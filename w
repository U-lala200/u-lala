import type { User, Post, Message, Conversation, Comment } from '@/types';

// --- Current User Management (Simulated Auth) ---
let initialUserId: string | null = null;
if (typeof window !== 'undefined') {
  initialUserId = localStorage.getItem('chirpspace_currentUserId');
}
export let MOCK_CURRENT_USER_ID: string | null = initialUserId;

export const getMockCurrentUser = (): User | undefined => {
  if (!MOCK_CURRENT_USER_ID) return undefined;
  const user = users.find(u => u.id === MOCK_CURRENT_USER_ID);
  return user ? { ...user } : undefined; 
};

export const setMockCurrentUser = (userId: string | null) => {
  MOCK_CURRENT_USER_ID = userId;
  if (typeof window !== 'undefined') {
    if (userId) {
      localStorage.setItem('chirpspace_currentUserId', userId);
    } else {
      localStorage.removeItem('chirpspace_currentUserId');
    }
  }
};

// --- Mock Data Arrays ---
export let users: User[] = [
  {
    id: 'user1',
    username: 'alexdoe',
    name: 'Alex Doe',
    email: 'alex.doe@example.com',
    mobileNumber: '+15551234567',
    avatarUrl: 'https://placehold.co/100x100.png?text=AD',
    bio: 'Lover of code, coffee, and cats. Building the future, one line at a time. 🚀',
    followers: ['user2', 'user3'],
    following: ['user2', 'user3', 'user4'],
    pendingFollowRequestsSent: [],
    pendingFollowRequestsReceived: [],
    referralCode: 'ALEXDOE_REF763',
    referralsMade: 5,
  },
  {
    id: 'user2',
    username: 'janesmith',
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    mobileNumber: '+15559876543',
    avatarUrl: 'https://placehold.co/100x100.png?text=JS',
    bio: 'Exploring the world and sharing my adventures. Foodie, traveler, photographer. 🌍🍜📸',
    followers: ['user1', 'user4'],
    following: ['user1'],
    pendingFollowRequestsSent: [],
    pendingFollowRequestsReceived: ['user3'],
    referralCode: 'JANESMITH_REF294',
    referralsMade: 2,
  },
  {
    id: 'user3',
    username: 'bobdev',
    name: 'Bob The Developer',
    email: 'bob.dev@example.com',
    avatarUrl: 'https://placehold.co/100x100.png?text=BD',
    bio: 'Frontend wizard. Making the web beautiful and accessible. ✨',
    followers: ['user1'],
    following: ['user1', 'user4'],
    pendingFollowRequestsSent: ['user2'],
    pendingFollowRequestsReceived: [],
    referralCode: 'BOBDEV_REF510',
    referralsMade: 10,
  },
  {
    id: 'user4',
    username: 'creativecarla',
    name: 'Creative Carla',
    email: 'carla.creative@example.com',
    mobileNumber: '+15552223333',
    avatarUrl: 'https://placehold.co/100x100.png?text=CC',
    bio: 'Art, design, and all things creative. Living life in full color. 🎨',
    followers: ['user3', 'user1'],
    following: ['user2', 'user3'],
    pendingFollowRequestsSent: [],
    pendingFollowRequestsReceived: [],
    referralCode: 'CREATIVECARLA_REF872',
    referralsMade: 1,
  },
];

export let posts: Post[] = [
  {
    id: 'post1',
    userId: 'user1',
    content: "Just enjoyed a fantastic cup of coffee at this new cafe! Highly recommend. What's your favorite coffee spot? ☕️ #coffee #cafe #morningvibes",
    imageUrl: 'https://placehold.co/600x400.png',
    likes: ['user2', 'user3'],
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(),
    hashtags: ['#coffee', '#cafe', '#morningvibes'],
  },
  {
    id: 'post2',
    userId: 'user2',
    content: "Throwback to my trip to the mountains last summer. The views were breathtaking! Can't wait for my next adventure. 🏞️ This is a video of the scenery! #travel #mountains #adventure #nature #video",
    videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    likes: ['user1', 'user4'],
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24).toISOString(),
    hashtags: ['#travel', '#mountains', '#adventure', '#nature', '#video'],
  },
  {
    id: 'post3',
    userId: 'user1',
    content: 'Working on a new exciting Next.js project! The new App Router is a game changer. #webdev #nextjs #coding #react',
    likes: ['user3', 'user4', 'user2'],
    createdAt: new Date(Date.now() - 1000 * 60 * 30).toISOString(),
    hashtags: ['#webdev', '#nextjs', '#coding', '#react'],
  },
];

