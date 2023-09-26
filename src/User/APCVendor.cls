/// APC Vendor              (APCVM,243)
Class User.APCVendor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = APC_Vendor, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCO
Property APCVMCoCodeDR As CTCompany [ SqlColumnNumber = 2, SqlFieldName = APCVM_CoCode_DR ];

/// Vendor Code
Property APCVMCode As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APCVM_Code ];

/// Vendor Name
Property APCVMName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = APCVM_Name ];

/// Address
Property APCVMAddr As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = APCVM_Addr, SqlListType = SUBNODE ];

/// Des Ref to CTCIT
Property APCVMCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = APCVM_City_DR ];

/// Des Ref to CTSTT
Property APCVMStateDR As CTState [ SqlColumnNumber = 7, SqlFieldName = APCVM_State_DR ];

/// Des Ref to CTZIP
Property APCVMZipDR As CTZip [ SqlColumnNumber = 8, SqlFieldName = APCVM_Zip_DR ];

/// Telephone No
Property APCVMTel As %String(COLLATION = "AlphaUp", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = APCVM_Tel ];

/// Contact Person
Property APCVMContPerson As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = APCVM_ContPerson ];

/// Vendor Type
Property APCVMType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = APCVM_Type ];

/// Des Ref to APCCA(not in use)
Property APCVMCtrlAcctDR As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = APCVM_CtrlAcct_DR ];

/// Credit Limit
Property APCVMCrLimit As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 13, SqlFieldName = APCVM_CrLimit ];

/// Discount Rate
Property APCVMDiscRate As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 14, SqlFieldName = APCVM_DiscRate ];

/// Discount Days
Property APCVMDiscDays As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 15, SqlFieldName = APCVM_DiscDays ];

/// Credit Terms
Property APCVMCrTerm As %Float(MAXVAL = 9999, MINVAL = 1) [ SqlColumnNumber = 16, SqlFieldName = APCVM_CrTerm ];

/// Des Ref to APCVC
Property APCVMCategoryDR As APCVendCat [ SqlColumnNumber = 17, SqlFieldName = APCVM_Category_DR ];

/// Credit Available
Property APCVMCrAvail As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 18, SqlFieldName = APCVM_CrAvail ];

/// Previous Month Balance
Property APCVMPrevBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 19, SqlFieldName = APCVM_PrevBal ];

/// Current Month Balance
Property APCVMCurBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 20, SqlFieldName = APCVM_CurBal ];

/// Forward Month Balance
Property APCVMFwdBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 21, SqlFieldName = APCVM_FwdBal ];

/// Last Purchase Date
Property APCVMLstPoDate As %Date [ SqlColumnNumber = 22, SqlFieldName = APCVM_LstPoDate ];

/// Last Payment Date
Property APCVMLstPayDate As %Date [ SqlColumnNumber = 23, SqlFieldName = APCVM_LstPayDate ];

/// Last Invoice Date
Property APCVMLstInvDate As %Date [ SqlColumnNumber = 24, SqlFieldName = APCVM_LstInvDate ];

/// Des Ref to GLCCC
Property APCVMCostCentDR As GLCCC [ SqlColumnNumber = 25, SqlFieldName = APCVM_CostCent_DR ];

/// Des Ref to GLCAC
Property APCVMAcctCodeDR As GLCAcct [ SqlColumnNumber = 26, SqlFieldName = APCVM_AcctCode_DR ];

/// Archived Flag
Property APCVMRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 27, SqlFieldName = APCVM_RcFlag ];

/// Vendor Short Name
Property APCVMShName As %String(COLLATION = "AlphaUp", MAXLEN = 22, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlComputeCode = { s {APCVM_ShName}=$e({APCVM_Name},1,22)
}, SqlComputed, SqlFieldName = APCVM_ShName, Transient ];

/// Fax No
Property APCVMFax As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = APCVM_Fax ];

/// Grading
Property APCVMGrading As %String(DISPLAYLIST = ",Good,Bad,Average", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",G,B,A") [ SqlColumnNumber = 30, SqlFieldName = APCVM_Grading ];

/// President
Property APCVMPresident As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = APCVM_President ];

/// Registration No
Property APCVMRegistration As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = APCVM_Registration ];

