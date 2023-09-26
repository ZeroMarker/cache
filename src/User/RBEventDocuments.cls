/// Event Documents(2316)
Class User.RBEventDocuments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventDocuments, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SDChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SD",0))}, SqlColumnNumber = 2, SqlFieldName = SD_Childsub ];

/// Des Ref DocumentType
Property SDDocumentTypeDR As PACDocumentType [ SqlColumnNumber = 3, SqlFieldName = SD_DocumentType_DR ];

/// File
Property SDFile As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SD_File ];

/// RB_Event Parent Reference
Relationship SDParRef As RBEvent [ Cardinality = parent, Inverse = ChildRBEventDocuments, Required, SqlFieldName = SD_ParRef ];

Index RowIDBasedIDKeyIndex On SDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="SDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDDocumentTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDFile">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SD_DocumentType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SD_File">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SD_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventDocumentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
