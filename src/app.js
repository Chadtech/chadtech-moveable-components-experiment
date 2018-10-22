var app = Elm.Main.init({
	flags: {
		seed: Math.floor(Math.random() * Number.MAX_SAFE_INTEGER),
		windowSize: {
			width: window.innerWidth,
			height: window.innerHeight
		},
		model: getStoredModel()
	}
});

function getStoredModel() {
	var modelStr = localStorage.getItem("model");
	if (modelStr === null) {
		return null;
	} else {
		return JSON.parse(modelStr);
	}
}

function toElm(type, payload) {
	app.ports.fromJs.send({
		type: type,
		payload: payload
	});
}

function saveModel(model) {
	localStorage.setItem("model", JSON.stringify(model))
}

var actions = {
	saveModel
}

function jsMsgHandler(msg) {
	var action = actions[msg.type];
	if (typeof action === "undefined") {
		console.log("Unrecognized js msg type ->", msg.type);
		return;
	}
	action(msg.payload);
}

app.ports.toJs.subscribe(jsMsgHandler)

