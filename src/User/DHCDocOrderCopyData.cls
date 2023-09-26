/// Creat:tanjishan 2020.03.16
/// 仅限于公司内部产品组使用，获取待审核列表并将该医嘱列表加载至医嘱录入界面
Class User.DHCDocOrderCopyData Extends %Persistent [ SqlRowIdName = OrdCD_RowID, SqlTableName = DHCDoc_OrderCopyData, StorageStrategy = SQLStorage ]
{

/// 使用用户
Property OrdCDUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = OrdCD_UserDr ];

/// 使用科室
Property OrdCDLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = OrdCD_LocDr ];

/// 使用患者
Property OrdCDAdmDr As User.PAAdm [ Required, SqlColumnNumber = 4, SqlFieldName = OrdCD_AdmDr ];

Property OrdCDOrdData As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OrdCD_OrdData, SqlListType = SUBNODE ];

Property OrdCDActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OrdCD_Active ];

Property OrdCDUpdateUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = OrdCD_UpdateUserDr ];

Property OrdCDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OrdCD_UpdateDate ];

Property OrdCDUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = OrdCD_UpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$I(^DHCDocOrderCopyData(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OrdCD_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OrdCD_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OrdCD_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OrdCD_OrdData">
<Node>"OrdData"</Node>
</Data>
<Data name="OrdCD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OrdCD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OrdCD_UpdateUserDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OrdCD_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocOrderCopyData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OrdCD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OrdCD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCDocOrderCopyData</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OrdCD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexAdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OrdCD_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OrdCD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderCopyDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// tanjishan 2020.03.16
/// 仅限公司内部产品组的使用，获取待审核列表并将该医嘱列表加载至医嘱录入界面
/// d ##Class(User.DHCDocOrderCopyData).GetCopyItem(62,95,10209,.arr)
/// 参考w ##Class(web.DHCDocMain).CreateCopyItem("103||1030","","10209")
ClassMethod GetCopyItem(EpisodeID As %String, LogonLocDr As %String, LogonUserDr As %String, ByRef CopyItemArr) As %String
{
	k CopyItemArr
	s Count=0
	s ID=0
	for {
		s ID=$O(^DHCDocOrderCopyData(0,"IndexAdmDr",EpisodeID,ID))
		q:(ID="")
		s Active=$P(^DHCDocOrderCopyData(ID),"^",4)
		continue:(Active'="Y")
		s OrdCDUserDr=$P(^DHCDocOrderCopyData(ID),"^",2)
		continue:(LogonLocDr'=OrdCDUserDr)&&(OrdCDUserDr'="")
		s OrdCDLocDr=$P(^DHCDocOrderCopyData(ID),"^",3)
		continue:(LogonUserDr'=OrdCDLocDr)&&(OrdCDLocDr'="")
		s SubID=0
		for {
			s SubID=$O(^DHCDocOrderCopyData(ID,"OrdData",SubID))
			q:(SubID="")
			s OrdData=$G(^DHCDocOrderCopyData(ID,"OrdData",SubID))
			continue:(OrdData="")
			s Count=Count+1
			s CopyItemArr(Count,"Data")=OrdData
		}
		s CurrDate=+$H,CurrTime=$P($H,",",2)
		&SQL(Update SQLUser.DHCDoc_OrderCopyData 
			Set OrdCD_Active='N',
			OrdCD_UpdateUserDr=:LogonUserDr,OrdCD_UpdateDate=:CurrDate,
			OrdCD_UpdateTime=:CurrTime
			where OrdCD_RowID=:ID)
	}
	q Count
}

/// 8.2及之前版本的库使用，前台直接获取对应json数据
/// d ##Class(User.DHCDocOrderCopyData).GetCopyItem(62,95,10209)
ClassMethod GetCopyItemJson(EpisodeID As %String, LogonLocDr As %String, LogonUserDr As %String)
{
	s CopyItemJson="[]"
 	d ##Class(User.DHCDocOrderCopyData).GetCopyItem(EpisodeID,LogonLocDr,LogonUserDr,.CopyItemArr)
 	if $D(CopyItemArr){
	 	s CopyItemJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.CopyItemArr)
	 	s CopyItemJson=$replace(CopyItemJson,"""","'")
	 	s CopyItemJson=$replace(CopyItemJson,"'","\'")
	}
	q CopyItemJson
}

}
