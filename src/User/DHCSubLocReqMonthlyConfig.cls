Class User.DHCSubLocReqMonthlyConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RQ_RowId, SqlTableName = DHC_SubLocReqMonthlyConfig, StorageStrategy = SqlStorage ]
{

/// RQ_SubLoc_DR  //科室rowid 
Property RQSubLocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = RQ_SubLoc_DR ];

/// RQ_SCG_DR  //类组rowid
Property RQSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = RQ_SCG_DR ];

/// RQ_StkCat_DR  //分类rowid
Property RQStkCatDR As User.INCStkCat [ SqlColumnNumber = 4, SqlFieldName = RQ_StkCat_DR ];

/// RQ_INCI_DR //库存项rowid
Property RQINCIDR As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = RQ_INCI_DR ];

/// RQ_ReqAmt  reqamt
Property RQReqAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RQ_ReqAmt ];

/// RQ_ReqQty
Property RQReqQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RQ_ReqQty ];

/// RQ_CTUOM_DR
Property RQCTUOMDR As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = RQ_CTUOM_DR ];

/// RQ_ReqAmtOfThisMonth
Property RQReqAmtOfThisMonth As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = RQ_ReqAmtOfThisMonth ];

///  RQ_LUG_DR - DHC_LocUserGroup       
Property RQLUGDR As User.DHCSubLocUserGroup [ Required, SqlColumnNumber = 10, SqlFieldName = RQ_LUG_DR ];

///  RQ_ReqQtyOfThisMonth -        
Property RQReqQtyOfThisMonth As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = RQ_ReqQtyOfThisMonth ];

/// RQ_ConfigType 配置类型(0 - 类组,1-库存项)
Property RQConfigType As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = RQ_ConfigType ];

/// RQ_CurMon YYYY-MM
Property RQCurMon As %String [ SqlColumnNumber = 13, SqlFieldName = RQ_CurMon ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLOCRQCONFIG("LUG"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RQ_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RQ_ConfigType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RQ_CurMon">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RQ_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RQ_LUG_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RQ_ReqAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RQ_ReqAmtOfThisMonth">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RQ_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RQ_ReqQtyOfThisMonth">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RQ_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RQ_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RQ_SubLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLOCRQCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"LUG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{RQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^DHCLOCRQCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"LUG"</Expression>
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
<Expression>{RQ_SubLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RQ_LUG_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RQ_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{RQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocSCG">
<Global>^DHCLOCRQCONFIG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"LUG"</Expression>
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
<Expression>{RQ_SubLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RQ_LUG_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RQ_SCG_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{RQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSubLocReqMonthlyConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLOCRQCONFIG("LUG"))
	s oldI = +$g(^mdata("DHCSUBLOCREQMONTHLYCONFIG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLOCRQCONFIG("LUG") = maxI
	s ^mdata("DHCSUBLOCREQMONTHLYCONFIG") = maxI
}

}
