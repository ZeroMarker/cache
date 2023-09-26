Class DHCDoc.DHCDocConfig.BtnBar Extends Common
{

Query QueryPage(HospID) As %SQLQuery
{
	SELECT * FROM SQLUser.DocCFTreatStatusMainInfo WHERE HospDr=:HospID
}

Query QueryPageBtn(PageID) As %SQLQuery
{
	SELECT * FROM SQLUser.DocCFTreatStatusInfo where TreatStatusConfigMainID=:PageID ORDER BY DisplayNum
}

/// w ##class(DHCDoc.DHCDocConfig.BtnBar).CopyPage(10,"[10]")
ClassMethod CopyPage(PageID, ToHospIDs)
{
	s row=..GetRowData("User.DocCFTreatStatusMainInfo",PageID,"obj","TreatStatusConfigMainID")
	s CSPname=row.CSPname
	if (CSPname=""){
		Q "-1^源页面不存在"
	}
	s PageItems=##class(DHCDoc.Util.QueryToJSON).%New("DHCDoc.DHCDocConfig.BtnBar","QueryPageBtn",PageID).ToArray()
	s rtn=0
	TS
	s row.TreatStatusConfigMainID=""
	s ToHospIDs=[].%FromJSON(ToHospIDs)
	for i=1:1:ToHospIDs.%Size(){
		s ToHospID=ToHospIDs.%Get(i-1)
		s row.HospDr=ToHospID
		s MainID=""
		&SQL(SELECT TreatStatusConfigMainID INTO :MainID FROM SQLUser.DocCFTreatStatusMainInfo WHERE CSPname=:CSPname AND HospDr=:ToHospID)
		if 'SQLCODE&&(MainID'=""){
			s HospName=$P(^CT("HOSP",ToHospID),"^",2)
			s rtn="-1^该页面在【"_HospName_"】已存在"
			Q
		}
		s rtn=..SaveData("User.DocCFTreatStatusMainInfo",[].%Push(row),"TreatStatusConfigMainID")
		Q:rtn'=0
		&SQL(SELECT TreatStatusConfigMainID INTO :MainID FROM SQLUser.DocCFTreatStatusMainInfo WHERE CSPname=:CSPname AND HospDr=:ToHospID)
		if SQLCODE||(MainID=""){
			s rtn=-1
			Q
		}
		for i=1:1:PageItems.%Size(){
			s PageItems.%Get(i-1).TreatStatusConfigID=""
			s PageItems.%Get(i-1).TreatStatusConfigMainID=MainID
		}
		s rtn=..SaveData("User.DocCFTreatStatusInfo",PageItems,"TreatStatusConfigID")
		Q:rtn'=0
	}
	if rtn=0 TC
	else  TRO
	Q rtn
}

ClassMethod UpdateBtnSeq(IDStr)
{
	s SQLCODE=0
	TS
	s IDArr=[].%FromJSON(IDStr)
	for i=1:1:IDArr.%Size(){
		s ID=IDArr.%Get(i-1)
		&SQL(UPDATE SQLUser.DocCFTreatStatusInfo SET DisplayNum=:i WHERE TreatStatusConfigID=:ID)
		Q:SQLCODE
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

}
