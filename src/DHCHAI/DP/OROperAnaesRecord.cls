/// 名称: DHCHAI.DP.OROperAnaesRecord
/// 描述: 手术麻醉记录-同步手术手麻原始记录
/// 编写者：pylian
/// 编写日期: 2020-07-16
Class DHCHAI.DP.OROperAnaesRecord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property OREpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 手术ICD
Property OROperICD As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术名称
Property OROperDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 手术类型
Property OROperType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态(F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
Property OROperStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术日期
Property OROperDate As %Date [ Required ];

/// 手术开始时间
Property ORSttTime As %Time;

/// 手术结束日期
Property OREndDate As %Date;

/// 手术结束时间
Property OREndTime As %Time;

/// 手术持续时间（小时）
Property OROperHour As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术科室
Property OROperLocDr As DHCHAI.BT.Location;

/// 手术科室（ID|Code|Desc）
Property OROperLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术医生（ID|Code|Desc）
Property OROpertor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助（ID|Code|Desc）
Property ORAssistant1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助（ID|Code|Desc）
Property ORAssistant2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口等级
Property ORIncision As %String(MAXLEN = 100, TRUNCATE = 1);

/// 愈合情况
Property ORHealing As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式
Property ORAnesMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医生（ID|Code|Desc）
Property ORAnesthesia As %String(MAXLEN = 100, TRUNCATE = 1);

/// ASA评分
Property ORASAScore As %String(MAXLEN = 100, TRUNCATE = 1);

/// NNIS分级
Property ORNNISGrade As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property ORSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property ORXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 术前外周WBC计数
Property ORWBC As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口个数
Property ORIncisionNum As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否使用窥镜
Property ORIsSightGlass As %Boolean;

/// 是否有植入物
Property ORIsImplants As %Boolean;

/// 失血量
Property ORLoseBlood As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输血量
Property ORGotBlood As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术后并发症
Property ORComplication As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property ORIsActive As %Boolean [ Required ];

/// 更新日期
Property ORUpdateDate As %Date;

/// 更新时间
Property ORUpdateTime As %Time;

/// 手术类型(N常规，D诊断性操作，T治疗性操作,I介入治疗,其中NI为手术DT为操作)
Property OROperTypeSoC As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊记录索引
Index IndexEpisodeDr On OREpisodeDr;

/// 手术开始日期时间索引
Index IndexOperDateTime On (OROperDate, ORSttTime);

/// 手术开始日期时间手术科室索引 
Index IndexOperDateTimeOperLoc On (OROperDate, ORSttTime, OROperLocDr);

/// 手术开始日期时间切口等级索引
Index IndexOperDateTimeIncision On (OROperDate, ORSttTime, ORIncision As Exact);

/// 子系统代码+记录索引码 索引
Index IndexSCodeXCode On (ORSCode As Exact, ORXCode As Exact);

/// 就诊记录 + 手术开始日期 索引
Index IndexEpisodeDrOperDate On (OREpisodeDr, OROperDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (OREpisodeDr, ORUpdateDate);

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  根据ID作废手麻记录
/// Table：       DHCHAI.DP.OROperAnaesRecord
/// Input：       id:    DHCHAI.DP.OROperAnaesRecord.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperAnaesRecord).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.OROperAnaesRecord).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.ORIsActive		= 0
	Set obj.ORUpdateDate    = +$h
	Set obj.ORUpdateTime    = $p($h,",",2)
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

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  根据ID取手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaesRecord
/// Input：       ID:    DHCHAI.DP.OROperAnaesRecord.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperAnaesRecord).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OROperAnaesRecord
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OROperAnaesRecord).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OROperAnaesRecord).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  根据Code取手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaesRecord
/// Input：       aSCode:    DHCHAI.DP.OROperAnaesRecord.ORSCode
/// 			  aXCode:    DHCHAI.DP.OROperAnaesRecord.ORXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperAnaesRecord).GetObjByXCode()
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.OROperAnaesRecord
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.DP.OROperAnaesRecordI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  更新手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaesRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperAnaesRecord).Update("^111^^^择期^2016-09-01^10:30^^^0^ZXYJHYK-中西医结合一科^冯红^411^周玉玲^^Ⅱ类切口^^吸入麻醉,静脉麻醉,基础麻醉^^^^OPS01^102^^^^^^^^1^64505^44432,静脉麻醉,基础麻醉^^^^OPS01^102^^^^^^^^1^64504^60062","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			 = $p(InStr,aSeparete,1)
	Set EpisodeDr	 = $p(InStr,aSeparete,2)
	Set OperICD		 = $p(InStr,aSeparete,3)
	Set OperDesc	 = $p(InStr,aSeparete,4)
	Set OperType	 = $p(InStr,aSeparete,5)
	Set OperDate	 = $p(InStr,aSeparete,6)
	Set SttTime		 = $p(InStr,aSeparete,7)
	Set EndDate		 = $p(InStr,aSeparete,8)
	Set EndTime		 = $p(InStr,aSeparete,9)
	Set OperHour	 = $p(InStr,aSeparete,10)
	Set OperLocDr	 = $p(InStr,aSeparete,11)
	Set OperLoc      = $p(InStr,aSeparete,12)
	Set Opertor    	 = $p(InStr,aSeparete,13)
	Set Assistant1	 = $p(InStr,aSeparete,14)
	Set Assistant2	 = $p(InStr,aSeparete,15)
	Set Incision	 = $p(InStr,aSeparete,16)
	Set Healing		 = $p(InStr,aSeparete,17)
	Set AnesMethod	 = $p(InStr,aSeparete,18)
	Set Anesthesia	 = $p(InStr,aSeparete,19)
	Set ASAScore	 = $p(InStr,aSeparete,20)
	Set NNISGrade	 = $p(InStr,aSeparete,21)
	Set SCode	 	 = $p(InStr,aSeparete,22)
	Set XCode	 	 = $p(InStr,aSeparete,23)
	Set WBC		     = $p(InStr,aSeparete,24)
	Set IncisionNum  = $p(InStr,aSeparete,25)
	Set IsSightGlass = +$p(InStr,aSeparete,26)
	Set IsImplants   = +$p(InStr,aSeparete,27)
	Set LoseBlood    = $p(InStr,aSeparete,28)
	Set GotBlood     = $p(InStr,aSeparete,29)
	Set Complication = $p(InStr,aSeparete,30)
	Set IsActive	 = +$p(InStr,aSeparete,31)
	Set UpdateDate	 = $p(InStr,aSeparete,32)
	Set UpdateTime	 = $p(InStr,aSeparete,33)
	Set OperStatus   = $p(InStr,aSeparete,34)
	Set OPertypesoc   = $p(InStr,aSeparete,35)
	
	Set:OperDate["-" OperDate = $zdh(OperDate,3)
	Set:SttTime[":" SttTime = $zth(SttTime,1)
	Set:EndDate["-" EndDate = $zdh(EndDate,3)
	Set:EndTime[":" EndTime = $zth(EndTime,1)
	Quit:(EpisodeDr="")||(OperDesc="")||(OperDate="")||(Opertor="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	Set objOperLoc = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.OROperAnaesRecordI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OROperAnaesRecord).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OROperAnaesRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OREpisodeDr		= objAdm
	Set obj.OROperICD		= OperICD
	Set obj.OROperDesc		= OperDesc
	Set obj.OROperType		= OperType
	Set obj.OROperDate		= OperDate
	Set obj.ORSttTime		= SttTime
	Set obj.OREndDate		= EndDate
	Set obj.OREndTime		= EndTime
	Set obj.OROperHour		= OperHour
	Set obj.OROperLocDr	    = objOperLoc
	Set obj.OROperLoc	    = OperLoc
	Set obj.OROpertor	    = Opertor
	Set obj.ORAssistant1	= Assistant1
	Set obj.ORAssistant2	= Assistant2
	Set obj.ORIncision		= Incision
	Set obj.ORHealing		= Healing
	Set obj.ORAnesMethod	= AnesMethod
	Set obj.ORAnesthesia	= Anesthesia
	Set obj.ORASAScore		= ASAScore
	Set obj.ORNNISGrade		= NNISGrade
	Set obj.ORSCode			= SCode
	Set obj.ORXCode			= XCode
	Set obj.ORWBC			= WBC
	Set obj.ORIncisionNum   = IncisionNum
	Set obj.ORIsSightGlass  = IsSightGlass
	Set obj.ORIsImplants    = IsImplants
	Set obj.ORLoseBlood		= LoseBlood
	Set obj.ORGotBlood      = GotBlood
	Set obj.ORComplication  = Complication
	Set obj.OROperStatus    = OperStatus
	Set obj.ORIsActive		= IsActive
	Set obj.ORUpdateDate    = +$h
	Set obj.ORUpdateTime    = $p($h,",",2)
	Set obj.OROperTypeSoC    = OPertypesoc
	
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

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  删除手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaesRecord
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OROperAnaesRecord).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="OROperAnaesRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OREpisodeDr</Value>
</Value>
<Value name="3">
<Value>OROperICD</Value>
</Value>
<Value name="4">
<Value>OROperDesc</Value>
</Value>
<Value name="5">
<Value>OROperType</Value>
</Value>
<Value name="6">
<Value>OROperStatus</Value>
</Value>
<Value name="7">
<Value>OROperDate</Value>
</Value>
<Value name="8">
<Value>ORSttTime</Value>
</Value>
<Value name="9">
<Value>OREndDate</Value>
</Value>
<Value name="10">
<Value>OREndTime</Value>
</Value>
<Value name="11">
<Value>OROperHour</Value>
</Value>
<Value name="12">
<Value>OROperLocDr</Value>
</Value>
<Value name="13">
<Value>OROperLoc</Value>
</Value>
<Value name="14">
<Value>OROpertor</Value>
</Value>
<Value name="15">
<Value>ORAssistant1</Value>
</Value>
<Value name="16">
<Value>ORAssistant2</Value>
</Value>
<Value name="17">
<Value>ORIncision</Value>
</Value>
<Value name="18">
<Value>ORHealing</Value>
</Value>
<Value name="19">
<Value>ORAnesMethod</Value>
</Value>
<Value name="20">
<Value>ORAnesthesia</Value>
</Value>
<Value name="21">
<Value>ORASAScore</Value>
</Value>
<Value name="22">
<Value>ORNNISGrade</Value>
</Value>
<Value name="23">
<Value>ORSCode</Value>
</Value>
<Value name="24">
<Value>ORXCode</Value>
</Value>
<Value name="25">
<Value>ORWBC</Value>
</Value>
<Value name="26">
<Value>ORIncisionNum</Value>
</Value>
<Value name="27">
<Value>ORIsSightGlass</Value>
</Value>
<Value name="28">
<Value>ORIsImplants</Value>
</Value>
<Value name="29">
<Value>ORLoseBlood</Value>
</Value>
<Value name="30">
<Value>ORGotBlood</Value>
</Value>
<Value name="31">
<Value>ORComplication</Value>
</Value>
<Value name="32">
<Value>ORIsActive</Value>
</Value>
<Value name="33">
<Value>ORUpdateDate</Value>
</Value>
<Value name="34">
<Value>ORUpdateTime</Value>
</Value>
<Value name="35">
<Value>OROperTypeSoC</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OROperAnaesRecordD</DataLocation>
<DefaultData>OROperAnaesRecordDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OROperAnaesRecordD</IdLocation>
<IndexLocation>^DHCHAI.DP.OROperAnaesRecordI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OROperAnaesRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
