/// 文件收藏
Class dbo.OTFileCollection Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileCollection ]
{

Index IndexUserDR On (UserDR, OTFileInfoDR) [ SqlName = Index_UserDR, Type = index, Unique ];

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileInfoDR ];

/// Foreign Key FKRightUser created via DDL
ForeignKey FKUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_User ];

/// DDL Primary Key Specification
Index PKOTFILEPERMISSION On RowID [ PrimaryKey, SqlName = PK_OT_FILEPERMISSION, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 文件  
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 收藏日期  
Property CollectDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 收藏时间  
Property CollectTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 收藏用户  
Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="OTFileCollectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>CollectDate</Value>
</Value>
<Value name="4">
<Value>CollectTime</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileCollectionD</DataLocation>
<DefaultData>OTFileCollectionDefaultData</DefaultData>
<IdLocation>^dbo.OTFileCollectionD</IdLocation>
<IndexLocation>^dbo.OTFileCollectionI</IndexLocation>
<StreamLocation>^dbo.OTFileCollectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
