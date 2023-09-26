Class DHCMA.CPW.SDS.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  判断是否重复 ：确定atype 判断code是否唯一，接着判断id是否唯一
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input:        aTypeDr,aCode,aID 
/// d ##class(DHCMA.CPW.SDS.DictionarySrv).CheckPTCode(1,1)
ClassMethod CheckPTCode(aTypeDr As %String, aCode As %String, aID As %String = "") As %String
{
	New (aTypeDr,aCode,aID)
	Set return=""
	Quit:(aTypeDr="")||(aCode="") return
	
	//由atype、code 判断id是否唯一
	If ($d(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",aTypeDr," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",aTypeDr," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Description:  根据类型ID取数据
/// Table：       DHCMA.CPW.SD.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.DictionarySrv","QryDicByTypeID","1662")
Query QryDicByTypeID(aTypeDr As %String, aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,TypeDesc:%String,BTIndNo,BTIsActive:%String,BTActDate:%Date,BTActTime:%Time,BTActUserDesc:%String,IsDefault:%String,Resume:%String,Group:%String")
{
}

ClassMethod QryDicByTypeIDExecute(ByRef qHandle As %Binary, aTypeDr As %String, aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aTypeDr="" $$$OK
 	Set xID=""
 	For {
 		Set xID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeDr,xID))
 		Quit:xID=""
	 	Set obj      = ##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	continue:(aKey'="")&&(Code'[aKey)&&(Desc'[aKey)
	 	Set TypeDesc="" , TypeID=""
	 	if (obj.BTTypeDr){
	    	Set TypeDesc = obj.BTTypeDr.BTDesc
	   		Set TypeID   = obj.BTTypeDr.%Id()
	 	}
	    Continue:aTypeDr'=TypeID
	    Set IndNo    = obj.BTIndNo
	 	Set IsActive = obj.BTIsActive
	 	Set ActDate  = obj.BTActDate
	 	Set ActTime  = obj.BTActTime  
	 	Set ActUserID= obj.BTActUserID  
	 	Set ActDate  = $ZD(ActDate,3)
	 	Set ActTime  = $ZT(ActTime,1)  
	 	Set ActUserID= obj.BTActUserID     
	 	Set IsDefault= obj.BTIsDefault
	 	Set Resume	 = obj.BTResume
	 	Set Group	 = obj.BTGroup

	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}    
	 	//翻译字典描述
 		Set Desc=##class(DHCMA.CPW.SD.Dictionary).GetTranByDesc("BTDesc",Desc)
		Set Data=$lb(xID,Code,Desc,TypeDesc,IndNo,IsActive,ActDate,ActTime,ActUserDesc,IsDefault,Resume,Group)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
 	}
	Quit $$$OK
}

ClassMethod QryDicByTypeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByTypeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicByTypeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByTypeIDExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-09-08
/// Description:  根据类型取字典
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input：       
/// output:   BTCode:%String,BTDesc:%String,BTIsActive:%String,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.DictionarySrv","QryDictByType","33","2","VTE-0-1-1",1)
Query QryDictByType(aQCID As %String, aVersion As %String, aTypeCode As %String, aIsActive As %String = "", aKey As %String = "", aAddItem As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeDr:%String,BTIndNo,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String,IsDefault:%String,Resume:%String,Group:%String")
{
}

ClassMethod QryDictByTypeExecute(ByRef qHandle As %Binary, aQCID As %String, aVersion As %String, aTypeCode As %String, aIsActive As %String = "", aKey As %String = "", aAddItem As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz419=$lb(aQCID,aVersion,aTypeCode,aIsActive)
 	Quit:aTypeCode="" $$$OK
 	Set objType = ##class(DHCMA.CPW.SD.DicType).GetObjByCode(aQCID,aVersion,aTypeCode)
 	Quit:'$Isobject(objType) $$$OK
 	Set TypeDr = objType.%Id()
 	Set xID="",Count=0
 	For {
 		Set xID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",TypeDr,xID))
 		Quit:xID=""	
	 	Set BTObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(BTObj)
	 	Set Code         = BTObj.BTCode
	 	Set Desc         = BTObj.BTDesc
	 	If (aKey'="") {
		 	Set MatchFlg=0
		 	for ikey=1:1:$l(aKey,",") {  //兼容多个以逗号分隔的关键字过滤情况
				Set xkey=$p(aKey,",",ikey)
				Continue:xkey=""
				Set:(Code[xkey)||(Desc[xkey) MatchFlg=1
				if (MatchFlg=0) {
					//范围匹配
					Set dicICD=$p(Desc," ",1)
			 		Set MatchFlg=##Class(DHCMA.CPW.SDS.QCExpressSrv).CheckICDArea(dicICD,xkey)
				}
		 	}
		 	Continue:MatchFlg<1
		}
	    Set BTTypeDr     = BTObj.BTTypeDr.BTDesc
	    Set BTIndNo      = BTObj.BTIndNo
	    Set IsActive	 = BTObj.BTIsActive
	 	Continue:(aIsActive'="")&&(IsActive'=1)
	 	Set BTActDate        = $ZD(BTObj.BTActDate,3)
	 	Set BTActTime        = $Zt(BTObj.BTActTime)   
	 	Set BTActUserID      = BTObj.BTActUserID     
	 	Set IsDefault		 = BTObj.BTIsDefault
	 	Set Resume			 = BTObj.BTResume
	 	Set Group			 = BTObj.BTGroup
	 	Set Count=Count+1
	 	//翻译字典描述
 		Set Desc=##class(DHCMA.CPW.SD.Dictionary).GetTranByDesc("BTDesc",Desc)
		Set Data=$lb(xID,Code,Desc,BTTypeDr,BTIndNo,IsActive,BTActDate,BTActTime,BTActUserID,IsDefault,Resume,Group)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDictByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictByTypeExecute ]
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

/// s a=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode("CS-5-1","b")
ClassMethod GetObjByPCodeItemCode(aQCID As %String, aVersion As %String, PCode As %String, Alias As %String) As DHCMA.Util.BT.Dictionary
{
	n (aQCID,aVersion,PCode,Alias)
	Set:aVersion="" aVersion=1
	Set return="",Alias=$ZCVT(Alias,"U")
	Set DicTypeObj=##class(DHCMA.CPW.SD.DicType).GetObjByCode(aQCID,aVersion,PCode)
	Quit:'$IsObject(DicTypeObj) return
	Set DicId=DicTypeObj.%Id()
	Set ItemID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicId," "_Alias,""),-1)
	Set ItemObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemID)
	Quit:'$IsObject(ItemObj) return
	Quit ItemObj
}

/// w ##class(DHCMA.CPW.SDS.DictionarySrv).ImportDicItem(^tmpzgz1021,$c(1))
ClassMethod ImportDicItem(inputStr As %String, aSeparete = "^") As %String
{
	n (inputStr,aSeparete)
	Set ret=-1
	Set TypeCode   	= $p(inputStr,aSeparete,4)
	s ^tmpzgz1021=inputStr
	If (+TypeCode>0) {
		//兼容直接传入类型ID的情况
		Set TypeDr		= TypeCode
	}else {
		//新表单版本直接传入类型ID，不通过Code再次取值运算
		Quit "-1"
		Set TypeObj		= ##class(DHCMA.CPW.SD.DicType).GetObjByCode(TypeCode)
		Quit:'$IsObject(TypeObj) ret
		Set TypeDr		= TypeObj.%Id()
	}
	Set $p(inputStr,aSeparete,4)=TypeDr
	//导入新字典时，将该字典类型下的字典项置为无效
	d ..DisabledItemDic(TypeDr)
	Set xCode= $p(inputStr,aSeparete,2)
	Set ID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr," "_$ZCVT(xCode,"U"),0))
	If (ID'="") {
		//已存在的字典保留其默认项信息
		Set obj=##class(DHCMA.CPW.SD.Dictionary).%OpenId(ID)
		Set xDefault=obj.BTIsDefault
		Set $p(inputStr,aSeparete,10)=xDefault
	}
	Set ret=##class(DHCMA.CPW.SD.Dictionary).Update(inputStr,aSeparete)
	Quit ret
}

