/// 名称:优质病历字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-3-27
Class web.CDSS.CMKB.HighQualityEMR Extends %RegisteredObject
{

/// Creator：丁亚男	
/// CreatDate: 2023-3-27
/// Description：查询 
/// Table:CT.WDT.CDSS.HighQualityEMR优质病历字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.HighQualityEMR","GetList","","","","肺炎","","","","1","","")
Query GetList(rowid As %String, desc As %String = "", VisType As %String, MainDiagName As %String, OtherDiagName As %String, Dept As %String, SSex As %String, AgeMin As %String, AgeMax As %String, Doctor As %String, Code As %String) As %Query(ROWSPEC = "RowId,EMRType,EMRContent,VisitType,Loc,Name,Sex,Age,Marriage,Birthplace,Nation,Profession,CurrentAddress,Expressionist,ReliableDegree,HospitalDate,RecordDate,DoctorName,BloodGroup,Birthday,PregStatus,GestWeek,Remarks,UseFlag,UpdateUser,UpdateDate,MDiagName,EMRCode")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String = "", VisType As %String, MainDiagName As %String, OtherDiagName As %String, Dept As %String, SSex As %String, AgeMin As %String, AgeMax As %String, Doctor As %String, Code As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
		s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
		s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
	    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
	    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
	    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
	    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8) 
	    
	    s Marriage= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),9)
	    s Birthplace= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),10) 	
	    s Nation= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),11)     
	    s Profession= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),12)        
	    s CurrentAddress= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),13) 
	    s Expressionist= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),14)
	    s ReliableDegree= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),15) 	
	    s HospitalDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),16)
	    s RecordDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),17) 
	    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18) 
	    
	    s BloodGroup= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),19)
	    s Birthday= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),20) 	
	    s PregStatus= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),21)
	    s GestWeek= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),22) 
	    s Remarks= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),23) 
	    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24) 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
	    s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
	    s MDiagName=""
	    if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
		{
			s ConDiaId=""
			for 
			{
				s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
				s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
				s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
				s:IsMainDiagnosis=1 MDiagName=DiagnosisName 
			}
		}
	        
		d OutputRow
	}
	else
	{
		s:VisType="" VisType="全部" //转换成大写
		s MainDiagName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(MainDiagName)
		s OtherDiagName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OtherDiagName)
		if (MainDiagName'="")&&($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",MainDiagName,1)))
		{
			s RowId=""
			for 
			{
				s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",MainDiagName,1,RowId)) q:RowId=""
				if ((OtherDiagName'="")&&($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",OtherDiagName,0,RowId))))||(OtherDiagName="")
				{
					s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
					s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
					s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
				    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
				    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
				    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
				    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
				    s Marriage= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),9)
				    s Birthplace= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),10) 	
				    s Nation= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),11)     
				    s Profession= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),12)        
				    s CurrentAddress= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),13) 
				    s Expressionist= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),14)
				    s ReliableDegree= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),15) 	
				    s HospitalDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),16) 
				    s RecordDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),17) 
				    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
				    s BloodGroup= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),19)
				    s Birthday= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),20) 	
				    s PregStatus= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),21)
				    s GestWeek= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),22) 
				    s Remarks= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),23)
				    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
				    s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
	    			s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
	    			s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
	    			
	     			s MDiagName=MainDiagName
		 			s OtherDiagStr=""
		    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
					{
						s ConDiaId=""
						for 
						{
							s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
							s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
							s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
							if (IsMainDiagnosis'=1) 
							{
								s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
								s:OtherDiagStr="" OtherDiagStr=DiagnosisName
							}
						}
					}
				
				    if ((VisType="全部")||(VisType=VisitType))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((OtherDiagName="")||((OtherDiagName'="")&(OtherDiagStr[OtherDiagName)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))&&((Code="")||((Code'="")&(EMRCode[Code)))
				    {
					  d OutputRow  
					}
				}
			    
			}
		}
		elseif (OtherDiagName'="")&&($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",OtherDiagName,0)))
		{
			s RowId=""
			for 
			{
				s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",OtherDiagName,0,RowId)) q:RowId=""
				s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
				s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
				s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
			    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
			    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
			    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
			    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
			    s Marriage= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),9)
			    s Birthplace= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),10) 	
			    s Nation= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),11)     
			    s Profession= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),12)        
			    s CurrentAddress= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),13) 
			    s Expressionist= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),14)
			    s ReliableDegree= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),15) 	
			    s HospitalDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),16) 
			    s RecordDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),17) 
			    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
			    s BloodGroup= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),19)
			    s Birthday= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),20) 	
			    s PregStatus= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),21)
			    s GestWeek= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),22) 
			    s Remarks= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),23)
			    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
				s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
	    		s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
	    		
	    		s MDiagName="",OtherDiagStr=""
	    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
				{
					s ConDiaId=""
					for 
					{
						s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
						s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
						s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
						s:IsMainDiagnosis=1 MDiagName=DiagnosisName
						if (IsMainDiagnosis'=1) 
						{
							s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
							s:OtherDiagStr="" OtherDiagStr=DiagnosisName
						}
					}
				}
	     
			    if ((VisType="全部")||(VisType=VisitType))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((MainDiagName="")||((MainDiagName'="")&(MDiagName[MainDiagName)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))&&((Code="")||((Code'="")&(EMRCode[Code)))
			    {
				  d OutputRow  
				}
			}
		}
		else
		{
			s RowId=""
			for 
			{
				s RowId=$O(^CT.WDT.CDSS.HighQualityEMRD(RowId)) q:RowId=""
				s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
				s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
				s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
			    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
			    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
			    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
			    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
			    s Marriage= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),9)
			    s Birthplace= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),10) 	
			    s Nation= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),11)     
			    s Profession= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),12)        
			    s CurrentAddress= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),13) 
			    s Expressionist= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),14)
			    s ReliableDegree= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),15) 	
			    s HospitalDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),16)
			    s RecordDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),17) 
			    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
			    s BloodGroup= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),19)
			    s Birthday= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),20) 	
			    s PregStatus= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),21)
			    s GestWeek= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),22) 
			    s Remarks= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),23)
			    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
			    s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
	    		s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
	    		
	    		s MDiagName="",OtherDiagStr=""
	    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
				{
					s ConDiaId=""
					for 
					{
						s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
						s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
						s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
						s:IsMainDiagnosis=1 MDiagName=DiagnosisName
						if (IsMainDiagnosis'=1) 
						{
							s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
							s:OtherDiagStr="" OtherDiagStr=DiagnosisName
						}
					}
				}
					
			    if ((VisType="全部")||(VisType=VisitType))&&((MainDiagName="")||((MainDiagName'="")&(MDiagName[MainDiagName)))&&((OtherDiagName="")||((OtherDiagName'="")&(OtherDiagStr[OtherDiagName)))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))&&((Code="")||((Code'="")&(EMRCode[Code)))
			    {
				  d OutputRow  
				}
			}
		}
	}		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,EMRType,EMRContent,VisitType,Loc,Name,Sex,Age,Marriage,Birthplace,Nation,Profession,CurrentAddress,Expressionist,ReliableDegree,HospitalDate,RecordDate,DoctorName,BloodGroup,Birthday,PregStatus,GestWeek,Remarks,UseFlag,UpdateUser,UpdateDate,MDiagName,EMRCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2023-3-27
