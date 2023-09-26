Class dhc.qm.udata.uComm Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:     ban
/// CreateDate:  2015-08-04
/// Description: 根据计划表ID查询计划信息
/// Table:       dhc_qm_data.Plan
/// Input:       划表ID
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetQMSchem("<Request><wardDr>43</wardDr><planDr>6</planDr><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetQMSchem(Param As %String) As %String
{
	n (Param)
	i Param="" s Param="<Request><planDr>1</planDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s planDr=request.planDr
	   s dept=request.deptGroupDr
	   s ward=request.wardDr
	}
	 s resultString=""
	 q:planDr="" "NoplanDr"
	 q:dept="" "Nodept"
	 q:ward="" "Noward"
	 s resultString=##class(dhc.qm.udata.uComm).List(planDr,dept,ward)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-09-15
/// Description: 验证登录信息
/// Table:       SSUser
/// Input:       划表ID
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetSSUser("<Request><userCode>demo</userCode><userPassWord>30</userPassWord></Request>")
ClassMethod GetSSUser(Param As %String) As %String
{
	n (Param)
	i Param="" s Param="<Request><userCode>demo</userCode><userPassWord>30</userPassWord></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userPassWord = request.userPassWord
	}
	 s resultString=""
	 q:userCode="" "NouserCode"
	 q:userPassWord="" "NouserPassWord"
	 s resultString=##Class(dtweb.SSUser).IsValidUser(userCode,userPassWord)
	 i resultString>0  s resultString="{success:'true',info:'"_resultString_"'}"
	 e  i resultString=""  s resultString="{success:'false',info:'此用户不存在'}"
	 e  i resultString="-101"  s resultString="{success:'false',info:'密码错误'}"
	 e   s resultString="{success:'false',info:'验证不通过'}"

	 q resultString
}

