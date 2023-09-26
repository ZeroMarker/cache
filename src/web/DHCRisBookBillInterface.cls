Import SQLUser

Class web.DHCRisBookBillInterface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 2014-07-02 为哈医大增加自动打印预约单接口
/// 获取病区打印数据
/// 按照医嘱号来设置打印标示
/// sunyi 2011-12-16
ClassMethod SetPrintFlag(oeorditemdr As %String)
{
	s ^t=oeorditemdr
	s ^DHCRISORDITEMPRINTED(oeorditemdr)="Y"	
	q 0
}

/// 按照医嘱号来设置打印人和打印时间
/// liuyang
ClassMethod SetPtertime(oeorditemdr, Printinfo) As %String
{
	n (oeorditemdr,Printinfo)
	s ^DHCRISPTERTIMETMP(oeorditemdr)=Printinfo
	q ^DHCRISPTERTIMETMP(oeorditemdr)
}

/// 根据科室代码获取ID
ClassMethod GetLocRowidbyCode(Code As %String)
{
	s LocRowid=""
	q:(Code="")
	s LocRowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),LocRowid))
	q LocRowid
}

/// 根据医嘱号获取备注（下医嘱时备注）
ClassMethod GetMemo(Oeorditemdr As %String) As %String
{
    s Notes=""
    i Oeorditemdr'="" d
    .s itemsub=$p(Oeorditemdr,"||",2)
    .s Notes=$g(^OEORD(+Oeorditemdr,"I",itemsub,"DEP",1))
    
    q Notes
}

ClassMethod GetWardByLoc(LocDr) As %String
{
	s LocType=$p(^CTLOC(LocDr),"^","13")
	if (LocType="W")
	{
		s warrowid=0
		s warrowid=$o(^PAWARD(0,"WARD_LocationDR",LocDr,warrowid)) 
		q warrowid
	}
	else
	{
		q ""
	}
}

/// 根据医护人员Code获取病区ID
/// 
ClassMethod GetWardbyUserCode(Code As %String) As %String
{
	q:(Code="")
	s UserRowid="",LocDr="",ward=""
	s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code),UserRowid))
	q:(UserRowid="")
	s LocDr=$p($g(^SSU("SSUSR",UserRowid)),"^",4)
	i LocDr'="" s ward=..GetWardByLoc(LocDr)
	
	q ward
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisBookBillInterface","QueryNoPrintItem","314")
Query QueryNoPrintItem(UserCode As %String = "") As %Query(ROWSPEC = "oeorditemdr:%String")
{
}

