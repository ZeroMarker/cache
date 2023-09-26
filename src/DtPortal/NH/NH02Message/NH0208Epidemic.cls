/// Description:  护士长传染病服务
/// Creator：     chengpeng
/// CreatDate:    2014-12-4
Class DtPortal.NH.NH02Message.NH0208Epidemic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2014-12-4
/// Description:  查询护士长所辖病区传染病人详细信息
/// 服务代码：    NH02.08.01
/// Table：       DHCMed.EPD.Epidemic
/// Input：       UserCode    :  护士长工号
/// Return：      病人详细信息
/// do ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0208Epidemic","NH020801","059","")
Query NH020801(UserCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,BedNo:%String,PaadmID:%String,EPDDisease:%String,RepDate:%String,RepUserName:%String,StatusDesc:%String,admDocName:%String,admNurseName:%String,diagnoseDesc:%String,inDay:%String,PAPMINo:%String")
{
}

ClassMethod NH020801Execute(ByRef qHandle As %Binary, UserCode As %String, wardId As %String) As %Status
{
	new (qHandle,UserCode,wardId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Q:wardId="" $$$OK
	Set PatPaadmIDList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,wardId)
	for i=1:1:$l(PatPaadmIDList,"^")
	{
		set PaadmID=$p(PatPaadmIDList,"^",i)
		
		Set PatientID=$p($g(^PAADM(+PaadmID)),"^",1)
		continue:PatientID="" 
		
		Set AdmType=""
		For {
			Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
			Quit:AdmType=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
				Quit:Paadm=""
				Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
				Continue:VisitStatus="C"  //取消就诊
				
				set EpidemicID=""
				for
				{
					set EpidemicID=$o(^DHCMed.EPDi("EPD","0","EpisodeID",Paadm,EpidemicID))
					quit:EpidemicID=""
					
					set EpiDataStr=$g(^DHCMed.EPD("EPD",+EpidemicID))
					set EpdStatus=$p(EpiDataStr,"^",15)
				
					continue:EpdStatus=5
					continue:EpdStatus=6
					continue:EpdStatus=7
					continue:EpdStatus=8
					
					set DictionaryID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," EPIDEMICREPORTSTATUS"," "_EpdStatus,""))
					set objDictionary=##class(DHCMed.SS.Dictionary).GetObjById(DictionaryID)
					continue:'$IsObject(objDictionary)
					set StatusDesc=objDictionary.Description							//报告状态
					set ICDID=$p(EpiDataStr,"^",5)										//传染病ID
					set EPDDisease=$p($g(^DHCMed.EPDC("IF",ICDID)),"^",2)				//传染病名称
					set RepDate=$zd($p(EpiDataStr,"^",17),3)							//报告日期
					set RepUserID=$p(EpiDataStr,"^",16)
					set RepUserName=$p($g(^SSU("SSUSR",RepUserID)),"^",2)				//报告人
					
					set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(PaadmID)
					Continue:PatInfo=""
					set Name=$p(PatInfo,"^",2)											//姓名
					set Sex=$p(PatInfo,"^",3)											//性别
					set Age=$p(PatInfo,"^",4)											//年龄
					set MedicareNo=$p(PatInfo,"^",5)									//病案号
					set AdmReason=$p(PatInfo,"^",6)										//费用类别
					set BedNo=$p(PatInfo,"^",1)											//床号																				
			        s admDocName=$p(PatInfo,"^",11)										//主管医生
					s admNurseName=$p(PatInfo,"^",12)									//主管护士
					s PAPMINo=$p(PatInfo,"^",7)    										//登记号
					s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PaadmID)
					s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(PaadmID)
		   
					Set Data=$lb(Name,Sex,Age,MedicareNo,AdmReason,BedNo,PaadmID,EPDDisease,RepDate,RepUserName,StatusDesc,admDocName,admNurseName,diagnoseDesc,inDay,PAPMINo)
					Set ^||CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
		
		
	}
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-08-11
/// Description:  判断病人是否患有传染病报卡
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aEpisodeID     : 患者就诊号
/// Return：      return=0:不是  return=1:是
/// w ##class(DtPortal.NH.NH13Epidemic).IsEPDPat("20")
ClassMethod IsEPDPat(aEpisodeID As %String)
{
	New (aEpisodeID)
	set return=0
	q:aEpisodeID="" return
	
	
	set RowID=""
	for 
	{
		set RowID=$o(^DHCMed.EPDi("EPD","0","EpisodeID",aEpisodeID,RowID)) 
		q:RowID=""
		set EPDStatus=$p($g(^DHCMed.EPD("EPD",RowID)),"^",15)
		Continue:(EPDStatus="5")    //检查报告状态（4:退回）
		Continue:(EPDStatus="6")    //检查报告状态（6:草稿）
		Continue:(EPDStatus="7")    //检查报告状态（7:删除）
		Continue:(EPDStatus="8")    //检查报告状态（7:外院已报）
		set return=1
	} 
	q return
}

}
