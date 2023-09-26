/// 名称:DtPortal.DD.DD34Consultation
/// 描述:科主任会诊服务
/// 编写者：yupeng
/// 编写日期: 2018-12-24
Class DtPortal.DD.DD34Consultation Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     bmz
/// CreatDate：   2018-12-25
/// Description:  MD34.01.01统计用户会诊数量
/// Table：       DHC_Consultation
/// Input：        findType  R-按申请科室统计 C-按会诊科室统计
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD34Consultation","DD340101","ys01","I*110||O*","R","2018","2018")
Query DD340101(UserCode As %String, locGroupID As %String, findType As %String = "", startDate As %String = "", endDate As %String = "") As DtPortal.Query(ROWSPEC = "date,UnComNum,FENum,OverFENum")
{
}

ClassMethod DD340101Execute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, findType As %String = "", startDate As %String = "", endDate As %String = "") As %Status
{
	n (qHandle,UserCode,locGroupID,findType,startDate,endDate)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s mode="H"
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	q:DocLocStr="" $$$OK
	s DocLocStr=$tr(DocLocStr,"^",",")
	i (findType'="R")&&(findType'="C") Quit $$$OK
	
	s dateType="byMonth"
	s kpiRule=""
	S filterRule=""
	if (findType="R") {
		s kpiRule="DtPortal0005:conType"
		S filterRule="DtPortal0005:({ResLoc.LocId}="_DocLocStr_")"
	}elseif(findType="C"){
		s kpiRule="DtPortal0005:conType"
		S filterRule="DtPortal0005:({RecLoc.LocId}="_DocLocStr_")"
	}
	k ^TEMPDHCWL($j)
	s ^TEMPDHCWL($j,startDate_"年01月","UnCom")=0,^TEMPDHCWL($j,startDate_"年01月","FE")=0,^TEMPDHCWL($j,startDate_"年01月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年02月","UnCom")=0,^TEMPDHCWL($j,startDate_"年02月","FE")=0,^TEMPDHCWL($j,startDate_"年02月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年03月","UnCom")=0,^TEMPDHCWL($j,startDate_"年03月","FE")=0,^TEMPDHCWL($j,startDate_"年03月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年04月","UnCom")=0,^TEMPDHCWL($j,startDate_"年04月","FE")=0,^TEMPDHCWL($j,startDate_"年04月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年05月","UnCom")=0,^TEMPDHCWL($j,startDate_"年05月","FE")=0,^TEMPDHCWL($j,startDate_"年05月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年06月","UnCom")=0,^TEMPDHCWL($j,startDate_"年06月","FE")=0,^TEMPDHCWL($j,startDate_"年06月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年07月","UnCom")=0,^TEMPDHCWL($j,startDate_"年07月","FE")=0,^TEMPDHCWL($j,startDate_"年07月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年08月","UnCom")=0,^TEMPDHCWL($j,startDate_"年08月","FE")=0,^TEMPDHCWL($j,startDate_"年08月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年09月","UnCom")=0,^TEMPDHCWL($j,startDate_"年09月","FE")=0,^TEMPDHCWL($j,startDate_"年09月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年10月","UnCom")=0,^TEMPDHCWL($j,startDate_"年10月","FE")=0,^TEMPDHCWL($j,startDate_"年10月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年11月","UnCom")=0,^TEMPDHCWL($j,startDate_"年11月","FE")=0,^TEMPDHCWL($j,startDate_"年11月","OverFE")=0
	s ^TEMPDHCWL($j,startDate_"年12月","UnCom")=0,^TEMPDHCWL($j,startDate_"年12月","FE")=0,^TEMPDHCWL($j,startDate_"年12月","OverFE")=0

	s endDate=startDate
	s startDate=startDate_"-01"
	s endDate=endDate_"-12"
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,"")

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit

		s date=rs.Data("month")
		set conType=$g(rs.Data("dimIdCol1"))
		continue:conType=""
		if (conType="1"){
			s ^TEMPDHCWL($j,date,"UnCom")=$g(^TEMPDHCWL($j,date,"UnCom"))+rs.Data("kpiValueCol1")
		}elseif(conType="2"){
			s ^TEMPDHCWL($j,date,"FE")=$g(^TEMPDHCWL($j,date,"FE"))+rs.Data("kpiValueCol1")
		}elseif(conType="3"){
			s ^TEMPDHCWL($j,date,"OverFE")=$g(^TEMPDHCWL($j,date,"OverFE"))+rs.Data("kpiValueCol1")
		}

	}
	s SDate="" f  s SDate=$o(^TEMPDHCWL($j,SDate)) q:SDate=""  d
	.s lastmonth=$p($p(SDate,"年",2),"月",1)
	.s nowmonth=$p($zd($p($h,",",1),3),"-",2)
	.s lastyear=$p(SDate,"年",1)
	.s nowyear=$p($zd($p($h,",",1),3),"-",1)
	.i lastyear=nowyear q:lastmonth>nowmonth
	.s date=lastyear_"-"_lastmonth
	.s UnComNum=$g(^TEMPDHCWL($j,SDate,"UnCom"))
	.s FENum=$g(^TEMPDHCWL($j,SDate,"FE"))
	.s OverFENum=$g(^TEMPDHCWL($j,SDate,"OverFE"))
	.s ^||CacheTemp(repid,ind)=$lb(date,UnComNum,FENum,OverFENum)
	.s ind=ind+1
	k ^TEMPDHCWL($j)
	
	
	
	Quit $$$OK
}

