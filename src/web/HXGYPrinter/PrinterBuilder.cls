Class web.HXGYPrinter.PrinterBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetInitPrintInfo(EpisodeID As %String, PrescNo As %String) As %String
{
	s XMLNameflag="1"

	s PAPMIDR=$p(^PAADM(EpisodeID),"^",1)
	s Birthday=$p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	s Age=($p($h,",",1)-Birthday)\365.25
	
	//presctyp^age
	q XMLNameflag_"^"_Age
}

ClassMethod GetPrescStr(AdmDR As %String, delmet As %String) As %String
{
	s retPrescStr=""
	s del="^"
	s ORDDR=$o(^OEORD(0,"Adm",AdmDR,0)) //421798
	for i=1:1:$g(^OEORD(ORDDR,"I",0))
	{
		s ordstr1=$g(^OEORD(ORDDR,"I",i,1))
		s ordstr2=$g(^OEORD(ORDDR,"I",i,2))
		s ordstr3=$g(^OEORD(ORDDR,"I",i,3))
		s ArcimId=$p(ordstr1,del,2)
		s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(""_ArcimId)
		s ArcType=$p(ArcStr,del,10)
		if (ArcType="R") //药品医嘱
		{
			s Billed=$p(ordstr3,del,5)
			if (Billed="P") //已付费
			{
				s ArcP=$p(ArcimId,"||",1)
				s ArcS=$p(ArcimId,"||",2)
				s PHCGEDR=""
				
				s PHCGEDR=$p($g(^ARCIM(ArcP,ArcS,8)),del,20) 
				s phcgestr=$p(^PHCGE("GE",PHCGEDR),del,1) //通用名
				
				s dosegetstr="" ;"用量" //用量
				
				s inci=""
				s inci=$o(^INCI(0,"ARCIM_DR",ArcP,inci)) //756
				s inci=$p(inci,$c(1),1)
				s phgg=$p($g(^INCI(inci,3)),"^",9)
				s:phgg'="" phgg=phgg_"?"
				s phqty=""
				s phqty=$p(ordstr2,del,1)
				s phunitdr=$p(ordstr2,del,3)
				s phunit=$p(^CT("UOM",phunitdr),"^",2)
				s dosegetstr=phgg_phqty_phunit
				
				s instrgetstr="" //"用法" //用法
				
				s instrdr="" s instrdr=$p($g(^OEORD(ORDDR,"I",i,2)),"^",7)
				i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
				s tidstr=""
				s phcfrdr=$p(ordstr2,del,4)
				s tidstr=$p(^PHCFR(phcfrdr),"^",3)
				s instrdesc=tidstr_"  "_instrdesc
	
	
				s phbz="",bz=0,bb=0
				s bz=$g(^OEORD(ORDDR,"I",i,"DEP",0))
				f bb=1:1:bz  d
		        .s phbz0=""
		        .s phbz0=$g(^OEORD(ORDDR,"I",i,"DEP",bb))
		        .s phbz=phbz_phbz0
				i instrdesc["遵医嘱" s instrdesc=phbz
				
				s instrgetstr=instrdesc
	
				s retPrescStr=retPrescStr_phcgestr_"^"_dosegetstr_"^Sig:  "_instrgetstr_"^"_$C(2)
			}
		}
	}
	q retPrescStr
}

ClassMethod GetPrintPrescInfo(JSFunName As %String, TempletName As %String = "", InPrescNo As %String, InPrescTypeDesc As %String = "") As %String
{
	Quit:$g(InPrescNo)="" ""	
	s PrescNo=InPrescNo
	d InitVar
	d GetBaseVar(PrescNo,InPrescTypeDesc)
	//s (PatNo,PatLoc,fb,PrescType,PatName,PatSex,PatAge,AdmDate,PatID,PatICD,windesc,DoctName,DoctCode,TotalMoney,txtList)=""
	s prtFieldInfo="PatNo"_$c(2)_PatNo
	s prtFieldInfo=prtFieldInfo_"^"_"PatLoc"_$c(2)_PatLoc
	s prtFieldInfo=prtFieldInfo_"^"_"fb"_$c(2)_fb
	s prtFieldInfo=prtFieldInfo_"^"_"PrescType"_$c(2)_PrescType
	s prtFieldInfo=prtFieldInfo_"^"_"PatName"_$c(2)_PatName
	s prtFieldInfo=prtFieldInfo_"^"_"PatSex"_$c(2)_PatSex
	s prtFieldInfo=prtFieldInfo_"^"_"PatAge"_$c(2)_PatAge
	s prtFieldInfo=prtFieldInfo_"^"_"AdmDate"_$c(2)_AdmDate
	s prtFieldInfo=prtFieldInfo_"^"_"PatID"_$c(2)_PatID
	s prtFieldInfo=prtFieldInfo_"^"_"PatICD"_$c(2)_PatICD
	s prtFieldInfo=prtFieldInfo_"^"_"windesc"_$c(2)_windesc
	s prtFieldInfo=prtFieldInfo_"^"_"DoctName"_$c(2)_DoctName
	s prtFieldInfo=prtFieldInfo_"^"_"DoctCode"_$c(2)_DoctCode
	s prtFieldInfo=prtFieldInfo_"^"_"TotalMoney"_$c(2)_TotalMoney

		
	s prtFieldInfo=prtFieldInfo_..getPrintPrescStr(PrescNo)
	//s prtListInfo=..getPrintPrescStr(PrescNo)未使用ListInfo
	s prtListInfo=""
	set rtnval=JSFunName_"('"_$ZCVT($g(prtFieldInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
		
	Quit "0"  
InitVar
	s (PatNo,PatLoc,fb,PrescType,PatName,PatSex,PatAge,AdmDate,PatID,PatICD,windesc,DoctName,DoctCode,TotalMoney,txtList)=""
	Quit
GetBaseVar(cPrescNo,cPrescTypeDesc)
	s OrdDR=$o(^OEORD(0,"PrescNo",cPrescNo,0))
	s OrdItmDR=$o(^OEORD(0,"PrescNo",cPrescNo,OrdDR,0))
	s EpisodeID=$p(^OEORD(OrdDR),"^",1)
		s PAADMDR=EpisodeID
	s PAPMIDR=$p(^PAADM(EpisodeID),"^",1)
	s PatNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",2)
		s PatLocDr=$p(^PAADM(PAADMDR),"^",4)
	s PatLoc = $p(^CTLOC(PatLocDr),"^",2)
		s fbdr=$p(^PAADM(EpisodeID,1),"^",7)
	s fb=$p(^PAC("ADMREA",fbdr),"^",2)
	s PrescType=cPrescTypeDesc
	s PatName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
		s SexDR=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
	s PatSex=$p(^CT("SEX",SexDR),"^",2)
		s Birthday=$p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	s Age=$$CalAge^at182(Birthday,+$H,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	
	if AgeYear>14 s AgeDesc=AgeYear_"岁"
	else  d
	.i AgeYear=0 s AgeYear=""
	.i AgeMonth=0 s AgeMonth=""
	.i AgeDay=0 s AgeDay=""
	.s AgeDesc=AgeYear_"岁"_AgeMonth_"月"_AgeDay_"天"
	s PatAge=AgeDesc
	
	s AdmDate=$zd($p(^PAADM(PAADMDR),"^",6),3)
	s PatID=$p($g(^PAPER(PAPMIDR,"ALL")),"^",9)
		s mradm=$p(^PAADM(EpisodeID),"^",61)
		s mrdia="0"
		s allicd=""
		f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	    .s icdcode="",desc=""
	    .s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	    .i icdcode'=0 s desc=$p(^MRC("ID",icdcode),"^",2)
	    .i desc'=""  d
	    ..i allicd="" s allicd=desc
	    ..e  s allicd=allicd_";"_desc
 s mricd=allicd
	s PatICD="" //mricd 
	s windesc=""
		s orddoctco = $p(^PAADM(PAADMDR),"^",9)
	s DoctName=$p($g(^CTPCP(orddoctco,1)),"^",2)
	s DoctCode=$p($g(^CTPCP(orddoctco,1)),"^",1)
	s TotalMoney=""
		s TotalMoney=..getTotalMoneyByPrescNo(cPrescNo)
	s txtList=""
	Quit
}

/// getSpecialDiseaseInfo
ClassMethod GetSpecialDiseaseInfo(JSFunName As %String, TempletName As %String = "", InPAAdm As %String) As %String
{
	Quit:$g(InPAAdm)="" ""	
	s PAADMDR=InPAAdm
	d InitVar
	d GetBaseVar(PAADMDR)
	
	s prtFieldInfo="PrnName"_$c(2)_PrnName
	set prtFieldInfo=prtFieldInfo_"^"_"Gender"_$c(2)_Gender
	set prtFieldInfo=prtFieldInfo_"^"_"Age"_$c(2)_Age
	set prtFieldInfo=prtFieldInfo_"^"_"SINo"_$c(2)_SINo
	set prtFieldInfo=prtFieldInfo_"^"_"Doctor"_$c(2)_Doctor
	set prtFieldInfo=prtFieldInfo_"^"_"PrnYear"_$c(2)_PrnYear
	set prtFieldInfo=prtFieldInfo_"^"_"PrnMonth"_$c(2)_PrnMonth
	set prtFieldInfo=prtFieldInfo_"^"_"PrnDay"_$c(2)_PrnDay
		
	
	s prtListInfo=$$GetDetails(PAADMDR)	
	s prtImageInfo=$$GetImages(PAADMDR)
	
	/*
	s prtFieldInfo="PrnName"_$C(2)_".^Gender"_$C(2)_"男^Age"_$C(2)_"48^SINo"_$C(2)_"^Doctor"_$C(2)_"李静^Year"_$C(2)_"^Month"_$C(2)_"^Day"_$C(2)
 s prtListInfo="PrescList"_$C(2)
 _"PrescDesc^PrescNotes^PrescMark"_$C(2)
 _"处方描述0^处方备注0^处方说明0"_$C(2)
 _"处方描述1^处方备注1^处方说明1"_$C(2)
 _$C(1)
				_"DiagnList"_$C(2)
				_"Diagn^"_$C(2)
 _"诊断描述0^"_$C(2)
 _"诊断描述1^"_$C(2)

	s prtImageInfo="FieldName^fldSign"_$C(2)_"ImageName^5"_$C(2)_"BorderStyle^1"_$C(2)_"ImageAlign^6"
 _$C(1)
 _"FieldName^fldSign2"_$C(2)_"ImageName^15"
 */
	set rtnval=JSFunName_"('"_$ZCVT($g(prtFieldInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"','"_$ZCVT($g(prtImageInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
		
	Quit "0"  
InitVar
	s (PrnName,Gender,Age,SINo,Doctor,PrnYear,PrnMonth,PrnDay)=""
	Quit
GetBaseVar(PAADMDR)
	s PAPMIDR=$p(^PAADM(PAADMDR),"^",1)
	s PAPERName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	s SexDR=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
	s SexDesc=$p(^CT("SEX",SexDR),"^",2)
	s Birthday=$p(^PAPER(PAPMIDR,"ALL"),"^",6)
	s Age=(+$p($h,",",1)-Birthday)\365.25
	s AdmDocCodeDR = $p(^PAADM(PAADMDR),"^",9)
	s CTPCPDR=AdmDocCodeDR
	s CTPCPDesc = $p(^CTPCP(CTPCPDR,1),"^",2)

	s PrnName=PAPERName
	s Gender=SexDesc
	s Age=Age
	s SINo=""
	s Doctor=CTPCPDesc
	s PrnYear=$p($zd($h),"/",3)
	s PrnMonth=$p($zd($h),"/",1)
	s PrnDay=$p($zd($h),"/",2)
	Quit
GetDetails(inAdmDR)
	/*
	/_"DiagnList"_$C(2)
 _"DiagnCode^DiagnDesc^"_$C(2)
 _"诊断0^诊断描述0^"_$C(2)
	*/
	s retStr=""
	
	s mrdiagdescstr="DiagnDescList"_$C(2)
					_"DiagnDesc^"_$C(2)
	s mrdiagstr="DiagnList"_$C(2)
				_"Diagn^"_$C(2)
	s prescstr="PrescList"_$C(2)
				_"PrescDesc^PrescDose^PrescInstr^"_$C(2)
	s MRAdmRowid=$p($g(^PAADM(inAdmDR)),"^",61)
	
	//病史特征
	s getmrdiagdescstr=""
	s:MRAdmRowid'="" getmrdiagdescstr=##class(web.DHCMRDiagnos).GetMRDIASignSymDesc(MRAdmRowid,$C(2))
	
	s mrdiagdescstr=mrdiagdescstr_getmrdiagdescstr
	
	//诊断
	s getmrdiagstr=""
	s:MRAdmRowid'="" getmrdiagstr=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmRowid,$C(2))
	s mrdiagstr=mrdiagstr_getmrdiagstr

	//处方
	s getprescstr=""
	s:inAdmDR'="" getprescstr=..GetPrescStr(inAdmDR,$C(2))
	s prescstr=prescstr_getprescstr
	s retStr=mrdiagdescstr_$C(1)_mrdiagstr_$C(1)_prescstr
	
	q retStr
GetImages(inAdmDR)
	q "FieldName^fldSign"_$C(2)_"ImageName^"_%session.Get("LOGON.USERID")_$C(2) _"CustomSize^1"_$C(2)
	//q ""
}

ClassMethod getPrintPrescStr(prescno As %String)
{
	s del="^"
	s stopCode=$o(^OEC("OSTAT",0,"Code","D",0))
	s retStr=""
	s orddr=0
	s orddr=$o(^OEORD(0,"PrescNo",prescno,orddr))
	s xx=1
	while (orddr'="")
	{
		s orditmdr=0
		s orditmdr=$o(^OEORD(0,"PrescNo",prescno,orddr,orditmdr))
		while (orditmdr'="")
		{
			s ordstr1=$g(^OEORD(orddr,"I",orditmdr,1))
			s ordstr2=$g(^OEORD(orddr,"I",orditmdr,2))
			s ordstr3=$g(^OEORD(orddr,"I",orditmdr,3))
			s ordstr9=$g(^OEORD(orddr,"I",orditmdr,9))
			s ArcimId=$p(ordstr1,del,2)
			s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(""_ArcimId)
			s ArcType=$p(ArcStr,del,10)
			if (ArcType="R") //药品医嘱
			{
				s OrdStatus=$p(ordstr1,del,13)
				if (stopCode'=OrdStatus)
				{
				//s Billed=$p(ordstr3,del,5)
				//if (Billed="P") //已付费
				//{
					s ArcP=$p(ArcimId,"||",1)
					s ArcS=$p(ArcimId,"||",2)
					
					//s PHCGEDR=""
					//s PHCGEDR=$p($g(^ARCIM(ArcP,ArcS,8)),del,20) 
					//s phcgestr=$p(^PHCGE("GE",PHCGEDR),del,1) //通用名
					
					s phdesc=""
					s incTYdesc=""
					s phdesc=$p(^ARCIM(ArcP,ArcS,1),"^",2)
					s genric=$p(^ARCIM(ArcP,ArcS,8),"^",20)
					i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
					s ypmc=phdesc_"("_incTYdesc_")"
					s phcgestr=ypmc
					
					//规格
					s phgg=""
					s itmmastid=ArcP
					s inci=""
					s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
					s inci=$p(inci,$c(1),1)
					s phgg=$p($g(^INCI(inci,3)),"^",9)
					
					
					s dosegetstr="" ;"用量" //用量
				
					s inci=""
					s inci=$o(^INCI(0,"ARCIM_DR",ArcP,inci)) //756
					s inci=$p(inci,$c(1),1)
					s phgg=$p($g(^INCI(inci,3)),"^",9)
					s:phgg'="" phgg=phgg_"?"
					s phqty=""
					s phqty=$p(ordstr9,del,4)
					
					s phunitdr=$p($g(^ARCIM(ArcP,ArcS,8)),del,14) 
					s phunit=$p(^CT("UOM",phunitdr),"^",2)
					;i phunit["(" s phunit=$p(phunit,"(",1)
					s dosegetstr=phgg_phqty_phunit
					
					
					s instrgetstr="" //"用法" //用法
					
					s instrdr="" s instrdr=$p($g(^OEORD(orddr,"I",orditmdr,2)),"^",7)
					i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
					s tidstr=""
					s phcfrdr=$p(ordstr2,del,4)
					s tidstr=$p(^PHCFR(phcfrdr),"^",3)
					s instrdesc=tidstr_"  "_instrdesc
		
		
					s phbz="",bz=0,bb=0
					s bz=$g(^OEORD(orddr,"I",orditmdr,"DEP",0))
					f bb=1:1:bz  d
			        .s phbz0=""
			        .s phbz0=$g(^OEORD(orddr,"I",orditmdr,"DEP",bb))
			        .s phbz=phbz_phbz0
					i instrdesc["遵医嘱" s instrdesc=phbz
					
					s instrgetstr=instrdesc
		
					s produstr=""
					s itmmastid=ArcP
					s itmmastver=ArcS
					s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
					i drgform'=""  d
				       .s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
				       .s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
				     e  d
				       .s phcform="",phfact=""
			         i phfact=""  s factdesc="" 
			         e  d
			           .i '$d(^PHMNF(phfact))  s factdesc="" 
			           .e  s factdesc=$p(^PHMNF(phfact),"^",2)  
			        i factdesc["-" s factdesc=$p(factdesc,"-",2)  
					s produstr=factdesc
					
					s retStr=retStr_"^txt"_xx_"1"_$C(2)_phcgestr
					s retStr=retStr_"^txt"_xx_"2"_$C(2)_phgg ;规格
					s retStr=retStr_"^txt"_xx_"3"_$C(2)_dosegetstr
					s retStr=retStr_"^txt"_xx_"4"_$C(2)_"Sig:"
					s retStr=retStr_"^txt"_xx_"5"_$C(2)_instrgetstr
					s retStr=retStr_"^txt"_xx_"6"_$C(2) ;_produstr不打印厂家
					s xx=xx+1
				}
			}
			s orditmdr=$o(^OEORD(0,"PrescNo",prescno,orddr,orditmdr))
		}
		s orddr=$o(^OEORD(0,"PrescNo",prescno,orddr))
	}
	q retStr
}

ClassMethod getTotalMoneyByPrescNo(prescno As %String)
{
	;s ^zTom("prescno")=prescno
	s del="^"
	s stopCode=$o(^OEC("OSTAT",0,"Code","D",0))
	s retMoney=""
	s orddr=0
	s orddr=$o(^OEORD(0,"PrescNo",prescno,orddr))
	while (orddr'="")
	{
		s orditmdr=0
		s orditmdr=$o(^OEORD(0,"PrescNo",prescno,orddr,orditmdr))
		while (orditmdr'="")
		{
			
			s ordstr=$g(^OEORD(orddr,"I",orditmdr))
			s ordstr1=$g(^OEORD(orddr,"I",orditmdr,1))
			s ordstr2=$g(^OEORD(orddr,"I",orditmdr,2))
			s ordstr9=$g(^OEORD(orddr,"I",orditmdr,9))
			
			s OrdItmPrice=0
			s ArcimId=$p(ordstr1,"^",2)
			s PatType=""
			s InsType=""
			s InstrRowid=""
			s ARCIMRowid=ArcimId
			s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(ArcimId)
			i ArcStr'=""
			{
				s ArcType=$p(ArcStr,del,10)
				if (ArcType="R") //药品医嘱
				{
					s OrdStatus=$p(ordstr1,del,13)
					if (stopCode'=OrdStatus)
					{
						s OrderPackQty=+$p(ordstr9,"^",4)
						s ArcimDesc=$p(ArcStr,del,3)
						s OrdStatus=$p(ordstr1,del,13)
						s OrderSttDate=$p($h,",",1)
						s:ordstr'="" OrderSttDate=+$p(ordstr,"^",9)
						s PriorRowid=$p(ordstr,"^",8)
						s:$g(ordstr2)'="" InstrRowid=$p(ordstr2,"^",7)
						s LinkTo=""
						s OEPrice=""
						s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
						s OrdItmPrice=+$P(retPrice,"^",1)
						s OrderSum=OrderPackQty*OrdItmPrice
						s retMoney=retMoney+OrderSum
					}
				}
			}
			s orditmdr=$o(^OEORD(0,"PrescNo",prescno,orddr,orditmdr))
		}
		s orddr=$o(^OEORD(0,"PrescNo",prescno,orddr))
	}
	q $Justify(retMoney,0,2)
}

}
