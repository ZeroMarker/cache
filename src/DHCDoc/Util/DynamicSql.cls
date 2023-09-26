/// lixu
/// 2022-10-10
/// SQL相关动态写法
/// Sqldb调试：语法：CALL 包名.类名_Query名  包名用"_"连接，入参如果是空，传进Cache是：$c(0)，程序需做转换
/// 	CALL DHCDoc_Util.Sql_LookUpCat("")
/// 
Class DHCDoc.Util.DynamicSql Extends %RegisteredObject
{

/// desc：通过SQL语句获取动态对象
/// input: SqlStr:SQL语句
/// output: 字符串/对象: 错误信息/结果对象
/// w ##class(DHCDoc.Util.DynamicSql).GetQueryObjBySqlStr("SELECT * FROM OEC_OrderStatus WHERE OSTAT_Code like 'V%'")
ClassMethod GetQueryObjBySqlStr(SqlStr, Arg...)
{
	Set ErrMsg="",result=""
	try{
		Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")		;%DynamicQuery:SQL可以不要
		Set sc=result.Prepare(SqlStr)
		If $$$ISERR(sc){
			Set ErrMsg=$system.Status.GetErrorText(sc)
			return ErrMsg
		}
		Set sc=result.Execute(Arg...) 
		If $$$ISERR(sc) {
			Set ErrMsg=$system.Status.GetErrorText(sc)
			return ErrMsg
		}
	}catch{
		Set ErrMsg="程序异常:"_$ZE 
		return ErrMsg
	}
	Quit:ErrMsg'="" ErrMsg
	Quit result
}

/// desc：通过类名和Query获取动态对象
/// input: ClassQuery:类名:Query名
/// output: 字符串/对象: 错误信息/结果对象
/// w ##class(DHCDoc.Util.DynamicSql).GetQueryObjByQueryStr("DHCDoc.Interface.Outside.SmartInsu.YNPortal:GetDiagList",18)
ClassMethod GetQueryObjByQueryStr(ClassQuery, Arg...)
{
	Set ErrMsg="",result=""
	try{
		Set ClassName=$p(ClassQuery,":",1)
		Set QueryName=$p(ClassQuery,":",2)
		return:(ClassName="")||(QueryName="") "请输入有效的类名:Query名"

		if '##class(websys.Conversions).IsValidQueryName(ClassName,QueryName){
			Set ErrMsg="没有找到Query："_ClassQuery
			return ErrMsg 
		}
		
		Set result=##class(%ResultSet).%New(ClassQuery)
		Set sc=result.Execute(Arg...) 
		If $$$ISERR(sc) {
			Set ErrMsg=$system.Status.GetErrorText(sc)
			return ErrMsg
		}
	}catch{
		Set ErrMsg="程序异常:"_$ZE 
		return ErrMsg
	}
	Quit:ErrMsg'="" ErrMsg
	Quit result
}

/// desc：通过:类名和Query、动态SQL语句 获取动态对象
/// input: ClassQuery:类名:Query名()
/// output: 字符串/对象: 错误信息/结果对象
/// w ##class(DHCDoc.Util.DynamicSql).GetQueryObjByStatements("SELECT * FROM OEC_OrderStatus WHERE OSTAT_Code like ?","Sql","V%")
/// w ##class(DHCDoc.Util.DynamicSql).GetQueryObjByStatements("DHCDoc.Interface.Outside.SmartInsu.YNPortal:GetDiagList",,"18")
ClassMethod GetQueryObjByStatements(Statement, Flag = "Query", Arg...)
{
	Set ErrMsg="",result=""
	try{
		Set Flag=$ZCVT(Flag,"U")
		If Flag="SQL"{
			;动态SQL
			Set result=..GetQueryObjBySqlStr(Statement,Arg...)
		}
		If Flag="QUERY"{
			;Query
			Set result=..GetQueryObjByQueryStr(Statement,Arg...)
		}
	}catch{
		Set ErrMsg="程序异常:"_$ZE 
		return ErrMsg
	}
	Quit:ErrMsg'="" ErrMsg
	Quit result
}

