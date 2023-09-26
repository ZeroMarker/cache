Import sqluser

Class web.UDHCCLDischarge Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetUserType(userId As %String) As %String
{
	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcpIntType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcpIntType="" "医护人员类型定义有误!"
	q ctcpIntType
}

ClassMethod GetUnReturnDrug(EpisodeID As %String) As %String
{
	//药停了但未作退药处理
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	//s ^ypzDebug(oeordId)=EpisodeID
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s oeoriId=oeordId_"||"_oeoriSub
		.s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    	.q:ordStatCode'="D"
	    .s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	    .q:arcicOrderType'="R"
		.s oeoreSub=0  f  s oeoreSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:(oeoreSub="")  d
    		..s dspSub=0  f  s dspSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
    			...s dspStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub) 
    			...s Stat=$P(dspStr,"^",6)
    			...q:Stat'="C"
    			...i +$p(dspStr,"^",7)=0 d
	    			....i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    			....s oeoriIdStr=oeoriIdStr_oeoriId
    q oeoriIdStr
}

ClassMethod GetAbnormalOrder(EpisodeID As %String, userId As %String = "") As %String
{
	f i=1:1:30 s $p(retStr,"^",i)=0	
	q:EpisodeID="" "无病人ADM号!^0^0^0^"_retStr
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" "无病人病区!^0^0^0^"_retStr
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" "0^0^0^0^"_retStr
	s standToday=0,unExec=0,verifyLabOrd=0,verifyExamOrd=0
	s shouldCollectOrder=0,unReturnDrug=0,shouldDisconOrder=0

	s abnormSeq=$g(^DHCCLSet("Disch","AbnormalSeq"))
	
	s disconInd=..GetAdmOrderC(EpisodeID)
	s ordNum=+$o(^mPLIST(disconInd,""),-1) //ypz 070319
	s oeoriIdStr=""
	i userId=""  s userId=%session.Data("LOGON.USERID")                           //Wkz 080114
	i userId'="" s curCPType=##Class(web.UDHCCLDischarge).GetUserType(userId)    //Wkz 080114
	f iOrd=1:1:ordNum d
	    .//s ordStatusDesc=$li(^mPLIST(disconInd,iOrd),4)
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode($lg(^mPLIST(disconInd,iOrd),13))
	    .s OeorCPType=##Class(web.UDHCCLDischarge).GetUserType($lg(^mPLIST(disconInd,iOrd),15))   //Wkz 080114
	    .i (("V"=ordStatCode)!("E"=ordStatCode))&((OeorCPType="DOCTOR")!(curCPType="NURSE")) d    //Wkz 080114
	        ..i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	        ..s oeoriIdStr=oeoriIdStr_$lg(^mPLIST(disconInd,iOrd),13)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",1)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",1))=oeoriIdStr
	i oeoriIdStr'="" s $p(retStr,"^",$p(abnormSeq,"^",1))="该病人有 "_$l(oeoriIdStr,"^")_" 条今天的长期医嘱未停!  "
	s oeoriIdStr=..GetUnexecOrder(EpisodeID,userId)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",2)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",2))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",2))="该病人有"_$l(oeoriIdStr,"^")_"条医嘱未执行, 请执行医嘱!  "
	s oeoriIdStr=..GetVerifyLabOrder(EpisodeID)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",3)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",3))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",3))="该病人有"_$l(oeoriIdStr,"^")_"条检验医嘱未做检验, 请做检验或停医嘱!  "
	s oeoriIdStr=..GetVerifyExamOrder(EpisodeID)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",4)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",4))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",4))="该病人有"_$l(oeoriIdStr,"^")_"条检查医嘱未做检查, 请做检查或停医嘱!  "
	s oeoriIdStr=..GetShouldCollectOrder(EpisodeID)
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",5)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",5))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",5))="该病人有"_$l(oeoriIdStr,"^")_"条未领药医嘱(不含今天长嘱), 请领药或停医嘱!  "
	s oeoriIdStr=..GetUnReturnDrug(EpisodeID)  //药停了但未作退药处理
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",6)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",6))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",6))="该病人有"_$l(oeoriIdStr,"^")_"条停止医嘱未做退药处理!  "
	s oeoriIdStr=..GetShouldDisconOrder(EpisodeID)  //必须停但未停的医嘱
	i $g(^TMP("Discon",$i))="Y",$p(abnormSeq,"^",7)'="" s ^TMP("Discon",$i,$p(abnormSeq,"^",7))=oeoriIdStr
	i (oeoriIdStr'="")&(curCPType="NURSE") s $p(retStr,"^",$p(abnormSeq,"^",7))="该病人有"_$l(oeoriIdStr,"^")_"条必须停止医嘱未停!  "
	s NeedItmCat=^DHCCLSet("Disch","NeedOrdCat")                  //WKZ 080116  S
	s NeedFlage=..IfOpItmCat(EpisodeID, NeedItmCat)
	//i ($p(abnormSeq,"^",8)'="")&(NeedFlage'=1) s $p(retStr,"^",$p(abnormSeq,"^",8))="该病人未开"_$P($G(^ARC("IC",NeedItmCat)),"^",2)_"医嘱"
	i ($p(abnormSeq,"^",8)'="")&(NeedFlage'=1)&(NeedItmCat'="") s $p(retStr,"^",$p(abnormSeq,"^",8))="该病人未开"_$P($G(^ARC("IC",NeedItmCat)),"^",2)_"医嘱"    //xuqy 080412
	s NeedTransItmCat=^DHCCLSet("Disch","NeedTransOrdCat")                  
	s NeedTransFlage=..IfOpItmCat(EpisodeID, NeedTransItmCat)
	//i ($p(abnormSeq,"^",9)'="")&(NeedTransFlage'=1) s $p(retStr,"^",$p(abnormSeq,"^",9))="该病人未开"_$P($G(^ARC("IC",NeedTransItmCat)),"^",2)_"医嘱"    //WKZ 080116  E
	i ($p(abnormSeq,"^",9)'="")&(NeedTransFlage'=1)&(NeedTransItmCat'="") s $p(retStr,"^",$p(abnormSeq,"^",9))="该病人未开"_$P($G(^ARC("IC",NeedTransItmCat)),"^",2)_"医嘱"    //xuqy 080412

	//s retStr=standToday_"^"_disconInd_"^"_unExec_"^"_verifyLabOrd_"^"_verifyExamOrd_"^"_shouldCollectOrder_"^"_unReturnDrug
	//s retStr=standToday_"^"_unExec_"^"_verifyLabOrd_"^"_verifyExamOrd_"^"_shouldCollectOrder_"^"_unReturnDrug_"^"_shouldDisconOrder
	s alertItem=$g(^DHCCLSet("Disch","AlertItem"))
	s canDisch="Y"
	f i=1:1:$l(retStr,"^") d
	    .i $p(alertItem,"^",i)'="Y",$p(abnormSeq,"^",i)'="" d
	        ..s $p(retStr,"^",$p(abnormSeq,"^",i))=0
	        ..k ^TMP("Discon",$i,$p(abnormSeq,"^",i))
	    .i $p(retStr,"^",i)'=0 s canDisch="N"
	s $p(retStr,"^",31)=disconInd
	i $g(^DHCCLSet("Disch","CanDisch"))="Y" s canDisch="Y"
	s retStr=retStr_"^"_canDisch
	s retStr=retStr_"^"_$g(^DHCCLSet("Disch","TransDiscon"))
	s retStr=retStr_"^"_..GetDiagnosType(EpisodeID)
	q retStr
}

ClassMethod DisconLongOrder(ordStrsInd As %String, EpisodeID As %String = "", ctcptType As %String = "", userId As %String = "", transLocId As %String = "", disconDesc As %String = "") As %String
{
	//停当日的长期医嘱w ##Class(web.DHCCLDischarge).DisconLongOrder(166)
	q:(ordStrsInd="") -1
	i transLocId'=""
	{
		s admLocId=""
		i EpisodeID'=""	s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		q:admLocId=transLocId 0
	}
	s disconDeadFlag=""
	i ctcptType="DOCTOR"
	{
		s disconId=0
		s disconDesc=$$ALPHAUP^SSUTIL4(disconDesc)
		i disconDesc'="" s disconId=$o(^PAC("DISCON",0,"Desc",disconDesc,""))
		q:disconId="" 0
		s disconDeadFlag=$p($g(^PAC("DISCON",disconId)),"^",3)
		i disconDeadFlag'="D" q 0
	}
	s count=0
	i ordStrsInd>0 s count=$o(^mPLIST(ordStrsInd,""),-1)
	s err=0
  	for i=1:1:count
   	{  
    	s oeitm=$lg(^mPLIST(ordStrsInd,i),13)

    	////////s err=##Class(web.UDHCStopOrderLook).discon(oeitm, UserID, PinNum)
    	s oldnamespace=$ZNSPACE
        s datanamespace=$LIST(^websys.ConfigurationD(1),12)
        zn datanamespace
        s err=$$discon^DHCCLDiscon(oeitm,"","")  //yu 
        ////s err=$$discon^SMLPrescLook(oeitm, user, pinnumber)
        zn oldnamespace
    	i err'=0 quit  
        
        s unCollect=1,oeoreSub=0,oeoriSub=$p(oeitm,"||",2)
        f  s oeoreSub=$o(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
            .s dspSub=0
            .f  s dspSub=$o(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:dspSub=""  d
                ..i $p(^OEORD(+oeitm,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6)="C" s unCollect=0
    	//w !,oeitm," unCollect="_unCollect
    	i unCollect=1 s err=..Collect(oeitm)
   	}
   	i err'=0 q err
   	i (ctcptType="DOCTOR")&(disconDeadFlag="D")
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
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoriId=oeordId_"||"_oeoriSub
	    .s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	    .q:reclocId=""
	    .q:$p(^CTLOC(reclocId),"^",13)'="D"
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
        .q:ordStatCode'="V"
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
        .q:(oecprCode="OM")!(oecprCode="OMST") // i oecprDesc["自备药" q
        .q:($g(^DHCCLSet("Disch","TakeDisDrug"))'="Y")&(oecprCode="OUT") //ypz 070605
        .s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
        .q:(oeoriDate=+$h)&(oecprCode="S")  //i (oeoriDate=+$h)&(oecprDesc["长期") q
        .s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoriId)
	    .q:(dispenStat="C")!(dispenStat="")
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
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

ClassMethod GetAdmOrderC(NowAdm)
{
	//n (NowAdm,Arcim,dayflag,longflag,shortflag,user,lulocdes)
    s luloc=""
    s lulocdes=$g(lulocdes)
    i lulocdes'="" s luloc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(lulocdes),""))  
    s longflag=1
	s dayflag=1
	s shortflag=0,lulocdes=""
	q:$g(NowAdm)="" -1
	s visstat=$p(^PAADM(NowAdm),"^",20)     
	q:$g(visstat)'="A" -1        ;已经出院结算的患者不能处理医嘱

	s ord="" s ord=$o(^OEORD(0,"Adm",NowAdm,ord)) q:ord="" -1
	s i=0
	s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.k UserDR,UserName
	.q:'$D(^OEORD(ord,"I",chl,3))
	.s Oepriortydr=$p(^OEORD(ord,"I",chl,1),"^",8) ;医嘱优先级
	.i $g(Oepriortydr)'="" s priortycode=$p(^OECPR(Oepriortydr),"^",1)
	.s priortycode=$g(priortycode) 
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.q:(dayflag=1)&($g(Sttdate)'=+$h) ;flag=1时，只保留当天的医嘱                     
	.q:(longflag=0)&((priortycode="S")!(priortycode="OMST")) ;longflag=0,不保留长期医嘱
	.q:(shortflag=0)&((priortycode="STAT")!(priortycode="PRN")!(priortycode="NORM")!(priortycode="ONE")!(priortycode="OM")!(priortycode="OUT"))  ;shortflag=0,不保留短期医嘱
    .s reploc=$p(^OEORD(ord,"I",chl,3),"^",6)                                     ;医嘱接收位置
	.s Arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) 
	.q:$g(Arcimid)=""
	.q:'$d(^ARCIM($P(Arcimid,"||",1),$P(Arcimid,"||",2),1))  ;医嘱 ARC_ItmMast ARCIM_RowId       
	.s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)  ;医嘱名称
	.s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7)  ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.q:'$d(^OEORD(ord,"I",chl,1))
	.s xintmp=$p(^OEORD(ord,"I",chl,1),"^",13)
	.q:$g(xintmp)=""
	.q:'$d(^OEC("OSTAT",xintmp))
	.q:'$d(^OEORD(ord,"I",chl,3))
	.s xintmp=$p(^OEORD(ord,"I",chl,3),"^",5)  ; oeori_billed
	.q:$g(xintmp)="P"
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1) ;医嘱状态
	.q:(oeflag="D")!(oeflag="E")!(oeflag="I")   ;已停止的、已执行医嘱，未激活的不做处理 
	.s XUserDR=""
	.i $d(^OEORD(ord,"I",chl,7)) s XUserDR=$p(^OEORD(ord,"I",chl,7),"^",1)                                  ;下医嘱人ID
	.s XUserName=""
	.s:$g(XUserDR)'="" XUserName=$p(^SSU("SSUSR",XUserDR),"^",2) ;下医嘱人的Initials
	.i ($g(arctype)="R")&(priortycode'="OM")&(priortycode'="OMST") d
	..;-------------------------------药物---------------------------------------------------------  
	..
	..
	..
	..s disconMark="N"  //ypz add 070314
	..s oeoriId=ord_"||"_chl
	..s dhcDspId=0,checkedFlag="N"
    ..f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ...s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ...q:dhcDspStat="R"
    ...q:checkedFlag="Y"
	...i oeflag="D" s dhcDspStat="C"  //ypz add 070314
	...q:disconMark="Y"  //ypz add 070314
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)              ;医嘱 ARC_ItmMast ARCIM_RowId
	...//s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2) ;INCLB_RowId
	...//s inci=$p(inclbid,"||",1)                              ;INCI_RowId
	...q:$p(^OEORD(ord,"I",chl,1),"^",8)=""
	...s i=i+1
	...s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	...i $g(Sttdate)'="" s sttd(i)=$ZD(Sttdate,3)  e  s sttd(i)=""
	...i dhcDspStat="C" s status(i)="已发"
	...i dhcDspStat="TC" s status(i)="未发"
	...s xuserid(i)=$g(XUserDR)
	...s xusername(i)=$g(XUserName) 
	...s OEORIOEORIDR(i)="" 
	...i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	...i OEORIOEORIDR(i)'="" s ARCimDesc="____"_ARCimDesc   //lgl + 关联医嘱
	...s arcdesc(i)=ARCimDesc
	...s ordch(i)=ord_"||"_chl                                ;医嘱名称
	...s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)             ;医嘱序号     
	...s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)            ;医嘱处方号
	...s qty(i)=$P(^DHCOEDISQTY(dhcDspId),"^",5)  ;发药数量       
	...s uom(i)=$P(^DHCOEDISQTY(dhcDspId),"^",6)  //$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;药品基本库存单位
	...s date(i)=$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)       ;下医嘱时间
	...q:$D(^OEORD(ord,"I",chl,2))=0                          
	...s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)            ;用药剂量
	...i $p(^OEORD(ord,"I",chl,2),"^",3)'="" s doseuom(i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)          ;剂量单位
	...e  s doseuom(i)="*"
	...i $p(^OEORD(ord,"I",chl,2),"^",4)'="" d           
	....s freq(i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",3)
	...e  s freq(i)="*"             ;用药频率
	...i $p(^OEORD(ord,"I",chl,2),"^",6)="" s dur(i)="*"
	...e  s dur(i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)    ;用药疗程
	...i $p(^OEORD(ord,"I",chl,2),"^",7)="" s inst(i)="*"
	...e  s inst(i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",1)   ;用法
	...i $f(inst(i),"-")  s inst(i)=$p(inst(i),"-",2)
	...s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)   ;医嘱优先级代码 
	...s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2) ;医嘱状态     
	...s recloc(i)=""                                   ;医嘱价格
	...s reploc(i)=$p(^CTLOC(reploc),"^",2)             ;接收科室
	...i $f(reploc(i),"-")  s reploc(i)=$p(reploc(i),"-",2)                                                     
	...s dosage(i)=dosage(i)_" "_doseuom(i)
	...i $l(qty(i))>6 s qty(i)=$e(qty(i),1,6)  
	...s qty(i)=qty(i)_" "_uom(i)
	...s locex=..getlocEx(ord,chl,NowAdm)  //cwg2006-5-13查询医嘱人所在科室、执行状态、系统时间、执行人
	...s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
    ...i $p(^OEORD(ord,"I",chl,2),"^",7)="" d  ;Edited   By cwg,用法
	....s usemethod(i)=""
	...e  s usemethod(i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2) 
	...s OID=..GETOID(ord,chl)    //通过fillerno取得原始医嘱的日期
	...i OID'="" d 
	....s Ow=$P(OID,",",1)
	....s cl=$P(OID,",",2)
	....s begindate(i)=$p((^OEORD(Ow,"I",cl,11)),"^",4)
	....if begindate(i)'="" s begindate(i)=$zd(begindate(i),3)
	...i oeflag="D" s disconMark="Y"  //ypz add 070314
    ...s checkedFlag="Y"
	..
	..q //ypz 080712
	..
	..s ex=0 f  s ex=$o(^OEORD(ord,"I",chl,"X",ex)) q:ex=""  d                     ;
	...s dis=0 f  s dis=$o(^OEORD(ord,"I",chl,"X",ex,"D",dis)) q:dis=""  s disp=^(dis) d   ;
	....s dstatus=$p(disp,"^",6)                                                   ;
	....i oeflag="D" s dstatus="C"  //ypz add 070314
	....q:disconMark="Y"  //ypz add 070314
	....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)              ;医嘱 ARC_ItmMast ARCIM_RowId
	....s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2) ;INCLB_RowId
	....s inci=$p(inclbid,"||",1)                              ;INCI_RowId
	....q:$p(^OEORD(ord,"I",chl,1),"^",8)=""
	....s i=i+1
	....s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	....i $g(Sttdate)'="" s sttd(i)=$ZD(Sttdate,3)  e  s sttd(i)=""
	....i dstatus="C" s status(i)="已发"
	....i dstatus="P" s status(i)="未发"
	....s xuserid(i)=$g(XUserDR)
	....s xusername(i)=$g(XUserName) 
	....s OEORIOEORIDR(i)="" 
	....i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	....i OEORIOEORIDR(i)'="" s ARCimDesc="____"_ARCimDesc   //lgl + 关联医嘱
	....s arcdesc(i)=ARCimDesc
	....s ordch(i)=ord_"||"_chl                                ;医嘱名称
	....s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)             ;医嘱序号     
	....s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)            ;医嘱处方号
	....s qty(i)=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",1)  ;发药数量       
	....s uom(i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;药品基本库存单位
	....s date(i)=$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)       ;下医嘱时间
	....q:$D(^OEORD(ord,"I",chl,2))=0                          
	....s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)            ;用药剂量
	....i $p(^OEORD(ord,"I",chl,2),"^",3)'="" s doseuom(i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)          ;剂量单位
	....e  s doseuom(i)="*"
	....i $p(^OEORD(ord,"I",chl,2),"^",4)'="" d           
	.....s freq(i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",3)
	....e  s freq(i)="*"             ;用药频率
	....i $p(^OEORD(ord,"I",chl,2),"^",6)="" s dur(i)="*"
	....e  s dur(i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)    ;用药疗程
	....i $p(^OEORD(ord,"I",chl,2),"^",7)="" s inst(i)="*"
	....e  s inst(i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",1)   ;用法
	....i $f(inst(i),"-")  s inst(i)=$p(inst(i),"-",2)
	....s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)   ;医嘱优先级代码 
	....s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2) ;医嘱状态     
	....s recloc(i)=""                                   ;医嘱价格
	....s reploc(i)=$p(^CTLOC(reploc),"^",2)             ;接收科室
	....i $f(reploc(i),"-")  s reploc(i)=$p(reploc(i),"-",2)                                                     
	....s dosage(i)=dosage(i)_" "_doseuom(i)
	....i $l(qty(i))>6 s qty(i)=$e(qty(i),1,6)  
	....s qty(i)=qty(i)_" "_uom(i)
	....s locex=..getlocEx(ord,chl,NowAdm)  //cwg2006-5-13查询医嘱人所在科室、执行状态、系统时间、执行人
	....s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
    ....i $p(^OEORD(ord,"I",chl,2),"^",7)="" d  ;Edited   By cwg,用法
	.....s usemethod(i)=""
	....e  s usemethod(i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2) 
	....s OID=..GETOID(ord,chl)    //通过fillerno取得原始医嘱的日期
	....i OID'="" d 
	.....s Ow=$P(OID,",",1)
	.....s cl=$P(OID,",",2)
	.....s begindate(i)=$p((^OEORD(Ow,"I",cl,11)),"^",4)
	.....if begindate(i)'="" s begindate(i)=$zd(begindate(i),3)
	....i oeflag="D" s disconMark="Y"  //ypz add 070314
	..
	. e  d  ;-------------------------------非药物-------------------------------------------
	..s i=i+1
	..s xuserid(i)=$g(XUserDR)
	..s xusername(i)=$g(XUserName) 
	..q:$g(xintmp)="P"   ; 已经是Paid状态的医嘱不能处理
	..s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	..i $g(Sttdate)'="" s sttd(i)=$ZD(Sttdate,3)  e  s sttd(i)=""
	..s status(i)=""
	..//s arcdesc(i)=ARCimDesc
	..s ordch(i)=ord_"||"_chl                                         ;医嘱名称
	..s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)                      ;医嘱序号     
	..s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)                     ;医嘱处方号
	..i $p(^OEORD(ord,"I",chl,1),"^",8)'="" d
	...s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2) ;医嘱优先级代码  
	..e  s ordtype(i)=""
	..s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2) ;医嘱核实、未核实、停止状态 
	..s date(i)=$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)                     ;下医嘱时间
	..s reploc=$p(^OEORD(ord,"I",chl,3),"^",6)  
	..;s reploc(i)=""
	..i $g(reploc)'="" s reploc(i)=$p(^CTLOC(reploc),"^",2)                ;接受科室
	..i $f($g(reploc(i)),"-")  s reploc(i)=$p(reploc(i),"-",2)                                                     
	..s OEORIOEORIDR(i)=""
	..i $d(^OEORD(ord,"I",chl,11)) d
	...s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	..i (OEORIOEORIDR(i)'="") s ARCimDesc="____"_ARCimDesc   //lgl xiugai
	..s arcdesc(i)=ARCimDesc
	..q:$d(^OEORD(ord,"I",chl,2))=0 
	..s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)
	..s qty(i)=$p(^OEORD(ord,"I",chl,1),"^",12) 
	..s freq(i)=""
	..s inst(i)=""
	..s patientsort(i)=$p(^PAADM(NowAdm),"^",2)  //cwg061028
	..s locex=..getlocEx(ord,chl,NowAdm)  //cwg2006-5-13查询医嘱人所在科室、执行状态、系统时间、执行人
	..s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
	..i $p(^OEORD(ord,"I",chl,2),"^",7)="" d   ;Edited   By cwg,用法
	...s usemethod(i)="" 
	..e  s usemethod(i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2) 
	s tmpid=$I(^mPLIST)
	F j=1:1:i d
	  .s ret=..Getdocloc($g(xuserid(j)),$G(luloc))
	  .q:ret="N"
	  .s ^mPLIST(tmpid,j)=$lb(seqno(j),arcdesc(j),ordtype(j),oeflag(j),date(j),status(j),qty(j),reploc(j),presc(j),dosage(j),freq(j),inst(j),ordch(j),$g(sttd(j)),$g(xuserid(j)),$g(xusername(j)),$g(OEORIOEORIDR(j)),$g(usemethod(j)),$G(docloc(j)),$G(exflag(j)),$g(begindate(j)),$g(xtsj(j)),$g(zxr(j)),$g(patientsort(j)),$g(notes(j)))
	  .; w !,^mPLIST(tmpid,j)
	m ^xintmp=^mPLIST(tmpid)
	q tmpid
}

