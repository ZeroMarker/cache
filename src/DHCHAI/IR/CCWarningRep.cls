/// 名称: DHCHAI.IR.CCWarningRep
/// 描述: 暴发预警表()的业务封装，定义常用属性和方法
/// 编写者：zhangqy
/// 编写日期: 2020-11-24
Class DHCHAI.IR.CCWarningRep Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告状态(初次报告，订正报告)
Property CWPRepStatus As %String;

/// 暴发科室ID
Property CWPLocDr As DHCHAI.BT.Location;

/// 预警项目
Property IRWarnItem As %String;

/// 开始日期
Property CWPStartDate As %Date;

/// 结束日期
Property CWPEndDate As %Date;

/// 发生地点(医院/妇幼保健院)
Property CWPHappenHos As DHCHAI.BT.Hospital;

/// 发生地点(科室病区)
Property CWPHappenLoc As DHCHAI.BT.Location;

/// 感染初步诊断("")
Property CWPPreINFDiag As %String;

/// 医院感染诊断("")
Property CWPINFDiagDr As DHCHAI.BT.InfPos;

/// 可能病原体
Property CWPMayPathogenDr As DHCHAI.DP.LabBacteria;

/// 医院感染病原体
Property CWPPathogenDr As DHCHAI.DP.LabBacteria;

/// 累计患者数___例
Property CWPCumPat As %String;

/// 感染患者数___例
Property CWPInfPat As %String;

/// 患者感染愈后情况
/// 痊愈
Property CWPCure As %String;

/// 正在治疗
Property CWPUnderTreat As %String;

/// 病危
Property CWPCritically As %String;

/// 死亡
Property CWPDeath As %String;

/// 可能传播的途径
Property CWPMayTrans As %String;

/// 传播的途径
Property CWPTrans As %String;

/// 可能感染源
Property CWPMaySource As %String;

/// 感染源
Property CWPSource As %String;

/// 感染患者主要相同临床症状
Property CWPSameSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院环境 卫生学主要监测结果
Property CWPHygiene As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染患者主要影像学检查结果(X光、CT、MRI.B超)
Property CWPImaging As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染患者主要病原学检查结果(涂片革兰染色、培养、病毒检测结果、血清学检查结果、同源性检查结果）
Property CWPEtiology As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 暴发的详细描述
Property CWPDetaiDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 报告科室
Property CWPLoc As %String;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新人
Property UpdateUser As %String;

/// 以开始日期为索引
Index IndexStartDate On CWPStartDate;

/// 以报告状态为索引
Index IndexRepStatus On CWPRepStatus;

/// 科室ID+日期索引
Index IndexRepLocDate On (CWPLocDr As Exact, UpdateDate);

/// 唯一索引预警科室+预警日期+项目索引
Index IndexWarnLocDateItem On (CWPLocDr As Exact, UpdateDate, IRWarnItem As Exact);

/// Creator：     zhangqy
/// CreatDate：   2020-11-24
/// Description:  根据ID取暴发预警报告
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       aId : DHCHAI.IR.CCWarningRep.id
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCWarningRep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCWarningRep
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCWarningRep).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCWarningRep).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangqy
/// CreatDate：   2021-1-24
/// Description:  根据ID取暴发预警项目
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       aId : DHCHAI.IR.CCWarningRep.id
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCWarningRep).GetWarnItemById(4)
ClassMethod GetWarnItemById(aId As %String) As %String
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCWarningRep).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCWarningRep).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj.IRWarnItem
}

