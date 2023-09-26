Class dhc.qm.udata.uDeptProject Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 查询符合条件的记录
/// Table: dhc.qm.udata.uDeptProject
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uDeptProject).List("","",0,15)
ClassMethod List(sortField, sortDir, start, limit) As %String
{
	n (sortField,sortDir,start,limit)
	s sqlStr="select QMSchem_RowID,QMSchem_Code,QMSchem_name,QMSchem_desc,QMSchem_shortcut,QMSchem_active,QMSchem_Arcitem,QMSchem_periodType from dhc_qm_data.QMSchem where  QMSchem_active='Y'   "
	
	
    
    ;w sqlStr!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="Rowid^QMSchemCode^QMSchemname^QMSchemArcitem"
	While(result.Next())
	{   
		s Rowid= result.Data("QMSchem_RowID")
		s QMSchemCode= result.Data("QMSchem_Code")
		s QMSchemname= result.Data("QMSchem_name")
		s arc= result.Data("QMSchem_Arcitem")
		s QMSchemArcitem=..Listarcname(arc)
		;W arc,!
	//s IsValid= result.Data("org_affi_IsValid")
		 s tmp=Rowid_"^"_QMSchemCode_"^"_QMSchemname_"^"_QMSchemArcitem
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 查询符合条件的记录
/// Table: dhc.qm.udata.uDeptProject
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uDeptProject).Listto("","","","",0,15,1)
ClassMethod Listto(searchField, searchValue, sortField, sortDir, start, limit, Code) As %String
{
	n (searchField,searchValue,sortField,sortDir,start,limit,Code)
	s sqlStr="select QMLocSchem_rowid,QMLocSchem_QMSchemDr->QMSchem_Code as code,QMLocSchem_DepartDr->DEP_Desc as name,QMLocSchem_DepartDr->DEP_Code as deptCode from dhc_qm_data.QMLocSchem  where %ID>0"
	i Code'="" s sqlStr=sqlStr_"AND QMLocSchem_QMSchemDr='"_Code_"'" 
	s sortStr="ORDER BY QMLocSchem_rowid ASC "
	
	s sqlStr=sqlStr_sortStr
    
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="RowId^Code^name^deptCode"
	While(result.Next())
	{   
		s RowId= result.Data("QMLocSchem_rowid")
		s Code= result.Data("code")
		s name= result.Data("name")
		s deptCode = result.Data("deptCode")
		
		s tmp=RowId_"^"_Code_"^"_name_"^"_deptCode
		i searchValue'="" d
		.q:(searchField="Code")&(deptCode'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.s count=count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		e  d
		.s count=count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.qm.udata.uDeptProject).nameList("","",0,25)
ClassMethod nameList(sortField, sortDir, start, limit) As %String
{
	n (sortField, sortDir, start, limit)	
		
	s sqlStr="select DEP_RowId,DEP_Desc from RBC_DepartmentGroup where %ID>'0'"
			 
			 
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="groupRowid^groupName" 
	while(result.Next())
	{
		s groupRowid=result.Data("DEP_RowId")
		s groupName=result.Data("DEP_Desc")	
		s tem=groupRowid_"^"_groupName
		i (count>=start)&(count<=limit) d
		.d json.InsertRowData(tem)
		s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2010-11-25
/// Description:删除记录
/// Table:dhc_qm_data.QMLocSchem
/// Input:rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.qm.udata.uDeptProject).Delete(32)
ClassMethod Delete(RowId) As %String
{
	n (RowId)
	
	&SQL(delete from dhc_qm_data.QMLocSchem where QMLocSchem_rowid=:RowId)
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate: 2015-6-12
/// Description: 添加功能
/// Table： dhc.qm.udata.uDeptProject
/// Input: 
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.qm.udata.uDeptProject).Add("1^1")
ClassMethod Add(data) As %String
{
   n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s name=$p(data,"^",1)
		s Code=$p(data,"^",2)
		s SQLCODE=0
        s len=$l(name,",")
        s i=1
        TSTART
        f i=i:1:len   d
		.s rowid=0
		.s QMSchem=$P(name,",",i)
		.;w "QMSchem-> "_QMSchem_"   DepartId->"_DepartId,!
		.s rowid=..IfRepRecode(QMSchem,Code)
		.i rowid>0  d
		..s SQLCODE="RepRecode"
		.e  d
		..i QMSchem'="" s PLIST(2)=QMSchem
		..i Code'="" s PLIST(3)=Code
		..&sql(INSERT INTO dhc_qm_data.QMLocSchem VALUES PLIST())
		i SQLCODE'=0  TROLLBACK
		e  TCOMMIT
		q SQLCODE
}

/// Creator：黄凤杰
/// CreatDate：
/// Description: 判断是否存在同一记录
/// Table：
/// Input：
/// Output：
/// Return：返回RowId
/// Others：w ##class(dhc.qm.udata.uDeptProject).IfRepRecode(1,1)
ClassMethod IfRepRecode(name, Code) As %String
{
	n (name,Code)
	
	s RowId=0
	s RowId=$O(^DHCCJXQMQMLocSchemI("QMschemDrDepartDr",name,Code,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// others: w ##class(dhc.qm.udata.uDeptProject).Listarcname("26610||1,26627||1")
ClassMethod Listarcname(arc) As %String
{
 
	n (arc)
	
	s arc=..MyArray(arc)
	s sqlStr = "SELECT %id,arcim_desc FROM arc_itmmast WHERE %id IN ("_arc_")"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()

	s resultString="" 

	while(result.Next())
	{
		s resultString=resultString_","_result.Data("ARCIM_Desc")

	}

	q $E(resultString,2,$L(resultString))
}

/// others:w ##class(dhc.qm.udata.uDeptProject).MyArray("1||4,1||6,1||7")
ClassMethod MyArray(s) As %String
{
	n (s)
	s len=$L(s,",")
	s resultString=""
	for i=1:1:len{
		i resultString="" {
		s resultString=resultString_"'"_$p(s,",",i)_"'"}else{
		s resultString=resultString_",'"_$p(s,",",i)_"'"	
			}
		}
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uDeptProjectS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
