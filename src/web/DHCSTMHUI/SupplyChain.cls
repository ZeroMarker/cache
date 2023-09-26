Import sqluser

/// Descript:	授权书相关
/// CreateDate: 2022-05-05
Class web.DHCSTMHUI.SupplyChain Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询信息
/// Input:		查询条件
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SupplyChain","QueryChain",^tmpbin(22))
Query QueryChain(Params As %String) As Query(ROWSPEC = "RowId:%Integer,ChainCode,LevelCount,ManfId,ManfDesc,VendorId,VendorDesc,Remarks,ChainInfo") [ SqlProc ]
{
}

ClassMethod QueryChainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s PRowId=PJObj.%Get("RowId")
	s PChainCode=PJObj.%Get("ChainCode")
	s PManf=PJObj.%Get("Manf")
	s gHospId=PJObj.%Get("gHospId")
	;s PHospId=PJObj.%Get("BDPHospital")
	;s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(PHospId,gHospId)
	
	s SqlStr="SELECT ID, SC_Code, SC_Manf_DR, SC_Vendor_DR, SC_Remarks "
		_" FROM CT_HRP_Mat.SupplyChain where 1=1 "
	i PRowId'="" d
	.s SqlStr=SqlStr_" AND DL_RowId="_pRowId
	e  d
	.i PChainCode'="" d
	..s PChainCode=$$UPPER^SSUTIL4(PChainCode)
	..s SqlStr=SqlStr_" AND %ALPHAUP(SC_Code) LIKE '%"_PChainCode_"%'"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (Result.Next())
	{
		s RowId=Result.Data("ID")
		s ChainCode=Result.Data("SC_Code")
		s ManfId=Result.Data("SC_Manf_DR")
		s VendorId=Result.Data("SC_Vendor_DR")
		s Remarks=Result.Data("SC_Remarks")
		continue:(PRowId="")&&(PManf'="")&&(ManfId'=PManf)
		;s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Dealer",RowId,pHospId)
		;continue:ShowDataFlag'="Y"
		
		s ManfDesc=$p(^PHMNF(ManfId),"^",2)
		s VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
		s LevelCount=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,""),-1)
		s ChainInfo=..GetChainInfo(RowId)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ChainCode,LevelCount,ManfId,ManfDesc,
		VendorId,VendorDesc,Remarks,ChainInfo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetChainInfo(RowId)
{
	n (RowId)
	q:RowId="" ""
	
	s ChainInfo=""
	s Level=0
	f  s Level=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,Level)) q:Level=""  d
	.s Ch=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,Level,""))
	.q:Ch=""
	.s LevelIist=^CT.HRP.MAT.SupplyChainD(RowId,"Level",Ch)
	.s FrType=$lg(LevelIist,3)
	.s FromCompanyId=$lg(LevelIist,4)
	.s ToType=$lg(LevelIist,5)
	.s ToCompanyId=$lg(LevelIist,6)
	.s StartDate=$lg(LevelIist,7)
	.s EndDate=$lg(LevelIist,8)
	.
	.s FromCompy=""
	.i FrType="P" s FromCompy=$p(^PHMNF(FromCompanyId),"^",2)
	.e  i FrType="D" s FromCompy=$lg(^User.DHCDealerD(FromCompanyId),4)
	.
	.s ToCompany=""
	.i ToType="D" s ToCompany=$lg(^User.DHCDealerD(ToCompanyId),4)
	.e  i ToType="V" s ToCompany=$p(^APC("APCVM",ToCompanyId),"^",3)
	.
	.s StartDate=..DL2H(StartDate)
	.s EndDate=..DL2H(EndDate)
	.s LevelInfo=Level_". "_ToCompany_"&nbsp&nbsp&nbsp"_StartDate_" 至 "_EndDate
	.i ChainInfo="" s ChainInfo=LevelInfo
	.e  s ChainInfo=ChainInfo_"</br>"_LevelInfo
	
	q ChainInfo
}

/// w ##class(web.DHCSTMHUI.SupplyChain).GetChainDetail(4)
ClassMethod GetChainDetail(RowId) As %String
{
	n (RowId)
	q:RowId="" "{}"
	
	s ChainDetail={}
	s ChainCode=$lg(^CT.HRP.MAT.SupplyChainD(RowId),2)
	s Manf=$lg(^CT.HRP.MAT.SupplyChainD(RowId),3)
	s Remarks=$lg(^CT.HRP.MAT.SupplyChainD(RowId),5)
	s ManfDesc=$p(^PHMNF(Manf),"^",2)
	s ManfObj={}.%Set("RowId",Manf).%Set("Description",ManfDesc)
	s MainObj={}.%Set("RowId",RowId).%Set("ChainCode",ChainCode).%Set("Manf",ManfObj).%Set("Remarks",Remarks)
	s ChainDetail.Main=MainObj
	
	s DetailArray=[]
	s Level=0
	f  s Level=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,Level)) q:Level=""  d
	.s Ch=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,Level,""))
	.q:Ch=""
	.s LevelItmId=RowId_"||"_Ch
	.s LevelIist=^CT.HRP.MAT.SupplyChainD(RowId,"Level",Ch)
	.s Level=$lg(LevelIist,2)
	.s FrType=$lg(LevelIist,3)
	.s FromCompanyId=$lg(LevelIist,4)
	.s ToType=$lg(LevelIist,5)
	.s ToCompanyId=$lg(LevelIist,6)
	.s StartDate=$lg(LevelIist,7)
	.s EndDate=$lg(LevelIist,8)
	.
	.s FromCompy=""
	.i FrType="P" s FromCompy=$p(^PHMNF(FromCompanyId),"^",2)
	.e  i FrType="D" s FromCompy=$lg(^User.DHCDealerD(FromCompanyId),4)
	.
	.s ToCompany=""
	.i ToType="D" s ToCompany=$lg(^User.DHCDealerD(ToCompanyId),4)
	.e  i ToType="V" s ToCompany=$p(^APC("APCVM",ToCompanyId),"^",3)
	.
	.s VendorFlag=$s(ToType="V":"Y",1:"N")
	.s StartDate=..DL2H(StartDate)
	.s EndDate=..DL2H(EndDate)
	.
	.s FromCompany={}.%Set("RowId",FromCompanyId).%Set("Description",FromCompy)
	.s ToCompany={}.%Set("RowId",ToCompanyId).%Set("Description",ToCompany)
	.
	.s DetailObj={}
	.s DetailObj.RowId=LevelItmId
	.s DetailObj.Level=Level
	.s DetailObj.FromCompany=FromCompany
	.s DetailObj.ToCompany=ToCompany
	.s DetailObj.Flag=VendorFlag
	.s DetailObj.StartDate=StartDate
	.s DetailObj.EndDate=EndDate
	.
	.d DetailArray.%Push(DetailObj)
	
	s ChainDetail.Detail=DetailArray
	
	q ChainDetail.%ToJSON()
}

