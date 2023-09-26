Class web.DHCClinic.DHCANCRecordSubCat Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2016-05-05
/// Description： 	获取麻醉记录子类数据
/// Table：        	DHC_ANC_ViewCat
/// Input:			filterDesc：记录子类名称筛选字符串，recordCategoryId：麻醉记录分类ID，dataType：记录子类数据类型
/// Return：       	ResultSet
/// Debug:			d ##class(%ResultSet).RunQuery("web.DHCClinic.DHCANCRecordSubCat","FindRecordSubCat")
Query FindRecordSubCat(filterDesc As %String = "", recordCategoryId As %String = "", dataType As %String = "") As %Query(ROWSPEC = "RowId,Code,Desc,RecordCategoryId,RecordCategory,DataType,DataTypeDesc,DisplayByCat,DataFormat,Options,RelateSubCateId,RelateSubCate")
{
}

ClassMethod FindRecordSubCatExecute(ByRef qHandle As %Binary, filterDesc As %String = "", recordCategoryId As %String = "", dataType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set filterDesc=$$ALPHAUP^SSUTIL4(filterDesc)
	set subCateId=0
	for
	{
		set subCateId=$order(^DHCANC("ViewCat",subCateId))
		quit:(subCateId="")
		set subCateInfo=^DHCANC("ViewCat",subCateId)
		set subCateCode=$p(subCateInfo,"^",1)
		set subCateDesc=$p(subCateInfo,"^",2)
		continue:(filterDesc'="")&($$ALPHAUP^SSUTIL4(subCateDesc)'[filterDesc)
		set thisRecordCategoryId=$p(subCateInfo,"^",10)
		continue:(recordCategoryId'="")&(recordCategoryId'=thisRecordCategoryId)
		set thisRecordCategory=$p($g(^DHCANC("VSCat",+thisRecordCategoryId)),"^",2)
		set thisDataType=$p(subCateInfo,"^",19)
		continue:(dataType'="")&(dataType'=thisDataType)
		set thisDataTypeDesc=$case(thisDataType,
								   "V":"体征",
								   "D":"药品",
								   "E":"事件",
								   "T":"治疗",
								   "L":"检验",
								   "":"")
		set displayByCat=$p(subCateInfo,"^",11)
		set dataFormat=$p(subCateInfo,"^",16)
		set options=$p(subCateInfo,"^",17)
		set relateSubCateId=$p(subCateInfo,"^",18),splitChar=","
		set relateSubCateCount=$length(relateSubCateId,splitChar),relateSubCate=""
		for subCateInd=1:1:relateSubCateCount
		{
			set singleSubCateId=$p(relateSubCateId,splitChar,subCateInd)
			set singleSubCate=$p($g(^DHCANC("ViewCat",+singleSubCateId)),"^",2)
			if (subCateInd=1)
			{
				set relateSubCate=singleSubCate	
			}
			else
			{
				set relateSubCate=splitChar_singleSubCate	
			}	
		}
		do OutputRow	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(subCateId,subCateCode,subCateDesc,thisRecordCategoryId,thisRecordCategory,thisDataType,thisDataTypeDesc,displayByCat,dataFormat,options,relateSubCateId,relateSubCate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRecordSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecordSubCatExecute ]
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

ClassMethod FindRecordSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecordSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
