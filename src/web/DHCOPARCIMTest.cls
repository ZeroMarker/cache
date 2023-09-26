Import SQLUser

Class web.DHCOPARCIMTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 277;

ClassMethod CheckARCItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckARCItmMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckARCItmMastExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCOPARCIMTest","CheckARCItmMast")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ##class(web.DHCOPARCIMTest).KillTmp()
	b
	d ##class(web.DHCOPARCIMTest).CheckItm()
	
	;^TMPTARCITM($j,Num)
	
	q:'$d(^TMPTARCITM($j))
	
	s mynum=0
	f  s mynum=$o(^TMPTARCITM($j,mynum)) q:mynum=""  d
	.s Code=$p($g(^TMPTARCITM($j,mynum)),"^",1)
	.s ArcDesc=$p($g(^TMPTARCITM($j,mynum)),"^",2)
	.s ArcDesc1=$p($g(^TMPTARCITM($j,mynum)),"^",3)
	.s ErrDesc=$p($g(^TMPTARCITM($j,mynum)),"^",4)
	.Do OutputRow
	
	d ##class(web.DHCOPARCIMTest).KillTmp()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Code,ArcDesc,ArcDesc1,ErrDesc)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariables
	set (Code,ArcDesc,ArcDesc1,ErrDesc)=""
	quit
}

ClassMethod CheckARCItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckARCItmMastExecute ]
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

