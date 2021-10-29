s.boot;

n = NetAddr("127.0.0.1", 47120);




(
//Declarations
~speed = 2.0;
~beatSpace = 0.3;

//Heart
(
SynthDef(\Heart, {
	arg freq = 50;
	var envDef, env, sig;

	envDef = Env.new(
		[0, 1, 0],
		[0.05, 1, 1],
		[1, -50]
	);

	env = EnvGen.kr(envDef, doneAction: 2);
	sig = SinOsc.ar(freq: freq) * env;

	sig = Pan2.ar(sig, 0, 0.5);

	Out.ar(0, sig);

}).add;
);

//Bell
(
SynthDef(\Bell, {
	arg freq = 400;
	var envDef, env, sig;

	envDef = Env.new(
		[0, 1, 0],
		[0.05, 2, 1],
		[10, -10]
	);

	env = EnvGen.kr(envDef, doneAction: 2);
	sig = SinOsc.ar(freq: freq) * env;

	sig = Pan2.ar(sig, 0, 0.2);

	Out.ar(0, sig);

}).add;
);

//Ring
(
SynthDef(\Ring, {
	arg freq = 6000;
	var envDef, env, sig;

	envDef = Env.new(
		[0, 1, 0],
		[0.05, 10, 10],
		[1, -1]
  );

	env = EnvGen.kr(envDef, doneAction: 2);
	sig = SinOsc.ar(freq: freq) * env;

	sig = Pan2.ar(sig, 0, 0.1);

	Out.ar(0, sig);

}).add;
);


//Noise
(
SynthDef(\Noise, {
	var sig;

	sig = PinkNoise.ar(0.05);

	sig = Pan2.ar(sig, 0, 0.1);

	Out.ar(0, sig);

}).add;
);



//Task
~heartbeat = Task({
	Synth(\Noise);
	10.wait;
	{

		n.sendMsg("/heart", 1.0);

		Synth(\Heart);
		~beatSpace.wait;
		Synth(\Heart);
		n.sendMsg("/heart", 0.0);
		~speed.wait;

		n.sendMsg("/heart", 1.0);

		Synth(\Heart);
		~beatSpace.wait;
		Synth(\Heart);
		n.sendMsg("/heart", 0.0);
		~speed.wait;

		//if statement saves speed on fastest
		if ( ~speed <= 0.4,

			{ // true function
				~speed = 0.4;
				n.sendMsg("/heart", 0.0);
				Synth(\Ring);
				//Synth(\Noise);

				~bells.stop;
				~heartbeat.stop;

			},
			{ // false function
				~speed = ~speed - 0.05;
				~beatSpace = ~beatSpace - 0.004;
			}
    );

		//~speed.postln;
		//~beatSpace.postln;

	}.loop;
}).play;

~bells = Task({
	20.wait;
	{
		var freq, delta;
		freq = rrand(5000, 8000);
		delta = [0.5, 1, 3, 5].choose;

		n.sendMsg("/bell", 1.0);

		Synth(\Bell, [freq: freq]);

		delta.wait;
	}.loop;
}).play;
)
