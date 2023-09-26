Import SQLUser

Include Nur.DateFormat

/// 程序名DHCLCNUREXCUTE,护士执行
Class web.DHCLCNUREXCUTE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1791;

/// 判断标本是否接受
/// return: 1:标本已被检验科接受；0:标本未被检验科接受
/// add by linyuxu 20151118
ClassMethod ifLabReceive(LabEpisode)
{
	s execFlag=0
	s Ord="" f  s Ord=$O(^OEORD(0,"EpisNo",LabEpisode,Ord)) q:(Ord="")!(execFlag=1)  d
	.s chl="" f  s chl=$O(^OEORD(0,"EpisNo",LabEpisode,Ord,chl)) q:(chl="")!(execFlag=1)  d
	..s ordStat=$p(^OEORD(Ord,"I",chl,1),"^",13)
	..q:ordStat=""
	..s ordStatDesc=$p(^OEC("OSTAT",ordStat),"^",2)
	..i ordStatDesc="执行" s execFlag=1
	q execFlag
}

/// EH 2014-08-25
ClassMethod ReturnLiquor(oeoriId = "", userId = "") As %String
{
    q ##class(appcom.OEOrdExec).StopLiquorItem(oeoriId,userId,"","","","","Y","Y")
}

ClassMethod StopLiquorItem(oeoriId = "", userId = "", date = "", time = "", newReasonId = "", bflag = "", dflag = "", cflag = "")
{
    s oeordId=$p(oeoriId,"||",1)
    s oeoriSub=$p(oeoriId,"||",2)
    i (oeordId="")!(oeoriSub="")!(userId="") q "-105"
    s error="0"
    ts
    s oeoreSub="" f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
    .s oeoreId=oeoriId_"||"_oeoreSub
    .s error=##class(appcom.OEOrdExec).StopLiquorExec(oeoreId,userId,date,time,newReasonId,bflag,dflag,cflag)
    .i (error'="-105")&(error'="-100") s error="0"
    i error tro  q "-100"
    tc
    q error
}

