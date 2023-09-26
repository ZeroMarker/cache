/// 名称：DHCMed.Base.PatientAdm
/// 描述：病人就诊信息
/// 创建者：李阳
/// 创建日期：2010-04-05
Class DHCMed.Base.PatientAdm Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// paadm
Property AdmRowID As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmitDate As %String(TRUNCATE = 1);

/// 就诊时间
Property AdmitTime As %String(TRUNCATE = 1);

/// 就诊科室ID
Property DepartmentID As %String(TRUNCATE = 1);

/// 就诊科室名称
Property Department As %String(TRUNCATE = 1);

/// 就诊科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 出院日期
Property DisDate As %String(TRUNCATE = 1);

/// 出院时间
Property DisTime As %String(TRUNCATE = 1);

/// 病房ID
Property WardID As %String(TRUNCATE = 1);

/// 病房
Property Ward As %String(TRUNCATE = 1);

/// 病室ID
Property RoomID As %String(TRUNCATE = 1);

/// 病室
Property Room As %String(TRUNCATE = 1);

/// 病床ID
Property BedID As %String(TRUNCATE = 1);

/// 病床
Property Bed As %String(TRUNCATE = 1);

/// 主管医师ID
Property DoctorID As %String(TRUNCATE = 1);

/// 医师工号
Property DoctorCode As %String(TRUNCATE = 1);

/// 医师姓名
Property DoctorName As %String(TRUNCATE = 1);

/// 就诊结果
Property Status As %String(TRUNCATE = 1);

/// 就诊号
Property AdmNo As %String(TRUNCATE = 1);

/// papmi病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 就诊类型
Property AdmType As %String(TRUNCATE = 1);

/// 住院天数 Add By LiYang 2010-4-23
Property Days As %Integer;

/// 病案号
Property MrNo As %String;

/// MR_Adm rowid Add By LiYang 2010-10-09
Property MrAdmID As %Integer;

/// w ##Class(DHCMed.Base.PatientAdm).GetObjById(3004)
ClassMethod GetObjById(paadm As %String) As DHCMed.Base.PatientAdm
{
	n (paadm,%session)
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	s tmp=$g(^PAADM(+paadm))
    q:tmp="" ""
    s obj=##class(DHCMed.Base.PatientAdm).%New()
    s obj.AdmRowID=paadm
    s obj.AdmType=$p(tmp,"^",2)
    s obj.AdmNo=$p(tmp,"^",81)
    //s obj.AdmitDate=$zd($p(tmp,"^",6),3)
    //s obj.AdmitTime=$zt($p(tmp,"^",7))
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(paadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    If (AdmitDate'="")&&(AdmitTime'="") {
	    ;Set obj.AdmitDate=$zd(AdmitDate,3)
	    Set obj.AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
	    Set obj.AdmitTime=$zt(AdmitTime,1)
    } Else {
	    Set obj.AdmitTime=""
	    Set obj.AdmitTime=""
	}
    s obj.DepartmentID=+$p(tmp,"^",4)
    s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(+$p(tmp,"^",4))
    s obj.Department=objLoc.Descs
    s obj.Department=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,objLoc.Descs)
    s obj.DepartmentCode=objLoc.Code    
    d objLoc.%Close()
    k objLoc
    //upadte by pylian 2016-01-21 修改出院时间取值方式
    Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(paadm)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
    If (DischDate'="")&&(DischTime'="") {
	    ;Set obj.DisDate=$zd(DischDate,3)
	    Set obj.DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	    Set obj.DisTime=$zt(DischTime,1)
    } Else {
	    Set obj.DisDate=""
	    Set obj.DisTime=""
	}
    
    s obj.WardID=+$p(tmp,"^",70)
    s obj.Ward=$p($g(^PAWARD(+$p(tmp,"^",70))),"^",2)
	s:obj.Ward'="" obj.Ward=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,obj.Ward)
    s obj.RoomID=+$p(tmp,"^",69)
    s obj.Room=$p($g(^PAROOM(+$p(tmp,"^",69))),"^",2)
    s obj.BedID=$p(tmp,"^",73)
    s obj.Bed=$p($g(^PAWARD(+$p(tmp,"^",73),"BED",+$p($p(tmp,"^",73),"||",2))),"^",1)
    s docData=$g(^CTPCP(+$p(tmp,"^",9),1))
    s obj.DoctorID=+$p(tmp,"^",9)
    s obj.DoctorCode=$p(docData,"^",1)
    s obj.DoctorName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,$p(docData,"^",2))
    s obj.Status=$p(tmp,"^",20) ;Admit, Cancel, Current, Discharged, Preadmit, Released, DNA
    s obj.PatientID=$p(tmp,"^",1)
    //update by pylian 2016-01-22
    i DischDate'=""  d //计算住院天数 Add By LiYang 2010-4-23
    .s obj.Days=DischDate-AdmitDate
    e  d
    .s obj.Days=+$h-AdmitDate	//add by liuyh 2012-08-16 出院日期为空，取当前日期
    s obj.MrAdmID=$p(tmp,"^",61)
    s obj.MrNo=..GetMrNoByAdm(paadm)
    q obj
    /*
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$zd($p(tmp,"^",6),3),AdmTime=$zt($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18))
    
    s:CTLoc'=0 LocDesc=$$GetCtlocStr^DHCMedBase(CTLoc)    
    s:Doc'=0 DocDesc=$$GetUserByCTCP^DHCMedBase(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    */
}

