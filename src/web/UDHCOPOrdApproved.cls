Import SQLUser

Class web.UDHCOPOrdApproved Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

ClassMethod CheckOrdApprovedIF(myAdmstr, unordstr, curInsType, ExpStr)
{
	;w ##class(web.UDHCOPOrdApproved).CheckOrdApprovedIF("1256","","19","")
	s rtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=11){
		s rtn=..CheckSingleOrdApproved(myAdmstr, unordstr, curInsType, ExpStr)
	}else{
		s rtn=..CheckSingleOrdApproved(myAdmstr, unordstr, curInsType, ExpStr)
		//s rtn=..CheckOrdApproved(myAdmstr, unordstr, curInsType, ExpStr)
	}
	q rtn
}

ClassMethod CheckOrdApproved(myAdmstr, unordstr, curInsType, ExpStr)
{
	n (myAdmstr,unordstr,curInsType,ExpStr)
	s myAdmstr=$g(myAdmstr),unordstr=$g(unordstr),curInsType=$g(curInsType),ExpStr=$g(ExpStr)
	s rtn=0
	q:'$d(^DHCOPApproved) rtn
	q:myAdmstr="" rtn
	q:curInsType="" rtn
	q:'$d(^PAC("ADMREA",curInsType)) rtn
	s len=$l(myAdmstr,"^")
	f i=1:1:len  d
	.s Adm=$p(myAdmstr,"^",i)
	.q:Adm=""
	.q:'$d(^PAADM(Adm))
	.s rtn=..GetAdmOrdApproved(rtn,Adm,unordstr,curInsType,ExpStr)
	.
	q rtn
}

