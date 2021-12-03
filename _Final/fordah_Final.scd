n = NetAddr("127.0.0.1", 47120);

a = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/audience.wav");
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/newIntro.wav");

(
SynthDef(\audience, {
	arg out = 0, bufnum = 0, gate = 0, ampGate = 0;
	var rateMod = 1, amp = 1, fadeIn;

	fadeIn = EnvGen.kr(
		Env.new(
			levels: [0, 1],
			times: [5],
			curve: 2,
		),
	);

	amp = EnvGen.kr(
		Env.new(
			levels: [1, 0.5, 0.1, 0],
			times: [3, 5, 4],
			curve: 2,
		),
		gate: ampGate;
	);

	rateMod = EnvGen.kr(
		Env.new(
			levels: [1, 0.5, 0.1],
			times: [1, 3],
			curve: 2,
		),
		gate: gate;
	);

	Out.ar(out,
		PlayBuf.ar(
			numChannels: 2,
			bufnum: bufnum,
			rate: BufRateScale.kr(bufnum) * rateMod,
			loop: 1,
			doneAction: 0
		) * amp * fadeIn;
	);
}).play;


SynthDef(\intro, {
	arg out = 0, bufnum = 1, gate = 0, loop = 1, amp = 1, rateMod = 1;

	amp = EnvGen.kr(
		Env.new(
			levels: [1, 0.5, 0.1, 0],
			times: [10, 5, 4],
			curve: 2,
		),
		gate: gate;
	);

	Out.ar(out,
		PlayBuf.ar(
			numChannels: 2,
			bufnum: bufnum,
			rate: BufRateScale.kr(bufnum) * rateMod,
			loop: loop,
			doneAction: 0
		) * amp;
	);
}).add;

(
SynthDef(\burst, {
	arg outBus = 0, freq = 440, amp = 0.2, pos = 0, atk = 0.0, sus = 0.3, rel = 0.0;
	var sig, env;

	sig = WhiteNoise.ar();
	env = EnvGen.kr(Env.linen(atk, sus, rel, amp), doneAction: 2);
	sig = Pan2.ar(sig * env, pos);

	Out.ar(outBus, sig);
}).add;
)
);






~audience = Synth(\audience);

(
~nightmare = Task({
	10.wait;

	Synth(\burst);
	n.sendMsg("/start", 1.0);
	0.3.wait;
	n.sendMsg("/start", 0.0);
	wait(rrand(2, 7));

	Synth(\burst);
	n.sendMsg("/start", 2.0);
	0.3.wait;
	n.sendMsg("/start", 0.0);
	wait(rrand(10, 20));

	Synth(\burst);
	n.sendMsg("/start", 2.0);
	~audience.set(\gate, 1);
	0.5.wait;
	n.sendMsg("/start", 3.0);
	5.wait;
	n.sendMsg("/start", 4.0);
	~intro = Synth(\intro);
	18.wait;
	~intro.set(\gate, 1);
	20.wait;
	n.sendMsg("/face", 1.0);
	10.wait;
	n.sendMsg("/face", 1.0);
	3.wait;
	n.sendMsg("/face", 1.0);
	40.wait;
	~intro = Synth(\intro, [\rateMod, -1]);
	n.sendMsg("/face", 2.0);
	3.wait;
	~intro.set(\rateMod, 0.5);
	2.wait;
	~intro.set(\rateMod, -0.5);
	1.5.wait;
	~intro.set(\rateMod, -1);
	8.wait;
	~intro.set(\rateMod, 0.75);
	2.wait;
	~intro.set(\rateMod, -0.1);
	4.wait;
	~intro.free;
	Synth(\burst);
	n.sendMsg("/face", 2.0);
	n.sendMsg("/start", 5.0);
	1.wait;
	n.sendMsg("/start", 4.0);
	7.wait;

	Synth(\burst);
	n.sendMsg("/face", 2.0);
	n.sendMsg("/start", 5.0);
	1.wait;
	n.sendMsg("/start", 4.0);
	3.wait;

	Synth(\burst);
	n.sendMsg("/face", 0.0);
	n.sendMsg("/start", 5.0);

	30.wait;
	~audience.set(\ampGate, 1);
	n.sendMsg("/start", 6.0);
	15.wait;
	~audience = Synth(\audience);
}).play;
)

// (
// ~audience.set(\gate, 1);
// n.sendMsg("/start", 3.0);
// )
//
//
// ~audience.free;