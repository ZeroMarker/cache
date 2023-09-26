/// Creator:     Huxiaotian 2018-10-13
/// Description: JS请求封装统一出入口, EasyUI/HisUI/ExtJS通用
/// Update:      2019-09-22 (1)与HISUI的websys.Broker.cls兼容; (2)优化入参获取
Class web.DHCST.Common.ActionURL Extends (%CSP.Page, web.DHCST.Common.Act) [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	// Base Param
	Set ClassName = $Get(%request.Data("ClassName",1))
	Set QueryName = $Get(%request.Data("QueryName",1))
	Set MethodName = $Get(%request.Data("MethodName",1))
	Do:(QueryName = "")&&(MethodName = "") ..WriteErrorJSON(-102, "QueryName和MethodName至少包含一个")
	Quit:(QueryName = "")&&(MethodName = "") $$$OK
	Set ParamStr = $Get(%request.Data("Params",1))
	Set MOutput = $Get(%request.Data("MOutput",1))
	Set:(MOutput = "") MOutput = $Get(%request.Data("WantReturnVal", 1))
	Set:(MOutput = "") MOutput = $Get(%request.Data("wantreturnval", 1))
	Set:(MOutput = "") MOutput = "Quit" // 默认方法有返回值
	Set $ZT = "DHCSTHTTPERROR"
	// Run ClassMethod
 	If (MethodName '= "")&&(MOutput '= "") Do
 	.Set DoOutput = $Select(MOutput="Write":"Do", MOutput="0":"Do", 1:"Write")
	.Write ..ExeClassMethod(ClassName, MethodName, ParamStr, DoOutput)
 	Quit:(MethodName'="")&&(MOutput'="") $$$OK
	// Run Query
	Set JsonType = $Get(%request.Data("JsonType",1)) // 兼容ExtJs (array/total/results)
	Set:(JsonType = "") JsonType = $ZCVT($Get(%request.Data("ResultSetType",1)), "L") // 兼容HISUI
	Set:(JsonType = "") JsonType = "total"
	If (QueryName '= "") Do
	.;1.Create And Run ResultSet
	.Set rs = ..ExeClassQuery(ClassName, QueryName, ParamStr)
	.;2.Sort And Paging Info
	.Set cParamsObj = ..GetParams()
 	.Set SortColumn = cParamsObj.Sort
	.Set SortOrder = cParamsObj.Dir
	.Set tSortOrder = $Select(SortOrder="DESC":-1, 1:1)
	.Set pDataFrom = cParamsObj.DataFrom
	.Set pDataTo = cParamsObj.DataTo
	.Set jqGridPaging = $Get(%request.Data("jqGridPaging",1))
	.Set:(jqGridPaging = "N") pDataTo = 99999 // jqGrid not Pagination
	.;3.Set TempData
 	.Kill SortTemp
 	.Set Count = 0
 	.Set ColumnsCnt = rs.GetColumnCount()
 	.For  Quit:(rs.Next() = 0)  Do
 	..Set KeyVals = "", OneObj = "", SortColVal = 0
 	..For iiii = 1 : 1 : ColumnsCnt Do
 	...Set OutVal = rs.GetData(iiii)
 	...Set OutKey = rs.GetColumnName(iiii)
 	...If (OutKey = SortColumn)&&(OutVal '= "") Set SortColVal = OutVal
 	...Set OutVal = ..ReplaceSpecialChar(OutVal)
 	...Set KeyVal = $c(34)_OutKey_$c(34)_":"_$c(34)_OutVal_$c(34)
 	...If (KeyVals = "") Set KeyVals = KeyVal
 	...Else  Set KeyVals = KeyVals _ "," _ KeyVal
 	..Set OneObj = "{" _ KeyVals _ "}"
 	..Set Count = Count + 1
 	..Set SortTemp(SortColVal, Count) = OneObj
 	.;4.Output Data
 	.Set FirstFlag = 1, CurCnt = 0
 	.Write:(JsonType = "array") "[" 
 	.Write:(JsonType '= "array") "{" _ $c(34) _ "rows" _ $c(34) _ ":["
 	.Set SortColVal = ""
 	.For  Set SortColVal = $o(SortTemp(SortColVal),tSortOrder) Quit:SortColVal=""  Do
 	..Set CntData = ""
 	..For  Set CntData = $o(SortTemp(SortColVal,CntData),tSortOrder) Quit:CntData=""  Do
 	...Set CurCnt = CurCnt + 1
 	...Quit:(CurCnt < pDataFrom)
 	...Quit:(CurCnt > pDataTo)
 	...If (FirstFlag = 1) Do
 	....Write SortTemp(SortColVal, CntData)
 	....Set FirstFlag = 0
 	...Else  Do
 	....Write "," _ SortTemp(SortColVal, CntData)
 	.Write:(JsonType = "array") "]"
 	.If (JsonType '= "array") Do
 	..Write "]," _ $c(34) _ JsonType _ $c(34) _ ":" _ CurCnt
 	..Write "," _ $c(34) _ "pages" _ $c(34) _ ":" _ ..GetTotalPages(CurCnt, cParamsObj.Rows)
 	..Write "," _ $c(34) _ "curPage" _ $c(34) _ ":" _ cParamsObj.CurPage
 	..Write "}"
 	.Do rs.%Close()
	Quit:(QueryName '= "") $$$OK
	// Others Output
	Do ..WriteErrorJSON(-104, "请求参数无效")
	Quit $$$OK
DHCSTHTTPERROR
	Set ErrCode = -105
	Set ErrMsg = $ZE
	Set ErrMsg = ..GetErrDescription(ErrMsg, ClassName)
	Write ..WriteErrorJSON(ErrCode, ErrMsg)
	Quit $$$OK
}

}
