Import sqluser

Class web.DHCST.Tools.LoadData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod LoadData(fname, sub, p) As %String
{
 ;fname : the filename including data(必须是全路径)
 ;
 q:fname="" -1
 k ^REJECT($zn)
 w "正在读取数据...",!
 d ..file(fname,sub,p)	
 q 0
}

ClassMethod file(file, sub, p)
{
 ;process file
 ;
 k ^zTSA(p,sub),^TMP(p,sub)
 ;directory where files are 
 s del="^"
 s $zt="close"
 ;s file=file
 w "File Upload Starting...",!
 c file
 o file:"RS"
 u file
 f  d
 . r a
 . ;w a,!
 . s line=$o(^zTSA(p,sub,""),-1)+1
 . s ^zTSA(p,sub,0)=line
 . s ^zTSA(p,sub,line)=$tr(a,$c(9),del)
 q 
close c file
 w "File Upload Finished!",!!
 q
}

/// 导入库存项与收费项的对照关系
/// w ##class(web.DHCST.Tools.LoadData).SetLinkToIncTar()
ClassMethod SetLinkToIncTar()
{
	s inci="",num=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci'>0
	.q:'$d(^INCI(inci,1))
	.s incsc=$p($G(^INCI(inci,2)),"^",2)
 	.q:incsc="" 
 	.s catgrp=$o(^DHCSCG("STKCAT",incsc,""))
 	.q:catgrp=""
 	.s catgrptype=$p(^DHCSCG(catgrp),"^",3)
 	.q:catgrptype'="G"
 	.s catgrpcode=$p(^DHCSCG(catgrp),"^",1)
 	.;q:catgrpcode'="CY"
	.s arcitm=$p(^INCI(inci,1),"^",3)
	.q:arcitm=""
	.s taritm=$o(^DHCOLT(0,"ARTTA",arcitm,""))
	.q:taritm=""
	.s startDate=+$h-99
	.i '$d(^DHCINCTARi("INCI",inci)) d
	..&SQL(INSERT INTO DHC_IncTarRela(INCTR_INCI_Dr,INCTR_Tari_Dr,INCTR_Qty,INCTR_StartDate) values (:inci,:taritm,1,:startDate))
	..i SQLCODE=0 s num=num+1
	q num
}

