/// 名称: DHCHAI.DP.CSSDRecord
/// 描述: 消毒供应中心
/// 编写者：chenjb
/// 编写日期: 2019-04-01
Class DHCHAI.DP.CSSDRecord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CSSDEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 消毒包条码号（手术包/普通包）
Property CSSDBarCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 消毒包名称
Property CSSDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 消毒器械说明
Property CSSDNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 绑定科室（消毒器械使用科室）
Property CSSDLocDr As DHCHAI.BT.Location;

/// 清洗批次
Property CSSDBatchNumberC As %String(MAXLEN = 100, TRUNCATE = 1);

/// 清洗日期
Property CSSDCleanDate As %Date;

/// 清洗时间
Property CSSDCleanTime As %Time;

/// 清洗人（ID|Code|Desc）
Property CSSDCleanUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 配包人（ID|Code|Desc）
Property CSSDDispUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 配包日期
Property CSSDDispDate As %Date;

/// 配包时间
Property CSSDDispTime As %Time;

/// 灭菌批次
Property CSSDBatchNumberS As %String(MAXLEN = 100, TRUNCATE = 1);

/// 灭菌锅号
Property CSSDBatchG As %String(MAXLEN = 100, TRUNCATE = 1);

/// 灭菌日期
Property CSSDSterilDate As %Date;

/// 灭菌时间
Property CSSDSterilTime As %Time;

/// 灭菌人（ID|Code|Desc）
Property CSSDSterilUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 灭菌验收人（ID|Code|Desc）
Property CSSDSterilYsUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 灭菌有效期至
Property CSSDSterilYxqDate As %Date;

/// 灭菌有效期至
Property CSSDSterilYxqTime As %Time;

/// 发放日期
Property CSSDSendDate As %Date;

/// 发放时间
Property CSSDSendTime As %Time;

/// 发放人（ID|Code|Desc）
Property CSSDSendUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用(手术)日期
Property CSSDReceptDate As %Date;

/// 使用(手术)时间
Property CSSDReceptTime As %Time;

/// 手术医生（ID|Code|Desc）
Property CSSDReceptUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 器械护士（ID|Code|Desc）
Property CSSDReceptHsUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术室
Property CSSDOperLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术房间号
Property CSSDOperBed As %String(MAXLEN = 100, TRUNCATE = 1);

/// 感染名称
Property CSSDInfDiagnos As %String(MAXLEN = 250, TRUNCATE = 1);

/// 回收日期
Property CSSDBackDate As %Date;

/// 回收时间
Property CSSDBackTime As %Time;

/// 回收人（ID|Code|Desc）
Property CSSDBackUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property CSSDSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property CSSDXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property CSSDIsActive As %Boolean [ Required ];

/// 更新日期
Property CSSDUpdateDate As %Date [ Required ];

/// 更新时间
Property CSSDUpdateTime As %Time [ Required ];

/// 就诊号,消毒包索引
Index IndexEpisode On (CSSDEpisodeDr As Exact, CSSDBarCode As Exact);

/// 科室索引
Index IndexLocDr On CSSDLocDr As Exact;

