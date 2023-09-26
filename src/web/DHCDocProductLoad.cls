/// 医生站产品维护
/// 1.导入导出产品
Class web.DHCDocProductLoad Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// HIS版本
/// P5,P7,P8
/// P8版本代表P8及以上版本
Parameter DTHealthVersion = "P8";

/// 导出/导入的路径
Parameter LoadPath = "c:\temp\";

/// 导出js,csp路径
Parameter WebLoadPath = "dthealth/web/";

/// 导出/导入组件路径
Parameter ComponentPath = "c:\temp\Component\";

/// 导出/导入菜单路径
Parameter MenuPath = "c:\temp\Menu\";

/// 导出产品
/// w ##class(web.DHCDocProductLoad).ExportProduct()
ClassMethod ExportProduct()
{
	s CacheVersion=$SYSTEM.OBJ.Version()
	Set BuildOS=$SYSTEM.Version.GetBuildOS()
	Set BuildOS=$zcvt(BuildOS,"U")
	
	;公共部分
	;1.导出class,csp,js,Mac,Int,工程,包
	s errorlog=""
	d ..ExportClass()
	d ..ExportAppRouList()
	d ..ExportMedRouList()
	d ..ExportCsp()
	d ..ExportJs()
	d ..ExportProject()
	
	;2.导出组件
	d ..ExportComponent()
	
	;3.导出菜单
	d ..ExportMenu()
	
	;特殊部分
	i ..#DTHealthVersion="P8" {
		
	}elseif ..#DTHealthVersion="P7" {
		
	}elseif ..#DTHealthVersion="P5" {
		
	}
	
	Q 0
}

/// 导入产品
/// w ##class(web.DHCDocProductLoad).ImportProduct()
ClassMethod ImportProduct()
{
	;公共部分
	;1.导入class,csp,js,Mac,Int,工程,包
	s errorlog=""
	d ..ImportClass()
	d ..ImportAppRouList()
	d ..ImportMedRouList()
	d ..ImportCsp()
	d ..ImportJs()
	d ..ImportProject()

	;2.导入组件
	d ..ImportComponent()
	;3.导入菜单
	d ..ImportMenu()

	i ..#DTHealthVersion="P8" {
		
	}elseif ..#DTHealthVersion="P7" {
		
	}elseif ..#DTHealthVersion="P5" {
		
	}
	
	Q 0
}

