/// Clinic Group(2487)
Class User.RBCClinicGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ClinicGroup, StorageStrategy = SQLStorage ]
{

/// Code
Property CLGRPCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLGRP_Code ];

/// Description
Property CLGRPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLGRP_Desc ];

/// Date From
Property CLGRPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CLGRP_DateFrom ];

/// Date To
Property CLGRPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CLGRP_DateTo ];

/// Address,按亚专业维护位置,可用于按专业定义就诊位置,按此位置在挂号后提示
Property CLGRPAddress As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CLGRP_Address ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCClinicGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCClinicGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCClinicGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCClinicGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCClinicGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCClinicGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCClinicGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCClinicGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCClinicGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCClinicGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("CLGRP",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CLGRP_Address">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CLGRP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLGRP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLGRP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLGRP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CLGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CLGRP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CLGRP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CLGRP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CLGRP_RowId</SqlRowIdName>
<StreamLocation>^User.RBCClinicGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
