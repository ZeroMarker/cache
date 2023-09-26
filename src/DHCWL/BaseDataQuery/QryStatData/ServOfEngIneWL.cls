Class DHCWL.BaseDataQuery.QryStatData.ServOfEngIneWL Extends DHCWL.BaseDataQuery.QryStatData.ServOfEngIne
{

Method Next() As %Integer
{

	q:..curDate>..endDate 0
	
	
		
	s updateDateFlag=0
	s date=0
	f date=..curDate:1:..endDate {
		/*
		s ..curRowID=$o(^DHCWorkLoad(0,"ORDDATE",date,..curRowID))
		s:..curRowID="" updateDateFlag=1
		continue:..curRowID=""
		if ..curRowID'="" q
		*/
		s inxNode=..dateInx_","_date_","_..curRowID_")"
		s ..curRowID=$o(@inxNode)
		s:..curRowID="" updateDateFlag=1
		continue:..curRowID=""
		if ..curRowID'="" q
		
		
	}
	
	s:updateDateFlag=1 ..curDate=date
	q ..curRowID
}

Method LoadInxData()
{
	//^DHCWorkLoad(0,"ORDDATE",{WorkLoad_OrdDate},{WorkLoad_Rowid})
	//^DHCWorkLoad(0,"FlagDate",{WorkLoad_FlagDate},{WorkLoad_Rowid})
	s ^||DHCWLTEMP("ServOfEngIne","WorkLoad_OrdDate")="^DHCWorkLoad(0,""ORDDATE"""
	s ^||DHCWLTEMP("ServOfEngIne","WorkLoad_FlagDate")="^DHCWorkLoad(0,""FlagDate"""	
	
	s ..dateInx=^||DHCWLTEMP("ServOfEngIne",..dateField)
}

}
