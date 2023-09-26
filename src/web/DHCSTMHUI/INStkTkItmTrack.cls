Import sqluser

Class web.DHCSTMHUI.INStkTkItmTrack Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存DHC_INStkTkItmTrack信息
/// Creator:	
/// CreateDate: 2015-07-13
/// Input:		insti
/// Return:		0 - 成功, <0 - 失败
ClassMethod Save(Insti As %String) As RtnObj
{
	n (Insti)
	s RtnObj=##class(RtnObj).%New()
	i Insti="" q RtnObj.Err(-601,"","账盘单明细不存在","",0)

	s Inst=+Insti,ch=$p(Insti,"||",2)
	s Inclb=$p(^DHCINST(Inst,"STI",ch),"^",1)
	s InciId=+Inclb

	s dhcit=0
	f  s dhcit=$o(^DHCIT(0,"INCI",InciId,dhcit)) q:(dhcit="")||(RtnObj.success<0)  d
	.s tmpinclb=$p(^DHCIT(dhcit),"^",12)
	.q:(tmpinclb'=Inclb)
	.
	.s Status=$p(^DHCIT(dhcit),"^",5)
	.q:(Status="")||(Status="Used")||(Status="InIsTrf")
	.s lastAudit=""
	.i (Status="Return")||(Status="InScrap")||(Status="InAdj") d
	..s lastCh=+$o(^DHCITD(dhcit,"I",""),-1)
	..i +lastCh>0 d
	...s lastChInfo=##class(web.DHCSTMHUI.DHCItmTrack).IsDetailAudit(dhcit_"||"_lastCh)
	...s lastAudit=$p(lastChInfo,"^",1)
	.q:(lastAudit="Y")
	.
	.s obj=##class(User.DHCInStkTkItmTrack).%New()
	.d obj.INSTITINSTIParrefSetObjectId(Insti)
	.s sub=$o(^DHCINST(Inst,"STI",ch,"STIT",""),-1)+1
	.s obj.INSTITChildSub=sub
	.d obj.INSTITDHCITDRSetObjectId(dhcit)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d RtnObj.Err(-602,"","保存高值账盘明细失败")
	.
	q RtnObj
}

/// Descript:	检索insti对应高值条码明细
/// Creator:	lxt
/// CreateDate: 2018-8-14
/// Input:		insti
/// Return:		json串
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTkItmTrack","jsItmTrackDetail",^templxt("TrackIn"),^templxt("TrackOt"))
Query jsItmTrackDetail(Insti As %String, Others As %String) As Query(ROWSPEC = "Instit,Dhcit,BarCode,CountFlag,CountDate,CountTime,CountUserName") [ SqlProc ]
{
}

ClassMethod jsItmTrackDetailExecute(ByRef qHandle As %Binary, Insti As %String, Others As %String) As %Status
{
	n (qHandle,Insti,Others)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Insti="" $$$OK
	
	s AckFlag=$p(Others,"^",1)		;是否盘点("Y":仅已盘点, "N":"仅未盘点", 其他:所有)
	s Inst=+Insti,ch=$p(Insti,"||",2)
	s sub=0
	f  s sub=$o(^DHCINST(Inst,"STI",ch,"STIT",sub)) q:sub=""  d
	.s InstitInfo=^(sub)
	.s Instit=Insti_"||"_sub
	.s Dhcit=$p(InstitInfo,"^",1)
	.s BarCode=$p(^DHCIT(Dhcit),"^",2)
	.s CountFlag=$p(InstitInfo,"^",2)
	.q:(AckFlag'="")&&(AckFlag'=CountFlag)
	.
	.s CountDate=$p(InstitInfo,"^",3)
	.s:CountDate'="" CountDate=..DL2H(CountDate)
	.s CountTime=$p(InstitInfo,"^",4)
	.s:CountTime'="" CountTime=..TL2H(CountTime)
	.s CountUserId=$p(InstitInfo,"^",5)
	.s (CountUserName)=""
	.s:CountUserId'="" CountUserName=$p(^SSU("SSUSR",CountUserId),"^",2)
	.d OutPutRow
	
	Quit $$$OK
OutPutRow
	s Data=$lb(Instit,Dhcit,BarCode,CountFlag,CountDate,CountTime,CountUserName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 批量保存实盘表记录(js调用)
/// Creator:	lxt
ClassMethod jsINStkTkItmTrack(HVBarCode As %String, Inst As %String, UserId As %String) As %String
{
	n (HVBarCode,Inst,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..INStkTkItmTrack(HVBarCode,Inst,UserId)
	q RtnObj.Json()
}

/// Descript:	根据高值条码盘点,记录盘点信息
/// Creator:	lxt
/// CreateDate: 2015-07-15
/// Input:		HVBarCode
/// Return:		0^insti - 成功, <0 - 失败
/// 			-10:条码不存在,-11:条码不存在盘点单中,-12:重复处理
/// w ##class(web.DHCSTMHUI.INStkTkItmTrack).INStkTkItmTrack("WJWS20170419015-6",160,873)
ClassMethod INStkTkItmTrack(HVBarCode As %String, Inst As %String, UserId As %String) As RtnObj
{
	n (HVBarCode,Inst,UserId)
	s RtnObj=##class(RtnObj).%New()
	i HVBarCode="" q RtnObj.Err(-1,"","条码为空","",0)
	i Inst="" q RtnObj.Err(-1,"","盘点单为空","",0)
	
	s Dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	s:Dhcit="" Dhcit=$o(^DHCIT(0,"ORIGINALCODE",HVBarCode,""))
	q:Dhcit="" RtnObj.Err(-2,"","查询不到该条码","",0)
	
	s ch=$o(^DHCINST(0,"DHCIT",Dhcit,Inst,0))
	q:ch="" RtnObj.Err(-3,"","该条码未存在本地盘点中","",0)
	
	s Insti=Inst_"||"_ch
	s sub=$o(^DHCINST(0,"DHCIT",Dhcit,Inst,ch,0))
	s Instit=Insti_"||"_sub
	s CountFlag=$p(^DHCINST(Inst,"STI",ch,"STIT",sub),"^",2)
	q:CountFlag="Y" RtnObj.Err(-4,"","该条码已进行实盘","",0)
	
	ts
	;记录盘点信息
	s InstitObj=##class(User.DHCInStkTkItmTrack).%OpenId(Instit)
	d InstitObj.%Reload()
	d InstitObj.INSTITCountUserDRSetObjectId(UserId)
	s InstitObj.INSTITInStkTkFlag="Y"
	s InstitObj.INSTITCountDate=+$h
	s InstitObj.INSTITCountTime=$p($h,",",2)
	s sc=InstitObj.%Save()
	i $$$ISERR(sc) tro  q RtnObj.Err(-5,"","记录条码实盘信息失败1")
	
	s Rp=+$P(^DHCINST(Inst,"STI",ch),"^",30)
	s Sp=+$P(^DHCINST(Inst,"STI",ch),"^",28)
	s FreezeQty=+$p(^DHCINST(Inst,"STI",ch),"^",2)
	
	s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	d obj.%Reload()
	s CountQty=+obj.INSTICount1Qty+1
	s RpAmt=Rp*CountQty
	s SpAmt=Sp*CountQty
	s FreezeRpAmt=+obj.INSTIFreezeRpAmt
	s FreezeSpAmt=+obj.INSTIFreezeSpAmt
	s VarianceQty=CountQty-FreezeQty
	s VarianceRpAmt=RpAmt-FreezeRpAmt
	s VarianceSpAmt=SpAmt-FreezeSpAmt
	d obj.INSTICount1PersonDRSetObjectId(UserId)
	s obj.INSTICount1Qty=CountQty
	s obj.INSTICount1Date=+$h
	s obj.INSTICount1Time=$p($h,",",2)
	s obj.INSTICount1SpAmt=SpAmt
	s obj.INSTICount1RpAmt=RpAmt
	s obj.INSTIVariance1=VarianceQty
	s obj.INSTIVariance1RpAmt=VarianceRpAmt
	s obj.INSTIVariance1SpAmt=VarianceSpAmt
	s sc=obj.%Save()
	i $$$ISERR(sc) tro  q RtnObj.Err(-6,"","记录条码实盘信息失败2")
	s RtnObj.rowid=CountQty
	tc
	q RtnObj
}

/// 盘点完成 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkItmTrack).jsCompleteItmTrack(160,873)
ClassMethod jsCompleteItmTrack(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CompleteItmTrack(Inst,UserId)
	q RtnObj.Json()
}

/// Descript:	盘点汇总
/// Creator:	wangjiabin
/// CreateDate: 2015-07-15
/// Input:		inst,UserId
ClassMethod CompleteItmTrack(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	s CompleteFlag=$p(^DHCINST(Inst),"^",13)
	i CompleteFlag="Y" q RtnObj.Err(-2,"","已经完成!","",0)
	
	i ..sssLock("DHCSTINSTKTK"_Inst)<0  q RtnObj.Err(-99,"","加锁失败!")
	s InStkItmFlag="Y"

	ts
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI",ch)) q:(ch="")!(RtnObj.success<0)  d
	.s Insti=Inst_"||"_ch
	.s Inci=$p(^DHCINST(Inst,"STI",ch),"^",18) q:Inci=""
	.s CountQty=0
	.s FreezeQty=+$p(^DHCINST(Inst,"STI",ch),"^",2) 
	.s CountQty=+$p(^DHCINST(Inst,"STI",ch),"^",5)		;实盘数量
	.q:CountQty>0		;录入过条码的,不需再次处理
	.s Rp=$P(^DHCINST(Inst,"STI",ch),"^",30)
	.s CountRpAmt=Rp*CountQty
	.s Sp=$P(^DHCINST(Inst,"STI",ch),"^",28)
	.s CountSpAmt=Sp*CountQty
	.
	.s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	.d obj.%Reload()
	.d obj.INSTICount1PersonDRSetObjectId(UserId)
	.s obj.INSTICount1Qty=+CountQty
	.s obj.INSTICount1Date=+$H
	.s obj.INSTICount1Time=$P($H,",",2)
	.s obj.INSTICount1SpAmt=+CountSpAmt
	.s obj.INSTICount1RpAmt=+CountRpAmt
	.s varQty=obj.INSTICount1Qty-FreezeQty
	.s obj.INSTIVariance1=varQty
	.s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	.s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d RtnObj.Err(-5,"","更新账盘明细失败")
	.q:RtnObj.success<0
	.
	i RtnObj.success<0 d
	.tro 
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	i RtnObj.success<0 q RtnObj

	&sql(update DHC_instktk set inst_stocktakecomplete=:InStkItmFlag where inst_rowid =:Inst)
	i SQLCODE'=0  d
	.tro
	.d RtnObj.Err(-6,"","汇总错误!")
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	q:RtnObj.success'=0 RtnObj
	
	tc
	d ..sssUnLock("DHCSTINSTKTK"_Inst)
	q RtnObj
}

}
