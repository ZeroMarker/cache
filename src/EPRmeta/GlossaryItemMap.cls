Class EPRmeta.GlossaryItemMap Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxGlossaryItemID On GlossaryItemID;

Index IdxTempID On TempID;

Index IdxDECVMID On DECVMID;

Index IdxGloItemTemp On (GlossaryItemID, TempID) [ Unique ];

Index IdxDECVMIDTempID On (DECVMID, TempID);

Index IdxDECVMIDTempDes On (DECVMID, TempDes);

Index IdxDECVMIDCodeSystem On (DECVMID, CodeSystem);

/// 术语子集ID关联EPRmeta.GlossaryItem的ID
Property GlossaryItemID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模版数据ID
Property TempID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模版数据描述
Property TempDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元允许值标示符关联ID
Property DECVMID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元允许值ID
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据元允许值描述
Property DEVDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 字典单元：编码，其他为空
Property CodeSystem As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRmeta.GlossaryItemMap","SelectByGlossaryItemID","353")
Query SelectByGlossaryItemID(aGlossaryItemID As %String) As %Query(ROWSPEC = "ID:%Integer,GlossaryItemID:%String,TempID:%String,TempDes:%String,DEVID:%String,DEVDes:%String,CodeSystem:%String")
{
}

ClassMethod SelectByGlossaryItemIDExecute(ByRef qHandle As %Binary, aGlossaryItemID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(aGlossaryItemID) = "") $$$OK
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCEPRM.GlossaryItemMapI("IdxGlossaryItemID"," "_aGlossaryItemID,rowID))
		q:(rowID = "")	
		
		s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(rowID)
		
		s GlossaryItemID = objGlossaryItemMap.GlossaryItemID
		s TempID = objGlossaryItemMap.TempID
		s TempDes = objGlossaryItemMap.TempDes
		s DEVID = objGlossaryItemMap.DEVID
		s DEVDes = objGlossaryItemMap.DEVDes
		s CodeSystem = objGlossaryItemMap.CodeSystem
		s Data = $lb(rowID,GlossaryItemID,TempID,TempDes,DEVID,DEVDes,CodeSystem)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectByGlossaryItemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectByGlossaryItemIDExecute ]
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

ClassMethod SelectByGlossaryItemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectByGlossaryItemIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRmeta.GlossaryItemMap","SelectByCodeDECVMID","GB/T 3304","S04")
Query SelectByCodeDECVMID(aDECVMID As %String, aCodeSystem As %String) As %Query(ROWSPEC = "ID:%Integer,GlossaryItemID:%String,TempID:%String,TempDes:%String,DEVID:%String,DEVDes:%String,CodeSystem:%String")
{
}

ClassMethod SelectByCodeDECVMIDExecute(ByRef qHandle As %Binary, aDECVMID As %String, aCodeSystem As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(aDECVMID) = "") $$$OK
	q:($g(aCodeSystem) = "") $$$OK
	s rowID = ""
	
	for {
		s rowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDCodeSystem"," "_aDECVMID," "_aCodeSystem,rowID))
		q:(rowID = "")	
		
		s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(rowID)
		s GlossaryItemID = objGlossaryItemMap.GlossaryItemID
		s TempID = objGlossaryItemMap.TempID
		s TempDes = objGlossaryItemMap.TempDes
		s DEVID = objGlossaryItemMap.DEVID
		s DEVDes = objGlossaryItemMap.DEVDes
		s CodeSystem = objGlossaryItemMap.CodeSystem
		s Data = $lb(rowID,GlossaryItemID,TempID,TempDes,DEVID,DEVDes,CodeSystem)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectByCodeDECVMIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectByCodeDECVMIDExecute ]
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

ClassMethod SelectByCodeDECVMIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectByCodeDECVMIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="GlossaryItemMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEVDes</Value>
</Value>
<Value name="3">
<Value>DEVID</Value>
</Value>
<Value name="4">
<Value>GlossaryItemID</Value>
</Value>
<Value name="5">
<Value>TempDes</Value>
</Value>
<Value name="6">
<Value>TempID</Value>
</Value>
<Value name="7">
<Value>DECVMID</Value>
</Value>
<Value name="8">
<Value>CodeSystem</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossaryItemMapD</DataLocation>
<DefaultData>GlossaryItemMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.GlossaryItemMapD</IdLocation>
<IndexLocation>^DHCEPRM.GlossaryItemMapI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossaryItemMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
