Class DHCWL.DM.Test.CQLTest2 Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.CQLTest2).TestWorkload("2013-01-01","2013-01-01")

ClassMethod TestWorkload(sd, ed)
{
	s cql="rs1:{"_
            "from: /workload.t,"_
            "dims : WorkLoad_Rowid,WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_ //WorkLoad_Rowid,WorkLoad_PatWard_DR->Code,WorkLoad_RecDep_DR,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,WorkLoad_PatWard_DR->Code,  WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,
            "metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),count() ON (WorkLoad_PAPMI_DR),count() ,min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),"_ //,WorkLoad_TotalPrice  sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (WorkLoad_OrdDate) As daySumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count() ON (WorkLoad_OrdDate),count() ON (null),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),count() ON (WorkLoad_PAPMI_DR),count() ,min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice)
            "filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))&&  WorkLoad_Type contain([O])  && WorkLoad_RecDep_DR->Code = (门诊西药房)  ,"_ //&& WorkLoad_PAPMI_DR >= (4) WorkLoad_Rowid = (296073)||  WorkLoad_Rowid = (297358)       &&  WorkLoad_Type contain([O])  && WorkLoad_RecDep_DR->Code = (门诊西药房) && WorkLoad_PAPMI_DR =(1) WorkLoad_PatWard_DR->Code like(内%护%)
            "sort:WorkLoad_PAPMI_DR,"_  //WorkLoad_PAPMI_DR,WorkLoad_TotalPrice desc,
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cql)
	if status'=$$$OK{
		w status,!
		q
	}
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w "列头：",!
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),":",1)_"   ;  "_$lts(it.CurMetrics(),":",1),!
	}
	d executor.Close()
	s executor="",parser=""
}

}
