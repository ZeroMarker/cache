Class web.DHCPE.PrintIAdmInfo Extends %Persistent
{

/// 功能:条码打印
/// 创建:2018.09.06
/// 创建人:xy
/// d ##class(%ResultSet).RunQuery("web.DHCPE.PrintIAdmInfo","SearchPrintIAdmInfo","507")
Query SearchPrintIAdmInfo(PAADM As %Library.String = "") As %Query(ROWSPEC = "STID:%String,STation:%String,OEID:%String,ARCIMDesc:%String,PAADM:%String,LabSpecNo:%String,OrdName:%String,PrintType:%String,Str:%String,IsPrint:%String")
{
}

ClassMethod SearchPrintIAdmInfoExecute(ByRef qHandle As %Binary, PAADM As %Library.String = "") As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
 	q:PAADM="" ""
 	s Single=$J
 	k ^TempDHCPEPrintIAdmInfoSortHUI(Single)
	s LabSpecNo="",OrdName="",PrintType=""

	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))

	s RisStation="^"_RisStation_"^"_OtherStation_"^"
	
	s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)	
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""		
    s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(IADM)
    ;q:Flag="1" "NoPayed"
    s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
    s PGDesc="个人"
    s:GADM'="" PGDesc="团体"
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IADM)
    s VIPDesc=$P(VIPLevel,"^",2)
		
	s Name=PAADMObj.PAADMPAPMIDR.PAPMIName
	s RegNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
	s Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Age=PAADMObj.PAADMPAPMIDR.PAPMIDOB
	s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
	s PatLoc=PAADMObj.PAADMDepCodeDR.CTLOCDesc
	s PatLoc=##class(web.DHCPE.Query.IAdmItemStatus).GetShortLocDesc(PatLoc)
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ""
	s OrderObj=##class(User.OEOrder).%OpenId(Order)
	s Length=OrderObj.ChildOEOrdItem.Count()
	q:Length=0 ""
	s ItemInfo=""
	s Flag=0
	
	
	for i=1:1:Length
	{
		s PrintType=""
		s obj=OrderObj.ChildOEOrdItem.GetAt(i)
		s OEORIStatus=obj.OEORIItemStatDR.OSTATCode
		continue:OEORIStatus="D" ;医嘱停止的不再显示
		;continue:OEORIStatus="E" ;医嘱执行的不再显示
		s OEID=obj.%Id()
		continue:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID))
		s ARCIMID=obj.OEORIItmMastDRGetObjectId()
		continue:ARCIMID=""
		;s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
		s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
		S STID=$p(StatOrderDR,"||",1)
		continue:STID=""
		s STation=$P($g(^DHCPEST(STID)),"^",2)
		s LabSpecNo=obj.OEORILabEpisodeNo
		;s:LabSpecNo="" LabSpecNo=999999
		;s NeedPrint=##class(web.DHCPE.Query.IAdmItemStatus).NeedPrint(OEID, ARCIMID)
		;continue:(LabSpecNo="")&&(NeedPrint=0)
		s NeedPrint="N"
		s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
		i StatOrdSetID'="" s NeedPrint=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),14)  //基本信息条码(科室站点项目扩展表
		i NeedPrint="" s NeedPrint="N"
		continue:(LabSpecNo="")&&(NeedPrint="N")
		s ARCIMDesc=obj.OEORIItmMastDR.ARCIMDesc //ARCIMDesc ARCIMAbbrev
		i (LabSpecNo'="") d
		.s CRMOID=$o(^DHCPECRMO(0,"OEORI",OEID,0))
		.s PaiedFlag=$p($g(^DHCPECRMO(CRMOID)),"^",4)
		.s PrintType="Lis"
		.s OrdName=##class(web.DHCPE.BarPrint).GetARCIMDesc(LabSpecNo,+OEID,",")
		.s OrdName=$P(OrdName,$C(1),1)_PrintType
		e  i (RisStation[("^"_STID_"^")) d
		.s LabSpecNo="&nbsp"
		.s OrdName="&nbsp"
		.s PrintType="Ris"
		e  d
		.s LabSpecNo="&nbsp"
		.s OrdName="&nbsp"
		
		s disabled=""
		s RecLoc=obj.OEORIRecDepDR.CTLOCDesc
		s RecLoc=##class(web.DHCPE.Query.IAdmItemStatus).GetShortLocDesc(RecLoc)
		;s OrdName=OrdName_PrintType
		i PrintType="Lis" d
		.i $G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,LabSpecNo))="" d
		..s ^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,LabSpecNo)=PAADM_"^"_OEID_"^"_STation_"^"_OrdName_"^"_PrintType_"^"_0_";"_ARCIMDesc
		..s ^TempDHCPEPrintIAdmInfoSortHUI(Single,"LabSpecNo",LabSpecNo,OEID)=PaiedFlag
		.e  d
		..s ^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,LabSpecNo)=$G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,LabSpecNo))_","_ARCIMDesc
		e  d
		.s ^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEID)=PAADM_"^"_OEID_"^"_STation_"^"_OrdName_"^"_PrintType_"^"_0_";"_ARCIMDesc
	
	}
	   s (STID,STation,OEID,ARCIMDesc,PAADM,LabSpecNo,OrdName,PrintType,Str,IsPrint)=""
 	    s STID=""
 		f  s STID=$O(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID))  q:STID=""  d
 		.s SpecNo=""
		.f  s SpecNo=$O(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo))  q:SpecNo=""  d
		..s PAADM=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo)),"^",1)
		..s OEID=$o(^TempDHCPEPrintIAdmInfoSortHUI(Single,"LabSpecNo",SpecNo,0))
		..s ARCIMDesc=""
		..s ARCIMDesc=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo)),";",2)
		..s STation=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo)),"^",3)
		..s LabSpecNo=SpecNo
		..s OrdName=""
		..s OrdName=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo)),"^",4)
		..s PrintType=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Lis",STID,SpecNo)),"^",5)
		..s Str=PAADM_"^"_OEID_"^"_PrintType_"^"_SpecNo
		..s IsPrint="N"
		..i $G(^DHCPEDataEx("OEOrderItem","PrintLisRequest",SpecNo))="Y" d
		...s OrdName="<font color=red>"_OrdName_"</font>"
		...s IsPrint="Y"
		..d OutPutIAdmInfo
	   
	    
			
 	    s STID=""
		f  s STID=$O(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID))  q:STID=""  d
		.s OEItemID=""
		.f  s OEItemID=$O(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID))  q:OEItemID=""  d
		..s PAADM=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID)),"^",1)
		..s OEID=OEItemID
		..s OrdName=""
		..s OrdName=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID)),"^",4)
		..s STation=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID)),"^",3)
		..s ARCIMDesc=""
		..s ARCIMDesc=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID)),";",2)
		..s PrintType=$P($G(^TempDHCPEPrintIAdmInfoSortHUI(Single,"Other",STID,OEItemID)),"^",5)
		..s Str=PAADM_"^"_OEItemID_"^"_PrintType_"^"_""
		..s IsPrint="N"
		..i $G(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEItemID))="Y" d
        ...s OrdName="<font color=red>"_OrdName_"</font>"
        ...s IsPrint="Y"
        ..d OutPutIAdmInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutIAdmInfo
	set Data=$lb(STID,STation,OEID,ARCIMDesc,PAADM,LabSpecNo,OrdName,PrintType,Str,IsPrint)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPrintIAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPrintIAdmInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPrintIAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPrintIAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// added by xy 20180906

