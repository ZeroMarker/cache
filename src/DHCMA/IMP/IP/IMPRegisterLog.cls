/// 名称: DHCMA.IMP.IP.IMPRegisterLog
/// 描述: 重点患者登记操作日志
/// 编写者：zhufei
/// 编写日期: 2020-9-25
Class DHCMA.IMP.IP.IMPRegisterLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.IP.IMPRegister [ Cardinality = parent, Inverse = ChildLog ];

/// 当前状态（"IMPRegStatus"  提交、审核）
Property StatusDr As DHCMA.Util.BT.Dictionary;

/// 处置意见
Property Opinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property ActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     dsp
/// CreatDate：   2020-09-28
/// Description:  更新重点患者登记操作日志
/// Table：       DHCMA.IMP.IP.IMPRegisterLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegisterLog).Update("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref   = $p(aInputStr,aSeparete,1)
	Set ChildSub = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set StatusDr = $p(aInputStr,aSeparete,3)
	Set Opinion  = $p(aInputStr,aSeparete,4)
	Set ActDate  = $p(aInputStr,aSeparete,5)
	Set ActTime  = $p(aInputStr,aSeparete,6)
	Set ActUserID  = $P(aInputStr,aSeparete,7)	
	
	Set:ActDate'="" ActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Quit:Parref="" -1
	Set objIMPReg = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(Parref)
	Quit:'$Isobject(objIMPReg) -1
	
	Quit:StatusDr="" -2
	Set StatusDrObj = ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("IMPRegStatus",StatusDr)
	QUit:'$Isobject(StatusDrObj) -2
	
	If ChildSub="" { 
		Set obj=##class(DHCMA.IMP.IP.IMPRegisterLog).%New()
	}Else{
		Set ID= Parref_"||"_ChildSub
		Set obj=##class(DHCMA.IMP.IP.IMPRegisterLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.Parref       = objIMPReg      
	Set obj.StatusDr     = StatusDrObj
	Set obj.Opinion      = Opinion
	Set obj.ActDate      = ActDate
	Set obj.ActTime 	 = ActTime
	Set obj.ActUserID    = ActUserID
	
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
/// CreatDate：   2020-09-29
/// Description:  根据ID查询登记主表日志
/// Table：       DHCMA.IMP.IP.IMPRegisterLog
/// Input：       aId :  DHCMA.IMP.IP.IMPRegisterLog.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.IMPRegisterLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.OperCompReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.IMPRegisterLog).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.IMPRegisterLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-09-29
/// Description:  删除登记主表记录日志
/// Table：       DHCMA.IMP.IP.IMPRegisterLog
/// Input：       aId :  DHCMA.IMP.IP.IMPRegisterLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegisterLog).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.IMPRegisterLog).%DeleteId(aId)
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
<Value>StatusDr</Value>
</Value>
<Value name="3">
<Value>Opinion</Value>
</Value>
<Value name="4">
<Value>ActDate</Value>
</Value>
<Value name="5">
<Value>ActTime</Value>
</Value>
<Value name="6">
<Value>ActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^MA.IMP.IPIMPRegisterI("Log")</IndexLocation>
<StreamLocation>^MA.IMP.IPIMPRegisterLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
