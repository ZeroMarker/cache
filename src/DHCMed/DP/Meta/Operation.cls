/// 名称: DHCMed.DP.Meta.Operation
/// 描述: 手术记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.Operation Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property OPMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OP_MainID ];

/// 与主记录DataSubCat一致
Property OPDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OP_DataSubCat ];

/// 与主记录ObjectID一致
Property OPObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OP_ObjectID ];

/// 手术编码
Property OPOperCM3 As %String [ SqlColumnNumber = 5, SqlFieldName = OP_OperCM3 ];

/// 手术名称
Property OPOperName As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OP_OperName ];

/// 手术类型
Property OPOperType As %String [ SqlColumnNumber = 7, SqlFieldName = OP_OperType ];

/// 开始日期
Property OPSttDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OP_SttDate ];

/// 开始时间
Property OPSttTime As %Time [ SqlColumnNumber = 9, SqlFieldName = OP_SttTime ];

/// 结束日期
Property OPEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = OP_EndDate ];

/// 结束时间
Property OPEndTime As %Time [ SqlColumnNumber = 11, SqlFieldName = OP_EndTime ];

/// 手术科室代码
Property OPOperDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = OP_OperDept ];

/// 手术病区代码
Property OPOperWard As %String [ SqlColumnNumber = 13, SqlFieldName = OP_OperWard ];

/// 手术医生代码
Property OPOperDoc As %String [ SqlColumnNumber = 14, SqlFieldName = OP_OperDoc ];

/// 切口个数
Property OPCuteNum As %String [ SqlColumnNumber = 15, SqlFieldName = OP_CuteNum ];

/// 切口等级
Property OPCutGrade As %String [ SqlColumnNumber = 16, SqlFieldName = OP_CutGrade ];

/// 愈合情况
Property OPHealState As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OP_HealState ];

/// 麻醉方式
Property OPAneMethod As %String [ SqlColumnNumber = 18, SqlFieldName = OP_AneMethod ];

/// 麻醉医师代码
Property OPAneDoc As %String [ SqlColumnNumber = 19, SqlFieldName = OP_AneDoc ];

/// ASA(麻醉)评分
Property OPASAScore As %String [ SqlColumnNumber = 20, SqlFieldName = OP_ASAScore ];

/// NNIS分级
Property OPNNIS As %String [ SqlColumnNumber = 21, SqlFieldName = OP_NNIS ];

/// 感染类型
Property OPInfPos As %String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = OP_InfPos ];

/// 术前外周WBC
Property OPOperWBC As %String [ SqlColumnNumber = 23, SqlFieldName = OP_OperWBC ];

/// 失血量
Property OPLoseBlood As %String [ SqlColumnNumber = 24, SqlFieldName = OP_LoseBlood ];

/// 输血量
Property OPEnterBlood As %String [ SqlColumnNumber = 25, SqlFieldName = OP_EnterBlood ];

/// 术前口服抗生素肠道准备
Property OPIsPreOralAnti As %Boolean [ SqlColumnNumber = 26, SqlFieldName = OP_IsPreOralAnti ];

/// 植入物
Property OPIsImplants As %Boolean [ SqlColumnNumber = 27, SqlFieldName = OP_IsImplants ];

/// 使用窥镜
Property OPIsLookinGlass As %Boolean [ SqlColumnNumber = 28, SqlFieldName = OP_IsLookinGlass ];

/// 术前0.5-2小时用药情况
Property OPIsPreOperAnti As %Boolean [ SqlColumnNumber = 29, SqlFieldName = OP_IsPreOperAnti ];

/// 术中用药情况
Property OPIsIntraOperAnti As %Boolean [ SqlColumnNumber = 30, SqlFieldName = OP_IsIntraOperAnti ];

/// 术后用药情况
Property OPIsPostOperAnti As %Boolean [ SqlColumnNumber = 31, SqlFieldName = OP_IsPostOperAnti ];

/// 术后24小时停药情况
Property OPIsPost24HourAnti As %Boolean [ SqlColumnNumber = 32, SqlFieldName = OP_IsPost24HourAnti ];

