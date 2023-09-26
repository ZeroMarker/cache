Class DHCDoc.DHCDocConfig.OrderClassify Extends (DHCDoc.Util.RegisteredObject, %CSP.Page, %Library.DynamicAbstractObject) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	s action=$g(%request.Data("action",1),"")
	s Json=""
	if (action="LoadOrderKind"){
		s EpisodeID=$g(%request.Data("EpisodeID",1),"")
		s HospId=$g(%request.Data("HospId",1),"")
		s Json=..LoadOrderKind(EpisodeID,HospId)
	}elseif (action="InserOrderKindSub"){
		s MainRowID=$g(%request.Data("MainRowID",1),"")
		s SubIndex=$g(%request.Data("SubIndex",1),"")
		s ARCIMDR=$g(%request.Data("ARCIMDR",1),"")
		s HospId=$g(%request.Data("HospId",1),"")
		s Json=..InserOrderKindSub(MainRowID,SubIndex,ARCIMDR,HospId)
	}elseif (action="InserOrderKindMain"){
		s MainRowID=$g(%request.Data("MainRowID",1),"")
		s Title=$g(%request.Data("Title",1),"")
		s HospId=$g(%request.Data("HospId",1),"")
		s Json=..InserOrderKindMain(MainRowID,Title,HospId)
	}elseif (action="DelOrderKind"){
		s RowID=$g(%request.Data("RowID",1),"")
		s HospId=$g(%request.Data("HospId",1),"")
		s Json=..DelOrderKind(RowID,HospId)
	}else{
		s Json=""
	}
 	w Json
	Quit $$$OK
ErrorHandler
	w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
	Quit $$$OK
}

Query FindOrderClassify(HospId As %String = "") As %Query(ROWSPEC = "Index:%String,ClassifyCode:%String,ClassifyDesc:%String")
{
}

ClassMethod FindOrderClassifyExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ClassifyCode=0
		for {
			s ClassifyCode=$O(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode))
			q:(ClassifyCode="")
			s ClassifyDesc=^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode)
			d OutPut1
		}
	}else{
		s ClassifyCode=0
		for {
			s ClassifyCode=$O(^DHCDocConfig("OrderClassify",ClassifyCode))
			q:(ClassifyCode="")
			s ClassifyDesc=^DHCDocConfig("OrderClassify",ClassifyCode)
			d OutPut1
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut1
	Set Data=$lb(ind,ClassifyCode,ClassifyDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindOrderClassifyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderClassifyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrderClassifyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderClassifyExecute ]
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

ClassMethod DelOrderClassify(ClassifyCodeS As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		for i=1:1:$L(ClassifyCodeS,",") {
			s ClassifyCode=$P(ClassifyCodeS,",",i)
			k ^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode)
		}
	}else{
		for i=1:1:$L(ClassifyCodeS,",") {
			s ClassifyCode=$P(ClassifyCodeS,",",i)
			k ^DHCDocConfig("OrderClassify",ClassifyCode)
		}
	}
	q 0
}

ClassMethod InsertOrderClassify(ClassifyCode As %String, ClassifyDesc As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode)=ClassifyDesc
	}else{
		s ^DHCDocConfig("OrderClassify",ClassifyCode)=ClassifyDesc
	}
	q 0
}

Query FindClassifyDetails(ClassifyCode As %String, HospId As %String = "") As %Query(ROWSPEC = "Index:%String,ARCIMDR:%String,ArcimDesc:%String,NeedOutData:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderClassify","FindClassifyDetails","TendOrd")
ClassMethod FindClassifyDetailsExecute(ByRef qHandle As %Binary, ClassifyCode As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (ClassifyCode=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index)
			s ARCIMDR=$P(val,"^",1)
			s NeedOutData=$P(val,"^",2)
			s ARCIMDesc=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",2)
			d OutPut2
		}
	}else{
		s Index=0
		for {
			s Index=$O(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index)
			s ARCIMDR=$P(val,"^",1)
			s NeedOutData=$P(val,"^",2)
			s ARCIMDesc=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",2)
			d OutPut2
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut2
	Set Data=$lb(Index,ARCIMDR,ARCIMDesc,NeedOutData)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindClassifyDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClassifyDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindClassifyDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClassifyDetailsExecute ]
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

ClassMethod DefinedClassify(ClassifyCode As %String, ARCIMDR As %String, HospId As %String = "")
{
	s DefinedClassifyFlag="N"
	if (ClassifyCode=""){
		q DefinedClassifyFlag
	}
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index)
			if (ARCIMDR=$P(val,"^",1)){
				s DefinedClassifyFlag="Y"
				q
			}
		}
	}else{
		s Index=0
		for {
			s Index=$O(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index)
			if (ARCIMDR=$P(val,"^",1)){
				s DefinedClassifyFlag="Y"
				q
			}
		}
	}
	
	q DefinedClassifyFlag
}

