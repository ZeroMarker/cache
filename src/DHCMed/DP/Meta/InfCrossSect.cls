/// 名称: DHCMed.DP.Meta.InfCrossSect
/// 描述: 横断面调查
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.InfCrossSect Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property ICSMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICS_MainID ];

/// 与主记录DataSubCat一致
Property ICSDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ICS_DataSubCat ];

/// 与主记录ObjectID一致
Property ICSObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ICS_ObjectID ];

/// 横断面调查编号
Property ICSSurvNumber As %String [ SqlColumnNumber = 5, SqlFieldName = ICS_SurvNumber ];

/// 科室代码
Property ICSDeptCode As %String [ SqlColumnNumber = 6, SqlFieldName = ICS_DeptCode ];

/// 病区代码
Property ICSWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ICS_WardCode ];

/// 诊断
Property ICSDiagnos As %String [ SqlColumnNumber = 8, SqlFieldName = ICS_Diagnos ];

/// 是否手术
Property ICSIsOperation As %Boolean [ SqlColumnNumber = 9, SqlFieldName = ICS_IsOperation ];

/// 手术切口类型
Property ICSOperCuteType As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ICS_OperCuteType ];

/// 是否感染
Property ICSIsInfection As %Boolean [ SqlColumnNumber = 11, SqlFieldName = ICS_IsInfection ];

/// 感染类型代码
Property ICSInfType As %String [ SqlColumnNumber = 12, SqlFieldName = ICS_InfType ];

/// 医院感染感染部位1
Property ICSInfPos11 As %String [ SqlColumnNumber = 13, SqlFieldName = ICS_InfPos11 ];

/// 医院感染感染部位2
Property ICSInfPos12 As %String [ SqlColumnNumber = 14, SqlFieldName = ICS_InfPos12 ];

/// 医院感染感染部位3
Property ICSInfPos13 As %String [ SqlColumnNumber = 15, SqlFieldName = ICS_InfPos13 ];

/// 医院感染病原体列表1
Property ICSInfPyList11 As %String [ SqlColumnNumber = 16, SqlFieldName = ICS_InfPyList11 ];

/// 医院感染病原体列表2
Property ICSInfPyList12 As %String [ SqlColumnNumber = 17, SqlFieldName = ICS_InfPyList12 ];

/// 医院感染病原体列表3
Property ICSInfPyList13 As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ICS_InfPyList13 ];

/// 社区感染感染部位1
Property ICSInfPos21 As %String [ SqlColumnNumber = 19, SqlFieldName = ICS_InfPos21 ];

/// 社区感染感染部位2
Property ICSInfPos22 As %String [ SqlColumnNumber = 20, SqlFieldName = ICS_InfPos22 ];

/// 社区感染感染部位3
Property ICSInfPos23 As %String [ SqlColumnNumber = 21, SqlFieldName = ICS_InfPos23 ];

/// 社区感染病原体列表1
Property ICSInfPyList21 As %String [ SqlColumnNumber = 22, SqlFieldName = ICS_InfPyList21 ];

/// 社区感染病原体列表2
Property ICSInfPyList22 As %String [ SqlColumnNumber = 23, SqlFieldName = ICS_InfPyList22 ];

/// 社区感染病原体列表3
Property ICSInfPyList23 As %String [ SqlColumnNumber = 24, SqlFieldName = ICS_InfPyList23 ];

/// 泌尿道插管
Property ICSIsUC As %Boolean [ SqlColumnNumber = 25, SqlFieldName = ICS_IsUC ];

/// 泌尿道感染前48h内有泌尿道插管
Property ICSIsUC48Hour As %Boolean [ SqlColumnNumber = 26, SqlFieldName = ICS_IsUC48Hour ];

/// 动静脉插管
Property ICSIsPICC As %Boolean [ SqlColumnNumber = 27, SqlFieldName = ICS_IsPICC ];

