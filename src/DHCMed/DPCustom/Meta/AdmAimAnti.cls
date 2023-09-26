/// 名称: DHCMed.DPCustom.Meta.AdmAimAnti
/// 描述: 抗生素使用相关Service
/// 编写者：Zhugz
/// 编写日期: 2013-11-28
Class DHCMed.DPCustom.Meta.AdmAimAnti Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.DPCustom.Meta.AdmAimAnti).GetAntiInfoByDate(+$h-1,+$h-1)
ClassMethod GetAntiInfoByDate(FromDate As %String, ToDate As %String)
{
	n (FromDate,ToDate)
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=FromDate:1:ToDate {
		Set xPaadm=0
		For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				If objAdm'="" Do objAdm.%Close()
				Set LocID=objAdm.DepartmentID
				Set WardID=objAdm.WardID
				Set OrdID=$o(^OEORD(0,"Adm",xPaadm,0))	  
				//Set CodeValue=..GetUseDaysAsPCode(OrdID,ArcimID,PoisonCode)                                     
				Set ArcimID=""
				Set IfLab=..IsAntiTestSet(xPaadm)    //是否送检
				Set AntiUseKind=$lb("")   //存储使用抗生素种类
				Set (AntiUse,AntiUseCount,AAAIsAnti2,AAAIsAnti2Count,AAAIsLab2,AAAIsAnti3,AAAIsAnti3Count,AAAIsLab3,ExcuteFlag)=0
				for {
					Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
					Quit:ArcimID=""
					Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
					If objArcim'="" Do objArcim.%Close()
					Continue:'$IsObject(objArcim)
					Set ArcOrdTp=objArcim.ARCICOrderType
					Continue:ArcOrdTp'="R" //不是药品
					
					Set DrgFormID=$p(^ARCIM(+ArcimID,1,1),"^",12)   ;PHC_DrgForm 药学形态
					continue:DrgFormID=""
					Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
				
					continue:AntiFlag'="Y"  //判断是否为抗菌药物
		
					continue:$lf(AntiUseKind,objArcim.ARCIMCode)>0 
					set AntiUseKind=AntiUseKind_$lb(objArcim.ARCIMCode)
					Set AntiUse=1,AntiUseCount=AntiUseCount+1
					Set DrgMastID=+DrgFormID                           ;PHC_DrgMast 药理学项
					Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)      ;PHC_Poison  管制分类
					Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)
					Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
					Set:PoisonCode="KSS2" AAAIsAnti2=1,AAAIsAnti2Count=AAAIsAnti2Count+1
					Set:PoisonCode="KSS3" AAAIsAnti3=1,AAAIsAnti3Count=AAAIsAnti3Count+1
					Set ExcuteFlag=1
					/**使用天数未作*/
					
					
					}
					if (ExcuteFlag=1) {
						Set mainstr=""_"^"_xPaadm_"^"_"OE"_"^"_"OE-HIS-ANTI"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"1"_"^"_+$h_"^"_$p($h,",",2)_"^"_""
						Set MainID=##Class(DHCMed.DP.Meta.ActMain).Update(mainstr)
						q:MainID<=0
						Set SubStr=""_"^"_MainID_"^"_"OE-HIS-ANTI"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_AntiUse_"^"_IfLab_"^"_AntiUseCount_"^"_""_"^"_AAAIsAnti2_"^"_AAAIsAnti2Count_"^"_IfLab_"^"_""_"^"_AAAIsAnti3_"^"_AAAIsAnti3Count_"^"_IfLab_"^"_""
						Set SubID=##Class(DHCMed.DP.Meta.AdmAimAnti).Update(SubStr)  //病人基本信息可以从该病人的DHCMed_DP.ActPatInfo表中获取
					
					}
					
		}
	}
	Quit $$$OK
}

/// 检查是否送检
ClassMethod IsAntiTestSet(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	Set xOrdID=$o(^OEORD(0,"Adm",+aEpisodeID,""))
 	Set xArcimID=""
 	For {
	 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
	 	Quit:xArcimID=""
	 	Quit:return>0
		
	 	Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ArcimType=objArcim.ARCICOrderType
	 	Continue:ArcimType'="L"
	 	Set ArcimSubCat=objArcim.ARCICDesc
	 	Continue:ArcimSubCat=""
	 	//微生物
	 	//w LabOEItemType_"///"_ArcimSubCat,!
	 	Continue:(LabOEItemType'="")&&(LabOEItemType'[ArcimSubCat)
	 	
	 	Set ArcimID=xArcimID
	 	Set ArcimDesc=objArcim.ARCIMDesc
	 	
	 	Set xOrdDate=0
	 	For {
		 	Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
		 	Quit:xOrdDate=""
		 	Quit:return>0
			
		 	Set xSubID=0
		 	For {
			 	Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
			 	Quit:xSubID=""
			 	Quit:return>0
			 	
			 	Set OEItemID=xOrdID_"||"_xSubID
			 	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
			 	Continue:'$IsObject(objOEItem)
			 	Set OEItemStatus=objOEItem.OSTATCode
			 	///OEC_OrderStatus 医嘱状态表
			 	Continue:(OEItemStatus="D")||(OEItemStatus="U")  //检查医嘱状态
			 	
			 	Set return=1
		 	}
	 	}
 	}
	Quit return
}

/// 用药天数统计
ClassMethod GetUseDaysAsPCode(aOrdID As %String) As %String
{
	New (aOrdID)
	Set return=0
	Quit:aOrdID="" return
	Set StartDate=""
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",aOrdID,aArcimID,StartDate))
			Quit:StartDate=""
			Quit:return>0
			
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",aOrdID,aArcimID,StartDate,SubID))
				Quit:SubID=""
				Quit:return>0
				
				Set OEItemID=##class(DHCMed.Base.OrdItem).GetObjById(aOrdID_"||"_SubID)
				If OEItemID'="" Do OEItemID.%Close()
				Continue:'$IsObject(OEItemID)
				}
			}
	Quit return
}

}
