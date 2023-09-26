Class dhc.sync.udata.uConfig Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//数据加密地址配置

/// Description: 用户维护 代码是否存在
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncUser).IfRepCode("2")
ClassMethod IfRepCode(Code) As %String
{
	new (Code)
	s rowid=0
	s rowid=$o(^dhcsyncUserI("SyncUserCode",Code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 用户维护 代码是否存在
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncUser).IfRepCode("2")
ClassMethod IfRepEmail(email) As %String
{
	new (email)
	s rowid=0
	s rowid=$o(^dhcsyncUserI("SyncUserEmail",email,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 根据名称获取用户编码、助记码、序号
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncUser).GetUcode("2")
ClassMethod GetUcode(Name) As %String
{
	n (Name)
	s Mnemonics=""
	s hr=##class(dhc.sync.HRWebServiceSoap).%New()
	d hr.getPYString(Name)
	s Mnemonics = hr.getPYString(Name)
	i $l(Mnemonics)<3 d
	.s Mnemonics=$e(Mnemonics,1)_Mnemonics
	e  i $l(Mnemonics)>3 d
	.s Mnemonics=$e(Mnemonics,1,3)
	;&sql(select max(Sync_Number) into :MaxNo from dhc_sync_data.Sync_User where %id>0 )
	;i MaxNo="" d
	;.;s MaxNo="0001" 
	;e  d 
	;.;s MaxNo=MaxNo+1
	;.;i MaxNo<10 s MaxNo="000"_MaxNo
	;.;e  i (MaxNo>=10)&&(MaxNo<100) s MaxNo="00"_MaxNo
	;.;e  i (MaxNo>=100)&&(MaxNo<1000) s MaxNo="0"_MaxNo
	s MaxNo=$RANDOM(10000)
	i MaxNo<10 s MaxNo="000"_MaxNo
	e  i (MaxNo>=10)&&(MaxNo<100) s MaxNo="00"_MaxNo
	e  i (MaxNo>=100)&&(MaxNo<1000) s MaxNo="0"_MaxNo
	
	s Code=Mnemonics_MaxNo
	s rid=0
	s rid=..IfRepCode(Code)
	q:rid>0 "RepCode"
	
	q Code_"^"_Mnemonics_"^"_MaxNo
}

/// Description: 插入一条新数据
/// Table：dhc_sync_data.Sync_User
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).InsertRec("1","demo group","SwD101|散弹|123QWE!@#|1001|1|srw.san@chccilin.com|2013-09-01|||01|医师|N|Demo Group|100|N|sear|SSD|00001|san|慈林医院|1001|||","24")
ClassMethod InsertRec(userId, uname, data, sysid) As %String
{
	
	n (userId,uname, data,sysid)
	
	s rid=0
	s rid=..IfRepCode(Code)
	q:rid>0 "RepCode"
	
	s id=0
	s id=..IfRepEmail(Email)
	q:id>0 "RepEmail"
		
	
	&sql(insert into dhc_sync_data.Sync_User(Sync_Code, Sync_Name, Sync_Password, Sync_Deptcode,Sync_State,Sync_Email,Sync_InvalidDate,Sync_UpdateDate,Sync_EegDate,Sync_Type,Sync_Mnemonics,Sync_HealthType,Sync_IsExpert,Sync_Secgroup,Sync_Certificate,Sync_ISDrugRight,Sync_Number,Ename,Fname,Company,Position,Dleader,Cellphone,Landline) 
	values(:Code,:Name,:Password,:Deptcode,:State,:Email,:InvalidDate,:UpdateDate,:EegDate,:Type,:Mnemonics,:HealthType,:IsExpert,:Secgroup,:Certificate,:ISDrugRight,:MaxNo,:Ename,:Fname,:Company,:Position,:Dleader,:Cellphone,:Landline))
	q SQLCODE
}

/// Description: 删除记录
/// Table：dhc_sync_data.Sync_User
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.sync.udata.SyncUser).Delete("1","demo group","3","HCG0003")
ClassMethod Delete(userId, uname, Rowid, code) As %String
{
	n (userId,uname,Rowid,code)
	&sql(delete from dhc_sync_data.Sync_User where Sync_Rowid=:Rowid )
	q SQLCODE
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 更新记录
/// Table：dhc_sync_data.Sync_User
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).UpdateRec("1","demo group","284","ZZK0502|周坎|569QWE!@#|30010200|1|kan.zhou@chccilin.com|2013-09-01|||01|药剂士|Y|门诊西药房组员|1|Y|kan|ZZK|293|zhou|慈林医院|医师|serra.Hao||","^24")
ClassMethod UpdateRec(userId, uname, Rowid, data, sysstr) As %String
{
	n (userId,uname,Rowid,data,sysstr)
	
	// code, Name, Password, Deptcode,State,Email,InvalidDate,UpdateDate,EegDate,Type
	// Mnemonics,HealthType,IsExpert,Secgroup,Certificate,ISDrugRight,Number
	k PLIST
	i code   		'="" s Plist(2)= code 
	i Name   		'="" s Plist(3)= Name       	      
	
	&SQL(UPDATE  dhc_sync_data.Sync_User VALUES Plist() where %ID=:Rowid) 
	s ^zlgtem=SQLCODE
	;q SQLCODE
	q 0
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_User
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.SyncUser).List("1","demo group","","","",0,10)
ClassMethod List(userId, uname, name, dcode, type, start, limit) As %String
{
	n (userId,uname,name,dcode,type,start,limit)
	
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户信息维护"
	s ObjectDesc="查询用户信息"
	s NewValue=""
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R",NewValue,userId,uname)
	
	s sqlStr="select Sync_Rowid,Sync_Code, Sync_Name, Sync_Password, Sync_Deptcode,Name,Sync_State,Sync_Email,Sync_InvalidDate,Sync_UpdateDate,Sync_EegDate,Sync_Type,SUT_Name"
	_" ,Sync_Mnemonics,Sync_HealthType,Sync_IsExpert,Sync_Secgroup,Sync_Certificate,Sync_ISDrugRight,Sync_Number,Ename,Fname,Company,Position,Dleader,Cellphone,Landline"
	_" from dhc_sync_data.Sync_User a,dhc_sync_data.Sync_Loc b,dhc_sync_data.Sync_UserType c"
	_" where a.%id>0 and a.Sync_Deptcode=*b.Code and a.Sync_Type=*c.SUT_Code "
	i name'="" 	s sqlStr=sqlStr_" and (Sync_Name like '%"_name_"%' or Sync_Code like '%"_name_"%')"
	i dcode'="" s sqlStr=sqlStr_" and Sync_Deptcode = '"_dcode_"'"
	i type'="" 	s sqlStr=sqlStr_" and Sync_Type = '"_type_"'"
	s sqlStr=sqlStr_" order by Sync_State,Sync_Rowid asc "
	
	;w sqlStr,!
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^Code^Name^Pass^Password^Deptcode^dName^State^Email^InvalidDate^UpdateDate^EegDate^Type^TypeName^Mnemonics^HealthType^IsExpert^Secgroup^Certificate^ISDrugRight^Number^Ename^Fname^Company^Position^Dleader^Cellphone^Landline"
	While(result.Next())
	{  
		s rowid = result.Data("Sync_Rowid")
		s Code=result.Data("Sync_Code")
		s Name=result.Data("Sync_Name")
		s Pass=result.Data("Sync_Password")
		s Password="******"
		s Deptcode=result.Data("Sync_Deptcode")	
		s dName=result.Data("Name")
		s State = result.Data("Sync_State")
		s Email=result.Data("Sync_Email")
		s InvalidDate=result.Data("Sync_InvalidDate")
		s UpdateDate=result.Data("Sync_UpdateDate")
		s EegDate=result.Data("Sync_EegDate")	
		s Type=result.Data("Sync_Type")
		s TypeName=result.Data("SUT_Name")
		s Mnemonics=result.Data("Sync_Mnemonics")
		s HealthType = result.Data("Sync_HealthType")
		s IsExpert=result.Data("Sync_IsExpert")
		s Secgroup=result.Data("Sync_Secgroup")
		s Certificate=result.Data("Sync_Certificate")
		s ISDrugRight=result.Data("Sync_ISDrugRight")
		s Number=result.Data("Sync_Number")
		s Ename=result.Data("Ename")
		s Fname=result.Data("Fname")
		s Company=result.Data("Company")
		s Position=result.Data("Position")
		s Dleader=result.Data("Dleader")
		s Cellphone=result.Data("Cellphone")
		s Landline=result.Data("Landline")
		
		
		s tmp=rowid_"^"_Code_"^"_Name_"^"_Pass_"^"_Password_"^"_Deptcode_"^"_dName_"^"_State_"^"_Email
		_"^"_InvalidDate_"^"_UpdateDate_"^"_EegDate_"^"_Type_"^"_TypeName_"^"_Mnemonics
		_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename
		_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-07-25
/// Description: 修改用户信息时，用户对应的已选系统
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.SyncUser).GetSysCode("ZLG_00005")
ClassMethod GetSysCode(ucode) As %String
{
	n (ucode)
	s sys = ""
	s sqlStr="select a.*,b.Rowid id from dhc_sync_data.Sync_U2SMap a ,dhc_sync_data.Sync_System b"
	_" where a.SystemCode=b.Code and a.UserCode='"_ucode_"' and a.State ='1' "
	_" and b.Active='Y' order by a.Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()    

	s json = ##class(herp.comm.JsonObj).%New()
	s codenames=""
	While(result.Next()){
		s id   = result.Data("id")
		;w Code,!
		s sys=sys_"^"_id
		;w States,!
	}	
	d result.Close()	
	q sys
}

/// Description: 获取安全组名称
/// Table：dhc_sync_data.Sync_Loc
/// Output：
/// Return：安全组字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).Groupname("0","10","")
ClassMethod Groupname(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from SS_Group"
	i str'="" s sqlStr = sqlStr_" where  (LOWER(SSGRP_Desc)  LIKE '%"_str_"%'"_" or  UPPER(SSGRP_Desc) LIKE  '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		//s code = result.Data("SSGRP_RowID")
		s name = result.Data("SSGRP_Desc")
		s tmp=name_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.sync.udata.uConfigS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
