Class CHSSWeb.CommunityWorkStaNumService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod initCommunityStaData()
{
	&sql(delete from CHSS.CommunityWorkStaNum)
	//初始化儿童建档数
	&sql(insert into CHSS.CommunityWorkStaNum (CommunityCode,DateOfRegister,ChildArcAllNum) select p.communitycode ,p.operatedate,count(communitycode)   from chss.childbaseinfo p where communitycode <>'' and operatedate<>'' group by  p.communitycode,p.operatedate)
	//
	d ..initWomanData()
	d ..initElderData()
	d ..initHBPData()
	d ..initDiabeteData()
	d ..initSchizoData()
	d ..initHandicappedData()
	d ..initDeadPersonData()
}

//初始化妇女建档数	

ClassMethod initWomanData()
{
	s sqlstr="select p.communitycode as communitycode,p.operatedate as DateOfRegister,count(communitycode) as WomanArcAllNum  from chss.WomenBaseInfo p where communitycode <>'' and operatedate<>'' group by  p.communitycode,p.operatedate"
    Set result = ##class(%Library.ResultSet).%New()    
  	d result.Prepare(sqlstr)
    d result.Execute()
	While(result.Next())
	{
	s communitycode=result.Get("communitycode")
	s DateOfRegister=result.Get("DateOfRegister")
	s WomanArcAllNum=result.Get("WomanArcAllNum")
	s rowid=0
	s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_communitycode,DateOfRegister,rowid))
	;w RowIdN,!
	i RowIdN'="" d
	.s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	.s tempStaNum.WomanArcAllNum=WomanArcAllNum
	.d tempStaNum.%Save()  
	e  d
	.s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	.s tempStaNum.CommunityCode=communitycode
	.s tempStaNum.DateOfRegister=DateOfRegister
	.s tempStaNum.WomanArcAllNum=WomanArcAllNum
	.d tempStaNum.%Save()  
		}
	d result.Close()
}

//初始化老年人

ClassMethod initElderData()
{
	  s sqlstr="select count(c.communitycode) as ElderArcAllNum,c.communitycode as communitycode,c.dateregister as DateOfRegister from (select b.communitycode as communitycode,a.DateOfRecord as  dateregister  from CHSS.personhealthrecordmain b left join CHSS.ElerlyBaseInfo a on a.personrowid=b.personrowid where a.personrowid<>'' and a.DateOfRecord<>'')c group by c.communitycode,c.dateregister"
    Set result = ##class(%Library.ResultSet).%New()    
  	d result.Prepare(sqlstr)
    d result.Execute()
	While(result.Next())
	{
	s communitycode=result.Get("communitycode")
	s DateOfRegister=result.Get("DateOfRegister")
	s ElderArcAllNum=result.Get("ElderArcAllNum")
	s rowid=0
	s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_communitycode,DateOfRegister,rowid))
	;w RowIdN,!
	i RowIdN'="" d
	.s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	.s tempStaNum.ElderArcAllNum=ElderArcAllNum
	.d tempStaNum.%Save()  
	e  d
	.s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	.s tempStaNum.CommunityCode=communitycode
	.s tempStaNum.DateOfRegister=DateOfRegister
	.s tempStaNum.ElderArcAllNum=ElderArcAllNum
	.d tempStaNum.%Save()  
		}
	d result.Close()
}

//初始化高血压

ClassMethod initHBPData()
{
	    s sqlstr="select c.communitycode  as communitycode,count(communitycode) as HBPArcAllNum from(select b.communitycode  from CHSS.PersonHealthDiagnose a left join chss.personhealthrecordmain  b on a.PersonRowidParref=b.personrowid  where a.ItemdCode = '22' and a.ItemAssortName = '高血压')c where c.communitycode<>'' group by c.communitycode"
	    Set result = ##class(%Library.ResultSet).%New()    
  	    d result.Prepare(sqlstr)
        d result.Execute()
	    While(result.Next())
		{
		s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
		s tempStaNum.CommunityCode=result.Get("communitycode")
		s tempStaNum.DateOfRegister=0
	    s tempStaNum.HBPArcAllNum=result.Get("HBPArcAllNum")
        d tempStaNum.%Save()  
		}
		d result.Close()
}

//初始化糖尿病

