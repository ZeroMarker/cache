/// 名称: DHCMA.IMP.IB.UnplanSurRegistry
/// 描述: 重点患者特因字典
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.BT.IMPReasonDic Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 特因代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 特因描述
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 索引
Index IdxOfCode On BTCode;

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  根据ID取重点患者特因字典信息
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// Input：       aId : DHCMA.IMP.BT.IMPReasonDic.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPReasonDic
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPReasonDic).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPReasonDic).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  根据Code取重点患者特因字典信息
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// Input：       aCode : DHCMA.IMP.BT.IMPReasonDic.ReasonCode
/// Return：      返回String
/// w ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjByCode("11")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.MA.IMP.BTIMPReasonDicI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  更新重点患者特因字典信息
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPReasonDic).Update("^zz^zz^0^^^^^^^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID                    	= $p(aInputStr,aSeparete,1)
	Set Code                  	= $p(aInputStr,aSeparete,2)
	Set Desc                  	= $p(aInputStr,aSeparete,3)
	Set BTIsActive   			= +$p(aInputStr,aSeparete,4)
	Set BTActDate    			= $p(aInputStr,aSeparete,5)
	Set BTActTime    			= $p(aInputStr,aSeparete,6)
	Set BTActUserID  			= $p(aInputStr,aSeparete,7)
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)

	Quit:(Code="")||(Desc="") return
	Set tID=$o(^CT.MA.IMP.BTIMPReasonDicI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2  
	
	If ID="" {
		Set obj=##class(DHCMA.IMP.BT.IMPReasonDic).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.BT.IMPReasonDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode          = Code
	Set obj.BTDesc          = Desc
	Set obj.BTIsActive	 	= BTIsActive
	Set obj.BTActDate    	= BTActDate
	Set obj.BTActTime    	= BTActTime
	Set obj.BTActUserID  	= BTActUserID
	
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  删除重点患者特因字典信息
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// Input：       aId : DHCMA.IMP.BT.IMPReasonDic.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPReasonDic).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPReasonDic).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-08
/// Description:  根据描述取重点患者特因
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// w ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjByDesc("床位周转发生率")
ClassMethod GetObjByDesc(aAlias) As DHCMA.IMP.BT.IMPReasonDic
{
	new (aAlias)
 	Set xRowID=0,return=""
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPReasonDicD(xRowID))
	 	Quit:(xRowID="")||(return'="")
	 	Set objReasonDic  = ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(xRowID)
	 	Set Code          = objReasonDic.BTCode
	 	Set Desc          = objReasonDic.BTDesc
	 	Set:Desc[aAlias return=objReasonDic
 	}
 	Quit return
}

Storage Default
{
<Data name="DefaultData">
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
<DataLocation>^CT.MA.IMP.BTIMPReasonDicD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.IMP.BTIMPReasonDicD</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPReasonDicI</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPReasonDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
