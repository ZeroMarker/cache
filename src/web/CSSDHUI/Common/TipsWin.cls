Import SQLUser

Class web.CSSDHUI.Common.TipsWin Extends (%RegisteredObject, web.CSSDHUI.CSSDType, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName = "CSSDTIPSWIN";

/// Descript:	工作台提醒
/// Creator:	why
/// CreateDate: 2020-03-10
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:
/// d ##class(web.CSSDHUI.Common.TipsWin).GetTips(^tmpmy("dfrhg"))
ClassMethod GetTips(Params As %String) As %Library.String
{
	n (Params,%session)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("gLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s DateType=PJObj.%Get("DateType")

	i (DateType=1)||(DateType="") d
	.s FStartDate=+$h
	e  i DateType=2 d
	.s FStartDate=+$h-7+1
	e  i DateType=3 d
	.s FStartDate=+$h-30+1
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AppName=..%GetParameter("AppName")
	;配置提示即将过期的天数
	s day=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"WillExpireDays",Param)
	w "{"
	d ..GetTipsDetail(LocId,day,GroupId)
	d ..GetTipsApplyDetail(LocId,GroupId,FStartDate)
	d ..GetTipsPackageDetail(LocId,GroupId,FStartDate)
	w "}"
}

/// w ##Class(web.CSSDHUI.Common.TipsWin).GetAllKindsOfExpiredPkgsCount()
ClassMethod GetAllKindsOfExpiredPkgsCount() As %String [ SqlProc ]
{
	new
	set rtv="0^0^0^0^0"
	s curDate=$p($h,",",1)
	s cnt1=0
	s cnt2=0
	s cnt3=0
	s cnt4=0

	s days=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDTIPSWIN","WillExpireDays")
	&sql(SELECT count(1) into :cnt1 FROM cssd_trans where  (CSSDT_Status='R' or CSSDT_Status='D') and CSSDT_ExpDate-:curDate<0)
	&sql(SELECT count(1) into :cnt2 FROM cssd_trans where  (CSSDT_Status='R' or CSSDT_Status='D') and CSSDT_ExpDate-:curDate< :days AND CSSDT_ExpDate-:curDate>=0 )
	&sql(SELECT count(1) into :cnt3 FROM cssd_trans where  CSSDT_Status='S' and CSSDT_ExpDate-:curDate<0)
	&sql(SELECT count(1) into :cnt4 FROM cssd_trans where  CSSDT_Status='S' and CSSDT_ExpDate-:curDate< :days AND CSSDT_ExpDate-:curDate>=0)

	s rtv=days_"^"_cnt1_"^"_cnt2_"^"_cnt3_"^"_cnt4
	q rtv
}

/// w ##Class(web.CSSDHUI.Common.TipsWin).GetExpiredPkgsCountByLoc()
ClassMethod GetExpiredPkgsCountByLoc(Loc As %String, days As %String) As %String [ SqlProc ]
{
	n (Loc,days,%session)
	set rtv="0^0^0^0^0"
	s curDate=$p($h,",",1)
	s cnt1=0
	s cnt2=0
	s cnt3=0
	s cnt4=0

	&sql(SELECT count(1) into :cnt1 FROM cssd_trans where  (CSSDT_Status='R' or CSSDT_Status='D') and CSSDT_ExpDate-:curDate<0 and  CSSDT_Pack_DR->CSSDPP_Loc_Dr=:Loc)
	&sql(SELECT count(1) into :cnt2 FROM cssd_trans where  (CSSDT_Status='R' or CSSDT_Status='D') and CSSDT_ExpDate-:curDate< :days AND CSSDT_ExpDate-:curDate>=0 and CSSDT_Pack_DR->CSSDPP_Loc_Dr=:Loc)
	&sql(SELECT count(1) into :cnt3 FROM cssd_trans where  CSSDT_Status='S' and CSSDT_ExpDate-:curDate<0 and CSSDT_Pack_DR->CSSDPP_Loc_Dr=:Loc)
	&sql(SELECT count(1) into :cnt4 FROM cssd_trans where  CSSDT_Status='S' and CSSDT_ExpDate-:curDate< :days AND CSSDT_ExpDate-:curDate>=0 and CSSDT_Pack_DR->CSSDPP_Loc_Dr=:Loc)

	s rtv=days_"^"_cnt1_"^"_cnt2_"^"_cnt3_"^"_cnt4
	q rtv
}

///  w ##Class(web.CSSDHUI.Common.TipsWin).GetTipsDetail("396","7","102")
ClassMethod GetTipsDetail(Loc As %String, day As %String, GroupId = "") As %Library.String
{
	n (Loc,day,GroupId,%session)
	i (GroupId="")&&$d(%session) d
	.s GroupId=%session.Data("LOGON.GROUPID")
	
	s Title="App^Info^NodeCaption^NodeUrl^Count"
	w $c(34)_"doc"_$c(34)_":["
	
	s rtv=..GetExpiredPkgsCountByLoc(Loc,day)
	s count=0
	s days=$p(rtv,"^",1)
	s cnt1=$p(rtv,"^",2)
	s cnt2=$p(rtv,"^",3)
	s cnt3=$p(rtv,"^",4)
	s cnt4=$p(rtv,"^",5)
	
	i cnt1>0 d
	.s NodeUrl="cssdhui.packagestat.expirationquery.csp?link=yes&isDisped=1&ndays="
	.s Url="cssdhui.packagestat.expirationquery.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(Url,GroupId)
	.q:NodeInfo=""
	.
	.s reqStr="科室已过期"
	.s NodeCaption="过期包查询"
	.s Data="过期包查询"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_cnt1
	.d isEmpty 
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	i (cnt2>0)&&(days>0) d
	.s NodeUrl="cssdhui.packagestat.expirationquery.csp?link=yes&isDisped=1&ndays="_days_""
	.s Url="cssdhui.packagestat.expirationquery.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(Url,GroupId)
	.q:NodeInfo=""
	.
	.s reqStr="科室即将过期"
	.s NodeCaption="过期包查询"
	.s Data="过期包查询"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_cnt2
	.d isEmpty 
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	i (cnt3>0) d
	.s NodeUrl="cssdhui.packagestat.expirationquery.csp?link=yes&sterFlag=1&ndays="
	.s Url="cssdhui.packagestat.expirationquery.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(Url,GroupId)
	.q:NodeInfo=""
	.
	.s reqStr="供应中心已过期"
	.s NodeCaption="过期包查询"
	.s Data="过期包查询"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_cnt3
	.d isEmpty 
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	i (days>0)&&(cnt4>0) d
	.s NodeUrl="cssdhui.packagestat.expirationquery.csp?link=yes&sterFlag=1&ndays="_days_""
	.s Url="cssdhui.packagestat.expirationquery.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(Url,GroupId)
	.q:NodeInfo=""
	.
	.s reqStr="供应中心即将过期"
	.s NodeCaption="过期包查询"
	.s Data="过期包查询"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_cnt4
	.d isEmpty 
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	w "],"_$c(34)_"doccount"_$c(34)_":"_count
	q
isEmpty
	i count'=0 w ","
	s count=count+1
}

///  工作台显示请领单
///  d ##Class(web.CSSDHUI.Common.TipsWin).GetTipsApplyDetail(396)
ClassMethod GetTipsApplyDetail(Loc As %String, GroupId = "", FStartDate) As %Library.String
{
	n (Loc,GroupId,FStartDate,%session)
	s Title="App^Info^NodeCaption^NodeUrl^Count"
	w ","_$c(34)_"docapply"_$c(34)_":["
	s applycount=0
	s StartDate=..DL2H(FStartDate)
	&sql(SELECT count(*) into:applycount FROM CSSD_PackageApply WHERE CSSDPA_LOCDR=:Loc and CSSDPA_Flag=1 and CSSDPA_CreateDate-:FStartDate>=0)
	i applycount>0 d
	.s NodeUrl="cssdhui.apply.applycheck.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	.s NodeUrl=NodeUrl_"?link=yes&StartDate="_StartDate_""
	.q:NodeInfo=""
	.
	.s reqStr="有"_applycount_"个申请单待确认"
	.s NodeCaption="回收确认"
	.s Data="回收确认"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_applycount
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	s CBDispCount=0
	&sql(select count(1) into :CBDispCount from CSSD_PackageDispMain where CSSDPDM_FromLoc_DR=:Loc and CSSDPDM_ComplateFlag='N' and CSSDPDM_Type='N' and isnull(CSSDPDM_DocType,'')<>'1')
	i CBDispCount>0 d
	.s NodeUrl="cssdhui.packagedisp.disp.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	.q:NodeInfo=""
	.s NodeUrl=NodeUrl_"?link=yes"
	.s reqStr="按单据发放有"_CBDispCount_"个发放单待提交"
	.s NodeCaption="按单据发放"
	.s Data="按单据发放"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_CBDispCount
	.i applycount'=0 w ","
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	s DispCount=0
	&sql(select count(1) into :DispCount from CSSD_PackageDispMain where CSSDPDM_FromLoc_DR=:Loc and CSSDPDM_ComplateFlag='N' and CSSDPDM_Type='Y' and isnull(CSSDPDM_DocType,'')<>'1')
	i DispCount>0 d
	.s NodeUrl="cssdhui.packagedisp.oprdisp.csp"
	.s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	.q:NodeInfo=""
	.s NodeUrl=NodeUrl_"?link=yes"
	.s reqStr="有"_DispCount_"个发放单待提交"
	.s NodeCaption="消毒包发放"
	.s Data="消毒包发放"_"^"_reqStr_"^"_NodeCaption_"^"_NodeUrl_"^"_DispCount
	.i (applycount'=0)||(CBDispCount'=0) w ","
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	w "],"_$c(34)_"docapplycount"_$c(34)_":"_applycount
}

///  w ##Class(web.CSSDHUI.Common.TipsWin).GetTipsPackageDetail(166,102)
ClassMethod GetTipsPackageDetail(LocId, GroupId = "", FStartDate) As %Library.String
{
	n (LocId,GroupId,FStartDate,%session)
	s PId=..NewPid()
	k ^TMPCSSD(PId,"GetTipsPackageDetail")
	
	s DeptCenterID=""
	&sql(SELECT ID INTO:DeptCenterID FROM CSSD_DeptCenter WHERE CSSDD_Loc_DR=:LocId)
	q:DeptCenterID="" ""
	s StartDate=..DL2H(FStartDate)
	s Title="Id^Info^Status^NodeCaption^NodeUrl^Count"
	w ","_$c(34)_"sterilizepackage"_$c(34)_":["
	
	///获取待清洗消毒包
	s BackId=""
	f  s BackId=$o(^User.CSSDCallbackDetailNewD(BackId)) q:BackId=""  d
	.s IsClean=$lg(^User.CSSDCallbackDetailNewD(BackId),10)
	.q:IsClean="Y"
	.s CBMainId=$lg(^User.CSSDCallbackDetailNewD(BackId),2)
	.s CBMainObj=##class(User.CSSDPackageCallback).%OpenId(CBMainId)
	.d CBMainObj.%Reload()
	.s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	.q:LocId'=ToLocId
	.s CBDate=CBMainObj.CSSDPCDate
	.q:CBDate<FStartDate ;显示近一周数据
	.s Status="C"
	.s ^TMPCSSD(PId,"GetTipsPackageDetail",Status)=$i(^TMPCSSD(PId,"GetTipsPackageDetail",Status))
	
	//获取待配包数据
	s CleanId=""
	f  s CleanId=$o(^User.CSSDCleanDetailPacksD(CleanId)) q:CleanId=""  d
	.s IsCrtLbl=$lg(^User.CSSDCleanDetailPacksD(CleanId),7)
	.q:IsCrtLbl="1"
	.s Status=$lg(^User.CSSDCleanDetailPacksD(CleanId),14)
	.q:Status'="Y"
	.s CleanMainId=$lg(^User.CSSDCleanDetailPacksD(CleanId),3)
	.s CleanMainObj=##class(User.CSSDClean).%OpenId(CleanMainId)
	.d CleanMainObj.%Reload()
	.s CleanLocId=CleanMainObj.CSSDCLocDrGetObjectId()
	.q:LocId'=CleanLocId
	.s CleanDate=CleanMainObj.CSSDCDate
	.q:CleanDate<FStartDate
	.s Status="P"
	.s ^TMPCSSD(PId,"GetTipsPackageDetail",Status)=$i(^TMPCSSD(PId,"GetTipsPackageDetail",Status))
	
	///获取待灭菌消毒包
	s PackId=""
	f  s PackId=$o(^User.CSSDPackagePackD(PackId)) q:PackId=""  d
	.s label=$lg(^User.CSSDPackagePackD(PackId),3)
	.s PackDate=$lg(^User.CSSDPackagePackD(PackId),2)
	.s PackLocId=$lg(^User.CSSDPackagePackD(PackId),4)
	.q:LocId'=PackLocId
	.q:PackDate<FStartDate
	.s PackagePack=##Class(User.CSSDPackagePack).%OpenId(PackId)
	.d PackagePack.%Reload()
	.s IsSter=PackagePack.CSSDPPPackage.CSSDPSterType.CSSDSTIsSter
	.q:IsSter="N" ;过滤不需要灭菌的
	.s SteriId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",label,0))
	.q:+SteriId>0
	.s Status="S"
	.s ^TMPCSSD(PId,"GetTipsPackageDetail",Status)=$i(^TMPCSSD(PId,"GetTipsPackageDetail",Status))
	
	///获取待发放消毒包
	s SteriId=""
	f  s SteriId=$o(^User.CSSDPackageSterilizeD(SteriId)) q:SteriId=""  d
	.s label=$lg(^User.CSSDPackageSterilizeD(SteriId),3)
	.s CheckStatus=$lg(^User.CSSDPackageSterilizeD(SteriId),22)
	.q:CheckStatus'="Y"
	.s MainId=$lg(^User.CSSDPackageSterilizeD(SteriId),13)
	.s SterObj=##class(User.CSSDSterilizeRecord).%OpenId(MainId)
	.d SterObj.%Reload()
	.s SterLocId=SterObj.CSSDSRLocDrGetObjectId()
	.q:LocId'=SterLocId
	.s SterDate=SterObj.CSSDSRDate
	.q:SterDate<FStartDate
	.s DispId=$o(^User.CSSDPackageDispI("CSSDPDLabel",label,0))
	.q:DispId'=""
	.s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDLabelIndex",label,0))
	.q:DispDetailId'=""
	.s Status="D"
	.s ^TMPCSSD(PId,"GetTipsPackageDetail",Status)=$i(^TMPCSSD(PId,"GetTipsPackageDetail",Status))
	
	s Status="",Num=0
	f  s Status=$o(^TMPCSSD(PId,"GetTipsPackageDetail",Status)) q:Status=""  d
	.s Count=^TMPCSSD(PId,"GetTipsPackageDetail",Status)
	.s Id="",NodeCaption="",NodeUrl="",Info=""
	.
	.i Status="C" d
	..s NodeUrl="cssdhui.packageclean.cleaninfocollect.csp"
	..s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	..s NodeUrl=NodeUrl_"?link=yes&StartDate="_StartDate_""
	..q:NodeInfo=""
	..
	..;这里补充权限判断
	..s Info="待清洗消毒包明细有"_Count_"条"
	..
	.e  i Status="P" d
	..s NodeUrl="cssdhui.packagepack.cleanpacklabel.csp"
	..s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	..s NodeUrl=NodeUrl_"?link=yes&StartDate="_StartDate_""
	..q:NodeInfo=""
	..
	..s Info="待配包消毒包明细有"_Count_"条"
	..
	.e  i Status="S" d
	..s NodeUrl="cssdhui.packagesterilize.sterilizein.csp"
	..s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	..q:NodeInfo=""
	..s NodeUrl=NodeUrl_"?link=yes&StartDate="_StartDate_""
	..s Info="待灭菌消毒包明细有"_Count_"条"
	..
	.e  i Status="D" d
	..s NodeUrl="cssdhui.packagedisp.oprdisp.csp?link=yes&StartDate="_StartDate_""
	..s NodeInfo=##class(web.CSSDHUI.Main.Menu).GetMenuSecurityByUrl(NodeUrl,GroupId)
	..q:NodeInfo=""
	..
	..s Info="待发放消毒包明细有"_Count_"条"
	.
	.;q:Info=""		;当前工作台用了顺序,这里先全部输出(后续工作台会做整改)
	.s Num=Num+1
	.s Data=Id_"^"_Info_"^"_Status_"^"_NodeCaption_"^"_NodeUrl_"^"_Count
	.i Num>1 w ","
	.w ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	w "]"
	k ^TMPCSSD(PId,"GetTipsPackageDetail")
}

}