ClassMethod ExportClass()
{
	s ExportClsList=$LB()
	s $List(ExportClsList,1)="web.DHCDoc*.cls"
	s $List(ExportClsList,2)="web.DHCOPAdm*.cls"
	s $List(ExportClsList,3)="web.DHCOEOrd*.cls"
	s $List(ExportClsList,4)="web.UDHCStopOrder*.cls"
	s $List(ExportClsList,5)="User.DHCDoc*.cls"
	s $List(ExportClsList,6)="web.dhcorderlist.cls"
	s $List(ExportClsList,7)="web.DHCDTHealthCommon.cls"
	s $List(ExportClsList,8)="User.DHCReg*.cls"
	s $List(ExportClsList,9)="User.DHCQueue*.cls"
	s $List(ExportClsList,10)="User.DHCRBAppointment.cls"
	s $List(ExportClsList,11)="User.DHCRBAppt*.cls"
	s $List(ExportClsList,12)="User.DHCCardRef.cls"
	s $List(ExportClsList,13)="User.DHCCardStatusChange.cls"
	s $List(ExportClsList,14)="User.DHCCardTypeDef.cls"
	s $List(ExportClsList,15)="User.DHCCardPATRegConfig.cls"
	s $List(ExportClsList,16)="User.DHCCardHardDLLFunction.cls"
	s $List(ExportClsList,17)="User.DHCCardHard*.cls"
	s $List(ExportClsList,18)="User.DHCCardGroupPerson.cls"
	s $List(ExportClsList,19)="web.DHCRB*.cls"
	s $List(ExportClsList,20)="web.DHCAlloc.cls"
	s $List(ExportClsList,21)="User.DHCOPChgDepMarkSet.cls"
	s $List(ExportClsList,22)="web.DHCOPChgDepMarkSet.cls"
	s $List(ExportClsList,23)="User.DHCTimeRange.cls"
	s $List(ExportClsList,24)="web.DHCTimeRange.cls"
	s $List(ExportClsList,25)="User.DHCExa*.cls"
	s $List(ExportClsList,26)="web.DHCExa*.cls"
	s $List(ExportClsList,27)="User.DHCBor*.cls"
	s $List(ExportClsList,28)="User.DHCDepMark.cls"
	s $List(ExportClsList,29)="web.DHCDepMark.cls"
	s $List(ExportClsList,30)="User.DHCRoomComp.cls"
	
	
	;Class
	s ClassInfoAry=""
	s ClassInfoQuery=##class(%ResultSet).%New("%Library.ClassDefinition:ClassInfo")
	If ClassInfoQuery.QueryIsValid() { 
		Set Status=ClassInfoQuery.Execute("")
		If 'Status Quit
		While (ClassInfoQuery.Next()) {
			s ClassName=ClassInfoQuery.GetDataByName("Name")
			s TimeChanged=ClassInfoQuery.GetDataByName("TimeChanged")
			s IncludeFlag=..IsIncludeStr(ExportClsList,ClassName)
			i IncludeFlag {
				s ClassInfoAry(ClassName_".cls")=""
			}
		}
	}
    
    s LoadPath=..#LoadPath_"Doc-class.xml"
	s sc=$SYSTEM.OBJ.Export(.ClassInfoAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出类错误,错误信息:"_$g(errorlog),!
	
	q
}

ClassMethod ExportAppRouList()
{
	s AppExportRouList=$LB()
	s $List(AppExportRouList,1)="DHCDoc*.MAC"
	s $List(AppExportRouList,2)="DHCReg*.MAC"
	s $List(AppExportRouList,3)="DHCComponent.MAC"
	s $List(AppExportRouList,4)="DHCComponent68.MAC"
	s $List(AppExportRouList,5)="DHCComponentDoc.MAC"
	s $List(AppExportRouList,6)="DHCComponentReg.MAC"
	s $List(AppExportRouList,7)="CHPAT13NEW.MAC"
	s $List(AppExportRouList,8)="DHCOE*.MAC"
	s $List(AppExportRouList,9)="DHCaOET1.MAC"
	
	;APPRoutine
	s AppRoutineStr=$LISTTOSTRING(AppExportRouList,",",1)
	s AppRoutineAry=""
	s AppRoutineQuery=##class(%ResultSet).%New("%Library.Routine:RoutineList")
	If AppRoutineQuery.QueryIsValid() { 
		Set Status=AppRoutineQuery.Execute(AppRoutineStr)
		If 'Status Quit
		While (AppRoutineQuery.Next()) {
			s AppRoutineName=AppRoutineQuery.GetDataByName("Name")
			s AppLastModifyDate=AppRoutineQuery.GetDataByName("Date")
			s AppRoutineAry(AppRoutineName)=""
		}
	}
	s LoadPath=..#LoadPath_"Doc-approutine.xml"
	s sc=$SYSTEM.OBJ.Export(.AppRoutineAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出APP下的Routine错误,错误信息:"_$g(errorlog),!
	
	q
}

ClassMethod ExportMedRouList()
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	
	s MedExportRouList=$LB()
	s $List(MedExportRouList,1)="DHCDoc*.MAC"
	s $List(MedExportRouList,2)="CHBB1.INT"
	s $List(MedExportRouList,3)="CHPAT13.INT"
	s $List(MedExportRouList,4)="aOET*.INT"
	
	ZN "DHC-MEDSRC"		
	;MEDRoutine
	s MedRoutineStr=$LISTTOSTRING(MedExportRouList,",",1)
	s MedRoutineAry=""
	s MedRoutineQuery=##class(%ResultSet).%New("%Library.Routine:RoutineList")
	If MedRoutineQuery.QueryIsValid() { 
		Set Status=MedRoutineQuery.Execute(MedRoutineStr)
		If 'Status Quit
		While (MedRoutineQuery.Next()) {
			s MedRoutineName=MedRoutineQuery.GetDataByName("Name")
			s MedLastModifyDate=MedRoutineQuery.GetDataByName("Date")
			s MedRoutineAry(MedRoutineName)=""
		}
	}
	s LoadPath=..#LoadPath_"Doc-medroutine.xml"
	s sc=$SYSTEM.OBJ.Export(.MedRoutineAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出MED下的Routine错误,错误信息:"_$g(errorlog),!
	ZN CurrentNS
	q
}

ClassMethod ExportCsp()
{
	s ExportCspList=$LB()
	s $List(ExportCspList,1)="oeorder.oplistcustom.csp"
	s $List(ExportCspList,2)="oeorder.cmlistcustom.csp"
	s $List(ExportCspList,3)="dhcmrdiagnosnew.csp"
	s $List(ExportCspList,4)="dhcorderlist.csp"
	s $List(ExportCspList,5)="dhcdocoeorder.csp"
	s $List(ExportCspList,6)="dhcdocoeorderdata.csp"
	s $List(ExportCspList,7)="dhcdhcdocoverallinfo.csp"
	s $List(ExportCspList,8)="dhc.reg.appschedulerdata.csp"
	s $List(ExportCspList,9)="dhc.reg.appscheduler.csp"
	s $List(ExportCspList,10)="dhcmrdiagnos.edit.csp"
	s $List(ExportCspList,11)="dhc.nurse.subscriberegister.csp"
	s $List(ExportCspList,12)="dhcopadm.reg.csp"
	s $List(ExportCspList,13)="dhcopadm.reg.tree.csp"
	
	;csp
	s ExportCspStr=$LISTTOSTRING(ExportCspList,",",1)
	s ExportCspAry=""
	for i=1:1:$l(ExportCspStr,",") {
		Continue:$p(ExportCspStr,",",i)=""
		s ExportCspAry(..#WebLoadPath_"csp/"_$p(ExportCspStr,",",i))=""
	}
	s LoadPath=..#LoadPath_"Doc-csp.xml"
	s sc=$SYSTEM.OBJ.Export(.ExportCspAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出csp错误,错误信息:"_$g(errorlog),!
	q
}

ClassMethod ExportJs()
{
	s ExportJsList=$LB()
	s $List(ExportJsList,1)="DHCOPAdm.Reg.js",$List(ExportJsList,2)="DHCDocOutPatientList.js"
	s $List(ExportJsList,3)="DHCDocInPatientList.js",$List(ExportJsList,4)="DHCDocEmergencyPatientList.js"
	s $List(ExportJsList,5)="DHCDocRapidRegist.js",$List(ExportJsList,6)="DHCDocTransfer.JS"
	s $List(ExportJsList,7)="DHCDocTransFusion.js",$List(ExportJsList,8)="UDHCMRDiagnos.Edit.js"
	s $List(ExportJsList,9)="UDHCOEOrder.CHNMEDEntry.js",$List(ExportJsList,10)="UDHCOEOrder.List.Custom.js"
	s $List(ExportJsList,11)="UDHCOEOrder.DepProcNote.js",$List(ExportJsList,12)="UDHCOEOrder.Item.List.js"
	s $List(ExportJsList,13)="DHCDHCDepMarknew.js",$List(ExportJsList,14)="DHCDoc.Consultation.js"
	s $List(ExportJsList,15)="DHCDoc.Patient.js",$List(ExportJsList,16)="DHCDoc.Transfer.js"
	s $List(ExportJsList,17)="DHCDocAntibioticApply.js",$List(ExportJsList,18)="DHCDocAntibioticVerify.js"
	s $List(ExportJsList,19)="DHCDocAntiManagement.js",$List(ExportJsList,20)="DHCDocGetInspectOrder.js"
	s $List(ExportJsList,21)="DHCDocIndicationsChoose.js",$List(ExportJsList,22)="DHCDocInstrLinkOrdItem.js"
	s $List(ExportJsList,23)="DHCDocIPBClass.js",$List(ExportJsList,24)="DHCDocIPBCommonFunction.js"
	s $List(ExportJsList,25)="DHCDocIPBDataAccess.js",$List(ExportJsList,26)="DHCDocIPBDicEdit.js"
	s $List(ExportJsList,27)="DHCDocIPBKTempDtlEdit.js",$List(ExportJsList,28)="DHCDocIPBKTempEdit.js"
	s $List(ExportJsList,29)="DHCDocIPBKTItmEdit.js",$List(ExportJsList,30)="DHCDocIPBookExtra.js"
	s $List(ExportJsList,31)="DHCDocIPBookList.js",$List(ExportJsList,32)="DHCDocIPBookNew.js"
	s $List(ExportJsList,33)="DHCDocIPBookQry.js",$List(ExportJsList,34)="DHCDocIPBSerialize.js"
	s $List(ExportJsList,35)="DHCDocItemDefaultOrder.js",$List(ExportJsList,36)="DHCDocNurAddOrderList.JS"
	s $List(ExportJsList,37)="DHCDocNurAddOrderSearch.JS",$List(ExportJsList,38)="DHCDocOEForSelfMedicinalOrder.js"
	s $List(ExportJsList,39)="dhcdocoeordercfg.js",$List(ExportJsList,40)="dhcdocoeordermain.js"
	s $List(ExportJsList,41)="UDHCOEOrder.List.Verify.js",$List(ExportJsList,42)="UDHCOEOrder.OSItem.js"
	
	;js
	s ExportJsStr=$LISTTOSTRING(ExportJsList,",",1)
	s ExportJsAry=""
	for i=1:1:$l(ExportJsStr,",") {
		Continue:$p(ExportJsStr,",",i)=""
		s ExportJsAry(..#WebLoadPath_"scripts/"_$p(ExportJsStr,",",i))=""
	}
	s LoadPath=..#LoadPath_"Doc-js.xml"
	s sc=$SYSTEM.OBJ.Export(.ExportJsAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出csp错误,错误信息:"_$g(errorlog),!
	q
}

ClassMethod ExportProject()
{
	s ExportPrjList=$LB()
	s $List(ExportPrjList,1)="Project_PilotPro.prj"
	;project
	s ExportPrjStr=$LISTTOSTRING(ExportPrjList,",",1)
	s ExportPrjAry=""
	for i=1:1:$l(ExportPrjStr,",") {
		Continue:$p(ExportPrjStr,",",i)=""
		s ExportPrjAry($p(ExportPrjStr,",",i))=""
	}
	s LoadPath=..#LoadPath_"Doc-project.xml"
	s sc=$SYSTEM.OBJ.Export(.ExportPrjAry,LoadPath,"",.errorlog)
	if $$$ERROR(sc) w "导出工程文件错误,错误信息:"_$g(errorlog),!
	q
}

ClassMethod ExportComponent()
{
	s ExportCompList=$LB()
	s $List(ExportCompList,1)="DHCCard*"
	s $List(ExportCompList,2)="UDHCCard*"
	s $List(ExportCompList,3)="UDHCDoc*"
	s $List(ExportCompList,4)="DHCDoc*"
	s $List(ExportCompList,5)="DHCOPAdm*"
	s $List(ExportCompList,6)="DHCOPReg*"
	s $List(ExportCompList,7)="DHC.OPReg*"
	s $List(ExportCompList,8)="DHCOPReturn"
	s $List(ExportCompList,9)="DHCReg*"
	s $List(ExportCompList,10)="DHCRB*"
	s $List(ExportCompList,11)="UDHCStop*"
	s $List(ExportCompList,12)="DHCAlloc"
	
	s ExistsFlag=##class(%File).DirectoryExists(..#ComponentPath)
	i 'ExistsFlag s ExistsFlag=##class(%File).CreateDirectoryChain(..#ComponentPath)
	i 'ExistsFlag w "创建导出组件的目录失败",!
	
	for ExCompI=1:1:$listlength(ExportCompList) {
		s ExportCompItem=$List(ExportCompList,ExCompI)
		i ExportCompItem["*" {
			s MatchStr="%"_$p(ExportCompItem,"*",1)_"%"
			&SQL(DECLARE CompCursor CURSOR FOR
			SELECT ID into :RowId From websys.component Where Name like :MatchStr)
			&SQL(OPEN CompCursor)
 			For {
	 			&SQL(FETCH CompCursor) QUIT:SQLCODE 
				s CompItemObj=##class(websys.Component).%OpenId(RowId)
				s CompName=CompItemObj.Name
				d ##class(web.Util.UtilService).GetExportComponents(CompName,..#ComponentPath)
				kill CompItemObj
 			}
 			&SQL(CLOSE CompCursor)
		}else{
			&sql(SELECT ID into :RowId From websys.component Where Name=:ExportCompItem)
			s CompItemObj=##class(websys.Component).%OpenId(RowId)
			if $ISOBJECT(CompItemObj) {
				s CompName=CompItemObj.Name
				d ##class(web.Util.UtilService).GetExportComponents(CompName,..#ComponentPath)
				kill CompItemObj
			}
		}
	}
	q
}

ClassMethod ExportMenu()
{
	s ExportMenuList=$LB()
	s $List(ExportMenuList,1)="DHC.Inpatient.Doctor*"
	s $List(ExportMenuList,2)="DHC.Outpatient.Doctor*"

	for ExMuI=1:1:$listlength(ExportMenuList) {
		s ExportMenuItem=$List(ExportMenuList,ExMuI)
		i ExportMenuItem["*" {
			s MatchStr="%"_$p(ExportMenuItem,"*",1)_"%"
			&SQL(DECLARE MenuCursor CURSOR FOR
			SELECT ID into :RowId From websys.menu Where Name like :MatchStr)
			&SQL(OPEN MenuCursor)
 			For {
	 			&SQL(FETCH MenuCursor) QUIT:SQLCODE 
				s MenuItemObj=##class(websys.Menu).%OpenId(RowId)
				s MenuName=MenuItemObj.Name
				d ##class(web.DHCDocProductLoadCommon).ExportMenuToXml(RowId,MenuName,..#MenuPath)
				kill MenuItemObj
 			}
 			&SQL(CLOSE MenuCursor)
		}else{
			&sql(SELECT ID into :RowId From websys.menu Where Name=:ExportMenuItem)
			s MenuItemObj=##class(websys.Menu).%OpenId(RowId)
			if $ISOBJECT(MenuItemObj) {
				s MenuName=MenuItemObj.Name
				d ##class(web.DHCDocProductLoadCommon).ExportMenuToXml(RowId,MenuName,..#MenuPath)
				kill MenuItemObj
			}
		}
	}
	q
}

ClassMethod ImportClass()
{
	s FilePath=..#LoadPath_"Doc-class.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportAppRouList()
{
	s FilePath=..#LoadPath_"Doc-approutine.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportMedRouList()
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	s FilePath=..#LoadPath_"Doc-medroutine.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	ZN "DHC-MEDSRC"
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	ZN CurrentNS
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportCsp()
{
	s FilePath=..#LoadPath_"Doc-csp.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportJs()
{
	s FilePath=$parameter(,"LoadPath")_"Doc-js.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportProject()
{
	s FilePath=..#LoadPath_"Doc-project.xml"
	s sc=##class(%Library.File).Exists(FilePath)
	if $$$ERROR(sc) w "File:"_FilePath_" is not exists!",! q
	d $SYSTEM.OBJ.Load(FilePath,"",.errorlog)
	i errorlog'="" w "Import "_wildcard_" error: "_errorlog,! q
	d ##class(%Library.File).Rename(FilePath,FilePath_".imported")    	
	q
}

ClassMethod ImportComponent()
{
	s Directory=..#ComponentPath
	s rs=##class(%Library.ResultSet).%New("%File:FileSet")
	s wildcard="*.xml" ,sortby="DateCreated"
	s FileCnt=1
	s Status=rs.Execute(Directory,wildcard,sortby)
	while rs.Next() 
	{
		s fn=rs.Get("Name"),type=rs.Get("Type")
		i ($p(fn,".",$l(fn,"."))="xml")&&(fn'[".cls.")
		{
	    	w "filename: ",fn,!
	    	d ##class(web.Util.UtilService).PutComponent(fn)
	    	d ##class(%Library.File).Rename(fn,fn_".imported")
	    	s FileCnt=FileCnt+1
		}
	}
	d rs.%Close()
	q
}

ClassMethod ImportMenu()
{
	s Directory=..#MenuPath
	s rs=##class(%Library.ResultSet).%New("%File:FileSet")
	s wildcard="*.xml" ,sortby="DateCreated"
	s FileCnt=1
	s Status=rs.Execute(Directory,wildcard,sortby)
	while rs.Next() 
	{
		s fn=rs.Get("Name"),type=rs.Get("Type")
		i $p(fn,".",$l(fn,"."))="xml" 
		{
	    	w "filename: ",fn,!
	    	d ##CLASS(web.DHCDocProductLoadCommon).ImportMenu(fn)
	    	d ##class(%Library.File).Rename(fn,fn_".imported")
	    	s FileCnt=FileCnt+1
		}
	}
	d rs.%Close()
	q
}

ClassMethod IsIncludeStr(ExportClsList As %List, ClassName As %String)
{
	n (ExportClsList,ClassName)
	s IncludeFlag=0
	s LBCount=$ListLength(ExportClsList)
	for i=1:1:LBCount {
		s LBItem=$List(ExportClsList,i)
		i LBItem["*" {
			i ClassName[$p(LBItem,"*",1) s IncludeFlag=1 Quit
		}else{
			i ClassName=LBItem s IncludeFlag=1 Quit
		}
	}
	
	Q IncludeFlag
}

}
