/// PHC Instruction         (PHCIN,130)
Class User.PHCInstruc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_Instruc, StorageStrategy = SQLStorage ]
{

/// Instruction Code
Property PHCINCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCIN_Code ];

/// Description(Local Language)
Property PHCINDesc1 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCIN_Desc1 ];

/// Description(Foreign Language)
Property PHCINDesc2 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCIN_Desc2 ];

/// chenying add@2017-06-12 是否激活 节点位置4  空时默认为激活
Property PHCINActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHCIN_ActiveFlag ];

/// chenying add@2017-06-12  就诊类型(门诊O,急诊E,住院I,体检H,新生儿N) 节点位置5
/// 控制哪些类型可开这个用法，PHCINClinicType为空时则都可以开
Property PHCINClinicType As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = PHCIN_ClinicType ];

Index PHCINCodeUnqIdx1 On PHCINCode [ Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCInstruc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCInstruc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCInstruc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCInstruc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCInstruc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCInstruc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCInstruc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCInstruc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCInstruc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCInstruc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="PHCINCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCINDesc1">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCINDesc2">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PHCIN(0))</SqlIdExpression>
<SQLMap name="DataMasterPHCIN">
<Data name="PHCIN_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCIN_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCIN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCIN_Desc1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCIN_Desc2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHCIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCIN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCINCode">
<Global>^PHCIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCIN_RowId</Field>
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
<Expression>$$ALPHAUP({PHCIN_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCINDesc1">
<Global>^PHCIN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCIN_Desc1})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCIN_RowId</SqlRowIdName>
<StreamLocation>^User.PHCInstrucS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