ClassMethod QueryNoPrintItemExecute(ByRef qHandle As %Binary, UserCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s ward=""
	s ward=..GetWardbyUserCode(UserCode)
    i (ward="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s BookDate=+$h
		
	/*s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId)) q:(ResourceId="")  d
	.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:(ResSchduleID="")  d
    ..s DetailRowid=0 f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,ResSchduleID,DetailRowid)) q:(DetailRowid="")  d
    ...s oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	...q:(oeorditemdr="")
	...s OrderRowid="",itemsub="",paadmdr=""
	...s OrderRowid=$p(oeorditemdr,"||",1)
	...s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	...q:(paadmdr="")
	...q:$p($g(^PAADM(paadmdr)),"^",20)'="A" 
    ...q:$p($g(^PAADM(paadmdr)),"^",2)'="I"
	...q:($d(^DHCRISORDITEMPRINTED(oeorditemdr)))
	...Do Export*/
	
	s room=0 f  s room=$o(^PAADMi("CurrWard",ward,room)) q:room=""  d
    .s paadmdr=0 f  s paadmdr=$o(^PAADMi("CurrWard",ward,room,paadmdr)) q:paadmdr=""  d 
    ..q:$p($g(^PAADM(paadmdr)),"^",20)'="A" 
    ..q:$p($g(^PAADM(paadmdr)),"^",2)'="I"
    ..s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",paadmdr,oeordrowid)) q:oeordrowid=""  d
    ...s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    ....s oeorditemdr=oeordrowid_"||"_oeorisub ;病人的所有医嘱
    ....s DetailRowid=""
    ....s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
    ....q:(DetailRowid="")
    ....s ResSchduleID=""
    ....s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",2) 
    ....q:(ResSchduleID="")
    ....s Date=""
    ....s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
    ....q:(Date'="")&(Date<BookDate)
    ....q:($d(^DHCRISORDITEMPRINTED(oeorditemdr)))
	....Do Export 
	
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Export
	set Data=$lb($g(oeorditemdr))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryNoPrintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNoPrintItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryNoPrintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNoPrintItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisBookBillInterface).RequestPrintData("20017||3865")
ClassMethod RequestPrintData(OrditemRowid As %String) As %String
{
	//Name^strAge^SexDesc^bedname^RegNo^BookedDate^AppLocName^OrdName^price^ResourceDesc^LocAddress^PatientNow^Memo^Attention^AppDoc^ItemDate^"机打"^PrintTime
	
	q:(OrditemRowid="")
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,Name,OrderName,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid,PinYin,PInfo,strDOB,strAge,SexDesc)=""
	s (MedicareNo,Memo,wardname,bedname,AppLocName,OrdInfo,Attention,AppDoc,PrintTime,price,ItemDate)=""
	s PrintUser="机打",PDate=+$h ,PTime=$p($h,",",2)
	
	i PDate'="" s PDate=$zd(PDate,3)
	i PTime'="" s PTime=$zt(PTime,2)
	s PrintTime=PDate_" "_PTime
	
	s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 

	i (paadmdr'="")
	{
	   s PInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   i PInfo'="" d
	   .s RegNo=$p($g(PInfo),"^",1)
	   .s Name=$p($g(PInfo),"^",2)
	   .s strDOB=$p($g(PInfo),"^",3)
	   .s strAge=$p($g(PInfo),"^",4)
	   .s SexDesc=$p($g(PInfo),"^",5)
	   .s wardname=$p($g(PInfo),"^",10)
	   .s bedname=$p($g(PInfo),"^",11)
	   .s AppDoc=$p($g(PInfo),"^",18)
	   .s MedicareNo=$p($g(PInfo),"^",33)
	   .s PinYin=$p($g(PInfo),"^",38)
	   .;s AppLocName=$p($g(PInfo),"^",39)
	   
	   s PatientNow=##class(web.DHCRisApplicationBill).GetItemInfo(OrderRowid)
	}
	
    s OrdInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,ItemRowid)
    q:(OrdInfo="")
    
    s OrderName=$p($g(OrdInfo),"^",1)
    s ItemDate=$p($g(OrdInfo),"^",2)
    s ItemTime=$p($g(OrdInfo),"^",3)
    s ItemDate=ItemDate_" "_ItemTime
    s price=$p($g(OrdInfo),"^",12)
    s LocId=$p($g(OrdInfo),"^",19)
    i LocId'="" s Attention=$g(^LocNoticeItem(LocId))
    
    s Memo=..GetMemo(OrditemRowid)
    s AppLocDR=""
    s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
    i AppLocDR'="" s AppLocName=$p($g(^CTLOC(AppLocDR)),"^",2)
    i AppLocName'="" s AppLocName=$p($g(AppLocName),"-",2)
       
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	i (ResDetailRowid'="")
	{
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	   .s ResourceDesc=""
	   .i ResouceId'="" d
	   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	   ..i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	   ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	   ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
	   ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",4)
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=$zd(Date,3)
	   .s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	   .s TimeDesc=""
	   .i TimeDescCode'="" d
	   .s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	   .s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	   .s BookedDate=BookedDate_" "_TimeDesc
	   .;s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
	   .;i StartTime'="" s BooketTime=$zt(StartTime)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .;s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$p($g(^CTLOC(LocId),"ADDR"),"^",16)
	   .s LocAddress=EqAdress
	   .s Info="" 
	   .s Info=Name_"^"_strAge_"^"_SexDesc_"^"_bedname_"^"_RegNo_"^"_BookedDate_"^"_AppLocName_"^"_OrderName_"^"_price_"^"_ResourceDesc_"^"_LocAddress_"^"_PatientNow_"^"_Memo_"^"_Attention_"^"_AppDoc_"^"_ItemDate_"^"_PrintUser_"^"_PrintTime
	   .s ret=..SetPrintFlag(OrditemRowid)
	   
	}
	
	q Info
}

}
