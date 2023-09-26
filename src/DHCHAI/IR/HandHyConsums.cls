/// 名称: DHCHAI.IR.HandHyConsums
/// 描述: 手卫生用品消耗量登记
/// 编写者：zhoubo
/// 编写日期: 2017-12-20
Class DHCHAI.IR.HandHyConsums Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查科室
Property HHCLocDr As DHCHAI.BT.Location;

/// 调查日期
Property HHCObsDate As %Date;

/// 手卫生用品
Property HHCProduct As DHCHAI.IR.HandHyProducts;

/// 手卫生用品消耗量
Property HHCConsumption As %String(TRUNCATE = 1);

/// 领用人
Property HHCRecipient As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记日期
Property HHCRepDate As %Date;

/// 登记时间
Property HHCRepTime As %Time;

/// 登记人
Property HHCRegUserDr As DHCHAI.BT.SysUser;

/// 是否有效
Property HHCActive As %Boolean;

/// 备注
Property HHCResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 第三方系统ID存储防止重复
Property xCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查科室+调查日期
Index IndexLocDate On (HHCLocDr, HHCObsDate);

/// 第三方系统ID索引
Index IndexxCode On xCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-12-28
/// Description:  根据ID取手卫生用品消耗量登记信息
/// Table：       DHCHAI.IR.HandHyConsums
/// Input：       aId : DHCHAI.IR.HandHyConsums.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.HandHyConsums).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.HandHyConsums
{
	New (aId)
	Quit:'##class(DHCHAI.IR.HandHyConsums).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.HandHyConsums).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-28
/// Description:  更新手卫生用品消耗量登记信息
/// Table：       DHCHAI.IR.HandHyConsums
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyConsums).Update("^6^2017-12^1^5瓶^周波^^^23^1^beizhuxinxi","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID          = $p(aInputStr,aSeparete,1)
	Set LocDr	    = $p(aInputStr,aSeparete,2)
	Set ObsDate     = $p(aInputStr,aSeparete,3)
	Set ProductDr   = $p(aInputStr,aSeparete,4)
	Set Consumption = $p(aInputStr,aSeparete,5)
	Set Recipient   = $p(aInputStr,aSeparete,6)
	Set RepDate     = $p(aInputStr,aSeparete,7)
	Set RepTime     = $p(aInputStr,aSeparete,8)
	Set RegUserDr   = $p(aInputStr,aSeparete,9)
	Set Active      = $p(aInputStr,aSeparete,10)
	Set Resume      = $p(aInputStr,aSeparete,11)
	Set xCode       = $p(aInputStr,aSeparete,12)
	Quit:(LocDr="")||(ObsDate="")||(ProductDr="")||(Consumption="")||(Recipient="") return
	Set:RepDate="" RepDate=+$h
	Set:RepTime="" RepTime=$p($h,",",2) 
	Set ObsDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ObsDate)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Set objProduct=##class(DHCHAI.IR.HandHyProducts).GetObjById(ProductDr)
	Quit:'$IsObject(objProduct) return
	Set objRegUser=##class(DHCHAI.BT.SysUser).GetObjById(RegUserDr)
	Quit:'$IsObject(objRegUser) return
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.HandHyConsums).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.HandHyConsums).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.HHCLocDr       = objLoc
	Set obj.HHCObsDate     = ObsDate
	Set obj.HHCProduct     = objProduct
	Set obj.HHCConsumption = Consumption
	Set obj.HHCRecipient   = Recipient
	Set obj.HHCRepDate     = RepDate
	Set obj.HHCRepTime     = RepTime
	Set obj.HHCRegUserDr   = objRegUser
	Set obj.HHCActive      = Active
	Set obj.HHCResume      = Resume
	Set obj.xCode          =xCode
	
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
/// CreatDate：   2017-12-28
/// Description:  删除手卫生用品消耗量登记信息
/// Table：       DHCHAI.IR.HandHyConsums
/// Input：       aId : DHCHAI.IR.HandHyConsums.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyConsums).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.HandHyConsums).%DeleteId(aId)
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
<Data name="HandHyConsumsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHCLocDr</Value>
</Value>
<Value name="3">
<Value>HHCObsDate</Value>
</Value>
<Value name="4">
<Value>HHCProduct</Value>
</Value>
<Value name="5">
<Value>HHCConsumption</Value>
</Value>
<Value name="6">
<Value>HHCRecipient</Value>
</Value>
<Value name="7">
<Value>HHCRepDate</Value>
</Value>
<Value name="8">
<Value>HHCRepTime</Value>
</Value>
<Value name="9">
<Value>HHCRegUserDr</Value>
</Value>
<Value name="10">
<Value>HHCActive</Value>
</Value>
<Value name="11">
<Value>HHCResume</Value>
</Value>
<Value name="12">
<Value>xCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.HandHyConsumsD</DataLocation>
<DefaultData>HandHyConsumsDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.HandHyConsumsD</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyConsumsI</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyConsumsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
