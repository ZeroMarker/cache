/// Function:收费项扩展表 
/// CreateDate:2021-06-17
/// Creator:sunfengchao
Class User.DHCTarItemExtend Extends %Persistent [ SqlRowIdName = TARIE_RowId, SqlTableName = DHC_TarItemExtend, StorageStrategy = SQLtorage ]
{

/// 院内重点耗材-地坛
Property TARIHospHVMFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = TARI_HospHVMFlag ];

/// 物价备注-北大一院
Property TARIPriceRemark As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TARI_PriceRemark ];

/// 是否统计护理数据  -南方医院太和分院
Property TARIStatisticNursingData As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = TARI_StatisticNursingData ];

/// 检查检验标准编码  - 浙江慈林医院
Property TARIInspectStandardCode As %String [ SqlColumnNumber = 5, SqlFieldName = TARI_InspectStandardCode ];

/// 检查检验标准名称  - 浙江慈林医院
Property TARIInspectStandardName As %String [ SqlColumnNumber = 6, SqlFieldName = TARI_InspectStandardName ];

/// 物价本原价  -广东韶关曲江人民 
Property TARICostPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = TARI_CostPrice ];

/// 材料医保属性  (甲乙丙) - 北京航空总院
Property TARIInsuType As %String(DISPLAYLIST = ",甲,乙,丙", MAXLEN = 3, VALUELIST = ",F,S,T") [ SqlColumnNumber = 8, SqlFieldName = TARI_InsuType ];

Storage SQLtorage
{
<SQLMap name="DataMap">
<Data name="TARI_CostPrice">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>6</Piece>
</Data>
<Data name="TARI_HospHVMFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>1</Piece>
</Data>
<Data name="TARI_InspectStandardCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>4</Piece>
</Data>
<Data name="TARI_InspectStandardName">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>5</Piece>
</Data>
<Data name="TARI_InsuType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>7</Piece>
</Data>
<Data name="TARI_PriceRemark">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>2</Piece>
</Data>
<Data name="TARI_StatisticNursingData">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>3</Piece>
</Data>
<Global>^DHCTARI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TARIE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TARIE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTarItemExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
