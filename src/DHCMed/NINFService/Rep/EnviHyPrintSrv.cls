/// 名称: DHCMed.NINFService.Rep.EnviHyReport
/// 描述: 环境卫生学监测报告打印相关程序
/// 编写者：zhufei
/// 编写日期: 2014-06-13
Class DHCMed.NINFService.Rep.EnviHyPrintSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 打印环境卫生学监测报告
/// w ##Class(DHCMed.NINFService.Rep.EnviHyPrintSrv).PrintEHReport("fillxlSheet,MergCells,DeleteRows",1)
ClassMethod PrintEHReport(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set AskForLoc=objReport.EHRAskForLoc
	quit:AskForLoc="" return
	set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AskForLoc)
	quit:CTHospID="" return
	set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,"NINF")
	quit:SSHospCode="" return
	
	set objItem=objReport.EHRItem        	//检测项目
	quit:'$IsObject(objItem) return
	set ItemDesc=objItem.EHIDesc            //检测项目名称
	set objNorm=objReport.EnviHyNorm
	quit:'$IsObject(objNorm) return
	set EHNRange=objNorm.EHNRange
	set EHNNorm=objNorm.EHNNorm
	set SpecimenNum=objNorm.SpecimenNum     //标本数量
	set SpecimenNum=+SpecimenNum
	quit:SpecimenNum<1 return
	set CenterNum=objNorm.CenterNum         //中心值数量
	set CenterNum=+CenterNum
	set SurroundNum=objNorm.SurroundNum     //周边值数量
	set SurroundNum=+SurroundNum
	set NormDesc=objNorm.EHNNorm            //检测标准
	set NormMax=objNorm.EHNNormMax          //中心值标准
	set NormMin=objNorm.EHNNormMin          //周边值标准
	quit:'$IsObject(objNorm.SpecimenType) return
	set SpecimenType=objNorm.SpecimenType.Description  //标本类型
	
	set ItemObj=objReport.EHRItemObj         //检测对象
	set SpecDate=objReport.EHRDate           //采样日期
	set:SpecDate'="" SpecDate=$zd(SpecDate,3)
	set SpecLoc=AskForLoc
	set SpecLoc=$p($g(^CTLOC(+SpecLoc)),"^",2)  //采样科室
	set:$p(SpecLoc,"-",2)'="" SpecLoc=$p(SpecLoc,"-",2)
	set AskForUser=objReport.EHRAskForUser
	set AskForUser=$p($g(^SSU("SSUSR",+AskForUser)),"^",2)  //申请人
	
	set RepDate=objReport.EHRRepDate         //报告日期
	set:RepDate'="" RepDate=$zd(RepDate,3)
	set RepTime=objReport.EHRRepTime         //报告时间
	set:RepTime'="" RepTime=$zt(RepTime,1)
	set RepLoc=objReport.EHRRepLoc
	set RepLoc=$p($g(^CTLOC(+RepLoc)),"^",2) //报告科室
	set:$p(RepLoc,"-",2)'="" RepLoc=$p(RepLoc,"-",2)
	set RepUser=objReport.EHRRepUser
	set RepUser=$p($g(^SSU("SSUSR",+RepUser)),"^",2)  //报告人
	
	set Result=objReport.EHRResult        //结果
	set Pathogens=objReport.EHRPathogens  //检出致病菌
	set BarCode=objReport.EHRBarCode      //条码
	
	set fillxlSheet=$p(itmjs,",",1)
	set mergCells=$p(itmjs,",",2)
	set deleteRows=$p(itmjs,",",3)
	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SpecDate,"O","JS")_"',"_2_",5);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SpecLoc,"O","JS")_"',"_2_",14);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(AskForUser,"O","JS")_"',"_2_",26);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_3_",5);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(RepTime,"O","JS")_"',"_3_",14);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(RepUser,"O","JS")_"',"_3_",26);"
	&javascript<#(retval)#>
	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(EHNRange,"O","JS")_"',"_4_",5);"
	&javascript<#(retval)#>
	if SpecimenType="手" {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT("医护人员:","O","JS")_"',"_4_",12);"
		&javascript<#(retval)#>
	} elseif SpecimenType="物体表面" {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT("物体表面:","O","JS")_"',"_4_",12);"
		&javascript<#(retval)#>
	} else {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT("监测对象:","O","JS")_"',"_4_",12);"
		&javascript<#(retval)#>
	}
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(ItemObj,"O","JS")_"',"_4_",16);"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(BarCode,"O","JS")_"',"_4_",26);"
	&javascript<#(retval)#>
	
	set tmpNorm="结果("_EHNNorm_")"
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(tmpNorm,"O","JS")_"',"_5_",13);"
	&javascript<#(retval)#>
	
	set Row = 7
	
	//单元格合并
	if (SpecimenNum>1){
		set retval=mergCells_"(xlSheet,"_Row_",1,"_(Row+SpecimenNum-1)_",9);"
		&javascript<#(retval)#>
	} else {
		set retval=mergCells_"(xlSheet,"_Row_",1,"_Row_",12);"
		&javascript<#(retval)#>
	}
	if (CenterNum>1){
		set retval=mergCells_"(xlSheet,"_Row_",27,"_(Row+CenterNum-1)_",30);"
		&javascript<#(retval)#>
	}
	if (SurroundNum>1){
		set retval=mergCells_"(xlSheet,"_(Row+CenterNum)_",27,"_(Row+CenterNum+SurroundNum-1)_",30);"
		&javascript<#(retval)#>
	}
	set OtherNum=SpecimenNum-CenterNum-SurroundNum
	if (OtherNum>1){
		set retval=mergCells_"(xlSheet,"_(Row+CenterNum+SurroundNum)_",27,"_(Row+CenterNum+SurroundNum+OtherNum-1)_",30);"
		&javascript<#(retval)#>
	}
	for indRow=(Row+SpecimenNum):1:30 {
		set retval=deleteRows_"(xlSheet,"_(Row+SpecimenNum)_");"
		&javascript<#(retval)#>
	}
	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(ItemDesc,"O","JS")_"',"_Row_",1);"
	&javascript<#(retval)#>
	
	for ind=1:1:SpecimenNum {
		set SubItemNorm=""
		set SubItemNo=ind
		if (CenterNum>0)&(ind<=CenterNum){
			set SubItemDesc="中心-"_SubItemNo
			set:ind=1 SubItemNorm=NormMax
		} elseif (SurroundNum>0)&(ind<=(SurroundNum+CenterNum)){
			set SubItemDesc="周边-"_SubItemNo
			set:ind=(CenterNum+1) SubItemNorm=NormMin
		} elseif (CenterNum>0)||(SurroundNum>0) {
			set SubItemDesc="参照-"_SubItemNo
			set SubItemNorm="0"
		} else {
			set SubItemDesc="检测-"_SubItemNo
			set:ind=1 SubItemNorm=NormMax
		}
		set SubItemResult=$p(Result,",",ind)
		set SubItemPathogen=$p(Pathogens,",",ind)
		if SubItemDesc'="" {
			set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SubItemDesc,"O","JS")_"',"_Row_",10);"
			&javascript<#(retval)#>
		}
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SubItemResult,"O","JS")_"',"_Row_",13);"
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SubItemPathogen,"O","JS")_"',"_Row_",16);"
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(SubItemNorm,"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		
		//行数累加
		Set Row=Row+1
	}
	
	set return=1
	quit return
}

}
