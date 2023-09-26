Import SQLUser

Class web.DHCPdaNurComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ExecUserInfo(UserCode As %String) As %String
{
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserCode,"U"),""))
  	if User=""
  	{
	  	zn oldnamespace
        q "-3"
	}
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	zn oldnamespace
	s ret=User_"^"_UserName
	q ret
}

Query GetWork(flag) As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%Integer,DiagDes:%String")
{
  
    select CTOCC_RowId,CTOCC_Desc from  SQLUser.CT_OCCUPATION
}

Query GetMarr(flag) As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%Integer,DiagDes:%String")
{
    select CTMAR_RowId,CTMAR_Desc from  SQLUser.CT_Marital
}

ClassMethod execRelation(param) As %String
{
   //s param="Y^^^2^3342216||691^^"
   s row=$P(param,"^",5)
   s oew=$P(row,"||",1),ordsub=$P(row,"||",2),exechl=$P(row,"||",3)
   q:exechl="" 1
   s oewsub=oew_"||"_ordsub
   s oewRel=$P(^OEORD(oew,"I",ordsub,11),"^",39)
   b //;;
   if (oewRel'="")
   {
     s $P(param,"^",5)=oewRel_"||"_exechl //1
     s a=..UpdateExecStat(param)
     s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oew,oewRel,curOriSub)) q:(curOriSub="")  d
     .s $P(param,"^",5)=oew_"||"_curOriSub_"||"_exechl
     .s a=..UpdateExecStat(param)
     b  //'''
     q 2
   }
   s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oew,oewsub,curOriSub)) q:(curOriSub="")  d
   .s $P(param,"^",5)=oew_"||"_curOriSub_"||"_exechl
   .s a=..UpdateExecStat(param)
   b //?
   q 3
}

ClassMethod UpdateExecStat(param As %String)
{
   // n oeordId,oeoriSub,ok,arcicId,oeoriId,unit,num,uom,uomid,stat,statid,usr,ssusr,ctpcpId,dat,tim,ret ;xuqy 2005-04-20
    //n newid
    //w ##Class(web.DHCPdaNurComm).UpdateExecStat("C^^^1412^3499605||199^^")
    s newid=""
    s ok=1
   // s param=^TMP(0)
  // s param="Y^^^2^3342216||691^^"
    s exeMark=$p(param,"^",1)  ;标记:Y/S/X/C  C复核皮试
    s oeoriId=$p(param,"^",5)    ;Oeori_rowid
    s arcicId=$p(param,"^",6)   ;判断是否为输血类或其它处置/治疗类 
    s now=$zt($p($h,",",2))
    i exeMark="X" d            ;如果是停止医嘱
        .
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .//s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .s usrId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .if ^TMP("Hospital")="AZ"  d
        ..s ret=##class(web.DHCPdaComm).SetDisconFlag(oeordId,oeoriSub,usrId)
        .if ^TMP("Hospital")="AZ" s ok=0
        .//s ^TMP("aa")=oeordId_"||"_oeoriSub
        .s ret=##class(web.DHCPdaComm).SetDisconOrder(oeordId_"||"_oeoriSub,usrId)
        .//s ctpcpId=$p(^SSU("SSUSR",usrId),"^",14) //SSUSR_CareProv_DR
        .//i ctpcpId="" s ok="请以医护人员的身份操作!" q //ypz 060430 用户不是医护人员时提示 //ypz 070105
        .//if oeoreSub'="" d
        .//.k PLIST
        .//.&sql(select * into PLIST() from SQLUSER.Oe_OrdEXEC where oeore_rowid=:oeoriId)
        .//.s PLIST(25)=+$H
        .//.s PLIST(36)=$P($H,",",2)
        .//.s PLIST(37)=ctpcpId
        .//.b
        .//.&sql(update oe_ordexec values PLIST() where oeore_rowid=:oeoriId)
        .//.s ok=SQLCODE
        .//.b
        .q
        .e  d
        ..k PLIST
        ..s PLIST(0)=oeordId_"||"_oeoriSub
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(25)=+$H
            ..s PLIST(36)=$P($H,",",2)
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..s ok=SQLCODE
    i exeMark="S" d            ;如果是长期医嘱或处置/治疗类 
        .i 1 d  ;如果是输血类或其它处置/治疗类?在此执行
            ..s statid=7    ;完成状态设为完成(7为完成)
            ..s usr=$p(param,"^",3)   ;执行人姓名和ctpcpId码
            ..&sql(select SSUSR_CareProv_DR,SSUSR_Name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
            ..s dat=+$h,tim=$p($h,",",2)   ;执行的日期和时间
            ..s PLIST(26)=dat,PLIST(26)=dat,PLIST(27)=tim,PLIST(35)=$h,PLIST(37)=ctpcpId,PLIST(40)=7
            ..s PLIST(41)=0,PLIST(42)=0,PLIST(43)="TB"_$c(1)_"To Bill",PLIST(46)=dat,PLIST(47)=tim
            ..s ok=$$insert^MVBOEEXE(oeoriId)
        .e  d
            ..s men=$p(param,"^",3)
            ..&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
            ..s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
            ..s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
            ..s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    
    ;如果是即刻医嘱或处置/治疗类    ;Y^1^完成^777^8412||395^49
    //s ^wxldebug(2)=exeMark_","_param
    i exeMark="Y" d 
        .s ok=1
        .s arcicId=$p(param,"^",6)
        .s oeoriId=$p(param,"^",5)         ;医嘱ROWID或医嘱执行RowId
        .s seatNo="" 
        .s userid=$p(param,"^",4)
        .s userDeptId=$p(^SSU("SSUSR",userid),"^",4) 
        .s skinflag=$p(param,"^",7)
        .if skinflag'="" d
        ..s res=..SetSkinTestResult(oeoriId,userid,skinflag)
        ..i res'=0  s ok=res  q
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .q:($g(oeordId)="")!($g(oeoriSub)="")
        .
        .//ypz 070105 begin
        .//s arcicOrdType=$p(^ARC("IC",arcicId),"^",7)
        .s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
        .s admId=+^OEORD(oeordId),feeRetStr=""
        .//ypz 070105 end
        .s unit=$p(param,"^",2)
        .s num=$p(unit," ",1)
        .s uom=$p(unit," ",2)
        .i (num[".")&(num<1) s num="."_$p($g(num),".",2)
        .;&sql(select ctuom_rowid into :uomid from ct_uom where ctuom_desc=:uom)
        .;s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .;s uomid=$o(^CT("UOM",0,"Desc",uom,"")) ,uomid=$g(uomid)
        .i uom="" d
            ..s uomid=""
        .e  d
            ..s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .s stat=$p(param,"^",3),stat=$g(stat) ;完成状态
        .;&sql(select stat_rowid into :statid from OEC_Order_AdminStatus where stat_desc=:stat)
        .if stat="" s stat="完成"
        .s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) ,skinTestInstr="" //add by ll 091221
        .i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) //add by ll 091221
        .s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //add by ll 091221
        .s statid=$o(^OEC("STAT",0,"Desc",$$ALPHAUP^SSUTIL4(stat),"")),statid=$g(statid)
        .s usrId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .
        .s ctpcpId=$p(^SSU("SSUSR",usrId),"^",14) //SSUSR_CareProv_DR
        .i ctpcpId="" s ok="请以医护人员的身份操作!" q //ypz 060430 用户不是医护人员时提示 //ypz 070105
        .//b ;s userName=$p(^SSU("SSUSR",ssusr),"^",2)
        .s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
        .b ;------
        .s feeRetStr="",EpisodeID=+^OEORD(oeordId) //add by ll 091221
        .i admType="I" d 
        	..;q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	..q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
        	..s insAttStr=##Class(web.DHCNurCom).GetAttOrdStr(oeoriId)
        	..//s ^TMPNurOPDebug(oeoriId,31)=insAttStr
        	..q:insAttStr=""
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,32)=insAttStr
        	..s addAmount=0
        	..f iAtt=1:1:$l(insAttStr,"^") d
        		...s attItem=$p(insAttStr,"^",iAtt)
        		...s insArcimId=$p(attItem,$c(2))
        		...s insQty=$p(attItem,$c(2),2)
        		...s patType=$p(^PAADM(EpisodeID,1),"^",6)
        		...s insType=$p(^PAADM(EpisodeID,1),"^",7)
        		...s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(patType,insType,insArcimId,+$h,"","","","")
        		...s addAmount=addAmount+(insQty*retPrice)
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,"add")=addAmount
        	..s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, addAmount,"OE")
        .//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,4)=feeRetStr
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") s ok="费用不足,不能执行!" q
        .i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d
            ..b //&js<alert("come in oeore if "+"#(oeordId)#"+"/"+"#(oeoriSub)#");>
            ..s PLIST(0)=oeoriId
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(40)=""   ;状态OEORE_Order_Status_DR
            ..s PLIST(41)=0    ;OEORE_PhQtyIss
            ..s PLIST(42)=num      ;剂量OEORE_QtyAdmin
            ..s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
            ..s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
            ..s PLIST(46)=curDate      ;日期OEORE_DateExecuted
            ..s PLIST(47)=curTime      ;时间OEORE_TimeExecuted
            ..s PLIST(50)=seatNo   ;x OEORE_SignFile 座位号
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..s ok=SQLCODE
            ..if SQLCODE d
            ...s RowID=%ROWID
            ...s Row1=$P(RowID,"||",1),Row2=$P(RowID,"||",2),Row3=$P(RowID,"||",3)
            ...s $P(^OEORD(Row1,"I",Row2,"X",Row3),"^",16)=statid 
            ...d
        .e  d
            ..b  ;d
            ..s oreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
            ..if oeoreSub="" s oeoreSub=oreSub
            ..s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
            ..//s ret=$$select^MVBOEEXE(oeoreId)  ;取出原有数据
            ..s curPLIST37=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)   ;//1 changed to oreSub !! OEORE_CTPCP_DR
            ..//&js<alert("come in oeore else "+"#(oeordId)#"+"/"+"#(oeoriSub)#"+"/"+"#(curPLIST37)#"+"/");>
            ..b ;i $g(PLIST(37))="" d
            ..i $g(curPLIST37)="" d
                ...;i (num[".")&(num<1) s num="."_$p($g(num),".",3)
                ...s PLIST(37)=ctpcpId      ;pin 码 执行人OEORE_CTPCP_DR
                ...s PLIST(40)=""  //statid   ;状态OEORE_Order_Status_DR
                ...s PLIST(42)=num      ;剂量OEORE_QtyAdmin
                ...s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
                ...s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
                ...s PLIST(46)=curDate      ;日期OEORE_DateExecuted 
                ...s PLIST(47)=curTime      ;时间OEORE_TimeExecuted
                ...//&js<alert("come in oeori else "+"#(num)#"+"/"+"#(pin)#"+"/"+"#(statid_" "_uomid_" "_dat_"-"_tim)#"+"/");>
            ...////ypz add .
            ...//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
            ...&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:curDate,
                   OEORE_TimeExecuted=:curTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
            ...s ok=SQLCODE
            ...if SQLCODE=0 d
            ....s statid=$o(^OEC("STAT",0,"Desc",$$ALPHAUP^SSUTIL4(stat),""))
            ....s $P(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)=statid
     .//i ok'=0 q
        .i admType="I" d 
        	..;q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	..q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
        	..q:insAttStr=""
         	..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
         	..q:phcinId=""
        	..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        	..q:phcfrId=""
        	..s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
        	..//s ^TMPNurOPDebug(oeordId,oeoriSub,34)=arcimId_"/"_userDeptId
       		..TStart
        	..s isAbort=0
        	..f iInst=1:1:$l(insAttStr,"^")  d
        		...s insItem=$p(insAttStr,"^",iInst)
        		...s arcimId=$p(insItem,$c(2)),qty=$p(insItem,$c(2),2)
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,35)=userId_"/"_oeordId_"/"_arcimId_"/"_qty_"/"_userDeptId
        		...s retInsord=##Class(web.DHCCLCom).InsertOrdItem(usrId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,36)=retInsord
        		...i retInsord'=0 s isAbort=1
        	..i isAbort TRollBack  s insTimes=0 q
        	..TCommit
        	..s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
        	..s insTimes=phfactor-maxPhfactor
        	..i insTimes<0 s insTimes=0
        	..i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
        	..s prefiTimes=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"D",""),-1)
            ..i $g(prefiTimes)="" s oneTimes=1
            ..e  s oneTimes=0
            ..i oneTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"D",oneTimes)=$g(inattList("D"))
        	..q //下面程序不执行
     ;如果是复核皮试医嘱    ;Y^1^完成^777^8412||395^49      
     i exeMark="C" d 
         .s oeordId=+oeoriId
         .s oeoriSub=$p(oeoriId,"||",2)
         .s oeoriId=oeordId_"||"_oeoriSub
         .s usrId=$p(param,"^",4) ;复核人姓名和ctpcpId码
         .s ctcpId=$p(^SSU("SSUSR",usrId),"^",14)
	     .s curDate=+$h,curTime=$p($h,",",2)
	     .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	     .i dhcoriId'="" d
	     ..//&sql(update DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:ctcpId,DHCORI_SkinTestAuditDate=:curDate,DHCORI_SkinTestAuditTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
	     ..s SkinTestCtcpDr=$P($G(^DHCORDItem(dhcoriId)),"^",2)
	     ..i SkinTestCtcpDr=ctcpId s ok="-1000"
	     ..e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:ctcpId,DHCORI_SkinTestAuditDate=:curDate,DHCORI_SkinTestAuditTime=:curTime where DHCORI_RowId=:dhcoriId)
       //s ^liulei(oeoriId)=ok
    q ok
}

