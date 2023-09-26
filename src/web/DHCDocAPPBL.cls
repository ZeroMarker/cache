Class web.DHCDocAPPBL Extends DHCDoc.Util.RegisteredObject
{

/// 增加 病理申请单配置表
/// (代码，描述，JS调用地址)
/// Creator:qujian
/// CreateTime:20190815
/// w ##class(web.DHCDocAPPBL).InsertBLType("003","ceshi","script")
ClassMethod InsertBLType(Code As %String, Desc As %String, JSStr As %String, RowID As %String = "", FristFunction, ItmmastFunction, OpenSaveOther, LoadSaveOther, MapType As %String = "", XMLTempName As %String = "", ActiveFlag As %String = "")
{
	q:((Code="")||(Desc="")) ""
	s:ActiveFlag="" ActiveFlag="Y"
	s ^tempqujian("InsertBLType")=Code_","_Desc_","_JSStr_","_RowID_","_FristFunction_","_ItmmastFunction_","_OpenSaveOther_","_LoadSaveOther
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_DocAppBLMap 
		(APPMap_Code,APPMap_Name,APPMap_ShowJS,APPMap_Active,APPMap_FristFunction,APPMap_ItmmastFunction,APPMap_SaveOtherInfo,APPMap_LoadOtherInfo,APPMap_MapType,APPMap_XMLTempName
		) Values(:Code,:Desc,:JSStr,:ActiveFlag,:FristFunction,:ItmmastFunction,:OpenSaveOther,:LoadSaveOther,:MapType,:XMLTempName))
	}else{
		&SQL(Update SQLUser.DHC_DocAppBLMap set APPMap_Code=:Code,APPMap_Name=:Desc,APPMap_Active=:ActiveFlag,
		APPMap_ShowJS=:JSStr,APPMap_FristFunction=:FristFunction,APPMap_ItmmastFunction=:ItmmastFunction,
		APPMap_SaveOtherInfo=:OpenSaveOther,APPMap_LoadOtherInfo=:LoadSaveOther,APPMap_XMLTempName=:XMLTempName,APPMap_MapType=:MapType where RowID=:RowID)
		}
	s rtn=SQLCODE
	q rtn
}

/// 删除 病理申请单配置表
/// Creator:qujian
/// CreateTime:20190815
ClassMethod DelectBLType(RowID As %String)
{
	q:RowID="" ""
	s BLMapType=$P(^DHCDocAppBLMap(RowID),"^",9)
	if BLMapType="CA"{
		;治疗评估模板配置若项目或服务组已关联使用，则不允许删除
		s rtn=0
		if $d(^DHCDocCureItemSet(0,"RAT",RowID)){
			Q "-1"
		}
		s chkRowID=""
		for{
			s chkRowID=$o(^DHCDocCureItemSet(0,"RAT",chkRowID)) 
			Q:chkRowID=""
			if (","_chkRowID_",")[(","_RowID_","){
				s rtn="-1"
				Q
			}	
		}
		Q:rtn'=0 rtn
		
		s DDCSGSRowid=0 
		for{
			s DDCSGSRowid=$o(^DHCDocCureRBCServiceGroupSet(DDCSGSRowid))
			q:(DDCSGSRowid="")!(rtn="-1")
			s RelateAssTemp=$p(^DHCDocCureRBCServiceGroupSet(DDCSGSRowid),"^",5)
			if (","_RelateAssTemp_",")[(","_RowID_","){
				s rtn="-2"	
			}
		}
		Q:+rtn'=0 rtn
	}
	&SQL(DELETE SQLUser.DHC_DocAppBLMap where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

/// 查询 病理申请单数据
/// 
Query FindBLType(MapType As %String = "", FindType As %String = "Y") As %Query(ROWSPEC = "RowID:%String,BLTypeCode:%String,BLTypeDesc:%String,BLTypeJSAddress:%String,BLInit:%String,BLItemMast:%String,BLSaveOther:%String,BLLoadOther:%String,BLXMLTempName:%String,BLMapType:%String,BLActiveFlag:%String")
{
}

ClassMethod FindBLTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBLTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBLTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBLTypeExecute ]
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

/// Input:MapType 单据类型 FindType 查询类型(仅显示激活?)
ClassMethod FindBLTypeExecute(ByRef qHandle As %Binary, MapType As %String = "", FindType As %String = "Y") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocAPPBL","FindBLType","")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCDocAppBLMap(RowID))
		q:RowID=""
		s BLTypeCode=$P(^DHCDocAppBLMap(RowID),"^",1)
		s BLTypeDesc=$P(^DHCDocAppBLMap(RowID),"^",2)
		s BLMapType=$P(^DHCDocAppBLMap(RowID),"^",9)
		continue:(("^"_MapType_"^")'[("^"_BLMapType_"^"))
		s BLActiveFlag=$P(^DHCDocAppBLMap(RowID),"^",4)
		s BLActiveFlag=$case(BLActiveFlag,"N":"N",:"Y")
		continue:(FindType="Y")&&(BLActiveFlag'=FindType)
		s BLTypeJSAddress=$g(^DHCDocAppBLMap(RowID,"ShowJS"))
		s BLInit=$P(^DHCDocAppBLMap(RowID),"^",5)
		s BLItemMast=$P(^DHCDocAppBLMap(RowID),"^",6)
		s BLSaveOther=$P(^DHCDocAppBLMap(RowID),"^",7)
		s BLLoadOther=$P(^DHCDocAppBLMap(RowID),"^",8)
		s BLXMLTempName=$P(^DHCDocAppBLMap(RowID),"^",10)
		set Data=$lb(RowID,BLTypeCode,BLTypeDesc,BLTypeJSAddress,BLInit,BLItemMast,BLSaveOther,BLLoadOther,BLXMLTempName,BLMapType,BLActiveFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 增加 病理申请单模板配置表
/// (描述，html代码 RowID)
/// Creator:qujian
/// CreateTime:20190815
/// w ##class(web.DHCDocAPPBL).InsertBLType("003","ceshi","..script")
ClassMethod InsertBLTemple(Desc As %String, Content As %String, RowID As %String = "", ID As %String, JSStr As %String, MapType As %String = "", LastID As %String = "0", ByRef BLTempleRowid As %String = "")
{
	q:((Desc="")) ""
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_DocAppBLTemple 
		(APP_Name,APP_Content,APP_ID,APP_JSStr,APP_MapType,APP_LastID
		) Values(:Desc,:Content,:ID,:JSStr,:MapType,:LastID))
		if 'SQLCODE{
			s BLTempleRowid=$p(%ROWID,$c(1))	
		}
	}else{
		&SQL(Update SQLUser.DHC_DocAppBLTemple set APP_Name=:Desc, 
		APP_Content=:Content,APP_ID=:ID,APP_JSStr=:JSStr
		where RowID=:RowID)
		s BLTempleRowid=RowID
	}
	s rtn=SQLCODE
	q rtn
}

/// 删除 病理申请单配置表
/// Creator:qujian
/// CreateTime:20190815
ClassMethod DelectBLTemple(RowID As %String)
{
	q:RowID="" ""
	s MapID=0
	for{
		s MapID=$O(^DHCDocAppBLMap(MapID))
		q:MapID=""
		s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
		if (("||"_MapStr_"||")[("||"_RowID_"||")){
			d ..DelectApptNote(MapID, RowID)
			}
		
		}
	&SQL(DELETE SQLUser.DHC_DocAppBLTemple where RowID=:RowID)
	s rtn=SQLCODE
	if 'rtn{
		s ItemID=""
		for{
			s ItemID=$o(^DHCDocAppBLItemi("BLTemp",RowID,ItemID))
			Q:ItemID=""
			D ..DelectBLItem(ItemID)
		}
	}
	
	q rtn
}

/// 查询 病理申请单数据
/// 
Query FindBLTemple(MapType As %String = "") As %Query(ROWSPEC = "RowID:%String,BLTempleDesc:%String,BLTempleContetn:%String,BLTempleID:%String,BLTempleJS:%String")
{
}

ClassMethod FindBLTempleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBLTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBLTempleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBLTempleExecute ]
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

ClassMethod FindBLTempleExecute(ByRef qHandle As %Binary, MapType As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","FindThreeDocAdm","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCDocBLTem(RowID))
		q:RowID=""
		s BLMapType=$P(^DHCDocBLTem(RowID),"^",4)
		continue:(MapType'=BLMapType)
		s BLTempleDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLTempleContetn="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		s BLTempleID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLTempleJS=$g(^DHCDocBLTem(RowID,"JSStr"))
		set Data=$lb(RowID,BLTempleDesc,BLTempleContetn,BLTempleID,BLTempleJS)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCDocAPPBL).FindBLTempeJson("")
ClassMethod FindBLTempeJson(MapType As %String = "")
{
	s JsonObj=[]
	s RowID=0
	for {
		s RowID=$O(^DHCDocBLTemi("LastID",0,RowID))
		q:RowID=""
		s BLMapType=$P(^DHCDocBLTem(RowID),"^",4)
		continue:(MapType'=BLMapType)
		s BLTempleDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLTempleContetn="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		s BLTempleID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLTempleJS=$g(^DHCDocBLTem(RowID,"JSStr"))
		s json={}
		s json.RowID=RowID
		s json.BLTempleDesc=BLTempleDesc
		s json.BLTempleJS=BLTempleJS
		s json.BLTempleID=BLTempleID
		s json.BLTempleContetn=BLTempleContetn
		s json.FatherRowID=0
		s childrenRowID=$O(^DHCDocBLTemi("LastID",RowID,0))
		if (childrenRowID'=""){
			s childrenjson=[]
			s childrenjson=..GetChildrenTempJson(childrenjson,RowID)
			s json.children=childrenjson
		}
		d JsonObj.%Push(json)
	}
	Q JsonObj.%ToJSON()
}

ClassMethod GetChildrenTempJson(fatherjson, FatherRwodID)
{
	s RowID=0
	for {
		s RowID=$O(^DHCDocBLTemi("LastID",FatherRwodID ,RowID))
		q:RowID=""
		s BLMapType=$P(^DHCDocBLTem(RowID),"^",4)
		s BLTempleDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLTempleContetn="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		s BLTempleID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLTempleJS=$g(^DHCDocBLTem(RowID,"JSStr"))
		s json={}
		s json.RowID=RowID
		s json.BLTempleDesc=BLTempleDesc
		s json.BLTempleJS=BLTempleJS
		s json.BLTempleID=BLTempleID
		s json.BLTempleContetn=BLTempleContetn
		s json.FatherRowID=0
		s childrenRowID=$O(^DHCDocBLTemi("LastID",RowID,0))
		b ;09334
		if (childrenRowID'=""){
			s childrenjson=[]
			s childrenjson=..GetChildrenTempJson(childrenjson,RowID)
			s json.children=childrenjson
		}
		d fatherjson.%Push(json)
	}
	q fatherjson
}

ClassMethod InsertBLItemMulit(BLTempRowID, domJson)
{
	s ^tmplog("InsertBLItemMulit")=$lb(BLTempRowID,domJson)
	s domJsonObj={}.%FromJSON(domJson)
	k domJsonAry
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(domJson,.domJsonAry)
	TS
	s domID=""
	for{
		s domID=$o(domJsonAry(domID))	
		Q:domID=""
		s domVal=domJsonAry(domID)
		s forXPrintName=$p(domVal,$c(1),2)
		s domVal=$p(domVal,$c(1),1)
		s BLItemExp="^^"_forXPrintName
		s saveFlag=..InsertBLItem(domID, domVal,"", "", "", "", BLTempRowID,"",BLItemExp) 
		Q:saveFlag'=0 
	}
	i saveFlag'=0 {
		TRO
		Q "-101"_","_domID_","_domVal_","_saveFlag
	}
	TC
	
	Q 0
}

ClassMethod InsertBLItemMulitOld(BLTempRowID, domJson)
{
	s c=domJson
	s jsonstrlen=$length(domJson)
	s tempstr=$EXTRACT(domJson,2,jsonstrlen-1)
	s len=$length(tempstr,",")
	TS
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$P(tempstr1,":",2)
		if name["""" {
			s name=$P(name,"""",2)
		}
		if value["""" {
			s value=$P(value,"""",2)
		}
		s saveFlag=..InsertBLItem(name, value,"", "", "", "", BLTempRowID) 
		Q:saveFlag'=0 
	}
	i saveFlag'=0 {
		TRO
		Q "-101"_","_name
	}
	TC
	
	Q 0
}

