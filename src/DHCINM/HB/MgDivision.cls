/// Creater:wangpf
/// Descriptions:科室护管分工
/// Date:2020-07-01
Class DHCINM.HB.MgDivision Extends %Persistent
{

/// 病区
Property DivisionWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Division_Ward ];

/// 分工
Property DivisionWork As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Division_Work ];

/// 职务
Property DivisionPost As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 4, SqlFieldName = Division_Post ];

/// 人员
Property DivisionPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Division_Per ];

Index Ward On DivisionWard;

Index Per On (DivisionPer, DivisionWard, DivisionWork, DivisionPost);

Storage Default
{
<Data name="MgDivisionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DivisionWard</Value>
</Value>
<Value name="3">
<Value>DivisionWork</Value>
</Value>
<Value name="4">
<Value>DivisionPost</Value>
</Value>
<Value name="5">
<Value>DivisionPer</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgDivisionD</DataLocation>
<DefaultData>MgDivisionDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgDivisionD</IdLocation>
<IndexLocation>^DHCINM.HB.MgDivisionI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgDivisionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
