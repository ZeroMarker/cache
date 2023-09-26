/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 公共Query
Class DHCDoc.Chemo.COM.Qry Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-27
/// DESC: 查询模板阶段
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryTPLStage",1)
Query QryTPLStage(TPID = "") As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTPLStageExecute(ByRef qHandle As %Binary, TPID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (TPID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s total=##class(DHCDoc.Chemo.COM.Func).GetTPLStage(TPID)
	
	if (total="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	f i=1:1:total {
		s id=i
		s text=i	
		d output1
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLStageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLStageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLStageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLStageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-04-27
/// DESC: 查询组编号
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryTPLGroupCode")
Query QryTPLGroupCode() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTPLGroupCodeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s total=10	//可设置为参数
	f i=1:1:total {
		s id=i
		s text=i	
		d output1
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLGroupCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLGroupCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLGroupCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLGroupCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-04-27
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","FindMasterItem","zsy","",6452)
Query FindMasterItem(arcimdesc As %String, HospId As %String = "", EpisodeID = "", InOrderCate = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String,factor,stock,itemDr")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String, HospId As %String = "", EpisodeID = "", InOrderCate = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^QP("FindMasterItem")=$LB(arcimdesc,EpisodeID)
 	s langid=..%LanguageID()
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    //i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,HospId)="N"
	..s Flag=0
	..s factor="",stock=""
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s OutArcimDesc=ArcimDesc
	..s itemDr=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",10)
    ..q:itemDr=""
    ..s orderCate=$p(^ARC("IC",itemDr),"^",8)
    ..q:orderCate=""
    ..s orderCateDesc=$p(^OEC("ORCAT",orderCate),"^",2)
    ..q:(InOrderCate'="")&&(InOrderCate'=orderCateDesc)
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 d
	...i EpisodeID'="" d
	....s defaultRecLoc=##class(DHCDoc.Chemo.COM.CallMethod).GetDefaultRecLoc(EpisodeID,ArcimDR)
	....i defaultRecLoc="" d OutputRow5
	....e  d
	.....s stockInfo=##class(DHCDoc.Chemo.COM.CallMethod).FindDurgByArc(ArcimDR,defaultRecLoc)
	.....s factor=$p(stockInfo,"^",1)
	.....s stock=$p(stockInfo,"^",2)
	.....d OutputRow5
	...e  d
	....Do OutputRow5
	..//s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..//q:AlisDR=""
	..//s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..//s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..//s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..//q:ArcimDesc'[arcimdesc
	..//Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	s OutArcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OutArcimDesc,langid)
	set Data=$lb(OutArcimDesc,ArcimDR,factor,stock,itemDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 查询疗程
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","LookUpDuration","")
Query LookUpDuration(desc As %String) As %Query(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,CTPCPDesc:%String:描述,CTPCPCode:%String:编码,HIDDEN:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s langid=..%LanguageID()
 	s desc=$$ALPHAUP^SSUTIL4(desc)
 	s PHCDURowId=0
 	f  s PHCDURowId=$O(^PHCDU(PHCDURowId)) Q:PHCDURowId=""  d
 	.s PHCDUCode=$P(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$P(^PHCDU(PHCDURowId),"^",2)
 	.s PHCDUDesc1=$P(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUDesc2=$P(^PHCDU(PHCDURowId),"^",4)
 	.s DateFrom=$P(^PHCDU(PHCDURowId),"^",5)
 	.s DateTo=$P(^PHCDU(PHCDURowId),"^",6)
 	.q:(DateFrom'="")&&(DateFrom>+$h)
 	.q:(DateTo'="")&&(DateTo<+$h)
 	.Q:PHCDUDesc2="饮片"
 	.s FindFlag=1
 	.i desc'=""  d
 	..s FindFlag=0
 	..s SubFactor=$$ALPHAUP^SSUTIL4(PHCDUFactor)
 	..s SubDesc1=$$ALPHAUP^SSUTIL4(PHCDUDesc1)
 	..i ((SubFactor=desc)||(SubDesc1[desc))  d
 	...s FindFlag=1
 	..i FindFlag'=1 d
 	...s SubID=0  
	...f  s SubID=$O(^User.BDPAliasI("DataRef","PHC_Duration",PHCDURowId,SubID)) Q:SubID=""  d
	....i $D(^User.BDPAliasD(SubID)) d
	.....s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	.....i SUbCode[desc  d
	......s FindFlag=1
	.Q:FindFlag'=1
	.s RowID=PHCDURowId
	.s CTPCPDesc=PHCDUDesc1
	.s CTPCPCode=PHCDUCode
	.s Facter=PHCDUFactor
	.Do OutputDuration
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDuration
	s CTPCPDesc= ##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",CTPCPDesc,langid)
	set Data=$lb(RowID,CTPCPDesc,CTPCPCode,Facter)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
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

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 查询频次
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","LookUpFrequency","")
Query LookUpFrequency(desc As %Library.String, PAAdmType As %Library.String = "", UserID As %Library.String = "", OrderPriorRowid As %Library.String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "Desc:%String:描述,Code:%String:编码,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpFrequencyExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, PAAdmType As %Library.String = "", UserID As %Library.String = "", OrderPriorRowid As %Library.String = "") As %Library.Status
{
	
	s desc=$P(desc," ",1)
	
	K ^TMP($J,"FreqLookup")
	s langid=..%LanguageID()
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s STFreqRowid=$O(^PHCFR(0,"Code","ST",0))
	s ONCEFreqRowid=$O(^PHCFR(0,"Code","ONCE",0))
	s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
	s ShortOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s PHCFRRowId=0
	f  s PHCFRRowId=$O(^PHCFR(PHCFRRowId)) Q:PHCFRRowId=""  d
	.Q:(PAAdmType="I")&&(OrderPriorRowid'="")&&(OrderPriorRowid=LongOrderPriorRowid)&&((PHCFRRowId=STFreqRowid)||(PHCFRRowId=ONCEFreqRowid))
	.Q:(PAAdmType="I")&&(OrderPriorRowid'="")&&(OrderPriorRowid=ShortOrderPriorRowid)&&(PHCFRRowId'=STFreqRowid)&&(PHCFRRowId'=ONCEFreqRowid)
	.s PHCFRCode=$P(^PHCFR(PHCFRRowId),"^",1)
	.s PHCFRFactor=$P(^PHCFR(PHCFRRowId),"^",2)
	.s PHCFRDesc1=$P(^PHCFR(PHCFRRowId),"^",3)
	.s PHCFRDesc2=$P(^PHCFR(PHCFRRowId),"^",4)
	.s PHCFRDays=$P(^PHCFR(PHCFRRowId),"^",5)
	.s Active=$P(^PHCFR(PHCFRRowId),"^",6)
	.s AvailableType=$P(^PHCFR(PHCFRRowId),"^",7)
	.q:(Active="N")
	.Q:(PHCFRDesc2="饮片")||(PHCFRDesc2="UNUSE")
	.q:(PAAdmType'="")&&(AvailableType'="")&&(AvailableType'[PAAdmType)
	.
	.s WeekFlag=$P(^PHCFR(PHCFRRowId),"^",9)
	.s OPNoDelayExe=$P(^PHCFR(PHCFRRowId),"^",8)
	.s IPNoDelayExe=$P(^PHCFR(PHCFRRowId),"^",10)
	.i PAAdmType="I" s NoDelayExe=IPNoDelayExe
	.e  s NoDelayExe=OPNoDelayExe
	.s FindFlag=1
	.i desc'=""  d
	..s FindFlag=0
	..s SubCode=$$ALPHAUP^SSUTIL4(PHCFRCode)
	..s subDesc1=$$ALPHAUP^SSUTIL4(PHCFRDesc1)
	..i ((SubCode=desc)||(subDesc1[desc))  d
	...s FindFlag=1
	..i FindFlag'=1  d
	...s SubID=0  
	...f  s SubID=$O(^User.BDPAliasI("DataRef","PHC_Freq",PHCFRRowId,SubID)) Q:SubID=""  d
	....i $D(^User.BDPAliasD(SubID)) d
	.....s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	.....i SUbCode[desc  d
	......s FindFlag=1
	.Q:FindFlag'=1
	.s desc1=PHCFRDesc1
	.s code=PHCFRCode
	.s factor=PHCFRFactor
	.s days=PHCFRDays
	.s rowid=PHCFRRowId
	.;上边是SQL改为M---------------end--------
	.s PHCFRMarkNO=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.PHCFreq",rowid,UserID,"U")
	.S ^TMP($J,"FreqLookup",PHCFRMarkNO,rowid)=desc1_"^"_code_"^"_factor_"^"_days_"^"_rowid_"^"_""_"^"_WeekFlag_"^"_NoDelayExe  //建立临时Globle
	
	//按照序号排序
	s seq="" for {
		s seq=$O(^TMP($j,"FreqLookup",seq),-1)
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"FreqLookup",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"FreqLookup",seq,seq1)
			s desc1=$P(temp,"^",1)
			s code=$P(temp,"^",2)
			s factor=$P(temp,"^",3)
			s days=$P(temp,"^",4)
			s rowid=$P(temp,"^",5)
			s disptimestr=$P(temp,"^",6)
			s WeekFlag=$P(temp,"^",7)
			s NoDelayExe=$P(temp,"^",8)
			//_"^"__"^"_
			d OuputRow4		
		}
	}

	K ^TMP($J,"FreqLookup")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow4
	s desc1= ##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",desc1,langid)
	set Data=$lb(desc1,code,factor,days,rowid,disptimestr,WeekFlag,NoDelayExe)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequencyFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFrequencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpFrequencyClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFrequencyFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 查询用法
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","LookUpInstr","WY")
Query LookUpInstr(instrdesc As %Library.String, paadmtype As %String = "", arcimrowid As %Library.String = "", LocRowId As %String = "", UserID As %Library.String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,Desc:%String:描述,Code:%String:编码")
{
}

ClassMethod LookUpInstrExecute(ByRef qHandle As %Library.Binary, instrdesc As %Library.String, paadmtype As %String = "", arcimrowid As %Library.String = "", LocRowId As %String = "", UserID As %Library.String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s langid=..%LanguageID()
	s ForbidDosingInstr=""
	if (LocRowId'=""){
		s ForbidDosing=$P($G(^CTLOC(LocRowId,"DHC")),"^",18)
		i (ForbidDosing="1"){
			if (paadmtype="I"){
				s ForbidDosingInstr=##Class(web.DHCDocConfig).GetConfigNode("IPDosingInstr")
			}elseif (paadmtype="O"){
				s ForbidDosingInstr=##Class(web.DHCDocConfig).GetConfigNode("OPInfusionInstr")
			}
		}
	}
	
	
	K ^TMP($J,"InstrLookup")
	s instrdesc=$zcvt(instrdesc,"U")
	;现在不启用使用医嘱项目找用法的程序,知识库未提供接口,药学项也没有相关维护
	s arcimrowid=""
	if $g(arcimrowid)'="" {
		Set rset=##Class(%ResultSet).%New("web.DHCSTINTERFACE.GetPHCInstruc")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(arcimrowid)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s code=rset.GetData(1)
				s desc1=rset.GetData(2)
				s rowid=rset.GetData(3)
				continue:(instrdesc'="")&&((desc1'[instrdesc)&&(code'[instrdesc))
				s ^TMP($J,"InstrLookup",rowid)=rowid_"^"_desc1_"^"_code				
			}
			d rset.Close()
		}
		Set repid=$I(^CacheTemp)
		If $g(ind)="" Set ind=1
		//按照序号排序
		s rid=0 for {
			s rid=$O(^TMP($J,"InstrLookup",rid))
			Quit:rid=""
			s temp=^TMP($J,"InstrLookup",rid)
			s rowid=$P(temp,"^",1)
			s desc1=$P(temp,"^",2)
			s code=$P(temp,"^",3)
			do OuputRow5		
		}
		
	}else{
		s InstrRowStrByAlias=##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("PHC_Instruc",instrdesc)
		s InstrRowAliasList=$LISTFROMSTRING(InstrRowStrByAlias,"^")
		&sql(declare CurInstr cursor for
			SELECT PHCIN_RowId,PHCIN_Desc1,PHCIN_Code,PHCIN_ClinicType,PHCIN_ActiveFlag FROM SQLUser.PHC_Instruc 
			WHERE (PHCIN_Desc1 %STARTSWITH :instrdesc or PHCIN_Code %STARTSWITH :instrdesc or PHCIN_Desc2 %STARTSWITH :instrdesc 
			or PHCIN_RowId %INLIST (:InstrRowAliasList)) and (PHCIN_Desc1 NOT LIKE '%停用%') and PHCIN_Desc2<>'UNUSE' and (PHCIN_Desc2<>'饮片')
			ORDER BY PHCIN_Code)
		&sql(open CurInstr)
		s num=0,zcnum=1
		f  &sql(fetch CurInstr into :rowid,:desc1,:code,:ClinicType,:ActiveFlag) q:SQLCODE  d
		.q:(ActiveFlag="N")
		.q:(paadmtype'="")&&(ClinicType'="")&&(ClinicType'[paadmtype)
		.q:(ForbidDosingInstr'="")&&(("^"_ForbidDosingInstr_"^")[("^"+rowid+"^"))
		.;s SeqNo=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.PHCInstruc","正式",rowid)
		.s SeqNo=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.PHCInstruc",rowid,UserID,"U")
		.S ^TMP($J,"InstrLookup",SeqNo,rowid)=rowid_"^"_desc1_"^"_code
		&sql(close CurInstr)
		s rid="" f  s rid=$O(^TMP($J,"InstrLookup",rid),-1) Quit:rid=""  d
		.s rno=0 f  s rno=$O(^TMP($J,"InstrLookup",rid,rno)) Quit:rno=""  d
		..s temp=^TMP($J,"InstrLookup",rid,rno)
		..s rowid=$P(temp,"^",1)
		..s desc1=$P(temp,"^",2)
		..s code=$P(temp,"^",3)
		..do OuputRow5			
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow5
	s desc1= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",desc1,langid)
	set Data=$lb(rowid,desc1,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpInstrClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInstrFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-09
/// DESC: 查询BSA公式
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryBASFunc")
Query QryBASFunc() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryBASFuncExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="XWS",text="许文生氏公式"
 	d output6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output6
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryBASFuncClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBASFuncExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBASFuncFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBASFuncExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DESC: 科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryGetdep","呼吸")
Query QryGetdep(Desc As %String = "", InHosp = "") As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryGetdepExecute(ByRef qHandle As %Binary, Desc As %String = "", InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set Desc=$zcvt(Desc,"U")
    if (Desc="") {
	    //Set qHandle=$lb(0,repid,0)
    	//Quit $$$OK
	  }
	s langid=..%LanguageID()
    s locid=""
    f  s locid=$o(^CTLOC(locid))  q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
    .i locdesc["-"  s locdesc=$p(locdesc,"-",2)
    .s type=$p(^CTLOC(locid),"^",13)
    .s code=$p(^CTLOC(locid),"^",43)
    .s code=$zcvt(code,"U")
    .q:(Desc'="")&&(code'[Desc)&&(locdesc'[Desc)
    .q:(type'="E")&&(type'="EM")
    .s hospDr=$p(^CTLOC(locid),"^",22)
    .q:(InHosp'="")&&(hospDr'=InHosp)
    .d output7
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
output7
	s locdesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locdesc,langid)
    set Data=$lb(locid,locdesc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryGetdepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetdepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryGetdepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetdepExecute ]
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

/// CTOR: QP
/// DATE: 
/// DESC: 查询HIS成员
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryHisDoc","姜春梅","",9)
Query QryHisDoc(Desc As %String = "", LocId = "", InHosp = "") As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QryHisDocExecute(ByRef qHandle As %Binary, Desc As %String = "", LocId = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (Desc="") {
	 	//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	s ^QP("QryHisDoc")=$LB(Desc,LocId,InHosp)
	s langid=..%LanguageID()
	S Desc=$zcvt(Desc,"U")
	i LocId="" { 
		Set id=0
		f  s id=$o(^CTPCP(id)) q:id=""  d
		.s uid=##class(DHCDoc.Chemo.COM.Func).TransCTCareToSSUser(id)
		.q:uid=""
		.s userCode=$p(^SSU("SSUSR",uid),"^",1)
		.s userCode=$zcvt(userCode,"U")
		.s text=$p(^CTPCP(id,1),"^",2)
		.s code=$p(^CTPCP(id,1),"^",1)
		.s othername=$p(^CTPCP(id,3),"^",28)
		.q:(userCode'[Desc)&&(text'[Desc)&&(othername'[Desc)
		.s AllHosp=$p(^SSU("SSUSR",uid),"^",98)	;
	    .s sub=""
		.f  s sub=$o(^SSU("SSUSR",uid,"OTHLL",sub)) q:sub=""  d
		..s cHosp=$p(^SSU("SSUSR",uid,"OTHLL",sub),"^",3)
		..q:cHosp=""
		..i AllHosp="" s AllHosp=cHosp
		..e  d
		...i ##class(DHCDoc.Chemo.COM.Func).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
	    .q:(InHosp'="")&&(##class(DHCDoc.Chemo.COM.Func).InArray(AllHosp,InHosp)'=1)
	 	.d output8
	} else {
		s dep=""
	    f  s dep=$o(^RB("RES",0,"CTLOC",dep))  q:dep=""  d
	    .q:(LocId'="")&&(dep'=LocId)
	    .s RowId=""
	    .f  s RowId=$o(^RB("RES",0,"CTLOC",dep,RowId))  q:RowId=""  d
	    ..s docdr=$p($g(^RB("RES",RowId)),"^",2) 
	    ..q:docdr=""
	    ..s uid=##class(DHCDoc.Chemo.COM.Func).TransCTCareToSSUser(docdr)
		..q:uid=""
	    ..;s docdesc=$p(^CTPCP(docdr,1),"^",2)
	    ..s CTCarPrvTpDR=$P($g(^CTPCP(docdr,1)),"^",4)
		..;s CTCarPrvTpdesc=$P($g(^CTPCP(docdr,1)),"^",2)
		..s userCode=$p(^SSU("SSUSR",uid),"^",1)
		..s userCode=$zcvt(userCode,"U")
		..s text=$p(^CTPCP(docdr,1),"^",2)
		..s code=$p(^CTPCP(docdr,1),"^",1)
		..s othername=$p(^CTPCP(docdr,3),"^",28)
		..q:(userCode'[Desc)&&(text'[Desc)&&(othername'[Desc)
	    ..d output8
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output8
	s text= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",text,langid)
	set Data=$lb(uid,text,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryHisDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHisDocExecute ]
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

ClassMethod QryHisDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHisDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-09
/// DESC: 查询BSA类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryBSAType")
Query QryBSAType() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryBSATypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="Default",text="默认体表面积"
 	d output9
 	s id="New",text="调整体表面积"
 	d output9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output9
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryBSATypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBSATypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBSATypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBSATypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-06-22
/// DESC: 查询计算公式
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryFormula")
Query QryFormula() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryFormulaExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="BSA",text="BSA算法"
 	d output10
 	s id="GFR",text="GFR算法"
 	d output10
 	s id="WGT",text="体重算法"
 	d output10
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output10
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryFormulaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFormulaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFormulaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFormulaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-08-19
/// DESC: 查询化疗组字典库
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryChemoDic","CHEMOGORUP")
Query QryChemoDic(InCode = "") As %Query(ROWSPEC = "id,desc,code")
{
}

ClassMethod QryChemoDicExecute(ByRef qHandle As %Binary, InCode = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s Par=$o(^DHCDocCTi(0,"Define","Code",InCode,""))
 	if (Par="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
 	S sub=0	
	f  s sub=$o(^DHCDocCT("DefineData",Par,"D",sub)) q:sub=""  d
	.s desc=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",2)
	.s code=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",1)
	.s StartDate=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",3)
	.s EndDate=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",4)
	.q:(StartDate'="")&&(StartDate>+$h)
	.q:(EndDate'="")&&(EndDate<+$h)
	.s id=Par_"||"_sub
 	.d output11
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output11
	Set Data=$lb(id,desc,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryChemoDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChemoDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryChemoDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChemoDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-10-15
/// DESC: 查询组类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryGroupType","15||1")
Query QryGroupType(PSID = "") As %Query(ROWSPEC = "id,desc,code")
{
}

ClassMethod QryGroupTypeExecute(ByRef qHandle As %Binary, PSID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (PSID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	
	s TPID=$p(PSID,"||",1)
	s SID=$p(PSID,"||",2)
	s langid=..%LanguageID()
 	s sub=""
	f  s sub=$o(^BS.DOC.Chemo.PlanD(TPID,SID,sub)) q:sub=""  d
	.s gDesc=$p(^BS.DOC.Chemo.PlanD(TPID,SID,sub),"^",2)
	.s df=$p(gDesc,"||",1),ch=$p(gDesc,"||",2)
	.s code=$p(^DHCDocCT("DefineData",df,"D",ch),"^",1)
	.s desc=$p(^DHCDocCT("DefineData",df,"D",ch),"^",2)
	.s desc=##class(User.ChemoTemplateGroup).GetTranByDesc("TPGDesc",desc,langid)
	.s id=gDesc
 	.d output12
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output12
	Set Data=$lb(id,desc,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGroupTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGroupTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGroupTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGroupTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-10-20
/// DESC: 查询疗效评价
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryTreatType")
Query QryTreatType() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTreatTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	//CR、PR、SD、PD、Mini-respond
 	s id="N",text="无"
 	s text=##class(websys.Translation).Get("chemo.bs.apply.csp",text)
 	d output10
 	s id="CR",text="CR"
 	d output10
 	s id="PR",text="PR"
 	d output10
 	s id="SD",text="SD"
 	d output10
 	s id="PD",text="PD"
 	d output10
 	s id="Mini-respond",text="Mini-respond"
 	d output10
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output10
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTreatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTreatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTreatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTreatTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-06-18
/// DESC: 查询皮试备注
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryPS")
Query QryPS() As %Query(ROWSPEC = "rowid,code,desc")
{
}

ClassMethod QryPSExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s rowid=0,code="无",desc="&nbsp"
 	d output11
 	s rowid=0 
 	f  s rowid=$o(^OEC("ACT",rowid)) q:rowid=""  d
	.s code=$p($g(^OEC("ACT",rowid)),"^",1)
	.s desc=$p($g(^OEC("ACT",rowid)),"^",2)
	.s DateFrom=$p($g(^OEC("ACT",rowid)),"^",3)
	.Q:(DateFrom'="")&&(DateFrom>+$h)
	.s DateTo=$p($g(^OEC("ACT",rowid)),"^",4)
	.Q:(DateTo'="")&&(DateTo<=+$h)
	.d output11
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output11
	Set Data=$lb(rowid,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-06-28
/// DESC: 查询性别
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QrySex")
Query QrySex() As %Query(ROWSPEC = "rowid,code,desc")
{
}

ClassMethod QrySexExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s langid=..%LanguageID()
 	s rowid=0
 	f  s rowid=$o(^CT("SEX",rowid)) q:rowid=""  d
 	.s code=$p(^CT("SEX",rowid),"^",1)
 	.s desc=$p(^CT("SEX",rowid),"^",2)
 	.s dateTo=$p(^CT("SEX",rowid),"^",5)
 	.s dateFrom=$p(^CT("SEX",rowid),"^",4)
 	.q:(dateFrom'="")&&(dateFrom>+$h)
 	.q:(dateTo'="")&&(dateTo<+$h)
 	.s desc= ##class(User.CTSex).GetTranByDesc("CTSEXDesc",desc,langid)
 	.d output12
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output12
	Set Data=$lb(rowid,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QrySexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySexExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-06-28
/// DESC: 查询医嘱类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.COM.Qry","QryOEType","NORM")
Query QryOEType(InDesc = "") As %Query(ROWSPEC = "rowid,code,desc")
{
}

ClassMethod QryOETypeExecute(ByRef qHandle As %Binary, InDesc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s rowid=0
 	
 	f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
 	.s code=$p(^OECPR(rowid),"^",1) 
 	.s desc=$p(^OECPR(rowid),"^",2) 
 	.d output13
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output13
	s isExit=1
	i InDesc'="" {
		i desc[InDesc s isExit=0
		i code[InDesc s isExit=0
	} else {
		s isExit=0	
	}
	q:isExit=1
	Set Data=$lb(rowid,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryOETypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOETypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOETypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOETypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
