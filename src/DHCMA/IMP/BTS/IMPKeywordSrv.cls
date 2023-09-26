Class DHCMA.IMP.BTS.IMPKeywordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-07-31
/// Description:  根据重点患者分类查询关键词
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPKeywordSrv","QryKeyWord","1")
Query QryKeyWord(aCategoryID As %String, aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,CategoryID:%String,CategoryDesc:%String,BTIsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,KeywordDr:%String")
{
}

ClassMethod QryKeyWordExecute(ByRef qHandle As %Binary, aCategoryID As %String, aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategoryID="" $$$OK
 	Set xChildID=""	
 	For{
	 	Set xChildID = $o(^CT.MA.IMP.BTIMPCategoryD(aCategoryID,"Keys",xChildID))
	 	Quit:xChildID=""
	 	
	 	Set obj = ##class(DHCMA.IMP.BT.IMPCateKeys).GetObjById(aCategoryID_"||"_xChildID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Keyword         = obj.BTKeywordDr
 		Continue:'$IsObject(Keyword)
 		Set KeywordDr       = Keyword.%Id()
 		Set (Code,Desc,IsActive)=""
	 	
	 	Set Code     = Keyword.BTCode
	 	Set Desc     = Keyword.BTDesc
	 	Set IsActive = Keyword.BTIsActive
	 	continue:(aKey'="")&&(Code'[aKey)&&(Desc'[aKey)
	 	Set CategoryCode="",CategoryDesc =""
	 	Set objCategory = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(aCategoryID)
	 	If $IsObject(objCategory){
		 	Set CategoryCode = objCategory.BTCode
	    	Set CategoryDesc = objCategory.BTDesc
	 	}
	 	Set BTIsActive      = obj.BTIsActive
 		Set BTIsActive=$s(BTIsActive=1:"是",1:"否")
 		Set ActDate      = obj.BTActDate
 		Set ActTime      = obj.BTActTime
 		Set ActUserID    = obj.BTActUserID
	 	
	    Set IsActive=obj.BTIsActive
		Set Data=$lb(aCategoryID_"||"_xChildID,Code,Desc,aCategoryID,CategoryDesc,BTIsActive,ActDate,ActTime,ActUserID,KeywordDr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryKeyWordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKeyWordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryKeyWordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKeyWordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhangdc
/// CreatDate：   2020-10-10
/// Description:  取重点患者关键词字典信息
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPKeywordSrv","QryIMPKeyword")
Query QryIMPKeyword(aIsActive As %String = "") As %Query(ROWSPEC = "BTID:%String,Code:%String,Desc:%String,BTIsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String")
{
}

ClassMethod QryIMPKeywordExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPKeywordD(xRowID))
	 	Quit:xRowID=""
	 	Set objKeyword     = ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(xRowID)
	 	Set Code             = objKeyword.BTCode
	 	Set Desc             = objKeyword.BTDesc 
	 	Set IsActive         = objKeyword.BTIsActive
	 	Continue:(aIsActive'="")&&(IsActive'=1)
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set ActDate          = objKeyword.BTActDate 
	 	Set ActTime          = objKeyword.BTActTime 
	 	Set ActUserID        = objKeyword.BTActUserID 
	 	
		Set Data=$lb(xRowID,Code,Desc,IsActive,ActDate,ActTime,ActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryIMPKeywordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPKeywordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPKeywordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPKeywordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     deengshaopeng
/// CreatDate：   2021-08-03
/// Description:  检索取重点患者关键词字典信息
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPKeywordSrv","QryIMPKeyword")
Query QryIMPKeywordByKey(aIsActive As %String = "", aKey As %String) As %Query(ROWSPEC = "BTID:%String,Code:%String,Desc:%String,BTIsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String")
{
}

ClassMethod QryIMPKeywordByKeyExecute(ByRef qHandle As %Binary, aIsActive As %String = "", aKey As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPKeywordD(xRowID))
	 	Quit:xRowID=""
	 	Set objKeyword     = ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(xRowID)
	 	Set Code             = objKeyword.BTCode
	 	Set Desc             = objKeyword.BTDesc 
	 	Set IsActive         = objKeyword.BTIsActive
	 	Continue:(aIsActive'="")&&(IsActive'=1)
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set ActDate          = objKeyword.BTActDate 
	 	Set ActTime          = objKeyword.BTActTime 
	 	Set ActUserID        = objKeyword.BTActUserID 
	 	continue:(aKey'="")&&(Code'[aKey)&&(Desc'[aKey)
	 	
		Set Data=$lb(xRowID,Code,Desc,IsActive,ActDate,ActTime,ActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryIMPKeywordByKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPKeywordByKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPKeywordByKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPKeywordByKeyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhangdc
/// CreatDate：   2020-10-13
/// Description:  导入重点患者关键词字典
/// return： 	  成功：-1，失败：返回空
/// w ##class(DHCMA.IMP.BTS.IMPKeywordSrv).ImportIMPKeyword()
ClassMethod ImportIMPKeyword(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID		 		 = $p(aInputStr,aSeparete,1)
	Set KCode		 	 = $p(aInputStr,aSeparete,2)
	Set KDesc     		 = $p(aInputStr,aSeparete,3)
	Set KIsActive        = +$p(aInputStr,aSeparete,4)
	Set SDesc         	 = $p(aInputStr,aSeparete,5)
	Set SIsActive         = +$p(aInputStr,aSeparete,6)
	Set BTActDate		 = +$h
	Set BTActTime		 = +$p($h,",",2)
	Set BTActUserID		 = ""
	
	Set inputStr1=ID_"^"_KCode_"^"_KDesc_"^"_KIsActive_"^"_BTActDate_"^"_BTActTime_"^"_BTActUserID
	Set return=##class(DHCMA.IMP.BT.IMPKeyword).Update(inputStr1)
	Quit:+return<1 return=""
	
	Set Keyword=##class(DHCMA.IMP.BT.IMPKeyword).GetObjByCode(KCode)
	Set:$IsObject(Keyword) Keyword=Keyword.%Id()
	Quit:Keyword="" return
	
	Set inputStr2=ID_"^"_SDesc_"^"_Keyword_"^"_SIsActive_"^"_BTActDate_"^"_BTActTime_"^"_BTActUserID
	Set return=##class(DHCMA.IMP.BT.SemanticWord).Update(inputStr2)
	Quit:+return<1 return=""
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-10-14
/// Description:  导入重点患者关键词维护
/// return： 	  成功：-1，失败：返回空
/// w ##class(DHCMA.IMP.BTS.IMPKeywordSrv).ImportIMPCateKeys()
ClassMethod ImportIMPCateKeys(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefDesc		 = $p(aInputStr,aSeparete,1)
	Set ChildSub		 = $p(aInputStr,aSeparete,2)
	Set KeywordDesc      = $p(aInputStr,aSeparete,3)
	Set IsActive         = +$p(aInputStr,aSeparete,4)
	Set BTActDate		 = +$h
	Set BTActTime		 = +$p($h,",",2)
	Set BTActUserID		 = ""
	
	Set Parref=##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc(ParrefDesc)
	Set:$IsObject(Parref) Parref=Parref.%Id()
	Quit:Parref="" return
	
	Set KeywordDic=##class(DHCMA.IMP.BT.IMPKeyword).GetObjByDesc(KeywordDesc)	
	Set:$IsObject(KeywordDic) KeywordDic=KeywordDic.%Id()
	
	Set inputStr=Parref_"^"_ChildSub_"^"_KeywordDic_"^"_IsActive_"^"_BTActDate_"^"_BTActTime_"^"_BTActUserID
	Set return=##class(DHCMA.IMP.BT.IMPCateKeys).Update(inputStr)
	Set:+return<1 return=""
	Quit return
}

}
