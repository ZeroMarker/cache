/// creator: LCY
/// createdate: 20190926
/// description: 人员信息
Class DHCNMG.Handbook.MgHNHPerInfo Extends %Persistent
{

/// 人员信息动态创建者
Property HNHInfoDesDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = HNH_InfoDes_DR ];

/// 人员信息动态病区
Property HNHInfoWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = HNH_SumWard_DR ];

/// 动态人员
Property HNHPerDesDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = HNH_PerDes_DR ];

/// 外出学习进修等其他情况
Property HNHInfoNews As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = HNH_InfoNews ];

///  状态(调入:I,调出:O)
Property HNHInfoStatus As %String [ SqlColumnNumber = 6, SqlFieldName = HNH_InfoStatus ];

/// 日期
Property HNHTranDate As %Date [ SqlColumnNumber = 7, SqlFieldName = HNH_TranDate ];

/// 时间
Property HNHTranTime As %Time [ SqlColumnNumber = 8, SqlFieldName = HNH_TranTime ];

/// 工作总结创建日期
Property HNHCreDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = HNH_CreDate ];

/// 工作总结创建时间
Property HNHCreTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = HNH_CreTime ];

Index PerDes On HNHPerDesDR;

Index InfoWard On HNHInfoWardDR;

Index tranDate On HNHTranDate;

Storage Default
{
<Data name="MgHNHPerInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HNHInfoDesDR</Value>
</Value>
<Value name="3">
<Value>HNHInfoWardDR</Value>
</Value>
<Value name="4">
<Value>HNHPerDesDR</Value>
</Value>
<Value name="5">
<Value>HNHInfoNews</Value>
</Value>
<Value name="6">
<Value>HNHInfoStatus</Value>
</Value>
<Value name="7">
<Value>HNHTranDate</Value>
</Value>
<Value name="8">
<Value>HNHTranTime</Value>
</Value>
<Value name="9">
<Value>HNHCreDate</Value>
</Value>
<Value name="10">
<Value>HNHCreTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.MgHNHPerInfoD</DataLocation>
<DefaultData>MgHNHPerInfoDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.MgHNHPerInfoD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.MgHNHPerInfoI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.MgHNHPerInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
