/// 耗材医嘱在途信息表
Class User.MATReservedDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATRD_RowId, SqlTableName = MAT_ReservedDetail ]
{

/// 在途类型: (此字段与Pointer对应)
/// 	"DspBat": 批次价模式DHC_OEDispBatch的rowid;
/// 	"Oeori": 统一价模式,医嘱(或执行记录)rowid;
/// 	"Inrqi": 请求单在途,请求单明细;
Property MATRDType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATRD_Type ];

/// 对应Type字段解释
Property MATRDPointer As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = MATRD_Pointer ];

/// 按科室库存设置在途,此字段非空
Property MATRDINCILDR As User.INCItmLoc [ SqlColumnNumber = 4, SqlFieldName = MATRD_INCIL_DR ];

/// 按科室批次设置在途,此字段非空
Property MATRDINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 5, SqlFieldName = MATRD_INCLB_DR ];

/// 在途数(基本单位),清在途时调整此字段
Property MATRDQty As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATRD_Qty ];

/// 科室
Property MATRDCTLOCDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = MATRD_CTLOC_DR ];

Property MATRDDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = MATRD_Date ];

Property MATRDTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MATRD_Time ];

/// 清除标记
Property MATRDClearFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = MATRD_ClearFlag ];

/// 在途初始值
Property MATRDInitialQty As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = MATRD_InitialQty ];

Index TypePointer On (MATRDType As Exact, MATRDPointer As Exact);

Index Date On MATRDDate As Exact;

Index Incil On (MATRDINCILDR As Exact, MATRDClearFlag As Exact);

Index Inclb On (MATRDINCLBDR As Exact, MATRDClearFlag As Exact);

Storage Default
{
<Data name="MATReservedDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATRDType</Value>
</Value>
<Value name="3">
<Value>MATRDPointer</Value>
</Value>
<Value name="4">
<Value>MATRDINCILDR</Value>
</Value>
<Value name="5">
<Value>MATRDINCLBDR</Value>
</Value>
<Value name="6">
<Value>MATRDQty</Value>
</Value>
<Value name="7">
<Value>MATRDCTLOCDR</Value>
</Value>
<Value name="8">
<Value>MATRDDate</Value>
</Value>
<Value name="9">
<Value>MATRDTime</Value>
</Value>
<Value name="10">
<Value>MATRDClearFlag</Value>
</Value>
<Value name="11">
<Value>MATRDInitialQty</Value>
</Value>
</Data>
<DataLocation>^User.MATReservedDetailD</DataLocation>
<DefaultData>MATReservedDetailDefaultData</DefaultData>
<IdLocation>^User.MATReservedDetailD</IdLocation>
<IndexLocation>^User.MATReservedDetailI</IndexLocation>
<SqlRowIdName>MATRD_RowId</SqlRowIdName>
<StreamLocation>^User.MATReservedDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
