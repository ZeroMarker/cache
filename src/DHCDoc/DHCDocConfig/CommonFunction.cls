/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 医生站配置界面公共方法
Class DHCDoc.DHCDocConfig.CommonFunction Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","FindMasterItem","")
Query FindMasterItem(arcimdesc As %String, HospId As %String = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String, HospId As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,HospId)="N"
	..s Flag=0
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=..%SysDate()
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 Do OutputRow5
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
	set Data=$lb(ArcimDesc,ArcimDR)
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
/// DATE: 2018-08-17
/// DESC: 查询代码表外部对照类型
/// IN  : 
/// OUT : 
/// TABL: DHCDoc_CT_ExtDataType
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryExtDataType")
Query QueryExtDataType() As %Query(ROWSPEC = "TCTEDTRowId:%String,TCTEDTCode:%String,TCTEDTDesc:%String,TCTEDTClassName:%String,TCTEDTQueryName:%String,TCTEDTActive:%String")
{
}

ClassMethod QueryExtDataTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s CTEDTRowId="" for {
		set CTEDTRowId=$o(^DHCDOCCTEDT("CTEDT",CTEDTRowId)) quit:CTEDTRowId=""
		s CTEDTCode=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",1)
		s CTEDTDesc=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",2)
		s CTEDTClassName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",3)
		s CTEDTQueryName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",4)
		s CTEDTActive=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",5)
		continue:CTEDTActive'="Y"
		i CTEDTActive="Y" s CTEDTActive="是"
		e  s CTEDTActive="否"
		d OutputRow2
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2     
	set Data=$lb(CTEDTRowId,CTEDTCode,CTEDTDesc,CTEDTClassName,CTEDTQueryName,CTEDTActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryExtDataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
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

ClassMethod QueryExtDataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpCTLoc","zxy")
Query LookUpCTLoc(desc As %Library.String, HospId As %String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,CTLOC:%String,ContactName:%String")
{
}

ClassMethod LookUpCTLocExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, HospId As %String = "") As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s CTLocId=0
	s desc=$zcvt(desc,"U")
	S ^PENG("desc")=desc
	for {
		s CTLocId=$O(^CTLOC(CTLocId)) Q:CTLocId=""
		s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
		s CTLocContactName=$P(^CTLOC(CTLocId),"^",43)
		s ContactName=CTLocContactName_"-"_CTLocDesc
		s LocHospId=$p(^CTLOC(CTLocId),"^",22)
		continue:(LocHospId'=HospId)
		//continue:((desc'="")&&(CTLocDesc'[desc))
		continue:##class(web.DHCOPAdmReg).CheckLocDesc(CTLocId,desc)'=1 
		s LocDateTo=$p($g(^CTLOC(CTLocId)),"^",25)
		continue:(LocDateTo'="")&&(LocDateTo<+$H)
		continue:($P(^CTLOC(CTLocId),"^",14)'="Y")
		s flagO=$d(^PAC("ADMLOC",0,"AdmType","O",CTLocId))
		s flagE=$d(^PAC("ADMLOC",0,"AdmType","E",CTLocId))
		d OuputRow111
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow111
	set Data=$lb(CTLocId,CTLocDesc,ContactName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpCTLocFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCTLocExecute ]
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

ClassMethod LookUpCTLocClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCTLocFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询用户
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpUser","王")
Query LookUpUser(desc As %Library.String, HospId As %String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,USER:%String")
{
}

ClassMethod LookUpUserExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, HospId As %String = "") As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*
	i desc=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}*/
	
	s USERID=0
	s desc=$zcvt(desc,"U")
	for {
		s USERID=$O(^SSU("SSUSR",USERID)) Q:USERID=""
		s USERIDNAME=$p(^SSU("SSUSR",USERID),"^",2)
		// 判断是否医生
		s CTCareProv9=$p(^SSU("SSUSR",USERID),"^",9)
		s CTCareProv14=$p(^SSU("SSUSR",USERID),"^",14)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",USERID,HospId)="N"
		continue:((CTCareProv9="")&&(CTCareProv14=""))
		s SSUSRInitials=$p(^SSU("SSUSR",USERID),"^",1)
		s USRActive=$p(^SSU("SSUSR",USERID),"^",19)
		continue:USRActive'="Y"
		s Datefrom=$p(^SSU("SSUSR",USERID),"^",96)
		s DateTo=$p(^SSU("SSUSR",USERID),"^",97)
		continue:(Datefrom'="")&&(Datefrom>+$H)
		continue:(DateTo'="")&&(DateTo<+$H)
		;continue:((desc'="")&&($zcvt(USERIDNAME,"U")'[desc)&&($zcvt(SSUSRInitials,"U")'[desc))	
		d OuputRow222
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow222
	set Data=$lb(USERID,USERIDNAME)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpUserFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUserExecute ]
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

ClassMethod LookUpUserClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUserFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-22
/// DESC: 取医嘱模版数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetOETabItems("User.CTLoc",7,"")
ClassMethod GetOETabItems(objtype As %String, objvalue As %String, Key As %String = "") As %String
{
	n (objtype,objvalue,Key)
	s ^tempscl("GetOETabItems")=objtype_","_objvalue_","_Key
	s i=1
	k ^GetOETabItems("ORDER")	
	s ^GetOETabItems("ORDER",objtype,objvalue)=""
	s websysPrefId=""
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	do rs.Execute(objtype,objvalue)
	while(rs.%Next()){
		//valueDesc:%String:类型描述,valueCode:%String:类型代码,Type:%String:类型,
		//AppKey:%String:应用代码,EPRChartCode:%String:EPR图表,
		//EPRChartSize:%String:EPR图表尺寸,Tab:%String:表名,Col:%String:列名,
		//ARCIMorARCOS:%String:医嘱或医嘱套,Desc:%String:药品描述,Code:%String:药品代码
		//,NoShowAlias:%String:不显示别名,NoShowAliasSameCode:%String:别名和代码一致则不显示别名
		s valueDesc=rs.GetDataByName("valueDesc")
		s AppKey=rs.GetDataByName("AppKey")
		//不导按工作流保存的
		//continue:((Key="")&&(AppKey'="ORDER"))
		//按工作流 如 Key=ORDERW50008
		continue:((Key'="")&&(AppKey'=Key))
		
		s Type=rs.GetDataByName("Type")
		s Tab=rs.GetDataByName("Tab")
		s Col=rs.GetDataByName("Col")
		s ARCIMorARCOS=rs.GetDataByName("ARCIMorARCOS")
		//不导出医嘱套
		//continue:ARCIMorARCOS="ARCOS"
		s Desc=rs.GetDataByName("Desc")
		s Code=rs.GetDataByName("Code")
		s Index=rs.GetDataByName("Index")
		s itemrowid=rs.GetDataByName("itemrowid")
		s tabIndex=..FormateIndex($p(Index,"||",1))
		s ColIndex=..FormateIndex($p(Index,"||",2))
		s CodeIndex=..FormateIndex($p(Index,"||",3))
		s Tab=tabIndex_"!"_Tab
		s websysPrefId=rs.GetDataByName("websysPrefId")
		s ^GetOETabItems("ORDER",objtype,objvalue,Tab,ColIndex_"!"_Col,CodeIndex_"!"_Code)=valueDesc_"^"_Type_"^"_Tab_"^"_Col_"^"_ARCIMorARCOS_"^"_Code_"^"_Desc_"^"_itemrowid_"^"_websysPrefId

	}	
	b //34
	d rs.%Close()
	if (websysPrefId="")&&(Key'=""){
		s websysPrefId=$o(^websys.PreferencesI("Index", objtype, objvalue, Key, "OEOrder.PrefTabs.EditList", ""))
		Q "!!"_websysPrefId
	}	
	s allTable="",websysPrefId=""
	s Tab=""
	f  s Tab=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab)) q:Tab=""  d
	.//表名
	.s onetabName=$p(Tab,"!",2)
	.s groupsStr=""
	.s Col=""
	.f  s Col=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col)) q:Col=""  d
	..s groupname=$p(Col,"!",2)
	..s onegroupStr=""
	..s Code=""
	..f  s Code=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code)) q:Code=""  d
	...s DESC=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",7)
	...s Type=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",5)
	...//q:Type=""
	...s itemrowid=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",8)
	...s websysPrefId=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",9)
	...s tepstr=Code_"$c(4)"_DESC_"$c(4)"_Type_"$c(4)"_itemrowid_"$c(4)"_websysPrefId
	...i onegroupStr="" d
	....s onegroupStr=tepstr
	...else  d
	....s onegroupStr=onegroupStr_"^"_tepstr
	..s onegroup=groupname_"::"_onegroupStr
	..i groupsStr="" d
	...s groupsStr=onegroup
	..else  d
	...s groupsStr=groupsStr_"$c(28)"_onegroup	//groupsStr_$c(28)_onegroup
	.s onetable=onetabName_"@"_groupsStr
	.i allTable="" d
	..s allTable=onetable
	.else  d
	..s allTable=allTable_","_onetable	
	k ^GetOETabItems("ORDER")
	s ^tempscl("allTable")=allTable	
	q allTable_"!!"_websysPrefId
}

ClassMethod FormateIndex(SeqNo)
{
	If $L(SeqNo)=2 Set SeqNo="0"_SeqNo
	If $L(SeqNo)=1 Set SeqNo="00"_SeqNo
	Q SeqNo
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 根据类型获取科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","GetLocByType","O^E")
Query GetLocByType(TypeList As %String, code As %String = "", HospId As %String = "") As %Query(ROWSPEC = "rowid,Desc,ContactName")
{
}

ClassMethod GetLocByTypeExecute(ByRef qHandle As %Binary, TypeList As %String, code As %String = "", HospId As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    //i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    Set langid=..%LanguageID()
    k TempList
    f itype=1:1:$L(TypeList,"^")  d
	.s loctype=$P(TypeList,"^",itype)
	.if loctype="I"  d
	..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...q:($p($g(^CTLOC(rowid)),"^",13)'="E")
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
    ...Q:(Desc["门诊")
    ...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
	...Q:($P(^CTLOC(rowid),"^",14)'="Y")
	...s Desc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Desc,langid)
    ...s TempList(Desc,rowid)=Desc_"^"_ContactName
    ...;d OutputRow6
    ...
    .else  d
    ..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
 	...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
	...Q:($P(^CTLOC(rowid),"^",14)'="Y")
	...s Desc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Desc,langid)
    ...s TempList(Desc,rowid)=Desc_"^"_ContactName
    ...;d OutputRow6
   
    s sub1=0
    f  s sub1=$O(TempList(sub1)) Q:sub1=""  d
    .s sub2=0
    .f  s sub2=$O(TempList(sub1,sub2)) Q:sub2=""  d
    ..s value=$G(TempList(sub1,sub2))
    ..s rowid=sub2
    ..s Desc=$p(value,"^",1)
    ..s ContactName=$p(value,"^",2)
    ..d OutputRow6
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(rowid,Desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocByTypeExecute ]
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

ClassMethod GetLocByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// ==================

/*Query FindGroup(desc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_Rowid,SSGRP_Desc")
{
	SELECT SSGRP_Rowid, SSGRP_Desc 
	FROM SQLUser.SS_Group
	WHERE SSGRP_Desc %STARTSWITH :desc
	ORDER BY SSGRP_Desc
}*/
/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取安全组
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","FindGroup","")
Query FindGroup(value As %String, HospRowId As %String = "") As %Query(ROWSPEC = "SSGRP_Rowid:%String,SSGRP_Desc:%String")
{
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary, value As %String, HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
    s value=$ZCVT(value,"U")
    s rowid=0
    for {
	    s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""
	    s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",rowid,HospRowId)
		continue:flag="N"
	    s desc=$p(^SSU("SSGRP",rowid),"^",1)
	    continue:($ZCVT(desc,"U")'[value)&&(value'="")
		s ActiveFlag=$p(^SSU("SSGRP",rowid),"^",151)
	    continue:ActiveFlag="N"
	    Do OutputRowFind
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	set Data=$lb($g(rowid),$g(desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupExecute ]
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
/// DATE: 2018-09-11
/// DESC: 根据安全组id获取科室
/// IN  : 
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetGroupAdmLoc("163","nk")
ClassMethod GetGroupAdmLoc(GroupRowId As %String, LocDesc As %String = "", HospId As %String = "")
{
	n (GroupRowId,LocDesc,HospId,%session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",GroupRowId,HospId)="N") {
		Q ""
	}
	s mRtn = ""
	s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:AdmDep")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(GroupRowId)
		If 'Status Quit
		While (rset.Next()) {
			s CTLOCDesc=rset.GetData(2)
			s ResRowIdStr=rset.GetData(1)
			s LocId=+ResRowIdStr
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocId,HospId)="N"
			s LocOtherName=""
			s:LocId'="" LocOtherName=$p(^CTLOC(LocId),"^",43)
			s LocOtherName=$$ALPHAUP^SSUTIL4(LocOtherName)
			continue:(LocOtherName'="")&&(LocDesc'="")&&(LocOtherName'[LocDesc)&&(CTLOCDesc'[LocDesc)
			i mRtn="" s mRtn=ResRowIdStr_"&"_CTLOCDesc
	   		e  s mRtn=mRtn_"^"_ResRowIdStr_"&"_CTLOCDesc
	   		
		    ;i mRtn="" s mRtn=$ZCVT(ResRowIdStr,"O","JS")_"!"_$ZCVT(CTLOCDesc,"O","JS")
	   		;e  s mRtn=mRtn_"^"_$ZCVT(ResRowIdStr,"O","JS")_"!"_$ZCVT(CTLOCDesc,"O","JS")
		}
		d rset.Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-11
/// DESC: 根据安全组id获取医生
/// IN  : 
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDocByLoc("1","")
ClassMethod GetDocByLoc(LocId As %String, DocName As %String = "", HospId As %String = "")
{
	n (LocId,DocName,HospId,%session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocId,HospId)="N") {
		Q ""
	}
	s mRtn=""
	s DocName=$$ALPHAUP^SSUTIL4(DocName)
	s Type="",UserID="",DataType="ResID"
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(LocId,Type,UserID)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",DocRowid,HospId)="N"
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 Set OtherName=$p(^CTPCP(DocRowid,3),"^",28)
			 Set Hidden="N"
			 if (0=##Class(web.DHCExaBorough).CheckDocAlias(DocRowid,DocName)){
				Set Hidden="Y"	
			 }
			 i DataType = "ResID" d
			 .i mRtn="" s mRtn=ResRowid_"!"_DocDesc_"!"_Hidden
	   		 .e  s mRtn=mRtn_"^"_ResRowid_"!"_DocDesc_"!"_Hidden
			 e  d
			 .i mRtn="" s mRtn=DocRowid_"!"_DocDesc_"!"_Hidden
	   		 .e  s mRtn=mRtn_"^"_DocRowid_"!"_DocDesc_"!"_Hidden
		 }
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-11
/// DESC: 从web.DHCOPRegConfig.SaveGroupRes中改迁
/// IN  : +^869!+^1085!-^528
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveGroupRes("163","",528)
ClassMethod SaveGroupRes(GroupRowId As %String, inPara As %String, subPara As %String, HospId As %String = "") As %String
{
	n (GroupRowId,inPara,subPara,HospId)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:((inPara="")&&(subPara=""))||(GroupRowId="") 0
	s osPara=$P($g(^SSU("SSGRP",GroupRowId,"DHC",HospId)),"^",1)
	s resPara=""
	s osLen=$l(osPara,"!")
	f i=1:1:osLen {
		s curValue=$p(osPara,"!",i)
		i ("!"_subPara_"!")'[("!"_curValue_"!") {
			i resPara="" s resPara=curValue
			e  s resPara=resPara_"!"_curValue
		}
	}
	i inPara'="" {
		if (resPara="") {
			s resPara=inPara
		}else{
			for i=1:1:$l(inPara,"!") {
				s curValue=$p(inPara,"!",i)
				i ("!"_resPara_"!")'[("!"_curValue_"!") {
					s resPara=resPara_"!"_curValue
				}	
			}
		}
	} 
	s $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",1)=resPara

	Q 0
}

ClassMethod DeleteGroupRes(GroupRowId As %String, ResRowId As %String, HospId As %String = "") As %String
{
	n (GroupRowId,ResRowId,HospId)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s osPara=$P($g(^SSU("SSGRP",GroupRowId,"DHC",HospId)),"^",1)
	s resPara=""
	s osLen=$l(osPara,"!")
	f i=1:1:osLen {
		s curValue=$p(osPara,"!",i)
		i (curValue'=ResRowId) {
			i resPara="" s resPara=curValue
			e  s resPara=resPara_"!"_curValue
		}
	}
	s $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",1)=resPara
	Q 0
}

ClassMethod DeleteGroupResByLoc(GroupRowId As %String, LocId As %String, HospId As %String = "") As %String
{
	n (GroupRowId,LocId,HospId)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s resPara=""
	s osPara=$P($g(^SSU("SSGRP",GroupRowId,"DHC",HospId)),"^",1)
	s osLen=$l(osPara,"!")
	f i=1:1:osLen {
		s curValue=$p(osPara,"!",i)
		continue:curValue=""
		s RESCTLOCDR=$p($g(^RB("RES",curValue)),"^",1)
		continue:(RESCTLOCDR="")||(RESCTLOCDR=LocId)
		i resPara="" s resPara=curValue
		e  s resPara=resPara_"!"_curValue
	}
	s $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",1)=resPara
	Q 0
}

// ========================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询模块代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryCodeModule")
Query QryCodeModule() As %Query(ROWSPEC = "ModuleRowId:%String,ModuleDesc:%String")
{
}

ClassMethod QryCodeModuleExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
      
	Set rset=##class(%ResultSet).%New("web.DHCDocCTCommon:GetDHCDocCTModule")
	do rset.Execute()
	While (rset.Next()) {
		s ModuleRowId=rset.Data("ModuleRowId")
		s ModuleDesc=rset.Data("ModuleDesc")
		d OutputRow66
	}
	d rset.Close()
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow66
	set Data=$lb(ModuleRowId,ModuleDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCodeModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCodeModuleExecute ]
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

ClassMethod QryCodeModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCodeModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// =============医嘱归类模块HUI===========

/// web.DHCDocOrderEntry
/// /d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","LookUpItemNew","pttzs",29,"14#","","","","",67,"","",3009,"","",185,"","")
/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItemNew","ptt",29,"","","","","",69,"","",1259,"","",188,"","")
Query LookUpItemNew(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String,ArcimDr:%String")
{
}

ClassMethod LookUpItemNewExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	//New repid, index
	///do ResetVariables
	//n (QHandle,Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	s ^tempscl("sd")=Item_","_GroupID_","_Category_","_SubCategory_","_TYPE_","_OrderDepRowId_","_OrderPriorRowId_","_EpisodeID_","_BillingGrp_","_BillingSubGrp_","_UserRowId_","_OrdCatGrp_","_NonFormulary_","_Form_","_Strength_","_Route
	kill ^||tmpLookUpItemNew
	Set repid=$I(^CacheTemp)
	Set index=1,Num=0
	//b ;001
	i Item=""{
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d obj.Execute(Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	//b ;02
	
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		///OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,HIDDEN:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String
		s OrdName=obj.GetData(1)
		s OrdName=##class(web.DHCDocUtil).EvalJSON(OrdName)
		s OrdInfo=OrdName
		For col = 2:1:columns {
			s tmpOrdName=##class(web.DHCDocUtil).EvalJSON(obj.GetData(col))
			 i col="15" {
				 s tmpOrdName=$replace(tmpOrdName,$c(14),"")
				 s tmpOrdName=$replace(tmpOrdName,$c(12),"")
			 }
			 
	         s OrdInfo=OrdInfo_"^"_tmpOrdName
	    }
	    
		Set Data=$lb(OrdInfo,OrdName,obj.GetData(18),obj.GetData(19),obj.GetData(21),obj.GetData(27),obj.GetData(28),obj.GetData(29),obj.GetData(31),obj.GetData(32),obj.GetData(2))
		//i Data'="" s ^tempscl("OrdInfo1",Data)=1
		do RecordSortTmpDataNew
	}
	
	s RecordCount=""
	for {
		s RecordCount=$o(^||tmpLookUpItemNew(RecordCount),-1) Quit:RecordCount=""
		s Num=0
		for {
			s Num=$o(^||tmpLookUpItemNew(RecordCount,Num)) Quit:Num=""
			s id=0
			for {
				s id=$o(^||tmpLookUpItemNew(RecordCount,Num,id)) Quit:id=""
				s Data=^||tmpLookUpItemNew(RecordCount,Num,id)
				;s ^tmpLookUpItemNewlog(RecordCount,Num,id)=Data
				do OutputRowItemNew
			}
		}
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
RecordSortTmpDataNew
	Set OutRecordId=obj.GetData(2)
	Q:OutRecordId=""
	Set Num=Num+1
	
	if OutRecordId["||"{
		s TableName="User.ARCItmMast"
	}else{
		s TableName="User.ARCOrdSets"	
	}
	Set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,OutRecordId,UserRowId,"U")
	Set ^||tmpLookUpItemNew(RecordCount,Num,OutRecordId)=Data
	quit
OutputRowItemNew
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod LookUpItemNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	//New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpItemNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	// New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// =============常用维护中医嘱项替换HUI===========

/// CTOR: QP
/// DATE: 2018-09-18
/// atype: ARCOS/TMPL/USE(医嘱套/医嘱模板/常用用法维护)
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryReplaceArcim","TMPL","","","",2)
Query QryReplaceArcim(atype = "", arcimrow = "", locid = "", ssuid = "", HospId As %String = "") As %Query(ROWSPEC = "acosdate,arcosname,acostype,desc,RowId,cfgType,detail,cfgCode,index")
{
}

ClassMethod QryReplaceArcimExecute(ByRef qHandle As %Binary, atype = "", arcimrow = "", locid = "", ssuid = "", HospId As %String = "") As %Status
{
 s repidQ=$I(^CacheTemp)	
 s indQ=1
 s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
 s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
 
 i (atype="ARCOS")||(atype="") {
	 s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:arcos=""  d
	 .s favId=$o(^DHCFavItems(0,"ItemRowid",arcos,""))
	 .Q:favId=""
	 .s (userId,depId,hospId)=""
	 .i favId'="" d
	 ..s userId=$p(^DHCFavItems(favId),"^",2)
	 ..s depId=$p(^DHCFavItems(favId),"^",4)
	 ..s hospId=$p(^DHCFavItems(favId),"^",9)
	 ..s FavUseHospDr=$p($g(^DHCFavItems(favId)),"^",11)
	 .Q:FavUseHospDr'=HospId
	 .q:(ssuid'="")&&(userId'=ssuid)
	 .q:(locid'="")&&(depId'=locid)
	 .q:(depId'="")&&($p(^CTLOC(depId),"^",22)'=HospId)
	 .q:(hospId'="")&&(hospId'=HospId)
	 .s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:datesub=""  d
	 ..s flag=0,detail=""
	 ..s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:arcossub=""  d
	 ...s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
	 ...q:(arcosarcitm="")||(arcosarcitm="undefined")	//处理表中垃圾数据QP
	 ...Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcosarcitm,DefHospId)="N"
	 ...s arcosarcitmDesc=$p($g(^ARCIM(+arcosarcitm,$P(arcosarcitm,"||",2),1)),"^",2)
	 ...s curId=arcos_"||"_datesub_"||"_arcossub
	 ...i detail="" s detail=curId_"^"_arcosarcitmDesc_"^"_arcosarcitm
	 ...e  s detail=detail_"!"_curId_"^"_arcosarcitmDesc_"^"_arcosarcitm
	 ...q:(arcimrow'="")&&(arcimrow'=arcosarcitm)
	 ...s flag=1  //包含这个医嘱项
	 ..//检索医嘱套嵌套
	 ..s OSChildsub=0 f  s OSChildsub=$o(^ARCOS(arcos,"DATE",datesub,"OS",OSChildsub)) q:OSChildsub=""  d
	 ...s OSOrderSetDR=$p(^ARCOS(arcos,"DATE",datesub,"OS",OSChildsub),"^",1)
	 ...s OSfavId=$o(^DHCFavItems(0,"ItemRowid",OSOrderSetDR,""))
	 ...Q:OSfavId=""
	 ...s OSArcosName=$p(^ARCOS(OSOrderSetDR),"^",2)	;套名称
	 ...s curId=arcos_"||"_datesub_"||"_OSChildsub
	 ...i detail="" s detail=curId_"^"_OSArcosName_"^"_OSOrderSetDR
	 ...e  s detail=detail_"!"_curId_"^"_OSArcosName_"^"_OSOrderSetDR
	 ..i flag=1 d
	 ...s userName="",depName="",hospName="全院",desc="",cfgType="医嘱套",cfgCode="ARCOS"
	 ...s acossubcat=$p(^ARCOS(arcos),"^",9) 
	 ...s acostype=""
	 ...if acossubcat'="" s acostype=$p(^ARC("IC",acossubcat),"^",2)	;套类型
	 ...s arcosname=$p(^ARCOS(arcos),"^",2)	;套名称
	 ...s acosdate=$p(^ARCOS(arcos,"DATE",datesub),"^",1)
	 ...s acosdate=..%ZD(acosdate)
	 ...i userId'="" d
	 ....s userName=$p(^SSU("SSUSR",userId),"^",2)
	 ....s desc=userName_"->"_arcosname
	 ...e  i depId'="" d
	 ....s depName=$p(^CTLOC(depId),"^",2)
	 ....s desc=depName_"->"_arcosname
	 ...e  s desc=hospName_"->"_arcosname
	 ...s RowId=arcos_"||"_datesub
	 ...d OutputRow
 }
 i (atype="TMPL")||(atype="") {
	i ssuid'="" s FavType="USER.SSUSER",FavTypeValue=ssuid
	e  i locid'="" s FavType="USER.CTLOC",FavTypeValue=locid
	e  s FavType="",FavTypeValue=""
	s iCatType="" f  s iCatType=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType)) Q:iCatType=""  d
	.s CatType=$TR(iCatType," ")
	.s Type=$ZCVT($P(CatType,"|",1),"U")
	.q:(FavType'="")&&(FavType'=Type)
	.s iTypeValue="" f  s iTypeValue=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue)) Q:iTypeValue=""  d
	..s TypeValue=$TR(iTypeValue," ")
	..q:(FavTypeValue'="")&&(FavTypeValue'=$ZCVT(TypeValue,"U"))
	..i Type="USER.SSUSER" s cfgType="医嘱模板(个人)",cfgCode="TMPL-SSUser",valueDesc=$p($g(^SSU("SSUSR",+TypeValue)),"^",2),HospitalDR=$p(CatType,"|",3)
	..e  i Type="USER.CTLOC"'="" s cfgType="医嘱模板(科室)",cfgCode="TMPL-CTLoc",valueDesc=$p($g(^CTLOC(+TypeValue)),"^",2),HospitalDR=$p($g(^CTLOC(+TypeValue)),"^",22)
	..e  s cfgType="医嘱模板(全院)",cfgCode="TMPL-Hospital",valueDesc=$p($g(^CT("HOSP",+TypeValue)),"^",2),HospitalDR=TypeValue
	..q:(HospId'="")&&(HospitalDR'=HospId)
	..s CatSeq="" f  s CatSeq=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq)) Q:CatSeq=""  d
	...s CatID=0  f  s CatID=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq,CatID)) Q:CatID=""  d
	....s Cat=$LG(^User.ARCOrdFavCatD(CatID),4)
	....s acostype=$LG(^User.ARCOrdFavCatD(CatID),2)
	....s SubSeq="" f  s SubSeq=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,SubSeq)) Q:SubSeq=""  d
	.....s SubCatID=0 f  s SubCatID=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,SubSeq,SubCatID)) Q:SubCatID=""  d
	......s SubCat=$LG(^User.ARCOrdFavSubCatD(SubCatID),3)
	......s detail=""
	......s ItemSeq="" f  s ItemSeq=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,ItemSeq)) Q:ItemSeq=""  d
	.......s FavItemID=0 f  s FavItemID=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,ItemSeq,FavItemID)) Q:FavItemID=""  d
	........s ItemID=$LG(^User.ARCOrdFavItemD(FavItemID),3)
	........i ItemID["||" s ItemDesc=$P(^ARCIM(+ItemID,1,1),"^",2),itemType="ARCIM"
	........e  s ItemDesc=$P(^ARCOS(ItemID),"^",2),itemType="ARCOS"
	........s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel($LG(^User.ARCOrdFavItemD(FavItemID),7))
	........s:PartInfo'="" ItemDesc=ItemDesc_PartInfo
	........s itemNotes=$LG(^User.ARCOrdFavItemD(FavItemID),6)
	........s:itemNotes'="" ItemDesc=ItemDesc_"["_itemNotes_"]"
	........i detail="" s detail=ItemID_"^"_ItemDesc_"^"_itemType
	........e  s detail=detail_"!"_ItemID_"^"_ItemDesc_"^"_itemType
	......
	......s curRecord=valueDesc_"->"_Cat_"->"_SubCat
	......s (acosdate,arcosname)=""
	......s id=SubCatID
	......d OutputRow1
	
 }
 i (atype="USE")||(atype="") {
	s:arcimrow'="" ItemDesc=$p($g(^ARCIM(+arcimrow,$P(arcimrow,"||",2),1)),"^",2)
	if (ssuid'="") {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","User",ssuid,Rowid))
			q:Rowid=""
			//s Rowid=$O(^DHCDID(0,"LastUser",UserID,Rowid)) q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetData
		}
	}
	if (locid'="") {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","Location",locid,Rowid))
			q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetData
		}
	}
	if ((ssuid="")&&(locid="")) {
		s curLoc="" f  s curLoc=$O(^DHCDID(0,"Contral","Location",curLoc)) q:curLoc=""  d
		.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","Location",curLoc,Rowid)) q:Rowid=""  d
		..s Data=$g(^DHCDID(Rowid))
		..d GetData
		
		s curUser="" f  s curUser=$O(^DHCDID(0,"Contral","User",curUser)) q:curUser=""  d
		.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","User",curUser,Rowid)) q:Rowid=""  d
		..s Data=$g(^DHCDID(Rowid))
		..d GetData
	}
 	
 }
 i (atype="CureAppend")||(atype="") {
 	//治疗项目设置-》绑定医嘱列表中的医嘱项
 	s DDCIAIRowid=0
 	for {
 		s DDCIAIRowid=$O(^DHCDocCureItemSet(DDCIAIRowid))
 		q:(DDCIAIRowid="")
 		s CureArcimDr=$p(^DHCDocCureItemSet(DDCIAIRowid),"^",1)
 		s HospitalDR=$p(^DHCDocCureItemSet(DDCIAIRowid),"^",12)
 		continue:(HospId'=HospitalDR)
 		s CureName=##class(web.DHCDocOrderCommon).GetFormateOrderName(CureArcimDr)
		s CureName=##class(ext.util.String).EvalJSON(CureName)
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
 		s DDCIAIChildSub=0
 		for {
	 		s DDCIAIChildSub=$O(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
	 		q:(DDCIAIChildSub="")
	 		s data=$g(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
	 		s AppendItemDr=$p(data,"^",1)
		 	s AppendItem=##class(web.DHCDocOrderCommon).GetFormateOrderName(AppendItemDr)
		 	s AppendItem=##class(ext.util.String).EvalJSON(AppendItem)
		 	s AppendItemQty=$p(data,"^",2)
		 	s AppendAdmLocID=$p(data,"^",3)
		 	s AppendRecLocID=$p(data,"^",4)
		 	s AppendRecLocDesc=""
		 	i AppendRecLocID'="" s AppendRecLocDesc=$P(^CTLOC(AppendRecLocID),"^",2)
		 	s AppendDefaultFlag=$p(data,"^",5)
	 		if (arcimrow'="")&&(arcimrow=AppendItemDr){
				s FindArcimFlag="Y"
			}
	 		////id^描述^类型^用法^单次用量^数量^接受科室
			s SubTreeDetail=DDCIAIRowid_"||"_DDCIAIChildSub_"^"_AppendItem_"^"_"DHCDocCureItemAppendItem"_"^^^"_AppendItemQty_"^"_AppendRecLocDesc	
			if (OutSubTreeDetail'=""){
				s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
			}else{
				s OutSubTreeDetail=SubTreeDetail
			}
	 		
	 	}
	 	continue:(arcimrow'="")&&(FindArcimFlag="N")
	 	continue:(OutSubTreeDetail="")
	 	///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=CureName
 		s OutType=""
 		s OutDetails=CureName
 		s OutRowId=DDCIAIRowid
 		s OutConfigType="治疗项目绑定医嘱"
 		s OutConfigCode="CureAppend"
 		d OutputRowCommon
	 	
 	}
 	
 }
 i (atype="LabAppend")||(atype="") {
	//检验绑定医嘱规则	
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.LabBindRuleSetting:QueryLabPlan")
	do rset.Execute(HospId)
	s columns = rset.GetColumnCount()
	s row=0
	While (rset.Next()) {
		s PlanRowId=$g(rset.Data("RowID"))
		s PlanName=$g(rset.Data("PlanName"))
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s LoopLabPlanBindType=0
		for {
			s LoopLabPlanBindType=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_PlanRowId,LoopLabPlanBindType))
			q:LoopLabPlanBindType=""
			s LabPlanBindType=$replace(LoopLabPlanBindType," ","")
			s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.LabBindRuleSetting:QueryLabPlanBindOrdFee")
			do rset2.Execute(PlanRowId,LabPlanBindType)
			While (rset2.Next()) {
				s LabPlanBindOrdFeeID=$g(rset2.Data("RowID"))
				s ARCIMDR=$g(rset2.Data("ARCIMDR"))
				s ArcimDesc=$g(rset2.Data("ArcimDesc"))
				s Qty=$g(rset2.Data("Qty"))
				
				if (arcimrow'="")&&(arcimrow=ARCIMDR){
					s FindArcimFlag="Y"
				}
				
				//id^描述^类型^用法^单次用量^数量^接受科室
				s SubTreeDetail=LabPlanBindOrdFeeID_"^"_ArcimDesc_"^"_"DHCDocLabPlanBindOrdFee:"_LoopLabPlanBindType_"^^^"_Qty_"^"	
				if (OutSubTreeDetail'=""){
					s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
				}else{
					s OutSubTreeDetail=SubTreeDetail
				}
				
				
			}
			
		}
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
	 	///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=PlanName
 		s OutType=""
 		s OutDetails=PlanName
 		s OutRowId=PlanRowId
 		s OutConfigType="检验绑定医嘱"
 		s OutConfigCode="LabAppend"
 		d OutputRowCommon
		
	}
 }
 i (atype="SkinAppend")||(atype="") {
	//皮试绑定医嘱
	s ActRowid=0
	for {
		s ActRowid=$O(^OEC("ACT",ActRowid))
		q:(ActRowid="")
		s ActDesc=$p(^OEC("ACT",ActRowid),"^",2)
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.SkinTestConfig:GetSkinLinkItem")
		do rset.Execute(ActRowid,HospId)
		While (rset.Next()) {
			s ActIARCIMDR=$g(rset.Data("ActIARCIMDR"))
			s ActIARCIMDesc=$g(rset.Data("ActIARCIMDesc"))
			s SkinAppendRowid=$g(rset.Data("Rowid"))
			s Instr=$g(rset.Data("Instr"))
			s Dose=$g(rset.Data("Dose"))
			s DoseUom=$g(rset.Data("DoseUom"))
			s ActIQty=$g(rset.Data("ActIQty"))
			s DoseStr=""
			if (DoseUom'="")&&(Dose'=""){
				s DoseStr=Dose_DoseUom
			}
			if (arcimrow'="")&&(arcimrow=ActIARCIMDR){
				s FindArcimFlag="Y"
			}
			//id^描述^类型^用法^单次用量^数量^接受科室
			s SubTreeDetail=SkinAppendRowid_"^"_ActIARCIMDesc_"^"_"DHC_OECAction"_"^"_DoseStr_"^"_Instr_"^"_ActIQty_"^"	
			if (OutSubTreeDetail'=""){
				s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
			}else{
				s OutSubTreeDetail=SubTreeDetail
			}
			
		}
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
	 	///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=ActDesc
 		s OutType=""
 		s OutDetails=ActDesc
 		s OutRowId=ActRowid
 		s OutConfigType="皮试绑定医嘱"
 		s OutConfigCode="SkinAppend"
 		d OutputRowCommon
		
	}
 }
 i (atype="ItemListAppend")||(atype="") {
	//附加医嘱绑定-按医嘱
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Items:GetItemList")
	do rset.Execute("","",HospId,"")
	While (rset.Next()) {
		s ARCIMRowID=$g(rset.Data("ARCIMRowID"))
		s ARCIMDesc=$g(rset.Data("ARCIMDesc"))
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Items:GetAppendItemList")
		do rset2.Execute(ARCIMRowID,HospId)
		While (rset2.Next()) {
			s DHCIARowid=$g(rset2.Data("DHCIARowid"))
			s AddItmDR=$g(rset2.Data("AddItmDR"))
			s AddItmDesc=$g(rset2.Data("AddItmDesc"))
			s Dose=$g(rset2.Data("Dose"))
			s DoseUom=$g(rset2.Data("DoseUom"))
			s DHCIAInstr=$g(rset2.Data("DHCIAInstr"))
			s DHCIARecLoc=$g(rset2.Data("DHCIARecLoc"))
			s SPECDesc=$g(rset2.Data("SPECDesc"))
			s Qty=$g(rset2.Data("DHCIAQty"))
			s DoseStr=""
			if (DoseUom'="")&&(Dose'=""){
				s DoseStr=Dose_DoseUom
			}
			if (arcimrow'="")&&(arcimrow=AddItmDR){
				s FindArcimFlag="Y"
			}
			//id^描述^类型^用法^单次用量^数量^接受科室
			s SubTreeDetail=DHCIARowid_"^"_AddItmDesc_"^"_"DHC_ItmAdd"_"^"_DoseStr_"^"_DHCIAInstr_"^"_Qty_"^"_DHCIARecLoc_"^"_SPECDesc
			if (OutSubTreeDetail'=""){
				s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
			}else{
				s OutSubTreeDetail=SubTreeDetail
			}
			
		}
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
	 	///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=ARCIMDesc
 		s OutType=""
 		s OutDetails=ARCIMDesc
 		s OutRowId=ARCIMRowID
 		s OutConfigType="附加医嘱绑定-按医嘱"
 		s OutConfigCode="ItemListAppend"
 		d OutputRowCommon
	}
 }
 i (atype="CatListAppend")||(atype="") {
	//附加医嘱绑定-按子类
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:FindCatList")
	do rset.Execute("",HospId)
	While (rset.Next()) {
		s ARCICRowId=$g(rset.Data("ARCICRowId"))
		s ARCICDesc=$g(rset.Data("ARCICDesc"))
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.AppendItemInItemCat:GetAppendItemInItemCat")
		do rset2.Execute(ARCICRowId,HospId)
		While (rset2.Next()) {
			s DHCICARowid=$g(rset2.Data("DHCICARowid"))
			s ARCIMRowid=$g(rset2.Data("ARCIMRowid"))
			s ARCIMDesc=$g(rset2.Data("ARCIMDesc"))
			s Dose=$g(rset2.Data("Dose"))
			s DoseUom=$g(rset2.Data("DoseUom"))
			s DHCIAInstr=$g(rset2.Data("DHCIAInstr"))
			s Qty=$g(rset2.Data("Qty"))
			s RecLoc=$g(rset2.Data("RecLoc"))
			s SPECDesc=$g(rset2.Data("SPECDesc"))
			s DoseStr=""
			if (DoseUom'="")&&(Dose'=""){
				s DoseStr=Dose_DoseUom
			}
			if (arcimrow'="")&&(arcimrow=ARCIMRowid){
				s FindArcimFlag="Y"
			}
			//id^描述^类型^用法^单次用量^数量^接受科室
			s SubTreeDetail=DHCICARowid_"^"_ARCIMDesc_"^"_"DHC_ItmSubCatAdd"_"^"_DoseStr_"^"_DHCIAInstr_"^"_Qty_"^"_RecLoc_"^"_SPECDesc
			if (OutSubTreeDetail'=""){
				s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
			}else{
				s OutSubTreeDetail=SubTreeDetail
			}
			
		}
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
	 	///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=ARCICDesc
 		s OutType=""
 		s OutDetails=ARCICDesc
 		s OutRowId=ARCICRowId
 		s OutConfigType="附加医嘱绑定-按子类"
 		s OutConfigCode="CatListAppend"
 		d OutputRowCommon
	}
 }
 i (atype="CMPrescTypeLinkFee")||(atype="") {
	//草药录入设置-》处方剂型关联费用
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CMDocConfig:FindCMPrescType")
	do rset.Execute(HospId)
	While (rset.Next()) {
		s Code=$g(rset.Data("Code"))
		s Desc=$g(rset.Data("Desc"))
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s CMPrescTypeLinkFeeStr=..%GetConfig1(Code,"CMPrescTypeLinkFee",HospId)
		if (CMPrescTypeLinkFeeStr'=""){
			for index=1:1:$l(CMPrescTypeLinkFeeStr,"^"){
				s ArcimRowId=$p(CMPrescTypeLinkFeeStr,"^",index)
				s ArcimDesc=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",2)
				
				if (arcimrow'="")&&(arcimrow=ARCIMRowid){
					s FindArcimFlag="Y"
				}
				//id^描述^类型^用法^单次用量^数量^接受科室
				s SubTreeDetail=index_"^"_ArcimDesc_"^"_"CMPrescTypeLinkFee"_"^"_"^"_"^"_"^"_"^"
				if (OutSubTreeDetail'=""){
					s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
				}else{
					s OutSubTreeDetail=SubTreeDetail
				}
				
			}
		}
		
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
		///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=Desc
 		s OutType=""
 		s OutDetails=Desc
 		s OutRowId=Code
 		s OutConfigType="草药录入设置-处方剂型关联费用"
 		s OutConfigCode="CMPrescTypeLinkFee"
 		d OutputRowCommon
		
	}
 }
 i (atype="ArcWardAppend")||(atype="") {
	//病区绑定医嘱设置
	&SQL(DECLARE PACWardList CURSOR FOR 
		select LINK_CTLOC_DR INTO :INKCTLOCDR from SQLUser.CT_LocLinkLocation 
		where LINK_ParRef->CTLOC_Hospital_DR=:HospId group by LINK_CTLOC_DR)
	&SQL(OPEN PACWardList)
 	For  {
		&SQL(FETCH PACWardList)
		QUIT:SQLCODE
		s PACWardDR=$O(^PAWARD(0,"WARD_LocationDR",INKCTLOCDR,0))
		continue:(PACWardDR="")
		s PACWardName=$P(^PAWARD(PACWardDR),"^",2)
		s PACWardLoc=$P(^PAWARD(PACWardDR),"^",5)
		continue:(locid'="")&&(locid'=PACWardLoc)
		s FindArcimFlag="N"
		s OutSubTreeDetail=""
		s queryName=""
		for {
			s queryName=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName))
			Q:queryName=""
			s QueryID=""
			for {
				s QueryID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName,PACWardDR,QueryID))
				Q:QueryID=""
				s ID=""
				for {
					s ID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName,PACWardDR,QueryID,ID))
					Q:ID=""
					s Val=$g(^User.DHCDocInstrArcimWardD(ID))
					s ARCIMDR=$lg(Val,4)
					s ARCIMDesc=$P($G(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)),"^",2)
					s AppendType=$lg(Val,5)
					s AppendType=$CASE(AppendType,1:"下医嘱绑定",2:"执行绑定",:"")
					s Qty=$lg(Val,10)
					if (queryName="A"){
						s MainArcimDr=$lg(Val,14)
						s MainARCIMDesc=$P($G(^ARCIM(+MainArcimDr,$P(MainArcimDr,"||",2),1)),"^",2)
						s ARCIMInfo=MainARCIMDesc_"->"_ARCIMDesc
						
					}elseif(queryName="I"){
						s MainInstrDr=$lg(Val,14)
						s MainInstrCode=$P($G(^PHCIN(MainInstrDr)),"^",1) 
						s ARCIMInfo=MainInstrCode_"->"_ARCIMDesc
					}else{
						s ARCIMInfo=ARCIMDesc
					}
					
					
					if (arcimrow'="")&&(arcimrow=ARCIMDR){
						s FindArcimFlag="Y"
					}
					//id^描述^类型^用法^单次用量^数量^接受科室
					s SubTreeDetail=ID_"^"_ARCIMInfo_"^"_"DHCDocInstrArcimWard:"_AppendType_"^"_"^"_"^"_"^"_"^"
					if (OutSubTreeDetail'=""){
						s OutSubTreeDetail=OutSubTreeDetail_"!"_SubTreeDetail
					}else{
						s OutSubTreeDetail=SubTreeDetail
					}
				}
			}
		}
		continue:(arcimrow'="")&&(FindArcimFlag="N")
		continue:(OutSubTreeDetail="")
		///OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode
	 	s OutDate=""
 		s OutName=PACWardName
 		s OutType=""
 		s OutDetails=PACWardName
 		s OutRowId=PACWardDR
 		s OutConfigType="病区绑定医嘱设置"
 		s OutConfigCode="ArcWardAppend"
 		d OutputRowCommon
 	}
 	&SQL(CLOSE PACWardList)
 }
 
 Set qHandle=$lb(0,repidQ,0)
 Quit $$$OK

