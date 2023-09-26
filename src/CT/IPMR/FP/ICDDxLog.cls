/// 名称: CT.IPMR.FP.ICDDxLog
/// 描述: ICD库变更日志
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.ICDDxLog Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// ICD指针
Property FIICDDxDr As CT.IPMR.FP.ICDDx [ Required ];

/// 操作类型 （新增：A、修改：M、变更映射：M1）
Property FIOperType As %String(DISPLAYLIST = ",Add,Modify,Modify1", VALUELIST = ",A,M,M1") [ Required ];

/// 操作前数据
Property FIOldValue As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 操作后数据
Property FINewValue As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 操作用户的Ip地址
Property FIIpAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作用户ID
Property FIUpdateUserID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作日期
Property FIUpdateDate As %Date [ Required ];

/// 操作时间
Property FIUpdateTime As %Time [ Required ];

/// 备注
Property FIResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 操作日期 时间 ICD字典 操作类型 索引
Index IndexDateTime On (FIUpdateDate, FIUpdateTime, FIICDDxDr, FIOperType);

/// ICD字典
Index IndexICDDxDr On FIICDDxDr;

/// Creator：     chenPJ
/// CreatDate：   2019-10-18
/// Description:  取ICD库变更日志
/// Table：       CT.IPMR.FP.ICDDxLog
/// Input：       Id : CT.IPMR.FP.ICDDxLog.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDDxLog).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.ICDDxLog
{
	New (aId)
	Quit:'##class(CT.IPMR.FP.ICDDxLog).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.FP.ICDDxLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-18
/// Description:  更新ICD库变更日志
/// Table：       CT.IPMR.FP.ICDDxLog
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDDxLog).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ICDDxID		= $p(aInputStr,aSeparate,1)
	Set OperType 	= $p(aInputStr,aSeparate,2)
	Set OldValue 	= $p(aInputStr,aSeparate,3)
	Set NewValue	= $p(aInputStr,aSeparate,4)
	Set IpAddress 	= $p(aInputStr,aSeparate,5)
	Set UpdateUserID= $p(aInputStr,aSeparate,6)
	Set Resume  	= $p(aInputStr,aSeparate,7)

	Set UpdateDate 	= +$h
	Set UpdateTime 	= +$P($h,",",2)
	Quit:ICDDxID="" return
	If OperType="M1" {
		Set ICDDxID = $p(NewValue,",",6)
		Set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjById(ICDDxID)
		Quit:'$isobject(objICDDx) return
	}else{
		Set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjById(ICDDxID)
		Quit:'$isobject(objICDDx) return
	}
	Set obj=##class(CT.IPMR.FP.ICDDxLog).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.FIICDDxDr		= objICDDx
	Set obj.FIOperType		= OperType
	Set obj.FIOldValue		= OldValue
	Set obj.FINewValue		= NewValue
	Set obj.FIIpAddress		= IpAddress
	Set obj.FIUpdateUserID	= UpdateUserID
	Set obj.FIUpdateDate	= UpdateDate
	Set obj.FIUpdateTime	= UpdateTime
	Set obj.FIResume		= Resume
	
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

/// Creator：     chenPJ
/// CreatDate：   2019-10-24
/// Description:  删除ICD库变更日志
/// Table：       CT.IPMR.FP.ICDDxLog
/// Input：       Id : CT.IPMR.FP.ICDDxLog.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.ICDDxLog).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	
	Set sc = ##class(CT.IPMR.FP.ICDDxLog).%DeleteId(aId)
	If $system.Status.IsError(sc) {  //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} else {
		Set return=1
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
<Value>FIICDDxDr</Value>
</Value>
<Value name="3">
<Value>FIOperType</Value>
</Value>
<Value name="4">
<Value>FIOldValue</Value>
</Value>
<Value name="5">
<Value>FINewValue</Value>
</Value>
<Value name="6">
<Value>FIIpAddress</Value>
</Value>
<Value name="7">
<Value>FIUpdateUserID</Value>
</Value>
<Value name="8">
<Value>FIUpdateDate</Value>
</Value>
<Value name="9">
<Value>FIUpdateTime</Value>
</Value>
<Value name="10">
<Value>FIResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ICDDxLogD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ICDDxLogD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDDxLogI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDDxLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
