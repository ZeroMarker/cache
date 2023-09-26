Class dhc.sync.udata.uSyncl2SMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// wanghc
ClassMethod GetLocData(LocId)
{
	s Code=$List(^dhcsyncLocD(LocId),2)
	s Name=$List(^dhcsyncLocD(LocId),3)
	s LocLevel=$List(^dhcsyncLocD(LocId),4)
	s Super=$List(^dhcsyncLocD(LocId),5)
	s State=$List(^dhcsyncLocD(LocId),6)
	s IsLast=$List(^dhcsyncLocD(LocId),7)
	s Type=$List(^dhcsyncLocD(LocId),8)
	s DGroup=$List(^dhcsyncLocD(LocId),9)
	s Classify=$List(^dhcsyncLocD(LocId),10)
	s Address =$List(^dhcsyncLocD(LocId),11)
	s Phone =$List(^dhcsyncLocD(LocId),12)
	s Mnemonics=$List(^dhcsyncLocD(LocId),13)
	s StartDate=$List(^dhcsyncLocD(LocId),14)
	s EndDate=$List(^dhcsyncLocD(LocId),15)
	s Storey=$List(^dhcsyncLocD(LocId),16)
	s Catalogue=$List(^dhcsyncLocD(LocId),17)
	s Dept=$List(^dhcsyncLocD(LocId),18)
	s Data=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_State_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	quit Data
}

/// wanghc 
/// 2015-01-16
ClassMethod SyncByLocId(SystemCodes, LocId)
{
	s ^temp("SyncLoc")=$lb(SystemCodes,LocId)
	n (SystemCodes,LocId,%session)
	Set LocIdData = ..GetLocData(LocId)
	Set rtn = ##class(dhc.sync.udata.SyncInterface).Sync("D",SystemCodes,LocIdData)
	quit:rtn>0 0
	quit -100_"^SyncError. "_rtn
}