/// 增加 病理申请单元素表
/// (描述，html代码 RowID)
/// Creator:qujian
/// CreateTime:20190815
/// w ##class(web.DHCDocAPPBL).InsertBLType("003","ceshi","..script")
ClassMethod InsertBLItem(IDDesc As %String, Desc As %String, Content As %String, RowID As %String = "", Acquir As %String, Save As %String, BLTempRowID As %String, BLItemLength As %String, BLItemExpt As %String = "")
{
	q:((Desc="")) ""
	s BLItemXType=$p(BLItemExpt,"^",1)
	s BLItemXID=$p(BLItemExpt,"^",2)
	s forXPrintName=$p(BLItemExpt,"^",3)
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_DocAppBLItem 
		(APPItem_ID,APPItem_Name,APPItem_ShowJS,APPItem_Acquir,APPItem_Save,APPItem_ForBLTemple,APPItem_Length,APP_ItemXType,APP_ItemXID,APPItem_XPrintName
		) Values(:IDDesc,:Desc,:Content,:Acquir,:Save,:BLTempRowID,:BLItemLength,:BLItemXType,:BLItemXID,:forXPrintName))
	}else{
		&SQL(Update SQLUser.DHC_DocAppBLItem set APPItem_ID=:IDDesc, APPItem_Name=:Desc, 
		APPItem_ShowJS=:Content,APPItem_Acquir=:Acquir,APPItem_Save=:Save,APPItem_Length=:BLItemLength,
		APP_ItemXType=:BLItemXType,APP_ItemXID=:BLItemXID,APPItem_XPrintName=:forXPrintName
		where RowID=:RowID)
		}
	s rtn=SQLCODE
	q rtn
}

/// 删除 病理申请单元素表
/// Creator:qujian
/// CreateTime:20190815
ClassMethod DelectBLItem(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHC_DocAppBLItem where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

/// 查询 病理申请单数据
/// 
Query FindBLItem(BLTempRowID As %String) As %Query(ROWSPEC = "RowID:%String,BLItemID:%String, BLItemDesc:%String,BLItemJSContent:%String,BLItemAcqiur:%String,BLItemSave:%String,BLItemLength:%String,BLItemXType:%String,BLItemXID:%String,BLItemXPrintName:%String")
{
}

ClassMethod FindBLItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBLItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBLItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBLItemExecute ]
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

ClassMethod FindBLItemExecute(ByRef qHandle As %Binary, BLTempRowID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocAPPBL","FindBLItem")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCDocAppBLItemi("BLTemp",BLTempRowID, RowID))
		q:RowID=""
		s BLItemID=$P(^DHCDocAppBLItem(RowID),"^",1)
		s BLItemDesc=$P(^DHCDocAppBLItem(RowID),"^",2)
		s BLItemJSContent="<xmp>"_$g(^DHCDocAppBLItem(RowID,"ShowJS"))_"</xmp>"
		s BLItemAcqiur=$P(^DHCDocAppBLItem(RowID),"^",4)
		s BLItemSave=$P(^DHCDocAppBLItem(RowID),"^",5)
		s BLItemLength=$P(^DHCDocAppBLItem(RowID),"^",7)
		s BLItemXType=$P(^DHCDocAppBLItem(RowID),"^",8)
		s BLItemXID=$P(^DHCDocAppBLItem(RowID),"^",9)
		s BLItemXPrintName=$P(^DHCDocAppBLItem(RowID),"^",10)
		set Data=$lb(RowID,BLItemID, BLItemDesc,BLItemJSContent,BLItemAcqiur,BLItemSave,BLItemLength,BLItemXType,BLItemXID,BLItemXPrintName)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCDocAPPBL).InsertBLType("003","ceshi","..script")
