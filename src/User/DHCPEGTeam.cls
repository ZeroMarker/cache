Class User.DHCPEGTeam Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GT_RowId, SqlTableName = DHC_PE_GTeam, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGTeam";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GTChildSub [ IdKey, PrimaryKey, Unique ];

/// GT_AddOrdItem
Property GTAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = GT_AddOrdItem ];

/// GT_AddOrdItemAmount
Property GTAddOrdItemAmount As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 7, SqlFieldName = GT_AddOrdItemAmount ];

/// GT_AddOrdItemLimit
Property GTAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = GT_AddOrdItemLimit ];

/// GT_AddPhcItem
Property GTAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GT_AddPhcItem ];

/// GT_AddPhcItemAmount
Property GTAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 10, SqlFieldName = GT_AddPhcItemAmount ];

/// GT_AddPhcItemLimit
Property GTAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = GT_AddPhcItemLimit ];

/// GT_CRMTeam
Property GTCRMTeam As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GT_CRMTeam ];

/// GT_ChildSub
Property GTChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEGADM($p(%d(0),$c(1),1),"Team",0))}, Required, SqlColumnNumber = 2, SqlFieldName = GT_ChildSub ];

/// GT_Desc
Property GTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GT_Desc ];

/// GT_LowerLimit
Property GTLowerLimit As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 13, SqlFieldName = GT_LowerLimit ];

/// GT_Married
Property GTMarried As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GT_Married ];

/// DHC_PE_GADM Parent Reference
Relationship GTParRef As User.DHCPEGADM [ Cardinality = parent, Inverse = ChildDHCPEGTeam, Required, SqlFieldName = GT_ParRef ];

/// GT_Sex
Property GTSex As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GT_Sex ];

/// GT_UpdateDate
Property GTUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 16, SqlFieldName = GT_UpdateDate ];

/// GT_UpdateTime
Property GTUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = GT_UpdateTime ];

/// GT_UpdateUser_DR
Property GTUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = GT_UpdateUser_DR ];

/// GT_UpperLimit
Property GTUpperLimit As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 12, SqlFieldName = GT_UpperLimit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEGADM">
<Data name="GT_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GT_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GT_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GT_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GT_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GT_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GT_CRMTeam">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GT_LowerLimit">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GT_Married">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GT_Sex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GT_UpperLimit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPEGADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_GADM.GADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GADM.GADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Team"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGTeamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
