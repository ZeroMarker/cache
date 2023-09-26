Class web.DHCCRM.CRMGrowthCurve Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod RegNoMask(RegNo)
{
	s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
	i length=0 s length=10
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

/// w ##class(web.DHCCRM.CRMGrowthCurve).GetWHInfoBy0to2()
ClassMethod GetWHInfoBy0to2(PAPMI)
{
	;s patno=##class(web.DHCPE.DHCPECommon).UnEscape(patno)
	;s patno=..RegNoMask(patno)
	s ret=""
	;s PAPMI=$o(^PAPERi("PAPMI_PatNo",patno,0))
	s Sex="M"
	s Dob=$p(^PAPER(PAPMI,"ALL"),"^",6)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMI,"ALL")),"^",7))),"^",1)
	if Sex="1" s Sex="M"
	if Sex="2" s Sex="F"
	
	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM)) q:PAADM=""  d
	.s LPADMDate=$p(^PAADM(PAADM),"^",6)
	.q:LPADMDate-Dob<=0
	.s Month=(LPADMDate-Dob)/30
	.s Month=$j(Month,3,1)
	.q:Month>24
	.;s Info=##class(Nur.DHCMoudData).GetThreeInfoByAdmold(PAADM)
	.s Info=..GetThreeInfoByAdmold(PAADM)
	.s Height=$p(Info,"^",1)
	.q:Height=""
	.s Weight=$p(Info,"^",2)
	.q:Weight=""
	.i ret="" s ret=Weight_"$"_Height_"$"_Month_"$"
	.e  s ret=ret_"^"_Weight_"$"_Height_"$"_Month_"$"
	
	q ret_$c(1)_Sex
}

ClassMethod GetWHInfoBy2to5(PAPMI)
{
	;s patno=##class(web.DHCPE.DHCPECommon).UnEscape(patno)
	;s patno=..RegNoMask(patno)
	s ret=""
	s Sex="M"
	;s PAPMI=$o(^PAPERi("PAPMI_PatNo",patno,0))
	s Dob=$p(^PAPER(PAPMI,"ALL"),"^",6)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMI,"ALL")),"^",7))),"^",1)
	i Sex="1" s Sex="M"
	i Sex="2" s Sex="F"
	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM)) q:PAADM=""  d
	.s LPADMDate=$p(^PAADM(PAADM),"^",6)
	.q:LPADMDate-Dob<=0
	.s Month=(LPADMDate-Dob)/30
	.s Month=$j(Month,3,1)
	.q:Month<24
	.q:Month>60
	.s Month=Month-24
	.;s Info=##class(Nur.DHCMoudData).GetThreeInfoByAdmold(PAADM)
	.s Info=..GetThreeInfoByAdmold(PAADM)
	.s Height=$p(Info,"^",1)
	.q:Height=""
	.s Weight=$p(Info,"^",2)
	.q:Weight=""
	.i ret="" s ret=Weight_"$"_Height_"$"_Month_"$"
	.e  s ret=ret_"^"_Weight_"$"_Height_"$"_Month_"$"
	q ret_$c(1)_Sex
}

/// w ##class(web.DHCCRM.CRMGrowthCurve).GetTInfoBy0to5()
ClassMethod GetTInfoBy0to5(PAPMI)
{
	;s patno=##class(web.DHCPE.DHCPECommon).UnEscape(patno)
	;s patno=..RegNoMask(patno)
	s ret=""
	s Sex="M"
	;s PAPMI=$o(^PAPERi("PAPMI_PatNo",patno,0))
	s Dob=$p(^PAPER(PAPMI,"ALL"),"^",6)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMI,"ALL")),"^",7))),"^",1)
	i Sex="1" s Sex="M"
	i Sex="2" s Sex="F"
	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM)) q:PAADM=""  d
	.s LPADMDate=$p(^PAADM(PAADM),"^",6)
	.q:LPADMDate-Dob<=0
	.s Month=(LPADMDate-Dob)/30
	.s Month=$j(Month,3,1)
	.q:Month>60
	.;s Info=##class(Nur.DHCMoudData).GetThreeInfoByAdmold(PAADM)
	.s Info=..GetThreeInfoByAdmold(PAADM)
	.s HeadCircum=$p(Info,"^",3)
	.q:HeadCircum=""
	.i ret="" s ret=HeadCircum_"$"_Month_"$"
	.e  s ret=ret_"^"_HeadCircum_"$"_Month_"$"
	q ret_$c(1)_Sex
}

ClassMethod GetWHInfoBy2to20(PAPMI)
{
	;s patno=##class(web.DHCPE.DHCPECommon).UnEscape(patno)
	;s patno=..RegNoMask(patno)
	s ret=""
	s Sex="M"
	;s PAPMI=$o(^PAPERi("PAPMI_PatNo",patno,0))
	s Dob=$p(^PAPER(PAPMI,"ALL"),"^",6)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMI,"ALL")),"^",7))),"^",1)
	i Sex="1" s Sex="M"
	i Sex="2" s Sex="F"
	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM)) q:PAADM=""  d
	.s LPADMDate=$p(^PAADM(PAADM),"^",6)
	.q:LPADMDate-Dob<=0
	.s Month=(LPADMDate-Dob)/30
	.s Month=$j(Month,3,1)
	.q:Month<24
	.q:Month>240
	.s Month=(Month-24)/3
	.;s Info=##class(Nur.DHCMoudData).GetThreeInfoByAdmold(PAADM)
	.s Info=..GetThreeInfoByAdmold(PAADM)
	.s Height=$p(Info,"^",1)
	.q:Height=""
	.s Weight=$p(Info,"^",2)
	.q:Weight=""
	.i ret="" s ret=Weight_"$"_Height_"$"_Month_"$"
	.e  s ret=ret_"^"_Weight_"$"_Height_"$"_Month_"$"
	q ret_$c(1)_Sex
}

/// w ##class(web.DHCCRM.CRMGrowthCurve).GetSignInfo()
ClassMethod GetSignInfo(PAPMI)
{
	i PAPMI="" q "{results:0,rows:[{}]}"
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="Item4^Item5^Item8^Item2^Item3^Item9^Item1^Item17^Item18^Item19^Item6^Item7^Item13^Item14^Item15^Item16^Item20^EmrDate"
	s count=0

	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM),-1) q:PAADM=""  d
	.;s tmp=##class(Nur.DHCMoudData).GetThreeInfoByAdm(PAADM)
	.s tmp=..GetThreeInfoByAdm(PAADM)
	.q:tmp=""
	.d json.InsertRowData(tmp)
	.s count=count+1
	s jsonStr = json.getJsonData(jsonTitle,count)

 	k json
	q jsonStr
}

ClassMethod GetThreeInfoByAdmold()
{
q ""
}

ClassMethod GetThreeInfoByAdm()
{
q ""
}

}
