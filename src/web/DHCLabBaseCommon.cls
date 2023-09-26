Class web.DHCLabBaseCommon Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 9;

/// Lid
/// 2010-08-26 
/// 根据医嘱Rowid(医嘱已结算)获取发票号
/// 入参:oeoridr:医嘱Rowid
///     pattype:病人类型(I:住院,O:门诊/急诊)
/// 出参:发票Rowid^发票号^发票打印人^发票打印日期
/// w ##class(web.UDHCJFBaseCommon).GetInvNOByOeoriDr("318||1","O")
ClassMethod GetInvNOByOeoriDr(oeoridr, pattype)
{
	;^DHCPBi(0,"OEORI",{PBO_OEORI_DR},{DHC_PatientBill.PB_RowId},{PBO_ChildSub})
	q:oeoridr="" "^^^^^^^^^^"
	;获取医嘱对应的账单Rowid(取最后一条正常结算账单记录)
	s billRowid="",pbdr=""
	f  s pbdr=$o(^DHCPBi(0,"OEORI",oeoridr,pbdr),-1) q:((pbdr="")!(billRowid'=""))  d
	.s s=$g(^DHCPB(pbdr))
	.s billFlag=$p(s,"^",16)
	.q:billFlag'="P"
	.s billRowid=pbdr 
	q:billRowid="" "^^^^^^^^^"
	;根据账单Rowid获取发票信息
	s rtn="",prtRowid=""
	i pattype="I" d
	.;^DHCINVPRTZY(0,"AR",{PRT_ARPBL},{PRT_Rowid})
	.s invNO="",prtDr=""
	.f  s prtDr=$o(^DHCINVPRTZY(0,"AR",billRowid,prtDr),-1) q:(prtDr="")!(rtn'="")  d
	..s data=$g(^DHCINVPRTZY(prtDr))
	..s prtFlag=$p(data,"^",8)
	..q:prtFlag'="N" ;过滤非正常状态的发票
	..s invNO=$p(data,"^",1)
	.s prtUser=$p(data,"^",7)
	.s prtDate=$p(data,"^",2)
	.i prtDate'="" s prtDate=$zd(prtDate,3)
	.s rtn=prtRowid_"^"_invNO_"^"_prtUser_"^"_prtDate 
	i pattype="O" d
	.;^DHCBCI
	.s bcidr=""
	.f  s bcidr=$o(^DHCBCI(0,"Bill",billRowid,bcidr),-1) q:(bcidr=""!rtn'="")  d
	.s prtRowid=$p(^DHCBCI(bcidr),"^",1)
	.s data=$g(^DHCINVPRT(prtRowid))
	.s prtFlag=$p(data,"^",8)
	.q:prtFlag'="N"
	.s invNO=$p(data,"^",14)
	.s prtUser=$p(data,"^",21)
	.s prtDate=$p(data,"^",5)
	.i prtDate'="" s prtDate=$zd(prtDate,3)
	.s rtn=prtRowid_"^"_invNO_"^"_prtUser_"^"_prtDate
	q rtn
}

}
