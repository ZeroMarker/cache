Class dhc.sync.udata.uSyncLoc Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//keshi维护

/// Others:w ##class(dhc.sync.udata.uSyncLoc).IfRepCode("脾胃病一科")
ClassMethod test(name) As %String
{
	n (name)
	s Mnemonics=""
	s hr=##class(dhc.sync.HRWebServiceSoap).%New()
	d hr.getPYString(name)
	s Mnemonics = hr.getPYString(name)
	w Mnemonics,!
}

/// Description: 自动生成编码
/// Others:w ##class(dhc.sync.udata.uSyncLoc).CreateCode("3","10020300","")
ClassMethod CreateCode(level, super, code0, dept) As %String
{
	n (level,super,code0,dept)
	s str="",code1="",code2="",code3=""
	
	i level=0 d
	.s str=code0_"^"_code1_"^"_code2_"^"_code3
	.i dept="Y" d
	..s str=code0_"^"_"00"_"^"_"00"_"^"_"00"
	
	&sql(select Code0 into:code0 from dhc_sync_data.Sync_Loc where Code=:super)
	
	i level=1 d
	.&sql(select max(cast(Code1 as int))into:code1 from dhc_sync_data.Sync_Loc where Super=:super)
	.s code1=code1+1
	.i code1<10 s code1="0"_code1
	.s str=code0_"^"_code1_"^"_code2_"^"_code3
	.i dept="Y" d
	..s str=code0_"^"_code1_"^"_"00"_"^"_"00"
	
	&sql(select Code1 into:code1 from dhc_sync_data.Sync_Loc where Code=:super)	
	
	i level=2 d
	.&sql(select max(cast(Code2 as int))into:code2 from dhc_sync_data.Sync_Loc where Super=:super)
	.s code2=code2+1
	.i code2<10 s code2="0"_code2
	.s str=code0_"^"_code1_"^"_code2_"^"_code3
	.i dept="Y" d
	..s str=code0_"^"_code1_"^"_code2_"^"_"00"
	
	&sql(select Code2 into:code2 from dhc_sync_data.Sync_Loc where Code=:super)
	
	i level=3 d
	.&sql(select max(cast(Code3 as int))into:code3 from dhc_sync_data.Sync_Loc where Super=:super)
	.s code3=code3+1
	.i code3<10 s code3="0"_code3
	.s str=code0_"^"_code1_"^"_code2_"^"_code3
	
	q str
}

