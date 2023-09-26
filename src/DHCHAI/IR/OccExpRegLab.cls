/// 名称: DHCHAI.IR.OccExpRegLab
/// 描述: 职业暴露 血清学检查表
/// 编写者：zhufei
/// 编写日期: 2018-04-25
Class DHCHAI.IR.OccExpRegLab Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.OccExpReg [ Cardinality = parent, Inverse = ChildLab ];

/// 检查时机（暴露24小时内、4周、8周、12周、6个月、1年）
Property OELabTimDr As DHCHAI.IR.OccExpTypeLab;

/// 检查日期
Property OELabDate As %Date;

/// 检查项目
Property OELabItem As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检查结果
Property OEResult As %String(MAXLEN = 500, TRUNCATE = 1);

/// 检测机构
Property OEDeptDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 采血人
Property OECollector As %String(MAXLEN = 100, TRUNCATE = 1);

/// 证明人
Property OEReterence As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验人
Property OEExaminer As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引 检查时机
Index IndexLabTim On (Parref, OELabTimDr As Exact);

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  根据ID取职业暴露血清学检查表
/// Table：       DHCHAI.IR.OccExpRegLab
/// Input：       aId : DHCHAI.IR.OccExpRegLab.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OccExpRegLab).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpRegLab
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpRegLab).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpRegLab).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  更新职业暴露血清学检查表
/// Table：       DHCHAI.IR.OccExpRegLab
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpRegLab).Update("1^^1||2^2018-06-08^33^44^检测机构^采血人^证明人^检验人")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref    = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set LabTimDr  = $p(aInputStr,aSeparete,3)
	Set LabDate   = $p(aInputStr,aSeparete,4)
	Set LabItem   = $p(aInputStr,aSeparete,5)
	Set Result    = $p(aInputStr,aSeparete,6)
	Set DeptDesc  = $p(aInputStr,aSeparete,7)
	Set Collector = $p(aInputStr,aSeparete,8)
	Set Reterence = $p(aInputStr,aSeparete,9)
	Set Examiner  = $p(aInputStr,aSeparete,10) 
	
	Quit:(Parref="")||(LabTimDr="")||(LabDate="") return
	
	Set:LabDate'="" LabDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabDate)
	Set:LabDate="" LabDate=+$h

	Set objParref=##class(DHCHAI.IR.OccExpReg).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objLabTim = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabTimDr)
	Quit:'$IsObject(objLabTim) return
  
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.OccExpRegLab).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.OccExpRegLab).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref      = objParref
	Set obj.OELabTimDr  = objLabTim
	Set obj.OELabDate   = LabDate  
	Set obj.OELabItem   = LabItem  
	Set obj.OEResult    = Result   
	Set obj.OEDeptDesc  = DeptDesc 
	Set obj.OECollector = Collector
	Set obj.OEReterence = Reterence
	Set obj.OEExaminer  = Examiner 
	
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

/// Creator：     pylian
/// CreatDate：   2018-06-11
/// Description:  根据检查时机获得职业暴露血清学ID
/// Table：       DHCHAI.IR.OccExpReg,DHCHAI.IR.OccExpRegLab
/// Input：       aReportID : DHCHAI.IR.OccExpReg.ID
///               aLabTimDr : DHCHAI.IR.OccExpTypeLab.ID
/// Return：      返回String
/// w ##class(DHCHAI.IR.OccExpRegLab).GetIDByTimDr("1","1||2")
ClassMethod GetIDByTimDr(aReportID As %String, aLabTimDr) As %String
{
	New (aReportID,aLabTimDr)
	Set return=""
	Quit:(aReportID="")||(aLabTimDr="") return
	
	Set return=$o(^DHCHAI.IR.OccExpRegI("LAB","IndexLabTim",aReportID,aLabTimDr,0))
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  删除职业暴露血清学检查表
/// Table：       DHCHAI.IR.OccExpRegLab
/// Input：       aId : DHCHAI.IR.OccExpRegLab.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpRegLab).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpRegLab).%DeleteId(aId)
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
<Data name="OccExpRegLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OELabTimDr</Value>
</Value>
<Value name="3">
<Value>OELabDate</Value>
</Value>
<Value name="4">
<Value>OELabItem</Value>
</Value>
<Value name="5">
<Value>OEResult</Value>
</Value>
<Value name="6">
<Value>OEDeptDesc</Value>
</Value>
<Value name="7">
<Value>OECollector</Value>
</Value>
<Value name="8">
<Value>OEReterence</Value>
</Value>
<Value name="9">
<Value>OEExaminer</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LAB")</DataLocation>
<DefaultData>OccExpRegLabDefaultData</DefaultData>
<IdLocation>{%%PARENT}("LAB")</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpRegI("LAB")</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpRegLabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
