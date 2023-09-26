/// Creator：      lihaihong
/// CreatDate：    20170605
/// Description：   以CQL为编程过程的统一接口
Class DHCWL.DM.Core.CQLProcedure Extends %RegisteredObject
{

Property Parser As CQLParser;

Property Executor As PhysicalExecutor;

Property IsCommit As %Boolean [ Private ];

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
    s ..Parser=##class(CQLParser).%New()
    s ..Executor=##class(PhysicalExecutor).%New(..Parser)
    s ..IsCommit=0
    q $$$OK
}

// d ##class(DHCWL.DM.Core.CQLProcedure).Test()

ClassMethod Test()
{
	s pro=##class(CQLProcedure).%New()
	s cql="rs1:{"_
            "from: /workload2.t,"_
            //"way: OrdDate DateRange('2013-01-01','2013-01-01'),"_
            "dims : RecDep->Code,AdmType,"_ //,TarECDr
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,sum(Price) ON (null),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-01') && ( AdmType = ('E') || AdmType = ('O') ),"_ ; && RecDep->Code = ('门诊西药房')
            //"print:true,"_
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

Method Batch(cql) As %Status
{
	q:..IsCommit=1 $$$ERROR("Procedure has been commited!")
    s status=..Parser.Parse(cql)
    i status'=$$$OK{
	  d DecomposeStatus^%apiOBJ(status,.err,"-d") 
	  s errStr="" ,oneErr="" f {
	    s oneErr=$o(err(oneErr))
	    q:oneErr=""
	    s errStr=errStr_"  "_err(oneErr)
	  }
	  w errStr,!
	}
    q status
}

/*
flowName:{
  from:rsName,
  dims:dim1->rsNameDim,dim2->/ctpcp.d,dim3,
  metric:metric1,metric2
}
*/
Method Flow(flowMetaDefined, flow As Flow) As %Status
{
	q:..IsCommit=1 $$$ERROR("Procedure has been commited!")
	s status= ..Parser.ParseFlow(flowMetaDefined,.irp)
	s irp.FlowExecutor=##class(FlowExecutor).%New(irp,flow)
	q status
}

Method Commit() As %Status
{
	q:..IsCommit=1 $$$ERROR("Procedure has been commited!")
	s ..IsCommit=1
	q ..Executor.Execute()
}

Method GetIterator(resultSetName) As Iterator
{
	q ..Executor.GetIterator(resultSetName)
}

Method Close()
{
	d ..Executor.Close()
	s ..Executor=""
	s ..Parser=""
}

}
