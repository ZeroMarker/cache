/// 客户端电脑
Class dbo.OTComputer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_Computer ]
{

/// Foreign Key FKOTComputerHospitalDR created via DDL
ForeignKey FKOTComputerHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_OTComputerHospitalDR ];

/// Foreign Key FKOTComputerAddUserDR created via DDL
ForeignKey FKOTComputerAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OTComputerAddUserDR ];

/// DDL Primary Key Specification
Index PKOTCOMPUTER On RowID [ PrimaryKey, SqlName = PK_OT_COMPUTER, Type = index, Unique ];

Index IndexMaster On IPAddress [ SqlName = Index_IPAddress, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// IP地址  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 电脑描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 就诊类型  
Property AdmTypes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 添加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="OTComputerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IPAddress</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>AdmTypes</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.OTComputerD</DataLocation>
<DefaultData>OTComputerDefaultData</DefaultData>
<IdLocation>^dbo.OTComputerD</IdLocation>
<IndexLocation>^dbo.OTComputerI</IndexLocation>
<StreamLocation>^dbo.OTComputerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
