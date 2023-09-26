/// 名称: DHCHAI.DP.LabTestSet
/// 描述: 检验医嘱
/// 编写者：zhufei
/// 编写日期: 2017-05-09
Class DHCHAI.DP.LabTestSet Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验医嘱代码
Property BTTSCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验医嘱名称
Property BTTestSet As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 分类（细菌检测、常规检验）
Property BTCatDr As DHCHAI.DP.LabTestSetCat;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 备注
Property BTNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 送检标志（提高住院患者抗菌药物治疗前病原学送检率中常见病原学送检项目）
Property BTIsSubItem As %Boolean;

/// 病毒项目标志
Property BTIsVirus As %Boolean;

/// 检验医嘱代码索引
Index IndexTSCode On BTTSCode As Exact;

/// 检验医嘱名称索引
Index IndexTestSet On BTTestSet As Exact;

/// 分类索引
Index IndexType On BTCatDr;

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  根据代码取常规检验医嘱
/// Table：       DHCHAI.DP.LabTestSet
/// Input：       aTSCode:   检验医嘱代码
/// 			  aTestSet:   检验医嘱名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestSet).GetObjByCodeDesc("","血常规")
ClassMethod GetObjByCodeDesc(aTSCode As %String, aTestSet As %String) As DHCHAI.DP.LabTestSet
{
	New (aTSCode,aTestSet)
	Set return=""
	Quit:((aTSCode="")&&(aTestSet=""))||((aTSCode'="")&&(aTestSet'="")) return
	
	Set id=""
	Set:aTSCode'="" id = $o(^DHCHAI.DP.LabTestSetI("IndexTSCode",aTSCode,0))
	Set:aTestSet'="" id = $o(^DHCHAI.DP.LabTestSetI("IndexTestSet",aTestSet,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  根据ID取常规检验医嘱
/// Table：       DHCHAI.DP.LabTestSet
/// Input：       ID:    DHCHAI.DP.LabTestSet.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestSet).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTestSet
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTestSet).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTestSet).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  更新常规检验医嘱
/// Table：       DHCHAI.DP.LabTestSet
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTestSet).Update("^检验医嘱代码^检验医嘱名称^1^1^备注")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set TSCode		= $p(InStr,aSeparete,2)
	Set TestSet		= $p(InStr,aSeparete,3)
	Set CatDr		= $p(InStr,aSeparete,4)
	Set IsActive	= +$p(InStr,aSeparete,5)
	Set Note		= $p(InStr,aSeparete,6)
	Set IsSubItem   = $p(InStr,aSeparete,7)
	Set IsVirus		= $p(InStr,aSeparete,8)

	Quit:(TSCode="")||(TestSet="")||(IsActive="")||(CatDr="") return
	Set TestSet = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSet) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.LabTestSetI("IndexTSCode",TSCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 

	Set objCat = ##class(DHCHAI.DP.LabTestSetCat).GetObjById(CatDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabTestSet).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabTestSet).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTSCode	= TSCode
	Set obj.BTTestSet	= TestSet
	Set obj.BTCatDr		= objCat
	Set obj.BTIsActive	= IsActive
	Set obj.BTNote		= Note
	Set obj.BTIsSubItem	= IsSubItem
	Set obj.BTIsVirus	= IsVirus
	
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
/// CreatDate：   2017-05-09
/// Description:  删除常规检验医嘱
/// Table：       DHCHAI.DP.LabTestSet
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabTestSet")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabTestSet).%DeleteId(+Id)
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
<Data name="LabTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTSCode</Value>
</Value>
<Value name="3">
<Value>BTTestSet</Value>
</Value>
<Value name="4">
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTNote</Value>
</Value>
<Value name="7">
<Value>BTIsSubItem</Value>
</Value>
<Value name="8">
<Value>BTIsVirus</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabTestSetD</DataLocation>
<DefaultData>LabTestSetDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTestSetD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTestSetI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
