/// desc:	医生站公共 Excel 导入
Class DHCDoc.Common.ExcelImport Extends DHCDoc.Util.RegisteredObject
{

/// desc:	数据导入（校验 + 导入）
ClassMethod ImportDataToServer(excelRows, sessionStr, mClassName, mMethodName, mCheckBefore)
{
	s $zt = "ErrorHandle"
	// m ^Tempxkl("excelRows") = excelRows
	if ('..%IsValidMethod(mClassName, mMethodName)) {
		q "-1^后台数据导入方法未定义"
	}
	
	s ret = 0
	// 把校验抽离，判断校验方法是否存在
	if (mCheckBefore = "") {
		s mCheckBefore = "CheckBeforeImport"
	}
	s index = 0
	if (..%IsValidMethod(mClassName, mCheckBefore)) {
		for {
			s index = $o(excelRows(index))
			q:index=""
			s excelRow = excelRows(index)
			s mRet = $CLASSMETHOD(mClassName, mCheckBefore, excelRow, sessionStr)
			if (+mRet '= 0) {
				s ret = "-1^第"_index_"行数据错误："_$p(mRet, "^", 2)
				q
			}
		}
		if (+ret '= 0) {
			q ret
		}
	}
	s ret = 0
	ts
	s index = 0
	for {
		s index = $o(excelRows(index))
		q:index=""
		s excelRow = excelRows(index)
		s mRet = $CLASSMETHOD(mClassName, mMethodName, excelRow, sessionStr)
		if (+mRet '= 0) {
			s ret = "-1^第"_index_"行数据导入错误："_$p(mRet, "^", 2)
			q
		}
	}
	if (+ret '= 0) {
		tro
	} else {
		tc
	}
	q ret
	
ErrorHandle
	s $zt = ""
	if ($tl > 0) {
		tro
	}
	q "-1^第"_index_"行时，程序执行异常："_$ze
}

/// desc:	导入模板的 Query 是否存在
ClassMethod IsValidQueryTemplate(mClassName As %String = "", mMethodNameTemplate As %String = "")
{
	q ..%IsValidQuery(mClassName, mMethodNameTemplate)
}

}
