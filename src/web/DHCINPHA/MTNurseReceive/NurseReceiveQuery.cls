/// Description:护士病区签收查询相关
/// Creator:    hulihua
/// CreateDate: 2016-10-24
/// Table:      DHC_PHBox
Class web.DHCINPHA.MTNurseReceive.NurseReceiveQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询物流箱信息
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:      DHC_PHBox
/// Input:		每页行数、页数、箱号
/// Output:		物流箱ID、箱号、箱数、药房交接人、药房交接日期、药房交接时间、物流人员、病区交接人、
///             病区交接日期、病区交接时间、病区核对人、病区核对日期、病区核对时间
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseReceive.NurseReceiveQuery).GetInPhBoxInfo("50","1","ZX20170424001")
ClassMethod GetInPhBoxInfo(rows, page, params) As %String
{
	 n (rows, page,params)
	 //s ^hlh($h)=$lb(rows, page,params)
	 q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
     i $g(page)="" s page=1
     i $g(rows)="" s rows=50
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 s PhBoxNo=params
	 s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery")
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetInPhBoxInfo",pid)
	 s n=0
	 s phbid="" 
	 f  s phbid=$o(^DHCPHBOXi("No",PhBoxNo,phbid)) q:phbid=""  d
	 .s phbno=$p(^DHCPHBOX(phbid),"^",1)
	 .s phbnum=$p(^DHCPHBOX(phbid),"^",2)
	 .s userphhandid=$p(^DHCPHBOX(phbid),"^",3)
	 .s userphhand=$s(userphhandid'="":$p($G(^SSU("SSUSR",userphhandid)),"^",2),1:"")
	 .s datephhand=$p(^DHCPHBOX(phbid),"^",4)
	 .s datephhand=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datephhand)
	 .s timephhand=$p(^DHCPHBOX(phbid),"^",5)
	 .s timephhand=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timephhand) 
	 .s userlogisticsdr=$p(^DHCPHBOX(phbid),"^",6)
	 .s userlogistics=$s(userlogisticsdr'="":$p($G(^SSU("SSUSR",userlogisticsdr)),"^",2),1:"")
	 .s userwardhanddr=$p(^DHCPHBOX(phbid),"^",7)
	 .s userwardhand=$s(userwardhanddr'="":$p($G(^SSU("SSUSR",userwardhanddr)),"^",2),1:"")
	 .s datewardhand=$p(^DHCPHBOX(phbid),"^",8)
	 .s datewardhand=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datewardhand)
	 .s timewardhand=$p(^DHCPHBOX(phbid),"^",9) 
	 .s timewardhand=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timewardhand) 
	 .s userwardchkdr=$p(^DHCPHBOX(phbid),"^",10)
	 .s userwardchk=$s(userwardchkdr'="":$p($G(^SSU("SSUSR",userwardchkdr)),"^",2),1:"")
	 .s datewardchk=$p(^DHCPHBOX(phbid),"^",11)
	 .s datewardchk=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datewardchk)
	 .s timewardchk=$p(^DHCPHBOX(phbid),"^",12) 
	 .s timewardchk=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timewardchk) 
	 .s n=n+1
	 .s data1=$g(phbid)_"^"_$g(phbno)_"^"_$g(phbnum)_"^"_$g(userphhand)_"^"_$g(datephhand)
	 .s data2=$g(timephhand)_"^"_$g(userlogistics)_"^"_$g(userwardhand)_"^"_$g(datewardhand)_"^"_$g(timewardhand)
	 .s data3=$g(userwardchk)_"^"_$g(datewardchk)_"^"_$g(timewardchk)
	 .s data=data1_"^"_data2_"^"_data3
	 .s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetInPhBoxInfo",pid,n)=data
     q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetInPhBoxInfo",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetInPhBoxInfo",pid,h)
     .s count = count+1
	 .s Title1="TPhbID^TPhbNo^TPhbNum^TUserPhHand^TDatePhHand"
	 .s Title2="TTimePhHand^TUserLogistics^TUserWardHand^TDateWardHand^TTimeWardHand"
	 .s Title3="TUserWardChk^TDateWardChk^TTimeWardChk"
	 .s Title=Title1_"^"_Title2_"^"_Title3
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	
	 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetInPhBoxInfo",pid)
     q ""
}

/// Description:获取登录用户在当天总共签收了几个物流箱号
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:		DHC_PHBox      
/// Input:		登录用户ID      
/// Output:			
/// Return：	物流箱号数量
/// w ##class(web.DHCINPHA.MTNurseReceive.NurseReceiveQuery).GetUserRcBoxCount("578")
ClassMethod GetUserRcBoxCount(guser, usercode, gLocId)
{
	n (guser, usercode, gLocId)
	//s ^hlh($h)=$lb(guser, usercode, gLocId)
	s userid=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserIdByLogCode(usercode)
	s:userid'="" guser=userid
	q:guser="" 0
	s recdate=+$h 				//今天啊
	s phbrow="",count=0
	f  s phbrow=$o(^DHCPHBOXi(0,"WardDateWardHand",gLocId,recdate,phbrow)) q:phbrow=""  d 
	.s userwardhanddr=+$p(^DHCPHBOX(phbrow),"^",7)
	.q:userwardhanddr'=guser
	.s count=count+1
	q count
}

