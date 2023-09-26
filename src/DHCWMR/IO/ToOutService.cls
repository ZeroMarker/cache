/// 名称: 	  DHCWMR.IO.ToOutService
/// 描述: 	  病案管理对外接口程序
/// 编写者：  朱飞
/// 编写日期: 2014-03-17
Class DHCWMR.IO.ToOutService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2016-05-05
/// Description:  接诊接口（TO计费组）住院登记的后台事务调用
/// Input：       aEpisodeID ：就诊ID
///               aMrNo ：病案号
///               aLogonLocID ：入院操作用户登录科室ID
/// 				  aLogonUserID：入院操作用户登录ID
/// w ##class(DHCWMR.IO.ToOutService).IGroupReceipt(666,"",294,20581)
ClassMethod IGroupReceipt(aEpisodeID As %String, aMrNo As %String, aLogonLocID As %String, aLogonUserID As %String) As %String
{
	New (aEpisodeID,aMrNo,aLogonLocID,aLogonUserID)
	Set return="-100^建立病案参数错误！"
	Quit:(aEpisodeID="")||(aLogonLocID="")||(aLogonUserID="") return
	
	Set $ZT="IGroupReceiptError"
	
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).IGroupReceipt(aEpisodeID,aMrNo,aLogonLocID,aLogonUserID)
		quit return
	}ElseIf(MRSVersion=3){
		Set ReceiptType = ##class(DHCWMR.SSService.ReceiptSrv).GetReceiptType(aEpisodeID)
		If ((ReceiptType="A")||((ReceiptType="HN")&&(aMrNo'=""))){  //自动接诊,或手工接诊但是存在已分配的病案号
			//按就诊号取号码类型
			Set NoTypeID = ##class(DHCWMR.SSService.ReceiptSrv).GetNoTypeByAdm(aEpisodeID,aMrNo)
			If (NoTypeID =""){
				Set return = "-2^病案号码类型错误"
				Quit return
			}
			Set MrTypeID = $p(NoTypeID,"||",1)
			//检查病案号格式
			If (aMrNo '= ""){
				Set ret = ##class(DHCWMR.SSService.ReceiptSrv).CheckMrNoInput(NoTypeID,aMrNo)
				Set errCode = $p(ret,"^",1)
				Set errDesc = $p(ret,"^",2)
				If (errCode<1){
					Set return = "-3^病案号格式错误,"_errDesc
					Quit return
				}
				Set aMrNo = $p(ret,"^",2)
			}
			
			//病案接诊
			Set ret = ##class(DHCWMR.SSService.ReceiptSrv).GroupReceipt(aEpisodeID,aMrNo,aLogonLocID,aLogonUserID,NoTypeID)
			Set errCode = $p(ret,"^",1)
			Set errDesc = $p(ret,"^",2)
			if (errCode<1)&&(errCode'=-3){
				Set return = "-4^接诊失败,"_errDesc
				Quit return
			} else {
				Set MrNo = $P(ret,"^",4)
				Set return = "1^接诊成功"_"^"_MrNo
				Quit return
			}
		} else {
			//手工接诊TODO
			Set return="-200^手工接诊暂不处理"
			Quit return
		}
	}
IGroupReceiptError
    Set ErrMsg="-999^"_$ZE
    Quit return
}

/// Creator：     liyi
/// CreatDate：   2016-05-05
/// Description:  取消接诊接口（TO计费组）住院登记的后台事务调用
/// Input：       aEpisodeID ：就诊ID
///               aLogonLocID ：退院操作用户登录科室ID
/// 				  aLogonUserID：退院操作用户登录ID
/// w ##class(DHCWMR.IO.ToOutService).IGroupUnReceipt(736,294,20581)
ClassMethod IGroupUnReceipt(aEpisodeID As %String, aLogonLocID As %String, aLogonUserID As %String) As %String
{
	New (aEpisodeID,aLogonLocID,aLogonUserID)
	Set return="-100^取消病案参数错误！"
	Quit:(aEpisodeID="")||(aLogonLocID="")||(aLogonUserID="") return
	
	Set $ZT="IGroupUnReceiptError"
	
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).IGroupUnReceipt(aEpisodeID,aLogonLocID,aLogonUserID)
	}ElseIf(MRSVersion=3){
		//取消接诊
		Set ret = ##class(DHCWMR.SSService.ReceiptSrv).GroupUnReceipt(aEpisodeID,aLogonLocID,aLogonUserID)
		Set errCode = $p(ret,"^",1)
		Set errDesc = $p(ret,"^",2)
		If (errCode<1){
			Set return = "-2^取消接诊失败,"_errDesc
			Quit return
		} else {
			Set return = "1^取消接诊成功"
			Quit return
		}
	}
	
IGroupUnReceiptError
    Set ErrMsg="-999^"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据PatientID取病案号接口
