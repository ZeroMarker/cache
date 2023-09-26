/// 名称: DHCMA.CPW.BT.Survey
/// 描述: 调查表/试卷类
/// 编写者：yankai
/// 编写日期: 2021-12-15
Class DHCMA.CPW.BT.Survey Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 子表题目类
Relationship ChildQst As DHCMA.CPW.BT.SurveyQuestion [ Cardinality = children, Inverse = Parref ];

/// 代码
Property SQCode As %String [ Required ];

/// 标题
Property SQTitle As %String [ Required ];

/// 试卷总分
Property SQScore As %String;

/// 说明
Property SQResume As %String;

Index IdxofCode On SQCode;

/// w ##class(DHCMA.CPW.BT.Survey).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.Survey
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.Survey).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.Survey).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.Survey).Update("^1^1^1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return

	Set ID       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set Resume   = $p(aInputStr,aSeparete,4)
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.Survey).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.Survey).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.SQCode			= Code      //写入数据
	Set obj.SQTitle			= Desc
	Set obj.SQResume		= Resume
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	//数据院区关联处理 add by yankai20210803
	If (+return>0)&&(aHospID'=""){
		Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
		If (ret="Y")||(ret=1){
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.Survey",return,aHospID)	
		}
	}
	Quit return
}

/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.Survey).DeleteById(3)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set sc = ##class(DHCMA.CPW.BT.Survey).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.Survey",aId,aHospID)
			}
		}
	}
	Quit return
}

/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.Survey).CheckSQCode("010")
ClassMethod CheckSQCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.SurveyI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.SurveyI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// 获取第一张问卷Code
/// w ##class(DHCMA.CPW.BT.Survey).GetSQCode()
ClassMethod GetSQCode() As %String
{
	Set return=""
	Set xId=$o(^DHCMA.CPW.BT.SurveyD(""),1)
	Set obj=..GetObjById(xId)
	Quit:'$IsObject(obj) return
	Quit obj.SQCode
}

Storage Default
{
<Data name="SurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SQCode</Value>
</Value>
<Value name="3">
<Value>SQTitle</Value>
</Value>
<Value name="4">
<Value>SQScore</Value>
</Value>
<Value name="5">
<Value>SQResume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.SurveyD</DataLocation>
<DefaultData>SurveyDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.SurveyD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.SurveyI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.SurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