/// Status
Property APCVMStatus As %String(DISPLAYLIST = ",Active,Suspended", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",A,S") [ SqlColumnNumber = 33, SqlFieldName = APCVM_Status ];

/// Des Ref CreditTerm
Property APCVMCreditTermDR As INCCreditTerms [ SqlColumnNumber = 34, SqlFieldName = APCVM_CreditTerm_DR ];

/// Last Business Date
Property APCVMLstBsDate As %Date [ SqlColumnNumber = 35, SqlFieldName = APCVM_LstBsDate ];

/// APCVM_AccountPeriod
Property APCVMAccountPeriod As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 36, SqlFieldName = APCVM_AccountPeriod ];

/// APCVM_PresidentIDDate 法人身份证的效期
Property APCVMPresidentIDDate As %Date [ SqlColumnNumber = 37, SqlFieldName = APCVM_PresidentIDDate ];

/// 云平台供应商ID
Property APCVMCloudID As %String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 38, SqlFieldName = APCVM_CloudID ];

/// APCVM_ProPurPCode
Property APCVMProPurPCode As %String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 39, SqlFieldName = APCVM_ProPurPCode ];

/// APCVM_CPoisonFlag 
Property APCVMCPoisonFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 40, SqlFieldName = APCVM_CPoisonFlag ];

/// APCVM_PPoisonFlag 
Property APCVMPPoisonFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 41, SqlFieldName = APCVM_PPoisonFlag ];

/// APCVM_SecondSpiritFlag
Property APCVMSecondSpiritFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 42, SqlFieldName = APCVM_SecondSpiritFlag ];

/// 账号名(对应原有账号和开户行)
Property APCVMAcctName As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = APCVM_AcctName ];

/// 新开户行
Property APCVMAcctBankRes As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = APCVM_AcctBank_Res ];

/// 新账号
Property APCVMAcctNoRes As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = APCVM_AcctNo_Res ];

/// 新账户
Property APCVMAcctNameRes As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = APCVM_AcctName_Res ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.APCVendor).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnAfterInsert")
 
 d POFILINS^at243
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.APCVendor).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnAfterUpdate")
 
 d POFILUPD^at243
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.APCVendor).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnBeforeDelete")
 
 d VALDEL^at243
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.APCVendor).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.APCVendor).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.APCVendor","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^APC("APCVM",0))</SqlIdExpression>
<SQLMap name="APCVMDataMasterMap">
<Data name="APCVM_AccountPeriod">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="APCVM_AcctBank_Res">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="APCVM_AcctCode_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="APCVM_AcctName">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="APCVM_AcctName_Res">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="APCVM_AcctNo_Res">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="APCVM_Addr">
<Node>"ADDR"</Node>
</Data>
<Data name="APCVM_CPoisonFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="APCVM_Category_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="APCVM_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APCVM_CloudID">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="APCVM_CoCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APCVM_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APCVM_ContPerson">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APCVM_CostCent_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="APCVM_CrAvail">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="APCVM_CrLimit">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APCVM_CrTerm">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APCVM_CreditTerm_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="APCVM_CtrlAcct_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APCVM_CurBal">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="APCVM_DiscDays">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="APCVM_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APCVM_Fax">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="APCVM_FwdBal">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="APCVM_Grading">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="APCVM_LstBsDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="APCVM_LstInvDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="APCVM_LstPayDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="APCVM_LstPoDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="APCVM_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APCVM_PPoisonFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="APCVM_President">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="APCVM_PresidentIDDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="APCVM_PrevBal">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="APCVM_ProPurPCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="APCVM_RcFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="APCVM_Registration">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="APCVM_SecondSpiritFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="APCVM_State_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APCVM_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="APCVM_Tel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APCVM_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APCVM_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^APC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>APCVM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{APCVM_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="APCVMIndexAPCVMCode">
<Data name="APCVM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^APC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APCVM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APCVM_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({APCVM_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{APCVM_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="APCVMIndexAPCVMName">
<Data name="APCVM_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^APC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APCVM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APCVM_Name"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({APCVM_Name})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{APCVM_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APCVM_RowId</SqlRowIdName>
<StreamLocation>^User.APCVendorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
