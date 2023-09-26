Import SQLUser

Class web.DHCSTTRREQ Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsReqItm(reqrowid As %String, inci As %String, ctuom As %String, qty As %String, user As %String) As %String
{
 k PLIST
 f i=0:1:13 s PLIST(i)=""
 n ch  //zhwh 2012-03-28
 s ch=$o(^INRQ(reqrowid,"RQI",""),-1)+1
 ;
 s PLIST(0)=reqrowid
 s PLIST(4)=+inci
 s PLIST(5)=+qty
 s PLIST(7)=+ch
 s PLIST(12)=ctuom
 s PLIST(10)=+$h
 &sql(insert into in_reqitm values :PLIST() ) ;
 q SQLCODE
}

ClassMethod DelReqItm(reqitmrowid As %String) As %String
{
 s req=+reqitmrowid
 i $p(^INRQ(req),"^",8)="Y" q 0
 //
 s reqType=..GetReqType(+reqitmrowid)   
 s err=0
 i reqType>0 s err=##class(web.DHCSTBASEDRUG).ClearReqItm(reqitmrowid)  //清除补货记录 zhwh 2010.12.23
 i err'=0 q -1
 //
 &sql(delete from in_reqitm where inrqi_rowid=:reqitmrowid)
 q SQLCODE
}

ClassMethod DelReq(reqrowid As %String) As %String
{
 n (reqrowid)
 //
 s reqType=..GetReqType(reqrowid) 
 //i reqType>0 s err=##class(web.DHCSTBASEDRUG).ClearAllReqItms(reqrowid)   //清除整单的补货记录 zhwh 2010.12.23
 //
 s ret=0
 i (reqType>0)&($o(^DHCBDD(0,"REQ",reqrowid,""))>0) d
 . &sql(delete from dhc_basedrugdisp where BDD_INRQ_DR=:reqrowid )
 . i SQLCODE'=0 s ret=-1
 q:ret'=0 ret
 i $o(^DHCINRQ(0,"INRQ",reqrowid,""))>0 d
 . &sql(delete from DHC_INRequest where inrq_inrq_dr=:reqrowid)
 . i SQLCODE'=0 s ret=-2
 q:ret'=0 ret
 i $d(^INRQ(reqrowid)) d
 . &sql(delete from in_request where inrq_rowid=:reqrowid)
 . i SQLCODE'=0 s ret=-3
 . 
 q ret
}

ClassMethod InsReq(stkcode, recloc, reqloc, user, status, reqType = "")
{
 s no=..GetStreqNo(stkcode)
 s reqNo=##class(web.DHCST.Common.AppCommon).GetAppNo(##class(web.DHCST.INRequest).%GetParameter("AppName"),"",recloc)
 i reqNo'="" s no=reqNo
 s dd=+$h,tt=$p($h,",",2)
 s reqType=$G(reqType)   //zhwh  2011-08-14
 tstart
 &sql(insert into in_request(inrq_no,inrq_recloc_dr,inrq_reqloc_dr,inrq_ssusr_dr,inrq_date,inrq_time)
  values(:no,:recloc,:reqloc,:user,:dd,:tt) )
 s ret=SQLCODE
 i ret'=0  trollback
 q:ret'=0 -1
 s rowid=%ROWID
 i rowid'>0 trollback
 q:rowid'>0 -2
 &SQL(UPDATE IN_Request SET INRQ_No=:no WHERE INRQ_RowId=:rowid)
 &sql(insert into DHC_INRequest(inrq_inrq_dr,inrq_type) values (:rowid,:reqType) )
 s ret=SQLCODE
 i ret'=0  trollback
 q:ret'=0 -3
 tcommit
 q rowid
}

ClassMethod UpdReq(rowid As %String, frloc As %String, toloc As %String, complete As %String)
{
 &sql(update in_request set inrq_recloc_dr=:toloc,inrq_reqloc_dr=:frloc,inrq_usercompleted=:complete
   where inrq_rowid=:rowid)
   q SQLCODE
}

ClassMethod UpdReqItm(inrqi, qty) As %String
{
	n (inrqi, qty)
	s qty=+qty q:qty<0 -1
	;s uom=+uom q:uom<0 -2
	;s buom=$p(^INCI(inci,1),"^",10)
	;s puom=$p(^INCI(inci,3),"^",6)
	;q:(uom'=buom)&(uom'=puom) -3
	//
    s reqType=..GetReqType(+inrqi)
	i reqType>0 s err=##class(web.DHCSTBASEDRUG).CheckRepQtyByReqItm(inrqi,qty) q:err=0 -2 //是否允许更新 2010-12-23
    //	
	&sql(update in_reqitm set inrqi_reqqty=:qty	where inrqi_rowid=:inrqi)
   q:SQLCODE -4
   s err1=##class(web.DHCSTBASEDRUG).HandleReqItmQty(inrqi)
   q err1
}

ClassMethod GetStreqNo(prefix As %String) As %String
{
	n (prefix)
	s inno=""
	s head=..GetBillNoStream(prefix)
	&sql(select max(inrq_no) into :inno
	 from in_request where %ALPHAUP(inrq_no) %STARTSWITH :head)
	i inno="" s num=1
	e  d
	. s num=+$e(inno,$l(head)+1,$l(inno))+1
	s serialno=$tr($j(num,3)," ","0")
	s no=head_serialno
 	q no
}

Query ReqItmQuery(Rowid As %String) As %Query(ROWSPEC = "TReqItmRowid:%String,TCode:%String,TDesc:%String,TUom:%String,TQty:%String,TSp:%String,TStkQty:%String,TInciRowid:%String,TUomRowid:%String,TPackUOM:%String")
{
}

ClassMethod ReqItmQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReqItmQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReqItmQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReqItmQueryExecute ]
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