/// w ##class(DHCMA.CPW.SDS.DictionarySrv).GetDicsByTypeCode("Cap_Adult_CURB_65")
ClassMethod GetDicsByTypeCode(aQCID, aVerID As %String, aTypeCode As %String, aMrListID As %String = "") As %String
{
	new (aQCID,aVerID,aTypeCode,aMrListID)
	Set:aVerID="" aVerID=1
	Set objType = ##class(DHCMA.CPW.SD.DicType).GetObjByCode(aQCID,aVerID,aTypeCode)
 	Quit:'$Isobject(objType) ""
 	Set TypeDr = objType.%Id()
 	Set xCode = "",return="",Records=""
 	If (aMrListID'="") {
		Set QCItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,aTypeCode)
		If $IsObject(QCItemObj) {
			Set ItemID=QCItemObj.%Id()
		 	Set ID=$o(^DHCMA.CPW.SD.QCMrListScoreI("IndexMrItem"," "_aMrListID,ItemID,""),-1)
			Set obj=##class(DHCMA.CPW.SD.QCMrListScore).%OpenId(ID)
			Set:$IsObject(obj) Records=obj.ScoreRecords
		}
	}
 	For {
	 	Set xCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
	 	Quit:xCode=""
	 	Set RowID = ""
	 	For {
		   	Set RowID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,RowID))
		   	Quit:RowID=""
		 	Set BTObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(RowID)
		 	Continue:'$IsObject(BTObj)
		 	Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTDesc
		    Set BTTypeDr     = BTObj.BTTypeDr.BTDesc
		    Set BTIndNo      = BTObj.BTIndNo
		 	Continue:BTObj.BTIsActive'=1
		 	Set Resume			 = BTObj.BTResume
		 	Set Group			 = BTObj.BTGroup
		 	Set Checked=0
		 	Set:Records[Code Checked=1
	 		Set return=return_RowID_$c(2)_Desc_$c(2)_+Resume_$c(2)_Group_$c(2)_Code_$c(2)_Checked_$c(1)
 		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

/// 批量无效字典类型值域字典
/// w ##class(DHCMA.CPW.SDS.DictionarySrv).DisabledItemDic(12)
ClassMethod DisabledItemDic(aTypeID As %String) As %String
{
	New (aTypeID)
	//如果导入当天已经导入了当前版本，退出
	Quit:$d(^DHCMADisabledVerItem("Dic",aTypeID,+$h)) ""
	Set xID="",Count=0
 	For {
 		Set xID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeID,xID))
 		Quit:xID=""	
	 	Set obj= ##class(DHCMA.CPW.SD.Dictionary).%OpenId(xID)
	 	Continue:'$IsObject(obj)
	    Set obj.BTIsActive=0
	    Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=obj.%Id()
			Set Count=Count+1
		}
		Do obj.%Close()
 	}
	Set ^DHCMADisabledVerItem("Dic",aTypeID,+$h)="字典导入更新日期："_$zd(+$h)_" "_$zt($p($h,",",2))
	Quit "无效字典："_Count_"个"
}

