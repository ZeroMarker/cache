/// OEC Text Result Section(1392)
Class User.OECTextResultSection Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_TextResultSection, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SECChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_TextResultType Parent Reference
Relationship SECParRef As OECTextResultType [ Cardinality = parent, Inverse = ChildOECTextResultSection, Required, SqlFieldName = SEC_ParRef ];

/// Childsub
Property SECChildsub As %Float [ InitialExpression = {$i(^OEC("TRT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SEC",0))}, SqlColumnNumber = 2, SqlFieldName = SEC_Childsub ];

/// Section Name
Property SECDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SEC_Desc ];

/// Order in Printing
Property SECOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = SEC_Order ];

/// Font Name
Property SECFontName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SEC_FontName ];

/// Font Size
Property SECFontSize As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SEC_FontSize ];

/// Font Style
Property SECFontStyle As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SEC_FontStyle ];

/// ControlType
Property SECControlType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SEC_ControlType ];

/// Values
Property SECValues As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SEC_Values ];

/// RTF
Property SECRTF As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SEC_RTF ];

/// RTFTemplateWEB
Property SECRTFTemplateWEB As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SEC_RTFTemplateWEB ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OECTextResultSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OECTextResultSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OECTextResultSection).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OECTextResultSection).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OECTextResultSection).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultSection","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="SECChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SECControlType">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SECDesc">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="SECFontName">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SECFontSize">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="SECFontStyle">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SECOrder">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SECParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SECRTF">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SECRTFTemplateWEB">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SECValues">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SEC_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SEC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SEC_FontName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SEC_FontSize">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SEC_FontStyle">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SEC_Order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SEC_RTF">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SEC_RTFTemplateWEB">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SEC_Values">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_TextResultType.TRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_TextResultType.TRT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SEC_RowId</SqlRowIdName>
<StreamLocation>^User.OECTextResultSectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
