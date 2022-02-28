const owner = 'streamlink';
const repo = 'streamlink-twitch-gui';

module.exports = {
    latestRelease: async ({ github, context }) => {
        const release = await github.rest.repos.getLatestRelease({
            owner,
            repo,
        });

        return release.data.tag_name.replace('v','');
    },

    latestReleaseUrl: async({github, context}) => {
        const release = await github.rest.repos.getLatestRelease({
            owner,
            repo,
        });

        const asset = release.data.assets.filter((asset) => {
            return asset.name.endsWith('-win64.zip');
        });

        return asset[0].browser_download_url.replace('-win64.zip', '');
    }
};