/// Description: 用户维护 代码是否存在
/// Table：dhc_sync_data.Sync_Loc
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.uSyncLoc).IfRepCode("1")
ClassMethod IfRepCode(Code) As %String
{
	new (Code)
	s rowid=0
	s rowid=$o(^dhcsyncLocI("syncLocIdx",Code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 用户维护 属性为科室的科室名称是否重复
/// Table：dhc_sync_data.Sync_Loc
/// Input: Name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.uSyncLoc).IfRepName("1")
ClassMethod IfRepName(Name) As %String
{
	new (Name)
	s rowid=0,Dept="Y"
	s rowid=$o(^dhcsyncLocI("syncLocNameIdx",Name,Dept,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 根据科室名称生成助记码
/// Table：dhc_sync_data.Sync_Loc
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.uSyncLoc).GetLCode("1")
ClassMethod GetLCode(LocLevel, Super, Code0, Dept, Name) As %String
{
	n (LocLevel,Super,Code0,Dept,Name)
	s str=..CreateCode(LocLevel,Super,Code0,Dept)
	s Code0=$p(str,"^",1)
	s Code1=$p(str,"^",2)
	s Code2=$p(str,"^",3)
	s Code3=$p(str,"^",4)
	s Code=Code0_Code1_Code2_Code3
	
	s Mnemonics=""
	s hr=##class(dhc.sync.HRWebServiceSoap).%New()
	d hr.getPYString(Name)
	s Mnemonics = hr.getPYString(Name)
	q Code_"^"_Mnemonics
}

/// Description: 根据科室名称生成助记码
/// Table：dhc_sync_data.Sync_Loc
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.uSyncLoc).GetMnemo("1")
ClassMethod GetMnemo(Name) As %String
{
	n (Name)
	
	s Mnemonics=""
	s hr=##class(dhc.sync.HRWebServiceSoap).%New()
	d hr.getPYString(Name)
	s Mnemonics = hr.getPYString(Name)
	q Mnemonics
}

/// Description: 插入一条新数据
/// Table：dhc_sync_data.Sync_Loc
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncLoc).InsertRec("1","demo group","1001|11|0|0|1|N|||||||||Y|N")
ClassMethod InsertRec(userId, uname, data) As %String
{
	// Code, Name, LocLevel, Super, State, IsLast
	// Type DGroup Classify Address Phone Mnemonics StartDate EndDate Storey 
	// Catalogue Dept Code0 Code1 Code2 Code3
	n (userId, uname,data)
	K ^temp
	s ^temp=data
	
	s Code             	=$p(data,"|",1) 
	s Name              =$p(data,"|",2) 
	s LocLevel          =$p(data,"|",3)
	s Super         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s IsLast           	=$p(data,"|",6)
	s Type              =$p(data,"|",7) 
	s DGroup          	=$p(data,"|",8)
	s Classify         	=$p(data,"|",9)
	s Address           =$p(data,"|",10)
	s Phone           	=$p(data,"|",11)
	s StartDate         =$p(data,"|",12)
	s EndDate           =$p(data,"|",13)
	s Storey           	=$p(data,"|",14)
	s Catalogue			=$p(data,"|",15)
	s Dept				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	
	s Code0=$e(Code,1,2)
	s Code1=$e(Code,3,4)
	s Code2=$e(Code,5,6)
	s Code3=$e(Code,7,8)
	
	s rowid=0
	s rowid=..IfRepCode(Code)
	q:rowid>0 "RepCode"
	
	s rid=0
	s rid=..IfRepName(Name)
	q:rid>0 "RepName"
	
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_Loc"
	s ClassName="dhc.sync.udata.uSyncLoc"
	s ClassNameDesc="科室信息维护"
	s ObjectDesc="增加一条科室信息"
	s NewValue="Code:"_Code
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"code:"_Code,ObjectDesc,"A",NewValue,userId, uname)

	&sql(insert into dhc_sync_data.Sync_Loc(Code ,Name ,LocLevel ,Super ,State ,IsLast,Type,DGroup,Classify,Address,Phone,Mnemonics,StartDate,EndDate,Storey,Catalogue,Dept,Code0,Code1,Code2,Code3) 
	values(:Code ,:Name ,:LocLevel ,:Super ,:State ,:IsLast,:Type,:DGroup,:Classify,:Address,:Phone,:Mnemonics,:StartDate,:EndDate,:Storey,:Catalogue,:Dept,:Code0,:Code1,:Code2,:Code3))
	q SQLCODE
}

/// Description: 添加页面选择多个系统时调用
/// Table：dhc_sync_data.Sync_User
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.sync.udata.uSyncLoc).Inserts("2","^his^oa^hr^pa")
ClassMethod Inserts(data, sysids) As %String
{
	n (data,sysids)
	s rtn="",sysid=""
	s len=$l(sysids,"^")
	f i=2:1:len d
	.s sysid=$p(sysids,"^",i)
	.s hr=##class(dhc.sync.udata.uSyncLoc).%New()
	.s rtn=..InsertU2S(data,sysid)
	q rtn
}

/// Description: 插入一条新数据
/// Table：dhc_sync_data.Sync_User
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncLoc).InsertRec("1","demo group","SwD101|散弹|123QWE!@#|1001|1|srw.san@chccilin.com|2013-09-01|||01|医师|N|Demo Group|100|N|sear|SSD|00001|san|慈林医院|1001|||","24")
ClassMethod InsertU2S(data, sysid) As %String
{
	
	n (data,sysid)
	s data1="",ever="",syscode=""
	s Code             	=$p(data,"|",1) 
	s Name              =$p(data,"|",2) 
	s LocLevel          =$p(data,"|",3)
	s Super         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s IsLast           	=$p(data,"|",6)
	s Type              =$p(data,"|",7) 
	s DGroup          	=$p(data,"|",8)
	s Classify         	=$p(data,"|",9)
	s Address           =$p(data,"|",10)
	s Phone           	=$p(data,"|",11)
	s StartDate         =$p(data,"|",12)
	s EndDate           =$p(data,"|",13)
	s Storey           	=$p(data,"|",14)
	s Catalogue			=$p(data,"|",15)
	s Dept				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)

	i sysid'="" s syscode=$list(^dhcsyncSystemD(sysid),2)
	i syscode'="" d
	.s rowid=$D(^dhcsyncL2SMapI("L2SMapIndex",Code,syscode))
	.i (rowid=10)||(rowid=0) d
	..s data1=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_1_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	..i syscode="PA" d
	...s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	...s ever=locsync.BonusUnitSync(data1)
	..e  d
	...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;1表添加状态
	...s ever=checkrec.SwitchSystem("D",syscode,data1)
	..s data1=Code_"|"_Name_"|"_LocLevel_"|"_Super_"|"_1_"|"_IsLast_"|"_Type_"|"_DGroup_"|"_Classify_"|"_Address_"|"_Phone_"|"_Mnemonics_"|"_StartDate_"|"_EndDate_"|"_Storey_"|"_Catalogue_"|"_Dept
	..s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	..s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	..d insertlog.InsertRec(info, Code, syscode, data1)
	..i $p(ever,"^",1)'="-1" d
	...&sql(insert into dhc_sync_data.Sync_L2SMap (LocCode,SystemCode,State) values(:Code,:syscode,1))	
	
	s ^hssupuser=ever_"____"_data1
	q:($p(ever,"^",1)="-1") "fail"
	
	q 0
}

