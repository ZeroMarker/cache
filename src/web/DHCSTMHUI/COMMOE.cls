Import SQLUser

/// Descript:医嘱处理相关的函数
/// CreateDate：2011-03-17
/// Creater：周永刚
Class web.DHCSTMHUI.COMMOE Extends (%RegisteredObject, StkTypeM) [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	更新发药状态
/// CreateDate：2012-04-20
/// Creater：	周永刚 
/// Table：		DHC_OEDispensing
/// Input:		DspID
/// Return:		0-成功，-1-失败
ClassMethod UpdDispensing(DspID As %String, DspStatus As %String, dateh As %String, timeh As %String, UserID As %String, DspType As %String, DspPointer As %String) As %String
{
	n (DspID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	s err=0
	s $ZT=..sssError()
	&sql(update DHC_OEDispensing set dsp_status=:DspStatus,dsp_date=:dateh,dsp_time=:timeh,
	  dsp_user=:UserID,dsp_type=:DspType,dsp_pointer=:DspPointer where dsp_rowid=:DspID)
	i SQLCODE'=0  d
	.s err=-1 
	q err
}

/// Descript:	插入退药状态
/// CreateDate：2012-04-20
/// Creater：	周永刚 
/// Table：		DHC_OEDispensing
/// Input:		OE_OrdItem表ID(长期医嘱传执行记录rowid)
/// Return:		0-成功，-1-失败
ClassMethod InsDispensing(OeoreID As %String, DspStatus As %String, dateh As %String, timeh As %String, UserID As %String, DspType As %String, DspPointer As %String, Qty As %String, UomID As %String) As %String
{
	n (OeoreID,DspStatus,dateh,timeh,UserID,DspType,DspPointer,Qty,UomID)
	s err=0
	s OeoriID=$p(OeoreID,"||",1,2)
	s sysdate=+$h
	s systime=$p($h,",",2)
	s oeore=""
	s $ZT=..sssError()
	i $p(OeoreID,"||",3)'="" d
	.s oeore=OeoreID
	e  d
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,""),-1)
	.s:dsp'="" oeore=$p(^DHCOEDISQTY(dsp),"^",3)
	&sql(insert into sqluser.dhc_oedispensing(
		dsp_date,dsp_dateadd,dsp_time,dsp_timeadd,dsp_qty,
		dsp_qtyuom,dsp_oeori_dr,dsp_pointer,dsp_type,dsp_status,
		dsp_user,dsp_confirmqty,dsp_totalqty,dsp_oeore_dr)
	values(
		:dateh,:sysdate,:timeh,:systime,:Qty,
		:UomID,:OeoriID,:DspPointer,:DspType,:DspStatus,
		:UserID,:Qty,:Qty,:oeore)
	)
	i SQLCODE'=0  d
	.s err=-1
	q err
}

/// Descript:	更新发药状态
/// CreateDate：2012-04-20
/// Creater：	周永刚 
/// Table：		DHC_OEDispensing
/// Input:		OeoreID(长嘱执行记录rowid--oeore,临嘱医嘱rowid--oeori) 
/// Return:		0-成功，-1-失败
/// 2015-01-29 第1个参数传入修改(长期医嘱传执行记录rowid)
ClassMethod UpdDispensingByOeori(OeoreID As %String, DspStatus As %String, dateh As %String, timeh As %String, UserID As %String, DspType As %String, DspPointer As %String) As %String
{
	n (OeoreID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	s err=0
	s dspID=""
	i $p(OeoreID,"||",3)'=""  d
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OeoreID,dspID)) q:(dspID="")!(err'=0)  d
	..s err=..UpdDispensing(dspID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	e  d
	.s OeoriID=$p(OeoreID,"||",1,2)
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,dspID)) q:(dspID="")!(err'=0)  d
	..s err=..UpdDispensing(dspID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	q err
}

}
