/// 病案主表
Class DHCWMR.SS.Main Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildFee As DHCWMR.SS.MainFee [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property SMMrType As DHCWMR.SS.MrType [ Required ];

/// 病案号
Property SMMrNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标识/标记（如：高干、VIP、生殖科标记、妇科标记等）
/// 根据医院具体要求设置，只是一个显示标记而已
Property SMMarker As %String(MAXLEN = 100, TRUNCATE = 1);

/// 归档号(归档上架号)
/// 根据医院具体要求设置，应用是，只要通过病案号找到归档号即可
Property SMFileNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案条码号（默认为病案ID，历史数据特殊处理）
Property SMBarcode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 建档日期
Property SMBuildDate As %Date;

/// 建档时间
Property SMBuildTime As %Time;

/// 建档人（指向SS_User）
Property SMBuildUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 初诊院区（指向CT_Hospital）
Property SMFirstHosp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 初诊科室（指向CT_Loc）
Property SMFirstLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 初诊医生（指向CT_CareProv）
Property SMFirstDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 初诊日期
Property SMFirstDate As %Date;

/// 初诊就诊号
Property SMFirstAdm As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property SMIsActive As %Boolean;

/// 病人来源（字典PatFrom） 
Property SMPatFrom As DHCWMR.SS.Dictionary;

/// 急诊来源 （字典EPPatFrom）
Property SMEPPatFrom As DHCWMR.SS.Dictionary;

/// 就诊状态 (字典PatAdmStatus)
Property SMPatAdmStatus As DHCWMR.SS.Dictionary;

/// 指初始记录（修改病案号会记录）
Property SMInitMainDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property SMResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 病案类型+病案号索引
Index IndexTypeNo On (SMMrType, SMMrNo);

/// 病案类型+病案号+是否有效索引
Index IndexTypeNoAct On (SMMrType, SMMrNo, SMIsActive);

/// 病案类型+病案条码+是否有效索引
Index IndexTypeBarcodeAct On (SMMrType, SMBarcode, SMIsActive);

/// 病案类型+建档日期+是否有效索引
Index IndexTypeBuildDateAct On (SMMrType, SMBuildDate, SMIsActive);

/// 指向原始记录索引
Index IndexInitMainDr On SMInitMainDr As Exact;

/// Creator:          李阳
/// CreateDate:       2014-08-21
/// Description:      根据ID取病案信息
/// OperationTable:   DHCWMR.SS.Main
/// Input:            Id : DHCWMR.SS.Main.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.SS.Main).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Main
{
	new (aId)
	quit:'##class(DHCWMR.SS.Main).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Main).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-01-19
/// Description:  根据病案号取病案信息
/// Table：       DHCWMR.SS.Main
/// Input：       MrTypeID : 病案类型
///               MrNo : 病案号
/// Return：      返回String
/// w ##class(DHCWMR.SS.Main).GetObjByMrNo(6,"00000020")
ClassMethod GetObjByMrNo(aMrTypeID As %String, aMrNo As %String) As DHCWMR.SS.Main
{
	New (aMrTypeID,aMrNo)
	Set return=""
	Quit:(aMrTypeID="")||(aMrNo="") return
	
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
		Quit:xMainID=""
		Quit:return'=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			Quit:return'=""
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			
			Set return=objVol.SVMainDr
		}
	}
	
	Quit return
}

/// Creator:          zhufei
/// CreateDate:       2014-09-27
/// Description:      取病案病人列表（如果存在一份病案多个登记号情况）
/// OperationTable:   DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input:            Id : DHCWMR.SS.Main.ID
/// Output:           返回String
/// w ##Class(DHCWMR.SS.Main).GetPatientIDs(1)
ClassMethod GetPatientIDs(aMainID As %String) As %String
{
	New (aMainID)
	Set return=""
	Quit:aMainID="" return
	
	Kill arrPatientList
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",aMainID,1,xVolID))
		Quit:xVolID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.SS.VolumeD(xVolID,"P",xSub))
			Quit:xSub=""
			Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSub)
			Continue:'$IsObject(objVolPaadm)
			Set Paadm=objVolPaadm.VPEpisodeID
			Continue:Paadm=""
			//Continue:$p($g(^PAADM(Paadm)),"^",20)="C"  //取消就诊
			Set PatientID=$p($g(^PAADM(Paadm)),"^",1)
			Continue:PatientID=""
			Set arrPatientList(PatientID)=""
		}
	}
	
	Set xPatientID=""
	For {
		Set xPatientID=$o(arrPatientList(xPatientID))
		Quit:xPatientID=""
		Set return=return_","_xPatientID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Kill arrPatientList
	
	Quit return
}