ClassMethod GetAdmOrdApproved(rtn, Adm, unordstr, curInsType, ExpStr)
{
	n (rtn,Adm,unordstr,curInsType,ExpStr)
	s rtn=$g(rtn),Adm=$g(Adm),unordstr=$g(unordstr),curInsType=$g(curInsType),ExpStr=$g(ExpStr)
	q:'$d(^DHCOPApproved) rtn
	s admInstype=$p($g(^PAADM(Adm,1)),"^",7)
	q:admInstype="" rtn
	s OrdID=$o(^OEORD(0,"Adm",Adm,""))
	q:OrdID="" rtn
	q:'$d(^DHCOPApproved(0,"OrdAppAR",admInstype,curInsType)) rtn
	s ApprovedID=..GetApprovedID(admInstype,curInsType,+$H,ExpStr)
	q:+ApprovedID'>0 rtn
	s AppConID=$p($g(^DHCOPApproved(ApprovedID)),"^",4),ToInsType=$p($g(^DHCOPApproved(ApprovedID)),"^",3)
	q:(AppConID'="")&&('$d(^DHCOPAppCon(AppConID))) rtn
	s AdmLoc=$p($g(^PAADM(Adm)),"^",4)
	s AdmLocDesc=$p($g(^CTLOC(AdmLoc)),"^",2)
	i AdmLocDesc["-" s AdmLocDesc=$p(AdmLocDesc,"-",2)
	
	s ToInsTypeDesc=""
	i ToInsType'="" s ToInsTypeDesc=$p($g(^PAC("ADMREA",ToInsType)),"^",2)
	i AppConID=""  s AppConStr=""
	e  s AppConStr=..GetAppConStr(AppConID,+$H)
	s MinAmt=+$p(AppConStr,$c(3),1)
	s subcateStr=$p(AppConStr,$c(3),2)
	s CateMinAmtStr=$p(AppConStr,$c(3),3)
	k ^TMP("ORDAPP",$j)
	s AppOrdIDStr="",AppOrdDescStr=""
	s find=0
	s sub=0
	f  s sub=$o(^OEORD(OrdID,"I",sub)) q:sub=""  d
	.s OrdItemID=OrdID_"||"_sub
	.s ItmMast=$p($g(^OEORD(OrdID,"I",sub,1)),"^",2)
	.q:ItmMast=""
	.s ItemStat=$p($g(^OEORD(OrdID,"I",sub,1)),"^",13)
	.q:ItemStat=""
	.s ItemStatCode=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
	.q:ItemStatCode="D"
	.q:ItemStatCode="I"
	.s Billed=$p($g(^OEORD(OrdID,"I",sub,3)),"^",5)
	.q:Billed="P"
	.q:unordstr[("^"_OrdItemID_"^")
	.s BBExtCode=$p($g(^OEORD(OrdID,"I",sub,11)),"^",18)
	.q:curInsType'=BBExtCode
	.s DHCORDItemID=$o(^DHCORDItem(0,OrdItemID,""))
	.q:(DHCORDItemID'="")&&($p($g(^DHCORDItem(DHCORDItemID,2)),"^",1)="Y")
	.s ArcimDesc=$p($g(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1)),"^",2)
	.i AppConStr="" d
	..i AppOrdIDStr="" s AppOrdIDStr=OrdItemID,AppOrdDescStr=ArcimDesc
	..e  s AppOrdIDStr=AppOrdIDStr_"^"_OrdItemID,AppOrdDescStr=AppOrdDescStr_"^"_ArcimDesc
	..
	.e  d
	..
	..i subcateStr'="" s err=..GetItem(OrdItemID,ItmMast,AppConStr,+$H,ExpStr)
	..e  s err=..GetOrd(OrdItemID,ItmMast,AppConStr)
	..
	.
	
	i (AppConStr'="")&&(subcateStr="") d
	.s tmpSum=+$g(^TMP("ORDAPP",$j,0,"SUM"))
	.i tmpSum>MinAmt s AppOrdIDStr=$g(^TMP("ORDAPP",$j,0,"ID")),AppOrdDescStr=$g(^TMP("ORDAPP",$j,0,"DESC"))
	
	i (AppConStr'="")&&(subcateStr'="") d
	.i MinAmt>0 d
	..i +$g(^TMP("ORDAPP",$j))>MinAmt d
	...s AppOrdIDStr=$g(^TMP("ORDAPP",$j,"OrdItemID"))
	...
	.e  d
	..s len=$l(subcateStr,"^")
	..f i=1:1:len  d
	...s subcate=$p(subcateStr,"^",i)
	...q:subcate=""
	...q:'$d(^TMP("ORDAPP",$j,0,subcate))
	...s CateMinAmt=+$p(CateMinAmtStr,"^",i)
	...i +$g(^TMP("ORDAPP",$j,0,subcate))>CateMinAmt  d
	....i AppOrdIDStr="" s AppOrdIDStr=$g(^TMP("ORDAPP",$j,0,subcate,"OrdItemID"))
	....e  s AppOrdIDStr=AppOrdIDStr_"^"_$g(^TMP("ORDAPP",$j,0,subcate,"OrdItemID"))
	....
	..
	.i AppOrdIDStr'="" d
	..s len=$l(AppOrdIDStr,"^")
	..f i=1:1:len  d
	...s ordid=$p(AppOrdIDStr,"^",i)
	...q:ordid=""
	...s arcim=$p($g(^OEORD(+ordid,"I",$p(ordid,"||",2),1)),"^",2)
	...q:arcim=""
	...s orddesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	...i AppOrdDescStr="" s AppOrdDescStr=orddesc
	...e  s AppOrdDescStr=AppOrdDescStr_"^"_orddesc
	
	k ^TMP("ORDAPP",$j)
	q:AppOrdIDStr="" rtn
	
	i rtn=0 d
	.s rtn="1"_$c(2)_ToInsType_$c(2)_ToInsTypeDesc_$c(2)_AdmLocDesc_$c(2)_AppOrdIDStr_$c(2)_AppOrdDescStr
	e  d
	.s tmprtn="1"_$c(2)_ToInsType_$c(2)_ToInsTypeDesc_$c(2)_AdmLocDesc_$c(2)_AppOrdIDStr_$c(2)_AppOrdDescStr
	.s rtn=rtn_$c(3)_tmprtn
	
	q rtn
}

ClassMethod GetOrd(OrdItemID, ItmMast, AppConStr)
{
	n (OrdItemID,ItmMast,AppConStr)
	s rtn=0
	s ArcimDesc=$p($g(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1)),"^",2)
	s oeprice=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),3)),"^",25)
	s OrdPrice=+##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMast,+$H,"","","",oeprice)
	s Qty=##Class(web.UDHCJFBILL).GetQtyO(OrdItemID,"","","",ItmMast)
	s OrdAmt=OrdPrice*Qty
	s OrdAmt=$j(OrdAmt,3,2)
	s ^TMP("ORDAPP",$j,0,"ID")=$g(^TMP("ORDAPP",$j,0,"ID"))_"^"_OrdItemID
	s ^TMP("ORDAPP",$j,0,"DESC")=$g(^TMP("ORDAPP",$j,0,"DESC"))_"^"_ArcimDesc
	s ^TMP("ORDAPP",$j,0,"SUM")=(+$g(^TMP("ORDAPP",$j,0,"SUM")))+OrdAmt
	q rtn
}

