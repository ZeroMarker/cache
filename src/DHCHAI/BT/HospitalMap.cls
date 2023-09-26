/// 名称: DHCHAI.BT.HospitalMap
/// 描述: 医院对照列表
/// 编写者：zhufei
/// 编写日期: 2017-09-30
Class DHCHAI.BT.HospitalMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医院指针
Property BTMapHospDr As DHCHAI.BT.Hospital [ Required ];

/// 医院代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医院关联码
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 子系统代码 + 医院关联码索引
Index IndexSCodeXCode On (BTSCode As Exact, BTXCode As Exact);

/// 子系统代码 + 医院代码索引
Index IndexSCodeCode On (BTSCode As Exact, BTCode As Exact);

/// 子系统代码 + 医院名称索引
Index IndexSCodeDesc On (BTSCode As Exact, BTDesc As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照医院关系
/// Table：       DHCHAI.BT.HospitalMap
/// Input：       aSCode : DHCHAI.BT.HospitalMap.BTSCode
///               aXCode : DHCHAI.BT.HospitalMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",2)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.HospitalMap
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set ID=$o(^DHCHAI.BT.HospitalMapI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据ID取医院信息
/// Table：       DHCHAI.BT.HospitalMap
/// Input：       aId : DHCHAI.BT.HospitalMap.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.HospitalMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.HospitalMap
{
	New (aId)
	Quit:'##class(DHCHAI.BT.HospitalMap).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.HospitalMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  更新医院信息
/// Table：       DHCHAI.BT.HospitalMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.HospitalMap).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set MapHospDr   = $p(aInputStr,aSeparete,2)
	Set Code        = $p(aInputStr,aSeparete,3)
	Set Desc        = $p(aInputStr,aSeparete,4)
	Set SCode       = $p(aInputStr,aSeparete,5)
	Set XCode   	= $p(aInputStr,aSeparete,6)
	Set ActDate   	= $p(aInputStr,aSeparete,7)
	Set ActTime   	= $p(aInputStr,aSeparete,8)
	Set ActUserDr   = $p(aInputStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(SCode="")||(XCode="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set SCode=$zcvt(SCode,"U")
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.HospitalMapI("IndexSCodeXCode",SCode,XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(MapHospDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.HospitalMap).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.HospitalMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTMapHospDr = objHosp
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTSCode	    = SCode
	Set obj.BTXCode		= XCode
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

Storage Default
{
<Data name="HospitalMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTMapHospDr</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTSCode</Value>
</Value>
<Value name="6">
<Value>BTXCode</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUser</Value>
</Value>
<Value name="10">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.HospitalMapD</DataLocation>
<DefaultData>HospitalMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.HospitalMapD</IdLocation>
<IndexLocation>^DHCHAI.BT.HospitalMapI</IndexLocation>
<StreamLocation>^DHCHAI.BT.HospitalMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
