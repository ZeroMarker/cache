/// GenericRtForms(2618)
Class User.PHCGenericRtForms Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericRtForms, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RTFChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPHCGenericRtFormsTherCat As PHCGenericRtFormsTherCat [ Cardinality = children, Inverse = THCParRef ];

Relationship ChildPHCGenericRtFormsDTherCl As PHCGenericRtFormsDTherCl [ Cardinality = children, Inverse = DTCParRef ];

Relationship ChildPHCGenericRtFormsInter As PHCGenericRtFormsInter [ Cardinality = children, Inverse = INTParRef ];

Relationship ChildPHCGenericRtFormsSubs As PHCGenericRtFormsSubs [ Cardinality = children, Inverse = SUBSParRef ];

/// PHC_Generic Parent Reference
Relationship RTFParRef As PHCGeneric [ Cardinality = parent, Inverse = ChildPHCGenericRtForms, Required, SqlFieldName = RTF_ParRef ];

/// Childsub
Property RTFChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RTF",0))}, SqlColumnNumber = 2, SqlFieldName = RTF_Childsub ];

/// Des Ref Form
Property RTFFormDR As PHCForm [ SqlColumnNumber = 3, SqlFieldName = RTF_Form_DR ];

/// Des Ref Route
Property RTFRouteDR As OECRoute [ SqlColumnNumber = 4, SqlFieldName = RTF_Route_DR ];

/// Des Ref Strength
Property RTFStrengthDR As PHCStrength [ SqlColumnNumber = 5, SqlFieldName = RTF_Strength_DR ];

/// Des Ref SubCat
Property RTFSubCatDR As PHCSubCat [ SqlColumnNumber = 6, SqlFieldName = RTF_SubCat_DR ];

/// Ident
Property RTFIdent As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RTF_Ident ];

/// Des Ref AdminRoute
Property RTFAdminRouteDR As PHCAdministrationRoute [ SqlColumnNumber = 8, SqlFieldName = RTF_AdminRoute_DR ];

/// DaysAfterMedsInterActive
Property RTFDaysAfterMedsInterActive As %Float [ SqlColumnNumber = 9, SqlFieldName = RTF_DaysAfterMedsInterActive ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PHCGenericRtForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PHCGenericRtForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PHCGenericRtForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PHCGenericRtForms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PHCGenericRtForms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtForms","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RTF_AdminRoute_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTF_DaysAfterMedsInterActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTF_Form_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTF_Ident">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTF_Route_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTF_Strength_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTF_SubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RTF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexForm">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>RTF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Form"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RTF_Form_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RTF_Route_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RTF_Strength_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RTF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTF_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericRtFormsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
