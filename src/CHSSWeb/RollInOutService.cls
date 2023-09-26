Class CHSSWeb.RollInOutService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 个人档案迁出
/// 1、迁出的时候将保存变更记录(PersonChangeRecord)，
/// 2、将该个人档案的CommunityCode字段清空，
/// 3、将该个人档案号存入个人档案迁出表（PersonRollOut）
ClassMethod PersonRollOut(PersonRowId As %String, Username As %String, ReasonNo As %String, OperatorDate As %String, Remark As %String, OldCommunityCode As %String) As %String
{
	i PersonRowId = "" q ""
	s $zt="ERROR"
   
      
	s tempPersonChangeRecord = ##class(CHSS.PersonChangeRecord).%New()
  
	i PersonRowId '= "" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempPersonChangeRecord.PersonRowId=PersonRowIdobj
	i ReasonNo '= "" d
	.s ReasonNoobj=##class(CHSS.DictChangeReason).%OpenId(ReasonNo)
	.s tempPersonChangeRecord.ReasonSn=ReasonNoobj 	
	i Username '= "" d
	.s Usernameobj=##class(User.SSUser).%OpenId(Username)
	.s tempPersonChangeRecord.Operator=Usernameobj
	 i OperatorDate'="" d
	.s OperatorDate=$zdh(OperatorDate,3)
	.s tempPersonChangeRecord.OperatorDate=OperatorDate
	
   
	s tempPersonChangeRecord.RegisterDate = $P($h,",",1)
	s tempPersonChangeRecord.Remark = Remark
	s tempPersonChangeRecord.OldCommunityCode = OldCommunityCode
	s tempPersonChangeRecord.InOrOut = "迁出"
	s result = ""
  
	TSTART	        //下面执行 2操作
	&SQL(update CHSS.PersonHealthRecordMain  set CommunityCode='' where PersonRowId=:PersonRowId)
	
	i SQLCODE=0 d   //下面执行 3操作
	.&SQL(insert into CHSS.PersonRollOut (PersonRowId) values(:PersonRowId))
	.i SQLCODE=0 d //下面执行 1操作
	..s result = tempPersonChangeRecord.%Save()
	i result=1 d
	.TCOMMIT
	.w "{""success"":""true"",""info"":"_tempPersonChangeRecord.%Id()_"}"
	e  d
	.TROLLBACK
	.w "{""success"":""false"",""info"":""数据保存出错!!""}"
	q ""
ERROR 	          
 	TROLLBACK		       
 	W "{""success"":""false"",""info"":""数据保存出错!""}"
 	Q ""
}

