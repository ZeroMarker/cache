/// author:wanghc
/// date:  2009-11-12
/// desc:  xml文件操作
Class web.Util.DHCJFXMLOperate Extends %RegisteredObject
{

ClassMethod WriteStreamByFile(pathFileName As %String = "") As %FileCharacterStream
{
	s ExistsFlag=##Class(%File).Exists(pathFileName)
	q:ExistsFlag'=1 ""   //pathFileName is not exists 
	s file=##class(%File).%New(pathFileName)
	Do file.Open("RU")
	s stream=##class(%FileCharacterStream).%New()  
	d stream.CopyFrom(file)  
	d file.%Close()
	quit stream
}

ClassMethod testFile() As %String
{
	s stream = ..WriteStreamByFile("D:\XMLPath\DHCJFClassGlobal.xml")
	s size = ..WriteFileByStream(stream,"c:\wang2.xml")
}

ClassMethod test() As %String
{
	s fileString=$p( ^TMP("wanghc"),"^",1)
	s pathFileName=$p(^TMP("wanghc"),"^",2)
	s size = ..WriteFileByString(fileString,pathFileName)
}

ClassMethod WriteFileByString(fileString As %String = "", pathFileName As %String = "") As %Float
{
	

	q:pathFileName="" "-1"
	s len = ##class(%File).GetDirectoryLength(pathFileName)
	f i=1:1:len-1 d
	.d ##class(%File).GetDirectoryPiece(pathFileName,i,.dirAll)
	.s dirExists=##class(%File).DirectoryExists(dirAll)
	.i dirExists=0 d ##class(%File).CreateDirectory(dirAll)
	s file = ##class(%File).%New(pathFileName)
	D file.Open("WSN")
	d file.Write(fileString)
	d file.Close()
	q file.SizeGet()
}

/// @param: param  web后面的路径
/// @return: webpath 目录的物理全路径
/// @other: 
/// s path = ##class(web.Util.DHCJFXMLOperate).GetPhysicalPath("/csp"). 
/// 如果是window返回 D:\DTHealth\app\dthis\web\csp\ 或 D:\trakcarelive\....
/// 如果是linux 返回 /DTHealth/app/dthis/web/csp/ 或/trakcarelive/....
ClassMethod GetPhysicalPath(param)
{
	Set pathInfo = %request.GetCgiEnv("PATH_INFO")
	Set app = $p(pathInfo,"/csp/",1)
	set physicalPath=""
	Set CurNS= $namespace
	zn "%sys"
	set flag = $d(^SYS("Security","ApplicationsD",app))
	if flag=0{
		s app = $p(app,"/",1,$l(app,"/")-1)		
		if $d(^SYS("Security","ApplicationsD",app))=0{
			s app = $p(app,"/",1,$l(app,"/")-1)
		}
	}
	if 1=$d(^SYS("Security","ApplicationsD",app)){
		set physicalPath = $lg(^SYS("Security","ApplicationsD",app),17)
	}
	zn CurNS
	set physicalPath = ##class(%File).NormalizeDirectory(physicalPath_param)
	if '##class(%File).DirectoryExists(physicalPath) {
		d ##class(%File).CreateDirectoryChain(physicalPath)
	}
	q physicalPath
}

/// @param: param 
/// @return: webpath /dthealth/web/, /trakcarelive/web/ ,trakcarelive/trak/web/
/// @other:
/// s path = ##class(web.Util.DHCJFXMLOperate).GetWebPath()
/// /dthealth/web/
ClassMethod GetWebPath()
{
	Set path = %request.GetCgiEnv("SCRIPT_NAME")
	Set path = $p(path,"/web/")
	Set path = path_"/web/"
	Quit path
}

ClassMethod WriteFileByStream(stream As %CharacterStream = "", pathFileName As %String = "") As %Float
{
	q:pathFileName="" "-1"
	//create Directory
	s len = ##class(%File).GetDirectoryLength(pathFileName)
	f i=1:1:len-1 d
	.d ##class(%File).GetDirectoryPiece(pathFileName,i,.dirAll)
	.s dirExists=##class(%File).DirectoryExists(dirAll)
	.i dirExists=0 d ##class(%File).CreateDirectory(dirAll)
	//create file
	s file = ##class(%File).%New(pathFileName)
	D file.Open("WSN")
	d stream.Rewind()
	d file.CopyFrom(stream)
	d file.Close()
	q file.SizeGet()
}

/// author : wanghuicai
/// date:    2009-10-16
/// input:   对象 ,目标对象 
/// Output:  目标对象有多少属性被写值非空值
/// desc:    通过对象的属性名拷贝对象的值
///         如果属性不对应对应,属性值就设为""
ClassMethod copyObject(srcObject, aimObject)
{
	s srcAllClass = srcObject.%PackageName()_"."_srcObject.%ClassName()
	s aimAllClass = aimObject.%PackageName()_"."_aimObject.%ClassName()
	set @"aimObject"=aimObject  
	set @"srcObject"=srcObject
	set @"nullValue"=""
	s srcClassDefionition=##class(%Dictionary.ClassDefinition).%OpenId(srcAllClass,0)
	Set rs = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rs.Execute(aimAllClass)
	set count=0
	While(rs.Next()) {
		set propertyName=rs.Data("Name")
		set srcpropertydefinition=##class(%Dictionary.PropertyDefinition).%OpenId(srcAllClass_"||"_propertyName,0)
		//判断在来源对象中是不是有目标对象的属性
		if (srcpropertydefinition){
			s executeStr="srcPropValue=srcObject."_propertyName ,@executeStr  
			s executeStr="srcIsObjFlag=$isObject(srcPropValue)",@executeStr 
			s executeStr="aimPropValue=aimObject."_propertyName ,@executeStr  
			s executeStr="aimIsObjFlag=$isObject(aimPropValue)",@executeStr 
			if (@("srcIsObjFlag")=1)&&(@("aimIsObjFlag")=1) {
				s executeStr="aimObject."_propertyName_"SetObjectId(srcObject."_propertyName_"GetObjectId())" ,@executeStr
			} elseif (@("srcIsObjFlag")=1)&&(@("aimIsObjFlag")=0){
				s executeStr="aimObject."_propertyName_"=srcObject."_propertyName_"GetObjectId()" ,@executeStr
			} elseif (@("srcIsObjFlag")=0)&&(@("aimIsObjFlag")=1){
				s executeStr="aimObject."_propertyName_"SetObjectId(srcObject."_propertyName_")" ,@executeStr
			}else {
				 s executeStr = "aimObject."_propertyName_"=srcObject."_propertyName, @executeStr
			}
			s count=count+1
		}else{
			s executeStr = "aimObject."_propertyName_"=nullValue", @executeStr
		}
	}	
	q count
}

}
