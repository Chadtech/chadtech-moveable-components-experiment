var app = Elm.Main.init({
	flags: {
		seed: Math.floor(Math.random() * Number.MAX_SAFE_INTEGER),
		windowSize: {
			width: window.innerWidth,
			height: window.innerHeight
		}
	}
});

// function toElm(type, payload) {
// 	app.ports.fromJs.send({
// 		type: type,
// 		payload: payload
// 	});
// }

// function square(n) {
// 	toElm("square computed", n * n);
// }

// var actions = {
// 	consoleLog: console.log,
// 	square: square
// }

// function jsMsgHandler(msg) {
// 	var action = actions[msg.type];
// 	if (typeof action === "undefined") {
// 		console.log("Unrecognized js msg type ->", msg.type);
// 		return;
// 	}
// 	action(msg.payload);
// }

// app.ports.toJs.subscribe(jsMsgHandler)

