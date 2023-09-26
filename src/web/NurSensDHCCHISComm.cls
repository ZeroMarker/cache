/// creator:lulin
/// createdate:2019-11-25
/// description:东华HIS方法接口
Class web.NurSensDHCCHISComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:检测是否是测试患者
/// Date:日期
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod IsTextPat(PatName As %String) As %String
{
	q:PatName="" 0
	q:PatName["测试" 1
	s textPatName=$LB("测试")
	q:$LF(textPatName,PatName)'=0 1
	q 0
}

/// Creator:lulin
/// Description:获取患者信息【公共方法】
/// Date:日期
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetPatInfoData(EpisodeID As %String = "") As %String
{
	q:EpisodeID="" ""
	q:$g(^PAADM(EpisodeID))="" ""
	s disdate=$p($g(^PAADM(EpisodeID)),"^",59) ;准许出院日期
	s distime=$p($g(^PAADM(EpisodeID)),"^",60) ;准许出院时间
	;s disdate=$p($g(^PAADM(EpisodeID)),"^",17)  ;出院日期
 	;s distime=$p($g(^PAADM(EpisodeID)),"^",18)  ;出院时间
 	s visstu=$p($g(^PAADM(EpisodeID)),"^",20) ;出院状态
 	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6) ;就诊日期
	s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7) ;就诊时间
 	s ret=disdate_"^"_distime_"^"_visstu_"^"_AdmDate_"^"_AdmTime
 	q ret
}

