/// 名称: DHCHAI.IR.EnviHyReport
/// 描述: 环境卫生学监测报告单
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IR.EnviHyReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCHAI.IR.EnviHyReportLog [ Cardinality = children, Inverse = Parref ];

/// 监测结果
Relationship ChildResult As DHCHAI.IR.EnviHyRepResult [ Cardinality = children, Inverse = Parref ];

/// 检验标本号
Relationship ChildLab As DHCHAI.IR.EnviHyReportLab [ Cardinality = children, Inverse = Parref ];

/// 监测项目
Property EHItemDr As DHCHAI.IR.EnviHyItem [ Required ];

/// 监测对象
Property EHItemObjDr As DHCHAI.IR.EnviHyObject;

/// [新增]监测对象文本
Property EHItemObjTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态 EHRepStatus
Property EHRepStatus As DHCHAI.BT.Dictionary [ Required ];

/// [新增]全部完成
Property EHIsAllDone As %Boolean;

/// 监测日期
Property EHMonitorDate As %Date [ Required ];

/// [新增]监测科室
Property EHMonitorLocDr As DHCHAI.BT.Location [ Required ];

/// 申请日期
Property EHApplyDate As %Date [ Required ];

/// 申请时间
Property EHApplyTime As %Time [ Required ];

/// 申请科室
Property EHApplyLocDr As DHCHAI.BT.Location [ Required ];

/// 申请人
Property EHApplyUserDr As DHCHAI.BT.SysUser [ Required ];

/// 标本数量（不能超过20个）
Property EHSpecimenNum As %Integer(MAXVAL = 1000) [ Required ];

/// [新增]中心点数量
Property EHCenterNum As %Integer(MAXVAL = 1000) [ Required ];

/// [新增]周边点数量
Property EHSurroundNum As %Integer(MAXVAL = 1000) [ Required ];

/// [新增]参照点数量
Property EHReferToNum As %Integer(MAXVAL = 1000) [ Required ];

/// 报告日期
Property EHRepDate As %Date;

/// 报告时间
Property EHRepTime As %Time;

/// 报告科室
Property EHRepLocDr As DHCHAI.BT.Location;

/// 报告人
Property EHRepUserDr As DHCHAI.BT.SysUser;

/// 达标情况 EHStandard
Property EHStandard As DHCHAI.BT.Dictionary;

/// 备注
Property EHResume As %String(MAXLEN = 1000, TRUNCATE = 1);

/// [新增]采集日期（默认是发标本时间或人工标记）
Property EHCollDate As %Date;

/// [新增]采集时间
Property EHCollTime As %Time;

/// [新增]采集者
Property EHCollUserDr As DHCHAI.BT.SysUser;

/// [新增]接收日期（默认是接收标本时间）
Property EHRecDate As %Date;

/// [新增]接收时间
Property EHRecTime As %Time;

/// [新增]接收者
Property EHRecUserDr As DHCHAI.BT.SysUser;

/// [新增]录入方式 "EHEnterType"（1按项目、2按标本、3其他[1中心+1周边]）
Property EHEnterTypeDr As DHCHAI.BT.Dictionary;

/// [新增]是否复检
Property EHIsReCheck As %Boolean;

/// [新增]复检指针（指向原报告）
Property EHReCheckRepDr As %String(MAXLEN = 1000, TRUNCATE = 1);

/// [新增]顺序码
Property EHReOrderCode As %Integer(MAXVAL = 999) [ Required ];

/// 监测日期 索引
Index IndexOnMonitorDate On EHMonitorDate;

/// 申请日期 索引
Index IndexOnApplyDate On EHApplyDate;

/// 申请日期+顺序码 索引
Index IdxApplyCode On (EHApplyDate, EHReOrderCode);

/// 复检+监测日期 索引
Index IdxReCheckMonitorDate On (EHIsReCheck, EHMonitorDate);

/// 复检+申请日期 索引
Index IdxReCheckApplyDate On (EHIsReCheck, EHApplyDate);

/// 复检+采集日期 索引
Index IdxReCheckCollDate On (EHIsReCheck, EHCollDate);

/// 复检+接收日期 索引
Index IdxReCheckRecDate On (EHIsReCheck, EHRecDate);

