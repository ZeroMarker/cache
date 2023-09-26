Class web.UDHCOPGSPTEdit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据安全组获取打印列表
/// w ##class(web.UDHCOPGSPTEdit).GetPrtListByGRowID(122, 2, "CP")
ClassMethod GetPrtListByGRowID(GPRowID As %String, HospId As %String, PrtType As %String) As %String
{
	new (GPRowID, HospId, PrtType)
	set mystr=""
	quit:(GPRowID="") mystr
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospId)
	quit:(myGSRowID="") mystr
		
	set myPrtListFlag=$p((^DHCOPGS("GS",myGSRowID)),"^",20)
	if (myPrtListFlag="Y") {
		set mySub=0
		while($o(^DHCOPGS("GS",myGSRowID,"PT",mySub))) {
			set mySub=$o(^DHCOPGS("GS",myGSRowID,"PT",mySub))
			set myListData=$g(^DHCOPGS("GS",myGSRowID,"PT",mySub))
			continue:(myListData="")
			set myType=$p(myListData,"^",4)
			continue:(myType'=PrtType)
			set myXmlName=$p(myListData,"^",1)
			set myClassName=$p(myListData,"^",2)
			set myMethodName=$p(myListData,"^",3)
			set myPrintMode=$p(myListData,"^",5)
			set HardEquipDR=$p(myListData,"^",6)
			if (mystr="") {
				set mystr=myXmlName_"^"_myClassName_"^"_myMethodName_"^"_myPrintMode_"^"_HardEquipDR
			}else {
				set mystr=mystr_$c(2)_myXmlName_"^"_myClassName_"^"_myMethodName_"^"_myPrintMode_"^"_HardEquipDR
			}
		}
	}
	
	quit myPrtListFlag_$c(1)_mystr
}

}
