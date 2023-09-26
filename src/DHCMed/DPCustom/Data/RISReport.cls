/// 名称: DHCMed.DPCustom.Data.RISReport
/// 描述: 与RIS相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-04-17
Class DHCMed.DPCustom.Data.RISReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID（StudyNo）
Property RecordID As %String(TRUNCATE = 1);

/// 医嘱ID
Property OEItemID As %String(TRUNCATE = 1);

/// 医嘱代码
Property OEItemCode As %String(TRUNCATE = 1);

/// 医嘱名称
Property OEItemDesc As %String(TRUNCATE = 1);

/// 检查号
Property StudyNo As %String(TRUNCATE = 1);

/// 检查所见
Property ExamDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 诊断意见
Property ResultDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 登记日期
Property RegDate As %String(TRUNCATE = 1);

/// 登记时间
Property RegTime As %String(TRUNCATE = 1);

/// 登记医生代码
Property RegUser As %String(TRUNCATE = 1);

/// 登记医生姓名
Property RegUserDesc As %String(TRUNCATE = 1);

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告时间
Property ReportTime As %String(TRUNCATE = 1);

/// 报告医生代码
Property RepUser As %String(TRUNCATE = 1);

/// 报告医生姓名
Property RepUserDesc As %String(TRUNCATE = 1);

/// 报告日期
Property ActDate As %String(TRUNCATE = 1);

/// 报告时间
Property ActTime As %String(TRUNCATE = 1);

/// 报告医生代码
Property ActUser As %String(TRUNCATE = 1);

/// 报告医生姓名
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.RISReport).GetDataByAdm("3211253","","","RIS-CHESTITM")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aActWords As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aActWords)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-RISReport","")
	Set DataType=+DataType
	
	If DataType=1 {
		//DataType=1 默认取值HIS检查项目结果
		
	} Else {
		//DataType=0 默认取值HIS检查项目结果
		Set OEOrdType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdType","")
		Set OEOrdType=+OEOrdType
		
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" return
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:(ArcimType="L")||(ArcimType="R")
		 	
		 	//关键字筛查相关检查项目
			If aActWords'="" {
				//常用短语筛查（包含）
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check1(aActWords,objArcim.ARCIMDesc)
				Continue:checkFlag=""
			}
			
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSubID=0
				For {
					Set xSubID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSubID))
					Quit:xSubID=""
					
				 	Set OEItemID=OrdID_"||"_xSubID
					If OEOrdType=0 { //滚执行记录模式
						Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem7(OEItemID)=0)
					} ElseIf OEOrdType=1 {  //滚医嘱模式
					 	Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem(OEItemID)=0)
					} Else {
						Continue
					}
					
				 	Set PACRegID=$o(^DHCPACRegInfoi("OEORI",OEItemID,0))
				    Continue:PACRegID=""
				    Set StudyNo=$p($g(^DHCPACRegInfo(PACRegID)),"^",2)
				    Continue:StudyNo=""
				    
			 		Set obj=..GetObjById0(StudyNo)
			 		Continue:'$IsObject(obj)
					
					Set ActDate=obj.ActDate
					Continue:ActDate=""
					Set tmpDate=ActDate
					Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
					Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
					Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
					Continue:(aDateTo'="")&&(tmpDate>aDateTo)
					
			    	//Do $system.OBJ.Dump(obj)
					Do return.Insert(obj)
				}
			}
		}
	}
	Do return.%Close()
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.RISReport).GetDataByID("372644||A010||1")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.RISReport
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-RISReport","")
	Set DataType=+DataType
	
	If DataType=1 {
		//DataType=1 默认取值HIS检查项目结果
		
	} Else {
		//DataType=0 默认取值HIS检查项目结果
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象(DHCRB_RegInfo)
/// w ##Class(DHCMed.DPCustom.Data.RISReport).GetObjById0()
ClassMethod GetObjById0(aStudyNo As %String) As DHCMed.DPCustom.Data.RISReport
{
	New (aStudyNo)
	Set return=""
	Quit:aStudyNo="" return
	
	Set StudyNo=aStudyNo
	Set ReportID=""
	Set xReportID=0
	For {
		Set xReportID=$o(^DHCRBStudyi("Report","StudyNo",aStudyNo,xReportID))
		Quit:xReportID=""
		Set ReportID=xReportID
	}
    Quit:ReportID="" return
    
    //状态检查  V,已审核  S,已发布
    Set RISItemStatus=$p($g(^DHCRBStudy("Report",ReportID)),"^",4)
    Set RISItemStatus=$p($g(^DHCRBCStatus("ReportStatus",+RISItemStatus)),"^",1)
    Quit:(RISItemStatus'="V")&&(RISItemStatus'="S") return
    
	Set RepDate=$p($g(^DHCRBStudy("Report",ReportID)),"^",9)
	Set RepTime=$p($g(^DHCRBStudy("Report",ReportID)),"^",10)
	Quit:(RepDate="")||(RepTime="") return
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepTime'="" RepTime=$zt(RepTime,1)
    Set RepUser=$p($g(^DHCRBStudy("Report",ReportID)),"^",8)
	Set RepUserDesc=""
	If RepUser'="" {
		Set RepUserDesc=$p($g(^SSU("SSUSR",RepUser)),"^",2)
	}
	
    Set ExamDesc=$g(^DHCRBStudy("Report",ReportID,"ExamDescEx"))      //检查所见
    Set ResultDesc=$g(^DHCRBStudy("Report",ReportID,"ResultDescEx"))  //诊断意见
    
	Set PACRegID=$o(^DHCPACRegInfoi("StudyNo",aStudyNo,0))
    Quit:PACRegID="" return
    Set OEItemID=$p($g(^DHCPACRegInfo(PACRegID)),"^",11)
    Quit:OEItemID="" return
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objOEItem) return
	
	Set RegDate=$p($g(^DHCPACRegInfo(PACRegID)),"^",8)
	Set RegTime=$p($g(^DHCPACRegInfo(PACRegID)),"^",9)
	Set:RegDate'="" RegDate=$zd(RegDate,3)
	Set:RegTime'="" RegTime=$zt(RegTime,1)
    Set RegUser=$p($g(^DHCPACRegInfo(PACRegID)),"^",7)
	Set RegUserDesc=""
	If RegUser'="" {
		Set RegUserDesc=$p($g(^SSU("SSUSR",RegUser)),"^",2)
	}
	
	//记录ID、记录日期、记录时间、记录人
	Set RecordID=StudyNo          //检查号
	Set ActDate=RepDate           //报告日期
	Set ActTime=RepTime           //报告时间
	Set ActUser=RepUser           //报告人
	Set ActUserDesc=RepUserDesc
	
	Set obj=##Class(DHCMed.DPCustom.Data.RISReport).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = RecordID
	Set obj.StudyNo        = StudyNo
	Set obj.OEItemID       = OEItemID
	Set obj.OEItemCode     = objOEItem.ARCIMCode
	Set obj.OEItemDesc     = objOEItem.ARCIMDesc
	Set obj.ExamDesc       = ExamDesc
	Set obj.ResultDesc     = ResultDesc
	Set obj.RegDate        = RegDate
	Set obj.RegTime        = RegTime
	Set obj.RegUser        = RegUser
	Set obj.RegUserDesc    = RegUserDesc
	Set obj.ReportDate     = RepDate
	Set obj.ReportTime     = RepTime
	Set obj.RepUser        = RepUser
	Set obj.RepUserDesc    = RepUserDesc
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

}
