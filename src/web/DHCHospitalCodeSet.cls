Import SQLUser

Class web.DHCHospitalCodeSet Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2;

ClassMethod GetHospitalCode() As %String
{
	q:'$d(^DHCCURRENTHOSPITAL) "^^"
    s id=$o(^DHCCURRENTHOSPITAL(""))
    s code=$p(^DHCCURRENTHOSPITAL(id),"^",1)
    s desc=$p(^DHCCURRENTHOSPITAL(id),"^",2)
    q id_"^"_code_"^"_desc
}

}
