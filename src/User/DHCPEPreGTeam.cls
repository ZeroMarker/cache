Class User.DHCPEPreGTeam Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGT_RowId, SqlTableName = DHC_PE_PreGTeam, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreGTeam";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PGTChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEPreGTOrdEnt As User.DHCPEPreGTOrdEnt [ Cardinality = children, Inverse = PGTOEParRef ];

Relationship ChildDHCPEPreGTOrdItem As User.DHCPEPreGTOrdItem [ Cardinality = children, Inverse = PGTOIParRef ];

/// PGT_AddOrdItem
Property PGTAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PGT_AddOrdItem ];

/// PGT_AddOrdItemAmount
Property PGTAddOrdItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 10, SqlFieldName = PGT_AddOrdItemAmount ];

/// PGT_AddOrdItemLimit
Property PGTAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PGT_AddOrdItemLimit ];

/// PGT_AddPhcItem
Property PGTAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PGT_AddPhcItem ];

/// PGT_AddPhcItemAmount
Property PGTAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 13, SqlFieldName = PGT_AddPhcItemAmount ];

/// PGT_AddPhcItemLimit
Property PGTAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PGT_AddPhcItemLimit ];

/// PGT_BookDateBegin
Property PGTBookDateBegin As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = PGT_BookDateBegin ];

/// PGT_BookDateEnd
Property PGTBookDateEnd As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = PGT_BookDateEnd ];

/// PGT_BookTime
Property PGTBookTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PGT_BookTime ];

/// PGT_ChildSub
Property PGTChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreGADM($p(%d(0),$c(1),1),"Team",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PGT_ChildSub ];

/// PGT_Desc
Property PGTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PGT_Desc ];

/// PGT_LowerLimit
Property PGTLowerLimit As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 16, SqlFieldName = PGT_LowerLimit ];

/// PGT_Married
Property PGTMarried As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PGT_Married ];

/// PGT_PEDeskClerk_DR
Property PGTPEDeskClerkDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PGT_PEDeskClerk_DR ];

/// DHC_PE_PreGADM Parent Reference
Relationship PGTParRef As User.DHCPEPreGADM [ Cardinality = parent, Inverse = ChildDHCPEPreGTeam, Required, SqlFieldName = PGT_ParRef ];

/// PGT_Sex
Property PGTSex As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PGT_Sex ];

/// PGT_UpdateDate
Property PGTUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 19, SqlFieldName = PGT_UpdateDate ];

/// PGT_UpdateTime
Property PGTUpdateTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = PGT_UpdateTime ];

/// PGT_UpdateUser_DR
Property PGTUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PGT_UpdateUser_DR ];

/// PGT_UpperLimit
Property PGTUpperLimit As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 15, SqlFieldName = PGT_UpperLimit ];

/// PGT_DisChargedMode
Property PGTDisChargedMode As %Library.String(DISPLAYLIST = ",GDischarged,IDischarged", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GD,ID") [ SqlColumnNumber = 21, SqlFieldName = PGT_DisChargedMode ];

/// PGT_PreRebate
Property PGTPreRebate As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 22, SqlFieldName = PGT_PreRebate ];

/// PGT_GAddRebate
Property PGTGAddRebate As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 23, SqlFieldName = PGT_GAddRebate ];

/// PGT_IAddRebate
Property PGTIAddRebate As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 24, SqlFieldName = PGT_IAddRebate ];

/// PGT_Parent_DR
Property PGTParentDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PGT_Parent_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreGADM">
<Data name="PGT_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGT_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PGT_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGT_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGT_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGT_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PGT_BookDateBegin">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGT_BookDateEnd">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGT_BookTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGT_DisChargedMode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PGT_GAddRebate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PGT_IAddRebate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PGT_LowerLimit">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGT_Married">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PGT_PEDeskClerk_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGT_Parent_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PGT_PreRebate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PGT_Sex">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PGT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PGT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PGT_UpperLimit">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCPEPreGADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreGADM.PGADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PGT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreGADM.PGADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Team"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGTeamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