/// desc: 通过SQL语句生成json数据
/// input: JsonStr: json串：{""JsonCodeStr"":""^Code^Desc"",""JsonFlag"":""Y""} : JsonCodeStr:字段别名、JsonFlag:返回JSON标识、DynamicFlag:动态对象标识
/// 		SqlStr:SQL语句
/// output: (-1/0^描述)/对象：(错误/成功^描述)/对象 %Library.DynamicArray 老版本可改为 DHCDoc.Util.ListData
/// w ##class(DHCDoc.Util.DynamicSql).GetJsonObjBySqlStr("{""JsonCodeStr"":""^Code^Desc"",""JsonFlag"":""Y"",""DynamicFlag"":""N""}","SELECT * FROM OEC_OrderStatus WHERE OSTAT_Code like ?","P%").Read()
/// w ##class(DHCDoc.Util.DynamicSql).GetJsonObjBySqlStr(,"SELECT OEORI_ItmMast_DR As ArcimID, OEORI_ItmMast_DR->ARCIM_Code As ArcimCode, OEORI_ItmMast_DR->ARCIM_Desc As ArcimDesc FROM OE_OrdItem WHERE OEORI_OEORD_ParRef=? AND OEORI_ItemStat_DR=?","12","1").%ToJSON()
ClassMethod GetJsonObjBySqlStr(JsonStr = "{}", SqlStr, Arg...)
{
	try{
		Set ErrMsg=""	
		Set InObj={}.%FromJSON(JsonStr)
		Set JsonCodeStr=InObj."JsonCodeStr"		;json字段代码
		Set JsonFlag=InObj."JsonFlag"			;返回Json标识(Y)
		Set DynamicFlag=InObj."DynamicFlag"		;动态Json标识(Y)
		
		if (DynamicFlag="N") Set JsonObj=##class(DHCDoc.Util.ListData).%New()
		else  Set JsonObj=[]
		Set result=..GetQueryObjBySqlStr(SqlStr, Arg...)
		return:'$IsObject(result) "-1^"_result
		
		Set ColCnt=result.GetColumnCount()
		While result.Next(.sc) {
			if (DynamicFlag="N") Set Obj=##class(DHCDoc.Util.ArrayData).%New()
			else  Set Obj={}
			for len=1:1:ColCnt{
				Set ColName=result.GetColumnName(len)
				Set ColData=result.Get(ColName)
				If JsonCodeStr'="" Do
				.Set JsonName=$p(JsonCodeStr,"^",len)
				.Set:JsonName'="" ColName=JsonName
				Do Obj.%Set(ColName,ColData)
			}
			Do JsonObj.%Push(Obj)
		}
		Do result.Close()
		
		return:ErrMsg'="" "-1^"_ErrMsg
		if JsonFlag="Y"{
			return "0^"_JsonObj.%ToJSON()
		}
		return JsonObj
	}catch{
		return ErrMsg="-1^程序异常:"_$ZE 
	}
	Quit "-1^程序完毕"
}

/// d ##class(DHCDoc.Util.DynamicSql).TestSql()
ClassMethod TestSql()
{
	;调试Query写法
	s result=..GetQueryObjByStatements("DHCDoc.Interface.Outside.SmartInsu.YNPortal:GetDiagList",,18)
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("ICDCode"),result.Get("ICDDesc"),!
		}
	}else{
		write result ,!
	}
	
	;SQL多个条件写法
	s SqlStr="SELECT PAADM_RowID FROM SQLUser.PA_Adm WHERE PAADM_RowID in (?,?)"
	s result=..GetQueryObjByStatements(SqlStr,"sql",1,2)
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("PAADM_RowID"),!
		}
	}else{
		write result ,!
	}
	
	;匹配写法，获取所有字段信息。
	s SqlStr="SELECT * FROM OEC_OrderStatus WHERE OSTAT_Code like 'P%'"
	s result=..GetQueryObjBySqlStr(SqlStr)
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("OSTAT_RowId"),result.Get("OSTAT_Code"),!
		}
	}else{
		write result ,!
	}
	
	;动态条件参数写法。
	s SqlStr="SELECT OSTAT_RowId, OSTAT_Code, OSTAT_Desc FROM OEC_OrderStatus where OSTAT_Code=? AND OSTAT_Desc LIKE ?"
	s result=..GetQueryObjBySqlStr(SqlStr,"V", "核%")
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("OSTAT_RowId"),result.Get("OSTAT_Desc"),!
		}
	}else{
		write result ,!
	}
	
	;字段别名写法。注：Desc是SQL关键字，不能作为别名
	s SqlStr="SELECT OSTAT_RowId As ID, OSTAT_Code As Code, OSTAT_Desc As Desc1 FROM OEC_OrderStatus where OSTAT_Code=? AND OSTAT_Desc LIKE ?"
	s result=..GetQueryObjBySqlStr(SqlStr,"V", "核%")
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("Code"),result.Get("Desc1"),!
		}
	}else{
		write result ,!
	}

	;注：Desc是SQL关键字，不能作为别名
	s SqlStr="SELECT OSTAT_RowId As ID, OSTAT_Code As Code, OSTAT_Desc As Desc1 FROM OEC_OrderStatus where OSTAT_Code='V' AND OSTAT_Desc LIKE '核%'"
	s result=..GetQueryObjBySqlStr(SqlStr)
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("Code"),result.Get("Desc1"),!
		}
	}else{
		write result ,!
	}
	
	;别名写法，注：该写法返回的对象还是只能通过获取表字段，通过别名变量输出有问题，但调试是Code或PLIST是存在的(原因未知)
	s SqlStr="SELECT OSTAT_RowId, OSTAT_Code, OSTAT_Desc Into ID,Code,Desc1 FROM OEC_OrderStatus where OSTAT_Code LIKE ?"
	s result=..GetQueryObjBySqlStr(SqlStr,"%P%")
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write result.Get("OSTAT_Code"),result.Get("OSTAT_Desc"),!
			b ;此处调试时直接输出Code是有值，但程序输出就未定义
			;Write Code,Desc1 ,!
		}
	}else{
		write result ,!
	}
	
	;数组写法
	s SqlStr="SELECT * Into PLIST() FROM OEC_OrderStatus WHERE OSTAT_Code like 'P%'"
	s result=..GetQueryObjBySqlStr(SqlStr)
	i $IsObject(result){
		While result.Next(.sc) {
			If $$$ISERR(sc) Quit
			Write PLIST(1),PLIST(2),!
		}
	}else{
		write result ,!
	}

	Q ""
}

}
