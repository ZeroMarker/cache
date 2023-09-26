/// 名称: DHCHAI.IR.VAERuleConfig
/// 描述: VAE监测规则定义
/// 编写者: zhoubo
/// 编写日期: 2022-01-12
Class DHCHAI.IR.VAERuleConfig Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// VAE监测项目
Property VAEMonitItemDr As DHCHAI.IR.VAEMonitItem;

/// VAE监测项目子项
Property VAESubItemDr As DHCHAI.IR.VAESubItem;

/// 参数1(多值“,”分割)
Property VAEArg1 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数2
Property VAEArg2 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数3
Property VAEArg3 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数4
Property VAEArg4 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数5
Property VAEArg5 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数6
Property VAEArg6 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数7
Property VAEArg7 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数8
Property VAEArg8 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数9
Property VAEArg9 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数10
Property VAEArg10 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数11
Property VAEArg11 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数12
Property VAEArg12 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数13
Property VAEArg13 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数14
Property VAEArg14 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 参数15
Property VAEArg15 As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 规则运算逻辑关系
Property VAERuleLogic As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property VAEIsActive As %Boolean;

/// 更新日期
Property VAEActDate As %Date;

/// 更新时间
Property VAEActTime As %Time;

/// 更新人
Property VAEActUserDr As DHCHAI.BT.SysUser;

/// 监测项目索引
Index IndexMonitItemDr On VAEMonitItemDr As Exact;

