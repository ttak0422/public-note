import { ImageResponse } from '@vercel/og';

export const config = {
  runtime: 'edge',
};

export default async function handler(request: Request) {
  const { searchParams } = new URL(request.url);
  const title = searchParams.get('title') || "tak's Note";
  const subtitle = searchParams.get('subtitle') || '';

  return new ImageResponse(
    (
      <div
        style={{
          height: '100%',
          width: '100%',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'flex-start',
          justifyContent: 'center',
          background: '#0b0b0f',
          color: '#f5f5f5',
          padding: '96px',
          gap: '32px',
          fontSize: 56,
          fontWeight: 700,
          fontFamily: 'Inter, sans-serif',
        }}
      >
        <div style={{ fontSize: 28, opacity: 0.7 }}>tak's Note</div>
        <div style={{ fontSize: 72, lineHeight: 1.05 }}>{title}</div>
        {subtitle ? (
          <div style={{ fontSize: 36, fontWeight: 500, opacity: 0.85 }}>{subtitle}</div>
        ) : null}
      </div>
    ),
    {
      width: 1200,
      height: 630,
    }
  );
}
