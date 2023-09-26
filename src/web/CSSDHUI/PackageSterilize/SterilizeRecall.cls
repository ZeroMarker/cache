Import SQLUser

/// 消毒包灭菌召回
Class web.CSSDHUI.PackageSterilize.SterilizeRecall Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	灭菌批号召回
/// Creator:	why
/// CreateDate:	2020-7-9
/// Table:		cssd_packagesterilize
/// Input:		灭菌批号
/// Return：	灭菌批号数据
/// d ##Class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeRecall","GetTraceInfoBySteBatNo","{""RecallReason"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SterNo"":""202206160012102""}")
Query GetTraceInfoBySteBatNo(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgDesc,Status,LocId,LocDesc,RecallFlag,RecallReasonDesc,RecallUserName,RecallDateTime") [ SqlProc ]
{
}

ClassMethod GetTraceInfoBySteBatNoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PSterNo=PJObj.%Get("SterNo")
	q:PSterNo="" $$$OK
	s PSterMainId=$o(^User.CSSDSterilizeRecordI("CSSDSRNoIndex",PSterNo,""))
	q:PSterMainId="" $$$OK
	s CheckFlag=$lg(^User.CSSDSterilizeRecordD(PSterMainId),27)
	;验收合格的才能召回
	q:CheckFlag'="1" $$$OK
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,SterItmId)) q:SterItmId=""  d
	.s RowId=SterItmId
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.d SterItmObj.%Reload()
	.q:'$IsObject(SterItmObj)
	.s SterLabel=SterItmObj.CSSDPSLabel
	.s RecallFlag=SterItmObj.CSSDPSRecallFlag
	.s RecallReasonDesc=SterItmObj.CSSDPSRecallReason.CSSDRecallDesc
	.s RecallUserName=SterItmObj.CSSDPSRecallUser.SSUSRName
	.s RecallDate=SterItmObj.CSSDPSRecallDate
	.s RecallTime=SterItmObj.CSSDPSRecallTime
	.s RecallDate=..DL2H(RecallDate)
	.s RecallTime=..TL2H(RecallTime)
	.s RecallDateTime=RecallDate_" "_RecallTime
	.q:SterLabel=""
	.s TransId= $o(^User.CSSDTransI("CSSDTLabel",SterLabel,""))
	.s TransInfo=$g(^User.CSSDTransD(TransId))
	.q:TransInfo=""
	.s Label=$lg(TransInfo,5)
	.s SteDr=$lg(TransInfo,17)
	.s DispDr=$lg(TransInfo,14)
	.s Pkgdr=$lg(TransInfo,16)
	.s Status=$lg(TransInfo,8)
	.s PkgObj=##class(User.CSSDPackage).%OpenId(Pkgdr)
	.d PkgObj.%Reload()
	.q:'$IsObject(PkgObj)
	.s PkgDesc=PkgObj.CSSDPDesc
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.s:AttributeId=1 PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.q:SteDr=""
	.i DispDr="" d
	..s SterItmInfo=$g(^User.CSSDPackageSterilizeD(SteDr))
	..q:SterItmInfo=""
	..s SterMainId=$lg(SterItmInfo,13)
	..s SterMainInfo=$g(^User.CSSDSterilizeRecordD(SterMainId))
	..s LocId=$lg(SterMainInfo,17)
	..s LocDesc=..sssLocDesc(LocId)
	.e  d
	..s DispItmInfo=$g(^User.CSSDPackageDispD(DispDr))
	..q:DispItmInfo=""
	..s DispMainId = $li(DispItmInfo,26)
	..s DispMainInfo=$g(^User.CSSDPackageDispMainD(DispMainId))
	..q:DispMainInfo=""
	..s LocId=$li(DispMainInfo,7)
	..s LocDesc=..sssLocDesc(LocId)
	.d OutputRowRecall
	q $$$OK
OutputRowRecall
	s Data=$lb(RowId,Label,PkgDesc,Status,LocId,LocDesc,RecallFlag,RecallReasonDesc,RecallUserName,RecallDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:sbx
/// CreatDate:2023.1.6
/// Description:灭菌批号召回
/// Input:Main,Detail
/// Output:
/// Return:RtnObj.Json()
/// others:
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeRecall).jsSteReCall()
ClassMethod jsSteReCall(Main, Detail) As %Library.String
{
	n (Main, Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SteReCall(Main, Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020.7.9
/// Description:灭菌批号召回
/// Table:CSSD_Trans,CSSD_PackageSterilize
/// Input:Main, Detail
/// Output:
/// Return:RtnObj
/// others:
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeRecall).SteReCall(^tmpwn(1),^tmpwn(2))
ClassMethod SteReCall(Main, Detail) As web.CSSDHUI.RtnObj
{
	n (Main,Detail,%session)
	s MethodName=$ClassName()_".SteReCall"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJObjMain.%FromJSON(Main)
	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)
	i ((ScMain'=0)||(ScDetail'=0)) q RtnObj.Err(-1,"","入参解析失败:"_MethodName)

	s PRecallReasonId=PJObjMain.%Get("RecallReasonDesc")
	s gUser=PJObjMain.%Get("gUserId")
	s gLocId=PJObjMain.%Get("gLocId")
	i PRecallReasonId="" q RtnObj.Err(-1,"","召回原因为空","",0)
	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s SteItmId=Obj.%Get("RowId")
		s Label=Obj.%Get("Label")
		s PkgDesc=Obj.%Get("PkgDesc")
		s RecallFlag=Obj.%Get("RecallFlag")
		s LocId=Obj.%Get("LocId")

		continue:RecallFlag'=""
		s DateTime=$zdt($h,3)
		s Date=$p($h,",",1)
		s Time=$p($h,",",2)
		s SteItmObj=##class(User.CSSDPackageSterilize).%OpenId(SteItmId)
		d SteItmObj.%Reload()
		s SteItmObj.CSSDPSRecallFlag="Y"
		d SteItmObj.CSSDPSRecallReasonSetObjectId(PRecallReasonId)
		d SteItmObj.CSSDPSRecallUserSetObjectId(gUser)
		s SteItmObj.CSSDPSRecallDateTime=DateTime
		s SteItmObj.CSSDPSRecallDate=Date
		s SteItmObj.CSSDPSRecallTime=Time
		s Sc=SteItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-2,"","更新灭菌明细表失败!")
		continue:RtnObj.success'=0

		s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		s TransObj.CSSDTStatus="RC"
		s Sc=TransObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","更新追踪表失败")
		continue:RtnObj.success'=0

		s RecallReasonDesc=##class(User.CSSDRecallReason).%OpenId(PRecallReasonId).CSSDRecallDesc
		s Message="标签:"_Label_","_PkgDesc_" 现在因 "_RecallReasonDesc_" 原因"_" 需要紧急召回"
		s rtn=##class(web.CSSDHUI.Common.Message).Send(Message,"2008",gUser,"","","","",LocId,"",gLocId)
	}
	q RtnObj
}

}
