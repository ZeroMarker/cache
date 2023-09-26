/// 检验报告
Class DWR.ORD.BL.LISReport Extends %RegisteredObject
{

/// 查询检验报告
ClassMethod LISReportQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="LISReportQryET"
	set pResponse=##Class(DWR.ORD.MSG.LISReportQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.ORD.MSG.LISReportQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..LISReportQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
LISReportQryET
	set pResponse=##Class(DWR.ORD.MSG.LISReportQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod LISReportQryExe(Rt As DWR.ORD.MSG.LISReportQryRt) As DWR.ORD.MSG.LISReportQryRp
{
	set $ZT="LISReportQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到检验报告记录"
	set Rp=##Class(DWR.ORD.MSG.LISReportQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set GroupBy=Rt.GroupBy
	
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
	
	set OEORDRowID=$order(^OEORD(0,"Adm",EpisodeID,""))
	if (OEORDRowID="")
	{
		do OutputResult("100","没有查询到检验报告记录")
    	quit Rp
	}
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	set myJob=$job
	kill ^TMP("DWRLISREPORT",myJob)
	set LabTestSetRow=""
	while($order(^OEORDi(0,"LabTS",OEORDRowID,LabTestSetRow))'="")
	{
		set LabTestSetRow=$order(^OEORDi(0,"LabTS",OEORDRowID,LabTestSetRow))
		set ChildSub="0"
		while ($order(^OEORDi(0,"LabTS",OEORDRowID,LabTestSetRow,ChildSub))'="")
		{
			set ChildSub=$order(^OEORDi(0,"LabTS",OEORDRowID,LabTestSetRow,ChildSub))
			set OrdItemID=OEORDRowID_"||"_ChildSub
			set StatusID=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",13)
			set StatusCode=$piece($get(^OEC("OSTAT",StatusID)),"^",1)
			
			if ((StatusCode'="E")&&(StatusCode'="V")) continue
			set ArcimRowID=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",2)
			set ARCSubCatDr=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",10)
			if (ARCSubCatDr="") {do myObj.%Close() continue}           // 过滤没有医嘱子类的错误数据
			set ARCSubCatCode=$piece($get(^ARC("IC",ARCSubCatDr)),"^",1)
			if ($data(^DHCDWRSET("ORD","LabOrdSubCat",ARCSubCatCode))) continue   // 过滤不显示的医嘱
			
			set ResultCode="0"
			set ResultContent="查询成功"
			
			set OrdItemDesc=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",2)
			set OrdStartDate=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",9)
			set OrdStartDate=$ZDate(OrdStartDate,3)
			set LabTestSetRow=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,3)),"^",35)
			if (GroupBy="Date")
			{
				set Group1=OrdStartDate
			}
			else
			{
				set Group1=OrdItemDesc
			}
			
			set ^TMP("DWRLISREPORT",myJob,Group1,OrdStartDate,OrdItemID)=LabTestSetRow
			
				
		}
	}
	
	
	set Group1=""
	while($order(^TMP("DWRLISREPORT",myJob,Group1))'="")
	{
		set Group1=$order(^TMP("DWRLISREPORT",myJob,Group1))
		set GroupObj=##Class(DWR.ORD.MSG.LISReportGroup).%New()
		set GroupObj.GroupName=Group1
		
		set myOrdStartDate=""
		while($order(^TMP("DWRLISREPORT",myJob,Group1,myOrdStartDate),-1)'="")
		{
			set myOrdStartDate=$order(^TMP("DWRLISREPORT",myJob,Group1,myOrdStartDate),-1)
			set myOrdItemID=""
			while($order(^TMP("DWRLISREPORT",myJob,Group1,myOrdStartDate,myOrdItemID))'="")
			{
				set myOrdItemID=$order(^TMP("DWRLISREPORT",myJob,Group1,myOrdStartDate,myOrdItemID))
				set myLabTestSetRow=^TMP("DWRLISREPORT",myJob,Group1,myOrdStartDate,myOrdItemID)
				do OutputLISReport
			}
		}
		do Rp.LISReportGroupList.Insert(GroupObj)
		do GroupObj.%Close()
		
	}
	
	kill ^TMP("DWRLISREPORT",myJob)	
	
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	

OutputLISReport

	set RowObj=##class(DWR.ORD.MSG.LISReport).%New()			
	set myrtn=..GetOneLISReport(myLabTestSetRow,myOrdItemID,.RowObj)
	if (+myrtn="0")
	{
		do GroupObj.LISReportList.Insert(RowObj)			
	}
			
	do RowObj.%Close()
	quit
OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
LISReportQryExeET
	set Rp=##Class(DWR.ORD.MSG.LISReportQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

/// 取一个检验报告
ClassMethod GetOneLISReport(myLISLabNo As %String, myOrdItemID As %String, myLISReportObj As DWR.ORD.MSG.LISReport) As %String
{
	set $ZTrap="GetOneLISReportET"
	set myLISReportStr=..GetOneLisReportFromLab(myLISLabNo,myOrdItemID)
	
	set myReportStr=$piece(myLISReportStr,"$",1)
	set myReportItemStr=$piece(myLISReportStr,"$",2)
	
    if (myReportStr="") 
    {
    	quit "100^没有查到任何结果"
	}	
	set rtn="0",ResultContent="查询成功"
	
	set myLISReportObj.LabNo=$piece(myReportStr,"~",4)
	set myLISReportObj.LabSerialNo=""
	set myLISReportObj.CategroryNo=""
	set myLISReportObj.ReportType=""
	set myLISReportObj.LabItemCode=$piece(myReportStr,"~",2)
	set myLISReportObj.LabItemDesc=$piece(myReportStr,"~",3)
	set myLISReportObj.LabLoc=$piece(myReportStr,"~",1)
	set myLISReportObj.SpecimenType=$piece(myReportStr,"~",13)
	set myLISReportObj.SamplingDate=""
	set ReceiveSpecDate=$piece(myReportStr,"~",16)
	if (ReceiveSpecDate'="") set ReceiveSpecDate=$ZDate(ReceiveSpecDate,3)
	set myLISReportObj.ReceiveSpecDate=ReceiveSpecDate
	set ReportDate=$piece(myReportStr,"~",17)
	if (ReportDate'="") set ReportDate=$ZDate(ReportDate,3)
	set myLISReportObj.ReportDate=ReportDate
	set myLISReportObj.ReportDoctor=$piece(myReportStr,"~",19)
	set myLISReportObj.VerifyDate=""
	set myLISReportObj.VerifyDoctor=""
	
	set ItemCount=$length(myReportItemStr,"~")
 	for myItemIdx=1:1:ItemCount
    {
        set myItemStr=$piece(myReportItemStr,"~",myItemIdx)
        set myOneReportItemStr=$piece(myItemStr,"||",1)
        set myItemGermStr=$piece(myItemStr,"||",2)
        
        set myItemObj=##Class(DWR.ORD.MSG.LISReportItem).%New()
        set myItemObj.SerialNo=$piece(myOneReportItemStr,"@",9)
        set myItemObj.ItemCode=$piece(myOneReportItemStr,"@",1)
        set myItemObj.ItemDesc=$piece(myOneReportItemStr,"@",2)
        set myItemObj.Abbreviation=$piece(myOneReportItemStr,"@",3)
        set myItemObj.Result=$piece(myOneReportItemStr,"@",4)
        set myItemObj.ResultValue=$piece(myOneReportItemStr,"@",5)
        set myItemObj.Unit=$piece(myOneReportItemStr,"@",6)
        set myItemObj.UpDownFlag=$piece(myOneReportItemStr,"@",7)
        set myItemObj.NaturalRange=$piece(myOneReportItemStr,"@",8)
        if (myItemObj.ItemDesc="备注")
        {
	        do myItemObj.%Close()
	        continue
	    }
        /*
        set myGermCount=$length(myItemGermStr,"&")
		for myGermIdx=1:1:myGermCount
		{
			set myGermStr=$piece(myItemGermStr,"&",myGermIdx)
			
			set ItemGermObj=##Class(DTR.ENS.ADM.MSG.HIS.LISReportItemGerm).%New()
			set ItemGermObj.GermSerialNo=$piece(myGermStr,"@",6)
			set ItemGermObj.AntibioticCode=$piece(myGermStr,"@",1)
			set ItemGermObj.AntibioticName=$piece(myGermStr,"@",2)
			set ItemGermObj.MIC=$piece(myGermStr,"@",3)
			set ItemGermObj.Sensitivity=$piece(myGermStr,"@",4)
			set ItemGermObj.UsageMethod=$piece(myGermStr,"@",5)

			do myItemObj.LISReportItemGermList.Insert(ItemGermObj)
			do ItemGermObj.%Close()
		}
		*/
		do myLISReportObj.LISReportItemList.Insert(myItemObj)
	    do myItemObj.%Close()
        
    }
    
    quit rtn_"^"_ResultContent
GetOneLISReportET
	quit "-1"_"^"_$ZERROR
}

/// 从LabTrak取一个检验报告信息
ClassMethod GetOneLisReportFromLab(LabTestSetRow As %String, OEORIRowID As %String) As %String
{
	set myReportStr="",myReportItemStr=""
	set LabNo=$piece(LabTestSetRow,"||",1)
	set TestSet=$piece(LabTestSetRow,"||",2)
	set TestSetRow=$piece(LabTestSetRow,"||",3)
	set RecLocDr=$piece($get(^OEORD(+OEORIRowID,"I",$piece(OEORIRowID,"||",2),3)),"^",6)
	set LabLoc=$piece($get(^CTLOC(RecLocDr)),"^",2)
	if LabLoc["-" set LabLoc=$piece(LabLoc,"-",2)
	set ArcimRowID=$piece($get(^OEORD(+OEORIRowID,"I",$piece(OEORIRowID,"||",2),1)),"^",2)
	set ItemCode=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",1)
	set ItemDesc=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",2) 
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    zn LABDATA
    	set myjob=$job
        kill ^TMP("DWR","TS",myjob,TestSet)
        set num="0"
        while ($order(^TTAB("TS",TestSet,0,num))'="")
        {
	        set num=$order(^TTAB("TS",TestSet,0,num))
	        set TestItmCode=$piece($get(^TTAB("TS",TestSet,0,num)),"\\",3)
	        set TestItmName=$piece($get(^TTAB("TS",TestSet,0,num)),"\\",1)
	        set ^TMP("DWR","TS",myjob,TestSet,TestItmCode)=num
	    }
        
    	if ($data(^TEPI(LabNo,1,TestSet,TestSetRow)))
    	{
	    	set ReceiveDate=$piece(^TEPI(LabNo,1,TestSet,TestSetRow),"\",21)
	    	//if ReceiveDate'="" set ReceiveDate=$ZDate(ReceiveDate,3)
	    	set ReportDate=$piece(^TEPI(LabNo,1,TestSet,TestSetRow),"\",4)
	    	//if ReportDate'="" set ReportDate=$ZDate(ReportDate,3)
	    	set ReportUserCode=$piece(^TEPI(LabNo,1,TestSet,TestSetRow),"\",6)
	    	set ReportUser=""
	    	if (ReportUserCode'="") set ReportUser=$piece($get(^SSU("SSUSR",1,ReportUserCode)),"^",2)
	    	set SpecimenType=""
	    	set SpecimenTypeCode=$piece(^TEPI(LabNo,1,TestSet,TestSetRow),"\",46)
	    	if (SpecimenTypeCode'="") set SpecimenType=$piece($get(^TTAB("SPEC",SpecimenTypeCode)),"\",1)
	    	set SpecimenNo=$piece(^TEPI(LabNo,1,TestSet,TestSetRow),"\",47)
	    	
	    	set myReportStr=LabLoc_"~"_ItemCode_"~"_ItemDesc_"~"_LabNo_"~"_SpecimenNo_"~"_""_"~"_""_"~"_""
			set myReportStr=myReportStr_"~"_""_"~"_""_"~"_""_"~"_""_"~"_SpecimenType_"~"_""_"~"_""
			set myReportStr=myReportStr_"~"_ReceiveDate_"~"_ReportDate_"~"_""_"~"_ReportUser_"~"_"~"_"~"_""_"~"_""
			
			set TestItem="0"
			//while ($order(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem))'="")
			while ($order(^TMP("DWR","TS",myjob,TestSet,TestItem))'="")
			{
				//set TestItem=$order(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem))
				set TestItem=$order(^TMP("DWR","TS",myjob,TestSet,TestItem))
				set ItemCode=TestItem
				set ItemDesc=$piece($get(^TTAB("TC",TestItem)),"\",1)
				set Abbreviation="",Result="",ResultValue="",UpdownFlag="",SerialNo=""
				set ItemUnits="",Ranges=""
				set myOneItemGermStr="",myItemGermStr=""
				if ($get(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem))'="")
				{
					//set ItemUnits=$$Units^DHCCTTCU(TestItem,ReportDate)
					set Result=""
					set ResultValue=$piece($get(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem)),"\",1)
					set SerialNo=""
					set testitm=TestItem
					set mytmpItemStr=$$TestItmRes^CHDhcLabReport(LabNo,TestItem,ResultValue,ReportDate)
				
					set Abbreviation=$piece(mytmpItemStr,$Char(2),3)
					set ItemUnits=$piece(mytmpItemStr,$Char(2),5)
					if (ItemUnits["~") set ItemUnits=$TRANSLATE(ItemUnits,"~","-")
					set Ranges=$piece(mytmpItemStr,$Char(2),7)
					if (Ranges["~") set Ranges=$TRANSLATE(Ranges,"~","-")
					set UpdownFlag=$piece(mytmpItemStr,$Char(2),6)
					if (UpdownFlag="H") set UpdownFlag="↑"
					if (UpdownFlag="L") set UpdownFlag="↓"
					set myOneItemGermStr="",myItemGermStr=""
					set GermId="0"
					while ($order(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem,"ANT",GermId))'="")
					{
						set GermId=$order(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem,"ANT",GermId))
						set Sensitivity=""
						set SensitivityDr=$piece($get(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem,"ANT",GermId)),"\",1)
						if (SensitivityDr'="") set Sensitivity=$piece($get(^TTAB("SENS",SensitivityDr)),"\",1)
						set MIC=$piece($get(^TEPI(LabNo,1,TestSet,TestSetRow,"DATA",TestItem,"ANT",GermId)),"\",3)
						set AntibioticCode=GermId
						set AntibioticName=$piece($get(^TTAB("ANT",AntibioticCode)),"\",1)
						set UsageMethod=""
						set myOneItemGermStr=AntibioticCode_"@"_AntibioticName_"@"_MIC_"@"_Sensitivity_"@"_UsageMethod_"@"_""
						if (myItemGermStr="")
						{
							set myItemGermStr=myOneItemGermStr
						}
						else
						{
							set myItemGermStr=myItemGermStr_"&"_myOneItemGermStr
						}
					
					}
				}
				
				set myOneReportItemStr=ItemCode_"@"_ItemDesc_"@"_Abbreviation_"@"_Result_"@"_ResultValue_"@"_ItemUnits_"@"_UpdownFlag_"@"_Ranges_"@"_SerialNo
            	set myOneReportItemStr=myOneReportItemStr_"||"_myItemGermStr
            	if (myReportItemStr="")
            	{
	            	set myReportItemStr=myOneReportItemStr
	            }
            	else
	            {
		            set myReportItemStr=myReportItemStr_"~"_myOneReportItemStr
		        }
			}
	    }
		kill ^TMP("DWR","TS",myjob,TestSet)
    zn CurrentNS
	quit myReportStr_"$"_myReportItemStr
}

/// 查询检验项目图表数据
ClassMethod LISTestItemChartQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="LISTestItemChartQryET"
	set pResponse=##Class(DWR.ORD.MSG.LISTestItemChartQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.ORD.MSG.LISTestItemChartQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..LISTestItemChartQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
LISTestItemChartQryET
	set pResponse=##Class(DWR.ORD.MSG.LISTestItemChartQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod LISTestItemChartQryExe(Rt As DWR.ORD.MSG.LISTestItemChartQryRt) As DWR.ORD.MSG.LISTestItemChartQryRp
{
	set $ZT="LISTestItemChartQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到检验报告记录"
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    
	set Rp=##Class(DWR.ORD.MSG.LISTestItemChartQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set TestItemCode=Rt.TestItemCode
	if (EpisodeID="")
	{
		do OutputResult("101","就诊ID不能为空")
	    Quit Rp
	}
	if ('$data(^PAADM(EpisodeID)))
	{
		do OutputResult("102","就诊ID不存在")
    	quit Rp
	}
	
	set OEORDRowID=$order(^OEORD(0,"Adm",EpisodeID,""))
	if (OEORDRowID="")
	{
		do OutputResult("100","没有查询到检验报告记录")
    	quit Rp
	}
	if (TestItemCode="")
	{
		do OutputResult("103","检验项目代码不能为空")
    	quit Rp
	}
	set TestItemDesc=$piece($get(^TTAB("TC",TestItemCode)),"\",1)
	
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	set PatInfoStr=##Class(DWR.PAT.BL.Patient).GetPatientByRowId(PatientID)
	set RegNo=$piece(PatInfoStr,"^",2)
	if (RegNo="")
	{
		do OutputResult("104","没有找到患者信息")
    	quit Rp
	}
 
    set LISTestItemStr=""
    
    zn LABDATA
	
	set myDate=""
	while($order(^TDHCOldResult(1,RegNo,TestItemCode,myDate))'="")
	{
		set myDate=$order(^TDHCOldResult(1,RegNo,TestItemCode,myDate))
		set myTime=""
		while ($order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime))'="")
		{
			set myTime=$order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime))
			set LabNo=""
			while($order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo))'="")
			{
				set LabNo=$order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo))
				set TestSetCode=""
				while($order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo,TestSetCode))'="")
				{
					set TestSetCode=$order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo,TestSetCode))
					set TestSetRow=""
					while($order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo,TestSetCode,TestSetRow))'="")
					{
						set TestSetRow=$order(^TDHCOldResult(1,RegNo,TestItemCode,myDate,myTime,LabNo,TestSetCode,TestSetRow))
						
						set Result=""
						set ResultValue=$piece($get(^TEPI(LabNo,1,TestSetCode,TestSetRow,"DATA",TestItemCode)),"\",1)	
						if ($number(ResultValue)="") continue          // 过滤结果值不是数字的的记录
						set ResultCode="0"
						set ResultContent="查询成功"
						set SerialNo=""
						set mytmpItemStr=$$TestItmRes^CHDhcLabReport(LabNo,TestItemCode,ResultValue,myDate)
						
						set Abbreviation=$piece(mytmpItemStr,$Char(2),3)
						set ItemUnits=$piece(mytmpItemStr,$Char(2),5)
						if (ItemUnits["~") set ItemUnits=$TRANSLATE(ItemUnits,"~","-")
						set Ranges=$piece(mytmpItemStr,$Char(2),7)
						if (Ranges["~") set Ranges=$TRANSLATE(Ranges,"~","-")
						set UpdownFlag=$piece(mytmpItemStr,$Char(2),6)
						if (UpdownFlag="H") set UpdownFlag="↑"
						if (UpdownFlag="L") set UpdownFlag="↓"
						set LabTestSetRow=LabNo_"||"_TestSetCode_"||"_TestSetRow
						set LabOrderItemdesc=$piece($get(^TTAB("TS",TestSetCode)),"\",1)
						set tmpStr=TestItemCode_"@"_TestItemDesc_"@"_Abbreviation_"@"_Result_"@"_ResultValue_"@"_ItemUnits_"@"_UpdownFlag_"@"_Ranges_"@"_SerialNo_"@"_LabTestSetRow_"@"_LabOrderItemdesc_"@"_$ZDate(myDate,3)_"@"_$ZTime(myTime,2)
						if (LISTestItemStr="")
						{
							set LISTestItemStr=tmpStr
						}
						else
						{
							set LISTestItemStr=LISTestItemStr_$char(2)_tmpStr
						}
						
					}
				}
			}	
		}
	}
	
	zn CurrentNS
	
	if (LISTestItemStr'="")
	{
		set myRow=$length(LISTestItemStr,$char(2))
		for i=1:1:myRow
		{
			set mytmpStr=$piece(LISTestItemStr,$char(2),i)
			set myItemObj=##Class(DWR.ORD.MSG.LISTestItem).%New()
			set myItemObj.SerialNo=$piece(mytmpStr,"@",9)
        	set myItemObj.ItemCode=$piece(mytmpStr,"@",1)
        	set myItemObj.ItemDesc=$piece(mytmpStr,"@",2)
        	set myItemObj.Abbreviation=$piece(mytmpStr,"@",3)
        	set myItemObj.Result=$piece(mytmpStr,"@",4)
        	set myItemObj.ResultValue=$piece(mytmpStr,"@",5)
        	set myItemObj.Unit=$piece(mytmpStr,"@",6)
        	set myItemObj.UpDownFlag=$piece(mytmpStr,"@",7)
        	set myItemObj.NaturalRange=$piece(mytmpStr,"@",8)
        	set myItemObj.LabTestSetRow=$piece(mytmpStr,"@",10)
        	set myItemObj.LabOrderItemdesc=$piece(mytmpStr,"@",11)
        	set myItemObj.ReportDate=$piece(mytmpStr,"@",12)
        	set myItemObj.ReportTime=$piece(mytmpStr,"@",13)
        	set sc=Rp.LISTestItemList.Insert(myItemObj)
        	do myItemObj.%Close()
		}
	}
	

	do OutputResult(ResultCode,ResultContent)
	quit Rp
	


OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
LISTestItemChartQryExeET
	zn CurrentNS
	set Rp=##Class(DWR.ORD.MSG.LISTestItemChartQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

}
