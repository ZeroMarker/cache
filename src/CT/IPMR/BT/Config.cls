/// 名称: CT.IPMR.BT.Config
/// 描述: 系统参数配置表
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.Config Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BCCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property BCDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 值
Property BCVal As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 值说明
Property BCValDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医院ID (指向CT_Hospital 或 CT_IPMR_BT.Hospital)
Property BCHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property BCResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCodeHosp On (BCCode, BCHospID) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  通过代码取配置值
/// Table：       CT.IPMR.BT.Config
/// Input：       Id : CT.IPMR.BT.Config.BCCode
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Config).GetValByCode("")
ClassMethod GetValByCode(aCode As %String, aHospID As %String = "") As %String
{
	new (aCode,aHospID)
	set return=""
	quit:aCode="" return
	
	set ID=$o(^CT.IPMR.BT.ConfigI("IndexCodeHosp"," "_$ZCVT(aCode,"U")," "_aHospID,0))
	set obj=##class(CT.IPMR.BT.Config).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.BCVal
	
	quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取参数配置
/// Table：       CT.IPMR.BT.Config
/// Input：       Id : CT.IPMR.BT.Config.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Config).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.Config
{
	new (aId)
	quit:'##class(CT.IPMR.BT.Config).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.Config).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新参数配置
/// Table：       CT.IPMR.BT.Config
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.Config).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Code 	= $p(aInputStr,aSeparate,2)
	Set Desc 	= $p(aInputStr,aSeparate,3)
	Set Val		= $p(aInputStr,aSeparate,4)
	Set ValDesc = $p(aInputStr,aSeparate,5)
	Set HospID 	= $p(aInputStr,aSeparate,6)
	Set Resume 	= $p(aInputStr,aSeparate,7)

	Set return=-100
	set tID=$o(^CT.IPMR.BT.ConfigI("IndexCodeHosp"," "_$zcvt(Code,"U")," "_HospID,0))
	Quit:(tID'="")&&(tID'=ID) return
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.Config).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.Config).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BCCode		= Code
	Set obj.BCDesc		= Desc
	Set obj.BCVal		= Val
	Set obj.BCHospID	= HospID
	Set obj.BCValDesc	= ValDesc
	Set obj.BCResume	= Resume
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  删除参数配置
/// Table：       CT.IPMR.BT.Config
/// Input：       Id : CT.IPMR.BT.Config.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.Config).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.Config).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BCCode</Value>
</Value>
<Value name="3">
<Value>BCDesc</Value>
</Value>
<Value name="4">
<Value>BCVal</Value>
</Value>
<Value name="5">
<Value>BCValDesc</Value>
</Value>
<Value name="6">
<Value>BCHospID</Value>
</Value>
<Value name="7">
<Value>BCResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.ConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.ConfigD</IdLocation>
<IndexLocation>^CT.IPMR.BT.ConfigI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