///               如果是集团化医院，注意HospitalID参数传入
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       PatientID ：病人ID
///               MrClass ：病案分类（门诊OP、住院IP、急诊EP、急诊留观EM）
///               HospitalID ：医院ID
/// w ##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(225,"I")
ClassMethod IGetMrNoByPatientID(aPatientID As %String, aMrClass As %String, aHospitalID As %String = "", ByRef ErrMsg As %String = "") As %String
{
	New (aPatientID,aMrClass,aHospitalID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aPatientID="")||(aMrClass="") return
	
	Set $ZT="GetMrNoByPatientIDError"
	
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,aMrClass,aHospitalID,"",.ErrMsg)
	}ElseIf(MRSVersion=3){
		Set:aMrClass="IP" aMrClass="I"
		Set:aMrClass="OP" aMrClass="O"
		Set:aMrClass="EP" aMrClass="E"
		
		Set ErrMsg="-2:无有效病案类型"
		Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,aHospitalID)
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,MrTypeID)
		If return="" {
			Set ErrMsg="-3:病案号不存在"
		} Else {
			Set ErrMsg=""
		}
	}
	
	Quit return
	
GetMrNoByPatientIDError
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据EpisodeID取病案号接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID ：就诊号
///               MrClass ：病案分类（门诊OP、住院IP、急诊EP、急诊留观EM）
/// w ##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(394,"I")
ClassMethod IGetMrNoByEpisodeID(aEpisodeID As %String, aMrClass As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,aMrClass,ErrMsg)
	Set return = "",ErrMsg="-1:参数错误"
	Quit:(aEpisodeID="")||(aMrClass="") return
	
	Set $ZT="GetMrNoByEpisodeIDError"
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(aEpisodeID,.ErrMsg)
	}ElseIf(MRSVersion=3){
		Set:aMrClass="IP" aMrClass="I"
		Set:aMrClass="OP" aMrClass="O"
		Set:aMrClass="EP" aMrClass="E"
		
		Set ErrMsg="-2:就诊不存在"
		Quit:$g(^PAADM(aEpisodeID))="" return
		
		Set ErrMsg="-3:无有效病案类型"
		Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
		Set HospitalID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		Quit:HospitalID="" return
		Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,HospitalID)
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(aEpisodeID,MrTypeID)
		If return="" {
			Set ErrMsg="-4:病案号不存在"
		} Else {
			Set ErrMsg=""
		}
	}
	Quit return
	
GetMrNoByEpisodeIDError
     Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案号取病人ID接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo ：病案号
///               MrClass ：病案分类（门诊OP、住院IP、急诊EP、急诊留观EM）
///               HospitalID ：医院ID
/// w ##class(DHCWMR.IO.ToOutService).IGetPatientIDByMrNo("000113","IP")
ClassMethod IGetPatientIDByMrNo(aMrNo As %String, aMrClass As %String, aHospitalID As %String = "", ByRef ErrMsg As %String) As %String
{
	New (aMrNo,aMrClass,aHospitalID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aMrNo="")||(aMrClass="") return
	
	Set $ZT="IGetPatientIDByMrNoError"
	
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(aMrNo,aMrClass,.ErrMsg)
	}ElseIf(MRSVersion=3){
		Set:aMrClass="IP" aMrClass="I"
		Set:aMrClass="OP" aMrClass="O"
		Set:aMrClass="EP" aMrClass="E"
		Set ErrMsg="-2:无有效病案类型"
		Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,aHospitalID)
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,MrTypeID)
		If return="" {
			Set ErrMsg="-3:病案号不存在"
		} Else {
			Set ErrMsg=""
		}
	}
	Quit return
	
IGetPatientIDByMrNoError
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// Description:  根据EpisodeID取新生儿病案号接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID ：就诊号（分娩记录）
/// w ##Class(DHCWMR.IO.ToOutService).GetNewBabyMrNo(aEpisodeID)
ClassMethod GetNewBabyMrNo(aEpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:aEpisodeID="" return
	
	Set $ZT="GetNewBabyMrNoErr"
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetNewBabyMrNo(aEpisodeID,.ErrMsg)
	}ElseIf(MRSVersion=3){
		Set return=##Class(DHCWMR.SSService.MrNoSrv).GetNewBabyMrNo(aEpisodeID)
		If return="" {
			Set ErrMsg="-2:病案号不存在"
		} Else {
			Set ErrMsg=""
		}
	}
	Quit return
	
