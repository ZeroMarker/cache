Class User.DHCItmPicture Extends (%Persistent, User.Abstract) [ SqlRowIdName = IPIC_RowId, SqlTableName = DHC_ItmPicture, StorageStrategy = SqlStorage ]
{

/// 图片名称
Property IPICFileName As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IPIC_FileName ];

/// 图片类型
Property IPICType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IPIC_Type ];

/// 上传人
Property IPICSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = IPIC_SSUSR_DR ];

/// 上传日期
Property IPICDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = IPIC_Date ];

/// 上传时间
Property IPICTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = IPIC_Time ];

/// 激活标志
Property IPICActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = IPIC_Active ];

/// 指向表RowId
Property IPICPointer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IPIC_Pointer ];

/// 数据类型：SalesMan(业务员)、comLic(营业执照)等
Property IPICPointerType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IPIC_PointerType ];

/// 来源分类Person(人员)、Cert(资质)等
Property IPICGrpType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = IPIC_GrpType ];

/// 对象ID(供应商或生产厂家)
Property IPICOrgId As %Library.String [ SqlColumnNumber = 11, SqlFieldName = IPIC_OrgId ];

/// 对象Vendor\Manf\Inci等
Property IPICOrgType As %Library.String [ SqlColumnNumber = 12, SqlFieldName = IPIC_OrgType ];

/// 图片链接
Property IPICFileSrc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IPIC_FileSrc ];

/// 数据子类型
Property IPICSubType As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 14, SqlFieldName = IPIC_SubType ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCIPIC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPIC_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPIC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPIC_FileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPIC_FileSrc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPIC_GrpType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPIC_OrgId">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPIC_OrgType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPIC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPIC_PointerType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPIC_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPIC_SubType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPIC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCIPIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IPIC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IPIC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmPictureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCIPIC)
	s oldI = +$g(^mdata("DHCIPIC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCIPIC = maxI
	s ^mdata("DHCIPIC") = maxI
}

}