ClassMethod GetItem(OrdItemID, ItmMast, AppConStr, StDate, ExpStr)
{
	n (OrdItemID,ItmMast,AppConStr,StDate,ExpStr)
	s rtn=0
	s subcateStr=$p(AppConStr,$c(3),2)
	s oeprice=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),3)),"^",25)
	s Qty=##Class(web.UDHCJFBILL).GetQtyO(OrdItemID,"","","",ItmMast)
	s ExecuDate=""
	f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",ItmMast,"Z",ExecuDate)) q:ExecuDate=""  d
	.q:ExecuDate>StDate
	.s OLT=""
	.f  s OLT=$o(^DHCOLT(0,"ARCIM",ItmMast,"Z",ExecuDate,OLT)) q:OLT=""  d
	..s EndDate=$p(^DHCOLT(OLT),"^",5)
	..i EndDate=""  d
	...s EndDate=+$H+7
	..q:(EndDate<StDate)
	..s qty0=$p(^DHCOLT(OLT),"^",3)
	..s Itm=$p(^DHCOLT(OLT),"^",2)
	..q:Itm=""
	..q:'$d(^DHCTARI(Itm))
	..s ItmSubCate=$p($g(^DHCTARI(Itm)),"^",4)
	..q:ItmSubCate=""
	..q:("^"_subcateStr_"^")'[("^"_ItmSubCate_"^")
	..s ItmPrice=+##CLASS(UDHCJFPRICE).GetItmPrice(Itm,StDate,"","",oeprice)
	..s ItmAmt=Qty*qty0*ItmPrice
	..s ItmAmt=$j(ItmAmt,3,2)
	..s ^TMP("ORDAPP",$j)=(+$g(^TMP("ORDAPP",$j)))+ItmAmt
	..i ("^"_$g(^TMP("ORDAPP",$j,"OrdItemID"))_"^")'[("^"_OrdItemID_"^") s ^TMP("ORDAPP",$j,"OrdItemID")=$g(^TMP("ORDAPP",$j,"OrdItemID"))_"^"_OrdItemID
	..
	..s ^TMP("ORDAPP",$j,0,ItmSubCate)=(+$g(^TMP("ORDAPP",$j,0,ItmSubCate)))+ItmAmt
	..i ("^"_$g(^TMP("ORDAPP",$j,0,ItmSubCate,"OrdItemID"))_"^")'[("^"_OrdItemID_"^") s ^TMP("ORDAPP",$j,0,ItmSubCate,"OrdItemID")=$g(^TMP("ORDAPP",$j,0,ItmSubCate,"OrdItemID"))_"^"_OrdItemID
	
	q rtn
}

