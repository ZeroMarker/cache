/// 名称: DHCHAI.IR.CRuleOperKeys
/// 描述: 手术筛查关键词
/// 编写者：zhufei
/// 编写日期: 2017-01-16
Class DHCHAI.IR.CRuleOperKeys Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术名称/分类
Property BTOperDr As DHCHAI.IR.CRuleOper;

/// 包含关键词
Property BTInWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 排除关键词
Property BTExWords As %List;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 包含关键词索引
Index IndexInWord On BTInWord As Exact;

/// 手术索引
Index IndexOperDrInWord On (BTOperDr, BTInWord As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-01-17
/// Description:  根据ID取手术筛查关键词
/// Table：       DHCHAI.IR.CRuleOperKeys
/// Input：       ID:    DHCHAI.IR.CRuleOperKeys.ID
///               aSeparete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCHAI.IR.CRuleOperKeys).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.CRuleOperKeys
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.CRuleOperKeys).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.IR.CRuleOperKeys).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-01-17
/// Description:  更新手术筛查关键词
/// Table：       DHCHAI.IR.CRuleOperKeys
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperKeys).Update("^2^白内障^^^^med")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	if (aSeparete="") set aSeparete="^"
	Set return=0
	Quit:InStr="" return
	
	Set ID		   = $p(InStr,aSeparete,1)
	Set OperDr     = $p(InStr,aSeparete,2)
	Set InWord     = $p(InStr,aSeparete,3)
	Set ExWords    = $p(InStr,aSeparete,4)
	Set ActDate    = $p(InStr,aSeparete,5)
	Set ActTime    = $p(InStr,aSeparete,6)
	Set ActUserDr  = +$p(InStr,aSeparete,7)
	Quit:(OperDr="")||(InWord="") return
	
	Set InWord=$zcvt(InWord,"U")
	Set InWord=$tr(InWord," ","")
	Quit:InWord="" return
	
	Set ExWordList=""
	If ExWords'="" {
		For indEx=1:1:$l(ExWords,",") {
			Set ExWord=$p(ExWords,",",indEx)
			Continue:ExWord=""
			Set ExWord=$zcvt(ExWord,"U")
			Set ExWord=$tr(ExWord," ","")
			Set ExWordList=ExWordList_$lb(ExWord)
		}
	}
	
	Set objOper=##class(DHCHAI.IR.CRuleOper).GetObjById(OperDr)
	Quit:'$IsObject(objOper) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	//包含关键词唯一性
	Set tID =$o(^DHCHAI.IR.CRuleOperKeysI("IndexInWord",OperDr,InWord,0))
	Quit:(tID'="")&&(ID'=tID) -2
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.CRuleOperKeys).%New()
	}else{
		Set obj=##class(DHCHAI.IR.CRuleOperKeys).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTOperDr    = objOper
	Set obj.BTInWord	= InWord
	Set obj.BTExWords	= ExWordList
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUserDr = objActUser
	
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
/// CreatDate：   2017-01-17
/// Description:  删除手术筛查关键词
/// Table：       DHCHAI.IR.CRuleOperKeys
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.CRuleOperKeys).%DeleteId(+Id)
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
<Data name="CRuleOperKeysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTOperDr</Value>
</Value>
<Value name="3">
<Value>BTInWord</Value>
</Value>
<Value name="4">
<Value>BTExWords</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleOperKeysD</DataLocation>
<DefaultData>CRuleOperKeysDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleOperKeysD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleOperKeysI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleOperKeysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
