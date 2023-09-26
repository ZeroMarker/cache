Class DHCWL.DM.Core.PhysicalExecutor Extends %RegisteredObject
{

/// 单个节点的最大Bit长度 最大可设置为：262104;
Parameter MAXBITRANGE = 262104;

/// 分配的最大分区号，适用于数据和索引
Parameter MAXPARTIONNUM = 6;

/// 维度数据结构定义转换成List时多大长度为一个单元
Parameter DIMSTRUCTLISTUNIT = 4;

Property Parser As DHCWL.DM.Core.CQLParser;

Property Debug As %Boolean;

Property IteratorList As %ListOfObjects [ Private ];

Property IteratorMap [ MultiDimensional ];

Method %OnNew(cqlParser As DHCWL.DM.Core.CQLParser, debugFlag As %Boolean = 0) As %Status [ Private, ServerOnly = 1 ]
{
	s ..Parser=cqlParser
	s ..Debug=debugFlag
	s ..Debug=1
	s ..IteratorList=##class(%ListOfObjects).%New()
	q $$$OK
}

// d ##class(DHCWL.DM.Core.PhysicalExecutor).TestWorkloadAll("2015-01-01","2015-02-10")

ClassMethod TestWorkloadAll(start, end)
{
	k ^||TEMPCMPDCUBEDI,^||TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /WorkLoadAlll.t,"_
            "dims : wl_orddate,"_ //wl_orddate,WL_ABDATE_FK,WL_ADMREASON,WL_ARCBG_FK
            "metrics: sum( WL_TOTALPRICE ) price,count(),count() on (null),"_
            "filter: WL_ABDATE DateRange('"_start_"','"_end_"') ,"_
            "print:true,"_
          "};"_
          ""
    s parser=##class(CQLParser).%New()
	d parser.Parse(cql)
	s executor=##class(PhysicalExecutor).%New(parser)
	d executor.Execute()
	s list=executor.GetPrintRSList()
	;w $lts(list),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Core.PhysicalExecutor).TestInnerJoin()

ClassMethod TestInnerJoin()
{
	k ^||TEMPCMPDCUBEDI,^||TEMPCMPDCUBEDD
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-02') && (AdmType = ('E') || AdmType = ('O'))"_
            "print:true,"_
          "};"_
          "rs2:{"_
            "from: /workload2.t,"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
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
            "dims:RecDep,hospitalName,AdmType,"_
            "metrics:sum(price),sum(AdmSumPrice),"_
            "print:true,"_
          "}"_
          ""
    s parser=##class(CQLParser).%New()
	d parser.Parse(cql)
	s executor=##class(PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s list=executor.GetPrintRSList()
	w $lts(list),!
	s it=executor.GetIterator("rs4")
	w $lts(it.GetDimMeta()),!
	w $lts(it.GetMetricMeta()),!
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^")_","_$lts(it.CurMetrics(),"^"),!	
	}
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Core.PhysicalExecutor).TestProFun()

Method DimsMeta(resultSetName As %String) As %List
{
	s irp=..Parser.GetIRParser(resultSetName)
	s lb=irp.GetMetaDims()
	s irp=""
	q lb
}

Method MetricsMeta(resultSetName As %String) As %List
{
	s irp=..Parser.GetIRParser(resultSetName)
	s lb=irp.GetMetaMetrics()
	s irp=""
	q lb
}

Method GetPrintRSList() As %List
{
	q ..Parser.GetPrintRSList()
}

Method GetIteratorList() As %List
{
	q ..Parser.GetRSList()
}

Method GetIterator(resultSetName) As Iterator
{
	s it=""
	if '$d(..IteratorMap(resultSetName)){
	  s irp=..Parser.GetIRParser(resultSetName)
	  s mask=irp.ComputedCube.Mask()
	  m sortStructMap=irp.sortStructMap
	  m metricDataInfo=irp.metricsShowInd
	  s it= ##class(Iterator).%New(mask,..DimsMeta(resultSetName),..MetricsMeta(resultSetName),.sortStructMap,.metricDataInfo,irp.GetComputedTheme(),irp.HasSortFlag,irp.MetricDitailInSortFlag)
	  d it.OnExecute()
	  d ..IteratorList.Insert(it)
	  s ..IteratorMap(resultSetName)=..IteratorList.Count()
	}else{
	  s iti=..IteratorMap(resultSetName)
	  s it=..IteratorList.GetAt(iti)
	}
	q it
}

Method Execute() As %Status
{
	;b ;Execute
	s status= ..Parser.GetStatus()
	i status'=$$$OK{
	  d DecomposeStatus^%apiOBJ(status,.err,"-d") 
	  s errStr="" ,oneErr="" f {
	    s oneErr=$o(err(oneErr))
	    q:oneErr=""
	    s errStr=errStr_"  "_err(oneErr)
	  }
	  ;w errStr,!
	  q status
	}
	if ..Debug{
	  s startTime=$p($zts,",",2)
	  s dgind=$i(^temp("PhysicalExecutor"))	
	}
	s status=$$$OK
	s forest=..Parser.ParserForest
	s len=forest.Count()
	f i=1:1:len {
	  s irp=forest.GetAt(i)
	  s status=..ExecuteRoot3(irp)
	  q:status'=$$$OK
	}
	q:status'=$$$OK status
	f i=1:1:len {
	  s irp=forest.GetAt(i)
	  s children=irp.Children
	  s clen=children.Count()
	  f j=1:1:clen{
		s child=children.GetAt(j)
		s status=..RecurseExecuteChild(child)
		q:status'=$$$OK
	  }
	}
	if ..Debug{
	  s endTime=$p($zts,",",2)
	  s dgind=^temp("PhysicalExecutor")
	  s ^temp(dgind,"PhysicalExecutor","Execute")=endTime-startTime
	}
	s itLen=..IteratorList.Count()
	f i=1:1:itLen{
	  s it=..IteratorList.GetAt(i)
	  d it.OnExecute()
	}
	q status
}

Method RecurseExecuteChild(child As InternalResolvedParser) As %Status
{
	s status=..ExecuteChild(child)
	q:status'=$$$OK status
	s children=child.Children
	s len=children.Count()
	f i=1:1:len {
	  s irp=children.GetAt(i)
	  s status=..RecurseExecuteChild(irp)
	  q:status'=$$$OK
	}
	q status
}

Method ExecuteChild(irp As InternalResolvedParser) As %Status
{
	;b ;ExecuteChild
	s status=$$$OK
	q:'irp.CanExecute() status
	q:irp.Status'=$$$OK irp.Status
	if (irp.IsRealTimeData()){
	  q $$$ERROR("children cql can't RealTimeQury")
	}elseif irp.IsFlow(){
	  q irp.FlowExecutor.Execute()
	}elseif irp.IsInnerJoin(){
	  q ..ExecuteInnerJoin(irp)
	}
	s startTime=$p($zts,",",2)
	d irp.GetFilterTargetBit()
	if ..Debug{
	  s endTime=$p($zts,",",2)
	  s dgind=^temp("PhysicalExecutor")
	  s ^temp(dgind,"PhysicalExecutor","ExecuteRoot:FilterTargetBit")=endTime-startTime
	}
	s status=irp.FilterParse2()
	q:status'=$$$OK status
	s isJoinRefed=irp.IsJoinRefed,ijChildren=""
	if isJoinRefed{
	  s ijChildren=irp.GetInnerJoinChildren()
	}
	if irp.FilterRootNode=""{
	  d ..GetAllWithNoFilter(irp)
	}else{
	  d irp.GetFilterTargetBit()
	  m segBitMap= irp.FilterRootNode.SegBitIndexMap
	  k ^||tempPartIdMap
	  s partInd="" f{
	    s partInd=$o(segBitMap(partInd))
	    q:partInd=""
	    f i=0:1:$g(segBitMap(partInd),0){
	      continue:'$d(segBitMap(partInd,i))
	      s bit=segBitMap(partInd,i)
	      s j=$bitfind(bit,1,1)
	      while(j>0){
	        s id=(i*..#MAXBITRANGE)+j
	        s ^||tempPartIdMap(partInd,id)=""
	        s j=$bitfind(bit,1,j+1)
	      }
	    }
	  }
	}
	
	;s debuget=$p($zts,",",2)
	;w "filter bit id spend time:"_(debuget-debugst),!
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	s pcubeDimMask=$g(irp.Parent.cubeDimsShowInd,"")
	m metricMap=irp.metricsShowInd
	m proFunStruct=irp.proFunStruct
	k metricSNStruct
	//precompute join dims for joining start
	k joinDimStruct
	s isJoinRefed=irp.IsJoinRefed
	if isJoinRefed{
	  ;b ;isJoinRefed
	  s ijChildren=irp.GetInnerJoinChildren()
	  f i=1:1:ijChildren.Count(){
		s ijChild=ijChildren.GetAt(i)
		s ijirp=ijChild.GetInnerJoinIRP()
		s ijSt=ijirp.GetJoinStruct(irp.ResultSetName,.joinStructDimMap)
		s ijPos=ijirp.GetJoinPosition(irp.ResultSetName)
		if ijPos=-1{
		  s status=$$$ERROR(irp.ResultSetName_" is not left or right of inner joining")
		  q
		}
		s ijChildMask=ijChild.GetComputedCube().Mask()
		;s joinDimStruct(ijChildMask,ijPos)=ijSt
		m joinDimStruct(ijChildMask,ijPos)=joinStructDimMap
	  }
	}
	q:status'=$$$OK status
	//precompute join dims for joining end
	;w irp.RefCube.ToString(),!
	;w irp.GetComputedCube().ToString(),!
	;zw showStruct
	;zw metricMap
	k ^||tempdimvc
	s part="" f {
	  s part=$o(^||tempPartIdMap(part))
	  q:part=""
	  s id="" f{
		s id=$o(^||tempPartIdMap(part,id))
		q:id=""
		;w "cid:"_id,!
		s row=^||TEMPCMPDCUBEDD(cubeMask,part,id)
		s drow=$lb()
		if (showStruct'=0){
		  s j="" f{
		    s j=$o(showStruct(j))
		    q:j=""
		    s srt=showStruct(j,"S")
		    s srtl=$ll(srt)
		    s cDim=$lg(row,$list(srt,3))
		    s $list(drow,j)=""
		    continue:cDim=""
		    if srtl<5{
		    }else{
			  if $d(^||tempdimvc(j,cDim)){
			    s cDim=^||tempdimvc(j,cDim)
			  }else{
				s cDim2=##class(DHCWL.DM.T.DimDStruct).GetValue(cDim,srt,j,.proFunStruct,"D")
			    s ^||tempdimvc(j,cDim)=cDim2
			    s cDim=cDim2
			  }
		    }
		    s $list(drow,j)=cDim
	      }
		}
	    s dimsStatus=0
	    if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
		  s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)
		  s dimsStatus=1
	    }else{
		  s cid=$i(^||TEMPCMPDCUBEDI(ccm,dimMask,0))
		  s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)=cid
		  ;b ;// choice inner join dims and id start
		  if isJoinRefed{
			;b ;child choice inner join dims
			s ijmask="" f{
			  s ijmask=$o(joinDimStruct(ijmask))
			  q:ijmask=""
			  s ijPos=$o(joinDimStruct(ijmask,""))
			  s ijDimList=$lb()
			  s ijDimCode="" f{
				s ijDimCode=$o(joinDimStruct(ijmask,ijPos,ijDimCode))
				q:ijDimCode=""
				s ijDimSn=joinDimStruct(ijmask,ijPos,ijDimCode,"SN")
				s ijDimPsn=joinDimStruct(ijmask,ijPos,ijDimCode,"PSN")
				s $list(ijDimList,ijDimSn)=$lg(drow,ijDimPsn)
			  }
			  if '$d(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList)){
				s i=$i(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos))
			  }
			  s ^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList,cid)=0
			}
		  }
		  // choice inner join dims and id end
	    }
	    //index build start
	    s segNum=cid \ ..#MAXBITRANGE
	    s segInInd=cid # ..#MAXBITRANGE
	    i segInInd=0 {
	      s segInInd=..#MAXBITRANGE
	      s segNum=segNum-1
	    }
	    if (dimsStatus=0){ //index data
	      s j="" f{
		    s j=$o(showStruct(j))
		    q:j=""
		    s srt=showStruct(j,"S")
		    s sn=$lg(srt,3)
		    s dimV=$lg(drow,j,"")
		    continue:dimV=""
		    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
	      }
	    }
	    //index build end
	    
	    //metric compute start
	    ;b ;12
	    s result=0
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:$d(metricMap(j,"DSN"))
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:metricSN'=""
		    }
		  }else{
		    s metricSN=$o(^||TEMPCMPDCUBEDD(cubeMask,part,id,0))
		  }
		  if metricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  s metricSNStruct(metricSN)=j
		  q:'$d(^||TEMPCMPDCUBEDD(cubeMask,part,id,metricSN))
		  if '$d(metricMap(j,"D")){
			s mlist=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),$lb(0,0))
			s mli=$lg(mlist,1)
		    s segMetricInd="" f{
			  s segMetricInd=$o(^||TEMPCMPDCUBEDD(cubeMask,part,id,metricSN,2,segMetricInd))
			  q:segMetricInd=""
			  s segMetricList=^||TEMPCMPDCUBEDD(cubeMask,part,id,metricSN,2,segMetricInd)
			  s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^||TEMPCMPDCUBEDD(cubeMask,part,id,metricSN,2,segMetricInd),$lb())
			  s mli=mli+1
		    }
		    s $list(mlist,1)=mli
		    s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mlist
		  }
	    }
	    //metric compute end
	    q:status'=$$$OK
	    if (dimsStatus=0){
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
		  ;s ^||TEMPCMPDCUBEDD(ccm,0,cid,metricSN,1)=0
	    }
	    ;b ;1
	    //window function dim group start
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:'$d(metricMap(j,"DSN"))
		  s pdrow=$lb(),pdrowi=0
		  s pdsi="" f{
			s pdsi=$o(metricMap(j,"DSN",pdsi))
			q:pdsi=""
			s dsn=metricMap(j,"DSN",pdsi)
			s pdrowi=pdrowi+1
			if dsn=0{
			  s $list(pdrow,pdrowi)=""
			}else{
			  s $list(pdrow,pdrowi)=$lg(drow,dsn,"")
			}
		  }
		  s partmask=metricMap(j,"D")
		  if '$d(^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)){
			s partRowId=$i(^||TEMPCMPDCUBEDI(ccm,partmask,0))
			s ^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)=partRowId
		  }else{
			s partRowId=^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)
		  }
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s winMetricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:winMetricSN'=""
		    }
		  }else{
		    s winMetricSN=$o(^||TEMPCMPDCUBEDD(cubeMask,part,id,0))
		  }
		  if winMetricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  ;s metricSNStruct(winMetricSN)=j
		  q:'$d(^||TEMPCMPDCUBEDD(cubeMask,part,id,winMetricSN))
		  s mlist=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),$lb(0,0))
		  s mli=$lg(mlist,1)
		  s segMetricInd="" f{
			s segMetricInd=$o(^||TEMPCMPDCUBEDD(cubeMask,part,id,winMetricSN,2,segMetricInd))
			q:segMetricInd=""
			s segMetricList=^||TEMPCMPDCUBEDD(cubeMask,part,id,winMetricSN,2,segMetricInd)
			s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^||TEMPCMPDCUBEDD(cubeMask,part,id,winMetricSN,2,segMetricInd),$lb())
			s mli=mli+1
		  }
		  s $list(mlist,1)=mli
		  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mlist
		  //window data belong main row
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j)=partmask
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j,partRowId)=""
		  
	    } //s j=$o(metricMap(j))
	    //window function dim group end
	    
	  }
	}
	k ^||tempdimvc
	i status'=$$$OK {
	  k ^||TEMPCMPDCUBEDD(ccm)
	  k ^||TEMPCMPDCUBEDI(ccm)
	  q status
	}
	k ^||TEMPCMPDCUBEDI(ccm,dimMask,0)
	//window agg computing start
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:'$d(metricMap(j,"DSN"))
	  s partmask=metricMap(j,"D")
	  k ^||TEMPCMPDCUBEDI(ccm,partmask,-1)
	  s funCall=irp.aggFunctionCallList.GetAt(j)
	  s fun=funCall.GetFunction()
	  s partRowId="" f{
	    s partRowId=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId))
	    q:partRowId=""
	    d fun.SetNewDim(0)
	    ;d fun.SetInteralResult(1)
	    s mli="" f{
		  s mli=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli))
		  q:mli=""
		  s wml=^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
		  d fun.Eval(wml)
	    }
	    d fun.SetNewDim(1)
		s result=fun.Eval()
		k ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2)
		s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0),1)=result
	  }
	}
	//window agg computing end
	
	s partInd="" f{
	  s partInd=$o(^||TEMPCMPDCUBEDD(ccm,partInd))
	  q:partInd=""
	  s cid="" // computed cube dim row id
	  f {
		s cid=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid))
		q:cid=""
		s metricSN=0 f{
		  s metricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN))
		  q:metricSN=""
		  ;s metricShowInd=metricSNStruct(metricSN)
		  s funCall=irp.aggFunctionCallList.GetAt(metricSN)
		  s fun=funCall.GetFunction()
		  d fun.SetNewDim(0)
		  ;d fun.SetInteralResult(1)
		  s mli="" f{
			s mli=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli))
			q:mli=""
			s segMetricList=^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
			;w "segMetricList:"_$lts(segMetricList),!
			d fun.Eval(segMetricList)
		  }
		  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,1)=0
		  d fun.SetNewDim(1)
		  s result=fun.Eval()
		  k ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2)
		  s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0),1)=result
		}
		s winMetricSN=0 f{
		  s winMetricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN))
		  q:winMetricSN=""
		  s winDimMask=^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN)
		  s winRowId="" f{
			s winRowId=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN,winRowId))
			q:winRowId=""
			if $d(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId)){
		      s result=$lg(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId,2,0),1)
		      ;if winDimMask=104 b ;2
		      s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,winMetricSN,2,0),1)=result
			}
			
		  }
		}
	  }
	}
	
	;zw ^||TEMPCMPDCUBEDD
	;zw ^||TEMPCMPDCUBEDI
	s irp.ExecutedLogs=irp.ExecutedLogs+1
	q status
}

