Class DHCWL.BaseDataQuery.QryStatData.ServOfOutIFJson Extends DHCWL.BaseDataQuery.QryStatData.ServOfOutputIF
{

Method DoOutput()
{
	//明细数据
	//^||DHCWLTEMP("resultSet",rowInx)=recData
	//汇总数据
	//s ^||DHCWLTEMP("measureV",dimsV,item)=$g(^||DHCWLTEMP("measureV",dimsV,item))+measure(item)
	s startInx=..GetAryOutCfgArgs("start")
	s endInx=..GetAryOutCfgArgs("end")
	s delimiter=..GetAryOutCfgArgs("delimiter")
	
	s jsonPros=""
	s jsonDeli=delimiter
	s colInx=0
	s nums=0
	
	if ^||DHCWLTEMP("RPTCFG","IsAggregat")=0 d BuildDetailJson
	//^||DHCWLTEMP("RPTItem","colItem",item
	if ^||DHCWLTEMP("RPTCFG","IsAggregat")=1 d BuildAggregatJson
	
	d json.SetTotalNum(nums)
	
	w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"		
	
	q
	
BuildAggregatJson
	s item=0
	
	f {
		s item=$o(^||DHCWLTEMP("RPTItem","colItem",item))	
		q:item=""
		
		s type=^||DHCWLTEMP("RPTItem","colItem",item,"type")
		s itemKey=$p(item,"(",1)
		if type="度量" {
			s measure(item)=""
		}else{
			if jsonPros'="" s jsonPros=jsonPros_jsonDeli_"'"_itemKey_"'"
			else  s jsonPros="'"_itemKey_"'"
		}
	}

	s itemKey=""
	f {
		s item=$o(measure(itemKey))	
		q:item=""
		
		if jsonPros'="" s jsonPros=jsonPros_jsonDeli_"'"_itemKey_"'"
		else  s jsonPros="'"_itemKey_"'"
	}	
	s json=##class(DHCWL.util.Json).Json(jsonPros,,,jsonDeli)	
	

	i (startInx=0)&&(endInx=0) s ignore=0
	s recInx=0
	//^||DHCWLTEMP("measureV",dimsV,item)
	s dimsV=""		
	f {
		s dimsV=$o(^||DHCWLTEMP("measureV",dimsV))
		q:dimsV=""
		s nums=nums+1
		i (ignore)&&(nums<(startInx)) continue
		i (ignore)&&((endInx)<nums) continue	
		s recData=dimsV
		s item=""
		f {
			s item=$o(measure(item))	
			q:item=""
		
			s measureV=^||DHCWLTEMP("measureV",dimsV,item)
			s recData=recData_jsonDeli_"'"_measureV_"'"
		}		
		d json.Insert(recData)
	}	
	
	
	
	q	
BuildDetailJson	
	s item=0
	
	f {
		s item=$o(^||DHCWLTEMP("RPTItem","colItem",item))	

		q:item=""
		s itemKey=$p(item,"(",1)
		if jsonPros'="" s jsonPros=jsonPros_jsonDeli_"'"_itemKey_"'"
		else  s jsonPros="'"_itemKey_"'"
	}
	s json=##class(DHCWL.util.Json).Json(jsonPros,,,jsonDeli)
	
	i (startInx=0)&&(endInx=0) s ignore=0
	s recInx=0	
	f {
		s recInx=$o(^||DHCWLTEMP("resultSet",recInx))
		q:recInx=""
		s nums=nums+1
		i (ignore)&&(nums<(startInx)) continue
		i (ignore)&&((endInx)<nums) continue	
		
		s recData=^||DHCWLTEMP("resultSet",recInx)
		d json.Insert(recData)
	}
	
	q
}

}
