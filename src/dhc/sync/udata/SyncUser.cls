Class dhc.sync.udata.SyncUser Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// @author : wanghc
/// 2015-01-16
ClassMethod GetUserData(UserId)
{
	s userCode=$list(^dhcsyncUserD(UserId),2)
	s name=$List(^dhcsyncUserD(UserId),3)
	s password=$List(^dhcsyncUserD(UserId),4)
	s Deptcode=$List(^dhcsyncUserD(UserId),5)
	s State=$List(^dhcsyncUserD(UserId),6)
	s Email=$List(^dhcsyncUserD(UserId),7)
	s InvalidDate=$List(^dhcsyncUserD(UserId),8)
	s UpdateDate=$List(^dhcsyncUserD(UserId),9)
	s EegDate=$List(^dhcsyncUserD(UserId),10)
	s Type=$List(^dhcsyncUserD(UserId),11)
	s Mnemonics=$List(^dhcsyncUserD(UserId),12)
	s HealthType=$List(^dhcsyncUserD(UserId),13)
	s IsExpert=$List(^dhcsyncUserD(UserId),14)
	s Secgroup=$List(^dhcsyncUserD(UserId),15)
	s Certificate=$List(^dhcsyncUserD(UserId),16)
	s ISDrugRight=$List(^dhcsyncUserD(UserId),17)
	s Number=$List(^dhcsyncUserD(UserId),18)
	s Ename=$List(^dhcsyncUserD(UserId),19)
	s Fname=$List(^dhcsyncUserD(UserId),20)
	s Company=$List(^dhcsyncUserD(UserId),21)
	s Position=$List(^dhcsyncUserD(UserId),22)
	s Dleader=$List(^dhcsyncUserD(UserId),23)
	s Cellphone=$List(^dhcsyncUserD(UserId),24)
	s Landline=$Listget(^dhcsyncUserD(UserId),25)
	S PasswordDate =$Listget(^dhcsyncUserD(UserId),26)
	If PasswordDate'="" Set PasswordDate=$zd(PasswordDate,3)
	s userCode= ##class(ext.util.String).EvalJSON(userCode)
	s name= ##class(ext.util.String).EvalJSON(name)
	s password=##class(ext.util.String).EvalJSON(password)
	//Mnemonics HealthType IsExpert Secgroup Certificate ISDrugRight Number
	s userData=userCode_"^"_name_"^"_password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline_"^"_PasswordDate
	q userData
}

//用户维护

/// Description: 用户维护 代码是否存在
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncUser).test("郝珊珊","3","MB")
ClassMethod test(name, MaxNo, Mnemonics) As %String
{
	n (name,MaxNo,Mnemonics)
	/*;s hr=##class(dhc.sync.HRWebServiceSoap).%New()
	;d hr.getPYString(name)
	;w hr.getPYString(name),"^"
	i $l(Mnemonics)<3 d
	.s Mnemonics=$e(Mnemonics,1)_Mnemonics
	w Mnemonics,!
	i MaxNo="" d
	.s MaxNo="0001" 
	e  d 
	.s MaxNo=MaxNo+1
	.i MaxNo<10 s MaxNo="000"_MaxNo
	.e  i (MaxNo>=10)&&(MaxNo<100) s MaxNo="00"_MaxNo
	.e  i (MaxNo>=100)&&(MaxNo<1000) s MaxNo="0"_MaxNo
	w MaxNo,!*/
	//返回一个0-25之间的整数
	WRITE $RANDOM(25)
	
	
	w a,!
	
	
	q 0
}

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
	s Mnemonics = $SYSTEM.SQL.UPPER(Mnemonics)
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
ClassMethod InsertRecOld(userId, uname, data, sysid) As %String
{
	
	n (userId,uname, data,sysid)
	s data1="",ever="",syscode=""
	s Code            	=$p(data,"|",1)
	s Name              =$p(data,"|",2) 
	s Password          =$p(data,"|",3)
	s Deptcode         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s Email           	=$p(data,"|",6)
	s InvalidDate       =$p(data,"|",7)
	s updateDate	    =$p(data,"|",8)
	s EegDate          	=$p(data,"|",9)
	s Type				=$p(data,"|",10)
	s HealthType        =$p(data,"|",11)
	s IsExpert         	=$p(data,"|",12)
	s Secgroup          =$p(data,"|",13)
	s Certificate       =$p(data,"|",14)
	s ISDrugRight       =$p(data,"|",15)
	s Ename				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	s MaxNo				=$p(data,"|",18)
	s Fname				=$p(data,"|",19)
	s Company			=$p(data,"|",20)
	s Position			=$p(data,"|",21)
	s Dleader			=$p(data,"|",22)
	s Cellphone			=$p(data,"|",23)
	s Landline			=$p(data,"|",24)
	s UpdateDate=$zd($p($h,",",1),3)
	
	s rid=0
	s rid=..IfRepCode(Code)
	q:rid>0 "RepCode"
	
	s id=0
	s id=..IfRepEmail(Email)
	q:id>0 "RepEmail"
		
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户信息维护"
	s ObjectDesc="插入新的用户"
	s NewValue="Code："_Code
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"A",NewValue,userId,uname)
	//Mnemonics,HealthType,IsExpert,Secgroup,Certificate,ISDrugRight,Number
	&sql(insert into dhc_sync_data.Sync_User(Sync_Code, Sync_Name, Sync_Password, Sync_Deptcode,Sync_State,Sync_Email,Sync_InvalidDate,Sync_UpdateDate,Sync_EegDate,Sync_Type,Sync_Mnemonics,Sync_HealthType,Sync_IsExpert,Sync_Secgroup,Sync_Certificate,Sync_ISDrugRight,Sync_Number,Ename,Fname,Company,Position,Dleader,Cellphone,Landline) 
	values(:Code,:Name,:Password,:Deptcode,:State,:Email,:InvalidDate,:UpdateDate,:EegDate,:Type,:Mnemonics,:HealthType,:IsExpert,:Secgroup,:Certificate,:ISDrugRight,:MaxNo,:Ename,:Fname,:Company,:Position,:Dleader,:Cellphone,:Landline))
	q SQLCODE
}