// function:获取服务器IP

ClassMethod getSet() As %String
{
   //w ##class(web.DHCPE.DHCPECommon).getSet()
	s id=$O(^Nur.DHCMGNurseSetD(""))
	if id="" q ""
	s db=$ListGet(^Nur.DHCMGNurseSetD(id),2)
	s websv=$ListGet(^Nur.DHCMGNurseSetD(id),3)
	s genpath=$ListGet(^Nur.DHCMGNurseSetD(id),4)
	//q db_"^"_websv_"^"_genpath
	Q websv
}

// w ##class(web.DHCPE.PrintIAdmInfo).OutMyUI()

ClassMethod OutMyUI(PAADM)
{
	;IAdmID->paadmID
	q:PAADM="" ""
	s LabSpecNo="",OrdName="",PrintType=""
	/*
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
	*/
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))

	s RisStation="^"_RisStation_"^"_OtherStation_"^"
	s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)
		
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""		
    s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(IADM)
    ;q:Flag="1" "NoPayed"
    s GADM=$P(^DHCPEIADM(IADM),"^",2)
    s PGDesc="个人"
    s:GADM'="" PGDesc="团体"
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
    s VIPDesc=$P(VIPLevel,"^",2)
		
	s Name=PAADMObj.PAADMPAPMIDR.PAPMIName
	s RegNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
	s Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Age=PAADMObj.PAADMPAPMIDR.PAPMIDOB
	s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
	s PatLoc=PAADMObj.PAADMDepCodeDR.CTLOCDesc
	s PatLoc=##class(web.DHCPE.Query.IAdmItemStatus).GetShortLocDesc(PatLoc)
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ""
	s OrderObj=##class(User.OEOrder).%OpenId(Order)
	s Length=OrderObj.ChildOEOrdItem.Count()
	q:Length=0 ""
	s ItemInfo=""
	s Flag=0
	s Single=$J
	k ^TempDHCPEPrintIAdmInfoSort(Single)
	for i=1:1:Length
	{
		s PrintType=""
		s obj=OrderObj.ChildOEOrdItem.GetAt(i)
		s OEORIStatus=obj.OEORIItemStatDR.OSTATCode
		continue:OEORIStatus="D" ;医嘱停止的不再显示
		;continue:OEORIStatus="E" ;医嘱执行的不再显示
		s OEID=obj.%Id()
		s ARCIMID=obj.OEORIItmMastDRGetObjectId()
		s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
		continue:STID=""
		;continue:STID=4	  //妇科
		s STation=$P(^DHCPEST(STID),"^",2)
		s LabSpecNo=obj.OEORILabEpisodeNo
		;s:LabSpecNo="" LabSpecNo=999999
		s NeedPrint=##class(web.DHCPE.Query.IAdmItemStatus).NeedPrint(OEID, ARCIMID)
		//continue:(LabSpecNo="")&&(NeedPrint=0)
		continue:(LabSpecNo="")&&(NeedPrint="N")
		s ARCIMDesc=obj.OEORIItmMastDR.ARCIMDesc //ARCIMDesc ARCIMAbbrev
		
		i (LabSpecNo'="") d
		.s CRMOID=$o(^DHCPECRMO(0,"OEORI",OEID,0))
		.s PaiedFlag=$p(^DHCPECRMO(CRMOID),"^",4)
		.s PrintType="Lis"
		.s OrdName=##class(web.DHCPE.BarPrint).GetARCIMDesc(LabSpecNo,+OEID,",")
		.s OrdName=$P(OrdName,$C(1),1)_PrintType
		e  i (RisStation[("^"_STID_"^")) d
		.s LabSpecNo="&nbsp"
		.s OrdName="&nbsp"
		.s PrintType="Ris"
		e  i (STID=10)  d
		.s LabSpecNo="&nbsp"
		.;s OrdName="&nbsp"
		.s PrintType="EKG"
		e  i (STID=4)  d
		.s LabSpecNo="&nbsp"
		.s OrdName="&nbsp"
		.s PrintType="FK"
		e  i (STID=5) d
		.s LabSpecNo="&nbsp"
		.s OrdName="&nbsp"
		.s PrintType="YK"
		s disabled=""
		s RecLoc=obj.OEORIRecDepDR.CTLOCDesc
		s RecLoc=##class(web.DHCPE.Query.IAdmItemStatus).GetShortLocDesc(RecLoc)
		;s OrdName=OrdName_PrintType
		i PrintType="Lis" d
		.i $G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo))="" d
		..s ^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)=PAADM_"^"_OEID_"^"_STation_"^"_OrdName_"^"_PrintType_"^"_0_";"_ARCIMDesc
		..s ^TempDHCPEPrintIAdmInfoSort(Single,"LabSpecNo",LabSpecNo,OEID)=PaiedFlag
		.e  d
		..s ^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)=$G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo))_","_ARCIMDesc
		e  d
		.s ^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)=PAADM_"^"_OEID_"^"_STation_"^"_OrdName_"^"_PrintType_"^"_0_";"_ARCIMDesc
	}
	d ..OutToUI(Single)
}

