Class CHSSWeb.ReportOfTrigger Extends %Persistent
{

//个人档案、家庭档案表插入时对CHSS.ReportCommunityFPCount表进行操作

ClassMethod RecordInsert(TableName, CurrentRowId, CommunityCode, DateOfRegister)
{
 
   Set $ZT="ERROR"	
	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId="")) 
	s CurDate=$P($H,",",1)
    s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityFPCount).%OpenId(RowIdN)
		 .i TableName="FamilyHealthRecord" d
		 ..s tmpR.FamilyCount=tmpR.FamilyCount+1
		 .e  d
		 ..s tmpR.PersonCount=tmpR.PersonCount+1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertUpdate',:re) ) 
		 e  d
		  .set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.DateOfRegister= DateOfRegister
		  .i TableName="FamilyHealthRecord" d
		  ..s tmpComm.FamilyCount=1
		  .e  d
		  ..s tmpComm.PersonCount=1
		  .s re=tmpComm.%Save()
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertInsert',:re) )
           d ..RecordTotal(CommunityCode,TableName,"add")
          q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeInsert',:ErrorMsg) )
 q
}

//家庭档案个人档案总数 加一减一

ClassMethod RecordTotal(CommunityCode As %String, TableName As %String, Action As %String)
{
  Set $ZT="ERROR"
  	s CurDate=$P($H,",",1)	
	s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,0,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityFPCount).%OpenId(RowIdN)
	     .i Action="add" d
 	     ..i TableName="FamilyHealthRecord" d
 	     ...s tmpR.FamilyCount=tmpR.FamilyCount+1
 	     ..e  d
 	     ...s tmpR.PersonCount=tmpR.PersonCount+1
	     .i Action="delete" d
 	     ..i TableName="FamilyHealthRecord" d
 	     ...i tmpR.FamilyCount>0 d
 	     ....s tmpR.FamilyCount=tmpR.FamilyCount-1
 	     ..e  d
 	     ...i tmpR.PersonCount>0 d
 	     ....s tmpR.PersonCount=tmpR.PersonCount-1
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
       e  d
          .i Action="add" d
		  ..set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  ..s tmpComm.CommunityCode=CommunityCode		  
		  ..s tmpComm.DateOfRegister= 0
		  ..i TableName="FamilyHealthRecord" d
		  ...s tmpComm.FamilyCount=1
		  ..e  d
		  ...s tmpComm.PersonCount=1
		  ..s re=tmpComm.%Save()
		  ..i re'=1  d
		  ...s re=$Extract(re,1,200)
		  ...&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalInsert',:re) )
   q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'BeforeInsert',:ErrorMsg) )
 q
}

//个人档案、家庭档案表修改前对CHSS.ReportCommunityFPCount表进行操作

//可拆分正增加和删除操作

ClassMethod RecordUpdate(TableName As %String, CurrentRowId As %String, CommunityCode As %String, DateOfRegister As %String)
{
 
	Set $ZT="ERROR"
	s CurDate=$P($H,",",1)
 	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId=""))
	s DateOfRegisterOld=..SearchDateByRowid(TableName,CurrentRowId)
    i $L(DateOfRegisterOld)=10 d
    .s DateOfRegisterOld=$ZDH(DateOfRegisterOld,3)
     i $L(DateOfRegister)=10 d
    .s DateOfRegister=$ZDH(DateOfRegister,3)
	q:DateOfRegisterOld=DateOfRegister //相等的话不用操作
	
    s RowId=0
    s RowIdN=""
		 f  s RowId = $O(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
		 i RowIdN'=""  d 
		 .s tmpR=##class(CHSS.ReportCommunityFPCount).%OpenId(RowIdN)
		 .i TableName="FamilyHealthRecord" d
		 ..s tmpR.FamilyCount=tmpR.FamilyCount+1
		 .e  d
		 ..s tmpR.PersonCount=tmpR.PersonCount+1
		 .s re=tmpR.%Save()
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateUpdate',:re) ) 
		 e  d 
		  .set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode	 
		  .s tmpComm.DateOfRegister= DateOfRegister 
		  .i TableName="FamilyHealthRecord" d
		  ..s tmpComm.FamilyCount=1
		  .e  d
		  ..s tmpComm.PersonCount=1
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateInsert',:re) ) 
	 	q:DateOfRegisterOld=""
	     s RowId=0
         s RowIdN=""
       	 f  s RowId = $O(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegisterOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
	     i RowIdN'=""  d 
		  .s tmpR=##class(CHSS.ReportCommunityFPCount).%OpenId(RowIdN)
		  .i TableName="FamilyHealthRecord" d 
		  ..s tmpR.FamilyCount=tmpR.FamilyCount-1 
		  .e  d 
		  ..s tmpR.PersonCount=tmpR.PersonCount-1 
		  .s re=tmpR.%Save() 
		  .i re'=1 d 
		  ..s re=$Extract(re,1,200) 
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'Delete',:re) )
    q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeUpdate',:ErrorMsg) )
 q
}