// Drainage^^3431||1^N 2

ClassMethod InsertClassifyDetail(Params As %String, HospId As %String = "") As %String
{
	s ClassifyCode=$P(Params,"^",1)
	s Index=$P(Params,"^",2)
	s ARCIMDRStr=$P(Params,"^",3)
	s NeedOutData=$P(Params,"^",4)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (ClassifyCode="")||(+ARCIMDRStr="0") q "-100^未检索到有效的数据"
	for i=1:1:$Length(ARCIMDRStr,"!"){
		s ARCIMDR=$P(ARCIMDRStr,"!",i)
		continue:'$D(^ARCIM(+ARCIMDR,+$P(ARCIMDR,"||",2)))
		
		s myParams=ClassifyCode_"^"_Index_"^"_ARCIMDR_"^"_NeedOutData
		continue:..CheckClassifyDetailRepeat(myParams,HospId)
		if (HospId'="") {
			s HospCodeNode="HospDr_"_HospId
			if (Index=""){
				s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",""),-1)
				s Index=Index+1
			}
			s ^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index)=ARCIMDR_"^"_NeedOutData
		}else{
			if (Index=""){
				s Index=$O(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",""),-1)
				s Index=Index+1
			}
			s ^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index)=ARCIMDR_"^"_NeedOutData
		}
		s Index=""
	}
	q 0
}