ClassMethod OutToUI(Single)
{
	s (STID,STation,OEID,ARCIMDesc,PAADM,LabSpecNo,OrdName,PrintType,Str)=""
	w "<TABLE border=1 cellspacing='0' cellpadding='0'>"
	w "<TR height=20 bgcolor='' width=90%>"
	    w "<TD colspan=5 align=right width=20%>"
		w "<button class='i-btn'; onclick='PrintAllBarCode()' id='PrintAllBarCode'>全部打印</button>"
		w "</TD>"
	w "</TR>"
	w "<TR height=20 bgcolor=''>"
			w "<TD align=center width=10%>"
				w "科室"
			w "</TD>"
			w "<TD width=10%>"
				w "标本号"
			w "</TD>"
			w "<TD width=30%>"
				w "项目"
			w "</TD>"
			w "<TD width=30%>"
				w "检查项目"
			w "</TD>"
			w "<TD align=center width=20%>"
				w "按钮"
			w "</TD>"
		w "<TR>"
		f  s STID=$O(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID))  q:STID=""  d
		.f  s LabSpecNo=$O(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo))  q:LabSpecNo=""  d
		..s PAADM=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)),"^",1)
		..s OEID=$o(^TempDHCPEPrintIAdmInfoSort(Single,"LabSpecNo",LabSpecNo,0))
		..s ARCIMDesc=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)),";",2)
		..s STation=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)),"^",3)
		..s LabSpecNo=LabSpecNo
		..s OrdName=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)),"^",4)
		..s PrintType=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Lis",STID,LabSpecNo)),"^",5)
		..s Str=PAADM_"^"_OEID_"^"_PrintType_"^"_LabSpecNo
		..i $G(^DHCPEDataEx("OEOrderItem","PrintLisRequest",LabSpecNo))="Y" d
		...s OrdName="<font color=red>"_OrdName_"</font>"
		..d ..WriteRow(STation,LabSpecNo,ARCIMDesc,OrdName,Str,Single)
		s (STID,STation,OEID,ARCIMDesc,PAADM,LabSpecNo,OrdName,PrintType,Str)=""
		f  s STID=$O(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID))  q:STID=""  d
		.f  s OEID=$O(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID))  q:OEID=""  d
		..s PAADM=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)),"^",1)
		..s OEID=OEID
		..s OrdName=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)),";",2)
		..s STation=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)),"^",3)
		..s ARCIMDesc=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)),"^",4)
		..s PrintType=$P($G(^TempDHCPEPrintIAdmInfoSort(Single,"Other",STID,OEID)),"^",5)
		..s Str=PAADM_"^"_OEID_"^"_PrintType_"^"_""
		..i $G(^DHCPEDataEx("OEOrderItem","PrintRisRequest",OEID))="Y" d
		...s OrdName="<font color=red>"_OrdName_"</font>"
		..d ..WriteRow(STation,"&nbsp",ARCIMDesc,OrdName,Str,Single)
		
	w "</TABLE>"
	k ^TempDHCPEPrintIAdmInfoSort(Single)
}

