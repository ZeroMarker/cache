Import sqluser

Class web.DHCADVREPONLINE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存评论信息明细  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-8
/// Table: 		 DHC_AdvRepOnline 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// w ##class(web.DHCADVREPONLINE).saveReviewDetail("","")
ClassMethod saveReviewDetail(ronID As %String, ronDataList As %String) As %String
{
	n (ronID,ronDataList)
	s ronUserID=$p(ronDataList,"^",1)  //用户ID
	s ronDesc=$p(ronDataList,"^",2)    //评论信息
	s lkConDetID=$p(ronDataList,"^",3)  //回复ID
	s shareID=$p(ronDataList,"^",4)  //分享ID
	s ret=..InsRepOnline(ronID,ronUserID,ronDesc,lkConDetID,shareID)
	q ret
}

/// Description: 统计点赞数  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-5
/// Table: 		 DHC_AdvRepOnline 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPONLINE).CountOkNum("14")
ClassMethod CountOkNum(ronID As %String, ronUserID As %String) As %String
{
   
    N (ronID,ronUserID)
    s ronOKNum=$p(^DHCADVRON(ronID),"^",7)
    I $d(^DHCADVROA(0,"User",ronID,ronUserID))  D
	.s ronOKNum=ronOKNum-1
	E  D
	.s ronOKNum=ronOKNum+1
	&SQL(Update DHC_AdvRepOnline Set RON_OkNum=:ronOKNum Where RON_RowID=:ronID)
	Q SQLCODE
}

/// Description: 添加评论信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-5
/// Table: 		 DHC_AdvRepOnline 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPONLINE).InsRepOnline("13^600^hahahhhah^^6")
ClassMethod InsRepOnline(ronID, ronUserID, ronDesc, lkConDetID, shareID) As %String
{
	N (ronID, ronUserID, ronDesc, lkConDetID,shareID)
	S ronOKNum=0
	S ronDate=+$H               
	S ronTime=$p($H,",",2)              //记录日期	
	&SQL(Insert Into DHC_AdvRepOnline(RON_Date ,RON_Time, RON_User,RON_Content,RON_Online_Dr,RON_OkNum,RON_Share_Dr ) 
		Values(:ronDate,:ronTime,:ronUserID,:ronDesc,:lkConDetID,:ronOKNum,:shareID))
	Q SQLCODE
}

/// Description: 添加点赞计数信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-9
/// Table: 		 DHC_AdvRepOnlineAcc 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPONLINE).InsRepOnlineAcc("14","600")
ClassMethod InsRepOnlineAcc(ronID As %String, ronUserID As %String) As %String
{
	N (ronID,ronUserID)
	I $d(^DHCADVROA(0,"User",ronID,ronUserID))  D
	.d ..CountOkNum(ronID,ronUserID) 
	.&SQL(Delete From DHC_AdvRepOnlineAcc where ROA_Online_Dr=:ronID And ROA_User=:ronUserID)
    E  D
	.S roaDate=+$H               
	.S roaTime=$p($H,",",2) //记录日期   
	.d ..CountOkNum(ronID,ronUserID)  
	.&SQL(Insert Into DHC_AdvRepOnlineAcc(ROA_Online_Dr ,ROA_DATE, ROA_Time,ROA_User) 
		Values(:ronID,:roaDate,:roaTime,:ronUserID))
	Q SQLCODE
}

/// Description: 添加采纳日期  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-9
/// Table: 		 DHC_AdvRepShare 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPSHARE).InsRepShareDate("7")
ClassMethod InsRepShareDate(shareId As %String) As %String
{
   N (shareId)
	S rshCompleteDate=+$h  //结束日期
	S rshCompleteTime=$p($h,",",2) //结束时间
	&SQL(Update DHC_AdvRepShare Set RSH_CompleteDate=:rshCompleteDate, RSH_CompleteTime=:rshCompleteTime Where RSH_RowID=:shareId)
	Q SQLCODE
}