/// 复检+结果日期 索引
Index IdxReCheckRepDate On (EHIsReCheck, EHRepDate);

/// 复检报告指针 索引
Index IdxReCheckRepDr On EHReCheckRepDr;

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  根据ID取监测报告单
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       id:    DHCHAI.IR.EnviHyReport.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyReport
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.EnviHyReport).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  更新监测报告单(申请)
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyReport).Update("^1^1^1^2019-09-19^^^242^8^22^13^4^^^^^^^^^^^^^^^^^2^5")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE

	Set $ZT="UpdateErr"

	Set ID			= $p(InStr,aSeparete,1)
	Set ItemDr		= $p(InStr,aSeparete,2)
	Set ItemObjDr	= $p(InStr,aSeparete,3)
	Set RepStatusCode	= $p(InStr,aSeparete,4)
	Set MonitorDate	= $p(InStr,aSeparete,5)
	Set:MonitorDate'="" MonitorDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(MonitorDate)
	Set ApplyDate	= $p(InStr,aSeparete,6)
	Set:ApplyDate'="" ApplyDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ApplyDate)
	Set:ApplyDate="" ApplyDate=+$h
	Set ApplyTime	= $p(InStr,aSeparete,7)
	Set:ApplyTime[":" ApplyTime=$zth(ApplyTime,1)
	Set:ApplyTime="" ApplyTime=+$p($h,",",2)
	Set ApplyLocDr	= $p(InStr,aSeparete,8)
	Set ApplyUserDr	= $p(InStr,aSeparete,9)
	Set SpecimenNum	= $p(InStr,aSeparete,10)
	Set CenterNum   = $p(InStr,aSeparete,11)
	Set SurroundNum = $p(InStr,aSeparete,12)
	Set RepDate		= $p(InStr,aSeparete,13)
	Set:RepDate'="" RepDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RepDate)
	Set RepTime		= $p(InStr,aSeparete,14)
	Set:RepTime[":" RepTime = $zth(RepTime,1)
	Set RepLocDr	= $p(InStr,aSeparete,15)
	Set RepUserDr	= $p(InStr,aSeparete,16)
	Set Standard	= $p(InStr,aSeparete,17)
	Set Resume    	= $p(InStr,aSeparete,18)
	Set CollDate	= $p(InStr,aSeparete,19)
	Set CollTime	= $p(InStr,aSeparete,20)
	Set CollUserDr	= $p(InStr,aSeparete,21)
	Set RecDate		= $p(InStr,aSeparete,22)
	Set RecTime		= $p(InStr,aSeparete,23)
	Set RecUserDr	= $p(InStr,aSeparete,24)
	Set EnterTypeDr	= $p(InStr,aSeparete,25)
	Set IsReCheck	= $p(InStr,aSeparete,26)
	Set ReCheckRepDr= $p(InStr,aSeparete,27)
	Set ItemObjTxt	= $p(InStr,aSeparete,28)
	Set MonitorLocDr= $p(InStr,aSeparete,29)
	Set ReferToNum	= $p(InStr,aSeparete,30)
	
	Quit:(ItemDr="")||(RepStatusCode="")||(MonitorDate="") return
	Quit:(ApplyDate="")||(ApplyTime="")||(ApplyLocDr="")||(ApplyUserDr="")||(SpecimenNum="")||(MonitorLocDr="") return
	Set objItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(ItemDr)
	Quit:'$IsObject(objItem) return
	
	Set objItemObj = ##class(DHCHAI.IR.EnviHyObject).GetObjById(ItemObjDr)
	//Quit:'$IsObject(objItemObj) return   //卫生手对象申请时可能为空
	
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",RepStatusCode)
	Quit:'$IsObject(objStatus) return

	Set objApplyLoc = ##class(DHCHAI.BT.Location).GetObjById(ApplyLocDr)
	Set objApplyUser = ##class(DHCHAI.BT.SysUser).GetObjById(ApplyUserDr)
	Set objRepLoc = ##class(DHCHAI.BT.Location).GetObjById(RepLocDr)
	Set objRepUser = ##class(DHCHAI.BT.SysUser).GetObjById(RepUserDr)
	Set objMonitorLoc = ##class(DHCHAI.BT.Location).GetObjById(MonitorLocDr)
	Set objEnterType = ##class(DHCHAI.BT.Dictionary).GetObjById(EnterTypeDr)
	//如果申请没有特别定义录入方式，录入方式与项目定义的录入方式一致
	Set:'$IsObject(objEnterType) objEnterType=objItem.EHEnterTypeDr 
	if ID="" {
		Set obj=##class(DHCHAI.IR.EnviHyReport).%New()
		Set obj.EHReOrderCode=..NewOrderCode()
	}else{
		Set obj=##class(DHCHAI.IR.EnviHyReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHItemDr 		= objItem
	Set obj.EHItemObjDr 	= objItemObj
	Set obj.EHRepStatus 	= objStatus
	Set obj.EHMonitorDate 	= MonitorDate
	//Set obj.EHApplyDate 	= ApplyDate
	Set:obj.EHApplyDate="" obj.EHApplyDate=ApplyDate
	//Set obj.EHApplyTime 	= ApplyTime
	Set:obj.EHApplyTime="" obj.EHApplyTime=ApplyTime
	Set obj.EHApplyLocDr 	= objApplyLoc
	Set obj.EHApplyUserDr 	= objApplyUser
	Set obj.EHSpecimenNum 	= SpecimenNum 
	Set obj.EHRepDate 		= RepDate
	Set obj.EHRepTime 		= RepTime
	Set obj.EHRepLocDr 		= objRepLoc
	Set obj.EHRepUserDr 	= objRepUser
	Set obj.EHStandard 		= Standard
	Set obj.EHResume 		= Resume
	Set obj.EHCenterNum		= CenterNum
	Set obj.EHSurroundNum	= SurroundNum
	Set obj.EHCollDate		= CollDate
	Set obj.EHCollTime		= CollTime
	Set obj.EHCollUserDr	= CollUserDr
	Set obj.EHRecDate		= RecDate
	Set obj.EHRecTime		= RecTime
	Set obj.EHRecUserDr		= RecUserDr
	Set obj.EHEnterTypeDr	= objEnterType
	Set obj.EHIsReCheck		= IsReCheck
	Set obj.EHReCheckRepDr	= ReCheckRepDr
	Set obj.EHItemObjTxt	= ItemObjTxt
	Set obj.EHMonitorLocDr	= objMonitorLoc
	Set obj.EHReferToNum	= ReferToNum
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return

UpdateErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     zhoubo
/// CreatDate：   2021-07-31
/// Description:  更新备注信息
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyReport).UpdateResume(110,"222222222222222")
ClassMethod UpdateResume(aReportID As %String, aResume As %String) As %String
{
	New (aReportID,aResume)
	Set return=0
	Quit:(aReportID="") return
	
	Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(aReportID)
	Quit:'$IsObject(obj) return
	Set obj.EHResume = aResume
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-19
/// Description:  更新报告状态信息
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyReport).UpdateStatus("128^4^^")
ClassMethod UpdateStatus(aStatusInfo As %String) As %String
{
	New (aStatusInfo)
	Set return=0
	Quit:aStatusInfo="" return
	
	Set ReportID     = $p(aStatusInfo,"^",1)
	Set StatusCode   = $p(aStatusInfo,"^",2)
	Set LocID        = $p(aStatusInfo,"^",3)
	Set UserID       = $p(aStatusInfo,"^",4)
	Set LabRegDate   = $p(aStatusInfo,"^",5)
	Set LabRegTime   = $p(aStatusInfo,"^",6)
	Quit:(ReportID="")||(StatusCode="") return
	
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",StatusCode)
	Quit:'$IsObject(objStatus) return
	
	//取值当前操作完成情况
	Set IsAllDone=##class(DHCHAI.IR.EnviHyReportLog).ChecktIsAllDone(ReportID,StatusCode)
	If (IsAllDone=1)&&((StatusCode=4)||(StatusCode=5)) {
		//录入结果或审核结果，取值达标情况
		Set StandardCode=##class(DHCHAI.IR.EnviHyRepResult).CheckStandard(ReportID)
	} Else {
		Set StandardCode=""
	}
	Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(ReportID)
	Quit:'$IsObject(obj) return
	Set obj.EHRepStatus     = objStatus
	Set obj.EHIsAllDone     = +IsAllDone
	
	If StatusCode="1" {  //申请
		Set obj.EHApplyDate     = +$h
		Set obj.EHApplyTime     = $p($h,",",2)
		Set obj.EHApplyLocDr    = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Set obj.EHApplyUserDr 	= ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	} ElseIf StatusCode="2" {  //发放材料
	} ElseIf StatusCode="3" {  //接收标本
		Set obj.EHRecDate 		= +$h
		Set obj.EHRecTime 		= $p($h,",",2)
		Set obj.EHRecUserDr 	= ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	} ElseIf StatusCode="4" {  //录入结果
		Set obj.EHRepDate 		= +$h
		Set obj.EHRepTime 		= $p($h,",",2)
		Set:LabRegDate'="" obj.EHRepDate = LabRegDate
		Set:LabRegTime'="" obj.EHRepTime = LabRegTime
		Set obj.EHRepLocDr 		= ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Set obj.EHRepUserDr 	= ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
		Set obj.EHStandard      = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHStandard",StandardCode)
	} ElseIf StatusCode="5" {  //审核结果
		Set obj.EHRepDate 		= +$h
		Set obj.EHRepTime 		= $p($h,",",2)
		Set obj.EHRepLocDr 		= ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Set obj.EHRepUserDr 	= ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	} ElseIf StatusCode="6" {  //采集标本
		Set obj.EHCollDate      = +$h
		Set obj.EHCollTime      = $p($h,",",2)
		Set obj.EHCollUserDr 	= ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	} Else {}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 环境卫生学顺序码生成 2056115
/// w ##class(DHCHAI.IR.EnviHyReport).NewOrderCode() 
ClassMethod NewOrderCode()
{
	kill:$d(^DHCHAI.IR.EnviHyReport("EHReOrderCode",+$H-1)) ^DHCHAI.IR.EnviHyReport("EHReOrderCode",+$H-1)
	Set return=$I(^DHCHAI.IR.EnviHyReport("EHReOrderCode",+$H))
    Quit:+return<1000 return
    Quit 0
}

/// 环境卫生学监测生成条码规则
/// 8位条码,前边自动补零 ->20210804调整成申请当天的年月日+3位顺序码为申请号
/// w ##class(DHCHAI.IR.EnviHyReport).GetBarCode("87")
ClassMethod GetBarCode(aReportID As %String = "") As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set SSHospCode=""
	Set RepList=$g(^DHCHAI.IR.EnviHyReportD(aReportID))
	Quit:RepList="" return
	Set OrderCode=$lg(RepList,32)
	if +OrderCode'=0{
		Set EHApplyDate=$lg(RepList,6)
		Set OrderCode= "000"_OrderCode
		Set return = $e($zd(EHApplyDate,8),3,8)_$e(OrderCode,$l(OrderCode)-2,$l(OrderCode))     //11位
	}else{
		Set BarCode=aReportID
	
		Set BarCode="00000000"_BarCode
		Set return=$e(BarCode,$l(BarCode)-7,$l(BarCode)) //8位
	}
	Quit return
}

/// 环境卫生学监测标本条码
/// w ##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode("1",1)
ClassMethod GetSpenBarCode(aReportID As %String, aIndex As %String) As %String
{
	New (aReportID,aIndex)
	Set return=""
	Quit:aReportID="" return
	
	Set RepBarCode = ..GetBarCode(aReportID)
	Set BarCode=RepBarCode_$s($l(aIndex)<2:"0"_aIndex,1:aIndex)
	Set return=BarCode
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-04
/// 保存环境卫生学监测检验标本
/// w ##class(DHCHAI.IR.EnviHyReport).SaveLabBarcode("2")
ClassMethod SaveLabBarcode(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	For indBar=1:1:objRep.EHItemDr.EHSpecimenNum {
		Set SpenBarCode=..GetSpenBarCode(aReportID,indBar)
		
		Set InputStr = aReportID_"^"_""_"^"_SpenBarCode_"^"_""_"^"_""_"^"_""
		
		Set return = ##class(DHCHAI.IR.EnviHyReportLab).Update(InputStr,"^")
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  环境卫生学监测接收标本，发放材料(按申请单操作/按标本操作)
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       BarCode
/// Return：      返回String
/// w ##class(DHCHAI.IR.EnviHyReport).ReceiveSpecimen("^0000000101^2^117^9","^")
ClassMethod ReceiveSpecimen(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return

	Set $ZT="ReceiveSpecimenErr"

	Set ReportID = $p(aInput,aSeparate,1)
	Set SpenBarCode  = $p(aInput,aSeparate,2)
	Quit:(ReportID'="")&&(SpenBarCode'="") return
	
	If ReportID=""{
		Set ReportID=+$e(SpenBarCode,0,8)
	}
	Quit:ReportID<1 return
	
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	
	Set StatusCode	= $p(aInput,aSeparate,3)
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",StatusCode)
	Quit:'$IsObject(objStatus) return
	Quit:'((objStatus.BTCode=2)||(objStatus.BTCode=3)) return	// 非材料发放或标本接收操作

	Set LocID		= $p(aInput,aSeparate,4)
	Set UserID		= $p(aInput,aSeparate,5)
	
	Tstart
	// 保存主表信息
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).%OpenId(ReportID)
	Quit:'$IsObject(objRep) return

	If (SpenBarCode'=""){	// 单个标本操作
		If (objStatus.BTCode=2){	// 材料发放
			Set SpecimenNum=+objRep.EHSpecimenNum
			Set SpecimenNum=SpecimenNum+1
			Set objRep.EHSpecimenNum=SpecimenNum
		}
	}else{		// 按申请单操作
		If objStatus.BTCode=2{	// 材料发放
			Set SpecimenNum=+objRep.EHItemDr.EHSpecimenNum
			Set objRep.EHSpecimenNum=SpecimenNum
		}
	}
	Set objRep.EHRepStatus = objStatus
	Set sc=objRep.%Save()
	If objRep'="" Do objRep.%Close()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Trollback
   		Quit return
	}else{
		Set return=objRep.%Id()
	}
	
	// 保存日志
	If SpenBarCode=""{
		Set flg =1
		Set SpecimenNum = objRep.EHItemDr.EHSpecimenNum
		Set RepBarCode = ..GetBarCode(ReportID)
		For indBar=1:1:SpecimenNum {
			Set BarCode=..GetSpenBarCode(ReportID,indBar)
			if '$d(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCodeStatus"," "_BarCode,objStatus.%Id(),ReportID)){
				Set inputStatus=objRep.%Id()_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_BarCode_"^"_""_"^"_1
				Set ret=##Class(DHCHAI.IR.EnviHyReportLog).Update(inputStatus,"^")	//标本日志
				IF '(+ret>0){
					Set flg =0
				}
			}
		}
		If flg=0{
			Trollback
			Quit return 
		}
	}else{
		Set inputStatus=objRep.%Id()_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_SpenBarCode_"^"_""_"^"_1
		Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(inputStatus,"^")	// 标本日志
		IF '(+flg>0){
			Trollback
			Quit return
		}
	}
	Set inputStatus=objRep.%Id()_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_""_"^"_""_"^"_1
	Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(inputStatus,"^") // 报告日志
	IF '(+flg>0){
		Trollback
		Quit return
	}
	TCommit
	
	Quit return

ReceiveSpecimenErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  环境卫生学监测结果录入
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       BarCode
/// Return：      返回String
/// w ##class(DHCHAI.IR.EnviHyReport).EnterResult("1^24^13^4^1^312^0000000101^2^240^0000000102^3^428^0000000103^4^576^0000000104^5^578^0000000105^6^579^0000000106^7^1509^0000000107","^")
ClassMethod EnterResult(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return

	Set $ZT="EnterResultErr"

	Set ReportID 	= $p(aInput,aSeparate,1)
	Set LocID		= $p(aInput,aSeparate,2)
	Set UserID		= $p(aInput,aSeparate,3)
	Set StatusCode	= $p(aInput,aSeparate,4)
	Set ResultStr   = $p(aInput,aSeparate,5,$l(aInput,aSeparate))	// 结果信息
	Quit:ReportID="" return

	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	
	Set RepBarCode = ..GetBarCode(ReportID)
	Quit:RepBarCode="" return
	
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",StatusCode)
	Quit:'$IsObject(objStatus) return
	
	TStart
	// 结果表
	Set SpenCount = 0,Flg=1
	For ind=3:3:$l(ResultStr,aSeparate){
		Set Result = $p(ResultStr,aSeparate,ind-2,ind)
		Set SpenCount = SpenCount+1
		Set BacteriaCount = $p(Result,aSeparate,1)
		Set BacteriaID	  = $p(Result,aSeparate,2)
		Set SpenBarCode	  = $p(Result,aSeparate,3)
		
		Set Input = ReportID_"^^"_BacteriaCount_"^"_BacteriaID_"^"_SpenBarCode
		Set ret = ##class(DHCHAI.IR.EnviHyRepResult).Update(Input,"^")
		If '(+ret>0){
			Set Flg=0
		}
		Set Input=ReportID_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_SpenBarCode_"^"_""_"^"_1
		Set ret=##Class(DHCHAI.IR.EnviHyReportLog).Update(Input,"^")	// 标本日志
		If '(+ret>0){
			Set Flg=0
		}
	}
	If Flg=0{
		Trollback
		Quit return
	}
	
	// 主表
	Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(ReportID)
	Quit:'$IsObject(obj) return
	
	// 已录入结果标本量
	Set ResultCount = 0
	For indBar=1:1:obj.EHItemDr.EHSpecimenNum {
		Set SpenBarCode=..GetSpenBarCode(ReportID,indBar)
		If $d(^DHCHAI.IR.EnviHyReportI("Result","IndexOnSpenBarCode",SpenBarCode)){
			Set ResultCount = ResultCount+1
		}
	}
	
	Set ForMula     = obj.EHItemDr.EHForMula  // 计算公式
	Set NormMax     = obj.EHItemDr.EHNormMax	// 中心值
	Set NormMin     = obj.EHItemDr.EHNormMin	// 周边值
	Set CenterNum   = obj.EHItemDr.EHCenterNum
	Set SurroundNum = obj.EHItemDr.EHSurroundNum
	Set SpecimenNum	= obj.EHItemDr.EHSpecimenNum
	
	// 判断达标情况
	Set StandardCode = ""
	If ResultCount<=obj.EHItemDr.EHSpecimenNum {
		Set errorInfo="",StandardCode="1"
		Set (CenterVal,SurroundVal,SpecimenVal)=0
		For indBar=1:1:obj.EHItemDr.EHSpecimenNum {
			Set SpenBarCode=..GetSpenBarCode(ReportID,indBar)
			Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexOnSpenBarCode",SpenBarCode,ReportID,""),-1)
			Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(ReportID_"||"_SubID)
			Continue:'$IsObject(objResult)
			Continue:'$IsObject(objResult.EHBactDr)
			Set StandardCode="0"  // 检出病原体不合格
		}
		For indBar=1:1:obj.EHItemDr.EHSpecimenNum {
			Quit:StandardCode="0" // 检出病原体不合格,不需要在判断细菌数
			Set SpenBarCode=..GetSpenBarCode(ReportID,indBar)
			Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexOnSpenBarCode",SpenBarCode,ReportID,""),-1)
			Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(ReportID_"||"_SubID)
			If $IsObject(objResult){
				Set Result = +objResult.EHResult
			}else{
				Set Result = 0
			}
			Set ErrMsg=""
			Set tmpRst=..GetEnviHyResult(ForMula,Result,.ErrMsg)
			Set tmpRst=+tmpRst
			If ErrMsg'="" {
				Set errorInfo=ErrMsg
			}
			If ((CenterNum>0)&&((+$p(SpenBarCode,RepBarCode,2))<=CenterNum)){
				Set CenterVal=CenterVal+tmpRst
			} ElseIf ((SurroundNum>0)&&((+$p(SpenBarCode,RepBarCode,2))<=(SurroundNum+CenterNum))){
				Set SurroundVal=SurroundVal+tmpRst
			} ElseIf ((CenterNum>0)||(SurroundNum>0)) {
				//参照值
			} else {
				Set SpecimenVal=SpecimenVal+tmpRst
			}
		}
		If (CenterNum>0) {
			Set:(CenterVal/CenterNum)>NormMax StandardCode="0"      //中心值
		}
		If (SurroundNum>0) {
			Set:(SurroundVal/SurroundNum)>NormMin StandardCode="0"  //周边值
		}
		If (CenterNum<1)&&(SurroundNum<1) {
			Set:(SpecimenVal/SpecimenNum)>NormMax StandardCode="0"  //检测值
		}
		if errorInfo'="" {
			Trollback
			Quit return
		}
	}
	if StandardCode'=""{
		Set objStandard = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHStandard",StandardCode)
		Set obj.EHStandard = objStandard
	}
	Set objRep.EHRepStatus = objStatus
	Set sc=objRep.%Save()
	If objRep'="" Do objRep.%Close()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Trollback
   		Quit return
	}
	
	Set Input=ReportID_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_""_"^"_""_"^"_1
	Set ret=##Class(DHCHAI.IR.EnviHyReportLog).Update(Input,"^")	// 报告日志
	If '(+ret>0){
		Set Flg=0
	}
	TCommit
	
	Quit ReportID

EnterResultErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  删除监测报告单
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.EnviHyReport).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

ClassMethod GetEnviHyResult(aItemForMula As %String, aResult As %String, ByRef ErrMsg As %String) As %String
{
	New (aItemForMula,aResult,ErrMsg)
	Set return=""
	Quit:aResult="" return
	
	Set $ZT="GetEnviHyResultErr"
	If aItemForMula="" {
		Set return=aResult
	} Else {
		For {
			Quit:aItemForMula'["N"
			Set tmpForMula=$p(aItemForMula,"N",1)
			Set aItemForMula=tmpForMula_aResult_$e(aItemForMula,$l(tmpForMula)+2,$l(aItemForMula))
		}
		If ($e(aItemForMula,1,1)="(")&&($e(aItemForMula,$l(aItemForMula),$l(aItemForMula))=")"){
			Set aItemForMula="Set return="_aItemForMula
		} Else {
			Set aItemForMula="Set return=("_aItemForMula_")"
		}
		X aItemForMula
	}
	Quit return
	
GetEnviHyResultErr
	Set ErrMsg=$ZError
	Quit ""
}

Storage Default
{
<Data name="EnviHyReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHItemDr</Value>
</Value>
<Value name="3">
<Value>EHItemObjDr</Value>
</Value>
<Value name="4">
<Value>EHRepStatus</Value>
</Value>
<Value name="5">
<Value>EHMonitorDate</Value>
</Value>
<Value name="6">
<Value>EHApplyDate</Value>
</Value>
<Value name="7">
<Value>EHApplyTime</Value>
</Value>
<Value name="8">
<Value>EHApplyLocDr</Value>
</Value>
<Value name="9">
<Value>EHApplyUserDr</Value>
</Value>
<Value name="10">
<Value>EHSpecimenNum</Value>
</Value>
<Value name="11">
<Value>EHRepDate</Value>
</Value>
<Value name="12">
<Value>EHRepTime</Value>
</Value>
<Value name="13">
<Value>EHRepLocDr</Value>
</Value>
<Value name="14">
<Value>EHRepUserDr</Value>
</Value>
<Value name="15">
<Value>EHStandard</Value>
</Value>
<Value name="16">
<Value>EHResume</Value>
</Value>
<Value name="17">
<Value>EHCollDate</Value>
</Value>
<Value name="18">
<Value>EHCollTime</Value>
</Value>
<Value name="19">
<Value>EHCollUserDr</Value>
</Value>
<Value name="20">
<Value>EHRecDate</Value>
</Value>
<Value name="21">
<Value>EHRecTime</Value>
</Value>
<Value name="22">
<Value>EHRecUserDr</Value>
</Value>
<Value name="23">
<Value>EHEnterTypeDr</Value>
</Value>
<Value name="24">
<Value>EHIsReCheck</Value>
</Value>
<Value name="25">
<Value>EHReCheckRepDr</Value>
</Value>
<Value name="26">
<Value>EHItemObjTxt</Value>
</Value>
<Value name="27">
<Value>EHCenterNum</Value>
</Value>
<Value name="28">
<Value>EHSurroundNum</Value>
</Value>
<Value name="29">
<Value>EHReferToNum</Value>
</Value>
<Value name="30">
<Value>EHMonitorLocDr</Value>
</Value>
<Value name="31">
<Value>EHIsAllDone</Value>
</Value>
<Value name="32">
<Value>EHReOrderCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.EnviHyReportD</DataLocation>
<DefaultData>EnviHyReportDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.EnviHyReportD</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyReportI</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
