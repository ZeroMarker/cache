Import SQLUser

Class web.CSSDHUI.Common.Tips Extends (%RegisteredObject, web.CSSDHUI.CSSDType, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName = "CSSDTIPSWIN";

/// Descript:	获取人员工作量
/// CreateDate: 2023-04-04
/// Output:
/// w ##class(web.CSSDHUI.Common.Tips).GetPersonWork(^bintmp("CallBack"))
ClassMethod GetPersonWork(Params As %String) As %Library.String
{
	n (Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s DateType=PJObj.%Get("DateType")
	s PAttributeId=PJObj.%Get("AttributeId")

	s Pid=..NewPid()
	k ^TMPCSSD(Pid)
	
	i (DateType=1)||(DateType="") d
	.s FStartDate=+$h
	e  i DateType=2 d
	.s FStartDate=+$h-7+1
	e  i DateType=3 d
	.s FStartDate=+$h-30+1
	s FEndDate=+$h
	s pHospId=""
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Initials As Initials, SSUSR_Name AS Name FROM SS_User where SSUSR_DefaultDept_DR="_gLocId
	s SqlStr1="select othll_parref as RowId, othll_parref->SSUSR_Initials As Initials, othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where othll_ctloc_dr="_gLocId
	s SqlStr=SqlStr_" union "_SqlStr1 
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s UserId=Result.Data("RowId")
		s Initials=Result.Data("Initials")
		s UserName=Result.Data("Name")
		s result = ##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_User",UserId,pHospId)
		continue:result="N"
		s dateFrom = $p(^SSU("SSUSR",UserId),"^",96)
		s dateTo = $p(^SSU("SSUSR",UserId),"^",97)
		s date = +$h
		continue:((dateFrom'="")&&(date<dateFrom))
		continue:((dateTo'="")&&(date>dateTo))
		
		s Sub=$$GetSub(UserId)		;输出排序依据
		s ^TMPCSSD(Pid,Sub)=UserId_"^"_UserName
	}
	d Result.Close()
	
	;遍历各业务数据,记录临时global
	;Glboabl结点: 1-UserId, 2-用户姓名, 3-回收, 4-手工清洗, 5-机器清洗, 6-包装, 7-包装审核, 8-灭菌, 9-发放
	d CallBack(Pid,FStartDate,FEndDate,gLocId,PAttributeId)
	d Clean(Pid,FStartDate,FEndDate,gLocId,PAttributeId)
	d Pack(Pid,FStartDate,FEndDate,gLocId,PAttributeId)
	d Ster(Pid,FStartDate,FEndDate,gLocId,PAttributeId)
	d Disp(Pid,FStartDate,FEndDate,gLocId,PAttributeId)
	
	s UserArr=$$GetArrStr(Pid,2)
	s CBArr=$$GetArrStr(Pid,3)
	s PCleanArr=$$GetArrStr(Pid,4),CleanArr=$$GetArrStr(Pid,5)
	s PackArr=$$GetArrStr(Pid,6),PackAckArr=$$GetArrStr(Pid,7)
	s SterArr=$$GetArrStr(Pid,8)
	s DispArr=$$GetArrStr(Pid,9)
	
	s TitleStr="UserArr^CBArr^PCleanArr^CleanArr^PackArr^PackAckArr^SterArr^DispArr"
	s DataStr=UserArr_"^"_CBArr_"^"_PCleanArr_"^"_CleanArr_"^"_PackArr_"^"_PackAckArr_"^"_SterArr_"^"_DispArr
	s ObjStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q ObjStr

GetArrStr(Pid,Piece)
	n (Pid,Piece)
	s Str=""
	s Count=0
	s Sub=""
	f  s Sub=$o(^TMPCSSD(Pid,Sub)) q:Sub=""  d
	.s Count=Count+1
	.s Data=^TMPCSSD(Pid,Sub)
	.s PieceData=$p(Data,"^",Piece)
	.i (Piece'=1)&&(Piece'=2)&&(PieceData="") s PieceData="null"
	.
	.i Count>1 s Str=Str_","
	.i Piece=2 s Str=Str_""""_PieceData_""""	;名字加引号,数字不加
	.e  s Str=Str_PieceData
	s Str="["_Str_"]"
	q Str
	
/// 人员排序字段
GetSub(UserId)
	s Initials=$p(^SSU("SSUSR",UserId),"^",1)
	q Initials
	
CallBack(Pid,StartDate,EndDate,LocId,PAttributeId)
	n (Pid,StartDate,EndDate,LocId,PAttributeId)
	q:LocId=""
	
	f Date=StartDate:1:EndDate d
	.s CallBackMainId=0
	.f  s CallBackMainId=$o(^User.CSSDPackageCallbackI("CSSDPCDateToLoc",Date,LocId,CallBackMainId)) q:CallBackMainId=""  d
	..s CallBackMainObj=##class(User.CSSDPackageCallback).%OpenId(CallBackMainId)
	..q:'$IsObject(CallBackMainObj)
	..q:'$IsObject(CallBackMainObj.CSSDPCToUserDr)
	..s CBUserId=CallBackMainObj.CSSDPCToUserDrGetObjectId()
	..s CBUserName=$p(^SSU("SSUSR",CBUserId),"^",2)
	..
	..s CallBackQty=0
	..s CallBackItmId=0
	..f  s CallBackItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackMainId,CallBackItmId)) q:CallBackItmId=""  d
	...s CallBackItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackItmId)
	...q:'$IsObject(CallBackItmObj)
	...q:'$IsObject(CallBackItmObj.CSSDCDPackageDr)
	...s Qty=CallBackItmObj.CSSDCDQty				//回收数
	...s AttributeId=CallBackItmObj.CSSDCDPackageDr.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s CallBackQty=CallBackQty+Qty
	..q:CallBackQty=0
	..
	..;3-回收
	..i '$d(^TMPCSSD(Pid,$$GetSub(CBUserId))) s ^TMPCSSD(Pid,$$GetSub(CBUserId))=CBUserId_"^"_CBUserName
	..s $p(^TMPCSSD(Pid,$$GetSub(CBUserId)),"^",3)=CallBackQty+$p(^TMPCSSD(Pid,$$GetSub(CBUserId)),"^",3)
	q
Clean(Pid,StartDate,EndDate,LocId,PAttributeId)
	n (Pid,StartDate,EndDate,LocId,PAttributeId)
	q:LocId=""

	f Date=StartDate:1:EndDate d
	.s CleanId=0
	.f  s CleanId=$o(^User.CSSDCleanI("IndexDateLoc",Date,LocId,CleanId)) q:CleanId=""  d
	..s CleanMainObj=##class(User.CSSDClean).%OpenId(CleanId)
	..q:'$IsObject(CleanMainObj)
	..s CleanUserId=CleanMainObj.CSSDCCleanerGetObjectId()
	..s MachineDr=CleanMainObj.CSSDCMachine
	..q:CleanUserId=""
	..s CleanUserName=$p(^SSU("SSUSR",CleanUserId),"^",2)
	..
	..s CleanQtySum=0
	..s CleanItmId=0
	..f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:CleanItmId=""  d
	...s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	...q:'$IsObject(CleanItmObj)
	...q:'$IsObject(CleanItmObj.CSSDPRPackage)
	...s Qty=CleanItmObj.CSSDCDPQty					//清洗数
	...s AttributeId=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...
	...s CleanQtySum=CleanQtySum+Qty
	..q:CleanQtySum=0
	..
	..;4-手工清洗, 5-机器清洗
	..i '$d(^TMPCSSD(Pid,$$GetSub(CleanUserId))) s ^TMPCSSD(Pid,$$GetSub(CleanUserId))=CleanUserId_"^"_CleanUserName
	..i MachineDr="" s $p(^TMPCSSD(Pid,$$GetSub(CleanUserId)),"^",4)=CleanQtySum+$p(^TMPCSSD(Pid,$$GetSub(CleanUserId)),"^",4)
	..i MachineDr'="" s $p(^TMPCSSD(Pid,$$GetSub(CleanUserId)),"^",5)=CleanQtySum+$p(^TMPCSSD(Pid,$$GetSub(CleanUserId)),"^",5)
	q
Pack(Pid,StartDate,EndDate,LocId,PAttributeId)
	n (Pid,StartDate,EndDate,LocId,PAttributeId)
	q:LocId=""
	
	f Date=StartDate:1:EndDate d
	.s PackId=0
	.f  s PackId=$o(^User.CSSDPackagePackI("IndexCSSDPPAckDate",Date,PackId)) q:PackId=""  d
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..q:'$IsObject(PackObj)
	..q:'$IsObject(PackObj.CSSDPPPackage)
	..s PackLocId=PackObj.CSSDPPLocDrGetObjectId()
	..s Qty=PackObj.CSSDPPQty								//配包数
	..s PackUserId=PackObj.CSSDPPUserDrGetObjectId()		;包装人Id
	..s PackAckUserId=PackObj.CSSDPPAckUserDrGetObjectId()	;包装审核人Id
	..s AttributeId=PackObj.CSSDPPPackage.CSSDPPackTypeDetail
	..q:Qty=0
	..q:PackLocId'=LocId
	..q:(PackUserId="")||(PackAckUserId="")
	..q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	..
	..;6-包装, 7-包装审核
	..s PackUserName=$p(^SSU("SSUSR",PackUserId),"^",2)
	..s PackAckUserName=$p(^SSU("SSUSR",PackAckUserId),"^",2)
	..i '$d(^TMPCSSD(Pid,$$GetSub(PackUserId))) s ^TMPCSSD(Pid,$$GetSub(PackUserId))=PackUserId_"^"_PackUserName
	..i '$d(^TMPCSSD(Pid,$$GetSub(PackAckUserId))) s ^TMPCSSD(Pid,$$GetSub(PackAckUserId))=PackAckUserId_"^"_PackAckUserName
	..s $p(^TMPCSSD(Pid,$$GetSub(PackUserId)),"^",6)=Qty+$p(^TMPCSSD(Pid,$$GetSub(PackUserId)),"^",6)
	..s $p(^TMPCSSD(Pid,$$GetSub(PackAckUserId)),"^",7)=Qty+$p(^TMPCSSD(Pid,$$GetSub(PackAckUserId)),"^",7)
	q
Ster(Pid,StartDate,EndDate,LocId,PAttributeId)
	n (Pid,StartDate,EndDate,LocId,PAttributeId)
	q:LocId=""
	
	f Date=StartDate:1:EndDate d
	.s SterMainId=0
	.f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexDateLoc",Date,LocId,SterMainId)) q:SterMainId=""  d
	..s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	..q:'$IsObject(SterMainObj)
	..q:'$IsObject(SterMainObj.CSSDSRUserDr)
	..s SterUserId=SterMainObj.CSSDSRUserDrGetObjectId()
	..s SterUserName=$p(^SSU("SSUSR",SterUserId),"^",2)
	..
	..s SterQty=0
	..s SterItmId=0
	..f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	...s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	...q:'$IsObject(SterItmObj)
	...q:'$IsObject(SterItmObj.CSSDPSPackage)
	...s Qty=SterItmObj.CSSDPSQty					//灭菌数
	...s AttributeId=SterItmObj.CSSDPSPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s SterQty=SterQty+Qty
	..q:SterQty=0
	..
	..;8-灭菌
	..i '$d(^TMPCSSD(Pid,$$GetSub(SterUserId))) s ^TMPCSSD(Pid,$$GetSub(SterUserId))=SterUserId_"^"_SterUserName
	..s $p(^TMPCSSD(Pid,$$GetSub(SterUserId)),"^",8)=SterQty+$p(^TMPCSSD(Pid,$$GetSub(SterUserId)),"^",8)
	q
Disp(Pid,StartDate,EndDate,LocId,PAttributeId)
	n (Pid,StartDate,EndDate,LocId,PAttributeId)
	q:LocId=""
	
	f Date=StartDate:1:EndDate d
	.s DispMainId=0
	.f  s DispMainId=$o(^User.CSSDPackageDispMainI("DispDateIndex",Date,DispMainId)) q:DispMainId=""  d
	..s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	..q:'$IsObject(DispMainObj)
	..q:'$IsObject(DispMainObj.CSSDPDMFromUserDr)
	..s DispLocId=DispMainObj.CSSDPDMFromLocDrGetObjectId()
	..s DispUserId=DispMainObj.CSSDPDMFromUserDrGetObjectId()
	..q:DispLocId'=LocId
	..s DispUserName=$p(^SSU("SSUSR",DispUserId),"^",2)
	..
	..s DispQty=0
	..s DispItmId=0
	..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispItmId)) q:DispItmId=""  d
	...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
	...q:'$IsObject(DispItmObj)
	...q:'$IsObject(DispItmObj.CSSDPDPackage)
	...s Qty=DispItmObj.CSSDPDDispQty				//发放数
	...s AttributeId=DispItmObj.CSSDPDPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s DispQty=DispQty+Qty
	..q:DispQty=0
	..
	..;9-发放
	..i '$d(^TMPCSSD(Pid,$$GetSub(DispUserId))) s ^TMPCSSD(Pid,$$GetSub(DispUserId))=DispUserId_"^"_DispUserName
	..s $p(^TMPCSSD(Pid,$$GetSub(DispUserId)),"^",9)=DispQty+$p(^TMPCSSD(Pid,$$GetSub(DispUserId)),"^",9)
	q
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Tips","QueryPkgSum",^bintmp(262))
/// call web_CSSDHUI_Common.Tips_QueryPkgSum(^bintmp(262))
Query QueryPkgSum(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "Type,Qty:%Integer") [ SqlProc ]
{
}

ClassMethod QueryPkgSumExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s DateType=PJObj.%Get("DateType")
	s PAttributeId=PJObj.%Get("AttributeId")
	q:gLocId="" $$$OK
	
	i (DateType=1)||(DateType="") d
	.s FStartDate=+$h
	e  i DateType=2 d
	.s FStartDate=+$h-7+1
	e  i DateType=3 d
	.s FStartDate=+$h-30+1
	s FEndDate=+$h
	
	f Date=FStartDate:1:FEndDate d
	.
	.s CallBackMainId=0,PkgQty=0
	.f  s CallBackMainId=$o(^User.CSSDPackageCallbackI("CSSDPCDateToLoc",Date,gLocId,CallBackMainId)) q:CallBackMainId=""  d
	..s CallBackMainObj=##class(User.CSSDPackageCallback).%OpenId(CallBackMainId)
	..q:'$IsObject(CallBackMainObj)
	..q:'$IsObject(CallBackMainObj.CSSDPCToUserDr)
	..
	..s CallBackItmId=0
	..f  s CallBackItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackMainId,CallBackItmId)) q:CallBackItmId=""  d
	...s CallBackItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackItmId)
	...q:'$IsObject(CallBackItmObj)
	...q:'$IsObject(CallBackItmObj.CSSDCDPackageDr)
	...s Qty=CallBackItmObj.CSSDCDQty				//回收数
	...s AttributeId=CallBackItmObj.CSSDCDPackageDr.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s PkgQty=PkgQty+Qty
	.s Type="回收"
	.d OutputRowData
	.
	.s (PCleanQty,CleanQty)=0
	.s CleanMainId=0
	.f  s CleanMainId=$o(^User.CSSDCleanI("IndexDateLoc",Date,gLocId,CleanMainId)) q:CleanMainId=""  d
	..s CleanMainObj=##class(User.CSSDClean).%OpenId(CleanMainId)
	..q:'$IsObject(CleanMainObj)
	..q:'$IsObject(CleanMainObj.CSSDCCleaner)
	..s LocId=CleanMainObj.CSSDCLocDrGetObjectId()
	..s MachineDr=CleanMainObj.CSSDCMachine
	..
	..s CleanItmId=0
	..f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanMainId,CleanItmId)) q:CleanItmId=""  d
	...s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	...q:'$IsObject(CleanItmObj)
	...q:'$IsObject(CleanItmObj.CSSDPRPackage)
	...s Qty=CleanItmObj.CSSDCDPQty					//清洗数
	...s AttributeId=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...
	...i MachineDr="" s PCleanQty=PCleanQty+Qty
	...e  s CleanQty=CleanQty+Qty
	.s Type="机器清洗",PkgQty=CleanQty
	.d OutputRowData
	.s Type="手工清洗",PkgQty=PCleanQty
	.d OutputRowData
	.
	.
	.s PackId=0,PkgQty=0
	.f  s PackId=$o(^User.CSSDPackagePackI("IndexCSSDPPAckDate",Date,PackId)) q:PackId=""  d
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..q:'$IsObject(PackObj)
	..q:'$IsObject(PackObj.CSSDPPAckUserDr)
	..q:'$IsObject(PackObj.CSSDPPPackage)
	..s LocId=PackObj.CSSDPPLocDrGetObjectId()
	..s Qty=PackObj.CSSDPPQty							//配包数
	..s AttributeId=PackObj.CSSDPPPackage.CSSDPPackTypeDetail
	..q:(gLocId'="")&&(gLocId'=LocId)
	..q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	..s PkgQty=PkgQty+Qty
	.s Type="打包"
	.d OutputRowData
	.
	.s SterMainId=0,PkgQty=0
	.f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexDateLoc",Date,gLocId,SterMainId)) q:SterMainId=""  d
	..s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	..q:'$IsObject(SterMainObj)
	..q:'$IsObject(SterMainObj.CSSDSRUserDr)
	..
	..s SterItmId=0
	..f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	...s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	...q:'$IsObject(SterItmObj)
	...q:'$IsObject(SterItmObj.CSSDPSPackage)
	...s Qty=SterItmObj.CSSDPSQty					//灭菌数
	...s AttributeId=SterItmObj.CSSDPSPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s PkgQty=PkgQty+Qty
	.s Type="灭菌"
	.d OutputRowData
	.
	.s DispMainId=0,PkgQty=0
	.f  s DispMainId=$o(^User.CSSDPackageDispMainI("DispDateIndex",Date,DispMainId)) q:DispMainId=""  d
	..s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	..q:'$IsObject(DispMainObj)
	..q:'$IsObject(DispMainObj.CSSDPDMFromUserDr)
	..s LocId=DispMainObj.CSSDPDMFromLocDrGetObjectId()
	..q:(gLocId'="")&&(gLocId'=LocId)
	..s DispItmId=0
	..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispItmId)) q:DispItmId=""  d
	...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
	...q:'$IsObject(DispItmObj)
	...q:'$IsObject(DispItmObj.CSSDPDPackage)
	...s Qty=DispItmObj.CSSDPDDispQty				//发放数
	...s AttributeId=DispItmObj.CSSDPDPackage.CSSDPPackTypeDetail
	...q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	...s PkgQty=PkgQty+Qty
	.s Type="发放"
	.d OutputRowData
	
	Quit $$$OK
OutputRowData
	q:PkgQty=0
	s Data=$lb(Type,PkgQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