ClassMethod StopLiquorExec(oeoreId = "", userId = "", date = "", time = "", newReasonId = "", bflag = "", dflag = "", cflag = "") As %String
{
    s oeordId=$p(oeoreId,"||",1)
    s oeoriSub=$p(oeoreId,"||",2)
    s oeoreSub=$p(oeoreId,"||",3)
    i (oeordId="")!(oeoriSub="")!(oeoreSub="")!(userId="") q "-105"
    i ('$d(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))) q "-105"
    s billStatus=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",6)
    i (billStatus="P")&(bflag="Y") q "-101" // 已计费不停止
    s curStatusId=$P(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)
    s curStatusCode=$s((curStatusId'=""):$p($g(^OEC("STAT",curStatusId)),"^",1),1:"")
    i (curStatusCode="D")&(dflag="Y") q "-102" // 已停止不停止
    s episodeId=$p($g(^OEORD(oeordId)),"^",1)
    s isCollected=##class(appcom.OEDispensing).Collected(oeoreId)
    i (isCollected)&(cflag="Y") q "-103" // 已发药不停止
    s newStatusId=$O(^OEC("STAT",0,"Code","D",0))
    s ctcpId=##class(web.SSUser).GetDefaultCareProvider(userId)
    s curDate=$p($h,",",1),curTime=$p($h,",",2)
    i (date="")!(time="") s date=curDate,time=curTime
    ts
    s obj=##class(User.OEOrdExec).%OpenId(oeoreId)
    i $ISObject(obj) {
        d obj.OEOREOrderStatusDRSetObjectId(newStatusId)
        i (ctcpId'="") d obj.OEORECTPCPDRSetObjectId(ctcpId)
        s obj.OEOREXDate=date
        s obj.OEOREXDate=time
        s ExpectDate=obj.OEOREExStDate
        s sc=obj.%Save()
        i ($$$ISERR(sc)) tro  q "-100"
        d obj.%Close()
        s obj=""
        s objext=##class(User.OEOrdExecExt).%OpenId(oeoreId)
        i $ISObject(objext) {
            s newOStatusId=$O(^OEC("OSTAT",0,"Code","D",0))
            i (newOStatusId'="") {
                d objext.OEOREOrderStatusDRSetObjectId(newOStatusId)
                s sc=objext.%Save()
                i ($$$ISERR(sc)) tro  q "-100"
            }
            d objext.%Close()
            s objext=""
        }
        s objstatus=##class(User.OEOrdExecStatus).%New(oeoreId)
        d objstatus.STCHParRefSetObjectId(oeoreId)
        d objstatus.STCHAdminStatusDRSetObjectId(newStatusId)
        i (newReasonId'="") d objstatus.STCHReasonDRSetObjectId(newReasonId)
        s objstatus.STCHDate=curDate
        s objstatus.STCHTime=curTime
        d objstatus.STCHUserDRSetObjectId(userId)
        s sc=objstatus.%Save()
        i ($$$ISERR(sc)) tro  q "-103"
        d objstatus.%Close()
        s objstatus=""
    }
    tc
    q "0"
}

ClassMethod GetXOrdInfo(oeordId, oeoriSub)
{
	n (oeordId, oeoriSub)
	s xUserDr=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",1)
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",2)
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",3)
	q $G(xUserDr)_"^"_$G(xDate)_"^"_$G(xTime)
}

ClassMethod GetSeeOrdInfo(oeordId, oeoriSub)
{
	n (oeordId, oeoriSub)
	s xUserDr=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",4)
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",5)
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",6)
	q $G(xUserDr)_"^"_$G(xDate)_"^"_$G(xTime)
}

/*ClassMethod SeeOrder(oeoreIdStr As %String, userId As %String)
{
	;s ^pjf(1)=oeoreIdStr_"@"_userId
	s num=$l(oeoreIdStr,"^")
	s curDate=+$h,curTime=$p($h,",",2)
	s SQLCODE=0
	f i=1:1:num
	{
		s oeoreId=$p(oeoreIdStr,"^",i)
		s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
		s OrdStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) 
	    continue:OrdStatDR=""
	    s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)
	    s stopOrdInfo=##class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeoriSub)
        s XDate=$p(stopOrdInfo,"^",2)
		i (OrdStatCode="D")&&(oeoreSub="")&&(XDate="") d 
		.d ..SetDisconOrder(oeoreId,userId)
		continue:(OrdStatCode="D")&&(oeoreSub="")
    	s curOeoriId=oeordId_"||"_oeoriSub
		//s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(curOeoriId)
		;s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)  
		;s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
		;i ordStat="V" d
		&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:userId,OEORI_SeeDate=:curDate,OEORI_SeeTime=:curTime where OEORI_RowId=:curOeoriId)
			s chl=0
		f  s chl=$O(^OEORDi(0,"OEORI",oeordId,oeordId_"||"_oeoriSub,chl)) q:chl=""  d
		.s oeoreIdSub=oeordId_"||"_chl
		.&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:userCode,OEORI_SeeDate=:curDate,OEORI_SeeTime=:curTime where OEORI_RowId=:oeoreIdSub)
	}
	q SQLCODE
}*/
ClassMethod UnSeeOrder(oeoreIdStr As %String, userId As %String)
{
	s num=$l(oeoreIdStr,"^")
	s curDate=+$h,curTime=$p($h,",",2)
	s nullValue=""
	s SQLCODE=0
	f i=1:1:num
	{
		s oeoreId=$p(oeoreIdStr,"^",i)
		s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
		;continue:oeoreSub="" 
    	s curOeoriId=oeordId_"||"_oeoriSub
		//s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(curOeoriId)
		s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  
		s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
		i (ordStat="V")!(ordStat="E") d
		.&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:nullValue,OEORI_SeeType=:nullValue,OEORI_SeeRemark=:nullValue,OEORI_SeeDate=:nullValue,OEORI_SeeTime=:nullValue where OEORI_RowId=:curOeoriId)
		s chl=0
		f  s chl=$O(^OEORDi(0,"OEORI",oeordId,oeordId_"||"_oeoriSub,chl)) q:chl=""  d
		.s oeoreIdSub=oeordId_"||"_chl
		.&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:nullValue,OEORI_SeeType=:nullValue,OEORI_SeeRemark=:nullValue,OEORI_SeeDate=:nullValue,OEORI_SeeTime=:nullValue where OEORI_RowId=:oeoreIdSub)
	}
	q SQLCODE
}

ClassMethod getNotes(oew, chl)
{
	f rnum=1:1:$g(^OEORD(oew,"I",chl,"DEP",0))  d
	.s note=$g(notes)_$g(^OEORD(oew,"I",chl,"DEP",rnum))
	s type=$p($g(^OEORD(oew,"I",chl,"DHC")),"^",8)
	s type=$s(type="SQ":"术前",type="SZ":"术中",type="SH":"术后",1:"") 
	s:type'="" note="("_type_")"_note
	q $g(note)
}

ClassMethod getSkinTestResult(oeoreId)
{
	n (oeoreId)
	s oew=+oeoreId,chl=$p(oeoreId,"||",2)
	s skintest=$p($g(^OEORD(oew,"I",chl,5)),"^",2)
    s abnorm=$p($g(^OEORD(oew,"I",chl,11)),"^",3)
    i skintest="Y" d
    .s skintResult="皮试"_$s(abnorm="Y":"(+)",abnorm="N":"(-)",1:"()")
    q $g(skintResult)
}

/// 按指定项取病人的一条停止医嘱内容
ClassMethod GetXOrderItemSingle(admId, wardId, oeordId, oeoriSub, oeoreSub, varType, val, tPos, userId = "", fromDate = "", toDate = "", HospitalRowId = "", excute = "false", long As %String = "false", temp As %String = "false")
{
    n (admId, wardId, oeordId, oeoriSub,oeoreSub, varType, val, tPos,userId, fromDate, toDate, HospitalRowId,excute,long,temp)
    s userId=+userId //考虑历史打印时无用户ID
    s curWardId=wardId
    i curWardId="" s curWardId=$p($g(^PAADM(admId)),"^",70)
    i curWardId="" q "" 
    s unitUomId="",usrdat="",unitDesc="",execDate="",arcicId="",orcatId="",ctcpId=""
    s pmark="N",execXDate="",execXTime="",packUomId="",specCollDate="", specCollTime="",pdaNurExec=""
    s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    s oeoriId=oeordId_"||"_oeoriSub
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep dup
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep dup
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    ;i bedSub="",wardId'="" q ""
    s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
    i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
    s usrdat=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",3)
    s disposeStatCodeStr="^"_..GetDisposeStatCode($g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"DisposeStat")))_"^"
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    q:oecprCode="" 0    
    s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
    s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
    s val("ordStatDesc")=$p($g(^OEC("OSTAT",ordStatusId)),"^",2)
    ;q:(val("ordStatDesc") = "执行")&&(excute = "false") ""
    s ordHandStatus=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",7)
    ;q:(ordHandStatus="A")&&(excute = "false") ""   ;20170817
    q:(ordHandStatus="")&&(excute = "true") ""
    i oecprId'="" s val("oecprDesc")=$p($g(^OECPR(oecprId)),"^",2)
    i phcinId'="" s val("phcinDesc")=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
    s val("seqNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
    s seqNochl=oeoriSub //val("seqNo")
    s val("labNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
    s val("packUomQty")=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=+packUomId
    i (packUomId'=0)&(val("packUomQty")'="") d
    	.s val("packUomDesc")=$p(^CT("UOM",packUomId),"^",2)
    s dipUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    i (+dipUomId)'=0 s val("packUomDesc")=$p($g(^CT("UOM",dipUomId)),"^",2)

    s val("notes")=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))_" "_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",2))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",3))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",4))                      ;xuqy 04/08/04
    s val("notes")=$TR(val("notes"),"!","")
   	s user=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    i user'="" s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    i ctcpId'="" s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,1)),"^",2)
    i (val("ctcpDesc")="")&(ctcpId'="") s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,8)),"^",12)  ////????
    s papmiId=+^PAADM($p($g(^OEORD(oeordId)),"^",1))
    s val("regNo")=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s val("patName")=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    //s val("patIdentity")=..GetPatMedicare(admId)
    //s val("patIdentity")=##class(web.UDHCJFCKD).deposit(admId)
    s admreasondr=$p($g(^PAADM(admId,1)),"^",7)
    if admreasondr'="" s val("patIdentity")=$P(^PAC("ADMREA",admreasondr),"^",2)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s val("age")=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
    s roomdr=$p(^PAADM($p($g(^OEORD(oeordId)),"^",1)),"^",69)
    i (roomdr'="") s room=$p(^PAROOM(roomdr),"^",2)
    i bedSub'="" s val("bedCode")=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)  //ypz 070131
    i orcatId'="" s val("orcatDesc")=$p($g(^OEC("ORCAT",orcatId)),"^",2)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    i reclocId'=""
    {
    	i $p($p($g(^CTLOC(reclocId)),"^",2),"-",2)'="" s val("reclocDesc")=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
    	e  s val("reclocDesc")=$p($g(^CTLOC(reclocId)),"^",2)
    	i oeoreSub'="" d
    	.s dhcDspId=$o(^DHCOEDISQTY(0,"OEORE",oeordId_"||"_oeoriSub_"||"_oeoreSub,""))
    	.i dhcDspId'="" d
    	..s dispRecLocId=$P(^DHCOEDISQTY(dhcDspId),"^",24)
    	..q:dispRecLocId=""
    	..s val("reclocDesc")=$p($g(^CTLOC(dispRecLocId)),"^",2)
    }
    s EpisodeID=$p(^OEORD(oeordId),"^",1)
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    Set val("EncryptLevel")=$p(PatEncryptLevel,"^",1)
    Set val("PatLevel")=$p(PatEncryptLevel,"^",2) 
    s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&(unitDesc'="") s val("doseQtyUnit")=doseQty_" "_unitDesc
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId'="" s val("phcfrCode")=$p($g(^PHCFR(phcfrId)),"^",3) //ypz 070418 统一
    s val("prescNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
    i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    i (phOrdQty'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i val("packUomQty")'=""  s val("phOrdQtyUnit")=val("packUomQty")_" "_val("packUomDesc") 
    s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s hospital=""
    i reclocId'="" s hospital=$p($g(^CTLOC(reclocId)),"^",22)
    s expStr="^"_oeordId_"||"_oeoriSub_"^"_oeordId_"||"_oeoriSub_"||"_oeoreSub_"^"_admId_"^"_reclocId
    i oeoreSub="" s expStr="^"_oeordId_"||"_oeoriSub_"^"_"^"_admId_"^"_reclocId
    
    s instype=""
    s instype=$P($g(^PAADM(EpisodeID,1)),"^",7)
    s val("price")=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("",instype,arcimId,sttDate,"","","",oeoriPrice,hospital,expStr)
    s val("price")=$fn(val("price"),"",2)
    s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    i orderBaseQty=0 s orderBaseQty=##Class(web.DHCNurCom).GetOrderBaseQtyMZ(oeoriId)
    s val("totalAmount")=$fn(orderBaseQty*val("price"),"",2)
    //i +doseQty'=0 s val("totalAmount")=$fn(val("totalAmount")/doseQty,"",2)
    
    //默认处置状态为不需要处理
    s disposeStatCode="Needless" 
    	
   	//新开医嘱,非新开医嘱
    i ((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))&(ordStat="V")
    {
        i sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) s disposeStatCode="LongNew" 
        e  s disposeStatCode="LongUnnew"

    }
    //医嘱停止
    i (ordStat="D")
    {
	    //取停医嘱人,停医嘱日期时间
	    s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
        s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	    s xCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",29)
   		i xCtcpId'="" 
   		{
	   		s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",2)
   		}
    	else
    	{
	    	 //停医嘱人为空时从医嘱状态表取
           s ordStatSub=$O(^OEORD(oeordId,"I",oeoriSub,"ST",0))
           i ordStatSub'=""
           {
	           s ordStatStr=^OEORD(oeordId,"I",oeoriSub,"ST",ordStatSub)
	           i $p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="D" 
	           {
	               s xUserId=$p(ordStatStr,"^",4) //??
	               s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	               i xCtcpId'=""
	               {
		                s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	               }
	           }
           }
    	}
    	s val("xDateTime")=..FormatDate(xDate)_" "_..FormatTime(xTime)
    	//取处理停医嘱人,处理停医嘱日期时间
    	s xOrdExecStr=..GetXOrdInfo(oeordId,oeoriSub)
    	i $p(xOrdExecStr,"^")'=""
    	{
         	s execXUserId=$p(xOrdExecStr,"^"),execXDate=$p(xOrdExecStr,"^",2),execXTime=$p(xOrdExecStr,"^",3)
        	i execXUserId'="" s val("execXUserDesc")=$p($g(^SSU("SSUSR",execXUserId)),"^",2)      ;$p($g(^SSU("SSUSR",execXUserId)),"^",2)
        	
    	}
   	    s val("execXDateTime")=..FormatDate(execXDate)_" "_..FormatTime(execXTime)
    	i ($g(xOrdExecStr)="^^") s disposeStatCode="Discontinue"
    	e  s disposeStatCode="ExecDiscon"
    }
	i (ordStat="V")&($g(execStatusCode)="D")
    {
	    s disposeStatCode="ExecDiscon"
    }
    //医嘱已执行
    i $g(execStatusCode)="F"
    {
	    s execDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",19)
	    s execTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",20)
	    s execCTPCP=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
    	s val("execDateTime")=$$$zd(execDate,1)_" "_##Class(web.DHCCLCom).FormatTime(execTime)
    	i execCTPCP'="" s val("execCtcpDesc")=$p($g(^CTPCP(execCTPCP,1)),"^",2) //根据医院情况定
    	i val("execCtcpDesc")=""  s val("execDateTime")=""  ;未关联医护人员不显示执行时间
    	s disposeStatCode="Exec"
    }
    

    //需处理临嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="ONE")!(oecprCode="OUT"))&(ordStat'="D")&(($g(execStatusCode)="")!($g(execStatusCode)="C"))
    {
	    s disposeStatCode="Temp" 
    }

    //需处理即刻
    i ((oecprCode="STAT")!($g(val("phcfrCode"))="St"))&(ordStat="V")&(($g(execStatusCode)="")!($g(execStatusCode)="C"))
    {
     	s disposeStatCode="Immediate" 
     	
    }
    
    s SeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) //qshe add 05-08-22
    i SeqNo'="",$d(^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub))<=1 D
    .S val("arcimDesc")="____"_val("arcimDesc")
    .s ^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub)=""  //ypz 071212
    e  D
    .s SeqNo=oeordId_"||"_oeoriSub
    i (SeqNo'="")&(+SeqNo'=0) d  
    .s tmpSeqNo=$p(SeqNo,"||",2)
    e  s tmpSeqNo=oeoriSub 
    s ordEffDesc=##Class(web.DHCNurCom).GetOrdEffDesc(oeoriId) //ypz 070621
    i (ordEffDesc'="")&(ordEffDesc'=0) s val("arcimDesc")=val("arcimDesc")_"("_ordEffDesc_")" //ypz 070621
    
    i $d(^OEORD(oeordId,"I",oeoriSub,2)) s duratdr=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",6)
    i $g(duratdr)'="" s durat=$p(^PHCDU(duratdr),"^",3)  //Oeori_Durat_Dr
    s val("Durat")=$g(durat)
   
    s val("placerNo")=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36) 
      
    //s pdaNurExec=..GetPDAExec(oeoriId)
    //s allOrdItemExec=$P($G(pdaNurExec),"^",2)
    //s pdaNurExec=$P($G(pdaNurExec),"^")
    
    //皮试
    s skintest=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)

    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s val("arcimDesc")=val("arcimDesc")_"(皮试:"_actDesc_")"
    
    

    i ((skintest="Y")) s val("phcinDesc")=val("phcinDesc")_"(皮试)"
    //执行记录皮试标志,ST表示皮试

    i (skintest="Y")&(ordStat'="D")
    {
        
        i ($G(execStatusCode)'="F")&($G(execStatusCode)'="R")
        {
            i (abnorm="N") s disposeStatCode="SkinTestNorm"  //ypz 060617
            e  s disposeStatCode="SkinTest" //ypz 080714
        }
        i oeoreSub'="" 
        {
            s skinTestCtcpDesc=""
            s skinTestCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",13)
            i skinTestCtcpId'=""{
            s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
            }
            s skinTestDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",14)
            s skinTestTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",15)
            s val("skinTestDateTime") =..FormatDate(skinTestDate)_" "_..FormatTime(skinTestTime)
            i (abnorm="N") s val("arcimDesc")=val("arcimDesc")_" (-)"_skinTestCtcpDesc
            i (abnorm="Y") s val("arcimDesc")=val("arcimDesc")_" (+)"_skinTestCtcpDesc
            i (abnorm="") s val("arcimDesc")=val("arcimDesc")_" ( )"
        }
        
    }

    i (oecprCode["OM")&(oecprCode'["ZT") s val("arcimDesc")=val("arcimDesc")_"(自备药)"
    i (oecprCode["OM")&(oecprCode["ZT") s val("arcimDesc")=val("arcimDesc")_"(嘱托)"
    //s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeordId_"||"_oeoriSub)
    //q:orcatId="" 1
    i ("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^") s disposeStatCode="Needless" //070206
    i oecprCode="STAT" s val("phcfrCode")="ST"  ;by xin ///???
    s val("createDateTime")=..FormatDate(oeoriDate)_" "_..FormatTime(oeoriTimeOrd)
    s val("sttDateTime")=..FormatDate(sttDate)_" "_..FormatTime(sttTime)
    
    s val("PreDisDateTime")=..GetPreStopDate(oeordId,oeoriSub)
    //s val("pdaNurExec")=$G(pdaNurExec)
    //暂时没用了
    s val("pdaNurExec")=""

    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
    i specCode'="" s val("specDesc")=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2) ;s val("specDesc")=$p($g(^TTAB("SPEC",specCode)),"\",1)
    e  d
        .s arcicCode=$p($g(^ARC("IC",+arcicId)),"^",1)
        .q:(arcicCode="")
        .q:(arcicCode'["PATHOLOGY")
        .s tmId=$o(^DHCPISTestMasteri("ORDER",oeoriId,""))
        .i tmId'="" d
            ..s val("labNo")=tmId
            ..s tsSub=0
            ..f  s tsSub=$o(^DHCPISTestMaster(tmId,"TS",tsSub)) q:tsSub=""  d
                ...i val("specDesc")'="" s val("specDesc")=val("specDesc")_"/"
                ...s tsStr=$g(^DHCPISTestMaster(tmId,"TS",tsSub))
                ...s val("specDesc")=val("specDesc")_$p(tsStr,"^",1)_":"_$p(tsStr,"^",3)
    s placerCode=""
    i ordStat'="D" d  
        .s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(oeoriId)
        .i $p(placerStr,"^",5)'="" s placerCode=$p(placerStr,"^",5)
    s resStr=""

    i (disposeStatCodeStr'[("^"_disposeStatCode_"^"))&&(excute="false") q "不包含该处置状态"_disposeStatCode //'$d(^TMP("NurQuery",userId,tmpId,"printed"))&
    ;q:(disposeStatCode'="Exec")&&(excute="false") "已执行不包含该处置状态"_disposeStatCode 
    b ;sssds
    s longStr="^S^OMST^"
    q:(longStr'[("^"_oecprCode_"^"))&&(long="true") "不包含长期"
    s tempStr="^STAT^PRN^NORM^ONE^OM^OUT^"
    q:(tempStr'[("^"_oecprCode_"^"))&&(temp="true") "不包含临时"
    //ExecDiscon
    //w disposeStatCode_"@"_excute,!
    i oecprCode="OMLSZT" s disposeStatCode="Temp"  ///update 20180306 临时嘱托处置状态改为需处理，与新版一致。
    s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)
     
    s resStr="",tmpPrtFlag=val("prtFlag") //,tmpSeqNo=$p(val("seqNo"),".",1)*100+$p(val("seqNo"),".",2)
    //皮试显示医嘱
    f ivar=1:1:^DHCCLNurseExec("Var",0)
    {
        s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        i $g(tPos(varName))'="" s $p(resStr,"!",tPos(varName))=val(varName)
    }
    i resStr'=""
    {
         s tmpSttDate=sttDate
         s seqNochl=oeoriSub
         s tmpOeoriId=oeoriId
         s tmpSttDate=sttDate+(sttTime/100000)
         s tmpSeqNo=SeqNo
         s resStr=resStr_"!"_tmpOeoriId_"!"_placerCode_"!"_disposeStatCode_"!"_tmpPrtFlag_"!"_tmpSeqNo_"!"_sttDate
         s ^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,tmpSttDate,tmpSeqNo,seqNochl)=resStr
    }
    f ivar=1:1:^DHCCLNurseExec("Var",0)
    {
        s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        s val(varName)="" 
    }
    q resStr
}

ClassMethod SetPrintFlag(wardId As %String, userId As %String, queryTypeCode As %String, oeoreIdStr As %String, flag As %String = "Y") As %String
{
 	n (wardId, userId, queryTypeCode,oeoreIdStr,flag)
 	q:(wardId="")!(userId="")!(queryTypeCode="")!(oeoreIdStr="") -1
	s num=$l(oeoreIdStr,"^")
    s curDate=+$h,curTime=$p($h,",",2)
	s err=0
	f i=1:1:num d
	    .s oeoreId=$p(oeoreIdStr,"^",i)
	    .q:oeoreId=""
	    .s dhcorePrinted=""
	    .&sql(select OEORE_Printed into :dhcorePrinted from OE_OrdExecExt where OEORE_RowId=:oeoreId)
	    .i dhcorePrinted'[flag s dhcorePrinted=dhcorePrinted_flag
	    .B
	    .&sql(update OE_OrdExecExt set OEORE_Printed=:dhcorePrinted,OEORE_PrintDate=:curDate,OEORE_PrintTime=:curTime,OEORE_PrintUser_DR=:userId,OEORE_QueryCode=:queryTypeCode where OEORE_RowId=:oeoreId)
	    .s err=SQLCODE
	    .i err'=0 s err="置打印标志错!" q
    q err
}

ClassMethod SetPrintFlagO(userId As %String, queryTypeCode As %String, oeoreIdStr As %String, flag As %String = "Y") As %String
{
 	n (userId, queryTypeCode,oeoreIdStr,flag)
 	q:(userId="")!(queryTypeCode="")!(oeoreIdStr="") -1
	s num=$l(oeoreIdStr,"^")
    s curDate=+$h,curTime=$p($h,",",2)
	s err=0
	f i=1:1:num d
	    .s oeoreId=$p(oeoreIdStr,"^",i)
	    .q:oeoreId=""
	    .s dhcorePrinted=""
	    .&sql(select OEORE_Printed into :dhcorePrinted from OE_OrdExecExt where OEORE_RowId=:oeoreId)
	    .i dhcorePrinted'[flag s dhcorePrinted=dhcorePrinted_flag
	    .B
	    .&sql(update OE_OrdExecExt set OEORE_Printed=:dhcorePrinted,OEORE_PrintDate=:curDate,OEORE_PrintTime=:curTime,OEORE_PrintUser_DR=:userId,OEORE_QueryCode=:queryTypeCode where OEORE_RowId=:oeoreId)
	    .s err=SQLCODE
	    .i err'=0 s err="置打印标志错!" q
    q err
}

ClassMethod GetTypVar(typ As %String, HospitalRowId As %String)
{
    q:(typ="")!(HospitalRowId="") ""
    s num=$L(^DHCCLNurseExec("VarDef",HospitalRowId,typ,"VarId"),"^")
    s a=^DHCCLNurseExec("VarDef",HospitalRowId,typ,"VarId")
    for i=1:1:num
    {
	    s id=$p(a,"^",i)
	    q:id=""
	    s var=$p(^DHCCLNurseExec("Var",id),"^",1)
        s $p(str,"^",i)=var
   	}
 q str
}

ClassMethod GetVarStr(typ As %String)
{
    q:typ="" ""
    s num=$L(^DHCCLNurseExec("VarDef",typ,"VarId"),"^")
    s a=^DHCCLNurseExec("VarDef",typ,"VarId")
    for i=1:1:num
    {
	    s id=$p(a,"^",i)
	    q:id=""
	    s var=$p(^DHCCLNurseExec("Var",id),"^",2)
        s $p(str,"^",i)=var
   	}
 q str
}

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s code=$$ALPHAUP^SSUTIL4(code)
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(sub="")!(sub="BED_BedType_DR")  d
    .q:$p(^PAWARD(sub),"^",6)'="Y"
    .s locDr=$p(^PAWARD(sub),"^",5)
    .s wardFlag=$p($g(^CTLOC(locDr)),"^",5)
    .s JP=$p($g(^CTLOC(locDr)),"^",43)
    .s JP=$$ALPHAUP^SSUTIL4(JP)
    .q:wardFlag'="Y"
    .s desc=$p(^PAWARD(sub),"^",2)
    .s descTmp=$$ALPHAUP^SSUTIL4(desc)
    .q:((descTmp'[code)&(code'=""))&&((JP'[code)&(code'=""))
    .i desc["-" s desc=$p(desc,"-",2)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetWard(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod findarcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findarcExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod findarcExecute(ByRef qHandle As %Binary, catid As %String, subcat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	if catid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s ind=1
 	s sub="" f  s sub=$o(^ARCIM(0,"ARCIC_DR",catid,sub))  q:sub=""  d
    .s ver=""  f  s ver=$o(^ARCIM(0,"ARCIC_DR",catid,sub,ver)) q:ver=""  d
    ..s code=$p(^ARCIM(sub,ver,1),"^",1)
    ..s desc=$p(^ARCIM(sub,ver,1),"^",2)
    ..s aritemdr=$p(^ARCIM(sub,ver,1),"^",10)
    ..s arcitem=$p(^ARC("IC",aritemdr),"^",2) 
 	..Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(code,desc,arcitem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findarcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findarcExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod findcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findcatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query findarc(catid As %String, subcat As %String) As %Query(ROWSPEC = "code:%String,desc:%String,arccat:%String")
{
}

ClassMethod findcatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rw=0  f  s rw=$o(^ARC("IC",rw))  q:rw=""  d
 	.s desc=$p(^ARC("IC",rw),"^",2)
 	.Do Outputcat
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query findcat() As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetAllPatient(itmjs As %Library.String = "", itmjsex As %Library.String = "", userId As %String)
{
    s patStr="",patNum=0
    ;s PLIST(1)="patname"_"ROWID!"_"医嘱类别!"_"医嘱名称!"_"检验标本号!"_"医嘱优先级!"_"剂量!"_"用法!"_"备注!"_"医生"
    s bedCode=0 f  s bedCode=$o(^TMP("NurExec",userId,"Patient",bedCode)) q:bedCode=""  d
        .//&js<alert("come in class "+"#(^TMP("NurExec",userId,"Patient",bedCode))#");>
        .s admId=$p($g(^TMP("NurExec",userId,"Patient",bedCode)),"^",1)
        .s patname=$p($g(^TMP("NurExec",userId,"Patient",bedCode)),"^",2)
        .s patNum=patNum+1
        .s $p(patStr,"^",patNum)=admId_"!"_patname
      s retval=itmjs_"('"_$ZCVT(patStr,"O","JS")_"');"
      i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(patStr,"O","JS")_"');"
     // &javascript<#(retval)#>
    q patStr
}

ClassMethod GetVarCols(typeCode)
{
	i typeCode="" q 0
	q:$g(^DHCCLNurseExec("VarDef",typeCode,"VarId"))="" 0
	q $l(^DHCCLNurseExec("VarDef",typeCode,"VarId"),"^")
}

/// 取已打印记录
ClassMethod GetPrinted(fDateStr, tDateStr, curWardId)
{
	//&js<alert("here  "+"#(fDateStr)#"+"/"+"#(tDateStr)#"+"/"+"#(curWardId)#");>
	q:(fDateStr="")!(tDateStr="") -2
	s resStr=-1,num=0
	s fromDate=##class(websys.Conversions).DateHtmlToLogical(fDateStr) ;$zdh(fDateStr,3)
	s toDate=##class(websys.Conversions).DateHtmlToLogical(tDateStr) ;$zdh(tDateStr,3)
	f pDate=fromDate:1:toDate d
	    .s pTime=""
	    .f  s pTime=$o(^DHCCLNurseExec("Printed",pDate,pTime)) q:pTime=""  d
	        ..//&js<alert("in ptime  "+"#(pTime)#"+"/"+"#(fromDate)#"+"/"+"#(toDate)#");>
	        ..s wardId=0
	        ..f  s wardId=$o(^DHCCLNurseExec("Printed",pDate,pTime,wardId)) q:wardId=""  d
	            ...//&js<alert("inin  "+"#(fDateStr)#"+"/"+"#(tDateStr)#"+"/"+"#(curWardId)#");>
	            ...i (curWardId'="")&(wardId'=curWardId) q
	            ...s pdateTime=..FormatDate(pDate)_" "_..FormatTime(pTime)
	            ...s wardDesc=$p(^PAWARD(wardId),"^",2)
	            ...s formType=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^",1)
	            ...s userId=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^",2)
	            ...s userDesc=$p(^SSU("SSUSR",userId),"^",2)
	            ...s num=num+1
	            ...s $p(resStr,"^",num)=pdateTime_"!"_formType_"!"_userDesc
    q $g(resStr)
}

ClassMethod GetTypeStr(pDateTimeStr, wardId)
{
	q:(pDateTimeStr="")!(wardId="") -3
	s pDateStr=$p(pDateTimeStr,"|",1)
	s pTimeStr=$p(pDateTimeStr,"|",2)
	q:(pDateStr="")!(pTimeStr="") -2
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
	s resStr=-1,num=0
	s pDate=##class(websys.Conversions).DateHtmlToLogical(pDateStr) ;$zdh(pDateStr,4)
	s pTime=$zth(pTimeStr)
	//&js<alert("here  "+"#(pDate)#"+"/"+"#(pTime)#");>
    s varType=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^",1)
    q:varType="" ""
    s resStr=varType_"^"_^DHCCLNurseExec("VarDef",varType)
    q resStr
}

/// 取已打印记录明细
ClassMethod GetPrintedItem(pDateTimeStr, wardId)
{
	//&js<alert("here  "+"#(pDateTimeStr)#"+"/"+"#(wardId)#"+"/"+"#(wardId)#");>
	q:(pDateTimeStr="")!(wardId="") -3
	s pDateStr=$p(pDateTimeStr," ",1)
	s pTimeStr=$p(pDateTimeStr," ",2)
	q:(pDateStr="")!(pTimeStr="") -2
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
	s resStr=-1,num=0
	s pDate=##class(websys.Conversions).DateHtmlToLogical(pDateStr) ;$zdh(pDateStr,3),
	s pTime=$zth(pTimeStr)
	//&js<alert("here  "+"#(pDate)#"+"/"+"#(pTime)#");>
	s oeoriId=""
	f  s oeoriId=$o(^DHCCLNurseExec("Printed",pDate,pTime,wardId,oeoriId)) q:oeoriId=""  d
	    .s arcimId=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),1)),"^",2)
	    .s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	    .s num=num+1
	    .s $p(resStr,"^",num)=oeoriId_"!"_arcimDesc
    q $g(resStr)
}

/// 取一次已打印的记录的各医嘱的选定项内容
ClassMethod GetPrintedData(pDateTimeStr, wardId)
{
	//&js<alert("here  "+"#(pDateTimeStr)#"+"/"+"#(wardId)#"+"/"+"#(wardId)#");>
	q:(pDateTimeStr="")!(wardId="") -3
	s userId=+$g(userId)
	s pDateStr=$p(pDateTimeStr,"|",1)
	s pTimeStr=$p(pDateTimeStr,"|",2)
	q:(pDateStr="")!(pTimeStr="") -2
	s resStr=-1,num=0
	s pDate=##class(websys.Conversions).DateHtmlToLogical(pDateStr) ;$zdh(pDateStr,4)
	s pTime=$zth(pTimeStr)
    s tmpId=$i(^TMP("NurQuery",userId))
	k ^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort")
	
	s varType=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^",1)

    s patOrder=$p(^DHCCLNurseExec("VarDef",varType),"^",3)

	s varStr=^DHCCLNurseExec("VarDef",varType,"VarId")
    s varCount=$l(varStr,"^") ;对应项
    f ivar=1:1:varCount d 
        .s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
        .s tPos(varName)=ivar
    
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s val(varName)=""

	k ^TMP("NurQuery",userId,tmpId,"NurseExec")
	s oeoriId="",num=0
	f  s oeoriId=$o(^DHCCLNurseExec("Printed",pDate,pTime,wardId,oeoriId)) q:oeoriId=""  d
	    .s admId=+^OEORD(+oeoriId)
	    .s resStr=..GetOrderItemSingle(admId, wardId,+oeoriId,$p(oeoriId,"||",2),varType,pdaExec,.val,.tPos,tmpId,"","","")
	    .i (resStr'="")&(patOrder'="Y") s num=num+1,^TMP("NurQuery",userId,tmpId,"NurseExec",num)=resStr
    i patOrder="Y" d  //按病人排序
        .q:$d(^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort"))<2
        .s admId=""
        .f  s admId=$o(^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort",admId)) q:admId=""  d
            ..s sttDate=""
            ..f  s sttDate=$o(^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort",admId,sttDate)) q:sttDate=""  d
            ...s seqNo=""
            ...f  s seqNo=$o(^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort",admId,sttDate,seqNo)) q:seqNo=""  d
            ....s sq=""  
            ....f  s sq=$o(^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort",admId,sttDate,seqNo,sq)) q:sq=""  d 
            .....s num=num+1,^TMP("NurQuery",userId,tmpId,"NurseExec",num)=^TMP("NurQuery",userId,tmpId,"NurseExecSeqNoSort",admId,sttDate,seqNo,sq)
    q num
}

/// 撤消已打印记录
ClassMethod UndoPrinted(pDateTimeStr, wardId, querytyp = "")
{
 //	&js<alert("here  "+"#(pDateTimeStr)#"+"/"+"#(wardId)#"+"/"+"#(wardId)#");>
	q:(pDateTimeStr="")!(wardId="") -3
	s pDateStr=$p(pDateTimeStr,"|",1)
	s pTimeStr=$p(pDateTimeStr,"|",2)
	q:(pDateStr="")!(pTimeStr="") -2
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
	s pDate=##class(websys.Conversions).DateHtmlToLogical(pDateStr) ;$zdh(pDateStr,4)
	s pTime=$zth(pTimeStr)
	//&js<alert("  "+"#(pDate)#"+"/"+"#(pTime)#"+"/"+"#(wardId)#");>
	//s queryTypeCode=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^")
	//s ^TMPNurIPDebug("printed")=pDate_","_pTime_","_wardId_"/"_querytyp
	s oeoriId=""
	s ^TM=pDate_"^"_pTime_"^"_pTimeStr_"^"_wardId_"^"_querytyp_"^"
	//s pDate=pDateStr,pTime=pTimeStr
	s user="" f  s user=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
    .s ^TM=user
    .s rw=""  f  s rw=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user,rw)) q:rw=""  d
	..s $p(^DHCOrdExec(rw),"^",3)="" //,$p(^DHCOrdExec(rw),"^",6)=""
    q 0
}

/// 取查询参数
ClassMethod GetQueryPara(code As %String)
{
	q:code="" ""
    s resStr=$g(^DHCCLNurseExec("VarDef",code,"DisposeStat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",code,"OrCat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",code,"OecPr"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",code,"OrdStat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",code,"PhcIn"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",code,"VarId"))
    q resStr
}

/// 取变量值类别
ClassMethod TypeVarGet(code As %String)
{
	q $g(^DHCCLNurseExec("VarDef",code,"VarId"))
}

Parameter SQLROWID = "ID";

ClassMethod GetVarType(code As %String, HospitalRowId As %String)
{
	n (code,HospitalRowId)
	q:(code="")!(HospitalRowId="") ""
	q $g(^DHCCLNurseExec("VarDef",HospitalRowId,code))
}

/// 取查询类别
ClassMethod GetType()
{
	s HospitalRowId="",type=0,num=0
	f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
	.f  s type=$o(^DHCCLNurseExec("VarDef",HospitalRowId,type)) q:type=""  d
	    ..s num=num+1
	    ..s typeStr=type_"^"_^DHCCLNurseExec("VarDef",HospitalRowId,type)
	    ..s $p(resStr,"!",num)=typeStr
	q $g(resStr)
}

/// 取得处置状态
ClassMethod GetDisposeStat()
{
	s disposeStatId=0
	f  s disposeStatId=$o(^DHCCLNurseExec("DisposeStat",disposeStatId)) q:disposeStatId=""  d
	    .s varStr=disposeStatId_"^"_^DHCCLNurseExec("DisposeStat",disposeStatId)
	    .s $p(resStr,"!",disposeStatId)=varStr
	q $g(resStr)
}

/// 取得医嘱大类状态
Query GetOrcat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "orcat_rowid:%Integer,orcat_Desc:%String")
{
	 select orcat_rowId,orcat_desc from OEC_OrderCategory
}

/// 取得医嘱执行状态
Query GetExecStat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Stat_rowid:%Integer,Stat_Desc:%String")
{
	 select Stat_rowId,Stat_desc from OEC_Order_AdminStatus where STAT_RowId='1'
}

/// 取处置状态代码
ClassMethod GetDisposeStatCode(codeStr)
{
	s resCode=""
	s codeNum=$l(codeStr,"^")
	//&js<alert("sigle  "+"#(codeStr)#"+"/"+"#(codeNum)#"+"/");>
	f ipos=1:1:codeNum d
	    .s codeId=$p(codeStr,"^",ipos)
	    .i codeId="" q
	    .s $p(resCode,"^",ipos)=$p($g(^DHCCLNurseExec("DisposeStat",codeId)),"^",2)
	q resCode
}

// 

ClassMethod TransformAge(birth)
{
	s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)_"岁"_$p(age,"Y",2)
    s age=$p(age,"M",1)_"月"_$p(age,"M",2)
    s age=$p(age,"D",1)_"天"_$p(age,"D",2)
    i age>2 s age=$p(age," ",1)
    i (age>1)&(age<3) s age=$p(age," ",1,2)
    i age<1 d
    .s age=$p(age," ",2,3)
    .i age<1 s age=$p(age," ",2) q
    .i age>5 s age=$p(age," ",1)
    q age
}

/// 按指定项取病人的一条医嘱内容
ClassMethod GetOrderItemSingle(admId, wardId, oeordId, oeoriSub, oeoreSub, varType, val, tPos, userId = "", fromDate = "", toDate = "", HospitalRowId = "", excute = "false", long As %String = "false", temp As %String = "false", otherArgs...)
{
    n (admId, wardId, oeordId, oeoriSub,oeoreSub, varType, val, tPos,userId, fromDate, toDate, HospitalRowId,excute,long,temp,otherArgs)
    s newOrd=$g(otherArgs(1))
    s unExec=$g(otherArgs(2))
    s startTime=$g(otherArgs(3))
    s endTime=$g(otherArgs(4))
    s userId=+userId //考虑历史打印时无用户ID
    s curWardId=wardId
    i curWardId="" s curWardId=$p($g(^PAADM(admId)),"^",70)
    i curWardId="" q "" 
    s unitUomId="",usrdat="",unitDesc="",execDate="",arcicId="",orcatId="",ctcpId=""
    s pmark="N",execXDate="",execXTime="",packUomId="",specCollDate="", specCollTime="",pdaNurExec=""
    s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    s oeoriId=oeordId_"||"_oeoriSub
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)   //keep dup
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)  //keep dup
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    ;i bedSub="",wardId'="" q ""
    s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
	s newInspect=##Class(web.DHCEMInterface).GetOrdExecDesc(oeoreId) ;##Class(web.DHCEMInterface).GetExaReqItemDesc(oeordId_"||"_oeoriSub)
    i newInspect'="" d
    .s val("arcimDesc")= newInspect
    i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
    s usrdat=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",3)
    s disposeStatCodeStr="^"_..GetDisposeStatCode($g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"DisposeStat")))_"^"
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    q:oecprCode="" 0    
    s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)  ;OEORI_ItemStat_DR
    s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)  //医嘱状态
    s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
    s val("ordStatDesc")=$p($g(^OEC("OSTAT",ordStatusId)),"^",2)
    s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
    i execStatusId'="" 
    {
	    s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)   
	    s val("execStat")=$p($g(^OEC("STAT",execStatusId)),"^",2)   
    }
    s LockUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",21)
    i LockUserId'="" s val("LockStatus")="<font color='red' size='5px' ><text>"_"锁"_"</text></font>"
    e  s val("LockStatus")=""
    ///病人密级
    s EpisodeID=$p(^OEORD(oeordId),"^",1)
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    Set val("EncryptLevel")=$p(PatEncryptLevel,"^",1)
    Set val("PatLevel")=$p(PatEncryptLevel,"^",2) 
    i oecprId'="" s val("oecprDesc")=$p($g(^OECPR(oecprId)),"^",2)
    i phcinId'="" s val("phcinDesc")=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
    s val("seqNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
    s seqNochl=oeoriSub //val("seqNo")
    s val("labNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
    s val("packUomQty")=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    
    
    //用量
     s val("dosage")=##class(web.DHCDocMain).GetQtyAndUom(oeordId,oeoriSub)
     
    s packUomId=+packUomId
    i (packUomId'=0)&(val("packUomQty")'="") d
    	.s val("packUomDesc")=$p(^CT("UOM",packUomId),"^",2)
     s dipUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    i (+dipUomId)'=0 s val("packUomDesc")=$p($g(^CT("UOM",dipUomId)),"^",2)
    s val("notes")=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))_" "_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",2))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",3))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",4))                      ;xuqy 04/08/04
    s val("notes")=$TR(val("notes"),"!","")

    s phSpecNotes=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",8)
    i phSpecNotes'="" s val("notes")=phSpecNotes
   	s user=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    i user'="" s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    i ctcpId'="" s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,1)),"^",2)
    i (val("ctcpDesc")="")&(ctcpId'="") s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,8)),"^",12)  ////????
    s papmiId=+^PAADM($p($g(^OEORD(oeordId)),"^",1))
    s val("regNo")=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s val("patName")=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    //s val("patIdentity")=..GetPatMedicare(admId)
    //s val("patIdentity")=##class(web.UDHCJFCKD).deposit(admId)
    s admreasondr=$p($g(^PAADM(admId,1)),"^",7)
    if admreasondr'="" s val("patIdentity")=$P(^PAC("ADMREA",admreasondr),"^",2)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s val("age")=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
    s roomdr=$p(^PAADM($p($g(^OEORD(oeordId)),"^",1)),"^",69)
    i (roomdr'="") s room=$p(^PAROOM(roomdr),"^",2)
    i bedSub'="" s val("bedCode")=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)  //ypz 070131
    i orcatId'="" s val("orcatDesc")=$p($g(^OEC("ORCAT",orcatId)),"^",2)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    i reclocId'=""
    {
    	i $p($p($g(^CTLOC(reclocId)),"^",2),"-",2)'="" s val("reclocDesc")=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
    	e  s val("reclocDesc")=$p($g(^CTLOC(reclocId)),"^",2)
    	 i oeoreSub'="" d
    	.s dhcDspId=$o(^DHCOEDISQTY(0,"OEORE",oeordId_"||"_oeoriSub_"||"_oeoreSub,""))
    	.i dhcDspId'="" d
    	..s dispRecLocId=$P(^DHCOEDISQTY(dhcDspId),"^",24)
    	..q:dispRecLocId=""
    	..s val("reclocDesc")=$p($g(^CTLOC(dispRecLocId)),"^",2)
    }
    s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&(unitDesc'="") s val("doseQtyUnit")=doseQty_" "_unitDesc
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId'="" s val("phcfrCode")=$p($g(^PHCFR(phcfrId)),"^",3) //ypz 070418 统一
    s val("prescNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
    i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    i (phOrdQty'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i val("packUomQty")'=""  s val("phOrdQtyUnit")=val("packUomQty")_" "_$G(val("packUomDesc"))
    s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s hospital=""
    i reclocId'="" d
    .s hospital=$p($g(^CTLOC(reclocId)),"^",22)
    s instype=""
    s instype=$P($g(^PAADM(EpisodeID,1)),"^",7)
    s expStr="^"_oeordId_"||"_oeoriSub_"^"_oeordId_"||"_oeoriSub_"||"_oeoreSub_"^"_admId_"^"_reclocId
    s val("price")=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("",instype,arcimId,sttDate,"","","",oeoriPrice,hospital,expStr)
    s val("price")=$fn(val("price"),"",2)
    s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    i newInspect'="" s val("price")=+##class(web.DHCLCNUREXCUTE).getInspectPrice(oeoreId)
   	s val("totalAmount")=$fn(orderBaseQty*val("price"),"",2)
    //i +doseQty'=0 s val("totalAmount")=$fn(val("totalAmount")/doseQty,"",2)
    s deeppurple=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",55)
    i deeppurple="Y"  s val("arcimDesc")=val("arcimDesc")_"<font color='red'><b>-急查</b></font>"
    
    //默认处置状态为不需要处理
    s disposeStatCode="Needless" 
    	
   	//新开医嘱,非新开医嘱
   	s OrdTyp=""
   	s firstTimeOrd=""
    i ((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))&(ordStat="V")
    {
	    
        i sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) d
	    .s OrdTyp=$P(^ARC("IC",arcicId),"^",7)
	    .i OrdTyp="R" s firstTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",18)
        .s disposeStatCode="LongNew" 
        e  s disposeStatCode="LongUnnew"

    }
    //医嘱停止
    i (ordStat="D")
    {
	    //取停医嘱人,停医嘱日期时间
	    s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
        s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	    s xCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",29)
   		i xCtcpId'="" 
   		{
	   		s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",2)
   		}
    	else
    	{
	    	 //停医嘱人为空时从医嘱状态表取
           s ordStatSub=$O(^OEORD(oeordId,"I",oeoriSub,"ST",0))
           i ordStatSub'=""
           {
	           s ordStatStr=^OEORD(oeordId,"I",oeoriSub,"ST",ordStatSub)
	           i $p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="D" 
	           {
	               s xUserId=$p(ordStatStr,"^",4) //??
	               s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	               i xCtcpId'=""
	               {
		                s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	               }
	           }
           }
    	}
    	s val("xDateTime")=..FormatDate(xDate)_" "_..FormatTime(xTime)
    	//取处理停医嘱人,处理停医嘱日期时间
    	s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoreId)
    	i $p(xOrdExecStr,"^")'=""
    	{
         	s execXUserId=$p(xOrdExecStr,"^"),execXDate=$p(xOrdExecStr,"^",2),execXTime=$p(xOrdExecStr,"^",3)
        	i execXUserId'="" s val("execXUserDesc")=$p($g(^CTPCP(execXUserId,1)),"^",2)
    	}
   	    s val("execXDateTime")=..FormatDate(execXDate)_" "_..FormatTime(execXTime)
    	i ($g(execStatusCode)'="D") s disposeStatCode="Discontinue"
    	i $g(execStatusCode)="D" s disposeStatCode="ExecDiscon"
    }
    i (ordStat="V")&($g(execStatusCode)="D")
    {
	    s disposeStatCode="ExecDiscon"
    }
    //医嘱已执行
    i $g(execStatusCode)="F"
    {
	    s execDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",19)
	    s execTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",20)
	    s execCTPCP=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
    	s val("execDateTime")=..FormatDate(execDate)_" "_##Class(web.DHCCLCom).FormatTime(execTime)
    	i execCTPCP'="" s val("execCtcpDesc")=$p($g(^CTPCP(execCTPCP,1)),"^",2) //根据医院情况定
    	i val("execCtcpDesc")=""  s val("execDateTime")=""  ;未关联医护人员不显示执行时间
    	s disposeStatCode="Exec"
    }
    
    
    
    //需处理临嘱
    i ((oecprCode="NORM")!(oecprCode="OMLSZT")!(oecprCode="OM")!(oecprCode="ONE")!(oecprCode="OUT"))&(ordStat'="D")&(($g(execStatusCode)="")!($g(execStatusCode)="C"))
    {
	    s disposeStatCode="Temp" 
    }
    
    //需处理即刻
    i ((oecprCode="STAT")!($g(val("phcfrCode"))="St"))&(ordStat="V")&(($g(execStatusCode)="")!($g(execStatusCode)="C"))
    {
     	s disposeStatCode="Immediate" 
    }
    
    i ordStatusCode="PD" s disposeStatCode="PreDiscon"
    i disposeStatCode'="LongNew",ordStatusCode="TPD" s disposeStatCode="PreDiscon"
    
    /*s SeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) //qshe add 05-08-22
    i SeqNo'="",$d(^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub))<1 s ^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub)=""  

//ypz 071212
    i (SeqNo'="")&(+SeqNo'=0) d  
       .s tmpSeqNo=$p(SeqNo,"||",2),val("arcimDesc")="____"_val("arcimDesc")
    e  s tmpSeqNo=oeoriSub */
     s SeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",3)
     i SeqNo="" s SeqNo=oeordId_"||"_oeoriSub_"||"_oeoreSub
     e  s val("arcimDesc")="____"_val("arcimDesc")
     /*
     i (SeqNo'="")&(+SeqNo'=0) d 
     .s tmpSeqNo=$p(SeqNo,"||",2)
     .s tmpOreSub=$p(SeqNo,"||",3)
     .s val("arcimDesc")="____"_val("arcimDesc")
     e  d
     .s tmpSeqNo=oeoriSub 
     .s tmpOreSub=oeoreSub
    */
    s ordEffDesc=##Class(web.DHCNurCom).GetOrdEffDesc(oeoriId) //ypz 070621
    i (ordEffDesc'="")&(ordEffDesc'=0) s val("arcimDesc")=val("arcimDesc")_"("_ordEffDesc_")" //ypz 070621
    
    i $d(^OEORD(oeordId,"I",oeoriSub,2)) s duratdr=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",6)
    i $g(duratdr)'="" s durat=$p(^PHCDU(duratdr),"^",3)  //Oeori_Durat_Dr
    s val("Durat")=$g(durat)
   
    s val("placerNo")=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36) 
   
    s dispensingStat=##class(web.DHCCLCom).GetDispensingStat(oeoreId,"Y")  //ypz 070409 ..PHASTAT(oeordId,oeoriSub) //药品状态
 
    i (dispensingStat="")&(val("doseQtyUnit")'="") s val("arcimDesc")="*-"_val("arcimDesc") //未打包 
    i dispensingStat="TC" s val("DspStat")="未发"   
    i dispensingStat="C" s val("DspStat")="已发"  
    i dispensingStat="PC" s val("DspStat")="部分发"

     
    //s pdaNurExec=..GetPDAExec(oeoriId)
    //s allOrdItemExec=$P($G(pdaNurExec),"^",2)
    //s pdaNurExec=$P($G(pdaNurExec),"^")
    
    //皮试
    s skintest=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)

    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s val("arcimDesc")=val("arcimDesc")_"(皮试:"_actDesc_")"
    
    
    i ((skintest="Y")) s val("phcinDesc")=val("phcinDesc")_"(皮试)"
    //执行记录皮试标志,ST表示皮试

    s ordExecSkinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",20)
    ;i oeordId=816011,oeoriSub=42 w skintest
    //i (skintest="Y")&(ordStat'="D")&(ordExecSkinTestFlag="ST")
    i (skintest="Y")&(ordStat'="D")
    {
        
        s skinTestCtcpDesc=""
        s skinTestCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",13)
        i skinTestCtcpId'=""{
        s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
        }
        s skinTestDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",14)
        s skinTestTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",15)
        s val("skinTestDateTime") =..FormatDate(skinTestDate)_" "_..FormatTime(skinTestTime)
        i (abnorm="N") s val("arcimDesc")=val("arcimDesc")_" (-)"_skinTestCtcpDesc
        i (abnorm="Y") s val("arcimDesc")=val("arcimDesc")_" (+)"_skinTestCtcpDesc
        i (abnorm="") s val("arcimDesc")=val("arcimDesc")_" ( )"
        i ($G(execStatusCode)'="F")&($G(execStatusCode)'="R")
        {
	        i (abnorm="N") s disposeStatCode="SkinTestNorm"  //ypz 060617
	        e  s disposeStatCode="SkinTest" //ypz 080714
        }
    }
    
    //没出皮试结果或者皮试阳性的非皮试执行记录医嘱不显示
    //q:(skintest="Y")&(ordExecSkinTestFlag="")&((abnorm="Y")!(abnorm="")) "没出皮试结果或者皮试阳性的非皮试执行记录医嘱不显示"
    
    i (oecprCode["OM")&(oecprCode'["ZT") s val("arcimDesc")=val("arcimDesc")_"(自备药)"
    i (oecprCode["OM")&(oecprCode["ZT") s val("arcimDesc")=val("arcimDesc")_"(嘱托)"
    
    i firstTimeOrd'="" s val("arcimDesc")=val("arcimDesc")_"(首次:"_firstTimeOrd_")"
    //s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeordId_"||"_oeoriSub)
    //q:orcatId="" 1
    i ("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^") s disposeStatCode="Needless" //070206
    i oecprCode="STAT" s val("phcfrCode")="ST"  ;by xin ///???
    s val("createDateTime")=..FormatDate(oeoriDate)_" "_..FormatTime(oeoriTimeOrd)
    s val("sttDateTime")=..FormatDate(sttDate)_" "_..FormatTime(sttTime)
    
    //打印标记和采血日期时间
    s pmark=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",1)
    s val("prtFlag")=pmark  //显示多日的长嘱单 ypz 061226
    s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
    s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
    s val("specCollDateTime")=..FormatDate(specCollDate)_" "_..FormatTime(specCollTime)
    
    //s val("pdaNurExec")=$G(pdaNurExec)
    //暂时没用了
    s val("pdaNurExec")=""
    i ordStatusCode="PD" s val("PreDisDateTime")=val("xDateTime")
    //i ordStatusCode="TPD" s val("PreDisDateTime")=..GetPreStopDate(oeordId,oeoriSub)
    s val("PreDisDateTime")=..GetPreStopDate(oeordId,oeoriSub)
    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
    //i specCode'="" s val("specDesc")=$p($g(^TTAB("SPEC",specCode)),"\",1)
    i specCode'="" s val("specDesc")=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2)

    //病理
    s blLabNo=##class(web.DHCPisApplicationSheet).GetRowIdByOrderDr(oeordId_"||"_oeoriSub)
    i blLabNo'="" d
    .s val("labNo")=blLabNo
    .s specDateInfo=""
    .s val("specDesc")=##class(web.DHCPisApplicationSheet).GetSpecimensinfo(blLabNo)
    s placerCode=""
    i ordStat'="D" d  
        .s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(oeoriId)
        .i $p(placerStr,"^",5)'="" s placerCode=$p(placerStr,"^",5)
    s resStr=""
    s oreStr=$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
 	
    i (disposeStatCodeStr'[("^"_disposeStatCode_"^"))&&((excute="false")&(unExec="false")) q "不包含该处置状态"_disposeStatCode //'$d(^TMP("NurQuery",userId,tmpId,"printed"))&
    
    q:((disposeStatCode'="LongNew")&(disposeStatCode'="Temp"))&(newOrd="true") "新医嘱不包含该处置状态"_disposeStatCode 
    
   
    q:(disposeStatCode'="Exec")&&(disposeStatCode'="ExecDiscon")&&(excute="true")&(unExec="false") "已执行不包含该处置状态"_disposeStatCode 
    
    q:((disposeStatCode="Exec")!(disposeStatCode="ExecDiscon"))&&((unExec="true")&&(excute="false")) "未执行不包含该处置状态"_disposeStatCode  
    
    s longStr="^S^OMST^OMCQZT^"
    q:(longStr'[("^"_oecprCode_"^"))&&(long="true") "不包含长期"
    s tempStr="^STAT^PRN^NORM^ONE^OM^OUT^OMLSZT^"
    q:(tempStr'[("^"_oecprCode_"^"))&&(temp="true") "不包含临时"
    //ExecDiscon
    //w disposeStatCode_"@"_excute,!
    s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)
    
    s resStr="",tmpPrtFlag=val("prtFlag") //,tmpSeqNo=$p(val("seqNo"),".",1)*100+$p(val("seqNo"),".",2)
    //皮试显示医嘱
    q:(varType["PS")&($g(^TMP("SkinTest",$j,oeordId_"||"_oeoriSub))=1) "皮试显示一条"
    i varType["PS" d 
    .s ^TMP("SkinTest",$j,oeordId_"||"_oeoriSub)=1
    //需处理医嘱显示一条
    
    s seeOrdInfo=..GetSeeOrdInfo(oeordId,oeoriSub)
    q:((varType["PS")!(varType["ps"))&(skintest'="Y") "皮试单只显示皮试医嘱"
    q:(varType["DefaultSee")&(ordStat'="V") "只显示新开"
    q:(seeOrdInfo'="^^")&(varType["DefaultSee")&(excute'="true") "已处理不显示"
    s ordSttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    s ordSttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    s ordComparDateTime=ordSttDate*86400+ordSttTime
	s fromDateTime=fromDate*86400+startTime
	s toDateTime=toDate*86400+endTime
    q:(seeOrdInfo'="^^")&(varType["DefaultSee")&(excute="true")&((ordComparDateTime>toDateTime)!(ordComparDateTime<fromDateTime)) "时间不符合"
    q:(seeOrdInfo="^^")&(varType["DefaultSee")&(excute="true") "已处理"
    q:(varType["DefaultSee")&($g(^TMP("SeeOrder",$j,oeordId_"||"_oeoriSub))=1) "需处理医嘱显示一条"
    i varType["DefaultSee" d 
    .s ^TMP("SeeOrder",$j,oeordId_"||"_oeoriSub)=1
    
    s SeqNotemp=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    q:((varType'["PS")&(varType'["ps"))&(SeqNotemp'="")&($g(^TMP("OrderGroup",$j,SeqNo))'=1) "主医嘱不在，子医嘱过滤" ///主医嘱不在，子医嘱过滤
    s ^TMP("OrderGroup",$j,SeqNo)=1 //成组医嘱用
	
    f ivar=1:1:^DHCCLNurseExec("Var",0)
    {
        s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        i $g(tPos(varName))'="" s $p(resStr,"!",tPos(varName))=val(varName)
    }
    i resStr'=""
    {
         s tmpSttDate=sttDate
         s seqNochl=oeoriSub
         s tmpOeoriId=oeoriId
         s tmpSttDate=sttDate+(sttTime/100000)
         s seqNochl=oeoriSub+(oeoreSub/100)
         s tmpOeoriId=oeoreId
         s tmpSeqNo=SeqNo
         s resStr=resStr_"!"_tmpOeoriId_"!"_placerCode_"!"_disposeStatCode_"!"_tmpPrtFlag_"!"_tmpSeqNo_"!"_sttDate
         s ^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,tmpSttDate,tmpSeqNo,seqNochl)=resStr
    }
    f ivar=1:1:^DHCCLNurseExec("Var",0)
    {
        s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        s val(varName)="" 
    }
    q resStr
}

/// 按指定项取病人或病区的医嘱
ClassMethod GetOrderItem(admId As %String, fDateStr As %String, tDateStr As %String, userId As %String, wardId As %String, varType As %String, Loc As %String, doctyp As %String, ArcimDR As %String = "", HospitalRowId As %String = "", excute As %String = "false", long As %String = "false", temp As %String = "false", startTime As %String = "", endTime As %String = "", otherArg...)
{
  //d ##Class(web.DHCLCNUREXCUTE).GetOrderItem("","",11,"","",1,89,"Default","")
    n (itmjs, itmjsex,admId, fDateStr, tDateStr, userId, wardId, varType,Loc, doctyp,ArcimDR,HospitalRowId,excute,long,temp,startTime,endTime,otherArg)
    s newOrd=$g(otherArg(1))
    s unExec=$g(otherArg(2))
	s prnOrd=$g(otherArg(3))
	s startCheck=$g(otherArg(4))
    q:admId="" -2
    q:(varType="")!(HospitalRowId="") -1
    s locType=""
    i Loc'="" s locType=$p(^CTLOC(Loc),"^",13) 
    s patTempLoc=$P($g(^PAADM(admId)),"^",74)
    q:(wardId="")&(locType'="OP")&(patTempLoc="")&(Loc="") -3  
    k ^TMP("NurQuery",$j,userId,"NurseExec"),^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort"),tPos,val
    k ^TMP("SkinTest",$j) //皮试用
    k ^TMP("SeeOrder",$j) //需处理用
    k ^TMP("OrderGroup",$j) //成组医嘱用
    s num=0
    s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"VarId"))
    q:varStr="" -2
    s varCount=$l(varStr,"^") ;对应项
    f ivar=1:1:varCount d 
        .s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
        .s tPos(varName)=ivar
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s val(varName)=""
    s today=$p($h,",",1)  
    s fromDate=+fDateStr 
    i $l(fDateStr,"/")=3 s fromDate=$zdh(fDateStr,4)
    i $l(fDateStr,"-")=3 s fromDate=$zdh(fDateStr,3)
    s fromDate=##class(websys.Conversions).DateHtmlToLogical(fDateStr)
    i fDateStr="" s fromDate=+$h
    s toDate=+tDateStr
    i $l(tDateStr,"/")=3 s toDate=$zdh(tDateStr,4)
    i $l(tDateStr,"-")=3 s toDate=$zdh(tDateStr,3)
    s toDate=##class(websys.Conversions).DateHtmlToLogical(tDateStr)
    i tDateStr="" s toDate=+$h
    i fromDate>toDate q -3
    i startTime="" s startTime=0
    i startTime="23:59" s startTime=86400
    i startTime[":" s startTime=$zth(startTime)
    i endTime="" s endTime=86400
    i endTime="23:59" s endTime=86400
    i endTime[":" s endTime=$zth(endTime)
    s oecatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OrCat"))_"^"
    s oecprIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OecPr"))_"^"
    s ordStatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OrdStat"))_"^"
    s phcinIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"PhcIn"))_"^"
    s specCodeStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"Spec"))_"^"
    s recLocStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"RecLoc"))_"^"
    s fDate=fromDate
    s tDate=toDate
    s oeordId=$o(^OEORD(0,"Adm",admId,0)) 
    q:oeordId="" ""
    s:varType["DefaultSee" tDate=tDate+1
    s fDateTime=fromDate*86400+startTime
    s tDateTime=toDate*86400+endTime
    i startCheck="true" d
    .s fDate=+$h,tDate=+$h,startTime=0,endTime=86400 ;按开医嘱时间查询,默认查询当天的执行记录
    .s fromDate=+$h,toDate=+$h
    f ordSttDate=fDate:1:tDate
    {
	        ;q:(prnOrd="true")&(varType["DefaultSee")
	        q:(varType["DefaultSee")
	        s ordSttTime=""
	        f
	        {
		       s ordSttTime=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime))
		       q:ordSttTime=""
        		s oeoriSub=0
        		f  
        		{
	        		
	        		s oeoriSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub))
					
	        	    q:oeoriSub=""
	        	    
	        	    s ordInfo=..GetSeeOrdInfo(oeordId,oeoriSub)
	    			continue:ordInfo="^^"  //过滤未处理的医嘱
	        	    
	        	    s OrdStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) //20130122discontinue do GetXOrderItemSingle 
	    			continue:OrdStatDR=""
	    			s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)
	        	    ;continue:(OrdStatCode="D")&((varType["DefaultSee")!(varType["Default"))
	        	      	    
	        	    //prn
	        	    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        			i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
        			continue:($g(phcfrCode)'="Prn")&&(prnOrd="true")
	        	    //s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub_"||"_oeoreSub)
			        //q:(ordStatusCode="")
			        ///OP 科室 只显示 本科室的医嘱
			        i locType="OP" s ordDocLoc=..GetOrdDocLoc(oeordId,oeoriSub)
			        continue:((locType="OP")!(patTempLoc'=""))&($G(ordDocLoc)'[("^"_Loc_"^"))
			        s ctcptType=""
			        i $g(doctyp)="true" s ctcptType="DOCTOR"
			        s locIdStr=""
			       
					s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,ctcptType,locIdStr,oeordId_"||"_oeoriSub)
			        ;q:(curDocFlag'="Y")&(locType'="OP")&(patTempLoc="")
			        continue:(wardId'="")&(curDocFlag'="Y")&(locType'="OP")&(patTempLoc="") //+wxl090814
			        s curDocFlag=##Class(web.DHCNurCom).OrdLocLinkDoc(Loc,ctcptType,oeordId_"||"_oeoriSub)
			        
			        continue:(curDocFlag'="Y")&((locType'="OP")&(patTempLoc="")) 
			       
			        s flag=0
			        s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
			        &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val

("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
			        i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
			        s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
			        s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) 
			        continue:(oecprIdStr'[("^"_oecprId_"^"))&(oecprId'="")  //优先级
			        continue:(phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="")  //用法途径
			        s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))  
			        continue:(SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="")  //医嘱大类
			        continue:(SubCatFlag="Y")&(oecatIdStr'[("^"_arcicId_"^"))&(arcicId'="")	//医嘱子类
			        s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
			        continue:(specCodeStr'[("^"_specCode_"^"))&(specCode'="")&(specCodeStr'="^^") //标本类型
			        s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
			        continue:(recLocStr'[("^"_reclocId_"^"))&(reclocId'="")&(recLocStr'="^^")   //接受科室
			        //s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
			        s SeqNotemp=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) 
			        i $G(SeqNotemp)="" s SeqNotemp=oeordId_"||"_oeoriSub
			        s seq1=$P(SeqNotemp,"||",1)
			        s seq2=$P(SeqNotemp,"||",2)
			        s arcimIdtemp1=$p($g(^OEORD(seq1,"I",seq2,1)),"^",2)
			        s arcimIdtemp2=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
			        continue:(ArcimDR'="")&(arcimIdtemp1'=ArcimDR)&(arcimIdtemp2'=ArcimDR)
			        s CreateDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    				s CreateTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    				s createDateTime=CreateDate*86400+CreateTime
    				continue:((createDateTime<fDateTime)||(createDateTime>tDateTime))&&(startCheck="true")
	        	    s oeoreSub=0
	        	    f
	        	    {
		        	    s oeoreSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub,oeoreSub))
		        	    q:oeoreSub=""
		        	    s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)
		        	    continue:(ordStatIdStr'[("^"_ordStatusId_"^"))&(ordStatusId'="") //医嘱状态
						s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)   //keep dup
						s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)   //keep dup
			        	;s orddate1=sttDate,ordtime1=sttTime
			       		;s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)  //医嘱生成日期
			            ;s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17) //医嘱生成时间
			            ;i (((orddate1+1>fromDate)&(orddate1-1<toDate))!((orddate1+1=fromDate)&(ordtime1'<startTime))!((orddate1-1=toDate)&(ordtime1<endTime))) s flag=1
			            ;q:flag'=1
			            s ordComparDateTime=sttDate*86400+sttTime
			            s fromDateTime=fromDate*86400+startTime
			            s toDateTime=toDate*86400+endTime
			            q:(ordComparDateTime>toDateTime)!(ordComparDateTime<fromDateTime)
			            f ivar=1:1:^DHCCLNurseExec("Var",0)
			            {
			                s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
			                s val(varName)=""
			            }
			           
			            s rStr=..GetOrderItemSingle(admId,wardId,oeordId,oeoriSub,oeoreSub,varType,.val,.tPos,userId,fromDate,toDate,HospitalRowId,excute,long,temp,newOrd,unExec,startTime,endTime)
						 //w !,rStr_"@"_oeoreSub,!
						
	        	    }
        		}
	        }
     }
  //显示停止日期时间在最后一条执行记录要求执行日期时间后的医嘱
    s oeoriSub=0
    f  
    {
	    ;q:(varType'["DefaultSee")&(varType'["Default")
	    q:(varType'["DefaultSee")
	    s oeoriSub=$O(^OEORD(oeordId,"I",oeoriSub))
	    q:(oeoriSub="")!(oeoriSub="0") 
	    s ctcptType=""
		i $g(doctyp)="true" s ctcptType="DOCTOR"
		s locIdStr=""
			       
		s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,ctcptType,locIdStr,oeordId_"||"_oeoriSub)
		continue:(wardId'="")&(curDocFlag'="Y")&(locType'="OP")&(patTempLoc="") //+wxl090814
		s curDocFlag=##Class(web.DHCNurCom).OrdLocLinkDoc(Loc,ctcptType,oeordId_"||"_oeoriSub)
		continue:(curDocFlag'="Y")&((locType'="OP")&(patTempLoc=""))
		
		i locType="OP" s ordDocLoc=..GetOrdDocLoc(oeordId,oeoriSub)
		continue:((locType="OP"))&($G(ordDocLoc)'[("^"_Loc_"^"))
		
	    s OrdStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) 
	    continue:OrdStatDR=""
	    s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)
	    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
        continue:($g(phcfrCode)'="Prn")&&(prnOrd="true")
       



	    s ordXinfo=..GetXOrdInfo(oeordId,oeoriSub)
	    ;continue:(ordXinfo'="^^")&&(OrdStatCode="D")
	    continue:(ordXinfo="^^")&&(OrdStatCode="D")&&(excute="true")
	    continue:(ordXinfo'="^^")&&(OrdStatCode="D")&&(excute="false")
		
		
	    s ordInfo=..GetSeeOrdInfo(oeordId,oeoriSub)
	    s seeOrdDate=$p(ordInfo,"^",2)
	    continue:($g(phcfrCode)="Prn")&&($g(seeOrdDate)'="")&&($g(seeOrdDate)=+$h)&&(excute="false")
	    continue:($g(phcfrCode)="Prn")&&(($g(seeOrdDate)="")!(($g(seeOrdDate)'="")&&($g(seeOrdDate)'=+$h)))&&(excute="true")
	    
	    continue:(ordInfo="^^")&&(excute="true")&&(OrdStatCode'="D")
	    continue:(ordInfo'="^^")&&(excute="false")&&(OrdStatCode'="D")
	    

	

	    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	    &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val

("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
	    i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
	    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) 
	    continue:(ordStatIdStr'[("^"_OrdStatDR_"^"))&(OrdStatDR'="") //医嘱状态
	    continue:(oecprIdStr'[("^"_oecprId_"^"))&(oecprId'="")  //优先级
	    continue:(phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="")  //用法途径
	    s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))  
	    continue:(SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="")  //医嘱大类
	    continue:(SubCatFlag="Y")&(oecatIdStr'[("^"_arcicId_"^"))&(arcicId'="")	//医嘱子类
	    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
	    continue:(specCodeStr'[("^"_specCode_"^"))&(specCode'="")&(specCodeStr'="^^") //标本类型
	    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	    continue:(recLocStr'[("^"_reclocId_"^"))&(reclocId'="")&(recLocStr'="^^")   //接受科室
	    s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	    f ivar=1:1:^DHCCLNurseExec("Var",0)
	    {
		    s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
		    s val(varName)=""
	    }
	   
	    s SeqNotemp=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) 
	    i $G(SeqNotemp)="" s SeqNotemp=oeordId_"||"_oeoriSub
	    s seq1=$P(SeqNotemp,"||",1)
	    s seq2=$P(SeqNotemp,"||",2)
	    s arcimIdtemp1=$p($g(^OEORD(seq1,"I",seq2,1)),"^",2)
	    s arcimIdtemp2=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	    continue:(ArcimDR'="")&(arcimIdtemp1'=ArcimDR)&(arcimIdtemp2'=ArcimDR)
	    s rStr=..GetXOrderItemSingle(admId,wardId,oeordId,oeoriSub,"",varType,.val,.tPos,userId,fromDate,toDate,HospitalRowId,excute,long,temp)
    }   
     
    s admId=""
    f  s admId=$o(^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId)) q:admId=""  d
        .s sttDate=""
        .f  s sttDate=$o(^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,sttDate)) q:sttDate=""  d
        ..s seqNo=""
        ..f  s seqNo=$o(^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,sttDate,seqNo)) q:seqNo=""  d
        ...s sq=""
        ...f  s sq=$o(^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,sttDate,seqNo,sq)) q:sq=""  d
        ....s num=num+1,^TMP("NurQuery",$j,userId,"NurseExec",num)=^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort",admId,sttDate,seqNo,sq)
    k ^TMP("NurQuery",$j,userId,"NurseExecSeqNoSort")
    q num
}

ClassMethod GetIfSeeOrder(admId As %String, wardId As %String, Loc As %String)
{
	s oeordId=$o(^OEORD(0,"Adm",admId,0)) 
    q:oeordId="" 0
    
	s varType="DefaultSee"
	s doctyp="true"
	s excute="false"
	s doctyp="true"
	s locType=""
	s oeoriSub=0
	s prnOrd="false"
	s HospitalRowId=$p($g(^CTLOC(Loc)),"^",22)
	s HospitalRowId=0
	i HospitalRowId="" s HospitalRowId=0

	s oecatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OrCat"))_"^"
    s oecprIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OecPr"))_"^"
    s ordStatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"OrdStat"))_"^"
    s phcinIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"PhcIn"))_"^"
    s specCodeStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"Spec"))_"^"
    s recLocStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"RecLoc"))_"^"
    s flag=0
	s patTempLoc=$P($g(^PAADM(admId)),"^",74)
    f  
    {
	    ;q:(varType'["DefaultSee")&(varType'["Default")
	    q:(varType'["DefaultSee")
	    s oeoriSub=$O(^OEORD(oeordId,"I",oeoriSub))
	    q:(oeoriSub="")!(oeoriSub="0") 
	    s ctcptType=""
		i $g(doctyp)="true" s ctcptType="DOCTOR"
		s locIdStr=""
			       
		s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,ctcptType,locIdStr,oeordId_"||"_oeoriSub)
		continue:(wardId'="")&(curDocFlag'="Y")&(locType'="OP")&(patTempLoc="") //+wxl090814
		s curDocFlag=##Class(web.DHCNurCom).OrdLocLinkDoc(Loc,ctcptType,oeordId_"||"_oeoriSub)
		continue:(curDocFlag'="Y")&((locType'="OP")&(patTempLoc=""))
		
	    s OrdStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) 
	    continue:OrdStatDR=""
	    s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)
	    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
        continue:($g(phcfrCode)'="Prn")&&(prnOrd="true")
       


	
	    s ordXinfo=..GetXOrdInfo(oeordId,oeoriSub)
	    ;continue:(ordXinfo'="^^")&&(OrdStatCode="D")
	    continue:(ordXinfo="^^")&&(OrdStatCode="D")&&(excute="true")
	    continue:(ordXinfo'="^^")&&(OrdStatCode="D")&&(excute="false")
		
		
	    s ordInfo=..GetSeeOrdInfo(oeordId,oeoriSub)
	    s seeOrdDate=$p(ordInfo,"^",2)
	    continue:($g(phcfrCode)="Prn")&&($g(seeOrdDate)'="")&&($g(seeOrdDate)=+$h)&&(excute="false")
	    continue:($g(phcfrCode)="Prn")&&(($g(seeOrdDate)="")!(($g(seeOrdDate)'="")&&($g(seeOrdDate)'=+$h)))&&(excute="true")
	    
	    continue:(ordInfo="^^")&&(excute="true")&&(OrdStatCode="V")
	    continue:(ordInfo'="^^")&&(excute="false")&&(OrdStatCode="V")
	    

	    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	    &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val

("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
	    i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
	    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) 
	   
	    continue:(ordStatIdStr'[("^"_OrdStatDR_"^"))&(OrdStatDR'="") //医嘱状态
	    
	  
	    continue:(oecprIdStr'[("^"_oecprId_"^"))&(oecprId'="")  //优先级
	    
	  
	    continue:(phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="")  //用法途径
	    
	   
	    s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))  
	    continue:(SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="")  //医嘱大类
	    continue:(SubCatFlag="Y")&(oecatIdStr'[("^"_arcicId_"^"))&(arcicId'="")	//医嘱子类
	    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
	    continue:(specCodeStr'[("^"_specCode_"^"))&(specCode'="")&(specCodeStr'="^^") //标本类型
	    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	    continue:(recLocStr'[("^"_reclocId_"^"))&(reclocId'="")&(recLocStr'="^^")   //接受科室
	    
	   
	    s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	    f ivar=1:1:^DHCCLNurseExec("Var",0)
	    {
		    s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
		    s val(varName)=""
	    }
	   	b ;
	    s flag=1 q
    }
    q $g(flag)
}

ClassMethod GetOrdAlertNum(userId) As %String
{
  q $g(^DHCCLNurseExec("gapordnum",userId))
}

ClassMethod GetNow()
{
   n 
   s str=$h
   q str
}

ClassMethod GetData(itmjs As %Library.String = "", itmjsex As %Library.String = "", number As %String, userId = "")
{
      q:(+userId=0)!(+number=0) ""
      s str=$g(^TMP("NurQuery",$j,userId,"NurseExec",number))
      s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
      i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
      k ^TMP("NurQuery",$j,userId,"NurseExec",number)
      //&javascript<#(retval)#>
   q str
}

ClassMethod kmtemp()
{
 //删除query 查询标志
	//k ^mtemp("query")
	q $i
}

/// 取处置名称
ClassMethod GetDisposeDesc(code)
{
    q:code="" ""
	s DisposeDesc=""
	s disposeId=0
	f  s disposeId=$o(^DHCCLNurseExec("DisposeStat",disposeId)) q:disposeId=""  d
	    .i $p(^DHCCLNurseExec("DisposeStat",disposeId),"^",2)=code s DisposeDesc=$p(^DHCCLNurseExec("DisposeStat",disposeId),"^",1)
	s dts=$zd(+$H,3)_" "_$zt($p($H,",",2),2)
	q DisposeDesc_"|"_dts
}

/// 取长期医嘱滚动时间
ClassMethod GetCQOrdTime()
{
	n startTimef,endTimeT 
	k P1
	i $d(^DHCCLNurseExec("CQORD"))'=0  d
	    .s startTimef=$g(^DHCCLNurseExec("CQORD","STARTIME"))
	    .s endTimeT=$g(^DHCCLNurseExec("CQORD","ENDTIME"))
	    .s P1=$zt(+startTimef)_$c(23)_$zt(+endTimeT)
	e  d
	    .s startTimef="23:40:00"
	    .s endTimeT="02:00:59"
	    .s P1=startTimef_$c(23)_endTimeT
	q P1
}

/// 取病人社会地位(医保)
ClassMethod GetPatMedicare(admId As %String)
{
    s papersonId=$p($g(^PAADM($g(admId))),"^",1)
	q:$g(papersonId)="" ""
	s SocialStatus=$p($g(^PAPER($g(papersonId),"PER",1)),"^",10)
	q:$g(SocialStatus)="" ""
	s SocialDESC=$p($g(^CT("SS",SocialStatus)),"^",2)
	q $g(SocialDESC)
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// 取执行设置时间
ClassMethod GetExecStTime(oeoriId As %String)
{
    &sql(declare pexst cursor for select oeore_exsttime  from oe_ordexec where oeore_oeori_parref=:oeoriId)
	s timeStr=""
	&sql(open pexst)
	f  &sql(fetch pexst into:execTime)  q:SQLCODE  d
	    .s timeStr=timeStr_","_$zt(+execTime)
	&sql(close pexst)
	q timeStr
}

/// 取查找的起止日期
ClassMethod GetSearchDate(userId As %String)
{
    s fromDate=$g(^TMP("NurExec",userId,"DateStart"))
	i fromDate'="" s fromDate=$zd(fromDate,3)
	s toDate=$g(^TMP("NurExec",userId,"DateEnd"))        
	i toDate'="" s toDate=$zd(toDate,3)
	q (fromDate_"^"_toDate)
}

/// 取用户代码
ClassMethod GetUserCode(userId As %String)
{
    i userId="" q ""
    s usrStr=^SSU("SSUSR",userId)
    s userCode=$p(usrStr,"^",1)
    q userCode
}

ClassMethod SetDisconOrderOld(oeoriId As %String, userId As %String)
{
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:oeoriId,:userId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
    //s ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)=+$h_"^"_$p($h,",",2)_"^"_userId
    s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
        .s curOeoriId=oeordId_"||"_curOriSub
        .s dhcoriId=$o(^DHCORDItem(0,curOeoriId,""))
		.s curDate=+$h,curTime=$p($h,",",2)
		.i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:curOeoriId,:userId,:curDate,:curTime))
		.e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:curOeoriId)
    q +$h_"^"_$p($h,",",2)
}

ClassMethod SetDisconOrder(oeoreId As %String, userId As %String)
{
	n (oeoreId,userId)
	s curDate=+$h,curTime=$p($h,",",2)
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s curOeoriId=oeordId_"||"_oeoriSub
    s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(curOeoriId)
    s stopOrdInfo=##class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeoriSub)
    s XDate=$p(stopOrdInfo,"^",2)
	s XTime=$p(stopOrdInfo,"^",3) 
    s usrStr=^SSU("SSUSR",userId)
    s userCode=$p(usrStr,"^",14)
    s SQLCODE=0
    i (ordStatusCode="D")&(oeoreSub="")&(XDate="") {
    	&sql(update OE_OrdItemExt set OEORI_DisconUser_DR=:userId,OEORI_DisconDate=:curDate,OEORI_DisconTime=:curTime where OEORI_RowId=:curOeoriId)
    	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),-1) q:(oeoreSub=0)!(oeoreSub="")  d
    	.s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)  
		.s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 		.s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
 		.s execStatusCode=""
		.i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)
		.q:ordStat'="D"
		.q:execStatusCode="D"
		.d ##class(appcom.OEOrdExec).UpdateStatus(oeordId_"||"_oeoriSub_"||"_oeoreSub,"D",userId,curDate,curTime,"")
		s chl=0
		f  s chl=$O(^OEORDi(0,"OEORI",oeordId,oeordId_"||"_oeoriSub,chl)) q:chl=""  d
		.s oeoreIdSub=oeordId_"||"_chl
		.&sql(update OE_OrdItemExt set OEORI_DisconUser_DR=:userId,OEORI_DisconDate=:curDate,OEORI_DisconTime=:curTime where OEORI_RowId=:oeoreIdSub)
	}
    else
     {
	    d ##class(appcom.OEOrdExec).UpdateStatus(oeoreId,"D",userId,curDate,curTime,"")
     }
    ;s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
        ;.s curOeoriId=oeordId_"||"_curOriSub_"||"_oeoreSub
        ;.d ##class(appcom.OEOrdExec).UpdateStatus(curOeoriId,"D",userId,curDate,curTime,"")
    q SQLCODE
}

ClassMethod UndoDisconOrder(oeoreId As %String, userId As %String)
{
	n (oeoreId,userId)
	s curDate=+$h,curTime=$p($h,",",2)
	s ok=##class(appcom.OEOrdExec).UpdateStatus(oeoreId,"D",userId,curDate,curTime,"")
    q ok
}

ClassMethod GetTitle(varType As %String, HospitalRowId As %String)
{
    q:(varType="")!($G(HospitalRowId)="") ""
    s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,varType,"VarId"))
    s num=$l(varStr,"^")
    f ivar=1:1:num d
        .s $p(titles,"!",ivar)=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",1)
        .s $p(vars,"!",ivar)=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
    q num_"^"_$g(titles)_"^"_$g(vars)
}

ClassMethod FormatDate(dateVal As %String)
{
	q:dateVal="" ""
	If (##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateFormat")) d
	.s dateVal=##class(websys.Conversions).DateLogicalToHtml(dateVal)
	e  s dateVal= $zd(dateVal,3)
	q dateVal
}

ClassMethod FormatTime(timeVal As %String)
{
	q:timeVal="" ""
	q $zt(timeVal)
}

ClassMethod FindOrditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindOrditemExecute(ByRef qHandle As %Binary, wardid As %String, RegNo As %String, userId As %String, StartDate As %String = "", EndDate As %String = "", vartyp As %String, gap As %String, Loc As %String, doctyp As %String, longNewOrdAdd As %String, onlyNewOrd As %String, ArcimDR As %String = "", pdaExec As %String = "", HospitalRowId As %String = "", StartTim As %String = "", EndTim As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s TMPSEL=""
    s execute=$G(%request.Data("execute",1))
    i execute="" s execute="false"
    s PatStr=$G(%request.Data("PatStr",1))
    s BEDSEL=""
    d ##class(Nur.Android.Common).getselbed(userId,.BEDSEL)
    if PatStr'=""
    {
         s Adm="" //多人选择
         s l=$L(PatStr,"^")
         for i=1:1:l
         {
           s itm=$P(PatStr,"^",i)
           if itm="" continue
           s TMPSEL(itm)=""
         }
    }
    
    if userId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s tmpRes=##Class(web.DHCNurCom).FindPatient(wardid,RegNo,userId,"I") 
    s patstr=..GetAllPatient("","",userId)
    s num=$l(patstr,"^")
    i patstr="" s num=0 //ypz 070108
    s ^DHCCLNurseExec("gapordnum",userId)=0  //$ZTH("18:30") //
    k ^DHCCLNurExec("gapname",userId)
    s varStr=^DHCCLNurseExec("VarDef",HospitalRowId,vartyp,"VarId")
    s varCount=$l(varStr,"^") ;对应项
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s data(varName)=""
    k ^TMP("NurPrint",userId)
    s ^TMP("NurPrint",userId,"j")=$j
    f i=1:1:num
    {
        s pat=$p(patstr,"^",i)
        s admId=$p(pat,"!",1)
        s curWardId=$p($g(^PAADM(admId)),"^",70)
        s patTempLoc=$P($g(^PAADM(admId)),"^",74)
        
        s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
        s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
        
        if ((PatStr'="")&('$D(TMPSEL(admId))))
        {
             continue
       
        }else{
                if (RegNo="") 
                {
                    if $G(BEDSEL(bedCode))="" continue
                }

            }
        
        s locType="" //ypz 070723
        i Loc'="" s locType=$p(^CTLOC(Loc),"^",13) //ypz 070723
        //i locType'="OP" s Loc=$G(%session.Data("LOGON.CTLOCID"))
        i ((curWardId'="")&(curWardId=wardid))!(locType="OP")!(patTempLoc'="") //ypz 070723
        {
            i $g(^TMPNurIPDebug)="Y" k ^TMPNurIPDebug(admId)
            
            s lisnum=..GetOrderItem(admId,StartDate,EndDate,userId,wardid,vartyp,Loc,doctyp,ArcimDR,HospitalRowId,execute,"false","false",StartTim,EndTim,"","","","","","","","false")
            s curTmpId=$p(lisnum,"^",2),lisnum=+lisnum
            i $g(^TMPNurIPDebug)="Y" s ^TMPNurIPDebug(admId,"0 listnum")=lisnum
            f j=1:1:lisnum
            {  
                s ordstr=..GetData("","",j,userId)
                s ordnum=$I(^TMP("NurPrint",userId,$j))

                s ^TMP("NurPrint",userId,$j,ordnum)=ordstr

                f ivar=1:1:varCount 
                {
                    s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
                    s data(varName)=$p(ordstr,"!",ivar)
                } 
                s data("admId")=admId
                s oeoriId=$p(ordstr,"!",ivar+1)
                s placerCode=$p(ordstr,"!",ivar+2) 
                s disposeStatCode=$p(ordstr,"!",ivar+3)
                s tmpPrtFlag=$p(ordstr,"!",ivar+4)
                /*i data("ordStatDesc")'="停止" 
                {
                s data("execXDateTime")=""
                s data("execXUserDesc")=""
                s data("xCtcpDesc")=""
                s data("xDateTime")=""
                }
                i data("execCtcpDesc")=""  s data("execDateTime")="" */
                i (vartyp="WZXCX")&(data("execCtcpDesc")'="")
                {
                    //q////过滤已执行医嘱qse060306
                }
                else{
                    Do OutRow
                }
           }
     	}
	}
    s ^DHCCLNurseExec("gapTime",userId)= $p($H,",",2) ///$p($h,",",2)
	//k ^TMP("NurQuery",userId,tmpId) //071113

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),data("seqNo"),data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("admId"),data("placerNo"),data("DspStat"),data("PreDisDateTime"),data("specCollDateTime"),data("specDesc"),data("pdaNurExec"))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindOrditem(wardid As %String, RegNo As %String, userId As %String, StartDate As %String, EndDate As %String, vartyp As %String, gap As %String, Loc As %String, doctyp As %String, longNewOrdAdd As %String, onlyNewOrd As %String, ArcimDR As %String, pdaExec As %String, HospitalRowId As %String = "", StartTim As %String, EndTim As %String) As %Query(ROWSPEC = "prtFlag,regNo,bedCode,patName,patIdentity,age,orcatDesc,seqNo,arcimDesc,oecprDesc,ordStatDesc,labNo,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,execStat,execDateTime,execCtcpDesc,ctcpDesc,disposeStatDesc,reclocDesc,sttDateTime,xDateTime,execXUserDesc,prescNo,price,totalAmount,execXDateTime,xCtcpDesc,createDateTime,oeoriId,placerCode,disposeStatCode,tmpPrtFlag,Durat,EpisodeID,placerNo,DspStat,PreDisDateTime,specCollDateTime,specDesc,pdaNurExec")
{
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

ClassMethod GetTmpPrintedDataNum(user) As %String
{
	n (user)
	s proc=^TMP("Printed",user,"J")
	q ^TMP("Printed",user,proc)
}

ClassMethod GetTmpPrintedData(user, num) As %String
{
 //qse add 061213
	n (user,num)
	s proc=^TMP("Printed",user,"J")
	q ^TMP("Printed",user,proc,num)
}

ClassMethod GetPrintedItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintedItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPrintedItemExecute(ByRef qHandle As %Binary, pDateStr As %String, pTimeStr As %String, wardId As %String, querytyp As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s ^TM=pDateStr_"|"_pTimeStr
 	s PrintUser=%session.Data("LOGON.USERID")
 	k ^TMP("Printed",PrintUser)  //清除临时数据
 	i (pDateStr="")!(wardId="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	i (pDateStr="")!(pTimeStr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
 	//s pDate=$zdh(pDateStr,4),pTime=$zth(pTimeStr)
	//w !,pDateStr,"^",pTimeStr,"^",wardId,"^",querytyp
	s pDate=pDateStr,pTime=pTimeStr
	s i=0
	s ^TMP("Printed",PrintUser,"J")=$i
	s user="" f  s user=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
    .s rw=""  f  s rw=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user,rw)) q:rw=""  d
    ..s oeore=$p(^DHCOrdExec(rw),"^",1) 
    ..s flag=$p(^DHCOrdExec(rw),"^",3)
    ..q:flag'["Y"
    ..s ord=$p(oeore,"||"),chl=$p(oeore,"||",2)
    ..s oeoriId=ord_"||"_chl
    ..s i=i+1
    ..s ^TMP("Printed",PrintUser,$i,i)=oeoriId
	..s arcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	..s str=$$patinfo(oeoriId)
	..s regNo=$p(str,"|",1)
    ..s patName=$p(str,"|",2)
    ..s bedCode=$p(str,"|",3)
    ..Do OutRow1
    s ^TMP("Printed",PrintUser,$i)=i
    set qHandle=$lb(0,repid,0)
	Quit $$$OK

patinfo(oeoriId)
 {
	s oeordId=$p(oeoriId,"||",1)
	s papmiId=+^PAADM($p($g(^OEORD(oeordId)),"^",1))
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s roomdr=$p(^PAADM($p($g(^OEORD(oeordId)),"^",1)),"^",69)
    s bedSub=$p($p($g(^PAADM($p($g(^OEORD(oeordId)),"^",1))),"^",73),"||",2)
    s curWardId=$p($g(^PAADM($p($g(^OEORD(oeordId)),"^",1))),"^",70)
    if (roomdr'="") s room=$p(^PAROOM(roomdr),"^",2)
    //&js<alert("come in oeore else "+"#(curWardId)#"+"/"+"#(admId)#"+"/");>
    if bedSub'="" s bedCode=$g(room)_"-"_$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
  q regNo_"|"_patName_"|"_bedCode
}
OutRow1
	set Data=$lb(regNo,patName,bedCode,oeoriId,arcimDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrintedItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintedItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetPrintedItem(pDateStr As %String, pTimeStr As %String, wardId As %String, querytyp As %String) As %Query(ROWSPEC = "regNo,patName,bedCode,oeoriId,arcimDesc")
{
}

ClassMethod GetPrintedDataHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintedDataHExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPrintedDataHExecute(ByRef qHandle As %Binary, fDateStr As %String, tDateStr As %String, curWardId As %String, loc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	if (fDateStr="")!(tDateStr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s resStr=-1,num=0
 //	s fromDate=$zdh(fDateStr,3),toDate=$zdh(tDateStr,3)
    s wardId=curWardId
 	s fromDate=fDateStr,toDate=tDateStr
	f pDate=fromDate:1:toDate d
	    .s pTime=""
	    .f  s pTime=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime)) q:pTime=""  d
	    ..s querytyp="" f  s querytyp=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp)) q:querytyp=""  d
	    ...s user=""  f  s user=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
	    ....s pdateTime=$ZD(pDate,4)_"|"_..FormatTime(pTime)
	    ....//s wardDesc=$p(^PAWARD(wardId),"^",2)
	    ....s formType=querytyp
	    ....q:'$d(^DHCCLNurseExec("VarDef",formType))
	    ....s FormDes=$p(^DHCCLNurseExec("VarDef",formType),"^",1)
	    ....s userDesc=$p(^SSU("SSUSR",user),"^",2)
        ....Do OutRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow2
	set Data=$lb(pdateTime,formType,userDesc,FormDes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrintedDataHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintedDataHExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPrintedDataH(fDateStr As %String, tDateStr As %String, curWardId As %String, loc = "") As %Query(ROWSPEC = "pdateTime,formType,userDesc,FormDes")
{
}

ClassMethod nn(unit)
{
        s num=$p(unit," ",1)
        s uom=$p(unit," ",2)
        i (num[".")&(num<1) s num="."_$p($g(num),".",2)
        q num
}

ClassMethod OrdNote(oeorid, not)
{
	 n (oeorid,not)
	 s oeordId=$p(oeorid,"||",1)
	 s oeoriSub=$p(oeorid,"||",2)
	 k ^OEORD(oeordId,"I",oeoriSub,"REM")
	 k ^OEORD(oeordId,"I",oeoriSub,"DEP")
	 s ^OEORD(oeordId,"I",oeoriSub,"REM",0)=1
	 s ^OEORD(oeordId,"I",oeoriSub,"REM",1)=not
	 s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=1 
	 s ^OEORD(oeordId,"I",oeoriSub,"DEP",1)=not
	 q 0
}

ClassMethod GetNewOrdPat(userId) As %String
{
 //新医嘱病人姓名
    n (userId)
	s ord=""  f  s ord=$o(^DHCCLNurExec("gapname",userId,ord))  q:ord=""  d
	.s patstr=$g(patstr)_^DHCCLNurExec("gapname",userId,ord)_"|"
	q $g(patstr)
}

ClassMethod GetUserWardId(usid, loc, EpisodeID = "")
{
 ///获得用户病区
  n (usid,loc,EpisodeID)
  //s loc=$p(^SSU("SSUSR",usid),"^",4)
  s warddes=$p(^CTLOC(loc),"^",2)
  s loctyp=$p(^CTLOC(loc),"^",13)
  q:loctyp="OP" "^|"_warddes_"^"_loc //ypz 070723
  //q:loctyp'="W" ""  //ward
  q:loctyp'="W" "^|"_warddes_"^"_loc //+wxl090814
  
  s res=""
  
  i EpisodeID'="" d
  .s patTempLoc=$P($g(^PAADM(EpisodeID)),"^",74)
  .s patTempLocLinkStr="^",patTempLocLink=""
  .i patTempLoc'="" d
  ..f  s patTempLocLink=$O(^CTLOC(patTempLoc,"LINK",0,"Loc",patTempLocLink)) q:patTempLocLink=""  d
  ...s patTempLocLinkStr=patTempLocLinkStr_patTempLocLink_"^"
  .i (patTempLoc="")!(patTempLoc'=loc) d
  ..i (patTempLocLinkStr'[("^"_loc_"^")) d
  ...s wardid=$p(^PAADM(EpisodeID),"^",70)
  ...s wardLinkLocId=$p($g(^PAWARD(wardid)),"^",5)      //+091111 取病人就诊病区对应科室表中的科室ID
  ...i wardLinkLocId'=loc s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)		//+091111如果登陆病区与病人就诊病区不一致时取登陆病区
  ...s warddes=$p(^PAWARD(wardid),"^",2)
  ...s depid=$p(^PAADM(EpisodeID),"^",4)
  ...s depdesc=$p(^CTLOC(depid),"^",2)
  ...//s res=warddes_"^"_wardid_"^"_depid_"^"_depdesc
  ...s res=warddes_"^"_wardid_"|"_depdesc_"^"_depid
  ..e  d
  ...s depid=patTempLoc
  ...s depdesc=$p(^CTLOC(depid),"^",2)
  ...s res="^|"_depdesc_"^"_depid
  .e  d
  ..s depid=patTempLoc
  ..s depdesc=$p(^CTLOC(depid),"^",2)
  ..s res="^|"_depdesc_"^"_depid
  i res'="" q res
  
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  q:wardid="" ""
  s ctcpt=$p(^SSU("SSUSR",usid),"^",14)
  i $g(ctcpt)'="" s typid=$p(^CTPCP(ctcpt,1),"^",4)
  q:$g(typid)="" ""
  i $g(typid)'="" s typdes=$p(^CT("CPT",typid),"^",4)
  i ($g(typdes)="NURSE") s res=warddes_"^"_wardid
  s sub=0
  f  s sub=$o(^CTLOC(loc,"LINK",sub)) q:sub=""  d
  .s locDr=^CTLOC(loc,"LINK",sub)
  .q:locDr=""
  .s locDesc=$p(^CTLOC(locDr),"^",2)
  /*s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",wardid,paroom)) q:(paroom="")!($g(ctloc)'="")  d
  .s admId=0 f  s admId=$o(^PAADMi("CurrWard",wardid,paroom,admId)) q:(admId="")!($g(ctloc)'="")  d
  ..s ctlocdr=$p(^PAADM(admId),"^",4)
  ..q:ctlocdr=loc
  ..i ctlocdr'="" s ctloc=$p(^CTLOC(ctlocdr),"^",2) */
  i res'="" s res=res_"|"_$g(locDesc)_"^"_$g(locDr) 
  q res
}

ClassMethod GetPatWardIdW(EpisodeID)
{
 ///获得并人病区WKZ
   n (EpisodeID)
   q:EpisodeID=""
   i EpisodeID'="" d
   .s wardid=$p(^PAADM(EpisodeID),"^",70)
   .s warddes=$p(^PAWARD(wardid),"^",2)
   .s depid=$p(^PAADM(EpisodeID),"^",4)
   .s depdesc=$p(^CTLOC(depid),"^",2)
   .s res=warddes_"^"_wardid_"^"_depid_"^"_depdesc
   q $g(res)
}

ClassMethod GetOrdSet(ord)
{
  q:ord="" ""
  //^ARCOS({ARCOS_RowId})  --x ARC_OrdSets_
  //^ARCOS({ARC_OrdSets.ARCOS_RowId},"DATE",{DATE_Childsub})--ARC_OrdSetDate_
  //^ARCOS({ARC_OrdSets.ARCOS_RowId},"DATE", {ARC_OrdSetDate.DATE_Childsub},"ITM",{ITM_Childsub}) --ARC_OrdSetDateItem__
  s ordpar=$p(ord,"||",1),chl=$p(ord,"||",2)
  s ordset=$p(^OEORD(ordpar,"I",chl,3),"^",10)
  q:ordset="" ""
  s ArcStr=$p(^ARCOS(ordset),"^",2)  
  q:$g(ArcStr)
  //  s dcl=0 f  s dcl=$o(^ARCOS(ordset,"DATE",dcl)) q:dcl=""  d
  //.s itcl=0 f  s itcl=$o(^ARCOS(ordset,"DATE",dcl,"ITM",itcl)) q:itcl=""  d  // --ARC_OrdSetDateItem__)
  //..s ArcimDr=$p(^ARCOS(ordset,"DATE",dcl,"ITM",itcl),"^",1)
  //..w !, ArcimDr
  //..b
  //..s sub=$p(ArcimDr,"||",1),ver=$p(ArcimDr,"||",2)
  //..s ItemCatDR=$p($g(^ARCIM(sub,ver,1)),"^",10)
  //..s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
  //..q:OrdCatDR=27
  //..s ArcimDes=$p(^ARCIM(sub,ver,1),"^",2)
  //..s ArcStr=$g(ArcStr)_ArcimDes_" "
  //..
  //q $g(ArcStr)
}

ClassMethod SpecName(OeorId)
{
 //取标本类型
   s paorder=$p(OeorId,"||",1)
   s itemsub=$p(OeorId,"||",2)
   s SPECChildsub=0
   s SPECDesc="",tempSPECCode="",tempSPECDesc=""
   i $d(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))'=0 d
   s SPECChildsub=0 f  s SPECChildsub=$o(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub)) q:SPECChildsub=""  d
   .s tempSPECCode=$g(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))
   .s tempSPECCode=$p(tempSPECCode,"^",1)
   .s tempSPECDesc=$p(^["LabData"]TTAB("SPEC",tempSPECCode),"\",1)
   .i SPECDesc="" s SPECDesc=tempSPECDesc
   .e  s SPECDesc=SPECDesc_","_tempSPECDesc
  q $g(SPECDesc)
}

ClassMethod Getdocloc(admId, Oew, OrdSub)
{
         n (admId,Oew,OrdSub)
         s res="Y"
   	     s user=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",1)
         q:user="" "N"
	     s DoctorDr=$p(^SSU("SSUSR",user),"^",14)
         i DoctorDr'="" s CpTypDR=$p(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	     i $g(CpTypDR)'="" s CpTyp=$p(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	     q:($g(CpTyp)'="DOCTOR") "N"  //////////////2005-12-3 qse add
	     s truedoc=0
	     s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	     f  s DocLoc=$o(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	     .i $d(^TMP($i,"loc",admId,DocLoc))  s truedoc=1
         i truedoc'=1 s res="N" 
 q res
}

ClassMethod checkExcuteCtpcp(oeord)
{
 //查看医嘱是否执行
    n (oeord)
    s oeordId=$p(oeord,"||")
    s oeoriSub=$p(oeord,"||",2)
	q:$o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" 1
 &sql(select oeore_ctpcp_dr->ctpcp_id,oeore_dateexecuted,oeore_timeexecuted into :execCtcpDesc,:execDate,:execTime from oe_ordexec where oeore_oeori_parref=:oeord)
    q:execCtcpDesc="" 1
    q 0
}

ClassMethod GetLocDes(Loc)
{
	s LocDes=$p(^CTLOC(Loc),"^",2)
	q LocDes
}

ClassMethod ClearRecordSy() As %String
{
 //清除输液打印记录
  // s Ord=$o(^OEORD(0,"Adm",admId,""),-1)
   s userId=%session.Data("LOGON.USERID")
   k ^DHCNurseSyd(userId)
   q 0
}

ClassMethod FreqTime(freq) As %String
{
 //取频次时间
  n (freq)
  q:$g(freq)="" ""  //ypz 061209
  //PHC_DispensingTime //
  //^PHCFR({PHC_Freq.PHCFR_RowId},"DT",{PHCDT_ChildSub})
  //s freq=$ZCVT(freq,"U") 
  s frw=""  s frw=$o(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(freq),frw),-1) //ypz 070418 统一
  i frw'=""
  {
	  s chl=0  f  s chl=$o(^PHCFR(frw,"DT",chl))  q:chl=""  d
	  .i ^PHCFR(frw,"DT",chl)>86300 s frtime=$g(frtime)_24 q
	  .s timeStr=$ZT(^PHCFR(frw,"DT",chl),2)
	  .s $p(timeStr,":",1)=+$p(timeStr,":",1)
	  .i $p(timeStr,":",2)'>0 s timeStr=$p(timeStr,":",1)
	  .s frtime=$g(frtime)_timeStr_"  "
	  .//s frtime=$g(frtime)_$ZT(^PHCFR(frw,"DT",chl),2)_"    "
  }
  //s frtime=$TR($g(frtime),"0","")
  //s frtime=$TR($g(frtime),":","")
  
  q $g(frtime)
}

ClassMethod GetTmpDataNum(user) As %String
{
	n (user)
	q $G(^TMP("NurPrint",$j,user))
}

ClassMethod GetTmpData(user, num) As %String
{
 //qse add 061213
	n (user,num)
	q ^TMP("NurPrint",$j,user,num)
}

ClassMethod GetTyp(Typ = "0@CQSYD") As %String
{
	n (Typ)
	s HospitalRowId=$p(Typ,"@",1)
    s TypeCode=$p(Typ,"@",2)
    i (HospitalRowId="")!(TypeCode="") q -2
	s valStr=""
	i '$d(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode)) {
		i $d(^DHCCLNurseExec("VarSetColumnPrtDefTyp")) 
		{
		  s Typ=^DHCCLNurseExec("VarSetColumnPrtDefTyp")
		  s HospitalRowId=$p(Typ,"@",1)
    	  s TypeCode=$p(Typ,"@",2)
    	  i (HospitalRowId="")!(TypeCode="") q -2
		}
		else{
		  q ""
		}
	}  
	s no=""  f  s no=$o(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no)) q:no=""  d
	.s seqno=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",5)
	.s $p(valStr,"^",seqno)=^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no)
	q valStr
}

ClassMethod getarcim(oew, chl, oeoreSub, typ = "") As %String
{
  
    n (oew,chl,typ,oeoreSub)
    q:(oew="")||(chl="")||(oeoreSub="")
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
     s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)  //关联  OEORI_OEORI_DR
     
	 s scrip=$p(arcimdr,"||")
	 s ver=$p(arcimdr,"||",2)
	 s arcimdes=$p(^ARCIM(scrip,ver,1),"^",2)
	 i $P(arcimdes,"}",2)'="" s arcimdes=$P(arcimdes,"}",2)
	 s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
	 s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oew_"||"_chl)
	 ;i oecprCode["OM" s arcimdes=arcimdes_"(自备药)"
	 i (oecprCode["OM")&(oecprCode'["ZT") s val("arcimDesc")=val("arcimDesc")_"(自备药)"
   	 i (oecprCode["OM")&(oecprCode["ZT") s val("arcimDesc")=val("arcimDesc")_"(嘱托)"
	 s deeppurple=$p($g(^OEORD(oew,"I",chl,11)),"^",55)
	 i deeppurple="Y" s arcimdes="急"_" "_arcimdes
	 s packUomId=$p(^ARCIM(scrip,ver,8),"^",14)
	  //滴速
     s SpeedFlow=""
	 s SpeedFlowRate=$P($G(^OEORD(oew,"I",chl,3)),"^",17)
	 s SpeedFlowUnitDr=$P($G(^OEORD(oew,"I",chl,6)),"^",8)
	 i SpeedFlowUnitDr'="" s SpeedFlowUnit=$p($g(^OEC("SFR",SpeedFlowUnitDr)),"^",2)
	 i SpeedFlowRate'="",SpeedFlowUnitDr'="" s SpeedFlow=$g(SpeedFlowRate)_""_$g(SpeedFlowUnit)
     e  s SpeedFlow=""
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     s phcDispensingTime=..GetDispensingTime(phcfrId)
      //执行人
     s execCTPCP=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub)),"^",15) 
     i execCTPCP'="" s val("execCtcpDesc")=$p($g(^CTPCP(execCTPCP,1)),"^",2)
     e  s val("execCtcpDesc")=""
      //执行时间
     s execDate=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub)),"^",19)
	 s execTime=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub)),"^",20)
	 //s execCTPCP=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub)),"^",15)
     s val("execDateTime")=##Class(web.DHCCLCom).FormatDate(execDate)_" "_##Class(web.DHCCLCom).FormatTime(execTime)
     //医生
     	s user=$p($g(^OEORD(oew,"I",chl,7)),"^",1)
    i user'="" s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    i ctcpId'="" s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,1)),"^",2)
    i (val("ctcpDesc")="")&(ctcpId'="") s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,8)),"^",12)
     //要素PHC_FREQ
     i $g(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
     s sttDate=$p($g(^OEORD(oew,"I",chl,1)),"^",9)   //keep dup
     i sttDate'="" d
     .s tmpSttDate=$zd(sttDate,3)
     .i $l(tmpSttDate,"-")>2 s sttDate=$p(tmpSttDate,"-",2)_"-"_$p(tmpSttDate,"-",3)
     s sttTime=$p($g(^OEORD(oew,"I",chl,1)),"^",10)  //keep dup
     i sttTime'="" s sttTime=$zt(sttTime,2)
     s val("sttDateTime")=sttDate_" "_sttTime
     ;i phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
     i phcfrId'="" d
     .s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
     .i $d(^PHCFR(phcfrId,"DHC")) d
     ..i $g(^PHCFR(phcfrId,"DHC"))'=0,$g(^PHCFR(phcfrId,"DHC"))'="" d
     ...s phfactor=$g(^PHCFR(phcfrId,"DHC"))
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
     e  s unitUomId=""
    // W !,doseQty,",",$g(unitUomId),",",chl
	 f rnum=1:1:$g(^OEORD(oew,"I",chl,"DEP",0))  d
	 .s val("notes")=$g(val("notes"))_$g(^OEORD(oew,"I",chl,"DEP",rnum))
     i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$g(doseQty)_" "_$g(unitDesc)
     s val("doseQtyUnit")=$g(doseQty)_" "_$g(unitDesc)
     s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
     //i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i (phOrdQty'="") s PackNum=phOrdQty_" "_$g(unitDesc)
     s orderBaseQty=..GetOrdBaseQtyNum(oew_"||"_chl)
     s phcdfId=$p($g(^ARCIM(+arcimdr,$p(arcimdr,"||",2),1)),"^",12)
     i phcdfId'="" d 
     .s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
     .s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
     .i (baseUomId'="")&(baseUomId'=unitUomId) d
     ..s baseUomDesc=$p($g(^CT("UOM",baseUomId)),"^",2)
     ..s PackNum=$g(orderBaseQty)_" "_$g(baseUomDesc)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     s packUomId=+packUomId
     i (packUomId'=0)&(packUomQty'="") d 
     .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     i packUomQty'="" s PackNum=$g(packUomQty)_" "_$g(packUomDesc)
     s val("phOrdQtyUnit")=PackNum
     s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
     s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
     i reclocId'=""  d
     .i $p($p($g(^CTLOC(reclocId)),"^",2),"-",2)'="" s val("reclocDesc")=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
     .e  s val("reclocDesc")=$p($g(^CTLOC(reclocId)),"^",2)
     e  s val("reclocDesc")=""
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
     s OrdDate=$p($g(^OEORD(oew,"I",chl,1)),"^",9)  //stdat
     //i ("^S^OMST^"[PriorCode)&(dose'="") s OrdDate=OrdDate+1
     //打印执行单时长期药物开始时间加1 因为是提前摆药
     s OrdDate=$ZD(OrdDate,3) 
     s PrnDate=$ZD(+$H,3)_" "_$Zt($p($H,",",2),2)
     s SeqNo=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub,"BILL")),"^",3)
     i +SeqNo=0 s SeqNo=oew_"||"_chl_"||"_oeoreSub
     e  s arcimdes="____"_arcimdes
     i glno=""
     {
	   s val("phcfrCode")=$g(phcfrCode) 
	   s val("phcinDesc")=$g(phcinDesc)
	 }
	 //s phcfrCode=""
	 ;s val("specDesc")=..GetSpecContainer(oew_"||"_chl)          //标本名称用来存储容器及量
	s arcicId=""
	s specCode=$p($g(^OEORD(oew,"I",chl,"SPEC",1)),"^")
    i specCode'="" s val("specDesc")=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2) ;s val("specDesc")=$p($g(^TTAB("SPEC",specCode)),"\",1)
    e  d
        .s arcicCode=$p($g(^ARC("IC",+arcicId)),"^",1)
        .q:(arcicCode="")
        .q:(arcicCode'["PATHOLOGY")
        .s tmId=$o(^DHCPISTestMasteri("ORDER",oew_"||"_chl,""))
        .i tmId'="" d
            ..s val("labNo")=tmId
            ..s tsSub=0
            ..f  s tsSub=$o(^DHCPISTestMaster(tmId,"TS",tsSub)) q:tsSub=""  d
                ...i val("specDesc")'="" s val("specDesc")=val("specDesc")_"/"
                ...s tsStr=$g(^DHCPISTestMaster(tmId,"TS",tsSub))
                ...s val("specDesc")=val("specDesc")_$p(tsStr,"^",1)_":"_$p(tsStr,"^",3)
	s dispensingStat=##class(web.DHCCLCom).GetDispensingStat(oew_"||"_chl,"Y")
	 i dispensingStat="TC" s val("DspStat")="未发"
     i dispensingStat="C" s val("DspStat")="已发"
     i dispensingStat="PC" s val("DspStat")="部分发"
     s arcimdes=arcimdes_$g(val("notes"))
     //s Arcim=arcimdes_"|"_""_"|"_$g(phcfrCode)_"|"_$g(phcinDesc)_"|"_$g(phfactor)_"|"_OrdDate_"|"_PrnDate_"|"_SeqNo_"|"_$g(oecprDesc)_"|"_""_"|"_$g(val("labNo"))_"|"_$g(val("reclocDesc"))_"|"_$g(val("notes"))
     s:$g(phfactor)["^" phfactor=$replace(phfactor,"^","")
     s Arcim=arcimdes_"^"_""_"^"_$g(phcfrCode)_"^"_$g(phcinDesc)_"^"_$g(phfactor)_"^"_OrdDate_"^"_PrnDate_"^"_SeqNo_"^"_$g(oecprDesc)_"^"_""_"^"_$g(val("labNo"))_"^"_$g(val("reclocDesc"))_"^"_$g(val("notes"))_"^"_$g(val("specDesc"))_"^"_$g(phcDispensingTime)
     b ;123
     s Str=..GetTyp(typ)
     s titlen=$l(Str,"^")
     s mval=""
     for i=1:1:titlen
     {
	    s item=$p(Str,"^",i)
	    s vastr=$p(item,"|",4)
	    i item'=""{
	    i (vastr)'=""{
		  s sortno=i
		  s caption=$p(item,"|",1)
		  s mval=$g(mval)_caption_"|"_sortno_"|"_$g(val(vastr))_"^"
		 }
	    }
	 }
	 
     q Arcim_"@"_mval
}

