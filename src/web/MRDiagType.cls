Class web.MRDiagType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 87;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// KM 14-Nov-2001: Called from component MRDiagnos.Edit and method ..websysSaveDiagType()
ClassMethod getDiagTypeDetails(PARREF As %Library.String) As %Library.String
{
	//wqr 2011.10.24
	if $g(PARREF) = "" quit ""
	set DTYPDesc = ""
	
	set mradm = $p(PARREF,"||",1)
	set Childsub = $p(PARREF,"||",2)
	
	//只取第一条符合条件的记录
	set TypeChildsub = $o(^MR(mradm,"DIA",Childsub,"TYP",0))
	while(TypeChildsub '= "")
	{
		if DTYPDesc '= "" quit
		set DTypeRowId = ^MR(mradm,"DIA",Childsub,"TYP",TypeChildsub)
		set DTYPDesc = $p($g(^MRC("DTYP",DTypeRowId)),"^",2)
			
		set TypeChildsub = $o(^MR(mradm,"DIA",Childsub,"TYP",TypeChildsub))
	}
	
	//组件MRDiagnos.ListEMR的DiagType要求取"^"第2个部分
	quit "^"_DTYPDesc
}

/// 	s t="",oktoupdate=1
/// 
/// 	d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM,MRDiagnos.Edit")
/// 	
/// 	i DiagType'="" {
/// 		s DiagTypeID=##Class(web.MRCDiagnosType).GetIdFromCodeOrDescription(DiagType)
/// 		i DiagTypeID="",DiagType'="" d:msg msg.AddItem("E",t("MRDiagType"),t("XINVALID")) s oktoupdate=0
/// 	}
/// 	
/// 	i oktoupdate=1 {
/// 		s id=PARREF_"||1"
/// 		s obj=##Class(web.MRDiagType).%OpenId(id)
/// 		i 'obj s obj=##Class(web.MRDiagType).%New()
/// 		i ChartID="" s obj=##Class(epr.Chart).%New()
/// 	i ChartID'="" s obj=##Class(epr.Chart).%OpenId(ChartID)
/// 
/// 
/// 
/// 		//Do DecomposeStatus^%apiOBJ(save,.err) f j=1:1:err d msg.AddItem("E",j,err(j))
/// 
/// 		
/// 	}
/// 
ClassMethod websysSaveDiagType(DiagType As %Library.String, PARREF As %Library.String)
{
}

Parameter SQLCODE = "TYP_RowId";

Parameter SQLDESCRIPTION = "TYP_RowId";

Parameter SQLROWID = "TYP_RowId";

Query FindByParRef(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,TypeDesc,TypeID")
{
SELECT  TYP_Rowid, TYP_MRCDiagTyp->DTYP_Desc, TYP_MRCDiagTyp->DTYP_Rowid
FROM SQLUser.MR_DiagType
WHERE TYP_ParRef = :PARREF
}

}
