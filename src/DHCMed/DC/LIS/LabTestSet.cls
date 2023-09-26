/// 名称 : DHCMed.DC.LIS.LabTestSet
/// 说明 : 检验组套（检验医嘱）
Class DHCMed.DC.LIS.LabTestSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验号（对应医嘱表LabEpisodeNo字段）
Property EpisodeNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验医嘱（对应医嘱表LabTestSetRow字段）
Property TestSetRow As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验医嘱索引序号
Property TestSetNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目组套/检验医嘱
Property TestSetDR As DHCMed.DC.LIS.BTTestSet;

/// 标本
Property SpecimenDR As DHCMed.DC.LIS.BTSpecimen;

/// 申请科室
Property LocationDR As DHCMed.DC.BTLoc;

/// 采集日期
Property CollectDate As %Date;

/// 采集时间
Property CollectTime As %Time;

/// 采集者
Property CollectUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接收日期
Property ReceiveDate As %Date;

/// 接收时间
Property ReceiveTime As %Time;

/// 接收者
Property ReceiveUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 接收日期时间索引
Index IndexReceiveDT On (ReceiveDate, ReceiveTime);

/// 采集日期时间索引
Index IndexCollectDT On (CollectDate, CollectTime);

/// 检验号+检验组套索引
Index IndexEpisodeNo On (EpisodeNo, TestSetDR);

/// 检验医嘱索引
Index IndexTestSetRow On TestSetRow As Exact;

/// 检验医嘱序号索引
Index IndexTestSetNo On TestSetNo As Exact;

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  根据ID取检验医嘱记录
/// Table：       DHCMed.DC.LIS.LabTestSet
/// Input：       ID:    DHCMed.DC.LIS.LabTestSet.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.LabTestSet).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.LabTestSet
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.LabTestSet).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.LabTestSet).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCMed.DC.LIS.LabTestSet).GetObjByTSRow()
ClassMethod GetObjByTSRow(aTestSetRow As %String) As %String
{
	new (aTestSetRow)
	set return=""
	quit:aTestSetRow="" return
	
	set xID=0
	for {
		set xID=$o(^DHCMed.DC.LIS.LabTestSetI("IndexTestSetRow",aTestSetRow,xID))
		quit:xID=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		continue:obj.IsActive'=1
		set return=obj
		quit
	}
	quit return
}

/// TestSetRow与TestSetNo应该是多对一关系
/// w ##class(DHCMed.DC.LIS.LabTestSet).GetTSNoByTSRow(304)
ClassMethod GetTSNoByTSRow(aTestSetRow As %String) As %String
{
	new (aTestSetRow)
	set return=""
	quit:aTestSetRow="" return
	
	set xID=0
	for {
		set xID=$o(^DHCMed.DC.LIS.LabTestSetI("IndexTestSetRow",aTestSetRow,xID))
		quit:xID=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		continue:obj.IsActive'=1
		set return=obj.TestSetNo
		quit
	}
	quit return
}

/// 通过报告ID获取检验标本号
/// w ##class(DHCMed.DC.LIS.LabTestSet).GetEpisodeNoByTSNo(1)
ClassMethod GetEpisodeNoByTSNo(aTestSetNo As %String) As %String
{
	new (aTestSetNo)
	set return=""
	quit:aTestSetNo="" return
	
	set xID=0
	for {
		set xID=$o(^DHCMed.DC.LIS.LabTestSetI("IndexTestSetNo",aTestSetNo,xID))
		quit:xID=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		continue:obj.IsActive'=1
		set return=obj.EpisodeNo
		quit
	}
	
	quit return
}

