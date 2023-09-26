/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 绩效单元权限设置表维护
Class dhc.qm.udata.uCheckCoefficient Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 查询符合条件的绩效单元权限设置记录
/// Table：dhc_qm_data.CheckCoefficient
/// Input：start-起始行;limit-行数;checkDr-检查点
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).List(0,2)
ClassMethod List(start, limit, schemdr, checkDr) As %String
{
  n (start,limit,schemdr,checkDr)
  s sqlStr = "SELECT CheckCoefficient_rowid, CheckCoefficient_CheckDr,CheckCoefficient_CheckDr->Check_name as checkName, CheckCoefficient_Coefficient "
			_", CheckCoefficient_SchemDr,CheckCoefficient_SchemDr->QMSchem_name as schemName "
			_"FROM dhc_qm_data.CheckCoefficient where %ID>0 "
  if checkDr'=""  s sqlStr=sqlStr_"and CheckCoefficient_CheckDr="_checkDr
   if schemdr'=""  s sqlStr=sqlStr_" and CheckCoefficient_SchemDr="_schemdr
  ;s sqlStr=sqlStr_" order by CheckCoefficient_CheckDr"
  s resultSql =##class(%Library.ResultSet).%New()
  d resultSql.Prepare(sqlStr)
  d resultSql.Execute()
  s count=0
  ;s ^chuSql=sqlStr
  
  s json=##class(dhc.pa.comm.JsonObj).%New()
  s jsonTitle="rowid^schemDr^schemName^checkDr^checkName^coefficient^formula^formulaCode"
  s end=start+limit-1
  while(resultSql.Next()){
	  s rowid=resultSql.Data("CheckCoefficient_rowid")
	  s schemDr=resultSql.Data("CheckCoefficient_SchemDr")
	  s schemName=resultSql.Data("schemName")
	  s checkDr=resultSql.Data("CheckCoefficient_CheckDr")
	  s checkName=resultSql.Data("checkName")
	  s coefficientStr=resultSql.Data("CheckCoefficient_Coefficient")
	  s formula=""
	  s formulaCode=$p(coefficientStr,"#",1)
	  if (formulaCode="between"){
		  ;between#"20 " and " 30"
		  s coefficient=$REPLACE($EXTRACT($p(coefficientStr,"#",2),2,*-1),$CHAR(34)_" and "_$CHAR(34)," ~ ")
		  
		 s formula="区间"
	  }elseif (formulaCode="like"){
	  	 s coefficient=$EXTRACT($p(coefficientStr,"#",2),3,*-2)
	  	 s formula="包含"
	  }else{
	  	 s coefficient=$EXTRACT($p(coefficientStr,"#",2),2,*-1)
	  	 s formula=formulaCode
	  }
	  
	 
	  s temp=rowid_"^"_schemDr_"^"_schemName_"^"_checkDr_"^"_checkName_"^"_coefficient_"^"_formula_"^"_formulaCode
	  i (count>=start)&(count<=end) d
	  .d json.InsertRowData(temp)
	  s count=count+1
 }
 d resultSql.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 添加
/// Table：dhc_qm_data.CheckCoefficient
/// Input：data(表单数据)
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).Insert("55^=^否")
ClassMethod Insert(dataStr) As %String
{
  n (dataStr)
  
  s result=""
  ;1^>^额  checkDr^公式^特殊值
  s schemDr = $p(dataStr,"^",1)
  s checkDr = $p(dataStr,"^",2)
  s ifAddCheck=..ifAddCheck(schemDr,checkDr,"")
  if (ifAddCheck="") {
	  s formula=$p(dataStr,"^",3)
	  if (formula="between"){
		  ; checkDr^between^特殊值 and 特殊值2
	  	 s coefficient=formula_"#"_$CHAR(34)_$p($p(dataStr,"^",4),"and",1)_$CHAR(34)_" and "_$CHAR(34)_$p($p(dataStr,"^",4),"and",2)_$CHAR(34)
	  }elseif (formula="like"){
	  	 s coefficient=formula_"#"_$CHAR(34)_"%"_$p(dataStr,"^",4)_"%"_$CHAR(34)
	  }else{
	  	 s coefficient=formula_"#"_$CHAR(34)_$p(dataStr,"^",4)_$CHAR(34)
	  }
	

	  &sql(INSERT INTO dhc_qm_data.CheckCoefficient (CheckCoefficient_CheckDr, CheckCoefficient_Coefficient,CheckCoefficient_SchemDr)
		VALUES (:checkDr,:coefficient,:schemDr))
	  if (SQLCODE=0){
	     s result=0
	  }else{
	  	 s result=SQLCODE
	  }
  }else{
  	s result="hasCheck"
  
  }
 q result
}

