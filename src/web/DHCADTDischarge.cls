Import SQLUser

Class web.DHCADTDischarge Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetUserType(userId As %String) As %String
{
	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"
	q ctcptInternalType
}

ClassMethod GetUnReturnDrug(EpisodeID As %String) As %String
{
	//药停了但未作退药处理
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
		..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
		..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
		..s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    ..q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^"))
		..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
    	..q:ordStatCode'="D"
	    ..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoreId)
	    ..q:arcicOrderType'="R"
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        ..q:(oecprCode="OM")!(oecprCode="OMST")
	    ..s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoreId)
	    ..q:(dispenStat'="C")
	    ..s dspRowId="",returnFlag="N"
        ..s dspRowId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,dspRowId))
        ..q:dspRowId=""
        ..s dspStatus=$P($G(^DHCOEDISQTY(dspRowId)),"^",7)
        ..i dspStatus="R" s returnFlag="Y"
        ..q:returnFlag="Y"
	    ..q:$D(^RETRQ(0,"DODIS",dspRowId))'=0  //存在退药申请
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
    q oeoreIdStr
}

ClassMethod GetUnReturnDrug1(EpisodeID As %String) As %String
{
	//药停了护士做退药申请药房未做退药
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
		..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
		..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
		..s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    ..q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^"))
		..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
    	..;q:ordStatCode'="D"
	    ..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoreId)
	    ..q:arcicOrderType'="R"
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        ..q:(oecprCode="OM")!(oecprCode="OMST")
        ..s dspRowId=""
        ..s dspRowId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,dspRowId))
        ..q:dspRowId=""
        ..q:$D(^RETRQ(0,"DODIS",dspRowId))=0
        ..s flag=##class(web.DHCSTRETREQUEST).GetReturnFlag(oeoreId)
	    ..i flag=0 d
	    ...i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ...s oeoreIdStr=oeoreIdStr_oeoreId
    q oeoreIdStr
}

