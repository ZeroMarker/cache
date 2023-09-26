Class dhc.qm.udata.uPlan Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:     wang ying
/// CreateDate:  2015-7-31
/// Description: 根据考核期间、登录用户id、状态查询计划信息
/// Table:       dhc_qm_data.Plan
/// Input:       考核期间、登录用户id、状态
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPlan).GetPlanInfo("<Request><status>1</status><checkDr>3901</checkDr><period></period></Request>")
ClassMethod GetPlanInfo(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><period>201501</period><checkDr>1</checkDr><status>0</status></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s period=request.period
	   s checkDr=request.checkDr
	   s status=request.status
	}
	 s resultString=""
	 ;q:period="" "Noperiod"
	 q:checkDr="" "NocheckDr"
	 q:status="" "NoStatus"
	 
	 s resultString=##class(dhc.qm.udata.uPlanArrange).PlanListDetail("","",0,999999,"","",checkDr,status)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-8-3
/// Description: 根据考核期间、登录用户id、状态、计划id插入更新到计划表和科室方案主表
/// Table:       dhc_qm_data.Plan
/// Input:       考核期间、登录用户id、状态
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPlan).submit("<Request><planDr>15</planDr><period>201602</period><status>1</status><checkDr>1</checkDr></Request>")
ClassMethod submit(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><period>201501</period><checkDr>1</checkDr><status>0</status><planDr>1</planDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s period=request.period
	   s checkDr=request.checkDr
	   s status=request.status
	   s planDr=request.planDr
	}
	 s resultString=""
	 q:period="" "Noperiod"
	 q:checkDr="" "NocheckDr"
	 q:status="" "NoStatus"
	 q:planDr="" "NoplanDr"
	 
	 s SQLCODE=..Add(period,checkDr,status,planDr)
	 s SQLCODE=..updateQMSchem(period,checkDr,status,planDr)
	 s SQLCODE=..calPADScore(period,checkDr,status,planDr)
	 i SQLCODE = 0 d
	 .s resultString="{success:'true',info:''}"
	 e  d
	 .s resultString= "{success:'false',info:'"_SQLCODE_"'}"
	 q resultString
}