ClassMethod GetPreStopDate(Oew, OrdSub) As %String
{
  //取预停日期时间
 	   n (Oew, OrdSub)
 	   s retstr=""
 	   s PreStopDate=$p($g(^OEORD(Oew,"I",OrdSub,9)),"^",9)  ;stop date
	   s PreStopTime=$p($g(^OEORD(Oew,"I",OrdSub,9)),"^",10)   ;stop time
	   i PreStopDate'="" s retstr=$$$ZD(PreStopDate,4)_" "_$ZT(PreStopTime,2)
	   e  s retstr=""
       q retstr
}

ClassMethod GetIfCancel(GroupID As %String = "241") As %String
{
	n (GroupID)
	s flage=0
	s flage=$g(^DHCCLNurseExec("UserGroupAccess","CanCancel",GroupID))
	q flage
}

ClassMethod SyCard(oeorid) As %String
{
	s userid=$G(%session.Data("LOGON.USERID"))
	n (oeorid,userid)
	s oew=$P(oeorid,"||")
	s oewsub=$P(oeorid,"||",2)
	s oeoridr=oew_"||"_oewsub
	s i=2
	s n=1
	s arc=..getarcimSYC(oew,oewsub)
	s mainarc=arc
	s StDate=$ZD($P($G(^OEORD(oew,"I",oewsub,1)),"^",9),3)

	s $P(sycd,"!",1)=$P(arc,"^",1)   
	s ^DHCNurseSyd(userid,oew,oewsub)=""
	s chl="" f  s chl=$O(^OEORDi(0,"OEORI",oew,oeoridr,chl)) q:chl=""  d
	.s doseQty=$p($g(^OEORD(oew,"I",oeoridr,2)),"^",1)
	.s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oew_"||"_chl)
	.q:(ordstat="D")!(ordstat="U")!(ordstat="C")
		.s arc=..getarcimSYC(oew,chl)     
	.q:arc=""
	.s $P(sycd,"!",i)=$P(arc,"^",1)
	.s ^DHCNurseSyd(userid,oew,chl)=""
	.s i=i+1
	s sr=##Class(web.DHCCLCom).PatInfo(oeoridr)
	s PatName=$P(sr,"^",5)
	s BedCode=$P(sr,"^",7)
	s Loc=$P(sr,"^",2)
	s WardDesc=$P(sr,"^",9)
	
    s $P(sycd,"^",2)=PatName
    s $P(sycd,"^",3)=BedCode	
    s $P(sycd,"^",4)=$G(ExCpt)	
    s $P(sycd,"^",5)=$G(ExeDate)_" "_$g(ExeTime)	
    s $P(sycd,"^",6)=Loc
    s $P(sycd,"^",7)=StDate
    s $P(sycd,"^",8)=WardDesc
    if $G(fstr)'="" d
    .s $P(fstr,"^",2)=PatName
    .s $P(fstr,"^",3)=BedCode	
    .s $P(fstr,"^",4)=$G(ExCpt)	
    .s $P(fstr,"^",5)=$G(ExeDate)_" "_$g(ExeTime)	
    .s $P(fstr,"^",6)=Loc
    .s $P(fstr,"^",7)=StDate
    .s $P(fstr,"^",8)=WardDesc
    q $G(sycd)_"@"_$G(fstr)
}

