Class User.DHCHVMatItmCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = IC_RowId, SqlTableName = DHC_HVMat_ItmCheckList, StorageStrategy = SqlStorage ]
{

/// HIS医嘱项代码
Property ICHISItmCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IC_HISItmCode ];

/// HIS医嘱项名称
Property ICHISItmDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IC_HISItmDesc ];

/// 东华物资库存项代码
Property ICINCItmCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IC_INCItmCode ];

/// 东华物资库存项名称
Property ICINCItmDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IC_INCItmDesc ];

/// 东华物资库存项RowId
Property ICINCIDR As User.INCItm [ SqlColumnNumber = 6, SqlFieldName = IC_INCI_DR ];

/// 下属医院id
Property ICHospCompDR As User.DHCHospComp [ Required, SqlColumnNumber = 7, SqlFieldName = IC_HospComp_DR ];

/// 单位转换分子  例如:本系统单位盒(7),下属医院单位只,分子为7 分母为1
Property ICUomNum As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IC_UomNum ];

/// 单位转换分母
Property ICUomDen As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IC_UomDen ];

/// HIS物资规格
Property ICHISItmSpec As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IC_HISItmSpec ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCHVMIL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IC_HISItmCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IC_HISItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IC_HISItmSpec">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IC_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IC_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IC_INCItmCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IC_INCItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IC_UomDen">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IC_UomNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCHVMIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHisItmCode">
<Global>^DHCHVMIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HISITMCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({IC_HISItmCode})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCITM">
<Global>^DHCHVMIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IC_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatItmCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
