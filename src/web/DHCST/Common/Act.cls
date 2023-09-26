/// Creator:     Huxiaotian 2018-10-13
/// Description: 封装处理请求参数的方法
Class web.DHCST.Common.Act Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// properties
Property DataFrom As %Integer [ InitialExpression = 0 ];

Property DataTo As %Integer [ InitialExpression = 99999 ];

Property Start As %Integer [ InitialExpression = 0 ];

Property Limit As %Integer [ InitialExpression = 99999 ];

Property Page As %Integer [ InitialExpression = 1 ];

Property Rows As %Integer [ InitialExpression = 99999 ];

Property Sort As %String;

Property Dir As %String;

Property Filter As %String;

Property CurPage As %Integer [ InitialExpression = 1 ];

/// -------------------------------------------------------
/// Description: 空json串
/// Creator:     Huxiaotian 2018-10-13
/// Input:       total/results/array
/// Output:      JSON String
/// w ##class(web.DHCST.Common.Act).WriteEmptyJSON("total")
ClassMethod WriteEmptyJSON(jsonType As %String = "array") As %String
{
	New (jsonType, %request, %session, %response)
	Write:jsonType="array" "[]"
	Write:jsonType'="array" "{"_$C(34)_jsonType_$C(34)_":0"_","_$C(34)_"rows"_$C(34)_":[]}"
	Quit ""
}

ClassMethod EmptyJSON(jsonType As %String = "array") As %String
{
	New (jsonType, %request, %session, %response)
	Quit:jsonType="array" "[]"
	Quit:jsonType'="array" "{"_$C(34)_jsonType_$C(34)_":0"_","_$C(34)_"rows"_$C(34)_":[]}"
	Quit "[]"
}

/// Description: 异常统一出口
/// Creator:     Huxiaotian 2018-10-13
/// Input:       sc - 错误代码;
///              errMsg - 错误提示信息
/// Output:      {"errCode":"-101","errMsg":"系统异常"}
/// w ##class(web.DHCST.Common.Act).WriteErrorJSON(-102, "系统异常...")
ClassMethod WriteErrorJSON(sc As %Status, errMsg As %String = "") As %String [ ServerOnly = 1 ]
{
	New (sc, errMsg, %request, %session, %response)
	Write {"errCode":(sc),"errMsg":(errMsg),"success":0,"msg":(errMsg)}.%ToJSON()
	Quit ""
	Set sc = ..ReplaceSpecialChar(sc)
	Set errMsg = ..ReplaceSpecialChar(errMsg)
	Set errJsonStr = "{"
	Set errJsonStr = errJsonStr _ $c(34)_"errCode"_$c(34)_":"_$c(34)_sc_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"errMsg"_$c(34)_":"_$c(34)_errMsg_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"success"_$c(34)_":"_$c(34)_0_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"msg"_$c(34)_":"_$c(34)_errMsg_$c(34)
	Set errJsonStr = errJsonStr _ "}"
	Write errJsonStr
	Quit ""
}

/// Description: 返回错误json串
/// Creator:     Huxiaotian 2018-10-13
/// w ##class(web.DHCST.Common.Act).ErrorJSON(-1, "保存失败")
ClassMethod ErrorJSON(sc As %Status, errMsg As %String = "") As %String [ ServerOnly = 1 ]
{
	New (sc, errMsg, %request, %session, %response)
	Set sc = ..ReplaceSpecialChar(sc)
	Set errMsg = ..ReplaceSpecialChar(errMsg)
	Set errJsonStr = "{"
	Set errJsonStr = errJsonStr _ $c(34)_"errCode"_$c(34)_":"_$c(34)_sc_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"errMsg"_$c(34)_":"_$c(34)_errMsg_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"success"_$c(34)_":"_$c(34)_0_$c(34)_","
	Set errJsonStr = errJsonStr _ $c(34)_"msg"_$c(34)_":"_$c(34)_errMsg_$c(34)
	Set errJsonStr = errJsonStr _ "}"
	Quit errJsonStr
}