ClassMethod WriteRow(STation, LabSpecNo, ARCIMDesc, OrdName, Str, Jack)
{
	;s Jack=$Job
	s disabled=""
		w "<TR height=20 bgcolor=''>"
			w "<TD align=center width=10%>"
				w STation
				s ^TempDHCPEPrintIAdmInfoSort(Jack,"OldStation")=STation
			w "</TD>"
			w "<TD width=10%>"
				w LabSpecNo
			w "</TD>"
			w "<TD width=30%>"
				w ARCIMDesc
			w "</TD>"
			w "<TD width=35%>"
				w OrdName
			w "</TD>"
			w "<TD width=15% align=right>"
				w "<button class='i-btn'; onclick='PrintBarCode(this)' id='"_Str_"' name='BtnPrint' "_disabled_">打印</button>"
			w "</TD>"
		w "<TR>"
		k ^TempDHCPEPrintIAdmInfoSort(Jack,"OldStation")
}

/// Flag:1弹出窗口;2不弹出
ClassMethod RigsterWinSet(User, Flag, Type)
{
	i Type="Set" d
	.s ^DHCPEDataEX("DHCPERigsterWinSet",User)=1
	i Type="Move" d
	.s ^DHCPEDataEX("DHCPERigsterWinSet",User)=0
	q 0
}

