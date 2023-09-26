Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-11-09
/// description:库存项关联收费项
Class web.DHCST.INCLINKTAR Extends %RegisteredObject
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAIN";

/// w ##class(%ResultSet).RunQuery("web.DHCST.INCLINKTAR","QueryIncLinkTar",4446)
Query QueryIncLinkTar(IncId = "") As websys.Query(ROWSPEC = "lnkId,tarItmId,tarItmCode,tarItmDesc,uomDesc,qty,sp,lnkStDate,lnkEdDate")
{
}

ClassMethod QueryIncLinkTarExecute(ByRef qHandle As %Binary, IncId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:IncId="" $$$OK
	i $d(%session) s HospId=$g(%session.Data("LOGON.HOSPID"))
	e  s HospId=""
	s lnkTarId=0
	f  s lnkTarId=$o(^DHCINCTARi("INCI",IncId,lnkTarId)) q:lnkTarId=""  d
	.s lnkTarData=$g(^DHCINCTAR(lnkTarId))
	.q:lnkTarData=""
	.s tarItmId=$p(lnkTarData,"^",2)
	.q:tarItmId=""
	.s tarItmCode=$p(^DHCTARI(tarItmId),"^",1)
	.s tarItmDesc=$p(^DHCTARI(tarItmId),"^",2)
	.s uomId=$p(^DHCTARI(tarItmId),"^",3)
	.s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	.s sp=..GetTarPrice(tarItmId,HospId)
	.s qty=$p(lnkTarData,"^",3)
	.s lnkStDate=$p(lnkTarData,"^",4)
	.s lnkEdDate=$p(lnkTarData,"^",5)
	.s lnkStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lnkStDate,"ST")
	.s lnkEdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lnkEdDate,"ST")
	.s Data=$lb(lnkTarId,tarItmId,tarItmCode,tarItmDesc,uomDesc,qty,sp,lnkStDate,lnkEdDate)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// description: 获取收费项价格
ClassMethod GetTarPrice(TarItmId, HospId)
{
	q:TarItmId="" ""
	s spStr=##class(web.UDHCJFPRICE).GetItmPrice(TarItmId,+$h,"","","",HospId,"")
	s sp=$p(spStr,"^",1)
	i (sp<1)&&($p(sp,".",1)="") s sp=0_sp
	q sp
}

