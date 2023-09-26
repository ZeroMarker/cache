Class User.DHCEQEquipService Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ES_RowID, SqlTableName = DHC_EQEquipService, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ES_SourceType
Property ESSourceType As %Library.String(DISPLAYLIST = ",设备,设备项,采购申请明细", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 2, SqlFieldName = ES_SourceType ];

/// ES_SourceID
Property ESSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ES_SourceID ];

/// ES_ModelDR
Property ESModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = ES_ModelDR ];

/// ES_ServiceDR
Property ESServiceDR As User.DHCEQCServiceItem [ SqlColumnNumber = 5, SqlFieldName = ES_ServiceDR ];

/// ES_MinMinutes
Property ESMinMinutes As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ES_MinMinutes ];

/// ES_MinutesPerTimes
Property ESMinutesPerTimes As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ES_MinutesPerTimes ];

/// ES_MaxMinutes
Property ESMaxMinutes As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ES_MaxMinutes ];

/// ES_Remark
Property ESRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ES_Remark ];

/// ES_InvalidFlag
Property ESInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ES_InvalidFlag ];

/// ES_BussType
Property ESBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ES_BussType ];

/// ES_ExType
Property ESExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ES_ExType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipService("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ES_BussType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ES_ExType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ES_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ES_MaxMinutes">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ES_MinMinutes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ES_MinutesPerTimes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ES_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ES_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ES_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ES_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ES_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQEquipService</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ES_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBussService">
<Global>^DHCEQEquipService</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BussService"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ES_BussType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ES_ServiceDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ES_SourceType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ES_SourceID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ES_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBussSource">
<Global>^DHCEQEquipService</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BussSource"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ES_BussType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ES_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ES_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ES_ServiceDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ES_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^DHCEQEquipService</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ServiceSource"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ES_ServiceDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ES_BussType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ES_SourceType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ES_SourceID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{ES_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQEquipService</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SourceService"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ES_BussType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ES_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ES_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{ES_ServiceDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{ES_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipServiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
