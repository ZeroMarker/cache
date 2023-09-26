/// 名称: DHCMA.IMP.BT.IMPCateRules
/// 描述: 手术并发症字典
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.BT.OperCompDic Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术并发症代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 手术并发症描述
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 排序
Property BTOrder As %String;

/// 是否有效
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCode On BTCode [ Unique ];

/// Creator：     dsp
/// CreatDate：   2020-05-28
/// Description:  更新手术并发症字典
/// Table：       DHCMA.IMP.BT.OperCompDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.OperCompDic).Update("^001^项目类型1^A^D")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID         = $p(aInputStr,aSeparete,1)
	Set BTCode     = $p(aInputStr,aSeparete,2)
	Set BTDesc     = $p(aInputStr,aSeparete,3)
	Set BTIsActive = $p(aInputStr,aSeparete,4)
	Set BTOrder    = $p(aInputStr,aSeparete,5)
	Set BTActDate  = $p(aInputStr,aSeparete,6)
	Set BTActTime  =$p(aInputStr,aSeparete,7)
	Set BTActUserID = $p(aInputStr,aSeparete,8)

	Set tID=$o(^CT.MA.IMP.BTOperCompDicI("IdxofCode"," "_$zcvt(BTCode,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set:BTActDate'="" BTActDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActDate="" BTActDate =+$h
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActTime="" BTActTime =$p($h,",",2)
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.BT.OperCompDic).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.BT.OperCompDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.BTCode     = BTCode
	Set obj.BTDesc     = BTDesc
	Set obj.BTIsActive = BTIsActive
	Set obj.BTOrder    = BTOrder
	Set obj.BTActDate  = BTActDate
	Set obj.BTActTime  = BTActTime
	Set obj.BTActUserID= BTActUserID
	
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

/// Creator：     dsp
/// CreatDate：   2020-05-28
/// Description:  检查手术并发症字典Code是否唯一
/// Table：       DHCMA.IMP.BT.OperCompDic
/// Input：       aId :  DHCMA.IMP.BT.OperCompDic.SCCode
/// Return：      返回obj
/// w ##class( DHCMA.IMP.BT.OperCompDic).CheckPTCode("01",1)
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^CT.MA.IMP.BTOperCompDicI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^CT.MA.IMP.BTOperCompDicI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     dsp
/// CreatDate：   2020-05-28
/// Description:  根据ID获取手术并发症字典
/// Table：       DHCMA.IMP.BT.OperCompDic
/// Input：       aId :  DHCMA.IMP.BT.OperCompDic.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.BT.OperCompDic).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.OperCompDic
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.OperCompDic).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.OperCompDic).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-05-28
/// Description:  删除手术并发症字典
/// Table：       DHCMA.IMP.BT.OperCompDic
/// Input：       aId :  DHCMA.IMP.BT.OperCompDic.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.OperCompDic).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.OperCompDic).%DeleteId(aId)
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
<Value>BTOrder</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.IMP.BTOperCompDicD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.IMP.BTOperCompDicD</IdLocation>
<IndexLocation>^CT.MA.IMP.BTOperCompDicI</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTOperCompDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
