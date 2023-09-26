Class User.DHCSubLocUserReqMonthlyConfig Extends %Persistent [ ClassType = persistent, SqlRowIdName = URQ_RowId, SqlTableName = DHC_SubLocUserReqMonthlyConfig, StorageStrategy = CacheSqlStorage ]
{

/// URQ_SubLoc_DR  //科室rowid 
Property URQSubLocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = URQ_SubLoc_DR ];

/// URQ_SSUSR_DR  //用户rowid 
Property URQSSUSRDR As User.SSUser [ Required, SqlColumnNumber = 3, SqlFieldName = URQ_SSUSR_DR ];

/// URQ_SCG_DR  //类组rowid
Property URQSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = URQ_SCG_DR ];

/// URQ_StkCat_DR  //分类rowid
Property URQStkCatDR As User.INCStkCat [ SqlColumnNumber = 5, SqlFieldName = URQ_StkCat_DR ];

/// URQ_INCI_DR //库存项rowid
Property URQINCIDR As User.INCItm [ SqlColumnNumber = 6, SqlFieldName = URQ_INCI_DR ];

/// URQ_ReqAmt  reqamt
Property URQReqAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = URQ_ReqAmt ];

/// URQ_ReqQty
Property URQReqQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = URQ_ReqQty ];

/// URQ_CTUOM_DR
Property URQCTUOMDR As User.CTUOM [ SqlColumnNumber = 9, SqlFieldName = URQ_CTUOM_DR ];

/// URQ_ReqAmtOfThisMonth
Property URQReqAmtOfThisMonth As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = URQ_ReqAmtOfThisMonth ];

/// URQ_ReqQtyOfThisMonth     
Property URQReqQtyOfThisMonth As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = URQ_ReqQtyOfThisMonth ];

/// URQ_ConfigType 配置类型 (0 - 类组,1-库存项)
Property URQConfigType As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = URQ_ConfigType ];

/// URQ_CurMon 当前月份 YYYY-MM
Property URQCurMon As %String [ SqlColumnNumber = 13, SqlFieldName = URQ_CurMon ];

Storage CacheSqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLOCRQCONFIG("SLU"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="URQ_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="URQ_ConfigType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="URQ_CurMon">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="URQ_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URQ_ReqAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="URQ_ReqAmtOfThisMonth">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="URQ_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="URQ_ReqQtyOfThisMonth">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="URQ_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="URQ_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URQ_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URQ_SubLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLOCRQCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>URQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SLU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{URQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocUserINCI">
<Global>^DHCLOCRQCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>URQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SLU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{URQ_SubLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{URQ_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{URQ_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{URQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocUserSCG">
<Global>^DHCLOCRQCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>URQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SLU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"SCG"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{URQ_SubLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{URQ_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{URQ_SCG_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{URQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>URQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSubLocUserReqMonthlyConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLOCRQCONFIG("SLU"))
	s oldI = +$g(^mdata("DHCSUBLOCUSERREQMONTHLYCONFIG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLOCRQCONFIG("SLU") = maxI
	s ^mdata("DHCSUBLOCUSERREQMONTHLYCONFIG") = maxI
}

}
