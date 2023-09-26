/// 名称: DHCHAI.IRS.EnviHyItemSrv
/// 描述: 环境卫生学监测项目服务
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IRS.EnviHyItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  查询监测项目
/// Table：       DHCHAI.IR.EnviHyItem
/// Input：       aLocID 通过监测科室的院区信息  筛选监测项目
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyItemSrv","QryEvItem","","",428)
Query QryEvItem(aIsActive As %String = "", aLocID As %String = "", EvItemFL As %String = "", aAlis As %String = "") As %Query(ROWSPEC = "ID:%String,ItemDesc:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,Norm:%String,NormMax:%String,NormMin:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,ForMula:%String,Freq:%String,Uom:%String,IsActive:%String,IsActDesc:%String,ItemTypeID:%String,ItemTypeDesc:%String,EnvironmentCateID:%String,EnvironmentCateDesc:%String,IsObjNull:%String,IsObjNullDesc:%String,IsSpecNum:%String,IsSpecNumDesc:%String,EHEnterTypeID:%String,EHEnterTypeDesc:%String,ReferToNum:%String,HospID:%String,HospDesc:%String,LabItemDr:%String,LabItem:%String")
{
}

ClassMethod QryEvItemExecute(ByRef qHandle As %Binary, aIsActive As %String = "", aLocID As %String = "", EvItemFL As %String = "", aAlis As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospID=""
	Set LocObj=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	if ($IsObject(LocObj)) {
			Set aHospID=LocObj.BTHospDr.%Id()
		}
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyItemD(xID))
		Quit:xID=""
		
		Set objItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(xID)
		Continue:'$IsObject(objItem)
		Set ItemHospID=""
		Set:$IsObject(objItem.EHHospDr) ItemHospID=objItem.EHHospDr.%Id()
		Continue:(aHospID'="")&&(ItemHospID'="")&&(aHospID'=ItemHospID)
		Set ItemDesc 		= objItem.EHItemDesc
		
		Set SpecimenTypeID="",SpecimenTypeDesc=""
		If $IsObject(objItem.EHSpecimenTypeDr){
			Set SpecimenTypeID=objItem.EHSpecimenTypeDr.%Id()
			Set SpecimenTypeDesc=objItem.EHSpecimenTypeDr.BTDesc
		}
		Set ItemTypeID="",ItemTypeDesc=""
		If $IsObject(objItem.EHItemTypeDr){
			Set ItemTypeID=objItem.EHItemTypeDr.%Id()
			Continue:(EvItemFL'="")&&(EvItemFL'=ItemTypeID)
			Set ItemTypeDesc=objItem.EHItemTypeDr.BTDesc
		}
		//支持分类和名称过滤
		Continue:(aAlis'="")&((ItemDesc'[aAlis)&(ItemTypeDesc'[aAlis))
		Set EnvironmentCateID="",EnvironmentCateDesc=""
		If $IsObject(objItem.EHEnvironmentCateDr){
			Set EnvironmentCateID=objItem.EHEnvironmentCateDr.%Id()
			Set EnvironmentCateDesc=objItem.EHEnvironmentCateDr.BTDesc
		}
		Set Norm 			= objItem.EHNorm
		Set NormMax 		= objItem.EHNormMax
		Set NormMin 		= objItem.EHNormMin
		Set SpecimenNum 	= objItem.EHSpecimenNum
		Set CenterNum 		= objItem.EHCenterNum	
		Set SurroundNum 	= objItem.EHSurroundNum
		Set ForMula 		= objItem.EHForMula	
		Set Freq 			= objItem.EHFreq		
		Set Uom 			= objItem.EHUom		
		Set IsActive 		= objItem.EHIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		//新增字段
		Set IsObjNull 		= objItem.EHIsObjNull
		Set IsObjNullDesc   = $s(IsObjNull=1:"是",1:"否")
		Set IsSpecNum 		= objItem.EHIsSpecNum
		Set IsSpecNumDesc   = $s(IsSpecNum=1:"是",1:"否")
		Set EHEnterTypeID="",EHEnterTypeDesc=""
		If $IsObject(objItem.EHEnterTypeDr){
			Set EHEnterTypeID=objItem.EHEnterTypeDr.%Id()
			Set EHEnterTypeDesc=objItem.EHEnterTypeDr.BTDesc
		}
				
		Set ReferToNum=objItem.EHReferToNum
		Set HospID="",HospDesc=""
		if ($IsObject(objItem.EHHospDr)){
			Set HospID=objItem.EHHospDr.%Id()
			Set HospDesc=objItem.EHHospDr.BTDesc
		}
		Set LabItemDr="",LabItem=""
		if ($IsObject(objItem.EHExtItemDr)){
			Set LabItemDr = objItem.EHExtItemDr.%Id()
			Set LabItem   = objItem.EHExtItemDr.BTTSDesc
		}
		Set Data=$lb(xID,ItemDesc,SpecimenTypeID,SpecimenTypeDesc,Norm,NormMax,NormMin,SpecimenNum,CenterNum,SurroundNum,ForMula,Freq,Uom,IsActive,IsActDesc,ItemTypeID,ItemTypeDesc,EnvironmentCateID,EnvironmentCateDesc,IsObjNull,IsObjNullDesc,IsSpecNum,IsSpecNumDesc,EHEnterTypeID,EHEnterTypeDesc,ReferToNum,HospID,HospDesc,LabItemDr,LabItem)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryEvItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvItemExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2019-08-29
/// Description:  查询消毒剂列表
/// Table：       DHCHAI.IR.EnviHyItem
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyItemSrv","QryDisFactor")
Query QryDisFactor() As %Query(ROWSPEC = "ID:%String,DisDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDisFactorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=0 
	for
	{
		Set xID=$o(^DHCHAI.IR.EnviHyItemD(xID))
	 	Quit:xID=""	
	 	
	 	Set obj=##class(DHCHAI.IR.EnviHyItem).GetObjById(xID)
	 	Quit:'$IsObject(obj)
	 	Continue:(obj.EHItemTypeDr.BTDesc'="消毒剂监测")
	 	Set Data=$lb(xID,obj.EHItemDesc)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryDisFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDisFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvItemExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2019-09-17
/// Description:  根据监测项目查询关联的监测对象(多对多的关系，增加中间表)
/// Table：       DHCHAI.IR.EnviHyItem,DHCHAI.IR.EnviHyItemObj,DHCHAI.IR.EnviHyObject    
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyItemSrv","QryEvObjsByItem",48,"0")
Query QryEvObjsByItem(aParRef As %String, aShowAll As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ObjID:%String,ObjDesc:%String,IsActive:%String,IsActDesc:%String,LinkID:%String,EHObjDesc2:%String")
{
}

ClassMethod QryEvObjsByItemExecute(ByRef qHandle As %Binary, aParRef As %String, aShowAll As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:aParRef="" $$$OK
	Set objEvItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(aParRef)
	Quit:'$IsObject(objEvItem) $$$OK
	//默认显示项目关联对象
	Set SpecimenTypeDr = objEvItem.EHSpecimenTypeDr
	//项目所属院区ID
	Set ItemHospID=""
	Set:$IsObject(objEvItem.EHHospDr) ItemHospID = objEvItem.EHHospDr.%Id()
	Quit:'$IsObject(SpecimenTypeDr) $$$OK
	Set xID = ""
	For {
			Set xID = $o(^DHCHAI.IR.EnviHyObjectI("IndexOnSpecimenType",SpecimenTypeDr.%Id(),xID))
			Quit:xID=""
			
			Set EHObject = ##class(DHCHAI.IR.EnviHyObject).GetObjById(xID)
			Continue:'$IsObject(EHObject)
			Set IsActive  = EHObject.EHIsActive
			//无效的监测对象关联时不显示
			continue:(IsActive=0)
			Set ObjDesc  	= EHObject.EHObjDesc
			Set EHObjDesc2=EHObject.EHObjDesc2
			Set:EHObjDesc2="" EHObjDesc2=ObjDesc
			Set ObjID  	 	= EHObject.%Id()
			Set ObjHospID	= "",LocID=""
			Set:$IsObject(EHObject.EHHospDr) ObjHospID	= EHObject.EHHospDr.%Id()
			Set:$IsObject(EHObject.EHLocationDr) LocID	= EHObject.EHLocationDr.%Id()
			//如果项目关联医院ID和对象关联医院不一致，不允许关联
			//continue:(ItemHospID'=ObjHospID)
			//院区新增判断,之前判断为全部院区时不起作用
			continue:(+ItemHospID=1)&&(+ObjHospID=2)
			continue:(+ItemHospID=2)&&(+ObjHospID=1)
			Continue:(aLocID'="")&&(LocID'="")&&(aLocID'=LocID)
			//如果显示全部，先自动默认关联上
			if (+aShowAll=1)&('$d(^DHCHAI.IR.EnviHyItemI("Obj","IdxObjectDr",aParRef,xID)))
			{
				Set aInputStr=aParRef_"^^"_xID_"^1"
				Set rstInp = ##class(DHCHAI.IR.EnviHyItemObj).Update(aInputStr)				
			}
			//如果不是显示全部，则显示关联对象；反之显示该项目类型下的所有对象
			//continue:(+aShowAll=0)&&('$d(^DHCHAI.IR.EnviHyItemI("Obj","IdxObjectDr",aParRef,xID)))
			Set LinkID=""
			if ($d(^DHCHAI.IR.EnviHyItemI("Obj","IdxObjectDr",aParRef,xID))) {
					Set SubID=$o(^DHCHAI.IR.EnviHyItemI("Obj","IdxObjectDr",aParRef,xID,""),-1)
					Set LinkID=aParRef_"||"_SubID
			}					
			Set IsActDesc = $s(IsActive=1:"是",1:"否")
			Set Data=$lb(ObjID,ObjDesc,IsActive,IsActDesc,LinkID,EHObjDesc2)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	Quit $$$OK
}

ClassMethod QryEvObjsByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvObjsByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEvObjsByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvObjsByItemExecute ]
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
