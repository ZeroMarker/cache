/// 名称: CT.IPMR.DP.Location
/// 描述: 科室
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.Location Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property DLSysDr As CT.IPMR.DP.System [ Required ];

/// 字典ID （指向CT_Location 或 第三方科室字典ID）
Property DLDicID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 科室ID （DLDicID_||_DLSysDr）
Property DLLocID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 科室代码
Property DLCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室名称
Property DLDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室别名
Property DLDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室类型（E执行科室、W病区、O其他）
Property DLType As %String(DISPLAYLIST = ",Execute,Ward,Other", VALUELIST = ",E,W,O");

/// 关联科室（多值逗号分隔） CT.IPMR.DP.Location.DLLocID
Property DLLinkLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊类型（多值逗号分隔）
Property DLAdmType As %String;

/// 所属医院ID（指向CT.IPMR.DP.Hospital.DHHospID）
Property DLHospID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property DLIsActive As %Boolean;

/// 科室ID 索引
Index IndexOfLocID On DLLocID [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据拼接的科室ID取科室信息
/// Table：       CT.IPMR.DP.Location
/// Input：       aLocID : CT.IPMR.DP.Location.DLLocID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.Location).GetObjByOID("1||2")
ClassMethod GetObjByOID(aLocID As %String) As CT.IPMR.DP.Location
{
	New (aLocID)
	Set return=""
	Quit:aLocID="" return
	Set id =  $o(^CT.IPMR.DP.LocationI("IndexOfLocID"," "_$zcvt(aLocID,"U"),""))
	Quit:id="" return
	Set return = ..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据ID取医院信息
/// Table：       CT.IPMR.DP.Location
/// Input：       aId : CT.IPMR.DP.Location.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.Location).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.Location
{
	New (aId)
	Quit:'##class(CT.IPMR.DP.Location).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.DP.Location).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  更新医院信息
/// Table：       CT.IPMR.DP.Location
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.Location).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set SysID    = $p(aInputStr,aSeparete,2)
	Set DicID    = $p(aInputStr,aSeparete,3)
	Set LocID    = $p(aInputStr,aSeparete,4)
	Set Code	 = $p(aInputStr,aSeparete,5)
	Set Desc     = $p(aInputStr,aSeparete,6)
	Set Desc2    = $p(aInputStr,aSeparete,7)
	Set Type     = $p(aInputStr,aSeparete,8)
	Set AdmType	 = $p(aInputStr,aSeparete,9)
	Set HospID	 = $p(aInputStr,aSeparete,10)
	Set IsActive = +$p(aInputStr,aSeparete,11)
	Set LinkLoc  = $p(aInputStr,aSeparete,12)
	Quit:(SysID="")||(DicID="")||(Code="")||(Desc="")||(LocID="") return
	
	Set objSYS=##class(CT.IPMR.DP.System).GetObjById(SysID)
	Quit:'$IsObject(objSYS) return
	
	Set tID=$o(^CT.IPMR.DP.LocationI("IndexOfLocID"," "_$zcvt(LocID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.Location).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.Location).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DLSysDr      = objSYS
	Set obj.DLDicID      = DicID
	Set obj.DLLocID      = LocID
	Set obj.DLCode       = Code
	Set obj.DLDesc       = Desc
	Set obj.DLDesc2      = Desc2
	Set obj.DLType       = Type
	Set obj.DLAdmType    = AdmType
	Set obj.DLHospID     = HospID
	Set obj.DLIsActive   = IsActive
	Set obj.DLLinkLoc	 = LinkLoc
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

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  删除医院信息
/// Table：       CT.IPMR.DP.Location
/// Input：       aId : CT.IPMR.DP.Location.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.Location).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(CT.IPMR.DP.Location).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLSysDr</Value>
</Value>
<Value name="3">
<Value>DLDicID</Value>
</Value>
<Value name="4">
<Value>DLLocID</Value>
</Value>
<Value name="5">
<Value>DLCode</Value>
</Value>
<Value name="6">
<Value>DLDesc</Value>
</Value>
<Value name="7">
<Value>DLDesc2</Value>
</Value>
<Value name="8">
<Value>DLType</Value>
</Value>
<Value name="9">
<Value>DLLinkLoc</Value>
</Value>
<Value name="10">
<Value>DLAdmType</Value>
</Value>
<Value name="11">
<Value>DLHospID</Value>
</Value>
<Value name="12">
<Value>DLIsActive</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.LocationD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.LocationD</IdLocation>
<IndexLocation>^CT.IPMR.DP.LocationI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.LocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
