/// 名称: DHCMed.NINF.CSS.SurveyExec
/// 描述: 横断面调查方法执行登记表
/// 编写者：maxp
/// 编写日期: 2013-12-02
Class DHCMed.NINF.CSS.SurveyExec Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查编号
Property SESurvNumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SE_SurvNumber ];

/// 医院ID 指向CT_Hospital
Property SEHospCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SE_HospCode ];

/// 调查方法: 全院统一开展/分科依次开展
Property SESurvMethod As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SE_SurvMethod ];

/// 调查开始日期
Property SESurvSttDate As %Date [ SqlColumnNumber = 5, SqlFieldName = SE_SurvSttDate ];

/// 调查结束日期
Property SESurvEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SE_SurvEndDate ];

/// 生成日期
Property SEUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = SE_UpdateDate ];

/// 生成时间
Property SEUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = SE_UpdateTime ];

/// 操作员 指向SS_User
Property SEUpdateUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SE_UpdateUser ];

/// 备注
Property SEResume As %String(MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = SE_Resume ];

Index SurvNumber On SESurvNumber;

/// w ##class(DHCMed.NINF.CSS.SurveyExec).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.CSS.SurveyExec
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.CSS.SurveyExec).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.CSS.SurveyExec).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCMed.NINF.CSS.SurveyExec).GetObjBySurvNumber("201312240001")
ClassMethod GetObjBySurvNumber(aSurvNumber As %String) As DHCMed.NINF.CSS.SurveyExec
{
	new (aSurvNumber)
	set return=""
	quit:aSurvNumber="" return
	set ID=$o(^DHCMed.NINF.CSSi("SE","SurvNumber"," "_aSurvNumber,0))
	quit:ID="" return
	set return=##class(DHCMed.NINF.CSS.SurveyExec).GetObjById(ID)
	quit return
}

/// w ##class(DHCMed.NINF.CSS.SurveyExec).GetSurvMethod("201312240001")
ClassMethod GetSurvMethod(aSurvNumber As %String) As %String
{
	new (aSurvNumber)
	set return=""
	quit:aSurvNumber="" return
	set ID=$o(^DHCMed.NINF.CSSi("SE","SurvNumber"," "_aSurvNumber,0))
	quit:ID="" return
	set obj=##class(DHCMed.NINF.CSS.SurveyExec).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.SESurvMethod
	quit return
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// input: InStr="ID^HospDR^SESurvMethod^SESurvSttDate^SESurvEndDate^SEUpdateUser^SEResume"
/// w ##Class(DHCMed.NINF.CSS.SurveyExec).Update("")
ClassMethod Update(InStr As %String) As %String
{

	new (InStr)
	set return=0
	quit:InStr="" return
	
	set HospCode=""
	set HospitalDr=$p(InStr,"^",2)
	set SurvMethod=$p(InStr,"^",3)
	set SttDate=$p(InStr,"^",4)
	;set:SttDate'="" SttDate=$zdh(SttDate,3)
	set:SttDate'="" SttDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SttDate)
	set EndDate=$p(InStr,"^",5)
	;set:EndDate'="" EndDate=$zdh(EndDate,3)
	set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EndDate)
	set UpdateUser=$p(InStr,"^",6)
	set Resume=$p(InStr,"^",7)
	
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.NINF.CSS.SurveyExec).%New()
		set tmpID=$o(^DHCMed.NINF.CSS("SE",""),-1)+1
		set obj.SESurvNumber=$tr($zd(+$h,3),"-","")_$tr($justify(tmpID,4)," ",0)
	} else {
		set obj=##class(DHCMed.NINF.CSS.SurveyExec).%OpenId(ID)
	}
	
	set obj.SEHospCode=HospitalDr
	set obj.SESurvMethod=SurvMethod
	set obj.SESurvSttDate=SttDate
	set obj.SESurvEndDate=EndDate
	set obj.SEUpdateDate=+$h
	set obj.SEUpdateTime=$p($h,",",2)
	set obj.SEUpdateUser=UpdateUser
	set obj.SEResume=Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// Description:  删除
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(DHCMed.NINF.CSS.SurveyExec).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SESurvNumber</Value>
</Value>
<Value name="3">
<Value>SEHospCode</Value>
</Value>
<Value name="4">
<Value>SESurvMethod</Value>
</Value>
<Value name="5">
<Value>SESurvSttDate</Value>
</Value>
<Value name="6">
<Value>SESurvEndDate</Value>
</Value>
<Value name="7">
<Value>SEUpdateDate</Value>
</Value>
<Value name="8">
<Value>SEUpdateTime</Value>
</Value>
<Value name="9">
<Value>SEUpdateUser</Value>
</Value>
<Value name="10">
<Value>SEResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.CSS("SE")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.CSS("SE")</IdLocation>
<IndexLocation>^DHCMed.NINF.CSSi("SE")</IndexLocation>
<StreamLocation>^DHCMed.NINF.CSS.SurveyExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
