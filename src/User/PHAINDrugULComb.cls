Class User.PHAINDrugULComb Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = DULI_RowId, SqlTableName = PHAIN_DrugULComb, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DULICHILDSUB [ IdKey, PrimaryKey, Unique ];

Relationship DULIDULPARREF As User.PHAINDrugUseLimit [ Cardinality = parent, Inverse = ChildDHCDUL, Required, SqlFieldName = DULI_DULPARREF ];

Relationship ChildDULCI As User.PHAINDrugULCItm [ Cardinality = children, Inverse = DULIParRef ];

/// DULI_DUL_PARREF Parent Reference
/// DULI_CHILDSUB
Property DULICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DULI_CHILDSUB ];

/// DULI_CtrlLevel  管控等级
Property DULICtrlLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DULI_CtrlLevel ];

/// DULI_ActiveFlag  使用状态
Property DULIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DULI_ActiveFlag ];

/// DULI_LimitQty 限制数量
Property DULILimitQty As %Integer(MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = DULI_LimitQty ];

/// DULI_QtyStartDate  消耗数量起始日期
Property DULIQtyStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DULI_QtyStartDate ];

/// DULI_QtyEndDate 消耗数量起始日期
Property DULIQtyEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DULI_QtyEndDate ];

/// DULI_ActiveStartDate	限制起始日期
Property DULIActiveStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DULI_ActiveStartDate ];

/// DULI_ActiveEndDate	限制起始日期
Property DULIActiveEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DULI_ActiveEndDate ];

/// DULI_PromptRemarks  提示备注
Property DULIPromptRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DULI_PromptRemarks ];

/// DULI_Remarks  备注信息
Property DULIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DULI_Remarks ];

/// DULI_AddDate  添加日期
Property DULIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DULI_AddDate ];

/// DULI_UpdateDate 更新日期
Property DULIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DULI_UpdateDate ];

/// DULI_UpdateTime 更新时间
Property DULIUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DULI_UpdateTime ];

/// DULI_UpdateUser 更新人
Property DULIUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = DULI_UpdateUser ];

Storage SQLStorage
{
<SQLMap name="DULIMASTER">
<Data name="DULI_ActiveEndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DULI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DULI_ActiveStartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DULI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DULI_CtrlLevel">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DULI_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DULI_PromptRemarks">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DULI_QtyEndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DULI_QtyStartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DULI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DULI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DULI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DULI_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^CF.PHA.IN.DrugUseLimit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_DrugUseLimit.DUL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DULI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_DrugUseLimit.DUL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DULI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DULI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DULI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINDrugULComb</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
