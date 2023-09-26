/// ClassName:    DHCMed.SPE.PatType
/// Description:  特殊患者子分类
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPE.PatTypeSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.SPE.PatType [ Cardinality = parent, Inverse = ChildSub ];

/// 代码
Property PTSCode As %String(TRUNCATE = 1);

/// 名称
Property PTSDesc As %String(TRUNCATE = 1);

/// 图标定义
Property PTSIcon As %String(MAXLEN = 100, TRUNCATE = 1);

/// 自动标记（即：监控任务自动标记特殊患者）
Property PTSAutoMark As %Boolean;

/// 自动审核（即：标记过之后即为审核状态）
Property PTSAutoCheck As %Boolean;

/// 自动关闭（即：医疗结算后自动关闭特殊患者）
Property PTSAutoClose As %Boolean;

/// 是否有效
Property PTSIsActive As %Boolean;

/// 备注
Property PTSResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On PTSCode [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  根据ID取特殊患者子分类
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       ID:    DHCMed.SPE.PatTypeSub.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.SPE.PatTypeSub).GetObjById(1||1)
ClassMethod GetObjById(id As %String) As DHCMed.SPE.PatTypeSub
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SPE.PatTypeSub).%ExistsId(id) return
	set obj=##Class(DHCMed.SPE.PatTypeSub).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  更新特殊患者子分类
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SPE.PatTypeSub).Update("1^^001^test^lol^1^测试","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ParRef       = $p(InStr,separete,1)
	set ChildSub     = $p(InStr,separete,2)
	set PTSCode      = $p(InStr,separete,3)
	set PTSDesc      = $p(InStr,separete,4)
	set PTSIcon      = $p(InStr,separete,5)
	set PTSAutoMark  = +$p(InStr,separete,6)
	set PTSAutoCheck = +$p(InStr,separete,7)
	set PTSAutoClose = +$p(InStr,separete,8)
	set PTSIsActive  = +$p(InStr,separete,9)
	set PTSResume    = $p(InStr,separete,10)
	
	quit:(ParRef="")||(PTSCode="")||(PTSDesc="")||(PTSIcon="") return
	
	if ChildSub="" {
		Set Parref=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(PTSCode,"U"),0))
		If Parref'="" {
			Set ChildSub=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(PTSCode,"U"),Parref,0))
		}
	}
	
	if ChildSub="" {
		set obj=##class(DHCMed.SPE.PatTypeSub).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCMed.SPE.PatTypeSub).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ParRef       = ##class(DHCMed.SPE.PatType).GetObjById(ParRef)
	set obj.PTSCode      = PTSCode
	set obj.PTSDesc      = PTSDesc
	set obj.PTSIcon      = PTSIcon
	set obj.PTSAutoMark  = PTSAutoMark
	set obj.PTSAutoCheck = PTSAutoCheck
	set obj.PTSAutoClose = PTSAutoClose
	set obj.PTSIsActive  = PTSIsActive
	set obj.PTSResume    = PTSResume
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  删除特殊患者子分类
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.SPE.PatTypeSub")
	Quit:Flg'=1 -777
	set sc = ##class(DHCMed.SPE.PatTypeSub).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     mxp
/// CreatDate：   20160525
/// Description:  更新时判断Code是否重复
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       aCode：    代码
/// Return：      重复：1，不重复：0
/// w ##class(DHCMed.SPE.PatTypeSub).CheckPTSCode("")
ClassMethod CheckPTSCode(aCode As %String, aSubID As %String) As %String
{
	New (aCode,aSubID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(aCode,"U"))))
	{
		Set return=1
		Set Parref=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(aCode,"U"),0))
		Set ChildSub=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(aCode,"U"),Parref,0))
		Set SubID=Parref_"||"_ChildSub
		Set:(aSubID'="")&&(aSubID=SubID) return=0
	}else{
		set return=0
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
<Value>PTSCode</Value>
</Value>
<Value name="3">
<Value>PTSDesc</Value>
</Value>
<Value name="4">
<Value>PTSIcon</Value>
</Value>
<Value name="5">
<Value>PTSAutoMark</Value>
</Value>
<Value name="6">
<Value>PTSAutoCheck</Value>
</Value>
<Value name="7">
<Value>PTSAutoClose</Value>
</Value>
<Value name="8">
<Value>PTSIsActive</Value>
</Value>
<Value name="9">
<Value>PTSResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Sub")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Sub")</IdLocation>
<IndexLocation>^DHCMed.SPEDi("PatTp",0,"Sub")</IndexLocation>
<StreamLocation>^DHCMed.SPE.PatTypeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