/// Creator: ban
/// CreatDate:2015-08-04
/// Description: 查询符合条件的记录
/// Table: dhc_qm_data.Plan
/// Input: planDr
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).List(6,9,10)
ClassMethod List(planDr, dept, ward) As %String
{
	n (planDr,dept,ward)
	q:planDr="" "NoplanDr"
	q:dept="" "NoLdept"
	q:ward="" "NoLward"
	s sqlStr="SELECT Plan_QMSchemDr FROM dhc_qm_data.Plan where Plan_rowid='"_planDr_"'"
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^qmschemDr^qmschemName^isCheck"
	While(result.Next())
	{   
		s qmschemName=""
		s qmschemDr = result.Data("Plan_QMSchemDr")
		i qmschemDr'="" d
		.s len=$l(qmschemDr,",")
		.f i=1:1:len  d
		..s qmschemName=##class(dhc.qm.udata.uitem3).QMSchem($p(qmschemDr,",",i))
		..s qmschemSingleDr=$p(qmschemDr,",",i)
		..s isCheck=0
		..s isCheck=..SchemIsChecked2(planDr,ward,dept,qmschemSingleDr)
		..s tmp=planDr_"^"_qmschemSingleDr_"^"_qmschemName_"^"_isCheck
		..d json.InsertRowData(tmp)
		..s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-04
/// Description: 根据计划表ID查询获取科室列表
/// Table:       dhc_qm_data.Plan
/// Input:       划表ID
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetDepartmentGroup("<Request><planDr>1</planDr></Request>")
ClassMethod GetDepartmentGroup(Param As %String) As %String
{
	n (Param)
	i Param="" s Param="<Request><planDr>1</planDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s planDr=request.planDr
	}
	 s resultString=""
	 q:planDr="" "NoplanDrs"
	 s resultString=##class(dhc.qm.udata.uComm).ListDept(planDr)
	 q resultString
}

/// Creator: ban
/// CreatDate:2015-08-04
/// Description: 根据计划表ID查询获取科室列表
/// Table: dhc_qm_data.Plan
/// Input: planDr
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).ListDept(1)
ClassMethod ListDept(planDr) As %String
{
	n (planDr)
	q:planDr="" "NoplanDrs"
	s sqlStr="SELECT Plan_CheckDepart FROM dhc_qm_data.Plan where Plan_rowid='"_planDr_"'"
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name"
	While(result.Next())
	{   
		s deptGroupName=""
		s deptGroupDr= result.Data("Plan_CheckDepart")
		i deptGroupDr'="" d
		.s deptlen=$l(deptGroupDr,",")
		.f j=1:1:deptlen  d
		..s deptGroupName=##class(dhc.qm.udata.uitem3).deptList($p(deptGroupDr,",",j))
		..s deptGroupSingleDr=$p(deptGroupDr,",",j)
		..s tmp=planDr_"^"_deptGroupSingleDr_"^"_deptGroupName
		..d json.InsertRowData(tmp)
		..s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:    wang ying
/// CreateDate:  2015-08-06
/// Description: 根据科室组ID查询病区id、名称
/// Table:      
/// Input:       科室组ID
/// Return:      病区信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetWard("<Request><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetWard(Param As %String) As %String
{
	n (Param)
	i Param="" s Param="<Request><deptGroupDr>20</deptGroupDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    //s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s deptGroupDr=request.deptGroupDr
	}
	 
	 q:deptGroupDr="" "NodeptGroupDr"
	 s resultString=##class(dhc.qm.udata.uComm).GetAdmlocward(deptGroupDr)
	 q resultString
}

/// Creator: wang ying
/// CreatDate:2015-08-05
/// Description: 根据科室组id获取病区id
/// Table: 
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).GetAdmlocward(20)
ClassMethod GetAdmlocward(dept)
{
 	//s file="/tmp/GetAdmlocward.Txt"
    //o file:"WNS"
    //u file
	n (dept)
	
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^deptGroupDr^wardCode^wardName"
	 
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .q:Depdr'=dept
    .s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    .s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
    ...;w WardID,!
    ...;s value=WardID
    ...s WardCode=$P(^PAWARD(WardID),"^",1)
    ...s WardDesc=$P(^PAWARD(WardID),"^",2)
    ...if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
    ...s tmp=WardID_"^"_Depdr_"^"_WardCode_"^"_WardDesc  
    ...d json.InsertRowData(tmp)
	...s count=count+1
    ...;s retval=CTLOCID_":"_desc_":"_value_":"_WardDesc
    ...;w !,Depdr_"^"_DepartCode_"^"_Department_"^"_CTLOCID_"^"_CtCode_"^"_desc_"^"_LocFlag_"^"_WardID_"^"_WardCode_"^"_WardDesc_"^"_Type
    //c file
   
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate:2015-09-08
/// Description: 查询科室组
/// Table: 
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).GetDeptGroup("0","1000","","2016年03季","201603",1)
ClassMethod GetDeptGroup(start, limit, str, periodTxt, yearPeriod, userDr, planId)
{
 
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^deptGroupCode^deptGroupName"
	s checkwardList=..isWardChecked(periodTxt, yearPeriod, userDr,planId) 
	
	i (start'="")&(limit'="") s end=limit+start 
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .i Depdr'="" d
    ..s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    ..s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    ..q:(str'="")&&(Department'[str) 
    ..;s tmp=Depdr_"^"_DepartCode_"^"_Department
    ..//（10）如果isExtNoCheckWard>0则生成global
    ..s isExtNOCheckWard=..isExtNOCheckWard(Depdr,CTLOCID,periodTxt,yearPeriod,userDr,checkwardList)
    ..if isExtNOCheckWard>0 d
    ...s ^TMPDHCCJXPADEPT($j,Depdr)=DepartCode_"^"_Department
    
   
    s count=0
    s deptDr=0
    f  s deptDr=$o(^TMPDHCCJXPADEPT($j,deptDr)) q:deptDr=""  d
    .s deptCode=$p($g(^TMPDHCCJXPADEPT($j,deptDr)),"^",1)
    .s deptName=$p($g(^TMPDHCCJXPADEPT($j,deptDr)),"^",2)
    .s tmp=deptDr_"^"_deptCode_"^"_deptName
    .s count=count+1
    .i (start'="")&(limit'="") d
    ..i (count>=start)&(count<end) d
    ...;w count_"^"_start_"^"_end_"^"_tmp,!
    ...d json.InsertRowData(tmp)
    .e  d
    ..d json.InsertRowData(tmp)
	s resultString = json.getJsonData(jsonTitle,count)
 	k json,^TMPDHCCJXPADEPT($j)
	q resultString
}

/// Creator: zhaowei
/// CreatDate:2015-09-17
/// Description: 根据科室组查病房信息--带模糊查询
/// Table: 
/// Input:start,limit,str,dept 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).GetSuperAdmlocward(0,10,"外科",20)
ClassMethod GetSuperAdmlocward(start, limit, str, dept)
{
	n (start, limit, str,dept)
	
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^deptGroupDr^wardCode^wardName"
	 
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .q:Depdr'=dept
    .s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    .s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
    ...;w WardID,!
    ...;s value=WardID
    ...s WardCode=$P(^PAWARD(WardID),"^",1)
    ...s WardDesc=$P(^PAWARD(WardID),"^",2)
    ...q:WardDesc'[str

    ...if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
    ...s tmp=WardID_"^"_Depdr_"^"_WardCode_"^"_WardDesc  
    ...//w count_"p->"_((count>start)&(count<limit))_"*",!
    ...i ((count>=start)&(count<(start+limit))) { d json.InsertRowData(tmp)}
    ...s count=count+1 

    ...;s retval=CTLOCID_":"_desc_":"_value_":"_WardDesc
    ...;w !,Depdr_"^"_DepartCode_"^"_Department_"^"_CTLOCID_"^"_CtCode_"^"_desc_"^"_LocFlag_"^"_WardID_"^"_WardCode_"^"_WardDesc_"^"_Type
    //c file
   
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate:2015-10-30
/// Description: 获取病区信息
/// Table: 
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).GetAdmlocwardInfo()
ClassMethod GetAdmlocwardInfo()
{
	
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^deptGroupDr^wardCode^wardName"
	 
    s ADMLRowId=""
    
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    .s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
    ...;w WardID,!
    ...;s value=WardID
    ...s WardName="",WardDesc=""
    ...s WardCode=$P(^PAWARD(WardID),"^",1)
    ...s WardName=$P(^PAWARD(WardID),"^",2)
    ...;w WardCode,!
    ...if $P(WardName,"-",2)'="" s WardName=$P(WardName,"-",2)
    ...i WardCode'="" d
    ....s WardLoc=""
    ....s WardLoc=$o(^CTLOC(0,"Code",WardCode,WardLoc))
    ....q:WardLoc=""
    ....s WardDesc=$g(^CTLOC(WardLoc,"ADDR",1))
    ....q:WardDesc=""
    ....s WardDesc="["_WardDesc_"]"_"-"_Department_"-"_WardName
    ....;w WardDesc,!
    ....s ^TEMPDHCCJXQMWARD($j,WardDesc,WardID_"||"_Depdr)=Depdr_"^"_WardCode
    
    s WardDesc=""
    f  s WardDesc=$o(^TEMPDHCCJXQMWARD($j,WardDesc)) q:WardDesc=""  d
    .s WardID=0
    .f  s WardID=$o(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)) q:WardID=""  d
    ..s deptDr=$p($g(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)),"^",1)
    ..s WardCode=$p($g(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)),"^",2)
    ..s tmp=WardID_"^"_deptDr_"^"_WardCode_"^"_WardDesc  
    ..d json.InsertRowData(tmp)
	..s count=count+1
    ..;s retval=CTLOCID_":"_desc_":"_value_":"_WardDesc
    ..;w !,Depdr_"^"_DepartCode_"^"_Department_"^"_CTLOCID_"^"_CtCode_"^"_desc_"^"_LocFlag_"^"_WardID_"^"_WardCode_"^"_WardDesc_"^"_Type
    //c file
   
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	k ^TEMPDHCCJXQMWARD($j)
	q resultString
}

