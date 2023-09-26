Class DHCWL.MKPIIO.util.Test Extends %RegisteredObject
{

//d ##class(DHCWL.MKPIIO.util.Test).Test()

ClassMethod Test()
{
	s list=##Class(%Library.ListOfObjects).%New()
	s kpi=""
	f {
		s kpi=$o(^DHCWL.MKPI.MKPIDimensionsI("DimAndOrderI",kpi))
		q:kpi=""
		continue:kpi<0
		s order=""
		f {
			s order=$o(^DHCWL.MKPI.MKPIDimensionsI("DimAndOrderI",kpi,order))
			q:order=""
			s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("DimAndOrderI",kpi,order,""))
			continue:kpiDimId=""
			d list.Insert(##class(DHCWL.MKPI.MKPIDimensions).%OpenId(kpiDimId))
		}
	}
	s kpi=""
	f {
		s kpi=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpi))
		q:kpi=""
		continue:kpi<0
		s active=""
		f {
			s active=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpi,active))
			q:active=""
			s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpi,active,""))
			continue:taskId=""
			d list.Insert(##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId))
		}
	}
	s dimId=""
	f {
		s dimId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId))
		q:dimId=""
		s code=""
		f {
			s code=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,code))
			q:code=""
			s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,code,""))
			continue:dimProId=""
			d list.Insert(##class(DHCWL.MKPI.DimProperty).%OpenId(dimProId))
		}
	}
	s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,"D:\test.xml")
}

}
