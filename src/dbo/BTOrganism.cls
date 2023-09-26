/// 细菌
Class dbo.BTOrganism Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Organism, StorageStrategy = Default ]
{

/// Foreign Key FKOrganismGenus created via DDL
ForeignKey FKOrganismGenus(GenusDR) References dbo.BTGenus(PKBTGENUS) [ SqlName = FK_OrganismGenus ];

/// Foreign Key FKOrganismGroup created via DDL
ForeignKey FKOrganismGroup(OrganismGroupDR) References dbo.BTOrganismGroup(PKBTORGANISMGROUP) [ SqlName = FK_OrganismGroup ];

/// Foreign Key FKOrganismClass created via DDL
ForeignKey FKOrganismClass(OrganismClassDR) References dbo.BTOrganismClass(PKBTOrganismClass) [ SqlName = FK_OrganismClass ];

Index IndexOrganismClass On OrganismClassDR [ SqlName = Index_OrganismClass, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexWCode On WCode [ SqlName = Index_WCode, Type = index ];

Index IndexLISCode On LISCode [ SqlName = Index_LISCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTORGANISM On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 英文名  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 简称  
Property SName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// Whonet码  
Property WCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 革兰氏  
Property Gram As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

/// 状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

/// 细菌组  
Property OrganismGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 菌属  
Property GenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// OrgGroup  
Property OrgGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// OrgSubGroup  
Property OrgSubGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 15 ];

/// 使用次数  
Property UseNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 阴阳性  {P:阳性,N:阴性}
Property Positive As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 17 ];

/// 细菌提示  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 18 ];

///       
Property LISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 细菌分类
Property OrganismClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BTOrganismDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>EName</Value>
</Value>
<Value name="5">
<Value>SName</Value>
</Value>
<Value name="6">
<Value>WCode</Value>
</Value>
<Value name="7">
<Value>Gram</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>OrganismGroupDR</Value>
</Value>
<Value name="10">
<Value>GenusDR</Value>
</Value>
<Value name="11">
<Value>OrgGroup</Value>
</Value>
<Value name="12">
<Value>OrgSubGroup</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
<Value name="14">
<Value>Active</Value>
</Value>
<Value name="15">
<Value>UseNum</Value>
</Value>
<Value name="16">
<Value>Positive</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
<Value name="18">
<Value>LISCode</Value>
</Value>
<Value name="19">
<Value>OrganismClassDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismD</DataLocation>
<DefaultData>BTOrganismDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTOrganismD</IdLocation>
<IndexLocation>^dbo.BTOrganismI</IndexLocation>
<StreamLocation>^dbo.BTOrganismS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
