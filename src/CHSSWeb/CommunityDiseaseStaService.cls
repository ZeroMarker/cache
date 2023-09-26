Class CHSSWeb.CommunityDiseaseStaService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//根据树的街道节点，列出下属机构的统计数据

ClassMethod List(streetid)
{
 
	Set resultString = ""
	
	 
 
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
		
    s sqlStr="select communitycode,communityname from chss.dicthospital where recorddr="_streetid_" and (communitytype='社区卫生服务中心' or communitytype='乡镇卫生院') union select communitycode,communityname from chss.dicthospital where recorddr in (select rowid from chss.dictVillage where rowidparref="_streetid_") and (communitytype='村卫生所' or communitytype='社区卫生服务站')"	

	d result.Prepare(sqlStr)
	d result.Execute()	
	
	While(result.Next())
	{
	s communitycode=result.Data("CommunityCode")
	s communityname = result.Data("CommunityName")

    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
	;s tmp=communityname_"^"_DiseaseName_"^"_DiseaseCount

	
	
	i $d(^TMPStatDiseaseStreetZwpTotal(DiseaseName)) d
	.s ^TMPStatDiseaseStreetZwpTotal(DiseaseName)=^TMPStatDiseaseStreetZwpTotal(DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseStreetZwpTotal(DiseaseName)=DiseaseCount
	
	}
	d resulta.Close()
	}
	
	s Disea=0
    f  s Disea=$o(^TMPStatDiseaseStreetZwpTotal(Disea)) q:Disea=""  d
    .s temp=Disea_"^"_^TMPStatDiseaseStreetZwpTotal(Disea)
  
    .d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("StatName^ArcNum",20)
	k json	

	k ^TMPStatDiseaseStreetZwpTotal
	q resultString
}

//根据树的街道节点，列出下属机构的统计数据(数据明细)

ClassMethod ListDetail(streetid)
{
 
	Set resultString = ""
	
	 
 
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
		
    s sqlStr="select communitycode,communityname from chss.dicthospital where recorddr="_streetid_" and (communitytype='社区卫生服务中心' or communitytype='乡镇卫生院') union select communitycode,communityname from chss.dicthospital where recorddr in (select rowid from chss.dictVillage where rowidparref="_streetid_") and (communitytype='村卫生所' or communitytype='社区卫生服务站')"	

	d result.Prepare(sqlStr)
	d result.Execute()	
	
	While(result.Next())
	{
	s communitycode=result.Data("CommunityCode")
	s communityname = result.Data("CommunityName")

    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
	;s tmp=communityname_"^"_DiseaseName_"^"_DiseaseCount
	i $d(^TMPStatDiseaseStreetZwp(communityname,DiseaseName)) d
	.s ^TMPStatDiseaseStreetZwp(communityname,DiseaseName)=^TMPStatDiseaseStreetZwp(communityname,DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseStreetZwp(communityname,DiseaseName)=DiseaseCount
	
	
 
	}
	d resulta.Close()
	}
	d result.Close()
	s communityname=0
    f  s communityname=$o(^TMPStatDiseaseStreetZwp(communityname)) q:communityname=""  d
    .s DiseaseName=0
    .f  s DiseaseName=$o(^TMPStatDiseaseStreetZwp(communityname,DiseaseName)) q:DiseaseName=""  d
    ..s temp=communityname_"^"_DiseaseName_"^"_^TMPStatDiseaseStreetZwp(communityname,DiseaseName)
  
    ..d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("CommunityCode^StatName^ArcNum",20)
	k json	
	k ^TMPStatDiseaseStreetZwp
	q resultString
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
    
     
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
 
	
	i $d(^TMPStatDiseaseSectionZwpTotal(DiseaseName)) d
	.s ^TMPStatDiseaseSectionZwpTotal(DiseaseName)=^TMPStatDiseaseSectionZwpTotal(DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseSectionZwpTotal(DiseaseName)=DiseaseCount

	}
    d resulta.Close()
	}
	d resultCommunityCode.Close()
 
    
	}
	d result.Close()
	s Disea=0
    f  s Disea=$o(^TMPStatDiseaseSectionZwpTotal(Disea)) q:Disea=""  d
    .s temp=Disea_"^"_^TMPStatDiseaseSectionZwpTotal(Disea)
  
    .d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("StatName^ArcNum",20)
	k json	
 
	k ^TMPStatDiseaseSectionZwpTotal
	q resultString
}

//根据树的区县节点，列出下属街道和乡镇的统计数据（明细）

