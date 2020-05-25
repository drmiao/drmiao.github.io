package ispring.as3bridge
{
	public class PresenterInfo
	{
		private var m_name:String;
		private var m_title:String;
		private var m_biographyText:String;
		private var m_email:String;
		private var m_webSite:String;
		private var m_index:int;
		
		public function PresenterInfo(internalClass:InternalClass, pi:Object, index:int)
		{
			m_name = pi.name;
			m_title = pi.title;
			m_biographyText = pi.biographyText;
			m_email = pi.email;
			m_webSite = pi.webSite;
			m_index = index;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get title():String
		{
			return m_title;
		}
		
		public function get biographyText():String
		{
			return m_biographyText;
		}
		
		public function get email():String
		{
			return m_email;
		}
		
		public function get webSite():String
		{
			return m_webSite;
		}
		
		public function get index():int
		{
			return m_index;
		}
	}
}