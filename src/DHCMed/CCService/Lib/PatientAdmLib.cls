/// 监控中心病人就诊信息类库
/// 创建者：李阳
/// 日期：2010-10-18
Class DHCMed.CCService.Lib.PatientAdmLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// paadm
ClassMethod AdmRowID() As %String
{
	n (%Adm)
	q %Adm.AdmRowID
}

/// 就诊日期
ClassMethod AdmitDate() As %String
{
	n (%Adm)
	q %Adm.AdmitDate
}

/// 就诊时间
ClassMethod AdmitTime() As %String
{
	n (%Adm)
	q %Adm.AdmitTime
}

/// 就诊科室ID
ClassMethod DepartmentID() As %String
{
	n (%Adm)
	q %Adm.DepartmentID
}

/// 就诊科室名称
ClassMethod Department() As %String
{
	n (%Adm)
	q %Adm.Department
}

/// 就诊科室代码
ClassMethod DepartmentCode() As %String
{
	n (%Adm)
	q %Adm.DepartmentCode
}

/// 出院日期
ClassMethod DisDate() As %String
{
	n (%Adm)
	q %Adm.DisDate
}

/// 出院时间
ClassMethod DisTime() As %String
{
	n (%Adm)
	q %Adm.DisTime
}

/// 病房ID
ClassMethod WardID() As %String
{
	n (%Adm)
	q %Adm.WardID
}

/// 病房
ClassMethod Ward() As %String
{
	n (%Adm)
	q %Adm.Ward
}

/// 病室ID
ClassMethod RoomID() As %String
{
	n (%Adm)
	q %Adm.RoomID
}

/// 病室
ClassMethod Room() As %String
{
	n (%Adm)
	q %Adm.Room
}

/// 病床ID
ClassMethod BedID() As %String
{
	n (%Adm)
	q %Adm.BedID
}

/// 病床
ClassMethod Bed() As %String
{
	n (%Adm)
	q %Adm.Bed
}

/// 主管医师ID
ClassMethod DoctorID() As %String
{
	n (%Adm)
	q %Adm.DoctorID
}

/// 医师工号
ClassMethod DoctorCode() As %String
{
	n (%Adm)
	q %Adm.DoctorCode
}

/// 医师姓名
ClassMethod DoctorName() As %String
{
	n (%Adm)
	q %Adm.DoctorName
}

/// 就诊结果
ClassMethod Status() As %String
{
	n (%Adm)
	q %Adm.Status
}

/// 就诊号
ClassMethod AdmNo() As %String
{
	n (%Adm)
	q %Adm.AdmNo
}

/// papmi病人ID
ClassMethod PatientID() As %String
{
	n (%Adm)
	q %Adm.PatientID
}

/// 就诊类型
ClassMethod AdmType() As %String
{
	n (%Adm)
	q %Adm.AdmType
}

/// 住院天数
ClassMethod Days() As %Integer
{
	n (%Adm)
	q %Adm.Days
}

/// MR_Adm rowid 
ClassMethod MrAdmID() As %Integer
{
	n (%Adm)
	q %Adm.MrAdmID
}

}
