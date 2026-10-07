/**
 * Returns a time-appropriate Indonesian greeting with the user's first name.
 *
 *  0–9h   → Selamat pagi
 * 10–13h  → Selamat siang
 * 14–17h  → Selamat sore
 * 18–23h  → Selamat malam
 */
export function getGreeting(firstName: string): string {
  const hour = new Date().getHours();

  let salutation: string;

  if (hour >= 0 && hour <= 9) {
    salutation = 'Selamat pagi';
  } else if (hour >= 10 && hour <= 13) {
    salutation = 'Selamat siang';
  } else if (hour >= 14 && hour <= 17) {
    salutation = 'Selamat sore';
  } else {
    salutation = 'Selamat malam';
  }

  return `${salutation}, ${firstName} 👋`;
}
