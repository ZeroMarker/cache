Import sqluser

/// Descript:	生产厂家相关
/// Creater:    tsr
/// CreateDate: 2018-10-09
Class web.DHCSTMHUI.ItmManfNew Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPHMANFM";

/// Descript:	查询生产厂家信息
/// Creator: 	tsr
/// CreatDate: 	2018-10-09
/// Table: 		PH_Manufacturer,DHC_Manf_AddionInfo
/// Input: 		Params对象-生产厂家代码,生产厂家名称,状态
Query ItmManf(Params As %String) As Query(ROWSPEC = "RowId,ManfCode,ManfDesc,Address,Tel,MatProductPermit,MatProductExpDate,ComLic,ComLicDate,BusinessRegNo,BusinessRegExpDate,OrgCode,OrgCodeExpDate,TaxRegNo,MatManLic,MatManLicDate,MANFProdEprsHygLic,MANFProdEprsHygLicExpDate,SocialCreditCode,SocialCreditExpDate") [ SqlProc ]
{
}

ClassMethod ItmManfExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pRowId=PJObj.%Get("RowId")
	s pManfDesc=PJObj.%Get("ManfDesc")
	s pManfDesc=$$ALPHAUP^SSUTIL4(pManfDesc)
	s pStatus=PJObj.%Get("Status")
	s gHospId=PJObj.%Get("gHospId")
	s HospId=PJObj.%Get("BDPHospital")
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,gHospId)
	s ManfByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","ManfByHosp","")
	s Type=..sssCode()

	s SqlStr="SELECT a.PHMNF_RowId, a.PHMNF_Code, a.PHMNF_Name, a.PHMNF_Tel,"
		_"b.MANF_Alias, b.MANF_MatProduct_Permit, b.MANF_MatProduct_ExpDate, b.MANF_SocialCreditCode, b.MANF_SocialCreditExpDate, b.MANF_Active,"
		_"b.MANF_ComLic, b.MANF_ComLicDate, b.MANF_BusinessRegNo, b.MANF_BusinessReg_ExpDate, b.MANF_TaxRegNo,"
		_"b.MANF_OrgCode, b.MANF_OrgCode_ExpDate, b.MANF_MatManLic, b.MANF_MatManLic_ExpDate, b.MANF_ProdEprsHygLic, b.MANF_ProdEprsHygLicExpDate"
		_" FROM PH_Manufacturer a LEFT JOIN DHC_Manf_AddionInfo b ON a.PHMNF_RowId=b.MANF_PhcManf_DR"
		_" WHERE b.MANF_Type= '"_Type_"'"
	i pStatus'="" d
	.s SqlStr=SqlStr_" AND b.MANF_Active ='"_pStatus_"'"
	i pRowId'="" d
	.s SqlStr=SqlStr_" AND a.PHMNF_RowId IN ("_pRowId_")"
	
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("PHMNF_RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("PH_Manufacturer",RowId,HospId)
		continue:ShowDataFlag'="Y"
		s ManfCode = result.Data("PHMNF_Code")
		s ManfDesc = result.Data("PHMNF_Name")
		s Alias = result.Data("MANF_Alias")
		continue:(pManfDesc'="")&&(($$ALPHAUP^SSUTIL4(ManfCode)'[pManfDesc)
			&&($$ALPHAUP^SSUTIL4(ManfDesc)'[pManfDesc)&&($$ALPHAUP^SSUTIL4(Alias)'[pManfDesc))
		s Address =..GetAddress(RowId)
		s Tel = result.Data("PHMNF_Tel")
		s MatProductPermit = result.Data("MANF_MatProduct_Permit")
		s MatProductExpDate = result.Data("MANF_MatProduct_ExpDate")
		s:MatProductExpDate'="" MatProductExpDate=..DL2H(MatProductExpDate)
		s ComLic = result.Data("MANF_ComLic")
		s ComLicDate = result.Data("MANF_ComLicDate")
		s:ComLicDate'="" ComLicDate=..DL2H(ComLicDate)
		s BusinessRegNo = result.Data("MANF_BusinessRegNo")
		s BusinessRegExpDate = result.Data("MANF_BusinessReg_ExpDate")
		s:BusinessRegExpDate'="" BusinessRegExpDate=..DL2H(BusinessRegExpDate)
		s OrgCode = result.Data("MANF_OrgCode")
		s OrgCodeExpDate = result.Data("MANF_OrgCode_ExpDate")
		s:OrgCodeExpDate'="" OrgCodeExpDate=..DL2H(OrgCodeExpDate)
		s TaxRegNo = result.Data("MANF_TaxRegNo")
		s MatManLic = result.Data("MANF_MatManLic")
		s MatManLicDate = result.Data("MANF_MatManLic_ExpDate")
		s:MatManLicDate'="" MatManLicDate=..DL2H(MatManLicDate)
		s MANFProdEprsHygLic=result.Data("MANF_ProdEprsHygLic")
		s MANFProdEprsHygLicExpDate = result.Data("MANF_ProdEprsHygLicExpDate")
		s:MANFProdEprsHygLicExpDate'="" MANFProdEprsHygLicExpDate=..DL2H(MANFProdEprsHygLicExpDate)
		s SocialCreditCode=result.Data("MANF_SocialCreditCode")
		s SocialCreditExpDate = result.Data("MANF_SocialCreditExpDate")
		s:SocialCreditExpDate'="" SocialCreditExpDate=..DL2H(SocialCreditExpDate)
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ManfCode,ManfDesc,Address,Tel,MatProductPermit,MatProductExpDate,ComLic,ComLicDate,BusinessRegNo,BusinessRegExpDate,OrgCode,OrgCodeExpDate,TaxRegNo,MatManLic,MatManLicDate,MANFProdEprsHygLic,MANFProdEprsHygLicExpDate,SocialCreditCode,SocialCreditExpDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询生产厂家明细
/// Creator:	tsr
/// CreatDate:	2018-10-10
/// Table:		PH_Manufacturer,DHC_Manf_AddionInfo
/// Input:		生产厂家Id
/// w ##class(web.DHCSTMHUI.ItmManfNew).Select(672)
ClassMethod Select(Manf As %String) As %Library.String
{
	n (Manf)
	q:Manf="" ""
	q:'$d(^PHMNF(Manf)) ""

	s Code=$p(^PHMNF(Manf),"^",1)
	s Name=$p(^PHMNF(Manf),"^",2)
	s Tel=$p(^PHMNF(Manf),"^",3)
	s Address=..GetAddress(Manf)
	s ManfAddId=$o(^DHCMANF(0,"MANF",Manf,""))
	s (ParManfId,ParManf,Active)=""
	i ManfAddId'=""  d
	.s ParManfId=$p(^DHCMANF(ManfAddId),"^",2)
	.s Type=$p(^DHCMANF(ManfAddId),"^",7)
	.s Active=$p(^DHCMANF(ManfAddId),"^",10)
	s:ParManfId'="" ParManf=$p(^PHMNF(ParManfId),"^",2)
	s Data=Manf_"^"_Code_"^"_Name_"^"_Tel_"^"_Address_"^"_ParManfId
		_"^"_ParManf_"^"_Active
	s Title="RowId^ManfCode^ManfDesc^Tel^Address^ParManfId"
		_"^ParManf^Status"
	s BasicData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)

	q "{""success"":""0"",""BasicData"":"_BasicData_"}"
}

/// Descript:   保存生产厂家信息
/// Creater:    lihui
/// CreateDate: 20200315
/// Table:		PH_Manufacturer,DHC_Manf_AddionInfo,DHC_CertDetail
/// Input:		生产厂家基本信息,资质信息
/// w ##class(web.DHCSTMHUI.ItmManfNew).Save(^templxt("Save"))
ClassMethod Save(Basic As %String) As %Library.String
{
	n (Basic,%session)
	d ..sssSetLogID()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Basic)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s HospId=PJObj.%Get("BDPHospital")
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,gHospId)
	s RowId=PJObj.%Get("RowId")
	s ManfCode=PJObj.%Get("ManfCode")
	s ManfDesc=PJObj.%Get("ManfDesc")
	s Tel=PJObj.%Get("Tel")
	s Address=PJObj.%Get("Address")
	s ParManf=PJObj.%Get("ParManf")
	s Status=PJObj.%Get("Status")
	s:Status="" Status="N"
	
	i ManfDesc="" d RtnObj.Err(-2,"","生产厂家名称不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ManfCode="" d
	.s AppName=..%GetParameter("AppName")
	.s ManfCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",HospId)
	i ManfCode="" d RtnObj.Err(-3,"","生产厂家代码不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s HospMsg=""
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType("PH_Manufacturer")
	i TableType="C" s HospMsg="该数据属于管控类型数据,请联系相关人员进行授权!"
	s TmpId=##class(web.DHCSTMHUI.ItmManfNew).CheckManf("CODE",ManfCode,RowId,HospId)
	i (TmpId'="") d RtnObj.Err(-3,"",ManfCode_"代码重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s TmpId=##class(web.DHCSTMHUI.ItmManfNew).CheckManf("DESC",ManfDesc,RowId,HospId)
	i (TmpId'="") d RtnObj.Err(-4,"",ManfDesc_"名称重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s StkType=..sssCode()
	s SPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,4)
	s QPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,3,"",50)
	s Alias=ManfCode_"/"_ManfDesc_"/"_SPAlias_"/"_QPAlias
	
	tstart
	i RowId="" d
	.s OldJsonStr=""
	.s LogType="A"
	.&sql(Insert into PH_Manufacturer(PHMNF_Code,PHMNF_Name,PHMNF_Tel)
		values(:ManfCode,:ManfDesc,:Tel))   //PHMNF_Hospital_DR :HospId
	.i SQLCODE'=0 d RtnObj.Err(-6,RowId,ManfDesc_"主表保存失败!"_SQLCODE)
	.q:RtnObj.success'=0
	.s RowId=$p(%ROWID,$c(1))
	.s pHospId=..sssHospId(LocId)
	.s:pHospId="" pHospId=HospId
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,StkType,LocId,"",pHospId)	//生产厂家类组授权
	.s ScgStr=$Replace(ScgStr,"^",",")
	.s RtnObj=##class(web.DHCSTMHUI.ManfCatGroup).SaveManfAuthor(RowId,ScgStr)
	e  d
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("PH_Manufacturer",RowId)
	.s LogType="U"
	.&sql(update PH_Manufacturer set PHMNF_Code=:ManfCode,PHMNF_Name=:ManfDesc,PHMNF_Tel=:Tel
		where PHMNF_Rowid=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-8,RowId,ManfDesc_"主表保存失败!"_SQLCODE)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	d ..SaveAddress(Address,RowId)
	
	s ManfInfo=$o(^DHCMANF(0,"MANF",RowId,0))
	i (LogType="A")&&(ManfInfo'="") d
	.s ManfInfo=""
	.&sql(delete from DHC_Manf_AddionInfo where MANF_PhcManf_DR=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-9,RowId,ManfDesc_"附加表历史数据删除失败!"_SQLCODE)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	i ManfInfo="" d
	.s AddLogType="A"
	.s AddOldData=""
	.&sql(Insert into DHC_Manf_AddionInfo(MANF_ParManf_DR,MANF_PhcManf_DR,MANF_Type,MANF_Active,MANF_Alias)
		values(:ParManf,:RowId,:StkType,:Status,:Alias))
	.i SQLCODE'=0 d RtnObj.Err(-9,RowId,ManfDesc_"附加表增加失败!"_SQLCODE)
	.q:RtnObj.success'=0
	.s ManfInfo=$p(%ROWID,$c(1))
	e  d
	.s AddLogType="U"
	.s AddOldData=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("PH_Manufacturer",ManfInfo)
	.&sql(update DHC_Manf_AddionInfo set MANF_ParManf_DR=:ParManf,MANF_Active=:Status,MANF_Alias=:Alias  
		where MANF_Rowid=:ManfInfo)
	.i SQLCODE'=0 d RtnObj.Err(-11,ManfInfo,ManfDesc_"附加表更新失败!"_SQLCODE)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=##class(Log).SaveLog("PH_Manufacturer","User.PHManufacturer","生产厂家信息",RowId,ManfDesc,LogType,"",OldJsonStr)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=##class(Log).SaveLog("DHC_Manf_AddionInfo","User.DHCManfAddionInfo","生产厂家附加表信息",ManfInfo,ManfDesc,AddLogType,"",AddOldData)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",RowId,HospId)
	i +ret<0 d RtnObj.Err(-5,"",Description_"关联院区失败!")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tcommit
	d ..sssKillLogID()
	
	d ##class(web.DHCSTMHUI.ServiceForECS).postFactories(RowId,HospId)
	
	s RtnObj.rowid=RowId   
	q RtnObj.Json()
}

/// Description:查询生产厂家地址信息
/// Creator:	tsr
/// CreatDate:	2018-10-10
/// Table:		PH_Manufacturer
/// Input:		生产厂家Id
ClassMethod GetAddress(rowid As %String) As %Library.String
{
	n (rowid)
	s chl=0
	s ret=""
	f  s chl=$o(^PHMNF(rowid,"Address",chl))  q:chl=""  d
	.s address=^PHMNF(rowid,"Address",chl)
	.i ret=""  d
	..s ret=address
	.e  d
	..s ret=ret_address
	.
	q ret
}

/// Description:保存生产厂家地址信息
/// Creator:	tsr
/// CreatDate:	2018-10-10
/// Table:		PH_Manufacturer
/// Input:		地址,生产厂家Id
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{
	n (add,rowid)
	s linenum=$l(add,$c(13,10))
	k ^PHMNF(rowid,"Address")
	s ^PHMNF(rowid,"Address",0)=linenum 
	f i=1:1:linenum d
	.s ^PHMNF(rowid,"Address",i)=$p(add,$c(13,10),i) 
	q
}

/// Description:根据图片类型获取资质名称
/// Creator:	tsr
/// CreatDate:	2018-10-10
ClassMethod TypeDesc(type As %String) As %String
{
	n (type)
	i type="comLic" q "工商执照"
	i type="taxLic" q "税务登记号"
	i type="orgCode" q "机构代码"
	i type="insProLic" q "生产许可证"
	i type="insBusLic" q "经营许可证"
	i type="drugProLic" q "卫生许可证"
	i type="socialCreditCode" q "社会信用码"
	q type
}

/// w ##class(web.DHCSTMHUI.ItmManfNew).CheckManf(type, vlaue, OriRowId, HospId)
/// 判断生产厂家代码或名称是否重复,hospid为空时判断所有医院
ClassMethod CheckManf(type, vlaue, OriRowId, HospId, StkType = "M")
{
	n (type,vlaue,OriRowId,HospId,StkType)
	s tableName="PH_Manufacturer"
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat(type,vlaue,tableName,HospId,OriRowId,StkType)
	q ret
}

/// w ##class(web.DHCSTMHUI.ItmManfNew).GetManfId("CODE",vlaue,"")
/// 获取生产厂家id
ClassMethod GetManfId(type, value, HospId, StkType = "M")
{
	n (type,value,HospId,StkType)
	s tableName="PH_Manufacturer"
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId(type, value, tableName, HospId, StkType)
	q ret
}

}
