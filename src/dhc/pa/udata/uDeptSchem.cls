Class dhc.pa.udata.uDeptSchem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others:w ##class(dhc.pa.udata.uDeptSchem).IfRepCode("001")
/// Description: 插入一条新数据
/// Table：dhc_pa_data.DeptSchem
/// Others：w ##class(dhc.pa.udata.uDeptSchem).InsertRec("002","科室运行病历自查","1","1","11")
ClassMethod InsertRec(code, name, shortcut, frequency, desc) As %String
{
	
	n (code, name,shortcut,frequency,desc)
	
	s rowid=0	
	s returnStr=""
	s isStr=..isCodeName("",code,name)
	if (isStr="") d
	.&sql(insert into dhc_pa_data.DeptSchem(DSC_code,DSC_name,DSC_shortcut,DSC_frequency,DSC_desc,DSC_isStop) values(:code,:name,:shortcut,:frequency,:desc,'N'))
	.s returnStr=SQLCODE
	e  d
	. s returnStr= isStr
	q returnStr
}

/// Description: 删除记录
/// Table：dhc_pa_data.DeptSchem
/// Others: w ##class(dhc.pa.udata.uDeptSchem).Delete("12")
ClassMethod Delete(rowid) As %String
{
	n (rowid)	
	&sql(delete  dhc_pa_data.DeptSchem  where DSC_rowid=:rowid)
	
	q SQLCODE
}

// 更新

/// Others：w ##class(dhc.pa.udata.uDeptSchem).Update("4","1","4","","","")
ClassMethod Update(rowid, code, name, shortcut, frequency, desc, isStop) As %String
{
	n (rowid, code, name,shortcut,frequency,desc,isStop)
	k PLIST
	s returnStr=""
	s isStr=..isCodeName(rowid, code, name)
	if (isStr=""){
		i code'="" s Plist(2)= code
		i name'="" s Plist(3)= name   
		i shortcut'="" s Plist(4)= shortcut 
		i frequency'="" s Plist(5)= frequency 
		i desc'="" s Plist(6)=desc 
		&SQL(UPDATE  dhc_pa_data.DeptSchem set  DSC_isStop =:isStop WHERE DSC_rowid =:rowid) 
		&SQL(UPDATE  dhc_pa_data.DeptSchem VALUES Plist()  where %ID=:rowid) 
		s returnStr=SQLCODE
	}else{
		s returnStr= isStr
	}
	q returnStr
}

/// 查找
/// others:w ##class(dhc.pa.udata.uDeptSchem).List("","",0,15)
ClassMethod List(sortField, sortDir, start, limit) As %String
{
	n (sortField,sortDir,start,limit)
	s sqlStr="select DSC_rowid,DSC_code,DSC_name,DSC_shortcut,DSC_frequency,DSC_desc from dhc_pa_data.DeptSchem where %ID>0"
		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^shortcut^frequency^desc"
	While(result.Next())
	{   
		s rowid=result.Data("DSC_rowid")
		s code=result.Data("DSC_code")
		s name=result.Data("DSC_name")
		s shortcut=result.Data("DSC_shortcut")
		s frequency=result.Data("DSC_frequency")
		s desc=result.Data("DSC_desc")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_frequency_"^"_desc
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:初雅莉
/// CreatDate:2016-7-11 
/// Description: 判编码和名称是否重复
/// Table：dhc_pa_data.DeptSchem
/// Others：w ##class(dhc.pa.udata.uDeptSchem).isCodeName("4","2w","2")
ClassMethod isCodeName(rowid, code, name) As %String
{
	n (rowid,code,name)
	s resultStr=""
	if rowid="" d
	.i code'=""  d
	..&sql(SELECT DSC_rowid into:isRowId FROM dhc_pa_data.DeptSchem WHERE DSC_code =:code)
	..i isRowId'="" s resultStr=resultStr_"^"_"isCode"
	..s isRowId=""
	.i name'="" d
	..&sql(SELECT DSC_rowid into:isRowId FROM dhc_pa_data.DeptSchem WHERE DSC_name =:name)
	..i isRowId'="" s resultStr=resultStr_"^"_"isName"
	e  d
	.i code'=""  d
	..&sql(SELECT DSC_rowid into:isRowId FROM dhc_pa_data.DeptSchem WHERE DSC_code =:code)
	..i (isRowId'=rowid)&&(isRowId'="") s resultStr=resultStr_"^"_"isCode"
	..s isRowId=""
	.i name'="" d
	..&sql(SELECT DSC_rowid into:isRowId FROM dhc_pa_data.DeptSchem WHERE DSC_name =:name)
	..i (isRowId'=rowid)&&(isRowId'="")  s resultStr=resultStr_"^"_"isName"
	
	q resultStr
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDeptSchemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
