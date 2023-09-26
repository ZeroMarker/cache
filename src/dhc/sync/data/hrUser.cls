/// 人员表
Class dhc.sync.data.hrUser Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_hrUser ]
{

//code Name Password Deptcode State Email InvalidDate UpdateDate EegDate Type

//Mnemonics HealthType IsExpert Secgroup Certificate ISDrugRight Number Ename

//助记码 医护类型 专家(Y/N) 安全组 医师资格证号 毒麻处方权（Y/N) 人员序号 英文名

Property Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Hr_Code ];

Property Name As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Hr_Name ];

Property Password As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Hr_Password ];

Property Deptcode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Hr_Deptcode ];

//1有效 2无效

Property State As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Hr_State ];

Property Email As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Hr_Email ];

Property InvalidDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Hr_InvalidDate ];

Property UpdateDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Hr_UpdateDate ];

Property EegDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Hr_EegDate ];

Property Type As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Hr_Type ];

Property Mnemonics As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Hr_Mnemonics ];

Property HealthType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Hr_HealthType ];

Property IsExpert As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = Hr_IsExpert ];

Property Secgroup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Hr_Secgroup ];

Property Certificate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Hr_Certificate ];

Property ISDrugRight As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = Hr_ISDrugRight ];

Property Number As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = Hr_Number ];

Property Ename As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Hr_Ename ];

Storage Default
{
<Data name="hrUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Dept</Value>
</Value>
<Value name="5">
<Value>entryDate</Value>
</Value>
<Value name="6">
<Value>Password</Value>
</Value>
<Value name="7">
<Value>Deptcode</Value>
</Value>
<Value name="8">
<Value>State</Value>
</Value>
<Value name="9">
<Value>Email</Value>
</Value>
<Value name="10">
<Value>InvalidDate</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>EegDate</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
<Value name="14">
<Value>Mnemonics</Value>
</Value>
<Value name="15">
<Value>HealthType</Value>
</Value>
<Value name="16">
<Value>IsExpert</Value>
</Value>
<Value name="17">
<Value>Secgroup</Value>
</Value>
<Value name="18">
<Value>Certificate</Value>
</Value>
<Value name="19">
<Value>ISDrugRight</Value>
</Value>
<Value name="20">
<Value>Number</Value>
</Value>
<Value name="21">
<Value>Ename</Value>
</Value>
</Data>
<DataLocation>^dhcsynchrUserD</DataLocation>
<DefaultData>hrUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsynchrUserD</IdLocation>
<IndexLocation>^dhcsynchrUserI</IndexLocation>
<StreamLocation>^dhc.sync.data.hrUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
