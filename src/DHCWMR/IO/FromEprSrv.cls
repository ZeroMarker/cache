/// 名称: DHCWMR.IO.FromEprSrv
/// 描述: 电子病历提供接口服务
/// 编写者：zhufei
/// 编写日期: 2014-12-08
Class DHCWMR.IO.FromEprSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-03-01
/// Description:  判断2版还是3版电子病历
/// Input：       EpisodeID:就诊号
/// Return：      返回Integer  return>0:表示二版电子病历
/// w ##Class(DHCWMR.IO.FromEprSrv).GetOldRecCount()
ClassMethod GetOldRecCount(aEpisodeID As %String) As %Integer
{
	New (aEpisodeID)
	Quit:aEpisodeID="" -1
	
	Set $ZT="GetOldRecCountErr"
	Set return=##Class(EMRservice.BL.BLScatterData).GetOldRecCount(aEpisodeID)
	Quit return
	
GetOldRecCountErr
	Kill SLQCODE
	Set ECRecordCnt=-1
	&SQL(select count(*) into :ECRecordCnt from EPRinstance.ECRecord where EpisodeID = :aEpisodeID)
	Quit ECRecordCnt
}

/// Creator：     zhufei
/// CreatDate：   2016-03-01
/// Description:  术语集取东华电子病历首页数据接口
/// Input：       EpisodeID:就诊号
///               ElCode:术语集
///               ArrData:电子病历值 数组
/// Return：      返回String
/// Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
/// w ##class(DHCWMR.IO.FromEprSrv).GetEPRData(892,"HDSD00.11.056",.ArrGlossary)
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,ArrGlossary)
	Set return=""
	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set $ZT="GetEPRDataNewErr"
	
	Set Count=..GetOldRecCount(aEpisodeID)
	If Count>0 {
		//二版电子病历，GetEPRData方法即可通过模板单元调用，也可通过术语集调用
		Set return=##class(EPRservice.BOScatterData).GetEPRData(aEpisodeID,aElCode)
		
		//二版电子病历，GetDataByGlossary方法为术语集调用接口
		//Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(aEpisodeID,aElCode)
	} Else {
		//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
		Set Category=$e(aElCode,1,9)
		Quit:Category="" return
		
		If ArrGlossary.GetAt(Category)'=aEpisodeID {
			Set ArrGlossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(aEpisodeID,Category)
			Do ArrGlossary.SetAt(aEpisodeID,Category)
		}
		Set return=ArrGlossary.GetAt(aElCode)
		
	}
	Quit return
	
GetEPRDataNewErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2015-03-28
/// Description:  【作废】取电子病历版本
/// w ##Class(DHCWMR.IO.FromEprSrv).GetEprVersion()
ClassMethod GetEprVersion(aCode As %String) As %String
{
	New (aCode)
	Quit:aCode="" 0
	Set return=+$g(^DHCWMR.IO.VersionC(aCode))  //..GetEprVersion("GetEprFpDataIOVer")=1 二版电子病历判断
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  获取病历状态，包括：最终结算是否完成、医生是否确认病历完成、病历PDF文件是否生成
/// Input：       EpisodeID:就诊号
/// Return：      返回String
///               最终结算是否完成^医生是否确认病历完成^病历PDF文件是否生成
///               如:  1^1^1   1^1^0
/// w ##class(DHCWMR.IO.FromEprSrv).GetMedRecordStatus(5620763)
ClassMethod GetMedRecordStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set $ZT="GetMedRecordStatusErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(aEpisodeID)
	Quit return
GetMedRecordStatusErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  病历复核失败时，回置病历状态
/// Input：       EpisodeID : 就诊号
///               FinalAccountFlag : 是否回置最终结算标识, 1 或 0, 1表示需要回置
///               MRCompletionFlag : 是否回置医生病历确认标识, 1 或 0, 1表示需要回置
///               Remark : 复核备注信息, 可以为空
/// Return：      返回String（1 成功, 0 失败, -1 指定就诊不存在）
/// w ##class(DHCWMR.IO.FromEprSrv).SetCheckFailFlag("1", "1", "0", "备注信息")
ClassMethod SetCheckFailFlag(aEpisodeID As %String, aFinalAccountFlag As %String, aMRCompletionFlag As %String, aRemark As %String) As %String
{
	New (aEpisodeID,aFinalAccountFlag,aMRCompletionFlag,aRemark)
	Set return=0
	Quit:aEpisodeID="" return
	Set $ZT="SetCheckFailFlagErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag(aEpisodeID,aFinalAccountFlag,aMRCompletionFlag,aRemark)
	Quit return
SetCheckFailFlagErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  设置病案编目信息
/// Input：       EpisodeID:就诊号
/// Return：      返回String（1 成功，0 失败）
/// w ##class(DHCWMR.IO.FromEprSrv).SetCatalogInfo(5620763)
ClassMethod SetCatalogInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	Set $ZT="SetCatalogInfoErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).SetCatalogInfo(aEpisodeID)
	Quit return
SetCatalogInfoErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  设置病案复核信息
/// Input：       EpisodeID : 就诊号
///               UserID : 模板单元代码/术语集
/// Return：      返回String（1 成功，0 失败）
/// w ##class(DHCWMR.IO.FromEprSrv).SetReviewInfo(5620763,428)
ClassMethod SetReviewInfo(aEpisodeID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aUserID)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="") return
	Set $ZT="SetReviewInfoErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).SetReviewInfo(aEpisodeID,aUserID)
	Quit return
SetReviewInfoErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  指定就诊是否被扫描
/// Input：       EpisodeID:就诊号
/// Return：      返回String（1 - 已扫描，0 - 未扫描）
/// w ##class(DHCWMR.IO.FromEprSrv).HasScanned(5620763)
ClassMethod HasScanned(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	Set $ZT="HasScannedErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).HasScanned(aEpisodeID)
	Quit return
HasScannedErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  指定就诊是否被打印
/// Input：       EpisodeID:就诊号
/// Return：      返回String（1 - 已打印，0 - 未打印）
/// w ##class(DHCWMR.IO.FromEprSrv).HasPrinted(5620763)
ClassMethod HasPrinted(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	Set $ZT="HasPrintedErr"
	Set return=##Class(DHCEPRFS.BI.BIToWMR).HasPrinted(aEpisodeID)
	Quit return
HasPrintedErr
	Quit 0
}

/*********************************************************************
Desc:	统计指定日期内、指定用户的扫描操作明细
Input:	AStartDate 	开始日期，Cache内部格式
	AEndDate	结束日期，Cache内部格式
 	AUserID		用户RowID，如果此值为空，则查询指定日期内所有用户的扫描操作明细
 	ANeedSummarization ：是否需要计算扫描操作明细总和，0 不需要，1 需要
Return：一个自定义的%ResultSet，其返回列信息如下：
	MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID,ScanPages,ScanDate
Debug:	s rs = ##Class(DHCEPRFS.BI.BIToWMR).GetScanLog("63117","63117","136","0")
*********************************************************************/

/*********************************************************************
Desc:	统计指定日期内、指定用户的打印操作明细
Input:	AStartDate 	开始日期，Cache内部格式
	AEndDate	结束日期，Cache内部格式
	AUserID		用户RowID，如果此值为空，则查询指定日期内所有用户的打印操作明细
	ANeedSummarization ：是否需要计算打印操作明细总和，0 不需要，1 需要
Return：一个自定义的%ResultSet，其返回列信息如下：
 	MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,PrintUserID,PrintPages,PrintDate,UnitPrice,TotPrice
Debug:	s rs = ##Class(DHCEPRFS.BI.BIToWMR).GetPrintLog("63117","63117","136","0")
*********************************************************************/
}