/// Creator：     bmz
/// CreatDate：   2018-12-25
/// Description:  MD34.01.01统计用户会诊数量
/// Table：       DHC_Consultation
/// Input：        findType  R-按申请科室统计 C-按会诊科室统计  otherType:UnCom未完成，FE代表48小时内完成，OverFE超过48小时完成
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD34Consultation","DD340102","ys01","I*110||O*","R","2018-12-01","2018-12-31","All")
Query DD340102(UserCode As %String, locGroupID As %String, findType As %String = "", startDate As %String = "", endDate As %String = "", otherType As %String = "") As DtPortal.Query(ROWSPEC = "name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc")
{
}

ClassMethod DD340102Execute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, findType As %String = "", startDate As %String = "", endDate As %String = "", otherType As %String = "") As %Status
{
	n (qHandle,UserCode,locGroupID,findType,startDate,endDate,otherType)
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s mode="H"
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	q:DocLocStr="" $$$OK
	
	i (findType'="R")&&(findType'="C") Quit $$$OK
	
	//不查询当天的数据
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	if (EDate>=+$h) {
		s EDate=(+$h-1)
	}
	if (SDate>EDate){
		Quit $$$OK
	}
	
	s ConStatusCodeFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE")
	s ConStatusCodeNotFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE")
	set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
	d obj.Execute("","",startDate,endDate,"","R")
	f  Quit:'obj.Next()  d               
	.s ConsultId=obj.Data("CsItmID")
	.s CsStatCode=obj.Data("CsStatCode")  
	.;i ConsultId="286||1" b ;286
	.//从配置的完成、未完成中过滤
	.q:('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))&&('$LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode))
	.s CstRLocID=obj.Data("CstRLocID")    //申请科室 
	.s CsLocID=obj.Data("CsLocID")    //会诊科室
	.q:(CstRLocID="")||(CsLocID="")
	.//w !,ConsultId_"&&"_locGroupID_"---"_CstRLocID
	.//i CstRLocID'="176" b ;286
	.q:(findType="R")&&'$LF($LISTFROMSTRING(locGroupID,"^"),CstRLocID)
	.q:(findType="C")&&'$LF($LISTFROMSTRING(locGroupID,"^"),CsLocID)
	.s CstDocID=""
	.//会诊医生的数据，从完成状态中取
	.i $LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode) s CstDocID=$p($g(^DHCEMCON($p(ConsultId,"||",1),"I",$p(ConsultId,"||",2))),"^",2)     /// 会诊医生
	.s appDate=obj.Data("CstRDate") //会诊申请时间 
	.s appTime=obj.Data("CstRTime")
	.s conDate=obj.Data("CstNDate") 	//会诊日期
	.s conTime=obj.Data("CstNTime")		//会诊时间
	.;b ;09
	
	.i appDate'="" s appDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(appDate),3)
	.i appTime'="" s appTime=$zth(appTime)
	.i conDate'="" s conDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(conDate),3)
	.i conTime'="" s conTime=$zth(conTime)
	
	.s numTemp="" //会诊时长
	.s ifOverFe=""
	.s secondNum=0
	.i (conDate'="")&&(conTime'="") d
	..s secondNum=(conDate-appDate)*24*3600+(conTime-appTime)
	.s admId=obj.Data("EpisodeID")				//病人就诊ID
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
	.s bedNo=$p(patInfoStr,"^",1)
	.s medicalNo=$p(patInfoStr,"^",5)
	.s name=$p(patInfoStr,"^",2)
	.s sex=$p(patInfoStr,"^",3)
	.s age=$p(patInfoStr,"^",4)
	.s admReason=$p(patInfoStr,"^",6)
	.s appLocId=CstRLocID
	.s applyLocDesc=$p($g(^CTLOC(appLocId)),"^",2)
	.i applyLocDesc["-" s applyLocDesc=$p(applyLocDesc,"-",2)
	.s applyDcotor=obj.Data("CstRUser")  //申请医生        
	.s applyTime=$zd(appDate,3)_"&nbsp;"_$zt(appTime)
	.s consultDcotor=obj.Data("CsUser")  //会诊医生 
	.s consultLocId=CsLocID
	.s consultLocDesc=$p($g(^CTLOC(consultLocId)),"^",2)
	.i consultLocDesc["-" s consultLocDesc=$p(consultLocDesc,"-",2)
	.s consultTime=""
	.i conDate'="" s consultTime=$zd(conDate,3)_"&nbsp;"_$zt(conTime)
	.s timeLength=##Class(DtPortal.MD.MD36Consultation).getTimeNum(secondNum)
	.s consultId=ConsultId
	.//i ConsultId="286||1" b ;286
	.s patientId=$P($g(^PAADM(admId)),"^",1)
	.s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)    //取诊断
	.s CsStatDesc=obj.Data("CsStatDesc")  
	.s ^||CacheTemp(repid,ind)=$lb(name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc)
	.s ind=ind+1
	
	
	
	/*
	for index=1:1:$l(DocLocStr,"^")
	{
		set DocLoc=$p(DocLocStr,"^",index)
		continue:DocLoc=""
		set (name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc)=""
		set obj=##class(%ResultSet).%New("DtPortal.MD.MD36Consultation:MD360103")
		d obj.Execute(startDate,endDate,findType,otherType,DocLoc,"0")
		f  Quit:'obj.Next()  d              
		.s name=obj.Data("name")
		.s sex=obj.Data("sex")  
		.s age=obj.Data("age")
		.s medicalNo=obj.Data("medicalNo")
		.s applyLocDesc=obj.Data("applyLocDesc")
		.s applyTime=obj.Data("applyTime")
		.s applyDcotor=obj.Data("applyDcotor")
		.s consultDcotor=obj.Data("consultDcotor")
		.s consultLocDesc=obj.Data("consultLocDesc")
		.s consultTime=obj.Data("consultTime")
		.s timeLength=obj.Data("timeLength")
		.s consultId=obj.Data("consultId")
		.s diagnosis=obj.Data("diagnosis")
		.s patientId=obj.Data("patientId")
		.s admId=obj.Data("admId")
		.s CsStatDesc=obj.Data("CsStatDesc")
		.s ^||CacheTemp(repid,ind)=$lb(name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc)
		.s ind=ind+1
	}
	*/
	
	Quit $$$OK
}

}
