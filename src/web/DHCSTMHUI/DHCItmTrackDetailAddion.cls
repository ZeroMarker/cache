Import sqluser

/// Descript:	高值跟踪明细(补录信息的处理)
/// Creator:    wangjiabin
/// CreateDate: 2017-05-15
Class web.DHCSTMHUI.DHCItmTrackDetailAddion Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:
/// Creator:	记录补录信息
/// CreateDate:	2017-05-15
/// Input:		入库单rowid
/// Output:		
/// w ##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordIngr(6579)
ClassMethod RecordIngr(ingr As %String) As %String
{
	n (ingr)
	s ingrDate=$p(^DHCINGR(ingr),"^",4)		;审核信息
	s ingrTime=$p(^DHCINGR(ingr),"^",9)
	s ingrUser=$p(^DHCINGR(ingr),"^",8)
	s err=0
	ts
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")||(err'=0)  d
	.s ingri=ingr_"||"_ch
	.s hvm=$o(^DHCHVMORI(0,"INGRIModify",ingri,0))
	.q:hvm=""
	.;1.获取医嘱对应的跟踪信息rowid(dhcitd)
	.s oeori=$p(^DHCHVMORI(hvm,1),"^",1)
	.s barcode=$p(^DHCHVMORI(hvm,1),"^",24)
	.s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	.s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	.q:dhcit=""
	.q:oeori=""
	.s IntrTypeInfo=..sssOeoriTrType(oeori)
	.s IntrType=$p(IntrTypeInfo,"^",1)
	.s OeoriUser=""
	.&sql(select DHCITD_SSUSR_DR into :OeoriUser from DHC_ItmTrackDetail
		where DHCITD_Type=:IntrType and DHCITD_Pointer=:oeori and dhcitd_parref=:dhcit)
	.
	.s lastCh=$o(^DHCITD(dhcit,"I",""),-1)
	.q:lastCh=""
	.s dhcitd=dhcit_"||"_lastCh
	.
	.;2.记录dhc_itmtrackdetail_addion
	.s type="SG"	;补录入库
	.s StrParam=ingri_"^"_type_"^"_ingrDate_"^"_ingrTime_"^"_ingrUser_"^"_dhcitd
	.s ret=..Insert(StrParam)
	.i ret<0 s err=-1 q
	.
	.&sql(select %id,INITI_INIT_Parref->INIT_AckDate,INITI_INIT_Parref->INIT_AckTime,INITI_INIT_Parref->INIT_AckUser_DR
		into :initi,:initDate,:initTime,:initUser
		from DHC_INIsTrfItm where INITI_INGRI_DR=:ingri)
	.q:SQLCODE'=0
	.s type="ST"	;补录出库
	.s StrParam=initi_"^"_type_"^"_initDate_"^"_initTime_"^"_initUser_"^"_dhcitd
	.s ret=..Insert(StrParam)
	.i ret<0 s err=-2 q
	.
	.s KIntrId=$o(^DHCINTR(0,"TypePointer","K",initi,0))
	.i KIntrId'="" d
	..s type="SK"
	..s IntrInfo=..GetIntrInfo("K",initi)
	..s IntrDate=$p(IntrInfo,"^",1)
	..s IntrTime=$p(IntrInfo,"^",2)
	..s IntrUser=$p(IntrInfo,"^",3)
	..s StrParam=initi_"^"_type_"^"_IntrDate_"^"_IntrTime_"^"_IntrUser_"^"_dhcitd
	..s ret=..Insert(StrParam)
	..i ret<0 q
	..;有K时,也同时有医嘱台帐
	..s type="S"_IntrType
	..s StrParam=oeori_"^"_type_"^"_IntrDate_"^"_IntrTime_"^"_OeoriUser_"^"_dhcitd
	..s ret=..Insert(StrParam)
	..i ret<0 q
	.i ret<0 s err=-3 q
 	.
 	i err'=0 tro 1 q err
 	tc
 	q 0
}

