Class User.DHCOPGSPayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PM_RowID, SqlTableName = DHC_OPGSPayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PMSub [ IdKey, PrimaryKey, Unique ];

/// DHC_OPGroupSettings Parent Reference
Relationship GSPMParRef As User.DHCOPGroupSettings [ Cardinality = parent, Inverse = ChildDHCOPGSPayMode, Required, SqlFieldName = GS_PM_ParRef ];

/// PM_Sub
Property PMSub As %Library.Float [ InitialExpression = {$i(^DHCOPGS("GS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PM",0))}, SqlColumnNumber = 2, SqlFieldName = PM_Sub ];

/// PM_CTPM_DR
Property PMCTPMDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = PM_CTPM_DR ];

/// PM_DateFrom
Property PMDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PM_DateFrom ];

/// PM_DateTo
Property PMDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PM_DateTo ];

/// Default Pay Mode
Property PMDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PM_DefaultFlag ];

/// Define the Invoice be Printed??? 
Property PMINVPrtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PM_INVPrtFlag ];

/// Request write Print Flag
Property PMRPFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PM_RPFlag ];

/// PM_Note1--收预交金
Property PMNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PM_Note1 ];

/// PM_Note2--收费（门诊、住院）
Property PMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PM_Note2 ];

/// PM_Note3--挂号
Property PMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PM_Note3 ];

/// PM_Note4--退费
Property PMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PM_Note4 ];

/// 顺序号
Property PMSequence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PM_Sequence ];

/// 快捷键
Property PMHotKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PM_HotKey ];

/// 图标
Property PMIconCls As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PM_IconCls ];

/// PM_ObsChg --急诊留观收费
Property PMObsChg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PM_ObsChg ];

/// PM_DepRefund --退预交金
Property PMDepRefund As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PM_DepRefund ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMap">
<Data name="PM_CTPM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PM_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PM_DepRefund">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PM_HotKey">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PM_INVPrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PM_IconCls">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PM_Note1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PM_ObsChg">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PM_RPFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PM_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCOPGS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_OPGroupSettings.GS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_OPGroupSettings.GS_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PM"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTPMDR">
<Global>^DHCOPGSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_OPGroupSettings.GS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTPMDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PM_CTPM_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_OPGroupSettings.GS_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"PM"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPGSPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
