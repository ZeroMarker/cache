/// 名称: CT.IPMR.FP.AREA.Province
/// 描述: 省区划代码
/// 创建者：liyi
/// 创建日期: 2022-01-22
Class CT.IPMR.FP.AREA.Province Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 区划代码
Property APCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 描述
Property APDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 生效日期
Property APDateFrom As %Date [ Required ];

/// 失效日期
Property APDateTo As %Date;

Index IndexOnCode On APCode As Exact;

/// Creator：     liyi
/// CreatDate：   2022-01-22
/// Description:  取对象
/// Table：       CT.IPMR.FP.AREA.Province
/// Input：       Id : CT.IPMR.FP.AREA.Province.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.AREA.Province).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.AREA.Province
{
	new (aId)
	quit:'##class(CT.IPMR.FP.AREA.Province).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.AREA.Province).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2022-01-22
/// Description:  更新
/// Table：       CT.IPMR.FP.AREA.Province
/// Input：       InputStr ：数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.AREA.Province).Update("^1||1^1^1^1^1^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set Code		= $p(aInputStr,aSeparate,2)
	Set Desc 		= $p(aInputStr,aSeparate,3)
	Set DateFrom 	= $p(aInputStr,aSeparate,4)
	Set DateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(DateFrom)
	Set DateTo		= $p(aInputStr,aSeparate,5)
	Set DateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(DateTo)
	Quit:(Code="")&&(Desc="")&&(DateFrom="") return
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.AREA.Province).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.AREA.Province).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.APCode		= Code
	Set obj.APDesc		= Desc
	Set obj.APDateFrom	= DateFrom
	Set obj.APDateTo	= DateTo
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
/// CreatDate：   2022-01-22
/// Description:  删除
/// Table：       CT.IPMR.FP.AREA.Province
/// Input：       Id : CT.IPMR.FP.AREA.Province.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.AREA.Province).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.AREA.Province).%DeleteId(aId)
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
<Value>APCode</Value>
</Value>
<Value name="3">
<Value>APDesc</Value>
</Value>
<Value name="4">
<Value>APDateFrom</Value>
</Value>
<Value name="5">
<Value>APDateTo</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.AREA.ProvinceD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.AREA.ProvinceD</IdLocation>
<IndexLocation>^CT.IPMR.FP.AREA.ProvinceI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.AREA.ProvinceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
