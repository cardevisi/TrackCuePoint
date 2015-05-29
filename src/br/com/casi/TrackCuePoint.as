package br.com.casi {

	import br.com.casi.events.TrackerEvent;
	import fl.video.FLVPlayback;
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	/**
	 * @author cardevisi
	 * 
	 * 	import br.com.casi.events.TrackerEvent;
	 * 	import br.com.casi.TrackCuePoint;
	 * 
	 *  var track:TrackCuePoint = new TrackCuePoint(this, flvPlayBack, func, true, playPauseButton, muteButton); 
	 *		track.addEventListener(TrackerEvent.CLICKED, handleMouseEvent);
	 *		function handleMouseEvent(e:TrackerEvent) {
	 *			if (e.data == "play_mc") {
	 *				playButton.visible = false;
	 *			} else if (e.data == "pause_mc") {
	 *				playButton.visible = true;
	 *			}
	 *		}
	 */
	 
	public class TrackCuePoint extends EventDispatcher {
		
		private var _func:String;
		private var _debug:Boolean;
		private var _referFlvPlayBack:FLVPlayback;
		private var _cuePoints:Array = ["25","50","75","100"];
		private var _duration:Number;
					
		public function TrackCuePoint(scope:*, flvPlayBack:FLVPlayback, duration:Number, func:String, debug:Boolean=false, playPauseButton:MovieClip=null, muteButton:MovieClip=null):void {
			_debug = debug;
			_referFlvPlayBack = flvPlayBack;
			_func = func;
			_duration = duration;
			
			_referFlvPlayBack.getVideoPlayer(_referFlvPlayBack.activeVideoPlayerIndex).smoothing  = true;
			_referFlvPlayBack.addEventListener(MetadataEvent.CUE_POINT, videoCpListener, false, 0, true);
			_referFlvPlayBack.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, playStateEntered, false, 0, true);
			_referFlvPlayBack.addEventListener(VideoEvent.PAUSED_STATE_ENTERED, pauseStateEntered, false, 0, true);
			
			if (playPauseButton) {
				playPauseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			
			if (muteButton) {
				muteButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}

			scope.addEventListener(MouseEvent.CLICK, handleMouseEvent, false, 0, true);
			
			createCuePoint(_cuePoints);

		}

		private function handleMouseEvent(e:MouseEvent) {
			if (e.target.name == "off_mc") {
				Tracer.call(_func, "unmute", _debug);
			} else if (e.target.name == "on_mc") {
				Tracer.call(_func, "mute", _debug);
			} else if (e.target.name == "play_mc") {
				dispatchEvent(new TrackerEvent(TrackerEvent.CLICKED, "play_mc"));
			} else if (e.target.name == "pause_mc") {
				dispatchEvent(new TrackerEvent(TrackerEvent.CLICKED, "pause_mc"));
			}
		}

		private function createCuePoint(data:Array):void {
			var cuePoint:Object;
			var arrInit:Array = [];
			
			if (!data && !data.length) {
				return;
			}
			
			var total:Number = _duration / data.length; 
			
			for( var i:int = 1; i <= data.length; i++ ) {
				var obj:Object = new Object();
					obj.time = i*total;
					obj.name = data[i-1];
					arrInit.push(obj);
			}
			
			if(_debug) showDebug(arrInit);
			
			for( var j:int = 0; j < arrInit.length; j++ ) {
				cuePoint = new Object();
				cuePoint.time = arrInit[j].time;
				cuePoint.name = arrInit[j].name;
				_referFlvPlayBack.addASCuePoint(cuePoint);
			}
			
		}
		
		private function showDebug(data:Array):void {
			for( var i:int = 0; i < data.length; i++ ) {
				trace("VIDEO CUEPOINT TIME:", data[i].time);
				trace("VIDEO TRACKER VALUE:", data[i].name);
				trace("-----------------------");
			}
		}

		private function videoCpListener(e:MetadataEvent):void {
			Tracer.call(_func, e.info.name, _debug);
		}
		
		private function playStateEntered(e:VideoEvent):void {
			Tracer.call(_func, "play_video", _debug);
		}
		
		private function pauseStateEntered(e:VideoEvent):void {
			Tracer.call(_func, "pause_video", _debug);
		}
			
	}
}