// 废弃

Method ExecuteRoot(irp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	;b ;0
	if (irp.IsRealTimeData()){
	  ;b ;1
	  s rtirp=irp.GetRealTimeIRP()
	  q:rtirp="" $$$ERROR("Can't create RealTimeThemeIRP!")
	  s select=rtirp.DimSelect
	  i select="" s select=rtirp.MetricSelect else  s select=select_rtirp.MetricSelect
	  s fetchDS=rtirp.GetFetchDimStruct(),fetchMS=rtirp.GetFetchMetricStruct()
	  s httprequest=##class(%Net.HttpRequest).%New()
      s httprequest.Server="localhost"
      s httprequest.Port=8088
      d httprequest.InsertParam("themePath",irp.jsonExpStruct("FROM"))
      d httprequest.InsertParam("day",$zd($p($h,",",1),3))
      d httprequest.InsertParam("select",select)
      d httprequest.InsertParam("mask",rtirp.FetchCube.Mask())
      d httprequest.InsertParam("dimStruct",$lts(fetchDS))
      d httprequest.InsertParam("metricStruct",$lts(fetchMS))
      w "start request",!
      s status= httprequest.Post("/dm/theme/data/rtdcreate")
      if (status=$$$OK){
	    s response=httprequest.HttpResponse
	    s rstatus=response.Data.WriteLine()
	    i rstatus'="1"{
		   q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_rstatus) 
	    }
      }else{
	    q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_httprequest.HttpResponse.Data.WriteLine())
      }
      s irp.RefTheme=rtirp.FetchTheme
      s irp.RefCube=rtirp.FetchCube
      q ..ExecuteChild(irp)
	}
	s startTime=$p($zts,",",2)
	;b ;ExecuteRoot
	;s debugst=$p($zts,",",2)
	s status=irp.FilterParse()
	q:status'=$$$OK status
	d irp.GetFilterTargetBit()
	if ..Debug{
	  s endTime=$p($zts,",",2)
	  s dgind=^temp("PhysicalExecutor")
	  s ^temp(dgind,"PhysicalExecutor","ExecuteRoot:FilterTargetBit")=endTime-startTime
	}
	m segBitMap= irp.FilterRootNode.SegBitIndexMap
	;s idList=$lb(),idPartList=$lb(),len=0
	k ^||tempPartIdMap
	s partInd="" f{
	  s partInd=$o(segBitMap(partInd))
	  q:partInd=""
	  f i=0:1:$g(segBitMap(partInd),0){
	    continue:'$d(segBitMap(partInd,i))
	    s bit=segBitMap(partInd,i)
	    s j=$bitfind(bit,1,1)
	    while(j>0){
	      s id=(i*..#MAXBITRANGE)+j
	      s ^||tempPartIdMap(partInd,id)=""
	      ;s len=len+1
	      ;s $list(idList,len)=id
	      ;s $list(idPartList,len)=id # ..#MAXPARTIONNUM
	      s j=$bitfind(bit,1,j+1)
	    }
	  }
	}
	;s debuget=$p($zts,",",2)
	;w "filter bit id spend time:"_(debuget-debugst),!
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	m metricMap=irp.metricsShowInd
	k metricSNStruct
	;w irp.RefCube.ToString(),!
	;w irp.GetComputedCube().ToString(),!
	;zw showStruct
	;zw metricMap
	;w "cubeMask:"_cubeMask,!
	;w "idList:"_ $lts(idList),!
	;w $lts(idPartList),!
	k ^||tempdimvc
	s part="" f{
	  s part=$o(^||tempPartIdMap(part))
	  q:part=""
	  s id="" f{
		s id=$o(^||tempPartIdMap(part,id))
		q:id=""
		;w "id:"_id,!
		s row=^DHCWL.DM.T.CubeDStructD(cubeMask,part,id)
		s drow=$lb()
	    s j="" 
	    f{
		  s j=$o(showStruct(j))
		  q:j=""
		  s srt=showStruct(j,"S")
		  s srtl=$ll(srt)
		  s cDim=$lg(row,$list(srt,3))
		  s $list(drow,j)=""
		  continue:cDim=""
		  if srtl<5{
		  }else{
			if $d(^||tempdimvc(j,cDim)){
			  s cDim=^||tempdimvc(j,cDim)
			}else{
			  s cDim2=##class(DHCWL.DM.T.DimDStruct).GetValue(cDim,srt)
			  s ^||tempdimvc(j,cDim)=cDim2
			  s cDim=cDim2
			}
		  }
		  s $list(drow,j)=cDim
	    }
	    s dimsStatus=0
	    if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
		  s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)
		  s dimsStatus=1
	    }else{
		  s cid=$i(^||TEMPCMPDCUBEDI(ccm,dimMask,0))
		  s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)=cid
	    }
	    s segNum=cid \ ..#MAXBITRANGE
	    s segInInd=cid # ..#MAXBITRANGE
	    i segInInd=0 {
	      s segInInd=..#MAXBITRANGE
	      s segNum=segNum-1
	    }
	    if (dimsStatus=0){ //index data
	      f{
		    s j=$o(showStruct(j))
		    q:j=""
		    s srt=showStruct(j,"S")
		    s sn=$lg(srt,3)
		    s dimV=$lg(drow,j,"")
		    continue:dimV=""
		    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
	      }
	    }
	    s result=0
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:$d(metricMap(j,"DSN"))
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:metricSN'=""
		    }
		  }else{
		    s metricSN=$o(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,""))
		  }
		  if metricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  s metricSNStruct(j)=metricSN
		  q:'$d(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,1))
		  s maxMetricListSegNum=^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,1)
		  if '$d(metricMap(j,"D")){
		    ;s funCall=irp.aggFunctionCallList.GetAt(j)
		    ;s fun=funCall.GetFunction()
		    ;d fun.SetNewDim(0)
		    s segMetricInd="" f{
			  s segMetricInd=$o(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,2,segMetricInd))
			  q:segMetricInd=""
			  s segMetricList=^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,2,segMetricInd)
			  ;b ;00
			  ;d fun.Eval(segMetricList)
			  s mli=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),0)
			  s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,2,segMetricInd),$lb())
	          s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli,0)=$g(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,metricSN,2,segMetricInd,0),0)
	          s mli=mli+1
	          s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mli
		    }
		    ;d fun.SetNewDim(1)
		    ;s result=fun.Eval()
		  }
		  /*s mli=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),0)
	      s mll=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli,0),0)
	      s mll=mll+1
	      try{
		    s $list(^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli),mll)=result
	      }catch(e){
		    s mli=mli+1
		    s mll=1
		    s $list(^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli),mll)=result
	      }
	      s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mli
	      s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli,0)=mll
	      */
	      
	    }
	    q:status'=$$$OK
	    if (dimsStatus=0){
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
		  ;s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=0
	    }
	    //window function dim group start
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:'$d(metricMap(j,"DSN"))
		  s pdrow=$lb(),pdrowi=0
		  s pdsi="" f{
			s pdsi=$o(metricMap(j,"DSN",pdsi))
			q:pdsi=""
			s dsn=metricMap(j,"DSN",pdsi)
			s pdrowi=pdrowi+1
			if dsn=0{
			  s $list(pdrow,pdrowi)=""
			}else{
			  s $list(pdrow,pdrowi)=$lg(drow,dsn,"")
			}
			
		  }
		  s partmask=metricMap(j,"D")
		  if '$d(^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)){
			s partRowId=$i(^||TEMPCMPDCUBEDI(ccm,partmask,0))
			s ^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)=partRowId
		  }else{
			s partRowId=^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)
		  }
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s winMetricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:winMetricSN'=""
		    }
		  }else{
		    s winMetricSN=$o(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,""))
		  }
		  if winMetricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  s metricSNStruct(j)=winMetricSN
		  q:'$d(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,winMetricSN,1))
		  ;s funCall=irp.aggFunctionCallList.GetAt(j)
		  ;s fun=funCall.GetFunction()
		  ;d fun.SetNewDim(0)
		  s segMetricInd="" f{
			s segMetricInd=$o(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,winMetricSN,2,segMetricInd))
			q:segMetricInd=""
			;s segMetricList=^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,winMetricSN,2,segMetricInd)
			;d fun.Eval(segMetricList)
			s mli=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),0)
			s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,winMetricSN,2,segMetricInd),$lb())
			s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli,0)=$g(^DHCWL.DM.T.CubeDStructD(cubeMask,part,id,winMetricSN,2,segMetricInd,0),0)
			s mli=mli+1
			s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mli
		  }
		  ;d fun.SetNewDim(1)
		  ;s result=fun.Eval()
		  //window data belong main row
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j)=partmask
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j,partRowId)=""
		  
		  /*s mli=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),0)
	      s mll=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli,0),0)
	      s mll=mll+1
	      try{
		    s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli),mll)=result
	      }catch(e){
		    s mli=mli+1
		    s mll=1
		    s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli),mll)=result
	      }
	      s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mli
	      s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli,0)=mll*/
	    } //s j=$o(metricMap(j))
	    //window function dim group end
	  } //s id=$o(^||tempPartIdMap(part,id))
	} //s part=$o(^||tempPartIdMap(part))
	if ..Debug{
	  s endTime2=$p($zts,",",2)
	  s dgind=^temp("PhysicalExecutor")
	  s ^temp(dgind,"PhysicalExecutor","ExecuteRoot:GroupFSum")=endTime2-endTime
	}
	k ^||tempdimvc
	i status'=$$$OK {
	  k ^||TEMPCMPDCUBEDD(ccm)
	  k ^||TEMPCMPDCUBEDI(ccm)
	  q status
	}
	k ^||TEMPCMPDCUBEDI(ccm,dimMask,0)
	//window agg computing start
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:'$d(metricMap(j,"DSN"))
	  s partmask=metricMap(j,"D")
	  k ^||TEMPCMPDCUBEDI(ccm,partmask,-1)
	  s funCall=irp.aggFunctionCallList.GetAt(j)
	  s fun=funCall.GetFunction()
	  s partRowId="" f{
	    s partRowId=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId))
	    q:partRowId=""
	    d fun.SetNewDim(0)
	    ;d fun.SetInteralResult(1)
	    s mli="" f{
		  s mli=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli))
		  q:mli=""
		  s wml=^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
		  d fun.Eval(wml)
		  k ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
	    }
	    d fun.SetNewDim(1)
		s result=fun.Eval()
		s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0),1)=result
		s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0,0)=1
	  }
	}
	//window agg computing end
	
	s partInd="" f{
	  s partInd=$o(^||TEMPCMPDCUBEDD(ccm,partInd))
	  q:partInd=""
	  s cid="" // computed cube dim row id
	  f {
		s cid=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid))
		q:cid=""
		s metricSN=0 f{
		  s metricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN))
		  q:metricSN=""
		  ;continue:'$g(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN),0)
		  ;s metricShowInd=metricSNStruct(metricSN)
		  s funCall=irp.aggFunctionCallList.GetAt(metricSN)
		  s fun=funCall.GetFunction()
		  d fun.SetNewDim(0)
		  ;d fun.SetInteralResult(1)
		  s mli="" f{
			s mli=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli))
			q:mli=""
			s segMetricList=^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
			;w "segMetricList:"_$lts(segMetricList),!
			d fun.Eval(segMetricList)
			k ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
		  }
		  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,1)=0
		  d fun.SetNewDim(1)
		  s result=fun.Eval()
		  s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0),1)=result
		  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0,0)=1
		}
		s winMetricSN=0 f{
		  s winMetricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN))
		  q:winMetricSN=""
		  s winDimMask=^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN)
		  s winRowId="" f{
			s winRowId=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN,winRowId))
			q:winRowId=""
			if $d(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId)){
		      s result=$lg(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId,2,0),1)
		      ;if winDimMask=104 b ;2
		      s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,winMetricSN,2,0),1)=result
			}
			
		  }
		}
	  }
	}
	
	if ..Debug{
	  s endTime3=$p($zts,",",2)
	  s dgind=^temp("PhysicalExecutor")
	  s ^temp(dgind,"PhysicalExecutor","ExecuteRoot:AllSum")=endTime3-endTime2
	}
	
	
	;zw ^||TEMPCMPDCUBEDD
	;zw ^||TEMPCMPDCUBEDI
	q status
}