ClassMethod GetAbnormalOrder(EpisodeID As %String, userId As %String = "") As %String
{
	f i=1:1:30 s $p(retStr,"^",i)=0	
	q:EpisodeID="" "无病人ADM号!^0^0^0^"_retStr
	q:$p(^PAADM(EpisodeID),"^",20)'="A" "0^0^0^0^"_retStr

	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" "无病人病区!^0^0^0^"_retStr
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" "0^0^0^0^"_retStr
	s standToday=0,unExec=0,verifyLabOrd=0,verifyExamOrd=0
	s shouldCollectOrder=0,unReturnDrug=0,shouldDisconOrder=0

	s abnormSeq=$g(^DHCCLSet("Disch","AbnormalSeq"))
	i userId=""  s userId=%session.Data("LOGON.USERID")                           //Wkz 080114
	i userId'="" s ctcptInternalType=..GetUserType(userId)    //Wkz 080114
	
	s oeoreIdStr=..GetStandingOrder(EpisodeID,"")
    s babyAdmId="",babyEstimDisch=0,oeoreIdStr1=""
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	.s oeoreIdStr2=..GetStandingOrder(babyAdmId,"")
	.i oeoreIdStr2'="" d
	..i oeoreIdStr1'="" s oeoreIdStr1=oeoreIdStr1_"^"_oeoreIdStr2
	..e  s oeoreIdStr1=oeoreIdStr2
     i oeoreIdStr1'="" s oeoreIdStr=oeoreIdStr_"^"_oeoreIdStr1
	e  s oeoreIdStr=oeoreIdStr
	
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",1)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",1))=oeoreIdStr
	i oeoreIdStr'="" s $p(retStr,"^",$p(abnormSeq,"^",1))="该病人有 "_$l(oeoreIdStr,"^")_" 条今天的长期医嘱未停!  "
	s oeoreIdStr=..GetUnexecOrder(EpisodeID,userId)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",2)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",2))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",2))="该病人有"_$l(oeoreIdStr,"^")_"条医嘱未执行, 请执行医嘱!  "
	
	s babyAdmId="",babyEstimDisch=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	.s oeoreIdStr=..GetUnexecOrder(babyAdmId,userId)
	.i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",2)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",2))=oeoreIdStr
	.i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",2))="该病人婴儿有"_$l(oeoreIdStr,"^")_"条医嘱未执行, 请执行医嘱!  "
	
	s oeoreIdStr=..GetVerifyLabOrder(EpisodeID)
	s babyAdmId="",babyEstimDisch=0,oeoreIdStr1=""
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	.s oeoreIdStr2=..GetVerifyLabOrder(babyAdmId)
	.i oeoreIdStr2'="" d
	..i oeoreIdStr1'="" s oeoreIdStr1=oeoreIdStr1_"^"_oeoreIdStr2
	..e  s oeoreIdStr1=oeoreIdStr2
     i oeoreIdStr1'="" s oeoreIdStr=oeoreIdStr_"^"_oeoreIdStr1
	e  s oeoreIdStr=oeoreIdStr
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",3)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",3))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",3))="该病人有"_$l(oeoreIdStr,"^")_"条检验医嘱未做检验, 请做检验或停医嘱!  "
	s oeoreIdStr=..GetVerifyExamOrder(EpisodeID)
	s babyAdmId="",babyEstimDisch=0,oeoreIdStr1=""
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	.s oeoreIdStr2=..GetVerifyExamOrder(babyAdmId)
	.i oeoreIdStr2'="" d
	..i oeoreIdStr1'="" s oeoreIdStr1=oeoreIdStr1_"^"_oeoreIdStr2
	..e  s oeoreIdStr1=oeoreIdStr2
     i oeoreIdStr1'="" s oeoreIdStr=oeoreIdStr_"^"_oeoreIdStr1
	e  s oeoreIdStr=oeoreIdStr
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",4)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",4))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",4))="该病人有"_$l(oeoreIdStr,"^")_"条检查医嘱未做检查, 请做检查或停医嘱!  "
	s oeoreIdStr=..GetShouldCollectOrder(EpisodeID)
	s babyAdmId="",babyEstimDisch=0,oeoreIdStr1=""
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	.s oeoreIdStr2=..GetShouldCollectOrder(babyAdmId)
	.i oeoreIdStr2'="" d
	..i oeoreIdStr1'="" s oeoreIdStr1=oeoreIdStr1_"^"_oeoreIdStr2
	..e  s oeoreIdStr1=oeoreIdStr2
     i oeoreIdStr1'="" s oeoreIdStr=oeoreIdStr_"^"_oeoreIdStr1
	e  s oeoreIdStr=oeoreIdStr
	
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",5)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",5))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",5))="该病人有"_$l(oeoreIdStr,"^")_"条未领药医嘱(不含今天长嘱), 请领药或停医嘱!  "
	s oeoreIdStr=..GetUnReturnDrug(EpisodeID)  //药停了但未作退药申请
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",6)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",6))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",6))="该病人有"_$l(oeoreIdStr,"^")_"条停止医嘱未做退药处理!  "
	s oeoreIdStr=..GetUnReturnDrug1(EpisodeID)  //药停了药房未作退药处理
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",7)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",7))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",7))="该病人有"_$l(oeoreIdStr,"^")_"条停止医嘱药房未做退药处理!  "
	s oeoreIdStr=..GetShouldDisconOrder(EpisodeID)  //必须停但未停的医嘱
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",8)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",8))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",8))="该病人有"_$l(oeoreIdStr,"^")_"条必须停止医嘱未停!  "
	s oeoreIdStr=..GetStopDisconOrder(EpisodeID)  //停止需处理的医嘱
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",13)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",13))=oeoreIdStr
	i (oeoreIdStr'="")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",13))="该病人有"_$l(oeoreIdStr,"^")_"条停止需处理医嘱!  "
	s NeedItmCat=$g(^DHCCLSet("Disch","NeedOrdCat"))                  //WKZ 080116  S
	s NeedFlage=..IfOpItmCat(EpisodeID, NeedItmCat)
	i ($p(abnormSeq,"^",9)'="")&(NeedFlage'=1)&(NeedItmCat'="") s $p(retStr,"^",$p(abnormSeq,"^",9))="该病人未开"_$P($G(^ARC("IC",NeedItmCat)),"^",2)_"医嘱"    //xuqy 080412
	s NeedTransItmCat=$G(^DHCCLSet("Disch","NeedTransOrdCat"))                  
	s NeedTransFlage=..IfOpItmCat(EpisodeID, NeedTransItmCat)
	i ($p(abnormSeq,"^",10)'="")&(NeedTransFlage'=1)&(NeedTransItmCat'="") s $p(retStr,"^",$p(abnormSeq,"^",10))="该病人未开"_$P($G(^ARC("IC",NeedTransItmCat)),"^",2)_"医嘱"    //xuqy 080412
  
	s babyAdmId="",babyEstimDisch=0
	s motherloc=..GetPatLoc(EpisodeID)
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
		.s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
	    .q:(pavisit'="A")
	    .s babyloc=..GetPatLoc(babyAdmId) //
	    .q:motherloc'=babyloc
	    .i $p($g(^PAADM(babyAdmId)),"^",59)="" s babyEstimDisch=1 q
	//i  q "请先为该病人的婴儿做医疗结算!^0^0^0^"_retStr
	i ($p(abnormSeq,"^",11)'=""),ctcptInternalType="NURSE",babyEstimDisch  s $p(retStr,"^",$p(abnormSeq,"^",11))="请先为该病人的婴儿做医疗结算!"
		
	s OpOrdUnPaid=..GetAnOpOrder(EpisodeID) // + wxl 090410
 i ($p(abnormSeq,"^",12)'="")&(OpOrdUnPaid="Y")&(ctcptInternalType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",12))="该病人已做手术，但没有录相关费用"    //wxl 090410
	s alertItem=$g(^DHCCLSet("Disch","AlertItem"))
	s canDisch="Y"
	f i=1:1:$l(retStr,"^") d
	    .i $p(alertItem,"^",i)'="Y",$p(abnormSeq,"^",i)'="" d
	        ..s $p(retStr,"^",$p(abnormSeq,"^",i))=0
	        ..k ^TMP("Discon",$i,$p(abnormSeq,"^",i))
	    .i $p(retStr,"^",i)'=0 s canDisch="N"
	s $p(retStr,"^",31)=1 //temp former ://disconInd
	i $g(^DHCCLSet("Disch","CanDisch"))="Y" s canDisch="Y"
	s retStr=retStr_"^"_canDisch
	s retStr=retStr_"^"_$g(^DHCCLSet("Disch","TransDiscon"))
	s retStr=retStr_"^"_..GetDiagnosType(EpisodeID)
	q retStr
}

ClassMethod GetStopDisconOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" ""
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoreId=oeordId_"||"_oeoriSub
	    .s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    .q:UnNeedExecLocOrd=1
		.s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
		
	    .q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^"))
	    .s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
	    .q:orcatId="" 
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
	    .q:ordStatCode'="D"
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
	    .q:("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^")
	    .s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    	.q:userAddId=""
    	.s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    	.q:ctcpId=""
    	.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    	.q:ctcptInternalType'="DOCTOR"
        .s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,"DOCTOR","",oeoreId)
        .q:curDocFlag'="Y"
	    .;i ##Class(web.DHCNurCom).IfExecOrder(oeoreId)=1 q
    	.s getXordinfo=##Class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeoriSub)
    	.i getXordinfo'="^^" q 
    	
	    .i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    .s oeoreIdStr=oeoreIdStr_oeoreId
	 q oeoreIdStr
}

ClassMethod GetStandingOrderNew(EpisodeID As %String, startDate As %String = "") As %String
{
	///找startDate开始的长嘱,为空则从系统日期开始
	
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	
	i startDate="" s startDate=+$h
	s oeoriIdStr="",sttDate=""
	f  s sttDate=$o(^OEORDi(0,"StDt",sttDate)) q:sttDate=""  d
		.s oeoriSub=0
		.f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:oeoriSub=""  d
	        ..q:$d(^OEORD(oeordId,"I",oeoriSub))<10
		    ..s oeoriId=oeordId_"||"_oeoriSub
		    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
	        ..q:ordStatCode'="V"
	        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
	        ..q:(oecprCode'="S")&(oecprCode'="OMST")
	        ..s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    	    ..q:userAddId=""
    	    ..s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    	    ..q:ctcpId=""
    	    ..s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
		    ..q:ctcptId=""
    	    ..s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    	    ..q:ctcptInternalType'="DOCTOR"
	        
	        ..q:$p(^OEORD(oeordId,"I",oeoriSub,7),"^",1)=""
	        ..//q:$p(^OEORD(oeordId,"I",oeoriSub,3),"^",5)="P"  ; oeori_billed
		    ..i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
		    ..s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
}

ClassMethod DisconLongOrder(ordStrsInd As %String, EpisodeID As %String = "", ctcptInternalType As %String = "", userId As %String = "", transLocId As %String = "", disconDesc As %String = "") As %String
{
	//停当日的长期医嘱w ##Class(web.DHCCLDischarge).DisconLongOrder(166)
	//q:(ordStrsInd="") -1
	q:EpisodeID="" -2
	s oeoriStr=..GetStandingOrderNew(EpisodeID,"")
	q:oeoriStr="" 0
	
	i transLocId'=""
	{
		s admLocId=""
		i EpisodeID'=""	s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		q:admLocId=transLocId 0
	}
	s disconDeadFlag=""
	i ctcptInternalType="DOCTOR"
	{
		s disconId=0
		s disconDesc=$$ALPHAUP^SSUTIL4(disconDesc)
		i disconDesc'="" s disconId=$o(^PAC("DISCON",0,"Desc",disconDesc,""))
		q:disconId="" 0
		s disconDeadFlag=$p($g(^PAC("DISCON",disconId)),"^",3)
		i disconDeadFlag="D" q 0
	}
	
	//s count=0
	//i ordStrsInd>0 s count=$o(^mPLIST(ordStrsInd,""),-1)
	s count=$l(oeoriStr,"^")
	//s oeitm=$p(oeoriStr,"^",i)
	//s userId=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),7)),"^",1) 
	s err=0
	f i=1:1:count
	{
	s oeitm=$p(oeoriStr,"^",i)
	s userAdd=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),7)),"^",1) 
	s ordstatus=##Class(web.DHCCLCom).GetOrdStatCode(oeitm)
	i ordstatus="D" continue
	s err=##class(appcom.OEOrdItem).StopMulti(oeitm,userAdd,"","N")
	i err'=0 q
		}
	b ;123
	//s err=##class(appcom.OEOrdItem).StopMulti(oeoriStr,"","","N")
  	/*for i=1:1:count
   	{  
    	s oeitm=$p(oeoriStr,"^",i) //$lg(^mPLIST(ordStrsInd,i),13)

    	////////s err=##Class(web.UDHCStopOrderLook).discon(oeitm, UserID, PinNum)
    	s oldnamespace=$ZNSPACE
        s datanamespace=$LIST(^websys.ConfigurationD(1),12)
        zn datanamespace
        s err=$$discon^DHCCLDiscon(oeitm,"","")  //yu 
        ////s err=$$discon^SMLPrescLook(oeitm, user, pinnumber)
        zn oldnamespace
    	i err'=0 quit  
        
        /*s unCollect=1,oeoreSub=0,oeoriSub=$p(oeitm,"||",2)
        f  s oeoreSub=$o(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
            .s dspSub=0
            .f  s dspSub=$o(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:dspSub=""  d
                ..i $p(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6)="C" s unCollect=0
    	//w !,oeitm," unCollect="_unCollect
    	i unCollect=1 s err=..Collect(oeitm)
   	}	*/
   	i err'=0 q err
   	i (ctcptInternalType="DOCTOR")&(disconDeadFlag="D")
   	{
		s wardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
		i wardId="" q 0
		
		s curDate=+$h,curTime=$p($h,",",2)
		s bedSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,""))
		i bedSub'="" d
		    .s admSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub,""))
		    .i admSub'="" d
		        ..s bedAdmId=wardId_"||"_bedSub_"||"_admSub
		        ..s transId=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",admSub),"^",3)
				..
				..i transId'="" d
					...s reqstId=$o(^PAC("REQST",0,"Code","D",""))
					...&sql(update PA_AdmTransaction set TRANS_Status_DR=:reqstId,TRANS_Ward_DR=:wardId,TRANS_UpdateDate=:curDate,
		TRANS_UpdateTime=:curTime,TRANS_UpdateUser_DR=:userId where TRANS_RowId=:transId)
		        ..
		        ..&sql(delete from PAC_BedAdm where ADM_RowId=:bedAdmId)
		        ..s err=SQLCODE
		i err q "修改病人床位错误!"
		s reqstId=$o(^PAC("REQST",0,"Code","T",""))
		&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			TRANS_Ward_Dr,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR)
			Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId))
		i SQLCODE q "插入转移床位信息出错!"
		
		s transId=$g(%ROWID)
		q:transId="" "插入转移床位信息出错!"

		s wadmBookedStatus="O"
		&sql(insert into PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:wadmBookedStatus,:transId))
		i SQLCODE q "插入病区信息出错!"
   	}
  	q err
}

ClassMethod GetShouldCollectOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    ..s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	    ..q:reclocId=""
	    ..q:$p(^CTLOC(reclocId),"^",13)'="D"
	    ..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
		..s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    ..q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^"))
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..q:ordStatCode'="V"
        ..s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
    	 ..i execStatusId'="" s execStat=$p($g(^OEC("STAT",execStatusId)),"^",1)
        ..q:$g(execStat)="D"
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        ..q:(oecprCode="OM")!(oecprCode="OMST") // i oecprDesc["自备药" q
        ..q:($g(^DHCCLSet("Disch","TakeDisDrug"))'="Y")&(oecprCode="OUT") //ypz 070605
        ..s oeoreDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
        ..q:(oeoreDate=+$h)&(oecprCode="S")  //i (oeoriDate=+$h)&(oecprDesc["长期") q
        ..s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoreId)
	    ..q:(dispenStat="C")!(dispenStat="")   //已发药 和 部分已发药的 不提示未领药
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
}

