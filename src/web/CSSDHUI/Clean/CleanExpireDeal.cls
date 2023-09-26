Import SQLUser

Class web.CSSDHUI.Clean.CleanExpireDeal Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

///  Creator:ban
///  CreatDate:2021.12.07
///  Description:清洗页面获取待清洗-过期包弹窗数据
///  Table: CSSD_trans
///  Input: Params : 查询条件 以及 科室ID等
///  Output:
///  Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanExpireDeal","SelectExpireDeal",^tmpllkk)
Query SelectExpireDeal(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "TransRowId:%Integer,PkgId,PkgDesc,Label,Status,StatusDesc,ExpDate,ExpDealDate,ExpDealTime,ExpDealUserId,ExpDealUserName,AttributeId,AttributeDesc") [ SqlProc ]
{
}

ClassMethod SelectExpireDealExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gLocId = PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate = PJObj.%Get("ExpStartDate")
	s pEndDate = PJObj.%Get("ExpEndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s PId=..NewPid()
	
	f date=pStartDate:1:pEndDate d
	.s TransRowId="" 
	.f  s TransRowId=$o(^User.CSSDTransI("CSSDTExpDealDateIndex",date,TransRowId)) q:TransRowId=""  d
	..q:'$d(^User.CSSDTransD(TransRowId))
	..
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransRowId)
	..s ExpDealCleanDetailObj=TransObj.CSSDTExpDealCleanDetailDr
	..s ExpDealCleanDetailId=""
	..i $IsObject(ExpDealCleanDetailObj) d
	...s ExpDealCleanDetailId=ExpDealCleanDetailObj.%Id()
	..q:ExpDealCleanDetailId'=""	//去除掉已添加清洗的包
	..
	..s Label=TransObj.CSSDTLabel
	..s ExpDealDate=TransObj.CSSDTExpDealDate
	..s ExpDealDate=..DL2H(ExpDealDate)
	..s ExpDealTime=TransObj.CSSDTExpDealTime
	..s ExpDealTime=..TL2H(ExpDealTime)
	..s Status=TransObj.CSSDTStatus
	..s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
	..q:Status'="TC"
	..
	..s (ExpDealUserId,ExpDealUserName)=""
	..s ExpDealUserObj=TransObj.CSSDTExpDealUserDr
	..i $IsObject(ExpDealUserObj) d
	...s ExpDealUserId=ExpDealUserObj.%Id()
	...s ExpDealUserName=ExpDealUserObj.SSUSRName
	...
	..s ExpDate=TransObj.CSSDTExpDate
	..s ExpDate=..DL2H(ExpDate)
	..s PackageObj=TransObj.CSSDTPackage
	..s PkgId=PackageObj.%Id()
	..s HospitalId=PackageObj.CSSDPHospital.%Id()
	..q:(HospitalId'=gHospId)
	..
	..s PkgDesc=PackageObj.CSSDPDesc
	..s AttributeId=PackageObj.CSSDPPackTypeDetail
	..q:AttributeId=7
	..
	..s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	..d OutPutRowExpDeal
	Quit $$$OK
OutPutRowExpDeal
	s Data=$lb(TransRowId,PkgId,PkgDesc,Label,Status,StatusDesc,ExpDate,ExpDealDate,ExpDealTime,ExpDealUserId,ExpDealUserName,AttributeId,AttributeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

///  Creator:ban
///  CreatDate:2021.12.07
///  Description:清洗页面待清洗-过期包弹窗添加消毒包功能
///  Table: CSSD_Trans,CSSD_CleanDetailPacksl
///  Input: Params ：科室等信息 , mainId : 主表ID
///  Output:
///  Return:
/// w ##Class(web.CSSDHUI.Clean.CleanExpireDeal).SaveExpireDeal("[{""TransRowId"":"""",""PkgId"":""5"",""PkgDesc"":""普通包2"",""Label"":""00052022120700003"",""Status"":""TC"",""StatusDesc"":""已过期处理"",""ExpDate"":""2022-12-06"",""ExpDealDate"":""2022-12-08"",""ExpDealTime"":""09:28:29"",""ExpDealUserId"":""11889"",""ExpDealUserName"":""xd01"",""AttributeId"":""2"",""AttributeDesc"":""普通包""}]","25")
ClassMethod SaveExpireDeal(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s MethodName=$ClassName()_".SaveUnPassClean"
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s PkgId=Obj.%Get("PkgId")
		s Label=Obj.%Get("Label")
		s AttributeId=Obj.%Get("AttributeId")	//包属性
		s TransRowId=Obj.%Get("TransRowId")
		s MaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		s LevelFlag=0
		s Qty=1		
		
		s (NewCleanDetailId,CallBackDetailId)=""
		i AttributeId=1 d
		.s CodeDictId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
		.&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR,CSSDCDP_Label,CSSDPR_Package_DR,CSSDCDP_Qty,CSSDCDP_IsCrtLbl,CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,CSSDCDP_TotalQty,CSSDCDP_MaterialDR) values (:MainId,:CodeDictId,:PkgId,1,0,0,:CallBackDetailId,1,:MaterialId))
		.i SQLCODE'=0  d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.s NewCleanDetailId=%ROWID	;用以绑定追踪信息，记录重新处理后对应的清洗明细
		
		e  d
		.s detailId=""
		.s detailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrPkgdr",MainId,PkgId,""))
		.i detailId=""  d
		..&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR,CSSDPR_Package_DR,CSSDCDP_Qty,CSSDCDP_IsCrtLbl,CSSDCDP_CreatedQty,CSSDCDP_TotalQty,CSSDCDP_MaterialDR) values (:MainId,:PkgId,1,0,0,1,:MaterialId))
		..i SQLCODE'=0 d RtnObj.Err(-3,"","插入清洗明细失败！")
		..s NewCleanDetailId=%ROWID
		.
		.e  d
		..&sql(update cssd_cleandetailpacks set CSSDCDP_Qty=CSSDCDP_Qty+:Qty,CSSDCDP_TotalQty=CSSDCDP_TotalQty+:Qty  where ID=:detailId)
		..i SQLCODE'=0 d RtnObj.Err(-4,"","更新清洗明细失败！")
		..s NewCleanDetailId=detailId
		q:RtnObj.success'=0
		
		i TransRowId'="" d
		.;更新原有标签数据，绑定重新清洗的明细ID
		.&sql(UPDATE CSSD_Trans SET CSSDT_ExpDealCleanDetailDr=:NewCleanDetailId WHERE CSSDT_Rowid=:TransRowId)
		.i SQLCODE'=0  d RtnObj.Err(-3,"","重新清洗绑定明细数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
