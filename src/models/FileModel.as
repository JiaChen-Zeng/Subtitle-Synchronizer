package models
{
	public class FileModel
	{
		public var _id:int;
		public var name:String;
		public var extension:String;
		public var url:String;
		
		public function FileModel(_id:int = 0, name:String = null, extension:String = null, url:String = null)
		{
			this._id = _id;
			this.name = name;
			this.extension = extension;
			this.url = url;
		}
	}
}