GetData
	s DIDUserHospDR=$p(Data,"^",31)
	Q:DIDUserHospDR'=HospId
	s ARCIMDR=$p(Data,"^",1)
	if ARCIMDR="" q
	s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)),"^",2)
	q:(($g(ItemDesc)'="")&&(ArcimDesc'[ItemDesc))
	s DataPAAdmType=$p($g(Data),"^",23)
	//q:(PAAdmType'="")&&(PAAdmType'=DataPAAdmType)
	s ContralTypeCode=$p(Data,"^",2)
	s ContralKey=$p(Data,"^",3)
	s ContralType="",ContralDesc=""
	s cfgType="常用用法维护",cfgCode="USE"
	if ContralTypeCode="User" {
		q:(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",+ContralKey,HospId)="N")
		s ContralType="用户"
		s cfgType="常用用法维护(用户)",cfgCode="USE-SSUser"
		s ContralDesc=$p($g(^SSU("SSUSR",+ContralKey)),"^",2)
	}
	if ContralTypeCode="Location" {
		q:($p(^CTLOC(+ContralKey),"^",22)'=HospId)
		s ContralType="科室"
		s cfgType="常用用法维护(科室)",cfgCode="USE-CTLoc"
		s ContralDesc=$p($g(^CTLOC(+ContralKey)),"^",2)
		s ContralDesc=##class(web.DHCOPAdmReg).LocDescFormate(ContralDesc)
	}
	s ActiveFlag=$p(Data,"^",4)
	s Priority=""
	s PriorityDR=$p(Data,"^",5)
	if PriorityDR'="" s Priority=$p(^OECPR(PriorityDR),"^",2)
	s Dose=$p(Data,"^",6)
	s OrderFreqTimeDoseStr=$p($g(Data),"^",28)
	if (OrderFreqTimeDoseStr'="") {
		s Dose=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(OrderFreqTimeDoseStr)
	}
	s DoseUom=""
	s DoseUomDR=$p(Data,"^",7)
	if DoseUomDR'="" s DoseUom=$P(^CT("UOM",DoseUomDR),"^",2)
	s Instr=""
	s InstrDR=$p(Data,"^",8)
	if InstrDR'="" s Instr=$p($G(^PHCIN(InstrDR)),"^",2)
	s PHFreq=""
	s PHFreqDR=$p(Data,"^",9)
	if PHFreqDR'="" s PHFreq=$p($g(^PHCFR(PHFreqDR)),"^",3)
	s OrderFreqWeekStr=$p($g(Data),"^",29)
	if (OrderFreqWeekStr'="") {
		s CalOrderFreqWeekStr=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(PHFreqDR,OrderFreqWeekStr)
		s PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
		//##class(web.DHCARCOrdSets).CalFreqWeekStr(OrderFreqWeekStr),PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
	}
	s Durat=""
	s DuratDR=$p(Data,"^",10)
	if DuratDR'="" s Durat=$p($g(^PHCDU(DuratDR)),"^",3)
	s PackQty=$p(Data,"^",11)
	s SkinTest=$p(Data,"^",12)
	i SkinTest="" s SkinTest="N"
	s SkinAction=""
	s SkinActionDR=$p(Data,"^",13)
	if SkinActionDR'="" s SkinAction=$p(^OEC("ACT",SkinActionDR),"^",2)
	s RelevanceNo=$p(Data,"^",14)
	s UserAdd=""
	s UserAddDR=$p(Data,"^",15)
	if UserAddDR'="" s UserAdd=$p($g(^SSU("SSUSR",UserAddDR)),"^",2)
	s DateAdd=$p(Data,"^",16)
	if DateAdd'="" s DateAdd=..%ZD(DateAdd) //$zd(DateAdd,3)
	s TimeAdd=$p(Data,"^",17)
	if TimeAdd'="" s TimeAdd=..%ZT(TimeAdd,1)
	s LastUpdateUser=""
	s LastUpdateUserDR=$p(Data,"^",18)
	if LastUpdateUserDR'="" s LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	s LastUpdateDate=$p(Data,"^",19)
	if LastUpdateDate'="" s LastUpdateDate=..%ZD(LastUpdateDate) //$zd(LastUpdateDate,3)
	s LastUpdateTime=$p(Data,"^",20)
	if LastUpdateTime'="" s LastUpdateTime=..%ZT(LastUpdateTime,1)
	s Notes=$p(Data,"^",21)
	
	s TPAAdmType=""
	if DataPAAdmType="I" s TPAAdmType="住院"
	if DataPAAdmType="O" s TPAAdmType="门诊"
	if DataPAAdmType="E" s TPAAdmType="急诊"
	
	s SpeedFlowRate=$p($g(Data),"^",24)
	s FlowRateUnitDr=$p($g(Data),"^",25)
	s FlowRateUnit=""
	if (FlowRateUnitDr'=""){
		s FlowRateUnit=$P(^OEC("SFR",FlowRateUnitDr),"^",2)
	}
	s ExceedReasonDR=$p($g(Data),"^",26)
	s ExceedReason=""
	i ExceedReasonDR'="" s ExceedReason=$p($g(^DHCDocExceedReason(ExceedReasonDR)),"^",2)
	s curRecord=ContralDesc_"->"_ArcimDesc_"->"_Priority
	s PackUom=""
	s PackUomDr=$p($g(Data),"^",30)
	if (PackUomDr'="") {
		s PackUom=$P($g(^CT("UOM",PackUomDr)),"^",2)
	}
	//单次剂量^用法^频次^疗程^类型
	s detail=Dose_DoseUom_"^"_Instr_"^"_PHFreq_"^"_Durat_"^"_TPAAdmType_"^"_PackQty_PackUom
	s (acosdate,arcosname,acostype)=""
	d OuputRow3
	q 
OutputRow
	set Data=$lb(acosdate,arcosname,acostype,desc,RowId,cfgType,detail,cfgCode,indQ)
 	Set ^CacheTemp(repidQ,indQ)=Data
 	Set indQ=indQ+1
	quit
OutputRow1
	set Data=$lb(acosdate,arcosname,acostype,curRecord,id,cfgType,detail,cfgCode,indQ)
 	Set ^CacheTemp(repidQ,indQ)=Data
 	Set indQ=indQ+1
	quit
OuputRow3
	set Data=$lb(acosdate,arcosname,acostype,curRecord,Rowid,cfgType,detail,cfgCode,indQ)
 	Set ^CacheTemp(repidQ,indQ)=Data
 	Set indQ=indQ+1
	quit
OutputRowCommon
	set Data=$lb(OutDate,OutName,OutType,OutDetails,OutRowId,OutConfigType,OutSubTreeDetail,OutConfigCode,indQ)
 	Set ^CacheTemp(repidQ,indQ)=Data
 	Set indQ=indQ+1
	quit
}

ClassMethod QryReplaceArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReplaceArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReplaceArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReplaceArcimExecute ]
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

// =========================新医嘱菜单权限分配==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询菜单类型
/// IN  : 
/// OUT : 
/// TABL: websys.ExtMenu
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryMenuType","menuTreeRoot","1")
Query QryMenuType(parentNode, groupid) As %Query(ROWSPEC = "id,code,desc,checkflag,showFunc,func")
{
}

ClassMethod QryMenuTypeExecute(ByRef qHandle As %Binary, parentNode, groupid) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i parentNode=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i parentNode="menuTreeRoot" s parentNode=""
	s parentNode = " "_$$ALPHAUP^SSUTIL4(parentNode)	
	s index=0 f  s index = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index)) q:index=""  d
	.s id = 0 f  s id = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index,id)) q:id=""  d
	..s obj = ##class(websys.ExtMenu).%OpenId(id,0)
	..s checkflag=0
	..i $d(^SSU("SSGRP",groupid,"Menu")) d
	...s checkflag=$bit($p(^SSU("SSGRP",groupid,"Menu"),"^",1),id) 
	..;s checkflag=$s(checkflag:"true",1:"false")
	..s code=obj.EMCode
	..s desc=obj.EMText
	..s showFunc=obj.EMDisplayHandler
	..s func=obj.EMHandler
	..d obj.%Close()
	..d OutputRow12
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12    
	set Data=$lb(id,code,desc,checkflag,showFunc,func)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryMenuTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMenuTypeExecute ]
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