ClassMethod GetCurDateTime() As %String
{
	q $zd(+$h,4)_"^"_$zt($p($h,",",2))
}

ClassMethod GetCurrentSeverDateTime() As %String
{
 
	s datstr=$ZD($H,3)
	s timstr=$ZT($P($H,",",2),1)
	s year=$P(datstr,"-",1)
	s month=$P(datstr,"-",2)
	s day=$P(datstr,"-",3)
	s hour=$P(timstr,":",1)
	s min=$P(timstr,":",2)
	s sec=$P(timstr,":",3)
	q year_"^"_month_"^"_day_"^"_hour_"^"_min_"^"_sec
}

ClassMethod GetStandingOrder(EpisodeID As %String, ordSttDate As %String = "") As %String
{
	///找startDate开始的长嘱,为空则从系统日期开始
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	
	i ordSttDate="" s ordSttDate=+$h
	s oeoreIdStr="",ordSttDate=ordSttDate-1
	f  s ordSttDate=$o(^OEORDi(0,"Date",oeordId,ordSttDate)) q:ordSttDate=""  d
		.s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime)) q:ordSttTime=""  d
		..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub)) q:oeoriSub=""  d
		...s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
		....q:$d(^OEORD(oeordId,"I",oeoriSub))<10
		....s oeoreId=oeordId_"||"_oeoriSub
		....s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
		....q:ordStatCode'="V"
		....s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
		....q:(oecprCode'="S")&(oecprCode'="OMST")
		....q:$p(^OEORD(oeordId,"I",oeoriSub,7),"^",1)=""
		....//q:$p(^OEORD(oeordId,"I",oeoriSub,3),"^",5)="P"  ; oeori_billed
		....i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
		....s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
}

ClassMethod GetVerifyLabOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    ..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
	    ..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoreId)
	    ..q:arcicOrderType'="L"
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..q:ordStatCode'="V"
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        ..s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
}

ClassMethod GetVerifyExamOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    ..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
	    ..s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
	    ..q:orcatId="" 
	    ..s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
	    ..q:ocgrpId=""
	    ..s ocgrpCode=$p($g(^OEC("OCGRP",ocgrpId)),"^",1)
	    ..q:ocgrpCode'="EXAM"
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..q:ordStatCode'="V"
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
}

ClassMethod GetUnexecOrder(EpisodeID As %String, userId As %String = "") As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" ""
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s ordInfo=##class(web.DHCLCNUREXCUTE).GetSeeOrdInfo(oeordId,oeoriSub)
		.q:ordInfo="^^"  //过滤未处理的医嘱
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    ..s UnNeedExecLocOrd=..UnNeedExecLocOrd(oeoreId)
	    ..q:UnNeedExecLocOrd=1
		..s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    ..q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^"))
	    ..s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
	    ..q:orcatId="" 
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
	    ..q:("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^")
	    ..s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    	..q:userAddId=""
    	..s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    	..q:ctcpId=""
    	..s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
		..q:ctcptId=""
    	..s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    	..q:ctcptInternalType'="DOCTOR"
        ..s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,"DOCTOR","",oeoreId)
        ..q:curDocFlag'="Y"
    	..i ##Class(web.DHCNurCom).IfExecOrder(oeoreId)=1 q
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
	
	       /*  出院带药自动执行
	       .i (ordStatCode="V")&(oecprCode="OUT") d
			..s oeoreSub=0  f  s oeoreSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:(oeoreSub="")  d
    			...s dspSub=0  f  s dspSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
    				....s oreStr=$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
    				....q:oreStr=""
    				....i $p(oreStr,"^",15)="" d
    				    .....s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
    				    .....q:ctcpId=""
    				    .....s ctcptId=$P($G(^CTPCP(ctcpId,1)),"^",4)
    				    .....q:ctcptId=""
    				    .....q:$P($G(^CT("CPT",ctcptId)),"^",4)'="NURSE"
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)=ctcpId
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)=$o(^OEC("STAT",0))
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)=+$h
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)=$p($h,",",2)
    				    .....s statId=$o(^OEC("STAT",0))
    				    .....s curDate=+$h,curTime=$p($h,",",2)
    				    .....s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    				    .....&Sql(update OE_ORDEXEC set OEORE_CTPCP_DR=:ctcpId,OEORE_Order_Status_DR=:statId,OEORE_DateExecuted=:curDate,OEORE_TimeExecuted=:curTime where OEORE_RowId=:oeoreId) */
}

ClassMethod Collect(oeitm)
{
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s err=$$Collect^SMLPrescLook(oeitm)
	zn oldnamespace
	q err
}

Query LookUpAbnormalOrder(EpisodeID As %String, AbnormalStat As %String) As %Query(ROWSPEC = "arcimDesc,abnormalDesc,regNo,oecprDesc,patName,bedCode,ordStatDesc,updateDateTime,sttDateTime,execCtcpDesc,execXUserDesc,ctcpDesc,dispenStat,reclocDesc,labNo,doseQtyUnit,phcfrCode,phcinDesc,oeoreId,PrescNo,EncryptLevel,PatLevel")
{
}

ClassMethod LookUpAbnormalOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, AbnormalStat As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i EpisodeID="" s qHandle=$lb(0,repid,0) q $$$OK
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	i wardId="" s qHandle=$lb(0,repid,0) q $$$OK
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	i oeordId="" s qHandle=$lb(0,repid,0) q $$$OK
	
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
	e  s bedCode=""
	s regNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
	s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1)
	
	k ^TMP("Discon",$i)
	s ^TMP("Discon",$i)="Y"
	s resStr=..GetAbnormalOrder(EpisodeID)
	
	s abnormSeq=$g(^DHCCLSet("Disch","AbnormalSeq"))
	s abnormStatStr=$g(^DHCCLSet("Disch","AbnormalStat"))
	s node=""
	f  s node=$o(^TMP("Discon",$i,node)) q:node=""  d
	    .s oeoreIdStr=^TMP("Discon",$i,node)
	    .q:oeoreIdStr=""
	    .
	    .s pos=0
	    .f i=1:1:$l(abnormSeq,"^") d
	        ..i $p(abnormSeq,"^",i)=node s pos=i
	    .i pos>0 s abnormalDesc=$p(abnormStatStr,"^",pos)
	    .q:(AbnormalStat'="")&&(AbnormalStat'=abnormalDesc)
	    .f i=1:1:$l(oeoreIdStr,"^") d
	        ..s oeoreId=$p(oeoreIdStr,"^",i)
	        ..q:oeoreId=""
	        ..s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	        ..;q:oeoreSub=""
	        ..s arcimStr=##Class(web.DHCNurCom).GetArcim(oeoreId)
	        ..s arcimDesc=$p(arcimStr,"^")
	        ..s doseQtyUnit=$p(arcimStr,"^",2)
	        ..s oecprDesc=$p(arcimStr,"^",3)
	        ..s phcfrCode=$p(arcimStr,"^",4)
	        ..s phcinDesc=$p(arcimStr,"^",5)
	        ..s ordStatDesc=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
	        ..s ordStatId=$o(^OEC("OSTAT",0,"Code",ordStatDesc,""))
	        ..;s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	        ..;s ordStatDesc=""
	        ..i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
	        ..s updateDateTime=""
	        ..s updateDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    		..s updateTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    		..s updateDateTime=##Class(web.DHCCLCom).FormatDate(updateDate)_" "_##Class(web.DHCCLCom).FormatTime(updateTime)
	       ..s sttDateTime=""
	       ..i oeoreSub'="" d
	       ...s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)   //keep duplicate
    		...s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)  //keep duplicate
    		..e  d
	       ...s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    		...s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    		..s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
	        ..s execCtcpDesc=""
	        ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	        ..i oeoreSub'="" d
	            ...s oreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
	            ...i $p(oreStr,"^",15)'="" d
                    ....s execCtcpDesc=$p($g(^CTPCP($p(oreStr,"^",15),1)),"^",2)
    		..s execXUserDesc=""
    		..s xOrdExecStr=""
    		..i $g(ordStatDesc)="D" s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoreId)
			..i $p(xOrdExecStr,"^")'="" d //ypz 070207
				...s execXUserId=$p(xOrdExecStr,"^")
        		...i execXUserId'="" s execXUserDesc=$p($g(^SSU("SSUSR",execXUserId)),"^",2)
 	        ..s ctcpDesc=""
   			..s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    		..s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    		..i ctcpId'="" s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	        ..s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoreId)
	        ..i dispenStat="C" s dispenStat="已发"
	        ..i dispenStat="TC" s dispenStat="未发"
	        ..i dispenStat="P" s dispenStat="未发"
	        ..i dispenStat="PC" s dispenStat="部分发"
	        ..s reclocDesc=""
	        ..s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    		..i reclocId'="" s reclocDesc=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
	        ..s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
	        ..s PrescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
	        ..Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
	        ..Set EncryptLevel=$p(PatEncryptLevel,"^",1)
            ..Set PatLevel=$p(PatEncryptLevel,"^",2) 
	        ..d OutputRow
 	s qHandle=$lb(0,repid,0)
 	k ^TMP("Discon",$i)
	q $$$OK
    
