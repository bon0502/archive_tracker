window.addEventListener('beforeunload', () => {
  const archiveId = document.querySelector('[data-archive-id]')?.dataset.archiveId;
  if (!archiveId) return;

  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  const video = document.querySelector('video');
  const currentPosition = video ? Math.floor(video.currentTime) : null;

  if (currentPosition === null) return;

  const formData = new FormData();
  formData.append('authenticity_token', csrfToken);
  formData.append('viewing_position[current_position_seconds]', currentPosition);

  navigator.sendBeacon(`/archives/${archiveId}/viewing_position`, formData);
});