ClassMethod QryMenuTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMenuTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// =========================批量修改医嘱费别==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询费别
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryFeeType")
Query QryFeeType(HospId As %String = "") As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryFeeTypeExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s myBMRowid=0 f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",myBMRowid,HospId)="N"
	.s id=myBMRowid
	.s desc=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s code=$p(^PAC("ADMREA",myBMRowid),"^", 1)
	.s SttDate=$p(^PAC("ADMREA",myBMRowid),"^", 3)
	.Q:(SttDate'="")&&(SttDate>+$h)
	.s EndDate=$p(^PAC("ADMREA",myBMRowid),"^", 4)
	.Q:(EndDate'="")&&(EndDate<+$h)
	.d OutputRow14
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow14
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryFeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeeTypeExecute ]
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

ClassMethod QryFeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SaveArcimReplaceBySel(selectTypeStr, para, HospRowId)
{
	n (selectTypeStr,para,HospRowId)
	s rtn=1
	for i=1:1:$l(selectTypeStr,$C(1)) {
		s oneSelectType=$p(selectTypeStr,$C(1),i)
		s atype=$p(oneSelectType,"^",1)
		s cfgId=$p(oneSelectType,"^",2)
		s rtn=..SaveArcimReplace(cfgId,atype,para, HospRowId)
		Q:rtn'=1
	}
	Q rtn
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 医嘱替换保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveArcimReplace("297","CureAppend","1487||1^1482||1","2")
ClassMethod SaveArcimReplace(cfgId = "", atype, para, HospRowId)
{
	n (cfgId,atype,para,HospRowId)
	s ^TEMP("QPH",11)=cfgId_"!"_atype_"!"_para_"!"_HospRowId
	s mRtn=1,flag=0
	q:atype="" mRtn
	TS
	s ch28=$C(28)
	s ch4=$C(4)
	s ch1=$C(1)
	s fromArcim=$p(para,"^",1)
	s toArcim=$p(para,"^",2)
	
	s len=$l(atype,"^")
	f ii=1:1:len {
		continue:mRtn'=1
		s cType=$p(atype,"^",ii)
		continue:(cType="")
		i (cType="ARCOS") {
			i cfgId'="" {
				s arcos=$p(cfgId,"||",1),datesub=$p(cfgId,"||",2)
				d UpdateArcos
			}else{
				s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:(arcos="")  d
				.s FavRowId=$o(^DHCFavItems(0,"ItemRowid",arcos,""))
				.Q:FavRowId=""
				.s FavUseHospDr=$p(^DHCFavItems(FavRowId),"^",11)
				.Q:FavUseHospDr'=HospRowId
				.s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:(datesub="")  d
				..d UpdateArcos
			}
		}elseif (cType["USE"){
			i cfgId'="" {
				s Rowid=cfgId
				d UpdateUSE
				
			}else{
				s curLoc="" f  s curLoc=$O(^DHCDID(0,"Contral","Location",curLoc)) q:curLoc=""  d
				.q:mRtn'=1
				.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","Location",curLoc,Rowid)) q:Rowid=""  d		
				..d UpdateUSE
				continue:(mRtn'=1)
				s curUser="" f  s curUser=$O(^DHCDID(0,"Contral","User",curUser)) q:curUser=""  d
				.s Rowid=0 f  s Rowid=$O(^DHCDID(0,"Contral","User",curUser,Rowid)) q:Rowid=""  d
				..d UpdateUSE
			}
			
		}elseif (cType["TMPL"){
			s result=..SaveOrdTPL(cfgId,atype,para)
			i result=1 s flag=1
			e  s mRtn=result
		}elseif (cType="CureAppend"){
			i cfgId'="" {
				s DDCIAIRowid=cfgId
				d UpdateCureAppend
			}else{
				s DDCIAIRowid=0
			 	for {
			 		s DDCIAIRowid=$O(^DHCDocCureItemSet(DDCIAIRowid))
			 		q:(DDCIAIRowid="")
			 		s LoopDataHospDR=$p(^DHCDocCureItemSet(DDCIAIRowid),"^",12)
			 		continue:(HospRowId'=LoopDataHospDR)
			 		d UpdateCureAppend
			 	}
			}
		}elseif (cType="LabAppend"){
			//检验绑定医嘱规则	
			i cfgId'="" {
				s PlanRowId=cfgId
				d UpdateLabAppend
			}else{
				
				s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.LabBindRuleSetting:QueryLabPlan")
				do rset.Execute(HospRowId)
				s columns = rset.GetColumnCount()
				s row=0
				While (rset.Next()) {
					s PlanRowId=$g(rset.Data("RowID"))
				
					d UpdateLabAppend

				}
			}
		}elseif (cType="SkinAppend"){
			//皮试绑定医嘱规则	
			i cfgId'="" {
				s ActRowid=cfgId
				d UpdateSkinAppend
			}else{
				s ActRowid=0
				for {
					s ActRowid=$O(^OEC("ACT",ActRowid))
					q:(ActRowid="")
					d UpdateSkinAppend
				}
			}
		}elseif (cType="ItemListAppend"){
			//附加医嘱绑定-按医嘱
			i cfgId'="" {
				s ARCIMRowID=cfgId
				d UpdateItemListAppend
			}else{
				s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Items:GetItemList")
				do rset.Execute("","",HospRowId,"")
				While (rset.Next()) {
					s ARCIMRowID=$g(rset.Data("ARCIMRowID"))
					d UpdateItemListAppend
				}
			}
		}elseif (cType="CatListAppend"){
			//附加医嘱绑定-按子类
			i cfgId'="" {
				s ARCICRowId=cfgId
				d UpdateCatListAppend
			}else{
				s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral:FindCatList")
				do rset.Execute("",HospRowId)
				While (rset.Next()) {
					s ARCICRowId=$g(rset.Data("ARCIMRowID"))
					d UpdateCatListAppend
				}
			}
		}elseif (cType="CMPrescTypeLinkFee"){
			//草药录入设置-》处方剂型关联费用
			i cfgId'="" {
				s Code=cfgId
				d UpdateCMPrescTypeLinkFee
			}else{
				s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CMDocConfig:FindCMPrescType")
				do rset.Execute(HospRowId)
				While (rset.Next()) {
					s Code=$g(rset.Data("Code"))
					d UpdateCMPrescTypeLinkFee
				}
			}
		}elseif (cType="ArcWardAppend"){
			//病区绑定医嘱设置
			i cfgId'="" {
				s PACWardDR=cfgId
				d UpdateArcWardAppend
			}else{
				//病区绑定医嘱设置
				&SQL(DECLARE PACWardList CURSOR FOR 
					select LINK_CTLOC_DR INTO :INKCTLOCDR from SQLUser.CT_LocLinkLocation 
					where LINK_ParRef->CTLOC_Hospital_DR=:HospId group by LINK_CTLOC_DR)
				&SQL(OPEN PACWardList)
			 	For  {
					&SQL(FETCH PACWardList)
					QUIT:SQLCODE
					s PACWardDR=$O(^PAWARD(0,"WARD_LocationDR",INKCTLOCDR,0))
					continue:(PACWardDR="")
					d UpdateArcWardAppend
				}
			}
		}
	}
	i (mRtn'=1) {
		tro
		q "-1"	//更新失败
	}
	TC
	
	q:flag=0 "2"	//没找到相关记录
 
	q mRtn