ClassMethod Getdocloc(user, Loc)
{
         //n (user,Loc)
         s res="Y"
         q:Loc="" "Y"
	     q:user="" "N"
         s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	     //b
	     //q:($G(CpTyp)'="DOCTOR") "N"  //////////////2005-12-3 qse add
	     s truedoc=0
	     s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	     f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	     .if Loc=DocLoc  s truedoc=1
         i truedoc'=1 s res="N" 
 q res
}

ClassMethod GETOID(Oew, oeoriSub)
{
	  //n (Oew,oeoriSub)
	  s oid=$P($G(^OEORD(Oew,"I",oeoriSub,9)),"^",12)
	  i oid'="" d
	  .s OPar=$P(oid,"!!",1)
	  .s par=$P(OPar,"||",1)
	  .s chl=$P(OPar,"||",2)
	  .s RowId=par_","_chl
	  q $G(RowId)
}

ClassMethod getlocEx(oew, chl, NowAdm) As %String
{
	//cwg2006-5-13查询医嘱人所在科室、执行状态、系统时间、执行人
	//n (oew,chl,NowAdm)
	s zycat=0
	 s OeorIDr=oew_"||"_chl
     &sql(select PAADM_DepCode_DR,PAADM_CurrentWard_DR into :AdmLoc,:AdmWard from Pa_Adm where paadm_rowid=:NowAdm)
     &sql(select   OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR into :zycat  from   oe_orditem  where   oeori_rowid=:OeorIDr)
	 &sql(select oeore_ctpcp_dr->ctpcp_id,oeore_order_status_dr->stat_desc into :excpt,:execStat from oe_ordexec where oeore_oeori_parref=:OeorIDr)
      //cwg061028
      i $p(^PAADM(NowAdm),"^",2)="O" s WardNurse=""
      i $p(^PAADM(NowAdm),"^",2)="I" s WardNurse=$p(^PAWARD(AdmWard),"^",5)
      
      i $d(^OEORD(oew,"I",chl,1))  d
       .s DoctorDr=$P($G(^OEORD(oew,"I",chl,1)),"^",11)
         
	     s doctor=""
	     s nurse=""
	     //2006-5-13 cwg add
	     s DocLoc="" 
	     i $g(DoctorDr)'="" d
	     .f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:(DocLoc="")!(AdmLoc=doctor)!(WardNurse=doctor)  d
	       ..s doctor=DocLoc
	     i $g(doctor)'="" s DocLoc=doctor
	     i $g(DoctorDr)="" d
	      .s DocLoc=WardNurse
	    // .if $D(^TMP($J,"loc",EpisodeID,DocLoc))  s truedoc=1
	    if ($G(execStat)'="")&($g(zycat)'=30)  s flag="已执行"  //zycat不等于药物医嘱30
	    else  s flag="未执行"
	    i flag="未执行" s excpt=""
	    q $G(DocLoc)_"^"_$G(flag)_"^"_$zd($h,3)_"^"_$G(excpt)
}

