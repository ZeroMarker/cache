/// 名称: DHCMed.NINF.Rep.EnviHyReport
/// 描述: 环境卫生学监测报告
/// 编写者：zhufei
/// 编写日期: 2012-08-13
Class DHCMed.NINF.Rep.EnviHyReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.Rep.EnviHyReportLog [ Cardinality = children, Inverse = ParRef ];

/// 监测项目
Property EHRItem As DHCMed.NINF.Dic.EnviHyItem [ Required ];

/// 监测标准
Property EnviHyNorm As DHCMed.NINF.Dic.EnviHyNorms;

/// 项目对象
Property EHRItemObj As %String(TRUNCATE = 1);

/// 监测日期
Property EHRDate As %Date;

/// 接收标本日期
Property EHRReceiveDate As %Date;

/// 接收标本时间
Property EHRReceiveTime As %Time;

/// 标本类型 "NINFEnviHySpecimenType"
Property SpecimenType As DHCMed.SS.Dictionary;

/// 发放标本数量
Property SpecimenNum As %String;

/// 补发标本数量
Property AddSpecimenNum As %String;

/// 监测结果
Property EHRResult As %String(MAXLEN = 500);

/// 监测结果致病菌
Property EHRPathogens As %String(MAXLEN = 500);

/// 合格/达标情况("NINFEnviHyIsNorm")
/// 自动判断/手动判断
Property EHRAutoIsNorm As %String;

/// 计算公式
Property EHRItemForMula As %String;

/// 条码
Property EHRBarCode As %String;

/// 申请日期
Property EHRAskForDate As %Date;

/// 申请时间
Property EHRAskForTime As %Time;

/// 申请科室
Property EHRAskForLoc As %String;

/// 申请人
Property EHRAskForUser As %String;

/// 报告日期
Property EHRRepDate As %Date;

/// 报告时间
Property EHRRepTime As %Time;

/// 报告科室
Property EHRRepLoc As %String;

/// 报告人
Property EHRRepUser As %String;

/// 报告状态("NINFEnviHyReportStatus")
Property EHRRepStatus As DHCMed.SS.Dictionary;

/// 备注
Property EHRResume As %String(TRUNCATE = 1);

Index IndexDateLoc On (EHRDate As Exact, EHRAskForLoc As Exact);

Index IndexRepDateLoc On (EHRRepDate As Exact, EHRRepLoc As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-08-17
/// Description:  取环境卫生学监测报告
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       DHCMed.NINF.Rep.EnviHyReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById("1")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.EnviHyReport
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	If $IsObject(obj){
		Set obj.EHRBarCode=..GetBarCode(obj.%Id())
	}
	Quit obj
}