ClassMethod SetSkinTestResult(oriOreId, userId, flag) As %String
{
    //皮试处理
   // n (oriOreId,userId,flag)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
 	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	////多次置结果的控制?//同一次
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	b //SetSkinTestResult--1
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_RowId=:dhcoriId)
    b  //SetSkinTestResult--2
 	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
 	s OrdTyp=..GetOrdType(oeordId,oeoriSub)
 	if (OrdTyp="R")
    {
	  s resStr=##class(web.DHCCLCom).UpdatePatAllergy(oeoriId,userId,flag)
    }
    else
    {
	 q 0
	}
	i resStr'=0 q resStr
	q 0
}

ClassMethod updhcoroei(dhcoriId) As %String
{
}

ClassMethod GetOrdType(Oew, OrdSub) As %String
{
	 // n (Oew,OrdSub,Flag)
	   s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   s ARCIMRowid=$P(ArcimDR,"||",1)
	   s ARCIMSub=$P(ArcimDR,"||",2)  
	   s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	   s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	   q OrdType
}

ClassMethod SetDisconOrder(oeoriId As %String, userId As %String)
{
   //
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
	//i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:oeoriId,:userId,:curDate,:curTime))
	//e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)

	//i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:Row,:userId,:curDate,:curTime))
	//e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:Row)
    //s ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)=+$h_"^"_$p($h,",",2)_"^"_userId
    b
    q +$h_"^"_$p($h,",",2)
}

ClassMethod UndoDisconOrder(oeoriId As %String, userId As %String)
{
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" q 0
	s nullStr=""
	//&sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:nullStr,DHCORI_DisconDate=:nullStr,DHCORI_DisconTime=:nullStr where DHCORI_OEORI_Dr=:oeoriId)
    //k ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)
    q 0
}

