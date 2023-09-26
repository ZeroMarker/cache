/// 名称:DtPortal.NH.NH02Message.NH0206CVReports
/// 描述:查询护士长今日提示危急值服务
/// 编写者：shp
/// 编写日期: 2014-12-04
Class DtPortal.NH.NH02Message.NH0206CVReports Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称:DtPortal.NH.NH02CVReports
/// CreatDate： 2014-12-04
/// Description: 查询护士长今日提示危急值服务
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.06.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0206CVReports","NH020601","059","")
Query NH020601(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedno:%String,name:%String,age:%String,sex:%String,regno:%String,RType:%String,Summary:%String,RepTime:%String,RepUser:%String,TransStatus:%String,AtendDoc:%String,AtendNurse:%String,admreason:%String,mrno:%String,inhospday:%String,diagnos:%String,ReportType:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02CVReports","CVReports","059")
ClassMethod NH020601Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	if $g(ind)="" Set ind=1
	Quit:wardId="" $$$OK
	Set OrdLoc=$p(^PAWARD(wardId),"^",5)
	s stdate=$zd(+$h,3)
	s eddate=$zd(+$h,3)
	s type="C^F"

	s len=$l(type,"^")
	f n=1:1:len  d
	.s status=$p(type,"^",n)
	.f RType=1:1:6   d
	..s objCV=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
	..d objCV.Execute(stdate,eddate,OrdLoc,status,"I",RType)
	..f  Quit:'objCV.Next()  d
	...s (bedno,name,age,sex,regno,TransStatus,Summary,RepTime,RepUser,TransStatus,AtendDoc,AtendNurse,admreason,mrno,inhospday,diagnos,adm,ReportType)=""
	...s adm=objCV.Data("adm")
	...s patinfo=##class(DtPortal.Common.PaadmService).GetPatInfo(adm)
	...s bedno=$p(patinfo,"^",1)
	...s name=$p(patinfo,"^",2)
	...s age=$p(patinfo,"^",4)
	...s sex=$p(patinfo,"^",3)
	...s mrno=$p(patinfo,"^",5)
	...s admreason=$p(patinfo,"^",6)
	...s regno=$p(patinfo,"^",7)
	...s AtendDoc=$p(patinfo,"^",11)
	...s AtendNurse=$p(patinfo,"^",12)
	...s diagnos=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(adm)
	...s inhospday=##class(DtPortal.Common.PaadmService).getInDayByInPat(adm)
	...s RType=objCV.Data("ReportType")
	...s ReportID=objCV.Data("ReportId")
	...s Summary=objCV.Data("DPRPResult")			//危急值报告信息

	...s RepTime=$P(^DHCAntCVReport(RType,$P(ReportID,"||",1),$P(ReportID,"||",2)),"\",2)
	...s RepTime=$zt(RepTime,2)
	...s RepUserId=$P(^DHCAntCVReport(RType,$P(ReportID,"||",1),$P(ReportID,"||",2)),"\",3)
	...i RepUserId'="" s RepUser=$p(^SSU("SSUSR",RepUserId),"^",2)
	...s TransStatus=$s(status="C":"未处理",status="F":"已处理")
	...s ReportType=$S(RType=1:"检验",RType=2:"病理",RType=3:"心电",RType=4:"超声",RType=5:"内镜",RType=6:"放射")
	...d outputinfo 
	
 
  	q $$$OK
outputinfo
    s Data=$lb(bedno,name,age,sex,regno,TransStatus,Summary,RepTime,RepUser,TransStatus,AtendDoc,AtendNurse,admreason,mrno,inhospday,diagnos,ReportType)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