/// wanghc 
ClassMethod Save(LocCode, SystemCode, SessionUserId, SessionUserName)
{
	n (LocCode,SystemCode,SessionUserId,SessionUserName)
	Quit:LocCode="" ""
	Quit:SystemCode="" ""
	ts
	Set RowId = $O(^dhcsyncL2SMapI("L2SMapIndex",LocCode,SystemCode,""))
	If RowId>0 {
		Set Obj = ##class(dhc.sync.data.L2SMap).%OpenId(RowId)
		Set OperateType = "U" ;Upd
		Set State = 3 ;修改
	}Else {
		 Set Obj = ##class(dhc.sync.data.L2SMap).%New()
		 Set Obj.SystemCode = SystemCode
		 Set Obj.LocCode = LocCode
		Set OperateType="A" ;Add
		Set State = 1	;新增
	}
	Set Obj.State = State
	Set sc = Obj.%Save()
	
	If $$$ISERR(sc) tro  Set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set RowId = Obj.%Id(),Obj=""
	Set rtn = ##class(dhc.sync.udata.SyncChangeLog).SaveLog("dhc.sync.data.L2SMap","dhc.sync.udata.syncL2SMap","科室同步" ,
		"LocCode:"_LocCode_"->"_SystemCode,"科室同步到系统",OperateType,State,SessionUserId,SessionUserName) 
	If rtn="添加失败!" tro  quit "-100^SaveChangeLog"
	tc
	Quit RowId
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 更新记录
/// Table：dhc_sync_data.Sync_L2SMap
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncl2SMap).UpdateRec("1","demo group","1","产科","1,dataIndex42^")
ClassMethod UpdateRec(userId, uname, locid, Code, Systemdesc) As %String
{
	n (userId, uname,locid,Code, Systemdesc)
	k ^temp
	s ^temp=locid_"***"_Code_"***"_Systemdesc
	s locCode=Code,ever="",rtn=""
	k PLIST
	s checkinfo=##class(ext.util.String).%New()
	
	;w locid,!
	s Code=$List(^dhcsyncLocD(locid),2)
	s Name=$List(^dhcsyncLocD(locid),3)
	s LocLevel=$List(^dhcsyncLocD(locid),4)
	s Super=$List(^dhcsyncLocD(locid),5)
	s State=$List(^dhcsyncLocD(locid),6)
	s IsLast=$List(^dhcsyncLocD(locid),7)
	s Type=$List(^dhcsyncLocD(locid),8)
	s DGroup=$List(^dhcsyncLocD(locid),9)
	s Classify=$List(^dhcsyncLocD(locid),10)
	s Address =$List(^dhcsyncLocD(locid),11)
	s Phone =$List(^dhcsyncLocD(locid),12)
	s Mnemonics=$List(^dhcsyncLocD(locid),13)
	s StartDate=$List(^dhcsyncLocD(locid),14)
	s EndDate=$List(^dhcsyncLocD(locid),15)
	s Storey=$List(^dhcsyncLocD(locid),16)
	s Catalogue=$List(^dhcsyncLocD(locid),17)
	s Dept=$List(^dhcsyncLocD(locid),18)
	s Len=$L(Systemdesc,"^")
	f k=1:1:Len-1 d
	.s statesys=$p(Systemdesc,"^",k)
	.s state=$p(statesys,",",1)
	.s Code= checkinfo.EvalJSON(Code)
	.s Name= checkinfo.EvalJSON(Name)
	.s Address= checkinfo.EvalJSON(Address)
	.s tmpsysid=$p(statesys,",",2)
	.s sysid=$p(tmpsysid,"x",2)
	.s systemCode=$list(^dhcsyncSystemD(sysid),2)
	.i locCode   		'="" s Plist(2)= locCode 
	.i systemCode   	'="" s Plist(3)= systemCode       	      
	.i state  			'="" s Plist(4)= state
	.&SQl(select count(*)into:count from dhc_sync_data.Sync_L2SMap where LocCode=:locCode and SystemCode=:systemCode)	             	
	.i count>0 d
	..s State=3
	.e  d
	..s State=1
	.s data1=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_State_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	.;w data1,!
	.i systemCode="PA" d
	..s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	..s ever=locsync.BonusUnitSync(data1)
	.e  d
	..s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New()
	..s ever=checkrec.SwitchSystem("D",systemCode,data1)
	.;w ever,!
	.s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	.s TableName="dhc_sync_data.Sync_L2SMap"
	.s ClassName="dhc.sync.udata.uSyncl2SMap"
	.s ClassNameDesc="科室同步信息"
	.s ObjectDesc="更新科室同步到各系统的信息"
	.s NewValue=state
	.s ^hssloc=ever_"________"_data1
	.s data1=Code_"|"_Name_"|"_LocLevel_"|"_Super_"|"_State_"|"_IsLast_"|"_Type_"|"_DGroup_"|"_Classify_"|"_Address_"|"_Phone_"|"_Mnemonics_"|"_StartDate_"|"_EndDate_"|"_Storey_"|"_Catalogue_"|"_Dept
	.s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	.s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	.d insertlog.InsertRec(info, Code, systemCode, data1)
	.s ever=$p(ever,"^",1)
	.i ever="-1" d
	..s rtn="fail"
	.e  d	
	..i count>0 d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"locCode:"_locCode_",sysCode:"_systemCode,ObjectDesc,"U",NewValue,userId, uname) 
	...&SQL(UPDATE dhc_sync_data.Sync_L2SMap VALUES Plist() where LocCode=:locCode and SystemCode=:systemCode) 
	..e  d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"locCode:"_locCode_",sysCode:"_systemCode,ObjectDesc,"A",NewValue,userId, uname) 
	...&sql(insert into dhc_sync_data.Sync_L2SMap (LocCode,SystemCode,State) values(:locCode,:systemCode,:state) )
	..s rtn=SQLCODE
	q rtn
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 页面批量处理的方法，一个系统对应所有科室
/// Table：dhc_sync_data.Sync_L2SMap
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncl2SMap).Update("1","demo group","40","1","")
ClassMethod Update(userId, uname, sysid, state, dgroup) As %String
{
	n (userId, uname,sysid, state,dgroup)
	s ever="",data="",rtn=""
	k PLIST
	s checkinfo=##class(ext.util.String).%New()
	s data=..GetLocCode(dgroup) 
	;^1*0001^2*0002^5*000102^6*000201^7*000202
	s Len=$L(data,"^")
	f k=2:1:Len d
	.s loc=$p(data,"^",k)
	.;w loc,"^",k,!
	.s locid=$p(loc,"*",1)	
	.s loccode=$p(loc,"*",2)
	.s sysCode=$list(^dhcsyncSystemD(sysid),2)
	
	.;w locid,"^",loccode,"^",sysCode,!

	.s Code=$List(^dhcsyncLocD(locid),2)
	.s Name=$List(^dhcsyncLocD(locid),3)
	.s LocLevel=$List(^dhcsyncLocD(locid),4)
	.s Super=$List(^dhcsyncLocD(locid),5)
	.s State=$List(^dhcsyncLocD(locid),6)
	.s IsLast=$List(^dhcsyncLocD(locid),7)
	.s Type=$List(^dhcsyncLocD(locid),8)
	.s DGroup=$List(^dhcsyncLocD(locid),9)
	.s Classify=$List(^dhcsyncLocD(locid),10)
	.s Address =$List(^dhcsyncLocD(locid),11)
	.s Phone =$List(^dhcsyncLocD(locid),12)
	.s Mnemonics=$List(^dhcsyncLocD(locid),13)
	.s StartDate=$List(^dhcsyncLocD(locid),14)
	.s EndDate=$List(^dhcsyncLocD(locid),15)
	.s Storey=$List(^dhcsyncLocD(locid),16)
	.s Catalogue=$List(^dhcsyncLocD(locid),17)
	.s Dept=$List(^dhcsyncLocD(locid),18)
	
	.s Code= checkinfo.EvalJSON(Code)
	.s Name= checkinfo.EvalJSON(Name)
	.s Address= checkinfo.EvalJSON(Address)
	
	.&SQl(select count(*)into:count from dhc_sync_data.Sync_L2SMap where LocCode=:loccode and SystemCode=:sysCode)
	.i count>0 d
	..s State=3
	.e  d
	..s State=1
	.s data1=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_State_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	.i sysCode="PA" d
	..s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	..s ever=locsync.BonusUnitSync(data1)
	.e  d
	..s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New()
	..s ever=checkrec.SwitchSystem("D",sysCode,data1)	
	..k ^temuupdate
	..s ^temuupdate=ever_"_____"_data1
	.s data1=Code_"|"_Name_"|"_LocLevel_"|"_Super_"|"_State_"|"_IsLast_"|"_Type_"|"_DGroup_"|"_Classify_"|"_Address_"|"_Phone_"|"_Mnemonics_"|"_StartDate_"|"_EndDate_"|"_Storey_"|"_Catalogue_"|"_Dept
	.s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	.s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	.d insertlog.InsertRec(info, Code, sysCode, data1)
	
	.s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	.s TableName="dhc_sync_data.Sync_L2SMap"
	.s ClassName="dhc.sync.udata.uSyncl2SMap"
	.s ClassNameDesc="科室同步信息"
	.s ObjectDesc="批量更新科室同步到各系统的信息"
	.s NewValue=state
	
	.i loccode   		'="" s Plist(2)= loccode 
	.i sysCode   		'="" s Plist(3)= sysCode       	      
	.i state  			'="" s Plist(4)= state
	.s ever=$p(ever,"^",1)
	.i ever="-1" d
	..s rtn="fail"
	.e  d	
	..i count>0 d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"locCode:"_loccode_",sysCode:"_sysCode,ObjectDesc,"U",NewValue,userId, uname) 
	...&SQL(UPDATE  dhc_sync_data.Sync_L2SMap VALUES Plist() where LocCode=:loccode and SystemCode=:sysCode) 
	..e  d
	...d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"locCode:"_loccode_",sysCode:"_sysCode,ObjectDesc,"A",NewValue,userId, uname) 
	...&sql(insert into dhc_sync_data.Sync_L2SMap (LocCode,SystemCode,State) values(:loccode,:sysCode,:state) )
	..s rtn=SQLCODE
	q rtn
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-07-25
/// Description: 获取有效的科室
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.uSyncl2SMap).GetLocCode()
ClassMethod GetLocCode(dgroup) As %String
{
	n (dgroup)
	s locs = "",loc=""
	s sqlStr="select * from dhc_sync_data.Sync_Loc"
	_" where State ='1' "
	i dgroup'="" s sqlStr=sqlStr_" and DGroup='"_dgroup_"'"
	s sqlStr=sqlStr_" order by Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()    

	s json = ##class(herp.comm.JsonObj).%New()
	s codenames=""
	While(result.Next()){
		s Rowid   = result.Data("Rowid")
		s Code   = result.Data("Code")
		s loc	=Rowid_"*"_Code
		s locs=locs_"^"_loc
		;w States,!
	}	
	d result.Close()	
	q locs
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 返回各个系统的状态state
/// Table: dhc_sync_data.Sync_L2SMap
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncl2SMap).Getcodename("0001")
ClassMethod Getcodename(LocCode) As %String
{
	n (LocCode)
	s States = "" // LocCode SystemCode State

	s sqlStr="select b.LocCode,b.SystemCode,b.State,a.Active from dhc_sync_data.Sync_System a"
	_" left join dhc_sync_data.Sync_L2SMap b on a.Code=b.SystemCode and b.LocCode ='"_LocCode_"'"
	s sqlStr=sqlStr_" where a.Active ='Y' order by a.Rowid asc"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s LocCode = result.Data("LocCode")
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
/// Table: dhc_sync_data.Sync_L2SMap
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncl2SMap).Getsyscode()
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
/// Table: dhc_sync_data.Sync_System
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.uSyncl2SMap).GetGridTitle()
ClassMethod GetGridTitle() As %String
{
	
	s id= 0
	
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
	
	d json.InsertRowData("0^Rowid^科室ID")
	d json.InsertRowData("0^Code^科室编码")
	d json.InsertRowData("0^Name^科室名称")
	While(result.Next()){
		s id =id+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("title")
		
		s tmp = id_"^"_dataIndex_"^"_title
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
/// others:w ##class(dhc.sync.udata.uSyncl2SMap).List("1","demo group","","","",0,125)
ClassMethod List(userId, uname, name, code, level, start, limit) As %String
{
	n (userId, uname,name,code,level,start,limit)
	;i rnode="roo" s rnode=0
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_L2SMap"
	s ClassName="dhc.sync.udata.uSyncl2SMap"
	s ClassNameDesc="科室同步信息"
	s ObjectDesc="查询科室同步信息"
	s NewValue=""
	
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R",NewValue,userId, uname) 
	//获取系统信息code,name
	s tempjson=..Getsyscode()
	;w tempjson,!
	
	s sqlStr="select Rowid,Code,LocLevel,Name,Super,IsLast from dhc_sync_data.Sync_Loc "
	_" where State=1 "
	i name'="" 	s sqlStr=sqlStr_" and Name like '%"_name_"%'"
	i code'=""	s sqlStr=sqlStr_" and Code like '%"_code_"%'"
	i level'=""	s sqlStr=sqlStr_" and LocLevel ='"_level_"'"
	;_" where Super = '"_rnode_"'"
	
	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="Rowid^Code^Name^parent^leaf^uiProvider"_tempjson
	;w jsonTitle,!
	
	s UserCode=""
	While(result.Next())
	{
		s Rowid=result.Data("Rowid") // Rowid Code Name LocLevel Super State IsLast
		s Code=result.Data("Code")
		s Level=result.Data("LocLevel")
		s Name=result.Data("Name")
		
		s m="&nbsp;"
		f k=1:1:Level d
		.s m=m_"&nbsp;"
		.s Name=m_Name
		
		s Super=result.Data("Super")
		s IsLast=result.Data("IsLast")
		i IsLast="Y" s Flag="true"
		else  s Flag="false"
		;w Code,"^"
		s codestatestr= ..Getcodename(Code)	
		
		s tmp=Rowid_"^"_Code_"^"_Name_"^"_Super_"^"_Flag_"^"_"col"_codestatestr
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

Storage Default
{
<StreamLocation>^dhc.sync.udata.uSyncl2SMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
