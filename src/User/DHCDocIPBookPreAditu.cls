Class User.DHCDocIPBookPreAditu Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHCDocIPBookPreAditu, StorageStrategy = DHCDocIPBookPreAditu ]
{

/// 住院就诊
Property IPBookPreAdituINAdm As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = IPBookPreAdituINAdm ];

/// 门诊就诊
Property IPBookPreAdituOPAdm As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = IPBookPreAdituOPAdm ];

/// 审核医生
Property IPBookPreAdituDoc As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = IPBookPreAdituDoc ];

/// 审核医生情况，是否通过
Property IPBookPreAdituDocActive As %Library.String [ SqlColumnNumber = 5, SqlFieldName = IPBookPreAdituDocActive ];

/// 审核医生日期
Property IPBookPreAdituDocDate As %Date [ SqlColumnNumber = 6, SqlFieldName = IPBookPreAdituDocDate ];

/// 审核医生日期
Property IPBookPreAdituDocTime As %Time [ SqlColumnNumber = 7, SqlFieldName = IPBookPreAdituDocTime ];

/// 审核医生备注
Property IPBookPreAdituDocRemark As %Library.String [ SqlColumnNumber = 8, SqlFieldName = IPBookPreAdituDocRemark ];

/// 审核医生不通过原因
Property IPBookPreAdituDocReason As %Library.String [ SqlColumnNumber = 9, SqlFieldName = IPBookPreAdituDocReason ];

/// 审核护士
Property IPBookPreAdituNurse As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = IPBookPreAdituNurse ];

/// 审核护士情况，是否通过
Property IPBookPreAdituNurseActive As %Library.String [ SqlColumnNumber = 11, SqlFieldName = IPBookPreAdituNurseActive ];

/// 审核护士日期
Property IPBookPreAdituNurseDate As %Date [ SqlColumnNumber = 12, SqlFieldName = IPBookPreAdituNurseDate ];

/// 审核护士日期
Property IPBookPreAdituNurseTime As %Time [ SqlColumnNumber = 13, SqlFieldName = IPBookPreAdituNurseTime ];

/// 审核护士备注
Property IPBookPreAdituNurseRemark As %Library.String [ SqlColumnNumber = 14, SqlFieldName = IPBookPreAdituNurseRemark ];

/// 审核护士不通过原因
Property IPBookPreAdituNurseReason As %Library.String [ SqlColumnNumber = 15, SqlFieldName = IPBookPreAdituNurseReason ];

/// 期望入院日期
Property IPBookPreAdituInDate As %Date [ SqlColumnNumber = 16, SqlFieldName = IPBookPreAdituInDate ];

/// 期望入院床位
Property IPBookPreAdituInBed As %Library.String [ SqlColumnNumber = 17, SqlFieldName = IPBookPreAdituInBed ];

Storage DHCDocIPBookPreAditu
{
<SqlIdExpression>$i(^DHCDocIPBookPreAditu(0))</SqlIdExpression>
<SQLMap name="IndexPreAdm">
<Global>^DHCDocIPBookPreAditui</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"INAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPBookPreAdituINAdm}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="IPBookPreAdituDoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPBookPreAdituDocActive">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPBookPreAdituDocDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPBookPreAdituDocReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPBookPreAdituDocRemark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPBookPreAdituDocTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPBookPreAdituINAdm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPBookPreAdituInBed">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPBookPreAdituInDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPBookPreAdituNurse">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPBookPreAdituNurseActive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPBookPreAdituNurseDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPBookPreAdituNurseReason">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPBookPreAdituNurseRemark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPBookPreAdituNurseTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPBookPreAdituOPAdm">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocIPBookPreAditu</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBookPreAdituS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