/// 监测项目+子项
Index IndexMonitItemSubDr On (VAEMonitItemDr, VAESubItemDr);

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  更新VAE监测规则逻辑关系
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).UpdateLogic("1","")
ClassMethod UpdateLogic(aMonitItemDr As %String, aRuleLogic As %String) As %String
{
	New (aMonitItemDr,aRuleLogic)
	Set return=0
	Quit:aMonitItemDr="" return
	
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemDr",aMonitItemDr,xID))
		Quit:xID=""
		Continue:'##class(DHCHAI.IR.VAERuleConfig).%ExistsId(xID)
		Set obj=##Class(DHCHAI.IR.VAERuleConfig).%OpenId(xID)
		
		Set obj.VAERuleLogic = aRuleLogic
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
		
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  获取VAE监测规则逻辑关系
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).GetVAELogic("1")
ClassMethod GetVAELogic(aMonitItemDr As %String) As %String
{
	New (aMonitItemDr)
	Set return=""
	Quit:aMonitItemDr="" return
	
	Set VAERuleLogic =""
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemDr",aMonitItemDr,xID))
		Quit:xID=""
		Set obj=##Class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set VAERuleLogic = obj.VAERuleLogic
		Quit  // 只需要一条数据
	}
	Quit VAERuleLogic
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  根据ID取VAE监测规则
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       aId : DHCHAI.IR.VAERuleConfig.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.VAERuleConfig).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.VAERuleConfig
{
	New (aId)
	Quit:'##class(DHCHAI.IR.VAERuleConfig).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.VAERuleConfig).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  删除VAE检验医嘱信息 ---公用
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).DeleteLabOE("1^ItmCode5A1^1721^1,2,4,5","^")
ClassMethod DeleteLabOE(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set VAEMonitItemDr = $p(aInputStr,aSeparete,1)
	Set SubItemID    = $p(aInputStr,aSeparete,2)
	Set DelVAEInfo   = $p(aInputStr,aSeparete,3)
	Set ClickEventID = $p(aInputStr,aSeparete,4)
	
	Quit:(VAEMonitItemDr="")||(SubItemID="") return
	Set ID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",VAEMonitItemDr,SubItemID,0))
	Quit:ID="" return
	Set obj=##class(DHCHAI.IR.VAERuleConfig).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set ArgNo = $p(ClickEventID,"A",2)
	Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
	X ExpInfo
	Set VAEArg="#"_VAEArg
	
	For i=1:1:$l(DelVAEInfo,"#"){
		Set tVAEArg=$p(DelVAEInfo,"#",i) 
		Continue:tVAEArg=""
		Set tmpVAEArg="#"_tVAEArg
		If (VAEArg[tmpVAEArg){
			Set VAEArg=$replace(VAEArg,tmpVAEArg,"")
		}
	}
	Set ExpInfo="Set obj.VAEArg"_ArgNo_"=VAEArg"
	X ExpInfo
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return_"%"_VAEArg
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  更新VAE检验医嘱信息 ---公用
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).UpdateLabOE("1^ItmCode5A1^1721^1,2,4,5","^")
ClassMethod UpdateLabOE(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set VAEMonitItemDr = $p(aInputStr,aSeparete,1)
	Set ClickEventID   = $p(aInputStr,aSeparete,2)
	Set LabOETypeID    = $p(aInputStr,aSeparete,3)
	Set aLabOEIDs      = $p(aInputStr,aSeparete,4)
	
	Quit:(VAEMonitItemDr="") return
	Set ArgNo = $p(ClickEventID,"A",2)
	Set VASItmCode = +$e(ClickEventID,8,$l(ClickEventID))
	Set SubItemID = ##class(DHCHAI.IR.VAESubItem).GetIDByCode(VASItmCode)
	Quit:SubItemID="" return
	Set aVAEArgInfo=""
	For i=1:1:$l(aLabOEIDs,","){
		Set VaeLabID=$p(aLabOEIDs,",",i)
		Continue:VaeLabID=""
		Set aVAEArgInfo=aVAEArgInfo_"#"_VaeLabID_","_LabOETypeID
	}
	Set ID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",VAEMonitItemDr,SubItemID,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.VAERuleConfig).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.VAERuleConfig).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set ObjItem = ##class(DHCHAI.IR.VAEMonitItem).GetObjById(VAEMonitItemDr)
	Set ObjSItm = ##class(DHCHAI.IR.VAESubItem).GetObjById(SubItemID)
	Set ExpInfo="Set VAEArg=obj.VAEArg"_ArgNo
	X ExpInfo
	Set:VAEArg["####" VAEArg=$replace(VAEArg,"####","#")
	Set VAEArg="#"_VAEArg
	//合并之前的规则
	For i=1:1:$l(aVAEArgInfo,"#"){
		Set tVAEArg=$p(aVAEArgInfo,"#",i) 
		Continue:tVAEArg=""
		Set tmpVAEArg="#"_(+tVAEArg)_","
		If (VAEArg[tmpVAEArg){
			Set RuleType=+$p(VAEArg,tmpVAEArg,"2")
			Set tmpVAEArg=tmpVAEArg_RuleType
			Set VAEArg=$replace(VAEArg,tmpVAEArg,("#"_tVAEArg))
		}Else{
			Set VAEArg=VAEArg_"#"_tVAEArg
		}
	}
	Set ExpInfo="Set obj.VAEArg"_ArgNo_"=VAEArg"
	X ExpInfo
	
	Set obj.VAEMonitItemDr = ObjItem
	Set obj.VAESubItemDr   = ObjSItm
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return_"%"_VAEArg
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  更新VAE监测规则
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).Update("^1^1^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^1^^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			   = $p(aInputStr,aSeparete,1)
	Set VAEMonitItemDr = $p(aInputStr,aSeparete,2)
	Set VAESubItemDr   = $p(aInputStr,aSeparete,3)
	Set VAEArg1        = $p(aInputStr,aSeparete,4)
	Set VAEArg2        = $p(aInputStr,aSeparete,5)
	Set VAEArg3        = $p(aInputStr,aSeparete,6)
	Set VAEArg4        = $p(aInputStr,aSeparete,7)
	Set VAEArg5        = $p(aInputStr,aSeparete,8)
	Set VAEArg6        = $p(aInputStr,aSeparete,9)
	Set VAEArg7        = $p(aInputStr,aSeparete,10)
	Set VAEArg8        = $p(aInputStr,aSeparete,11)
	Set VAEArg9        = $p(aInputStr,aSeparete,12)
	Set VAEArg10       = $p(aInputStr,aSeparete,13)
	Set VAEArg11       = $p(aInputStr,aSeparete,14)
	Set VAEArg12       = $p(aInputStr,aSeparete,15)
	Set VAEArg13       = $p(aInputStr,aSeparete,16)
	Set VAEArg14       = $p(aInputStr,aSeparete,17)
	Set VAEArg15       = $p(aInputStr,aSeparete,18)
	Set VAERuleLogic   = $p(aInputStr,aSeparete,19)
	Set VAEIsActive    = +$p(aInputStr,aSeparete,20)
	Set VAEActDate     = $p(aInputStr,aSeparete,21)
	Set VAEActTime     = $p(aInputStr,aSeparete,22)
	Set VAEActUserDr   = $p(aInputStr,aSeparete,23)
	
	Quit:(VAEMonitItemDr="")||(VAESubItemDr="") return
	
	Set:VAEActDate'="" VAEActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VAEActDate)
	Set:VAEActDate="" VAEActDate=+$h
	Set:VAEActTime[":" VAEActTime = $zth(VAEActTime,1)
	Set:VAEActTime="" VAEActTime=$p($h,",",2)
	Set ObjUser = ##class(DHCHAI.BT.SysUser).GetObjById(VAEActUserDr)
	Set ObjItem = ##class(DHCHAI.IR.VAEMonitItem).GetObjById(VAEMonitItemDr)
	Set ObjSItm = ##class(DHCHAI.IR.VAESubItem).GetObjById(VAESubItemDr)
	
	Set:ID="" ID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemSubDr",VAEMonitItemDr,VAESubItemDr,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.VAERuleConfig).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.VAERuleConfig).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VAEMonitItemDr = ObjItem
	Set obj.VAESubItemDr   = ObjSItm
	Set obj.VAEArg1        = VAEArg1
	Set obj.VAEArg2        = VAEArg2
	Set obj.VAEArg3        = VAEArg3
	Set obj.VAEArg4        = VAEArg4
	Set obj.VAEArg5        = VAEArg5
	Set obj.VAEArg6        = VAEArg6
	Set obj.VAEArg7        = VAEArg7
	Set obj.VAEArg8        = VAEArg8
	Set obj.VAEArg9        = VAEArg9
	Set obj.VAEArg10       = VAEArg10
	Set obj.VAEArg11       = VAEArg11
	Set obj.VAEArg12       = VAEArg12
	Set obj.VAEArg13       = VAEArg13
	Set obj.VAEArg14       = VAEArg14
	Set obj.VAEArg15       = VAEArg15
	Set obj.VAERuleLogic   = VAERuleLogic
	Set obj.VAEIsActive    = VAEIsActive
	Set obj.VAEActDate     = VAEActDate
	Set obj.VAEActTime	   = VAEActTime
	Set obj.VAEActUserDr   = ObjUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  删除VAE监测项目规则
/// Table：       DHCHAI.IR.VAERuleConfig
/// Input：       aId : DHCHAI.IR.VAERuleConfig.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAERuleConfig).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.VAERuleConfig).%DeleteId(aId)
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
<Data name="VAERuleConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VAEMonitItemDr</Value>
</Value>
<Value name="3">
<Value>VAESubItemDr</Value>
</Value>
<Value name="4">
<Value>VAEArg1</Value>
</Value>
<Value name="5">
<Value>VAEArg2</Value>
</Value>
<Value name="6">
<Value>VAEArg3</Value>
</Value>
<Value name="7">
<Value>VAEArg4</Value>
</Value>
<Value name="8">
<Value>VAEArg5</Value>
</Value>
<Value name="9">
<Value>VAEArg6</Value>
</Value>
<Value name="10">
<Value>VAEArg7</Value>
</Value>
<Value name="11">
<Value>VAEArg8</Value>
</Value>
<Value name="12">
<Value>VAEArg9</Value>
</Value>
<Value name="13">
<Value>VAEArg10</Value>
</Value>
<Value name="14">
<Value>VAEArg11</Value>
</Value>
<Value name="15">
<Value>VAEArg12</Value>
</Value>
<Value name="16">
<Value>VAEArg13</Value>
</Value>
<Value name="17">
<Value>VAEArg14</Value>
</Value>
<Value name="18">
<Value>VAEArg15</Value>
</Value>
<Value name="19">
<Value>VAERuleLogic</Value>
</Value>
<Value name="20">
<Value>VAEIsActive</Value>
</Value>
<Value name="21">
<Value>VAEActDate</Value>
</Value>
<Value name="22">
<Value>VAEActTime</Value>
</Value>
<Value name="23">
<Value>VAEActUserDr</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.VAERuleConfigD</DataLocation>
<DefaultData>VAERuleConfigDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.VAERuleConfigD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.VAERuleConfigI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.VAERuleConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
