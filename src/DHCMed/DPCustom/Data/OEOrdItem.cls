/// 名称: DHCMed.DPCustom.Data.OEOrdItem
/// 描述: 与医嘱相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-03-18
Class DHCMed.DPCustom.Data.OEOrdItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 医嘱代码
Property ItemCode As %String(TRUNCATE = 1);

/// 医嘱名称
Property ItemDesc As %String(TRUNCATE = 1);

/// 药品通用名
Property DrgGeneric As %String(TRUNCATE = 1);

/// 医嘱类别(检验L、药品D、检查C)
Property Category As %String(TRUNCATE = 1);

/// 开医嘱医生代码
Property DocCode As %String(TRUNCATE = 1);

/// 开医嘱医生姓名
Property DocDesc As %String(TRUNCATE = 1);

/// 医嘱类型(长期、临时)
Property Priority As %String(TRUNCATE = 1);

/// 医嘱状态（执行、审核、停止、作废）
Property OEStatus As %String(TRUNCATE = 1);

/// 开单科室代码
Property OrdDeptCode As %String(TRUNCATE = 1);

/// 开单科室名称
Property OrdDeptDesc As %String(TRUNCATE = 1);

/// 接收科室代码
Property RecDeptCode As %String(TRUNCATE = 1);

/// 接收科室名称
Property RecDeptDesc As %String(TRUNCATE = 1);

/// 开始日期
Property SttDate As %String(TRUNCATE = 1);

/// 开始时间
Property SttTime As %String(TRUNCATE = 1);

/// 停止日期
Property XDate As %String(TRUNCATE = 1);

/// 停止时间
Property XTime As %String(TRUNCATE = 1);

/// 记录日期
Property ActDate As %String(TRUNCATE = 1);

/// 记录时间
Property ActTime As %String(TRUNCATE = 1);

/// 记录人代码
Property ActUser As %String(TRUNCATE = 1);

