Class dhc.sync.data.User Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Sync_Rowid, SqlTableName = Sync_User ]
{

// code Name Password Deptcode State Email InvalidDate EffectiveDate EegDate Type

// Mnemonics HealthType IsExpert Secgroup Certificate ISDrugRight Number Ename 

// 助记码 医护类型 专家(Y/N) 安全组 医师资格证号 毒麻处方权（Y/N) 人员序号 英文名 

// Fname Company Position Dleader Cellphone Landline

// 姓    公司 	职务	直属领导 电话 		座机

Property Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Sync_Code ];

Property Name As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Sync_Name ];

Property Password As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Sync_Password ];

// 科室代码

Property Deptcode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Sync_Deptcode ];

// 1有效 2无效

Property State As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Sync_State ];

Property Email As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Sync_Email ];

// 有效日期

Property InvalidDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Sync_InvalidDate ];

Property UpdateDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Sync_UpdateDate ];

// 结束日期

Property EegDate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Sync_EegDate ];

Property Type As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Sync_Type ];

// 助记码

Property Mnemonics As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Sync_Mnemonics ];

// 医护类型

Property HealthType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Sync_HealthType ];

// 是否是专家

Property IsExpert As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = Sync_IsExpert ];

// 安全组

Property Secgroup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Sync_Secgroup ];

// 医师资格证

Property Certificate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Sync_Certificate ];

// 毒麻处方权

Property ISDrugRight As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = Sync_ISDrugRight ];

// 序号

Property Number As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = Sync_Number ];

// 英文名

Property Ename As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Ename ];

// 姓

Property Fname As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = Fname ];

// 公司

Property Company As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = Company ];

// 职务

Property Position As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = Position ];

// 领导

Property Dleader As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = Dleader ];

// 电话

Property Cellphone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = Cellphone ];

// 座机

Property Landline As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = Landline ];

/// 修改密码日期
Property PasswordDate As %Date [ SqlColumnNumber = 26, SqlFieldName = PasswordDate ];

Index SyncUserCode On Code;

Index SyncUserEmail On Email;

Index LogonUserCode On Code As AlphaUp;

Storage Default
{
<Data name="UserDefaultData">
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
<Value>Password</Value>
</Value>
<Value name="5">
<Value>Deptcode</Value>
</Value>
<Value name="6">
<Value>State</Value>
</Value>
<Value name="7">
<Value>Email</Value>
</Value>
<Value name="8">
<Value>InvalidDate</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>EegDate</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>Mnemonics</Value>
</Value>
<Value name="13">
<Value>HealthType</Value>
</Value>
<Value name="14">
<Value>IsExpert</Value>
</Value>
<Value name="15">
<Value>Secgroup</Value>
</Value>
<Value name="16">
<Value>Certificate</Value>
</Value>
<Value name="17">
<Value>ISDrugRight</Value>
</Value>
<Value name="18">
<Value>Number</Value>
</Value>
<Value name="19">
<Value>Ename</Value>
</Value>
<Value name="20">
<Value>Fname</Value>
</Value>
<Value name="21">
<Value>Company</Value>
</Value>
<Value name="22">
<Value>Position</Value>
</Value>
<Value name="23">
<Value>Dleader</Value>
</Value>
<Value name="24">
<Value>Cellphone</Value>
</Value>
<Value name="25">
<Value>Landline</Value>
</Value>
<Value name="26">
<Value>PasswordDate</Value>
</Value>
</Data>
<DataLocation>^dhcsyncUserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncUserD</IdLocation>
<IndexLocation>^dhcsyncUserI</IndexLocation>
<StreamLocation>^dhcsyncUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
