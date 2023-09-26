Class dhcinterface.BankRegMacRule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 注册
ClassMethod ToRegister(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.Sex
		s MacString=MacString_PatDetail.DOB
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo
		s MacString=MacString_PatDetail.Address
		s MacString=MacString_PatDetail.Zip
		s MacString=MacString_PatDetail.TelephoneNo
		s MacString=MacString_PatDetail.Mobile

	}
	
	q MacString
}

/// 换卡
ClassMethod ChangeCard(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo
		s MacString=MacString_PatDetail.OldPatientCard

	}
	
	q MacString
}

/// 挂失
ClassMethod DeclareCardLost(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo

	}
	
	q MacString
}

/// 撤消挂失
ClassMethod RecallCard(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo

	}
	
	q MacString
}

/// 卡作废
ClassMethod RepealCard(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo

	}
	
	q MacString
}

/// 变更病人基本信息
ClassMethod ChangePatientInfo(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s MacString=RequestObj.TxDate_RequestObj.TransactionId_RequestObj.ActionCode_RequestObj.BankCode
		s MacString=MacString_PatDetail.PatientID
		s MacString=MacString_PatDetail.PatientCard
		s MacString=MacString_PatDetail.Name
		s MacString=MacString_PatDetail.Sex
		s MacString=MacString_PatDetail.DOB
		s MacString=MacString_PatDetail.IDType
		s MacString=MacString_PatDetail.IDNo
		s MacString=MacString_PatDetail.Address
		s MacString=MacString_PatDetail.Zip
		s MacString=MacString_PatDetail.TelephoneNo
		s MacString=MacString_PatDetail.Mobile

	}
	q MacString
}

/// 签到
ClassMethod SignIn(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""	
	q MacString
}

/// 签退
ClassMethod SignOut(RequestObj As dhcinterface.BankSendMsg) As %String
{
	s MacString=""	
	q MacString
}

}
