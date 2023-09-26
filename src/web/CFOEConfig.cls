Class web.CFOEConfig Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// by zhouzq 2011-09-30
/// w ##class(web.CFOEConfig).GetConfiguration("OECFPriorityDR","OECPRDesc")
ClassMethod GetConfiguration(Field As %Library.String, ChildField As %Library.String = "") As %Library.String
{
	n val,expr,obj
	s val=""
	s obj=##class(User.CFOEConfig).%OpenId(1)
	if ChildField'="" {
		s expr="i obj."_Field_" s val=obj."_Field_"."_ChildField
	}else{
		s expr="s val=obj."_Field
	}
	X expr
	d obj.%Close()
	quit val
}

Parameter SQLCODE = "OECF_SendHospitalCodeToLab";

Parameter SQLDESCRIPTION = "OECF_RowID";

Parameter SQLROWID = "OECF_RowID";

}
