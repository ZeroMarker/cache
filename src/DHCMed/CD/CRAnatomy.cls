/// 名称 : DHCMed.CD.CRAnatomy
/// 描述 : 解剖学编码字典 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2020-02-25
Class DHCMed.CD.CRAnatomy Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property CRCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property CRDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property CRIsActive As %Boolean;

/// 备注
Property CRResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On CRCode [ Unique ];

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 解剖学编码字典信息
/// Table       : DHCMed.CD.CRAnatomy
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.CD.CRAnatomy).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.CD.CRAnatomy
{
	New (aID)
	Quit:'##class(DHCMed.CD.CRAnatomy).%ExistsId(aID) ""
	Set obj=##class(DHCMed.CD.CRAnatomy).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2020-02-25
/// Description : 更新病理类型字典信息
/// Table       : DHCMed.CD.CRAnatomy
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRAnatomy).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set Code=$p(aInputStr,aSeparete,2)
	Set Desc=$p(aInputStr,aSeparete,3)
	Set IsActive=+$p(aInputStr,aSeparete,4)
	Set Resume=$p(aInputStr,aSeparete,5)
	
	Quit:($l(Code)<1)||(Desc="") return
    Set flgCode=..CheckCode(Code)
	Quit:(ID="")&&(flgCode>0) return
	Set tID=$o(^DHCMed.CD.CRAnatomyI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If (ID="") {
		Set obj=##class(DHCMed.CD.CRAnatomy).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRAnatomy).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CRCode=Code
	Set obj.CRDesc=Desc
	Set obj.CRIsActive=IsActive
	Set obj.CRResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2020-02-25
/// Description : 删除病理类型字典信息
/// Table       : DHCMed.CD.CRAnatomy
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRAnatomy).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.CD.CRAnatomy).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2020-02-25
/// Description : 解剖学编码字典
/// Table       : DHCMed.CD.CRAnatomy
/// Input       : Object
/// w ##class(DHCMed.CD.CRAnatomy).GetDescByObj("")
ClassMethod GetDescByObj(obj As DHCMed.CD.CRAnatomy) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.CRDesc
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2020-02-25
/// Description : 检查病理类型代码是否重复
/// Table       : DHCMed.CD.CRAnatomy
/// Input       : Code
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRAnatomy).CheckCode("")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=+$o(^DHCMed.CD.CRAnatomyI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Quit return
}

Storage Default
{
<Data name="CRAnatomyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRCode</Value>
</Value>
<Value name="3">
<Value>CRDesc</Value>
</Value>
<Value name="4">
<Value>CRIsActive</Value>
</Value>
<Value name="5">
<Value>CRResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CD.CRAnatomyD</DataLocation>
<DefaultData>CRAnatomyDefaultData</DefaultData>
<IdLocation>^DHCMed.CD.CRAnatomyD</IdLocation>
<IndexLocation>^DHCMed.CD.CRAnatomyI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRAnatomyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