/// Description: ExtJs or EasyUI 统一分页信排序息取法
/// Creator:     Huxiaotian 2018-10-13
/// Output:      %ArrayOfDataTypes
/// w ##class(web.DHCST.Common.Act).GetParams()
ClassMethod GetParams() As web.DHCST.Common.Act
{
	New (%request, %session, %response)
	Set myParamsObj = ##class(web.DHCST.Common.Act).%New()
	Quit:'$d(%request) myParamsObj
	Set gExtJsFlag = $Get(%request.Data("ExtJsFlag",1))
	If (gExtJsFlag = "Y") Do // extjs
	.Set gStart = +$Get(%request.Data("start",1))
	.Set gLimit = +$Get(%request.Data("limit",1))
	.Set gDataFrom = gStart + 1
	.Set gDataTo = gStart + gLimit
	.Set myParamsObj.Start = gStart
	.Set myParamsObj.Limit = gLimit
	.Set myParamsObj.Sort = $Get(%request.Data("sort",1))
	.Set myParamsObj.Dir = $ZCVT($Get(%request.Data("dir",1)),"U") // DESC OR ASC
	.Set myParamsObj.CurPage = ((gDataFrom - 1) / gLimit) + 1
	.Set myParamsObj.CurPage = $s(myParamsObj.CurPage <= 0:1, 1:myParamsObj.CurPage)
	Else  Do // easyui or hisui
	.Set gPage = +$Get(%request.Data("page",1))
	.Set gRows = +$Get(%request.Data("rows",1))
	.Set gDataFrom = ((gPage - 1) * gRows) + 1
	.Set gDataTo = gPage * gRows
	.Set myParamsObj.Page = gPage
	.Set myParamsObj.Rows = gRows
	.Set myParamsObj.Sort = $Get(%request.Data("sort",1))
	.Set myParamsObj.Dir = $ZCVT($Get(%request.Data("order",1)),"U") // DESC OR ASC
	.Set myParamsObj.CurPage = $s(gPage <= 0:1, 1:gPage)
	Set:(gDataFrom <= 0) gDataFrom = 1
	Set:(gDataTo < gDataFrom) gDataTo = 9999
	Set myParamsObj.DataFrom = gDataFrom
	Set myParamsObj.DataTo = gDataTo
	Set myParamsObj.Filter = $Get(%request.Data("filter",1))
	Quit myParamsObj
}

/// Description: 获取请求参数
/// w ##class(web.DHCST.Common.Act).GetParam("page")
ClassMethod GetParam(reqKey) As %String
{
	New (reqKey, %request, %session, %response)
	Quit:'$d(%request) ""
	Quit $Get(%request.Data(reqKey,1))
}

