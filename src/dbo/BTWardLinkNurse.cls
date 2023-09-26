Class dbo.BTWardLinkNurse Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WardLinkNurse ]
{

Index IndexMaster On (WardDR, UserDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUser On (UserDR, WardDR) [ SqlName = Index_User, Type = index ];

Index IndexSequence On (WardDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWARDLINKNURSE On RowID [ PrimaryKey, SqlName = PK_BT_WardLinkNurse, Type = index, Unique ];

/// Foreign Key FKLocationDR created via DDL
ForeignKey FKWardDR(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BT_WardLinkNurse_WardDR ];

ForeignKey FKUserDR(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BT_WardLinkNurse_UserDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsDirector As %Library.Boolean [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTWardLinkNurseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>UserDR</Value>
</Value>
<Value name="4">
<Value>IsDirector</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWardLinkNurseD</DataLocation>
<DefaultData>BTWardLinkNurseDefaultData</DefaultData>
<IdLocation>^dbo.BTWardLinkNurseD</IdLocation>
<IndexLocation>^dbo.BTWardLinkNurseI</IndexLocation>
<StreamLocation>^dbo.BTWardLinkNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