/// 环境卫生学监测生成条码规则
/// 10位条码,前边自动补零
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).GetBarCode("1")
ClassMethod GetBarCode(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set SSHospCode=""
	Set RepList=$g(^DHCMed.NINF("EnviRep",aReportID))
	Quit:RepList="" return
	If $listlength(RepList)>23 {
		Set ReqLocID=$list(RepList,23)
		Set LogonHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(ReqLocID)
		Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(LogonHospID,"NINF")
	}
	
	Set BarCode=aReportID
	Set BarCode="0000000"_BarCode
	Set return=$e(BarCode,$l(BarCode)-6,$l(BarCode))
	
	If SSHospCode="11-AZ" {
		Set return="S"_return
	} ElseIf SSHospCode="11-XH" {
		Set return="7"_return
	} Else {
		Set return="0"_return
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-17
/// Description:  更新环境卫生学监测报告
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：      Input：       报告ID^申请科室ID^检测项目ID^检测标准ID^检测对象^检测日期Cache类型^标本类型ID^标本数量^申请人ID^状态ID^备注^日志记录申请动作的执行科室——执行人——报告状态ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.EnviHyReport).Update("^117^1^1^阿道夫^62696^3292^3^9^3295^备注^117/9/3295","^,/")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	Set ID=$p(aInput,CHR1,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.EnviHyReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHRAskForLoc=$p(aInput,CHR1,2)
	Set itemID=$p(aInput,CHR1,3)
	Set obj.EHRItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(itemID)
	Set normID=$p(aInput,CHR1,4)
	Set obj.EnviHyNorm = ##class(DHCMed.NINF.Dic.EnviHyNorms).GetObjById(normID)
	Set obj.EHRItemObj=$p(aInput,CHR1,5)
	Set obj.EHRDate=$p(aInput,CHR1,6)
	Set SpecimenTypeID=$p(aInput,CHR1,7)
	Set obj.SpecimenType=##class(DHCMed.SS.Dictionary).GetObjById(SpecimenTypeID)
	Set obj.SpecimenNum=$p(aInput,CHR1,8)
	Set obj.EHRAskForDate=+$h  
	Set obj.EHRAskForTime=$p($h,",",2) 
	Set obj.EHRAskForUser=$p(aInput,CHR1,9)
	Set EHRRepStatusID=$p(aInput,CHR1,10)
	Set obj.EHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(EHRRepStatusID)
	Set obj.EHRResume=$p(aInput,CHR1,11)
	Set UpdateLog=$p(aInput,CHR1,12)
	Set obj.EHRRepLoc=$p(UpdateLog,CHR2,1)
	Set obj.EHRRepUser=$p(UpdateLog,CHR2,2)
	Set obj.EHRBarCode=""  //条码自动生成
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		//Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		//更新日志
		Set UpdateLog=obj.%Id()_CHR2_UpdateLog_CHR2_obj.EHRResume
		Set flg=##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(UpdateLog,CHR2)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yhb
/// CreatDate：   2013-11-27
/// Description:  删除环境卫生学申请报告
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       DHCMed.NINF.Rep.EnviHyReport.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.EnviHyReport).DeleteById("4")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.EnviHyReport).%DeleteId(+aId)
	If $System.Status.IsError(sc) {
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-14
/// Description:  环境卫生学监测接收标本
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       BarCode
/// Return：      返回String
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).ReceiveSpecimen("7000000801^3^117^9","^")
ClassMethod ReceiveSpecimen(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set BarCode=$p(aInput,aSeparate,1)
	Set ReportID=+$e(BarCode,2,$l(BarCode)-2)
	Set StatusCode=$p(aInput,aSeparate,2)
	Set StatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(StatusCode,"NINFEnviHyReportStatus")
	Set LocID=$p(aInput,aSeparate,3)
	Set UserID=$p(aInput,aSeparate,4)
	
	Set errorInfo="-1^无检测报告!"
	Quit:ReportID<1 errorInfo
	Set objRep=##Class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) errorInfo
	
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReport).%OpenId(ReportID)
	Quit:'$IsObject(obj) return
	
	Set SpecimenNum=obj.SpecimenNum
	Set SpecimenNum=+SpecimenNum
	Set obj.SpecimenNum=SpecimenNum+1
	
	Set obj.EHRReceiveDate=+$h
	Set obj.EHRReceiveTime=$p($h,",",2)
	Set obj.EHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Set return="-2^保存失败!"
	} Else {
		Set return=obj.%Id()
		
		Set inputStatus=obj.%Id()_"^"_LocID_"^"_UserID_"^"_StatusID_"^"_""_"^"_BarCode
		Set flg=##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(inputStatus,"^")
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-14
/// Description:  环境卫生学监测录入结果权限检查
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       BarCode
/// Return：      返回String
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).CheckBarCodeInput("0000000701")
ClassMethod CheckBarCodeInput(aBarCode As %String) As %String
{
	New (aBarCode)
	Set return="0^参数错误!"
	Quit:(aBarCode="") return
	
	Set aBarCode=$tr(aBarCode," ","")
	Quit:$l(aBarCode)'=10 return
	
	Set ReportID=+$e(aBarCode,2,$l(aBarCode)-2)
	Set SubIndex=+$e(aBarCode,$l(aBarCode)-1,$l(aBarCode))
	Set errorInfo="-100^无条码号对应的检测报告!"
	Quit:ReportID<1 errorInfo
	
	Set errorInfo="-101^无有效的检测报告!"
	Set objRep=##Class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) errorInfo
	
	Set errorInfo="-102^环境卫生检测项目无对应结果判定标准!"
	Set objNorm=objRep.EnviHyNorm
	Quit:'$IsObject(objNorm) errorInfo
	Set SpecimenNum=objNorm.SpecimenNum
	
	Set errorInfo="-103^环境卫生检测条码对应编号与标本数量不符!"
	Quit:SubIndex>SpecimenNum errorInfo
	
	Set StatusInfo=##Class(DHCMed.NINF.Rep.EnviHyReportLog).CheckCurrStatus("",aBarCode)
	Set StatusCode=$p(StatusInfo,"^",1)
	Set StatusDesc=$p(StatusInfo,"^",2)
	Set StatusLog=$p(StatusInfo,"^",3)
	
	Set return="1^"_aBarCode_"^"_StatusCode_"^"_StatusDesc_"^"_StatusLog
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-14
/// Description:  环境卫生学监测录入结果
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       BarCode
/// Return：      返回String
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).InputEnviHyResult("8"_$c(1)_"4"_$c(1)_"117"_$c(1)_"9"_$c(1)_"1"_$c(1)_"AAA",$c(1)_","_$c(2),1)
ClassMethod InputEnviHyResult(aInput As %String, aSeparate As %String, aBarCode As %String = "") As %String
{
	New (aInput,aSeparate,aBarCode)
	Set return=0
	Quit:(aInput="") return
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	
	If aBarCode'="" {
		Set ReportID=+$e(aBarCode,2,$l(aBarCode)-2)
		Set SubIndex=+$e(aBarCode,$l(aBarCode)-1,$l(aBarCode))
	} Else {
		Set ReportID=$p(aInput,CHR1,1)
		Set SubIndex=0
	}
	
	Set StatusCode=$p(aInput,CHR1,2)
	Set StatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(StatusCode,"NINFEnviHyReportStatus")
	Set LocID=$p(aInput,CHR1,3)
	Set UserID=$p(aInput,CHR1,4)
	Set Results=$p(aInput,CHR1,5)
	Set Results=$tr(Results,",","，")
	Set Results=$tr(Results,CHR2,",")
	Set Pathogens=$p(aInput,CHR1,6)
	Set Pathogens=$tr(Pathogens,",","，")
	Set Pathogens=$tr(Pathogens,CHR2,",")
	Set AutoIsNorm=""
	
	Set errorInfo="-100^无条码号对应的检测报告!"
	Quit:ReportID<1 errorInfo
	Set objRep=##Class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) errorInfo
	
	//******************************开始******************************
	Set ResultCount=0
	For indRst=1:1:$l(Results,",") {
		Set tmpResult=$p(Results,",",indRst)
		Continue:tmpResult=""
		Set ResultCount=ResultCount+1
	}
	
	//计算环境卫生学检测是否合格
	Set errorInfo="-200^无环境卫生检测项目!"
	Set objItem=objRep.EHRItem
	Quit:'$IsObject(objItem) errorInfo
	Set ItemID=objItem.%Id()
	Set ItemForMula=""  //计算公式
	Set ItemFMId=$o(^DHCMed.NINFD("EHI",ItemID,"FM",""),-1)
	If ItemFMId'="" {
		Set objItemFM=##class(DHCMed.NINF.Dic.EnviHyItmForMula).GetObjById(ItemID_"||"_ItemFMId)
		If $IsObject(objItemFM){
			Set ItemForMula=objItemFM.EHIFForMula
		}
	}
	Set errorInfo="-300^环境卫生检测项目无对应结果判定标准!"
	Set objNorm=objRep.EnviHyNorm
	Quit:'$IsObject(objNorm) errorInfo
	Set NormMax=objNorm.EHNNormMax
	Set NormMin=objNorm.EHNNormMin
	Set SpecimenNum=objNorm.SpecimenNum
	Set CenterNum=objNorm.CenterNum
	Set SurroundNum=objNorm.SurroundNum
	
	Set errorInfo="-400^环境卫生检测条码对应编号与标本数量不符!!"
	Quit:SubIndex>SpecimenNum errorInfo
	
	If SubIndex>0 {
		Set tmpResults=objRep.EHRResult
		Set $p(tmpResults,",",SubIndex)=Results
		Set tmpPathogens=objRep.EHRPathogens
		Set $p(tmpPathogens,",",SubIndex)=Pathogens
		
		Set Results=tmpResults
		Set Pathogens=tmpPathogens
		Set $p(Results,",",SpecimenNum)=$p(Results,",",SpecimenNum)
		
		//修改条码输入结果后，未进行是否合格的判断	by yjf
		For indRst=1:1:$l(objRep.EHRResult,",") {
			Set tmpResult=$p(objRep.EHRResult,",",indRst)
			Continue:tmpResult=""
			Set ResultCount=ResultCount+1
		}
	}
	
	If ResultCount=SpecimenNum {
		Set errorInfo=""  //计算公式错误计算错误
		If (Results'="")||(Pathogens'=""){
			Set AutoIsNorm="合格"
			For indPy=1:1:$l(Pathogens,",") {
				Set tmpPy=+$p(Pathogens,",",indPy)
				Continue:tmpPy="0"
				Set AutoIsNorm="不合格"
			}
			Set (CenterVal,SurroundVal,SpecimenVal)=0
			For indRst=1:1:$l(Results,",") {
				Continue:indRst>SpecimenNum
				Set tmpRst=+$p(Results,",",indRst)
				Continue:tmpRst=""
				Set ErrMsg=""
				Set tmpRst=..GetEnviHyResult(ItemForMula,tmpRst,.ErrMsg)
				Set tmpRst=+tmpRst
				If ErrMsg'="" {
					Set errorInfo=ErrMsg
					Quit
				}
				If ((CenterNum>0)&&(indRst<=CenterNum)){
					Set CenterVal=CenterVal+tmpRst
				} ElseIf ((SurroundNum>0)&&(indRst<=(SurroundNum+CenterNum))){
					Set SurroundVal=SurroundVal+tmpRst
				} ElseIf ((CenterNum>0)||(SurroundNum>0)) {
					//参照值
				} else {
					Set SpecimenVal=SpecimenVal+tmpRst
				}
			}
			If (CenterNum>0) {
				Set:(CenterVal/CenterNum)>NormMax AutoIsNorm="不合格"      //中心值
			}
			If (SurroundNum>0) {
				Set:(SurroundVal/SurroundNum)>NormMin AutoIsNorm="不合格"  //周边值
			}
			If (CenterNum<1)&&(SurroundNum<1) {
				Set:(SpecimenVal/SpecimenNum)>NormMax AutoIsNorm="不合格"  //检测值
			}
		}
		Quit:errorInfo'="" errorInfo
	}
	//*****************************结束*******************************
	
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReport).%OpenId(ReportID)
	Quit:'$IsObject(obj) return
	
	Set obj.EHRResult     = Results
	Set obj.EHRPathogens  = Pathogens
	Set obj.EHRAutoIsNorm = AutoIsNorm
	Set obj.EHRRepStatus  = ##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set obj.EHRRepLoc     = LocID
	Set obj.EHRRepUser    = UserID
	Set obj.EHRRepDate    = +$h  
	Set obj.EHRRepTime    = $p($h,",",2)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Set return="-1^录入结果保存失败!"
	} Else {
		Set return=obj.%Id()
		
		Set inputStatus=obj.%Id()_"^"_LocID_"^"_UserID_"^"_StatusID_"^"_""_"^"_aBarCode
		Set flg=##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(inputStatus,"^")
	}
	If obj'="" Do obj.%Close()
	
	Quit return
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