// 暂且废弃

Method ExecuteRoot2(irp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	q:'irp.CanExecute() status
	if (irp.IsRealTimeData()){
	  s rtirp=irp.GetRealTimeIRP()
	  q:rtirp="" $$$ERROR("Can't create RealTimeThemeIRP!")
	  s select=rtirp.DimSelect
	  i select="" s select=rtirp.MetricSelect
	  else  s select=select_","_rtirp.MetricSelect
	  s fetchDS=rtirp.GetFetchDimStruct(),fetchMS=rtirp.GetFetchMetricStruct()
	  s httprequest=##class(%Net.HttpRequest).%New()
      s httprequest.Server="localhost"
      s httprequest.Port=8088
      s httprequest.Timeout=60*10  ;10 min
      s dimMask=irp.dimsShowInd
      s day=$g(irp.jsonExpStruct("DAY"),$zd($p($h,",",1),3))
      ;s:day="" day=$zd($p($h,",",1),3)
      d httprequest.InsertParam("themePath",irp.jsonExpStruct("FROM"))
      d httprequest.InsertParam("day",day) ;
      d httprequest.InsertParam("select",select)
      d httprequest.InsertParam("mask",irp.GetComputedCube().Mask())
      d httprequest.InsertParam("dimStruct",$lts(fetchDS))
      d httprequest.InsertParam("metricStruct",$lts(fetchMS))
      d httprequest.InsertParam("dimMask",dimMask)
      
      
      w "start request",!
      s requestUrl="/dm/theme/data/rtdcreate?themePath="_irp.jsonExpStruct("FROM")_"&day="_day_"&select="_select_"&mask="_rtirp.FetchCube.Mask()_"&dimStruct="_$lts(fetchDS)_"&metricStruct="_$lts(fetchMS)_"&dimMask="_dimMask
      w "requestUrl:"_requestUrl,!
      s status= httprequest.Get("/dm/theme/data/rtdcreate",2)
      ;b ;ExecuteRoot2
      if (status=$$$OK){
	    s response=httprequest.HttpResponse
	    s rstatus=response.Data.ReadLine()
	    i rstatus'="1"{
		  q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_rstatus) 
	    }else{
		  q status
	    }
      }else{
	    q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_httprequest.HttpResponse.Data.WriteLine())
      }
	}elseif irp.IsInnerJoin(){
	  q ..ExecuteInnerJoin(irp)
	}
	s dataLog=##class(DHCWL.DM.T.DataLog).StartLog("PEHQ",irp.jsonExpStruct("FROM")) //PhysicalExecutor History Query
	s status=irp.FilterParse2()
	q:status'=$$$OK status
	if irp.FilterRootNode=""{
	  k ^||tempPartIdMap
	  d ..GetRootAllWithNoFilter(irp)
	}else{
	  d irp.GetFilterTargetBit()
	  m segBitMap= irp.FilterRootNode.SegBitIndexMap
	  k ^||tempPartIdMap
	  s re=$sortbegin(^||tempPartIdMap)
	  s partInd="" f{
	    s partInd=$o(segBitMap(partInd))
	    q:partInd=""
	    f i=0:1:$g(segBitMap(partInd),0){
	      continue:'$d(segBitMap(partInd,i))
	      s bit=segBitMap(partInd,i)
	      s j=$bitfind(bit,1,1)
	      while(j>0){
	        s id=(i*..#MAXBITRANGE)+j
	        s ^||tempPartIdMap(partInd,id)=""
	        s j=$bitfind(bit,1,j+1)
	      }
	    }
	  }
	  s re=$sortend(^||tempPartIdMap)
	}
	
	
	;job ##class(MulProPhyExecutor).RootExecutor(1,irp,.cubeIdMap)
	;d ##class(MulProPhyExecutor).RootExecutor(2,irp,.cubeIdMap)
	;s idList=$lb(),idPartList=$lb(),len=0
	
	;s debuget=$p($zts,",",2)
	;w "filter bit id spend time:"_(debuget-debugst),!
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	m metricMap=irp.metricsShowInd
	m proFunStruct=irp.proFunStruct
	m sortStruct=irp.sortStructMap
	k metricSNStruct
	//precompute join dims for joining start
	k joinDimStruct
	s isJoinRefed=irp.IsJoinRefed
	d dataLog.Touch("Filter")
	if isJoinRefed{
	  ;b ;isJoinRefed
	  s ijChildren=irp.GetInnerJoinChildren()
	  f i=1:1:ijChildren.Count(){
		s ijChild=ijChildren.GetAt(i)
		s ijirp=ijChild.GetInnerJoinIRP()
		s ijSt=ijirp.GetJoinStruct(irp.ResultSetName,.joinStructDimMap)
		s ijPos=ijirp.GetJoinPosition(irp.ResultSetName)
		if ijPos=-1{
		  s status=$$$ERROR(irp.ResultSetName_" is not left or right of inner joining")
		  q
		}
		s ijChildMask=ijChild.GetComputedCube().Mask()
		;s joinDimStruct(ijChildMask,ijPos)=ijSt
		m joinDimStruct(ijChildMask,ijPos)=joinStructDimMap
	  }
	}
	q:status'=$$$OK status
	//precompute join dims for joining end
	;w irp.RefCube.ToString(),!
	;w irp.GetComputedCube().ToString(),!
	;zw showStruct
	;zw metricMap
	;w "cubeMask:"_cubeMask,!
	;w "idList:"_ $lts(idList),!
	;w $lts(idPartList),!
	k ^||tempdimvc
	s part="" f{
	  s part=$o(^||tempPartIdMap(part))
	  q:part=""
	  s id="" f{
		s id=$o(^||tempPartIdMap(part,id))
		q:id=""
		;w "id:"_id,!
		s row=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
		s drow=$lb()
	    s j="" 
	    //start build computed cube dims
	    f{
		  s j=$o(showStruct(j))
		  q:j=""
		  s srt=showStruct(j,"S")
		  s dtype="" //showStruct(j,"T")
		  s srtl=$ll(srt)
		  s cDim=$lg(row,$list(srt,3))
		  s $list(drow,j)=""
		  continue:cDim=""
		  if srtl<5{
		  }else{
			if $d(^||tempdimvc(j,cDim)){
			  s cDim=^||tempdimvc(j,cDim)
			}else{
			  ;b ;DHCWL.DM.T.DimDStruct).GetValue
			  //not relation dim resolve
			  if (dtype'="R"){
				s cDim2=##class(DHCWL.DM.T.DimDStruct).GetValue(cDim,srt,j,.proFunStruct,"D")
			  }else{//relation dim resolve
				  
			  }
			  s ^||tempdimvc(j,cDim)=cDim2
			  s cDim=cDim2
			}
		  }
		  s $list(drow,j)=cDim
	    }
	    //end build computed cube dims
	    s dimsStatus=0
	    if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
		  s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)
		  s dimsStatus=1
	    }else{
		  s cid=$g(^||TEMPCMPDCUBEDI(ccm,dimMask,0),0)+1
		  s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid
		  s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)=cid
		 
		  // choice inner join dims and id start
		  if isJoinRefed{
			;b ;choice inner join dims
			s ijmask="" f{
			  s ijmask=$o(joinDimStruct(ijmask))
			  q:ijmask=""
			  s ijPos=$o(joinDimStruct(ijmask,""))
			  s ijDimList=$lb()
			  s ijDimCode="" f{
				s ijDimCode=$o(joinDimStruct(ijmask,ijPos,ijDimCode))
				q:ijDimCode=""
				s ijDimSn=joinDimStruct(ijmask,ijPos,ijDimCode,"SN")
				s ijDimPsn=joinDimStruct(ijmask,ijPos,ijDimCode,"PSN")
				s $list(ijDimList,ijDimSn)=$lg(drow,ijDimPsn)
			  }
			  if '$d(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList)){
				s i=$i(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos))
			  }
			  s ^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList,cid)=0
			}
		  }
		  // choice inner join dims and id end
	    }
	    //index build start
	    s segNum=cid \ ..#MAXBITRANGE
	    s segInInd=cid # ..#MAXBITRANGE
	    i segInInd=0 {
	      s segInInd=..#MAXBITRANGE
	      s segNum=segNum-1
	    }
	    if (dimsStatus=0){ //index data
	      f{
		    s j=$o(showStruct(j))
		    q:j=""
		    s srt=showStruct(j,"S")
		    s sn=$lg(srt,3)
		    s dimV=$lg(drow,j,"")
		    continue:dimV=""
		    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
	      }
	    }
	    //index build end
	    //metric compute start
	    s result=0
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:$d(metricMap(j,"DSN"))
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:metricSN'=""
		    }
		  }else{
		    s metricSN=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,0))
		  }
		  if metricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  s metricSNStruct(j)=metricSN
		  q:'$d(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN))
		  //s maxMetricListSegNum=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN,1)
		  if '$d(metricMap(j,"D")){
		    //m ^||TEMPCMPDCUBEDD(ccm,0,cid,j)=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN)
		    s mlist=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),$lb(0,0))
		    s mli=$lg(mlist,1)
		    s segMetricInd="" f{
			  s segMetricInd=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd))
			  q:segMetricInd=""
			  s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd),$lb())
	          //s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli,0)=$g(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN,2,segMetricInd,0),0)
	          s mli=mli+1
		    }
		    s $list(mlist,1)=mli
		    s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mlist
		  }
	    }
	    //metric compute end
	    q:status'=$$$OK
	    if (dimsStatus=0){
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
		  ;s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=0
	    }
	    //window function dim group start
	    s j="" f{
		  s j=$o(metricMap(j))
		  q:j=""
		  continue:'$d(metricMap(j,"DSN"))
		  s pdrow=$lb(),pdrowi=0
		  s pdsi="" f{
			s pdsi=$o(metricMap(j,"DSN",pdsi))
			q:pdsi=""
			s dsn=metricMap(j,"DSN",pdsi)
			s pdrowi=pdrowi+1
			if dsn=0{
			  s $list(pdrow,pdrowi)=""
			}else{
			  s $list(pdrow,pdrowi)=$lg(drow,dsn,"")
			}
			
		  }
		  s partmask=metricMap(j,"D")
		  if '$d(^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)){
			s partRowId=$i(^||TEMPCMPDCUBEDI(ccm,partmask,0))
			s ^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)=partRowId
		  }else{
			s partRowId=^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)
		  }
		  if $d(metricMap(j,"P")){
		    s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s winMetricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:winMetricSN'=""
		    }
		  }else{
		    s winMetricSN=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,0))
		  }
		  if winMetricSN=""{
		    s status=$$$ERROR("Can't get metric serial number")
		    q
		  }
		  s metricSNStruct(j)=winMetricSN
		  q:'$d(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN))
		  s mlist=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),$lb(0,0))
		  s mli=$lg(mlist,1)
		  s segMetricInd="" f{
			s segMetricInd=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd))
			q:segMetricInd=""
			s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
			;s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli,0)=$g(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,winMetricSN,2,segMetricInd,0),0)
			s mli=mli+1
			;s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mli
		  }
		  s $list(mlist,1)=mli
		  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mlist
		  //window data belong main row
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j)=partmask
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j,partRowId)=""
	    } //s j=$o(metricMap(j))
	    //window function dim group end
	  } //s id=$o(^||tempPartIdMap(part,id))
	} //s part=$o(^||tempPartIdMap(part))
	d dataLog.Touch("Group")
	k ^||tempdimvc
	i status'=$$$OK {
	  k ^||TEMPCMPDCUBEDD(ccm)
	  k ^||TEMPCMPDCUBEDI(ccm)
	  q status
	}
	k ^||TEMPCMPDCUBEDI(ccm,dimMask,0)
	//window agg computing start
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:'$d(metricMap(j,"DSN"))
	  s partmask=metricMap(j,"D")
	  k ^||TEMPCMPDCUBEDI(ccm,partmask,-1)
	  s funCall=irp.aggFunctionCallList.GetAt(j)
	  s fun=funCall.GetFunction()
	  s partRowId="" f{
	    s partRowId=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId))
	    q:partRowId=""
	    d fun.SetNewDim(0)
	    ;d fun.SetInteralResult(1)
	    s mli="" f{
		  s mli=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli))
		  q:mli=""
		  s wml=^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
		  d fun.Eval(wml)
	    }
	    d fun.SetNewDim(1)
		s result=fun.Eval()
		k ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2)
		s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0),1)=result
	  }
	}
	//window agg computing end
	//metric agg start
	s partInd="" f{
	  s partInd=$o(^||TEMPCMPDCUBEDD(ccm,partInd))
	  q:partInd=""
	  s cid="" // computed cube dim row id
	  f {
		s cid=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid))
		q:cid=""
		s metricSN=0 f{
		  s metricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN))
		  q:metricSN=""
		  ;continue:'$g(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN),0)
		  ;s metricShowInd=metricSNStruct(metricSN)
		  s funCall=irp.aggFunctionCallList.GetAt(metricSN)
		  s fun=funCall.GetFunction()
		  d fun.SetNewDim(0)
		  ;d fun.SetInteralResult(1)
		  s mli="" f{
			s mli=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli))
			q:mli=""
			s segMetricList=^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
			;w "segMetricList:"_$lts(segMetricList),!
			d fun.Eval(segMetricList)
		  }
		  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,1)=0
		  d fun.SetNewDim(1)
		  s result=fun.Eval()
		  k ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2)
		  s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0),1)=result
		}
		s winMetricSN=0 f{
		  s winMetricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN))
		  q:winMetricSN=""
		  s winDimMask=^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN)
		  s winRowId="" f{
			s winRowId=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN,winRowId))
			q:winRowId=""
			if $d(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId)){
		      s result=$lg(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId,2,0),1)
		      ;if winDimMask=104 b ;2
		      s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,winMetricSN,2,0),1)=result
			}
			
		  }
		}
		//sort resolve start add at 20170926
		s drow=^||TEMPCMPDCUBEDD(ccm,partInd,cid)
		s sindex="" f{
		  s sindex=$o(sortStruct(1,sindex))
		  q:sindex=""
		  s lb=$lb()
		  s ft=sortStruct(1,sindex,"FT")
		  s fi=sortStruct(1,sindex,"FI")
		  if ft="D"{
			s sdim=$lg(drow,fi,$char(-1))
		  }else{
			s sdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi,2,0),1,0) //metric
		  }
		  s sindex2=$o(sortStruct(1,sindex))
		  if sindex2'=""{
		    s fi2=sortStruct(1,sindex2,"FI")
		    s ft2=sortStruct(1,sindex2,"FT")
		    if ft2="D"{
			  s nsdim=$lg(drow,fi2,$char(-1))
		    }else{
			  s nsdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi2,2,0),1,0) //metric
		    }
			s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
			s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,1,nsdim)=sindex2
		  }else{
			s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
		  }
		  s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0))
		}
		//sort resolve end
	  }
	}
	//metric agg end
	//sort resolve again start add at 20170927
	d ..SortResolve(.sortStruct,ccm)
	//sort resolve again end
	d dataLog.CommitLog("F",irp.GetCQLExpression())
	
	s irp.ExecutedLogs=irp.ExecutedLogs+1
	
	;zw ^||TEMPCMPDCUBEDD
	;zw ^||TEMPCMPDCUBEDI
	q status
}