/// 血流感染前48h内有动静脉插管
Property ICSIsPICC48Hour As %Boolean [ SqlColumnNumber = 28, SqlFieldName = ICS_IsPICC48Hour ];

/// 气管切开
Property ICSIsTCT As %Boolean [ SqlColumnNumber = 29, SqlFieldName = ICS_IsTCT ];

/// 肺部感染前48h内有气管切开
Property ICSIsTCT48Hour As %Boolean [ SqlColumnNumber = 30, SqlFieldName = ICS_IsTCT48Hour ];

/// 使用呼吸机
Property ICSIsVAP As %Boolean [ SqlColumnNumber = 31, SqlFieldName = ICS_IsVAP ];

/// 肺部感染前48h内有使用呼吸机
Property ICSIsVAP48Hour As %Boolean [ SqlColumnNumber = 32, SqlFieldName = ICS_IsVAP48Hour ];

/// 血液透析
Property ICSIsCHD As %Boolean [ SqlColumnNumber = 33, SqlFieldName = ICS_IsCHD ];

/// 抗菌药物使用
Property ICSIsANTI As %Boolean [ SqlColumnNumber = 34, SqlFieldName = ICS_IsANTI ];

/// 目的
Property ICSMedPurpose As %String [ SqlColumnNumber = 35, SqlFieldName = ICS_MedPurpose ];

/// 联合用药
Property ICSCombinedMed As %String [ SqlColumnNumber = 36, SqlFieldName = ICS_CombinedMed ];

