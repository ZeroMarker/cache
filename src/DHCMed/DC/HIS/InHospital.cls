/// 名称 : DHCMed.DC.HIS.InHospital
/// 说明 : 住在患者列表
Class DHCMed.DC.HIS.InHospital Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号（PA_Adm.ID）
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人ID（Pa_Patmas.ID）
Property PatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊类型（I住院、O门诊、E急诊、EP急诊留观）
Property AdmType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院日期
Property AdmDate As %Date;

/// 入院时间
Property AdmTime As %Time;

/// 出院日期
Property DischDate As %Date;

/// 出院时间
Property DischTime As %Time;

/// 住院天数（在院为-1）
Property AdmDays As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Index IndexHospTypeAdm On (HospCode As Exact, AdmType As Exact, EpisodeID As Exact);

Index IndexInHospital On (HospCode As Exact, AdmType As Exact, AdmDays As Exact, AdmDate As Exact);

Index IndexHospTypeAdmDate On (HospCode As Exact, AdmType As Exact, AdmDate As Exact, AdmTime As Exact);

Index IndexHospTypeDisDate On (HospCode As Exact, AdmType As Exact, DischDate As Exact, DischTime As Exact);

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据ID取住在患者列表
/// Table：       DHCMed.DC.HIS.InHospital
/// Input：       ID:    DHCMed.DC.HIS.InHospital.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.HIS.InHospital).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.HIS.InHospital
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.HIS.InHospital).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.HIS.InHospital).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  更新住在患者列表
/// Table：       DHCMed.DC.HIS.InHospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.HIS.InHospital).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set EpisodeID  = $p(InStr,separete,1)
	set PatientID  = $p(InStr,separete,2)
	set AdmType    = $p(InStr,separete,3)
	set HospCode   = $p(InStr,separete,4)
	set AdmDate    = $p(InStr,separete,5)
	set AdmTime    = $p(InStr,separete,6)
	set DischDate  = $p(InStr,separete,7)
	set DischTime  = $p(InStr,separete,8)
	set AdmDays    = $p(InStr,separete,9)
	set IsActive   = +$p(InStr,separete,10)
	quit:(EpisodeID="")||(PatientID="") return
	quit:(AdmType="")||(HospCode="") return
	
	//数据唯一性
	set ID=$o(^DHCMed.DC.HIS.InHospitalI("IndexHospTypeAdm",HospCode,AdmType,EpisodeID,0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.HIS.InHospital).%New()
	}else{
		set obj=##class(DHCMed.DC.HIS.InHospital).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.EpisodeID  = EpisodeID
	set obj.PatientID  = PatientID
	set obj.AdmType    = AdmType
	set obj.HospCode   = HospCode
	set obj.AdmDate    = AdmDate
	set obj.AdmTime    = AdmTime
	set obj.DischDate  = DischDate
	set obj.DischTime  = DischTime
	set obj.AdmDays    = AdmDays
	set obj.IsActive   = IsActive
	set obj.UpdateDate = +$h
	set obj.UpdateTime = $p($h,",",2)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  删除住在患者列表
/// Table：       DHCMed.DC.HIS.InHospital
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.HIS.InHospital).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>AdmType</Value>
</Value>
<Value name="5">
<Value>HospCode</Value>
</Value>
<Value name="6">
<Value>AdmDate</Value>
</Value>
<Value name="7">
<Value>AdmTime</Value>
</Value>
<Value name="8">
<Value>DischDate</Value>
</Value>
<Value name="9">
<Value>DischTime</Value>
</Value>
<Value name="10">
<Value>AdmDays</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.HIS.InHospitalD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.HIS.InHospitalD</IdLocation>
<IndexLocation>^DHCMed.DC.HIS.InHospitalI</IndexLocation>
<StreamLocation>^DHCMed.DC.HIS.InHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
