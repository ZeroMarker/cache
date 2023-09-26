Class web.DHCBL.CARD.UCardAccStatusChange Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod Insert(AccStatusChange As web.DHCEntity.PCA.CardAccStatusChange) As %String
{
	
	TStart
	set Account=##class(User.DHCAccManager).%OpenId(AccStatusChange.AccountID)
	set AccStatus=##class(User.DHCAccStatusChange).%New(AccStatusChange.AccountID)
	set AccStatus.AccSCParRef=Account
	set AccStatus.AccSCOValue=AccStatusChange.OldStatus
	set AccStatus.AccSCNValue=AccStatusChange.NewStatus
	set AccStatus.AccSCLeft=AccStatusChange.Left
	set AccStatus.AccSCOperDate=AccStatusChange.OperDate
	set AccStatus.AccSCOperTime=AccStatusChange.OperTime
	set AccStatus.AccSCUserDR=AccStatusChange.UserDR
	set AccStatus.AccSCRLName=AccStatusChange.RLName
	set AccStatus.AccSCRLCredNo=AccStatusChange.RLCredNo
	set AccStatus.AccSCRLAddress=AccStatusChange.RLAddress
	set AccStatus.AccSCRLPhoneNo=AccStatusChange.RLPhoneNo
	set AccStatus.AccSCRLProof=AccStatusChange.RLProof
	set AccStatus.AccSCRLRemark=AccStatusChange.RLRemark
	set AccStatus.AccSCCredType=AccStatusChange.CredType
	
	set sc=AccStatus.%Save()
	if $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		quit -100
	}
	TCommit
	quit AccStatus.%Id()
}

}
