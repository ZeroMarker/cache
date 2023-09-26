/// 名称: web.DHCCPW.MRC.BaseDictionary
/// 描述：基础字典项目相关操作
/// 编写者：zhufei
/// 编写日期：2011-04-24
Class web.DHCCPW.MRC.BaseDictionary Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  根据ID取基础字典项目
/// Table：       User.DHCMRCBaseDictionary
/// Input：       ID:    User.DHCMRCBaseDictionary.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseDictionary
{
	New (argId)
	Set return=##Class(User.DHCMRCBaseDictionary).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  更新基础字典项目
/// Table：       User.DHCMRCBaseDictionary
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(web.DHCCPW.MRC.BaseDictionary).Update()
ClassMethod Update(InStr) As %String
{
	New (InStr)
	Set return=-1
	
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCBaseDictionary).%New()
	}Else{
		Set obj=##class(User.DHCMRCBaseDictionary).%OpenId(ID)
		Quit:obj="" return
	}
	Set obj.BDCode=$p(InStr,"^",2)
	Set obj.BDDesc=$p(InStr,"^",3)
	Set objType=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById($p(InStr,"^",4))
	Set obj.BDTypeDR=objType
	Set objCPWD=##class(web.DHCCPW.MRC.CliPathWay).GetObjById($p(InStr,"^",5))
	Set obj.BDCPWDDR=objCPWD
	Set obj.BDActive=$p(InStr,"^",6)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// 查询所有临床路径字典
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryBaseDictionary")
Query QryBaseDictionary(argDesc As %String, argSubCategID As %String, argCPWDicID As %String, argIsActive As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeDesc:%String,CPWDID:%String,CPWDDesc:%String,IsActive:%String")
{
}

ClassMethod QryBaseDictionaryExecute(ByRef qHandle As %Binary, argDesc As %String, argSubCategID As %String, argCPWDicID As %String, argIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set BDID=0
	For {
		Set BDID=$o(^DHCMRC("BD",BDID))
		Quit:BDID=""
		
		Set objBaseDic=..GetObjById(BDID)
		If $IsObject(objBaseDic){
			Set Code=objBaseDic.BDCode
			Set Desc=objBaseDic.BDDesc
			Continue:(argDesc'="")&&(Desc'[argDesc)
			Set (TypeID,TypeDesc)=""
			If $IsObject(objBaseDic.BDTypeDR){
				Set TypeID=objBaseDic.BDTypeDR.%Id()
				Set TypeDesc=objBaseDic.BDTypeDR.BDSCDesc
			}
			Continue:(argSubCategID'="")&&(argSubCategID'=TypeID)
			Set (CPWDID,CPWDDesc)=""
			If $IsObject(objBaseDic.BDCPWDDR){
				Set CPWDID=objBaseDic.BDCPWDDR.%Id()
				Set CPWDDesc=objBaseDic.BDCPWDDR.CPWDDesc
			}
			Continue:(argCPWDicID'="")&&(argCPWDicID'=CPWDID)
			Set Active=$s(objBaseDic.BDActive["Y":"Yes",1:"No")
			Set argIsActive=$s(argIsActive["Y":"Y",argIsActive["N":"N",1:"")
			Continue:(argIsActive'="")&&(Active'[argIsActive)
			
			Set Data=$lb(BDID,Code,Desc,TypeID,TypeDesc,CPWDID,CPWDDesc,Active)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBaseDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBaseDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBaseDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBaseDictionaryExecute ]
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

/// Creator:zhufei
/// CreatDate:2011-04-24
/// Description:检查Code是否重复
/// Table:User.DHCMRCBaseDictionary
/// w ##Class(web.DHCCPW.MRC.BaseDictionary).CheckCode("01",1)
ClassMethod CheckCode(argCode As %String, argDicID As %String, argSubCatID As %String) As %String
{
	New (argCode,argDicID,argSubCatID)
	Set return=0
	Quit:(argCode="")||(argSubCatID="") return
	
	Set DicID=0
	For {
		Set DicID=$o(^DHCMRC("BD",DicID))
		Quit:(DicID="")||(return=1)
		Continue:(argDicID'="")&(argDicID=DicID)
		
		Set objDic=..GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Continue:'$IsObject(objDic.BDTypeDR)
		Continue:objDic.BDTypeDR.%Id()'=argSubCatID
		Continue:objDic.BDCode'=argCode
		Set return=1
	}
	
	Quit return
}

/// 查询基础字典
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryBySubCateg","XZZGS","3")
Query QryBySubCateg(argSubCateg As %String, argPathWayID As %String) As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod QryBySubCategExecute(ByRef qHandle As %Binary, argSubCateg As %String, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set argCPWDicID=""
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) {
				Set argCPWDicID=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
			}
		}
	}
	
	Set BDID=0
	For {
		Set BDID=$o(^DHCMRC("BD",BDID))
		Quit:BDID=""
		
		Set objBaseDic=..GetObjById(BDID)
		If $IsObject(objBaseDic){
			Set Code=objBaseDic.BDCode
			Set Desc=objBaseDic.BDDesc
			Set TypeCode=""
			If $IsObject(objBaseDic.BDTypeDR){
				Set TypeCode=objBaseDic.BDTypeDR.BDSCCode
			}
			Continue:argSubCateg'=TypeCode
			Set CPWDID=""
			If $IsObject(objBaseDic.BDCPWDDR){
				Set CPWDID=objBaseDic.BDCPWDDR.%Id()
			}
			Continue:(argCPWDicID'="")&&(argCPWDicID'=CPWDID)
			Set Active=$s(objBaseDic.BDActive["Y":"Yes",1:"No")
			Continue:Active'["Y"
			
			Set Data=$lb(BDID,Code,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBySubCategClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBySubCategExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBySubCategFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBySubCategExecute ]
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

/// w ##Class(web.DHCCPW.MRC.BaseDictionary).GetBySubCateg("","")
ClassMethod GetBySubCateg(argSubCateg As %String, argPathWayID As %String) As %String
{
	New (argSubCateg,argPathWayID)
	Set return=""
	Quit:argSubCateg="" return
	
	Set $ZT="GetBySubCategErr"
	Set argCPWDicID=""
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) {
				Set argCPWDicID=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
			}
		}
	}
	
	Set BDID=0
	For {
		Set BDID=$o(^DHCMRC("BD",BDID))
		Quit:BDID=""
		
		Set objBaseDic=..GetObjById(BDID)
		If $IsObject(objBaseDic){
			Set Code=objBaseDic.BDCode
			Set Desc=objBaseDic.BDDesc
			Set TypeCode=""
			If $IsObject(objBaseDic.BDTypeDR){
				Set TypeCode=objBaseDic.BDTypeDR.BDSCCode
			}
			Continue:argSubCateg'=TypeCode
			Set CPWDID=""
			If $IsObject(objBaseDic.BDCPWDDR){
				Set CPWDID=objBaseDic.BDCPWDDR.%Id()
			}
			Continue:(argCPWDicID'="")&&(argCPWDicID'=CPWDID)
			Set Active=$s(objBaseDic.BDActive["Y":"Yes",1:"No")
			Continue:Active'["Y"
			
			Set return=return_$c(1)_BDID_$c(2)_Code_$c(2)_Desc
		}
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetBySubCategErr
	Quit ""
}

/*
/// 根据字典子类代码查询字典数据
/// by wuqk 
/// 2011-07-25
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryDicBySubCatDesc","STEPTYPE")
/// 
Query QryDicBySubCatDesc(SubCateDesc As %String, Active As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT BD_RowId,BD_Code,BD_Desc,BD_Active FROM SQLUser.DHC_MRC_BaseDictionary
 WHERE (BD_TypeDR->BDSC_Code = :SubCateDesc AND (:Active IS NULL OR (BD_Active=:Active)))
 ORDER BY BD_Code
}
*/

//note by liulan

/// 根据字典子类代码查询字典数据
/// add by liulan 
/// 2012-10-26
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryDicBySubCatDesc","STEPTYPE")
Query QryDicBySubCatDesc(SubCateDesc As %String, Active As %String) As %Query(ROWSPEC = "BD_RowId:%String,BD_Code:%String,BD_Desc:%String,BD_Active:%String")
{
}

ClassMethod QryDicBySubCatDescExecute(ByRef qHandle As %Binary, SubCateDesc As %String, Active As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
    Set ZIndex=$zn,JIndex=$j
    Kill ^CacheTemp(ZIndex,JIndex,"QryDicBySubCatDesc")

	Set BDRowId=0
	For{
		Set BDRowId=$o(^DHCMRC("BD",BDRowId))
	    Quit:BDRowId=""
		Set ObjBD=##class(User.DHCMRCBaseDictionary).%OpenId(BDRowId)
	    If $IsObject(ObjBD)
	     { 
		    Set BDCode=ObjBD.BDCode
		    Set BDDesc=ObjBD.BDDesc
		    Set BDActive=ObjBD.BDActive
		    Set BDTypeDR=ObjBD.BDTypeDR
		  Continue:((Active'="")&&(Active'=BDActive))	//Add by zhaoyu 2013-01-06 路径步骤维护，无效步骤类型未过滤
			If $IsObject(BDTypeDR)
	        { 
	          Set BDSCCode=BDTypeDR.BDSCCode
		      Continue:BDSCCode'=SubCateDesc
		      Set Data=$lb(BDRowId,BDCode,BDDesc,BDActive)
		      Set ^CacheTemp(ZIndex,JIndex,"QryDicBySubCatDesc",BDCode)=Data
		      
		    }
		 }	
       }
	 Set BDCode=0
	 For 
	   { 
	     Set BDCode=$o(^CacheTemp(ZIndex,JIndex,"QryDicBySubCatDesc",BDCode))   
	     Quit:BDCode=""
	     Set ^CacheTemp(repid,ind)=^CacheTemp(ZIndex,JIndex,"QryDicBySubCatDesc",BDCode)
	     Set ind=ind+1  
	    } 
     Kill ^CacheTemp(ZIndex,JIndex,"QryDicBySubCatDesc")
	 Quit $$$OK
}

ClassMethod QryDicBySubCatDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicBySubCatDescExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicBySubCatDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicBySubCatDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}Else{				   
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*/// 根据字典子类代码和字典数据代码查询字典数据的描述
/// by wuqk 
/// 2011-07-25
/// w ##class(web.DHCCPW.MRC.BaseDictionary).GetDescBySubCateAndCode("STEPTYPE","01")
ClassMethod GetDescBySubCateAndCode(subCate, dicItemCode) As %String
{
	n (subCate,dicItemCode)
	&sql(SELECT BD_RowId,BD_Desc into :ID,:DESC FROM SQLUser.DHC_MRC_BaseDictionary
 	WHERE (BD_TypeDR->BDSC_Code = :subCate AND BD_Code=:dicItemCode))
 	quit:SQLCODE=100 ""
 	quit DESC
}
*/

//note by liulan

/// 根据字典子类代码和字典数据代码查询字典数据的描述
/// add by liulan 
/// 2012-10-29
/// w ##class(web.DHCCPW.MRC.BaseDictionary).GetDescBySubCateAndCode("STEPTYPE","01")
ClassMethod GetDescBySubCateAndCode(subCate, dicItemCode) As %String
{
	New (subCate,dicItemCode)
	Set return=""
	Quit:(subCate="")||(dicItemCode="") return	//Modified by zhaoyu 2013-01-06 &&改为|| 路径步骤维护，步骤类型输入为空时保存为死亡
	
	Set BDRowId=0,BDDesc=""
	For {
		Set BDRowId=$o(^DHCMRC("BD",BDRowId))
		Quit:BDRowId=""
		Set ObjBD=##class(User.DHCMRCBaseDictionary).%OpenId(BDRowId)
		If $IsObject(ObjBD){
			Set BDCode=ObjBD.BDCode
			Set BDDesc=ObjBD.BDDesc
			Set BDTypeDR=ObjBD.BDTypeDR
			If $IsObject(BDTypeDR){
				Set BDSCCode=BDTypeDR.BDSCCode
			}
			Continue:(dicItemCode'=BDCode)||(subCate'=BDSCCode)
			Set return=BDDesc	//Add by zhaoyu 2013-01-06 路径步骤维护，步骤类型输入为空时保存为死亡
		}
		Quit:(return'="")	//zhaoyu 2013-01-06 BDDesc改为return 路径步骤维护，步骤类型输入为空时保存为死亡
	}
	Quit return	//zhaoyu 2013-01-06 BDDesc改为return 路径步骤维护，步骤类型输入为空时保存为死亡
}

/// /// Creator：     wuqk
/// /// CreatDate：   2011-09-168
/// /// Description:  构造字典json串
/// /// 
/// /// Table：       User.DHCMRCBaseDicCategory
/// ///               User.DHCMRCBaseDicSubCategory
/// ///               User.DHCMRCBaseDictionary
/// /// Input：       treeNode ID
/// /// Return：      返回树形结构json串
/// /// Modify:       zhaoyu    Description:SQLQuery改为自定义Query    Date:2012-10-29
/// /// 
/// /// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryDicTree","5-cate")
Query QryDicTree(NodeID As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String")
{
}

ClassMethod QryDicTreeExecute(ByRef qHandle As %Binary, NodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set parentId=$p(NodeID,"-",1)
	set type=$p(NodeID,"-",2)
	
	If ((type="")||(type="root")){
	//原来代码的type="",对应属性postfix="-subcate",leaf="true" 
		If (type=""){
			Set postfix="-subcate"
			set leaf="true" 
		}Else{
			Set postfix="-cate"
			set leaf="false"
		}
		
		Set BDCateRowID=""
		For
		{
			Set BDCateRowID=$o(^DHCMRC("BDC",BDCateRowID))
			Quit:BDCateRowID=""
			
			Set ObjBaseDicCategory=##class(User.DHCMRCBaseDicCategory).%OpenId(BDCateRowID)
			Set BaseDicCategoryID=ObjBaseDicCategory.%Id()
			Set BDCDesc=ObjBaseDicCategory.BDCDesc
			
			Set id=BaseDicCategoryID_postfix
			Set text=BDCDesc
			Set ^CacheTemp(repid,ind)=$lb(id,text,leaf)
			Set ind=ind+1
			
			Do ObjBaseDicCategory.%Close()
		}
	}

	ElseIf (type="cate"){
		Set postfix="-subcate"
		set leaf="true"
		
		Set BDSubCateRowID=""
		For
		{
			Set BDSubCateRowID=$o(^DHCMRC("BDC",parentId,"SUB",BDSubCateRowID))
			Quit:BDSubCateRowID=""
			
			Set BDSCRowId=parentId_"||"_BDSubCateRowID
			Set ObjBaseDicSubCategory=##class(User.DHCMRCBaseDicSubCategory).%OpenId(BDSCRowId)
			Set BaseDicSubCategoryID=ObjBaseDicSubCategory.%Id()              //应该取rowid
			Set BDSCDesc=ObjBaseDicSubCategory.BDSCDesc
			Set BDSCType=ObjBaseDicSubCategory.BDSCType
			Set BDSCParRef=ObjBaseDicSubCategory.BDSCParRef.%Id()
			
			//	过滤不是字典类型的数据
			Continue:(BDSCType'="DIC")||(BDSCParRef'=parentId)
			
			Set id=BaseDicSubCategoryID_postfix
			Set text=BDSCDesc
			Set ^CacheTemp(repid,ind)=$lb(id,text,leaf)
			Set ind=ind+1
			
			Do ObjBaseDicSubCategory.%Close()
		}
	}
	
	ElseIf (type="subcate"){
		set postfix="-dic"
		set leaf="true"
		
		Set BDRowID=""
		For
		{
			Set BDRowID=$o(^DHCMRC("BD",BDRowID))
			Quit:BDRowID=""
			
			Set ObjBaseDictionary=##class(User.DHCMRCBaseDictionary).%OpenId(BDRowID)
			Set BaseDictionaryID=ObjBaseDictionary.%Id()
			Set BDDesc=ObjBaseDictionary.BDDesc
			Set BDTypeDR=ObjBaseDictionary.BDTypeDR.%Id()
			
			//	过滤基础字典项目子类
			Continue:(BDTypeDR'=parentId)
			
			Set id=BaseDictionaryID_postfix
			Set text=BDDesc
			Set ^CacheTemp(repid,ind)=$lb(id,text,leaf)
			Set ind=ind+1
			
			Do ObjBaseDictionary.%Close()
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDicTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTreeExecute ]
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

}
