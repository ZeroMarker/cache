/// ClassName:    DHCMed.SPE.PatType
/// Description:  特殊患者类型
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPE.PatType Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSub As DHCMed.SPE.PatTypeSub [ Cardinality = children, Inverse = ParRef ];

/// 代码
Property PTCode As %String(TRUNCATE = 1);

/// 名称
Property PTDesc As %String(TRUNCATE = 1);

/// 是否活动
Property PTIsActive As %Boolean;

/// 备注
Property PTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexCode On PTCode [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  根据ID取特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       ID:    DHCMed.SPE.PatType.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.SPE.PatType).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SPE.PatType
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SPE.PatType).%ExistsId(+id) return
	set obj=##Class(DHCMed.SPE.PatType).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  更新特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SPE.PatType).Update("^A^需关注病人^1^测试","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	set ID       = $p(InStr,separete,1)
	set PTCode   = $p(InStr,separete,2)
	set PTDesc   = $p(InStr,separete,3)
	set PTIsActive = +$p(InStr,separete,4)
	set PTResume = $p(InStr,separete,5)
	
	quit:(PTCode="")||(PTDesc="") return
	
	if ID="" {
		Set ID=$o(^DHCMed.SPEDi("PatTp",0,"IndexCode"," "_$zcvt(PTCode,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.SPE.PatType).%New()
	}else{
		set obj=##class(DHCMed.SPE.PatType).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.PTCode     = PTCode
	set obj.PTDesc     = PTDesc
	set obj.PTIsActive = PTIsActive
	set obj.PTResume   = PTResume
	
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
/// Description:  删除特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.SPE.PatType")
	Quit:Flg'=1 -777
	set sc = ##class(DHCMed.SPE.PatType).%DeleteId(+Id)
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
/// Table：       DHCMed.SPE.PatType
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMed.SPE.PatType).CheckPTCode("")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMed.SPEDi("PatTp",0,"IndexCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMed.SPEDi("PatTp",0,"IndexCode"," "_$zcvt(aCode,"U"),0))
		Set return=1
		Set:(aID'="")&&(aID=ID) return=0
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
<Value>PTCode</Value>
</Value>
<Value name="3">
<Value>PTDesc</Value>
</Value>
<Value name="4">
<Value>PTIsActive</Value>
</Value>
<Value name="5">
<Value>PTResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SPED("PatTp")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SPED("PatTp")</IdLocation>
<IndexLocation>^DHCMed.SPEDi("PatTp",0)</IndexLocation>
<StreamLocation>^DHCMed.SPE.PatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