/// Descript:	保存授权书信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.SupplyChain).jsSave("{""Manf"":""1176"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57900"",""RowId"":"""",""ChainCode"":""102"",""Remarks"":"""",""Vendor"":""25""}","[{""FromCompany"":""2"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57900"",""ToCompany"":""25"",""StartDate"":""2022-03-05"",""EndDate"":""2022-06-10"",""Flag"":""Y"",""Level"":""3""},{""FromCompany"":""1"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57900"",""ToCompany"":""2"",""StartDate"":""2020-05-04"",""EndDate"":""2022-06-02"",""Flag"":"""",""Level"":""2""},{""FromCompany"":""1176"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57900"",""ToCompany"":""1"",""StartDate"":""2020-02-03"",""EndDate"":""2022-06-01"",""Flag"":"""",""Level"":""1""}]")
ClassMethod jsSave(Main As %String, Detail) As %String
{
	n (%session,Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存授权书
/// Input:		明细
/// Return：	RtnObj
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (%session,Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s RowId=PJObj.%Get("RowId")
	s ChainCode=PJObj.%Get("ChainCode")
	s Manf=PJObj.%Get("Manf")
	s Vendor=PJObj.%Get("Vendor")
	s Remarks=PJObj.%Get("Remarks")
	s MaxLevel=PJObj.%Get("MaxLevel")
	q:ChainCode="" RtnObj.Err(-2,"","代码不能为空!","",0)
	
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","明细入参解析失败!")
	
	ts
	
	;先清除多余的授权级别
	i (RowId'="") d
	.s DelLevel=MaxLevel
	.f  s DelLevel=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,DelLevel)) q:(DelLevel="")||(RtnObj.success<0)  d
	..s DelCh=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,DelLevel,""))
	..q:DelCh=""
	..s DelRowId=RowId_"||"_DelCh
	..&sql(DELETE FROM CT_HRP_MAT.SupplyChainLevel WHERE ID=:DelRowId)
	..i SQLCODE<0 d RtnObj.Err(-1,RowId,"供应链明细信息保存失败!") q
	i RtnObj.success<0 tro  q RtnObj
	
	i RowId'="" d
	.s ChainObj=##class(CT.HRP.MAT.SupplyChain).%OpenId(RowId)
	e  d
	.s ChainObj=##class(CT.HRP.MAT.SupplyChain).%New()
	s ChainObj.SCCode=ChainCode
	d ChainObj.SCManfDRSetObjectId(Manf)
	d ChainObj.SCVendorDRSetObjectId(Vendor)
	s ChainObj.SCRemarks=Remarks
	s Sc=ChainObj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-1,"","供应链信息保存失败")
	s RowId=ChainObj.%Id()
	
	While (RtnObj.success=0) {
		s ItmObj=PJObj.%Pop()
		q:ItmObj=""
		
		s Level=ItmObj.%Get("Level")
		s VendorFlag=ItmObj.%Get("Flag")
		s FromCompany=ItmObj.%Get("FromCompany")
		s ToCompany=ItmObj.%Get("ToCompany")
		s StartDate=ItmObj.%Get("StartDate")
		s EndDate=ItmObj.%Get("EndDate")
		s StartDate=..DH2L(StartDate)
		s EndDate=..DH2L(EndDate)
		
		;P-生产厂家、V-供应商、D-经销商
		s FromType=$s(Level=1:"P",1:"D")
		s ToType=$s(VendorFlag="Y":"V",1:"D")
		
		s Ch=$o(^CT.HRP.MAT.SupplyChainLevelI("Level",RowId,Level,""))
		i Ch="" d
		.s Obj=##class(CT.HRP.MAT.SupplyChainLevel).%New()
		.d Obj.SCLParRefSetObjectId(RowId)
		e  d
		.s LevelItmId=RowId_"||"_Ch
		.s Obj=##class(CT.HRP.MAT.SupplyChainLevel).%OpenId(LevelItmId)
		
		s Obj.SCLLevel=Level
		s Obj.SCLFrType=FromType
		s Obj.SCLFrPointer=FromCompany
		s Obj.SCLToType=ToType
		s Obj.SCLToPointer=ToCompany
		s Obj.SCLStartDate=StartDate
		s Obj.SCLEndDate=EndDate
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"",Level_"级授权信息保存失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=RowId
	q RtnObj
}

}
