Class dhc.bonus.umodule.Funcmaintain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘壮
/// CreatDate: 2016-09-06
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.data.BonusCalcFunction
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;funcnameLS-函数名查询字段;funccodeLS-函数标识查询字段;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.umodule.Funcmaintain).ListRec("","","","","","","",0,4)
ClassMethod ListRec(funcnameLS, funccodeLS, active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (funcnameLS, funccodeLS, active, searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT BankAccountID,FunCode,FunName,FunDesc,FunClass,ParaDesc,CreatDate" 
                 _" FROM dhc_bonus_data.BonusCalcFunction where IsValid=1"
				 
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BankAccountID"
		.i sortField="funcode" s sortField1="FunCode"
		.i sortField="funname"  s sortField1="FunName"
		.i sortField="fundesc" s searchField1="FunDesc"
		.i sortField="funclass"  s sortField1="FunClass"
		.i sortField="paradesc" s searchField1="ParaDesc"
		.i sortField="creattdate" s searchField1="CreatDate"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		;e  d
		.;s sortStr=" ORDER BY %ID DESC"
		
		i funcnameLS'="" d
		.s sqlStr=sqlStr_" and FunName like %'"_funcnameLS_"%'"
		i funccodeLS'="" d
		.s sqlStr=sqlStr_" and FunCode='"_funccodeLS_"'"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^funcode^funname^fundesc^funclass^paradesc^creattdate"
		
		While(result.Next())
		{
			s rowid=result.Data("BankAccountID")
			s funcode=result.Data("FunCode")
			s funname=result.Data("FunName")
			s fundesc=result.Data("FunDesc")
			s funclass=result.Data("FunClass")
			s paradesc=result.Data("ParaDesc")
			s creattdate=result.Data("CreatDate")
		
			s tmp=rowid_"^"_funcode_"^"_funname_"^"_fundesc_"^"_funclass_"^"_paradesc_"^"_creattdate
			s count=count+1
			;w auditdate,!
			i searchValue'="" d
			.q:(searchField="funcode")&(funcode'[searchValue)
			.q:(searchField="funname")&(funname'[searchValue)
			.q:(searchField="fundesc")&(fundesc'[searchValue)
			.q:(searchField="funclass")&(funclass'[searchValue)
			.q:(searchField="paradesc")&(paradesc'[searchValue)
			.q:(searchField="creattdate")&(creattdate'[searchValue)
			
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: 刘壮
/// CreatDate: 2016-09-06
/// Description: 插入
/// Table: dhc.bonus.data.BonusCalcFunction
/// Input: data-待插入的数据(bonustarget^workitem^auditdate)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.umodule.Funcmaintain).InsertRec(1,5,2015-02-02)
ClassMethod InsertRec(funcode, funname, fundesc, funclass, paradesc) As %String
{
		n (funcode, funname,fundesc,funclass,paradesc)
		
		;s auditdate = $zdh(auditdate,3)
	
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		&sql(INSERT INTO  dhc_bonus_data.BonusCalcFunction(FunCode,FunName,FunDesc,FunClass,ParaDesc,IsValid,CreatDate) 
		values (:funcode,:funname,:fundesc,:funclass,:paradesc,1,:UpdateDate))


		q SQLCODE
}

/// Creator: 刘壮
/// CreatDate: 2016-09-06
/// Description: 更新记录
/// Table: dhc_bonus_data.BonusCalcFunction
/// Input: rowid-数据行号;data-待插入的数据(bonustarget^workitem^auditdate);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.bonus.umodule.Funcmaintain).UpdateRec(1,3,3,2015-02-02)
ClassMethod UpdateRec(rowid, funcode, funname, fundesc, funclass, paradesc) As %String
{
		n (rowid,funcode,funname,fundesc,funclass,paradesc)
		
		i funcode = ""    s funcode=$list(^dhcbsCalcFunctionD(rowid),2)
		i funname = ""       s funname = $list(^dhcbsCalcFunctionD(rowid),3)
		i fundesc= ""       s fundesc = $list(^dhcbsCalcFunctionD(rowid),4)
		i funclass = ""       s funclass = $list(^dhcbsCalcFunctionD(rowid),5)
		i paradesc= ""       s paradesc = $list(^dhcbsCalcFunctionD(rowid),6)
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
			
		&SQL(UPDATE dhc_bonus_data.BonusCalcFunction(FunCode,FunName,FunDesc,FunClass,ParaDesc,CreatDate) values (:funcode,:funname,:fundesc,:funclass,:paradesc,:UpdateDate) where %ID=:rowid)
		q SQLCODE
}

/// Creator: 刘壮
/// CreatDate: 2016-09-06
/// Description:删除数据
/// Table:dhc_bonus_data.BonusCalcFunction
/// Input:rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.Funcmaintain).Delete(3)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(UPDATE dhc_bonus_data.BonusCalcFunction set IsValid=0 where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.umo866B.FuncmaintainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
