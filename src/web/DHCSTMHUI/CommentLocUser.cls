Import sqluser

/// Descript:   高值点评可点评科室或者点评人员授权维护
/// Creater: wxj
/// CreateDate: 2019-10-17
Class web.DHCSTMHUI.CommentLocUser Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   查询科室授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input:
/// Table:DHC_MatCNT_Loc     
/// Return:Rowid^被点评科室id^被点评科室描述^点评科室id^点评科室描述^开始日期^截止日期^开始时间^截止时间^是否启用标志
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CommentLocUser","selectComLoc")
Query selectComLoc() As websys.Query(ROWSPEC = "RowId,PhaLocId,PhaLocDesc,ComLocId,ComLocDesc,StartDate,EndDate,StartTime,EndTime,Active") [ SqlProc ]
{
}

ClassMethod selectComLocExecute(ByRef qHandle As %Binary) As %Status
{
	
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID AS RowId,MATC_Loc AS PhaLocId, MATC_ComLoc AS ComLocId,MATC_ComStatDate, MATC_ComEndDate,"_
      "MATC_ComStatTime, MATC_ComEndTime, MATC_ActiveFlag AS Active FROM DHC_MatCNT_Loc"
    d Result.Prepare(SqlStr)
	d Result.Execute()	
	while(Result.Next())
    {
	    s RowId=Result.Data("RowId")
	    s PhaLocId=Result.Data("PhaLocId")  //被点评科室
	    s PhaLocDesc=""
	    s:PhaLocId'="" PhaLocDesc=$p($g(^CTLOC(PhaLocId)),"^",2)
	    s ComLocId=Result.Data("ComLocId")  //可点评科室
	    s ComLocDesc=""
	    s:ComLocId'="" ComLocDesc=$p($g(^CTLOC(ComLocId)),"^",2)
	    s StartDate=Result.Data("MATC_ComStatDate")   //开始日期
	    s:StartDate'="" StartDate=..DL2H(StartDate)
	    s EndDate=Result.Data("MATC_ComEndDate")    //结束日期
	    s:EndDate'="" EndDate=..DL2H(EndDate)
	    s StartTime=Result.Data("MATC_ComStatTime")  //开始时间
	    s:StartTime'="" StartTime=..TL2H(StartTime)
	    s EndTime=Result.Data("MATC_ComEndTime") //结束时间
	    s:EndTime'="" EndTime=..TL2H(EndTime)
	    s Active=Result.Data("Active")  //是否使用标志
	    d OutPutRow
    }
 	Quit $$$OK
OutPutRow
 s Data=$lb(RowId,PhaLocId,PhaLocDesc,ComLocId,ComLocDesc,StartDate,EndDate,StartTime,EndTime,Active)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:   保存更新科室授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: 被点评科室id^点评科室id^开始日期^开始时间^截止日期^截止时间^是否启用标志,医院id^安全组id^科室id^用户id
/// Table:DHC_MatCNT_Loc     
/// Return:0 保存成功;-1更新失败,-2插入失败,其余失败;
/// w ##class(web.DHCSTMHUI.CommentLocUser).SaveComLoc(^tempxj("01"))
ClassMethod SaveComLoc(Params As %String) As %Library.String
{
	n (Params,%session)
	s ^tempxj("01")=Params
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s PhaLoc=Obj.%Get("PhaLocId") ;被点评科室
		q:PhaLoc=""
		s ComLoc=Obj.%Get("ComLocId") ;执行科室
		q:ComLoc=""
		s StartDate=Obj.%Get("StartDate")
		s EndDate=Obj.%Get("EndDate")
		s StartTime=Obj.%Get("StartTime")
		s EndTime=Obj.%Get("EndTime")
		;s:StartTime="" StartTime="00:00:00"
		;s:EndTime="" EndTime="23:59:59"
		s:StartDate'="" StartDate=..DH2L(StartDate)
 		s:EndDate'="" EndDate=..DH2L(EndDate)
 		s:StartTime'="" StartTime=..TH2L(StartTime)
 		s:EndTime'="" EndTime=..TH2L(EndTime)
 		i (StartDate'="")&&(EndDate'="") d
 		.i (StartDate>EndDate) d
 		..d RtnObj.Err("-2","","开始日期不能晚于截止日期","",0) 
 		.e  i (StartDate=EndDate)&&(StartTime'="")&&(EndTime'="")&&(StartTime>EndTime) d
		..d RtnObj.Err("-3","","截止时间不能早于开始时间","",0)
		q:RtnObj.success'=0
 		s Active=Obj.%Get("Active") ;是否启用标志
 		i RowId'="" d
		.s RtnObj=..Update(RowId,PhaLoc,ComLoc,StartDate,StartTime,EndDate,EndTime,Active)
		e  d
		.s RtnObj=..Insert(PhaLoc,ComLoc,StartDate,StartTime,EndDate,EndTime,Active)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加科室授权记录
/// Creater:	wxj
/// CreateDate:	2019-10-17
/// Table: DHC_MatCNT_Loc
/// Input: 执行科室id,开始日期,开始时间,截止日期,截止时间,是否启用标志,医院id^安全组id^科室id^用户id
/// Return：大于0 :保存成功, 空 保存失败;
ClassMethod Insert(PhaLoc As %String, ComLoc As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String) As RtnObj [ Private ]
{
	n (PhaLoc,ComLoc,StartDate,StartTime,EndDate,EndTime,Active,%session)
	s RtnObj=##class(RtnObj).%New()
 	s RowId=""
 	&sql(SELECT ID into:RowId FROM DHC_MatCNT_Loc WHERE MATC_ComLoc=:ComLoc AND MATC_Loc=:PhaLoc)
 	i +RowId>0 d
 	.s Sc=RtnObj.Err(-3,"","存在重复记录","",0)
 	q:RtnObj.success'=0 RtnObj
	&sql(INSERT INTO DHC_MatCNT_Loc (MATC_Loc,MATC_ComLoc,MATC_ComStatDate,MATC_ComEndDate,MATC_ComStatTime,MATC_ComEndTime,MATC_ActiveFlag) 
	    VALUES(:PhaLoc,:ComLoc,:StartDate,:EndDate,:StartTime,:EndTime,:Active))
	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Loc","User.DHCMatCNTLoc","高值点评科室授权维护",$SYSTEM.SQL.GetROWID(),PhaLoc,"A")
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	更新科室授权记录
/// Creater:	wxj
/// CreateDate:	2019-10-17
/// Table: DHC_MatCNT_Loc
/// Input: Rowid,执行科室id,开始日期,开始时间,截止日期,截止时间,是否启用标志,医院id^安全组id^科室id^用户id
/// Return 0 更新成功; -1 更新失败;
ClassMethod Update(Rowid As %String, PhaLoc As %String, ComLoc As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String) As RtnObj [ Private ]
{
	n (Rowid,PhaLoc,ComLoc,StartDate,StartTime,EndDate,EndTime,Active,%session)
	s RtnObj=##class(RtnObj).%New()
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_Loc",Rowid)
	&sql(UPDATE DHC_MatCNT_Loc SET MATC_Loc=:PhaLoc,MATC_ComLoc=:ComLoc,MATC_ComStatDate=:StartDate,MATC_ComEndDate=:EndDate,MATC_ComStatTime=:StartTime,MATC_ComEndTime=:EndTime,MATC_ActiveFlag=:Active WHERE %ID=:Rowid)
 	i SQLCODE'=0  d
 	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Loc","User.DHCMatCNTLoc","高值点评科室授权维护",Rowid,ComLoc,"U","",OldJsonStr)
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:   删除科室授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: Rowid
/// Table:DHC_MatCNT_Loc     
/// Return:0 删除成功;其余失败;
/// w ##class(web.DHCSTMHUI.CommentLocUser).DeletePerMLoc("[{""RowId"":""15"",""OperLoc"":""5"",""OperLocDesc"":""风湿  免疫科门诊"",""CreateDate"":""19/11/2018"",""CreateUserDr"":""6444"",""CreateUse     r"":""wxj"",""UpdateDate"":""20/11/2018"",""UpdateUserDr"":""6444"",""UpdateUser"":""wxj"",""StartDate"":""22/11/2018"",""EndDate"":""07/12/2018"",""StartTime"":""00:00:00"",""EndTime"":""23:59:59"",""Active"":""N""}]")
ClassMethod DeleteComLoc(Params As %String) As %Library.String
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
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s PhaLocId=Obj.%Get("PhaLocId")
		s ComLocId=Obj.%Get("ComLocId")
		s PhaLoc=$p($g(^CTLOC(PhaLocId)),"^",2)
		s ComLoc=$p($g(^CTLOC(ComLocId)),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_Loc",RowId)
	 	&sql(DELETE from DHC_MatCNT_Loc WHERE %ID=:RowId)
	 	i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Loc","User.DHCMatCNTLoc","高值点评科室授权维护",RowId,ComLoc,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:   查询科室人员授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: 科室授权记录id
/// Table:DHC_MatCNT_LocUser    
/// Return:CNTLUParref^Rowid^人员id^人员姓名^创建日期^创建人id^创建人^更新日期^更新人id^更新人^是否启用标志
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CommentLocUser","QueryPerLocUser",392)
Query QueryComLocUser(ParRef As %String) As websys.Query(ROWSPEC = "CNTLUParref,CNTLURowid,ComUserId,ComUserCode,ComUser,StartDate,EndDate,StartTime,EndTime,ActiveFlag") [ SqlProc ]
{
}

ClassMethod QueryComLocUserExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	n (qHandle,ParRef)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT MatCNTLU_ParRef AS CNTLUParRef,MatCNTLU_ChildSub ChildSub,MatCNTLU_ComUser As ComUserId,"_
      "MatCNTLU_ActiveFlag AS Active,MatCNTLU_StatDate,MatCNTLU_EndDate,MatCNTLU_StatTime,MatCNTLU_EndTime "_
      "FROM DHC_MatCNT_LocUser where MatCNTLU_ParRef ="_ParRef
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s CNTLUParRef=Result.Data("CNTLUParRef")
	    q:CNTLUParRef=""
	    s ChildSub=Result.Data("ChildSub")
	    q:ChildSub=""
	    s CNTLURowid=CNTLUParRef_"||"_ChildSub
	    s ComUserId=Result.Data("ComUserId")
	    s (ComUser,ComUserCode)=""
	    s:ComUserId'="" ComUser=$p($g(^SSU("SSUSR",ComUserId)),"^",2) //授权人员
	    s:ComUserId'="" ComUserCode=$p($g(^SSU("SSUSR",ComUserId)),"^",1)
	    s StartDate=Result.Data("MatCNTLU_StatDate")   //开始日期
	    s:StartDate'="" StartDate=..DL2H(StartDate)
	    s EndDate=Result.Data("MatCNTLU_EndDate")    //结束日期
	    s:EndDate'="" EndDate=..DL2H(EndDate)
	    s StartTime=Result.Data("MatCNTLU_StatTime")  //开始时间
	    s:StartTime'="" StartTime=..TL2H(StartTime)
	    s EndTime=Result.Data("MatCNTLU_EndTime") //结束时间
	    s:EndTime'="" EndTime=..TL2H(EndTime)
	    s ActiveFlag=Result.Data("Active")  //是否使用标志
	    d OutPutUserRow
 	}
 Quit $$$OK
OutPutUserRow
 s Data=$lb(CNTLUParRef,CNTLURowid,ComUserId,ComUserCode,ComUser,StartDate,EndDate,StartTime,EndTime,ActiveFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:   保存更新科室人员授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: Rowid^用户id^是否启用标志^用户描述,授权科室记录id,医院id^安全组id^科室id^用户id
/// Table: DHC_MatCNT_LocUser     
/// Return:0 保存成功;-1更新失败,-2插入失败,-3存在重复记录,其余失败;
/// w ##class(web.DHCSTMHUI.CommentLocUser).SaveComUser(^tempxj("01"))
ClassMethod SaveComUser(Params As %String, ParRef As %String) As %Library.String
{
	n (Params,ParRef,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s CNTLURowid=Obj.%Get("CNTLURowid")
		s ComUserId=Obj.%Get("ComUserId")
		d:ComUserId="" RtnObj.Err("-4","","请选择正确的人员名称","",0)
		q:RtnObj.success'=0
		s StartDate=Obj.%Get("StartDate")
		s EndDate=Obj.%Get("EndDate")
		s StartTime=Obj.%Get("StartTime")
		s EndTime=Obj.%Get("EndTime")
 		q:(StartDate'="")&&(EndDate'="")&&(StartDate>EndDate) ;开始日期不能晚于截止日期
		q:(StartTime'="")&&(EndTime'="")&&(StartTime>EndTime)  ;截止时间不能早于开始时间
		s:StartDate'="" StartDate=..DH2L(StartDate)
 		s:EndDate'="" EndDate=..DH2L(EndDate)
 		s:StartTime'="" StartTime=..TH2L(StartTime)
 		s:EndTime'="" EndTime=..TH2L(EndTime)
 		i (StartDate'="")&&(EndDate'="") d
 		.i (StartDate>EndDate) d
 		..d RtnObj.Err("-2","","开始日期不能晚于截止日期","",0) 
 		.e  i (StartDate=EndDate)&&(StartTime'="")&&(EndTime'="")&&(StartTime>EndTime) d
		..d RtnObj.Err("-3","","截止时间不能早于开始时间","",0)
		q:RtnObj.success'=0
		s Active=Obj.%Get("ActiveFlag")
		i CNTLURowid'="" d
		.s RtnObj=..UserUpdate(CNTLURowid,ParRef,ComUserId,StartDate,StartTime,EndDate,EndTime,Active)
		.i ret'=0 s Sc=RtnObj.Err(-1,"",tmpName_"信息更新失败")
		e  d
		.s RtnObj=..UserInsert(ParRef,ComUserId,StartDate,StartTime,EndDate,EndTime,Active)
		.i ret="" s Sc=RtnObj.Err(-2,"",tmpName_"信息插入失败")
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
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Table: DHC_MatCNT_LocUser 
/// Input: 授权科室记录id,人员id,激活标志,医院id^安全组id^科室id^用户id
/// Output:		
/// Return：rowid 插入成功;空 插入失败;
ClassMethod UserInsert(ParRef As %String, ComUserId As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String) As %Library.String [ Private ]
{
	n (ParRef,ComUserId,StartDate,StartTime,EndDate,EndTime,Active,%session)
	s RtnObj=##class(RtnObj).%New()
	s RowId=""
	&sql(SELECT ID into:RowId FROM DHC_MatCNT_LocUser WHERE MatCNTLU_ParRef=:ParRef AND MatCNTLU_ComUser=:ComUserId)
	i +RowId>0 d
	.s Sc=RtnObj.Err(-3,"","存在重复记录","",0)
	q:RtnObj.success'=0 RtnObj
	i SQLCODE=0  d
	.s Name=$p(^SSU("SSUSR",ComUserId),"^",2)
	.s Sc=RtnObj.Err(-5,"",Name_"已存在,信息插入失败")
	&sql(INSERT INTO DHC_MatCNT_LocUser (MatCNTLU_Parref,MatCNTLU_ComUser,MatCNTLU_StatDate,MatCNTLU_StatTime,MatCNTLU_EndDate,MatCNTLU_EndTime, MatCNTLU_ActiveFlag) 
		VALUES(:ParRef,:ComUserId,:StartDate,:StartTime,:EndDate,:EndTime,:Active))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_LocUser","User.DHCMatCNTLocUser","高值点评人员授权维护",$SYSTEM.SQL.GetROWID(),ComUserId,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新科室人员授权
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Table: DHC_MatCNT_LocUser 
/// Input: 人员记录id,授权科室记录id,人员id,激活标志,医院id^安全组id^科室id^用户id
/// Output:		
/// Return：0 更新成功;非0 更新失败;  
ClassMethod UserUpdate(Rowid As %String, ParRef As %String, ComUserId As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, Active As %String) As %Library.String [ Private ]
{
	n (Rowid,Parref,ComUserId,StartDate,StartTime,EndDate,EndTime,Active,%session)
	s RtnObj=##class(RtnObj).%New()
	s DOdate=..DL2H(+$h)
	s UserName=$p(^SSU("SSUSR",ComUserId),"^",2)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_LocUser",Rowid)
	&sql(UPDATE DHC_MatCNT_LocUser SET MatCNTLU_ComUser=:ComUserId, MatCNTLU_ActiveFlag=:Active ,MatCNTLU_StatDate=:StartDate,MatCNTLU_StatTime=:StartTime,MatCNTLU_EndDate=:EndDate,MatCNTLU_EndTime=:EndTime WHERE %ID=:Rowid)
 	i SQLCODE'=0  d
 	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_LocUser","User.DHCMatCNTLocUser","高值点评人员授权维护",Rowid,"U","",OldJsonStr)
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:   删除科室人员授权信息
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: Rowid
/// Table: DHC_MatCNT_LocUser     
/// Return:0 删除成功;其余失败;
ClassMethod DeleteComUser(Params As %String) As %Library.String
{
	n (Params,%session)
 	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s CNTLURowid=Obj.%Get("CNTLURowid")
		q:CNTLURowid=""
		s ComUserId=Obj.%Get("ComUserId")
		s UserName=$p(^SSU("SSUSR",ComUserId),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_LocUser",CNTLURowid)
		&sql(DELETE from DHC_MatCNT_LocUser where ID=:CNTLURowid)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_LocUser","User.DHCMatCNTLocUser","高值点评人员授权维护",CNTLURowid,UserName,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript: 判断科室人员是否有权点评
/// CreateDate: 2019-10-17
/// Creater: wxj
/// Input: 医嘱科室id,点评科室id,点评人员id
/// Table: DHC_MatCNT_Loc 
/// Return: -1 科室无授权记录或授权未激活 -2 人员无授权记录或授权未激活 -3 科室授权记录已过期 -4 人员授权记录已过期
/// w ##class(web.DHCSTMHUI.CommentLocUser).IfAllowDo(95,326,6423)
ClassMethod IfAllowDo(OriLoc As %String, ComLoc As %String, User As %String) As %Library.String
{
	n (OriLoc,ComLoc,User)
	q:OriLoc="" 0
	q:ComLoc="" 0
	s ret=0
	s NowDate=+$h
	s NowTime=$p($h,",",2)
	s rowid="",ch=""
	s rowid=$o(^User.DHCMatCNTLocI("DHCSTMCLIndex",OriLoc,ComLoc,""))
	q:rowid="" 0 ;科室不存在授权记录
	s:User'="" ch=$o(^User.DHCMatCNTLocUserI("DHCSTMCLUIndex",rowid,User,""))
	q:(User'="")&&(ch="") 0  ;人员不存在授权记录
	s LocUseFlag=$LG(^User.DHCMatCNTLocD(rowid),8) ;是否启用标志
	q:LocUseFlag'="Y" -1 ; 科室授权记录未激活
	s LocStatDate=$LG(^User.DHCMatCNTLocD(rowid),4) ;开始日期
	s LocEndDate=$LG(^User.DHCMatCNTLocD(rowid),6) ;截止日期
	s LocStartTime=$LG(^User.DHCMatCNTLocD(rowid),5) ;开始时间
	s LocEndTime=$LG(^User.DHCMatCNTLocD(rowid),7) ;截止时间
	i ((LocStatDate'="")&&(NowDate<LocStatDate))||((LocEndDate'="")&&(NowDate>LocEndDate))||((LocStartTime'="")&&(NowTime<LocStartTime))||((LocEndTime'="")&&(NowTime>LocEndTime)) d
	.s ret=-3
	q:ret<0 ret
	i +ch>0  d
	.s UserUseFlag=$LG(^User.DHCMatCNTLocD(rowid,"ChildDHCMatCNTLocUser",ch),7)
	.s:UserUseFlag'="Y" ret=-2 ; 人员授权记录未激活
	.q:ret<0
	.s UserStatDate=$LG(^User.DHCMatCNTLocD(rowid,"ChildDHCMatCNTLocUser",ch),3) ;开始日期
	.s UserEndDate=$LG(^User.DHCMatCNTLocD(rowid,"ChildDHCMatCNTLocUser",ch),5) ;截止日期
	.s UserStartTime=$LG(^User.DHCMatCNTLocD(rowid,"ChildDHCMatCNTLocUser",ch),4) ;开始时间
	.s UserEndTime=$LG(^User.DHCMatCNTLocD(rowid,"ChildDHCMatCNTLocUser",ch),6) ;截止时间
	.i ((UserStatDate'="")&&(NowDate<UserStatDate))||((UserEndDate'="")&&(NowDate>UserEndDate))||((UserStartTime'="")&&(NowTime<UserStartTime))||((UserEndTime'="")&&(NowTime>UserEndTime)) d
	..s ret=-4
	q ret
}

}
