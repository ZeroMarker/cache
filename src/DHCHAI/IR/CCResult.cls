/// 名称: DHCHAI.IR.CCResult
/// 描述: 医院感染监测结果
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CCEpisodeDr As DHCHAI.DP.PAAdm;

/// 监控项目
Property CCItemDr As DHCHAI.IR.CCItmMast;

/// 监控结果（细菌名称、常规检验异常、医学影像异常、抗生素升级、体温持续异常、诊断名称、症状或体征）
Property CCResult As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 定性结果
Property CCTextRes As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 结果单位
Property CCUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生科室
Property CCActLocDr As DHCHAI.BT.Location;

/// 发生日期
Property CCActDate As %Date;

/// 发生时间
Property CCActTime As %Time;

/// 发生人
Property CCActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告（审核）日期
Property CCRepDate As %Date;

/// 报告（审核）时间
Property CCRepTime As %Time;

/// 报告（审核）人
Property CCRepUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property CCIsActive As %Boolean;

/// 更新日期
Property CCUpdateDate As %Date;

/// 更新时间
Property CCUpdateTime As %Time;

/// 子系统代码
Property CCSCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 业务指针（处理任务重复执行，保证数据唯一性）
Property CCObjectID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 附加参数值  格式："参数1=值1,参数2=值2"
Property CCParams As %String(MAXLEN = 500, TRUNCATE = 1);

/// 关键词
Property CCKeyWordDr As DHCHAI.IR.CCKeyWord;

/// 异常标志
Property CCIsAbFlag As %Boolean;

/// 标本（原始标本名称）
Property CCSpecimen As %String(MAXLEN = 100, TRUNCATE = 1);

/// 细菌（原始细菌名称）
Property CCBacteria As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐菌分类
Property CCMRBTpDr As DHCHAI.IR.CRuleMRB;

/// 抗菌用药等级（3特殊使用级、2限制使用级、1非限制使用级）
Property CCAntiGrade As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术日期
Property CCOperDate As %Date;

/// 手术切口
Property CCIncision As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗生素名称
Property CCAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 未结束标记（长期医嘱）
Property CCIsNotEnd As %Boolean;

/// 摘要信息
Property CCSummary As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 多耐菌分类2
Property CCMRBTp2Dr As DHCHAI.IR.CRuleMRB;

/// 多耐菌群   add 20230423
Property MultipleResChild As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊+项目+业务指针索引
Index IndexObjectID On (CCEpisodeDr, CCItemDr, CCSCode As Exact, CCObjectID As Exact);

/// 就诊索引
Index IndexEpisodeDr On CCEpisodeDr;

/// 更新日期时间索引
Index IndexUpdateDate On (CCUpdateDate, CCUpdateTime);

/// 发生日期+耐药菌分类
Index IndexMRBActDate On (CCActDate, CCMRBTpDr);

/// 检出菌索引
Index IndexItemDrBacteria On (CCEpisodeDr, CCItemDr, CCBacteria);

/// 异常标记索引
Index IndexItemDrIsAbFlag On (CCEpisodeDr, CCItemDr, CCIsAbFlag);

/// 关键词索引
Index IndexItemDrKeyWordDr On (CCEpisodeDr, CCItemDr, CCKeyWordDr);

/// 发生日期索引
Index IndexItemDrActDate On (CCEpisodeDr, CCItemDr, CCActDate);

/// 报告日期索引
Index IndexItemDrRepDate On (CCEpisodeDr, CCItemDr, CCRepDate);

/// 项目+发生日期索引
Index IndexItemActDate On (CCItemDr, CCActDate);

