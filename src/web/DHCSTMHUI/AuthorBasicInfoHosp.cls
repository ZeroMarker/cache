Import sqluser

/// Description: 院区区分启动 数据授权
/// Createor:	lihui
/// CreateDate:	20200514
Class web.DHCSTMHUI.AuthorBasicInfoHosp Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Description: 根据库存项 关联医嘱项、收费项 与医院
ClassMethod OverrideHospFromInci(inci)
{
	n (inci)
	q:inci="" 0
	s errCode=""	
	s arcim = $p(^INCI(inci,1),"^",3)
	q:arcim="" 0
	s ret=..OverrideHosp(arcim,inci)
	i +ret<0 s errCode = ret
	i errCode '="" q errCode
	q 0
}

/// Description: 库存项继承医嘱项院区信息
ClassMethod InheritHospToInci(inci)
{
	s arcim = $p($g(^INCI(inci, 1)), "^", 3)
	q ..OverrideHosp(arcim, inci)
}

ClassMethod OverrideHosp(arcim, inci)
{
	n (arcim,inci)
	q:arcim="" 0
	q:inci="" 0
	s errCode = ""
	s tar = ..GetTarItmIdByArcid(arcim,"")
	/* 先删除作废的关联 */
	s iah = 0
	f  s iah = $o(^ITMADDHOP(0, "Inci", inci, iah)) q:(iah="")||(errCode'="")  d
	.s iahHosp = $p(^ITMADDHOP(iah), "^", 2)
	.s arcimHospSub = $o(^ARCIM(+arcim, +$p(arcim,"||",2), "HOSP", 0, "Hosp", iahHosp, 0))
	.i +arcimHospSub > 0 d
	..s ret = ##class(web.DHCSTMHUI.MatForBDPData).DeleteArcHOSP(arcim, iahHosp)
	..i +ret<0 s errCode = ret q
	..s ret = ##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_TarItem",tar, iahHosp)
	..i +ret<0 s errCode = ret q
	.;/* 再处理保存 */
	.s ret = ##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(arcim, iahHosp)
	.i +ret<0 s errCode = ret q
	.s ret = ##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_TarItem",tar, iahHosp)
	.i +ret<0 s errCode = ret q
	i errCode '="" q errCode
	q 0
}

/// Description: 根据医嘱项获取收费项有效的唯一ID
ClassMethod GetTarItmIdByArcid(Arcid, LogDate = "")
{
	n (Arcid)
	q:Arcid="" ""
	i LogDate="" s LogDate=+$h
	s tarItmId="",finalTarItmId=""
	f  s tarItmId=$o(^DHCOLT(0,"ARTTA",Arcid,tarItmId)) q:(tarItmId="")  d
	.s startDate=$p(^DHCTARI(tarItmId),"^",11)
	.q:(startDate="")||(startDate>LogDate)
	.s endDate=$p(^DHCTARI(tarItmId),"^",12)
	.q:(endDate'="")&&(endDate<LogDate)
	.s date=""
	.f  s date=$o(^DHCOLT(0,"ARTTA",Arcid,tarItmId,date)) q:(date="")  d
	..q:(date>LogDate)
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"ARTTA",Arcid,tarItmId,date,OLTRowId)) q:OLTRowId=""  d
	...s lendDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(lendDate'="")&&(lendDate<LogDate)
	...s finalTarItmId=tarItmId
	q finalTarItmId
}

/// Description: 管控授权库存项, 同时更新医嘱项与收费项
/// Creater:	lihui
/// CreateDate:	20200514
/// Input:		 Inci,hospStr(院区ID$Y^院区ID$N...)
ClassMethod SaveDataHospMulti(Inci, hospStr)
{
	s $zt = "ErrorSaveDataHospMulti"
	ts
	s errCode = ""
	s len = $l(hospStr, "^")
	f i = 1 : 1 : len d
	.s str = $p(hospStr, "^", i)
	.i str = "" q
	.s hosp = $p(str,"$",1)
	.s flag = $p(str,"$",2)
	.i hosp = "" q
	.i flag = "Y" d		// 插入 
	..s ret =##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(Inci,hosp)
	.e  d				// 删除
	..s ret = ##class(web.DHCSTMHUI.MatForBDPData).DeleteInciHOSP(Inci,hosp)
	.i +ret <0 s errCode=ret
	
	i errCode '= "" tro  q errCode
	s ret = ..OverrideHospFromInci(Inci)
	i +ret <0 tro  q ret
	
	tc
	q 0
ErrorSaveDataHospMulti
	l
	tro
	q "-5^" _ $replace($ze, "^", "-")
}

}