/// Creator: wang ying
/// CreatDate:2015-11-18
/// Description: 获取病区信息
/// Table: 
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uComm).GetlocwardInfo("6","2015年04季","201504",1)
ClassMethod GetlocwardInfo(dept, periodtxt, yearPeriod, userDr, planId)
{
	
	s count=0
	s resultString=""
	;s dept=","_dept_","
	if dept="" s dept=""
	e  s dept=","_dept_","
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^deptGroupDr^wardCode^wardName"
	;s ^chuchu=dept_"^"_periodtxt_"^"_yearPeriod_"^"_userDr
    s ADMLRowId=""
    s wardList=..isWardChecked(periodtxt,yearPeriod,userDr,planId) //获得所有非当前检查人已经选择的病区
    
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s LocDateTo=$p(^CTLOC(CTLOCID),"^",25)
    .q:(LocDateTo'="")&&(LocDateTo<+$h)
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .q:dept'[(","_Depdr_",")
    .s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    .s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
    ...s WardName="",WardDesc=""
    ...s WardCode=$P(^PAWARD(WardID),"^",1)
    ...s WardName=$P(^PAWARD(WardID),"^",2)
    ...;w WardCode,!
    ...if $P(WardName,"-",2)'="" s WardName=$P(WardName,"-",2)
    ...i WardCode'="" d
    ....s WardLoc=""
    ....s WardLoc=$o(^CTLOC(0,"Code",WardCode,WardLoc))
    ....q:WardLoc=""
    ....s WardDesc=$g(^CTLOC(WardLoc,"ADDR",1))
    ....;q:WardDesc=""
    ....if WardDesc=""  s WardDesc="无地址信息"
    ....s WardDesc="["_WardDesc_"]"_"-"_Department_"-"_WardName
    ....//这里面要确定去到的WardId是否在本季度已经被其他人选择了，
    ....//选择啦则不再显示
    ....s isCheckBYOther=$LISTFIND(wardList,WardID_"||"_Depdr)
    ....if (isCheckBYOther=0) d
    .....s ^TEMPDHCCJXQMWARD($j,WardDesc,WardID_"||"_Depdr)=Depdr_"^"_WardCode
    
    s WardDesc=""
    f  s WardDesc=$o(^TEMPDHCCJXQMWARD($j,WardDesc)) q:WardDesc=""  d
    .s WardID=0
    .f  s WardID=$o(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)) q:WardID=""  d
    ..s deptDr=$p($g(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)),"^",1)
    ..s WardCode=$p($g(^TEMPDHCCJXQMWARD($j,WardDesc,WardID)),"^",2)
    ..s tmp=WardID_"^"_deptDr_"^"_WardCode_"^"_WardDesc  
    ..d json.InsertRowData(tmp)
	..s count=count+1
    ..;s retval=CTLOCID_":"_desc_":"_value_":"_WardDesc
    ..;w !,Depdr_"^"_DepartCode_"^"_Department_"^"_CTLOCID_"^"_CtCode_"^"_desc_"^"_LocFlag_"^"_WardID_"^"_WardCode_"^"_WardDesc_"^"_Type
    //c file
   
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	k ^TEMPDHCCJXQMWARD($j)
	q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-04
