/// 标本容器
Class dbo.BTContainer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Container, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTCONTAINER On RowID [ PrimaryKey, SqlName = PK_BT_CONTAINER, Type = index, Unique ];

/// Foreign Key FKContainerHospital created via DDL
ForeignKey FKContainerHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_ContainerHospital ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 容量  
Property Volumn As %Library.Float [ SqlColumnNumber = 6 ];

/// 颜色  
Property Color As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 图片  
Property Photo As %Library.String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 11 ];

/// ConType  
Property ConType As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTContainerDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Volumn</Value>
</Value>
<Value name="6">
<Value>Color</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>Photo</Value>
</Value>
<Value name="11">
<Value>ConType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTContainerD</DataLocation>
<DefaultData>BTContainerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTContainerD</IdLocation>
<IndexLocation>^dbo.BTContainerI</IndexLocation>
<StreamLocation>^dbo.BTContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
