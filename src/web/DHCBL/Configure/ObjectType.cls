Class web.DHCBL.Configure.ObjectType Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetObject(SessionStr As %String) As %ObjectHandle
{
	s myobj=##class(web.DHCEntity.Configure.ObjectType).%New()
	s myobj.IP =$p(SessionStr,"^",1)
	s myobj.SSUser = $p(SessionStr,"^",2)
	s myobj.CTLoc = $p(SessionStr,"^",3)
	s myobj.SSGroup = $p(SessionStr,"^",4)
	s myobj.CTHospital= $p(SessionStr,"^",5)
	s myobj.SITE =$p(SessionStr,"^",6)
	
	q myobj
}

}
