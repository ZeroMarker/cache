Class dbo.BDPatRegisterBloodGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PatRegisterBloodGroup ]
{

/// Foreign Key FKBBBGCMGroup created via DDL
ForeignKey FKBDPatRegisterBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_PatRegisterBloodGroup ];

/// Foreign Key FKBDAgreeFAddUser created via DDL
ForeignKey FKBDPATREGAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PATREGAddUser ];

ForeignKey FKBDPATREGCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PATREGCheckUser ];

Index IndexRegNo On (RegNo, AddDate) [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPATREGTESTRESULT On RowID [ PrimaryKey, SqlName = PK_BD_PATREGBLDGROUP, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 3 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property ClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPatRegisterBloodGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>BloodGroupDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>CheckUserDR</Value>
</Value>
<Value name="8">
<Value>ClientIP</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPatRegisterBloodGroupD</DataLocation>
<DefaultData>BDPatRegisterBloodGroupDefaultData</DefaultData>
<IdLocation>^dbo.BDPatRegisterBloodGroupD</IdLocation>
<IndexLocation>^dbo.BDPatRegisterBloodGroupI</IndexLocation>
<StreamLocation>^dbo.BDPatRegisterBloodGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
