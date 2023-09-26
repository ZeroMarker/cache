/// 名称: DHCMA.CPW.STA.DataResults
/// 描述: 临床路径 统计数据池
/// 编写者：jiangpengpeng
/// 编写日期: 2019-03-21
Class DHCMA.CPW.STA.DataResults Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 明细信息
Relationship Child As DHCMA.CPW.STA.DataDetails [ Cardinality = children, Inverse = Parref ];

/// 数据日期(每月第一天)
Property STADate As %Date;

/// 医院ID
Property STAHospID As %String;

/// 入径科室ID
Property STAInLocID As %String;

/// 入径科室
Property STAInLocDesc As %String;

/// 路径类型ID
Property STAPathTypeID As %String;

/// 路径类型
Property STAPathTypeDesc As %String;

/// 路径PathMastID
Property STAPathID As %String;

/// 路径名称
Property STAPathDesc As %String;

/// 病种ID
Property STAPathSDID As %String;

/// 病种名称
Property STAPathSDDesc As %String;

/// 应入径人数
Property STAForCPCount As %String;

/// 入径人数
Property STAInCPCount As %String;

/// 出径人数
Property STAOutCPCount As %String;

/// 完成人数
Property STAClsCPCount As %String;

/// 变异人数
Property STAVarCPCount As %String;

/// 发生院感人数
Property STAHAICount As %String;

/// 总住院日
Property STAInHospDays As %String;

/// 总费用
Property STAFees As %String;

/// 当天再入院人数
Property STAReAdmCount As %String;

/// 入院24小时内退出人数
Property STAOutCP24HCount As %String;

/// 术前住院日数
Property STAOprInHospDays As %String;

/// 治愈人数
Property STAHealingCount As %String;

/// 好转人数
Property STABetterCount As %String;

/// 死亡人数
Property STADeadCount As %String;

/// 手术部位感染人数
Property STAOprInfCount As %String;

/// 非计划重返手术室人数
Property STAReOperCount As %String;

/// 药费
Property STADrugCost As %String;

/// 检验费
Property STALabCost As %String;

/// 耗材费
Property STAMaterialCost As %String;

/// 使用预防性抗菌药物人数
Property STAPreDrugCount As %String;

/// 使用三线抗菌药物人数
Property STA3PharmacyCount As %String;

/// 使用抗菌药物人数
Property STAPharmacyCount As %String;

/// 使用抗菌药物天数
Property STAPharmacyDays As %String;

/// 抗菌药物费用
Property STAPharmacyCost As %String;

/// 14日再住院人数
Property STAReAdmIn14Count As %String;

/// 31日在住院人数
Property STAReAdmIn31Count As %String;

/// 合并症人数
Property STAComplCount As %String;

/// 并发症人数
Property STAComplCount2 As %String;

/// 出院人数
Property STADischCount As %String;

/// 生成日期
Property STAActDate As %Date;

/// 生成时间
Property STAActTime As %Time;

/// 出院科室ID
Property STAOutLocID As %String;

/// 出院科室
Property STAOutLocDesc As %String;

Index IdxofDate On (STADate, STAHospID As Exact, STAInLocID As Exact, STAPathID As Exact);

Index IdxofOutDate On (STADate, STAHospID As Exact, STAOutLocID As Exact, STAPathID As Exact);

