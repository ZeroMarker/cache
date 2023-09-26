/// PAC Referral Doctor Clinic(1594)
Class User.PACRefDoctorClinic Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorClinic, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CLNChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPACRefDoctorClinicSession As PACRefDoctorClinicSession [ Cardinality = children, Inverse = SESSParRef ];

Relationship ChildPACRefDoctorClinicAlias As PACRefDoctorClinicAlias [ Cardinality = children, Inverse = ALIASParRef ];

/// PAC_RefDoctor Parent Reference
Relationship CLNParRef As PACRefDoctor [ Cardinality = parent, Inverse = ChildPACRefDoctorClinic, Required, SqlFieldName = CLN_ParRef ];

/// Childsub
Property CLNChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CLN",0))}, SqlColumnNumber = 2, SqlFieldName = CLN_Childsub ];

/// Code
Property CLNCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLN_Code ];

/// Address 1
Property CLNAddress1 As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CLN_Address1 ];

/// Address2
Property CLNAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CLN_Address2 ];

/// Des Ref City
Property CLNCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = CLN_City_DR ];

/// Des Ref Zip
Property CLNZipDR As CTZip [ SqlColumnNumber = 7, SqlFieldName = CLN_Zip_DR ];

/// Phone
Property CLNPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CLN_Phone ];

/// ProviderNo
Property CLNProviderNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CLN_ProviderNo ];

/// Business Phone
Property CLNBusPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CLN_BusPhone ];

/// Mob Phone
Property CLNMobPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CLN_MobPhone ];

/// Fax
Property CLNFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CLN_Fax ];

/// Email
Property CLNEmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CLN_Email ];

/// Preferred Contact
Property CLNPreferredContact As %String(DISPLAYLIST = ",Post,Email,Fax", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",P,E,F") [ SqlColumnNumber = 14, SqlFieldName = CLN_PreferredContact ];

/// VEMD
Property CLNVEMD As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CLN_VEMD ];

/// Date From
Property CLNDateFrom As %Date [ SqlColumnNumber = 16, SqlFieldName = CLN_DateFrom ];

/// Date To
Property CLNDateTo As %Date [ SqlColumnNumber = 17, SqlFieldName = CLN_DateTo ];

/// Des Ref Clinic
Property CLNClinicDR As PACClinic [ SqlColumnNumber = 18, SqlFieldName = CLN_Clinic_DR ];

/// Alias
Property CLNAlias As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CLN_Alias ];

/// Location text
Property CLNLocation As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CLN_Location ];

/// System
Property CLNSystem As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CLN_System ];

/// Default Send
Property CLNDefaultSend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = CLN_DefaultSend ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d keyw^at1423($g(%d(1)))

 d ##Class(User.PACRefDoctorClinic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinic","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d keyw^at1423($g(%d(1)))

 d ##Class(User.PACRefDoctorClinic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinic","OnAfterUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CLN_Address1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CLN_Address2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLN_Alias">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CLN_BusPhone">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CLN_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLN_Clinic_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CLN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLN_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CLN_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CLN_DefaultSend">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CLN_Email">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CLN_Fax">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CLN_Location">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CLN_MobPhone">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLN_Phone">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CLN_PreferredContact">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CLN_ProviderNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CLN_System">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CLN_VEMD">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CLN_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CLN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClinic">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CLN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Clinic"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLN_Clinic_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CLN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClnProvNo">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CLN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLN_ProviderNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CLN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CLN_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorClinicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
