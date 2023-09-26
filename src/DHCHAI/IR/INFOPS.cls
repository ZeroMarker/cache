/// 名称: DHCHAI.IR.INFOPS
/// 描述: 手术切口调查表
/// 编写者：zhufei
/// 编写日期: 2017-06-28
Class DHCHAI.IR.INFOPS Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 手术指针
Property IROperDr As DHCHAI.DP.OROperAnaes;

/// 手术名称（手麻系统名称）
Property IROperName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 手术名称（标准名称）
Property IROperName2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术科室
Property IROperLocDr As DHCHAI.BT.Location;

/// 手术日期
Property IROperDate As %Date;

/// 结束日期
Property IREndDate As %Date;

/// 开始时间
Property IRSttTime As %Time;

/// 结束时间
Property IREndTime As %Time;

/// 手术时长（小时）
Property IROperHours As %String;

/// 手术医生
Property IROperDocTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术医生指针
Property IROperDocDr As DHCHAI.BT.SysUser;

/// 手术类型
Property IROperTypeDr As DHCHAI.BT.Dictionary;

/// 麻醉方式
Property IRAnesthesiaDr As DHCHAI.BT.Dictionary;

/// NNIS分级
Property IRNNISLevelDr As DHCHAI.BT.Dictionary;

/// 切口类型
Property IRCuteTypeDr As DHCHAI.BT.Dictionary;

/// 愈合情况
Property IRCuteHealingDr As DHCHAI.BT.Dictionary;

/// 是否切口感染
Property IRIsOperInf As %Boolean;

/// 手术感染类型
Property IRInfTypeDr As DHCHAI.BT.InfPos;

/// 是否引起院内感染
Property IRIsInHospInf As %Boolean;

/// ASA麻醉评分
Property IRASAScore As DHCHAI.BT.Dictionary;

/// 术前外周WBC计数 单位(×10^9/L)
Property IRPreoperWBC As %Integer;

/// 切口个数
Property IRCuteNumber As %String(MAXLEN = 50, TRUNCATE = 1);

/// 是否使用窥镜
Property IREndoscopeFlag As %Boolean;

/// 是否植入物
Property IRImplantFlag As %Boolean;

/// 是否术前口服抗生素肠道准备
Property IRPreoperAntiFlag As %Boolean;

/// 是否失血
Property IRBloodLossFlag As %Boolean;

/// 术中失血量(ml)
Property IRBloodLoss As %Integer;

/// 是否输血
Property IRBloodTransFlag As %Boolean;

/// 术中输血量(ml)
Property IRBloodTrans As %Integer;

/// 术后并发症
Property IRPostoperComps As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 回访人员
Property IRVisitName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 回访日期
Property IRVistDate As %Date;

/// 回访结果
Property IRVisitResultDr As DHCHAI.BT.Dictionary;

/// 回访备注
Property IRVisitResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 患者联系电话
Property IRPatTem As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否随访   (Add 2022-04-22 Hp 方便上报北京民科系统)
Property IRVisit As %Boolean;

/// 是否电话随访   
Property IRVisitDH As %Boolean;

/// 是否信函随访
Property IRVisitXH As %Boolean;

/// 是否短信随访
Property IRVisitDX As %Boolean;

/// 是否门诊随访
Property IRVisitMZ As %Boolean;

/// 是否家庭随访
Property IRVisitJT As %Boolean;

/// 是否其他随访
Property IRVisitQT As %Boolean;

/// 其他随访方式
Property IRVisitQTFS As %Integer;

/// 疾病转归
Property IRInfEffect As DHCHAI.BT.Dictionary;

/// 与死亡关系
Property IRDeathRelation As DHCHAI.BT.Dictionary;

/// 手术部位是否感染
Property IRInfPosXZ As DHCHAI.BT.Dictionary;

/// 手术部位感染诊断依据
Property IRInfPosZDYJ As DHCHAI.BT.Dictionary;

/// 是否有植入物
Property IRImplant As DHCHAI.BT.Dictionary;

/// 是否回访
Property IRVisitPro As DHCHAI.BT.Dictionary;

/// 回访方式
Property IRVisitMethod As DHCHAI.BT.Dictionary;

/// 其他
Property IRVisitQita As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期索引
Index IndexUpdateDate On IRUpdateDate;

/// 就诊记录+手术指针索引
Index IndexEpisodeOperDr On (IREpisodeDr, IROperDr);

/// 手术日期索引
Index IndexOperDate On IROperDate;