/// Creator: wang ying
/// CreatDate: 2015-8-3
/// Description: 添加功能
/// Table： dhc_qm_data.Plan
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).Add("201501","1","1","1")
ClassMethod Add(period, checkDr, status, planDr) As %String [ SqlProc ]
{
	n (period,checkDr,status,planDr)
	
	 q:period="" "Noperiod"
	 q:checkDr="" "NocheckDr"
	 q:status="" "NoStatus"
	 q:planDr="" "NoplanDr"
	
	&sql(update dhc_qm_data.Plan set Plan_Status=:status where Plan_rowid=:planDr)
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2015-8-3
/// Description: 修改科室方案表的状态
/// Table： dhc_qm_data.Plan
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).updateQMSchem("201501","1","1","1")
ClassMethod updateQMSchem(period, checkDr, status, planDr) As %String [ SqlProc ]
{
	n (period,checkDr,status,planDr)
	
	 q:period="" "Noperiod"
	 q:checkDr="" "NocheckDr"
	 q:status="" "NoStatus"
	 q:planDr="" "NoplanDr"
	
	s SQLCODE=0
	s date=$p($h,",",1)
	&sql(SELECT Plan_QMSchemDr, Plan_CheckDepart into :qmschemDr,:deptDr FROM dhc_qm_data.Plan where %ID=:planDr)
   
    s schemLen=$l(qmschemDr,",")
    s deptLen=$l(deptDr,",")
    f i=1:1:schemLen d
    .f j=1:1:deptLen d
    ..s qmschem=$p(qmschemDr,",",i)
    ..s dept=$p($p(deptDr,",",j),"||",2)
    ..&sql(update dhc_qm_data.LocResultMain set LocResultMain_auditDr=:checkDr,LocResultMain_auditDate=:date,LocResultMain_auditState=1
         where LocResultMain_schemDr=:qmschem and LocResultMain_departDr=:dept and LocResultMain_period=:period)
	..i SQLCODE'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("updateQMSchem",qmschem_"^"_dept_"^"_period,SQLCODE,"")
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2015-9-13
/// Description: 计算登录人提交的计划的考核结果
/// Table： dhc_qm_data.Plan
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPADScore("201503","3901","1","1")
ClassMethod calPADScore(period, checkDr, status, planDr) As %String [ SqlProc ]
{
	n (period,checkDr,status,planDr)
	
	 q:period="" "Noperiod"
	 q:checkDr="" "NocheckDr"
	 q:status="" "NoStatus"
	 q:planDr="" "NoplanDr"
	
	s SQLCODE=0
	s sqlStr="SELECT *,LocResultMain_schemDr->QMSchem_periodType,LocResultMain_schemDr->QMSchem_Code FROM dhc_qm_data.LocResultMain" 
	         _" WHERE LocResultMain_period='"_period_"'"
	         _" and LocResultMain_auditState=1"
	
	i planDr'="" s sqlStr=sqlStr_" AND LocResultMain_Plandr='"_planDr_"'"

    ;w sqlStr,!
    s sqlcode=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
		s MainID = result.Data("LocResultMain_rowid")
		s periodType = result.Data("QMSchem_periodType")
		s schemCode = result.Data("QMSchem_Code")
        s actValue=0
		s actValue=..calPADPatScore(period, periodType,MainID)
		;w "1="_MainID_"^"_actValue,!
		&sql(update dhc_qm_data.LocResultMain set LocResultMain_failNum=:actValue where %ID=:MainID)
		i ((schemCode="0060302")||(schemCode="0060301")||(schemCode="0060303")) d
		.s actValue=..calPADDeptScore(period, periodType,MainID)
		;w MainID_"^"_actValue,!
		&sql(update dhc_qm_data.LocResultMain set LocResultMain_failNum=:actValue where %ID=:MainID)
		
	}
	d result.Close()
	q sqlcode
}

/// Creator: wang ying
/// CreatDate: 2015-9-14
/// Description: 计算PC端的考核结果
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPCScore("201602","Q")
ClassMethod calPCScore(period, periodType) As %String [ SqlProc ]
{
	n (period,periodType)
	
	 q:period="" "Noperiod"
	 q:periodType="" "NoperiodType"
	
	s SQLCODE=0
	s sqlStr="SELECT * FROM dhc_qm_data.LocResultMain" 
	         _" WHERE LocResultMain_period='"_period_"'"
	         _" and LocResultMain_auditState=1"
	         _" and LocResultMain_schemDr->QMSchem_periodType='"_periodType_"'"
	         _" and LocResultMain_Plandr is null"
	        

    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
		s actValue=0
		s MainID = result.Data("LocResultMain_rowid")
		
		s actValue=..calPCPatScore(period, periodType,MainID)
		i $ISVALIDNUM(actValue) d
		.&sql(update dhc_qm_data.LocResultMain set LocResultMain_failNum=:actValue where %ID=:MainID)
		i SQLCODE'=0 d
		.d ##class(dhc.pa.udata.uPALogger).Insert("calPCPatScore",actValue_"^"_MainID,SQLCODE,"")
		
		s actValue=0		
		s actValue=..calPCDeptScore(period, periodType,MainID)		
		i $ISVALIDNUM(actValue) d
		.&sql(update dhc_qm_data.LocResultMain set LocResultMain_failNum=:actValue where %ID=:MainID)
		i SQLCODE'=0 d
		.d ##class(dhc.pa.udata.uPALogger).Insert("calPCDeptScore",actValue_"^"_MainID,SQLCODE,"")
		;i SQLCODE'=0 b
	}
	d result.Close()
	
	
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2015-9-15
/// Description: 计算PC端的有病人信息考核结果
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPCPatScore("201602","Q","658")
ClassMethod calPCPatScore(period, periodType, MainID) As %String
{
	n (period, periodType,MainID)
	q:period="" "Noperiod"
	q:periodType="" "NoperiodType"
	q:MainID="" "NoMainID"
	
	s actValue=0
	&sql(SELECT sum(actValue) as actValue into :actValue FROM
				(SELECT LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,count(DISTINCT(LocResultdetail_parRef->LocResultMain_departDr)) AS actValue
				FROM dhc_qm_data.LocResultdetail 
				WHERE LocResultdetail_parRef->LocResultMain_period=:period
				AND LocResultdetail_parRef->LocResultMain_auditState=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
				AND LocResultdetail_parRef=:MainID
				GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_JXPatDr)
				GROUP BY LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_wardDr)
	
	&sql(SELECT sum(actValue) as actValue into :actValue FROM
				(SELECT LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,count(DISTINCT(LocResultdetail_parRef->LocResultMain_departDr)) AS actValue
				FROM dhc_qm_data.LocResultdetail 
				WHERE LocResultdetail_parRef->LocResultMain_period=:period
				AND LocResultdetail_parRef->LocResultMain_auditState=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType=2
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
				AND LocResultdetail_actValue='N' 
				AND LocResultdetail_parRef=:MainID
				GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_JXPatDr)
				GROUP BY LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_wardDr)
	
	&sql(SELECT count(distinct(LocResultdetail_parRef->LocResultMain_departDr)) into:actValue FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code in ('0060404')
			 AND (LocResultdetail_actValue!="" AND LocResultdetail_actValue IS NOT NULL)  
			 AND  LocResultdetail_checkDr->Check_code IN ('060','061')		
	         GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr)
    q actValue
}

