///     
Class dbo.SYSUserReagentGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UserReagentGroup, StorageStrategy = Default ]
{

Index IndexMaster On (UserDR, ReagentGroupDR, GroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequece On Sequence [ SqlName = Index_Sequece, Type = index ];

/// DDL Primary Key Specification
Index PKSYSUSERREAGENTGROUP On RowID [ PrimaryKey, SqlName = PK_SYS_USERREAGENTGROUP, Type = index, Unique ];

/// Foreign Key FKRGUserReagentGroupGroup created via DDL
ForeignKey FKRGUserReagentGroupGroup(GroupDR) References dbo.SYSGroup(PKSYSGROUP) [ SqlName = FK_RG_UserReagentGroup_Group ];

/// Foreign Key FKRGUserReagentGroupReagentGroup created via DDL
ForeignKey FKRGUserReagentGroupReagentGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_UserReagentGroup_ReagentGroup ];

/// Foreign Key FKRGUserReagentGroupUser created via DDL
ForeignKey FKRGUserReagentGroupUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_UserReagentGroup_User ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property GroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSUserReagentGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="4">
<Value>GroupDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUserReagentGroupD</DataLocation>
<DefaultData>SYSUserReagentGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserReagentGroupD</IdLocation>
<IndexLocation>^dbo.SYSUserReagentGroupI</IndexLocation>
<StreamLocation>^dbo.SYSUserReagentGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