// 适用于数据结构1

Method ExecuteRoot3(irp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	q:'irp.CanExecute() status
	if (irp.IsRealTimeData()){
	  s rtirp=irp.GetRealTimeIRP()
	  q:rtirp="" $$$ERROR("Can't create RealTimeThemeIRP!")
	  s select=rtirp.DimSelect
	  i select="" s select=rtirp.MetricSelect
	  else  s select=select_","_rtirp.MetricSelect
	  s fetchDS=rtirp.GetFetchDimStruct(),fetchMS=rtirp.GetFetchMetricStruct()
	  s httprequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
      s dimMask=irp.dimsShowInd
      s day=$g(irp.jsonExpStruct("DAY"),$zd($p($h,",",1),3))
      ;s:day="" day=$zd($p($h,",",1),3)
      d httprequest.InsertParam("themePath",irp.jsonExpStruct("FROM"))
      d httprequest.InsertParam("day",day) ;
      d httprequest.InsertParam("select",select)
      d httprequest.InsertParam("mask",irp.GetComputedCube().Mask())
      d httprequest.InsertParam("dimStruct",$lts(fetchDS))
      d httprequest.InsertParam("metricStruct",$lts(fetchMS))
      d httprequest.InsertParam("dimMask",dimMask)
      
      
      w "start request",!
      s requestUrl="/dm/theme/data/rtdcreate?themePath="_irp.jsonExpStruct("FROM")_"&day="_day_"&select="_select_"&mask="_rtirp.FetchCube.Mask()_"&dimStruct="_$lts(fetchDS)_"&metricStruct="_$lts(fetchMS)_"&dimMask="_dimMask
      w "requestUrl:"_requestUrl,!
      s status= httprequest.Get("/dm/theme/data/rtdcreate",2)
      ;b ;ExecuteRoot2
      if (status=$$$OK){
	    s response=httprequest.HttpResponse
	    s rstatus=response.Data.ReadLine()
	    i rstatus'="1"{
		  q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_rstatus) 
	    }else{
		  q status
	    }
      }else{
	    q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_httprequest.HttpResponse.Data.WriteLine())
      }
	}elseif irp.IsInnerJoin(){
	  q ..ExecuteInnerJoin(irp)
	}
	s dataLog=##class(DHCWL.DM.T.DataLog).StartLog("PEHQ",irp.jsonExpStruct("FROM")) //PhysicalExecutor History Query
	
	k ^||tempcfrdind // temp Cube Filter RelationDimvaule INDex
	b ;1
	s status=irp.FilterParse2()
	q:status'=$$$OK status
	//TODO 20181022根据statisticWayExpression获取目标Part
	if irp.FilterRootNode=""{
	  k ^||tempPartIdMap
	  d ..GetRootAllWithNoFilter(irp)
	}else{
	  d irp.GetFilterTargetBit()
	  m segBitMap= irp.FilterRootNode.SegBitIndexMap
	  k ^||tempPartIdMap
	  s re=$sortbegin(^||tempPartIdMap),rowcount=0
	  s partInd="" f{
	    s partInd=$o(segBitMap(partInd))
	    q:partInd=""
	    f i=0:1:$g(segBitMap(partInd),0){
	      continue:'$d(segBitMap(partInd,i))
	      s bit=segBitMap(partInd,i)
	      s j=$bitfind(bit,1,1)
	      while(j>0){
	        s id=(i*..#MAXBITRANGE)+j
	        s ^||tempPartIdMap(partInd,id)=""
	        s j=$bitfind(bit,1,j+1),rowcount=rowcount+1
	      }
	    }
	  }
	  s re=$sortend(^||tempPartIdMap)
		d dataLog.Touch("RowCount:"_rowcount,0)
	}
	
	
	;job ##class(MulProPhyExecutor).RootExecutor(1,irp,.cubeIdMap)
	;d ##class(MulProPhyExecutor).RootExecutor(2,irp,.cubeIdMap)
	;s idList=$lb(),idPartList=$lb(),len=0
	
	;s debuget=$p($zts,",",2)
	;w "filter bit id spend time:"_(debuget-debugst),!
	d dataLog.Touch("Filter")
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	m metricMap=irp.metricsShowInd
	m proFunStruct=irp.proFunStruct
	m sortStruct=irp.sortStructMap
	k metricSNStruct
	//precompute join dims for joining start
	k joinDimStruct
	s isJoinRefed=irp.IsJoinRefed
	s hasSortFlag=irp.HasSortFlag
	s hasMetricDetailSort=irp.MetricDitailInSortFlag
	/*if isJoinRefed{
	  ;b ;isJoinRefed
	  s ijChildren=irp.GetInnerJoinChildren()
	  f i=1:1:ijChildren.Count(){
		s ijChild=ijChildren.GetAt(i)
		s ijirp=ijChild.GetInnerJoinIRP()
		s ijSt=ijirp.GetJoinStruct(irp.ResultSetName,.joinStructDimMap)
		s ijPos=ijirp.GetJoinPosition(irp.ResultSetName)
		if ijPos=-1{
		  s status=$$$ERROR(irp.ResultSetName_" is not left or right of inner joining")
		  q
		}
		s ijChildMask=ijChild.GetComputedCube().Mask()
		;s joinDimStruct(ijChildMask,ijPos)=ijSt
		m joinDimStruct(ijChildMask,ijPos)=joinStructDimMap
	  }
	}
	q:status'=$$$OK status
	*/
	//precompute join dims for joining end
	;w irp.RefCube.ToString(),!
	;w irp.GetComputedCube().ToString(),!
	;zw showStruct
	;zw metricMap
	;w "cubeMask:"_cubeMask,!
	;w "idList:"_ $lts(idList),!
	;w $lts(idPartList),!
	/*s pdsList=irp.parsedDimStuList
	k showStruct2
	s j="" f{
	  s j=$o(showStruct(j))
	  q:j=""
	  s pdstu=pdsList.GetAt(j)
	  if (pdstu.IsRelationDim()=1){
			if (pdstu.IsFunctionCall()=1){
		  	s showStruct2("RF",j)=""
			}else{
		  	s showStruct2("R",j)=pdstu.SN
			}
	  }else{
			if (0)&&(pdstu.IsFunctionCall()=1){
		  	s showStruct2("DF",j)=""
			}else{
		  	s showStruct2("D",j)=""
			}
	  }
	}
	
	k refdMetricInfo
	s j="" f{
		s j=$o(metricMap(j))
		q:j=""
		if $d(metricMap(j,"DSN")){
			if $d(metricMap(j,"P")){
				s pid="" f{
					s pid= $o(metricMap(j,"P",pid))
					q:pid=""
					continue:'$d(metricMap(j,"P",pid,"T"))
					s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
					s refdMetricInfo(metricSN)=""
					q:metricSN'=""
				}
			}elseif $d(metricMap(j,"M")){
				s metricSN=metricMap(j,"M")
				s refdMetricInfo(metricSN)=""
			}
		}else{
			if $d(metricMap(j,"P")){
				s pid="" f{
				  s pid= $o(metricMap(j,"P",pid))
				  q:pid=""
				  continue:'$d(metricMap(j,"P",pid,"T"))
				  s winMetricSN=$lg(metricMap(j,"P",pid,"S"),2)
				  s refdMetricInfo(winMetricSN)=""
				  q:winMetricSN'=""
				}
			}
		}
	}
	*/
	s status= ..ResolveDimAndMetric(irp)
	k ^||tempdimvc
	i status'=$$$OK {
	  k ^||TEMPCMPDCUBEDD(ccm)
	  k ^||TEMPCMPDCUBEDI(ccm)
	  q status
	}
	d dataLog.Touch("Group")
	k ^||TEMPCMPDCUBEDI(ccm,dimMask,0)
	//window agg computing start
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:'$d(metricMap(j,"DSN"))
	  s partmask=metricMap(j,"D")
	  k ^||TEMPCMPDCUBEDI(ccm,partmask,-1)
	  s funCall=irp.aggFunctionCallList.GetAt(j)
	  s fun=funCall.GetFunction()
	  s partRowId="" f{
	    s partRowId=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId))
	    q:partRowId=""
	    d fun.SetNewDim(0)
	    ;d fun.SetInteralResult(1)
	    s mli="" f{
		  s mli=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli))
		  q:mli=""
		  s wml=^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
		  d fun.Eval(wml)
	    }
	    d fun.SetNewDim(1)
			s result=fun.Eval()
			k ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2)
			s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0),1)=result
	  }
	}
	//window agg computing end
	//metric agg start
	s partInd="" f{
	  s partInd=$o(^||TEMPCMPDCUBEDD(ccm,partInd))
	  q:partInd=""
	  s cid="" // computed cube dim row id
	  f {
			s cid=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid))
			q:cid=""
			s metricSN=0 f{
			  s metricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN))
			  q:metricSN=""
			  if ('$d(metricMap(metricSN,"F"))){
					continue
			  }
			  ;continue:'$g(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN),0)
			  ;s metricShowInd=metricSNStruct(metricSN)
			  s funCall=irp.aggFunctionCallList.GetAt(metricSN)
			  s fun=funCall.GetFunction()
			  d fun.SetNewDim(0)
			  ;d fun.SetInteralResult(1)
			  s mli="" f{
					s mli=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli))
					q:mli=""
					s segMetricList=^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
					;w "segMetricList:"_$lts(segMetricList),!
					d fun.Eval(segMetricList)
			  }
			  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,1)=0
			  d fun.SetNewDim(1)
			  s result=fun.Eval()
			  k ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2)
			  s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0),1)=result
			}
			s winMetricSN=0 f{
			  s winMetricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN))
			  q:winMetricSN=""
			  s winDimMask=^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN)
			  s winRowId="" f{
					s winRowId=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN,winRowId))
					q:winRowId=""
					if $d(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId)){
				      s result=$lg(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId,2,0),1)
				      ;if winDimMask=104 b ;2
				      s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,winMetricSN,2,0),1)=result
					}
			  }
			}
		
			//sort resolve start add at 20170926
			s drow=^||TEMPCMPDCUBEDD(ccm,partInd,cid)
			if (hasSortFlag=1)&&(hasMetricDetailSort=0){
				s sindex="" f{
				  s sindex=$o(sortStruct(1,sindex))
				  q:sindex=""
				  s ft=sortStruct(1,sindex,"FT")
				  s fi=sortStruct(1,sindex,"FI")
				  if ft="D"{
						s sdim=$lg(drow,fi,$char(-1))
						s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0))
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
				  }else{
						s sdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi,2,0),1,0) //metric
						s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0))
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
				  }
				  s sindex2=$o(sortStruct(1,sindex))
				  if sindex2'=""{
				    s fi2=sortStruct(1,sindex2,"FI")
				    s ft2=sortStruct(1,sindex2,"FT")
				    if ft2="D"{
					  	s nsdim=$lg(drow,fi2,$char(-1))
				    }else{
					  	s nsdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi2,2,0),1,0) //metric
				    }
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,1,nsdim,partInd,cid)=""
				  }
				}
			}
			//sort resolve end
	  }
	}
	//metric agg end
	d dataLog.Touch("AGG")
	//sort resolve again start add at 20170927
	if (hasSortFlag=1)&&(hasMetricDetailSort=0){
		d ..SortResolve(.sortStruct,ccm)
	}
	//sort resolve again end
	d dataLog.Touch("Sort")
	d dataLog.CommitLog("F","Cube:"_cubeMask_";Filter:"_irp.jsonExpStruct("FILTER"))
	
	s irp.ExecutedLogs=irp.ExecutedLogs+1
	
	;zw ^||TEMPCMPDCUBEDD
	;zw ^||TEMPCMPDCUBEDI
	q status
}