ClassMethod InsertApptNote(MapID As %String, TempID As %String)
{
	q:((MapID="")||(TempID="")) ""
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	if (MapStr=""){
		s MapStr=TempID
	}else{
		Q:(("||"_MapStr_"||")[("||"_TempID_"||")) "repeat"
		s MapStr=MapStr_"||"_TempID
	}
	&SQL(Update SQLUser.DHC_DocAppBLMap set APPMap_ShowTemp=:MapStr
	where RowID=:MapID)
	b ;0932323
	s rtn=SQLCODE
	q rtn
}

ClassMethod DelectApptNote(MapID As %String, TempID As %String)
{
	q:((MapID="")||(TempID="")) ""
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	s StrL=$L(MapStr,"||")
	if (StrL=1){
		s MapStr=""
	}else{
		s ChangeStr=""
		s i=1
		for{
			s TempComonID=$P(MapStr,"||",i)
			q:TempComonID=""
			s i=i+1
			if (TempComonID'=TempID){
				if (ChangeStr=""){s ChangeStr=TempComonID}
				else{
					s ChangeStr=ChangeStr_"||"_TempComonID
					}
			}
		}
		s MapStr=ChangeStr
	}
	&SQL(Update SQLUser.DHC_DocAppBLMap set APPMap_ShowTemp=:MapStr
	where RowID=:MapID)
	s rtn=SQLCODE
	q rtn
}

/// 改变模板顺序
/// w ##class(web.DHCDocAPPBL).ChangeApptNote(4,2,"Down")
ClassMethod ChangeApptNote(MapID As %String, TempID As %String, ChangeType As %String = "")
{
	q:((MapID="")||(TempID=""))
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)

	s StrL=$L(MapStr,"||")
	s ChangeI=""
	s i=1
	for{
		s TempComonID=$P(MapStr,"||",i)
		q:TempComonID=""
		if (TempComonID=TempID){
			s ChangeI=i
		}
		q:ChangeI'=""
		s i=i+1
	}
	if (ChangeType="Up"){
		s UpID=ChangeI-1
		if (UpID>0){
			s UpTemp=$P(MapStr,"||",UpID)
			s $P(MapStr,"||",UpID)=TempID
			s $P(MapStr,"||",ChangeI)=UpTemp
		}
	}else{
		s DownID=ChangeI+1
		b ;09323
		if (DownID<=StrL){
			s DownTemp=$P(MapStr,"||",DownID)
			s $P(MapStr,"||",DownID)=TempID
			s $P(MapStr,"||",ChangeI)=DownTemp
		}
	}
	&SQL(Update SQLUser.DHC_DocAppBLMap set APPMap_ShowTemp=:MapStr
	where RowID=:MapID)
	s rtn=SQLCODE
	q rtn
}

/// 查询 病理申请单模板
/// 
Query FindBLContent(MapID As %String) As %Query(ROWSPEC = "RowID:%String,BLContentDesc:%String,BLContentText:%String")
{
}

ClassMethod FindBLContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBLContentExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBLContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBLContentExecute ]
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

ClassMethod FindBLContentExecute(ByRef qHandle As %Binary, MapID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","FindThreeDocAdm","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	if (MapStr=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		} 
	s i=1
	for{
		s RowID=$P(MapStr,"||",i)
		q:RowID=""
		s i=i+1
		s BLContentDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLContentText="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		set Data=$lb(RowID,BLContentDesc,BLContentText)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// /// 增加 病理申请单医嘱项目元素表
/// (描述，html代码 RowID)
/// Creator:qujian
/// CreateTime:20190815
/// w ##class(web.DHCDocAPPBL).InsertBLType("003","ceshi","..script")
ClassMethod InsertBLArcItem(RowID As %String = "", ArcID, Name, ShowJS As %String, Acquir, Save, Hide, BLTempleRowID, ArcMapRowID, ArcItemID)
{
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_DocAppArcItem 
		(APPItemArc_ID,APPItemArc_Name,APPItemArc_ShowJS,APPItemArc_Acquir,APPItemArc_Save,APPItemArc_Hidden
		,APPItemArc_BLTemple,APPItemArc_Map,APPItemArc_ItmMast
		) Values(:ArcID,:Name,:ShowJS,:Acquir,:Save,:Hide,:BLTempleRowID,:ArcMapRowID,:ArcItemID))
	}else{
		&SQL(Update SQLUser.DHC_DocAppArcItem set 
		APPItemArc_ShowJS=:ShowJS,APPItemArc_Acquir=:Acquir,APPItemArc_Save=:Save,APPItemArc_Hidden=:Hide
		where RowID=:RowID)
		}
	s rtn=SQLCODE
	q rtn
}

ClassMethod DelectBLArcItem(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHC_DocAppArcItem where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

/// 查询 病理申请单医嘱项目元素表
/// 
Query FindBLArcItem(BLTempleRowID As %String, ArcMapRowID As %String, ArcItemID As %String) As %Query(ROWSPEC = "RowID:%String ,ArcID :%String  ,Name:%String ,ShowJSContent:%String ,Acquir:%String ,Save:%String ,Hide:%String ,ArcMapRowID:%String ,BLTempleRowID:%String ,ArcItemID:%String ")
{
}

ClassMethod FindBLArcItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBLArcItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBLArcItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBLArcItemExecute ]
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