/// Creator：     ShenC
/// CreatDate：   2019-07-25
/// Description:  根据Id取消毒供应中心信息
/// Table：       DHCHAI.DP.CSSDRecord
/// Input：       aId : DHCHAI.DP.CSSDRecord
/// Return：      返回obj
/// w ##class(DHCHAI.DP.CSSDRecord).GetObjById("11")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.CSSDRecord
{
	New (aId)
	Quit:'##class(DHCHAI.DP.CSSDRecord).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.CSSDRecord).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2019-07-25
/// Description:  更新消毒供应中心数据
/// Table：       DHCHAI.DP.CSSDRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.CSSDRecord).Update("1^50^C位 ^O^001002001000049^口鼻器械001^^42|ZYMZ043|生殖医学科门诊^20170825100002^2019-06-25 10:12:57^1|demo|Demo Group^2019-06-25 10:13:26^1|demo|Demo Group^2017082501003^1^2019-06-25 10:14:02^1|demo|Demo Group^1|demo|Demo Group^2019-06-01 10:15:29^2019-06-25 10:15:29^1|demo|^2019-06-25 10:15:29^|郑途|^|innurse|^9^1^mi^2019-06-25 10:14:02^1|demo|Demo Group","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set EpisodeIDX     = $p(aInputStr,aSeparete,1)    		/// HIS就诊号
	Set PatientID	  = $p(aInputStr,aSeparete,2)			/// 病人ID
	Set PatName	 	  = $p(aInputStr,aSeparete,3)			/// 病人姓名
	Set AdmType       = $p(aInputStr,aSeparete,4)			/// 就诊类型(I-住院，O-门诊，E-急诊)
	
	Quit:(EpisodeIDX="") return								/// HIS就诊号为空退出
	Set EpisodeDr=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01||"_EpisodeIDX)	///根据HIS就诊号取病人对象
	Quit:'$isObject(EpisodeDr) return
	Set PatientID=EpisodeDr.%Id()
	
	Set BarCode       = $p(aInputStr,aSeparete,5)    		/// 消毒包条码号（手术包/普通包）	
	Set CSSDId=##class(DHCHAI.DP.CSSDRecord).GetIDByCode(PatientID,BarCode)			///过滤重复信息
	if (CSSDId=""){
		Set obj=##class(DHCHAI.DP.CSSDRecord).%New()
	}
	Else{
		Set obj=##class(DHCHAI.DP.CSSDRecord).%OpenId(CSSDId)
	}
	Quit:'$IsObject(obj) return	
	
	Set BarDesc       = $p(aInputStr,aSeparete,6)    			/// 消毒包名称
	Quit:BarDesc="" return
	Set BarNote       = $p(aInputStr,aSeparete,7)    			/// 消毒器械说明
	Set BarLocID      = $P($p(aInputStr,aSeparete,8),"|",1)    	/// 绑定科室（消毒器械使用科室）
	Quit:BarLocID="" return	
	Set BatchNumberC  = $p(aInputStr,aSeparete,9)  				/// 清洗批次
	Set CleanDate     = $p($p(aInputStr,aSeparete,10)," ",1)   	/// 清洗日期
	Set CleanTime     = $p($p(aInputStr,aSeparete,10)," ",2)   	/// 清洗时间
	Set CleanUser     = $p(aInputStr,aSeparete,11)   			/// 清洗人（ID|Code|Desc）
	Set DispDate      = $p($p(aInputStr,aSeparete,12)," ",1)   	/// 配包日期
	Set DispTime      = $p($p(aInputStr,aSeparete,12)," ",2)   	/// 配包时间
	Set DispUser      = $p(aInputStr,aSeparete,13)   			/// 配包人（ID|Code|Desc）
	Set BatchNumberS  = $p(aInputStr,aSeparete,14)   			/// 灭菌批次
	Set CSSDBatchG    = $p(aInputStr,aSeparete,15)   			/// 灭菌锅次
	Set SterilDate    = $p($p(aInputStr,aSeparete,16)," ",1)   	/// 灭菌日期
	Set SterilTime    = $p($p(aInputStr,aSeparete,16)," ",2)   	/// 灭菌时间
	Set SterilUser    = $p(aInputStr,aSeparete,17)   			/// 灭菌人（ID|Code|Desc）
	Set SterilYsUser  = $p(aInputStr,aSeparete,18)   			/// 灭菌验收人（ID|Code|Desc）
	Set SterilYxqDate = $p($p(aInputStr,aSeparete,19)," ",1)  	/// 灭菌有效期至-日期 			
	Set SterilYxqTime = $p($p(aInputStr,aSeparete,19)," ",2)	/// 灭菌有效期至-时间
	Set SendDate      = $p($p(aInputStr,aSeparete,20)," ",1)   	/// 发放日期
	Set SendTime      = $p($p(aInputStr,aSeparete,20)," ",2)   	/// 发放时间
	Set SendUser      = $p(aInputStr,aSeparete,21)   			/// 发放人（ID|Code|Desc）	
	Set ReceptDate    = $p($p(aInputStr,aSeparete,22)," ",1)   	/// 使用(手术)日期
	Set ReceptTime    = $p($p(aInputStr,aSeparete,22)," ",2)   	/// 使用(手术)时间
	Set ReceptUser    = $p(aInputStr,aSeparete,23)   			/// 手术医生（ID|Code|Desc）
	Set ReceptHsUser  = $p(aInputStr,aSeparete,24)   			/// 器械护士（ID|Code|Desc）
	Set OperLoc       = $p(aInputStr,aSeparete,25)   			/// 手术室
	Set OperBed       = $p(aInputStr,aSeparete,26)   			/// 手术房间号
	//Set InfDiagnos    = $p(aInputStr,aSeparete,27)   			/// 感染名称	
	Set BackDate      = $p($p(aInputStr,aSeparete,27)," ",1)  	/// 回收日期
	Set BackTime      = $p($p(aInputStr,aSeparete,27)," ",2)  	/// 回收时间
	Set BackUser      = $p(aInputStr,aSeparete,28)_"|"_$p(aInputStr,aSeparete,29)  			/// 回收人

	Set SCode         = "CSSD01"   								/// 子系统代码
	Set XCode         = 1  										/// 记录索引码
	Set IsActive      = 1  										/// 有效标志
	//日期时间转化
	Set:SendDate'="" SendDate =##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SendDate)		/// 发放日期
	Set:SendTime'="" SendTime =##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(SendTime)   		/// 发放时间
	Set:DispDate'="" DispDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DispDate)			/// 配包日期
	Set:DispTime'="" DispTime =##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(DispTime)		/// 配包时间
	Set:ReceptDate'="" ReceptDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ReceptDate) /// 使用(手术)日期
	Set:ReceptTime'="" ReceptTime = ##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(ReceptTime) /// 使用(手术)时间
	Set:CleanDate'="" CleanDate =##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CleanDate)  	/// 清洗日期
	Set:CleanTime'="" CleanTime = ##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(CleanTime) 	/// 清洗时间
	Set:SterilDate'="" SterilDate =##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SterilDate)  /// 灭菌日期
	Set:SterilTime'="" SterilTime =##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(SterilTime) 	/// 灭菌时间
	Set:SterilYxqDate'="" SterilYxqDate =##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SterilYxqDate)  	///灭菌有效期至-日期 			
	Set:SterilYxqTime'="" SterilYxqTime = ##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(SterilYxqTime)	///灭菌有效期至-时间
	Set:BackDate'="" BackDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(BackDate)  					/// 回收日期
	Set:BackTime'="" BackTime = ##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(BackTime)  					/// 回收时间
	Set UpdateDate = $p($h,",",1)    // $zdh(CleanDate,3)   			更新日期
	Set UpdateTime = $p($h,",",2)   // $zth(CleanTime,1)   			 	更新时间
	//转换为院感科室ID
	//##class(DHCHAI.BT.Location).GetObjById(BarLocID)	
	Set OLocDr=##class(DHCHAI.BT.Location).GetObjByXCode("HIS01",BarLocID)		//根据科室号返回科室对象
	Quit:'$Isobject(OLocDr) return
	Set obj.CSSDEpisodeDr        = EpisodeDr
	Set obj.CSSDBarCode          = BarCode
	Set obj.CSSDDesc             = BarDesc

	Set obj.CSSDNote             = BarNote
	Set obj.CSSDLocDr            = OLocDr
	Set obj.CSSDBatchNumberC     = BatchNumberC
	Set obj.CSSDCleanDate        = CleanDate
	Set obj.CSSDCleanTime        = CleanTime
	Set obj.CSSDCleanUser        = CleanUser
	Set obj.CSSDDispUser         = DispUser
	Set obj.CSSDDispDate         = DispDate
	Set obj.CSSDDispTime         = DispTime
	Set obj.CSSDBatchNumberS     = BatchNumberS
	Set obj.CSSDBatchG           = CSSDBatchG
	Set obj.CSSDSterilDate       = SterilDate
	Set obj.CSSDSterilTime       = SterilTime
	Set obj.CSSDSterilUser       = SterilUser
	Set obj.CSSDSterilYsUser     = SterilYsUser
	Set obj.CSSDSterilYxqDate    = SterilYxqDate
	Set obj.CSSDSterilYxqTime    = SterilYxqTime
	Set obj.CSSDSendDate         = SendDate
	Set obj.CSSDSendTime         = SendTime
	Set obj.CSSDSendUser         = SendUser
	Set obj.CSSDReceptDate       = ReceptDate 
	Set obj.CSSDReceptTime       = ReceptTime
	Set obj.CSSDReceptUser       = ReceptUser
	Set obj.CSSDReceptHsUser     = ReceptHsUser
	Set obj.CSSDOperLoc          = OperLoc
	Set obj.CSSDOperBed          = OperBed
	//Set obj.CSSDInfDiagnos       = InfDiagnos
	Set obj.CSSDBackDate         = BackDate
	Set obj.CSSDBackTime         = BackTime
	Set obj.CSSDBackUser         = BackUser
	Set obj.CSSDIsActive         = IsActive
	Set obj.CSSDSCode            = SCode
	Set obj.CSSDUpdateDate       = UpdateDate
	Set obj.CSSDUpdateTime       = UpdateTime 
	Set obj.CSSDXCode            = XCode
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc){   	//检查Save是否成功     
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}
	Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2019-07-25
