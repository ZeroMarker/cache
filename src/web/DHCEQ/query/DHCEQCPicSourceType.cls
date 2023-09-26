Class web.DHCEQ.query.DHCEQCPicSourceType Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/*
ClassMethod GetPicSourceType(RowID As %String = "", Desc As %String = "", Start As %Integer, Limit As %Integer, CurrentSourceType = "", PicTypeDR = "")
{
	s:Start="" Start=0
	s:Limit="" Limit=20
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s end = Start+Limit
	k DHCEQTemp
	
	Set rowid=0
	s PicSourceTypeDR=""
	i RowID'=""  d BuildDataByRowid
	e  For  Set PicSourceTypeDR=$Order(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) Quit:PicSourceTypeDR=""  Do BuildDataGetPicSourceType
	
	s TSourceType=""
	for  Set TSourceType=$o(DHCEQTemp(TSourceType)) q:TSourceType=""  d
	.Set TDesc=$Case(TSourceType,0:"设备",1:"保养",2:"检查",3:"维修",4:"证件",5:"采购合同",6:"保修合同",7:"验收",99:"培训")
	.Do OutputRowLookUpInfo
	
	s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
	Quit $$$OK
BuildDataByRowid
	Do ResetVariablesLookUpInfo
	Set TRowId = RowID
	Set TInvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)
	Quit:TInvalidFlag="Y"
	Set TDesc=$Case(TSourceType,0:"设备",1:"保养",2:"检查",3:"维修",4:"证件",5:"采购合同",6:"保修合同",7:"验收",99:"培训")
	Do OutputRowLookUpInfo
	Quit	
BuildDataGetPicSourceType
	Do ResetVariablesLookUpInfo
	Set TRowId = PicSourceTypeDR
	s TSourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	Quit:(0=##Class(web.DHCEQ.query.DHCEQCPicSourceType).Configure(CurrentSourceType,TSourceType))
	s TPicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	Quit:(PicTypeDR'="")&&(PicTypeDR'=TPicTypeDR)
	
	Set TInvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)
	Quit:TInvalidFlag="Y"
	s DHCEQTemp(TSourceType)=TSourceType
	//Set TDesc=$Case(TSourceType,0:"设备",1:"保养",2:"检查",3:"维修",4:"证件",5:"采购合同",6:"保修合同",7:"验收",99:"培训")
	//Do OutputRowLookUpInfo
	Quit
OutputRowLookUpInfo
	Set Data=TSourceType_"^"_TDesc
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(Data)
	Quit
ResetVariablesLookUpInfo
	Set (TRowId,TDesc)=""
	Quit
}

ClassMethod Configure(CurrentSourceType, SourceType)
{
	q:(CurrentSourceType=7)&&(SourceType'=7) 0
	q 1
}

ClassMethod IsPicTypeInSourceType(CurrentSourceType As %String = "", PicTypeDR As %String = "")
{
	set ResultJson=1
	s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s TSourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.q:(CurrentSourceType'="")&&(TSourceType'=CurrentSourceType)
	.s TPicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.s:(PicTypeDR'="")&&(TPicTypeDR=PicTypeDR) ResultJson=0
	q ResultJson
}

//0:设备|1:保养|2:检查|3:维修|4:证件|5:采购合同|6:保修合同|7:验收|99:培训

ClassMethod GetPicTypeMenu(CurrentSourceType As %String = "", CurrentSourceID As %String = "")
{
	//k DHCEQTemp
	set menusJson="["
	s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s SourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.//q:(CurrentSourceType=7)&&(SourceType'=7)
	.Quit:(0=##Class(web.DHCEQ.query.DHCEQCPicSourceType).Configure(CurrentSourceType,SourceType))
	.s PicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.s DHCEQTemp(PicTypeDR)=PicTypeDR
	s PicTypeDR=""
	for  s PicTypeDR=$o(DHCEQTemp(PicTypeDR)) q:PicTypeDR=""  d
	.s PicCode=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",1)
	.s PicDesc=$p(^DHCEQCCode("DHCEQCPicType",PicTypeDR),"^",2)
	.s menusJson=menusJson_"{""id"":"_PicTypeDR_",""text"":"""_PicDesc_""",""icon"":"""",""myhref"":""dhceq.process.picture.csp?&CurrentSourceType="_CurrentSourceType_"&CurrentSourceID="_CurrentSourceID_"&PicTypeDR="_PicTypeDR_""",""leaf"":true},"
	s menusJson=menusJson_"]"
	q menusJson
}

ClassMethod GetMainMenu()
{
	q "[{""id"":""0"",""text"":""图片类型"",""icon"":"""",""leaf"":false}]"
}
*/
}