ClassMethod FindBLArcItemExecute(ByRef qHandle As %Binary, BLTempleRowID As %String, ArcMapRowID As %String, ArcItemID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","FindThreeDocAdm","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	if (BLTempleRowID="")||(ArcMapRowID="")||(ArcItemID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		} 
	s ^tempqujian("FindBLArcItem")=BLTempleRowID_","_ArcMapRowID_","_ArcItemID
	s RowID="0"
	S IDStr=""
	for{
		s RowID=$O(^DHCDocAppArcItemi("ArcItem",ArcMapRowID,BLTempleRowID,ArcItemID,RowID))
		q:RowID=""
		s ArcID=$P(^DHCDocAppArcItem(RowID),"^",1)
		s Name=$P(^DHCDocAppArcItem(RowID),"^",2)
		s Acquir=$P(^DHCDocAppArcItem(RowID),"^",4)
		s Save=$P(^DHCDocAppArcItem(RowID),"^",5)
		s Hide=$P(^DHCDocAppArcItem(RowID),"^",6)
		s ShowJSContent="<xmp>"_$g(^DHCDocAppArcItem(RowID,"ShowJS"))_"</xmp>"
		if (IDStr="") s IDStr=ArcID
		else  s IDStr=IDStr_"^"_ArcID
		set Data=$lb(RowID,ArcID,Name,ShowJSContent,Acquir,Save,Hide,ArcMapRowID,BLTempleRowID,ArcItemID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	s RowID=0
	for{
		s RowID=$O(^DHCDocAppBLItemi("BLTemp",BLTempleRowID, RowID))
		q:RowID=""
		s ArcID=$P(^DHCDocAppBLItem(RowID),"^",1)
		continue:(("^"_IDStr_"^")[("^"_ArcID_"^"))
		s Name=$P(^DHCDocAppBLItem(RowID),"^",2)
		s ShowJSContent="<xmp>"_$g(^DHCDocAppBLItem(RowID,"ShowJS"))_"</xmp>"
		s Acquir=$P(^DHCDocAppBLItem(RowID),"^",4)
		s Save=$P(^DHCDocAppBLItem(RowID),"^",5)
		set Data=$lb("",ArcID,Name,ShowJSContent,Acquir,Save,"","",BLTempleRowID,"")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetNeedHidenItem(ArcMapRowID, BLTempleRowID, ArcItemID)
{
	s RowID="0"
	S Str=""
	for{
		s RowID=$O(^DHCDocAppArcItemi("ArcItem",ArcMapRowID,BLTempleRowID,ArcItemID,RowID))
		q:RowID=""
		s HiddenFlag=$P(^DHCDocAppArcItem(RowID),"^",6)
		continue:HiddenFlag'="Y"
		s ArcID=$P(^DHCDocAppArcItem(RowID),"^",1)
		if Str="" s Str=ArcID
		else  s Str=Str_"^"_ArcID
	}
	q Str
}

/// 得到是否需要必填的元素:病理菜单->模板维护->元素维护->是否必填
/// w ##Class(web.DHCDocAPPBL).GetAcquireItem(16)
ClassMethod GetAcquireItem(MapID As %String)
{
	s Str=""
	s Mapid=""
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	for{
		 s Mapid=$O(^DHCDocAppBLItemi("Acquir","Y",Mapid))
		 q:Mapid=""
		 s ID=$P(^DHCDocAppBLItem(Mapid),"^",1)
		 s Desc=$P(^DHCDocAppBLItem(Mapid),"^",2)
		 s SubMapID=$P(^DHCDocAppBLItem(Mapid),"^",6)
		 s ItemXType=$P(^DHCDocAppBLItem(Mapid),"^",8)
		 s ItemXID=$P(^DHCDocAppBLItem(Mapid),"^",9)
		 Continue:(("||"_MapStr_"||")'[("||"_SubMapID_"||"))
		 s BLID=$P(^DHCDocBLTem(SubMapID),"^",3)
		 if Str="" s Str=ID_$C(1)_Desc_$C(1)_BLID_$C(1)_ItemXType_$C(1)_ItemXID
		 else  s Str=Str_"^"_ID_$C(1)_Desc_$C(1)_BLID_$C(1)_ItemXType_$C(1)_ItemXID
	}
	q Str
}

/// 得到必填元素:病理菜单->内容维护->项目元素维护->是否必填
ClassMethod GetAcquireArcItem(ArcMapRowID, BLTempleRowID, ArcItemID)
{
	s RowID="0"
	S Str=""
	for{
		s RowID=$O(^DHCDocAppArcItemi("ArcItem",ArcMapRowID,BLTempleRowID,ArcItemID,RowID))
		q:RowID=""
		s AcquireFlag=$P(^DHCDocAppArcItem(RowID),"^",4)
		continue:AcquireFlag'="Y"
		s ArcID=$P(^DHCDocAppArcItem(RowID),"^",1)
		s Desc=$P(^DHCDocAppArcItem(RowID),"^",2)
		if Str="" s Str=ArcID_$C(1)_Desc
		else  s Str=Str_"^"_ArcID_$C(1)_Desc
	}
	q Str
}

/// 得到哪些元素需要保存
/// w ##class(web.DHCDocAPPBL).GetSaveItem(1)
ClassMethod GetSaveItem(MapID As %String)
{
	s Str=""
	s Mapid=""
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	for{
		 s Mapid=$O(^DHCDocAppBLItemi("Save","Y",Mapid))
		 q:Mapid=""
		 s ID=$P(^DHCDocAppBLItem(Mapid),"^",1)
		 s SubMapID=$P(^DHCDocAppBLItem(Mapid),"^",6)
		 Continue:(("||"_MapStr_"||")'[("||"_SubMapID_"||"))
		 if Str="" s Str=ID
		 else  s Str=Str_"^"_ID
	}
	q Str
}

/// 得到是否需要必填的元素:病理菜单->模板维护->限制长度
ClassMethod GetAcquireLength(MapID As %String)
{
	s Str=""
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	s Lenght=""
	for{
		 s Lenght=$O(^DHCDocAppBLItemi("Length",Lenght))
		 q:Lenght=""
		 s Mapid=""
		 for {
			 s Mapid=$O(^DHCDocAppBLItemi("Length",Lenght,Mapid))
			 q:Mapid=""
			 s ID=$P(^DHCDocAppBLItem(Mapid),"^",1)
			 s Desc=$P(^DHCDocAppBLItem(Mapid),"^",2)
			 s SubMapID=$P(^DHCDocAppBLItem(Mapid),"^",6)
			 Continue:(("||"_MapStr_"||")'[("||"_SubMapID_"||"))
			 if Str="" s Str=ID_$C(1)_Desc_$C(1)_Lenght
			 else  s Str=Str_"^"_ID_$C(1)_Desc_$C(1)_Lenght
		 }
	}
	q Str
}

/// 保存或更新新的病理维护
ClassMethod InsertNewBLInformation(EpisodeID, DocID, LocID, Type, OEOrdStr, JsonStr, PisID, BillTypeID As %String = "", ChronicDiagCode As %String = "", DocEntryFlag As %String = "0", EmConsultItm As %String = "")
{
 q:EpisodeID="" ""
 s ^tempqujian("InsertNewBLInformation")=EpisodeID_","_DocID_","_LocID_","_Type_","_OEOrdStr_","_JsonStr_","_ PisID_","_ChronicDiagCode
 s rtn=0,ErrMsg=""
 if $isobject(JsonStr){
	 s JsonStr=JsonStr.Read()
	 }
 ts 
 if (PisID=""){
	s PisNo=##class(web.DHCAppPisMaster).GetCurMaxNo(Type_$zd(+$H,8),"5")  ///单号
	s EpisodeID=EpisodeID ///EpisodeID
	s arUserID=DocID   ///申请医生
	s arLocID=LocID    ///申请科室
	s PisType=Type  ///申请类型
	s arOeori=""
	;s arOeori=$P(OEOrdStr,"^",1)  ///医嘱ID
	s arStatus="N"				     ///申请状态 
	i arOeori'="" s arStatus="Y"
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arUserID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (practiceFlag=1){
		s arStatus="I"	
	}
	s arCreateDate=..%SysDate()   		     ///申请日期
	s arCreateTime=..%SysTime()      ///申请时间 
	s EmgFlag=..CheckSendFlagEmg(JsonStr)
	&SQL(Insert Into SQLUser.DHC_AppPisMaster(AP_Adm_Dr,AP_No,AP_CreateDoc_Dr,AP_CreateDate,AP_CreateTime,AP_Loc_Dr,AP_Status,AP_JsonInfo,AP_Type,AP_EmgFlag)
		values(:EpisodeID,:PisNo,:arUserID,:arCreateDate,:arCreateTime,:arLocID,:arStatus,:JsonStr,:Type,:EmgFlag))
	i SQLCODE'=0  {
		s rtn=SQLCODE
		tro
		q rtn
	}
	s Rowid=+%ROWID  
	s itmmastid=$p(OEOrdStr,"^",1)  /// 医嘱项ID
	s arLocID=$p(OEOrdStr,"^",2)    /// 接收科室ID
	s arOeori=$p(OEOrdStr,"^",3)   /// 医嘱ID
	s arChildSub=$o(^DHCAPPPM(Rowid,"A",""),-1)+1
	&SQL(Insert Into SQLUser.DHC_AppPisArc(AP_ParRef_Dr,AP_ChildSub,AP_Arc_Dr,AP_Loc_Dr,AP_OrdItem,AP_OrdItemFlag)
		values(:Rowid,:arChildSub,:itmmastid,:arLocID,:arOeori,:DocEntryFlag))
	i SQLCODE'=0  {
		s rtn=SQLCODE
		tro
		q rtn
	}
	if ((DocEntryFlag=0)&&(practiceFlag'=1)){
		s Err = ##Class(web.DHCAppPisMaster).InsPisOeori(Rowid,BillTypeID,"",ChronicDiagCode,"",.ErrMsg,EmConsultItm)
		i Err'=0 tro
		Q:Err'=0 "-12^"_ErrMsg
	}
	
}else{
	s arUserID=DocID    ///申请医生
	s arStatus=$p(^DHCAPPPM(PisID),"^",9)
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arUserID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (practiceFlag=1){
		s arStatus="I"	
	}else{
		if (arStatus="I"){s arStatus="N"}
	}
	&SQL(Update SQLUser.DHC_AppPisMaster Set AP_Status=:arStatus,AP_CreateDoc_Dr=:arUserID,AP_JsonInfo=:JsonStr Where AP_RowID=:PisID)
	i SQLCODE'=0  {
		s rtn=SQLCODE
		tro
		q rtn
	}
	s Rowid=+%ROWID 
	s ApStatus = $p(^DHCAPPPM(Rowid),"^",9)
	if (ApStatus="Y"){
		s subpID=$o(^DHCAPPPM(PisID,"A",""))
		s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
		if (Oeori'="") {s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000042",Oeori)}
		d ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",Rowid,arUserID)
	}
	s subpID=$o(^DHCAPPPM(PisID,"A",""))
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	if (Oeori="")&&(practiceFlag'=1){
		s Err = ##Class(web.DHCAppPisMaster).InsPisOeori(Rowid,BillTypeID,"",ChronicDiagCode,arUserID,.ErrMsg)
		i Err'=0 tro
		Q:Err'=0 "-12^"_ErrMsg
	}
		 
}
  tc
	q SQLCODE_"^"_Rowid
}

/// 发送新病理申请单
ClassMethod InsSendFlag(PisID As %String, UserID As %String, BillTypeID As %String = "") As %String
{
	s Err=0
	Q:$p(^DHCAPPPM(PisID),"^",9)="Y" "-1" 
	TS

	/// 更新发送状态
	s ApStatus="Y"
	&SQL(update SQLUser.DHC_AppPisMaster set AP_Status=:ApStatus where AP_RowID=:PisID)
	s subpID=$o(^DHCAPPPM(PisID,"A",""))
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	if (Oeori=""){
		s ErrMsg=""
		/// 插入医嘱
		s Err = ##Class(web.DHCAppPisMaster).InsPisOeori(PisID,BillTypeID,"","",UserID,.ErrMsg)
		i Err'=0 tro
		Q:Err'=0 "-12^"_ErrMsg
	}
	TC
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	if (Oeori'="") {s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000042",Oeori)}
	d ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",PisID,UserID)
	
	Q Err
}

/// 打印数据提取
/// w ##Class(web.DHCDocAPPBL).GetPisPrintCon("150")
ClassMethod GetPisPrintCon(PisID As %String, PrintUserID As %String = "") As %String
{
	/// 病人信息
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=""
	if UserID'="" s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	s HospID=+$p(^CTLOC(ReqLocID),"^",22)  /// 医院ID
	s HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	s BillType=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason($g(EpisodeID))     /// 费别
	;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号
	s PatDiagDesc1="",PatDiagDesc2=""
	s MRADMID=$p(^PAADM(EpisodeID),"^",61) 
	s PatDiagDesc=##class(DHCDoc.OPDoc.TreatPrint).GetMRDiagnosDesc(MRADMID,";") //诊断 web.DHCSTKUTIL
	i $L(PatDiagDesc)>48 D
	.s PatDiagDesc1=$E(PatDiagDesc,1,48)
	.s PatDiagDesc2=$E(PatDiagDesc,48,$L(PatDiagDesc))
	E  s PatDiagDesc1=PatDiagDesc
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s PatLev=$p(PatEncryptLevel,"^",2)
		s PatScrLev=$p(PatEncryptLevel,"^",4)
	}
	s BarCode=PatNo
	s subpID=$o(^DHCAPPPM(PisID,"A",""))
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	s PrintNo=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("PrintNo")
	if (PrintNo="orderitem"){s BarCode=$p(Oeori,"||",1)_"-"_$p(Oeori,"||",2)}elseif (PrintNo="papmino"){s BarCode=PatNo}elseif (PrintNo="adm"){s BarCode=EpisodeID}
	s PrintNum=..GetPrintTime(PisID)+1
	s PrintUserName=""
	if PrintUserID'= "" s PrintUserName=$p(^SSU("SSUSR",PrintUserID),"^",2)
	s PrintDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(+$H) 
	s PrintTime=..%ZT(..%SysTime(),2)
	s MyPara = "BarCode"_$C(2)_"*"_BarCode_"*^"_"PatNo"_$C(2)_PatNo_"^"_"PatName"_$C(2)_PatName_"^"_"PatSex"_$C(2)_PatSex_"^"_"PatAge"_$C(2)_PatAge
	s MyPara = MyPara _"^PatLoc"_$C(2)_PatLoc_"^PatWard"_$C(2)_PatWard_"^PatBed"_$C(2)_PatBed_"^PatTelH"_$C(2)_PatTelH
	s MyPara = MyPara _"^PatBod"_$C(2)_PatBod_"^PatAddr"_$C(2)_ReqLoc_"^ReqLoc"_$C(2)_ReqLoc_"^BillType"_$C(2)_BillType
	s MyPara = MyPara _"^MedicareNo"_$C(2)_MedicareNo_"^PisReqNo"_$C(2)_PisReqNo_"^UserName"_$C(2)_UserName_"^CreatDate"_$C(2)_CreatDate
	s MyPara = MyPara _"^CreatTime"_$C(2)_CreatTime_"^EpisodeID"_$C(2)_EpisodeID_"^PatDiagDesc1"_$C(2)_PatDiagDesc1_"^PatDiagDesc2"_$C(2)_PatDiagDesc2
	s MyPara = MyPara _"^PatLev"_$C(2)_$g(PatLev)_"^PatScrLev"_$C(2)_$g(PatScrLev)
	s MyPara = MyPara _"^PrintNum"_$C(2)_$g(PrintNum)_"^PrintUserName"_$C(2)_$g(PrintUserName)_"^PrintDateTime"_$C(2)_$g(PrintDate)_" "_$g(PrintTime)
	s MyPara = MyPara _"^hopName"_$C(2)_$g(HospDesc)
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	k ArrJsonStr,TmpMorToDeaProArr,TmpDisAndTreProArr,TmpPhyAndLabTestArr,TmpPisTesDiagArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	b //45
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		;b ;092332
		s PrintID=$g(ArrJsonStr(ID,"ID"))
		s val=$G(ArrJsonStr(ID))
		continue:(PrintID="OtherInfo")
		if (PrintID="PrintInfo"){
			k ArrOtherPrint
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherPrint)
			s PrintID=""
			for {
				s PrintID=$O(ArrOtherPrint(PrintID))
				q:PrintID=""
				Continue:PrintID="List"
				s MyPara = MyPara _"^"_PrintID_$C(2)_$g(ArrOtherPrint(PrintID))
			}
		}else{
			if PrintID="TesItemDesc" s PrintID="ItemDesc"
			s PrintDesc=$g(ArrJsonStr(ID,"Desc"))
			if (PrintID="PauFlag")||(PrintID="UnknownFlag")||(PrintID="BloodFlag")||(PrintID="TakBack")||(PrintID="TakHosp") {
				s PrintDesc=$case(ArrJsonStr(ID,"Val"),"true":"√",:"")
			}
			//自发病至死亡病程时日
			if (PrintID="MorToDeaPro") {
				s MorToDeaPro=ArrJsonStr(ID,"Val")
				D ##Class(web.DHCAPPExaRepCom).splitString(MorToDeaPro, "86", "10", .TmpMorToDeaProArr)  /// 拆分字符串
				D ##class(web.DHCAPPPrintCom).TrsTmpArr("MorToDeaPro", .TmpMorToDeaProArr)
				for MorToDeaProIndex=1:1:$l($g(TmpMorToDeaProArr("MorToDeaProKey"))) {
					s MyPara = MyPara _"^"_$p(TmpMorToDeaProArr("MorToDeaProKey"),"^",MorToDeaProIndex)_$C(2)_$p(TmpMorToDeaProArr("MorToDeaProVal"),"^",MorToDeaProIndex)
				}
			}elseif (PrintID="DisAndTrePro"){ //病史及治疗经过
				s DisAndTrePro=ArrJsonStr(ID,"Val")
				D ##Class(web.DHCAPPExaRepCom).splitString(DisAndTrePro, "86", "10", .TmpDisAndTreProArr)  /// 拆分字符串
				D ##class(web.DHCAPPPrintCom).TrsTmpArr("DisAndTrePro", .TmpDisAndTreProArr)
				for DisAndTreProIndex=1:1:$l($g(TmpDisAndTreProArr("DisAndTreProKey"))) {
					s MyPara = MyPara _"^"_$p(TmpDisAndTreProArr("DisAndTreProKey"),"^",DisAndTreProIndex)_$C(2)_$p(TmpDisAndTreProArr("DisAndTreProVal"),"^",DisAndTreProIndex)
				}
			}elseif (PrintID="PhyAndLabTest"){ //临床体格检查及化验检查
				s PhyAndLabTest=ArrJsonStr(ID,"Val")
				D ##Class(web.DHCAPPExaRepCom).splitString(PhyAndLabTest, "86", "10", .TmpPhyAndLabTestArr)  /// 拆分字符串
				D ##class(web.DHCAPPPrintCom).TrsTmpArr("PhyAndLabTest", .TmpPhyAndLabTestArr)
				for PhyAndLabTestIndex=1:1:$l($g(TmpPhyAndLabTestArr("PhyAndLabTestKey"))) {
					s MyPara = MyPara _"^"_$p(TmpPhyAndLabTestArr("PhyAndLabTestKey"),"^",PhyAndLabTestIndex)_$C(2)_$p(TmpPhyAndLabTestArr("PhyAndLabTestVal"),"^",PhyAndLabTestIndex)
				}
			}else{
				s MyPara = MyPara _"^"_PrintID_$C(2)_PrintDesc
			}
		}
	}
	/// 临床诊断
	if (PatDiagDesc'="") {
		D ##Class(web.DHCAPPExaRepCom).splitString(PatDiagDesc, "86", "10", .TmpPisTesDiagArr)  /// 拆分字符串
		D ##class(web.DHCAPPPrintCom).TrsTmpArr("PisTesDiag", .TmpPisTesDiagArr)
		for PisTesDiagIndex=1:1:$l($g(TmpPisTesDiagArr("PisTesDiagKey"))) {
			s MyPara = MyPara _"^"_$p(TmpPisTesDiagArr("PisTesDiagKey"),"^",PisTesDiagIndex)_$C(2)_$p(TmpPisTesDiagArr("PisTesDiagVal"),"^",PisTesDiagIndex)
		}
	}
	q MyPara
}

/// w ##Class(web.DHCDocAPPBL).GetPrintList("150")
ClassMethod GetPrintList(PisID As %String) As %String
{
	s MyList=""
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		;b ;092332
		s PrintID=$g(ArrJsonStr(ID,"ID"))
		s val=$G(ArrJsonStr(ID))
		continue:(PrintID="OtherInfo")
		if (PrintID="PrintInfo"){
			k ArrOtherPrint
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherPrint)
			s PrintID=""
			for {
				s PrintID=$O(ArrOtherPrint(PrintID))
				q:PrintID=""
				if PrintID="List" s MyList=$replace($g(ArrOtherPrint(PrintID)),"*AABCD*",$C(2))
				}
		}
		}
	q MyList
}

/// Descript: 病理申请单打印模板
/// w ##Class(web.DHCDocAPPBL).GetPisPrintTemp("CYT")
ClassMethod GetPisPrintTemp(PisType As %String, Adm As %String, CallFalg As %String = "") As %String
{
	s itmArcCatID=$o(^DHCAPARCCA(0,"Code",PisType,""))
	Q:itmArcCatID="" ""
	s TempID=""
	s AdmType=$P(^PAADM(Adm),"^",2)
	s PatientID=$p(^PAADM(Adm),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	s PrintTemp=""
	s LastPrintTemp=""
	s FristPrintTemp=""
	s SecordPrintTemp=""
	for {
		s TempID=$o(^DHCAPPPRT(0,"Arc",itmArcCatID,TempID))
		q:TempID=""
		if (CallFalg'=""){
			s Calltemp=$p(^DHCAPPPRT(TempID),"^",5)
			continue:Calltemp'="Y"
			s PrintTemp=$p(^DHCAPPPRT(TempID),"^",2)
		}else{
			s type=$p(^DHCAPPPRT(TempID),"^",3)
			s sex=$p(^DHCAPPPRT(TempID),"^",4)
			s Calltemp=$p(^DHCAPPPRT(TempID),"^",5)
			continue:Calltemp="Y"
			if ((sex=PatSex)&&(type=AdmType)){
				s FristPrintTemp=$p(^DHCAPPPRT(TempID),"^",2)
			}elseif((sex=PatSex)||(type=AdmType)){
				s SecordPrintTemp=$p(^DHCAPPPRT(TempID),"^",2)
			}else{s LastPrintTemp=$p(^DHCAPPPRT(TempID),"^",2)
			}
			
			}
		}
	if (PrintTemp=""){
		if (LastPrintTemp'="") s PrintTemp=LastPrintTemp
		if (SecordPrintTemp'="") s PrintTemp=SecordPrintTemp
		if (FristPrintTemp'="") s PrintTemp=FristPrintTemp
		}
	Q PrintTemp
}

ClassMethod GetReqJsonStr(PisID)
{
	q:PisID=""
	s itemReqJsonStr=$g(^DHCAPPPM(PisID,"JsonInfo"))
	s PisStatus=$p(^DHCAPPPM(PisID),"^",9)
	s PisNo=$p(^DHCAPPPM(PisID),"^",4)
	s subpID=$o(^DHCAPPPM(PisID,"A",""))
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	s PisStatusSign="",CH="0"
	f  s CH=$o(^DHCAPPPM(PisID,"A",CH))  Q:CH=""  D
	.s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
	.s PisStatusSign = ##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,"")
	s RetObj=[]
	s obj={}
	s obj.PisStatus=PisStatus
	s obj.PisNo=PisNo
	s obj.oeori=Oeori
	s obj.itemReqJsonStr=itemReqJsonStr
	s obj.PisStatusSign=PisStatusSign
	d RetObj.%Push(obj)
	Q RetObj.%ToJSON()
}

ClassMethod InsertNewBLInformationDoc(Pid, PisType, JsonStr)
{
	s Index=$I(^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType))
	s ^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType,Index)=JsonStr
	Q 0
}

/// 清除保存病理申请的缓存数据
ClassMethod ClearNewBLInformationDoc(Pid)
{
	k ^TMP("DHCAPP","web.DHCAppPisMaster",Pid)
	Q 0
}

/// w ##Class(web.DHCDocAPPBL).ToPisSystem("2250||1")
ClassMethod ToPisSystem(Oeori As %String) As %String
{
	Q:Oeori="" ""
	s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	Q:ID="" ""
	Q:$p(^DHCAPPPM(ID),"^",9)="D" "-101"     /// 申请单已取消
	s PisReqNoXml=..GetPisReqNoXml(ID,Oeori) /// 申请单内容XML串
	Q PisReqNoXml
}

// w ##Class(web.DHCDocAPPBL).PrintBarCode("213","150||351")

ClassMethod PrintBarCode(PisID As %String, Oeori As %String)
{
	if ((PisID="")&&(Oeori="")) q ""
	if (PisID=""){
		s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	}
	q:PisID="" ""
	s subpID=$o(^DHCAPPPM(PisID,"A",""))
	s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
	s PrtintCodeStlye=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("PrintStyle")
	if (PrtintCodeStlye="printstyleoff"){s XmlTemp="DHCNursePathBarLv"}else{s XmlTemp="DHCNursePathBarLh"}
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	s bedCode=""
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)_"床"   /// 床号描述
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	s SpecStr=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		;b ;092332
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
		if ToPisID="recLoc" s reclocDesc=$g(ArrJsonStr(ID,"Desc")) 
		if ToPisID="TesItemDesc" s arcimDesc=$g(ArrJsonStr(ID,"Val")) 
		if (ToPisID="OtherInfo"){
			k ArrOtherInfo
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherInfo)
			s OtherID=""
			for {
				s OtherID=$O(ArrOtherInfo(OtherID))
				q:OtherID=""
				b ;09
				if (OtherID="PisReqSpec"){
					s PisReqSpec=$g(ArrOtherInfo(OtherID))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(1), $c(1))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(2), $c(2))
					s OrderID=+Oeori_"-"_$P(Oeori,"||",2)
					for i=1:1:$L(PisReqSpec,$C(2)){
						s OneSpec=$P(PisReqSpec,$C(2),i)
						if (SpecStr=""){
							s SpecStr="pathNo"_$C(2)_""_OrderID_"-"_$P(OneSpec,$c(1),1)_""_"^"_"specDesc"_$C(2)_$P(OneSpec,$c(1),2)_"^"_"examDesc"_$C(2)_$P(OneSpec,$c(1),3)_"^"_"pathNo1"_$C(2)_OrderID_"-"_$P(OneSpec,$c(1),1)
						}else{
							s SpecStr=SpecStr_$C(3)_"pathNo"_$C(2)_OrderID_"-"_$P(OneSpec,$c(1),1)_"^"_"specDesc"_$C(2)_$P(OneSpec,$c(1),2)_"^"_"examDesc"_$C(2)_$P(OneSpec,$c(1),3)_"^"_"pathNo1"_$C(2)_OrderID_"-"_$P(OneSpec,$c(1),1)
						}
					}
				}
			}
		}
		/*if (ToPisID="PrintInfo"){
			k ArrOtherPrint
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherPrint)
			s OtherID=""
			for {
				s OtherID=$O(ArrOtherPrint(OtherID))
				q:OtherID=""
				if (OtherID="PisReqSpec"){
					s PisReqSpec=$g(ArrOtherPrint(OtherID))
					s OrderID=+Oeori_"-"_$P(Oeori,"||",2)
					for i=1:1:$L(PisReqSpec,","){
						s OneSpec=$P(PisReqSpec,",",i)
						if (SpecStr=""){
							s SpecStr="pathNo"_$C(2)_""_OrderID_"-"_i_""_"^"_"specDesc"_$C(2)_$P(OneSpec," ",1)_"^"_"examDesc"_$C(2)_""_"^"_"pathNo1"_$C(2)_OrderID_"-"_i
						}else{
							s SpecStr=SpecStr_$C(3)_"pathNo"_$C(2)_""_OrderID_"-"_i_""_"^"_"specDesc"_$C(2)_$P(OneSpec," ",1)_"^"_"examDesc"_$C(2)_""_"^"_"pathNo1"_$C(2)_OrderID_"-"_i
						}
					}
				}
			}
		}*/
	}
	s BasInfo="PatNo"_$C(2)_PatNo_"^"_"patName"_$C(2)_PatName_"^"_"sex"_$C(2)_PatSex_"^"_"locDesc"_$C(2)_ReqLoc_"^"_"age"_$C(2)_PatAge
	s BasInfo = BasInfo _"^reclocDesc"_$C(2)_reclocDesc_"^bedCode"_$C(2)_PatBed_"^regNo"_$C(2)_PatNo_"^arcimDesc"_$C(2)_arcimDesc
	s rtn=XmlTemp_$C(1)_BasInfo_$C(1)_SpecStr
	q rtn
}

