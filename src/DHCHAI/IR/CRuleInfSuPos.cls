/// 名称: DHCHAI.IR.CRuleInfSuPos
/// 描述: 医院感染关键词库
/// 编写者：zhufei
/// 编写日期: 2017-03-14
Class DHCHAI.IR.CRuleInfSuPos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 疑似诊断（部位）
Property BTSuPosDr As DHCHAI.BT.InfSuPos [ Required ];

/// 分类("InfSuPosKeyCategory")
Property BTCatDr As DHCHAI.BT.Dictionary [ Required ];

/// 关键词（包括：标本、菌、检查部位、检查项目、诊断词、阳性症状或体征词、抗感染治疗、否定句式、科室、其他-腹泻）
Property BTKeyWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 优先级("InfSuPosKeyTpye")
Property BTPRIDr As DHCHAI.BT.Dictionary;

/// 肯定词/否定词（包含/排除）
Property BTProperty As %Boolean;

/// 是否通用（所有诊断下都通用，主要是针对否定句式）
Property BTIsCurrent As %Boolean;

/// 说明
Property BTNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IdxofSuPosCatKey On (BTSuPosDr, BTCatDr, BTKeyWord) [ Unique ];

Index IdxofKeyWord On (BTSuPosDr, BTKeyWord);

Index IdxofSuPosDr On BTSuPosDr;

Index IdxofKeyPRI On (BTKeyWord, BTPRIDr);

Index IdxofKeyWord2 On BTKeyWord;

/// Creator：     zhufei
/// CreatDate：   2017-03-14
/// Description:  根据ID取疑似关键词信息
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       aId : DHCHAI.IR.CRuleInfSuPos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleInfSuPos
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleInfSuPos).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleInfSuPos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-14
/// Description:  更新疑似关键词信息
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuPos).Update("3^痰^46^1^1^^^9^616^1^21313","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set KeyWord   = $p(aInputStr,aSeparete,2)
	Set PRIDr     = $p(aInputStr,aSeparete,3)
	Set Property  = $p(aInputStr,aSeparete,4)
	Set SuPosDr   = $p(aInputStr,aSeparete,5)
	Set ActDate   = $p(aInputStr,aSeparete,6)
	Set ActTime   = $p(aInputStr,aSeparete,7)
	Set ActUserDr = $p(aInputStr,aSeparete,8)
	Set CatDr     = $p(aInputStr,aSeparete,9)
	Set IsCurrent = $p(aInputStr,aSeparete,10)
	Set Note      = $p(aInputStr,aSeparete,11)
	Quit:(KeyWord="")||(PRIDr="")||(CatDr="") return
	
	Set objCat=##class(DHCHAI.BT.Dictionary).GetObjById(CatDr)
	Quit:'$IsObject(objCat) return
	Set objPRI=##class(DHCHAI.BT.Dictionary).GetObjById(PRIDr)
	Quit:'$IsObject(objPRI) return
	Set objInfSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(SuPosDr)
	Quit:'$IsObject(objInfSuPos) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set tID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyWord",SuPosDr," "_$ZCVT(KeyWord,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	//Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleInfSuPos).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleInfSuPos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTKeyWord   = KeyWord
	Set obj.BTPRIDr     = objPRI
	Set obj.BTProperty  = Property
	Set obj.BTSuPosDr   = objInfSuPos
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUserDr = objActUser
	Set obj.BTCatDr     = objCat
	Set obj.BTIsCurrent = IsCurrent
	Set obj.BTNote      = Note
	
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

/// Creator：     zhufei
/// CreatDate：   2017-03-14
/// Description:  删除疑似关键词表信息
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       aId : DHCHAI.IR.CRuleInfSuPos.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuPos).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleInfSuPos).%DeleteId(aId)
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
<Data name="CRuleInfSuPosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTSuPosDr</Value>
</Value>
<Value name="3">
<Value>BTPRIDr</Value>
</Value>
<Value name="4">
<Value>BTKeyWord</Value>
</Value>
<Value name="5">
<Value>BTProperty</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserDr</Value>
</Value>
<Value name="9">
<Value>BTCatDr</Value>
</Value>
<Value name="10">
<Value>BTIsCurrent</Value>
</Value>
<Value name="11">
<Value>BTNote</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleInfSuPosD</DataLocation>
<DefaultData>CRuleInfSuPosDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleInfSuPosD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleInfSuPosI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleInfSuPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