/// Description：打开单条的数据
/// Table:CT.WDT.CDSS.HighQualityEMR优质病历字典表
/// Input：id
/// Return:Json格式的字符串
/// Other: w ##class(web.CDSS.CMKB.HighQualityEMR).OpenData("9099")
ClassMethod OpenData(Id As %String) As %String
{
    s str="" 
    s obj=##class(CT.WDT.CDSS.HighQualityEMR).%OpenId(Id)
    s eobj=##class(web.CDSSEntity.CMKB.HighQualityEMR).%New()
    s eobj.RowId=Id
    s eobj.EMRType=obj.EMRType          
    s eobj.EMRContent=obj.EMRContent 
    s eobj.VisitType=obj.VisitType
    s eobj.Loc=obj.Loc
    s eobj.Name=obj.Name          
    s eobj.Sex=obj.Sex 
    s eobj.Age=obj.Age
    s eobj.Marriage=obj.Marriage
    s eobj.Birthplace=obj.Birthplace          
    s eobj.Nation=obj.Nation 
    s eobj.Profession=obj.Profession
    s eobj.CurrentAddress=obj.CurrentAddress
    s eobj.Expressionist=obj.Expressionist          
    s eobj.ReliableDegree=obj.ReliableDegree 
    s eobj.HospitalDate=obj.HospitalDate
    s eobj.RecordDate=obj.RecordDate
    s eobj.DoctorName=obj.DoctorName          
    s eobj.BloodGroup=obj.BloodGroup 
    s eobj.Birthday=obj.Birthday
    s eobj.PregStatus=obj.PregStatus 
    s eobj.GestWeek=obj.GestWeek
    s eobj.Remarks=obj.Remarks
    s eobj.UseFlag=obj.UseFlag
    s eobj.UpdateUser= obj.UpdateUser 	//编辑人员
    s eobj.UpdateDate= obj.UpdateDate     //编辑时间
    s eobj.EMRCode=obj.EMRCode
     
    s str = eobj.JsonS()    
    d obj.%Close()
    q str
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:保存优质病历字典表
/// Table: CT_WDT_CDSS.HighQualityEMR
/// Input: eobj 优质病历字典表实体对象
/// Return:
/// others:w ##class(web.CDSS.CMKB.HighQualityEMR).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.HighQualityEMR)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.HighQualityEMR).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.HighQualityEMR).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.HighQualityEMR).%New()
			s bobj.EMRType=obj.EMRType          
		    s bobj.EMRContent=obj.EMRContent 
		    s bobj.VisitType=obj.VisitType
		    s bobj.Loc=obj.Loc
		    s bobj.Name=obj.Name          
		    s bobj.Sex=obj.Sex 
		    s bobj.Age=obj.Age
		    s bobj.Marriage=obj.Marriage
		    s bobj.Birthplace=obj.Birthplace          
		    s bobj.Nation=obj.Nation 
		    s bobj.Profession=obj.Profession
		    s bobj.CurrentAddress=obj.CurrentAddress
		    s bobj.Expressionist=obj.Expressionist          
		    s bobj.ReliableDegree=obj.ReliableDegree 
		    s bobj.HospitalDate=obj.HospitalDate
		    s bobj.RecordDate=obj.RecordDate
		    s bobj.DoctorName=obj.DoctorName          
		    s bobj.BloodGroup=obj.BloodGroup 
		    s bobj.Birthday=obj.Birthday
		    s bobj.PregStatus=obj.PregStatus 
    		s bobj.GestWeek=obj.GestWeek
		    s bobj.Remarks=obj.Remarks
		    s bobj.UseFlag=obj.UseFlag
		    s bobj.UpdateUser= obj.UpdateUser 	//编辑人员
    		s bobj.UpdateDate= obj.UpdateDate     //编辑时间
    		s bobj.EMRCode=obj.EMRCode
			
		}
		
		s obj.EMRType=eobj.EMRType          
	    s obj.EMRContent=eobj.EMRContent 
	    s obj.VisitType=eobj.VisitType
	    s obj.Loc=eobj.Loc
	    s obj.Name=eobj.Name          
	    s obj.Sex=eobj.Sex 
	    s obj.Age=eobj.Age
	    s obj.Marriage=eobj.Marriage
	    s obj.Birthplace=eobj.Birthplace          
	    s obj.Nation=eobj.Nation 
	    s obj.Profession=eobj.Profession
	    s obj.CurrentAddress=eobj.CurrentAddress
	    s obj.Expressionist=eobj.Expressionist          
	    s obj.ReliableDegree=eobj.ReliableDegree 
	    s obj.HospitalDate=eobj.HospitalDate
	    s obj.RecordDate=eobj.RecordDate
	    s obj.DoctorName=eobj.DoctorName          
	    s obj.BloodGroup=eobj.BloodGroup 
	    s obj.Birthday=eobj.Birthday
	    s obj.PregStatus=eobj.PregStatus 
    	s obj.GestWeek=eobj.GestWeek
	    s obj.Remarks=eobj.Remarks
	    s obj.UseFlag=eobj.UseFlag
	    if (eobj.UpdateUser'="")
	    {
		    s obj.UpdateUser= eobj.UpdateUser 	//编辑人员
	    }
	    else
	    {
		    s obj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
	    }
	    
	    if (eobj.UpdateDate'="")
	    {
		    s obj.UpdateDate= eobj.UpdateDate     //编辑时间
	    }
	    else
	    {
		    s obj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    }
		s obj.EMRCode=eobj.EMRCode    
	    
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQualityEMR","CT.WDT.CDSS.HighQualityEMR","优质病历字典表",id,eobj.Name,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQualityEMR","CT.WDT.CDSS.HighQualityEMR","优质病历字典表",eobj.RowId,eobj.Name,"U",eobj,bobj)	
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历字典表","web.CDSS.CMKB.HighQualityEMR","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历字典表","web.CDSS.CMKB.HighQualityEMR","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.HighQualityEMR
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.HighQualityEMR).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""	
	Ts
	//删除优质病历关联诊断表
	s EMRConDiaRowId=0
	for
	{
		s EMRConDiaRowId = $o(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",id,EMRConDiaRowId)) q:EMRConDiaRowId=""
		s result=##class(web.CDSS.CMKB.HighQEMRConDia).DeleteData(EMRConDiaRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:优质病历关联诊断表删除失败'}"  //返回错误信息
		}
	}
	
	//删除优质病历关联诊断因子表
	s EMRConSymRowId=0
	for
	{
		s EMRConSymRowId = $o(^CT.WDT.CDSS.HighQEMRConSymI("EMRDRIndex",id,EMRConSymRowId)) q:EMRConSymRowId=""
		s result=##class(web.CDSS.CMKB.HighQEMRConSym).DeleteData(EMRConSymRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'优质病历关联诊断因子表删除失败'}"  //返回错误信息
		}
	}
	
	s obj=##class(CT.WDT.CDSS.HighQualityEMR).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.HighQualityEMR).%New() 
	s bobj.EMRType=obj.EMRType          
    s bobj.EMRContent=obj.EMRContent 
    s bobj.VisitType=obj.VisitType
    s bobj.Loc=obj.Loc
    s bobj.Name=obj.Name          
    s bobj.Sex=obj.Sex 
    s bobj.Age=obj.Age
    s bobj.Marriage=obj.Marriage
    s bobj.Birthplace=obj.Birthplace          
    s bobj.Nation=obj.Nation 
    s bobj.Profession=obj.Profession
    s bobj.CurrentAddress=obj.CurrentAddress
    s bobj.Expressionist=obj.Expressionist          
    s bobj.ReliableDegree=obj.ReliableDegree 
    s bobj.HospitalDate=obj.HospitalDate
    s bobj.RecordDate=obj.RecordDate
    s bobj.DoctorName=obj.DoctorName          
    s bobj.BloodGroup=obj.BloodGroup 
    s bobj.Birthday=obj.Birthday
    s bobj.PregStatus=obj.PregStatus 
    s bobj.GestWeek=obj.GestWeek
    s bobj.Remarks=obj.Remarks
    s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateUser= obj.UpdateUser 	//编辑人员
    s bobj.UpdateDate= obj.UpdateDate     //编辑时间
	s bobj.EMRCode=obj.EMRCode
		
	s sc=##class(CT.WDT.CDSS.HighQualityEMR).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQualityEMR","CT.WDT.CDSS.HighQualityEMR","优质病历字典表",id,bobj.Name,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历字典表","web.CDSS.CMKB.HighQualityEMR","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:丁亚男
