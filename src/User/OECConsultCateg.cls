/// OEC Consult Category(1603)
Class User.OECConsultCateg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCateg, StorageStrategy = SQLStorage ]
{

Relationship ChildOECConsultCategQuestion As OECConsultCategQuestion [ Cardinality = children, Inverse = QUESParRef ];

Relationship ChildOECConsultCategObserv As OECConsultCategObserv [ Cardinality = children, Inverse = OBSParRef ];

Relationship ChildOECConsultCategICDDxOrd As OECConsultCategICDDxOrd [ Cardinality = children, Inverse = ITMParRef ];

Relationship ChildOECConsultCategWLType As OECConsultCategWLType [ Cardinality = children, Inverse = WLTParRef ];

Relationship ChildOECConsultCategSubCat As OECConsultCategSubCat [ Cardinality = children, Inverse = SUBParRef ];

Relationship ChildOECConsultCategFollowOrd As OECConsultCategFollowOrd [ Cardinality = children, Inverse = FOLParRef ];

/// Code
Property CONSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CONS_Code ];

/// Description
Property CONSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CONS_Desc ];

/// DateFrom
Property CONSDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CONS_DateFrom ];

/// DateTo
Property CONSDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CONS_DateTo ];

/// HTML_File1
Property CONSHTMLFile1 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CONS_HTML_File1 ];

/// HTML_File2
Property CONSHTMLFile2 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CONS_HTML_File2 ];

/// HTML_File3
Property CONSHTMLFile3 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CONS_HTML_File3 ];

/// HTML_File_Desc1
Property CONSHTMLFileDesc1 As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CONS_HTML_File_Desc1 ];

/// HTML_File_Desc2
Property CONSHTMLFileDesc2 As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CONS_HTML_File_Desc2 ];

/// HTML_File_Desc3
Property CONSHTMLFileDesc3 As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CONS_HTML_File_Desc3 ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OECConsultCateg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OECConsultCateg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OECConsultCateg).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OECConsultCateg).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OECConsultCateg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCateg","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEC("CONS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CONS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONS_HTML_File1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONS_HTML_File2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONS_HTML_File3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONS_HTML_File_Desc1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONS_HTML_File_Desc2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONS_HTML_File_Desc3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CONS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CONS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONS_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