/// Description: 向上取整数
/// w ##class(web.DHCST.Common.Act).Ceil(1.2)
ClassMethod Ceil(NUM) As %Integer
{
	New (NUM, %request, %session, %response)
	Set TempNum = +NUM
	Quit:TempNum'["." TempNum
	Quit:TempNum["." +$p(TempNum,".",1) + 1
}

/// Description: 总页数
/// w ##class(web.DHCST.Common.Act).GetTotalPages(102, 50)
ClassMethod GetTotalPages(mTotal, mRows) As %Integer
{
	New (mTotal, mRows, %request, %session, %response)
	q:(mRows = 0) 1
	q ..Ceil(mTotal / mRows)
}

/// Description: 设置session
/// w ##class(web.DHCST.Common.Act).SetSession("key1^val1"_$c(2)_"key2^val2")
ClassMethod SetSession(SessionInfo) As %Integer
{
	New (SessionInfo, %request, %session, %response)
	Quit:'$d(%session) -1
	Set Len = $l(SessionInfo, $c(2))
	For iSession = 1:1:Len Do
	.Set SessionStr = $p(SessionInfo, $c(2), iSession)
	.Set sIndex = $p(SessionStr,"^",1)
	.Set sValue = $p(SessionStr,"^",2)
	.Set %session.Data(sIndex) = sValue
	Quit Len
}

/// Description: 异常信息描述转换 (内部调用)
/// Creator:     Huxiaotian 2018-10-13
/// w ##class(web.DHCST.Common.Act).GetErrDescription()
ClassMethod GetErrDescription(ErrMsgInfo, OtherInfo = "") As %String
{
	New (ErrMsgInfo, OtherInfo, %request, %session, %response)
	Quit:ErrMsgInfo="" ErrMsgInfo
	Set:ErrMsgInfo["<UNDEFINED>" ErrMsgInfo = ErrMsgInfo_"^变量未定义"
	Set:ErrMsgInfo["<INVALID OREF>" ErrMsgInfo = ErrMsgInfo_"^引用无效: 请检查Method或Query是否存在系统中,或者类"_OtherInfo_"是否编译"
	Set:ErrMsgInfo["<PARAMETER>" ErrMsgInfo = ErrMsgInfo_"^参数异常: 参数个数不一致"
	Set:ErrMsgInfo["<METHOD DOES NOT EXIST>" ErrMsgInfo = ErrMsgInfo_"^类方法不存在"
	Set:ErrMsgInfo["must return a value" ErrMsgInfo = ErrMsgInfo_"^类方法必须使用q或者return返回值"
	Set ErrMsgInfo = $replace(ErrMsgInfo, "<", "")
	Set ErrMsgInfo = $replace(ErrMsgInfo, ">", "%")
	Quit ErrMsgInfo
}

/// Description: 替换JSON数据中的特殊字符串 (内部调用)
/// Creator:     Huxiaotian 2018-10-13
/// Input:       可能包含特殊字符的字符串
/// Output:      不含特殊字符的字符串
/// w ##class(web.DHCST.Common.Act).ReplaceSpecialChar()
ClassMethod ReplaceSpecialChar(pOldStr As %String) As %String
{
	n (pOldStr, %request, %session, %response)
	q:pOldStr="" ""
	set pOldStr = $replace(pOldStr,"\","\\")  // 必须放第一个
	set pOldStr = $replace(pOldStr,$c(0) ,"\u0000")
	set pOldStr = $replace(pOldStr,$c(1) ,"\u0001")
	set pOldStr = $replace(pOldStr,$c(2) ,"\u0002")
	set pOldStr = $replace(pOldStr,$c(3) ,"\u0003")
	set pOldStr = $replace(pOldStr,$c(4) ,"\u0004")
	set pOldStr = $replace(pOldStr,$c(5) ,"\u0005")
	set pOldStr = $replace(pOldStr,$c(6) ,"\u0006")
	set pOldStr = $replace(pOldStr,$c(7) ,"\u0007")
	set pOldStr = $replace(pOldStr,$c(8) ,"\b")
	set pOldStr = $replace(pOldStr,$c(9) ,"\t")
	set pOldStr = $replace(pOldStr,$c(10),"\n")
	set pOldStr = $replace(pOldStr,$c(11),"\u000b")
	set pOldStr = $replace(pOldStr,$c(12),"\f")
	set pOldStr = $replace(pOldStr,$c(13),"\r")
	set pRetStr = $replace(pOldStr,$c(34),"\""")
	q pRetStr
}

/// Description: 运行类方法 (主要解决前台传参太长的时候,入参为对象,无法获取的问题)
/// Creator:     Huxiaotian 2021-08-04
/// w ##class(web.DHCST.Common.Act).ExeClassMethod("PHA.SYS.PrintClient.Com", "GetUserId")
ClassMethod ExeClassMethod(cName, mName, mParamStr = "", dOutput = "Quit") As %String
{
	n (cName, mName, mParamStr, dOutput, %request, %session, %response)
	// 获取参数
	s mtdArgInfoStr = $g(^oddDEF(cName, "m", mName, 27))
	if (mtdArgInfoStr = "") {
		s mtdArgInfoLen = 0
	} else {
		k arg
		s isParamListByStr = $Get(%request.Data("ParamListByStr", 1))
		s mtdArgInfoLen = $l(mtdArgInfoStr, ",")
		for imp = 1 : 1 : mtdArgInfoLen {
			if (isParamListByStr = 1) {
				s arg(imp) = $p(mParamStr, $c(2), imp)
			} else {
				s iMtdParaKey = $p(mtdArgInfoStr, ",", imp)
				s iMtdParaKey = $p(iMtdParaKey, "=", 1)
				s iMtdParaKey = $p(iMtdParaKey, ":", 1)
				s iMtdParaKey = $replace(iMtdParaKey, "*", "")
				s iMtdParaKey = $replace(iMtdParaKey, "&", "")
				s iMtdParaVal = $Get(%request.Data(iMtdParaKey, 1))
				s arg(imp) = iMtdParaVal
			}
		}
	}
	// 小于等于30个参数
	if (mtdArgInfoLen = 0) {
		s mRet = $ClassMethod(cName, mName)
	} elseif (mtdArgInfoLen = 1) {
		s mRet = $ClassMethod(cName, mName, arg(1))
	} elseif (mtdArgInfoLen = 2) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2))
	} elseif (mtdArgInfoLen = 3) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3))
	} elseif (mtdArgInfoLen = 4) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4))
	} elseif (mtdArgInfoLen = 5) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5))
	} elseif (mtdArgInfoLen = 6) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6))
	} elseif (mtdArgInfoLen = 7) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7))
	} elseif (mtdArgInfoLen = 8) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8))
	} elseif (mtdArgInfoLen = 9) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9))
	} elseif (mtdArgInfoLen = 10) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10))
	} elseif (mtdArgInfoLen = 11) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11))
	} elseif (mtdArgInfoLen = 12) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12))
	} elseif (mtdArgInfoLen = 13) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13))
	} elseif (mtdArgInfoLen = 14) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14))
	} elseif (mtdArgInfoLen = 15) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15))
	} elseif (mtdArgInfoLen = 16) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16))
	} elseif (mtdArgInfoLen = 17) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17))
	} elseif (mtdArgInfoLen = 18) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18))
	} elseif (mtdArgInfoLen = 19) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19))
	} elseif (mtdArgInfoLen = 20) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20))
	} elseif (mtdArgInfoLen = 21) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21))
	} elseif (mtdArgInfoLen = 22) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22))
	} elseif (mtdArgInfoLen = 23) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23))
	} elseif (mtdArgInfoLen = 24) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24))
	} elseif (mtdArgInfoLen = 25) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25))
	} elseif (mtdArgInfoLen = 26) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26))
	} elseif (mtdArgInfoLen = 27) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27))
	} elseif (mtdArgInfoLen = 28) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28))
	} elseif (mtdArgInfoLen = 29) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28), arg(29))
	} elseif (mtdArgInfoLen = 30) {
		s mRet = $ClassMethod(cName, mName, arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28), arg(29), arg(30))
	}
	if (mtdArgInfoLen <= 30) {
		if ($IsObject(mRet)) {
			if ((mRet.%IsA("PHA.COM.Object"))||(mRet.%IsA("PHA.COM.Array"))) {
				q mRet.ToJSON()
			} elseif ((mRet.%IsA("%Library.DynamicObject"))||(mRet.%IsA("%Library.DynamicArray"))) {
				q mRet.%ToJSON()
			} elseif (mRet.%IsA("%Stream.GlobalCharacter")) {
				d mRet.Rewind()
				while ('mRet.AtEnd) {
					w mRet.Read()
				}
				q ""
			} else {
				q mRet
			}
		} else {
			q mRet
		}
	}
	// 大于30个参数
 	s RunMethodStr = dOutput _ " ##class(" _ cName _ ")." _ mName _ "("
 	for imp = 1 : 1 : mtdArgInfoLen {
	 	s iMtdParaVal = $g(arg(imp))
	 	s iMtdParaVal = $replace(iMtdParaVal, $c(34), $c(34) _ $c(34))
	 	if (imp = mtdArgInfoLen) {
		 	s RunMethodStr = RunMethodStr _ $c(34) _ iMtdParaVal _ $c(34)
		} else {
			s RunMethodStr = RunMethodStr _ $c(34) _ iMtdParaVal _ $c(34) _ ","
		}
	}
	s RunMethodStr = RunMethodStr _ ")"
	xecute RunMethodStr
	q ""
}

