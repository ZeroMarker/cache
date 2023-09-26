Class web.UDHCOPINVPrtMedical Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:hj
/// date:2015-09-22
/// function:获取病案打印发票信息
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String, PrtFlag As %String) As %String
{
	;w ##class(web.UDHCOPINVPrtMedical).GetOPPrtData("","55","1","现金","INVPrtFlag2007")
	q:$g(InvRowID)="" ""
	k ^TMP("myWinInfo",InvRowID)
	
	s SelectPrtDr=InvRowID
	Set PatDr=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",1)
	q:$g(PatDr)="" ""
	s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	s PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	s SCH=$p(^PAPER(PatDr,"ALL"),"^",19)
	s PatSexID=$p(^PAPER(PatDr,"ALL"),"^",7)
	s PatSex=$p(^CT("SEX",PatSexID),"^",2)
	s PatAcount=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",2)
	
	s Date=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",4)
	s myInvNo=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",3)
	
	s InsType=""
	s InsTypeDR=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",21)
	;s InsuDivDr=$p(^DHCINVPRT(SelectPrtDr),"^",30)
	s initDr=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",12)
	;i initDr'="" s InsuDivDr=$p(^DHCINVPRT(initDr),"^",30)
	i InsTypeDR'="" s InsType=$p($g(^PAC("ADMREA",InsTypeDR)),"^",2)
	s DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s Pusr=$p(^DHCINVPRTMEDICAL(SelectPrtDr),"^",14)
	s UsrName=$p(^SSU("SSUSR",Pusr),"^",2)
	s UsrCode=$p(^SSU("SSUSR",Pusr),"^",1)
	s DateL=$zd(Date,3)
	s PYear=$p(DateL,"-",1)
	s PMon=$p(DateL,"-",2)
	s PDay=$p(DateL,"-",3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UsrName_"^"_"PYear"_$c(2)_PYear_"^"_"PMon"_$c(2)_PMon_"^"_"PDay"_$c(2)_PDay
	s DetailStr=DetailStr_"^"_"InsType"_$c(2)_InsType
	s DetailStr=DetailStr_"^"_"Sex"_$c(2)_PatSex
	s myTMPINVStr="^"_"InvNo"_$c(2)_myInvNo
	s DetailStr=DetailStr_myTMPINVStr
	s DetailStr=DetailStr_"^"_"PaySum"_$c(2)_PatAcount
	
	s prtsub="0"
	f  s prtsub=$o(^DHCINVPRTMEDICAL(InvRowID,"P",prtsub)) q:prtsub=""  d
	.s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	.s ItmDr=$p(^DHCINVPRTMEDICAL(InvRowID,"P",prtsub),"^",3)
	.s ItmDesc=$p(^DHCTARI(ItmDr),"^",2)
	.s UnitPrice=$p(^DHCINVPRTMEDICAL(InvRowID,"P",prtsub),"^",4)
	.s Qty=$p(^DHCINVPRTMEDICAL(InvRowID,"P",prtsub),"^",5)
	.s Acount=$p(^DHCINVPRTMEDICAL(InvRowID,"P",prtsub),"^",6)
	.s idex=^TMP($ZN,$j,"D")
	.s ^TMP($ZN,$j,"D",idex)=ItmDesc_"^"_UnitPrice_"^"_Qty_"^"_Acount
	
	s ^TMP("OPBILL",$j,"InvDetailsCount")=^TMP($ZN,$j,"D")
    b   ;;InvDetailsCount
	s myMaxRows=15
	;  省略
	s myList=""
	s myOrdCount=+$g(^TMP($ZN,$j,"D"))
	f i=(myOrdCount+1):1:(myMaxRows*2)  d
	.s ^TMP($ZN,$j,"D",i)="^^^^"
	.s ^TMP($ZN,$j,"D")=i
	f myidx=1:1:(myMaxRows)  d
	.i myList="" d
	..s myList=^TMP($ZN,$j,"D",myidx)_"^"_^TMP($ZN,$j,"D",(myidx+(myMaxRows)))
	.e  d
	..s myList=myList_""_$c(2)_""_^TMP($ZN,$j,"D",myidx)_"^"_^TMP($ZN,$j,"D",(myidx+(myMaxRows)))	
		
	s prtListInfo=myList	
	s prtTxtInfo=DetailStr
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	KILL ^TMP($ZN,$j)
	
	;add by lml 2015-01-27 增加打印日志
	try{
		Set UseID=$p(^DHCINVPRTMEDICAL(InvRowID),"^",14)
		Set myCondition="{InvRowID:"""_InvRowID_""",UseID:"""_UseID_""",PayMode:"""_PayMode_""",PrtFlag:"""_PrtFlag_"""}"
		Set myContent="{InvRowID:"""_InvRowID_""",myInvNo:"""_myInvNo_"""}"
 		Set mySecretCodeStr=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PatDr,"")
 		Set mySecretCode=$p(mySecretCodeStr,"^",3)
		set mylog=##class(web.DHCEventLog).EventLog("udhcOPCharge.BillPrintInv",myCondition,myContent,mySecretCode)
	}catch{
		
	}
	;end
	
	
	Quit "0"
}

}
