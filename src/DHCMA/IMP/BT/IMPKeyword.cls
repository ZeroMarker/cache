/// 名称: DHCMA.IMP.BT.IMPKeyword
/// 描述: 重点患者关键词字典
/// 编写者：zhangdc
/// 编写日期: 2020-6-24
Class DHCMA.IMP.BT.IMPKeyword Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 索引
Index IdxofCode On BTCode;

/// Creator：     zhangdc
/// CreatDate：   2020-06-24
/// Description:  根据ID取重点患者关键词信息
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       aId :  DHCMA.IMP.BT.IMPKeyword.ID
/// Return：      返回obj
/// zw ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPKeyword
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPKeyword).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPKeyword).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-24
/// Description:  删除重点患者关键词信息
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       aId :  DHCMA.IMP.BT.IMPKeyword.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPKeyword).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPKeyword).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-24
/// Description:  更新重点患者关键词信息
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPKeyword).Update("^01^腹腔积液^1^1","^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	
	Set ID       	 = $p(aInputStr,aSeparete,1)       
	Set Code     	 = $p(aInputStr,aSeparete,2)
	Set Desc     	 = $p(aInputStr,aSeparete,3)
	Set BTIsActive   = +$p(aInputStr,aSeparete,4)
	Set BTActDate    = $p(aInputStr,aSeparete,5)
	Set BTActTime    = $p(aInputStr,aSeparete,6)
	Set BTActUserID  = $p(aInputStr,aSeparete,7)
	Quit:(Code="")||(Desc="") return
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)
	
	If ID="" {                                  
		Set obj=##class(DHCMA.IMP.BT.IMPKeyword).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.BT.IMPKeyword).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.BTCode     	 = Code
	Set obj.BTDesc     	 = Desc
	Set obj.BTIsActive	 = BTIsActive
	Set obj.BTActDate    = BTActDate
	Set obj.BTActTime    = BTActTime
	Set obj.BTActUserID  = BTActUserID
	
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  根据Code取关键词
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// Input：       aCode : DHCMA.IMP.BT.IMPKeyword.Code
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPKeyword).GetObjByCode("Fistula")
ClassMethod GetObjByCode(aCode As %String) As DHCMA.IMP.BT.IMPKeyword
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^CT.MA.IMP.BTIMPKeywordI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-10-14
/// Description:  根据描述取重点患者关键词
/// Table：       DHCMA.IMP.BT.IMPKeyword
/// w ##class(DHCMA.IMP.BT.IMPKeyword).GetObjByDesc("")
ClassMethod GetObjByDesc(aAlias) As DHCMA.IMP.BT.IMPKeyword
{
	new (aAlias)
 	Set xRowID=0,return=""
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPKeywordD(xRowID))
	 	Quit:(xRowID="")||(return'="")
	 	Set objKeyword  = ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(xRowID)
	 	Set Code          = objKeyword.BTCode
	 	Set Desc          = objKeyword.BTDesc
	 	Set:Desc[aAlias return=objKeyword
 	}
 	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Subscript>"1"</Subscript>
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
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.IMP.BTIMPKeywordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.IMP.BTIMPKeywordD</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPKeywordI</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPKeywordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
