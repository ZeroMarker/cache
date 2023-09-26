/// 名称: DHCMed.DPService.Base.ActWards
/// 描述: 常用短语相关内容
/// 编写者：zhufei
/// 编写日期: 2014-02-29
Class DHCMed.DPService.Base.ActWards Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-02-29
/// Description:  更新词组、短语数据
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DPService.Base.ActWards).Update("^LIS-PY^木糖氧化亚种^PRO-0^^^^^1^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=-1
	quit:(InStr="")||(separete="") return
	
	set ActType=$p(InStr,separete,4)
	if ActType'="" {
		set objActType=##class(DHCMed.SS.Dictionary).GetObjById(ActType)
		if $IsObject(objActType) {
			set category=objActType.Type
			set:category="DPDicWordProperty" ActType=objActType.Code
		}
	}
	set $p(InStr,separete,4)=ActType
	
	set return=##Class(DHCMed.DP.Base.ActWards).Update(InStr,separete)
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-27
/// Description:  查询常用词组、短语、关键字、特殊符号
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.DPService.Base.ActWards","QryActWards","EMR-PN","PRO-0")
Query QryActWards(aCategory As %String, aActType As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,CategoryDesc:%String,Words:%String,ActType:%String,ActTypeDesc:%String,Text1:%String,Text2:%String,Text3:%String,Text4:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QryActWardsExecute(ByRef qHandle As %Binary, aCategory As %String, aActType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aCategory="") $$$OK
 	
 	Set xID=0
 	For {
		Set xID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategory",aCategory,xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DP.Base.ActWards).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set Category=obj.APCategory
		Set objCategory=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordCategory",Category,"")
		Continue:'$IsObject(objCategory)
		Set CategoryDesc=objCategory.Description
		Set Words=obj.APWords
		Set ActType=obj.APActType
		Continue:(aActType'="")&&(ActType'=aActType)
		Set objActType=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordProperty",ActType,"")
		Continue:'$IsObject(objActType)
		Set ActTypeDesc=objActType.Description
		
	 	Set Text1=obj.APText1
	 	Set Text2=obj.APText2
	 	Set Text3=obj.APText3
	 	Set Text4=obj.APText4
	 	Set IsActive=obj.APIsActive
	 	Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
	 	Set ResumeText=obj.APResume
	 	
	 	Set Data=$lb(xID,Category,CategoryDesc,Words,ActType,ActTypeDesc,Text1,Text2,Text3,Text4,IsActive,IsActiveDesc,ResumeText)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryActWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryActWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryActWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryActWardsExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2014-3-4
/// Description:  导入常用词组、短语、关键字、特殊符号
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       
/// w ##Class(DHCMed.DPService.Base.ActWards).ImportActWards("^EMR-PN^无压痛、反跳痛^PRO-0^^^^^1^","^")
ClassMethod ImportActWards(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//常用短语、说明
	Set APCategory=$p(aInputStr,aSeparate,2) 
	Set APWords=$p(aInputStr,aSeparate,3) 
	Set APActType=$p(aInputStr,aSeparate,4)     
	Set APText1=$p(aInputStr,aSeparate,5)   
	Set APText2=$p(aInputStr,aSeparate,6)       
	Set APText3=$p(aInputStr,aSeparate,7)   	
	Set APText4=$p(aInputStr,aSeparate,8) 
	Set APIsActive=$p(aInputStr,aSeparate,9)   	
	Set APResume=$p(aInputStr,aSeparate,10) 
	
	Set xRowID=""	
	Set xRowID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",APCategory,APActType,APIsActive,APWords,xRowID))
	
	Set RowID=xRowID
	Set InputStr=RowID_aSeparate_APCategory_aSeparate_APWords_aSeparate_APActType_aSeparate_APText1_aSeparate_APText2_aSeparate_APText3_aSeparate_APText4_aSeparate_APIsActive_aSeparate_APResume
	Set return=##Class(DHCMed.DP.Base.ActWards).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-6-17
/// Description:  导出常用短语
/// Table：       DHCMed.DP.Base.ActWards
/// w ##Class(DHCMed.DPService.Base.ActWards).ExportActWards()
ClassMethod ExportActWards() As %String
{
	Set return=""
	Set xCategory=0
	For {
		Set xCategory=$o(^DHCMed.DP.Base.ActWardsI("IndexCategory",xCategory))
		Quit:xCategory=""
		Set Ind=0
		
		Set xID=0
	 	For {
			Set xID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategory",xCategory,xID))
			Quit:xID=""
		
			Set obj=##class(DHCMed.DP.Base.ActWards).GetObjById(xID)
			Continue:'$IsObject(obj)
		
			Set Category=obj.APCategory
			Set objCategory=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordCategory",Category,"")
			Continue:'$IsObject(objCategory)
			Set CategoryDesc=objCategory.Description
			Set Words=obj.APWords
			Set ActType=obj.APActType
			Set objActType=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordProperty",ActType,"")
			Continue:'$IsObject(objActType)
			Set ActTypeDesc=objActType.Description
		
		 	Set Text1=obj.APText1
		 	Set Text2=obj.APText2
		 	Set Text3=obj.APText3
		 	Set Text4=obj.APText4
		 	Set IsActive=obj.APIsActive
		 	Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		 	Set ResumeText=obj.APResume
	 		Set Ind=Ind+1
		 	Set return=return_"||"_Ind_"^"_Category_"^"_CategoryDesc_"^"_Words_"^"_ActType_"^"_ActTypeDesc_"^"_Text1_"^"_Text2_"^"_Text3_"^"_Text4_"^"_IsActive_"^"_IsActiveDesc_"^"_ResumeText
	 	}
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-27
/// Description:  查询常用短语，导出用
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.DPService.Base.ActWards","QrytoExport")
Query QrytoExport() As %Query(ROWSPEC = "ID:%String,Category:%String,CategoryDesc:%String,Words:%String,ActType:%String,ActTypeDesc:%String,Text1:%String,Text2:%String,Text3:%String,Text4:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QrytoExportExecute(ByRef qHandle As %Binary, aCategory As %String, aActType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xCategory=0
	For {
		Set xCategory=$o(^DHCMed.DP.Base.ActWardsI("IndexCategory",xCategory))
		Quit:xCategory=""
		
		Set Ind=0
	 	Set xID=0
	 	For {
			Set xID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategory",xCategory,xID))
			Quit:xID=""
		
			Set obj=##class(DHCMed.DP.Base.ActWards).GetObjById(xID)
			Continue:'$IsObject(obj)
		
			Set Category=obj.APCategory
			Set objCategory=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordCategory",Category,"")
			Continue:'$IsObject(objCategory)
			Set CategoryDesc=objCategory.Description
			Set Words=obj.APWords
			Set ActType=obj.APActType
			
			Set objActType=##class(DHCMed.SS.Dictionary).GetByTypeCode("DPDicWordProperty",ActType,"")
			Continue:'$IsObject(objActType)
			Set ActTypeDesc=objActType.Description
		
		 	Set Text1=obj.APText1
		 	Set Text2=obj.APText2
		 	Set Text3=obj.APText3
		 	Set Text4=obj.APText4
		 	Set IsActive=obj.APIsActive
		 	Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		 	Set ResumeText=obj.APResume
	 		Set Ind=Ind+1
		 	Set Data=$lb(Ind,Category,CategoryDesc,Words,ActType,ActTypeDesc,Text1,Text2,Text3,Text4,IsActive,IsActiveDesc,ResumeText)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrytoExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrytoExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrytoExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrytoExportExecute ]
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

Storage Default
{
<Data name="ActWardsSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DPService.Base.ActWardsD</DataLocation>
<DefaultData>ActWardsSrvDefaultData</DefaultData>
<IdLocation>^DHCMed.DPService.Base.ActWardsD</IdLocation>
<IndexLocation>^DHCMed.DPService.Base.ActWardsI</IndexLocation>
<StreamLocation>^DHCMed.DPService.Base.ActWardsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
