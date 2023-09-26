Class User.DHCDocOrderPreStopLogin Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_DocOrderPreStopLogin, StorageStrategy = NewStorage1 ]
{

/// 医嘱ID
Property DHCPreStopOrder As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DHCPreStop_Order ];

/// 预停日期
Property DHCPreStopDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCPreStop_Date ];

/// 预停时间
Property DHCPreStopTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCPreStop_Time ];

/// 操作时间
Property DHCPreStopUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCPreStop_UpdateDate ];

/// 预停时间
Property DHCPreStopUpdateTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCPreStop_UpdateTime ];

/// Usert
Property DHCPreStopUpdateUser As SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCPreStop_UpdateUser ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDocOrderPreStopLogin(0))</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="DHCPreStop_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPreStop_Order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPreStop_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPreStop_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPreStop_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPreStop_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocOrderPreStopLogin</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOEOrder">
<Global>^DHCDocOrderPreStopLogini</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OEOrder"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCPreStop_Order}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocOrderPreStopLoginS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
