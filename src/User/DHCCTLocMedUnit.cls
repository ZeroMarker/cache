/// Creator:      周志强
/// CreatDate:    2010.07.08
/// Description:: 医疗单元定义,作为科室的子表
Class User.DHCCTLocMedUnit Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlRowIdName = MU_RowId, SqlTableName = DHC_CTLoc_MedUnit, StorageStrategy = SQLStorage1 ]
{

Relationship ChildCareProv As User.DHCCTLocMedUnitCareProv [ Cardinality = children, Inverse = MUCPParRef ];

Index RowIDBasedIDKeyIndex On (CTMUCTLOCParRef, CTMUChildsub) [ IdKey, PrimaryKey, Unique ];

/// 代码
Property CTMUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = CTMU_Code ];

/// 描述
Property CTMUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = CTMU_Desc ];

/// 激活标志
Property CTMUActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 6, SqlFieldName = CTMU_ActiveFlag ];

/// 开始日期
Property CTMUDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = CTMU_DateFrom ];

/// 截止日期
Property CTMUDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = CTMU_DateTo ];

/// 科室主表指针
Property CTMUCTLOCParRef As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = CTMU_CTLOC_ParRef ];

/// CTMU_Childsub
Property CTMUChildsub As %Float [ InitialExpression = {$i(^CTLOC(+$s($d(initvalue):initvalue,1:%d(2)),"MU",0))}, SqlColumnNumber = 3, SqlFieldName = CTMU_Childsub ];

/// 门诊出诊标志
Property CTMUOPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = CTMU_OPFlag ];

/// 住院出诊标志
Property CTMUIPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 10, SqlFieldName = CTMU_IPFlag ];

Storage SQLStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMast">
<Data name="CTMU_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTMU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTMU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTMU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTMU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTMU_IPFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTMU_OPFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTMU_CTLOC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CTMU_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CTMU_CTLOC_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"MU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTMU_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCTLocMedUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
