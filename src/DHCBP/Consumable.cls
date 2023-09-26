Import SQLUser

Class DHCBP.Consumable Extends web.DHCClinicCom
{

Query GetConsumableListByBPModeId(bpModeId) As %SQLQuery(CONTAINID = 1)
{
SELECT T1.%ID As Id,
       T1.BPCC_Code As Code,
       T1.BPCC_Desc As Description,
	   T1.BPCC_Type As ConsumableType,
	   T1.BPCC_MembraneArea As MembraneArea,
	   T1.BPCC_HighFluxed As HighFluxed,
	   T1.BPCC_Arcim_Dr As ArcimId
	   FROM DHC_BPC_Consumable T1,DHC_BPC_ModeConsumable T2 where T2.BPCMC_BPCMode_Dr=:bpModeId
	   and T1.%ID=T2.BPCMC_BPCConsumable_Dr
}

// D ##class(%ResultSet).RunQuery("DHCBP.AfterDialysis","GetConsumableListByBPModeId","1")

Query GetRConsumableListByBPModeId(bpModeId, BPType) As %SQLQuery(CONTAINID = 1)
{
SELECT T1.%ID As Id,
       T1.BPCC_Desc As Description
	   FROM DHC_BPC_Consumable T1,DHC_BPC_ModeConsumable T2 where T2.BPCMC_BPCMode_Dr=:bpModeId
	   and T1.%ID=T2.BPCMC_BPCConsumable_Dr and T1.BPCC_Type=:BPType
}

Query GetCConsumableListByBPModeId(bpModeId, BPType) As %SQLQuery(CONTAINID = 1)
{
SELECT T1.%ID As Id,
       T1.BPCC_Desc As Description
	   FROM DHC_BPC_Consumable T1,DHC_BPC_ModeConsumable T2 where T2.BPCMC_BPCMode_Dr=:bpModeId
	   and T1.%ID=T2.BPCMC_BPCConsumable_Dr and T1.BPCC_Type<>:BPType
}

/// w ##class(DHCBP.Consumable).SaveArrangeConsumableList(5,"{""ChangedConsumable"":""F60S"",""ChangedConsumableId"":""14"",""ChangedConsumableAmount"":""1"",""ReplacedPipe"":""F60S"",""ReplacedPipeId"":""14"",""ReplacedPipeAmount"":""1""}")
ClassMethod SaveArrangeConsumableList(arrangeId, paraStr) As %String
{
	S ^TEMPBY("BAIY","20190822")=paraStr
	s d=..ToJsonObj(paraStr)
	s consumables=d.GetAt("consumable")
	s count=consumables.Count()
	d ..DeleteConsumableData(arrangeId)
	For i=1:1:count {
		s consumable=consumables.GetAt(i)
		s Id=consumable.GetAt("Id")
		s consumableId=consumable.GetAt("consumableId")
		if (consumableId'="") {
			if (Id){
				s consumableObj=##class(User.DHCBPArrangeConsumable).%OpenId(Id)
			}
			else{
				s consumableObj=##class(User.DHCBPArrangeConsumable).%New()
			}
			s consumableObj.BPACBPArrangeDr=##class(User.DHCBPArrange).%OpenId(arrangeId)
			s consumableObj.BPACBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(consumableId)
			s consumableObj.BPACAmount=consumable.GetAt("ConsumableAmount")
			s consumableObj.BPACType=consumable.GetAt("Type")
			s consumableObj.BPACIfAbandon="N"
			s consumableObj.BPACOperationTime=$p($h,",",2)
			s consumableObj.BPACOperationDate=+$h
			d consumableObj.%Save()
		}
	}
	q "1"
}

ClassMethod DeleteConsumableData(arrangeId)
{
	&sql(update DHC_BP_ArrangeConsumable set BPAC_IfAbandon='Y' where BPAC_BPArrange_Dr=:arrangeId) 
	q 0
}

}
