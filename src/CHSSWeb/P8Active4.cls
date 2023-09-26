Class CHSSWeb.P8Active4 Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ActiveAll() As %String
{
	;add by wangbo 2010-06-08
	;妇保激活语句
	w ##class(CHSSWeb.WomenBaseInfoService).List("100",0,15,"")
	w ##class(CHSSWeb.WomenBaseInfoService).ListWoman(15,0,15,"")
	w ##class(CHSSWeb.WomenBaseInfoService).ListArc("100",0,15,"")
	w ##class(CHSSWeb.WomenBaseInfoService).ListArcName("100",0,15,"","")
	w ##class(CHSSWeb.WomenBaseInfoService).ListChart("100","EducationDR",0,15,"","")
	w ##class(CHSSWeb.WomenFirstCheckService).List(26,0,15,"")
	w ##class(CHSSWeb.WhFirstCheckEvalService).ListPage(0,15,6)
	w ##class(CHSSWeb.WhFirstCheckEvalService).ShowInfo(0,15,6)
	w ##class(CHSSWeb.WhAntepartumRecheckService).List(26,0,15,"")
	w ##class(CHSSWeb.WhRecheckResultService).List(26,3,0,15,"")
	w ##class(CHSSWeb.WhBirthRecordService).List(26,0,15,"")
	w ##class(CHSSWeb.WhNewBornService).ListPage(0,15,26)
	w ##class(CHSSWeb.WhNewBornService).ShowInfo(0,15,26)
	w ##class(CHSSWeb.WhAfterBirthVisitRecordService).List(26,0,15,"")
	w ##class(CHSSWeb.WhAfter42DaysRecordService).List(26,0,15,"")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBirthParity")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBirthType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBleedReason")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictDystocia")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFetusPosition")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFirstCheckEval")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHBPUnit")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHBVTag")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHeartCheckResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictHemglobin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictODFD")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPlacentaFallMode")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSplitType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictUrineProtein")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenAbPregResult")	
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenBookTime")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenCheck")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenCheckResult")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenComplication")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWomenDangerGrade")


    ;儿保激活语句
    w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChildCheckMonth")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChildGrowthAppraisal")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChildDisease")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictComplexion")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictPhysique")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictRicketSign")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictSuggestion")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFeedType")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictUmbilicalCord")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChildSkin")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictFontanel")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictRicketsSym")
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictChildDisease")
	w ##class(CHSSWeb.Child36CheckRecordService).List("",1,100)
	w ##class(CHSSWeb.ChildBaseInfo).ListFinish("",1,100)
	w ##class(CHSSWeb.ChildBaseInfo).List("",1,100)	
	w ##class(CHSSWeb.ChildBaseInfo).finishsearch("", "", 1, 100)
	w ##class(CHSSWeb.ChildBaseInfo).List2("",1,100)
	w ##class(CHSSWeb.ChildBaseInfo).statisticsAge("1999-01-01","2012-12-21")
	w ##class(CHSSWeb.ChildBaseInfo).statisticsWork("", "1999-01-01","2012-12-21")
	w ##class(CHSSWeb.ChildCheckRecordService).List("",1,100)
	w ##class(CHSSWeb.ChildCheckResultService).List("",1,100)
	w ##class(CHSSWeb.ChildDiseaseHisService).List("")
	w ##class(CHSSWeb.ChildDiseaseHisService).ShowInfo("")
	w ##class(CHSSWeb.ChildFirstCheckService).List("",1,100)

	
	,!
	w ""
	,!
	w "P8Active3的激活已执行完毕"
	,!

	q ""
}

Storage Default
{
<Data name="P8Active4DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.P8Active4D</DataLocation>
<DefaultData>P8Active4DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.P8Active4D</IdLocation>
<IndexLocation>^CHSSWeb.P8Active4I</IndexLocation>
<StreamLocation>^CHSSWeb.P8Active4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
