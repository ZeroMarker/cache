Class web.DHCTest.Tools Extends %RegisteredObject
{

/// Creator：    taosongrui
/// CreatDate:   2022-3-2
/// Description：导入xml
/// Input：      path
/// Others:      w ##class(web.DHCTest.Tools).ImportXml("/tmp/xml/yfyk")
ClassMethod ImportXml(path As %String) As %String
{
	s existFlag = ##class(%File).Exists(path)
	i existFlag = 0 q "文件夹不存在"
	
#;	k ^TMPImportError("ImportXml")
	s fileName = "*.xml"
	s qspec = "c-d"
	s errorlog = "",ret = "",fileRet = ""
	s Date = $zd(+$H,3)
	s Time = $zt($p($H,",",2))
	d $SYSTEM.OBJ.ImportDir(path, fileName, qspec, .errorlog, 1)
	
	i +errorlog=0 {
		s ret = "编译xml成功"
	}else{
		s errlen = errorlog
		;Set errorPath = path_"XmlErrorFile.log"
		;Set errorFile = ##class(%Stream.FileCharacter).%New()
		;Set sc = errorFile.FilenameSet(errorPath)
		;If $$$ISERR(sc) {
		;	s fileRet = "Error: Unable to create file at "_errorPath
		;}
		f i = 1:1:errlen{
			s ^TMPImportError("ImportXml",Date,Time,i) = errorlog(i)
			;Set sc = errorFile.Write(i_": "_errorlog(i)_$C(13,10))
			;If $$$ISERR(sc) {
			;	s fileRet = "Error: Unable to write to file at "_errorPath
			;}
		}
		;Do errorFile.Flush()
		;Do errorFile.%Save()
		s ret = "编译xml存在错误，请查看^TMPImportError"
	}
	q ret_"!"_fileRet
}

/// Creator：    taosongrui
/// CreatDate:   2022-5-12
/// Description：编译csp
/// Input：      path
/// Others:      w ##class(web.DHCTest.Tools).CompileCsp("/dthealth/app/dthis/web/csp/pha.in.v3.locdruglist.csp", "/tmp/xml/yfyk/")
ClassMethod CompileCsp(file As %String, path As %String) As %String
{
	s existFlag = ##class(%File).Exists(file)
	i existFlag = 0 q "文件不存在"
	
	s file = "/imedical/web/"_$p(file,"/web/",2)
#;	k ^TMPImportError("CompileCsp")
	s errorlog = "",ret = "",fileRet = ""
	s qspec = "c-d"
	s Date = $zd(+$H,3)
	s Time = $zt($p($H,",",2))
	d $SYSTEM.OBJ.Load(file, qspec, .errorlog)
	i +errorlog=0 {
		s ret = "编译csp成功"		
	}else{
		s errlen = errorlog
		;s path = path_"CspErrorFile.log"
		;s errorFile = ##class(%Stream.FileCharacter).%New()
		;s sc = errorFile.FilenameSet(path)
		;i $$$ISERR(sc) {
		;	s fileRet = "Error: Unable to create file at "_path
		;}
		f i = 1:1:errlen{
			s ^TMPImportError("CompileCsp",Date,Time,i) = errorlog(i)
			;s sc = errorFile.Write(i_": "_errorlog(i)_$C(13,10))
			;i $$$ISERR(sc) {
			;	s fileRet = "Error: Unable to write to file at "_path
			;}
		}
		;d errorFile.Flush()
		;d errorFile.%Save()
		s ret = "编译csp存在错误，请查看^TMPImportError"
	}
	q ret_"!"_fileRet
}

/// Creator：    taosongrui
/// CreatDate:   2023-2-22
/// Description：将数据保存到文件
/// Input：      path
/// Others:      d ##class(web.DHCTest.Tools).WriteFile()
ClassMethod WriteFile() As %String
{
	
	Set path = "/tmp/xml/"

#;	s existFlag = ##class(%File).Exists(path)
#;	i existFlag=0 {
#;		s cmd = "mkdir -p " _ path
#;		s result = $ZF(-1, cmd)
#;	}
	s path = path_"CspErrorFile.log"
	Set file = ##class(%Stream.FileCharacter).%New()
	Set sc = file.FilenameSet(path)
	If $$$ISERR(sc) {
		Write "Error: Unable to create file at ", path, ! Quit
	}
	Set result = 30
	Set sc = file.Write("1\The result is: "_result_"."_$C(13,10))
	Set sc = file.Write("2\The result is: "_result_"."_$C(13,10))
	If $$$ISERR(sc) {
		Write "Error: Unable to write to file at ", path, ! Quit
	}
	Do file.Flush()
	Do file.%Save()
	Write "The result has been saved to ", path, !
}

}
