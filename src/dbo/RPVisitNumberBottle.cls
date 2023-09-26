///     
Class dbo.RPVisitNumberBottle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberBottle ]
{

/// Foreign Key FKRPVisitNumberBottleVisitNumberDR created via DDL
ForeignKey FKRPVisitNumberBottleVisitNumberDR(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RPVisitNumberBottleVisitNumberDR ];

/// Foreign Key FKRPVisitNumberBottleWorkGroupMachineDR created via DDL
ForeignKey FKRPVisitNumberBottleWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RPVisitNumberBottleWorkGroupMachineDR ];

/// Foreign Key FKRPVisitNumberBottleAddUserDR created via DDL
ForeignKey FKRPVisitNumberBottleAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPVisitNumberBottleAddUserDR ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERBOTTLE On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERBOTTLE, Type = index, Unique ];

Index IndexMaster On (VisitNumberDR, BottleNo) [ SqlName = Index_Master, Type = index ];

Index IndexBottleNo On BottleNo [ SqlName = Index_BottleNo, Type = index ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, AddDate) [ SqlName = Index_WorkGroupMachine, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property BottleNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPVisitNumberBottleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>BottleNo</Value>
</Value>
<Value name="4">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberBottleD</DataLocation>
<DefaultData>RPVisitNumberBottleDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberBottleD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberBottleI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberBottleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
