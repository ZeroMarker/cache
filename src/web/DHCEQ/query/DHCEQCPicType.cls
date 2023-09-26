Class web.DHCEQ.query.DHCEQCPicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
ClassMethod GetPicType(RowID As %String = "", Desc As %String = "", Start = 0, Limit = 40)
{
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s end = Start+Limit

	Set rowid=""
	//s PicSourceTypeDR=""
	i RowID'=""  d BuildDataByRowid
	e  For  Set rowid=$Order(^DHCEQCCode("DHCEQCPicType",rowid)) Quit:rowid=""  Do BuildDataGetPicType
	//e  For  Set PicSourceTypeDR=$Order(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) Quit:PicSourceTypeDR=""  Do BuildDataGetPicType
	
	s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
	Quit $$$OK
BuildDataByRowid
	Do ResetVariablesLookUpInfo
	Set TRowId = RowID
	Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",4)
	Quit:TInvalidFlag="Y"
	Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",1)
	Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",2)
	Do OutputRowLookUpInfo
	Quit	
BuildDataGetPicType
	Do ResetVariablesLookUpInfo
	//q:(SourceType'="")&&($P(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)'=SourceType)
	//Set TRowId = $P(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	Set TRowId =rowid
	Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",4)
	Quit:TInvalidFlag="Y"
	Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",1)
	Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowId)),"^",2)
	Quit:(Desc'="")&&(TDesc'[Desc)
	Do OutputRowLookUpInfo
	Quit
OutputRowLookUpInfo
	Set Data=TRowId_"^"_TDesc
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(Data)
	Quit
ResetVariablesLookUpInfo
	Set (TRowId,TDesc)=""
	Quit
}
*/
Storage Default
{
<Data name="DHCEQCPicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.query.DHCEQCPicTypeD</DataLocation>
<DefaultData>DHCEQCPicTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.query.DHCEQCPicTypeD</IdLocation>
<IndexLocation>^web.DHCEQ.query.DHCEQCPicTypeI</IndexLocation>
<StreamLocation>^web.DHCEQ.query.DHCEQCPicTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
