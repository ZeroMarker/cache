/// 名称: DHCMA.IMP.IP.IMPRecordLog
/// 描述: 重点患者筛查操作日志
/// 编写者：zhufei
/// 编写日期: 2020-9-25
Class DHCMA.IMP.IP.IMPRecordLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.IP.IMPRecord [ Cardinality = parent, Inverse = ChildLog ];

/// 筛查关键词
Property IMPKeywords As %String(MAXLEN = 100, TRUNCATE = 1);

/// 特因分类
Property IMPReasonDr As DHCMA.IMP.BT.IMPReasonDic;

/// 当前状态（"IMPStatus"  自动标记、手动标记、排除、确诊）
Property StatusDr As DHCMA.Util.BT.Dictionary;

/// 处置意见
Property Opinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property ActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     zhangdc
/// CreatDate：   2020-09-28
/// Description:  根据ID取对象
/// Table：       DHCMA.IMP.IP.IMPRecordLog
/// Input：       aId : DHCMA.IMP.IP.IMPRecordLog.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.IP.IMPRecordLog).GetObjById("")
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.IMPRecordLog
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.IMPRecordLog).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.IMPRecordLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-09-28
/// Description:  更新实体对象
/// Table：       DHCMA.IMP.IP.IMPRecordLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRecordLog).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^TEMPZDC20201130=aInputStr
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		 = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set IMPKeywords  = $p(aInputStr,aSeparete,3)
	Set IMPReasonDr  = $p(aInputStr,aSeparete,4)
	Set StatusDr     = $p(aInputStr,aSeparete,5)
	Set Opinion      = $p(aInputStr,aSeparete,6)
	Set ActDate      = $p(aInputStr,aSeparete,7)
	Set ActTime    	 = $p(aInputStr,aSeparete,8)
	Set ActUserID  	 = $p(aInputStr,aSeparete,9)
	
	Set:ActDate'="" ActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=+$p($h,",",2)	
	
	Quit:(Parref="") -1
	Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(Parref)
	Quit:'$Isobject(objRecord) -1
	Set IMPKeywords = objRecord.IMPKeywords
	
	Set objReason=""
	if (StatusDr=1){//确诊
		Set objStatus=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","确诊")
	}elseif(StatusDr=2){//排除
		Set objStatus=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","排除")
		Set objReason = objRecord.IMPReasonDr
		Set Opinion = objRecord.Opinion
	}elseif(StatusDr=3){//自动标记
		Set objStatus=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","自动标记")
	}elseif(StatusDr=4){//手动标记
		Set objStatus=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","手动标记")
	}
	
	If ChildSub="" {
		Set obj=##class(DHCMA.IMP.IP.IMPRecordLog).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.IMP.IP.IMPRecordLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objRecord  //对象
	Set obj.IMPKeywords	 = IMPKeywords 
	Set obj.IMPReasonDr	 = objReason
	Set obj.StatusDr	 = objStatus
	Set obj.Opinion	 	 = Opinion
	Set obj.ActDate    	 = ActDate
	Set obj.ActTime      = ActTime
	Set obj.ActUserID    = ActUserID	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=$p(obj.%Id(),"||",2)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-09-28
/// Description:  删除对象信息
/// Table：       DHCMA.IMP.IP.IMPRecordLog
/// Input：       aId : DHCMA.IMP.IP.IMPRecordLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRecordLog).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.IMPRecordLog).%DeleteId(aId)
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
<Value>IMPKeywords</Value>
</Value>
<Value name="3">
<Value>IMPReasonDr</Value>
</Value>
<Value name="4">
<Value>StatusDr</Value>
</Value>
<Value name="5">
<Value>Opinion</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^MA.IMP.IPIMPRecordI("Log")</IndexLocation>
<StreamLocation>^MA.IMP.IPIMPRecordLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
