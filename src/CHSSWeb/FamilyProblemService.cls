Class CHSSWeb.FamilyProblemService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—12-02
/// Description:根据家庭档案编码检索家庭主要问题
/// Table：FamilyProblem
/// Input:FamilyRowIdParref , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod FamilyProblemList(FamilyRowIdParref As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
		n (FamilyRowIdParref, start, limit, sort)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set ProblemRowId = 0
		
		For  Set ProblemRowId=$O(^CHSS.FamilyProblemI("FamilyRowIdParrefIndex",FamilyRowIdParref,ProblemRowId)) q:ProblemRowId=""  d
		.s tempProblem=##class(CHSS.FamilyProblem).%OpenId(ProblemRowId)
		.s ProblemName = tempProblem.ProblemName
		.
		.
		.s DateOfStart = tempProblem.DateOfStart
		.i DateOfStart '= "" d
	    ..s DateOfStart=$zd(DateOfStart,3)
	    ..
	    .s DateOfDeal = tempProblem.DateOfDeal
		.i DateOfDeal '= "" d
	    ..s DateOfDeal=$zd(DateOfDeal,3)
	    .
	    .s Deal = tempProblem.Deal
	    .s Vest = tempProblem.Vest
	    .
	    .s DateRegister = tempProblem.DateRegister
		.i DateRegister '= "" d
	    ..s DateRegister=$zd(DateRegister,3)
	    ..
		.set RegisterName = ""
		.set Register = ""
		.i tempProblem.Register '= "" d
		..s Register = tempProblem.Register
		..s RegisterName = tempProblem.Register
		.
		.s REMARK = tempProblem.REMARK
		.
		.
		.Set tmp= ProblemRowId_"^"_FamilyRowIdParref_"^"_ProblemName_"^"_DateOfStart_"^"_DateOfDeal_"^"_Deal_"^"_Vest_"^"_DateRegister_"^"_Register_"^"_RegisterName_"^"_REMARK
	    .
	    .Set count=count+1
		.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		s resultColumn = "ProblemRowId^FamilyRowIdParref^ProblemName^DateOfStart^DateOfDeal^Deal^Vest^DateRegister^Register^RegisterName^REMARK"
	    Set resultString = json.getJsonData(resultColumn,count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009-12-03
/// Description:添加家庭主要问题
/// Table：FamilyProblem
/// Input: FamilyRowIdParref
/// Output：
/// Return：
/// Others：
ClassMethod Insert(ProblemRowId As %Integer, FamilyRowIdParref As %Integer, ProblemName As %String, DateOfStart As %Date, DateOfDeal As %Date, Deal As %String, Vest As %String, DateRegister As %Date, Register As %Integer, REMARK As %String) As %String
{
      s tempProblem=""
      s tempProblem=##class(CHSS.FamilyProblem).%New()
      q:(tempProblem="") 0
      
	  
      s FamilyRowIdParrefobj=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowIdParref)
      s tempProblem.FamilyRowIdParref=FamilyRowIdParrefobj
      
      s tempProblem.ProblemName = ProblemName
      
      i DateOfStart '= "" d
      .s DateOfStart=$zdh(DateOfStart,3)
      s tempProblem.DateOfStart = DateOfStart
      
      i DateOfDeal '= "" d
      .s DateOfDeal=$zdh(DateOfDeal,3)
      s tempProblem.DateOfDeal = DateOfDeal
      
      s tempProblem.Deal = Deal
      s tempProblem.Vest = Vest
      
      i DateRegister '= "" d
      .s DateRegister=$zdh(DateRegister,3)
      s tempProblem.DateRegister = DateRegister

	  i Register '= "" d
	  .;s RegisterObj = ##class(User.SSUser).%OpenId(Register)
	  .s tempProblem.Register = Register
	  
      s tempProblem.REMARK = REMARK
      
      s result=""
      s result=tempProblem.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempProblem.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempProblem.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: wangbo
/// CreatDate：2009-12-03
/// Description:修改家庭主要问题
/// Table：FamilyProblem
/// Input: FamilyRowIdParref
/// Output：
/// Return：
/// Others：
ClassMethod Update(ProblemRowId As %Integer, FamilyRowIdParref As %Integer, ProblemName As %String, DateOfStart As %Date, DateOfDeal As %Date, Deal As %String, Vest As %String, DateRegister As %Date, Register As %Integer, REMARK As %String) As %String
{
      s tempProblem=""
      s tempProblem=##class(CHSS.FamilyProblem).%OpenId(ProblemRowId)
      q:(tempProblem="") 0
      
	  
      s FamilyRowIdParrefobj=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowIdParref)
      s tempProblem.FamilyRowIdParref=FamilyRowIdParrefobj
      
      s tempProblem.ProblemName = ProblemName
      
      i DateOfStart '= "" d
      .s DateOfStart=$zdh(DateOfStart,3)
      s tempProblem.DateOfStart = DateOfStart
      
      i DateOfDeal '= "" d
      .s DateOfDeal=$zdh(DateOfDeal,3)
      s tempProblem.DateOfDeal = DateOfDeal
      
      s tempProblem.Deal = Deal
      s tempProblem.Vest = Vest
      
      i DateRegister '= "" d
      .s DateRegister=$zdh(DateRegister,3)
      s tempProblem.DateRegister = DateRegister

	  i Register '= "" d
	  .;s RegisterObj = ##class(User.SSUser).%OpenId(Register)
	  .s tempProblem.Register = Register
	  
      s tempProblem.REMARK = REMARK
      
      s result=""
      s result=tempProblem.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempProblem.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempProblem.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

ClassMethod Delete(ProblemRowId) As %String
{
	q:(ProblemRowId = "") ""
	s tempProblem=##class(CHSS.FamilyProblem).%OpenId(ProblemRowId)
	q:(tempProblem="") ""
	
	s result=tempProblem.%DeleteId(ProblemRowId)
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

Storage Default
{
<Data name="FamilyProblemServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FamilyProblemServiceD</DataLocation>
<DefaultData>FamilyProblemServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FamilyProblemServiceD</IdLocation>
<IndexLocation>^CHSSWeb.FamilyProblemServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.FamilyProblemServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
