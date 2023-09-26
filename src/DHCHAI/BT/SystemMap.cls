/// 名称: DHCHAI.BT.SystemMap
/// 描述: 应用子系统对照表
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.BT.SystemMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 系统名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// HIS关联码
Property BTHISCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 系统类型
Property BTTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 医院
Property BTHospDr As DHCHAI.BT.Hospital [ Required ];

/// 是否有效（同一类型系统,同一个医院分组,只允许有一个当前有效）
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 代码索引
Index IdxofCode On BTCode As Exact;

/// 医院+类型索引
Index IdxofHospDrTypeDr On (BTHospDr, BTTypeDr);

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取应用子系统对照信息
/// Table：       DHCHAI.BT.SystemMap
/// Input：       aId : DHCHAI.BT.SystemMap.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SystemMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.SystemMap
{
	New (aId)
	Quit:'##class(DHCHAI.BT.SystemMap).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.SystemMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据Code取应用子系统对照信息
/// Table：       DHCHAI.BT.SystemMap
/// Input：       aCode : DHCHAI.BT.SystemMap.BTCode
/// Return：      返回Obj
/// w ##class(DHCHAI.BT.SystemMap).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.SystemMap
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set aCode=$zcvt(aCode,"U")  //字母大写
	Set ID=$o(^DHCHAI.BT.SystemMapI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTHospDr) return  //不维护医院认为无效
	Set return=obj
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-11
/// Description:  根据HospGrpID取对应子系统代码
/// Table：       DHCHAI.BT.SystemMap
/// Input：       aHospGrpID:   DHCHAI.BT.HospGroup.ID
/// Return：      返回%String
/// w ##class(DHCHAI.BTS.SystemMapSrv).GetSCodeList(1)
ClassMethod GetSCodeList(aHospGrpID As %String = "") As %String
{
	New (aHospGrpID)
	Set return=""
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.SystemMapD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.BT.SystemMap).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.BTHospDr)
		Continue:'$IsObject(obj.BTHospDr.BTGroupDr)  //不维护医院认为无效
		Set tHospGrpID=obj.BTHospDr.BTGroupDr.%Id()
		Continue:(aHospGrpID'="")&(tHospGrpID'=aHospGrpID)
		Set SCode=obj.BTCode
		Continue:SCode=""
		Set return=return_$lb(SCode)
	}
	Set:return'="" return=$listtostring(return,",")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新应用子系统对照信息
/// Table：       DHCHAI.BT.SystemMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SystemMap).Update("2^LIS02^东华检验系统V2^4^1^1^2017-05-17^09:00:00^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code        = $p(aInputStr,aSeparete,2)
	Set Desc        = $p(aInputStr,aSeparete,3)
	Set HISCode     = $p(aInputStr,aSeparete,4)
	Set TypeDr      = $p(aInputStr,aSeparete,5)
	Set HospDr      = $p(aInputStr,aSeparete,6)
	Set IsActive    = +$p(aInputStr,aSeparete,7)
	Set ActDate   	= $p(aInputStr,aSeparete,8)
	Set ActTime   	= $p(aInputStr,aSeparete,9)
	Set ActUserDr   = $p(aInputStr,aSeparete,10)
	Quit:(Code="")||(Desc="")||(TypeDr="")||(HospDr="")||(IsActive="") return
	
	Set Code=$zcvt(Code,"U")  //字母大写
	Set HISCode=$zcvt(HISCode,"U")  //字母大写
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符

	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set tID=$o(^DHCHAI.BT.SystemMapI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	Quit:'$IsObject(objType) return
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(HospDr)
	Quit:'$IsObject(objHosp) return
	
	Set HospGroupDr = objHosp.BTGroupDr
	if HospGroupDr'=""{ //验证已维护数据是否有 同一类型系统,同一个医院分组,且有效情况
		Set CheckFlg = 1
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.SystemMapI("IdxofHospDrTypeDr",HospDr,TypeDr,xID))
			Quit:xID=""
			Quit:CheckFlg=0
			
			Set objSystemMap = ##class(DHCHAI.BT.SystemMap).GetObjById(xID)
			Continue:$isobject(objSystemMap)
			
			if (objSystemMap.BTIsActive=1)||(objSystemMap.BTHospDr.BTGroupDr=HospGroupDr){
				Set CheckFlg=0
			}
		}
		Quit:CheckFlg=0 -2
	}
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	If ID="" {
		Set obj=##class(DHCHAI.BT.SystemMap).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.SystemMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTHISCode   = HISCode
	Set obj.BTTypeDr    = objType
	Set obj.BTHospDr	= objHosp
	Set obj.BTIsActive  = IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUserDr	= objActUser
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

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  删除应用子系统对照信息
/// Table：       DHCHAI.BT.SystemMap
/// Input：       aId : DHCHAI.BT.SystemMap.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SystemMap).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.SystemMap).%DeleteId(aId)
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
<Data name="SystemMapDefaultData">
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
<Value>BTHISCode</Value>
</Value>
<Value name="5">
<Value>BTTypeDr</Value>
</Value>
<Value name="6">
<Value>BTHospDr</Value>
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
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.SystemMapD</DataLocation>
<DefaultData>SystemMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.SystemMapD</IdLocation>
<IndexLocation>^DHCHAI.BT.SystemMapI</IndexLocation>
<StreamLocation>^DHCHAI.BT.SystemMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