/// Description: 根据计划表ID查询获取科室列表
/// Table:       dhc_qm_data.Plan
/// Input:       划表ID
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetWardInfoForSelect("<Request><planDr>1</planDr></Request>")
ClassMethod GetWardInfoForSelect(Param As %String) As %String
{
	n (Param)
	i Param="" s Param="<Request><planDr>1</planDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s planDr=request.planDr
	}
	 s resultString=""
	 q:planDr="" "NoplanDrs"
	 s resultString=##class(dhc.qm.udata.uPlanArrange).PlanWardListDetail(planDr)
	 q resultString
}

/// Creator:     chu yali
/// CreateDate:  2015-11-25
/// Description: 病房已检完、在检、未检
/// Table:       dhc_qm_data.Plan
/// Input:       planId(计划Id)，warId（病房Id），departId（科室Id）
/// Return:      0：未检查   1：已检查
/// Others:  w ##class(dhc.qm.udata.uComm).WarIsChecked("1","33","18") --2015-12-8 update by wy
ClassMethod WarIsChecked(planId, warId, departId) As %String
{
	n (planId,warId,departId)
	
	//主表中是否有记录
	set mainCount=0 ,detailCount=0,detailCheckCount=0
	set isChecked =0,schemStr=""
	&sql(SELECT Plan_QMSchemDr into :schemStr FROM dhc_qm_data.Plan where Plan_rowid=:planId)
	s sNum=$l(schemStr,",")
	
	&sql(SELECT count(*) into :mainCount FROM dhc_qm_data.LocResultMain 
				WHERE LocResultMain_wardDr=:warId
				AND LocResultMain_Plandr=:planId
				AND LocResultMain_departDr=:departId )
	&sql(SELECT count(*) into :detailCheckCount FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND (LocResultdetail_saveStatus=1)
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId )
	if (mainCount'=0){
		&sql(SELECT count(*) into :detailCount FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND (LocResultdetail_saveStatus IS NULL OR LocResultdetail_saveStatus=0)
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId )
		if (detailCount=0){
			set isChecked= 1  //如果主表中有记录，并且子表中也没有未检查记录，则返回1-检查完
		}
		elseif (detailCheckCount=0) {
			set isChecked=0   //如果主表中有记录，但子表中没有已检查记录，则返回0-未检查完
		}
		else{
			
			set isChecked=2  //其他情况则返回0-未检查完
		}
	}else{
		set isChecked=0  //主表没记录为未检查
	}
	;w "4="_isChecked_"^"_detailCount_"^"_detailCheckCount_"^"_mainCount,!
	i isChecked=1 d
	.f i=1:1:sNum d
	..s schem=$p(schemStr,",",i)
	..s unCheck=..SchemIsChecked(planId,warId,departId,schem)
	..i unCheck=0 s isChecked=2
	;w isChecked,!
	q isChecked
}

