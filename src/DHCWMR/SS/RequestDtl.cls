/// 病案操作登记/申请明细
Class DHCWMR.SS.RequestDtl Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.Request [ Cardinality = parent, Inverse = ChildDtl ];

/// 病案卷
Property RQVolumeDr As DHCWMR.SS.Volume;

/// 申请状态（R申请、A响应、U作废）
Property RQReqStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property RQUpdateDate As %Date;

/// 更新时间
Property RQUpdateTime As %Time;

/// 更新人（指向SS_User）
Property RQUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注信息
Property RQResume As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案卷+申请状态索引
Index IndexVolumeDr On (Parref, RQVolumeDr);

/// 病案卷+申请状态索引
Index IndexVolumeStatus On (Parref, RQVolumeDr, RQReqStatus);

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  根据ID取病案卷申请记录
/// Table：       DHCWMR.SS.RequestDtl
/// Input：       Id : DHCWMR.SS.RequestDtl.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.RequestDtl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.RequestDtl
{
	new (aId)
	quit:'##class(DHCWMR.SS.RequestDtl).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.RequestDtl).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  更新病案卷申请记录
/// Table：       DHCWMR.SS.RequestDtl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.RequestDtl).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set Parref      = $p(aInputStr,aSeparate,1)
	set ChildSub    = $p(aInputStr,aSeparate,2)
	set VolumeID    = $p(aInputStr,aSeparate,3)
	set ReqStatus   = $p(aInputStr,aSeparate,4)
	set UpdateDate  = $p(aInputStr,aSeparate,5)
	set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate="" UpdateDate=+$h
	set UpdateTime  = $p(aInputStr,aSeparate,6)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	set:UpdateTime="" UpdateTime=$p($h,"^",2)
	set UpdateUser  = $p(aInputStr,aSeparate,7)
	set Resume      = $p(aInputStr,aSeparate,8)
	quit:(Parref="")||(VolumeID="")||(ReqStatus="") return
	
	if ChildSub="" {
		set ChildSub=$o(^DHCWMR.SS.RequestI("RD","IndexVolumeDr",Parref,VolumeID,0))
	}
	
	set objParref=##class(DHCWMR.SS.Request).GetObjById(Parref)
	quit:'$IsObject(objParref) return
	set objVolume=##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	quit:'$IsObject(objVolume) return
	
	if ChildSub="" {
		set obj=##class(DHCWMR.SS.RequestDtl).%New()
	}else{
		set obj=##class(DHCWMR.SS.RequestDtl).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref        = objParref
	set obj.RQVolumeDr    = objVolume
	set obj.RQReqStatus   = ReqStatus
	set obj.RQUpdateDate  = UpdateDate
	set obj.RQUpdateTime  = UpdateTime
	set obj.RQUpdateUser  = UpdateUser
	set obj.RQResume      = Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  删除病案卷申请记录
/// Table：       DHCWMR.SS.RequestDtl
/// Input：       Id : DHCWMR.SS.RequestDtl.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.RequestDtl).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RQVolumeDr</Value>
</Value>
<Value name="3">
<Value>RQReqStatus</Value>
</Value>
<Value name="4">
<Value>RQUpdateDate</Value>
</Value>
<Value name="5">
<Value>RQUpdateTime</Value>
</Value>
<Value name="6">
<Value>RQUpdateUser</Value>
</Value>
<Value name="7">
<Value>RQResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("D")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("D")</IdLocation>
<IndexLocation>^DHCWMR.SS.RequestI("RD")</IndexLocation>
<StreamLocation>^DHCWMR.SS.RequestDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
