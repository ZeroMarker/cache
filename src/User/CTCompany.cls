/// CT Company               (CTCO,536)
Class User.CTCompany Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Company, StorageStrategy = SQLStorage ]
{

/// Address
Property CTCOAddr As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CTCO_Addr ];

/// Not Used Financial Period - des ref to CTFPR
Property CTCOApPerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTCO_ApPer_DR ];

/// AP Financial Year
Property CTCOApYr As %Float [ SqlColumnNumber = 4, SqlFieldName = CTCO_ApYr ];

/// Not Used AR Financial Year - des ref to CTFP
Property CTCOArPerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTCO_ArPer_DR ];

/// AR Financial Year
Property CTCOArYr As %Float [ SqlColumnNumber = 6, SqlFieldName = CTCO_ArYr ];

/// Des Ref to CTCIT
Property CTCOCityDR As CTCity [ SqlColumnNumber = 7, SqlFieldName = CTCO_City_DR ];

/// Company Code
Property CTCOCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 8, SqlFieldName = CTCO_Code ];

/// Contact Person
Property CTCOContractPerson As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTCO_ContractPerson ];

/// Description
Property CTCODesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 11, SqlFieldName = CTCO_Desc ];

/// Not Used Financial Period - des ref to CTFPR
Property CTCOGLPerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTCO_GLPer_DR ];

/// GL Financial Year
Property CTCOGLYr As %Float [ SqlColumnNumber = 13, SqlFieldName = CTCO_GLYr ];

/// Child Company of Hanjin
Property CTCOHanjinChild As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = CTCO_HanjinChild ];

/// Not Use Flag
Property CTCONotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 14, SqlFieldName = CTCO_NotUseFlag ];

/// Company Password
Property CTCOPassword As %String(COLLATION = "AlphaUp", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CTCO_Password ];

/// Primary Billing Code
Property CTCOPrimBillingCode As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CTCO_PrimBillingCode ];

/// Remarks
Property CTCORemarks As list Of %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CTCO_Remarks, SqlListType = SUBNODE ];

/// Secondary Billing Code
Property CTCOSecondBillCode As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = CTCO_SecondBillCode ];

/// Short Company Desc
Property CTCOShDesc As %String(COLLATION = "AlphaUp", MAXLEN = 22, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CTCO_ShDesc ];

/// Des Ref to CTSTT
Property CTCOStateDR As CTState [ SqlColumnNumber = 17, SqlFieldName = CTCO_State_DR ];

/// Company Telephone
Property CTCOTel As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTCO_Tel ];

/// Des Ref to CTZIP
Property CTCOZipDR As CTZip [ SqlColumnNumber = 19, SqlFieldName = CTCO_Zip_DR ];

/// Des Ref to CTCUR
Property CTCPCurrCodeDR As CTCurrency [ SqlColumnNumber = 10, SqlFieldName = CTCP_CurrCode_DR ];

Relationship ChildCTCompanyContract As CTCompanyContract [ Cardinality = children, Inverse = CONTParRef ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCompany).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCompany","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCompany).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCompany","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCompany).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCompany","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCompany).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCompany","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCompany).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCompany","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("CTCO",0))</SqlIdExpression>
<SQLMap name="CTCOIndexCTCOCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTCO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTCO_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCO_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCO_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CTCOIndexCTCODesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTCO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTCO_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTCO_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCO_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CTCOMasterMap">
<Data name="CTCO_Addr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCO_ApPer_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCO_ApYr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTCO_ArPer_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTCO_ArYr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTCO_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTCO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCO_ContractPerson">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTCO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCO_GLPer_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTCO_GLYr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTCO_HanjinChild">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTCO_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTCO_Password">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTCO_PrimBillingCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CTCO_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="CTCO_SecondBillCode">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTCO_ShDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTCO_State_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTCO_Tel">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTCO_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTCP_CurrCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTCO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCO_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CTCO_RowId</SqlRowIdName>
<StreamLocation>^User.CTCompanyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
