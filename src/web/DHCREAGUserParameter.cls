Class web.DHCREAGUserParameter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDefaultPara(depart As %String, user As %String) As %String
{
	s RetStr=""
	s (ime,OPStkInDR,OPStkTransDR,OPStkOutDR,StartUp)=""
	//^lab.DHCCTUserDepartmentD(19,"Params",1)=<<$LB("","","","","","A1")>>
	s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,""))
	s subid=""
	i $l(id) s subid=$o(^lab.DHCCTUserDepartmentD(id,"Params",""),-1)
	i $l(subid) d
	.s str=$g(^lab.DHCCTUserDepartmentD(id,"Params",subid))
	.i '$l(str) q
	.s ime=$li(str,2)
	.s OPStkInDR=$li(str,3)
	.s OPStkTransDR=$li(str,5)
	.s OPStkOutDR=$li(str,4)
	.s StartUp=$li(str,6)
	s RetStr=ime_$c(2)_OPStkInDR_$c(2)_OPStkTransDR_$c(2)_OPStkOutDR_$c(2)_StartUp
	Quit RetStr
}

ClassMethod SaveIme(depart As %String, user As %String, ime As %String) As %String
{
	s ime=$g(ime)
	s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,""))
	i '$l(id) q "用户没用关联此科室"
	s subid=""
	i $l(id) s subid=$o(^lab.DHCCTUserDepartmentD(id,"Params",""),-1)
	i $l(subid) d
	.s rowid=id_"||"_subid
	.&sql(update lab.DHCCTUserDepartParameter set ImeName=:ime where ID=:rowid)
	e  d
	.&sql(insert into lab.DHCCTUserDepartParameter(ParRef,ImeName) values(:id,:ime))
	q SQLCODE
}

ClassMethod SaveOpratorType(depart As %String, user As %String, OpIn As %String, OpTrans As %String, OpOut As %String) As %String
{
	s OpIn=$g(OpIn)
	s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,""))
	i '$l(id) q "用户没用关联此科室"
	s subid=""
	i $l(id) s subid=$o(^lab.DHCCTUserDepartmentD(id,"Params",""),-1)
	i $l(subid) d
	.s rowid=id_"||"_subid
	.&sql(update lab.DHCCTUserDepartParameter set OPStkInDR=:OpIn,OPStkTransDR=:OpTrans,OPStkOutDR=:OpOut where ID=:rowid)
	e  d
	.&sql(insert into lab.DHCCTUserDepartParameter(ParRef,OPStkInDR,OPStkTransDR,OPStkOutDR) values(:id,:OpIn,:OpTrans,:OpOut))
	q SQLCODE
}

}
