/// 名称: DHCHAI.BT.Hospital
/// 描述: 医院信息
/// 编写者：liyi
/// 编写日期: 2017-01-12
Class DHCHAI.BT.Hospital Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 组织机构代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医疗机构名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医院别名
Property BTDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院分组
Property BTGroupDr As DHCHAI.BT.HospGroup;

/// 记录索引码（HIS中医院ID或代码）
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 医院代码索引
Index IndexHospCode On BTCode As Exact;

/// 记录索引码索引
Index IndexXCode On BTXCode As Exact;

/// 医院分组索引
Index IndexHospGroupDr On BTGroupDr;

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照医院
/// Table：       DHCHAI.BT.Hospital、DHCHAI.BT.HospitalMap
/// Input：       aSCode : DHCHAI.BT.HospitalMap.BTSCode
///               aXCode : DHCHAI.BT.HospitalMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Hospital).GetObjByXCode("HIS02",2)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.Hospital
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set objMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode(aSCode,aXCode)
	If $IsObject(objMap){
		//按照医院对照取标准医院信息
		Quit:'$IsObject(objMap.BTMapHospDr) return
		Set return=objMap.BTMapHospDr
		Quit return
	} Else {
		//按医院表代码对照取标准医院信息
		Set ID=$o(^DHCHAI.BT.HospitalI("IndexXCode",aSCode_"||"_aXCode,0))
		Set:ID'="" return=##class(DHCHAI.BT.Hospital).GetObjById(ID)
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取医院信息
/// Table：       DHCHAI.BT.Hospital
/// Input：       aId : DHCHAI.BT.Hospital.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Hospital).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.Hospital
{
	New (aId)
	Quit:'##class(DHCHAI.BT.Hospital).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.Hospital).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新医院信息
/// Table：       DHCHAI.BT.Hospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Hospital).Update("^bjdt^北京地坛医院^1^1^1^2017-01-17^10:15:23^系统")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code        = $p(aInputStr,aSeparete,2)
	Set Desc        = $p(aInputStr,aSeparete,3)
	Set Desc2       = $p(aInputStr,aSeparete,4)
	Set GroupDr     = $p(aInputStr,aSeparete,5)
	Set XCode   	= $p(aInputStr,aSeparete,6)
	Set IsActive   	= +$p(aInputStr,aSeparete,7)
	Set ActDate   	= $p(aInputStr,aSeparete,8)
	Set ActTime   	= $p(aInputStr,aSeparete,9)
	Set ActUserDr   = $p(aInputStr,aSeparete,10)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Code="")||(Desc="")||(XCode="")
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.HospitalI("IndexXCode",XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objGroup=##class(DHCHAI.BT.HospGroup).GetObjById(GroupDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.Hospital).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.Hospital).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTDesc2     = Desc2
	Set obj.BTGroupDr	= objGroup
	Set obj.BTXCode		= XCode
	Set obj.BTIsActive	= IsActive
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除医院信息
/// Table：       DHCHAI.BT.Hospital
/// Input：       aId : DHCHAI.BT.Hospital.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Hospital).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.Hospital).%DeleteId(aId)
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
<Data name="HospitalDefaultData">
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
<Value>BTDesc2</Value>
</Value>
<Value name="5">
<Value>BTGroupDr</Value>
</Value>
<Value name="6">
<Value>BTXCode</Value>
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
<DataLocation>^DHCHAI.BT.HospitalD</DataLocation>
<DefaultData>HospitalDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.HospitalD</IdLocation>
<IndexLocation>^DHCHAI.BT.HospitalI</IndexLocation>
<StreamLocation>^DHCHAI.BT.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
