Class User.DHCStkSysDataModify Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DM_RowId, SqlTableName = DHC_StkSysDataModify, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkSysDataModifyDetail As User.DHCStkSysDataModifyDetail [ Cardinality = children, Inverse = DMDDMParRef ];

/// DM_DI_DR
Property DMDataItemDR As User.DHCStkSysDataItem [ SqlColumnNumber = 2, SqlFieldName = DM_DataItem_DR ];

/// DM_PersistentClass
Property DMPersistentClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DM_PersistentClass ];

/// DM_Date
Property DMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DM_Date ];

/// DM_Time
Property DMTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DM_Time ];

/// DM_SSUSR_DR
Property DMSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DM_SSUSR_DR ];

/// DM_Action
Property DMAction As %Library.String(DISPLAYLIST = ",Insert,Update,Delete", MAXLEN = 6, SELECTIVITY = "25.0000%", VALUELIST = ",I,U,D") [ SqlColumnNumber = 7, SqlFieldName = DM_Action ];

/// DM_Group_Dr
Property DMGroupDR As User.SSGroup [ SqlColumnNumber = 8, SqlFieldName = DM_Group_DR ];

/// DM_ClassID
Property DMClassId As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DM_ClassId ];

Trigger TAfterIns [ Event = INSERT, Time = AFTER ]
{
 d ##class(web.DHCST.StkSysDataModify).file()
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSSDM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DM_Action">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DM_ClassId">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DM_DataItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DM_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DM_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DM_PersistentClass">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DM_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DM_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCSSDM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCSSDM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DM_RowId</Field>
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
<Expression>{DM_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DM_DataItem_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysDataModifyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSDM)
	s oldI = +$g(^mdata("DHCSTKSYSDATAMODIFY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSDM = maxI
	s ^mdata("DHCSTKSYSDATAMODIFY") = maxI
}

}
