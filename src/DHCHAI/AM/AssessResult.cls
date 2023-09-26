/// 名称: DHCHAI.AM.AssessResult
/// 描述: 疑似病例筛查评估结果
/// 编写者：zhufei
/// 编写日期: 2019-03-13
Class DHCHAI.AM.AssessResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 评估模型代码
Property ARModelDr As DHCHAI.AM.AssessModel;

/// 就诊号
Property AREpisodeDr As DHCHAI.DP.PAAdm;

/// 是否有效
Property ARIsActive As %Boolean;

/// 1疑似病例、2自报感染、3疑似社区感染
Property ARInfType As %Integer;

/// 疑似筛查结果
Property ARSusResult As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 疑似感染诊断/部位
Property ARSusDiagnos As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 状态（-1未处置、0排除、1确诊、2自报）
Property ARStatus As %Integer;

/// 确诊日期
Property ARDiagDate As %Date;

/// 诊断依据（感染日期、感染部位/诊断）、排除依据
Property ARDiagNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 处置日期
Property ARRstDate As %Date;

/// 处置时间
Property ARRstTime As %Time;

/// 处置人
Property ARRstUserDr As DHCHAI.BT.SysUser;

/// 患者类型 （感染疑似TP、感染非疑似FN、疑似非感染FP、非疑似感染TN）-整体
Property ARSuMatrix As %String;

/// 触发规则-处置操作（A-1/B-0/C-2/D-1/...）
Property ARSuRuleDtl As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 评估模型+就诊 索引
Index IdxofModelEpis On (ARModelDr, AREpisodeDr);

