/// Creater:wangpf
/// Descriptions:计划周、日重点
/// Date:2020-07-07
Class DHCINM.HB.MgPlanKey Extends %Persistent
{

/// 重点病区
Property KeyWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Key_Ward ];

/// 重点类型 W:周 D:日
Property KeyType As %String(DISPLAYLIST = ",周重点,日重点", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",W,D") [ SqlColumnNumber = 3, SqlFieldName = Key_Type ];

/// 重点日期(周重点为开始日期)
Property KeyDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Key_Date ];

/// 重点内容
Property KeyContent As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = Key_Content ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

Index Type On KeyType;

Index WardDate On (KeyType, KeyWard, KeyDate);

Storage Default
{
<Data name="MgPlanKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyWard</Value>
</Value>
<Value name="3">
<Value>KeyType</Value>
</Value>
<Value name="4">
<Value>KeyDate</Value>
</Value>
<Value name="5">
<Value>KeyContent</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPlanKeyD</DataLocation>
<DefaultData>MgPlanKeyDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPlanKeyD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPlanKeyI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPlanKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