ClassMethod SyCardIP(oeorid) As %String
{
	s userid=$G(%session.Data("LOGON.USERID"))
	n (oeorid,userid)
	s oew=$P(oeorid,"||")
	s oewsub=$P(oeorid,"||",2)
	s oreSub=$P(oeorid,"||",3)
	s oeoridr=oew_"||"_oewsub_"||"_oreSub
    s seqno=0
    s SeqNo=""
	i oew'="" s SeqNo=$P($G(^OEORD(oew,"I",oewsub,11)),"^",39)
	i (SeqNo'="")&&(SeqNo'=oew_"||"_oewsub) s seqno=1
	s i=2
	s n=1

	s arc=..getarcimSYCIP(oew,oewsub,oreSub)
	s mainarc=arc
	s StDate=$p(arc,"|",7)
	s StTime=$p(arc,"|",8)
	s $P(sycd,"!",1)=$P(arc,"^",1)  
	s chl=0 f  s chl=$O(^OEORDi(0,"OEORI",oew,oew_"||"_oewsub,chl)) q:chl=""  d
	.s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oew,StDate,StTime,chl,oeoreSub)) q:oeoreSub=""  d
	..s linkOeordId=$P($G(^OEORD(+oew,"I",chl,"X",oeoreSub,"BILL")),"^",3)
	..q:oeoridr'=linkOeordId
	..s arc=..getarcimSYCIP(oew,chl,oeoreSub)     
	..q:arc=""
	..s $P(sycd,"!",i)=$P(arc,"^",1)
	..s i=i+1

	s sr=##Class(web.DHCCLCom).PatInfo(oeoridr)
	s PatName=$P(sr,"^",5)
	s BedCode=$P(sr,"^",7)
	s Loc=$P(sr,"^",2)
	s WardDesc=$P(sr,"^",9)
    s $P(sycd,"^",2)=PatName
    s $P(sycd,"^",3)=BedCode	
    s $P(sycd,"^",4)=$G(ExCpt)	
    s $P(sycd,"^",5)=$zd(StDate,3)_"-"_$zt(StTime,2)
    s $P(sycd,"^",6)=Loc
    s $P(sycd,"^",7)=StDate
    s $P(sycd,"^",8)=WardDesc
    q $G(sycd)_"^@"_seqno
}