// w ##class(web.DHCPE.PrintIAdmInfo).GetWinSetType()

ClassMethod GetWinSetType(User)
{
	s type=""
	s:User="" User=%session.Get("LOGON.USERID")
	s type=$G(^DHCPEDataEX("DHCPERigsterWinSet",User))
	s:type="" type=0
	q type
}

/// 测试：d ##class(%ResultSet).RunQuery("web.DHCPE.PrintIAdmInfo","GetRegWinType","")
Query GetRegWinType(UserId As %Library.String = "") As %Query(ROWSPEC = "TUserId:%String,TUserName:%String,Tflag1:%String,Tflag2:%String")
{
}

ClassMethod GetRegWinTypeExecute(ByRef qHandle As %Binary, UserId As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
 	
 	s SetId=""
 	f  s SetId=$O(^DHCPEDataEX("DHCPERigsterWinSet",SetId)) q:SetId=""  d
 	.;q:(UserId'="")&&(UserId'=SetId)
 	.;d Clear
 	.s TUserId=SetId
 	.s Obj=##class(User.SSUser).%OpenId(SetId)
 	.s TUserName=Obj.SSUSRName
 	.s Tflag1=$P($G(^DHCPEDataEX("DHCPERigsterWinSet",SetId)),"^",1)
 	.s Tflag2=""
	.d FindBuild
	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
Clear
	s (TUserId,TUserName,Tflag1,Tflag2)=""
	q 
FindBuild
	set Data=$lb(TUserId,TUserName,Tflag1,Tflag2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRegWinTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegWinTypeExecute ]
{
	s repid=$List(qHandle,2)
	kill ^CacheTmp(repid)
	Quit $$$OK
}

ClassMethod GetRegWinTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegWinTypeExecute ]
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

/// Use Component:DHCPEIReportPHistory
/// 
/// 测试：d ##class(%ResultSet).RunQuery("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfo","","","")
Query GetIPrtIAdmInfo(UserId As %Library.String = "", PDateFrom As %Library.Date = "", PDateTo As %Library.Date = "", GroupID As %Library.String = "", TeamID As %Library.String = "", VIPLevel As %Library.String = "", PUserId As %Library.String = "") As %Query(ROWSPEC = "TPAPMINo:%String,TName:%String,TAge:%String,TCheckDate:%String,TGrpName:%String,TAuditOpr:%String,TAuditDate:%String,TPrtFlag:%String,THead:%String,TSex:%String,HPNO:%String,TPrintDate:%String,TReportOpr:%String")
{
}

ClassMethod GetIPrtIAdmInfoExecute(ByRef qHandle As %Binary, UserId As %Library.String = "", PDateFrom As %Library.Date = "", PDateTo As %Library.Date = "", GroupID As %Library.String = "", TeamID As %Library.String = "", VIPLevel As %Library.String = "", PUserId As %Library.String = "") As %Status
{
	k ^DHCPETMP("GetIPrtIAdmInfo")
	Set repid=$I(^CacheTemp)
	s ind=1
 	s PrintStartDate=""
 	if (UserId="")&&(PDateFrom="")&&(PDateTo="")&&(GroupID="")&&(TeamID="")&&(VIPLevel="")
 	{
	 	Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
 	}
 	s CurLoc=%session.Get("LOGON.CTLOCID")
 	s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurLoc))  //该科室是否需求复检
 	
 	s:PDateFrom'="" PrintStartDate=$ZD(PDateFrom,3)
 	s PrintEndDate=""
 	s:PDateTo'="" PrintEndDate=$ZD(PDateTo,3)
 	//s PrintDate="日期范围:"_PrintStartDate_"    "_PrintEndDate
 	//s PrintDate=PrintDate_"   打印日期:"_$ZD($H,3)
 	s PrintDate="打印日期:"_$ZD($H,3)
 	s RptID="",THead=0
 	
 	I PDateFrom'="" s PDateFrom=##class(websys.Conversions).DateHtmlToLogical(PDateFrom)
	I PDateTo'=""   s PDateTo=##class(websys.Conversions).DateHtmlToLogical(PDateTo)
 	i PDateTo="" s PDateTo=+$h 

 	s Date=PDateTo+1
 	f  s Date=$O(^DHCPERPT(0,"PrintDate",Date),-1) q:(Date="")||(Date<PDateFrom)  d
 	.s Time=""
 	.f  s Time=$O(^DHCPERPT(0,"PrintDate",Date,Time),-1) q:(Time="")  d
 	..s RptID=""
 	..f  s RptID=$O(^DHCPERPT(0,"PrintDate",Date,Time,RptID)) q:(RptID="")  d
 	...d GetOneInfo
 	//w "共"_(ind-1)_"份"
 	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
