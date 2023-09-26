Class web.DHCEMPatCard Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CreatDate: 2016.08.22
/// Creator: lvpeng
/// Description:   获取打印各项所需数据    
/// input:
/// output:          
/// Other:w ##class(web.DHCEMPatCard).getData("119")
ClassMethod getData(EpisodeID As %String) As %String
{
   
	s PatName="",PatSex="",PatInDep="",PatSeat="",PatAge="",PatRegNo="",PatYear="",PatMon="",PatDay="",PatHour="",PatMin="",PatDiagnose=""
	if EpisodeID="" q ""
	//w ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc("1",",")
	s PatDiagnose=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	;s deplocdr=$p(^PAADM(EpisodeID),"^",4)
    ;s PatInDep=$p(^CTLOC(deplocdr),"^",2)
    ;i PatInDep["-" s PatInDep=$p(PatInDep,"-",2) ///就诊科室
    set PatInfo=..GetPatInfo(EpisodeID)
	set PatName=$p(PatInfo,"^",2)				//姓名
	set PatSex=$p(PatInfo,"^",3)				//性别
	set PatAge=$p(PatInfo,"^",4)				//年龄
	;set PatNum=$p(PatInfo,"^",5)				//病案号
	set PatCost=$p(PatInfo,"^",6)				//费用类别
	;set PatSeat=$p(PatInfo,"^",1)				//床号	
	;s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	;s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	;s PatSeat=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
	;s PatSeat=$p(PatInfo,"^",1)				
	set PatRegNo=$p(PatInfo,"^",7)			//登记号
    //调用统一取入院时间的接口
	;s inDateTimeStr=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	s Date=$p(^PAADM(EpisodeID),"^",6)
	s PatDate=$zd(Date,3)
	;s PatYear=$p(PatDate,"-",1)
	;s PatMon=$p(PatDate,"-",2)
	;s PatDay=$p(PatDate,"-",3)
	s Time=$p(^PAADM(EpisodeID),"^",7)
	s PatTime=$zt(Time,2)
	s PatYear=PatDate_"  "_PatTime
	;s PatHour=$p(PatTime,":",1)
	;s PatMin=$p(PatTime,":",2)
	s loc=%session.Get("LOGON.CTLOCID")
	;s seatsyID=$o(^User.DHCNurSyPatRecI("patseat"," "_loc," "_EpisodeID,""),-1)
	;s seatDr=$list(^User.DHCNurSyPatRecD(seatsyID),5)
	;s SySeatCode=$list(^User.DHCNurSySeatD(seatDr),3)
	;s SySeatDes=$list(^User.DHCNurSySeatD(seatDr),4)
	;s SEChildSub=$o(^DHCEMPSE(0,"Code",SySeatDes,SySeatCode,""))
	;s PatSeat=$p(^DHCEMPSE(SySeatCode,"SE",SEChildSub),"^",2)_"号"
	s PatSeat=##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID(loc,EpisodeID)
    s AdmDocCodeDr=$p(^PAADM(EpisodeID),"^",4)
    s PatInDep=$p(^CTLOC(AdmDocCodeDr),"^",2)
    i PatInDep["-" s PatInDep=$p(PatInDep,"-",2) ///就诊科室
	
	Set str=""
	set str="{"
	set str=str_"""PatInDep"""_":"""_PatInDep_""","
	set str=str_"""PatSeat"""_":"""_PatSeat_""","
	set str=str_"""PatName"""_":"""_PatName_""","
	set str=str_"""PatSex"""_":"""_PatSex_""","
    set str=str_"""PatAge"""_":"""_PatAge_""","
    set str=str_"""PatRegNo"""_":"""_PatRegNo_""","
	set str=str_"""PatYear"""_":"""_PatYear_""","
	set str=str_"""PatDiagnose"""_":"""_PatDiagnose_""""				  
	set str=str_"}"
	q str
}

/// Creator： lvpeng
/// CreatDate： 2016.08.22
/// Description: 根就诊ID取病人基本信息
/// Input：	PAAdm : 就诊ID
/// Return： 	床号^姓名^性别^年龄^病案号^费用类别^登记号
/// Debug：d ##class(DtPortal.Common.PaadmService).GetPatInfo(51)
/// other: w ##class(web.DHCEMPatCard).GetPatInfo("458")
ClassMethod GetPatInfo(PAAdm As %String) As %String
{
	n (PAAdm)
	s BedNo="",Name="",Sex="",Age="",MedicareNo="",AdmReason="",regNo=""
	if PAAdm="" q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	
	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	;Set MedicareNo=$p(^PAPER(PatientID,"PAT",1),"^",22)
	set MedicareNo=##Class(web.DHCEMCommonUtil).GetMrNo(PAAdm) /// 病案号
	set paadmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
	set Age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(PAAdm) //统一调用计费组的年龄接口
	s AdmReasonDr=$P($g(^PAADM(PAAdm)),"^",73)
	Set AdmReasonDr=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	//取病人登记号
	Set regNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	
	
	q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo
}

}
