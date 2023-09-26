Class web.DHCOPCashier3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 44;

/// //版本为3		大同专用
ClassMethod GetToDayAdmStr(PatDr As %String) As %String
{
	n (PatDr)
	Set AdmStr=""
	;
	s myAdmType=0
	
	f  s myAdmType=$o(^PAPERdr(PatDr,"ADM",myAdmType)) q:(myAdmType="")  d
	.q:(myAdmType'="O")&(myAdmType'="E")
	.Set Adm=""
	.For  Set Adm=$O(^PAPERdr(PatDr,"ADM",myAdmType,Adm)) Quit:Adm=""  Do
	..Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	..Quit:AdmDate'=+$H
	..Set VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	..Quit:VisitStatus="C"
	..s CrUserDR=$p($g(^PAADM(Adm)),"^",43)
	..q:CrUserDR=""
	..If AdmStr="" Set AdmStr=Adm
	..Else  Set AdmStr=AdmStr_"^"_Adm
	Quit AdmStr
}

ClassMethod GetAdmDetail(AdmStr As %String) As %String
{
	Set AdmDetailStr=""
	Quit:$g(AdmStr)="" AdmDetailStr
	Set AdmCount=$LENGTH(AdmStr,"^")
	For AdmNum=1:1:AdmCount Do
	.Set Adm=$p(AdmStr,"^",AdmNum)
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Set AdmDateDesc=$ZD($G(AdmDate),3)
	.Set AdmDept=$p($g(^PAADM(Adm)),"^",4)
	.Set AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	.Set AdmDoc=$p($g(^PAADM(Adm)),"^",9)
	.;查询医保对应的信息
	.s myYBType="(自)"
	.;^User.INSUAdmInfoI("IndexOfAdm"
	.s myINSRowID=$o(^User.INSUAdmInfoI("IndexOfAdm"," "_Adm,0))
	.i myINSRowID'="" d
	..s myYBType="(医)"
	.If AdmDoc'="" Do
	..Set AdmDocName=$p($g(^CTPCP(AdmDoc,1)),"^",2)
	.Else  Set AdmDocName=""
	.If AdmDeptDesc["-" Set AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	.Set AdmDocDept=myYBType_AdmDeptDesc_AdmDocName
	.Set MRADM=$p($g(^PAADM(Adm)),"^",61)
	.Set PAPMI=$p($g(^PAADM(Adm)),"^",1)
	.Set AdmReason=$p($g(^PAADM(Adm,1)),"^",7)
	.If AdmReason="" Set AdmReason=..GetInsTypeFromPat(PAPMI)
	.;If AdmReason="" Set AdmReason=
	.Set AdmDetail=AdmDocDept_"^"_Adm_"^"_MRADM_"^"_AdmDateDesc_"^"_AdmDept_"^"_AdmDoc_"^"_AdmDocName_"^"_AdmReason
	.Set AdmBillSum=##class(web.DHCOPCashier).GetToBillSum(Adm)
	.Set AdmDetail=AdmDetail_"^"_$p(AdmBillSum,"^",1)_"^"_$p(AdmBillSum,"^",4)
	.If AdmDetailStr="" Set AdmDetailStr=AdmDetail
	.Else  Set AdmDetailStr=AdmDetailStr_$C(2)_AdmDetail
	Quit AdmDetailStr
}

ClassMethod GetInsTypeFromPat(PatDr As %String) As %String
{
	Set PatSocialStatus=$P(^PAPER(PatDr,"PER",1),"^",10)
	Quit:PatSocialStatus="" ""
	Set PToAdm=$O(^DHCPACADM(0,"Social",PatSocialStatus,""))
	Quit:PToAdm="" ""
	Set PatInsType=$p(^DHCPACADM(PToAdm),"^",2)
	Quit PatInsType
}

}