GetNewBabyMrNoErr
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/*************************************以下接口未兼容V4**************************************/
/// Creator：     liyi
/// CreatDate：   2017-07-03
/// Description:  根据EpisodeID取病案条码
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       aEpisodeID ：就诊ID
///               aBarType ：条码类型，1：病案条码、2：卷条码
/// w ##class(DHCWMR.IO.ToOutService).GetBarCode(3)
ClassMethod GetBarCode(aEpisodeID As %String, aBarType As %String = "2") As %String
{
	New (aBarType,aEpisodeID)
	Set return ="",ErrMsg="-1:参数错误"
	Quit:(aBarType="")||(aEpisodeID="") return
	
	Set $ZT="GetBarCodeError"
	Set objVol = ##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$isobject(objVol) return
	
	Set SVBarcode = objVol.SVBarcode
	Set SMBarcode = objVol.SVMainDr.SMBarcode
	Set return = $s(aBarType=2:SVBarcode,aBarType=1:SMBarcode)
	Quit return
	
GetBarCodeError
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-12
/// Description:  取编目就诊记录（To统计组）
/// Table：       DHCWMR.FP.FrontPage
/// Input：       InputStr ：查询日期（编目日期）^开始时间^开始ID^空^空^截止日期^截止时间
/// Return：      返回String
///               查询日期（编目日期）^结束日期^结束ID^完成标志(1:完成，0:未完成)^就诊号字符串(英文逗号分隔)^截止日期^截止时间
/// 原有方法：直接调用Global(^DHCWMRFP)
/// 替换方法：w ##class(DHCWMR.IO.ToOutService).IGetFPCodingAdms()
ClassMethod IGetFPCodingAdms(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:aInputStr="" return
	
	Set aQryDate=+$p(aInputStr,"^",1)
	Set aSttTime=+$p(aInputStr,"^",2)
	Set aSttID=+$p(aInputStr,"^",3)
	Set aEndDate=+$p(aInputStr,"^",6)
	Set aEndTime=+$p(aInputStr,"^",7)
	Quit:aQryDate="" return
	
	Set maxOutputCnt=3000  //最大输出数
	
	Set OutputCnt=0,OutputStr=""
	Set xTime=aSttTime-1
	For {
		Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,aQryDate,xTime))
		Quit:xTime=""
		Quit:OutputCnt>maxOutputCnt
		
		//增加截止日期参数过滤 add by zf 2015-03-17
		If (aEndDate>0) {
			Quit:(aQryDate=aEndDate)&&(xTime>aEndTime)
		}
		
		Set xFpID=$s(xTime=aSttTime:aSttID,1:0)
		For {
			Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,aQryDate,xTime,xFpID))
			Quit:xFpID=""
			Quit:OutputCnt>maxOutputCnt
			
			Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
			Continue:'$IsObject(objFrontPage)
			Continue:'$IsObject(objFrontPage.FPVolumeDr)
			Continue:objFrontPage.FPType'="F"  //首次编目
			Set VolumeID=objFrontPage.FPVolumeDr.%Id()
			Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
			Continue:EpisodeID=""
			
			Set $p(return,"^",1)=aQryDate
			Set $p(return,"^",2)=xTime
			Set $p(return,"^",3)=xFpID
			Set $p(return,"^",4)=1
			Set OutputStr=OutputStr_","_EpisodeID
			
			Set OutputCnt=OutputCnt+1
			If OutputCnt>=maxOutputCnt {
				Set $p(return,"^",4)=0
				Quit //退出循环，等待下次循环再处理
			}
		}
	}
	Set $p(return,"^",5)=OutputStr
	Set ErrMsg=""
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-17
/// Description:  取病案操作对应就诊记录（To平台组）
/// Table：       DHCWMR.SS.Operation、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       InputStr ：查询日期（操作日期）^开始时间^开始ID^空^空^截止日期^截止时间
///               MrClass : 病案分类代码
///               SysOperCode : 系统操作代码
///               HospitalID : 医院ID
/// Return：      返回String
///               查询日期（操作日期）^结束日期^结束ID^完成标志(1:完成，0:未完成)^就诊号字符串(英文逗号分隔)^截止日期^截止时间
/// 原有方法：直接调用Global(^DHCWMRVOL)
/// 替换方法：w ##class(DHCWMR.IO.ToOutService).IGetMrOperaAdms()
ClassMethod IGetMrOperaAdms(aInputStr As %String, aMrClass As %String, aSysOperCode As %String, aHospitalID As %String = "", ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,aMrClass,aSysOperCode,aHospitalID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:(aInputStr="")||(aMrClass="")||(aSysOperCode="") return
	
	Set aQryDate=+$p(aInputStr,"^",1)
	Set aSttTime=+$p(aInputStr,"^",2)
	Set aSttID=+$p(aInputStr,"^",3)
	Set aEndDate=+$p(aInputStr,"^",6)
	Set aEndTime=+$p(aInputStr,"^",7)
	Quit:aQryDate="" return
	
	Set:aMrClass="IP" aMrClass="I"
	Set:aMrClass="OP" aMrClass="O"
	Set:aMrClass="EP" aMrClass="E"
	
	Set ErrMsg="-2:无有效病案类型"
	Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,aHospitalID)
	Quit:'$IsObject(objMrType) return
	Set MrTypeID=objMrType.%Id()
	
	Set ErrMsg="-3:无有效操作项目"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,aSysOperCode)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	
	Set maxOutputCnt=500  //最大输出数
	
	Set OutputCnt=0,OutputStr=""
	Set xTime=aSttTime-1
	For {
		Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",MrTypeID,WorkItemID,aQryDate,xTime))
		Quit:xTime=""
		Quit:OutputCnt>maxOutputCnt
		
		//增加截止日期参数过滤 add by zf 2015-03-17
		If (aEndDate>0) {
			Quit:(aQryDate=aEndDate)&&(xTime>aEndTime)
		}
		
		Set xOperaID=$s(xTime=aSttTime:aSttID,1:0)
		For {
			Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",MrTypeID,WorkItemID,aQryDate,xTime,xOperaID))
			Quit:xOperaID=""
			Quit:OutputCnt>maxOutputCnt
			
			Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
			Continue:'$IsObject(objOpera)
			Continue:objOpera.OPIsActive'=1
			Set BatchNumber=objOpera.OPBatchNumber
			
			Set xVolID=0,EpisodeIDStr=""
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
				Quit:xVolID=""
				
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive'=1  //卷无效
				Set objMain=objVol.SVMainDr
				Continue:'$IsObject(objMain)
				Continue:objMain.SMIsActive'=1  //病案无效
				Continue:'$IsObject(objMain.SMMrType)
				Continue:objMain.SMMrType.%Id()'=MrTypeID  //病案类型不一致
				
				Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
				Continue:EpisodeID=""
				Set EpisodeIDStr=EpisodeIDStr_","_EpisodeID
			}
			
			Set $p(return,"^",1)=aQryDate
			Set $p(return,"^",2)=xTime
			Set $p(return,"^",3)=xOperaID
			Set $p(return,"^",4)=1
			Set OutputStr=OutputStr_","_$e(EpisodeIDStr,2,$l(EpisodeIDStr))
			
			Set OutputCnt=OutputCnt+1
			If OutputCnt>=maxOutputCnt {
				Set $p(return,"^",4)=0
				Quit //退出循环，等待下次循环再处理
			}
		}
	}
	Set $p(return,"^",5)=OutputStr
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-12-14
/// Description:  查询病案编目就诊列表
/// Table：       DHCWMR.FP.FrontPage、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：    	  aDateFrom : 开始日期（按最新编目时间查询）
///               aDateTo : 结束日期
///               aHospitalID ：医院ID（CT_Hospital.ID） 允许为空
/// Return：      返回ROWSPEC="病案卷ID:就诊号:首次编目日期:首次编目时间:首次编目人:最新编目日期:最新编目时间:最新编目人:"
/// D ##class(%ResultSet).RunQuery("DHCWMR.IO.ToOutService","QryFPAdmsByDate","2013-01-01","2016-12-01")
Query QryFPAdmsByDate(aDateFrom As %String, aDateTo As %String, aHospitalID As %String = "") As %Query(ROWSPEC = "VolumeID:%String,EpisodeID:%String,BuildDate:%String,BuildTime:%String,BuildUser:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String")
{
}