ClassMethod ResolveDimAndMetric(ByRef irp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	m metricMap=irp.metricsShowInd
	m proFunStruct=irp.proFunStruct
	m sortStruct=irp.sortStructMap
	k metricSNStruct
	s pdsList=irp.parsedDimStuList
	//precompute join dims for joining start
	k joinDimStruct
	s isJoinRefed=irp.IsJoinRefed
	s hasSortFlag=irp.HasSortFlag
	s hasMetricDetailSort=irp.MetricDitailInSortFlag
	if isJoinRefed{
	  s ijChildren=irp.GetInnerJoinChildren()
	  f i=1:1:ijChildren.Count(){
			s ijChild=ijChildren.GetAt(i)
			s ijirp=ijChild.GetInnerJoinIRP()
			s ijSt=ijirp.GetJoinStruct(irp.ResultSetName,.joinStructDimMap)
			s ijPos=ijirp.GetJoinPosition(irp.ResultSetName)
			if ijPos=-1{
			  s status=$$$ERROR(irp.ResultSetName_" is not left or right of inner joining")
			  q
			}
			s ijChildMask=ijChild.GetComputedCube().Mask()
			m joinDimStruct(ijChildMask,ijPos)=joinStructDimMap
	  }
	}
	q:status'=$$$OK status
	//precompute join dims for joining end
	s dimStructList=$lb(),rdimStructList=$lb(),rfdimStructList=$lb(),allDimStructList=$lb()
	s dimStructListLen=0,rdimStructListLen=0,rfdimStructListLen=0,allDimStructListLen=0
	s j="" f{
	  s j=$o(showStruct(j))
	  q:j=""
	  s pdstu=pdsList.GetAt(j)
	  if (pdstu.IsRelationDim()=1){
			if (pdstu.IsFunctionCall()=1){
		  	s rfdimStructListLen=rfdimStructListLen+1
		  	s $list(rfdimStructList,rfdimStructListLen)=$lb(j,pdstu.SN,pdstu)
			}else{
		  	s rdimStructListLen=rdimStructListLen+1
		  	s $list(rdimStructList,rdimStructListLen)=$lb(j,pdstu.SN)
			}
			s allDimStructListLen=allDimStructListLen+1
			s $list(allDimStructList,allDimStructListLen)=j
			s allDimStructListLen=allDimStructListLen+1
			s $list(allDimStructList,allDimStructListLen)=pdstu.SN
	  }else{
			if (0)&&(pdstu.IsFunctionCall()=1){
		  	s showStruct2("DF",j)=""
			}else{
				s dst=showStruct(j,"S")
		  	s dimStructListLen=dimStructListLen+1
		  	s $list(dimStructList,dimStructListLen)=$lb(j,$list(dst,3),$ll(dst),dst)
		  	s allDimStructListLen=allDimStructListLen+1
				s $list(allDimStructList,allDimStructListLen)=j
				s allDimStructListLen=allDimStructListLen+1
				s $list(allDimStructList,allDimStructListLen)=$list(dst,3)
			}
	  }
	}
	k refdMetricInfo
	s metricStructList=$lb(),winMetricStructList=$lb()
	s metricStructListLen=0,winMetricStructListLen=0
	s j="" f{
		s j=$o(metricMap(j))
		q:j=""
		if $d(metricMap(j,"DSN")){
			s pdsturow=$lb(),pdrowi=0
			s partmask=metricMap(j,"D")
			s pdsi="" f{
		    s pdsi=$o(metricMap(j,"DSN",pdsi))
		    q:pdsi=""
		    s dsn=metricMap(j,"DSN",pdsi)
		    s pdrowi=pdrowi+1
		    s $list(pdsturow,pdrowi)=dsn
			}
			if $d(metricMap(j,"P")){
				s pid="" f{
					s pid= $o(metricMap(j,"P",pid))
					q:pid=""
					continue:'$d(metricMap(j,"P",pid,"T"))
					s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
					s refdMetricInfo(metricSN)=""
					s winMetricStructListLen=winMetricStructListLen+1
					s $list(winMetricStructList,winMetricStructListLen)=$lb(j,metricSN,pdrowi,pdsturow,partmask)
				}
			}elseif $d(metricMap(j,"M")){
				s metricSN=metricMap(j,"M")
				s refdMetricInfo(metricSN)=""
				s winMetricStructListLen=winMetricStructListLen+1
				s $list(winMetricStructList,winMetricStructListLen)=$lb(j,metricSN,pdrowi,pdsturow,partmask)
			}else{
				s winMetricStructListLen=winMetricStructListLen+1
				s $list(winMetricStructList,winMetricStructListLen)=$lb(j,"",pdrowi,pdsturow,partmask)
			}
			
		}else{
			if $d(metricMap(j,"P")){
				s pid="" f{
				  s pid= $o(metricMap(j,"P",pid))
				  q:pid=""
				  continue:'$d(metricMap(j,"P",pid,"T"))
				  s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
				  s refdMetricInfo(metricSN)=""
				  s metricStructListLen=metricStructListLen+1
					s $list(metricStructList,metricStructListLen)=$lb(j,metricSN)
				}
			}elseif $d(metricMap(j,"M")){
				s metricSN=metricMap(j,"M")
				s refdMetricInfo(metricSN)=""
				s metricStructListLen=metricStructListLen+1
				s $list(metricStructList,metricStructListLen)=$lb(j,metricSN)
			}else{
				s metricStructListLen=metricStructListLen+1
				s $list(metricStructList,metricStructListLen)=$lb(j,"")
			}
		}
	}
	s emptyMetricCanRef=$o(refdMetricInfo(""))
	f i=1:1:metricStructListLen{
		s dsListObj=$list(metricStructList,i)
		s metricSN=$lg(dsListObj,2)
		s:metricSN="" metricSN=emptyMetricCanRef
		if metricSN=""{
			s status=$$$ERROR("Can't get metric serial number")
			q
		}
		s $list(dsListObj,2)=metricSN
		s $list(metricStructList,i)=dsListObj
	}
	q:status'=$$$OK status
	f i=1:1:winMetricStructListLen{
		s dsListObj=$list(winMetricStructList,i)
		s winMetricSN=$lg(dsListObj,2)
		s:winMetricSN="" winMetricSN=emptyMetricCanRef
		if winMetricSN=""{
			s status=$$$ERROR("Can't get metric serial number")
			q
		}
		s $list(dsListObj,2)=metricSN
		s $list(winMetricStructList,i)=dsListObj
	}
	q:status'=$$$OK status
	k ^||tempdimvc  //temp dim value cache
	k ^||temprmind  //temp index of relation dim for metric 
	k ^||tempcfrmind //temp Cube Filter Relationdimvaule for Metric INDex
	m ^||tempcfrmind=irp.FilterRootNode.RMBitIMap
	s hasRelaDimFilter=0
	s:$d(^||tempcfrmind) hasRelaDimFilter=1
	s onlyRelaDimFilter=0
	if (hasRelaDimFilter=1)&&(rfdimStructListLen=0)&&(rdimStructListLen=0){
		s onlyRelaDimFilter=1
	}
	s relationDimFlag=0
	s part="" f{
	  s part=$o(^||tempPartIdMap(part))
	  q:part=""
	  s id="" f{
			s id=$o(^||tempPartIdMap(part,id))
			q:id=""
			s row=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
			s drow=$lb()
			//dim resolve start
			f ij=1:1:dimStructListLen{
				s dsListObj=$list(dimStructList,ij)
				s j=$list(dsListObj,1)
				s srtl=$list(dsListObj,3)
				s srt=$list(dsListObj,4)
				s cDim=$lg(row,$list(srt,3),"NULL")
				s:cDim=$c(0) cDim= "NULL"
				s $list(drow,j)=cDim
				;b ;1
				if srtl>4{
					if $d(^||tempdimvc(j,cDim)){
						s $list(drow,j)=^||tempdimvc(j,cDim)
					}else{
						s cDim2=##class(DHCWL.DM.T.DimDStruct).GetValue(cDim,srt,j,.proFunStruct,"D")
						s ^||tempdimvc(j,cDim)=cDim2
						s $list(drow,j)=cDim2
					}
				}
				
			}
			//dim resolve end
			s relDimMetricFilterFlag=0
			if (rfdimStructListLen>0)||(rdimStructListLen>0){
				//relation dim function resolve start
				f ij=1:1:rfdimStructListLen{
					s dsListObj=$list(rfdimStructList,ij)
					s j=$list(dsListObj,1),relDimMetricFilterFlag=1
					s pdstu=pdsList.GetAt(j)
					k returnMap
					d ##class(DHCWL.DM.T.CubeDStruct).FetchDimFromFunCall(cubeMask,part,id,j,.row,.pdstu,.returnMap,.refdMetricInfo,hasRelaDimFilter)
					m returnListMap(j)=returnMap
				}
				//relation dim function resolve end
				//relation dim resolve start
				f ij=1:1:rdimStructListLen{
					s dsListObj=$list(rdimStructList,ij)
					s j=$list(dsListObj,1),relDimMetricFilterFlag=1
					s rsn=$list(dsListObj,2)
					s rsn2=-rsn
					s rind="" f{
					  s rind=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,rsn2,rind))
					  q:rind=""
						s retList=^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,rsn2,rind)
						if (hasRelaDimFilter){
							s retList2=$lb(),retList2Len=0,retListLen=$ll(retList)
							f retListInd=1:1:retListLen{
								s retListVal=$lg(retList,retListInd,$c(0))
								continue:'$d(^||tempcfrdind(part,cubeMask,id,retListVal))
								s retList2Len=retList2Len+1
								s $list(retList2,retList2Len)=retListVal
							}
							s retList=retList2
						}
						s returnListMap(j,rind)=retList
						//记录RelationDim对应的度量索引
						s retListLen=$ll(retList)
						f retListInd=1:1:retListLen{
							s rvalue=$lg(retList,retListInd,$c(0))
							if ($d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn,rvalue,id))){
							  s relDimMetricFilterFlag=1
							  s crdid=^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn,rvalue,id)
								s msn="" f{
									s msn=$o(refdMetricInfo(msn))
									q:msn=""
									continue:'$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdid))
									s rseg="" f{
									  s rseg=$o(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdid,rseg))
									  q:rseg=""
									  s rmetricbit=$g(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdid,rseg),"")
									  continue:rmetricbit=""
									  if (hasRelaDimFilter)&&($d(^||tempcfrmind(part,id))){
										  s filterMetBit=^||tempcfrmind(part,id,msn,rseg)
										  s:filterMetBit'="" rmetricbit=$bitlogic(filterMetBit & rmetricbit)
									  }
									  s prermetricbit=$g(^||temprmind(rvalue,msn,rseg),"")
									  if (prermetricbit=""){
											s ^||temprmind(j,rvalue,msn,rseg)=rmetricbit
									  }else{
											s ^||temprmind(j,rvalue,msn,rseg)=$bitlogic(prermetricbit | rmetricbit)
									  }
									}
								}
							}
						}
					}
				}
				//relation dim resolve end
				k visitListMapStatus
				s rdimInd="" f{
				  s rdimInd=$o(returnListMap(rdimInd))
				  q:rdimInd=""
				  s listseg=$o(returnListMap(rdimInd,""))
				  s visitListMapStatus(rdimInd)=listseg
				  s visitListMapStatus(rdimInd,0)=1
				  s visitListMapStatus(rdimInd,1)=$ll(returnListMap(rdimInd,listseg))
				}
				s runFlag=1
			  while(runFlag){
				  k metricIndBitInfo
			    s rdimInd="" f{
			      s rdimInd=$o(returnListMap(rdimInd))
			      q:rdimInd=""
			      s listseg=visitListMapStatus(rdimInd)
			      s listInd=visitListMapStatus(rdimInd,0)
			      s rdimv=$lg(returnListMap(rdimInd,listseg),listInd,$c(0))
			      s $list(drow,rdimInd)=rdimv
			      if $d(^||temprmind(rdimInd,rdimv)){
				      s r2msn="" f{
					      s r2msn=$o(^||temprmind(rdimInd,rdimv,r2msn))
					      q:r2msn=""
					      s rseg="" f{
						      s rseg=$o(^||temprmind(rdimInd,rdimv,r2msn,rseg))
						      q:rseg=""
						      if '$d(metricIndBitInfo(r2msn,rseg)){
							      s metricIndBitInfo(r2msn,rseg)=^||temprmind(rdimInd,rdimv,r2msn,rseg)
						      }else{
							      s metricIndBitInfo(r2msn,rseg)=$bitlogic(^||temprmind(rdimInd,rdimv,r2msn,rseg) &  metricIndBitInfo(r2msn,rseg))
						      }
					      }
				      }
			      }
			      s listInd=listInd+1
			      s visitListMapStatus(rdimInd,0)=listInd
			      if (listInd>visitListMapStatus(rdimInd,1) ){
					    s listInd=  $o(returnListMap(rdimInd,listInd))
					    s visitListMapStatus(rdimInd)=listInd
					    s:listInd="" runFlag=0
			      }
			    }
			    d resolveOneDimMetric
			    q:status'=$$$OK
			  }
			}else{
				d resolveOneDimMetric
				q:status'=$$$OK
			}
	  }
	  //s id="" f{
	}
	//s part="" f{
	q $$$OK
