/// 名称: DHCWL.MKPIService.ExtendMKPIQuery
/// 描述: 标准指标Query扩展类
/// 编写者：lihaihong
/// 编写日期:2017-09-25
/// 
Class DHCWL.MKPIService.ExtendMKPIQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 在QueryMKPIByDate，QueryKpiWithContract，NewQueryKpiWithContract三个标准Query的基础上增加3个参数分别表示过滤函数CheckContain的参数值，该参数值可以是很多个以英文逗号分隔的数值，用来过滤维度是否包含某个参数值
/// 在指标过滤表达式中CheckContain函数最多支持3次使用。在指标过滤表达式中函数CheckContain后的参数写1或2或3分别对应choicedPara1Values，choicedPara2Values，choicedPara3Values
/// @Param standQueryName的值为QueryMKPIByDate，QueryKpiWithContract或NewQueryKpiWithContract
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.ExtendMKPIQuery","BaseExtendKpiQurey","LHHKPI2:RecDep.LocDesc^RecDep.HospDesc^PatDep.LocDesc^AdmType^TarECDr","LHHKPI2:( [{AdmType}=O || {AdmType}=E] && {RecDep} CheckContain 1 && {PatDep} CheckContain 2 )","2013-01-01","2013-01-01",,,,,,,"100,101,159,67,85","67")
Query BaseExtendKpiQurey(kpiRule As %Text, filterRule As %Text, startDate As %String, endDate As %String, dateType As %String = "freeDateChoice", standQueryName As %String = "QueryMKPIByDate", mode = "H", contractType As %String = "", dynParam As %Text = "", execParam As %Text = "", choicedPara1Values As %Text = "", choicedPara2Values As %Text = "", choicedPara3Values As %Text = "") As %Query(ROWSPEC = "monId:%String,contractTye:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod BaseExtendKpiQureyExecute(ByRef qHandle As %Binary, kpiRule As %Text, filterRule As %Text, startDate As %String, endDate As %String, dateType As %String = "freeDateChoice", standQueryName As %String = "QueryMKPIByDate", mode = "H", contractType As %String = "", dynParam As %Text = "", execParam As %Text = "", choicedPara1Values As %Text = "", choicedPara2Values As %Text = "", choicedPara3Values As %Text = "") As %Status
{
	n (qHandle,kpiRule, filterRule, startDate, endDate , dateType ,standQueryName,mode, contractType, dynParam, execParam ,choicedPara1Values,choicedPara2Values,choicedPara3Values)
	s:standQueryName="" standQueryName="QueryMKPIByDate"
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^CacheTemp($j,"DHCWLEMQ")
	if choicedPara1Values'=""{
	  s ^CacheTemp($j,"DHCWLEMQ",1)="Y"
	  s len=$l(choicedPara1Values)
	  f i=1:1:len{
		s pv=$p(choicedPara1Values,",",i)
		continue:pv=""
		s ^CacheTemp($j,"DHCWLEMQ",1,pv)=""
	  }
	}else{
	  s ^CacheTemp($j,"DHCWLEMQ",1)="N"
	}
	if choicedPara2Values'=""{
	  s ^CacheTemp($j,"DHCWLEMQ",2)="Y"
	  s len=$l(choicedPara2Values)
	  f i=1:1:len{
		s pv=$p(choicedPara2Values,",",i)
		continue:pv=""
		s ^CacheTemp($j,"DHCWLEMQ",2,pv)=""
	  }
	}else{
	  s ^CacheTemp($j,"DHCWLEMQ",2)="N"
	}
	if choicedPara3Values'=""{
	  s ^CacheTemp($j,"DHCWLEMQ",3)="Y"
	  s len=$l(choicedPara3Values)
	  f i=1:1:len{
		s pv=$p(choicedPara3Values,",",i)
		continue:pv=""
		s ^CacheTemp($j,"DHCWLEMQ",3,pv)=""
	  }
	}else{
	  s ^CacheTemp($j,"DHCWLEMQ",3)="N"
	}
	
	if standQueryName="QueryMKPIByDate"{
	  s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	  s sc=rs.Execute(kpiRule,startDate,endDate,dateType,mode,filterRule,dynParam, execParam)
	  s len=rs.GetColumnCount()
	  ;s ^CacheTemp(repid,ind)=$lb("386",,"2013年01月01日","3188","LHHKPI2",,"67,67,,,,E,29,,,,,,,","急诊科,北京地坛医院,急诊科,急诊,29",122.5756099701597332)
	  ;q $$$OK
	  while rs.Next(.sc) {
		i $$$ISERR(sc) q
		s lb=$lb("","")
		s $list(lb,1)=rs.GetData(1)
		f i=2:1:len{
			s $list(lb,i+1)=rs.GetData(i)
		}
	    s ^CacheTemp(repid,ind)=lb
 	    s ind=ind+1
	  }
	  d rs.Close()
	}elseif standQueryName="QueryKpiWithContract"{
	  s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryKpiWithContract")
	  s sc=rs.Execute(kpiRule,startDate,endDate,dateType,mode,contractType,filterRule,dynParam, execParam)
	  s len=rs.GetColumnCount()
	  while rs.Next(.sc) {
		i $$$ISERR(sc) q
		s lb=$lb()
		f i=1:1:len{
			s $list(lb,i)=rs.GetData(i)
		}
	    s ^CacheTemp(repid,ind)=lb
 	    s ind=ind+1
	  }
	  d rs.Close()
	}elseif standQueryName="NewQueryKpiWithContract"{
	  s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract")
	  s sc=rs.Execute(kpiRule,startDate,endDate,dateType,mode,contractType,filterRule,dynParam, execParam)
	  s len=rs.GetColumnCount()
	  while rs.Next(.sc) {
		i $$$ISERR(sc) q
		s lb=$lb()
		f i=1:1:len{
			s $list(lb,i)=rs.GetData(i)
		}
	    s ^CacheTemp(repid,ind)=lb
 	    s ind=ind+1
	  }
	  d rs.Close()
	}else{
	  s ^CacheTemp(repid,1)=$lb("Query Name:"_standQueryName_" is not supported!")
	}
	
	Quit $$$OK
}

ClassMethod BaseExtendKpiQureyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BaseExtendKpiQureyExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
	k ^CacheTemp($j,"DHCWLEMQ")
	Quit $$$OK
}

ClassMethod BaseExtendKpiQureyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BaseExtendKpiQureyExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(DHCWL.MKPIService.ExtendMKPIQuery).CheckContain
ClassMethod CheckContain(a, b As %Integer = 1) As %Boolean
{
	n (a,b)
	q:^CacheTemp($j,"DHCWLEMQ",b)="N" 1
	q:((a="")||(b="")) 0
	q $d(^CacheTemp($j,"DHCWLEMQ",b,a))=1
}

}