/// 导入化学通用名
/// w ##class(web.DHCST.Tools.LoadData).SetPHChemical()
ClassMethod SetPHChemical()
{
	s gen="",num=0
	f  s gen=$o(^PHCGE("GE",gen)) q:gen=""  d
	.q:+gen'>0	
	.s gencode=$p(^PHCGE("GE",gen),"^",1)
	.s gendesc=$p(^PHCGE("GE",gen),"^",2)
	.s phcd="",	phccat=""
	.f  s phcd=$o(^PHCD(0,"Gener",gen,phcd)) q:phcd=""  d
	..s phcdf=$o(^PHCD(+phcd,"DF","0"))	
	..q:+phcdf'>"0"	
	..q:'$d(^PHCD(+phcd,"DF",phcdf,"DHC"))
	..s phccat=$p(^PHCD(+phcd,"DF",phcdf,"DHC"),"^",20)
	..q:phccat=""
	..s phcm="",phcmdesctmp=""
	..f  s phcm=$o(^DHCPHCMi("PHCC",phccat,phcm)) q:phcm=""  d
	...s phcmdesc=$p(^DHCPHCM(phcm),"^",2)
	...i phcmdesctmp="" s phcmdesctmp=phcmdesc
	...e  s phcmdesctmp=phcmdesctmp_","_phcmdesc
	..q:(","_phcmdesctmp_",")[(","_gendesc_",")
	..ts
	..&sql(insert into DHC_PHChemical (PHCM_Code,PHCM_Desc,PHCM_PHCC_Dr) values (:gencode,:gendesc,:phccat))
	..s chem=""	
	..i SQLCODE="0"  d
	...s chem=$G(%ROWID)
	..i chem="" tc
	..q:chem=""
	..s sqlcodex=""		
	..&sql(update DHC_PhcGeneric set PHCGE_PHCM_Dr=:chem where PHCGE_PHCGE_DR=:gen)
	..s sqlcodex=SQLCODE
	..i sqlcodex'="0" tc
	..q:sqlcodex'="0"
	..s num=num+1
	..tc
	q num
}

/// 导入住院发药单位和门诊发药单位
/// w ##class(web.DHCST.Tools.LoadData).ImPortUom()
ClassMethod ImPortUom()
{
	s inci="",num=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci'>0
	.q:'$d(^INCI(inci,1))
	.s BaseUomDr=$p($G(^INCI(inci,1)),"^",10)
	.s ArcId=$p(^INCI(inci,1),"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDr=$p(BillUom,"^",1)
	.&sql(update INC_Itm set INCI_CTUOM_OutPat_DR=:BillUomDr,INCI_CTUOM_InPat_DR=:BaseUomDr where INCI_RowId=:inci)
	.i SQLCODE=0 s num=num+1
	q num
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData()
ClassMethod CheckData()
{
	s inci = 0
	for{
		s inci = $O(^INCI(inci))
		q:(inci = "")||(+inci = 0)
		s itm = 0
		for {
			s itm = $O(^INCI(inci, "IL", itm))
			q:(itm = "")
			if $d(^INCI(inci, "IL", itm)) = 10 k ^INCI(inci, "IL", itm) continue
			s incil = inci_"||"_itm
			s incilData = ^INCI(inci, "IL", itm)
			s loc = $P(incilData, "^", 1)
			if (loc = "") w "NULL - "_incil,!
			if (loc = 187) w "187 - "_incil,! k ^INCI(inci, "IL", itm)
			
		}
	}
	q 0
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData2()
ClassMethod CheckData2()
{
	s active= ""
	for{
		s active = $O(^DHCINCLBi("ACIBT", active),-1)
		q:(active = "")
		s inci = 0
		for {
			s inci = $O(^DHCINCLBi("ACIBT", active, 187, inci))
			q:(inci = "")||(+inci = 0)
			s inclb = ""
			for{
				s inclb = $O(^DHCINCLBi("ACIBT", active, 187, inci, inclb))
				q:(inclb = "")
				s il = $P(inclb, "||", 2)
				s lb = $P(inclb, "||", 3)
				if ($D(^INCI(inci, "IL", il, "LB", lb)) = 0) w inclb_"|| "_$D(^INCI(inci, "IL", il, "LB", lb)) ,! k ^DHCINCLBi("ACIBT", active, 187, inci, inclb)
			}
		}
		
	}
	q 0
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData3()
ClassMethod CheckData3()
{
	s inci = 0
	for{
		s inci = $O(^INCI("IL_LOC", 187, inci))
		q:(inci = "")||(+inci = 0)
		s il = "" 
		for {
			s il = $O(^INCI("IL_LOC", 187, inci, il))
			q:(il = "")
			s incil = inci_"||"_il
			if $D(^INCI(inci, "IL", il)) '=11  w incil_"  "_$D(^INCI(inci, "IL", il)),! k ^INCI("IL_LOC", 187, inci, il)
		}
		
	}
	
	q 0
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData4()
ClassMethod CheckData4()
{
	s incib = ""
	for {
		s incib = $O(^DHCINGR(0, "GRI_INCIB", incib))
		q:(incib = "")
		s ingdId = ""
		for {
			s ingdId = $O(^DHCINGR(0, "GRI_INCIB", incib, ingdId))
			q:(ingdId = "")
			s itm = ""
			for {
				s itm = $O(^DHCINGR(0, "GRI_INCIB", incib, ingdId, itm))
				q:(itm = "")
				s ingdiId = ingdId_"||"_itm
				i ($D(^DHCINGR(ingdId, "GRI", itm)) = 0) {
					w ingdiId_"^"_$D(^DHCINGR(ingdId, "GRI", itm)),!
					k ^DHCINGR(0, "GRI_INCIB", incib, ingdId, itm)
				}
			}
		}
	}
	q 0
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData5()
ClassMethod CheckData5()
{
	s inclb = ""
	for {
		s inclb = $O(^DHCINCLB(0, "LB", inclb))
		q:(inclb = "")
		s inci = +inclb
		s il = $P(inclb, "||", 2)
		s lb = $P(inclb, "||", 3)
		s incil = inci_"||"_il
		i (inclb = "1||4||1") w $D(^INCI(inci, "IL", il, "LB", lb)),!
		if ($D(^INCI(inci, "IL", il)) '=11)  w incil_"^"_$D(^INCI(inci, "IL", il)),! k ^DHCINCLB(0, "LB", inclb)
		if ($D(^INCI(inci, "IL", il, "LB", lb)) '= 1) w inclb_"^"_$D(^INCI(inci, "IL", il, "LB", lb)) ,!  k ^DHCINCLB(0, "LB", inclb)
		
	}
	q 0
}

/// W ##Class(web.DHCST.Tools.LoadData).CheckData6()
ClassMethod CheckData6()
{
	s active= ""
	for{
		s active = $O(^DHCINCLBi("ACSTK", active))
		q:(active = "")
		s loc = ""
		for {
			s loc = $O(^DHCINCLBi("ACSTK", active, loc))
			q:(loc = "")
			s inclb = ""
			for {
				s inclb = $O(^DHCINCLBi("ACSTK", active, loc, inclb))
				q:(inclb = "")
				s inci = +inclb
				s il = $P(inclb, "||", 2)
				s lb = $P(inclb, "||", 3)
				if ($D(^INCI(inci, "IL", il, "LB", lb)) '= 1) w inclb ,! k ^DHCINCLBi("ACSTK", active, loc, inclb)
			}
		}
	}
	q 0
}

}