UpdateArcWardAppend
	s queryName=""
	for {
		s queryName=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName))
		Q:queryName=""
		s QueryID=""
		for {
			s QueryID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName,PACWardDR,QueryID))
			Q:QueryID=""
			s ID=""
			for {
				s ID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName,PACWardDR,QueryID,ID))
				Q:ID=""
				s Val=$g(^User.DHCDocInstrArcimWardD(ID))
				s ARCIMDR=$lg(Val,4)
				continue:(fromArcim'=ARCIMDR)
				&sql(update SQLUSER.DHCDoc_InstrArcimWard set AddItem_Arcim_DR=:toArcim where ID=:ID)
		
				s flag=1
				i SQLCODE'=0 s mRtn=SQLCODE
			}
		}
	}

	q
UpdateCMPrescTypeLinkFee
	//关联费用列表
	s CMPrescTypeLinkFeeStr=..%GetConfig1(Code,"CMPrescTypeLinkFee",HospRowId)
	if (CMPrescTypeLinkFeeStr'=""){
		s NewCMPrescTypeLinkFeeStr=""
		for index=1:1:$l(CMPrescTypeLinkFeeStr,"^"){
			s ArcimRowId=$p(CMPrescTypeLinkFeeStr,"^",index)
			s ArcimDesc=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",2)
			if (fromArcim=ArcimRowId){
				s ArcimRowId=toArcim
			}
			s $p(NewCMPrescTypeLinkFeeStr,"^",index)=ArcimRowId
		}
		if (NewCMPrescTypeLinkFeeStr'=CMPrescTypeLinkFeeStr){
			//保存处方类型绑定费用列表
			d ##class(web.DHCDocConfig).SaveConfig1(Code,"CMPrescTypeLinkFee",NewCMPrescTypeLinkFeeStr,HospRowId)
			s flag=1
		}
	}
	q
