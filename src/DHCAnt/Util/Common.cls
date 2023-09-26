/// CTOR: QP
/// DATE: 2019-04-18
/// DESC: CACHE Common Tool
Class DHCAnt.Util.Common Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC:
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.BSNoraml")
ClassMethod GetClassPropertyList(ClassName As %String) As %String
{
	n (ClassName)
	;w ##class(web.PilotProject.DHCDocPilotProCommon).GetClassPropertyList("web.PilotProject.PPA.DHCDocPilotProject")
	
	s myItems=""
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s myCount = myobj.Properties.Count()
	
	s mylist=$p(ClassName,".",$l(ClassName,"."))
	
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		if myName="%%OID" continue
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	
	q mylist
}

}