/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 修改
/// Table：dhc_qm_data.CheckCoefficient
/// Input：data(表单数据)
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).Update("1^区间^23and56^31")
ClassMethod Update(dataStr) As %String
{
  n (dataStr)
  
  s result=""
  ;1^>^额  checkDr^公式^特殊值^rowid
   s schemDr = $p(dataStr,"^",1)
  s checkDr = $p(dataStr,"^",2)
   s rowid=$p(dataStr,"^",5)
  s ifAddCheck=..ifAddCheck(schemDr,checkDr,rowid)
  if (ifAddCheck="") {
 
	  s formula=$p(dataStr,"^",3)
	  if (formula="between"){
		  ; checkDr^between^特殊值 and 特殊值2
	  	 s coefficient=formula_"#"_$CHAR(34)_$p($p(dataStr,"^",4),"and",1)_$CHAR(34)_" and "_$CHAR(34)_$p($p(dataStr,"^",4),"and",2)_$CHAR(34)
	  }elseif (formula="like"){
	  	 s coefficient=formula_"#"_$CHAR(34)_"%"_$p(dataStr,"^",4)_"%"_$CHAR(34)
	  }else{
	  	 s coefficient=formula_"#"_$CHAR(34)_$p(dataStr,"^",4)_$CHAR(34)
	  }
 
	 
	  &sql(UPDATE dhc_qm_data.CheckCoefficient
			SET CheckCoefficient_CheckDr = :checkDr
				, CheckCoefficient_Coefficient = :coefficient
				,CheckCoefficient_SchemDr=:schemDr
			WHERE CheckCoefficient_rowid = :rowid)
	  if (SQLCODE=0){
	     s result=0
	  }else{
	  	 s result=SQLCODE
	  }
  } else{
  	s result="hasCheck"
  
  } 
 q result
}

/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 删除
/// Table：dhc_qm_data.CheckCoefficient
/// Input：rowid
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).Delete()
ClassMethod Delete(rowid) As %String
{
  n (rowid)
  
  s result=""
 
  &sql(delete from dhc_qm_data.CheckCoefficient where %ID=:rowid)
  if (SQLCODE=0){
     s result=0
  }else{
  	 s result=SQLCODE
  }
 q result
}

/// Creator: 初雅莉
/// CreatDate: 2016-02-25
/// Description: 检查点
/// Table：dhc_qm_data.CheckInfo
/// Input：str-模糊查询，start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).CheckList("",0,10)
ClassMethod CheckList(str, start, limit)
{
  n (str,start,limit)
  s sqlStr="SELECT Check_rowid, Check_code, Check_name "
			_"FROM dhc_qm_data.CheckInfo "
			_"WHERE Check_active = 'Y'"
  if str'=""  s sqlStr=sqlStr_" and Check_name like '%"_str_"%'"
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(sqlStr)
  d result.Execute()
  ;s ^chuStr=sqlStr
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.pa.comm.JsonObj).%New()
  s jsonTitle="rowid^code^name"
  While(result.Next())
  {
	s rowid= result.Data("Check_rowid")
	s code= result.Data("Check_code")
	s name= result.Data("Check_name")
	


	s temp=rowid_"^"_code_"^"_name
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator: 初雅莉
/// CreatDate: 2016-07-01
/// Description: 检查点
/// Table：dhc_qm_data.CheckInfo
/// Input：str-模糊查询，start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).ifAddCheck("")
ClassMethod ifAddCheck(schemDr, checkDr, rowid)
{
  n (schemDr,checkDr,rowid)
  s checkRowid=""
  &sql(SELECT CheckCoefficient_rowid into:checkRowid
		FROM dhc_qm_data.CheckCoefficient
		WHERE CheckCoefficient_CheckDr =:checkDr and CheckCoefficient_SchemDr=:schemDr)
 
  if (rowid'=""){
   if (rowid=checkRowid) s checkRowid=""
  }
  q checkRowid
}

/// Creator: 初雅莉
/// CreatDate: 2016-08-23
/// Description: 添加检查点时，不显示已经添加的
/// Table：
/// Input：str-模糊查询，start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.qm.udata.uCheckCoefficient).ListCheck("")
ClassMethod ListCheck(start, limit, str, schemdr) As %String
{
	n (start, limit, str,schemdr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT QMSchemDetail_CheckDr AS checkDr,QMSchemDetail_CheckDr->Check_name AS checkName FROM dhc_qm_data.QMSchemDetail  "  //2016-8-23 cyl edit
			_" WHERE QMSchemDetail_parRef='"_schemdr_"' "
			_" AND QMSchemDetail_CheckDr NOT IN ( "
			_" SELECT CheckCoefficient_CheckDr FROM dhc_qm_data.CheckCoefficient "
			_" WHERE CheckCoefficient_SchemDr='"_schemdr_"')"
	i str'="" s sqlStr = sqlStr_" and QMSchemDetail_CheckDr->Check_name LIKE '%"_str_"%'"
	s ^TEMPchu= sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("checkDr")
		s name = result.Data("checkName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: 初雅莉
/// CreatDate: 2016-08-23
/// Description: 显示所有的检查项，pad端和pc端的
/// Table：
/// Input：str-模糊查询，start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uCheckCoefficient).ListschemDr("1","10","",3901)
ClassMethod ListschemDr(start, limit, str, userid) As %String
{
	n (start, limit, str,userid)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem WHERE  QMSchem_active='Y' "
	i str'="" s sqlStr = sqlStr_" and QMSchem_name LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("QMSchem_RowID")
		s name = result.Data("QMSchem_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uCheckCoeff5039S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