ClassMethod GetVerifyLabOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoriId=oeordId_"||"_oeoriSub
	    .s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	    .q:arcicOrderType'="L"
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
        .q:ordStatCode'="V"
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
        .s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
}

ClassMethod GetVerifyExamOrder(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoriId=oeordId_"||"_oeoriSub
	    .//s orsubcatId=##Class(web.DHCCLCom).GetOrdSubCatId(oeoriId) q:$g(orsubcatId)=210 ///医嘱子类
	    .s orsubcatId=##Class(web.DHCCLCom).GetOrdSubCatId(oeoriId)
	    .s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoriId)
	    .q:$g(orcatId)=""
	    .q:$g(orcatId)=3  //医嘱大类（放射检查）
	    .q:($g(orcatId)=8)&(orsubcatId'=235)   //医嘱大类( 除超声)
	    .s ocgrpId=$p(^OEC("ORCAT",orcatId),"^",15) //OEC_OrderCategoryGroup
	    .q:ocgrpId=""
	    .s ocgrpCode=$p(^OEC("OCGRP",ocgrpId),"^",1)
	    .q:ocgrpCode'="EXAM"
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
        .q:ordStatCode'="V"
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
        .s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
}

ClassMethod GetUnexecOrder(EpisodeID As %String, userId As %String = "") As %String
{
	q:EpisodeID="" ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" ""
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoriId=oeordId_"||"_oeoriSub
	    .s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoriId)
	    .q:orcatId="" 
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
        .i (ordStatCode="V")&(oecprCode="OUT") d
			..s oeoreSub=0  f  s oeoreSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:(oeoreSub="")  d
    			...s dspSub=0  f  s dspSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
    				....s oreStr=$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
    				....q:oreStr=""
    				....i $p(oreStr,"^",15)="" d
    				    .....s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)=ctcpId
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)=$o(^OEC("STAT",0))
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)=+$h
    				    .....//s $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)=$p($h,",",2)
    				    .....s statId=$o(^OEC("STAT",0))
    				    .....s curDate=+$h,curTime=$p($h,",",2)
    				    .....s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    				    .....&Sql(update OE_ORDEXEC set OEORE_CTPCP_DR=:ctcpId,OEORE_Order_Status_DR=:statId,OEORE_DateExecuted=:curDate,OEORE_TimeExecuted=:curTime where OEORE_RowId=:oeoreId)
	    .q:("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^")
	    .s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    	.q:userAddId=""
    	.s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    	.q:ctcpId=""
    	.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
		.q:ctcptId=""
    	.s ctcpIntType=$P($g(^CT("CPT",ctcptId)),"^",4)
    	.q:ctcpIntType'="DOCTOR"
        .s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,"DOCTOR","",oeoriId)
        .q:curDocFlag'="Y"
    	.i ##Class(web.DHCNurCom).IfExecOrder(oeoriId)=1 q
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
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

