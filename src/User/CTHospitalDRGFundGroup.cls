/// Hospital DRG Fund Group(2479)
Class User.CTHospitalDRGFundGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HospitalDRGFundGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DFGChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Hospital Parent Reference
Relationship DFGParRef As CTHospital [ Cardinality = parent, Inverse = ChildCTHospitalDRGFundGroup, Required, SqlFieldName = DFG_ParRef ];

/// Childsub
Property DFGChildsub As %Float [ InitialExpression = {$i(^CT("HOSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DFG",0))}, SqlColumnNumber = 2, SqlFieldName = DFG_Childsub ];

/// Des Ref HospDRGCateg
Property DFGHospDRGCategDR As CTHospitalDRGCategory [ SqlColumnNumber = 3, SqlFieldName = DFG_HospDRGCateg_DR ];

/// Date From
Property DFGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = DFG_DateFrom ];

/// Date To
Property DFGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = DFG_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHospitalDRGFundGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalDRGFundGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHospitalDRGFundGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalDRGFundGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHospitalDRGFundGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalDRGFundGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHospitalDRGFundGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalDRGFundGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHospitalDRGFundGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalDRGFundGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DFG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DFG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DFG_HospDRGCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DFG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DFG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DFG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCateg">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DFG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DFG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Categ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DFG_HospDRGCateg_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DFG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DFG_RowId</SqlRowIdName>
<StreamLocation>^User.CTHospitalDRGFundGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