/// 评估模型+就诊+状态 索引
Index IdxofModelEpisStatus On (ARModelDr, AREpisodeDr, ARStatus);

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  根据ID取评估结果信息
/// Table：       DHCHAI.AM.AssessResult
/// Input：       aId : DHCHAI.AM.AssessResult.ID
/// Return：      返回obj
/// w ##class(DHCHAI.AM.AssessResult).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.AM.AssessResult
{
	New (aId)
	Quit:'##class(DHCHAI.AM.AssessResult).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.AM.AssessResult).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  更新评估结果信息
/// Table：       DHCHAI.AM.AssessResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessResult).Update("^2^1^1^1^^^0^^^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set ModelDr	   = $p(aInputStr,aSeparete,2)
	Set EpisodeDr  = $p(aInputStr,aSeparete,3)
	Set IsActive   = +$p(aInputStr,aSeparete,4)
	Set InfType	   = +$p(aInputStr,aSeparete,5)
	Set SusResult  = $p(aInputStr,aSeparete,6)
	Set SusDiagnos = $p(aInputStr,aSeparete,7)
	Set Status	   = +$p(aInputStr,aSeparete,8)
	Set DiagDate   = $p(aInputStr,aSeparete,9)
	Set DiagNote   = $p(aInputStr,aSeparete,10)
	Set RstDate	   = $p(aInputStr,aSeparete,11)
	Set RstTime	   = $p(aInputStr,aSeparete,12)
	Set RstUserDr  = $p(aInputStr,aSeparete,13)
	Set SuMatrix   = $p(aInputStr,aSeparete,14)
	Set SuRuleDtl  = $p(aInputStr,aSeparete,15)
	
	Quit:(ModelDr="")||(EpisodeDr="") return
	
	Set DiagNote=$tr(DiagNote,$c(10),";")
	
	Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(ModelDr)
	Quit:'$IsObject(objModel) return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set objRstUser=##class(DHCHAI.BT.SysUser).GetObjById(RstUserDr)
	
	Set:DiagDate'="" DiagDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DiagDate)
	Set:RstDate'="" RstDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RstDate)
	Set:RstTime[":" RstTime=$zth(RstTime,1)
	
	Set tID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelDr,EpisodeDr,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.AM.AssessResult).%New()
	}Else{
		Set obj=##class(DHCHAI.AM.AssessResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ARModelDr	= objModel   //评估模型代码
	Set obj.AREpisodeDr	= objEpisode //就诊号
	Set obj.ARIsActive	= IsActive   //是否有效
	Set obj.ARInfType	= InfType    //1疑似病例、2自报感染、3疑似社区感染
	Set obj.ARSusResult = SusResult  //疑似筛查结果
	Set obj.ARSusDiagnos= SusDiagnos //疑似感染诊断/部位
	Set obj.ARStatus	= Status     //状态（-1未处置、0排除、1确诊、2自报）
	Set obj.ARDiagDate	= DiagDate   //确诊日期
	Set obj.ARDiagNote	= DiagNote   //诊断依据、排除依据
	Set obj.ARRstDate	= RstDate    //处置日期
	Set obj.ARRstTime	= RstTime    //处置时间
	Set obj.ARRstUserDr	= objRstUser //处置人
	Set obj.ARSuMatrix  = SuMatrix
	Set obj.ARSuRuleDtl = SuRuleDtl
	
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

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  更新评估结果是否有效标记
/// Table：       DHCHAI.AM.AssessResult
/// Input：       ID ：评估记录ID
///               IsActive : 是否有效
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessResult).SetResultAct()
ClassMethod SetResultAct(aID As %String, aIsActive As %String) As %String
{
	New (aID,aIsActive)
	Set return=0
	Quit:(aID="")||(aIsActive="") return
	
	Set obj=##class(DHCHAI.AM.AssessResult).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Set obj.ARIsActive	= aIsActive   //是否有效
	
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

/// Creator：     pylian
/// CreatDate：   2019-03-19
/// Description:  处置评估记录
/// Table：       DHCHAI.AM.AssessResult
/// Input：       aInputStr ：字符串
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessResult).ChangeStatus()
ClassMethod ChangeStatus(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="") return
	
	Set aID = $p(aInputStr,aSeparete,1)
	Set aStatus = $p(aInputStr,aSeparete,2)
	Set aDiagDate = $p(aInputStr,aSeparete,3)
	Set aDiagNote = $p(aInputStr,aSeparete,4)
	Set aUserID = $p(aInputStr,aSeparete,5)
	Set obj=##class(DHCHAI.AM.AssessResult).%OpenId(aID)
	Quit:'$IsObject(obj) return
	
	Set objRstUser=##class(DHCHAI.BT.SysUser).GetObjById(aUserID)
	Set:aDiagDate'="" aDiagDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDiagDate)
	Set obj.ARStatus	= aStatus     //状态（-1未处置、0排除、1确诊、2自报）
	Set obj.ARDiagDate	= aDiagDate   //确诊日期
	Set obj.ARDiagNote	= aDiagNote   //诊断依据、排除依据
	Set obj.ARRstDate	= +$h    //处置日期
	Set obj.ARRstTime	= $p($h,",",2)    //处置时间
	Set obj.ARRstUserDr	= objRstUser //处置人
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

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  删除评估结果信息
/// Table：       DHCHAI.AM.AssessResult
/// Input：       aId : DHCHAI.AM.AssessResult.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessResult).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.AM.AssessResult).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="AssessResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARModelDr</Value>
</Value>
<Value name="3">
<Value>AREpisodeDr</Value>
</Value>
<Value name="4">
<Value>ARIsActive</Value>
</Value>
<Value name="5">
<Value>ARInfType</Value>
</Value>
<Value name="6">
<Value>ARSusResult</Value>
</Value>
<Value name="7">
<Value>ARSusDiagnos</Value>
</Value>
<Value name="8">
<Value>ARStatus</Value>
</Value>
<Value name="9">
<Value>ARDiagDate</Value>
</Value>
<Value name="10">
<Value>ARDiagNote</Value>
</Value>
<Value name="11">
<Value>ARRstDate</Value>
</Value>
<Value name="12">
<Value>ARRstTime</Value>
</Value>
<Value name="13">
<Value>ARRstUserDr</Value>
</Value>
<Value name="14">
<Value>ARSuMatrix</Value>
</Value>
<Value name="15">
<Value>ARSuRuleDtl</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.AM.AssessResultD</DataLocation>
<DefaultData>AssessResultDefaultData</DefaultData>
<IdLocation>^DHCHAI.AM.AssessResultD</IdLocation>
<IndexLocation>^DHCHAI.AM.AssessResultI</IndexLocation>
<StreamLocation>^DHCHAI.AM.AssessResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
