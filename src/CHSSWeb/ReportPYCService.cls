Class CHSSWeb.ReportPYCService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ReportListOld(CommunityCode As %String, CheckType As %String, BeginDate As %Date, EndDate As %Date) As %String
{
	  //社区卫生服务站	  社区卫生服务中心 县（区）卫生局 市卫生局 村卫生所 乡镇卫生院
		 
		set BeginDate = $zdh(BeginDate,3)
		set EndDate = $zdh(EndDate,3)
		;set Communitytype=""
		set CommunityName=""
		set FamilyCount=0
		set PersonCount=0
	 	set PYCDistinctCount=0
		set PYCcount=0
		Set json = ##class(Code.JsonObj).%New()
	    
	    Set result = ##class(%Library.ResultSet).%New() 
	    Set resultString=""
	    s hospitalId=""
	    s hospitalRowId=""
	    f  s hospitalId=$O(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode,hospitalId))  q:hospitalId=""  d
	    .s hospitalRowId=hospitalId
	    
	 	set tmpHospital =##class(CHSS.DictHospital).%OpenId(hospitalRowId)
	    set Communitytype = tmpHospital.CommunityType
	     set CommunityName = tmpHospital.CommunityName
	 
		;如果是 社区卫生服务站、社区卫生服务中心、村卫生所 则查看自己所录数据
	 
		;总家庭档案数
	     ;w StrCode
		 s rowid=0
	     f  s rowid=$o(^CHSS.FamilyHealthRecordI("CommunityCodeIndex"," "_CommunityCode,rowid)) q:rowid=""    d  
	     .s FamilyCount=FamilyCount+1
 	
		s markpersonrowid=""
		i CheckType="CheckDate" {
	    s personrowid=0
	    f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_CommunityCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
          .s checkrowid=0
	    .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.DateCheck
 
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	
	     }else{
		  s personrowid=0
	      f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_CommunityCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
          .s checkrowid=0
	    .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.FillDate
 
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	     
	     }
		
		 
		Set tmp=CommunityName_"^"_FamilyCount_"^"_PersonCount_"^"_PYCDistinctCount_"^"_PYCcount		
		d json.InsertRowData(tmp)
		Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCDistinctCount^PYCcount",1)
	 
	 	k json	 	
		Quit resultString
}

ClassMethod ReportAllListOld(SectionId As %Integer, CheckType As %String, BeginDate As %String, EndDate As %String) As %String
{
    set BeginDate = $zdh(BeginDate,3)
	set EndDate = $zdh(EndDate,3)	
	Set count=0
	Set resultString = ""	
    set FamilyCountZ="0"
	set PersonCountZ="0"
	set PYCDistinctCountZ="0"
    set PYCcountZ="0"
 
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""    
  
    s resultall = ##class(%Library.ResultSet).%New()        
    
    s sqlStr = "select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_" and street.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s sqlStr = sqlStr_" union select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictVillage village, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_"  and street.rowid = village.RowIdParref and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
 
	d resultall.Prepare(sqlStr)
	d resultall.Execute()
	
   	s markpersonrowid=""
	While(resultall.Next())
	{
		s StrCode=resultall.Data("CommunityCode")
		s CommunityName=resultall.Data("CommunityName")
		set FamilyCount="0" 
	    set PersonCount="0"
        set PYCDistinctCount="0"
	    set PYCcount="0"
 
		  ;总家庭档案数
	     ;w StrCode
		 s rowid=0
	     f  s rowid=$o(^CHSS.FamilyHealthRecordI("CommunityCodeIndex"," "_StrCode,rowid)) q:rowid=""    d  
	     .s FamilyCount=FamilyCount+1
	     ;w FamilyCount_"     "
	     ;总个人档案数 
	     ;总体检人数 总体检人次
	     i CheckType="CheckDate" {
	    s personrowid=0
	    f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_StrCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
          .s checkrowid=0
	    .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.DateCheck
 
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	
	     }else{
		  s personrowid=0
	      f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_StrCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
          .s checkrowid=0
	    .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.FillDate
 
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	     
	  }
		
		 
		 
		Set tmp=CommunityName_"^"_FamilyCount_"^"_PersonCount_"^"_PYCDistinctCount_"^"_PYCcount		
		 
 	
	     Set count=count+1
        set FamilyCountZ=FamilyCountZ+FamilyCount
		set PersonCountZ=PersonCountZ+PersonCount
	 	set PYCDistinctCountZ=PYCDistinctCountZ+PYCDistinctCount
		set PYCcountZ=PYCcountZ+PYCcount
       d json.InsertRowData(tmp)    	
    }
    Set tmp="<b><font color=red>总计</font></b>"_"^"_FamilyCountZ_"^"_PersonCountZ_"^"_PYCDistinctCountZ_"^"_PYCcountZ
    d json.InsertRowData(tmp)	
    d resultall.Close()
    
         
    Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCDistinctCount^PYCcount",count+1)
    k json
      
    Quit resultString
}

