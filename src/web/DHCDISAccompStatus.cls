Import SQLUser

Class web.DHCDISAccompStatus Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:申请列表插入新状态
/// Creator:     lvpeng
/// CreateDate:  2017-02-06
/// Table: 	DHC_DisRequestSta	 
/// Input:  statuscode:状态描述; mainID:申请id; userid:创建用户id; reason:未完成原因;
/// Return： 	 
/// W ##Class(web.DHCDISAccompStatus).insetNewStatus("29","182","4","1","")
ClassMethod insetNewStatus(statuscode As %String, mainID As %String, userid As %String, locdr As %String, reason As %String) As %String
{
	n (statuscode ,mainID ,userid ,locdr, reason)
	//s ^lv(123)=statuscode_"!!"_mainID_"!!"_userid_"!!"_reason_"!!"_locdr
	q:statuscode="" "插入状态有误"
	s err=0
	;i (statuscode=13)&(statuscode=currstatdr) q "已经验证码确认过该条记录！"
	;i (statuscode=14)&(statuscode=currstatdr) q "该记录状态已置为完成！"
	;i (statuscode=currstatdr) s err="请勿重复操作！"
	s type=1,statusid=""
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
	s:+mainID'=0 RsRowID=$o(^DHCDISRS(0,"TypePointer",type,mainID,""),-1) //取最新状态
	q:RsRowID="" "申请单没有接收，无法确认！"
	s RsCurStatus=""
	s RsCurStatusid=$p(^DHCDISRS(RsRowID),"^",3)
	s:RsCurStatusid'="" RsCurStatus=$p(^DHCDISSA(RsCurStatusid),"^",1)
	q:(statuscode=RsCurStatus) "请勿重复操作！"
	s ^lv("qq")=statuscode_"!"_RsCurStatus
	q:(statuscode="13")&(RsCurStatus<12) "申请单没有接收，不能确认验证码！"
	q:(statuscode="15")&(RsCurStatus<14) "申请单没有完成，不能完成确认！" 
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
	s err=##class(web.DHCDISRequestCom).updateStatus(RsPointer,RsReqType,statusid,RsCreateUser,Rsreasondr)  //2017-04-19  zhaowuqiang 
	;s err=##class(web.DHCDISRequestCom).saveRequestSta(RsPointer,RsReqType,statusid,RsCreateUser,Rsreasondr)
	;i err'=0 d
	;.s err="保存状态失败！"
	;.q:err'=0
	// w ##class(web.DHCDISRequestCom).updateRequestStatus(21,0,37)
	;s err=##class(web.DHCDISRequestCom).updateRequestStatus(RsPointer,RsReqType,statusid)
	;i err'=0 d
	;.s err="更新状态失败！"
	;.q:err'=0
	
	q err
}

/// Description:撤销申请
/// Creator:     lvpeng
/// CreateDate:  2017-02-07
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAccompStatus).CancelApplicaion("296")
ClassMethod CancelApplicaion(req As %String) As %String
{
   n (req)
   q:req="" "请选择其中一条申请单！"
   s statusID=$p(^DHCDISGRE(req),"^",10)
   q:statusID="" "状态为空，撤销失败"
   s statusCode=$p(^DHCDISSA(statusID),"^",1)
   q:statusCode>12 "出科确认后不能撤销申请"
   TS
   s err=0,ReqType=1
   ;s RsRowID=$o(^DHCDISRS(0,"TypePointer",ReqType,req,""),-1)
   ;b ;RsRowID
   ;s RsCurStatus=""
   ;s:RsRowID'="" RsCurStatus=$p(^DHCDISRS(RsRowID),"^",3)
   ;i (RsCurStatus=10)!(RsCurStatus=98)!(RsCurStatus=99) q "撤销失败！"  
   &sql(delete from DHC_DisGoodsRequest where REQ_RowID=:req)
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
   f  s reqsub=$o(^DHCDISRE(req,"ITM",reqsub)) q:reqsub=""  d
   .s reqi=req_"||"_reqsub
   .&sql(delete from DHC_DisGoodsReqItm where REQ_RowID=:reqi)
   i SQLCODE'=0  tro  q "撤销申请明细失败！"
   TC
   q 0
}

/// Description:获得配送申请状态
/// Creator:     lvpeng
/// CreateDate:  2017-02-13
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISAccompStatus).GetAffirmStatus()   
ClassMethod GetAffirmStatus()
{
	s satype=1,count=0
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
}

