/// 名称: DHCWMR.MRService.ImportDataByEmr
/// 描述: 导入东华电子病历数据接口服务
/// 编写者：zhufei
/// 编写日期: 2015-08-27
Class DHCWMR.MRService.ImportDataByEmr Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  导入东华住院病案首页数据接口服务
/// Table：       
/// Input：       aFromDate ：开始日期
///               aToDate ：结束日期
/// Return：      return=0:失败，return=1:成功
/// w ##class(DHCWMR.MRService.ImportDataByEmr).Task()
ClassMethod Task(aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aMrTypeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aMrTypeID="")||(aDateFrom="")||(aDateTo="") return
	
	Set xMrTypeID=0
	For {
		Set xMrTypeID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID))
		Quit:xMrTypeID=""
		
		If aMrTypeID'="" {
			Continue:xMrTypeID'=aMrTypeID
		} Else {
			Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(xMrTypeID)
			Continue:'$IsObject(objMrType)
			Continue:objMrType.MTMrClass.MCCode'="I"
		}
		
		Set xItemID=0
		For {
			Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID))
			Quit:xItemID=""
			
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(xMrTypeID,xItemID)
			Continue:'$IsObject(objWFItem)
			Continue:objWFItem.WFISysOpera'="RC"
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID,xDate,xTime,xID))
						Quit:xID=""
						
						Set objOperation=##class(DHCWMR.SS.Operation).GetObjById(xID)
						Continue:'$IsObject(objOperation)
						Set BatchNumber=objOperation.OPBatchNumber
						
						Set xVolID=0
						For {
							Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
							Quit:xVolID=""
							
							//检查卷操作是否有效
							Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
							Continue:xSub=""
							Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
							Continue:'$IsObject(objVolStatus)
							Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
							
							Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
							Continue:EpisodeID=""
							
							Set InputStr=""
							Set $p(InputStr,"^",1)=EpisodeID
							Set $p(InputStr,"^",11)=objVolStatus.VSActDate
							Set $p(InputStr,"^",12)=objVolStatus.VSActTime
							Set $p(InputStr,"^",13)=1
							Set MRFpID=##class(DHCWMR.MRService.FrontPageSrv).Save(InputStr)
							If MRFpID<1 {
								Set ErrCode="-100"
								Set ErrText="主记录更新错误"
								Set Error="##class(DHCWMR.MRService.FrontPageSrv).Save("""_InputStr_""")"
								Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,"")
								Continue
							}
							
							Set Count=Count+1
							Set flg=..SaveRowData(MRFpID,EpisodeID)
							
						}
					}
				}
			}
		}
	}
	
	
	Quit Count
}

ClassMethod SaveRowData(aMRFpID As %String, aEpisodeID As %String) As %String
{
	new (aMRFpID,aEpisodeID)
	Set return=0
	Quit:(aMRFpID="")||(aEpisodeID="") return
	
	Set %Version="3"
	Set %MRType="XY"
	Set %EpisodeID=aEpisodeID
	Set %ArrData=""
	If %Version=3 {
		If %MRType="XY" {
			Set %ArrData=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(%EpisodeID,"HDSD00.11")
		} Else {
			Set %ArrData=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(%EpisodeID,"HDSD00.12")
		}
	}
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)   = ..GetEMRData("HDSD00.11.118","HDSD00.12.133")    //医疗机构名称
    Set $p(InputStr,"^",4)   = ..GetEMRData("HDSD00.11.119","HDSD00.12.134")    //医疗机构组织机构代码
    Set $p(InputStr,"^",5)   = ..GetEMRData("HDSD00.11.585","HDSD00.12.585")    //医疗付费方式
    Set $p(InputStr,"^",6)   = ..GetEMRData("HDSD00.11.117","HDSD00.12.132")    //医疗付费方式代码
    Set $p(InputStr,"^",7)   = ..GetEMRData("HDSD00.11.053","HDSD00.12.060")    //健康卡号
    Set $p(InputStr,"^",8)   = ..GetEMRData("HDSD00.11.139","HDSD00.12.166")    //住院次数
    Set $p(InputStr,"^",9)   = ..GetEMRData("HDSD00.11.006","HDSD00.12.007")    //病案号
    Set $p(InputStr,"^",10)  = ..GetEMRData("HDSD00.11.110","HDSD00.12.125")    //姓名
    Set $p(InputStr,"^",11)  = ..GetEMRData("HDSD00.11.586","HDSD00.12.586")    //性别
    Set $p(InputStr,"^",12)  = ..GetEMRData("HDSD00.11.109","HDSD00.12.124")    //性别代码
    Set $p(InputStr,"^",13)  = ..GetEMRData("HDSD00.11.014","HDSD00.12.015")    //出生日期
    Set $p(InputStr,"^",14)  = ..GetEMRData("HDSD00.11.079","HDSD00.12.090")    //年龄（岁）
    Set $p(InputStr,"^",15)  = ..GetEMRData("HDSD00.11.080","HDSD00.12.091")    //年龄（月）
    //..GetEMRData("HDSD00.11.807","HDSD00.12.807")  //年龄（天）
	//..GetEMRData("HDSD00.11.808","HDSD00.12.808")  //年龄（小时）
    //..GetEMRData("HDSD00.11.1227","HDSD00.12.1227")  //年龄（分钟）
    Set $p(InputStr,"^",16)  = ..GetEMRData("HDSD00.11.563","HDSD00.12.563")    //国籍描述
    Set $p(InputStr,"^",17)  = ..GetEMRData("HDSD00.11.036","HDSD00.12.043")    //国籍代码
    Set $p(InputStr,"^",18)  = ..GetEMRData("HDSD00.11.107","HDSD00.12.122")    //新生儿出生体重（g）
    Set $p(InputStr,"^",19)  = ..GetEMRData("HDSD00.11.108","HDSD00.12.123")    //新生儿入院体重（g）
    Set $p(InputStr,"^",20)  = ""  //出生地-详细地址
    Set $p(InputStr,"^",21)  = ..GetEMRData("HDSD00.11.011","HDSD00.12.012")    //出生地-省（自治区、直辖市）
    Set $p(InputStr,"^",22)  = ""  //出生地-省（区、市）编码
    Set $p(InputStr,"^",23)  = ..GetEMRData("HDSD00.11.012","HDSD00.12.013")    //出生地-市（地区、州）
    Set $p(InputStr,"^",24)  = ""  //出生地-市编码
    Set $p(InputStr,"^",25)  = ..GetEMRData("HDSD00.11.013","HDSD00.12.014")    //出生地-县（区）
    Set $p(InputStr,"^",26)  = ""  //出生地-县编码
    Set $p(InputStr,"^",27)  = ""  //籍贯-详细地址
    Set $p(InputStr,"^",28)  = ..GetEMRData("HDSD00.11.051","HDSD00.12.058")    //籍贯-省（自治区、直辖市）
    Set $p(InputStr,"^",29)  = ""  //籍贯-省（区、市）编码
    Set $p(InputStr,"^",30)  = ..GetEMRData("HDSD00.11.052","HDSD00.12.059")    //籍贯-市（地区、州）
    Set $p(InputStr,"^",31)  = ""  //籍贯-市编码
    Set $p(InputStr,"^",32)  = ..GetEMRData("HDSD00.11.590","HDSD00.12.590")    //民族
    Set $p(InputStr,"^",33)  = ..GetEMRData("HDSD00.11.077","HDSD00.12.088")    //民族代码
    Set $p(InputStr,"^",34)  = ..GetEMRData("HDSD00.11.048","HDSD00.12.055")    //患者身份证件号码
    Set $p(InputStr,"^",35)  = ..GetEMRData("HDSD00.11.564","HDSD00.12.564")    //职业描述
    Set $p(InputStr,"^",36)  = ..GetEMRData("HDSD00.11.125","HDSD00.12.140")    //职业类别代码
    Set $p(InputStr,"^",37)  = ..GetEMRData("HDSD00.11.587","HDSD00.12.587")    //婚姻状况
    Set $p(InputStr,"^",38)  = ..GetEMRData("HDSD00.11.050","HDSD00.12.057")    //婚姻状况代码
    
    Set tmpData1=..GetEMRData("HDSD00.11.102","HDSD00.12.117")  //现住址-省（自治区、直辖市）
	Set tmpData2=..GetEMRData("HDSD00.11.103","HDSD00.12.118")  //现住址-市（地区、州）
	Set tmpData3=..GetEMRData("HDSD00.11.104","HDSD00.12.119")  //现住址-县（区）
    Set tmpData4=..GetEMRData("HDSD00.11.105","HDSD00.12.120")  //现住址-乡（镇、街道办事处）
	Set tmpData5=..GetEMRData("HDSD00.11.100","HDSD00.12.115")  //现住址-村（街、路、弄等）
	Set tmpData6=..GetEMRData("HDSD00.11.101","HDSD00.12.116")  //现住址-门牌号码
    Set $p(InputStr,"^",39)  = tmpData1_tmpData2_tmpData3_tmpData4_tmpData5_tmpData6  //现住址-详细地址
    //..GetEMRData("HDSD00.11.1230","")  //现住址-完整地址
    Set $p(InputStr,"^",40)  = tmpData1                                         //现住址-省（自治区、直辖市）
    Set $p(InputStr,"^",41)  = ""  //现住址-省（区、市）编码
    Set $p(InputStr,"^",42)  = tmpData2                                         //现住址-市（地区、州）
    Set $p(InputStr,"^",43)  = ""  //现住址-市编码
    Set $p(InputStr,"^",44)  = tmpData3                                         //现住址-县（区）
    Set $p(InputStr,"^",45)  = ""  //现住址-县编码
    Set $p(InputStr,"^",46)  = tmpData4_tmpData5_tmpData6                       //现住址-其他
    Set $p(InputStr,"^",47)  = ..GetEMRData("HDSD00.11.026","HDSD00.12.033")    //电话号码
    Set $p(InputStr,"^",48)  = ..GetEMRData("HDSD00.11.106","HDSD00.12.121")    //现住址-邮政编码
    
    Set tmpData1=..GetEMRData("HDSD00.11.043","HDSD00.12.050")  //户口地址-省（自治区、直辖市）
    Set tmpData2=..GetEMRData("HDSD00.11.044","HDSD00.12.051")  //户口地址-市（地区、州）
    Set tmpData3=..GetEMRData("HDSD00.11.045","HDSD00.12.052")  //户口地址-县（区）
    Set tmpData4=..GetEMRData("HDSD00.11.046","HDSD00.12.053")  //户口地址-乡（镇、街道办事处）
    Set tmpData5=..GetEMRData("HDSD00.11.041","HDSD00.12.048")  //户口地址-村（街、路、弄等）
    Set tmpData6=..GetEMRData("HDSD00.11.042","HDSD00.12.049")  //户口地址-门牌号码
    Set $p(InputStr,"^",49)  = tmpData1_tmpData2_tmpData3_tmpData4_tmpData5_tmpData6  //户口地址-详细地址
    //..GetEMRData("HDSD00.11.1229","")  //户口地址-完整地址
    Set $p(InputStr,"^",50)  = tmpData1                                         //户口地址-省（区、市）
    Set $p(InputStr,"^",51)  = ""  //户口地址-省（区、市）编码
    Set $p(InputStr,"^",52)  = tmpData2                                         //户口地址-市
    Set $p(InputStr,"^",53)  = ""  //户口地址-市编码
    Set $p(InputStr,"^",54)  = tmpData3                                         //户口地址-县
    Set $p(InputStr,"^",55)  = ""  //户口地址-县编码
    Set $p(InputStr,"^",56)  = tmpData4_tmpData5_tmpData6                       //户口地址-其他
    Set $p(InputStr,"^",57)  = ..GetEMRData("HDSD00.11.047","HDSD00.12.054")    //户口地址-邮政编码
    
    Set $p(InputStr,"^",58)  = ..GetEMRData("HDSD00.11.1191","HDSD00.12.1191")  //工作单位及地址
    Set $p(InputStr,"^",59)  = ..GetEMRData("HDSD00.11.034","HDSD00.12.041")    //工作单位电话号码
    Set $p(InputStr,"^",60)  = ..GetEMRData("HDSD00.11.033","HDSD00.12.040")    //工作单位地址-邮政编码
    
    Set $p(InputStr,"^",61)  = ..GetEMRData("HDSD00.11.065","HDSD00.12.072")    //联系人姓名
    Set $p(InputStr,"^",62)  = ..GetEMRData("HDSD00.11.562","HDSD00.12.562")    //联系人与患者的关系描述
    Set $p(InputStr,"^",63)  = ..GetEMRData("HDSD00.11.066","HDSD00.12.073")    //联系人与患者的关系代码
    Set $p(InputStr,"^",64)  = ..GetEMRData("HDSD00.11.565","HDSD00.12.565")    //联系人地址-完整地址
    Set $p(InputStr,"^",65)  = ..GetEMRData("HDSD00.11.064","HDSD00.12.071")    //联系人电话号码
    Set $p(InputStr,"^",66)  = ..GetEMRData("HDSD00.11.591","HDSD00.12.591")    //入院途径
    Set $p(InputStr,"^",67)  = ..GetEMRData("HDSD00.11.086","HDSD00.12.097")    //入院途径代码
    Set $p(InputStr,"^",68)  = ""  //治疗类别
    Set $p(InputStr,"^",69)  = ..GetEMRData("","HDSD00.12.144")                 //治疗类别代码
    
    Set tmpData=..GetEMRData("HDSD00.11.085","HDSD00.12.096")  //入院日期时间
    Set $p(InputStr,"^",70)  = $p(tmpData," ",1)                                //入院日期
    Set $p(InputStr,"^",71)  = $p(tmpData," ",2)                                //入院时间(时)
    
    Set $p(InputStr,"^",72)  = ..GetEMRData("HDSD00.11.084","HDSD00.12.095")    //入院科别
    Set $p(InputStr,"^",73)  = ..GetEMRData("HDSD00.11.1004","HDSD00.12.1004")  //入院科别代码
    Set $p(InputStr,"^",74)  = ..GetEMRData("HDSD00.11.083","HDSD00.12.094")    //入院病房
    Set $p(InputStr,"^",75)  = ""  //入院病房编码
    Set $p(InputStr,"^",76)  = ..GetEMRData("HDSD00.11.144","HDSD00.12.171")    //转科科别
    Set $p(InputStr,"^",77)  = ""  //转科科别编码
    
    Set tmpData=..GetEMRData("HDSD00.11.019","HDSD00.12.020")  //出院日期时间
    Set $p(InputStr,"^",78)  = $p(tmpData," ",1)                                //出院日期
    Set $p(InputStr,"^",79)  = $p(tmpData," ",2)                                //出院时间(时)
    
    Set $p(InputStr,"^",80)  = ..GetEMRData("HDSD00.11.018","HDSD00.12.019")    //出院科别
    Set $p(InputStr,"^",81)  = ..GetEMRData("HDSD00.11.1005","HDSD00.12.1005")  //出院科别代码
    Set $p(InputStr,"^",82)  = ..GetEMRData("HDSD00.11.017","HDSD00.12.018")    //出院病房
    Set $p(InputStr,"^",83)  = ""  //出院病房编码
    Set $p(InputStr,"^",84)  = ..GetEMRData("HDSD00.11.087","HDSD00.12.098")    //实际住院天数
    Set $p(InputStr,"^",85)  = ..GetEMRData("","HDSD00.12.2000")                //实施临床路径
    Set $p(InputStr,"^",86)  = ..GetEMRData("","HDSD00.12.099")                 //实施临床路径标志代码
    Set $p(InputStr,"^",87)  = ..GetEMRData("","HDSD00.12.101")  //使用医疗机构中药制剂标志
    //..GetEMRData("","HDSD00.12.2001")  //使用医疗机构中药制剂
    Set $p(InputStr,"^",88)  = ..GetEMRData("","HDSD00.12.103")  //使用中医诊疗设备标志
	//..GetEMRData("","HDSD00.12.2002")  //使用中医诊疗设备
    Set $p(InputStr,"^",89)  = ..GetEMRData("","HDSD00.12.102")  //使用中医诊疗技术标志
	//..GetEMRData("","HDSD00.12.2003")  //使用中医诊疗技术
    Set $p(InputStr,"^",90)  = ..GetEMRData("","HDSD00.12.006")  //辨证施护标志
	//..GetEMRData("","HDSD00.12.2004")  //辨证施护
    Set $p(InputStr,"^",91)  = ..GetEMRData("HDSD00.11.884","HDSD00.12.884")    //入院情况描述
    Set $p(InputStr,"^",92)  = ..GetEMRData("HDSD00.11.883","HDSD00.12.883")    //入院情况代码
    Set $p(InputStr,"^",93)  = ..GetEMRData("HDSD00.11.876","HDSD00.12.876")    //入院后确诊日期
    Set $p(InputStr,"^",94)  = ..GetEMRData("HDSD00.11.008","HDSD00.12.009")    //病理号
    Set $p(InputStr,"^",95)  = ""  //病理号2
    Set $p(InputStr,"^",96)  = ""  //病理号3
    Set $p(InputStr,"^",97)  = ..GetEMRData("HDSD00.11.890","HDSD00.12.890")    //HBs-Ag描述
    Set $p(InputStr,"^",98)  = ..GetEMRData("HDSD00.11.889","HDSD00.12.889")    //HBs-Ag代码
    Set $p(InputStr,"^",99)  = ..GetEMRData("HDSD00.11.888","HDSD00.12.888")    //HCV-Ab描述
    Set $p(InputStr,"^",100) = ..GetEMRData("HDSD00.11.887","HDSD00.12.887")    //HCV-Ab代码
    Set $p(InputStr,"^",101) = ..GetEMRData("HDSD00.11.886","HDSD00.12.886")    //HIV-Ab描述
    Set $p(InputStr,"^",102) = ..GetEMRData("HDSD00.11.885","HDSD00.12.885")    //HIV-Ab代码
    Set $p(InputStr,"^",103) = ..GetEMRData("HDSD00.11.773","HDSD00.12.773")    //门诊与出院
    Set $p(InputStr,"^",104) = ..GetEMRData("HDSD00.11.774","HDSD00.12.774")    //门诊与出院代码
    Set $p(InputStr,"^",105) = ..GetEMRData("HDSD00.11.775","HDSD00.12.775")    //入院与出院
    Set $p(InputStr,"^",106) = ..GetEMRData("HDSD00.11.776","HDSD00.12.776")    //入院与出院代码
    Set $p(InputStr,"^",107) = ..GetEMRData("HDSD00.11.777","HDSD00.12.777")    //术前与术后
    Set $p(InputStr,"^",108) = ..GetEMRData("HDSD00.11.778","HDSD00.12.778")    //术前与术后代码
    Set $p(InputStr,"^",109) = ..GetEMRData("HDSD00.11.779","HDSD00.12.779")    //临床与病理
    Set $p(InputStr,"^",110) = ..GetEMRData("HDSD00.11.780","HDSD00.12.780")    //临床与病理代码
    Set $p(InputStr,"^",111) = ..GetEMRData("HDSD00.11.781","HDSD00.12.781")    //放射与病理
    Set $p(InputStr,"^",112) = ..GetEMRData("HDSD00.11.782","HDSD00.12.782")    //放射与病理代码
    //..GetEMRData("HDSD00.11.963","HDSD00.12.963")  //入院与出院诊断符合情况
	//..GetEMRData("HDSD00.11.964","HDSD00.12.964")  //门诊与出院诊断符合情况
	//..GetEMRData("HDSD00.11.965","HDSD00.12.965")  //临床与病理诊断符合情况
	//..GetEMRData("HDSD00.11.966","HDSD00.12.966")  //放射与病理诊断符合情况
	//..GetEMRData("HDSD00.11.817","HDSD00.12.817")  //术前诊断与术后病理诊断符合情况
	//..GetEMRData("HDSD00.11.818","HDSD00.12.818")  //术前诊断与术后病理诊断符合情况代码
	//..GetEMRData("","HDSD00.12.2034")  //术前与术后诊断符合情况
	//..GetEMRData("","HDSD00.12.2035")  //中医入院与出院诊断符合情况
	//..GetEMRData("","HDSD00.12.2036")  //中医门诊与出院诊断符合情况
	//..GetEMRData("","HDSD00.12.2037")  //临床与病理诊断符合情况
	//..GetEMRData("","HDSD00.12.2038")  //放射与病理诊断符合情况
	//..GetEMRData("","HDSD00.12.2039")  //西医入院与出院诊断符合情况
	//..GetEMRData("","HDSD00.12.2040")  //西医门诊与出院诊断符合情况
    Set $p(InputStr,"^",113) = ..GetEMRData("HDSD00.11.569","HDSD00.12.569")    //抢救次数
    Set $p(InputStr,"^",114) = ..GetEMRData("HDSD00.11.570","HDSD00.12.570")    //成功次数
    Set $p(InputStr,"^",115) = ..GetEMRData("HDSD00.11.116","HDSD00.12.131")    //药物过敏标志
	//..GetEMRData("HDSD00.11.566","HDSD00.12.566")  //有无药物过敏
    Set $p(InputStr,"^",116) = ..GetEMRData("HDSD00.11.037","HDSD00.12.044")    //过敏药物
    Set $p(InputStr,"^",117) = ..GetEMRData("HDSD00.11.095","HDSD00.12.110")    //死亡患者尸检标志
    //..GetEMRData("HDSD00.11.596","HDSD00.12.596")  //死亡患者尸检
    Set $p(InputStr,"^",118) = ..GetEMRData("HDSD00.11.896","HDSD00.12.896")    //手术、治疗、检查、诊断是否为本院第一例
    Set $p(InputStr,"^",119) = ..GetEMRData("HDSD00.11.571","HDSD00.12.571")    //是否随诊
    Set tmpData=..GetEMRData("HDSD00.11.572","HDSD00.12.572")  //随诊期限
    Set $p(InputStr,"^",120) = ..GetEMRData("HDSD00.11.993","HDSD00.12.993")    //随诊年数
    Set $p(InputStr,"^",121) = ..GetEMRData("HDSD00.11.992","HDSD00.12.992")    //随诊月数
    Set $p(InputStr,"^",122) = ..GetEMRData("HDSD00.11.991","HDSD00.12.991")    //随诊周数
    Set $p(InputStr,"^",123) = ..GetEMRData("HDSD00.11.891","HDSD00.12.891")    //示教病历
    Set $p(InputStr,"^",124) = ..GetEMRData("HDSD00.11.597","HDSD00.12.597")    //ABO血型
    Set $p(InputStr,"^",125) = ..GetEMRData("HDSD00.11.003","HDSD00.12.003")    //ABO血型代码
    Set $p(InputStr,"^",126) = ..GetEMRData("HDSD00.11.598","HDSD00.12.598")    //Rh血型
    Set $p(InputStr,"^",127) = ..GetEMRData("HDSD00.11.004","HDSD00.12.004")    //Rh血型代码
    Set $p(InputStr,"^",128) = ..GetEMRData("HDSD00.11.602","HDSD00.12.602")    //是否有输血反应代码
    //..GetEMRData("HDSD00.11.601","HDSD00.12.601")  //是否有输血反应
    Set $p(InputStr,"^",129) = ..GetEMRData("HDSD00.11.994","HDSD00.12.994")    //红细胞
    Set $p(InputStr,"^",130) = ..GetEMRData("HDSD00.11.995","HDSD00.12.995")    //血小板
    Set $p(InputStr,"^",131) = ..GetEMRData("HDSD00.11.996","HDSD00.12.996")    //血浆
    Set $p(InputStr,"^",132) = ..GetEMRData("HDSD00.11.997","HDSD00.12.997")    //全血
    Set $p(InputStr,"^",133) = ..GetEMRData("HDSD00.11.999","HDSD00.12.999")    //其它_输血
    Set $p(InputStr,"^",134) = ..GetEMRData("HDSD00.11.056","HDSD00.12.063")    //科主任签名
	//..GetEMRData("HDSD00.11.575","HDSD00.12.575")  //科主任签名代码
    Set $p(InputStr,"^",135) = ..GetEMRData("HDSD00.11.137","HDSD00.12.164")    //主任（副主任）医师签名
	//..GetEMRData("HDSD00.11.576","HDSD00.12.576")  //主任（副主任）医师签名代码
    Set $p(InputStr,"^",136) = ..GetEMRData("HDSD00.11.138","HDSD00.12.165")    //主治医师签名
	//..GetEMRData("HDSD00.11.577","HDSD00.12.577")  //主治医师代码
    Set $p(InputStr,"^",137) = ..GetEMRData("HDSD00.11.141","HDSD00.12.168")    //住院医师签名
	//..GetEMRData("HDSD00.11.578","HDSD00.12.578")  //住院医师代码
    Set $p(InputStr,"^",138) = ..GetEMRData("HDSD00.11.120","HDSD00.12.135")    //责任护士签名
	//..GetEMRData("HDSD00.11.579","HDSD00.12.579")  //责任护士代码
    Set $p(InputStr,"^",139) = ..GetEMRData("HDSD00.11.054","HDSD00.12.061")    //进修医师签名
	//..GetEMRData("HDSD00.11.580","HDSD00.12.580")  //进修医师代码
    Set $p(InputStr,"^",140) = ..GetEMRData("HDSD00.11.972","HDSD00.12.972")    //研究生实习医师
    Set $p(InputStr,"^",141) = ..GetEMRData("HDSD00.11.088","HDSD00.12.100")    //实习医师签名
	//..GetEMRData("HDSD00.11.581","HDSD00.12.581")  //实习医师代码
    Set $p(InputStr,"^",142) = ..GetEMRData("HDSD00.11.005","HDSD00.12.005")    //编码员签名
	//..GetEMRData("HDSD00.11.582","HDSD00.12.582")  //编码员代码
    Set $p(InputStr,"^",143) = ..GetEMRData("HDSD00.11.899","HDSD00.12.899")    //病案质量描述
    Set $p(InputStr,"^",144) = ..GetEMRData("HDSD00.11.007","HDSD00.12.008")    //病案质量代码
    Set $p(InputStr,"^",145) = ..GetEMRData("HDSD00.11.128","HDSD00.12.143")    //质控医师签名
	//..GetEMRData("HDSD00.11.583","HDSD00.12.583")  //质控医师代码
    Set $p(InputStr,"^",146) = ..GetEMRData("HDSD00.11.126","HDSD00.12.141")    //质控护士签名
	//..GetEMRData("HDSD00.11.584","HDSD00.12.584")  //质控护士代码
	//..GetEMRData("HDSD00.11.973","HDSD00.12.973")  //质控护师
    Set $p(InputStr,"^",147) = ..GetEMRData("HDSD00.11.127","HDSD00.12.142")    //质控日期
    Set $p(InputStr,"^",148) = ..GetEMRData("HDSD00.11.603","HDSD00.12.603")    //离院方式
    Set $p(InputStr,"^",149) = ..GetEMRData("HDSD00.11.057","HDSD00.12.064")    //离院方式代码
    Set $p(InputStr,"^",150) = ..GetEMRData("HDSD00.11.1001","HDSD00.12.1001")  //转入医院名称
    //..GetEMRData("HDSD00.11.078","HDSD00.12.089")  //拟接收医疗机构名称
    Set $p(InputStr,"^",151) = ..GetEMRData("HDSD00.11.1002","HDSD00.12.1002")  //转入社区服务机构/乡镇卫生院名称
    //..GetEMRData("HDSD00.11.545","HDSD00.12.545")  //拟接收社区名称
    Set $p(InputStr,"^",152) = ..GetEMRData("HDSD00.11.604","HDSD00.12.604")    //出院31d内再住院
    Set $p(InputStr,"^",153) = ..GetEMRData("HDSD00.11.016","HDSD00.12.017")    //出院31d内再住院目的
    Set $p(InputStr,"^",154) = ..GetEMRData("HDSD00.11.070","HDSD00.12.077")    //颅脑损伤患者入院前昏迷时间-d
    Set $p(InputStr,"^",155) = ..GetEMRData("HDSD00.11.071","HDSD00.12.078")    //颅脑损伤患者入院前昏迷时间-h
    Set $p(InputStr,"^",156) = ..GetEMRData("HDSD00.11.072","HDSD00.12.079")    //颅脑损伤患者入院前昏迷时间-min
    Set $p(InputStr,"^",157) = ..GetEMRData("HDSD00.11.067","HDSD00.12.074")    //颅脑损伤患者入院后昏迷时间-d
    Set $p(InputStr,"^",158) = ..GetEMRData("HDSD00.11.068","HDSD00.12.075")    //颅脑损伤患者入院后昏迷时间-h
    Set $p(InputStr,"^",159) = ..GetEMRData("HDSD00.11.069","HDSD00.12.076")    //颅脑损伤患者入院后昏迷时间-min
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveAdm(InputStr)
	If flg<0 {
		Set ErrCode="-400"
		Set ErrText="病人信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveAdm("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)  = ..GetEMRData("HDSD00.11.142","HDSD00.12.169")  //住院总费用
	Set $p(InputStr,"^",4)  = ..GetEMRData("HDSD00.11.143","HDSD00.12.170")  //住院总费用-自付金额
	Set $p(InputStr,"^",5)  = ..GetEMRData("HDSD00.11.147","HDSD00.12.174")  //综合医疗服务类-一般医疗服务费
	Set $p(InputStr,"^",6)  = ..GetEMRData("","HDSD00.12.175")               //综合医疗服务类-一般医疗服务费-中医辨证论治费
	Set $p(InputStr,"^",7)  = ..GetEMRData("","HDSD00.12.176")               //综合医疗服务类-一般医疗服务费-中医辨证论治会诊费
	Set $p(InputStr,"^",8)  = ..GetEMRData("HDSD00.11.148","HDSD00.12.177")  //综合医疗服务类-一般治疗操作费
	Set $p(InputStr,"^",9)  = ..GetEMRData("HDSD00.11.145","HDSD00.12.172")  //综合医疗服务类-护理费
	Set $p(InputStr,"^",10) = ..GetEMRData("HDSD00.11.146","HDSD00.12.173")  //综合医疗服务类-其他费用
	Set $p(InputStr,"^",11) = ..GetEMRData("HDSD00.11.121","HDSD00.12.136")  //诊断类-病理诊断费
	Set $p(InputStr,"^",12) = ..GetEMRData("HDSD00.11.123","HDSD00.12.138")  //诊断类-实验室诊断费
	Set $p(InputStr,"^",13) = ..GetEMRData("HDSD00.11.124","HDSD00.12.139")  //诊断类-影像学诊断费
	Set $p(InputStr,"^",14) = ..GetEMRData("HDSD00.11.122","HDSD00.12.137")  //诊断类-临床诊断项目费
	Set $p(InputStr,"^",15) = ..GetEMRData("HDSD00.11.129","HDSD00.12.145")  //治疗类-非手术治疗项目费
	Set $p(InputStr,"^",16) = ..GetEMRData("HDSD00.11.130","HDSD00.12.146")  //治疗类-非手术治疗项目费-临床物理治疗费
	Set $p(InputStr,"^",17) = ..GetEMRData("HDSD00.11.131","HDSD00.12.147")  //治疗类-手术治疗费
	Set $p(InputStr,"^",18) = ..GetEMRData("HDSD00.11.132","HDSD00.12.148")  //治疗类-手术治疗费-麻醉费
	Set $p(InputStr,"^",19) = ..GetEMRData("HDSD00.11.133","HDSD00.12.149")  //治疗类-手术治疗费-手术费
	Set $p(InputStr,"^",20) = ..GetEMRData("HDSD00.11.055","HDSD00.12.062")  //康复类-康复费
	Set $p(InputStr,"^",21) = ..GetEMRData("","HDSD00.12.156")               //中医类-中医诊断费
	Set $p(InputStr,"^",22) = ..GetEMRData("HDSD00.11.136","HDSD00.12.157")  //中医类-中医治疗费
	Set $p(InputStr,"^",23) = ..GetEMRData("","HDSD00.12.163")               //中医类-中医治疗费-中医外治费
	Set $p(InputStr,"^",24) = ..GetEMRData("","HDSD00.12.160")               //中医类-中医治疗费-中医骨伤费
	Set $p(InputStr,"^",25) = ..GetEMRData("","HDSD00.12.158")               //中医类-中医治疗费-针刺与灸法费
	Set $p(InputStr,"^",26) = ..GetEMRData("","HDSD00.12.162")               //中医类-中医治疗费-中医推拿治疗费
	Set $p(InputStr,"^",27) = ..GetEMRData("","HDSD00.12.159")               //中医类-中医治疗费-中医肛肠治疗费
	Set $p(InputStr,"^",28) = ..GetEMRData("","HDSD00.12.161")               //中医类-中医治疗费-中医特殊治疗费
	Set $p(InputStr,"^",29) = ..GetEMRData("","HDSD00.12.153")               //中医类-中医其他费
	Set $p(InputStr,"^",30) = ..GetEMRData("","HDSD00.12.155")               //中医类-中医其他费-中医特殊调配加工费
	Set $p(InputStr,"^",31) = ..GetEMRData("","HDSD00.12.154")               //中医类-中医其他费-辨证施膳费
	Set $p(InputStr,"^",32) = ..GetEMRData("HDSD00.11.098","HDSD00.12.113")  //西药类-西药费
	Set $p(InputStr,"^",33) = ..GetEMRData("HDSD00.11.099","HDSD00.12.114")  //西药类-西药费-抗菌药物费用
	Set $p(InputStr,"^",34) = ..GetEMRData("HDSD00.11.135","HDSD00.12.151")  //中药类-中成药费
	Set $p(InputStr,"^",35) = ..GetEMRData("","HDSD00.12.152")               //中药类-中成药费-医疗机构中药制剂费
	Set $p(InputStr,"^",36) = ..GetEMRData("HDSD00.11.134","HDSD00.12.150")  //中药类-中草药费
	Set $p(InputStr,"^",37) = ..GetEMRData("HDSD00.11.115","HDSD00.12.130")  //血液和血液制品类-血费
	Set $p(InputStr,"^",38) = ..GetEMRData("HDSD00.11.111","HDSD00.12.126")  //血液和血液制品类-白蛋白类制品费
	Set $p(InputStr,"^",39) = ..GetEMRData("HDSD00.11.113","HDSD00.12.128")  //血液和血液制品类-球蛋白类制品费
	Set $p(InputStr,"^",40) = ..GetEMRData("HDSD00.11.112","HDSD00.12.127")  //血液和血液制品类-凝血因子类制品费
	Set $p(InputStr,"^",41) = ..GetEMRData("HDSD00.11.114","HDSD00.12.129")  //血液和血液制品类-细胞因子类制品费
	Set $p(InputStr,"^",42) = ..GetEMRData("HDSD00.11.038","HDSD00.12.045")  //耗材类-检查用一次性医用材料费
	Set $p(InputStr,"^",43) = ..GetEMRData("HDSD00.11.040","HDSD00.12.047")  //耗材类-治疗用一次性医用材料费
	Set $p(InputStr,"^",44) = ..GetEMRData("HDSD00.11.039","HDSD00.12.046")  //耗材类-手术用一次性医用材料费
	Set $p(InputStr,"^",45) = ..GetEMRData("HDSD00.11.081","HDSD00.12.092")  //其他类-其他费
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveFees(InputStr)
	If flg<0 {
		Set ErrCode="-500"
		Set ErrText="费用信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveFees("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	
	//初始化重症监护记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitICU(aMRFpID)
	If flg<0 {
		Set ErrCode="-601"
		Set ErrText="初始化重症监护记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitICU("""_aMRFpID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.546","HDSD00.12.546")    //重症监护室名称1
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1215","HDSD00.12.1215")  //进入重症监护室日期1
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.547","HDSD00.12.547")    //进重症监护室时间1
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1220","HDSD00.12.1220")  //离开重症监护室日期1
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.548","HDSD00.12.548")    //出重症监护室时间1
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.546","HDSD00.12.546")    //重症监护室名称1
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1215","HDSD00.12.1215")  //进入重症监护室日期1
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.547","HDSD00.12.547")    //进重症监护室时间1
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1220","HDSD00.12.1220")  //离开重症监护室日期1
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.548","HDSD00.12.548")    //出重症监护室时间1
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.549","HDSD00.12.549")    //重症监护室名称2
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1216","HDSD00.12.1216")  //进入重症监护室日期2
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.550","HDSD00.12.550")    //进重症监护室时间2
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1221","HDSD00.12.1221")  //离开重症监护室日期2
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.551","HDSD00.12.551")    //出重症监护室时间2
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.552","HDSD00.12.552")    //重症监护室名称3
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1217","HDSD00.12.1217")  //进入重症监护室日期3
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.553","HDSD00.12.553")    //进重症监护室时间3
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1222","HDSD00.12.1222")  //离开重症监护室日期3
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.554","HDSD00.12.554")    //出重症监护室时间3
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.984","HDSD00.12.984")    //重症监护室名称4
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1218","HDSD00.12.1218")  //进入重症监护室日期4
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.985","HDSD00.12.985")    //进重症监护室时间4
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1223","HDSD00.12.1223")  //离开重症监护室日期4
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.986","HDSD00.12.986")    //出重症监护室时间4
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	Set $p(InputStr,"^",1)=aMRFpID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=..GetEMRData("HDSD00.11.987","HDSD00.12.987")    //重症监护室名称5
	Set $p(InputStr,"^",4)=..GetEMRData("HDSD00.11.1219","HDSD00.12.1219")  //进入重症监护室日期5
	Set $p(InputStr,"^",5)=..GetEMRData("HDSD00.11.988","HDSD00.12.988")    //进重症监护室时间5
	Set $p(InputStr,"^",6)=..GetEMRData("HDSD00.11.1224","HDSD00.12.1224")  //离开重症监护室日期5
	Set $p(InputStr,"^",7)=..GetEMRData("HDSD00.11.989","HDSD00.12.989")    //出重症监护室时间5
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
	If flg<0 {
		Set ErrCode="-600"
		Set ErrText="重症监护信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFpID)
	}
	
	Quit return
}

ClassMethod GetEMRData(aXYCode As %String, aZYCode As %String) As %String
{
	New (aXYCode,aZYCode,%Version,%MRType,%EpisodeID,%ArrData)
	Set return=""
	Quit:(aXYCode="")&&(aZYCode="") return
	
	If %Version=2 {
		If %MRType="XY" {
			Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(%EpisodeID,aXYCode)
		} Else {
			Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(%EpisodeID,aZYCode)
		}
	} ElseIf %Version=3 {
		If %MRType="XY" {
			Set return=%ArrData.GetAt(aXYCode)
		} Else {
			Set return=%ArrData.GetAt(aZYCode)
		}
	}
	Quit return
}

}
