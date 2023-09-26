Class dhc.qm.udata.uPlanArrange Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 查询符合条件的记录
/// Table: dhc.qm.udata.uPlanArrange
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uPlanArrange).List("","",0,15,"","","")  --2015-07-31 update by wy
ClassMethod List(sortField, sortDir, start, limit, CheckStartDate, CheckEndDate, userDr) As %String
{
	n (sortField,sortDir,start,limit,CheckStartDate,CheckEndDate,userDr)
	
	;q:status="" "Nostatus"
	;q:userDr="" "NoUser"
	s sqlStr="SELECT Plan_rowid,Plan_CycleDr,Plan_period,Plan_Title,Plan_CheckStartDate,Plan_CheckEndDate, Plan_TaskStartDate, Plan_TaskEndDate, Plan_QMSchemDr, Plan_CheckUser, Plan_CheckDepart, Plan_Status FROM dhc_qm_data.Plan where 1=1"
	i CheckStartDate '="" s CheckStartDate=$zdh(CheckStartDate,3) s sqlStr=sqlStr_" and Plan_CheckStartDate >='"_CheckStartDate_"'"
	i CheckEndDate '="" s CheckEndDate=$zdh(CheckEndDate,3) s sqlStr=sqlStr_"and Plan_CheckEndDate <='"_CheckEndDate_"'"
    i userDr'="" s sqlStr=sqlStr_" and Plan_CheckUser='"_userDr_"'"
    s sqlStr=sqlStr_" and (Plan_Status!=3 OR Plan_Status IS  null) order by Plan_rowid asc"
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="Rowid^Title^qmschemDr^qmschemName^deptGroupDr^deptGroupName^CheckStartDate^CheckEndDate^taskStart^taskEndData^checkUser^checkUserName^status^statusName"
	While(result.Next())
	{   
		s qmschemName="",deptGroupName="",statusName="",checkUserName=""
		s Rowid= result.Data("Plan_rowid")
		s Title= result.Data("Plan_Title")
		s qmschemDr = result.Data("Plan_QMSchemDr")
		i qmschemDr'="" d
		.s len=$l(qmschemDr,",")
		.f i=1:1:len  d
		..i qmschemName'="" s qmschemName=..QMSchem($p(qmschemDr,",",i))_","_qmschemName
		..e  s qmschemName=..QMSchem($p(qmschemDr,",",i))
		s deptGroupDr= result.Data("Plan_CheckDepart")
		i deptGroupDr'="" d
		.s deptlen=$l(deptGroupDr,",")
		.f j=1:1:deptlen  d
		..;i deptGroupName'="" s deptGroupName=..deptList($p(deptGroupDr,",",j))_","_deptGroupName
		..;e  s deptGroupName=..deptList($p(deptGroupDr,",",j))
		..i deptGroupName'="" s deptGroupName=..WardList($p(deptGroupDr,",",j))_","_deptGroupName
		..e  s deptGroupName=..WardList($p(deptGroupDr,",",j))
		s CheckStartDate= result.Data("Plan_CheckStartDate")
		s CheckStartDate=##class(websys.Conversions).DateLogicalToHtml(CheckStartDate) ;$zd(CheckStartDate,3)
		s CheckEndDate= result.Data("Plan_CheckEndDate")
		s CheckEndDate=##class(websys.Conversions).DateLogicalToHtml(CheckEndDate) ;$zd(CheckEndDate,3)
		s taskStart= result.Data("Plan_TaskStartDate")
		s taskStart=##class(websys.Conversions).DateLogicalToHtml(taskStart) ;$zd(taskStart,3)
		s taskEnd= result.Data("Plan_TaskEndDate")
		s taskEndData=##class(websys.Conversions).DateLogicalToHtml(taskEnd) ;$zd(taskEnd,3)
		s CheckUser= result.Data("Plan_CheckUser")
		i CheckUser'="" d
		.s checkUserName = $p($g(^SSU("SSUSR",CheckUser)),"^",2)
		s Status= result.Data("Plan_Status")
		i Status'="" d
		.i Status=0 s statusName="未完成"
		.i Status=1 s statusName="完成"
		.i Status=3 s statusName="作废"
		
	//s IsValid= result.Data("org_affi_IsValid")
		 s tmp=Rowid_"^"_Title_"^"_qmschemDr_"^"_qmschemName_"^"_deptGroupDr_"^"_deptGroupName
		       _"^"_CheckStartDate_"^"_CheckEndDate_"^"_taskStart_"^"_taskEndData_"^"_CheckUser_"^"_checkUserName_"^"_Status_"^"_statusName
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:可以根据科室组id查询科室组信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组信息
/// Others:w ##class(dhc.qm.udata.uPlanArrange).nameList("","",0,10000,"")  --2015-07-31 update by wy
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
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="groupRowid^groupName" 
	while(result.Next())
	{
		s groupRowid=result.Data("DEP_RowId")
		s groupName=result.Data("DEP_Desc")	
		s tem=groupRowid_"^"_groupName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		
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
/// Others:w ##class(dhc.qm.udata.uPlanArrange).deptList("2")  
ClassMethod deptList(deptDR) As %String
{
	n (deptDR)	
		
	q:deptDR="" "NodeptDR"
	s sqlStr="select DEP_RowId,DEP_Desc from RBC_DepartmentGroup where %ID>'0'"
	i deptDR'="" s sqlStr=sqlStr_" and DEP_RowId='"_deptDR_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s groupName=""
	while(result.Next())
	{
		s groupRowid=result.Data("DEP_RowId")
		s groupName=result.Data("DEP_Desc")	
		
	}
	d result.Close()
	
	q groupName
}

/// Creator:wang ying
/// CreatDate:2015-7-31
/// Description:可以根据科室组id查询科室组信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组信息 "'"相连格式
/// Others:w ##class(dhc.qm.udata.uPlanArrange).WardList("20")  
ClassMethod WardList(WardDR) As %String
{
	n (WardDR)	
		
	q:WardDR="" "NoWardDR"
	s sqlStr="select WARD_RowID,WARD_Desc from PAC_Ward where %ID>'0'"
	i WardDR'="" s sqlStr=sqlStr_" and  WARD_RowID='"_$p(WardDR,"||",1)_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s groupName=""
	while(result.Next())
	{
		s groupRowid=result.Data("WARD_RowID")
		s groupName=result.Data("WARD_Desc")
		i $p(groupName,"-",2)'="" s groupName=$p(groupName,"-",2)	
		
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
/// Others:w ##class(dhc.qm.udata.uPlanArrange).userList("","",0,25)
ClassMethod userList(sortField, sortDir, start, limit, str) As %String
{
	n (sortField, sortDir, start, limit,str)	
		
	s sqlStr="select SSUSR_RowId,SSUSR_Name,SSUSR_Initials from SS_User where %ID>'0'"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name like '"_str_"%'"		 
			 
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="grupRowid^grupName" 
	while(result.Next())
	{
		s grupRowid=result.Data("SSUSR_RowId")
		s grupName=result.Data("SSUSR_Name")
		s logName = result.Data("SSUSR_Initials")	
		s tem=grupRowid_"^"_logName_"-"_grupName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		
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
/// Others:w ##class(dhc.qm.udata.uPlanArrange).QMSchemList("","",0,25,"1") --2015-07-31 update by wy
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
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="grouRowid^grouName" 
	while(result.Next())
	{
		s grouRowid=result.Data("QMSchem_RowID")
		s grouName=result.Data("QMSchem_name")	
		s tem=grouRowid_"^"_grouName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator:wang ying
/// CreatDate:2015-12-2
/// Description:可以根据检查项目id获得检查项目信息
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:检查项目信息
/// Others:w ##class(dhc.qm.udata.uPlanArrange).QMSchemList("","",0,25,"1") --2015-07-31 update by wy
ClassMethod QMSchemList1(sortField, sortDir, start, limit, qmschemDr) As %String
{
	n (sortField, sortDir, start, limit,qmschemDr)	
		
	s sqlStr="select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem where %ID>'0' and QMSchem_importType=1"
	i qmschemDr'="" s sqlStr=sqlStr_" and QMSchem_RowID='"_qmschemDr_"'"		 
			 
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="grouRowid^grouName" 
	while(result.Next())
	{
		s grouRowid=result.Data("QMSchem_RowID")
		s grouName=result.Data("QMSchem_name")	
		s tem=grouRowid_"^"_grouName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		
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
/// Others:w ##class(dhc.qm.udata.uPlanArrange).QMSchem("1") --2015-07-31 update by wy
ClassMethod QMSchem(qmschemDr) As %String
{
	n (qmschemDr)	
		
	q:qmschemDr="" "NoqmschemDr"
	s sqlStr="select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem where %ID>'0'"
	i qmschemDr'="" s sqlStr=sqlStr_" and QMSchem_RowID='"_qmschemDr_"'"		 
			 
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s grouName=""
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
/// Table： dhc_qm_data.uPlanArrange
/// Input: rowId-数据行号，Cyclecode-年度code，Cyclename-年度名称，Cycleactive-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.qm.udata.uPlanArrange).Update("2","","SFAF")
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
/// Others:w ##class(dhc.qm.udata.uPlanArrange).Add("绩效考核","2016","201604","2016-03-08","2016-03-24","1","2016-03-13","2016-03-25","1,2,3,4,5,6,7,8,9","33||18,45||20,1||27,124||27,43||20,44||20,46||20,2||27")
ClassMethod Add(title, CycleDr, period, CheckStartDate1, CheckEndDate1, user, StartDate, EndDate, QMSchem, name) As %String [ SqlProc ]
{
	n (title,CycleDr,period,CheckStartDate1,CheckEndDate1, user,StartDate,EndDate,QMSchem,name)
	;s ^shhgjjgjhrtem = CheckStartDate1
    i CheckStartDate1'="" d
	.s CheckStartDate1=$ZDH(CheckStartDate1,3)
	;W CheckStartDate1,!
	i CheckEndDate1'="" d
	.s CheckEndDate1=$ZDH(CheckEndDate1,3)
	i StartDate'="" d
	.s StartDate=$ZDH(StartDate,3)
	i EndDate'="" d
	.s EndDate=$ZDH(EndDate,3)
	/*s rowid=0
	s rowid=..IfRepDate(CheckStartDate1)
	q:rowid>0 "RepDate"
	
	s rowid=0
	s rowid=..IfRepuser(user)
	q:rowid>0 "Repuser"*/
	
	s rowid=0
	;s rowid=..IfRepUserStartDate(user,CheckStartDate1)
	;b
	q:rowid>0 "RepUserStartDate"
	s depWard=$ZSTRIP(name,"<>","^")
	&sql(insert into dhc_qm_data.Plan(Plan_Title,Plan_CycleDr,Plan_period,Plan_CheckStartDate,Plan_CheckEndDate,Plan_CheckUser,Plan_TaskStartDate,Plan_TaskEndDate,Plan_QMSchemDr,Plan_Status,Plan_CheckDepart) values (:title,:CycleDr,:period,:CheckStartDate1,:CheckEndDate1,:user,:StartDate,:EndDate,:QMSchem,'0',:depWard))
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
/// Others: w ##class(dhc.qm.udata.uPlanArrange).IfRepUserStartDate("5681","63704")
ClassMethod IfRepUserStartDate(user, CheckStartDate1) As %String
{
	new (user,CheckStartDate1)
	s rowid=0
	s rowid=$o(^DHCCJXQMPlanI("UserStartDate",user,CheckStartDate1,rowid))
	i rowid="" d  s rowid=0
	i (rowid'="")&&(rowid'=0) d
	.s status=$LIST(^DHCCJXQMPlanD(rowid),10)
	.i status=3  s rowid=0
	q rowid
}

/// Creator: ban
/// CreatDate:2015-10-30
/// Description: 查询符合条件的记录
/// Table: dhc.qm.udata.uPlanArrange
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uPlanArrange).PlanListDetail("","",0,15,"","",3901,1)
ClassMethod PlanListDetail(sortField, sortDir, start, limit, CheckStartDate, CheckEndDate, userDr, status) As %String
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
	
	
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^title^qmschemDr^qmschemName^deptGroupDr^deptGroupName^checkStard^checkEnd^taskStard^taskEnd^checkUser^checkUserName^status^statusName^period^hasCheckNum^noCheckNum"
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
		.s deptWardNames=""
		.s deptWardIDs =""
		.f j=1:1:wardlen  d
		..s AddressNew=""
		..s wardDr = $p(wardDrs,",",j)
		..s wardInfos =..getWardInfosById(wardDr)
		..s wardDeptAddress=$p(wardInfos,",",1)
		..s AddressNew = $p(wardDeptAddress,"-",1)
		..i AddressNew="" s AddressNew ="无楼层信息"
		..s wardDeptNew = $p(wardDeptAddress,"-",2,3)
		..s wardDrNew = $REPLACE(wardDr,"||","aa")
		..;b
		..s ^TMPDHCCJXPADADDRESS($j,AddressNew,wardDrNew)=wardDeptNew
		..s wardName = $p(wardInfos,",",1)
		..i AddressNew="无楼层信息" s wardName =AddressNew_""_wardName
		..s deptDr = $p(wardInfos,",",2)
		..s deptWardDr = deptDr_"#"_$p(wardDr,"||",1)
		..i deptWardNames'="" s deptWardNames = deptWardNames _","_ wardName
		..e  s deptWardNames = wardName
		..i deptWardIDs'="" s deptWardIDs = deptWardIDs _","_ deptWardDr
		..e  s deptWardIDs = deptWardDr
		..;i Rowid=10 b
		s deptwardNameIdNews=""
		s AddressNew=""
   		f  s AddressNew=$o(^TMPDHCCJXPADADDRESS($j,AddressNew)) q:AddressNew=""  d
    	.s deptDrNew="",deptwardNameIdNew=""
    	.f  s deptDrNew=$o(^TMPDHCCJXPADADDRESS($j,AddressNew,deptDrNew)) q:deptDrNew=""  d
    	..s deptwardNameNew=""
    	..s deptwardNameNew=$p($g(^TMPDHCCJXPADADDRESS($j,AddressNew,deptDrNew)),"^",1)
    	..s isCheck=0
    	..s isCheck=##class(dhc.qm.udata.uComm).WarIsChecked(Rowid,$p(deptDrNew,"aa",1),$p(deptDrNew,"aa",2))
    	..i deptwardNameIdNew'="" s deptwardNameIdNew=deptwardNameIdNew_"#"_deptwardNameNew_"@"_deptDrNew_"aa"_isCheck
    	..e  s deptwardNameIdNew=deptwardNameNew_"@"_deptDrNew_"aa"_isCheck
    	.i deptwardNameIdNews'="" s deptwardNameIdNews=deptwardNameIdNews_";"_AddressNew_"@"_deptwardNameIdNew
    	.e  s deptwardNameIdNews=AddressNew_"@"_deptwardNameIdNew
    	
		s checkNum = ##class(dhc.qm.udata.uPlan).getWardNum("","",Rowid)
		s hasCheckNum = $p(checkNum,"^",2)
		s noCheckNum = $p(checkNum,"^",1)
		;w hasCheckNum_" -- "_noCheckNum,!
		;s deptGroupDr = $p(deptWardIDs,",",2,deptWardIDLen)
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
		s tmp=Rowid_"^"_Title_"^"_qmschemDr_"^"_qmschemName_"^"_deptWardIDs_"^"_deptwardNameIdNews
		       _"^"_CheckStartDate_"^"_CheckEndDate_"^"_taskStart_"^"_taskEndData_"^"_CheckUser_"^"_checkUserName_"^"_Status_"^"_statusName_"^"_period_"^"_hasCheckNum_"^"_noCheckNum
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json,^TMPDHCCJXPADADDRESS($j)
	q resultString
}

/// Creator:ban
/// CreatDate:2015-10-30
/// Description:可以根据病区id获取 ct_loc表中科室的id和病房的位置
/// Table:ct_loc 
/// Output:
/// Return:返回科室的id和病房的位置  即地址
/// Others:w ##class(dhc.qm.udata.uPlanArrange).getWardInfosById("43||20")  
ClassMethod getWardInfosById(ward) As %String
{
	n (ward)	
		
	q:ward="" "Noward"
	s wardRowid=$p(ward,"||",1)
	s deptGroup=$p(ward,"||",2)
	;w deptGroup,!
	s WardCode=$P(^PAWARD(wardRowid),"^",1)
	s WardDesc=$P(^PAWARD(wardRowid),"^",2)
    if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
	
	s sqlStr="select CTLOC_RowID from ct_loc where CTLOC_Code ='"_WardCode_"'"
	;w sqlStr,!
	s wardAddress=""
	s CTLOCDepDr="",Department=""
	i deptGroup'="" s Department=$P(^RBC("DEP",deptGroup),"^",2)  //科室组
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	while(result.Next())
	{
		s CTLOCID=result.Data("CTLOC_RowID")
		s wardAddress = $p($g(^CTLOC(CTLOCID,"ADDR","1")),"^",1)
		
	}
	
	d result.Close()
	q wardAddress_"-"_Department_"-"_WardDesc_","_deptGroup
}

/// Creator:ban
/// CreatDate:2015-10-26
/// Description:可以根据科室组id查询科室组下的病区信息
/// Table:RBC_DepartmentGroup
/// Output:
/// Return:返回科室组下的病区名称
/// Others:w ##class(dhc.qm.udata.uPlanArrange).getWardByDeptID(20) 
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

/// Creator: ban
/// CreatDate:2015-11-23
/// Description: 根据planDr获取病区的相关信息
/// Table: dhc_qm_data.Plan
/// Input: planDr-计划id
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uPlanArrange).PlanWardListDetail(15)
ClassMethod PlanWardListDetail(planDr) As %String
{
	n (planDr)
	q:planDr="" "NoplanDr"
	s sqlStr="SELECT Plan_CheckDepart FROM dhc_qm_data.Plan where Plan_rowid='"_planDr_"'"
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="deptwardName"
	While(result.Next())
	{   
		s qmschemName="",deptGroupNames="",statusName="",checkUserName=""
		s wardDrs= result.Data("Plan_CheckDepart")
		i wardDrs'="" d
		.s wardlen=$l(wardDrs,",")
		.s deptWardNames=""
		.s deptWardIDs =""
		.f j=1:1:wardlen  d
		..s AddressNew=""
		..s wardDr = $p(wardDrs,",",j)
		..s wardInfos =..getWardInfosById(wardDr)
		..s wardDeptAddress=$p(wardInfos,",",1)
		..s AddressNew = $p(wardDeptAddress,"-",1)
		..i AddressNew =""  s AddressNew="未维护楼层信息"  //增加楼层未维护的处理
		..s wardDeptNew = $p(wardDeptAddress,"-",2,3)
		..s wardDrNew = $REPLACE(wardDr,"||","aa")
		..s ^TMPDHCCJXPADADDRESS($j,AddressNew,wardDrNew)=wardDeptNew
		s deptwardNameIdNews=""
		s AddressNew=""
   		f  s AddressNew=$o(^TMPDHCCJXPADADDRESS($j,AddressNew)) q:AddressNew=""  d
    	.s deptDrNew="",deptwardNameIdNew=""
    	.f  s deptDrNew=$o(^TMPDHCCJXPADADDRESS($j,AddressNew,deptDrNew)) q:deptDrNew=""  d
    	..s deptwardNameNew=""
    	..s deptwardNameNew=$p($g(^TMPDHCCJXPADADDRESS($j,AddressNew,deptDrNew)),"^",1)
    	..s isCheck=0
    	..s isCheck=##class(dhc.qm.udata.uComm).WarIsChecked(planDr,$p(deptDrNew,"aa",1),$p(deptDrNew,"aa",2))
    	..i deptwardNameIdNew'="" s deptwardNameIdNew=deptwardNameIdNew_"#"_deptwardNameNew_"@"_deptDrNew_"aa"_isCheck
    	..e  s deptwardNameIdNew=deptwardNameNew_"@"_deptDrNew_"aa"_isCheck
    	.i deptwardNameIdNews'="" s deptwardNameIdNews=deptwardNameIdNews_AddressNew_"@"_deptwardNameIdNew_";"
    	.e  s deptwardNameIdNews=AddressNew_"@"_deptwardNameIdNew_";"
    	s resultString = "{deptwardName:'"_deptwardNameIdNews_"'}"
		s tmp=deptwardNameIdNews
		d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	;s resultString = json.getJsonData(jsonTitle,count)
	;s resultString = "{deptwardName:'"_deptwardNameIdNews_"'}"
 	k json,^TMPDHCCJXPADADDRESS($j)
	q resultString
}

/// Creator：初雅莉
/// CreatDate：2016-6-30
/// Description: 修改记录
/// Table：dhc_qm_data.Plan 
/// Input: rowId-数据行号
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.qm.udata.uPlanArrange).UpdateRecord("2","","SFAF")
ClassMethod UpdateRecord(title, CycleDr, period, CheckStartDate1, CheckEndDate1, user, StartDate, EndDate, QMSchem, name, rowid) As %String [ SqlProc ]
{
	n (title,CycleDr,period,CheckStartDate1,CheckEndDate1, user,StartDate,EndDate,QMSchem,name,rowid)
	
    i CheckStartDate1'="" d
	.s CheckStartDate1=$ZDH(CheckStartDate1,3)

	i CheckEndDate1'="" d
	.s CheckEndDate1=$ZDH(CheckEndDate1,3)
	i StartDate'="" d
	.s StartDate=$ZDH(StartDate,3)
	i EndDate'="" d
	.s EndDate=$ZDH(EndDate,3)
	
	s updataSql="UPDATE dhc_qm_data.Plan "
				_" SET Plan_Title = '"_title_"' "
				_" 	, Plan_CheckStartDate = '"_CheckStartDate1_"'"
				_" 	, Plan_CheckEndDate = '"_CheckEndDate1_"'"
				_" 	, Plan_TaskStartDate = '"_StartDate_"'"
				_" 	, Plan_TaskEndDate = '"_EndDate_"'"
					_" 	, Plan_CycleDr = '"_CycleDr_"'"
				_" 	, Plan_period = '"_period_"'"
			
				;_" 	, 2Plan_Status = 0 "
			
	if (user'="")  s updataSql=updataSql_" 	, Plan_CheckUser ="_user
	if (QMSchem'="")&&(QMSchem'="undefined")  s updataSql=updataSql_" 	, Plan_QMSchemDr = '"_QMSchem_"' "
	if (name'="")&&(name'="undefined")   s updataSql=updataSql_" 	, Plan_CheckDepart = '"_$ZSTRIP(name,"<>","^")_"' "
				
    s updataSql=updataSql_" WHERE Plan_rowid ="_rowid
    s updataSql=$replace(updataSql,$c(9),"")
	SET tStatement = ##class(%SQL.Statement).%New(0,"Sample")
    SET status = tStatement.%Prepare(updataSql)
    SET rtn = tStatement.%Execute()
	s sqlCode=rtn.%SQLCODE
	
	q sqlCode
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uPlanArrangeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
