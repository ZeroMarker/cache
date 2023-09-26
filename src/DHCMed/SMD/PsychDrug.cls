/// 精神类药物字典
Class DHCMed.SMD.PsychDrug Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildAlias As DHCMed.SMD.PsychDrugAlias [ Cardinality = children, Inverse = ParRef ];

/// 代码
Property PDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property PDDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 规格
Property PDSpec As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property PDPackUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱项ID（与HIS系统进行对照）
Property PDArcimID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property PDIsActive As %Boolean;

/// 备注
Property PDResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexCode On PDCode [ Unique ];

/// 名称索引
Index IndexDesc On PDDesc;

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 取精神类药品字典
/// Table       : DHCMed.SMD.PsychDrug
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.SMD.PsychDrug).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.SMD.PsychDrug
{
	New (aID)
	Quit:'##class(DHCMed.SMD.PsychDrug).%ExistsId(aID) ""
	Set obj=##class(DHCMed.SMD.PsychDrug).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 更新精神类药品字典
/// Table       : DHCMed.SMD.PsychDrug
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.PsychDrug).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID		   = $p(aInputStr,aSeparete,1)
	Set PDCode	   = $p(aInputStr,aSeparete,2)
	Set PDDesc	   = $p(aInputStr,aSeparete,3)
	Set PDSpec     = $p(aInputStr,aSeparete,4)
	Set PDPackUnit = $p(aInputStr,aSeparete,5)
	Set PDArcimID  = $p(aInputStr,aSeparete,6)
	Set PDIsActive = +$p(aInputStr,aSeparete,7)
	Set PDResume   = $p(aInputStr,aSeparete,8)
	
	Quit:(PDCode="")||(PDDesc="") return
	
	Set tID=$o(^DHCMed.SMD.PsychDrugI("IndexCode"," "_$ZCVT(PDCode,"U"),0))
	Quit:((ID="")&&(tID'="")) -2  //表示代码重复
	
	If (ID="") {
		Set obj=##class(DHCMed.SMD.PsychDrug).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.PsychDrug).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PDCode		= PDCode
	Set obj.PDDesc		= PDDesc
	Set obj.PDSpec	    = PDSpec
	Set obj.PDPackUnit	= PDPackUnit
	Set obj.PDArcimID	= PDArcimID
	Set obj.PDIsActive  = PDIsActive
	Set obj.PDResume    = PDResume
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

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 删除精神类药品字典
/// Table       : DHCMed.SMD.PsychDrug
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.PsychDrug).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.SMD.PsychDrug).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
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
<Value>PDCode</Value>
</Value>
<Value name="3">
<Value>PDDesc</Value>
</Value>
<Value name="4">
<Value>PDSpec</Value>
</Value>
<Value name="5">
<Value>PDPackUnit</Value>
</Value>
<Value name="6">
<Value>PDArcimID</Value>
</Value>
<Value name="7">
<Value>PDIsActive</Value>
</Value>
<Value name="8">
<Value>PDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SMD.PsychDrugD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SMD.PsychDrugD</IdLocation>
<IndexLocation>^DHCMed.SMD.PsychDrugI</IndexLocation>
<StreamLocation>^DHCMed.SMD.PsychDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
