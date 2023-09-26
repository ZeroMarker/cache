/// creator:xbl
/// createdate:2017-06-28
/// description:护管病区维护
Class DHCNMG.DB.MgWard Extends %Persistent
{

/// HIS CT_Loc Id
Property CTLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = CT_LocDR ];

/// 代码
Property WardCode As %String [ SqlColumnNumber = 3, SqlFieldName = Ward_Code ];

/// 描述
Property WardDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Ward_Desc ];

/// 科室类型 
Property WardTypeDR As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 5, SqlFieldName = Ward_TypeDR ];

/// HIS CT_Hospital Id
Property CTHospitalDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = CT_HospitalDR ];

/// 字母首拼
Property WardSpell As %String [ SqlColumnNumber = 7, SqlFieldName = Ward_Spell ];

/// 简称
Property WardShort As %String [ SqlColumnNumber = 8, SqlFieldName = Ward_Short ];

/// 所属片区
Property WardAreaDR As DHCNMG.DB.MgWardArea [ SqlColumnNumber = 9, SqlFieldName = Ward_AreaDR ];

/// 所属科室
Property WardLocDR As DHCNMG.DB.MgWardLoc [ SqlColumnNumber = 10, SqlFieldName = Ward_LocDR ];

/// 使用标志
Property WardLimits As list Of %String [ SqlColumnNumber = 11, SqlFieldName = Ward_Limits ];

/// 启用日期
Property WardStDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Ward_StDate ];

/// 停用日期
Property WardEndDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Ward_EndDate ];

/// 发热参数值
Property WardFire As %String [ SqlColumnNumber = 14, SqlFieldName = Ward_Fire ];

/// 床护比参数值
Property WardBedPR As %String [ SqlColumnNumber = 15, SqlFieldName = Ward_BedPR ];

/// 在编床位数
Property WardBedNum As %String [ SqlColumnNumber = 16, SqlFieldName = Ward_BedNum ];

/// 序号
Property WardSort As %Integer [ SqlColumnNumber = 17, SqlFieldName = Ward_Sort ];

/// 备注
Property WardRemark As %String [ SqlColumnNumber = 18, SqlFieldName = Ward_Remark ];

Index Code On WardCode;

Index CTLoc On CTLocDR [ Condition = {CT_LocDR'=""} ];

Index Area On WardAreaDR [ Condition = {Ward_AreaDR'=""} ];

Index Loc On WardLocDR [ Condition = {Ward_LocDR'=""} ];

Index Hosptial On CTHospitalDR [ Condition = {CT_HospitalDR'=""} ];

Index Spell On WardSpell;

Index Sort On WardSort;

Index Desc On WardDesc;

Storage Default
{
<Data name="MgWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocDr</Value>
</Value>
<Value name="3">
<Value>WardCode</Value>
</Value>
<Value name="4">
<Value>WardDesc</Value>
</Value>
<Value name="5">
<Value>WardType</Value>
</Value>
<Value name="6">
<Value>WardFlag</Value>
</Value>
<Value name="7">
<Value>CTHospitalDr</Value>
</Value>
<Value name="8">
<Value>WardStDate</Value>
</Value>
<Value name="9">
<Value>WardEndDate</Value>
</Value>
<Value name="10">
<Value>CTLocDR</Value>
</Value>
<Value name="11">
<Value>CTHospitalDR</Value>
</Value>
<Value name="12">
<Value>WardSpell</Value>
</Value>
<Value name="13">
<Value>WardAreaDR</Value>
</Value>
<Value name="14">
<Value>WardLocDR</Value>
</Value>
<Value name="15">
<Value>WardShort</Value>
</Value>
<Value name="16">
<Value>WardLimit</Value>
</Value>
<Value name="17">
<Value>WardTypeDR</Value>
</Value>
<Value name="18">
<Value>WardLimits</Value>
</Value>
<Value name="19">
<Value>WardFire</Value>
</Value>
<Value name="20">
<Value>WardBedPR</Value>
</Value>
<Value name="21">
<Value>WardBedNum</Value>
</Value>
<Value name="22">
<Value>WardSort</Value>
</Value>
<Value name="23">
<Value>WardRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgWardD</DataLocation>
<DefaultData>MgWardDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgWardD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgWardI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
