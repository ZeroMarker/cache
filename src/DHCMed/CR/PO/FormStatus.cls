/// 名称: DHCMed.CR.PO.FormStatus
/// 描述: 自定义表单状态列表
/// 编写者：wuqk
/// 编写日期: 2012-12-18
Class DHCMed.CR.PO.FormStatus Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock ]
{

Relationship Form As DHCMed.CR.PO.Form [ Cardinality = parent, Inverse = StatusList ];

//状态代码

Property StatusCode As %String(MAXLEN = 20, TRUNCATE = 1);

//状态名称

Property StatusName As %String(MAXLEN = 20, TRUNCATE = 1);

//是否提交数据

Property IsSubmitData As %Boolean;

//是否校验数据

Property IsCheckData As %Boolean;

Index IndexStuCode On (StatusCode, Form);

///  Creator：     mxp
///  CreatDate：   2013-01-05
///  Description:  更新表单状态列表
///  Table：       DHCMed.CR.PO.FormStatus
///  Input：       formId,statusCode
///  Return：      
///  w ##class(DHCMed.CR.PO.FormStatus).UpdateStatus(14,"02^审核^0^0")
ClassMethod UpdateStatus(formId, StatusStr)
{
	
	new (formId,StatusStr)
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) -1
	
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(+formId)
	set StatusCode=$p(StatusStr,"^",1)
	if $d(^DHCMed.CR.PO.FormI("StatusList","IndexStuCode"," "_StatusCode,formId)) {
		s StatusId=$o(^DHCMed.CR.PO.FormI("StatusList","IndexStuCode"," "_StatusCode,formId,""))
		set objFormStatus = ##class(DHCMed.CR.PO.FormStatus).%OpenId(formId_"||"_StatusId)
	}
	else {
		set objFormStatus = ##class(DHCMed.CR.PO.FormStatus).%New()	
		}
	Quit:'$IsObject(objFormStatus) -2
	set objFormStatus.StatusCode = StatusCode
	set objFormStatus.StatusName = $p(StatusStr,"^",2)
	set objFormStatus.IsSubmitData = $p(StatusStr,"^",3)
	set objFormStatus.IsCheckData = $p(StatusStr,"^",4)
	set objFormStatus.Form = objForm
	set sc = objFormStatus.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set return=-3
	}
	else{
		Set return=objFormStatus.%Id()
	}
	quit return
}

/// Creator：     mxp
/// CreatDate：   2013-1-9
/// Description:  根据状态Id删除表单状态
/// Table：       DHCMed.CR.PO.FormStatus
/// Input：       状态Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CR.PO.FormStatus).DeleteById("1||3")
ClassMethod DeleteById(formStaId)
{
	new (formStaId)
	set sc = ##class(DHCMed.CR.PO.FormStatus).%DeleteId(formStaId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     mxp
/// CreatDate：   2013-5-3
/// Description:  根据状态代码删除表单状态
/// Table：       DHCMed.CR.PO.FormStatus
/// Input：       状态代码
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CR.PO.FormStatus).DeleteByStaCode("00",2)
ClassMethod DeleteByStaCode(StatusCode, formId)
{
	s formStaId=$o(^DHCMed.CR.PO.FormI("StatusList","IndexStuCode"," "_StatusCode,formId,""))
	set ret=##class(DHCMed.CR.PO.FormStatus).DeleteById(formId_"||"_formStaId)
	quit ret
}

/// Creator：     maxp
/// CreatDate：   2013-01-09
/// Description:  通过表单id查询表单状态列表
/// Table：       DHCMed.CR.PO.FormStatus
/// Input:		  formId:表单id
/// Output:       
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.PO.FormStatus","QueryFormStatus",15)
Query QueryFormStatus(formId As %String) As %Query(ROWSPEC = "FormStaID:%String,StatusCode:%String,StatusName:%String,IsSubmitData:%Boolean,IsCheckData:%Boolean")
{
}

ClassMethod QueryFormStatusExecute(ByRef qHandle As %Binary, formId As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) $$$OK
 	s ChildSub=0
 	f  s ChildSub=$o(^DHCMed.CR.PO.FormD(formId,"StatusList",ChildSub)) q:ChildSub=""  d
 	.s objFormStatus=##class(DHCMed.CR.PO.FormStatus).%OpenId(formId_"||"_ChildSub)
 	.i $IsObject(objFormStatus) d
 	..s $li(data,1)=formId_"||"_ChildSub
 	..s $li(data,2)=objFormStatus.StatusCode
 	..s $li(data,3)=objFormStatus.StatusName
 	..s $li(data,4)=objFormStatus.IsSubmitData
 	..s $li(data,5)=objFormStatus.IsCheckData
 	..s ^CacheTemp(repid,ind)=data
    ..s ind=ind+1
    do objFormStatus.%Close()
	Quit $$$OK
}

ClassMethod QueryFormStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFormStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryFormStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFormStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)
	Quit $$$OK
}

Storage Default
{
<Data name="FormStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>StatusCode</Value>
</Value>
<Value name="4">
<Value>StatusName</Value>
</Value>
<Value name="5">
<Value>IsSubmitData</Value>
</Value>
<Value name="6">
<Value>IsCheckData</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("StatusList")</DataLocation>
<DefaultData>FormStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("StatusList")</IdLocation>
<IndexLocation>^DHCMed.CR.PO.FormI("StatusList")</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.FormStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
