/// creator:lulin
/// createdate:2018-04-08
/// description:历史床护比
Class DHCNMG.Sens.MgBedPR Extends %Persistent
{

/// 病区
Property BedPRWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = BedPR_Ward ];

/// 日期
Property BedPRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BedPR_Date ];

/// 护士总数
Property BedPRNurseNum As %String [ SqlColumnNumber = 4, SqlFieldName = BedPR_NurseNum ];

/// 在编床位数
Property BedPRBedNum As %String [ SqlColumnNumber = 5, SqlFieldName = BedPR_BedNum ];

/// 实际床位数
Property BedPRRealBedNum As %String [ SqlColumnNumber = 6, SqlFieldName = BedPR_RealBedNum ];

/// 床护比参数值
Property BedPRParam As %String [ SqlColumnNumber = 7, SqlFieldName = BedPR_Param ];

/// 在编床护比
Property BedPRBedPR As %String [ SqlColumnNumber = 8, SqlFieldName = BedPR_BedPR ];

/// 实际床护比
Property BedPRRealBedPR As %String [ SqlColumnNumber = 9, SqlFieldName = BedPR_RealBedPR ];

/// 在编床护比颜色。1、黑色；2、绿色；3、红色
Property BedPRColor As %String [ SqlColumnNumber = 10, SqlFieldName = BedPR_Color ];

/// 实际床护比颜色。1、黑色；2、绿色；3、红色
Property BedPRRealColor As %String [ SqlColumnNumber = 11, SqlFieldName = BedPR_RealColor ];

Index ward On BedPRWard;

Index date On (BedPRDate, BedPRWard);

Storage Default
{
<Data name="MgBedPRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BedPRWard</Value>
</Value>
<Value name="3">
<Value>BedPRDate</Value>
</Value>
<Value name="4">
<Value>BedPRNurseNum</Value>
</Value>
<Value name="5">
<Value>BedPRBedNum</Value>
</Value>
<Value name="6">
<Value>BedPRRealBedNum</Value>
</Value>
<Value name="7">
<Value>BedPRParam</Value>
</Value>
<Value name="8">
<Value>BedPRBedPR</Value>
</Value>
<Value name="9">
<Value>BedPRRealBedPR</Value>
</Value>
<Value name="10">
<Value>BedPRColor</Value>
</Value>
<Value name="11">
<Value>BedPRRealColor</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Sens.MgBedPRD</DataLocation>
<DefaultData>MgBedPRDefaultData</DefaultData>
<IdLocation>^DHCNMG.Sens.MgBedPRD</IdLocation>
<IndexLocation>^DHCNMG.Sens.MgBedPRI</IndexLocation>
<StreamLocation>^DHCNMG.Sens.MgBedPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
