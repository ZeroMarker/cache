/// PAC Allergy(1159)
Class User.PACAllergy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Allergy, StorageStrategy = SQLStorage ]
{

/// Code
Property ALGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ALG_Code ];

/// Description
Property ALGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ALG_Desc ];

/// Des Ref to ALGType
Property ALGTypeDR As MRCAllType [ SqlColumnNumber = 4, SqlFieldName = ALG_Type_DR ];

/// Date From
Property ALGDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = ALG_DateFrom ];

/// Date To
Property ALGDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = ALG_DateTo ];

/// Allergy Category Des Ref
Property ALGAllergyCategoryDR As PACAllergyCategory [ SqlColumnNumber = 7, SqlFieldName = ALG_AllergyCategoryDR ];

/// 过敏源指向
Property ALGAllergyDR As PACAllergy [ SqlColumnNumber = 8, SqlFieldName = ALG_Allergy_DR ];

Index ALGCodeUnqIdx1 On ALGCode [ Unique ];

Parameter EXTENTSIZE = 8691;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAllergy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAllergy","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAllergy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAllergy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAllergy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAllergy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAllergy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAllergy","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAllergy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAllergy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>8691</ExtentSize>
<Property name="ALGAllergyCategoryDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGTypeDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ALG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALG_AllergyCategoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALG_Allergy_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALG_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ALG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ALG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALG_RowId</SqlRowIdName>
<StreamLocation>^User.PACAllergyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
