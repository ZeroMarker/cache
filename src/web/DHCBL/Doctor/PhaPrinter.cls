Class web.DHCBL.Doctor.PhaPrinter Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 诊间导诊单
ClassMethod GetOPDocPrtData(JSFunName As %String, PrtXMLName As %String = "", InvRowID As %String) As %String
{
	k ^CACHETMPTML("PRN")
	s OrdDR=""
	s OrdItmDR=""
	s prtTxtInfo=""
	s prtListInfo=""
	s HaveErr="0"
	s OrdItmLB=$LB("")
	for i=1:1:$l(InvRowID,",")
	{
		s inRow=$p(InvRowID,",",i)
		if (inRow'=""){
			s myOrdDR=$p(inRow,"||",1)
			s myOrdItmDR=$p(inRow,"||",2)
			If ((OrdDR'="")&&(OrdDR'=myOrdDR)){
				s HaveErr="1"
			}
			
			s OrdDR=myOrdDR
			s OrdItmDR=myOrdItmDR
			set getDoc=..GetOrdItmDetail(OrdDR,OrdItmDR)
			s c1DR=$p(getDoc,"^",1)
			s c2DR=$p(getDoc,"^",2)
			
			if ($g(^CACHETMPTML("PRN",c1DR))="")
			{ ;没有
				i ($F(c2DR,"划价")'=0)
				{
					s ^CACHETMPTML("PRN",c1DR_"划价")=c2DR
				}
				else
				{
					s ^CACHETMPTML("PRN",c1DR)=c2DR
				}
			}
			else
			{ ;有
				if ($F(c2DR,"划价")'=0){
					s ^CACHETMPTML("PRN",c1DR_"划价")=c2DR
				}else{
					s lastDR=^CACHETMPTML("PRN",c1DR)
					if (($F(lastDR,"划价")=0)&&($F(c2DR,"划价")=0))
					{
						s ^CACHETMPTML("PRN",c1DR)=lastDR+c2DR
					}
					else
					{
						s ^CACHETMPTML("PRN",c1DR_"划价")=c2DR
					}
				}
			}
		}
	}
	s prtListInfo=""
	s c1DR=""
	s c1DR=$o(^CACHETMPTML("PRN",c1DR))
	while (c1DR'="")
	{
		//不打印价格
		if ($f(^CACHETMPTML("PRN",c1DR),"划价")=0){
			s prtListInfo=prtListInfo_$p(c1DR,"划价",1)_$p(c1DR,"划价",2)_"^"_$C(2) ;_^CACHETMPTML("PRN",c1DR)_"元"_$C(2)
		}else{
			s splitstr=^CACHETMPTML("PRN",c1DR)
			i $l(splitstr)>8
			{
				s splitstr1=$E(splitstr,1,8)
				s splitstr2=$E(splitstr,9,$l(splitstr))
				s prtListInfo=prtListInfo_$p(c1DR,"划价",1)_$p(c1DR,"划价",2)_"^"_splitstr1_$C(2)
				s prtListInfo=prtListInfo_"^"_splitstr2_$C(2)
				
			}
			else
			{
				s prtListInfo=prtListInfo_$p(c1DR,"划价",1)_$p(c1DR,"划价",2)_"^"_splitstr_$C(2)
			}

		}
		s c1DR=$o(^CACHETMPTML("PRN",c1DR))
	}
	Q:HaveErr="1" "0"
	s prtTxtInfo=..GetPerInfoByOrd(OrdDR,OrdItmDR)
	set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	Quit "0"
}

/// 购药单
ClassMethod GetOPPrtData(JSFunName As %String, PrtXMLName As %String = "", InvRowID As %String) As %String
{
	Quit:$g(InvRowID)="" ""	
	s firstORDString=$p(InvRowID,",",2)
	s OrdDR=+$p(firstORDString,"||",1)
	s OrdItmDR=+$p(firstORDString,"||",2)
	q:((OrdDR=0)||(OrdItmDR=0)) "0"
	q:$g(^OEORD(OrdDR,"I",OrdItmDR,3))="" "0"
	s RegNo=$p(^OEORD(OrdDR,"I",OrdItmDR,3),"^",9)
	s PatDr=""
	&sql(select PAPMI_RowId1 into :PatDr from sqluser.PA_PatMas where PAPMI_No=:RegNo)
	Quit:$g(PatDr)="" ""
	
	&sql(select OEORD_RowId1 into :PAADMRowId from sqluser.OE_ORDer where OEORD_RowId=:OrdDR)
	s PAADMNo=""
	&sql(select PAADM_ADMNo into :PAADMNo from sqluser.PA_Adm where PAADM_RowId=:PAADMRowId)
	
	s CheckSign=""
	s INVNo=$zd($h,8)_RegNo
	s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	s PatRegNo=RegNo
	s UserID=%session.Get("LOGON.USERID")
	q:UserID="" "0"

	s PrnName=""
	s PrnName2=""
	s:$g(^SSU("SSUSR",UserID))'="" PrnName=$p(^SSU("SSUSR",UserID),"^",2)   //"打印" //%session.Get("LOGON.USERID")
	i PrnName="" d
	.s UserDR=+$o(^CTPCP(0,"Code",$ZCVT(UserID,"U"),0))
	.s:UserDR'="" PrnName2=$p(^CTPCP(UserDR,1),"^",2)
	.s:PrnName="" PrnName=PrnName2
	s PrnTime=$zd($h,3)
	s SellSign=""
	s TotalMoney=..GetTotalMoney(InvRowID)
	s WindowNo="2"

	s prtTxtInfo="CheckSign"_$c(2)_CheckSign
	set prtTxtInfo=prtTxtInfo_"^"_"INVNo"_$c(2)_INVNo
	set prtTxtInfo=prtTxtInfo_"^"_"PatName"_$c(2)_PatName
	set prtTxtInfo=prtTxtInfo_"^"_"PatRegNo"_$c(2)_PatRegNo
	set prtTxtInfo=prtTxtInfo_"^"_"PrnName"_$c(2)_PrnName
	set prtTxtInfo=prtTxtInfo_"^"_"PrnTime"_$c(2)_PrnTime
	set prtTxtInfo=prtTxtInfo_"^"_"SellSign"_$c(2)_SellSign
	set prtTxtInfo=prtTxtInfo_"^"_"TotalMoney"_$c(2)_TotalMoney
	set prtTxtInfo=prtTxtInfo_"^"_"WindowNo"_$c(2)_WindowNo
	
	set prtListInfo=$$GetDetails(InvRowID)	
	set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
		
	Quit "0"  

GetDetails(OrdString)
	s firstORDString=$p(InvRowID,",",2)
	s OrdDR=$p(firstORDString,"||",1)
	s del="^"
	s stopCode=$o(^OEC("OSTAT",0,"Code","D",0))
	q:^OEORD(OrdDR,"I",0)=0 ""
	s OrdItmDR=0
	s OrdItmDR=+$o(^OEORD(OrdDR,"I",OrdItmDR))
	s retStr=""
	while(OrdItmDR'=0)
	{
		s haveIn=0
		for k=1:1:$l(OrdString,",")
		{
			s inOrdItmDR=$p($p(OrdString,",",k),"||",2)
			if (OrdItmDR=inOrdItmDR)
			{
				s haveIn=1
			}
		}
		if (haveIn=1){
			s ARCPhaName =""
			s Production=""
			s Specification=""
			s NumAndUnit=""
			
			s OrdItmPrice=0
			s ordstr1=$g(^OEORD(OrdDR,"I",OrdItmDR,1))
			s ordstr2=$g(^OEORD(OrdDR,"I",OrdItmDR,2))
			s ordstr3=$g(^OEORD(OrdDR,"I",OrdItmDR,3))
			s ordstr9=$g(^OEORD(OrdDR,"I",OrdItmDR,9))
			s ArcimId=$p(ordstr1,"^",2)
			
			s PatType=""
			s InsType=""
			s InstrRowid=""
			s ARCIMRowid=ArcimId
			s ARCP=$p(ARCIMRowid,"||",1)
			s ARCS=$p(ARCIMRowid,"||",2)
			s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(ArcimId)
			s ArcimDesc=$p(ArcStr,del,3)
			
			s OrdStatus=$p(ordstr1,del,13)
			if ($Find(ArcimDesc,"挂号费")>0)
			{
				s OrderSum=0
			}elseif(stopCode=OrdStatus){
				s OrderSum=0
			}else{
				s OrderSttDate=$p($h,",",1)
				s:$g(^OEORD(OrdDR,"I",OrdItmDR))'="" OrderSttDate=+$p(^OEORD(OrdDR,"I",OrdItmDR),"^",9)
				s PriorRowid=$p(^OEORD(OrdDR,"I",OrdItmDR,1),"^",8)
				s:$g(ordstr2)'="" InstrRowid=$p(ordstr2,"^",7)
				s LinkTo=""
				s OEPrice=""
				s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
				
				s OrdItmPrice=+$P(retPrice,"^",1)
				s OrderPackQty=+$p(ordstr9,"^",4) ;+$p(ordstr1,"^",12)
				s OrderUnit=$p(ordstr3,"^",14)
				s OrderSum=OrderPackQty*OrdItmPrice
				/*
				s sUnit=""
				s sUnitDR=$p(ordstr2,"^",3)
				s:sUnitDR'="" sUnit=$p(^CT("UOM",sUnitDR),"^",1)
				s sUnitQty=$p(ordstr1,"^",12)
				
				s sPack=""
				&sql(Select ARCIM_BillingUOM_DR->CTUOM_Desc into :sPack from sqluser.ARC_ItmMast where arcim_rowid=:ArcimId)
				s Specification=""
				if ((sUnit'="")&&(sPack'="")){
					s Specification=sUnitQty_sUnit_"/"_sPack
				}
				
				s Specification=sPack
				s Specification=""
				s UnitStr=""
				s:OrderUnit'="" UnitStr="("_OrderUnit_")"
				s NumAndUnit=OrderPackQty_sPack ;"*"_OrdItmPrice_UnitStr
				*/
				s dosegetstr="" ;"用量" //用量
				
				s inci=""
				s inci=$o(^INCI(0,"ARCIM_DR",ARCP,inci)) //756
				s inci=$p(inci,$c(1),1)
				s phgg=$p($g(^INCI(inci,3)),"^",9)
				s:phgg'="" phgg=phgg_"?"
				s phqty=""
				s phqty=$p(ordstr9,del,4)
				
				s phunitdr=$p($g(^ARCIM(ARCP,ARCS,8)),del,14) 
				s phunit=$p(^CT("UOM",phunitdr),"^",2)
				;i phunit["(" s phunit=$p(phunit,"(",1)
				s dosegetstr=phgg_phqty_phunit
				s NumAndUnit=dosegetstr
				
				s Production=""
					s PHCDFDR=$p(^ARCIM(ARCP,ARCS,1),"^",12) //114||1
					s PHDP=+$P(PHCDFDR,"||",1)
					s PHDS=+$P(PHCDFDR,"||",2)
					s phmnfstr2=""
					s:((PHDP'=0)&&(PHDS'=0)) phmnfstr2=^PHCD(PHDP,"DF",PHDS,2)
					s PHMNFDR=""
					s:phmnfstr2'="" PHMNFDR=$p(phmnfstr2,"^",4)
					s:PHMNFDR'="" Production=$p(^PHMNF(PHMNFDR),"^",1)
				s ARCPhaName=ArcimDesc
				s retStr=retStr_ARCPhaName_"^"_Specification_"^"_NumAndUnit_"^"_Production_$C(2)
			}
		}
		s OrdItmDR=+$o(^OEORD(OrdDR,"I",OrdItmDR))
	}
	//s myList= "药品^规格^2*10(盒)^广州"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)
	//s myList=myList_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"_$C(2)_"药品2^规格2^3*10(盒)^广州1"
	q retStr
}

ClassMethod GetOrdItmDetail(OrdDR As %String, OrdItmDR As %String) As %String
{
	s del="^"
	s stopCode=$o(^OEC("OSTAT",0,"Desc","停止",0))
	
	s ordstr1=^OEORD(OrdDR,"I",OrdItmDR,1)
	s ordstr3=^OEORD(OrdDR,"I",OrdItmDR,3)
	s ordstr9=^OEORD(OrdDR,"I",OrdItmDR,9)
	s OrderPackQty=0
	s:$g(ordstr9)'="" OrderPackQty=+$P(ordstr9,"^",4)
	//改为帐单大类
	s RecDepDR=$p(ordstr3,"^",6)
	s RecDepSite=$g(^CTLOC(RecDepDR,"ADDR",1))
	
	s OrdGroupDesc=""
	s OrdItmPrice=0
	s ordstr1=$g(^OEORD(OrdDR,"I",OrdItmDR,1))
	s ArcimId=$p(ordstr1,"^",2)
	s ArcIMP=$p(ArcimId,"||",1)
	s ArcIMS=$p(ArcimId,"||",2)
	s ArcIM1=^ARCIM(ArcIMP,ArcIMS,1)
	s ArcimBillSub=$p(ArcIM1,"^",9)
	s ArcBGP=$p(ArcimBillSub,"||",1)
	s RecDepDesc=$p(^ARCBG(ArcBGP),"^",1)
	
	s PatType=""
	s InsType=""
	s ARCIMRowid=ArcimId
	s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(ArcimId)
	s ArcimDesc=$p(ArcStr,del,3)
	s OrdStatus=$p(ordstr1,del,13)
	if ($Find(ArcimDesc,"挂号费")>0) {
		s OrderSum=0
	}elseif(stopCode=OrdStatus){
		s OrderSum=0
	}else{
		s OrderSttDate=$p($h,",",1)
		s:$g(^OEORD(OrdDR,"I",OrdItmDR))'="" OrderSttDate=+$p(^OEORD(OrdDR,"I",OrdItmDR),"^",9)
		s PriorRowid=$p(^OEORD(OrdDR,"I",OrdItmDR,1),"^",8)
		s InstrRowid=$p(^OEORD(OrdDR,"I",OrdItmDR,2),"^",7)
		s LinkTo=""
		s OEPrice=""
		s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
		s OrdItmPrice=+$P(retPrice,"^",1)
		s OrderPackQty=+$p(ordstr1,"^",12)
		s OrderSum=OrderPackQty*OrdItmPrice
		If (OrderSum=0) {
			s OrderSum=RecDepSite_"划价"
		}else{
			s OrderSum=$Justify(OrderSum,0,2)
		}
	}
	s:RecDepDesc="西药费" RecDepDesc="西药"
	q RecDepDesc_"^"_OrderSum
}

ClassMethod GetPerInfoByOrd(OrdDR As %String, OrdItmDR As %String) As %String
{
	q:$g(^OEORD(OrdDR,"I",OrdItmDR,3))="" ""
	s RegNo=$p(^OEORD(OrdDR,"I",OrdItmDR,3),"^",9)
	
	s PatDr=""
	&sql(select PAPMI_RowId1 into :PatDr from sqluser.PA_PatMas where PAPMI_No=:RegNo)
	Quit:$g(PatDr)="" ""
	s PAPMI=""
	&sql(select OEORD_RowId1,OEORD_Adm_DR into :PAADMRowId,:PAPMI from sqluser.OE_ORDer where OEORD_RowId=:OrdDR)
	s PAADMNo=""
	&sql(select PAADM_ADMNo into :PAADMNo from sqluser.PA_Adm where PAADM_RowId=:PAADMRowId)
	s PatRegNo=PAADMNo ;"OP000439877"
	
	s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	s Sex=$p(^CT("SEX",$p(^PAPER(PatDr,"ALL"),"^",7)),"^",2)
	s TBirthday=$p(^PAPER(PatDr,"ALL"),"^",6)
	s TAge=($p($h,",",1)-TBirthday)\365.5
	s Age=TAge_"岁"

		s UserDR=$p(^PAADM(PAPMI),"^",9)
	s PrnName="开单医生:"_ $p(^CTPCP(UserDR,1),"^",2) ;
	s PrnDate=$zd($h,3) 

	s prtTxtInfo="PatName"_$c(2)_PatName
	set prtTxtInfo=prtTxtInfo_"^"_"PrnName"_$C(2)_PrnName
	set prtTxtInfo=prtTxtInfo_"^"_"Sex"_$c(2)_Sex
	set prtTxtInfo=prtTxtInfo_"^"_"Age"_$c(2)_Age
	set prtTxtInfo=prtTxtInfo_"^"_"PatRegNo"_$c(2)_RegNo  ;PatRegNo
	set prtTxtInfo=prtTxtInfo_"^"_"PrnDate"_$c(2)_PrnDate
	q prtTxtInfo
}

ClassMethod GetTotalMoney(OrdString As %String) As %String
{
	s OrdDR=$p($p(OrdString,",",2),"||",1)
	s stopCode=$o(^OEC("OSTAT",0,"Code","D",0))
	s del="^"
	s sumMoney=0
	s OrdItmDR=0
	s OrdItmDR=+$o(^OEORD(OrdDR,"I",OrdItmDR))
	while(OrdItmDR'=0)
	{
		s haveIn=0
		for k=1:1:$l(OrdString,",")
		{
			s inOrdItmDR=$p($p(OrdString,",",k),"||",2)
			if (OrdItmDR=inOrdItmDR)
			{
				s haveIn=1
			}
		}
		if (haveIn=1){
			s OrdItmPrice=0
			s ordstr1=$g(^OEORD(OrdDR,"I",OrdItmDR,1))
			s ordstr2=$g(^OEORD(OrdDR,"I",OrdItmDR,2))
			s ordstr9=$g(^OEORD(OrdDR,"I",OrdItmDR,9))
			
			s ArcimId=$p(ordstr1,"^",2)
			
			s PatType=""
			s InsType=""
			s InstrRowid=""
			s ARCIMRowid=ArcimId
			s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(ArcimId)
			q:ArcStr=""
			s ArcimDesc=$p(ArcStr,del,3)
			s OrdStatus=$p(ordstr1,del,13)
			if ($Find(ArcimDesc,"挂号费")>0)
			{
				s OrderSum=0
			}elseif(stopCode=OrdStatus){
				s OrderSum=0
			}else{
				s OrderSttDate=$p($h,",",1)
				s:$g(^OEORD(OrdDR,"I",OrdItmDR))'="" OrderSttDate=+$p(^OEORD(OrdDR,"I",OrdItmDR),"^",9)
				s PriorRowid=$p(^OEORD(OrdDR,"I",OrdItmDR,1),"^",8)
				s:$g(ordstr2)'="" InstrRowid=$p(ordstr2,"^",7)
				s LinkTo=""
				s OEPrice=""
				s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
				
				s OrdItmPrice=+$P(retPrice,"^",1)
				s OrderPackQty=+$p(ordstr9,"^",4) ;+$p(ordstr1,"^",12)
				s OrderSum=OrderPackQty*OrdItmPrice
			}
			s sumMoney=sumMoney+OrderSum
		}
		s OrdItmDR=+$o(^OEORD(OrdDR,"I",OrdItmDR))
	}
	
	Quit $Justify(sumMoney,0,2)
}

}