/// Creator: wang ying
/// CreatDate: 2015-9-15
/// Description: 计算PC端的无病人信息考核结果
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPCDeptScore("201602","Q","692")
ClassMethod calPCDeptScore(period, periodType, MainID) As %String
{
	n (period,periodType,MainID)
	q:period="" "Noperiod"
	q:periodType="" "NoperiodType"
	q:MainID="" "NoMainID"
	
	s actValue=0,type=0
    
    &sql(SELECT LocResultdetail_parRef->LocResultMain_failNum,LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType into :actValue,:type FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType=3
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND LocResultdetail_checkDr->Check_comp='Y')
	
	q:type'=3 actValue
	&sql(SELECT LocResultdetail_actValue into:actValue FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period 
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType=3
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code not in ('0060105','0060405','0060404')
			 AND LocResultdetail_parRef=:MainID
			 AND LocResultdetail_checkDr->Check_comp='Y')
			 //			
	
			 
	&sql(SELECT count(distinct(LocResultdetail_parRef->LocResultMain_departDr)) into:actValue FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code in ('0060105','0060405')
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_dataType=3
			 AND (LocResultdetail_actValue='N' or LocResultdetail_actValue='否' or LocResultdetail_actValue='差')
			 AND  LocResultdetail_checkDr->Check_comp='Y'			
	         GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr)


	
	i actValue="" s actValue=0
	q actValue
}

