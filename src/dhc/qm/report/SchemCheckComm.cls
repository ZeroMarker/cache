/// 判断检查项检查点不合格公用方法
/// 初雅莉
/// 2016-03-02
Class dhc.qm.report.SchemCheckComm Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:  初雅莉  
/// CreateDate:  2016-03-02
/// Description: 根据检查项目rowid获得检查项目的dataType(用来判断该检查项目是否有不合格记录的方式）
/// 				：1显示该检查项目所有的数据；2当检查点中有一个为N或者为否，则不合格；3在特殊值表中取检查点为特殊值，则为不合格)
/// Table:   dhc_qm_data.QMSchem
/// Input:   schemId(检查项目code)
/// Return:  dataType
/// Others:  w ##class(dhc.qm.report.SchemCheckComm).GetSchemDataType("16")	
ClassMethod GetSchemDataType(schemId As %String) As %String
{
	
	s dataType=0
	&sql(SELECT QMSchem_dataType into:dataType FROM dhc_qm_data.QMSchem WHERE QMSchem_code =:schemId)
	q dataType
}

/// Creator:     初雅莉
/// CreateDate:  2015-12-17
/// Description: 判断该病人,科室是否有不合格的检查点（当patdr为空则为科室检查项）
/// Table:      dhc_qm_data.LocResultdetail lrd , dhc_qm_data.LocResultMain lrm  
/// Input:      patdr（病人id），period（考核期间），snameID（检查项目ID）、科室id，dataType
/// Return:     num
/// Others:  w ##class(dhc.qm.report.SchemCheckComm).getDocQmCount("40,""201502","1")
ClassMethod getDocQmCount(patdr, period, schemDr, depDr, dataType) As %String
{

	s num=0
	set sqlStr2="SELECT DISTINCT lrd.LocResultdetail_checkDr as checkId "
				_"FROM dhc_qm_data.LocResultMain lrm,dhc_qm_data.Locresultdetail lrd "
			_"WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
			_" AND lrm.LocResultMain_schemDr="_schemDr_" "
		   _" and lrd.LocResultdetail_parRef->LocResultMain_period='"_period_"' "
 		  
  	i patdr'=""  s sqlStr2=sqlStr2 _" AND lrd.LocResultdetail_JXPatDr="_patdr_" "
    i depDr'=""  s sqlStr2=sqlStr2 _" AND lrm.LocResultMain_departDr ="_depDr_" "  
    
  	s resultSql=##class(%Library.ResultSet).%New()
	d resultSql.Prepare(sqlStr2)
	d resultSql.Execute()
	s fieldStr=..getFieldStrOrCount(resultSql,"checkId",sqlStr2,dataType)
	s count3=$p(fieldStr,"^",1)
	
	q count3
}