ClassMethod ReqItmQueryExecute(ByRef qHandle As %Binary, Rowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	i Rowid="" s qHandle=$lb(0,repid,0) q $$$OK
	//实现；
	s reqdate=$p(^INRQ(Rowid),"^",2)
	s tolocdr=$p(^INRQ(Rowid),"^",6)
	s HospID=$p($g(^CTLOC(tolocdr)),"^",22)
	s ch=0
	f  s ch=$o(^INRQ(Rowid,"RQI",ch)) q:ch=""  d
	. d resetvariable
	. s inci=$p(^(ch),"^",4)
	. q:inci=""
	. s uom=$p(^(ch),"^",5)
	. 
	. s reqqty=$p(^(ch),"^",3)
	. s incicode=$p(^INCI(inci,1),"^",1)
	. s incidesc=$p(^INCI(inci,1),"^",2)
	. i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2)
	. //s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,reqdate,uom)
	. s sp=##Class(web.DHCSTPRICE).GetSp(inci,reqdate,uom,HospID,"","")
	. s stkqty=##class(web.DHCSTSTKQTY).IL(inci,tolocdr,+$h)
	. s inrqi=Rowid_"||"_ch
	. s TPackUOM=..GetPU(inci)  //zhwh 2011-08-11
	. d OutputRow2
	
	Quit $$$OK
OutputRow2
	s TReqItmRowid=inrqi
	s TCode=incicode
	s TDesc=incidesc
	s TUom=$g(uomdesc)
	s TQty=reqqty
	s TSp=sp
	s TStkQty=stkqty
	s TInciRowid=inci
	s TUomRowid=uom
	s TPackUOM=TPackUOM
 	s Data=$lb(TReqItmRowid,TCode,TDesc,TUom,TQty,TSp,TStkQty,TInciRowid,TUomRowid,TPackUOM)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
resetvariable
	s (inrqi,incicode,incidesc,uomdesc,reqqty,sp,stkqty,inci,uom)=""
	q
}

ClassMethod GetItmUom(inci As %String) As %String
{
	&sql(select inci_ctuom_dr, inci_ctuom_dr->ctuom_desc,
	inci_ctuom_purch_dr,inci_ctuom_purch_dr->ctuom_desc
	 into :uom,:uomdesc,:puom,:puomdesc from inc_itm where inci_rowid=:inci)
	q:SQLCODE ""
	q uom_"^"_uomdesc_"^"_puom_"^"_puomdesc
}

Query MainQuery(StartDate As %String, EndDate As %String, FrLocDR As %String, ToLocDR As %String, Grp As %String) As %Query(ROWSPEC = "TReqRowid:%String,TReqNo:%String,TFromLoc:%String,TToLoc:%String,TReqUser:%String,TDate:%String,TTime:%String,TComp:%String,TReqType:%String,TFrDate:%String,TToDate:%String,TPrintFlag:%String,TCollUserName:%String,TCollDate:%String,TCollTime:%String,TDispUserName:%String,TDispDate:%String,TDispTime:%String,TPrtDate:%String,TPrtTime:%String")
{
}

ClassMethod MainQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MainQueryExecute ]
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

ClassMethod MainQueryExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, FrLocDR As %String, ToLocDR As %String, Grp As %String) As %Status
{

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	;
	;
	f dd=StartDate:1:EndDate d
	.s req=""
	.f  s req=$o(^INRQ(0,"Date",dd,req)) q:req=""  d
	..s frloc=$p(^INRQ(req),"^",5)
	..s toloc=$p(^INRQ(req),"^",6)
	..q:toloc=""
	..q:Grp=""
	..//q:..GrpStkLoc(Grp,toloc)=0
	..q:(FrLocDR'="")&(frloc'=FrLocDR)
	..q:(ToLocDR'="")&(toloc'=ToLocDR)
	..s frloc=$p(^CTLOC(frloc),"^",2)
	..s toloc=$p(^CTLOC(toloc),"^",2)
	..s frloc=##class(web.DHCSTKUTIL).noPrefix(frloc,"-")
	..s toloc=##class(web.DHCSTKUTIL).noPrefix(toloc,"-")
	..
	..s date=$p(^INRQ(req),"^",2)
	..i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
	..s time=$p(^INRQ(req),"^",3)
	..i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"IP")
	..s user=$p(^INRQ(req),"^",4)
	..i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
	..s comp=$p(^INRQ(req),"^",8)
	..s no=$p(^INRQ(req),"^",1)
	..
	..s reqType=..GetReqType(req)
	..i reqType="1" s reqType="基数补货"
	..i reqType="2" s reqType="精神毒麻补货"
	..i reqType="3" s reqType="大输液补货"
	..s bdds=..GetBDD(req)
	..s frDate=$p(bdds,"^",1)
	..s toDate=$p(bdds,"^",2)
	..s frTime=$p(bdds,"^",3)
	..s toTime=$p(bdds,"^",4)
	..i frDate="" s frDate=date
	..i toDate="" s toDate=date
	..i frTime="" s frTime=time
	..i toTime="" s toTime=time
	..s frDate=frDate_" "_frTime
	..s toDate=toDate_" "_toTime
	..
	..s dreqInfo=..GetDHCReq(req)
	..//s reqType=$p(dreqInfo,"^",1)
	..s printFlag=$p(dreqInfo,"^",2)
	..i printFlag>0 s printFlag="是" e  s printFlag="否"
	..s collUserName=$p(dreqInfo,"^",3)
	..s collDate=$p(dreqInfo,"^",4)
	..s collTime=$p(dreqInfo,"^",5)
	..s dispUserName=$p(dreqInfo,"^",6)
	..s dispUserDate=$p(dreqInfo,"^",7)
	..s dispUserTime=$p(dreqInfo,"^",8)
	..s prtDate=$p(dreqInfo,"^",9)
	..s prtTime=$p(dreqInfo,"^",10)
	..
	..
	..d outputrow
	..

	q $$$OK