ClassMethod QryFPAdmsByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospitalID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate,xTime))
			Quit:xTime=""
			
			Set xFpID=0
			For {
				Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate,xTime,xFpID))
				Quit:xFpID=""
				
				Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
				Continue:'$IsObject(objFrontPage)
				Continue:'$IsObject(objFrontPage.FPVolumeDr)
				Continue:objFrontPage.FPType'="F"  //首次编目
				Set VolumeID=objFrontPage.FPVolumeDr.%Id()
				Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
				Continue:EpisodeID=""
				
				Set BuildDate=objFrontPage.FPBuildDate
				Set:BuildDate'="" BuildDate=$zd(BuildDate,3)
				Set BuildTime=objFrontPage.FPBuildTime
				Set:BuildTime'="" BuildTime=$zt(BuildTime,1)
				Set BuildUser=objFrontPage.FPBuildUser
				Set:BuildUser'="" BuildUser=$p($g(^SSU("SSUSR",BuildUser)),"^",2)
				Set UpdateDate=objFrontPage.FPUpdateDate
				Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
				Set UpdateTime=objFrontPage.FPUpdateTime
				Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
				Set UpdateUser=objFrontPage.FPUpdateUser
				Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
				
				Set Data=$lb(VolumeID,EpisodeID,BuildDate,BuildTime,BuildUser,UpdateDate,UpdateTime,UpdateUser)
	 			Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
			}
		}
	}
	
 	Quit $$$OK
}

ClassMethod QryFPAdmsByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFPAdmsByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFPAdmsByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFPAdmsByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