/// Creator:     初雅莉
/// CreateDate:  2016-03-07
/// Description: 方法说明及使用：
/// 				该方法是根据检查项目表中dataType字段的值，来进行检查项目不合格记录的判断处理，
/// 				因考虑到以后dataType值可能增加或者修改，所有将datatype判断的处理提取成一个方法。
/// 				使用方法：1、需要传入一个sql的result，用来获取这个result中的检查点的id
/// 						  2、传入result中检查点字段的名称 s checkId=resultSQL.Data(checkDes) 
/// 						  3、传入要执行的sql ：当sqlStr为空时，则值返回拼接的过滤条件fieldSql
/// 											   当sqlStr不为空时，返回不合格例数^过滤条件fieldSql  
/// Input:      resultStr（sql执行的result），checkDes（检查点的字段名），sqlStr（要拼接过滤条件的sql），dataType（检查项目的类型）
/// 				useParamStr=period_"^"_type_"^"_schemId_"^"_deptId
/// Return:     count^过滤条件的sql
/// Others: w ##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount("40,""201502","1")
ClassMethod getFieldStrOrCount(resultSQL, checkDes, sqlStr, dataType, useParamStr) As %String
{
		;stDate_"^"_endDate_"^"_frequency_"^"_schemDr_"^"_locdr
		s stDate=$p(useParamStr,"^",1)
		s endDate=$p(useParamStr,"^",2)
		s type=$p(useParamStr,"^",3)
	 	s schemCode=$p(useParamStr,"^",4)
	 	;s deptId=$p(useParamStr,"^",5)
	if (dataType=3){ //特殊值得
	/*	d specialCheck
		s unQNum=0
		if (count2'=0){
			set filedSql =$EXTRACT(filedSql,1,*-3)
			set filedSql=filedSql_")"
		}else{
			set filedSql=sqlStr
		}*/
		if (schemCode="0060404"){ //合理用血，描述不为空的为不合格记录 2016-07-18 add
			s filedSql=sqlStr_"  and LocResultdetail_checkDr->Check_code='060' and lrd.LocResultdetail_actValue is not NULL and lrd.LocResultdetail_actValue!=''"
		}else{
			d specialCheck
			s unQNum=0
			if (count2'=0){
				set filedSql =$EXTRACT(filedSql,1,*-3)
				set filedSql=filedSql_")"
				//set filedSql=sqlStr_filedSql
			}else{
				set filedSql=sqlStr
			}

		}
	}elseif (dataType=2){
		s filedSql=sqlStr_" and (lrd.LocResultdetail_actValue='N' or lrd.LocResultdetail_actValue='否')"
	}elseif (dataType=1){
		s filedSql=sqlStr
	}else{
		if (schemCode="0060301"){
			d specialCheck
			s unQNum=0
			if (count2'=0){
		
				set filedSql =$EXTRACT(filedSql,1,*-3)
				s filedSql=filedSql_" or (lrd.LocResultdetail_actValue='N' or lrd.LocResultdetail_actValue='否')" 
				set filedSql=filedSql_")"
			}else{
				set filedSql=sqlStr
			}
		}elseif(schemCode="0060302"){
			//死亡病例不合格判断：1、检查点为N或否；2、“本季度讨论数”=0;3、“本季度讨论数<>死亡数量”
			/*思路：
				1、获得讨论数和死亡数量
				2、比较大小，如果不相等，则在sql中加入过滤条件
			*/
		
			&sql(DECLARE DetailCursor CURSOR FOR 
		  		select DISTINCT lrd.LocResultdetail_parRef,lrd.LocResultdetail_JXPatDr,lrd.LocResultdetail_checkDr,lrd.LocResultdetail_checkDr->Check_name,lrd.LocResultdetail_actValue
					into:parRef,:jxpatDr,:checkDr,:checkName,:actValue
					FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail lrd
					WHERE lm.LocResultMain_rowid=lrd.LocResultdetail_parRef  
					and LocResultMain_period between :stDate  and :endDate
					and LocResultMain_schemDr->QMSchem_periodType =:type  
					and LocResultMain_schemDr->QMSchem_code =:schemCode 
					AND lrd.LocResultdetail_checkDr=16 OR LocResultdetail_checkDr=17
					ORDER BY lrd.LocResultdetail_parRef,lrd.LocResultdetail_JXPatDr
				 )
	  		 &sql(OPEN DetailCursor)
		  	 FOR {
			  	&sql(FETCH DetailCursor)
		        QUIT:SQLCODE  
				s ^checkFiledTemp(parRef,jxpatDr,checkDr)=actValue
			 }
	  		 &sql(CLOSE DetailCursor)		
			
			s parRef=""
			for  s parRef=$o(^checkFiledTemp(parRef))  q:parRef=""  do
			.s jxpatDr=""
			.for  s jxpatDr=$o(^checkFiledTemp(parRef,jxpatDr)) q:jxpatDr=""  do
			..s check16=$g(^checkFiledTemp(parRef,jxpatDr,16))
			..s check17=$g(^checkFiledTemp(parRef,jxpatDr,17))
			..if check16'=check17 do
			...s str=" or (lrd.LocResultdetail_checkDr=16 and( lrd.LocResultdetail_actValue ="_check16_" )) "
			...	s str=str_" or (lrd.LocResultdetail_checkDr=17 and( lrd.LocResultdetail_actValue ="_check17_" )) "
			
			k ^checkFiledTemp
			d specialCheck //特殊值
			s unQNum=0
			if (count2'=0){
		
				set filedSql =$EXTRACT(filedSql,1,*-3)
				s filedSql=filedSql_" or (lrd.LocResultdetail_actValue='N' or lrd.LocResultdetail_actValue='否') " 
				set filedSql=filedSql_str_")"
			}else{
				set filedSql=sqlStr
			}
		}else{
			s filedSql=sqlStr_" and (lrd.LocResultdetail_actValue='N' or lrd.LocResultdetail_actValue='否')"
		}
	}
	
	
	if (sqlStr'=""){
		s resultSql2=##class(%Library.ResultSet).%New()
		d resultSql2.Prepare(filedSql)
		d resultSql2.Execute()
		
		s count3=0	
		while(resultSql2.Next()){
			s count3=count3+1
		}
	}else{
		s count3=""
	}

	q count3_"^"_filedSql
	
specialCheck
	s filedSql=sqlStr_" and( "
		
	s count2=0	
	while(resultSQL.Next()){
		s checkId=resultSQL.Data(checkDes) 
		s checkchecked = ..GetUnqualifiedField(checkId)
		if (checkchecked'="") {
			
			set filedSql=filedSql_checkchecked_"or "
			s count2=count2+1
		}
	}
}

