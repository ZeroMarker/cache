Class web.UDHCAccRepair0711 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

ClassMethod AddPreD(AccPDRowID As %String) As %String
{
	;w ##class(web.UDHCAccRepair0711).AddPreD("947||2")
	;w ##class(web.UDHCAccRepair0711).AddPreD("356||3")
	;w ##class(web.UDHCAccRepair0711).AddPreD("960||5")
	n (AccPDRowID)
	
	k PLIST
	s myrtn=##class(web.UDHCAccPreDeposit).SELECT(AccPDRowID)
	k PLIST(1)
	k PLIST(2)
	
	b	;;;;
	
	s myrtn=##class(web.UDHCAccPreDeposit).INSERT()
	
	q myrtn
}

ClassMethod UpdatePreD(AccPLRowID) As %String
{
	;w ##class(web.UDHCAccRepair0711).UpdatePreD("")
	
	k PLIST
	s myrtn=##class(web.UDHCAccPreDeposit).SELECT("960||4")
	
	s PLIST(1)="960||5"
	s PLIST(2)=5
	;s PLIST(4)=""		;PRT_DR
	;s PLIST(7)=""		;User
	;s PLIST(8)=""		;PayDate
	;s PLIST(9)=""		;PayTime
	;s PLIST(10)=""		;PayNum
	;s PLIST(11)=""		;Left
	tstart
	
	b	;;bbb
	s myrtn=##class(web.UDHCAccPreDeposit).UPDATE("960||5")
	
	b	;;;Tro
	tcommit
	q 0
}

ClassMethod InsertPD() As %String
{
	s mystr="947	947||2	2	Pay	100	07/05/2006	07:40:49	23332	9270000000000844		110		31	07/05/2006	11:51:29	23332	"
}

ClassMethod InsertPL(AccPLRowID) As %String
{
	;写入DHC_AccPayList
	;w ##class(web.UDHCAccRepair0711).InsertPL("947||3")
	;w ##class(web.UDHCAccRepair0711).InsertPL("356||3")
	;w ##class(web.UDHCAccRepair0711).InsertPL("960||9")
	k PLIST
	s myrtn=##class(web.UDHCAccPayList).SELECT(AccPLRowID)
	
	k PLIST(1)
	k PLIST(2)
	
	b		;;;
	s myrtn=##class(web.UDHCAccPayList).INSERT()
	
	q 0
}

ClassMethod UpdatePayList(AccPLRowID) As %String
{
	;w ##class(web.UDHCAccRepair0711).UpdatePayList("")
	
	k PLIST
	;s myrtn=##class(web.UDHCAccPayList).SELECT("960||8")
	s myrtn=##class(web.UDHCAccPayList).SELECT("960||7")
	
	s PLIST(1)="960||8"
	s PLIST(2)=8
	;s PLIST(4)=""		;PRT_DR
	;s PLIST(7)=""		;User
	;s PLIST(8)=""		;PayDate
	;s PLIST(9)=""		;PayTime
	;s PLIST(10)=""		;PayNum
	;s PLIST(11)=""		;Left
	
	b	;;bbb
	;s myrtn=##class(web.UDHCAccPayList).UPDATE("960||9")
	s myrtn=##class(web.UDHCAccPayList).UPDATE("960||8")
	q 0
}

}
