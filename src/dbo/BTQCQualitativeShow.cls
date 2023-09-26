/// 定性展示维护
Class dbo.BTQCQualitativeShow Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_QualitativeShow ]
{

/// Foreign Key FKBTQCQualitativeShowMaterialDR created via DDL
ForeignKey FKBTQCQualitativeShowMaterialDR(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_BTQCQualitativeShowMaterialDR ];

/// Foreign Key FKBTQCQualitativeShowTestCodeDR created via DDL
ForeignKey FKBTQCQualitativeShowTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCQualitativeShowTestCodeDR ];

Index IndexMaster On (MaterialDR, TestCodeDR, Line) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCQUALITATIVESHOW On RowID [ PrimaryKey, SqlName = PK_BTQC_QUALITATIVESHOW, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标线  
Property Line As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

/// 绘制
Property DrawTxt As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTQCQualitativeShowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Line</Value>
</Value>
<Value name="5">
<Value>DrawTxt</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCQualitativeShowD</DataLocation>
<DefaultData>BTQCQualitativeShowDefaultData</DefaultData>
<IdLocation>^dbo.BTQCQualitativeShowD</IdLocation>
<IndexLocation>^dbo.BTQCQualitativeShowI</IndexLocation>
<StreamLocation>^dbo.BTQCQualitativeShowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