/// CreatDate:2023-4-18
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.HighQualityEMR
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.BodyPartsDict).UpdateUseFlag("1","1")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.HighQualityEMR).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	
	s obj=##class(CT.WDT.CDSS.HighQualityEMR).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.HighQualityEMR).%New() 
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
		
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQualityEMR","CT.WDT.CDSS.HighQualityEMR","优质病历字典表",id,obj.Name_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2023-4-18
/// Description：批量通过
/// Table：CT.WDT.CDSS.HighQualityEMR
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).BatchConfirm()
ClassMethod BatchConfirm(idstr As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"通过")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2023-4-18
/// Description：批量驳回
/// Table：CT.WDT.CDSS.HighQualityEMR
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).BatchCancel()
ClassMethod BatchCancel(idstr As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"驳回")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2023-05-15
/// Description:根据检索信息，获取符合条件的相似高质量病历
/// Table: CT.WDT.CDSS.HighQualityEMR:优质病历字典表 CT_WDT_CDSS.HighQEMRConDia:优质病历关联诊断表  CT_WDT_CDSS.HighQEMRConSym:优质病历关联诊断因子表
/// Input: 
/// Return: 
/// Others:w ##class(web.CDSS.CMKB.HighQualityEMR).getSatisfyHQEMR("","住院","食管癌","","","","","","")
ClassMethod getSatisfyHQEMR(desc As %String = "", VisType As %String, MainDiagName As %String, OtherDiagName As %String, Dept As %String, SSex As %String, AgeMin As %String, AgeMax As %String, Doctor As %String) As %String
{
	s:VisType="" VisType="全部" //转换成大写
	s MainDiagName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(MainDiagName)
	s OtherDiagName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OtherDiagName)
	s EMRArray=[] //符合条件的病历数组
	if (MainDiagName'="")&&($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",MainDiagName,1)))
	{
		s RowId=""
		for 
		{
			s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",MainDiagName,1,RowId)) q:RowId=""
			s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
			s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
			s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
		    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
		    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
		    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
		    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
		    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
		    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
		    s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
			s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
			s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
			
 			s MDiagName=MainDiagName
 			s OtherDiagStr=""
    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
			{
				s ConDiaId=""
				for 
				{
					s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
					s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
					s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
					if (IsMainDiagnosis'=1) 
					{
						s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
						s:OtherDiagStr="" OtherDiagStr=DiagnosisName
					}
				}
			}
		
		    if ((VisType="全部")||(VisType=VisitType))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((OtherDiagName="")||((OtherDiagName'="")&(OtherDiagStr[OtherDiagName)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))
		    {
			  	s BaseInfo=Sex_"|"_Age_"|"_Loc_"|"_VisitType
				s lenContent=$length(EMRContent)
				if (lenContent>100)
				{
					s EMRContent=$E(EMRContent,1,100)_"..."
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",EMRContent)
				d TmpAss.%Set("ItemID",RowId)
				d TmpAss.%Set("MDiagName",MDiagName)
				d TmpAss.%Set("BaseInfo",BaseInfo)
				d EMRArray.%Push(TmpAss)
			  
			}
		}
	}
	elseif (OtherDiagName'="")&&($d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",OtherDiagName,0)))
	{
		s RowId=""
		for 
		{
			s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("DiagNameEMRDRIndex",OtherDiagName,0,RowId)) q:RowId=""
			s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
			s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
			s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
		    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
		    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
		    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
		    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
		    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
		    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
			s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
    		s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
    		s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
    		
    		s MDiagName="",OtherDiagStr=""
    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
			{
				s ConDiaId=""
				for 
				{
					s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
					s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
					s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
					s:IsMainDiagnosis=1 MDiagName=DiagnosisName
					if (IsMainDiagnosis'=1) 
					{
						s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
						s:OtherDiagStr="" OtherDiagStr=DiagnosisName
					}
				}
			}
     
		    if ((VisType="全部")||(VisType=VisitType))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((MainDiagName="")||((MainDiagName'="")&(MDiagName[MainDiagName)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))
		    {
			    s BaseInfo=Sex_"|"_Age_"|"_Loc_"|"_VisitType
				s lenContent=$length(EMRContent)
				if (lenContent>100)
				{
					s EMRContent=$E(EMRContent,1,100)_"..."
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",EMRContent)
				d TmpAss.%Set("ItemID",RowId)
				d TmpAss.%Set("MDiagName",MDiagName)
				d TmpAss.%Set("BaseInfo",BaseInfo)
				d EMRArray.%Push(TmpAss)
			}
		}
	}
	else
	{
		s RowId=""
		for 
		{
			s RowId=$O(^CT.WDT.CDSS.HighQualityEMRD(RowId)) q:RowId=""
			s EMRType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),2)      //病例类型
			s EMRContent= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),3)      //病历内容
			s VisitType= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),4)
		    s Loc= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),5) 	
		    s Name= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),6)     
		    s Sex= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),7)        
		    s Age= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),8)
		    s DoctorName= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),18)
		    s UseFlag= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),24)
		    s UpdateUser= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),25) 	//编辑人员
    		s UpdateDate= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),26)     //编辑时间
    		s EMRCode= $lg($g(^CT.WDT.CDSS.HighQualityEMRD(RowId)),27)
    		
    		s MDiagName="",OtherDiagStr=""
    		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId))
			{
				s ConDiaId=""
				for 
				{
					s ConDiaId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",RowId,ConDiaId)) q:ConDiaId="" 
					s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),4)
					s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(ConDiaId)),6)
					s:IsMainDiagnosis=1 MDiagName=DiagnosisName
					if (IsMainDiagnosis'=1) 
					{
						s:OtherDiagStr'="" OtherDiagStr=OtherDiagStr_"&%"_DiagnosisName
						s:OtherDiagStr="" OtherDiagStr=DiagnosisName
					}
				}
			}
				
		    if ((VisType="全部")||(VisType=VisitType))&&((MainDiagName="")||((MainDiagName'="")&(MDiagName[MainDiagName)))&&((OtherDiagName="")||((OtherDiagName'="")&(OtherDiagStr[OtherDiagName)))&&((desc="")||((desc'="")&(EMRContent[desc)))&&((Dept="")||((Dept'="")&(Dept=Loc)))&&((SSex="")||((SSex'="")&(SSex=Sex)))&&((AgeMin="")||((AgeMin'="")&(AgeMin<Age)))&&((AgeMax="")||((AgeMax'="")&(AgeMax>Age)))&&((Doctor="")||((Doctor'="")&(Doctor=DoctorName)))
		    {
			    s BaseInfo=Sex_"|"_Age_"|"_Loc_"|"_VisitType
				s lenContent=$length(EMRContent)
				if (lenContent>100)
				{
					s EMRContent=$E(EMRContent,1,100)_"..."
				}
				s TmpAss={}
				d TmpAss.%Set("ItemName",EMRContent)
				d TmpAss.%Set("ItemID",RowId)
				d TmpAss.%Set("MDiagName",MDiagName)
				d TmpAss.%Set("BaseInfo",BaseInfo)
				d EMRArray.%Push(TmpAss)
			}
		}
	}
	s EMRInfo=EMRArray.%ToJSON()
	q EMRInfo
}

}
