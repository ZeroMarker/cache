Class DHCWL.APP.Data.Test Extends %RegisteredObject
{

//d ##class(DHCWL.APP.Data.Test).Test()

ClassMethod Test()
{
	s searcheValue="a"
		;s kpiId=+kpiId
		s sql="select KDT_Code,KDT_Name from DHCWL_MKPI.DHCWLMKPIDimType"
		i searcheValue'="" s sql=sql_" where KDT_Code like '%"_searcheValue_"%'"
		s rs=##class(%ResultSet).%New()
		s sc=rs.Prepare(sql)
		If $$$ISERR(sc){
			w "Error"
			q
		}
		s sc=rs.Execute()
		s dp=##class(DHCWL.APP.Data.DataPackage).SetResultSet(rs,"DHCWLMKPIDimType")
		s js=dp.GetReader()
		s jo=js.GetJsonObject()
		s dsm=dp.GetDataStorageManager()
		s cursor=dsm.GetCursor("DHCWLMKPIDimType")
		d js.SetOnceDomain(1,1)
		s pivot=js.GetOnceDomainFrom()
		while((pivot'="")) {
			w jo.ToArrayString()
			if 'js.IsOnceLast() w ","
			s pivot=js.OnceNext()
			w !
		}
}

}