Index IdxofInOutDate On (STADate, STAHospID As Exact, STAInLocID As Exact, STAOutLocID As Exact, STAPathID As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-21
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       aId : DHCMA.CPW.STA.DataResults.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.STA.DataResults).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.STA.DataResults
{
	New (aId)
	Quit:'##class(DHCMA.CPW.STA.DataResults).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.STA.DataResults).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-21
/// Description:  生成一条记录
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STA.DataResults).Update(1)
ClassMethod Update(aInputs As %String) As %String
{
	New (aInputs)
	Set return=""
	Quit:aInputs="" return
	
	Set Time             = $p(aInputs,"^",1)
	Set HospID           = $p(aInputs,"^",2)
	Set InLocID          = $p(aInputs,"^",3)
	Set InLocDesc        = $p(aInputs,"^",4)
	Set PathTypeID       = $p(aInputs,"^",5)
	Set PathTypeDesc     = $p(aInputs,"^",6)
	Set PathID           = $p(aInputs,"^",7)
	Set PathDesc         = $p(aInputs,"^",8)
	Set PathSDID         = $p(aInputs,"^",9)
	Set PathSDDesc       = $p(aInputs,"^",10)
	Set ForCPCount       = $p(aInputs,"^",11)
	Set InCPCount        = $p(aInputs,"^",12)
	Set OutCPCount       = $p(aInputs,"^",13)
	Set ClsCPCount       = $p(aInputs,"^",14)
	Set VarCPCount       = $p(aInputs,"^",15)
	Set HasHAICount    	 = $p(aInputs,"^",16)
	Set InHospDays       = $p(aInputs,"^",17)
	Set Fees             = $p(aInputs,"^",18)

	Set ReAdmCount       = $p(aInputs,"^",19)
	Set OutCP24hCount    = $p(aInputs,"^",20)
	Set OprInHospDays    = $p(aInputs,"^",21)
	Set HealingCount     = $p(aInputs,"^",22)
	Set BetterCount      = $p(aInputs,"^",23)
	Set DeadCount        = $p(aInputs,"^",24)
	Set OprInfCount      = $p(aInputs,"^",25)
	Set ReOperCount      = $p(aInputs,"^",26)
	Set DrugCost         = $p(aInputs,"^",27)
	Set LabCost          = $p(aInputs,"^",28)
	Set MaterialCost     = $p(aInputs,"^",29)
	Set PreDrugCount     = $p(aInputs,"^",30)
	Set TPharmacyCount   = $p(aInputs,"^",31)
	Set PharmacyCount    = $p(aInputs,"^",32)
	Set PharmacyDays     = $p(aInputs,"^",33)
	Set PharmacyCost     = $p(aInputs,"^",34)
	Set ReAdmIn14Count   = $p(aInputs,"^",35)
	Set ReAdmIn31Count   = $p(aInputs,"^",36)
	Set ComplCount       = $p(aInputs,"^",37)
	Set ComplCount2      = $p(aInputs,"^",38)
	Set DischCount       = $p(aInputs,"^",39)
	Set OutLocID      	 = $p(aInputs,"^",40)
	Set OutLocDesc       = $p(aInputs,"^",41)
	
	Quit:(Time="") return
	Quit:(HospID="")||(InLocID="")||(PathID="") return
	
	Set ID=""
	Set ID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofInOutDate",Time,HospID,InLocID,OutLocID,PathID,ID))
	If (ID'="") {
		Set obj=..GetObjById(ID)
	} Else {
		Set obj=##class(DHCMA.CPW.STA.DataResults).%New()
	}
	Quit:'$IsObject(obj) return
	
	Set obj.STADate          = Time
	Set obj.STAHospID        = HospID
	Set obj.STAInLocID       = InLocID
	Set obj.STAInLocDesc     = InLocDesc
	Set obj.STAPathTypeID    = PathTypeID
	Set obj.STAPathTypeDesc  = PathTypeDesc
	Set obj.STAPathID        = PathID
	Set obj.STAPathDesc      = PathDesc
	Set obj.STAPathSDID      = PathSDID
	Set obj.STAPathSDDesc    = PathSDDesc
	Set obj.STAForCPCount    = ForCPCount
	Set obj.STAInCPCount     = InCPCount
	Set obj.STAOutCPCount    = OutCPCount
	Set obj.STAClsCPCount    = ClsCPCount
	Set obj.STAVarCPCount    = VarCPCount
	Set obj.STAHAICount      = HasHAICount
	Set obj.STAInHospDays    = InHospDays
	Set obj.STAFees          = Fees
	Set obj.STAActDate		 = +$h
	Set obj.STAActTime		 = $p($h,",",2)
	
	Set obj.STAReAdmCount        = ReAdmCount
	Set obj.STAOutCP24HCount     = OutCP24hCount
	Set obj.STAOprInHospDays     = OprInHospDays
	Set obj.STAHealingCount      = HealingCount
	Set obj.STABetterCount       = BetterCount
	Set obj.STADeadCount         = DeadCount
	Set obj.STAOprInfCount       = OprInfCount
	Set obj.STAReOperCount       = ReOperCount
	Set obj.STADrugCost          = DrugCost
	Set obj.STALabCost           = LabCost
	Set obj.STAMaterialCost      = MaterialCost
	Set obj.STAPreDrugCount      = PreDrugCount
	Set obj.STA3PharmacyCount    = TPharmacyCount
	Set obj.STAPharmacyCount     = PharmacyCount
	Set obj.STAPharmacyDays      = PharmacyDays
	Set obj.STAPharmacyCost      = PharmacyCost
	Set obj.STAReAdmIn14Count    = ReAdmIn14Count
	Set obj.STAReAdmIn31Count    = ReAdmIn31Count
	Set obj.STAComplCount        = ComplCount
	Set obj.STAComplCount2       = ComplCount2
	Set obj.STADischCount        = DischCount
	Set obj.STAOutLocID       	 = OutLocID
	Set obj.STAOutLocDesc        = OutLocDesc
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		Do ##class(DHCMA.CPW.STA.DataDetails).Clear(return)	//清除明细信息
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DataResultsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STADate</Value>
</Value>
<Value name="3">
<Value>STAHospID</Value>
</Value>
<Value name="4">
<Value>STAInLocID</Value>
</Value>
<Value name="5">
<Value>STAInLocDesc</Value>
</Value>
<Value name="6">
<Value>STAPathTypeID</Value>
</Value>
<Value name="7">
<Value>STAPathTypeDesc</Value>
</Value>
<Value name="8">
<Value>STAPathID</Value>
</Value>
<Value name="9">
<Value>STAPathDesc</Value>
</Value>
<Value name="10">
<Value>STAPathSDID</Value>
</Value>
<Value name="11">
<Value>STAPathSDDesc</Value>
</Value>
<Value name="12">
<Value>STAForCPCount</Value>
</Value>
<Value name="13">
<Value>STAInCPCount</Value>
</Value>
<Value name="14">
<Value>STAOutCPCount</Value>
</Value>
<Value name="15">
<Value>STAClsCPCount</Value>
</Value>
<Value name="16">
<Value>STAVarCPCount</Value>
</Value>
<Value name="17">
<Value>STAHAICount</Value>
</Value>
<Value name="18">
<Value>STAInHospDays</Value>
</Value>
<Value name="19">
<Value>STAFees</Value>
</Value>
<Value name="20">
<Value>STAReAdmCount</Value>
</Value>
<Value name="21">
<Value>STAOutCP24HCount</Value>
</Value>
<Value name="22">
<Value>STAOprInHospDays</Value>
</Value>
<Value name="23">
<Value>STAHealingCount</Value>
</Value>
<Value name="24">
<Value>STABetterCount</Value>
</Value>
<Value name="25">
<Value>STADeadCount</Value>
</Value>
<Value name="26">
<Value>STAOprInfCount</Value>
</Value>
<Value name="27">
<Value>STAReOperCount</Value>
</Value>
<Value name="28">
<Value>STADrugCost</Value>
</Value>
<Value name="29">
<Value>STALabCost</Value>
</Value>
<Value name="30">
<Value>STAMaterialCost</Value>
</Value>
<Value name="31">
<Value>STAPreDrugCount</Value>
</Value>
<Value name="32">
<Value>STA3PharmacyCount</Value>
</Value>
<Value name="33">
<Value>STAPharmacyCount</Value>
</Value>
<Value name="34">
<Value>STAPharmacyDays</Value>
</Value>
<Value name="35">
<Value>STAPharmacyCost</Value>
</Value>
<Value name="36">
<Value>STAReAdmIn14Count</Value>
</Value>
<Value name="37">
<Value>STAReAdmIn31Count</Value>
</Value>
<Value name="38">
<Value>STAComplCount</Value>
</Value>
<Value name="39">
<Value>STAComplCount2</Value>
</Value>
<Value name="40">
<Value>STADischCount</Value>
</Value>
<Value name="41">
<Value>STAActDate</Value>
</Value>
<Value name="42">
<Value>STAActTime</Value>
</Value>
<Value name="43">
<Value>STAOutLocID</Value>
</Value>
<Value name="44">
<Value>STAOutLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.STA.DataResultsD</DataLocation>
<DefaultData>DataResultsDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.STA.DataResultsD</IdLocation>
<IndexLocation>^DHCMA.CPW.STA.DataResultsI</IndexLocation>
<StreamLocation>^DHCMA.CPW.STA.DataResultsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