ClassMethod CheckItm() As %String
{
	;w ##class(web.DHCOPARCIMTest).CheckItm()
 s Total=0
 s Num=0
 s arcim=0
 k ^TMPTARCITM($j)
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set MEDDATA=Config.DataNamespace
		Set LABDATA=Config.LabDataNamespace
		Set CurrentNS=$ZNSPACE

 f  s arcim=$o(^ARCIM(arcim)) q:arcim=""  d
 .;q:(+arcim>10000)
 .;b	;
 .s Total=Total+1
 .s Code=$p(^ARCIM(arcim,1,1),"^",1)
 .s Desc=$p(^ARCIM(arcim,1,1),"^",2)
 .s arcuom=$p(^ARCIM(arcim,1,8),"^",14)
 .s inci=""
 .zn MEDDATA
 .s inci=$$GetINCI^ST02(arcim)
 .zn CurrentNS
 .s phi=""
 .s phi=$p(^ARCIM(arcim,1,1),"^",12)
 .;w arcim,!
 .;b	;;;
 .i inci'="" d
 ..s inccode=$p(^INCI(inci,1),"^",1)
 ..s incdesc=$p(^INCI(inci,1),"^",2)
 ..i Code'=inccode  s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_inccode_"^Stock Code not is ARCIM Code"
 ..i Desc'=incdesc  s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_incdesc_"^Stock Desc not is ARCIM Desc"
 ..s incuom=$p(^INCI(inci,1),"^",10)
 ..s conv=$o(^CT("CTCF",0,"UOM",arcuom,incuom,""))
 ..i conv=""&(incuom'=arcuom) s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_incdesc_"^Billing UOM is Error!"
 .;判断转换系数
 .;
 .i phi'=""&(phi'=-1) d
 ..s phicode=$p(^PHCD(+phi,1),"^",1)
 ..s phidesc=$p(^PHCD(+phi,1),"^",2)
 ..i Code'=phicode  s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_phicode_"^Pharmacy Code not is ARCIM Code"
 ..i Desc'=phidesc  s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_phidesc_"^Pharcmacy Desc not is ARCIM Desc"
 ..s phiuom=$p(^PHCD(+phi,"DF",$p(phi,"||",2),2),"^",4)
 ..i inci'=""&(incuom'=phiuom) s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^"_phidesc_"^Pharcmacy UOM is not INCI UOM"
 .;
 .i (inci="")&(phi'="")&(phi'=-1) s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^No Stock Item"
 .i (inci'="")&((phi="")!(phi=-1)) s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^No Pharmacy Item"
 .;
 .;s TarItm=""
 .;s TarItm=$o(^DHCTARI(0,"Code",Code,""))
 .;i TarItm="" s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^No Tariff Item"
 .;TarItemLink表
 .s TarItm=""
 .f  s TarItm=$o(^DHCOLT(0,"ARTTA",arcim_"||1",TarItm)) q:TarItm=""  d
 ..s Date="" 
 ..s Date=$o(^DHCOLT(0,"ARTTA",arcim_"||1",TarItm,""))
 ..i Date="" s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^医嘱账单连接表开始日期错误"
 ..i (Date'="")&&(+Date>+$h) s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^医嘱账单连接表开始日期错误"
 ..s Link=""
 ..i Date'="" s Link=$o(^DHCOLT(0,"ARTTA",arcim_"||1",TarItm,Date,""))
 ..i Date'=""&(Link="") s Num=Num+1 s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^医嘱账单连接表错误?重新加入连接关系"
 .s myinstr=""
 .f  s myinstr=$o(^DHCOLT(0,"ARCIM",arcim_"||1",myinstr)) q:myinstr=""  d
		..i myinstr'="Z" d
		...s Num=Num+1 
		...s ^TMPTARCITM($j,Num)=Code_"^"_Desc_"^^连接表中添加用法错误?导致单价=0"
 .;w "."
 q
}

ClassMethod CheckRecLoc(PAPMI As %String, BegACIM As %String, EndACIM As %String) As %String
{
	;重新编一个接收单位的验证
	;w ##class(web.DHCOPARCIMTest).CheckRecLoc("222","1","5")
	;w ##class(web.DHCOPARCIMTest).CheckRecLoc("222","5000","10000")
	;w ##class(web.DHCOPARCIMTest).CheckRecLoc("222","1","12100")
	;^PAADMi("PAADM_AdmDate"
	;d ..KillTmp()
	
	s myPaadmStr=""
	s vIdx=0
	s mycurdate=+$h
	s myPAADMRowID=""
	f  s myPAADMRowID=$o(^PAADMi("PAADM_AdmDate",mycurdate,myPAADMRowID)) q:myPAADMRowID=""  d
	.s myPAPMI=$p(^PAADM(myPAADMRowID),"^",1)
	.q:myPAPMI'=PAPMI
	.;w myPAADMRowID,!
	.s myPaadmStr=$g(myPaadmStr)_myPAADMRowID_"^"
	
	d ##class(web.DHCOPARCIMTest).OEFCheckRecLoc(myPaadmStr,BegACIM,EndACIM)
}

ClassMethod CheckRecLocNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckRecLocNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckRecLocNewExecute(ByRef qHandle As %Binary, PAPMI As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCOPARCIMTest","CheckRecLocNew","00000010")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ##class(web.DHCOPARCIMTest).KillTmp()
	
	;&sql(select PAPMI_RowID into :myPRowID from PA_PatMas where PAPMI_No=:PAPMI)
	s PAADMRIDStr=""
	s vIdx=0
	s mycurdate=+$h
	s myPAADMRowID=""
	f  s myPAADMRowID=$o(^PAADMi("PAADM_AdmDate",mycurdate,myPAADMRowID)) q:myPAADMRowID=""  d
	.s myPAPMI=$p(^PAADM(myPAADMRowID),"^",1)
	.q:myPAPMI'=myPRowID
	.s PAADMRIDStr=$g(PAADMRIDStr)_myPAADMRowID_"^"
	
	b
	
	s mynum=0
	s arcim=0
	
	f  s arcim=$o(^ARCIM(arcim)) q:arcim=""  d
	.s myCount=$l(PAADMRIDStr,"^")
	.s ACRIMRowID=arcim_"||1"
	.for vADMIdx=1:1:myCount d
	..s PAADMRID=$p(PAADMRIDStr,"^",vADMIdx)
	..q:PAADMRID=""
	..s aritmcat=$p(^ARCIM(+arcim,1,1),"^",10)
	..s subcatdesc=$p(^ARC("IC",aritmcat),"^",2)
	..s subcatordtype=$p(^ARC("IC",aritmcat),"^",7)
	..s patInsType="1"
	..s patInsType=$p(^PAADM(PAADMRID,1),"^",7)
	..s ARCType="ARCIM"
	..s ORDType=""
	..s OEPrice=""
	..s EpRecLocID=$p(^PAADM(PAADMRID),"^",4)
	..s EpRecDesc=$p(^CTLOC(EpRecLocID),"^",2)
	..i subcatordtype="P" s OEPrice=100
	..;s myPInfo=..GetPrice(PAADMRID,ACRIMRowID,"",patInsType,OEPrice,ARCType)
	..;价格问题?
	..;ARCIM_ItemCat_DR->ARCIC_OrderType    subcatordtype
	..;
	..;验证接收科室
	..;s myRecInfo=..GetRecLoc(PAADMRID,ACRIMRowID,subcatordtype)
	..s myRecInfo=$$OutRecLocInfo()
	..i +myRecInfo=0 d
	...s mynum=+$g(mynum)+1
	...s ^TMPTARCITM($j,"ARCRecLocErr",EpRecLocID,aritmcat)=subcatdesc_"^"_subcatordtype_"^"_EpRecDesc_"^没有默认的接收科室"
	..q:myRecInfo=""
	
	;d ResetVariablesRecLoc
		
	s myrecloc=0
	f  s myrecloc=$o(^TMPTARCITM($j,"ARCRecLocErr",myrecloc)) q:myrecloc=""  d
	.s myitmcat=0
	.f  s myitmcat=$o(^TMPTARCITM($j,"ARCRecLocErr",myrecloc,myitmcat)) q:myitmcat=""  d
	..s mycatdesc=$p($g(^TMPTARCITM($j,"ARCRecLocErr",myrecloc,myitmcat)),"^",1)
	..s mycatordtype=$p($g(^TMPTARCITM($j,"ARCRecLocErr",myrecloc,myitmcat)),"^",2)
	..s myRecDesc=$p($g(^TMPTARCITM($j,"ARCRecLocErr",myrecloc,myitmcat)),"^",3)
	..s ErrDesc=$p($g(^TMPTARCITM($j,"ARCRecLocErr",myrecloc,myitmcat)),"^",4)
	..Do OutputRowRecLoc
	b
	d ##class(web.DHCOPARCIMTest).KillTmp()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowRecLoc
 set Data=$lb(mycatdesc,mycatordtype,myRecDesc,ErrDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesRecLoc
	set (mycatdesc,mycatordtype,myRecDesc,ErrDesc)=""
	quit
OutRecLocInfo()
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	
		k tmprecloc
		s nCount=0
		s myRecInfo=""
		s myCTLocRID=""
		s mydes=""
		s rtnvalue=$$getall^aOET3a(PAADMRID,ACRIMRowID)
 i rtnvalue=0
		{
	   		s nCount=$o(PLIST(""),-1)
	   		For i=1:1:nCount {
		   		;s tmprecloc(i)=PLIST(i)
		   		s myflag=$p(PLIST(i),$c(2),3)
		   		s myCTLocRID=$p(PLIST(i),$c(2),1)
		   		s mydes=$p(PLIST(i),$c(2),2)
		   		i myflag="Y" d
		   		.s myRecInfo=myCTLocRID_"^"_mydes
		   	}
		   	
		   	
		}
 zn oldnamespace  ; Restore the namespace

	q myRecInfo
}

ClassMethod CheckRecLocNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckRecLocNewExecute ]
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

ClassMethod DelErrPatBillClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DelErrPatBillExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DelErrPatBillExecute(ByRef qHandle As %Binary, PBRowID As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCOPARCIMTest","DelErrPatBill","1791")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	s rtn=0
	
	s rtn=##class(web.UDHCJFPB).SELECT(PBRowID)
	
	;防止Paid的账单被误删?
	if (PLIST(17)="P") d
	.s rtn=-1
	
	b   ;;;;;
	if (rtn=0)  d
	.s rtn=##class(web.UDHCJFPB).DELETE(PBRowID)
	.;s rtn=##class(web.UDHCJFPB).PBDEL(PBRowID)
	.;
	
	d OutputRowDel
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDel
	set Data=$lb(rtn)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod DelErrPatBillFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DelErrPatBillExecute ]
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

ClassMethod GetPrice(bPAAdmRowID As %String, bItmMastRowid As %String, bPatType As %String, bInsType As %String, bOEPrice As %String, bARCType As %String) As %String
{
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:OEItmInfo")
 Set columns = rset.GetColumnCount()
 ;//bPAAdmRowID as %String, bItmMastRowid as %String, bPatType as %String, bInsType as %String
 ;//bOEPrice as %Float,bARCType as %String
 Set rs = rset.Execute(bPAAdmRowID, bItmMastRowid,bPatType,bInsType,bOEPrice,bARCType)
 ;Set rs = rset.Execute("2","8586||1","","","","ARCIM")
	s myRowVal=""
	s myIdx=0
 While (rset.Next()) {
	 	s myRowVal=""
	 	For mycol=1:1:columns {
		 	s mydata=rset.GetData(mycol)
 s myRowVal=$g(myRowVal)_$g(mydata)_"^"	//行集
		}
 }

 d rset.%Close()

 q myRowVal
}

ClassMethod GetRecLoc(bPAADMRowID As %String, bARCIMRID As %String, bARCType As %String) As %String
{
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:AIMRecLoc")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set rs = rset.Execute(bPAADMRowID,bARCIMRID)
	s myRecInfo=""
	While (rset.Next()) {
	 	s myRowVal=""
	 	s defflag=0
	 	s myCTLocRID=$g(rset.Data("RecLocRID"))
	 	s mydes=rset.Data("RecLocDesc")
	 	i $l(rset.Data("RecLocDesc"),"-")>1 d
	 		.s mydes=$p($p(rset.Data("RecLocDesc"),"'"),"-",2)
		
		;验证默认的接收科室
	 	i rset.Data("DefRecFlag")="Y" d
	 	.s myRecInfo=myCTLocRID_"^"_mydes
 }

 ;
 i ((bARCType="R")&&(myRecInfo'="")) d
 .;验证默认药房的接收科室
 .


 d rset.%Close()

 q myRecInfo
}

ClassMethod InputOEItmBatch(PAADMRID As %String, BegACIM As %String, EndACIM As %String) As %String
{
	;w ##class(web.DHCOPARCIMTest).InputOEItmBatch("6","450","480")
	;ARCIM({ARCIM_Subscript},{ARCIM_Version})
	q:(+BegACIM>=+EndACIM) "Error BegACIM>=+EndACIM"
	
	q:PAADMRID="" "error PAADMRID"
	
	;desc,rowid,subcatdesc,subcatordtype,phuomdesc,ItemPrice,$p(phfreqcode,$c(1)),type,TEXT0,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,$p(phdurrowid,$C(1)),generic,"","",""
	s mybegid=+BegACIM-1
	
	d ..KillTmp()
	
	;b	;;
	f vIdx=mybegid:1:EndACIM d
	.s ACRIMRowID=vIdx_"||1"
	.&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			ARCIM_OEMessage,ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatordtype,:ordcatid,
	        :oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,
	        :generic,:subcatdesc
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:ACRIMRowID)
	.q:SQLCODE
	.;b	;;
	.;w desc_"^"_rowid_"^"_subcatdesc_"^"_subcatordtype_"^"_phuomdesc_"^"_$p(phfreqcode,$c(1))
	.s myARCIMInfo=desc_"^"_rowid_"^"_subcatdesc_"^"_subcatordtype_"^"_phuomdesc_"^"_$p(phfreqcode,$c(1))_"^"_subcat
	.;取出价格
	.s patInsType="1"
	.s patInsType=$p(^PAADM(PAADMRID,1),"^",7)
	.s ARCType="ARCIM"
	.s OEPrice=""
	.s EpRecLocID=$p(^PAADM(PAADMRID),"^",4)
	.s EpRecDesc=$p(^CTLOC(EpRecLocID),"^",2)
	.i subcatordtype="P" s OEPrice=100
	.s myPInfo=..GetPrice(PAADMRID,ACRIMRowID,"",patInsType,OEPrice,ARCType)
	.;验证接收科室
	.s myRecInfo=..GetRecLoc(PAADMRID,ACRIMRowID,subcatordtype)
	.i myRecInfo="" d
	..;s ^TMPTARCITM($j,"ARCRecLocErr",EpRecLocID,subcat)=subcatdesc_"^"_subcatordtype_"^"_EpRecDesc_"^没有默认的接收科室"
	..;s ^TMPTARCITM($j,"ARCRecLocErr",EpRecLocID,ACRIMRowID)=myARCIMInfo_"^"_EpRecDesc_"^没有默认的接收科室"
	.q:myRecInfo=""
	.;验证库存
	.s myStock=1
	.i subcatordtype="R" d
	..s myRecRID=$p(myRecInfo,"^")
	..s myStock=##class(web.DHCOPCashier).CheckStockEnough(ACRIMRowID,"1",myRecRID)
	.i myStock=0 d
	..;s ^TMPTARCITM($j,"StockErr",EpRecLocID,ACRIMRowID)=myARCIMInfo_"^"_myRecInfo_"^没有库存"
	.q:myStock=0		;库存不够退出
	.;下面写医嘱信息
	.s ^TMPTARCITM($j,"Normal",ACRIMRowID)=myARCIMInfo_"^"_myPInfo_myRecInfo
	.;b	;;
}

ClassMethod KillTmp()
{
	;w ##class(web.DHCOPARCIMTest).KillTmp()
	k ^TMPTARCITM($j)
	k ^TMP($j)
}

ClassMethod OEFCheckRecLoc(PAADMRIDStr As %String, BegACIM As %String, EndACIM As %String) As %String
{
	;w ##class(web.DHCOPARCIMTest).InputOEItmBatch("1210","1","10")
	;ARCIM({ARCIM_Subscript},{ARCIM_Version})
	q:(+BegACIM>=+EndACIM) "Error BegACIM>=+EndACIM"
	
	q:PAADMRIDStr="" "error PAADMRID"
	
	;desc,rowid,subcatdesc,subcatordtype,phuomdesc,ItemPrice,$p(phfreqcode,$c(1)),type,TEXT0,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,$p(phdurrowid,$C(1)),generic,"","",""
	s mybegid=+BegACIM-1
	
	;d ..KillTmp()
	
	f vIdx=mybegid:1:EndACIM d
	.s ACRIMRowID=vIdx_"||1"
	.w vIdx,!
	.&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			ARCIM_OEMessage,ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatordtype,:ordcatid,
	        :oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,
	        :generic,:subcatdesc
	   	FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:ACRIMRowID)
	.q:SQLCODE
	.s myARCIMInfo=desc_"^"_rowid_"^"_subcatdesc_"^"_subcatordtype_"^"_phuomdesc_"^"_$p(phfreqcode,$c(1))_"^"_subcat
	.;b ;
	.;取出价格
	.s myCount=$l(PAADMRIDStr,"^")
	.for vADMIdx=1:1:myCount d
	..s PAADMRID=$p(PAADMRIDStr,"^",vADMIdx)
	..q:PAADMRID=""
	..s patInsType="1"
	..s patInsType=$p(^PAADM(PAADMRID,1),"^",7)
	..s ARCType="ARCIM"
	..s ORDType=""
	..s OEPrice=""
	..s EpRecLocID=$p(^PAADM(PAADMRID),"^",4)
	..s EpRecDesc=$p(^CTLOC(EpRecLocID),"^",2)
	..i subcatordtype="P" s OEPrice=100
	..s myPInfo=..GetPrice(PAADMRID,ACRIMRowID,"",patInsType,OEPrice,ARCType)
	..;验证接收科室
	..s myRecInfo=..GetRecLoc(PAADMRID,ACRIMRowID,subcatordtype)
	..i myRecInfo="" d
	...s ^TMPTARCITM($j,"ARCRecLocErr",EpRecLocID,subcat)=subcatdesc_"^"_subcatordtype_"^"_EpRecDesc_"^没有默认的接收科室"
	..q:myRecInfo=""
	..;验证库存
	..s myStock=1
	..i subcatordtype="R" d
	...s myRecRID=$p(myRecInfo,"^")
	...s myStock=##class(web.DHCOPCashier).CheckStockEnough(ACRIMRowID,"1",myRecRID)
	..i myStock=0 d
	...s ^TMPTARCITM($j,"StockErr",EpRecLocID,ACRIMRowID)=myARCIMInfo_"^"_myRecInfo_"^没有库存"
	..q:myStock=0		;库存不够退出
}

ClassMethod OPFErrQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPFErrQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPFErrQueryExecute(ByRef qHandle As %Binary, PatNO As %String, BeginDate As %String, EndDate As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCOPARCIMTest","OPFErrQuery","00004556","2005-12-26","2005-12-30")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ##class(web.DHCOPARCIMTest).KillTmp()
	
	d ResetVariablesFErr
	s Idx=0
	s nCount=$l(PatNO,"^")
	
	set PatNO=$g(PatNO)
	set BeginDate=$g(BeginDate)
	set EndDate=$g(EndDate)
		
	for i=1:1:nCount d
	.s myPatNo=$p(PatNO,"^")
	.;&sql(select PAPMI_RowID into :myPRowID from PA_PatMas where PAPMI_No=:myPatNo)
	.;根据日期取出时间段内的ADM
	.;^PAADMi("AdmDateCurr",{PAADM_AdmDate},{PAADM_RowID})
	.s BeginDate=$zdh(BeginDate,3)
	.s EndDate=$zdh(EndDate,3)
	.s myAdmDate=BeginDate-1
	.f  s myAdmDate=$o(^PAADMi("AdmDateCurr",myAdmDate)) q:(myAdmDate="")||(myAdmDate>EndDate)  d
	..s AdmRowID=0
	..
	..f  s AdmRowID=$o(^PAADMi("AdmDateCurr",myAdmDate,AdmRowID)) q:AdmRowID=""  d
	...;^DHCPB(0,"ADM",{PB_Adm_Dr},{PB_RowId})
	...s myPAPMI=$p(^PAADM(AdmRowID),"^",1)
	...;b	;order
	...q:myPRowID'=myPAPMI
	...s PAADMDate=$p(^PAADM(AdmRowID),"^",6)
	...s:PAADMDate'="" PAADMDate=$zd(PAADMDate,3)
	...s PAADMTime=$p(^PAADM(AdmRowID),"^",7)
	...s:PAADMTime'="" PAADMTime=$zt(PAADMTime)
	...s PAADMID=$p(^PAADM(AdmRowID),"^",1)
	...s PAName=$p(^PAPER(PAADMID,"ALL"),"^",1)
	...s billcount=0
	...s PBrowid=0
	...;b	;Adm
	...f  s PBrowid=$o(^DHCPB(0,"ADM",AdmRowID,PBrowid))  q:PBrowid=""  d
	....;^DHCPB({PB_RowId})
	....s PayFlag=$p(^DHCPB(PBrowid),"^",16)
	....;b	;PB
	....i (PayFlag="B") d
	.....s billcount=+billcount+1
	.....i (+billcount>1) d
	......s Idx=+Idx+1
	......s patbillinfo=^DHCPB(PBrowid)
	......;输出信息?患者姓名?就诊日期时间?费别类型?
	......s ^TMPTARCITM($j,Idx)=PAName_"^"_PAADMDate_"^"_PAADMTime_"^"_PBrowid_"^"_patbillinfo
	
	s mynum=0
	f  s mynum=$o(^TMPTARCITM($j,mynum)) q:mynum=""  d
	.s PAName=$p($g(^TMPTARCITM($j,mynum)),"^",1)
	.s PAADMDate=$p($g(^TMPTARCITM($j,mynum)),"^",2)
	.s PAADMTime=$p($g(^TMPTARCITM($j,mynum)),"^",3)
	.s PBrowid=$p($g(^TMPTARCITM($j,mynum)),"^",4)
	.s PBDate=$p($g(^TMPTARCITM($j,mynum)),"^",23)
	.s:PBDate'="" PBDate=$zd(PBDate,3)
	.s PBTime=$p($g(^TMPTARCITM($j,mynum)),"^",24)
	.s:PBTime'="" PBTime=$zt(PBTime)
	.Do OutputRowFErr
	
	d ##class(web.DHCOPARCIMTest).KillTmp()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFErr
	set Data=$lb(PAName,PAADMDate,PAADMTime,PBrowid,PBDate,PBTime)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariablesFErr
	set (PAName,PAADMDate,PAADMTime,PBrowid,PBDate,PBTime)=""
	quit
}

ClassMethod OPFErrQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPFErrQueryExecute ]
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

ClassMethod SaveOrder(ADMRID As %String, InsTypeDR As %String) As %String
{
	;ADMRDR->PA_ADMReason->RowID
	;web.DHCOPCashier.CashierInsertOrdItem(Adm As %String, OrdItemStr , User , Loc , DocUserId , OSRID)
	;w ##class(web.DHCOPARCIMTest).SaveOrder("6","3")
	q:($d(^TMPTARCITM($j,"Normal"))=0) ""
	
	;大黄蛰虫丸(60g)^12||1^丸剂(甲类中成药)^R^盒(60g)^tid^561^32.3000^0.0000^0.0000^32.3000^643^中成药房
	s myRowid=""
	s rtn=0
	f  s myRowid=$o(^TMPTARCITM($j,"Normal",myRowid)) q:((myRowid="")||(rtn'=0))  d
	.s OrdItemStr=""
	.s OrdItemStr=$p(^TMPTARCITM($j,"Normal",myRowid),"^",2)
	.s OrdItemStr=OrdItemStr_"^1"
	.s OrdItemStr=OrdItemStr_"^"_$p(^TMPTARCITM($j,"Normal",myRowid),"^",12)
	.s OrdItemStr=OrdItemStr_"^"_$p(^TMPTARCITM($j,"Normal",myRowid),"^",8)
	.s OrdItemStr=OrdItemStr_"^"
	.s OrdItemStr=OrdItemStr_"^"_InsTypeDR
	.s User="10137"
	.s Loc="693"
	.s DocUserId=""
	.s OSRID=""	;ARC_OrdSets
	.;b ;
	.s rtnvalue=##class(web.DHCOPCashier).CashierInsertOrdItem(ADMRID,OrdItemStr,User,Loc,DocUserId,OSRID)
	.;b	;
	.s rtn=$p(rtnvalue,"^",1)
	.q:rtn
	
	q:rtn
	;
	s rtn=##class(web.DHCOPCashier).CreatePrescNo(ADMRID)
}

ClassMethod TestTarLink() As %String
{
	;测试医嘱与计费项连接表的一个索引?
	;w ##class(web.DHCOPARCIMTest).TestTarLink()
	k ^TMP($j)
	s arcimrid=0
	f  s arcimrid=$o(^DHCOLT(0,"ARCIM",arcimrid)) q:arcimrid=""  d
	.q:'$d(^ARCIM(+arcimrid,1))
	.s arcimdesc=$p(^ARCIM(+arcimrid,$p(arcimrid,"||",2),1),"^",2)
	.s myinstr=""
	.f  s myinstr=$o(^DHCOLT(0,"ARCIM",arcimrid,myinstr)) q:myinstr=""  d
	..i myinstr'="Z" d
	...s ^TMP($j,"TZ",arcimrid,myinstr)=arcimdesc
	...
}

/// ////w ##class(web.DHCOPARCIMTest).CheckARCItmMast()
Query CheckARCItmMast() As %Query(ROWSPEC = "Code:%String,ItemDesc:%String,ItemDesc1:%String,ErrDesc:%String")
{
}

Query CheckRecLocNew(PAPMI As %String) As %Query(ROWSPEC = "Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String")
{
}

Query DelErrPatBill(PBRowID As %String) As %Query(ROWSPEC = "SuccFlag:%String")
{
}

Query OPFErrQuery(PatNO As %String, BeginDate As %String, EndDate As %String) As %Query(ROWSPEC = "PAName:%String,PAADMDate:%String,PAADMTime:%String,PBrowid:%String,PBDate:%String,PBTime:%String")
{
}

Query ReadCTLoc() As %SQLQuery(CONTAINID = 1)
{
	select CTLOC_RowID,CTLOC_Code,CTLOC_Desc from CT_Loc
}

}