/// 查询所有非本社区的人员档案  这里只查社区编码为空的。
ClassMethod PersonRollInList(start As %Integer, limit As %Integer, SearchSql As %String) As %String
{
	Set start=$G(start)
	Set limit=$G(limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
  
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PersonRowId,PersonCode,PersonName,SexDR->CTSEX_Desc   FROM CHSS.PersonHealthRecordMain  where CommunityCode=''"_SearchSql
	d result.Prepare(sqlStr)
	d result.Execute()
	 While(result.Next())
	 {
	  set PersonRowId = result.Get("PersonRowId")
	  set PersonCode = result.Get("PersonCode")
	  set PersonName = result.Get("PersonName")
	  set SexName = result.Get("CTSEX_Desc")
	  set CommunityName = "" //暂时将非本社区的 编码 都置成空
	  s tmp = PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexName_"^"_CommunityName
	  s count=count+1
	  i (count>start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	 }
	  s resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexName^CommunityName",count)
	  k json
	  q resultString
}

/// 1、迁入的时候将保存变更记录，
/// 2、将该个人档案的CommunityCode字段设置为本社区的编码
/// 3、清除个人档案迁出表（PersonRollOut）中该个人档案的相关记录。
ClassMethod PersonRollIn(PersonRowId As %String, CommunityCode As %String) As %String
{
   
	S $zt="ERROR"
	i PersonRowId = "" q ""
	s tempPersonChangeRecord = ##class(CHSS.PersonChangeRecord).%New()
  
	i PersonRowId '= "" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempPersonChangeRecord.PersonRowId=PersonRowIdobj
    s tempPersonChangeRecord.RegisterDate = $P($h,",",1)
    s tempPersonChangeRecord.InOrOut = "迁入"
    s result = ""
    TSTART	        //下面执行 2操作
	&SQL(update CHSS.PersonHealthRecordMain  set CommunityCode=:CommunityCode where PersonRowId=:PersonRowId)
	i SQLCODE=0 d   //下面执行 3操作
	.&SQL(delete from CHSS.PersonRollOut where PersonRowId=:PersonRowId)
	.i SQLCODE=0 d  //下面执行 1操作
	..s result = tempPersonChangeRecord.%Save()	
 i result=1 d
	.TCOMMIT
	.w "{""success"":""true"",""info"":"_tempPersonChangeRecord.%Id()_"}"
	e  d
	.TROLLBACK
	.w "{""success"":""false"",""info"":""迁入出错!!""}"
	q ""
ERROR 	          
 	TROLLBACK 	       
 	W "{""success"":""false"",""info"":""迁入出错!""}"
 	Q ""
}

/// 家庭档案迁出 
/// 1、将家庭档案的CommunityCode清空
/// 2、将该家庭的个人档案的CommunityCode都清空
/// 3、将家庭主键 保存到FamilyRollOut
/// 4、保存变更信息到 FamilyChangeRecord
ClassMethod FamilyRollOut(ReasonNo As %String, FamilyRowId As %String, FamilyCode As %String, CommunityCode As %String, CurCommunity As %String, FamilyAddress As %String, CurAdd As %String, Username As %String, OperatorDate As %Date, Remark As %String) As %String
{
     
     
  	i FamilyRowId = "" q ""  
	s $zt="ERROR"     
	s tempFamilyChangeRecord = ##class(CHSS.FamilyChangeRecord).%New()     
	i FamilyRowId '= "" d
    .s FamilyRowIdobj=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
    .s tempFamilyChangeRecord.FamilyRowId=FamilyRowIdobj
      
   i ReasonNo '= "" d
	.s ReasonNoobj=##class(CHSS.DictChangeReason).%OpenId(ReasonNo)
	.s tempFamilyChangeRecord.FrmChangeSn = ReasonNoobj 	
  
    /// 原家庭编号   
   s tempFamilyChangeRecord.OrgFrmCode = FamilyCode   
    /// 原管辖单位
   s tempFamilyChangeRecord.OrgCommunity = CommunityCode  
    /// 现管辖单位
    s tempFamilyChangeRecord.CurCommunity = CurCommunity   
    /// 原住址
    s tempFamilyChangeRecord.OrgAdd = FamilyAddress  
    /// 现住址
    s tempFamilyChangeRecord.CurAdd = CurAdd
  
    i Username '= "" d
	.s Usernameobj=##class(User.SSUser).%OpenId(Username)
	.s tempFamilyChangeRecord.Operator=Usernameobj
	 
	 i OperatorDate'="" d
	.s OperatorDate=$zdh(OperatorDate,3)
	.s tempFamilyChangeRecord.OperatorDate=OperatorDate
 
   
	s tempFamilyChangeRecord.RegisterDate = $P($h,",",1)
 
	s tempFamilyChangeRecord.Remark = Remark 
 
	s tempFamilyChangeRecord.InOrOut = "迁出"
  
   	TSTART	        //下面执行1操作
	&SQL(update CHSS.FamilyHealthRecord  set CommunityCode='' where FamilyRowId=:FamilyRowId)
 
	i SQLCODE=0 d   //下面执行2操作
	.&SQL(update CHSS.PersonHealthRecordMain  set CommunityCode='' where FamilyRowId=:FamilyRowId)
 	.i (SQLCODE=0)||(SQLCODE=100) d //下面执行 3操作
	..&SQL(insert into CHSS.FamilyRollOut (FamilyRowId) values(:FamilyRowId))
	..i SQLCODE=0 d //下面执行4操作
	...s result = tempFamilyChangeRecord.%Save()
	i result=1 d
	.TCOMMIT
	.w "{""success"":""true"",""info"":"_tempFamilyChangeRecord.%Id()_"}"
	e  d
	.TROLLBACK
	.w "{""success"":""false"",""info"":""数据保存出错!!""}"
	q ""
ERROR 	          
 	TROLLBACK		       
 	W "{""success"":""false"",""info"":""数据保存出错!""}"
 	Q ""
}

/// 1、迁入的时候将保存变更记录，
/// 2、将该家庭档案的CommunityCode字段设置为本社区的编码
/// 3、将该个人档案的CommunityCode字段设置为本社区的编码
/// 4、清除家庭档案迁出表（FamilyRollOut）中该个人档案的相关记录。
ClassMethod FamilyRollIn(FamilyRowId As %String, CommunityCode As %String) As %String
{
   n (FamilyRowId,CommunityCode)
	S $zt="ERROR"
	
	i FamilyRowId = "" q ""
	s tempFamilyChangeRecord = ##class(CHSS.FamilyChangeRecord).%New()
  
	i FamilyRowId '= "" d
    .s FamilyRowIdobj=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
    .s tempFamilyChangeRecord.FamilyRowId=FamilyRowIdobj
    s tempFamilyChangeRecord.RegisterDate = $P($h,",",1)
    s tempFamilyChangeRecord.InOrOut = "迁入"
    s result = ""
    TSTART	         //下面执行2操作
	&SQL(update CHSS.FamilyHealthRecord  set CommunityCode=:CommunityCode where FamilyRowId=:FamilyRowId)
 	i SQLCODE=0 d    //下面执行3操作
	.&SQL(update CHSS.PersonHealthRecordMain  set CommunityCode=:CommunityCode where FamilyRowId=:FamilyRowId)
	.i (SQLCODE=0)||(SQLCODE=100)  d   //下面执行4操作
	..&SQL(delete from CHSS.FamilyRollOut where FamilyRowId=:FamilyRowId)
	..i SQLCODE=0 d  //下面执行1操作
	..s result = tempFamilyChangeRecord.%Save()		
 i result=1 d
	.TCOMMIT
	.w "{""success"":""true"",""info"":"_tempFamilyChangeRecord.%Id()_"}"
	e  d
	.TROLLBACK
	.w "{""success"":""false"",""info"":""迁入出错!!""}"
	q ""
ERROR 	          
 	TROLLBACK 	       
 	W "{""success"":""false"",""info"":""迁入出错!""}"
 	Q ""
}

ClassMethod FamilyRollInList(start As %Integer, limit As %Integer, SearchSql As %String) As %String
{
	  // n (start)
	   
	    Set CommunityCode=$G(communityCode)
		s CommunityCode=" "_CommunityCode
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set FamilyRowId = 0
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where CommunityCode = ''  "_SearchSql
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set FamilyRowId = result.Get("FamilyRowId")
		s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		
		set FamilyCode = tempFamily.FamilyCode
		set DateOfRegister = tempFamily.DateOfRegister	
			
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)
		
		set ProvinceName = ""
		set ProvinceDR = ""
		i tempFamily.ProvinceDR '="" d
		. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		. s ProvinceName = tempFamily.ProvinceDR.Description
	
		
		set CityName=""
		set CityDR=""
		i tempFamily.CityDR '="" d
		. s CityDR = tempFamily.CityDR.%Id()
		. s CityName = tempFamily.CityDR.Description
		
		set SectionName=""
		set SectionDR="" 
		i tempFamily.SectionDR '="" d
		. s SectionDR = tempFamily.SectionDR.%Id()
		. s SectionName = tempFamily.SectionDR.Description
		
		set StreetName=""
		set StreetDR=""
		i tempFamily.StreetDR '="" d
		. s StreetDR=tempFamily.StreetDR.%Id()
		. s StreetName = tempFamily.StreetDR.Description 
		 
		set VillageName =""
		set VillageDR =""
		i tempFamily.VillageDR '="" d
		. s VillageDR = tempFamily.VillageDR.%Id()
		. s VillageName = tempFamily.VillageDR.Description
			
		set HouseHoldName = tempFamily.HouseHoldName
	
		s FamilyAddress = ""
	    i tempFamily.ProvinceDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    i tempFamily.CityDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    i tempFamily.SectionDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    i tempFamily.StreetDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		;i tempFamily.VillageDR '= "" d
	    ;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    i tempFamily.DoorPlate '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	   
	    Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_HouseHoldName_"^"_FamilyAddress
	    
	    Set count=count+1
	    If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^HouseHoldName^FamilyAddress",count)
	 	k json	 	
		Quit resultString
}

Storage Default
{
<Data name="RollInOutServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.RollInOutServiceD</DataLocation>
<DefaultData>RollInOutServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.RollInOutServiceD</IdLocation>
<IndexLocation>^CHSSWeb.RollInOutServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.RollInOutServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