resolveOneDimMetric
		;w $lts(drow,",",1),!
		s dimsStatus=0,oneNum=0,addCubeRowIdFlag=0
		//*
		if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
			s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)
		}else{
			s cid=$g(^||TEMPCMPDCUBEDI(ccm,dimMask,0),0)+1
      s addCubeRowIdFlag=1
		}
		//*/
		/*
		//using bit index check dim row
		s indAndBitFlag=1,oneSeg=0,onePos=0
		k indAndBit
		s indAndBit=$lb()
		f ij=1:2:allDimStructListLen{
			s j=$list(allDimStructList,ij)
			s dimV=$lg(drow,j,$c(0))
			if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV)){
				k indBit
				m indBit=^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV)
				if (indAndBitFlag=1) {
					//m indAndBit=indBit
					s segInd2="" f  {
						s segInd2=$o(indBit(segInd2))
						q:segInd2=""
						s segInd3=segInd2+1
						s $list(indAndBit,segInd3)=indBit(segInd2)
					}
					s indAndBitFlag=0
				}else{
					s segInd2="" f  {
						s segInd2=$o(indBit(segInd2))
						q:segInd2=""
						s segInd3=segInd2+1
						s indAndbitv=$lg(indAndBit,segInd3,"")
						s $list(indAndBit,segInd3)=$bitlogic(indAndbitv & indBit(segInd2) )
					}
	      	s segBitFound=0
	      	f segInd=1:1:$ll(indAndBit){
		      	s indAndbitv=$lg(indAndBit,segInd,"")
		      	s onePos=$bitfind(indAndbitv,1)
		      	if onePos>0 {
			      	s segBitFound=segBitFound+1
			      	s oneSeg=segInd-1
		      	}
		      }
		      if segBitFound=0{
			      s dimsStatus=1
			      q
		      }
				}
			}else{
				s dimsStatus=1
				q
			}
		}
		;b:dimsStatus=0
		s onePos=0,oneSeg=0
		if (dimsStatus=0)  {
			f segInd=1:1:$ll(indAndBit){
			//s segInd="" f{
				//s segInd=$o(indAndBit(segInd))
				//q:segInd=""
				s indAndbitv=$lg(indAndBit,segInd,"")
				;q:indAndbitv=""
				s onePos2=$bitfind(indAndbitv,1)
				if onePos2>0 {
					s oneNum=oneNum+1,oneSeg=segInd-1,onePos=onePos2
				}
			}
		}
		if oneNum=1 { // if oneNum=1 $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
	  	s cid=(oneSeg*..#MAXBITRANGE)+onePos // (oneSeg*..#MAXBITRANGE)+onePos  ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow),dimsStatus=1
		}else{
    	s cid=$g(^||TEMPCMPDCUBEDI(ccm,dimMask,0),0)+1
      s addCubeRowIdFlag=1
		}
		*/
		//metric compute start
		s hasMetricValueFlag=0
		s:metricStructListLen=0 hasMetricValueFlag=1
		f ij=1:1:metricStructListLen{
			s dsListObj=$list(metricStructList,ij)
			s j=$list(dsListObj,1)
			s metricSN=$lg(dsListObj,2)
		  q:'$d(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN))
		  s mlist=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),$lb(0,0))
		  s mli=$lg(mlist,1)
		  ;k rowmetricmap
		  ;m rowmetricmap=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN)
		  s segMetricInd="" f{
			  s segMetricInd=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN,segMetricInd))
			  q:segMetricInd=""
			  if (relDimMetricFilterFlag=0){
				  s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN,segMetricInd),$lb())
				  s hasMetricValueFlag=1
				}elseif $d(metricIndBitInfo(metricSN,segMetricInd)){
					s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN,segMetricInd),$lb())
					s metricbit=metricIndBitInfo(metricSN,segMetricInd)
					s metricbitind=$bitfind(metricbit,1,1)
					s targmetriclist=$lb(),targmetriclistCnt=0
					while(metricbitind>0){
						s targmetriclistCnt=targmetriclistCnt+1
						s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
						s metricbitind=$bitfind(metricbit,1,metricbitind+1),hasMetricValueFlag=1
					}
					s:targmetriclistCnt>0 ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=targmetriclist
				}elseif (onlyRelaDimFilter=1){
					s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN,segMetricInd),$lb())
					s metricbit=^||tempcfrmind(part,cubeMask,id,metricSN,segMetricInd)
					s metricbitind=$bitfind(metricbit,1,1)
					s targmetriclist=$lb(),targmetriclistCnt=0
					while(metricbitind>0){
						s targmetriclistCnt=targmetriclistCnt+1
						s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
						s metricbitind=$bitfind(metricbit,1,metricbitind+1),hasMetricValueFlag=1
					}
					s:targmetriclistCnt>0 ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=targmetriclist
				}else{
					s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,metricSN,segMetricInd),$lb())
					s hasMetricValueFlag=1
				}
				s mli=mli+1
			}
			continue:hasMetricValueFlag=0
			s $list(mlist,1)=mli
			s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mlist
		}
		//metric compute end
		q:status'=$$$OK status
		//window function dim group start
		f ij=1:1:winMetricStructListLen{
			s dsListObj=$list(winMetricStructList,ij)
			s j=$list(dsListObj,1)
			s winMetricSN=$lg(dsListObj,2)
			s pdrowlen=$lg(dsListObj,3,0),pdrowstu=$lg(dsListObj,4),partmask=$lg(dsListObj,5)
			s pdrow=$lb(),pdrowi=0
			f pdrowi=1:1:pdrowlen{
				s dsn=$lg(pdrowstu,pdrowi,0)
				s $list(pdrow,pdrowi)=$lg(drow,dsn,"")
			}
			if '$d(^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)){
				s partRowId=$i(^||TEMPCMPDCUBEDI(ccm,partmask,0))
				s ^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)=partRowId
		  }else{
				s partRowId=^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)
	    }
	    q:'$d(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN))
		  s mlist=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),$lb(0,0))
		  s mli=$lg(mlist,1)
		  ;k rowmetricmap
		  ;m rowmetricmap=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,winMetricSN)
		  s segMetricInd="" f{
				s segMetricInd=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN,segMetricInd))
				q:segMetricInd=""
				if (relDimMetricFilterFlag=0){
				  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
				  s hasMetricValueFlag=1
				}elseif $d(metricIndBitInfo(winMetricSN,segMetricInd)){
				  s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
				  s metricbit=metricIndBitInfo(winMetricSN,segMetricInd)
				  s metricbitind=$bitfind(metricbit,1,1)
				  s targmetriclist=$lb(),targmetriclistCnt=0
			    while(metricbitind>0){
				    s targmetriclistCnt=targmetriclistCnt+1
				    s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
				    s metricbitind=$bitfind(metricbit,1,metricbitind+1),hasMetricValueFlag=1
			    }
			    s:targmetriclistCnt>0 ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=targmetriclist
				}elseif (onlyRelaDimFilter=1){
					s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
					s metricbit=^||tempcfrmind(part,cubeMask,id,winMetricSN,segMetricInd)
					s metricbitind=$bitfind(metricbit,1,1)
					s targmetriclist=$lb(),targmetriclistCnt=0
					while(metricbitind>0){
						s targmetriclistCnt=targmetriclistCnt+1
						s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
						s metricbitind=$bitfind(metricbit,1,metricbitind+1),hasMetricValueFlag=1
					}
					s:targmetriclistCnt>0 ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=targmetriclist
				}else{
				  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
				  s hasMetricValueFlag=1
				}
				s mli=mli+1
			}
			continue:hasMetricValueFlag=0
		  s $list(mlist,1)=mli
		  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mlist
		  //window data belong main row
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j)=partmask
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j,partRowId)=""
		}
		//window function dim group end
		if (hasMetricValueFlag=1){
			if (addCubeRowIdFlag=1){
				s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid
				s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)=cid
	      //index build start
			  s segNum=cid \ ..#MAXBITRANGE
			  s segInInd=cid # ..#MAXBITRANGE
			  i segInInd=0 {
				  s segInInd=..#MAXBITRANGE
				  s segNum=segNum-1
				}
			  f ij=1:2:allDimStructListLen{
					s j=$list(allDimStructList,ij)
			    s dimV=$lg(drow,j,$c(0))
			    s:dimV="" dimV=$c(0)
			    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
			  }
			  //index build end
			  // choice inner join dims and id start
	      if isJoinRefed{
			    s ijmask="" f{
					  s ijmask=$o(joinDimStruct(ijmask))
					  q:ijmask=""
					  s ijPos=$o(joinDimStruct(ijmask,""))
					  s ijDimList=$lb()
					  s ijDimCode="" f{
							s ijDimCode=$o(joinDimStruct(ijmask,ijPos,ijDimCode))
							q:ijDimCode=""
							s ijDimSn=joinDimStruct(ijmask,ijPos,ijDimCode,"SN")
							s ijDimPsn=joinDimStruct(ijmask,ijPos,ijDimCode,"PSN")
							s $list(ijDimList,ijDimSn)=$lg(drow,ijDimPsn)
					  }
					  if '$d(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList)){
							s i=$i(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos))
					  }
					  s ^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList,cid)=0
					}
			  }
			  // choice inner join dims and id end
			  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
			}
		}elseif addCubeRowIdFlag=1{
			s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid-1
		}
		q status
dataIndexBuild
    s hasMetricValueFlag=1
		if hasMetricValueFlag=1{
			s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid
      //index build start
		  s segNum=cid \ ..#MAXBITRANGE
		  s segInInd=cid # ..#MAXBITRANGE
		  i segInInd=0 {
			  s segInInd=..#MAXBITRANGE
			  s segNum=segNum-1
			}
		  f ij=1:2:allDimStructListLen{
				s j=$list(allDimStructList,ij)
		    s dimV=$lg(drow,j,$c(0))
		    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
		  }
		  //index build end
		  // choice inner join dims and id start
      if isJoinRefed{
		    s ijmask="" f{
				  s ijmask=$o(joinDimStruct(ijmask))
				  q:ijmask=""
				  s ijPos=$o(joinDimStruct(ijmask,""))
				  s ijDimList=$lb()
				  s ijDimCode="" f{
						s ijDimCode=$o(joinDimStruct(ijmask,ijPos,ijDimCode))
						q:ijDimCode=""
						s ijDimSn=joinDimStruct(ijmask,ijPos,ijDimCode,"SN")
						s ijDimPsn=joinDimStruct(ijmask,ijPos,ijDimCode,"PSN")
						s $list(ijDimList,ijDimSn)=$lg(drow,ijDimPsn)
				  }
				  if '$d(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList)){
						s i=$i(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos))
				  }
				  s ^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList,cid)=0
				}
		  }
		  // choice inner join dims and id end
		  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
		}elseif addCubeRowIdFlag=1{
			s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid-1
		}
		q
}

// 适用于数据结构2

Method ExecuteRoot4(irp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	q:'irp.CanExecute() status
	if (irp.IsRealTimeData()){
	  s rtirp=irp.GetRealTimeIRP()
	  q:rtirp="" $$$ERROR("Can't create RealTimeThemeIRP!")
	  s select=rtirp.DimSelect
	  i select="" s select=rtirp.MetricSelect
	  else  s select=select_","_rtirp.MetricSelect
	  s fetchDS=rtirp.GetFetchDimStruct(),fetchMS=rtirp.GetFetchMetricStruct()
	  s httprequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
      s dimMask=irp.dimsShowInd
      s day=$g(irp.jsonExpStruct("DAY"),$zd($p($h,",",1),3))
      ;s:day="" day=$zd($p($h,",",1),3)
      d httprequest.InsertParam("themePath",irp.jsonExpStruct("FROM"))
      d httprequest.InsertParam("day",day) ;
      d httprequest.InsertParam("select",select)
      d httprequest.InsertParam("mask",irp.GetComputedCube().Mask())
      d httprequest.InsertParam("dimStruct",$lts(fetchDS))
      d httprequest.InsertParam("metricStruct",$lts(fetchMS))
      d httprequest.InsertParam("dimMask",dimMask)
      
      
      w "start request",!
      s requestUrl="/dm/theme/data/rtdcreate?themePath="_irp.jsonExpStruct("FROM")_"&day="_day_"&select="_select_"&mask="_rtirp.FetchCube.Mask()_"&dimStruct="_$lts(fetchDS)_"&metricStruct="_$lts(fetchMS)_"&dimMask="_dimMask
      w "requestUrl:"_requestUrl,!
      s status= httprequest.Get("/dm/theme/data/rtdcreate",2)
      ;b ;ExecuteRoot2
      if (status=$$$OK){
	    s response=httprequest.HttpResponse
	    s rstatus=response.Data.ReadLine()
	    i rstatus'="1"{
		  q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_rstatus) 
	    }else{
		  q status
	    }
      }else{
	    q $$$ERROR("Request "_httprequest.Server_":"_httprequest.Port_"/dm/theme/data/rtdcreate is error,message is "_httprequest.HttpResponse.Data.WriteLine())
      }
	}elseif irp.IsInnerJoin(){
	  q ..ExecuteInnerJoin(irp)
	}
	s dataLog=##class(DHCWL.DM.T.DataLog).StartLog("PEHQ",irp.jsonExpStruct("FROM")) //PhysicalExecutor History Query
	s status=irp.FilterParse2()
	q:status'=$$$OK status
	if irp.FilterRootNode=""{
	  k ^||tempPartIdMap
	  d ..GetRootAllWithNoFilter(irp)
	}else{
	  d irp.GetFilterTargetBit()
	  m segBitMap= irp.FilterRootNode.SegBitIndexMap
	  k ^||tempPartIdMap
	  s re=$sortbegin(^||tempPartIdMap)
	  s partInd="" f{
	    s partInd=$o(segBitMap(partInd))
	    q:partInd=""
	    f i=0:1:$g(segBitMap(partInd),0){
	      continue:'$d(segBitMap(partInd,i))
	      s bit=segBitMap(partInd,i)
	      s j=$bitfind(bit,1,1)
	      while(j>0){
	        s id=(i*..#MAXBITRANGE)+j
	        s ^||tempPartIdMap(partInd,id)=""
	        s j=$bitfind(bit,1,j+1)
	      }
	    }
	  }
	  s re=$sortend(^||tempPartIdMap)
	}
	
	
	;job ##class(MulProPhyExecutor).RootExecutor(1,irp,.cubeIdMap)
	;d ##class(MulProPhyExecutor).RootExecutor(2,irp,.cubeIdMap)
	;s idList=$lb(),idPartList=$lb(),len=0
	
	;s debuget=$p($zts,",",2)
	;w "filter bit id spend time:"_(debuget-debugst),!
	s cubeMask=irp.RefCube.Mask()
	m dimMask=irp.dimsShowInd
	s ccm=irp.GetComputedCube().Mask() //computed cube mask
	m showStruct=irp.cubeDimsShowInd
	m metricMap=irp.metricsShowInd
	m proFunStruct=irp.proFunStruct
	m sortStruct=irp.sortStructMap
	k metricSNStruct
	//precompute join dims for joining start
	k joinDimStruct
	s isJoinRefed=irp.IsJoinRefed
	s hasSortFlag=irp.HasSortFlag
	s hasMetricDetailSort=irp.MetricDitailInSortFlag
	d dataLog.Touch("Filter")
	if isJoinRefed{
	  ;b ;isJoinRefed
	  s ijChildren=irp.GetInnerJoinChildren()
	  f i=1:1:ijChildren.Count(){
		s ijChild=ijChildren.GetAt(i)
		s ijirp=ijChild.GetInnerJoinIRP()
		s ijSt=ijirp.GetJoinStruct(irp.ResultSetName,.joinStructDimMap)
		s ijPos=ijirp.GetJoinPosition(irp.ResultSetName)
		if ijPos=-1{
		  s status=$$$ERROR(irp.ResultSetName_" is not left or right of inner joining")
		  q
		}
		s ijChildMask=ijChild.GetComputedCube().Mask()
		;s joinDimStruct(ijChildMask,ijPos)=ijSt
		m joinDimStruct(ijChildMask,ijPos)=joinStructDimMap
	  }
	}
	q:status'=$$$OK status
	//precompute join dims for joining end
	;w irp.RefCube.ToString(),!
	;w irp.GetComputedCube().ToString(),!
	;zw showStruct
	;zw metricMap
	;w "cubeMask:"_cubeMask,!
	;w "idList:"_ $lts(idList),!
	;w $lts(idPartList),!
	s pdsList=irp.parsedDimStuList
	k showStruct2
	s j="" f{
	  s j=$o(showStruct(j))
	  q:j=""
	  s pdstu=pdsList.GetAt(j)
	  if (pdstu.IsRelationDim()=1){
			if (pdstu.IsFunctionCall()=1){
		  	s showStruct2("RF",j)=""
			}else{
		  	s showStruct2("R",j)=pdstu.SN
			}
	  }else{
			if (0)&&(pdstu.IsFunctionCall()=1){
		  	s showStruct2("DF",j)=""
			}else{
		  	s showStruct2("D",j)=""
			}
	  }
	}
	k ^||tempdimvc  //temp dim value cache
	k ^||temprmind  //temp index of relation dim for metric 
	
	s relationDimFlag=0
	s part="" f{
	  s part=$o(^||tempPartIdMap(part))
	  q:part=""
	  s id="" f{
		s id=$o(^||tempPartIdMap(part,id))
		q:id=""
		;w "id:"_id,!
		s row=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
		s drow=$lb()
		//start build computed cube dims
		k returnListMap
	    s j="" f{
			  s j=$o(showStruct2("D",j))
			  q:j=""
			  s $list(drow,j)=""
			  s srt=showStruct(j,"S")
			  s srtl=$ll(srt)
			  s cDim=$lg(row,$list(srt,3))
			  s $list(drow,j)=cDim
			  if srtl>4{
					if $d(^||tempdimvc(j,cDim)){
					  s $list(drow,j)=^||tempdimvc(j,cDim)
					}else{
					  s cDim2=##class(DHCWL.DM.T.DimDStruct).GetValue(cDim,srt,j,.proFunStruct,"D")
					  s ^||tempdimvc(j,cDim)=cDim2
					  s $list(drow,j)=cDim2
					}
			  }
	    }
	  k ^||temprmind
	  s relDimMetricFilterFlag=0
	  s j="" f{
			s j=$o(showStruct2("RF",j))
			q:j=""
			s pdstu=pdsList.GetAt(j)
			s relationDimFlag=1
			d ##class(DHCWL.DM.T.CubeDStruct).FetchDimFromFunCall(cubeMask,part,id,j,.row,.pdstu,.returnMap)
			m returnListMap(j)=returnMap
			s relDimMetricFilterFlag=1
			//记录RelationDim对应的度量索引
	  }
		s j="" f{
			s j=$o(showStruct2("R",j))
			q:j=""
			s relationDimFlag=1
			s rsn=showStruct2("R",j)
			s rind="" f{
			  s rind=$o(^DHCWL.DM.T.CubeDStructR(part,cubeMask,id,rsn,rind))
			  q:rind=""
				s retList=^DHCWL.DM.T.CubeDStructR(part,cubeMask,id,rsn,rind)
				s returnListMap(j,rind)=retList
				//记录RelationDim对应的度量索引
				s retListLen=$ll(retList)
				f retListInd=1:1:retListLen{
					s rvalue=$lg(retList,retListInd,"")
					if ($d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rvalue,id))){
					  s relDimMetricFilterFlag=1
						s msn="" f{
							s msn=$o(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rvalue,id,msn))
							q:msn=""
							s rseg="" f{
							  s rseg=$o(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rvalue,id,msn,rseg))
							  q:rseg=""
							  s rmetricbit=$g(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rvalue,id,msn,rseg),"")
							  continue:rmetricbit=""
							  s prermetricbit=$g(^||temprmind(msn,rseg),"")
							  if (prermetricbit=""){
									s ^||temprmind(msn,rseg)=rmetricbit
							  }else{
									s ^||temprmind(msn,rseg)=$bitlogic(prermetricbit & rmetricbit)
							  }
							}
						}
					}
				}
			}
		}
		k visitListMapStatus
		s rdimInd="" f{
		  s rdimInd=$o(returnListMap(rdimInd))
		  q:rdimInd=""
		  s listseg=$o(returnListMap(rdimInd,""))
		  s visitListMapStatus(rdimInd)=listseg
		  s visitListMapStatus(rdimInd,0)=1
		  s visitListMapStatus(rdimInd,1)=$ll(returnListMap(rdimInd,listseg))
		}
		if (relationDimFlag=1){
		  s runFlag=1
		  while(runFlag){
		    s rdimInd="" f{
		      s rdimInd=$o(returnListMap(rdimInd))
		      q:rdimInd=""
		      s listseg=visitListMapStatus(rdimInd)
		      s listInd=visitListMapStatus(rdimInd,0)
		      s rdimv=$lg(returnListMap(rdimInd,listseg))
		      s $list(drow,rdimInd)=rdimv
		      s listInd=listInd+1
		      s visitListMapStatus(rdimInd,0)=listInd
		      if (listInd>visitListMapStatus(rdimInd,1) ){
			    s listInd=  $o(returnListMap(rdimInd,listInd))
			    s visitListMapStatus(rdimInd)=listInd
			    s:listInd="" runFlag=0
		      }
		    }
		    d resolveonRow4
		  }
		}else{
		  d resolveonRow4
		}
		
	    //end build computed cube dims
	    
	    //window function dim group end
	  } //s id=$o(^||tempPartIdMap(part,id))
	} //s part=$o(^||tempPartIdMap(part))
	d dataLog.Touch("Group")
	k ^||tempdimvc
	i status'=$$$OK {
	  k ^||TEMPCMPDCUBEDD(ccm)
	  k ^||TEMPCMPDCUBEDI(ccm)
	  q status
	}
	k ^||TEMPCMPDCUBEDI(ccm,dimMask,0)
	//window agg computing start
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:'$d(metricMap(j,"DSN"))
	  s partmask=metricMap(j,"D")
	  k ^||TEMPCMPDCUBEDI(ccm,partmask,-1)
	  s funCall=irp.aggFunctionCallList.GetAt(j)
	  s fun=funCall.GetFunction()
	  s partRowId="" f{
	    s partRowId=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId))
	    q:partRowId=""
	    d fun.SetNewDim(0)
	    ;d fun.SetInteralResult(1)
	    s mli="" f{
		  s mli=$o(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli))
		  q:mli=""
		  s wml=^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)
		  d fun.Eval(wml)
	    }
	    d fun.SetNewDim(1)
		s result=fun.Eval()
		k ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2)
		s $list(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,0),1)=result
	  }
	}
	//window agg computing end
	//metric agg start
	s partInd="" f{
	  s partInd=$o(^||TEMPCMPDCUBEDD(ccm,partInd))
	  q:partInd=""
	  s cid="" // computed cube dim row id
	  f {
			s cid=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid))
			q:cid=""
			s metricSN=0 f{
			  s metricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN))
			  q:metricSN=""
			  if ('$d(metricMap(metricSN,"F"))){
					continue
			  }
			  ;continue:'$g(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN),0)
			  ;s metricShowInd=metricSNStruct(metricSN)
			  s funCall=irp.aggFunctionCallList.GetAt(metricSN)
			  s fun=funCall.GetFunction()
			  d fun.SetNewDim(0)
			  ;d fun.SetInteralResult(1)
			  s mli="" f{
					s mli=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli))
					q:mli=""
					s segMetricList=^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,mli)
					;w "segMetricList:"_$lts(segMetricList),!
					d fun.Eval(segMetricList)
			  }
			  s ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,1)=0
			  d fun.SetNewDim(1)
			  s result=fun.Eval()
			  k ^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2)
			  s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,metricSN,2,0),1)=result
			}
			s winMetricSN=0 f{
			  s winMetricSN=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN))
			  q:winMetricSN=""
			  s winDimMask=^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN)
			  s winRowId="" f{
				s winRowId=$o(^||TEMPCMPDCUBEDD(ccm,partInd,cid,-1,winMetricSN,winRowId))
				q:winRowId=""
				if $d(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId)){
			      s result=$lg(^||TEMPCMPDCUBEDI(ccm,winDimMask,0,winRowId,2,0),1)
			      ;if winDimMask=104 b ;2
			      s $list(^||TEMPCMPDCUBEDD(ccm,partInd,cid,winMetricSN,2,0),1)=result
				}
			
			  }
			}
		
			//sort resolve start add at 20170926
			s drow=^||TEMPCMPDCUBEDD(ccm,partInd,cid)
			if (hasSortFlag=1)&&(hasMetricDetailSort=0){
				s sindex="" f{
				  s sindex=$o(sortStruct(1,sindex))
				  q:sindex=""
				  s ft=sortStruct(1,sindex,"FT")
				  s fi=sortStruct(1,sindex,"FI")
				  if ft="D"{
						s sdim=$lg(drow,fi,$char(-1))
						s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0))
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
				  }else{
						s sdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi,2,0),1,0) //metric
						s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0))
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,0,partInd,cid)=""
				  }
				  s sindex2=$o(sortStruct(1,sindex))
				  if sindex2'=""{
				    s fi2=sortStruct(1,sindex2,"FI")
				    s ft2=sortStruct(1,sindex2,"FT")
				    if ft2="D"{
					  	s nsdim=$lg(drow,fi2,$char(-1))
				    }else{
					  	s nsdim=$lg(^||TEMPCMPDCUBEDD(ccm,partInd,cid,fi2,2,0),1,0) //metric
				    }
						s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sdim,1,nsdim)=$lb(sindex2,partInd,cid)
				  }
				}
			}
			//sort resolve end
	  }
	}
	//metric agg end
	//sort resolve again start add at 20170927
	if (hasSortFlag=1)&&(hasMetricDetailSort=0){
		d ..SortResolve(.sortStruct,ccm)
	}
	//sort resolve again end
	d dataLog.CommitLog("F",irp.GetCQLExpression())
	
	s irp.ExecutedLogs=irp.ExecutedLogs+1
	
	;zw ^||TEMPCMPDCUBEDD
	;zw ^||TEMPCMPDCUBEDI
	q status