/// Description: 添加页面选择多个系统时调用
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.SyncUser).Inserts("2","^his^oa^hr^pa")
ClassMethod Inserts(data, sysids) As %String
{
	n (data,sysids)
	s rtn="",sysid=""
	s len=$l(sysids,"^")
	f i=2:1:len d
	.s sysid=$p(sysids,"^",i)
	.s hr=##class(dhc.sync.udata.SyncUser).%New()
	.s rtn=..InsertU2S(data,sysid)
	q rtn
}

/// Description: 插入一条新数据
/// Table：dhc_sync_data.Sync_User
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).InsertRec("1","demo group","SwD101|散弹|123QWE!@#|1001|1|srw.san@chccilin.com|2013-09-01|||01|医师|N|Demo Group|100|N|sear|SSD|00001|san|慈林医院|1001|||","24")
ClassMethod InsertU2S(data, sysid) As %String
{
	
	n (data,sysid)
	s data1="",ever="",syscode=""
	s Code            	=$p(data,"|",1)
	s Name              =$p(data,"|",2) 
	s Password          =$p(data,"|",3)
	s Deptcode         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s Email           	=$p(data,"|",6)
	s InvalidDate       =$p(data,"|",7)
	s updateDate	    =$p(data,"|",8)
	s EegDate          	=$p(data,"|",9)
	s Type				=$p(data,"|",10)
	s HealthType        =$p(data,"|",11)
	s IsExpert         	=$p(data,"|",12)
	s Secgroup          =$p(data,"|",13)
	s Certificate       =$p(data,"|",14)
	s ISDrugRight       =$p(data,"|",15)
	s Ename				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	s MaxNo				=$p(data,"|",18)
	s Fname				=$p(data,"|",19)
	s Company			=$p(data,"|",20)
	s Position			=$p(data,"|",21)
	s Dleader			=$p(data,"|",22)
	s Cellphone			=$p(data,"|",23)
	s Landline			=$p(data,"|",24)
	s UpdateDate=$zd($p($h,",",1),3)

	i sysid'="" s syscode=$list(^dhcsyncSystemD(sysid),2)
	i syscode'="" d
	.;&sql(select UserPassword into:password from dhc_sync_data.Sync_UP2SMap where UserCode=:Code and SystemCode=:syscode)
    .s rowid=$D(^dhcsyncU2SMapI("U2SMapIndex",Code,syscode))
	.i (rowid=10)||(rowid=0) d
	..s data1=Code_"^"_Name_"^"_password_"^"_Deptcode_"^"_1_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_MaxNo_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	..i (syscode'="PA")&&(syscode'="CA") d
	...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;1表添加状态	
	...s ever=checkrec.SwitchSystem("U",syscode,data1)
	...s data1=Code_"|"_Name_"|"_"密码"_"|"_Deptcode_"|"_1_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_MaxNo_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	...s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	...s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	...d insertlog.InsertRec($e(info,0,22), Code, syscode, data1)
	...i $p(ever,"^",1)'="-1" d
	....&sql(insert into dhc_sync_data.Sync_U2SMap (UserCode,SystemCode,State) values(:Code,:syscode,1))	
	..e  d
	...&sql(insert into dhc_sync_data.Sync_U2SMap (UserCode,SystemCode,State) values(:Code,:syscode,1))	
	
	s ^hssupuser=ever_"____"_data1
	q:($p(ever,"^",1)="-1") "fail"_"_"_syscode
	
	q 0
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
	s id="",rowid="",ever="",data1=""	
	s dcode=$list(^dhcsyncUserD(Rowid),5)
	
	f  s id=$o(^dhcsyncU2SMapI("U2SUcodeIndex",code,id))  q:id=""  d 
	.s U2Smap=##Class(dhc.sync.data.U2SMap).%OpenId(id)
	.s syscode=U2Smap.SystemCode
	.s rowid=$D(^dhcsyncU2SMapI("U2SMapIndex",code,syscode))
	.i rowid=0||(rowid=10) d
	..s data1=code_"^^^"_dcode_"^"_2_"^^^^^^^^^^^^"
	..i (syscode'="PA")&&(syscode'="CA") d
	...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;2表删除状态
	...s ever=checkrec.SwitchSystem("U",syscode,data1)
	...s data1=code_"|||"_dcode_"|"_2_"||||||||||||"
	...s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	...s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	...d insertlog.InsertRec($e(info,0,22), code, syscode, data1)	
	s ^hssdeuser=ever_"__"_data1
	s ever=$p(ever,"^",1)
	q:(ever="-1") "fail"	
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户信息维护"
	s ObjectDesc="删除用户信息,同时删同步到各个系统的信息"
	s NewValue=""
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"用户id:"_Rowid,ObjectDesc,"D",NewValue,userId,uname)
	&sql(select count(*) into:count from dhc_sync_data.Sync_U2SMap where UserCode=:code and State=1) 
	i count>0 d
	.&sql(Update dhc_sync_data.Sync_User set Sync_State=2 where Sync_Rowid=:Rowid)
	e  d
	.&sql(delete from dhc_sync_data.Sync_User where Sync_Rowid=:Rowid )
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
	k ^temp
	s ^temp=data,id="",rowid="",ever="",data1="",State="",rtn=0
	s oldcode=$list(^dhcsyncUserD(Rowid),2)
	
	q:data="" "emptyData"
	
	s code              =$p(data,"|",1) 
	s Name              =$p(data,"|",2) 
	s Password          =$p(data,"|",3)

	s Deptcode         	=$p(data,"|",4)
	s state             =$p(data,"|",5)
	s Email           	=$p(data,"|",6)
	s InvalidDate       =$p(data,"|",7)
	s EegDate          	=$p(data,"|",9)
	s Type				=$p(data,"|",10) 
	s HealthType        =$p(data,"|",11)
	s IsExpert         	=$p(data,"|",12)
	s Secgroup          =$p(data,"|",13)
	s Certificate       =$p(data,"|",14)
	s ISDrugRight       =$p(data,"|",15)
	s Ename				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	s Number			=$p(data,"|",18)
	s Fname				=$p(data,"|",19)
	s Company			=$p(data,"|",20)
	s Position			=$p(data,"|",21)
	s Dleader			=$p(data,"|",22)
	s Cellphone			=$p(data,"|",23)
	s Landline			=$p(data,"|",24)
	s updateDate=$zd($p($h,",",1),3)
	s ^zlgtemp3=state
	
	i code="" s code=$list(^dhcsyncUserD(Rowid),2)	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid>0)&&(tmpRowid'=Rowid) "RepCode"
	
	s rid=0
	s rid=..IfRepEmail(Email)
	q:(rid>0)&&(rid'=Rowid) "RepEmail"
	
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户信息维护"
	s ObjectDesc="更新用户信息,同时更到各个系统的用户"
	s NewValue="code:"_code
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"用户id:"_Rowid,ObjectDesc,"U",NewValue,userId,uname)
	
	i sysstr="" d
	.s sysidstr=##class(dhc.sync.udata.SyncUser).%New()
	.s sysstr=sysidstr.GetSysCode(code)
	
	i sysstr'="" d
	.s len=$l(sysstr,"^")
	.f i=2:1:len d
	..s sysid=$p(sysstr,"^",i)
	..s syscode=$list(^dhcsyncSystemD(sysid),2)	
	..&SQl(select count(*)into:count from dhc_sync_data.Sync_U2SMap where UserCode=:code and SystemCode=:syscode)
	..i count>0 s State=3 e  s State=1
	..;&sql(select Sync_State into:state1 from dhc_sync_data.Sync_User where Sync_code=:code)
	..i state=2 s State=2
	..;&sql(select UserPassword into:password1 from dhc_sync_data.Sync_UP2SMap where UserCode=:code and SystemCode=:syscode)
	..s data1=code_"^"_Name_"^"_password1_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	..i (syscode'="PA")&&(syscode'="CA") d
	...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
	...i State'=2 d	
	....s ever=checkrec.SwitchSystem("U",syscode,data1)
	....s data2=code_"|"_Name_"|"_"密码"_"|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	....s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	....s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	....d insertlog.InsertRec($e(info,0,22), code, syscode, data2)
	...e  d
	....s ever="2^无效用户"
	..i ($p(ever,"^",1)'="-1")&&(count>0) d
	...&sql(update dhc_sync_data.Sync_U2SMap set UserCode=:code where UserCode=:oldcode and SystemCode=:syscode)	
	..e  i ($p(ever,"^",1)'="-1")&&(count=0) d
	...&sql(insert into dhc_sync_data.Sync_U2SMap (UserCode,SystemCode,State) values(:code,:syscode,1))	
	..e  i $p(ever,"^",1)="-1" s rtn="fail"_"_"_syscode

	;s ^hsstemp=ever_"____"_data1
	k ^zlgtemp1
	s ^zlgtemp1=data1
	
	q:($p(rtn,"_",1)="fail") rtn	
	;s ever=$p(ever,"^",1)
	;q:(ever="-1") "fail"_"_"_syscode
	;2013-09-01|||01|主任医师|Y|Demo Group|23123|Y|lirry|护士|Y|li|慈林医院|111111|serra.Hao||
	i code   		'="" s Plist(2)= code 
	i Name   		'="" s Plist(3)= Name       	      
	i Password  	'="" s Plist(4)= Password
	i Deptcode 		'="" s Plist(5)= Deptcode
	i state   		'="" s Plist(6)= state 
	i Email   		'="" s Plist(7)= Email       	      
	i InvalidDate  	'="" s Plist(8)= InvalidDate
	i updateDate 	'="" s Plist(9)= updateDate
	s Plist(10)= EegDate
	i Type			'="" s Plist(11)= Type
	i Mnemonics  	'="" s Plist(12)= Mnemonics
	i HealthType 	'="" s Plist(13)= HealthType
	i IsExpert   	'="" s Plist(14)= IsExpert 
	i Secgroup   	'="" s Plist(15)= Secgroup       	      
	i Certificate  	'="" s Plist(16)= Certificate
	i ISDrugRight 	'="" s Plist(17)= ISDrugRight
	i Number		'="" s Plist(18)= Number
	i Ename			'="" s Plist(19)= Ename
	i Fname			'="" s Plist(20)= Fname
	i Company		'="" s Plist(21)= Company
	i Position		'="" s Plist(22)= Position
	i Dleader		'="" s Plist(23)= Dleader
	i Cellphone		'="" s Plist(24)= Cellphone
	i Landline		'="" s Plist(25)= Landline
	
	&SQL(UPDATE  dhc_sync_data.Sync_User VALUES Plist() where %ID=:Rowid) 
	s ^zlgtem=SQLCODE
	;q SQLCODE
	q 0
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 修改密码editpass oldpass	123qwe!@# pass	123qwe!@ ucode	DDM4506
/// Table：dhc_sync_data.Sync_User
/// Input：ucode-用户编码,oldpass-原密码,pass-新密码
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).UpdPass("","","DDM4506","123qwe!@#","123qwe!@")
ClassMethod UpdPass(userId, uname, ucode, oldpass, pass) As %String
{
	n (userId,uname,ucode,oldpass,pass)
	
	k PLIST
	s id="",rowid="",ever="",password=""
	&sql(select Sync_Password into:password from dhc_sync_data.Sync_User where Sync_Code=:ucode)
	q:(oldpass'=password) "diffrent"
	
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户密码修改"
	s ObjectDesc="修改密码,同时更到各个系统的用户"
	s NewValue="code:"_ucode
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"Code:"_ucode,ObjectDesc,"U",NewValue,userId,uname)
	
	f  s id=$o(^dhcsyncU2SMapI("U2SUcodeIndex",ucode,id))  q:id=""  d 
	   .s U2Smap=##Class(dhc.sync.data.U2SMap).%OpenId(id)
	   .s syscode=U2Smap.SystemCode
	   .s State="3"
	   .;&sql(select UserPassword into:password1 from dhc_sync_data.Sync_UP2SMap where UserCode=:ucode and SystemCode=:syscode)
	   .&sql(  select Sync_Code ,Sync_Name ,  Sync_Deptcode  , Sync_Email , Sync_InvalidDate, Sync_EegDate , Sync_Type , Sync_Mnemonics ,Sync_HealthType , Sync_IsExpert , Sync_Secgroup, Sync_Certificate , Sync_ISDrugRight ,Sync_Number ,Ename , Fname , Company , Position  , Dleader , Cellphone , Landline 
	   into :code,:Name, :Deptcode ,:Email, :InvalidDate, :EegDate, :Type, :Mnemonics 
	   ,:HealthType, :IsExpert, :Secgroup, :Certificate, :ISDrugRight,
	   :Number,:Ename,:Fname, :Company, :Position, :Dleader, :Cellphone, :Landline	
	    from dhc_sync_data.Sync_User where Sync_Code=:ucode )
	   .s rowid=$D(^dhcsyncU2SMapI("U2SMapIndex",ucode,syscode))
	   .s ^zlgtemp2=ucode_":"_syscode
	   .i rowid=0||(rowid=10) d
	   ..s data1=ucode_"^"_Name_"^"_password1_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	   ..;s data1=ucode_"^^"_password1_"^^"_3_"^^^^^^^^^^^^^^^^^^"
	   ..s ^zlgtemp(id)=data1
	   ..i (syscode'="PA")&&(syscode'="CA") d
	   ...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
	   ...s ever=checkrec.SwitchSystem("U",syscode,data1)
	   ...s data1=ucode_"|"_Name_"|"_"密码"_"|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	   ...s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	   ...s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	   ...d insertlog.InsertRec($e(info,0,22), ucode, syscode, data1)	
	s ever=$p(ever,"^",1)
	q:(ever="-1") "fail"
		      	      
	i pass  	'="" s Plist(4)= pass
	
	&SQL(UPDATE dhc_sync_data.Sync_User VALUES Plist() where Sync_Code=:ucode) 
	q SQLCODE
}

/// Creator：Hao Shanshan
/// CreatDate：2014-12-19
/// Description: 修改密码editpass oldpass	123qwe!@# pass	123qwe!@ ucode	DDM4506
/// Table：dhc_sync_data.Sync_User
/// Input：ucode-用户编码,oldpass-原密码,pass-新密码
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).UpdPass2("1","","CBK8434","12")
ClassMethod UpdPass3(userId, uname, ucode, pass) As %String
{
	n (userId,uname,ucode,pass)
	
	k PLIST
	s id="",rowid="",ever=""
	
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户密码修改"
	s ObjectDesc="修改密码,同时更到各个系统的用户"
	s NewValue="code:"_ucode
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"Code:"_ucode,ObjectDesc,"U",NewValue,userId,uname)
	
	f  s id=$o(^dhcsyncU2SMapI("U2SUcodeIndex",ucode,id))  q:id=""  d 
	   .s U2Smap=##Class(dhc.sync.data.U2SMap).%OpenId(id)
	   .s syscode=U2Smap.SystemCode
	   .s State="3"
	   .;&sql(select UserPassword into:password1 from dhc_sync_data.Sync_UP2SMap where UserCode=:ucode and SystemCode=:syscode)
	   .&sql(  select Sync_Code ,Sync_Name ,  Sync_Deptcode  , Sync_Email , Sync_InvalidDate, Sync_EegDate , Sync_Type , Sync_Mnemonics ,Sync_HealthType , Sync_IsExpert , Sync_Secgroup, Sync_Certificate , Sync_ISDrugRight ,Sync_Number ,Ename , Fname , Company , Position  , Dleader , Cellphone , Landline 
	   into :code,:Name, :Deptcode ,:Email, :InvalidDate, :EegDate, :Type, :Mnemonics 
	   ,:HealthType, :IsExpert, :Secgroup, :Certificate, :ISDrugRight,
	   :Number,:Ename,:Fname, :Company, :Position, :Dleader, :Cellphone, :Landline	
	    from dhc_sync_data.Sync_User where Sync_Code=:ucode )
	   .s rowid=$D(^dhcsyncU2SMapI("U2SMapIndex",ucode,syscode))
	   .s ^zlgtemp2=ucode_":"_syscode
	   .i rowid=0||(rowid=10) d
	   ..s data1=ucode_"^"_Name_"^"_password1_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	   ..;s data1=ucode_"^^"_password1_"^^"_3_"^^^^^^^^^^^^^^^^^^"
	   ..s ^zlgtemp(id)=data1
	   ..i (syscode'="PA")&&(syscode'="CA") d
	   ...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
	   ...s ever=checkrec.SwitchSystem("U",syscode,data1)
	   ...s data1=ucode_"|"_Name_"|"_"密码"_"|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
	   ...s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	   ...s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	   ...d insertlog.InsertRec($e(info,0,22), ucode, syscode, data1)	
	s ever=$p(ever,"^",1)
	q:(ever="-1") "fail"
		      	      
	i pass  	'="" s Plist(4)= pass
	
	&SQL(UPDATE  dhc_sync_data.Sync_User VALUES Plist() where Sync_Code=:ucode) 
	q SQLCODE
}

