Class dhc.sync.udata.syncU2SMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others：w ##class(dhc.sync.udata.syncU2SMap).Test("HXY1260","OA")
ClassMethod Test(userCode, systemCode) As %String
{
	n (userCode, systemCode)

	
	;&sql(select UserPassword into:password from dhc_sync_data.Sync_UP2SMap where UserCode=:userCode and SystemCode=:systemCode)
	
	s Code="2"
	s Name="张三"
	;s Password="EW40AbMn3XvAtPSv/5c3/kuPGnO5poaqAmDAPUUrlv3Xo8jsCwL2gfgq80CWyRNfZEQb+GESid+A"
	;_"tJ+kwLGHzBRlMaIbBZq5bVk+wUtmJvfro/Rqmivv1hdRE+mTrdIEVqISUmujOFtwBmH3QpoqbTpL"
	;_"jTdsQnmeCjDed3F98EU="
	s Deptcode="102"
	s State="1"
	s Email="zs@sina.com"
	s InvalidDate="2013-07-05"
	s EegDate="2019-07-05"
	s Type="01"
	s checkpass=##class(ext.util.String).%New()
	s ss= checkpass.EvalJSON(password)
	w ss,!
	w $char(password),!
	;s data=Code_"^"_Name_"^"_Password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type
	;s Code="0001" ,Name="临床科室",LocLevel="0",Super="0",State="1",IsLast="N"
	;s data=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_State_"^"_IsLast 
	;s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New()
	;s ss= checkrec.SwitchSystem("D","OA",data)
	
	//s ss= ##class(dhc.oa.UserServiceHttpPort).saveUser("1","2","3","4","5","6","7","8","9")	
	//w ss,!
	q $char(password)
}

/// w ##class(dhc.sync.udata.syncU2SMap).test1()
ClassMethod test1() As %String
{
	s data=""
	s infos="<property name=”Name” value=”课题名称”/><property name=”DeptName” value=”科室”/><property name=”DeptName_CODE” value=”科室”/><property name=”Head”  value=”负责人”/><attachments><attachment name=“文件名” type=“文件类型”>Base64编码</ attachment >……<attachments></data>"			
	s infos=..EvalJSON2(infos)

	s len=$LENGTH(infos,"<property name=")
	F index=2:1:len d
	.s info=$p(infos,"<property name=",index)
	.s valuename=$e($p(info," ",1),2,*-1)
	.s values=$p(info,"=",2)
	.s value=$e(values,2,*-3)
	.i index=len s value=$p(value,"'",1)
	.i valuename="Name" s Name=value
	.i valuename="DeptCode" s DeptCode=value
	.i valuename="HeadCode" s DeptCode=value
	.i valuename="Participants_CODE" s ParticipantsC=value
	.i valuename="RelyUnit" s RelyUnit=value
	.i valuename="AppFunds" s AppFunds=value
	.i valuename="StartDate" s StartDate=value
	.i valuename="EndDate" s EndDate=value
	.i valuename="Remark" s Remark=value
	.i valuename="SubUser_CODE" s SubUserC=value
	.i valuename="SubDate" s SubDate=value
	.i valuename="ConDate" s ConDate=value
	.i valuename="SubNo" s SubNo=value
	.i valuename="SubSource" s SubSource=value
	
	.i data="" s data=valuename_"="_value
	.e  s data=data_"^"_valuename_"="_value
	w data,!
	s SQLCODE=0
	i SQLCODE=0 s rtn="0^成功"
	i SQLCODE'=0 s rtn="1^"_SQLCODE_"保存错误"
	Quit rtn
	q 0
}

/// 对JSON数据字符特殊字符处理
/// JSON 中的特殊字符
/// $c(13)
/// $c(10)
/// \
/// '
ClassMethod EvalJSON2(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr

	s mystr = ..Replace(mystr,$c(34), "'")
	s mystr = ..Replace(mystr,"”", "'")
	s mystr = ..Replace(mystr,"“", "'")	
	
	q mystr
}