OutputRow
	s Data=$lb(arcimDesc,abnormalDesc,regNo,oecprDesc,patName,bedCode,ordStatDesc,updateDateTime,sttDateTime,execCtcpDesc,execXUserDesc,ctcpDesc,dispenStat,reclocDesc,labNo,doseQtyUnit,phcfrCode,phcinDesc,oeoreId,PrescNo,EncryptLevel,PatLevel)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpAbnormalOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAbnormalOrderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpAbnormalOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpAbnormalOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetDiagnosType(EpisodeID) As %String
{
  	q:EpisodeID="" 0
  	s dtypIdStr=$g(^DHCCLSet("Disch","DiagTypeId"))
  	q:dtypIdStr="" 0
  	s mradmId=$P(^PAADM(EpisodeID),"^",61)
    s motherAdmId=$P(^PAADM(EpisodeID),"^",75)  //控制婴儿无诊断可以出院
    s motherDeptId=$p($g(^PAADM(+motherAdmId)),"^",4)
    q:$p($g(^PAADM(+EpisodeID)),"^",4)=motherDeptId 0
  	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  		.q:$P(^MR(mradmId,"DIA",mrdiaSub),"^",1)=""
  		.s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  			..s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  			..q:dtypId=""
  			..f i=1:1:$l(dtypIdStr,"^") d
  			    ...i $p(dtypIdStr,"^",i)=dtypId s $p(dtypIdStr,"^",i)=0
  	s retStr=0
  	f i=1:1:$l(dtypIdStr,"^") d
  	    .q:+$p(dtypIdStr,"^",i)<1
  	    .i retStr'=0 s retStr=retStr_"  " 
  	    .e  s retStr=""
  	    .s retStr=retStr_"缺少"_$p($g(^MRC("DTYP",$p(dtypIdStr,"^",i))),"^",2)_"!"
  	q retStr
}

ClassMethod GetShouldDisconOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s mustDisconArcimId=$g(^DHCCLSet("Disch","MustDisconArcimId"))
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..q:ordStatCode'="V"
        ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
        ..q:arcimId=""
        ..q:("^"_mustDisconArcimId_"^")'[("^"_arcimId_"^")
	    ..i oeoreIdStr'="" s oeoreIdStr=oeoreIdStr_"^"
	    ..s oeoreIdStr=oeoreIdStr_oeoreId
	q oeoreIdStr
}

ClassMethod InsertBedOrd(EpisodeID, newWardDesc) As %String
{
	q:(EpisodeID="")!(newWardDesc="") -1
	s newWardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(newWardDesc),""))
	q:(newWardId=192)!(newWardId=193) -2 //转入ICU病区退出
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	//w curWardId,!
	q:(curWardId'=192)&(curWardId'=193) -3 //当前病区不是ICU
	q:$p($g(^PAADM(EpisodeID)),"^",73)="" -4 //不在床位上
	
	s preBedId="",findFlag="N"
    s transId="" f  s transId=$o(^PAADM(EpisodeID,"TRANS",transId),-1) q:(transId="")!(findFlag="Y")  d  
    	.s transStr=^PAADM(EpisodeID,"TRANS",transId)
    	.s bedId=$p(transStr,"^",8)
    	.s endDate=$p(transStr,"^",3)    ;end date
    	.//w transId_" bed="_bedId_" endDate="_endDate,!
    	.q:(bedId="")!(endDate="")  ;skip not bed, end date is not null 
    	.s tsbedtype=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",2)
    	.s tsarcim=$p($g(^PAC("BEDTP",+tsbedtype)),"^",4)
    	.//w " arcim/"_tsarcim,"/bedtype=",tsbedtype,!
    	.q:tsarcim=""
    	.q:$p($g(^PAC("BEDTP",+tsbedtype)),"^",5)="Y"
    	.s findFlag="Y"
    	.s preBedId=bedId
    	.s preEndTime=$p(transStr,"^",4)
	q:preBedId="" -11
	//w "preBedId="_preBedId_"/"_preEndTime_"/"_$zt(preEndTime),!
	
    s curTime=$p($h,",",2)
	s lastLeftTime=86400-preEndTime
	i lastLeftTime>43200 s lastLeftTime=lastLeftTime-43200
	s actTime=curTime+lastLeftTime
	i actTime<43200 q -12
	i actTime<86400,$g(^["MEDDATA"]TSABatch("CHBB1",+$h,"Room",EpisodeID))=1 q -6
		
    q:+$g(^["MEDDATA"]TSABatch("CHBB1",+$h,"Room",EpisodeID))>1 -7    //ypz
    s $p(^["MEDDATA"]TSABatch("CHBB1",+$h,"Room",EpisodeID),"^")=+$p($g(^["MEDDATA"]TSABatch("CHBB1",+$h,"Room",EpisodeID)),"^")+1    //lrl
    s row=$g(^PAADM(EpisodeID))         ;1 record
    s bed=$p(row,"^",73)          ;current bed
    s bedtype=$p($g(^PAWARD(+bed,"BED",+$p(bed,"||",2))),"^",2)
    //s arcim=$p($g(^PAC("BEDTP",+bedtype)),"^",4)
    //s alredarc=arcim
    s icu=$p($g(^PAC("BEDTP",+bedtype)),"^",5),seq=$s(icu="Y":1001,1:1000)
    s bedtypedesc=$p($g(^PAC("BEDTP",+bedtype)),"^",2)
    s recloc=$p(^PAWARD(curWardId),"^",5)
    s oldNameSpace=$ZNSPACE    //dj080523
    s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
    zn dataNameSpace
    i (icu="Y")&&($d(^ARCIM(15633,1))) d addorder^aOET13("15633||1",EpisodeID,"",".5","","","1004",+$h,curTime,recloc)   //监护费(进口心电监护病房)
    i ((icu="Y")!(bedtypedesc="普通单人间"))&&($d(^ARCIM(19905,1))) d addorder^aOET13("19905||1",EpisodeID,"",".5","","","1002",+$h,curTime,recloc)    //护理费
    i ((icu="Y")!(bedtypedesc="普通单人间"))&&($d(^ARCIM(19906,1))) d addorder^aOET13("19906||1",EpisodeID,"",".5","","","1003",+$h,curTime,recloc)    //诊疗费
    i ((icu'="Y")&&(bedtypedesc'="普通单人间"))&&($d(^ARCIM(19454,1))) d addorder^aOET13("19454||1",EpisodeID,"",".5","","","1002",+$h,curTime,recloc)    //护理费
    i ((icu'="Y")&&(bedtypedesc'="普通单人间"))&&($d(^ARCIM(15655,1))) d addorder^aOET13("15655||1",EpisodeID,"",".5","","","1003",+$h,curTime,recloc)    //诊疗费
    zn oldNameSpace  ; Restore the namespace
    
    s bedtype=$p($g(^PAWARD(+preBedId,"BED",+$p(preBedId,"||",2))),"^",2)
    s preArcim=$p($g(^PAC("BEDTP",+bedtype)),"^",4)
    //s alredarc=arcim

    i preArcim="" d
    .//w "Err! No Arcim - Bed: ",bed
    .s index=$o(^["MEDDATA"]TSABatch("CHBB1",+$h,"Day",$j,""),-1)+1
    .s ^["MEDDATA"]TSABatch("CHBB1",+$h,"Day",$j,index)="Err: No ARCIM - bed: "_$g(EpisodeID)_"^"_$g(bed)    
    i preArcim="" q -13
     
    zn dataNameSpace
    d addorder^aOET13(preArcim,EpisodeID,"",".5","","",seq,+$h,curTime+10,recloc)
  	zn oldNameSpace  ; Restore the namespace
  	q 0
}

ClassMethod IfOpItmCat(EpisodeID, needArcicId) As %String
{
    //判断今天是否有某类医嘱
    s ret=0
    s OEItemDate=+$h
    //If EpisodeID="" q
    i needArcicId="" q ret     //xuqy 080412
    I EpisodeID="" q ret             //xuqy 080412
    //查询两天内是否有某类医嘱
    s daynum=2
    s OEOrderId=""
    f  Set OEOrderId= $o(^OEORD(0,"Adm",EpisodeID,OEOrderId))  q:OEOrderId=""   d
    .f i=1:1:daynum d
    ..s OEItemDate=+$h-daynum+i
    ..s OEOrderSub=""
    ..f  s OEOrderSub=$o(^OEORDi(0,"ItemDate",OEItemDate,OEOrderId,OEOrderSub)) q:OEOrderSub=""   d
    ...q:'$d(^OEORD(OEOrderId,"I",OEOrderSub,1))
    ...s oeoriStr=^OEORD(OEOrderId,"I",OEOrderSub,1)
    ...s ItemStat=$p(oeoriStr,"^",13) 
    ...q:(ItemStat'=1)&(ItemStat'=6)
    ...s arcimId=$P(oeoriStr,"^",2)
    ...s arcimStr=$g(^ARCIM(+arcimId,1,1))
    ...s arcicId=$p(arcimStr,"^",10)
    ...i arcicId=needArcicId d
    ....s ret=1
    q ret
}

