Class DHCDoc.DHCDocConfig.CookModeCharge Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->草药加工方式收费设置 草药加工方式
Query GetCNMedCookMode() As %Query(ROWSPEC = "Code,Desc")
{
}

ClassMethod GetCNMedCookModeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetCNMedCookMode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s str=$g(^DHCDocConfig("CNMedCookMode"))
    s Code=0
    For i=1:1:$l(str,"^") d
    .s value=$p(str,"^",i)
    .s Code=+$p(value,$c(1),1)
    .;s Code=Code+1
    .s Desc=$p(value,$c(1),2)
	.Do OutputRowGetCNMedCookMode
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCNMedCookMode
	set Data=$lb($g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCNMedCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCNMedCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCNMedCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCNMedCookModeExecute ]
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
/// date:2015-07-06
/// desc:医生站设置程序->草药加工方式收费设置 限定单位
Query GetCTUomList(value As %String, CookMode As %String, HospId As %String = "") As %Query(ROWSPEC = "CTUOMRowId:%String,CTUOMDesc:%String,selected:%Boolean")
{
}

ClassMethod GetCTUomListExecute(ByRef qHandle As %Binary, value As %String, CookMode As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetCTUomList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s CalBaseUomRowId=..GetCMBaseUomRowId("WeightUom",HospId) //重量单位类型对应的基本单位
    s DurBaseUomRowId=..GetCMBaseUomRowId("DurUom",HospId)  //付数单位类型对应的基本单位
    s CTUOMRowId=0  f  s CTUOMRowId=$o(^CT("UOM",CTUOMRowId)) q:CTUOMRowId=""  d
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_UOM",CTUOMRowId,HospId)="N"
    .Q:($$ConvFac^ST02(CTUOMRowId,CalBaseUomRowId)="")&&($$ConvFac^ST02(CTUOMRowId,DurBaseUomRowId)="")
    .s CTUOMDesc=$p(^CT("UOM",CTUOMRowId),"^",2)
    .s selected=0
    .i CookMode'="" d
    ..s str=..%GetConfig1(value,CookMode,HospId)
    ..i CTUOMRowId=$p($g(str),"^",1)  s selected=1
	.Do OutputRowGetCTUomList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTUomList
	set Data=$lb($g(CTUOMRowId),$g(CTUOMDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTUomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTUomListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTUomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTUomListExecute ]
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
/// date:2015-07-06
/// desc:医生站设置程序->草药加工方式收费设置 绑定的收费项目
Query GetAppendItem(value As %String, CookMode As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,Qty:%String,CTUomDr:%String,CTUomDesc:%String,MinQty:%String,EqualQty:%String,ChargeCateDr:%String,ChargeCate:%String")
{
}

ClassMethod GetAppendItemExecute(ByRef qHandle As %Binary, value As %String, CookMode As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetAppendItem","CookModeCharge",3)
	s ^tempscl("GetAppendItem")=value_","_CookMode_","_HospId
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (CookMode="") {
	   Set qHandle=$lb(0,repid,0)
	   Quit $$$OK
	}
	//var ChargeInfo=Qty+"!"+CTUom+"!"+MinQty+"!"+EqualQty+"!"+ChargeCateDr;
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ARCIMRowID=0 
	    f  s ARCIMRowID=$o(^DHCDocConfig(HospCodeNode,value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
		.q:+ARCIMRowID="0"
	    .q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
	    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
	    .s val=$g(^DHCDocConfig(HospCodeNode,value,CookMode,ARCIMRowID))
	    .s Qty=$p(val,"!",1)
	    .s CTUomDr=$p(val,"!",2)
	    .s CTUomDesc=$p(^CT("UOM",CTUomDr),"^",2)
	    .s MinQty=$p(val,"!",3)
	    .s EqualQty=$p(val,"!",4)
	    .s ChargeCateDr=$p(val,"!",5)
	    .s ChargeCate=""
	    .if (ChargeCateDr="Material") s ChargeCate="材料费"
	    .if (ChargeCateDr="Service") s ChargeCate="加工费"
		.Do OutputRowGetAppendItem
	}else{
		s ARCIMRowID=0 
	    f  s ARCIMRowID=$o(^DHCDocConfig(value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
		.q:+ARCIMRowID="0"
	    .q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
	    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
	    .s val=$g(^DHCDocConfig(value,CookMode,ARCIMRowID))
	    .s Qty=$p(val,"!",1)
	    .s CTUomDr=$p(val,"!",2)
	    .s CTUomDesc=$p(^CT("UOM",CTUomDr),"^",2)
	    .s MinQty=$p(val,"!",3)
	    .s EqualQty=$p(val,"!",4)
	    .s ChargeCateDr=$p(val,"!",5)
	    .s ChargeCate=""
	    .if (ChargeCateDr="Material") s ChargeCate="材料费"
	    .if (ChargeCateDr="Service") s ChargeCate="加工费"
		.Do OutputRowGetAppendItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAppendItem
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(Qty),$g(CTUomDr),$g(CTUomDesc),$g(MinQty),EqualQty,ChargeCateDr,ChargeCate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemExecute ]
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
/// date:2015-07-06
/// desc:医生站设置程序->草药加工方式收费设置 查询所有的绑定的收费项目
Query GetChargeItem(value As %String, ChargeCate As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,selected:%Boolean")
{
}

ClassMethod GetChargeItemExecute(ByRef qHandle As %Binary, value As %String, ChargeCate As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CookModeCharge","GetChargeItem","CookModeCharge","Material")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s CookMode=0  f  s CookMode=$o(^DHCDocConfig(HospCodeNode,value,CookMode)) q:CookMode=""  d
	    .s ARCIMRowID=0 
	    .f  s ARCIMRowID=$o(^DHCDocConfig(HospCodeNode,value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
		..q:+ARCIMRowID="0"
	    ..q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
	    ..s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
	    ..s selected=0
	    ..i ChargeCate'="" d
	    ...i ("^"_..%GetConfig1("CookModeChargeCate",ChargeCate)_"^")[("^"_ARCIMRowID_"^")  s selected=1 //$g(^DHCDocConfig("CookModeChargeCate",ChargeCate))
		..Do OutputRowGetChargeItem
	}else{
		s CookMode=0  f  s CookMode=$o(^DHCDocConfig(value,CookMode)) q:CookMode=""  d
	    .s ARCIMRowID=0 
	    .f  s ARCIMRowID=$o(^DHCDocConfig(value,CookMode,ARCIMRowID)) q:ARCIMRowID=""  d
		..q:+ARCIMRowID="0"
	    ..q:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
	    ..s ARCIMDesc=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",2)
	    ..s selected=0
	    ..i ChargeCate'="" d
	    ...i ("^"_..%GetConfig1("CookModeChargeCate",ChargeCate)_"^")[("^"_ARCIMRowID_"^")  s selected=1 //$g(^DHCDocConfig("CookModeChargeCate",ChargeCate))
		..Do OutputRowGetChargeItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetChargeItem
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetChargeItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChargeItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChargeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChargeItemExecute ]
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

ClassMethod delete(node, node1, node2, HospId As %String = "") As %String
{
	/*zn "dhc-data"
	s rtn=$$killconfignodes2^DHCDocConfig(node,node1,node2)
	zn "dhc-app"*/
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,node,node1,node2)
	}else{
		k ^DHCDocConfig(node,node1,node2)
	}
	Q 0
}

ClassMethod save(node, node1, node2, value, HospId As %String = "") As %String
{
    q:(+node2="0")||(node2'["||") 1
	q:'$d(^ARCIM(+node2,$p(node2,"||",2),1)) 1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,node,node1,node2)=value
	}else{
		s ^DHCDocConfig(node,node1,node2)=value
	}
	q 0
}

/// 保存计算单位类型维护
ClassMethod SaveCalUomTypeConfig(rowid As %String, CTUomDr As %String, ChargeCateDr As %String) As %String
{
	s ID=0,Repeat=0
    for {
	    s ID=$o(^DHCDocCalUomTypeConfig(ID)) Q:ID=""||(Repeat=1)
	    continue:(rowid'="")&&(ID=rowid)
		s UomDr=0
		for {
			s UomDr=$o(^DHCDocCalUomTypeConfig(ID,UomDr)) Q:(UomDr="")||(Repeat=1)
			if (UomDr=CTUomDr) s Repeat=1
		}
	}
	Q:Repeat=1 "-1"
	if (rowid'="") {
		s ^DHCDocCalUomTypeConfig(rowid,CTUomDr)=ChargeCateDr
	}else{
		s maxRowid=+$o(^DHCDocCalUomTypeConfig(""),-1)
		s NewRowId=maxRowid+1
		s ^DHCDocCalUomTypeConfig(NewRowId,CTUomDr)=ChargeCateDr
	}
	Q 0
}

ClassMethod DelCalUomTypeConfig(rowid As %String)
{
	k ^DHCDocCalUomTypeConfig(rowid)
}

ClassMethod GetCalUomType(CTUomDr As %String)
{
	s CalUomType="",CalUomIndex=0
	for {
	    s CalUomIndex=$o(^DHCDocCalUomTypeConfig(CalUomIndex)) Q:(CalUomIndex="")||(CalUomType'="")
		s CalUomDr=0
		for {
			s CalUomDr=$o(^DHCDocCalUomTypeConfig(CalUomIndex,CalUomDr)) Q:(CalUomDr="")||(CalUomType'="")
			if (CalUomDr=CTUomDr) s CalUomType=$g(^DHCDocCalUomTypeConfig(CalUomIndex,CalUomDr))
		}
	}
	Q CalUomType
}

Query QueryCalUomTypeConfig(HospId As %String = "") As %Query(ROWSPEC = "rowid:%String,CTUomDr:%String,CTUomDesc:%String,ChargeCateDr:%String,ChargeCate:%String")
{
}

ClassMethod QueryCalUomTypeConfigExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HLYY","FindHLYYCompany","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s rowid=0
    for {
	    s rowid=$o(^DHCDocCalUomTypeConfig(rowid)) Q:rowid=""
	    s CTUomDr=0
		for {
			s CTUomDr=$o(^DHCDocCalUomTypeConfig(rowid,CTUomDr)) Q:(CTUomDr="")
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_UOM",CTUomDr,HospId)="N"
			s CTUomDesc=$p($g(^CT("UOM",CTUomDr)),"^",2)
			continue:CTUomDesc=""
			s ChargeCateDr=$g(^DHCDocCalUomTypeConfig(rowid,CTUomDr))
			if (ChargeCateDr="WeightUom") s ChargeCate="重量单位"
			if (ChargeCateDr="DurUom") s ChargeCate="付数单位"
			Do OutputQueryCalUomTypeConfig
		}
	    
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQueryCalUomTypeConfig
	set Data=$lb($g(rowid),$g(CTUomDr),$g(CTUomDesc),ChargeCateDr,ChargeCate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryCalUomTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCalUomTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCalUomTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCalUomTypeConfigExecute ]
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

/// 获取草药重量单位类型对应的基本单位/付数单位类型对应的基本单位
ClassMethod GetCMBaseUomRowId(ChargeCate As %String, HospId As %String) As %String
{
	if (HospId="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s CMBaseUomRowId=""
	if (ChargeCate="WeightUom") {
		s BaseUOMRowID=0
		for {
			s BaseUOMRowID=$o(^CT("UOM",0,"Desc","G",BaseUOMRowID)) Q:(BaseUOMRowID="")||(CMBaseUomRowId'="")
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_UOM",BaseUOMRowID,HospId)="N"
			s CMBaseUomRowId=BaseUOMRowID
		}
	}
	if (ChargeCate="DurUom") {
		s BaseUOMRowID=0
		for {
			s BaseUOMRowID=$o(^CT("UOM",0,"Desc","付",BaseUOMRowID)) Q:(BaseUOMRowID="")||(CMBaseUomRowId'="")
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_UOM",BaseUOMRowID,HospId)="N"
			s CMBaseUomRowId=BaseUOMRowID
		}
	}
	Q CMBaseUomRowId
}

/// Desc: 校验医嘱项ID是否和医嘱名称一致
/// Input: ArcimID:医嘱项ID、FArcimDesc:医嘱项名称
/// Output: -1/0:描述:不匹配/匹配
/// w ##class(DHCDoc.DHCDocConfig.CookModeCharge).CheckAvailItem("8733||1","大黄")
ClassMethod CheckAvailItem(ArcimID, FArcimDesc) As %String
{
	Q:(ArcimID="")||(FArcimDesc="") "-1^参数不能为空"
	s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	Q:(FArcimDesc'=ArcimDesc) "-1^名称不匹配"
	
	Q "0^成功"
}

/// 校验医嘱项ID是否已经保存过
/// Input: ArcimID:医嘱项ID、Code:处方代码、CookMode:处方类型、HospID:医院ID
/// Output: -1/0:描述:不存在/存在
/// w ##class(DHCDoc.DHCDocConfig.CookModeCharge).CheckExitAddItem("9099||1","PrescTypeAddCharge","CNMedGrindItemCat^2","2")
ClassMethod CheckExitAddItem(ArcimID, Code, CookMode, HospID) As %String
{
	Q:(ArcimID="")||(Code="")||(CookMode="")||(HospID="") "-1^参数不能为空"
	
	s HospCodeNode="HospDr_"_HospID
	s Exit=$D(^DHCDocConfig(HospCodeNode,Code,CookMode,ArcimID))
	Q:+Exit=0 "-1^不存在"
	Q "0^存在"
}

/// 获取草药加工方式附加费用
/// w ##class(DHCDoc.DHCDocConfig.CookModeCharge).GetAddItem("PrescTypeAddCharge","CNMedItemCat^2","2")
ClassMethod GetAddItem(Value, CookMode, HospID) As %String
{
	Q:(Value="")||(CookMode="")||(HospID="") "[]"
	
	w "["
	if (HospID'="") {
		s HospCodeNode="HospDr_"_HospID
		s ARCIMRowID=0,SeqNo=0 
		for {
			s ARCIMRowID=$o(^DHCDocConfig(HospCodeNode,Value,CookMode,ARCIMRowID)) 
			Q:ARCIMRowID'["||"
			Continue:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
			s SeqNo=SeqNo+1
			w:SeqNo>1 ","
			s JsonStr=$g(^DHCDocConfig(HospCodeNode,Value,CookMode,ARCIMRowID))
			w JsonStr
		}
	}else{
		s ARCIMRowID=0,SeqNo=0 
		for {
			s ARCIMRowID=$o(^DHCDocConfig(Value,CookMode,ARCIMRowID)) 
			Q:ARCIMRowID'["||"
			Continue:'$d(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1))
			s SeqNo=SeqNo+1
			w:SeqNo>1 ","
			s JsonStr=$g(^DHCDocConfig(Value,CookMode,ARCIMRowID))
			w JsonStr
		}
	}
	w "]"
	Q ""
}

}
