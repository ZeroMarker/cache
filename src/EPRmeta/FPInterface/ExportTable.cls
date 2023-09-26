Class EPRmeta.FPInterface.ExportTable Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter ExportToOSFiles = "F";

Parameter ExportToTable = "T";

Parameter SingleLineImport = "S";

Parameter MultiLineImport = "M";

Parameter ImportData = "I";

Parameter UpdataData = "U";

Parameter ErrMsgNotNull = "不能为空";

Parameter ErrMsgInt = "应为纯数字的组合";

Parameter ErrMsgNum = "应为数值型";

Parameter ErrMsgDate = "日期格式错误";

Parameter ErrMsgDateTime = "全日期格式错误";

Parameter ErrMsgTime = "时间格式错误";

Parameter ErrMsgHour = "时间的小时部分格式错误";

Parameter ErrMsgMinute = "时间的分钟部分格式错误";

Parameter ErrMsgFee = "费用不平";

Parameter MeddataNameSpace = "Meddata";

Parameter EPRNameSpace = "EPR";

/// if clear existed data in export table or not when generate new data
Property ClearData As %Boolean;

Property Columns As list Of ExpTableColumn;

Property ImpTableName As %String(TRUNCATE = 1);

/// single line or multi-line
Property ImpTableType As %String(TRUNCATE = 1);

/// insert or update
Property ImpType As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

/// OS files("F") or tables in Cache("T")
Property Type As %String(TRUNCATE = 1);

/// the unique id for the global that contains a patient's export data
Property DataGlobalUniqueId As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

Property IndexProperies As %String(TRUNCATE = 1);

Relationship TableColumns As EPRmeta.FPInterface.ExpTabColumnPersistent [ Cardinality = many, Inverse = ParentTable ];

Index IdxName On Name [ Unique ];

/// export data to a cache table
Method ExportToTable(parDynamicClassManager As DynamicClassManager, parAdmId As %String, parFlag As %String, parRowID As %String) As %Status
{
	q:($d(parDynamicClassManager)=0)||(parDynamicClassManager="") 0
	q:(($d(parAdmId)=0)||(parAdmId="")||($d(parFlag)=0)||(parFlag="")) 0
	s result=""
	
	merge parDynamicClassManager.DataGlobal(..DataGlobalUniqueId)=^CacheTempEPRResult(..DataGlobalUniqueId)
	if parFlag="2"  //新增
	{
		s result=parDynamicClassManager.InsertData(..DataGlobalUniqueId,parAdmId)
	}
	elseif parFlag="3"  //更新
	{
		s result=parDynamicClassManager.UpdateData(..DataGlobalUniqueId,parAdmId,parRowID)
	}
	
	q result
}