GetOneInfo 	
 	d Clear
 	s iRptStatus=$P($G(^DHCPERPT(RptID)),"^",2)
 	q:(iRptStatus'="P")
 	s RptPrtDate=$P($G(^DHCPERPT(RptID)),"^",7)
 	q:((PDateFrom'="")&&(PDateFrom>RptPrtDate))||((PDateTo'="")&&(PDateTo<RptPrtDate))
 	s IADMID=$P($G(^DHCPERPT(RptID)),"^",1)
 	q:IADMID="" 
 	s PAADMID=$P($G(^DHCPEIADM(IADMID)),"^",1)
 	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADMID)
  	q:LocFlag=1 
  	S PAPMI=$P($G(^PAADM(PAADMID)),"^",1)
 	s PIADMID=$P($G(^DHCPEIADM(IADMID)),"^",4)
 	s PIBIID=$P($G(^DHCPEPreIADM(PIADMID)),"^",1)
 	s HPNO=$P($G(^DHCPEPreIADM(PIADMID)),"^",27)
 	s Vip=$P($G(^DHCPEPreIADM(PIADMID)),"^",18)
 	q:(VIPLevel'="")&&(VIPLevel'=Vip)
 	s SexDR=$P($G(^DHCPEPreIBI(PIBIID)),"^",3)
 	s TSex=$p($g(^CT("SEX",SexDR)),"^",2)
 	s TPAPMINo=$P($G(^DHCPEPreIBI(PIBIID)),"^",1)
 	q:(UserId'="")&&(UserId'=TPAPMINo)
 	s TName=$P($G(^DHCPEPreIBI(PIBIID)),"^",2)
 	s TDob=$P($G(^DHCPEPreIBI(PIBIID)),"^",4)
 	//s TAge=+##class(web.DHCLCNUREXCUTE).CalAge(TDob,+$h)
 	s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMI,PAADMID)
 	s CheckDate=$P($G(^DHCPEIADM(IADMID)),"^",5)
 	s TCheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)	;体检日期
 	
 	i NeedReCheck'="Y" d
 	.s AuditOpr=$P($G(^DHCPERPT(RptID)),"^",4)
 	.s TAuditDate=$P($G(^DHCPERPT(RptID)),"^",5)
 	e  d
 	.s AuditOpr=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADMID)),"^",1)  //复检者
    .s TAuditDate=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADMID)),"^",2)  //复检提交日期
  	s:AuditOpr'="" TAuditOpr=$p($g(^SSU("SSUSR",AuditOpr)),"^",2)
 	s:TAuditDate'="" TAuditDate=##class(websys.Conversions).DateLogicalToHtml(TAuditDate)
 	s PGADMID=$P($G(^DHCPEPreIADM(PIADMID)),"^",2)
 	s GADMID=$P($G(^DHCPEIADM(IADMID)),"^",2)
 	q:(""'=GroupID)&&(GroupID'=GADMID)
 	
 	s TPrintUser=$P($G(^DHCPERPT(RptID)),"^",6)
 	q:((PUserId'="")&&(TPrintUser'=PUserId))
 	s:TPrintUser'="" TPrintUser=$p($g(^SSU("SSUSR",TPrintUser)),"^",2)  // 姓名
 	s TPrintDate=$P($G(^DHCPERPT(RptID)),"^",7)
 	s:TPrintDate'="" TPrintDate=##class(websys.Conversions).DateLogicalToHtml(TPrintDate)
 	
 	i PGADMID'=""  d
 	.s PGBIID=$P($G(^DHCPEPreGADM(PGADMID)),"^",1)
 	.s TGrpName=$P($G(^DHCPEPreGBI(PGBIID)),"^",2)
 	s TPrtFlag=""
 	//s:Vip'="" TPrtFlag=$P(^DHCPEVIPLevel("VIP",Vip),"^",2)
 	s:Vip'="" TPrtFlag=$lg($g(^CT.PE.VIPLevelD(Vip)),3) //VIP描述
 	s THead=THead+1
	d FindBuild
	q
