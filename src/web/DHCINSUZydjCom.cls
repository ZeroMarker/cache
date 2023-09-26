Import SQLUser

/// 住院登记
Class web.DHCINSUZydjCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

//根据病人登记号得到病人信息列表

ClassMethod GetPaPamasInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatNO As %Library.String = "") As %Library.String
{
	q:PatNO=""	
	s ret=##class(web.DHCINSUPatInfo).GetPatInfoByPatNO(PatNO)
	q ret
}

//根据病人登记号得到病人就诊记录

ClassMethod GetPaAdmListByPatNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "") As %Library.String
{
	q:PapmiNo=""
	s outstr=""
    s PatmasID="0"
    s PaadmRowID="0"
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM","I",PaadmRowID)) q:PaadmRowID=""  d
    .s DepNameId=$P(^PAADM(PaadmRowID),"^",4)
    .s outstr=$p($g(^PAADM(PaadmRowID)),"^",81)_"!"_PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepNameId),"^",2)_"!"_$ZD($p(^PAADM(PaadmRowID),"^",6),3)_"^"_outstr
    s outstr=""_"^"_outstr
    q outstr
}

ClassMethod GetPaAdmListByPatNoIPReg(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "")
{
	q:PapmiNo=""
	s outstr=""
    s PatmasID="0"
    s PaadmRowID="0"
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM","I",PaadmRowID)) q:PaadmRowID=""  d
    .s BillFlag=$P(^PAADM(PaadmRowID),"^",45)
    .q:BillFlag="Y"  d
    .s DepNameId=$P(^PAADM(PaadmRowID),"^",4)
    .s outstr=$p($g(^PAADM(PaadmRowID)),"^",81)_"!"_PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepNameId),"^",2)_"!"_$ZD($p(^PAADM(PaadmRowID),"^",6),3)_"^"_outstr
    s outstr=""_"^"_outstr
    q outstr
}

//根据Adm得到病人就诊信息

ClassMethod GetPaAdmInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm As %Library.String = "") As %String
{
	q:Adm=""	
	s ret=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(Adm)
	q ret
}

//得到医保信息

ClassMethod GetInfoByAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", Paadm As %Library.String = "")
{
	q:Paadm=""
	s ret=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(Paadm)
	q ret
}

//检测病人费用

ClassMethod CheckBillCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", admRowid As %Library.String = "", user As %Library.String = "")
{
	q:admRowid=""
	s err=##class(web.UDHCJFBILL).BILL(admRowid,user)	
	q:$d(^DHCPB(0,"ADM",admRowid))=0 0
	s id=$o(^DHCPB(0,"ADM",admRowid,""))	
	s s=$g(^DHCPB(id))	
	q:+$p(s,"^",8)>0 -1
	q 0
}

//20080828 入院类别

ClassMethod GetAdmTypeByAdm(Paadm As %Library.String = "")
{
	q:Paadm=""
	s ret=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(Paadm)
	s data=$p(ret,"!",2)
    S type=$p(data,"^",15)
	if type="TB"{ s type="特病登记"}
	else  {s type=""} 
	q type
}

}