ClassMethod GetFinalStat(EpisodeID) As %String
{
    //取得病人财务结算状态,财务最终结算,财务审核。
    s retStr=0
    q:EpisodeID="" "没有病人就诊号!"
    s auditUser=$P($G(^PAADM(EpisodeID,2)),"^",92)
    i auditUser'="" s retStr="财务已审核,不能撤消最终结算!"
    s billFlag=$P($G(^PAADM(EpisodeID)),"^",45)
    i billFlag="Y" s retStr="已做财务结算,不能撤消最终结算!"
    s inadmId=$o(^DHCINADM("0","ADM",EpisodeID,""),-1)
    i inadmId'="" d 
        .s inadmActiveFlag=$p($g(^DHCINADM(inadmId)),"^",11)        ;INSU_AdmInfo表中的INADM_ActiveFlag字段
        .i inadmActiveFlag="out" s retStr="医保已经导出,不能撤销最终结算!"
    q retStr
}

ClassMethod DischargeBaby(EpisodeID, userId) As %String
{
    //为EpisodeID办理子女的出院
    q:EpisodeID="" "无病人就诊号!"
    q:userId="" "无操作用户!"
    s motherloc=..GetPatLoc(EpisodeID) //
    s babyAdmId="",babyEstimDisch=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	    .s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
	    .q:(pavisit'="A")
	    .s babyloc=..GetPatLoc(babyAdmId) //
	    .q:motherloc'=babyloc
	    .i $p($g(^PAADM(babyAdmId)),"^",59)="" s babyEstimDisch=1 q
	//i babyEstimDisch  q "请先为该病人的婴儿做医疗结算!"
	
    i ((babyEstimDisch)&($p(^DHCTarC("CF",2),"^",5)="Y")) q "请先为该病人的婴儿做医疗结算!"
    //s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
    s babyAdmId="",retStr=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:(babyAdmId="")!(retStr'=0)  d
	    .s pavisit=$p($g(^PAADM(babyAdmId)),"^",20)
	    .q:(pavisit'="A")
	    .s babyloc=..GetPatLoc(babyAdmId) //
	    .i motherloc'=babyloc  q  //
	    .s retStr=..PAAdmFinalDischarge(babyAdmId, userId)
	    .i retStr="不能对出院病人操作!" s retStr=0
	    .q:retStr'=0
	    .s babyBedId=$p(^PAADM(babyAdmId),"^",73)
	    .s babyBedSub=$p(babyBedId,"||",2)
	    .s babyBedtpId=""
	    .i babyBedSub'="" s babyBedtpId=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	    .//i babyBedtpId=mBabyBedtpId s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	    .i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(babyBedtpId)="Y" s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
    q retStr
}

ClassMethod PAAdmDischarge(EpisodeID, userId, medDischDate = "", medDischTime = "", dischDate = "", dischTime = "", disConDesc = "", deceasedDate = "", deceasedTime = "", userpassword) As %String
{
	q:userpassword="" "密码不能为空!"
	s retStr=""
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(userpassword)
	i pin="" s retStr=-1
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",3) s retStr=-1
	zn oldnamespace
	q:retStr=-1 "输入密码有误!"
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!"
	q:(disConDesc="死亡")&&((deceasedDate="")!(deceasedTime="")) "请填写死亡日期时间"
	//s ^ypzTmp(EpisodeID)=userId_"/"_disConDesc_"/"_deceasedDate_"/"_deceasedTime
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="DOCTOR")&(ctcptInternalType'="NURSE") "医护人员类型错!"
	q:((medDischDate="")!(medDischTime=""))&(ctcptInternalType="DOCTOR") 0     ///医疗结算日期不能为空，为空不能办理医疗结算
    i $l(medDischDate,"/")=3 s medDischDate=$zdh(medDischDate,4)
    i $l(medDischTime,":")>1 s medDischTime=$zth(medDischTime)
    i $l(dischDate,"/")=3 s dischDate=$zdh(dischDate,4)
    i $l(dischTime,":")>1 s dischTime=$zth(dischTime)
    i $l(deceasedDate,"/")=3 s deceasedDate=$zdh(deceasedDate,4)
    i $l(deceasedTime,":")>1 s deceasedTime=$zth(deceasedTime)
	s curDate=+$h,curTime=$p($h,",",2)
    i (medDischDate>curDate)!((medDischDate=curDate)&(medDischTime>curTime)) d
        .s medDischDate=curDate,medDischTime=curTime
    i ctcptInternalType="DOCTOR" d
	    .&sql(update PA_ADM set PAADM_EstDischConfirmed='Y',
			PAADM_EstimDischargeDate=:medDischDate,PAADM_EstimDischargeTime=:medDischTime,PAADM_MedDischDoc_DR=:ctcpId,
			PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,PAADM_UpdateUser_DR=:userId 
			where PAADM_RowId=:EpisodeID)
    //i ctcptInternalType="DOCTOR" q SQLCODE
    s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
	i disConDesc="" s disconId=""
	e  s disconId=$o(^PAC("DISCON",0,"Desc",disConDesc,""))
	//---------------
	b ;123
	i disconId'="" d
	    .i $p(^PAC("DISCON",disconId),"^",3)="D" d
	        ..i deceasedDate="" s deceasedDate=medDischDate //dischDate
	        ..i deceasedTime="" s deceasedTime=medDischTime //dischTime
	        ..i (deceasedDate>medDischDate)!((deceasedDate=medDischDate)&(deceasedTime>medDischTime)) d
	        	...q:medDischDate=""
	            ...s deceasedDate=medDischDate,deceasedTime=medDischTime
	        ..s paperDeceased="Y"
	    .i $p(^PAC("DISCON",disconId),"^",3)'="D" d
		    ..s deceasedDate="",deceasedTime="",paperDeceased=""
	    .s paperId=+^PAADM(EpisodeID)
	    .&sql(update PA_Person set PAPER_Deceased=:paperDeceased,PAPER_Deceased_Date=:deceasedDate,PAPER_DeceasedTime=:deceasedTime where Paper_RowId=:paperId)
	    .//s ^ypzTmp("deceased")=SQLCODE_"/"_deceasedDate_"/"_deceasedTime_"/"_$p(^PAPER(paperId,"ALL"),"^",11,20)
	 //---------------------
	
	&sql(update MR_Adm set MRADM_ConditAtDisch_DR=:disconId	where MRADM_RowId=:mrAdmId)
    i ctcptInternalType="DOCTOR" q SQLCODE
    //以下是护士的最终结算
    q:(dischDate="")!(dischTime="") 0    ///最终结算日期不能为空，为空不能办理出院
    i dischDate="" s dischDate=curDate,dischTime=curTime
    i dischTime="" s dischTime=curTime
    i (dischDate>curDate)!((dischDate=curDate)&(dischTime>curTime)) s dischDate=curDate,dischTime=curTime
    
    s paadmEstDischDate=$p(^PAADM(EpisodeID),"^",59)
    s paadmEstDischTime=$p(^PAADM(EpisodeID),"^",60)
    q:(paadmEstDischDate>dischDate)!((paadmEstDischDate=dischDate)&(paadmEstDischTime>dischTime)) "最终结算时间不能早于医疗结算时间!"
	
	s retStr=##class(web.DHCADTTransaction).IfPatOccupyBed(EpisodeID)
	q:retStr'=0 "病人有包床未退!"
    s retStr=..DischargeBaby(EpisodeID, userId)
    q:retStr'=0 retStr
    q ..PAAdmFinalDischarge(EpisodeID, userId, dischDate, dischTime, disConDesc, deceasedDate, deceasedTime)
}

ClassMethod PAAdmFinalDischarge(EpisodeID, userId, dischDate = "", dischTime = "", disConDesc = "", deceasedDate = "", deceasedTime = "") As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!" 
	//s ^ypzTmp(EpisodeID)=userId_"/"_disConDesc_"/"_deceasedDate_"/"_deceasedTime
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="DOCTOR")&(ctcptInternalType'="NURSE") "医护人员类型错!"
    
    s curDate=+$h,curTime=$p($h,",",2)
    i dischDate="" s dischDate=curDate,dischTime=curTime
    i dischTime="" s dischTime=curTime

	s visitStatusCode="D"
	&sql(update PA_ADM set PAADM_VisitStatus=:visitStatusCode,
			PAADM_DischgDate=:dischDate,PAADM_DischgTime=:dischTime,PAADM_DischgDoc_DR=:ctcpId,
			PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,PAADM_UpdateUser_DR=:userId 
			where PAADM_RowId=:EpisodeID)
	i SQLCODE q "修改病人结算状态错误!"
	s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
	i disConDesc="" s disconId=""
	e  s disconId=$o(^PAC("DISCON",0,"Desc",disConDesc,""))
	//&sql(update MR_Adm set MRADM_ConditAtDisch_DR=:disconId	where MRADM_RowId=:mrAdmId)
	i SQLCODE q "修改病人出院状态错误!"
    
    //s ^ypzTmp("EpisodeID")=userId_"/"_disconId_"/"_deceasedDate_"/"_deceasedTime_"/"_paadmEstDischDate
	i disconId'="" d
	    .i $p(^PAC("DISCON",disconId),"^",3)="D" d
	        ..i deceasedDate="" s deceasedDate=dischDate
	        ..i deceasedTime="" s deceasedTime=dischTime
	        ..i (deceasedDate>dischDate)!((deceasedDate=dischDate)&(deceasedTime>dischTime)) d
	            ...s deceasedDate=dischDate,deceasedTime=dischTime
	        ..s paperDeceased="Y"
	    .i $p(^PAC("DISCON",disconId),"^",3)'="D" d
		    ..s deceasedDate="",deceasedTime="",paperDeceased=""
	    .s paperId=+^PAADM(EpisodeID)
	    .&sql(update PA_Person set PAPER_Deceased=:paperDeceased,PAPER_Deceased_Date=:deceasedDate,PAPER_DeceasedTime=:deceasedTime where Paper_RowId=:paperId)
	    .//s ^ypzTmp("deceased")=SQLCODE_"/"_deceasedDate_"/"_deceasedTime_"/"_$p(^PAPER(paperId,"ALL"),"^",11,20)
    s paadmEstDischDate=$p(^PAADM(EpisodeID),"^",59)
    i paadmEstDischDate'="" s ^PAADMi("EstDisch",paadmEstDischDate,EpisodeID)=""

	s transId=""
	s wardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	i wardId'="" d
	    .s wardSub=$o(^PAWARDA(0,"WADM",EpisodeID,wardId,""))
	    .i wardSub'="" d
	        ..s wadmId=wardId_"||"_wardSub
	        ..s transId=$p(^PAWARDA(wardId,"WADM",wardSub),"^",3)
	        ..&sql(delete from PAC_WardAdm where WADM_RowId=:wadmId)
	s wardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	i wardId'="" d
	    .s bedSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,""))
	    .i bedSub'="" d
	        ..s admSub=$o(^PAWARDA(0,"ADM",EpisodeID,wardId,bedSub,""))
	        ..i admSub'="" d
	        	...s bedAdmId=wardId_"||"_bedSub_"||"_admSub
	        	...s transId=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",admSub),"^",3)
	        	...&sql(delete from PAC_BedAdm where ADM_RowId=:bedAdmId)
	i SQLCODE q "修改病人病区位置错误!"
	i transId'="" d
		.s reqstId=$o(^PAC("REQST",0,"Code","D",""))
		.&sql(update PA_AdmTransaction set TRANS_Status_DR=:reqstId,TRANS_UpdateDate=:curDate,
		TRANS_UpdateTime=:curTime,TRANS_UpdateUser_DR=:userId where TRANS_RowId=:transId)
	i SQLCODE q "修改病人转科状态错误!"
	//释放小孩床位
	s curPAADMMotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	s curPAADMMotherAdmDR=+curPAADMMotherAdmDR
	i curPAADMMotherAdmDR'=0 d
	.s babyBedId=$p(^PAADM(EpisodeID),"^",73)
	.s babyBedSub=$p(babyBedId,"||",2)
	.s babyBedtpId=""
	.//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
	.i babyBedSub'="" s babyBedtpId=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	.//i babyBedtpId=mBabyBedtpId s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	.i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(babyBedtpId)="Y" s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	d ..ISendDischargeInfo(EpisodeID) //调用平台接口方法
	s userName=$p(^SSU("SSUSR",userId),"^",2)
	i userName'="" d
	.d ##Class(RISService.InvokeRISService).DiscontinueAllAppInfoPACS(EpisodeID,userName)
	//************************************************************
	//add by zf 20101108
	//最终结算时自动关闭临床路径
	i 'SQLCODE d
	.s flg=##class(web.DHCCPW.MR.Interface).ClosePathWay(EpisodeID)
	//************************************************************
	q SQLCODE
}

