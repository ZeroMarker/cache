/// CreateUser: houj
/// CreateDate: 2010-05-27
/// Desc: 病人就诊列表信息
/// Input：argPatientID 病人登记rowid
/// Output：就诊类型（门诊O、急诊E、住院I）、就诊日期、就诊时间、当前科室、主治医生、诊断、出院日期、出院时间
/// Table: /
/// Debug d ##Class(%ResultSet).RunQuery("EPRservice.browser.BOEpisodeInfo","GetPatientList","424","","")
Class EPRservice.browser.BOEpisodeInfo Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/browser";

/// Name of the WebService.
Parameter SERVICENAME = "EpisodeInfo";

Query GetPatientList(argPatientID As %String, argAdmtype As %String, argDiagnosDesc As %String) As %Query(ROWSPEC = "AdmType, AdmDate, AdmTime, CurDept, MainDoc, Diagnosis, DisDate, DisTime,EpisodeID")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, argPatientID As %String, argAdmtype As %String, argDiagnosDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

 	Quit:(argPatientID="") $$$OK
 	
 	//s ^CacheTemp("Debug","GetPatientList","argPatientID")=argPatientID
 	//s ^CacheTemp("Debug","GetPatientList","argAdmtype")=argAdmtype
 	//s ^CacheTemp("Debug","GetPatientList","argDiagnosDesc")=argDiagnosDesc
 
 	//b "s"
 	//初始化返回值
 	s admType = ""
 	for {
 		s admType = $O(^PAPERdr(argPatientID,"ADM",admType))
 		q:(admType="")
 		continue:(admType'[argAdmtype) 

 		s admID = ""
 		for {
	 		s admID = $O(^PAPERdr(argPatientID,"ADM",admType,admID),-1)
	 		q:(admID="")
	 		
	 		s diagnosis = ##class(EPRservice.HISInterface.PatientInfoAssist).DiagnosInfo(admID)
	 		s diagnosis = $P(diagnosis,"^",3)	 		
	 		continue:(diagnosis'[argDiagnosDesc) 
	 		
	 		s admDate = $P($G(^PAADM(admID)),"^",6)
	 		s admTime = $P($G(^PAADM(admID)),"^",7)
	 		s disDate = $P($G(^PAADM(admID)),"^",17)
	 		s disTime = $P($G(^PAADM(admID)),"^",18)	
	 		s visitStatus = $P($G(^PAADM(admID)),"^",20)
	 		s mainDoc =  ##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(admID)
	 		s mainDoc = $P(mainDoc,"^",3)
	 		s curDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(admID)
	 		s curDept = $P(curDept,"^",3)
	 		
	 		set ^CacheTemp(repid,ind)=$LB(admType, admDate, admTime, curDept, mainDoc, diagnosis, disDate, disTime,admID)
	 		s ind = ind + 1
 		}
 	}
 
 	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
 	s qHandle="" 
	Quit $$$OK
}

}
