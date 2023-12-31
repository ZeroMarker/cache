/// 名称: DHCHAI.BTS.DictionarySrv
/// 描述: 字典相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-23
Class DHCHAI.BTS.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据类型查询字典（字典维护用）
/// Table：       DHCHAI.BT.Dictionary
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DictionarySrv","QryDictionary","2")
Query QryDictionary(aTypeID As %String) As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicDesc:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary, aTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",aTypeID,xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",aTypeID,xCode,xID))
			Quit:xID=""
			
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$Isobject(objDic)
			
			Set DicCode  = objDic.BTCode
		    Set DicDesc  = objDic.BTDesc	
		    Set TypeCode="",TypeDesc=""
		    If $Isobject(objDic.BTTypeDr){
			    Set TypeCode=objDic.BTTypeDr.BTCode
			    Set TypeDesc=objDic.BTTypeDr.BTDesc
		    }
		    Set IndNo    = objDic.BTIndNo
		    Set IsActive = objDic.BTIsActive
	        Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
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
/// CreatDate：   2017-03-23
/// Description:  根据类型查询字典（下拉框用）
/// Table：       DHCHAI.BT.Dictionary
/// Input：     aFlag 新冠监测标志，0输出整个列表，1输出阴性，阳性  
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DictionarySrv","QryDic","OERegStatus","")
Query QryDic(aTypeCode As %String, aActive As %String = "", aFlag As %String = "") As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicDesc:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDicExecute(ByRef qHandle As %Binary, aTypeCode As %String, aActive As %String = "", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeCode="" $$$OK
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) $$$OK
	Set TypeID=objType.%Id()
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode,xID))
			Quit:xID=""
			
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$Isobject(objDic)
			
			Set DicCode  = objDic.BTCode
		    Set DicDesc  = objDic.BTDesc	
		    Set TypeCode="",TypeDesc=""
		    If $Isobject(objDic.BTTypeDr){
			    Set TypeCode=objDic.BTTypeDr.BTCode
			    Set TypeDesc=objDic.BTTypeDr.BTDesc
		    }
		    Set IndNo    = objDic.BTIndNo
		    Set IsActive = objDic.BTIsActive
		   	Continue:(aActive'="")&&(aActive'=IsActive)
	        Set IsActDesc=$s(IsActive=1:"是",1:"否")
	        
	        //特殊处理[职业暴露不显示删除状态]
	        Continue:(aTypeCode="OERegStatus")&&(DicDesc["删除")
	        //特殊处理[环境卫生学新冠监测只需要阴性，阳性]
	        Continue:(aFlag=1)&&(DicDesc'["阴性")&&(DicDesc'["阳性")
	        //多语言字典描述处理
	        Set DicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",DicDesc,"DHCHAI.BT.Dictionary")
			Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicExecute ]
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
/// CreatDate：   2017-03-23
/// Description:  根据描述获得字典ID
/// Table：       DHCHAI.BT.Dictionary
/// w ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("CuteType","Ⅰ类","1")
ClassMethod GetIDByDesc(aType As %String, aDesc As %String, aActive As %String = "") As %String
{
	New (aType,aDesc,aActive)
	Set return=""
	Quit:(aType="")||(aDesc="") return
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DictionaryD(xID))
		Quit:xID=""
	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set DicCode  = objDic.BTCode		   
	    Set DicDesc  = objDic.BTDesc
	    Continue:($ZCVT(DicDesc,"U")'=$ZCVT(aDesc,"U"))	
	    Set TypeCode="",TypeDesc=""
	    If $Isobject(objDic.BTTypeDr){
		    Set TypeCode=objDic.BTTypeDr.BTCode
		    Set TypeDesc=objDic.BTTypeDr.BTDesc    
	    }
	    Continue:($ZCVT(TypeCode,"U")'=$ZCVT(aType,"U"))
	    Set IsActive = objDic.BTIsActive
	   	Continue:(aActive'="")&&(aActive'=IsActive)	
	   	
		Set return=xID
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据代码获得字典ID
/// Table：       DHCHAI.BT.Dictionary
/// w ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("LocCate","E","")
ClassMethod GetIDByCode(aType As %String, aCode As %String, aActive As %String) As %String
{
	New (aType,aCode,aActive)
	Set return=""
	Quit:(aCode="")||(aType="") return
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DictionaryD(xID))
		Quit:xID=""
	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set DicCode  = objDic.BTCode
		Continue:($ZCVT(aCode,"U")'=$ZCVT(DicCode,"U"))		   		   
	    Set DicDesc  = objDic.BTDesc
	    Set TypeCode="",TypeDesc=""
	    If $Isobject(objDic.BTTypeDr){
		    Set TypeCode=objDic.BTTypeDr.BTCode
		    Set TypeDesc=objDic.BTTypeDr.BTDesc    
	    }
	    Continue:($ZCVT(TypeCode,"U")'=$ZCVT(aType,"U"))
	    Set IsActive = objDic.BTIsActive
	   	Continue:(aActive'="")&&(aActive'=IsActive)	
	   
		Set return=xID
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据代码获得字典ID
/// Table：       DHCHAI.BT.Dictionary
/// w ##Class(DHCHAI.BTS.DictionarySrv).GetByTypeCode("LocCate","E","")
ClassMethod GetByTypeCode(aType As %String, aCode As %String, aActive As %String) As DHCHAI.BT.Dictionary
{
	New (aType,aCode,aActive)
	Set return=""
	Quit:(aCode="")||(aType="") return
	
	Quit:'$d(^DHCHAI.BT.DicTypeI("IdxofCode",aType)) return
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",aType,xID))
		Quit:xID=""
		Set xDicID = ""
		For {
			Set xDicID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xID,aCode,xDicID))
			Quit:xDicID=""

			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xDicID)
			Continue:'$Isobject(objDic)
			
		
			Do:objDic'="" objDic.%Close()
			Set IsActive = objDic.BTIsActive
		   	Continue:(aActive'="")&&(aActive'=IsActive)	
		   	
			Set return = objDic
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-24
/// Description:  导入基础字典
/// w ##Class(DHCHAI.BTS.DictionarySrv).ImportDic("^E^急诊^LocCate^1^1","^")
ClassMethod ImportDic(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Code    = $p(aInputStr,aSeparate,2)
	Set Desc    = $p(aInputStr,aSeparate,3)
	Set Type    = $p(aInputStr,aSeparate,4)
	Set IndNo   = $p(aInputStr,aSeparate,5)
	Set IsActive= $p(aInputStr,aSeparate,6)

	Quit:'$d(^DHCHAI.BT.DicTypeI("IdxofCode",Type)) return
    Set TypeID=""
	Set xTypeID = ""
	For {
		Set xTypeID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",Type,xTypeID))
		Quit:xTypeID=""
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjById(xTypeID)
		Continue:'$IsObject(objDicType)
		Set TypeID=xTypeID
	}
  
	Set DicRowID=""
	Set DicID=0
	For {
		Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,Code,DicID))
		Quit:DicID=""

		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set DicRowID=DicID
	}	
	Set InputStr=DicRowID_aSeparate_Code_aSeparate_Desc_aSeparate_TypeID_aSeparate_IndNo_aSeparate_IsActive
	Set return=##Class(DHCHAI.BT.Dictionary).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-24
/// Description:  删除基础字典
/// w ##Class(DHCHAI.BTS.DictionarySrv).DeleteDic("E","LocCate")
ClassMethod DeleteDic(aCode As %String, aType As %String) As %String
{
	New (aCode,aType)
	Set return=-1
	Quit:(aCode="")||(aType="") return
	
	Set $ZT="DeleteDicErr"
	
	Quit:'$d(^DHCHAI.BT.DicTypeI("IdxofCode",aType)) return
	Set xTypeID = ""
	For {
		Set xTypeID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",aType,xTypeID))
		Quit:xTypeID=""
		Set xDicID=0
		For {
			Set xDicID =$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xTypeID,aCode,xDicID))
			Quit:xDicID=""
			
			Set flg=##class(DHCHAI.BT.Dictionary).DeleteById(xDicID)
		}
	}
	Set return=1
	Quit return
	
DeleteDicErr
	Write "Error:"_$ZError,!
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2019-07-11
/// Description:  获取基础字典列表
/// Table：       DHCHAI.BT.Dictionary
/// Input：       TypeCode : 字典类型
/// Return：      %String
/// w ##class(DHCHAI.BTS.DictionarySrv).GetDicList("ANTUnReaction")
ClassMethod GetDicList(aTypeCode As %String, aIsActive As %String = "") As %String
{
	New (aTypeCode,aIsActive)
	Set return=""
	Quit:aTypeCode="" return
	
	Set $ZT="GetDicListErr"
	
	// Add by zhaoyj 2022-06-17 Global方式
	Set TypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",aTypeCode,0))
	Quit:TypeID="" return
	Set TypeData=$g(^DHCHAI.BT.DicTypeD(TypeID))
	Quit:TypeData="" return
	Set TypeDr=TypeID
	Set xCode=""
	For {
		Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,xID))
			Quit:xID=""
			
			Set Data=$g(^DHCHAI.BT.DictionaryD(xID))
			Continue:Data=""
			Continue:(aIsActive'="")&&($lg(Data,6)'=aIsActive)
			Set Code=$lg(Data,2)
			Set Desc=$lg(Data,3)
			Set return=return_$c(1)_Code_$c(2)_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetDicListErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2021-07-01
/// Description:  获取基础字典列表
/// Table：       DHCHAI.BT.Dictionary
/// Input：       TypeCode : 字典类型
/// Return：      %String
/// w ##class(DHCHAI.BTS.DictionarySrv).GetIDDicList("ANTUnReaction")
ClassMethod GetIDDicList(aTypeCode As %String, aIsActive As %String = "") As %String
{
	New (aTypeCode,aIsActive)
	Set return=""
	Quit:aTypeCode="" return
	
	Set $ZT="GetIDDicListErr"
	
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set xCode=""
	For {
		Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:(aIsActive'="")&&(obj.BTIsActive'=aIsActive)
			Set Code=obj.BTCode
			Set Desc=obj.BTDesc
			//多语言处理
			Set Desc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.BT.Dictionary")
			Set return=return_$c(1)_xID_$c(2)_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetIDDicListErr
	Quit ""
}

}
