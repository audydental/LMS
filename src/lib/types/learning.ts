export interface User {
  id: string;
  name: string;
  firstName: string;
  lastName: string;
  position: string;
  department: string;
  avatarUrl: string;
  email: string;
}

export interface Stage {
  id: string;
  sequence: number;
  title: string;
  subtitle: string;
  description: string;
  image: string;
  isActive: boolean;
  isCompleted: boolean;
  progress: number;
  totalMaterials: number;
  completedMaterials: number;
  pointReward: number;
  status: 'active' | 'inactive';
}

export interface PointData {
  current: number;
  target: number;
  weeklyGain: number;
  rank?: number;
}

export interface ScoreData {
  average: number;
  quizCompleted: number;
  totalQuizzes?: number;
}

export interface Level {
  name: 'Keep Growing' | 'Level Up' | 'Power Team';
  minScore: number;
  maxScore: number;
  color: string;
  bgColor: string;
  progress: number; // 0–100 within the level band
}

export interface PowerTeamData {
  teamName: string;
  memberCount: number;
  rank: number;
  points: number;
}

export type ActivityIntensity = 0 | 1 | 2 | 3;

export interface ActivityDay {
  date: Date;
  dayLabel: string;
  completed: number;
  total: number;
  intensity: ActivityIntensity;
}

export type ActivityType = 'module' | 'quiz' | 'practice';

export type Difficulty = 'beginner' | 'intermediate' | 'advanced';

export interface Recommendation {
  id: string;
  title: string;
  subtitle: string;
  category: string;
  durationMinutes: number;
  difficulty: Difficulty;
  thumbnailColor: string;
}

export interface FreshUpdate {
  id: string;
  title: string;
  subtitle: string;
  label: string;
  count: number;
  imageUrl?: string;
}

export type StageDisplayStatus = 'available' | 'in_progress' | 'completed' | 'locked';

export interface Material {
  id: string;
  stageId: string;
  title: string;
  description: string;
  estimatedMinutes: number;
  pointReward: number;
  sequence: number;
  status: 'available' | 'completed';
}

export interface LearningProgress {
  totalStages: number;
  completedStages: number;
  inProgressStages: number;
  totalMaterials: number;
  completedMaterials: number;
  overallProgressPct: number;
  totalPointsEarned: number;
  totalPointsAvailable: number;
}
