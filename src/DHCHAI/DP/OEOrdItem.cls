/// 名称: DHCHAI.DP.OEOrdItem
/// 描述: 医嘱表(只存储抗生素医嘱和三管操作医嘱)
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEOrdItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property OEEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 医嘱代码
Property OEOrdCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱名称
Property OEOrdDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医嘱分类（R药品、L检验、O其他）
Property OEOrdType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱大类
Property OEOrdCat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱子类
Property OEOrdSubCat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱类型
Property OEPriority As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医嘱状态
Property OEOrdStatus As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 开医嘱日期
Property OEOrdDate As %Date;

/// 开医嘱时间
Property OEOrdTime As %Time;

/// 开医嘱科室
Property OEOrdLocDr As DHCHAI.BT.Location;

/// 开医嘱科室（ID|Code|Desc）
Property OEOrdLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 开医嘱医生
Property OEDocDr As DHCHAI.BT.CareProv;

/// 开医嘱医生（ID|Code|Desc）
Property OEDoctor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱接收科室
Property OERecLocDr As DHCHAI.BT.Location;

/// 医嘱接收科室（ID|Code|Desc）
Property OERecLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱开始日期
Property OESttDate As %Date;

/// 医嘱开始时间
Property OESttTime As %Time;

/// 停医嘱日期
Property OEXDate As %Date;

/// 停医嘱时间
Property OEXTime As %Time;

/// 药品通用名
Property OEGeneric As %String(MAXLEN = 100, TRUNCATE = 1);

/// 给药途径
Property OEInstruc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单次剂量
Property OEDoseQty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 剂量单位
Property OEDoseQtyUom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 频次
Property OEFreqDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property OESCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property OEXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property OEIsActive As %Boolean [ Required ];

/// 更新日期
Property OEUpdateDate As %Date;

/// 更新时间
Property OEUpdateTime As %Time;

/// 管制分类
Property OEAntDrgPoison As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用目的
Property OEAntUsePurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他目的
Property OEAntOthPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否送检
Property OEAntIsSubmiss As %Boolean;

/// 感染部位
Property OEAntInfPos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用日期
Property OEAntUseDate As %Date;

/// 使用时间
Property OEAntUseTime As %Time;

/// 抗生素标志
Property OEAntUseFlag As %Boolean;

/// 关联主医嘱
Property OEFillerNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱阶段
Property OEStage As %String;

/// 术前几小时使用抗菌药物
Property OEAntiAHours As %String;

/// 术后几小时停止使用抗菌药物
Property OEAntiBHours As %String;

/// 医嘱备注
Property OEDepProcNotes As %String(MAXLEN = 100, TRUNCATE = 1);

/// add pylian 20220909 抗菌药物医嘱首次执行时间
Property OEAntExecDate As %Date;

Property OEAntExecTime As %Time;

/// 子系统代码 + 记录索引码 索引
Index IndexSCodeXCode On (OESCode As Exact, OEXCode As Exact);

/// 就诊记录索引
Index IndexEpisodeDr On OEEpisodeDr;

/// 关联主医嘱索引
Index IndexFillerNo On OEFillerNo;

/// 更新日期索引
Index IndexOrdDescDate On (OESCode As Exact, OEOrdDesc As Exact, OEUpdateDate);

/// 就诊+更新日期索引
Index IndexEpisodeOrdDescDate On (OEEpisodeDr, OESCode As Exact, OEOrdDesc As Exact, OEUpdateDate);

/// 医嘱开始日期索引
Index IndexAntUseSttDate On (OESCode As Exact, OEAntUseFlag, OESttDate);

/// 停医嘱日期索引
Index IndexAntUseXDate On (OESCode As Exact, OEAntUseFlag, OEXDate);

/// 就诊医嘱开始日期索引
Index IndexEpisAntUseSttDate On (OEEpisodeDr, OESCode As Exact, OEAntUseFlag, OESttDate);

