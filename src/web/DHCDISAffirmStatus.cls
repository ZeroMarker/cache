Import SQLUser

Class web.DHCDISAffirmStatus Extends (%RegisteredObject, %XML.Adaptor, ) [ Not ProcedureBlock ]
{

/// Description:获得配送申请列表
/// Creator:     QQA and lvpeng
/// CreateDate:  2017-01-07
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetDisListOrd("06/06/2017^06/06/2017^^^^^","")   
ClassMethod GetDisListOrd(param As %String, PatLoc As %String, AdmNo As %String)
{
	q:param=""
	//s ^lv(11)=param
	s fromDate=$p(param,"^",1)
	s:fromDate'="" fromDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(fromDate) //hxy 2017-03-22 $zdh(fromDate,3)
	s fromTo=$p(param,"^",2)
	s:fromTo'="" fromTo=##class(web.DHCDISCommonDS).DateHtmlToLogical(fromTo) //hxy 2017-03-22 $zdh(fromTo,3)
	s TaskID = $p(param,"^",3)	//任务id
	s regNo = $p(param,"^",4)	//登记号
	s applayLocDr = $p(param,"^",5)	//接收科室
	s disStatus = $p(param,"^",6)	//状态
	s HosNo = $p(param,"^",7)    //住院号
	s count=0
	s jsonStr="mainRowID^newStatus^applyDate^applyTime^currregNo^applayUser^PatAdm^bedNo^endemicArea^taskID^"
	s jsonStr=jsonStr_"acceptLoc^deliveryDate^deliveryTime^deliveryWay^deliveryType^remarkDesc^nullFlag^TypeID^patname^hosno^dispeople"
	s disRowId=""
	f  s disRowId= $o(^DHCDISRE(disRowId),-1)  q:disRowId=""  d  //遍历主表
	.q:disRowId=0
	.s mainRowID=disRowId
	.s disDate=$p(^DHCDISRE(disRowId),"^",13)
	.s applyDate=$p(^DHCDISRE(disRowId),"^",13)	        //申请日期
	.Q:(disDate'="")&(fromDate'="")&(fromDate>disDate) ///过滤开始日期	
	.Q:(disDate'="")&(fromTo'="")&(fromTo<disDate) //过滤结束日期 
	.s:applyDate'="" applyDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(applyDate) //2017-03-22 $zd(applyDate,3)
	.s DateMDay=$p(applyDate,"/",1)
	.s DateMonth=$p(applyDate,"/",2)
	.s applyDate=DateMonth_"/"_DateMDay
	.s applyTime = $p(^DHCDISRE(disRowId),"^",14)       //申请时间
	.;Q:(applyTime'="")&(fromDate>applyTime) ///过滤时间
	.s diswarddr="",disReqLoc="",disWard=""
	.s diswarddr=$p(^DHCDISRE(disRowId),"^",2)
	.s:diswarddr'="" disWard=$p(^PAWARD(diswarddr),"^",2) //申请病区
	.s:diswarddr'="" disReqLoc=$p(^PAWARD(diswarddr),"^",5) //申请科室
	.s:applyTime'="" applyTime=$zt(applyTime,2)
	.s TimeHour=$p(applyTime,":",1)
	.s TimeMunite=$p(applyTime,":",2)
	.s applyTime=TimeHour_":"_TimeMunite
	.s applyDate=applyDate_" "_applyTime   //优化日期时间显示方式  zwq
	.s applayUser = $p(^DHCDISRE(disRowId),"^",15)      //申请人
	.s CurStatus = $p(^DHCDISRE(disRowId),"^",16)	//当前状态
	.s TypeID = $p(^DHCDISRE(disRowId),"^",18)   //任务类型id
	.s nullFlag = $p(^DHCDISRE(disRowId),"^",17)   //空趟标识    zhaowuqiang    2017-03-28
	.i nullFlag = "Y"  s nullFlag="空趟"
	.i nullFlag = "N"  s nullFlag=""
	.s dispeopleid="",dispeople=""
	.f  s dispeopleid=$o(^DHCDISPE(0,"TypePointer",TypeID,disRowId,dispeopleid)) q:dispeopleid=""  d
	..q:dispeopleid=0
	..s dpStatus=$p(^DHCDISPE(dispeopleid),"^",4)
	..q:dpStatus=-1
	..s userdr=$p(^DHCDISPE(dispeopleid),"^",3)
	..s username=""
	..i userdr'=""  d
	...s username=$p(^SSU("SSUSR",userdr),"^",2)
	...i dispeople=""  d
	....s dispeople=username
	...e  d
	....s dispeople=dispeople_","_username
	.;q:(CurStatus'="")&(disStatus'="")&(CurStatus'=disStatus)
	.;s:CurStatus'="" CurStatus=$SELECT(CurStatus=10:"待处理",CurStatus=11:"已安排",CurStatus=12:"接收",CurStatus=13:"验证确认",CurStatus=14:"完成",CurStatus=10:"完成确认",CurStatus=98:"拒绝",CurStatus=99:"未完成")
	.s:applayUser'="" applayUser=$P(^SSU("SSUSR",applayUser),"^",1)  
	.s PatAdm = $p(^DHCDISRE(disRowId),"^",4)	    	//就诊ID
	.q:PatAdm=""
	.q:(AdmNo'="")&&(PatAdm'=AdmNo)
	.s papmi=$p(^PAADM(PatAdm),"^",1)
	.s patname=$p(^PAPER(papmi,"ALL"),"^",1)			//姓名
	.s hosno="",currregNo=""
	.;s:papmi'="" hosno=$p(^PAPER(papmi,"PAT",1),"^",22)  //住院号
	.s hosno=##class(web.DHCDISInterface).GetMrNoByEpisodeID(PatAdm)		//sufan 20200513
	.s:papmi'="" currregNo=$p(^PAPER(papmi,"PAT",1),"^",1)        //登记号
	.q:(regNo'="")&(currregNo'=regNo) 
	.s bedNo = $p(^DHCDISRE(disRowId),"^",3)   	        //床号
	.i bedNo'["||" s bedNo=""
	.i bedNo["||" s bedNo=$p(^PAWARD($p(bedNo,"||",1),"BED",$p(bedNo,"||",2)),"^",1) 
	.s endemicAreadr="",endemicArea="",disReqLoc=""
	.s endemicAreadr = $p(^DHCDISRE(disRowId),"^",2)   	//病区
	.s CtLocDr=$p(^PAWARD(endemicAreadr),"^",5)				/// 所在护理单元		//sufan   2017-12-19 按登录科室过滤
	.q:(PatLoc'="")&&(PatLoc'=CtLocDr)
	.s:endemicAreadr'="" endemicArea=$p(^PAWARD(endemicAreadr),"^",2)
	.s:endemicAreadr'="" disReqLoc=$p(^PAWARD(endemicAreadr),"^",5) //申请科室
	.;q:(applayLocDr'="")&(disReqLoc'="")&(applayLocDr'=disReqLoc)
	.;s:endemicArea["-" endemicArea = $p(endemicArea,"-",2) 
	.s taskID = $p(^DHCDISRE(disRowId),"^",1)           //申请单ID
	.q:(taskID'="")&(TaskID'="")&(taskID'=TaskID)
	.s acceptLoc = $p(^DHCDISRE(disRowId),"^",6)		//接收科室
	.q:(applayLocDr'="")&&(disReqLoc'="")&&(disReqLoc'=applayLocDr)
	.s:acceptLoc'="" acceptLoc=$p(^CTLOC(acceptLoc),"^",2)
	.s:acceptLoc["-" acceptLoc=$p(acceptLoc,"-",2)
	.s deliveryDate = $p(^DHCDISRE(disRowId),"^",7)		//陪送日期
	.s:deliveryDate'="" deliveryDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(deliveryDate) //$zd(deliveryDate,3)
	.s DateDay=$p(deliveryDate,"/",1)
	.s DateMonth=$p(deliveryDate,"/",2)
	.s deliveryDate=DateMonth_"/"_DateDay
	.s deliveryTime = $p(^DHCDISRE(disRowId),"^",8)		//陪送时间
	.s:deliveryTime'="" deliveryTime=$zt(deliveryTime,2)
	.s TimeHour=$p(deliveryTime,":",1)
	.s TimeMunite=$p(deliveryTime,":",2)
	.s:deliveryTime'="" Time=TimeHour_":"_TimeMunite
	.s deliveryTimePoint=$p(^DHCDISRE(disRowId),"^",19) //陪送时间段
	.s deliveryDate=deliveryDate_" "_deliveryTimePoint_" "_deliveryTime
	.s deliveryWay = $p(^DHCDISRE(disRowId),"^",10)     //陪送方式工具
	.s:deliveryWay'="" deliveryWay=$p(^DHCDISTO(deliveryWay),"^",2)
	.s deliveryType = $p(^DHCDISRE(disRowId),"^",9)	    //陪送类型
	.s:deliveryType'="" deliveryType=$p(^DHCDISTY(deliveryType),"^",2)
	.s newStatus=$p(^DHCDISRE(disRowId),"^",16) //陪送状态
	.q:(disStatus'="")&(newStatus'=disStatus)
	.s:newStatus'="" newStatus=$p($g(^DHCDISSA(newStatus)),"^",2)
	.s remarkDesc = $p(^DHCDISRE(disRowId),"^",12)		//备注
	.s count =count+1
	.s tmp = mainRowID_"^"_newStatus_"^"_applyDate_"^"_applyTime_"^"_currregNo_"^"_applayUser_"^"_PatAdm_"^"_bedNo
	.s tmp = tmp_"^"_endemicArea_"^"_taskID_"^"_acceptLoc_"^"_deliveryDate_"^"_deliveryTime
	.s tmp = tmp_"^"_deliveryWay_"^"_deliveryType_"^"_remarkDesc_"^"_nullFlag_"^"_TypeID_"^"_patname_"^"_hosno_"^"_dispeople
	.i count=1 d
	..w "{"
	..w """"_"rows"_""""_":"   //"rows:"
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData(jsonStr,tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(jsonStr,tmp)
	i count=0 d
	.w "{""{""rows"":[],""total"":0}"
	.w """"_"rows"_""""_":"_"["
	w "]"     
	w ","_""""_"total"_""""_":"_""""_count_"""" //,"totle":"1"
	w "}"
	q ""
}

/// Description:获得陪送申请明细列表
/// Creator:     lvpeng
/// CreateDate:  2017-01-23
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetDisListOrdDetail("")  
ClassMethod GetDisListOrdDetail(DisMainRowId As %String) As %String
{
	q:DisMainRowId="" "{""rows"":[],""total"":0}"
	s count=0
	s jsonStr="projectName^toBourn^ReqItemType"
	s REQSub=""
	f  s REQSub=$o(^DHCDISRE(DisMainRowId,"Itm",REQSub)) q:REQSub=""  d
	.s REQItem=$p(^DHCDISRE(DisMainRowId,"Itm",REQSub),"^",1) //项目名称
	.q:REQItem=""
	.s REQExeLocDr=$p(^DHCDISRE(DisMainRowId,"Itm",REQSub),"^",3)
	.s LocDesc=""
	.s:REQExeLocDr'="" LocDesc=$p(^CTLOC(REQExeLocDr),"^",2) //去向科室
	.i LocDesc=""  d
	..s LocDR=$p(^DHCDISRE(DisMainRowId),"^",6)
	..s:LocDR'="" LocDesc=$p(^CTLOC(LocDR),"^",2)
	.;s REQQty=$p(^DHCDISRE(DisMainRowId,"Itm",REQSub),"^",2) //数量
	.s ReqItemType=$p(^DHCDISRE(DisMainRowId,"Itm",REQSub),"^",2) //项目类型
	.q:ReqItemType="" 
	.i ReqItemType="Ord" d
	..s ArcimId1=$p(REQItem,"||",1),ArcimId2=$p(REQItem,"||",2)
	..s arcimId=$p(^OEORD(ArcimId1,"I",ArcimId2,1),"^",2) //医嘱id
	..i arcimId'="" s ArcDesc=$P($G(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
	.e  d
	..;s LIType=$p(^DHCDISLI(REQItem),"^",4)
	..;q:LIType'=0
	..s ArcDesc=$p(^DHCDISLI(REQItem),"^",2)
	.s count =count+1
	.s tmp = ArcDesc_"^"_LocDesc_"^"_ReqItemType
	.i count=1 d
	..w "{"
	..w """"_"rows"_""""_":"
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData(jsonStr,tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(jsonStr,tmp)
	i count=0 d
	.w "{"
	.w """"_"rows"_""""_":"_"["
	w "]" 
	w ","_""""_"total"_""""_":"_""""_count_""""
	w "}"
	q ""
}

/// Description:申请列表插入新状态
/// Creator:     lvpeng
/// CreateDate:  2017-02-06
/// Table: 	DHC_DisRequestSta	 
/// Input:  statuscode:状态描述; mainID:申请id; userid:创建用户id; reason:未完成原因;
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).insetNewStatus("15","21","4","1","")
ClassMethod insetNewStatus(statuscode As %String, mainID As %String, userid As %String, locdr As %String, reason As %String) As %String
{
	n (statuscode ,mainID ,userid ,locdr, reason)
	s ^lv(123)=statuscode_"!!"_mainID_"!!"_userid_"!!"_reason_"!!"_locdr
	q:statuscode="" "插入状态有误"
	s err=0
	;i (statuscode=13)&(statuscode=currstatdr) q "已经验证码确认过该条记录！"
	;i (statuscode=14)&(statuscode=currstatdr) q "该记录状态已置为完成！"
	;i (statuscode=currstatdr) s err="请勿重复操作！"
	s type=0,statusid=""
	s sarowid="" f  s sarowid=$o(^DHCDISSA(0,"TypeCode",type,"Y","Y",statuscode,sarowid)) q:sarowid=""  d
	.q:sarowid=0 //(sarowid="")&(sarowid=0)&(satype'=0)
	.s sacode=$p(^DHCDISSA(sarowid),"^",1) 
	.s saActiveFlag=$p(^DHCDISSA(sarowid),"^",3)
	.s SAMustFlag=$p(^DHCDISSA(sarowid),"^",4)
	.q:(sacode'=statuscode)
	.i (saActiveFlag'="Y") s err="状态未激活"
	.q:(saActiveFlag'="Y")
	.i (SAMustFlag'="Y") s err="未配置工作流"
	.q:(SAMustFlag'="Y")
	.s statusid=sarowid
	s RsRowID=""
	b ;satype11	
	s:+mainID'=0 RsRowID=$o(^DHCDISRS(0,"TypePointer",type,mainID,""),-1) //取最新状态
	;b ;RsRowID
	q:RsRowID="" "申请单没有接收，无法确认！"
	s RsCurStatus=""
	s RsCurStatusid=$p(^DHCDISRS(RsRowID),"^",3)
	s:RsCurStatusid'="" RsCurStatus=$p(^DHCDISSA(RsCurStatusid),"^",1)
	b ;RsCurStatusid
	q:(statuscode=RsCurStatus) "请勿重复操作！"
	s ^lv("qq")=statuscode_"!"_RsCurStatus
	q:(statuscode="13")&(RsCurStatus<12) "申请单没有接收，不能确认验证码！"
	q:(statuscode="15")&(RsCurStatus<14) "申请单没有完成，不能完成确认！" 
	b ;RsCurStatus
	s RsReqType=type
	s RsCurStatus=statuscode
	s ctpcpId=$p(^SSU("SSUSR",userid),"^",14)
	i ctpcpId=""  s err="请以医护人员身份登录后操作!" 
	q:ctpcpId="" 
	s RsCreateUser=userid
	s RsPointer=mainID	 //陪送、配送id
	s RsCreateDate=+$H   				 ///  创建日期
	s RsCreateTime=$p($H,",",2)   	 ///  创建时间
	s Rsreasondr=reason 
	s err=##class(web.DHCDISRequestCom).saveRequestSta(RsPointer,RsReqType,statusid,RsCreateUser,Rsreasondr)
	i err'=0 d
	.s err="保存状态失败！"
	.q:err'=0
	// w ##class(web.DHCDISRequestCom).updateRequestStatus(21,0,37)
	s err=##class(web.DHCDISRequestCom).updateRequestStatus(RsPointer,RsReqType,statusid)
	i err'=0 d
	.s err="更新状态失败！"
	.q:err'=0
	q err
}

/// Description:撤销申请
/// Creator:     lvpeng
/// CreateDate:  2017-02-07
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).CancelApplicaion("31")
ClassMethod CancelApplicaion1(req As %String) As %String
{
   n (req)
   q:req="" "请选择其中一条申请单！"
   TS
   s err=0,ReqType=0
   ;s RsRowID=$o(^DHCDISRS(0,"TypePointer",ReqType,req,""),-1)
   ;b ;RsRowID
   ;s RsCurStatus=""
   ;s:RsRowID'="" RsCurStatus=$p(^DHCDISRS(RsRowID),"^",3)
   ;i (RsCurStatus=10)!(RsCurStatus=98)!(RsCurStatus=99) q "撤销失败！"  
   &sql(delete from DHC_DisRequest where REQ_RowID=:req)
   i SQLCODE'=0  {
	  tro
	  q "撤销申请失败！"
   }
   s RsRowID=""
   s:req'="" RsRowID=$o(^DHCDISRS(0,"TypePointer",ReqType,req,""))
   i RsRowID'="" d 
   .&sql(delete from DHC_DisRequestSta where RS_Pointer=:req and RS_ReqType=:ReqType)
   i SQLCODE'=0  {
	  tro
	  q "撤销状态失败！"
   }
   s reqsub=0
   f  s reqsub=$o(^DHCDISRE(req,"Itm",reqsub)) q:reqsub=""  d
   .s reqi=req_"||"_reqsub
   .&sql(delete from DHC_DisRequestItm where REQ_RowID=:reqi)
   i SQLCODE'=0  tro  q "撤销申请明细失败！"
   TC
   q 0
}

/// Description:撤销申请
/// Creator:     sufan
/// CreateDate:  2017-05-27
/// Table: 		 
/// Input:  	 
/// Return
/// W ##Class(web.DHCDISAffirmStatus).CancelApplicaion("2^100^1^待处理^4636")
ClassMethod CancelApplicaion(params)
{
	n (params)
	s ^tempsufan("11")=params
	s Len=$l(params,"&&")
	s ret=0
	//s $Zt="Err"
	TS
	for i=1:1:Len d
	.s TempData=$p(params,"&&",i)
	.s disreqID=$p(TempData,"^",1)
	.s statuscode=$p(TempData,"^",2)
	.s type=$p(TempData,"^",3)
	.s Status=$p(TempData,"^",4)
	.s lgUser=$p(TempData,"^",5)
	.s ret=..UpdateRepStatus(disreqID,statuscode,type,lgUser)
	.Q:ret'=0 
	i ret'=0 TRO
	TC
	q ret
Err
	TRO
	q -4
}

ClassMethod UpdateRepStatus(disreqID, statuscode, type, lgUser)
{
	n (disreqID, statuscode, type, lgUser)
	s ret=0
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)    //获取下个流程状态
	i status="" s ret=-1 q ret
	&sql(update DHC_DisRequest set REQ_CurStatus=:status where REQ_RowID=:disreqID)  //更新申请单状态
	i SQLCODE'=0  s ret=-2  q ret
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(disreqID,type,status,lgUser)  //保存操作流水表
	i ret'=0  s ret=-3 q ret
	q ret
}

/*
/// Description:获得申请科室列表(BootStrap)
/// Creator:     QQA
/// CreateDate:  2017-01-05
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetApplayLoc("2")   
ClassMethod GetApplayLoc(HospID As %String, search As %String)
{
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.q:(search'="")&(LocDesc'[$$ALPHAUP^SSUTIL4(search))
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}
*/
/// Description:科室列表下拉
/// Creator:     lvpeng
/// CreateDate:  2017-01-23
/// Table: 		 
/// Input:  	 HospID
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetApplayLoc("2")   
ClassMethod GetApplayLoc(HospID As %String)
{
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.;s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description: 任务id下拉列表
/// Creator:     zhaowuqiang
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).TaskId()   
ClassMethod TaskId()
{
	s Count=0
	s Id=0
	f  s Id = $o(^DHCDISGRE(Id)) q:Id=""  d
	.s TaskId=$p(^DHCDISGRE(Id),"^",1)
	.s Count=Count+1
	.s tmp = TaskId_"^"_TaskId
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description:获得陪送申请状态
/// Creator:     lvpeng
/// CreateDate:  2017-01-05
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetAffirmStatus()   
ClassMethod GetAffirmStatus()
{
	
	/*
	s satype=0,count=0
	s sacode=""
	f  s sacode=$o(^DHCDISSA("0","TypeCode",satype,"Y","Y",sacode)) q:sacode=""  d
	.s sarowid=$o(^DHCDISSA("0","TypeCode",satype,"Y","Y",sacode,""))
	.;b ;sarowid
	.q:sarowid="" 
	.s sadesc=$p($g(^DHCDISSA(sarowid)),"^",2)
	.s count=count+1
	.i count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",sacode_"^"_sadesc)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",sacode_"^"_sadesc)
	w "]"
	q ""
	*/
	
	w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text","10^待处理")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","11^已安排")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","12^接收")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","13^验证确认")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","14^完成")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","15^完成确认")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","98^拒绝")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","99^未完成")
	w "]"
	q ""
}

/// Description:初始化加载数据
/// Creator:     QQA
/// CreateDate:  2017-01-05
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).GetParamByInit()   
ClassMethod GetParamByInit()
{
	s regNoLen = ##class(web.DHCDISAffirmStatus).GetPatConfig()  //获取登记号长度
	s tmp = regNoLen
	w ##class(web.DHCAPPJsonCommon).getJsonData("regNoLen",tmp)
	q ""
}

/// Description:获取登记号长度
ClassMethod GetPatConfig() As %String
{
    s patcfId=$o(^CF("PATCF",""))
    i patcfId="" q "8^"
    s patcfIpNoLength=$p($g(^CF("PATCF",patcfId,3)),"^",5)
    i patcfIpNoLength<8 s patcfIpNoLength=8
	q patcfIpNoLength_"^"
}

/// Description:通过就诊ID获取登记号
ClassMethod GetRegNoByAdm(PatAdm As %String)
{
	
	s RegNo=""
	s patDr = $p(^PAADM(PatAdm),"^",1)
	s RegNo = $p(^PAPER(patDr,"PAT",1),"^",1)
	q RegNo
}

/// Description:通过主表ID获取当前陪送状态
/// w ##class(web.DHCDISAffirmStatus).GetNowStatusByMainID("14")
ClassMethod GetNowStatusByMainID(disID As %String)
{
	
	q:disID="" ""
	s ReqType=0
	s RsRowID=$o(^DHCDISRS(0,"TypePointer",ReqType,disID,""),-1)
	q:RsRowID="" ""
	s RsCurStatuscode=$p(^DHCDISRS(RsRowID),"^",3)
	;s status = $p(^DHCDISRE(disID,"RS",disRsSub),"^",4)   //状态
	;s RsCurStatus=$s(RsCurStatus=10:"待处理",RsCurStatus=11:"已安排",RsCurStatus=12:"接收",RsCurStatus=13:"验证确认",RsCurStatus=14:"完成",RsCurStatus=10:"完成确认",RsCurStatus=98:"拒绝",RsCurStatus=99:"未完成",nowStatus="":"")
	;s status=$s(status=13:"完成",status=98:"拒绝",status=99:"未完成",nowStatus="":"")
	q RsCurStatuscode
}

/// Description:判断状态是或否可用
/// table:DHC_DisStatusAdd
/// Input:code（状态代码）
/// w ##class(web.DHCDISAffirmStatus).IfCodeStatusUsable()
ClassMethod IfCodeStatusUsable(code As %String, locdr As %String) As %String
{
	n (code,locdr)
	q:code="" 0	
	s flag=""
	s sarowid="0",sa=""
	f  s sarowid=$o(^DHCDISSA(sarowid)) q:sarowid=""  d
	.s sacode=$p(^DHCDISSA(sarowid),"^",1)
	.i sacode'=code s flag=1
	.q:(sacode'=code)
	.s saactiveflag=$p(^DHCDISSA(sarowid),"^",3)
	.s samustmlag=$p(^DHCDISSA(sarowid),"^",4)
	.q:(saactiveflag'="Y")
}

/// Description: 陪送申请设置空趟标识
/// Creator:     zhaowuqiang
/// CreatDate:   2017-03-28
/// Table:       DHC_DisNodeLoc
/// Input:       验证码
/// Output:      SQLCODE
/// Other:       w ##class(web.DHCDISAffirmStatus).SetNullFlag("YWAkPRI=")
ClassMethod SetNullFlag(param)
{
	n (param)
	
	TS
	s ret=0
	s ReqNo=param
	s ReqID=""
	f  s ReqID=$o(^DHCDISRE(ReqID)) q:(ReqID="")||(ret'=0)  d
	.q:ReqID=0
	.s VerCode=$p(^DHCDISRE(ReqID),"^",1)
	.q:VerCode'=ReqNo
	.s NullFlag=$p(^DHCDISRE(ReqID),"^",17)
	.i NullFlag="" d
	..s NullFlag="Y"
	.e  i NullFlag="Y" d
	..s NullFlag="N"
	.e  d
	..s NullFlag="Y"
	.&sql(update DHC_DisRequest set REQ_NullFlag=:NullFlag where REQ_RowID=:ReqID)
	.s ret=SQLCODE
	i ret'=0 TRO
	e  TC
	
	q ret
}

/// Description: 复制陪送申请
/// Creator:     zhaowuqiang
/// CreatDate:   2017-03-29
/// Input:       验证码
/// Output:      SQLCODE
/// Other:       w ##class(web.DHCDISAffirmStatus).RequestCopy("30","^02/11/2018  晚上^3^2^1^^197^4636")
ClassMethod RequestCopy(reqID, copyStr)
{
	n (reqID,copyStr,%session)
	//s ^tempsufan(11)=$lb(reqID,copyStr)
	s ReqString=..GetReqStr(reqID,copyStr)                 //陪送申请主表数据
	s ReqItemString=..GetReqItmStr(reqID)          //陪送项目数据
	s err=##class(web.DHCDISRequest).Save(ReqString,ReqItemString)
	
	q err
}

/// Other:       w ##class(web.DHCDISAffirmStatus).GetReqStr("11","")
ClassMethod GetReqStr(reqID, copyStr)
{
	n (reqID,copyStr)
	
	s REQNo=$p(^DHCDISRE(reqID),"^",1)        /// 申请单号/ID
	s REQWardDr=$p(^DHCDISRE(reqID),"^",2)    /// 申请病区
	s REQWardBedDr=$p(^DHCDISRE(reqID),"^",3) /// 病人床号
	s REQAdm=$p(^DHCDISRE(reqID),"^",4)       /// 病人就诊id
	s REQPapmiDr=$p(^DHCDISRE(reqID),"^",5)   /// 病人id
	//s REQRecLocDr=$p(^DHCDISRE(reqID),"^",6)  /// 接收科室
	s HospID=$p(^DHCDISRE(reqID),"^",20)        /// 医院ID
	s ReqStr=REQNo_"^"_REQWardDr_"^"_REQWardBedDr_"^"_REQAdm_"^"_REQPapmiDr_"^"_copyStr_"^"_HospID
	
	q ReqStr
}

/// Other:       w ##class(web.DHCDISAffirmStatus).GetReqItmStr("176")
ClassMethod GetReqItmStr(reqID)
{
	n (reqID)
	
	s ItmStrs=""
	s ItmChildSub="",ItmStrs=""
	f  s ItmChildSub=$o(^DHCDISRE(reqID,"Itm",ItmChildSub)) q:ItmChildSub=""  d
	.s REQItem=$p(^DHCDISRE(reqID,"Itm",ItmChildSub),"^",1)
	.s REQItemType=$p(^DHCDISRE(reqID,"Itm",ItmChildSub),"^",2)
	.s REQExeLocDr=$p(^DHCDISRE(reqID,"Itm",ItmChildSub),"^",3)
	.s ItmStr=REQItem_"^"_REQItemType_"^"_REQExeLocDr
	.i ItmStrs=""  d
	..s ItmStrs=ItmStr_"$$"
	.e  d
	..s ItmStrs=ItmStrs_ItmStr_"$$"
	
	q ItmStrs
}

/// Descrition:  插入陪送申请主表
/// Creator:     zhaowuqiang
/// CreatDate:   2017-03-29
/// Table:       DHC_DisRequest
/// Input:       验证码
/// Output:      SQLCODE
/// w ##class(web.DHCDISAffirmStatus).InsRequest("606748","24/05/2017 17:41")
ClassMethod InsRequest(param, addDateTime)
{
	n (param,addDateTime)
	s reDate=""
	s reTime=""
	i addTime'="" d
	.s reDate=$p(addDateTime," ",1)
	.s reTime=$p(addDateTime," ",2)
	.s reDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(reDate)
	.s reTime=$zth(reTime,1)
	s ReqNo=param
	s RowID=""
	s Flag=0   //设置标识,让其只复制一次
	s ret=0
	s id=""
	f  s id=$o(^DHCDISRE(id)) q:(id="")||(Flag=1)  d
	.q:id=0
	.s VerCode=$p(^DHCDISRE(id),"^",1)
	.q:VerCode'=ReqNo
	.s VerCode=##class(web.DHCDISRequest).getVerfiyCode()  //获取验证码
	.;s Len=$l(VerCode)
	.;s VerCode=$e(VerCode,2,Len-1)
	.s ReqID=id
	.s Flag=1
	.s REQWardDr=$p(^DHCDISRE(id),"^",2)
	.s REQWardBedDr=$p(^DHCDISRE(id),"^",3)
	.s REQAdm=$p(^DHCDISRE(id),"^",4)
	.s REQPapmiDr=$p(^DHCDISRE(id),"^",5)
	.s REQRecLocDr=$p(^DHCDISRE(id),"^",6)
	.i reDate'=""  d
	..s REQExeDate=reDate 
	.e  d
	..s REQExeDate=$p($h,",",1)
	.i reTime'="" d
	..s REQExeTime=reTime
	.e  d
	..s REQCreateTime=$p($h,",",2)
	.;s REQExeDate=$p($h,",",1)
	.;s REQExeTime=$p($h,",",2)
	.s REQEscortTypeDr=$p(^DHCDISRE(id),"^",9)
	.s REQEscortToolDr=$p(^DHCDISRE(id),"^",10)
	.s REQNums=$p(^DHCDISRE(id),"^",11)
	.s REQRemarks=$p(^DHCDISRE(id),"^",12)
	.s REQCreateDate=$p($h,",",1)
	.s REQCreateTime=$p($h,",",2)
	.s REQCreateUser=$p(^DHCDISRE(id),"^",15)
	.s REQCurStatus=27
	.;s REQCurStatus=$p(^DHCDISRE(id),"^",16)
	.;s REQNullFlag=$p(^DHCDISRE(ReqID),"^",17)
	.&sql(insert into DHC_DisRequest (REQ_No,REQ_Ward_Dr,REQ_WardBed_Dr,REQ_Adm,REQ_Papmi_Dr,REQ_RecLoc_Dr,REQ_ExeDate,REQ_ExeTime,
	      REQ_EscortType_Dr,REQ_EscortTool_Dr,REQ_Nums,REQ_Remarks,REQ_CreateDate,REQ_CreateTime,REQ_CreateUser,REQ_CurStatus)
	      values (:VerCode,:REQWardDr,:REQWardBedDr,:REQAdm,:REQPapmiDr,:REQRecLocDr,:REQExeDate,:REQExeTime,:REQEscortTypeDr,
	      :REQEscortToolDr,:REQNums,:REQRemarks,:REQCreateDate,:REQCreateTime,:REQCreateUser,:REQCurStatus))
	.s RowID =%ROWID
	.s ret=SQLCODE
	
	q ret_"^"_ReqID_"^"_RowID
}

/// Descrition:  插入陪送项目表
/// Creator:     zhaowuqiang
/// CreatDate:   2017-03-29
/// Table:       DHC_DisRequestItm
/// Input:       复制源ID、已复制ID
/// Output:      0
/// Other:       w ##class(web.DHCDISAffirmStatus).InsRequestItm("130","139")
ClassMethod InsRequestItm(ReqID, RowID)
{
	n (ReqID,RowID)
	
	s ret=0
	s childsub=""
	f  s childsub=$o(^DHCDISRE(ReqID,"Itm",childsub)) q:(childsub="")||(ret'=0)  d
	.s REQItem=$p(^DHCDISRE(ReqID,"Itm",childsub),"^",1)
	.s REQItemType=$p(^DHCDISRE(ReqID,"Itm",childsub),"^",2)
	.s REQExeLocDr=$p(^DHCDISRE(ReqID,"Itm",childsub),"^",3)
	.s subID=$o(^DHCDISRE(RowID,"Itm",""),-1)+1
	.&sql(insert into DHC_DisRequestItm (REQ_ParRef_Dr,REQ_ChildSub,REQ_Item,REQ_ItemType,REQ_ExeLoc_Dr) values 
	     (:RowID,:subID,:REQItem,:REQItemType,:REQExeLocDr))
	.s ret=SQLCODE
	
	q ret
}

/// Descrition:  插入陪送人员表
/// Creator:     zhaowuqiang
/// CreatDate:   2017-03-29
/// Table:       DHC_DisPeople
/// Input:       复制源ID、已复制ID
/// Output:      0
/// w ##class(web.DHCDISAffirmStatus).InsDisPeople("130","139")
ClassMethod InsDisPeople(ReqID, RowID)
{
	n (ReqID, RowID)
	
	s ret=0
	s Type=0
	s PeopleID=""
	f  s PeopleID=$o(^DHCDISPE(0,"TypePointer",0,ReqID,PeopleID)) q:(PeopleID="")||(ret'=0)  d
	.q:PeopleID=0
	.s DPUserDr=$p(^DHCDISPE(PeopleID),"^",3)
	.&sql(insert into DHC_DisPeople (DP_ReqType,DP_Pointer,DP_User_Dr) values (:Type,:RowID,:DPUserDr))
	.s ret=SQLCODE
	
	q ret
}

/// w ##class(web.DHCDISAffirmStatus).GetDisTypeCombobox()
ClassMethod GetDisTypeCombobox()
{
	s Count=0
	w "["
	s TypeID=""
	f  s TypeID=$o(^DHCDISTA(TypeID)) q:TypeID=""  d
	.q:TypeID=0
	.s TypeDesc=$p(^DHCDISTA(TypeID),"^",2)
	.q:TypeDesc="陪送"
	.s ActiveFlag=$p(^DHCDISTA(TypeID),"^",3)
	.q:ActiveFlag'="Y"
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",TypeID_"^"_TypeDesc)
	w "]"
	q ""
}

/// Description:获得陪送未完成原因
/// Creator:     yuliping
/// CreateDate:  2017-05-04
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAffirmStatus).getFailReason()   
ClassMethod getFailReason()
{
	s Count=0
	s Id=""
	f  s Id = $o(^DHCDISFR(Id)) q:Id=""  d
	.q:Id=0
	.s code=$p(^DHCDISFR(Id),"^",2)
	
	.s Count=Count+1
	.s tmp = Id_"^"_code
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 复制陪送申请时获取原申请单信息
/// Creator:     zwq
/// CreateDate:  2017-06-02
/// Table: 		 DHC_DisRequest 
/// Input:       申请单ID
/// Output:      接收科室^陪送方式^陪送类型^备注
/// W ##Class(web.DHCDISAffirmStatus).GetReqMessage("181") 
ClassMethod GetReqMessage(ReqID)
{
	n (ReqID)

	s CopyReqRecLoc=$p(^DHCDISRE(ReqID),"^",6)
	s CopyReqWay=$p(^DHCDISRE(ReqID),"^",10)
	s CopyReqType=$p(^DHCDISRE(ReqID),"^",9)
	s CopyReqMark=$p(^DHCDISRE(ReqID),"^",12)
	s CopyMessage=CopyReqRecLoc_"^"_CopyReqWay_"^"_CopyReqType_"^"_CopyReqMark
	
	q CopyMessage
}

/// Description: 陪送申请量查询
/// Creator:     zhaowuqiang
/// Creatdate:   2017-09-25
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室^项目
/// Output:      本院人次^外院人次^本院项目数^外院项目数^人次合计^项目合计
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISAffirmStatus","QueryEscortWorkByPeople","2017-01-25","2017-10-25")
Query QueryEscortWorkByPeople(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "EscortPeople:%String,ThisPeopleNum:%Integer,OtherPeopleNum:%Integer,ThisHosItemNum:%Integer,OtherHosItemNum:%Integer,PeopleNum:%Integer,ItemNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryEscortWorkByPeopleExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	N (qHandle,StDate,EndDate)
	s HosDr=2
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s tid=$I(^TMP) //相当于一个计数器            根据陪送安排统计陪送量
	s StDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate)
	f dd=StDate:1:EndDate d
	.s ReqID=""
	.f  s ReqID=$o(^DHCDISRE(0,"CreateDate",dd,ReqID)) q:ReqID=""  d
	..q:+ReqID=0
	..s DisTypeAddDr=$p(^DHCDISRE(ReqID),"^",18)    //陪送类型
	..s CurStatusDr=$p(^DHCDISRE(ReqID),"^",16)
	..s:CurStatusDr'="" CurStatusCode=$p(^DHCDISSA(CurStatusDr),"^",1)
	..s:CurStatusDr'="" CurStatus=$p(^DHCDISSA(CurStatusDr),"^",2)    //申请单当前状态
	..q:(CurStatus'="完成确认")&(CurStatus'="空趟")
	..s ThisHosItemNum=0     //本院项目数
	..s OtherHosItemNum=0    //外院项目数
	..s ThisPeopleNum=0      //本院人次
	..s OtherPeopleNum=0     //外院人次
	..s ItemNum=0            //项目合计
	..s PeopleNum=0          //人次合计
	..s ItemSub="",HosID="",ItemType=""
	..f  s ItemSub=$o(^DHCDISRE(ReqID,"Itm",ItemSub)) q:ItemSub=""  d
	...s ItemID=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",1)
	...s ItemType=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",2)
	...i ItemType="Oth" d
	....s HosID=$p(^DHCDISLI(ItemID),"^",6)
	....s:HosID=HosDr ThisHosItemNum=ThisHosItemNum+1    //增加本院项目数
	....s:HosID'=HosDr OtherHosItemNum=OtherHosItemNum+1 //增加外院项目数
	...e  d
	....s ThisHosItemNum=ThisHosItemNum+1
	..i ItemType="Oth" d
	...s:HosID=HosDr ThisPeopleNum=ThisPeopleNum+1       //增加本院人数
	...s:HosID'=HosDr OtherPeopleNum=OtherPeopleNum+1    //增加外院人数
	..e  d
	...s ThisPeopleNum=ThisPeopleNum+1
	..s ItemNum=ThisHosItemNum+OtherHosItemNum            //人次合计
	..s PeopleNum=ThisPeopleNum+OtherPeopleNum            //项目数合计
	..s DPRowid="",EscortPeople=""
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",DisTypeAddDr,ReqID,DPRowid)) q:DPRowid=""  d
	...q:+DPRowid=0
	...s DPUserStatus=$p(^DHCDISPE(DPRowid),"^",4)
	...q:DPUserStatus=-1   //过滤掉撤销安排的人员
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s:DPUserDr'="" EscortPeople=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	..s ListData=EscortPeople_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum
	..i '$d(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople))  d
	...s ^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople)=ListData
	..e  d
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",2)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",2)+$p(ListData,"^",2)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",3)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",3)+$p(ListData,"^",3)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",4)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",4)+$p(ListData,"^",4)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",5)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",5)+$p(ListData,"^",5)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",6)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",6)+$p(ListData,"^",6)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",7)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",7)+$p(ListData,"^",7)
	s People=""
	f  s People=$o(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People)) q:People=""  d
	.s EscortPeople=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",1)
	.s ThisPeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",2)
	.s OtherPeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",3)
	.s ThisHosItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",4)
	.s OtherHosItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",5)
	.s PeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",6)
	.s ItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",7)
	
	.s data = $lb(EscortPeople,ThisPeopleNum,OtherPeopleNum,ThisHosItemNum,OtherHosItemNum,PeopleNum,ItemNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod QueryEscortWorkByPeopleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEscortWorkByPeopleExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryEscortWorkByPeopleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEscortWorkByPeopleExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Creator :  sufan
/// CreatDate: 2017-12-21
/// Descript:  已开申请单列表
/// W ##Class(web.DHCDISAffirmStatus).GetDisListOrdEscort("100","1","2020-05-07^2020-05-07^^^^1^")
ClassMethod GetDisListOrdEscort(rows As %String, page As %String, param As %String = "", PatLoc As %String = "", AdmNo As %String = "", HospID As %String = "") As %String
{
	n (rows, page, param,PatLoc,AdmNo,HospID)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    k ^TMP("DHCDIS","web.DHCDISAffirmStatus","GetDisListOrdEscort",pid)
    q:param="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
    i (PatLoc'="")&&($p(^CTLOC(PatLoc),"^",2)["陪送中心") s PatLoc=""    ///sufan 2018-01-05
	s fromDate=$p(param,"^",1)
	s:fromDate'="" fromDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(fromDate) //hxy 2017-03-22 $zdh(fromDate,3)
	s fromTo=$p(param,"^",2)
	s:fromTo'="" fromTo=##class(web.DHCDISCommonDS).DateHtmlToLogical(fromTo) //hxy 2017-03-22 $zdh(fromTo,3)
	s TaskID = $p(param,"^",3)			//任务id
	s regNo = $p(param,"^",4)			//登记号
	s applayLocDr = $p(param,"^",5)		//接收科室
	s disStatus = $p(param,"^",6)		//状态
	s HosNo = $p(param,"^",7)    		//住院号
	s EscNurs = $p(param,"^",8)    		//护工ID
	s Num=0,count=0
	f date=fromDate:1:fromTo  d
	.s disRowId=""
	.f  s disRowId= $o(^DHCDISRE("0","CreateDate",date,disRowId),-1)  q:disRowId=""  d  	//遍历主表
	..q:disRowId=0
	..s mainRowID=disRowId
	..s disDate=$p(^DHCDISRE(disRowId),"^",13)
	..s applyDate=$p(^DHCDISRE(disRowId),"^",13)	        			//申请日期
	..s:applyDate'="" applyDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(applyDate) //2017-03-22 $zd(applyDate,3)
	..s applyTime = $p(^DHCDISRE(disRowId),"^",14)       	//申请时间
	..s diswarddr="",disReqLoc="",disWard=""
	..s diswarddr=$p(^DHCDISRE(disRowId),"^",2)
	..s:diswarddr'="" disWard=$p(^PAWARD(diswarddr),"^",2) 	//申请病区
	..s:diswarddr'="" disReqLoc=$p(^PAWARD(diswarddr),"^",5) //申请科室
	..s:applyTime'="" applyTime=$zt(applyTime,2)
	..s TimeHour=$p(applyTime,":",1)
	..s TimeMunite=$p(applyTime,":",2)
	..s applyTime=TimeHour_":"_TimeMunite
	..s applyDate=applyDate_" "_applyTime   					//优化日期时间显示方式  zwq
	..s applayUser = $p(^DHCDISRE(disRowId),"^",15)      	//申请人
	..s CurStatus = $p(^DHCDISRE(disRowId),"^",16)			//当前状态
	..s TypeID = $p(^DHCDISRE(disRowId),"^",18)  			//任务类型id
	..s nullFlag = $p(^DHCDISRE(disRowId),"^",17)   			//空趟标识    zhaowuqiang    2017-03-28
	..i nullFlag = "Y"  s nullFlag="空趟"
	..i nullFlag = "N"  s nullFlag=""
	..s:applayUser'="" applayUser=$P(^SSU("SSUSR",applayUser),"^",1)  
	..s PatAdm = $p(^DHCDISRE(disRowId),"^",4)	    		//就诊ID
	..q:PatAdm=""
	..q:(AdmNo'="")&&(PatAdm'=AdmNo)
	..s papmi=$p(^PAADM(PatAdm),"^",1)
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)				//姓名
	..s hosno="",currregNo=""
	..;s:papmi'="" hosno=$p(^PAPER(papmi,"PAT",1),"^",22)  	//住院号
	..s hosno=##class(web.DHCDISInterface).GetMrNoByEpisodeID(PatAdm)	//sufan 20200507
	..s:papmi'="" currregNo=$p(^PAPER(papmi,"PAT",1),"^",1)  //登记号
	..q:(regNo'="")&(currregNo'=regNo) 
	..s bedNo=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(PatAdm)
	..s endemicAreadr="",endemicArea="",disReqLoc=""
	..s endemicAreadr = $p(^DHCDISRE(disRowId),"^",2)   		//病区
	..s CtLocDr=""
	..i endemicAreadr'="" s CtLocDr=$p(^PAWARD(endemicAreadr),"^",5)				//所在护理单元		//sufan   2017-12-19 按登录科室过滤
	..q:(PatLoc'="")&&(PatLoc'=CtLocDr)
	..s:endemicAreadr'="" endemicArea=$p(^PAWARD(endemicAreadr),"^",2)
	..s:endemicAreadr'="" disReqLoc=$p(^PAWARD(endemicAreadr),"^",5) //申请科室
	..s taskID = $p(^DHCDISRE(disRowId),"^",1)           //申请单ID
	..q:(taskID'="")&(TaskID'="")&(taskID'=TaskID)
	..s acceptLoc = $p(^DHCDISRE(disRowId),"^",6)		//接收科室
	..q:(applayLocDr'="")&&(disReqLoc'="")&&(disReqLoc'=applayLocDr)
	..s:acceptLoc'="" acceptLoc=$p(^CTLOC(acceptLoc),"^",2)
	..s:acceptLoc["-" acceptLoc=$p(acceptLoc,"-",2)
	..s deliveryDate = $p(^DHCDISRE(disRowId),"^",7)		//陪送日期
	..s:deliveryDate'="" deliveryDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(deliveryDate) //$zd(deliveryDate,3)
	..s deliveryTime = $p(^DHCDISRE(disRowId),"^",8)		//陪送时间
	..s:deliveryTime'="" deliveryTime=$zt(deliveryTime,2)
	..s TimeHour=$p(deliveryTime,":",1)
	..s TimeMunite=$p(deliveryTime,":",2)
	..s:deliveryTime'="" Time=TimeHour_":"_TimeMunite
	..s deliveryTimePoint=$p(^DHCDISRE(disRowId),"^",19) 	//陪送时间段
	..s deliveryDate=deliveryDate_" "_deliveryTimePoint_" "_deliveryTime
	..s deliveryWay = $p(^DHCDISRE(disRowId),"^",10)     	//陪送方式工具
	..s:deliveryWay'="" deliveryWay=$p(^DHCDISTO(deliveryWay),"^",2)
	..s deliveryType = $p(^DHCDISRE(disRowId),"^",9)	    //陪送类型
	..s:deliveryType'="" deliveryType=$p($g(^DHCDISTY(deliveryType)),"^",2)
	..s newStatus=$p(^DHCDISRE(disRowId),"^",16) 			//陪送状态
	..q:((disStatus'="")&(disStatus'="0"))&(newStatus'=disStatus)
	..s:newStatus'="" newStatus=$p($g(^DHCDISSA(newStatus)),"^",2)
	..s remarkDesc = $p(^DHCDISRE(disRowId),"^",12)			//备注
	..s ConfirRowID="",ConfirUser="",ConfirDate=""
	..f  s ConfirRowID=$O(^DHCDISRS(0,"TypePointer",TypeID,disRowId,ConfirRowID))  q:ConfirRowID=""  d
	...s status=$p(^DHCDISRS(ConfirRowID),"^",3)
	...s statuscode=$p(^DHCDISSA(status),"^",1)
	...q:(statuscode'="13")&&(statuscode'="14")
	...s ConfirDate = $p(^DHCDISRS(ConfirRowID),"^",4)		///陪送确认时间
	...s:ConfirDate'="" ConfirDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(ConfirDate)
	...s ConfirUserID=$p(^DHCDISRS(ConfirRowID),"^",6)
	...s ConfirUser=""
	...s:ConfirUserID'="" ConfirUser=$p(^SSU("SSUSR",ConfirUserID),"^",2)   ///确认人
	..s dispeopleid="",dispeople="",userdr=""
	..f  s dispeopleid=$o(^DHCDISPE(0,"TypePointer",TypeID,disRowId,dispeopleid)) q:dispeopleid=""  d
	...q:dispeopleid=0
	...s dpStatus=$p(^DHCDISPE(dispeopleid),"^",4)
	...q:dpStatus=-1
	...s userdr=$p(^DHCDISPE(dispeopleid),"^",3)
	...s dispeople=$p(^SSU("SSUSR",userdr),"^",2)
	..q:(EscNurs'="")&&(userdr'=EscNurs)
	..s AsseId=$o(^DHCDISRA(0,"TypePointer",TypeID,mainRowID,""))
	..s AssNumber=""
	..s AssRemarks=""
	..i AsseId'="" s AssNumber=$p(^DHCDISRA(AsseId),"^",3)
	..i AsseId'="" s AssRemarks=$p(^DHCDISRA(AsseId),"^",4)
	..s ReqHospID=$p(^DHCDISRE(disRowId),"^",20)
	..q:(HospID'="")&&(ReqHospID'=HospID)
	..s ListData = mainRowID_"^"_newStatus_"^"_applyDate_"^"_applyTime_"^"_currregNo_"^"_applayUser_"^"_PatAdm_"^"_bedNo
	..s ListData = ListData_"^"_endemicArea_"^"_taskID_"^"_acceptLoc_"^"_deliveryDate_"^"_deliveryTime
	..s ListData = ListData_"^"_deliveryWay_"^"_deliveryType_"^"_remarkDesc_"^"_nullFlag_"^"_TypeID_"^"_patname_"^"_hosno_"^"_dispeople_"^"_ConfirDate_"^"_ConfirUser
	..s ListData = ListData_"^"_AssNumber_"^"_AssRemarks
	..s Num=Num+1
	..s ^TMP("DHCDIS","web.DHCDISAffirmStatus","GetDisListOrdEscort",pid,Num)=ListData
	.
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="mainRowID^newStatus^applyDate^applyTime^currregNo^applayUser^PatAdm^bedNo^endemicArea^taskID"
	s ListTitle=ListTitle_"^acceptLoc^deliveryDate^deliveryTime^deliveryWay^deliveryType^remarkDesc^nullFlag^TypeID^patname^hosno^dispeople^ConfirDate^ConfirUser"
	s ListTitle=ListTitle_"^AssNumber^AssRemarks"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISAffirmStatus","GetDisListOrdEscort",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCDIS","web.DHCDISAffirmStatus","GetDisListOrdEscort",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	k ^TMP("DHCDIS","web.DHCDISAffirmStatus","GetDisListOrdEscort",pid)
	q ""
}

/// w ##class(web.DHCDISAffirmStatus).CancelApplicaionArray()
ClassMethod CancelApplicaionArray(ReqIDStr, ReqTypeStr, StatusCode, LgUser)
{
	n (ReqIDStr,ReqTypeStr,StatusCode,LgUser)
	s ^tempsufan("LgUser")=$lb(ReqIDStr,ReqTypeStr,StatusCode,LgUser)
	ts
	s ErrFlag=""
	s Len = $l(ReqIDStr,",")	
	f I=1:1:Len q:ErrFlag'=""  d
	.s ReqID = $p(ReqIDStr,",",I)
	.s ReqType = $p(ReqTypeStr,",",I)
	.s Rs = ##class(web.DHCDISAffirmStatus).CancelApplicaionNew(ReqID,ReqType,StatusCode,LgUser)
	.s:Rs'=0 ErrFlag=1
	i ErrFlag'="" tro
	i ErrFlag="" tc
	q Rs
}

/// Description:撤销申请
/// Creator:     zwq
/// CreateDate:  2017-05-27
/// Table: 		 
/// Input:  	 
/// Return
/// W ##Class(web.DHCDISAffirmStatus).CancelApplicaion("149","100","18","575")
ClassMethod CancelApplicaionNew(disreqID, type, statuscode, lgUser)
{
	n (disreqID, statuscode, type, lgUser)
	
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	i status="" tro  q "获取下个流程状态失败"
	&sql(update DHC_DisRequest set REQ_CurStatus=:status where REQ_RowID=:disreqID)
	i SQLCODE'=0 tro  q "更新申请单状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(disreqID,type,status,lgUser)
	i ret'=0 tro  q "保存操作流水表失败"
	
	s ret=##class(web.DHCDISRequestCom).updWorkLoad(disreqID,type,status)
	i ret'=0 tro  q "更新护工工作量失败"
	q 0
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	//Q $I(^DHCAPP("APPExaReportQuery"))
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

}