outputrow	
	s TReqRowid=req
	s TReqNo=no
	s TFromLoc=frloc
	s TToLoc=toloc
	s TReqUser=user
	s TDate=date
	s TTime=time
	s TComp=comp
	s TReqType=reqType
	
	s TPrintFlag=printFlag
	s TCollUserName=collUserName
	s TCollDate=collDate
	s TCollTime=collTime
	s TDispUserName=dispUserName
	s TDispDate=dispUserDate
	s TDispTime=dispUserTime
	s TPrtDate=prtDate
	s TPrtTime=prtTime
	;
 	s Data=$lb(TReqRowid,TReqNo,TFromLoc,TToLoc,TReqUser,TDate,TTime,TComp,TReqType,frDate,toDate,TPrintFlag,TCollUserName,TCollDate,TCollTime,TDispUserName,TDispDate,TDispTime,TPrtDate,TPrtTime)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod MainQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MainQueryExecute ]
{
	
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ReqCollQuery(StartDate As %String, EndDate As %String, FrLocDR As %String, ToLocDR As %String, Grp As %String, CollFlag As %String, IncludeOperated As %String, IncludeDispensed As %String) As %Query(ROWSPEC = "TReqRowid:%String,TReqNo:%String,TFromLoc:%String,TToLoc:%String,TReqUser:%String,TDate:%String,TTime:%String,TComp:%String,TReqType:%String,TCollectUser:%String,TCollectDate:%String,TCollectTime:%String,TDispUser:%String,TDispDate:%String,TDispTime:%String,TPrintFlag:%String,TReqStartDate:%String,TReqEndDate:%String,TPrtDate:%String,TPrtTime:%String")
{
}

ClassMethod ReqCollQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReqCollQueryExecute ]
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

ClassMethod ReqCollQueryExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, FrLocDR As %String, ToLocDR As %String, Grp As %String, CollFlag As %String, IncludeOperated As %String, IncludeDispensed As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	;
	;
	;s ^TMP("zhwh",1000)=StartDate_","_EndDate_","_FrLocDR_","_ToLocDR_","_Grp_","_CollFlag_","_IncludeOperated_","_IncludeDispensed
	i IncludeOperated="on" s IncludeOperated="1"
	i IncludeDispensed="on" s IncludeDispensed="1"
	f dd=StartDate:1:EndDate d
	.s req=""
	.f  s req=$o(^INRQ(0,"Date",dd,req)) q:req=""  d
	..s frloc=$p(^INRQ(req),"^",5)
	..s toloc=$p(^INRQ(req),"^",6)
	..q:toloc=""
	..q:Grp=""
	..//q:..GrpStkLoc(Grp,toloc)=0
	..q:(FrLocDR'="")&(frloc'=FrLocDR)
	..q:(ToLocDR'="")&(toloc'=ToLocDR)
	..s frloc=$p(^CTLOC(frloc),"^",2)
	..s toloc=$p(^CTLOC(toloc),"^",2)
	..s date=$p(^INRQ(req),"^",2)
	..i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
	..s time=$p(^INRQ(req),"^",3)
	..i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"IP")
	..s user=$p(^INRQ(req),"^",4)
	..i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
	..s comp=$p(^INRQ(req),"^",8)
	..q:comp'="Y"  //未"完成"的请求单
	..s no=$p(^INRQ(req),"^",1)
	..s reqType=..GetReqType(req)
	..q:(reqType="C")||(reqType="O") 
	..q:reqType=""   //zhwh 11-07-20 无请求单类型的不予显示
	..i reqType="3" q  //大输液补货的请求不予显示  zhwh 2011-10-21
	..i reqType="1" s reqType="基数补货"
	..i reqType="2" s reqType="精神毒麻补货"
	..i reqType="3" s reqType="大输液补货"
	..q:$$ChkCondition(CollFlag,req,IncludeOperated,IncludeDispensed)<0  //配药或发药检查条件,根据CollFlag
	..s dinrq=$o(^DHCINRQ(0,"INRQ",req,""))
	..s printflag="",collUser="",collDate="",collTime="",dispUser="",dispDate="",dispTime=""
	..s frDate="",toDate="",frTime="",toTime=""
	..s prtDate="",prtTime=""  //zhwh 2011-11-01
	..
	..i dinrq'="" s printflag=$p($G(^DHCINRQ(dinrq)),"^",2)
	..i dinrq'="" s collUser=$p($G(^DHCINRQ(dinrq)),"^",5)
	..i collUser'="" s collUser=$P(^SSU("SSUSR",collUser),"^",2)
	..i dinrq'="" s collDate=$p($G(^DHCINRQ(dinrq)),"^",3)
	..i collDate'="" s collDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collDate)
	..i dinrq'="" s collTime=$p($G(^DHCINRQ(dinrq)),"^",4)
	..i collTime'="" s collTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collTime,"IP")
	..i dinrq'="" s dispUser=$p($G(^DHCINRQ(dinrq)),"^",8)
	..i dispUser'="" s dispUser=$P(^SSU("SSUSR",dispUser),"^",2)
	..i dinrq'="" s dispDate=$p($G(^DHCINRQ(dinrq)),"^",6)
	..i dispDate'="" s dispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dispDate)
	..i dinrq'="" s dispTime=$p($G(^DHCINRQ(dinrq)),"^",7)
	..i dispTime'="" s dispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(dispTime,"IP")
	..//zhwh 2011-11-01 增加打印日期时间
	..i dinrq'="" s prtDate=$p($G(^DHCINRQ(dinrq)),"^",22)  
	..i prtDate'="" s prtDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtDate)
	..i dinrq'="" s prtTime=$p($G(^DHCINRQ(dinrq)),"^",23)
	..i prtTime'="" s prtTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(prtTime,"IP")    					
	..//zhwh 2011-11-01
	..s bdds=..GetBDD(req)
	..s frDate=$p(bdds,"^",1)
	..s toDate=$p(bdds,"^",2)
	..s frTime=$p(bdds,"^",3)
	..s toTime=$p(bdds,"^",4)
	..s frDate=frDate_" "_frTime
	..s toDate=toDate_" "_toTime
	..b //5
	..d outputrow1
	..

	q $$$OK
