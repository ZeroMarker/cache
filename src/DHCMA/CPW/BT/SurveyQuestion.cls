/// 名称: DHCMA.CPW.BT.SurveyQuestion
/// 描述: 调查表问题类
/// 编写者：yankai
/// 编写日期: 2021-12-14
Class DHCMA.CPW.BT.SurveyQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 父表试卷类
Relationship Parref As DHCMA.CPW.BT.Survey [ Cardinality = parent, Inverse = ChildQst ];

/// 子表题目选项
Relationship ChildOpt As DHCMA.CPW.BT.SurveyOption [ Cardinality = children, Inverse = ParrefQst ];

/// 题目序号
Property SQItemNo As %Integer [ Required ];

/// 题目描述
Property SQItemDesc As %String [ Required ];

/// 题目类型(单选/多选/问答/判断)
Property SQItemType As DHCMA.Util.BT.Dictionary [ Required ];

/// 本题分值
Property SQItemScore As %Integer;

/// 备注
Property SQItemResume As %String;

Index IdxofPItemNo On (Parref, SQItemNo);

Index IdxofPItemType On (Parref, SQItemType);

/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.SurveyQuestion
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.SurveyQuestion).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.SurveyQuestion).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.SurveyQuestion).Update("1^^1^1+1^439^1^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^zqy22=aInputStr
	Set Parref     = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set ID    	   = $p(aInputStr,aSeparete,2)
	Set ItemNo     = $p(aInputStr,aSeparete,3)
	Set ItemDesc   = $p(aInputStr,aSeparete,4)
	Set ItemType   = $p(aInputStr,aSeparete,5)
	Set ItemScore  = $p(aInputStr,aSeparete,6)
	Set ItemResume = $p(aInputStr,aSeparete,7)
	Set objSurvey  = ##class(DHCMA.CPW.BT.Survey).GetObjById(Parref)
	Set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(ItemType)
	Quit:(('$Isobject(objSurvey))||('$Isobject(objType)))
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.SurveyQuestion).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.SurveyQuestion).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       	= objSurvey
	Set obj.SQItemNo		= ItemNo      //写入数据
	Set obj.SQItemDesc		= ItemDesc
	Set obj.SQItemType		= objType
	Set obj.SQItemScore		= ItemScore
	Set obj.SQItemResume	= ItemResume
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
/// w ##class(DHCMA.CPW.BT.SurveyQuestion).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.SurveyQuestion).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.BT.SurveyQuestion).GetScoreByID("1-13")
ClassMethod GetScoreByID(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set:aID["-" aID=$Replace(aID,"-","||")
	Set obj=..GetObjById(aID)
	Quit:'$IsObject(obj)
	Set Score=obj.SQItemScore
	Set:Score="" Score=0
	Set return=Score
	Quit return
}

/// w ##class(DHCMA.CPW.BT.SurveyQuestion).CheckSQItemNo("1","1")
ClassMethod CheckSQItemNo(aItem As %String, Parref As %String = "") As %String
{
	New (aItem,Parref)
	Set return="1"
	Quit:(aItem="") return
	
	If ($d(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",Parref,aItem)))
	{
		Set return=1
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="SurveyQuestionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SQItemNo</Value>
</Value>
<Value name="3">
<Value>SQItemDesc</Value>
</Value>
<Value name="4">
<Value>SQItemType</Value>
</Value>
<Value name="5">
<Value>SQItemScore</Value>
</Value>
<Value name="6">
<Value>SQItemResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QST")</DataLocation>
<DefaultData>SurveyQuestionDefaultData</DefaultData>
<IdLocation>{%%PARENT}("QST")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.SurveyI("QST")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.SurveyQuestionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
