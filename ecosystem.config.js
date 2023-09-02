module.exports = {
  apps: [
    {
      name: "vt-backend-pw2",
      script: "script/rails",
      args: "server -b 0.0.0.0 -p 3000",
      interpreter: "bundle",
    },
  ],
};