ClassMethod GetPisReqNoXml(PisID As %String, Oeori As %String) As %String
{
	/// 病人信息
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",1)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",1)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",1) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=$zd(CreatDate,3)
	//s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",1)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	s:PatBod'="" PatBod=$zd(PatBod,3)
	//i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号
	
	s MRADMID=$p(^PAADM(EpisodeID),"^",61) 
	s PatDiagDesc=""
	s PatDiagDesc=##class(DHCDoc.OPDoc.TreatPrint).GetMRDiagnosDesc(MRADMID,",")   /// 诊断
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s PisType=$p(^DHCAPPPM(PisID),"^",20)    /// 申请单类型
	s PisStatus=$p(^DHCAPPPM(PisID),"^",9)   /// 申请单状态
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID)     /// 病理申请医嘱项目内容
	s PisArcList=$REPLACE(PisArcList,"^","#")
	/// 申请单内容
	s (FrostFlag,EmgFlag,MedRecord,MedDiag,HepatitisB,OperRes,InfDisHis,FoundDate,MorToDeaPro,DisAndTrePro,PhyAndLabTest,FinTakRes)=""
	s (InsDoc,InsHosp,SpecExaRes,ConsNote,ConsStaff,PisGynWon,LastMensDate,MensDate,PisCutBas,SepDate,SepTime,FixDate,FixTime,BLocDesc)=""
	s (DocName,Position,Type,PisTumour,TFoundDate,PisReqSpec,PisTreMet,PisTesItmMet,PisTesDiag,PisPatRec,PisPatInfDis)=""
	s (SamplingDeptCode,SamplingDoctorCode,PisCutBasType,MensDate,PreTimes,LyTimes,PauFlag,UnknownFlag,BloodFlag)=""
	s (OperName,OperPart,OperTime,OperTele,OperAim,OperWay,OperRoom,OperUser,SentOrder,PisTestItem)=""
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		;b ;092332
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
		if ToPisID="FrostFlag" {
			if ($g(ArrJsonStr(ID,"Val"))="true"){s FrostFlag="Y" }else{s FrostFlag="N" } /// 冰冻标志
		}
		if ToPisID="EmgFlag"{
			if ($g(ArrJsonStr(ID,"Val"))="true"){s EmgFlag="Y" }else{s EmgFlag="N" } /// 加急标志
			} 
		if ToPisID="MedRecord" s MedRecord=$g(ArrJsonStr(ID,"Val")) /// 临床病历
		if ToPisID="MedDiag" s MedDiag=$g(ArrJsonStr(ID,"Val")) /// 临床诊断
		if ToPisID="HepatitisB" s HepatitisB=$g(ArrJsonStr(ID,"Val")) /// 乙肝病史
		if ToPisID="OperRes" s OperRes=$g(ArrJsonStr(ID,"Val")) /// 手术所见
		if ToPisID="InfDisHis" s InfDisHis=$g(ArrJsonStr(ID,"Val")) /// 传染病史
		if ToPisID="FoundDate" s FoundDate=$g(ArrJsonStr(ID,"Val"))
		/// 病理申请尸检信息内容
		if ToPisID="MorToDeaPro" s MorToDeaPro=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="DisAndTrePro" s DisAndTrePro=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="PhyAndLabTest" s PhyAndLabTest=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="FinTakRes" s FinTakRes=$g(ArrJsonStr(ID,"Val"))
		/// 病理申请会诊信息内容
		if ToPisID="InsDoc" s InsDoc=$g(ArrJsonStr(ID,"Desc"))
		if ToPisID="InsHosp" s InsHosp=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="PreMedRecord" s SpecExaRes=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="SpecExaRes" s SpecExaRes=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="ConsNote" s ConsNote=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="ConsStaff" s ConsStaff=$g(ArrJsonStr(ID,"Desc"))
		/// 病理申请妇科信息内容
		if ToPisID="LastMensDate" s LastMensDate=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="MensDate" s MensDate=$g(ArrJsonStr(ID,"Val"))
		/// 病理申请取材信息内容
		if ToPisID="SepDate" s SepDate=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="SepTime" s SepTime=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="FixDate" s FixDate=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="FixTime" s FixTime=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="BLocDesc" s BLocDesc=$g(ArrJsonStr(ID,"Desc"))
		if ToPisID="Position" s Position=$g(ArrJsonStr(ID,"Desc"))
		if ToPisID="Type" s Type=$g(ArrJsonStr(ID,"Val"))
		/// 病理申请肿瘤信息内容
		if ToPisID="PisTumour" s PisTumour=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="TFoundDate" s TFoundDate=$g(ArrJsonStr(ID,"Val"))
		if ToPisID="PisTreMet" s PisTreMet=$g(ArrJsonStr(ID,"Val")) /// 治疗方式
		if ToPisID="PisTesItmMet" s PisTesItmMet=$g(ArrJsonStr(ID,"Val"))   /// 检测方法
		if ToPisID="PisTesDiag" s PisTesDiag=$g(ArrJsonStr(ID,"Val")) /// 临床诊断
		if ToPisID="PisPatRec" s PisPatRec=$g(ArrJsonStr(ID,"Val")) /// 病人病历
		if ToPisID="LocID" s SamplingDeptCode=$g(ArrJsonStr(ID,"Desc")) //取材科室
		if ToPisID="DocDr" s SamplingDoctorCode=$g(ArrJsonStr(ID,"Desc")) //取材医生
		if ToPisID="MensDate" s MensDate=$g(ArrJsonStr(ID,"Val")) //末次月经
		if ToPisID="PreTimes" s PreTimes=$g(ArrJsonStr(ID,"Val")) //胎
		if ToPisID="LyTimes" s LyTimes=$g(ArrJsonStr(ID,"Val")) //产
		if ToPisID="PauFlag" s PauFlag=$g(ArrJsonStr(ID,"Val")) //绝经
		if ToPisID="UnknownFlag" s UnknownFlag=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="BloodFlag" s BloodFlag=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperName" s OperName=$g(ArrJsonStr(ID,"Desc")) //不详
		if ToPisID="OperPart" s OperPart=$g(ArrJsonStr(ID,"Val")) //不详

		if ToPisID="OperTime" s OperTime=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperTele" s OperTele=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperAim" s OperAim=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperWay" s OperWay=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperRoom" s OperRoom=$g(ArrJsonStr(ID,"Val")) //不详
		if ToPisID="OperUser" s OperUser=$g(ArrJsonStr(ID,"Desc")) //不详
		if (ToPisID="OtherInfo"){
			k ArrOtherInfo
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherInfo)
			s OtherID=""
			for {
				s OtherID=$O(ArrOtherInfo(OtherID))
				q:OtherID=""
				if (OtherID="PisReqSpec"){
					s PisReqSpec=$g(ArrOtherInfo(OtherID))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(1), $c(1))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(2), $c(2))
					/*k ArrPisSpec
					d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrOtherInfo(OtherID)),.ArrPisSpec)
					b ;09223s 
					s PisSpecID=""
					for {
						s PisSpecID=$O(ArrPisSpec(PisSpecID))
						q:PisSpecID=""
						s PisSpecNo=$p(ArrPisSpec(PisSpecID),"^",1)
						s PisSpecName=$p(ArrPisSpec(PisSpecID),"^",3)
						s PisSpecQty=$p(ArrPisSpec(PisSpecID),"^",5)
						s PisSpecSliType=$p(ArrPisSpec(PisSpecID),"^",4)
						s PisSpecPisNo=$p(ArrPisSpec(PisSpecID),"^",2)
						s PisSpecRemark=$p(ArrPisSpec(PisSpecID),"^",8)
						s mTmpData=PisSpecNo_"#"_PisSpecName_"#"_"#"_PisSpecQty_"#"_PisSpecSliType_"#"_PisSpecPisNo_"#"_PisSpecRemark
						i PisReqSpec="" s PisReqSpec=mTmpData
						E  s PisReqSpec=PisReqSpec_"@"_mTmpData
						}*/
				}
			}
		}
		if (ToPisID="PrintInfo"){
			k ArrOtherPrint
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherPrint)
			s PrintID=""
			for {
				s PrintID=$O(ArrOtherPrint(PrintID))
				q:PrintID=""
				;if PrintID="PisPatInfDis" s InfDisHis=$g(ArrOtherPrint(PrintID)) /// 传染病史
				if PrintID="PisPatInfDis" s PisPatInfDis=$g(ArrOtherPrint(PrintID)) /// 传染病史
				if PrintID="PisCutBasType" s PisCutBasType=$g(ArrOtherPrint(PrintID)) /// 标本类型
				if PrintID="TesDiag" s PisTesDiag=$g(ArrOtherPrint(PrintID)) /// 临床诊断
				if PrintID="PisPatRec" s PisPatRec=$g(ArrOtherPrint(PrintID)) /// 病人病历
		 		if PrintID="PisTestItem" s PisTestItem=$g(ArrOtherPrint(PrintID)) /// 分子病理检测项目
				if (PrintID="SentOrder") {
					if ($g(ArrOtherPrint(PrintID))="加急") s EmgFlag="Y"
					if ($g(ArrOtherPrint(PrintID))="冰冻") s FrostFlag="Y"
					s SentOrder=$g(ArrOtherPrint(PrintID)) ///送检目的
					}
		 		}
		}
		}
	s PisGynWon=","_MensDate_","_PreTimes_","_LyTimes_","_PauFlag_","_UnknownFlag_","_BloodFlag
	if OperName'="" s OperRes=OperRes_","_OperName
	if OperPart'="" s OperRes=OperRes_","_OperPart
	if OperTime'="" s OperRes=OperRes_","_OperTime
	if OperTele'="" s OperRes=OperRes_","_OperTele
	if OperAim'="" s OperRes=OperRes_","_OperAim
	if OperWay'="" s OperRes=OperRes_","_OperWay
	if OperRoom'="" s OperRes=OperRes_","_OperRoom
	if OperUser'="" s OperRes=OperRes_","_OperUser
	;i PisTesDiag="" s PisTesDiag=MedDiag
	;i PisTesDiag="" s PisTesDiag=PatDiagDesc
	s mListData=$g(PatNo)_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s mListData=mListData_"^"_ReqLoc_"^"_BillType_"^"_MedicareNo_"^"_PisReqNo_"^^"_UserCode_"^"_UserName_"^"_CreatDate_"^"_CreatTime
	s mListData=mListData_"^"_EpisodeID_"^"_PisReqNo_"^"_OperRes_"^"_PisTumour_"^"_PisGynWon_"^"_MedRecord_"^"_EmgFlag_"^"_FrostFlag
	s mListData=mListData_"^"_SepDate_" "_SepTime_"^"_FixDate_" "_FixTime_"^"_SamplingDeptCode_"^"_SamplingDoctorCode_"^"_SepDate_"^"_PisPatInfDis_"^"_PisPatRec
	s mListData=mListData_"^"_FoundDate_"^"_PisTesItmMet_"^"_PisTesDiag_"^"_PisTreMet_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff_"^"_Position_"^"_Type
	s mListData=mListData_"^"_MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_FinTakRes_"^"_PisReqSpec_"^"_PisArcList
	s mListData=mListData_"^"_InsHosp_"^"_InsDoc_"^"_PisType_"^"_PisStatus_"^"_PisCutBasType
	s mListData=mListData_"^"_SentOrder_"^"_PisTestItem
	Q mListData
}