/// 就诊停医嘱日期索引
Index IndexEpisAntUseXDate On (OEEpisodeDr, OESCode As Exact, OEAntUseFlag, OEXDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (OEEpisodeDr, OEUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废医嘱记录
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       id:    DHCHAI.DP.OEOrdItem.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEOrdItem).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.OEOrdItem).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.OEIsActive		= 0
	Set obj.OEUpdateDate    = +$h
	Set obj.OEUpdateTime    = $p($h,",",2)
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
/// Description:  根据ID取医嘱表
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       ID:    DHCHAI.DP.OEOrdItem.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEOrdItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEOrdItem
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEOrdItem).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEOrdItem).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据记录索引码取医嘱
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aScode:    DHCHAI.DP.OEOrdItem.OESCode
/// 				  aXCode:    DHCHAI.DP.OEOrdItem.OEXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(1)
ClassMethod GetObjByXCode(aScode As %String, aXCode As %String) As DHCHAI.DP.OEOrdItem
{
	New (aScode,aXCode)
	Set return=""
	Quit:(aXCode="")||(aScode="") return
	
	Set id = $o(^DHCHAI.DP.OEOrdItemI("IndexSCodeXCode",aScode,aXCode,0)) 	
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-28
/// Description:  根据FillerNo更新长期医嘱状态（滚医嘱方式）
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aFillerNo:    DHCHAI.DP.OEOrdItem.OEFillerNo
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEOrdItem).UpdateStatus(1)
ClassMethod UpdateStatus(aFillerNo As %String) As %String
{
	New (aFillerNo)
	Set return=""
	Quit:aFillerNo="" return
	
	Set objFiller=..GetObjById(aFillerNo)
	Quit:'$IsObject(objFiller) return
	Quit:objFiller.OEIsActive=0 return
	Set FillerNo=objFiller.%Id()
	Set XDate=objFiller.OEXDate
	Set XTime=objFiller.OEXTime
	Set Status=objFiller.OEOrdStatus
	
	Set IsChange=0
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexFillerNo"," "_FillerNo,xID))
		Quit:xID=""
		Set objFiller=..GetObjById(xID)
		Continue:'$IsObject(objFiller)
		Set tXDate=objFiller.OEXDate
		Continue:tXDate=""
		Set tXTime=objFiller.OEXTime
		Set tXTime=+tXTime
		Set tStatus=objFiller.OEOrdStatus
		If XDate="" {
			Set XDate=tXDate
			Set XTime=tXTime
			Set Status=tStatus
			Set IsChange=1
		} Else {
			If (XDate<tXDate)||((XDate=tXDate)&(XTime<tXTime)) {
				Set XDate=tXDate
				Set XTime=tXTime
				Set Status=tStatus
				Set IsChange=1
			}
		}
	}
	Quit:IsChange<1 return
	
	Set obj=##class(DHCHAI.DP.OEOrdItem).%OpenId(FillerNo)
	Quit:'$IsObject(obj) return
	Set obj.OEXDate	       = XDate
	Set obj.OEXTime        = XTime
	Set obj.OEOrdStatus    = Status
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
/// Description:  更新医嘱表
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEOrdItem).Update("^63^A00N001^药箅子[1个]^O^材料类医嘱^代管器材^临时医嘱^核实^64127^300^37^^^64127^300^64127^300^药箅子^^^^^HIS01^205||100^1^64505^59082")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(InStr,aSeparete,1)
	Set EpisodeDr		= $p(InStr,aSeparete,2)
	Set OrdCode			= $p(InStr,aSeparete,3)
	Set OrdDesc			= $p(InStr,aSeparete,4)
	Set OrdType			= $p(InStr,aSeparete,5)
	Set OrdCat			= $p(InStr,aSeparete,6)
	Set OrdSubCat		= $p(InStr,aSeparete,7)
	Set Priority		= $p(InStr,aSeparete,8)
	Set OrdStatus		= $p(InStr,aSeparete,9)
	Set OrdDate			= $p(InStr,aSeparete,10)
	Set OrdTime			= $p(InStr,aSeparete,11)
	Set OrdLocDr		= $p(InStr,aSeparete,12)
	Set OrdLoc 			= $p(InStr,aSeparete,13)
	Set Doctor    	    = $p(InStr,aSeparete,14)
	Set SttDate			= $p(InStr,aSeparete,15)
	Set SttTime			= $p(InStr,aSeparete,16)
	Set XDate			= $p(InStr,aSeparete,17)
	Set XTime			= $p(InStr,aSeparete,18)
	Set Generic			= $p(InStr,aSeparete,19)
	Set Instruc			= $p(InStr,aSeparete,20)
	Set DoseQty			= $p(InStr,aSeparete,21)
	Set DoseQtyUom		= $p(InStr,aSeparete,22)
	Set FreqDesc		= $p(InStr,aSeparete,23)
	Set SCode			= $p(InStr,aSeparete,24)
	Set XCode			= $p(InStr,aSeparete,25)
	Set IsActive		= +$p(InStr,aSeparete,26)
	Set UpdateDate		= $p(InStr,aSeparete,27)
	Set UpdateTime		= $p(InStr,aSeparete,28)
	
	Set AntDrgPoison    = $p(InStr,aSeparete,29)
	Set AntUsePurpose   = $p(InStr,aSeparete,30)
	Set AntOthPurpose   = $p(InStr,aSeparete,31)
	Set AntIsSubmiss    = +$p(InStr,aSeparete,32)
	Set AntInfPos       = $p(InStr,aSeparete,33)
	Set AntUseDate      = $p(InStr,aSeparete,34)
	Set AntUseTime      = $p(InStr,aSeparete,35)
	Set AntUseFlag      = $p(InStr,aSeparete,36)
	
	//add by zf 增加内容
	Set OrdDocDr		= $p(InStr,aSeparete,37)  //开医嘱医生
	Set RecLocDr		= $p(InStr,aSeparete,38)  //医嘱接收科室ID
	Set RecLoc 			= $p(InStr,aSeparete,39)  //医嘱接收科室
	Set FillerNo        = $p(InStr,aSeparete,40)  //主医嘱ID
	///add by wpl 添加医嘱阶段 2020-07-08
	Set Stage           = $p(InStr,aSeparete,41)
	Set DepProcNotes	= $p(InStr,aSeparete,42)  //医嘱备注
	// add pylian 20220909 抗菌药物医嘱首次执行时间
	Set ExecutDate      = $p(InStr,aSeparete,43) //医嘱首次执行时间  42
	Set ExecutTime	    = $p(InStr,aSeparete,44) 
	 
	Set:OrdDate["-" OrdDate = $zdh(OrdDate,3)
	Set:OrdTime[":" OrdTime = $zth(OrdTime,1)
	Set:SttDate["-" SttDate = $zdh(SttDate,3)
	Set:SttTime[":" SttTime = $zth(SttTime,1)
	Set:XDate["-" XDate = $zdh(XDate,3)
	Set:XTime[":" XTime = $zth(XTime,1)
	Set:ExecutDate["-" ExecutDate = $zdh(ExecutDate,3)
	Set:ExecutTime[":" ExecutTime = $zth(ExecutTime,1)
	
	Quit:(EpisodeDr="")||(OrdDesc="")||(OrdType="")||(Priority="")||(OrdStatus="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	Set objOrdLoc=##class(DHCHAI.BT.Location).GetObjById(OrdLocDr)
	Set objOrdDoc=##class(DHCHAI.BT.CareProv).GetObjById(OrdDocDr)
	Set objRecLoc=##class(DHCHAI.BT.Location).GetObjById(RecLocDr)
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.OEOrdItemI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEOrdItem).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEOrdItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set (AntiAHours,AntiBHours)=""
	If (Stage'="")&(Stage'="术中"){
		Set aFromDate=SttDate-5
		Set aToDate=SttDate-2
		For xOROperDate=aFromDate:1:aToDate {
			Set xOROperID=""
			For{
				Set xOROperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",EpisodeDr,xOROperDate,xOROperID))
				Quit:xOROperID=""
				
				Set objOROper=##class(DHCHAI.DP.OROperAnaes).GetObjById(xOROperID)
				Continue:'$IsObject(objOROper)
				
				Set OREndDate	= objOROper.OREndDate	/// 手术结束日期
				Set OREndTime	= objOROper.OREndTime	/// 手术结束时间
				Set OROperDate	= objOROper.OROperDate	/// 手术开始日期
				Set ORSttTime	= objOROper.ORSttTime	/// 手术开始时间
				
				if (Stage="术后")&(OREndDate'=""){
					Set AHours=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OREndDate,OREndTime,SttDate,SttTime)
					Set:(AHours<=72)&(AHours>0) AntiAHours=AHours
				}
				if (AntiBHours="")&(Stage="术前"){
					Set BHours=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(SttDate,SttTime,OROperDate,ORSttTime)
					Set:(BHours<=24)&(BHours>0) AntiBHours=BHours
				}
			}
		}
	}
	
	Set obj.OEEpisodeDr		= objAdm
	Set obj.OEOrdCode		= OrdCode
	Set obj.OEOrdDesc		= OrdDesc
	Set obj.OEOrdType		= OrdType
	Set obj.OEOrdCat		= OrdCat
	Set obj.OEOrdSubCat		= OrdSubCat	
	Set obj.OEPriority		= Priority
	Set obj.OEOrdStatus		= OrdStatus
	Set obj.OEOrdDate		= OrdDate
	Set obj.OEOrdTime		= OrdTime
	Set obj.OEOrdLocDr		= objOrdLoc
	Set obj.OEOrdLoc		= OrdLoc
	Set obj.OEDocDr         = objOrdDoc
	Set obj.OEDoctor		= Doctor
	Set obj.OERecLocDr      = objRecLoc
	Set obj.OERecLoc        = RecLoc
	Set obj.OESttDate		= SttDate
	Set obj.OESttTime		= SttTime
	Set obj.OEXDate			= XDate
	Set obj.OEXTime			= XTime	
	Set obj.OEGeneric		= Generic
	Set obj.OEInstruc		= Instruc
	Set obj.OEDoseQty		= DoseQty
	Set obj.OEDoseQtyUom	= DoseQtyUom
	Set obj.OEFreqDesc		= FreqDesc
	Set obj.OESCode			= SCode
	Set obj.OEXCode			= XCode
	Set obj.OEIsActive		= IsActive
	Set obj.OEUpdateDate	= +$h
	Set obj.OEUpdateTime	= $p($h,",",2)
	
	Set obj.OEAntDrgPoison  = AntDrgPoison
	Set obj.OEAntUsePurpose = AntUsePurpose
	Set obj.OEAntOthPurpose = AntOthPurpose
	Set obj.OEAntIsSubmiss  = AntIsSubmiss
	Set obj.OEAntInfPos     = AntInfPos
	Set obj.OEAntUseDate    = AntUseDate
	Set obj.OEAntUseTime    = AntUseTime
	Set obj.OEAntUseFlag    = AntUseFlag
	Set obj.OEFillerNo      = FillerNo   //主医嘱ID
	Set obj.OEStage			= Stage
	Set obj.OEAntiAHours	= AntiAHours
	Set obj.OEAntiBHours	= AntiBHours
	Set obj.OEDepProcNotes	= DepProcNotes	//医嘱备注
	Set obj.OEAntExecDate   = ExecutDate
	Set obj.OEAntExecTime   = ExecutTime
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	//处理主医嘱停止时间问题
	If return>0 {
		Do ..UpdateStatus(FillerNo)
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除医嘱表
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OEOrdItem).%DeleteId(+Id)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEEpisodeDr</Value>
</Value>
<Value name="3">
<Value>OEOrdCode</Value>
</Value>
<Value name="4">
<Value>OEOrdDesc</Value>
</Value>
<Value name="5">
<Value>OEOrdType</Value>
</Value>
<Value name="6">
<Value>OEOrdCat</Value>
</Value>
<Value name="7">
<Value>OEOrdSubCat</Value>
</Value>
<Value name="8">
<Value>OEPriority</Value>
</Value>
<Value name="9">
<Value>OEOrdStatus</Value>
</Value>
<Value name="10">
<Value>OEOrdDate</Value>
</Value>
<Value name="11">
<Value>OEOrdTime</Value>
</Value>
<Value name="12">
<Value>OEOrdLocDr</Value>
</Value>
<Value name="13">
<Value>OEOrdLoc</Value>
</Value>
<Value name="14">
<Value>OEDoctor</Value>
</Value>
<Value name="15">
<Value>OESttDate</Value>
</Value>
<Value name="16">
<Value>OESttTime</Value>
</Value>
<Value name="17">
<Value>OEXDate</Value>
</Value>
<Value name="18">
<Value>OEXTime</Value>
</Value>
<Value name="19">
<Value>OEGeneric</Value>
</Value>
<Value name="20">
<Value>OEInstruc</Value>
</Value>
<Value name="21">
<Value>OEDoseQty</Value>
</Value>
<Value name="22">
<Value>OEDoseQtyUom</Value>
</Value>
<Value name="23">
<Value>OEFreqDesc</Value>
</Value>
<Value name="24">
<Value>OEXCode</Value>
</Value>
<Value name="25">
<Value>OEIsActive</Value>
</Value>
<Value name="26">
<Value>OEUpdateDate</Value>
</Value>
<Value name="27">
<Value>OEUpdateTime</Value>
</Value>
<Value name="28">
<Value>OESCode</Value>
</Value>
<Value name="29">
<Value>OEAntDrgPoison</Value>
</Value>
<Value name="30">
<Value>OEAntUsePurpose</Value>
</Value>
<Value name="31">
<Value>OEAntOthPurpose</Value>
</Value>
<Value name="32">
<Value>OEAntIsSubmiss</Value>
</Value>
<Value name="33">
<Value>OEAntInfPos</Value>
</Value>
<Value name="34">
<Value>OEAntUseDate</Value>
</Value>
<Value name="35">
<Value>OEAntUseTime</Value>
</Value>
<Value name="36">
<Value>OEAntUseFlag</Value>
</Value>
<Value name="37">
<Value>OEDocDr</Value>
</Value>
<Value name="38">
<Value>OERecLocDr</Value>
</Value>
<Value name="39">
<Value>OERecLoc</Value>
</Value>
<Value name="40">
<Value>OEFillerNo</Value>
</Value>
<Value name="41">
<Value>OEStage</Value>
</Value>
<Value name="42">
<Value>OEAntiAHours</Value>
</Value>
<Value name="43">
<Value>OEAntiBHours</Value>
</Value>
<Value name="44">
<Value>OEDepProcNotes</Value>
</Value>
<Value name="45">
<Value>OEAntExecDate</Value>
</Value>
<Value name="46">
<Value>OEAntExecTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OEOrdItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEOrdItemD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEOrdItemI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEOrdItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