/// 根据EpisodeID传出就诊信息的json串
/// by wuqk 
/// 2011-07-21
/// w ##class(DHCMed.Base.PatientAdm).GetJsonById(142709)
ClassMethod GetJsonById(EpisodeID As %String) As %String
{
	set obj=..GetObjById(EpisodeID)
	
	quit:'$IsObject(obj) ""
	set json=""
	set cls=##class(%ClassDefinition).%OpenId("DHCMed.Base.PatientAdm")
	for i=1:1:cls.Properties.Count() {
		set strPropertyName=cls.Properties.GetAt(i).Name
		set expression="set strValue=obj."_strPropertyName
		x expression
		set json=json_strPropertyName
		set json=json_":'"_strValue_"',"
	}
	if json'=""{
		set json=$e(json,1,$l(json)-1)
	}
	s json="{"_json_"}"
	quit json
}

ClassMethod QueryAdmByPatientID(PatientID As %String) As %Library.ListOfObjects
{
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..AdmRowID_separete
	set return=return_..AdmitDate_separete
	set return=return_..AdmitTime_separete
	set return=return_..DepartmentID_separete
	set return=return_..Department_separete
	set return=return_..DepartmentCode_separete
	set return=return_..DisDate_separete
	set return=return_..DisTime_separete
	set return=return_..WardID_separete
	set return=return_..Ward_separete
	set return=return_..RoomID_separete
	set return=return_..Room_separete
	set return=return_..BedID_separete
	set return=return_..Bed_separete
	set return=return_..DoctorID_separete
	set return=return_..DoctorCode_separete
	set return=return_..DoctorName_separete
	set return=return_..Status_separete
	set return=return_..AdmNo_separete
	set return=return_..PatientID_separete
	set return=return_..AdmType_separete
	set return=return_..Days_separete
	set return=return_..MrAdmID_separete
	set return=return_..MrNo_separete
	quit return
}

/// Creator：     Chenjb
/// CreatDate：   2010-05-19
/// Description:  根据Pa_Adm.取就诊信息
/// Table：       Pa_PatMas,Pa_Adm
/// Input：       id:    Pa_Adm
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.PatientAdm).GetStringById(1,"")
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// 根据EpisodeID获取病案号
/// by liuyh
/// 2012-08-16
/// w ##class(DHCMed.Base.PatientAdm).GetMrNoByAdm(1)
ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//病案系统接口调用：就诊取病案号接口
	Set return=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,"I","")
	Quit return
}

}
