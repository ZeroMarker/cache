Class web.DHCBL.SQuote.SoundPrice7 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod SoundService(JSFunName As %String, SoundService As %String, ValAry As %String, SessionStr As %String, ExpStr As %String) As %String
{
	;费用总额提示   TotalFee
	;找零提示       RtnOdd
	;ValAry= 应收总额^收取金额^找零
	s myrtn=0
	s myXmlStr=""
	s mySoundEquipDR=##class(web.UDHCCardCommLinkRegister).GetSingleEquipDR("SQ")
	i (SoundService="TotalFee"){
		;ValAry  = 费用金额^
		s myTFee=+$p(ValAry,"^",1)
		s myXmlStr="<SPrice><Instruction>"_myTFee_"J</Instruction><Instruction></Instruction></SPrice>"
	}elseif(SoundService="RtnOdd"){
		;ValAry= 应收总额^收取金额^找零
		s myReturnSum=+$p(ValAry,"^",3)
		s myXmlStr="<SPrice><Instruction>"_myReturnSum_"Z</Instruction><Instruction></Instruction></SPrice>"
	}
	q:(myXmlStr="")
	;DHCWCOM_SoundQuotePrice(myEquipDR,myXmlStr);
	s mytip=0
	s ^TMPmyXmlStr=myXmlStr_"^"_mySoundEquipDR_"^"_JSFunName
	
	s rtnval=JSFunName_"('"_$ZCVT($g(mySoundEquipDR),"O","JS")_"','"_$ZCVT($g(myXmlStr),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mytip,"O","JS")_"');"
	
	&javascript<#(rtnval)#>
	
	q 0
}

}
