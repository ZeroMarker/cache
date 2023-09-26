/// 名称: DHCMA.CPW.BT.SurveyOption
/// 描述: 调查表选项类
/// 编写者：yankai
/// 编写日期: 2021-12-14
Class DHCMA.CPW.BT.SurveyOption Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 父表题干类
Relationship ParrefQst As DHCMA.CPW.BT.SurveyQuestion [ Cardinality = parent, Inverse = ChildOpt ];

/// 选项序号
Property SQOptionNo As %Integer [ Required ];

/// 选项描述
Property SQOptionDesc As %String [ Required ];

/// 本项分值
Property SQOptionScore As %Integer;

Index IdxofPQst On ParrefQst;

Index IdxofPOptionNo On (ParrefQst, SQOptionNo);

/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.SurveyOption).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.SurveyOption
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.SurveyOption).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.SurveyOption).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.SurveyOption).Update("1||2^^1^11^1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set Parref       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set ID    	     = $p(aInputStr,aSeparete,2)
	Set OptionNo     = $p(aInputStr,aSeparete,3)
	Set OptionDesc   = $p(aInputStr,aSeparete,4)
	Set OptionScore  = $p(aInputStr,aSeparete,5)
	
	Set objQuestion  = ##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(Parref)
	Quit:'$Isobject(objQuestion)
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.SurveyOption).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.SurveyOption).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParrefQst       = objQuestion
	Set obj.SQOptionNo		= OptionNo      //写入数据
	Set obj.SQOptionDesc	= OptionDesc
	Set obj.SQOptionScore	= OptionScore

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
/// w ##class(DHCMA.CPW.BT.SurveyOption).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.SurveyOption).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.BT.SurveyOption).GetScoreByID("1||5||1")
ClassMethod GetScoreByID(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set:aID["-" aID=$Replace(aID,"-","||")
	Set len=$l(aID,",")
	For ind=1:1:len{
		Set ID=$p(aID,",",ind)
		Set obj=..GetObjById(ID)
		Quit:'$IsObject(obj)
		Set Score=obj.SQOptionScore
		Set:Score="" Score=0
		if (return=0){
			Set return=Score
		}else{
			Set return=return+Score
		}
	}
	Quit return
}

/// w ##class(DHCMA.CPW.BT.SurveyOption).CheckSQOptionNo("2","1||1")
ClassMethod CheckSQOptionNo(aOptionNo As %String, Parrer As %String = "") As %String
{
	New (aOptionNo,Parrer)
	Set return="1"
	Quit:(aOptionNo="") return
	Quit:Parrer'["||" return
	Set Sur=$p(Parrer,"||",1)
	Set Ques=$p(Parrer,"||",2)
	If ($d(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",Sur,Ques,aOptionNo)))
	{
		Set return=1
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="SurveyOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SQOptionNo</Value>
</Value>
<Value name="3">
<Value>SQOptionDesc</Value>
</Value>
<Value name="4">
<Value>SQOptionScore</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OPT")</DataLocation>
<DefaultData>SurveyOptionDefaultData</DefaultData>
<IdLocation>{%%PARENT}("OPT")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.SurveyI("OPT")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.SurveyOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