/// Creator:     chu yali
/// CreateDate:  2015-11-25
/// Description: 病房是否已检查
/// Table:       dhc_qm_data.Plan
/// Input:       planId(计划Id)，warId（病房Id），departId（科室Id）
/// Return:      0：未检查   1：已检查
/// Others:  w ##class(dhc.qm.udata.uComm).WarIsChecked("1","33","18")
ClassMethod WarIsCheckedOld(planId, warId, departId) As %String
{
	n (planId,warId,departId)
	
	//主表中是否有记录
	set mainCount=0 ,detailCount=""
	set isChecked =0,schemStr=""
	&sql(SELECT Plan_QMSchemDr into :schemStr FROM dhc_qm_data.Plan where Plan_rowid=:planId)
	s sNum=$l(schemStr,",")
	
	&sql(SELECT count(*) into :mainCount FROM dhc_qm_data.LocResultMain 
				WHERE LocResultMain_wardDr=:warId
				AND LocResultMain_Plandr=:planId
				AND LocResultMain_departDr=:departId )
	if (mainCount'=0){
		//如果主表中没有记录，并且子表中也没有记录，则返回1
		&sql(SELECT count(*) into :detailCount FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND (LocResultdetail_saveStatus IS NULL OR LocResultdetail_saveStatus=0)
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId )
		if (detailCount=0){
			set isChecked= 1
		}else{
			set isChecked=0	
		}
	}else{
		set isChecked=0
	}
	;w isChecked,!
	i isChecked=1 d
	.f i=1:1:sNum d
	..s schem=$p(schemStr,",",i)
	..;w schem,!
	..s unCheck=..SchemIsChecked(planId,warId,departId,schem)
	..;w schem_"^"_unCheck,!
	..i unCheck=0 s isChecked=0
	;w isChecked,!
	q isChecked
}

/// Creator:     ban
/// CreateDate:  2016-08-10
/// Description: 检查项是否已检查,已检中有一条记录即可
/// Table:       dhc_qm_data.Plan
/// Input:       planId(计划Id)，warId（病房Id），departId（科室Id），schemId（检查项Id）
/// Return:      0：未检查   1：已检查
/// Others:  w ##class(dhc.qm.udata.uComm).SchemIsChecked2("6","43","20","5")
ClassMethod SchemIsChecked2(planId, warId, departId, schemId) As %String
{
	n (planId,warId,departId,schemId)
	
	s SchemCode=""
	&sql(SELECT QMSchem_Code INTO:SchemCode FROM dhc_qm_data.QMschem where QMSchem_RowID=:schemId)
	
	//主表中是否有记录
	set mainCount=0 ,detailCount=""
	set isChecked =""
	&sql(SELECT count(*) into :mainCount FROM dhc_qm_data.LocResultMain 
				WHERE LocResultMain_wardDr=:warId
				AND LocResultMain_Plandr=:planId
				AND LocResultMain_departDr=:departId
				AND LocResultMain_schemDr=:schemId )
	if (mainCount'=0){
		//如果主表中有记录，并且子表中也有记录
		&sql(SELECT count(DISTINCT LocResultdetail_JXPatDr) into :detailCount FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND LocResultdetail_saveStatus=1
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId
				AND LocResultdetail_parRef->LocResultMain_schemDr=:schemId )
		//疑难病例、交接班的   只要有保存记录，就证明已调查
		i (SchemCode="0060301")||(SchemCode="0060303") d  
		.i detailCount=1  d
		..set isChecked= 1
		.e  d
		..set isChecked= 0
		e  i SchemCode="0060302"  d
		.&sql(SELECT count(DISTINCT LocResultdetail_JXPatDr) into :detailCounts FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND (LocResultdetail_saveStatus IS NULL OR LocResultdetail_saveStatus=0)
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId
				AND LocResultdetail_parRef->LocResultMain_schemDr=:schemId )
		.i detailCounts=0  d
		..set isChecked= 1
		.e  d
		..set isChecked= 0
		//其他的检查项，只要调查了两个病人，就算已检查
		e  d
		.i detailCount>=2  d
		..set isChecked= 1
		.e  d
		..set isChecked=0	
	}else{
		set isChecked=0
	}
	
	q isChecked
}

