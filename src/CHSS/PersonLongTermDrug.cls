Class CHSS.PersonLongTermDrug Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DrugRowId, SqlTableName = PersonLongTermDrug ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain;

// 开始用药日期

Property DateOfStart As %Date;

// 结束用药日期

Property DateOfEnd As %Date;

// 药物名称

Property DrugName As %String(MAXLEN = 60, TRUNCATE = 1);

// 药物编码

Property DrugCode As %String(MAXLEN = 30, TRUNCATE = 1);

// 用法

Property Useage As %String(MAXLEN = 50, TRUNCATE = 1);

// 用量

Property Dosage As %String(MAXLEN = 50, TRUNCATE = 1);

// 不良反应

Property ADR As %String(MAXLEN = 50, TRUNCATE = 1);

// 备注

Property Remark As %String(MAXLEN = 50, TRUNCATE = 1);

// 记录号(用来记录年检记录号）

Property RecordId As %String(MAXLEN = 5, TRUNCATE = 1);

// 记录类别

Property RecordType As %String(MAXLEN = 5, TRUNCATE = 1);

/// 对应表
Property TableName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 表中类别
Property TableType As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="PersonLongTermDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ADR</Value>
</Value>
<Value name="3">
<Value>DateOfEnd</Value>
</Value>
<Value name="4">
<Value>DateOfStart</Value>
</Value>
<Value name="5">
<Value>Dosage</Value>
</Value>
<Value name="6">
<Value>DrugCode</Value>
</Value>
<Value name="7">
<Value>DrugName</Value>
</Value>
<Value name="8">
<Value>RecordId</Value>
</Value>
<Value name="9">
<Value>RecordType</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>Useage</Value>
</Value>
<Value name="12">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="13">
<Value>TableName</Value>
</Value>
<Value name="14">
<Value>TableType</Value>
</Value>
<Value name="15">
<Value>PersonRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonLongTermDrugD</DataLocation>
<DefaultData>PersonLongTermDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonLongTermDrugD</IdLocation>
<IndexLocation>^CHSS.PersonLongTermDrugI</IndexLocation>
<StreamLocation>^CHSS.PersonLongTermDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
