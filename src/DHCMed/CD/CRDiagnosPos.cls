/// 名称 : DHCMed.CD.CRDiagnosPos
/// 描述 : 诊断部位(亚部位)字典 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CD.CRDiagnosPos Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property CRCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property CRDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 部位标志
Property CRPosFlag As %Boolean;

/// 是否有效
Property CRIsActive As %Boolean;

/// 备注
Property CRResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On CRCode;

/// 以部位标志为索引
Index IndexPosFlg On CRPosFlag;

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取诊断部位(亚部位)字典信息
/// Table       : DHCMed.CD.CRDiagnosPos
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.CD.CRDiagnosPos).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.CD.CRDiagnosPos
{
	New (aID)
	Quit:'##class(DHCMed.CD.CRDiagnosPos).%ExistsId(aID) ""
	Set obj=##class(DHCMed.CD.CRDiagnosPos).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取诊断部位(亚部位)字典
/// Table       : DHCMed.CD.CRDiagnosPos
/// Input       : Object
/// w ##class(DHCMed.CD.CRDiagnosPos).GetDescByObj("")
ClassMethod GetDescByObj(obj As DHCMed.CD.CRDiagnosPos) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.CRDesc
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 更新诊断部位(亚部位)字典信息
/// Table       : DHCMed.CD.CRDiagnosPos
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRDiagnosPos).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set Code=$p(aInputStr,aSeparete,2)
	Set Desc=$p(aInputStr,aSeparete,3)
	Set DiagFlag=+$p(aInputStr,aSeparete,4)
	Set IsActive=+$p(aInputStr,aSeparete,5)
	Set Resume=$p(aInputStr,aSeparete,6)
	
	Quit:($l(Code)<1)||(Desc="") return
	Set flgCode=..CheckCode(Code)
	Quit:(ID="")&&(flgCode>0) -2
	
	If (ID="") {
		Set obj=##class(DHCMed.CD.CRDiagnosPos).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRDiagnosPos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CRCode=Code
	Set obj.CRDesc=Desc
	Set obj.CRPosFlag=DiagFlag
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
/// Description : 删除诊断部位(亚部位)字典信息
/// Table       : DHCMed.CD.CRDiagnosPos
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRDiagnosPos).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.CD.CRDiagnosPos).%DeleteId(+aID)
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
/// Description : 检查诊断部位(亚部位)字典代码是否重复
/// Table       : DHCMed.CD.CRDiagnosPos
/// Input       : Code
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRDiagnosPos).CheckCode("B11")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=+$o(^DHCMed.CD.CRDiagnosPosI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Quit return
}

Storage Default
{
<Data name="CRDiagnosPosDefaultData">
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
<Value>CRPosFlag</Value>
</Value>
<Value name="5">
<Value>CRIsActive</Value>
</Value>
<Value name="6">
<Value>CRResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CD.CRDiagnosPosD</DataLocation>
<DefaultData>CRDiagnosPosDefaultData</DefaultData>
<IdLocation>^DHCMed.CD.CRDiagnosPosD</IdLocation>
<IndexLocation>^DHCMed.CD.CRDiagnosPosI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRDiagnosPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
