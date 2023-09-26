Class CHSSWeb.PersonLongTermProblemService Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—06-16
/// Description:检索个人长期健康问题
/// Table：PersonLongTermProblem
/// Input:PersonRowIdParref , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		//n (communityCode, start, limit, sort)
		Set PersonRowIdParref=$G(PersonRowIdParref)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set ProblemRowId = 0
		
		
		For  Set ProblemRowId=$O(^CHSS.PersonLongTermProblemI("PersonRowIdParrefIndex",PersonRowIdParref,ProblemRowId)) q:ProblemRowId=""  d
		.
		.s tempProblem=##class(CHSS.PersonLongTermProblem).%OpenId(PersonRowIdParref_"||"_ProblemRowId)
		.
		.s ProblemName = tempProblem.ProblemName
		
		.set ICD10Name=""
		.set ICD10=""
		.i tempProblem.ICD10 '="" d
		.. s ICD10 = tempProblem.ICD10.%Id()
		.. s ICD10Name = tempProblem.ICD10.MRCIDDesc
		
		.s Effection = tempProblem.Effection
		.
		.set DateOfStart = tempProblem.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.
		.		
		.set DateRegister = tempProblem.DateRegister
		.i DateRegister '= "" d
		..s DateRegister = $zd(DateRegister,3)
		.
		.
		.set RegisterName = ""
		.set Register = ""
		.i tempProblem.Register '= "" d
		..s Register = tempProblem.Register
		..s RegisterName = tempProblem.Register
		.
		.set REMARK = tempProblem.REMARK
		.
		.set DateOfDeal = tempProblem.DateOfDeal
		.i DateOfDeal '= "" d
		..s DateOfDeal = $zd(DateOfDeal,3)
		.
		.s Deal = tempProblem.Deal
		.
		.set LapseToName = ""
		.set LapseTo = ""
		.i tempProblem.LapseTo '= "" d
		..s LapseTo = tempProblem.LapseTo.%Id()
		..s LapseToName = tempProblem.LapseTo.Description
		.
		.set DateOfCreate = tempProblem.DateOfCreate
		.i DateOfCreate '= "" d
		..s DateOfCreate = $zd(DateOfCreate,3)
		.
		.Set tmp = PersonRowIdParref_"||"_ProblemRowId_"^"_ProblemName_"^"_ICD10_"^"_ICD10Name_"^"_Effection_"^"_DateOfStart_"^"_DateRegister_"^"_Register_"^"_RegisterName_"^"_REMARK_"^"_DateOfDeal_"^"_Deal_"^"_LapseTo_"^"_LapseToName_"^"_DateOfCreate
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.
		.
	    Set resultString = json.getJsonData("ProblemRowId^ProblemName^ICD10^ICD10Name^Effection^DateOfStart^DateRegister1^Register^RegisterName^REMARK^DateOfDeal^Deal^LapseTo^LapseToName^DateOfCreate",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: lyy
/// CreatDate：2009—06-16
/// Description:添加个人长期健康问题
/// Table：PersonLongTermProblem
/// Input: PersonLongTermProblem
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, ProblemName As %String, ICD10 As %Integer, Effection As %String, DateOfStart As %Date, DateRegister As %Date, Register As %Integer, REMARK As %String, DateOfDeal As %Date, Deal As %String, LapseTo As %Integer, DateOfCreate As %Date) As %String
{
  
	s tempProblem=""
	s tempProblem=##class(CHSS.PersonLongTermProblem).%New()
	q:(tempProblem="") 0
	
	i ICD10 '= "" d
	.s ReturnCode=..existProblem(ICD10,PersonRowId)
	.i (ReturnCode'="0") d
	..i ICD10 '= "" d
	...s ICD10Desc=##class(User.MRCICDDx).%OpenId(ICD10).MRCIDDesc
	...w "{""success"":""false"",""info"":""疾病ICD10: "_ICD10Desc_" 已存在! 请重新输入!""}"
	e  d
	
	.s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	.s tempProblem.PersonRowIdParref=PersonRowIdobj
	.
	.s tempProblem.ProblemName = ProblemName
	
	.i ICD10 '= "" d
	..s ICD10obj=##class(User.MRCICDDx).%OpenId(ICD10)
	..s tempProblem.ICD10=ICD10obj
	
	.s tempProblem.Effection = Effection
	

	.i DateOfStart '= "" d
	..s DateOfStart=$zdh(DateOfStart,3)
	.s tempProblem.DateOfStart=DateOfStart
	
	.i DateRegister '= "" d
	..s DateRegister=$zdh(DateRegister,3)
	.s tempProblem.DateRegister=DateRegister
	
	.i Register '= "" d
	..;s Registerobj=##class(User.SSUser).%OpenId(Register)
	..s tempProblem.Register=Register
		
	.s tempProblem.REMARK = REMARK
	
	.i DateOfDeal '= "" d
	..s DateOfDeal=$zdh(DateOfDeal,3)
	.s tempProblem.DateOfDeal=DateOfDeal
		
	.s tempProblem.Deal = Deal
	
	.i LapseTo '= "" d
	..s LapseToobj=##class(CHSS.DictLapseTo).%OpenId(LapseTo)
	..s tempProblem.LapseTo=LapseToobj
	
	.i DateOfCreate '= "" d
	..s DateOfCreate=$zdh(DateOfCreate,3)
	.s tempProblem.DateOfCreate=DateOfCreate
	

	.s result=""
    .s result=tempProblem.%Save()
    
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempProblem.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    ..
    q ""
}

/// Creator: lyy
/// CreatDate：2009—06-16
/// Description:更新个人长期健康问题
/// (注意：对于表字段多的情况采用这种对类赋值的方式，如果字段较少，可以直接采用SQL语句)
/// Table：PersonLongTermProblem
/// Input: ProblemRowId,PersonLongTermProblem
/// Output：
/// Return：
/// Others：
ClassMethod Update(PersonRowId As %Integer, ProblemRowId As %String, ProblemName As %String, ICD10 As %Integer, Effection As %String, DateOfStart As %Date, DateRegister As %Date, Register As %Integer, REMARK As %String, DateOfDeal As %Date, Deal As %String, LapseTo As %Integer, DateOfCreate As %Date) As %String
{
	q:($d(ProblemRowId)=0)||(ProblemRowId="")
	s tempProblem="",result=""
	s tempProblem=##class(CHSS.PersonLongTermProblem).%OpenId(ProblemRowId)
	q:(tempProblem="") 0
	
	i ICD10 '= "" d
	.s originalICD10 = tempProblem.ICD10.%Id()
	.s ReturnCode=..existProblem(ICD10,PersonRowId)
	.i (originalICD10'=ICD10)&&(ReturnCode'="0") d
	..i ICD10 '= "" d
	...s ICD10Desc=##class(User.MRCICDDx).%OpenId(ICD10).MRCIDDesc
	...w "{""success"":""false"",""info"":""疾病ICD10: "_ICD10Desc_" 已存在! 请重新输入!""}"
	
	e  d
	
    .s tempProblem.ProblemName=ProblemName
	
	.i ICD10 '= "" d
	..s ICD10obj=##class(User.MRCICDDx).%OpenId(ICD10)
	..s tempProblem.ICD10=ICD10obj
	
	.s tempProblem.Effection=Effection
	
	.i DateOfStart '= "" d
	..s DateOfStart=$zdh(DateOfStart,3)
	..s tempProblem.DateOfStart=DateOfStart
	
	.i DateRegister '= "" d
	..s DateRegister=$zdh(DateRegister,3)
	..s tempProblem.DateRegister=DateRegister
	
	.i Register '= "" d
	..;s Registerobj=##class(User.SSUser).%OpenId(Register)
	..s tempProblem.Register=Register
    
    .s tempProblem.REMARK = REMARK
    .
    .i DateOfDeal '= "" d
	..s DateOfDeal=$zdh(DateOfDeal,3)
	.s tempProblem.DateOfDeal=DateOfDeal
		
	.s tempProblem.Deal = Deal
	
	.i LapseTo '= "" d
	..s LapseToobj=##class(CHSS.DictLapseTo).%OpenId(LapseTo)
	..s tempProblem.LapseTo=LapseToobj
	
	.i DateOfCreate '= "" d
	..s DateOfCreate=$zdh(DateOfCreate,3)
	.s tempProblem.DateOfCreate=DateOfCreate
	
	
	.s result=""
	.s result=tempProblem.%Save()
	.i result = "1" d
    ..w "{""success"":""true"",""info"":"_ProblemRowId_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    ..
    q ""
}

//判断code是否存在,-1入参为空，1重复，0不重复

ClassMethod existProblem(ICD10 As %Integer, PersonRowId As %Integer) As %String
{
	q:ICD10="" "-1"
	q:PersonRowId="" "-1"
	q:$d(^CHSS.PersonLongTermProblemI("ICD10Index",ICD10,PersonRowId)) "1"
	q "0"
}

/// Creator: lyy
/// CreatDate：2009—06-18
/// Description:删除个人长期健康问题
/// Table：PersonLongTermProblem
/// Input: ProblemRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(ProblemRowId As %String) As %String
{
	&sql(delete from CHSS.PersonLongTermProblem where %ID=:ProblemRowId)
	s result=SQLCODE
	i result = "0" d
    .w "{""success"":""true"",""info"":"_ProblemRowId_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错!""}"
	///q SQLCODE
	///
	q ""
}

Storage Default
{
<Data name="PersonLongTermProblemServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonLongTeB41D</DataLocation>
<DefaultData>PersonLongTermProblemServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonLongTeB41D</IdLocation>
<IndexLocation>^CHSSWeb.PersonLongTeB41I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonLongTeB41S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
