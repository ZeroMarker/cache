/// 病案操作记录表
Class DHCWMR.SS.Operation Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案类型
Property OPMrType As DHCWMR.SS.MrType;

/// 操作项目
Property OPItemDr As DHCWMR.SS.WorkItem;

/// 操作员（SS_User.ID）
Property OPUserFrom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作日期
Property OPActDate As %Date;

/// 操作时间
Property OPActTime As %Time;

/// 验证用户（SS_User.ID）
Property OPUserTo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 批次号
Property OPBatchNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property OPIsActive As %Boolean;

/// 备注信息
Property OPResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 批次号 索引
Index IndexBatchNumber On OPBatchNumber [ Unique ];

/// 病案类型+操作项目+操作日期索引
Index IndexItemDrDate On (OPMrType, OPItemDr, OPActDate, OPActTime);

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  根据ID取病案操作记录
/// Table：       DHCWMR.SS.Operation
/// Input：       Id : DHCWMR.SS.Operation.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Operation).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Operation
{
	new (aId)
	quit:'##class(DHCWMR.SS.Operation).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Operation).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  根据批次号取病案操作记录
/// Table：       DHCWMR.SS.Operation
/// Input：       Id : DHCWMR.SS.Operation.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Operation).GetObjByBatchNumber("AAA")
ClassMethod GetObjByBatchNumber(aBatchNumber As %String) As DHCWMR.SS.Operation
{
	new (aBatchNumber)
	set return=""
	quit:aBatchNumber="" return
	set OperID=$o(^DHCWMR.SS.OperationI("IndexBatchNumber"," "_aBatchNumber,0))
	quit:OperID="" return
	set return=##class(DHCWMR.SS.Operation).GetObjById(OperID)
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-19
/// Description:  更新病案操作记录
/// Table：       DHCWMR.SS.Operation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.Operation).Update("^7^1^1^1^BBB^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID          = $p(aInputStr,aSeparate,1)
	set MrTypeID    = $p(aInputStr,aSeparate,2)
	set WorkItemID  = $p(aInputStr,aSeparate,3)
	set UserFromID  = $p(aInputStr,aSeparate,4)
	set ActDate     = $p(aInputStr,aSeparate,5)
	set:ActDate["-" ActDate=$zdh(ActDate,3)
	set:ActDate["/" ActDate=$zdh(ActDate,4)
	set:ActDate="" ActDate=+$h
	set ActTime     = $p(aInputStr,aSeparate,6)
	set:ActTime[":" ActTime=$zth(ActTime,1)
	set:ActTime="" ActTime=$p($h,",",2)
	set UserToID    = $p(aInputStr,aSeparate,7)
	set BatchNumber = $p(aInputStr,aSeparate,8)
	set IsActive = +$p(aInputStr,aSeparate,9)
	set Resume      = $p(aInputStr,aSeparate,10)
	quit:(MrTypeID="")||(WorkItemID="")||(BatchNumber="") return
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	quit:'$IsObject(objMrType) return
	set objWorkItem=##class(DHCWMR.SS.WorkItem).GetObjById(WorkItemID)
	quit:'$IsObject(objWorkItem) return
	
	if ID="" {
		set obj=##class(DHCWMR.SS.Operation).%New()
	}else{
		set obj=##class(DHCWMR.SS.Operation).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.OPMrType      = objMrType
	set obj.OPItemDr      = objWorkItem
	set obj.OPUserFrom    = UserFromID
	set obj.OPActDate     = ActDate
	set obj.OPActTime     = ActTime
	set obj.OPUserTo      = UserToID
	set obj.OPBatchNumber = BatchNumber
	set obj.OPIsActive    = IsActive
	set obj.OPResume      = Resume
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
/// CreatDate：   2014-09-19
/// Description:  删除病案操作记录
/// Table：       DHCWMR.SS.Operation
/// Input：       Id : DHCWMR.SS.Operation.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Operation).%DeleteId(aId)
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
<Value>OPMrType</Value>
</Value>
<Value name="3">
<Value>OPItemDr</Value>
</Value>
<Value name="4">
<Value>OPActDate</Value>
</Value>
<Value name="5">
<Value>OPActTime</Value>
</Value>
<Value name="6">
<Value>OPUserFrom</Value>
</Value>
<Value name="7">
<Value>OPUserTo</Value>
</Value>
<Value name="8">
<Value>OPBatchNumber</Value>
</Value>
<Value name="9">
<Value>OPIsActive</Value>
</Value>
<Value name="10">
<Value>OPResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.OperationD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.OperationD</IdLocation>
<IndexLocation>^DHCWMR.SS.OperationI</IndexLocation>
<StreamLocation>^DHCWMR.SS.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