resolveonRow4
    s dimsStatus=0
	if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)){
	  s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)
	  s dimsStatus=1
	}else{
      s cid=$g(^||TEMPCMPDCUBEDI(ccm,dimMask,0),0)+1
      s ^||TEMPCMPDCUBEDI(ccm,dimMask,0)=cid
      s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,drow)=cid
      // choice inner join dims and id start
      if isJoinRefed{
	    ;b ;choice inner join dims
	    s ijmask="" f{
		  s ijmask=$o(joinDimStruct(ijmask))
		  q:ijmask=""
		  s ijPos=$o(joinDimStruct(ijmask,""))
		  s ijDimList=$lb()
		  s ijDimCode="" f{
			s ijDimCode=$o(joinDimStruct(ijmask,ijPos,ijDimCode))
			q:ijDimCode=""
			s ijDimSn=joinDimStruct(ijmask,ijPos,ijDimCode,"SN")
			s ijDimPsn=joinDimStruct(ijmask,ijPos,ijDimCode,"PSN")
			s $list(ijDimList,ijDimSn)=$lg(drow,ijDimPsn)
		  }
		  if '$d(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList)){
			s i=$i(^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos))
		  }
		  s ^||TEMPCMPDCUBEDI(ccm,-ijmask,ijPos,ijDimList,cid)=0
		}
	  }
	  // choice inner join dims and id end
	}
	//index build start
	s segNum=cid \ ..#MAXBITRANGE
	s segInInd=cid # ..#MAXBITRANGE
	i segInInd=0 {
	  s segInInd=..#MAXBITRANGE
	  s segNum=segNum-1
	}
	if (dimsStatus=0){ //index data
	  s j="" f{
	    s j=$o(showStruct(j))
	    q:j=""
	    s srt=showStruct(j,"S")
	    s sn=$lg(srt,3)
	    s dimV=$lg(drow,j,"")
	    continue:dimV=""
	    s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,j,dimV,segNum),segInInd)=1
	  }
	}
	//index build end
	//metric compute start
	s result=0
	s j="" f{
	  s j=$o(metricMap(j))
	  q:j=""
	  continue:$d(metricMap(j,"DSN"))
	  if $d(metricMap(j,"P")){
			s pid="" f{
			  s pid= $o(metricMap(j,"P",pid))
			  q:pid=""
			  continue:'$d(metricMap(j,"P",pid,"T"))
			  s metricSN=$lg(metricMap(j,"P",pid,"S"),2)
			  q:metricSN'=""
			}
    }elseif $d(metricMap(j,"M")){
	    s metricSN=metricMap(j,"M")
	  }else{
			s metricSN=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,0))
	  }
	  if metricSN=""{
	    s status=$$$ERROR("Can't get metric serial number")
	    q
	  }
	  s metricSNStruct(j)=metricSN
	  q:'$d(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN))
	  //s maxMetricListSegNum=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN,1)
	  if '$d(metricMap(j,"D")){
		//m ^||TEMPCMPDCUBEDD(ccm,0,cid,j)=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN)
		s mlist=$g(^||TEMPCMPDCUBEDD(ccm,0,cid,j,1),$lb(0,0))
		s mli=$lg(mlist,1)
		s segMetricInd="" f{
		  s segMetricInd=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd))
		  q:segMetricInd=""
		  if (relDimMetricFilterFlag=0){
			s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd),$lb())
		  }elseif $d(^||temprmind(metricSN,segMetricInd)){
			s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd),$lb())
			s metricbit=^||temprmind(metricSN,segMetricInd)
			s metricbitind=$bitfind(metricbit,1,1)
			s targmetriclist=$lb(),targmetriclistCnt=1
	        while(metricbitind>0){
	          s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
	          s metricbitind=$bitfind(metricbit,1,metricbitind+1),targmetriclistCnt=targmetriclistCnt+1
	        }
	        s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=targmetriclist
		  }else{
			s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,metricSN,segMetricInd),$lb())
		  }
		  
	      //s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,2,mli,0)=$g(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,metricSN,2,segMetricInd,0),0)
	      s mli=mli+1
		}
		s $list(mlist,1)=mli
		s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=mlist
	  }
	}
	//metric compute end
	q:status'=$$$OK
	if (dimsStatus=0){
	  s ^||TEMPCMPDCUBEDD(ccm,0,cid)=drow
	  ;s ^||TEMPCMPDCUBEDD(ccm,0,cid,j,1)=0
	}
	//window function dim group start
	s j="" f{
      s j=$o(metricMap(j))
      q:j=""
      continue:'$d(metricMap(j,"DSN"))
      s pdrow=$lb(),pdrowi=0
      s pdsi="" f{
	    s pdsi=$o(metricMap(j,"DSN",pdsi))
	    q:pdsi=""
	    s dsn=metricMap(j,"DSN",pdsi)
	    s pdrowi=pdrowi+1
	    if dsn=0{
		  s $list(pdrow,pdrowi)=""
		}else{
		  s $list(pdrow,pdrowi)=$lg(drow,dsn,"")
		}
	  }
	  s partmask=metricMap(j,"D")
	  if '$d(^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)){
		s partRowId=$i(^||TEMPCMPDCUBEDI(ccm,partmask,0))
		s ^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)=partRowId
	  }else{
		s partRowId=^||TEMPCMPDCUBEDI(ccm,partmask,-1,pdrow)
      }
      if $d(metricMap(j,"P")){
	    s pid="" f{
		  s pid= $o(metricMap(j,"P",pid))
		  q:pid=""
		  continue:'$d(metricMap(j,"P",pid,"T"))
		  s winMetricSN=$lg(metricMap(j,"P",pid,"S"),2)
		  q:winMetricSN'=""
		}
	  }else{
		s winMetricSN=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,0))
	  }
	  if winMetricSN=""{
	    s status=$$$ERROR("Can't get metric serial number")
	    q
	  }
	  s metricSNStruct(j)=winMetricSN
	  q:'$d(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN))
	  s mlist=$g(^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1),$lb(0,0))
	  s mli=$lg(mlist,1)
	  s segMetricInd="" f{
		s segMetricInd=$o(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd))
		q:segMetricInd=""
		if (relDimMetricFilterFlag=0){
		  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
		}elseif $d(^||temprmind(winMetricSN,segMetricInd)){
		  s rdmetriclist=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
		  s metricbit=^||temprmind(winMetricSN,segMetricInd)
		  s metricbitind=$bitfind(metricbit,1,1)
		  s targmetriclist=$lb(),targmetriclistCnt=1
	      while(metricbitind>0){
	        s $list(targmetriclist,targmetriclistCnt)=$lg(rdmetriclist,metricbitind)
	        s metricbitind=$bitfind(metricbit,1,metricbitind+1),targmetriclistCnt=targmetriclistCnt+1
	      }
	      s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=targmetriclist
		}else{
		  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,2,mli)=$g(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,winMetricSN,segMetricInd),$lb())
		}
		s mli=mli+1
	  }
	  s $list(mlist,1)=mli
	  s ^||TEMPCMPDCUBEDI(ccm,partmask,0,partRowId,1)=mlist
	  //window data belong main row
	  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j)=partmask
	  s ^||TEMPCMPDCUBEDD(ccm,0,cid,-1,j,partRowId)=""
	} //s j=$o(metricMap(j))
    q $$$OK
}

