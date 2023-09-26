/// 病案类型维护
Class DHCWMR.SS.MrType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildNT As DHCWMR.SS.NoType [ Cardinality = children, Inverse = Parref ];

/// 病案分类（门诊O、急诊E、住院I）
Property MTMrClass As DHCWMR.SS.MrClass;

/// 病案类型名称
Property MTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院列表（指向CT_Hospital,多值#分隔）
Property MTHospIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接诊类型（按病人/按就诊）
Property MTReceiptType As DHCWMR.SS.Dictionary;

/// 是否启用病案系统分号（计费系统自动分号、手工输入病案号、病案系统自动分号）
Property MTGetWay As DHCWMR.SS.Dictionary;

/// 工作流
Property MTWorkFlow As DHCWMR.SS.WorkFlow;

/// 病案号是否回收（收回的号还可以分给别人）
Property MTRecycleType As %Boolean;

/// 是否回写病案号到病人基本信息表
Property MTIsBWMrNo As %Boolean;

/// 病案号存储字段（对应病人基本信息表或就诊表号码存储字段）
Property MTNoFiled As DHCWMR.SS.Dictionary;

/// 就诊类型（I住院、O门诊、E急诊）多值#分隔
Property MTAdmType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 详细说明
Property MTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  取病案类型
/// Table：       DHCWMR.SS.MrType
/// Input：       Id : DHCWMR.SS.MrType.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.MrType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.MrType
{
	new (aId)
	quit:'##class(DHCWMR.SS.MrType).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.MrType).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据病案分类、医院取病案类型
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.MrClass
/// Input：       MrClass : 病案分类
///               HospitalID : 医院
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.MrType).GetMrType("I",2)
ClassMethod GetMrType(aMrClass As %String, aHospitalID As %String) As DHCWMR.SS.MrType
{
	New (aMrClass,aHospitalID)
	Set return=""
	Quit:aMrClass="" return
	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.MrType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:'$IsObject(obj.MTMrClass)
	 	Set MrClassCode = obj.MTMrClass.MCCode
	 	Continue:(aMrClass'="")&&(MrClassCode'=aMrClass)
	 	Set HospIDs=obj.MTHospIDs
	 	Continue:HospIDs=""
	 	
	 	If aHospitalID'="" {
		 	Continue:("#"_HospIDs_"#")'[("#"_aHospitalID_"#")
	 	}
	 	
	 	Set return=obj
	 	Quit
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  更新病案类型
/// Table：       DHCWMR.SS.MrType
/// Input：       InputStr ：ID^病案分类^病案类型名称^医院列表^接诊类型^是否启用病案系统分号^病案号是否回收^病案号存储字段^详细说明
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.MrType).Update("3^1^sss^2#3^^^1^xxx^xxx^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set MrClass=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set HospIDs=$p(aInputStr,aSeparate,4)
	Set ReceiptTypeID=$p(aInputStr,aSeparate,5)
	Set GetWayID=$p(aInputStr,aSeparate,6)
	Set RecycleType=$p(aInputStr,aSeparate,7)
	Set NoFiledID=$p(aInputStr,aSeparate,8)
	Set WorkFlowID=$p(aInputStr,aSeparate,9)
	Set IsBWMrNo=$p(aInputStr,aSeparate,10)
	Set AdmType=$p(aInputStr,aSeparate,11)
	Set Resume=$p(aInputStr,aSeparate,12)
	Quit:(MrClass="")||(Desc="") return
	
	Set objMrClass=##class(DHCWMR.SS.MrClass).GetObjById(MrClass)
	Quit:'$IsObject(objMrClass) return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.MrType).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.MrType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MTMrClass     = objMrClass
	Set obj.MTDesc        = Desc
	Set obj.MTHospIDs     = HospIDs
	Set obj.MTReceiptType = ##class(DHCWMR.SS.Dictionary).GetObjById(ReceiptTypeID)
	Set obj.MTGetWay      = ##class(DHCWMR.SS.Dictionary).GetObjById(GetWayID)
	Set obj.MTRecycleType = +RecycleType
	Set obj.MTNoFiled     = ##class(DHCWMR.SS.Dictionary).GetObjById(NoFiledID)
	Set obj.MTWorkFlow    = ##class(DHCWMR.SS.WorkFlow).GetObjById(WorkFlowID)
	Set obj.MTIsBWMrNo    = +IsBWMrNo
	Set obj.MTAdmType     = AdmType
	Set obj.MTResume      = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  删除病案类型
/// Table：       DHCWMR.SS.MrType
/// Input：       Id : DHCWMR.SS.MrType.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.MrType).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-26
/// Description:  根据病案类型ID查询配置医院列表
/// Table：       DHCWMR.SS.MrType、CT_Hosptial
/// Input：       MrTypeID ：DHCWMR.SS.MrType.ID
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SS.MrType","QryMTHospList",1)
Query QryMTHospList(aMrTypeID As %String) As %Query(ROWSPEC = "HospID:%String,HospDesc:%String,IsChecked:%String")
{
}

ClassMethod QryMTHospListExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMrTypeID="" $$$OK
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) $$$OK
	Set HospIDs=objMrType.MTHospIDs
	Set HospIDs="#"_HospIDs_"#"
	
	Set xID=0
	For {
		Set xID=$o(^CT("HOSP",xID))
		Quit:xID=""
		
		Set HospID=xID
		Set HospDesc=$p($g(^CT("HOSP",xID)),"^",2)
		Set tmpHospID="#"_HospID_"#"
		Set IsChecked=$s(HospIDs[tmpHospID:1,1:0)
		
		Set Data=$lb(HospID,HospDesc,IsChecked)
    	Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMTHospListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMTHospListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMTHospListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMTHospListExecute ]
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
/// CreatDate：   2014-08-26
/// Description:  查询病案类型
/// Table：       DHCWMR.SS.MrType
/// Input：    	  无
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SS.MrType","QueryMrType","")
Query QueryMrType(aMrClass As %String = "") As %Query(ROWSPEC = "ID:%String,MrClassID:%String,MrClassDesc:%String,MrTypeDesc:%String,HospIDs:%String,HospDescs:%String,ReceiptTypeID:%String,ReceiptTypeDesc:%String,GetWayID:%String,GetWayDesc:%String,RecycleType:%String,RecycleTypeDesc:%String,NoFiledID:%String,NoFiledDesc:%String,WorkFlowID:%String,WorkFlowDesc:%String,IsBWMrNo:%String,IsBWMrNoDesc:%String,AdmType:%String,AdmTypeDesc:%String,MTResume:%String")
{
}

ClassMethod QueryMrTypeExecute(ByRef qHandle As %Binary, aMrClass As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.MrType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=xID
	 	Set MrTypeDesc=obj.MTDesc
	 	Set MrClassID="",MrClassDesc=""
	 	If $IsObject(obj.MTMrClass){
		 	Set MrClassID=obj.MTMrClass.%Id()
		 	Set MrClassCode = obj.MTMrClass.MCCode
		 	Set MrClassDesc=obj.MTMrClass.MCDesc
	 	}
	 	Continue:(aMrClass'="")&&(MrClassCode'=aMrClass)
	 	Set HospIDs=obj.MTHospIDs
	 	Set HospDescs=""
		For indHosp=1:1:$l(HospIDs,"#") {
			Set HospID=$p(HospIDs,"#",indHosp)
			Continue:HospID=""
			Set HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
			Continue:HospDesc=""
			Set HospDescs=HospDescs_","_HospDesc
		}
		Set:HospDescs'="" HospDescs=$e(HospDescs,2,$l(HospDescs))
		Set ReceiptTypeID="",ReceiptTypeDesc=""
		If $IsObject(obj.MTReceiptType) {
			Set ReceiptTypeID=obj.MTReceiptType.%Id()
			Set ReceiptTypeDesc=obj.MTReceiptType.SDDesc
		}
		Set GetWayID="",GetWayDesc=""
		If $IsObject(obj.MTGetWay) {
			Set GetWayID=obj.MTGetWay.%Id()
			Set GetWayDesc=obj.MTGetWay.SDDesc
		}
		Set RecycleType=obj.MTRecycleType
		Set RecycleTypeDesc=$s(RecycleType=1:"是",1:"否")
		Set NoFiledID="",NoFiledDesc=""
		If $IsObject(obj.MTNoFiled) {
			Set NoFiledID=obj.MTNoFiled.%Id()
			Set NoFiledDesc=obj.MTNoFiled.SDDesc
		}
		Set MTResume=obj.MTResume
		Set WorkFlowID ="", WorkFlowDesc=""
		If $IsObject(obj.MTWorkFlow){
			Set WorkFlowID=obj.MTWorkFlow.%Id()
			Set WorkFlowDesc=obj.MTWorkFlow.WFDesc
		}
		Set IsBWMrNo=obj.MTIsBWMrNo
		Set IsBWMrNoDesc=$s(IsBWMrNo=1:"是",1:"否")
		Set AdmType=obj.MTAdmType
		Set cAdmType="#"_AdmType_"#"
		Set AdmTypeDesc=""
		Set:cAdmType["#O#" AdmTypeDesc=AdmTypeDesc_","_"门诊"
		Set:cAdmType["#E#" AdmTypeDesc=AdmTypeDesc_","_"急诊"
		Set:cAdmType["#I#" AdmTypeDesc=AdmTypeDesc_","_"住院"
		Set:AdmTypeDesc'="" AdmTypeDesc=$e(AdmTypeDesc,2,$l(AdmTypeDesc))
		
		Set Data=$lb(ID,MrClassID,MrClassDesc,MrTypeDesc,HospIDs,HospDescs,ReceiptTypeID,ReceiptTypeDesc,GetWayID,GetWayDesc,RecycleType,RecycleTypeDesc,NoFiledID,NoFiledDesc,WorkFlowID,WorkFlowDesc,IsBWMrNo,IsBWMrNoDesc,AdmType,AdmTypeDesc,MTResume)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
 	Quit $$$OK
}

ClassMethod QueryMrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrTypeExecute ]
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
<Value>MTMrClass</Value>
</Value>
<Value name="3">
<Value>MTDesc</Value>
</Value>
<Value name="4">
<Value>MTHospIDs</Value>
</Value>
<Value name="5">
<Value>MTReceiptType</Value>
</Value>
<Value name="6">
<Value>MTGetWay</Value>
</Value>
<Value name="7">
<Value>MTRecycleType</Value>
</Value>
<Value name="8">
<Value>MTNoFiled</Value>
</Value>
<Value name="9">
<Value>MTWorkFlow</Value>
</Value>
<Value name="10">
<Value>MTIsBWMrNo</Value>
</Value>
<Value name="11">
<Value>MTAdmType</Value>
</Value>
<Value name="12">
<Value>MTResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.MrTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.MrTypeD</IdLocation>
<IndexLocation>^DHCWMR.SS.MrTypeI</IndexLocation>
<StreamLocation>^DHCWMR.SS.MrTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
