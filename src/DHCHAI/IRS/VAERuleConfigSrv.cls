/// 名称: DHCHAI.IRS.VAERuleConfigSrv
/// 描述: VAE监测项规则服务类
/// 编写者: zhoubo
/// 编写日期: 2022-01-13
Class DHCHAI.IRS.VAERuleConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-04-01
/// Description:  根据检测项目以及子项Code获取参数配置
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      参数信息
/// w ##class(DHCHAI.IRS.VAERuleConfigSrv).GetArgByCode("3","7")
ClassMethod GetArgByCode(aMonItemID As %String, aSubCode As %String) As %String
{
	New (aMonItemID,aSubCode)
	Set return=""
	Quit:(aMonItemID="")||(aSubCode="") return
	
	Set SubItemID=##class(DHCHAI.IR.VAESubItem).GetIDByCode(aSubCode)
	Quit:SubItemID="" return
	Set ID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonItemID,SubItemID,0))
	Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(ID)
	Quit:'$Isobject(obj) return
	
	Set VAEIsActive = obj.VAEIsActive
	Quit:(VAEIsActive'=1) return
	Set VAEArg1  = obj.VAEArg1
	Set VAEArg2  = obj.VAEArg2
	Set VAEArg3  = obj.VAEArg3
	Set VAEArg4  = obj.VAEArg4
	Set VAEArg5  = obj.VAEArg5
	Set VAEArg6  = obj.VAEArg6
	
	Set return = VAEArg1_"^"_VAEArg2_"^"_VAEArg3_"^"_VAEArg4_"^"_VAEArg5_"^"_VAEArg6
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测规则-抗菌药物
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAERuleConfigSrv","QryVAERuleAnti","1","ItmCode5A2")
Query QryVAERuleAnti(aMonitItemDr As %String, aClickEventID As %String) As %Query(ROWSPEC = "ID:%String,aMonitItemDr:%String,SubItemID:%String,AntiDr:%String,AntiDesc:%String,DictionDr:%String,DictionDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVAERuleAntiExecute(ByRef qHandle As %Binary, aMonitItemDr As %String, aClickEventID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aMonitItemDr="")||(aClickEventID="") $$$OK
	
	Set ArgNo = $p(aClickEventID,"A",2)
	Set VASItmCode = +$e(aClickEventID,8,$l(aClickEventID))
	Set SubItemID = ##class(DHCHAI.IR.VAESubItem).GetIDByCode(VASItmCode)
	Quit:SubItemID="" $$$OK
	Set objSItm=##class(DHCHAI.IR.VAESubItem).GetObjById(SubItemID)
	Quit:'$IsObject(objSItm) $$$OK
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonitItemDr,SubItemID,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set ObjItem = obj.VAEMonitItemDr
		Continue:'$isObject(ObjItem)
		Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
		X ExpInfo
		Continue:VAEArg=""
		For i=1:1:$l(VAEArg,"#"){
			Set ArgInfo=$p(VAEArg,"#",i)
			Continue:ArgInfo=""
			Set AntiDr = $p(ArgInfo,",",1)
			Set objAnti=##class(DHCHAI.DP.OEAntiMast).GetObjById(AntiDr)
			Continue:'$isObject(objAnti)
			Set AntiDesc = objAnti.BTName
			Set DictionDr = $p(ArgInfo,",",2)
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DictionDr)
			Continue:'$isObject(objDic)
			Set DictionDesc = objDic.BTDesc
			
			Set Data=$lb(xID,aMonitItemDr,SubItemID,AntiDr,AntiDesc,DictionDr,DictionDesc)
   	 		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryVAERuleAntiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAERuleAntiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVAERuleAntiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAERuleAntiExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测规则-病原体
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAERuleConfigSrv","QryVAERuleBact","1","ItmCode5A2")
Query QryVAERuleBact(aMonitItemDr As %String, aClickEventID As %String) As %Query(ROWSPEC = "ID:%String,aMonitItemDr:%String,SubItemID:%String,BactDr:%String,BactDesc:%String,DictionDr:%String,DictionDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVAERuleBactExecute(ByRef qHandle As %Binary, aMonitItemDr As %String, aClickEventID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aMonitItemDr="")||(aClickEventID="") $$$OK
	
	Set ArgNo = $p(aClickEventID,"A",2)
	Set VASItmCode = +$e(aClickEventID,8,$l(aClickEventID))
	Set SubItemID = ##class(DHCHAI.IR.VAESubItem).GetIDByCode(VASItmCode)
	Quit:SubItemID="" $$$OK
	Set objSItm=##class(DHCHAI.IR.VAESubItem).GetObjById(SubItemID)
	Quit:'$IsObject(objSItm) $$$OK
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonitItemDr,SubItemID,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set ObjItem = obj.VAEMonitItemDr
		Continue:'$isObject(ObjItem)
		Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
		X ExpInfo
		Continue:VAEArg=""
		For i=1:1:$l(VAEArg,"#"){
			Set ArgInfo=$p(VAEArg,"#",i)
			Continue:ArgInfo=""
			Set BactDr = $p(ArgInfo,",",1)
			Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BactDr)
			Continue:'$isObject(objBact)
			Set BactDesc = objBact.BTBacDesc
			Set DictionDr = $p(ArgInfo,",",2)
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DictionDr)
			Continue:'$isObject(objDic)
			Set DictionDesc = objDic.BTDesc
			
			Set Data=$lb(xID,aMonitItemDr,SubItemID,BactDr,BactDesc,DictionDr,DictionDesc)
   	 		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryVAERuleBactClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAERuleBactExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVAERuleBactFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAERuleBactExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测规则-标本
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAERuleConfigSrv","QryVAERuleSpec","1","ItmCode5A2")
Query QryVAERuleSpec(aMonitItemDr As %String, aClickEventID As %String) As %Query(ROWSPEC = "ID:%String,aMonitItemDr:%String,SubItemID:%String,SpecDescDr:%String,SpecDesc:%String,DictionDr:%String,DictionDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVAERuleSpecExecute(ByRef qHandle As %Binary, aMonitItemDr As %String, aClickEventID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aMonitItemDr="")||(aClickEventID="") $$$OK
	
	Set ArgNo = $p(aClickEventID,"A",2)
	Set VASItmCode = +$e(aClickEventID,8,$l(aClickEventID))
	Set SubItemID = ##class(DHCHAI.IR.VAESubItem).GetIDByCode(VASItmCode)
	Quit:SubItemID="" $$$OK
	Set objSItm=##class(DHCHAI.IR.VAESubItem).GetObjById(SubItemID)
	Quit:'$IsObject(objSItm) $$$OK
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonitItemDr,SubItemID,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set ObjItem = obj.VAEMonitItemDr
		Continue:'$isObject(ObjItem)
		Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
		X ExpInfo
		Continue:VAEArg=""
		For i=1:1:$l(VAEArg,"#"){
			Set ArgInfo=$p(VAEArg,"#",i)
			Continue:ArgInfo=""
			Set SpecDescDr = $p(ArgInfo,",",1)
			Set objSpec=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecDescDr)
			Continue:'$isObject(objSpec)
			Set SpecDesc = objSpec.BTSpecDesc
			Set DictionDr = $p(ArgInfo,",",2)
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DictionDr)
			Continue:'$isObject(objDic)
			Set DictionDesc = objDic.BTDesc
			
			Set Data=$lb(xID,aMonitItemDr,SubItemID,SpecDescDr,SpecDesc,DictionDr,DictionDesc)
   	 		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryVAERuleSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAERuleSpecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVAERuleSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAERuleSpecExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测规则检验医嘱
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAERuleConfigSrv","QryVAERuleLab","1","ItmCode5A1")
Query QryVAERuleLab(aMonitItemDr As %String, aClickEventID As %String) As %Query(ROWSPEC = "ID:%String,aMonitItemDr:%String,SubItemID:%String,TestSetDr:%String,TestSetDesc:%String,DictionDr:%String,DictionDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVAERuleLabExecute(ByRef qHandle As %Binary, aMonitItemDr As %String, aClickEventID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aMonitItemDr="")||(aClickEventID="") $$$OK
	
	Set ArgNo = $p(aClickEventID,"A",2)
	Set VASItmCode = +$e(aClickEventID,8,$l(aClickEventID))
	Set SubItemID = ##class(DHCHAI.IR.VAESubItem).GetIDByCode(VASItmCode)
	Quit:SubItemID="" $$$OK
	Set objSItm=##class(DHCHAI.IR.VAESubItem).GetObjById(SubItemID)
	Quit:'$IsObject(objSItm) $$$OK
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonitItemDr,SubItemID,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set ObjItem = obj.VAEMonitItemDr
		Continue:'$isObject(ObjItem)
		Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
		X ExpInfo
		Continue:VAEArg=""
		For i=1:1:$l(VAEArg,"#"){
			Set ArgInfo=$p(VAEArg,"#",i)
			Continue:ArgInfo=""
			Set TestSetDr = $p(ArgInfo,",",1)
			Set objTestSet=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetDr)
			Continue:'$isObject(objTestSet)
			Set TestSetDesc = objTestSet.BTTestSet
			Set DictionDr = $p(ArgInfo,",",2)
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DictionDr)
			Continue:'$isObject(objDic)
			Set DictionDesc = objDic.BTDesc
			
			Set Data=$lb(xID,aMonitItemDr,SubItemID,TestSetDr,TestSetDesc,DictionDr,DictionDesc)
   	 		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryVAERuleLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAERuleLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVAERuleLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAERuleLabExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测规则
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAERuleConfigSrv","QueryVAERule","1")
Query QueryVAERule(aMonitItemDr As %String, aSubItemDr As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,MonitItemDr:%String,VAItmCode:%String,VAItmDesc:%String,VAResume:%String,SubItemDr:%String,VASItmCode:%String,VASItmDesc:%String,VASResume:%String,VAEArg1:%String,VAEArg2:%String,VAEArg3:%String,VAEArg4:%String,VAEArg5:%String,VAEArg6:%String,VAEArg7:%String,VAEArg8:%String,VAEArg9:%String,VAEArg10:%String,VAEArg11:%String,VAEArg12:%String,VAEArg13:%String,VAEArg14:%String,VAEArg15:%String,VAERuleLogic:%String,VAEIsActive:%String,VAEActDate:%String,VAEActTime:%String,VAEActUserDr:%String,VAEActUser:%String") [ SqlProc ]
{
}

ClassMethod QueryVAERuleExecute(ByRef qHandle As %Binary, aMonitItemDr As %String, aSubItemDr As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aMonitItemDr="") $$$OK
	If (aSubItemDr'=""){
		Set xID=""
		For {
			Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",aMonitItemDr,aSubItemDr,xID))
			Quit:xID=""
			
			Do BuildData
		}
	}Else{
		Set xID=""
		For {
			Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemDr",aMonitItemDr,xID))
			Quit:xID=""
			
			Do BuildData
		}
	}
	Quit $$$OK
	
BuildData
	Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
	Quit:'$Isobject(obj)
	Set ObjItem  = obj.VAEMonitItemDr
	Quit:'$isObject(ObjItem)
	Set MonitItemDr = ObjItem.%Id()
	Set VAItmCode   = ObjItem.VAItmCode
	Set VAItmDesc   = ObjItem.VAItmDesc
	Set VAResume    = ObjItem.VAResume
	
	Set ObjSItem    = obj.VAESubItemDr
	Quit:'$isObject(ObjSItem)
	Set SubItemDr   = ObjSItem.%Id()
	Set VASItmCode  = ObjSItem.VASItmCode
	Set VASItmDesc  = ObjSItem.VASItmDesc
	Set VASResume   = ObjSItem.VASResume
	
	Set VAEArg1  = obj.VAEArg1
	Set VAEArg2  = obj.VAEArg2
	Set VAEArg3  = obj.VAEArg3
	Set VAEArg4  = obj.VAEArg4
	Set VAEArg5  = obj.VAEArg5
	Set VAEArg6  = obj.VAEArg6
	Set VAEArg7  = obj.VAEArg7
	Set VAEArg8  = obj.VAEArg8
	Set VAEArg9  = obj.VAEArg9
	Set VAEArg10 = obj.VAEArg10
	Set VAEArg11 = obj.VAEArg11
	Set VAEArg12 = obj.VAEArg12
	Set VAEArg13 = obj.VAEArg13
	Set VAEArg14 = obj.VAEArg14
	Set VAEArg15 = obj.VAEArg15
	Set VAERuleLogic = obj.VAERuleLogic
	Set VAEIsActive = +obj.VAEIsActive
	Quit:(aIsActive'="")&&(VAIsActive'=aIsActive)
	Set VAEActDate = obj.VAEActDate
	Set:VAEActDate'="" VAEActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEActDate)
	Set VAEActTime = obj.VAEActTime
	Set:VAEActTime'="" VAEActTime=$zt(VAEActTime,1)
	
	If $IsObject(obj.VAEActUserDr) {
		Set VAEActUserDr = obj.VAEActUserDr.%Id()
		Set VAEActUser   = obj.VAEActUserDr.BTDesc
	} Else {
		Set VAEActUserDr="",VAEActUser=""
	}
	
	Set Data=$lb(xID,MonitItemDr,VAItmCode,VAItmDesc,VAResume,SubItemDr,VASItmCode,VASItmDesc,VASResume,VAEArg1,VAEArg2,VAEArg3,VAEArg4,VAEArg5,VAEArg6,VAEArg7,VAEArg8,VAEArg9,VAEArg10,VAEArg11,VAEArg12,VAEArg13,VAEArg14,VAEArg15,VAERuleLogic,VAEIsActive,VAEActDate,VAEActTime,VAEActUserDr,VAEActUser)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	Quit 1
}

ClassMethod QueryVAERuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVAERuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryVAERuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVAERuleExecute ]
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
