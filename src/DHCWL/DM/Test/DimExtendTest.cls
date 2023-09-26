Class DHCWL.DM.Test.DimExtendTest Extends %RegisteredObject
{

Method %OnNew(propertiesExpression As %List) As %Status [ Private, ServerOnly = 1 ]
{
	s dimConfig("")=""
	k dimQueryConfig
	f i=1:1:$ll(propertiesExpression){
	  s pros=$lg(propertiesExpression,i)
	  continue:pros=""
	  s len=$l(pros,",")
	  f j=1:1:len{
		s pro=$p(pros,",",j)
		continue:pro=""
		s dimIns=$p(pro,"->",1)
		s dimInsPro=$p(pro,"->",2)
		s dimInsPro=##class(DHCWL.DM.Util.StringUtil).Trim(dimInsPro)
		continue:dimInsPro=""
		s dimPath=dimConfig(dimIns)
		s dimQueryConfig(dimPath,dimInsPro)=""
	  }
	}
}

}
