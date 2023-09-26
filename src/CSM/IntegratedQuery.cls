Class CSM.IntegratedQuery Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CSM";

/// Name of the WebService.
Parameter SERVICENAME = "IntegratedQuery";

/// 
/// debug: w ##class(CSM.IntegratedQuery).GetAllOrders("meddata",2,5)
ClassMethod GetAllOrders(parNamespace As %String, parPageSize As %Integer, parPageNum As %Integer) As %String
{
	;b "s"
	s $zt="errhandler"
	
	zn parNamespace
	
	s result="["
	s ARCIMSubscript=0
	s counter=0
	
	do
	{
		s ARCIMVersion=""
		
		/// 以下两行代码，直接取了ARCIMSubscript下级的第一个节点，如果有多个节点，
		/// 就可能是错误的！
		s ARCIMSubscript=$O(^ARCIM(ARCIMSubscript))
		s ARCIMVersion=$O(^ARCIM(ARCIMSubscript,ARCIMVersion))
		
		s counter=counter+1
		continue:(counter'>(parPageSize*(parPageNum-1)))
		q:(counter>(parPageSize*parPageNum))
		
		s:(result'="[") result=result_",{Code:"_$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",1)
		s:(result="[") result="[{Code:"_$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",1)
		s result=result_",Desc:"_$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
		
		s itemCatDR=""
		s itemCatDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)
		s:(itemCatDR'="") result=result_",ItemCat:"_$p(^ARC("IC",itemCatDR),"^",2)
		
		s ordCatDR=""
		s:(itemCatDR'="") ordCatDR=$p(^ARC("IC",itemCatDR),"^",8)
		s:(ordCatDR'="") result=result_",OrdCat:"_$p(^OEC("ORCAT",ordCatDR),"^",2)
		
		s result=result_"}"
	}
	while ((ARCIMSubscript'="")&&(ARCIMVersion'="")&&($l(result)'>28000))
	
	zn "csm"
	
	q:($l(result)>28000) "Query result exceeds the max size of 28k"
	q result_"]"
	
errhandler
	zn "csm"
	q ##class(CSM.DataInterface).CleanErrorMsg($ze)
}

}
