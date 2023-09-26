Import sqluser

/// 图片上传 统一入口
Class web.DHCSTMHUI.UpLoadPic Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	上传图片
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.UpLoadPic).jsUpLoad("3@%CSP.BinaryStream","{""OrgType"":""Vendor"",""OrgId"":""654"",""GrpType"":""Person"",""PointType"":""PersonLic"",""Point"":""8"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}","image/png","aa - 副本.png")
ClassMethod jsUpLoad(File, Params, FileType, FileName) As %String
{
	n (File, Params, FileType, FileName)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..UpLoad(File, Params, FileType, FileName)
	q RtnObj.Json()
}

/// 上传图片
/// w ##class(web.DHCSTMHUI.UpLoadPic).UpLoad("3@%CSP.BinaryStream","{""OrgType"":""Vendor"",""OrgId"":""654"",""GrpType"":""Person"",""PointType"":""PersonLic"",""Point"":""8"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}","image/png","aa - 副本.png")
ClassMethod UpLoad(File, Params, FileType, FileName) As RtnObj
{
	n (File,Params,FileType,FileName,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s OrgType=PJObj.%Get("OrgType")		//对象Vendor\Manf\Inci等
	s OrgId=PJObj.%Get("OrgId")			//对象ID
	s GrpType=PJObj.%Get("GrpType")		//来源分类Person(人员)、Cert(资质)等
	s PointerType=PJObj.%Get("PointerType")	//数据类型：SalesMan(业务员)、comLic(营业执照)等
	s Pointer=PJObj.%Get("Pointer")		//数据ID
	s SubType=PJObj.%Get("SubType")		//数据子类型类型
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	
	i FileName'="" d
	.s tmpid=""
	.&sql(select %ID into :tmpid from DHC_ItmPicture where IPIC_FileName=:FileName 
		and IPIC_PointerType=:PointerType and IPIC_Pointer=:Pointer)
	.i tmpid'="" d RtnObj.Err(-2,"","文件名称重复!","",0)
	q:RtnObj.success<0 RtnObj
	
	s AppName=##class(web.DHCSTMHUI.Common.FtpFile).%GetParameter("AppName")  //ftp公共单号规则
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock("FTPFILE")
	i ret'=0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	s FileSrc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",gHospId) //生成图片名称
	i FileSrc="" d
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	.d RtnObj.Err(-3,"","生成图片名称失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Len=$L(FileName,".")
	s FileSuffix=$p(FileName,".",Len)		//后缀
	s FileSuffix=$$ALPHAUP^SSUTIL4(FileSuffix)
	s FileSrc=FileSrc_"."_FileSuffix	//重命名
	i FileName="" s FileName=FileSrc
	
	//FileType重新分类，图片类型JPG，除图片外的文件类型PDF
	s PicType=$$ALPHAUP^SSUTIL4("gif,jpg,jpeg,bmp,png")
	i (PicType'[FileSuffix) s FileType="PDF"
	e  s FileType="JPG"
	
	s StrParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s result = ##class(web.DHCSTMHUI.Common.FtpFile).UpFile(File,StrParam,FileSrc)
	i result'=0  d
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	.d RtnObj.Err(-4,"","ftp服务上传失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Date=+$h
	s Time=$p($h,",",2)
	&sql(insert into DHC_ItmPicture
		(IPIC_OrgType,IPIC_OrgId,IPIC_GrpType,IPIC_PointerType,IPIC_Pointer,IPIC_SubType,IPIC_FileName,IPIC_FileSrc,IPIC_Date,IPIC_Time,IPIC_SSUSR_DR,IPIC_Active,IPIC_Type)
		values(:OrgType,:OrgId,:GrpType,:PointerType,:Pointer,:SubType,:FileName,:FileSrc,:Date,:Time,:gUserId,'Y',:FileType))
	i SQLCODE'=0 d RtnObj.Err(-5,"","保存图片信息失败!")
	
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	q RtnObj
}

/// 保存拍照
/// w ##class(web.DHCSTMHUI.UpLoadPic).SavePhoto("{""OrgType"":""Vendor"",""OrgId"":""654"",""GrpType"":""Person"",""PointerType"":""SalesMan"",""Pointer"":""8"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""SubType"":""PersonLic""}","aa1.jpg","20201112001.jpg")
ClassMethod SavePhoto(Params As %String, FileName As %String, NewFileName As %String) As %String
{
	n (Params,FileName,NewFileName)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q -1
	
	s OrgType=PJObj.%Get("OrgType")		//对象Vendor\Manf\Inci等
	s OrgId=PJObj.%Get("OrgId")			//对象ID
	s GrpType=PJObj.%Get("GrpType")		//来源分类Person(人员)、Cert(资质)等
	s PointerType=PJObj.%Get("PointerType")	//数据类型：SalesMan(业务员)、comLic(营业执照)等
	s Pointer=PJObj.%Get("Pointer")		//数据ID
	s SubType=PJObj.%Get("SubType")		//数据子类型类型
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	
	s FileType=$p(NewFileName,".",2)
	
	s Date=+$h
	s Time=$p($h,",",2)
	&sql(insert into DHC_ItmPicture
		(IPIC_OrgType,IPIC_OrgId,IPIC_GrpType,IPIC_PointerType,IPIC_Pointer,IPIC_SubType,IPIC_FileName,IPIC_FileSrc,IPIC_Date,IPIC_Time,IPIC_SSUSR_DR,IPIC_Active,IPIC_Type)
		values(:OrgType,:OrgId,:GrpType,:PointerType,:Pointer,:SubType,:FileName,:NewFileName,:Date,:Time,:gUserId,'Y',:FileType))
	q SQLCODE
}

/// Descript:	删除文件
/// 对象类型数据
ClassMethod jsDeleteFileInfo(PicName As %String, Params As %String) As %String
{
	n (PicName,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..DeleteFileInfo(PicName, Params)
	q RtnObj.Json()
}

/// Description:删除文件
ClassMethod DeleteFileInfo(PicName As %String, Params As %String) As RtnObj
{
	n (PicName,Params)
	s RtnObj=##class(RtnObj).%New()
	i PicName="" d RtnObj.Err(-1,"","请选择要删除的文件!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId
	
	s RowId=""
	&sql(SELECT IPIC_RowId into :RowId FROM DHC_ItmPicture WHERE IPIC_FileSrc=:PicName)
	i RowId="" d RtnObj.Err(-2,"","文件信息查询失败!")
	q:RtnObj.success'=0 RtnObj

	s ret = ##class(web.DHCSTMHUI.Common.FtpFile).DeleFile(PicName,Param)
	i ret'=0 d RtnObj.Err(-3,RowId,"图片FTP删除失败!")
	q:RtnObj.success'=0 RtnObj
	
	&sql(delete from DHC_ItmPicture where  IPIC_RowId=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-4,RowId,"图片删除失败!")
	q RtnObj
}

/// 获取文件信息
/// w ##class(web.DHCSTMHUI.UpLoadPic).GetFileInfo(^templxt("mmnnn3"))
ClassMethod GetFileInfo(Params) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	
	s OrgType=PJObj.%Get("OrgType")		//对象Vendor\Manf\Inci等
	s OrgId=PJObj.%Get("OrgId")			//对象ID
	s GrpType=PJObj.%Get("GrpType")		//来源分类Person(人员)、Cert(资质)等
	s PointerType=PJObj.%Get("PointerType")	//数据类型：SalesMan(业务员)、comLic(营业执照)等
	s Pointer=PJObj.%Get("Pointer")		//数据ID
	s SubType=PJObj.%Get("SubType")		//数据子类型类型
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("HospId")
	i HospId="" s HospId=gHospId
	
	q:((OrgId="")&&(Pointer="")) ""
	s (VendorId,ManfId)=""
	i OrgType="Inci" d
	.s Add=$o(^DHCITMINFO(0,"INCI",OrgId,""))
	.q:Add=""
	.s VendorId=$p($G(^DHCITMINFO(Add)),"^",24)
	.s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
	
	s StrSql="select IPIC_RowId, IPIC_OrgType,IPIC_OrgId,IPIC_GrpType,IPIC_PointerType,IPIC_Pointer,IPIC_SubType,IPIC_FileName,IPIC_FileSrc,IPIC_Date,IPIC_Time,IPIC_SSUSR_DR,IPIC_Active,IPIC_Type "
		_" from DHC_ItmPicture where (IPIC_OrgType='"_OrgType_"' and IPIC_OrgId='"_OrgId_"')"
	i VendorId'="" s StrSql=StrSql_" or (IPIC_OrgType='Vendor' and IPIC_OrgId='"_VendorId_"')" 
	i ManfId'="" s StrSql=StrSql_" or (IPIC_OrgType='Manf' and IPIC_OrgId='"_ManfId_"')" 
	
	i GrpType'="" d
	.s StrSql=StrSql_" and IPIC_GrpType='"_GrpType_"'"
	
	i PointerType'="" d
	.s StrSql=StrSql_" and IPIC_PointerType='"_PointerType_"'"
	
	i Pointer'="" d
	.s StrSql=StrSql_" and IPIC_Pointer='"_Pointer_"'"
	e  d
	.s StrSql=StrSql_" and IPIC_Active='Y'"
	
	i SubType'="" d
	.s StrSql=StrSql_" and IPIC_SubType='"_SubType_"'"
	
	s StrSql=StrSql_" order by IPIC_PointerType"

	s pid=..NewPid()
	k ^DHCSTMPID("GetFileInfo",pid)
	s resultString = "",count=0
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	i err  q "{}"
	While(result.Next())
	{
		s RowId = result.Data("IPIC_RowId")
		s OrgType = result.Data("IPIC_OrgType")
		s OrgId = result.Data("IPIC_OrgId")
		s GrpType = result.Data("IPIC_GrpType")
		s PointerType = result.Data("IPIC_PointerType")
		s FileName = result.Data("IPIC_FileName")
		s FileSrc = result.Data("IPIC_FileSrc")
		s Pointer = result.Data("IPIC_Pointer")
		s SubType = result.Data("IPIC_SubType")
		s FileType = result.Data("IPIC_Type")
		
		s ImgType=""
		i GrpType="Cert" d
		.s ImgType=##class(web.DHCSTMHUI.DHCCertDetail).GetCertName(OrgType,PointerType,HospId)
		e  i GrpType="Person" d
		.s ImgType="业务员"		//目前只有SalesMan一种人员
		
		i SubType'="" d
		.s:SubType="PersonLic" SubType="授权书"
		.s:SubType="PersonPhoto" SubType="照片"
		.s:SubType="PersonCard" SubType="身份证"
		.s ImgType=ImgType_"-"_SubType
		
		s ^DHCSTMPID("GetFileInfo",pid,FileType,RowId)=FileSrc_"^"_ImgType_"^"_FileName
	}
	d result.Close()
	s JsonObj=##class(%DynamicObject).%New()
	s FileType=""
	f  s FileType=$o(^DHCSTMPID("GetFileInfo",pid,FileType))  q:FileType=""  d
	.s RowId=""
	.s JsonArray=##class(%DynamicArray).%New()
	.f  s RowId=$o(^DHCSTMPID("GetFileInfo",pid,FileType,RowId))  q:RowId=""  d
	..s JsonSubObj=##class(%DynamicObject).%New()
	..s info=^DHCSTMPID("GetFileInfo",pid,FileType,RowId)
	..s PicSrc=$p(info,"^",1)
	..s ImgType=$p(info,"^",2)
	..s FileName=$p(info,"^",3)
	..d JsonSubObj.%Set("PicSrc",PicSrc)
	..d JsonSubObj.%Set("ImgType",ImgType)
	..d JsonSubObj.%Set("FileName",FileName)
	..d JsonSubObj.%Set("FileType",FileType)
	..d JsonArray.%Push(JsonSubObj)
	.d JsonObj.%Set(FileType,JsonArray)
	w JsonObj.%ToJSON()
	k ^DHCSTMPID("GetFileInfo",pid)
	q ""
}

/// 获取文件信息
/// w ##class(web.DHCSTMHUI.UpLoadPic).UpdateFileActiveFlag(^templxt("mm11222"))
ClassMethod UpdateFileActiveFlag(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-21,"","入参解析失败!")
	
	s OrgType=PJObj.%Get("OrgType")		//对象Vendor\Manf\Inci等
	s OrgId=PJObj.%Get("OrgId")			//对象ID
	s GrpType=PJObj.%Get("GrpType")		//来源分类Person(人员)、Cert(资质)等
	s PointerType=PJObj.%Get("PointerType")	//数据类型：SalesMan(业务员)、comLic(营业执照)等
	s Pointer=PJObj.%Get("Pointer")		//数据ID
	//s SubType=PJObj.%Get("SubType")		//数据子类型类型
	s RowId=PJObj.%Get("RowId")		//图片id
	s ActiveFlag=PJObj.%Get("ActiveFlag")
	
	q:(OrgType="")||(OrgId="")||(PointerType="")||(Pointer="") RtnObj.Err(-22,"","请选择要更新图片的对象","",0)
	
	s RowId=""
	&sql(select IPIC_RowId into :RowId from DHC_ItmPicture where IPIC_OrgType=:OrgType and IPIC_OrgId=:OrgId and IPIC_GrpType=:GrpType 
		and IPIC_PointerType=:PointerType and IPIC_Pointer=:Pointer)
	q:RowId="" RtnObj
	
	&sql(update DHC_ItmPicture set IPIC_Active=:ActiveFlag where IPIC_OrgType=:OrgType and IPIC_OrgId=:OrgId and IPIC_GrpType=:GrpType 
		and IPIC_PointerType=:PointerType and IPIC_Pointer=:Pointer)
	i SQLCODE'=0 d RtnObj.Err(-23,"","文件更新标志失败")
	
	q RtnObj
}

/// 依据库存项获取文件信息
/// w ##class(web.DHCSTMHUI.UpLoadPic).GetFileInfoByItm(^templxt("pic"))
ClassMethod GetFileInfoByItm(Params) As %String
{
	n (Params)
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"
	
	s InciId=PJObj.%Get("InciId")
	s Oeori=PJObj.%Get("Oeori")
	s gHospId=PJObj.%Get("gHospId")
	i InciId="" d		//2021-02-20基础平台调用处理
	.s Oeord=$p(Oeori,"||",1),Ch=$p(Oeori,"||",2)
	.q:(Oeord="")!(Ch="")
	.q:'$d(^OEORD(Oeord,"I",Ch))
	.s Arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	.q:Arcim=""
	.s InciId=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),""))
	q:(InciId="")&&(Oeori="") "{}"
	
	s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(InciId)
	s VendorId=$p(VendorStr,"^",1)
	s InciOrgType="Inci"
	s VendorOrgType="Vendor"
	
	s StrParam=""_"^"_""_"^"_""_"^"_gHospId
	s ftpconfig=##class(web.DHCSTMHUI.Common.FtpFile).GetFtpConfig(StrParam)
	s ftpip=$p(ftpconfig,"^",1)
	s ftpuser=$p(ftpconfig,"^",2)
	s ftppass=$p(ftpconfig,"^",3)
	s ftpsrc=$p(ftpconfig,"^",4)
	s ftpport=$p(ftpconfig,"^",5)
	s ftpssl=$p(ftpconfig,"^",7)
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.SSLConfiguration=ftpssl
	i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q "{}"
	
	s StrSql="select IPIC_OrgType,IPIC_RowId, IPIC_OrgType,IPIC_OrgId,IPIC_GrpType,IPIC_PointerType,IPIC_Pointer,IPIC_SubType,IPIC_FileName,IPIC_FileSrc,IPIC_Date,IPIC_Time,IPIC_SSUSR_DR,IPIC_Active,IPIC_Type "
		_" from DHC_ItmPicture where (IPIC_OrgType='"_InciOrgType_"' and IPIC_OrgId='"_InciId_"') or (IPIC_OrgType='"_VendorOrgType_"' and IPIC_OrgId='"_VendorId_"' and IPIC_GrpType='Cert')"
		_" and IPIC_Active='Y'"
	
	s pid=..NewPid()
	k ^DHCSTMPID("GetFileInfo",pid)
	s resultString = "",count=0
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	i err  q "{}"
	While(result.Next())
	{
		s OrgType = result.Data("IPIC_OrgType")
		s RowId = result.Data("IPIC_RowId")
		s OrgType = result.Data("IPIC_OrgType")
		s OrgId = result.Data("IPIC_OrgId")
		s GrpType = result.Data("IPIC_GrpType")
		s PointerType = result.Data("IPIC_PointerType")
		s FileName = result.Data("IPIC_FileName")
		s FileSrc = result.Data("IPIC_FileSrc")
		s Pointer = result.Data("IPIC_Pointer")
		s SubType = result.Data("IPIC_SubType")
		s FileType = result.Data("IPIC_Type")
		
		s ftpFileName=ftpsrc_FileSrc
		s ExistFlag=$$IsFtpFileExist()
		continue:ExistFlag=0		;不存在图片
		
		s ImgType=""
		s:PointerType'="" ImgType=##class(web.DHCSTMHUI.DHCCertDetail).GetCertName(OrgType,PointerType,gHospId)
		
		s ^DHCSTMPID("GetFileInfo",pid,OrgType_FileType,RowId)=FileSrc_"^"_ImgType_"^"_FileName
	}
	d ftp.Logout()
	d result.Close()
	s JsonObj=##class(%DynamicObject).%New()
	s FileType=""
	f  s FileType=$o(^DHCSTMPID("GetFileInfo",pid,FileType))  q:FileType=""  d
	.s RowId=""
	.s JsonArray=##class(%DynamicArray).%New()
	.f  s RowId=$o(^DHCSTMPID("GetFileInfo",pid,FileType,RowId))  q:RowId=""  d
	..s JsonSubObj=##class(%DynamicObject).%New()
	..s info=^DHCSTMPID("GetFileInfo",pid,FileType,RowId)
	..s PicSrc=$p(info,"^",1)
	..s ImgType=$p(info,"^",2)
	..s FileName=$p(info,"^",3)
	..d JsonSubObj.%Set("PicSrc",PicSrc)
	..d JsonSubObj.%Set("ImgType",ImgType)
	..d JsonSubObj.%Set("FileName",FileName)
	..d JsonSubObj.%Set("FileType",FileType)
	..d JsonArray.%Push(JsonSubObj)
	.d JsonObj.%Set(FileType,JsonArray)
	w JsonObj.%ToJSON()
	k ^DHCSTMPID("GetFileInfo",pid)
	q ""
	
IsFtpFileExist()
	;确认目录下是否存在该文件: 1存在,0不存在
	New fileArray,key,isExists
	If 'ftp.NameList(ftpsrc,.fileArray) q 1
	Set key="",isExists=0
	s count=0
	For  s tmpFileName=fileArray.GetNext(.key) Quit:(key="")||(isExists=1)  d
	.i (ftpFileName=tmpFileName) s isExists=1
	q isExists
}

}