/// 撤消医疗结算
ClassMethod ReverseEstimDischarge(EpisodeID) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" "不能对出院病人操作!"
	&sql(update PA_ADM set PAADM_EstDischConfirmed='N',PAADM_DischCond_DR=null,
			PAADM_EstimDischargeDate=null,PAADM_EstimDischargeTime=null,PAADM_MedDischDoc_DR=null
			where PAADM_RowId=:EpisodeID)
	i SQLCODE q "撤消医疗结算失败!"
	s paperId=+^PAADM(EpisodeID)
	&sql(update PA_Person set PAPER_Deceased='N',PAPER_Deceased_Date=null,PAPER_DeceasedTime=null where Paper_RowId=:paperId)
	i SQLCODE q "撤消医疗结算失败!"
	s mrAdmId=$p(^PAADM(EpisodeID),"^",61)
	i mrAdmId'="" d
	.&sql(update MR_Adm set MRADM_ConditAtDisch_DR=null where MRADM_RowId=:mrAdmId)
	i SQLCODE q "撤消医疗结算失败!"
	q SQLCODE
}

/// 撤消最终结算
ClassMethod PAAdmReverseFinalDischarge(EpisodeID, userId, reverseReasonId) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)'="D" "只能对出院病人操作!"
	q:reverseReasonId="" "没有撤消最终结算原因!"
	s retStr=..GetFinalStat(EpisodeID)
	i retStr'=0 q retStr
	//s ^ypzTmp(EpisodeID)=userId_"/"_disConDesc_"/"_deceasedDate_"/"_deceasedTime
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="DOCTOR")&(ctcptInternalType'="NURSE") "医护人员类型错!"
    
    s curDate=+$h,curTime=$p($h,",",2)
    s dischDate="",dischTime=""

	s visitStatusCode="A"
	Set $ZT="ERROR"
	TSTART
	&sql(update PA_ADM set PAADM_VisitStatus=:visitStatusCode,
			PAADM_DischgDate=:dischDate,PAADM_DischgTime=:dischTime,
			PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,PAADM_UpdateUser_DR=:userId 
			where PAADM_RowId=:EpisodeID)
	i SQLCODE TROLLBACK  q "修改病人结算状态错误!"
	s wardId=$p(^PAADM(EpisodeID),"^",70)
	s bedId=$p(^PAADM(EpisodeID),"^",73)
	s bedSub=$p(bedId,"||",2)
	s reverseBed="N"  //默认转到等待区
	i bedSub'="" d
	    .q:$p(^PAWARD(wardId,"BED",bedSub),"^",4)="N" 
	    .s reverseBed="Y"
	    .s bedAdmSub=0
	    .f  s bedAdmSub=$o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
	        ..i $p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^",2)="O" s reverseBed="N"
	        ..//w bedAdmSub,"/",reverseBed
	s transBed="N"
	i reverseBed="Y" d
		.s bookedStatus="O"
		.s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
		.s preTransSub="",transSub=0
		.f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	    	..i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	        ..//w preTransSub,"/",transSub,!
		.q:transSub=0
		.s transId=EpisodeID_"||"_transSub
		.&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		.i SQLCODE s retStr="插入床位信息出错!" q
		.s transBed="Y"
	i retStr'=0 TROLLBACK  q retStr
	i (reverseBed'="Y")||(transBed'="Y") d
	    .s retStr=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, userId, wardId, "","N")
	i retStr'=0 TROLLBACK  q retStr
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	i $P(^PAADM(EpisodeID),"^",2)="E" d
    .s curdate = $ZD(+$h,4)
    .s curtime = $zt($p($h,",",2))
    .s warddesc = $p(^PAWARD(wardId),"^",2)
    .s rtn = ##class(web.DHCADMVisitStat).InsertVis(EpisodeID,"Stay",curdate,curtime,userId,warddesc,1)
	&sql(update MR_Adm set MRADM_ReasonForRevFinDisch_DR=:reverseReasonId where MRADM_RowId=:mradmId)
	i SQLCODE'=0 TROLLBACK  q "修改撤消最终结算原因错!"
	TCOMMIT
	d ..ISendCancelDisInfo(EpisodeID) 
	q retStr
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

/// 延迟出院
ClassMethod UpdateDelayDischarge(EpisodeID, DHCADMStatus, DischgUserId, DischgDate, DischgTime) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	s CTCpId=$p(^SSU("SSUSR",+DischgUserId),"^",14)
	q:CTCpId="" "该用户未关联医护人员!"
    s retStr=..UpdateDHCADMStatus(EpisodeID, DHCADMStatus, DischgUserId, DischgDate, DischgTime)
	q:retStr'=0 retStr
	s wardId=""
	s wardId=$p(^PAADM(EpisodeID),"^",70)
	q:(wardId="") "无病区信息!"
	i DHCADMStatus="D" d 
	.s retStr=##Class(web.DHCADTTransaction).MoveAdm(EpisodeID,DischgUserId,wardId,"") //出院，病人转到等待区
	i retStr'=0 q retStr
	q 0
}

