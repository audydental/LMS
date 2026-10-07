import type { Stage, Material, LearningProgress } from '#lib/types/learning';
import { mockStages } from '#lib/mocks/stages';
import { mockMaterials } from '#lib/mocks/materials';

export async function getStages(): Promise<Stage[]> {
  await new Promise<void>((r) => setTimeout(r, 200));
  return mockStages.filter((s) => s.status === 'active').sort((a, b) => a.sequence - b.sequence);
}

export async function getStageById(stageId: string): Promise<Stage | null> {
  await new Promise<void>((r) => setTimeout(r, 100));
  return mockStages.find((s) => s.id === stageId) ?? null;
}

export async function getMaterialsByStage(stageId: string): Promise<Material[]> {
  await new Promise<void>((r) => setTimeout(r, 150));
  return mockMaterials.filter((m) => m.stageId === stageId).sort((a, b) => a.sequence - b.sequence);
}

export async function getLearningProgress(): Promise<LearningProgress> {
  await new Promise<void>((r) => setTimeout(r, 200));
  const activeStages = mockStages.filter((s) => s.status === 'active');
  const totalMaterials = mockMaterials.length;
  const completedMaterials = mockMaterials.filter((m) => m.status === 'completed').length;
  const completedStages = activeStages.filter((s) => s.isCompleted).length;
  const inProgressStages = activeStages.filter((s) => s.isActive && !s.isCompleted).length;
  const totalPointsAvailable = activeStages.reduce((sum, s) => sum + s.pointReward, 0);
  const totalPointsEarned = activeStages
    .filter((s) => s.isCompleted)
    .reduce((sum, s) => sum + s.pointReward, 0);

  return {
    totalStages: activeStages.length,
    completedStages,
    inProgressStages,
    totalMaterials,
    completedMaterials,
    overallProgressPct:
      totalMaterials > 0 ? Math.round((completedMaterials / totalMaterials) * 100) : 0,
    totalPointsEarned,
    totalPointsAvailable,
  };
}
