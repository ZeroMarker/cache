/// 名称: CT.IPMR.BT.MrType
/// 描述: 病案类型
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.MrType Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildNT As CT.IPMR.BT.NoType [ Cardinality = children, Inverse = Parref ];

/// 病案分类（门诊O、急诊E、住院I）
Property BMMrClass As CT.IPMR.BT.MrClass;

/// 病案类型名称
Property BMDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院列表（指向CT_Hospital 或 MA.IPMR.BT.Hospital,多值#分隔）
Property BMHospIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接诊类型（按病人/按就诊）
Property BMReceiptType As CT.IPMR.BT.Dictionary;

/// 号码发放方式（计费系统自动分号、手工输入病案号、病案系统自动分号）
Property BMAssignType As CT.IPMR.BT.Dictionary;

/// 工作流
Property BMWorkFlow As CT.IPMR.BT.WorkFlow;

/// 病案号是否回收（收回的号还可以分给别人）
Property BMRecycleType As %Boolean;

/// 是否回写病案号到病人基本信息表
Property BMIsBWMrNo As %Boolean;

/// 病案号存储字段（对应病人基本信息表或就诊表号码存储字段）
Property BMNoFiled As CT.IPMR.BT.Dictionary;

/// 就诊类型（I住院、O门诊、E急诊）多值#分隔
Property BMAdmType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 详细说明
Property BMResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     WHui
/// CreatDate：   2020-05-18
/// Description:  根据病案分类、医院取病案类型
/// Table：       CT.IPMR.BT.MrType、CT.IPMR.BT.MrClass
/// Input：       MrClass : 病案分类
///               HospitalID : 医院
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.MrType).GetMrType("I",2)
ClassMethod GetMrType(aMrClass As %String, aHospitalID As %String) As CT.IPMR.BT.MrType
{
	New (aMrClass,aHospitalID)
	Set return=""
	Quit:aMrClass="" return
	
 	Set xID=""
 	For {
	 	Set xID=$o(^CT.IPMR.BT.MrTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(CT.IPMR.BT.MrType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:'$IsObject(obj.BMMrClass)
	 	Set MrClassCode = obj.BMMrClass.BMCode
	 	Continue:(aMrClass'="")&&(MrClassCode'=aMrClass)
	 	Set HospIDs=obj.BMHospIDs
	 	Continue:HospIDs=""
	 	
	 	If aHospitalID'="" {
		 	Continue:("#"_HospIDs_"#")'[("#"_aHospitalID_"#")
	 	}
	 	
	 	Set return=obj
	 	Quit
	}
	
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2020-05-18
/// Description:  根据病案分类、医院取病案类型ID
/// Table：       CT.IPMR.BT.MrType、CT.IPMR.BT.MrClass
/// Input：       MrClass : 病案分类
///               HospitalID : 医院
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.MrType).GetMrTypeID("I",2)
ClassMethod GetMrTypeID(aMrClass As %String, aHospitalID As %String) As %String
{
	New (aMrClass,aHospitalID)
	Set return=""
	Quit:aMrClass="" return
	
	Set objMrType = ##class(CT.IPMR.BT.MrType).GetMrType(aMrClass,aHospitalID)
	Set MrTypeID = ""
	Set:$IsObject(objMrType) MrTypeID = objMrType.%Id() 
	Quit MrTypeID
}

/// Creator：     liyi
/// CreatDate：   2020-04-27
/// Description:  根据病案类型格式化病案号
/// Table：       
/// Input：       aMrTypeID : 病案类型ID
/// 			  aMrNo：病案号
/// 			  aHospID：医院ID
/// 			  aLocID：科室ID
/// Return：      返回病案号
/// w ##class(CT.IPMR.BT.MrType).FormatMrNo(7,"25",1,"")
ClassMethod FormatMrNo(aMrTypeID As %String, aMrNo As %String, aHospID As %String = "", aLocID As %String = "") As %String
{
	New (aMrTypeID,aMrNo,aHospID,aLocID)
	Set return=""
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set aMrNo=##Class(MA.IPMR.SSService.CommonSrv).ChangeChar(aMrNo)
	Quit:aMrNo="" return

	Set objMrType = ..GetObjById(aMrTypeID)
	Quit:'$isobject(objMrType) return
	
	Set AdmType = objMrType.BMMrClass.BMCode
	Set objNoType = ##class(CT.IPMR.BT.NoType).GetObjByNoLink(AdmType,aHospID,aLocID)
	Quit:'$isobject(objNoType) return
	
	Set NoTypeID = objNoType.%Id()
	Set MrNo = ##class(CT.IPMR.BT.NoType).FormatMrNo(NoTypeID,aMrNo)
	// 判断病案号是否存在MrNo表，如果存在则为系统分配的号码，否则为自定义号码
	if $d(^MA.IPMR.SS.MrNoI("IndexNoTypeMrNo",NoTypeID," "_$zcvt(MrNo,"U"))) {
		Set return = MrNo
	}else{
		Set return = aMrNo
	}
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-27
/// Description:  取病案类型
/// Table：       CT.IPMR.BT.MrType
/// Input：       Id : CT.IPMR.BT.MrType.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.MrType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.MrType
{
	New (aId)
	Quit:'##class(CT.IPMR.BT.MrType).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.BT.MrType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     WHui
/// CreatDate：   2019-10-27
/// Description:  更新病案类型
/// Table：       CT.IPMR.BT.MrType
/// Input：       InputStr ：ID^病案分类^病案类型名称^医院列表^接诊类型^是否启用病案系统分号^病案号是否回收^病案号存储字段^工作流^回写^就诊类型^详细说明
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(CT.IPMR.BT.MrType).Update("^2^门诊病案^2#3^6^10^1^13^2^1^E^测试配置^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	;Set ^TMPWHui = $lb(aInputStr,aSeparate)
	Set ID				= $p(aInputStr,aSeparate,1)
	Set MrClass			= $p(aInputStr,aSeparate,2)
	Set Desc			= $p(aInputStr,aSeparate,3)
	Set HospIDs			= $p(aInputStr,aSeparate,4)
	Set ReceiptTypeID	= $p(aInputStr,aSeparate,5)
	Set AssignTypeID	= $p(aInputStr,aSeparate,6)
	Set RecycleType		= $p(aInputStr,aSeparate,7)
	Set NoFiledID		= $p(aInputStr,aSeparate,8)
	Set WorkFlowID		= $p(aInputStr,aSeparate,9)
	Set IsBWMrNo		= $p(aInputStr,aSeparate,10)
	Set AdmType			= $p(aInputStr,aSeparate,11)
	Set Resume			= $p(aInputStr,aSeparate,12)
	Quit:(MrClass="")||(Desc="") return
	
	Set objMrClass=##class(CT.IPMR.BT.MrClass).GetObjById(MrClass)
	Quit:'$IsObject(objMrClass) return
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.MrType).%New()
	} Else {
		Set obj=##class(CT.IPMR.BT.MrType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BMMrClass		= objMrClass
	Set obj.BMDesc			= Desc
	Set obj.BMHospIDs		= HospIDs
	Set obj.BMReceiptType	= ##class(CT.IPMR.BT.Dictionary).GetObjById(ReceiptTypeID)
	Set obj.BMAssignType	= ##class(CT.IPMR.BT.Dictionary).GetObjById(AssignTypeID)
	Set obj.BMRecycleType	= +RecycleType
	Set obj.BMNoFiled		= ##class(CT.IPMR.BT.Dictionary).GetObjById(NoFiledID)
	Set obj.BMWorkFlow		= ##class(CT.IPMR.BT.WorkFlow).GetObjById(WorkFlowID)
	Set obj.BMIsBWMrNo		= +IsBWMrNo
	Set obj.BMAdmType		= AdmType
	Set obj.BMResume		= Resume
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

/// Creator：     WHui
/// CreatDate：   2019-10-27
/// Description:  删除病案类型
/// Table：       CT.IPMR.BT.MrType
/// Input：       Id : CT.IPMR.BT.MrType.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.MrType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(CT.IPMR.BT.MrType).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		D $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMMrClass</Value>
</Value>
<Value name="3">
<Value>BMDesc</Value>
</Value>
<Value name="4">
<Value>BMHospIDs</Value>
</Value>
<Value name="5">
<Value>BMReceiptType</Value>
</Value>
<Value name="6">
<Value>BMAssignType</Value>
</Value>
<Value name="7">
<Value>BMWorkFlow</Value>
</Value>
<Value name="8">
<Value>BMRecycleType</Value>
</Value>
<Value name="9">
<Value>BMIsBWMrNo</Value>
</Value>
<Value name="10">
<Value>BMNoFiled</Value>
</Value>
<Value name="11">
<Value>BMAdmType</Value>
</Value>
<Value name="12">
<Value>BMResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.MrTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.MrTypeD</IdLocation>
<IndexLocation>^CT.IPMR.BT.MrTypeI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.MrTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
