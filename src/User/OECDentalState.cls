/// Dental State(2580)
Class User.OECDentalState Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_DentalState, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 5;

/// Code
Property DENSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DENST_Code ];

/// Description
Property DENSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DENST_Desc ];

/// DateFrom
Property DENSTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = DENST_DateFrom ];

/// DateTo
Property DENSTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = DENST_DateTo ];

/// Color
Property DENSTColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DENST_Color ];

/// Des Ref ToothArea
Property DENSTToothAreaDR As OECToothArea [ SqlColumnNumber = 7, SqlFieldName = DENST_ToothArea_DR ];

/// Root
Property DENSTRoot As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DENST_Root ];

/// Crown
Property DENSTCrown As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DENST_Crown ];

/// WholeTooth
Property DENSTWholeTooth As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DENST_WholeTooth ];

/// Face1
Property DENSTFace1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DENST_Face1 ];

/// Face2
Property DENSTFace2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DENST_Face2 ];

/// Face3
Property DENSTFace3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DENST_Face3 ];

/// Face4
Property DENSTFace4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DENST_Face4 ];

/// Face5
Property DENSTFace5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DENST_Face5 ];

/// Image
Property DENSTImage As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DENST_Image ];

/// Root Image
Property DENSTRootImage As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DENST_RootImage ];

/// Colos
Property DENSTColos As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = DENST_Colos ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECDentalState).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECDentalState","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECDentalState).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECDentalState","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECDentalState).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECDentalState","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECDentalState).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECDentalState","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECDentalState).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECDentalState","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="DENSTCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DENSTColor">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DENSTColos">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTCrown">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DENSTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DENSTDesc">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DENSTFace1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTFace2">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTFace3">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTFace4">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTFace5">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTImage">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DENSTRoot">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DENSTRootImage">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DENSTToothAreaDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DENSTWholeTooth">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("DENST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="DENST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DENST_Color">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DENST_Colos">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DENST_Crown">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DENST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DENST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DENST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DENST_Face1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DENST_Face2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DENST_Face3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DENST_Face4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DENST_Face5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DENST_Image">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DENST_Root">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DENST_RootImage">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DENST_ToothArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DENST_WholeTooth">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DENST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DENST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DENST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DENST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DENST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DENST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DENST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DENST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DENST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DENST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DENST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DENST_RowId</SqlRowIdName>
<StreamLocation>^User.OECDentalStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
