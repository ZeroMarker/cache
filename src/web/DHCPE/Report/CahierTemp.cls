Class web.DHCPE.Report.CahierTemp [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(web.DHCPE.ReportCahierTemp).Main(61125,61725)

ClassMethod Main(StartDate, EndDate)
{
	s FootIDStr=""
	s fdate=StartDate-1
	f  s fdate=$o(^DHCPEUSERREPORT(0,"DATE",fdate)) q:(fdate="")||(fdate>EndDate)  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEUSERREPORT(0,"DATE",fdate,rowid))  q:rowid=""  d
	..i FootIDStr=""  d
	...s FootIDStr=rowid
	..e  d
	...s FootIDStr=FootIDStr_"^"_rowid
	q ..GetCatInfoByFootID(FootIDStr,"1")
}

ClassMethod GetCatInfoByFootID(FootIDStr, StrType As %String = 0)
{
	
    i FootIDStr=""  q ""
    k ^TMPINVCAT($J)
    s len=$l(FootIDStr,"^")
    f i=1:1:len {
    	s FootID=$p(FootIDStr,"^",i)
    	s PEINVID=0
		f  s PEINVID=$o(^DHCPEINVPRT(0,"REPORT",FootID,PEINVID)) q:PEINVID=""  d
		.d ..GetCatFee(PEINVID)
     }

   
    s Fee=""
	s CatSub=""
	f  s CatSub=$o(^TMPINVCAT($J,"TotalFee",CatSub)) q:CatSub=""  d
	.s CatDesc=$p($G(^DHCTarC("TOC",CatSub)),"^",2)
	.s TotalFee="",CatFee="",ReduseFee=""
	.s TotalFee=$G(^TMPINVCAT($J,"TotalFee",CatSub))
	.s CatFee=$G(^TMPINVCAT($J,"Fee",CatSub))
	.s ReduseFee=$G(^TMPINVCAT($J,"ReduseFee",CatSub))
    .q:(TotalFee=0)&&(ReduseFee=0)&&(CatFee=0)
    .i Fee=""  d
    ..s Fee=TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
    .e  d
    ..s Fee=Fee_"$"_TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
  	
  	s TotalFee=0,ReduseFee=0,CatFee=0,CatDesc="预缴金"
   	f i=1:1:len {
    	s FootID=$p(FootIDStr,"^",i)
    	s APID=0
  	
   		f  s APID=$o(^DHCPEAP(0,"Report",FootID,APID)) q:APID=""  d
   		.s Sub=0
   		.f  s Sub=$o(^DHCPEAP(0,"Report",FootID,APID,Sub)) q:Sub=""  d
   		..s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   		..q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   		..s OneFee=$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   		..s PayModeID=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
   		..i Type="RF" d
   		...s ReduseFee=ReduseFee-OneFee
   		..i Type'="RF" d
   		...s TotalFee=TotalFee+OneFee
   		..s ^TMPINVCAT($J,"USERREPORT","999999999999",PayModeID)=+$G(^TMPINVCAT($J,"USERREPORT","999999999999",PayModeID))+OneFee
   		..s CatFee=CatFee+OneFee
   	}
  	i TotalFee'=0 d
  	.i Fee=""  d
    ..s Fee=TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
    .e  d
    ..s Fee=Fee_"$"_TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
   	i StrType=1
   	{
	   	s Fee=..GetPayModeStr()
   	}
  
  	k ^TMPINVCAT($J)
  
  	q Fee
}

//w ##Class(web.DHCPE.DHCPEUSERREPORT).GetCatFee("34")

