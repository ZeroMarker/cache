Class web.DHCEMBedCard Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-22
/// Description:   获取打印各项所需数据
/// Table：        
/// Input：	                  
/// Return：       json串串
/// Other:         w ##class(web.DHCEMBedCard).getData(592,0000000001,2)
ClassMethod getData(EpisodeID, RegNo, LgHospID)
{
	n (EpisodeID, RegNo, LgHospID,%session)
    ;s LgHospID=%session.Get("LOGON.HOSPID") //2017-01-19 2017-01-23

    i LgHospID'="" s HospDesc=$P(^CT("HOSP",LgHospID),"^",2) //2017-01-19
	s PatName="",PatNum="",PatSex="",PatAge="",PatInDep="",PatCost="",PatDate="",PatDiagnose=""
	if EpisodeID="" q ""
	s AdmVisit = $p($g(^PAADM(EpisodeID)),"^",20)
	q:(AdmVisit'="A") "-2"
	s ObsWardDr = $p(^PAADM(EpisodeID),"^",70)
	q:+ObsWardDr=0 "-1"
	s PatDiagnose=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
    s deplocdr=$p(^PAADM(EpisodeID),"^",4)
    s PatInDep=$p(^CTLOC(deplocdr),"^",2)
    i PatInDep["-" s PatInDep=$p(PatInDep,"-",2) ///就诊科室
    set PatInfo=..GetPatInfo(EpisodeID)
	set PatName=$p(PatInfo,"^",2)											//姓名
	set PatSex=$p(PatInfo,"^",3)											//性别
	set PatAge=$p(PatInfo,"^",4)											//年龄
	;set PatNum=$p(PatInfo,"^",5)								        	//病案号
	set PatNum=RegNo											        	//登记号
	set PatCost=$p(PatInfo,"^",6)								    		//费用类别
	;set BedNo=$p(PatInfo,"^",1)											//床号
	set PatDate=$p(PatInfo,"^",8)	
    //调用统一取入院时间的接口
	;s inDateTimeStr=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	;s PatDate=$p(inDateTimeStr,"^",1)
	i PatDate'="" s PatDate=$zd(PatDate,3)
	;s InTime=$p(inDateTimeStr,"^",2)
	
	s:HospDesc'="" HospDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",HospDesc) //hxy 2022-12-27
	
	Set str=""
	set str="{"
	set str=str_"""PatName"""_":"""_PatName_""","
	set str=str_"""PatNum"""_":"""_PatNum_""","
	set str=str_"""PatSex"""_":"""_PatSex_""","
    set str=str_"""PatAge"""_":"""_PatAge_""","
	set str=str_"""PatInDep"""_":"""_PatInDep_""","
	set str=str_"""PatCost"""_":"""_PatCost_""","
	set str=str_"""PatDate"""_":"""_PatDate_""","
	set str=str_"""PatDiagnose"""_":"""_PatDiagnose_""","
	set str=str_"""HospDesc"""_":"""_HospDesc_""""	//2017-01-19			  
	set str=str_"}"
	q str
}

/// Creator： huaxiaoying
/// CreatDate： 2016-08-22
/// Description: 根就诊ID取病人基本信息
/// Input：	PAAdm : 就诊ID
/// Return： 	床号^姓名^性别^年龄^病案号^费用类别
/// Debug：d ##class(DtPortal.Common.PaadmService).GetPatInfo(601)
/// Other: d ##class(web.DHCEMBedCard).GetPatInfo(601)
ClassMethod GetPatInfo(PAAdm As %String) As %String
{
	n (PAAdm,%session)
	s BedNo="",Name="",Sex="",Age="",MedicareNo="",AdmReason="",regNo=""
	if PAAdm="" q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	
	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	;Set MedicareNo=$p(^PAPER(PatientID,"PAT",1),"^",22)
	;set MedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(PAAdm)
	set paadmType=$P($g(^PAADM(PAAdm)),"^",2)
	if (paadmType="O"){
		set MedicareNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,"O") ;门诊病案号
	}
	
	Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
	set Age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(PAAdm) //统一调用计费组的年龄接口
	s AdmReasonDr=$P($g(^PAADM(PAAdm)),"^",73)
	Set AdmReasonDr=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	//取病人登记号
	Set regNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	
	set PatDate=$P($g(^PAADM(PAAdm)),"^",6)
	
	s:Sex'="" Sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",Sex) //hxy 2022-12-27

	q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo_"^"_PatDate
}

}