ClassMethod RecordDelete(TableName, CurrentRowId, CommunityCode, DateOfRegister)
{
    Set $ZT="ERROR"	
	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId="")) 
	s CurDate=$P($H,",",1)
	i TableName="FamilyHealthRecord" d
	.&SQL(Update CHSS.ReportCommunityFPCount set FamilyCount=FamilyCount-1 where CommunityCode=:CommunityCode and DateOfRegister=:DateOfRegister )
    e  d
    .&SQL(Update CHSS.ReportCommunityFPCount set PersonCount=PersonCount-1 where CommunityCode=:CommunityCode and DateOfRegister=:DateOfRegister )
    s result=SQLCODE
    i result'=0 d
    .&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'SQLDelete',:result) )
  d ..RecordTotal(CommunityCode,TableName,"delete")
 q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeDelete',:ErrorMsg) )
 q
}

ClassMethod SearchDateByRowid(TableName As %String, CurrentRowId As %String)
{
	    Set result = ##class(%Library.ResultSet).%New() 
	    i TableName="FamilyHealthRecord" d
		.Set sqlStr="select DateOfRegister As DateOfRegister from CHSS.FamilyHealthRecord F where F.FamilyRowId="_CurrentRowId
		e  d
	    .Set sqlStr="select DateRegister As DateOfRegister from CHSS.PersonHealthRecordMain P where P.PersonRowId="_CurrentRowId
		s DateOfRegister=""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{		 
		  set DateOfRegister = result.Get("DateOfRegister")
		}
		q DateOfRegister
}

//体检记录添加时

ClassMethod PYCInsert(YearCheckRowId, CommunityCode, DateCheck, FillDate)
{
  s TableName="PersonYearCheckRecord"
  Set $ZT="ERROR"	 
	q:((CommunityCode="")||(DateCheck="")||(FillDate="")) 
	s CurDate=$P($H,",",1)
    s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,DateCheck,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
		 .s tmpR.CheckCount=tmpR.CheckCount+1
		 .i DateCheck=FillDate d
		 ..s tmpR.FillCount=tmpR.FillCount+1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'InsertUpdateDateCheck',:re) ) 
		 e  d
		  .set tmpComm =##class(CHSS.ReportCommunityPYCCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.Date= DateCheck
		  .s tmpComm.CheckCount= 1
		  .i DateCheck=FillDate d
		  ..s tmpComm.FillCount=1
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'InsertInsertDateCheck',:re) )
         //按录入日期
          i DateCheck'=FillDate  d
		.s RowId=0
		.s RowIdN=""  
		.f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDate,RowId)) q:RowId=""  d
		..s RowIdN=RowId 
		.i RowIdN'=""  d
		..s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
		..s tmpR.FillCount=tmpR.FillCount+1
		..s re=tmpR.%Save() 
		..i re'=1 d
		...s re=$Extract(re,1,200)
		...&sql(INSERT INTO CHSS.ReportLog ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'InsertUpdateFillDate',:re) ) 
		.e  d
		..set tmpComm =##class(CHSS.ReportCommunityPYCCount).%New()
		..s tmpComm.CommunityCode=CommunityCode		  
		..s tmpComm.Date= FillDate
		..s tmpComm.FillCount=1
		..s re=tmpComm.%Save()
		..i re'=1  d
		...s re=$Extract(re,1,200)
		...&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'InsertInsertFillDate',:re) )
      q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'BeforeInsert',:ErrorMsg) )
 q
}

//体检记录修改时