ClassMethod CheckClassifyDetailRepeat(Params As %String, HospId As %String = "") As %String
{
	s ClassifyCode=$P(Params,"^",1)
	s Index=$P(Params,"^",2)
	s ARCIMDR=$P(Params,"^",3)
	s NeedOutData=$P(Params,"^",4)
	s ClassifyDetailRepeat=0
	if (HospId="") {
		s count=0
		for {
			s count=$o(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",count)) Q:count=""
			continue:(Index'="")&&(Index=count)
			s Data=$g(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",count))
			if ($p(Data,"^",1)=ARCIMDR){
				s ClassifyDetailRepeat=1
			}
		}
	}else{
		s HospCodeNode="HospDr_"_HospId
		s count=0
		for {
			s count=$o(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",count)) Q:count=""
			continue:(Index'="")&&(Index=count)
			s Data=$g(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",count))
			if ($p(Data,"^",1)=ARCIMDR){
				s ClassifyDetailRepeat=1
			}
		}
	}
	Q ClassifyDetailRepeat
}

ClassMethod DelClassifyDetail(Params As %String, HospId As %String = "") As %String
{
	s ClassifyCode=$P(Params,"^",1)
	s Index=$P(Params,"^",2)
	if (ClassifyCode="")||(Index="") q "-100"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyCode,"Detail",Index)
	}else{
		k ^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",Index)
	}
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.OrderClassify).LoadOrderKind(66)
ClassMethod LoadOrderKind(EpisodeID As %String, HospId As %String = "") As %String
{
	;s ^tan("LoadOrderKind")=EpisodeID
	Set langid=..%LanguageID()
	k OrderKindList
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s MainIndex=0
		for {
			s MainIndex=$O(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex))
			q:(MainIndex="")
			
			if $D(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail")){
				s SubIndex=0
				for {
					s SubIndex=$O(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail",SubIndex))
					q:(SubIndex="")
					s val=$G(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail",SubIndex))
					s ARCIMDR=$P(val,"^",1)
					s NeedOutData=$P(val,"^",2)
					
					if (EpisodeID'=""){
						s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
						s SignOrdList=""
						s mySelection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.SignOrdList,NeedOutData)
						if (mySelection="1"){
							s OEOrder=$P(SignOrdList,"^",1)
							s OrderKindList(MainIndex,SubIndex)=OEOrder
						}
					}else{
						s OrderKindList(MainIndex,SubIndex)=""
					}
				}
			}else{
				s OrderKindList(MainIndex)=""
			}
		}
	}else{
		s HospCodeNode=""
		s MainIndex=0
		for {
			s MainIndex=$O(^DHCDocConfig("OrderKind",MainIndex))
			q:(MainIndex="")
			
			if $D(^DHCDocConfig("OrderKind",MainIndex,"Detail")){
				s SubIndex=0
				for {
					s SubIndex=$O(^DHCDocConfig("OrderKind",MainIndex,"Detail",SubIndex))
					q:(SubIndex="")
					s val=$G(^DHCDocConfig("OrderKind",MainIndex,"Detail",SubIndex))
					s ARCIMDR=$P(val,"^",1)
					s NeedOutData=$P(val,"^",2)
					
					if (EpisodeID'=""){
						s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
						s SignOrdList=""
						s mySelection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.SignOrdList,NeedOutData)
						if (mySelection="1"){
							s OEOrder=$P(SignOrdList,"^",1)
							s OrderKindList(MainIndex,SubIndex)=OEOrder
						}
					}else{
						s OrderKindList(MainIndex,SubIndex)=""
					}
				}
			}else{
				s OrderKindList(MainIndex)=""
			}
		}
	}
	
	s JsonObj=[]
	s MainIndex=""
	for {
		s MainIndex=$O(OrderKindList(MainIndex))
		q:(MainIndex="")
		if (HospCodeNode="") {
			s OrderKindDesc=$G(^DHCDocConfig("OrderKind",MainIndex))
		}else{
			s OrderKindDesc=$G(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex))
		}
		s OneKindJson={}
		do OneKindJson.%Set("RowID",MainIndex)
		do OneKindJson.%Set("Title",OrderKindDesc)
		do OneKindJson.%Set("ARCIMDR","")
		do OneKindJson.%Set("ArcimDesc","")
		s SubKindJson=[]
		s SubIndex=""
		for {
			s SubIndex=$O(OrderKindList(MainIndex,SubIndex))
			q:(SubIndex="")
			s OEOrder=OrderKindList(MainIndex,SubIndex)
			if (HospCodeNode="") {
				s val=$G(^DHCDocConfig("OrderKind",MainIndex,"Detail",SubIndex))
			}else{
				s val=$G(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail",SubIndex))
			}
			s ARCIMDR=$P(val,"^",1)
			continue:+ARCIMDR=0
			s NeedOutData=$P(val,"^",2)
			s ARCIMDesc=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",2)
			s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
			s obj={}
			do obj.%Set("RowID",MainIndex_"99999"_SubIndex)
			do obj.%Set("Title","")
			do obj.%Set("ARCIMDR",ARCIMDR)
			do obj.%Set("ArcimDesc",ARCIMDesc)
			do obj.%Set("OEOrder",OEOrder)
			do SubKindJson.%Push(obj,"")
		}
		d OneKindJson.%Set("children",SubKindJson)
		do JsonObj.%Push(OneKindJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
}

ClassMethod InserOrderKindSub(MainRowID As %String, SubIndex As %String, ARCIMDRStr As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	for i=1:1:$Length(ARCIMDRStr,"!"){
		s ARCIMDR=$P(ARCIMDRStr,"!",i)
		continue:'$D(^ARCIM(+ARCIMDR,+$P(ARCIMDR,"||",2)))
		if (HospId'="") {
			s HospCodeNode="HospDr_"_HospId
			if (SubIndex=""){
				s SubIndex=$O(^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID,"Detail",""),-1)
				s SubIndex=SubIndex+1
			}
			s ^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID,"Detail",SubIndex)=ARCIMDR
		}else{
			if (SubIndex=""){
				s SubIndex=$O(^DHCDocConfig("OrderKind",MainRowID,"Detail",""),-1)
				s SubIndex=SubIndex+1
			}
			s ^DHCDocConfig("OrderKind",MainRowID,"Detail",SubIndex)=ARCIMDR
		}
		s SubIndex=""
	}
	q 0
}

ClassMethod InserOrderKindMain(MainRowID As %String, Title As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if '$D(^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID)){
			s MainRowID=$O(^DHCDocConfig(HospCodeNode,"OrderKind",""),-1)
			s MainRowID=MainRowID+1
		}
		s ^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID)=Title
	}else{
		if '$D(^DHCDocConfig("OrderKind",MainRowID)){
			s MainRowID=$O(^DHCDocConfig("OrderKind",""),-1)
			s MainRowID=MainRowID+1
		}
		s ^DHCDocConfig("OrderKind",MainRowID)=Title
	}
	q 0
}

