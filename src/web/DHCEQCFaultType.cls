Import SQLUser

Class web.DHCEQCFaultType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "FT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "FT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "FT_RowID";

Parameter SQLFILTER = " (FT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT FT_Desc,
	   FT_RowID,
	   FT_Code
FROM sqluser.DHC_EQCFaultType
where FT_InvalidFlag = 'N' and FT_Desc like nvl(:para,'')||'%'
}

/// 20150112  Mozy0149
/// w ##Class(web.DHCEQCManufacturer).UpdFaultType("01^AAA")
ClassMethod UpdFaultType(data)
{
	n ftrowid,OperMethod,code,desc
	Set ftrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503001")
	if (OperMethod=0)||(desc="") Quit ""
	&SQL(Select FT_RowID Into:ftrowid from SQLUSER.DHC_EQCFaultType Where FT_InvalidFlag='N' and FT_Desc=:desc)
	if ftrowid=""
	{
		if code=""
		{
			Set ftrowid=$Order(^DHCEQCCode("DHCEQCFaultType",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQCFaultType",ftrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQCFaultType(FT_Code, FT_Desc, FT_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set ftrowid=$Get(%ROWID)
	}
	Quit ftrowid
}

}