/// 对JSON数据字符特殊字符处理
/// JSON 中的特殊字符
/// $c(13)
/// $c(10)
/// \
/// '
ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(91), "'")
	
	s mystr = ..Replace(mystr,$c(93), "'")
	
	s mystr = ..Replace(mystr,"""", "'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

//用户与系统关系维护

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 更新记录
/// Table：dhc_sync_data.Sync_U2SMap
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.syncU2SMap).UpdateRec("1","demo group","3","HCG_00003","1,dataIndex23^")
ClassMethod UpdateRecOld(userId, uname, userid, Code, Systemdesc) As %String
{
	n (userId, uname,userid,Code, Systemdesc)
	s checkinfo=##class(ext.util.String).%New()
	k ^temp
	s ^temp=$lb(userId, uname, userid, Code, Systemdesc)
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s userCode=$list(^dhcsyncUserD(userid),2)
	s userCode=Code,ever="",rtn="",password=""
	k PLIST
	s code=$List(^dhcsyncUserD(userid),2)
	s name=$List(^dhcsyncUserD(userid),3)
	s Deptcode=$List(^dhcsyncUserD(userid),5)
	s State=$List(^dhcsyncUserD(userid),6)
	s Email=$List(^dhcsyncUserD(userid),7)
	s InvalidDate=$List(^dhcsyncUserD(userid),8)
	i $l(InvalidDate,"-")'>1 s InvalidDate=$zd(InvalidDate,3)
	s UpdateDate=$List(^dhcsyncUserD(userid),9)
	i $l(UpdateDate,"-")'>1 s UpdateDate=$zd(UpdateDate,3)
	s EegDate=$List(^dhcsyncUserD(userid),10)
	i $l(EegDate,"-")'>1 s EegDate=$zd(EegDate,3)
	s Type=$List(^dhcsyncUserD(userid),11)
	s Mnemonics=$List(^dhcsyncUserD(userid),12)
	s HealthType=$List(^dhcsyncUserD(userid),13)
	s IsExpert=$List(^dhcsyncUserD(userid),14)
	s Secgroup=$List(^dhcsyncUserD(userid),15)
	s Certificate=$List(^dhcsyncUserD(userid),16)
	s ISDrugRight=$List(^dhcsyncUserD(userid),17)
	s Number=$List(^dhcsyncUserD(userid),18)
	s Ename=$List(^dhcsyncUserD(userid),19)
	s Fname=$List(^dhcsyncUserD(userid),20)
	s Company=$List(^dhcsyncUserD(userid),21)
	s Position=$List(^dhcsyncUserD(userid),22)
	s Dleader=$List(^dhcsyncUserD(userid),23)
	s Cellphone=$List(^dhcsyncUserD(userid),24)
	s Landline=$List(^dhcsyncUserD(userid),25)
	
	s code= checkinfo.EvalJSON(code)
	s name= checkinfo.EvalJSON(name)
	//Mnemonics HealthType IsExpert Secgroup Certificate ISDrugRight Number
	s Len=$L(Systemdesc,"^")
	f k=1:1:Len-1 d
	.s statesys=$p(Systemdesc,"^",k)
	.s state=$p(statesys,",",1)
	
	.s tmpsysid=$p(statesys,",",2)
	.s sysid=$p(tmpsysid,"x",2)
	.s systemCode=$list(^dhcsyncSystemD(sysid),2)

	.i userCode'="" s Plist(2)= userCode 
	.i systemCode'="" s Plist(3)= systemCode       	      
	.i state'="" s Plist(4)= state
	
	.s TableName="dhc_sync_data.Sync_U2SMap"
	.s ClassName="dhc.sync.udata.syncU2SMap"
	.s ClassNameDesc="用户信息同步"
	.s ObjectDesc="修改用户信息同步到系统的信息"
	
	.&SQl(select count(*)into:count from dhc_sync_data.Sync_U2SMap where UserCode=:userCode and SystemCode=:systemCode)
	.i count>0 d
	..s State=3	;修改
	.e  d
	..s State=1	;新增
	
	.i systemCode="PORTAL" d
	..s password=""
	.e  d
	..;&sql(select UserPassword into:password from dhc_sync_data.Sync_UP2SMap where UserCode=:userCode and SystemCode=:systemCode)
	.;s password= checkinfo.EvalJSON(password)
	.s data1=code_"^"_name_"^"_password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	.
	.i (systemCode'="PA")&&(systemCode'="CA") d
	..s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New()
	..s ever=checkrec.SwitchSystem("U",systemCode,data1)
	.s ^hssuser=ever_"_________"_data1
	.s data1=code_"|"_name_"|"_"密码"_"|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	.s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	.s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	.d insertlog.InsertRec(info, userCode, systemCode, data1)
	.s ever=$p(ever,"^",1)
	.i ever="-1" d
	..s rtn="fail"
	.e  d
	..i count>0 d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,userCode_","_systemCode,ObjectDesc,"U",State,userId, uname) 
	...&SQL(UPDATE  dhc_sync_data.Sync_U2SMap VALUES Plist() where UserCode=:userCode and SystemCode=:systemCode) 
	..e  d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,userCode_","_systemCode,ObjectDesc,"A",State,userId, uname) 
	...&sql(insert into dhc_sync_data.Sync_U2SMap (UserCode,SystemCode,State) values(:userCode,:systemCode,:state) )
	..s rtn=SQLCODE
	q rtn
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-06
/// Description: 获取有效的用户
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.syncU2SMap).GetUserCode()
ClassMethod GetUserCode(dcode, date) As %String
{
	n (dcode,date)
	s users = "",user=""
	s sqlStr="select * from dhc_sync_data.Sync_User"
	_" where Sync_State ='1' "
	i dcode'="" s sqlStr=sqlStr_" and Sync_Deptcode='"_dcode_"' "
	i date'="" s sqlStr=sqlStr_" and Sync_InvalidDate='"_date_"'"
	s sqlStr=sqlStr_" and Sync_Rowid>=900 and Sync_Rowid<980"
	s sqlStr=sqlStr_" order by Sync_Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()    

	s json = ##class(herp.comm.JsonObj).%New()
	s codenames=""
	While(result.Next()){
		s Rowid   = result.Data("Sync_Rowid")
		s Code   = result.Data("Sync_Code")
		s user	=Rowid_"*"_Code
		s users=users_"^"_user
		;w States,!
	}	
	s checkinfo=##class(ext.util.String).%New()
	s users= checkinfo.EvalJSON(users)
	d result.Close()	
	q users
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-06
/// Description: 获取系统
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.syncU2SMap).GetSystem()
ClassMethod GetSystem() As %String
{
	
	s rowid= 0
	
	s sqlStr=" select Rowid,Code,Name"
	s sqlStr=sqlStr_" from dhc_sync_data.Sync_System"
	s sqlStr=sqlStr_" where Active='Y' order by Rowid asc "
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="code^name"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0

	While(result.Next()){
		s code=result.Data("Rowid")
		s name=result.Data("Name")
		
		s tmp = code_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 批量处理按钮的方法
/// Table：dhc_sync_data.Sync_U2SMap
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.syncU2SMap).Update("1","demo group","^1*CCJ0018^2*LLD0172^3*YDY0154^4*CCC0173^5*CLD0240^6*XJQ0169^7*LXW0208","24","1")
ClassMethod Update(userId, uname, data, sysid, state) As %String
{
	n (userId, uname,data,sysid, state)
	s checkinfo=##class(ext.util.String).%New()

	k ^temp
	s ^temp=data_"***"_sysid_"***"_state,ever="",rtn="",password=""
	k PLIST
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_U2SMap"
	s ClassName="dhc.sync.udata.syncU2SMap"
	s ClassNameDesc="用户信息同步"
	s ObjectDesc="批量处理用户同步到系统的信息"
	
	;^1*1^2*2^3*3^4*4^5*5^6*6^7*7^8*8^9*9^10*10
	s Len=$L(data,"^")
	f k=2:1:Len d
	.s user=$p(data,"^",k)
	.;w user,"^",k,!
	.s userid=$p(user,"*",1)	
	.s usercode=$p(user,"*",2)
	.s sysCode=$list(^dhcsyncSystemD(sysid),2)
	
	.;w userCode,"^",state,"^",tmpsysid,"^",sysid,"^",systemCode,!
	
	.s code=$List(^dhcsyncUserD(userid),2)
	.s name=$List(^dhcsyncUserD(userid),3)
	.s Deptcode=$List(^dhcsyncUserD(userid),5)
	.s State=$List(^dhcsyncUserD(userid),6)
	.s Email=$List(^dhcsyncUserD(userid),7)
	.s InvalidDate=$List(^dhcsyncUserD(userid),8)
	.i $l(InvalidDate,"-")'>1 s InvalidDate=$zd(InvalidDate,3)
	.s UpdateDate=$List(^dhcsyncUserD(userid),9)
	.i $l(UpdateDate,"-")'>1 s UpdateDate=$zd(UpdateDate,3)
	.s EegDate=$List(^dhcsyncUserD(userid),10)
	.i $l(EegDate,"-")'>1 s EegDate=$zd(EegDate,3)
	.s Type=$List(^dhcsyncUserD(userid),11)
	.s Mnemonics=$List(^dhcsyncUserD(userid),12)
	.s HealthType=$List(^dhcsyncUserD(userid),13)
	.s IsExpert=$List(^dhcsyncUserD(userid),14)
	.s Secgroup=$List(^dhcsyncUserD(userid),15)
	.s Certificate=$List(^dhcsyncUserD(userid),16)
	.s ISDrugRight=$List(^dhcsyncUserD(userid),17)
	.s Number=$List(^dhcsyncUserD(userid),18)
	.s Ename=$List(^dhcsyncUserD(userid),19)
	.s Fname=$List(^dhcsyncUserD(userid),20)
	.s Company=$List(^dhcsyncUserD(userid),21)
	.s Position=$List(^dhcsyncUserD(userid),22)
	.s Dleader=$List(^dhcsyncUserD(userid),23)
	.s Cellphone=$List(^dhcsyncUserD(userid),24)
	.s Landline=$List(^dhcsyncUserD(userid),25)
	.i sysCode="PORTAL" d
	..s password=""
	.e  d
	..;&sql(select UserPassword into:password from dhc_sync_data.Sync_UP2SMap where UserCode=:usercode and SystemCode=:sysCode)
	.s password= checkinfo.EvalJSON(password)
	.s code= checkinfo.EvalJSON(code)
	.s name= checkinfo.EvalJSON(name)
	.&SQl(select count(*)into:count from dhc_sync_data.Sync_U2SMap where UserCode=:usercode and SystemCode=:sysCode)
	.i count>0 d
	..s State=3
	.e  d
	..s State=1	
	.s data1=code_"^"_name_"^"_password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	.i (sysCode'="PA")&&(sysCode'="CA") d
	..s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New()
	..s ever=checkrec.SwitchSystem("U",sysCode,data1)	
	..s data1=code_"|"_name_"|"_"密码"_"|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	..k ^temupdate
	..s ^temupdate=ever_"_____"_data1
	..s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	..s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	..d insertlog.InsertRec(info, usercode, sysCode, data1)
	.i usercode   		'="" s Plist(2)= usercode 
	.i sysCode   		'="" s Plist(3)= sysCode       	      
	.i state  			'="" s Plist(4)= state
	.s ever=$p(ever,"^",1)
	.i ever="-1" d
	..s rtn="fail"
	.e  d
	..i count>0 d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,usercode_","_sysCode,ObjectDesc,"U",State,userId, uname) 
	...&SQL(UPDATE  dhc_sync_data.Sync_U2SMap VALUES Plist() where UserCode=:usercode and SystemCode=:sysCode) 
	..e  d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,usercode_","_sysCode,ObjectDesc,"A",State,userId, uname) 
	...&sql(insert into dhc_sync_data.Sync_U2SMap (UserCode,SystemCode,State) values(:usercode,:sysCode,:state) )
	..s rtn=SQLCODE
	q rtn
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 返回各个系统的状态state
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.syncU2SMap).Getcodename("CCC0173")
ClassMethod Getcodename(UserCode) As %String
{
	n (UserCode)
	s States = ""
	s sqlStr="select b.UserCode,b.SystemCode,b.State,a.Active from dhc_sync_data.Sync_System a"
	_" left join dhc_sync_data.Sync_U2SMap b on a.Code=b.SystemCode and b.UserCode ='"_UserCode_"'"
	s sqlStr=sqlStr_" where a.Active ='Y' order by a.Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s json = ##class(herp.comm.JsonObj).%New()
	s codenames=""
	While(result.Next()){
		s userCode = result.Data("UserCode")
		s systemCode = result.Data("SystemCode")
		s state = result.Data("State")
		;w state,！
		;s codeStates = SystemCode_","_State
		s States=States_"^"_state
		;w States,!
	}	
	d result.Close()
	k json	
	q States
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.syncU2SMap).Getsyscode()
ClassMethod Getsyscode() As %String
{
	s States = ""
	s sqlStr="select * from dhc_sync_data.Sync_System"
	_" where Active ='Y' order by Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()    

	s json = ##class(herp.comm.JsonObj).%New()
	s codenames=""
	While(result.Next()){
		
		s Rowid  = result.Data("Rowid")
		s Rowid  = "dataIndex"_Rowid
		s Code   = result.Data("Code")
		s Name   = result.Data("Name")
		s Active = result.Data("Active")
		;w state,！
		;s codeStates = SystemCode_","_State
		s States=States_"^"_Rowid
		;w States,!
	}	
	d result.Close()	
	q States
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-06
/// Description: 动态标题
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.syncU2SMap).GetGridTitle()
ClassMethod GetGridTitle() As %String
{
	
	s rowid= 0
	
	s sqlStr=" select 'dataIndex'_ Rowid as  IndexName,Name title"
	s sqlStr=sqlStr_" from dhc_sync_data.Sync_System"
	s sqlStr=sqlStr_" where Active='Y' order by Rowid asc "
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^IndexName^title"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	
	d json.InsertRowData("0^Rowid^用户ID")
	d json.InsertRowData("0^Code^用户编码")
	d json.InsertRowData("0^Name^用户名称")
	While(result.Next()){
		s rowid =rowid+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("title")
		
		s tmp = rowid_"^"_dataIndex_"^"_title
		d json.InsertRowData(tmp)
		s count=count+1	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_User
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.syncU2SMap).List("1","demo group","","","",0,25)
ClassMethod List(userId, uname, name, dcode, type, start, limit) As %String
{
	n (userId, uname,name,dcode,type,start,limit)
	
	s TableName="dhc_sync_data.Sync_U2SMap"
	s ClassName="dhc.sync.udata.syncU2SMap"
	s ClassNameDesc="用户信息同步"
	s ObjectDesc="查询用户信息同步到系统的信息"
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R","",userId, uname) 
	//获取系统信息code,name
	s tempjson=..Getsyscode()
	;w tempjson,!
	
	s sqlStr="select a.Sync_Rowid,Sync_Code, Sync_Name,Sync_Type,UserCode from dhc_sync_data.Sync_User a,dhc_sync_data.Sync_U2SMap b "
	_" where a.Sync_Code=b.UserCode and Sync_State=1 "
	i name'="" 	s sqlStr=sqlStr_" and Sync_Name like '%"_name_"%'"
	i dcode'="" s sqlStr=sqlStr_" and Sync_Deptcode = '"_dcode_"'"
	i type'="" 	s sqlStr=sqlStr_" and Sync_Type = '"_type_"'"
	s sqlStr=sqlStr_" group by a.Sync_Code"
	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="Rowid^Code^Name"_tempjson
	;w jsonTitle,!
	s checkinfo=##class(ext.util.String).%New()
	s UserCode=""
	While(result.Next())
	{
		s Rowid=result.Data("Sync_Rowid")
		s Code=result.Data("Sync_Code")
		s Name=result.Data("Sync_Name")
		s UserCode=result.Data("UserCode")
		;w UserCode,!
		
		s Code= checkinfo.EvalJSON(Code)
		s Name= checkinfo.EvalJSON(Name)
		s UserCode= checkinfo.EvalJSON(UserCode)
		s codestatestr= ..Getcodename(UserCode)	
		
		
		s tmp=Rowid_"^"_Code_"^"_Name_codestatestr
		;w tmp,!
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

/// @author :wanghc 
/// 20150116
ClassMethod SyncByUserId(SystemCodes, UserId)
{
	n (SystemCodes,UserId)
	Set UserData = ##class(dhc.sync.udata.SyncUser).GetUserData(UserId)
	Set rtn = ##class(dhc.sync.udata.SyncInterface).Sync("U",SystemCodes,UserData)
	quit:rtn>=0 0
	quit -100_"^SyncError."_rtn
}

/// @author :wanghc
/// 保存同步记录表
/// password为空表示不修改密码
ClassMethod Save(UserCode, SystemCode, SessionUserId, SessionUserName, password = "")
{
	Quit:UserCode="" ""
	Quit:SystemCode="" ""
	Set RowId = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,SystemCode,""))
	If RowId>0 {
		Set Obj = ##class(dhc.sync.data.U2SMap).%OpenId(RowId)
		Set OperateType = "U" ;Upd
		Set State = 3 ;修改
	}Else {
		 Set Obj = ##class(dhc.sync.data.U2SMap).%New()
		 Set Obj.SystemCode = SystemCode
		 Set Obj.UserCode = UserCode
		Set OperateType="A" ;Add
		Set State = 1	;新增
	}
	Set Obj.State = State
	if password'=""{
		;密码加密存入
		Set password1 = ..Enc(password,SystemCode)
		Set Obj.Password = password1
	}
	Set sc = Obj.%Save()
	If $$$ISERR(sc) Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	
	Do ##class(dhc.sync.udata.SyncChangeLog).SaveLog("dhc.sync.data.U2SMap","dhc.sync.udata.syncU2SMap","同步用户" ,
		UserCode_","_SystemCode,"用户同步到系统",OperateType,State,SessionUserId,SessionUserName) 

	Set RowId = Obj.%Id(),Obj=""
	Quit RowId
}

/// Wanghc 
/// 拿用户需求同步的系统代码
ClassMethod GetUserSystemCode(SyncUserId)
{
	Set Rtn="^"
	Q:SyncUserId="" ""
	Set UserCode = $list(^dhcsyncUserD(SyncUserId),2)
	Set SysCode=""
	for {
		Set SysCode = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,SysCode))
		Q:SysCode=""
		Set SysRowId = $O(^dhcsyncSystemI("syncSysCode",SysCode,""))
		Set Active = $Lg(^dhcsyncSystemD(SysRowId))
		Quit:Active="N"
		Set Rtn = Rtn_SysCode_"^"
	}
	Quit Rtn
}

ClassMethod GetAppDir()
{
	Set Config = $o(^websys.ConfigurationD(""))
	Set App = $lg(^websys.ConfigurationD(Config),2)
	If App="" Set App="/dthealth/web"
	Set dir=""
	Set CurNS=$namespace
	zn "%sys"
	if $d(^SYS("Security","ApplicationsD",App),g){
		Set dir = $lg(g,17)_"/key/"
	}else{
		Set App1 = $p(App,"/",1,$l(App,"/")-1)
		if $d(^SYS("Security","ApplicationsD",App1),g){
			Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/"))_"/key/"
		}
	}
	zn CurNS
	Set dir = ##class(%File).NormalizeDirectory(dir)
	Quit dir
}

//加密

ClassMethod Enc(Password, SystemCode)
{
	 Set PK = SystemCode_"_Public.csr"	
	 Set PKeyFile = ##class(%File).NormalizeFilename(..GetAppDir()_PK)
	 if '##class(%File).Exists(PKeyFile) Set flag=-1 quit Password
	 
	 SET password1 = ##class(web.Util.Encryption).RSAEncrypt(Password,PKeyFile)
	 Quit password1
}

//解密

ClassMethod Dec(Password1, SystemCode)
{
     Set SK = SystemCode_"_Privatekey.pem"	
	 Set SKeyFile = ##class(%File).NormalizeFilename(..GetAppDir()_SK)
	 if '##class(%File).Exists(SKeyFile) Set flag=-1 quit Password1
	 SET Password = ##class(web.Util.Encryption).RSADecrypt(Password1,SKeyFile)
	 Quit Password
}

Storage Default
{
<Data name="syncU2SMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhcsyncsyncU2SMapD</DataLocation>
<DefaultData>syncU2SMapDefaultData</DefaultData>
<IdLocation>^dhcsyncsyncU2SMapD</IdLocation>
<IndexLocation>^dhcsyncsyncU2SMapI</IndexLocation>
<StreamLocation>^dhcsyncsyncU2SMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
