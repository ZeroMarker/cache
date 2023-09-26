Import SQLUser

/// 医保就诊信息类
Class web.DHCINSUSpecInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存
ClassMethod Save(InString As %String) As %String
{
	
	n (InString)
	q:InString="" -100
	i $p(InString,"^",2)=""   d
	.s $p(InString,"^",2)=##class(web.DHCINSUSpecInfo).GetSQDH()
	s Save=$$Save^DHCINSUSpecInfo(InString)
	q Save
}

/// w ##class(web.DHCINSUSpecInfo).CheckSpecLoc(CardNo)
ClassMethod CheckSpecLoc(CardNo As %String) As %String
{
	n (CardNo)
	s ^yjz(1)=CardNo
	s OutStr=""
	s SpecDr=""
	q:('$d(^DHCINSPEC("0","YBKH",CardNo))) OutStr
	f  s SpecDr=$o(^DHCINSPEC("0","YBKH",CardNo,SpecDr))  q:SpecDr=""  d
	.s OutStr=""
	.s SpecInfo=$g(^DHCINSPEC(SpecDr))
	.s DJRQ=$p(SpecInfo,"^",13)
	.q:(+$h-DJRQ)>180			;大病登记的有效期为半年，这里暂时写死180天，
	.s SFXZ=+$p(SpecInfo,"^",24)			;是否科室限制
	.q:SFXZ=0
	.s JBZD=$p(SpecInfo,"^",23)
	.q:(JBZD="")
	.s INDIDDr=""
	.f  s INDIDDr=$o(^DHCINDID("0","ITypeCode","SpecLocCon",JBZD,INDIDDr))  q:INDIDDr=""  d
	..s s=$g(^DHCINDID(INDIDDr))
	..s DicBill1=$p(s,"^",4)
	..s CTLocDr=+$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DicBill1),""))
	..q:CTLocDr=0
	..i OutStr=""  d
	...s OutStr=CTLocDr
	..e  s OutStr=OutStr_"^"_CTLocDr 
	q OutStr
}

