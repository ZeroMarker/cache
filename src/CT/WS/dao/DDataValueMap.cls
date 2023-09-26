Class CT.WS.dao.DDataValueMap Extends %Persistent
{

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.dao.DDataValueMap","SelectDataValueMap","DHCC","s01")
Query SelectDataValueMap(aSystemCode As %String, aDicCode As %String) As %Query(ROWSPEC = "ID:%Integer,DECVMID:%String,DEVID:%String,Meaning:%String,CtmDictCode:%String,CtmDictDesc:%String,DicCode:%String,SystemCode:%String")
{
}

ClassMethod SelectDataValueMapExecute(ByRef qHandle As %Binary, aSystemCode As %String, aDicCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(aSystemCode) = "" ||$g(aDicCode) = "" ) $$$OK
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCCTWS.DataValueMapI("IdxSystemCodeDicCode"," "_$ZCONVERT(aSystemCode,"U")," "_$ZCONVERT(aDicCode,"U"),rowID))
		q:(rowID = "")	
		
		s objGlossaryItemMap = ##Class(CT.WS.DataValueMap).%OpenId(rowID)
		s DECVMID = objGlossaryItemMap.DECVMID
		s DEVID = objGlossaryItemMap.DEVID
		s Meaning = objGlossaryItemMap.Meaning
		s CtmDictCode = objGlossaryItemMap.CtmDictCode
		s CtmDictDesc = objGlossaryItemMap.CtmDictDesc
		s DicCode = objGlossaryItemMap.DicCode
		s SystemCode = objGlossaryItemMap.SystemCode
		
		s Data = $lb(rowID,DECVMID,DEVID,Meaning,CtmDictCode,CtmDictDesc,DicCode,SystemCode)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectDataValueMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDataValueMapExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectDataValueMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDataValueMapExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="DDataValueMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.dao.DDataValueMapD</DataLocation>
<DefaultData>DDataValueMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CT.WS.dao.DDataValueMapD</IdLocation>
<IndexLocation>^CT.WS.dao.DDataValueMapI</IndexLocation>
<StreamLocation>^CT.WS.dao.DDataValueMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
