/// 名称: CT.IPMR.BT.Glossary
/// 描述: 术语集字典表
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.Glossary Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 首页类型 （"FrontPageType" 中医首页/西医首页）
Property BGFPTypeDr As CT.IPMR.BT.Dictionary;

/// 代码
Property BGCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BGDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 数据类型
Property BGDataTypeDr As CT.IPMR.BT.Dictionary [ Required ];

/// 是否有效
Property BGIsActive As %Boolean;

/// 备注
Property BGResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexFPTypeCode On (BGFPTypeDr, BGCode) [ Unique ];

Index IndexDesc On BGDesc;

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取术语集字典
/// Table：       CT.IPMR.BT.Glossary
/// Input：       Id : CT.IPMR.BT.Glossary.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Glossary).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.Glossary
{
	new (aId)
	quit:'##class(CT.IPMR.BT.Glossary).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.Glossary).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新术语集字典
/// Table：       CT.IPMR.BT.Glossary
/// Input：       InputStr ：术语集数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.Glossary).Update("^128^测试代码2^测试名称3^218^1^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set FPTypeID= $p(aInputStr,aSeparate,2)
	Set Code 	= $p(aInputStr,aSeparate,3)
	Set Desc 	= $p(aInputStr,aSeparate,4)
	Set DataTypeID= $p(aInputStr,aSeparate,5)
	Set IsActive= +$p(aInputStr,aSeparate,6)
	Set Resume 	= $p(aInputStr,aSeparate,7)
	Quit:(FPTypeID="")||(Code="")||(Desc="")||(DataTypeID="") return
	
	Set objFPType = ##class(CT.IPMR.BT.Dictionary).GetObjById(FPTypeID)
	Quit:'$IsObject(objFPType) return
	
	Set objDataType = ##class(CT.IPMR.BT.Dictionary).GetObjById(DataTypeID)
	Quit:'$IsObject(objDataType) return
	
	Set tID = $o(^CT.IPMR.BT.GlossaryI("IndexFPTypeCode",FPTypeID," "_$ZCVT(Code,"U"),0))
	Quit:(ID'="")&&(ID'=tID) return
	Set ID = tID
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.Glossary).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.Glossary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BGFPTypeDr	= objFPType
	Set obj.BGCode		= Code
	Set obj.BGDesc		= Desc
	Set obj.BGDataTypeDr= objDataType
	Set obj.BGIsActive 	= IsActive
	Set obj.BGResume	= Resume
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
/// Description:  删除术语集字典
/// Table：       CT.IPMR.BT.Glossary
/// Input：       Id : CT.IPMR.BT.Glossary.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.Glossary).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.Glossary).%DeleteId(aId)
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
<Value>BGFPTypeDr</Value>
</Value>
<Value name="3">
<Value>BGCode</Value>
</Value>
<Value name="4">
<Value>BGDesc</Value>
</Value>
<Value name="5">
<Value>BGDataTypeDr</Value>
</Value>
<Value name="6">
<Value>BGIsActive</Value>
</Value>
<Value name="7">
<Value>BGResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.GlossaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.GlossaryD</IdLocation>
<IndexLocation>^CT.IPMR.BT.GlossaryI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.GlossaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