export let messages: Message[] = [
    { id: 'msg1', conversationId: 'user1_user2', senderId: 'user1', receiverId: 'user2', content: 'Hey Jane, how are you?', createdAt: new Date(Date.now() - 1000 * 60 * 60 * 3).toISOString(), isReadBy: ['user1'] },
    { id: 'msg2', conversationId: 'user1_user2', senderId: 'user2', receiverId: 'user1', content: 'Hi Alex! Doing great, thanks! You?', createdAt: new Date(Date.now() - 1000 * 60 * 60 * 2.5).toISOString(), isReadBy: ['user2'] },
    { id: 'msg3', conversationId: 'user1_user2', senderId: 'user1', receiverId: 'user2', content: 'Good too! Working on that new project.', createdAt: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(), isReadBy: ['user1'] },
    { id: 'msg4', conversationId: 'user1_user3', senderId: 'user3', receiverId: 'user1', content: 'Alex, need your help with a bug.', createdAt: new Date(Date.now() - 1000 * 60 * 30).toISOString(), isReadBy: ['user3'] },
];

export let conversations: Conversation[] = [
    {
        id: 'user1_user2', 
        participantIds: ['user1', 'user2'],
        lastMessage: { content: 'Good too! Working on that new project.', createdAt: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(), senderId: 'user1' },
        updatedAt: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(),
    },
    {
        id: 'user1_user3', 
        participantIds: ['user1', 'user3'],
        lastMessage: { content: 'Alex, need your help with a bug.', createdAt: new Date(Date.now() - 1000 * 60 * 30).toISOString(), senderId: 'user3' },
        updatedAt: new Date(Date.now() - 1000 * 60 * 30).toISOString(),
    }
];

export let comments: Comment[] = [
  { id: 'comment1', postId: 'post1', userId: 'user2', content: 'Looks delicious! I should try that cafe.', createdAt: new Date(Date.now() - 1000 * 60 * 60 * 1.5).toISOString() },
  { id: 'comment2', postId: 'post1', userId: 'user3', content: 'Nice! I love a good coffee recommendation.', createdAt: new Date(Date.now() - 1000 * 60 * 50).toISOString() },
  { id: 'comment3', postId: 'post3', userId: 'user4', content: 'Awesome! Keep us updated on the project.', createdAt: new Date(Date.now() - 1000 * 60 * 10).toISOString() },
];

// --- User Data Functions ---
export const getAppUser = (userId: string): User | undefined => {
  const user = users.find(u => u.id === userId);
  return user ? { ...user } : undefined; 
};

export const addUser = (newUser: User, enteredReferralCode?: string): boolean => {
  if (users.some(u => u.id === newUser.id || u.username.toLowerCase() === newUser.username.toLowerCase() || u.email.toLowerCase() === newUser.email.toLowerCase())) {
    return false; 
  }
  users.unshift(newUser); 

  if (enteredReferralCode) {
    const referringUserIndex = users.findIndex(u => u.referralCode === enteredReferralCode && u.id !== newUser.id);
    if (referringUserIndex !== -1) {
      users[referringUserIndex].referralsMade = (users[referringUserIndex].referralsMade || 0) + 1;
    }
  }
  return true;
};

export const updateAppUser = (userId: string, updatedData: Partial<Pick<User, 'name' | 'username' | 'avatarUrl' | 'bio'>>): User | undefined => {
  const userIndex = users.findIndex(u => u.id === userId);
  if (userIndex !== -1) {
    const currentUserData = users[userIndex];
    const newName = updatedData.name || currentUserData.name;

    let finalAvatarUrl = currentUserData.avatarUrl; 

    if (updatedData.avatarUrl !== undefined) { 
      if (updatedData.avatarUrl && updatedData.avatarUrl.startsWith('data:image')) {
        finalAvatarUrl = updatedData.avatarUrl;
      } else if (updatedData.avatarUrl && updatedData.avatarUrl.startsWith('https://placehold.co')) {
        finalAvatarUrl = updatedData.avatarUrl;
      } else if (!updatedData.avatarUrl) {
        finalAvatarUrl = `https://placehold.co/100x100.png?text=${newName.substring(0,2).toUpperCase()}`;
      } else {
         finalAvatarUrl = updatedData.avatarUrl;
      }
    } else if (updatedData.name && (currentUserData.avatarUrl.startsWith('https://placehold.co') || !currentUserData.avatarUrl)) {
      finalAvatarUrl = `https://placehold.co/100x100.png?text=${newName.substring(0,2).toUpperCase()}`;
    }
    
    users[userIndex] = {
      ...currentUserData, 
      ...updatedData,    
      name: newName,       
      avatarUrl: finalAvatarUrl, 
    };
    return { ...users[userIndex] }; 
  }
  return undefined;
};


