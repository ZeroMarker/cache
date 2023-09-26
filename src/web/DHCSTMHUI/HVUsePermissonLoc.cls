Import sqluser

/// Descript:   高值条码生成,科室或者人员授权维护
/// CreateDate: 20170702 lihui
Class web.DHCSTMHUI.HVUsePermissonLoc Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   查询科室授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input:
/// Table:DHC_HVUsePermisson_Loc     
/// Return:Rowid^执行科室id^执行科室描述^创建日期^创建人id^创建人^更新日期^更新人id^更新人^开始日期^截止日期^开始时间^截止时间^是否启用标志
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HVUsePermissonLoc","selectAll")
Query selectAll(Params = "") As websys.Query(ROWSPEC = "HUPLrowid,OperLocId,OperLocDesc,CreateDate,CreateUserDr,CreateUser,UpdateDate,UpdateUserDr,UpdateUser,StartDate,EndDate,StartTime,EndTime,Active") [ SqlProc ]
{
}

ClassMethod selectAllExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("Hospital") ;选择的医院ID
	i pHospId="" s pHospId=gHospId
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT HUPL_Rowid AS HUPLrowid, HUPL_Loc_Dr AS LocdId, HUPL_CreateDate, HUPL_CreateUser_Dr AS CreateUserDr,"_
		"HUPL_UpdateDate, HUPL_UpdateUser_Dr AS UpdateUserDr, HUPL_StartDate, HUPL_EndDate,"_
		"HUPL_StartTime, HUPL_EndTime, HUPL_Active AS Active FROM DHC_HVUsePermisson_Loc"
	d Result.Prepare(SqlStr)
	d Result.Execute()	
	while(Result.Next())
	{
		s HUPLrowid=Result.Data("HUPLrowid")
		s OperLocId=Result.Data("LocdId")  //执行科室
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(OperLocId,pHospId)'=0)
		s Locdesc=""
		s:OperLocId'="" OperLocDesc=$p($g(^CTLOC(OperLocId)),"^",2)
		s CreateDate=Result.Data("HUPL_CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate) //创建日期
		s (CreateUser,UpdateUser)=""
		s CreateUserDr=Result.Data("CreateUserDr") //创建人
		s:CreateUserDr'="" CreateUser=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
		s UpdateDate=Result.Data("HUPL_UpdateDate") //更新日期
		s:UpdateDate'="" UpdateDate=..DL2H(UpdateDate)
		s UpdateUserDr=Result.Data("UpdateUserDr")  //更新人
		s:UpdateUserDr'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
		s StartDate=Result.Data("HUPL_StartDate")   //开始日期
		s:StartDate'="" StartDate=..DL2H(StartDate)
		s EndDate=Result.Data("HUPL_EndDate")    //结束日期
		s:EndDate'="" EndDate=..DL2H(EndDate)
		s StartTime=Result.Data("HUPL_StartTime")  //开始时间
		s:StartTime'="" StartTime=..TL2H(StartTime)
		s EndTime=Result.Data("HUPL_EndTime") //结束时间
		s:EndTime'="" EndTime=..TL2H(EndTime)
		s Active=Result.Data("Active")  //是否使用标志
		d OutPutRow
	}
 	Quit $$$OK
OutPutRow
 s Data=$lb(HUPLrowid,OperLocId,OperLocDesc,CreateDate,CreateUserDr,CreateUser,UpdateDate,UpdateUserDr,UpdateUser,StartDate,EndDate,StartTime,EndTime,Active)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:   保存更新科室授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input: ^执行科室id^开始日期^开始时间^截止日期^截止时间^是否启用标志,医院id^安全组id^科室id^用户id
/// Table:DHC_HVUsePermisson_Loc     
/// Return:0 保存成功;-1更新失败,-2插入失败,其余失败;
/// d ##class(web.DHCSTMHUI.HVUsePermissonLoc).SavePerMLoc("[{""OperLocDesc"":""保健病房护理单元"",""OperLocId"":""219"        ",""StartDate"":""04/12/2018"",""StartTime"":""01:00:00"",""EndDate"":""06/12/2018"",""EndTime"":""02:00:00"",""Active"":""Y""}]","6444")
ClassMethod SavePerMLoc(Params As %String, DOuser As %String) As %Library.String
{
	n (Params,DOuser,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("HUPLrowid")
		s OperLoc=Obj.%Get("OperLocId") ;执行科室
		q:OperLoc=""
		s locdesc=$p($g(^CTLOC(OperLoc)),"^",2)
		s StartDate=Obj.%Get("StartDate")
		s EndDate=Obj.%Get("EndDate")
		q:EndDate=""
		q:StartDate=""
		s StartTime=Obj.%Get("StartTime")
		s EndTime=Obj.%Get("EndTime")
		s:StartTime="" StartTime="00:00:00"
		s:EndTime="" EndTime="23:59:59"
		s:StartDate'="" StartDate=..DH2L(StartDate)
		s:EndDate'="" EndDate=..DH2L(EndDate)
		s:StartTime'="" StartTime=..TH2L(StartTime)
		s:EndTime'="" EndTime=..TH2L(EndTime)
		q:(StartDate>EndDate) ;开始日期不能晚于截止日期
		q:(StartTime>EndTime)  ;截止时间不能早于开始时间
		s Active=Obj.%Get("Active") ;是否启用标志
		i Rowid'="" d
		.s RtnObj=..Update(Rowid,OperLoc,StartDate,StartTime,EndDate,EndTime,Active,DOuser)
		e  d
		.s RtnObj=..Insert(OperLoc,StartDate,StartTime,EndDate,EndTime,Active,DOuser)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加科室授权记录
/// Creater:	lihui
/// CreateDate:	20170702
/// Table: DHC_HVUsePermisson_Loc
/// Input: 执行科室id,开始日期,开始时间,截止日期,截止时间,是否启用标志,医院id^安全组id^科室id^用户id
/// Return：大于0 :保存成功, 空 保存失败;
ClassMethod Insert(Locid As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String, DOuser As %String) As %Library.String [ Private ]
{
	n (Locid,StartDate,StartTime,EndDate,EndTime,Active,DOuser,%session)
	s RtnObj=##class(RtnObj).%New()
	s DOdate=..DL2H(+$h)
	s HUPLRowid=""
	&sql(SELECT HUPL_Rowid into:HUPLRowid FROM DHC_HVUsePermisson_Loc WHERE HUPL_Loc_Dr=:Locid AND HUPL_StartDate=:StartDate AND HUPL_EndDate=:EndDate AND HUPL_StartTime=:StartTime AND HUPL_EndTime=:EndTime)
	i +HUPLRowid>0 d
	.s Sc=RtnObj.Err(-3,"","存在重复记录","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(INSERT INTO DHC_HVUsePermisson_Loc (HUPL_Loc_Dr,HUPL_CreateDate,HUPL_CreateUser_Dr,HUPL_StartDate,HUPL_EndDate,HUPL_StartTime,HUPL_EndTime,HUPL_Active) 
		VALUES(:Locid,:DOdate,:DOuser,:StartDate,:EndDate,:StartTime,:EndTime,:Active))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_Loc","User.DHCHVUsePermissonLoc","高值紧急业务科室授权维护",$SYSTEM.SQL.GetROWID(),Locid,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新科室授权记录
/// Creater:	lihui
/// CreateDate:	20170702
/// Table: DHC_HVUsePermisson_Loc
/// Input: Rowid,执行科室id,开始日期,开始时间,截止日期,截止时间,是否启用标志,医院id^安全组id^科室id^用户id
/// Return 0 更新成功; -1 更新失败;
ClassMethod Update(Rowid As %String, Locid As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String, DOuser As %String) As %Library.String [ Private ]
{
	n (Rowid,Locid,StartDate,StartTime,EndDate,EndTime,Active,DOuser,%session)
	s RtnObj=##class(RtnObj).%New()
	s DOdate=..DL2H(+$h)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVUsePermisson_Loc",Rowid)
	&sql(UPDATE DHC_HVUsePermisson_Loc SET HUPL_Loc_Dr=:Locid,HUPL_UpdateDate=:DOdate,HUPL_UpdateUser_Dr=:DOuser,HUPL_StartDate=:StartDate,HUPL_EndDate=:EndDate,HUPL_StartTime=:StartTime,HUPL_EndTime=:EndTime,HUPL_Active=:Active WHERE HUPL_Rowid=:Rowid)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_Loc","User.DHCHVUsePermissonLoc","高值紧急业务科室授权维护",Rowid,Locid,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:   删除科室授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input: Rowid
/// Table:DHC_HVUsePermisson_Loc     
/// Return:0 删除成功;其余失败;
/// w ##class(web.DHCSTMHUI.HVUsePermissonLoc).DeletePerMLoc("[{""HUPLrowid"":""15"",""OperLoc"":""5"",""OperLocDesc"":""风湿  免疫科门诊"",""CreateDate"":""19/11/2018"",""CreateUserDr"":""6444"",""CreateUse     r"":""wxj"",""UpdateDate"":""20/11/2018"",""UpdateUserDr"":""6444"",""UpdateUser"":""wxj"",""StartDate"":""22/11/2018"",""EndDate"":""07/12/2018"",""StartTime"":""00:00:00"",""EndTime"":""23:59:59"",""Active"":""N""}]")
ClassMethod DeletePerMLoc(Params As %String) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("HUPLrowid")
		q:RowId=""
		s LocId=Obj.%Get("OperLocId")
		s Loc=$p($g(^CTLOC(LocId)),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVUsePermisson_Loc",RowId)
	 	&sql(DELETE from DHC_HVUsePermisson_Loc WHERE HUPL_Rowid=:RowId)
	 	i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_Loc","User.DHCHVUsePermissonLoc","高值紧急业务科室授权维护",RowId,Loc,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript: 判断起始截止日期是否有重叠的记录
/// CreateDate: 20170702
/// Creater: lihui
/// Input: 执行科室id^开始日期^开始时间
/// Table:DHC_HVUsePermisson_Loc     
/// Return:0 无;-1 存在重叠记录;
/// w ##class(web.DHCSTMHUI.HVUsePermissonLoc).ExitOverlapped(2,"2017-07-07","2017-07-14")
ClassMethod ExitOverlapped(HUPLrowid As %String, Loc As %String, StartDate As %String, EndDate As %String) As %Library.String
{
	n (HUPLrowid,Loc,StartDate,EndDate)
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	s:EndDate'="" EndDate=$zdh(EndDate,3)
	s rowid="",ret=0
	f  s rowid=$o(^DHCHUPL(0,"OperLoc",Loc,rowid)) q:(rowid="")||(ret=1)  d
	.s InfoStr=^DHCHUPL(rowid)
	.s tmpStartDate=$p(InfoStr,"^",6)
	.s tmpEndDate=$p(InfoStr,"^",7)
	.i (HUPLrowid'=rowid)&&(StartDate>=tmpStartDate)&&(StartDate<=tmpEndDate) d ;开始日期存在重叠
	..s ret=1
	.i (HUPLrowid'=rowid)&&(EndDate>=tmpStartDate)&&(EndDate<=tmpEndDate) d ;截止日期存在重叠
	..s ret=1
	.i (HUPLrowid'=rowid)&&(tmpStartDate>=StartDate)&&(tmpStartDate<=EndDate) d ;此记录包含了其他记录起始截止日期
	..s ret=1
	.i (HUPLrowid'=rowid)&&(tmpEndDate>=StartDate)&&(tmpEndDate<=EndDate) d ;此记录包含了其他记录起始截止日期
	..s ret=1
	q ret
}

/// Descript:  判断科室是否有权生成高值条码
/// CreateDate:  20170702
/// Creater:  lihui
/// Input:  执行科室id
/// Table: DHC_HVUsePermisson_Loc     
/// Return: -1 科室未授权;-2 科室人员未授权;0存在授权日期时间
/// w ##class(web.DHCSTMHUI.HVUsePermissonLoc).IfAllowDo(114,6423)
ClassMethod IfAllowDo(Loc As %String, User As %String) As %Library.String
{
	n (Loc,User)
	s RtnObj=##class(RtnObj).%New()
	s NowDate=+$h
	s NowTime=$p($h,",",2)
	s tmprowid=$o(^DHCHUPL(0,"OperLoc",Loc,""))
	q:tmprowid="" RtnObj.Err(-1,"","此请求科室没有操作高值入库权限","",0).Json()
	
	s rowid=0,countLoc=0,UserActive="N"
	f  s rowid=$o(^DHCHUPL(0,"OperLoc",Loc,rowid)) q:(rowid="")||(UserActive="Y")  d
	.s InfoStr=^DHCHUPL(rowid)
	.s tmpStartDate=$p(InfoStr,"^",6) ;开始日期
	.s tmpEndDate=$p(InfoStr,"^",7) ;截止日期
	.s tmpStartTime=$p(InfoStr,"^",8) ;开始时间
	.s tmpEndTime=$p(InfoStr,"^",9) ;截止时间
	.q:tmpStartDate>NowDate
	.q:tmpEndDate<NowDate
	.q:(NowDate=tmpStartDate)&&(NowTime<tmpStartTime)
	.q:(NowDate=tmpEndDate)&&(NowTime>tmpEndTime)
	.s AllowUseFlag=$p(InfoStr,"^",10) ;是否启用标志
	.q:AllowUseFlag'="Y"
	.s countLoc=countLoc+1
	.s chl=$o(^DHCHUPL(rowid,"HUPL",""))
	.q:chl=""
	.s tmpchl=$o(^DHCHUPL(0,"LocUser",User,rowid,""))
	.q:tmpchl=""
	.s UserActive=$p(^DHCHUPL(rowid,"HUPL",tmpchl),"^",6) 
	.q:UserActive'="Y"
	
	q:countLoc=0 RtnObj.Err(-2,"","此请求科室当前时间没有操作高值入库权限","",0).Json()
	q:UserActive'="Y" RtnObj.Err(-2,"","当前登陆人员没有操作高值入库权限","",0).Json()
	q RtnObj.Json()
}

/// Descript:   查询科室人员授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input: 科室授权记录id
/// Table:DHC_HVUsePermisson_LocUser    
/// Return:HUPLUParref^Rowid^人员id^人员姓名^创建日期^创建人id^创建人^更新日期^更新人id^更新人^是否启用标志
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HVUsePermissonLoc","QueryPerLocUser",392)
Query QueryPerLocUser(Parref As %String) As websys.Query(ROWSPEC = "HUPLUParref,HUPLURowid,UserId,Code,User,CreateDate,CreateUserDr,CreateUser,UpdateDate,UpdateUserDr,UpdateUser,ActiveFlag") [ SqlProc ]
{
}

ClassMethod QueryPerLocUserExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT HUPLU_Hupl_Parref AS HUPLUParref,HUPLU_ChildSub ChildSub, HUPLU_CreateDate, HUPLU_CreateUser_Dr AS CreateUserDr,"_
		"HUPLU_UpdateDate, HUPLU_UpdateUser_Dr AS UpdateUserDr,HUPLU_SSuser_Dr As SSuserDr,HUPLU_Active AS Active FROM DHC_HVUsePermisson_LocUser where HUPLU_Hupl_Parref ="_Parref
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s HUPLUParref=Result.Data("HUPLUParref")
		q:HUPLUParref=""
		s ChildSub=Result.Data("ChildSub")
		q:ChildSub=""
		s HUPLURowid=HUPLUParref_"||"_ChildSub
		s CreateDate=Result.Data("HUPLU_CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate) //创建日期
		s UserId=Result.Data("SSuserDr")
		s (CreateUser,UpdateUser,Name)=""
		s:UserId'="" User=$p($g(^SSU("SSUSR",UserId)),"^",2) //授权人员
		s:UserId'="" Code=$p($g(^SSU("SSUSR",UserId)),"^",1)
		s CreateUserDr=Result.Data("CreateUserDr") //创建人
		s:CreateUserDr'="" CreateUser=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
		s UpdateDate=Result.Data("HUPLU_UpdateDate") //更新日期
		s:UpdateDate'="" UpdateDate=..DL2H(UpdateDate)
		s UpdateUserDr=Result.Data("UpdateUserDr")  //更新人
		s:UpdateUserDr'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
		s ActiveFlag=Result.Data("Active")  //是否使用标志
		d OutPutUserRow
 	}
 Quit $$$OK
OutPutUserRow
 s Data=$lb(HUPLUParref,HUPLURowid,UserId,Code,User,CreateDate,CreateUserDr,CreateUser,UpdateDate,UpdateUserDr,UpdateUser,ActiveFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:   保存更新科室人员授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input: Rowid^用户id^是否启用标志^用户描述,授权科室记录id,医院id^安全组id^科室id^用户id
/// Table: DHC_HVUsePermisson_LocUser     
/// Return:0 保存成功;-1更新失败,-2插入失败,-3存在重复记录,其余失败;
/// w ##class(web.DHCSTMHUI.HVUsePermissonLoc).SavePerLocUser("[{""User"":""宋丽娟"",""UserId"":""5122"",""Active   Flag"":""N""}]","20","6444")
ClassMethod SavePerLocUser(Params As %String, PermLocId As %String, DOuser As %String) As %Library.String
{
	n (Params,PermLocId,DOuser,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s ret=0
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s HUPLURowid=Obj.%Get("HUPLURowid")
		s UserId=Obj.%Get("UserId")
		s Active=Obj.%Get("ActiveFlag")
		s UserName=Obj.%Get("User")
		s tmpName=$p(^SSU("SSUSR",UserId),"^",2)
		i tmpName'=UserName d
		.s Chl=$o(^DHCHUPL(0,"LocUser",UserId,PermLocId,""))
		.i +Chl>0 s Sc=RtnObj.Err(-3,"","信息更新失败","",0)
		i HUPLURowid'="" d
		.s RtnObj=..UserUpdate(HUPLURowid,PermLocId,UserId,Active,DOuser)
		.i ret'=0 s Sc=RtnObj.Err(-1,"",tmpName_"信息更新失败","",0)
		e  d
		.s RtnObj=..UserInsert(PermLocId,UserId,Active,DOuser)
		.i ret="" s Sc=RtnObj.Err(-2,"",tmpName_"信息插入失败","",0)
		i RtnObj.success'=0 tro
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加科室人员授权
/// CreateDate: 20170702
/// Creater: lihui
/// Table: DHC_HVUsePermisson_LocUser 
/// Input: 授权科室记录id,人员id,激活标志,医院id^安全组id^科室id^用户id
/// Output:		
/// Return：rowid 插入成功;空 插入失败;
ClassMethod UserInsert(PermLocId As %String, UserId As %String, Active As %String, DOuser As %String) As %Library.String [ Private ]
{
	n (PermLocId,UserId,Active,DOuser,%session)
	s RtnObj=##class(RtnObj).%New()
	s DOdate=..DL2H(+$h)
	&sql(SELECT HUPLU_Rowid FROM DHC_HVUsePermisson_LocUser WHERE HUPLU_Hupl_Parref=:PermLocId AND HUPLU_SSuser_Dr=:UserId)
	i SQLCODE=0  d
	.s Name=$p(^SSU("SSUSR",UserId),"^",2)
	.s Sc=RtnObj.Err(-5,"",Name_"已存在,信息插入失败","",0)
	s ChildSub=1+$o(^DHCHUPL(PermLocId,"HUPL",""),-1)
	&sql(INSERT INTO DHC_HVUsePermisson_LocUser (HUPLU_Hupl_Parref,HUPLU_ChildSub,HUPLU_SSuser_Dr, HUPLU_CreateDate, HUPLU_CreateUser_Dr, HUPLU_Active) 
		VALUES(:PermLocId,:ChildSub,:UserId,:DOdate,:DOuser,:Active))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_LocUser","User.DHCHVUsePermissonLocUser","高值紧急业务人员授权维护",$SYSTEM.SQL.GetROWID(),UserId,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新科室人员授权
/// CreateDate: 20170702
/// Creater: lihui
/// Table: DHC_HVUsePermisson_LocUser 
/// Input: 人员记录id,授权科室记录id,人员id,激活标志,医院id^安全组id^科室id^用户id
/// Output:		
/// Return：0 更新成功;非0 更新失败;  
ClassMethod UserUpdate(Rowid As %String, PermLocId As %String, UserId As %String, Active As %String, DOuser As %String) As %Library.String [ Private ]
{
	n (Rowid,PermLocId,UserId,Active,DOuser,%session)
	s RtnObj=##class(RtnObj).%New()
	s DOdate=..DL2H(+$h)
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVUsePermisson_LocUser",Rowid)
	&sql(UPDATE DHC_HVUsePermisson_LocUser SET HUPLU_SSuser_Dr=:UserId, HUPLU_UpdateDate=:DOdate, HUPLU_UpdateUser_Dr=:DOuser, HUPLU_Active=:Active WHERE HUPLU_Rowid=:Rowid)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_LocUser","User.DHCHVUsePermissonLocUser","高值紧急业务人员授权维护",Rowid,UserName,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:   删除科室人员授权信息
/// CreateDate: 20170702
/// Creater: lihui
/// Input: Rowid
/// Table: DHC_HVUsePermisson_LocUser     
/// Return:0 删除成功;其余失败;
ClassMethod DeletePerLocUser(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
 	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s HUPLURowid=Obj.%Get("HUPLURowid")
		q:HUPLURowid=""
		s UserId=Obj.%Get("UserId")
		s UserName=$p(^SSU("SSUSR",UserId),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVUsePermisson_LocUser",HUPLURowid)
 		&sql(DELETE from DHC_HVUsePermisson_LocUser where HUPLU_Rowid=:HUPLURowid)
 		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_HVUsePermisson_LocUser","User.DHCHVUsePermissonLocUser","高值紧急业务人员授权维护",HUPLURowid,UserName,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
