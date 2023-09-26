Import SQLUser

/// 基数药管理类 
Class web.DHCSTBASEDRUG Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:创建销售数据并生成库存转移请求单
/// Created By :ZHWH
/// Create Date:2010-12-09
/// Arguments:
///   dept - 基数药品科室
///   phaloc - 药房科室()
///   user - 操作人
///  w ##class(web.DHCSTBASEDRUG).CreateBaseDrugDispData("10","184","2022-01-28","00:00:00","2022-01-28","11:02:25","17399","BASEDRUG")
ClassMethod CreateBaseDrugDispData(dept As %String, phaloc As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, user As %String, ICCode As %String)
{
 n (dept,phaloc,startDate,startTime,endDate,endTime,user,ICCode)
 //查找出该科室的销售统计期间
 s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
 s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
 q:startDate>endDate "^"
 
 s startTime=$zth(startTime)
 s endTime=$zth(endTime)
 
 s frDate=startDate
 s toDate=endDate
 s frTime=startTime
 s toTime=endTime
 s reqtype=1  //缺省为基数药
 s ret=..TotalizeBaseDrugOfDept(dept,phaloc,frDate,frTime,toDate,toTime,ICCode,user)
 q:ret<0 ret  
 
 //生成请求单
 //
 s main=ret
 /*
 //检查本期统计是否存在正明细
 &sql(select count(*) into :rowcnt from dhc_basedrugdispitm where bddi_bdd_parref=:main)
 i +$G(rowcnt)=0 d
 .&sql(delete from dhc_basedrugdisp where bdd_rowid=:main)
 q:+$G(rowcnt)=0 -100 //没有明细记录时不执行后面的生成请求单的动作
 */ 
 s recloc=$P(^DHCBDD(main),"^",1)  //请求科室
 s reqloc=$P(^DHCBDD(main),"^",5)   //供应科室
 s stkcode="G"
 s prefixOfNo="RQ"_$G(stkcode)
 s status=""
 s reqRowid=##class(web.DHCSTTRREQ).InsReq(prefixOfNo, recloc, reqloc, user, status)
 q:reqRowid'>0 -1
 s errInfo=""
 i reqRowid>0 d
 .s reqtype=..RqType(ICCode)
 .d ##class(web.DHCSTTRREQ).SetReqType(reqRowid,reqtype) //表示"基数补货"
 .&sql(update DHC_BaseDrugDisp set BDD_INRQ_DR=:reqRowid where BDD_RowId=:main)
 .s ch=0
 .f  s ch=$O(^DHCBDD(main,"I",ch)) q:ch=""  d
 ..s bddi=main_"||"_ch
 ..s inci=$P(^DHCBDD(main,"I",ch),"^",1)
 ..s incDesc=$P($g(^INCI(inci,1)),"^",2)
 ..//供应科室没有的项目不加到请求单 zhwh 2011-08-24
 ..s reqLocInc=$o(^INCI("IL_LOC",reqloc,inci,""))
 ..i reqLocInc="" d
 ...i errInfo="" s errInfo="供给科室无该药品目录:"_incDesc
 ...e  s errInfo=errInfo_"</br>"_"供给科室无该药品目录:"_incDesc
 ..q:reqLocInc=""   
 ..; kww 20121011 add 如果是不可用状态的药品就不出现在请求单里面
 ..s notUseFlag=$P($g(^INCI(inci,2)),"^",9)
 ..q:notUseFlag="Y"
 ..; kww 20121011 end
 ..s qty=..GetRestQty(bddi)  //
 ..i (ICCode'="JSDM")&&(+qty'>0) d
 ...i errInfo="" s errInfo="可用库存足够:"_incDesc
 ...e  s errInfo=errInfo_"</br>"_"可用库存足够:"_incDesc
 ..q:(ICCode'="JSDM")&&(+qty'>0)   //数量为负值时不生成请求明细 zhwh 2011-08-29
 ..q:qty<=0
 ..s buom=$P(^INCI(inci,1),"^",10)
 ..s ret=##class(web.DHCSTTRREQ).InsReqItm(reqRowid,inci,buom,qty,user)
 ..i ret=0 d
 ...s reqi=%ROWID  
 ...&sql(update DHC_BaseDrugDispItm Set BDDI_ReqQty=:qty,BDDI_ReqItm=:reqi where BDDI_RowId=:bddi)
 ...
 //判断是否存在明细
 s itmCount=0
 &SQL(SELECT count(*) INTO :itmCount FROM IN_ReqItm where INRQI_INRQ_ParRef=:reqRowid)
 i itmCount=0 d
 .d ..DelBddReq(reqRowid)
 q:itmCount=0 -1002_"^"_errInfo
 //JSDM补货申请单自动置为"完成"状态
 s completed="Y" 
 i ($G(reqRowid)>0)&($G(reqtype)=2) &sql(update in_request set inrq_usercompleted=:completed where inrq_rowid=:reqRowid)
 q reqRowid_"^"_main
}