/// 回访日期+手术指针索引
Index IndexVistDateOperDr On (IRVistDate, IROperDr);

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  根据RowId取手术切口调查表信息
/// Table：       DHCHAI.IR.INFOPS
/// Input：       RowId    DHCHAI.IR.INFOPS
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.INFOPS
{
	New (RowId)
	Set return=""
	Quit:RowId="" return
	Quit:'##class(DHCHAI.IR.INFOPS).%ExistsId(+RowId) ""
	Set obj=##Class(DHCHAI.IR.INFOPS).%OpenId(+RowId)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  根据就诊记录和手术记录取手术切口调查表信息
/// Table：       DHCHAI.IR.INFOPS
/// Input：       ID:    
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(1,2)
ClassMethod GetObjByEpOperDr(aEpisodeDr As %String, aOperDr As %String) As DHCHAI.IR.INFOPS
{
	New (aEpisodeDr,aOperDr)
	Set return=""
	Quit:((aEpisodeDr="")||(aOperDr="")) return
	
	Set id = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",aEpisodeDr,aOperDr,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  更新手术切口调查表
/// Table：       DHCHAI.IR.INFOPS
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFOPS).Update("329^undefined^undefined^undefined^膝关节镜下半月板成形术^undefined^2020-10-29^2021-03-18^09:00^10:46^^张学来^^214^52^72^58^63^0^^0^65^12^2^1^0^0^0^0^216,217,218^^^1197^沈超^2021-04-12^773^无需备注","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID=$p(InStr,separete,1)
	Set EpisodeDr       = $p(InStr,separete,2)
	Set OperDr          = $p(InStr,separete,3)
	
	If OperDr'=""{
		Set ID = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",EpisodeDr,OperDr,""))
	}
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFOPS).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFOPS).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IROperDr    = ##class(DHCHAI.DP.OROperAnaes).GetObjById(OperDr)
	Set OperLocDr       = $p(InStr,separete,4)
	Set obj.IREpisodeDr = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Set obj.IROperLocDr = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)  // 手术科室
	Set OperName        = $p(InStr,separete,5)      // 手麻系统手术名称
	Set obj.IROperName  = OperName
	Set OperName2       = $p(InStr,separete,6)      // 标准手术名称 DR
	Set OperDxobj = ##class(DHCHAI.DP.OROperDx).GetObjById(OperName2)
	if $IsObject(OperDxobj){
		Set obj.IROperName2 = OperDxobj.BTOperDesc
	}else{
		Set obj.IROperName2 = OperName2
	}
	Set OperDate        = $p(InStr,separete,7)      // 手术开始日期
	Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(OperDate)
	Set obj.IROperDate  = OperDate
	Set EndDate         = $p(InStr,separete,8)      // 手术结束日期
	Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	Set obj.IREndDate   = EndDate
	Set SttTime         = $p(InStr,separete,9)      // 手术开始时间
	Set:SttTime[":" SttTime=$zth(SttTime,1)
	Set obj.IRSttTime   = SttTime
	Set EndTime         = $p(InStr,separete,10)      // 手术结束时间
	Set:EndTime[":" EndTime=$zth(EndTime,1)
	Set obj.IREndTime   = EndTime
	Set OperHours       = $p(InStr,separete,11)     // 手术时长  调整精确到2位数
	//Set OperHours = ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,SttTime,EndDate,EndTime)
	Set SpanSec=..GetGapNow(OperDate,SttTime,EndDate,EndTime)  //秒数
	if (SpanSec>0)
	{
		Set OperHours=$fn((SpanSec/(60*60)),"",2)
	}
	Set obj.IROperHours = OperHours
	Set OperDocTxt      = $p(InStr,separete,12)     // 手术医生
	Set obj.IROperDocTxt = OperDocTxt
	Set OperDocDr       = $p(InStr,separete,13)     // 手术医生DR
	Set obj.IROperDocDr = ##class(DHCHAI.BT.SysUser).GetObjById(OperDocDr)
	Set OperTypeDr      = $p(InStr,separete,14)     // 手术类型DR
	Set obj.IROperTypeDr= ##class(DHCHAI.BT.Dictionary).GetObjById(OperTypeDr)
	Set AnesthesiaDr    = $p(InStr,separete,15)     // 麻醉方式DR
	Set obj.IRAnesthesiaDr = ##class(DHCHAI.BT.Dictionary).GetObjById(AnesthesiaDr)
	Set NNISLevelDr     = $p(InStr,separete,16)     // NNIS分级DR
	Set obj.IRNNISLevelDr = ##class(DHCHAI.BT.Dictionary).GetObjById(NNISLevelDr)
	Set CuteTypeDr      = $p(InStr,separete,17)     // 切口类型DR
	Set obj.IRCuteTypeDr= ##class(DHCHAI.BT.Dictionary).GetObjById(CuteTypeDr)
	Set CuteHealingDr   = $p(InStr,separete,18)     // 愈合情况DR
	Set obj.IRCuteHealingDr = ##class(DHCHAI.BT.Dictionary).GetObjById(CuteHealingDr)
	Set IsOperInf       = +$p(InStr,separete,19)    // 是否切口感染
	Set obj.IRIsOperInf = IsOperInf
	Set InfTypeDr       = $p(InStr,separete,20)     // 感染部位DR
	Set obj.IRInfTypeDr = ##class(DHCHAI.BT.InfPos).GetObjById(InfTypeDr)
	Set IsInHospInf     = +$p(InStr,separete,21)    // 是否引起院感
	Set obj.IRIsInHospInf = IsInHospInf
	Set ASAScore        = $p(InStr,separete,22)     // ASA评分DR
	Set obj.IRASAScore  = ##class(DHCHAI.BT.Dictionary).GetObjById(ASAScore)
	Set PreoperWBC      = $p(InStr,separete,23)     // 术前外周WBC
	Set obj.IRPreoperWBC = PreoperWBC
	Set CuteNumber      = $p(InStr,separete,24)     // 切口个数
	Set obj.IRCuteNumber = CuteNumber
	Set EndoscopeFlag   = +$p(InStr,separete,25)    // 是否使用窥镜
	Set obj.IREndoscopeFlag = EndoscopeFlag
	Set ImplantFlag     = +$p(InStr,separete,26)    // 是否植入物
	Set obj.IRImplantFlag = ImplantFlag
	Set PreoperAntiFlag = +$p(InStr,separete,27)    // 术前口服抗生素
	Set obj.IRPreoperAntiFlag = PreoperAntiFlag
	Set BloodLoss       = +$p(InStr,separete,28)    // 失血量
	Set obj.IRBloodLoss = BloodLoss
	Set BloodLossFlag   = $s((BloodLoss>0):1,1:0)   // 是否失血
	Set obj.IRBloodLossFlag = BloodLossFlag
	Set BloodTrans      = +$p(InStr,separete,29)    // 输血量
	Set obj.IRBloodTrans = BloodTrans
	Set BloodTransFlag  = $s((BloodTrans>0):1,1:0)  // 是否输血
	Set obj.IRBloodTransFlag = BloodTransFlag
	Set PostoperComps   = $p(InStr,separete,30)     // 并发症
	Set obj.IRPostoperComps   = PostoperComps
	Set UpdateDate      = $p(InStr,separete,31)     // 更新日期
	Set:UpdateDate="" UpdateDate = +$h
	Set UpdateTime      = $p(InStr,separete,32)     // 更新时间
	Set:UpdateTime="" UpdateTime = $p($h,",",2)
	Set UpdateUserDr    = $p(InStr,separete,33)     // 更新人
	Set obj.IRUpdateDate   = UpdateDate
	Set obj.IRUpdateTime   = UpdateTime
	Set obj.IRUpdateUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	
	Set VisitName       = $p(InStr,separete,34)     // 回访人员
	Set obj.IRVisitName = VisitName
	Set VistDate        = $p(InStr,separete,35)     // 回访日期
	Set:VistDate'="" VistDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VistDate)
	Set obj.IRVistDate  = VistDate
	Set VisitResultDr   = $p(InStr,separete,36)     // 回访结果
	Set obj.IRVisitResultDr = ##class(DHCHAI.BT.Dictionary).GetObjById(VisitResultDr)
	Set VisitResume         = $p(InStr,separete,37)     // 备注
	Set obj.IRVisitResume   = VisitResume
	Set PatTem         = $p(InStr,separete,38)     		//患者联系电话	
	Set obj.IRPatTem		= PatTem					
	
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

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  删除
/// Table：       DHCHAI.IR.INFOPS
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.INFOPS).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Desc:      取时间和当前间隔
/// Creator:   Chenjb
/// CreatDate: 2021-12-30
/// Input:     date 日期
///            time 时间
/// Output:    间隔秒数
/// Debug: w ##class(DHCHAI.IR.INFOPS).GetGapNow("2022-01-24","17:14:05",$P($H,",",1),$P($H,",",2))
ClassMethod GetGapNow(aDate As %String, aTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aDate,aTime,aEndDate,aEndTime)
	//结束日期为空用当前时间
	Set:aDate["-" aDate=$zdh(aDate,3)
	Set:aTime[":" aTime=$zth(aTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	
 	Set currDate = +aEndDate
 	Set currTime = +aEndTime
 	Set:currDate=0 currDate =$p($h,",",1)
 	Set:currDate=0 currTime =$p($h,",",2)
 	Set dayToHour = (currDate - aDate ) * 24*60*60
 	Set secondToHour = (currTime - aTime)
 	Set gap = dayToHour + secondToHour
 	
 	Quit gap
}

Storage Default
{
<Data name="INFOPSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IROperDr</Value>
</Value>
<Value name="4">
<Value>IROperName</Value>
</Value>
<Value name="5">
<Value>IROperName2</Value>
</Value>
<Value name="6">
<Value>IROperLocDr</Value>
</Value>
<Value name="7">
<Value>IROperDate</Value>
</Value>
<Value name="8">
<Value>IREndDate</Value>
</Value>
<Value name="9">
<Value>IRSttTime</Value>
</Value>
<Value name="10">
<Value>IREndTime</Value>
</Value>
<Value name="11">
<Value>IROperHours</Value>
</Value>
<Value name="12">
<Value>IROperDocTxt</Value>
</Value>
<Value name="13">
<Value>IROperDocDr</Value>
</Value>
<Value name="14">
<Value>IROperTypeDr</Value>
</Value>
<Value name="15">
<Value>IRAnesthesiaDr</Value>
</Value>
<Value name="16">
<Value>IRNNISLevelDr</Value>
</Value>
<Value name="17">
<Value>IRCuteTypeDr</Value>
</Value>
<Value name="18">
<Value>IRCuteHealingDr</Value>
</Value>
<Value name="19">
<Value>IRIsOperInf</Value>
</Value>
<Value name="20">
<Value>IRInfTypeDr</Value>
</Value>
<Value name="21">
<Value>IRIsInHospInf</Value>
</Value>
<Value name="22">
<Value>IRASAScore</Value>
</Value>
<Value name="23">
<Value>IRPreoperWBC</Value>
</Value>
<Value name="24">
<Value>IRCuteNumber</Value>
</Value>
<Value name="25">
<Value>IREndoscopeFlag</Value>
</Value>
<Value name="26">
<Value>IRImplantFlag</Value>
</Value>
<Value name="27">
<Value>IRPreoperAntiFlag</Value>
</Value>
<Value name="28">
<Value>IRBloodLossFlag</Value>
</Value>
<Value name="29">
<Value>IRBloodLoss</Value>
</Value>
<Value name="30">
<Value>IRBloodTransFlag</Value>
</Value>
<Value name="31">
<Value>IRBloodTrans</Value>
</Value>
<Value name="32">
<Value>IRPostoperComps</Value>
</Value>
<Value name="33">
<Value>IRUpdateDate</Value>
</Value>
<Value name="34">
<Value>IRUpdateTime</Value>
</Value>
<Value name="35">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="36">
<Value>IRVisitName</Value>
</Value>
<Value name="37">
<Value>IRVistDate</Value>
</Value>
<Value name="38">
<Value>IRVisitResultDr</Value>
</Value>
<Value name="39">
<Value>IRVisitResume</Value>
</Value>
<Value name="40">
<Value>IRPatTem</Value>
</Value>
<Value name="41">
<Value>IRVisit</Value>
</Value>
<Value name="42">
<Value>IRVisitDH</Value>
</Value>
<Value name="43">
<Value>IRVisitXH</Value>
</Value>
<Value name="44">
<Value>IRVisitDX</Value>
</Value>
<Value name="45">
<Value>IRVisitMZ</Value>
</Value>
<Value name="46">
<Value>IRVisitJT</Value>
</Value>
<Value name="47">
<Value>IRVisitQT</Value>
</Value>
<Value name="48">
<Value>IRVisitQTFS</Value>
</Value>
<Value name="49">
<Value>IRInfEffect</Value>
</Value>
<Value name="50">
<Value>IRDeathRelation</Value>
</Value>
<Value name="51">
<Value>IRInfPosXZ</Value>
</Value>
<Value name="52">
<Value>IRInfPosZDYJ</Value>
</Value>
<Value name="53">
<Value>IRImplant</Value>
</Value>
<Value name="54">
<Value>IRVisitPro</Value>
</Value>
<Value name="55">
<Value>IRVisitMethod</Value>
</Value>
<Value name="56">
<Value>IRVisitQita</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFOPSD</DataLocation>
<DefaultData>INFOPSDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFOPSD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFOPSI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFOPSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