ClassMethod CheckSingleOrdApproved(myAdmstr, unordstr, curInsType, ExpStr)
{
	n (myAdmstr,unordstr,curInsType,ExpStr)
	s myAdmstr=$g(myAdmstr),unordstr=$g(unordstr),curInsType=$g(curInsType),ExpStr=$g(ExpStr)
	s rtn=0
	q:'$d(^DHCOPApproved) rtn
	q:myAdmstr="" rtn
	q:curInsType="" rtn
	q:'$d(^PAC("ADMREA",curInsType)) rtn
	s len=$l(myAdmstr,"^")
	f i=1:1:len  d
	.s Adm=$p(myAdmstr,"^",i)
	.q:Adm=""
	.q:'$d(^PAADM(Adm))
	.s rtn=..GetAdmSingleOrdApproved(rtn,Adm,unordstr,curInsType,ExpStr)
	.
	q rtn
}

ClassMethod GetAdmSingleOrdApproved(rtn, Adm, unordstr, curInsType, ExpStr)
{
	n (rtn,Adm,unordstr,curInsType,ExpStr)
	s rtn=$g(rtn),Adm=$g(Adm),unordstr=$g(unordstr),curInsType=$g(curInsType),ExpStr=$g(ExpStr)
	q:'$d(^DHCOPApproved) rtn
	s admInstype=$p($g(^PAADM(Adm,1)),"^",7)
	q:admInstype="" rtn
	s OrdID=$o(^OEORD(0,"Adm",Adm,""))
	q:OrdID="" rtn
	q:'$d(^DHCOPApproved(0,"OrdAppAR",admInstype,curInsType)) rtn
	s ApprovedID=..GetApprovedID(admInstype,curInsType,+$H,ExpStr)
	q:+ApprovedID'>0 rtn
	s AppConID=$p($g(^DHCOPApproved(ApprovedID)),"^",4),ToInsType=$p($g(^DHCOPApproved(ApprovedID)),"^",3)
	q:(AppConID'="")&&('$d(^DHCOPAppCon(AppConID))) rtn
	s AdmLoc=$p($g(^PAADM(Adm)),"^",4)
	s AdmLocDesc=$p($g(^CTLOC(AdmLoc)),"^",2)
	i AdmLocDesc["-" s AdmLocDesc=$p(AdmLocDesc,"-",2)
	
	s ToInsTypeDesc=""
	i ToInsType'="" s ToInsTypeDesc=$p($g(^PAC("ADMREA",ToInsType)),"^",2)
	i AppConID=""  s AppConStr=""
	e  s AppConStr=..GetAppConStr(AppConID,+$H)
	s MinAmt=+$p(AppConStr,$c(3),1)
	s subcateStr=$p(AppConStr,$c(3),2)
	s CateMinAmtStr=$p(AppConStr,$c(3),3)
	k ^TMP("ORDAPP",$j)
	s AppOrdIDStr="",AppOrdDescStr=""
	s find=0
	s sub=0
	f  s sub=$o(^OEORD(OrdID,"I",sub)) q:sub=""  d
	.s OrdItemID=OrdID_"||"_sub
	.s ItmMast=$p($g(^OEORD(OrdID,"I",sub,1)),"^",2)
	.q:ItmMast=""
	.s ItemStat=$p($g(^OEORD(OrdID,"I",sub,1)),"^",13)
	.q:ItemStat=""
	.s ItemStatCode=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
	.q:ItemStatCode="D"
	.q:ItemStatCode="I"
	.s Billed=$p($g(^OEORD(OrdID,"I",sub,3)),"^",5)
	.q:Billed="P"
	.q:unordstr[("^"_OrdItemID_"^")
	.s BBExtCode=$p($g(^OEORD(OrdID,"I",sub,11)),"^",18)
	.q:curInsType'=BBExtCode
	.s DHCORDItemID=$o(^DHCORDItem(0,OrdItemID,""))
	.q:(DHCORDItemID'="")&&($p($g(^DHCORDItem(DHCORDItemID,2)),"^",1)="Y")
	.s ArcimDesc=$p($g(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1)),"^",2)
	.i AppConStr="" d
	..i AppOrdIDStr="" s AppOrdIDStr=OrdItemID,AppOrdDescStr=ArcimDesc
	..e  s AppOrdIDStr=AppOrdIDStr_"^"_OrdItemID,AppOrdDescStr=AppOrdDescStr_"^"_ArcimDesc
	..
	.e  d
	..
	..i subcateStr'="" s err=..GetSingleItem(OrdItemID,ItmMast,AppConStr,+$H,ExpStr)
	..e  s err=..GetSingleOrd(OrdItemID,ItmMast,AppConStr)
	..
	.
	
	i (AppConStr'="")&&(subcateStr="") d
	.s AppOrdIDStr=$g(^TMP("ORDAPP",$j,0,"ID"))
	.s AppOrdDescStr=$g(^TMP("ORDAPP",$j,0,"DESC"))
	
	i (AppConStr'="")&&(subcateStr'="") d
	.
	.s AppOrdIDStr=$g(^TMP("ORDAPP",$j,"OrdItemID"))
	.s AppOrdDescStr=$g(^TMP("ORDAPP",$j,"OrdItemDesc"))
	.
	
	k ^TMP("ORDAPP",$j)
	q:AppOrdIDStr="" rtn
	
	i rtn=0 d
	.s rtn="1"_$c(2)_ToInsType_$c(2)_ToInsTypeDesc_$c(2)_AdmLocDesc_$c(2)_AppOrdIDStr_$c(2)_AppOrdDescStr
	e  d
	.s tmprtn="1"_$c(2)_ToInsType_$c(2)_ToInsTypeDesc_$c(2)_AdmLocDesc_$c(2)_AppOrdIDStr_$c(2)_AppOrdDescStr
	.s rtn=rtn_$c(3)_tmprtn
	
	q rtn
}

ClassMethod GetSingleOrd(OrdItemID, ItmMast, AppConStr)
{
	n (OrdItemID,ItmMast,AppConStr)
	s rtn=0
	s MinAmt=+$p(AppConStr,$c(3),1)
	s ArcimDesc=$p($g(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1)),"^",2)
	s oeprice=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),3)),"^",25)
	s OrdPrice=+##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMast,+$H,"","","",oeprice)
	s Qty=##Class(web.UDHCJFBILL).GetQtyO(OrdItemID,"","","",ItmMast)
	s OrdAmt=OrdPrice*Qty
	s OrdAmt=$j(OrdAmt,3,2)
	q:(+OrdAmt'>MinAmt) rtn
	s ^TMP("ORDAPP",$j,0,"ID")=$g(^TMP("ORDAPP",$j,0,"ID"))_"^"_OrdItemID
	s ^TMP("ORDAPP",$j,0,"DESC")=$g(^TMP("ORDAPP",$j,0,"DESC"))_"^"_ArcimDesc
	;s ^TMP("ORDAPP",$j,0,"SUM")=(+$g(^TMP("ORDAPP",$j,0,"SUM")))+OrdAmt
	q rtn
}