/// Creator:lulin
/// Description:获取东华CT_Loc数据
/// Date:2019-11-25
/// Table:
/// Input:
/// Output：
/// Others:id^代码^描述^类型（W指病区E指各种执行科室包括门诊住院医生所在科室检查检验科室等D指药房OP手术室）
ClassMethod GetCTLocList(tmp) As %String
{
	s locid="" f  s locid=$O(^CTLOC(locid)) q:locid=""  d
	.s loccode=$P(^CTLOC(locid),"^",1)
	.s locdesc=$P(^CTLOC(locid),"^",2)
	.s loctype=$P(^CTLOC(locid),"^",13)
	.q:(locdesc["停用")!(+locdesc=locdesc)
	.q:$d(tmp(locid))'=0
	.s loccode=$replace($tr(loccode," ",""),"\","\\")
	.s locdesc=$replace($tr(locdesc," ",""),"\","\\")
	.s tmp(locid)=locid_"^"_loccode_"^"_locdesc_"^"_loctype
	q ""
}

/// Creator:lulin
/// Description:判断HIS工号和密码是否正确
/// Date:2019-11-26
/// Table:
/// Input:
/// Output：-1:不存在HIS工号，0:密码错误，1：密码正确
/// Others:需要和第三方HIS确定超级用户工号
ClassMethod ConfirmPassword(userCode As %String = "", password As %String = "") As %String
{
	s ret=0
	s hisId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:hisId="" "-1" //不能存在his工号
	s userpassword=$p($G(^SSU("SSUSR",hisId)),"^",3)
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(password)
	s:pin=userpassword ret=1
	zn oldnamespace
	q ret
}

/// Creator:lulin
/// Description:查询医嘱项目---此接口如果不是东华his需要重写，在元素设定界面直接使用了
/// Date:2019-12-26
/// Table:User.ARCItmMast
/// Input:
/// Output：
/// Others:
Query FindOrderList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrderListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$o(^ARCIM(0,"Code",code)) q:code=""  d
	.s subScript="" f  s subScript=$o(^ARCIM(0,"Code",code,subScript)) q:subScript=""  d
	..s version="" f  s version=$o(^ARCIM(0,"Code",code,subScript,version)) q:version=""  d
	...s ItmDesc=$p(^ARCIM(subScript,version,1),"^",2)
	...s ItemCode=$p($g(^OEORD(subScript,"I",version,1)),"^",2)
	...;q:((parr'="")&&(ItmDesc'[parr))
	...s ItmDesc=$replace(ItmDesc,"'","")
	...s ItmSpell=##class(web.NurSensUtilComm).ToChineseSpell(ItmDesc)
	...q:((parr'="")&&((ItmDesc_ItmSpell)'[$zcvt($tr(parr," ",""),"U"))&&((subScript_"__"_version)'[parr))
	...s ret="ItmDesc|"_ItmDesc_"^ItmSpell|"_ItmSpell_"^RowID|"_subScript_"^Sub|"_version
	...do OutputRowsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:jiangyingcan
/// Description:获取医嘱例次/留置日数【弃用】
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod getOrderNum(date, tmpE, tmpData) As %String
{
	q:date="" 0
	//s tmpE("1")="O#1894||1^9180||1^9641||1^2252||1"
	//s tmpE("2")="L#536||1^11007||1"
	s oew="" f  s oew=$O(^OEORDi(0,"DateExecute",date,oew)) q:oew=""  d
	.s ordSub="" f  s ordSub=$O(^OEORDi(0,"DateExecute",date,oew,ordSub)) q:ordSub=""  d
	..s oeoreSub="" f  s oeoreSub=$O(^OEORDi(0,"DateExecute",date,oew,ordSub,oeoreSub)) q:oeoreSub=""  d 
	...s execStatusId=$p($g(^OEORD(oew,"I",ordSub,"X",oeoreSub)),"^",16) //执行状态
	...q:execStatusId'=1  //只统计执行的
	...s arcimId=$P($G(^OEORD(oew,"I",ordSub,1)),"^",2)   //医嘱id
	...s elementId="" f  s elementId=$O(tmpE(elementId)) q:elementId=""  d  //元素id
	....s elementFlag=$P(tmpE(elementId),"#",1)    //类型   O例次L留置日数
	....s elementOrdId="^"_$P(tmpE(elementId),"#",2)_"^"  //配置的医嘱
	....q:elementOrdId'[("^"_arcimId_"^")
	....s ARCIMDesc=$P(^ARCIM($P(arcimId,"||",1),$P(arcimId,"||",2),1),"^",2)  //医嘱名称
	....s admId=$P(^OEORD(oew),"^",1)   //就诊号
	....s stDate=$P(^OEORD(oew,"I",ordSub,1),"^",9)  //医嘱开始日期
	....s stTime=$zt($P(^OEORD(oew,"I",ordSub,1),"^",10),2)  //医嘱开始时间
	....s wardId=..getTransWardByDateTime(admId,$zd(stDate,3),stTime)  //根据开始日期、时间获取当时患者所在病区。获取不到获取当前病区
	....i wardId="" s wardId=$p(^PAADM(admId),"^",70)  
	....q:wardId=""
	....s locId=$p(^PAWARD(wardId),"^",5)   //ctloc病区id
	....s papmiId=+^PAADM(admId)  //患者id
	....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)  //患者姓名
	....i (elementFlag="O")&&($g(tmpData(locId,date,elementId,admId,arcimId))="")  d
	.....s tmpData(locId,date,elementId)=$g(tmpData(locId,date,elementId))+1   //例次
	.....i $g(tmpData(locId,date,elementId,admId,arcimId))="" s tmpData(locId,date,elementId,admId,arcimId)=patName_"@"_stDate_"@"_ARCIMDesc
	....i (elementFlag="L")&&($g(tmpData(locId,date,elementId,admId,arcimId))="")&&(date>stDate)  d
	.....s tmpData(locId,date,elementId)=$g(tmpData(locId,date,elementId))+1   //留置日数
	.....i $g(tmpData(locId,date,elementId,admId,arcimId))="" s tmpData(locId,date,elementId,admId,arcimId)=patName_"@"_stDate_"@"_ARCIMDesc
	q 1
}

/// Creator:      zw
/// CreateDate:   2018.12.05
/// Description:  获取患者对应时间所在病区
/// Other: w ##Class(web.NurSensDHCCHISComm).getTransWardByDateTime(2872458,"2018-11-09","10:00")
ClassMethod getTransWardByDateTime(episodId, date, time) As %String
{
	;New (episodId,date,time)
	Quit:(episodId="")||(date="")||(time="") ""
	Set:date["-" date=$zdh(date,3)
	if ((time[":")&&($L(time,":")=2)) {
		s time=time_":00"	
	}
	Set:time[":" time=$zth(time)
	Kill rtnData
	Quit:episodId="" ""
	Quit:$g(^PAADM(episodId))="" ""
	Set tranWardNum=0
	Set visitStatus=$p(^PAADM(episodId),"^",20)
	Set lastWardid="",staDate="",staTime=""
	Set chl="" For  Set chl=$O(^PAADM(episodId,"TRANS",chl)) Quit:chl=""  Do
	.;Set transTypeDR=$P(^PAADM(episodId,"TRANS",chl),"^",21)
	.;Set transTypeCode=""
	.;If transTypeDR'="" Set transTypeCode=$P($G(^PAC("TRANSTYP",transTypeDR)),"^",1)
	.;Quit:transTypeCode="M"
	.Set wardId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
	.;If wardId="" Set wardId=lastWardid
	.Quit:wardId=""
	.Quit:$P(^PAADM(episodId,"TRANS",chl),"^",8)="" ;床为空
	.If (lastWardid'="")&&(wardId'=lastWardid) Do
	..Set lastWardid=wardId,tranWardNum=tranWardNum+1
	..Set staDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
	..Set staTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)  
	.If lastWardid="" Do
	..Set lastWardid=wardId,tranWardNum=tranWardNum+1 
	..Set staDate=$P(^PAADM(episodId),"^",6) //首次取就诊时间
	..Set staTime= $P(^PAADM(episodId),"^",7)
  	.Set endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
    .Set endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
  	.Set rtnData(tranWardNum)=wardId_"^"_staDate_"^"_staTime_"^"_endDate_"^"_endTime
  	//出院取出院时间
  	If $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))'="Y" Do
  	.Set disDate=$P($G(^PAADM(episodId,"DHC")),"^",29)
	.Set disTime=$P($G(^PAADM(episodId,"DHC")),"^",30)
	Else  Do
	.Set disDate=$p(^PAADM(episodId),"^",17) 
	.Set disTime=$p(^PAADM(episodId),"^",18) 
  	Set ret="" 
    Set dateTime=date*86400+time
  	Set staDate="",staTime="",endDate="",endTime=""
  	Set Num="" For  Set Num=$O(rtnData(Num)) Quit:(Num="")||(ret'="")  Do
	.Set wardId=$P(rtnData(Num),"^",1)
	.Set staDate=$P(rtnData(Num),"^",2)
	.Set staTime=$P(rtnData(Num),"^",3)
	.Set endDate=$P(rtnData(Num),"^",4)
	.Set endTime=$P(rtnData(Num),"^",5)
	.If (tranWardNum=Num)&&(visitStatus="D") Do 
	..Set endDate=disDate
	..Set endTime=disTime
	.If (endDate="") Set endDate=+$h
	.If (endTime="") Set endTime=$P($h,",",2)
	.Set staDateTime=staDate*86400+staTime
	.Set endDateTime=endDate*86400+endTime
	.Quit:(dateTime<staDateTime)||(dateTime>endDateTime)
 	.Set wardDesc = $p($g(^PAWARD(wardId)),"^",2)
	.;Set ret=wardId_"^"_wardDesc
	.Set ret=wardId
	Quit ret
}

/// Creator:lulin
/// Description:获取医嘱执行记录信息
/// Date:2020-04-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod getOrderExec(date, tmpE, tmpData) As %String
{
	q:date="" 0
#;	s oew="" f  s oew=$O(^OEORDi(0,"ARCIM",oew)) q:oew=""  d
#;	.s ArcimID="" f  s ArcimID=$O(tmpE(ArcimID)) q:ArcimID=""  d
#;	..s ArcimStartDate="" f  s ArcimStartDate=$O(^OEORDi(0,"ARCIM",oew,ArcimID,ArcimStartDate)) q:ArcimStartDate=""  d
#;	...s ordSub="" f  s ordSub=$O(^OEORDi(0,"ARCIM",oew,ArcimID,ArcimStartDate,ordSub)) q:ordSub=""  d
	s ordStTime="" f  s ordStTime=$O(^OEORDi(0,"DateExec",date,ordStTime)) q:ordStTime=""  d
	.s oew="" f  s oew=$O(^OEORDi(0,"DateExec",date,ordStTime,oew)) q:oew=""  d
	..s ordSub="" f  s ordSub=$O(^OEORDi(0,"DateExec",date,ordStTime,oew,ordSub)) q:ordSub=""  d
	...;停医嘱人姓名、停医嘱人id、停医嘱人工号
	...s orderItemId=oew_"||"_ordSub
	...s ArcimID=$P($G(^OEORD(oew,"I",ordSub,1)),"^",2)
	...q:ArcimID=""
	...q:($G(tmpE(ArcimID))="")
	...s ArcimDesc=$P($g(^ARCIM($P(ArcimID,"||",1),$P(ArcimID,"||",2),1)),"^",2)  //医嘱名称
	...s EpisodeID=$P($g(^OEORD(oew)),"^",1)   //患者EpisodeID
	...s patInfo=..GetPatInfoData(EpisodeID)
	...s patDisDate=$P(patInfo,"^",1) ;出院日期     
	...s patDisTime=$P(patInfo,"^",2) ;出院时间         
	...s papmiId=+^PAADM(EpisodeID)  //患者id
	...s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //患者姓名
	...q:..IsTextPat(PatName)=1
	...s motherDR=$P(^PAADM(EpisodeID),"^",75)
	...s ArcimStartDate=$P($g(^OEORD(oew,"I",ordSub,1)),"^",9)  //医嘱开始日期
	...s ArcimStartTime=$P($g(^OEORD(oew,"I",ordSub,1)),"^",10)  //医嘱开始时间
	...s wardId=..getTransWardByDateTime(EpisodeID,$zd(ArcimStartDate,3),$zt(ArcimStartTime,2))  //根据开始日期、时间获取当时患者所在病区。获取不到获取当前病区
	...s:wardId="" wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	...q:wardId=""
	...s OEORIItemStatDR=$P($g(^OEORD(oew,"I",ordSub,1)),"^",13)
	...s OEORIItemStatCode="" ;状态 D未停止、U为作废
	...i OEORIItemStatDR'="" d
	....s OEORIItemStatCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	...s XDate=$P($g(^OEORD(oew,"I",ordSub,3)),"^",34) //医嘱停止日期
	...s XTime=$P($g(^OEORD(oew,"I",ordSub,2)),"^",15) //医嘱停止时间
	...s OeordDoctorId=$P($g(^OEORD(oew,"I",ordSub,1)),"^",11) ;下医嘱id
	...s OeordDoctorNo="",OeordDoctorName=""
	...i OeordDoctorId'=""  d
	....s OeordDoctorNo=$P(^CTPCP(OeordDoctorId,1),"^",1) ;下医嘱人姓名
	....s OeordDoctorName=$P(^CTPCP(OeordDoctorId,1),"^",2) ;下医嘱工号
	...s XCTCPId=$P($g(^OEORD(oew,"I",ordSub,3)),"^",29) ;停医嘱id
	...s XCTCPNo="",XCTCPName=""
	...i XCTCPId'=""  d
	....s XCTCPNo=$P(^CTPCP(XCTCPId,1),"^",1) ;停医嘱人姓名
	....s XCTCPName=$P(^CTPCP(XCTCPId,1),"^",2) ;停医嘱工号
	...s priorDr=$P($g(^OEORD(oew,"I",ordSub,1)),"^",8) ;医嘱优先级（类别）
	...s priorDesc=""
	...s:priorDr'="" priorDesc=$p($g(^OECPR(priorDr)),"^",2)
	...s:((priorDesc'["长期")&&(XDate="")) XDate=ArcimStartDate,XTime=ArcimStartTime
	...s xOrderCTLocID=""
	...i XDate'="" d
	....s xWardId=..getTransWardByDateTime(EpisodeID,XDate+1,1)  //停医嘱次日在何病区
	....s:xWardId'="" xOrderCTLocID=$p($g(^PAWARD(xWardId)),"^",5)   //ctloc病区id
	...i ((patDisDate'="")&&((XDate="")||(XDate>patDisDate))) d
	....s XDate=patDisDate ;出院日期
	....s XTime=patDisTime ;出院时间
	...s OrderDoseQty=$P($g(^OEORD(oew,"I",ordSub,2)),"^",1) //剂量
	...s OrderUnit=$P($g(^OEORD(oew,"I",ordSub,2)),"^",3) //剂量单位
	...s OrderInstrDR=$P($g(^OEORD(oew,"I",ordSub,2)),"^",7) //用法
	...;从这一天往后算
	...s oeoreSub="" f  s oeoreSub=$O(^OEORDi(0,"DateExec",date,ordStTime,oew,ordSub,oeoreSub)) q:oeoreSub=""  d 
	....s ArcimExecID=oew_"||"_ordSub_"||"_oeoreSub
	....;s execStatusId=$p($g(^OEORD(oew,"I",ordSub,"X",oeoreSub,"BILL")),"^",1) //执行状态
	....s execStatusId=$p($g(^OEORD(oew,"I",ordSub,"X",oeoreSub)),"^",16) //执行状态
	....s OrderExecDate=$P(^OEORD(oew,"I",ordSub,"X",oeoreSub),"^",1) //执行日期
	....s OrderExecTime=$P(^OEORD(oew,"I",ordSub,"X",oeoreSub),"^",2) //执行时间
	....s ExecPerUserId=$P(^OEORD(oew,"I",ordSub,"X",oeoreSub),"^",15) //执行人idCTCareProv
	....s ExecPerUserNo="",ExecPerName="",excWard=wardId
	....i ExecPerUserId'=""  d
	.....s ExecPerUserNo=$P(^CTPCP(ExecPerUserId,1),"^",1) //执行人code
	.....s ExecPerName=$P(^CTPCP(ExecPerUserId,1),"^",2) //执行人姓名
	.....;s OrderExecWard=$P($G(^OEORD(oew,"I",ordSub,"X",oeoreSub,"NUR")),"^",5)
	.....i ((OrderExecDate'="")&&(OrderExecTime'="")) d
	......s excWard=..getTransWardByDateTime(EpisodeID,$zd(OrderExecDate,3),$zt(OrderExecTime,2))  //根据开始日期、时间获取当时患者所在病区。获取不到获取当前病区
	......s:excWard="" excWard=$p($g(^PAADM(EpisodeID)),"^",70)
	....q:excWard=""
	....s OrderExecCTLoc=$p($g(^PAWARD(excWard)),"^",5)   //ctloc病区id
	....s orderExecRet="ExecPerUserId|"_ExecPerUserId_"^OrderExecDate|"_OrderExecDate_"^OrderExecTime|"_OrderExecTime
	....s orderExecRet=orderExecRet_"^OrderExecWard|"_OrderExecCTLoc_"^EpisodeID|"_EpisodeID_"^PatName|"_PatName_"^PatDisDate|"_patDisDate
	....s orderExecRet=orderExecRet_"^ArcimID|"_ArcimID_"^ArcimDesc|"_ArcimDesc_"^ExecPerName|"_ExecPerName
	....s orderExecRet=orderExecRet_"^ExecPerUserId|"_ExecPerUserId_"^ExecPerUserNo|"_ExecPerUserNo
	....s orderExecRet=orderExecRet_"^ArcimStartDate|"_ArcimStartDate_"^ArcimStartTime|"_ArcimStartTime
	....s orderExecRet=orderExecRet_"^execStatusId|"_execStatusId_"^ArcimExecID|"_ArcimExecID
	....s tmpData(orderItemId,oeoreSub)=orderExecRet
	...s tranInfo=..GetPatTrasInfo(date, EpisodeID)
	...s tranDate=$P(tranInfo,"^",1)
	...s tranTime=$P(tranInfo,"^",2)
	...s nowWard=$P(tranInfo,"^",3)
	...s StDate=ArcimStartDate,StTime=ArcimStartTime
	...;i ((nowWard'="")&&(tranDate'="")&&((nowWard'=wardId)||(tranDate>ArcimStartDate))) d ;
	...;.i ((XDate="")||(XDate>tranDate)||((XDate=tranDate)&&(tranTime<XTime))) d
	...;..s wardId=nowWard,ArcimStartDate=tranDate,ArcimStartTime=tranTime
	...i (tranDate>=ArcimStartDate) d
	....s wardId=nowWard,ArcimStartDate=tranDate,ArcimStartTime=tranTime
	...s:wardId'="" OrderCTLoc=$p($g(^PAWARD(wardId)),"^",5)   //ctloc病区id
	...s orderRet="OrderItemId|"_orderItemId_"^StartDate|"_ArcimStartDate_"^StartTime|"_ArcimStartTime
	...s orderRet=orderRet_"^EndDate|"_XDate_"^EndTime|"_XTime_"^OrderWard|"_OrderCTLoc_"^XOrderCTLocID|"_xOrderCTLocID
	...s orderRet=orderRet_"^EpisodeID|"_EpisodeID_"^PatName|"_PatName_"^ArcimID|"_ArcimID_"^ArcimDesc|"_ArcimDesc_"^PatDisDate|"_patDisDate
	...s orderRet=orderRet_"^OeordDoctorName|"_OeordDoctorName_"^OeordDoctorId|"_OeordDoctorId_"^OeordDoctorNo|"_OeordDoctorNo
	...s orderRet=orderRet_"^XCTCPName|"_XCTCPName_"^XCTCPId|"_XCTCPId_"^XCTCPNo|"_XCTCPNo_"^OEORIItemStatCode|"_OEORIItemStatCode
	...s orderRet=orderRet_"^MotherEpisodeID|"_motherDR_"^OrderDoseQty|"_OrderDoseQty_"^OrderUnit|"_OrderUnit_"^OrderInstrDR|"_OrderInstrDR
	...s orderRet=orderRet_"^StDate|"_StDate_"^StTime|"_StTime_"^XDate|"_XDate_"^XTime|"_XTime_"^PriorDesc|"_priorDesc
	...s tmpData(orderItemId)=orderRet
	q 1
}

/// 转出病区，转入病区
ClassMethod GetPatTrasInfo(date, EpisodeID) As %String
{
	s tranDate="",tranTime="",nowWard="",beforWard=""
	s stDate="" f  s stDate=$O(^PAADMi("TransDateTime1",EpisodeID,stDate)) q:stDate=""  d
	.q:(stDate>date)
	.s stTime="" f  s stTime=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime)) q:stTime=""  d
	..s tranid="" f  s tranid=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime,tranid)) q:tranid=""  d
	...q:(+tranid=0)
	...s bed=$P(^PAADM(EpisodeID,"TRANS",tranid),"^",8)
	...q:(+bed=0)
	...s tTranWard=$P($g(^PAADM(EpisodeID,"TRANS",tranid)),"^",9)  ;PACWard
	...q:(tTranWard="")  ;过滤无效数据,如第一次登记
	...q:(tTranWard=beforWard)
	...s beforWard=tTranWard
	...s tranDate=stDate,tranTime=stTime,nowWard=tTranWard
	q tranDate_"^"_tranTime_"^"_nowWard
}

/// Creator:lulin
/// Description:获取医嘱记录信息
/// Date:2020-04-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod getEndOrder(tmpOrder, tmpEndData) As %String
{
	s autoOrderId="" f  s autoOrderId=$O(tmpOrder(autoOrderId)) q:autoOrderId=""  d
	.s orderItemId=$g(tmpOrder(autoOrderId))
	.q:orderItemId=""
	.s oew=$P(orderItemId,"||",1)
	.s ordSub=$P(orderItemId,"||",2)
	.q:((oew="")||(ordSub=""))
	.s XDate=$P($g(^OEORD(oew,"I",ordSub,3)),"^",34) //医嘱停止日期
	.s XTime=$P($g(^OEORD(oew,"I",ordSub,2)),"^",15) //医嘱停止日期
	.s ArcimID=$P($G(^OEORD(oew,"I",ordSub,1)),"^",2)
	.q:ArcimID=""
	.s OEORIItemStatDR=$P($g(^OEORD(oew,"I",ordSub,1)),"^",13)
	.s OEORIItemStatCode="" ;状态 D未停止、U为作废
	.i OEORIItemStatDR'="" d
	..s OEORIItemStatCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	.s XCTCPId=$P($g(^OEORD(oew,"I",ordSub,3)),"^",29) ;停医嘱id
	.s XCTCPNo="",XCTCPName=""
	.i XCTCPId'=""  d
	..s XCTCPNo=$P(^CTPCP(XCTCPId,1),"^",1) ;停医嘱人姓名
	..s XCTCPName=$P(^CTPCP(XCTCPId,1),"^",2) ;停医嘱工号
	.s ArcimStartDate=$P($g(^OEORD(oew,"I",ordSub,1)),"^",9)  //医嘱开始日期
	.s ArcimStartTime=$P($g(^OEORD(oew,"I",ordSub,1)),"^",10)  //医嘱开始时间
	.s priorDr=$P($g(^OEORD(oew,"I",ordSub,1)),"^",8) ;医嘱优先级（类别）
	.s priorDesc=""
	.s:priorDr'="" priorDesc=$p($g(^OECPR(priorDr)),"^",2)
	.s:((priorDesc'["长期")&&(XDate="")) XDate=ArcimStartDate,XTime=ArcimStartTime
	.s EpisodeID=$P($g(^OEORD(oew)),"^",1)   //患者EpisodeID
	.s patInfo=..GetPatInfoData(EpisodeID)
	.s patDisDate=$P(patInfo,"^",1)
	.i ((patDisDate'="")&&((XDate="")||(XDate>patDisDate))) d
	..s XDate=$P(patInfo,"^",1) ;出院日期
	..s XTime=$P(patInfo,"^",2) ;出院时间
	.q:XDate=""
	.s xWardId=..getTransWardByDateTime(EpisodeID,XDate+1,1)  //停医嘱次日在何病区
	.s xOrderCTLocID=""
	.s:xWardId'="" xOrderCTLocID=$p($g(^PAWARD(xWardId)),"^",5)   //ctloc病区id
	.s ret="OrderItemId|"_orderItemId_"^EndDate|"_XDate_"^EndTime|"_XTime_"^OEORIItemStatCode|"_OEORIItemStatCode	
	.s ret=ret_"^XCTCPName|"_XCTCPName_"^XCTCPId|"_XCTCPId_"^XCTCPNo|"_XCTCPNo_"^XOrderCTLocID|"_xOrderCTLocID
	.s ret=ret_"^XDate|"_XDate_"^XTime|"_XTime
	.s tmpEndData(autoOrderId)=ret
	q 1
}

/// Creator:lulin
/// Description:获取患者信息接口
/// Date:2020-02-19
/// Table:
/// Input:日期,结果数组，白班开始时间，夜班开始时间
/// Output：
/// Others:
ClassMethod getPatInfo(date, tmpPatData, dStTime, dEndTime) As %String
{
	s EpisodeID=""  f  s EpisodeID=$O(^PAADMi("PAADM_Type","I",EpisodeID)) q:EpisodeID=""  d
	.q:+EpisodeID=0
	.q:$g(^PAADM(EpisodeID))=""
	.s patInfoData=..GetPatInfoData(EpisodeID)
	.s disdate=$P(patInfoData,"^",1) ;出院日期
	.s distime=$P(patInfoData,"^",2) ;出院时间
	.s visstu=$P(patInfoData,"^",3) ;出院状态
	.s AdmDate=$P(patInfoData,"^",4) ;就诊日期$p($g(^PAADM(EpisodeID)),"^",6) 
	.s AdmTime=$P(patInfoData,"^",5) ;就诊时间$p($g(^PAADM(EpisodeID)),"^",7) 
 	.q:visstu="C"
 	.q:(disdate'="")&&(disdate<date) ;入参日期已出院
 	.s papmidr=$P(^PAADM(EpisodeID),"^",1)
 	.q:papmidr=""
 	.s patname=$P($g(^PAPER(papmidr,"ALL")),"^",1)
 	.q:..IsTextPat(patname)=1
	.s Medicare=$P($g(^PAPER(papmidr,"PAT",1)),"^",22) ;住院号
	.s isBaby="N"
	.s motherDR=$P(^PAADM(EpisodeID),"^",75)
	.s:motherDR'="" isBaby="Y"
 	.s doctor=..GetCareDoctor(EpisodeID)
	.s nurse=..GetDutyNurse(EpisodeID)
	.s patDob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
	.s patAdultDate=""
	.i patDob'="" d
	..s patAdultDate=$zd(patDob,3)
	.s PerDiagnos=..GetPatDiag(EpisodeID,"")
	.s PerLeaveDiagnos=..GetPatDiag(EpisodeID,"DIS")
	.s patInfo="KeyWord|"_EpisodeID_"^Doctor|"_doctor_"^Nurse|"_nurse_"^SubDesc|"_patname_"^IsBaby|"_isBaby
	.s patInfo=patInfo_"^AdmDate|"_AdmDate_"^AdmTime|"_AdmTime_"^PerBirthDate|"_patAdultDate_"^PerDiagnos|"_PerDiagnos
	.s patInfo=patInfo_"^PerLeaveDiagnos|"_PerLeaveDiagnos
	.i disdate=date  d ;出院
	..s:distime="" distime="0"
	..s outWard=""
	..;s outWard=..getTransWardByDateTime(EpisodeID,$zd(disdate,3))
	..s:outWard="" outWard=$p($g(^PAADM(EpisodeID)),"^",70) 
	..s DeadFlag=""
	..s PACDischConditID=$p($g(^PAADM(EpisodeID)),"^",49)
	..i PACDischConditID'="" d
	...s DeadFlag=$P($G(^PAC("DISCON",PACDischConditID)),"^",3)
	...s:DeadFlag="D" DeadFlag=1
	..d:((outWard'="")&&(DeadFlag="")) ..SaveTmpPatData(outWard,patInfo,.tmpPatData,EpisodeID,"O")
	.s index=1,bTranWard=""
	.k tmpPatTran
	.s tmpPatTran=""
	.s stDate="" f  s stDate=$O(^PAADMi("TransDateTime1",EpisodeID,stDate)) q:stDate=""  d
	..q:(stDate>(date+1))
	..s stTime="" f  s stTime=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime)) q:stTime=""  d
	...q:(stDate=(date+1))&&(stTime>dStTime)  ;只考虑次日白班开始时间之前的转科信息
	...s tranid="" f  s tranid=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime,tranid)) q:tranid=""  d
	....q:(+tranid=0)
	....s bed=$P(^PAADM(EpisodeID,"TRANS",tranid),"^",8)
	....q:(+bed=0)
	....s tTranWard=$P($g(^PAADM(EpisodeID,"TRANS",tranid)),"^",9)  ;PACWard
	....q:(tTranWard="")  ;过滤无效数据,如第一次登记
	....q:(tTranWard=bTranWard) ;转床不做考虑
	....s nextFlag=0,nextTranDate=disdate,nextTranTime=distime
	....s nextTranId=""  f  s nextTranId=$O(^PAADM(EpisodeID,"TRANS",nextTranId)) q:(nextTranId="")||(nextFlag=1)  d
	.....q:(+nextTranId=0)
	.....s bed=$P(^PAADM(EpisodeID,"TRANS",nextTranId),"^",8)
	.....q:(+bed=0)
	.....s nextTranWard=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",9)  ;PACWard
	.....q:(nextTranWard="")
	.....q:(nextTranWard=tTranWard)
	.....s nextTranDate=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",1)
	.....s nextTranTime=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",2)
	.....q:((nextTranDate<stDate)||((nextTranDate=stDate)&&(nextTranTime<stTime)))
	.....s nextFlag=1
	....s:nextFlag=0 nextTranDate=disdate,nextTranTime=distime
	....i ((stDate<=date)&&((nextTranDate="")||(nextTranDate>=(date+1)))) d
	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"Z") ;24点接班患者数
	....i ((stDate<date)&&((nextTranDate="")||(nextTranDate>=date))) d
	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"0") ;0点接班患者数
	.....;d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"S") ;总患者数--0点接班数
	.....;d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"B") ;床日数--0点接班数
	....;白班接班患者数
	....i ((stDate<date)||((stDate=date)&&(stTime<dStTime)))&&((nextTranDate="")||(nextTranDate>date)||((nextTranDate=date)&&(nextTranTime>dStTime))) d  
	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"D")
	....;夜班接班患者数
	....i ((stDate<date)||((stDate=date)&&(stTime<dEndTime)))&&((nextTranDate="")||(nextTranDate>date)||((nextTranDate=date)&&(nextTranTime>dEndTime))) d
	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"N")
	....i index=1 d  ;新入患者
	.....d:stDate=date ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"0N") ;0-0新入
	.....;d:stDate=date ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"S") ;总患者数--0点接班数
	.....;d:stDate=date ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"B") ;床日数--0点接班数
	.....i ((stDate=date)&&(stTime>=dStTime)&&(stTime<dEndTime))  d
	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"DN")
	.....i ((stDate>date)||((stDate=date)&&(stTime>=dEndTime))) d
	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"NN")
	....e  d
	.....i ((stDate=date)&&((nextTranDate="")||(nextTranDate>date)||((nextTranDate=date)&&(nextTranTime>0)))) d
	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"0T") ;全天转入
	.....i ((stDate=date)&&(stTime>dStTime)&&(stTime<dEndTime)) d
	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"DT") ;白班转入
	......d:bTranWard'="" ..SaveTmpPatData(bTranWard,patInfo,.tmpPatData,EpisodeID,"DO") ;白班转出
	.....i ((stDate=date)&&(stTime>dEndTime))||((stDate=(date+1))&&(stTime<dStTime)) d
	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"NT") ;夜班转入
	......d:bTranWard'="" ..SaveTmpPatData(bTranWard,patInfo,.tmpPatData,EpisodeID,"NO") ;夜班转出
	.....;;24小时转回来的，48小时内转回来的。
	.....;前前转科记录转入的为相同病区
	.....i stDate=date d
	......s isOneFlag=0,isTwoFlag=0
	......s tranIndex="" f  s tranIndex=$O(tmpPatTran(EpisodeID,tTranWard,tranIndex)) q:((tranIndex="")||((isOneFlag=1)&&(isTwoFlag=1)))  d
	.......s bbTranInfo=$g(tmpPatTran(EpisodeID,tTranWard,tranIndex))
	.......s bbStDate=$P(bbTranInfo,"^",2)
	.......s bbStTime=$P(bbTranInfo,"^",3)
	.......s dTime=((stDate*24*3600+stTime)-(bbStDate*24*3600+bbStTime))\3600
	.......i ((dTime<=24)&&(isOneFlag=0)) d 
	........d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"24")
	........s isOneFlag=1
	.......i ((dTime<=48)&&(isTwoFlag=0))  d 
	........d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"48")
	........s isTwoFlag=1
	....s tmpPatTran(EpisodeID,tTranWard,index)=tranid_"^"_nextTranDate_"^"_nextTranTime  ;保存所有之前的转科记录信息
	....s index=index+1
	....s bTranWard=tTranWard
	
		
