Import SQLUser

/// 名称: web.DHCEQ.Plat.CTVendor
/// 描述: 供应商
/// 编写者：LMM
/// 编写日期: 2018-09-17
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTVendor Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-08-16
/// modified by sjh 2020-08-06 增加入参SourceType
/// 描述：hisui改造 查询供应商
/// 入参：Name:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTVendor","GetVendor","","5")
Query GetVendor(Name As %String = "", SourceType As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TAddress:%String,TContPerson:%String,TTel:%String,TFax:%String,TBank:%String,TBankNo:%String,TShName:%String") [ SqlProc ]
{
}

ClassMethod GetVendorExecute(ByRef qHandle As %Binary, Name As %String = "", SourceType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Name=##Class(web.DHCEQCommon).UnEscape(Name)
 	s Name=$ZCONVERT(Name ,"U")
 	// modified by sjh 2020-08-03 BUG0031 begin  增加SourceType入参控制
 	//s FirmType=2		//add by CZF0093 2020-03-17 公司类型: 2:供应商 3:生产厂商 4:服务商
	s index=1
	s rowid=0
	d BuildDataGetVendorInfo
	Quit $$$OK
BuildDataGetVendorInfo
	i SourceType=""  d
	.s FirmType=2
	.f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d		//modified by czf 20200404 begin
	..s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	..q:FCRowid=""
	..q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	..d ResetVariablesGetVendorInfo
	..s TRowID = rowid	//rowid
	..s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	..q:InvalidFlag="Y"
	..s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	..s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	..s TShName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",11)
	..q:(Name'="")&&($ZCONVERT(TCode ,"U")'[Name)&&($ZCONVERT(TName ,"U")'[Name)&&($ZCONVERT(TShName ,"U")'[Name)
	..s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)	//add by CZF0093 2020-03-17 2:供应商 3:生产厂商 4:服务商
	..s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	..s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	..s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
	..s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
	..s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
	..s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
	..s THold5=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",24)
	..q:(THold5="Y")&&(##class(web.DHCEQCommon).GetSysInfo("201016")=2)
	..d OutputRowGetVendorInfo
		
	i SourceType=5
	{
		//公司信息
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCVendor",rowid)) q:rowid=""  d
		.d ResetVariablesGetVendorInfo
		.s TRowID = rowid
		.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
		.q:InvalidFlag="Y"
		.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
		.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
		.q:TName=""
		.s TShName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",11)
		.q:(Name'="")&&($ZCONVERT(TCode ,"U")'[Name)&&($ZCONVERT(TName ,"U")'[Name)&&($ZCONVERT(TShName ,"U")'[Name)
		.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)	//add by CZF0093 2020-03-17 2:供应商 3:生产厂商 4:服务商
		.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
		.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
		.s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
		.s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
		.s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
		.s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
		.d OutputRowGetVendorInfo
	}
	
	quit
OutputRowGetVendorInfo
   s Data=$lb(TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetVendorInfo
	s (TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName)=""
	quit
}

ClassMethod GetVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 创建:zx 2018-12-11
/// 目的:系统自动录入供应商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: Data:供应商
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQ.Plat.CTVendor).UpdProvider("hhffdd^我w^111")
ClassMethod UpdProvider(Data)
{
	n PRowID,ProviderOperMethod,Code,Desc,ProviderHandler,ProviderTel
	s (PRowID,Code)=""
	s Desc=$p(Data,"^",1)
	s Desc=$ZCONVERT(Desc,"U")
	s ProviderHandler=$p(Data,"^",2)
	s ProviderTel=$p(Data,"^",3)
	s CodeInfo=##class(web.DHCEQ.Plat.CTCHanZiEncoding).GetEncoding(Desc,4,"","U")
	s CodeInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(CodeInfo)	//CZF0131 2020-01-20
	i CodeInfo.%Get("SQLCODE")=0 s Code=CodeInfo.%Get("Data")
	s SQLCODE=0
	s ProviderOperMethod=##class(web.DHCEQCommon).GetSysInfo("201006")
	if (ProviderOperMethod=0)||(Desc="") q ""
	&SQL(Select V_RowID Into :PRowID from SQLUSER.DHC_EQCVendor Where V_Name=:Desc and V_InvalidFlag='N')
	if PRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCVendor(V_Code,V_Name,V_ContPerson,V_Tel,V_InvalidFlag) Values(:Code,:Desc,:ProviderHandler,:ProviderTel,'N'))
		if SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s PRowID=$G(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,PRowID)
}

}
