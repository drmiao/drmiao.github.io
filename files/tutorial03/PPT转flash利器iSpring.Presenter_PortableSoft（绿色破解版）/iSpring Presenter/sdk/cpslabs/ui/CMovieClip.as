import cpslabs.ui.CComponent;

class cpslabs.ui.CMovieClip extends CComponent
{
	private var m_content:MovieClip;
	private var m_source:String;
	
	function CMovieClip(parent:MovieClip, name:String, depth:Number)
	{
		super(parent, name, depth);
	}
	
	function set source(src:String):Void
	{
		if (m_source != src)
		{
			if (m_content)
			{
				m_content.removeMovieClip();
				delete m_content;
			}
			m_source = src;
			attachMovie(src);
			invalidate();
		}
	}
	
	function get source():String
	{
		return m_source;
	}
	
	function get content():MovieClip
	{
		return m_content;
	}
	
	function createEmptyMovieClip(name:String, depth:Number):MovieClip
	{
		var d:Number = (depth != undefined) ? depth : movieClip.getNextHighestDepth();
		var mc:MovieClip = movieClip.createEmptyMovieClip((name != undefined) ? name : "m" + d, (depth != undefined) ? depth : d);
		mc.tabEnabled = false;
		if (m_content == undefined)
		{
			m_content = mc;
		}
		return mc;
	}

	function attachMovie(assetName:String, name:String, depth:Number):MovieClip
	{
		var d:Number = (depth != undefined) ? depth : movieClip.getNextHighestDepth();
		var mc:MovieClip = movieClip.attachMovie(assetName, (name != undefined) ? name : "m" + d, (depth != undefined) ? depth : d);
		
		if (mc == undefined)
		{
			//trace(movieClip + ": asset " + assetName + " is not found in library");
		}
		
		mc.tabEnabled = false;
		if (m_content == undefined)
		{
			m_content = mc;
		}
		return mc;
	}
	
	function resize(w:Number, h:Number):Void
	{
		var mc:MovieClip = movieClip;
		if (m_content)
			mc = m_content;
		mc._width  = w;
		mc._height = h;
	}
	
	private function getWidth():Number
	{
		return m_content ? m_content._width : movieClip._width;
	}
	
	private function getHeight():Number
	{
		return m_content ? m_content._height : movieClip._height;
	}
}
