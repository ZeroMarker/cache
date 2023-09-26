/// 名称: DHCMA.CPW.CP.PatStsSvyDtl
/// 描述: 患者满意度调查明细
/// 编写者：yankai
/// 编写日期: 2021-12-14
Class DHCMA.CPW.CP.PatStsSvyDtl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 父表结果类
Relationship Parref As DHCMA.CPW.CP.PatStsSvy [ Cardinality = parent, Inverse = ChildDtl ];

/// 题目指针
Property SSItemDr As DHCMA.CPW.BT.SurveyQuestion [ Required ];

/// 本题得分
Property SSItemScore As %Integer;

/// 答案选项（单选、多选、判断记录）(多值逗号分隔)
Property SSOptionDr As %String;

/// 答案文本（回答类问题）
Property SSAnswerTxt As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IdxofParref On Parref;

Index IdxofPItem On (Parref, SSItemDr);

/// w ##class(DHCMA.CPW.CP.PatStsSvyDtl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PatStsSvyDtl
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PatStsSvyDtl).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PatStsSvyDtl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.CP.PatStsSvyDtl).Update("38^^^0^^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^zqy88=aInputStr
	Set Parref   	= $p(aInputStr,aSeparete,1)   
	Set ID       	= $p(aInputStr,aSeparete,2)       ///获取数据（表的字段）
	Set ItemDr 	 	= $p(aInputStr,aSeparete,3)
	Set ItemScore   = $p(aInputStr,aSeparete,4)
	Set Option   	= $p(aInputStr,aSeparete,5)
	Set AnswerTxt   = $p(aInputStr,aSeparete,6)

	Set objPatStsSvy  = ##class(DHCMA.CPW.CP.PatStsSvy).GetObjById(Parref)
	Quit:'$Isobject(objPatStsSvy) -1
	Set:ItemDr["," ItemDr=$p(ItemDr,",",1)
	Set:ItemDr["-" ItemDr=$Replace(ItemDr,"-","||")
	Set:$l(ItemDr,"||")=3 ItemDr=$p(ItemDr,"||",1,2)
	Set:Option["-" Option=$Replace(Option,"-","||")
	Set objQuestion  = ##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(ItemDr)
	Quit:'$Isobject(objQuestion) -2
	If ($d(^DHCMA.CPW.CP.PatStsSvyI("DTL","IdxofPItem",Parref,ItemDr)))
	{
		Set ID=$o(^DHCMA.CPW.CP.PatStsSvyI("DTL","IdxofPItem",Parref,ItemDr,""),-1)
		Set obj=##class(DHCMA.CPW.CP.PatStsSvyDtl).%OpenId(Parref_"||"_ID)
	}else{
		Set obj=##class(DHCMA.CPW.CP.PatStsSvyDtl).%New()
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			= objPatStsSvy      //写入数据
	Set obj.SSItemDr		= objQuestion
	Set obj.SSItemScore		= ItemScore
	Set obj.SSOptionDr		= Option
	Set obj.SSAnswerTxt		= AnswerTxt
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.CP.PatStsSvyDtl).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.CP.PatStsSvyDtl).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="PatStsSvyDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSItemDr</Value>
</Value>
<Value name="3">
<Value>SSItemScore</Value>
</Value>
<Value name="4">
<Value>SSOptionDr</Value>
</Value>
<Value name="5">
<Value>SSAnswerTxt</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>PatStsSvyDtlDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PatStsSvyI("DTL")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PatStsSvyDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