/// CreateDate: 2016-01-18
/// Descript:   查询配送列表
/// w ##class(web.DHCDISAccompStatus).listGoodsRequest("03/05/2017^03/05/2017^^^^")
ClassMethod listGoodsRequest(page = 1, rows = 10, param = "")
{
	n (%session,page,rows,param)
	s End = page*rows
	s Start=(page-1)*rows+1
	//Set sessionCtlocID=+%session.Get("LOGON.CTLOCID")
	s st=$p(param,"^",1)
	s ed=$p(param,"^",2)
	s taskID=$p(param,"^",3)
	s reqLoc=+$p(param,"^",5) //申请科室
	s recLoc=+$p(param,"^",4)
	s status=$p(param,"^",6)
	s st=$case(+st,0:+$h-100,:##class(web.DHCDISCommonDS).DateHtmlToLogical(st)) //hxy 2017-03-22 $zdh(st,3)
	s ed=$case(+ed,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(ed)) //$zdh(ed,3)
	s count=0
	w "{""rows"":["
	f date=ed:-1:st d
	.s req=""
	.f  s req=$o(^DHCDISGRE("0","CreateDate",date,req),-1) q:req=""  d
	..s tmpReqLoc=+$p(^DHCDISGRE(req),"^",2)
	..s tmpRecLoc=+$p(^DHCDISGRE(req),"^",3)
	..s tmpStatus=$p(^DHCDISGRE(req),"^",10)
	..s tmpTaskID=$p(^DHCDISGRE(req),"^",1)
	..s tmpTypeID=$p(^DHCDISGRE(req),"^",12)
	..s tmpEmFlag=$p(^DHCDISGRE(req),"^",13)   //2017-05-04  zhaowuqiang   加急标志
	..q:(reqLoc'=0)&&(reqLoc'=tmpReqLoc)
	..q:(recLoc'=0)&&(recLoc'=tmpRecLoc)
	..q:(taskID'="")&&(taskID'=tmpTaskID)
	..q:(status'="")&&(status'=tmpStatus)
	..;2017-05-03 取出库确认人 zhaowuqiang
	..s statusCode="",confirmUserName=""
	..s reqStaID=""
	..f  s reqStaID=$o(^DHCDISRS(0,"TypePointer",tmpTypeID,req,reqStaID)) q:reqStaID=""  d
	...s curStatusID=$p(^DHCDISRS(reqStaID),"^",3)
	...i curStatusID'="" s statusCode=$p(^DHCDISSA(curStatusID),"^",1)
	...q:statusCode'=13
	...s confirmUserDr=$p(^DHCDISRS(reqStaID),"^",6)
	...i confirmUserDr'="" s confirmUserName=$p(^SSU("SSUSR",confirmUserDr),"^",2)
    ..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	..d jsonObj.Put("REQ",req)
	..d jsonObj.Put("REQNo",tmpTaskID)
	..d jsonObj.Put("REQTypeID",tmpTypeID)
	..d jsonObj.Put("REQEmFlag",tmpEmFlag)
	..d jsonObj.Put("REQConfirmUser",confirmUserName)
	..d jsonObj.Put("REQLoc", $p(^CTLOC(+tmpReqLoc),"^",2))
	..d jsonObj.Put("REQRecLoc",$p(^CTLOC(tmpRecLoc),"^",2))
	..d jsonObj.Put("REQExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",4))) //hxy $zd($p(^DHCDISGRE(req),"^",4),3)
	..d jsonObj.Put("REQExeTime",$zt($p(^DHCDISGRE(req),"^",5)))
	..d jsonObj.Put("REQRemarks",$p(^DHCDISGRE(req),"^",6))
	..d jsonObj.Put("REQCreateDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",7)))  //hxy $zd($p(^DHCDISGRE(req),"^",7),3)
	..d jsonObj.Put("REQCreateTime",$zt($p(^DHCDISGRE(req),"^",8)))
	..d jsonObj.Put("REQCreateUser",$p(^SSU("SSUSR",+$p(^DHCDISGRE(req),"^",9)),"^",2))
	..i +tmpStatus'=0 d jsonObj.Put("REQCurStatus",$p($g(^DHCDISSA(tmpStatus)),"^",2))
	..w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// CreateDate: 2016-01-18
/// Descript:   查询配送列表明细
/// w ##class(web.DHCDISAccompStatus).listGoodsRequestItm(1,10,53)
ClassMethod listGoodsRequestItm(page = 1, rows = 10, req = "")
{
	n (%session,page,rows,req)
	s End = page*rows
	s Start=(page-1)*rows+1

	s count=0
	w "{""rows"":["
	s reqi=""
	f  s reqi=$o(^DHCDISGRE(req,"ITM",reqi)) q:reqi=""  d
	.
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s itmdr=$p(^DHCDISGRE(req,"ITM",reqi),"^",1)
	.s recloc=$p(^DHCDISGRE(req,"ITM",reqi),"^",2)
	.i recloc'=""  d
	..s LocDesc=$p(^CTLOC(recloc),"^",2)
	..s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.e  s LocDesc=""
	.s dispeo=$o(^DHCDISPE("0","TypePointer",1,req_"||"_reqi,""))
	.s username="",user=""
	.i +dispeo'=0 d
	..s user=$p(^DHCDISPE(dispeo),"^",3)
	..s username=$p(^SSU("SSUSR",user),"^",2)
	.d jsonObj.Put("ITMDR",itmdr)
	.d jsonObj.Put("RECLOCDR",recloc)
	.d jsonObj.Put("REQI",req_"||"_reqi)
	.d jsonObj.Put("ITM",$p(^DHCDISLI(itmdr),"^",2))
	.d jsonObj.Put("RECLOC",LocDesc)
	.d jsonObj.Put("QTY",$p(^DHCDISGRE(req,"ITM",reqi),"^",3))
	.d jsonObj.Put("USERID",user)
	.d jsonObj.Put("USERNAME",username)
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Description:  获取条码
/// Creator:      zhaowuqiang
/// Creatdate:    2017-04-19
/// Input：      申请单ID
/// Output:      条码
/// Other:       w ##class(web.DHCDISAccompStatus).PrintBarCode(230)
ClassMethod PrintBarCode(ReqID As %String) As %String
{
	
	n (ReqID)
	q:ReqID="" -1
	s BarCode=$p(^DHCDISGRE(ReqID),"^",11)
	q:BarCode="" -2
	s YFBarCode=$p(^DHCDISGRE(ReqID),"^",16)
	q BarCode_"^"_YFBarCode
}

}
