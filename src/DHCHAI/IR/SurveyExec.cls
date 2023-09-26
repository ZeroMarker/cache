/// 名称: DHCHAI.IR.SurveyExec
/// 描述: 横断面调查方法执行登记表 (配置)
/// 编写者：chenjb
/// 编写日期: 2017-12-28
Class DHCHAI.IR.SurveyExec Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查编号
Property SESurvNumber As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医院：可选择多个院区
Property SEHospDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查方法: 1 全院统一开展 2 分科依次开展
Property SESurvMethod As %String(MAXLEN = 10, TRUNCATE = 1);

/// 调查开始日期
Property SESurvSttDate As %Date;

/// 调查结束日期
Property SESurvEndDate As %Date;

/// 更新日期
Property SEUpdateDate As %Date;

/// 更新时间
Property SEUpdateTime As %Time;

/// 处置人
Property SEUpdateUserDr As DHCHAI.BT.SysUser;

/// 备注
Property SEResume As %String(MAXLEN = 100, TRUNCATE = 1);

Index SurvNumber On SESurvNumber As Exact;

/// w ##class(DHCHAI.IR.SurveyExec).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.SurveyExec
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCHAI.IR.SurveyExec).%ExistsId(+id) return
	set obj=##Class(DHCHAI.IR.SurveyExec).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCHAI.IR.SurveyExec).GetObjBySurvNumber("201312240001")
ClassMethod GetObjBySurvNumber(aSurvNumber As %String) As DHCHAI.IR.SurveyExec
{
	new (aSurvNumber)
	set return=""
	quit:aSurvNumber="" return
	set ID=$o(^DHCHAI.IR.SurveyExecI("SurvNumber"," "_aSurvNumber,0))
	quit:ID="" return
	set return=##class(DHCHAI.IR.SurveyExec).GetObjById(ID)
	quit return
}

/// w ##class(DHCHAI.IR.SurveyExec).GetSurvMethod("201312240001")
ClassMethod GetSurvMethod(aSurvNumber As %String) As %String
{
	new (aSurvNumber)
	set return=""
	quit:aSurvNumber="" return
	set ID=$o(^DHCHAI.IR.SurveyExecI("SurvNumber"," "_aSurvNumber,0))
	quit:ID="" return
	set obj=##class(DHCHAI.IR.SurveyExec).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.SESurvMethod
	quit return
}

/// w ##class(DHCHAI.IR.SurveyExec).GetSurvHospital("1")
ClassMethod GetSurvHospital(aID As %String) As %String
{
	new (aID)
	set return=""
	quit:aID="" return
	set obj=##class(DHCHAI.IR.SurveyExec).GetObjById(aID)
	quit:'$IsObject(obj) return
	set return=obj.SEHospDr
	quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-12-02
/// input: InStr="ID^SEHospDr^SESurvMethod^SESurvSttDate^SESurvEndDate^SEUpdateUser^SEResume"
/// w ##Class(DHCHAI.IR.SurveyExec).Update("^,1,2,3^^2020-03-01^2020-03-01^1197^")
ClassMethod Update(InStr As %String) As %String
{

	new (InStr)
	set return=0
	quit:InStr="" return

	set HospitalDr=$p(InStr,"^",2)
	Set:HospitalDr'="" HospitalDr=$tr(HospitalDr,",","|")
	set SurvMethod=$p(InStr,"^",3)
	set SttDate=$p(InStr,"^",4)
	;set:SttDate'="" SttDate=$zdh(SttDate,3)
	set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SttDate)
	set EndDate=$p(InStr,"^",5)
	;set:EndDate'="" EndDate=$zdh(EndDate,3)
	set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	set UpdateUser=$p(InStr,"^",6)
	set Resume=$p(InStr,"^",7)
	
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCHAI.IR.SurveyExec).%New()
		set tmpID=$o(^DHCHAI.IR.SurveyExecD(""),-1)+1
		set obj.SESurvNumber=$tr($zd(+$h,3),"-","")_$tr($justify(tmpID,4)," ",0)
	} else {
		set obj=##class(DHCHAI.IR.SurveyExec).%OpenId(ID)
	}
	
	set obj.SEHospDr=HospitalDr
	set obj.SESurvMethod=SurvMethod
	set obj.SESurvSttDate=SttDate
	set obj.SESurvEndDate=EndDate
	set obj.SEUpdateDate=+$h
	set obj.SEUpdateTime=$p($h,",",2)
	set obj.SEUpdateUserDr=##class(DHCHAI.BT.SysUser).GetObjById(UpdateUser)
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
	Set sc = ##class(DHCHAI.IR.SurveyExec).%DeleteId(aId)
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
<Data name="SurveyExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SESurvNumber</Value>
</Value>
<Value name="3">
<Value>SEHospDr</Value>
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
<Value>SEUpdateUserDr</Value>
</Value>
<Value name="10">
<Value>SEResume</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.SurveyExecD</DataLocation>
<DefaultData>SurveyExecDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.SurveyExecD</IdLocation>
<IndexLocation>^DHCHAI.IR.SurveyExecI</IndexLocation>
<StreamLocation>^DHCHAI.IR.SurveyExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