Query LookUpAbnormalOrder(EpisodeID As %String) As %Query(ROWSPEC = "arcimDesc,abnormalDesc,regNo,oecprDesc,patName,bedCode,ordStatDesc,updateDateTime,sttDateTime,execCtcpDesc,execXUserDesc,ctcpDesc,dispenStat,reclocDesc,labNo,doseQtyUnit,phcfrCode,phcinDesc,oeoriId")
{
}

ClassMethod LookUpAbnormalOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i EpisodeID="" s qHandle=$lb(0,repid,0) q $$$OK
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	i wardId="" s qHandle=$lb(0,repid,0) q $$$OK
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	i oeordId="" s qHandle=$lb(0,repid,0) q $$$OK
	
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
	s regNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
	s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1)
	
	k ^TMP("Discon",$i)
	s ^TMP("Discon",$i)="Y"
	s resStr=..GetAbnormalOrder(EpisodeID)
	
	s abnormSeq=$g(^DHCCLSet("Disch","AbnormalSeq"))
	s abnormStatStr=$g(^DHCCLSet("Disch","AbnormalStat"))
	s node=""
	f  s node=$o(^TMP("Discon",$i,node)) q:node=""  d
	    .s oeoriIdStr=^TMP("Discon",$i,node)
	    .q:oeoriIdStr=""
	    .
	    .s pos=0
	    .f i=1:1:$l(abnormSeq,"^") d
	        ..i $p(abnormSeq,"^",i)=node s pos=i
	    .i pos>0 s abnormalDesc=$p(abnormStatStr,"^",pos)
	    .f i=1:1:$l(oeoriIdStr,"^") d
	        ..s oeoriId=$p(oeoriIdStr,"^",i)
	        ..q:oeoriId=""
	        ..s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	        ..q:oeoriSub=""
	        ..s arcimStr=##Class(web.DHCNurCom).GetArcim(oeoriId)
	        ..s arcimDesc=$p(arcimStr,"^")
	        ..s doseQtyUnit=$p(arcimStr,"^",2)
	        ..s oecprDesc=$p(arcimStr,"^",3)
	        ..s phcfrCode=$p(arcimStr,"^",4)
	        ..s phcinDesc=$p(arcimStr,"^",5)
	        ..s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	        ..s ordStatDesc=""
	        ..i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
	        ..s updateDateTime=""
	        ..s updateDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    		..s updateTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    		..s updateDateTime=##Class(web.DHCCLCom).FormatDate(updateDate)_" "_##Class(web.DHCCLCom).FormatTime(updateTime)
	        ..s sttDateTime=""
	        ..s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    		..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    		..s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
	        ..s execCtcpDesc=""
	        ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	        ..i oeoreSub'="" d
	            ...s oreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
	            ...i $p(oreStr,"^",15)'="" d
                    ....s execCtcpDesc=$p($g(^CTPCP($p(oreStr,"^",15),1)),"^",2)
    		..s execXUserDesc=""
    		..s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoriId)
			..i $p(xOrdExecStr,"^")'="" d //ypz 070207
				...s execXUserId=$p(xOrdExecStr,"^")
        		...i execXUserId'="" s execXUserDesc=$p($g(^SSU("SSUSR",execXUserId)),"^",2)
 	        ..s ctcpDesc=""
   			..s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    		..s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    		..i ctcpId'="" s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	        ..s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoriId)
	        ..i dispenStat="C" s dispenStat="已发"
	        ..i dispenStat="TC" s dispenStat="未发"
	        ..i dispenStat="P" s dispenStat="未发"
	        ..s reclocDesc=""
	        ..s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    		..i reclocId'="" s reclocDesc=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
	        ..s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
	        ..
	        ..
	        ..d OutputRow
 	s qHandle=$lb(0,repid,0)
 	k ^TMP("Discon",$i)
	q $$$OK
    
