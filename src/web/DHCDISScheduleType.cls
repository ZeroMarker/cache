Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-04-10
/// Descript:    配送排班维护类
Class web.DHCDISScheduleType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班保存
/// Table：        DHC_DisScheduleType
/// input:		   待保存数据串，分割符："^".多个串，以&&分割
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).SaveSchType("1^正常班^正常班^10/04/2018^08:00^10/04/2018^61200")
ClassMethod SaveSchType(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.s Err=..CheckRepeat(tmpstr) 
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdSchType(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsSchType(tmpstr)   		 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班保存
/// Table：        DHC_DisScheduleType
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).InsSchType()
ClassMethod InsSchType(ListData As %String) As %String
{
	n (ListData)
	s SchtId=$p(ListData,"^",1)				/// 排班表Id
	s SchtCode=$p(ListData,"^",2)   		/// 排班代码
	s SchtDesc=$p(ListData,"^",3)			/// 排班描述
	s SchtSTDate=$p(ListData,"^",4)			/// 开始日期
	i SchtSTDate'=""  s SchtSTDate=$zdh(SchtSTDate,4)
	s SchtSTTime=$p(ListData,"^",5)			/// 开始时间
	s SchtEndDate=$p(ListData,"^",6)		/// 结束日期
	i SchtEndDate'="" s SchtEndDate=$zdh(SchtEndDate,4)
	s SchtEndTime=$p(ListData,"^",7) 		/// 结束时间
	s SchtLastRowId=$p(ListData,"^",8) 		/// 上级ID
	&sql(insert into DHC_DisScheduleType (SCHT_Code,SCHT_Desc,SCHT_StartDate,SCHT_StartTime,SCHT_EndDate,SCHT_EndTime,SCHT_LastRowID) 
	 	values (:SchtCode,:SchtDesc,:SchtSTDate,:SchtSTTime,:SchtEndDate,:SchtEndTime,:SchtLastRowId) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班更新
/// Table：        DHC_DisScheduleType
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).UpdSchType()
ClassMethod UpdSchType(ListData As %String) As %String
{
	n (ListData)
	s SchtId=$p(ListData,"^",1)				/// 排班表Id
	s SchtCode=$p(ListData,"^",2)   		/// 排班代码
	s SchtDesc=$p(ListData,"^",3)			/// 排班描述
	s SchtSTDate=$p(ListData,"^",4)			/// 开始日期
	i SchtSTDate'=""  s SchtSTDate=$zdh(SchtSTDate,4)
	s SchtSTTime=$p(ListData,"^",5)			/// 开始时间
	s SchtEndDate=$p(ListData,"^",6)		/// 结束日期
	i SchtEndDate'="" s SchtEndDate=$zdh(SchtEndDate,4)
	s SchtEndTime=$p(ListData,"^",7) 		/// 结束时间
	s SchtLastRowId=$p(ListData,"^",8) 		/// 上级ID
	&sql(update DHC_DisScheduleType set SCHT_Code=:SchtCode,SCHT_Desc=:SchtDesc, SCHT_StartDate=:SchtSTDate,SCHT_StartTime=:SchtSTTime,SCHT_EndDate=:SchtEndDate,SCHT_EndTime=:SchtEndTime ,SCHT_LastRowID=:SchtLastRowId where SCHT_RowID=:SchtId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  删除
/// Table：        DHC_DisScheduleType
/// input:		   NodeRowId
/// Others：       w ##class(web.DHCDISScheduleType).DelSchType()
ClassMethod DelSchType(SchtId As %String) As %String
{
	n (SchtId)
	&sql(delete from DHC_DisScheduleType where SCHT_RowID=:SchtId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班查询
/// Table：        DHC_DisScheduleType
/// Others：       w ##class(web.DHCDISScheduleType).QuerySchType(10,1,"")
ClassMethod QuerySchType(rows As %String, page As %String, params As %String, LastRowId As %String) As %String
{
	n (rows,page,params,LastRowId)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s Code=$p(params,"^",1)
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s SchtId=0
	f  s SchtId=$o(^DHCDISSCHT(0,"Parref",LastRowId,SchtId)) q:SchtId=""  d  /// 查询表DHC_DisScheduleType
	.s SchtCode=$p(^DHCDISSCHT(SchtId),"^",1)			/// 排班代码
	.s SchtDesc=$p(^DHCDISSCHT(SchtId),"^",2)			/// 排班描述
	.s StartDate=$p(^DHCDISSCHT(SchtId),"^",5)			/// 开始日期
	.i StartDate'="" s StartDate=$zd(StartDate,3)
	.s StartTime=$p(^DHCDISSCHT(SchtId),"^",6)			/// 开始时间
	.s EndDate=$p(^DHCDISSCHT(SchtId),"^",3)			/// 结束日期
	.i EndDate'="" s EndDate=$zd(EndDate,3)
	.s EndTime=$p(^DHCDISSCHT(SchtId),"^",4)			/// 结束时间
	.s LastRowID=$p(^DHCDISSCHT(SchtId),"^",7)			/// 上级ID
	.q:(Code'="")&(SchtCode'[Code)
	.q:(Desc'="")&(SchtDesc'[Desc)
	.s h=h+1
	.s tempstr=SchtId_"^"_SchtCode_"^"_SchtDesc_"^"_StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_LastRowID
	.s ^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchType",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="SchtId^SchtCode^SchtDesc^StartDate^StartTime^EndDate^EndTime^LastRowID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchType",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchType",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  重复性判断
/// Table：        DHC_DisScheduleType
ClassMethod CheckRepeat(ListData As %String) As %String
{
	N (ListData)
	s ret=0
	s ID=$p(ListData,"^",1)   		///ID
	s Code=$p(ListData,"^",2)   	///代码
	s Desc=$p(ListData,"^",3)   	///描述
	
	if ID=""  d
	.i $d(^DHCDISSCHT(0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	..s ret=-1
	.i $d(^DHCDISSCHT(0,"Name",$$ALPHAUP^SSUTIL4(Desc)))  d
	..s ret=-2
	/// 修改记录
	else  d
	.s SheCode=$p($g(^DHCDISSCHT(ID)),"^",1)    //代码
	.s SheDesc=$p($g(^DHCDISSCHT(ID)),"^",2)    //描述
	.i (Code'=SheCode)&($d(^DHCDISSCHT(0,"Code",$$ALPHAUP^SSUTIL4(Code))))  d
	..s ret=-3
	.i (Desc'=SheDesc)&&($d(^DHCDISSCHT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))  d
	..s ret=-4
	q ret
}

/// ===================================================保存排班明细======================================================
/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班明细保存
/// Table：        DHC_DisSchedule
/// input:		   待保存数据串，分割符："^".多个串，以&&分割
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).SaveSchItm("^2^15^4^5906")
ClassMethod SaveSchItm(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdSchItm(tmpstr)		 	/// 更新数据
	.e  d
	..s Err=..InsSchItm(tmpstr)   		 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班明细保存
/// Table：        DHC_DisSchedule
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).InsSchItm("^2^15^4^5906")
ClassMethod InsSchItm(ListData As %String) As %String
{
	n (ListData)
	s SchtItmId=$p(ListData,"^",1)				/// 排班明细表Id
	s SchtId=$p(ListData,"^",2)   				/// 排班表Id
	s TypeId=$p(ListData,"^",3)					/// 配送类型Id
	s NodeId=$p(ListData,"^",4)					/// 配送岗位Id
	s UserId=$p(ListData,"^",5)					/// 配送护工Id
	&sql(insert into DHC_DisSchedule (SCH_DisSch_Dr,SCH_DisType_Dr,SCH_Node_Dr,SCH_SSUser_Dr) 
	 	values (:SchtId,:TypeId,:NodeId,:UserId) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班更新
/// Table：        DHC_DisSchedule
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISScheduleType).UpdSchItm()
ClassMethod UpdSchItm(ListData As %String) As %String
{
	n (ListData)
	s SchtItmId=$p(ListData,"^",1)				/// 排班明细表Id
	s SchtId=$p(ListData,"^",2)   				/// 排班表Id
	s TypeId=$p(ListData,"^",3)					/// 配送类型Id
	s NodeId=$p(ListData,"^",4)					/// 配送岗位Id
	s UserId=$p(ListData,"^",5)					/// 配送护工Id
	&sql(update DHC_DisSchedule set SCH_DisSch_Dr=:SchtId,SCH_DisType_Dr=:TypeId, SCH_Node_Dr=:NodeId,SCH_SSUser_Dr=:UserId where SCH_RowID=:SchtItmId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  删除
/// Table：        DHC_DisSchedule
/// input:		   NodeRowId
/// Others：       w ##class(web.DHCDISScheduleType).DelSchItm()
ClassMethod DelSchItm(SchtItmId As %String) As %String
{
	n (SchtItmId)
	&sql(delete from DHC_DisSchedule where SCH_RowID=:SchtItmId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送排班明细查询
/// Table：        DHC_DisSchedule
/// Input：		   排班表Id
/// Others：       w ##class(web.DHCDISScheduleType).QuerySchItm(10,1)
ClassMethod QuerySchItm(rows As %String, page As %String) As %String
{
	n (rows,page)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s SchtItmId=0
	f  s SchtItmId=$o(^DHCDISSCH(SchtItmId)) q:SchtItmId=""  d  /// 查询表DHC_DisSchedule
	.s SchDr=$p(^DHCDISSCH(SchtItmId),"^",1)				/// 排班类型Id
	.s SchDesc=""
	.i SchDr'="" s SchDesc=$p(^DHCDISSCHT(SchDr),"^",2)		/// 排班类型描述
	.s TypeDr=$p(^DHCDISSCH(SchtItmId),"^",2)				/// 配送类型Id
	.s TypeDesc=""
	.i TypeDr'="" s TypeDesc=$p(^DHCDISTA(TypeDr),"^",2)	/// 配送类型描述
	.s NodeDr=$p(^DHCDISSCH(SchtItmId),"^",3)				/// 岗位Id
	.s NodeDesc=""
	.i NodeDr'="" s NodeDesc=$p(^DHCDISWN(NodeDr),"^",2)	/// 岗位描述
	.s UserDr=$p(^DHCDISSCH(SchtItmId),"^",4)				/// 护工Id
	.s UserDesc=""
	.i UserDr'="" s UserDesc=$p(^SSU("SSUSR",UserDr),"^",2) /// 护工名称、
	.s h=h+1
	.s tempstr=SchtItmId_"^"_TypeDr_"^"_TypeDesc_"^"_NodeDr_"^"_NodeDesc_"^"_UserDr_"^"_UserDesc_"^"_SchDr_"^"_SchDesc
	.s ^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchItm",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="SchtItmId^TypeDr^TypeDesc^NodeDr^NodeDesc^UserDr^UserDesc^SchDr^SchDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchItm",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchItm",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  获取岗位
/// Table：        DHC_DisWorkNode
/// w ##class(web.DHCDISScheduleType).QueryNode()
ClassMethod QueryNode()
{
	s Count=0
	w "["
	s NodeID=0
	f  s NodeID=$o(^DHCDISWN(NodeID)) q:NodeID=""  d
	.s NodeDesc=$p(^DHCDISWN(NodeID),"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",NodeID_"^"_NodeDesc)
	w "]"
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  获取配送人员
ClassMethod GetDisUser(q = "")
{
	n (q)
	s CodeFlag=$$ALPHAUP^SSUTIL4(q)
	s Count=0,Num=0
	s Hosp="",locid=""
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s userId=0
	f  s userId = $o(^SSU("SSUSR",userId)) q:userId=""  d
	.i $d(^DHCDISLU("0","User",userId)) d    ///此处对姓名按照姓氏排序
	.s UserName = $p(^SSU("SSUSR",userId),"^",2)
	.s QuitCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"")
	.q:(CodeFlag'="")&&(QuitCode'[CodeFlag)
	.s NameCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"^")
	.s FirCode=$p(NameCode,"^",1)
	.s CodeAII=$ASCII(FirCode)
	.s Num=Num+1
	.s ^TMP("DHCDIS","web.DHCDISScheduleType","GetDisUser",pid,CodeAII,Num)=userId_"^"_UserName
	
	w "["
	s CodeNum=0
	f  s CodeNum=$o(^TMP("DHCDIS","web.DHCDISScheduleType","GetDisUser",pid,CodeNum)) q:CodeNum=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCDIS","web.DHCDISScheduleType","GetDisUser",pid,CodeNum,index))  q:index=""  d
	..s mdata=^(index)
	..s EsUserId=$p(mdata,"^",1)
	..s EsUserName=$p(mdata,"^",2)
	..q:'$d(^DHCDISLU("0","User",EsUserId))
	..s LuRowID=$o(^DHCDISLU("0","User",EsUserId,""))		//科室人员表
	..s Workload=$p(^DHCDISLU(LuRowID),"^",5)				//工作量
	..i Workload=0 s Workload=""
	..s FromDate=$p(^SSU("SSUSR",EsUserId),"^",96)
	..s EndDate=$p(^SSU("SSUSR",EsUserId),"^",97)
	..q:(FromDate>+$h)&(FromDate'="")
	..q:(EndDate<+$h)&(EndDate'="")
	..s Hosp=$p(^SSU("SSUSR",EsUserId),"^",90)
	..s locid=$p(^SSU("SSUSR",EsUserId),"^",4)
	..q:locid=""
	..;q:((LocId'=locid)&(LocId'=""))			//sufan 注释，人员取默认登录科室为后勤管理科的人员
	..s LocDesc=$p(^CTLOC(locid),"^",2)			//取科室描述
	..;q:(LocDesc'="")&(LocDesc'="后勤管理配送组")
	..s Count=Count+1
	..s tmp = EsUserId_"^"_EsUserName
	..i Count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	d ..killTmpGlobal(pid)    //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  获取排班类型
/// w ##class(web.DHCDISScheduleType).GetSchedule()
ClassMethod GetSchedule()
{
	s Count=0
	w "["
	s ScheID=0
	f  s ScheID=$o(^DHCDISSCHT(ScheID)) q:ScheID=""  d
	.s ScheDesc=$p(^DHCDISSCHT(ScheID),"^",2)
	.s LastRowId=$p(^DHCDISSCHT(ScheID),"^",7)
	.q:LastRowId=0
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ScheID_"^"_ScheDesc)
	w "]"
	q ""
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchType",pid)
	k ^TMP("DHCDIS","web.DHCDISScheduleType","QuerySchItm",pid)
	k ^TMP("DHCDIS","web.DHCDISScheduleType","GetDisUser",pid)
}

}
