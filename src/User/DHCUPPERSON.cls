/// 病人信息更新日志表
Class User.DHCUPPERSON Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UP_RowID, SqlTableName = DHCUPPERSON, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCUPPERSONDETAIL As User.DHCUPPERSONDETAIL [ Cardinality = children, Inverse = UPDParRef ];

/// UPCardInfo 卡内其他信息修改
Property UPCardInfo As %Library.String(COLLATION = "Exact", MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = UP_CardInfo ];

/// UPCardNo  卡号
Property UPCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = UP_CardNo ];

/// UPDate 修改日期
Property UPDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = UP_Date ];

/// UPPAPERName 修改前的病人姓名
Property UPPAPERName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = UP_PAPERName ];

/// UPRegistrationNo 登记号  
Property UPRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = UP_RegistrationNo ];

/// UPTime  修改时间
Property UPTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = UP_Time ];

/// UPUserDr 修改操作人
Property UPUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = UP_UserDr ];

/// UPPPAPERName 修改后的病人姓名
Property UPsPAPERName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = UPs_PAPERName ];

/// UPUserIP 修改操作IP地址
Property UPUserIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = UP_UserIP ];

Storage Default
{
<ExtentSize>100000</ExtentSize>
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.DHCUPPERSOND(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UP_CardInfo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UP_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UP_PAPERName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UP_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UP_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UP_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UP_UserIP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UPs_PAPERName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^User.DHCUPPERSOND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="UPCardNoIndex">
<Global>^User.DHCUPPERSONI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPCardNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UP_CardNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UPDateIndex">
<Global>^User.DHCUPPERSONI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UP_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UPPAPERNameIndex">
<Global>^User.DHCUPPERSONI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPPAName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UP_PAPERName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UPRegNoIndex">
<Global>^User.DHCUPPERSONI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPRegNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UP_RegistrationNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UPsPAPERNameIndex">
<Global>^User.DHCUPPERSONI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>UP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPsPAName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UPs_PAPERName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCUPPERSONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