OutputRow
	s Data=$lb(arcimDesc,abnormalDesc,regNo,oecprDesc,patName,bedCode,ordStatDesc,updateDateTime,sttDateTime,execCtcpDesc,execXUserDesc,ctcpDesc,dispenStat,reclocDesc,labNo,doseQtyUnit,phcfrCode,phcinDesc,oeoriId)
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
  	s dtypIdStr=$g(^DHCCLSet("Disch","DiagTypeId"))
  	q:dtypIdStr="" 0
  	s mradmId=$P(^PAADM(EpisodeID),"^",61)
  	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
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
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	    .s oeoriId=oeordId_"||"_oeoriSub
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
        .q:ordStatCode'="V"
        .s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
        .q:arcimId=""
        .q:("^"_mustDisconArcimId_"^")'[("^"_arcimId_"^")
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	q oeoriIdStr
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
    i (icu="Y")&&($d(^ARCIM(15633,1))) d addorder^aOET13("15633||1",EpisodeID,"",".5","","","1004",+$h,curTime,recloc)   //监护费(进口心电监护病房)
    i ((icu="Y")!(bedtypedesc="普通单人间"))&&($d(^ARCIM(19905,1))) d addorder^aOET13("19905||1",EpisodeID,"",".5","","","1002",+$h,curTime,recloc)    //护理费
    i ((icu="Y")!(bedtypedesc="普通单人间"))&&($d(^ARCIM(19906,1))) d addorder^aOET13("19906||1",EpisodeID,"",".5","","","1003",+$h,curTime,recloc)    //诊疗费
    i ((icu'="Y")&&(bedtypedesc'="普通单人间"))&&($d(^ARCIM(19454,1))) d addorder^aOET13("19454||1",EpisodeID,"",".5","","","1002",+$h,curTime,recloc)    //护理费
    i ((icu'="Y")&&(bedtypedesc'="普通单人间"))&&($d(^ARCIM(15655,1))) d addorder^aOET13("15655||1",EpisodeID,"",".5","","","1003",+$h,curTime,recloc)    //诊疗费

    s bedtype=$p($g(^PAWARD(+preBedId,"BED",+$p(preBedId,"||",2))),"^",2)
    s preArcim=$p($g(^PAC("BEDTP",+bedtype)),"^",4)
    //s alredarc=arcim

    i preArcim="" d
    .//w "Err! No Arcim - Bed: ",bed
    .s index=$o(^["MEDDATA"]TSABatch("CHBB1",+$h,"Day",$j,""),-1)+1
    .s ^["MEDDATA"]TSABatch("CHBB1",+$h,"Day",$j,index)="Err: No ARCIM - bed: "_$g(EpisodeID)_"^"_$g(bed)    
    i preArcim="" q -13
     
    d addorder^aOET13(preArcim,EpisodeID,"",".5","","",seq,+$h,curTime+10,recloc)
  	q 0
}