ClassMethod UpdateDHCADMStatus(EpisodeID, DHCADMStatus, DischgUserId, DischgDate, DischgTime) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	s CTCpId=$p(^SSU("SSUSR",+DischgUserId),"^",14)
	q:CTCpId="" "该用户未关联医护人员!"
	s curDate=+$h,curTime=$p($h,",",2)
	i DischgDate'="" s DischgDate=$zdh(DischgDate,4)
	e  s DischgDate=curDate
	i DischgTime'="" s DischgTime=$zth(DischgTime,2)
	e  s DischgTime=curTime
	s paadmEstDischDate=$p(^PAADM(EpisodeID),"^",59)
    s paadmEstDischTime=$p(^PAADM(EpisodeID),"^",60)
    q:(DHCADMStatus="D")&((paadmEstDischDate>DischgDate)!((paadmEstDischDate=DischgDate)&(paadmEstDischTime>DischgTime))) "最终结算时间不能早于医疗结算时间!"
	
	s DHCADMRowId=""
	s DHCADMRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,DHCADMRowId))
	
	q:(DHCADMRowId="")&(DischgDate'=curDate) "最终结算日期不等于当前日期!"
	q:(DHCADMRowId="")&(DHCADMStatus="R") "非出院状态不能招回!"
			
	s retStr=0
	i (DHCADMRowId'="")&(DHCADMStatus="D") d
	.i $p(^DHCPAAdm(DHCADMRowId),"^",5)="" d
	..i DischgDate'=curDate s retStr="最终结算日期不等于当前日期!"
	.e  d
	..i $p($G(^DHCPAAdm(DHCADMRowId)),"^",5)'=DischgDate d
	...s retStr="不能改变最终结算日期!"
	i (DHCADMRowId'="")&(DHCADMStatus="R") d
	.i $p($G(^DHCPAAdm(DHCADMRowId)),"^",3)'="D" s retStr="非出院状态不能招回!"
	.e  d
	..i DischgDate'=curDate s retStr="招回日期不等于当前日期!" 
	i retStr'=0 q retStr
	
	Set $ZT="ERROR"
	s err=0
	TSTART
	i DHCADMRowId="" d
	.i DHCADMStatus="D" d
	..&sql(insert into DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_Status,DHCADM_DischgDoc_Dr,DHCADM_DischgDate,
			DHCADM_DischgTime) Values (:EpisodeID,:DHCADMStatus,:CTCpId,:DischgDate,:DischgTime))
	..i SQLCODE s err="出院主表记录插入有误!" q
    ..s ADMDPar=$g(%ROWID)
	..&sql(insert into DHC_PA_AdmDischarge (ADMD_Parref,ADMD_Status,ADMD_User_Dr,ADMD_StatusDate,
			ADMD_StatusTime,ADMD_UpdateDate,ADMD_UpdateTime) Values (:ADMDPar,:DHCADMStatus,:DischgUserId,
			:DischgDate,:DischgTime,:curDate,:curTime))
	..i SQLCODE s err="出院子表记录插入有误!" q
	.i DHCADMStatus="R" d
	..&sql(insert into DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_Status,DHCADM_ReturnUser_Dr,DHCADM_ReturnDate,
			DHCADM_ReturnTime) Values (:EpisodeID,:DHCADMStatus,:DischgUserId,:DischgDate,:DischgTime))
	..i SQLCODE s err="招回主表记录插入有误!" q
	..s ADMDPar=$g(%ROWID)
	..&sql(insert into DHC_PA_AdmDischarge (ADMD_Parref,ADMD_Status,ADMD_User_Dr,ADMD_StatusDate,
			ADMD_StatusTime,ADMD_UpdateDate,ADMD_UpdateTime) Values (:ADMDPar,:DHCADMStatus,:DischgUserId,
			:DischgDate,:DischgTime,:curDate,:curTime))
	..i SQLCODE s err="招回子表记录插入有误!" q
	
	i DHCADMRowId'="" d
	.i DHCADMStatus="D" d
	..&sql(update DHC_PA_Adm set DHCADM_Status=:DHCADMStatus,DHCADM_DischgDoc_Dr=:CTCpId,
			DHCADM_DischgDate=:DischgDate,DHCADM_DischgTime=:DischgTime where DHCADM_RowId=:DHCADMRowId)
	..i SQLCODE s err="出院主表记录更新有误!" q
	..&sql(insert into DHC_PA_AdmDischarge (ADMD_Parref,ADMD_Status,ADMD_User_Dr,ADMD_StatusDate,
			ADMD_StatusTime,ADMD_UpdateDate,ADMD_UpdateTime) Values (:DHCADMRowId,:DHCADMStatus,:DischgUserId,
			:DischgDate,:DischgTime,:curDate,:curTime))
	..i SQLCODE s err="出院子表记录插入有误!" q
	.i DHCADMStatus="R" d
	..s DHCADMDischgDate=""
	..s DHCADMDischgTime=""
	..&sql(update DHC_PA_Adm set DHCADM_Status=:DHCADMStatus,DHCADM_DischgDoc_Dr="",DHCADM_DischgDate=:DHCADMDischgDate,DHCADM_DischgTime=:DHCADMDischgTime,
				  DHCADM_ReturnUser_Dr=:DischgUserId,DHCADM_ReturnDate=:DischgDate,DHCADM_ReturnTime=:DischgTime where DHCADM_RowId=:DHCADMRowId)
	..i SQLCODE s err="招回主表记录更新有误!" q
	..&sql(insert into DHC_PA_AdmDischarge (ADMD_Parref,ADMD_Status,ADMD_User_Dr,ADMD_StatusDate,
			ADMD_StatusTime,ADMD_UpdateDate,ADMD_UpdateTime) Values (:DHCADMRowId,:DHCADMStatus,:DischgUserId,
			:DischgDate,:DischgTime,:curDate,:curTime))
	..i SQLCODE s err="招回子表记录插入有误!" q
	i err TROLLBACK  q err
	TCOMMIT
	q err
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

/// 就诊 结算 招回日期与时间
ClassMethod GetAdmDateTime(EpisodeID) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	s PAADMAdmDate=$p($G(^PAADM(EpisodeID)),"^",6)
	s PAADMAdmTime=$p($G(^PAADM(EpisodeID)),"^",7)
	s medDischDate=$p($G(^PAADM(EpisodeID)),"^",59)
	s medDischTime=$p($G(^PAADM(EpisodeID)),"^",60)
	s DHCADMRowId="",DHCADMDischgDate="",DHCADMStatus="",DHCADMDischgTime="",DHCADMReturnDate="",DHCADMReturnTime=""
	s DHCADMRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,DHCADMRowId))
	i DHCADMRowId'="" d
	.s DHCADMStatus=$p(^DHCPAAdm(DHCADMRowId),"^",3)
	.s DHCADMDischgDate=$p(^DHCPAAdm(DHCADMRowId),"^",5)
	.s DHCADMDischgTime=$p(^DHCPAAdm(DHCADMRowId),"^",6)
	.s DHCADMReturnDate=$p(^DHCPAAdm(DHCADMRowId),"^",8)
	.s DHCADMReturnTime=$p(^DHCPAAdm(DHCADMRowId),"^",9)
    i PAADMAdmDate'="" s PAADMAdmDate=$zd(PAADMAdmDate,4)
    i PAADMAdmTime'="" s PAADMAdmTime=$zt(PAADMAdmTime,2)
    i medDischDate'="" s medDischDate=$zd(medDischDate,4)
    i medDischTime'="" s medDischTime=$zt(medDischTime,2)
    i DHCADMDischgDate'="" s DHCADMDischgDate=$zd(DHCADMDischgDate,4)
    i DHCADMDischgTime'="" s DHCADMDischgTime=$zt(DHCADMDischgTime,2)
    i DHCADMReturnDate'="" s DHCADMReturnDate=$zd(DHCADMReturnDate,4)
    i DHCADMReturnTime'="" s DHCADMReturnTime=$zt(DHCADMReturnTime,2)    
    s str=PAADMAdmDate_"^"_PAADMAdmTime_"^"_medDischDate_"^"_medDischTime_"^"_DHCADMStatus_"^"_DHCADMDischgDate_"^"_DHCADMDischgTime_"^"_DHCADMReturnDate_"^"_DHCADMReturnTime
	q str
}

ClassMethod FindReaForRevFinDischClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReaForRevFinDischExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindReaForRevFinDischExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s RFDRowId=0 
    f  s RFDRowId=$o(^PAC("RFD",RFDRowId)) q:RFDRowId=""  d
    .s RFDDesc=$p(^PAC("RFD",RFDRowId),"^",2)
 	.Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(RFDDesc,RFDRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindReaForRevFinDischFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReaForRevFinDischExecute ]
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

Query FindReaForRevFinDisch() As %Query(ROWSPEC = "RFDDesc:%String,RFDRowId:%String")
{
}

/// 撤销出院原因
ClassMethod GetReaForRevFinDisch(EpisodeID) As %String
{
	q:EpisodeID="" ""
	s RFDRowId=""
	s RFDDesc=""
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	i mradmId'="" s RFDRowId=$p(^MR(mradmId,"PRO",1),"^",53)
	i RFDRowId'="" s RFDDesc=$p(^PAC("RFD",RFDRowId),"^",2)
	q RFDDesc_"^"_RFDRowId
}

