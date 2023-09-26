/// OE Order                (OEORD,119)
Class User.OEOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_Order, StorageStrategy = SQLStorage ]
{

Relationship ChildOEOrdEnt As OEOrdEnt [ Cardinality = children, Inverse = OEORNOEORDParRef ];

Relationship ChildOEOrdItem As OEOrdItem [ Cardinality = children, Inverse = OEORIOEORDParRef ];

Relationship ChildOERecDept As OERecDept [ Cardinality = children, Inverse = OERECOEORDParRef ];

Relationship ChildOEOrdAccept As OEOrdAccept [ Cardinality = children, Inverse = ACCParRef ];

Relationship ChildOEOrdCateg As OEOrdCateg [ Cardinality = children, Inverse = CATParRef ];

/// OEORD Row ID
Property OEORDRowId As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD(0))}, Required, SqlFieldName = OEORD_RowId ];

/// Des Ref to PAADM
Property OEORDAdmDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = OEORD_Adm_DR ];

/// Order Date
Property OEORDDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = OEORD_Date ];

/// Order Time
Property OEORDTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = OEORD_Time ];

/// Des Ref to CTPCP
Property OEORDDoctorDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = OEORD_Doctor_DR ];

/// Des Ref to ARCOP(not in use)
Property OEORDARCOPDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OEORD_ARCOP_DR ];

/// Des Ref to OEORD (not in use)
Property OEORDOEOTCDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OEORD_OEOTC_DR ];

/// Des Ref SundryDebtor
Property OEORDSundryDebtorDR As ARCSundryDebtor [ SqlColumnNumber = 8, SqlFieldName = OEORD_SundryDebtor_DR ];

Index RowIDBasedIDKeyIndex On OEORDRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OEOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OEOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OEOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OEOrder).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OEOrder).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrder","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEORD(0))</SqlIdExpression>
<SQLMap name="DataMasterOEORD">
<Data name="OEORD_ARCOP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OEORD_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEORD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEORD_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEORD_OEOTC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OEORD_SundryDebtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OEORD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OEORD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORDAdmDR">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORD_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OEORD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORDDate">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OEORD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSundryDeb">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SunDeb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORD_SundryDebtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OEORD_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
