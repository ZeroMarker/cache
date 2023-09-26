/// 名称 : DHCMed.DC.ORIS.Operation
/// 说明 : 手术麻醉记录
Class DHCMed.DC.ORIS.Operation Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号/住院号
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术编码(ICD-9-CM3)
Property OperICD9 As %String(TRUNCATE = 1);

/// 手术名称
Property OperDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术类型（急诊E、择期S、空）
Property OperTypeDR As DHCMed.DC.ORIS.BTOperType;

/// 手术日期
Property OperDate As %Date;

/// 手术开始时间
Property OperSttTime As %Time;

/// 手术结束日期
Property OperEndDate As %Date;

/// 手术结束时间
Property OperEndTime As %Time;

/// 手术持续时间（小时）
Property OperHour As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术科室
Property OperLocDR As DHCMed.DC.BTLoc;

/// 手术医生
Property Operator As %String(MAXLEN = 100, TRUNCATE = 1);

/// Ⅰ助
Property Assistant1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Ⅱ助
Property Assistant2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口等级（Ⅰ、Ⅱ、Ⅲ、Ⅳ、无）
Property IncisionDR As DHCMed.DC.ORIS.BTIncision;

/// 愈合情况(甲、乙、丙、无)
Property HealingDR As DHCMed.DC.ORIS.BTHealing;

/// 麻醉方式
Property AnesMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师
Property Anesthesia As %String(MAXLEN = 100, TRUNCATE = 1);

/// ASA评分（P1、P2、P3、P4、P5）
Property ASAScoreDR As DHCMed.DC.ORIS.BTASAScore;

/// NNIS分级 （0、1、2、3）
Property NNISGradeDR As DHCMed.DC.ORIS.BTNNISGrade;

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Index IndexResultID On ResultID;

Index IndexEpisode On EpisodeID;

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据ID取手术麻醉记录
/// Table：       DHCMed.DC.ORIS.Operation
/// Input：       ID:    DHCMed.DC.ORIS.Operation.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.ORIS.Operation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.ORIS.Operation
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.ORIS.Operation).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.ORIS.Operation).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  更新手术麻醉记录
/// Table：       DHCMed.DC.ORIS.Operation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.ORIS.Operation).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set ResultID      = $p(InStr,separete,1)
	set EpisodeID     = $p(InStr,separete,2)
	set OperICD9      = $p(InStr,separete,3)
	set OperDesc      = $p(InStr,separete,4)
	set OperTypeDR    = $p(InStr,separete,5)
	set OperDate      = $p(InStr,separete,6)
	set OperSttTime   = $p(InStr,separete,7)
	set OperEndDate   = $p(InStr,separete,8)
	set OperEndTime   = $p(InStr,separete,9)
	set OperLocDR     = $p(InStr,separete,10)
	set Operator      = $p(InStr,separete,11)
	set Assistant1    = $p(InStr,separete,12)
	set Assistant2    = $p(InStr,separete,13)
	set IncisionDR    = $p(InStr,separete,14)
	set HealingDR     = $p(InStr,separete,15)
	set AnesMethod    = $p(InStr,separete,16)
	set Anesthesia    = $p(InStr,separete,17)
	set ASAScoreDR    = $p(InStr,separete,18)
	set NNISGradeDR   = $p(InStr,separete,19)
	set OperHour      = $p(InStr,separete,20)
	set IsActive      = +$p(InStr,separete,21)
	quit:(ResultID="")||(EpisodeID="") return
	//quit:(OperDesc="")||(OperTypeDR="")||(OperDate="")||(Operator="")||(IncisionDR="") return
	
	//数据唯一性
	//set ID=$o(^DHCMed.DC.ORIS.OperationI("IndexHospTypeAdm",HospCode,AdmType,EpisodeID,0))
	Set ID = ""
	set:$d(^DHCMed.DC.ORIS.OperationI("IndexResultID"," "_ResultID)) ID=$o(^DHCMed.DC.ORIS.OperationI("IndexResultID"," "_ResultID,""))
	if ID="" {
		set obj=##class(DHCMed.DC.ORIS.Operation).%New()
	}else{
		set obj=##class(DHCMed.DC.ORIS.Operation).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ResultID      = ResultID
	set obj.EpisodeID     = EpisodeID
	set obj.OperICD9      = OperICD9
	set obj.OperDesc      = OperDesc
	set obj.OperTypeDR    = ##class(DHCMed.DC.ORIS.BTOperType).GetObjById(OperTypeDR)
	set obj.OperDate      = OperDate
	set obj.OperSttTime   = OperSttTime
	set obj.OperEndDate   = OperEndDate
	set obj.OperEndTime   = OperEndTime
	set obj.OperLocDR     = ##class(DHCMed.DC.BTLoc).GetObjById(OperLocDR)
	set obj.Operator      = Operator
	set obj.Assistant1    = Assistant1
	set obj.Assistant2    = Assistant2
	set obj.IncisionDR    = ##class(DHCMed.DC.ORIS.BTIncision).GetObjById(IncisionDR)
	set obj.HealingDR     = ##class(DHCMed.DC.ORIS.BTHealing).GetObjById(HealingDR)
	set obj.AnesMethod    = AnesMethod
	set obj.Anesthesia    = Anesthesia
	set obj.ASAScoreDR    = ##class(DHCMed.DC.ORIS.BTASAScore).GetObjById(ASAScoreDR)
	set obj.NNISGradeDR   = ##class(DHCMed.DC.ORIS.BTNNISGrade).GetObjById(NNISGradeDR)
	set obj.OperHour      = OperHour
	set obj.IsActive      = IsActive
	set obj.UpdateDate    = +$h
	set obj.UpdateTime    = $p($h,",",2)
	
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
/// CreatDate：   2016-04-19
/// Description:  删除手术麻醉记录
/// Table：       DHCMed.DC.ORIS.Operation
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.ORIS.Operation).%DeleteId(+Id)
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
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>OperICD9</Value>
</Value>
<Value name="5">
<Value>OperDesc</Value>
</Value>
<Value name="6">
<Value>OperTypeDR</Value>
</Value>
<Value name="7">
<Value>OperDate</Value>
</Value>
<Value name="8">
<Value>OperSttTime</Value>
</Value>
<Value name="9">
<Value>OperEndDate</Value>
</Value>
<Value name="10">
<Value>OperEndTime</Value>
</Value>
<Value name="11">
<Value>OperLocDR</Value>
</Value>
<Value name="12">
<Value>Operator</Value>
</Value>
<Value name="13">
<Value>Assistant1</Value>
</Value>
<Value name="14">
<Value>Assistant2</Value>
</Value>
<Value name="15">
<Value>IncisionDR</Value>
</Value>
<Value name="16">
<Value>HealingDR</Value>
</Value>
<Value name="17">
<Value>AnesthesiaDR</Value>
</Value>
<Value name="18">
<Value>Anesthesia</Value>
</Value>
<Value name="19">
<Value>ASAScoreDR</Value>
</Value>
<Value name="20">
<Value>NNISGradeDR</Value>
</Value>
<Value name="21">
<Value>IsActive</Value>
</Value>
<Value name="22">
<Value>UpdateDate</Value>
</Value>
<Value name="23">
<Value>UpdateTime</Value>
</Value>
<Value name="24">
<Value>OperHour</Value>
</Value>
<Value name="25">
<Value>AnesMethod</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.ORIS.OperationD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.ORIS.OperationD</IdLocation>
<IndexLocation>^DHCMed.DC.ORIS.OperationI</IndexLocation>
<StreamLocation>^DHCMed.DC.ORIS.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
