Class CHSSWeb.CommunityDeathStaService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//根据树的街道节点，列出下属机构的统计数据

ClassMethod List(streetid)
{
 
	Set resultString = ""
	
	 
 
	Set json = ##class(Code.JsonObj).%New()	
     s result = ##class(%Library.ResultSet).%New()	
		
    s sqlStr="select communitycode,communityname from chss.dicthospital where recorddr="_streetid_" and (communitytype='社区卫生服务中心' or communitytype='乡镇卫生院') union select communitycode,communityname from chss.dicthospital where recorddr in (select rowid from chss.dictVillage where rowidparref="_streetid_") and (communitytype='村卫生所' or communitytype='社区卫生服务站')"	
    ;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()	
	While(result.Next())
	{
	s communitycode=result.Data("CommunityCode")
	s communityname = result.Data("CommunityName")

	s DeathCount=..GetDeathCount(communitycode)

	s tmp=communityname_"^"_DeathCount

    d json.InsertRowData(tmp)
	}

	s resultString = json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

//根据树的区县节点，列出下属街道和乡镇的统计数据

ClassMethod ListSection(sectionid)
{
	 
	Set resultString = ""
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as streetname,rowid as streetid from chss.dictstreet where rowidparref="_sectionid
	d result.Prepare(sqlstr)
	d result.Execute()	
	While(result.Next())
	{
	s streetname=result.Get("streetname")
	s streetid = result.Get("streetid")
	s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowId = "_streetid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowId="_streetid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
    
    s DeathCountz=0
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
    s DeathCount=..GetDeathCount(communitycode)
    s DeathCountz=DeathCountz+DeathCount	
	}
	d resultCommunityCode.Close()
	s tmp=streetname_"^"_DeathCountz
    d json.InsertRowData(tmp)
	}
	s resultString =  json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

//根据树的市节点，列出下属区县的数据

ClassMethod ListCity(cityid)
{
	 
	Set resultString = ""
 
 
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as sectionname,rowid as sectionid from chss.dictsection where rowidparref="_cityid
	d result.Prepare(sqlstr)
	d result.Execute()	
	While(result.Next())
	{
	s sectionname=result.Get("sectionname")
	s sectionid = result.Get("sectionid")
	s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowIdParref = "_sectionid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowIdParref="_sectionid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
    
   s DeathCountz=0
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
    s DeathCount=..GetDeathCount(communitycode)
    s DeathCountz=DeathCountz+DeathCount	
	}
	d resultCommunityCode.Close()
	s tmp=sectionname_"^"_DeathCountz
    d json.InsertRowData(tmp)
	}
	s resultString =  json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

ClassMethod GetDeathCount(CommunityCode As %String) As %String
{
	     s DeathCount=0
         
	 	 s rowid=0
	     f  s rowid=$o(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid)) q:rowid=""    d  
	     .s tmp=##class(CHSS.CommunityWorkStaNum).%OpenId(rowid)
	     .s DeathCount=tmp.CommunityDeathNum //死亡档案数
 	    
 	     q DeathCount
}

Storage Default
{
<Data name="CommunityDeathStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityDea9A4D</DataLocation>
<DefaultData>CommunityDeathStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityDea9A4D</IdLocation>
<IndexLocation>^CHSSWeb.CommunityDea9A4I</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityDea9A4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
