/// 名称: DHCHAI.IRS.CRuleOperCatSrv
/// 描述: 手术分类相关服务
/// 编写者：pylian
/// 编写日期: 2021-09-17
Class DHCHAI.IRS.CRuleOperCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  查询手术分类(下拉字典)
/// Table：       DHCHAI.IR.CRuleOperCat
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryCRuleOperCat","","")
Query QryCRuleOperCat(aAlias As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "ID:%String,OperCat:%String,OperType:%String,OperTypeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleOperCatExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xOperCat=""
 	For {
		Set xOperCat=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat))
		Quit:xOperCat=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat,xID))
			Quit:xID=""
			
	 		Set obj=##class(DHCHAI.IR.CRuleOperCat).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		
	 		Set OperCat     = obj.BTOperCat
	 		Continue:(aAlias'="")&&(OperCat'[aAlias)
			Set OperType    = obj.BTOperType
			Set OperTypeDesc=$s(OperType="I":"手术",1:"操作")	
			
			Set IsActive    = obj.BTIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc=$s(IsActive="1":"是",1:"否")
			Set ActDate     = obj.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = obj.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUserID="",ActUserCode="",ActUserDesc=""
			If $IsObject(obj.BTActUser) {
				Set ActUserID   = obj.BTActUser.%Id()
				Set ActUserCode = obj.BTActUser.BTCode
				Set ActUserDesc = obj.BTActUser.BTDesc
			}
			
			Set Data=$lb(xID,OperCat,OperType,OperTypeDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleOperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleOperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleOperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleOperCatExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-11-04
/// Description:  查询手术分类
/// Table：       DHCHAI.IR.CRuleOperCat
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryOperCat","","")
Query QryOperCat(aAlias As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "ID:%String,OperCat:%String,OperType:%String,OperTypeDesc:%String,KeyID:%String,KeyType:%String,KeyTypeDesc:%String,IncludeKey:%String,ExcludeKeys:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOperCatExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xOperCat=""
 	For {
		Set xOperCat=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat))
		Quit:xOperCat=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat,xID))
			Quit:xID=""
			
	 		Set obj=##class(DHCHAI.IR.CRuleOperCat).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		
	 		Set OperCat     = obj.BTOperCat
			Set OperType    = obj.BTOperType
			Set OperTypeDesc=$s(OperType="I":"手术",1:"操作")	
			
			Set IsActive    = obj.BTIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc=$s(IsActive="1":"是",1:"否")
			Set ActDate     = obj.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = obj.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUserID="",ActUserCode="",ActUserDesc=""
			If $IsObject(obj.BTActUser) {
				Set ActUserID   = obj.BTActUser.%Id()
				Set ActUserCode = obj.BTActUser.BTCode
				Set ActUserDesc = obj.BTActUser.BTDesc
			}
		
			Set xKeyID=0
			For {
				Set xKeyID=$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCat",xID,xKeyID))
				Quit:xKeyID=""
				
				Set objKey=##class(DHCHAI.IR.CRuleOperCatKeys).GetObjById(xID_"||"_xKeyID)
	 			Continue:'$IsObject(objKey)
						
				Set KeyType     = objKey.BTKeyType
				Set KeyTypeDesc=$s(KeyType="I":"ICD-9-CM-3",1:"手术名称")
				Set IncludeKey  = objKey.BTIncludeKey		
				Continue:(aAlias'="")&&(OperCat'[aAlias)&&(IncludeKey'[aAlias)		
				Set ExcludeKeys = objKey.BTExcludeKeys
				
				Set Data=$lb(xID,OperCat,OperType,OperTypeDesc,xKeyID,KeyType,KeyTypeDesc,IncludeKey,ExcludeKeys,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperCatExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-11-03
/// Description:  导入手术分类字典
/// Table：       DHCHAI.IR.CRuleOperCat、DHCHAI.IR.CRuleOperCatKeys
/// Input：      
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IRS.CRuleOperCatSrv).ImportOperCat("单侧甲状腺叶切除术^I^I^06.2^^1","^")
ClassMethod ImportOperCat(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set:aSeparate="" aSeparate="^"
	Set OperCat     = $p(aInput,aSeparate,1)  
	Set OperType    = $p(aInput,aSeparate,2)  
	Set KeyType     = $p(aInput,aSeparate,3)  
	Set IncludeKey  = $p(aInput,aSeparate,4)  
	Set ExcludeKeys = $p(aInput,aSeparate,5)  
	Set IsActive    = $p(aInput,aSeparate,6)  
	Set Property = $p(aInput,aSeparate,6)  
	Quit:(OperCat="")||(IncludeKey="")||(IsActive="") return
	
	Set OperCat = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OperCat)  //去掉特殊字符
	
	Set ID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",OperCat,0))
	Set InputStr=ID                             //ID
	Set InputStr=InputStr_aSeparate_OperCat    
	Set InputStr=InputStr_aSeparate_OperType    
    Set InputStr=InputStr_aSeparate_IsActive     
	Set Flg=##Class(DHCHAI.IR.CRuleOperCat).Update(InputStr,aSeparate)
	
	If Flg>0 {
		Set CatID =Flg
		Set KeyID=$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCatKey",CatID,IncludeKey,0))
		
		Set InputKeyStr=CatID                             //Parref
		Set InputKeyStr=InputKeyStr_aSeparate_KeyID
		Set InputKeyStr=InputKeyStr_aSeparate_KeyType    
		Set InputKeyStr=InputKeyStr_aSeparate_IncludeKey    
		Set InputKeyStr=InputKeyStr_aSeparate_ExcludeKeys
	    Set InputKeyStr=InputKeyStr_aSeparate_IsActive 
	  
	    Set ret=##Class(DHCHAI.IR.CRuleOperCatKeys).Update(InputKeyStr,aSeparate)
	}
	
	Set return=Flg
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-22
/// Description:  查询手术分类（树形网格）
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryOperCatTree","")
Query QryOperCatTree(aAlias As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "RowId:%String,RowDesc:%String,ID:%String,OperCat:%String,OperType:%String,OperTypeDesc:%String,KeyID:%String,KeyType:%String,KeyTypeDesc:%String,IncludeKey:%String,ExcludeKeys:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String,_parentId:%String,state:%String") [ SqlProc ]
{
}

ClassMethod QryOperCatTreeExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Set rowIdField=0
    Set xOperCat = ""
	For {
		Set xOperCat = $o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat))
		Quit:xOperCat=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat,xID))
			Quit:xID=""
			Set obj=##class(DHCHAI.IR.CRuleOperCat).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		
			Set OperType    = obj.BTOperType
			Set OperTypeDesc=$s(OperType="I":"手术",1:"操作")	
			
			Set IsActive    = obj.BTIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc=$s(IsActive="1":"是",1:"否")
			Set ActDate     = obj.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = obj.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUserID="",ActUserCode="",ActUserDesc=""
			If $IsObject(obj.BTActUser) {
				Set ActUserID   = obj.BTActUser.%Id()
				Set ActUserCode = obj.BTActUser.BTCode
				Set ActUserDesc = obj.BTActUser.BTDesc
			}
			
			Set ParentId=rowIdField	
			Set rowIdField=rowIdField+1,rowTreeField=xOperCat	
					
			Set Data = $lb(rowIdField,rowTreeField,xID,xOperCat,OperType,OperTypeDesc,"","","","","",,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc,ParentId,"closed")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
			Set xKeyID=0
			For {
				Set xKeyID=$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCat",xID,xKeyID))
				Quit:xKeyID=""
				
				Set objKey=##class(DHCHAI.IR.CRuleOperCatKeys).GetObjById(xID_"||"_xKeyID)
	 			Continue:'$IsObject(objKey)
						
				Set KeyType     = objKey.BTKeyType
				Set KeyTypeDesc=$s(KeyType="I":"ICD-9-CM-3",1:"手术名称")
				Set IncludeKey  = objKey.BTIncludeKey		
				Continue:(aAlias'="")&&(xOperCat'[aAlias)&&(IncludeKey'[aAlias)		
				Set ExcludeKeys = objKey.BTExcludeKeys
			
				Set rowIdField=rowIdField+1,rowTreeField=KeyTypeDesc	
				Set Data = $lb(rowIdField,rowTreeField,xID,xOperCat,OperType,OperTypeDesc,xKeyID,KeyType,KeyTypeDesc,IncludeKey,ExcludeKeys,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc,ParentId,"")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}	
	}
	Quit $$$OK
}

