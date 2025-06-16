export interface User {
  id: string;
  username: string;
  name: string;
  avatarUrl: string; 
  email: string;
  mobileNumber?: string;
  bio?: string;
  followers: string[]; 
  following: string[]; 
  pendingFollowRequestsSent: string[]; 
  pendingFollowRequestsReceived: string[]; 
  referralCode?: string;
  referralsMade?: number;
}

export interface Post {
  id: string;
  userId: string;
  content: string;
  imageUrl?: string;
  videoUrl?: string;
  likes: string[]; 
  createdAt: string; 
  hashtags?: string[];
  // No direct comments array here to keep mock data simpler; will be fetched.
}

export interface Comment {
  id: string;
  postId: string;
  userId: string;
  content: string;
  createdAt: string; // ISO date string
}

export interface Message {
  id: string;
  conversationId: string;
  senderId: string;
  receiverId: string;
  content: string;
  createdAt: string; 
  isReadBy: string[]; 
}

export interface Conversation {
  id: string; 
  participantIds: [string, string];
  lastMessage?: Pick<Message, 'content' | 'createdAt' | 'senderId'>;
  updatedAt: string; 
}
