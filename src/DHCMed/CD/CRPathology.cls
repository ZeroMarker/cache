/// 名称 : DHCMed.CD.CRPathology
/// 描述 : 病理类型字典 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CD.CRPathology Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property CRCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property CRDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property CRIsActive As %Boolean;

/// 备注
Property CRResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On CRCode [ Unique ];

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取病理类型字典信息
/// Table       : DHCMed.CD.CRPathology
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.CD.CRPathology).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.CD.CRPathology
{
	New (aID)
	Quit:'##class(DHCMed.CD.CRPathology).%ExistsId(aID) ""
	Set obj=##class(DHCMed.CD.CRPathology).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 更新病理类型字典信息
/// Table       : DHCMed.CD.CRPathology
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRPathology).Update("","")
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
	Set tID=$o(^DHCMed.CD.CRPathologyI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If (ID="") {
		Set obj=##class(DHCMed.CD.CRPathology).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRPathology).%OpenId(ID)
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
/// CreatDate   : 2019-02-20
/// Description : 删除病理类型字典信息
/// Table       : DHCMed.CD.CRPathology
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRPathology).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.CD.CRPathology).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取病理类型字典
/// Table       : DHCMed.CD.CRPathology
/// Input       : Object
/// w ##class(DHCMed.CD.CRPathology).GetDescByObj("")
ClassMethod GetDescByObj(obj As DHCMed.CD.CRPathology) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.CRDesc
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 检查病理类型代码是否重复
/// Table       : DHCMed.CD.CRPathology
/// Input       : Code
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.DiagnosPos).CheckCode("")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=+$o(^DHCMed.CD.CRPathologyI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Quit return
}

Storage Default
{
<Data name="CRPathologyDefaultData">
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
<DataLocation>^DHCMed.CD.CRPathologyD</DataLocation>
<DefaultData>CRPathologyDefaultData</DefaultData>
<IdLocation>^DHCMed.CD.CRPathologyD</IdLocation>
<IndexLocation>^DHCMed.CD.CRPathologyI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRPathologyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
