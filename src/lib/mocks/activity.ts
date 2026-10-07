import type { ActivityDay, ActivityIntensity } from '#lib/types/learning';

/**
 * Compute the current week (Mon–Sun) at module-load time.
 * Each entry's date and dayLabel always corresponds to the actual current week.
 */
function buildCurrentWeek(): ActivityDay[] {
  const indonesianDayLabels: string[] = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  // JS: 0=Sun, 1=Mon … 6=Sat. We want Monday as day 0 of the week.
  const jsDayOfWeek = today.getDay(); // 0=Sun … 6=Sat
  const mondayOffset = jsDayOfWeek === 0 ? -6 : 1 - jsDayOfWeek;

  const monday = new Date(today);
  monday.setDate(today.getDate() + mondayOffset);

  // Days of week ordered Mon–Sun (index 0=Mon … 6=Sun)
  const weekOrder: number[] = [1, 2, 3, 4, 5, 6, 0]; // JS day numbers

  return weekOrder.map((jsDayNum, index) => {
    const date = new Date(monday);
    date.setDate(monday.getDate() + index);

    const isToday = date.getTime() === today.getTime();
    const isPast = date.getTime() < today.getTime();

    let completed = 0;
    let intensity: ActivityIntensity = 0;

    if (isPast) {
      // Three past weekdays (Mon, Tue, Wed-ish) get completed activity
      if (index < 3) {
        completed = 2;
        intensity = 2;
      } else {
        completed = 0;
        intensity = 0;
      }
    } else if (isToday) {
      completed = 1;
      intensity = 1;
    }

    return {
      date,
      dayLabel: indonesianDayLabels[jsDayNum],
      completed,
      total: 3,
      intensity
    };
  });
}

export const mockWeeklyActivity: ActivityDay[] = buildCurrentWeek();
