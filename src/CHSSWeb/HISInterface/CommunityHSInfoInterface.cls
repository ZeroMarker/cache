Class CHSSWeb.HISInterface.CommunityHSInfoInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-08-
/// Description:公共卫生服务情况接口
/// Table：
/// Input:
/// Output：
/// Return：
/// Others：
ClassMethod CommunityHSInfoData(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date)
{
		
		s reportData = ""
		set returnData = ""
				
	    s reportData = ##class(CHSSWeb.HISInterface.CommunityHSInfo).%New()
        
        
        s reportData.FamilyArcNum = ##class(CHSSWeb.CommunityHSInfoService).FamilyArcInfo(CommunityCode, DateOfStart, DateOfEnd)                
        s reportData.PersonArcNum = ##class(CHSSWeb.CommunityHSInfoService).PersonArcInfo(CommunityCode, DateOfStart, DateOfEnd)                
        s reportData.WomenFetusNum = ##class(CHSSWeb.CommunityHSInfoService).WomenFetusInfo(CommunityCode, DateOfStart, DateOfEnd)               
        s reportData.WomenArcNum = ##class(CHSSWeb.CommunityHSInfoService).WomenArcInfo(CommunityCode, DateOfStart, DateOfEnd)                 
        s reportData.WomenCheckArcNum = ##class(CHSSWeb.CommunityHSInfoService).WomenCheckArcInfo(CommunityCode, DateOfStart, DateOfEnd)            
        s reportData.WomenAfterCheckArcNum = ##class(CHSSWeb.CommunityHSInfoService).WomenAfterCheckArcInfo(CommunityCode, DateOfStart, DateOfEnd)       
        s reportData.ElderArcNum = ##class(CHSSWeb.CommunityHSInfoService).ElderArcInfo(CommunityCode, DateOfStart, DateOfEnd)                 
        s reportData.ElderCheckArcNum = ##class(CHSSWeb.CommunityHSInfoService).ElderCheckArcInfo(CommunityCode, DateOfStart, DateOfEnd)            
        s reportData.ElderBloodSurgeLimosisArcNum = ##class(CHSSWeb.CommunityHSInfoService).ElderBloodSurgeLimosisArcInfo(CommunityCode, DateOfStart, DateOfEnd)
        s reportData.ElderCheckCountNum = ##class(CHSSWeb.CommunityHSInfoService).ElderCheckCountInfo(CommunityCode, DateOfStart, DateOfEnd)          
        s reportData.TrainingCountNum = ##class(CHSSWeb.CommunityHSInfoService).TrainingCountInfo(CommunityCode, DateOfStart, DateOfEnd)            
        s reportData.SchizoArcNum = ##class(CHSSWeb.CommunityHSInfoService).SchizoArcInfo(CommunityCode, DateOfStart, DateOfEnd)                
        s reportData.SchizoRecoverArcNum = ##class(CHSSWeb.CommunityHSInfoService).SchizoRecoverArcInfo(CommunityCode, DateOfStart, DateOfEnd)         
        s reportData.SchizoManageArcNum = ##class(CHSSWeb.CommunityHSInfoService).SchizoManageArcInfo(CommunityCode, DateOfStart, DateOfEnd)          
       
        s reportData.HealthBroad = ##class(CHSSWeb.ReportFourStaService).getHealthBroad(CommunityCode, DateOfStart, DateOfEnd)           
        s reportData.HealthEducationLecture = ##class(CHSSWeb.ReportFourStaService).getHealthEducationLecture(CommunityCode, DateOfStart, DateOfEnd)
        s reportData.ChildImmuCardNum = ##class(CHSSWeb.ReportFourStaService).getChildImmuCardNum(CommunityCode, DateOfStart, DateOfEnd)      
        s reportData.ImmunityBacterinRecord = ##class(CHSSWeb.ReportFourStaService).getImmunityBacterinRecord(CommunityCode, DateOfStart, DateOfEnd)
        s reportData.ChildBaseInfo = ##class(CHSSWeb.ReportFourStaService).getChildBaseInfo(CommunityCode, DateOfStart, DateOfEnd)         
        s reportData.ChildFirstCheckNum = ##class(CHSSWeb.ReportFourStaService).getChildFirstCheckNum(CommunityCode, DateOfStart, DateOfEnd)    
        s reportData.ChildCheckRecordNum = ##class(CHSSWeb.ReportFourStaService).getChildCheckRecordNum(CommunityCode, DateOfStart, DateOfEnd)   
        
        s reportData.HBPCheckNum = ##class(CHSSWeb.ReportFourStaService).getHBPCheckNum(CommunityCode, DateOfStart, DateOfEnd)           
        s reportData.HbpCheckManageNum = ##class(CHSSWeb.ReportFourStaService).getHbpCheckManageNum(CommunityCode, DateOfStart, DateOfEnd)     
        s reportData.DiabteNum = ##class(CHSSWeb.ReportFourStaService).getDiabteNum(CommunityCode, DateOfStart, DateOfEnd)             
        s reportData.DiabteManageNum = ##class(CHSSWeb.ReportFourStaService).getDiabteManageNum(CommunityCode, DateOfStart, DateOfEnd)       
        s reportData.OtherChornicNum = ##class(CHSSWeb.ReportFourStaService).getOtherChornicNum(CommunityCode, DateOfStart, DateOfEnd)       

	
		;第二种方法：手工拼写
	    Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.CommunityHSInfo")
 		s returnData = "<CommunityHSInfo>"
		 // get list of properties
		;Write "---Properties---",!
		Set count = cdef.Properties.Count()
		For i = 1:1:count d
    	.s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		s returnData = returnData_"</CommunityHSInfo>"
 		

		
		;如果返回的是LIST，则使用[Collection = list]方式返回列表
		;d reportReportData.PersonInfo.Insert(reportData)
		
		
		;如果是LIST，则返回reportReportData
		
		;if (reportData '= "")
		;{
			;Set status = reportData.XMLExport()
	    ;}    
	  	Quit returnData
}

Storage Default
{
<Data name="CommunityHSInfoInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.CommunityHSI97DD</DataLocation>
<DefaultData>CommunityHSInfoInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.CommunityHSI97DD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.CommunityHSI97DI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.CommunityHSI97DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
