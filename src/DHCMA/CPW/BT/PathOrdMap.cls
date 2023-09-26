/// 名称: DHCMA.CPW.BT.PathOrdMap
/// 描述: 临床路径表单 医嘱项替换
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathOrdMap Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医嘱类型（医嘱项、医嘱套、中药-协定方、中药-自定义方剂）
Property OrdTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 医嘱项、医嘱套、中药-协定方、中药-自定义方剂 ID指针
Property OrdMastID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 替换ID指针
Property OrdMapID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 开始日期
Property BTDateFrom As %Date;

/// 结束日期
Property BTDateTo As %Date;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathOrdMap
/// Input：       aId : DHCMA.CPW.BT.PathOrdMap.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathOrdMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathOrdMap
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathOrdMap).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathOrdMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathOrdMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathOrdMap).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set OrdTypeDr    = $p(aInputStr,aSeparete,2)
	Set OrdMastID    = $p(aInputStr,aSeparete,3)	
	Set OrdMapID     = $p(aInputStr,aSeparete,4)
	Set BTDateFrom   = $p(aInputStr,aSeparete,5)
	Set BTDateTo     = $p(aInputStr,aSeparete,6)
	Set BTActDate    = $p(aInputStr,aSeparete,7)
	Set BTActTime	 = $p(aInputStr,aSeparete,8)
	Set BTActUserID  = $p(aInputStr,aSeparete,9)
		
	Set:BTDateFrom'="" BTDateFrom = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTDateFrom)	
	Set:BTDateTo'="" BTDateTo = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTDateTo)
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)	
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=$p($h,",",2)
	
	Quit:(OrdTypeDr="")||(OrdMastID="")||(OrdMapID="") -1
	Set objOrdType = ##class(DHCMA.Util.BT.Dictionary).GetObjById(PDPathDr)
	Quit:'$Isobject(objOrdType) -1

	If ID="" {
		Set obj=##class(DHCMA.CPW.BT.PathOrdMap).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathOrdMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OrdTypeDr	 = objOrdType  //对象
	Set obj.OrdMastID	 = OrdMastID  
	Set obj.OrdMapID     = OrdMapID
	Set obj.BTDateFrom	 = BTDateFrom
	Set obj.BTDateTo	 = BTDateTo
	Set obj.BTActDate	 = BTActDate
	Set obj.BTActTime	 = BTActTime
	Set obj.BTActUserID  = BTActUserID
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

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathOrdMap
/// Input：       aId : DHCMA.CPW.BT.PathOrdMap.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathOrdMap).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathOrdMap).%DeleteId(aId)
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
<Data name="PathOrdMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdTypeDr</Value>
</Value>
<Value name="3">
<Value>OrdMastID</Value>
</Value>
<Value name="4">
<Value>OrdMapID</Value>
</Value>
<Value name="5">
<Value>BTDateFrom</Value>
</Value>
<Value name="6">
<Value>BTDateTo</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathOrdMapD</DataLocation>
<DefaultData>PathOrdMapDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathOrdMapD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathOrdMapI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathOrdMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
