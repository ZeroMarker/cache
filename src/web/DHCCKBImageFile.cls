Class web.DHCCKBImageFile Extends %Persistent
{

/// w ##class(web.DHCCKBImageFile).save()
ClassMethod save()
{
	s json={}
	if $data(%request.MimeData("files",1)){
		s dir = "\scripts\dhcnewpro\dhcckb\tinyimg\"
		s path = ##class(ext.util.String).GetPhysicalPath("",dir)
		if '##class(%File).DirectoryExists(path) d ##class(%File).CreateDirectoryChain(path)
		
		Set fileStream = %request.MimeData("files",1)
		Set fileName = $H_fileStream.FileName   //按日期重新命名  shy 2022-09-08
		Set fileName = $p(fileName,"\",$l(fileName,"\"))
		Set fileName = $p(fileName,"/",$l(fileName,"/"))
		Set suffix = $p(fileName,".",$l(fileName,"."))
		if (suffix="png")||(suffix="jpeg")||(suffix="jpg") {
			Set file = ##class(%FileBinaryStream).%New()
			Set file.Filename=path_fileName
			Do file.Rewind()
			do file.CopyFromAndSave(fileStream)
			Do file.Flush()
			Do file.%Save()
			do file.%Close()
			
			s item={}
			s item.name=fileName
			s item.dir=path
			s json.code=200
			s json.data=item
			s ^SHY=path
			//"D:\dthealth\app\dthis\web\temp\tinyimg\"
			s path6 = $p(path,"/",6)
			s path7 = $p(path,"/",7)
			s path8 = $p(path,"/",8)
			s path9 = $p(path,"/",9)
			s json.location=".."_"/"_path6_"/"_path7_"/"_path8_"/"_path9_"/"_fileName
		}else{
			s json.code=500
			s json.msg="仅支持图片格式的文件导入"
		}
	}else{
		s json.code=500
		s json.msg="请选择正确的文件"
	}
	q json.%ToJSON()
}

Storage Default
{
<Data name="DHCCKBImageFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCKBImageFileD</DataLocation>
<DefaultData>DHCCKBImageFileDefaultData</DefaultData>
<IdLocation>^web.DHCCKBImageFileD</IdLocation>
<IndexLocation>^web.DHCCKBImageFileI</IndexLocation>
<StreamLocation>^web.DHCCKBImageFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
