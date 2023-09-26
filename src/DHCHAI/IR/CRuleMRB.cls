/// 名称: DHCHAI.IR.CRuleMRB
/// 描述: 多重耐药菌分类
/// 编写者：zhufei
/// 编写日期: 2017-04-10
Class DHCHAI.IR.CRuleMRB Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 细菌
Relationship ChildBact As DHCHAI.IR.CRuleMRBBact [ Cardinality = children, Inverse = Parref ];

/// 抗生素分类
Relationship ChildAnti As DHCHAI.IR.CRuleMRBAnti [ Cardinality = children, Inverse = Parref ];

/// 关键词
Relationship ChildKeys As DHCHAI.IR.CRuleMRBKeys [ Cardinality = children, Inverse = Parref ];

/// 隔离医嘱
Relationship ChildOEOrds As DHCHAI.IR.CRuleMRBOEOrd [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 多耐分类（"MRBCategory"）
Property BTCatDr As DHCHAI.BT.Dictionary;

/// 有效标志
Property BTIsActive As %Boolean;

/// 启用规则检查
Property BTIsRuleCheck As %Boolean;

/// 启用检查抗生素
Property BTIsAntiCheck As %Boolean;

/// 抗生素种类（多耐）
Property BTAnitCatCnt As %Integer;

/// 抗生素种类2（泛耐）
Property BTAnitCatCnt2 As %Integer;

/// 启用关键词检查
Property BTIsKeyCheck As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As DHCHAI.BT.SysUser;

/// 备注说明
Property BTRuleNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// add 20230208 增加中介是否算耐药、耐药机制关键词检查
/// 中介是否算耐药
Property BTIsIRstCheck As %Boolean;

/// 耐药机制关键词
Property BTIsResKeyCheck As %Boolean;

Index IndexCode On BTCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取多重耐药菌信息
/// Table：       DHCHAI.IR.CRuleMRB
/// Input：       aId : DHCHAI.IR.CRuleMRB.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleMRB).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleMRB
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleMRB).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleMRB).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  根据Code取多重耐药菌信息
/// Table：       DHCHAI.IR.CRuleMRB
/// Input：       aCode : DHCHAI.IR.CRuleMRB.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleMRB).GetObjByCode("M1")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.IR.CRuleMRB
{
	New (aCode)
	Quit:(aCode="") ""
	Set ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新多重耐药菌信息
/// Table：       DHCHAI.IR.CRuleMRB
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRB).Update("^code^desc^1^^^","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete = ..#SEPARATE	
	Set ID			= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Set CatDr		= $p(InStr,aSeparete,4)
	Set IsActive	= +$p(InStr,aSeparete,5)
	Set IsRuleCheck = +$p(InStr,aSeparete,6)
	Set IsAntiCheck = +$p(InStr,aSeparete,7)
	Set AnitCatCnt  = $p(InStr,aSeparete,8)
	Set AnitCatCnt2 = $p(InStr,aSeparete,9)
	Set IsKeyCheck  = +$p(InStr,aSeparete,10)
	Set ActDate		= $p(InStr,aSeparete,11)
	Set ActTime		= $p(InStr,aSeparete,12)
	Set ActUser		= $p(InStr,aSeparete,13)
	Set RuleNote    = $p(InStr,aSeparete,14)
	Set IsIRstCheck   = $p(InStr,aSeparete,15)
	Set IsResKeyCheck = $p(InStr,aSeparete,16)

	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	Set objCat=##class(DHCHAI.BT.Dictionary).GetObjById(CatDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	
	//代码唯一性
	Set tID =$o(^DHCHAI.IR.CRuleMRBI("IndexCode",Code,0)) 
	Quit:(tID'="")&&(ID'=tID) -2
    
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleMRB).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleMRB).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		  = Code
	Set obj.BTDesc		  = Desc
	Set obj.BTCatDr       = objCat
	Set obj.BTIsActive	  = IsActive
	Set obj.BTIsRuleCheck = IsRuleCheck
	Set obj.BTIsAntiCheck = IsAntiCheck
	Set obj.BTAnitCatCnt  = AnitCatCnt
	Set obj.BTAnitCatCnt2 = AnitCatCnt2
	Set obj.BTIsKeyCheck  = IsKeyCheck
	Set obj.BTActDate	  = ActDate
	Set obj.BTActTime	  = ActTime
	Set obj.BTActUser	  = objActUser
	Set obj.BTRuleNote    = RuleNote
	Set obj.BTIsIRstCheck   = IsIRstCheck
	Set obj.BTIsResKeyCheck = IsResKeyCheck
	
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
/// CreatDate：   2017-03-15
/// Description:  删除多重耐药菌信息
/// Table：       DHCHAI.IR.CRuleMRB
/// Input：       aId : DHCHAI.IR.CRuleMRB.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRB).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleMRB).%DeleteId(aId)
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
<Data name="MRBTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUser</Value>
</Value>
<Value name="8">
<Value>BTIsRuleCheck</Value>
</Value>
<Value name="9">
<Value>BTAnitCatCnt</Value>
</Value>
<Value name="10">
<Value>BTAnitCatCnt2</Value>
</Value>
<Value name="11">
<Value>BTIsKeyCheck</Value>
</Value>
<Value name="12">
<Value>BTIsAntiCheck</Value>
</Value>
<Value name="13">
<Value>BTCatDr</Value>
</Value>
<Value name="14">
<Value>BTRuleNote</Value>
</Value>
<Value name="15">
<Value>BTIsIRstCheck</Value>
</Value>
<Value name="16">
<Value>BTIsResKeyCheck</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleMRBD</DataLocation>
<DefaultData>MRBTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleMRBD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleMRBI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleMRBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
