/// PAC Document Type(1739)
Class User.PACDocumentType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DocumentType, StorageStrategy = SQLStorage ]
{

Relationship ChildPACSADSubType As PACSADSubType [ Cardinality = children, Inverse = SADSTParRef ];

/// Description
Property DOCTYPEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DOCTYPE_Desc ];

/// Default
Property DOCTYPEDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DOCTYPE_Default ];

/// DateFrom
Property DOCTYPEDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = DOCTYPE_DateFrom ];

/// DateTo
Property DOCTYPEDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = DOCTYPE_DateTo ];

/// Des Ref ScanAdmDocSubType
Property DOCTYPEScanAdmDocSubTypeDR As PACScanAdminDocSubType [ SqlColumnNumber = 6, SqlFieldName = DOCTYPE_ScanAdmDocSubType_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACDocumentType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACDocumentType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACDocumentType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACDocumentType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACDocumentType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDocumentType","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("DOCTYPE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DOCTYPE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOCTYPE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOCTYPE_Default">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOCTYPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOCTYPE_ScanAdmDocSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOCTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOCTYPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOCTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DOCTYPE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOCTYPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DOCTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.PACDocumentTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
