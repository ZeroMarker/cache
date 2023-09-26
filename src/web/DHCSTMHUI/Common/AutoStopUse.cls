Import sqluser

/// 自动停用 物资 和 供应商 
/// d ##class(web.DHCSTMHUI.Common.AutoStopUse).ItmStop()
/// d ##class(web.DHCSTMHUI.Common.AutoStopUse).ApcStop()
Class web.DHCSTMHUI.Common.AutoStopUse Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   更新最后业务日期
/// Creater:    徐超
/// CreateDate: 2015-05-20
/// Table: 
/// Input:
/// Output:     
/// Return：0,成功
ClassMethod Update(Inci As %String, Pointer As %String, Type As %String) As %Library.String
{
	n (Inci,Pointer,Type)
	;不能为空项
	q:Inci="" "-1"
	q:Pointer="" "-1"
	q:Type="" "-1"
	s d=+$h
	&sql(select INFO_RowId from DHC_ItmAddionInfo where INFO_INCI_DR=:Inci)
	i SQLCODE=0  d
	.&sql(update DHC_ItmAddionInfo set INFO_EndDate=:d where INFO_INCI_DR=:Inci)
	e  d
	.&sql(insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_EndDate) values(:Inci,:d) )
	/////处理供应商最后业务日期
	i (Type="G")||(Type="R") d
	.s ApcId=""
	.i Type="G" d
	..&sql(select INGRI_INGR_ParRef->INGR_APCVM_DR into :ApcId from DHC_INGdRecItm where INGRI_RowId=:Pointer)
	.i Type="R" d
	..&sql(select INGRTI_INGRT_PARREF->INGRT_APCVM_DR into :ApcId from DHC_INGRTITM where INGRTI_Rowid=:Pointer)
	.&sql(Update APC_Vendor set APCVM_LstBsDate=:d where APCVM_RowId=:ApcId)
}

/// Descript:   任务停用物资
/// Creater:    徐超
/// CreateDate: 2015-05-20
/// Table: 
/// Input:
/// Output:     
/// Return：0,成功
ClassMethod ItmStop()
{
	new
	s d=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("StopItmDate")
	q:d'>0
	s now=+$h
	s flag="Y"
	s inci=0
	f  s inci=$o(^INCI(inci)) q:(inci="")||(inci="IB_EX")  d
	.s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s TmpStkGrpdesc=$p(tmpstkgrp,"^",3)
	.q:TmpStkGrpdesc'="M"
	.s notuse=$p(^INCI(inci,2),"^",9)
	.q:notuse="Y"
	.s add=$O(^DHCITMINFO(0,"INCI",inci,0))
	.q:add=""
	.s enddate=$p(^DHCITMINFO(add),"^",31)
	.q:enddate=""
	.i ((now-enddate)>d) d
	..&sql(update INC_Itm set INCI_NotUseFlag=:flag where INCI_RowId=:inci)
}

/// Descript:   任务停用供应商
/// Creater:    徐超
/// CreateDate: 2015-05-20
/// Table: 
/// Input:
/// Output:     
/// Return：0,成功
ClassMethod ApcStop()
{
	new
	s d=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("StopApcDate")
	q:d'>0
	s now=+$h
	s flag="S"
	s apc=0
	f  s apc=$o(^APC("APCVM",apc)) q:apc=""  d
	.s Type=$p(^APC("APCVM",apc),"^",9)
	.q:Type'="M"
	.s notuse=$p(^APC("APCVM",apc),"^",18)
	.q:notuse="S"
	.s podate=$p(^APC("APCVM",apc,1),"^",6)
	.q:podate=""
	.i ((now-podate)>d) d
	..&sql(update APC_Vendor  set APCVM_Status=:flag where APCVM_RowId=:apc)
}

/// Descript:	根据医嘱截止日期停用库存项: 设置"不可用"标记
/// Creator:	wangjiabin
/// CreateDate: 2016-11-18
/// d ##class(web.DHCSTMHUI.Common.AutoStopUse).StopInciByArcimEffDate()
ClassMethod StopInciByArcimEffDate()
{
	new
	s Now=+$h
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci'>0
	.q:'$d(^INCI(inci,1))
	.s arcim=$p(^INCI(inci,1),"^",3)
	.q:arcim=""
	.
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'="M"
	.
	.s NotUseFlag=$p(^INCI(inci,2),"^",9)
	.q:NotUseFlag="Y"
	.
	.s EffDateTo=""
	.&sql(select ARCIM_EffDateTo into :EffDateTo from Arc_ItmMast where arcim_rowid=:arcim)
	.q:(SQLCODE=100)||(EffDateTo="")
	.q:EffDateTo>=Now		;截止日期晚于今天的,过滤
	.;q:((Now-EffDateTo)'=1)	;只处理截止日期到昨天的,其余的过滤
	.
	.s obj=##class(User.INCItm).%OpenId(inci,0)
	.s obj.INCINotUseFlag="Y"
	.d obj.%Save()
	.
}

/// Descript:	根据合同截止日期停用库存项: 设置"不可用"标记
/// Creator:	wangjiabin
/// CreateDate: 2021-06-17
/// d ##class(web.DHCSTMHUI.Common.AutoStopUse).StopInciByContract()
ClassMethod StopInciByContract()
{
	new
	s ConId=0
	f  s ConId=$o(^DHCSTMCONTRACK(ConId)) q:ConId=""  d
	.s EndDate=$p(^DHCSTMCONTRACK(ConId),"^",5)
	.q:EndDate=""
	.q:EndDate>+$h
	.q:'$d(^DHCSTMITMCONTRACK(0,"CONTRACT",ConId))
	.s Inci=0
	.f  s Inci=$o(^DHCSTMITMCONTRACK(0,"CONTRACT",ConId,Inci)) q:Inci=""  d
	..q:'$d(^INCI(Inci,1))
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	..s ScgType=$p(ScgInfo,"^",3)
	..q:ScgType'=..sssCode()
	..s Obj=##class(User.INCItm).%OpenId(Inci,0)
	..s NotUseFlag=Obj.INCINotUseFlag
	..q:NotUseFlag="Y"
	..s Obj.INCINotUseFlag="Y"
	..s Sc=Obj.%Save()
	
	q ""
}

}
