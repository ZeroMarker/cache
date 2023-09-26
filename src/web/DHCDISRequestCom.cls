Import SQLUser

/// Creator:    zhouxin
/// CreateDate: 2016-02-20
/// Descript:   配送申请，配送申请 公共接收 拒绝方法
Class web.DHCDISRequestCom Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator:    zhouxin
/// CreateDate: 2016-02-20
/// Input: pointer:配送或陪送id
/// 		   type:DHCDisTypeAdd 配送类型表id
/// 		   status:DHCDisStatusAdd 状态字典表id	
/// 		   lgUser:操作用户id		
/// Descript:  
/// w ##class(web.DHCDISRequestCom).updateStatus(149,15,"完成",4839,"")
ClassMethod updateStatus(pointer, type, statuscode, lgUser, EmFlag, flag = "", reason = "", Relation = "", RelaFlag = "")
{
	
	n (pointer,type,statuscode,lgUser,reason,EmFlag,flag,Relation,RelaFlag)
	;s ^tempsufan("pointer")=$lb(pointer,type,statuscode,lgUser,reason,EmFlag,flag,Relation,RelaFlag)
	///获取状态ID
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	q:status="" "获取下个流程状态失败"
	///判断当前状态
	i statuscode=19 d						//置空的不需要判断当前状态，前台已控制
	.s ret=0 
	e  d
	.s ret=##class(web.DHCDISRequestCom).checkStatus(pointer,type,status,EmFlag,flag)
	q:ret'=0 "当前操作不允许"
	/// 保存操作流水表
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,type,status,lgUser,reason,Relation,RelaFlag)
	q:ret'=0 "保存操作流水表失败"
	/// 更新配送配送表状态
 	s ret=##class(web.DHCDISRequestCom).updateRequestStatus(pointer,type,status)
	q:ret'=0 "更新配送配送表状态失败"
	/// 更新配送陪送人员忙碌空闲状态
 	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,type,status)
	q:ret'=0 "更新人员状态失败"

	q 0
}

// w ##class(web.DHCDISRequestCom).checkStatus(246, 9, 125, "")

/// 检查当前状态
ClassMethod checkStatus(pointer, type, status, EmFlag, flag)
{
	n (pointer, type, status,reason,EmFlag,flag)
	s ^tempsufan(2)=pointer_"#"_type_"#"_status_"#"_EmFlag
	s ret=0
	s nextStatsu=##class(web.DHCDISRequestCom).getNextStatus(pointer,type,EmFlag,flag,status)   //新加当前状态  sufan 2018-03-22
	s:nextStatsu'=status ret="当前操作不允许"
	q:ret'=0 ret
	q 0
}

