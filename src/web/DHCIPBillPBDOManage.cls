Class web.DHCIPBillPBDOManage Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// //
/// 描述:	  把pb-rowid下的所有的pbdetails记录插入到DHC_PatBillDetailsOld表中,并生成相应负记录
/// 入参:     pbrowid,  OperateFalg的值为RB或OC,IB ,Flag:old表示删除，new表示新生成的
/// 返回值:   SQLCODE 81876
ClassMethod createPBDOByBill(JFPBRowid, JFOperateFlag, JFFlag)
{
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB") q "input error"
	i (JFFlag'="old")&(JFFlag'="new") q "input error"
	d ..tb()
	s JFerr=0
	i $d(^DHCPB(JFPBRowid))=0 q JFPBRowid_" no exist"
	s JFPBORowid=0
	f  s JFPBORowid=$o(^DHCPB(JFPBRowid,"O",JFPBORowid)) q:(JFPBORowid="")||(JFerr'=0)  d
	.if JFFlag="old" s JFerr=##class(web.DHCIPBillPBDOManage).createPBDOByOrder(JFPBRowid,JFPBORowid,JFOperateFlag)
	.if JFFlag="new" s JFerr=##class(web.DHCIPBillPBDOManage).copyDetailsByOrder(JFPBRowid,JFPBORowid,JFOperateFlag)
	i JFerr'=0  TROLLBACK 
	q:JFerr'=0 JFerr   ;yyx 增加
	i JFerr=0 d ..tc()
	q JFerr
}

/// 描述:	  重新生成帐单,中途结算,医嘱改变时,把pbo-Rowid下的所有的pbdetails记录插入到DHC_PatBillDetailsOld表中,
///           并生成相应的负记录,不分日期.
///           一帐单  第一次重新帐单时加三条数据,1.pbdetails表的明细,2.红冲, 3.新帐单的明细,
///                   第二次重新上面新生成的帐单时把新帐单的明细的状态N(Normal)改成D(Deleted)                  
/// 入参:     pbd_pb_dr,     pbd_pbo_dr,     OperateFalg: RB,OC,IB
/// 返回值:   SQLCODE
ClassMethod createPBDOByOrder(JFBill, JFOrder, JFOperateFlag)
{
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB") q "input error"
	i $d(^DHCPB(JFBill,"O",JFOrder))=0  q JFBill_"||"_JFOrder_" no exist"	
	d ..tb()
	s JFPBDRowid=0,JFerr=0
	f  s JFPBDRowid=$o(^DHCPB(JFBill,"O",JFOrder,"D",JFPBDRowid)) q:(JFPBDRowid="")||(JFerr'=0)  d
	.s JFerr=##class(web.DHCIPBillPBDOManage).createPBDOByItem(JFBill,JFOrder,JFPBDRowid,JFOperateFlag)
	i JFerr'=0 TROLLBACK
	q:JFerr'=0 JFerr
	i JFerr=0 d ..tc()
	q JFerr
}

/// 描述:	  重新生成帐单,中途结算,医嘱改变时,把pbd-Rowid下的所有的pbdetails记录插入到DHC_PatBillDetailsOld表中,
///           并生成相应的负记录,不分日期.
///           一帐单  第一次重新帐单时加三条数据,1.pbdetails表的明细,2.红冲, 3.新帐单的明细,
///                   第二次重新上面新生成的帐单时把新帐单的明细的状态N(Normal)改成D(Deleted)                  
/// 入参:     pbd_pb_dr,     pbd_pbo_dr,  pbd,   OperateFalg: RB,OC,IB
/// 返回值:  SQLCODE
ClassMethod createPBDOByItem(JFBill, JFOrder, JFItem, JFOperateFlag)
{
	d ..tb()
	s JFPBPBOPBD=JFBill_"||"_JFOrder_"||"_JFItem
	d ##class(web.DHCIPBillPBDOManage).initPLISTByDetails(JFPBPBOPBD,"D",JFOperateFlag)   
	s JFOldRowid=$o(^DHCPBDOi(0,"PatBillDetails",JFPBPBOPBD,""))
    i $g(JFOldRowid)="" s JFOldRowid=0
	i $g(^DHCPBDO(JFOldRowid)) s JFFlag=$p($g(^DHCPBDO(JFOldRowid)),"^",4)
	i ($g(JFOldRowid)'="0")&&($g(JFflag)=JFOperateFlag) d 
    .s JFerr=##class(web.DHCIPBillPatBillDetailsOld).UPDATE(JFOldRowid)    ;操作是第二次,则把stutasFlag="N"改成"D"
    e  d
    .s JFerr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()          ;操作是第一次,插入一被删记录状态为stutasFlag="D"
	i JFerr'=0 TROLLBACK  q JFerr
	s JFerr=##class(web.DHCIPBillPBDOManage).createPBDOStrike(+$h)          ;写一笔红冲的记录
	i JFerr'=0 TROLLBACK   q JFerr
	i JFerr=0 d ..tc()
	q JFerr
}

/// 描述：	  重新生成帐单时,把pbo-Rowid下的所有的pbdetails记录插入到DHC_PatBillDetailsOld表中                        
/// 入参:     pbd_pb_dr,     pbd_pbo_dr,     OperateFalg: RB,OC,IB
/// 返回值：  SQLCODE
ClassMethod copyDetailsByOrder(JFBill, JFOrder, JFOperateFlag)
{
	//b ;copyDetailsByOrder
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB") q "input error"
	
	i $d(^DHCPB(JFBill,"O",JFOrder))=0  q JFBill_"||"_JFOrder_" no exist"	
	d ..tb()
	s JFPBDRowid=0,JFerr=0
	f  s JFPBDRowid=$o(^DHCPB(JFBill,"O",JFOrder,"D",JFPBDRowid)) q:(JFPBDRowid="")||(JFerr'=0)  d
	.s JFPBPBOPBD=JFBill_"||"_JFOrder_"||"_JFPBDRowid	
	.d ..initPLISTByDetails(JFPBPBOPBD,"N",JFOperateFlag)          				   ;初始化PLIST
	.s JFOldRowid=$o(^DHCPBDOi(0,"PatBillDetails",JFPBPBOPBD,""))
	.i +JFOldRowid=0 s JFerr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()	//已经有了就不再拷入
	i JFerr'=0 TROLLBACK  q JFerr   ;yyx 
	i JFerr=0 d ..tc()
	;q SQLCODE  ; Lid 2009-05-09 修改
	q JFerr
}

/// 描述：	  中途结算时,把pbo-Rowid下的所有的pbdetails记录插入到DHC_PatBillDetailsOld表中
/// 入参:     pbd_pb_dr,     pbd_pbo_dr,  pbdrowid, OperateFalg: RB,OC,IB
/// 返回值：  SQLCODE
ClassMethod copyDetailsByItem(JFBill, JFOrder, JFItem, JFOperateFlag)
{
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB") q "input error"
	i $d(^DHCPB(JFBill,"O",JFOrder,"D",JFItem))=0  q JFBill_"||"_JFOrder_"||"_JFItem_" no exist"	
	d ..tb()
	s JFPBPBOPBD=JFBill_"||"_JFOrder_"||"_JFItem
	d ..initPLISTByDetails(JFPBPBOPBD,"N",JFOperateFlag)   					     ;初始化PLIST
	s JFerr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()
	i JFerr'=0 TROLLBACK  q JFerr
	i JFerr=0 d ..tc()
	q JFerr
}

/// 描述：    根椐details的rowid来初始化PLIST
/// 编写者：  汪会财
/// 编写日期：2009-4-2
/// 入参：    PBPBOPBD=PB||PBO||PBD,    stutasFlag：D或S或N ,   OperateFlag: RB,OC,IB  ;yyx  [ Private ]
ClassMethod initPLISTByDetails(JFPBPBOPBD, JFStutasFlag, JFOperateFlag)
{
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB") q "input error"
	k PLIST
	s JFPBRowid=$p(JFPBPBOPBD,"||",1),JFPBORowid=$p(JFPBPBOPBD,"||",2),JFPBDRowid=$P(JFPBPBOPBD,"||",3)
	i $d(^DHCPB(JFPBRowid,"O",JFPBORowid,"D",JFPBDRowid))=0  q JFPBRowid_"^"_JFPBORowid_"^"_JFPBDRowid_" no exist"
	s JFadm=$p(^DHCPB(JFPBRowid),"^",1)
	s JFoeOrdDR=$p($g(^DHCPB(JFPBRowid,"O",JFPBORowid)),"^",4)
	s PLISTDetails = $g(^DHCPB(JFPBRowid,"O",JFPBORowid,"D",JFPBDRowid))
	d ..initPLIST(JFPBPBOPBD,PLISTDetails,JFStutasFlag,JFOperateFlag,JFoeOrdDR,JFadm)
}

/// 描述：   DHC_PatBillDetails表的Rowid,  节点值(Global的值),  表DHC_PatBillDetailsOld中的状态stutasFlag：D或S或N ,   OperateFlag: RB,OC,IB ,医嘱指向,adm指向
/// 编写者：  汪会财
/// 编写日期：2009-4-2
/// 入参：    PBPBOPBD=PB||PBO||PBD,       ;yyx  [ Private ]
ClassMethod initPLIST(JFPBPBOPBD, PLISTDetails, JFStutasFlag, JFOperateFlag, JFoeOrdDR, JFadm)
{
	s PLIST(2) = JFPBPBOPBD
	s PLIST(3) = $p(PLISTDetails,"^",3) ;
	s PLIST(4) = $p(PLISTDetails,"^",4)
	s PLIST(5) = $p(PLISTDetails,"^",5)
	s PLIST(6) = $p(PLISTDetails,"^",6)
	s PLIST(7) = $p(PLISTDetails,"^",7)
	s PLIST(8) = $p(PLISTDetails,"^",8)
	s PLIST(9) = $p(PLISTDetails,"^",9)
	s PLIST(10) = $p(PLISTDetails,"^",10)
	//新生成的记录的帐单时间应为当前的时间 
	;i (JFStutasFlag="N")||(JFStutasFlag="S") d
	;.s PLIST(11) = +$h                  //billDate
	;.s PLIST(12) = $p($h,",",2)         //billTime
	;i JFStutasFlag="D" d
	s PLIST(11) = $p(PLISTDetails,"^",11)   //billDate
	s PLIST(12) = $p(PLISTDetails,"^",12)   //billTime
	s PLIST(13) = JFStutasFlag		    //PBDO_BillStatusFlag: Deleted   表示 删除的
	s PLIST(14) = +$h					//createDate
	s PLIST(15) = $p($h,",",2)	     	//createTime
	s PLIST(16) = $p(PLISTDetails,"^",13)
	s PLIST(17) = $p(PLISTDetails,"^",17)
	s PLIST(18) = $p(PLISTDetails,"^",18)
	s PLIST(19) = $p(PLISTDetails,"^",19)
	s PLIST(20) = $p(PLISTDetails,"^",20)
	s PLIST(21) = JFOperateFlag     		//PBDO_BillOperateFlag:  ReBill||RB, OrderChange||OC, IntBill||IB
	s PLIST(22) = $g(JFoeOrdDR)
	s PLIST(23) = $g(JFadm)
	q
}

/// 描述：    只能用在createPBDOByPBD方法后面 , 红冲掉上面生成的记录，即生成相应的负记录
/// 编写者：  汪会财
/// 编写日期：2009-3-27
/// 入参：    没有参数但是用到前面的PLIST  yyx [ Private ]   
ClassMethod createPBDOStrike(inDate)
{
  
	k PLIST(1)
	s PLIST(5) = -PLIST(5)                  // PBDO_BillQty
	s PLIST(7) = -PLIST(7)                  // PBDO_TotalAmount
	s PLIST(10) = -PLIST(10)                // PBDO_PatientShare
	s PLIST(11) = inDate					// billDate
	s PLIST(12) = $p($h,",",2)			    // billTime
	s PLIST(13) = "S"                       // PBDO_BillStatusFlag:Strike  表示负记录
	s PLIST(14) = +$h						// createDate
	s PLIST(15) = $p($h,",",2)			    // createTime
	S RetErr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()  ;插入负记录
	q RetErr
}

/// 描述：    通过oeOrdItem查出下面的details,把details中数据拷到DHC_PatBillDetailsOld表中
/// 编写者：  汪会财
/// 编写日期：2009-4-3
/// 入参：    oeOrdItem是表pbo中的指向, operateFlag:RB,OC,IB
ClassMethod copyByOeOrdItem(JFoeOrdItem, JFOperateFlag)
{
	i (JFOperateFlag'="OC")&(JFOperateFlag'="RB")&(JFOperateFlag'="IB")  q "input error"
	;d ..tc()   ;yyx 注释
	s JFBill=0,JFerr=0
	f  s JFBill=$o(^DHCPBi(0,"OEORI",JFoeOrdItem,JFBill)) q:(JFBill="")||(JFerr'=0)  d
	.s JFflag=$P(^DHCPB(JFBill),"^",17)
	.q:JFflag'=""
	.s JFOrder=0
	.f  s JFOrder=$o(^DHCPBi(0,"OEORI",JFoeOrdItem,JFBill,JFOrder)) q:(JFOrder="")||(JFerr'=0)  d
	..s JFDetails=0
	..f  s JFDetails=$o(^DHCPB(JFBill,"O",JFOrder,"D",JFDetails)) q:(JFDetails="")||(JFerr'=0)  d
	...s JFerr=##class(web.DHCIPBillPBDOManage).copyDetailsByItem(JFBill,JFOrder,JFDetails, "OC")
	...i JFerr='0 q
	;i JFerr'=0 TROLLBACK  q JFerr
	;d ..tc()  ; yyx 注释
	q JFerr
}

/// 描述:     删除前，先把pbd表中的数据放到pbdetailsold表中,OC表示orderChange
/// 编写者:   汪会财
/// 编写日期: 2009-4-7
/// 入参:     PBPBO=PB||PBO
/// 其它:     ^TMPOEORI("OEORI",$j,PBPBO)的值为医嘱rowid ,其中PBPBO为PB||PBO,也就是记录帐单对应的医嘱
ClassMethod getTempGlobalOeOrdI(JFPBPBO)
{
	s JFBill=+JFPBPBO
	s JFOrder=$p(JFPBPBO,"||",2)
	s ^TMPOEORI("OEORI",$j,JFPBPBO)=$p(^DHCPB(JFBill,"O",JFOrder),"^",4)  //记录医嘱Rowid
	s JFerr=##class(web.DHCIPBillPBDOManage).createPBDOByOrder(JFBill,JFOrder,"OC")
	q
}

/// 描述:     生成新的pbd后拷贝pbd到pbdo表,清除global , OC表示orderChange
/// 编写者:   汪会财
/// 编写日期: 2009-4-7
/// 入参:     PBPBO=PB||PBO
ClassMethod closeTempGlobalOeOrdI(JFPBPBO)
{
	
	i $g(^TMPOEORI("OEORI",$j,JFPBPBO))'="" d
	.s JFerr=##class(web.DHCIPBillPBDOManage).copyByOeOrdItem(^TMPOEORI("OEORI",$j,JFPBPBO),"OC")
	.k ^TMPOEORI("OEORI",$j,JFPBPBO)
	;yyx 增加返回值
	q $g(JFerr)
}

/// 外面调用此函数,时间可改
ClassMethod OrderChangeInsertPBDOIF()
{
	s nowDate=+$h-1			
	s err= ..OrderChangeInsertPBDO(nowDate)   //OC   医嘱改变
	s err= ..InsertPBDO(nowDate)              //RB IB   重新帐单  中途结算
	q err
}

/// 描述:     通过^DHCIPBillDelDetailNew(+$h,PBDRowID)把数据写入PBDO中, OC表示orderChange
/// 编写者:   汪会财
/// 编写日期: 2009-9-28
/// 入参:     
/// 相关表:   DHC_PatBillDetailsOld
/// 其它 ：   此方法是定时调用的,用来复制一天的因医嘱改变而发生变化的DHC_PatBillDetails
/// [Previously private]
ClassMethod OrderChangeInsertPBDO(nowDate)
{
	new (nowDate)
	q:$d(^DHCIPBillDelDetailNew(nowDate,"Done"))'=0 0
	s JFPBDRowID=0,JFerr=0,JFOrdItemDrStr=""
	d ..tb()
	s JFPBDRowID=0
	f  s JFPBDRowID=$o(^DHCIPBillDelDetailNew(nowDate,JFPBDRowID)) q:(JFPBDRowID="")||(JFerr'=0)  d
	.;k ^DHCIPBillDelDetailNew(nowDate,JFPBDRowID,"Done")
	.q:$g(^DHCIPBillDelDetailNew(nowDate,JFPBDRowID,"Done"))'=""
	.s JFOrdItemDr=$p(^DHCIPBillDelDetailNew(nowDate,JFPBDRowID),"#",1)
	.s JFPBDData=$p(^DHCIPBillDelDetailNew(nowDate,JFPBDRowID),"#",2)
	.i $d(^DHCPB(+JFPBDRowID,"O",$p(JFPBDRowID,"||",2),"D",$p(JFPBDRowID,"||",3)))'=0 d
	..d ..initPLIST(JFPBDRowID,JFPBDData,"N","OC",JFOrdItemDr,^DHCIPBillDelDetail(nowDate,JFPBDRowID))
	.e  d
	..d ..initPLIST(JFPBDRowID,JFPBDData,"D","OC",JFOrdItemDr,^DHCIPBillDelDetail(nowDate,JFPBDRowID))
	.s JFOldRowid=0
	.f  s JFOldRowid=$o(^DHCPBDOi(0,"PatBillDetails",JFPBDRowID,JFOldRowid))  q:JFOldRowid=""  d
	..s JFFlag=$p($g(^DHCPBDO(JFOldRowid)),"^",5)
	..i JFFlag="N" s JFOldPBDORowid=JFOldRowid
	.i $g(^DHCPBDO(+$g(JFOldPBDORowid)))'="" d
    ..s:JFFlag="N" JFerr=##class(web.DHCIPBillPatBillDetailsOld).UPDATE(JFOldPBDORowid)    ;操作是第二次,则 PLIST 更新 把stutasFlag="N"改成"D"
    .e  d
    ..s JFerr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()          ;操作是第一次,插入一被删记录状态为stutasFlag="D"
	.i JFerr'=0 TROLLBACK  q
	.i $d(^DHCPB(+JFPBDRowID,"O",$p(JFPBDRowID,"||",2),"D",$p(JFPBDRowID,"||",3)))=0 d
	..s JFerr=##class(web.DHCIPBillPBDOManage).createPBDOStrike(nowDate)          ;写一笔红冲的记录
	.i JFerr'=0 TROLLBACK  q
	.//通过医嘱查找出新的DHC_PatBillDetais中的记录,并写入old表
	.s JFPBORowidNew=$p(^OEORD(+JFOrdItemDr,"I",$p(JFOrdItemDr,"||",2),1),"^",16) 
	.s JFerr=##class(web.DHCIPBillPBDOManage).copyDetailsByOrder(+JFPBORowidNew,$p(JFPBORowidNew,"||",2),"OC")
	.s ^DHCIPBillDelDetailNew(nowDate,JFPBDRowID,"Done")=$h  //明细置成已做
	.i JFerr'=0 TROLLBACK  q
	i JFerr=0 d ..tc() s ^DHCIPBillDelDetailNew(nowDate,"Done")=$h //置成已做
	;w "^DHCIPBillDelDetailNew("_nowDate_")    Done",!
	q JFerr
}

/// 记录标志="N" 或 "D"     //N  新生成的记录new   D 已删除的记录delete
/// 操作标志="RB" 或  "IB"      //RB 重新帐单       IB   中途结算 
/// oeordItemRowid 是User.OEOrdItem 的rowid
/// paadmRowid     是User.PAAdm的rowid
/// s ^DHCIPBillDetail(+$h,PBDRowID)=oeordItemRowid_"#"_^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub)_"#"_paadmRowid_"#"_记录标志_"#"_操作标志
/// 将^DHCIPBillDetail(+$h,PBDRowID)重新写入表
ClassMethod InsertPBDO(date)
{
	new (date)
	q:$d(^DHCIPBillDetail(date,"Done"))'=0 0
	s JFPBDRowID=0,JFerr=0
	d ..tb()
	s JFPBDRowID=0
	s JFerr=0
	f  s JFPBDRowID=$o(^DHCIPBillDetail(date,JFPBDRowID)) q:(JFPBDRowID="")||(JFerr'=0)  d
	.;k ^DHCIPBillDetail(date,JFPBDRowID,"Done")
	.q:$g(^DHCIPBillDetail(date,JFPBDRowID,"Done"))'=""
	.s JFOrdItemDr=$p(^DHCIPBillDetail(date,JFPBDRowID),"#",1)
	.s JFPBDData=$p(^DHCIPBillDetail(date,JFPBDRowID),"#",2)
	.s JFPaadmDR=$p(^DHCIPBillDetail(date,JFPBDRowID),"#",3)
	.s JFStutasFlag=$p(^DHCIPBillDetail(date,JFPBDRowID),"#",4)
	.s JFOperateFlag=$p(^DHCIPBillDetail(date,JFPBDRowID),"#",5)
	.d ..initPLIST(JFPBDRowID,JFPBDData,JFStutasFlag,JFOperateFlag,JFOrdItemDr,JFPaadmDR)
	
	.s JFOldRowid=0
	.s JFOldPBDORowid=0
	.f  s JFOldRowid=$o(^DHCPBDOi(0,"PatBillDetails",JFPBDRowID,JFOldRowid))  q:JFOldRowid=""  d
	..s JFFlag=$p($g(^DHCPBDO(JFOldRowid)),"^",5)
	..i JFFlag="N" s JFOldPBDORowid=JFOldRowid 
	.i $g(^DHCPBDO(+$g(JFOldPBDORowid)))'="" d
    ..s:JFFlag="N" JFerr=##class(web.DHCIPBillPatBillDetailsOld).UPDATE(JFOldPBDORowid)    ;操作是第二次,则 PLIST 更新 把stutasFlag="N"改成"D"
    .e  d
    ..s JFerr=##class(web.DHCIPBillPatBillDetailsOld).INSERT()          ;操作是第一次,插入一被删记录状态为stutasFlag="D"
	.i JFerr'=0 TROLLBACK  q
	.s:JFStutasFlag="D" JFerr=##class(web.DHCIPBillPBDOManage).createPBDOStrike(date)          ;如果是删除的写一笔红冲的记录
	.i JFerr'=0 TROLLBACK  q
	.i JFerr=0 s ^DHCIPBillDetail(date,JFPBDRowID,"Done")=$h  //明细置成已做
	.;w "^DHCIPBillDelDetailNew("_date_","_JFPBDRowID_") Done"
	i JFerr=0 d ..tc() s ^DHCIPBillDetail(date,"Done")=$h //置成已做
	;w "^DHCIPBillDelDetailNew("_date_")    Done",!
	q JFerr
}

ClassMethod test()
{
	;w ##class(web.DHBIPBillPBDOManage).test()
	;s stDate=$zdh("2009-12-8",3)
	;s endDate=$zdh("2009-12-8",3)
	s stDate=$zdh("2009-11-12",3)
	s endDate=$zdh("2009-12-9",3)
	s err=0
	f date=stDate:1:endDate q:err'=0  d
	.;k ^DHCIPBillDetail(date,"Done")
	.;k ^DHCIPBillDelDetailNew(date,"Done")
	.s nowDate=+$h			 
	.s err= ..OrderChangeInsertPBDO(date)   //OC   医嘱改变
	.q:err'=0
	.s err= ..InsertPBDO(date)              //RB IB   重新帐单  中途结算
	.q:err'=0
	q err
}

ClassMethod tb()
{
	TSTART
	q
}

ClassMethod tc()
{
	TCOMMIT
	q
}

}