/// Creator: wang ying
/// CreatDate: 2015-9-15
/// Description: 计算PAD端的有病人信息考核结果
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPCScore("201501","1","1","1")
ClassMethod calPADPatScore(period, periodType, MainID) As %String
{
	n (period, periodType,MainID)
	q:period="" "Noperiod"
	q:periodType="" "NoperiodType"
	q:MainID="" "NoMainID"
	
	s actValue=0
	&sql(SELECT sum(actValue) as actValue into :actValue FROM
				(SELECT LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,count(DISTINCT(LocResultdetail_JXPatDr)) AS actValue
				FROM dhc_qm_data.LocResultdetail 
				WHERE LocResultdetail_parRef->LocResultMain_period=:period
				AND LocResultdetail_parRef->LocResultMain_auditState=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
				AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code not in ('0060305')
				AND LocResultdetail_parRef=:MainID
				AND LocResultdetail_actValue='N'
				AND LocResultdetail_checkDr->Check_comp='Y'
				AND (LocResultdetail_JXPatDr IS NOT NULL or LocResultdetail_JXPatDr!=0)
				GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_JXPatDr)
				GROUP BY LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_wardDr)
	;w "Pat1="_MainID_"^"_actValue,!
	&sql(SELECT sum(actValue) as actValue into :actValue FROM
				(SELECT LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,count(DISTINCT(LocResultdetail_JXPatDr)) AS actValue
				FROM dhc_qm_data.LocResultdetail 
				WHERE LocResultdetail_parRef->LocResultMain_period=:period
				AND LocResultdetail_parRef->LocResultMain_auditState=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
				AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code='0060305'
				AND LocResultdetail_parRef=:MainID
				AND LocResultdetail_actValue='N'
				AND LocResultdetail_checkDr->Check_comp='Y'
				AND LocResultdetail_checkDr->Check_code='012'
				AND (LocResultdetail_JXPatDr IS NOT NULL or LocResultdetail_JXPatDr!=0)
				GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_JXPatDr)
				GROUP BY LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_wardDr)
	/*
	&sql(SELECT sum(actValue) as actValue into :actValue FROM
				(SELECT LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,count(DISTINCT(LocResultdetail_JXPatDr)) AS actValue
				FROM dhc_qm_data.LocResultdetail 
				WHERE LocResultdetail_parRef->LocResultMain_period=:period
				AND LocResultdetail_parRef->LocResultMain_auditState=1
				AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
				AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code='004'
				AND LocResultdetail_parRef=:MainID
				AND LocResultdetail_actValue='N'
				AND LocResultdetail_checkDr->Check_comp='Y'
				AND LocResultdetail_checkDr->Check_code='010'
				AND (LocResultdetail_JXPatDr IS NOT NULL or LocResultdetail_JXPatDr!=0)
				GROUP BY LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr,
				LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_JXPatDr)
				GROUP BY LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_wardDr)
    */
    q actValue
}