/// description:根据库存项获取有效唯一的收费项Id
/// w ##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(858,"")
ClassMethod GetTarItmIdByInc(IncId, LogDate = "")
{
	i LogDate="" s LogDate=+$h
	q:IncId="" ""
	s finalTarItmId=""
	s lnkTarId=0
	f  s lnkTarId=$o(^DHCINCTARi("INCI",IncId,lnkTarId)) q:(lnkTarId="")||(finalTarItmId'="")  d
	.s lnkTarData=$g(^DHCINCTAR(lnkTarId))
	.q:lnkTarData=""
	.s tarItmId=$p(lnkTarData,"^",2)
	.q:tarItmId=""
	.s lnkStDate=$p(lnkTarData,"^",4)
	.s lnkEdDate=$p(lnkTarData,"^",5)
	.q:(lnkStDate'="")&&(lnkStDate>LogDate)
	.q:(lnkEdDate'="")&&(lnkEdDate<LogDate)
	.s finalTarItmId=tarItmId
	q finalTarItmId
}

/// description:根据收费项获取有效唯一的库存项Id
/// w ##class(web.DHCST.INCLINKTAR).GetIncIdByTarItm(8265,"")
ClassMethod GetIncIdByTarItm(TarItmId, LogDate = "")
{
	i LogDate="" s LogDate=+$h
	q:TarItmId="" ""
	s finalIncId=""
	s lnkTarId=0
	f  s lnkTarId=$o(^DHCINCTARi("TAR",TarItmId,lnkTarId)) q:(lnkTarId="")||(finalIncId'="")  d
	.s lnkTarData=$g(^DHCINCTAR(lnkTarId))
	.q:lnkTarData=""
	.s incId=$p(lnkTarData,"^",1)
	.q:incId=""
	.s lnkStDate=$p(lnkTarData,"^",4)
	.s lnkEdDate=$p(lnkTarData,"^",5)
	.q:(lnkStDate'="")&&(lnkStDate>LogDate)
	.q:(lnkEdDate'="")&&(lnkEdDate<LogDate)
	.s finalIncId=incId
	q finalIncId
}

/// description: 保存库存项关联收费项
/// w ##class(web.DHCST.INCLINKTAR).SaveIncLinkTar("","858^10^1^2018-11-09")
ClassMethod SaveIncLinkTar(LnkId, InputStr)
{
	s chkRet=..CheckBeforeSave(LnkId,InputStr)
	q:$p(chkRet,"^",1)<0 chkRet
	s IncId=$p(InputStr,"^",1)
	s TarItmId=$p(InputStr,"^",2)
	s StDate=$p(InputStr,"^",4)
	s EdDate=$p(InputStr,"^",5)
	s Qty=$p(InputStr,"^",3)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	s errCode=""
	i LnkId="" d
	.&SQL(
		INSERT INTO DHC_IncTarRela
		(INCTR_INCI_Dr,INCTR_Tari_Dr,INCTR_Qty,INCTR_StartDate,INCTR_EndDate)
		VALUES
		(:IncId,:TarItmId,:Qty,:StDate,:EdDate)
	 )
	e  d
	.&SQL(UPDATE DHC_IncTarRela SET INCTR_EndDate=:EdDate WHERE INCTR_RowId=:LnkId)
	i SQLCODE'=0 d
	.s errInfo=SQLCODE_":"_$g(%msg)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.DHCIncTarRela",errInfo)
	.s errCode="-1^"-errInfo
	q:errCode'="" errCode
	q ""
}

/// description: 保存前验证,(-10开头前台给warning,-1给error)
/// InputStr(库存项Id^收费项Id^数量^开始日期^结束日期)
/// w ##class(web.DHCST.INCLINKTAR).CheckBeforeSave("","858^50")
ClassMethod CheckBeforeSave(LnkId = "", InputStr = "")
{
	s IncId=$p(InputStr,"^",1)
	s TarItmId=$p(InputStr,"^",2)
	s StDate=$p(InputStr,"^",4)
	s EdDate=$p(InputStr,"^",5)
	q:IncId="" "-10^库存项为空"
	q:TarItmId="" "-10^收费项为空"
	q:StDate="" "-10^开始日期不能为空"
	s lnkId=""
	// 不判断重复,已截止日期控制有效

	s errCode=""
	// 验证日期范围
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	q:(EdDate'="")&&(EdDate<+$h) "-10^截止日期不能小于今日"
	q:(EdDate'="")&&(StDate'="")&&(StDate>EdDate) "-10^开始日期不能大于截止日期"
	q ""
}

/// description: 查询收费项
/// w ##class(%ResultSet).RunQuery("web.DHCST.INCLINKTAR","GetTarItem","dg")
Query GetTarItem(InputStr = "") As websys.Query(ROWSPEC = "tarItmId,tarItmCode,tarItmDesc")
{
}

ClassMethod GetTarItemExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s inputAlias=$zcvt($p(InputStr,"^",1),"U")
	q:inputAlias="" $$$OK
	s tarItmId=0
	f  s tarItmId=$o(^DHCTARI(tarItmId)) q:tarItmId=""  d
	.s tarItmData=$g(^DHCTARI(tarItmId))
	.q:$p(tarItmData,"^",7)'="Y"
	.s existFlag=""
	.s aliasId=0
	.f  s aliasId=$o(^DHCTARAL("A",tarItmId,aliasId)) q:(aliasId="")||(existFlag'="")  d
	..s alias=$p(^DHCTARAL(aliasId),"^",3)
	..i $zcvt(alias,"U")[inputAlias s existFlag=1 
	.q:existFlag=""
	.s tarItmCode=$p(tarItmData,"^",1)
	.s tarItmDesc=$p(tarItmData,"^",2)
	.d GetTarItemData
	q $$$OK	
GetTarItemData
	s Data=$lb(tarItmId,tarItmCode,tarItmDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

}
