Import sqluser

/// 图片管理公共类
Class web.CSSDHUI.CommonFile Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:查询图片信息
/// Creater:lxt
/// CreateDate:20230317
/// Table:CT_STER_CSSD.CommonFile
/// Input:
/// Output:
/// Return：w ##class(web.CSSDHUI.CommonFile).GetFileInfo("{""PointerType"":""Clean"",""Pointer"":""48"",""FileType"":""PDF""}")
ClassMethod GetFileInfo(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	
	s PointerType=PJObj.%Get("PointerType")
	s Pointer=PJObj.%Get("Pointer")
	s FileType=PJObj.%Get("FileType")
	
	q:(PointerType="")||(Pointer="")
	s SqlStr="SELECT ID,CF_Name,CF_Type,CF_Src "
			_" FROM CT_STER_CSSD.CommonFile "
			_" WHERE CF_PointerType='"_PointerType_"' and CF_Pointer='"_Pointer_"'"
			_" and CF_Type='"_FileType_"'"
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s Json = ##class(web.CSSDHUI.Common.JsonObj).%New()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s FileName = Result.Data("CF_Name")
		s FileType=Result.Data("CF_Type")
		s FileSrc=Result.Data("CF_Src")
		s Data=RowId_"^"_FileName_"^"_FileType_"^"_FileSrc
		d Json.InsertRowData(Data)
	}
	d Result.Close()
	d Json.getCbJsonData("RowId^FileName^FileType^FileSrc")
	k Json
	Q ""
}

/// Descript:删除图片
/// Creater:lxt
/// CreateDate:20230317
/// Table:
/// Input:
/// Output:
/// w ##class(web.CSSDHUI.CommonFile).jsDelete(3)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	
	s RowId=PJobj.%Get("RowId")
	
	s FileName=""
	s FileObj=##class(CT.STER.CSSD.CommonFile).%OpenId(RowId)
	q:'$IsObject(FileObj) RtnObj
	s FileName=FileObj.CFSrc
	
	s Result = ##class(web.CSSDHUI.Common.FtpFile).DeleFile(FileName,Params)
	q:Result'=0 RtnObj.Err(-1,"","删除FTP文件失败!")
	
	&sql(delete FROM CT_STER_CSSD.CommonFile WHERE ID=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-1,"","删除失败!")
	
	q RtnObj
}

/// Descript:上传图片信息
/// Creater:lxt
/// CreateDate:20230317
/// Table:CT_STER_CSSD.CommonFile
/// Input:
/// Output:
ClassMethod jsUpload(File As %CSP.BinaryStream, Params As %String, FileName As %String) As %Library.String
{
	n (File,Params,FileName)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Upload(File,Params,FileName)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Upload(File As %CSP.BinaryStream, Params As %String, FileName As %String) As web.CSSDHUI.RtnObj
{
	n (File,Params,FileName)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Pointer=PJObj.%Get("Pointer")
	s PointerType=PJObj.%Get("PointerType")
	s gUserId=PJObj.%Get("gUserId")
	
	s Len=$L(FileName,".")
	s FileSuffix=$$ALPHAUP^SSUTIL4($p(FileName,".",Len))
	s SuffixStr=$$ALPHAUP^SSUTIL4("gif,jpg,jpeg,bmp,png")
	i (SuffixStr'[FileSuffix) s FileType="PDF"
	e  s FileType="JPG"
	
	s ExistId=$o(^CT.STER.CSSD.CommonFileI("TypePointerName",PointerType,Pointer,FileName,0))
	i ExistId'="" d RtnObj.Err(-99,"","文件已存在！")
	q:RtnObj.success'=0 RtnObj
	
	s Ret=..sssLock("CSSDFTPFILEM")
	i Ret'=0 q RtnObj.Err(-99,"","加锁失败")
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("CSSDFTPFILEM")
	
	s FileSrc=No_"."_FileSuffix
	s Result = ##class(web.CSSDHUI.Common.FtpFile).UpFile(File,FileSrc,Params)
	i Result'=0 d RtnObj.Err(-99,"","ftp服务上传失败") d ..sssUnLock("CSSDFTPFILEM")
	q:RtnObj.success'=0 RtnObj
	
	s FileObj=##class(CT.STER.CSSD.CommonFile).%New()
	s FileObj.CFName=FileName
	s FileObj.CFType=FileType
	s FileObj.CFSrc=FileSrc
	d FileObj.CFUserDRSetObjectId(gUserId)
	s FileObj.CFDate=+$h
	s FileObj.CFTime=$p($h,",",2)
	s FileObj.CFPointerType=PointerType
	s FileObj.CFPointer=Pointer
	s Sc=FileObj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-5,"","文件保存失败！") d ..sssUnLock("CSSDFTPFILEM")
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock("CSSDFTPFILEM")
	q RtnObj
}

/// Descript:拍照
/// Creater:lxt
/// CreateDate:20230317
/// Table:CT_STER_CSSD.CommonFile
/// Input:
/// Output:
ClassMethod SavePhoto(Params As %String, FileName As %String, NewFileName As %String) As %String
{
	n (Params,FileName,NewFileName)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q -1
	
	s PointerType=PJObj.%Get("PointerType")
	s Pointer=PJObj.%Get("Pointer")
	s gUserId=PJObj.%Get("gUserId")
	
	i PointerType="Pkg" q ##class(web.CSSDHUI.PackageInfo.Package).SavePhoto(Params,FileName,NewFileName)
	
	s FileObj=##class(CT.STER.CSSD.CommonFile).%New()
	s FileObj.CFName=FileName
	s FileObj.CFType="JPG"
	s FileObj.CFSrc=NewFileName
	d FileObj.CFUserDRSetObjectId(gUserId)
	s FileObj.CFDate=+$h
	s FileObj.CFTime=$p($h,",",2)
	s FileObj.CFPointerType=PointerType
	s FileObj.CFPointer=Pointer
	s Sc=FileObj.%Save()
	q:$$$ISERR(Sc) -2
	
	q 0
}

}
