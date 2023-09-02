module.exports = {
  apps: [
    {
      name: "vt-backend-pw2",
      script: "bin/rails",
      args: "server -b 0.0.0.0 -p 3000",
      interpreter: "bundle",
    },
  ],
};