// --- Post Data Functions ---
export const getAppPosts = (userId?: string): Post[] => {
  const filteredPosts = userId ? posts.filter(p => p.userId === userId) : [...posts];
  return filteredPosts.map(p => ({...p})).sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
};

// --- Comment Data Functions ---
export const getCommentsForPost = (postId: string): Comment[] => {
  return comments
    .filter(c => c.postId === postId)
    .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
    .map(c => ({...c})); // Return copies
};

export const addComment = (postId: string, userId: string, content: string): Comment | undefined => {
  if (!content.trim() || !userId) return undefined;
  const newComment: Comment = {
    id: `comment${Date.now()}${Math.random().toString(36).substring(2, 7)}`,
    postId,
    userId,
    content,
    createdAt: new Date().toISOString(),
  };
  comments.push(newComment);
  return { ...newComment }; // Return a copy
};


// --- Follow/Request Logic ---
export const sendFollowRequest = (senderId: string, receiverId: string): boolean => {
  const senderIndex = users.findIndex(u => u.id === senderId);
  const receiverIndex = users.findIndex(u => u.id === receiverId);

  if (senderIndex === -1 || receiverIndex === -1 || senderId === receiverId) return false;

  const sender = users[senderIndex];
  const receiver = users[receiverIndex];

  if (sender.following.includes(receiverId) ||
      sender.pendingFollowRequestsSent.includes(receiverId) ||
      receiver.pendingFollowRequestsSent.includes(senderId)) {
    return false;
  }

  users[senderIndex] = { ...sender, pendingFollowRequestsSent: [...sender.pendingFollowRequestsSent, receiverId] };
  users[receiverIndex] = { ...receiver, pendingFollowRequestsReceived: [...receiver.pendingFollowRequestsReceived, senderId] };
  return true;
};

export const cancelFollowRequest = (senderId: string, receiverId: string): boolean => {
  const senderIndex = users.findIndex(u => u.id === senderId);
  const receiverIndex = users.findIndex(u => u.id === receiverId);

  if (senderIndex === -1 || receiverIndex === -1) return false;

  const sender = users[senderIndex];
  const receiver = users[receiverIndex];

  if (!sender.pendingFollowRequestsSent.includes(receiverId) || !receiver.pendingFollowRequestsReceived.includes(senderId)) {
      return false;
  }

  users[senderIndex] = { ...sender, pendingFollowRequestsSent: sender.pendingFollowRequestsSent.filter(id => id !== receiverId) };
  users[receiverIndex] = { ...receiver, pendingFollowRequestsReceived: receiver.pendingFollowRequestsReceived.filter(id => id !== senderId) };
  return true;
};

export const acceptFollowRequest = (accepterId: string, requesterId: string): boolean => {
  const accepterIndex = users.findIndex(u => u.id === accepterId);
  const requesterIndex = users.findIndex(u => u.id === requesterId);

  if (accepterIndex === -1 || requesterIndex === -1) return false;

  let accepter = users[accepterIndex];
  let requester = users[requesterIndex];

  if (!accepter.pendingFollowRequestsReceived.includes(requesterId) || !requester.pendingFollowRequestsSent.includes(accepterId)) return false;

  accepter = {
    ...accepter,
    pendingFollowRequestsReceived: accepter.pendingFollowRequestsReceived.filter(id => id !== requesterId),
    followers: accepter.followers.includes(requesterId) ? accepter.followers : [...accepter.followers, requesterId]
  };

  requester = {
    ...requester,
    pendingFollowRequestsSent: requester.pendingFollowRequestsSent.filter(id => id !== accepterId),
    following: requester.following.includes(accepterId) ? requester.following : [...requester.following, accepterId]
  };

  users[accepterIndex] = accepter;
  users[requesterIndex] = requester;
  return true;
};

