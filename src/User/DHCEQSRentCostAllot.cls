Class User.DHCEQSRentCostAllot Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RAL_RowID, SqlTableName = DHC_EQSRentCostAllot, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RAL_PutOnSetDR
Property RALPutOnSetDR As User.DHCEQSPutOnSet [ SqlColumnNumber = 2, SqlFieldName = RAL_PutOnSetDR ];

/// RAL_AllotType
Property RALAllotType As %Library.String(DISPLAYLIST = ",医院,共享平台中心,借出部门", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 3, SqlFieldName = RAL_AllotType ];

/// RAL_AllotSourceDR
Property RALAllotSourceDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RAL_AllotSourceDR ];

/// RAL_AllotPercentNum
Property RALAllotPercentNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RAL_AllotPercentNum ];

/// RAL_Remark
Property RALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RAL_Remark ];

/// RAL_AddUserDR
Property RALAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RAL_AddUserDR ];

/// RAL_AddDate
Property RALAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RAL_AddDate ];

/// RAL_AddTime
Property RALAddTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = RAL_AddTime ];

/// RAL_UpdateUserDR
Property RALUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RAL_UpdateUserDR ];

/// RAL_UpdateDate
Property RALUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = RAL_UpdateDate ];

/// RAL_UpdateTime
Property RALUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = RAL_UpdateTime ];

/// RAL_Hold1
Property RALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RAL_Hold1 ];

/// RAL_Hold2
Property RALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RAL_Hold2 ];

/// RAL_Hold3
Property RALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = RAL_Hold3 ];

/// RAL_InvalidFlag
Property RALInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = RAL_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSRentCostAllot("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RAL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RAL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RAL_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RAL_AllotPercentNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RAL_AllotSourceDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RAL_AllotType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RAL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RAL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RAL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RAL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RAL_PutOnSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RAL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RAL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RAL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RAL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQSRentCostAllot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RAL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPutOnSet">
<Global>^DHCEQSRentCostAllot</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PutOnSet"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RAL_PutOnSetDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSRentCostAllotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
