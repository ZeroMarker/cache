Class web.DHCBL.UDHCCardTypeEdit Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2;

ClassMethod CardTypeDTO(TypeRowID As %String, ValueInfo As %String) As %String
{
	n (TypeRowID, ValueInfo)
	
	tstart
	
	if (TypeRowID'=""){
		s myTypeObj=##class(User.DHCCardTypeDef).%OpenId(TypeRowID)
	}else{
		s myTypeObj=##class(User.DHCCardTypeDef).%New()
	}

	s myTypeObj.CTDCode=$p(ValueInfo,"^",2)
	s myTypeObj.CTDDesc =$p(ValueInfo,"^",3)
	s myTypeObj.CTDFareType =$p(ValueInfo,"^",4)
	s myTypeObj.CTDPrtINVFlag =$p(ValueInfo,"^",5)
	s myTypeObj.CTDUseINVType =$p(ValueInfo,"^",6)
	s myTypeObj.CTDCardFareCost =$p(ValueInfo,"^",7)
	s myTypeObj.CTDReclaimFlag =$p(ValueInfo,"^",8)
	s myTypeObj.CTDDefaultFlag =$p(ValueInfo,"^",9)
	s myTypeObj.CTDDateFrom =$p(ValueInfo,"^",10)
	s myTypeObj.CTDDateTo =$p(ValueInfo,"^",11)
	s myTypeObj.CTDActiveFlag =$p(ValueInfo,"^",12)
	s myTypeObj.CTDSearchMasFlag =$p(ValueInfo,"^",13)
	s myTypeObj.CTDSetFocusElement =$p(ValueInfo,"^",14)
	s myTypeObj.CTDHardComDR =$p(ValueInfo,"^",15)
	s myTypeObj.CTDBarCodeComDR =$p(ValueInfo,"^",16)
	s myTypeObj.CTDReadCardMode =$p(ValueInfo,"^",17)
	s myTypeObj.CTDCardNoLength =$p(ValueInfo,"^",18)
	s myTypeObj.CTDSecurityNoFlag =$p(ValueInfo,"^",19)
	s myTypeObj.CTDPreCardFlag =$p(ValueInfo,"^",20)
	s myTypeObj.CTDReadCardFocusElement =$p(ValueInfo,"^",21)
	s myTypeObj.CTDPANoCardRefFlag =$p(ValueInfo,"^",22)
	s myTypeObj.CTDCardRefFocusElement =$p(ValueInfo,"^",23)
	s myTypeObj.CTDOverWriteFlag =$p(ValueInfo,"^",24)
	s myTypeObj.CTDCardAccountRelation =$p(ValueInfo,"^",25)
	
	d myTypeObj.%Save()
	b	;Save
	
	TC
	
	d myTypeObj.%Close()
	
	q 0
}

ClassMethod InsertCardType() As %String
{
}

ClassMethod UpdateCardType() As %String
{
	;d ##class(web.DHCBL.UDHCCardTypeEdit).UpdateCardType()
	s ValueInfo=""
	d ##class(web.UDHCCardTypeDef).SELECT(1)
	d ##class(web.UDHCCardTypeDef).UPDATE(1)
	s myIdx=0
	f  s myIdx=$o(PLIST(myIdx)) q:(myIdx="")  d
	.i ValueInfo="" d
	..s ValueInfo=PLIST(myIdx)
	.e  d
	..s ValueInfo=ValueInfo_"^"_PLIST(myIdx)
	b
	s $p(ValueInfo,"^",4)="NP"
	s $p(ValueInfo,"^",20)="N"		;CTDPreCardFlag
	s $p(ValueInfo,"^",23)="CardNo"
	s $p(ValueInfo,"^",21)="Name"
	s $p(ValueInfo,"^",25)="CL"
	
	d ..CardTypeDTO("1",ValueInfo)
}

}