/// TestSetNo与TestSetRow应该是一对多关系
/// w ##class(DHCMed.DC.LIS.LabTestSet).GetTSRowByTSNo()
ClassMethod GetTSRowByTSNo(aTestSetNo As %String) As %String
{
	new (aTestSetNo)
	set return=""
	quit:aTestSetNo="" return
	
	set xID=0
	for {
		set xID=$o(^DHCMed.DC.LIS.LabTestSetI("IndexTestSetNo",aTestSetNo,xID))
		quit:xID=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		continue:obj.IsActive'=1
		set TestSetRow=obj.TestSetRow
		set return=return_","_TestSetRow
	}
	set:return'="" return=$e(return,2,$l(return))
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  更新检验医嘱记录
/// Table：       DHCMed.DC.LIS.LabTestSet
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.LabTestSet).Update("1604170529^54462^45202||10^876^^^^^^^^^1")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set EpisodeNo   = $p(InStr,separete,1)
	set TestSetRow  = $p(InStr,separete,2)
	set TestSetNo   = $p(InStr,separete,3)
	set TestSetDR   = $p(InStr,separete,4)
	set SpecimenDR  = $p(InStr,separete,5)
	set LocationDR  = $p(InStr,separete,6)
	set CollectDate = $p(InStr,separete,7)
	set:CollectDate["-" CollectDate=$zdh(CollectDate,3)
	set CollectTime = $p(InStr,separete,8)
	set:CollectTime[":" CollectTime=$zth(CollectTime,1)
	set CollectUser = $p(InStr,separete,9)
	set ReceiveDate = $p(InStr,separete,10)
	set:ReceiveDate["-" ReceiveDate=$zdh(ReceiveDate,3)
	set ReceiveTime = $p(InStr,separete,11)
	set:ReceiveTime[":" ReceiveTime=$zth(ReceiveTime,1)
	set ReceiveUser = $p(InStr,separete,12)
	set IsActive    = +$p(InStr,separete,13)
	quit:(EpisodeNo="")||(TestSetDR="") return
	quit:(TestSetRow="")||(TestSetNo="") return
	
	set objTestSet=##Class(DHCMed.DC.LIS.BTTestSet).GetObjById(TestSetDR)
	quit:'$IsObject(objTestSet) return
	
	set objSpecimen=##Class(DHCMed.DC.LIS.BTSpecimen).GetObjById(SpecimenDR)
	//quit:'$IsObject(objSpecimen) return
	
	set objLocation=##Class(DHCMed.DC.BTLoc).GetObjById(LocationDR)
	//quit:'$IsObject(objLocation) return
	
	//报告记录唯一性
	set ID=$o(^DHCMed.DC.LIS.LabTestSetI("IndexTestSetRow",TestSetRow,0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.LabTestSet).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.LabTestSet).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.EpisodeNo   = EpisodeNo
	set obj.TestSetRow  = TestSetRow
	set obj.TestSetNo   = TestSetNo
	set obj.TestSetDR   = objTestSet
	set obj.SpecimenDR  = objSpecimen
	set obj.LocationDR  = objLocation
	set obj.CollectDate = CollectDate
	set obj.CollectTime = CollectTime
	set obj.CollectUser = CollectUser
	set obj.ReceiveDate = ReceiveDate
	set obj.ReceiveTime = ReceiveTime
	set obj.ReceiveUser = ReceiveUser
	set obj.IsActive    = IsActive
	set obj.UpdateDate  = +$h
	set obj.UpdateTime  = $p($h,",",2)
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
/// CreatDate：   2016-03-04
/// Description:  删除检验医嘱记录
/// Table：       DHCMed.DC.LIS.LabTestSet
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.LabTestSet).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeNo</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>SpecimenDR</Value>
</Value>
<Value name="5">
<Value>LocationDR</Value>
</Value>
<Value name="6">
<Value>CollectDate</Value>
</Value>
<Value name="7">
<Value>CollectTime</Value>
</Value>
<Value name="8">
<Value>CollectUser</Value>
</Value>
<Value name="9">
<Value>ReceiveDate</Value>
</Value>
<Value name="10">
<Value>ReceiveTime</Value>
</Value>
<Value name="11">
<Value>ReceiveUser</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateTime</Value>
</Value>
<Value name="15">
<Value>OEItemID</Value>
</Value>
<Value name="16">
<Value>TestSetNo</Value>
</Value>
<Value name="17">
<Value>TestSetRow</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.LabTestSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.LabTestSetD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.LabTestSetI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.LabTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
