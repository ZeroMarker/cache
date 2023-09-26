/// PHC Drug Master          (PHCD,519)
Class User.PHCDrgMast Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrgMast, StorageStrategy = SQLStorage ]
{

Relationship ChildPHCDrgForm As PHCDrgForm [ Cardinality = children, Inverse = PHCDFPHCDParRef ];

Relationship ChildPHCDrgGeneric As PHCDrgGeneric [ Cardinality = children, Inverse = GENParRef ];

Relationship ChildPHCDrgInteraction As PHCDrgInteraction [ Cardinality = children, Inverse = INTParRef ];

Relationship ChildPHCDrgIngredient As User.PHCDrgIngredient [ Cardinality = children, Inverse = PHCDIPHCDParRef ];

/// Drug Name (field CN in MIMS)
Property PHCDName As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCD_Name ];

/// Product No (To uniquely identify MIMS record)
Property PHCDMIMSNo As %Float(MAXVAL = 999999, MINVAL = 1) [ SqlColumnNumber = 3, SqlFieldName = PHCD_MIMSNo ];

/// Des Ref to PHC_SubCat (Pham Index Sub Cat)
Property PHCDPHCSCDR As PHCSubCat [ SqlColumnNumber = 5, SqlFieldName = PHCD_PHCSC_DR ];

/// Logo - MIMS info
Property PHCDLogo As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHCD_Logo ];

/// Full name of the product
Property PHCDProductName As %String(COLLATION = "Exact", MAXLEN = 74, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PHCD_ProductName ];

/// Des Ref to PHCPO (Poison Code)
Property PHCDPHCPODR As PHCPoison [ SqlColumnNumber = 8, SqlFieldName = PHCD_PHCPO_DR ];

/// Stat - MIMS
Property PHCDStat As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PHCD_Stat ];

/// Not use Flag (also indicate if ready to use)
Property PHCDNotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = PHCD_NotUseFlag ];

/// Des Ref to PHMNF
Property PHCDPHMNFDR As PHManufacturer [ SqlColumnNumber = 13, SqlFieldName = PHCD_PHMNF_DR ];

/// Des Ref to PHDIS (Distributor)
Property PHCDPHDISDR As PHDistributor [ SqlColumnNumber = 14, SqlFieldName = PHCD_PHDIS_DR ];

/// Drug Code
Property PHCDCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 15, SqlFieldName = PHCD_Code ];

/// Drug Label Name (Local)
Property PHCDLabelName1 As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PHCD_LabelName1 ];

/// Drug Label Name (Foreign)
Property PHCDLabelName2 As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlComputeCode = { s {PHCD_LabelName2}=$$CO17^at519({PHCD_LabelName2},{PHCD_Name})
}, SqlComputed, SqlComputeOnChange = PHCDName, SqlFieldName = PHCD_LabelName2 ];

/// Des Ref to MinSubCat
Property PHCDMinSubCatDR As PHCMinorSubCat [ SqlColumnNumber = 18, SqlFieldName = PHCD_MinSubCat_DR ];

/// Update Date
Property PHCDUpdateDate As %Date [ SqlColumnNumber = 19, SqlFieldName = PHCD_UpdateDate ];

/// Update Time
Property PHCDUpdateTime As %Time [ SqlColumnNumber = 20, SqlFieldName = PHCD_UpdateTime ];

/// Update User
Property PHCDUpdateUser As SSUser [ SqlColumnNumber = 21, SqlFieldName = PHCD_UpdateUser ];

/// Des Ref Generic
Property PHCDGenericDR As PHCGeneric [ SqlColumnNumber = 22, SqlFieldName = PHCD_Generic_DR ];

/// Official Code
Property PHCDOfficialCode As %String(COLLATION = "AlphaUp", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PHCD_OfficialCode ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrgMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrgMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnAfterUpdate")
 d POFILUPD^at519
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrgMast).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnBeforeDelete")
 d VALDEL^at519({PHCD_RowId})
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrgMast).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnBeforeUpdate")
 d VALUPD^at519
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnBeforeInsert")
 d VALINS^at519
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrgMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgMast","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^PHCD(0))</SqlIdExpression>
<SQLMap name="DataMasterMapPHCD">
<Data name="PHCD_Code">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCD_Generic_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCD_LabelName1">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="PHCD_LabelName2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="PHCD_Logo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCD_MIMSNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCD_MinSubCat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCD_Name">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCD_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCD_OfficialCode">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCD_PHCPO_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCD_PHCSC_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCD_PHDIS_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCD_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCD_ProductName">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCD_Stat">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCD_UpdateUser">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDistributor">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Distrib"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCD_PHDIS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGeneric">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCD_Generic_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManuf">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Manuf"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCD_PHMNF_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOffCode">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OfficialCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHCD_OfficialCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDCode">
<Condition>{PHCD_Code}'=""</Condition>
<ConditionFields>PHCD_Code</ConditionFields>
<Global>^PHCD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCD_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDMIMSno">
<Condition>{PHCD_MIMSNo}'=""</Condition>
<Global>^PHCD</Global>
<PopulationPct>1</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MIMSno"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCD_MIMSNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDName">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCD_Name})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoison">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Poison"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCD_PHCPO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCD_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgMastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
