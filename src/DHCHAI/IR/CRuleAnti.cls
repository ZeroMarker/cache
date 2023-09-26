/// 名称: DHCHAI.IR.CRuleAnti
/// 描述: 抗菌用药筛查维护
/// 编写者：zhufei
/// 编写日期: 2017-11-28
Class DHCHAI.IR.CRuleAnti Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型（1全院、2院区、3科室）
Property BTType As %Integer [ Required ];

/// 全院
Property BTHospGrpDr As DHCHAI.BT.HospGroup [ Required ];

/// 院区
Property BTHospDr As DHCHAI.BT.Hospital;

/// 科室
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 抗菌用药分类
Property BTAntiCatDr As DHCHAI.DP.OEAntiCat;

/// 抗菌用药字典
Property BTAntiMastDr As DHCHAI.DP.OEAntiMast;

/// 抗菌用药（自定义）
Property BTAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As DHCHAI.BT.SysUser;

Index IndexTypeLocDr On (BTType, BTLocDr);

Index IndexTypeHospDr On (BTType, BTHospDr);

Index IndexTypeHospGrpDr On (BTType, BTHospGrpDr);

Index IndexTypeAntiCatMastDr On (BTType, BTAntiCatDr, BTAntiMastDr);

/// Creator：     mayanpeng
/// CreatDate：   2017-11-29
/// Description:  根据ID取抗菌用药筛查
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       ID:DHCHAI.IR.CRuleAnti.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.CRuleAnti).GetObjById(1)
ClassMethod GetObjById(Id As %String) As DHCHAI.IR.CRuleAnti
{
	New (Id)
	Set return=""
	Quit:Id="" return
	Quit:'##class(DHCHAI.IR.CRuleAnti).%ExistsId(+Id) return
	
	Set obj=##Class(DHCHAI.IR.CRuleAnti).%OpenId(+Id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-11-29
/// Description:  更新抗菌用药筛查
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleAnti).Update("^1^^3^2333^1^1^^1^^^7935")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Type		= $p(InStr,aSeparete,2)
	Set HospGrpDr	= $p(InStr,aSeparete,3)
	Set HospDr		= $p(InStr,aSeparete,4)
	Set LocDr		= $p(InStr,aSeparete,5)
	Set AntiCatDr	= $p(InStr,aSeparete,6)
	Set AntiMastDr	= $p(InStr,aSeparete,7)
	Set AntiDesc	= $p(InStr,aSeparete,8)
	Set IsActive	= +$p(InStr,aSeparete,9)
	Set ActDate		= $p(InStr,aSeparete,10)
	Set ActTime		= $p(InStr,aSeparete,11)
	Set ActUserDr	= $p(InStr,aSeparete,12)
	Quit:(Type="")||(HospDr="")||(LocDr="") return
	
	//代码唯一性
	Set tID =$o(^DHCHAI.IR.CRuleAntiI("IndexTypeAntiCatMastDr",Type,AntiCatDr,AntiMastDr,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	//Set:ActDate["-" ActDate = $zdh(ActDate,3)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate = +$h
	Set:ActTime="" ActTime = +($p($h,",",2))
	
	Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(HospDr)
	Quit:'$IsObject(objHosp) return
	If (HospGrpDr=""){
		Set objHospGrp = objHosp.BTGroupDr
	}Else{
		Set objHospGrp = ##class(DHCHAI.BT.HospGroup).GetObjById(HospGrpDr)
		Quit:'$IsObject(objHospGrp) return
	}
	
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Set objAntiCat = ##class(DHCHAI.DP.OEAntiCat).GetObjById(AntiCatDr)
	Set objAntiMast = ##class(DHCHAI.DP.OEAntiMast).GetObjById(AntiMastDr)
	Quit:('$IsObject(objAntiMast) && '$IsObject(objAntiCat)) return //抗菌用药分类与字典不能同时为空
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.CRuleAnti).%New()
	}else{
		Set obj=##class(DHCHAI.IR.CRuleAnti).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTType		= Type
	Set obj.BTHospGrpDr	= objHospGrp
	Set obj.BTHospDr	= objHosp
	Set obj.BTLocDr		= objLoc
	Set obj.BTAntiCatDr	= objAntiCat
	Set obj.BTAntiMastDr= objAntiMast
	Set obj.BTAntiDesc	= AntiDesc
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= objActUser
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

/// Creator：     mayanpeng
/// CreatDate：   2017-11-29
/// Description:  根据ID取抗菌用药筛查
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.CRuleAnti).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="CRuleAntiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTType</Value>
</Value>
<Value name="3">
<Value>BTHospGrpDr</Value>
</Value>
<Value name="4">
<Value>BTHospDr</Value>
</Value>
<Value name="5">
<Value>BTLocDr</Value>
</Value>
<Value name="6">
<Value>BTAntiCatDr</Value>
</Value>
<Value name="7">
<Value>BTAntiMastDr</Value>
</Value>
<Value name="8">
<Value>BTAntiDesc</Value>
</Value>
<Value name="9">
<Value>BTIsActive</Value>
</Value>
<Value name="10">
<Value>BTActDate</Value>
</Value>
<Value name="11">
<Value>BTActTime</Value>
</Value>
<Value name="12">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleAntiD</DataLocation>
<DefaultData>CRuleAntiDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleAntiD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleAntiI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
