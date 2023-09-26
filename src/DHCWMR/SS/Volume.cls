/// 病案卷表
Class DHCWMR.SS.Volume Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildStatus As DHCWMR.SS.VolStatus [ Cardinality = children, Inverse = Parref ];

Relationship ChildPaadm As DHCWMR.SS.VolPaadm [ Cardinality = children, Inverse = Parref ];

/// 病案主表
Property SVMainDr As DHCWMR.SS.Main;

/// 当前状态
Property SVStatus As DHCWMR.SS.WorkItem;

/// 顺序步骤(在院A、归档D、上架S、临时C)
Property SVOrdStep As %String(MAXLEN = 100, TRUNCATE = 1);

/// 质控锁定(纸张病历1、电子病历2、解除锁定0)
Property SVQCLock As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否被借阅(是1、否0)
Property SVIsLend As %Boolean;

/// 是否被复印(是1、否0)
Property SVIsCopy As %Boolean;

/// 是否被封存(是1、否0)
Property SVIsStore As %Boolean;

/// 出院日期
Property SVDischDate As %Date;

/// 回收日期
Property SVBackDate As %Date;

/// 第几次住院
Property SVIPTimes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 卷条码号（默认为卷ID，历史数据特殊处理）
Property SVBarcode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 创建日期
Property SVBuildDate As %Date;

/// 创建时间
Property SVBuildTime As %Time;

/// 是否有效
Property SVIsActive As %Boolean;

/// 备注
Property SVResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否存在纸质病历
Property SVIsExPaper As %Boolean;

/// 病案主记录索引
Index IndexSVMainDr On SVMainDr;

/// 卷当前状态索引
Index IndexSVStatus On SVStatus;

/// 病案主记录+是否有效索引
Index IndexMainDrAct On (SVMainDr, SVIsActive);

/// 顺序步骤索引
Index IndexOrdStep On SVOrdStep;

/// 质控锁定索引
Index IndexQCLock On SVQCLock;

/// 出院病历查询
Index IndexDischDate On (SVOrdStep, SVDischDate);

/// 创建病历查询
Index IndexBuildDate On (SVOrdStep, SVBuildDate);

/// 卷条码索引
Index IndexBarcodeAct On (SVBarcode, SVIsActive);

/// Creator:          李阳
/// CreateDate:       2014-08-22
/// Description:      根据ID取病案卷信息
/// OperationTable:   DHCWMR.SS.Volume
/// Input:            Id : DHCWMR.SS.Volume.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.SS.Volume).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Volume
{
	new (aId)
	quit:'##class(DHCWMR.SS.Volume).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Volume).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-03-31
/// Description:  根据PatientID,MrTypeID取病案卷
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       aPatientID : 病人ID
/// 			  aMrTypeID : DHCWMR.SS.MrType.ID
/// return：	  DHCWMR.SS.Volume
/// w ##class(DHCWMR.SS.Volume).GetObjByPatID("",6)
ClassMethod GetObjByPatID(aPatientID As %String, aMrTypeID As %String) As DHCWMR.SS.Volume
{
	New (aPatientID,aMrTypeID)
	Set return=""
	Quit:(aPatientID="")||(aMrTypeID="") return
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID))
		Quit:xVolID=""
		Quit:return'=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:((aMrTypeID'="")&&(aMrTypeID'=objVol.SVMainDr.SMMrType.%Id()))
		
		Set return=objVol
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  根据EpisodeID取病案卷
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        EpisodeID ：就诊号
/// Output:       返回String
/// w ##Class(DHCWMR.SS.Volume).GetObjByPaadm(5920325)
ClassMethod GetObjByPaadm(aEpisodeID As %String) As DHCWMR.SS.Volume
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//退院或取消就诊状态
	Set VisitStatus=$p($g(^PAADM(aEpisodeID)),"^",20)
	Quit:VisitStatus="C" return
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
		Quit:xVolID=""
		Quit:return'=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Set return=objVol
	}
	
	Quit return
}

/// Creator:          zhufei
/// CreateDate:       2014-09-18
/// Description:      取病案卷当前就诊号
/// OperationTable:   DHCWMR.SS.VolPaadm
/// Input:            Id : DHCWMR.SS.Volume.ID
/// Output:           返回String
/// w ##Class(DHCWMR.SS.Volume).GetEpisodeID(1)
ClassMethod GetEpisodeID(aVolID As %String) As %String
{
	New (aVolID)
	Set return=""
	Quit:aVolID="" return
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set return=EpisodeID
	Quit return
}

/// Creator:          zhufei
/// CreateDate:       2015-03-29
/// Description:      取病案卷顺序流操作时间
/// OperationTable:   DHCWMR.SS.VolStatus
/// Input:            VolID : DHCWMR.SS.Volume.ID
///                   SysOpera : 系统操作代码
/// Output:           返回String
/// w ##Class(DHCWMR.SS.Volume).GetOperaTimeByVol(1000,1)
ClassMethod GetOperaTimeByVol(aVolID As %String, aWorkItemID As %String) As %String
{
	New (aVolID,aWorkItemID)
	Set return=""
	Quit:(aVolID="")||(aWorkItemID="") return
	
	Set xSubID=""
	For {
		Set xSubID=$o(^DHCWMR.SS.VolumeD(aVolID,"S",xSubID),-1)
		Quit:xSubID=""
		Quit:return'=""
		
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVolID_"||"_xSubID)
		Continue:'$IsObject(objStatus)
		Continue:objStatus.VSUpdoOpera="U"
		Continue:'$IsObject(objStatus.VSStatus)
		Continue:objStatus.VSStatus.%Id()'=aWorkItemID
		Set return=objStatus.VSActDate_","_objStatus.VSActTime
	}
	
	Quit return
}

