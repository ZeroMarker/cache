Class CHSSWeb.CommStaTriggerService Extends %Persistent
{

//插入时对 表 CHSS.CommunityWorkStaNum  操作

ClassMethod RecordInsert(TableName, CurrentRowId, CommunityCode, DateOfRegister)
{
 
   Set $ZT="ERROR"	
	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId="")) 
	s CurDate=$P($H,",",1)
    s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		 .i TableName="ChildBaseInfo" d
		 ..s tmpR.ChildArcAllNum=tmpR.ChildArcAllNum+1
		 .e  i TableName="WomenBaseInfo" d
		 ..s tmpR.WomanArcAllNum=tmpR.WomanArcAllNum+1
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertUpdate',:re) ) 
		 e  d
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.DateOfRegister= DateOfRegister
		  .i TableName="ChildBaseInfo" d
		  
		  ..s tmpComm.ChildArcAllNum=1
		  
		  .e  i TableName="WomenBaseInfo" d
		  ..s tmpComm.WomanArcAllNum=1
		  .s re=tmpComm.%Save()
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertInsert',:re) )
           
          q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeInsert',:ErrorMsg) )
 q
}

//修改前对CHSS.CommunityWorkStaNum表进行操作

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
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
		 i RowIdN'=""  d 
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		 .i TableName="ChildBaseInfo" d
		 ..s tmpR.ChildArcAllNum=tmpR.ChildArcAllNum+1
		 .e  i TableName="WomenBaseInfo" d
		 ..s tmpR.WomanArcAllNum=tmpR.WomanArcAllNum+1
		 .s re=tmpR.%Save()
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateUpdate',:re) ) 
		 e  d 
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		  .s tmpComm.CommunityCode=CommunityCode	 
		  .s tmpComm.DateOfRegister= DateOfRegister 
		  .i TableName="ChildBaseInfo" d
		  ..s tmpComm.ChildArcAllNum=1
		  .e  i TableName="WomenBaseInfo" d
		  ..s tmpComm.WomanArcAllNum=1
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateInsert',:re) ) 
	 	q:DateOfRegisterOld=""
	     s RowId=0
         s RowIdN=""
       	 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegisterOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
	     i RowIdN'=""  d 
		  .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		  .i TableName="ChildBaseInfo" d 
		  ..s tmpR.ChildArcAllNum=tmpR.ChildArcAllNum-1 
		   .e  i TableName="WomenBaseInfo" d
		  ..s tmpR.WomanArcAllNum=tmpR.WomanArcAllNum-1 
		  .s re=tmpR.%Save() 
		  .i re'=1 d 
		  ..s re=$Extract(re,1,200) 
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateDelete',:re) )
    q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeUpdate',:ErrorMsg) )
 q
}

//删除操作

ClassMethod RecordDelete(TableName, CurrentRowId, CommunityCode, DateOfRegister)
{

    Set $ZT="ERROR"	
	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId="")) 
	s CurDate=$P($H,",",1)
	i TableName="ChildBaseInfo" d
	.&SQL(Update CHSS.CommunityWorkStaNum set ChildArcAllNum=ChildArcAllNum-1 where CommunityCode=:CommunityCode and DateOfRegister=:DateOfRegister )
    .e  i TableName="WomenBaseInfo" d
    .&SQL(Update CHSS.CommunityWorkStaNum set WomanArcAllNum=WomanArcAllNum-1 where CommunityCode=:CommunityCode and DateOfRegister=:DateOfRegister )
    s result=SQLCODE
    i result'=0 d
    .&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'DeleteDelete',:result) )
   
 q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeDelete',:ErrorMsg) )
 q
}

//插入时对表  CHSS.CommunityWorkStaNum  操作(老年人管理表)

ClassMethod ElerlyRecordInsert(TableName, CurrentRowId, PersonRowId, DateOfRegister)
{
    ;w "-------------------"
   
   Set $ZT="ERROR"
   s CommunityCode=""
   i PersonRowId'="" d
    .;w "==="_PersonRowId,!
	.s CommunityCode=PersonRowId.CommunityCode
	.;w "======"_CommunityCode,!
	q:((DateOfRegister="")||(PersonRowId="")||(CurrentRowId="")) 

	
	
	s CurDate=$P($H,",",1)
    s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		
		 .s tmpR.ElderArcAllNum=tmpR.ElderArcAllNum+1
		
		 .s re=tmpR.%Save() 
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertUpdate',:re) ) 
		 e  d
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.DateOfRegister= DateOfRegister
		  .s tmpComm.ElderArcAllNum=1
	
		  .s re=tmpComm.%Save()
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'InsertInsert',:re) )
           
          q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeInsert',:ErrorMsg) )
 q
}

//修改前对CHSS.CommunityWorkStaNum表进行操作(老年人管理表)