ClassMethod DelOrderKind(RowID As %String, HospId As %String = "") As %String
{
	s MainRowID=$P(RowID,"99999",1)
	s SubRowID=$P(RowID,"99999",2)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if (SubRowID'="")&&(MainRowID'=""){
			k ^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID,"Detail",SubRowID)
		}elseif (MainRowID'=""){
			k ^DHCDocConfig(HospCodeNode,"OrderKind",MainRowID)
		}else{
			q "-100"
		}
	}else{
		if (SubRowID'="")&&(MainRowID'=""){
			k ^DHCDocConfig("OrderKind",MainRowID,"Detail",SubRowID)
		}elseif (MainRowID'=""){
			k ^DHCDocConfig("OrderKind",MainRowID)
		}else{
			q "-100"
		}
	}
	
	q 0
}

/// 获取当前患者的护理、饮食、引流类医嘱列表
/// input:EpisodeID 就诊号;ClassifyType:Diet-饮食,Drainage-引流,TendOrd-护理
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderClassify","QueryAdmOrderClassifyDetail","66","TendOrd")
Query QueryAdmOrderClassifyDetail(EpisodeID As %String, ClassifyType As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCIMDR:%String,ARCIMDesc:%String,Selection:%String,OrdList:%String,NeedOutData:%String")
{
}

ClassMethod QueryAdmOrderClassifyDetailExecute(ByRef qHandle As %Binary, EpisodeID As %String, ClassifyType As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (ClassifyType="")||(EpisodeID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	if (OrderRowid=""){
		//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyType,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig(HospCodeNode,"OrderClassify",ClassifyType,"Detail",Index)
			s ARCIMDR=$P(val,"^",1)
			s NeedOutData=$P(val,"^",2)
			s ARCIMDesc=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",2)
			s OrdList=""
			s Selection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.OrdList,NeedOutData)
			d OutPut4
		}
	}else{
		s Index=0
		for {
			s Index=$O(^DHCDocConfig("OrderClassify",ClassifyType,"Detail",Index))
			q:(Index="")
			s val=^DHCDocConfig("OrderClassify",ClassifyType,"Detail",Index)
			s ARCIMDR=$P(val,"^",1)
			s NeedOutData=$P(val,"^",2)
			s ARCIMDesc=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",2)
			s OrdList=""
			s Selection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.OrdList,NeedOutData)
			d OutPut4
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut4
	Set Data=$lb(ARCIMDR,ARCIMDesc,Selection,OrdList,NeedOutData)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QueryAdmOrderClassifyDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmOrderClassifyDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAdmOrderClassifyDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmOrderClassifyDetailExecute ]
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

ClassMethod IsActiveOrd(OrderRowid As %String, ARCIMDR As %String, Day As %String, ByRef SelectOrdList As %String = "", NeedOutData As %String = "") As %String
{
	n (OrderRowid,ARCIMDR,Day,SelectOrdList,NeedOutData)
	s Selection="0"
	q:(OrderRowid="")||(ARCIMDR="") Selection
	///查询患者是否有该医嘱
	s SttDat=0
	for {
		s SttDat=$O(^OEORDi(0,"ARCIM",OrderRowid,ARCIMDR,SttDat))
		q:(SttDat="")||(SttDat>+$H)
		s ItemSub=0
		for {
			s ItemSub=$O(^OEORDi(0,"ARCIM",OrderRowid,ARCIMDR,SttDat,ItemSub))
			q:(ItemSub="")
			s PriorRowid=$p($g(^OEORD(OrderRowid,"I",ItemSub,1)),"^",8)
			s PriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
			if (PriorFlag=0){
				continue:(SttDat'=..%SysDate())&&(NeedOutData'="Y")
				//外部数据的消失标志根据第三方数据处理
				//continue
			}
			s StatCode=""
			s ItemStat=$p($g(^OEORD(OrderRowid,"I",ItemSub,1)),"^",13)
			i ItemStat'="" s StatCode=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
			continue:(StatCode'="V")&&(StatCode'="E")
			s Selection=1
			if (SelectOrdList=""){
				s SelectOrdList=OrderRowid_"||"_ItemSub
			}else{
				s SelectOrdList=SelectOrdList_","_OrderRowid_"||"_ItemSub
			}
		}
	}
	q Selection
}

/// 获取病人当前的医嘱细化分类
/// w ##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(17,"Diet",.a)
ClassMethod GetAdmOrdClassify(EpisodeID As %String, ClassifyCode As %String, ByRef DataList As %String = "") As %String
{
	n (EpisodeID,ClassifyCode,DataList,%session)
	Set langid=..%LanguageID()
	s ArcimList=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.OrderClassify.QueryAdmOrderClassifyDetail")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,ClassifyCode)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ARCIMDR=rset.GetData(1)
			s ARCIMDesc=rset.GetData(2)
			s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
			s Selection=rset.GetData(3)
			s OrdList=rset.GetData(4)
			s NeedOutData=rset.GetData(5)
			if (Selection="1"){
				if (ArcimList=""){
					s ArcimList=ARCIMDesc
				}else{
					s ArcimList=ArcimList_","_ARCIMDesc
				}
			}
			if (DataList=""){
				s DataList=ARCIMDesc_$C(1)_ARCIMDR_$C(1)_Selection_$C(1)_OrdList_$C(1)_NeedOutData
			}else{
				s DataList=DataList_"^"_ARCIMDesc_$C(1)_ARCIMDR_$C(1)_Selection_$C(1)_OrdList_$C(1)_NeedOutData
			}
			
		}
		d rset.Close()
	}
	if (ArcimList="")&&($O(^DHCDocConfig("OrderClassify",ClassifyCode,"Detail",""),-1)<=0){
		s ArcimList="未配置"
	}
	q ArcimList
}

