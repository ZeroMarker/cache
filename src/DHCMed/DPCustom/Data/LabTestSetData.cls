/// 名称: DHCMed.DPCustom.Data.LabTestSetData
/// 描述: 检验项目结果
/// 编写者：zhufei
/// 编写日期: 2013-03-01
Class DHCMed.DPCustom.Data.LabTestSetData Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检验项目代码
Property TestCode As %String(TRUNCATE = 1);

/// 检验项目名称
Property TestDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 输出数据类型（V细菌、N数值、S标准意见、B2血型结果）
Property DataFormat As %String(TRUNCATE = 1);

/// 检验结果 原始数据
Property DataValue As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 检验结果
Property DataText As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 检验结果单位
Property ItemUnit As %String(TRUNCATE = 1);

/// 异常标记
Property AbnorFlag As %String(TRUNCATE = 1);

/// 参考范围
Property ItemRangs As %String(MAXLEN = 200, TRUNCATE = 1);

/// 英文
Property Synonym As %String(MAXLEN = 200, TRUNCATE = 1);

/// 备注
Property Comments As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 耐药菌标记(0/1)
Property IsRBugs As %String(TRUNCATE = 1);

/// ESBLs标记(0/1)
Property IsESBLs As %String(TRUNCATE = 1);

/// 药敏试验(抗生素代码 $c(2) 抗生素名称 $c(2) 英文名称 $c(2) 药敏代码 $c(2) 药敏名称 $c(1) 抗生素代码 $c(2) ...)
Property Antibiotics As %String(MAXLEN = 2000, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2013-03-01
/// Description:  检验项目结果
/// Table：       DHCMed.DPCustom.Data.LabTestSetData
/// Input：       
/// Return：      返回obj
/// w ##class(DHCMed.DPCustom.Data.LabTestSetData).GetObj()
ClassMethod GetObj(aInput As %String) As DHCMed.DPCustom.Data.LabTestSetData
{
	New (aInput)
	Set return=""
	Quit:aInput="" return
	
	Set TestCode     = $p(aInput,$c(0),1)
	Set TestDesc     = $p(aInput,$c(0),2)
	Quit:(TestCode="")||(TestDesc="") return
	
	Set obj=##Class(DHCMed.DPCustom.Data.LabTestSetData).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.TestCode     = $p(aInput,$c(0),1)
	Set obj.TestDesc     = $p(aInput,$c(0),2)
	Set obj.DataFormat   = $p(aInput,$c(0),3)
	Set obj.DataValue    = $p(aInput,$c(0),4)
	Set obj.DataText     = $p(aInput,$c(0),5)
	Set obj.ItemUnit     = $p(aInput,$c(0),6)
	Set obj.AbnorFlag    = $p(aInput,$c(0),7)
	Set obj.ItemRangs    = $p(aInput,$c(0),8)
	Set obj.Synonym      = $p(aInput,$c(0),9)
	Set obj.Antibiotics  = $p(aInput,$c(0),10)
	Set obj.IsRBugs      = +$p(aInput,$c(0),11)
	Set obj.IsESBLs      = +$p(aInput,$c(0),12)
	Set obj.Comments     = $p(aInput,$c(0),13)
	
	Set return=obj
	Quit return
}

Storage Default
{
<Data name="LisTestSetDataState">
<Value name="1">
<Value>TestCode</Value>
</Value>
<Value name="2">
<Value>TestDesc</Value>
</Value>
<Value name="3">
<Value>DataValue</Value>
</Value>
<Value name="4">
<Value>DataText</Value>
</Value>
<Value name="5">
<Value>DataUnit</Value>
</Value>
<Value name="6">
<Value>DataAbnor</Value>
</Value>
<Value name="7">
<Value>DataRangs</Value>
</Value>
<Value name="8">
<Value>Synonym</Value>
</Value>
<Value name="9">
<Value>Comments</Value>
</Value>
<Value name="10">
<Value>Antibiotics</Value>
</Value>
<Value name="11">
<Value>ItemUnit</Value>
</Value>
<Value name="12">
<Value>AbnorFlag</Value>
</Value>
<Value name="13">
<Value>ItemRangs</Value>
</Value>
<Value name="14">
<Value>IsRBugs</Value>
</Value>
<Value name="15">
<Value>IsESBLs</Value>
</Value>
<Value name="16">
<Value>DataFormat</Value>
</Value>
</Data>
<State>LisTestSetDataState</State>
<StreamLocation>^DHCMed.DPCustom.Data.LabTestSetDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
