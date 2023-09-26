Class dhc.qm.udata.uitem3 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 查询符合条件的记录
/// Table: dhc.qm.udata.uitem3
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uitem3).List("","",0,15,"","",3901,0)  --2015-07-31 update by wy
/// others:w ##class(dhc.qm.udata.uitem3).List("","",0,15,"","",3901,0)  --2015-10-26 update by 小班
ClassMethod List(sortField, sortDir, start, limit, CheckStartDate, CheckEndDate, userDr, status) As %String
{
	n (sortField,sortDir,start,limit,CheckStartDate,CheckEndDate,userDr,status)
	
	;q:status="" "Nostatus"
	q:userDr="" "NoUser"
	s sqlStr="SELECT Plan_rowid,Plan_CycleDr,Plan_period,Plan_Title,Plan_CheckStartDate,Plan_CheckEndDate, Plan_TaskStartDate, Plan_TaskEndDate, Plan_QMSchemDr, Plan_CheckUser, Plan_CheckDepart, Plan_Status FROM dhc_qm_data.Plan where Plan_Status!=3"
	i CheckStartDate '="" s sqlStr=sqlStr_"  and Plan_CheckStartDate ='"_CheckStartDate_"'"
	i CheckEndDate '="" s sqlStr=sqlStr_"  and Plan_CheckEndDate ='"_CheckEndDate_"'"
	i status'="" s sqlStr=sqlStr_"  and Plan_Status='"_status_"'"
    i userDr'="" s sqlStr=sqlStr_"  and Plan_CheckUser='"_userDr_"'"
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s deptWardNames=""
	s deptWardIDs =""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^title^qmschemDr^qmschemName^deptGroupDr^deptGroupName^checkStard^checkEnd^taskStard^taskEnd^checkUser^checkUserName^status^statusName^period"
	While(result.Next())
	{   
		s qmschemName="",deptGroupNames="",statusName="",checkUserName=""
		s Rowid= result.Data("Plan_rowid")
		s Title= result.Data("Plan_Title")
		s qmschemDr = result.Data("Plan_QMSchemDr")
		i qmschemDr'="" d
		.s len=$l(qmschemDr,",")
		.f i=1:1:len  d
		..i qmschemName'="" s qmschemName=..QMSchem($p(qmschemDr,",",i))_","_qmschemName
		..e  s qmschemName=..QMSchem($p(qmschemDr,",",i))
		s wardDrs= result.Data("Plan_CheckDepart")
		i wardDrs'="" d
		.s wardlen=$l(wardDrs,",")
		.f j=1:1:wardlen  d
		..s wardDr = $p(wardDrs,",",j)
		..s wardInfos =..getWardInfosById(wardDr)
		..s wardName = $p(wardInfos,",",1)
		..s deptDr = $p(wardInfos,",",2)
		..s deptWardDr = deptDr_"#"_wardDr
		..s deptWardNames = deptWardNames _","_ wardName
		..s deptWardIDs = deptWardIDs _","_ deptWardDr
		s deptWardNameLen = $l(deptWardNames,",")
		s deptWardIDLen = $l(deptWardIDs,",")
		s deptGroupName = $p(deptWardNames,",",2,deptWardNameLen)
		s deptGroupDr = $p(deptWardIDs,",",2,deptWardIDLen)
		
		
		s CheckStartDate= result.Data("Plan_CheckStartDate")
		s CheckStartDate=$zd(CheckStartDate,3)
		s CheckEndDate= result.Data("Plan_CheckEndDate")
		s CheckEndDate=$zd(CheckEndDate,3)
		s taskStart= result.Data("Plan_TaskStartDate")
		s taskStart=$zd(taskStart,3)
		s taskEnd= result.Data("Plan_TaskEndDate")
		s taskEndData=$zd(taskEnd,3)
		s CheckUser= result.Data("Plan_CheckUser")
		i CheckUser'="" d
		.s checkUserName = $p($g(^SSU("SSUSR",CheckUser)),"^",2)
		s Status= result.Data("Plan_Status")
		i Status="" d
		.i Status=0 s statusName="未完成"
		.i Status=1 s statusName="完成"
		.i Status=3 s statusName="作废"
		s period = result.Data("Plan_period")
	//s IsValid= result.Data("org_affi_IsValid")
		 s tmp=Rowid_"^"_Title_"^"_qmschemDr_"^"_qmschemName_"^"_deptGroupDr_"^"_deptGroupName
		       _"^"_CheckStartDate_"^"_CheckEndDate_"^"_taskStart_"^"_taskEndData_"^"_CheckUser_"^"_checkUserName_"^"_Status_"^"_statusName_"^"_period
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:ban
/// CreatDate:2015-10-30
/// Description:可以根据病区dr查询对应的病区名称和地址
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组下的病区名称
/// Others:w ##class(dhc.qm.udata.uitem3).getWardInfoByWardID(43) 
ClassMethod getWardInfoByWardID(wardDr) As %String
{
	s resultString =""
	s WardDesc=$P(^PAWARD(wardDr),"^",2)
	;s WardAddress = ..getWardIDByWardCode(wardDr)
    if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
	s resultString =resultString _","_"["_WardAddress_"]"_WardDesc_";"_wardDr
	s len = $l(resultString,",")
	s resultString = $p(resultString,",",2,len)
	q resultString
}

/// Creator:ban
/// CreatDate:2015-10-26
/// Description:可以根据科室组id查询科室组下的病区信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组下的病区名称
/// Others:w ##class(dhc.qm.udata.uitem3).getWardByDeptID(20) 
ClassMethod getWardByDeptID(deptGroupDr) As %String
{
	n (deptGroupDr)
	s resultString=""
	 
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
    .q:Depdr'=deptGroupDr
    .s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    .s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
 
    ...s WardCode=$P(^PAWARD(WardID),"^",1)
    ...s WardDesc=$P(^PAWARD(WardID),"^",2)
    ...;s WardAddress = ..getWardIDByWardCode(WardID)
    ...if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
	...s resultString =resultString _","_"["_WardAddress_"]"_WardDesc_";"_WardID
	s len = $l(resultString,",")
	s resultString = $p(resultString,",",2,len)
	q resultString
}

/// Creator:ban
/// CreatDate:2015-10-26
/// Description:可以根据科室组中科室id获取ct_loc表中科室的位置
/// Table:ct_loc 
/// Output:
/// Return:返回科室的位置  即地址
/// Others:w ##class(dhc.qm.udata.uitem3).getWardInfosById("43")  
ClassMethod getWardInfosById(wardRowid) As %String
{
	n (wardRowid)	
		
	q:wardRowid="" "NowardRowid"
	s WardCode=$P(^PAWARD(wardRowid),"^",1)
	s WardDesc=$P(^PAWARD(wardRowid),"^",2)
    if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
	
	s sqlStr="select CTLOC_RowID,CTLOC_Dep_Dr as deptDr from ct_loc where CTLOC_Code ='"_WardCode_"'"
	;w sqlStr,!
	s wardAddress=""
	s CTLOCDepDr=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	while(result.Next())
	{
		s CTLOCID=result.Data("CTLOC_RowID")
		s CTLOCDepDr=result.Data("deptDr")
		s wardAddress = $p($g(^CTLOC(CTLOCID,"ADDR","1")),"^",1)
		
	}
	d result.Close()
	
	q "["_wardAddress_"]"_WardDesc_","_CTLOCDepDr
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:可以根据科室组id查询科室组信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组信息
/// Others:w ##class(dhc.qm.udata.uitem3).nameList("","",0,10000,"")  --2015-07-31 update by wy
ClassMethod nameList(sortField, sortDir, start, limit, deptDR) As %String
{
	n (sortField, sortDir, start, limit,deptDR)	
		
	s sqlStr="select DEP_RowId,DEP_Desc from RBC_DepartmentGroup where %ID>'0'"
	i deptDR'="" s sqlStr=sqlStr_" and DEP_RowId='"_deptDR_"'"
			 
			 
	
	
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

/// Creator:wang ying
/// CreatDate:2015-7-31
/// Description:可以根据科室组id查询科室组信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组信息 "'"相连格式
/// Others:w ##class(dhc.qm.udata.uitem3).deptList("2")  
ClassMethod deptList(deptDR) As %String
{
	n (deptDR)	
		
	q:deptDR="" "NodeptDR"
	s sqlStr="select DEP_RowId,DEP_Desc from RBC_DepartmentGroup where %ID>'0'"
	i deptDR'="" s sqlStr=sqlStr_" and DEP_RowId='"_deptDR_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	while(result.Next())
	{
		s groupRowid=result.Data("DEP_RowId")
		s groupName=result.Data("DEP_Desc")	
		
	}
	d result.Close()
	
	q groupName
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:
/// Table:SS_User
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.qm.udata.uitem3).userList("","",0,25)
ClassMethod userList(sortField, sortDir, start, limit) As %String
{
	n (sortField, sortDir, start, limit)	
		
	s sqlStr="select SSUSR_RowId,SSUSR_Name from SS_User where %ID>'0'"
			 
			 
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="grupRowid^grupName" 
	while(result.Next())
	{
		s grupRowid=result.Data("SSUSR_RowId")
		s grupName=result.Data("SSUSR_Name")	
		s tem=grupRowid_"^"_grupName
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
/// CreatDate:2015-5-18
/// Description:可以根据检查项目id获得检查项目信息
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:检查项目信息
/// Others:w ##class(dhc.qm.udata.uitem3).QMSchemList("","",0,25,"1") --2015-07-31 update by wy
ClassMethod QMSchemList(sortField, sortDir, start, limit, qmschemDr) As %String
{
	n (sortField, sortDir, start, limit,qmschemDr)	
		
	s sqlStr="select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem where %ID>'0'"
	i qmschemDr'="" s sqlStr=sqlStr_" and QMSchem_RowID='"_qmschemDr_"'"		 
			 
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="grouRowid^grouName" 
	while(result.Next())
	{
		s grouRowid=result.Data("QMSchem_RowID")
		s grouName=result.Data("QMSchem_name")	
		s tem=grouRowid_"^"_grouName
		i (count>=start)&(count<=limit) d
		.d json.InsertRowData(tem)
		s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator:wang ying
/// CreatDate:2015-7-31
/// Description:根据检查项目id获得检查项目信息
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:检查项目信息
/// Others:w ##class(dhc.qm.udata.uitem3).QMSchem("1") --2015-07-31 update by wy
ClassMethod QMSchem(qmschemDr) As %String
{
	n (qmschemDr)	
		
	q:qmschemDr="" "NoqmschemDr"
	s sqlStr="select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem where %ID>'0'"
	i qmschemDr'="" s sqlStr=sqlStr_" and QMSchem_RowID='"_qmschemDr_"'"		 
			 
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	
	while(result.Next())
	{
		s grouRowid=result.Data("QMSchem_RowID")
		s grouName=result.Data("QMSchem_name")	
		
	}
	d result.Close()
	
	q grouName
}

/// Creator：黄凤杰
/// CreatDate：2015-6-12
/// Description: 修改记录
/// Table： dhc_qm_data.uitem3
/// Input: rowId-数据行号，Cyclecode-年度code，Cyclename-年度名称，Cycleactive-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.qm.udata.uitem3).Update("2","","SFAF")
ClassMethod Update(rowId) As %String
{
	n (rowId)
	&SQL(UPDATE  dhc_qm_data.Plan set Plan_Status=3 where %ID=:rowId)
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate: 2015-6-12
/// Description: 添加功能
/// Table： dhc.qm.udata.uitem2
/// Input: 
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.qm.udata.uitem3).Add("2015-07-20","2015-07-23","1","2015-07-29","	2,3,4,5,6","3,4,7")
ClassMethod Add(CheckStartDate1, CheckEndDate1, user, EndDate, QMSchem, name) As %String [ SqlProc ]
{
	n (CheckStartDate1 , CheckEndDate1, user,EndDate,QMSchem,name)
	
    i CheckStartDate1'="" d
	.s CheckStartDate1=$ZDH(CheckStartDate1,3)
	;W CheckStartDate1,!
	i CheckEndDate1'="" d
	.s CheckEndDate1=$ZDH(CheckEndDate1,3)
	i EndDate'="" d
	.s EndDate=$ZDH(EndDate,3)
	s rowid=0
	s rowid=..IfRepDate(CheckStartDate1)
	q:rowid>0 "RepDate"
	
	s rowid=0
	s rowid=..IfRepuser(user)
	q:rowid>0 "Repuser"
	
	s rowid=0
	s rowid=..IfRepUserStartDate(CheckStartDate1,user)
	q:rowid>0 "RepUserStartDate"
	
	&sql(insert into dhc_qm_data.Plan(Plan_CheckStartDate,Plan_CheckEndDate,Plan_CheckUser,Plan_TaskEndDate,Plan_QMSchemDr,Plan_CheckDepart) values (:CheckStartDate1,:CheckEndDate1,:user,:EndDate,:QMSchem,:name))
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 判断是否重复
/// Table: dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 
/// Others: w ##class(dhc.qm.udata.uCycle).IfRepCode("2")
ClassMethod IfRepDate(CheckStartDate1) As %String
{
	new (CheckStartDate1)
	s rowid=0
	s rowid=$o(^DHCCJXQMPlanI("PlanCheckStartDate",CheckStartDate1,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 判断是否重复
/// Table: dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 
/// Others: w ##class(dhc.qm.udata.uCycle).IfRepCode("2")
ClassMethod IfRepuser(user) As %String
{
	new (user)
	s rowid=0
	s rowid=$o(^DHCCJXQMPlanI("PlanCheckUser",user,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 判断是否重复
/// Table: dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 
/// Others: w ##class(dhc.qm.udata.uCycle).IfRepCode("2")
ClassMethod IfRepUserStartDate(CheckStartDate1, user) As %String
{
	new (CheckStartDate1,user)
	s rowid=0
	s rowid=$o(^DHCCJXQMPlanI("UserStartDate",CheckStartDate1,user,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uitem3S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