/// 获取病人当前的特殊医嘱细化分类
/// w ##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrderKind(66)
ClassMethod GetAdmOrderKind(EpisodeID As %String, ByRef SelectOrdList As %String = "", HospId As %String = "") As %String
{
	n (EpisodeID,SelectOrdList,HospId,%session)
	s OrderKindList=""
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	q:OrderRowid="" ""
	s ARCIMStr=""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s MainIndex=0
		for {
			s MainIndex=$O(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex))
			q:(MainIndex="")
			s OrderKindDesc=$G(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex))
			s myOrdList=""
			s SubIndex=0
			s Selection=0
			for {
				s SubIndex=$O(^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail",SubIndex))
				q:(SubIndex="")
				s val=^DHCDocConfig(HospCodeNode,"OrderKind",MainIndex,"Detail",SubIndex)
				s ARCIMDR=$P(val,"^",1)
				s NeedOutData=$P(val,"^",2)
				s SignOrdList=""
				s mySelection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.SignOrdList,NeedOutData)
				i mySelection=1 s Selection=mySelection
				if (SignOrdList'=""){
					if (myOrdList=""){
						s myOrdList=SignOrdList
					}else{
						s myOrdList=myOrdList_","_SignOrdList
					}
				}
			}
			continue:(Selection=0)
			if (SelectOrdList=""){
				s SelectOrdList=OrderKindDesc_":"_myOrdList
			}else{
				s SelectOrdList=SelectOrdList_";"_OrderKindDesc_":"_myOrdList
			}
			
			if (OrderKindList=""){
				s OrderKindList=OrderKindDesc
			}else{
				s OrderKindList=OrderKindList_","_OrderKindDesc
			}
		}
	}else{
		s MainIndex=0
		for {
			s MainIndex=$O(^DHCDocConfig("OrderKind",MainIndex))
			q:(MainIndex="")
			s OrderKindDesc=$G(^DHCDocConfig("OrderKind",MainIndex))
			s myOrdList=""
			s SubIndex=0
			s Selection=0
			for {
				s SubIndex=$O(^DHCDocConfig("OrderKind",MainIndex,"Detail",SubIndex))
				q:(SubIndex="")
				s val=^DHCDocConfig("OrderKind",MainIndex,"Detail",SubIndex)
				s ARCIMDR=$P(val,"^",1)
				s NeedOutData=$P(val,"^",2)
				s SignOrdList=""
				s mySelection=..IsActiveOrd(OrderRowid,ARCIMDR,+$H,.SignOrdList,NeedOutData)
				i mySelection=1 s Selection=mySelection
				if (SignOrdList'=""){
					if (myOrdList=""){
						s myOrdList=SignOrdList
					}else{
						s myOrdList=myOrdList_","_SignOrdList
					}
				}
			}
			continue:(Selection=0)
			if (SelectOrdList=""){
				s SelectOrdList=OrderKindDesc_":"_myOrdList
			}else{
				s SelectOrdList=SelectOrdList_";"_OrderKindDesc_":"_myOrdList
			}
			
			if (OrderKindList=""){
				s OrderKindList=OrderKindDesc
			}else{
				s OrderKindList=OrderKindList_","_OrderKindDesc
			}
		}
	}
	q OrderKindList
}

}