ClassMethod QryOperCatTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperCatTreeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperCatTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperCatTreeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-11-04
/// Description:  查询手术字典对照信息
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryOperDxMap","","1")
Query QryOperDxMap(aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "") As %Query(ROWSPEC = "ind:%String,OperID:%String,OperICD:%String,OperDesc:%String,OperType:%String,OperCatList:%String") [ SqlProc ]
{
}

ClassMethod QryOperDxMapExecute(ByRef qHandle As %Binary, aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperDxMapD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperDxMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.BTIsActive'=1
	 
	 	Set OperDesc   = obj.BTOperDesc
		Set OperICD    = obj.BTOperCode          // 手术ICD 
	 	Set OperCatDrs = obj.BTOperCatDrs
		Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
		Set OperCatList=""
		For indC=1:1:$L(OperCatDrs,",") {
			Set OperCatDr=$p(OperCatDrs,",",indC)
			Continue:OperCatDr=""
			
			Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
			Continue:'$IsObject(objCat)
			Set OperCat =objCat.BTOperCat
			If $listfind(OperCatList,OperCat)<1 {
				Set OperCatList=OperCatList_$lb(OperCat)
			}
		}
		
		Continue:(aAlias'="")&&(OperICD'[aAlias)&&(OperDesc'[aAlias)&&($listfind(OperCatList,aAlias)<1)
		Continue:(aFlag="1")&&($l(OperCatList)<1)
		Continue:(aFlag="0")&&($l(OperCatList)>0)
		Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
		Set Data = $lb(ind,xID,OperICD,OperDesc,OperType,OperCatLists)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	Quit $$$OK
}

ClassMethod QryOperDxMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperDxMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperDxMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperDxMapExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-09-22
/// Description:  查询手术麻醉信息
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryOperAnaes","","1")
Query QryOperAnaes(aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "", aShowAll As %String = "0") As %Query(ROWSPEC = "ind:%String,OperID:%String,OperICD:%String,OperDesc:%String,OperType:%String,OperCatList:%String") [ SqlProc ]
{
}

ClassMethod QryOperAnaesExecute(ByRef qHandle As %Binary, aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "", aShowAll As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Kill ^TMP($zn,$j)
     
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.ORIsActive'=1
	 
	 	Set OperDesc   = obj.OROperDesc
		Set OperICD    = obj.OROperICD          // 手术ICD
		
		Continue:(aShowAll=0)&&($d(^TMP($zn,$j,"OperAnaesICD",OperICD)))
		Set ^TMP($zn,$j,"OperAnaesICD",OperICD)=""

		Set Incision   = obj.ORIncision         // 切口等级
	 	Set OperType   = obj.OROperTypeSoC       // 类型
	 	Set OperType=$s(OperType="N":"常规",OperType="D":"诊断性操作",OperType="T":"治疗性操作",OperType="I":"介入治疗",1:"")
	 	
	 	Set OperCatDrs = obj.OROperCatDrs
		Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
		Set OperCatList=""
		For indC=1:1:$L(OperCatDrs,",") {
			Set OperCatDr=$p(OperCatDrs,",",indC)
			Continue:OperCatDr=""
			
			Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
			Continue:'$IsObject(objCat)
			Set OperCat =objCat.BTOperCat
			If $listfind(OperCatList,OperCat)<1 {
				Set OperCatList=OperCatList_$lb(OperCat)
			}
		}
		
		Continue:(aAlias'="")&&(OperICD'[aAlias)&&(OperDesc'[aAlias)&&($listfind(OperCatList,aAlias)<1)
		Continue:(aFlag="1")&&($l(OperCatList)<1)
		Continue:(aFlag="0")&&($l(OperCatList)>0)
		Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
		Set Data = $lb(ind,xID,OperICD,OperDesc,OperType,OperCatLists)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}

	Kill ^TMP($zn,$j)
	Quit $$$OK
}

ClassMethod QryOperAnaesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperAnaesExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperAnaesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperAnaesExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-09-22
/// Description:  查询手术编目信息
/// Table：       DHCHAI.DP.OROperation
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleOperCatSrv","QryOperation","动脉")
Query QryOperation(aType As %String = "E", aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "") As %Query(ROWSPEC = "ind:%String,OperID:%String,OperICD:%String,OperDesc:%String,OperType:%String,OperCatList:%String") [ SqlProc ]
{
}

ClassMethod QryOperationExecute(ByRef qHandle As %Binary, aType As %String = "E", aOperCat As %String = "", aAlias As %String = "", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
   
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperationD(xID),-1)
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.ORIsActive'=1
	  
	    Set OperSource=obj.OROperSource
	    Continue:(OperSource'=aType)
	 	Set OperDesc   = obj.OROperDesc
		Set OperICD    = obj.OROperICD          // 手术ICD
		Set Incision   = obj.ORIncision         // 切口等级
		Set OperType=""

	 	Set OperCatDrs = obj.OROperCatDrs
	 	Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
		Set OperCatList=""
		For indC=1:1:$L(OperCatDrs,",") {
			Set OperCatDr=$p(OperCatDrs,",",indC)
			Continue:OperCatDr=""
			
			Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
			Continue:'$IsObject(objCat)
			Set OperCat =objCat.BTOperCat
			If $listfind(OperCatList,OperCat)<1 {
				Set OperCatList=OperCatList_$lb(OperCat)
			}
		}
		Continue:(aAlias'="")&&(OperICD'[aAlias)&&(OperDesc'[aAlias)&&($listfind(OperCatList,aAlias)<1)
		Continue:(aFlag="1")&&($l(OperCatList)<1)
		Continue:(aFlag="0")&&($l(OperCatList)>0)
		
		Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
		Set Data = $lb(ind,xID,OperICD,OperDesc,OperType,OperCatLists)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	Quit $$$OK
}

ClassMethod QryOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-09-26
/// Description:  判断手术ICD、手术名称所属分类
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：		
/// Return：       DHCHAI.IR.CRuleOperCat.ID
/// w ##Class(DHCHAI.IRS.CRuleOperCatSrv).CheckKeyCat()
ClassMethod CheckKeyCat(aKeyCode As %String, aKeyDesc As %String) As %String
{
	New (aKeyCode,aKeyDesc)
	Set return=""
	Quit:(aKeyCode="")&&(aKeyDesc="")
	
   	Set aKeyCode=$zcvt(aKeyCode,"U")
   	Set aKeyDesc=$zcvt(aKeyDesc,"U")
   		
	Set CatIDList=""
	Set xOperCat=""
 	For {
		Set xOperCat=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat))
		Quit:xOperCat=""			
		
		Set xCatID=0
		For {
			Set xCatID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",xOperCat,xCatID))
			Quit:xCatID=""
			
			Set obj=##class(DHCHAI.IR.CRuleOperCat).GetObjById(xCatID)
 			Continue:'$IsObject(obj)
 			Continue:(obj.BTIsActive'=1)
		
			Set xKeyID=0
			For {
				Set xKeyID=$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCat",xCatID,xKeyID))
				Quit:xKeyID=""
				
				Set objKey=##class(DHCHAI.IR.CRuleOperCatKeys).GetObjById(xCatID_"||"_xKeyID)
	 			Continue:'$IsObject(objKey)
						
				Set KeyType     = objKey.BTKeyType
				Set IncludeKeys = objKey.BTIncludeKey		
				Set ExcludeKeys = objKey.BTExcludeKeys
				
				Set IsKeyflg=0,NoKeyflg=0	
				For indI=1:1:$l(IncludeKeys,";") {	
					Set IncludeKey=$p(IncludeKeys,";",indI)	
					Quit:IncludeKey=""
					
					If (IncludeKey["&") { //关键词允许多个关键词判断一个诊断
						For ind=1:1:$l(IncludeKey,"&") {
							Set Key=$p(IncludeKey,"&",ind)
							Continue:Key=""
							Continue:NoKeyflg=1
							Set NoKeyflg=1				
							Continue:(aKeyCode'[$zcvt(Key,"U"))&&(aKeyDesc'[$zcvt(Key,"U"))
							Set NoKeyflg=0
						}
						Continue:NoKeyflg=1    //多关键词不满足
						Set IsKeyflg=1
					}ElseIf ((aKeyCode[$zcvt(IncludeKey,"U"))||(aKeyDesc[$zcvt(IncludeKey,"U"))) {
						 Set IsKeyflg=1
					}
					Quit:(IsKeyflg=1)
				}
				If (ExcludeKeys'="") {
					For indE=1:1:$l(ExcludeKeys,";") {
						Set ExcludeKey=$p(ExcludeKeys,";",indE)
						Continue:ExcludeKey=""
						Continue:NoKeyflg=1
						Set NoKeyflg=1
						Continue:((aKeyCode[$zcvt(ExcludeKey,"U"))||(aKeyDesc[$zcvt(ExcludeKey,"U")))
						Set NoKeyflg=0
					}
				}
				Continue:(IsKeyflg=0)||(NoKeyflg=1)
				Set CatIDList=CatIDList_","_xCatID
			}			
	 	}
 	}
 	
 	Set:CatIDList'="" CatIDList=$e(CatIDList,2,$l(CatIDList))	    
    Set return=CatIDList
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-23
/// Description:  自动匹配分类规则
/// Table：       DHCHAI.DP.OROperAnaesDHCHAI.IR.CRuleOperCat
/// Input：		
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.IRS.CRuleOperCatSrv).SynOperAnaesCat()
ClassMethod SynOperAnaesCat() As %String
{
	Set return=""
	Set Count=0
	
   	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.ORIsActive'=1
	 	
		Set OperCatDrs = obj.OROperCatDrs
		Continue:OperCatDrs'=""   //已经存在不再同步匹配
		Set OperDesc   = obj.OROperDesc
		Set OperICD    = obj.OROperICD          // 手术ICD
		
		Set CatIDList=..CheckKeyCat(OperICD,OperDesc)	
	 	Continue:CatIDList=""

	 	Set objOpr=##class(DHCHAI.DP.OROperAnaes).%OpenId(xID)
		Continue:'$IsObject(objOpr)
		Set OperCatDrs =objOpr.OROperCatDrs
		Set objOpr.OROperCatDrs=CatIDList
	    
		Set sc=objOpr.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
			Do $system.OBJ.DisplayError(sc)
			Set return=-1
		}Else{
			Set Count=Count+1
		}
		Do objOpr.%Close()
    }
   
    Set return=Count
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-26
/// Description:  自动匹配分类规则
/// Table：       DHCHAI.DP.OROperation、DHCHAI.IR.CRuleOperCat
/// Input：		  aType：类型 DHCHAI.DP.OROperation.OROperSource
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.IRS.CRuleOperCatSrv).SynOperationCat("E")
ClassMethod SynOperationCat(aType As %String = "E") As %String
{
	New (aType)
	Set return=""
	Set Count=0
	
   	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperationD(xID),-1)
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.ORIsActive'=1
	 	
		Set OperCatDrs = obj.OROperCatDrs
		Continue:OperCatDrs'=""   //已经存在不再同步匹配
		Set OperDesc   = obj.OROperDesc
		Set OperICD    = obj.OROperICD          // 手术ICD
		Set OperSource =  obj.OROperSource
		Continue:aType'=OperSource
			
		Set CatIDList=..CheckKeyCat(OperICD,OperDesc)	
	 	Continue:CatIDList=""

	 	Set objOpr=##class(DHCHAI.DP.OROperation).%OpenId(xID)
		Continue:'$IsObject(objOpr)
		Set OperCatDrs =objOpr.OROperCatDrs
		Set objOpr.OROperCatDrs=CatIDList
	
		Set sc=objOpr.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
			Do $system.OBJ.DisplayError(sc)
			Set return=-1
		}Else{
			Set Count=Count+1
		}
		Do objOpr.%Close()
    }
	 
    Set return=Count
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-23
/// Description:  更新分类对照
/// Table：       DHCHAI.DP.OROperAnaes、DHCHAI.DP.OROperation
/// Input：       
/// Return：      成功：返回成功条数，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CRuleOperCatSrv).UpdateCat("1","15","1","1")
ClassMethod UpdateCat(aIDs As %String, aCatID As %String, aType As %String, aIsAll As %String = "1") As %String
{
	New (aIDs,aCatID,aType,aIsAll)
	Set return=0
	Quit:(aIDs="")||(aCatID="")||(aType="") return
	
	Set aIDs=$e(aIDs,1,$l(aIDs)-1)
	//全部记录统一增加分类
	If (aIsAll=1) {	
		For indA=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indA)
			Quit:ID=""	
			If (aType=1) {
				Set OperInfo=$g(^DHCHAI.DP.OROperAnaesD(ID))
				Continue:OperInfo=""
				Set OperDesc=$lg(OperInfo,4)
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID),-1)
					Quit:xID=""
					Continue:(","_aIDs_",")[(","_xID_",")
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 
				 	Continue:(OperDesc'=obj.OROperDesc)
				    Set aIDs=aIDs_","_xID	    
				}
			}Else {
				Set OperInfo=$g(^DHCHAI.DP.OROperationD(ID))
				Continue:OperInfo=""
				Set OperDesc=$lg(OperInfo,4)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OROperationD(xID),-1)
					Quit:xID=""
					Continue:(","_aIDs_",")[(","_xID_",")
					
					Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 
				 	Continue:(OperDesc'=obj.OROperDesc)
				    Set aIDs=aIDs_","_xID	    
				}
			}	 		    
		}
    }
	Set Count=0
	If (aType=1) {
		For indC=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indC)
			Quit:ID=""	
			
			Set obj=##class(DHCHAI.DP.OROperAnaes).%OpenId(ID)
			Continue:'$IsObject(obj)
			Set OperCatDrs =obj.OROperCatDrs
			If (OperCatDrs="") {
				Set obj.OROperCatDrs=aCatID
			}Else {
				If (","_OperCatDrs_",")'[(","_aCatID_",") {
					Set obj.OROperCatDrs=OperCatDrs_","_aCatID
				}
			}
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
				Do $system.OBJ.DisplayError(sc)
				Set return=-1
			}else{
				Set Count=Count+1
			}
			Do obj.%Close()
			
			
		}
			
	}Else {
		For indC=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indC)
			Quit:ID=""	
			Set obj=##class(DHCHAI.DP.OROperation).%OpenId(ID)
			Continue:'$IsObject(obj)
			Set OperCatDrs =obj.OROperCatDrs
			If (OperCatDrs="") {
				Set obj.OROperCatDrs=aCatID
			}Else {
				If (","_OperCatDrs_",")'[(","_aCatID_",") {
					Set obj.OROperCatDrs=OperCatDrs_","_aCatID
				}
			}
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
				Do $system.OBJ.DisplayError(sc)
				Set return=-1
			}else{
				Set Count=Count+1
			}
			Do obj.%Close()
		}
	}
	Set return =Count
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-23
/// Description:  撤销分类对照
/// Table：       DHCHAI.DP.OROperAnaes、DHCHAI.DP.OROperation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回成功条数，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CRuleOperCatSrv).DeleteCat("3318,3175,","","2")
ClassMethod DeleteCat(aIDs As %String, aCatID As %String = "", aType As %String, aIsAll As %String = "1") As %String
{
	New (aIDs,aCatID,aType,aIsAll)
	Set return=0
	Quit:(aIDs="")||(aType="") return
	
	Set aIDs=$e(aIDs,1,$l(aIDs)-1)
	//全部记录统一撤销分类
	If (aIsAll=1) {	
		For indA=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indA)
			Quit:ID=""	
			If (aType=1) {
				Set OperInfo=$g(^DHCHAI.DP.OROperAnaesD(ID))
				Continue:OperInfo=""
				Set OperDesc=$lg(OperInfo,4)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID),-1)
					Quit:xID=""
					Continue:(","_aIDs_",")[(","_xID_",")
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 
				 	Continue:(OperDesc'=obj.OROperDesc)
				    Set aIDs=aIDs_","_xID	    
				}
			}Else {
				Set OperInfo=$g(^DHCHAI.DP.OROperationD(ID))
				Continue:OperInfo=""
				Set OperDesc=$lg(OperInfo,4)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OROperationD(xID),-1)
					Quit:xID=""
					Continue:(","_aIDs_",")[(","_xID_",")
					
					Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 
				 	Continue:(OperDesc'=obj.OROperDesc)
				    Set aIDs=aIDs_","_xID	    
				}
			}	 		    
		}
    }
	Set Count=0
	If (aType=1) {
		For indC=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indC)
			Quit:ID=""	
			Set obj=##class(DHCHAI.DP.OROperAnaes).%OpenId(ID)
			Continue:'$IsObject(obj)
			Set OperCatDrs =obj.OROperCatDrs
			Continue:OperCatDrs=""
		  
			If (aCatID'="") {
				If (","_OperCatDrs_",")[(","_aCatID_",") {
					Set tOperCatDrs=""
					For indK=1:1:$l(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indK)
						Quit:(OperCatDr="")
						Continue:(OperCatDr=aCatID)					
						Set tOperCatDrs=tOperCatDrs_","_OperCatDr
					}
					Set:tOperCatDrs'="" tOperCatDrs=$e(2,tOperCatDrs,$l(tOperCatDrs))
					
					Set obj.OROperCatDrs=tOperCatDrs
				}Else {
					Continue
				}
			}Else {
				Set obj.OROperCatDrs=""
			}
		
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
				Do $system.OBJ.DisplayError(sc)
				Set return=-1
			}else{
				Set Count=Count+1
			}
			Do obj.%Close()
		}
			
	}Else {
		For indC=1:1:$l(aIDs,",") {
			Set ID=$p(aIDs,",",indC)
			Quit:ID=""	
			Set obj=##class(DHCHAI.DP.OROperation).%OpenId(ID)
			Continue:'$IsObject(obj)
			Set OperCatDrs =obj.OROperCatDrs
			Continue:OperCatDrs=""
		
			If (aCatID'="") {
				If (","_OperCatDrs_",")[(","_aCatID_",") {
					Set tOperCatDrs=""
					For indK=1:1:$l(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indK)
						Quit:(OperCatDr="")
						Continue:(OperCatDr=aCatID)
						Set tOperCatDrs=tOperCatDrs_","_OperCatDr
					}
					Set:tOperCatDrs'="" tOperCatDrs=$e(2,tOperCatDrs,$l(tOperCatDrs))
					Set obj.OROperCatDrs=tOperCatDrs
					
				}Else {
					Continue
				}
			}Else {
				Set obj.OROperCatDrs=""
			}
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
				Do $system.OBJ.DisplayError(sc)
				Set return=-1
			}else{
				Set Count=Count+1
			}
			Do obj.%Close()
		}
	}
	Set return =Count
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-27
/// Description:  处理手术查询分类
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：		  
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.IRS.CRuleOperCatSrv).OprAnaesOperCat("392","部分肝切除术","","肝切除术","I","1","8")
ClassMethod OprAnaesOperCat(aID As %String = "", aOperDesc As %String = "", aCatIDs As %String = "", aOperCat As %String, aOperType As %String, aIsAll As %String, aActUser As %String = "") As %String
{
	New (aID,aOperDesc,aCatIDs,aOperCat,aOperType,aIsAll,aActUser)
	Set return=0,ret=0
	If (aCatIDs="")&&(aOperCat'="") {  //新增分类
	    Set OperCat = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aOperCat)  //去掉特殊字符
	
		Set ID=$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",OperCat,0))
		Set InputStr=ID                             //ID
		Set InputStr=InputStr_"^"_OperCat    
		Set InputStr=InputStr_"^"_aOperType    
	    Set InputStr=InputStr_"^"_1     
		Set ret = ##class(DHCHAI.IR.CRuleOperCat).Update(InputStr,"^")
		If ret>0 {
			Set aCatIDs =ret
			Set KeyID=$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCatKey",aCatIDs,aOperDesc,0))
			
			Set InputKeyStr=aCatIDs                             //Parref
			Set InputKeyStr=InputKeyStr_"^"_KeyID
			Set InputKeyStr=InputKeyStr_"^"_"K"    
			Set InputKeyStr=InputKeyStr_"^"_aOperDesc    
			Set InputKeyStr=InputKeyStr_"^"_""
		    Set InputKeyStr=InputKeyStr_"^"_1 
		  
		    Set flg=##Class(DHCHAI.IR.CRuleOperCatKeys).Update(InputKeyStr,"^")
		}	    
	}
	Set IDs=aID
	//手术麻醉更新分类
	If (aIsAll=1) {
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID),-1)
			Quit:xID=""
			Continue:xID=aID
			
			Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Continue:obj.ORIsActive'=1
		 
		 	Set OperDesc   = obj.OROperDesc
		 	Continue:(OperDesc'=aOperDesc)
		    Set IDs=IDs_","_xID	    
		}	 		    
    }
    Set return=##class(DHCHAI.IRS.CRuleOperCatSrv).UpdateAnaesCat(IDs,aCatIDs,aOperType)	 
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-09-27
/// Description:  更新分类对照
/// Table：       DHCHAI.DP.OROperAnaes、DHCHAI.DP.OROperation
/// Input：       
/// Return：      成功：返回成功条数，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CRuleOperCatSrv).UpdateCat("1,2,3,4","1","1")
ClassMethod UpdateAnaesCat(aIDs As %String, aCatIDs As %String, aOperType As %String) As %String
{
	New (aIDs,aCatIDs,aOperType)
	Set return=0
	Quit:(aIDs="")||(aCatIDs="") return
	
	Set Count=0

	For indC=1:1:$l(aIDs,",") {
		Set ID=$p(aIDs,",",indC)
		Quit:ID=""	
		Set obj=##class(DHCHAI.DP.OROperAnaes).%OpenId(ID)
		Continue:'$IsObject(obj)
		Set:aOperType'="" obj.OROperTypeSoC =aOperType
		Set obj.OROperCatDrs=aCatIDs
		
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
			Do $system.OBJ.DisplayError(sc)
			Set return=-1
		}else{
			Set Count=Count+1
		}
		Do obj.%Close()
	}
	Set return =Count	
	Quit return
}

}