ClassMethod UndoUpdateExecStat(oeoriId, arcicId, oecprDesc, userId) As %String
{
	//k PLIST
	//s name=$p(user,"^"),password=$p(user,"^",2)
	//s val=$$select^MVBSSUSR(name,password) ;验证用户身份
	//i val'=0 s P5=100  ;如果用户验证错误?设置标记
	//&js<alert("oeoriId="+"#(oeoriId)#"+" arcicId"+"#(arcicId)#");>
	s ctcpName=""
	s stat=##class(web.DHCPdaComm).GetOrdStat($P(oeoriId,"||"),$P(oeoriId,"||",2))
	//s oeoriId="876953||985||2"
	//s userId=10374
	if (stat="D") //&(^TMP("Hospital")="AZ")
	{
	 s ret=##class(web.DHCPdaComm).UnDoDisconFlag($P(oeoriId,"||"),$P(oeoriId,"||",2))
	 //s ret=##class(web.DHCPdaComm).UndoDisconOrder($P(oeoriId,"||"),$P(oeoriId,"||",2),userId)
	 s ret=##class(web.DHCPdaComm).UndoDisconOrder(oeoriId,userId)
	 q 0
	}
	&sql(select ssusr_careprov_dr->ctpcp_desc into :ctcpName from ss_user where ssusr_RowId=:userId)
	k PLIST
	s resStr=0
	i 1 d  //(oecprDesc["即刻")!(oecprDesc["临时")!(oecprDesc["长期")
	    .//&js<alert("arcicId="+"#(arcicId)#");>
	    .i arcicId=-90 d   //;待改!!!!????(arcicId=90)!(arcicId=228)  d   ;查询是否为即刻执行医嘱?删除记录
	        ..&sql(select oeore_rowid,oeore_ctpcp_dr->ctpcp_desc into :oeoreId,:ctcpDesc from oe_ordexec where oeore_oeori_parref=:oeoriId)
	        ..i $g(ctcpDesc)'[ctcpName d
	            ...s resStr=-2
	        ..e  d
	            ...//d delete^MVBOEEXE(oeoreId)
	    .i 1 d  //;目前程序
	        ..//s oeoreId=oeoriId_"||"_1
	        ..s oeordId=+oeoriId //oeoriId为医嘱或医嘱执行的RowId
	        ..s oeoriSub=$p($g(oeoriId),"||",2)
	        ..s oeoreSub=$p($g(oeoriId),"||",3) //ypz 060308
	        ..//s oeoriId=+oeoriId_"||"_oeoriSub //ypz 060308
	        ..i oeoreSub="" s oeoreSub=$o(^OEORD(+oeoriId,"I",oeoriSub,"X",0)) //ypz
	        ..i oeoreSub="" s resStr=-1 q
	        ..s oeoreId=oeoriId_"||"_oeoreSub
	        ..&sql(select oeore_ctpcp_dr->ctpcp_desc into :ctcpDesc from oe_ordexec where oeore_rowid=:oeoreId)
	        ..&sql(select * into PLIST() from SQLUSER.Oe_OrdEXEC where oeore_rowid=:oeoriId)
	        ..b
	        ..i $g(ctcpDesc)'[ctcpDesc d //
	            ...s resStr=-2
	        ..e  d
	            ...//&js<alert("#(oeoreId)#"+" ok ");>
	            ...s PLIST(25)=""      ;停止日期
	            ...s PLIST(36)=""      ;停止时间
	            ...s PLIST(37)=""      ;执行人
	            ...s PLIST(40)=""      ;状态
	            ...s PLIST(42)=""      ;剂量
	            ...s PLIST(43)="I"  ;帐单状态
	            ...s PLIST(44)=""      ;单位
	            ...s PLIST(46)=""      ;日期 
	            ...s PLIST(47)=""      ;时间
	            ...s billFlag="I",tmpStr=""
	            ...//&sql(UPDATE OE_OrdExec VALUES PLIST() WHERE OEORE_RowId=:oeoriId)
	            ...&sql(update Oe_ordexec set OEORE_CTPCP_DR=:tmpStr,OEORE_Order_Status_DR=:tmpStr,OEORE_QtyAdmin=:tmpStr,OEORE_CTUOM_DR=:tmpStr,OEORE_DateExecuted=:tmpStr,OEORE_TimeExecuted=:tmpStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	            ...s resStr=SQLCODE
	            ...//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
	            ...//&js<alert("SQLCode="+"#(SQLCODE)#");>
	q resStr
}

ClassMethod Logon(userid, pinnumber) As %String
{
    //s ^TMP("Hospital")="JST"
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""))
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",3) {
	  	 zn oldnamespace
		q "-4"
	}
	s ssgrp=$p(^SSU("SSUSR",User),"^",5)
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	s UserID=$p(^SSU("SSUSR",User),"^")
	s DefLocDes=$p($G(^CTLOC(DefLoc)),"^",2)
	s DocID=$p(^SSU("SSUSR",User),"^",14)
   	zn oldnamespace 
   // d ##class(DHCPdaComm).Init(User)
	s LogonDep=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(User)
	if LogonDep="-1"{
		s LogonDep="logonctloc&LocDesc&rowid&$"_DefLocDes_"^"_DefLoc_"^&"
		}else{
			s LogonDep=LogonDep_DefLocDes_"^"_DefLoc_"^&"
			}
	q User_"^"_DefLoc_"^"_ssgrp_"^"_UserName_"^"_UserID_"^"_DocID_"@"_LogonDep
}

Query logonctloc(userid As %String) As %Query(ROWSPEC = "LocDesc:%String,rowid:%String")
{
}

ClassMethod logonctlocExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .q:+chl=0
    .s loc=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .s locdes=$p($G(^CTLOC(loc)),"^",2)
    .q:locdes=""
    .s tm(loc)=locdes
    s loc=""  f  s loc=$O(tm(loc)) q:loc=""  d
    .s locdes=tm(loc)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(locdes,loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonctlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonctlocExecute ]
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

ClassMethod logonctlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSystTime() As %String
{
	s date=$ZD(+$H,3)
	s week=$ZD(+$H,10)
	s tim=$P($H,",",2)
	s tim=$ZT(tim)
 q date_"^"_week_"^"_tim
}

ClassMethod GetEmrInterface() As %String
{
  //电子病历接口
 s PDADR=$o(^DHCEPRM.SysOptionI("NameIndex"," PDAINTERFACE",""))
 s ret=""
 if PDADR'=""
 {
   s InterfaceStr=$li(^DHCEPRM.SysOptionD(PDADR),4)
   s ChartItemID= $p($g(InterfaceStr),"^",1)

   s CategoryID= $p($g(InterfaceStr),"^",2)

   s TemplateID= $p($g(InterfaceStr),"^",2)
   s ret=ChartItemID_"^"_CategoryID_"^"_TemplateID
 }
 q ret
}

ClassMethod GetArcim(CATCode As %String, Item As %String, GroupRID As %String, EpisodeId As %String) As %String
{
  // n (WardLoc, Adm, Excute , UnExcute , scroll, UserId,VarTyp)
   //	s QueryName="web.DHCOPItemMast:ARCIMastList"
   s ^TMP("GetArcim")=$LB(CATCode , Item, GroupRID ,EpisodeId )
    s QueryName="web.DHCDocOrderEntry:LookUpItem"

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Item,GroupRID,"","","","",EpisodeId,"","","","","","","")

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
   s i=0
   While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
	        if (rset.GetColumnName(col)="HIDDEN")
	        {
		       s head=rset.GetColumnName(col)_col
	        }else
	        {
		       s head=rset.GetColumnName(col)
	        }
            s ret=ret_head_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
	      // if (rset.GetColumnName(col)'="HIDDEN"){
		      s cellData=rset.GetData(col)
		      s cellData=$TR(cellData,"%")
		      s cellData=$TR(cellData,"!")
		      s cellData=$TR(cellData,":")
		      s cellData=$TR(cellData,"^")
		      i $P(cellData,"-",2)'="" s cellData=$P(cellData,"-",2)
		      i ($P(cellData,".",2)'="")&&(+cellData>0) d
		      .s cellData=cellData+1-1
		      s coldata=coldata_cellData_"^"
	      // }
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>80  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetCurrAdm(RegNo As %String) As %String
{
	;W ##CLASS(web.DHCPdaNurComm).GetCurrAdm("0001210302")
	s ^liulei("111")=RegNo
	s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
    s Ret=""
	if Adm'="" {
		s str=##class(web.DHCPdaComm).NurPatInfo(Adm)
		s Ret=Adm_"$"_str
		}
	q Ret
}

Query GetOrcat(userid As %String) As %Query(ROWSPEC = "ORCAT_Rowid:%Integer,ORCAT_Desc:%String,Sel")
{
}

ClassMethod GetOrcatExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^OEC("ORCAT",chl))  q:chl=""  d
    .s des=$P(^OEC("ORCAT",chl),"^",2)
    .s rw="^"_chl_"^"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrcatExecute ]
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

ClassMethod GetOrcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrcatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPhcin(userid As %String) As %Query(ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String,Sel:%String")
{
}

ClassMethod GetPhcinExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCIN(chl) )  q:chl=""  d
    .s des=$P(^PHCIN(chl) ,"^",2)
    .s rw="^"_chl_"^"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinExecute ]
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

ClassMethod GetPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOecpr(userid As %String) As %Query(ROWSPEC = "oecpr_rowid:%Integer,oecpr_Desc:%String,Sel")
{
}

ClassMethod ScanExcute(RowId, User, userdeptid) As %String
{
 //扫描条码执行医嘱
 s ret=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",RowId,"F",User,userdeptid,"","","","")
 q 0
}

