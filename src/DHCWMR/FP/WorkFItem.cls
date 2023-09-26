/// 编目操作项目定义
Class DHCWMR.FP.WorkFItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildExtra As DHCWMR.FP.WorkFExtra [ Cardinality = children, Inverse = Parref ];

/// 编目操作项目
Property WIItemDr As DHCWMR.SS.WorkFItem;

/// 编目类型(首次F,二次S)
Property WIType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property WIResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 诊断编码库
Property WIICDVer As DHCWMR.FP.ICDVersion;

/// 手术编码库
Property WIOprVer As DHCWMR.FP.ICDVersion;

/// 中医诊断库
Property WIICDVer2 As DHCWMR.FP.ICDVersion;

/// 肿瘤码诊断库
Property WIICDVer3 As DHCWMR.FP.ICDVersion;

Index IndexWFItem On WIItemDr [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据ID取编目操作项目定义
/// Table：       DHCWMR.FP.WorkFItem
/// Input：       ID:    DHCWMR.FP.WorkFItem.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.WorkFItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.WorkFItem
{
	new (aId)
	set return=""
	quit:aId="" return
	set obj=##Class(DHCWMR.FP.WorkFItem).%OpenId(aId)
	set return=obj
	if obj'="" do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-29
/// Description:  根据病案分类及医院取编目操作项目
/// Table：       DHCWMR.FP.WorkFItem
/// Input：       MrTypeID : 病案分类ID
///               FPType : 医院ID（CT_Hospital.ID）
///               SWICode ：编目项目代码（DHCWMR.SS.WorkFItem.Code）  允许为空
/// Return：      返回Object
/// w ##class(DHCWMR.FP.WorkFItem).GetObjByMrType(7)
ClassMethod GetObjByMrType(aMrTypeID As %String, aFPType As %String = "F") As DHCWMR.FP.WorkFItem
{
	New (aMrTypeID,aFPType)
	Set return=""
	Quit:(aMrTypeID="")||(aFPType="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Set WorkFlowID=objMrType.MTWorkFlow.%Id()
	Quit:WorkFlowID="" return
	
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCWMR.FP.WorkFItemD(xItemID))
		Quit:xItemID=""
		Quit:return'=""
		
		Set objFPItem=##class(DHCWMR.FP.WorkFItem).GetObjById(xItemID)
		Continue:'$IsObject(objFPItem)
		Continue:objFPItem.WIType'=aFPType
		Set objWFItem=objFPItem.WIItemDr
		Continue:'$IsObject(objWFItem)
		Continue:objWFItem.Parref.%Id()'=WorkFlowID
		Continue:objWFItem.WFIIsActive'=1
		
		Set return=objFPItem
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  更新编目操作项目定义
/// Table：       DHCWMR.FP.WorkFItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.WorkFItem).Update("^2^F^2^3^4^^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	new (aInputStr,aSeparete)
	set return=0
	quit:aInputStr="" return
	
	set ID          = $p(aInputStr,aSeparete,1)
	set WFItemID    = $p(aInputStr,aSeparete,2)
	set FPType      = $p(aInputStr,aSeparete,3)
	set Resume      = $p(aInputStr,aSeparete,4)
	set ICDVer      = $p(aInputStr,aSeparete,5)
	set OprVer      = $p(aInputStr,aSeparete,6)
	set ICDVer2     = $p(aInputStr,aSeparete,7)
	set ICDVer3     = $p(aInputStr,aSeparete,8)
	quit:(WFItemID="")||(ICDVer="")||(OprVer="") return
	quit:(FPType'="F")&&(FPType'="S") return
	
	Set objWFItm = ##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
	Quit:'$IsObject(objWFItm)
	
	Set objICDVer = ##class(DHCWMR.FP.ICDVersion).GetObjById(ICDVer)
	Quit:'$IsObject(objICDVer)
	
	Set objOprVer = ##class(DHCWMR.FP.ICDVersion).GetObjById(OprVer)
	Quit:'$IsObject(objOprVer)

	//fix bug 6649
    Quit:(ID="")&&($d(^DHCWMR.FP.WorkFItemI("IndexWFItem",WFItemID))) -100

	if ID="" {
		set obj=##class(DHCWMR.FP.WorkFItem).%New()
	}else{
		set obj=##class(DHCWMR.FP.WorkFItem).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.WIItemDr   = objWFItm
	set obj.WIType     = FPType
	set obj.WIResume   = Resume
	set obj.WIICDVer   = objICDVer
	set obj.WIOprVer   = objOprVer
	set obj.WIICDVer2  = ##class(DHCWMR.FP.ICDVersion).GetObjById(ICDVer2)
	set obj.WIICDVer3  = ##class(DHCWMR.FP.ICDVersion).GetObjById(ICDVer3)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  删除编目操作项目定义
/// Table：       DHCWMR.FP.WorkFItem
/// Input：       aId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.WorkFItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=0
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-17
/// Description:  查询编目操作项目
/// Table：       DHCWMR.FP.WorkFItem
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FP.WorkFItem","QryWorkFItem")
Query QryWorkFItem() As %Query(ROWSPEC = "FPItemID:%String,WFlowID:%String,WFlowDesc:%String,WFItemID:%String,WFItemDesc:%String,TypeCode:%String,TypeDesc:%String,Resume:%String,ICDVerID:%String,ICDVerCode:%String,ICDVerDesc:%String,OPRVerID:%String,OPRVerCode:%String,OPRVerDesc:%String,ICDVer2ID:%String,ICDVer2Code:%String,ICDVer2Desc:%String,ICDVer3ID:%String,ICDVer3Code:%String,ICDVer3Desc:%String")
{
}

ClassMethod QryWorkFItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID = ""
 	For {
	 	Set xID = $o(^DHCWMR.FP.WorkFItemD(xID))
	 	Quit:xID=""
	 	
	 	Set objItem = ..GetObjById(xID)
	 	Continue:'$IsObject(objItem)
	 	Continue:'$IsObject(objItem.WIItemDr)
	 	Continue:'$IsObject(objItem.WIItemDr.Parref)
	 	
	 	Set SWFItem      = objItem.WIItemDr
	 	Set WFItemID     = SWFItem.%Id()
	 	Set WFItemDesc   = SWFItem.WFIItem.WIDesc
	 	Set ItemAlias    = SWFItem.WFIAlias
	 	Set:ItemAlias'="" WFItemDesc=ItemAlias
	 	
	 	Set objWorkFlow  = SWFItem.Parref
	 	Set WFlowID      = objWorkFlow.%Id()
	 	Set WFlowDesc    = objWorkFlow.WFDesc
	 	
	 	Set TypeCode = objItem.WIType
	 	Set TypeDesc =$s(TypeCode="F":"首次",TypeCode="S":"二次",1:"")
	 	Set Resume = objItem.WIResume
	 	
	 	Set ICDVerID="",ICDVerCode="",ICDVerDesc=""
	 	If $IsObject(objItem.WIICDVer){
			Set ICDVerID=objItem.WIICDVer.%Id()
			Set ICDVerCode=objItem.WIICDVer.IVCode
			Set ICDVerDesc=objItem.WIICDVer.IVDesc
		}
		
	 	Set OPRVerID="",OPRVerCode="",OPRVerDesc=""
	 	If $IsObject(objItem.WIOprVer){
			Set OPRVerID=objItem.WIOprVer.%Id()
			Set OPRVerCode=objItem.WIOprVer.IVCode
			Set OPRVerDesc=objItem.WIOprVer.IVDesc
		}
		
	 	Set ICDVer2ID="",ICDVer2Code="",ICDVer2Desc=""
	 	If $IsObject(objItem.WIICDVer2){
			Set ICDVer2ID=objItem.WIICDVer2.%Id()
			Set ICDVer2Code=objItem.WIICDVer2.IVCode
			Set ICDVer2Desc=objItem.WIICDVer2.IVDesc
		}
		
	 	Set ICDVer3ID="",ICDVer3Code="",ICDVer3Desc=""
	 	If $IsObject(objItem.WIICDVer3){
			Set ICDVer3ID=objItem.WIICDVer3.%Id()
			Set ICDVer3Code=objItem.WIICDVer3.IVCode
			Set ICDVer3Desc=objItem.WIICDVer3.IVDesc
		}
		
	 	Set Data = $LB(xID,WFlowID,WFlowDesc,WFItemID,WFItemDesc,TypeCode,TypeDesc,Resume,ICDVerID,ICDVerCode,ICDVerDesc,OPRVerID,OPRVerCode,OPRVerDesc,ICDVer2ID,ICDVer2Code,ICDVer2Desc,ICDVer3ID,ICDVer3Code,ICDVer3Desc)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod QryWorkFItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkFItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWorkFItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkFItemExecute ]
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WIItemDr</Value>
</Value>
<Value name="3">
<Value>WIType</Value>
</Value>
<Value name="4">
<Value>WIResume</Value>
</Value>
<Value name="5">
<Value>WIICDVer</Value>
</Value>
<Value name="6">
<Value>WIOprVer</Value>
</Value>
<Value name="7">
<Value>WIICDVer2</Value>
</Value>
<Value name="8">
<Value>WIICDVer3</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.WorkFItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.WorkFItemD</IdLocation>
<IndexLocation>^DHCWMR.FP.WorkFItemI</IndexLocation>
<StreamLocation>^DHCWMR.FP.WorkFItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
