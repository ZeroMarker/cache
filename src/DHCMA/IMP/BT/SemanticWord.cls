/// 名称: DHCMA.IMP.BT.SemanticWord
/// 描述: 重点患者关键词对应语义词
/// 编写者：zhangdc
/// 编写日期: 2020-7-31
Class DHCMA.IMP.BT.SemanticWord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 语义词
Property BTSemaWord As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 关键词
Property BTKeywordDr As DHCMA.IMP.BT.IMPKeyword [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关键词 + 语义词 索引
Index IdxofKeySemaWord On (BTKeywordDr, BTSemaWord) [ Unique ];

/// 关键词  索引
Index IdxofKeywordDr On BTKeywordDr;

/// Creator：     zhangdc
/// CreatDate：   2020-7-31
/// Description:  根据ID取语义词
/// Table：       DHCMA.IMP.BT.SemanticWord
/// Input：       aId :  DHCMA.IMP.BT.SemanticWord.ID
/// Return：      返回obj
/// zw ##class(DHCMA.IMP.BT.SemanticWord).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.SemanticWord
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.SemanticWord).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.SemanticWord).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-7-31
/// Description:  删除语义词
/// Table：       DHCMA.IMP.BT.SemanticWord
/// Input：       aId :  DHCMA.IMP.BT.SemanticWord.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.SemanticWord).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.SemanticWord).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-7-31
/// Description:  更新语义词
/// Table：       DHCMA.IMP.BT.SemanticWord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.SemanticWord).Update("","^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID       				= $p(aInputStr,aSeparete,1)       
	Set BTSemaWord     			= $p(aInputStr,aSeparete,2)
	Set KeywordDr   			= $p(aInputStr,aSeparete,3)
	Set BTIsActive   			= +$p(aInputStr,aSeparete,4)
	Set BTActDate    			= $p(aInputStr,aSeparete,5)
	Set BTActTime    			= $p(aInputStr,aSeparete,6)
	Set BTActUserID  			= $p(aInputStr,aSeparete,7)
	Quit:(BTSemaWord="")||(KeywordDr="") return
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)
	
	If ID="" {                                  
		Set obj=##class(DHCMA.IMP.BT.SemanticWord).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.BT.SemanticWord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.BTSemaWord     	= BTSemaWord
	Set obj.BTKeywordDr   	= ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(KeywordDr)
	Set obj.BTIsActive	 	= BTIsActive
	Set obj.BTActDate    	= BTActDate
	Set obj.BTActTime    	= BTActTime
	Set obj.BTActUserID  	= BTActUserID
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTSemaWord</Value>
</Value>
<Value name="3">
<Value>BTKeywordDr</Value>
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
<DataLocation>^CT.MA.IMP.BTSemanticWordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.IMP.BTSemanticWordD</IdLocation>
<IndexLocation>^CT.MA.IMP.BTSemanticWordI</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTSemanticWord</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
