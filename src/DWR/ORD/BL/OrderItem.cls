/// 医嘱
Class DWR.ORD.BL.OrderItem Extends %RegisteredObject
{

/// 查询医嘱
ClassMethod OrderItemQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="OrderItemQryET"
	set pResponse=##Class(DWR.ORD.MSG.OrderItemQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.ORD.MSG.OrderItemQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..OrderItemQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
OrderItemQryET
	set pResponse=##Class(DWR.ORD.MSG.OrderItemQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod OrderItemQryExe(Rt As DWR.ORD.MSG.OrderItemQryRt) As DWR.ORD.MSG.OrderItemQryRp
{
	set $ZT="OrderItemQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到医嘱记录"
	set Rp=##Class(DWR.ORD.MSG.OrderItemQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set StartDate=Rt.StartDate
	if (StartDate'="") set StartDate=$ZDateH(StartDate,3)
	set EndDate=Rt.EndDate
	if (EndDate'="") set EndDate=$ZDateH(EndDate,3)
	if (EpisodeID="")
	{
		do OutputResult("101","就诊ID不能为空")
	    Quit Rp
	}
	if ('$data(^PAADM(EpisodeID)))
	{
		do OutputResult("106","就诊ID不存在")
    	quit Rp
	}
	set GroupBy=Rt.GroupBy
	
	set OEORDRowID=$order(^OEORD(0,"Adm",EpisodeID,""))
	if (OEORDRowID="")
	{
		do OutputResult("100","没有查询到医嘱记录")
    	quit Rp
	}
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	set myJob=$job
	kill ^TMP("DWRORDITM",myJob)
	kill ^TMP("DWRFillerNo",myJob)
	set ChildSub="0"
	while ($order(^OEORD(OEORDRowID,"I",ChildSub))'="")
	{
		set ChildSub=$order(^OEORD(OEORDRowID,"I",ChildSub))
		set myOrdItemID=OEORDRowID_"||"_ChildSub
		set myObj=##Class(User.OEOrdItem).%OpenId(myOrdItemID)
		if (myObj.OEORIFillerNo'="")
		{
			set FirstOrdItem=$piece(myObj.OEORIFillerNo,"!",1)
			if (FirstOrdItem'="") set ^TMP("DWRFillerNo",myJob,FirstOrdItem)=myOrdItemID
			
			if (GroupBy="Priority") do myObj.%Close() continue        // 过滤系统每天自动生成的长期医嘱
		}   
		
		if ((GroupBy'="Priority")&&(StartDate'="")&&(myObj.OEORIDate<StartDate)) {do myObj.%Close() continue}
		if ((GroupBy'="Priority")&&(EndDate'="")&&(myObj.OEORIDate>EndDate)) {do myObj.%Close() continue}
		
		if ('$IsObject(myObj.OEORIPriorityDR)) {do myObj.%Close() continue}       // 过滤医嘱优先级为空的医嘱
		if (myObj.OEORIPriorityDR.OECPRCode="ONE") {do myObj.%Close() continue}   // 过滤取药医嘱
		
		if ((myObj.OEORIPriorityDR.OECPRCode="S")||(myObj.OEORIPriorityDR.OECPRCode="OMST"))
		{
			set PriorityFlag="S",PriorityNum=1,PriorityName="长期医嘱"
		}
		else
		{
			set PriorityFlag="NORM",PriorityNum=2,PriorityName="临时医嘱"
		}
		
		if ((GroupBy="Priority")&&(PriorityFlag'="S")) do myObj.%Close() continue    //按照医嘱级别分组时过滤临时医嘱
		if ((GroupBy'="Priority")&&(PriorityFlag="S")) do myObj.%Close() continue    //不按照医嘱级别分组时过滤长期医嘱
		
		set OrdItemStatus=myObj.OEORIItemStatDR.OSTATCode
		if ((OrdItemStatus'="E")&&(OrdItemStatus'="V")&&(PriorityFlag'="S")) {do myObj.%Close() continue}    //过滤不是核实、执行状态的非长期医嘱
		if ((OrdItemStatus'="E")&&(OrdItemStatus'="V")&&(OrdItemStatus'="D")&&(PriorityFlag="S")) {do myObj.%Close() continue}    //过滤不是核实、执行、停止状态的长期医嘱
		
		set ArcimRowID=myObj.OEORIItmMastDR.%Id()
		set ARCSubCatDr=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",10)
		if (ARCSubCatDr="") {do myObj.%Close() continue}           // 过滤没有医嘱子类的错误数据
		set ARCSubCatCode=$piece($get(^ARC("IC",ARCSubCatDr)),"^",1)
		set ARCSubCatDesc=$piece($get(^ARC("IC",ARCSubCatDr)),"^",2)
		set OrderType=$piece($get(^ARC("IC",ARCSubCatDr)),"^",7)
		set OrdCatDr=$piece($get(^ARC("IC",ARCSubCatDr)),"^",8)
		set OrdCatCode=$piece($get(^OEC("ORCAT",OrdCatDr)),"^",1)
		set OrdCatDesc=$piece($get(^OEC("ORCAT",OrdCatDr)),"^",2)
		
		// 显示的医嘱子类需要增加配置
		if ((OrderType="L")||(OrdCatDesc["检查")) {do myObj.%Close() continue}    // 过滤检验医嘱和检查医嘱。
		if ((OrdCatDesc["材料")||(OrdCatDesc["费")) {do myObj.%Close() continue}    // 过滤材料、费用等非治疗医嘱。
		if ((ARCSubCatDesc["材料")||(ARCSubCatDesc["费")||(ARCSubCatDesc["床位")) {do myObj.%Close() continue}    // 过滤材料、费用、床位等非治疗医嘱。
		
		if ($data(^DHCDWRSET("ORD","OrdCat",OrdCatCode))) {do myObj.%Close() continue}       // 过滤医嘱分类设置为不显示的医嘱。
		if ($data(^DHCDWRSET("ORD","OrdSubCat",ARCSubCatCode))) {do myObj.%Close() continue} // 过滤医嘱子分类设置为不显示的医嘱。
		
		set ResultCode="0",ResultContent="查询成功"
		
		set OEORISttDat=$ZDate(myObj.OEORISttDat,3)
		if (GroupBy="OrdCat")
		{
			set Group1=OrdCatDesc       // 按照医嘱分类分组
			set Group2=OEORISttDat
		}
		elseif(GroupBy="Priority")
		{
			set Group1=PriorityNum	    // 按照医嘱优先级分组
			set Group2=OEORISttDat
		}
		else
		{
			set Group1=OEORISttDat	    // 按照医嘱开始日期分组
			set Group2=PriorityNum
		}
		set ^TMP("DWRORDITM",myJob,Group1,Group2,ChildSub)=myOrdItemID
		do myObj.%Close()
		
	}
	
	set Group1=""
	while($order(^TMP("DWRORDITM",myJob,Group1))'="")
	{
		set Group1=$order(^TMP("DWRORDITM",myJob,Group1))
		set GroupObj=##Class(DWR.ORD.MSG.OrderItemGroup).%New()
		set GroupObj.GroupName=Group1
		
		if (GroupBy="Priority")
		{
			if (Group1=1)
			{
				set GroupObj.GroupName="长期医嘱"
			}
			else
			{
				set GroupObj.GroupName="临时医嘱"
			}
		}
		else
		{
			set GroupObj.GroupName=Group1
		}
		
		
		set Group2=""
		while($order(^TMP("DWRORDITM",myJob,Group1,Group2))'="")
		{
			set Group2=$order(^TMP("DWRORDITM",myJob,Group1,Group2))
			set ChildSub=""
			while($order(^TMP("DWRORDITM",myJob,Group1,Group2,ChildSub))'="")
			{
				set ChildSub=$order(^TMP("DWRORDITM",myJob,Group1,Group2,ChildSub))
				set myOrdItemID=^TMP("DWRORDITM",myJob,Group1,Group2,ChildSub)
				do OutputOrdItem
			}
		}
		
		do Rp.OrderItemGroupList.Insert(GroupObj)
		do GroupObj.%Close()
		
	}
	
	kill ^TMP("DWRORDITM",myJob)
	kill ^TMP("DWRFillerNo",myJob)
	
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	
OutputOrdItem
	set myObj=##Class(User.OEOrdItem).%OpenId(myOrdItemID)
	set ArcimRowID=myObj.OEORIItmMastDR.%Id()
	set ARCSubCatDr=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",10)
	set OrderType=$piece($get(^ARC("IC",ARCSubCatDr)),"^",7)
	set OrdCatDr=$piece($get(^ARC("IC",ARCSubCatDr)),"^",8)
	set OrdCatDesc=$piece($get(^OEC("ORCAT",OrdCatDr)),"^",2)
	if (OrderType="R")
		{
			set myQty=myObj.OEORIPhQtyOrd
			set myUom=myObj.OEORIUnitDR.CTUOMDesc
			set myDoseQty=myObj.OEORIDoseQty
			set myDoseUom=myUom
			set myFrequency=myObj.OEORIPHFreqDR.PHCFRCode
			set myInstruction=myObj.OEORIInstrDR.PHCINCode
			set myDuration=myObj.OEORIDuratDR.PHCDUCode
			set myPackQty=myObj.OEORIQtyPackUOM
			set INCIRowID=$order(^INCI(0,"ARCIM_DR",+ArcimRowID,""))
			set myPackUom=""
			if (INCIRowID'="")&&(+myPackQty'=0)
			{
				set PackUomDr=$piece($get(^INCI(INCIRowID,3)),"^",6)
				if (PackUomDr'="") set myPackUom=$piece($get(^CT("UOM",PackUomDr)),"^",2)
			}
		}
		else
		{
			set myQty=myObj.OEORIPhQtyOrd
			set myUom=myObj.OEORIUnitDR.CTUOMDesc
			set myUomDr=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),8)),"^",14)
			if (myUomDr'="") set myUom=$piece($get(^CT("UOM",myUomDr)),"^",2)
			set myDoseQty=""
			set myDoseUom=""
			set myFrequency=""
			set myInstruction=""
			set myDuration=""
			set myPackQty=""
			set myPackUom=""
		}
		
		set RowObj=##class(DWR.ORD.MSG.OrderItem).%New()
		
		set RowObj.OrdItemID=myOrdItemID
		
		set RowObj.ItemDesc=myObj.OEORIItmMastDR.ARCIMDesc
		set RowObj.ItemCat=OrdCatDesc
		set OrderDept=myObj.OEORIOrdDeptDR.CTLOCDesc
		if OrderDept["-" set OrderDept=$piece(OrderDept,"-",2)
		//set RowObj.OrderDept=OrderDept
		set RowObj.OrderDoctor=myObj.OEORIDoctorDR.CTPCPDesc
		if myObj.OEORIDate'="" set RowObj.OrderDate=$ZDate(myObj.OEORIDate,3)
		if myObj.OEORITimeOrd'="" set RowObj.OrderTime=$ZTime(myObj.OEORITimeOrd,2)
		set RowObj.ItemStatus=myObj.OEORIItemStatDR.OSTATDesc
		if (myObj.OEORIItemStatDR.OSTATCode="D")
		{
			if ($IsObject(myObj.OEORIXCTCPDR)) set RowObj.StopOrderDoctor=myObj.OEORIXCTCPDR.CTPCPDesc
			if myObj.OEORIXDate'="" set RowObj.StopOrderDate=$ZDate(myObj.OEORIXDate,3)
			if myObj.OEORIXTime'="" set RowObj.StopOrderTime=$ZTime(myObj.OEORIXTime,2)
		
		}
		set LastOrdItem=$get(^TMP("DWRFillerNo",myJob,myOrdItemID))
		if ((GroupBy="Priority")&&(LastOrdItem'=""))      // 当按照优先级分组的时候，长期医嘱的停止信息取其最后一条医嘱的停止信息
		{
			set LastOrdItemStatusID=$piece($get(^OEORD(+LastOrdItem,"I",$piece(LastOrdItem,"||",2),1)),"^",13)
			if (LastOrdItemStatusID'="")
			{
				set LastOrdItemStatusCode=$piece($get(^OEC("OSTAT",LastOrdItemStatusID)),"^",1)
				set LastOrdItemStatusName=$piece($get(^OEC("OSTAT",LastOrdItemStatusID)),"^",2)
				if (LastOrdItemStatusCode="D")
				{
					set RowObj.ItemStatus=LastOrdItemStatusName
					set LastOrdItemXDoctor=$piece($get(^OEORD(+LastOrdItem,"I",$piece(LastOrdItem,"||",2),3)),"^",29)
					set LastOrdItemXDate=$piece($get(^OEORD(+LastOrdItem,"I",$piece(LastOrdItem,"||",2),3)),"^",34)
					set LastOrdItemXTime=$piece($get(^OEORD(+LastOrdItem,"I",$piece(LastOrdItem,"||",2),2)),"^",15)
					if (LastOrdItemXDoctor'="") set LastOrdItemXDoctor=$piece($get(^CTPCP(LastOrdItemXDoctor,1)),"^",2)
					if (LastOrdItemXDate'="") set LastOrdItemXDate=$ZDate(LastOrdItemXDate,3)
					if (LastOrdItemXTime'="") set LastOrdItemXTime=$ZTime(LastOrdItemXTime,2)
					set RowObj.StopOrderDoctor=LastOrdItemXDoctor
					set RowObj.StopOrderDate=LastOrdItemXDate
					set RowObj.StopOrderTime=LastOrdItemXTime
				}
			}
		}
		if myObj.OEORISttDat'="" set RowObj.StartDate=$ZDate(myObj.OEORISttDat,3)
		if myObj.OEORISttTim'="" set RowObj.StartTime=$ZTime(myObj.OEORISttTim,2)
		set RowObj.Priority=myObj.OEORIPriorityDR.OECPRDesc
		
		set RowObj.Qty=myQty
		set RowObj.Uom=myUom
		set RowObj.DoseQty=myDoseQty
		set RowObj.DoseUom=myDoseUom
		set RowObj.Frequency=myFrequency
		set RowObj.Instruction=myInstruction
		set RowObj.Duration=myDuration
		////set RowObj.PackQty=myPackQty
		////set RowObj.PackUom=myPackUom
		set RowObj.SeqNo=myObj.OEORISeqNo
		set RecLoc=myObj.OEORIRecDepDR.CTLOCDesc
		if RecLoc["-" set RecLoc=$piece(RecLoc,"-",2)
		set RowObj.RecLoc=RecLoc
		
		set RowObj.Remarks=""
		
		do GroupObj.OrderItemList.Insert(RowObj)
		do RowObj.%Close()
		do myObj.%Close()
		quit

OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
OrderItemQryExeET
	set Rp=##Class(DWR.ORD.MSG.OrderItemQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

}
