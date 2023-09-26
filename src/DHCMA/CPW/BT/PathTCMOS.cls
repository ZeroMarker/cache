/// 名称: DHCMA.CPW.BT.PathTCMOS
/// 描述: 临床路径 中药方剂与协定方对照
/// 编写者：zhufei
/// 编写日期: 2019-05-28
Class DHCMA.CPW.BT.PathTCMOS Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 中药方剂
Property TOTCMDr As DHCMA.CPW.BT.PathTCM [ Required ];

/// 中药-协定方 ID指针
Property TOARCOSID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 有效标志
Property TOIsActive As %Boolean;

/// 处置日期
Property TOActDate As %Date;

/// 处置时间
Property TOActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property TOActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxPathTCMOS On (TOTCMDr, TOARCOSID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  根据ID取中药方剂协定处方对照信息
/// Table：       DHCMA.CPW.BT.PathTCMOS
/// Input：       aId :  DHCMA.CPW.BT.PathTCMOS.ID
/// Return：      返回obj
/// zw ##class(DHCMA.CPW.BT.PathTCMOS).GetObjById("8||3")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathTCMOS
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCMA.CPW.BT.PathTCMOS).%ExistsId(aId) return
	set obj=##Class(DHCMA.CPW.BT.PathTCMOS).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  删除中药方剂协定处方对照信息
/// Table：       DHCMA.CPW.BT.PathTCMOS
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathTCMOS).DeleteById("2||2")
ClassMethod DeleteById(aId)
{
	new (aId)
	set sc = ##class(DHCMA.CPW.BT.PathTCMOS).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  更新中药方剂协定处方对照信息
/// Table：       DHCMA.CPW.BT.PathTCMOS
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码  （=0 参数错误）
/// w ##class(DHCMA.CPW.BT.PathTCMOS).Update()
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	new (aInStr,aSeparete)
	set return=0
	quit:aInStr="" return
	
	set:$g(aSeparete)="" aSeparete="^"
	set ID           = $p(aInStr,aSeparete,1)
	set PathTCMDr    = $p(aInStr,aSeparete,2)
	set ARCOSID      = $p(aInStr,aSeparete,3)
	set IsActive     = $p(aInStr,aSeparete,4)
	set ActDate      = $p(aInStr,aSeparete,5)
	set ActTime      = $p(aInStr,aSeparete,6)
	set ActUserID    = $p(aInStr,aSeparete,7)
	quit:(PathTCMDr="")||(ARCOSID="") return
	
	set:ActDate="" ActDate = +$h
	set:ActTime="" ActTime = $p($h,",",2)
	
	set objPathTCM=##class(DHCMA.CPW.BT.PathTCM).GetObjById(PathTCMDr)
	quit:'$IsObject(objPathTCM) return
	
	set tID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",PathTCMDr," "_$zcvt(ARCOSID,"U"),0))
	quit:(tID'="")&(ID'=tID) -2	    //根据代码找ID,如果id对不上号 返回-2
	
	if ID="" {
		set obj=##class(DHCMA.CPW.BT.PathTCMOS).%New()
	}else{
		set obj=##class(DHCMA.CPW.BT.PathTCMOS).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.TOTCMDr     = objPathTCM
	set obj.TOARCOSID   = ARCOSID
	set obj.TOIsActive  = IsActive
	set obj.TOActDate   = ActDate
	set obj.TOActTime   = ActTime
	set obj.TOActUserID = ActUserID
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

Storage Default
{
<Data name="PathTCMOSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TOTCMDr</Value>
</Value>
<Value name="3">
<Value>TOARCOSID</Value>
</Value>
<Value name="4">
<Value>TOIsActive</Value>
</Value>
<Value name="5">
<Value>TOActDate</Value>
</Value>
<Value name="6">
<Value>TOActTime</Value>
</Value>
<Value name="7">
<Value>TOActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathTCMOSD</DataLocation>
<DefaultData>PathTCMOSDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathTCMOSD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathTCMOSI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathTCMOSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