/// Creator:     初雅莉
/// CreateDate:  2015-12-10
/// Description: 医师不合格病例数的查询条件
///             特殊检查点，特定值为不合格的条件拼接
/// Table:       
/// Input:     deptdr(科室rowid),schemRowid（检查项目rowid）,docCode（医生编码）,frequency（期间频次：Q,M）,stDate（开始时间）,endDate（结束时间）  
/// Return:     unQNum（指定医师不合格病例数）
/// Others:  w ##class(dhc.qm.report.SchemCheckComm).GetUnqualifiedField("62")
ClassMethod GetUnqualifiedField(checkId As %String) As %String
{
	
	set fileStr=" (lrd.LocResultdetail_checkDr="_checkId_" and("
	set checkStr="SELECT CheckCoefficient_rowid, CheckCoefficient_CheckDr, CheckCoefficient_Coefficient as coefficient "
					_"FROM dhc_qm_data.CheckCoefficient "
					_"WHERE CheckCoefficient_CheckDr ="_checkId
			
	
	
	s resultcheckStr=##class(%Library.ResultSet).%New()
	d resultcheckStr.Prepare(checkStr)
	d resultcheckStr.Execute()	
	s count=0
    While(resultcheckStr.Next()){
		s coefficientOld=resultcheckStr.Data("coefficient") 
		//2016-02-29 替换字段中的#号为空格  between#"56.02" and "30"
		s formula=$p(coefficientOld,"#",1)
		
		s coefficient = $Replace($p(coefficientOld,"#",2),$CHAR(34),"")
		if (formula'="between"){
			s isNum = $ISVALIDNUM(coefficient) //如果为数字，返回1，否则返回0
		}else{
			s isNum=1
		}
		if (isNum=1){
			if (count=0) do
			.s fileStr=fileStr_" lrd.LocResultdetail_actValue "_formula_" "_coefficient_" "
			else  do
			.s fileStr=fileStr_" or lrd.LocResultdetail_actValue "_formula_" "_coefficient_" "
		}else{
			if (count=0) do
			.s fileStr=fileStr_" lrd.LocResultdetail_actValue "_formula_" '"_coefficient_"' "
			else  do
			.s fileStr=fileStr_" or lrd.LocResultdetail_actValue "_formula_" '"_coefficient_"' "
		}
		
		
		;s coefficient = $Replace(coefficientOld,"#"," ")
		
		s count=count+1
	}
	if (count=0) {
		s fileStr=""
	}else{
		s fileStr=fileStr_")) "
	}
	
	d resultcheckStr.Close()

	q fileStr
}

Storage Default
{
<StreamLocation>^dhc.qm.report.SchemCheckCommS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