ClassMethod GetlabOritem(LabEpisode, Adm As %String, messageFlag As %String = "0") As %String
{
	//根据标本号求医嘱
	s ^lyx("lab")=$lb(LabEpisode,Adm)
 	s Labstr=""
 	q:(LabEpisode["-")&(messageFlag=1) "NO@您扫描的是输液条码,请扫描检验条码" 	
 	q:(LabEpisode["-")&(messageFlag'=1) "NO"
 	s Ord=""  f  s Ord=$O(^OEORD(0,"EpisNo",LabEpisode,Ord)) q:Ord=""  d
 	.s Episodeid=$P(^OEORD(Ord),"^",1)
 	.i ((Episodeid=Adm)||(Adm="")) d //不是这个病人的医嘱
 	..s chl=""  f  s chl=$O(^OEORD(0,"EpisNo",LabEpisode,Ord,chl)) q:chl=""  d
 	...s exstr=..GetLabExstr(Ord,chl)
 	...s str=..getarcimDetail(Ord,chl)
 	...q:str=""
 	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(Ord_"||"_chl) //ypz 070204
  	...i ordStatCode="D" s errorMessage="瓶签对应的医嘱已经停止,不能执行" //ypz 070204 跳过停止的 070310 rem
  	...q:ordStatCode="D"
 	...s $P(str,"|",4)=LabEpisode
 	...s Labstr=Labstr_str_"|"_exstr_"^"
 	i $g(errorMessage)="" s errorMessage="不是同一个病人的医嘱,请核对!"
 	if (Labstr="")&(messageFlag'=1) s Labstr="NO"
 	if (Labstr="")&(messageFlag=1) s Labstr="NO@"_errorMessage
 	if Adm="" s Labstr=Labstr_"#"_Episodeid
 	q Labstr
}

ClassMethod GetlabOritem1(LabEpisode, Adm As %String, messageFlag As %String = "0") As %String
{
	//根据标本号求医嘱
 	s Labstr=""
 	s exstrFlag="||"
 	q:(LabEpisode["-")&(messageFlag=1) "NO@您扫描的是输液条码,请扫描检验条码" 	
 	q:(LabEpisode["-")&(messageFlag'=1) "NO"
 	s Ord=""  f  s Ord=$O(^OEORD(0,"EpisNo",LabEpisode,Ord)) q:Ord=""  d
 	.s Episodeid=$P(^OEORD(Ord),"^",1)
 	.i ((Episodeid=Adm)||(Adm="")) d //不是这个病人的医嘱
 	..s chl=""  f  s chl=$O(^OEORD(0,"EpisNo",LabEpisode,Ord,chl)) q:chl=""  d
 	...s exstr=..GetLabExstr(Ord,chl)
 	...if exstr'="||"  s exstrFlag=exstr
 	...s str=..getarcimDetail(Ord,chl)
 	...q:str=""
 	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(Ord_"||"_chl) //ypz 070204
  	...i ordStatCode="D" s errorMessage="瓶签对应的医嘱已经停止,不能执行" //ypz 070204 跳过停止的 070310 rem
  	...q:ordStatCode="D"
 	...s $P(str,"|",4)=LabEpisode
 	...s Labstr=Labstr_str_"|"_exstr_"^"
 	if exstrFlag'="|" s errorMessage="医嘱已执行,请核对!",Labstr=""
 	i $g(errorMessage)="" s errorMessage="不是同一个病人的医嘱,请核对!"
 	if (Labstr="")&(messageFlag'=1) s Labstr="NO"
 	if (Labstr="")&(messageFlag=1) s Labstr="NO@"_errorMessage
 	if Adm="" s Labstr=Labstr_"#"_Episodeid
 	q Labstr
}

ClassMethod ScanBarBaiYaoExcut(str As %String, user As %String) As %String
{
 //摆药执行
  //s str="2008-07-18 16:00:00!20||88^2008-07-18 16:00:00!20||79^2008-07-18 16:00:00!20||73^2008-07-18 16:00:00!20||81^2008-07-18 16:00:00!20||80^"
  s ret=""
  s num=$L(str,"^")
  f i=1:1:num 
  {
	  s ordstr=$P(str,"^",i)
	  q:ordstr=""
	  s ordrow=$P(ordstr,"!",2)
	  s ord=$P(ordrow,"||",1)
	  s chl=$P(ordrow,"||",2)
	  s datestr=$P(ordstr,"!",1)
	  s date=$P(datestr," ",1)
	  s tim=$P(datestr," ",2)
	  s date=$ZDH(date,3)
	  s tim=$ZTH(tim,3)
	  s No=..GetOrdNo(ord,chl,date,tim)
	  s par="Y^^^"_user_"^"_ord_"||"_chl_"||"_No_"^^"
	 // w !,par
	 s ret=..UpdateExecStat(par)
  }
  q 0
}

ClassMethod GetOrdItemBaiYao(str As %String, Adm As %String) As %String
{
  s ret=""
 // s Adm=99
 // s str="2008-08-12 08:00:00!101||199^2008-08-12 08:00:00!101||200^2008-08-12 08:00:00!101||202^2008-08-12 08:00:00!101||203^2008-08-12 08:00:00!101||204^2008-08-12 08:00:00!101||222^2008-08-12 08:00:00!101||223^"
 
 

  s num=$L(str,"^")
  f i=1:1:num 
  {
	  s ordstr=$P(str,"^",i)
	  q:ordstr=""
	  s ordrow=$P(ordstr,"!",2)
	  s ord=$P(ordrow,"||",1)
	  s Episodeid=$P(^OEORD(ord),"^",1) 
      q:Episodeid'=Adm     //不是这个病人的医嘱
	  s chl=$P(ordrow,"||",2)
	  s datestr=$P(ordstr,"!",1)
	  s date=$P(datestr," ",1)
	  s tim=$P(datestr," ",2)
	  s date=$ZDH(date,3)
	  s tim=$ZTH(tim,3)
	  s no=..GetOrdNo(ord,chl,date,tim)
	  s exstr=..GetExcuteNur(ord,chl,no)
	  s ret=ret_..getarcimDetail(ord,chl)_"|"_exstr_"^"
  }
  if ret="" s ret="NO"
  q ret
}

ClassMethod GetOrdNo(ord, chl, date, tim) As %String
{
   s oechl=0 s oechl=$O(^OEORDi(0,"NotExecE",ord,date,tim,chl,oechl))
   q oechl
}

ClassMethod GetLabExstr(Oew, OrdSub) As %String
{
  s exchl=0 s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl))
  if exchl="" s excutstr="||"
  e  s excutstr=..GetExcuteNur(Oew,OrdSub,exchl)
  q excutstr
}

ClassMethod ScanExcuteLabOrd(LabEpisode, user, userDept) As %String
{
     //检验医嘱扫条码执行
	 s num=$L(LabEpisode,"^")
	 for i=1:1:num
	 {
		 s labno=$P(LabEpisode,"^",i)
		 q:labno=""
		 s Ord=0  f  s Ord=$O(^OEORD(0,"EpisNo",labno,Ord)) q:Ord=""  d
		 .s chl=0  f  s chl=$O(^OEORD(0,"EpisNo",labno,Ord,chl)) q:chl=""  d
		 ..s Sub=$o(^OEORD(Ord,"I",chl,"X",0))
		 ..i Sub="" s Sub="1"
		 ..s ret=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",Ord_"||"_chl_"||"_Sub,"F",user,userDept,"","","","")
		 ..i ret=0 s retColl=##class(web.DHCNurSpecerNo).UpdateSpacer(Ord_"||"_chl_"||"_Sub,user)  //更新采血时间
    }
	 q 0
}

ClassMethod GetFillerOrd(RowId) As %String
{
	s oeordId=+RowId
	s oeordchl=$p(RowId,"||",2)
	s PriorityDr=$p(^OEORD(oeordId,"I",oeordchl,1),"^",8)
	s PriorityDesc=$p(^OECPR(PriorityDr),"^",1)
	s oeordRowId=""
	i (PriorityDesc="S") d
	.s chl=0 f  s chl=$o(^OEORD(oeordId,"I",chl)) q:(chl="")||(oeordRowId'="")  d
	..s oeordFillerNo=$p(^OEORD(oeordId,"I",chl,9),"^",12)
	..i oeordFillerNo=""  q 
    ..s oeordFillerNo=$p(oeordFillerNo,"!!",2)
    ..i oeordFillerNo=RowId d
    ...s oeordRowId=oeordId_"||"_chl
    i oeordRowId'="" s RowId=oeordRowId
    i oeordRowId=""  q ""
    s oeordFillerNo=$p(^OEORD(oeordId,"I",oeordchl,1),"^",9)
    q RowId
}

ClassMethod GetRelationOrd(RowId, No, Adm, messageFlag As %String = "0") As %String
{
  ;w ##class(web.DHCPdaNurComm).GetRelationOrd("7833531||220","1",$c(0))
  //关联医嘱
  s ArcRet=""
  //,mainOrdStatCode=""
  q:(RowId'["||")&(messageFlag=1) "NO@您扫描的是检验条码,请扫描输液条码"
  q:(RowId'["||")&(messageFlag'=1) "NO"
  s oeordId=+RowId
  //s ret=..Getexdattime(RowId,No)
  s Episodeid=$P(^OEORD(oeordId),"^",1) 
  //if Episodeid'=Adm q "NO" //不是这个病人的医嘱
  //s RowId=..GetFillerOrd(RowId)
  if RowId="" q "NO"
  if No="" q "NO"
  if '$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No))  q "NO"
  i ((Episodeid=Adm)||(Adm=$c(0))) d
  .s oeordId=+RowId
  .//q:ret="" "NO"
  .//s date=$P(ret,"^"),tim=$P(ret,"^",2)
  .s chl=$P(RowId,"||",2)
  .s mainOrdStatCode=##Class(web.DHCCLCom).GetOrdStatCode(RowId) //ypz 070204
  .i mainOrdStatCode="D" s errorMessage="瓶签对应的医嘱已经停止,不能执行"
  .q:mainOrdStatCode="D"
  .//按时间确定要执行的医嘱
  .//s No=..GetOrdNo(oeordId, chl, date, tim)
  .//q:No="" "NO"
  .s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
  .s ArcRet=..getarcimDetail(+RowId,$P(RowId,"||",2))_"|"_..GetExcuteNur(oeordId,$P(RowId,"||",2),No)
  .if ArcRet'="" s ArcRet=ArcRet_"^"
  .s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
  ..s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
  ..s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
  ..s ARCIMRowid=$P(ArcimDR,"||",1)
  ..s ARCIMSub=$P(ArcimDR,"||",2)
  ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
  ..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
  ..s ArcimDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
  ..///q:OrdTyp'="R" //非药品医嘱   华西显示所有子医嘱信息
  ..q:stdate'=mainStdate
  ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub) //ypz 070204
  ..i ordStatCode="D" s errorMessage="瓶签对应的医嘱已经停止,不能执行" //ypz 070204 跳过停止的 070310 rem
  ..q:ordStatCode="D"
  ..i OrdTyp="R" s ret=..getarcimDetail(oeordId,curOriSub)_"|||"
  ..e  s ret=ArcimDesc_"||||||"
  ..if ret'="" s ArcRet=ArcRet_ret_"^" 
  //if (mainOrdStatCode="D") q "Stop"
  i $g(errorMessage)="" s errorMessage="不是同一个病人的医嘱,请核对!"
  if (ArcRet="")&(messageFlag'=1) s ArcRet="NO"
  if (ArcRet="")&(messageFlag=1) s ArcRet="NO@"_errorMessage
  if Adm=$c(0) s ArcRet=ArcRet_"#"_Episodeid
  q ArcRet
}

ClassMethod Getexdattime(rowid, seqno)
{
	s oew=+rowid
	s oesub=$P(rowid,"||",2)
	s chl="" s chl=$O(^DHCOEDISQTY(0,"SEQNO",rowid,seqno,chl))
	s tim=$P(^DHCOEDISQTY(chl),"^",20) 
	s Date=$P(^OEORD(oew,"I",oesub,"X",seqno),"^")

	q Date_"^"_tim
}

ClassMethod GetExcuteNur(Oew, OrdSub, ExceChl) As %String
{
  //去执行人执行时间
    s ExDate=$P($G(^OEORD(Oew,"I",OrdSub,"X",ExceChl)),"^",19)
    s ExTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)
    S exdate=$ZD($P($G(^OEORD(Oew,"I",OrdSub,"X",ExceChl)),"^",1),3)
    s exdate=$P(exdate,"-",3)
    s extime=+$ZT($P($G(^OEORD(Oew,"I",OrdSub,"X",ExceChl)),"^",2))
    if ExDate'="" s ExDateTime=$ZD(ExDate,3)_" "_$ZT(ExTime)
    //if dispstat["已处理" w !,StopStr b
    s ExceCptDr=$P($G(^OEORD(Oew,"I",OrdSub,"X",ExceChl)),"^",15)
    if ExceCptDr'="" s ExceUsr=$P(^CTPCP(ExceCptDr,1),"^",2)
    s ExecStatDr=$p($G(^OEORD(Oew,"I",OrdSub,"X",ExceChl)),"^",16)
    i ExecStatDr'="" s ExecStatCode=$p(^OEC("STAT",ExecStatDr),"^",1)
	q $G(ExDateTime)_"|"_$G(ExceUsr)_"|"_exdate_"."_extime_"|"_$g(ExecStatCode)
}

ClassMethod getphbasnum(dosunit, dosqty, scrip, ver) As %String
{
 //求剂量基本单位   149, 1000                 //540,1
    s drgfrm=$P(^ARCIM(scrip,ver,1),"^",12)
    s drg=+drgfrm,frm=$P(drgfrm,"||",2)
    s basuom=$P(^PHCD(+drgfrm,"DF",frm,2),"^",4)
    if basuom=dosunit q ""
    s eqrw=0 f  s eqrw=$O(^PHCD(drg,"DF",frm,"EQ",eqrw)) q:eqrw=""  d
    .s equnit=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",1)
    .if equnit=dosunit d
    ..s eqval=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",2)
    if $G(eqval)'="" d
    .s num=dosqty/eqval
    .s ret=$FN(num,"",1)_$p($g(^CT("UOM",basuom)),"^",2)
    q $G(ret)
}

ClassMethod getarcimDetail(oew, chl) As %String
{
    //n (oew,chl,typ)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
     s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)  //关联  OEORI_OEORI_DR
     
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     //要素PHC_FREQ
     //if $G(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
     if phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
    // W !,doseQty,",",$G(unitUomId),",",chl
	 f rnum=1:1:$G(^OEORD(oew,"I",chl,"DEP",0))  d
	 .s val("notes")=$G(val("notes"))_$G(^OEORD(oew,"I",chl,"DEP",rnum))
     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s val("doseQtyUnit")=$G(doseQty)_" "_$g(unitDesc)
     s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
     //i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     if $G(phcinDesc)'="" s dosequnit=..getphbasnum(unitUomId,doseQty,scrip,ver)
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i (phOrdQty'="") s PackNum=phOrdQty_" "_$G(unitDesc)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     s packUomId=+packUomId
     i (packUomId'=0)&(packUomQty'="") d 
     .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     if packUomQty'="" s PackNum=$G(packUomQty)_" "_$G(packUomDesc)
     s val("phOrdQtyUnit")=PackNum
     s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
     s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
     i reclocId'="" s val("reclocDesc")=$P($p($g(^CTLOC(reclocId)),"^",2),"-",2)
     e   s val("reclocDesc")=""
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
     s OrdDate=$P($G(^OEORD(oew,"I",chl,1)),"^",9)  //stdat
     //i ("^S^OMST^"[PriorCode)&(dose'="") s OrdDate=OrdDate+1
     //打印执行单时长期药物开始时间加1 因为是提前摆药
     s OrdDate=$ZD(OrdDate,3) 
     s PrnDate=$ZD(+$H,3)_" "_$Zt($P($H,",",2))
     s SeqNo=$p($g(^OEORD(oew,"I",chl,3)),"^",4) //qshe add 05-08-22
     //i (SeqNo'="")&(+SeqNo'=0) d  //ypz 060925 error data protect
    // .s tmpSeqNo=$P(SeqNo,"||",2)
     //e  s tmpSeqNo=chl    //未打
    // s SeqNo=oew_tmpSeqNo
     if $G(dosequnit)'="" s val("doseQtyUnit")=dosequnit
	 s phcfrCode=""
     s Arcim=arcimdes_"|"_$G(val("doseQtyUnit"))_"|"_$G(phcinDesc)_"|"_SeqNo
     q Arcim
}

ClassMethod GetOecprExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   s chl=0  f  s chl=$O(^OECPR(chl))  q:chl=""  d
    .s des=$P(^OECPR(chl),"^",2)
    .s rw="^"_chl_"^"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOecprFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOecprExecute ]
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

ClassMethod GetOecprClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOecprExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPhFreq(userid As %String) As %Query(ROWSPEC = "oecpr_rowid:%Integer,oecpr_Desc:%String,Sel")
{
}

ClassMethod GetPhFreqExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCFR(chl))  q:chl=""  d
    .s des=$P(^PHCFR(chl),"^",1)
    .//s rw="^"_chl_"^"
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,"")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhFreqExecute ]
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

ClassMethod GetPhFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetUserGrp(user As %String, logloc As %String) As %String
{
  //根据登陆科室求安全组//2008-11-11 qse
    s grp=""
    s chl=""  f  s chl=$O(^SSU("SSUSR",user,"OTHLL",chl)) q:chl=""  d
    .s loc=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",1)
    .q:loc'=logloc
    .s grpId=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",2)
    .s grpdes=$p($G(^SSU("SSGRP",grpId)),"^",1)
    .q:grpdes'["住院护士"
    .s grp=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",2)
    q grp
}

ClassMethod GetOrdInfoByBarCode(RowId, No, Adm, UserId) As %String
{
  //关联医嘱
  //w ##class(web.DHCPdaNurComm).GetOrdInfoByBarCode("10287552||93","1","","23309")
  s ArcRet=""
  s retdesc=""
  q:(RowId'["||")||(No="") "No"
  s oeordId=+RowId
  s Episodeid=$P(^OEORD(oeordId),"^",1) 
  //if Episodeid'=Adm q "No" //不是这个人的
  s PapmiId=+^PAADM(Episodeid)
  s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2)  
  q:'$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No)) "No"
  s oeordId=+RowId
  s chl=$P(RowId,"||",2)
  //按时间确定要执行的医嘱
 
  s OrdStatusDR=$P($G(^OEORD(oeordId,"I",chl,1)),"^",13)
  s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
  q:OrdStat="停止" "No"
  
  s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
  s ArcRet=..getarcimDetailNew(+RowId,$P(RowId,"||",2))
  s ExecDate=$P(^OEORD(oeordId,"I",chl,"X",No),"^",1)
  s ExecTime=$P(^OEORD(oeordId,"I",chl,"X",No),"^",2)
  i (ExecDate'="")&&(ExecTime'="") s ExecDateTime=$ZD(ExecDate,3)_" "_$ZT(ExecTime,2)
  s ExecUserId=$P(^OEORD(oeordId,"I",chl,"X",No),"^",15)
  i ExecUserId'="" s ExecUser=$P(^CTPCP(ExecUserId,1),"^",2)
  e  s ExecUser=""
  s ArcRet=ArcRet_"|"_ExecDateTime_"^" 
  
  s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
  .s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
  .s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
  .s ARCIMRowid=$P(ArcimDR,"||",1)
  .s ARCIMSub=$P(ArcimDR,"||",2)
  .s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
  .s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
  .q:OrdTyp'="R" //非药品医嘱
  .q:stdate'=mainStdate
  .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub) //ypz 070204
  .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
  .//s ret=..getarcimDetail(oeordId,curOriSub)_"|"_$G(ExecUser)
  .s ret=..getarcimDetailNew(oeordId,curOriSub)
  .s ExecDate=$P(^OEORD(oeordId,"I",curOriSub,"X",No),"^",1)
  .s ExecTime=$P(^OEORD(oeordId,"I",curOriSub,"X",No),"^",2)
  .i (ExecDate'="")&&(ExecTime'="") s ExecDateTime=$ZD(ExecDate,3)_" "_$ZT(ExecTime,2)
  .s ArcRet=ArcRet_ret_"|"_ExecDateTime_"^" 
  if ArcRet="" q "No"   
  s ArcRet=ArcRet_"&"_RegNo
  
  q ArcRet
  
  //s ArcRetlen=$l(ArcRet,"&")
  //f i=1:1:ArcRetlen d
  //.s tempstr=$p(ArcRet,"&",i)
  //.s retdesc=retdesc_"&"_" 序号:"_$p(tempstr,"|",1)_"  医嘱:"_$p(tempstr,"|",2)_" 用量:"_$p(tempstr,"|",3)_" 用法:"_$p(tempstr,"|",4)_" 频次:"_$p(tempstr,"|",5)_" 执行时间:"_$p(tempstr,"|",6)
  
  //s ArcRet=ArcRet_"&"_RegNo
  //q retdesc
}

ClassMethod GetRelationOrdByBarCode(RowId, No, Adm, UserId) As %String
{
  //关联医嘱
  //w ##class(web.DHCPdaNurComm).GetRelationOrdByBarCode("10287552||124","1","","23309")
  //w ##class(web.DHCPdaNurComm).GetRelationOrdByBarCode("10856957||94","1","","22638")
  //s ^fuckwwt=RowId_"^"_No_"^"_Adm_"^"_UserId
  s ArcRet=""
  q:(RowId'["||")||(No="") "No"
  s oeordId=+RowId
  s Episodeid=$P(^OEORD(oeordId),"^",1) 
  //if Episodeid'=Adm q "No" //不是这个人的
  s PapmiId=+^PAADM(Episodeid)
  s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2)  
  q:'$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No)) "No"
  s oeordId=+RowId
  s chl=$P(RowId,"||",2)
  //按时间确定要执行的医嘱
 
  s OrdStatusDR=$P($G(^OEORD(oeordId,"I",chl,1)),"^",13)
  s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
  q:OrdStat="停止" "No"

  s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
  s ArcRet=..getarcimDetailNew(+RowId,$P(RowId,"||",2))
  s ExecDate=$P(^OEORD(oeordId,"I",chl,"X",No),"^",19)
  s ExecTime=$P(^OEORD(oeordId,"I",chl,"X",No),"^",20)
  i (ExecDate'="")&&(ExecTime'="") s ExecDateTime=$ZD(ExecDate,3)_" "_$ZT(ExecTime,2)
  s ExecUserId=$P(^OEORD(oeordId,"I",chl,"X",No),"^",15)
  i ExecUserId'="" s ExecUser=$P(^CTPCP(ExecUserId,1),"^",2)
  e  s ExecUser=""
  
  s PeiYaoInfo=..GetPeiYaoInfo(RowId,No) //取配药标志
  i $p(PeiYaoInfo,"^",1)="Y" s PeiYaoflag="Y",PeiYeUser=$P(PeiYaoInfo,"^",4)
  e  d 
  .s PeiYaoflag="N",PeiYeUser=""
  .s retsql=..UpdatePeiYaoInfo(RowId,No,UserId)
  .i retsql=0 s PeiYaoflag="Y",PeiYeUser=$p(^SSU("SSUSR",UserId),"^",2)
   
  s HeYaoInfo=..GetHeYaoInfo(RowId,No) //取核药标志
  i $p(HeYaoInfo,"^",1)="Y" s HeYaoflag="Y",FuHeUser=$P(PeiYaoInfo,"^",4)
  e  s HeYaoflag="N",FuHeUser=""
  if ArcRet'="" s ArcRet=PeiYaoflag_"|"_HeYaoflag_"|"_ArcRet_"|"_$G(ExecUser)_"|"_PeiYeUser_"|"_FuHeUser_"^"
  s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
  .s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
  .s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
  .s ARCIMRowid=$P(ArcimDR,"||",1)
  .s ARCIMSub=$P(ArcimDR,"||",2)
  .s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
  .s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
  .q:OrdTyp'="R" //非药品医嘱
  .q:stdate'=mainStdate
  .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub) //ypz 070204
  .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
  .s PeiYaoInfo=..GetPeiYaoInfo(oeordId_"||"_curOriSub,No) //取配药标志
  .i $p(PeiYaoInfo,"^",1)="Y" s PeiYaoflag="Y",PeiYeUser=$P(PeiYaoInfo,"^",4)
  .e  d
  ..s PeiYaoflag="N"
  ..s retsql=..UpdatePeiYaoInfo(oeordId_"||"_curOriSub,No,UserId)
  ..i retsql=0 s PeiYaoflag="Y",PeiYeUser=$p(^SSU("SSUSR",UserId),"^",2) 
  .s HeYaoInfo=..GetHeYaoInfo(oeordId_"||"_curOriSub,No) //取核药标志
  .i $p(HeYaoInfo,"^",1)="Y" s HeYaoflag="Y",FuHeUser=$P(PeiYaoInfo,"^",4)
  .e  s HeYaoflag="N",FuHeUser=""
  .s ret=..getarcimDetailNew(oeordId,curOriSub)_"|"_$G(ExecUser)
  .if ret'="" s ret=PeiYaoflag_"|"_HeYaoflag_"|"_ret_"|"_PeiYeUser_"|"_FuHeUser
  .if ret'="" s ArcRet=ArcRet_ret_"^" 
  if ArcRet="" q "No" 
  s ArcRet=ArcRet_"&"_RegNo
  q ArcRet
}

Query GetFuHeOrd(Input As %String) As %Query(ROWSPEC = "PeiYao,HeYao,SeqNo,ArcimDes,ExecUser,Dose,Meth,PHFreq,PeiYeUser,FuHeUser")
{
}

ClassMethod GetFuHeOrdExecute(ByRef qHandle As %Binary, Input As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	//RowId As %String, No As %String, Adm As %String,UserId As %String
 	s RowId=$p(Input,"^",1)
 	s No=$p(Input,"^",2)
 	s Adm=$p(Input,"^",3)
 	s UserId=$p(Input,"^",4) 
 	s ArcRet=""
 	if (RowId'["||")||(No="") 	Quit $$$OK

    s oeordId=+RowId
    if '$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No)) Quit $$$OK
    s oeordId=+RowId
    s chl=$P(RowId,"||",2)
    //按时间确定要执行的医嘱
 
    s OrdStatusDR=$P($G(^OEORD(oeordId,"I",chl,1)),"^",13)
    s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
    if OrdStat="停止" Quit $$$OK

    s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
    s ArcRet=..getarcimDetailNew(+RowId,$P(RowId,"||",2))
    s ExecDate=$P(^OEORD(oeordId,"I",chl,"X",No),"^",19)
    s ExecTime=$P(^OEORD(oeordId,"I",chl,"X",No),"^",20)
    i (ExecDate'="")&&(ExecTime'="") s ExecDateTime=$ZD(ExecDate,3)_" "_$ZT(ExecTime,2)
    s ExecUserId=$P(^OEORD(oeordId,"I",chl,"X",No),"^",15)
    i ExecUserId'="" s ExecUser=$P(^CTPCP(ExecUserId,1),"^",2)
    //if ArcRet'="" s ArcRet=ArcRet_"|"_$G(ExecDateTime)_"|"_$G(ExecUser)_"^"
    s PeiYaoInfo=..GetPeiYaoInfo(RowId,No) //取配药标志
    i $p(PeiYaoInfo,"^",1)="Y" s PeiYaoflag="Y",PeiYeUser=$P(PeiYaoInfo,"^",4)
    e  d 
    .s PeiYaoflag="N",PeiYeUser=""
    .//s retsql=..UpdatePeiYaoInfo(RowId,UserId)
    .//i retsql=0 s PeiYaoflag="Y" 
   
    s HeYaoInfo=..GetHeYaoInfo(RowId,No) //取核药标志
    i $p(HeYaoInfo,"^",1)="Y" s HeYaoflag="Y",FuHeUser=$P(HeYaoInfo,"^",4)
    e  s HeYaoflag="N",FuHeUser=""
    
    i (HeYaoflag="N")&&(PeiYaoflag="Y") d
    .i (PeiYeUser'=$p(^SSU("SSUSR",UserId),"^",2)) d  //配液人和复核人不能一样
    ..s retsql=..UpdateHeYaoInfo(RowId,No,UserId)
    ..i retsql=0 s HeYaoflag="Y",FuHeUser=$p(^SSU("SSUSR",UserId),"^",2)
    .e  s FuHeUser=PeiYeUser
    
    if ArcRet'=""  s ArcRet=PeiYaoflag_"|"_HeYaoflag_"|"_ArcRet_"|"_$G(ExecUser)_"|"_PeiYeUser_"|"_FuHeUser_"^"

    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
    .s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
    .s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
    .s ARCIMRowid=$P(ArcimDR,"||",1)
    .s ARCIMSub=$P(ArcimDR,"||",2)
    .s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
    .s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
    .q:OrdTyp'="R" //非药品医嘱
    .q:stdate'=mainStdate
    .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub) //ypz 070204
    .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
    .//s ret=..getarcimDetail(oeordId,curOriSub)_"|"_$G(ExecDateTime)_"|"_$G(ExecUser)
    .s PeiYaoInfo=..GetPeiYaoInfo(oeordId_"||"_curOriSub,No) //取配药标志
    .i $p(PeiYaoInfo,"^",1)="Y" s PeiYaoflag="Y",PeiYeUser=$P(PeiYaoInfo,"^",4)
    .e  d
    ..s PeiYaoflag="N",PeiYeUser=""
    ..//s retsql=..UpdatePeiYaoInfo(oeordId_"||"_curOriSub,UserId)
    ..//i retsql=0 s PeiYaoflag="Y" 
    .s HeYaoInfo=..GetHeYaoInfo(oeordId_"||"_curOriSub,No) //取核药标志
    .i $p(HeYaoInfo,"^",1)="Y" s HeYaoflag="Y",FuHeUser=$P(HeYaoInfo,"^",4)
    .e  s HeYaoflag="N",FuHeUser=""
    .i (HeYaoflag="N")&&(PeiYaoflag="Y") d
    .i (PeiYeUser'=$p(^SSU("SSUSR",UserId),"^",2)) d  //配液人和复核人不能一样
    ..s retsql=..UpdateHeYaoInfo(oeordId_"||"_curOriSub,No,UserId)
    ..i retsql=0 s HeYaoflag="Y" ,FuHeUser=$p(^SSU("SSUSR",UserId),"^",2) 
    .e  s FuHeUser=PeiYeUser
    .s ret=..getarcimDetailNew(oeordId,curOriSub)_"|"_$G(ExecUser)
    .if ret'="" s ret=PeiYaoflag_"|"_HeYaoflag_"|"_ret_"|"_PeiYeUser_"|"_FuHeUser
    .if ret'="" s ArcRet=ArcRet_ret_"^" 
    .s ArcRet=$tr(ArcRet,"$","")
    .//if ArcRet="" Quit $$$OK
    .//s ArcRet=ArcRet_"&"_RegNo
 	s columns=$l(ArcRet,"^")-1
 	For col = 1:1:columns { 
 	s retinfo=$p(ArcRet,"^",col) 
 	s PeiYao=$p(retinfo,"|",1)
    s HeYao=$p(retinfo,"|",2)
    s SeqNo=$p(retinfo,"|",3)
    s ArcimDes=$p(retinfo,"|",4)
    s Dose=$p(retinfo,"|",5)
    s Meth=$p(retinfo,"|",6)
    s PHFreq=$p(retinfo,"|",7)
    s PeiYeUser=$p(retinfo,"|",9)
    s FuHeUser=$p(retinfo,"|",10)
    d OutRow3
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow3
    Set Data=$LB($G(PeiYao),$G(HeYao),$G(SeqNo),$G(ArcimDes),$G(ExecUser),$G(Dose),$G(Meth),$G(PHFreq),$G(PeiYeUser),$G(FuHeUser))
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFuHeOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFuHeOrdExecute ]
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

ClassMethod GetFuHeOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFuHeOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdatePeiYaoInfo(oeoriId, no, UserId) As %String
{
	s ok=1
	s flag="Y"
	//s DHCORIRowId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
    s oeoreId=oeoriId_"||"_no
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId="" d
    .&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_PeiMedicalUser_dr,DHCORE_PeiMedicalDate,DHCORE_PeiMedicalTime,DHCORE_PeiMedical) Values(:oeoreId,:UserId,:curDate,:curTime,:flag))
    e  d
    .&sql(update DHC_OE_OrdExec set DHCORE_PeiMedicalUser_dr=:UserId,DHCORE_PeiMedicalDate=:curDate,DHCORE_PeiMedicalTime=:curTime,DHCORE_PeiMedical=:flag where DHCORE_RowId=:dhcoreId)
    s ok=SQLCODE
	q ok
}

ClassMethod GetPeiYaoInfo(oeoriId, no) As %String
{
	//s dhcoriId=$o(^DHCOrdExec(0,"DHCOEORI",oeoriId,""))
    s oeoreId=oeoriId_"||"_no

    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	s ret=""
	if dhcoreId'=""
	{
	  if $D(^DHCOrdExec(dhcoreId))
	  {
		  s flag=$P(^DHCOrdExec(dhcoreId),"^",22)
		  i flag="" s flag="N"
		  s PeiYaodate=$P(^DHCOrdExec(dhcoreId),"^",24)
		  s PeiYaotime=$P(^DHCOrdExec(dhcoreId),"^",25)
		  s userId=$P(^DHCOrdExec(dhcoreId),"^",23)
		  i userId'="" s PeiYaouser=$p(^SSU("SSUSR",userId),"^",2)
		  e  s PeiYaouser=""
		  s ret=flag_"^"_$ZD(PeiYaodate,3)_"^"_$ZT(PeiYaotime,2)_"^"_PeiYaouser
	  }
	}
	q ret
	
	
	/*s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s ret=""
	if dhcoriId'=""
	{
	  if $D(^DHCORDItem(dhcoriId,1))
	  {
		  s flag=$P(^DHCORDItem(dhcoriId,1),"^",11)
		  i flag="" s flag="N"
		  s PeiYaodate=$P(^DHCORDItem(dhcoriId,1),"^",12)
		  s PeiYaotime=$P(^DHCORDItem(dhcoriId,1),"^",13)
		  s userId=$P(^DHCORDItem(dhcoriId,1),"^",14)
		  i userId'="" s PeiYaouser=$p(^SSU("SSUSR",userId),"^",2)
		  e  s PeiYaouser=""
		  s ret=flag_"^"_$ZD(PeiYaodate,3)_"^"_$ZT(PeiYaotime,2)_"^"_PeiYaouser
	  }
	}
	q ret*/
}

ClassMethod UpdateHeYaoInfo(oeoriId, no, UserId) As %String
{
	s ok=1
	s flag="Y"
	//s DHCORIRowId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
	
    s oeoreId=oeoriId_"||"_no
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId="" d
    .&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_HeSMedicalUser_dr,DHCORE_HeSMedicallDate,DHCORE_HeSMedicallTime,DHCORE_HeSMedical) Values(:oeoreId,:UserId,:curDate,:curTime,:flag))
    e  d
    .&sql(update DHC_OE_OrdExec set DHCORE_HeSMedicalUser_dr=:UserId,DHCORE_HeSMedicallDate=:curDate,DHCORE_HeSMedicallTime=:curTime,DHCORE_HeSMedical=:flag where DHCORE_RowId=:dhcoreId)

    s ok=SQLCODE
	q ok
}