UpdateCatListAppend
	s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.AppendItemInItemCat:GetAppendItemInItemCat")
	do rset2.Execute(ARCICRowId,HospRowId)
	While (rset2.Next()) {
		s DHCICARowid=$g(rset2.Data("DHCICARowid"))
		s ARCIMRowid=$g(rset2.Data("ARCIMRowid"))
		continue:(fromArcim'=ARCIMRowid)
		&sql(update SQLUSER.DHC_ItmSubCatAdd set DHCICA_AddItm_DR=:toArcim where DHCICA_Rowid=:DHCICARowid)
		
		s flag=1
		i SQLCODE'=0 s mRtn=SQLCODE
	}
		
	q
UpdateItemListAppend
	s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Items:GetAppendItemList")
	do rset2.Execute(ARCIMRowID,HospRowId)
	While (rset2.Next()) {
		s DHCIARowid=$g(rset2.Data("DHCIARowid"))
		s AddItmDR=$g(rset2.Data("AddItmDR"))
		continue:(fromArcim'=AddItmDR)
		&SQL(UPDATE SQLUser.DHC_ItmAdd SET DHCIA_AddItm_DR=:toArcim WHERE DHCIA_Rowid=:DHCIARowid)
		s flag=1
		i SQLCODE'=0 s mRtn=SQLCODE
	}
	q
UpdateSkinAppend
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.SkinTestConfig:GetSkinLinkItem")
	do rset.Execute(ActRowid,HospRowId)
	While (rset.Next()) {
		s ActIARCIMDR=$g(rset.Data("ActIARCIMDR"))
		s SkinAppendRowid=$g(rset.Data("Rowid"))
		continue:(fromArcim'=ActIARCIMDR)
		
		&SQL(UPDATE SQLUser.DHC_OECAction SET ACTI_ARCIM_DR=:toArcim WHERE ACTI_RowId=:SkinAppendRowid)
		s flag=1
		i SQLCODE'=0 s mRtn=SQLCODE
	}
	q
UpdateLabAppend
	s LoopLabPlanBindType=0
	for {
		s LoopLabPlanBindType=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_PlanRowId,LoopLabPlanBindType))
		q:LoopLabPlanBindType=""
		s LabPlanBindType=$replace(LoopLabPlanBindType," ","")
		s rset2=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.LabBindRuleSetting:QueryLabPlanBindOrdFee")
		do rset2.Execute(PlanRowId,LabPlanBindType)
		While (rset2.Next()) {
			s LabPlanBindOrdFeeID=$g(rset2.Data("RowID"))
			s ARCIMDR=$g(rset2.Data("ARCIMDR"))
			continue:(ARCIMDR'=fromArcim)
			&SQL(UPDATE SQLUser.DHCDocLabPlanBindOrdFee SET LabPlanBindArcimDr=:toArcim WHERE ID=:LabPlanBindOrdFeeID)
			s flag=1
			i SQLCODE'=0 s mRtn=SQLCODE
		}
	}
	q
UpdateCureAppend
	s DDCIAIChildSub=0
	for {
 		s DDCIAIChildSub=$O(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
 		q:(DDCIAIChildSub="")
 		s data=$g(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
 		s AppendItemDr=$p(data,"^",1)
 		continue:(AppendItemDr'=fromArcim)
 		s RowID=DDCIAIRowid_"||"_DDCIAIChildSub
 		&SQL(UPDATE SQLUser.DHC_DocCureItemAppendItem SET DDCIAI_ItemMast_Dr=:toArcim WHERE DDCIAI_RowID=:RowID)
		s flag=1
		i SQLCODE'=0 s mRtn=SQLCODE
	}
	
	q
UpdateArcos
	s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:(arcossub="")  d
	.s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
	.q:arcosarcitm'=fromArcim
	.s rowid=arcos_"||"_datesub_"||"_arcossub
	.&SQL(UPDATE SQLUser.ARC_OrdSetDateItem SET ITM_ARCIM_DR=:toArcim WHERE ITM_RowId=:rowid)
	.s flag=1
	.i SQLCODE'=0 s mRtn=SQLCODE
	q
UpdateUSE
	s Data=$g(^DHCDID(Rowid))
	s ARCIMDR=$p(Data,"^",1)
	q:fromArcim'=ARCIMDR
	&SQL(UPDATE SQLUser.DHC_Doc_ItemDefault SET DID_ARCIM_DR=:toArcim WHERE DID_Rowid=:Rowid)
	s flag=1
	i SQLCODE'=0 s mRtn=SQLCODE
	q
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 医嘱模板替换
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPL(5312,"TMPL","1617||1^999||10")
ClassMethod SaveOrdTPL(cfgId = "", atype, para)
{
	n (cfgId,atype,para)
	s mRtn = 1
	s SubCatID=cfgId
	q:(atype'["TMPL")||(cfgId="") mRtn
	s fromArcim = $p(para,"^",1)
	s toArcim = $p(para,"^",2)
	TS
	if SubCatID=""{
		for{
			s SubCatID=$O(^User.ARCOrdFavItemI("IndexItem",SubCatID)) Q:SubCatID=""
			d OneSubCat	
			Q:mRtn'=1
		}
	}else{
		d OneSubCat	
	}
	if mRtn=1 TC
	else  TRO
	Q mRtn
OneSubCat	
	s ItemID=" "_$ZCVT(fromArcim,"U")
	s PartInfo="" for{
		s PartInfo=$O(^User.ARCOrdFavItemI("IndexItem",SubCatID,ItemID,PartInfo)) Q:PartInfo=""
		s ID=0 for{
			s ID=$O(^User.ARCOrdFavItemI("IndexItem",SubCatID,ItemID,PartInfo,ID)) Q:ID=""
			&SQL(UPDATE SQLUser.ARC_OrdFavItem SET ItemID=:toArcim WHERE ID=:ID)
			if SQLCODE{
				s mRtn=-1
				Q
			}
		}
	}
	Q
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 医嘱模板替换
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveOrdTPLOLD()
ClassMethod SaveOrdTPLOLD(cfgId = "", atype, para)
{
	n (cfgId,atype,para)
	s mRtn=1
	q:(atype'["TMPL")||(cfgId="") mRtn
	
	s fromArcim=$p(para,"^",1)
	s toArcim=$p(para,"^",2)
	
	s obj=##Class(websys.Preferences).%OpenId(cfgId)
	s OldData=obj.Data
	s tabLen=$listlength($list(OldData,3))
	s result=""
	f tabidx=1:1:tabLen d
	.s OldDataList=$list($list(OldData,3),tabidx)
	.s tabName=$P(OldDataList,ch1,1)
	.s curLen=$l(OldDataList,ch1)
	.s groupItem=$p(OldDataList,ch1,2,curLen)
	.s groupLen=$length(groupItem,ch1)
	.f groupidx=1:1:groupLen d
	..s ColItem = $p(groupItem,ch1,groupidx)
	..s colName = $p(ColItem,ch28,1)	//面板标题
	..s colName = $tr(colName,",","，")
	..s ColItem = $p(ColItem,ch28,2,$l(ColItem,ch28))
	..;q:$length(ColItem,ch4)=1
	..f k=1:1:$length(ColItem,ch28) d
	...s itemStr = $p(ColItem,ch28,k)
	...s itemType = $p(itemStr,ch4,1)
	...s itemRowid = $p(itemStr,ch4,2)
	...i itemRowid = "undefined" s itemRowid = "",itemType = ""
	...i itemRowid = fromArcim d
	....i itemStrNew = "" s itemStrNew = itemType_ch4_toArcim
	....e  s itemStrNew = itemStrNew_ch28_itemType_ch4_toArcim
}

// =========================导诊单配置==================================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询费别
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryPatGuide","acceptLoc")
Query QryPatGuide(code) As %Query(ROWSPEC = "id,typeDesc,desc")
{
}

ClassMethod QryPatGuideExecute(ByRef qHandle As %Binary, code) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//接受科室位置
	//w ##class(web.DHCDocPatGuideDocumentsPrt).GetConfig("DepLocation","451")
	i code="acceptLoc" d
	.s locId=""
	.f  s locId=$o(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",locId)) q:locId=""  d
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",locId))
	..s id=locId
	..s typeDesc=$p(^CTLOC(locId),"^",2)
	..d OutputRow114
	
	//开单科室位置
	i code="ordLoc" d
	.s locId=""
	.f  s locId=$o(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",locId)) q:locId=""  d
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",locId))
	..s id=locId
	..s typeDesc=$p(^CTLOC(locId),"^",2)
	..d OutputRow114
	
	//标本位置
	i code="bb" d
	.s bbDesc=""
	.f  s bbDesc=$o(^DHCDocConfig("PatGuideDocumentsPrt","Spec",bbDesc)) q:bbDesc=""  d
	..s typeDesc=bbDesc
	..s id=bbDesc
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",bbDesc))
	..d OutputRow114
	
	//医院温馨提示维护
	i code="hospInfo" d
	.s hospId=""
	.f  s hospId=$o(^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",hospId)) q:hospId=""  d
	..s typeDesc=$p(^CT("HOSP",hospId),"^",2)
	..s id=hospId
	..s desc=$g(^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",hospId))
	..d OutputRow114
	
	i code="itemPnt" d
	.s OrdCatID="" f  s OrdCatID=$O(^ARC("IC",0,"OrdCat",OrdCatID)) q:OrdCatID=""  d
	..s ItemCatRowID="" f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	...s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	...q:(ItemCatDesc="")&&(ItemCatRowID=0)
	...q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID))
	...q:$g(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID))'=1
	...s id=OrdCatID_"||"_ItemCatRowID
	...s typeDesc=$p(^OEC("ORCAT",OrdCatID),"^",2)
	...s desc=ItemCatDesc
	...d OutputRow114
	
	i code="ordItem" d
	.s OrdCatID="" f  s OrdCatID=$O(^ARC("IC",0,"OrdCat",OrdCatID)) q:OrdCatID=""  d
	..s ItemCatRowID="" f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	...s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	...q:(ItemCatDesc="")&&(ItemCatRowID=0)
	...q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID))
	...q:$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID))'=1
	...s id=OrdCatID_"||"_ItemCatRowID
	...s typeDesc=$p(^OEC("ORCAT",OrdCatID),"^",2)
	...s desc=ItemCatDesc
	...d OutputRow114
	
	i code="noDispalyOrd" d
	.s OrdCatRowID="" f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	..s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	..q:(OrdCatDesc="")&&(OrdCatRowID=0)
	..q:'$d(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID))
	..q:$g(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID))'=1
	..s typeDesc="医嘱大类"
	..s desc=OrdCatDesc
	..s id=OrdCatRowID
	..d OutputRow114
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow114
	set Data=$lb(id,typeDesc,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryPatGuideFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatGuideExecute ]
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

ClassMethod QryPatGuideClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatGuideExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询维护类型
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmReason
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QryOrdCat","acceptLoc")
Query QryOrdCat(code, para1 = "") As %Query(ROWSPEC = "id,desc,ContactName")
{
}

ClassMethod QryOrdCatExecute(ByRef qHandle As %Binary, code, para1 = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//接受科室位置
	i (code="acceptLoc")||(code="ordLoc") d
	.s rowid=0 f  s rowid=$O(^CTLOC(rowid)) q:rowid=""  d	
	..s id=rowid
	..s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	..s CTDesc=$ZCVT(CTDesc,"U")
	..s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	..s CTContactNameTem=""
	..i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2,$L(CTDesc,"-"))
	..s CTDesc=$TR(CTDesc,"-")
	..s desc=CTDesc
	..s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	..s CTContactName=$ZCVT(CTContactName,"U")
	..s ContactName=CTContactName
	..d DHCDocOut1
	
	i code="bb" {
		i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
		i $d(^DHCLISBSVersion(1)) {
	   	 	s HospitalCode=$g(HospitalCode)
			s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
			i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
			i $l(HospitalDR) {
				s SPECstr=""
				s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
				.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
				.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
				.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
				.s id=SpecimenDR
				.s ContactName=SPECCode_"-"_SPECDesc
				.s desc=SPECDesc
				.d DHCDocOut1
			}
    	}else{
			s SpecRowid=""
			s SpecDesc=""
			f  s SpecRowid=$O(^TTAB("SPEC",SpecRowid)) q:SpecRowid=""  d
			.s SpecDesc=$p(^TTAB("SPEC",SpecRowid),"\",1)
			.q:(SpecDesc="")&&(SpecRowid=0)
			.s id=SpecRowid
			.s ContactName=""
			.s desc=SPECDesc
			.d DHCDocOut1
		}
	}
	
	i (code="itemPnt")||(code="ordItem")||(code="noDispalyOrd-Value") d
	.s OrdCatRowID=""
	.f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	..s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	..q:(OrdCatDesc="")&&(OrdCatRowID=0)
	..s id=OrdCatRowID
	..s desc=OrdCatDesc
	..s ContactName=""
	..d DHCDocOut1
	
	i code="hospInfo" d
	.s HospRowid=""
	.f  s HospRowid=$O(^CT("HOSP",HospRowid)) q:HospRowid=""  d
	..s HospDesc=$p(^CT("HOSP",HospRowid),"^",2)
	..q:(HospDesc="")&&(HospRowid=0)	
	..s id=HospRowid
	..s desc=HospDesc
	..s ContactName=""
	..d DHCDocOut1
	
	i (code="itemPnt-Value")||(code="ordItem-Value") d
	.q:para1=""
	.s ItemCatRowID=""
	.f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",para1,ItemCatRowID)) q:ItemCatRowID=""  d
	..s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	..q:(ItemCatDesc="")&&(ItemCatRowID=0)
	..s id=ItemCatRowID
	..s desc=ItemCatDesc
	..s ContactName=""
	..d DHCDocOut1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCDocOut1
	set Data=$lb(id,desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryOrdCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdCatExecute ]
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

ClassMethod QryOrdCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 保存导诊单配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SavePatGuide()
ClassMethod SavePatGuide(code, id, value)
{
	n (code,id,value)
	s mRtn = 0
	
	i code = "acceptLoc" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",id) = value
	
	i code = "ordLoc" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",id) = value
	
	i code = "bb" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","Spec",id) = value
	
	i code = "itemPnt" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",id) = value
	
	i code = "ordItem" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",id) = value
	
	i code = "noDispalyOrd" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",id) = value
	
	i code = "hospInfo" d
	.s ^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",id) = value
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 删除导诊单配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).DeletePatGuide()
ClassMethod DeletePatGuide(code, id)
{
	n (code,id,value)
	s mRtn = 0
	i id [ "||" s id = $p(id,"||",2)
	i code = "acceptLoc" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",id)
	
	i code = "ordLoc" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",id)
	
	i code = "bb" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","Spec",id)
	
	i code = "itemPnt" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",id)
	
	i code = "ordItem" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",id)
	
	i code = "noDispalyOrd" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",id)
	
	i code = "hospInfo" d
	.k ^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",id)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 设置默认住院证科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SetDefaultIPBookLoc(50,127)
ClassMethod SetDefaultIPBookLoc(OPLoc As %String, IPLoc As %String) As %String
{
	s ^DHCDocConfig("CanCreatBook-Default",OPLoc)=IPLoc
	q:IPLoc="" 0	;取消时不需要执行底下代码
	s CurValue=$g(^DHCDocConfig("CanCreatBook",OPLoc))
	s FinallyValue=""
	s InValue="^"_IPLoc_"^"
	i CurValue="" s FinallyValue=IPLoc
	e  d
	.s CompareValue="^"_CurValue_"^"
	.i CompareValue'[InValue s FinallyValue=CurValue_"^"_IPLoc
	.e  s FinallyValue=CurValue
	
	s ^DHCDocConfig("CanCreatBook",OPLoc)=FinallyValue
	q 0
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 获取默认住院证科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultIPBookLoc()
ClassMethod GetDefaultIPBookLoc(OPLoc As %String) As %String
{
	Q:OPLoc="" ""
	Q $G(^DHCDocConfig("CanCreatBook-Default",OPLoc))
}

// ==医生号别对照============================

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryLoc","")
Query QueryLoc(depname As %String, UserID As %String = "", LogHospId As %String = "") As %Query(ROWSPEC = "name:%String,id:%String,ContactName") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary, depname As %String, UserID As %String = "", LogHospId As %String = "") As %Status
{
	;New repid, ind
	;New CTCode1,CTDesc1
 	Set repid=$I(^CacheTemp)
 	Set depname=$ZCVT(depname,"U")
 	s LogHospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogHospId)
 	s SortType=##class(web.DHCOPRegConfig).GetSpecConfigNode("RegistLocSort",LogHospId)
	s ind=1
	k ^Temp("QueryLocSortable",$j)
	S AdmType="O^E"
	for loop=1:1:$l(AdmType,"^"){
		s aAdmType=$p(AdmType,"^",loop)
		set myrowid=0
		for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType",aAdmType,myrowid)) q:myrowid=""  d
		.s CTCode1=myrowid ;CTCode CTDesc
		.s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
		.s ContactName=$P(^CTLOC(myrowid),"^",43)
		.s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
		.;q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
		.q:((LogHospId'="")&&(##class(DHCDoc.Common.Hospital).GetMultiHospConfigLoc(LogHospId,myrowid)="N"))
		.q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
		.q:$g(CTDesc1)
		.q:($P(^CTLOC(myrowid),"^",14)'="Y")
		.s StartDate=$P(^CTLOC(myrowid),"^",24)
		.s EndDate=$P(^CTLOC(myrowid),"^",25)
		.q:(StartDate'="")&&(StartDate>+$h)
		.q:(EndDate'="")&&(EndDate<+$h)
		.s CTLOCMarkNO=""
		.i SortType'="" s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc",SortType,myrowid)
		.s CTLOCMarkNO=$case($l(CTLOCMarkNO),0:"999",1:"00"_CTLOCMarkNO,2:"0"_CTLOCMarkNO,:CTLOCMarkNO)
		.s Sortable=CTLOCMarkNO_$$ALPHAUP^SSUTIL4(ContactName)
		.s ^Temp("QueryLocSortable",$j,Sortable,myrowid)=CTDesc1_"^"_CTCode1_"^"_ContactName
	}
	
 	Set QHandle=$lb(0,repid,0)
 	d OutPutSortRow
	Quit $$$OK
	
OutPutSortRow
	s l1="" f  s l1=$o(^Temp("QueryLocSortable",$j,l1)) q:l1=""  d
	.s l2="" f  s l2=$o(^Temp("QueryLocSortable",$j,l1,l2)) q:l2=""  d
	..s info=$g(^Temp("QueryLocSortable",$j,l1,l2))
	..s CTDesc1=$p(info,"^",1)
	..s CTCode1=$p(info,"^",2)
	..s ContactName=$p(info,"^",3)
	..d DHCDocOut2
	q

DHCDocOut2
    s CTDesc1=##class(web.DHCOPAdmReg).LocDescFormate(CTDesc1)
	set Data=$lb(CTDesc1,CTCode1,ContactName)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc1,CTCode1)=""
	quit
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 ;New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 医生号别对照
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CommonFunction","QueryLoc","")
Query UFindDHCMarkDoc(depid = "", reg = "", doc = "") As %Query(CONTAINID = 1, ROWSPEC = "Tdepname:%String,Tmarkname:%String,Tdocname:%String,Tdepid:%String,Tmarkid:%String,Tlocid:%String,Tid:%String,isDefault")
{
}

ClassMethod UFindDHCMarkDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod UFindDHCMarkDocExecute(ByRef qHandle As %Binary, depid As %String = "", reg = "", doc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i depid=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s (Tdepnam,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid,isDefault)=""
	&sql(DECLARE PrescCursor CURSOR FOR
		SELECT MarkddepDr,MarkdMarkDr,MarkdDocDr,ID,Markddefault
	  	into :Tdepid,:Tmarkid,:Tlocid,:Tid,:isDefault
 		From SQLUser.DHCMarkDoc
 		where SQLUser.DHCMarkDoc.MarkddepDr=:depid)
	&sql(OPEN PrescCursor)
 	for  &SQL(FETCH PrescCursor) QUIT:SQLCODE  do
 	.s Tmarkname=$P($g(^CTPCP(Tmarkid,1)),"^",2)
 	.s Tdocname=$P($g(^CTPCP(Tlocid,1)),"^",2)
 	.s Tdepname=$P($g(^CTLOC(Tdepid)),"^",2)
 	.i isDefault="" s isDefault=0
 	.q:(reg'="")&&(Tmarkid'=reg)
 	.q:(doc'="")&&(Tlocid'=doc)
 	.d OutputRow3
	&sql(CLOSE PrescCursor)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(Tdepname,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid,isDefault)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
}

ClassMethod UFindDHCMarkDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
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
 Else  {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 插入号别对照
/// IN  : 
/// OUT : 
/// TABL: DHCMarkDoc
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetKssCate("903||1")
ClassMethod insertMarkDoc(rowid As %Library.String = "", depDr As %Library.String = "", markDr As %Library.String = "", docDr As %Library.String = "", isDefault = "", action As %Library.String = "")
{
	n (action,rowid,depDr,markDr,docDr,isDefault)
	s ccode = "",mRtn=0,flag=0
	TS
	if (isDefault=1){
		&SQL(UPDATE SQLUser.DHCMarkDoc set Markddefault="N" WHERE MarkdDocDr=:docDr and MarkddepDr=:depDr)
	}
	i action="add" {
 		&SQL(SELECT id into :ccode FROM SQLUser.DHCMarkDoc 
 			WHERE MarkdMarkDr=:markDr and MarkdDocDr=:docDr and MarkddepDr=:depDr)
		if (ccode'=""){
			TROLLBACK
			Q "-1" ;记录重复
		}
 		&SQL(INSERT INTO SQLUser.DHCMarkDoc(Markddepdr,MarkdMarkDr,MarkdDocDr,Markddefault)
 		values(:depDr,:markDr,:docDr,:isDefault))
 		s mRtn=SQLCODE
	} else {
		s id=""
		f  s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",depDr,id)) q:(id="")||(flag=1)  d
		.q:id=rowid
		.s docid=$lg(^User.DHCMarkDocD(id),2)
		.s regid=$lg(^User.DHCMarkDocD(id),3)
		.s locid=$lg(^User.DHCMarkDocD(id),4)
		.i ((docid=docDr)&&(regid=markDr)&&(locid=depDr)) s flag=1
		if (flag=1){
			TROLLBACK
			Q "-1" ;记录重复
		}		
		&SQL(UPDATE SQLUser.DHCMarkDoc 
			SET MarkdMarkDr=:markDr,MarkdDocDr=:docDr,Markddepdr=:depDr,Markddefault=:isDefault
 			WHERE id=:rowid)
 		s mRtn=SQLCODE
	}
	if (mRtn=0){
		TC
	}
 	q mRtn
}

ClassMethod deleteMarkDoc(rowid As %Library.String = "")
{
	n (rowid)
	&SQL(DELETE from SQLUser.DHCMarkDoc WHERE id=:rowid)
	
	q SQLCODE
}

ClassMethod insertMarkDocMulit(depid As %Library.String = "", markstr As %Library.String = "", docstr As %Library.String = "")
{
	q:((depid="")||(markstr="")||(docstr=""))
	s rtn=""
	for i=1:1:$l(markstr,"^"){
		s MarkDr=$P(markstr,"^",i)
		s insertrtn=..insertMarkDoc("",depid,MarkDr,docstr,"","add")
		if (insertrtn="-1"){
			s MarkDesc=$p($g(^CTPCP(MarkDr,1)),"^",2)
			if rtn="" s rtn=MarkDesc
			else  s rtn=rtn_","_MarkDesc
		}
	}
	if rtn'="" {
		s DocDesc=$p($g(^CTPCP(docstr,1)),"^",2)
		s rtn="医生:"_DocDesc_",号别分别:"_rtn_";号别重复,其他插入成功"
	}else{
		s rtn="插入成功"
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取默认号别
/// IN  : 
/// OUT : 
/// TABL: DHCMarkDoc
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultReg("4634",7)
ClassMethod GetDefaultReg(uid As %Library.String = "", locid As %Library.String = "")
{
	n (uid,locid)
	s mRtn=""
	Q:uid="" mRtn
	s DocID=$P(^SSU("SSUSR",uid),"^",14)
	Q:DocID="" mRtn
	s id="" f  s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",locid,id)) q:(id="")||(mRtn'="")  d
	.s doc=$lg(^User.DHCMarkDocD(id),2)
	.q:doc'=DocID
	.s regid=$lg(^User.DHCMarkDocD(id),3)
	.s locid=$lg(^User.DHCMarkDocD(id),4)
	.s isDefault=$lg(^User.DHCMarkDocD(id),5)
	.i isDefault=1 s mRtn=regid
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取是否住院总签床
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetInZBed(110)
ClassMethod GetInZBed(locid As %Library.String = "")
{
	n (locid)
	s mRtn="N"
	Q:locid="" mRtn
	S mRtn=$p(^CTLOC(locid),"^",87)
	i mRtn="" s mRtn="N"
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取住院证科室
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).GetZYZLoc(110)
ClassMethod GetZYZLoc(bookid As %Library.String = "")
{
	n (bookid)
	s mRtn=""
	Q:bookid="" mRtn
	s mRtn=$p(^DHCDocIPBK(bookid),"^",13) ;科室
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 是否需要显示签床
/// IN  : 
/// OUT : Y/N
/// TABL: CT_LOC
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).IfNeedSignBed(29)
ClassMethod IfNeedSignBed(bookid As %Library.String = "")
{
	n (bookid)
	s mRtn=0
	s locid=..GetZYZLoc(bookid) 
	s mRtn=..GetInZBed(locid)
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 保存“新医嘱菜单权限分配”菜单
/// IN  : id + "!" + desc + "!" + func + "!" + showFunc + "!" + check ;
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.CommonFunction).SaveMenuGroupSetting(29)
ClassMethod SaveMenuGroupSetting(codes, groupid)
{
	q:groupid="" 100
	q:codes="" 100
	s len=$l(codes,"^")
	s gobj = ##class(User.SSExtMeunGroup).%OpenId(groupid)
	q:'$IsObject(gobj)
	s error=0,EMParentId=""
	s menubit=gobj.DHCEMGExtMenu
	f j=1:1:len d
	.s id=$p($p(codes,"^",j),"!",1)
	.s desc = $p($p(codes,"^",j),"!",2)
	.s func = $p($p(codes,"^",j),"!",3)
	.s showFunc = $p($p(codes,"^",j),"!",4)
	.s check = $p($p(codes,"^",j),"!",5)
	.;q:code=""
	.;s id = $O(^websys.ExtMenuI("EMCodeMenu"," "_$$ALPHAUP^SSUTIL4(code),""))
	.q:id=""
	.s menuOBJ=##class(websys.ExtMenu).%OpenId(id)
	.q:'$IsObject(menuOBJ)
	.s menuOBJ.EMText=desc
	.s menuOBJ.EMDisplayHandler=showFunc
	.s menuOBJ.EMHandler=func
	.s EMParentNode=menuOBJ.EMParentCode
	.s parentcode = " "_$$ALPHAUP^SSUTIL4(EMParentNode)
	.s EMParentId=$o(^websys.ExtMenuI("EMCodeMenu",parentcode,""))
	.s sc=menuOBJ.%Save()
	.i $System.Status.IsError(sc) s error="-100" 
	.q:error'=0
	.d menuOBJ.%Close()   
	.s $bit(menubit,id)=check
	if (EMParentId'=""){
		s $bit(menubit,EMParentId)=1
	}
	s gobj.DHCEMGExtMenu = menubit
	d gobj.%Save()
	d gobj.%Close()
	s gobj=""	
	q 0
}

/// 判断出诊号别是否在用户表(SS_User)中有数据，如果有数据说明是医生
/// 检测是否有这个科室下的把此医生做为号别是否有医生号别对照
/// 如果没有记录或者没有此医生对此医生的记录 则自动插入医生号别对照记录
/// w ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertMarkDoc()
ClassMethod AutoInsertMarkDoc(ResRowId As %String) As %String
{
	s rtn=0
	s MarkId=$p(^RB("RES",ResRowId),"^",2)
	s LocId=$p(^RB("RES",ResRowId),"^",1)
	s UserRowId=$o(^SSU("SSUSR",0,"CTPCP",MarkId,""))
	if (UserRowId'="") {
		&SQL(select * from SQLUser.DHCMarkDoc where MarkdDocDr=:MarkId and MarkdMarkDr=:MarkId and MarkddepDr=:LocId)
		if (SQLCODE=100) {
			s rtn=..insertMarkDoc("",LocId,MarkId,MarkId,"N","add")
		}
	}
	Q rtn
}

/// 判断这个科室下的此号别是否有诊区号别对照
/// 如果没有诊区号别对照且能通过科室在诊区科室对照下找到唯一诊区
/// 则自动插入此诊区与号别的对照关系
/// w ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertDepMark()
ClassMethod AutoInsertDepMark(ResRowId As %String) As %String
{
	s rtn=0
	s MarkId=$p(^RB("RES",ResRowId),"^",2)
	s LocId=$p(^RB("RES",ResRowId),"^",1)
	if '($d(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_LocId,MarkId))) {
		s BorDepCount=0
		s BorDepId=0
		for {
			s BorDepId=$o(^User.DHCExaBorDepI("BordDepDrIndex",LocId,BorDepId)) Q:BorDepId=""
			s BorId=$lg(^User.DHCExaBorDepD(BorDepId),6)
			continue:'$d(^User.DHCExaBoroughD(BorId))
			s BorDepCount=BorDepCount+1
		}
		if (BorDepCount=1) {
			s rtn=##class(web.DHCExaBorough).insertDepMark("","",BorId,LocId,MarkId,"N","Y","N")
		}
	}
	Q rtn
}

ClassMethod SaveConfig1(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
	q:(Node="")||(Node1="") 0
	s ^DHCDocConfig(Node,Node1)=NodeValue
	q 0
}

ClassMethod GetConfigNode1(Node As %String, Node1 As %String) As %String
{
	q:(Node="")||(Node1="") 0
	q $g(^DHCDocConfig(Node,Node1))
}

}