ClassMethod GetCatFee(CurINVID)
{
  	n (CurINVID)
    s RPEINVID=$p(^DHCPEINVPRT(CurINVID),"^",9)
    s Flag=1
    i RPEINVID'="" d
    .s CurINVID=RPEINVID
    .s Flag=-1
    i '$d(^DHCPEDataEX("DHCPEInvice",CurINVID)) d
    .s err=##class(web.DHCPE.Cashier).GetFeeCatInfo(CurINVID)
    //虚拟发票退出
    s InvNo=$p(^DHCPEINVPRT(CurINVID),"^",1)
    q:(InvNo["DHC") ""
    
    s PayInfo=..GetPayModeInfoByInvID(CurINVID)
    s Total=$p(PayInfo,"$",2)
    s PayInfo=$p(PayInfo,"$",1)
    
    s CatSub=""
    f  s CatSub=$o(^DHCPEDataEX("DHCPEInvice",CurINVID,CatSub)) q:CatSub=""  d
    .s CatStr=$G(^DHCPEDataEX("DHCPEInvice",CurINVID,CatSub))
    .s CatStr=(+CatStr)*Flag
    .s ^TMPINVCAT($J,"Fee",CatSub)=+$G(^TMPINVCAT($J,"Fee",CatSub))+CatStr
    .d ..SetCatPayModeFee(CatStr,CatSub,PayInfo,Total)
	.i Flag=1 d
	..s ^TMPINVCAT($J,"TotalFee",CatSub)=+$G(^TMPINVCAT($J,"TotalFee",CatSub))+CatStr
    .i Flag=-1 d
    ..s ^TMPINVCAT($J,"ReduseFee",CatSub)=+$G(^TMPINVCAT($J,"ReduseFee",CatSub))-CatStr
    
    q ""
}

ClassMethod GetPayModeInfoByInvID(InvID)
{
	n (InvID)
	s ret=""
	s Amt=0
	s ARRCPID=$p(^DHCPEINVPRT(InvID),"^",4)
	s ARRCPSub=0
	f  s ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) q:ARRCPSub=""  d
	.s PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.s Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.s Amt=Amt+Amount
	.i ret=""  d
	..s ret=PayModeID_"^"_Amount
	.e  d
	..s ret=ret_"&"_PayModeID_"^"_Amount
	q ret_"$"_Amt
}

ClassMethod SetCatPayModeFee(CatStr, CatSub, PayInfo, Total)
{
	n (ReportID,CatStr,CatSub,PayInfo,Total)
	s i=$L(PayInfo,"&")
	for j=1:1:i  d
	.s OneInfo=$p(PayInfo,"&",j)
	.s PayID=$p(OneInfo,"^",1)
	.s Fee=$p(OneInfo,"^",2)
	.s Fee=(Fee/Total)*CatStr
	.s ^TMPINVCAT($J,"USERREPORT",CatSub,PayID)=+$G(^TMPINVCAT($J,"USERREPORT",CatSub,PayID))+Fee
	.i '$D(^TMPINVCAT($J,"PayModeID",PayID)) d
	..s Sort=+$G(^TMPINVCAT($J,"PayModeID"))+1
	..s ^TMPINVCAT($J,"PayModeID",PayID)=Sort
	..s ^TMPINVCAT($J,"PayModeID")=Sort
	..s ^TMPINVCAT($J,"PayModeIDSort",Sort)=PayID
}

ClassMethod GetPayModeStr()
{
	;^TMPINVCAT($J,"USERREPORT",CatID,PayModeID)
	;门诊收费项目^收入金额^现金^支票^医保&
	;化验        ^30       ^10  ^20  ^0   &
	;检查        ^90       ^30  ^40  ^20  &
	;预缴金      ^50       ^20  ^10  ^20  &
	;合计        ^170      ^60  ^70  ^40
	n ret
	s ret="门诊收费项目^收入金额"
	k PLIST
	//得到各个分类的字符串
	s i=$G(^TMPINVCAT($J,"PayModeID"))
	f j=1:1:i d
	.s PayID=^TMPINVCAT($J,"PayModeIDSort",j)
	.s PayDesc=$p(^CT("CTPM",PayID),"^",2)
	.s ret=ret_"^"_PayDesc
	s CatID=""
	f  s CatID=$o(^TMPINVCAT($J,"USERREPORT",CatID)) q:CatID=""  d
	.s PayMode=""
	.i CatID="999999999999" d
	..s CatDesc="预缴金"
	.e  d
	..s CatDesc=$p($G(^DHCTarC("TOC",CatID)),"^",2)
	.k FeePLIST
	.f  s PayMode=$o(^TMPINVCAT($J,"USERREPORT",CatID,PayMode)) q:PayMode=""  d
	..s Sort=$G(^TMPINVCAT($J,"PayModeID",PayMode))
	..s FeePLIST(Sort)=+$G(^TMPINVCAT($J,"USERREPORT",CatID,PayMode))
	..s FeePLIST(0)=+$G(FeePLIST(0))+FeePLIST(Sort)
	..s PLIST(0)=+$G(PLIST(0))+FeePLIST(Sort)
	..s PLIST(Sort)=+$G(PLIST(Sort))+FeePLIST(Sort)
	.s OneStr=CatDesc
	.f j=0:1:i  d
	..s OneStr=OneStr_"^"_$G(FeePLIST(j))
	.s ret=ret_"&"_OneStr
	//输出合计
	s OneStr="合计"
	f j=0:1:i  d
	.s OneStr=OneStr_"^"_$G(PLIST(j))
	s ret=ret_"&"_OneStr
	q ret
}

}