/// 是否送检
Property ICSIsSubmiss As %Boolean [ SqlColumnNumber = 37, SqlFieldName = ICS_IsSubmiss ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新横断面调查
/// Table：       DHCMed.DP.Meta.InfCrossSect
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.InfCrossSect).Update("^SYS-Dept^NK^内科科室^内二科/内三科^ICU^^^^^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.InfCrossSect).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.InfCrossSect).%OpenId(ID)
		}

	set obj.ICSMainID=$p(InStr,separete,2)
	set obj.ICSDataSubCat=$p(InStr,separete,3)
	set obj.ICSObjectID=$p(InStr,separete,4)
	set obj.ICSDeptCode=$p(InStr,separete,5)
	set obj.ICSWardCode=$p(InStr,separete,6)
	set obj.ICSDiagnos=$p(InStr,separete,7)
	set obj.ICSIsOperation=$p(InStr,separete,8)
	set obj.ICSOperCuteType=$p(InStr,separete,9)
	set obj.ICSIsInfection=$p(InStr,separete,10)
	set obj.ICSInfType=$p(InStr,separete,11)
	set obj.ICSInfPos11=$p(InStr,separete,12)
	set obj.ICSInfPos12=$p(InStr,separete,13)
	set obj.ICSInfPos13=$p(InStr,separete,14)
	set obj.ICSInfPyList11=$p(InStr,separete,15)
	set obj.ICSInfPyList12=$p(InStr,separete,16)
	set obj.ICSInfPyList13=$p(InStr,separete,17)
	set obj.ICSInfPos21=$p(InStr,separete,18)
	set obj.ICSInfPos22=$p(InStr,separete,19)
	set obj.ICSInfPos23=$p(InStr,separete,20)
	set obj.ICSInfPyList21=$p(InStr,separete,21)
	set obj.ICSInfPyList22=$p(InStr,separete,22)
	set obj.ICSInfPyList23=$p(InStr,separete,23)
	set obj.ICSIsUC=$p(InStr,separete,24)
	set obj.ICSIsUC48Hour=$p(InStr,separete,25)
	set obj.ICSIsPICC=$p(InStr,separete,26)
	set obj.ICSIsPICC48Hour=$p(InStr,separete,27)
	set obj.ICSIsTCT=$p(InStr,separete,28)
	set obj.ICSIsTCT48Hour=$p(InStr,separete,29)
	set obj.ICSIsVAP=$p(InStr,separete,30)
	set obj.ICSIsVAP48Hour=$p(InStr,separete,31)
	set obj.ICSIsCHD=$p(InStr,separete,32)
	set obj.ICSIsANTI=$p(InStr,separete,33)
	set obj.ICSMedPurpose=$p(InStr,separete,34)
	set obj.ICSCombinedMed=$p(InStr,separete,35)
	set obj.ICSIsSubmiss=$p(InStr,separete,36)
	set obj.ICSSurvNumber=$p(InStr,separete,37)

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
/// Description:  删除横断面调查
/// Table：       DHCMed.DP.Meta.InfCrossSect
/// Input：       DHCMed.DP.Meta.InfCrossSect.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.InfCrossSect).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.InfCrossSect.ID
/// Return：      DHCMed.DP.Meta.InfCrossSect
/// w ##class(DHCMed.DP.Meta.InfCrossSect).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.InfCrossSect
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.InfCrossSect).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.InfCrossSect).%OpenId(+id)
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
<Value>ICSMainID</Value>
</Value>
<Value name="3">
<Value>ICSDataSubCat</Value>
</Value>
<Value name="4">
<Value>ICSObjectID</Value>
</Value>
<Value name="5">
<Value>ICSSurvNumber</Value>
</Value>
<Value name="6">
<Value>ICSDeptCode</Value>
</Value>
<Value name="7">
<Value>ICSWardCode</Value>
</Value>
<Value name="8">
<Value>ICSDiagnos</Value>
</Value>
<Value name="9">
<Value>ICSIsOperation</Value>
</Value>
<Value name="10">
<Value>ICSOperCuteType</Value>
</Value>
<Value name="11">
<Value>ICSIsInfection</Value>
</Value>
<Value name="12">
<Value>ICSInfType</Value>
</Value>
<Value name="13">
<Value>ICSInfPos11</Value>
</Value>
<Value name="14">
<Value>ICSInfPos12</Value>
</Value>
<Value name="15">
<Value>ICSInfPos13</Value>
</Value>
<Value name="16">
<Value>ICSInfPyList11</Value>
</Value>
<Value name="17">
<Value>ICSInfPyList12</Value>
</Value>
<Value name="18">
<Value>ICSInfPyList13</Value>
</Value>
<Value name="19">
<Value>ICSInfPos21</Value>
</Value>
<Value name="20">
<Value>ICSInfPos22</Value>
</Value>
<Value name="21">
<Value>ICSInfPos23</Value>
</Value>
<Value name="22">
<Value>ICSInfPyList21</Value>
</Value>
<Value name="23">
<Value>ICSInfPyList22</Value>
</Value>
<Value name="24">
<Value>ICSInfPyList23</Value>
</Value>
<Value name="25">
<Value>ICSIsUC</Value>
</Value>
<Value name="26">
<Value>ICSIsUC48Hour</Value>
</Value>
<Value name="27">
<Value>ICSIsPICC</Value>
</Value>
<Value name="28">
<Value>ICSIsPICC48Hour</Value>
</Value>
<Value name="29">
<Value>ICSIsTCT</Value>
</Value>
<Value name="30">
<Value>ICSIsTCT48Hour</Value>
</Value>
<Value name="31">
<Value>ICSIsVAP</Value>
</Value>
<Value name="32">
<Value>ICSIsVAP48Hour</Value>
</Value>
<Value name="33">
<Value>ICSIsCHD</Value>
</Value>
<Value name="34">
<Value>ICSIsANTI</Value>
</Value>
<Value name="35">
<Value>ICSMedPurpose</Value>
</Value>
<Value name="36">
<Value>ICSCombinedMed</Value>
</Value>
<Value name="37">
<Value>ICSIsSubmiss</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.InfCrossSectD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.InfCrossSectD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.InfCrossSectI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.InfCrossSectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