/// Creator：     李阳
/// CreatDate：   2014-08-19
/// Description:  更新病案信息
/// Table：       DHCWMR.SS.Main
/// Input：       InputStr : %Id^SMMrType^SMMrNo^SMBuildDate^SMBuildTime^SMIsActive^SMResume
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.SS.Main).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set MrTypeID=$p(aInputStr,aSeparate,2)
	Set MrNo=$p(aInputStr,aSeparate,3)
	Set BuildDate=$p(aInputStr,aSeparate,4)
	Set:BuildDate["-" BuildDate=$zdh(BuildDate,3)
	Set:BuildDate="" BuildDate=+$h
	Set BuildTime=$p(aInputStr,aSeparate,5)
	Set:BuildTime[":" BuildTime=$zth(BuildTime,1)
	Set:BuildTime="" BuildTime=$p($h,",",2)
	Set IsActive=+$p(aInputStr,aSeparate,6)
	Set Resume=$p(aInputStr,aSeparate,7)
	Set Marker=$p(aInputStr,aSeparate,8)
	Set FileNo=$p(aInputStr,aSeparate,9)
	Set Barcode=$p(aInputStr,aSeparate,10)
	Set BuildUser=$p(aInputStr,aSeparate,11)
	Set FirstHosp=$p(aInputStr,aSeparate,12)
	Set FirstLoc=$p(aInputStr,aSeparate,13)
	Set FirstDoc=$p(aInputStr,aSeparate,14)
	Set FirstDate=$p(aInputStr,aSeparate,15)
	Set FirstAdm=$p(aInputStr,aSeparate,16)
	Set PatFrom = $p(aInputStr,aSeparate,17)
	Set EPPatFrom = $p(aInputStr,aSeparate,18)
	Set PatAdmStatus = $p(aInputStr,aSeparate,19)
	Set SMInitMainDr = $p(aInputStr,aSeparate,20)
	Quit:(MrTypeID="")||(MrNo="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	
	Set objPatFrom = ##class(DHCWMR.SS.Dictionary).GetObjById(PatFrom)
	Set objEPPatFrom = ##class(DHCWMR.SS.Dictionary).GetObjById(EPPatFrom)
	Set objPatAdmStatus = ##class(DHCWMR.SS.Dictionary).GetObjById(PatAdmStatus)
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.Main).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.Main).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SMMrType    = objMrType
	Set obj.SMMrNo      = MrNo
	Set obj.SMMarker    = Marker
	Set obj.SMFileNo    = FileNo
	Set obj.SMBuildDate = BuildDate
	Set obj.SMBuildTime = BuildTime
	Set obj.SMBuildUser = BuildUser
	Set obj.SMFirstHosp = FirstHosp
	Set obj.SMFirstLoc  = FirstLoc
	Set obj.SMFirstDoc  = FirstDoc
	Set obj.SMFirstDate = FirstDate
	Set obj.SMFirstAdm  = FirstAdm
	Set obj.SMIsActive  = IsActive
	Set obj.SMPatFrom   = objPatFrom
	Set obj.SMEPPatFrom = objEPPatFrom
	Set obj.SMPatAdmStatus  = objPatAdmStatus
	Set obj.SMInitMainDr  = SMInitMainDr
	Set obj.SMResume    = Resume
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set MainID=obj.%Id()
		Set:Barcode="" Barcode=##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("01",MainID)
		Set obj.SMBarcode=Barcode
		Set sc=obj.%Save()
	}	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-19
