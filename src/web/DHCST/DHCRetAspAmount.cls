Import sqluser

Class web.DHCST.DHCRetAspAmount Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入一条数据到DHC_RetAspAmount
/// Author:zhwh
/// Date:2013-08-01
/// Arguments:
///  sdata - 数据串:批次rowid^数量^售价差异^售价差额^进价差^进价差额^用户rowid^业务RowId^业务代码
/// Return:
///  0 -成功
///  <0 - 失败
ClassMethod Insert(sdata As %String) As %String
{
 N (sdata)
 K PLIST
 s inclb=$p(sdata,"^",1)
 s inci=+inclb
 s locdr=$p(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
 s qty=$p(sdata,"^",2)
 s spdiff=$p(sdata,"^",3)
 s spamtdiff=$p(sdata,"^",4)
 s rpdiff=$p(sdata,"^",5)
 s rpamtdiff=$p(sdata,"^",6)
 s usr=$p(sdata,"^",7)
 s pointer=$p(sdata,"^",8)
 s type=$p(sdata,"^",9) 
 s uom=$p(sdata,"^",10) 
 
 S PLIST(2)=inci	//RETA_INCI_DR
 S PLIST(3)=locdr	//RETA_CTLOC_DR
 S PLIST(4)=+spdiff	//RETA_AdjPrice
 S PLIST(5)=+qty	//RETA_Qty
 S PLIST(6)=+spamtdiff	//RETA_Amount
 S PLIST(7)=usr	//RETA_SSUSR_DR
 S PLIST(8)=+$h				//RETA_Date
 S PLIST(9)=$p($h,",",2) 	//RETA_Time
 S PLIST(10)=pointer	//RETA_Pointer
 S PLIST(11)=type	//RETA_Type
 S PLIST(12)=+rpdiff	//RETA_RpDiff
 S PLIST(13)=+rpamtdiff	//RETA_RpAmt
 S PLIST(14)=uom	//RETA_Uom_DR
 s PLIST(15)=inclb  //RETA_INCLB_DR
 
 &SQL(Insert Into DHC_RetAspAmount Values :PLIST())
 Q SQLCODE
}

/// creator:yunhaibao
/// createdate:2015-11-26
/// description:删除损益数据,用于单据取消审核时删台账成功后调用
/// input:明细id,业务类型
ClassMethod delete(type, pointer)
{
	n (pointer,type)
	q:type="" "业务类型为空!"
	q:pointer="" "业务类型指针为空!"
	q:'$d(^DHCRETA(0,"TypePointer",type,pointer)) 0
	s retasprowid=$o(^DHCRETA(0,"TypePointer",type,pointer,""),-1)  //同台账,业务+指针确定唯一记录
	&SQL(DELETE FROM DHC_RetAspAmount WHERE RETA_RowId=:retasprowid)
	q:SQLCODE "删除损益数据失败!"
	q SQLCODE
}

/// creator:yunhaibao
/// createdate:2015-12-23
/// description:根据传入日期和时间判断之后是否存在调价记录,如果存在则不允许取消审核操作
/// output:>0存在
/// input:批次id,$h格式的日期与时间,院区id
/// others:w ##class(web.DHCST.DHCRetAspAmount).CheckIfHaveAdjPrice("533||5||3","63909","61493","")
ClassMethod CheckIfHaveAdjPrice(transinclb, transdate, transtime, hospid = "")
{
	n (transinclb,transdate,transtime,hospid)
	q:+transdate=0 ""
	q:+transtime=0 ""
	q:+transinclb=0 ""
	q:$l(transinclb,"||")'=3 ""
	s transinci=+transinclb
	s transincich=$p(transinclb,"||",2)
	s transincilb=$p(transinclb,"||",3)
	q:'$d(^INCI(transinci,"IL",transincich)) ""
	s transloc=$p(^INCI(transinci,"IL",transincich),"^",1)
	i hospid="" s hospid=$p($g(^CTLOC(transloc)),"^",22)
	s haveflag=0
	s RpRule=##Class(web.DHCSTCOMMPARA).GetRpRule(hospid)
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag()
	s exedate="",exetime=""
	i RpRule'=3 d  //非批次价
    .i GroupFlag'=2 d
    ..s exedate=$o(^INASP(0,"INCI",transinci,exedate),-1) //最新调价日期
    ..q:+exedate<transdate  
 	..s aspid=""
 	..s aspid=$o(^INASP(0,"INCI",transinci,exedate,aspid),-1) 
 	..q:aspid="" 
 	..s aspd=$o(^DHCINASPD(0,"INASP",aspid,""),-1)
 	..q:aspd="" 
 	..s exetime=$p(^DHCINASPD(aspd),"^",3)  //当天最新调价时间
 	..q:(exedate=transdate)&(exetime<=transtime)
 	..s haveflag=1
    .e  d
	..I hospid'="" d
	...s exedate=$o(^INASP(0,"HOSPI",hospid,transinci,exedate),-1)
    ...q:+exedate<transdate  
 	...s aspid=""
 	...s aspid=$o(^INASP(0,"HOSPI",hospid,transinci,exedate,aspid),-1) 
 	...q:aspid="" 
 	...s aspd=$o(^DHCINASPD(0,"INASP",aspid,""),-1)
 	...q:aspd="" 
 	...s exetime=$p(^DHCINASPD(aspd),"^",3)  //当天最新调价时间
 	...q:(exedate=transdate)&(exetime<=transtime)
 	...s haveflag=1
    e  d //批次价
    .q:'$d(^INCI(transinci,"IL",transincich,"LB",transincilb))
    .s transincib=$p(^INCI(transinci,"IL",transincich,"LB",transincilb),"^",1)
    .i GroupFlag'=2 d
    ..s exedate=$o(^DHCSTINAPB(0,"INCIB",transincib,exedate)) 
    ..q:+exedate<transdate  
    ..s exetime=$o(^DHCSTINAPB(0,"INCIB",transincib,exedate,exetime)) 
    ..q:(exedate=transdate)&(exetime<=transtime)
    ..s haveflag=1
    .e  d
    ..i hospid'="" d
    ...s exedate=$o(^DHCSTINAPB(0,"HOSPINCIB",hospid,transincib,exedate)) 
    ...q:+exedate<transdate  
    ...s exetime=$o(^DHCSTINAPB(0,"HOSPINCIB",hospid,transincib,exedate,exetime)) 
    ...q:(exedate=transdate)&(exetime<=transtime)
    ...s haveflag=1
    q haveflag
}

}