/// Descript:   获取配送下个状态
/// DO ##class(User.DHCDisStatusAdd).%BuildIndices()
/// w ##class(web.DHCDISRequestCom).getNextStatus(246,9,"")
ClassMethod getNextStatus(id, type, EmFlag, flag = "", status = "")
{
	n (id,type,EmFlag,status,flag)
	s currstatdr=0,currcode=""
	if (##class(web.DHCDISRequestCom).checkType(type)=1)&&(+id'=0) d
	.s currstatdr=$p(^DHCDISGRE(id),"^",10)
	e  d
	.s currstatdr=+$p(^DHCDISRE(id),"^",16)
	q:(+currstatdr'=0)&&('$d(^DHCDISSA(currstatdr))) ""
	s:+currstatdr'=0 currcode=$p(^DHCDISSA(currstatdr),"^",1)
	i EmFlag="Y"  d
	.i flag=1 d																//加急处理
	..s nextcode=""
	..s nextcode=$o(^DHCDISSA("0","TypeCode",type,"Y",currcode))				//起始状态
	..s next=$o(^DHCDISSA("0","TypeCode",type,"Y",nextcode,""))
	.e  s next=status
	e  d
	.i flag=1 d
	..s nextcode=""
	..s nextcode=$o(^DHCDISSA("0","TypeCode",type,"Y",currcode))  				//SUFAN 修改循环索引	//起始状态  
	..s next=$o(^DHCDISSA("0","TypeCode",type,"Y",nextcode,""))    				//改为待处理
	.e  s next=status
	
	q next
}

/// 检查是否为配送
/// 1 陪送
/// 0 配送
ClassMethod checkType(type)
{
	n (type)
	q:$p(^DHCDISTA(type),"^",1)="陪送" 0
	q 1
}

/// 保存操作流水表
ClassMethod saveRequestSta(pointer, type, status, lgUser, reason = "", Relation = "", RelaFlag = "")
{
	n (pointer,type,status,lgUser,reason,Relation,RelaFlag)
	s staObj=##class(User.DHCDisRequestSta).%New()
	s staObj.RSCreateDate=+$h
	s staObj.RSCreateTime=$p($h,",",2)
	s staObj.RSReqType=type
	s staObj.RSPointer=pointer
	s staObj.RSCurStatus=status
	s staObj.RSLoction=Relation
	s staObj.RSLoctionFlag=RelaFlag
	s:lgUser'=0 staObj.RSCreateUser=##class(User.SSUser).%OpenId(lgUser)
	s:+reason'=0 staObj.RSReasonDr=##class(User.DHCDisFailReason).%OpenId(reason)
	
	s sc=staObj.%Save()
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  q -1
 	}
 	q 0
}

/// 更新配送状态
ClassMethod updateRequestStatus(pointer, type, status)
{
	n (pointer,type,status)
	s obj=""
	if (##class(web.DHCDISRequestCom).checkType(type)=1) d
	.;if (type=1)  d
	.s obj=##class(User.DHCDisGoodsRequest).%OpenId(pointer)
	.s obj.REQCurStatus=status
	e  d
	.s obj=##class(User.DHCDisRequest).%OpenId(pointer)
	.s obj.REQCurStatus=##class(User.DHCDisStatusAdd).%OpenId(status)
	q:obj="" 0
	s sc=obj.%Save()
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  q -2
 	}
 	q 0
}