ClassMethod ElerlyRecordUpdate(TableName As %String, CurrentRowId As %String, PersonRowId As %String, DateOfRegister As %String)
{
 
	Set $ZT="ERROR"
	 s CommunityCode=""
   i PersonRowId'="" d
	.s CommunityCode=PersonRowId.CommunityCode
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
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegister,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
		 i RowIdN'=""  d 
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		
		 .s tmpR.ElderArcAllNum=tmpR.ElderArcAllNum+1
		
		 .s re=tmpR.%Save()
		 .i re'=1 d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog 
              ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateUpdate',:re) ) 
		 e  d 
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		  .s tmpComm.CommunityCode=CommunityCode	 
		  .s tmpComm.DateOfRegister= DateOfRegister 
		 
		  .s tmpComm.ElderArcAllNum=1
		 
		  .s re=tmpComm.%Save() 
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateInsert',:re) ) 
	 	q:DateOfRegisterOld=""
	     s RowId=0
         s RowIdN=""
       	 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,DateOfRegisterOld,RowId)) q:RowId=""  d
		 .s RowIdN=RowId
	     i RowIdN'=""  d 
		  .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		 
		  .s tmpR.ElderArcAllNum=tmpR.ElderArcAllNum-1 
		  
		  .s re=tmpR.%Save() 
		  .i re'=1 d 
		  ..s re=$Extract(re,1,200) 
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'UpdateDelete',:re) )
    q 
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeUpdate',:ErrorMsg) )
 q
}

//删除操作(老年人管理)

ClassMethod ElerlyRecordDelete(TableName, CurrentRowId, PersonRowId, DateOfRegister)
{

    Set $ZT="ERROR"	
    s CommunityCode=""
   i PersonRowId'="" d
	.s CommunityCode=PersonRowId.CommunityCode
	q:((DateOfRegister="")||(CommunityCode="")||(CurrentRowId="")) 
	s CurDate=$P($H,",",1)

    &SQL(Update CHSS.CommunityWorkStaNum set ElderArcAllNum=ElderArcAllNum-1 where CommunityCode=:CommunityCode and DateOfRegister=:DateOfRegister )
    s result=SQLCODE
    i result'=0 d
    .&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'DeleteDelete',:result) )
   
 q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:CurrentRowId,'BeforeDelete',:ErrorMsg) )
 q
}

//添加， 高血压，糖尿病，精神病，残疾人，对中间表进行操作

ClassMethod DiagnoseRecordInsert(DiagnoseRowId, PersonRowId, ItemdCode, ItemAssortName)
{
  Set $ZT="ERROR"
    s CommunityCode=""
    &sql(select CommunityCode into:CommunityCode from CHSS.PersonHealthRecordMain where PersonRowId=:PersonRowId)
  	i SQLCODE=100 d
  	.s CommunityCode=""
  	
  	s CurDate=$P($H,",",1)	
	s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .;W "bbbbbbbbbbbbbbbbbbbbbbbb",!
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	     .i (ItemdCode = "22")&(ItemAssortName="高血压") d
 	     ..s tmpR.HBPArcAllNum=tmpR.HBPArcAllNum+1
 	     .e  i (ItemdCode = "22")&(ItemAssortName="糖尿病") d
 	     ..s tmpR.DiabeteArcAllNum=tmpR.DiabeteArcAllNum+1
 	     .e  i (ItemdCode = "22")&(ItemAssortName="精神病") d
 	      ..s tmpR.SchizoArcAllNum=tmpR.SchizoArcAllNum+1
 	     .e  i (ItemdCode = "14") d
 	     .. s tmpR.HandicappedArcAllNum=tmpR.HandicappedArcAllNum+1
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
       e  d
        
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		 
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.DateOfRegister= 0
		  .i (ItemdCode = "22")&(ItemAssortName="高血压") d
 	     
 	      ..s tmpComm.HBPArcAllNum=1
 	      
 	      .e  i (ItemdCode = "22")&(ItemAssortName="糖尿病") d
 	     
 	      ..s tmpComm.DiabeteArcAllNum=1
 	     
 	      .e  i (ItemdCode = "22")&(ItemAssortName="精神病") d
 	      
 	      ..s tmpComm.SchizoArcAllNum=1
 	     
 	      .e  i (ItemdCode = "14") d
 	    
 	      ..s tmpComm.HandicappedArcAllNum=1
 	      
		  .s re=tmpComm.%Save()
		
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalInsert',:re) )
   q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'BeforeInsert',:ErrorMsg) )
 q
}

//删除对中间表的操作

ClassMethod DiagnoseRecordDelete(DiagnoseRowId, PersonRowId, ItemdCode, ItemAssortName)
{
  Set $ZT="ERROR"
    s CommunityCode=""
    &sql(select CommunityCode into:CommunityCode from CHSS.PersonHealthRecordMain where PersonRowId=:PersonRowId)
  	i SQLCODE=100 d
  	.s CommunityCode=""
  	
  	s CurDate=$P($H,",",1)	
	s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	     .i (ItemdCode = "22")&(ItemAssortName="高血压") d
 	     ..s tmpR.HBPArcAllNum=tmpR.HBPArcAllNum-1
 	     .e  i (ItemdCode = "22")&(ItemAssortName="糖尿病") d
 	     ..s tmpR.DiabeteArcAllNum=tmpR.DiabeteArcAllNum-1
 	     .e  i (ItemdCode = "22")&(ItemAssortName="精神病") d
 	      ..s tmpR.SchizoArcAllNum=tmpR.SchizoArcAllNum-1
 	     .e  i (ItemdCode = "14") d
 	     .. s tmpR.HandicappedArcAllNum=tmpR.HandicappedArcAllNum-1
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
 q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'BeforeInsert',:ErrorMsg) )
 q
}

