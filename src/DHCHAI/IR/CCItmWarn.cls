/// 名称: DHCHAI.IR.CCItmWarn
/// 描述: 暴发预警项目定义
/// 编写者：zhufei
/// 编写日期: 2017-05-14
Class DHCHAI.IR.CCItmWarn Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目名称
Property CCDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目名称2
Property CCDesc2 As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关键词(多值“,”分割)
Property CCKeyWords As %String(MAXLEN = 100, TRUNCATE = 1);

/// 排序码
Property CCIndNo As %String(TRUNCATE = 1);

/// 参数1
Property CCArg1 As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 参数2
Property CCArg2 As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 参数3
Property CCArg3 As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 参数4
Property CCArg4 As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 参数5
Property CCArg5 As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 是否有效
Property CCIsActive As %Boolean;

/// 更新日期
Property CCActDate As %Date;

/// 更新时间
Property CCActTime As %Time;

/// 更新人
Property CCActUserDr As DHCHAI.BT.SysUser;

Index IdxofDesc On CCDesc As Exact;

Index IdxofIndNo On CCIndNo;

/// Creator：     zhufei
/// CreatDate：   2017-05-14
/// Description:  根据ID取暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       aId : DHCHAI.IR.CCItmWarn.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCItmWarn).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCItmWarn
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCItmWarn).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCItmWarn).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据Code取暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       aCode : DHCHAI.IR.CCItmWarn.CCDesc
/// Return：      返回Obj
/// w ##class(DHCHAI.IR.CCItmWarn).GetObjByDesc("CS1")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.IR.CCItmWarn
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set ID=$o(^DHCHAI.IR.CCItmWarnI("IdxofDesc",aDesc,0))
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.CCIsActive'=1 return
	Set return=obj
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-14
/// Description:  更新暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCItmWarn).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set Desc        = $p(aInputStr,aSeparete,2)
	Set Desc2       = $p(aInputStr,aSeparete,3)
	Set KeyWords    = $p(aInputStr,aSeparete,4)
	Set IndNo       = $p(aInputStr,aSeparete,5)
	Set Arg1        = $p(aInputStr,aSeparete,6)
	Set Arg2        = $p(aInputStr,aSeparete,7)
	Set Arg3        = $p(aInputStr,aSeparete,8)
	Set Arg4        = $p(aInputStr,aSeparete,9)
	Set Arg5        = $p(aInputStr,aSeparete,10)	
	Set IsActive    = +$p(aInputStr,aSeparete,11)
	Set ActDate     = $p(aInputStr,aSeparete,12)
	Set ActTime     = $p(aInputStr,aSeparete,13)
	Set ActUserDr   = $p(aInputStr,aSeparete,14)
	Quit:(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	Set Desc2 = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc2)
	Set KeyWords = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(KeyWords)
	
	Set tID=$o(^DHCHAI.IR.CCItmWarnI("IdxofDesc",Desc,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCItmWarn).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCItmWarn).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CCDesc        = Desc
	Set obj.CCDesc2       = Desc2
	Set obj.CCKeyWords    = KeyWords
	Set obj.CCIndNo       = IndNo
	Set obj.CCArg1        = Arg1    
	Set obj.CCArg2        = Arg2    
	Set obj.CCArg3        = Arg3    
	Set obj.CCArg4        = Arg4    
	Set obj.CCArg5        = Arg5  
	Set obj.CCIsActive    = IsActive
	Set obj.CCActDate     = ActDate
	Set obj.CCActTime     = ActTime
	Set obj.CCActUserDr   = objActUser
	
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
/// CreatDate：   2017-05-14
/// Description:  删除暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       aId : DHCHAI.IR.CCItmWarn.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCItmWarn).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.IR.CCItmWarn")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.IR.CCItmWarn).%DeleteId(aId)
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
<Data name="CCItmWarnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCDesc</Value>
</Value>
<Value name="3">
<Value>CCDesc2</Value>
</Value>
<Value name="4">
<Value>CCKeyWords</Value>
</Value>
<Value name="5">
<Value>CCIndNo</Value>
</Value>
<Value name="6">
<Value>CCArg1</Value>
</Value>
<Value name="7">
<Value>CCArg2</Value>
</Value>
<Value name="8">
<Value>CCArg3</Value>
</Value>
<Value name="9">
<Value>CCArg4</Value>
</Value>
<Value name="10">
<Value>CCArg5</Value>
</Value>
<Value name="11">
<Value>CCIsActive</Value>
</Value>
<Value name="12">
<Value>CCActDate</Value>
</Value>
<Value name="13">
<Value>CCActTime</Value>
</Value>
<Value name="14">
<Value>CCActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCItmWarnD</DataLocation>
<DefaultData>CCItmWarnDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCItmWarnD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCItmWarnI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCItmWarnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