ClassMethod ListSectionDetail(sectionid)
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
    
     
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
	
	i $d(^TMPStatDiseaseSectionZwp(streetname,DiseaseName)) d
	.s ^TMPStatDiseaseSectionZwp(streetname,DiseaseName)=^TMPStatDiseaseSectionZwp(streetname,DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseSectionZwp(streetname,DiseaseName)=DiseaseCount
	
	
	

	}
    d resulta.Close()
	}
	d resultCommunityCode.Close()
 
    
	}
	d result.Close()
	s communityname=0
    f  s communityname=$o(^TMPStatDiseaseSectionZwp(communityname)) q:communityname=""  d
    .s DiseaseName=0
    .f  s DiseaseName=$o(^TMPStatDiseaseSectionZwp(communityname,DiseaseName)) q:DiseaseName=""  d
    ..s temp=communityname_"^"_DiseaseName_"^"_^TMPStatDiseaseSectionZwp(communityname,DiseaseName)
  
    ..d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("CommunityCode^StatName^ArcNum",20)
	k json	
	k ^TMPStatDiseaseSectionZwp
	q resultString
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
   
   
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
	;w resultCommunityCode.Count()
    While(resultCommunityCode.Next())
    { 
   
    s communitycode=resultCommunityCode.Get("code")	
    
    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
  
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
	 
	i $d(^TMPStatDiseaseCityZwpTotal(DiseaseName)) d
	.s ^TMPStatDiseaseCityZwpTotal(DiseaseName)=^TMPStatDiseaseCityZwpTotal(DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseCityZwpTotal(DiseaseName)=DiseaseCount
	;d json.InsertRowData(tmp)
	}
	d resulta.Close()
	
	}
	d resultCommunityCode.Close()
	}
	d result.Close()
	s Disea=0
    f  s Disea=$o(^TMPStatDiseaseCityZwpTotal(Disea)) q:Disea=""  d
    .s temp=Disea_"^"_^TMPStatDiseaseCityZwpTotal(Disea)
  
    .d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("StatName^ArcNum",20)
	k json	 
	k ^TMPStatDiseaseCityZwpTotal
	q resultString
}

//根据树的市节点，列出下属区县的数据（明细）

ClassMethod ListCityDetail(cityid)
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
   
   
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
	;w resultCommunityCode.Count()
    While(resultCommunityCode.Next())
    { 
   
    s communitycode=resultCommunityCode.Get("code")	
    
    s resulta = ##class(%Library.ResultSet).%New()	
	s sqlstra="select count(a.DiagnoseRowId) as DiseaseCount,a.Itemassortname as DiseaseName from chss.personhealthdiagnose a,chss.personhealthrecordmain b  where (a.itemdcode=22 or a.itemdcode=5) and a.personrowidparref=b.personrowid and b.communitycode="_communitycode_" group by a.Itemassortname"
	
	d resulta.Prepare(sqlstra)
	d resulta.Execute()	
   
	While(resulta.Next()){
  
	s DiseaseName=resulta.Get("DiseaseName")
    s DiseaseCount=resulta.Get("DiseaseCount")
	
	i $d(^TMPStatDiseaseCityZwp(sectionname,DiseaseName)) d
	.s ^TMPStatDiseaseCityZwp(sectionname,DiseaseName)=^TMPStatDiseaseCityZwp(sectionname,DiseaseName)+DiseaseCount
	e  d
	.s ^TMPStatDiseaseCityZwp(sectionname,DiseaseName)=DiseaseCount
	
	
	
 
	}
	d resulta.Close()
	
	}
	d resultCommunityCode.Close()
	}
	d result.Close()
	s communityname=0
    f  s communityname=$o(^TMPStatDiseaseCityZwp(communityname)) q:communityname=""  d
    .s DiseaseName=0
    .f  s DiseaseName=$o(^TMPStatDiseaseCityZwp(communityname,DiseaseName)) q:DiseaseName=""  d
    ..s temp=communityname_"^"_DiseaseName_"^"_^TMPStatDiseaseCityZwp(communityname,DiseaseName)
  
    ..d json.InsertRowData(temp)
	
	s resultString = json.getJsonData("CommunityCode^StatName^ArcNum",20)
	k json	
	k ^TMPStatDiseaseCityZwp
	q resultString
}

ClassMethod GetDiseaseCount(CommunityCode As %String) As %String
{
}

Storage Default
{
<Data name="CommunityDiseaseStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityDisA7CD</DataLocation>
<DefaultData>CommunityDiseaseStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityDisA7CD</IdLocation>
<IndexLocation>^CHSSWeb.CommunityDisA7CI</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityDisA7CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