/// Description:根据转移单明细,记录退库退货的日志信息
/// Creator:	记录补录信息
/// CreateDate:	2017-05-15
/// Input:		医嘱rowid,高值条码,退库单rowid,退货单rowid
/// Output:		
/// w ##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordReturn(7618,500)
ClassMethod RecordReturn(Oeori As %String, Barcode As %String, Init As %String, Ingrt As %String) As %String
{
	n (Oeori,Barcode,Init,Ingrt)
	q:(Init="")||(Ingrt="") -1
	;这里明确一下:按目前的处理模式,Init和Ingrt均分别只有一条明细
	s ch=$o(^DHCINIT(Init,"ITI",0))
	q:ch="" -1
	s Initi=Init_"||"_ch
	s ch=$o(^INGRT(Ingrt,"DHCGRR",0))
	q:ch="" -1
	s ingrti=Ingrt_"||"_ch
	
	s dhcit=$o(^DHCIT(0,"LABEL",Barcode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",Barcode,0))
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s IntrType=$p(IntrTypeInfo,"^",1)
	s lastCh=$o(^DHCITD(dhcit,"I",""),-1)
	q:lastCh="" 0
	s dhcitd=dhcit_"||"_lastCh
	
	ts
	;1.记录补录对应的退库
	s type="ST"
	s intrInfo=..GetIntrInfo("T",Initi)
	s date=$p(intrInfo,"^",1),time=$p(intrInfo,"^",2),user=$p(intrInfo,"^",3)
	s strParam=Initi_"^"_type_"^"_date_"^"_time_"^"_user_"^"_dhcitd
	s ret=..Insert(strParam)
	i ret<0 tro 1 q -2
	
	s type="SK"
	s intrInfo=..GetIntrInfo("K",Initi)
	s date=$p(intrInfo,"^",1),time=$p(intrInfo,"^",2),user=$p(intrInfo,"^",3)
	s strParam=Initi_"^"_type_"^"_date_"^"_time_"^"_user_"^"_dhcitd
	s ret=..Insert(strParam)
	i ret<0 tro 1 q -2
	
	;2.记录补录对应的退货
	s type="SR"
	s intrInfo=..GetIntrInfo("R",ingrti)
	s date=$p(intrInfo,"^",1),time=$p(intrInfo,"^",2),user=$p(intrInfo,"^",3)
	s strParam=ingrti_"^"_type_"^"_date_"^"_time_"^"_user_"^"_dhcitd
	s ret=..Insert(strParam)
	i ret<0 tro 1 q -3
	tc
	q 0
}

/// Descript:   保存高值跟踪明细信息
/// Table:		dhc_itmtrackdetail_addion
/// Input:		StrParam(pointer^type^date^time^user^dhcitd^dhcitda)
/// Output:     
/// Return:		id:成功; <0:失败
ClassMethod Insert(StrParam As %String) As %String
{
	n (StrParam)

	s pointer=$p(StrParam,"^",1)
	s type=$p(StrParam,"^",2)
	s date=$p(StrParam,"^",3)
	s time=$p(StrParam,"^",4)
	s user=$p(StrParam,"^",5)
	s dhcitd=$p(StrParam,"^",6)
	;已存在的,不重复处理
	q:$d(^DHCITD(0,"IATypePointer",type,pointer)) 0
	
	s obj=##class(User.DHCItmTrackDetailAddion).%New()
	s obj.DHCITDAPointer=pointer
	s obj.DHCITDAType=type
	s obj.DHCITDADate=date
	s obj.DHCITDATime=time
	d obj.DHCITDASSUSRDRSetObjectId(user)
	d obj.DHCITDADHCITDDRSetObjectId(dhcitd)
	s sc=obj.%Save()
	i $$$ISERR(sc) s err=-2 q err
	q obj.%Id()
}

/// 获取台帐日期,时间,人员
ClassMethod GetIntrInfo(Type As %String, Pointer As %String) As %String [ Private ]
{
	n (Type,Pointer)
	s date=+$h,time=$p($h,",",2),user=""
	s str=date_"^"_time_"^"_user
	s intr=$o(^DHCINTR(0,"TypePointer",Type,Pointer,0))
	q:intr="" str
	s date=$p(^DHCINTR(intr),"^",2)
	s time=$p(^DHCINTR(intr),"^",3)
	s user=$p(^DHCINTR(intr),"^",11)
	s str=date_"^"_time_"^"_user
	q str
}

/// Descript:   根据台帐类型,指针,若该业务是高值补录单据,取其对应的高值条码
/// Table:		dhc_itmtrackdetail_addion
/// Input:		台帐类型, 台帐Pointer
/// Output:     
/// Return:		高值条码,获取不到时返回""
ClassMethod GetAddionLabel(Type, Pointer) As %String
{
	n (Type,Pointer)
	q:(Type="")||(Pointer="") ""
	q:"^G^R^T^K^"'[("^"_Type_"^") ""
	
	s SType="S"_Type		;补录类型
	s dhcitda=$o(^DHCITD(0,"IATypePointer",SType,Pointer,0))
	q:dhcitda="" ""
	s dhcitd=$p(^DHCITD("IA",dhcitda),"^",6)
	s dhcit=$p(dhcitd,"||",1)
	q:dhcit="" ""
	s HVBarCode=$p(^DHCIT(dhcit),"^",2)
	
	q HVBarCode
}

}
