package 
{
	import spark.components.Group;
	import spark.components.WindowedApplication;
	
	public class MainBase extends WindowedApplication
	{
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//
		//  Constructor
		//
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		public function MainBase()
		{
			super();
		}
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//
		//  Variables
		//
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//  SkinPart
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		[SkinPart(required="true")]
		public var headerGroup:Group;
		
		[SkinPart(required="true")]
		public var footerGroup:Group;
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//
		//  Properties
		//
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//  header
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		[ArrayElementType("mx.core.IVisualElement")]
		private var _header:Array = [];
		
		public function get header():Array { return _header; }
		
		public function set header(value:Array):void
		{
			if (_header === value)
				return;
			
			_header = value;
			if (headerGroup)
				headerGroup.mxmlContent = _header;
		}
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//  header
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		[ArrayElementType("mx.core.IVisualElement")]
		private var _footer:Array = [];
		
		public function get footer():Array { return _footer; }
		
		public function set footer(value:Array):void
		{
			if (_footer === value)
				return;
			
			_footer = value;
			if (footerGroup)
				footerGroup.mxmlContent = _footer;
		}
		
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		//
		//  Overridden methods
		//
		//☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch (instance)
			{
				case headerGroup: headerGroup.mxmlContent = _header; break;
				case footerGroup: footerGroup.mxmlContent = _footer; break;
			}
		}
	}
}