/// Creator:     chu yali
/// CreateDate:  2015-11-25
/// Description: 检查项是否已检查，已检中有记录，未检中没有记录
/// Table:       dhc_qm_data.Plan
/// Input:       planId(计划Id)，warId（病房Id），departId（科室Id），schemId（检查项Id）
/// Return:      0：未检查   1：已检查
/// Others:  w ##class(dhc.qm.udata.uComm).SchemIsChecked("6","46","20","5")
ClassMethod SchemIsChecked(planId, warId, departId, schemId) As %String
{
	n (planId,warId,departId,schemId)
	
	s SchemCode=""
	;&sql(SELECT QMSchem_Code INTO:SchemCode FROM dhc_qm_data.QMschem where QMSchem_RowID=:schemId)
	;i (SchemCode="0060301")||(SchemCode="0060303") s warId=0
	//主表中是否有记录
	set mainCount=0 ,detailCount=""
	set isChecked =""
	&sql(SELECT count(*) into :mainCount FROM dhc_qm_data.LocResultMain 
				WHERE LocResultMain_wardDr=:warId
				AND LocResultMain_Plandr=:planId
				AND LocResultMain_departDr=:departId
				AND LocResultMain_schemDr=:schemId )
	if (mainCount'=0){
		//如果主表中没有记录，并且子表中也没有记录，则返回1
		&sql(SELECT count(*) into :detailCount FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND (LocResultdetail_saveStatus IS NULL OR LocResultdetail_saveStatus=0)
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId
				AND LocResultdetail_parRef->LocResultMain_schemDr=:schemId )
		if (detailCount=0){
			set isChecked= 1
			set detailTotal=0,QMSchemCode=""
			&sql(SELECT count(*) ,LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code into :detailCounts,:QMSchemCode 
			    FROM dhc_qm_data.LocResultdetail
				WHERE LocResultdetail_parRef->LocResultMain_wardDr=:warId
				AND LocResultdetail_parRef->LocResultMain_Plandr=:planId
				AND LocResultdetail_parRef->LocResultMain_departDr=:departId
				AND LocResultdetail_parRef->LocResultMain_schemDr=:schemId )
			if detailCounts=0  set isChecked=0
			if (QMSchemCode="0060302")&&(detailCounts=2) set isChecked=0
		}else{
			set isChecked=0	
		}
	}else{
		set isChecked=0
	}
	
	q isChecked
}