outputrow1	
	s TReqRowid=req
	s TReqNo=no
	s TFromLoc=frloc
	s TToLoc=toloc
	s TReqUser=user
	s TDate=date
	s TTime=time
	s TComp=comp
	s TReqType=reqType
	s TCollectUser=collUser
	s TCollectDate=collDate
	s TCollectTime=collTime
	s TDispUser=dispUser
	s TDispDate=dispDate
	s TDispTime=dispTime
	s TPrintFlag=""
	//i reqType="精神毒麻补货" d
	i printflag="1" s TPrintFlag="是"
	e  s TPrintFlag="否"
	;
 	s TReqStartDate=frDate
 	s TReqEndDate=toDate
 	s TPrtDate=prtDate  //zhwh 2011-11-01
 	s TPrtTime=prtTime //zhwh 2011-11-01
 	
 	s Data=$lb(TReqRowid,TReqNo,TFromLoc,TToLoc,TReqUser,TDate,TTime,TComp,TReqType,TCollectUser,TCollectDate,TCollectTime,TDispUser,TDispDate,TDispTime,TPrintFlag,TReqStartDate,TReqEndDate,TPrtDate,TPrtTime)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
ChkCondition(CollFlag,req,IncludeOperated,IncludeDispensed)
  //return value :
  // >0 - 符合条件
  // <=0 -不符合条件
   n (CollFlag,req,IncludeOperated,IncludeDispensed)
  s ret=0
  s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
  i dinrq="" s ret=-1  q ret
  s CollDate=$P(^DHCINRQ(dinrq),"^",3)
  s DispDate=$P(^DHCINRQ(dinrq),"^",6)
  
  i CollFlag="C" d
  .i CollDate>0 d
  ..i IncludeOperated="1" s ret=1
  ..e   s ret=-2
  .e  s ret=3
  
  i CollFlag="D" d
  .i CollDate="" s ret=-3 q
  .i DispDate>0 d
  ..i IncludeDispensed="1" s ret=4
  ..e  s ret=-4
  ..
  q ret
}

ClassMethod ReqCollQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReqCollQueryExecute ]
{
	
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetReqNo(reqrowid As %String) As %String
{
	&sql(select inrq_no into :no from in_request where inrq_rowid=:reqrowid)
 q:SQLCODE ""
 q $g(no)
}

ClassMethod GetReqInfo(rowid As %String) As %String
{
 k PLIST
 &sql(select * into :PLIST() from in_request where inrq_rowid=:rowid)
 q:SQLCODE ""
 s frloc=PLIST(9)
 i frloc'="" s frlocdesc=$p(^CTLOC(+frloc),"^",2)
 s toloc=PLIST(3)
 i toloc'="" s tolocdesc=$p(^CTLOC(+toloc),"^",2)
 s dd=PLIST(7)
 i dd'="" s dd=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd)
 s tt=PLIST(10)
 i tt'="" s tt=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tt,"IP")
 s user=PLIST(5)
 i user'="" s username=$P(^SSU("SSUSR",user),"^",2)
 s complete=PLIST(12)
 i complete="Y" s complete=1
 e   d
 . s complete=0
 s no=PLIST(2)
 s reqType=..GetReqType(+rowid)     //zhwh 2010-12-24
 i reqType="1" s reqType="基数补货"
 i reqType="2" s reqType="精神毒麻补货"
 i reqType="3" s reqType="大输液补货"
 s data=no_"^"_dd_"^"_tt_"^"_frloc_"^"_frlocdesc_"^"_toloc_"^"_tolocdesc_"^"_user_"^"_username_"^"_complete_"^"_reqType
 q data
}

Query ReqItmDisp(Rowid As %String) As %Query(ROWSPEC = "TRowid:%String,TCode:%String,TDesc:%String,TUomDesc:%String,TQty:%String,TSp:%String,TStkQty:%String,TSBOfReqLoc:%String,TPackUOM:%String,TQtyPackUOM:%String")
{
}

ClassMethod ReqItmDispExecute(ByRef qHandle As %Binary, Rowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;
 	q:Rowid="" $$$OK
	;
	q:'$d(^INRQ(Rowid)) $$$OK
	s reqdate=$p(^INRQ(Rowid),"^",2)
	s tolocdr=$p(^INRQ(Rowid),"^",6)
	s frLocDr=$p(^INRQ(Rowid),"^",5)
	s HospID=$p($g(^CLOC(tolocdr)),"^",22)
	s ch=0
	f  s ch=$o(^INRQ(Rowid,"RQI",ch)) q:ch=""  d
	. s inci=$p(^(ch),"^",4)
	. s uom=$p(^(ch),"^",5)
	. s reqqty=$p(^(ch),"^",3)
	. s incicode=$p(^INCI(inci,1),"^",1)
	. s incidesc=$p(^INCI(inci,1),"^",2)
	. i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2)
	. 
	. s PackUOM=..GetPU(inci)
	. s QtyPackUOM=""
	. //s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,reqdate,uom)
	. s sp=##Class(web.DHCSTPRICE).GetSp(inci,reqdate,uom,HospID,"","")
	. s stkqty=##class(web.DHCSTSTKQTY).IL(inci,tolocdr,+$h)
	
	. s inrqi=Rowid_"||"_ch
	. //s stkBin=..StkBin(inci,frLocDr)  //出货方的货位
	.//取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
    .s Chl=$o(^INCI("IL_LOC",frLocDr,inci,0))
    .s Incil=inci_"||"_Chl
    .s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(Incil,",","","") 
    .s stkbinstr=$p(stkbinret,":",2)
    .s stkBin=stkbinstr
	. d outputrowx
	q $$$OK
outputrowx
	s TRowid=inrqi
	s TCode=incicode
	s TDesc=incidesc
	s TUomDesc=uomdesc
	s TQty=reqqty
	s TSp=sp
	s TStkQty=stkqty
	s TSBOfReqLoc=stkBin
	;s ^wwjtempaa(inci)=TRowid_"^"_TCode_"^"_TDesc_"^"_TUomDesc_"^"_TQty_"^"_TSp_"^"_TStkQty_"^"_TSBOfReqLoc
 	s Data=$lb(TRowid,TCode,TDesc,TUomDesc,TQty,TSp,TStkQty,TSBOfReqLoc,PackUOM,QtyPackUOM)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod ReqItmDispFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReqItmDispExecute ]
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