/// Description: 生成科室基数药品的销售汇总,汇总后的数据保存到 DHC_BaseDrugDisp,DHC_BaseDrugDispItm
/// CreatedBy:zhwh
/// Create Date:2010-12-11
/// Arguments:
///   dept - 病区或科室等
///   frDate  -起始日期
///   toDate - 截止时间
///   ICCode - 基数药医嘱子类(目前通过该医嘱子类界定基数药品)
///   user - 操作人
/// ReturnValue:
///  >0 - 基数药销售主表rowid
///  <0 - 生成失败
ClassMethod TotalizeBaseDrugOfDept(dept As %String, phaloc As %String, frDate As %String, frTime As %String, toDate As %String, toTime As %String, ICCode As %String, user As %String) As %String
{
 s npid=##class(web.DHCSTPCHCOLLS).NewPid()
 s RQTP=..RqType(ICCode) 
 s last=..GetLast(dept,RQTP)  //上次统计
 i (last'="")&(ICCode'="JSDM")&(ICCode'="DSY") q:..IfBddHandled(last)<2 -9   //上次统计未处理则退出 zhwh 2010-12-30
 
 //w last,!
 
 //统计基数发药
 s dspType(1)="P"
 s dspType(2)="Y"
 s dspType(3)="F"
 s dspType(4)="H"
 //s dspType(5)="S"  //非正常发药
 //s dspType(6)="Z"
 
 s cnt=$o(dspType(""),-1)
 f nn=1:1:cnt d
 .s trType=dspType(nn)
 .f d=frDate:1:toDate d
 ..s intr=""
 ..f  s intr=$O(^DHCINTR(0,"LOCTYPEDATE",dept,trType,d,intr)) q:intr=""  d
 ...s tt=$P(^DHCINTR(intr),"^",3)
 ...i d=frDate q:tt<frTime  //按时间过滤
 ...i d=toDate q:tt>toTime  //按时间过滤
 ...s pointer=$p(^DHCINTR(intr),"^",9)
 ...
 ...s oeori=..GetOeori(trType,pointer)
 ...q:+oeori=0
 ...s recDep=$p($G(^OEORD(+oeori,"I",$P(oeori,"||",2),3)),"^",6)
 ...i ICCode="JSDM" q:..IfJSDM(oeori)=0
 ...i ICCode="DSY" q:..IfDSY(oeori)=0
 ...i ICCode="BASEDRUG" q:..IfBaseDrug(oeori)=0	// yunhaibao20180808
 ...i ICCode="BASEDRUG",..IfDocLoc(recDep)=0 q:..IfBaseDrug(oeori)=0
 ...//医生科室对基数药的特殊处理("JSDM"和"DSY"之外的都算"BASEDRUG")
 ...i ICCode="BASEDRUG",..IfDocLoc(recDep)=1 q:(..IfJSDM(oeori)=1)!(..IfDSY(oeori)=1)
 ...s inclb=$p(^DHCINTR(intr),"^",7)
 ...q:$o(^INCI("IL_LOC",phaloc,+inclb,""))=""   
 ...s inci=+inclb
 ...s qty=$p(^DHCINTR(intr),"^",6)
 ...s uom=$p(^DHCINTR(intr),"^",10)
 ...s buom=$P(^INCI(inci,1),"^",10)
 ...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
 ...s qty=qty*fac
 ...s qty=-qty
 ...i '$d(^TMP("DHCPHA",npid,inci)) d
 ....s ^TMP("DHCPHA",npid,inci)=qty_"^"_"0"
 ...e  d
 ....s $p(^TMP("DHCPHA",npid,inci),"^",1)=$p(^TMP("DHCPHA",npid,inci),"^",1)+qty
 ...i '$d(^TMP("DHCPHA",npid,inci,oeori)) d
 ....s ^TMP("DHCPHA",npid,inci,oeori)=qty
 ...e  d
 ....s ^TMP("DHCPHA",npid,inci,oeori)=^TMP("DHCPHA",npid,inci,oeori)+qty
 ...   
 ...  
 ...  
 //统计上次补货余量
 s inci=""
 f  s inci=$O(^TMP("DHCPHA",npid,inci)) q:inci=""  d
 .q:'$d(^INCI("IL_LOC",phaloc,+inci))
 .s restQty=..GetLastTimeRestQty(last,inci,dept)
 .s $p(^TMP("DHCPHA",npid,inci),"^",2)=restQty
 //统计上期存在补货余量的药品
 i last>0 d
 . &sql(declare rest cursor for select bddi_inci_dr,bddi_restqty From dhc_basedrugdispitm where bddi_bdd_parref=:last and nvl(bddi_restqty,0)<>0 )
 .
 .&sql(open rest)
 .f  &sql(fetch rest into :inci,:qty) q:SQLCODE  d
 ..s inci=+inci
 ..i ICCode="JSDM" q:..IfJSDMByInc(inci)=0
 ..i ICCode="DSY" q:..IfDSYByInc(inci)=0
 ..i ICCode="BASEDRUG" q:..IfBaseDrugByInc(inci)=0	
 ..q:$o(^INCI("IL_LOC",phaloc,+inci,""))=""
 ..i '$d(^TMP("DHCPHA",npid,inci)) s ^TMP("DHCPHA",npid,inci)=0_"^"_qty
 .&sql(close rest)  
 s main=0
 i $o(^TMP("DHCPHA",npid,""))>0 d   //说明存在数据
 .s main=..InsBaseDrugMain(user,frDate,frTime,toDate,toTime,dept,phaloc,RQTP)
 q:main=0 -1001 //无可用数据
 q:main<0 -1  //没有生成统计数据
 s inci=""
 s ret=0
 f  s inci=$o(^TMP("DHCPHA",npid,inci)) q:(inci="")!(ret>0)  d
 .q:'$d(^TMP("DHCPHA",npid,inci))
 .s dispqty=$P(^TMP("DHCPHA",npid,inci),"^",1)
 .k PLIST
 .s PLIST(0)=main
 .s PLIST(1)=""
 .//s PLIST(2)=""
 .s PLIST(3)=inci
 .s PLIST(4)=+dispqty
 .s PLIST(5)=""
 .s PLIST(6)=""
 .s PLIST(8)=dept  ;loc
 .s PLIST(9)=$P(^TMP("DHCPHA",npid,inci),"^",2)  //..GetLastTimeRestQty(last,inci,dept)  ;last time rest qty
 .s PLIST(10)=0  ;clear qty
 .
 .&sql(insert into DHC_BaseDrugDispItm values  :PLIST() )
 .i SQLCODE'=0 s ret=1 q
 .
 .s bddi=%ROWID
 .s oeori=""
 .f  s oeori=$o(^TMP("DHCPHA",npid,inci,oeori)) q:oeori=""  d
 ..q:'$d(^TMP("DHCPHA",npid,inci,oeori))
 ..s qty=$g(^TMP("DHCPHA",npid,inci,oeori))
 ..s ch=$O(^DHCBDD(+bddi,"I",$P(bddi,"||",2),"O",""),-1)+1
 ..&sql(insert into DHC_BaseDrugDispItmOrd(BDDIO_BDI_Parref,BDDIO_ChildSub,BDDIO_OEORI_DR,BDDIO_Qty)
     values (:bddi,:ch,:oeori,:qty))
 ..
 ..
 k ^TMP("DHCPHA",npid)
 q:ret>0 -2
 q main
}

/// Description: 根据库存项取医嘱子类Code
ClassMethod GetICCodeByInci(inci As %String) As %String
{
 n (inci)
 s arcim=$p(^INCI(inci,1),"^",3) 
 q:arcim="" ""
 &sql(select arcim_itemcat_dr->arcic_code into :ICCode from ARC_ItmMast where arcim_rowid=:arcim)
 q $G(ICCode)
}

/// Description: 插入基数药销售主表
ClassMethod InsBaseDrugMain(user As %String, frDate As %String, frTime As %String, toDate As %String, toTime As %String, loc As %String, phaloc As %String, RQTP As %String) As %String
{
 k PLIST
 s PLIST(1)=""
 s PLIST(2)=+$H
 s PLIST(3)=$p($H,",",2)
 s PLIST(4)=user
 s PLIST(5)=loc
 s PLIST(6)=phaloc
 s PLIST(7)=frDate
 s PLIST(8)=toDate
 s PLIST(9)=""
 s PLIST(10)=""
 s PLIST(11)=""
 s PLIST(12)=""
 s PLIST(14)=RQTP
 s PLIST(15)=$g(frTime)
 s PLIST(16)=$g(toTime)
 
 &sql(insert into DHC_BaseDrugDisp values :PLIST() )
 q:SQLCODE -1
 s rowid=$G(%ROWID)
 q rowid
}

/// Description:缺省补货科室
///  对于定义"医院"值与否的科室,加以区分.
ClassMethod GetConfigPhaLocDr(reqtype As %String, recloc As %String) As %String
{
 n (reqtype,recloc)
 s recloc=$g(recloc)
 s reqtype=$g(reqtype)
 
 s reclocHosp=""
 i recloc'="" s reclocHosp=$p($G(^CTLOC(+recloc)),"^",22)
 
 i reqtype="BASEDRUG" d
 . s locDesc=""
 . i reclocHosp>0 s locDesc=""
 . 
 i reqtype="JSDM" d
 .s locDesc=""
 .i reclocHosp>0 s locDesc=""
 .
 i reqtype="DSY" d
 .s locDesc=""
 .i reclocHosp>0 s locDesc=""
 
 i reqtype="" s locDesc=""
 q:locDesc=""
 &sql(select ctloc_rowid into :loc from ct_loc where ctloc_desc=:locDesc)
 q:SQLCODE ""
 q $G(locDesc)_"^"_$g(loc)
}

ClassMethod GetConfigICCode()
{
 q "JD01"
}

/// 是否基数药品(中山三院用)
ClassMethod IfBaseDrug(oeori As %String) As %String
{
 n (oeori)
 q:oeori="" 0
 s arcic=""
 &sql( select oeori_itmmast_dr->arcim_itemcat_dr->ARCIC_Desc into :arcic from oe_orditem where oeori_rowid=:oeori)
 i arcic [ "西药注射剂(基数药)" q 1
 q 0
}

/// 是否精神毒麻类(中山三院用)
ClassMethod IfJSDM(oeori As %String) As %String
{
 n (oeori)
 s arcic=""
 &sql( select oeori_itmmast_dr->arcim_itemcat_dr->ARCIC_Desc into :arcic from oe_orditem where oeori_rowid=:oeori)
 i arcic [ "麻醉药品(基数药)" q 1

 q 0
}

/// 是否大输液(中山三院用)
ClassMethod IfDSY(oeori As %String) As %String
{
 n (oeori)
 s arcic=""
 &sql( select oeori_itmmast_dr->arcim_itemcat_dr->ARCIC_Desc into :arcic from oe_orditem where oeori_rowid=:oeori)
 
 i arcic[ "大输液(基数药)" q 1
  q 0
}

/// 取一个科室的补货参考日期范围(起始日期\结束日期)
ClassMethod GetBaseDrugDispDateScope(dept As %String, ICCode As %String) As %String
{
 n (dept,ICCode)
 s RQTYPE=..RqType(ICCode)
 
 //zhwh 2011-01-15
 s frDate="",frTime="",toDate="",toTime=""
 i '$d(^DHCBDD(0,"LOCRQTPTODATE",dept,RQTYPE)) d
 .i RQTYPE="3" d  //大输液
 ..s frDate=+$h-4
 ..s frTime=$zth("0:00:00")
 .e  d
 ..s frDate=$O(^DHCPHAC(0,"PHP",dept,"DATE",""))  //第1天销售(住院)
 ..s frTime=$zth("0:00:00")
 e  d
 .s last=..GetLast(dept,RQTYPE) 
 .i last'="" d
 ..s lastToDate=$p(^DHCBDD(last),"^",7)
 ..s lastToTime=$p(^DHCBDD(last),"^",15)
 ..
 ..s tmp=..GetNextSecondDateTime(lastToDate,lastToTime)
 ..s frDate=$p(tmp,"^",1)
 ..s frTime=$p(tmp,"^",2)
 s now=$h 
 i frDate="" s frDate=+now-5
 i frTime="" s frTime=$p(now,",",2)  //截止时间采用当前时间
 
 s toDate=+now    //截止日期采用当前日期
 s toTime=$p(now,",",2)  //截止时间采用当前时间
 
 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(frDate)_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(toDate)_"^"_$zt(frTime)_"^"_$zt(toTime)
}

Query DeptBaseDrug(bdd As %String) As %Query(ROWSPEC = "inci:%String,inciCode:%String,inciDesc:%String,uom:%String,dispQty:%Numeric,reqQty:%Numeric,reqitm:%String")
{
}

/// 
/// BDD : DHC_BaseDrugDisp
ClassMethod DeptBaseDrugExecute(ByRef qHandle As %Binary, bdd As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:bdd="" $$$OK
	
	s ch=0
	f   s ch=$o(^DHCBDD(bdd,"I",ch)) q:ch=""  d
	.s inci=$P(^DHCBDD(bdd,"I",ch),"^",1)
	.s dispQty=$P(^DHCBDD(bdd,"I",ch),"^",2)
	.s reqQty=$P(^DHCBDD(bdd,"I",ch),"^",3)
	.s reqItm=$P(^DHCBDD(bdd,"I",ch),"^",4)
	.s inciCode=$p(^INCI(inci,1),"^",1)
	.s inciDesc=$p(^INCI(inci,1),"^",2)
	.s buomDesc=""
	.s buom=$p(^INCI(inci,1),"^",10)
	.i buom'="" s buomDesc=$p(^CT("UOM",buom),"^",2)
	.d OutPutRow
	
	Quit $$$OK
OutPutRow
	set Data=$lb(inci,inciCode,inciDesc,buomDesc,dispQty,reqQty,reqItm)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod DeptBaseDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptBaseDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeptBaseDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptBaseDrugExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:取某科室某药品上次补货的剩余数
/// Arguments:
///     last - 上次统计rowid
ClassMethod GetLastTimeRestQty(last As %String, inci As %String, loc As %String) As %String
{
 n (last,inci,loc)
 s restQty=0
 q:last="" restQty
 q:inci="" restQty
 q:loc="" restQty
 s ch=$O(^DHCBDD(0,"INCI_LOC",inci,loc,last,"")) 
 q:ch="" 0
 s rowid=last_"||"_ch
 &sql(select bddi_restqty into :restQty From dhc_basedrugdispitm where bddi_rowid=:rowid)
 q $G(restQty)
}

/// 取上次汇总的rowid
ClassMethod GetLast(loc As %String, RQTYPE As %String) As %String
{
 n (loc,RQTYPE)
 s lastDate=$o(^DHCBDD(0,"LOCRQTPTODATE",loc,RQTYPE,""),-1) 
 q:lastDate="" ""
 s last=$o(^DHCBDD(0,"LOCRQTPTODATE",loc,RQTYPE,lastDate,""),-1) 
 q last
}

/// /Description: 更新转移申请在补货表中的请领数量
/// 需要在修改IN_ReqItm后执行此方法.
/// 
ClassMethod HandleReqItmQty(reqItm As %String) As %String
{
  n (reqItm)
  q:##class(web.DHCSTTRREQ).GetReqType(+reqItm)'>0 0
  s req=$p(reqItm,"||",1)
  s itm=$p(reqItm,"||",2)
  s qty=$P(^INRQ(req,"RQI",itm),"^",3)
  s uom=$P(^INRQ(req,"RQI",itm),"^",5)
  s inci=$P(^INRQ(req,"RQI",itm),"^",4)
  s buom=$p(^INCI(inci,1),"^",10)
  s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
  s reqQty=qty*fac
  s bdd=$o(^DHCBDD(0,"RQI",reqItm,"")) q:bdd="" 0
  s ch=$o(^DHCBDD(0,"RQI",reqItm,bdd,"")) q:ch="" 0
  s $p(^DHCBDD(bdd,"I",ch),"^",3)=reqQty
  q 0
}

/// Description:清除掉补货表中的请求单数据
/// 需要在删除IN_ReqItm前执行此方法
/// returnValue
///   0 -成功
///   <0 -失败
ClassMethod ClearReqItm(reqItm As %String) As %String
{
  n (reqItm)
  s req=$p(reqItm,"||",1)
  s itm=$p(reqItm,"||",2)
  q:##class(web.DHCSTTRREQ).GetReqType(req)'>0 0  //验证是否是"基数补货"请求
  s qty=$P(^INRQ(req,"RQI",itm),"^",3)
  s uom=$P(^INRQ(req,"RQI",itm),"^",5)
  s inci=$P(^INRQ(req,"RQI",itm),"^",4)
  s buom=$p(^INCI(inci,1),"^",10)
  s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
  s reqQty=qty*fac //请求数量(基本单位)
  //
  s bdd=$o(^DHCBDD(0,"RQI",reqItm,"")) q:bdd="" 0
  s ch=$o(^DHCBDD(0,"RQI",reqItm,bdd,"")) q:ch="" 0
  s bddi=bdd_"||"_ch
  &sql(Update DHC_BaseDrugDispItm set BDDI_ReqItm=null,BDDI_ReqQty=0 WHERE BDDI_RowId=:bddi)
  q SQLCODE
}

/// Description: 清除一个请求单整张单的补货记录信息
/// Arguments:
///    req  - 请求单rowid(IN_Request)
ClassMethod ClearAllReqItms(req As %String) As %String
{
 n (req)
 q:req="" 0
 s ch=0
 s ret=0
 i ##class(web.DHCSTTRREQ).GetReqType(req)>0 d
 .f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(ch=0)!(ret'=0)  d
 ..s reqi=req_"||"_ch
 ..s ret=..ClearReqItm(reqi)
 q:ret'=0 ret
 //更新基数发药汇总表的请求单DR为空
 s bdd=$O(^DHCBDD(0,"REQ",req,"")) 
 i bdd'="" &sql(update dhc_basedrugdisp set bdd_inrq_dr=null where bdd_rowid=:bdd)
 i SQLCODE'=0 s ret=-99
 q ret
}

/// 检查余量是否满足请求数量(此处控制请求数量不能大于余量)
/// return value:
///  0  -不满足
///  1 - 满足
ClassMethod CheckRepQtyByReqItm(reqItm As %String, qty As %String) As %String
{
 n (reqItm,qty)
 s ret=1
 s bdd=$o(^DHCBDD(0,"RQI",reqItm,"")) q:bdd="" ret
 s ch=$o(^DHCBDD(0,"RQI",reqItm,bdd,"")) q:ch="" ret
 i ##class(web.DHCSTTRREQ).GetReqType(+reqItm)>0 d
 .s bddi=bdd_"||"_ch
 .s restQty=0
 .&sql(select bddi_dispqty+bddi_lastrestqty-bddi_clearqty into :restQty from DHC_BaseDrugDispItm where bddi_rowid=:bddi)
 .i (qty>restQty) s ret=0
 q ret
}

/// 查找补货记录中的剩余数量
ClassMethod GetRestQty(bddi As %String) As %String
{
 n (bddi)
 s restQty=0
 i bddi'=""  &sql(select bddi_restqty into :restQty From dhc_basedrugdispitm where bddi_rowid=:bddi )
 q $g(restQty)
}

/// 取请求单号
ClassMethod GetReqNo(req) As %String
{
  n (req)
  q:req="" ""
  q $P($g(^INRQ(req)),"^",1)
  //q $tr($J(req,6)," ","0")
}

/// Description:判断是否上次基数药(以及毒麻等其他实行基数管理的药品)情况是否已经处理,
///    若未处理,不允许生成新的基数统计,注:  判断依据是BDD->REQ->INIT
/// Created By : zhwh
/// Create Date: 2010-12-29
/// RetValue :
///   0 - 未生成请求单
///   1 - 未生成库存转移单
///   2 - 已经生成库存转移单
ClassMethod IfBddHandled(bdd As %String) As %String
{
 n (bdd)
 &sql(select BDD_INRQ_DR into :req from DHC_BaseDrugDisp where bdd_rowid=:bdd)
 s req=$G(req)
 if $G(req)="" q 0   //没有产生请求单,可以继续请求？？？？？？ zhwh 2011-06-27
 s init=$O(^DHCINIT(0,"REQ",req,"")) //DHC_InIsTrf
 i init="" q 1
 q 2
}

/// 判断科室是否是职能科室
ClassMethod IfDocLoc(currLoc As %String) As %String
{
 n (currLoc)
 s ret=0
 //
 //s loclist(1)="NSKEBQ-内三科二病区"
 //s loclist(1)="SSMZZX-手术麻醉中心"
 //s loclist(2)="JRDGS-介入导管室"
 //s loclist(3)="NJZX-内镜中心"
 ///s loclist(4)="FSK-放射科"
 //s loclist(5)="HYXK-核医学科"
 //s loclist(6)="CSK-超声科"
 //s loclist(7)="LGSSS-手术室[萝岗]"
 //s loclist(8)="LGCSK-超声科[萝岗]"
 //s loclist(9)="LGJRDGS-介入导管室[萝岗]"
 //s loclist(10)="LGNJZX-内镜中心[萝岗]"
 //s loclist(11)="LGHYXK-核医学科[萝岗]"
 //s loclist(12)="LGFSK-放射科[萝岗]"
 //
 s locstr=##class(web.DHCSTPCHCOLLAUTO3).GetBaseDrugLocStr()
 //s cnt=$o(loclist(""),-1)
 s cnt=$l(locstr,"^")
 f ii=1:1:cnt d
 .//s loc=$G(loclist(ii))
 .s loc=$p(locstr,"^",ii)
 .q:loc=""
 .//s locdr=##Class(web.DHCSTCOMMONSRV).LocToRowID(loc)
 .//q:locdr=""
 .i currLoc=loc s ret=1
 q ret
}

/// 取下一秒后的日期和时间
ClassMethod GetNextSecondDateTime(dd, tt) As %String
{
 n (dd,tt)
 i tt=$zth("23:59:59") d
 .s nextDate=dd+1
 .s nextTime=0
 e   d
 .s nextDate=dd
 .s nextTime=tt+1
 q nextDate_"^"_nextTime
}

ClassMethod GetOeori(type As %String, pointer As %String) As %String
{
	n (type, pointer)
	s oeori=""
	i type="P" d
	.s pointer=$p(pointer,"||",1,2)
	.&sql(select phaci_oedis_dr into :oeori from dhc_phacollectitm where phaci_rowid=:pointer)
	i type="Y" d
	.s pointer=$p(pointer,"||",1,2)
	.&sql(select PHARI_OEDIS_DR into :oeori from DHC_PhaReturnItm where PHARI_Rowid=:pointer)
	i type="F" d
	.&sql(select phdic_phdi_parref->phdi_oeori_dr into :oeori from DHC_PHDISITMCLB where phdic_rowid=:pointer)
	i type="H" d
	.s pointer=$p(pointer,"||",1,2)
	.&sql(select phrti_oeori_dr into :oeori from dhc_phretitm where phrti_rowid=:pointer)
	q $G(oeori)
	/*
	i type="S" d
	.
	i type="Z" d
	.
	*/
}

/// 
/// Description:删除一个库存请求单(基数补货)
/// 
ClassMethod DelBddReq(req As %String) As %String
{
  //检查
  //
  q:req="" -10
  q:'$d(^INRQ(req)) -11
  s init=$o(^DHCINIT(0,"REQ",req,""))
  q:init'="" -9  //已转移
  s compeletd=$P(^INRQ(req),"^",8)
  q:compeletd="Y" -12  //已完成
  s bdd=$O(^DHCBDD(0,"REQ",req,""))
  q:bdd="" -1   
  
  tstart
  &sql(delete from dhc_basedrugdisp where bdd_rowid=:bdd)
  s ret=SQLCODE
  i ret'=0 trollback
  q:ret'=0 -2
  
  s dhcinrq=$O(^DHCINRQ(0,"INRQ",req,""))
  i dhcinrq'=""  d
  .&sql(delete from dhc_inrequest where inrq_rowid=:dhcinrq)
  .s ret=SQLCODE
  .i ret'=0 trollback
  q:ret'=0 -3
  
  &sql(delete from in_request where inrq_rowid=:req)
  s ret=SQLCODE
  i ret'=0 trollback
  q:ret'=0 -4
  tcommit
  q 0
}

/// 是否为排除的项目:1、被供应科室加锁、排除、或供应科室不存在的项目
ClassMethod Exclude(inci As %String, provLoc As %String) As %String
{
  s ch=$o(^INCI("IL_LOC",provLoc,inci,""))
  q:ch'>0 1  //不存在的项目

  s lock="",excluded=""
  &sql( select incil_lockflag,incil_incil_dr->incil_freestorageBin
      into :lock,:excluded From dhc_incitmloc
    where incil_incil_dr->incil_ctloc_dr=:provLoc
    and incil_incil_dr->incil_inci_parref=:inci )
  
  //q:lock="Y" 2  //加锁
  q:excluded>0 3
  q 0
}

ClassMethod RqType(code As %String) As %String
{
 n (code)
 s reqtype=""
 i code="JSDM" s reqtype=2
 i code="BASEDRUG" s reqtype=1
 i code="DSY" s reqtype=3
 q reqtype
}

ClassMethod IfBaseDrugByInc(incId As %String) As %String
{
 n (incId)
 q:incId="" 0
 s arcic=""
 &sql(SELECT INCI_ARCIM_DR->arcim_itemcat_dr->ARCIC_Desc into :arcic FROM INC_Itm WHERE INCI_RowId=:incId)
 i arcic [ "西药注射剂(基数药)" q 1
 q 0
}

ClassMethod IfJSDMByInc(incId As %String) As %String
{
 n (incId)
 s arcic=""
 &sql(SELECT INCI_ARCIM_DR->arcim_itemcat_dr->ARCIC_Desc into :arcic FROM INC_Itm WHERE INCI_RowId=:incId)
 i arcic [ "麻醉药品(基数药)" q 1

 q 0
}

ClassMethod IfDSYByInc(incId As %String) As %String
{
 n (incId)
 s arcic=""
 &sql(SELECT INCI_ARCIM_DR->arcim_itemcat_dr->ARCIC_Desc into :arcic FROM INC_Itm WHERE INCI_RowId=:incId)
 
 i arcic[ "大输液(基数药)" q 1
  q 0
}

/// w ##class(web.DHCSTBASEDRUG).ArrayTest()
ClassMethod ArrayTest()
{
	s sui(123,456)=""
	b //
}

}