/// w ##class(web.DHCINSUSpecInfo).GetZLXMByCardNo(P12900753)
ClassMethod GetZLXMByCardNo(CardNo As %String) As %String
{
	n (CardNo)
	s OutStr=""
	s SpecDr=""
	q:('$d(^DHCINSPEC("0","YBKH",CardNo))) OutStr
	f  s SpecDr=$o(^DHCINSPEC("0","YBKH",CardNo,SpecDr))  q:SpecDr=""  d
	.s OutStr=""
	.s SpecInfo=$g(^DHCINSPEC(SpecDr))
	.s DJRQ=$p(SpecInfo,"^",13)
	.q:(+$h-DJRQ)>180			;大病登记的有效期为半年，这里暂时写死180天，
	.s JBZD=$p(SpecInfo,"^",23)
	.q:(JBZD="")
	.s ZLXM=$p(SpecInfo,"^",6)
	.i ZLXM'=""  s OutStr=OutStr_"^"_ZLXM
	.s ZLXM2=$p(SpecInfo,"^",7)
	.i ZLXM2'=""  s OutStr=OutStr_"^"_ZLXM2
	.s ZLXM3=$p(SpecInfo,"^",19)
	.i ZLXM3'=""  s OutStr=OutStr_"^"_ZLXM3
	.s ZLXM4=$p(SpecInfo,"^",20)
	.i ZLXM4'=""  s OutStr=OutStr_"^"_ZLXM4
	q OutStr
}

ClassMethod QueryDocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDocInfoExecute(ByRef qHandle As %Binary, AdmReason As %String, YLZBH As %String, Name As %String, SFZH As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDiv 
	set Data=$lb()
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryDocInfo(AdmReason As %String, YLZBH As %String, Name As %String, SFZH As %String) As %Query(ROWSPEC = "TXXLX:%String,TYLZBH:%String,TYLZZT:%String,TSBCARD:%String,TTXM:%String,TSFZH:%String,TName:%String,TXB:%String,TCSNY:%String,TFYID:%String,TFFXZID:%String,TRZID:%String,TJBID:%String,TBZNY:%String,TYYDH:%String,TDWDM:%String,TDWXZDM:%String,TDWMC:%String,TDWDZ:%String,TDWDH:%String,TDWYB:%String,TJTZZ:%String,TZZDH:%String,TZZYB:%String,TiDate:%String,TStaDate:%String,TEndDate:%String,TAdmReason:%String,TYearStrDate:%String,TMZQFD:%String,TMZLJ:%String,TZYQFX:%String,TNDLJ:%String,TZYCS:%String,TTZLX:%String,TZCYYDM:%String,TZCKSMC:%String,TZCBQMC:%String,TZCCWBH:%String,TZRYYDH:%String,TZRKSMC:%String,TZRBQMC:%String,TRowid:%String,TXXLXDesc:%String")
{
}

Query QueryDic0(txt As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,工号:%String")
{
	SELECT CTPCP_RowId,CTPCP_Code,CTPCP_Desc,CTPCP_TextOne FROM CT_CareProv
	where (length(CTPCP_TextOne)>1	)
}

/// w ##class(web.DHCINSUSpecInfo).GetSpecByCardNo("P01707130")
ClassMethod GetSpecByCardNo(CardNo As %String) As %String
{
	n (CardNo)
	s OutStr="-100"
	s SpecDr="",Rowid="",YSQM="",UserName="",ZLXMDesc="",ZLXM2Desc="",ZLXM3Desc="",ZLXM4Desc=""
	q:('$d(^DHCINSPEC("0","YBKH",CardNo))) OutStr
	f  s SpecDr=$o(^DHCINSPEC("0","YBKH",CardNo,SpecDr))  q:SpecDr=""  d
	.s SpecInfo=$g(^DHCINSPEC(SpecDr))
	.s DJRQ=$p(SpecInfo,"^",13)
	.q:(+$h-DJRQ)>180			;大病登记的有效期为半年，这里暂时写死180天，
	.s SFXZ=+$p(SpecInfo,"^",24)			;是否科室限制
	.s Rowid=SpecDr
	q:Rowid="" OutStr
	s OutStr=$$GetInfoById^DHCINSUSpecInfo(Rowid)
	s YSGH=$p(OutStr,"^",10)
	s CZGH=$p(OutStr,"^",16)
	s JBZD=$p(OutStr,"^",24)
	s ZLXM=$p(OutStr,"^",7)
	s ZLXM2=$p(OutStr,"^",8)
	s ZLXM3=$p(OutStr,"^",20)
	s ZLXM4=$p(OutStr,"^",21)
	i YSGH'=""  d
	.s YSQM=$p($g(^CTPCP(YSGH,1)),"^",2)
	i CZGH'=""  d
	.s UserName=$p($g(^SSU("SSUSR",CZGH)),"^",2)
	i ZLXM'=""  d
	.s ZLXMDesc=$p($$QueryByCode^DHCINSUDicData("ZLXM",ZLXM),"^",4)
	i ZLXM2'=""  d
	.s ZLXM2Desc=$p($$QueryByCode^DHCINSUDicData("ZLXM",ZLXM2),"^",4)
	i ZLXM3'=""  d
	.s ZLXM3Desc=$p($$QueryByCode^DHCINSUDicData("ZLXM",ZLXM3),"^",4)
	i ZLXM4'=""  d
	.s ZLXM4Desc=$p($$QueryByCode^DHCINSUDicData("ZLXM",ZLXM4),"^",4)
	s OutStr=OutStr_"^"_YSQM_"^"_UserName_"^"_ZLXMDesc_"^"_ZLXM2Desc_"^"_ZLXM3Desc_"^"_ZLXM4Desc
	q OutStr
}

ClassMethod GetCurrDate() As %String
{
	s OutStr=$zd(+$h,4)
	q OutStr
}

/// w ##class(web.DHCINSUSpecInfo).GetSQDH()
ClassMethod GetSQDH() As %String
{
	s OutStr=""
	s count=+$g(^CacheTemp("INSUSpec",+$h))+1
	s count=$j(count,2)
	s count=$tr(count," ","0")
	s ^CacheTemp("INSUSpec",+$h)=count
	s OutStr=$zd(+$h,8)_count
	q OutStr
}

}
