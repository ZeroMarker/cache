/// 名称: CT.IPMR.DP.Hospital
/// 描述: 医院表
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.Hospital Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property DHSysDr As CT.IPMR.DP.System [ Required ];

/// 字典ID （指向CT_Hospital 或 第三方医院字典ID）
Property DHDicID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 医院ID （DHDicID_||_DHSysDr）
Property DHHospID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 医院代码
Property DHCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 医院名称
Property DHDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 是否有效
Property DHIsActive As %Boolean;

/// 医院ID 索引
Index IdxOfHospID On DHHospID [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据拼接的医院ID取医院信息
/// Table：       CT.IPMR.DP.Hospital
/// Input：       aHospID : CT.IPMR.DP.Hospital.DHHospID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.Hospital).GetObjByOID(1)
ClassMethod GetObjByOID(aHospID As %String) As CT.IPMR.DP.Hospital
{
	New (aHospID)
	Set return=""
	Quit:aHospID="" return
	Set id =  $o(^CT.IPMR.DP.HospitalI("IdxOfHospID"," "_$zcvt(aHospID,"U"),""))
	Quit:id="" return
	Set return = ..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据ID取医院信息
/// Table：       CT.IPMR.DP.Hospital
/// Input：       aId : CT.IPMR.DP.Hospital.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.Hospital).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.Hospital
{
	New (aId)
	Quit:'##class(CT.IPMR.DP.Hospital).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.DP.Hospital).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  更新医院信息
/// Table：       CT.IPMR.DP.Hospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.Hospital).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set SysID    = $p(aInputStr,aSeparete,2)
	Set DicID    = $p(aInputStr,aSeparete,3)
	Set HospID   = $p(aInputStr,aSeparete,4)
	Set Code	 = $p(aInputStr,aSeparete,5)
	Set Desc     = $p(aInputStr,aSeparete,6)
	Set IsActive = +$p(aInputStr,aSeparete,7)
	Quit:(SysID="")||(DicID="")||(Code="")||(Desc="")||(HospID="") return

	Set objSYS=##class(CT.IPMR.DP.System).GetObjById(SysID)
	Quit:'$IsObject(objSYS) return
	
	Set tID=$o(^CT.IPMR.DP.HospitalI("IdxOfHospID"," "_$zcvt(HospID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.Hospital).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.Hospital).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DHSysDr      = objSYS
	Set obj.DHDicID      = DicID
	Set obj.DHHospID 	 = HospID
	Set obj.DHCode       = Code
	Set obj.DHDesc       = Desc
	Set obj.DHIsActive   = IsActive
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
/// Table：       CT.IPMR.DP.Hospital
/// Input：       aId : CT.IPMR.DP.Hospital.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.Hospital).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(CT.IPMR.DP.Hospital).%DeleteId(aId)
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
<Value>DHSysDr</Value>
</Value>
<Value name="3">
<Value>DHDicID</Value>
</Value>
<Value name="4">
<Value>DHHospID</Value>
</Value>
<Value name="5">
<Value>DHCode</Value>
</Value>
<Value name="6">
<Value>DHDesc</Value>
</Value>
<Value name="7">
<Value>DHIsActive</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.HospitalD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.HospitalD</IdLocation>
<IndexLocation>^CT.IPMR.DP.HospitalI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
