/// 名称: DHCHAI.IR.EnviHyReportLab
/// 描述: 环境卫生学监测检验标本
/// 编写者：zhufei
/// 编写日期: 2020-10-28
Class DHCHAI.IR.EnviHyReportLab Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.EnviHyReport [ Cardinality = parent, Inverse = ChildLab ];

/// 标本号（条码号）
Property BTBarcode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请日期
Property BTApplyDate As %Date;

/// 申请时间
Property BTApplyTime As %Time;

/// 申请人
Property BTApplyUser As DHCHAI.BT.SysUser;

/// 标本号 索引
Index IndexBarcode On (Parref, BTBarcode As Exact);

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取环境卫生学监测检验标本
/// Table：       DHCHAI.IR.EnviHyReportLab
/// Input：       aId : DHCHAI.IR.EnviHyReportLab.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.EnviHyReportLab).GetObjById("5||1")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.EnviHyReportLab
{
	New (aId)
	Quit:'##class(DHCHAI.IR.EnviHyReportLab).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.EnviHyReportLab).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  更新环境卫生学监测检验标本
/// Table：       DHCHAI.IR.EnviHyReportLab
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyReportLab).Update("12^^bar^^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref    = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set BTBarcode = $p(aInputStr,aSeparete,3)
	Set ActDate   = $p(aInputStr,aSeparete,4)
	Set ActTime   = $p(aInputStr,aSeparete,5)
	Set ActUserDr = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(BTBarcode="") return
	
	Set objParref=##class(DHCHAI.IR.EnviHyReport).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set ChildSub=$o(^DHCHAI.IR.EnviHyReportI("Lab","IndexBarcode",Parref,BTBarcode,""))
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.EnviHyReportLab).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.EnviHyReportLab).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.BTBarcode    = BTBarcode
	Set obj.BTApplyDate  = ActDate
	Set obj.BTApplyTime  = ActTime
	Set obj.BTApplyUser  = objActUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  删除环境卫生学监测检验标本
/// Table：       DHCHAI.IR.EnviHyReportLab
/// Input：       aId : DHCHAI.IR.EnviHyReportLab.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.EnviHyReportLab).%DeleteId(aId)
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
<Data name="EnviHyReportLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTBarcode</Value>
</Value>
<Value name="3">
<Value>BTApplyDate</Value>
</Value>
<Value name="4">
<Value>BTApplyTime</Value>
</Value>
<Value name="5">
<Value>BTApplyUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Lab")</DataLocation>
<DefaultData>EnviHyReportLabDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Lab")</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyReportI("Lab")</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyReportLabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
