/// 名称: DHCMed.DPCustom.Data.OEOrdExec
/// 描述: 与医嘱执行记录相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-03-18
Class DHCMed.DPCustom.Data.OEOrdExec Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 医嘱代码
Property ItemCode As %String(TRUNCATE = 1);

/// 医嘱名称
Property ItemDesc As %String(TRUNCATE = 1);

/// 通用名
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

/// 指向医嘱主记录（OE_OrdItem）
Property FillerNo As %String(TRUNCATE = 1);

/// 执行记录状态（执行、审核、停止、作废）
Property ExStatus As %String(TRUNCATE = 1);

/// 执行记录开始日期
Property ExSttDate As %String(TRUNCATE = 1);

/// 执行记录开始时间
Property ExSttTime As %String(TRUNCATE = 1);

/// 执行记录开始日期
Property ExXDate As %String(TRUNCATE = 1);

/// 执行记录开始时间
Property ExXTime As %String(TRUNCATE = 1);

/// 记录日期
Property ActDate As %String(TRUNCATE = 1);

/// 记录时间
Property ActTime As %String(TRUNCATE = 1);

/// 记录人代码
Property ActUser As %String(TRUNCATE = 1);

/// 记录人名称
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByAdm("309530","","","微生物")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aCategory As %String = "", aItmMast As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aCategory,aItmMast)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	Quit:(aCategory="")&&(aItmMast="") return
	Set:aCategory'="" aCategory=","_aCategory_","
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdItem","")
	Set DataType=+DataType
	
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
					
					Set PHCCat=","_$p(tmpPHCCat,$c(1),1)_","
					Set PHCCatCode=","_$p(PHCCat,$c(2),2)_","
					Set PHCCatDesc=","_$p(PHCCat,$c(2),3)_","
					Set PHCSubCat=","_$p(tmpPHCCat,$c(1),2)_","
					Set PHCSubCatCode=","_$p(PHCSubCat,$c(2),2)_","
					Set PHCSubCatDesc=","_$p(PHCSubCat,$c(2),3)_","
					Set PHCPoison=","_$p(tmpPHCCat,$c(1),3)_","
					Set PHCPoisonCode=","_$p(PHCPoison,$c(2),2)_","
					Set PHCPoisonDesc=","_$p(PHCPoison,$c(2),3)_","
					Set PHCAntiFlag=","_$p(tmpPHCCat,$c(1),4)_","
					
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
						
						//1.1处理医嘱执行记录
						Set xChildID=0,ExecCount=0
						For {
							Set xChildID=$o(^OEORD(OrdID,"I",xSubID,"X",xChildID))
							Quit:xChildID=""
							
							Set OEExecID=OrdID_"||"_xSubID_"||"_xChildID
							Continue:(..IsValidOEExec(OEExecID)=0)
							
							Set obj=..GetObjById0(OEExecID)
							Continue:'$IsObject(obj)
	    					
							//检查开始时间和结束时间
							Set flg=##class(DHCMed.DPCustom.Data.OEOrdExec).CheckDateRange(aDateFrom,aDateTo,obj)
							Continue:flg<1
							
							Set ExecCount=ExecCount+1
							
					    	//Do $system.OBJ.Dump(obj)
							Do return.Insert(obj)
						}
						Continue:ExecCount>0
						
						//1.2临时医嘱没有执行记录，医嘱即为执行记录
					 	Set obj=..GetObjById0(OEItemID)
						Continue:'$IsObject(obj)
    					
						//检查开始时间和结束时间
						Set flg=##class(DHCMed.DPCustom.Data.OEOrdExec).CheckDateRange(aDateFrom,aDateTo,obj)
						Continue:flg<1
						
				    	//Do $system.OBJ.Dump(obj)
						Do return.Insert(obj)
				 	} ElseIf OEOrdType=1 {  //滚医嘱模式
					 	Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem(OEItemID)=0)
					 	
					 	//2滚医嘱模式，医嘱即为执行记录
					 	Set obj=..GetObjById0(OEItemID)
						Continue:'$IsObject(obj)
    					
						//检查开始时间和结束时间
						Set flg=##class(DHCMed.DPCustom.Data.OEOrdExec).CheckDateRange(aDateFrom,aDateTo,obj)
						Continue:flg<1
						
				    	//Do $system.OBJ.Dump(obj)
						Do return.Insert(obj)
					} Else {
						Continue
					}
					
					
				}
			}
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.OEOrdExec).GetDataByID("309655||468")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.OEOrdExec
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdItem","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS体温信息
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.OEOrdExec
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set OrdID=$p(aId,"||",1)
	Set SubID=$p(aId,"||",2)
	Set ChildID=$p(aId,"||",3)
	Quit:(OrdID="")||(SubID="") return
	
	If ChildID="" {
		Set FillerNo=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",12)
		Set:FillerNo="" FillerNo=OrdID_"||"_SubID
		
		Set objExec=##class(DHCMed.Base.OrdItem).GetObjById(OrdID_"||"_SubID)
		Quit:'$IsObject(objExec) return
		Set ExStatus=objExec.OSTATDesc
		Set ExSttDate=objExec.OEORISttDat
		Set:ExSttDate'="" ExSttDate=$zd(ExSttDate,3)
		Set ExSttTime=objExec.OEORISttTim
		Set:ExSttTime'="" ExSttTime=$zt(ExSttTime,1)
		Set ExXDate=objExec.OEORIXDate
		Set:ExXDate'="" ExXDate=$zd(ExXDate,3)
		Set ExXTime=objExec.OEORIXTime
		Set:ExXTime'="" ExXTime=$zt(ExXTime,1)
	} Else {
		Set FillerNo=OrdID_"||"_SubID
		
		Set ExStatus=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",16)
		Set:ExStatus'="" ExStatus=$p($g(^OEC("STAT",+ExStatus)),2)
		Set ExSttDate=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",1)
		Set:ExSttDate'="" ExSttDate=$zd(ExSttDate,3)
		Set ExSttTime=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",2)
		Set:ExSttTime'="" ExSttTime=$zt(ExSttTime,1)
		Set ExXDate=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",12)
		Set:ExXDate'="" ExXDate=$zd(ExXDate,3)
		Set ExXTime=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",14)
		Set:ExXTime'="" ExXTime=$zt(ExXTime,1)
	}
	Quit:(ExStatus="")||(ExSttDate="")||(ExSttTime="") return
	
	Set objItem=##class(DHCMed.Base.OrdItem).GetObjById(FillerNo)
	Quit:'$IsObject(objItem) return
	
	Set ArcimID=objItem.OEORIItmMastDR
	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	Quit:'$IsObject(objArcim) return
	Set ArcimDesc=objArcim.ARCIMDesc
	Set Category=objArcim.ARCICOrderType
	
	//药品通用名
	/*
	Set DrgForm=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",12)
	If DrgForm'="" {
		Set DrgMast=+DrgForm
		Set DrgGeneric=$p($g(^PHCD(DrgMast,4)),"^",1)
		Set:DrgGeneric'="" DrgGeneric=$p($g(^PHCGE("GE",DrgGeneric)),"^",2)
	} Else {
		Set DrgGeneric=""
	}
	*/
	Set DrgGeneric=""
	Set PHCGeneID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",20)   //通用名
	Set:PHCGeneID'="" DrgGeneric=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
	Set:DrgGeneric="" DrgGeneric=ArcimDesc
	
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
	
	Set obj=##Class(DHCMed.DPCustom.Data.OEOrdExec).%New()
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
	Set obj.FillerNo       = FillerNo
	Set obj.ExStatus       = ExStatus
	Set obj.ExSttDate      = ExSttDate
	Set obj.ExSttTime      = ExSttTime
	Set obj.ExXDate        = ExXDate
	Set obj.ExXTime        = ExXTime
	Set obj.ActDate        = ExSttDate
	Set obj.ActTime        = ExSttTime
	Set obj.ActUser        = DocCode
	Set obj.ActUserDesc    = DocDesc
	
	Set return=obj
	Quit return
}

