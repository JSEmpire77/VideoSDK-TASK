import ws from "k6/ws";
import { check } from "k6";

export const options = {
  vus: 50,          // number of virtual users
  duration: "30s",  // how long the test should run (you can adjust)
};

export default function () {
  const url = "ws://localhost:8080/";   // change if using NodePort instead of port-forward

  const res = ws.connect(url, {}, function (socket) {
    socket.on("open", function () {
      console.log("Connected");
      socket.send("Hello server");
    });

    socket.on("message", function (message) {
      console.log("Received message:", message);
    });

    socket.on("close", () => console.log("Disconnected"));

    socket.setTimeout(() => socket.close(), 3000);
  });

  check(res, { "status is 101": (r) => r && r.status === 101 });
}