export const declineFollowRequest = (declinerId: string, requesterId: string): boolean => {
  const declinerIndex = users.findIndex(u => u.id === declinerId);
  const requesterIndex = users.findIndex(u => u.id === requesterId);

  if (declinerIndex === -1 || requesterIndex === -1) return false;

  let decliner = users[declinerIndex];
  let requester = users[requesterIndex];

  if (!decliner.pendingFollowRequestsReceived.includes(requesterId) || !requester.pendingFollowRequestsSent.includes(declinerId)) {
    return false;
  }

  users[declinerIndex] = {
    ...decliner,
    pendingFollowRequestsReceived: decliner.pendingFollowRequestsReceived.filter(id => id !== requesterId)
  };
  users[requesterIndex] = {
    ...requester,
    pendingFollowRequestsSent: requester.pendingFollowRequestsSent.filter(id => id !== declinerId)
  };
  return true;
};

export const unfollowUser = (unfollowerId: string, unfollowedId: string): boolean => {
  const unfollowerIndex = users.findIndex(u => u.id === unfollowerId);
  const unfollowedIndex = users.findIndex(u => u.id === unfollowedId);

  if (unfollowerIndex === -1 || unfollowedIndex === -1) return false;

  let unfollower = users[unfollowerIndex];
  let unfollowed = users[unfollowedIndex];

  if (!unfollower.following.includes(unfollowedId) || !unfollowed.followers.includes(unfollowerId)) {
      return false;
  }

  users[unfollowerIndex] = { ...unfollower, following: unfollower.following.filter(id => id !== unfollowedId) };
  users[unfollowedIndex] = { ...unfollowed, followers: unfollowed.followers.filter(id => id !== unfollowerId) };
  return true;
};

// --- Messaging System Functions ---
export const getConversationId = (userId1: string, userId2: string): string => {
  return [userId1, userId2].sort().join('_');
};

export const getOrCreateConversation = (currentUserIdParam: string, otherUserId: string): Conversation => {
  const conversationId = getConversationId(currentUserIdParam, otherUserId);
  let conversation = conversations.find(c => c.id === conversationId);

  if (!conversation) {
    conversation = {
      id: conversationId,
      participantIds: [currentUserIdParam, otherUserId].sort() as [string, string],
      updatedAt: new Date().toISOString(),
    };
    conversations.push(conversation);
  }
  return { ...conversation }; 
};

export const sendMessage = (senderId: string, receiverId: string, content: string): Message | undefined => {
  if (!content.trim()) return undefined;
  if (!MOCK_CURRENT_USER_ID) return undefined; 

  const conversationId = getConversationId(senderId, receiverId);
  const conversationIndex = conversations.findIndex(c => c.id === conversationId);

  const newMessage: Message = {
    id: `msg${Date.now()}${Math.random().toString(36).substring(2, 7)}`,
    conversationId,
    senderId,
    receiverId,
    content,
    createdAt: new Date().toISOString(),
    isReadBy: [senderId], 
  };
  messages.push(newMessage);

  if (conversationIndex !== -1) {
    conversations[conversationIndex] = {
      ...conversations[conversationIndex],
      lastMessage: { content: newMessage.content, createdAt: newMessage.createdAt, senderId: newMessage.senderId },
      updatedAt: newMessage.createdAt,
    };
  } else {
    const newConversation: Conversation = {
      id: conversationId,
      participantIds: [senderId, receiverId].sort() as [string, string],
      lastMessage: { content: newMessage.content, createdAt: newMessage.createdAt, senderId: newMessage.senderId },
      updatedAt: newMessage.createdAt,
    };
    conversations.push(newConversation);
  }

  return { ...newMessage }; 
};

export const getConversationsForUser = (userId: string): Conversation[] => {
  if (!userId) return [];
  return conversations
    .filter(c => c.participantIds.includes(userId))
    .sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());
};

export const getMessagesForConversation = (conversationId: string, viewingUserId: string | null): Message[] => {
  const conversationMessages = messages
    .filter(m => m.conversationId === conversationId)
    .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());

  if (viewingUserId && viewingUserId !== "SKIP_MARKING_READ_TEMP_USER_ID_HACK") {
    conversationMessages.forEach(msg => {
      if (msg.senderId !== viewingUserId && !msg.isReadBy.includes(viewingUserId)) {
        const originalMessageIndex = messages.findIndex(originalMsg => originalMsg.id === msg.id);
        if (originalMessageIndex !== -1) {
          messages[originalMessageIndex].isReadBy.push(viewingUserId);
        }
      }
    });
  }
  return conversationMessages.map(m => ({...m}));
};