/// Description: 删除记录
/// Table：dhc_sync_data.Sync_Loc
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.sync.udata.uSyncLoc).Delete("1","demo group","3")
ClassMethod Delete(userId, uname, Rowid) As %String
{
	n (userId, uname,Rowid)	
	s code="",id="",ever="",data1=""
	s code=$list(^dhcsyncLocD(Rowid),2)
	s name=$list(^dhcsyncLocD(Rowid),3)
	s level=$list(^dhcsyncLocD(Rowid),4)
	s super=$list(^dhcsyncLocD(Rowid),5)
	s IsLast=$list(^dhcsyncLocD(Rowid),7)	
	
	&sql(select count(*) into:acount from dhc_sync_data.Sync_User where Sync_Deptcode=:code)
	q:acount>0 "notalone"
			
	s flag="true"
	&sql(select count(*) into:count from dhc_sync_data.Sync_Loc where Super=:code and State=1)
	i count>0 s flag="false"
	
	f  s id=$o(^dhcsyncL2SMapI("L2ScodeIndex",code,id))  q:id=""  d 
	.s U2Smap=##Class(dhc.sync.data.L2SMap).%OpenId(id)
	.s syscode=U2Smap.SystemCode
	.i syscode'="" d
	..s rowid=$D(^dhcsyncL2SMapI("L2SMapIndex",code,syscode))
	..i rowid=0||(rowid=10) d
	...s data1=code_"^"_name_"^"_level_"^"_super_"^"_2_"^"_IsLast_"^^^^^^^^^^^"
	...i syscode="PA" d
	....s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	....s ever=locsync.BonusUnitSync(data1)
	...e  d
	....s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;2表删除状态
	....s ever=checkrec.SwitchSystem("D",syscode,data1)
	....i syscode="OA" d
	.....&sql(delete from dhc_sync_data.Sync_L2SMap where LocCode=:code and SystemCode='OA' )
	...s data1=code_"|"_name_"|"_level_"|"_super_"|"_2_"|"_IsLast_"|||||||||||"
	...s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	...s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	...d insertlog.InsertRec(info, code, syscode, data1)
	;...;i (flag="true")&&($p(ever,"^",1)'="-1") d
	;....;&sql(delete from dhc_sync_data.Sync_L2SMap where LocCode=:code and SystemCode=:syscode) 
	s ^hssdeloc=ever_"________"_data1
	s ever=$p(ever,"^",1)
	q:(ever="-1") "fail"
	
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_Loc"
	s ClassName="dhc.sync.udata.uSyncLoc"
	s ClassNameDesc="科室信息维护"
	s ObjectDesc="删除科室信息及已经同步的系统"
	s NewValue=""

	&sql(select count(*) into:count from dhc_sync_data.Sync_L2SMap where LocCode=:code and State=1) 
	i flag="true" d
	.d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"id:"_Rowid,ObjectDesc,"D",NewValue,userId, uname)	
	.i count>0 d
	..&SQL(update dhc_sync_data.Sync_Loc set State= 2 where Rowid=:Rowid)
	.e  d
	..&sql(delete from dhc_sync_data.Sync_Loc where Rowid=:Rowid )
	q flag
}

