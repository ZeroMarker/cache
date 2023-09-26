Class DHCWL.DM.Core.InnerJoinIRP Extends %RegisteredObject
{

Property Left As InternalResolvedParser;

Property Right As InternalResolvedParser;

Property Self As InternalResolvedParser;

Property LeftJoinDims As %List;

Property RightJoinDims As %List;

Property RefDimCfgMap [ MultiDimensional ];

Property RefMetricCfgMap [ MultiDimensional ];

Method %OnNew(left As InternalResolvedParser, right As InternalResolvedParser, irp As InternalResolvedParser, leftJoinDims As %List, rightJoinDims As %List, ByRef refDimCfgMap, ByRef refMetricCfgMap) As %Status [ Private, ServerOnly = 1 ]
{
	s left.IsJoinRefed=1
	s right.IsJoinRefed=1
	s ..Left=left
	s ..Right=right
	s ..Self=irp
	s ..LeftJoinDims=leftJoinDims
	s ..RightJoinDims=rightJoinDims
	m ..RefDimCfgMap=refDimCfgMap
	m ..RefMetricCfgMap=refMetricCfgMap
	q $$$OK
}

Method GetJoinStruct(refJoinName, ByRef structMap) As %List
{
	k structMap
	s irp="",joinDim=""
	if refJoinName=..Left.ResultSetName{
	  s irp=..Left
	  s joinDim=..LeftJoinDims
	}elseif refJoinName=..Right.ResultSetName{
	  s irp=..Right	
	  s joinDim=..RightJoinDims
	}else{
	  q ""	
	}
	s len=$ll(joinDim),struct=$lb()
	s refTheme=irp.GetComputedCube()
	
	s stInd=1
	f i=1:1:len{
	  s dim=$lg(joinDim,i)
	  s dimSt=refTheme.GetDimStruct(dim)
	  s $list(struct,stInd,stInd+3)=dimSt
	  s stInd=stInd+4
	  s structMap(dim,"PSN")=$lg(dimSt,2)
	  s structMap(dim,"SN")=i
	}
	q struct
}

//return 0 meaning left 1 meaning right -1 meaning error

Method GetJoinPosition(refJoinName) As %Integer
{
	if refJoinName=..Left.ResultSetName{
	  q 0
	}elseif refJoinName=..Right.ResultSetName{
	  q 1
	}else{
	  q -1	
	}
}

Method Close()
{
}

}
