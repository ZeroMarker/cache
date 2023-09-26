Class User.DHCWLAnOperation Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWL_AnOperation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On WLOPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCWL_Anaesthesia Parent Reference
Relationship WLOPParRef As DHCWLAnaesthesia [ Cardinality = parent, Inverse = ChildDHCWLAnOperation, Required, SqlFieldName = WLOP_ParRef ];

/// WLOP_ChildSub
Property WLOPChildSub As %Float [ InitialExpression = {$i(^DHCWLAnaesthesia($p(%d(0),$c(1),1),"OP",0))}, SqlColumnNumber = 2, SqlFieldName = WLOP_ChildSub ];

/// WLOP_OPER_DR
Property WLOPOPERDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = WLOP_OPER_DR ];

/// WLOP_ICD_DR
Property WLOPICDDR As MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = WLOP_ICD_DR ];

/// WLOP_UnitPrice
Property WLOPUnitPrice As %Float [ SqlColumnNumber = 5, SqlFieldName = WLOP_UnitPrice ];

/// WLOP_Units
Property WLOPUnits As %Float [ SqlColumnNumber = 6, SqlFieldName = WLOP_Units ];

/// WLOP_Price
Property WLOPPrice As %Float [ SqlColumnNumber = 7, SqlFieldName = WLOP_Price ];

/// WLOP_PreopDiag_DR
Property WLOPPreopDiagDR As MRCICDDx [ SqlColumnNumber = 8, SqlFieldName = WLOP_PreopDiag_DR ];

/// WLOP_PostDiag_DR
Property WLOPPostDiagDR As MRCICDDx [ SqlColumnNumber = 9, SqlFieldName = WLOP_PostDiag_DR ];

/// WLOP_DiagFlag
Property WLOPDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = WLOP_DiagFlag ];

/// WLOP_BodySite_DR
Property WLOPBodySiteDR As ORCOperPosition [ SqlColumnNumber = 11, SqlFieldName = WLOP_BodySite_DR ];

/// WLOP_Date
Property WLOPDate As %Date [ SqlColumnNumber = 12, SqlFieldName = WLOP_Date ];

/// WLOP_Time
Property WLOPTime As %Time [ SqlColumnNumber = 13, SqlFieldName = WLOP_Time ];

/// WLOP_OpDoc_DR
Property WLOPOpDocDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = WLOP_OpDoc_DR ];

/// WLOP_DocDep_DR
Property WLOPDocDepDR As CTLoc [ SqlColumnNumber = 15, SqlFieldName = WLOP_DocDep_DR ];

/// WLOP_AssistDoc1_DR
Property WLOPAssistDoc1DR As CTCareProv [ SqlColumnNumber = 16, SqlFieldName = WLOP_AssistDoc1_DR ];

/// WLOP_AssistDoc2_DR
Property WLOPAssistDoc2DR As CTCareProv [ SqlColumnNumber = 17, SqlFieldName = WLOP_AssistDoc2_DR ];

/// WLOP_AssistDoc3_DR
Property WLOPAssistDoc3DR As CTCareProv [ SqlColumnNumber = 18, SqlFieldName = WLOP_AssistDoc3_DR ];

/// WLOP_AnFADoc1_DR
Property WLOPAnFADoc1DR As CTCareProv [ SqlColumnNumber = 19, SqlFieldName = WLOP_AnFADoc1_DR ];

/// WLOP_AnFADoc2_DR
Property WLOPAnFADoc2DR As CTCareProv [ SqlColumnNumber = 20, SqlFieldName = WLOP_AnFADoc2_DR ];

/// WLOP_AnFADoc3_DR
Property WLOPAnFADoc3DR As CTCareProv [ SqlColumnNumber = 21, SqlFieldName = WLOP_AnFADoc3_DR ];

/// WLOP_CirNurse1_DR
Property WLOPCirNurse1DR As %String [ SqlColumnNumber = 22, SqlFieldName = WLOP_CirNurse1_DR ];

/// WLOP_CirNurse2_DR
Property WLOPCirNurse2DR As %String [ SqlColumnNumber = 23, SqlFieldName = WLOP_CirNurse2_DR ];

/// WLOP_ScrNurse1_DR
Property WLOPScrNurse1DR As %String [ SqlColumnNumber = 24, SqlFieldName = WLOP_ScrNurse1_DR ];

/// WLOP_ScrNurse2_DR
Property WLOPScrNurse2DR As %String [ SqlColumnNumber = 25, SqlFieldName = WLOP_ScrNurse2_DR ];

/// WLOP_OPER_Type
Property WLOPOPERType As %String(DISPLAYLIST = ",Main,Sub", MAXLEN = 4, VALUELIST = ",M,S") [ SqlColumnNumber = 26, SqlFieldName = WLOP_OPER_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="WLOP_AnFADoc1_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WLOP_AnFADoc2_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WLOP_AnFADoc3_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WLOP_AssistDoc1_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WLOP_AssistDoc2_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WLOP_AssistDoc3_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="WLOP_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLOP_CirNurse1_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WLOP_CirNurse2_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WLOP_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLOP_DiagFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLOP_DocDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WLOP_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLOP_OPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLOP_OPER_Type">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="WLOP_OpDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WLOP_PostDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLOP_PreopDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLOP_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLOP_ScrNurse1_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="WLOP_ScrNurse2_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="WLOP_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WLOP_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLOP_Units">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWLAnaesthesia</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDep">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DocDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_DocDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpDoc">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_OpDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpICD">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_ICD_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperName">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OperName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_OPER_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPostDiag">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PostDiag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_PostDiag_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPreopDiag">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCWL_Anaesthesia.WLAN_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WLOP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PreopDiag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWL_Anaesthesia.WLAN_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLOP_PreopDiag_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLOP_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCWLAnOperationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