#;	....i stDate<date  d  ;转科记录在入参日期之前，为0辰接班患者数,某天只可能在某一个病区
#;	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"0") ;0点接班患者数
#;	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"S") ;总患者数--0点接班数
#;	.....d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"B") ;床日数--0点接班数
#;	.....i (distime>dStTime) d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"D")  ;白班接班患者数
#;	.....e  i distime<dEndTime d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"N")  ;夜班接班患者数
#;	....e  d ;新转入或入院,stDate=date
#;	.....i (stTime<dStTime)&&(distime>dStTime) d ;白班接班患者数--今日转入的且出院时间在今天白班之后
#;	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"D")  ;转出时间未过滤
#;	.....i (stTime<dEndTime)&&(distime>dEndTime) d ;夜班接班患者数--今日转入且出院时间在今天白班之后
#;	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"N")  ;转出时间未过滤
#;	.....i index=1 d
#;	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"S") ;总患者数--新入
#;	......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"B") ;床日数--新入
#;	......i (stTime<dEndTime)&&(stTime>=dStTime) d ;白班新入
#;	.......d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"DN") ;
#;	......e  d ..SaveTmpPatData(tTranWard,patInfo,.tmpPatData,EpisodeID,"NN") ;夜班新入
}

/// Creator:lulin
/// Description:获取患者信息接口
/// Date:2020-02-19
/// Table:
/// Input:日期,结果数组，白班开始时间，夜班开始时间
/// Output：
/// Others:
ClassMethod SaveTmpPatData(pacward, patInfo, tmpPatData, EpisodeID, type) As %String
{
	i '$d(tmpPatData(pacward,type,EpisodeID)) d
	.s tmpPatData(pacward,type)=$g(tmpPatData(pacward,type))+1
	.s tmpPatData(pacward,type,EpisodeID)=patInfo
}