/// Description:检查所输入的物流箱号是否已经签收
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:		DHC_PHBox      
/// Input:		物流箱号      
/// Output:			
/// Return：	0-已签收，1-未签收
/// w ##class(web.DHCINPHA.MTNurseReceive.NurseReceiveQuery).CheckBoxNoStatue("ZX20170424001")
ClassMethod CheckBoxNoStatue(phboxno, LocId)
{
	n (phboxno,LocId)
	q:phboxno="" "-1^物流箱号为空,请核实!"
	q:'$d(^DHCPHBOXi("No",phboxno)) "-2^物流箱号不存在,请核实!"
	s phbid=$o(^DHCPHBOXi("No",phboxno,""),-1)
	q:phbid="" "-3^物流箱号错误,请核实!"
	s wardLocId=$p(^DHCPHBOX(phbid),"^",16)
	q:LocId'=wardLocId "-4^该物流箱不是本病区的,不能签收!"
	s phbstatus=$p(^DHCPHBOX(phbid),"^",13)
	q:phbstatus>60 "-5^该物流箱已签收,请核实!"
	q:phbstatus<60 "-6^该物流箱未进行物流交接,不能签收!"
	q 1
}

/// Description:查询病区已签收信息
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:      DHC_PHBox
/// Input:		每页行数、页数、箱号
/// Output:		物流箱ID、箱号、箱数、药房交接人、药房交接日期、药房交接时间、物流人员、病区交接人、
///             病区交接日期、病区交接时间、病区核对人、病区核对日期、病区核对时间
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseReceive.NurseReceiveQuery).GetInPhBoxInfo("50","1","ZX20170424001")
ClassMethod GetWardNurseRecList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^tmyq($this,"GetWardNurseRecList")=rows_","_page_","_params
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s WardLocId=$p(params,"^",5)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetWardNurseRecList",pid)
	s n=0
	f Date=StartDate:1:EndDate d
	.s phbid="" 
	.f  s phbid=$o(^DHCPHBOXi(0,"WardDateWardHand",WardLocId,Date,phbid)) q:phbid=""  d
	..s phbno=$p(^DHCPHBOX(phbid),"^",1)
	..s phbnum=$p(^DHCPHBOX(phbid),"^",2)
	..s userphhandid=$p(^DHCPHBOX(phbid),"^",3)
	..s userphhand=$s(userphhandid'="":$p($G(^SSU("SSUSR",userphhandid)),"^",2),1:"")
	..s datephhand=$p(^DHCPHBOX(phbid),"^",4)
	..s datephhand=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datephhand)
	..s timephhand=$p(^DHCPHBOX(phbid),"^",5)
	..s timephhand=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timephhand) 
	..s userlogisticsdr=$p(^DHCPHBOX(phbid),"^",6)
	..s userlogistics=$s(userlogisticsdr'="":$p($G(^SSU("SSUSR",userlogisticsdr)),"^",2),1:"")
	../* 物流人员可以存人员姓名或者工号，物流人员可能不是院内人员 */
	..i userlogistics="" d
	...s userlogistics = userlogisticsdr
	..s userwardhanddr=$p(^DHCPHBOX(phbid),"^",7)
	..s userwardhand=$s(userwardhanddr'="":$p($G(^SSU("SSUSR",userwardhanddr)),"^",2),1:"")
	..s datewardhand=$p(^DHCPHBOX(phbid),"^",8)
	..s timewardhand=$p(^DHCPHBOX(phbid),"^",9) 
	..q:(StartTime'="")&&(datewardhand=StartDate)&&(timewardhand<StartTime)
	..q:(EndTime'="")&&(datewardhand=EndDate)&&(timewardhand>EndTime)
	..s datewardhand=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datewardhand)
	..s timewardhand=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timewardhand) 
	..s userwardchkdr=$p(^DHCPHBOX(phbid),"^",10)
	..s userwardchk=$s(userwardchkdr'="":$p($G(^SSU("SSUSR",userwardchkdr)),"^",2),1:"")
	..s datewardchk=$p(^DHCPHBOX(phbid),"^",11)
	..s datewardchk=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datewardchk)
	..s timewardchk=$p(^DHCPHBOX(phbid),"^",12) 
	..s timewardchk=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timewardchk) 
	..s n=n+1
	..s data1=$g(phbid)_"^"_$g(phbno)_"^"_$g(phbnum)_"^"_$g(userphhand)_"^"_$g(datephhand)
	..s data2=$g(timephhand)_"^"_$g(userlogistics)_"^"_$g(userwardhand)_"^"_$g(datewardhand)_"^"_$g(timewardhand)
	..s data3=$g(userwardchk)_"^"_$g(datewardchk)_"^"_$g(timewardchk)
	..s data=data1_"^"_data2_"^"_data3
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetWardNurseRecList",pid,n)=data
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetWardNurseRecList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetWardNurseRecList",pid,h)
	.s count = count+1
	.s Title1="TPhbID^TPhbNo^TPhbNum^TUserPhHand^TDatePhHand"
	.s Title2="TTimePhHand^TUserLogistics^TUserWardHand^TDateWardHand^TTimeWardHand"
	.s Title3="TUserWardChk^TDateWardChk^TTimeWardChk"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetWardNurseRecList",pid)
	q ""
}

}