/// Description: 更新非末级的记录
/// Table：dhc_sync_data.Sync_Loc
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行语句后的SQLCODE
/// Others: w ##class(dhc.sync.udata.uSyncLoc).Delete("4")
ClassMethod updnolast(ncode, oldcode) As %String
{
	n (ncode,oldcode)	
	s id="",ever=""
	s sqlStr="select * from dhc_sync_data.Sync_Loc where Super ='"_oldcode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s code = result.Data("Code")
		f  s id=$o(^dhcsyncL2SMapI("L2ScodeIndex",code,id))  q:id=""  d 
	   .s U2Smap=##Class(dhc.sync.data.L2SMap).%OpenId(id)
	   .s syscode=U2Smap.SystemCode
	   .s rowid=$D(^dhcsyncL2SMapI("L2SMapIndex",code,syscode))
	   .i rowid=0||(rowid=10) d
	   ..s data1=code_"^^^"_ncode_"^"_3_"^^^^^^^^^^^^"
	   ..i syscode="PA" d
	   ...s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	   ...s ever= locsync.BonusUnitSync(data1)
	   ..e  d
	   ...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
	   ...s ever= checkrec.SwitchSystem("D",syscode,data1)
	  
	}
	d result.Close()		
	q 0
}

/// Creator：Hao Shanshan
/// CreatDate：2013-06-04
/// Description: 更新记录
/// Table：dhc_sync_data.Sync_Loc
/// Input：BDEPT_Code-编码,BDEPTT_Name-名称,BDEPTT_Class-分类,BDEPT_DirectDR-科主任
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncLoc).UpdateRec("1","demo group","2","10|行政科室|0|0|有效|N|O||||||||Y|N|XZKS","")
ClassMethod UpdateRec(userId, uname, Rowid, data, sysstr) As %String
{
	q:Rowid="" "error"
	n (userId, uname,Rowid,data,sysstr)
	
	// Code Name LocLevel Super State IsLast
	// Type DGroup Classify Address Phone Mnemonics StartDate EndDate Storey
	k PLIST
	k ^temp
	s ^temp=data,id="",rowid="",ever="",data1=""
	
	q:data="" "emptyData"
	
	s code            	=$p(data,"|",1)
	i code="" s code =$list(^dhcsyncLocD(Rowid),2)
	s Name              =$p(data,"|",2) 
	s LocLevel          =$p(data,"|",3)
	s Super         	=$p(data,"|",4)
	s State             =$p(data,"|",5)
	s IsLast           	=$p(data,"|",6)
	s Type              =$p(data,"|",7) 
	s DGroup          	=$p(data,"|",8)
	s Classify         	=$p(data,"|",9)
	s Address           =$p(data,"|",10)
	s Phone           	=$p(data,"|",11)
	s StartDate         =$p(data,"|",12)
	s EndDate           =$p(data,"|",13)
	s Storey           	=$p(data,"|",14)
	s Catalogue			=$p(data,"|",15)
	s Dept				=$p(data,"|",16)
	s Mnemonics			=$p(data,"|",17)
	
	i State'="" d
	.i State="有效" s State=1
	.i State="无效" s State=2

	
	i code="" s code=$list(^dhcsyncLocD(Rowid),2)	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid>0)&(tmpRowid'=Rowid) "RepCode"
	
	s rid=0
	s rid=..IfRepName(Name)
	q:(rid>0)&(rid'=Rowid) "RepName"
	
	s oldcode=$list(^dhcsyncLocD(Rowid),2)
	s flag="true"
	&sql(select count(*) into:count from dhc_sync_data.Sync_Loc where Super=:oldcode and State=1)
	i count>0 s flag="false" ; 非末级
	i sysstr="" d
	.s sysidstr=##class(dhc.sync.udata.uSyncLoc).%New()
	.s sysstr=sysidstr.GetSysCode(code)
	i sysstr'="" d
	.s len=$l(sysstr,"^")
	.f i=2:1:len d
	..s sysid=$p(sysstr,"^",i)
	..s syscode=$list(^dhcsyncSystemD(sysid),2)	
	..&SQl(select count(*)into:count from dhc_sync_data.Sync_L2SMap where LocCode=:code and SystemCode=:syscode)
	..i count>0 s state=3 e  s state=1
	..s data1=code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_state_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	..i syscode="PA" d
	...s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	...s ever=locsync.BonusUnitSync(data1)
	..e  d
	...s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
	...s ever=checkrec.SwitchSystem("D",syscode,data1)
	..s data1=code_"|"_Name_"|"_LocLevel_"|"_Super_"|"_state_"|"_IsLast_"|"_Type_"|"_DGroup_"|"_Classify_"|"_Address_"|"_Phone_"|"_Mnemonics_"|"_StartDate_"|"_EndDate_"|"_Storey_"|"_Catalogue_"|"_Dept
	..s info=$p(ever,"^",1)_"|"_$p(ever,"^",2)
	..s insertlog=##class(dhc.sync.udata.uSyncLog).%New()
	..d insertlog.InsertRec(info, code, syscode, data1)
	..i ($p(ever,"^",1)'="-1")&&(count>0) d
	...&sql(update dhc_sync_data.Sync_L2SMap set LocCode=:code where LocCode=:oldcode and SystemCode=:syscode)	
	..e  i ($p(ever,"^",1)'="-1")&&(count=0) d
	...&sql(insert into dhc_sync_data.Sync_L2SMap (LocCode,SystemCode,State) values(:code,:syscode,1))	
	
	s ^hssuploc=ever_"____"_data1
	q:($p(ever,"^",1)="-1") "fail"
	
	i code   		'="" s Plist(2)= code 
	i Name   		'="" s Plist(3)= Name       	      
	i LocLevel  	'="" s Plist(4)= LocLevel
	i Super 		'="" s Plist(5)= Super
	i State   		'="" s Plist(6)= State 
	i IsLast   		'="" s Plist(7)= IsLast
	i Type          '="" s Plist(8)= Type
	i DGroup        '="" s Plist(9)= DGroup
	i Classify      '="" s Plist(10)= Classify
	i Address       '="" s Plist(11)= Address
	i Phone         '="" s Plist(12)= Phone
	i Mnemonics     '="" s Plist(13)= Mnemonics
	i StartDate     '="" s Plist(14)= StartDate
	i EndDate       '="" s Plist(15)= EndDate
	i Storey        '="" s Plist(16)= Storey
	i Catalogue		'="" s Plist(17)= Catalogue
	i Dept			'="" s Plist(18)= Dept
	;w Rowid,"*",code,"*",Name,"*",LocLevel,"*",Super,"*",State,"*",IsLast,!
		
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_Loc"
	s ClassName="dhc.sync.udata.uSyncLoc"
	s ClassNameDesc="科室信息维护"
	s ObjectDesc="修改科室信息及已经同步的系统"
	s NewValue="code:"_code
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"id:"_Rowid,ObjectDesc,"U",NewValue,userId, uname)
	
	s ever=$p(ever,"^",1)
	q:(ever="-1") "fail"
	
	;如果是末级，直接修改，否则，先更新末级下的项的父级为新的编码，在更新
	i flag="true" d
	.&SQL(UPDATE  dhc_sync_data.Sync_Loc VALUES Plist() where %ID=:Rowid) 
	.s rtn=SQLCODE
	e  d
	.&sql(update dhc_sync_data.Sync_Loc set Super=:code where Super=:oldcode )
	.&SQL(UPDATE  dhc_sync_data.Sync_Loc VALUES Plist() where %ID=:Rowid) 
	.s rtn=SQLCODE
	q rtn
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_Loc
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLoc).List("","","roo",0,25)
ClassMethod List(userId, uname, rowid, start, limit) As %String
{
	n (userId, uname,rowid,start,limit)
	s rnode=""
	i rowid="roo" d
	.s rnode=0 
	e  d
	.s rnode=$list(^dhcsyncLocD(rowid),2) ;取code	
		
	s changelog=##class(dhc.sync.udata.SyncChangeLog).%New()
	s TableName="dhc_sync_data.Sync_Loc"
	s ClassName="dhc.sync.udata.uSyncLoc"
	s ClassNameDesc="科室信息维护"
	s ObjectDesc="查询科室信息"
	s NewValue=""
	d changelog.SaveLog(TableName,ClassName,ClassNameDesc ,"",ObjectDesc,"R",NewValue,userId, uname)
	s sqlStr="select Rowid,Code,Name,LocLevel,Super,State,IsLast,Type,DGroup,DEP_Desc,Classify,Address,Phone,Mnemonics,StartDate,EndDate,Storey,Catalogue,Dept,Code1,Code2,Code3"
	_" from dhc_sync_data.Sync_Loc a,RBC_DepartmentGroup b "
	s sqlStr=sqlStr_" where a.DGroup=*b.DEP_Code and Super = '"_rnode_"'"
	
	;w $list(^dhcsyncLocD(1),2)
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString="["
	s end=start+limit-1
	s checkName=##class(ext.util.String).%New()
	w "["
	;s json=##class(herp.comm.JsonObj).%New()
	;s jsonTitle="rowid^Code^Name^LocLevel^Super^State^IsLast"
	While(result.Next())
	{  
		s rowid = result.Data("Rowid")
		s Code=result.Data("Code")
		s Name=result.Data("Name")
		s Code= checkName.EvalJSON(Code)
		s Name= checkName.EvalJSON(Name)
		s LocLevel=result.Data("LocLevel")
		s Super=result.Data("Super")
		i Super = $c(0) d
		.s Super = ""
			
		s State1 = result.Data("State")
		s State=State1
		i State1'="" d
		.i State1=1 s State="有效"
		.i State1=2 s State="无效"
		
		
		s IsLast=result.Data("IsLast")
		i IsLast="Y" s Flag="true"
		else  s Flag="false"
		s Type = result.Data("Type")
		s Type1=Type
		i Type'="" d
		.i Type="E" s Type1="科室"
		.i Type="W" s Type1="病房"
		.i Type="D" s Type1="药房"
		.i Type="EM" s Type1="急诊"
		.i Type="CL" s Type1="门诊诊室"
		.i Type="OP" s Type1="手术室"
		.i Type="O" s Type1="其他"
		
		s DGroup=result.Data("DGroup")
		s Classify=result.Data("Classify")
		s Classify1=Classify
		i Classify'="" d
		.i Classify="E" s Classify1="急诊"
		.i Classify="O" s Classify1="门诊"
		.i Classify="I" s Classify1="住院"
		.i Classify="H" s Classify1="其它"
		
		s Address=result.Data("Address")
		s Address= checkName.EvalJSON(Address)
		s Phone=result.Data("Phone")
		s Mnemonics = result.Data("Mnemonics")
		s StartDate=result.Data("StartDate")
		s EndDate=result.Data("EndDate")
		s Storey=result.Data("Storey")
		s Desc=result.Data("DEP_Desc")
		s Catal=result.Data("Catalogue")
		s Dept=result.Data("Dept")
		s Code1=result.Data("Code1")
		s Code2=result.Data("Code2")
		s Code3=result.Data("Code3")
		    
		
		s tmp="{id:'"_rowid_"',Code:'"_Code_"',Name:'"_Name_"',level:'"_LocLevel
		_"',Super:'"_Super_"',parent:'"_Super_"',State:'"_State_"',IsLast:'"_IsLast_"',leaf:"_Flag
		_",uiProvider:'col'"_",Type:'"_Type_"',DGroup:'"_DGroup_"',Classify:'"_Classify_"',Address:'"
		_Address_"',Phone:'"_Phone_"',Mnemonics:'"_Mnemonics_"',StartDate:'"_StartDate_"',EndDate:'"
		_EndDate_"',Storey:'"_Storey_"'"_",Type1:'"_Type1_"'"_",Classify1:'"_Classify1_"'"
		_",Desc:'"_Desc_"',Catal:'"_Catal_"',Dept:'"_Dept_"',Code1:'"_Code1_"',Code2:'"_Code2
		_"',Code3:'"_Code3_"'}"
	 	
	 	w:count>0 ","
	 	w tmp
       ;q:count=300
		/*i resultString = "[" d
		.s resultString = resultString_tmp
		e  d
		.w resultString,!
		.s resultString = resultString_","_tmp
		*/
		s count=count+1
	}
    w "]"
	d result.Close()
	;s resultString = resultString_"]"
	q "" ;resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-07-25
/// Description: 修改科室信息时，科室对应的已选系统
/// Table: dhc_sync_data.Sync_U2SMap
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.sync.udata.uSyncLoc).GetSysCode("10")
ClassMethod GetSysCode(lcode) As %String
{
	n (lcode)
	s sys = ""
	s sqlStr="select a.*,b.Rowid id from dhc_sync_data.Sync_L2SMap a ,dhc_sync_data.Sync_System b"
	_" where a.SystemCode=b.Code and a.LocCode='"_lcode_"' and a.State ='1' "
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

/// Description: 获取科室部门组信息
/// Table：dhc_sync_data.Sync_Loc
/// Output：
/// Return：科室名称字符串
/// Others：w ##class(dhc.sync.udata.uSyncLoc).locgroupname("0","10","内")
ClassMethod locgroupname(start, limit, str) As %String
{
	n (start, limit, str)
	;SQLUser.CT_LocationList , 
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from RBC_DepartmentGroup" 
	i str'="" s sqlStr = sqlStr_" where  (LOWER(DEP_Code)  LIKE '%"_str_"%'"_" or  UPPER(DEP_Code) LIKE  '%"_str_"%'"_" or  DEP_Desc LIKE '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s code = result.Data("DEP_Code")
		s name = result.Data("DEP_Desc")
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
/// Table: dhc_sync_data.Sync_System
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLoc).ListSys("","",0,10)
ClassMethod ListSys(name, lcode, start, limit) As %String
{
	n (name,lcode,start,limit)
	s sqlStr2="select Rowid,Code,Name,0 State from dhc_sync_data.Sync_System where Active='Y'"
	s sqlStr1="select a.Rowid,Code, Name, State"
	_" from dhc_sync_data.Sync_System a left join dhc_sync_data.Sync_L2SMap b"
	_" on a.Code=b.SystemCode and b.LocCode='"_lcode_"'"
	_" where a.%id>0 and Active='Y'" 
	i lcode'="" s sqlStr=sqlStr1
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

Storage Default
{
<StreamLocation>^dhc.sync.udata.uSyncLocS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