ClassMethod initDiabeteData()
{
	 s sqlstr="select c.communitycode  as communitycode,count(communitycode) as DiabeteArcAllNum from(select b.communitycode  from CHSS.PersonHealthDiagnose a left join chss.personhealthrecordmain  b on a.PersonRowidParref=b.personrowid  where a.ItemdCode = '22' and a.ItemAssortName = '糖尿病')c where c.communitycode<>'' group by c.communitycode"
	
	  Set result = ##class(%Library.ResultSet).%New()    
  	    d result.Prepare(sqlstr)
        d result.Execute()
	    While(result.Next())
		{
	
		s CommunityCode=result.Get("communitycode")
		s DateOfRegister=0
	    s DiabeteArcAllNum=result.Get("DiabeteArcAllNum")
	    s rowid=0
        s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid))
	    i RowIdN'="" d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	   .s tempStaNum.DiabeteArcAllNum=DiabeteArcAllNum
	   .d tempStaNum.%Save()  
       e  d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	   .s tempStaNum.CommunityCode=CommunityCode
	   .s tempStaNum.DateOfRegister=0
	   .s tempStaNum.DiabeteArcAllNum=DiabeteArcAllNum
	   .d tempStaNum.%Save()  
		}
	    d result.Close()
}

//初始化精神病

ClassMethod initSchizoData()
{
	 	s sqlstr="select c.communitycode  as communitycode,count(communitycode) as SchizoArcAllNum from(select b.communitycode  from CHSS.PersonHealthDiagnose a left join chss.personhealthrecordmain  b on a.PersonRowidParref=b.personrowid  where a.ItemdCode = '22' and a.ItemAssortName = '精神病')c where c.communitycode<>'' group by c.communitycode"
	
	    Set result = ##class(%Library.ResultSet).%New()    
  	    d result.Prepare(sqlstr)
        d result.Execute()
	    While(result.Next())
		{
        s CommunityCode=result.Get("communitycode")
        s DateOfRegister=0
	    s SchizoArcAllNum=result.Get("SchizoArcAllNum")
	    s rowid=0
         s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid))
	    i RowIdN'="" d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	   .s tempStaNum.SchizoArcAllNum=SchizoArcAllNum
	   .d tempStaNum.%Save()  
       e  d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	   .s tempStaNum.CommunityCode=CommunityCode
	   .s tempStaNum.DateOfRegister=0
	   .s tempStaNum.SchizoArcAllNum=SchizoArcAllNum
	   .d tempStaNum.%Save()  
		}
	  
	    d result.Close()
}

//初始化残疾人

ClassMethod initHandicappedData()
{
	 
	    s sqlstr="select c.communitycode  as communitycode,count(communitycode) as HandicappedArcAllNum from(select b.communitycode  from CHSS.PersonHealthDiagnose a left join chss.personhealthrecordmain  b on a.PersonRowidParref=b.personrowid  where a.ItemdCode = '14')c where c.communitycode<>'' group by c.communitycode"
	
	    Set result = ##class(%Library.ResultSet).%New()    
  	    d result.Prepare(sqlstr)
        d result.Execute()
	    While(result.Next())
		{
        s CommunityCode=result.Get("communitycode")
		s DateOfRegister=0
	    s HandicappedArcAllNum=result.Get("HandicappedArcAllNum")
        s rowid=0
        s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid))
	    i RowIdN'="" d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	   .s tempStaNum.HandicappedArcAllNum=HandicappedArcAllNum
	   .d tempStaNum.%Save()  
       e  d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	   .s tempStaNum.CommunityCode=CommunityCode
	   .s tempStaNum.DateOfRegister=0
	   .s tempStaNum.HandicappedArcAllNum=HandicappedArcAllNum
	   .d tempStaNum.%Save()  
		}
	    d result.Close()
}

//初始化 机构死亡人数

ClassMethod initDeadPersonData()
{
	 
	    s sqlstr="SELECT communitycode as communitycode,count(communitycode) as  CommunityDeathNum FROM CHSS.PERSONHEALTHRECORDMAIN WHERE  PersonStatus=7 group by communitycode"
	
	    Set result = ##class(%Library.ResultSet).%New()    
  	    d result.Prepare(sqlstr)
        d result.Execute()
	    While(result.Next())
		{
        s CommunityCode=result.Get("communitycode")
		s DateOfRegister=0
	    s CommunityDeathNum=result.Get("CommunityDeathNum")
        s rowid=0
        s RowIdN=$O(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid))
	    i RowIdN'="" d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%OpenId(RowIdN)
	   .s tempStaNum.CommunityDeathNum=CommunityDeathNum
	   .d tempStaNum.%Save()  
       e  d
	   .s tempStaNum=##class(CHSS.CommunityWorkStaNum).%New()
	   .s tempStaNum.CommunityCode=CommunityCode
	   .s tempStaNum.DateOfRegister=0
	   .s tempStaNum.CommunityDeathNum=CommunityDeathNum
	   .d tempStaNum.%Save()  
		}
	    d result.Close()
}

Storage Default
{
<Data name="CommunityWorkStaNumServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityWorA91D</DataLocation>
<DefaultData>CommunityWorkStaNumServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityWorA91D</IdLocation>
<IndexLocation>^CHSSWeb.CommunityWorA91I</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityWorA91S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