/// Description:  更新病案号标记
/// Input：       MainID ：病案ID
///               MarkerID ：病案号标记
/// Return:		  return>0:成功
/// w ##class(DHCWMR.SS.Main).UpdateMarker()
ClassMethod UpdateMarker(aMainID As %String, aMarkerID As %String) As %String
{
	new (aMainID,aMarkerID)
	Set return=0
	Quit:(aMainID="") return
	
	Set obj=##class(DHCWMR.SS.Main).%OpenId(aMainID)
	Quit:'$IsObject(obj) return
	
	Set Marker=""
	Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(aMarkerID)
	If $IsObject(objDic){
		Set Marker=objDic.SDCode
	}
	
	Set obj.SMMarker = Marker
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     李毅
/// CreatDate：   2015-03-30
/// Description:  更新病案上架号
/// Input：       MainID ：病案ID
///               MarkerID ：病案上架号
/// Return:		  return>0:成功
/// w ##class(DHCWMR.SS.Main).UpdateFileNo()
ClassMethod UpdateFileNo(aMainID As %String, aFileNo As %String) As %String
{
	new (aMainID,aFileNo)
	Set return=0
	Quit:(aMainID="") return
	
	Set obj=##class(DHCWMR.SS.Main).%OpenId(aMainID)
	Quit:'$IsObject(obj) return
	
	Set obj.SMFileNo = aFileNo
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
/// CreatDate：   2015-03-19
/// Description:  获取病案号标记
/// Input：       MainID ：病案ID
/// Return:		  return>0:成功
/// w ##class(DHCWMR.SS.Main).GetMarker()
ClassMethod GetMarker(aMainID As %String) As %String
{
	new (aMainID)
	Set return=""
	Quit:(aMainID="") return
	
	Set obj=##class(DHCWMR.SS.Main).GetObjById(aMainID)
	Quit:'$IsObject(obj) return
	Set return = obj.SMMarker
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-27
/// Description:  作废病案信息
/// Table：       DHCWMR.SS.Main
/// Input：       MainID ：病案ID
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCWMR.SS.Main).CancelMain()
ClassMethod CancelMain(aMainID As %String) As %String
{
	New (aMainID)
	Set return=0
	Quit:(aMainID="") return
	Set obj=##class(DHCWMR.SS.Main).%OpenId(aMainID)
	Quit:'$IsObject(obj) return
	Set obj.SMIsActive  = 0
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     李阳
/// CreatDate：   2014-08-21
/// Description:  删除病案信息
/// Table：       DHCWMR.SS.Main
/// Input：       Id : DHCWMR.SS.Main.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Main).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-06-02
/// Description:  根据原始记录取有效病案记录（修改病案号之后）
/// Table：       DHCWMR.SS.Main
/// Input：       InitMainDr : 初始记录ID
/// Return：      返回String
/// w ##class(DHCWMR.SS.Main).GetActMainByID(353)
ClassMethod GetActMainByID(aInitMainDr As %String) As DHCWMR.SS.Main
{
	New (aInitMainDr)
	Set return=""
	Quit:(aInitMainDr="") return
	
	Set Count=0
	Set xMainID=aInitMainDr
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexInitMainDr",xMainID,""))
		Quit:xMainID=""
		Quit:Count>10
		
		Set Count=Count+1
		Set objMain=..GetObjById(xMainID)
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1
		Set return=objMain
		Quit
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-06-02
/// Description:  取历史修改记录（修改病案号之后）
/// Table：       DHCWMR.SS.Main
/// Input：       MainDr : 初始记录ID
/// Return：      返回String
/// w ##class(DHCWMR.SS.Main).GetHisMainByID(354)
ClassMethod GetHisMainByID(aID As %String) As %String
{
	New (aID)
	Set return=""
	Quit:(aID="") return
	
	Set objMain=..GetObjById(aID)
	Quit:'$IsObject(objMain) return
	Set InitMainDr=objMain.SMInitMainDr
	Quit:InitMainDr="" return
	Set return=InitMainDr
	
	Set Count=0
	Set xMainID=InitMainDr
	For {
		Set objMain=..GetObjById(xMainID)
		Quit:'$IsObject(objMain)
		Set xMainID=objMain.SMInitMainDr
		Quit:xMainID=""
		Quit:Count>10
		
		Set Count=Count+1
		Set return=return_","_xMainID
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SMMrType</Value>
</Value>
<Value name="3">
<Value>SMMrNo</Value>
</Value>
<Value name="4">
<Value>SMBuildDate</Value>
</Value>
<Value name="5">
<Value>SMBuildTime</Value>
</Value>
<Value name="6">
<Value>SMIsActive</Value>
</Value>
<Value name="7">
<Value>SMResume</Value>
</Value>
<Value name="8">
<Value>SMMarker</Value>
</Value>
<Value name="9">
<Value>SMFileNo</Value>
</Value>
<Value name="10">
<Value>SMBarcode</Value>
</Value>
<Value name="11">
<Value>SMBuildUser</Value>
</Value>
<Value name="12">
<Value>SMFirstHosp</Value>
</Value>
<Value name="13">
<Value>SMFirstLoc</Value>
</Value>
<Value name="14">
<Value>SMFirstDoc</Value>
</Value>
<Value name="15">
<Value>SMFirstDate</Value>
</Value>
<Value name="16">
<Value>SMFirstAdm</Value>
</Value>
<Value name="17">
<Value>SMPatFrom</Value>
</Value>
<Value name="18">
<Value>SMEPPatFrom</Value>
</Value>
<Value name="19">
<Value>SMPatAsmStatus</Value>
</Value>
<Value name="20">
<Value>SMPatAdmStatus</Value>
</Value>
<Value name="21">
<Value>SMInitMainDr</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.MainD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.MainD</IdLocation>
<IndexLocation>^DHCWMR.SS.MainI</IndexLocation>
<StreamLocation>^DHCWMR.SS.MainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