/// Creator：     zhangqy
/// CreatDate：   2020-11-24
/// Description:  更新暴发预警报告
/// Table：       DHCHAI.IR.CCWarningRep
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCWarningRep).Update("^1^2021-04-01^^1^111^我认为二^^2^^^^^^^^690,691^696,697^^^^^^^^医务部^medmanager^2021-04-07^111^气管炎、支气管炎","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID           	= $p(aInputStr,aSeparete,1)
	Set RepStatus	    = $p(aInputStr,aSeparete,2)
	Set StartDate     	= $p(aInputStr,aSeparete,3)
	Set EndDate      	= $p(aInputStr,aSeparete,4)
	Set HappenHos   	= $p(aInputStr,aSeparete,5)
	Set HappenLoc		= $p(aInputStr,aSeparete,6)
	Set PreINFDiag		= $p(aInputStr,aSeparete,7)
	Set INFDiagDr		= $p(aInputStr,aSeparete,8)
	Set MayPathogenDr	= $p(aInputStr,aSeparete,9)
	Set PathogenDr		= $p(aInputStr,aSeparete,10)
	Set CumPat			= $p(aInputStr,aSeparete,11)
	Set InfPat			= $p(aInputStr,aSeparete,12)
	Set Cure			= $p(aInputStr,aSeparete,13)
	Set UnderTreat		= $p(aInputStr,aSeparete,14)
	Set Critically		= $p(aInputStr,aSeparete,15)
	Set Death			= $p(aInputStr,aSeparete,16)
	Set MayTransDr		= $p(aInputStr,aSeparete,17)
	Set MaySourceDr		= $p(aInputStr,aSeparete,18)
	Set Trans   		= $p(aInputStr,aSeparete,19)
	Set Source   		= $p(aInputStr,aSeparete,20)
	Set SameSymptom 	= $p(aInputStr,aSeparete,21)
	Set Hygiene   		= $p(aInputStr,aSeparete,22)
	Set Imaging 		= $p(aInputStr,aSeparete,23)
	Set Etiology   		= $p(aInputStr,aSeparete,24)
	Set DetaiDesc 		= $p(aInputStr,aSeparete,25)
	Set UpdateLoc 		= $p(aInputStr,aSeparete,26)
	Set UpdateUser 		= $p(aInputStr,aSeparete,27)
	Set UpdateDate   	= $p(aInputStr,aSeparete,28)
	Set LocID			= $p(aInputStr,aSeparete,29)
	Set WarnItem		= $p(aInputStr,aSeparete,30)
	Set UpdateTime 		= $p($h,",",2)
	Set:UpdateDate="" UpdateDate=+$h
   
	Set objINFDiag 		=##class(DHCHAI.BT.InfPos).GetObjById(INFDiagDr)
	Set objMayPathogen 	=##class(DHCHAI.DP.LabBacteria).GetObjById(MayPathogenDr)
	Set objPathogen 	=##class(DHCHAI.DP.LabBacteria).GetObjById(PathogenDr)
	Set:StartDate'="" StartDate	= ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(StartDate)
	Set:EndDate'="" EndDate	= ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:HappenHos'="" objHappenHos = ##class(DHCHAI.BT.Hospital).GetObjById(HappenHos)
	Set:HappenLoc'="" objHappenLoc = ##class(DHCHAI.BT.Location).GetObjById(HappenLoc)
	Set objLocID = ##class(DHCHAI.BT.Location).GetObjById(LocID)
	Quit:'$IsObject(objLocID) return
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCWarningRep).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCWarningRep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return


	Set obj.CWPRepStatus 		= RepStatus
	Set obj.CWPStartDate 		= StartDate
	Set obj.CWPEndDate 			= EndDate
	Set obj.CWPHappenHos 		= objHappenHos
	Set obj.CWPHappenLoc 		= objHappenLoc
	Set obj.CWPPreINFDiag 		= PreINFDiag
	Set obj.CWPINFDiagDr 		= objINFDiag
	Set obj.CWPMayPathogenDr 	= objMayPathogen
	Set obj.CWPPathogenDr 		= objPathogen
	Set obj.CWPCumPat 			= CumPat
	Set obj.CWPInfPat 			= InfPat
	Set obj.CWPCure 			= Cure
	Set obj.CWPUnderTreat 		= UnderTreat
	Set obj.CWPCritically 		= Critically
	Set obj.CWPDeath 			= Death
	Set obj.CWPMayTrans 		= MayTransDr
	Set obj.CWPTrans 			= Trans
	Set obj.CWPMaySource 		= MaySourceDr
	Set obj.CWPSource 			= Source
	Set obj.CWPSameSymptom 		= SameSymptom
	Set obj.CWPHygiene 			= Hygiene
	Set obj.CWPImaging 			= Imaging
	Set obj.CWPEtiology 		= Etiology
	Set obj.CWPDetaiDesc 		= DetaiDesc
	Set obj.UpdateDate 			= UpdateDate
	Set obj.UpdateTime 			= UpdateTime
	Set obj.UpdateUser 			= UpdateUser
	Set obj.CWPLoc				= UpdateLoc
	Set obj.CWPLocDr			= objLocID
	Set obj.IRWarnItem			= WarnItem

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

/// Creator：     zhangqy
/// CreatDate：   2020-11-24
/// Description:  删除
/// Table：       DHCHAI.IR.CCWarningRep
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCWarningRep).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	new (Id)
	set sc = ##class(DHCHAI.IR.CCWarningRep).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator:	zhangqy			
/// CreatDate:	2020-11-24
/// Description:根据Id取字符串 
/// w ##class(DHCHAI.IR.CCWarningRep).GetStringById(4)
ClassMethod GetStringById(aId As %String) As %String
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set obj=##class(DHCHAI.IR.CCWarningRep).GetObjById(aId)
	Set:$IsObject(obj) return=obj.ToString("^")
	Quit return
}

