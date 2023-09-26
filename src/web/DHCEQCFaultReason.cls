Import SQLUser

Class web.DHCEQCFaultReason Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "FR_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "FR_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "FR_RowID";

Parameter SQLFILTER = " (FR_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT FR_Desc,
	   FR_RowID,
	   FR_Code
FROM sqluser.DHC_EQCFaultReason
where FR_InvalidFlag = 'N' and FR_Desc like nvl(:para,'')||'%'
}

/// 20150112  Mozy0149
/// w ##Class(web.DHCEQCFaultReason).UpdFaultReason("01^AAA")
ClassMethod UpdFaultReason(data)
{
	n frrowid,OperMethod,code,desc
	Set frrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503002")
	if (OperMethod=0)||(desc="") Quit ""
	&SQL(Select FR_RowID Into :frrowid from SQLUSER.DHC_EQCFaultReason Where FR_InvalidFlag='N' and FR_Desc=:desc)
	if frrowid=""
	{
		if code=""
		{
			Set frrowid=$Order(^DHCEQCCode("DHCEQCFaultReason",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQCFaultReason",frrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQCFaultReason(FR_Code, FR_Desc, FR_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set frrowid=$Get(%ROWID)
	}
	Quit frrowid
}

}
