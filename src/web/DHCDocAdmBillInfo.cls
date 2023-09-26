Class web.DHCDocAdmBillInfo Extends (%CSP.Page, DHCDoc.Util.RegisteredObject)
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	s action=$g(%request.Data("action",1),"")
	if (action="GetAdmBillInfo")
	{ 
		s EpisodeID=$g(%request.Data("EpisodeID", 1), "")
		s UserID=$g(%request.Data("UserID", 1), "")
		s ret=..GetAdmBillInfo(EpisodeID,UserID)
		w ret
	}elseif (action="GetDateAdmBillInfo") 
	{ 
		///UserID_","_LogonLoc_","_StDate_","_EdDate_","_AdmType
		s UserID=$g(%request.Data("UserID", 1), "")
		s LogonLoc=$g(%request.Data("LogonLoc", 1), "")
		s StDate=$g(%request.Data("StDate", 1), "")
		s EdDate=$g(%request.Data("EdDate", 1), "")
		s AdmType=$g(%request.Data("AdmType", 1), "")
		s ret=..GetDateAdmBillInfo(UserID,LogonLoc,StDate,EdDate,AdmType)
		w ret
	}elseif (action="GetInsunSumInfo") 
	{ 
		///UserID_","_LogonLoc_","_StDate_","_EdDate_","_AdmType
		s UserID=$g(%request.Data("UserID", 1), "")
		s LogonLoc=$g(%request.Data("LogonLoc", 1), "")
		s StDate=$g(%request.Data("StDate", 1), "")
		s EdDate=$g(%request.Data("EdDate", 1), "")
		s AdmType=$g(%request.Data("AdmType", 1), "")
		s ret=..GetInsunSumInfo(UserID,LogonLoc,StDate,EdDate,AdmType)
		w ret
	}else{
		w ""
	}
	Quit $$$OK
