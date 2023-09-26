/// 名称: DHCHAI.IR.INFLabBact
/// 描述: 医院感染 病原学检验 检出菌
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFLabBact Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.INFLab [ Cardinality = parent, Inverse = ChildBact ];

/// 病原体
Property IRBactDicDr As DHCHAI.DP.LabBacteria;

/// 病原体
Property IRBactDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 药敏结果
Property IRDrugSens As list Of DHCHAI.IR.INFLabSen;

/// 多耐分类
Property IRRuleMRB As DHCHAI.IR.CRuleMRB;

/// 病原学检验+病原体 索引
Index IndexParrefBactDicDr On (Parref, IRBactDicDr);

/// Creator：     chenjb
/// CreatDate：   2017-02-21
/// Description:  更新医院感染 病原学检验 检出菌
/// Table：       DHCHAI.IR.INFLabBact
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFLabBact).Update()
ClassMethod Update(aInput As %String, aDrugSens As %List, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate,aDrugSens)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set Parref 		= $p(aInput,aSeparate,1)
	Set SubID 		= $p(aInput,aSeparate,2)
	Set BactDicDr   = $p(aInput,aSeparate,3)
	Set BactDesc 	= $p(aInput,aSeparate,4)
	Set RuleMRB		= $p(aInput,aSeparate,5)
	
	//Set DrugSens	= $p(aInput,aSeparate,5)
	Set objParref = ##class(DHCHAI.IR.INFLab).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BactDicDr)
	Quit:'$IsObject(objBact) return
	If (SubID="") {
		Set obj=##class(DHCHAI.IR.INFLabBact).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFLabBact).%OpenId(Parref_"||"_SubID)
	}
	Set ListDrugSens=##Class(%Library.ListOfObjects).%New()
	for ind=1:1:$ll(aDrugSens){
		Set LabSens = $lg(aDrugSens,ind)
		Continue:LabSens=""
		Set LanSenStr = $lg(LabSens,1)_"^"_$lg(LabSens,2)_"^"_$lg(LabSens,3)
		d ListDrugSens.Insert(##class(DHCHAI.IR.INFLabSen).GetObj(LanSenStr,"^"))
	}
	Quit:'$IsObject(obj) return
	Set objMRB=""
	Set:RuleMRB'="" objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(RuleMRB)
	
	Set obj.Parref 		= objParref
	Set obj.IRBactDicDr = objBact
	Set obj.IRBactDesc 	= BactDesc
	Set obj.IRDrugSens 	= ListDrugSens
	Set obj.IRRuleMRB	= objMRB
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-06-21
/// Description:  取医院感染报告 病原学检验 病原体
/// Table：       DHCHAI.IR.INFLabBact
/// Input：       DHCHAI.IR.INFLabBact.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportLabPy).GetObj("1^d1^9*s9*9#99*s99*99","^,#,*")
ClassMethod GetObj(aInput As %String, aSeparate As %String = "^") As DHCHAI.IR.INFLabBact
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set obj=##Class(DHCHAI.IR.INFLabBact).%New()
	If obj'="" Do obj.%Close()
	
	Set PathogenyID=$p(aInput,CHR1,1)
	Set PathogenyDesc=$p(aInput,CHR1,2)
	Quit:PathogenyDesc="" return
	
	Set obj.IRPathogenyID=PathogenyID
	Set obj.IRPathogenyDesc=PathogenyDesc
	
	Set SenTests=$p(aInput,CHR1,3)
	Set SenTestLB=""
	For ind=1:1:$length(SenTests,CHR2) {
		Set SenTest=$p(SenTests,CHR2,ind)
		Continue:SenTest=""
		Continue:($listfind(SenTestLB,SenTest)>0)
		Set SenTestLB=SenTestLB_$lb(SenTest)
		Set objSenTest=##class(DHCHAI.IR.INFLabSen).GetObj(SenTest,CHR3)
		Continue:'$IsObject(objSenTest)
		Do obj.DrugSenTest.Insert(objSenTest)
	}
	Set return=obj
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-02-21
/// Description:  取医院感染报告 病原学检验 病原体
/// Table：       DHCHAI.IR.INFLabBact
/// Input：       DHCHAI.IR.INFLabBact.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFLabBact).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFLabBact
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFLabBact).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##Class(DHCHAI.IR.INFLabBact).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFLabBact).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="INFLabBactDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRBactDicDr</Value>
</Value>
<Value name="3">
<Value>IRBactDesc</Value>
</Value>
<Value name="4">
<Value>IRDrugSens</Value>
</Value>
<Value name="5">
<Value>IRRuleMRB</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("BACT")</DataLocation>
<DefaultData>INFLabBactDefaultData</DefaultData>
<IdLocation>{%%PARENT}("BACT")</IdLocation>
<IndexLocation>^DHCHAI.IR.INFLabI("BACT")</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFLabBactS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