/// 备注
Property OPResume As %String [ SqlColumnNumber = 33, SqlFieldName = OP_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新手术记录
/// Table：       DHCMed.DP.Meta.Operation
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.Operation).Update("^SYS-Dept^NK^内科科室^内二科/内三科^ICU^^^^^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.Operation).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.Operation).%OpenId(ID)
		}

	set obj.OPMainID=$p(InStr,separete,2)
	set obj.OPDataSubCat=$p(InStr,separete,3)
	set obj.OPObjectID=$p(InStr,separete,4)
	set obj.OPOperCM3=$p(InStr,separete,5)
	set obj.OPOperName=$p(InStr,separete,6)
	set obj.OPOperType=$p(InStr,separete,7)
	set obj.OPSttDate=$p(InStr,separete,8)
	set obj.OPSttTime=$p(InStr,separete,9)
	set obj.OPEndDate=$p(InStr,separete,10)
	set obj.OPEndTime=$p(InStr,separete,11)
	set obj.OPOperDept=$p(InStr,separete,12)
	set obj.OPOperWard=$p(InStr,separete,13)
	set obj.OPOperDoc=$p(InStr,separete,14)
	set obj.OPCuteNum=$p(InStr,separete,15)
	set obj.OPCutGrade=$p(InStr,separete,16)
	set obj.OPHealState=$p(InStr,separete,17)
	set obj.OPAneMethod=$p(InStr,separete,18)
	set obj.OPAneDoc=$p(InStr,separete,19)
	set obj.OPASAScore=$p(InStr,separete,20)
	set obj.OPNNIS=$p(InStr,separete,21)
	set obj.OPInfPos=$p(InStr,separete,22)
	set obj.OPOperWBC=$p(InStr,separete,23)
	set obj.OPLoseBlood=$p(InStr,separete,24)
	set obj.OPEnterBlood=$p(InStr,separete,25)
	set obj.OPIsPreOralAnti=$p(InStr,separete,26)
	set obj.OPIsImplants=$p(InStr,separete,27)
	set obj.OPIsLookinGlass=$p(InStr,separete,28)
	set obj.OPIsPreOperAnti=$p(InStr,separete,29)
	set obj.OPIsIntraOperAnti=$p(InStr,separete,30)
	set obj.OPIsPostOperAnti=$p(InStr,separete,31)
	set obj.OPIsPost24HourAnti=$p(InStr,separete,32)
	set obj.OPResume=$p(InStr,separete,33)

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
/// Description:  删除手术记录
/// Table：       DHCMed.DP.Meta.Operation
/// Input：       DHCMed.DP.Meta.Operation.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.Operation).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.Operation.ID
/// Return：      DHCMed.DP.Meta.Operation
/// w ##class(DHCMed.DP.Meta.Operation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.Operation
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.Operation).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.Operation).%OpenId(+id)
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
<Value>OPMainID</Value>
</Value>
<Value name="3">
<Value>OPDataSubCat</Value>
</Value>
<Value name="4">
<Value>OPObjectID</Value>
</Value>
<Value name="5">
<Value>OPOperCM3</Value>
</Value>
<Value name="6">
<Value>OPOperName</Value>
</Value>
<Value name="7">
<Value>OPOperType</Value>
</Value>
<Value name="8">
<Value>OPSttDate</Value>
</Value>
<Value name="9">
<Value>OPSttTime</Value>
</Value>
<Value name="10">
<Value>OPEndDate</Value>
</Value>
<Value name="11">
<Value>OPEndTime</Value>
</Value>
<Value name="12">
<Value>OPOperDept</Value>
</Value>
<Value name="13">
<Value>OPOperWard</Value>
</Value>
<Value name="14">
<Value>OPOperDoc</Value>
</Value>
<Value name="15">
<Value>OPCuteNum</Value>
</Value>
<Value name="16">
<Value>OPCutGrade</Value>
</Value>
<Value name="17">
<Value>OPHealState</Value>
</Value>
<Value name="18">
<Value>OPAneMethod</Value>
</Value>
<Value name="19">
<Value>OPAneDoc</Value>
</Value>
<Value name="20">
<Value>OPASAScore</Value>
</Value>
<Value name="21">
<Value>OPNNIS</Value>
</Value>
<Value name="22">
<Value>OPInfPos</Value>
</Value>
<Value name="23">
<Value>OPOperWBC</Value>
</Value>
<Value name="24">
<Value>OPLoseBlood</Value>
</Value>
<Value name="25">
<Value>OPEnterBlood</Value>
</Value>
<Value name="26">
<Value>OPIsPreOralAnti</Value>
</Value>
<Value name="27">
<Value>OPIsImplants</Value>
</Value>
<Value name="28">
<Value>OPIsLookinGlass</Value>
</Value>
<Value name="29">
<Value>OPIsPreOperAnti</Value>
</Value>
<Value name="30">
<Value>OPIsIntraOperAnti</Value>
</Value>
<Value name="31">
<Value>OPIsPostOperAnti</Value>
</Value>
<Value name="32">
<Value>OPIsPost24HourAnti</Value>
</Value>
<Value name="33">
<Value>OPResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.OperationD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.OperationD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.OperationI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