/// Creator: wang ying
/// CreatDate:2016-03-21
/// Description: 根据期间和期间类型获得开始日期和结束日期
/// Table: 
/// Input:period:期间,periodType:期间类型
/// Output:开始日期和结束日期 
/// Return: 
/// others:w ##class(dhc.qm.udata.uComm).getTime("201501","Q") 
ClassMethod getTime(period, periodType) As %String
{
	n ( period,periodType)
	q:period="" "Noperiod"
	q:periodType="" "NOperiodType"
	
	s cycleCode=$e(period,1,4)
	i periodType="Q" d
	.i $e(period,5,6)="01"  s month="12",cycleCode=cycleCode-1
	.i $e(period,5,6)="02"  s month="03"
	.i $e(period,5,6)="03"  s month="06"
	.i $e(period,5,6)="04"  s month="09" 
	.s startDate=cycleCode_"-"_month_"-01"
	e  s startDate=$e(period,1,4)_"-"_$e(period,5,6)_"-01"	
	i periodType="M" s end=$e(period,5,6)+1
	i ($e(period,5,6)="01")&&(periodType="Q") s end="03"
	e  i periodType="Q" s end=month+3
	s endDate=$zd($zdh($e(period,1,4)_"-"_end_"-01",3)-1,3)
	q startDate_"^"_endDate
}

/// 按病案号取在院状态的就诊号 wangying
/// w ##Class(dhc.qm.udata.uComm).GetCurrAdmByMedicare("2052881")
/// OutPut: 0,无当前在院就诊；1^就诊号
ClassMethod GetCurrAdmByMedicare(Medicare)
{
    Set PAPMIRowid="",ret=0
	Set PAPMIRowid=$O(^PAPERi("Medicare1",Medicare,PAPMIRowid))
	Set PAAdm="",patInfo="" 
	for  Set PAAdm=$O(^PAPERdr(PAPMIRowid,"ADM","I",PAAdm)) Quit:PAAdm=""  DO
	.Set VisitStatus=$P(^PAADM(PAAdm),"^",20)
	.Quit:VisitStatus'="A" 
	.Set ret=1_"^"_PAAdm
	.i $p(ret,"^",1)=1 d
	..i patInfo'="" s patInfo=patInfo_"$"_..GetPAAdmInfo($p(ret,"^",2))
	..e  s patInfo=..GetPAAdmInfo($p(ret,"^",2))
	..;w $p(..GetPAAdmInfo($p(ret,"^",2)),"^",17),! 床号
	q patInfo
}

/// 按就诊号取患者就诊信息 wbg
/// PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,Sex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDep,PAAdmDoc,PAAdmType,InHospitalDays,PAAdmWard,PAAdmBed,PAAdmReason,DischargeDate,Diagnosis
/// OutPut：PatientID^就诊号^mradm^患者ID^姓名^出生日期^性别^就诊日期^就诊时间^PAAdmNo^就诊科室^就诊医生^就诊类型^在院天数^病区^床号^就诊费别^出院日期^号别^诊断
/// w ##Class(dhc.qm.udata.uComm).GetPAAdmInfo("15172371")
ClassMethod GetPAAdmInfo(PAAdm)
{
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sexid=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set Sex=$P($g(^CT("SEX",Sexid)),"^",2)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=##Class(web.DHCDTHealthCommon).GetAgeDesc(DobDate,+$H)
	Else  Set PAPMIDOB="",PAPMIAge=""
	Set PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	set Mdeicare=$p(^PAPER(PatientID,"PAT",1),"^",22) //取得病人——病案号
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),2) //入院时间
	set pAAdmDischgDate=$P($g(^PAADM(PAAdm)),"^",17) 
	Set InHospitalDays=+$H-PAAdmDate 
	if (pAAdmDischgDate'="") set InHospitalDays=(pAAdmDischgDate-PAAdmDate)
	Set PAAdmDate=$ZD(PAAdmDate,3)
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDep=..RemoveAlias($P($g(^CTLOC(Loc)),"^",2)) //就诊科室
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDoc=$P($g(^CTPCP(Doctor,1)),"^",2)  //就诊医生
    Else  Set PAAdmDoc=""
    Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=..RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If mradm'="" Set Diagnosis=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(mradm,",")  //诊断,部分住院诊断无诊断类型
	Else  Set Diagnosis=""
	set Data=PatientID_"^"_EpisodeID_"^"_mradm_"^"_PAPMINO_"^"_PAPMIName_"^"_PAPMIDOB_"^"_PAPMIAge_"^"_Sex_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PAAdmNo_"^"_PAAdmDep_"^"_PAAdmDoc_"^"_PAAdmType_"^"_InHospitalDays_"^"_PAAdmWard_"^"_PAAdmBed_"^"_PAAdmReason_"^"_DischargeDate_"^"_Diagnosis
 	Quit Data
}

