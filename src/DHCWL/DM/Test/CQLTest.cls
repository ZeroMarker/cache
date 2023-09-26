Class DHCWL.DM.Test.CQLTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.CQLTest).Test("2013-01-01","2013-01-01")

ClassMethod Test(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload.t,"_
            "dims : OrdDate,RecDep->Code,AdmType,RecDep->Hospital hosDr,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ,count() ON (null) ,sum(Price) ON (null),"_
            "filter: OrdDate DateRange("_sd_","_ed_") && ( AdmType contain([O,E]) ) && RecDep->Code = (门诊西药房),"_ ; && RecDep->Code = ('门诊西药房')
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	w "hosDr dim path:"_parser.GetDimPath("rs1","hosDr"),!
	w executor.Execute(),!
	w "index 8 of dims value:"
	s dimsValue=it.DimsAt(8)
	w $lts(dimsValue),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	w "index 1 of dims value:"
	s dimsValue=it.DimsAt(1)
	w $lts(dimsValue),!
	
	w "index 9 of dims value:"
	s dimsValue=it.DimsAt(9)
	w $lts(dimsValue),!
	w it.CurIndex(),!
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestWorkload("2013-01-01","2013-01-01")

ClassMethod TestWorkload(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD   WorkLoad_TarMCNew_Dr
	s cql="rs1:{"_
            "from: /workload.t,"_
            "dims :WorkLoad_Type,WorkLoad_RecDep_DR->Code,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            //"dims : WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_ 
            //"dims : WorkLoad_Rowid,WorkLoad_OEORI_DR,WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            
            "metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,"_ //
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count() ,"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),WorkLoad_TotalPrice,"_
            "filter:  (WorkLoad_OrdDate between("_sd_","_ed_")),"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) &&  WorkLoad_Type contain([O])  && WorkLoad_RecDep_DR->Code = (门诊西药房)  ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  && WorkLoad_PatWard_DR->Code like(内%护%) ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  &&  WorkLoad_Type contain([O]) && WorkLoad_PAPMI_DR >= (4) && WorkLoad_PAPMI_DR <= (88) ,"_
            //"filter:  WorkLoad_Rowid = (297358) ,"_
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
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	while (it.HasNext()){
	  w $lts(it.CurDims(),":",1)_"   ;  "_$lts(it.CurMetrics(),":",1),!
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestWorkload4("2013-01-01","2013-01-01")

ClassMethod TestWorkload4(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload4.t,"_
            "dims : ordDate,type,RecDep,RecDep->Code,tarec,RecDep->Hospital->Name hospital,"_ //
            "metrics: sum(titalPrice) price,sum(titalPrice) ON (type) As AdmSumPrice,sum(titalPrice) ON (ordDate) As daySumPrice,sum(titalPrice) ON (null) allPrice,count() ,count() ON (ordDate),count() ON (null),"_
            "filter: ordDate DateRange("_sd_","_ed_")&& ( type contain([O,E]) ) && RecDep->Code = (门诊西药房),"_ //&& ( type contain([O,E]) ) && RecDep->Code = (门诊西药房)
            "sort:ordDate ,"_
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    "),"    "
	w $lts(it.GetMetricMeta(),"    "),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_" : "_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestWorkloadall("2016-08-26","2016-08-26")

ClassMethod TestWorkloadall(sd, ed)
{
	s cql="rs1:{"_
            "from: /workloadall.t,"_
            "dims : ORDDate,PAADMType type,OrdLocDR->Dept_Desc,PatDocDR->CPV_Desc,PersonID->PERSON_Name,"_ //
            "metrics: sum(TotalPrice) price,sum(TotalPrice) ON (type) As AdmSumPrice,sum(TotalPrice) ON (ORDDate) As daySumPrice,sum(TotalPrice) ON (null) allPrice,count() ,count() ON (ORDDate),count() ON (null),"_
            "filter: ORDDate DateRange("_sd_","_ed_")&& ( PAADMType contain([O,E]) ) && OrdLocDR->Dept_Desc [(儿童),"_ //&& ( type contain([O,E]) ) && RecDep->Code = (门诊西药房)
            "sort:ORDDate ,"_
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_" : "_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestArrayParam("2013-01-01","2013-01-02")

ClassMethod TestArrayParam(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : OrdDate,RecDep->Code,AdmType,TarECDr,RecDep->Hospital hosDr,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ,sum(Price) ON (null),"_
            "filter: OrdDate DateRange('"_sd_"','"_ed_"') && ( AdmType contain (['E','O']) ) && RecDep->Code = ('门诊西药房'),"_ ; && RecDep->Code = ('门诊西药房')
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	d parser.Parse(cql)
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	w "hosDr dim path:"_parser.GetDimPath("rs1","hosDr"),!
	w executor.Execute(),!
	w "index 8 of dims value:"
	s dimsValue=it.DimsAt(8)
	w $lts(dimsValue),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	w "index 1 of dims value:"
	s dimsValue=it.DimsAt(1)
	w $lts(dimsValue),!
	
	w "index 9 of dims value:"
	s dimsValue=it.DimsAt(9)
	w $lts(dimsValue),!
	w it.CurIndex(),!
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestSort("2013-01-01","2013-02-02")

ClassMethod TestSort(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : OrdDate,RecDep->Code,AdmType,TarECDr,RecDep->Hospital hosDr,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ,sum(Price) ON (null),"_
            "filter: OrdDate DateRange("_sd_","_ed_") && ( AdmType contain([O,E]) ) && RecDep->Code = (门诊西药房),"_ ; && RecDep->Code = ('门诊西药房')
            "sort:dim2,AdmType,price desc,"_
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	d parser.Parse(cql)
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	w "hosDr dim path:"_parser.GetDimPath("rs1","hosDr"),!
	w executor.Execute(),!
	w "index 8 value:"
	s dimsValue=it.DimsAt(8)
	w $lts(dimsValue),"  "
	w $lts(it.MetricsAt(8)),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	w "index 1 of dims value:"
	s dimsValue=it.DimsAt(1)
	w $lts(dimsValue),!
	
	w "index 9 of dims value:"
	s dimsValue=it.DimsAt(9)
	w $lts(dimsValue),!
	w it.CurIndex(),!
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).Test2("2013-01-01","2013-01-02")

ClassMethod Test2(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : OrdDate,RecDep->Code recLoc,AdmType,TarECDr,RecDep->Hospital hosDr,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ,sum(Price) ON (null),"_
            "filter: OrdDate DateRange('"_sd_"','"_ed_"') && ( AdmType = ('E') || AdmType = ('O') ) && RecDep->Code = ('门诊西药房'),"_ ; && RecDep->Code = ('门诊西药房')
          "};"_
          "rs2:{"_
            "from:rs1,"_
            "dims:hosDr,hosDr->Name hosName,recLoc,AdmType,"_
            "metrics:sum(price) fee,"_
          "};"_
          "rs3:{"_
            "from:rs2,"_
            "dims:hosDr,hosName,recLoc,"_
            "metrics:sum(fee) fee,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cql)
	w "parse status:"_status,!
	q:status'=$$$OK
	w "hosDr dim path:"_parser.GetDimPath("rs1","hosDr"),!
	w "hosName dim path:"_parser.GetDimPath("rs2","hosName"),!
	w "hosName dim path:"_parser.GetDimPath("rs3","hosName"),!
	w "hosDr dim path:"_parser.GetDimPath("rs3","hosDr"),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	;s list=executor.GetPrintRSList()
	;w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),",",$lts(it.GetMetricMeta()),!
	s status= executor.Execute()
	q:status'=$$$OK
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	s it=executor.GetIterator("rs2")
	w $lts(it.GetDimMeta()),",",$lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	s it=executor.GetIterator("rs3")
	w $lts(it.GetDimMeta()),",",$lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestRealTime("2013-01-01")

ClassMethod TestRealTime(day)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
	        "type:RTQ,"_
	        "day:"_day_","_
            "from: /workload2.t,"_
            "dims : OrdDate,RecDep->Code,AdmType,TarECDr,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ,sum(Price) ON (null),"_
            "filter: ( AdmType = ('E') || AdmType = ('O') ) && RecDep->Code = ('门诊西药房'),"_ ; && RecDep->Code = ('门诊西药房')
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	d parser.Parse(cql)
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestInnerJoin()

ClassMethod TestInnerJoin()
{
	k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name patDocName,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-02') && (AdmType = ('E') || AdmType = ('O'))"_
            "print:true,"_
          "};"_
          "rs2:{"_
            "from: /workload2.t,"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name patDocName,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-03','2013-01-04')&&(AdmType = ('E') || AdmType = ('O'))"_
          "};"_
          "rs3:{"_
            "type:IJ,"_
            "from:rs1=rs2,"_
            "metrics:rs1.price,rs2.AdmSumPrice,"_
            "print:true,"_
          "}"_
          "rs4:{"_
            "from:rs3,"_
            "dims:patCode,hospitalName,AdmType,"_
            "metrics:sum(price),sum(AdmSumPrice),"_
            "print:true,"_
          "}"_
          ""
    s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cql)
	q:status'=$$$OK
	w "patCode dim path:"_parser.GetDimPath("rs4","patCode"),!
	w "hospitalName dim path:"_parser.GetDimPath("rs4","hospitalName"),!
	w "AdmType dim path:"_parser.GetDimPath("rs4","AdmType"),!
	
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	d executor.Execute()
	/*w "rs2:",!
	s it=executor.GetIterator("rs2")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	
	w "rs3:",!
	s it=executor.GetIterator("rs3")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}*/
	
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs4")
	w "rs4:",!
	w $lts(it.GetDimMeta()),$lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestProFun()

ClassMethod TestProFun()
{
	k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : OrdDate,RecDep,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,PatDep->DynamicProFunTest('ab') as dynPro,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-02') && (AdmType = ('E') || AdmType = ('O'))&& PatDep->DynamicProFunTest('ab') [ ('AB')"_
            "print:true,"_
          "};"_
          "rs2:{"_
            "from:rs1,"_
            "dims:hospitalName,dynPro,RecDep->DynamicProFunTest('ab') as recDynPro,"_
            "metrics:sum(price),"_
            "filter:RecDep->Code = ('门诊西药房')"_
            "print:true,"_
          "}"_
          ""
    s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql)
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	q:executor.Execute()'=$$$OK
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs2")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.CQLTest).TestProcedure()

ClassMethod TestProcedure()
{
	s pro=##class(DHCWL.DM.Core.CQLProcedure).%New()
	s cql="rs1:{"_
            "from: /workload2.t,"_
             "dims : RecDep->Code,AdmType,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,sum(Price) ON (null),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-01') && ( AdmType = ('E') || AdmType = ('O') ),"_ ; && RecDep->Code = ('门诊西药房'),
          "};"
	d pro.Batch(cql)
	s flowTest=##class(DHCWL.DM.Test.FlowTest).%New()
	d pro.Flow("flow1:{from:rs1,dims:RecDep->dim1,AdmType,metrics:fee};",flowTest)
	d pro.Batch("rs2:{from:flow1,dims:AdmType,metrics:sum(fee)As SumFee,print:true};")
	d pro.Commit()
	s it=pro.GetIterator("rs2")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d pro.Close()
}

}