/// get the argAdmId's data defined by this export table
Method GetExportData(argAdmId As %String, argFPInterfacePath As %String, argExportMethodName As %String, argPatInfoAssistPath As %String, argASCIIColSeparator As %String, argASCIINameValueSeparator As %String) As %String
{
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s ..DataGlobalUniqueId=$ZOBJCLASSMETHOD(argFPInterfacePath_".DynamicClassManager","GetUniqueId")
	k ^CacheTempEPRResult(..DataGlobalUniqueId) ;(..DataGlobalUniqueId)
	
	s strEPRVersion=$ZOBJCLASSMETHOD(argFPInterfacePath_".DisPatient","GetEPRVersion")
	s hospital=$ZOBJCLASSMETHOD(argFPInterfacePath_".DisPatient","GetHospitalName",argFPInterfacePath,strEPRVersion)
	
	if hospital = "FuXing"
	{
		//记录未归类的收费项目,在Meddata的geticfee^DHCAdmFeeNew记录此信息--复兴
		d $zu(5, ..#MeddataNameSpace)
		k ^TempFeeErrMsg($j,argAdmId)
		s ^TempFeeErrMsg($j,"GetData")="1" ;开关，表示在geticfee^DHCAdmFeeNew中需要记录
		d $zu(5, ..#EPRNameSpace)
	}
	//end

	/// get patient's basic info
	s patientInfo=""
	s strEPRVersion=$ZOBJCLASSMETHOD(argFPInterfacePath_".DisPatient","GetEPRVersion")
	if strEPRVersion=1 {
		if (argExportMethodName="")
		{
			s argExportMethodName = "DHC.EPR.PatientInfo:getPatientInfoNew"
		}
		
		for i=1:1:$l(argExportMethodName,"^")
		{
			s curExportMethodName = $p(argExportMethodName,"^",i)
			s tempPatientInfo=$ZOBJCLASSMETHOD($p(curExportMethodName,":",1),$p(curExportMethodName,":",2),argAdmId)
			s tempPatientInfo=$li(tempPatientInfo,1)
			s patientInfo = patientInfo_tempPatientInfo
		}
	}
	elseif strEPRVersion=2 {
		if (argExportMethodName="")
		{
			s argExportMethodName = "EPRservice.SystemData:GetPatientInfo"
		}
		
		for i=1:1:$l(argExportMethodName,"^")
		{		
		    s curExportMethodName = $p(argExportMethodName,"^",i)
			s tempPatientInfoDataSet=##class(%ResultSet).%New(curExportMethodName)
			S columnCount = tempPatientInfoDataSet.GetColumnCount()
			
			s sc = tempPatientInfoDataSet.Execute(argAdmId)
			//q:(+sc'=1) ""
			//
			//
			s tempPatientInfo = ""
			While (tempPatientInfoDataSet.Next()) 
			{
				 For colIndex = 1:1:columnCount 
				 {
					s tempPatientInfo = tempPatientInfo_$lb(tempPatientInfoDataSet.GetColumnName(colIndex)_$c(2)_tempPatientInfoDataSet.GetData(colIndex))
        		 }
			}
			
			s patientInfo = patientInfo_tempPatientInfo
		}
	}
	else {
		q ""
	}

	//根据不同版本取不同的字段内容数--080114
	s ColumnCount=0, result=""
	s dataVer = "2"
	if dataVer = "1"
	{
		s ColumnCount=..Columns.Count()
	}
	else
	{
		s ColumnCount=..TableColumns.Count()
	}
	q:(ColumnCount=0) ""

	for i=1:1:ColumnCount {
		s aColumn="",aColumnString="",aDataValue="",aGetCode=""
		
		//根据不同版本取不同的字段内容--080114
		if dataVer = "1"
		{
			s aColumn=..Columns.GetAt(i)
		}
		else
		{
			s aColumn=..TableColumns.GetAt(i)	
		}
		q:(aColumn="")
		
		s aColumnString=aColumn.Code
		s data=""
		if (aColumnString'="") {
			s aGetCode=aColumn.IsGetCode
			;w aColumnString,!
			if aColumn.IsSystemData="1" {
				//if strEPRVersion=1 {
					for j=1:1:$ll(patientInfo) {
						s PIItem=$li(patientInfo,j)
						if ($p(PIItem,$c(2),1)=aColumnString) {
							s data=$p(PIItem,$c(2),2)
							quit
						}
					}
				//}
				//elseif strEPRVersion=2 {
				//	s data=patientInfo.Get(aColumnString)
				//}
				//else {
				//	s data=""
				//}
			}
			else {
				s data=$ZOBJMETHOD(##this,"GetItemDataValueV"_strEPRVersion,argAdmId,aColumnString,aGetCode) ;,argFPInterfacePath)
			}
		}
		
		if ($d(data)=0) {s data=""}
		if ..Type=..#ExportToTable {
			s convertedData=..ConvertData(aColumn,data,argFPInterfacePath,strEPRVersion)
			s checkedConvertedData=..CheckConvertedData(aColumn,convertedData,argFPInterfacePath,strEPRVersion)
			
			if +($f(checkedConvertedData,"#>"))>0
			{
				s ^CacheTempEPRResult(..DataGlobalUniqueId,argAdmId,aColumn.Name)=convertedData
				s ^CacheTempEPRResult(..DataGlobalUniqueId,argAdmId,"IsExpSuc")="N"
			}
			elseif (aColumn.Name'="IsExpSuc")
			{
				s ^CacheTempEPRResult(..DataGlobalUniqueId,argAdmId,aColumn.Name)=checkedConvertedData
			}
			
			
			if +($f(checkedConvertedData,"#>"))>0{
				s colNameStr = aColumn.Description_"!"_aColumn.Name
			}
			else
			{
				s colNameStr = aColumn.Name
			}
			
			if result=""{
				s result=colNameStr_$c(argASCIINameValueSeparator)_aColumn.DataType_$c(argASCIINameValueSeparator)_checkedConvertedData
		    }
			else{
				s result=result_$c(argASCIIColSeparator)_colNameStr_$c(argASCIINameValueSeparator)_aColumn.DataType_$c(argASCIINameValueSeparator)_checkedConvertedData	
			}
		}
		elseif ..Type=..#ExportToOSFiles {
			if result="" {
				s convertedData=..ConvertData(aColumn,data,argFPInterfacePath,strEPRVersion)
			    s checkedConvertedData=..CheckConvertedData(aColumn,convertedData,argFPInterfacePath,strEPRVersion)
				if +($f(checkedConvertedData,"#>"))>0{
					s colNameStr = aColumn.Description_"!"_aColumn.Name
				}
				else
				{
					s colNameStr = aColumn.Name
				}
				
				s result=colNameStr_$c(argASCIINameValueSeparator)_aColumn.DataType_$c(argASCIINameValueSeparator)_checkedConvertedData
			}
			else {
				s convertedData=..ConvertData(aColumn,data,argFPInterfacePath,strEPRVersion)
			    s checkedConvertedData=..CheckConvertedData(aColumn,convertedData,argFPInterfacePath,strEPRVersion)
				if +($f(checkedConvertedData,"#>"))>0{
					s colNameStr = aColumn.Description_"!"_aColumn.Name
				}
				else
				{
					s colNameStr = aColumn.Name
				}
				
				s result=result_$c(argASCIIColSeparator)_colNameStr_$c(argASCIINameValueSeparator)_aColumn.DataType_$c(argASCIINameValueSeparator)_checkedConvertedData
			}
		}
	}
	
	if (hospital = "FuXing") ||( hospital = "AnZhen")
	{
		//判断费用是否正确--复兴
		if strEPRVersion=1 
		{
			s checkfy="0"
			for j=1:1:$ll(patientInfo) 
			{
				s PIItem=$li(patientInfo,j)
				if ($p(PIItem,$c(2),1)="checkfy") 
				{
			 	 s checkfy=$p(PIItem,$c(2),2)
			 	 quit
				}
		 	}
		    
		 	if checkfy'="1"
		 	{
				s checkedConvertedData = "<#"_..#ErrMsgFee_" "_..GetTempFeeErrMsg(argAdmId)_"#>"
				if result="" 
				{
				  s result="zfy"_$c(argASCIINameValueSeparator)_""_$c(argASCIINameValueSeparator)_checkedConvertedData
				}
				else 
				{
				  s result=result_$c(argASCIIColSeparator)_"zfy"_$c(argASCIINameValueSeparator)_""_$c(argASCIINameValueSeparator)_checkedConvertedData
				}
			}
	 	}
	 
	 	//清空未归类的收费项目,在Meddata的geticfee^DHCAdmFeeNew记录此信息--复兴
	 	d $zu(5, ..#MeddataNameSpace)
	 	k ^TempFeeErrMsg($j,argAdmId)
	 	k ^TempFeeErrMsg($j,"GetData")
	 	d $zu(5, ..#EPRNameSpace)
	 	//end
	}
	q result
}

/*convert data if needed. for example, convert description to code such as bloodtype, or
  convert one description to another, such as department.
  argument: argDataFlag--a flag used to determine which rules should be used to convert data.
            argData--data to be converted.
  return value: data be converted*/
Method ConvertData(argColumn As ExpTableColumn, argData As %String, argFPInterfacePath As %String, argEPRVersion As %String) As %String
{
	q:($d(argData)=0)||(argData="") ""
	q:($d(argColumn)=0)||(argColumn="") argData

	s result=argData
	s convertFlags=argColumn.ConvertFlag
	
	for i=1:1:$l(convertFlags,"|") {
		s convertFlag=$p(convertFlags,"|",i)
		s convertParam=$p(argColumn.ConvertParam,"|",i)
		;convert department
		if $zcvt(convertFlag,"U")="DEPT" {
			s hospital=$ZOBJCLASSMETHOD(argFPInterfacePath_".DisPatient","GetHospitalName",argFPInterfacePath,argEPRVersion)
			s result=$ZOBJMETHOD(##this,"ConvertDept",result,hospital)
		}
		;convert JianHuShi DateTime to date, hour or minute
		if $zcvt(convertFlag,"U")="SPLITDT" {
			s result=..ConvertDateTime(result)
			s result=..SplitDateTime(result,convertParam)
		}
		
		;convert data to YYYY/MM/DD HH:MI:SS
		if $zcvt(convertFlag,"U")="DATETIME" {
			s result=..ConvertDateTime(result)
		}
		
		;convert date from YYYY-MM-DD to YYYY/MM/DD
		if $zcvt(convertFlag,"U")="DATE" {
			s result=..ConvertDate(result)
		}
		;convert data from 无 to ""
		if $zcvt(convertFlag,"U")="NULL" {
			s result=..ConvertNull(result)
		}
		;convert ICD to "01"
		if $zcvt(convertFlag,"U")="ICD" {
			s result=ConvertICD(result)
		}
		;convert itemdata to limited length of Tongren
		if $zcvt(convertFlag,"U")="LENGTH" {
			w result_"^"_argColumn.Length ,!
			s result=..CheckCharLength(result,argColumn.Length)
		}
		;convert description to code according to column description in export definition in MaintainApp
		;if $zcvt(convertFlag,"U")="CODE" {
		;	s tmpcode="",tmpCmd=""
		;	s tmpCmd="tmpcode=$case("""_result_""","_convertParam_")"
		;	s @tmpCmd
		;	s result=@"tmpcode"
		;	}
	    ;convert description to code according to column description in export definition in MaintainApp
	    ;format of convertParam: description1:code1,description:code2
	    if $zcvt(convertFlag,"U")="CODE" {
			for j=1:1:$l(convertParam,",") {
				s conParam = $p(convertParam,",",j)
			    s conParOrig=$p(conParam,":",1)
			    s conParDest=$p(conParam,":",2)
			   
			    if (conParOrig '= "")&&(conParDest '= "") {				
					s tmpCode=$case(result,conParOrig:conParDest,:result)	
					s result=tmpCode
				}
				elseif (conParOrig '= "")&&(conParDest = ""){
				    s result=""
				}
			}
		}
	     
	}
	
	q result
}

/*convert dept name to TongRen's dept name*/

/*
Method ConvertDeptFuXing(parDept As %String) As %String
{
	if $f(parDept,"耳鼻喉科")>0 {q "耳鼻喉科"}
	if $f(parDept,"心内科12(2)")>0 {q "干部二层"}
	if $f(parDept,"心内科12(1)")>0 {q "干部一层"}
	if $f(parDept,"感染科")>0 {q "感染科"}
	if $f(parDept,"高血压科")>0 {q "高血压"}
	if $f(parDept,"骨科")>0 {q "骨    科"}
	if $f(parDept,"呼吸内科")>0 {q "呼吸内科"}
	if $f(parDept,"激光整形科")>0 {q "激光整形科"}
	if $f(parDept,"泌尿外科")>0 {q "泌 尿 科"}
	if $f(parDept,"皮肤性病科")>0 {q "皮    科"}
	if $f(parDept,"普内科")>0 {q "普 内 科"}
	if $f(parDept,"普外科")>0 {q "普 外 科"}
	if $f(parDept,"抢救中心(15)2")>0 {q "抢救15(2)"}
	if $f(parDept,"EICU")>0 {q "抢救监护"}
	if $f(parDept,"神经内科")>0 {q "神经内科"}
	if $f(parDept,"神经外科")>0 {q "神经外科"}
	if $f(parDept,"PICU")>0 {q "小儿心脏科"}
	if $f(parDept,"心内科1")>0 {q "心 内 一"}
	if $f(parDept,"心内科2")>0 {q "心 内 二"}
	if $f(parDept,"心内科3")>0 {q "心 内 三"}
	if $f(parDept,"心外科3")>0 {q "心 外 三"}
	if $f(parDept,"心外科5")>0 {q "心 外 五"}
	if $f(parDept,"心外科6")>0 {q "心 外 六"}
	if $f(parDept,"心外科7")>0 {q "心 外 七"}
	if $f(parDept,"心外科9")>0 {q "心 外 九"}
	if $f(parDept,"心外科10")>0 {q "心 外 十"}
	if $f(parDept,"心内科21")>0 {q "心电生理"}
	if $f(parDept,"CCU")>0 {q "心内CCU"}
	if $f(parDept,"心外科6")>0 {q "心外六"}
	if $f(parDept,"心外科7")>0 {q "心外七"}
	if $f(parDept,"心外科11")>0 {q "心外十一"}
	if $f(parDept,"胸外科")>0 {q "胸 外 科"}
	if $f(parDept,"血管科")>0 {q "血 管 科"}
	if $f(parDept,"眼科")>0 {q "眼    科"}
	if $f(parDept,"中医理疗科")>0 {q "中 医 科"}
	if $f(parDept,"综合科")>0 {q "综合科"}
	if $f(parDept,"妇产科")>0 {q "妇产科"}
	if $f(parDept,"抢救中心(15)")>0 {q "抢救十五"}
	q parDept
}
*/

/*convert dept name to TongRen's dept name*/
Method ConvertDept(parDept As %String, parHospital As %String) As %String
{
	q:($d(parDept)=0)||(parDept="") ""
	q:($d(parHospital)=0)||(parHospital="") parDept
	
	if (parHospital="FuXing")||(parHospital="HeFei") { 
		if $f(parDept,"耳鼻喉科")>0 {q "耳鼻喉科"}
		if $f(parDept,"心内科12(2)")>0 {q "干部二层"}
		if $f(parDept,"心内科12(1)")>0 {q "干部一层"}
		if $f(parDept,"感染科")>0 {q "感染科"}
		if $f(parDept,"高血压科")>0 {q "高血压"}
		if $f(parDept,"骨科")>0 {q "骨    科"}
		if $f(parDept,"呼吸内科")>0 {q "呼吸内科"}
		if $f(parDept,"激光整形科")>0 {q "激光整形科"}
		if $f(parDept,"泌尿外科")>0 {q "泌 尿 科"}
		if $f(parDept,"皮肤性病科")>0 {q "皮    科"}
		if $f(parDept,"普内科")>0 {q "普 内 科"}
		if $f(parDept,"普外科")>0 {q "普 外 科"}
		if $f(parDept,"抢救中心(15)2")>0 {q "抢救15(2)"}
		if $f(parDept,"EICU")>0 {q "抢救监护"}
		if $f(parDept,"神经内科")>0 {q "神经内科"}
		if $f(parDept,"神经外科")>0 {q "神经外科"}
		if $f(parDept,"PICU")>0 {q "小儿心脏科"}
		if $f(parDept,"心内科1")>0 {q "心 内 一"}
		if $f(parDept,"心内科2")>0 {q "心 内 二"}
		if $f(parDept,"心内科3")>0 {q "心 内 三"}
		if $f(parDept,"心外科3")>0 {q "心 外 三"}
		if $f(parDept,"心外科5")>0 {q "心 外 五"}
		if $f(parDept,"心外科6")>0 {q "心 外 六"}
		if $f(parDept,"心外科7")>0 {q "心 外 七"}
		if $f(parDept,"心外科9")>0 {q "心 外 九"}
		if $f(parDept,"心外科10")>0 {q "心 外 十"}
		if $f(parDept,"心内科21")>0 {q "心电生理"}
		if $f(parDept,"CCU")>0 {q "心内CCU"}
		if $f(parDept,"心外科6")>0 {q "心外六"}
		if $f(parDept,"心外科7")>0 {q "心外七"}
		if $f(parDept,"心外科11")>0 {q "心外十一"}
		if $f(parDept,"胸外科")>0 {q "胸 外 科"}
		if $f(parDept,"血管科")>0 {q "血 管 科"}
		if $f(parDept,"眼科")>0 {q "眼    科"}
		if $f(parDept,"中医理疗科")>0 {q "中 医 科"}
		if $f(parDept,"综合科")>0 {q "综合科"}
		if $f(parDept,"妇产科")>0 {q "妇产科"}
		if $f(parDept,"抢救中心(15)")>0 {q "抢救十五"}
	}
	q parDept
}

/* convert yyyy-mm-dd hh:mm to yyyy-mm-dd for JHDATE, hh for JHHOUR, mm for JHMINUTE */
Method SplitDateTime(argDateTime As %String, argType As %String) As %String
{
	q:($zcvt(argType,"U")="DATE") ..ConvertDate($P(argDateTime, " ", 1))
	q:($zcvt(argType,"U")="TIME") ..ConvertTime($P(argDateTime, " ", 2))
	q:($zcvt(argType,"U")="HOUR") $P(..ConvertTime($P(argDateTime, " ", 2)),":",1)
	q:($zcvt(argType,"U")="MINUTE") $P(..ConvertTime($P(argDateTime, " ", 2)), ":", 2)
}

Method ConvertDateTime(argDateTime As %String) As %String
{
	q:($d(argDateTime)=0)||(argDateTime="") ""
	s argDateTime=$tr(argDateTime,",","/")
	s argDateTime=$tr(argDateTime,".","/")
	s argDateTime=$tr(argDateTime," ","/")
	s argDateTime=$tr(argDateTime,"  ","/")
	s argDateTime=$tr(argDateTime,"、","/")
	s argDateTime=$tr(argDateTime,"年","/")
	s argDateTime=$tr(argDateTime,"月","/")
	s argDateTime=$tr(argDateTime,"日","")
	s argDateTime=$tr(argDateTime,"-","/")
	s argDateTime=$tr(argDateTime,"－","/")
	s argDateTime=$tr(argDateTime,"－","/")
	s argDateTime=$tr(argDateTime,"，","/")
	s argDateTime=$tr(argDateTime,"。","/")
	s argDateTime=$tr(argDateTime,"时","/")
	s argDateTime=$tr(argDateTime,"分","/")
	s argDateTime=$tr(argDateTime,"秒","")
	s argDateTime=$tr(argDateTime,"：","/")
	s argDateTime=$tr(argDateTime,":","/")
	s argDateTimeLen=$l(argDateTime)
	
	if $extract(argDateTime,argDateTimeLen,argDateTimeLen)?1"/" {
		s argDateTime=$extract(argDateTime,1,argDateTimeLen-1)
	}
	
	s pConvertDate="",pConvertTime="",tempStr=""
	s index = 0

	for i=1:1:$l(argDateTime,"/")
	{
		s tempStr = $p(argDateTime,"/",i)
		if (tempStr="")
		{
			continue
		}
		
		s index = index + 1
	    if (index<4)
		{
		  s pConvertDate = pConvertDate_"/"_tempStr 
		}
		elseif (index<7)
		{
		  s pConvertTime =pConvertTime_":"_tempStr
		}
		else
		{
			q
		}
	}
	
	s pConvertDate = $e(pConvertDate,2,$l(pConvertDate))
	s pConvertTime = $e(pConvertTime,2,$l(pConvertTime))
	s pConvertDate = ..ConvertDate(pConvertDate)
	s pConvertTime = ..ConvertTime(pConvertTime)
	if (pConvertTime'="")
	{
		s convertStr = pConvertDate_" "_pConvertTime
	}
	else
	{
		s convertStr = pConvertDate
	}
	q convertStr
}

/* convert date from YYYY-MM-DD to YYYY/MM/DD of SQLServer format */
Method ConvertDate(argDate As %String) As %String
{
	q:($d(argDate)=0)||(argDate="") ""
	q:($e(argDate,1,4)="1840") ""
	q:(argDate?4N1"/"2N1"/"2N) argDate
	s argDate=$tr(argDate,",","/")
	s argDate=$tr(argDate,".","/")
	s argDate=$tr(argDate," ","/")
	s argDate=$tr(argDate,"、","/")
	s argDate=$tr(argDate,"年","/")
	s argDate=$tr(argDate,"月","/")
	s argDate=$tr(argDate,"日","")
	s argDate=$tr(argDate,"-","/")
	s argDate=$tr(argDate,"－","/")
	s argDate=$tr(argDate,"－","/")
	s argDate=$tr(argDate,"，","/")
	s argDate=$tr(argDate,"。","/")
	s argDateLen=$l(argDate)
	;if '$isvalidnum($e(argDate,argDateLen,argDateLen)) {
	;	s argDate=$e(argDate,1,argDateLen-1)
	;}
	if $extract(argDate,argDateLen,argDateLen)?1"/" {
		s argDate=$extract(argDate,1,argDateLen-1)
	}
	q:(argDate?4N1"/"2N1"/"2N) argDate

	s convertStr = $p(argDate,"/",1)
	for j=2:1:3
	{
		set tempStr = $p(argDate,"/",j)
		if $l(tempStr)=1
		{
			s tempStr = "0"_tempStr
		}
		s convertStr = convertStr_"/"_tempStr		
	}
	q convertStr
}

Method ConvertTime(argTime As %String) As %String
{
	q:($d(argTime)=0)||(argTime="") ""
	q:(argTime?2N1":"2N1":"2N) argTime
	s argTime=$tr(argTime,"-",":")
	s argTime=$tr(argTime,"－",":")
	s argTime=$tr(argTime,"_",":")
	s argTime=$tr(argTime,"/",":")
	s argTime=$tr(argTime," ",":")
	s argTime=$tr(argTime,"时",":")
	s argTime=$tr(argTime,"分",":")
	s argTime=$tr(argTime,"秒","")
	s argTime=$tr(argTime,"：",":")
	s argTime=$tr(argTime,"，",":")
	s argTimeLen=$l(argTime)
	;if '$isvalidnum($e(argDate,argDateLen,argDateLen)) {
	;	s argDate=$e(argDate,1,argDateLen-1)
	;}
	if $extract(argTime,argTimeLen-1,argTimeLen-1)?1":" {
		s argTime=$extract(argTime,1,argTimeLen-1)
	}
	
	q:(argTime?2N1":"2N1":"2N) argTime

	s convertStr = ""
	for j=1:1:3
	{
		if j>$l(argTime,":")
		{
			s tempStr = "00"	
		}
		else
		{
			set tempStr = $p(argTime,":",j)
			if $l(tempStr)=1
			{
				s tempStr = "0"_tempStr
			}
		}
		s convertStr = convertStr_":"_tempStr		
	}
	s convertStr=$extract(convertStr,2,$l(convertStr))
	q convertStr
}

/* convert date from YYYY-MM-DD to YYYY/MM/DD of SQLServer format */
Method ConvertNull(argNull As %String) As %String
{
	q:($d(argNull)=0)||(argNull="")||(argNull="无")||(argNull="不详")||((argNull="-")) ""
	q argNull
}

/* convert any ICD Code to "01" to fill a meaningless data
 NOT USING*/
Method ConvertICD(argICD As %String) As %String
{
	q "01"
}

/// w ##class(EPRmeta.FPInterface.ExportTable).CheckCharLength("00070965",10)
/// w ##class(DHC.EPR.FPInterface.ExportTable).CheckCharLength("00070965",10)
Method CheckCharLength(argChar As %String, argLength As %Integer) As %String
{
	q:($d(argChar)=0)||($d(argLength)=0)||(argChar="")||(argLength="") ""

	/// get the length of argChar in GB character set, that is, a GB character's length is 2
	s charLength=$l($zcvt(argChar,"O","GB"))
	s length=$l(argChar)
	q:(charLength'>argLength) argChar
	;Comment By Wangwt 2008-07-11
	q:(length<4) ""
	;q:(length<4) $e(argChar,1,argLength)
	
	if argLength<=4
	{
		s getLength = argLength - 1
		s endString = "."	
	}
	else
	{
		s getLength = argLength - 4
		s endString = "...."	
	}
	
	if charLength - length > argLength - 4
	{
		q $e(argChar,1,getLength/2)_endString
	}
	else
	{
		q $e(argChar,1,getLength -(charLength - length))_endString
	}
	q argChar
}

/// for EPR2
Method GetItemDataValueV2(argAdmId As %String, argCode As %String, argIsGetCode As %Boolean, argFPInterfacePath As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="")||($d(argCode)=0)||(argCode="")||($d(argIsGetCode)=0)||(argIsGetCode="") ""
	q:($l(argCode,"#")'=6)&&($l(argCode,"#")'=5) ""
	
	s tmpList=""
	
	///parse 
	s TypeSection=$p(argCode,"#",2)
	q:($l(TypeSection,":")<2) ""
	s aType=$p(TypeSection,":",2)

	if aType="Simple" 
	{
		s TIDSection=$p(argCode,"#",3)
		q:($l(TypeSection,":")<2)
		s aTID=$p(TIDSection,":",2)
		
		s SCODESection=$p(argCode,"#",5)
		q:($l(SCODESection,":")<2)
		s aSCODE=$p(SCODESection,":",2)
		
		;q ##class(EPRservice.Query.BODataQueryService).SelectEPRItemSimple(argAdmId,aTID,aSCODE,argIsGetCode)
		q $ZOBJMETHOD(##this,"SelectEPRItemSimple",argAdmId,aTID,aSCODE,argIsGetCode)
	}
	if aType="Segment"
	{
		s TIDSection=$p(argCode,"#",3)
		q:($l(TypeSection,":")<2)
		s aTID=$p(TIDSection,":",2)
		
		s GCODESection=$p(argCode,"#",5)
		q:($l(GCODESection,":")<2)
		s aGCODE=$p(GCODESection,":",2)
		
		q:(($d(aTID)=0)||(aTID="")||(aGCODE="")||($d(aGCODE)=0)) ""

		;q ##class(EPRservice.Query.BODataQueryService).SelectEPRItemSegment(argAdmId,aTID,aGCODE)
		;q $ZOBJMETHOD(argFPInterfacePath_".ExportTable","SelectEPRItemSegment",argAdmId,aTID,aGCODE)
		q $ZOBJMETHOD(##this,"SelectEPRItemSegment",argAdmId,aTID,aGCODE)
	}
}

/// FOR EPR2
Method SelectEPRItemSegment(argEpisodeId As %String, argTemplateId As %String, argSegmentCode As %String) As %String [ Private ]
{
	q:($d(argEpisodeId)=0||(argEpisodeId="")||$d(argTemplateId)=0||argTemplateId=""||$d(argSegmentCode)=0||(argSegmentCode="")) ""
	s TextStreamId="",aText=""
	&sql(select Text into :TextStreamId from EPRinstance.ISegment
			where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SegmentCode=:argSegmentCode)
	q:(TextStreamId="") ""
	Set TextStream=##class(%CharacterStream).%Open(TextStreamId)
	q:(TextStream="") ""
	d TextStream.Rewind()
	s aText=TextStream.Read(1000)
	s TextStream=""
	q aText
}

/// FOR EPR2
Method SelectEPRItemSimple(argEpisodeId As %String, argTemplateId As %String, argSimpleItemCode As %String, argGetCode As %Boolean) As %String [ Private ]
{
	s aDataValue=""
	if (argGetCode=1)
	{
		&sql(select ValueCode into :aDataValue from EPRinstance.ISimple 
			where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SimpleItemCode=:argSimpleItemCode)
		q aDataValue
	}
	&sql(select DataValue into :aDataValue from EPRinstance.ISimple 
			where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SimpleItemCode=:argSimpleItemCode)
	q aDataValue
}

/// FOR EPR1
/// enhanced by gjb 2007-8-16
/// add the function that can get simple item's data or code in a multiple item
/// the format of parameter code: 
/// first, get multiple item's code, #{23||3-G-151-edt183|D-T}
/// second, remove "|D" from GUITemplatePos, #{23||3-G-151-edt183-T}
/// finally, add sequence number of the simple item you want to get, #{23||3-G-151-edt183-T-1}
Method GetItemDataValueV1(admid As %String, code As %String, argIsGetCode As %String) As %String
{
	q:($d(admid)=0)||(admid="")||($d(code)=0)||(code="")||($d(argIsGetCode)=0)||(argIsGetCode="") ""
	set code = $EXTRACT(code,3,$LENGTH(code)-1)
	set strResult = "",curScatterItem=""
	set PID = ""
	
	//&SQL( select id into:PID from DHC_EPR.PatientInfo where pinfoadmid=:admid)
	
	if PID = "" {
		
		quit strResult		
	}
	
	set PID = " " _ PID	
			
	set categoryId = " " _ $piece(code ,"-",1)
    if $piece(code ,"-",2) = "D" { ; 数据模板
    	
      set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, " ", " -1",""))
      if MDItemId '= "" {      
        set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
        set strResult = curMDItem.ItemData       
      }        
    } ; end 数据模板
    else { ; GUI 模板
      set guiId = " " _ $piece(code ,"-",3)       
      set ctrlName = $piece(code ,"-",4)        
      set valueType = $piece(code ,"-",5)        
      set guiPos = " "_$ZCONVERT($piece(ctrlName,"|",1),"U")        
      set ctrllen = $length(ctrlName,"|")
      if (ctrllen = 3) { ; 表格单元
        set baseItemId = " "_$piece(ctrlName,"|",2)
        set rowNo = " "_$piece(ctrlName,"|",3)
        set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId,rowNo,""))
               
        if SItemId '= "" {      
          set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          if 'argIsGetCode { ; 取文本            
      		set strResult = curScatterItem.BaseItemValue 
          }           
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
      	  }   
        }          
      }
      elseif (ctrllen = 2) { ;复合单元或数据模板
        set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, guiId, guiPos,""))
        if MDItemId '= "" {     
          set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
          set strResult = curMDItem.ItemData      
        }          
      }
      else { ; 其他基本单元     
        s SItemId = ""
      	s multiItemPos=""
      	s multiItemPos=$piece(code ,"-",6) //get simple itme sequence number. if it has data, do the following
      	if multiItemPos="" {
	      	//check every simple item in a GUITemplatePos, if a simple item's MultiItemPos equals the sequence number then exit
	        set baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,""))
	        if baseItemId '= "" {        
	          set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
	        }
	        else {
	          set SItemId = ""
	        } 
    
      	}
      	else {
	      	// get simple item
	      	s baseItemId=""
	      	for {
		      	s baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,baseItemId))
		      	q:(baseItemId="")
		      	set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
		      	if SItemId '= "" {      
          		set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          		q:(curScatterItem.MultiItemPos=multiItemPos)}
	      	}
      	}

      	// get simple item data
      	if SItemId '= "" {      
          if curScatterItem="" {set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)}
          if 'argIsGetCode { ; 取文本      
            set strResult = curScatterItem.BaseItemValue          
          }         
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
          }
        }      
      }      
      
    } ; end GUI模板
    quit strResult
}

/// 取打散的数据，代码跟 GetItemDataValueV1 一样，只是是 ClassMethod
ClassMethod GetItemDataValueV1Another(admid As %String, code As %String, argIsGetCode As %String) As %String
{
	q:($d(admid)=0)||(admid="")||($d(code)=0)||(code="")||($d(argIsGetCode)=0)||(argIsGetCode="") ""
	set code = $EXTRACT(code,3,$LENGTH(code)-1)
	set strResult = "",curScatterItem=""
	set PID = ""
	
	//&SQL( select id into:PID from DHC_EPR.PatientInfo where pinfoadmid=:admid)
	
	if PID = "" {
		
		quit strResult		
	}
	
	set PID = " " _ PID	
			
	set categoryId = " " _ $piece(code ,"-",1)
    ;b
    if $piece(code ,"-",2) = "D" { ; 数据模板
    	
      set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, " ", " -1",""))
      if MDItemId '= "" {      
        set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
        set strResult = curMDItem.ItemData       
      }        
    } ; end 数据模板
    else { ; GUI 模板
      set guiId = " " _ $piece(code ,"-",3)       
      set ctrlName = $piece(code ,"-",4)        
      set valueType = $piece(code ,"-",5)        
      set guiPos = " "_$ZCONVERT($piece(ctrlName,"|",1),"U")        
      set ctrllen = $length(ctrlName,"|")
      if (ctrllen = 3) { ; 表格单元
        set baseItemId = " "_$piece(ctrlName,"|",2)
        set rowNo = " "_$piece(ctrlName,"|",3)
        set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId,rowNo,""))
               
        if SItemId '= "" {      
          set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          if 'argIsGetCode { ; 取文本            
      		set strResult = curScatterItem.BaseItemValue 
          }           
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
      	  }          
        }          
      }
      elseif (ctrllen = 2) { ;复合单元或数据模板
        ;w PID,!
      	;w categoryId,!
      	;w guiId,!
      	;w guiPos,!
        set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, guiId, guiPos,""))
        if MDItemId '= "" {     
          set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
          set strResult = curMDItem.ItemData      
        }          
      }
      else { ; 其他基本单元     
        s SItemId = ""
      	s multiItemPos=""
      	s multiItemPos=$piece(code ,"-",6) //get simple itme sequence number. if it has data, do the following
      	if multiItemPos="" {
	      	//check every simple item in a GUITemplatePos, if a simple item's MultiItemPos equals the sequence number then exit
	        set baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,""))
	        if baseItemId '= "" {        
	          set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
	        }
	        else {
	          set SItemId = ""
	        } 
    
      	}
      	else {
	      	// get simple item
	      	s baseItemId=""
	      	for {
		      	s baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,baseItemId))
		      	q:(baseItemId="")
		      	set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
		      	if SItemId '= "" {      
          		set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          		q:(curScatterItem.MultiItemPos=multiItemPos)}
	      	}
      	}

      	// get simple item data
      	if SItemId '= "" {      
          if curScatterItem="" {set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)}
          ;w argIsGetCode,!
          if 'argIsGetCode { ; 取文本      
            set strResult = curScatterItem.BaseItemValue          
          }         
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
          }          
        }      
      }      
      
    } ; end GUI模板
    quit strResult
}

ClassMethod GetItemDataValueV2ForStat(admid As %String, code As %String, argIsGetCode As %String) As %String
{
	q:($d(admid)=0)||(admid="")||($d(code)=0)||(code="")||($d(argIsGetCode)=0)||(argIsGetCode="") ""
	set FPInterface=""   //此参数在GetItemDataValueV2中已无用，在参数表中占位
	set result=""
	
	set objExportTable = ##class(EPRmeta.FPInterface.ExportTable).%New()
	set result = objExportTable.GetItemDataValueV2(admid,code,argIsGetCode,FPInterface)
	
	quit result
}

ClassMethod GetItemDataValueV1ForStat(admid As %String, code As %String, argIsGetCode As %String) As %String
{
	q:($d(admid)=0)||(admid="")||($d(code)=0)||(code="")||($d(argIsGetCode)=0)||(argIsGetCode="") ""
	;w argIsGetCode,!
	set code = $EXTRACT(code,3,$LENGTH(code)-1)
	set strResult = "",curScatterItem=""
	set PID = ""
	
	//&SQL( select id into:PID from DHC_EPR.PatientInfo where pinfoadmid=:admid)
	
	if PID = "" {
		
		quit strResult		
	}
	
	set PID = " " _ PID	
		
	set categoryId = " " _ $piece(code ,"-",1)
    ;b
    if $piece(code ,"-",2) = "D" { ; 数据模板
    	
      set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, " ", " -1",""))
      if MDItemId '= "" {      
        set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
        set strResult = curMDItem.ItemData       
      }        
    } ; end 数据模板
    else { ; GUI 模板
      set guiId = " " _ $piece(code ,"-",3)       
      set ctrlName = $piece(code ,"-",4)        
      set valueType = $piece(code ,"-",5)        
      set guiPos = " "_$ZCONVERT($piece(ctrlName,"|",1),"U")        
      set ctrllen = $length(ctrlName,"|")
      if (ctrllen = 3) { ; 表格单元
        set baseItemId = " "_$piece(ctrlName,"|",2)
        set rowNo = " "_$piece(ctrlName,"|",3)
        set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId,rowNo,""))
      
        if SItemId '= "" {      
          set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          if 'argIsGetCode { ; 取文本            
      		set strResult = curScatterItem.BaseItemValue 
          }           
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
      	  }          
        }          
      }
      elseif (ctrllen = 2) { ;复合单元或数据模板
        ;w PID,!
      	;w categoryId,!
      	;w guiId,!
      	;w guiPos,!
        set MDItemId = $order(^DHC.EPR.MDItemI("PidMDitem", PID, categoryId, guiId, guiPos,""))
        if MDItemId '= "" {     
          set curMDItem = ##class(DHC.EPR.MDItem).%OpenId(MDItemId)
          set strResult = curMDItem.ItemData      
        }          
      }
      else { ; 其他基本单元
        s SItemId = ""
      	s multiItemPos=""
      	s multiItemPos=$piece(code ,"-",6) //get simple itme sequence number. if it has data, do the following
      	if multiItemPos="" {
	      	//check every simple item in a GUITemplatePos, if a simple item's MultiItemPos equals the sequence number then exit
	        set baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,""))
	        if baseItemId '= "" {        
	          set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
	        }
	        else {
	          set SItemId = ""
	        }        
      	}
      	else {
	      	// get simple item
	      	s baseItemId=""
	      	for {
		      	s baseItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos,baseItemId))
		      	q:(baseItemId="")
		      	set SItemId = $order(^DHC.EPR.ScatterItemI("PIdBItem", PID, categoryId, guiId, guiPos, baseItemId," ",""))
		      	if SItemId '= "" {      
          		set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)
          		q:(curScatterItem.MultiItemPos=multiItemPos)}
	      	}
      	}
      	// get simple item data
      	if SItemId '= "" {      
          if curScatterItem="" {set curScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(SItemId)}
          ;w argIsGetCode,!
          if 'argIsGetCode { ; 取文本      
            set strResult = curScatterItem.BaseItemValue          
          }         
          else { ; 取 DictionaryCode
            set strResult = curScatterItem.DictionaryCode
          }          
        }      
      }      
      
    } ; end GUI模板
    quit strResult
}

/// w ##class(DHC.EPR.FPInterface.ExportTable).PatientRecordInfoForStat("364615","epr","epr")
/// 一些病案首页的信息
/// 请在使用该方法前确认 模板和项目 正确
ClassMethod PatientRecordInfoForStat(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s result=""
	
	s EPRVersion="1"
	if EPRVersion="1" {s FPIPackage="DHC.EPR.FPInterface"}
	if EPRVersion="2" {s FPIPackage="EPRmeta.FPInterface"}
	///$ZOBJCLASSMETHOD(FPIPackage_"ExportTable","GetItemDataValueV1",argAdmId
	
	
	///主诊断描述，主诊断代码，主诊断出院情况
	s mainDiagDesc= "", mainDiagCode="", mainDiagOut=""
	s mainDiagDesc = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||2-G-266-dbx264-T}","0")
    s mainDiagCode = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||2-G-266-dbx196-T}","1")	
	s mainDiagOut = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||2-G-266-cbx178-T}","0")
	
	///手术描述，手术代码
	s oper1Desc="", oper1Code=""
	s oper1Desc = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx333-T}",0)
    s oper1Code = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx341-T}",1)	
	s oper2Desc="", oper2Code=""
	s oper2Desc = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx335-T}",0)
    s oper2Code = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx343-T}",1)	
	s oper3Desc="", oper3Code=""
	s oper3Desc = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx337-T}",0)
    s oper3Code = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx345-T}",1)
	s oper4Desc="", oper4Code=""
	s oper4Desc = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx339-T}",0)
    s oper4Code = $ZOBJCLASSMETHOD(FPIPackage_".ExportTable","GetItemDataValueV1ForStat",argAdmId,"#{39||3-G-267-dbx347-T}",1)
	
	///do $zu(5, argCurrentNameSpace)
	
	s result = mainDiagDesc_"^"_mainDiagCode_"^"_mainDiagOut_"^"_oper1Desc_"^"_oper1Code_"^"_oper2Desc_"^"_oper2Code_"^"_oper3Desc_"^"_oper3Code_"^"_oper4Desc_"^"_oper4Code
	Quit result
}

/*
ClassMethod GetAllExpTables(argFPPackage As %String) As %ListOfObjects
{
	s ResultList=##class(%Library.ListOfObjects).%New()
	
	Set rs=##class(%ResultSet).%New()
	If rs.Prepare("select ID as EID from "_$tr(argFPPackage,".","_")_".ExportTable") {
		Set status=rs.Execute() // no ? parameter necessary
		If 'status Quit
		WHILE rs.Next() {
			;w rs.Data("EID")
			Set aExpTable=$ZOBJCLASSMETHOD(argFPPackage_".ExportTable","%OpenId",rs.Data("EID"))
			if (aExpTable'="") {d ResultList.Insert(aExpTable)}
		}
	}
	
	Do rs.Close()
	;b
	;w !!,"bbbbbb",!!
	;w ResultList.Insert(aExpTable)
	;w !!,"eeeeee",!!
	;w ResultList.Count()
	;w !!,"tttttt",!! 
	Quit ResultList
}
*/
ClassMethod GetAllExpTables(argFPPackage As %String) As EPRmeta.FPInterface.ExportTable
{
	s aExpTable=""
	Set rs=##class(%ResultSet).%New()
	If rs.Prepare("select ID As EID from "_$tr(argFPPackage,".","_")_".ExportTable") {
		Set status=rs.Execute() // no ? parameter necessary
		If 'status Quit
		WHILE rs.Next() {
			Set aExpTable=$ZOBJCLASSMETHOD(argFPPackage_".ExportTable","%OpenId",rs.Data("EID"))
			//Set aExpTable=##class(EPRmeta.FPInterface.ExportTable).%OpenId(rs.Data("EID"))
		}
	}
	
	Do rs.Close()
	Set aExpTable=##class(EPRmeta.FPInterface.ExportTable).%OpenId(1)
	Quit aExpTable
}

/// 校验转换后的导出数据是否合法
/// 可用的校验标志+参数有：NOTNULL, NUM, INT, DATE, 
/// SPLITDT + DATE, SPLITDT + TIME, SPLITDT + HOUR, SPLITDT + MININUTE 
Method CheckConvertedData(argColumn As ExpTableColumn, argData As %String, argFPInterfacePath As %String, argEPRVersion As %String) As %String
{
	q:$d(argData)=0 ""
	q:$d(argColumn)=0||argColumn="" argData
	
	s errorMsg=""
	s convertFlags=argColumn.ConvertFlag
	s convertParams=argColumn.ConvertParam
	
	for i=1:1:$l(convertFlags,"|") {
	
		s convertFlag=$p(convertFlags,"|",i)
		s convertParam=$p(convertParams,"|",i)
		
		;要求字段值非空
		if $zcvt(convertFlag,"U")="NOTNULL" {
    		if argData="" {s errorMsg=errorMsg_..#ErrMsgNotNull_"，"}
		}
		
		;若字段值为空，则退出此次循环
		continue:argData=""
		
		;要求字段内容为数值
		if $zcvt(convertFlag,"U")="NUM" {
			s IsMatch = "0"
			if $isvalidnum(argData)
			{
				s IsMatch = "1"
				}
			else
			{
				s IsMatch = "0"
				}
			if IsMatch="0" {s errorMsg = errorMsg_..#ErrMsgNum_"，"}
		}
		
		;要求字段内容为纯数字的组合
		if $zcvt(convertFlag,"U")="INT" {
			s IsMatch = argData?.N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgInt_"，"}
		}
			
        ;要求日期格式为 YYYY/MM/DD
		if $zcvt(convertFlag,"U")="DATE" {
			s IsMatch=argData?4N1"/"2N1"/"2N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgDate_"，"}
		}
		
		;要求日期格式为 YYYY/MM/DD HH:MM:SS
		if $zcvt(convertFlag,"U")="DATETIME" {
			s MatchCase1=argData?4N1"/"2N1"/"2N1" "2N1":"2N1":"2N
			s MatchCase2=argData?4N1"/"2N1"/"2N
			s IsMatch = MatchCase1||MatchCase2
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgDateTime_"，"}
		}
		;convert JianHuShi DateTime to date, hour or minute
		;convertFlag  convertParam  formatOfResult
		;splitdt      date          YYYY/MM/DD
		;splitdt      time          hh:mm
		;splitdt      hour          hh
		;splitdt      minute        mm
		;要求解析出来的日期格式YYYY/MM/DD，时间的格式为hh:mm,小时的格式为hh,分钟的格式为mm		
		if ($zcvt(convertFlag,"U")="SPLITDT" && $zcvt(convertParam,"U")="DATE") {
			s IsMatch = argData?4N1"/"2N1"/"2N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgDate_"，"}
		}
		elseif ($zcvt(convertFlag,"U")="SPLITDT" && $zcvt(convertParam,"U")="TIME"){
			s IsMatch = argData?2N1":"2N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgTime_"，"}
		}
		elseif ($zcvt(convertFlag,"U")="SPLITDT" && $zcvt(convertParam,"U")="HOUR"){
			s IsMatch = argData?2N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgHour_"，"}
		}
		elseif ($zcvt(convertFlag,"U")="SPLITDT" && $zcvt(convertParam,"U")="MINUTE"){
			s IsMatch = argData?2N
			if 'IsMatch {s errorMsg = errorMsg_..#ErrMsgMinute_"，"}
		}
	}
	
	if ($f(argData,$c(10))>0) ! ($f(argData,$c(13)))>0
	{
		//s errorMsg=errorMsg_"内容存在换行,请将换行去掉,将内容写于一行"_"，"
		s argData = $tr(argData,$c(10)," ")
		s argData = $tr(argData,$c(13)," ")
	}
	if $f(argData,"'")>0 >0
	{
		s argData = $tr(argData,"'","‘")
	}
	
	
	///若字段值格式正确，返回其值；若错误，返回其值+错误信息
	if errorMsg = "" {
		s result = argData
	}
	else {
		s errorMsg = $extract(errorMsg,1,$length(errorMsg)-1) ;截去最后的"，"
		s errorMsg = "<#"_errorMsg_"#>"   ;错误信息的格式为：<#content1，content2#>
		s result=argData_errorMsg
	}
	q result
}

//获取未归类的收费项目,在Meddata的geticfee^DHCAdmFeeNew记录此信息--复兴

Method GetTempFeeErrMsg(argAdmId As %String) As %String
{
	d $zu(5, ..#MeddataNameSpace)
	s result=""
	s taritem=""
    f  s taritem=$o(^TempFeeErrMsg($j,argAdmId,taritem)) q:taritem=""  d
	.s result = result_$g(^TempFeeErrMsg($j,argAdmId,taritem))_","
	k ^TempFeeErrMsg($j,argAdmId)
	d $zu(5, ..#EPRNameSpace)
	
	if result'=""
	{
		s result = "以下项目未归类："_result
	}
	q result
}

ClassMethod SetDisDateType(parStr As %String) As %String
{
	s ^EPRDisDateType(0) = parStr
	q ""
}

ClassMethod MoveTab() As %String
{
	s sourceTabRowId=""
	s result="0"
	for {
		s sourceTabRowId = $order(^EPRservi.ExportTablesD(sourceTabRowId))
		q:(sourceTabRowId="")
		s objSourceTab=##class(EPRservice.Query.ExportTables).%OpenId(sourceTabRowId)
		q:(objSourceTab="")
		s objTagTab=##class(EPRmeta.FPInterface.ExportTable).%New()
		q:(objTagTab="")
		
		s objTagTab.ClearData=0
		s objTagTab.Description =objSourceTab.Description
		s objTagTab.Name =objSourceTab.TableName
		s objTagTab.Type ="T"
		
		for i=1:1:objSourceTab.Columns.Count()
		{
			s objSourceColumn=objSourceTab.Columns.GetAt(i)
			s objTagColumn=##class(EPRmeta.FPInterface.ExpTabColumnPersistent).%New()
			
			s objTagColumn.Code=objSourceColumn.ItemCode
			s objTagColumn.DataType="String" //objSourceColumn.DataType 
			s objTagColumn.Description=objSourceColumn.Description
			s objTagColumn.Length=objSourceColumn.Length
			s objTagColumn.Name=objSourceColumn.Name
			if objSourceColumn.GetCode="1"
			{
			  s objSourceColumn.GetCode = 1
			}
			else
			{
			  s objSourceColumn.GetCode = 0
			}
			s objTagColumn.IsGetCode=objSourceColumn.GetCode
			s objTagColumn.ConvertFlag="Length"
			s objTagColumn.ConvertParam=""
			s objTagColumn.IndexSquence=0
			s objTagColumn.IsSystemData=0
			
			d objTagTab.TableColumns.Insert(objTagColumn)
		}
		
		s result=objTagTab.%Save()
		q:(result'=1)
	}
	
	q result
}

/// ***************测试代码*************************************
ClassMethod TestInsertData() As %String
{
	
	k ^EPRservi.ExportTableD
	k ^EPRservi.ExportTableI
	
	s a=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s a.Code="一般情况.医疗付款方式#TYPE:Simple#TID:1#TVER:0#SCODE:O0013#VTYPE:V"
	s a.DataType="String"
	s a.Description=""
	s a.ImportColName=""
	s a.Length=1
	s a.Name="ylfkfs"
	s a.IsGetCode=0
	s a.ConvertFlag="CODE"
	s a.ConvertParam="""社会基本医疗保险"":1,""商业保险"":2,:6"
	s a.IsSystemData=0
	
	s b=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s b.Code="一般情况.出  生#TYPE:Simple#TID:1#TVER:0#SCODE:D0056#VTYPE:V"
	s b.DataType="String"
	s b.Description=""
	s b.ImportColName=""
	s b.Length=50
	s b.Name="csrq"
	s b.IsGetCode=0
	s b.ConvertFlag="date"
	s b.ConvertParam="date"
	s b.IsSystemData=0

	s c=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s c.Code="一般情况.入院日期#TYPE:Simple#TID:1#TVER:0#SCODE:D0052#VTYPE:V"
	s c.DataType="String"
	s c.Description=""
	s c.ImportColName=""
	s c.Length=50
	s c.Name="ryrq"
	s c.IsGetCode=0
	s c.ConvertFlag="SPLITDT"
	s c.ConvertParam="date"
	s c.IsSystemData=0

	s d=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s d.Code="一般情况.入院日期#TYPE:Simple#TID:1#TVER:0#SCODE:D0052#VTYPE:V"
	s d.DataType="String"
	s d.Description=""
	s d.ImportColName=""
	s d.Length=50
	s d.Name="rysj"
	s d.IsGetCode=0
	s d.ConvertFlag="SPLITDT"
	s d.ConvertParam="time"
	s d.IsSystemData=0

	s e=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s e.Code="一般情况.门(急)诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V"
	s e.DataType="String"
	s e.Description=""
	s e.ImportColName=""
	s e.Length=10
	s e.Name="mjzzd"
	s e.IsGetCode=0
	s e.ConvertFlag="LENGTH"
	s e.ConvertParam=""
	s e.IsSystemData=0
	
	s f=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s f.Code="一般情况.门(急)诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V"
	s f.DataType="String"
	s f.Description=""
	s f.ImportColName=""
	s f.Length=50
	s f.Name="mjzzdicd"
	s f.IsGetCode=1
	s f.ConvertFlag=""
	s f.ConvertParam=""
	s f.IsSystemData=0
	
	//TransDept
	s g=##class(EPRservice.FPInterface.ExpTableColumn).%New()
	s g.Code="TransDept"
	s g.DataType="String"
	s g.Description=""
	s g.ImportColName=""
	s g.Length=100
	s g.Name="zk"
	s g.IsGetCode=0
	s g.ConvertFlag=""
	s g.ConvertParam=""
	s g.IsSystemData=1
	
	s newExportTable=##class(EPRservice.FPInterface.ExportTable).%New()
	s newExportTable.ClearData=1
	s newExportTable.ImpTableName="test"
	s newExportTable.ImpTableType="S"
	s newExportTable.ImpType="I"
	s newExportTable.Name="test"
	s newExportTable.Type="T"
	
	d newExportTable.Columns.Insert(a)
	d newExportTable.Columns.Insert(b)
	d newExportTable.Columns.Insert(c)
	d newExportTable.Columns.Insert(d)
	d newExportTable.Columns.Insert(e)
	d newExportTable.Columns.Insert(f)
	d newExportTable.Columns.Insert(g)
	
	s status=newExportTable.%Save()
	q status
	
	s newExportTable=##class(EPRservice.FPInterface.ExportTable).%OpenId(1)
	s dc=##class(EPRservice.FPInterface.DynamicClassManager).%New()
	s dc.ClassName="EPRservice.FPInterface.exptable1"
	s dc.SQLOwner=""
	s result=dc.GenerateTable(newExportTable)
	
	q result
}

//w ##class(DHC.EPR.FPInterface.ExportTable).TestGetData("55548")

ClassMethod TestGetData(admid As %String) As %String
{
	s newExportTable=##class(DHC.EPR.FPInterface.ExportTable).%OpenId(1)
	s newExportTable.Type=..#ExportToOSFiles
	s newExportTable.DataGlobalUniqueId=##class(DHC.EPR.FPInterface.DynamicClassManager).GetUniqueId()
	s result=newExportTable.GetExportData(admid,"DHC.EPR.FPInterface","DHC.EPR.PatientInfo","|","^")
	q result
}

ClassMethod TestImpTable() As %String
{
	s newExportTable=##class(EPRservice.FPInterface.ExportTable).%OpenId(1)
	s newExportTable.DataGlobalUniqueId=##class(EPRservice.FPInterface.DynamicClassManager).GetUniqueId()
	s result=newExportTable.GetExportData(388568,2,"EPRservice.FPInterface")
	
	s dcm=##class(EPRservice.FPInterface.DynamicClassManager).%New()
	s dcm.ClassName="EPRservice.FPInterface.exptable1"
	s dcm.SQLOwner=""
	
	s status=newExportTable.ExportToTable(dcm,388568)
	
	q status
}

ClassMethod TestGenTable() As %String
{
	b
	s newExportTable=##class(DHC.EPR.FPInterface.ExportTable).%OpenId(4)
	
	s dc=##class(DHC.EPR.FPInterface.DynamicClassManager).%New()
	s dc.ClassName="DHC.EPR.FPInterface.ExportedTables.basy"
	s dc.SQLOwner=""
	s result=dc.GenerateTable(newExportTable)
	b
	q result
}

/// w ##class(DHC.EPR.FPInterface.ExportTable).TestExportToTable("364615")
ClassMethod TestExportToTable(argAdm) As %String
{
	
	s newExportTable=##class(DHC.EPR.FPInterface.ExportTable).%OpenId(1)
	s dc=##class(DHC.EPR.FPInterface.DynamicClassManager).%New()
	s dc.ClassName="DHC.EPR.FPInterface.ExportedTables.basy"
	s dc.SQLOwner=""
	;s result=dc.GenerateTable(newExportTable)
	;b "s"
    s patData = newExportTable.GetExportData(argAdm,"DHC.EPR.FPInterface","DHC.EPR",$a("|"),$a("^"))
    ;q newExportTable.ExportToTable(dc,"66")
    q
}

/// w ##class(DHC.EPR.FPInterface.ExportTable).TestExportToTable()
ClassMethod Test() As %String
{
	s tmpCode=""
    s convertParam="0"
    s conParOrig=$p(convertParam,":",1)
	s conParDest=$p(convertParam,":",2)
	s result="女"
	;s tmpCmd="s tmpCode=$CASE("""_result_""","""_conParOrig_""":"""_conParDest_""")"
    if (conParOrig'="") & (conParDest'=""){
    	s tmpCode=$case(result,conParOrig:conParDest)
    	s result=tmpCode
    }
	q result
}

ClassMethod checksfx() As %String
{
	d $zu(5,MeddataNameSpace)
    k ^tmpincate
	s ^tmpincate(1)=18_"^"_"诊察费"
	s ^tmpincate(2)=19_"^"_"一般检查费"
	s ^tmpincate(3)=20_"^"_"特殊治疗费"
	s ^tmpincate(4)=21_"^"_"一般治疗费"
	s ^tmpincate(5)=22_"^"_"接生费"
	s ^tmpincate(6)=24_"^"_"麻醉费"
	s ^tmpincate(7)=25_"^"_"手术费"
	s ^tmpincate(8)=26_"^"_"护理治疗费"
	s ^tmpincate(9)=27_"^"_"护理费"
	s ^tmpincate(10)=28_"^"_"核素费"
	s ^tmpincate(11)=29_"^"_"超声费"
	s ^tmpincate(12)=30_"^"_"放射费"
	s ^tmpincate(13)=31_"^"_"化验费"
    s ^tmpincate(14)=32_"^"_"病理费"
    s ^tmpincate(15)=33_"^"_"呼吸机费"
    s ^tmpincate(16)=34_"^"_"监护仪费"
    s ^tmpincate(17)=35_"^"_"调温费"
    s ^tmpincate(18)=37_"^"_"床位费"
    s ^tmpincate(19)=38_"^"_"陪床费"
    s ^tmpincate(20)=39_"^"_"婴儿费"
    s ^tmpincate(21)=40_"^"_"输氧费"
    s ^tmpincate(22)=41_"^"_"输血费"
    s ^tmpincate(23)=42_"^"_"西药费"
    s ^tmpincate(24)=45_"^"_"中成药费"
    s ^tmpincate(25)=46_"^"_"中草药费"
    s ^tmpincate(26)=47_"^"_"治疗用一次性医用材料费"
    s ^tmpincate(27)=48_"^"_"手术用一次性医用材料费"
    s ^tmpincate(28)=49_"^"_"检查用一次性医用材料费"
    s ^tmpincate(29)=50_"^"_"放射用一次性医用材料费"
    s ^tmpincate(30)=51_"^"_"其它费"
    s result=0
    s ordsub=""
    f  s ordsub=$o(^DHCTARI(ordsub)) q:ordsub=""  d
    .s inpatcateDR=$p($g(^DHCTARI(ordsub)),"^",6)
    .q:inpatcateDR=""
    .s lostFlag="1"
    .f i=1:1:$g(^tmpincate) d
    ..i ($p(inpatcateDR,$c(1))=$p($p(^tmpincate(i),"^",1),$c(1))) d
    ...s lostFlag="0"
    ...w "ss",!
    .i lostFlag="1" d
    ..s result = +result + 1
    ..w $p($g(^DHCTARI(ordsub)),"^",2),! 
    ..i +result>100 d
    ...b ""
    ...s result=0
    d $zu(5,EPRNameSpace)
}

Storage Default
{
<Data name="ExportTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClearData</Value>
</Value>
<Value name="3">
<Value>Columns</Value>
</Value>
<Value name="4">
<Value>DataGlobalUniqueId</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>ImpTableName</Value>
</Value>
<Value name="7">
<Value>ImpTableType</Value>
</Value>
<Value name="8">
<Value>ImpType</Value>
</Value>
<Value name="9">
<Value>IndexProperies</Value>
</Value>
<Value name="10">
<Value>Name</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.FPInter6E3.ExportTableD</DataLocation>
<DefaultData>ExportTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.FPInter6E3.ExportTableD</IdLocation>
<IndexLocation>^EPRmeta.FPInter6E3.ExportTableI</IndexLocation>
<StreamLocation>^EPRmeta.FPInter6E3.ExportTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