/// Creator:lulin
/// Description:获取主治医生
/// Date:2020-02-19
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetCareDoctor(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s docdr=$P($g(^PAADM(EpisodeID)),"^",9)
	q docdr
#;	q:docdr="" ""
#;	s docname=$P($g(^CTPCP(docdr,1)),"^",2)
#;	q docname
}

/// Creator:lulin
/// Description:获取责任护士
/// Date:2020-02-19
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetDutyNurse(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s mainNurses=""
	s admExtID=""
	s admExtID=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,admExtID),-1)
	q:admExtID="" ""
	s mainNurseID=$P($G(^DHCPAAdm(admExtID)),"^",2)
	s nurseID=$P($G(^DHCPAAdm(admExtID)),"^",20)
	s:nurseID'="" mainNurseID=mainNurseID_","_nurseID
	q mainNurseID
	
#;	i mainNurseID'="" d
#;	.s mainNurseName=$P($G(^CTPCP(mainNurseID,1)),"^",2)
#;	.s mainNurses=mainNurseName
#;	s nurseID=$P($G(^DHCPAAdm(admExtID)),"^",20)
#;	i nurseID'="" d
#;	.s nurseName=$P($G(^CTPCP(nurseID,1)),"^",2)
#;	.s mainNurses=mainNurses_" "_nurseName
#;	q mainNurses
}