ClassMethod getarcimSYC(oew, chl) As %String
{
 
     n (oew,chl)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     i phcfrId'="" d
     .s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
     .i $d(^PHCFR(phcfrId,"DHC")) d
     ..i $g(^PHCFR(phcfrId,"DHC"))'=0,$g(^PHCFR(phcfrId,"DHC"))'="" d
     ...;s phfactor=$g(^PHCFR(phcfrId,"DHC"))
     ...s phfactor=$g(^PHCFR(phcfrId,"DT",0))
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     s Arcim=arcimdes_"|"_$G(dose)_"|"_$G(phcfrCode)_"|"_$G(phcinDesc)_"|"_$G(phfactor)_"|"_$g(phfTimes)   //_"^"_$G(oecprDesc)
     i $G(dose)=" " s Arcim=""
     q Arcim
}

ClassMethod getarcimSYCIP(oew, chl, sub) As %String
{
   n (oew,chl,sub)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
	 s ordStatusId=$p($g(^OEORD(oew,"I",chl,"X",sub,"BILL")),"^",1)  ;OEORI_ItemStat_DR
     s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	 s skintest=$p($g(^OEORD(oew,"I",chl,5)),"^",2)
	 s abnorm=$p($g(^OEORD(oew,"I",chl,11)),"^",3)
	 i (skintest="Y")&(ordStat'="D") d
     i (abnorm="N") s arcimdes=arcimdes_" (-)"
     i (abnorm="Y") s arcimdes=arcimdes_" (+)"
     //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     i phcfrId'="" d
     .s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
     .i $d(^PHCFR(phcfrId,"DHC")) d
     ..i $g(^PHCFR(phcfrId,"DHC"))'=0,$g(^PHCFR(phcfrId,"DHC"))'="" d
     ...;s phfactor=$g(^PHCFR(phcfrId,"DHC"))
     ...s phfactor=$g(^PHCFR(phcfrId,"DT",0))
     s StTime=$P(^OEORD(oew,"I",chl,"X",sub),"^",2)

     s StDate=$P(^OEORD(oew,"I",chl,"X",sub),"^",1)

     s phfSub=0 f  s phfSub=$o(^PHCFR(phcfrId,"DT",phfSub)) q:phfSub=""  d
     .s time=^PHCFR(phcfrId,"DT",phfSub)
     .i time=StTime s phfTimes=phfSub
     .e  s phfTimes=1
     s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     s Arcim=arcimdes_"|"_$G(dose)_"|"_$G(phcfrCode)_"|"_$G(phcinDesc)_"|"_$G(phfactor)_"|"_phfTimes_"|"_StDate_"|"_StTime  //_"^"_$G(oecprDesc)
     i $G(dose)=" " s Arcim=""
     q Arcim
}

ClassMethod KillSyCard() As %String
{
	s userid=$G(%session.Data("LOGON.USERID"))
	K ^DHCNurseSyd(userid)
	q 1
}

ClassMethod updateBatch(oeoriStr As %String, batchStr As %String) As %String
{
	n (oeoriStr,batchStr)
	s strLen=$L(oeoriStr,"!")
	s batchLen=$L(batchStr,",")
	s retStr=0
	s flage=0
	f i=1:1:strLen q:flage=1  d
	.s oeoriId=$P(oeoriStr,"!",i)
	.s factorDr=$P($G(^OEORD($P(oeoriId,"||"),"I",$P(oeoriId,"||",2),2)),"^",4)
	.i factorDr'="" s factor=$p($G(^PHCFR(factorDr)),"^",2)
	.e  s factor=""
	.i factor'=batchLen d
	..s flage=1
	..s retStr="选择医嘱频次与录入批次不一致,请核实!"
	q:(retStr'=0) retStr
	
	f i=1:1:strLen d
    .s oeoriId=$P(oeoriStr,"!",i)
    .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    .i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DispTimeList) values(:oeoriId,:batchStr))
    .i dhcoriId'="" &sql(update DHC_OE_OrdItem set DHCORI_DispTimeList=:batchStr where DHCORI_OEORI_Dr=:oeoriId)
    .i SQLCODE'=0 d
    ..i retStr=0 s retStr=oeoriId
    ..e  s retStr=retStr_","_oeoriId
    i retStr'=0 s retStr=retStr_"更新失败!"
	q retStr
}