/// 项目+发生日期索引
Index IndexItemRepDate On (CCItemDr, CCRepDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  根据ID作废监控记录
/// Table：       DHCHAI.IR.CCResult
/// Input：       id:    DHCHAI.IR.CCResult.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCResult).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=0
	Quit:id="" return
	
	Set obj=##class(DHCHAI.IR.CCResult).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.CCIsActive		= 0
	Set obj.CCUpdateDate    = +$h
	Set obj.CCUpdateTime    = $p($h,",",2)
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取信息
/// Table：       DHCHAI.IR.CCResult
/// Input：       RowID    DHCHAI.IR.CCResult
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCResult).GetObjById()
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.CCResult
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.CCResultD(+RowId)) return
	set obj=##Class(DHCHAI.IR.CCResult).%OpenId(+RowId)
	if $IsObject(obj) {
		set obj=##class(DHCHAI.IRC.CtrlResultSrv).CheckResultAct(obj)
	}
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.CCResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCResult).Update("^1^1^1^1^2017-01-16^11:33^1^处置意见^1^2017-01-17^11:43^1^反馈意见","")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(InStr,aSeparete,1)
	Set EpisodeDr  = $p(InStr,aSeparete,2)
	Set ItemDr     = $p(InStr,aSeparete,3)
	Set Result     = $p(InStr,aSeparete,4)
	Set TextRes    = $p(InStr,aSeparete,5)
	Set Unit       = $p(InStr,aSeparete,6)
	Set ActLocDr   = $p(InStr,aSeparete,7)
	Set ActDate    = $p(InStr,aSeparete,8)
	Set ActTime    = $p(InStr,aSeparete,9)
	Set ActUser    = $p(InStr,aSeparete,10)
	Set RepDate    = $p(InStr,aSeparete,11) 
	Set RepTime    = $p(InStr,aSeparete,12)
	Set RepUser    = $p(InStr,aSeparete,13)
	Set IsActive   = +$p(InStr,aSeparete,14)
	Set UpdateDate = $p(InStr,aSeparete,15)
	Set UpdateTime = $p(InStr,aSeparete,16)
	Set SCode      = $p(InStr,aSeparete,17)
	Set ObjectID   = $p(InStr,aSeparete,18)
	Set Params     = $p(InStr,aSeparete,19)
	Set KeyWordDr  = $p(InStr,aSeparete,20)
	Set IsAbFlag   = $p(InStr,aSeparete,21)
	Set Specimen   = $p(InStr,aSeparete,22)
	Set Bacteria   = $p(InStr,aSeparete,23)
    Set MRBTpDr    = $p(InStr,aSeparete,24)
	Set AntiGrade  = $p(InStr,aSeparete,25)
	Set OperDate   = $p(InStr,aSeparete,26)
	Set Incision   = $p(InStr,aSeparete,27)
	Set AntiDesc   = $p(InStr,aSeparete,28)
	Set IsNotEnd   = $p(InStr,aSeparete,29)
	Set Summary    = $p(InStr,aSeparete,30)
	Set MRBTp2Dr   = $p(InStr,aSeparete,31)
	Set MultipleRes= $p(InStr,aSeparete,32)
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(ItemDr)
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(ActLocDr)
	Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(KeyWordDr)
	Set objMRBTp=##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBTpDr)
	Set objMRBTp2=##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBTp2Dr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	//Set:ActDate="" ActDate=+$h	 //对没有发生日期的项目不自动记为当前日期，便于问题查找
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	//Set:ActTime="" ActTime=$p($h,",",2)
	
	Set:RepDate'="" CCRepDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate)
	Set:RepTime[":" RepTime = $zth(RepTime,1)
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set:OperDate'="" OperDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(OperDate)
	
   	If ID="" {
		Set obj=##class(DHCHAI.IR.CCResult).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
    Set obj.CCEpisodeDr  = objAdm
	Set obj.CCItemDr     = objItmMast   
	Set obj.CCResult     = Result   
	Set obj.CCTextRes    = TextRes  
	Set obj.CCUnit       = Unit     
	Set obj.CCActLocDr   = objLoc 
	Set obj.CCActDate    = ActDate  
	Set obj.CCActTime    = ActTime  
	Set obj.CCActUser    = ActUser
	Set obj.CCRepDate    = RepDate  
	Set obj.CCRepTime    = RepTime  
	Set obj.CCRepUser    = RepUser
	Set obj.CCIsActive   = IsActive 
	Set obj.CCUpdateDate = UpdateDate
	Set obj.CCUpdateTime = UpdateTime
	Set obj.CCSCode      = SCode    
	Set obj.CCObjectID   = ObjectID 
	Set obj.CCParams     = Params   
	Set obj.CCKeyWordDr  = objKeyWord
	Set obj.CCIsAbFlag   = IsAbFlag 
	Set obj.CCSpecimen   = Specimen 
	Set obj.CCBacteria   = Bacteria 
    Set obj.CCMRBTpDr    = objMRBTp  
	Set obj.CCAntiGrade  = AntiGrade
	Set obj.CCOperDate   = OperDate
	Set obj.CCIncision   = Incision
	Set obj.CCAntiDesc   = AntiDesc
	Set obj.CCIsNotEnd   = IsNotEnd
	Set obj.CCSummary    = Summary
	Set obj.CCMRBTp2Dr   = objMRBTp2 
	Set obj.MultipleResChild = MultipleRes
	
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除
/// Table：       DHCHAI.IR.CCResult
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.CCResult).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="CCResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CCItemDr</Value>
</Value>
<Value name="4">
<Value>CCResult</Value>
</Value>
<Value name="5">
<Value>CCTextRes</Value>
</Value>
<Value name="6">
<Value>CCUnit</Value>
</Value>
<Value name="7">
<Value>CCActLocDr</Value>
</Value>
<Value name="8">
<Value>CCActDate</Value>
</Value>
<Value name="9">
<Value>CCActTime</Value>
</Value>
<Value name="10">
<Value>CCActUser</Value>
</Value>
<Value name="11">
<Value>CCRepDate</Value>
</Value>
<Value name="12">
<Value>CCRepTime</Value>
</Value>
<Value name="13">
<Value>CCRepUser</Value>
</Value>
<Value name="14">
<Value>CCIsActive</Value>
</Value>
<Value name="15">
<Value>CCUpdateDate</Value>
</Value>
<Value name="16">
<Value>CCUpdateTime</Value>
</Value>
<Value name="17">
<Value>CCSCode</Value>
</Value>
<Value name="18">
<Value>CCObjectID</Value>
</Value>
<Value name="19">
<Value>CCParams</Value>
</Value>
<Value name="20">
<Value>CCKeyWordDr</Value>
</Value>
<Value name="21">
<Value>CCIsAbFlag</Value>
</Value>
<Value name="22">
<Value>CCSpecimen</Value>
</Value>
<Value name="23">
<Value>CCBacteria</Value>
</Value>
<Value name="24">
<Value>CCMRBTpDr</Value>
</Value>
<Value name="25">
<Value>CCAntiGrade</Value>
</Value>
<Value name="26">
<Value>CCOperDate</Value>
</Value>
<Value name="27">
<Value>CCIncision</Value>
</Value>
<Value name="28">
<Value>CCAntiDesc</Value>
</Value>
<Value name="29">
<Value>CCIsNotEnd</Value>
</Value>
<Value name="30">
<Value>CCSummary</Value>
</Value>
<Value name="31">
<Value>CCMRBTp2Dr</Value>
</Value>
<Value name="32">
<Value>MultipleResChild</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCResultD</DataLocation>
<DefaultData>CCResultDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCResultD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCResultI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
