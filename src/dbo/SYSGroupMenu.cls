///     
Class dbo.SYSGroupMenu Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_GroupMenu, StorageStrategy = Default ]
{

/// Foreign Key FKGroupLinkModuleGrp created via DDL
ForeignKey FKGroupLinkModuleGrp(GroupDR) References dbo.SYSGroup(PKSYSGROUP) [ SqlName = FK_GroupLinkModuleGrp ];

/// Foreign Key FKGroupLinkModuleMenu created via DDL
ForeignKey FKGroupLinkModuleMenu(MenuDR) References dbo.SYSMenu(PKSYSMENU) [ SqlName = FK_GroupLinkModuleMenu ];

Index IndexMaster On (GroupDR, MenuDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSGROUPMENU On RowID [ PrimaryKey, SqlName = PK_SYS_GROUPMENU, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property GroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MenuDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="SYSGroupMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDR</Value>
</Value>
<Value name="3">
<Value>MenuDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSGroupMenuD</DataLocation>
<DefaultData>SYSGroupMenuDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSGroupMenuD</IdLocation>
<IndexLocation>^dbo.SYSGroupMenuI</IndexLocation>
<StreamLocation>^dbo.SYSGroupMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