/// 医保中期结算
ClassMethod UpdateIntMedicare(EpisodeID, userId, UnableOrder, UnableOrdReason, IntMedicareStatus) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	s CTPCPId=$p(^SSU("SSUSR",+userId),"^",14)
	q:CTPCPId="" "请用医护人员的身份操作!"
    s CTPCPTypeId=$P($g(^CTPCP(CTPCPId,1)),"^",4)
	q:CTPCPTypeId="" "未定义医护人员类型!"
    s CTPCPInternalType=$P($g(^CT("CPT",CTPCPTypeId)),"^",4)
	q:CTPCPInternalType'="DOCTOR" "请用医生身份操作!"
	s curDate=+$h,curTime=$p($h,",",2)

	s DHCADMRowId=""
	s DHCADMRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,DHCADMRowId))
	i DHCADMRowId="" d
	.&sql(insert into DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_UnableOrder,DHCADM_UnableOrdReason,DHCADM_UnableOrdUser_Dr,
			DHCADM_UnableOrdDate,DHCADM_UnableOrdTime,DHCADM_IntMedicareStatus,DHCADM_IntMedicareUser_Dr,
			DHCADM_IntMedicareDate,DHCADM_IntMedicareTime) Values (:EpisodeID,:UnableOrder,:UnableOrdReason,:userId,
			:curDate,:curTime,:IntMedicareStatus,:userId,:curDate,:curTime))
	.i SQLCODE s err="插入医保中期医疗结算标志有误!" q
	i DHCADMRowId'="" d
	.&sql(update DHC_PA_Adm set DHCADM_UnableOrder=:UnableOrder,DHCADM_UnableOrdReason=:UnableOrdReason,
			DHCADM_UnableOrdUser_Dr=:userId,DHCADM_UnableOrdDate=:curDate,DHCADM_UnableOrdTime=:curTime,
			DHCADM_IntMedicareStatus=:IntMedicareStatus,DHCADM_IntMedicareUser_Dr=:userId,
			DHCADM_IntMedicareDate=:curDate,DHCADM_IntMedicareTime=:curTime where DHCADM_RowId=:DHCADMRowId)
	.i SQLCODE s err="更新医保中期医疗结算标志有误!" q
	i SQLCODE q err
	q 0
}

/// 取医保中期结算标志
ClassMethod GetIntMedFlag(EpisodeID) As %String
{
	q:EpisodeID="" 0
	s DHCADMRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,""))
	i DHCADMRowId="" q 0
	s IntMedicareStatus=$p(^DHCPAAdm(DHCADMRowId),"^",15)
	q:IntMedicareStatus="" 0
	q:(IntMedicareStatus["N")!(IntMedicareStatus["B") 1
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-04-20
/// Description: 手术室是否未收费
/// Table：DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation,OE_Order,OE_OrdItem,CT_Loc,ARC_ItmMast,ARC_ItemCat
/// Input：EpisodeID:病人就诊ID needArcicId:医嘱子类ID
/// Return：病人有手术申请且状态为完成,对于该手术申请没有录入医嘱或者录入医嘱的接受科室都不是手术室返回"Y"
///         否则返回空或"N"
ClassMethod GetAnOpOrder(EpisodeID As %String, needArcicId As %String) As %String
{
	q:EpisodeID="" ""
	s UnPaidFlag=""
	s OPAId=""
	f  s OPAId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,OPAId)) q:(OPAId="")!(UnPaidFlag="Y")  d
	.s OPAStatus=$p($g(^DHCANOPArrange(OPAId)),"^",27)
	.q:"ADF"=OPAStatus //申请，拒绝，完成的属于正常 ypz 110129
	.s UnPaidFlag="Y"
	.q
	.s OPAStatus=$p($g(^DHCANOPArrange(OPAId)),"^",27)
	.q:OPAStatus'="F"   //手术申请状态非完成退出
	.s OPAAnaestDr=$p($g(^DHCANOPArrange(OPAId)),"^",2)
	.s ANASub=$p(OPAAnaestDr,"||",2)
	.s ANAOPSub=$o(^OR(EpisodeID,"ANA",ANASub,"OP",0))
	.q:ANAOPSub=""      //手术申请指向麻醉表OR_Anaesthesia为空退出
	.s RecDepId=$p(^OR(EpisodeID,"ANA",ANASub,"OP",ANAOPSub),"^",10)
	.q:RecDepId=""      //手术所对应科室为空退出OR_Anaest_Operation
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""       
	.s oeoriSub=0
	.f  s oeoriSub=$o(^OEORDi(0,"RecDepOrd",oeordId,RecDepId,oeoriSub)) q:(oeoriSub="")!(UnPaidFlag="N")  d
	..s oeoriId=oeordId_"||"_oeoriSub
	..s OrdLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
	..q:OrdLocId=""
	..q:$p(^CTLOC(OrdLocId),"^",13)'="OP"        //开医嘱科室非手术室退出
	..s OEORIAnDr=$p($g(^OEORD(oeordId,"I",oeoriSub,4)),"^",9)
	..q:(OEORIAnDr="")!(OEORIAnDr'=OPAAnaestDr)  //非此台手术所录费用退出
	..s UnPaidFlag="N"
	..;s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    ..;s arcimStr=$g(^ARCIM(+arcimId,1,1))
    ..;s arcicId=$p(arcimStr,"^",10)
    ..;i arcicId=needArcicId s UnPaidFlag="N" q
    .i UnPaidFlag'="N" s UnPaidFlag="Y" q
	q UnPaidFlag
}

/// Creator: wangxinlei
/// CreatDate: 2009-07-27
/// Description: 设定科室的医嘱在需关注中不出现
/// Table：OE_Order,CT_Loc
/// Input：OEORIId:医嘱的RowId
/// Return：开医嘱科室是设定科室返回 1,否则返回 0 
ClassMethod UnNeedExecLocOrd(OEORIId) As %String
{
 	q:OEORIId="" 0
 	s UnNeedExecLocId=$g(^DHCCLSet("Disch","UnNeedExecLocId"))
 	q:UnNeedExecLocId="" 0
 	s OEORDId=$p(OEORIId,"||",1)
 	s OEORISub=$p(OEORIId,"||",2)
 	q:(OEORDId="")||(OEORISub="") 0
 	s CTLOCId=$p($g(^OEORD(OEORDId,"I",OEORISub,7)),"^",2)
	q:CTLOCId="" 0
	s CTLOCId="^"_CTLOCId_"^"
	s UnNeedExecLocId="^"_UnNeedExecLocId_"^"
	q:UnNeedExecLocId[CTLOCId 1
	q 0
}

/// Creator: pjf
/// CreatDate: 2009-09-21
/// Description: 判断病人是否有出院带药
/// Table：OE_Order,OE_OrdItem,OEC_OrderStatus,OEC_Priority,ARC_ItmMast,ARC_ItemCat,OEC_OrderCategory
/// Input：EpisodeID:病人就诊ID
/// Return：出院带药的医嘱大类 
ClassMethod DisTakeDruge(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s retstr=""
	s oeoriSub=0,oeoreIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	    ..s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        ..q:ordStatCode'="V"    //状态非核实的医嘱退出
        ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        ..q:oecprCode'="OUT"    //优先级非出院带药退出
        ..s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
        ..i orcatId'=""  s orcatdesc=$p($g(^OEC("ORCAT",orcatId)),"^",2) //取出医嘱大类
        ..e  s orcatdesc=""
        ..i retstr=""  s retstr=orcatdesc
        ..q:retstr[orcatdesc
        ..s retstr=retstr_","_orcatdesc  
	q retstr
}

/// Creator: pjf
/// CreatDate: 2009-09-21
/// Description: 取需关注中未处理情况
/// Table：^DHCCLSet("Disch","AbnormalStat")
/// Input：
/// Return：未处理情况,序号
Query LookUpType() As %Query(ROWSPEC = "未处理情况,序号")
{
}

ClassMethod LookUpTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
  	s str=^DHCCLSet("Disch","AbnormalStat")
  	s num=$l(str,"^")
  	f i=1:1:num d
  	.s AbnormalStat=$p(str,"^",i)
  	.d OutputRow        
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s Data=$lb(AbnormalStat,i)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTypeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 判断病人当前所在科室

ClassMethod GetPatLoc(Adm As %String)
{
  	
  	q:Adm="" "就诊id不存在"
    s dep=""
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl),-1) q:(chl="")||(dep'="")  d
    .s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
    .q:loc=""
    .s dep=loc
     i dep'="" s dep=$p($p(^CTLOC(dep),"^",2),"-",2)
     q dep
}

ClassMethod ISendDischargeInfo(Adm As %String)
{
	s res=0
	q:Adm="" res
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMOUTINFO",Adm)
    s rtnmes1=$p(rtn,"^")
    s rtnmes2=$p(rtn,"^",2)
    i rtnmes1'=0 s res=rtnmes2
    q rtnmes1
}

ClassMethod ISendCancelDisInfo(Adm As %String)
{
	s res=0
	q:Adm="" res
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMCANCELOUTINFO",Adm)
    s rtnmes1=$p(rtn,"^")
    s rtnmes2=$p(rtn,"^",2)
    i rtnmes1'=0 s res=rtnmes2
    q res
}

}
