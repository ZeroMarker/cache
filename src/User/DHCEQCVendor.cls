Class User.DHCEQCVendor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = V_RowID, SqlTableName = DHC_EQCVendor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// V_Code
Property VCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = V_Code ];

/// V_Name
Property VName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = V_Name ];

/// V_Address
Property VAddress As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = V_Address ];

/// V_Province
Property VProvince As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = V_Province ];

/// V_City
Property VCity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = V_City ];

/// V_State
Property VState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = V_State ];

/// V_ZipCode
Property VZipCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = V_ZipCode ];

/// V_ContPerson
Property VContPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = V_ContPerson ];

/// V_Tel
Property VTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = V_Tel ];

/// V_Fax
Property VFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = V_Fax ];

/// V_ShName
Property VShName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = V_ShName ];

/// V_Grading
Property VGrading As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = V_Grading ];

/// V_Bank
Property VBank As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = V_Bank ];

/// V_BankNo
Property VBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = V_BankNo ];

/// V_RegistrationNo
Property VRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = V_RegistrationNo ];

/// V_Remark
Property VRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = V_Remark ];

/// V_ExID
Property VExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = V_ExID ];

/// V_ExDesc
Property VExDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = V_ExDesc ];

/// V_InvalidFlag
Property VInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = V_InvalidFlag ];

/// V_Hold1
Property VHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = V_Hold1 ];

/// V_Hold2
Property VHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = V_Hold2 ];

/// V_Hold3
Property VHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = V_Hold3 ];

/// V_Hold4
Property VHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = V_Hold4 ];

/// V_Hold5
Property VHold5 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = V_Hold5 ];

/// V_Hold6
Property VHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = V_Hold6 ];

/// V_Hold7
Property VHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = V_Hold7 ];

/// V_Hold8
Property VHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = V_Hold8 ];

/// V_Hold9
Property VHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = V_Hold9 ];

/// V_Hold10
Property VHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = V_Hold10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCVendor",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="V_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="V_Bank">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="V_BankNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="V_City">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="V_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="V_ContPerson">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="V_ExDesc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="V_ExID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="V_Fax">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="V_Grading">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="V_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="V_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="V_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="V_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="V_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="V_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="V_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="V_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="V_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="V_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="V_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="V_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="V_Province">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="V_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="V_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="V_ShName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="V_State">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="V_Tel">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="V_ZipCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>V_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCVendor"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{V_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCVendorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
