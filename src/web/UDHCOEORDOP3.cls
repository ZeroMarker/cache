Class web.UDHCOEORDOP3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 15;

/// //山西大同版本
ClassMethod ReadDOCByPRTRowID(PRTRowID As %String) As %String
{
	n (PRTRowID)
	///利用DHC_INVPRT 表的RowID， 获取处方医生
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s myDocRowID=""
	s AdmDocName=""
	
	s myBCIRowID=0
	
	q:(PRTRowID="") ""
	
	f  s myBCIRowID=$o(^DHCBCI(0,"INV",PRTRowID, myBCIRowID)) q:(myBCIRowID="")!(myDocRowID'="")  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^",2)
	.s myPBSub=0
	.;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	.f  s myPBSub=$o(^DHCPB(myPBRowID,"O",myPBSub))  q:(myPBSub="")!(myDocRowID'="")  d
	..q:($d(^DHCPB(myPBRowID,"O",myPBSub))=10)
	..s myOEORDDR=$p(^DHCPB(myPBRowID,"O",myPBSub),"^",4)
	..q:(myOEORDDR="")
	..s myDocRowID=$p(^OEORD(+myOEORDDR,"I",$p(myOEORDDR,"||",2),1),"^",11)
	..q:myDocRowID=""
	..;^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId})
	..s myUseID=$o(^SSU("SSUSR",0,"CTPCP", myDocRowID,0))
	..If myUseID'="" Do
	...Set AdmDocName=$p($g(^SSU("SSUSR",myUseID)),"^",2)
	..Else  Set AdmDocName=""
	..i AdmDocName="" d
	...s AdmDocName=$p($g(^CTPCP(myDocRowID)),"^",2)
	
	q AdmDocName
}

}