/// Description:  删除消毒供应中心信息
/// Table：       DHCHAI.BT.Config
/// Input：       aId : DHCHAI.BT.Config.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.CSSDRecord).DeleteById(16)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.CSSDRecord).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2019-07-28
/// Description:  根据患者就诊记录和消毒条码取用户信息
/// Table：       DHCHAI.DP.CSSDRecord
/// Input：       aEpisodeDr(就诊号),aCSSDBarCode(消毒包)
/// Return：      返回obj
/// w ##class(DHCHAI.DP.CSSDRecord).GetIDByCode("48","001002001000046")
ClassMethod GetIDByCode(PatientID As %String, aCSSDBarCode As %String) As DHCHAI.DP.CSSDRecord
{
	New (PatientID,aCSSDBarCode)
	Set return = ""
	Quit:((PatientID="")||(aCSSDBarCode="")) return
	Set Id=0
	Set Id=$o(^DHCHAI.DP.CSSDRecordI("IndexEpisode",PatientID,aCSSDBarCode,Id))
	quit:Id="" return
	Quit Id
}

Storage Default
{
<Data name="CSSDRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CSSDBarCode</Value>
</Value>
<Value name="4">
<Value>CSSDDesc</Value>
</Value>
<Value name="5">
<Value>CSSDNote</Value>
</Value>
<Value name="6">
<Value>CSSDLocDr</Value>
</Value>
<Value name="7">
<Value>CSSDBatchNumberC</Value>
</Value>
<Value name="8">
<Value>CSSDCleanDate</Value>
</Value>
<Value name="9">
<Value>CSSDCleanTime</Value>
</Value>
<Value name="10">
<Value>CSSDCleanUser</Value>
</Value>
<Value name="11">
<Value>CSSDBatchNumberS</Value>
</Value>
<Value name="12">
<Value>CSSDSterilDate</Value>
</Value>
<Value name="13">
<Value>CSSDSterilTime</Value>
</Value>
<Value name="14">
<Value>CSSDSterilUser</Value>
</Value>
<Value name="15">
<Value>CSSDSendDate</Value>
</Value>
<Value name="16">
<Value>CSSDSendTime</Value>
</Value>
<Value name="17">
<Value>CSSDSendUser</Value>
</Value>
<Value name="18">
<Value>CSSDReceptDate</Value>
</Value>
<Value name="19">
<Value>CSSDReceptTime</Value>
</Value>
<Value name="20">
<Value>CSSDReceptUser</Value>
</Value>
<Value name="21">
<Value>CSSDSCode</Value>
</Value>
<Value name="22">
<Value>CSSDXCode</Value>
</Value>
<Value name="23">
<Value>CSSDIsActive</Value>
</Value>
<Value name="24">
<Value>CSSDUpdateDate</Value>
</Value>
<Value name="25">
<Value>CSSDUpdateTime</Value>
</Value>
<Value name="26">
<Value>CSSDDispUser</Value>
</Value>
<Value name="27">
<Value>CSSDDispDate</Value>
</Value>
<Value name="28">
<Value>CSSDDispTime</Value>
</Value>
<Value name="29">
<Value>CSSDBatchG</Value>
</Value>
<Value name="30">
<Value>CSSDSterilYsUser</Value>
</Value>
<Value name="31">
<Value>CSSDSterilYxqDate</Value>
</Value>
<Value name="32">
<Value>CSSDSterilYxqTime</Value>
</Value>
<Value name="33">
<Value>CSSDReceptHsUser</Value>
</Value>
<Value name="34">
<Value>CSSDOperBed</Value>
</Value>
<Value name="35">
<Value>CSSDOperLoc</Value>
</Value>
<Value name="36">
<Value>CSSDInfDiagnos</Value>
</Value>
<Value name="37">
<Value>CSSDBackDate</Value>
</Value>
<Value name="38">
<Value>CSSDBackTime</Value>
</Value>
<Value name="39">
<Value>CSSDBackUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.CSSDRecordD</DataLocation>
<DefaultData>CSSDRecordDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.CSSDRecordD</IdLocation>
<IndexLocation>^DHCHAI.DP.CSSDRecordI</IndexLocation>
<StreamLocation>^DHCHAI.DP.CSSDRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