ClassMethod IfOpItmCat(Adm, ARCIMItmCat) As %String
{
   
    //判断今天是否有某类医嘱
    s ret=0,temp=""
    s OEItemDate=+$h
    //If Adm="" q
    if ARCIMItmCat="" q ret     //xuqy 080412
    If Adm="" q ret             //xuqy 080412
    Set OEOrderId=""
    f  Set OEOrderId= $o(^OEORD(0,"Adm",Adm,OEOrderId))  q:OEOrderId=""   d
    .s OEOrderSub=""
    .f  s OEOrderSub=$o(^OEORDi(0,"ItemDate",OEItemDate,OEOrderId,OEOrderSub)) q:OEOrderSub=""   d
    ..q:'$d(^OEORD(OEOrderId,"I",OEOrderSub,1))
    ..s temp=^OEORD(OEOrderId,"I",OEOrderSub,1)
    ..s ItemStat=$p(temp,"^",13) 
    ..q:ItemStat=4
    ..s ARCITRowid=+$P(temp,"^",2)
    ..s ARCIMTemp=^ARCIM(ARCITRowid,1,1)
    ..s ItmCat=$p(ARCIMTemp,"^",10)
    ..if ItmCat=ARCIMItmCat d
    ...set ret=1
    q ret
}

ClassMethod getFinalStat(Adm) As %String
{
 
    //取得病人财务结算状态,财务最终结算,财务审核。
    s ret=0
    q:Adm="" ret
    s auditUser=$P($G(^PAADM(Adm,2)),"^",92)
    i auditUser'="" s ret="财务已审核,不能撤消最终结算."
    s BillFlage=$P($G(^PAADM(Adm)),"^",45)
    i BillFlage="Y" s ret="财务结算,不能撤消最终结算."
    q $G(ret)
}

}
