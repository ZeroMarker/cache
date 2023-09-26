/// 名称: DHCMed.DP.Meta.AdmAimAnti
/// 描述: 抗生素使用
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.AdmAimAnti Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property AAAMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AAA_MainID ];

/// 与主记录DataSubCat一致
Property AAADataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AAA_DataSubCat ];

/// 与主记录ObjectID一致
Property AAAObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AAA_ObjectID ];

/// 入院日期
Property AAAAdmDate As %Date [ SqlColumnNumber = 5, SqlFieldName = AAA_AdmDate ];

/// 入院科室
Property AAAAdmDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AAA_AdmDept ];

/// 入院病区
Property AAAAdmWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AAA_AdmWard ];

/// 出院日期
Property AAADischDate As %Date [ SqlColumnNumber = 8, SqlFieldName = AAA_DischDate ];

/// 出院科室
Property AAADischDept As %String [ SqlColumnNumber = 9, SqlFieldName = AAA_DischDept ];

/// 出院病区
Property AAADischWard As %String [ SqlColumnNumber = 10, SqlFieldName = AAA_DischWard ];

/// 是否使用抗生素
Property AAAIsAnti As %Boolean [ SqlColumnNumber = 11, SqlFieldName = AAA_IsAnti ];

/// 是否送检
Property AAAIsLab As %Boolean [ SqlColumnNumber = 12, SqlFieldName = AAA_IsLab ];

/// 使用抗生素种类
Property AAAAntiClass As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AAA_AntiClass ];

/// 使用天数
Property AAAAntiDay As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = AAA_AntiDay ];

/// 是否使用抗生素（限制类）
Property AAAIsAnti2 As %Boolean [ SqlColumnNumber = 15, SqlFieldName = AAA_IsAnti2 ];

/// 是否送检（限制类）
Property AAAIsLab2 As %Boolean [ SqlColumnNumber = 16, SqlFieldName = AAA_IsLab2 ];

/// 使用抗生素种类（限制类）
Property AAAAntiClass2 As %String [ SqlColumnNumber = 17, SqlFieldName = AAA_AntiClass2 ];

/// 使用天数（限制类）
Property AAAAntiDay2 As %String [ SqlColumnNumber = 18, SqlFieldName = AAA_AntiDay2 ];

/// 是否使用抗生素（特殊类）
Property AAAIsAnti3 As %Boolean [ SqlColumnNumber = 19, SqlFieldName = AAA_IsAnti3 ];

/// 是否送检（特殊类）
Property AAAIsLab3 As %Boolean [ SqlColumnNumber = 20, SqlFieldName = AAA_IsLab3 ];

/// 使用抗生素种类（特殊类）
Property AAAAntiClass3 As %String [ SqlColumnNumber = 21, SqlFieldName = AAA_AntiClass3 ];

/// 使用天数（特殊类）
Property AAAAntiDay3 As %String [ SqlColumnNumber = 22, SqlFieldName = AAA_AntiDay3 ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新抗生素使用
/// Table：       DHCMed.DP.Meta.AdmAimAnti
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.AdmAimAnti).Update("^2^3^ICDB12^66666^备注^2^63291^6752^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.AdmAimAnti).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.AdmAimAnti).%OpenId(ID)
		}
	set obj.AAAMainID=$p(InStr,separete,2)
	set obj.AAADataSubCat=$p(InStr,separete,3)
	set obj.AAAObjectID=$p(InStr,separete,4)
	set obj.AAAAdmDate=$p(InStr,separete,5)
	set obj.AAAAdmDept=$p(InStr,separete,6)
	set obj.AAAAdmWard=$p(InStr,separete,7)
	set obj.AAADischDate=$p(InStr,separete,8)
	set obj.AAADischDept=$p(InStr,separete,9)
	set obj.AAADischWard=$p(InStr,separete,10)
	set obj.AAAIsAnti=$p(InStr,separete,11)
	set obj.AAAIsLab=$p(InStr,separete,12)
	set obj.AAAAntiClass=$p(InStr,separete,13)
	set obj.AAAAntiDay=$p(InStr,separete,14)
	set obj.AAAIsAnti2=$p(InStr,separete,15)
	set obj.AAAIsLab2=$p(InStr,separete,16)
	set obj.AAAAntiClass2=$p(InStr,separete,17)
	set obj.AAAAntiDay2=$p(InStr,separete,18)
	set obj.AAAIsAnti3=$p(InStr,separete,19)
	set obj.AAAIsLab3=$p(InStr,separete,20)
	set obj.AAAAntiClass3=$p(InStr,separete,21)
	set obj.AAAAntiDay3=$p(InStr,separete,22)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  删除抗生素使用
/// Table：       DHCMed.DP.Meta.AdmAimAnti
/// Input：       DHCMed.DP.Meta.AdmAimAnti.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.AdmAimAnti).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.AdmAimAnti.ID
/// Return：      DHCMed.DP.Meta.AdmAimAnti
/// w ##class(DHCMed.DP.Meta.AdmAimAnti).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.AdmAimAnti
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.AdmAimAnti).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.AdmAimAnti).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AAAMainID</Value>
</Value>
<Value name="3">
<Value>AAADataSubCat</Value>
</Value>
<Value name="4">
<Value>AAAObjectID</Value>
</Value>
<Value name="5">
<Value>AAAAdmDate</Value>
</Value>
<Value name="6">
<Value>AAAAdmDept</Value>
</Value>
<Value name="7">
<Value>AAAAdmWard</Value>
</Value>
<Value name="8">
<Value>AAADischDate</Value>
</Value>
<Value name="9">
<Value>AAADischDept</Value>
</Value>
<Value name="10">
<Value>AAADischWard</Value>
</Value>
<Value name="11">
<Value>AAAIsAnti</Value>
</Value>
<Value name="12">
<Value>AAAIsLab</Value>
</Value>
<Value name="13">
<Value>AAAAntiClass</Value>
</Value>
<Value name="14">
<Value>AAAAntiDay</Value>
</Value>
<Value name="15">
<Value>AAAIsAnti2</Value>
</Value>
<Value name="16">
<Value>AAAIsLab2</Value>
</Value>
<Value name="17">
<Value>AAAAntiClass2</Value>
</Value>
<Value name="18">
<Value>AAAAntiDay2</Value>
</Value>
<Value name="19">
<Value>AAAIsAnti3</Value>
</Value>
<Value name="20">
<Value>AAAIsLab3</Value>
</Value>
<Value name="21">
<Value>AAAAntiClass3</Value>
</Value>
<Value name="22">
<Value>AAAAntiDay3</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.AdmAimAntiD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.AdmAimAntiD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.AdmAimAntiI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.AdmAimAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