ClassMethod ReqItmDispClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReqItmDispExecute ]
{
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GrpStkLoc(grp As %String, locdr As %String) As %String
{
	//return if the loc is in the list of stock locations
 n (grp,locdr)
 s grp=+grp
 s locdr=+locdr
 s childsub=$o(^SSU("SSGRP",grp,"ST",0,"Loc",locdr,""))
 q:childsub="" 0
 q 1
}

ClassMethod StkGrpList(stktype As %String) As %String
{
  n (stktype)
  s rowid=0
  s result=$g(result)
  f  s rowid=$o(^DHCSCG(rowid))	 q:+rowid<1  d
  . q:$p(^DHCSCG(rowid),"^",3)'=stktype
  . s tmp=$p(^DHCSCG(rowid),"^",1)_"-"_$p(^DHCSCG(rowid),"^",2)
  . i result="" s result=tmp
  . e  d
  . . s result=result_"^"_tmp
  q $g(result)
}

ClassMethod GetDateStream() As %String
{
}

ClassMethod GetBillNoStream(fix As %String) As %String
{
 n (fix)
 s datestr=$e($zd(+$h,8),3,8)
 s fix=fix_datestr
 s P0=fix
 q P0
}

/// 根据INCI和Loc取货位码
ClassMethod StkBin(inci As %String, locDr As %String) As %String
{
  n (inci,locDr)
  q:inci="" ""
  q:locDr="" ""
  s incilch=$o(^INCI("IL_LOC",locDr,inci,"")) q:incilch="" ""
  q ##class(web.DHCSTCOMMONSRV).getIncStk(inci_"||"_incilch)
}

ClassMethod GetReqType(req As %String) As %String
{
 n (req)
	s DHCINRQ=$O(^DHCINRQ(0,"INRQ",req,"")) 
	q:DHCINRQ="" ""
	q $p(^DHCINRQ(DHCINRQ),"^",1)
}

/// 设置请求单类型
ClassMethod SetReqType(req As %String, typeVal As %String) As %String
{
	n (req,typeVal)
	s dinrq=$O(^DHCINRQ(0,"INRQ",req,""))
	i dinrq="" d
	. &sql(insert into DHC_INRequest(INRQ_INRQ_DR,INRQ_Type) values (:req,:typeVal) )
	e  d
	.s $P(^DHCINRQ(dinrq),"^",1)=typeVal
  q 0
}

/// 请求单配药确认
ClassMethod SetReqCollect(req As %String, user As %String) As %String
{
   n (req,user)
   q:req="" -1
   //
   s dd=+$H
   s tt=$p($h,",",2)	
   s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
   i dinrq="" s dinrq=..InsDhcInrq(req)
   q:dinrq'>0 -3
   q:$p($g(^DHCINRQ(dinrq)),"^",3)'="" -4  //已经配药
   
   &sql(update dhc_inrequest set inrq_collectuser_dr=:user,inrq_collectdate=:dd,inrq_collecttime=:tt
      where inrq_rowid=:dinrq)
   q SQLCODE
}

/// 请求单发药确认
ClassMethod SetReqDisp(req As %String, user As %String) As %String
{
   n (req,user)
   q:req="" -1
   //
   s dd=+$H
   s tt=$p($h,",",2)	
   s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
   i dinrq="" s dinrq=..InsDhcInrq(req)
   q:dinrq'>0 -3
   q:$p($g(^DHCINRQ(dinrq)),"^",3)="" -4  //未配药
   q:$p($g(^DHCINRQ(dinrq)),"^",8)'="" -5  //已发药
   //
   &sql(update dhc_inrequest set inrq_dispuser_dr=:user,inrq_dispdate=:dd,inrq_disptime=:tt
      where inrq_rowid=:dinrq)
   q SQLCODE
}

/// 生成请求单附加表(DHC_INRequest)记录
ClassMethod InsDhcInrq(req As %String) As %String
{
  s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
  q:dinrq'="" dinrq
  &sql(insert into DHC_INRequest (INRQ_INRQ_DR) values (:req) )
  i SQLCODE'=0 q -1
  q %ROWID
}

/// Description : 根据请求单生成库存转移单
/// Created By :zhwh
/// Create Date :2010-12-26 
/// Arguments: 
///     req  -请求单rowid
///     user -操作者rowid
/// return value:
///     >0 - 成功(库存转移单主表rowid)
///     <0 - 失败
ClassMethod CreateTransfer(req As %String, user As %String) As %String
{
 q:req="" -1
 q:'$d(^INRQ(req)) -2

 //i ..ChkEnoughStk(req)'="" q -100 
 s frLoc=$p(^INRQ(req),"^",5)	
 s toLoc=$p(^INRQ(req),"^",6)	
 K PLIST
 f i=1:1:14 s PLIST(i)=""
 s PLIST(1)=+$h ;Trans Date
 s PLIST(2)=$p($h,",",2)      ;Trans Time
 s PLIST(3)=frLoc  //##class(web.DHCSTCOMMONSRV).LocToRowID(PLc)   ;ProvideL
 s PLIST(4)=toLoc //##class(web.DHCSTCOMMONSRV).LocToRowID(RLc)   ;RequestL
 s PLIST(5)=user  ;Operater ROWID
 s PLIST(6)="T"  ;INIT_Type
 s PLIST(7)="Y"   ;INIT_UserCompleted
 s PLIST(8)=""   ;INIT_Remarks
 s PLIST(9)=req
 s PLIST(10)="11"  ;INIT_State(10 no Complete?can't OutCheck)
 s PLIST(12)=""   //Remarks      ;INIT_OperationRemark
 s trno=##class(web.DHCSTCOMMONSRV).DHCGetSttrNo("A")
 s PLIST(11)=trno
 s ret=##class(web.DHCSTMVBSTTR).INSERT()
 s P9=$P($g(%ROWID),$char(1),1)
 //b
 //
 q:P9'>0 -10   //生成主表失败
 s IDM=P9  
 s hosp=##class(web.DHCSTCUSTOMER).GetCustomer()
 S HospID=##class(web.DHCSTLGST).GetHospIDByInit(IDM)
	
 s ret=0
 s ch=0 
 f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(ret<0)  d
 .s inci=$p(^INRQ(req,"RQI",ch),"^",4)
 .s uomdr=$p(^INRQ(req,"RQI",ch),"^",5)
 .s reqQty=$p(^INRQ(req,"RQI",ch),"^",3)
 .s incil=..GetINCIL(inci,frLoc)
 .i incil="" s ret=-11 q
 .
 .s err=0
 .tstart
 .s cnt=$$SelClbQty(incil,reqQty)
 .i cnt>0 d
 ..f i=1:1:cnt q:err>0  d
 ...s inclb=xINCLB(i)
 ...s qty=xQTY(i)
 ...
 ...k PLIST
 ...f xx=0:1:27 s PLIST(xx)=""
 ...s PLIST=27
 ...//s PLIST=$O(PLIST(""),-1)
 ...//s itmcode=$P(ListDetail,"^",1)
 ...//s qty=+$P(ListDetail,"^",2)
 ...//s uom=$P(ListDetail,"^",3)     ;uom
 ...//s ttype=$P(ListDetail,"^",4)   ;trans type
 ...s ttype="T"
 ...//s inclbrowid=$P(ListDetail,"^",5)  ;inclb rowid
 ...s inclbrowid=inclb
 ...//s aspflag=$p(ListDetail,"^",6) ;adjsp flag
 ...//s uomdr=##class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
 ...//s ss=itmcode_"^"_""_"^"_uom
 ...//s sp=+##class(web.DHCSTCOMMONSRV).GetItemSp(ss,HospID)
 ...//s sp=+##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$h,uomdr,HospID)
 ...s sp=##Class(web.DHCSTPRICE).GetSp(inclbrowid,+$h,uomdr,HospID,"","")
 ...s rp=##Class(web.DHCSTPRICE).GetRp(inclbrowid,+$h,uomdr,HospID,"")	//zhouyg 20150115
 ...s pricedata=##class(web.DHCSTPRICE).LastPrice(inclbrowid,uomdr)
 ...s pp=+$p(pricedata,"^",1)
 ...i pp=0 s pp=rp
 ...//s rp=+$p(pricedata,"^",2)
 ...s ppa=+(pp*qty)
 ...s rpa=+(rp*qty)
 ...s spa=+(sp*qty)
 ...s newsp=+##class(web.DHCSTCALSP).BatSpUom(inclbrowid,uomdr)
 ...s newspamt=+(newsp*qty) 
 ...i hosp="SG" d
 ....s ppa=+$fn(ppa,"",2)
 ....s rpa=+$fn(rpa,"",2)
 ....s spa=+$fn(spa,"",2)
 ....s newspamt=+$fn(newspamt,"",2)
 ...s PLIST(0)=IDM
 ...s PLIST(3)=$o(^DHCINIT(IDM,"ITI",""),-1)+1    ;2006-07-31
 ...s PLIST(5)=inclbrowid
 ...s PLIST(7)=qty
 ...s PLIST(14)=uomdr    ;UOM ROWID
 ...s PLIST(11)=ttype
 ...s PLIST(12)=sp
 ...//s PLIST(24)=aspflag
 ...s PLIST(17)=ppa
 ...s PLIST(18)=pp
 ...s PLIST(19)=rp
 ...s PLIST(20)=rpa
 ...s PLIST(21)=sp
 ...s PLIST(22)=spa
 ...s PLIST(27)="11"				;zdm,2009-3-31,库存转移明细增加状态字段
 ...//s result=##class(web.DHCSTMVBSTTRI).INSERT()
 ...
 ...&sql(Insert into DHC_InIstrfItm  values :PLIST())
 ...//b
 ...i SQLCODE'=0 s err=2 q
 ...//i result'=0 
 ...s rr=$g(%ROWID)
 ...i rr="" s err=3 q
 ...i rr'="" d 
 ....s buomdr=$p(^INCI(+inclbrowid,1),"^",10)
 ....s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 ....s bqty=+qty*fact
 ....s ret=##class(web.DHCSTLGST).UpInclbResQty(inclbrowid,bqty)
 ....&sql(update dhc_inistrfitm set dhciti_newsp=:newsp,dhciti_newspamt=:newspamt where initi_rowid=:rr)
 .
 .i err>0 s ret=-9 trollback  q 
 .
 .tcommit
 .
 q $G(IDM)
 
SelClbQty(incil, dspqty)
  ;按照发药数选择批次,PDELIM="!"
 n cnum,i,sumdqty,clbqty,k
 //l +^DHCINCIL(incil):10  e  q 0
 s cnum=$$GetClbQtyObExp(incil)
 i cnum=0  l -^DHCINCIL(incil) q 0  
 s k=0
 s sumdqty=0
 s clbqty=dspqty
 k xINCLB,xQTY
 f i=1:1:cnum q:clbqty'>0   d
 . i Eqty(i)'<clbqty d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=clbqty
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 . e  d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=Eqty(i)
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 i sumdqty<dspqty q 0  //当所查到的可发批次库存之和<发药总数量,不予发药 2008-07-16
 q k  
GetClbQtyObExp(incil) 
 ;INCLB按效期排序
 n num,tclb,tqty
 k CLB,Eqty 
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp)
 s num=0
 f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d                                                                            
 .;s tqty=$$CurQtyINCLB^DHCSTSTKQTY(tclb)
 .;s tqty=$$CuyInclbAvaQty^DHCSTSTKQTY(tclb,"")
 .i tqty>0 d
 ..s num=num+1
 ..s CLB(num)=tclb
 ..s Eqty(num)=tqty
 &sql(close CurrExp)
 q num
}

/// 检查库存是否足够
ClassMethod ChkEnoughStk(req As %String) As %String
{
 n (req)
 s ret=""
 i '$d(^INRQ(req)) s ret="请求单不存在!"
 q:ret'="" ret
 s frLoc=$p(^INRQ(req),"^",5)	
 s toLoc=$p(^INRQ(req),"^",6)	
 s ch=0
 ;s ^kww("sst",req)=req
 f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(ret'="")  d
 .s inci=$p(^INRQ(req,"RQI",ch),"^",4)
 .s inciDesc=$P(^INCI(inci,1),"^",2)
 .s uomdr=$p(^INRQ(req,"RQI",ch),"^",5)
 .s reqQty=$p(^INRQ(req,"RQI",ch),"^",3)
 .s buom=$p(^INCI(inci,1),"^",10)
 .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buom)
 .s reqQty=reqQty*fac
 .s incil=..GetINCIL(inci,frLoc)
 .i incil="" s ret="库存项目:< "_inciDesc_" > "_"库存不足!"  q
 .s result=##class(web.DHCSTSTKQTY).GetPhaQty(incil,reqQty)
 .i result=0 s ret="库存项目:< "_inciDesc_" > "_"库存不足!" q
 q ret
}

ClassMethod GetINCIL(inci, loc) As %String
{
 n (inci,loc)
 q:inci="" ""
 q:loc="" ""
 s ch=$O(^INCI("IL_LOC",loc,inci,0))
 q:ch="" ""
 q inci_"||"_ch
}

/// Description: 生成库存转移单并审核(outcheck & incheck )
/// Create By :zhwh
/// CReate Date : 2010-12-26
/// return :
///    "" - 成功
///    非""  -失败原因
ClassMethod CreateAndAuditOld(req As %String, user As %String) As %String
{
  n (req,user)
  //判断是否已经确认 zhwh,2012-10-12,start
  s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
  i dinrq>0 q:$p($g(^DHCINRQ(dinrq)),"^",3)'="" "已经配药!"  //已经配药 
  s result=..ChkEnoughStk(req)
  i result'="" q result
  s ret=..CreateTransfer(req,user)
  i ret<0 q "生成转移单失败!"
  s trRowid=ret
  s trno=$P(^DHCINIT(trRowid),"^",1)
  s outChk=##class(web.DHCSTOUTCHECK).TransOutCheck(trno,user,"21")
  i outChk'=0 q "出审核失败!"
  s inChk=##class(web.DHCSTINCHECK).TransInCheck(trno,user,"31")
  i inChk'=0 q "入审核失败!"
  q ""
}

/// last update by yunhaibao20161109,出库动作调用药库程序web.DHCST.DHCINIsTrf.cls
ClassMethod CreateAndAudit(req As %String, user As %String) As %String
{
  n (req,user)
  //判断是否已经确认 zhwh,2012-10-12,start
  s dinrq=$o(^DHCINRQ(0,"INRQ",req,"")) 
  i dinrq>0 q:$p($g(^DHCINRQ(dinrq)),"^",3)'="" "已经配药!"  //已经配药 
  s result=..ChkEnoughStk(req) //验证库存是否足够
  i result'="" q result
  s fromloc=$p(^INRQ(req),"^",5)	
  s toloc=$p(^INRQ(req),"^",6)	
  s reqinfo=fromloc_"^"_toloc_"^"_user
  s ret=##class(web.DHCST.DHCINIsTrf).CreateTransferByReq(reqinfo,req)
  i ret<0 q "生成转移单失败!"
  s trRowid=ret
  &SQL(UPDATE dhc_inistrf set init_usercompleted='Y',init_state=11 where %ID=:trRowid)
  s outChk=##class(web.DHCST.DHCINIsTrf).TransOutAuditYes(trRowid,user)
  i outChk'=0 q "出审核失败!"
  s inChk=##class(web.DHCST.DHCINIsTrf).TransInAuditYesPart(trRowid,user,"")
  i inChk'=0 q "入审核失败!"
  q ""
}

ClassMethod SaveReqCollUser(str, ip)
{
 q:ip="" -1
 s d=+$h
 f  s d=$o(^TMP("ZSSY_REQCOLLUSER",d),-1) q:d=""  d
 .k ^TMP("ZSSY_REQCOLLUSER",d)
 s ^TMP("ZSSY_REQCOLLUSER",+$h,ip)=str
 q 0
}

ClassMethod GetReqCollUser(ip)
{
 q:ip="" ""
 //s old=$ZNSPACE
  //ZNSPACE "%SYS"
  //s ret=##class(SYS.Process).%OpenId($JOB).ClientIPAddressGet()
 //zn old
 //s ^TMP("zhwh",10001)=ip
 
  q $g(^TMP("ZSSY_REQCOLLUSER",+$h,ip))
}

ClassMethod SaveReqDispUser(str, ip)
{
 q:ip="" -1
 s d=+$h
 f  s d=$o(^TMP("ZSSY_REQDISPUSER",d),-1) q:d=""  d
 .k ^TMP("ZSSY_REQDISPUSER",d)
 s ^TMP("ZSSY_REQDISPUSER",+$h,ip)=str
 q 0
}

ClassMethod GetReqDispUser(ip)
{
 q:ip="" ""
 //s old=$ZNSPACE
  //ZNSPACE "%SYS"
  //s ret=##class(SYS.Process).%OpenId($JOB).ClientIPAddressGet()
 //zn old
 //s ^TMP("zhwh",10001)=ip
 
  q $g(^TMP("ZSSY_REQDISPUSER",+$h,ip))
}

/// 根据请求单rowid 取本次补货的信息
ClassMethod GetBDD(req As %String) As %String
{
   n (req)
   s bdd=$o(^DHCBDD(0,"REQ",req,""))
   q:bdd="" ""
   s frDate="",toDate="",frTime="",toTime=""
   i bdd'="" s frDate=$P(^DHCBDD(bdd),"^",6)
   i bdd'="" s toDate=$P(^DHCBDD(bdd),"^",7)
   i bdd'="" s frTime=$P(^DHCBDD(bdd),"^",14)
   i bdd'="" s toTime=$P(^DHCBDD(bdd),"^",15)
   
   i frDate'="" s frDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(frDate)
   i toDate'="" s toDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(toDate)
   i frTime'="" s frTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(frTime,"IP")
   i toTime'="" s toTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(toTime,"IP")
   q frDate_"^"_toDate_"^"_frTime_"^"_toTime
}

ClassMethod GetDHCReq(req As %String) As %String
{
  n (req)
  &sql(select inrq_type,inrq_printflag,inrq_collectuser_dr->ssusr_name,inrq_collectDate,inrq_collecttime,
     inrq_dispuser_dr->ssusr_name,inrq_dispdate,inrq_disptime,
     inrq_printdate,inrq_printtime 
     into :type,:printFlag,:collUser,:collDate,:collTime,:dispUser,:dispDate,:dispTime,:prtDate,:prtTime
     from dhc_inrequest where inrq_inrq_dr=:req ) 
    q:SQLCODE ""
    
	i type="3" d  //zhwh 2011-08-17  使用出库审核人作为"配药确认"人
	. &sql(select init_ackuser_dr->ssusr_name,init_ackdate,init_acktime 
	 into :collUser,:collDate,:collTime  from dhc_inistrf where init_inrq_dr=:req)
	 
    i collDate'="" s collDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collDate)
    i collTime'="" s collTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collTime,"IP")
    i dispDate'="" s dispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dispDate)
    i dispTime'="" s dispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(dispTime,"IP")
	i prtDate'="" s prtDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtDate)  //zhwh 2011-11-01
	i prtTime'="" s prtTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(prtTime,"IP")  //zhwh 2011-11-01
	
	s result=$G(type)_"^"_$g(printFlag)_"^"_$G(collUser)_"^"_$G(collDate)_"^"_$g(collTime)_"^"_$g(dispUser)_"^"_$G(dispDate)_"^"_$g(dispTime)
	s result=result_"^"_prtDate_"^"_prtTime
	q $g(result)
}

/// 大包装
ClassMethod PU(inci) As %String
{
 n (inci)
 q:inci="" ""
 s pu=""
 s pu=$o(^DHCPU(0,"INCI",inci,""))
 q:pu="" ""
 s PUOM=$p(^INCI(inci,3),"^",6)  //zhwh 2011-06-09
 s PUOMDesc=$p(^CT("UOM",PUOM),"^",2)
 s packuom=$p(^DHCPU(pu),"^",2)
 s packuomdesc=$p(^CT("UOM",packuom),"^",2)      ; desc of uom
 s pufactor=$p(^DHCPU(pu),"^",3)
 s packuom1=$p(^DHCPU(pu),"^",4)
 s packuomdesc1=""
 i packuom1'=""  s packuomdesc1=$p(^CT("UOM",packuom1),"^",2)    ; desc of pack1 uom
 s pufactor1=$p(^DHCPU(pu),"^",5)  ; factor of pack1 uom
 q $g(packuom)_"^"_$g(packuomdesc)_"^"_+$g(pufactor)_"^"_$g(pu)_"^"_$g(packuomdesc1)_"^"_$g(pufactor1)_"^"_$G(PUOMDesc)
}

/// 大包装描述串
ClassMethod GetPU(inci) As %String
{
 n (inci)
 s data=..PU(inci)
 q:data="" ""
 s packuom1=$p(data,"^",5)
 s packuom1factor=$p(data,"^",6)
 q:packuom1="" $p(data,"^",2)_" * "_$p(data,"^",3) 
 q $p(data,"^",2)_" * "_packuom1factor_packuom1_" * "_$p(data,"^",3)
}

ClassMethod UpdatePrint(req) As %String
{
   n (req)	
   q:req="" -1
   //
   s flag="Y"
   s printdate=+$H
   s printtime=$p($h,",",2)	
   &sql(update dhc_inrequest set INRQ_PrintFlag=:flag,INRQ_PrintDate=:dd,INRQ_PrintTime=:tt
      where inrq_rowid=:req)
   q SQLCODE
}

}