ClassMethod List(id, level, start, limit)
{
    
    s sqlStr=""
    s Leaf="false"
    
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set end = start+limit
	s result = ##class(%Library.ResultSet).%New()
	i (id="0") d
	.s sqlStr = "select RowId, '1'||RowId As nodeid, Description from CHSS.DictProvince"
	.s level = "province"
	e  d
	.if level = "province" d
	..s sqlStr = "select RowId, '2'||RowId As nodeid, Description from CHSS.DictCity where rowidparref ="_id
	..s level = "city"
	.e  i level = "city" d
	..s sqlStr = "select RowId, '3'||RowId As nodeid, Description from CHSS.DictSection where rowidparref ="_id
	..s level = ""
	..s Leaf = "true"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("RowId")
	    s nodeid = result.Data("nodeid")
		s text=result.Data("Description")
				
	    s tmp=nodeid_"^"_text_"^"_Leaf_"^"_level_"^"_rowid
	    d json.InsertRowData(tmp)
	    s count=count+1
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text^leaf^level^rowid")
	k json
	q resultString
}

ClassMethod ReportAllListCityOld(SectionId As %Integer, CheckType As %String, BeginDate As %String, EndDate As %String) As %String
{
    set BeginDate = $zdh(BeginDate,3)
	set EndDate = $zdh(EndDate,3)
	Set count=0
	Set resultString = ""	
	;w BeginDate_"=="_EndDate 	
    set FamilyCountZ="0"
	set PersonCountZ="0"
	set PYCDistinctCountZ="0"
    set PYCcountZ="0"
    set StrCode=""
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""     
  	Set resultall = ##class(%Library.ResultSet).%New() 
     s sqlStr = "select RowId , Description from CHSS.DictSection where rowidparref ="_SectionId
	;w sqlStr
	d resultall.Prepare(sqlStr)
	d resultall.Execute()
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s markpersonrowid=""
	While(resultall.Next())
	{
		s rowid = resultall.Data("RowId")
		s text = resultall.Data("Description")			 
		set FamilyCount="0" 
     	set PersonCount="0" 
        set PYCDistinctCount="0"
	    set PYCcount="0"
		s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowIdParref = "_rowid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
        s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowIdParref="_rowid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
        
        ;w CommunityCodesqlStr
        Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
        d resultCommunityCode.Prepare(CommunityCodesqlStr)
	    d resultCommunityCode.Execute()
		While(resultCommunityCode.Next())
		{ 
		  set StrCode = resultCommunityCode.Get("code")	
		  ;总家庭档案数
	     ;w StrCode
		 s rowid=0
	     f  s rowid=$o(^CHSS.FamilyHealthRecordI("CommunityCodeIndex"," "_StrCode,rowid)) q:rowid=""    d  
	     .s FamilyCount=FamilyCount+1
	     ;w FamilyCount_"     "
	     ;总个人档案数 
	     ;总体检人数 总体检人次
	    i CheckType="CheckDate"  {
	    s personrowid=0
	    f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_StrCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
          .s checkrowid=0
	    .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid 
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.DateCheck 
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	
	    } else {
		  s personrowid=0
	     f  s personrowid=$o(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_StrCode,personrowid)) q:personrowid=""    d 
         .s PersonCount=PersonCount+1
         .s checkrowid=0
	     .f  s checkrowid=$o(^CHSS.PersonYearCheckRecordI("PersonRowIdkIndex",personrowid,checkrowid)) q:checkrowid=""    d  
	     ..;w checkrowid
	     ..set tmpRowRecord=##class(CHSS.PersonYearCheckRecord).%OpenId(checkrowid)
	     ..set Mark=tmpRowRecord.Mark 
	     ..i Mark="NOTNULL" d
	     ...set chcekdate=tmpRowRecord.FillDate  
	     ...i (chcekdate>=BeginDate)&&(chcekdate<=EndDate) d
	     .... set PYCcount = PYCcount+1   //体检人次
	     ....i personrowid'=markpersonrowid d
	     .....s PYCDistinctCount=PYCDistinctCount+1
	     .....s markpersonrowid=personrowid  //体检人数	 
		  }
		 d resultCommunityCode.Close()
	}
		Set tmp=text_"^"_FamilyCount_"^"_PersonCount_"^"_PYCDistinctCount_"^"_PYCcount		
	     Set count=count+1
        set FamilyCountZ=FamilyCountZ+FamilyCount
		set PersonCountZ=PersonCountZ+PersonCount
	 	set PYCDistinctCountZ=PYCDistinctCountZ+PYCDistinctCount
		set PYCcountZ=PYCcountZ+PYCcount
       d json.InsertRowData(tmp)  
	}
    Set tmp="<b><font color=red>总计</font></b>"_"^"_FamilyCountZ_"^"_PersonCountZ_"^"_PYCDistinctCountZ_"^"_PYCcountZ
    d json.InsertRowData(tmp)	
    d resultall.Close()
    
         
      Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCcount^PYFcount",count+1)
    k json
      
    Quit resultString
}

