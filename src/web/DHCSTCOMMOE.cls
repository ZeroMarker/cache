Import SQLUser

/// Descript:医嘱处理相关的函数
/// CreateDate：2011-03-17
/// Creater：周永刚
Class web.DHCSTCOMMOE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	&sql(update DHC_OEDispensing set dsp_status=:DspStatus,dsp_date=:dateh,dsp_time=:timeh,
	  dsp_user=:UserID,dsp_type=:DspType,dsp_pointer=:DspPointer where dsp_rowid=:DspID)
	i SQLCODE'=0  d
	.s err=-1 
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.DHCSTCOMMOE.UpdDispensing",$h,DspID,SQLCODE_":"_%msg)
	q err
}

/// Descript:	插入退药状态
/// CreateDate：2012-04-20
/// Creater：	周永刚 
/// Table：		DHC_OEDispensing
/// Input:		OE_OrdItem表ID
/// Return:		0-成功，-1-失败
ClassMethod InsDispensing(OeoriID As %String, DspStatus As %String, dateh As %String, timeh As %String, UserID As %String, DspType As %String, DspPointer As %String, Qty As %String, UomID As %String) As %String
{
	n (OeoriID,DspStatus,dateh,timeh,UserID,DspType,DspPointer,Qty,UomID)
	s err=0
	s sysdate=+$h
	s systime=$p($h,",",2)
	&sql(insert into sqluser.dhc_oedispensing(dsp_date,dsp_dateadd,dsp_time,dsp_timeadd,
	dsp_qty,dsp_qtyuom,dsp_oeori_dr,dsp_pointer,dsp_type,dsp_status,dsp_user,dsp_confirmqty)
	values(:dateh,:sysdate,:timeh,:systime,:Qty,:UomID,:OeoriID,:DspPointer,:DspType,:DspStatus,:UserID,:Qty))
	i SQLCODE'=0  d
	.s err=-1 
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.DHCSTCOMMOE.InsDispensing",$h,OeoriID,SQLCODE_":"_%msg)
	q err
}

/// Descript:	更新发药状态
/// CreateDate：2012-04-20
/// Creater：	周永刚 
/// Table：		DHC_OEDispensing
/// Input:		DspID
/// Return:		0-成功，-1-失败
ClassMethod UpdDispensingByOeori(OeoriID As %String, DspStatus As %String, dateh As %String, timeh As %String, UserID As %String, DspType As %String, DspPointer As %String) As %String
{
	n (OeoriID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	s err=0
	s dspID=""
	f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,dspID)) q:(dspID="")!(err'=0)  d
	.s err=..UpdDispensing(dspID,DspStatus,dateh,timeh,UserID,DspType,DspPointer)
	q err
}

}