/// 记录人名称
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm("301993","","","微生物")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aCategory As %String = "", aItmMast As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aCategory,aItmMast)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	Quit:(aCategory="")&&(aItmMast="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdItem","")
	Set DataType=+DataType
	
 	Kill OEOrdItemList
	If DataType=1 {
		//DataType=0 默认取值HIS医嘱信息（滚医嘱方式）
	} Else {
		//DataType=0 默认取值HIS医嘱信息
		Set OEOrdType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdType","")
		Set OEOrdType=+OEOrdType
		
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" return
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			//根据医嘱项过滤,多个医嘱逗号分隔
			If aItmMast'="" {
				Set yItmMast=","_aItmMast_","
				Set yArcimID=","_xArcimID_","
				Continue:yItmMast'[yArcimID
			}
			//根据医嘱大类或医嘱子类过滤
			If aCategory'="" {
		 		Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 		Continue:'$IsObject(objArcim)
		 		Set ArcimType=objArcim.ARCICOrderType
		 		If ArcimType="R" {
			 		Set tmpPHCCat=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetPHCCat(xArcimID)
			 		Continue:tmpPHCCat=""
			 		Set PHCCat=$p(tmpPHCCat,$c(1),1)
			 		Set PHCCatCode=$p(PHCCat,$c(2),2)
			 		Set PHCCatDesc=$p(PHCCat,$c(2),3)
			 		Set PHCSubCat=$p(tmpPHCCat,$c(1),2)
			 		Set PHCSubCatCode=$p(PHCSubCat,$c(2),2)
			 		Set PHCSubCatDesc=$p(PHCSubCat,$c(2),3)
			 		Set PHCPoison=$p(tmpPHCCat,$c(1),3)
			 		Set PHCPoisonCode=$p(PHCPoison,$c(2),2)
			 		Set PHCPoisonDesc=$p(PHCPoison,$c(2),3)
			 		Set PHCAntiFlag=$p(tmpPHCCat,$c(1),4)
			 		
			 		If ((PHCCatCode'="")&&(aCategory[PHCCatCode))
			 		||((PHCCatDesc'="")&&(aCategory[PHCCatDesc))
			 		||((PHCSubCatCode'="")&&(aCategory[PHCSubCatCode))
			 		||((PHCSubCatDesc'="")&&(aCategory[PHCSubCatDesc))
			 		||((PHCPoisonCode'="")&&(aCategory[PHCPoisonCode))
			 		||((PHCPoisonDesc'="")&&(aCategory[PHCPoisonDesc))
			 		||((PHCAntiFlag'="")&&(aCategory[PHCAntiFlag))
			 		{
				 		//符合筛查条件药品
				 	} Else {
					 	Continue
					}
			 	 	//w PHCCatCode_"///"_PHCCatDesc_"///"_PHCSubCatCode_"///"_PHCSubCatDesc_"///"_PHCPoisonCode_"///"_PHCPoisonDesc,!
			 	} Else {
			 		Continue:(aCategory'[objArcim.ARCICDesc)&&(aCategory'[objArcim.ORCATDesc)
		 			//w objArcim.ARCICDesc_"///"_objArcim.ORCATDesc,!
			 	}
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
						//滚医嘱模式，后边滚出来的医嘱算执行记录
					} Else {
						Continue
					}
					
					Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
					Continue:'$IsObject(objOEItem)
					Set StartDate=objOEItem.OEORISttDat
					Set StartDate=+StartDate
					Continue:StartDate=0
					Set XDate=objOEItem.OEORIXDate
					Set XTime=objOEItem.OEORIXTime
					Set:XDate'="" XDate=$zd(XDate,3)
					Set:XTime'="" XTime=$zt(XTime,1)
					
					Set FillerNo=$p($g(^OEORD(OrdID,"I",xSubID,9)),"^",12)
					If FillerNo'="" {
						Set FillerNo=$p(FillerNo,"!!",1)
					}Else{
						Set FillerNo=OrdID_"||"_xSubID
					}
					
					If $d(OEOrdItemList(FillerNo)){
						Set:XDate'="" OEOrdItemList(FillerNo)=XDate_" "_XTime
					} Else {
						Set OEOrdItemList(FillerNo)=""
					}
				}
			}
		}
	}
	
	Set xOEItemID="",Count=0
	For {
		Set xOEItemID=$o(OEOrdItemList(xOEItemID))
		Quit:xOEItemID=""
		
		Set OEItemID=xOEItemID
		Set tmpDateTime=$g(OEOrdItemList(OEItemID))
		Set XDate=$p(tmpDateTime," ",1)
		Set XTime=$p(tmpDateTime," ",2)
		
		Set obj=..GetObjById0(OEItemID)
		Continue:'$IsObject(obj)
		Set obj.XDate=XDate
		Set obj.XTime=XTime
		
		//检查开始时间和结束时间
		Set flg=##class(DHCMed.DPCustom.Data.OEOrdExec).CheckDateRange(aDateFrom,aDateTo,obj)
		Continue:flg<1
		
    	//Do $system.OBJ.Dump(obj)
		Do return.Insert(obj)
	}
 	Kill OEOrdItemList
 	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByID("309655||468")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.OEOrdItem
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdItem","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS医嘱信息
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.OEOrdItem
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set OrdID=$p(aId,"||",1)
	Set SubID=$p(aId,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set OEItemID=OrdID_"||"_SubID
	Set objItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
	Quit:'$IsObject(objItem) return
	
	Set ArcimID=objItem.OEORIItmMastDR
	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	Quit:'$IsObject(objArcim) return
	Set ArcimDesc=objArcim.ARCIMDesc
	Set Category=objArcim.ARCICOrderType
	
	//药品通用名
	Set DrgForm=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",12)
	If DrgForm'="" {
		Set DrgMast=+DrgForm
		Set DrgGeneric=$p($g(^PHCD(DrgMast,4)),"^",1)
		Set:DrgGeneric'="" DrgGeneric=$p($g(^PHCGE("GE",DrgGeneric)),"^",2)
	} Else {
		Set DrgGeneric=""
	}
	
	//开医嘱医生，转换为SSUser表数据
	Set CareProvID=objItem.OEORIDoctorDR
	If CareProvID'="" {
		Set DocCode=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,0))
		Set:DocCode'="" DocDesc=$p($g(^SSU("SSUSR",DocCode)),"^",2)
	} Else {
		Set DocCode=""
		Set DocDesc=""
	}
	
	Set Priority=objItem.OECPRDesc
	Set OEStatus=objItem.OSTATDesc
	Set SttDate=objItem.OEORISttDat
	Set:SttDate'="" SttDate=$zd(SttDate,3)
	Set SttTime=objItem.OEORISttTim
	Set:SttTime'="" SttTime=$zt(SttTime,1)
	Set XDate=objItem.OEORIXDate
	Set:XDate'="" XDate=$zd(XDate,3)
	Set XTime=objItem.OEORIXTime
	Set:XTime'="" XTime=$zt(XTime,1)
	
	Set OrdDeptCode=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",3)
	Set OrdDeptDesc=$p($g(^CTLOC(+OrdDeptCode)),"^",2)
	Set:$p(OrdDeptDesc,"-",2)'="" OrdDeptDesc=$p(OrdDeptDesc,"-",2)
	Set RecDeptCode=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",6)
	Set RecDeptDesc=$p($g(^CTLOC(+RecDeptCode)),"^",2)
	Set:$p(RecDeptDesc,"-",2)'="" RecDeptDesc=$p(RecDeptDesc,"-",2)
	
	Set obj=##Class(DHCMed.DPCustom.Data.OEOrdItem).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = aId
	Set obj.ItemCode       = ArcimID
	Set obj.ItemDesc       = ArcimDesc
	Set obj.DrgGeneric     = DrgGeneric
	Set obj.Category       = Category
	Set obj.DocCode        = DocCode
	Set obj.DocDesc        = DocDesc
	Set obj.Priority       = Priority
	Set obj.OEStatus       = OEStatus
	Set obj.OrdDeptCode    = OrdDeptCode
	Set obj.OrdDeptDesc    = OrdDeptDesc
	Set obj.RecDeptCode    = RecDeptCode
	Set obj.RecDeptDesc    = RecDeptDesc
	Set obj.SttDate        = SttDate
	Set obj.SttTime        = SttTime
	Set obj.XDate          = XDate
	Set obj.XTime          = XTime
	Set obj.ActDate        = SttDate
	Set obj.ActTime        = SttTime
	Set obj.ActUser        = DocCode
	Set obj.ActUserDesc    = DocDesc
	
	Set return=obj
	Quit return
}

/// 检查医嘱状态是否有效（滚执行记录模式）
/// w ##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem7("")
ClassMethod IsValidOEItem7(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=0
	Quit:aOEItemID="" return
	
	Set $ZT="IsValidOEItem7Err"
	
	Set StatusID=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//作废,未审核,撤销,预开医嘱
	Set StatusList=$lb("U","I","C","P")
	Quit:($listfind(StatusList,StatusCode)>0) return
	Quit:(StatusDesc["作废") return
	
	//停止医嘱
	If (StatusCode="D") {
		Set PriorityID=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),1)),"^",8)
		Set PriorityCode=$p($g(^OECPR(+PriorityID)),"^",1)
		Set PriorityDesc=$p($g(^OECPR(+PriorityID)),"^",2)
		Set Priority=PriorityCode_","_PriorityDesc
		Quit:(Priority'["长期")&&(Priority'["PRN")&&(Priority'["持续") return
	}
	
	Set return=1
	Quit return
	
IsValidOEItem7Err
	Quit 0
}

/// 检查医嘱状态是否有效（滚医嘱模式）
/// w ##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem("")
ClassMethod IsValidOEItem(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=0
	Quit:aOEItemID="" return
	
	Set $ZT="IsValidOEItemErr"
	
	Set StatusID=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//作废,未审核,撤销,预开医嘱
	Set StatusList=$lb("U","I","C","P")
	Quit:($listfind(StatusList,StatusCode)>0) return
	Quit:(StatusDesc["作废") return
	
	//停止医嘱
	If (StatusCode="D") {
		Quit return
	}
	
	Set return=1
	Quit return
	
IsValidOEItemErr
	Quit 0
}

/// 取药学大类、药学子类、管制分类
/// w ##class(DHCMed.DPCustom.Data.OEOrdItem).GetPHCCat(ArcimID)
ClassMethod GetPHCCat(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=""
	Quit:aArcimID="" return
	
	Set DrgFormID=$p($g(^ARCIM(+aArcimID,1,1)),"^",12)  //PHC_DrgForm:药学形态
	Set DrgMastID=+DrgFormID                            //PHC_DrgMast药理学项
	Quit:DrgMastID=0 return
	
	Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
	Set AntiFlag=$s(AntiFlag="Y":"ANTI",1:"")
	
	Set SubCatID=$p($g(^PHCD(DrgMastID,1)),"^",3)       //PHC_SubCat药理学子分类
	Set SubCatCode=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",1)
	Set SubCatDesc=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",2)
	
	Set MinCatID=$p($g(^PHCD(DrgMastID,1)),"^",6)       //PHC_MinorSubCat药理学最小分类
	
	Set PHCCatID=+SubCatID                              //PHC_Cat药理学分类
	Set PHCCatCode=$p($g(^PHCC(PHCCatID)),"^",1)
	Set PHCCatDesc=$p($g(^PHCC(PHCCatID)),"^",2)
	
	Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)      //PHC_Poison  管制分类
	Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)
	Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
	
	//新药品学分类
	Set MinCatID=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",20)  //PHC_MinorSubCat药理学最小分类	
	Set PhaCatAllstr=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCatById(MinCatID,"","","")
	If PhaCatAllstr'="" {
		Set PhaCatAlls=$p(PhaCatAllstr,"^",3)
		Set PHCCatID=$p(PhaCatAlls,"-",1)				//PHC_Cat药理学分类
		Set PHCCatCode=$p($g(^DHCPHCC(+PHCCatID)),"^",1) 
		Set PHCCatDesc=$p($g(^DHCPHCC(+PHCCatID)),"^",2) 
		Set SubCatID=$p(PhaCatAlls,"-",2)				//PHC_SubCat药理学子分类
		Set SubCatCode=$p($g(^DHCPHCC(+SubCatID)),"^",1) //PHC_SubCat药理学子分类
		set SubCatDesc=$p($g(^DHCPHCC(+SubCatID)),"^",2)
		Set MinCatID=$p(PhaCatAlls,"-",3)
	}
	
	Set return=PHCCatID_$c(2)_PHCCatCode_$c(2)_PHCCatDesc
	Set return=return_$c(1)_SubCatID_$c(2)_SubCatCode_$c(2)_SubCatDesc
	Set return=return_$c(1)_PoisonID_$c(2)_PoisonCode_$c(2)_PoisonDesc
	Set return=return_$c(1)_AntiFlag
	Quit return
}

}