/// Creator:lulin
/// Description:获取实际床位数,床位类型进行区分。
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetWardBedData(date As %String = "") As %String
{
#;	q:locId="" 0
#;	s pacward=$O(^PAWARD(0,"WARD_LocationDR",locId,""))
#;	q:pacward="" 0
	s pacward="" f  s pacward=$o(^PAWARD(0,"WardRoom",pacward)) q:pacward=""  d
	.s roomid="" f  s roomid=$o(^PAWARD(0,"WardRoom",pacward,roomid)) q:roomid=""  d
	..s bedchlid="" f  s bedchlid=$o(^PAWARD(0,"WardRoom",pacward,roomid,bedchlid)) q:bedchlid=""  d
	...s pacBedObj=##class(User.PACBed).%OpenId(pacward_"||"_bedchlid)
	...q:'$IsObject(pacBedObj)
	...q:pacBedObj.BEDRcFlag'="Y"
	...s CTLocId=$P($g(^PAWARD(pacward)),"^",5)
	...q:CTLocId=""
	...q:((pacBedObj.BEDCode["婴儿")||(pacBedObj.BEDCode["BABY"))
	...s BEDTPDesc=""
	...s:$IsObject(pacBedObj.BEDBedTypeDR) BEDTPDesc=pacBedObj.BEDBedTypeDR.BEDTPDesc
	...q:((BEDTPDesc["婴儿")||(BEDTPDesc["无费用")||(BEDTPDesc["急诊")||(BEDTPDesc["加")||(BEDTPDesc["监护"))
	...;根据启停时间过滤
	...q:((pacBedObj.BEDDateFrom'="")&&(date'="")&&(pacBedObj.BEDDateFrom>date))
	...q:((pacBedObj.BEDDateTo'="")&&(date'="")&&(pacBedObj.BEDDateTo<date))
	...s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1
	...s ^tmpWardData(CTLocId,pacward_"||"_bedchlid)=pacBedObj.BEDCode
}

/// Creator:wangpengfei
/// Description:BI
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetWardBedData2(date As %String = "") As %String
{
	s:date="" date=+$h
	s bedDate="" f  s bedDate=$o(^DHCMRBed(0,"Date",bedDate)) q:(bedDate="")||(bedDate>date)  d
	.s mrBedId="" f  s mrBedId=$o(^DHCMRBed(0,"Date",bedDate,mrBedId)) q:mrBedId=""  d
	..s obj=##class(User.DHCMRBed).%OpenId(mrBedId)
	..q:'$IsObject(obj)
	..q:(obj.MRLoc="")&&(obj.MRWard="")
	..i obj.MRLoc'="" d
	...s ctLocId=obj.MRLoc.%Id()
	..e  d
	...s ctLocId=$P($g(^PAWARD(obj.MRWard.%Id())),"^",5)
	..q:ctLocId=""
	..s ^tmpWardData(ctLocId)=obj.MRSYNum
}

/// Creator:lulin
/// Description:获取实际床位数,床位类型进行区分。
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensDHCCHISComm).GetWardBedData(66056)
ClassMethod GetWardBedDataNurMg(date As %String = "") As %String
{
	k ^tmpWardData
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	..q:((obj.WardStDate'="")&&(obj.WardStDate>+$H))
	..q:((obj.WardEndDate'="")&&(obj.WardEndDate<+$H))
	..s WardBedNum=obj.WardBedNum
	..q:obj.CTLocDR=""
	..s CTLocId=obj.CTLocDR.%Id()
	..s ^tmpWardData(CTLocId)=WardBedNum
}

/// Creator:lulin
/// Description:nurmg3.0
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetWardBedData3(date As %String = "") As %String
{
	s:date="" date=+$h
	s id="" f  s id=$o(^DHCNMG.DB.MgWardD(id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.CTLocDR)
	.s ^tmpWardData(obj.CTLocDR.%Id())=obj.WardBedNum
}

/// Creator:lulin
/// Description:MDR
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetBedsFromMDR(date As %String = "")
{
	
	s $ZT="ERROR"
	//如果是在循环中调用接口，要将以下初始化client的代码放在循环外面。只初始化一次即可。
	s client=##class(MDRBaseService.web.MDR.Client.MDRBaseServiceSoap).%New()
	q:date="" 1
	s parStr=$zd(date,3)
	s dateStr=client.FunCall("web.DHCWLIFForWHYY2021","GetDepBedHIS","C",parStr)
	s ln=$l(dateStr,",")
	f i=1:1:ln d
	.s mdata=$p(dateStr,",",i)
	.s depId=$p(mdata,":",1)   //科室id（ctloc表的护理单元）
	.s num=$p(mdata,":",2)		//床位数
	.q:depId=""
	.s ^tmpWardData(depId)=num
	q 1
ERROR
	q 0
}

/// Creator：     pylian
/// CreatDate：   2021-04-12
/// Description:  根据日期同步报告数据
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      
/// w ##class(web.NurSensDHCCHISComm).GetInfRepData("2020-05-27","2021-05-27",.tmpInfData)
ClassMethod GetInfRepData(aDateFrom As %String = "", aDateTo As %String = "", tmpInfData) As %String
{
	Set return=""
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportD(xRepID))
		Quit:xRepID=""
		
		Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.IREpisodeDr)
		Continue:'$IsObject(objReport.IRStatusDr)
		//报告状态：1保存,2提交,3审核,4删除,5退回,6取消审核；3审核是最终有效状态
		Set RepStatus = objReport.IRStatusDr.BTCode   //报告状态 
		Set RepType =objReport.IRRepType
		Continue:(RepType'=1)&&(RepType'=2)
		
		Set Flg =0
		Set xLogID=""
		For {
			Set xLogID=$o(^DHCHAI.IR.INFReportD(xRepID,"LOG",xLogID),-1)
			Quit:xLogID=""
			Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(xRepID_"||"_xLogID)
			Continue:'$IsObject(objLog)
			Continue:'$IsObject(objLog.IRStatusDr)
			Set UpdateDate= objLog.IRUpdateDate			
			Continue:(aDateFrom'="")&&(UpdateDate<aDateFrom)
			Continue:(aDateTo'="")&&(UpdateDate>aDateTo)
			Set Flg =1 
			Quit
		}
		Continue:Flg'=1
		
		Set EpisodeDr = objReport.IREpisodeDr.%Id()
		Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
		Continue:PAAdmData=""
		Set EpisodeIDx=$li(PAAdmData,2)           
		Set EpisodeID =$p(EpisodeIDx,"||",2)   //HIS就诊ID	
		Set PaRegNo=$li(PAAdmData,4)           //登记号
		Set PaMrNo=$li(PAAdmData,5)            //病案号
		Set PaName=$li(PAAdmData,6)            //姓名
		Continue:..IsTextPat(PaName)=1
		Set PaSex=$li(PAAdmData,7)             //性别
		Set PaSex=$s(PaSex="M":"男",PaSex="F":"女",1:"其他")
		Set PaAge=$li(PAAdmData,37)             //年龄
		
		Set RepUserCode="",RepUserName=""
		If $IsObject(objReport.IRRepUser)  {
			Set RepUserCode=objReport.IRRepUser.BTCode   //报告人工号
			Set RepUserName=objReport.IRRepUser.BTDesc   //报告人姓名
		}
		Set RepDate =objReport.IRRepDate       //报告日期
		Set RepTime =objReport.IRRepTime	   //报告时间
	
		Set xDiagID = objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)
		Continue:'$IsObject(objDiag.IRInfPosDr)
		Continue:'$IsObject(objDiag.IRInfSubDr)	
		Continue:($D(^oddCOM("DHCAI.IR.INFDiagnos","a","IRInfType"))&&(objDiag.IRInfType'=1))
		Set InfDate  = objDiag.IRInfDate           //感染日期
		Set InfXDate = objDiag.IRInfXDate          //感染结束日期
		Set InfEffect =""
		If ( objDiag.IRInfEffectDr) {
			Set InfEffect=objDiag.IRInfEffectDr.BTDesc   //感染转归
		}
		Set InfPosDr = objDiag.IRInfPosDr.%Id()
		Set InfSubDr = objDiag.IRInfSubDr.%Id()
		Set InfSubDesc = objDiag.IRInfSubDr.BTDesc
		
		Set InfType=""
		Set:(InfSubDesc["PICC") InfType="PICC" 
		Set:(InfSubDesc["CLABSI") InfType="PICC"    
		Set:(InfSubDesc["CA-UTI") InfType="UC" ;导尿管
		Set:(InfSubDesc["VAP") InfType="VAP" ;呼吸机
		Continue:InfType=""
        Continue:(InfType'="PICC")&(InfType'="UC")&(InfType'="VAP")&(InfType'="CVC")
        s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
        s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
        s InfTime="00:00:01"
        s:InfDate=AdmDate InfTime=AdmTime
        s:InfTime="" InfTime="00:00:01"
        Set RepWard=..getTransWardByDateTime(EpisodeID,InfDate,InfTime)
        s:RepWard'="" RepWard=$p($g(^PAWARD(RepWard)),"^",5)
        //报告ID 报告状态 报告日期 报告时间 报告人工号 报告人姓名 就诊ID 病案号 患者姓名 性别 感染日期 感染结束日期  转归 诊断类型
        Set Str="^ReportID|"_xRepID_"^RepStatus|"_RepStatus_"^RepDate|"_RepDate_"^RepTime|"_RepTime
        Set Str=Str_"^RepUserCode|"_RepUserCode_"^RepUserName|"_RepUserName
        Set Str=Str_"^EpisodeID|"_EpisodeID_"^PaRecord|"_PaMrNo_"^PaName|"_PaName_"^PaSex|"_PaSex
        Set Str=Str_"^InfDate|"_InfDate_"^InfXDate|"_InfXDate_"^InfEffect|"_InfEffect_"^InfType|"_InfType
        Set Str=Str_"^RepWard|"_RepWard_"^AdmDate|"_AdmDate_"^AdmTime|"_AdmTime
        Set tmpInfData(xRepID)=Str
	}
	Quit return
}

ClassMethod GetPatDiagFormBL(adm As %String) As %String
{
	s $zt="err"
	set arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(adm,"HDSD00.11")
	set DiagnoseDesc=arr.GetAt("HDSD00.11.024")  
	q DiagnoseDesc
err
	q ""
}

/// 获取病人诊断
/// w ##class(web.NurSensDHCCHISComm).GetPatDiag(1079096,"")
ClassMethod GetPatDiag(adm As %String, typ, ifnotICD = "true") As %String
{
	q:adm="" ""
	s mradm=$p(^PAADM(adm),"^",61)
	s i=0,diag=""
	q:mradm="" ""
    f a2=1:1:$g(^MR(mradm,"DIA",0)) d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .q:icdr="" 
    .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    .i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
    .e  s diatype=""
    .q:(diatype'=typ)&(typ'="")
    .s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
    .s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
    .s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    .s mrdesc=""
    .f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
    ..s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
    .s i=i+1
    .i diag="" s diag=icdcode_" "_$g(mrdesc)
    .e  s diag=diag_";"_icdcode_" "_$g(mrdesc)
    //---------- 取非标准ICD诊断，按诊断类型过滤
    s ret="",MRDIADesc=""
    s chl="" f  s chl=$o(^MR(mradm,"DIA",chl)) q:chl=""  d
    .q:chl=""
    .s typedr=$P($g(^MR(mradm,"DIA",chl,"TYP",1)),"^",1)
    .i $g(typedr)'="" s type=$P($g(^MRC("DTYP",typedr)),"^",1)  ;诊断类型
   	.e  s type=""
    .q:(type'=typ)&(typ'="")
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",chl,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .i ret="" s ret=MRDIADesc
    .e  s ret=ret_";"_MRDIADesc
    i ifnotICD="true" d
    .i ret'="" d
    ..i diag="" s diag=ret
    ..e  s diag=diag_";"_ret
    
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
    q diag
}

/// 输血
ClassMethod GetTransfusion(SttAccDate As %String, EndAccDate As %String) As %String
{
	S:SttAccDate'="" SttAccDate=$zd(SttAccDate,3)
	S:EndAccDate'="" EndAccDate=$zd(EndAccDate,3)
	S SttAccDate=$tr($g(SttAccDate),"-"),EndAccDate=$tr($g(EndAccDate),"-") 
	K ^tmpWardData
	F Date=SttAccDate:1:EndAccDate
	{
		S IssueRecordDR=""
		F {
			S IssueRecordDR=$O(^dbo.BDIssueRecordI("IndexIssueDate",Date,IssueRecordDR))
			Q:'$l(IssueRecordDR)
			S obj=##class(dbo.BDIssueRecord).%New()
			S obj=obj.%OpenId(IssueRecordDR)
			CONTINUE:'$l(obj)
			S ReqId=obj.ReqFormDR
			S ReqObj=##class(dbo.BDReqForm).%New()
			S ReqObj=ReqObj.%OpenId(ReqId)
			CONTINUE:'$l(ReqObj)
			S AdmNo=ReqObj.AdmNo
			S Name=ReqObj.SurName
			S WardDR=ReqObj.WardDR,(LocationCode,LocationDesc)=""
   			;S LocationCode=$lg($g(^dbo.BTLocationD(LocationDR)),2)
 			;S LocationDesc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
 			;S LocationHIS=$lg($g(^dbo.BTLocationD(LocationDR)),5)
 			
 			CONTINUE:+WardDR=0
 			S WardHIS=$lg($g(^dbo.BTWardD(WardDR)),4)
 			S WardDesc=$lg($g(^dbo.BTWardD(WardDR)),3)
 			CONTINUE:+WardHIS=0
 			S LocationHIS=$p($g(^PAWARD(WardHIS)),"^",5)
 			CONTINUE:+LocationHIS=0
 			
 			S IssueDate=obj.IssueDate
 			I $l(IssueDate) s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
			S IssueTime=obj.IssueTime
			CONTINUE:LocationHIS=""
			i $l(IssueTime) s IssueTime=$zt(IssueTime)
			s IssueDT=IssueDate_" "_IssueTime
			I '$D(^tmpWardData(LocationHIS,IssueRecordDR))
			{
				S ^tmpWardData(LocationHIS)=$I(^tmpWardData(LocationHIS))
				S ^tmpWardData(LocationHIS,IssueRecordDR)=""
			}
		
			s PackDR="" 
			F
			{  
				s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) 
				Q:'$l(PackDR)
				s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
				s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
  				s IsReturned=$lg(IssueRecordItemsData,4)
  				i IsReturned=1 CONTINUE  
  				s PackData=$g(^dbo.BDPackD(PackDR))
				s PackID=$lg(PackData,2)
				s BloodProductDR=$lg(PackData,3)
				s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
				s BloodProductCode=$lg(BloodProductData,2)
				s BloodProductName=$lg(BloodProductData,3)
				s BloodGroupDR=$lg(PackData,9)
				s BDType=$lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
  				s PackSize=$lg(PackData,10)
   				s Units=$lg(BloodProductData,15)
				s PackVolumn=PackSize_Units 
				I $D(^tmpWardData(LocationHIS,IssueRecordDR))
				{
					S ^tmpWardData(LocationHIS,IssueRecordDR)=IssueRecordDR_","_AdmNo_","_Name_","_WardDesc_","_IssueDT_","_BloodProductName
				}
			}
		}
	}
	Q 0
}

/// Creator:lulin
/// Description:查询剂量单位列表
/// Date:2021-07-14
/// Table:User.CTUOM
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensDHCCHISComm","FindUOMList")
Query FindUOMList() As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindUOMListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s rw="" f  s rw=$O(^CT("UOM",rw)) q:rw=""  d
	.s objData=$g(^CT("UOM",rw))
	.q:objData=""
	.s code=$tr($p(objData,"^",1),"'","")
	.s desc=$tr($p(objData,"^",2),"'","")
	.s ret="rw|"_rw_"^code|"_code_"^desc|"_desc
	.d OutputRowsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindUOMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUOMListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindUOMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUOMListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询用法列表
/// Date:2021-07-14
/// Table:User.PHCInstruc
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensDHCCHISComm","FindInstrucList")
Query FindInstrucList() As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInstrucListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s rw="" f  s rw=$O(^PHCIN(rw)) q:rw=""  d
	.s objData=$g(^PHCIN(rw))
	.q:objData=""
	.s code=$p(objData,"^",1)
	.s desc=$p(objData,"^",2)
	.q:desc=""
	.s desc2=$p(objData,"^",3)
	.s ActiveFlag=$P(objData,"^",4)
	.s ActiveFlagDesc="激活"
	.s:ActiveFlag="N" ActiveFlagDesc="未激活"
	.s ret="rw|"_rw_"^code|"_code_"^desc|"_desc_"^desc2|"_desc2_"^ActiveFlag|"_ActiveFlagDesc
	.d OutputRowsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInstrucListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrucListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInstrucListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrucListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询手术列表
/// Date:2021-07-14
/// Table:User.Operation
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensDHCCHISComm","FindOperationList")
Query FindOperationList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOperationListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s input=$zcvt(parr,"U")
	s rw="" f  s rw=$O(^ORC("OPER",rw)) q:rw=""  d
	.s objData=$g(^ORC("OPER",rw))
	.q:objData=""
	.s code=$p(objData,"^",1)
	.s desc=$p(objData,"^",2)
	.s fromDate=$P(objData,"^",5)
	.s toDate=$P(objData,"^",6)
	.s ItmSpell=##class(web.NurSensUtilComm).ToChineseSpell(desc)
	.q:((fromDate'="")&&(fromDate>+$H))
	.q:((toDate'="")&&(toDate<+$H))
	.q:((input'="")&&(($zcvt(code_desc_ItmSpell,"U"))'[input))
	.s ret="RowID|"_rw_"^ItmSpell|"_code_"^ItmDesc|"_desc
	.d OutputRowsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOperationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOperationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取医嘱执行记录信息
/// Date:2020-04-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetANData(date, tmpData) As %String
{
	s argId="" f  s argId=$O(^DHCANOPArrange(0,"SDate",date,argId)) q:argId=""  d
	.s argData=$g(^DHCANOPArrange(argId))
	.q:argData=""
	.s EpisodeID=$P(argData,"^",1)
	.q:EpisodeID=""
	.s papmidr=$P(^PAADM(EpisodeID),"^",1)
 	.q:papmidr=""
 	.s PatName=$P($g(^PAPER(papmidr,"ALL")),"^",1)
 	.q:..IsTextPat(PatName)=1
	.s OPAStartDate=$P(argData,"^",14)
	.s OPAStartTime=$P(argData,"^",15)
	.s OPAEndDate=$P(argData,"^",16)
	.s OPAEndTime=$P(argData,"^",17)
	.s OPAAppDate=$P(argData,"^",3)
	.s OPAAppTime=$P(argData,"^",5)
	.s CTLocID=""
	.s wardId=..getTransWardByDateTime(EpisodeID,OPAStartDate,OPAStartTime)  //根据开始日期、时间获取当时患者所在病区。获取不到获取当前病区
	.s:wardId="" wardId=$P(argData,"^",32)
	.s:wardId="" wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	.s:wardId'="" CTLocID=$p($g(^PAWARD(wardId)),"^",5)   //ctloc病区id
	.s OPAStatus=$P(argData,"^",27)
	.s chl=$P($P(^DHCANOPArrange(argId),"^",2),"||",2)
	.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	..s ANAOPTypeDR=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)     ;ANAOP_Type_DR ；手术ID
	..q:ANAOPTypeDR=""	;手工填写暂时不考虑
	..q:$g(^ORC("OPER",+ANAOPTypeDR))=""
	..s OPERDesc=$P($g(^ORC("OPER",+ANAOPTypeDR)),"^",2)
	..s OPERCode=$P($g(^ORC("OPER",+ANAOPTypeDR)),"^",1)
	..s DataId=EpisodeID_"||"_chl_"||"_subchl
	..s ret="DataId|"_DataId_"^CTLocID|"_CTLocID_"^EpisodeID|"_EpisodeID_"^PatName|"_PatName_"^OPAStartDate|"_OPAStartDate
	..s ret=ret_"^OPAStartTime|"_OPAStartTime_"^OPAEndDate|"_OPAEndDate_"^OPAEndTime|"_OPAEndTime
	..s ret=ret_"^ANAOPTypeDR|"_ANAOPTypeDR_"^OPERDesc|"_OPERDesc_"^OPERCode|"_OPERCode
	..s ret=ret_"^OPAStatus|"_OPAStatus_"^OPAAppDate|"_OPAAppDate_"^OPAAppTime|"_OPAAppTime_"^ArrangeID|"_argId
	..s tmpData(DataId)=ret
}

/// Creator:lulin
/// Description:获取医嘱执行记录信息
/// Date:2020-04-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetEndANOPData(tmpANData, tmpData) As %String
{
	s DataId="" f  s DataId=$O(tmpANData(DataId)) q:DataId=""  d
	.s EpisodeID=$P(DataId,"||",1)
	.s chl=$P(DataId,"||",2)
	.s subchl=$P(DataId,"||",3)
	.s argId=$g(tmpANData(DataId))
	.s argData=$g(^DHCANOPArrange(argId))
	.q:argData=""
	.s papmidr=$P(^PAADM(EpisodeID),"^",1)
 	.q:papmidr=""
 	.s PatName=$P($g(^PAPER(papmidr,"ALL")),"^",1)
	.s OPAStartDate=$P(argData,"^",14)
	.s OPAStartTime=$P(argData,"^",15)
	.s OPAEndDate=$P(argData,"^",16)
	.s OPAEndTime=$P(argData,"^",17)
	.s OPAAppDate=$P(argData,"^",3)
	.s OPAAppTime=$P(argData,"^",5)
	.s CTLocID=""
	.s wardId=..getTransWardByDateTime(EpisodeID,OPAStartDate,OPAStartTime)  //根据开始日期、时间获取当时患者所在病区。获取不到获取当前病区
	.s:wardId="" wardId=$P(argData,"^",32)
	.s:wardId="" wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	.s:wardId'="" CTLocID=$p($g(^PAWARD(wardId)),"^",5)   //ctloc病区id
	.s OPAStatus=$P(argData,"^",27)
	.s chl=$P($P(^DHCANOPArrange(argId),"^",2),"||",2)
	.s ANAOPTypeDR=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)     ;ANAOP_Type_DR ；手术ID
	.q:ANAOPTypeDR=""	;手工填写暂时不考虑
	.q:$g(^ORC("OPER",+ANAOPTypeDR))=""
	.s OPERDesc=$P($g(^ORC("OPER",+ANAOPTypeDR)),"^",2)
	.s OPERCode=$P($g(^ORC("OPER",+ANAOPTypeDR)),"^",1)
	.s DataId=EpisodeID_"||"_chl_"||"_subchl
	.s ret="DataId|"_DataId_"^CTLocID|"_CTLocID_"^EpisodeID|"_EpisodeID_"^PatName|"_PatName_"^OPAStartDate|"_OPAStartDate
	.s ret=ret_"^OPAStartTime|"_OPAStartTime_"^OPAEndDate|"_OPAEndDate_"^OPAEndTime|"_OPAEndTime
	.s ret=ret_"^ANAOPTypeDR|"_ANAOPTypeDR_"^OPERDesc|"_OPERDesc_"^OPERCode|"_OPERCode
	.s ret=ret_"^OPAStatus|"_OPAStatus_"^OPAAppDate|"_OPAAppDate_"^OPAAppTime|"_OPAAppTime
	.s tmpData(DataId)=ret
}

/// Creator:lulin
/// Description:急诊接诊患者数
/// Date:2020-02-20
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetEPatData(date As %String = "") As %String
{
	q:date=""
	s admTime="" f  s admTime=$O(^PAADMi("TypeDate","E",date,admTime)) q:admTime=""  d
	.s EpisodeID="" f  s EpisodeID=$O(^PAADMi("TypeDate","E",date,admTime,EpisodeID)) q:EpisodeID=""  d
	..s CTLocId=$P(^PAADM(EpisodeID),"^",4)
	..q:CTLocId=""
	..s papmidr=$P(^PAADM(EpisodeID),"^",1)
 	..q:papmidr=""
 	..s patname=$P($g(^PAPER(papmidr,"ALL")),"^",1)
	..s ^tmpWardData(CTLocId)=$g(^tmpWardData(CTLocId))+1
	..s ^tmpWardData(CTLocId,EpisodeID)=patname
}

}