ClassMethod SortResolve(ByRef sortStruct, ccm, type = "")
{
    s dosindex=$o(sortStruct(1,""))
    if dosindex'=""{
		  s doot=sortStruct(1,dosindex,"ST")
		  s doft=sortStruct(1,dosindex,"FT")
		  s dodim="" f{
		    s dodim=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim),doot)
		    q:dodim=""
		    d ..SortResolveHelper(.sortStruct,sortStruct_"S",ccm,type,dosindex,doot,doft,dodim)
		  }
    }
}

ClassMethod SortResolveHelper(ByRef sortStruct, sccm, ccm, type, dosindex As %Integer, doot As %Integer, doft, dodim, level As %Integer = 0, parentdimpart = "", parentdimcid = "")
{
   s sdimcount=^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0)
	 if (type'="I"){
		 if sdimcount=1{
		   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,""))
		   s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,""))
		   s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
		   s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(part,sid)
		   ;w part_":"_sid,!
		 }else{
		   s ndosindex=$o(sortStruct(1,dosindex))
		   if ndosindex'=""{
				 s ndoot=sortStruct(1,ndosindex,"ST")
				 s ndoft=sortStruct(1,ndosindex,"FT")
				 s ndodim="" f{
				   s ndodim=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim),ndoot)
				   q:ndodim=""
				   s part="" f{
					   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim,part))
					   q:part=""
					   s sid="" f{
						   s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim,part,sid))
						   q:sid=""
						   d ..SortResolveHelper(.sortStruct,sccm,ccm,type,ndosindex,ndoot,ndoft,ndodim,level+1,part,sid)
					   }
				   }
				 }
		   }else{
			   if (level<1){
				   s part="" f{
					   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part))
					   q:part=""
					   s sid="" f{
							 s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid))
							 q:sid=""
							 s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
					     s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(part,sid)
							 ;w part_":"_sid,!
					   }
					 }
			   }else{
				   if $d(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,parentdimpart,parentdimcid)){
					 	 s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
					   s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(parentdimpart,parentdimcid)
				   }
			   }
				 
		   }
		 }
	 }else{
		 //b:(dosindex=1)&&(dodim=4)
		 ;b:dodim=-0.48
		 if sdimcount=1{
		   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,""))
		   s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,""))
		   s sidind=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid,""))
		   s itrowid=^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid,sidind)
		   s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
		   s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(part,sid,itrowid)
		 }else{
		   s ndosindex=$o(sortStruct(1,dosindex))
		   if ndosindex'=""{
				 s ndoot=sortStruct(1,ndosindex,"ST")
				 s ndoft=sortStruct(1,ndosindex,"FT")
				 s ndodim="" f{
				   s ndodim=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim),ndoot)
				   q:ndodim=""
				   s part="" f{
					   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim,part))
					   q:part=""
					   s sid="" f{
						   s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,1,ndodim,part,sid))
						   q:sid=""
						   d ..SortResolveHelper(.sortStruct,sccm,ccm,type,ndosindex,ndoot,ndoft,ndodim,level+1,part,sid)
					   }
				   }
				 }
		   }else{
			   if (level<1){
				   s part="" f{
					   s part=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part))
					   q:part=""
					   s sid="" f{
							 s sid=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid))
							 q:sid=""
							 s sidind="" f{
								 s sidind=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid,sidind))
								 q:sidind=""
							   s itrowid=^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,part,sid,sidind)
								 s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
						     s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(part,sid,itrowid)
							 }
					   }
					 }
			   }else{
				   s sidind="" f{
					   s sidind=$o(^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,parentdimpart,parentdimcid,sidind))
					   q:sidind=""
					   s itrowid=^||TEMPCMPDCUBEDI(ccm,sortStruct,dosindex,dodim,0,parentdimpart,parentdimcid,sidind)
						 s i=$i(^||TEMPCMPDCUBEDI(ccm,sccm))
						 s ^||TEMPCMPDCUBEDI(ccm,sccm,i)=$lb(parentdimpart,parentdimcid,itrowid)
				   }
			   }
		   }
		 }
	 }
}

// called by FlowExecutor

ClassMethod UpsertRow(ccm, dimMask, schedulePart As %Integer, dimRow, metricRow)
{
	s dimsExist=0,cid=0
	if $d(^||TEMPCMPDCUBEDI(ccm,dimMask,0,dimRow)){
	  s cid=^||TEMPCMPDCUBEDI(ccm,dimMask,0,dimRow)
	  s dimsExist=1
	}else{
	  s cid=$i(^||TEMPCMPDCUBEDI(ccm,dimMask,0))
	  s ^||TEMPCMPDCUBEDI(ccm,dimMask,0,dimRow)=cid
	}
	s segNum=cid \ ..#MAXBITRANGE
	s segInInd=cid # ..#MAXBITRANGE
	i segInInd=0 {
	  s segInInd=..#MAXBITRANGE
	  s segNum=segNum-1
	}
	if (dimsExist=0){ //index data
	  s dimLen=$ll(dimRow)
	  f i=1:1:dimLen{
		s dimV=$lg(dimRow,i,"")
		continue:dimV=""
		s $bit(^||TEMPCMPDCUBEDI(ccm,dimMask,1,0,i,dimV,segNum),segInInd)=1
	  }
	}
	s metricLen=$ll(metricRow)
	f i=1:1:metricLen{
	  s sn=i
	  s mv=$lg(metricRow,sn)
	  s mli=$g(^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,1),0)
	  s mll=$g(^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,2,mli,0),0)
	  s mll=mll+1
	  try{
	    s $list(^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,2,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
	    s mll=1
	    s $list(^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,2,mli),mll)=mv
	  }
	  s ^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,1)=mli
	  s ^||TEMPCMPDCUBEDD(ccm,schedulePart,cid,sn,2,mli,0)=mll
	}
	s ^||TEMPCMPDCUBEDD(ccm,schedulePart,cid)=dimRow
	q
}

ClassMethod GetAllWithNoFilter(irp As InternalResolvedParser)
{
	s ccm=irp.RefCube.Mask()
	s part="" f{
	  s part=$o(^||TEMPCMPDCUBEDD(ccm,part))
	  q:part=""
	  s cid="" f{
		s cid=$o(^||TEMPCMPDCUBEDD(ccm,part,cid))
		q:cid=""
		s ^||tempPartIdMap(part,cid)=""
	  }
	}
	q
}

ClassMethod GetRootAllWithNoFilter(irp As InternalResolvedParser)
{
	s ccm=irp.RefCube.Mask()
	s part="" f{
	  s part=$o(^DHCWL.DM.T.CubeDStructD(part))
	  q:part=""
	  q:'$d(^DHCWL.DM.T.CubeDStructD(part,ccm))
	  s cid="" f{
		s cid=$o(^DHCWL.DM.T.CubeDStructD(part,ccm,cid))
		q:cid=""
		s ^||tempPartIdMap(part,cid)=""
	  }
	}
	q
}

Method ExecuteInnerJoin(irp As InternalResolvedParser) As %Status
{
	;b ;ExecuteInnerJoin
	s status=$$$OK
	s ijirp=irp.GetInnerJoinIRP()
	s leftirp=ijirp.Left
	s rightirp=ijirp.Right
	if leftirp.CanExecute() && irp.CanExecute(){
	  s depirp=..GetDependecyExecuteNode(leftirp)
	  if depirp'=""{
		if depirp.IsRoot(){
		  s status=..ExecuteRoot2(depirp)
	    }else{
		  s status=..ExecuteChild(depirp)
	    }
	  }
	}
	q:status'=$$$OK status
	if rightirp.CanExecute() && irp.CanExecute(){
	  s depirp=..GetDependecyExecuteNode(rightirp)
	  if depirp'=""{
		if depirp.IsRoot(){
		  s status=..ExecuteRoot2(depirp)
	    }else{
		  s status=..ExecuteChild(depirp)
	    }
	  }
	}
	q:status'=$$$OK status
	s leftMask=leftirp.GetComputedCube().Mask()
	s rightMask=rightirp.GetComputedCube().Mask()
	s leftDimMask=leftirp.dimsShowInd,rightDimMask=rightirp.dimsShowInd
	s ijMask=irp.GetComputedCube().Mask()
	s ijDimMask=irp.dimsShowInd
	s ijPart=0
	m ijRefDimMap=ijirp.RefDimCfgMap,ijRefMetricMap=ijirp.RefMetricCfgMap
	if '$d(^||TEMPCMPDCUBEDI(leftMask,-ijMask,0)) q status
	if '$d(^||TEMPCMPDCUBEDI(rightMask,-ijMask,1)) q status
	s count=^||TEMPCMPDCUBEDI(leftMask,-ijMask,0),fposMask=leftMask,fdimMask=leftDimMask,fpos=0,sposMask=rightMask,sdimMask=rightDimMask,spos=1
	i count>^||TEMPCMPDCUBEDI(rightMask,-ijMask,1) {
	  s count=^||TEMPCMPDCUBEDI(rightMask,-ijMask,1)
	  s fposMask=rightMask,fdimMask=rightDimMask,fpos=1
	  s sposMask=leftMask,sdimMask=leftDimMask,spos=0
	}
	s fijDim="" f{
	  s fijDim=$o(^||TEMPCMPDCUBEDI(fposMask,-ijMask,fpos,fijDim))
	  q:fijDim=""
	  if '$d(^||TEMPCMPDCUBEDI(sposMask,-ijMask,spos,fijDim)) continue
	  s id="" f{
		s id=$o(^||TEMPCMPDCUBEDI(fposMask,-ijMask,fpos,fijDim,id))
		q:id=""
		s fpart=^||TEMPCMPDCUBEDI(fposMask,-ijMask,fpos,fijDim,id)
		
		s fmetricMergeFlag=0
		s sid="" f{
		  s sid=$o(^||TEMPCMPDCUBEDI(sposMask,-ijMask,spos,fijDim,sid))
		  q:sid=""
		  s spart=^||TEMPCMPDCUBEDI(sposMask,-ijMask,spos,fijDim,sid)
		  s srefDims=^||TEMPCMPDCUBEDD(sposMask,spart,sid)
		  
		  s ijid=""
		  if '$d(^||TEMPCMPDCUBEDI(ijMask,ijDimMask,ijPart,fijDim)){
			s ijid=$i(^||TEMPCMPDCUBEDI(ijMask,ijDimMask,ijPart))
			s ^||TEMPCMPDCUBEDI(ijMask,ijDimMask,ijPart,fijDim)=ijid
			s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid)=fijDim
			//index update start
			s segNum=ijid \ ..#MAXBITRANGE
	        s segInInd=ijid # ..#MAXBITRANGE
	        i segInInd=0 {
	          s segInInd=..#MAXBITRANGE
	          s segNum=segNum-1
	        }
			s dim="" f{
		      s dim=$o(ijRefDimMap(2,fpos,dim))
		      q:dim=""
		      s sn=ijRefDimMap(1,dim,"SN")
		      s dimv=$lg(fijDim,sn)
		      continue:dimv=""
	          s $bit(^||TEMPCMPDCUBEDI(ijMask,ijDimMask,1,ijPart,sn,dimv,segNum),segInInd)=1
		    }
		    //index update end
		  }else{
			s ijid=^||TEMPCMPDCUBEDI(ijMask,ijDimMask,ijPart,fijDim)
		  }
		  if fmetricMergeFlag=0{
			s fmetricMergeFlag=1
			s metric="" f{
			  s metric=$o(ijRefMetricMap(2,fpos,metric))
		      q:metric=""
		      s sn=ijRefMetricMap(1,metric,"SN")
		      s psn=ijRefMetricMap(1,metric,"PSN")
		      continue:'$d(^||TEMPCMPDCUBEDD(fposMask,fpart,id,psn))
		      s segMetricInd="" f{
			    s segMetricInd=$o(^||TEMPCMPDCUBEDD(fposMask,fpart,id,psn,2,segMetricInd))
			    q:segMetricInd=""
			    s segMetricList=^||TEMPCMPDCUBEDD(fposMask,fpart,id,psn,2,segMetricInd)
			    s mli=$g(^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,1),0)
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,2,mli)=$g(^||TEMPCMPDCUBEDD(fposMask,fpart,id,psn,2,segMetricInd),$lb())
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,2,mli,0)=$g(^||TEMPCMPDCUBEDD(fposMask,fpart,id,psn,2,segMetricInd),0)
			    s mli=mli+1
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,1)=mli
		      }
			}
			s metric="" f{
			  s metric=$o(ijRefMetricMap(2,spos,metric))
		      q:metric=""
		      s sn=ijRefMetricMap(1,metric,"SN")
		      s psn=ijRefMetricMap(1,metric,"PSN")
		      continue:'$d(^||TEMPCMPDCUBEDD(sposMask,spart,id,psn))
		      s segMetricInd="" f{
			    s segMetricInd=$o(^||TEMPCMPDCUBEDD(sposMask,spart,id,psn,2,segMetricInd))
			    q:segMetricInd=""
			    s segMetricList=^||TEMPCMPDCUBEDD(sposMask,spart,id,psn,2,segMetricInd)
			    s mli=$g(^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,1),0)
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,2,mli)=$g(^||TEMPCMPDCUBEDD(sposMask,spart,id,psn,2,segMetricInd),$lb())
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,2,mli,0)=$g(^||TEMPCMPDCUBEDD(sposMask,spart,id,psn,2,segMetricInd),0)
			    s mli=mli+1
			    s ^||TEMPCMPDCUBEDD(ijMask,ijPart,ijid,sn,1)=mli
		      }
			}
		  }
		}
		
	  }
	}
	k ^||TEMPCMPDCUBEDI(fposMask,-ijMask),^||TEMPCMPDCUBEDI(sposMask,-ijMask)
	k ^||TEMPCMPDCUBEDI(ijMask,ijDimMask,ijPart)
	s irp.ExecutedLogs=2
	q status
}

Method GetDependecyExecuteNode(irp As InternalResolvedParser) As InternalResolvedParser
{
	q:((irp="")||('irp.CanExecute())) ""
    s dep=irp,p=irp.Parent
    while(p'=""){
	  if 'p.CanExecute() q
	  s dep=p
	  s p=dep.Parent
    }
    q dep
}

Method Close()
{
	s rsList=..Parser.GetRSList()
	f i=1:1:$ll(rsList){
	  s rs=$lg(rsList,i)
	  continue:rs=""
	  s irp=..Parser.GetIRParser(rs)
	  continue:irp=""
	  s cube=irp.GetComputedCube()
	  continue:cube=""
	  s mask=cube.Mask()
	  continue:mask=""
	  k ^||TEMPCMPDCUBEDI(mask),^||TEMPCMPDCUBEDD(mask)
	}
	d ..Parser.Close()
	d ..IteratorList.Clear()
	s ..IteratorList=""
	s ..Parser=""
	q
}

}
