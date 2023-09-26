/// 名称: DHCMed.INFService.RepCtlAppSrv
/// 描述:  院感监控评价Srv
/// 编写者：ChenJB
/// 编写日期: 2010-10-28
Class DHCMed.INFService.RepCtlAppSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPaadmApp(Paadm As %String = "") As %String
{
    n (Paadm)	
	s ret=""
	q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-10-15
/// Description:  查询评价列表
/// Table：       DHCMed.INF.*
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.RepCtlAppSrv","QueryPaadmApp","51104")
Query QueryPaadmApp(Paadm As %String) As %Query(ROWSPEC = "Paadm:%String,Rowid:%String,Points:%String:分数,Width:%String:宽度,DtStr:%String:评价时间,DiaDesc1:%String:初评诊断,DiaDesc2:%String:终评诊断,AppAll:%String:评价信息,AppStatus:%String:评价状态,Resume:%String:备注")
{
}

ClassMethod QueryPaadmAppExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:Paadm="" $$$OK
	// ^DHCMed.INF.RepCtlAppI("Paadm",val,rowid)
	s Rowid=0
	f  s Rowid=$o(^DHCMed.INF.RepCtlAppI("Paadm",Paadm,Rowid)) q:+Rowid=0  d
	.s objApp=##class(DHCMed.INF.RepCtlApp).GetObjById(Rowid)
	.q:'$IsObject(objApp)
	.s Points=objApp.Points
	.s Width=objApp.Width
	.s CtlDate=$zd(+objApp.CtlDate,3)
	.s AppDate=""
	.s:+objApp.AppDate'=0 AppDate=$zd(+objApp.AppDate,3)
	.s DtStr="初评日期:"_CtlDate_"<br>"_"终评日期:"_AppDate
	.s DiaDesc1=objApp.InfDiaginos1
	.i DiaDesc1'=""  d
	..s objDia1=##class(DHCMed.INF.InfDiagnose).GetObjById(DiaDesc1)
	..s:$IsObject(objDia1) DiaDesc1=objDia1.DiseaseName
	.s DiaDesc2=objApp.InfDiaginos2
	.i DiaDesc2'=""  d
	..s objDia2=##class(DHCMed.INF.InfDiagnose).GetObjById(DiaDesc2)
	..s:$IsObject(objDia2) DiaDesc2=objDia2.DiseaseName
	.s AppAll=""                       //评价信息
	.s DiagnoseApp=objApp.DiagnoseApp
	.i DiagnoseApp'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DiagnoseApp,"InfectionDiagnoseEvaluation")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..s:$IsObject(objDic) DiagnoseApp=objDic.Description
	.s ReportApp=objApp.ReportApp
	.i ReportApp'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ReportApp,"InfectionReportEvaluation")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s:$IsObject(objDic) ReportApp=objDic.Description
	.s NatureApp=objApp.NatureApp
	.i NatureApp'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(NatureApp,"InfectionReportQuality")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s:$IsObject(objDic) NatureApp=objDic.Description
	.s AppAll="诊断评价:"_DiagnoseApp_"<br>"_"报告评价:"_ReportApp_"<br>"_"性质评价:"_NatureApp
	.//Desc find
	.s AppStatus=objApp.AppStatus
	.i AppStatus'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(AppStatus,"InfectionEvaluationStatus")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s:$IsObject(objDic) AppStatus=objDic.Description
	.s Resume=objApp.Resume
	.s Data=$lb(Paadm,Rowid,Points,Width,DtStr,DiaDesc1,DiaDesc2,AppAll,AppStatus,Resume)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryPaadmAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPaadmAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPaadmAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPaadmAppExecute ]
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

/// Creator：     刘宇辉
/// CreatDate：   2011-01-29
/// Description:  查询评价列表
/// Table：       DHCMed.INF.*
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.RepCtlAppSrv","QueryAppInfo","","","","")
Query QueryAppInfo(StrDate As %String, EndDate As %String, Ctloc As %String, Ward As %String) As %Query(ROWSPEC = "ind:%String,PatID:%String,PatName:%String,InfDiagnose:%String,CtlContents:%String,CtlUserDsec:%String,CtlDate:%String,CtlocDesc:%String,WardDesc:%String")
{
}

ClassMethod QueryAppInfoExecute(ByRef qHandle As %Binary, StrDate As %String, EndDate As %String, Ctloc As %String, Ward As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:StrDate["-" StrDate=$zdh(StrDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StrDate["/" StrDate=$zdh(StrDate)
	s:EndDate["/" EndDate=$zdh(EndDate)
	s rowid=""
	f  s rowid=$o(^DHCMed.INF.RepCtlAppD(rowid)) q:rowid=""  d
	.s objApp=##class(DHCMed.INF.RepCtlApp).GetObjById(rowid)
	.q:'$IsObject(objApp)
	.s CtlDate=objApp.CtlDate
	.q:((StrDate'="")&(StrDate>CtlDate))
	.q:((EndDate'="")&(EndDate<CtlDate))
	.s PaadmDR=objApp.PaadmDR
	.q:PaadmDR=""
	.s CurCtlocDR=$p($g(^PAADM(PaadmDR)),"^",4)
	.s CurWardDR=$p($g(^PAADM(PaadmDR)),"^",70)
	.q:((Ctloc'="")&(Ctloc'=CurCtlocDR))
	.q:((Ward'="")&(Ward'=CurWardDR))
	.s CtlocDesc=$p($g(^CTLOC(CurCtlocDR)),"^",2)	//科室
	.s:CtlocDesc["-" CtlocDesc=$p(CtlocDesc,"-",2)
	.s WardDesc=$p($g(^PAWARD(CurWardDR)),"^",2)	//病区
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s papmi=$p($g(^PAADM(PaadmDR)),"^",1)
	.s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)	//姓名
	.s PatID=$p($g(^PAPER(papmi,"PAT",1)),"^",1)	//登记号
	.s InfDiagnoseDR=objApp.InfDiaginos1	
	.s objDia=##class(DHCMed.INF.InfDiagnose).GetObjById(InfDiagnoseDR)
	.s InfDiagnose=objDia.DiseaseName		//初步诊断
	.s CtlDate=objApp.CtlDate
	.s:CtlDate'="" CtlDate=$zd(CtlDate,3)	//初评日期
	.s CtlContents=objApp.CtlContents	//评价依据
	.s CtlUser=objApp.CtlUser
	.s CtlUserDsec=$p($g(^SSU("SSUSR",CtlUser)),"^",2)	//监控人
	.s Data=$lb(ind,PatID,PatName,InfDiagnose,CtlContents,CtlUserDsec,CtlDate,CtlocDesc,WardDesc)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryAppInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAppInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppInfoExecute ]
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

}
