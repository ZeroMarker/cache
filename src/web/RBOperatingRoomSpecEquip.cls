Class web.RBOperatingRoomSpecEquip Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 111;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_RowId";

Parameter SQLDESCRIPTION = "EQ_RowId";

Parameter SQLROWID = "EQ_RowId";

ClassMethod EquipmentForBooking(OperRoomID As %String = "") As %String
{
}

ClassMethod HasEquipment(parref As %String = "") As %Boolean
{
}

//added by EZ on 13/04/07 for log 62930 to display exceeded equipment booking icon

ClassMethod ExceededEquipment(parref As %String = "") As %Boolean
{
}

ClassMethod websysSaveOperRoomEquip(parref As %String = "", EquipList As %String = "")
{
}

Query ListEquipForBooking(parref As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "EQDesc,EQCode,RESDesc,Location")
{
	SELECT EQ_Equip_DR->EQ_Desc, EQ_Equip_DR->EQ_Code,EQ_Equip_DR->EQ_Resource_DR->RES_Desc,EQ_Equip_DR->EQ_Resource_DR->RES_CTLOC_DR->CTLOC_Desc 
	FROM SQLUser.RB_OperatingRoomSpecEquip
 	WHERE (EQ_ParRef = :parref)
 	ORDER BY EQ_Equip_DR->EQ_Desc
}

}
