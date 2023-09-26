Class DOC.OPDoc.SuspendRecentLog Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = SuspendRecentLog, StorageStrategy = SuspendRecentLog ]
{

/// 科室
Property LocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LocDr ];

/// 医生
Property DocDr As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DocDr ];

/// 离开原因
Property SuspendReason As CF.DOC.OPDoc.SuspendReason [ SqlColumnNumber = 4, SqlFieldName = SuspendReason ];

/// 离开日期
Property SuspendDate As %Date [ SqlColumnNumber = 5, SqlFieldName = SuspendDate ];

/// 离开时间
Property SuspendTime As %Time [ SqlColumnNumber = 6, SqlFieldName = SuspendTime ];

/// 预计离开时间
Property SuspendRangTime As %String [ SqlColumnNumber = 7, SqlFieldName = SuspendRangTime ];

/// 预计归来日期
Property PreSuspendDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PreSuspendDate ];

/// 预计归来时间
Property PreSuspendTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PreSuspendTime ];

/// 实际归来日期
Property ActSuspendDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ActSuspendDate ];

/// 实际归来时间
Property ActSuspendTime As %Time [ SqlColumnNumber = 11, SqlFieldName = ActSuspendTime ];

/// 离开操作人
Property SuspendUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = SuspendUser ];

/// 离开操作日期
Property SuspendUserDate As %Date [ SqlColumnNumber = 13, SqlFieldName = SuspendUserDate ];

/// 离开操作时间
Property SuspendUserTime As %Time [ SqlColumnNumber = 14, SqlFieldName = SuspendUserTime ];

/// 归来操作人
Property BackSuspendUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = BackSuspendUser ];

/// 归来操作日期
Property BackSuspendUserDate As %Date [ SqlColumnNumber = 16, SqlFieldName = BackSuspendUserDate ];

/// 归来操作时间
Property BackSuspendUserTime As %Time [ SqlColumnNumber = 17, SqlFieldName = BackSuspendUserTime ];

Storage SuspendRecentLog
{
<SqlIdExpression>$i(^DOC.OPDoc.SuspendRecentLog(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ActSuspendDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ActSuspendTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BackSuspendUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BackSuspendUserDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BackSuspendUserTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DocDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LocDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PreSuspendDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PreSuspendTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SuspendDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SuspendRangTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SuspendReason">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SuspendTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SuspendUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SuspendUserDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SuspendUserTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DOC.OPDoc.SuspendRecentLog</Global>
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
<SQLMap name="IndexDate">
<Global>^DOC.OPDoc.SuspendRecentLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateLocDoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SuspendDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DocDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^DOC.OPDoc.SuspendRecentLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