/// Creator: wang ying
/// CreatDate: 2015-9-15
/// Description: 计算PAD端的无病人信息考核结果
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).calPCScore("201501","1","1","1")
ClassMethod calPADDeptScore(period, periodType, MainID) As %String
{
	n (period, periodType,MainID)
	q:period="" "Noperiod"
	q:periodType="" "NoperiodType"
	q:MainID="" "NoMainID"
	
	s actValue=0
	;w "0="_actValue_"^"_MainID,!
	&sql(SELECT count(*) into:actValue FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code!='0060305'
			 AND (LocResultdetail_JXPatDr IS NULL or LocResultdetail_JXPatDr=0)
			 AND LocResultdetail_actValue!=0
			 AND LocResultdetail_actValue='N'
			 AND LocResultdetail_checkDr->Check_comp='Y' AND LocResultdetail_checkDr->Check_ObjectType='1')	
	
	;i actValue>0 s actValue=1
	;w "1="_actValue_"^"_MainID,!
	&sql(SELECT count(*) into:Value FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code!='0060305'
			 AND (LocResultdetail_JXPatDr IS NULL or LocResultdetail_JXPatDr=0)
			 AND LocResultdetail_actValue=0
			 AND LocResultdetail_checkDr->Check_comp='Y' AND LocResultdetail_checkDr->Check_ObjectType='1')	
	s temp=0,QMSchemCode=""
	&sql(SELECT LocResultMain_failNum,LocResultMain_schemDr->QMSchem_Code into:temp,:QMSchemCode FROM dhc_qm_data.LocResultMain WHERE %ID=:MainID)
	i (Value>0)&&(temp<2) s actValue=2
	e  i (temp>0) s actValue=temp
	;w "2="_actValue_"^"_MainID,!
	s dedNum=0,undedNum=0
	&sql(SELECT LocResultdetail_actValue into:dedNum FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code='0060302'
			 AND (LocResultdetail_JXPatDr IS NULL or LocResultdetail_JXPatDr=0)
			 AND  LocResultdetail_checkDr->Check_code='016'
			 AND LocResultdetail_checkDr->Check_comp='Y' AND LocResultdetail_checkDr->Check_ObjectType='1')	
	;w "3="_actValue_"^"_MainID,!
	
	&sql(SELECT LocResultdetail_actValue into:undedNum FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef->LocResultMain_period=:period
			 AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType=:periodType
			 AND LocResultdetail_parRef=:MainID
			 AND  LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code='0060302'
			 AND (LocResultdetail_JXPatDr IS NULL or LocResultdetail_JXPatDr=0)
			 AND  LocResultdetail_checkDr->Check_code='017'
			 AND LocResultdetail_checkDr->Check_comp='Y' AND LocResultdetail_checkDr->Check_ObjectType='1')	
	i QMSchemCode="0060302" d
	.i dedNum=0 s actValue=0
	.e   i ((undedNum<dedNum)&&(undedNum'=0)) s actValue=1
	.e  i undedNum=0 s actValue=2
	
	;w "4="_actValue_"^"_MainID,!
	q actValue
}

/// Creator: wang ying
/// CreatDate: 2015-12-8
/// Description: 获取已检过、未检病房数
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).getWardNum("201502","Q","15")
ClassMethod getWardNum(period, periodType, planDr) As %String
{
	n (period, periodType, planDr)
	;q:period="" "Noperiod"
	;q:periodType="" "NoperiodType"
	q:planDr="" "NoplanDr"
	
	s unCheckNum=0,totalNum=0,checkNum=0,totalDetail=0,unCheckDetail=0
	&sql(SELECT Plan_CheckDepart into:deptStr  FROM dhc_qm_data.Plan where %ID=:planDr)
	q:deptStr="" "NoDeptStr"
	s totalNum=$l(deptStr,",")
	
	s count=0
	/*
	f i=1:1:totalNum d
	.s ward=$p($p(deptStr,",",i),"||",1)
	.s dept=$p($p(deptStr,",",i),"||",2)
	.s ischeck=0
	.s ischeck=##class(dhc.qm.udata.uComm).WarIsChecked(planDr,ward,dept)
	.i ischeck=1 d 
	..;b
	..s count=count+1
	;w totalNum,!
	*/
	&sql(SELECT count(DISTINCT(LocResultdetail_parRef->LocResultMain_wardDr)) into:unCheckDetail FROM dhc_qm_data.LocResultdetail 
		WHERE LocResultdetail_parRef->LocResultMain_Plandr=:planDr
		AND (LocResultdetail_parRef->LocResultMain_wardDr IS NOT NULL AND LocResultdetail_parRef->LocResultMain_wardDr<>0)
		AND LocResultdetail_saveStatus=1)	
	/*		 
	&sql(SELECT count(DISTINCT(LocResultdetail_parRef->LocResultMain_wardDr)) into:totalDetail FROM dhc_qm_data.LocResultdetail 
		 WHERE LocResultdetail_parRef->LocResultMain_Plandr=:planDr 
		 AND LocResultdetail_parRef->LocResultMain_wardDr IS NOT NULL )
	*/	 
    ;w totalNum_"^"_unCheckDetail,!
    
    ;s checkNum=totalDetail-unCheckDetail
    
    s unCheckNum=totalNum-unCheckDetail
	q unCheckNum_"^"_unCheckDetail
}

/// Creator: wang ying
/// CreatDate: 2015-10-30
/// Description: 获取已检、未检病房数
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 正确返回0,错误返回sqlcode
/// Others:w ##class(dhc.qm.udata.uPlan).getWardNum("201503","Q","1")
ClassMethod getWardNumOld(period, periodType, planDr) As %String
{
	n (period, periodType, planDr)
	;q:period="" "Noperiod"
	;q:periodType="" "NoperiodType"
	q:planDr="" "NoplanDr"
	
	s unCheckNum=0,totalNum=0,checkNum=0,totalDetail=0,unCheckDetail=0
	&sql(SELECT Plan_CheckDepart into:deptStr  FROM dhc_qm_data.Plan where %ID=:planDr)
	q:deptStr="" "NoDeptStr"
	s totalNum=$l(deptStr,",")
	
	s count=0
	f i=1:1:totalNum d
	.s ward=$p($p(deptStr,",",i),"||",1)
	.s dept=$p($p(deptStr,",",i),"||",2)
	.s ischeck=0
	.s ischeck=##class(dhc.qm.udata.uComm).WarIsChecked(planDr,ward,dept)
	.i ischeck=1 d 
	..;b
	..s count=count+1
	;w totalNum,!
	/*
	&sql(SELECT count(DISTINCT(LocResultdetail_parRef->LocResultMain_wardDr)) into:unCheckDetail FROM dhc_qm_data.LocResultdetail 
		WHERE LocResultdetail_parRef->LocResultMain_Plandr=:planDr
		AND LocResultdetail_parRef->LocResultMain_wardDr IS NOT NULL 
		AND (LocResultdetail_saveStatus IS NULL 
		OR LocResultdetail_saveStatus=0))	
			 
	&sql(SELECT count(DISTINCT(LocResultdetail_parRef->LocResultMain_wardDr)) into:totalDetail FROM dhc_qm_data.LocResultdetail 
		 WHERE LocResultdetail_parRef->LocResultMain_Plandr=:planDr 
		 AND LocResultdetail_parRef->LocResultMain_wardDr IS NOT NULL )
		 
    ;w totalNum_"^"_totalDetail_"^"_unCheckDetail,!
    
    s checkNum=totalDetail-unCheckDetail
    */
    s unCheckNum=totalNum-count
	q unCheckNum_"^"_count
}

/// Creator: ban
/// CreatDate: 2015-11-05
/// Description: 获取该检查项已检查完毕
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 该检查项检查完毕，则返回Y,否则返回N
/// Others:w ##class(dhc.qm.udata.uPlan).qmschemIsCheck("6","18","33","201503","1")
ClassMethod qmschemIsCheck(qmschemDr, deptGroupDr, wardDr, period, planDr) As %String
{
	n (qmschemDr,deptGroupDr, wardDr, period,planDr)
	q:period="" "Noperiod"
	q:deptGroupDr="" "NodeptGroupDr"
	q:planDr="" "NoplanDr"
	q:wardDr="" "NowardDr"
	q:qmschemDr="" "NoqmschemDr"
	s isFlag =""
	&sql(select count(LocResultdetail_saveStatus) into :noCheckNum from dhc_qm_data.LocResultdetail 
	where LocResultdetail_parRef in(select LocResultMain_rowid from dhc_qm_data.LocResultMain where LocResultMain_Plandr = :planDr 
		and LocResultMain_departDr =:deptGroupDr and LocResultMain_wardDr = :wardDr
		and LocResultMain_period =:period and LocResultMain_schemDr = :qmschemDr) and LocResultdetail_saveStatus = 0)
		 
    i noCheckNum ="0"  d
    .s isFlag ="Y"
    e  d
    .s isFlag ="N"
	q isFlag
}

/// Creator: ban
/// CreatDate: 2015-11-05
/// Description: 获取该病区是否已检查完毕
/// Table： dhc_qm_data.LocResultMain, dhc_qm_data.LocResultdetail
/// Input: 
/// Output: 
/// Return: 该病区是否检查完毕，则返回Y,否则返回N
/// Others:w ##class(dhc.qm.udata.uPlan).wardIsChecked("18","33","201503","1")
ClassMethod wardIsChecked(deptGroupDr, wardDr, period, planDr) As %String
{
	n (deptGroupDr, wardDr, period,planDr)
	q:period="" "Noperiod"
	q:deptGroupDr="" "NodeptGroupDr"
	q:planDr="" "NoplanDr"
	q:wardDr="" "NowardDr"
	s isFlag =""
	&sql(select count(LocResultdetail_saveStatus) into :noCheckNum from dhc_qm_data.LocResultdetail 
	where LocResultdetail_parRef in(select LocResultMain_rowid from dhc_qm_data.LocResultMain where LocResultMain_Plandr = :planDr 
		and LocResultMain_departDr =:deptGroupDr and LocResultMain_wardDr = :wardDr
		and LocResultMain_period =:period) and LocResultdetail_saveStatus = 0)
		 
    i noCheckNum ="0"  d
    .s isFlag ="Y"
    e  d
    .s isFlag ="N"
	q isFlag
}

}