/// w ##class(DHCMed.DPCustom.Data.OEOrdExec).IsValidOEItem("")
ClassMethod IsValidOEExec(aOEExecID As %String) As %String
{
	New (aOEExecID)
	Set return=0
	Quit:aOEExecID="" return
	
	Set OrdID=$p(aOEExecID,"||",1)
	Set SubID=$p(aOEExecID,"||",2)
	Set ChildID=$p(aOEExecID,"||",3)
	Quit:(OrdID="")||(SubID="")||(ChildID="") return
	
	Set $ZT="IsValidOEExecErr"
	
	Set StatusID=$p($g(^OEORD(OrdID,"I",SubID,"X",ChildID)),"^",16)
	Set StatusCode=$p($g(^OEC("STAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("STAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//停止执行、拒绝执行、撤销执行	--update by liuyh 2017-03-28	增加撤销执行过滤
	Set StatusList=$lb("D","R","C")
	Quit:($listfind(StatusList,StatusCode)>0) return
	Quit:(StatusDesc["作废") return
	
	Set return=1
	Quit return
	
IsValidOEExecErr
	Quit 0
}

/// 检查日期范围
/// w ##class(DHCMed.DPCustom.Data.OEOrdExec).CheckDateRange()
ClassMethod CheckDateRange(aFromDate As %String, aToDate As %String, objRec As DHCMed.DPCustom.Data.OEOrdExec) As %String
{
	New (aFromDate,aToDate,objRec)
	Set return=0
	
	//监控结果：停止时间和触发时间都在检查时间区间内
	Set EndDate=objRec.XDate
	If EndDate'="" {
		Set tmpDate=EndDate
		Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
		Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
		Quit:(aFromDate'="")&&(tmpDate<aFromDate) return
		Quit:(aToDate'="")&&(tmpDate>aToDate) return
	} Else {
		Set ActDate=objRec.ActDate
		Quit:ActDate=""
		Set tmpDate=ActDate
		Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
		Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
		Quit:(aFromDate'="")&&(tmpDate<aFromDate) return
		Quit:(aToDate'="")&&(tmpDate>aToDate) return
	}
	
	Set return=1
	Quit return
}

}