ClassMethod ReportList(CommunityCode As %String, CheckType As %String, BeginDate As %Date, EndDate As %Date) As %String
{
	  //社区卫生服务站	  社区卫生服务中心 县（区）卫生局 市卫生局 村卫生所 乡镇卫生院
		 
		set BeginDate = $zdh(BeginDate,3)
		set EndDate = $zdh(EndDate,3)
		set CommunityName=""
		set FamilyCount=0
		set PersonCount=0
		set PYCcount=0
		set PYFcount=0
		Set json = ##class(Code.JsonObj).%New()
	    
	    Set result = ##class(%Library.ResultSet).%New() 
	    Set resultString=""
	    s hospitalId=""
	    s hospitalRowId=""
	    f  s hospitalId=$O(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode,hospitalId))  q:hospitalId=""  d
	    .s hospitalRowId=hospitalId
	    
	 	set tmpHospital =##class(CHSS.DictHospital).%OpenId(hospitalRowId)
	    set Communitytype = tmpHospital.CommunityType
	     set CommunityName = tmpHospital.CommunityName
	 
		;如果是 社区卫生服务站、社区卫生服务中心、村卫生所 则查看自己所录数据
	 
		;总家庭个人档案数
	     ;w StrCode
        s FPCount=..GetFPCount(CommunityCode)
        s FamilyCount=$P(FPCount,"^",1)
        s PersonCount=$P(FPCount,"^",2)
        ;体检日期 录入日期 数
        s PYCCount=..GetPYCCount(CommunityCode,BeginDate, EndDate )
        s PYCcount=$P(PYCCount,"^",1)
        s PYFcount=$P(PYCCount,"^",2)
 	    
 	  
		 
		Set tmp=CommunityName_"^"_FamilyCount_"^"_PersonCount_"^"_PYCcount_"^"_PYFcount		
		d json.InsertRowData(tmp)
		Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCcount^PYFcount",1)
	 
	 	k json	 	
		Quit resultString
}

//根据机构编码得到家庭档案总数 和个人档案总数

ClassMethod GetFPCount(CommunityCode As %String) As %String
{
	     s FamilyCount=0
         s PersonCount=0
	 	 s rowid=0
	     f  s rowid=$o(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,0,rowid)) q:rowid=""    d  
	     .s tmp=##class(CHSS.ReportCommunityFPCount).%OpenId(rowid)
	     .s FamilyCount=tmp.FamilyCount //家庭档案数
 	     .s PersonCount=tmp.PersonCount //个人档案数
 	     q FamilyCount_"^"_PersonCount
}

//根据机构编码 日期范围 得到 体检数 按体检日期 按录入日期

ClassMethod GetPYCCount(CommunityCode As %String, BeginDate As %Date, EndDate As %Date)
{

	    set PYCcount=0
		set PYFcount=0
 	    f i=BeginDate:1:EndDate d
 	    . s ReportRowid=0
	    .f  s ReportRowid=$o(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,i,ReportRowid)) q:ReportRowid=""    d 
        ..s PYCTmp=##class(CHSS.ReportCommunityPYCCount).%OpenId(ReportRowid)
        ..s CheckCount=PYCTmp.CheckCount
        ..s FillCount=PYCTmp.FillCount
 	    ..i CheckCount'="" d
 	    ...s PYCcount=PYCcount+CheckCount  //体检日期数
 	    ..i FillCount'="" d
 	    ...s PYFcount=PYFcount+FillCount   //录入日期数
 	     q PYCcount_"^"_PYFcount
}

