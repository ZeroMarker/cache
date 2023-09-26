Class User.DHCAppRepOthOpt Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepOthOpt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ARChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppReport Parent Reference AR_ParRef_Dr
Relationship ARParRefDr As User.DHCAppReport [ Cardinality = parent, Inverse = ChildDHCAPPREPOTHOPT, Required, SqlFieldName = AR_ParRef_Dr ];

/// AR_ChildSub
Property ARChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AR_ChildSub ];

/// 项目  AR_Opt_Dr 
Property AROptDr As User.DHCAppOtherOpt [ SqlColumnNumber = 3, SqlFieldName = AR_Opt_Dr ];

/// 项目值  AR_OptVal 
Property AROptVal As User.DHCAppOtherOptItm [ SqlColumnNumber = 4, SqlFieldName = AR_OptVal ];

/// 项目值  AR_OptVal 
Property AROrdItem As OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = AR_OrdItem ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AR_OptVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_Opt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_OrdItem">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepOthOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
