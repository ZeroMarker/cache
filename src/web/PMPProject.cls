Class web.PMPProject Extends %RegisteredObject
{

/// 项目管理
/// 入参:项目rowid,项目编码Code,项目描述,医院指针,备注,项目经理,项目经理助理,最后更新用户
/// 出参:
/// w ##Class(web.PMPProject).PorjectManager("","PRO-1","这是一个测试项目","2","备注","项目经理","项目经理助理","最后更新人员")
ClassMethod PorjectManager(PJTRowid As %String, ProCode As %String, Desc As %String, Hospital As %String, remark As %String, Manager As %String, Assistant As %String, UpdateUser As %String) As %String
{
 ; pass in date of birth in internal format
 ;创建日期,创建时间,有效状态,创建者,最后更新日期,最后更新时间,最后更新用户
 ;s $p(^PMPProject(1),"^",1)=1 ;project_rowid
 
 Set:remark["备注:" remark=$p(remark,"备注:", 2)
 
 
 s maxrowid = $o(^PMPProject(""),-1)
 ;w !,"<>"_maxrowid_"<>"
 s proid=""
 i PJTRowid="" d
 .s proid=maxrowid+1
 e  d
 .s proid=PJTRowid
 s $p(^PMPProject(proid),"^",1)=ProCode ;项目编码Code
 s $p(^PMPProject(proid),"^",2)=Desc ;项目描述
 s $p(^PMPProject(proid),"^",3)=Hospital ;医院指针
 s $p(^PMPProject(proid),"^",4)=remark ;备注
 i PJTRowid="" s $p(^PMPProject(proid),"^",5)=+($h) ;创建日期
 i PJTRowid="" s $p(^PMPProject(proid),"^",6)=$p($h,",",2) ;创建时间
 s $p(^PMPProject(proid),"^",7)="Y" ;有效状态
 i PJTRowid="" s $p(^PMPProject(proid),"^",8)=UpdateUser ;创建者
 s $p(^PMPProject(proid),"^",9)=Manager ;项目经理
 s $p(^PMPProject(proid),"^",10)=Assistant ;经理助理
 s $p(^PMPProject(proid),"^",11)=+($h) ;最后更新日期
 s $p(^PMPProject(proid),"^",12)=$p($h,",",2) ;最后更新时间
 s $p(^PMPProject(proid),"^",13)=UpdateUser ;最后更新用户
 s $p(^PMPProject(proid),"^",14)="" ;
 s $p(^PMPProject(proid),"^",15)="" ;
 s $p(^PMPProject(proid),"^",16)="" ;
 s $p(^PMPProject(proid),"^",17)="" ;
 s $p(^PMPProject(proid),"^",18)=proid ;
 
 i PJTRowid="" s ^PMPProject(0)=maxrowid+1
 
 s rtn="1"
 i PJTRowid'="" s rtn="0"
 q rtn
}

/// 模块表更新User.PMPModule
/// 入参:项目rowid,项目编码Code,项目描述,医院指针,备注,项目经理,项目经理助理,最后更新用户
/// 出参:
/// w ##Class(web.PMPProject).ModuleManager("","user","版本号^模块编码^模块描述^产品组^产品组负责人^项目名称^备注^2014-1-1^2014-9-9^状态^开发工程师")
ClassMethod ModuleManager(ModuleRowid As %String, UpdateUser As %String, inputstr As %String) As %String
{
 ; pass in date of birth in internal format
 ;s $p(^PMPProject(1),"^",1)=1 ;project_rowid
 
 ;s ^zzp("1")=inputstr
 s maxrowid = $o(^PMPModule(""),-1)
 ;w !,"<>"_maxrowid_"<>"
 s proid=""
 i ModuleRowid="" d
 .s proid=maxrowid+1
 e  d
 .s proid=ModuleRowid
 ;版本号^模块编码^模块描述^产品组^产品组负责人^项目名称^备注^计划上线日期^时间上线日期^状态^开发工程师 
 s ModuleCode =$p(inputstr,"^",2)
 s ModuleDesc =$p(inputstr,"^",3)
 s ActuclDate =$p(inputstr,"^",9)
 s DevelopUser =$p(inputstr,"^",11)
 s PlanDate =$p(inputstr,"^",8)
 s Product =$p(inputstr,"^",4)
 s Remark =$p(inputstr,"^",7)
 s Project1 =$p(inputstr,"^",6)
 s Status =$p(inputstr,"^",10)
 s bbh =$p(inputstr,"^",1)
 s Productleader=$p(inputstr,"^",5)
 i ActuclDate="31/12/1840" s ActuclDate=""
 i PlanDate="31/12/1840" s PlanDate=""
 Set:ActuclDate["-" ActuclDate=$zdh(ActuclDate, 3)         
 Set:PlanDate["-" PlanDate=$zdh(PlanDate, 3)
 Set:ActuclDate["/" ActuclDate=$zdh(ActuclDate, 4)
 Set:PlanDate["/" PlanDate=$zdh(PlanDate, 4)
 i (ActuclDate="0")||(ActuclDate=" ") s ActuclDate=""
 i (PlanDate="0")||(PlanDate=" ") s PlanDate=""

 Set:ModuleDesc["模块描述:" ModuleDesc=$p(ModuleDesc,"模块描述:", 2)
 Set:Remark["备注:" Remark=$p(Remark,"备注:", 2)
 
 s $p(^PMPModule(proid),"^",1)=ModuleCode ;模块编码Code
 s $p(^PMPModule(proid),"^",2)=ModuleDesc ;模块描述
 i ModuleRowid="" s $p(^PMPModule(proid),"^",3)=+($h) ;创建日期MODE_Date
 s $p(^PMPModule(proid),"^",4)=ActuclDate ;实际上线日期9	MODE_ActuclDate
 s $p(^PMPModule(proid),"^",5)=DevelopUser ;开发工程师MODE_DevelopUser
 s $p(^PMPModule(proid),"^",6)=PlanDate ;计划上线日期MODE_PlanDate
 s $p(^PMPModule(proid),"^",7)=Product ;产品组MODE_Product_DR
 s $p(^PMPModule(proid),"^",8)=Remark ;备注MODE_Remark
 s $p(^PMPModule(proid),"^",9)=Project1 ;项目指针MODE_Project1_DR
 s $p(^PMPModule(proid),"^",10)=Status ;项目状态MODE_Status_DR
 i ModuleRowid="" s $p(^PMPModule(proid),"^",11)=$p($h,",",2) ;创建时间MODE_Time
 s $p(^PMPModule(proid),"^",12)=+($h) ;最后更新日期MODE_UpdateDate
 s $p(^PMPModule(proid),"^",13)=$p($h,",",2) ;最后更新时间MODE_UpdateTime
 s $p(^PMPModule(proid),"^",14)=UpdateUser ;更新人MODE_UpdateUser_DR
 i ModuleRowid="" s $p(^PMPModule(proid),"^",15)=UpdateUser ;创建者MODE_User_DR
 s $p(^PMPModule(proid),"^",16)=bbh ;版本号MODE_Standby1
 s $p(^PMPModule(proid),"^",17)=Productleader ;产品组负责人MODE_Standby2
 s $p(^PMPModule(proid),"^",18)="" ;备用MODE_Standby3
 s $p(^PMPModule(proid),"^",19)="" ;备用MODE_Standby4
 s $p(^PMPModule(proid),"^",20)="" ;备用MODE_Standby5
 s $p(^PMPModule(proid),"^",21)="" ;备用MODE_Standby6
 s $p(^PMPModule(proid),"^",22)="" ;备用MODE_Standby7
 s $p(^PMPModule(proid),"^",23)="" ;备用MODE_Standby8
 s $p(^PMPModule(proid),"^",24)="" ;备用MODE_Standby9
 
 i ModuleRowid="" s ^PMPModule(0)=maxrowid+1
 
 s rtn="1"
 i ModuleRowid'="" s rtn="0"
 q rtn
}

/// 模块负责人更新
/// 入参:模块负责人rowid,成员Rowid,模块Rowid,备注,开始日期,结束日期,更新用户,有效性
/// w ##Class(web.PMPProject).ModeUserManager("7","Userid","Modeid","备注","63487","63488","更新用户","yes")
ClassMethod ModeUserManager(ModeUserRowid As %String, Userid As %String, Modeid As %String, bz As %String, startdate As %String, enddate As %String, updateuser As %String, flag As %String) As %String
{
	//s ^zzp("cheshi")="1"
 ; pass in date of birth in internal format
 ;PMP_ModuleUser
 Set:bz["备注:" bz=$p(bz,"备注:", 2)
 
 s maxrowid = $o(^PMPModuleUser(""),-1)
 ;w !,"<>"_maxrowid_"<>"
 s myrowid=""
 i ModeUserRowid="" d
 .s myrowid=maxrowid+1
 e  d
 .s myrowid=ModeUserRowid
 Set:startdate["-" startdate=$zdh(startdate, 3)         
 Set:enddate["-" enddate=$zdh(enddate, 3)
 Set:startdate["/" startdate=$zdh(startdate, 4)
 Set:enddate["/" enddate=$zdh(enddate, 4)
 s $p(^PMPModuleUser(myrowid),"^",1)=$p($h,",",1) ;更新日期MDU_Date
 s $p(^PMPModuleUser(myrowid),"^",2)=enddate ;结束日期MDU_EnDate
 s $p(^PMPModuleUser(myrowid),"^",3)=86399 ;结束时间MDU_Time
 s $p(^PMPModuleUser(myrowid),"^",4)=flag ;有效性MDU_Falg
 s $p(^PMPModuleUser(myrowid),"^",5)=Modeid ;模块rowid  MDU_Module_DR
 s $p(^PMPModuleUser(myrowid),"^",6)=bz ;备注MDU_Remark
 s $p(^PMPModuleUser(myrowid),"^",7)=startdate ;开始日期MDU_StDate
 s $p(^PMPModuleUser(myrowid),"^",8)=0 ;开始时间MDU_StTime
 s $p(^PMPModuleUser(myrowid),"^",9)=$p($h,",",2) ;更新时间MDU_Time
 s $p(^PMPModuleUser(myrowid),"^",10)=Userid ;成员MDU_User_DR
 s $p(^PMPModuleUser(myrowid),"^",11)=updateuser ;更新用户MDU_User1_DR
 s $p(^PMPModuleUser(myrowid),"^",12)="" ;备用1
 s $p(^PMPModuleUser(myrowid),"^",13)="" ;备用2
 s $p(^PMPModuleUser(myrowid),"^",14)="" ;备用3
 s $p(^PMPModuleUser(myrowid),"^",15)="" ;备用4
 s $p(^PMPModuleUser(myrowid),"^",16)="" ;备用5
 s $p(^PMPModuleUser(myrowid),"^",17)="" ;备用6
 s $p(^PMPModuleUser(myrowid),"^",18)="" ;备用7
 i ModeUserRowid="" s ^PMPModuleUser(0)=maxrowid+1
 s rtn="1"
 i ModeUserRowid'="" s rtn="0"
 q rtn
}

/// 模块负责人更新查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ModeUser","","","","")
Query ModeUser(User As %String, Module As %String) As %Query(ROWSPEC = "tUser:%String,tModule:%String,tFlag:%String,tStDate:%String,tStTime:%String,tEnDate:%String,tEnTime:%String,tUpdateUser:%String,tUpdateDate:%String,tUpdateTime:%String,tRemark:%String,rowid:%String")
{
}

/// 模块负责人更新查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ModeUser","","")
ClassMethod ModeUserExecute(ByRef qHandle As %Binary, User As %String, Module As %String) As %Status
{
 	//固定写法=========begin
 	Set repid=$I(^CacheTemp)	
    Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    //固定写法=========end
    s ^zhaoyan(0)=User_"^"_Module
    //日期格式转换=====begin
 	;Set:startdate["-" startdate=$zdh(startdate, 3)         
	;Set:endate["-" endate=$zdh(endate, 3)
	;Set:startdate["/" startdate=$zdh(startdate, 4)
	;Set:endate["/" endate=$zdh(endate, 4)
	//日期格式转换=====end
	
	//====初始化=====begin==
	
	set username = ""  //成员姓名
	set modename = ""  //模块名称
	set flag = ""  //有效性
	set startdate ="" //开始日期
	set startime =""  //开始时间
	set endate =""  //结束日期
	set endtime =""  //结束时间
	set upuser =""   //更新用户
	set update = "" //更新日期
	set uptime = "" //更新时间
	set remark = "" //备注
	
	//====初始化=====end====
 	i User'="" d 
 	.s rowid="0"
	.for  set rowid = $o(^PMPModuleUser(rowid))  quit:rowid=""   do
	..set userid2 =$p(^PMPModuleUser(rowid),"^",10)   
 	..set username=$p(^SSU("SSUSR",userid2),"^",2) //成员姓名
	..set modeid = $p(^PMPModuleUser(rowid),"^",5)  //模块名称
	..s modename=$p(^PMPModule(modeid),"^",2)
	..q:(username'="")&(username'[User)
	..set flag = $p(^PMPModuleUser(rowid),"^",4)  //有效性
	..set startdate =$zd($p(^PMPModuleUser(rowid),"^",7),4) //开始日期
	..set startime =$zt($p(^PMPModuleUser(rowid),"^",8))  //开始时间
	..set endate =$zd($p(^PMPModuleUser(rowid),"^",2),4)  //结束日期
	..set endtime =$zt($p(^PMPModuleUser(rowid),"^",3))  //结束时间
	..;set upuser =$p(^PMPModuleUser(rowid),"^",11)   //更新用户
	..set userid1 =$p(^PMPModuleUser(rowid),"^",11)   
 	..set upuser=$p(^SSU("SSUSR",userid1),"^",2) //更新用户
	..set update = $zd($p(^PMPModuleUser(rowid),"^",1),3) //更新日期
	..set uptime = $zt($p(^PMPModuleUser(rowid),"^",9)) //更新时间
	..set remark = $p(^PMPModuleUser(rowid),"^",6) //备注
	..d OutputRow
	
	
	
	
	i ((User="")&&(Module="")) d
	.s rowid="0"
	.for  set rowid = $o(^PMPModuleUser(rowid))  quit:rowid=""   do
 	..;
	..;set username = $p(^PMPModuleUser(rowid),"^",10)  
	..set userid2 =$p(^PMPModuleUser(rowid),"^",10)   
 	..set username=$p(^SSU("SSUSR",userid2),"^",2) //成员姓名
	..set modeid = $p(^PMPModuleUser(rowid),"^",5)  //模块名称
	..s modename=$p(^PMPModule(modeid),"^",2)
	..set flag = $p(^PMPModuleUser(rowid),"^",4)  //有效性
	..set startdate =$zd($p(^PMPModuleUser(rowid),"^",7),4) //开始日期
	..set startime =$zt($p(^PMPModuleUser(rowid),"^",8))  //开始时间
	..set endate =$zd($p(^PMPModuleUser(rowid),"^",2),4)  //结束日期
	..set endtime =$zt($p(^PMPModuleUser(rowid),"^",3))  //结束时间
	..;set upuser =$p(^PMPModuleUser(rowid),"^",11)   //更新用户
	..set userid1 =$p(^PMPModuleUser(rowid),"^",11)   
 	..set upuser=$p(^SSU("SSUSR",userid1),"^",2) //更新用户
	..set update = $zd($p(^PMPModuleUser(rowid),"^",1),3) //更新日期
	..set uptime = $zt($p(^PMPModuleUser(rowid),"^",9)) //更新时间
	..set remark = $p(^PMPModuleUser(rowid),"^",6) //备注
	..d OutputRow

	 
	
	//固定写法=========begin
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
	set Data=$lb(username,modename,flag,startdate,startime,endate,endtime,upuser,update,uptime,remark,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	//固定写法=========end
 	
	q $$$OK
}

ClassMethod ModeUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ModeUserExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ModeUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ModeUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// //==============================
/// 项目创建查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","Project","","","","")
Query Project(PROCEDE As %String, HOSPITAL As %String) As %Query(ROWSPEC = "tCode:%String,tProDesc:%String,tHospital:%String,tRemark:%String,tCreateDate:%String,tCreateTime:%String,tCteatePerson:%String,tFlag:%String,tProManager:%String,tProAssistant:%String,tUpDate:%String,tUpTime:%String,tUpUser:%String,rowid:%String")
{
}

/// 项目创建查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","Project","","")
ClassMethod ProjectExecute(ByRef qHandle As %Binary, PROCEDE As %String, HOSPITAL As %String) As %Status
{
 	//固定写法=========begin
 	Set repid=$I(^CacheTemp)	
    Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    //固定写法=========end
    ;s ^zhaoyan(0)=PROCEDE_"^"_HOSPITAL
    //日期格式转换=====begin
 	;Set:startdate["-" startdate=$zdh(startdate, 3)         
	;Set:endate["-" endate=$zdh(endate, 3)
	;Set:startdate["/" startdate=$zdh(startdate, 4)
	;Set:endate["/" endate=$zdh(endate, 4)
	//日期格式转换=====end
	
	//====初始化=====begin==
	
	s (tCode ,tProDesc ,tHospital ,tRemark ,tCreateDate ,tCreateTime ,tCteatePerson ,tFlag ,tProManager ,tProAssistant ,tUpDate ,tUpTime ,tUpUser ,proid ,userid2)=""
	
	//====初始化=====end====
    
    
 	i PROCEDE="" d 
 	.s proid="0"
	.for  set proid = $o(^PMPProject(proid))  quit:proid=""   do
	..s tCode=$p(^PMPProject(proid),"^",1) ;项目编码Code
 	..s tProDesc=$p(^PMPProject(proid),"^",2) ;项目描述
 	..s tHospital=$p(^PMPProject(proid),"^",3) ;医院指针
 	..s tRemark=$p(^PMPProject(proid),"^",4) ;备注
 	..s tCreateDate=$zd($p(^PMPProject(proid),"^",5),4) ;创建日期
 	..s tCreateTime=$zt($p(^PMPProject(proid),"^",6)) ;创建时间
 	..s tFlag=$p(^PMPProject(proid),"^",7) ;有效状态
 	..i tFlag="Y" d
 	...s tFlag="有效"
 	..e  d
 	...s tFlag="无效"
 	..s userid1=""
 	..s tCteatePersonid=$p(^PMPProject(proid),"^",8) ;创建者
 	..i tCteatePersonid'="" s tCteatePerson=$p(^SSU("SSUSR",tCteatePersonid),"^",2)
 	..s tProManagerid=$p(^PMPProject(proid),"^",9) ;项目经理
 	..i tProManagerid'="" s tProManager=$p(^SSU("SSUSR",tProManagerid),"^",2)
 	..s tProAssistantid=$p(^PMPProject(proid),"^",10) ;经理助理
 	..i tProAssistantid'="" s userid0=$p(^PMPProjectUser(tProAssistantid),"^",1)
 	..i tProAssistantid'="" s tProAssistant=$p(^SSU("SSUSR",userid0),"^",2)
 	..s tUpDate=$zd($p(^PMPProject(proid),"^",11),4) ;最后更新日期
 	..s tUpTime=$zt($p(^PMPProject(proid),"^",12)) ;最后更新时间
 	..s tUpUserid=$p(^PMPProject(proid),"^",13) ;最后更新用户
 	..i tUpUserid'=""  s tUpUser=$p(^SSU("SSUSR",tUpUserid),"^",2)
	..d OutputRow1
	
	
	//固定写法=========begin
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    
	set Data=$lb(tCode ,tProDesc ,tHospital ,tRemark ,tCreateDate ,tCreateTime ,tCteatePerson ,tFlag ,tProManager ,tProAssistant ,tUpDate ,tUpTime ,tUpUser ,proid )
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	//固定写法=========end
 	
	q $$$OK
}

ClassMethod ProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProjectExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProjectExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// //==============================
/// 状态查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ModeState","")
Query ModeState(desc As %String) As %Query(ROWSPEC = "rowid:%String,statedesc:%String")
{
}

/// 项目创建查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ModeState","")
ClassMethod ModeStateExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	//固定写法=========begin
 	Set repid=$I(^CacheTemp)	
    Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    //固定写法=========end
    
	//====初始化=====begin==
	s (rowid,statedesc)=""
	//====初始化=====end====
    
    
 	i desc="" d 
 	.s rowid="0"
	.for  set rowid = $o(^PMPDictionary("FLAG","MODESTATE",rowid))  quit:rowid=""   do
	..s statedesc=$p(^PMPDictionary(rowid),"^",2) ;状态描述
	..d OutputRow12	
	 
	
	//固定写法=========begin
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12
    
	set Data=$lb(rowid,statedesc )
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	//固定写法=========end
 	
	q $$$OK
}

ClassMethod ModeStateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ModeStateExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ModeStateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ModeStateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// //==============================
/// 模块查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","Moudle","","")
Query Moudle(PROCEDE As %String, HOSPITAL As %String) As %Query(ROWSPEC = "tStandby1:%String,tCode:%String,tDesc:%String,tProductDR:%String,tStandby2:%String,tProName:%String,rRemark:%String,tPlanDate:%String,tActuclDate:%String,tStatus:%String,tDevelopUser:%String,MoudleId:%String")
{
}

/// 项目创建查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","Moudle","","")
ClassMethod MoudleExecute(ByRef qHandle As %Binary, PROCEDE As %String, HOSPITAL As %String) As %Status
{
 	//固定写法=========begin
 	Set repid=$I(^CacheTemp)	
    Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    //固定写法=========end
    ;s ^zhaoyan(0)=PROCEDE_"^"_HOSPITAL
    //日期格式转换=====begin
 	;Set:startdate["-" startdate=$zdh(startdate, 3)         
	;Set:endate["-" endate=$zdh(endate, 3)
	;Set:startdate["/" startdate=$zdh(startdate, 4)
	;Set:endate["/" endate=$zdh(endate, 4)
	//日期格式转换=====end
	
	//====初始化=====begin==
	;版本号^模块编码^模块描述^产品组^产品组负责人^项目名称^备注^计划上线日期^时间上线日期^状态^开发工程师 
 
	s (tStandby1,tCode,tDesc,tProductDR,tStandby2,tProName,rRemark,tPlanDate,tActuclDate,tStatus,tDevelopUser,MoudleId )=""
	s (CreateDate,CreateTime,Update,Uptime,UpUser,CreateUser)=""
	//====初始化=====end====
    
    
 	i PROCEDE="" d 
 	.s MoudleId="0"
	.for  set MoudleId = $o(^PMPModule(MoudleId))  quit:MoudleId=""   do
	..s tCode=$p(^PMPModule(MoudleId),"^",1) ;模块编码Code
 	..s tDesc=$p(^PMPModule(MoudleId),"^",2) ;模块描述
 	..s CreateDate=$p(^PMPModule(MoudleId),"^",3) ;创建日期MODE_Date
 	..s tActuclDate=$p(^PMPModule(MoudleId),"^",4) ;实际上线日期9	MODE_ActuclDate
 	..i tActuclDate'="" s tActuclDate=$zd(tActuclDate,4)
 	..s tDevelopUser=$p(^PMPModule(MoudleId),"^",5) ;开发工程师MODE_DevelopUser
 	..s tPlanDate=$p(^PMPModule(MoudleId),"^",6) ;计划上线日期MODE_PlanDate
 	..i tPlanDate'="" s tPlanDate=$zd(tPlanDate,4)
 	..s tProductDR=$p(^PMPModule(MoudleId),"^",7) ;产品组MODE_Product_DR
 	..I tProductDR'="" S tProductDR=$P(^PMPDictionary(tProductDR),"^",2)
 	..s rRemark=$p(^PMPModule(MoudleId),"^",8) ;备注MODE_Remark
 	..s tProNameid=$p(^PMPModule(MoudleId),"^",9) ;项目指针MODE_Project1_DR
 	..s tProName=$p(^PMPProject(tProNameid),"^",2)
 	..s tStatusid=$p(^PMPModule(MoudleId),"^",10) ;项目状态MODE_Status_DR
 	..s tStatus=$p(^PMPDictionary(tStatusid),"^",2)
 	..s CreateTime=$p(^PMPModule(MoudleId),"^",11) ;创建时间MODE_Time
 	..s Update=$p(^PMPModule(MoudleId),"^",12) ;最后更新日期MODE_UpdateDate
 	..s Uptime=$p(^PMPModule(MoudleId),"^",13) ;最后更新时间MODE_UpdateTime
 	..s UpUser=$p(^PMPModule(MoudleId),"^",14) ;更新人MODE_UpdateUser_DR
 	..s CreateUser=$p(^PMPModule(MoudleId),"^",15) ;创建者MODE_User_DR
 	..s tStandby1=$p(^PMPModule(MoudleId),"^",16) ;版本号MODE_Standby1
 	..s tStandby2=$p(^PMPModule(MoudleId),"^",17) ;产品组负责人MODE_Standby2
 	..;s $p(^PMPModule(proid),"^",18)="" ;备用MODE_Standby3
 	..;s $p(^PMPModule(proid),"^",19)="" ;备用MODE_Standby4
 	..;s $p(^PMPModule(proid),"^",20)="" ;备用MODE_Standby5
 	..;s $p(^PMPModule(proid),"^",21)="" ;备用MODE_Standby6
 	..;s $p(^PMPModule(proid),"^",22)="" ;备用MODE_Standby7
 	..;s $p(^PMPModule(proid),"^",23)="" ;备用MODE_Standby8
 	..;s $p(^PMPModule(proid),"^",24)="" ;备用MODE_Standby9
	..d OutputRow1	
	;版本号^模块编码^模块描述^产品组^产品组负责人^项目名称^备注^计划上线日期^时间上线日期^状态^开发工程师 
 
	;tStandby1^tCode^tDesc^tProductDR^tStandby2^tProName^rRemark^tPlanDate^tActuclDate^tStatus^tDevelopUser
	 
	
	//固定写法=========begin
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    
	set Data=$lb(tStandby1,tCode,tDesc,tProductDR,tStandby2,tProName,rRemark,tPlanDate,tActuclDate,tStatus,tDevelopUser,MoudleId )
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	//固定写法=========end
 	
	q $$$OK
}

ClassMethod MoudleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudleExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MoudleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// //==============================
/// 项目查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ProductQ","")
Query ProductQ(desc As %String) As %Query(ROWSPEC = "statedesc:%String,rowid:%String")
{
}

/// 项目创建查询
/// do ##class(%ResultSet).RunQuery("web.PMPProject","ProductQ","")
ClassMethod ProductQExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	//固定写法=========begin
 	Set repid=$I(^CacheTemp)	
    Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    //固定写法=========end
    
	//====初始化=====begin==
	s (rowid,statedesc)=""
	//====初始化=====end====
    
    
 	i desc="" d 
 	.s rowid="0"
	.for  set rowid = $o(^PMPProject(rowid))  quit:rowid=""   do
	..s statedesc=$p(^PMPProject(rowid),"^",2) ;状态描述
	..d OutputRow12	
	 
	
	//固定写法=========begin
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12
    
	set Data=$lb(statedesc,rowid )
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	//固定写法=========end
 	
	q $$$OK
}

ClassMethod ProductQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProductQExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ProductQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProductQExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///       Input: PROCEDE
///      Return：存在返回0,不存在返回1
///     Creator：liubaoshi
///        Date: 2015-01-10
/// Description: 验证所增加项目是否存在
///       Table：PMP_Project
///       Other: w ##class(web.PMPProject).CheckProject("ZGSYGDJ")
ClassMethod CheckProject(PROCEDE As %String) As %String
{
	Set ret=1
	Set Rowid=""
    For  Set Rowid=$o(^PMPProject(Rowid)) Q:(Rowid="")  d
    .i ($p(^PMPProject(Rowid),"^",1)=PROCEDE)  d
    ..Set ret=0  e  d  s ret=1
    Q ret
}

/// 删除
/// 增加删除事件
/// liubaoshi
ClassMethod del(rowid As %Library.String)
{
	Q:rowid="" 0
	&sql(delete from  SqlUser.PMP_Project where PJT_Rowid=:rowid)
    Q:SQLCODE -1
    Q 0
}

}