Clear
	s (TPAPMINo,TName,TAge,TCheckDate,TGrpName,TAuditOpr,TAuditDate,TPrtFlag,TSex,HPNO)=""
	q 
FindBuild
	set Data=$lb(TPAPMINo,TName,TAge,TPrintDate,TGrpName,TAuditOpr,TAuditDate,TPrtFlag,THead,TSex,HPNO,PrintDate,TPrintUser)
	set:(VIPLevel'=2) ^DHCPETMP("GetIPrtIAdmInfo",HPNO)=THead_"^"_TPAPMINo_"^"_HPNO_"^"_TName_"^"_TSex_"^"_TAge_"^"_TPrintDate_"^"_TGrpName_"^"_TAuditOpr_"^"_TAuditDate
	set:(VIPLevel'=2) ^DHCPETMP("GetIPrtIAdmInfoHead","Row1")="序号"_"^"_"登记号"_"^"_"体检号"_"^"_"姓名"_"^"_"性别"_"^"_"年龄"_"^"_"打印日期"_"^"_"团体名称"_"^"_"审核人"_"^"_"审核日期"
 	set:(VIPLevel=2) ^DHCPETMP("GetIPrtIAdmInfo",HPNO)=THead_"^"_HPNO_"^"_TName_"^"_TPAPMINo_"^"_TPrintDate
 	set:(VIPLevel=2) ^DHCPETMP("GetIPrtIAdmInfoHead","Row1")="序号"_"^"_"体检号"_"^"_"姓名"_"^"_"登记号"_"^"_"打印日期"
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetIPrtIAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPrtIAdmInfoExecute ]
{
	s repid=$List(qHandle,2)
	kill ^CacheTmp(repid)
	Quit $$$OK
}

ClassMethod GetIPrtIAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPrtIAdmInfoExecute ]
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

/// 输出团体医嘱费用明细
/// d ##Class(web.DHCPE.PrintIAdmInfo).GetIPrtIAdmInfoImport("Out","","7")
ClassMethod GetIPrtIAdmInfoImport(Type As %Library.String = "", ParaID As %Library.String, Sort As %String = "") As %Status
{
   	s IDStr=""
 	i "Header"=Type d
	.s IDStr=$G(^DHCPETMP("GetIPrtIAdmInfoHead","Row1"))

	i "ColStr"=Type d
	.s ID=0
	.f  s ID=$O(^DHCPETMP("GetIPrtIAdmInfo",ID)) Q:(""=ID)  d
	..i ""=IDStr d
	...s IDStr=ID
	..e  d
	...s IDStr=IDStr_"^"_ID
	
	i "RowStr"=Type d
	.s IDStr=$G(^DHCPETMP("GetIPrtIAdmInfo",ParaID))
	.s $P(IDStr,"^",1)=(Sort+1)
	q IDStr
}

Storage Default
{
<Data name="PrintIAdmInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.PrintIAdmInfoD</DataLocation>
<DefaultData>PrintIAdmInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.PrintIAdmInfoD</IdLocation>
<IndexLocation>^web.DHCPE.PrintIAdmInfoI</IndexLocation>
<StreamLocation>^web.DHCPE.PrintIAdmInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
