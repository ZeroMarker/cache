Class User.DHCOPBillHDDCSub Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = HDDCS_Rowid, SqlTableName = DHC_OPBillHDDCSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HDDCSSub [ IdKey, PrimaryKey, Unique ];

/// HDDCS_Sub 
Property HDDCSSub As %Library.Float [ InitialExpression = {$i(^DHCOPBillHDDC($p(%d(0),$c(1)),"Sub",0))}, SqlColumnNumber = 2, SqlFieldName = HDDCS_Sub ];

/// HDDCS_Arcim_DR
Property HDDCSArcimDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HDDCS_Arcim_DR ];

/// HDDCS_Place
Property HDDCSPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HDDCS_Place ];

/// HDDCS_AddUser_DR
Property HDDCSAddUserDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = HDDCS_AddUser_DR ];

/// HDDCS_AddDate
Property HDDCSAddDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = HDDCS_AddDate ];

/// HDDCS_AddTime
Property HDDCSAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = HDDCS_AddTime ];

/// HDDCS_UpdateUser_DR
Property HDDCSUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = HDDCS_UpdateUserDR ];

/// HDDCS_UpdateDate
Property HDDCSUpdateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = HDDCS_UpdateDate ];

/// HDDCS_UpdateTime
Property HDDCSUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = HDDCS_UpdateTime ];

Relationship HDDCParref As User.DHCOPBillHDDC [ Cardinality = parent, Inverse = HDDCChildSub, Required, SqlFieldName = HDDC_Parref ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexMaster">
<Data name="HDDCS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HDDCS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HDDCS_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HDDCS_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HDDCS_Place">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HDDCS_Sub">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HDDCS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HDDCS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HDDCS_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HDDC_Parref">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCOPBillHDDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_OPBillHDDC.HDDC_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HDDCS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_OPBillHDDC.HDDC_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Sub"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{HDDCS_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCOPBillHDDCSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