ClassMethod ReportAllList(SectionId As %Integer, CheckType As %String, BeginDate As %String, EndDate As %String) As %String
{
    set BeginDate = $zdh(BeginDate,3)
	set EndDate = $zdh(EndDate,3)	
	Set count=0
	Set resultString = ""	
    set FamilyCountZ=0
	set PersonCountZ=0
    set PYCcountZ=0
	set PYFcountZ=0
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""    
  
    s resultall = ##class(%Library.ResultSet).%New()        
    
    s sqlStr = "select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_" and street.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s sqlStr = sqlStr_" union select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictVillage village, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_"  and street.rowid = village.RowIdParref and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
 
	d resultall.Prepare(sqlStr)
	d resultall.Execute()
	
   	s markpersonrowid=""
	While(resultall.Next())
	{
		Set count=count+1
		s StrCode=resultall.Data("CommunityCode")
		s CommunityName=resultall.Data("CommunityName")
        set PYCDistinctCount="0"
	    set PYCcount="0"
 
		  ;总家庭档案数
	     ;w StrCode
	    s FPCount=..GetFPCount(StrCode)
        s FamilyCount=$P(FPCount,"^",1)
        s PersonCount=$P(FPCount,"^",2)
        set FamilyCountZ=FamilyCountZ+FamilyCount
		set PersonCountZ=PersonCountZ+PersonCount	 
		 
		 ;体检日期 录入日期 数
        s PYCCount=..GetPYCCount(StrCode,BeginDate, EndDate )
        s PYCcount=$P(PYCCount,"^",1)
        s PYFcount=$P(PYCCount,"^",2)
     	set PYCcountZ=PYCcountZ+PYCcount
		set PYFcountZ=PYFcountZ+PYFcount 
		
		
		Set tmp=CommunityName_"^"_FamilyCount_"^"_PersonCount_"^"_PYCcount_"^"_PYFcount		
		 
        d json.InsertRowData(tmp)    	
    }
    Set tmp="<b><font color=red>总计</font></b>"_"^"_FamilyCountZ_"^"_PersonCountZ_"^"_PYCcountZ_"^"_PYFcountZ
    d json.InsertRowData(tmp)	
    d resultall.Close()
    
         
    Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCcount^PYFcount",count+1)
    k json
      
    Quit resultString
}

ClassMethod ReportAllListCity(SectionId As %Integer, CheckType As %String, BeginDate As %String, EndDate As %String) As %String
{
    set BeginDate = $zdh(BeginDate,3)
	set EndDate = $zdh(EndDate,3)
	Set count=0
	Set resultString = ""	
	;w BeginDate_"=="_EndDate 	
    set FamilyCountZ="0"
	set PersonCountZ="0"
    set PYCcountZ=0 
    set PYFcountZ="0"
    set StrCode=""
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""     
  	Set resultall = ##class(%Library.ResultSet).%New() 
     s sqlStr = "select RowId , Description from CHSS.DictSection where rowidparref ="_SectionId
	;w sqlStr
	d resultall.Prepare(sqlStr)
	d resultall.Execute()
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s markpersonrowid=""
	While(resultall.Next())
	{
		s rowid = resultall.Data("RowId")
		s text = resultall.Data("Description")			 
		set FamilyCount="0" 
     	set PersonCount="0" 
        set PYCcount="0"
	    set PYFcount="0"
		s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowIdParref = "_rowid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
        s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowIdParref="_rowid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
        
        ;w CommunityCodesqlStr
        Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
        d resultCommunityCode.Prepare(CommunityCodesqlStr)
	    d resultCommunityCode.Execute()
		While(resultCommunityCode.Next())
		{ 
		  set StrCode = resultCommunityCode.Get("code")	
		  ;总家庭档案数 ;总个人档案数 
	     s FPCount=..GetFPCount(StrCode)
        s FamilyCount=FamilyCount+$P(FPCount,"^",1)
        s PersonCount=PersonCount+$P(FPCount,"^",2) 	 
	    ;总体检人数 总体检人次
	    ;体检日期 录入日期 数
        s PYCCount=..GetPYCCount(StrCode,BeginDate, EndDate )
        s PYCcount=PYCcount+$P(PYCCount,"^",1)
        s PYFcount=PYFcount+$P(PYCCount,"^",2) 
	}
	   d resultCommunityCode.Close()
		Set tmp=text_"^"_FamilyCount_"^"_PersonCount_"^"_PYCcount_"^"_PYFcount		
	    Set count=count+1
        set FamilyCountZ=FamilyCountZ+FamilyCount
		set PersonCountZ=PersonCountZ+PersonCount
	 	set PYCcountZ=PYCcountZ+PYCcount
		set PYFcountZ=PYFcountZ+PYFcount 
       d json.InsertRowData(tmp)  
	}
    Set tmp="<b><font color=red>总计</font></b>"_"^"_FamilyCountZ_"^"_PersonCountZ_"^"_PYCcountZ_"^"_PYFcountZ
    d json.InsertRowData(tmp)	
    d resultall.Close()    
         
    Set resultString = json.getJsonData("CommunityName^FamilyCount^PersonCount^PYCcount^PYFcount",count+1)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="ReportPYCServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportPYCServiceD</DataLocation>
<DefaultData>ReportPYCServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportPYCServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ReportPYCServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportPYCServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