/// 记录打印次数
ClassMethod RecordPrintTime(PisID, UserID)
{
	q:PisID="" ""
	if ($G(^DHCDocAPPPisPrintNum(PisID))=""){
		s ^DHCDocAPPPisPrintNum(PisID)=1
		}else{
		s ^DHCDocAPPPisPrintNum(PisID)=$G(^DHCDocAPPPisPrintNum(PisID))	+1
		}
	s Number=^DHCDocAPPPisPrintNum(PisID)
	s ^DHCDocAPPPisPrintNum(PisID,Number)=UserID_"^"_$h
	q 0
}

ClassMethod GetPrintTime(PisID)
{
	q:PisID="" ""
	q $G(^DHCDocAPPPisPrintNum(PisID))
}

/// 判断送检目的是否为加急
ClassMethod CheckSendFlagEmg(JsonStr)
{
	q:JsonStr="" "N"
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s Emgflag="N"
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		;b ;092332
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
		if (ToPisID="PrintInfo"){
			k ArrOtherPrint
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherPrint)
			s PrintID=""
			for {
				s PrintID=$O(ArrOtherPrint(PrintID))
				q:PrintID=""
				if ((PrintID="SentOrder")&&($g(ArrOtherPrint(PrintID))["加急")) s Emgflag="Y"
		 		}
		}
	}
	q Emgflag
}

/// 根据病理申请ID获取申请单对应的就诊ID^申请单类型^打印模板^知情同意书模板
ClassMethod GetPisPrintInfo(PisID)
{
	Q:PisID="" ""
	s PisType=$p(^DHCAPPPM(PisID),"^",20)    /// 申请单类型
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PisPrintTemp=##Class(web.DHCDocAPPBL).GetPisPrintTemp(PisType,EpisodeID)
	s PisPrintCall=##Class(web.DHCDocAPPBL).GetPisPrintTemp(PisType,EpisodeID,1)
	Q EpisodeID_"^"_PisType_"^"_PisPrintTemp_"^"_PisPrintCall
}

/// 判断是否有标本
ClassMethod CheckForPisSpec(PisID)
{
	s rtn =0 
	q:PisID="" rtn
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
			if (ToPisID="OtherInfo"){
				k ArrOtherInfo
				d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherInfo)
				s OtherID=""
				for {
					s OtherID=$O(ArrOtherInfo(OtherID))
					q:OtherID=""
					if (OtherID="PisReqSpec"){
						s PisReqSpec=$g(ArrOtherInfo(OtherID))
						if PisReqSpec'="" s rtn=1
					}
				}
			}
		}
	q rtn
}

}
