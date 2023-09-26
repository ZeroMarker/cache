Class User.DHCAdvCaseShare Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CASHARE_RowID, SqlTableName = DHC_AdvCaseShare, StorageStrategy = SQLStorage ]
{

/// CASHARE_RepDr	报告id
Property CASHARERepDr As User.DHCAdvMaster [ SqlColumnNumber = 2, SqlFieldName = CASHARE_RepDr ];

/// CASHARE_RepType	报告类型
Property CASHARERepType As %String [ SqlColumnNumber = 3, SqlFieldName = CASHARE_RepType ];

/// CASHARE_LocDr	共享科室指向
Property CASHARELocDr As %String [ SqlColumnNumber = 4, SqlFieldName = CASHARE_LocDr ];

/// CASHARE_IfShare	是否共享 共享 Y / 撤销共享 N
Property CASHAREIfShare As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CASHARE_IfShare ];

/// CASHARE_User	操作人
Property CASHAREUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = CASHARE_User ];

/// CASHARE_Date	共享日期
Property CASHAREDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CASHARE_Date ];

/// CASHARE_Time	共享时间
Property CASHARETime As %Time [ SqlColumnNumber = 8, SqlFieldName = CASHARE_Time ];

/// CASHARE_RevShareUser	撤销操作人
Property CASHARERevShareUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CASHARE_RevShareUser ];

/// CASHARE_RevDate	撤销日期
Property CASHARERevDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CASHARE_RevDate ];

/// CASHARE_RevTime	撤销时间
Property CASHARERevTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CASHARE_RevTime ];

/// CASHARE_UserDr	共享人员指向
Property CASHAREUserDr As %String [ SqlColumnNumber = 12, SqlFieldName = CASHARE_UserDr ];

/// CASHARE_Advice	共享意见或者目的
Property CASHAREAdvice As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CASHARE_Advice ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVCASHARE)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="CASHARE_Advice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CASHARE_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CASHARE_IfShare">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CASHARE_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CASHARE_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CASHARE_RepType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CASHARE_RevDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CASHARE_RevShareUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CASHARE_RevTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CASHARE_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CASHARE_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CASHARE_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCADVCASHARE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CASHARE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CASHARE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="RepDrTypeIndex">
<Global>^DHCADVCASHARE</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CASHARE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDrType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CASHARE_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CASHARE_RepType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CASHARE_LocDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CASHARE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvCaseShareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
