Class DHCDoc.DHCDocConfig.DocConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询用法      
Query Find(value As %String, HospId As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","Find","CNMedItemPhSpecInstr",10)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=##class(web.DHCDocConfig).GetConfigNodeNew2(value,HospId) //$g(^DHCDocConfig(value))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$p(Data,$c(1),1)
    .s Desc=$p(Data,$c(1),2)
	.Do OutputRowFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	set Data=$lb($g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询使用频率
Query FindCHNPHFrequence(HospId As %String = "") As %Query(ROWSPEC = "CPFRowid:%String,CPFFrequence:%String,CPFFactor:%String,CPFDefault:%String")
{
}

ClassMethod FindCHNPHFrequenceExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCHNPHFrequence")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s CPFRowid=0
    f  s CPFRowid=$o(^DHCCHNPHFre(CPFRowid)) q:CPFRowid=""  d
    .s CPFFrequenceDR=$p(^DHCCHNPHFre(CPFRowid),"^",1)
    .Q:CPFFrequenceDR=""
    .Q:'$d(^PHCFR(CPFFrequenceDR))
    .s CPFFrequence=$p(^PHCFR(CPFFrequenceDR),"^",3)
    .s CPFFactor=$p(^DHCCHNPHFre(CPFRowid),"^",2)
    .s CPFDefault=$p(^DHCCHNPHFre(CPFRowid),"^",3)
    .s CPFHospDr=$p(^DHCCHNPHFre(CPFRowid),"^",4)
    .Q:CPFHospDr'=HospId
	.Do OutputRowFindCHNPHFrequence
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCHNPHFrequence
	set Data=$lb($g(CPFRowid),$g(CPFFrequence),$g(CPFFactor),$g(CPFDefault))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCHNPHFrequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCHNPHFrequenceExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCHNPHFrequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCHNPHFrequenceExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 保存使用频率
ClassMethod saveFrequence(FreqDr As %String, Factor As %String, Default As %String, HospId As %String = "")
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s find=0
	s CPFRowid=0
    for {
	    s CPFRowid=$o(^DHCCHNPHFre(CPFRowid)) q:(CPFRowid="")||(find=1) 
	    s CPFFrequenceDR=$p(^DHCCHNPHFre(CPFRowid),"^",1)
	    continue:CPFFrequenceDR'=FreqDr
	    s CPFHospDr=$p(^DHCCHNPHFre(CPFRowid),"^",4)
	    continue:CPFHospDr'=HospId
	    s find=1
    }
    Q:find=1 "-1"
	k PLIST
	s PLIST(2)=FreqDr
	s PLIST(3)=Factor
	s PLIST(4)=Default
	s PLIST(5)=HospId //CPFHospDR
	&sql(insert into SQLUser.DHC_CHNPHFrequence values PLIST())
	q SQLCODE
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 删除使用频率
ClassMethod deleteFrequence(Rowid As %String)
{
	&sql(delete from SQLUser.DHC_CHNPHFrequence where CPF_Rowid=:Rowid)
    q SQLCODE
}

ClassMethod test()
{
	zn "dhc-data"
	s rtn=0
	
	i rtn=0  zn "dhc-app" quit -1
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询所有医嘱项目
Query FindDefaultItem(value As %String = "", Desc As %String = "", MaxFindNum As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDefaultItemExecute(ByRef qHandle As %Binary, value As %String = "", Desc As %String = "", MaxFindNum As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindDefaultItem","","ycx","")
	s:(value="")||($ZCVT(value,"U")="NULL") value="NULL"
	s Desc=$ZCVT(Desc,"U")
	s FindTopNum=100000000
	if MaxFindNum'="" s FindTopNum=+MaxFindNum
	s FindNUm=0
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (value="NULL")&&(Desc=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s count=0
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d rs1.Execute(Desc,%session.Data("LOGON.GROUPID"),"","","","","","","","",%session.Data("LOGON.USERID"),"","",""_$C(3)_HospId,"","^1")
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		continue:ArcimID=""
		s ARCIMType=rs1.GetData(4)
		continue:ARCIMType="ARCOS"
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s selected=0
		i ArcimID=$g(^DHCDocConfig(value)) s selected=1
		d OutputRowFindDefaultItem
		s count=count+1
		if (count>FindTopNum)&&(FindTopNum'=0){
			q
		}
	}	
	
	/*kill ^||TempARCIMList($j)
	s ALIASText=$e(Desc,1,$l(Desc)-1)
	f  s ALIASText=$o(^ARC("ALIAS",0,"DescVI",ALIASText_" ")) q:((ALIASText="")||(FindNUm>=FindTopNum))  d
	.q:$e(ALIASText,1,$l(Desc))'=$e(Desc,1,$l(Desc))
	.s ALIASDesc=""
	.f  s ALIASDesc=$o(^ARC("ALIAS",0,"DescVI",ALIASText,ALIASDesc))  q:((ALIASDesc="")||(FindNUm>=FindTopNum))  d
	..s ALIASRowId=0
	..f  s ALIASRowId=$o(^ARC("ALIAS",0,"DescVI",ALIASText,ALIASDesc,ALIASRowId)) q:((ALIASRowId="")||(FindNUm>=FindTopNum))  d
	...s ArcimID=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
	...Q:ArcimID=""
	...Q:$d(^||TempARCIMList($j,ArcimID))
	...q:'$d(^ARCIM(+ArcimID,$p(ArcimID,"||",2)))
	...i ArcimID=..%GetConfig(value,HospId) s selected=1 //$g(^DHCDocConfig(value))
	...e  s selected=0
	...s ArcimDesc=$P($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	...s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
	...s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
	...q:ArcimDesc=""
	...s ^||TempARCIMList($j,ArcimID)=1
	...s FindNUm=FindNUm+1
	...d OutputRowFindDefaultItem
	kill ^||TempARCIMList($j)*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDefaultItem
	Set Data=$lb(ArcimID,ArcimDesc,selected)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindDefaultItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDefaultItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDefaultItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDefaultItemExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询所有草药用法列表
Query FindInstrList(value As %String, HospId As %String = "") As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrListExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindInstrList","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s KeyValue=..GetKeyValue(value,HospId)    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
	.s PHCINActiveFlag=$p(str,"^",4)
	.Q:PHCINActiveFlag="N"
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i ("^"_KeyValue_"^")[("^"_InstrRowID_"^") s selected=1
	.Do OutputRowFindInstrList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrList
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrListExecute ]
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

ClassMethod getDefaultDataJson(DOMConinfo As %String, Coninfo As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s JsonObj=[]
	s JsonObj=[]
	for i=1:1:$l(Coninfo,"^") {
		s Node=$p(Coninfo,"^",i)
		if (HospCodeNode'="") {
			s value=$g(^DHCDocConfig(HospCodeNode,Node))
		}else{
			s value=$g(^DHCDocConfig(Node))
		}
		s JsonData={}
		do JsonData.%Set("id",$p(DOMConinfo,"^",i))
		do JsonData.%Set("Node",Node)
		do JsonData.%Set("value",value)
		do JsonObj.%Push(JsonData,"")
	}
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	//s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

/// w ##class(DHCDoc.DHCDocConfig.DocConfig).getDefaultDataJson("OPLimitType",2)
ClassMethod getDefaultDataJson1(Coninfo As %String, HospId As %String = "", RetFlag = "") As %String
{
	if ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s JsonObj={}
	for i=1:1:$l(Coninfo,"^") {
		s Node=$p(Coninfo,"^",i)
		if (HospCodeNode'="") {
			s value=$g(^DHCDocConfig(HospCodeNode,Node))
		}else{
			s value=$g(^DHCDocConfig(Node))
		}
		do JsonObj.%Set(Node,value)
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(Stream)
	Q:RetFlag="Y" Stream
	do Stream.OutputToDevice()
	Q ""
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 返回设置值 
ClassMethod getDefaultData(value As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocConfig(HospCodeNode,value))
	}else{
		s rtn=$g(^DHCDocConfig(value))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod getOrdBillCheckData(node As %String, value As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocOrderBillConfig(HospCodeNode,node,value))
	}else{
		s rtn=$g(^DHCDocOrderBillConfig(node,value))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod saveOrdBillCheckData(Coninfo As %String, node As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d 
	..s node1=$p(evNoteinfo,$C(1),1)
	..s value=$p(evNoteinfo,$C(1),2)
	..i HospCodeNode'="" s ^DHCDocOrderBillConfig(HospCodeNode,node,node1)=value
	..e  s ^DHCDocOrderBillConfig(node,node1)=value
	q 0
}

ClassMethod getLabSttTime(value As %String, HospId As %String) As %String
{
	//if ($g(^DHCDocConfig("UseHospSepLabConfig"))=1)&&(HospId="") s HospId=$g(^DHCDocConfig("MainHospital"))
	if (HospId=""){
		s rtn=$g(^DHCDocConfig(value))
	}else{
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocConfig(HospCodeNode,value))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod GetLabOtherCheck(Node As %String, HospId As %String) As %String
{
	//if ($g(^DHCDocConfig("UseHospSepLabConfig"))=1)&&(HospId="") s HospId=$g(^DHCDocConfig("MainHospital"))
	if (HospId=""){
		s str=$g(^DHCDocConfig(Node))
	}else{
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocConfig(HospCodeNode,Node))
	}
	if (str="") s str=0
	q str
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询草药医嘱可用优先级
Query FindCNMedPrior(value As %String, HospId As %String = "") As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedPriorExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedPrior","CNMedPrior")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.///限制医嘱类型只能选择【取药医嘱】、【出院带药】、临时医嘱，防止更改导致数据问题
 	.q:(OECPRDesc'="取药医嘱")&&(OECPRDesc'="出院带药")&&(OECPRDesc'="临时医嘱")
	.i OECPRDesc["临时医嘱" s OECPRDesc=OECPRDesc_"（仅限门急诊使用）"
 	.s CNMedPriorListStr=..%GetConfig(value,HospId) //$g(^DHCDocConfig(value))
 	.s selected=0
 	.s:("^"_CNMedPriorListStr_"^")[("^"_OECPRRowId_"^") selected=1
	.Do OutputRowFindCNMedPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedPriorExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询账单大类
Query FindARCBillGrp(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCBGRowId:%String,ARCBGDesc:%String,selected:%Boolean")
{
}

ClassMethod FindARCBillGrpExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindARCBillGrp","CHNPHBillSub")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCBGRowId=0
 	f  s ARCBGRowId=$o(^ARCBG(ARCBGRowId)) q:ARCBGRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_BillGrp",ARCBGRowId,HospId)="N"
 	.s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2)
 	.q:ARCBGDesc=""
 	.s ARCBillGrpStr=..%GetConfig(value,HospId) //$g(^DHCDocConfig(value))
 	.s selected=0
 	.s:ARCBGRowId=$p(ARCBillGrpStr,"||") selected=1
 	.//s:("^"_ARCBillGrpStr_"^")[("^"_ARCBGRowId_"^") selected=1
	.Do OutputRowFindARCBillGrp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindARCBillGrp
	set Data=$lb($g(ARCBGRowId),$g(ARCBGDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindARCBillGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCBillGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindARCBillGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCBillGrpExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询账单子类
Query FindARCBillSub(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCSGRowId:%String,ARCSGDesc:%String,selected:%Boolean")
{
}

ClassMethod FindARCBillSubExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindARCBillSub","CHNPHBillSub")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCBillGrpStr=..%GetConfig(value,HospId) //$g(^DHCDocConfig(value))
    s ARCBGRowId=0
 	f  s ARCBGRowId=$o(^ARCBG(ARCBGRowId)) q:ARCBGRowId=""  d
 	.q:(ARCBGRowId'=$p(ARCBillGrpStr,"||"))&&(+ARCBillGrpStr'=0)
 	.s ARCSGChildSub=0
 	.f  s ARCSGChildSub=$o(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub)) q:ARCSGChildSub=""  d
 	..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_BillSub",ARCBGRowId_"||"_ARCSGChildSub,HospId)="N"
 	..s ARCSGDesc=$p($g(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub)),"^",2)
 	..q:ARCSGDesc=""
 	..s selected=0
 	..s:(ARCBGRowId_"||"_ARCSGChildSub)=ARCBillGrpStr selected=1
 	..s ARCSGRowId=ARCBGRowId_"||"_ARCSGChildSub
	..Do OutputRowFindARCBillSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindARCBillSub
	set Data=$lb($g(ARCSGRowId),$g(ARCSGDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindARCBillSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCBillSubExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindARCBillSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCBillSubExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询包装方式
Query FindCNMedCookMode(value As %String, HospId As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,ArcOrd:%String,ActiveFlag:%String,ArcOrdID:%String")
{
}

ClassMethod FindCNMedCookModeExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	//"02"_$c(1)_"代煎"_$c(1)_"0"_$c(1)_"1^01"_$c(1)_"自煎"_$c(1)_"0"_$c(1)_"1^03"_$c(1)_"加工膏方"_$c(1)_"0"_$c(1)_"1"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookMode","CNMedCookMode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=##class(web.DHCDocConfig).GetConfigNodeNew2(value,HospId) //$g(^DHCDocConfig(value))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$p(Data,$c(1),1)
    .s Desc=$p(Data,$c(1),2)
    .s ArcOrdID=$p(Data,$c(1),3)
    .s:ArcOrdID=0 ArcOrdID=""
    .s ArcOrd=""
    .i ArcOrdID'="" s ArcOrd=$p(^ARCOS(ArcOrdID),"^",2)
    .s ActiveFlag=$p(Data,$c(1),4)
    .i ActiveFlag="1" s ActiveFlag="Y"
    .else  s ActiveFlag="N"
	.Do OutputRowFindCNMedCookMode
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookMode
	set Data=$lb($g(Code),$g(Desc),$g(ArcOrd),$g(ActiveFlag),$g(ArcOrdID))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询可用医嘱套列表
Query FindArcOrd(HospId As %String = "") As %Query(ROWSPEC = "ARCOSRowId:%String,ARCOSDesc:%String")
{
}

ClassMethod FindArcOrdExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindArcOrd")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
    &SQL(DECLARE EmpCursor CURSOR FOR
	 Select ARCOS_Rowid,ARCOS_Code,ARCOS_Desc into :ARCOSRowId,:ARCOSCode,:ARCOSDesc
	 From SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems 
	 Where 
	 SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid and SQLUser.DHC_UserFavItems.Fav_UseHosp_Dr=:HospId
	 order by ARCOS_Rowid desc) 
	 &SQL(OPEN EmpCursor)
	 for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
	 .s str=$g(^ARCOS(ARCOSRowId))
 	.s ARCOSEffDateFrom=$p(str,"^",15)
 	.s ARCOSEffDateTo=$p(str,"^",16)
 	.q:(ARCOSEffDateFrom>+$h)&&(ARCOSEffDateFrom'="")
 	.q:(ARCOSEffDateTo'="")&&(ARCOSEffDateTo<=..%SysDate())
 	.s ArcAlias=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,""))
	.s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	.s:ArcAlias'="" ARCOSDesc=ArcAlias_"-"_ARCOSDesc
	.Do OutputRowFindArcOrd
 	/*s ARCOSRowId=0
 	f  s ARCOSRowId=$o(^ARCOS(ARCOSRowId)) q:ARCOSRowId=""  d
 	.s str=$g(^ARCOS(ARCOSRowId))
 	.s ARCOSDesc=$p(str,"^",2)
 	.s ARCOSEffDateFrom=$p(str,"^",15)
 	.s ARCOSEffDateTo=$p(str,"^",16)
 	.q:(ARCOSEffDateFrom>+$h)&&(ARCOSEffDateFrom'="")
 	.q:(ARCOSEffDateTo'="")&&(ARCOSEffDateTo<=..%SysDate())
 	.s ArcAlias=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,""))
	.s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	.s:ArcAlias'="" ARCOSDesc=ArcAlias_"-"_ARCOSDesc
	.Do OutputRowFindArcOrd*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcOrd
	set Data=$lb($g(ARCOSRowId),$g(ARCOSDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcOrdExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询接受科室(接收科室可跨院,故不进行院区过滤)
Query FindDep(value As %String, desc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary, value As %String, desc As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCDesc=$p(str,"^",2)
 	.//s CTLocHospDr=$p(str,"^",22)
 	.//Q:(CTLocHospDr'=HospId)&&(HospId'="")
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
 	.Q:(desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(CTLOCRowID,desc))
	.q:($P(^CTLOC(CTLOCRowID),"^",14)'="Y")
 	.s selected=0
 	.i value'="" d
 	..s:("^"_..%GetConfig(value,HospId)_"^")[("^"_CTLOCRowID_"^") selected=1 //$g(^DHCDocConfig(value))
	.Do OutputRowFindDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 根据就诊类型查询对应的药物使用方式
Query FindAdmTypeInstr(AdmType As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindAdmTypeInstrExecute(ByRef qHandle As %Binary, AdmType As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindAdmTypeInstr","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i AdmType'="" d
	..s:("^"_$g(^DHCDocConfig("AdmTypeInstr",AdmType))_"^")[("^"_InstrRowID_"^") selected=1
	.Do OutputRowFindAdmTypeInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAdmTypeInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAdmTypeInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmTypeInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmTypeInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmTypeInstrExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 根据子类查询药物加工方式
Query FindCNMedCookModeByCat(CatDr As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedCookModeByCatExecute(ByRef qHandle As %Binary, CatDr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookModeByCat","")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s Str=$g(^DHCDocConfig("CNMedCookMode"))
 	F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$tr($p(Data,$c(1),1),0,"")
    .s Desc=$p(Data,$c(1),2)
	.s selected=0
	.i CatDr'="" d
	..s:("^"_$g(^DHCDocConfig("ItemCatCookMode",CatDr))_"^")[("^"_Code_"^") selected=1
	.Do OutputRowFindCNMedCookModeByCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookModeByCat
	set Data=$lb($g(Code),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeByCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeByCatExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询颗粒设置用法
Query FindInstrByKL(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindInstrByKL","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",1)
 	.s PHCINDesc2=$p(str,"^",3)
 	.q:PHCINDesc2'="饮片"
	.s selected=0
	.i InstrRowID=$g(^DHCDocConfig("CNMedNormKL",value,"InStr")) s selected=1
	.Do OutputRowFindInstrByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrByKL
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrByKLExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询颗粒加工方式
Query FindCNMedCookModeByKL(value As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedCookModeByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	//"02"_$c(1)_"代煎"_$c(1)_"0"_$c(1)_"1^01"_$c(1)_"自煎"_$c(1)_"0"_$c(1)_"1^03"_$c(1)_"加工膏方"_$c(1)_"0"_$c(1)_"1"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedCookModeByKL","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s Str=$g(^DHCDocConfig("CNMedCookMode"))
    F i=1:1:$l(Str,"^") d
    .q:Str=""
    .s Data=$p(Str,"^",i)
    .s Code=$tr($p(Data,$c(1),1),0,"")
    .s Desc=$p(Data,$c(1),2)
    .s selected=0
    .i Code=$g(^DHCDocConfig("CNMedNormKL",value,"Cookmode")) s selected=1
	.Do OutputRowFindCNMedCookModeByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedCookModeByKL
	set Data=$lb($g(Code),$g(Desc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedCookModeByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedCookModeByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedCookModeByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedCookModeByKLExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询颗粒对应接受科室
Query FindCNMedNormKLRefLoc(value As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCNMedNormKLRefLocExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedNormKLRefLoc","1")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s selected=0
 	.s:$d(^DHCDocConfig("CNMedNormKL",value,CTLOCRowID)) selected=1
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindCNMedNormKLRefLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCNMedNormKLRefLoc
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedNormKLRefLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedNormKLRefLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedNormKLRefLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedNormKLRefLocExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 查询颗粒对应的子类
Query FindCatListByKL(value As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListByKLExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCatListByKL","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.i value'="" d
	..q:'$d(^DHCDocConfig("CNMedNormKL"))
 	..s Loc=$o(^DHCDocConfig("CNMedNormKL",value,""))
 	..s FrequencedItemCatListStr=$g(^DHCDocConfig("CNMedNormKL",value,Loc))
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatListByKL
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListByKL
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListByKLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListByKLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListByKLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListByKLExecute ]
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

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 保存普通 颗粒设置
ClassMethod saveCNMedNormKL(Input As %String) As %String
{
	//CNMedNormKL As %String,InStr As %String,Cookmode As %String,RefLoc As %String,ItemCatStr As %String
	Set CNMedNormKL=$p(Input,"$",1)
	Set ItemCatStr=$p(Input,"$",5)
	Set RefLoc=$p(Input,"$",4)
	Set InStr=$p(Input,"$",2)
	Set Cookmode=$p(Input,"$",3)
	Quit:RefLoc=""
	k ^DHCDocConfig("CNMedNormKL",CNMedNormKL)
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,RefLoc)=ItemCatStr
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,"InStr")=InStr
	Set ^DHCDocConfig("CNMedNormKL",CNMedNormKL,"Cookmode")=Cookmode
	q 0
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->草药录入设置 保存子类对应药物加工方式
ClassMethod saveItemCatCookMode(Input As %String) As %String
{
	s Node=$p(Input,"$",1)
	s Node1=$p(Input,"$",2)
	s NodeValue=$p(Input,"$",3)
	Set ^DHCDocConfig(Node,Node1)=NodeValue
	q 0
}

/// creator:lxz
/// desc:医生站设置程序->草药录入设置 医嘱单插入的长期医嘱
Query FindCNMedLongOrder(HospId As %String = "") As %Query(ROWSPEC = "IDOut:%String,DescOut:%String,ArcimID:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedLongOrder")
ClassMethod FindCNMedLongOrderExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s IDOut=0
	    f  s IDOut=$o(^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",IDOut)) q:IDOut=""  d
	    .s ArcimID=$G(^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",IDOut))
	    .s ArcimDesc=""
	    .s:ArcimID'="" ArcimDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
	   	.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
		.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
		.q:ArcimDesc=""
		.Do OutputFindCNMedLongOrder
	}else{
		s IDOut=0
	    f  s IDOut=$o(^DHCDocConfig("CNMedAddLongOrder",IDOut)) q:IDOut=""  d
	    .s ArcimID=$G(^DHCDocConfig("CNMedAddLongOrder",IDOut))
	    .s ArcimDesc=""
	    .s:ArcimID'="" ArcimDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
	   	.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
		.s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
		.q:ArcimDesc=""
		.Do OutputFindCNMedLongOrder
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFindCNMedLongOrder
	set Data=$lb($g(IDOut),$g(ArcimDesc),ArcimID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCNMedLongOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCNMedLongOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCNMedLongOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCNMedLongOrderExecute ]
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

/// creator:lxz
/// desc:保存对应医嘱单插入的长期医嘱
ClassMethod saveCNMedAddLongOrder(ArcimID As %String, HospId As %String = "") As %String
{
	Q:ArcimID="" "-1"
	Q:(+ArcimID=0)||('$d(^ARCIM(+ArcimID,$p(ArcimID,"||",2)))) "-1"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ID=$I(^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder"))
		s ^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",ID)=ArcimID
	}else{
		s ID=$I(^DHCDocConfig("CNMedAddLongOrder"))
		s ^DHCDocConfig("CNMedAddLongOrder",ID)=ArcimID
	}
	q 0
}

/// creator:lxz
/// desc:医生站设置程序->草药录入设置 删除应医嘱单插入的长期医嘱
ClassMethod deleteCNMedAddLongOrder(Rowid As %String, HospId As %String = "") As %String
{
	q:Rowid="" "-1"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",Rowid)
	}else{
		k ^DHCDocConfig("CNMedAddLongOrder",Rowid)
	}
	q 0
}

/// lxz 返回给草药录入界面使用 需要增加的长期医嘱
/// w ##class(DHCDoc.DHCDocConfig.DocConfig).FindAddLongArcim()
ClassMethod FindAddLongArcim(LogonHospDr As %String = "") As %String
{
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s HospCodeNode="HospDr_"_LogonHospDr
	s ArcimStr=""
	s IDOut=0
    f  s IDOut=$o(^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",IDOut)) q:IDOut=""  d
    .s ArcimID=$G(^DHCDocConfig(HospCodeNode,"CNMedAddLongOrder",IDOut))
    .q:+ArcimID=0
    .s ArcimDesc=""
    .s:ArcimID'="" ArcimDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
    .Q:ArcimDesc=""
    .if ArcimStr="" s ArcimStr=ArcimID_"^"_ArcimDesc
    .else  s ArcimStr=ArcimStr_"!"_ArcimID_"^"_ArcimDesc
    q ArcimStr
}

ClassMethod GetKeyValue(key As %String, HospId As %String = "") As %String [ ProcedureBlock = 0 ]
{
	n (key,HospId,%session)
	q:key="" ""
	s IllegalExpress=0
	i ($d(%session))||(HospId'="") {
		if (HospId="") {
			s HospId=%session.Get("LOGON.HOSPID")
		}
		s HospCodeNode="HospDr_"_HospId
		s Expression="KeyValue=$G(^DHCDocConfig("_""""_HospCodeNode_""""
		for i=1:1:$L(key,",") {
			s Expression=Expression_","""_$P(key,",",i)_""""
			if ($P(key,",",i)=""){
				s IllegalExpress=1
			}
		}
	}else{
		s Expression="KeyValue=$G(^DHCDocConfig("
		for i=1:1:$L(key,",") {
			if (i=1){
				s Expression=Expression_""""_$P(key,",",i)_""""
			}else{
				s Expression=Expression_","""_$P(key,",",i)_""""
			}
			if ($P(key,",",i)=""){
				s IllegalExpress=1
			}
		}
	}
	
	if (IllegalExpress=1){
		q ""
	}
	s Expression=Expression_"))"
	s @Expression
	q KeyValue
}

/// 保存煎药方式
/// ^DHCDocConfig("CookMode",1)=Code_"^"_Desc
/// ^DHCDocConfig("CookMode",1,"RecLoc",1)=Type_"^"_ID
/// ^DHCDocConfig("CookMode",1,"Arc",1)=ARCIM
ClassMethod SaveCookMode(Str, HospId As %String = "")
{
	q:Str="" ""
	s i=1
	for {
		s OneStr=$P(Str,"^",i)
		q:OneStr=""
		s i=i+1
		s RowID=$P(OneStr,$C(1),1)
		s Code=$P(OneStr,$C(1),2)
		s Desc=$P(OneStr,$C(1),3)
		if (RowID=""){
			s rtn=##class(web.DHCDocConfig).SaveConfig3("CookMode","",Code_"^"_Desc,HospId)
		}else{
			s rtn=##class(web.DHCDocConfig).SaveConfig1("CookMode",RowID,Code_"^"_Desc,HospId)
		}
	}
	q 0
}

ClassMethod DelectCookMode(RowID, HospId As %String = "")
{
	q:RowID="" 0
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"CookMode",RowID)
	}else{
		k ^DHCDocConfig("CookMode",RowID)
	}
	q 0
}

Query FindCookMode(value, HospId As %String = "", InstrRowID = "") As %Query(ROWSPEC = "RowID:%String, Code:%String,Desc:%String,RecLoc:%String")
{
}

ClassMethod FindCookModeExecute(ByRef qHandle As %Binary, value, HospId As %String = "", InstrRowID = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCookMode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ^tempqujian("FindCookMode")=value
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s RowID="0"
	    for {
		    s RowID=$O(^DHCDocConfig(HospCodeNode,"CookMode",RowID))
		    q:RowID=""
			if InstrRowID'=""{
				s CookModeInstr=..GetCookModeInstr(RowID, HospId)
				continue:(CookModeInstr'="")&&(("^"_CookModeInstr_"^")'[("^"_InstrRowID_"^"))
			}
			continue:($G(^DHCDocConfig(HospCodeNode,"CookMode",RowID))="")
		    s Code=$P(^DHCDocConfig(HospCodeNode,"CookMode",RowID),"^",1)
		    s Desc=$P(^DHCDocConfig(HospCodeNode,"CookMode",RowID),"^",2)
		    s RecLoc=""
		    if (value'="") s RecLoc=..GetCookRecLoc(RowID,value,HospId)
		    set Data=$lb(RowID,$g(Code),$g(Desc),RecLoc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}else{
	    s RowID="0"
	    for {
		    s RowID=$O(^DHCDocConfig("CookMode",RowID))
		    q:RowID=""
			if InstrRowID'=""{
				s CookModeInstr=..GetCookModeInstr(RowID, HospId)
				continue:(CookModeInstr'="")&&(("^"_CookModeInstr_"^")'[("^"_InstrRowID_"^"))
			}
		    s Code=$P(^DHCDocConfig("CookMode",RowID),"^",1)
		    s Desc=$P(^DHCDocConfig("CookMode",RowID),"^",2)
		    s RecLoc=""
		    if (value'="") s RecLoc=..GetCookRecLoc(RowID,value,HospId)
		    set Data=$lb(RowID,$g(Code),$g(Desc),RecLoc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCookModeExecute ]
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

Query FindLoc(Type As %String, HospId As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary, Type As %String, HospId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindLoc","")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s LocID=0
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocHospDr=$p(^CTLOC(LocID),"^",22)
	.Q:(LocHospDr'=HospId)&&(HospId'="")
	.s ActiveFlag=$p(^CTLOC(LocID),"^",14)
	.q:ActiveFlag="N"
	.s CTLOCWardFlag=$p(^CTLOC(LocID),"^",5)
	.s DateActiveFrom=$p(^CTLOC(LocID),"^",24)
	.q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
	.s DateActiveTo=$p(^CTLOC(LocID),"^",25)
	.q:(DateActiveTo'="")&&(DateActiveTo<+$h)
	.s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s selected=0
	.Do OutputRowFindLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
    set ConnectName=$p(^CTLOC(LocID),"^",43)
    set LocDesc=ConnectName_" "_LocDesc
	set Data=$lb($g(LocID),$g(LocDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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

/// 保存煎药方式的接收科室及类型#Iyqd
/// ^DHCDocConfig("CookMode",1,"RecLoc",1)=Type_"^"_ID
ClassMethod SaveCookModeLoc(Rowid, Type, LocDR, subrowid, HospId As %String = "")
{
	s ret=0
	q:Rowid="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if (subrowid=""){
			s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"RecLoc",""),-1)
			if subrowid="" s subrowid=1
			else  s subrowid=subrowid+1
		}
		s RepeatFlag=0
		s id=""
		for{
			s id=$o(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"RecLoc",id))
			Q:id=""
			continue:id=subrowid
			s mstr=$g(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"RecLoc",id))
			s mType=$p(mstr,"^",1)
			s mLocDR=$p(mstr,"^",2)
			if (mType=Type)&&(mLocDR=LocDR){
				s RepeatFlag=1	
			}
		}
		if RepeatFlag=1{
			s ret="Repeat"	
		}else{
			s ^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"RecLoc",subrowid)=Type_"^"_LocDR
		}
	}else{
		if (subrowid=""){
			s subrowid=$O(^DHCDocConfig("CookMode",Rowid,"RecLoc",""),-1)
			if subrowid="" s subrowid=1
			else  s subrowid=subrowid+1
		}
		s RepeatFlag=0
		s id=""
		for{
			s id=$o(^DHCDocConfig("CookMode",Rowid,"RecLoc",id))
			Q:id=""
			continue:id=subrowid
			s mstr=$g(^DHCDocConfig("CookMode",Rowid,"RecLoc",id))
			s mType=$p(mstr,"^",1)
			s mLocDR=$p(mstr,"^",2)
			if (mType=Type)&&(mLocDR=LocDR){
				s RepeatFlag=1	
			}
		}
		if RepeatFlag=1{
			s ret="Repeat"	
		}else{
			s ^DHCDocConfig("CookMode",Rowid,"RecLoc",subrowid)=Type_"^"_LocDR
		}
	}
	q ret
}

ClassMethod DelectCookModeLoc(Rowid, subRowid, HospId As %String = "")
{
	q:Rowid="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"RecLoc",subRowid)
	}else{
		k ^DHCDocConfig("CookMode",Rowid,"RecLoc",subRowid)
	}
	q 0
}

Query FindCookModeLoc(CookArcRowid As %String, HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,CookType:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindCookModeLocExecute(ByRef qHandle As %Binary, CookArcRowid As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCookModeLoc","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s subrowid=""
	    for {
		    s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s CookType=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid),"^",1)
		    s LocDr=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid),"^",2)
		    s LocDesc=$p(^CTLOC(LocDr),"^",2)
		    set Data=$lb($g(RowID),$g(CookType),$g(LocDesc),LocDr)
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}else{
		s subrowid=""
	    for {
		    s subrowid=$O(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s CookType=$P(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid),"^",1)
		    s LocDr=$P(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid),"^",2)
		    s LocDesc=$p(^CTLOC(LocDr),"^",2)
		    set Data=$lb($g(RowID),$g(CookType),$g(LocDesc),LocDr)
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindCookModeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCookModeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCookModeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCookModeLocExecute ]
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

/// 保存煎药方式的医嘱
/// ^DHCDocConfig("CookMode",1,"Arc",1)=ARCIM
ClassMethod SaveCookModeArcim(Rowid, Arcim, number, subrowid, HospId As %String = "")
{
	s ret=0
	q:Rowid="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if (subrowid=""){
			s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Arc",""),-1)
			if subrowid="" s subrowid=1
			else  s subrowid=subrowid+1
		}
		
		s RepeatFlag=0
		s id=""
		for{
			s id=$o(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Arc",id))
			Q:id=""
			continue:id=subrowid
			s mstr=$g(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Arc",id))
			s mArcim=$p(mstr,"^",1)
			if (mArcim=Arcim){
				s RepeatFlag=1	
			}
		}
		if RepeatFlag=1{
			s ret="Repeat"	
		}else{
			s ^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Arc",subrowid)=Arcim_"^"_number
		}
	}else{
		if (subrowid=""){
			s subrowid=$O(^DHCDocConfig("CookMode",Rowid,"Arc",""),-1)
			if subrowid="" s subrowid=1
			else  s subrowid=subrowid+1
		}
		s RepeatFlag=0
		s id=""
		for{
			s id=$o(^DHCDocConfig("CookMode",Rowid,"Arc",id))
			Q:id=""
			continue:id=subrowid
			s mstr=$g(^DHCDocConfig("CookMode",Rowid,"Arc",id))
			s mArcim=$p(mstr,"^",1)
			if (mArcim=Arcim){
				s RepeatFlag=1	
			}
		}
		if RepeatFlag=1{
			s ret="Repeat"	
		}else{
			s ^DHCDocConfig("CookMode",Rowid,"Arc",subrowid)=Arcim_"^"_number
		}
	}
	q ret
}

ClassMethod DelectCookModeArcim(Rowid, subRowid, HospId As %String = "")
{
	q:Rowid="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Arc",subRowid)
	}else{
		k ^DHCDocConfig("CookMode",Rowid,"Arc",subRowid)
	}
	q 0
}

/// 保存煎药方式限制用法
/// ^DHCDocConfig("CookMode",1,"Instr")=Instr1^Instr2^...
ClassMethod SaveCookModeInstr(Rowid, InstrStr, HospId As %String = "")
{
	Q:Rowid="" ""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Instr")=InstrStr
	}else{
		s ^DHCDocConfig("CookMode",Rowid,"Instr")=InstrStr
	}
	Q 0
}

ClassMethod GetCookModeInstr(Rowid, HospId As %String = "")
{
	Q:Rowid="" ""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s InstrStr=$G(^DHCDocConfig(HospCodeNode,"CookMode",Rowid,"Instr"))
	}else{
		s InstrStr=$G(^DHCDocConfig("CookMode",Rowid,"Instr"))
	}
	Q InstrStr
}

Query FindCookModeArcim(CookArcRowid As %String, HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,ARCIMDesc:%String,Number:%String,ARCIMRowid:%String")
{
}

ClassMethod FindCookModeArcimExecute(ByRef qHandle As %Binary, CookArcRowid As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCookModeLoc","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s subrowid=""
	    for {
		    s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s ArcimID=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid),"^",1)
		    continue:ArcimID=""
		    continue:'$d(^ARCIM(+ArcimID,$P(ArcimID,"||",2)))
		    s ARCIMDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
		    s Number=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid),"^",2)
		    set Data=$lb($g(RowID),$g(ARCIMDesc),$g(Number),ArcimID)
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}else{
	    s subrowid=""
	    for {
		    s subrowid=$O(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s ArcimID=$P(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid),"^",1)
		    continue:ArcimID=""
		    continue:'$d(^ARCIM(+ArcimID,$P(ArcimID,"||",2)))
		    s ARCIMDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
		    s Number=$P(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid),"^",2)
		    set Data=$lb($g(RowID),$g(ARCIMDesc),$g(Number),ArcimID)
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindCookModeArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCookModeArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCookModeArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCookModeArcimExecute ]
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

ClassMethod GetCookRecLoc(CookArcRowid, EpisodeID, HospId As %String, OrderOpenForAllHosp As %String = "0")
{
	n (CookArcRowid, EpisodeID, HospId ,OrderOpenForAllHosp ,%session)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmType=$case(AdmType,"I":"住院","O":"门诊","E":"急诊","H":"体检","N":"新生儿",:"")
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s subrowid=""
		s LocStr=""
	    for {
		    s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s CookType=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid),"^",1)
		    continue:(AdmType'=CookType)&&(CookType'="")
		    s LocDr=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"RecLoc",subrowid),"^",2)
		    continue:LocDr=""
		    continue:($p($g(^CTLOC(LocDr)),"^",22)'=HospId)&&(OrderOpenForAllHosp=0)
		    s LocDesc=$p(^CTLOC(LocDr),"^",2)
		    if (LocStr="")  s LocStr=LocDr_$C(1)_LocDesc_$C(1)_"Y"_$C(1)_""
		    else  s LocStr=LocStr_$C(2)_LocDr_$C(1)_LocDesc_$C(1)_"N"_$C(1)_""
		}
	}else{
		s subrowid=""
		s LocStr=""
	    for {
		    s subrowid=$O(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid))
		    q:subrowid=""
		    s RowID=subrowid
		    s CookType=$P(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid),"^",1)
		    continue:(AdmType'=CookType)&&(CookType)
		    s LocDr=$P(^DHCDocConfig("CookMode",CookArcRowid,"RecLoc",subrowid),"^",2)
		    continue:LocDr=""
		    continue:($p($g(^CTLOC(LocDr)),"^",22)'=HospId)&&(OrderOpenForAllHosp=0)
		    s LocDesc=$p(^CTLOC(LocDr),"^",2)
		    if (LocStr="")  s LocStr=LocDr_$C(1)_LocDesc_$C(1)_"Y"_$C(1)_""
		    else  s LocStr=LocStr_$C(2)_LocDr_$C(1)_LocDesc_$C(1)_"N"_$C(1)_""
		}
	}
	q LocStr
}

ClassMethod GetCookArcim(CookArcRowid)
{
	q:CookArcRowid="" ""
	s CookStr=""
	 s subrowid=""
    for {
	    s subrowid=$O(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid))
	    q:subrowid=""
	    s RowID=subrowid
	    s ArcimID=$P(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid),"^",1)
	    s ARCIMDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
	    s Number=$P(^DHCDocConfig("CookMode",CookArcRowid,"Arc",subrowid),"^",2)
	    if (CookStr="") s CookStr=ArcimID_"^"_Number
	    else  s CookStr=CookStr_"@"_ArcimID_"^"_Number
	   }
	q CookStr
}

/// 取药方式
ClassMethod SaveTakingMedicineMethod(RowID, Code, Desc, ToStock)
{
	n (RowID , Code , Desc  ,ToStock,%session)
	s Same=..CheckSameTakingMedicineMethod(RowID, Code, Desc)
	if Same=1 q "代码或者描述重复"
	if (RowID'=""){
		s ^DHCDocConfig("TakingMedicineMethod",RowID)=Code_$C(1)_Desc_$C(1)_"Y"_$C(1)_ToStock
	}else{
		s RowID=$O(^DHCDocConfig("TakingMedicineMethod",""),-1)
		s RowID=$G(RowID)+1
		s ^DHCDocConfig("TakingMedicineMethod",RowID)=Code_$C(1)_Desc_$C(1)_"Y"_$C(1)_ToStock
	}
	q 0
}

ClassMethod DelectTakingMedicineMethod(RowID)
{
	s $P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),3)="N"
	q 0
}

ClassMethod CheckSameTakingMedicineMethod(MastRowID, MastCode, MastDesc)
{
	n (MastRowID , MastCode , MastDesc  ,%session)
	s flag=0
	s RowID=""
    for {
	    s RowID=$O(^DHCDocConfig("TakingMedicineMethod",RowID))
	    q:RowID=""
	    continue:($P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),3)="N")
	    continue:MastRowID=RowID
		s Code=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),1)
		s Desc=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),2)
	    if ((MastCode=Code)||(MastDesc=Desc)) s flag=1
	    q:flag=1
	}
	q flag
}

Query FindTakingMedicineMethod() As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String,ToStock:%String")
{
}

ClassMethod FindTakingMedicineMethodExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCookModeLoc","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s RowID=""
    for {
	    s RowID=$O(^DHCDocConfig("TakingMedicineMethod",RowID))
	    q:RowID=""
	    continue:($P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),3)="N")
		s Code=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),1)
		s Desc=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),2)
		s ToStock=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),4)
	    set Data=$lb($g(RowID),$g(Code),$g(Desc),$g(ToStock))
	    Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindTakingMedicineMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTakingMedicineMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTakingMedicineMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTakingMedicineMethodExecute ]
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

/// w ##Class(DHCDoc.DHCDocConfig.DocConfig).GetDosingRecLocStr(2)
ClassMethod GetDosingRecLocStr(HospID = "") [ ProcedureBlock = 1 ]
{
	s RetLocStr=""
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospCodeNode="HospDr_"_HospID
	s LocID=""
	for {
		s LocID=$O(^DHCDocConfig(HospCodeNode,"IPDosingRecLoc",LocID))
		q:(LocID="")
		continue:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(LocID)
		//1 静配药房；其他 普通药房
		s Active=$g(^DHCDocConfig(HospCodeNode,"IPDosingRecLoc",LocID,"Active"))
		continue:Active'=1
		i RetLocStr="" s RetLocStr=LocID
		e  s RetLocStr=RetLocStr_"^"_LocID
	}
	Q RetLocStr
}

/// 批量保存多节点配置信息
/// w ##Class(DHCDoc.DHCDocConfig.DocConfig).SaveDocConfigCommon(2,$LG(^TMP("SaveDocConfigCommon"),2))
ClassMethod SaveDocConfigCommon(HospId As %String, ConfigJson As %String) [ ProcedureBlock = 1 ]
{
	s ^TMP("SaveDocConfigCommon")=$LB(HospId,ConfigJson)
	if (HospId=""){
		q -100
	}
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ConfigJson,.ConfigArr)
	if ('$D(ConfigArr)){
		q -101
	}
	s isNumber=0
	s Node=$O(ConfigArr(""))
	if ($A(Node)<65){
		//第一层节点（首字符）必须是有意义的英文，不得为数字
		q -102
	}
	s HospCodeNode="HospDr_"_HospId
	m ^DHCDocConfig(HospCodeNode)=ConfigArr
	
	Q 0
}

ClassMethod SaveCNMedInstrContrastData(CMPrescType As %String, CMPrescInstr As %String, HospId As %String = "")
{
	q:(CMPrescType="")!(CMPrescInstr="") "-1"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s rtn=##class(web.DHCDocConfig).SaveConfig3("CNMedInstrContrast","",CMPrescType_"^"_CMPrescInstr,HospId)
	q 0
}

ClassMethod DelectInstrContrast(RowID, HospId As %String = "")
{
	q:RowID="" 0
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",RowID)
	}else{
		k ^DHCDocConfig("CNMedInstrContrast",RowID)
	}
	q 0
}

Query FindInstrContrast(HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,CMPrescType:%String,CMPrescTypeDesc:%String,CMPrescInstr:%String,CMPrescInstrDesc:%String")
{
}

ClassMethod FindInstrContrastExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindInstrContrast","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s OutRowId=0
	    for {
		    s OutRowId=$O(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId))
		    q:OutRowId=""
		    s CMPrescType=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",1)
		    continue:CMPrescType=""
		    s CMPrescTypeDesc=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",2)
		    s CMPrescInstr=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",3)
		    continue:CMPrescInstr=""
		    s CMPrescInstrDesc=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",4)
		    set Data=$lb(OutRowId,CMPrescType,CMPrescTypeDesc,CMPrescInstr,CMPrescInstrDesc)
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}else{
	    s OutRowId=0
	    for {
		    s OutRowId=$O(^DHCDocConfig("CNMedInstrContrast",OutRowId))
		    q:OutRowId=""
		    s RowID=subrowid
		    s CMPrescType=$P(^DHCDocConfig("CNMedInstrContrast",OutRowId),"^",1)
		    continue:CMPrescType=""
		    s CMPrescInstr=$P(^DHCDocConfig("CNMedInstrContrast",OutRowId),"^",2)
		    set Data=$lb(OutRowId,CMPrescType,CMPrescInstr)
		    continue:CMPrescInstr=""
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindInstrContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrContrastExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrContrastExecute ]
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

Query FindLinkInstrContrast(ValType As %String, Value As %String, HospId As %String = "") As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod FindLinkInstrContrastExecute(ByRef qHandle As %Binary, ValType As %String, Value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindLinkInstrContrast","PrescType","CNMedPrior",2)
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    if (ValType="PrescType"){
	    s KeyValue=##class(web.DHCDocConfig).GetConfigNode(Value,HospId)
		s RowId=0
		f  {
			s RowId=$o(^OECPR(RowId)) 
			q:RowId=""
			s Desc=$p(^OECPR(RowId),"^",2)
			continue:("^"_KeyValue_"^")'[("^"_RowId_"^")
			Do OutputLinkInstrContrast
		}
    }elseif (ValType="PrescInstr"){
	    //s KeyValue=..GetKeyValue(Value,HospId) 
	    s RowId=0
	 	f  {
		 	s RowId=$o(^PHCIN(RowId)) 
		 	q:RowId=""
		 	s str=$g(^PHCIN(RowId))
		 	s Desc=$p(str,"^",1)
		 	s PHCINDesc2=$p(str,"^",3)
		 	continue:PHCINDesc2'="饮片"
			//continue:("^"_KeyValue_"^")'[("^"_RowId_"^")
			Do OutputLinkInstrContrast
	 	}
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLinkInstrContrast
	set Data=$lb($g(RowId),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLinkInstrContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLinkInstrContrastExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLinkInstrContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLinkInstrContrastExecute ]
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

/// 根据医嘱类型获取用法id
/// w ##class(DHCDoc.DHCDocConfig.DocConfig).GetInstrByPriorType("4","2")
ClassMethod GetInstrByPriorType(PriorTypeDr As %String, HospId As %String)
{
	s RetValue=""
	s:($g(HospId)="")&&($d(%session)) HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s OutRowId=0
	    for {
		    s OutRowId=$O(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId))
		    q:OutRowId=""
		    s CMPrescType=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",1)
		    continue:CMPrescType'=PriorTypeDr
		    s CMPrescTypeDesc=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",2)
		    s CMPrescInstr=$P(^DHCDocConfig(HospCodeNode,"CNMedInstrContrast",OutRowId),"^",3)
		    continue:CMPrescInstr=""
		    s RetValue=CMPrescInstr
		}
	}else{
	    s OutRowId=0
	    for {
		    s OutRowId=$O(^DHCDocConfig("CNMedInstrContrast",OutRowId))
		    q:OutRowId=""
		    s RowID=subrowid
		    s CMPrescType=$P(^DHCDocConfig("CNMedInstrContrast",OutRowId),"^",1)
		    continue:CMPrescType'=PriorTypeDr
		    s CMPrescInstr=$P(^DHCDocConfig("CNMedInstrContrast",OutRowId),"^",2)
		    set Data=$lb(OutRowId,CMPrescType,CMPrescInstr)
		    continue:CMPrescInstr=""
		    s RetValue=CMPrescInstr
		}
	}
	q RetValue
}

Query FindPrior(value As %String, HospId As %String = "") As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindPriorExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindCNMedPrior","CNMedPrior")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s selected=0
	.Do OutputRowFindPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPriorExecute ]
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

}