ClassMethod GetSingleItem(OrdItemID, ItmMast, AppConStr, StDate, ExpStr)
{
	n (OrdItemID,ItmMast,AppConStr,StDate,ExpStr)
	
	k ^TMP1("ORDAPP",$j)
	s rtn=0
	s MinAmt=+$p(AppConStr,$c(3),1)
	s subcateStr=$p(AppConStr,$c(3),2)
	s subcateminamtStr=$p(AppConStr,$c(3),3)
	s oeprice=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),3)),"^",25)
	s Qty=##Class(web.UDHCJFBILL).GetQtyO(OrdItemID,"","","",ItmMast)
	s ExecuDate=""
	f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",ItmMast,"Z",ExecuDate)) q:ExecuDate=""  d
	.q:ExecuDate>StDate
	.s OLT=""
	.f  s OLT=$o(^DHCOLT(0,"ARCIM",ItmMast,"Z",ExecuDate,OLT)) q:OLT=""  d
	..s EndDate=$p(^DHCOLT(OLT),"^",5)
	..i EndDate=""  d
	...s EndDate=+$H+7
	..q:(EndDate<StDate)
	..s qty0=$p(^DHCOLT(OLT),"^",3)
	..s Itm=$p(^DHCOLT(OLT),"^",2)
	..q:Itm=""
	..q:'$d(^DHCTARI(Itm))
	..s ItmSubCate=$p($g(^DHCTARI(Itm)),"^",4)
	..q:ItmSubCate=""
	..q:("^"_subcateStr_"^")'[("^"_ItmSubCate_"^")
	..s ItmPrice=+##CLASS(UDHCJFPRICE).GetItmPrice(Itm,StDate,"","",oeprice)
	..s ItmAmt=Qty*qty0*ItmPrice
	..s ItmAmt=$j(ItmAmt,3,2)
	..s ^TMP1("ORDAPP",$j,OrdItemID)=(+$g(^TMP1("ORDAPP",$j,OrdItemID)))+ItmAmt
	..s ^TMP1("ORDAPP",$j,OrdItemID,ItmSubCate)=(+$g(^TMP1("ORDAPP",$j,OrdItemID,ItmSubCate)))+ItmAmt
	..
	
	q:'$d(^TMP1("ORDAPP",$j,OrdItemID)) rtn
	s ArcimDesc=$p($g(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1)),"^",2)
	i MinAmt>0  d
	.i +$g(^TMP1("ORDAPP",$j,OrdItemID))>MinAmt  d
	..;s ^TMP("ORDAPP",$j)=(+$g(^TMP("ORDAPP",$j)))+(+$g(^TMP1("ORDAPP",$j,OrdItemID)))
	..s ^TMP("ORDAPP",$j,"OrdItemID")=$g(^TMP("ORDAPP",$j,"OrdItemID"))_"^"_OrdItemID
	..s ^TMP("ORDAPP",$j,"OrdItemDesc")=$g(^TMP("ORDAPP",$j,"OrdItemDesc"))_"^"_ArcimDesc
	e  d
	.s ItmSubCate="",sFlag=""
	.f  s ItmSubCate=$o(^TMP1("ORDAPP",$j,OrdItemID,ItmSubCate)) q:(ItmSubCate="")!(sFlag'="")  d
	..s len=$l(subcateStr,"^")
	..f i=1:1:len  d
	...s subcate=$p(subcateStr,"^",i)
	...q:subcate=""
	...q:subcate'=ItmSubCate
	...s subcateMinAmt=+$p(subcateminamtStr,"^",i)
	...q:(+$g(^TMP1("ORDAPP",$j,OrdItemID,ItmSubCate)))'>subcateMinAmt
	...s sFlag="Y"
	..
	.i sFlag="Y" d
	..;s ^TMP("ORDAPP",$j)=(+$g(^TMP("ORDAPP",$j)))+(+$g(^TMP1("ORDAPP",$j,OrdItemID)))
	..s ^TMP("ORDAPP",$j,"OrdItemID")=$g(^TMP("ORDAPP",$j,"OrdItemID"))_"^"_OrdItemID
	..s ^TMP("ORDAPP",$j,"OrdItemDesc")=$g(^TMP("ORDAPP",$j,"OrdItemDesc"))_"^"_ArcimDesc
	
	k ^TMP1("ORDAPP",$j)
	q rtn
}