ClassMethod GetHeYaoInfo(oeoriId, no) As %String
{
	
    //s dhcoriId=$o(^DHCOrdExec(0,"DHCOEORI",oeoriId,""))
    s oeoreId=oeoriId_"||"_no

    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	s ret=""
	if dhcoreId'=""
	{
	  if $D(^DHCOrdExec(dhcoreId))
	  {
		  s flag=$P(^DHCOrdExec(dhcoreId),"^",26)
		  i flag="" s flag="N"
		  s HeYaodate=$P(^DHCOrdExec(dhcoreId),"^",28)
		  s HeYaotime=$P(^DHCOrdExec(dhcoreId),"^",29)
		  s userId=$P(^DHCOrdExec(dhcoreId),"^",27)
		  i userId'="" s HeYaouser=$p(^SSU("SSUSR",userId),"^",2)
		  e  s HeYaouser=""
		  s ret=flag_"^"_$ZD(HeYaodate,3)_"^"_$ZT(HeYaotime,2)_"^"_HeYaouser
	  }
	}
	q ret
	
	/*
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s ret=""
	if dhcoriId'=""
	{
	  if $D(^DHCORDItem(dhcoriId,1))
	  {
		  s flag=$P(^DHCORDItem(dhcoriId,1),"^",15)
		  i flag="" s flag="N"
		  s HeYaodate=$P(^DHCORDItem(dhcoriId,1),"^",16)
		  s HeYaotime=$P(^DHCORDItem(dhcoriId,1),"^",17)
		  s userId=$P(^DHCORDItem(dhcoriId,1),"^",18)
		  i userId'="" s HeYaouser=$p(^SSU("SSUSR",userId),"^",2)
		  e  s HeYaouser=""
		  s ret=flag_"^"_$ZD(HeYaodate,3)_"^"_$ZT(HeYaotime,2)_"^"_HeYaouser
	  }
	}
	q ret
	*/
}

