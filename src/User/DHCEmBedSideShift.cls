Class User.DHCEmBedSideShift Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmBedSideShift, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEMBEDSIDESHIFTITEM As User.DHCEmBedSideShiftItem [ Cardinality = children, Inverse = EMParRefDr ];

/// 交班日期  EM_WrDate
Property EMWrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = EM_WrDate ];

/// 交班科室  EM_Ward_Dr
Property EMWardDr As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = EM_Ward_Dr ];

/// 班次  EM_Schedule
Property EMSchedule As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EM_Schedule ];

/// 交班类型  EM_Type
Property EMType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EM_Type ];

/// 交班人员  EM_User_Dr
Property EMUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = EM_User_Dr ];

/// 创建日期  EM_CrDate
Property EMCrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EM_CrDate ];

/// 创建时间  EM_CrTime
Property EMCrTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = EM_CrTime ];

/// 医疗组  EM_MedGrp_ID
Property EMMedGrpID As User.DHCCTLocMedUnit [ SqlColumnNumber = 9, SqlFieldName = EM_MedGrp_ID ];

/// 接班人员  EM_RecUser_Dr
Property EMRecUserDr As %Library.String [ SqlColumnNumber = 10, SqlFieldName = EM_RecUser_Dr ];

/// 完成标志  EM_CompFlag
Property EMCompFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = EM_CompFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMBSS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_CompFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EM_CrDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EM_CrTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EM_MedGrp_ID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EM_RecUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EM_Schedule">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_WrDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMBSS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateData">
<Global>^DHCEMBSS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_CrDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmBedSideShiftS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
