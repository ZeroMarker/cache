/// 名称：DHCWMR.Base.PatientAdm
/// 描述：病人就诊信息
/// 创建者：liy
/// 创建日期：2014-09-05
Class DHCWMR.Base.PatientAdm Extends (%Persistent, DHCWMR.Abstract) [ ClassType = "", Not ProcedureBlock ]
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

/// 住院天数
Property Days As %Integer;

/// MR_Adm rowid
Property MrAdmID As %Integer;

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据paadm就诊信息
/// Table：       
/// Input：       paadm
/// Return：      返回obj
/// Others：   
/// w ##class(DHCWMR.Base.PatientAdm).GetObjById(1)
ClassMethod GetObjById(paadm As %String) As DHCWMR.Base.PatientAdm
{
	new (paadm)
	
	s tmp=$g(^PAADM(+paadm))
    q:tmp="" ""
    s obj=##class(DHCWMR.Base.PatientAdm).%New()
    s obj.AdmRowID=paadm
    s obj.AdmType=$p(tmp,"^",2)
    s obj.AdmNo=$p(tmp,"^",81)
    //s obj.AdmitDate=$zd($p(tmp,"^",6),3)
    //s obj.AdmitTime=$zt($p(tmp,"^",7))
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(paadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    If (AdmitDate'="")&&(AdmitTime'="") {
	    Set obj.AdmitDate=$zd(AdmitDate,3)
	    Set obj.AdmitTime=$zt(AdmitTime,1)
    } Else {
	    Set obj.AdmitTime=""
	    Set obj.AdmitTime=""
	}
    s obj.DepartmentID=+$p(tmp,"^",4)
    s objLoc=##class(DHCWMR.Base.Ctloc).GetObjById(+$p(tmp,"^",4))
    s obj.Department=objLoc.Descs
    s obj.DepartmentCode=objLoc.Code    
    d objLoc.%Close()
    k objLoc
    /*
    If (+$p(tmp,"^",17))'=0 {
	    Set obj.DisDate=$zd(+$p(tmp,"^",17),3)
	    s obj.DisTime=$zt(+$p(tmp,"^",18),1)
    }*/
    //upadte by pylian 2016-01-21 修改出院时间取值方式
    Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(paadm)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
    If (DischDate'="")&&(DischTime'="") {
	    Set obj.DisDate=$zd(DischDate,3)
	    Set obj.DisTime=$zt(DischTime,1)
    } Else {
	    Set obj.DisDate=""
	    Set obj.DisTime=""
	}
    
    s obj.WardID=+$p(tmp,"^",70)
    s obj.Ward=$p($g(^PAWARD(+$p(tmp,"^",70))),"^",2)
    s obj.RoomID=+$p(tmp,"^",69)
    s obj.Room=$p($g(^PAROOM(+$p(tmp,"^",69))),"^",2)
    s obj.BedID=$p(tmp,"^",73)
    s obj.Bed=$p($g(^PAWARD(+$p(tmp,"^",73),"BED",+$p($p(tmp,"^",73),"||",2))),"^",1)
    s docData=$g(^CTPCP(+$p(tmp,"^",9),1))
    s obj.DoctorID=+$p(tmp,"^",9)
    s obj.DoctorCode=$p(docData,"^",1)
    s obj.DoctorName=$p(docData,"^",2)
    s obj.Status=$p(tmp,"^",20)
    s obj.PatientID=$p(tmp,"^",1)
     //update by pylian 2016-01-22
    i DischDate'=""  d 
    .s obj.Days=DischDate-AdmitDate
    //i $p(tmp,"^",17)'=""  d
    //.s obj.Days=$p(tmp,"^",17)-$p(tmp,"^",6)
    s obj.MrAdmID=$p(tmp,"^",61)
    q obj
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
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
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据Pa_Adm.取就诊信息
/// Table：       Pa_PatMas,Pa_Adm
/// Input：       id:    Pa_Adm
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.PatientAdm).GetStringById(1,"")
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

}
