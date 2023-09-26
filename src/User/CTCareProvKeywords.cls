/// CT Care Prov Keywords(1617)
Class User.CTCareProvKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvKeywords, StorageStrategy = SQLStorage ]
{

/// Anaestetist
Property KEYWAnaestetist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = KEYW_Anaestetist ];

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^CTPCP($p(%d(0),$c(1)),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Name
Property KEYWName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = KEYW_Name ];

/// CT_CareProv Parent Reference
Relationship KEYWParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvKeywords, Required, SqlFieldName = KEYW_ParRef ];

/// Specialist
Property KEYWSpecialist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = KEYW_Specialist ];

/// Surgeon
Property KEYWSurgeon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = KEYW_Surgeon ];

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5807;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvKeywords","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvKeywords).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvKeywords","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvKeywords).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvKeywords","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5807</ExtentSize>
<Property name="KEYWAnaestetist">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="KEYWChildsub">
<Selectivity>3.8456%</Selectivity>
</Property>
<Property name="KEYWName">
<Selectivity>0.7110%</Selectivity>
</Property>
<Property name="KEYWParRef">
<Selectivity>0.0442%</Selectivity>
</Property>
<Property name="KEYWSpecialist">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="KEYWSurgeon">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="KEYW_Anaestetist">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KEYW_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KEYW_Specialist">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KEYW_Surgeon">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnaest">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AnaestKeyw"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Anaestetist}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyword">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Keyw"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecialist">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SpecKeyw"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Specialist}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurgeon">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SurgKeyw"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Surgeon}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