/// wbg
ClassMethod RemoveAlias(Desc As %String) As %String
{
	s Desc1=$P(Desc,"-",2)
	if Desc1'="" Q Desc1
	Q Desc
}

/// Creator:     ban
/// CreateDate:  2016-08-04
/// Description: 获取版本控制的信息
/// Table:       dhc.pa.udata.APKVersion
/// Input:       划表ID
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uComm).GetVersion("")
ClassMethod GetVersion(Param As %String) As %String
{
	s sqlStr="SELECT Version_No,Version_Desc,Version_Url FROM dhc_qm_data.Version"
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="VersionNo^VersionDesc^VersionUrl"
	While(result.Next())
	{   
		s VersionNo= result.Data("Version_No")
		s VersionDesc= result.Data("Version_Desc")
		s VersionUrl= result.Data("Version_Url")
		
		s tmp=VersionNo_"^"_VersionDesc_"^"_VersionUrl
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:     chu yali
/// CreateDate:  2016-08-05
/// Description: 判断传入的病区id，是否已经被其他人选择过啦，选择啦，则返回已经选择的病区list
/// Table:      
/// Input:   
/// Others:  w ##class(dhc.qm.udata.uComm).isWardChecked("2015年02季度","201502","1")
ClassMethod isWardChecked(periodtxt, yearPeriod, userDr, planId) As %String
{
	n (periodtxt,yearPeriod,userDr,planId)
	/*
	1、先是过滤掉了本季度方案不是当前检查人的病区
	2、再要过滤本季度当前检查人已经选择的病区
	*/
	
	s wardSql="SELECT Plan_CheckDepart "
			_"FROM dhc_qm_data.Plan "
			_"WHERE Plan_period='"_yearPeriod_"' "
			_"AND Plan_Title LIKE '%"_periodtxt_"%' "
			_"and Plan_Status != 3"
	if (planId'="")	s wardSql=wardSql_" and Plan_rowid !="_planId
	 ;AND Plan_CheckUser!='"_userDr_"' 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(wardSql)
	d result.Execute()
	s ward=""
	while(result.Next()){
		s ward=ward_","_result.Data("Plan_CheckDepart")
	}
	
	s wardList=$LISTFROMSTRING(ward,",")
	q wardList
}

/// Creator:     chu yali
/// CreateDate:  2016-08-09
/// Description: 判断传入的科室id是否存在病区 and 科室下的病区是否全部被非当前用户所选择
/// d ##class(dhc.qm.udata.uComm).isExtNOCheckWard("6","13","2015年03季度","201503","1")
ClassMethod isExtNOCheckWard(deptId, CTLOCID, periodtxt, yearPeriod, userDr, checkwardList) As %String
{
	n (deptId,CTLOCID, periodtxt, yearPeriod, userDr, checkwardList)
	
	s wardCount=0
	
	//(1)根据^CTLoc(0,"DepGrp",deptId)得到CTLOC表的id
	/************,CTLOCID作为参数传入，从第二步开始***************/
	//(2)根据^CTLoc(CTLOCID,"LINK",childSub)得到关联表中关联的id
	s childSub=0
	f  s childSub=$o(^CTLOC(CTLOCID,"LINK",childSub)) q:childSub=""  d
	.//(3) 得到LinkLocID=^CTLoc(CTLOCID,"LINK",childSub)
	.s linkLocId=^CTLOC(CTLOCID,"LINK",childSub)
	.//(4)获得病区^PAWARD(0,"WARD_LocationDR",linkLocId,WardID)
	.s wardId=0
	.;s wardCount=0  //存在病区数
	.f  s wardId=$o(^PAWARD(0,"WARD_LocationDR",linkLocId,wardId)) q:wardId=""  d
	..//(5)如果不存在病区则返回0，如果有则继续下一步
	..///(6)拼接：deptWardStr=WardId || deptId
	..s deptWardStr=wardId_"||"_deptId
	..///(7) 判断deptWardStr是否在方法isWardChecked中的list中
	..s wardisCheckBYOther=$LISTFIND(checkwardList,deptWardStr)
	..///(8)如果不存在则count++，如果存在则继续循环
	..if wardisCheckBYOther=0  d
	...s wardCount=wardCount+1
	
	///(9)返回count
	
	
	q wardCount
}

}
