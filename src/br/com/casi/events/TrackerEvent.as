package br.com.casi.events {
	
	import flash.events.Event;
    
    /**
     * @author cardevisi
     */


    public class TrackerEvent extends Event {

        public static var CLICKED:String = "clicked";

        private var _params:String;
        
        public function get data():String { 
            return _params; 
        }

        public function TrackerEvent (type:String, data:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type,bubbles,cancelable);
            _params = data;
        }

        override public function clone():Event {
            return new TrackerEvent(type, data, bubbles, cancelable);
        }
    }

}