ClassMethod GetApprovedID(PatAdmInstype, OrdInsType, StDate, ExpStr)
{
	n (PatAdmInstype,OrdInsType,StDate,ExpStr)                ;ok
	s rtn=0
	s find=0
	s id=""
	f  s id=$o(^DHCOPApproved(0,"OrdAppAR",PatAdmInstype,OrdInsType,id),-1) q:(id="")!(find=1)  d
	.s startdate=$p($g(^DHCOPApproved(id)),"^",5),enddate=$p($g(^DHCOPApproved(id)),"^",6)
	.q:startdate>StDate
	.q:(enddate'="")&&(StDate>enddate)
	.s find=1
	.s rtn=id
	q rtn
}

ClassMethod GetAppConStr(AppConID, StDate)
{
	n (AppConID,StDate)                           ;ok
	s rtn=""
	s AppConID=$g(AppConID)
	q:AppConID="" rtn
	q:'$d(^DHCOPAppCon(AppConID)) rtn
	s ACMinAmount=+$p($g(^DHCOPAppCon(AppConID)),"^",2),ACDateFrom=$p($g(^DHCOPAppCon(AppConID)),"^",3),ACDateTo=$p($g(^DHCOPAppCon(AppConID)),"^",4)
	q:ACDateFrom>StDate rtn
	q:(ACDateTo'="")&&(StDate>ACDateTo) rtn
	s tmpstr1="",tmpstr2=""
	s sub=0
	f  s sub=$o(^DHCOPAppCon(AppConID,"C",sub)) q:sub=""  d
	.s Gstr=$g(^DHCOPAppCon(AppConID,"C",sub))
	.s SubCate=$p(Gstr,"^",1),CateMinAmount=+$p(Gstr,"^",2)
	.s ACCDateFrom=$p(Gstr,"^",3),ACCDateTo=$p(Gstr,"^",4)
	.q:SubCate=""
	.q:ACCDateFrom>StDate 
	.q:(ACCDateTo'="")&&(StDate>ACCDateTo)
	.i tmpstr1="" s tmpstr1=SubCate
	.e  s tmpstr1=tmpstr1_"^"_SubCate
	.i tmpstr2="" s tmpstr2=CateMinAmount
	.e  s tmpstr2=tmpstr2_"^"_CateMinAmount
	.
	.
	q:(ACMinAmount=0)&&(tmpstr1="") rtn
	s rtn=ACMinAmount_$c(3)_tmpstr1_$c(3)_tmpstr2
	q rtn
}

ClassMethod ChangeOrdInstype(ALLAppOrdRowIDStr, ToInsType, Guser, ExpStr)
{
	n (ALLAppOrdRowIDStr,ToInsType,Guser,ExpStr)
	s rtn=0
	q:$g(ALLAppOrdRowIDStr)="" rtn
	q:$g(ToInsType)="" rtn
	q:'$d(^PAC("ADMREA",ToInsType)) rtn
	s $ZT="ERROR^DHCSSERR" d ..tb()
	s len=$l(ALLAppOrdRowIDStr,$c(3))
	f i=1:1:len  d
	.q:rtn'=0
	.s tmpstr=$p(ALLAppOrdRowIDStr,$c(3),i)
	.q:tmpstr=""
	.s AppOrdRowIDStr=$p(tmpstr,$c(2),5)
	.s ToAdmInsType=$p(tmpstr,$c(2),2)
	.s rtn=..ChangeAdmInstype(AppOrdRowIDStr, ToAdmInsType, Guser, ExpStr)
	d ..tc()
	q rtn
}

ClassMethod ChangeAdmInstype(AppOrdRowIDStr, ToInsType, Guser, ExpStr)
{
	n (AppOrdRowIDStr, ToInsType, Guser, ExpStr)
	s rtn=0
	q:$g(AppOrdRowIDStr)="" rtn
	q:$g(ToInsType)="" rtn
	q:'$d(^PAC("ADMREA",ToInsType)) rtn
	
	s len=$l(AppOrdRowIDStr,"^")
	f j=1:1:len  d
	.q:rtn'=0
	.s OrdRowID=$p(AppOrdRowIDStr,"^",j)
	.q:OrdRowID=""
	.q:'$d(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2)))
	.k PLIST
	.s PLIST(206)=ToInsType
	.s rtn=..UpdateOrderItem(OrdRowID)
	.
	q rtn
}

ClassMethod UpdateOrderItem(OrdRowID)
{
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE oe_orditem VALUES PLIST() WHERE oeori_Rowid= :OrdRowID)
	;d ..tc()
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
