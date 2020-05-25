class CTrackBar
{
	private var m_mc:MovieClip;
	private var m_track:MovieClip;
	private var m_slider:MovieClip;
	
	private var m_sliderPressed:Boolean = false;
	
	public function CTrackBar(parent:MovieClip)
	{
		m_mc = parent.createEmptyMovieClip("m_mc", parent.getNextHighestDepth());
	}
	
	public function init(trackName:String, sliderName:String):Void
	{
		m_track = m_mc.attachMovie(trackName, "m_track", m_mc.getNextHighestDepth());
		m_slider = m_mc.attachMovie(sliderName, "m_slider", m_mc.getNextHighestDepth());
		
		initEventFunctions();
	}
	
	private function initEventFunctions():Void
	{
		var thisPtr:CTrackBar = this;
		
		m_slider.onPress = sliderOnPressTemp;
		m_slider.onRelease = sliderOnReleaseTemp;
		m_slider.onReleaseOutside = sliderOnReleaseTemp;
		m_slider.onMouseMove = sliderOnMouseMoveTemp;
		
		function sliderOnPressTemp():Void
		{
			thisPtr.sliderOnPress();
		}
		function sliderOnReleaseTemp():Void
		{
			thisPtr.sliderOnRelease();
		}
		function sliderOnMouseMoveTemp():Void
		{
			thisPtr.sliderOnMouseMove();
		}
	}
	
	private function sliderOnMouseMove():Void
	{
		if (!m_sliderPressed)
		{
			return;
		}		
		setSliderPos(m_mc._xmouse);
	}
	
	private function setSliderPos(posNew:Number):Void
	{
		var sliderOldX:Number = m_slider._x;
		
		m_slider._x = posNew;
		m_slider._x = clamp(m_slider._x, 0, m_track._width);
		if (m_slider._x != sliderOldX)
		{
			updateAfterEvent();
			newPos(m_slider._x / m_track._width);
		}
	}
	
	public function setPos(posNew:Number):Void
	{
		setSliderPos(posNew * m_track._width);
	}
	
	public function newPos(pos:Number):Void // pos 0..1
	{
	}
	
	private function clamp(num:Number, min:Number, max:Number):Number
	{
		if (num < min)
		{
			num = min;
		}
		if (num > max)
		{
			num = max;
		}
		return num;
	}
	
	private function sliderOnRelease():Void
	{
		m_sliderPressed = false;
		mouseUp();
	}
	
	private function sliderOnPress():Void
	{
		m_sliderPressed = true;
		mouseDown();
	}
	
	public function get x():Number
	{
		return m_mc._x;
	}
	
	public function get y():Number
	{
		return m_mc._y;
	}
	
	public function set x(xNew:Number):Void
	{
		m_mc._x = xNew;
	}
	
	public function set y(yNew:Number):Void
	{
		m_mc._y = yNew;
	}
	
	public function mouseDown():Void
	{
	}
	
	public function mouseUp():Void
	{
	}
}