/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.DictionarySrv","QryDicByItemID","1||134")
Query QryDicByItemID(aItemID As %String, aActive As %String = "") As %Query(ROWSPEC = "id:%String,code:%String,text:%String")
{
}

ClassMethod QryDicByItemIDExecute(ByRef qHandle As %Binary, aItemID As %String, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aItemID="" $$$OK
 	Set aTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
 	Quit:aTypeDr="" $$$OK
 	Set xID=""
 	For {
 		Set xID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeDr,xID))
 		Quit:xID=""
	 	Set obj      = ##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	Set TypeDesc="" , TypeID=""
	 	if (obj.BTTypeDr){
	    	Set TypeDesc = obj.BTTypeDr.BTDesc
	   		Set TypeID   = obj.BTTypeDr.%Id()
	 	}
	    Continue:aTypeDr'=TypeID
	    Set IndNo    = obj.BTIndNo
	 	Set IsActive = obj.BTIsActive
	 	Continue:(aActive'="")&&(aActive'=IsActive)
	 	Set ActDate  = obj.BTActDate
	 	Set ActTime  = obj.BTActTime  
	 	Set ActUserID= obj.BTActUserID  
	 	Set ActDate  = $ZD(ActDate,3)
	 	Set ActTime  = $ZT(ActTime,1)  
	 	Set ActUserID= obj.BTActUserID     
	 	Set IsDefault= obj.BTIsDefault
	 	Set Resume	 = obj.BTResume
	 	Set Group	 = obj.BTGroup

	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}    
		Set Data=$lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
 	}
	Quit $$$OK
}

ClassMethod QryDicByItemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByItemIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicByItemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByItemIDExecute ]
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

}