/// Description: 执行Query获取结果集%ResultSet
/// Creator:     Huxiaotian 2021-08-04
/// w ##class(web.DHCST.Common.Act).ExeClassQuery()
ClassMethod ExeClassQuery(cName, qName, qParamStr = "") As %ResultSet
{
	n (cName, qName, qParamStr, %request, %session, %response)
	// 获取参数
	s qryArgInfoStr = $g(^oddDEF(cName, "q", qName, 24))
	s rs = ##class(%ResultSet).%New(cName_":"_qName)
	s qryArgInfoLen = rs.GetParamCount()
	if (qryArgInfoLen = 0) {
		s sc = rs.Execute()
		q rs
	} else {
		k arg
		s isParamListByStr = $Get(%request.Data("ParamListByStr", 1))
		s qryArgInfoLen = $l(qryArgInfoStr, ",")
		for iqp = 1 : 1 : qryArgInfoLen {
			if (isParamListByStr = 1) {
				s arg(iqp) = $p(qParamStr, $c(2), iqp)
			} else {
				s iQryParaKey = $p(qryArgInfoStr, ",", iqp)
				s iQryParaKey = $p(iQryParaKey, "=", 1)
				s iQryParaKey = $p(iQryParaKey, ":", 1)
				s iQryParaKey = $replace(iQryParaKey, "*", "")
				s iQryParaKey = $replace(iQryParaKey, "&", "")
				s iQryParaVal = $Get(%request.Data(iQryParaKey, 1))
				s arg(iqp) = iQryParaVal
			}
		}
	}
	// 小于等于30个参数
	if (qryArgInfoLen = 0) {
		s sc = rs.Execute()
	} elseif (qryArgInfoLen = 1) {
		s sc = rs.Execute(arg(1))
	} elseif (qryArgInfoLen = 2) {
		s sc = rs.Execute(arg(1), arg(2))
	} elseif (qryArgInfoLen = 3) {
		s sc = rs.Execute(arg(1), arg(2), arg(3))
	} elseif (qryArgInfoLen = 4) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4))
	} elseif (qryArgInfoLen = 5){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5))
	} elseif (qryArgInfoLen = 6){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6))
	} elseif (qryArgInfoLen = 7){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7))
	} elseif (qryArgInfoLen = 8){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8))
	} elseif (qryArgInfoLen = 9){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9))
	} elseif (qryArgInfoLen = 10){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10))
	} elseif (qryArgInfoLen = 11){
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11))
	} elseif (qryArgInfoLen = 12) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12))
	} elseif (qryArgInfoLen = 13) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13))
	} elseif (qryArgInfoLen = 14) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14))
	} elseif (qryArgInfoLen = 15) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15))
	} elseif (qryArgInfoLen = 16) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16))
	} elseif (qryArgInfoLen = 17) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17))
	} elseif (qryArgInfoLen = 18) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18))
	} elseif (qryArgInfoLen = 19) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19))
	} elseif (qryArgInfoLen = 20) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20))
	} elseif (qryArgInfoLen = 21) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21))
	} elseif (qryArgInfoLen = 22) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22))
	} elseif (qryArgInfoLen = 23) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23))
	} elseif (qryArgInfoLen = 24) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24))
	} elseif (qryArgInfoLen = 25) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25))
	} elseif (qryArgInfoLen = 26) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26))
	} elseif (qryArgInfoLen = 27) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27))
	} elseif (qryArgInfoLen = 28) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28))
	} elseif (qryArgInfoLen = 29) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28), arg(29))
	} elseif (qryArgInfoLen = 30) {
		s sc = rs.Execute(arg(1), arg(2), arg(3), arg(4), arg(5), arg(6), arg(7), arg(8), arg(9), arg(10), arg(11), arg(12), arg(13), arg(14), arg(15), arg(16), arg(17), arg(18), arg(19), arg(20), arg(21), arg(22), arg(23), arg(24), arg(25), arg(26), arg(27), arg(28), arg(29), arg(30))
	}
	q:(qryArgInfoLen <= 30) rs
	// 大于30个参数
	s ExecuteStr = "s sc = $zobjMethod(rs," _ $c(34) _ "Execute" _ $c(34) _ ","
	for iqp = 1 : 1 : qryArgInfoLen {
		s iQryParaVal = $g(arg(iqp))
	 	s iQryParaVal = $replace(iQryParaVal, $c(34), $c(34) _ $c(34))
	 	if (iqp = qryArgInfoLen) {
		 	s ExecuteStr = ExecuteStr _ $c(34) _ iQryParaVal _ $c(34)
		} else {
			s ExecuteStr = ExecuteStr _ $c(34) _ iQryParaVal _ $c(34) _ ","
		}
	}
	s ExecuteStr = ExecuteStr _ ")"
	xecute ExecuteStr
	q rs
}

}