/** .i Action="delete" d
 	     ..i TableName="FamilyHealthRecord" d
 	     ...i tmpR.FamilyCount>0 d
 	     ....s tmpR.FamilyCount=tmpR.FamilyCount-1
 	     ..e  d
 	     ...i tmpR.PersonCount>0 d
 	     ....s tmpR.PersonCount=tmpR.PersonCount-1
**/

//添加， 死亡人数 ，对中间表进行操作

ClassMethod PersonDeathRecordInsert(PersonRowId, CommunityCode, PersonStatus)
{
  Set $ZT="ERROR"
    q:PersonStatus.Description'="死亡归档"
  	s CurDate=$P($H,",",1)	
	s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	     .s tmpR.CommunityDeathNum=tmpR.CommunityDeathNum+1
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
       e  d
        
		  .set tmpComm =##class(CHSS.CommunityWorkStaNum).%New()
		 
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.DateOfRegister= 0
 	      .s tmpComm.CommunityDeathNum=1
 	      
		  .s re=tmpComm.%Save()
		
		  .i re'=1  d
		  ..s re=$Extract(re,1,200)
		  ..&sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalInsert',:re) )
   q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'BeforeInsert',:ErrorMsg) )
 q
}

//更改档案状态， 死亡人数 ，对中间表进行操作

ClassMethod PersonDeathRecordUpdate(PersonRowId, CommunityCode, PersonStatus)
{
  Set $ZT="ERROR"
  s PersonStatusOld=""
  &sql(SELECT A.DESCRIPTION INTO:PersonStatusOld FROM CHSS.DictArchivesStatus A ,CHSS.PERSONHEALTHRECORDMAIN B WHERE A.ROWID=B.PersonStatus AND B.PERSONROWID=:PersonRowId)
  I SQLCODE=100 D
  .S PersonStatusOld=""
  ;q:PersonStatus.Description'="死亡归档"
  	s CurDate=$P($H,",",1)	
	s RowId=0
    s RowIdN=""  
		 f  s RowId = $O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
		 .i (PersonStatus.Description'="死亡归档")&(PersonStatusOld="死亡归档") d
		 
	     ..s tmpR.CommunityDeathNum=tmpR.CommunityDeathNum-1
 	     .e  i (PersonStatus.Description="死亡归档")&(PersonStatusOld'="死亡归档") d
 	     ..s tmpR.CommunityDeathNum=tmpR.CommunityDeathNum+1
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
         e  d
         .s tmpR=##class(CHSS.CommunityWorkStaNum).%New()
		 .i (PersonStatus.Description'="死亡归档")&(PersonStatusOld="死亡归档") d
		 
	     ..s tmpR.CommunityDeathNum=0
 	     .e  i (PersonStatus.Description="死亡归档")&(PersonStatusOld'="死亡归档") d
 	     ..s tmpR.CommunityDeathNum=1
 	     .s tmpR.CommunityCode=CommunityCode		  
		 .s tmpR.DateOfRegister= 0
 	     .s re=tmpR.%Save()
		 .i re'=1  d
		 ..s re=$Extract(re,1,200)
		 ..&sql(INSERT INTO CHSS.CommStaSqlLog   ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'TotalUpdate',:re) )
        
  q
ERROR
 Set ErrorMsg=$Extract($ZE,1,200)	  
 &sql(INSERT INTO CHSS.CommStaSqlLog  ( ErrorDate,TableName,DataRowId,ErrorType,ErrorMsg  ) VALUES (:CurDate,:TableName,:Action,'BeforeInsert',:ErrorMsg) )
 q
}

//根据传入的主键找出对应的日期

ClassMethod SearchDateByRowid(TableName As %String, CurrentRowId As %String)
{
	  
	    Set sqlStr=""
	    Set result = ##class(%Library.ResultSet).%New() 
	    i TableName="ChildBaseInfo" d
		.Set sqlStr="select OperateDate As DateOfRegister from CHSS.ChildBaseInfo F where F.ChildRowId="_CurrentRowId
		e  i TableName="WomenBaseInfo" d
	    .Set sqlStr="select OperateDate As DateOfRegister from CHSS.WomenBaseInfo P where P.WomanRowId="_CurrentRowId
		e  i TableName="ElerlyBaseInfo" d 
		.Set sqlStr="select DateOfRecord as DateOfRegister from CHSS.ElerlyBaseInfo p where p.ElerlyRowId="_CurrentRowId
		s DateOfRegister=""
		
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{		 
		  set DateOfRegister = result.Get("DateOfRegister")
		 
		}
		q DateOfRegister
}

Storage Default
{
<Data name="CommStaTriggerServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommStaTriggerServiceD</DataLocation>
<DefaultData>CommStaTriggerServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommStaTriggerServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CommStaTriggerServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CommStaTriggerServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
