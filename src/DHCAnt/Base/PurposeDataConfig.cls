/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物基础数据字典统一配置表：指征、感染部位、目的、特殊抗菌药指征、预防用药时间、致病菌字典库
Class DHCAnt.Base.PurposeDataConfig Extends (%Persistent, User.Abstract) [ StorageStrategy = CacheSQLStorage ]
{

/// PDC_Type 表类型
Property PDCType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PDC_Type ];

/// PDC_TypeDesc 表类型说明
Property PDCTypeDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PDC_TypeDesc ];

/// PDC_Value 值
Property PDCValue As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDC_Value ];

/// PDC_Code 代码
Property PDCCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PDC_Code ];

/// PDC_Active 是否激活
Property PDCActive As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PDC_Active ];

/// PDC_ParentOBJ 指向关联表
Property PDCParentOBJ As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PDC_ParentOBJ ];

/// PDC_ParentAimItem 指向使用目的子类表 DHC_CTAntUseReasonItem
Property PDCParentAimItem As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PDC_ParentAimItem ];

/// PDC_SpecialFlag 特殊标志
Property PDCSpecialFlag As %Library.String [ SqlColumnNumber = 9, SqlFieldName = PDC_SpecialFlag ];

/// PDC_InfectDepFlag 感染性疾病科标志
Property PDCInfectDepFlag As %Library.String [ SqlColumnNumber = 10, SqlFieldName = PDC_InfectDepFlag ];

/// PDC_Seqno 显示顺序
Property PDCSeqno As %Library.String [ SqlColumnNumber = 11, SqlFieldName = PDC_Seqno ];

/// PDC_Hosp 显示顺序
Property PDCHosp As User.CTHospital [ SqlColumnNumber = 12, SqlFieldName = PDC_Hosp ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCAntBasePurposeDataConfigD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDC_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDC_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDC_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDC_InfectDepFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDC_ParentAimItem">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDC_ParentOBJ">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDC_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDC_SpecialFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDC_TypeDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDC_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAntBasePurposeDataConfigD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDC_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPDCParentOBJ">
<Global>^DHCAntBasePurposeDataConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PDCParentOBJ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDC_ParentOBJ}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDC_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDCParentOBJType">
<Global>^DHCAntBasePurposeDataConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PDCParentOBJTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDC_ParentOBJ}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDC_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDCType">
<Global>^DHCAntBasePurposeDataConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PDCType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDC_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDC_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDC_ID</SqlRowIdName>
<StreamLocation>^DHCAnt.Base.PurposeDataConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
