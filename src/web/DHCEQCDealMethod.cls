Import SQLUser

Class web.DHCEQCDealMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "DM_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "DM_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "DM_RowID";

Parameter SQLFILTER = " (DM_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DM_Desc,
	   DM_RowID,
	   DM_Code
FROM sqluser.DHC_EQCDealMethod
where DM_InvalidFlag = 'N' and DM_Desc like nvl(:para,'')||'%'
}

/// 20150112  Mozy0149
/// w ##Class(web.DHCEQCDealMethod).UpdDealMethod("01^AAA")
ClassMethod UpdDealMethod(data)
{
	n dmrowid,OperMethod,code,desc
	Set dmrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503003")
	if (OperMethod=0)||(desc="") Quit ""
	&SQL(Select DM_RowID Into :dmrowid from SQLUSER.DHC_EQCDealMethod Where DM_InvalidFlag='N' and DM_Desc=:desc)
	if dmrowid=""
	{
		if code=""
		{
			Set dmrowid=$Order(^DHCEQCCode("DHCEQCDealMethod",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQCDealMethod",dmrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQCDealMethod(DM_Code, DM_Desc, DM_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set dmrowid=$Get(%ROWID)
	}
	Quit dmrowid
}

}
