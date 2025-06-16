"use client";

import type { Post, User, Comment as CommentType } from "@/types";
import { Card, CardHeader, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Heart, MessageCircle, Share2, Send, Loader2 } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { UserAvatar } from "./user-avatar";
import { Badge } from "@/components/ui/badge";
import { formatDistanceToNow } from 'date-fns';
import React, { useState, useEffect, useCallback } from 'react';
import { MOCK_CURRENT_USER_ID, getCommentsForPost, addComment, getAppUser } from "@/lib/mock-data";
import { Input } from "@/components/ui/input";
import { Separator } from "@/components/ui/separator";
import { CommentListItem } from "./comment-list-item";
import { useToast } from "@/hooks/use-toast";

interface PostCardProps {
  post: Post;
  author?: User;
  onLikeToggle: (postId: string, liked: boolean) => void;
}

export function PostCard({ post, author, onLikeToggle }: PostCardProps) {
  const [isLikedByCurrentUser, setIsLikedByCurrentUser] = useState(false);
  const [likeCount, setLikeCount] = useState(post.likes.length);
  const [timeAgo, setTimeAgo] = useState('');
  const { toast } = useToast();

  const [showComments, setShowComments] = useState(false);
  const [postComments, setPostComments] = useState<CommentType[]>([]);
  const [commentAuthors, setCommentAuthors] = useState<Record<string, User | undefined>>({});
  const [newCommentContent, setNewCommentContent] = useState("");
  const [isSubmittingComment, setIsSubmittingComment] = useState(false);
  const [isLoadingComments, setIsLoadingComments] = useState(false);

  useEffect(() => {
    if (MOCK_CURRENT_USER_ID) {
      setIsLikedByCurrentUser(post.likes.includes(MOCK_CURRENT_USER_ID));
    } else {
      setIsLikedByCurrentUser(false);
    }
    setLikeCount(post.likes.length);
  }, [post.likes, MOCK_CURRENT_USER_ID]);

  useEffect(() => {
    if (post.createdAt) {
      setTimeAgo(formatDistanceToNow(new Date(post.createdAt), { addSuffix: true }));
      const interval = setInterval(() => {
        setTimeAgo(formatDistanceToNow(new Date(post.createdAt), { addSuffix: true }));
      }, 60000);
      return () => clearInterval(interval);
    }
  }, [post.createdAt]);

  const fetchCommentsAndAuthors = useCallback(async () => {
    if (!post.id) return;
    setIsLoadingComments(true);
    await new Promise(resolve => setTimeout(resolve, 200)); // Simulate delay
    const comments = getCommentsForPost(post.id);
    setPostComments(comments);

    const authorIds = new Set(comments.map(c => c.userId));
    const authors: Record<string, User | undefined> = {};
    authorIds.forEach(id => {
      authors[id] = getAppUser(id);
    });
    setCommentAuthors(authors);
    setIsLoadingComments(false);
  }, [post.id]);

  useEffect(() => {
    if (showComments) {
      fetchCommentsAndAuthors();
    }
  }, [showComments, fetchCommentsAndAuthors]);

  const handleLike = () => {
    if (!MOCK_CURRENT_USER_ID) {
      toast({ title: "Login Required", description: "Please log in to like posts.", variant: "destructive" });
      return;
    }
    const newLikedState = !isLikedByCurrentUser;
    setIsLikedByCurrentUser(newLikedState);
    setLikeCount(newLikedState ? likeCount + 1 : likeCount - 1);
    onLikeToggle(post.id, newLikedState);
  };

  const handleToggleComments = () => {
    setShowComments(!showComments);
  };

  const handleSharePost = async () => {
    // In a real app, you might generate a specific shareable link or use navigator.share if available.
    // For this mock, we'll copy a constructed URL to the clipboard.
    const postUrl = `${window.location.origin}/profile/${post.userId}/post/${post.id}`; // Example URL
    try {
      await navigator.clipboard.writeText(postUrl);
      toast({
        title: "Link Copied!",
        description: "Post link copied to clipboard.",
      });
    } catch (err) {
      console.error("Failed to copy link: ", err);
      toast({
        title: "Error",
        description: "Could not copy link to clipboard.",
        variant: "destructive",
      });
    }
  };

  const handlePostComment = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCommentContent.trim() || !MOCK_CURRENT_USER_ID) {
      if(!MOCK_CURRENT_USER_ID) toast({ title: "Login Required", description: "Please log in to comment.", variant: "destructive" });
      else toast({ title: "Cannot post empty comment", variant: "destructive" });
      return;
    }
    setIsSubmittingComment(true);
    await new Promise(resolve => setTimeout(resolve, 500)); // Simulate API delay

    const newComment = addComment(post.id, MOCK_CURRENT_USER_ID, newCommentContent);
    if (newComment) {
      setPostComments(prevComments => [newComment, ...prevComments]); // Add to top
       // Ensure new comment author is fetched if not already present
      if (!commentAuthors[newComment.userId]) {
        const newAuthor = getAppUser(newComment.userId);
        if (newAuthor) {
          setCommentAuthors(prev => ({...prev, [newAuthor.id]: newAuthor}));
        }
      }
      setNewCommentContent("");
      toast({ title: "Comment Posted!" });
    } else {
      toast({ title: "Error", description: "Could not post comment.", variant: "destructive" });
    }
    setIsSubmittingComment(false);
  };

  return (
    <Card className="w-full overflow-hidden shadow-md transition-shadow hover:shadow-lg">
      <CardHeader className="flex flex-row items-center gap-3 p-4">
        {author && <UserAvatar user={author} />}
        <div className="flex flex-col">
          <Link href={`/profile/${post.userId}`} className="font-semibold hover:underline font-headline">
            {author?.name || "Unknown User"}
          </Link>
          <p className="text-xs text-muted-foreground">{timeAgo}</p>
        </div>
      </CardHeader>
      <CardContent className="px-4 pb-2">
        <p className="text-sm whitespace-pre-wrap">{post.content}</p>
        {post.videoUrl ? (
          <div className="mt-3 relative aspect-video w-full overflow-hidden rounded-lg border">
            <video
              src={post.videoUrl}
              controls
              className="w-full h-full object-cover"
              aria-label={post.content.substring(0,100) || "User uploaded video"}
            />
          </div>
        ) : post.imageUrl ? (
          <div className="mt-3 relative aspect-video w-full overflow-hidden rounded-lg border">
            <Image
              src={post.imageUrl}
              alt={post.content.substring(0,100) || "Post image"}
              layout="fill"
              objectFit="cover"
              data-ai-hint="social media content"
              className="transition-transform duration-300 hover:scale-105"
            />
          </div>
        ) : null}
        {post.hashtags && post.hashtags.length > 0 && (
            <div className="mt-3 flex flex-wrap gap-2">
                {post.hashtags.map((tag) => (
                    <Badge key={tag} variant="secondary" className="cursor-pointer hover:bg-primary/10">
                        {tag}
                    </Badge>
                ))}
            </div>
        )}
      </CardContent>
      <CardFooter className="flex justify-start gap-2 p-4 border-t">
        <Button
          variant="ghost"
          size="sm"
          onClick={handleLike}
          aria-pressed={isLikedByCurrentUser}
          className="flex items-center gap-1 text-muted-foreground hover:text-primary"
          disabled={!MOCK_CURRENT_USER_ID} 
        >
          <Heart className={`w-4 h-4 ${isLikedByCurrentUser ? "fill-red-500 text-red-500" : ""}`} />
          <span>{likeCount} {likeCount === 1 ? 'Like' : 'Likes'}</span>
        </Button>
        <Button variant="ghost" size="sm" onClick={handleToggleComments} className="flex items-center gap-1 text-muted-foreground hover:text-primary">
          <MessageCircle className="w-4 h-4" />
          <span>{postComments.length > 0 ? `${postComments.length} ` : ''}Comment{postComments.length !== 1 ? 's' : ''}</span>
        </Button>
        <Button variant="ghost" size="sm" onClick={handleSharePost} className="flex items-center gap-1 text-muted-foreground hover:text-primary">
          <Share2 className="w-4 h-4" />
          <span>Share</span>
        </Button>
      </CardFooter>

      {showComments && (
        <div className="px-4 pb-4 border-t">
          <form onSubmit={handlePostComment} className="flex items-center gap-2 py-3">
            {MOCK_CURRENT_USER_ID && getAppUser(MOCK_CURRENT_USER_ID) && (
                 <UserAvatar user={getAppUser(MOCK_CURRENT_USER_ID)!} className="h-8 w-8 shrink-0" />
            )}
            <Input
              type="text"
              placeholder="Write a comment..."
              value={newCommentContent}
              onChange={(e) => setNewCommentContent(e.target.value)}
              className="flex-grow h-9 text-sm"
              disabled={isSubmittingComment || !MOCK_CURRENT_USER_ID}
              aria-label="Write a comment"
            />
            <Button type="submit" size="sm" disabled={isSubmittingComment || !newCommentContent.trim() || !MOCK_CURRENT_USER_ID}>
              {isSubmittingComment ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
              <span className="ml-1 sr-only sm:not-sr-only">Post</span>
            </Button>
          </form>
          <Separator className="my-2"/>
          {isLoadingComments ? (
             <div className="space-y-3 py-2">
                {[1,2].map(i => (
                    <div key={i} className="flex items-start gap-3">
                        <div className="h-8 w-8 bg-muted rounded-full shrink-0 animate-pulse"></div>
                        <div className="flex-grow space-y-1.5">
                            <div className="h-3 w-24 bg-muted rounded animate-pulse"></div>
                            <div className="h-3 w-48 bg-muted rounded animate-pulse"></div>
                        </div>
                    </div>
                ))}
             </div>
          ) : postComments.length > 0 ? (
            <div className="max-h-60 overflow-y-auto pr-2 -mr-2">
              {postComments.map((comment) => (
                <CommentListItem key={comment.id} comment={comment} author={commentAuthors[comment.userId]} />
              ))}
            </div>
          ) : (
            <p className="text-sm text-muted-foreground text-center py-4">No comments yet. Be the first to comment!</p>
          )}
        </div>
      )}
    </Card>
  );
}