ErrorHandler
   s ^tan("OnPage")=$ZE
   w "[{""ErrCode"":"""_$replace($replace($ZE,">",")"),"<","(")_"""}]"
   //w $replace($replace($ZE,">",")"),"<","(")
   Quit $$$OK
}

/// w ##Class(web.DHCDocAdmBillInfo).GetAdmBillInfo(1174,"")
ClassMethod GetAdmBillInfo(EpisodeID As %String, UserID As %String) As %String
{
	s ^tan("GetAdmBillInfo")=EpisodeID_","_UserID
	s BillInfo=..GetOneAdmBillInfo(EpisodeID,UserID)
	s Json=""
	k DateAdmPriceArr
	for i=1:1:$l(BillInfo,$C(2)) {
		s OneBillInfo=$P(BillInfo,$C(2),i)
		continue:OneBillInfo=""
		s CatDesc=$p(OneBillInfo,"^",1)
		s Price=$p(OneBillInfo,"^",2)
		if ((Price["."))&&($p(Price,".",1)="") s Price="0"_Price
		s DateAdmPriceArr(Price,CatDesc)=""
		
	}
	s Json=""
	s Price=""
	for {
		s Price=$O(DateAdmPriceArr(Price))
		q:Price=""
		s CatDesc=""
		for {
			s CatDesc=$O(DateAdmPriceArr(Price,CatDesc))
			q:CatDesc=""
			s oneData="{""value"":"""_Price_""",""name"":"""_CatDesc_"""}"
			if (Json=""){
				s Json=oneData
			}else{
				s Json=Json_","_oneData
			}
		}
	}
	s Json="["_Json_"]"
	q Json
}

/// w ##Class(web.DHCDocAdmBillInfo).GetInsunSumInfo(3988,45,"","","")
ClassMethod GetInsunSumInfo(UserID As %String, LogonLoc As %String, StDate As %String, EdDate As %String, AdmType As %String) As %String
{
	s ^tan("GetInsunSumInfo")=UserID_","_LogonLoc_","_StDate_","_EdDate_","_AdmType
	if AdmType="" s AdmType="O"
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	q:DoctorID="" "[]"
	i StDate="" {s StDate=..%SysDate()}else{s StDate=$ZDH(StDate,3)}
	i EdDate="" {s EdDate=..%SysDate()}else{s EdDate=$ZDH(EdDate,3)}
	k DateAdmBillArr
	k DateAdmPriceArr
	if (AdmType="O"){
		s AdmTypeStr="E^O"
		for i=1:1:$L(AdmTypeStr,"^"){
			s LAdmType=$P(AdmTypeStr,"^",i)
			for Date=StDate:1:EdDate {
				s AdmTime=""
				for {
					s AdmTime=$O(^PAADMi("TypeLocDocDateTime",LAdmType,LogonLoc,DoctorID,Date,AdmTime))
					q:AdmTime=""
					s EpisodeID=0
					for {
						s EpisodeID=$O(^PAADMi("TypeLocDocDateTime",LAdmType,LogonLoc,DoctorID,Date,AdmTime,EpisodeID))
						q:EpisodeID=""
						s DHCBCIID=0
						for {
							s DHCBCIID=$O(^DHCBCI(0,"ADM",EpisodeID,DHCBCIID))
							q:DHCBCIID=""
							s InvprtID=$P(^DHCBCI(DHCBCIID),"^",1)
							s InvprtSub=0
							for {
								s InvprtSub=$O(^DHCINVPRT(InvprtID,"P",InvprtSub))
								q:InvprtSub=""
								s PayModeDR=$P(^DHCINVPRT(InvprtID,"P",InvprtSub),"^",1)
								//w PayModeDR,!
								s Amt=$P(^DHCINVPRT(InvprtID,"P",InvprtSub),"^",3)
								s DateAdmBillArr(PayModeDR)=$G(DateAdmBillArr(PayModeDR))+Amt
								
							}
							
						}
					}
				}
			}
		}
	}
	s PayModeDR=0
	for {
		s PayModeDR=$O(DateAdmBillArr(PayModeDR))
		q:PayModeDR=""
		s Amt=$G(DateAdmBillArr(PayModeDR))
		if ((Amt["."))&&($p(Amt,".",1)="") s Amt="0"_Amt
		s DateAdmPriceArr(Amt,PayModeDR)=""
		
		
	}
	s Json=""
	s Amt=""
	for {
		s Amt=$O(DateAdmPriceArr(Amt))
		q:Amt=""
		s PayModeDR=""
		for {
			s PayModeDR=$O(DateAdmPriceArr(Amt,PayModeDR))
			q:PayModeDR=""
			s PayModeDesc=$P(^CT("CTPM",PayModeDR),"^",2)
			s oneData="{""value"":"""_Amt_""",""name"":"""_PayModeDesc_"""}"
			if (Json=""){
				s Json=oneData
			}else{
				s Json=Json_","_oneData
			}
		}
	}
	s Json="["_Json_"]"
	q Json
}

/// w ##Class(web.DHCDocAdmBillInfo).GetDateAdmBillInfo(2853,89,"","","")
ClassMethod GetDateAdmBillInfo(UserID As %String, LogonLoc As %String, StDate As %String, EdDate As %String, AdmType As %String) As %String
{
	s ^tan("GetDateAdmBillInfo")=UserID_","_LogonLoc_","_StDate_","_EdDate_","_AdmType
	if AdmType="" s AdmType="O"
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	q:DoctorID="" "[]"
	i StDate="" {s StDate=..%SysDate()}else{s StDate=$ZDH(StDate,3)}
	i EdDate="" {s EdDate=..%SysDate()}else{s EdDate=$ZDH(EdDate,3)}
	k DateAdmBillArr
	k DateAdmPriceArr
	if (AdmType="O"){
		s AdmTypeStr="E^O"
		for i=1:1:$L(AdmTypeStr,"^"){
			s LAdmType=$P(AdmTypeStr,"^",i)
			for Date=StDate:1:EdDate {
				s AdmTime=""
				for {
					s AdmTime=$O(^PAADMi("TypeLocDocDateTime",LAdmType,LogonLoc,DoctorID,Date,AdmTime))
					q:AdmTime=""
					s EpisodeID=0
					for {
						s EpisodeID=$O(^PAADMi("TypeLocDocDateTime",LAdmType,LogonLoc,DoctorID,Date,AdmTime,EpisodeID))
						q:EpisodeID=""
						s BillInfo=..GetOneAdmBillInfo(EpisodeID,"","已收费")
						//s BillInfo=..GetOneAdmBillInfo(EpisodeID,UserID)
						for k=1:1:$l(BillInfo,$C(2)) {
							s OneBillInfo=$P(BillInfo,$C(2),k)
							s CatDesc=$p(OneBillInfo,"^",1)
							s Price=$p(OneBillInfo,"^",2)
							continue:CatDesc=""
							s DateAdmBillArr(CatDesc)=$G(DateAdmBillArr(CatDesc))+Price
						}
					}
				}
			}
		}
	}
	s CatDesc=0
	for {
		s CatDesc=$O(DateAdmBillArr(CatDesc))
		q:CatDesc=""
		s Price=$j($G(DateAdmBillArr(CatDesc)),"",2)
		s DateAdmPriceArr(Price,CatDesc)=""
		
		
	}
	s Json=""
	s Price=""
	for {
		s Price=$O(DateAdmPriceArr(Price))
		q:Price=""
		s CatDesc=""
		for {
			s CatDesc=$O(DateAdmPriceArr(Price,CatDesc))
			q:CatDesc=""
			s oneData="{""value"":"""_Price_""",""name"":"""_CatDesc_"""}"
			if (Json=""){
				s Json=oneData
			}else{
				s Json=Json_","_oneData
			}
		}
	}
	s Json="["_Json_"]"
	q Json
}

ClassMethod GetOneAdmBillInfo(EpisodeID As %String, UserID As %String, BillType As %String = "") As %String
{
	s BillInfoStr=""
	Set rset=##Class(%ResultSet).%New("web.DHCDocOPOrdInfo.GetOrdByAdm")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(EpisodeID,UserID,BillType) //BillType
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s OrdBilled=rset.Data("OrdBilled")
			s OrderSum=rset.Data("OrderSum")
			s Price=rset.Data("Price")
			s OEItemID=rset.Data("OEItemID")
			continue:OEItemID'=""
			s CatDesc=OrderSum
			s Sum=Price
			if (BillInfoStr=""){
				s BillInfoStr=CatDesc_"^"_Sum
			}else{
				s BillInfoStr=BillInfoStr_$C(2)_CatDesc_"^"_Sum
			}
			
		}
	}
	q BillInfoStr
}

}
