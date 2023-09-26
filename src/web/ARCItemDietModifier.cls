Class web.ARCItemDietModifier Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 67;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DM_RowId";

Parameter SQLDESCRIPTION = "DM_RowId";

Parameter SQLROWID = "DM_RowId";

Query FindDietModifier(itmMast As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MODIFDesc:%String")
{
SELECT DM_Modifier_DR->MODIF_Desc
FROM SQLUser.ARC_ItemDietModifier
WHERE DM_ParRef =:itmMast
ORDER BY DM_Modifier_DR->MODIF_Desc
}

Query FindDietModifierDefaults(itmMast As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MODIFDesc")
{
SELECT DM_Modifier_DR->MODIF_Desc
FROM SQLUser.ARC_ItemDietModifier
WHERE (DM_ParRef =:itmMast) AND (DM_Default='Y')
ORDER BY DM_Modifier_DR->MODIF_Desc
}

}
