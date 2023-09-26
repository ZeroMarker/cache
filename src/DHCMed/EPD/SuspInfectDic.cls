/// 传染病疑似诊断
Class DHCMed.EPD.SuspInfectDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 传染病诊断
Property BTInfectDr As DHCMed.EPD.Infection;

/// 传染病分类
Property BTKindDr As DHCMed.SS.Dictionary;

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新用户
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  根据ID取传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       aId : DHCMed.EPD.SuspInfectDic.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.SuspInfectDic).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.SuspInfectDic
{
	New (aId)
	Quit:'##class(DHCMed.EPD.SuspInfectDic).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.SuspInfectDic).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  更新传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspInfectDic).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Code      = $p(aInputStr,aSeparete,2)
	Set Desc      = $p(aInputStr,aSeparete,3)
	Set InfectDr  = $p(aInputStr,aSeparete,4)
	Set KindDr    = $p(aInputStr,aSeparete,5)
	Set IndNo     = $p(aInputStr,aSeparete,6)
	Set IsActive  = $p(aInputStr,aSeparete,7)
	Set ActDate   = $p(aInputStr,aSeparete,8)
	Set ActTime   = $p(aInputStr,aSeparete,9)
	Set ActUser   = $p(aInputStr,aSeparete,10)
	Quit:(Code="")||(Desc="")||(KindDr="") return

	Set objInfect=##class(DHCMed.EPD.Infection).GetObjById(InfectDr)
	Set objKind=##class(DHCMed.SS.Dictionary).GetObjById(KindDr)
	Quit:'$IsObject(objKind) return
	
	Set:ActDate'="" ActDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set tID=$o(^DHCMed.EPD.SuspInfectDicI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	Set tID=$o(^DHCMed.EPD.SuspInfectDicI("IdxofDesc",Desc,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.SuspInfectDic).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.SuspInfectDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode      = Code    
	Set obj.BTDesc      = Desc    
	Set obj.BTInfectDr  = objInfect
	Set obj.BTKindDr    = objKind  
	Set obj.BTIndNo     = IndNo   
	Set obj.BTIsActive  = IsActive
	Set obj.BTActDate   = ActDate 
	Set obj.BTActTime   = ActTime 
	Set obj.BTActUser   = ActUser   
    
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

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  删除传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       aId : DHCMed.EPD.SuspInfectDic.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspInfectDic).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.EPD.SuspInfectDic")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMed.EPD.SuspInfectDic).%DeleteId(aId)
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
<Data name="SuspInfectDicDefaultData">
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
<Value>BTInfectDr</Value>
</Value>
<Value name="5">
<Value>BTKindDr</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.SuspInfectDicD</DataLocation>
<DefaultData>SuspInfectDicDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.SuspInfectDicD</IdLocation>
<IndexLocation>^DHCMed.EPD.SuspInfectDicI</IndexLocation>
<StreamLocation>^DHCMed.EPD.SuspInfectDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