/// Creator：     yhb
/// CreatDate：   2013-11-28
/// Description:  保存环境卫生学报告状态、结果并在日志中记录【录入结果、材料发放】
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       DHCMed.NINF.Rep.EnviHyReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).SetResultIsNorm("108^3_4_5^合格^4","^")
ClassMethod SetResultIsNorm(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set CHR1=aSeparate
	
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReport).GetObjById($p(aInput,CHR1,1))
	Quit:'$IsObject(obj) return
	
	if ($p(aInput,CHR1,2)'=""){
		Set obj.EHRResult = $p(aInput,CHR1,2)
		Set obj.EHRPathogens = $p(aInput,CHR1,7)
	}
	if ($p(aInput,CHR1,3)'=""){
		Set obj.EHRAutoIsNorm = $p(aInput,CHR1,3)	
	}
	Set EHRRepStatusCode=$p(aInput,CHR1,4)
	if (EHRRepStatusCode=2){  //发放标本
		Set obj.SpecimenNum = obj.EnviHyNorm.SpecimenNum
	}
	if (EHRRepStatusCode=3){  //接收标本
		Set obj.EHRReceiveDate =+$h 
		Set obj.EHRReceiveTime =$p($h,",",2) 
	}
	Set EHRRepStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EHRRepStatusCode,"NINFEnviHyReportStatus")
	Set obj.EHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(EHRRepStatusID)
	Set obj.EHRRepLoc=$p(aInput,CHR1,5)
	Set obj.EHRRepUser=$p(aInput,CHR1,6)
	Set obj.EHRRepDate=+$h  
	Set obj.EHRRepTime=$p($h,",",2) 
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set StatStr = $p(aInput,CHR1,1)_"^"_$p(aInput,CHR1,5)_"^"_$p(aInput,CHR1,6)_"^"_EHRRepStatusID_"^"
		Set flg=##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(StatStr,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yhb