ClassMethod UpdPass2(userId, uname, ucode, pass) As %String
{
	Set ^Wanghc("UpdPass")=userId_","_uname_","_ucode_","_pass
	n (userId,uname,ucode,pass)
	ts
	s TableName="dhc_sync_data.Sync_User"
	s ClassName="dhc.sync.udata.SyncUser"
	s ClassNameDesc="用户密码修改"
	s ObjectDesc="修改密码,同时更到各个系统的用户"
	s NewValue="code:"_ucode
	d ##class(dhc.sync.udata.SyncChangeLog).SaveLog(TableName,ClassName,ClassNameDesc ,"Code:"_ucode,ObjectDesc,"U",NewValue,userId,uname)
	set syscode="",flag=1
	f  s syscode=$o(^dhcsyncU2SMapI("U2SMapIndex",ucode,syscode))  q:(flag="-1")||(syscode="")  d 
    .q:syscode="PA"
    .q:syscode="CA"
    .s rowid=$o(^dhcsyncU2SMapI("U2SMapIndex",ucode,syscode,""))
    .q:rowid'>0
    .Set SysRowId = $O(^dhcsyncSystemI("syncSysCode",syscode,""))
    .q:SysRowId=""
    .set Active = $lg(^dhcsyncSystemD(SysRowId),4)
    .q:Active'="Y"
    .;Set SK = syscode_"_Privatekey.pem" 	;$lg(^dhcsyncSystemD(SysRowId),5)
    .Set PK = syscode_"_Public.csr"	
	.Set PKeyFile = ##class(%File).NormalizeFilename("D:\Dthealth\app\dthis\web\DSKeys\"_PK)
	.if '##class(%File).Exists(PKeyFile) Set flag=-1 quit
	.SET password1 = ##class(web.Util.Encryption).RSAEncrypt(pass,PKeyFile)
    .;&sql(select UserPassword into:password1 from dhc_sync_data.Sync_UP2SMap where UserCode=:ucode and SystemCode=:syscode)
    .;&sql(update dhc_sync_data.Sync_UP2SMap set UserPassword=:password1 where UserCode=:ucode and SystemCode=:syscode)
    .IF SQLCODE'=0 Set flag=-1 quit
    .&sql(  select Sync_Code ,Sync_Name ,  Sync_Deptcode  , Sync_Email , Sync_InvalidDate, Sync_EegDate , Sync_Type , Sync_Mnemonics ,Sync_HealthType , Sync_IsExpert , Sync_Secgroup, Sync_Certificate , Sync_ISDrugRight ,Sync_Number ,Ename , Fname , Company , Position  , Dleader , Cellphone , Landline 
   			into :code,:Name, :Deptcode ,:Email, :InvalidDate, :EegDate, :Type, :Mnemonics,:HealthType, :IsExpert, :Secgroup, :Certificate, :ISDrugRight,:Number,:Ename,:Fname, :Company, :Position, :Dleader, :Cellphone, :Landline	
    		from dhc_sync_data.Sync_User where Sync_Code=:ucode )
    .s State="3"	;3表修改状态
    .s data1=ucode_"^"_Name_"^"_password1_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
    .s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() 
    .s ever=checkrec.SwitchSystem("U",syscode,data1), checkrec=""
    .s flag=$p(ever,"^",1)
    .q:flag="-1"
    .s info=flag_"|"_$p(ever,"^",2)
    .s data1=ucode_"|"_Name_"|密码|"_Deptcode_"|"_State_"|"_Email_"|"_InvalidDate_"|"_EegDate_"|"_Type_"|"_Mnemonics_"|"_HealthType_"|"_IsExpert_"|"_Secgroup_"|"_Certificate_"|"_ISDrugRight_"|"_Number_"|"_Ename_"|"_Fname_"|"_Company_"|"_Position_"|"_Dleader_"|"_Cellphone_"|"_Landline
    .d ##class(dhc.sync.udata.uSyncLog).InsertRec($e(info,0,22), ucode, syscode, data1)
    .b ;log	
	if (flag="-1") tro  q "service Soap sync fail"   
	&SQL(UPDATE dhc_sync_data.Sync_User set Sync_Password=:pass where Sync_Code=:ucode) 
	if SQLCODE TRO  Q "SYNC sync_user fail"
	tc
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

/// Description: 获取科室名称
/// Table：dhc_sync_data.Sync_Loc
/// Output：
/// Return：科室名称字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).Deptname("0","10","内")
ClassMethod Deptname(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Rowid,Code,Name from dhc_sync_data.Sync_Loc where LocLevel>1 "
	i str'="" s sqlStr = sqlStr_" and (LOWER(Name)  LIKE '%"_str_"%'"_" or  UPPER(Name) LIKE  '%"_str_"%'"_" or  Code LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("Code")
		s name = result.Data("Name")
		s name= ##class(dhc.sync.udata.uSyncLog).EvalJSON(name)
		s tmp=code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
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

/// Description: 获取已添加可用的用户---直属领导
/// Table：dhc_sync_data.Sync_User
/// Output：
/// Return：安全组字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).GetUname("0","10","q")
ClassMethod GetUname(start, limit, str) As %String
{
	n (start, limit, str)
	s email=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from dhc_sync_data.Sync_User"
	i str'="" s sqlStr = sqlStr_" where (LOWER(Sync_Name) LIKE '%"_str_"%'"_" or UPPER(Sync_Name) LIKE '%"_str_"%' or  LOWER(Sync_Code) LIKE '%"_str_"%' or  UPPER(Sync_Code) LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		
		s email = result.Data("Sync_Email")
		i email'="" s email=$p(email,"@",1)
		s code = result.Data("Sync_Code")
		s name = result.Data("Sync_Name")
		s tmp=code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
}

/// Description: 获取医护类型
/// Table：dhc_sync_data.Sync_Loc
/// Output：
/// Return：医护类型字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).caretypename("0","10","主")
ClassMethod caretypename(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from SQLUser.CT_CarPrvTp" 
	i str'="" s sqlStr = sqlStr_" where  (LOWER(CTCPT_Desc)  LIKE '%"_str_"%'"_" or  UPPER(CTCPT_Desc) LIKE  '%"_str_"%'"_" or  CTCPT_Code LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("CTCPT_Code")
		s name = result.Data("CTCPT_Desc")
		s tmp=code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
}

/// Description: 获取类别名称
/// Table： dhc_sync_data.Sync_UserType
/// Output：
/// Return：科室名称字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).Typename("0","10","其")
ClassMethod Typename(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SUT_Code,SUT_Name from dhc_sync_data.Sync_UserType"
	i str'="" s sqlStr = sqlStr_" where  (LOWER(SUT_Name)  LIKE '%"_str_"%'"_" or  UPPER(SUT_Name) LIKE  '%"_str_"%'"_" or  SUT_Code LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("SUT_Code")
		s name = result.Data("SUT_Name")
		s tmp=code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_hrUser
/// Input: Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.SyncUser).Listuname("郝","","",0,10)
ClassMethod Listuname(name, dcode, entrydate, start, limit) As %String
{
	n (name,dcode,entrydate,start,limit)
	s sqlStr="select Rowid,Code, Name, Dept, entryDate"
	_" from dhc_sync_data.Sync_hrUser "
	_" where %id>0 "
	i name'="" 			s sqlStr=sqlStr_" and Name like '%"_name_"%'"
	i dcode'="" 		s sqlStr=sqlStr_" and Dept = '"_dcode_"'"
	i entrydate'="" 	s sqlStr=sqlStr_" and Sync_Type = '"_entrydate_"'"
	s sqlStr=sqlStr_" order by entryDate desc "
	
	;w sqlStr,!
	 ;     
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^Code^Name^Dept^entryDate"
	While(result.Next())
	{  
		s rowid = result.Data("Rowid")
		s Code=result.Data("Code")
		s Name=result.Data("Name")
		s Dept=result.Data("Dept")
		s entryDate=result.Data("entryDate")	
		
		s tmp=rowid_"^"_Code_"^"_Name_"^"_Dept_"^"_entryDate
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
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
/// Table: dhc_sync_data.Sync_System
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.SyncUser).ListSys("","",0,10)
ClassMethod ListSys(name, ucode, start, limit) As %String
{
	n (name,ucode,start,limit)
	s sqlStr2="select Rowid,Code,Name,0 State from dhc_sync_data.Sync_System where Active='Y'"
	s sqlStr1="select a.Rowid,Code, Name, State"
	_" from dhc_sync_data.Sync_System a left join dhc_sync_data.Sync_U2SMap b"
	_" on a.Code=b.SystemCode and b.UserCode='"_ucode_"'"
	_" where a.%id>0 and Active='Y'" 
	i ucode'="" s sqlStr=sqlStr1
	e  s sqlStr= sqlStr2 
	i name'="" s sqlStr= sqlStr_" and Name like '%"_name_"%'"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^Code^Name^State"
	While(result.Next())
	{  
		s rowid = result.Data("Rowid")
		s Code=result.Data("Code")
		s Name=result.Data("Name")
		s State=result.Data("State")	
		
		s tmp=rowid_"^"_Code_"^"_Name_"^"_State
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 获取用户名称
/// Table：herp_budg_data.BudgProjectDict
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：科室名称字符串
/// Others：w ##class(dhc.sync.udata.SyncUser).Username("0","10","")
ClassMethod Username(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM dhc_sync_data.sync_user where %ID>0"
	i str'="" s sqlStr = sqlStr_" and (LOWER(Sync_Code)  LIKE '%"_str_"%' or UPPER(Sync_Code) LIKE  '%"_str_"%' or Sync_Name LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("Sync_Code")
		s name = result.Data("Sync_Name")
		s tmp=code_"^"_name_"_"_code
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
 	k json
	q resultString
}

/// Description: 保存用户信息
/// Table：dhc_sync_data.Sync_User,dhc_sync_data.Sync_U2SMap,dhc_sync_data.Sync_UP2SMap
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.SyncUser).Save("1","demo group","SwD101|散弹|123QWE!@#|1001|1|srw.san@chccilin.com|2013-09-01|||01|医师|N|Demo Group|100|N|sear|SSD|00001|san|慈林医院|1001|||","24")
ClassMethod Save(SessionUserId, SessionUserName, data, sysstr) As %String
{
	n (SessionUserId,SessionUserName, data,sysstr,%request,%session)
	Set ^Wanghc("syncUser","Save")=SessionUserId_","_ SessionUserName_","_ data_","_ sysstr
	s data1="",ever="",syscode=""
	s Code            	=$p(data,"|",1)
	s rid=0
	s rid=..IfRepCode(Code)
	s Name              =$p(data,"|",2) 
	s Password          =$p(data,"|",3)
	s Deptcode         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s Email           	=$p(data,"|",6)
	s InvalidDate       =$p(data,"|",7)
	s updateDate	    =$p(data,"|",8)
	s EegDate          	=$p(data,"|",9)
	s Type				=$p(data,"|",10)
	s HealthType        =$p(data,"|",11)
	s IsExpert         	=$p(data,"|",12)
	s Secgroup          =$p(data,"|",13)
	s Certificate       =$p(data,"|",14)
	s ISDrugRight       =$p(data,"|",15)
	s Ename				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	s MaxNo				=$p(data,"|",18)
	s Fname				=$p(data,"|",19)
	s Company			=$p(data,"|",20)
	s Position			=$p(data,"|",21)
	s Dleader			=$p(data,"|",22)
	s Cellphone			=$p(data,"|",23)
	s Landline			=$p(data,"|",24)
	s UpdateDate=$zd($p($h,",",1),3)
	if rid>0 Set LogStatus = "U"
	else  Set LogStatus = "A"	
	ts
	s changelog=##class(dhc.sync.udata.SyncChangeLog).SaveLog("dhc_sync_data.Sync_User","dhc.sync.udata.SyncUser","用户信息维护" ,"","插入新的用户","A","Code："_Code,SessionUserId,SessionUserName)
	Set UserObj = ""
	if (LogStatus="A"){
		Set UserObj = ##class(dhc.sync.data.User).%New()
		Set UserObj.Code = Code
	}else{
		Set UserObj = ##class(dhc.sync.data.User).%OpenId(rid)
	}
	Set UserObj.Name = Name,UserObj.Password=Password,UserObj.Deptcode = Deptcode,UserObj.State=State
	Set UserObj.Email = Email,UserObj.InvalidDate=InvalidDate,UserObj.UpdateDate=UpdateDate,UserObj.EegDate=EegDate
	Set UserObj.Type=Type,UserObj.Mnemonics=Mnemonics,UserObj.HealthType=HealthType,UserObj.IsExpert=IsExpert
	Set UserObj.Secgroup=Secgroup,UserObj.Certificate=Certificate,UserObj.ISDrugRight=ISDrugRight,UserObj.Number=MaxNo
	Set UserObj.Ename=Ename,UserObj.Fname=Fname,UserObj.Company=Company,UserObj.Position=Position,UserObj.Dleader=Dleader
	Set UserObj.Cellphone=Cellphone,UserObj.Landline=Landline
	Set sc = UserObj.%Save()
	If $$$ISERR(sc)  tro  quit "-100^Save User Error"	
	Set SyncUserId = UserObj.%Id()
	Set UserObj=""
	Set SysLen = $l(sysstr,"^")
	for i=1:1:SysLen {
		set sysid = $p(sysstr,"^",i)
		Continue:+sysid=0 
		Set syscode=$listget(^dhcsyncSystemD(sysid),2)
		Continue:syscode=""
		set rtn = ##class(dhc.sync.udata.syncU2SMap).Save(Code,syscode,SessionUserId,SessionUserName,Password)
		Quit:+rtn=-100
	}
	if rtn>0 tc
	else  tro  quit -100_"^Save syncU2SMap Error"
	Quit 0
}

/// 返回用户id,判断用户有效,有效日期
ClassMethod GetIdByCode(ucode)
{
	Quit:ucode="" ""
	Set userid=$o(^dhcsyncUserI("SyncUserCode",ucode,userid))
	Quit:userid'>0 -108
	Set statu = $lg(^dhcsyncUserD(userid),6)
	Set StDate = $lg(^dhcsyncUserD(userid),8)
	If StDate'="" Set StDate=$zdh(StDate,3)
	Set EndDate = $lg(^dhcsyncUserD(userid),10)
	If EndDate'="" Set EndDate=$zdh(EndDate,3)
	Set now = +$h
	Quit:(StDate'="")&&(stDate>now) -109
	Quit:(EndDate'="")&&(EndDate<now) -110
	Quit:statu'=1 -111
	q userid
}

Storage Default
{
<StreamLocation>^dhc.sync.udata.SyncUserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
