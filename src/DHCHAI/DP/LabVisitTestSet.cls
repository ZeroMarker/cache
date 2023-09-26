/// 名称: DHCHAI.DP.LabVisitTestSet
/// 描述: 检验医嘱/检验组套
/// 编写者：zhufei
/// 编写日期: 2017-08-08
Class DHCHAI.DP.LabVisitTestSet Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验标本
Property LabVisitNumberDr As DHCHAI.DP.LabVisitNumber [ Required ];

/// 检验医嘱名称
Property LabTestSetDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验医嘱代码
Property LabTestSetCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医嘱项名称
Property LabOrdTSDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医嘱项代码
Property LabOrdTSCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 合管检验医嘱代码
Property LabComSetCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 标本记录索引
Index IndexVisitNumberDr On LabVisitNumberDr;

/// 检验医嘱索引
Index IndexVisitNumberTestSet On (LabVisitNumberDr, LabTestSetDesc As Exact);

/// 检验医嘱名称索引
Index IndexTestSetDesc On LabTestSetDesc;

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  根据ID取检验医嘱
/// Table：       DHCHAI.DP.LabVisitTestSet
/// Input：       ID:    DHCHAI.DP.LabVisitTestSet.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitTestSet).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitTestSet
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitTestSet).%ExistsId(+id) return
	Set obj=##Class(DHCHAI.DP.LabVisitTestSet).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据描述取检验医嘱
/// Table：       DHCHAI.DP.LabVisitTestSet
/// Input：       aVisitNumberDr:DHCHAI.DP.LabVisitTestSet.LabVisitNumberDr
/// 				  aTestSetDesc:DHCHAI.DP.LabVisitTestSet.LabTestSetDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitTestSet).GetObjByDesc("1","人类乳头状病毒HPV基因检测")
ClassMethod GetObjByDesc(aVisitNumberDr As %String, aTestSetDesc As %String) As DHCHAI.DP.LabVisitTestSet
{
	New (aVisitNumberDr,aTestSetDesc)
	Set return=""
	Quit:(aVisitNumberDr="")||(aTestSetDesc="") return
	
	Set id = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",aVisitNumberDr,aTestSetDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  更新检验医嘱
/// Table：       DHCHAI.DP.LabVisitTestSet
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitTestSet).Update("1^1^人类乳头状病毒HPV基因检测^L001")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			  = $p(InStr,aSeparete,1)
	Set VisitNumberDr = $p(InStr,aSeparete,2)
	Set TestSetDesc   = $p(InStr,aSeparete,3)
	Set TestSetCode	  = $p(InStr,aSeparete,4)
	Set OrdTSDesc	  = $p(InStr,aSeparete,5)
	Set OrdTSCode	  = $p(InStr,aSeparete,6)
	Set ComSetCode    = $p(InStr,aSeparete,7)
	Quit:(VisitNumberDr="")||(TestSetDesc="") return

	Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberDr)
	Quit:'$IsObject(objVisitNumber) return
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",VisitNumberDr,TestSetDesc,"")) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitTestSet).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitTestSet).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabVisitNumberDr= objVisitNumber
	Set obj.LabTestSetDesc	= TestSetDesc
	Set obj.LabTestSetCode	= TestSetCode
	Set obj.LabOrdTSDesc	= OrdTSDesc
	Set obj.LabOrdTSCode	= OrdTSCode
	Set obj.LabComSetCode	= ComSetCode
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  删除检验医嘱
/// Table：       DHCHAI.DP.LabVisitTestSet
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitTestSet).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="LabVisitTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabVisitNumberDr</Value>
</Value>
<Value name="3">
<Value>LabTestSetDesc</Value>
</Value>
<Value name="4">
<Value>LabTestSetCode</Value>
</Value>
<Value name="5">
<Value>LabOrdTSDesc</Value>
</Value>
<Value name="6">
<Value>LabOrdTSCode</Value>
</Value>
<Value name="7">
<Value>LabComSetCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitTestSetD</DataLocation>
<DefaultData>LabVisitTestSetDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitTestSetD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitTestSetI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