/// CreatDate：   2013-12-02
/// Description:  保存环境卫生学报告补发标本数量日志中记录
/// Table：       DHCMed.NINF.Rep.EnviHyReport
/// Input：       DHCMed.NINF.Rep.EnviHyReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.EnviHyReport).SetAddSpecimenNum("108^3_4_5^合格^4","^")
ClassMethod SetAddSpecimenNum(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set CHR1=aSeparate
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReport).GetObjById($p(aInput,CHR1,1))
	Quit:'$IsObject(obj) return
	Set obj.AddSpecimenNum = $p(aInput,CHR1,2)
	Set StatStr = $p(aInput,CHR1,1)_"^"_$p(aInput,CHR1,3)_"^"_$p(aInput,CHR1,4)_"^"_obj.EHRRepStatus.%Id()_"^补发标本"
	d ##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update(StatStr,"^")
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Set return=-1
	} Else {
		Set return=obj.%Id()	
	}
	Do obj.%Close()
	Quit return
}

/// w ##Class(DHCMed.NINF.Rep.EnviHyReport).GetStatusByID(10)
ClassMethod GetStatusByID(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=..GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHRRepStatus) return
	Set StatusCode=objRep.EHRRepStatus.Code
	Set StatusDesc=objRep.EHRRepStatus.Description
	
	Set $p(return,"^",1)=aReportID
	Set $p(return,"^",2)=StatusCode
	Set $p(return,"^",3)=StatusDesc
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>""</Value>
</Value>
<Value name="3">
<Value>EHRItem</Value>
</Value>
<Value name="4">
<Value>EHRDate</Value>
</Value>
<Value name="5">
<Value>""</Value>
</Value>
<Value name="6">
<Value>EHRResult</Value>
</Value>
<Value name="7">
<Value>EHRPathogens</Value>
</Value>
<Value name="8">
<Value>EHRRepDate</Value>
</Value>
<Value name="9">
<Value>EHRRepTime</Value>
</Value>
<Value name="10">
<Value>EHRRepLoc</Value>
</Value>
<Value name="11">
<Value>EHRRepUser</Value>
</Value>
<Value name="12">
<Value>EHRRepStatus</Value>
</Value>
<Value name="13">
<Value>EHRResume</Value>
</Value>
<Value name="14">
<Value>EnviHyNorm</Value>
</Value>
<Value name="15">
<Value>EHRAutoIsNorm</Value>
</Value>
<Value name="16">
<Value>EHRBarCode</Value>
</Value>
<Value name="17">
<Value>SpecimenType</Value>
</Value>
<Value name="18">
<Value>SpecimenNum</Value>
</Value>
<Value name="19">
<Value>EHRItemObj</Value>
</Value>
<Value name="20">
<Value>AddSpecimenNum</Value>
</Value>
<Value name="21">
<Value>EHRAskForDate</Value>
</Value>
<Value name="22">
<Value>EHRAskForTime</Value>
</Value>
<Value name="23">
<Value>EHRAskForLoc</Value>
</Value>
<Value name="24">
<Value>EHRAskForUser</Value>
</Value>
<Value name="25">
<Value>EHRReceiveDate</Value>
</Value>
<Value name="26">
<Value>EHRReceiveTime</Value>
</Value>
<Value name="27">
<Value>EHRItemForMula</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("EnviRep")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("EnviRep")</IdLocation>
<IndexLocation>^DHCMed.NINFi("EnviRep",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.EnviHyReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
