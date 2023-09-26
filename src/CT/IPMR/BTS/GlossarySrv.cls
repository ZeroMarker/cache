/// 名称: CT.IPMR.BTS.GlossarySrv
/// 描述: 术语集字典相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BTS.GlossarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询术语集
/// Table：       CT.IPMR.BT.Glossary
/// Input：       aFPTypeID：首页类型
///               aAlias：关键字
///               aIsActive：有效标志
/// output:       符合条件术语集
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.GlossarySrv","QueryGlossary","128","007","")
Query QueryGlossary(aFPTypeID As %String, aAlias As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,FPTypeID:%String,FPTypeDesc:%String,Code:%String,Desc:%String,DataTypeID:%String,DataTypeDesc:%String,Resume:%String,FPTypeCode:%String,DataTypeCode:%String,IsActive:%String,IsActiveDesc:%String,MapDataItemCode:%String,MapDataItemDesc:%String")
{
}

ClassMethod QueryGlossaryExecute(ByRef qHandle As %Binary, aFPTypeID As %String, aAlias As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xFPTypeID = ""
 	For {
		Set xFPTypeID = $o(^CT.IPMR.BT.GlossaryI("IndexFPTypeCode",xFPTypeID)) 
		Quit:xFPTypeID=""
		Continue:(aFPTypeID'="")&&(aFPTypeID'=xFPTypeID)
		Set xCode = ""
	 	For {
			Set xCode = $o(^CT.IPMR.BT.GlossaryI("IndexFPTypeCode",xFPTypeID,xCode))
			Quit:xCode=""
			
			Set xID = ""
			For {
				Set xID = $o(^CT.IPMR.BT.GlossaryI("IndexFPTypeCode",xFPTypeID,xCode,xID))
				Quit:xID=""
				Set objGlossary = ##class(CT.IPMR.BT.Glossary).GetObjById(xID)
				Continue:'$ISObject(objGlossary)
				Set objFPType = objGlossary.BGFPTypeDr
				Set Code = objGlossary.BGCode
				Set Desc = objGlossary.BGDesc
				Set objDataType = objGlossary.BGDataTypeDr
				Set IsActive = objGlossary.BGIsActive
				Set Resume = objGlossary.BGResume
				IF aAlias'="" {
					Continue:'((Code[aAlias)||(Desc[aAlias))
				}
				Set (FPTypeID,FPTypeDesc)=""
				If $IsObject(objFPType){
					Set FPTypeID   = objFPType.%Id()
					Set FPTypeDesc = objFPType.BDDesc
					
					Set FPTypeCode = objFPType.BDCode
				}
				Set (DataTypeID,DataTypeDesc)=""
				If $IsObject(objDataType){
					Set DataTypeID   = objDataType.%Id()
					Set DataTypeDesc = objDataType.BDDesc
					
					Set DataTypeCode = objDataType.BDCode
				}
				
				Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
				// 已对照信息
				Set (MapDataItemCode,MapDataItemDesc)=""
				if $d(^CT.IPMR.FP.DataItemMapI("IndexGlossaryDr",xID)) {
					Set MapID = $o(^CT.IPMR.FP.DataItemMapI("IndexGlossaryDr",xID,""))
					Set objMap=##class(CT.IPMR.FP.DataItemMap).GetObjById(MapID)
					If $isobject(objMap) {
						If $isobject(objMap.FDDataItemDr) {
							Set MapDataItemCode = objMap.FDDataItemDr.FDCode
							Set MapDataItemDesc = objMap.FDDataItemDr.FDDesc
						}
					}
				}
				Set Data=$lb(xID,FPTypeID,FPTypeDesc,Code,Desc,DataTypeID,DataTypeDesc,Resume,FPTypeCode,DataTypeCode,IsActive,IsActiveDesc,MapDataItemCode,MapDataItemDesc)
       	 		Set ^CacheTemp(repid,ind)=Data
        		Set ind=ind+1
			} 
		}
	}
	Quit $$$OK
}

ClassMethod QueryGlossaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGlossaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryGlossaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGlossaryExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  导入术语集
/// Table：       CT.IPMR.BT.Glossary
/// Input：       术语集
/// w ##class("CT.IPMR.BTS.GlossarySrv").ImportGlossary("")
ClassMethod ImportGlossary(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return = 0
	Quit:aInput="" return
	Set FPTypeDesc = $p(aInput,aSeparate,2)
	Set objFPType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("FrontPageType",FPTypeDesc)
	Quit:'$IsObject(objFPType) return
	
	Set DataTypeDesc = $p(aInput,aSeparate,5)
	Set objDataType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("FPDataType",DataTypeDesc)
	Quit:'$IsObject(objDataType) return
	
	Set FPTypeDr = objFPType.%Id()
	Set $p(aInput,aSeparate,2)=FPTypeDr
	Set $p(aInput,aSeparate,5)=objDataType.%Id()
	Set return = ##class(CT.IPMR.BT.Glossary).Update(aInput,aSeparate)
	Quit return
}

}
