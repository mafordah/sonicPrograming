n = NetAddr("127.0.0.1", 47120);

a = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/audience.wav");

(
SynthDef(\audience, {
	arg out = 0, bufnum = a, gate = 0;
	var rateMod = 1;

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
			rate: BufRateScale.kr(bufnum)*rateMod,
			loop: 1,
			doneAction: 0
		)
	);
}).add;
);


~audience = Synth(\audience);

(
~audience.set(\gate, 1);
n.sendMsg("/start", 1.0);
)


~audience.free;

