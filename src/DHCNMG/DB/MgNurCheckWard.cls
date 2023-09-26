/// Description:检查病区维护
/// Date:2018-05-04
/// Creator:guozj
Class DHCNMG.DB.MgNurCheckWard Extends %Persistent
{

/// 病区类型 N:夜巡查 W；周末巡查 H：节假日巡查 D：病区自查 M：科护士长督查 S：特殊科室检查 Q：质控检查 
Property WardType As %String [ SqlColumnNumber = 2, SqlFieldName = Ward_Type ];

/// 病区ID（DHCNMG.DB.MgWard表ID）
Property WardID As %String [ SqlColumnNumber = 3, SqlFieldName = Ward_ID ];

/// 序号
Property WardSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Ward_Sort ];

/// 组名
Property WardGroup As %String [ SqlColumnNumber = 5, SqlFieldName = Ward_Group ];

/// 组序号
Property WardGroupSort As %Integer [ SqlColumnNumber = 6, SqlFieldName = Ward_GroupSort ];

Index Type On (WardType, WardID);

Index Sort On (WardType, WardSort);

Index Group On (WardType, WardGroup, WardGroupSort);

Storage Default
{
<Data name="MgNurCheckWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardType</Value>
</Value>
<Value name="3">
<Value>WardID</Value>
</Value>
<Value name="4">
<Value>WardSort</Value>
</Value>
<Value name="5">
<Value>WardGroup</Value>
</Value>
<Value name="6">
<Value>WardGroupSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurCheckWardD</DataLocation>
<DefaultData>MgNurCheckWardDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgNurCheckWardD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurCheckWardI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurCheckWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
