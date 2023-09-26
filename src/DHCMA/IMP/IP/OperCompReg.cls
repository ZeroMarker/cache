/// 名称: DHCMA.IMP.IP.OperCompReg
/// 描述: 重点患者业务-手术并发症登记表
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.IP.OperCompReg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 登记主表ID
Property RegisterDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术记录ID
Property OperationID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否发生手术并发症
Property IsOperCompl As %Boolean;

/// 并发症类型（指向DHCMA.Util.BT.Dictionary 多值“!”分割Dictionary.ID）
Property ComplTypes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 其他并发症类型
Property ComplTypeTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 并发症分级->DHCMA.IMP.BT.OperCompLvL
Property ComplLevelDr As DHCMA.IMP.BT.OperCompLvL;

/// 并发症发生日期
Property ComplDate As %Date;

Index IdxofRegisterDr On RegisterDr [ Unique ];

Index IdxofComplDate On ComplDate;

/// Creator：     dsp
/// CreatDate：   2020-05-18
/// Description:  更新手术并发症登记表
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.OperCompReg).Update("^001^项目类型1^A^D")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID          = $p(aInputStr,aSeparete,1)  
	Set RegisterDr  = $p(aInputStr,aSeparete,2)
	Set OperationID = $p(aInputStr,aSeparete,3)
	Set IsOperCompl = $p(aInputStr,aSeparete,4)
	Set ComplTypes 	= $p(aInputStr,aSeparete,5)
	Set ComplTypeTxt= $p(aInputStr,aSeparete,6)
	Set ComplLevelDr= $p(aInputStr,aSeparete,7)
	Set ComplDate   = $p(aInputStr,aSeparete,8)
	
	Set:ComplDate'="" ComplDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ComplDate)
	Set objLevel = ""
	Set:ComplLevelDr'="" objLevel = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(ComplLevelDr)
	Quit:(ComplLevelDr'="")&&('$Isobject(objLevel)) -3
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.OperCompReg).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.OperCompReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.RegisterDr   = RegisterDr      
	Set obj.OperationID  = OperationID
	Set obj.IsOperCompl  = IsOperCompl
	Set obj.ComplTypes   = ComplTypes
	Set obj.ComplTypeTxt = ComplTypeTxt
	Set obj.ComplLevelDr = objLevel
	Set obj.ComplDate    = ComplDate
	
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
/// CreatDate：   2020-05-18
/// Description:  根据ID手术并发症登记表信息
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       aId :  DHCMA.IMP.IP.OperCompReg.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.OperCompReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.OperCompReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.OperCompReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.OperCompReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-05-18
/// Description:  删除手术并发症登记表
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       aId :  DHCMA.IMP.IP.OperCompReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.OperCompReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.OperCompReg).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     dsp
/// CreatDate：   2020-09-29
/// Description:  查询是否存在登记主表的手术并发症信息
/// Table：       DHCMA.IMP.IP.OperCompReg
/// Input：       aId :  DHCMA.IMP.IP.OperCompReg.ID
/// Return：      成功：返回obj，失败：返回""
/// w ##class(DHCMA.IMP.IP.OperCompReg).GetObjByRegisterDr(1)
ClassMethod GetObjByRegisterDr(aRegisterDr As %String) As DHCMA.IMP.IP.OperCompReg
{
	New (aRegisterDr)
	Set objOperCompReg=""
	
	Set xOperCompRegID = ""
	For{
		Set xOperCompRegID = $O(^MA.IMP.IPOperCompRegI("IdxofRegisterDr"," "_+aRegisterDr,xOperCompRegID))
		Quit:xOperCompRegID=""
		Set objOperCompReg = ..GetObjById(xOperCompRegID)
	}
	Quit objOperCompReg
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegisterDr</Value>
</Value>
<Value name="3">
<Value>OperationID</Value>
</Value>
<Value name="4">
<Value>IsOperCompl</Value>
</Value>
<Value name="5">
<Value>ComplTypes</Value>
</Value>
<Value name="6">
<Value>ComplTypeTxt</Value>
</Value>
<Value name="7">
<Value>ComplLevelDr</Value>
</Value>
<Value name="8">
<Value>ComplDate</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPOperCompRegD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPOperCompRegD</IdLocation>
<IndexLocation>^MA.IMP.IPOperCompRegI</IndexLocation>
<StreamLocation>^MA.IMP.IPOperCompRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
