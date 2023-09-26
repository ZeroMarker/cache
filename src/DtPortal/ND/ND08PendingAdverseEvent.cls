/// description:待处理不良事件表格
Class DtPortal.ND.ND08PendingAdverseEvent Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate：  2018.12.16
/// Description:待处理不良事件列表
/// Input：          
/// Return：
/// 服务编码：ND08.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND08PendingAdverseEvent","ND080101","1496")	
Query ND080101(userCode As %String) As DtPortal.Query(ROWSPEC = "typeid,desc,subdesc,emrdate,emrtime,locdr,locdesc,statusdesc,reportid,statuscode,recaudituser,recauditdate,eventInfo,diagnosis,recordr,stausdr,receivedr,statuslast,statuslastid,statusnext,statusnextid,repappauditflag,userleadflag,fileflag,stafistaudituser,userId,stsusgrant")
{
}

ClassMethod ND080101Execute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	//n (qHandle,userCode)
 	Set repid=$I(^||CacheTemp)
 	s ind=1
	
	s startDate=$zd(+$h-30,3)
	s endDate=$zd(+$h,3)
	s userId=""
	i userCode'=""  s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	s wardId="all"
	s typeId=""
	s NurStatus="S"
	//Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	//Do object.Execute(startDate,endDate,wardId,typeId,userId,"A","H","",NurStatus,"")
	Set object = ##class(%ResultSet).%New("DtPortal.ND.ND07AdverseEvent:ND070103")
	Do object.Execute(startDate,endDate,typeId,wardId,userCode,"A","H","",NurStatus,"")
	b
	k AdverseEventTrend($j)
	s allMonth=""
	While (object.Next()) {
		s typeid=object.Data("typeid")
		s desc=object.Data("desc")
		s subdesc=object.Data("subdesc")
		s emrdate=object.Data("emrdate")
		continue:emrdate=""||($l(emrdate,"-")'=3)
		s emrtime=object.Data("emrtime")
		s subdesc=object.Data("subdesc")
		s locdr=object.Data("locdr")
		continue:+locdr=0
		//s EpisodeId=object.Data("EpisodeId")
		s locdesc=object.Data("locdesc")
		s statusdesc=object.Data("statusdesc")
		s reportid=object.Data("reportid")
		s statuscode=object.Data("statuscode")
		s recaudituser=object.Data("recaudituser")
		s recauditdate=object.Data("recauditdate")
		s eventInfo=object.Data("eventInfo")
		s recordr=object.Data("recordr")
		s stausdr=object.Data("stausdr")
		s receivedr=object.Data("receivedr")
		s statuslast=object.Data("statuslast")
		s statuslastid=object.Data("statuslastid")
		s statusnext=object.Data("statusnext")
		s statusnextid=object.Data("statusnextid")
		s repappauditflag=object.Data("repappauditflag")
		s userleadflag=object.Data("userleadflag")
		s fileflag=object.Data("fileflag")
		s stafistaudituser=object.Data("stafistaudituser")
		s stsusgrant=object.Data("stsusgrant")
		s diagnosis=object.Data("diagnosis")
		
		/*
		s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
		s bed=$p(patInfoStr,"^",1)
 		//s Name=$p(patInfoStr,"^",2)
 		s sex=$p(patInfoStr,"^",3)
 		s age=$p(patInfoStr,"^",4)
 		s medicalNo=$p(patInfoStr,"^",5)   //病案号
 		*/
		d ND080101
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ND080101
	set Data=$lb(typeid,desc,subdesc,emrdate,emrtime,locdr,locdesc,statusdesc,reportid,statuscode,recaudituser,recauditdate,eventInfo,diagnosis,recordr,stausdr,receivedr,statuslast,statuslastid,statusnext,statusnextid,repappauditflag,userleadflag,fileflag,stafistaudituser,userId,stsusgrant)
 	Set ^||CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
