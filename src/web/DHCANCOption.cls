Class web.DHCANCOption Extends %Persistent
{

/// eg. D ##class(%ResultSet).RunQuery("web.DHCANCOption","FindOptions","Cardiovascular")
Query FindOptions(type, queryRowId) As %Query(ROWSPEC = "rowId:%Integer,code,desc") [ SqlProc ]
{
}

ClassMethod FindOptionsExecute(ByRef qHandle As %Binary, type As %String, queryRowId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	//s queryRowId=""
	
	If $g(ind)="" Set ind=1
	//i queryRowId=$c(0) s queryRowId=""
	i type'="" d Find	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
Find
	s mainId=""
	s mainId=$O(^User.DHCANCOptionI("CodeIndex",type,mainId))
	s sub="" f  s sub=$O(^User.DHCANCOptionItemI("TypeIdIndex",mainId,sub)) q:sub=""  d
	.q:((queryRowId'="")&&(sub'=queryRowId))
	.s rowId=sub
	.s item=##class(User.DHCANCOptionItem).%OpenId(sub)
	.
	.s code=item.Code
	.s desc=item.Name
	.d OutputRow
	q 
OutputRow          
	set Data=$lb(rowId,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOptionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANOptionsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOptionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANOptionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// eg. D ##class(%ResultSet).RunQuery("web.DHCANCOption","GetOptionType")
Query GetOptionType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowId:%Integer,code,desc")
{
	SELECT ID ,Code,Name FROM SQLUser.DHC_ANC_Option
}

/// Creator: 唐潇
/// CreatDate: 2017-05-26
/// Description: 运行下拉码表
/// Table：DHC_ANC_OptionItem ,DHC_ANC_Option
/// Input：
/// Return：
/// Debug:d ##class(web.DHCANCOption).RunMutiCode()
ClassMethod RunMutiCode()
{
	/*中国医大术前码表
	w ##class(User.DHCANCOptionItem).AddItemByString("CommunicateZgydnf","沟通障碍","无;语言;听力损伤;视力损伤")
  	w ##class(User.DHCANCOptionItem).AddItemByString("PsycholAssessmentZgydnf","心理状况","健康;焦虑;烦躁不安;痴呆;昏迷")
	w ##class(User.DHCANCOptionItem).AddItemByString("DietZgydnf","饮食状况","正常进食;软食;流食;禁食;其它")
 	w ##class(User.DHCANCOptionItem).AddItemByString("MotionZgydnf","运动状况","正常行走;协助行走;轮椅;卧床")
	w ##class(User.DHCANCOptionItem).AddItemByString("ProsthesisZgydnf","假体安置","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("ImplantsZgydnf","体内植入物","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("AllergenZgydnf","已知过敏原","否;是;食物;药物;其它")
	w ##class(User.DHCANCOptionItem).AddItemByString("InfectedZgydnf","感染情况","否;是;甲肝;乙肝;丙肝;戊肝;结核;耐药值;其它")
	w ##class(User.DHCANCOptionItem).AddItemByString("FalseTeethZgydnf","假牙","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("PressureSoreZgydnf","压疮","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("MenstrualPeriodZgydnf","月经期","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("HeartDiseaseZgydnf","心脏病","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("CerebrovascularZgydnf","脑血管疾病","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("HypertensionZgydnf","高血压","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("EpilepsyZgydnf","癫痫","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("RespSystemZgydnf","呼吸系统疾病","否;是;哮喘;慢阻肺;其它")
	w ##class(User.DHCANCOptionItem).AddItemByString("DiabetesZgydnf","糖尿病","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("HyperthyroidismZgydnf","甲亢","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("PreOperationZgydnf","手术史","否;是")
	*/
	/*中国医大术后码表
	w ##class(User.DHCANCOptionItem).AddItemByString("WhereaboutsZgydna","病人去向","病房;ICU;出院")
	w ##class(User.DHCANCOptionItem).AddItemByString("VisitTypeZgydna","访视类型","电话访视;面对面访视;询问家属")
	w ##class(User.DHCANCOptionItem).AddItemByString("PostOpDateZgydna","术后日期","一天;两天;三天;四天;五天")
	w ##class(User.DHCANCOptionItem).AddItemByString("DiscomfortZgydna","有无不适","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("PainZgydna","药物疼痛","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("SwollenZgydna","红肿","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("DressingZgydna","敷料","是;否")
	w ##class(User.DHCANCOptionItem).AddItemByString("DietZgydna","饮食","正常;软食;流食;禁食")
	w ##class(User.DHCANCOptionItem).AddItemByString("MotionZgydna","正常活动","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("NauseaZgydna","恶心呕吐","否;是")
	w ##class(User.DHCANCOptionItem).AddItemByString("ComplicationZgydna","不适症状","发烧;嗜睡;头痛;喉咙痛;肌肉酸痛;皮肤瘙痒;压疮")
	w ##class(User.DHCANCOptionItem).AddItemByString("EvaluateZgydna","满意度","非常满意;满意;不满意")
	*/
}

Storage Default
{
<Data name="DHCANCOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCANCOptionD</DataLocation>
<DefaultData>DHCANCOptionDefaultData</DefaultData>
<IdLocation>^web.DHCANCOptionD</IdLocation>
<IndexLocation>^web.DHCANCOptionI</IndexLocation>
<StreamLocation>^web.DHCANCOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