/// Description: 设置采纳意见状态值  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-5
/// Table: 		 DHC_AdvRepOnlineAcc 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// w ##class(web.DHCADVREPONLINE).saveAdoptOnline("20^Y^600")
ClassMethod saveAdoptOnline(params As %String) As %String
{
	N (params)
	S ronID=$p(params,"^",1)
	S ronAcceptFlag=$p(params,"^",2)
	S ronUserID=$p(params,"^",3)
	S shareId=$p(params,"^",4)
	S shareCreator=$p(^DHCADVRSH(shareId),"^",3)
	Q:(shareCreator'="")&&(ronUserID'=shareCreator) "1"
	d ..InsRepShareDate(shareId)
    ;Q:$d(^DHCADVROA(0,"User",ronID,ronUserID)) "-1^已点赞，不可取消采纳！" 
	
	&SQL(Update DHC_AdvRepOnline Set RON_AcceptFlag=:ronAcceptFlag Where RON_RowID=:ronID)
	Q SQLCODE
}

/* /// Description: 获取点赞数  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-9
/// Table: 		 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPONLINE).QueryOKNum("14")
ClassMethod QueryOKNum(ronID As %String) As %String
{
	n (ronID)

	s Num=0
	s nums=0
	s userID=""
	s ID=""
	f  s userID=$o(^DHCADVROA(0,"User",ronID,userID)) q:userID=""  d
	.f  s ID=$o(^DHCADVROA(0,"User",ronID,userID,ID)) q:ID=""  d
	..s Num=Num+1
	.s nums=nums+Num
	.s Num=0
	q nums
} */
/// Description: 获取点赞数 
/// Creator:     yangyongtao
/// CreateDate:  2016-6-12
/// Table: 		 DHC_AdvRepOnlineAcc 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPONLINE).GetOkNumDetail("12","1","35^")
ClassMethod GetOkNumDetail(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	S onlineID=$p(params,"^",1)
	S TypeEvent=$p(params,"^",2)
	S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	d ..killTmpGlobal(pid)
	s Num=0
	s ID=""
	f  s ID=$o(^DHCADVROA(ID)) q:ID=""  d
	.Q:ID=0
	.s roaOnlineDr=$p(^DHCADVROA(ID),"^", 1) //评论表ID  ^DHCADVRON
	.s shareID=$p(^DHCADVRON(roaOnlineDr),"^",8) //分享ID ^DHCADVRSH
	.s typeId=$p(^DHCADVRSH(shareID),"^",1)  //类型
	.s TypeCode=""
	.s:(typeId'="")&&(typeId'["||") TypeCode=$p(^DHCMEDADREVT(typeId),"^",2) //描述
	.s:(typeId'="")&&(typeId["||") TypeCode=$p(^DHCMEDADREVTI(+typeId,"MADREVI",$p(typeId,"||",2)),"^",2) //描述	
	.s roaDate=$p(^DHCADVROA(ID),"^",2)
	.s:roaDate'="" roaDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(roaDate)  ///评论日期
	.s roaTime=$p(^DHCADVROA(ID),"^",3)
	.s:roaTime'="" roaTime=$zt(roaTime,1)  ///评论时间
	.s roaUserName=""
	.s roaUserID=$p(^DHCADVROA(ID),"^",4)
	.i roaUserID'="" s roaUserName=$p(^SSU("SSUSR",roaUserID),"^",2)
	.S roaUserName=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",roaUserName)  ;2020-06-28 cy
	.s ListData=ID_"^"_roaOnlineDr_"^"_roaDate_" "_roaTime_"^"_roaUserName_"^"_TypeCode
	.Q:(onlineID'="")&(onlineID'=roaOnlineDr)
	.Q:(TypeEvent'="")&(TypeEvent'=typeId)
	.s Num=Num+1
	.s ^TMP("DHCADV","web.DHCADVREPONLINE","QueryOkNumDetail",pid,Num)=ListData

	q:Num="0" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="ID^roaOnlineDr^roaDateTime^roaUserName^TypeCode"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVREPONLINE","QueryOkNumDetail",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCADV","web.DHCADVREPONLINE","QueryOkNumDetail",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid) //QueryOkNumDetail
	k ^TMP("DHCADV","web.DHCADVREPONLINE","QueryRepOnline",pid)
	k ^TMP("DHCADV","web.DHCADVREPONLINE","QueryOkNumDetail",pid)
}

/// Description: 获取评论信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-5
/// Table: 		 DHC_AdvRepOnline 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据 d ##Class(User.DHCAdvRepOnline).%BuildIndices()
/// Others:		 w ##class(web.DHCADVREPONLINE).QueryRepOnline("12","1","20^4")
ClassMethod QueryRepOnline(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	S ronID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	d ..killTmpGlobal(pid)
	s Num=0
	s Sub=""
	f  s Sub=$o(^DHCADVRON(0,"SHA",ronID,Sub)) q:Sub=""  d
	.s ronDate=$p(^DHCADVRON(Sub),"^",1)
	.s:ronDate'="" ronDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(ronDate)  ///评论日期
	.s ronTime=$p(^DHCADVRON(Sub),"^",2)
	.s:ronTime'="" ronTime=$zt(ronTime,1)  ///评论时间
	.s ronUserName=""
	.s ronUserID=$p(^DHCADVRON(Sub),"^",3)
	.i ronUserID'="" s ronUserName=$p(^SSU("SSUSR",ronUserID),"^",2)
	.S ronUserName=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",ronUserName)
	.s ronDesc=$p(^DHCADVRON(Sub),"^",4) ///描述
	.s ronOnlineDr=$p(^DHCADVRON(Sub),"^",5) ///评论id 2016-09-26 congyue
	.q:ronOnlineDr'="" //2016-09-26 congyue
	.s ronAcceptFlag=$p(^DHCADVRON(Sub),"^",6) ///采纳标志
	.s ronOkNum=$p(^DHCADVRON(Sub),"^",7)
	.s ronOKflag="N"
	.S:$d(^DHCADVROA(0,"User",Sub,UserID)) ronOKflag="Y"
	.;s ronOkNum=..QueryOKNum(Sub) //点赞数
	.s ListData=Sub_"^"_ronDate_" "_ronTime_"^"_ronUserName_"^"_ronDesc_"^"_ronAcceptFlag_"^"_ronOkNum_"^"_ronOKflag
	.s Num=Num+1
	.s ^TMP("DHCADV","web.DHCADVREPONLINE","QueryRepOnline",pid,Num)=ListData
	.s Num=..GetRepOnlineInfo(pid,Num,Sub,UserID) //2016-09-26 congyue
	q:Num="0" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="ronID^ronDate^ronUserName^ronDesc^ronAcceptFlag^ronOkNum^ronOKflag"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVREPONLINE","QueryRepOnline",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCADV","web.DHCADVREPONLINE","QueryRepOnline",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Description: 获取评论信息  
/// Creator:     congyue
/// CreateDate:  2016-09-26
/// Table: 		 DHC_AdvRepOnline 
/// Input: 		 pid Num 分享表id
/// Return： 	 Num
/// Others:		 
ClassMethod GetRepOnlineInfo(pid, Num, Sub, UserID As %String) As %String
{
	n (pid,Num,Sub,UserID,%session)
	s onlineid=""
	f  s onlineid=$o(^DHCADVRON(0,"Online",Sub,onlineid)) q:onlineid=""  d
	.s ronDate=$p(^DHCADVRON(onlineid),"^",1)
	.s:ronDate'="" ronDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(ronDate)  ///评论日期
	.s ronTime=$p(^DHCADVRON(onlineid),"^",2)
	.s:ronTime'="" ronTime=$zt(ronTime,1)  ///评论时间
	.s ronUserName=""
	.s ronUserID=$p(^DHCADVRON(onlineid),"^",3)
	.i ronUserID'="" s ronUserName=$p(^SSU("SSUSR",ronUserID),"^",2)
	.S ronUserName=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",ronUserName)
	.s ronDesc=$p(^DHCADVRON(onlineid),"^",4) ///描述
	.s ronAcceptFlag=$p(^DHCADVRON(onlineid),"^",6) ///采纳标志
	.s ronOkNum=$p(^DHCADVRON(onlineid),"^",7)
	.s ronOKflag="N"
	.S:$d(^DHCADVROA(0,"User",onlineid,UserID)) ronOKflag="Y"
	.s ListData=onlineid_"^"_ronDate_" "_ronTime_"^"_ronUserName_"^"_ronDesc_"^"_ronAcceptFlag_"^"_ronOkNum_"^"_ronOKflag
	.s Num=Num+1
	.s ^TMP("DHCADV","web.DHCADVREPONLINE","QueryRepOnline",pid,Num)=ListData
	.s Num=..GetRepOnlineInfo(pid,Num,onlineid,UserID)
	q Num
}

}
