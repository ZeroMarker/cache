Class DHCWL.RptMgmt.RptOutputIF Extends DHCWL.MKPIIO.util.OutputInterface [ Not ProcedureBlock ]
{

Method JudgeNodeType(classFullName As %String, primaryFieldValue As %String = "", primaryField As %String = "", refClassFullName As %String = "", refPrimaryFieldValue As %String = "") As %String
{
	n (classFullName,primaryFieldValue,primaryField,refClassFullName,refPrimaryFieldValue)
	s config("DHCWL.RptMgmt.RptCfg")="Object"
	if ((primaryFieldValue="")||(primaryFieldValue'="")){
		if ($d(config(classFullName))){
			q config(classFullName)
		}else {
			q "Base"
		}
	}
	q "Base"
}

}