/// Creator:	zhangqy
/// CreatDate:	2020-11-26
/// Description:
/// Method: DHCHAI.IR.CCWarningRep.GetStringById
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	Set return=return_separete_..CWPRepStatus
	if ($IsObject(..CWPLocDr)){
		Set return=return_separete_..CWPLocDr.%Id()
		Set return=return_separete_..CWPLocDr.BTDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	if (..CWPStartDate'=""){
		Set return=return_separete_$zd(..CWPStartDate,3)
	}else {
		Set return=return_separete_""	
	}
	if (..CWPEndDate'=""){
		Set return=return_separete_$zd(..CWPEndDate,3)
	}else {
		Set return=return_separete_""	
	}
	if ($IsObject(..CWPHappenHos)){
		Set return=return_separete_..CWPHappenHos.%Id()
		Set return=return_separete_..CWPHappenHos.BTDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	if ($IsObject(..CWPHappenLoc)){
		Set return=return_separete_..CWPHappenLoc.%Id()
		Set return=return_separete_..CWPHappenLoc.BTDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	Set return=return_separete_..CWPPreINFDiag
	if ($IsObject(..CWPINFDiagDr)){
		Set return=return_separete_..CWPINFDiagDr.%Id()
		Set return=return_separete_..CWPINFDiagDr.BTDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	if ($IsObject(..CWPMayPathogenDr)){
		Set return=return_separete_..CWPMayPathogenDr.%Id()
		Set return=return_separete_..CWPMayPathogenDr.BTBacDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	if ($IsObject(..CWPPathogenDr)){
		Set return=return_separete_..CWPPathogenDr.%Id()
		Set return=return_separete_..CWPPathogenDr.BTBacDesc
	}else{
		Set return=return_separete_""
		Set return=return_separete_""
	}
	Set return=return_separete_..CWPCumPat
	Set return=return_separete_..CWPInfPat
	Set return=return_separete_..CWPCure
	Set return=return_separete_..CWPUnderTreat	
	Set return=return_separete_..CWPCritically
	Set return=return_separete_..CWPDeath
	Set return=return_separete_..CWPMayTrans
	Set return=return_separete_..CWPTrans
	Set return=return_separete_..CWPMaySource
	Set return=return_separete_..CWPSource
	Set return=return_separete_..CWPSameSymptom
	Set return=return_separete_..CWPHygiene
	Set return=return_separete_..CWPImaging
	Set return=return_separete_..CWPEtiology
	Set return=return_separete_..CWPDetaiDesc
	Set return=return_separete_..CWPLoc
	Set return=return_separete_$zd(..UpdateDate,3)
	Set return=return_separete_..UpdateTime
	Set return=return_separete_..UpdateUser

	Quit return
}

Storage Default
{
<Data name="CCWarningRepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CWPRepStatus</Value>
</Value>
<Value name="3">
<Value>CWPStartDate</Value>
</Value>
<Value name="4">
<Value>CWPEndDate</Value>
</Value>
<Value name="5">
<Value>CWPHappenHos</Value>
</Value>
<Value name="6">
<Value>CWPHappenLoc</Value>
</Value>
<Value name="7">
<Value>CWPPreINFDiagDr</Value>
</Value>
<Value name="8">
<Value>CWPINFDiagDr</Value>
</Value>
<Value name="9">
<Value>CWPMayPathogenDr</Value>
</Value>
<Value name="10">
<Value>CWPPathogenDr</Value>
</Value>
<Value name="11">
<Value>CWPCumPat</Value>
</Value>
<Value name="12">
<Value>CWPInfPat</Value>
</Value>
<Value name="13">
<Value>CWPCure</Value>
</Value>
<Value name="14">
<Value>CWPUnderTreat</Value>
</Value>
<Value name="15">
<Value>CWPCritically</Value>
</Value>
<Value name="16">
<Value>CWPDeath</Value>
</Value>
<Value name="17">
<Value>CWPMayTransDr</Value>
</Value>
<Value name="18">
<Value>CWPTrans</Value>
</Value>
<Value name="19">
<Value>CWPMaySourceDr</Value>
</Value>
<Value name="20">
<Value>CWPSource</Value>
</Value>
<Value name="21">
<Value>CWPSameSymptom</Value>
</Value>
<Value name="22">
<Value>CWPHygiene</Value>
</Value>
<Value name="23">
<Value>CWPImaging</Value>
</Value>
<Value name="24">
<Value>CWPEtiology</Value>
</Value>
<Value name="25">
<Value>CWPDetaiDesc</Value>
</Value>
<Value name="26">
<Value>UpdateDate</Value>
</Value>
<Value name="27">
<Value>UpdateTime</Value>
</Value>
<Value name="28">
<Value>UpdateUserDr</Value>
</Value>
<Value name="29">
<Value>CWPLoc</Value>
</Value>
<Value name="30">
<Value>CWPPreINFDiag</Value>
</Value>
<Value name="31">
<Value>CWPLocID</Value>
</Value>
<Value name="32">
<Value>UpdateUser</Value>
</Value>
<Value name="33">
<Value>CWPMayTrans</Value>
</Value>
<Value name="34">
<Value>CWPMaySource</Value>
</Value>
<Value name="35">
<Value>CWPLocDr</Value>
</Value>
<Value name="36">
<Value>IRWarnItem</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCWarningRepD</DataLocation>
<DefaultData>CCWarningRepDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCWarningRepD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCWarningRepI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCWarningRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
