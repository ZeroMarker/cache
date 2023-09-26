Class dhc.qm.udata.uPadLogin Extends %RegisteredObject
{

/// Creator:     ban
/// CreateDate:  2015-08-12
/// Description: 根据登陆的信息获取登陆人的id
/// Table:       SS_User
/// Input:       userCode 用户工号，userPassWord 用户密码
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPadLogin).GetLoginInfo("<Request><userCode>1</userCode><userPassword>1</userPassword></Request>")
ClassMethod GetLoginInfo(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><userCode>1</userCode><userPassword>0</userPassword></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","dhc.qm.data.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userPassword=request.userPassword
	}
	 s resultString=""
	 q:userCode="" "NouserCode"
	 q:userPassword="" "NouserPassword"
	 
	 s resultString=##class(dhc.qm.udata.uPadLogin).checkInfo(userCode,userPassword)
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-12
/// Description: 根据登陆的信息获取登陆人的id
/// Table:       SS_User
/// Input:       userCode 用户工号，userPassWord 用户密码
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPadLogin).GetLoginInfo("1","1")
ClassMethod checkInfo(userCode, userPassword) As %String
{
	;n (userCode,userPassword)
	s statusName=""
	q:userCode="" "NouserCode"
	q:userPassword="" "NouserPassword"
	s sqlStr="select JXPat_rowid,JXPat_name,JXPat_code,JXPat_Indoccode,JXPat_IndocName,JXPat_operatorcode,JXPat_operdocname,JXPat_operatorID,JXPat_operator,JXPat_operatordate from dhc_qm_data.JXPat"
			_"  where JXPat_rowid in(select LocResultdetail_JXPatDr from dhc_qm_data.LocResultdetail"
			_"  where LocResultdetail_parRef->LocResultMain_Plandr='"_planDr_"' and LocResultdetail_parRef->LocresultMain_schemDr ='"_qmschemDr_"' and LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"' and LocResultdetail_parRef->LocResultmain_period='"_period_"' and LocResultdetail_parRef->LocresultMain_wardDr='"_wardDr_"')"
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="userId"
	While(result.Next())
	{   
		s JXPatRowid = result.Data("JXPat_rowid")
		
	}
	d result.Close()
	s resultString= "{userId:'"_JXPatRowid_"'}"
 	k json
	q resultString
}

}