ClassMethod GetPDAExec(oeoriId As %String = "") As %String
{
	n (oeoriId)
	s retStrPDA=""
	q:oeoriId="" retStrPDA
	s oeordId=+$P(oeoriId,"||")
	s oeoriSub=$P(oeoriId,"||",2)
	s ordExecNum=$G(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:((ordExecNum=0)||(ordExecNum="")) retStrPDA
	s oeoreSub=0
	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	.s orderStatDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
	.q:orderStatDr=""
	.s CTPCPDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
	.i CTPCPDr'="" s CTPCPDesc=$P($G(^CTPCP(CTPCPDr,1)),"^",2)
	.e  s CTPCPDesc=""
	.i retStrPDA=""  s retStrPDA=oeoreSub_"/"_ordExecNum_CTPCPDesc
	.e  s retStrPDA=retStrPDA_","_oeoreSub_"/"_ordExecNum_CTPCPDesc
	i $L(retStrPDA,",")=ordExecNum s retStrPDA=retStrPDA_"^"_"1"
	e  s retStrPDA=retStrPDA_"^"_"0"
	q retStrPDA
}

/// 取检验医嘱的容器及量
ClassMethod GetSpecContainer(oeoriId)
{
    n (oeoriId)
    s ret=""
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    q:oeordId="" retno
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retno
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retno
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" ret
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
    .s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
    .q:(tod'="")&(tod<+$h)
    .s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
  	q:excode="" ret
  	i '$d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) q ret
  	s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  	q:specCode="" ret
  	s curCtconId="",ctconId=""
  	f  s curCtconId=$o(^TTAB("TS",excode,"SC",curCtconId)) q:(curCtconId="")  d
  	.i $d(^TTAB("TS",excode,"SC",curCtconId,specCode))>0 s ctconId=curCtconId
	i ctconId'="" d
	.s ctlabDesc=$p(^TTAB("CON",ctconId),"\",1)
	.s ctlabCon=$p(^TTAB("CON",ctconId),"\",3)
	.s ret=ctlabDesc_" "_ctlabCon_"ml"
	q ret
}

/// 病区专业组 GetWardProGroup
ClassMethod GetWardProGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardProGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardProGroupExecute(ByRef qHandle As %Binary, wardid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i wardid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s wardProGroupId=""
 	f  s wardProGroupId=$O(^DHCWardProGroup(0,"WardDr",wardid,wardProGroupId)) q:wardProGroupId=""  d
 	.s activFlag=$p($G(^DHCWardProGroup(wardProGroupId)),"^",3)
 	.q:activFlag="N"
 	.s wardProGroupDesc=$p($G(^DHCWardProGroup(wardProGroupId)),"^",2)
   	.Do OutWardProGroup
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardProGroup
	set Data=$lb(wardProGroupDesc,wardProGroupId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardProGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardProGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetWardProGroup(wardid As %String) As %Query(ROWSPEC = "wardProGroupDesc:%String,wardProGroupId:%String")
{
}

/// 通过医嘱ID串去Lis信息
ClassMethod GetLabInterFaceData(ServiceType As %String, OEORIStr As %String) As %String
{
	s myRet=""
	q:(ServiceType="")!(OEORIStr="") myRet
	s myRetStr=##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService(ServiceType,OEORIStr)
	i $P($G(myRetStr),$c(1),1)=0 s myRet=$P($G(myRetStr),$c(1),2)
	q myRet
}

/// Lis 医嘱插入 试管 采血费
/// ordType  ---Cont  采血管    ---Charg   采血费
ClassMethod LabInsertOrdItem(userId As %String, userDeptId As %String, oeordId As %String, qty As %String, ordType As %String) As %String
{
	n (userId,userDeptId,oeordId,qty,ordType)
	s ret=-1
	s userId=+userId,userDeptId=+userDeptId,oeordId=+oeordId,qty=+qty
	q:(userId=0)!(userDeptId=0)!(oeordId=0)!(qty=0)!(ordType="") ret
	q:$D(^SSU("SSUSR",userId))=0 "医嘱人录入人不存在"
	q:$P($G(^SSU("SSUSR",userId)),"^",14)="" "插入医嘱人非医护人员"
	q:$D(^CTLOC(userDeptId))=0 "科室不存在"
	q:(oeordId="")!($D(^OEORD(oeordId))=0) "医嘱ID不存在"
	q:qty=0 "医嘱数量为空"
	q:ordType="" "医嘱类别为空!"
	i ordType="Cont"  s arcimId=$G(^DHCCLSet("Exec","Cont"))
	i ordType="Charg" s arcimId=$G(^DHCCLSet("Exec","Charg"))
	i arcimId="" s arcimId="2154||1"
	s ret=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
	q ret
}

/// Parm    oeoriId 医嘱RowID
/// Return  OrdDate_"^"_OrdTime_"^"_ArcimDesc
ClassMethod GetOrdInfo(oeoriId As %String) As %String
{
	n (oeoriId)
	q:oeoriId="" ""
	s oew=+oeoriId
	s chl=$P(oeoriId,"||",2)
	s oeoreSub=$P(oeoriId,"||",3)
    q:(oew="")||(chl="")
	s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	//s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)
	s scrip=$p(arcimdr,"||")
	s ver=$p(arcimdr,"||",2)
	s arcimdes=$p(^ARCIM(scrip,ver,1),"^",2)
	s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
	i $P(arcimdes,"}",2)'="" s arcimdes=$P(arcimdes,"}",2)
	s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oew_"||"_chl)
	;i oecprCode["OM" s arcimdes=arcimdes_"(自备药)"
	i (oecprCode["OM")&(oecprCode'["ZT") s val("arcimDesc")=val("arcimDesc")_"(自备药)"
    i (oecprCode["OM")&(oecprCode["ZT") s val("arcimDesc")=val("arcimDesc")_"(嘱托)"
	s packUomId=$p(^ARCIM(scrip,ver,8),"^",14)
	//途径
	s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
	i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
	e  s phcinDesc=""
	//频次
	s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
	i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
	//要素PHC_FREQ
	i $g(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
	i phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2),phfactorDesc=$p($g(^PHCFR(phcfrId)),"^",1)
	e  s phfactor="",phfactorDesc=""
	s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
	i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
	// W !,doseQty,",",$g(unitUomId),",",chl
	f rnum=1:1:$g(^OEORD(oew,"I",chl,"DEP",0))  d
	.s val("notes")=$g(val("notes"))_$g(^OEORD(oew,"I",chl,"DEP",rnum))
	i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
	s dose=$g(doseQty)_" "_$g(unitDesc)
	s val("doseQtyUnit")=$g(doseQty)_" "_$g(unitDesc)
	i $g(doseQty)="NaN" s val("doseQtyUnit")=""
	s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
	//i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
	i (phOrdQty'="") s PackNum=phOrdQty_" "_$g(unitDesc)
	s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
	s packUomId=+packUomId
	i (packUomId'=0)&(packUomQty'="") d 
	.s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
	i packUomQty'="" s PackNum=$g(packUomQty)_" "_$g(packUomDesc)
	s val("phOrdQtyUnit")=PackNum
	s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
	s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
	i reclocId'="" s val("reclocDesc")=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
	e   s val("reclocDesc")=""
	s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
	i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
	i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
	s OrdDate=$p($g(^OEORD(oew,"I",chl,1)),"^",9)
	s OrdDate=$ZD(OrdDate,3) 
	//s OrdDate=$P(OrdDate,"-",2)_"-"_$P(OrdDate,"-",3)
	s OrdTime=$p($g(^OEORD(oew,"I",chl,1)),"^",10)
	s OrdTime=$ZT(OrdTime,2)
	
	s PrnDate=$ZD(+$H,3)_" "_$Zt($p($H,",",2),2)
	/*s SeqNo=$p($g(^OEORD(oew,"I",chl,11)),"^",39) //qshe add 05-08-22
	i (SeqNo'="")&(+SeqNo'=0) d  //ypz 060925 error data protect
	.s arcimdes="____"_arcimdes
	.s tmpSeqNo=$p(SeqNo,"||",2)
	e  s tmpSeqNo=chl    //未打
	s SeqNo=oew_tmpSeqNo */
	s SeqNo=$p($g(^OEORD(oew,"I",chl,"X",oeoreSub,"BILL")),"^",3)
    i SeqNo="" s SeqNo=oew_"||"_chl_"||"_oeoreSub
    e  s arcimdes="____"_arcimdes
    s arcimdes=arcimdes_..getSkinTestResult(oew_"||"_chl)
    ;s firstTimeOrd=..getFirstOrdNum(oeoriId)
	s val("notes")=..getNotes(oew,chl)
    ;i $g(firstTimeOrd)'="" s arcimdes=arcimdes_"(首次:"_firstTimeOrd_")"
    i $g(val("notes"))'="" s arcimdes=arcimdes_"备注:"_val("notes")
	s Arcim=arcimdes_"|"_""_"|"_$g(phcfrCode)_"|"_$g(phcinDesc)_"|"_$g(phfactor)_"|"_OrdDate_"|"_PrnDate_"|"_SeqNo_"|"_$g(oecprDesc)_"|"_""_"|"_$g(val("labNo"))_"|"_$g(val("reclocDesc"))_"|"_$g(val("notes"))
	s arcimdes=arcimdes_" "_val("doseQtyUnit")_" "_val("notes")_" "_phfactorDesc_" "_phcinDesc
	q OrdDate_"^"_OrdTime_"^"_arcimdes_"^"_$G(phcfrCode)
}

/// 取医嘱的执行状态
/// 执行记录都执行返回 1 否则返回0
/// w ##Class(web.DHCLCNUREXCUTE).GetOrdExecStat(" ")
ClassMethod GetOrdExecStat(oeoriId As %String = "")
{
	s retStr=0
	q:(oeoriId="")!(+oeoriId=0)!(+$P(oeoriId,"||",2)=0) retStr
	s oeordId=+$P(oeoriId,"||")
	s oeoriSub=$P(oeoriId,"||",2)
	s ordExecNum=$G(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:((ordExecNum=0)||(ordExecNum="")) retStr
	s oeoreSub=""
	s ordNum=0
	s ordExecNum=0
	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	.s ordNum=ordNum+1
	.s orderStatDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
	.q:orderStatDr=""
	.q:$P($G(^OEC("STAT",orderStatDr)),"^")'="E"
	.s CTPCPDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
	.q:CTPCPDr=""
	.s ordExecNum=ordExecNum+1
	i (ordExecNum'=0)&(ordNum'=0)&(ordExecNum=ordNum) s retStr=1
	q retStr
}

/// 取得医生科室
ClassMethod GetOrdDocLoc(oeord, ordsub) As %String
{
	n (oeord,ordsub)
	s locStr="^"
	//s ctcpId=$p($g(^OEORD(oeord,"I",ordsub,1)),"^",11)
	s userId=$p($g(^OEORD(oeord,"I",ordsub,7)),"^",1)
	q:userId="" ""
	s ctcpId=$p($G(^SSU("SSUSR",userId)),"^",14)
	q:ctcpId="" ""
	q:$D(^RB("RES",0,"CTPCP",ctcpId))=0 ""
	s loc=""  f  s loc=$o(^RB("RES",0,"CTPCP",ctcpId,loc)) q:loc=""  d
	.s locStr=locStr_loc_"^"
	q locStr
}

/// 取医嘱日期加1
ClassMethod EditOrdDate(dateVal As %String)
{
	q:dateVal="" ""
	s ret=""
	If (##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateFormat")) d
	.s dateVal=##class(websys.Conversions).DateHtmlToLogical(dateVal)
	.s ret = $zd(dateVal+1,3)
	e  s ret=$zd($zdh(dateVal,3)+1,3)
	q ret
}

/// Creator: wangxinlei
/// CreatDate: 2009-05-21
/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String) As %String
{
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"

	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",3) s retStr="密码错误"
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Creator: wangxinlei
/// CreatDate: 2020-06-24
/// Description: 判断用户签名密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
ClassMethod ConfirmUserPIN(userCode As %String, passWord As %String) As %String
{
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"

	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",15) s retStr="密码错误"
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Creator: wangxinlei
/// CreatDate: 2009-05-21
/// Description: 复核皮试结果同时判断密码及置过敏记录
/// Table：SS_User,OE_OrdTtem,DHC_OE_OrdItem,PA_Allergy
/// Input：userCode: 用户登陆名 passWord: 用户密码 oeoriStr: 医嘱RowId skinTest: 复核皮试结果
/// Return：成功返回 0 失败返回 错误信息
ClassMethod updateAudit(userCode As %String, passWord As %String, oeoriStr As %String, skinTest As %String) As %String
{
	s retStr=""
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr=-1
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",3) s retStr=-1
	zn oldnamespace
	q:retStr=-1 retStr
	s skinTestAuditCtcpDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	s skinTestAuditDate=+$H
	//s skinTestAuditTime=+$P($H,",") //20090630更新
	s skinTestAuditTime=+$P($H,",",2)
	s strLen=$L(oeoriStr,"!")
	s retStr=""
	f i=1:1:strLen d
    .s oeoriId=$P(oeoriStr,"!",i)
    .s oeordId=+$P(oeoriId,"||")
    .s oeoriSub=+$P(oeoriId,"||",2)
    .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    .i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestAuditCtcp_Dr,DHCORI_SkinTestAuditDate,DHCORI_SkinTestAuditTime) values(:oeoriId,:skinTestAuditCtcpDr,:skinTestAuditDate,:skinTestAuditTime))
    .i dhcoriId'="" &sql(update DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:skinTestAuditCtcpDr,DHCORI_SkinTestAuditDate=:skinTestAuditDate,DHCORI_SkinTestAuditTime=:skinTestAuditTime where DHCORI_OEORI_Dr=:oeoriId)
    .i SQLCODE=0 d
    ..s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    ..q:skinTestFlag'="Y"
    ..s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=skinTest
    ..s ret=0
    ..i ret'=0 d
    ....i retStr="" s retStr=oeoriId_"修改过敏记录失败"
    ....e  s retStr=retStr_","_oeoriId_"修改过敏记录失败"
    .i SQLCODE'=0 d
    ..i retStr="" s retStr=oeoriId
    ..e  s retStr=retStr_","_oeoriId
    i retStr'="" s retStr=retStr_"更新失败!"
    e  s retStr=0
	q retStr
}

/// Creator: wangxinlei
/// CreatDate: 2009-05-21
/// Description: 置复核皮试结果
/// Table：SS_User,OE_OrdTtem,DHC_OE_OrdItem
/// Input：userId: 用户RowId, oeoriStr: 医嘱RowId
/// Return：成功返回 0 失败返回 错误信息
ClassMethod AuditSign(userId As %String, oeoriStr As %String) As %String
{
	q:(userId="")!(oeoriStr="") 0
	s AuditUserCtcpDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	q:AuditUserCtcpDr="" "该用户未关联医护人员!"
	s AuditDate=+$H
	//s AuditTime=+$P($H,",")  //20090630 更新
	s AuditTime=+$P($H,",",2)
	s strLen=$L(oeoriStr,"!")
	s retStr=""
	f i=1:1:strLen d
    .s oeoriId=$P(oeoriStr,"!",i)
    .s oeordId=+$P(oeoriId,"||")
    .s oeoriSub=+$P(oeoriId,"||",2)
    .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    .i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestAuditCtcp_Dr,DHCORI_SkinTestAuditDate,DHCORI_SkinTestAuditTime) values(:oeoriId,:AuditUserCtcpDr,:AuditDate,:AuditTime))
    .i dhcoriId'="" &sql(update DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:AuditUserCtcpDr,DHCORI_SkinTestAuditDate=:AuditDate,DHCORI_SkinTestAuditTime=:AuditTime where DHCORI_OEORI_Dr=:oeoriId)
    .i SQLCODE'=0 d
    ..i retStr="" s retStr=oeoriId
    ..e  s retStr=retStr_","_oeoriId
    .q:SQLCODE'=0
    .s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")!(retStr'="")  d
    ..s curOeoriId=oeordId_"||"_curOriSub
    ..s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(curOeoriId)
    ..q:ordStatusCode="D"
	..s dhcoriId=$o(^DHCORDItem(0,curOeoriId,""))
    ..i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestAuditCtcp_Dr,DHCORI_SkinTestAuditDate,DHCORI_SkinTestAuditTime) values(:curOeoriId,:AuditUserCtcpDr,:AuditDate,:AuditTime))
    ..i dhcoriId'="" &sql(update DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:AuditUserCtcpDr,DHCORI_SkinTestAuditDate=:AuditDate,DHCORI_SkinTestAuditTime=:AuditTime where DHCORI_OEORI_Dr=:curOeoriId)
    i SQLCODE'=0 d
    ...i retStr="" s retStr=oeoriId
    ...e  s retStr=retStr_","_oeoriId
    ...q:SQLCODE'=0

    i retStr'="" s retStr=retStr_"更新失败!"
    e  s retStr=0
	q retStr
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-03
/// Description: 取频率的分发时间
/// Table：PHC_Freq,PHC_DispensingTime
/// Input：phcFreqId: 频率RowID
/// Return：分发时间 08 12 16
ClassMethod GetDispensingTime(phcFreqId) As %String
{
	q:$g(phcFreqId)="" ""
	s DispensingTime=""
	s phcDTSub=0  f  s phcDTSub=$o(^PHCFR(phcFreqId,"DT",phcDTSub))  q:phcDTSub=""  d
	.s preDispensingTime=$p(^PHCFR(phcFreqId,"DT",phcDTSub),"^",1)
	.i preDispensingTime'="" d
	..i preDispensingTime>86300 s preDispensingTime="24"
	..e  s preDispensingTime=$p($zt(preDispensingTime),":",1)
	.i DispensingTime="" s DispensingTime=preDispensingTime
	.e  s DispensingTime=DispensingTime_"    "_preDispensingTime
	q $G(DispensingTime)
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-19
/// Description: 取基本剂量单位显示的总量
/// Table：OE_OrdItem,ARC_ItmMast,ARC_ItemCat,PHC_Freq,PHC_DrgForm,PHC_DispensingTime
/// Input：oeoriId: 医嘱项RowID
/// Return：基本剂量单位显示的总量
ClassMethod GetOrdBaseQtyNum(oeoriId) As %String
{
	q:oeoriId="" 0
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId="" 0
    
	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	q:arcicOrderType'="R" phOrdQty
	
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty="" q phOrdQty
    s phcfrFactor=1
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId="" q phOrdQty
    s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)

    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    q:phcdfId="" phOrdQty
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)
    
    s qtyPackUom=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    s packDoseQty=0
    i +qtyPackUom'=0,packUomId'="" d
        .s factor=1
        .i baseUomId'=packUomId d
            ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
		    ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
	    .q:+factor=0
		.s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
	i packDoseQty'=0 q packDoseQty
    
	s phcduId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	s phcduFactor=1
	i phcduId'="" s phcduFactor=$p(^PHCDU(phcduId),"^",2)
	i +phcduFactor=0 q phOrdQty
    s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    q:unitUomId="" phOrdQty
    s eqQty=1
    i baseUomId'=unitUomId d
        .s eqId=0,eqQty=0
        .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
            ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
            ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
    i eqQty=0 q phOrdQty
    s dQty=doseQty/eqQty
    ;i $p(dQty,".",2)>0 s dQty=$p(dQty,".",1)+1
    s qty=dQty*phcfrFactor*phcduFactor
    i $p(qty,".",2)>0 s qty=$fn(qty,"",1)
    ;i (qty'="")&(qty<1) s qty="0"_qty
   	q qty
}

/// CreatDate: 2010-01-30
/// Description: 判断医嘱是否审核
/// Table：OE_Order,OE_OrdExec,DHC_OE_OrdExec
/// Input：oeoriId:医嘱项ID
/// Return：审核返回Y,否则返回N
ClassMethod SearhAuditInfo(oeoriId) As %String
{
	n (oeoriId)
	s Ord=$p(oeoriId,"||",1)
	s OrdSub=$p(oeoriId,"||",2)
	q:(Ord="")!(OrdSub="") "N"
	s FillerNo=$P($G(^OEORD(Ord,"I",OrdSub,9)),"^",12)
	q:FillerNo'="" "Y"		//滚动医嘱不判断审核 
    s oeoreId=##class(web.DHCNurCom).GetFirstOeoreId(oeoriId)
    q:oeoreId="" "N"
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    q:dhcoreId="" "N"
	s auditUser=$p($g(^DHCOrdExec(dhcoreId)),"^",18)
	q:auditUser="" "N"
	q "Y"
}

/// Creator:      SongChao
/// CreateDate:   2017.7.27
/// Description:  获取医嘱的价格信息
/// Input:		  oeoreId
/// Return:       单价_"^"_折扣单价_"^"_记账单价_"^"_自付单价
/// Other:        ##CLASS(web.DHCLCNUREXCUTE).getOrderPrice(oeoreId)
ClassMethod getOrderPrice(oeoreId)
{
	s ordPrice=""
	s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) 
    s hospital=""
    ;i userDeptId'="" d
    ;.s hospital=$p($g(^CTLOC(userDeptId)),"^",22)
    s ordPrice = ##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital)
	q ordPrice
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-01
/// Description: 判断医嘱是否能执行 
/// Table：
/// Input：setSkinTest:是否置皮试结果调用,Y为皮试结果调用,oeoreId:医嘱执行表ID,execStatusCode:执行状态code,userId:执行人SS_UserDr,userDeptId:执行人登陆科室
/// Return：
/// w ##class(web.DHCLCNUREXCUTE).IfCanUpdateOrdGroup("","5548||1||1","F","4636","197","13/10/2017","")
ClassMethod IfCanUpdateOrdGroup(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, execDate, execTime)
{
	;S ^tempsc("IfCanUpdateOrdGroup")=$lb(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, execDate, execTime)
	n (setSkinTest, oeoreId, execStatusCode, userId, userDeptId, execDate, execTime)
	s AdmId=$P(^OEORD(+oeoreId),"^") //病人就诊ID 
	s PatVisit=$p($g(^PAADM(AdmId)),"^",20) //病人就诊状态 
    s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(AdmId)
	q:(PatVisit="D")&(currentStatus'="B") "病人已出院" 
	s resStr=0
	s ctpcpId=$p(^SSU("SSUSR",userId),"^",14) 
    q:ctpcpId="" "请以医护人员身份登录后操作!" 	//用户不是医护人员时提示

    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoreId)
    s prtFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",1)
	q:(arcicOrderType="L")&&(prtFlag'["P") "检验医嘱请先打印再执行!"
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    q:(setSkinTest'="Y")&(mainOeoriId'="")&(execStatusCode="F") "非置皮试的从医嘱不执行"
    q:(setSkinTest'="Y")&(mainOeoriId'="")&(execStatusCode'="F")&(abnorm'="Y") "非置皮试非皮试阳性从医嘱不能撤消"
    s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)  //070204
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
    i ordStatusCode="E",execStatusCode'="F",arcicOrderType'="R" q "医嘱状态为执行,不能撤消!" //ypz 070204
    i ordStatusCode="D",execStatusCode'="F" q "医嘱状态为停止,不能撤消!"
    s skinTest=""
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    i (skinTestFlag="Y")&(abnorm="")&(execStatusCode="F") q "请先置皮试结果!"
    i (setSkinTest'="Y")&(execStatusCode="F") s resStr=##Class(web.DHCCLCom).CanExecSkinTestOrd(oeoriId) //判断子医嘱有无需要皮试的医嘱
    i (resStr'=0) q resStr
    i (setSkinTest'="Y")&(skinTestFlag="Y")&(abnorm="Y") q "皮试阳性"
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) 
    s arcicOrdType=$p(^ARC("IC",arcicId),"^",7)
    s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",5)
    s EpisodeID=+^OEORD(oeordId),feeRetStr=""
    s orderDep=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",3)
    s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(orderDep)
    
    s ordSelfPrice = $p(..getOrderPrice(oeoreId),"^",4) //医嘱记账价格
    i ordSelfPrice'=0{
    	s feeRetStr=""
    	i execStatusCode="C" q resStr
    	i checkLocDeposit=0 s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, oeoreId_$c(2)_phOrdQty,"NE")
    	i (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="N") s resStr="费用不足,不能执行!" q resStr
    	s feeflag="1"             
    	i (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="Y") d  
      	.s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE($p(feeRetStr,"^",3), arcimId)  
    	i feeflag="0" q "费用不足,不能执行!"
    }
    q resStr
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-01
/// Description: 医嘱串执行操作 
/// Table：
/// Input：setSkinTest:是否置皮试结果调用,Y为皮试结果调用,oeoreId:医嘱执行表ID,execStatusCode:执行状态code,userId:执行人SS_UserDr,userDeptId:执行人登陆科室
/// Return：成功返回 0 失败返回 错误信息
ClassMethod UpdateOrdGroup(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, changeReasonDr)
{
    //setSkinTest,为"Y"是置皮试结果调用
    n (setSkinTest,setExecFlag,oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,execDate, execTime,changeReasonDr)
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub
    s resStr=..IfCanUpdateOrdGroup(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, execDate, execTime)            
    i resStr'=0 q resStr
    s resStr=..UpdateExecStat(oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,changeReasonDr,execDate,execTime)
    i resStr'=0 q resStr
    i (setSkinTest="Y") q resStr //置皮试为主医嘱时，子医嘱不执行
    s newInspect=##Class(web.DHCEMInterface).GetOrdExecDesc(oeoreId) ;//新检查判断
    i $g(newInspect)'="" d ..NewInspectHandle(oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,changeReasonDr,execDate,execTime)
   
    
    
    //执行子医嘱
    /*
    s curOriSub="" 
    f  
    {
	    s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub))
	    s curOreId=oeordId_"||"_curOriSub_"||"_oeoreSub 
	    q:(curOriSub="")!(resStr'=0)
        s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(curOreId) 
        ;q:ordStatusCode="D" 
        q:ordStatusCode="U" 
        s resStr=..UpdateExecStat(curOreId,execStatusCode,userId,userDeptId,queryTypeCode,changeReasonDr,execDate,execTime)
    }*/
    ;s rtn=##Class(web.UDHCJFBILL).BILLN(+^OEORD(oeordId),userId,oeoriId) 
    q resStr
}

/// Creator:      SongChao
/// CreateDate:   2017.8.3
/// Description:  新检查执行
/// Input:        
/// Return:
/// Other:  ##class(web.DHCLCNUREXCUTE).NewInspectHandle("118||53||2")
ClassMethod NewInspectHandle(oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, changeReasonDr, execDate, execTime)
{
 n (oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,execDate, execTime,changeReasonDr)
 s resStr=0 
 s tarItmRW = $o(^DHCAPREPTA(0,"IndexOrdExec",oeoreId,""))
 s PartID=$p(^DHCAPREPTA(tarItmRW),"^",1)      /// 部位ID
 s ARTIOrdItem = $p(^DHCAPREPTA(tarItmRW),"^",2)   ///医嘱id
 s TrID = "" f  s TrID = $o(^DHCAPREPTA(0,"OrdItem",ARTIOrdItem,TrID)) q:(TrID="")!(resStr'=0)  d
 .s oeoreId1= $p(^DHCAPREPTA(TrID),"^",10) 
 .q:oeoreId1=oeoreId
 .s partRW = $p(^DHCAPREPTA(TrID),"^",1)
 .q:partRW'=PartID 
 .s ARTIType=$p(^DHCAPREPTA(TrID),"^",3) 
 .i ARTIType="P" d
 ..s resStr=..UpdateExecStat(oeoreId1,execStatusCode,userId,userDeptId,queryTypeCode,changeReasonDr,execDate,execTime)
 q resStr
}

/// w ##class(web.DHCLCNUREXCUTE).UpdateExecStat("147||132||1","F","4636","197","WZX","","12/09/2017","16:00:00")
ClassMethod UpdateExecStat(oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, changeReasonDr, execDate, execTime)
{
    //n oeordId,oeoriSub,ok,arcicId,oeoriId,unit,num,uom,uomid,stat,execStatusId,usr,ssusr,ctpcpId,dat,tim,ret  ;xuqy 2005-04-20
    n (oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, changeReasonDr, execDate, execTime)
    s execStatusId=$o(^OEC("STAT",0,"Code",execStatusCode,""))  
    s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
    i execDate'=""  s execDate=##class(websys.Conversions).DateHtmlToLogical(execDate) ;$zdh(execDate,4)
    i execDate="" s execDate=curDate
    i execTime'="" s execTime=$zth(execTime)
    i execTime="" s execTime=curTime
    s execTime=+execTime
    s ctpcpId=$p(^SSU("SSUSR",userId),"^",14)   
    s ok=""
  /* i ((execDate>curDate)!((execDate=curDate)&(execTime>curTime)))
    {
	    s execDate=curDate,execTime=curTime
    }*/
    s oeordId=$p($g(oeoreId),"||",1)
    s oeoriSub=$p($g(oeoreId),"||",2)
    s oeoreSub=$p($g(oeoreId),"||",3)  
    s admId=+^OEORD(oeordId)
    s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    ;s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,oeoreSub)),"^",1)
    ;s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,oeoreSub)),"^",2)
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)
    ;s ^scv1("eee",1)=execDate_","_execTime_","_sttTime_","_sttDate
    i (((execDate<sttDate)!((execDate=sttDate)&(execTime<sttTime))))&(execStatusCode="F") s ok="执行时间不应小于要求执行时间!" q ok
    s feeRetStr="",EpisodeID=+^OEORD(oeordId)
    
    s result=0
    s ok=##class(appcom.OEOrdExec).UpdateStatus(oeoreId,execStatusCode,userId,execDate,execTime,changeReasonDr)
    i ok'=0 d
    .s ret=ok
    .i ok="-105" s result="操作失败!"
    .i ok="-3177" s result="医嘱药师审核未通过，不能执行。请联系医生处理!"
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    i (ok="-3177")&&(skinTestFlag="Y") s ok=0    
    i ok'=0 q result
    //s ret=##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(oeoreId, execStatusCode, userDeptId, userId)
    //8.1.1病区界面新配置用法和医嘱关联
   // s ret=##class(Nur.DHCInstrAttOrdByWard).ExcuteInstrAttOrdNew(oeoreId, execStatusCode, userDeptId, userId)
    q result
}

// 撤消已处理记录

ClassMethod UndoUpdateExecStat(oeoreId As %String, userId As %String, changeReasonDr As %String, execDate As %String, execTime As %String)
{
	n (oeoreId, changeReasonDr, userId,execDate,execTime)
	s oeordId=$p($g(oeoreId),"||",1) 
	s oeoriSub=$p($g(oeoreId),"||",2)
	s oeoreSub=$p($g(oeoreId),"||",3) 
	s ctpcpId=$p(^SSU("SSUSR",userId),"^",14) 
	s ctcpName=""
	&sql(select ssusr_careprov_dr->ctpcp_desc into :ctcpName from ss_user where ssusr_RowId=:userId)
	k PLIST
	s resStr=0
	&sql(select oeore_ctpcp_dr->ctpcp_desc into :ctcpDesc from oe_ordexec where oeore_rowid=:oeoreId)
	i 2<1 
	{
	    s resStr="只有原执行人能撤消操作!"
	}
	else
	{
		s execStatusId=""
		s changeReasonDr=""
	    s billFlag="I",execStatusId=$o(^OEC("STAT",0,"Code","C",""))  //默认完成
	    &sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,OEORE_Order_Status_DR=:execStatusId,OEORE_DateExecuted=:execDate,OEORE_TimeExecuted=:execTime,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	    i SQLCODE s resStr="医嘱撤消执行失败!"
	    i resStr'=0 q resStr
	    s resStr=..InsertOEOrdExecStatus(oeoreId,execStatusId,changeReasonDr,userId)
	    i resStr'=0 q resStr
	}
	q resStr
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-03
/// Description: 医嘱状态变化表插入记录
/// Table：OE_OrdExecStatus
/// Input：oeoreId:医嘱执行表ID,execStatusId:,changeReasonDr,userId
/// Return：成功返回 0 失败返回 错误信息
ClassMethod InsertOEOrdExecStatus(oeoreId As %String, execStatusId As %String, changeReasonDr As %String, userId As %String, execDate As %String, execTime As %String) As %String
{
	n (oeoreId, execStatusId, changeReasonDr, userId,execDate, execTime) ;
	/* &sql(insert into OE_OrdExecStatus (
		STCH_ParRef,
		STCH_AdminStatus_DR,
		STCH_Reason_DR,
		STCH_Date,
		STCH_Time,
		STCH_User_DR) values (
		:oeoreId,
		:execStatusId,
		:changeReasonDr,
		:execDate,
		:execTime,
		:userId)) */
	
	s OEOrdExecStatusObj=##class(User.OEOrdExecStatus).%New(oeoreId)
	s OEOrdExecStatusObj.STCHParRef=##class(User.OEOrdExec).%OpenId(oeoreId)
	s OEOrdExecStatusObj.STCHAdminStatusDR=##class(User.OECOrderAdminStatus).%OpenId(execStatusId)
	s OEOrdExecStatusObj.STCHReasonDR=##class(User.OECAdminStatusChReason).%OpenId(changeReasonDr)
	s OEOrdExecStatusObj.STCHDate=execDate
	s OEOrdExecStatusObj.STCHTime=execTime
	s OEOrdExecStatusObj.STCHUserDR=##class(User.SSUser).%OpenId(userId)
	d OEOrdExecStatusObj.%Save() 
	q 0
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-03
/// Description: 更新医嘱执行表
/// Table：OE_OrdExec
/// Input：oeoreId:医嘱执行表ID,execStatusId:,changeReasonDr,userId
/// Return：成功返回 0 失败返回 错误信息
ClassMethod UpdateOEOrdExec(oeoreId As %String, execStatusId As %String, billStatus As %String, ctpcpId As %String, execDate As %String, execTime As %String)
{
	n (oeoreId, execStatusId, billStatus, ctpcpId, execDate, execTime)
    /*&sql(update Oe_ordexec set 
    				 OEORE_CTPCP_DR=:ctpcpId,
    				 OEORE_Order_Status_DR=:execStatusId,
                   OEORE_DateExecuted=:execDate,
                   OEORE_TimeExecuted=:execTime
                    where oeore_rowid=:oeoreId)
    
    i SQLCODE s ok="执行记录修改有误!" */
    s OEOrdExecObj=##class(User.OEOrdExec).%OpenId(oeoreId)
    i (execStatusId'="") s OEOrdExecObj.OEOREOrderStatusDR=##class(User.OECOrderAdminStatus).%OpenId(execStatusId)
    i (billStatus'="") s OEOrdExecObj.OEOREBilled=billStatus
    i (ctpcpId'="") s OEOrdExecObj.OEORECTPCPDR=##class(User.CTCareProv).%OpenId(ctpcpId)
    i (execDate'="") s OEOrdExecObj.OEOREDateExecuted=execDate
    i (execTime'="") s OEOrdExecObj.OEORETimeExecuted=execTime
    d OEOrdExecObj.%Save()
    q 0
}

ClassMethod InsertAttOrd(insAttStr, oeoreId)
{
	n (insAttStr,oeoreId)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	i $p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" 
	{
		q:insAttStr="" ok
		s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
		q:phcinId=""
		s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
		q:phcfrId=""
		s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
		TStart
		s isAbort=0
		f iInst=1:1:$l(insAttStr,"^")  
		{
			s insItem=$p(insAttStr,"^",iInst)
			s arcimId=$p(insItem,$c(2)),qty=$p(insItem,$c(2),2)
			s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
			i retInsord'=0 s isAbort=1
		}
		i isAbort TRollBack  s insTimes=0 q ok
		TCommit
		s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
		s insTimes=phfactor-maxPhfactor
		i insTimes<0 s insTimes=0
		i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
		q ok //下面程序不执行
		k inattList
		s inattId="",itmmstStr=""
		f 
		{
			s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  
			q:inattId="" 
			s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
			q:inattType=""
			s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
			q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
			i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
			i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
			s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
			s inattType=""
			f 
			{
				s inattType=$o(inattList(inattType)) 
				q:(inattType="")!(ok'=0)
				i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
				i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
				s ok=##Class(web.DHCNurCom).insertAttOrd(.inattList,phcinId,phfactor,userId, oeordId,userDeptId)
			}
		 }
   	}
   	q ok
}

/// 增加皮试审核人 update 20180203 增加批号 update 20180428
ClassMethod SetSkinTestResult(oeoreId As %String, userId As %String, flag As %String, execStatusCode As %String = "", ctlocId As %String = "", queryTypeCode As %String = "", exedate As %String = "", exetime As %String = "", changeReasonDr As %String = "", auditUser = "", batch = "", mainOeoreId = "", groupID = "") As %String
{
    //皮试处理
    n (oeoreId,userId,flag,execStatusCode,ctlocId,queryTypeCode,exedate,exetime,changeReasonDr,auditUser,batch,mainOeoreId,groupID,%session)    
	s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s:##class(Nur.NIS.Service.Base.Order).IfPhcinSkinTest(oeordId,oeoriSub)=1 skinTestFlag="Y" 
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","非皮试医嘱!")
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","已结算医嘱不能置皮试结果!") 
    
	s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  
	i ordStatusCode="D" q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","停止医嘱不能置皮试结果!")
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    s skinTestBatch=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",27)
    i (preFlag=flag)&(skinTestBatch'=batch) q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","所置状态与原来相同,未改变皮试状态!")
    
    // 由阳性改为阴性时，根据护士执行配置判断是否有权限修改
    s execSetting=##class(Nur.NIS.Service.Base.OrderHandle).GetExecSetting(ctlocId)
	s skinOrdExecSequence=execSetting.GetAt("skinOrdExecSequence") // 执行和置皮试结果顺序 0:先执行后置皮试结果 1:置皮试结果同步执行
	s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
    s currentExecStatusCode=$s((execStatusId'=""):$p($g(^OEC("STAT",execStatusId)),"^",1),1:"")
    i (currentExecStatusCode'="F")&&(skinOrdExecSequence=0) q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","请先执行医嘱")
    // 阴性改为阳性要判断是否执行
	i (preFlag'="Y")&(currentExecStatusCode="F")&(skinOrdExecSequence=1)  q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","医嘱已执行，不能置皮试结果!")
	i (preFlag'="Y")&&(flag="Y") {
		// 阴性改为阳性要判断要判断是否存在为作废/未撤销且皮试备注为皮试阴性的治疗用药
		s linkValidTreatOrdList=##Class(web.DHCOEOrderGuideAllergy).GetLinkValidTreatOrdList(oeordId_"||"_oeoriSub,"N")
		s linkValidTreatOrdDescs=""
		f treatOrdIndex=1:1:$l(linkValidTreatOrdList,"^"){
			s treatOrdId=$p(linkValidTreatOrdList,"^",treatOrdIndex)
			continue:treatOrdId=""
			s treatArcimID =$p($g(^OEORD(+treatOrdId,"I",$p(treatOrdId,"||",2),1)),"^",2)
			continue:treatArcimID=""
			s treatArcimDesc= $P($G(^ARCIM(+treatArcimID,$p(treatArcimID,"||",2),1)),"^",2),treatArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",treatArcimDesc)
			i linkValidTreatOrdDescs="" s linkValidTreatOrdDescs=treatArcimDesc
			e  s linkValidTreatOrdDescs=linkValidTreatOrdDescs_", "_treatArcimDesc
		}
		if (linkValidTreatOrdDescs'=""){
			s arcimID =$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
			i arcimID'="" s arcimDesc= $P($G(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2),arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc)
			q arcimDesc_##class(websys.Translation).Get("web.DHCLCNUREXCUTE","关联的治疗用药 ")_treatArcimDesc_##class(websys.Translation).Get("web.DHCLCNUREXCUTE"," 已置皮试备注为阴性，请先撤销或作废！")
		}
	}
	// 置皮试结果晚于开医嘱时间
    s skinResultDTLaterMin=execSetting.GetAt("skinResultDTLaterMin")
    i (skinOrdExecSequence=0)&&(currentExecStatusCode="F")&&(+skinResultDTLaterMin>0){
	    s filter=..JudgeLaterSttDateTime(oeordId,oeoriSub,oeoreSub,exedate, exetime,skinResultDTLaterMin)
		q:filter'=0 ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","置皮试结果")_filter_skinResultDTLaterMin_##class(websys.Translation).Get("web.DHCLCNUREXCUTE","分钟")
	}
    s errStr=0
    i (preFlag="Y")&&(flag="N") d
    .s changeResutFlag=execSetting.GetAt("changeSkinTestResut")
    .s groupDesc=""
    .i groupID'="" s groupDesc=$p($g(^SSU("SSGRP",groupID)),"^",1)
    .i (changeResutFlag="Y")&&(groupDesc'="")&&(groupDesc'["护士长") s errStr=##class(websys.Translation).Get("web.DHCLCNUREXCUTE","非护士长不能修改皮试结果")
    q:errStr'=0 errStr
    
    // 根据护士执行配置判断是否需药师审核后执行
    s drugAuditStr=0
    i execStatusCode="F",skinOrdExecSequence'=0 d
    .s limitDrugAudit=execSetting.GetAt("limitDrugAudit")
    .i limitDrugAudit="Y" d
    ..s auditResult=##class(web.DHCSTINTERFACE).GetOrdIPMonitorResult(oeordId_"||"_oeoriSub)
    ..i auditResult="N" s drugAuditStr=##class(websys.Translation).Get("web.DHCLCNUREXCUTE","药品未审核不能执行")
    q:drugAuditStr'=0 drugAuditStr  
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2),skinTestInstr=""
	i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
	s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    s dispStat=##class(web.DHCCLCom).GetDispensingStat(oeoreId,"N") 
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoreId)
	i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(dispStat="")&(arcicOrderType="R") q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","无发药状态!")
	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	i auditUser'="" S auditCTPCP=$p(^SSU("SSUSR",auditUser),"^",14)
	Ts
	// 更新皮试医嘱关联治疗用药的皮试结果
	s skintestOeoriId=+oeoreId_"||"_$p(oeoreId,"||",2)
	i ##class(websys.Conversions).IsValidMethodName("web.DHCOEOrderGuideAllergy","GetLinkTreatOrdList") d
	.s linkTreatOrdList=##Class(web.DHCOEOrderGuideAllergy).GetLinkTreatOrdList(skintestOeoriId)
	.i linkTreatOrdList'=""  d
	..f i=1:1:$l(linkTreatOrdList,"^") d
	...s linkTreatOrd=$p(linkTreatOrdList,"^",i)
	...s resStr=..UpdateLinkOrderSkinTestResult(+linkTreatOrd,$p(linkTreatOrd,"||",2),flag)
	
	// 更新皮试结果及处理人处理时间
	s resStr=..UpdateSkinTestResult(oeoreId,flag,ctcpId,curDate,curTime,$g(auditCTPCP),$g(batch))
	d ##class(Nur.SkinTestRecord).Insert(+^OEORD(oeordId),oeoreId,flag,userId,curDate,curTime) // 插入皮试历史记录
	s skinTestContext="阴性"
	i flag="Y" s skinTestContext="阳性"
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s arcimdesc=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",2)
    s skinTestContext=arcimdesc_skinTestContext
	d ##class(websys.DHCMessageInterface).Send(skinTestContext,"1019",userId,+^OEORD(oeordId),oeordId_"||"_oeoriSub,$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1))
	s resStr=0
	i arcicOrderType="R" s resStr=..UpdatePatAllergy(oeoreId,userId,flag,ctlocId)
	i resStr'=0 q resStr
	i currentExecStatusCode'="F",skinOrdExecSequence=1 d
	.s resStr=##class(Nur.NIS.Service.Base.OrderHandle).UpdateOrdGroup("Y",oeoreId,"F",userId,ctlocId,queryTypeCode,exedate,exetime,"",changeReasonDr,"",auditUser)
	.i mainOeoreId'="" s resStr=##class(Nur.NIS.Service.Base.OrderHandle).UpdateOrdGroup("Y",mainOeoreId,"F",userId,ctlocId,queryTypeCode,exedate,exetime,"",changeReasonDr,"",auditUser)
	i resStr=0  Tc  q resStr
	e  tro
	q resStr
}

/// CreatDate: 		2022.8.26
/// Description: 	判断指皮试结果时时间是否满足条件
/// Input：			oeordId,oeoriSub,oeoreSub：医嘱OE_OrdExec表ID，execDate：执行日期，execTime：执行时间，forwardMin：允许提前执行时间
/// Return：		
ClassMethod JudgeLaterSttDateTime(oeordId, oeoriSub, oeoreSub, execDate, execTime, laterMin)
{
	n (oeordId, oeoriSub, oeoreSub, execDate, execTime, laterMin)
	
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",19)
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",20)
    s laterMin=laterMin*60
    
    s total = sttDate * 3600 *24 + sttTime + laterMin
    s sttDate = total \ (3600 * 24)
    s sttTime = total # (3600 * 24)
    s tempTime=$zt(sttTime)
	i execDate="" s execDate=+$h
    e  s execDate=##class(websys.Conversions).DateHtmlToLogical(execDate)
    i execTime="" s execTime=$p($h,",",2)
    e  s execTime=##class(websys.Conversions).TimeHtmlToLogical(execTime)
    q:((execDate=sttDate)&&(execTime>sttTime))||(execDate>sttDate) ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","超出执行记录实际执行时间范围")
    q 0
}

ClassMethod UpdatePatAllergy(oeoreId, userId, allergyFlag, locID) As %String
{
   //无当前药品则插入
	n (oeoreId,userId,allergyFlag, locID,%session)
	q:(allergyFlag'="Y")&(allergyFlag'="N") 0
	
	s ret=0
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s curDate=+$h,curTime=$p($h,",",2)
	
	s algId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",19)
	s papmiId=+algId,algSub=+$p(algId,"||",2)
	i allergyFlag="N" d
	.i (algId'="")&($d(^PAPER(papmiId,"ALG",algSub))'=0) d
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",19)="Y"
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",8)="I"
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",16)=userId
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",23)=curDate
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",24)=curTime
	i allergyFlag="N" q 0
	i (allergyFlag="Y")&(algId'="")&($p($g(^PAPER(papmiId,"ALG",algSub)),"^",19)="N") q 0
	
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","无药品指针!")
    k PLIST
    s PLIST(0)=+^PAADM(+^OEORD(oeordId)) //ALG_PAPMI_ParRef
    s PLIST(3)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11) //ALG_CTPCP_DR暂用下医嘱医生
    s PLIST(8)="" //ALG_Type_DR 取不到
    s PLIST(11)="A" //ALG_Status
    s PLIST(12)=curDate //ALG_Date
    s PLIST(13)=curDate //ALG_OnsetDate
    s PLIST(18)=curTime //ALG_Time
    s PLIST(19)=userId //ALG_UpdateUser_DR
    s PLIST(22)="N" //ALG_InActive
    s PLIST(23)=1 //ALG_LastUpdateHospital_DR
    s PLIST(24)="" //ALG_Severity_DR
    s PLIST(26)=curDate //ALG_LastUpdateDate
    s PLIST(27)=curTime //ALG_LastUpdateTime
    s PLIST(31)=+phcdfId //ALG_PHCDM_DR
    s PLIST(33)="" ;$o(^MRC("AT",0,"MRCAA_Desc","","")) //ALG_MRCAllType_DR
    s PLIST(34)=arcimId
    s PLIST(39)="Y"
    s PLIST(40)=oeordId_"||"_oeoriSub  //ALG_SkinTestOEORI_DR
    //w !,PLIST(0)_","_PLIST(3)_","_PLIST(8)_","_PLIST(11)_","_PLIST(12)_","_PLIST(13)_","_PLIST(18)_","_PLIST(19)_","_PLIST(22)_","_PLIST(23)_","_PLIST(26)_","_PLIST(27)_","_PLIST(31)_","_PLIST(33)
    
    s autoInsertAllergiesFlag="Y"
    //判断皮试阳性时是否自动插入过敏记录
    s autoInsertAllergiesFlag="Y"
    #;if ##class(websys.Conversions).IsValidMethodName("DHCDoc.Interface.Inside.ServiceOrd","GetAutoInsertAllergiesFlag") d
    #;.s autoInsertAllergiesFlag=##class(DHCDoc.Interface.Inside.ServiceOrd).GetAutoInsertAllergiesFlag(oeordId_"||"_oeoriSub)
    
    i autoInsertAllergiesFlag="Y" d
    .&sql(Insert into PA_Allergy Values PLIST())
    .i SQLCODE s ret=##class(websys.Translation).Get("web.DHCLCNUREXCUTE","过敏记录插入有误!")
    .s OEOrdItemExecExtObj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
    .s OEOrdItemExecExtObj.OEOREPAALGDR=##class(User.PAAllergy).%OpenId(%ROWID)
    .d OEOrdItemExecExtObj.%Save()
    .s hospitalID=$p(^CTLOC(locID),"^",22)
    .s ALGCheckConflictOpen=##Class(web.DHCDocConfig).GetConfigNode("ALGCheckConflictOpen") //过敏冲突检测是否开启
    .i ALGCheckConflictOpen=1 s ALGCheckConflictOpen="Y"
    .e  s ALGCheckConflictOpen="N"
    .s $P(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2),"DHC"),"^",3)=ALGCheckConflictOpen ;allergyFlag
    q ret
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-03
/// Description: 更新医嘱执行扩展表皮试
/// Table：OE_OrdExecExt
/// Input：oeoreId:医嘱执行表ID
/// Return：成功返回 0 失败返回 错误信息
/// Update: 20180203 增加皮试结果复核人
ClassMethod UpdateSkinTestResult(oeoreId, flag, ctcpId, execDate, execTime, auditUser = "", batch = "")
{
	n (oeoreId,flag,ctcpId,execDate,execTime,auditUser,batch)
	s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=oeordId_"||"_oeoriSub
	
	s OEOrdItemObj=##class(User.OEOrdItem).%OpenId(oeoriId)
	s OEOrdItemObj.OEORIAbnormal=flag
	d OEOrdItemObj.%Save()
	
	s OEOrdItemExecExtObj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
	s OEOrdItemExecExtObj.OEORESkinTestCTCPDR=##class(User.CTCareProv).%OpenId(ctcpId)
	s OEOrdItemExecExtObj.OEORESkinTestDate=execDate
	s OEOrdItemExecExtObj.OEORESkinTestTime=execTime
	i $g(auditUser)'=""{
		s OEOrdItemExecExtObj.OEORESkinTestAuditCTCPDR=##class(User.CTCareProv).%OpenId(auditUser)
		s OEOrdItemExecExtObj.OEORESkinTestAuditDate=execDate
		s OEOrdItemExecExtObj.OEORESkinTestAuditTime=execTime
	}
	s OEOrdItemExecExtObj.OEORESkinBatch=$g(batch)
	d OEOrdItemExecExtObj.%Save()
	q 0
}

ClassMethod UpdateLinkOrderSkinTestResult(oeoriId, oeoriSub, flag)
{
	n (oeoriId,oeoriSub,flag)
	s ^temp("UpdateLinkOrderSkinTestResult")=$lb(oeoriId, oeoriSub, flag)
	s oeoriId=oeoriId_"||"_oeoriSub
	s OEOrdItemObj=##class(User.OEOrdItem).%OpenId(oeoriId)
	if $ISObject(OEOrdItemObj) 
	{
		s OEOrdItemObj.OEORIAbnormal=flag
		s sc=OEOrdItemObj.%Save()
		i $$$ISERR(sc) q ##class(websys.Translation).Get("web.DHCLCNUREXCUTE","更新关联医嘱皮试结果失败")
		d OEOrdItemObj.%Close()
		s ret=0
	}
	q ret
}

ClassMethod SetPlacerNo(userId, oeoreId, placerNo, clearFlag = "N") As %String
{
	//新增参数 userId,061113
	//置检验瓶号
	q:$g(oeoreId)="" "医嘱不能为空!"
	q:(placerNo="")&&(clearFlag="N") "瓶号不能为空!"
	
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub
	if (clearFlag="N") {
		s sameOrdPlacNo=""
		s OEOrderId=""
		for {
			s OEOrderId=$o(^OEORD(0,"EpisNo",placerNo,OEOrderId)) q:(OEOrderId="")||(sameOrdPlacNo=1)
			s OEORIChildsub="" 
			for {
				s OEORIChildsub=$o(^OEORD(0,"EpisNo",placerNo,OEOrderId,OEORIChildsub)) q:(OEORIChildsub="")||(sameOrdPlacNo=1)
				s sameOrdPlacNo=1
			}
		}
		q:sameOrdPlacNo=1 placerNo_" 该条码号和系统生成的标本号相同"
	}
	s PFlage=1                                                              
	i clearFlag ="N" d
	.i ($d(^OEORDi(0,"PlacerNo",placerNo))>2)  d
	..s PFlage=##class(web.DHCNurCom).getPlacerFlage(placerNo)              
	s CPFlage=-1
	i (PFlage=0)&(clearFlag'="Y") d
	.s CPFlage=##class(web.DHCNurCom).clearPlacerFlage(placerNo)
	q:(clearFlag'="Y")&(PFlage=0)&(CPFlage<0) "清除停止医嘱的关联条码失败!"  
	s flag=""
	i (clearFlag'="Y") d
	.s flag=$d(^OEORDi(0,"PlacerNo",placerNo)) 
	q:$g(flag)>2 "已有该瓶号!"
	;i (placerNo'=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36))&(clearFlag="Y") q "无此瓶号!"
	s flag=""
	s oriLabEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)  ;OEORI_LabEpisodeNo
	i oriLabEpisodeNo="" q "该医嘱没有检验号!"
	;i clearFlag'="Y",$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",36)'="" q "该医嘱已有条码号!"
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
    i ordStatCode="D" q "医嘱状态为停止,不能置条码!"
    i ordStatCode="E" q "医嘱状态为执行,不能置条码!"
    s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
    s ordExecOrdStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub_"||"_oeoreSub) 
	i (ordExecOrdStatCode="F")!((ordExecOrdStatCode="D")) q "护士已执行,不能置条码!"

	s curOriSub=0,err="",oeoriIdStr=""
	f  s curOriSub=$O(^OEORD(0,"EpisNo",oriLabEpisodeNo,oeordId,curOriSub)) q:curOriSub=""  d
	    .s curLabEpisodeNo=$p($g(^OEORD(oeordId,"I",curOriSub,3)),"^",20)
	    .s oeoriId=oeordId_"||"_curOriSub
	    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId) 
	    .q:(ordStatCode="E")&&(clearFlag="Y")
	    .k PLIST
	    .&sql(SELECT * INTO PLIST() FROM OE_OrdItem WHERE OEORI_RowId=:oeoriId)
	    .s PLIST(215)=placerNo         ;OEORI_PlacerNo
	    .i clearFlag="Y" s PLIST(215)=""
	    .i 'SQLCODE d
	        ..&sql(UPDATE OE_OrdItem VALUES PLIST() WHERE OEORI_RowId=:oeoriId)
	    .s err=SQLCODE
	    .i err'=0 q
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	i err=0,oeoriIdStr'="" d
	   	.s num=$l(oeoriIdStr,"^")
	   	.f i=1:1:num d
	   	    ..s oeoriId=$p(oeoriIdStr,"^",i)
	   	    ..s oeordId=+oeoriId
	   	    ..s oeoriSub=$p(oeoriId,"||",2)
	   	    ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
           ..s curDate=+$h,curTime=$p($h,",",2)
           ..i clearFlag="Y" s userId="",curDate="",curTime=""
           ..//更新采血时间
           ..d ..UpdateSpecColl(oeordId_"||"_oeoriSub_"||"_oeoreSub,userId,curDate,curTime)
        
	q err
}

/// Creator: pengjunfu
/// CreatDate: 2012-03-03
/// Description: 更新医嘱执行表采血时间
/// Table：OE_OrdExec
/// Input：oeoreId:医嘱执行表ID
/// Return：成功返回 0 失败返回 错误信息
ClassMethod UpdateSpecColl(oeoreId As %String, userId As %String, execDate As %String, execTime As %String)
{
	n (oeoreId, userId, execDate, execTime)
    s OEOrdExecExtObj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
    s OEOrdExecExtObj.OEORESpecCollDate=execDate
    s OEOrdExecExtObj.OEORESpecCollTime=execTime
    i (userId'="") s OEOrdExecExtObj.OEORESpecCollUserDR=##class(User.SSUser).%OpenId(userId)
    e  s OEOrdExecExtObj.OEORESpecCollUserDR=""
    d OEOrdExecExtObj.%Save()
    q 0
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-27
/// Description: 取病人某一子类的医嘱
/// Table：OE_Order,OE_OrdItem,ARC_ItmMast,ARC_ItemCat
/// Input：EpisodeID:病人就诊ID,ARCICDesc: 医嘱子类描述
/// Return：有返回相应医嘱,无返回空
ClassMethod GetItemCatOrd(EpisodeID, ARCICDesc) As %String
{
	//w ##class(web.DHCLCNUREXCUTE).GetItemCatOrd("325017","饮食")
	q:EpisodeID="" ""
	s retStr=""	
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",EpisodeID,Oew)) q:(Oew="")   d 
	.s OrdSub=0 f   s OrdSub=$O(^OEORD(Oew,"I",OrdSub))   q:OrdSub=""  d
	..s fillerno=$p($G(^OEORD(Oew,"I",OrdSub,9)),"^",12)
	..q:fillerno'=""
	..s oeoriId=Oew_"||"_OrdSub
	..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
	..q:ordStatCode'="V"										//停止医嘱不显示
	..s arcimId=$p((^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$p(arcimId,"||",1)
	..s ARCIMSub=$p(arcimId,"||",2)
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)  //医嘱子类ID--ARc_Itemcat
	..q:ItemCatDR=""
	..s ItemCat=$P(^ARC("IC",ItemCatDR),"^",2) 					//子类描述
	..q:("^"_ARCICDesc_"^")'[("^"_ItemCat_"^")
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	..s notes=""
	..s rnum=0
	..f rnum=1:1:$g(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...s notes=$g(notes)_$g(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	..i notes'="" s ARCIMDesc=ARCIMDesc_"("_notes_")"
	..i retStr="" s retStr=ARCIMDesc
	..e  s retStr=retStr_","_ARCIMDesc
	..;i retStr'[ARCIMDesc d
	..;.i retStr="" s retStr=ARCIMDesc
	..;.e  s retStr=retStr_","_ARCIMDesc
	q retStr
}

ClassMethod SendPrnOrdId(oeoriIdStr As %String, PrnFlagStr As %String) As %String
{
	s rtnStr=0
	q:oeoriIdStr="" rtnStr
	s InStr=""
	s num=$l(oeoriIdStr,"^")
    f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .q:oeoriId=""
	    .s prnflag=$p(PrnFlagStr,"^",i)
	    .q:prnflag["P"
	    .s oew=$p(oeoriId,"||")
	    .s chl=$p(oeoriId,"||",2)
	    .q:(oew="")||(chl="")
	    .s ordId=oew_"||"_chl
	    .i InStr="" s InStr=ordId
	    .e  s InStr=InStr_"^"_ordId
	i InStr'=""  d
	.s res=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPRINTLABINFO",InStr)
	.s rtnmsg1=$p(res,"^",1)
	.s rtnmsg2=$p(res,"^",2)
	.i rtnmsg1'=0 s rtnStr=rtnmsg2 //"打印调接口传Lis数据失败!"
	q rtnStr
}

ClassMethod excuteflag(userId As %String) As %String
{
	q:userId="" ""
	q:'$d(^TMP("PSExcute",$j,userId)) ""
	q ^TMP("PSExcute",$j,userId)
}

ClassMethod GetOrderStInfo(ordItmRowId, code)
{
 	n (ordItmRowId, code)
	s statusRowId=$O(^OEC("OSTAT",0,"Code",code,0))
	s sub=0 f  s sub=$o(^OEORD(+ordItmRowId,"I",$p(ordItmRowId,"||",2),"ST",sub)) q:(sub="")!($g(user)'="")  d
	.s statusDr=$p(^OEORD(+ordItmRowId,"I",$p(ordItmRowId,"||",2),"ST",sub),"^",3)
	.q:statusDr'=statusRowId
	.s date=$p(^OEORD(+ordItmRowId,"I",$p(ordItmRowId,"||",2),"ST",sub),"^",1)
	.s time=$p(^OEORD(+ordItmRowId,"I",$p(ordItmRowId,"||",2),"ST",sub),"^",2)
	.s user=$p(^OEORD(+ordItmRowId,"I",$p(ordItmRowId,"||",2),"ST",sub),"^",4)
	q $g(user)_"^"_$G(date)_"^"_$G(time)
}

// 判断时间格式，返回1表示正确的时间格式，0不合法格式

// gg add

ClassMethod istime(str)
{
	s len=$l(str,":")
	s match=$s(len=3:str?1.2N1":"1.2N1":"1.2N,len=2:str?1.2N1":"1.2N,1:0)
	q:match=0 0
	q:($p(str,":")>24)!($p(str,":",2)>60)!($p(str,":",3)>60) 0
	q match
}

// 返回1表示合法的日期格式,否则不合法

// gg add

ClassMethod isdate(str)
{
	n (str)
	s match=$s(str["/"=1:str?1.2N1"/"2N1"/"4N,str["-"=1:str?4N1"-"1.2N1"-"1.2N,1:0)
	q:match=0 0
	i str["-" d
	.s year=$p(str,"-")
	.s month=$p(str,"-",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"-",3)<1)!($p(str,"-",3)>days) s match=0 q
	i str["/" d
	.s year=$p(str,"/",3)
	.s month=$p(str,"/",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"/")<1)!($p(str,"/")>days) s match=0 q
	q match
getdays(year,month)
    s calmonth="31;28;31;30;31;30;31;31;30;31;30;31"
 	s days=+$p(calmonth,";",+month)
 	if (+month=2)&(year#4=0)&((year#100'=0)!(year#400=0)) s days=29 
 	q days
}

ClassMethod CompleteRegNo(RegNo As %String)
{
	q:RegNo="" ""
	s ret=RegNo
    s RegLen=$l(RegNo)
    for z=1:1:(10-RegLen)
    {
	    s ret="0"_ret
    }
    q ret
}

ClassMethod FindOrditemNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemNewExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindOrditemNewExecute(ByRef qHandle As %Binary, wardid As %String, RegNo As %String, userId As %String, StartDate As %String, EndDate As %String, vartyp As %String, Loc As %String, doctyp As %String, ArcimDR As %String = "", HospitalRowId As %String, excute As %String = "false", long As %String = "false", temp As %String = "false", StartTim As %String, EndTim As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^TMP("qq")=$LB(wardid , RegNo , userId, StartDate, EndDate , vartyp , Loc , doctyp,  ArcimDR,HospitalRowId,excute,long,temp,startTime,endTime)
    s TMPSEL=""
    s PatStr=$G(%request.Data("PatStr",1))
    s BEDSEL=""
    
    d ##class(Nur.Android.Common).getselbed(userId,.BEDSEL)
    if PatStr'=""
    {
         s Adm="" //多人选择
         s l=$L(PatStr,"^")
         for i=1:1:l
         {
           s itm=$P(PatStr,"^",i)
           if itm="" continue
           s TMPSEL(itm)=""
        
         }   
    }
    if userId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s RegNo=..CompleteRegNo(RegNo)
    s tmpRes=##Class(web.DHCNurCom).FindPatient(wardid,RegNo,userId,"I") 
    s patstr=..GetAllPatient("","",userId)
    ;b ;01
    s num=$l(patstr,"^")
    i patstr="" s num=0 //ypz 070108
    s ^DHCCLNurseExec("gapordnum",userId)=0  //$ZTH("18:30") //
    k ^DHCCLNurExec("gapname",userId)
    s varStr=^DHCCLNurseExec("VarDef",0,vartyp,"VarId")
    s varCount=$l(varStr,"^") ;对应项
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s data(varName)=""
    k ^TMP("NurPrint",userId)
    s ^TMP("NurPrint",userId,"j")=$i
    //w num
    f i=1:1:num
    {
        s pat=$p(patstr,"^",i)
        s admId=$p(pat,"!",1)
        s curWardId=$p($g(^PAADM(admId)),"^",70)
        s patTempLoc=$P($g(^PAADM(admId)),"^",74)
        s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
        s bedCode=""
        i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
        
        if ((PatStr'="")&('$D(TMPSEL(admId))))
        {
             continue
       
        }elseif (bedCode'=""){
             if $G(BEDSEL(bedCode))="" continue  //by pan 20130815
            }
        s locType="" //ypz 070723
        i Loc'="" s locType=$p(^CTLOC(Loc),"^",13) //ypz 070723
        //i locType'="OP" s Loc=$G(%session.Data("LOGON.CTLOCID"))
        i ((curWardId'="")&(curWardId=wardid))!(locType="OP")!(patTempLoc'="") //ypz 070723
        {
            i $g(^TMPNurIPDebug)="Y" k ^TMPNurIPDebug(admId)
            //s lisnum=..GetOrderItem("","",admId,StartDate,EndDate,userId,wardid,vartyp,Loc,doctyp,longNewOrdAdd,ArcimDR,pdaExec)
            ;b ;02
            s lisnum=..GetOrderItem(admId,StartDate,EndDate,userId,wardid,vartyp,Loc,doctyp,ArcimDR,HospitalRowId,excute,long,temp,StartTim,EndTim)
            ;b ;03
            s curTmpId=$p(lisnum,"^",2),lisnum=+lisnum
            i $g(^TMPNurIPDebug)="Y" s ^TMPNurIPDebug(admId,"0 listnum")=lisnum
            f j=1:1:lisnum
            {  
                s ordstr=..GetData("","",j,userId)
                ;b ;04
                s ordnum=$I(^TMP("NurPrint",userId,$i))

                s ^TMP("NurPrint",userId,$i,ordnum)=ordstr

                f ivar=1:1:varCount 
                {
                    s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
                    s data(varName)=$p(ordstr,"!",ivar)
                } 
                b ;05
                s data("admId")=admId
                s oeoriId=$p(ordstr,"!",ivar+1)
                s placerCode=$p(ordstr,"!",ivar+2) 
                s disposeStatCode=$p(ordstr,"!",ivar+3)
                s tmpPrtFlag=$p(ordstr,"!",ivar+4)
                s tmpSeqNo=$p(ordstr,"!",ivar+5)
                /*i data("ordStatDesc")'="停止" 
                {
                s data("execXDateTime")=""
                s data("execXUserDesc")=""
                s data("xCtcpDesc")=""
                s data("xDateTime")=""
                }
                i data("execCtcpDesc")=""  s data("execDateTime")="" */
                ;b ;01
                i (vartyp="WZX")&(data("execCtcpDesc")'="")
                {
                    //q////过滤已执行医嘱qse060306
                    
                }
                else{
                    Do OutRowNew
                }
           }
        }
    }
    s ^DHCCLNurseExec("gapTime",userId)= $p($H,",",2) ///$p($h,",",2)
    //k ^TMP("NurQuery",userId,tmpId) //071113

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutRowNew
    set Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),tmpSeqNo,data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("admId"),data("placerNo"),data("DspStat"),data("PreDisDateTime"),data("specCollDateTime"),data("specDesc"),data("pdaNurExec"))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrditemNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemNewExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query FindOrditemNew(wardid As %String, RegNo As %String, userId As %String, StartDate As %String, EndDate As %String, vartyp As %String, Loc As %String, doctyp As %String, ArcimDR As %String, HospitalRowId As %String, excute As %String = "false", long As %String = "false", temp As %String = "false", StartTim As %String, EndTim As %String) As %Query(ROWSPEC = "prtFlag,regNo,bedCode,patName,patIdentity,age,orcatDesc,seqNo,arcimDesc,oecprDesc,ordStatDesc,labNo,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,execStat,execDateTime,execCtcpDesc,ctcpDesc,disposeStatDesc,reclocDesc,sttDateTime,xDateTime,execXUserDesc,prescNo,price,totalAmount,execXDateTime,xCtcpDesc,createDateTime,oeoriId,placerCode,disposeStatCode,tmpPrtFlag,Durat,EpisodeID,placerNo,DspStat,PreDisDateTime,specCollDateTime,specDesc,pdaNurExec")
{
}

/// Creator:gyongao
/// /给执行记录加锁
/// w ##class(web.DHCLCNUREXCUTE).LockOrders("1||2||3^1||2||4","3")
ClassMethod LockOrders(oeoreIdStr As %String, userId As %String)
{
	s num=$l(oeoreIdStr,"^")
	s curDate=+$h,curTime=$p($h,",",2)
	s ret=0
	f i=1:1:num
	{
		s oeoreId=$p(oeoreIdStr,"^",i)
		continue:$l(oeoreId,"||")<3   ///过滤非执行记录
		s ordStatusCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
		continue:ordStatusCode'="V"
		TS
		s obj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
		i '$Isobject(obj) tro  continue
		i obj.OEORELockDate'="" TRO  continue   ///加锁了过滤
		s obj.OEORELockUserDR=##class(User.SSUser).%OpenId(userId)
		s obj.OEORELockDate=curDate
		s obj.OEORELockTime=curTime
		s sc=obj.%Save()
		i $$$ISERR(sc) s ret=$System.Status.GetErrorText(sc) TRO  continue
		tc
		}
	q ret
}

/// /给执行记录解锁
ClassMethod UnLockOrders(oeoreIdStr As %String, userId As %String)
{
	s num=$l(oeoreIdStr,"^")
	s nullValue=""
	s ret=0
	f i=1:1:num
	{
	s oeoreId=$p(oeoreIdStr,"^",i)
	TS
	s obj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
	i '$Isobject(obj) TRO  continue
	s obj.OEORELockUserDR=nullValue
	s obj.OEORELockDate=nullValue
	s obj.OEORELockTime=nullValue
	s sc=obj.%Save()
	i $$$ISERR(sc) s ret=$System.Status.GetErrorText(sc) TRO  continue
	tc		
	}
	q ret
}

ClassMethod SeeOrder(oeoriId As %String, userId As %String, type As %String, note As %String = "", date As %String = "", time As %String = "")
{
	n (oeoriId,userId,type,note,date,time)
	i date'=""  s date=##class(websys.Conversions).DateHtmlToLogical(date) ;$zdh(date,4)
    e  s date=+$h
    i time'="" s time=$zth(time)
    e  s time=$p($h,",",2)
	s SQLCODE=0
	Ts
	s ret=0
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	s ordStatDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) 
	q:ordStatDr="" -1
	s ordStatCode=$p(^OEC("OSTAT",ordStatDr),"^",1)
	s stopOrdInfo=##class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeoriSub)
    s XDate=$p(stopOrdInfo,"^",2)
    s ret=0
	i (ordStatCode="D")&&(XDate="") d 
	.s ret=..SetDisconOrder(oeoriId,userId)
	i ret'=0 Tro  q ret
	i (ordStatCode="D") Tc  q 0
	&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:userId,OEORI_SeeType=:type,OEORI_SeeRemark=:note,OEORI_SeeDate=:date,OEORI_SeeTime=:time where OEORI_RowId=:oeoriId)
	i SQLCODE'=0 Tro  q "操作失败"
	s chl=0
	f  s chl=$O(^OEORDi(0,"OEORI",oeordId,oeoriId,chl)) q:(chl="")!(SQLCODE'=0)  d
	.s subOeoriId=oeordId_"||"_chl
	.&sql(update OE_OrdItemExt set OEORI_SeeUser_DR=:userId,OEORI_SeeType=:type,OEORI_SeeRemark=:note,OEORI_SeeDate=:date,OEORI_SeeTime=:time where OEORI_RowId=:subOeoriId)
	i SQLCODE'=0 Tro  q "操作失败"
	Tc
	i type="R" d
	.s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    .s arcimdesc=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",2)
    .s context=arcimdesc_"被护士拒绝"
	.d ##class(websys.DHCMessageInterface).Send(context,"1016",userId,+^OEORD(oeordId),oeordId_"||"_oeoriSub,$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1))
	q 0
}

ClassMethod OrdNoteNew(PlacerNo, not, sub)
{
	 n (PlacerNo,not,sub)
	 k ^PlacerNoInfo("NL",PlacerNo)
	 k ^PlacerNoInfo("TW",PlacerNo)
     i sub=1 s ^PlacerNoInfo("NL",PlacerNo)=not
     i sub=2 s ^PlacerNoInfo("TW",PlacerNo)=not
	 q 0
}

ClassMethod getvalForCX(PlacerNo, sub)
{
     n (PlacerNo, sub)
     s ret=""
     i (sub=1)&($d(^PlacerNoInfo("NL",PlacerNo))) s ret=^PlacerNoInfo("NL",PlacerNo)
     i (sub=2)&($d(^PlacerNoInfo("TW",PlacerNo))) s ret=^PlacerNoInfo("TW",PlacerNo)
     q ret
}

ClassMethod SetNote(PlacerNo, note, tmp, nl)
{
  q:PlacerNo="" ""
  //k ^PlacerNoInfo("TZ",PlacerNo) 
  s ^PlacerNoInfo("TW",PlacerNo)=tmp
  s ^PlacerNoInfo("NL",PlacerNo)=nl
  s ^PlacerNoInfo("TZ",PlacerNo)=note
  q 0
}

/// Creator:      SongChao
/// CreateDate:   2017.8.2
/// Description:  根据检查对应的执行记录取收费价格
/// Input:         OrdExecID:执行记录ID
/// Return:
/// Other:     w ##class(web.DHCLCNUREXCUTE).getInspectPrice("118||53||1")
ClassMethod getInspectPrice(OrdExecID)
{
	Q:OrdExecID="" ""
	s TrID=$o(^DHCAPREPTA(0,"IndexOrdExec",OrdExecID,""))
	Q:TrID="" ""
	s TarID=$p(^DHCAPREPTA(TrID),"^",5)      /// 收费项ID
	s price = $p(^DHCTARI(TarID),"^",8)
	s price =##CLASS(web.UDHCJFPRICE).GetItmPrice(TarID,"","","","")
	q price
}

ClassMethod SetNum(str) As %String
{
	q:str="" str
	q:str'["^" +str
	s len=$l(str,"^")
	s ret=0
	for i=1:1:len d
	.s tmpStr=$p(str,"^",i)
	.i tmpStr["(",tmpStr[")",tmpStr["分" s tmpStr=$p(tmpStr,"(",2)
	.s score=+tmpStr
	.s ret=ret+score
	q +ret
}

}
