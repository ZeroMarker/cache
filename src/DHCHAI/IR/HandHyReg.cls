/// 名称: DHCHAI.IR.HandHyReg
/// 描述: 手卫生依从性调查登记
/// 编写者：zhufei
/// 编写日期: 2017-12-15
Class DHCHAI.IR.HandHyReg Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查人数
Relationship ChildCnt As DHCHAI.IR.HandHyRegCnt [ Cardinality = children, Inverse = Parref ];

/// 调查时机
Relationship ChildTim As DHCHAI.IR.HandHyRegTim [ Cardinality = children, Inverse = Parref ];

/// 调查科室
Property HHLocDr As DHCHAI.BT.Location;

/// 调查日期
Property HHObsDate As %Date;

/// 调查方法（自查or督察）("HandHyObsMethod")
Property HHObsMethodDr As DHCHAI.BT.Dictionary;

/// 调查第几页("HandHyObsPage")
Property HHObsPageDr As DHCHAI.BT.Dictionary;

/// 调查人
Property HHObsUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property HHIsActive As %Boolean;

/// 登记日期
Property HHRegDate As %Date;

/// 登记时间
Property HHRegTime As %Time;

/// 登记人
Property HHRegUserDr As DHCHAI.BT.SysUser;

/// 调查日期+调查第几页
Index IndexDatePage On (HHObsDate, HHObsPageDr);

/// 调查科室+调查日期+调查第几页
Index IndexLocDatePage On (HHLocDr, HHObsDate, HHObsPageDr);

/// 调查科室+调查日期+调查第几页+调查方法  唯一索引
Index IndexLocDatePageMethod On (HHLocDr, HHObsDate, HHObsPageDr, HHObsMethodDr);

/// 调查科室+调查日期+调查方法+调查第几页  唯一索引 add by 需求序号	3085119
Index IndexLocDateMethodPage On (HHLocDr, HHObsDate, HHObsMethodDr, HHObsPageDr);

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  根据ID取手卫生依从性调查登记
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aId : DHCHAI.IR.HandHyReg.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.HandHyReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.HandHyReg
{
	New (aId)
	Quit:'##class(DHCHAI.IR.HandHyReg).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.HandHyReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-27
/// Description:  根据调查科室+调查日期+调查第几页取调查表ID
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aLocDr
/// Return：      返回DHCHAI.IR.HandHyReg.%Id()
/// w ##class(DHCHAI.IR.HandHyReg).GetIDByLocDate(6,"2017-12",684)
ClassMethod GetIDByLocDate(aLocDr As %String, aObsDate As %String, aObsPageDr As %String, aObsMethodDr As %String = "") As %String
{
	New (aLocDr,aObsDate,aObsPageDr,aObsMethodDr)
	Set return=""
	//Set:aObsDate'="" aObsDate=$zdh(aObsDate,3)
	Set:aObsDate'="" aObsDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aObsDate)
	Quit:((aLocDr="")||(aObsDate="")||(aObsPageDr="")||(aObsMethodDr="")) return
	
	Set ID=$o(^DHCHAI.IR.HandHyRegI("IndexLocDatePageMethod",aLocDr,aObsDate,aObsPageDr,aObsMethodDr,0))
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit ID
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  更新手卫生依从性调查登记
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyReg).Update("^6^683^2017-12^med^1^^^3884","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID          = $p(aInputStr,aSeparete,1)
	Set LocDr	    = $p(aInputStr,aSeparete,2)
	Set ObsMethodDr = $p(aInputStr,aSeparete,3)
	Set ObsPageDr   = $p(aInputStr,aSeparete,4)
	Set ObsDate     = $p(aInputStr,aSeparete,5)
	Set ObsUser     = $p(aInputStr,aSeparete,6)
	Set IsActive    = $p(aInputStr,aSeparete,7)
	Set RegDate     = $p(aInputStr,aSeparete,8)
	Set RegTime     = $p(aInputStr,aSeparete,9)
	Set RegUserDr   = $p(aInputStr,aSeparete,10)
	Quit:(LocDr="")||(ObsPageDr="")||(ObsDate="")||(RegUserDr="")||(ObsMethodDr="") return

	Set ObsDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ObsDate)
	
	Set:RegDate'="" RegDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RegDate)
	Set:RegTime[":" RegTime = $zth(RegTime,1)
	Set:RegDate="" RegDate=+$h
	Set:RegTime="" RegTime=$p($h,",",2)
	Set objRegUser=##class(DHCHAI.BT.SysUser).GetObjById(RegUserDr)
	Quit:'$IsObject(objRegUser) return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return

	Set objObsPage=##class(DHCHAI.BT.Dictionary).GetObjById(ObsPageDr)
	Quit:'$IsObject(objObsPage) return
	Set objObsMethod=##class(DHCHAI.BT.Dictionary).GetObjById(ObsMethodDr)
	Quit:'$IsObject(objObsMethod) return
	// 科室+日期+调查第几页 唯一性
	Set tID = $o(^DHCHAI.IR.HandHyRegI("IndexLocDatePageMethod",LocDr,ObsDate,ObsPageDr,ObsMethodDr,0))
	Quit:(tID'="")&(ID'=tID) -2
	If ID="" {
		Set obj=##class(DHCHAI.IR.HandHyReg).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.HandHyReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.HHLocDr      = objLoc
	Set obj.HHObsDate    = ObsDate
	Set obj.HHObsMethodDr= objObsMethod
	Set obj.HHObsPageDr  = objObsPage
	Set obj.HHObsUser    = ObsUser
	Set obj.HHIsActive   = IsActive
	Set obj.HHRegDate    = RegDate
	Set obj.HHRegTime    = RegTime
	Set obj.HHRegUserDr  = objRegUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  删除手卫生依从性调查登记
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aId : DHCHAI.IR.HandHyReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.HandHyReg).%DeleteId(aId)
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
<Data name="HandHyRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHLocDr</Value>
</Value>
<Value name="3">
<Value>HHObsDate</Value>
</Value>
<Value name="4">
<Value>HHObsPageDr</Value>
</Value>
<Value name="5">
<Value>HHObsUser</Value>
</Value>
<Value name="6">
<Value>HHIsActive</Value>
</Value>
<Value name="7">
<Value>HHRegDate</Value>
</Value>
<Value name="8">
<Value>HHRegTime</Value>
</Value>
<Value name="9">
<Value>HHRegUserDr</Value>
</Value>
<Value name="10">
<Value>HHObsMethodDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.HandHyRegD</DataLocation>
<DefaultData>HandHyRegDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.HandHyRegD</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyRegI</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
