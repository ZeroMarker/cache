/// 科室关注人员
Class dbo.BTLocationLinkCare Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_LocationLinkCare ]
{

Index IndexMaster On (LocationDR, UserType, UserDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUser On (UserDR, LocationDR, UserType) [ SqlName = Index_User, Type = index ];

Index IndexSequence On (LocationDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTLOCATIONLINKCARE On RowID [ PrimaryKey, SqlName = PK_BT_LocationLinkCare, Type = index, Unique ];

/// Foreign Key FKLocationDR created via DDL
ForeignKey FKLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BT_LocationLinkCare_LocationDR ];

ForeignKey FKUserDR(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BT_LocationLinkCare_UserDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 人员类型  
Property UserType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 人员  
Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 是否主管  {1:true,0:false}
Property IsDirector As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTLocationLinkCareDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocationDR</Value>
</Value>
<Value name="3">
<Value>UserType</Value>
</Value>
<Value name="4">
<Value>UserDR</Value>
</Value>
<Value name="5">
<Value>IsDirector</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTLocationLinkCareD</DataLocation>
<DefaultData>BTLocationLinkCareDefaultData</DefaultData>
<IdLocation>^dbo.BTLocationLinkCareD</IdLocation>
<IndexLocation>^dbo.BTLocationLinkCareI</IndexLocation>
<StreamLocation>^dbo.BTLocationLinkCareS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