ClassMethod PatNurseMedRecord(BarCode As %String, User As %String, Patlocdr As %String, NurMedTourMedDeal As %String, NurMedTourMedSituation As %String) As %String
{
	//s Adm=##class(web.DHCPdaNurComm).PatNurseMedRecord("10287552-93-1","23309","814","输液继续","局部疼痛")
    s OEORDRowId=$p(BarCode,"-",1)
    s Adm=$p(^OEORD(OEORDRowId),"^",1)
    s Ret="",ItmMastDesc="",ItmMastDR=""
	if Adm'="" 
	{
		s NurRecDATE=+$h
		s NurRecTIME=$p($h,",",2)
		s papmi=$P(^PAADM(Adm),"^",1)
		s PATName=$P(^PAPER(papmi,"ALL"),"^",1)
		s PATSex=$P(^CT("SEX",$P(^PAPER(papmi,"ALL"),"^",7)),"^",2)
		s PATBeddr=$P(^PAADM(Adm),"^",73)
		s Paadmwarddr=$P(^PAADM(Adm),"^",70)
		s Paadmlocdr=$P(^PAWARD(Paadmwarddr),"^",5)
		i (Patlocdr'=Paadmlocdr)
		{
		   s Ret="该患者非本病区患者,请核实瓶签后再巡视"
		}
		else
		{
		s PATBed=$p(^PAWARD($p(PATBeddr,"||",1),"BED",$p(PATBeddr,"||",2)),"^",1)
		s oeordId=$p(BarCode,"-",1)
		s RowId=$p(BarCode,"-",1)_"||"_$p(BarCode,"-",2)
		
		s ItmMastDR=$p(^OEORD($p(BarCode,"-",1),"I",$p(BarCode,"-",2),1),"^",2)
		s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
		
		s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
        .s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
        .s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
        .s ARCIMRowid=$P(ArcimDR,"||",1)
        .s ARCIMSub=$P(ArcimDR,"||",2)
        .s ItmMastDesctmp=$p(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",2)
        .s ItmMastDesc=ItmMastDesc_" "_ItmMastDesctmp
        .s ItmMastDR=ItmMastDR_"&"_ArcimDR
		
		//w !,ItmMastDesc
		
		//s ItmMastDR=$p(^OEORD($p(BarCode,"-",1),"I",$p(BarCode,"-",2),1),"^",2)
		//s ItmMastDR=$p(BarCode,"-",1)_"||"_$p(BarCode,"-",2)
		
		//s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
		
		s Ret=##class(User.DHCNurMedTourRecord).Insert(Adm,PATBed,PATName,PATSex,NurRecDATE,NurRecTIME,ItmMastDR,User,Patlocdr,NurMedTourMedDeal,NurMedTourMedSituation,$tr(BarCode,"-","||"))
		i Ret=1 s Ret="输液巡视记录失败,请联系系统管理员!"
		i Ret=0 s Ret=PATBed_" "_PATName_" "_ItmMastDesc_" "_"巡视完成"
		//s NurseLevel=##class(web.UDHCJFARREARSMANAGE).CheckNursePDALevel(Adm)
		//i NurseLevel=0 s Ret="该患者无护理级别医嘱,不需巡视!"
		//e  d
		//.s Type=$p(NurseLevel,"^",1)
		//.s ItmMastDR=$p(NurseLevel,"^",2)
		//.s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)				
		//.s Ret=##class(User.DHCADMNurseRecord).Insert(Adm,PATBed,PATName,PATSex,NurRecDATE,NurRecTIME,Type,ItmMastDR,User,Patlocdr)
		//.i Ret=1 s Ret="护理巡视记录失败,请联系系统管理员!"
		//.i Ret=0 s Ret=PATBed_" "_PATName_" "_ItmMastDesc_" "_"巡视完成"
		}
	}
	q Ret
}

ClassMethod getarcimDetailNew(oew, chl) As %String
{
    //n (oew,chl,typ)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
     s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)  //关联  OEORI_OEORI_DR
     
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     //要素PHC_FREQ
     //if $G(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
     if phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
    // W !,doseQty,",",$G(unitUomId),",",chl
	 f rnum=1:1:$G(^OEORD(oew,"I",chl,"DEP",0))  d
	 .s val("notes")=$G(val("notes"))_$G(^OEORD(oew,"I",chl,"DEP",rnum))
     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s val("doseQtyUnit")=$G(doseQty)_" "_$g(unitDesc)
     s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
     //i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     if $G(phcinDesc)'="" s dosequnit=..getphbasnum(unitUomId,doseQty,scrip,ver)
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i (phOrdQty'="") s PackNum=phOrdQty_" "_$G(unitDesc)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     s packUomId=+packUomId
     i (packUomId'=0)&(packUomQty'="") d 
     .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     if packUomQty'="" s PackNum=$G(packUomQty)_" "_$G(packUomDesc)
     s val("phOrdQtyUnit")=PackNum
     s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
     s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
     i reclocId'="" s val("reclocDesc")=$P($p($g(^CTLOC(reclocId)),"^",2),"-",2)
     e   s val("reclocDesc")=""
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
     s OrdDate=$P($G(^OEORD(oew,"I",chl,1)),"^",9)  //stdat
     //i ("^S^OMST^"[PriorCode)&(dose'="") s OrdDate=OrdDate+1
     //打印执行单时长期药物开始时间加1 因为是提前摆药
     s OrdDate=$ZD(OrdDate,3) 
     s PrnDate=$ZD(+$H,3)_" "_$Zt($P($H,",",2))
     s SeqNo=$p($g(^OEORD(oew,"I",chl,3)),"^",4) //qshe add 05-08-22
     //i (SeqNo'="")&(+SeqNo'=0) d  //ypz 060925 error data protect
    // .s tmpSeqNo=$P(SeqNo,"||",2)
     //e  s tmpSeqNo=chl    //未打
    // s SeqNo=oew_tmpSeqNo
     if $G(dosequnit)'="" s val("doseQtyUnit")=dosequnit
	 s phcfrCode=""
     s Arcim=SeqNo_"|"_arcimdes_"|"_$G(val("doseQtyUnit"))_"|"_$G(phcinDesc)_"|"_$g(phcfrCode)
     q Arcim
}

ClassMethod PatNurseLevelRecord(RegNo As %String, User As %String, Patlocdr As %String) As %String
{
	s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
    s Ret=""
	if Adm'="" 
	{
		s NurRecDATE=+$h
		s NurRecTIME=$p($h,",",2)
		s papmi=$P(^PAADM(Adm),"^",1)
		s PATName=$P(^PAPER(papmi,"ALL"),"^",1)
		s PATSex=$P(^CT("SEX",$P(^PAPER(papmi,"ALL"),"^",7)),"^",2)
		s PATBeddr=$P(^PAADM(Adm),"^",73)
		s Paadmwarddr=$P(^PAADM(Adm),"^",70)
		s Paadmlocdr=$P(^PAWARD(Paadmwarddr),"^",5)
		i (Patlocdr'=Paadmlocdr)
		{
		   s Ret="该患者非本病区患者,请核实腕带后再巡视"
		}
		else
		{
		s PATBed=$p(^PAWARD($p(PATBeddr,"||",1),"BED",$p(PATBeddr,"||",2)),"^",1)
		s NurseLevel=##class(web.UDHCJFARREARSMANAGE).CheckNursePDALevel(Adm)
		i NurseLevel=0 s Ret="该患者无护理级别医嘱,不需巡视!"
		e  d
		.s Type=$p(NurseLevel,"^",1)
		.s ItmMastDR=$p(NurseLevel,"^",2)
		.s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)				
		.s Ret=##class(User.DHCADMNurseRecord).Insert(Adm,PATBed,PATName,PATSex,NurRecDATE,NurRecTIME,Type,ItmMastDR,User,Patlocdr)
		.i Ret=1 s Ret="护理巡视记录失败,请联系系统管理员!"
		.i Ret=0 s Ret=PATBed_" "_PATName_" "_ItmMastDesc_" "_"巡视完成"
		}
	}
	q Ret
}

}