/// Creator：     李阳
/// CreatDate：   2014-08-22
/// Description:  更新病案卷信息
/// Table：       DHCWMR.SS.Volume
/// Input：       InputStr ：病案卷信息
///               Separate ：分隔符
/// Return：      返回String
/// w ##class(DHCWMR.SS.Volume).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set MainID=$p(aInputStr,aSeparate,2)
	Set WorkItemID=$p(aInputStr,aSeparate,3)
	Set OrdStep=$p(aInputStr,aSeparate,4)
	Set IsLend=+$p(aInputStr,aSeparate,5)
	Set IsCopy=+$p(aInputStr,aSeparate,6)
	Set IsStore=+$p(aInputStr,aSeparate,7)
	Set QCLock=+$p(aInputStr,aSeparate,8)
	Set DischDate=$p(aInputStr,aSeparate,9)
	;Set:DischDate["-" DischDate=$zdh(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(DischDate)
	Set BackDate=$p(aInputStr,aSeparate,10)
	;Set:BackDate["-" BackDate=$zdh(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(BackDate)
	Set IPTimes=$p(aInputStr,aSeparate,11)
	Set BuildDate=$p(aInputStr,aSeparate,12)
	;Set:BuildDate["-" BuildDate=$zdh(BuildDate,3)
	Set:BuildDate'="" BuildDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(BuildDate)
	Set:BuildDate="" BuildDate=+$h
	Set BuildTime=$p(aInputStr,aSeparate,13)
	Set:BuildTime[":" BuildTime=$zth(BuildTime,1)
	Set:BuildTime="" BuildTime=$p($h,",",2)
	Set IsActive=+$p(aInputStr,aSeparate,14)
	Set Resume=$p(aInputStr,aSeparate,15)
	Set Barcode=$p(aInputStr,aSeparate,16)
	Set IsExPaper = $p(aInputStr,aSeparate,17)
	Quit:(MainID="")||(WorkItemID="")||(OrdStep="") return
	
	Set objMain=##Class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	Set objWorkItem=##Class(DHCWMR.SS.WorkItem).GetObjById(WorkItemID)
	Quit:'$IsObject(objWorkItem) return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.Volume).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.Volume).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SVMainDr=objMain
	Set obj.SVStatus=objWorkItem
	Set obj.SVOrdStep=OrdStep
	Set obj.SVIsLend=IsLend
	Set obj.SVIsCopy=IsCopy
	Set obj.SVIsStore=IsStore
	Set obj.SVQCLock=QCLock
	Set obj.SVDischDate=DischDate
	Set obj.SVBackDate=BackDate
	Set obj.SVIPTimes=IPTimes
	Set obj.SVBuildDate=BuildDate
	Set obj.SVBuildTime=BuildTime
	Set obj.SVIsActive=IsActive
	Set obj.SVResume=Resume
	Set obj.SVIsExPaper=IsExPaper
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set VolID=obj.%Id()
		Set:Barcode="" Barcode=##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("02",VolID)
		Set obj.SVBarcode=Barcode
		Set sc=obj.%Save()
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-25
/// Description:  更新是否有纸张病历标识
/// Table：       DHCWMR.SS.Volume
/// Input：       VolID ：病案卷ID
/// 				  aFlg : 是否标识
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCWMR.SS.Volume).UpdateIsExPaper()
ClassMethod UpdateIsExPaper(aVolID As %String, aFlg As %Boolean) As %String
{
	New (aVolID,aFlg)
	Set return=0
	Quit:(aVolID="")||(aFlg="") return

	Set obj=##class(DHCWMR.SS.Volume).%OpenId(aVolID)
	Quit:'$IsObject(obj) return
	Set obj.SVIsExPaper=aFlg
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-27
/// Description:  作废病案卷信息
/// Table：       DHCWMR.SS.Volume
/// Input：       VolID ：病案卷ID
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCWMR.SS.Volume).CancelVolume()
ClassMethod CancelVolume(aVolID As %String) As %String
{
	New (aVolID)
	Set return=0
	Quit:(aVolID="") return
	Set obj=##class(DHCWMR.SS.Volume).%OpenId(aVolID)
	Quit:'$IsObject(obj) return
	Set obj.SVIsActive=0
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

/// Creator:      李阳
/// CreateDate:   2014-08-22
/// Description:  删除病案卷状态附加项
/// Table:        DHCWMR.SS.Volume
/// Input:        Id : DHCWMR.SS.Volume.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Volume).%DeleteId(aId)
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
<Value>SVMainDr</Value>
</Value>
<Value name="3">
<Value>SVStatus</Value>
</Value>
<Value name="4">
<Value>SVOrdStep</Value>
</Value>
<Value name="5">
<Value>SVIsLend</Value>
</Value>
<Value name="6">
<Value>SVIsCopy</Value>
</Value>
<Value name="7">
<Value>SVIsStore</Value>
</Value>
<Value name="8">
<Value>SVQCLock</Value>
</Value>
<Value name="9">
<Value>SVDischDate</Value>
</Value>
<Value name="10">
<Value>SVBackDate</Value>
</Value>
<Value name="11">
<Value>SVIPTimes</Value>
</Value>
<Value name="12">
<Value>SVBuildDate</Value>
</Value>
<Value name="13">
<Value>SVBuildTime</Value>
</Value>
<Value name="14">
<Value>SVIsActive</Value>
</Value>
<Value name="15">
<Value>SVResume</Value>
</Value>
<Value name="16">
<Value>SVBarcode</Value>
</Value>
<Value name="17">
<Value>SVIsExPaper</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.VolumeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.VolumeD</IdLocation>
<IndexLocation>^DHCWMR.SS.VolumeI</IndexLocation>
<StreamLocation>^DHCWMR.SS.VolumeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
