Class DHCWL.DM.I.Executor Extends %RegisteredObject
{

Property executor As DHCWL.DM.Core.PhysicalExecutor [ Private ];

// d ##class(DHCWL.DM.I.Executor).Test("2018-03-23","2018-03-23")

ClassMethod Test(sd, ed)
{
	s cql="rs1:{"_
            "from: /workload.t,"_
            //"dims :WorkLoad_Type,"_
            "dims: WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_RecDep_DR->LocDesc,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR as Name,"_
            //"dims: WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_RecDep_DR->LocDesc,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR as Name,"_
            //"dims :WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            //"dims : WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_ 
            //"dims : WorkLoad_Rowid,WorkLoad_OEORI_DR,WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            
            "metrics: sum(WorkLoad_TotalPrice) price,"_ //
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,"_ //
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count() ,"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),WorkLoad_TotalPrice,"_
            "filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) ,"_
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))&& WorkLoad_Type contain([I]) && WorkLoad_RecDep_DR->LocDesc [(内),"_
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) && WorkLoad_Type isnull(),"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) &&  WorkLoad_Type contain([O])  && WorkLoad_RecDep_DR->Code = (门诊西药房)  ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  && WorkLoad_PatWard_DR->Code like(内%护%) ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  &&  WorkLoad_Type contain([O]) && WorkLoad_PAPMI_DR >= (4) && WorkLoad_PAPMI_DR <= (88) ,"_
            //"filter:  WorkLoad_Rowid = (297358) ,"_
            //"sort:WorkLoad_PAPMI_DR,"_  //WorkLoad_PAPMI_DR,WorkLoad_TotalPrice desc,
            "print:true,"_
          "};"
	s executor=##class(Executor).Init(cql)
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	d executor.Execute()
	while (it.HasNext()){
	  w $lts(it.CurDims(),":",1)_"   ;  "_$lts(it.CurMetrics(),":",1),!
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor=""
}

ClassMethod Init(cqlExpression As %Text) As Executor
{
	s iex=##class(Executor).%New()
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cqlExpression)
	q:status'=$$$OK status
	s iex.executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	q iex
}

Method Execute() As %Status
{
	s status=..executor.Execute()
	q:status'=$$$OK status
	q status
}

Method GetIterator(resultName As %String = "") As DHCWL.DM.Core.Iterator
{
	if resultName'=""{
		q ..executor.GetIterator(resultName)
	}
	s itlist=executor.GetPrintRSList()
	if (($ll(itlist)=1)&&($lg(itlist,1)'="")){
		q $lg(itlist,1)
	}
	s itlist=executor.GetIteratorList()
	if (($ll(itlist)=1)&&($lg(itlist,1)'="")){
		q $lg(itlist,1)
	}
}

Method Close()
{
	d ..executor.Close()
}

}
