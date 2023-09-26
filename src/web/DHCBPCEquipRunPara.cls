Import SQLUser

Class web.DHCBPCEquipRunPara Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetEquipRunParaList(equipRunParaCatId As %String) As %SQLQuery(CONTAINID = 1)
{
   SELECT %ID As Id,
	   BPCERP_Code As Code,
	   BPCERP_Desc As Description,
	   BPCERP_Image As Image,
	   BPCERP_Min As MinValue,
	   BPCERP_Max As MaxValue,
	   BPCERP_BPCERPC_Dr As EquipRunParaCatId,
	   BPCERP_Value As Value,
	   BPCERP_Increment As Increment,
	   BPCERP_ShowImage As ShowImage,
	   BPCERP_ShowRange As ShowRange,
	   BPCERP_ShowValue As ShowValue
	   FROM DHC_BPC_EquipRunPara where BPCERP_BPCERPC_Dr=:equipRunParaCatId
}

}
