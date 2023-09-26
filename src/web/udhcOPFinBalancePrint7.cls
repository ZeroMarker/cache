Class web.udhcOPFinBalancePrint7 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// / 财务汇总打印输出
ClassMethod GetOperListDataForPrint(UserDR As %String, StDate As %String = "", StTime As %String = "", EndDate As %String = "", EndTime As %String = "", SubAvailHosp As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalancePrint7).GetOperListDataForPrint("2","2008-01-14","0","2008-01-14","","1")
	d ..KillTmp()
	
	s ^TMPOLDFPFDFD=$lb(UserDR, StDate, StTime, EndDate, EndTime, SubAvailHosp)
	
	i StDate["/" d  s StDate = $zdh(StDate,4)
	i StDate["-" d  s StDate = $zdh(StDate,3)
	
	i EndDate["/" d  s EndDate=$zdh(EndDate,4)
	i EndDate["-" d  s EndDate=$zdh(EndDate,3)
	
	s myRepObj=##class(web.DHCEntity.OPC.ReportsInfos).%New()
	s hUser=""
	s myCardINVInfo=##class(web.DHCBL.OPC.ReportsInfos).GetInComeReportInfo(StDate,StTime,EndDate,EndTime, hUser, .myRepObj, "A")
	
	s myINSFFlag=0
	s myrtn=0
	s myCount = myRepObj.RepInfos.Count()
	s myTCashSum=0
	s myTChequeSum=0
	s myTBankCardSum=0
	s myTYBCardSum=0
	s myTDWZHSum=0
	s myTHTZHSum=0
	s myTZGBLJZSum=0
	s myTJZQFSum=0
	
	;Excel 的长度
	s myExcelRowLength=10
	s myRepData=""
	
	d ..GetACCatList()
	
	s myUserName=$p(^SSU("SSUSR",UserDR),"^",2)
	s myRowID=4
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myUserName
	
	s myobj=##class(User.DHCSuAvailbHospital).%OpenId(SubAvailHosp)
	s mySubAvailHospName = myobj.SAHDesc
	d myobj.%Close()
	s myRowID=4
	s myCol=9
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_mySubAvailHospName
	
	s myRowID=5
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$zd(StDate,3)_" -- "_$zd(EndDate,3)
	
	;web.UDHCOPINVPrtIF.RMBConvert
	
	s myTMPGID=$i(^TMPOPPrintOut)
	s myIdx=0
	s myGBIdx=0
	f i=1:1:myCount {
		;输出收费员数据
		;d myRepObj.SetSelectPayMode(SubAvailHosp)
		s myPMRowTSum=0
		
		s myOperInfo=myRepObj.RepInfos.GetAt(i)
		
		s myHospPMObj=myOperInfo.SetSelectPayMode(SubAvailHosp)
		s myCashSum=myOperInfo.SelTotalPayMode.CashSum
		s myChequeSum=myOperInfo.SelTotalPayMode.ChequeSum
		
		s myBankCardSum=myOperInfo.SelTotalPayMode.BankCardSum
		s myYBCardSum=myOperInfo.SelTotalPayMode.YBCardSum
		s myDWZHSum=0
		s myHTZHSum=0
		s myZGBLJZSum=0
		s myJZQFSum=0
		
		s myTCashSum=+myTCashSum+myCashSum
		s myTChequeSum=+myTChequeSum+myChequeSum
		s myTBankCardSum=+myTBankCardSum+myBankCardSum
		s myTYBCardSum=+myTYBCardSum+myYBCardSum
		s myTDWZHSum=+myTDWZHSum+ myDWZHSum
		s myTHTZHSum= +myTHTZHSum + myHTZHSum
		s myTZGBLJZSum= +myTZGBLJZSum + myZGBLJZSum
		s myTJZQFSum= +myTJZQFSum + myJZQFSum
		
		s myUserDR=myOperInfo.UserDR
		s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
		s myPMRowTSum = +myPMRowTSum+myCashSum
		s myPMRowTSum = +myPMRowTSum+myChequeSum
		s myPMRowTSum = +myPMRowTSum+myBankCardSum
		s myPMRowTSum = +myPMRowTSum+myYBCardSum
		
		i (myOperInfo.ReportStatus="C")&&(+myINSFFlag=0) d
		.s myINSFFlag=119
		
		s myGBIdx=myGBIdx+1
		s mystr=myUserName_"^"_$fn(myCashSum,"",2)_"^"_$fn(myChequeSum,"",2)_"^"_$fn(myBankCardSum,"",2)_"^"_$fn(myYBCardSum,"",2)
		s mystr=mystr_"^"_$fn(myDWZHSum,"",2)_"^"_$fn(myHTZHSum,"",2)_"^"_$fn(myZGBLJZSum,"",2)_"^"_$fn(myJZQFSum,"",2)_"^"_$fn(myPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
		s ^TMPOPPrintOut(myTMPGID, myGBIdx)=mystr
		
		s myItmACCat=""
		
		;当前收费员的 项目分类
		;myOperInfo
		s myAcCats=myOperInfo.ACCat
		s myItmCount=myAcCats.Count()
		for myItmIdx=1:1:myItmCount {
			s myACCat = myAcCats.GetAt(myItmIdx)
			i ((SubAvailHosp=myACCat.SubAvailHospitlDR)||(SubAvailHosp="")) {
				;
				s myItemID=myACCat.CatDR
				s myItmSum=myACCat.Acount
				s myIdx=$g(^TMPTar($j,"ItmID",myItemID))
				i myIdx'=""{
					s ^TMPTar($j,"FAIR",myIdx,"TSum") = +$g(^TMPTar($j,"FAIR", myIdx,"TSum"))+myItmSum
				}
			}
		}
		
	}
	
	s myGBIdx=myGBIdx+1
	s myTPMRowTSum=+myTCashSum + myTChequeSum + myTBankCardSum + myTYBCardSum
	s myTPMRowTSum=+myTPMRowTSum+myTDWZHSum+ myTHTZHSum+myTZGBLJZSum + myTJZQFSum
	s mystr="合计  ^"_$fn(myTCashSum,"",2)_"^"_$fn(myTChequeSum,"",2)_"^"_$fn(myTBankCardSum,"",2)_"^"_$fn(myTYBCardSum,"",2)
	s mystr=mystr_"^"_$fn(myTDWZHSum,"",2)_"^"_$fn(myTHTZHSum,"",2)_"^"_$fn(myTZGBLJZSum,"",2)_"^"_$fn(myTJZQFSum,"",2)_"^"_$fn(myTPMRowTSum,"",2)_"^^^^^^^^^^^^^^^"
	s ^TMPOPPrintOut(myTMPGID, myGBIdx)=mystr
	
	;汇总信息 金额
	s myRowID=12
	s myCol=2
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTCashSum,"",2)
	
	s myRowID=12
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTChequeSum,"",2)
	
	s myRowID=12
	s myCol=4
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTBankCardSum,"",2)

	s myRowID=12
	s myCol=5
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTYBCardSum,"",2)
	
	s myRowID=12
	s myCol=6
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTDWZHSum,"",2)
	
	s myRowID=12
	s myCol=7
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTHTZHSum,"",2)
	
	s myRowID=12
	s myCol=8
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTZGBLJZSum,"",2)
	
	s myRowID=12
	s myCol=9
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTJZQFSum,"",2)

	s myRowID=12
	s myCol=10
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTPMRowTSum,"",2)
	
	s myRowID=6
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTPMRowTSum,"",2)
	
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myTPMRowTSum)
	s myRowID=7
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRMB
	
	;Tar Print
	;^TMPItmCat($j,myIdx, myItemID,"TSum")
	s mylenStr=+$g(^TMPTar($j))+1
	s myItemStr=mylenStr
	s myItemNameStr=mylenStr
	s myIdx=0
	
	s myTTCatSum=0
	f  s myIdx=$o(^TMPTar($j, "FAIR", myIdx))  q:(myIdx="")  d
	.s myTTCatSum=+myTTCatSum + $g(^TMPTar($j, "FAIR", myIdx,"TSum"))
	.i myItemStr="" d
	..s myItemStr=$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	.e  d
	..s myItemStr=myItemStr_"^"_$fn(^TMPTar($j, "FAIR", myIdx,"TSum"),"",2)
	.s myTarRowID=$g(^TMPTar($j,myIdx))
	.s myTarName=""
	.s:(myTarRowID'="") myTarName = $p(^DHCTarC("TAC",myTarRowID),"^",2)
	.i myItemNameStr="" d
	..s myItemNameStr=myTarName
	.e  d
	..s myItemNameStr=myItemNameStr_"^"_myTarName
	
	i myItemStr="" d
	.s myItemStr="0^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	e  d
	.s myItemStr=myItemStr_"^"_$fn(myTTCatSum,"",2)
	
	d myRepObj.%Close()
	
	s myinsobj=##class(web.DHCEntity.OPC.INSReport).%New()
	
	s myinsobj.StDate=$zd(StDate,3)
	s myinsobj.EndDate=$zd(EndDate,3)
	d myinsobj.XMLExportToStringExp(.myXmlData)
	d myinsobj.%Close()
	
	d ..KillTmp()
	
	s myTarItemStr = myItemStr
	
	q myrtn_$c(3)_myRepData_$c(3)_myTarItemStr_$c(3)_myTMPGID_$c(3)
}

ClassMethod GetACCatList()
{
	s n=1
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TAC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TAC",itmrowid),"^",2)
	.s ^TMPTar($j)=n
	.s ^TMPTar($j,"ItmID",itmrowid)=n
	.s ^TMPTar($j, "FAIR", n,"TSum")=0
	.s ^TMPTar($j,n)=itmrowid
	.s ^TMPItmCat($j,n, itmrowid)=""
	.s ^TMPItmCat($j,n, itmrowid,"TSum")=0
	.
	.s n=n+1
	
	q n
}

ClassMethod KillTmp()
{
	k ^TMPTar($j)
}

}
