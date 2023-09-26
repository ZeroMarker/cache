/// 手术分组
Class dbo.BBOperationClassLink Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BB_OperationClassLink ]
{

/// Foreign Key created via DDL
ForeignKey FKBBOperationClassDR(BBOperationClassDR) References dbo.BBOperationClass(PKBOperationClassId) [ SqlName = FK_BB_OperationClassDR ];

/// Foreign Key created via DDL
ForeignKey FKBBOperationDR(BBOperationDR) References dbo.BBOperation(PKBBOperation) [ SqlName = FK_BB_OperationDR ];

Index IndexMaster On (BBOperationClassDR, BBOperationDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BBOperationClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property BBOperationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBOperationClassLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BBOperationClassDR</Value>
</Value>
<Value name="3">
<Value>BBOperationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBOperationClassLinkD</DataLocation>
<DefaultData>BBOperationClassLinkDefaultData</DefaultData>
<IdLocation>^dbo.BBOperationClassLinkD</IdLocation>
<IndexLocation>^dbo.BBOperationClassLinkI</IndexLocation>
<StreamLocation>^dbo.BBOperationClassLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
