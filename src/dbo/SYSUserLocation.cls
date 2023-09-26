///     
Class dbo.SYSUserLocation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UserLocation, StorageStrategy = Default ]
{

/// Foreign Key FKUserLocation created via DDL
ForeignKey FKUserLocation(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UserLocation ];

/// Foreign Key FKUserLocationGrp created via DDL
ForeignKey FKUserLocationGrp(GroupDR) References dbo.SYSGroup(PKSYSGROUP) [ SqlName = FK_UserLocationGrp ];

/// Foreign Key FKUserLocationLoc created via DDL
ForeignKey FKUserLocationLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_UserLocationLoc ];

Index IndexMaster On (UserDR, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSUSERLOCATION On RowID [ PrimaryKey, SqlName = PK_SYS_USERLOCATION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property GroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSUserLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
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
<DataLocation>^dbo.SYSUserLocationD</DataLocation>
<DefaultData>SYSUserLocationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserLocationD</IdLocation>
<IndexLocation>^dbo.SYSUserLocationI</IndexLocation>
<StreamLocation>^dbo.SYSUserLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