ClassMethod PYCUpdate(YearCheckRowId, CommunityCode, DateCheck, FillDate)
{
	 
  s TableName="PersonYearCheckRecord"   
  Set $ZT="ERROR"  
  q:((CommunityCode="")||(DateCheck="")||(FillDate="")) 
  s DateAndCommunityCode=..SearchDateAndCommunityCode(YearCheckRowId)
  s DateCheckOld=$P(DateAndCommunityCode,"^",1)	 
  s FillDateOld=$P(DateAndCommunityCode,"^",2)
  s CommunityCodeOld=$P(DateAndCommunityCode,"^",3) //机构有变化先不管
  s Mark=$P(DateAndCommunityCode,"^",4) //机构有变化先不管
  i Mark="NULL" d
  .d ..PYCInsert(YearCheckRowId, CommunityCode, DateCheck, FillDate)
  q:Mark="NULL" 
  q:((DateCheckOld=DateCheck)&&(FillDateOld=FillDate))
  s CurDate=$P($H,",",1)
  
	if ((DateCheckOld'=DateCheck)&&(FillDateOld'=FillDate)){ 
	 d ..PYCInsert(YearCheckRowId, CommunityCode, DateCheck, FillDate)
   //体检日期减一
	  s RowId=0
      s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,DateCheckOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
	     .i tmpR.CheckCount>0 d
		 ..s tmpR.CheckCount=tmpR.CheckCount-1
		 .i DateCheckOld=FillDateOld d
		 ..i tmpR.FillCount>0 d
		 ...s tmpR.FillCount=FillCount-1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateDateCheck-1',:re) ) 
    
    if (DateCheckOld'=FillDateOld){
      //录入日期减一
	  s RowId=0
      s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDateOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
	     .i tmpR.FillCount>0 d
		 ..s tmpR.FillCount=tmpR.FillCount-1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateFillCheck-2',:re) ) 
    } 
   }elseif (DateCheckOld'=DateCheck){
	     s RowId=0
         s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,DateCheckOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
	     .i tmpR.CheckCount>0 d
		 ..s tmpR.CheckCount=tmpR.CheckCount-1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateFillCheck-13',:re) ) 
        s RowId=0
         s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,DateCheck,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)	   
		 .s tmpR.CheckCount=tmpR.CheckCount+1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateFillCheck-14',:re) ) 
         e  d
          .set tmpComm =##class(CHSS.ReportCommunityPYCCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.Date= DateCheck
		  .s tmpComm.CheckCount= 1
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'InsertInsertDateCheck-15',:re) )
   
   }elseif(FillDateOld'=FillDate){
	   
	   	 s RowId=0
         s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDateOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
	     .i tmpR.FillCount>0 d
		 ..s tmpR.FillCount=tmpR.FillCount-1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateFillCheck-16',:re) ) 
        s RowId=0
         s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDate,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)	   
		 .s tmpR.FillCount=tmpR.FillCount+1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateUpdateFillCheck-17',:re) ) 
         e  d
          .set tmpComm =##class(CHSS.ReportCommunityPYCCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.Date= FillDate
		  .s tmpComm.FillCount= 1
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'UpdateInsertFillCheck-18',:re) )
    } 
  
      q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'BeforeInsert',:ErrorMsg) )
 q
}

//体检记录删除

ClassMethod PYCDelete(YearCheckRowId, CommunityCode, DateCheck, FillDate)
{
  s TableName="PersonYearCheckRecord"
  Set $ZT="ERROR"
  s CurDate=$P($H,",",1)
   q:((CommunityCode="")||(DateCheck="")||(FillDate="")) 
 
   //体检日期减一
	  s RowId=0
      s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,DateCheck,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN) 
	     .i tmpR.CheckCount>0 d 
		 ..s tmpR.CheckCount=tmpR.CheckCount-1 
		 .i DateCheck=FillDate d 
		 ..i tmpR.FillCount>0 d
		 ...s tmpR.FillCount=tmpR.FillCount-1 
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'DeleteDateCheck',:re) ) 
    if (DateCheck'=FillDate){
      //录入日期减一
	  s RowId=0
      s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDate,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
	     .i tmpR.FillCount>0 d
		 ..s tmpR.FillCount=tmpR.FillCount-1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.ReportLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'DeleteFillCheck',:re) ) 
    }
      q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.ReportLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:YearCheckRowId,'BeforeDelete',:ErrorMsg) )
 q
}

//根据体检表的主键查找体检日期录入日期

ClassMethod SearchDateAndCommunityCode(CurrentRowId As %String)
{
 
	    Set result = ##class(%Library.ResultSet).%New() 
	    Set sqlStr="Select DateCheck,FillDate,CommunityCode,Mark from CHSS.PersonYearCheckRecord where YearCheckRowId="_CurrentRowId
		;w sqlStr,!
		d result.Prepare(sqlStr)
		d result.Execute()
	    set DateCheck = ""
		set FillDate = ""
		While(result.Next())
		{		 
		  set DateCheck = result.Get("DateCheck")
		  set FillDate = result.Get("FillDate")
		  set CommunityCode = result.Get("CommunityCode")
		  set Mark = result.Get("Mark")
		}
		q DateCheck_"^"_FillDate_"^"_CommunityCode_"^"_Mark
}

Storage Default
{
<Data name="ReportOfTriggerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportOfTriggerD</DataLocation>
<DefaultData>ReportOfTriggerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportOfTriggerD</IdLocation>
<IndexLocation>^CHSSWeb.ReportOfTriggerI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportOfTriggerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