/// 更新配送，陪人员忙碌状态
ClassMethod updatePeopleStatusDDDDDD(pointer, type, status)
{
	n (pointer,type,status)
	s pid=##class(web.DHCDISRequestCom).getPid()
	k ^TMP("web.DHCDISRequestCom","PEOPLE",pid)
	s stdesc=$p(^DHCDISSA(status),"^",2)
	i type=1 d
	.s itm=""
	.f  s itm=$o(^DHCDISGRE(+pointer,"ITM",itm)) q:itm=""  d
	..s dispeo=$o(^DHCDISPE("0","TypePointer",type,+pointer_"||"_itm,""))
	..q:+dispeo=0
	..s user=$p(^DHCDISPE(dispeo),"^",3)
	..s ^TMP("web.DHCDISRequestCom","PEOPLE",pid,user)=""
	i type=0 d
	.s itm=""
	.f  s itm=$o(^DHCDISRE(+pointer,"Itm",itm)) q:itm=""  d
	..s dispeo=$o(^DHCDISPE("0","TypePointer",type,+pointer_"||"_itm,""))
	..q:+dispeo=0
	..s user=$p(^DHCDISPE(dispeo),"^",3)
	..s ^TMP("web.DHCDISRequestCom","PEOPLE",pid,user)=""
	
	s user="",ret=0
	f  s user=$o(^TMP("web.DHCDISRequestCom","PEOPLE",user)) q:(user="")||(ret'=0)  d
	.s locUser=$o(^DHCDISLU(0,"User",user,""))
	.q:+locUser=0
	.s locUserObj=##class(User.DHCDisLocUser).%OpenId(locUser)
	.i stdesc["验证确认" d
	..s locUserObj.LUStatus=0
	.i (stdesc["完成")&&(..checkPeopleRequest(user)=1) d
	..s locUserObj.LUStatus=1
	.s sc=locUserObj.%Save()
	.If $$$ISERR(sc) s ret=-3
	k ^TMP("web.DHCDISRequestCom","PEOPLE",pid)
	q ret
}

/// Descript:  更新护工状态
/// Creator:   zhaowuqiang
/// Creatdate: 2017-05-15
/// Table:     DHC_DisLocUser
/// Input:     申请单ID^申请单类型
/// Output:    SQLCODE
/// Other:     w ##class(web.DHCDISRequestCom).updatePeopleStatus(148,15,119)
ClassMethod updatePeopleStatus(pointer, type, status)
{
	n (pointer,type,status)
	S BusyFlag=1,FreeFlag=0,Err=0
	;S StatusDesc=$p(^DHCDISSA(status),"^",2)  //获取申请单状态代码
	S PeopleID=0
	S PeopleID=$o(^DHCDISPE(0,"TypePointer",type,pointer,PeopleID))  //获取申请单护工表ID
	q:PeopleID="" 0
	S UserDr=$p(^DHCDISPE(PeopleID),"^",3)
	S LocUserID=""
	q:'$d(^DHCDISLU(0,"User",UserDr)) 1
	S LocUserID=$o(^DHCDISLU(0,"User",UserDr,LocUserID))   //获取护工表ID
	b    //LocUserID
	s WorkLoad=$p(^DHCDISLU(LocUserID),"^",5)    //工作量
	S DisReqNum=..GetDisReqNum(UserDr,type)
	b    ///DisReqNum
	I (DisReqNum<=1)  d
	.&sql(update DHC_DisLocUser set LU_Status=:FreeFlag where LU_RowId=:LocUserID)
	.S Err=SQLCODE
	E  D
	.s WorkLoad=WorkLoad-1
	.&sql(update DHC_DisLocUser set LU_Status=:BusyFlag where LU_RowId=:LocUserID)
	.S Err=SQLCODE
	
	Q Err
}

/// Descript:  更新护工工作量
/// Creator:   sufan
/// Creatdate: 2018-11-07
/// Table:     DHC_DisLocUser
/// Input:     申请单ID^申请单类型
/// Output:    SQLCODE
/// Other:     w ##class(web.DHCDISRequestCom).updWorkLoad("60","1","12")
ClassMethod updWorkLoad(pointer, type, status)
{
	n (pointer,type,status)
	S BusyFlag=1,FreeFlag=0,Err=0
	;S StatusDesc=$p(^DHCDISSA(status),"^",2)  //获取申请单状态代码
	S PeopleID=0
	S PeopleID=$o(^DHCDISPE(0,"TypePointer",type,pointer,PeopleID))  //获取申请单护工表ID
	q:PeopleID="" 0
	S UserDr=$p(^DHCDISPE(PeopleID),"^",3)
	S LocUserID=""
	q:'$d(^DHCDISLU(0,"User",UserDr)) 1
	S LocUserID=$o(^DHCDISLU(0,"User",UserDr,LocUserID))   //获取护工表ID
	s WorkLoad=$p(^DHCDISLU(LocUserID),"^",5)    //工作量
	//S DisReqNum=..GetDisReqNum(UserDr,type)
	I (WorkLoad<1)  d
	.&sql(update DHC_DisLocUser set LU_Status=:FreeFlag where LU_RowId=:LocUserID)
	.S Err=SQLCODE
	E  D
	.s WorkLoad=WorkLoad-1
	.&sql(update DHC_DisLocUser set LU_Status=:BusyFlag, LU_Workload=:WorkLoad where LU_RowId=:LocUserID)
	.S Err=SQLCODE
	
	Q Err
}

/// w ##class(web.DHCDISRequestCom).GetDisReqNum(4968,1)
ClassMethod GetDisReqNum(userdr, type)
{
	n (userdr,type)
	
	S Type="",Num=0
	F  S Type=$o(^DHCDISPE(0,"TypePointer",Type)) q:Type=""  d  //获取申请单护工表ID
	.Q:Type=0
	.q:Type'=type    ///sufan 2018-03-22
	.S Pointer="",Status=""
	.F  S Pointer=$o(^DHCDISPE(0,"TypePointer",Type,Pointer)) q:Pointer=""  d
	..Q:Pointer=0
	..S TypeCode=$p(^DHCDISTA(type),"^",1)
	..I TypeCode="陪送"  D
	...S Status=$p(^DHCDISRE(Pointer),"^",16)
	..E  D
	...S Status=$p(^DHCDISGRE(Pointer),"^",10)
	..S StatusDesc=$p(^DHCDISSA(Status),"^",2)
	..Q:(StatusDesc'="已安排")
	..S PeopleID=""
	..F  S PeopleID=$o(^DHCDISPE(0,"TypePointer",Type,Pointer,PeopleID)) q:PeopleID=""  d
	...Q:PeopleID=0
	...S UserDr=$p(^DHCDISPE(PeopleID),"^",3)
	...Q:UserDr'=userdr
	...s Num=Num+1
	
	Q Num
}

/// 查看配送人员在其他配送配送申请里的状态
ClassMethod checkPeopleRequest(user)
{
	n (user)
	
	q 1
}

/// 获取进程号
ClassMethod getPid()
{
	q $i(^DHCST("REQUEST"))
}

/// 查询历史记录
/// w ##class(web.DHCDISRequestCom).listHistory(1,10,104,1)
ClassMethod listHistory(page = 1, rows = 10, pointer = "", type = 1)
{
	n (page,rows,pointer,type)
	s End = page*rows
	s Start=(page-1)*rows+1
		s count=0
	w "{""rows"":["
	s his=""
	f  s his=$o(^DHCDISRS(0,"TypePointer",type,pointer,his)) q:his=""  d
	.
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s user=$p(^DHCDISRS(his),"^",6)
	.s date=$p(^DHCDISRS(his),"^",4)
	.s time=$p(^DHCDISRS(his),"^",5)
	.s status=$p(^DHCDISRS(his),"^",3)
	.d jsonObj.Put("status",$p(^DHCDISSA(status),"^",2))
	.d jsonObj.Put("date",$zd(date,3)_" "_$zt(time))
	.i user'="" d jsonObj.Put("user",$p(^SSU("SSUSR",user),"^",2))
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Description: 获取状态ID
/// Creator:     zhaowuqiang
/// CreatDate:   2017-04-22
/// Table:       DHC_DisStatusAdd
/// Input:       状态代码,任务类型
/// Output:      任务状态ID
/// Other:       w ##class(web.DHCDISRequestCom).GetStatusID("已安排",15)
ClassMethod GetStatusID(statuscode, type)
{
	n (statuscode,type)
	
	q:(statuscode="")||(type="") ""

	s status=""
	s status=$o(^DHCDISSA(0,"TypeCode",type,"Y",statuscode,status))
	q:status="" ""
	
	q status
}

/// Description:撤销申请
/// Creator:     zwq
/// CreateDate:  2017-06-20
/// Table: 		 
/// Input:  	 
/// Return
/// W ##Class(web.DHCDISRequestCom).CancelApplicaion("149","100","18","575")
ClassMethod CancelApplicaion(disreqID, statuscode, type, lgUser)
{
	n (disreqID, statuscode, type, lgUser)
	
	TS
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	i status="" tro  q "获取下个流程状态失败"
	&sql(update DHC_DisGoodsRequest set REQ_CurStatus=:status where REQ_RowID=:disreqID)
	i SQLCODE'=0 tro  q "更新申请单状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(disreqID,type,status,lgUser)
	i ret'=0 tro  q "保存操作流水表失败"
	TC
	
	q 0
}

}
