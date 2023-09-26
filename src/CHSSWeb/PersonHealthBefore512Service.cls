Class CHSSWeb.PersonHealthBefore512Service Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出

ClassMethod List(PersonRowIdParref, start, limit, searchField) As %String
{
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.PersonHealthBefore512 WHERE PersonRowIdParref ="_PersonRowIdParref_searchField

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	
	s json = ##class(Code.JsonObj).%New()
    while(result.Next())
    {
	    s PersonRowIdParref = result.Data("PersonRowIdParref")
	    s BeforeRowId = result.Data("BeforeRowId")
	    s bHaveTBHISBefore = result.Data("bHaveTBHISBefore")
	    s bHaveTB = result.Data("bHaveTB")
	    s TBDiagnose = result.Data("TBDiagnose")
	    s bTreat = result.Data("bTreat")
	    s bFamilyHaveTB = result.Data("bFamilyHaveTB")
	    s bContractHaveTB = result.Data("bContractHaveTB")
	    s bHBVCheck = result.Data("bHBVCheck")
	    
	    s DateOfHBVCheck = result.Data("DateOfHBVCheck")
	    i (DateOfHBVCheck '="")  d
	    .s DateOfHBVCheck = $zd(DateOfHBVCheck,3)
	    
	    s HbsAg = result.Data("HbsAg")
	    s HbsAb = result.Data("HbsAb")
	    s HbeAg = result.Data("HbeAg")
	    s HBeAb = result.Data("HBeAb")
	    s HbcAb = result.Data("HbcAb")
	    s HbsAgBefore = result.Data("HbsAgBefore")
	    s HbsAgType = result.Data("HbsAgType")
	    s bToldBronchia = result.Data("bToldBronchia")
	    s bHaveBronchiaCur = result.Data("bHaveBronchiaCur")
	    s bFamilyHaveBronchia = result.Data("bFamilyHaveBronchia")
	    s bOtherRelaHaveBro = result.Data("bOtherRelaHaveBro")
	    s bWorse = result.Data("bWorse")
	    
	    s tmp =BeforeRowId_"^"_PersonRowIdParref_"^"_bHaveTBHISBefore_"^"_bHaveTB_"^"_TBDiagnose_"^"_bTreat_"^"_bFamilyHaveTB_"^"_bContractHaveTB_"^"_bHBVCheck_"^"_DateOfHBVCheck_"^"_HbsAg_"^"_HbsAb_"^"_HbeAg_"^"_HBeAb_"^"_HbcAb_"^"_HbsAgBefore_"^"_HbsAgType_"^"_bToldBronchia_"^"_bHaveBronchiaCur_"^"_bFamilyHaveBronchia_"^"_bOtherRelaHaveBro_"^"_bWorse
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
		d result.Close()
		s resultString = json.getJsonData("BeforeRowId^PersonRowIdParref^bHaveTBHISBefore^bHaveTB^TBDiagnose^bTreat^bFamilyHaveTB^bContractHaveTB^bHBVCheck^DateOfHBVCheck^HbsAg^HbsAb^HbeAg^HBeAb^HbcAb^HbsAgBefore^HbsAgType^bToldBronchia^bHaveBronchiaCur^bFamilyHaveBronchia^bOtherRelaHaveBro^bWorse", count)
		k json
		q resultString
}

//操作(添加/修改)

ClassMethod AddEdit(BeforeRowId, PersonRowIdParref, bHaveTBHISBefore, bHaveTB, TBDiagnose, bTreat, bFamilyHaveTB, bContractHaveTB, bHBVCheck, DateOfHBVCheck, HbsAg, HbsAb, HbeAg, HBeAb, HbcAb, HbsAgBefore, HbsAgType, bToldBronchia, bHaveBronchiaCur, bFamilyHaveBronchia, bOtherRelaHaveBro, bWorse) As %String
{
	s tempPerson=""
    s ReturnCode=..existPersonRowIdParref(PersonRowIdParref)
   
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdParref)=0)||(PersonRowIdParref="")
	.s result=""
	.s tempPerson=##class(CHSS.PersonHealthBefore512).%OpenId(BeforeRowId)
	
	e  d
	.s tempPerson=##class(CHSS.PersonHealthBefore512).%New()
	i PersonRowIdParref '="" d
    .s PersonRowIdDRobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    .s tempPerson.PersonRowIdParref=PersonRowIdDRobj
    
	s tempPerson.bHaveTBHISBefore = bHaveTBHISBefore
	s tempPerson.bHaveTB = bHaveTB
	s tempPerson.TBDiagnose = TBDiagnose
	s tempPerson.bTreat = bTreat
	s tempPerson.bFamilyHaveTB = bFamilyHaveTB
	s tempPerson.bContractHaveTB = bContractHaveTB
	s tempPerson.bHBVCheck = bHBVCheck
	
	i (DateOfHBVCheck '= "")  d
	.s DateOfHBVCheck = $zdh(DateOfHBVCheck,3)
	.s tempPerson.DateOfHBVCheck = DateOfHBVCheck
	
	s tempPerson.HbsAg = HbsAg
	s tempPerson.HbsAb = HbsAb
	s tempPerson.HbeAg = HbeAg
	s tempPerson.HBeAb = HBeAb
	s tempPerson.HbcAb = HbcAb
	s tempPerson.HbsAgBefore = HbsAgBefore
	s tempPerson.HbsAgType = HbsAgType
	s tempPerson.bToldBronchia = bToldBronchia
	s tempPerson.bHaveBronchiaCur = bHaveBronchiaCur
	s tempPerson.bFamilyHaveBronchia = bFamilyHaveBronchia
	s tempPerson.bOtherRelaHaveBro = bOtherRelaHaveBro
	s tempPerson.bWorse = bWorse
	
	s result=tempPerson.%Save()

	i result = "1" d
    .w "{""success"":""true"",""info"":""数据保存成功!""}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

//删除

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.PersonHealthBefore512 where %ID= :RowId)
	q SQLCODE
}

//判断存在

ClassMethod existPersonRowIdParref(PersonRowIdParref) As %String
{
	
	q:PersonRowIdParref="" "-1"
	q:$d(^CHSS.PersonHealthBefore512I("PresonRowIdParrefIndex",PersonRowIdParref)) "1"
	q "0"
}

Storage Default
{
<Data name="PersonHealthBefore512ServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHealthA89D</DataLocation>
<DefaultData>PersonHealthBefore512ServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHealthA89D</IdLocation>
<IndexLocation>^CHSSWeb.PersonHealthA89I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHealthA89S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
