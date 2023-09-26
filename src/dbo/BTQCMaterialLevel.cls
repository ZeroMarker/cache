/// 质控物浓度
Class dbo.BTQCMaterialLevel Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLevel, StorageStrategy = Default ]
{

/// Foreign Key FKMaterialLevel created via DDL
ForeignKey FKMaterialLevel(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_MaterialLevel ];

Index IndexMaster On (MaterialDR, LevelNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLEVEL On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLEVEL, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物  
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 质控浓度  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 浓度名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 颜色
Property Colour As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTQCMaterialLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>LevelNo</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Colour</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLevelD</DataLocation>
<DefaultData>BTQCMaterialLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialLevelD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLevelI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
