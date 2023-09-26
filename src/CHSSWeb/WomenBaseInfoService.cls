Class CHSSWeb.WomenBaseInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-08-18
/// Description:妇女档案情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod List(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set CommunityCode=$G(CommunityCode)
      Set CommunityCode=" "_CommunityCode
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set WomanRowId = 0
      Set tmp = ""
      
      
      
      ///For  Set WomanRowId=$O(^CHSS.WomenBaseInfoI("PersonRowIdParrefIndex",PersonRowIdParref,WomanRowId)) q:WomanRowId=""  d
      For  Set WomanRowId=$O(^CHSS.WomenBaseInfoI("CommunityCodeIndex",CommunityCode,WomanRowId)) q:WomanRowId=""  d
      .
      
      .s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      .
      
      .q:tempWomenBaseInfo.FinishIdentifier="true"
       
      ./// 妇女基本信息
      .
      .s PersonName = tempWomenBaseInfo.PersonName
      .s SpellCode = tempWomenBaseInfo.SpellCode
      .s WoAge = tempWomenBaseInfo.WoAge

      .set Birth = tempWomenBaseInfo.Birth
      .i Birth '= "" d
      ..s Birth = $zd(Birth,3)

      .s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
      .s WorkUnit = tempWomenBaseInfo.WorkUnit
      .s TelPhone = tempWomenBaseInfo.TelPhone
      .s CellPhone = tempWomenBaseInfo.CellPhone
      .s Email = tempWomenBaseInfo.Email
      
      .s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
      .s AfMaAddress = tempWomenBaseInfo.AfMaAddress
      .s AftBeAddress = tempWomenBaseInfo.AftBeAddress
      .s bDose = tempWomenBaseInfo.bDose

      .s IdCard = tempWomenBaseInfo.IdCard
      .s Card = tempWomenBaseInfo.Card
      .s CardType = tempWomenBaseInfo.CardType
      .s InHosCode = tempWomenBaseInfo.InHosCode
      
      ./// 丈夫基本信息
      .
      .s HusbandName = tempWomenBaseInfo.HusbandName

      .set HusbandBirth = tempWomenBaseInfo.HusbandBirth
      .i HusbandBirth '= "" d
      ..s HusbandBirth = $zd(HusbandBirth ,3)

      .s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
      .s HusbandTele = tempWomenBaseInfo.HusbandTele
      .s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
      .s HusbandEmail = tempWomenBaseInfo.HusbandEmail
      

      ./// 建册报告
      .
      .set EBPeriodName = ""
      .set EBPeriod = ""
      .i tempWomenBaseInfo.EBPeriod '= "" d
      ..s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
      ..s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

      .s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

      .set EBTime = tempWomenBaseInfo.EBTime
      .i EBTime '= "" d
      ..s EBTime = $zd(EBTime ,3)

      .s EBunit = tempWomenBaseInfo.EBunit
      .s EBbefore = tempWomenBaseInfo.EBbefore
      .s EBnum = tempWomenBaseInfo.EBnum
      .s EBfrontCode = tempWomenBaseInfo.EBfrontCode
      
      ./// 本次填表情况
      .
      .s FinishTable = tempWomenBaseInfo.FinishTable
      
      .set OperatorName = ""
      .set Operator = ""
      .i tempWomenBaseInfo.Operator '= "" d
      ..s Operator = tempWomenBaseInfo.Operator.%Id()
      ..s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

      .set OperateDate = tempWomenBaseInfo.OperateDate
      .i OperateDate '= "" d
      ..s OperateDate = $zd(OperateDate ,3)

      .s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
      .///s CommunityCode = tempWomenBaseInfo.CommunityCode
     
      .i tempWomenBaseInfo.PersonRowIdParref '= "" d
      ..s PersonRowIdParref = tempWomenBaseInfo.PersonRowIdParref.%Id()
      .e  d
	  ..s PersonRowIdParref = ""

      
      .Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref
      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2009-08-18
/// Description:添加妇女档案情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Insert(CommunityCode As %String, PersonRowIdParref As %Integer, PersonName As %String, SpellCode As %String, WoAge As %String, Birth As %Date, WomanHandBookCode As %String, WorkUnit As %String, TelPhone As %String, CellPhone As %String, Email As %String, HusbandName As %String, HusbandBirth As %Date, HusbandWorkUnit As %String, HusbandTele As %String, HusbandMobTele As %String, HusbandEmail As %String, ResidenceAddress As %String, AfMaAddress As %String, AftBeAddress As %String, bDose As %String, IdCard As %String, Card As %String, CardType As %String, InHosCode As %String, EBPeriod As %Integer, EBPeriodDes As %String, EBTime As %Date, EBunit As %String, EBbefore As %String, EBnum As %Integer, EBfrontCode As %Integer, FinishTable As %String, Operator As %Integer, OperateDate As %Date, FinishIdentifier As %String) As %String
{
      s tempWomenBaseInfo=""
      s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%New()
      q:(tempWomenBaseInfo="") 0
      
      s tempWomenBaseInfo.CommunityCode = CommunityCode
            
	  
      i PersonRowIdParref '= "" d
      .s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
      .s tempWomenBaseInfo.PersonRowIdParref=PersonRowIdParrefobj
      

      /// 妇女基本信息
      
      s tempWomenBaseInfo.PersonName = PersonName
      s tempWomenBaseInfo.SpellCode = SpellCode
      s tempWomenBaseInfo.WoAge = WoAge

      i Birth '= "" d
      .s Birth=$zdh(Birth ,3)
      s tempWomenBaseInfo.Birth=Birth

      s tempWomenBaseInfo.WomanHandBookCode = WomanHandBookCode
      s tempWomenBaseInfo.WorkUnit = WorkUnit
      s tempWomenBaseInfo.TelPhone = TelPhone
      s tempWomenBaseInfo.CellPhone = CellPhone
      s tempWomenBaseInfo.Email = Email
      
           
      s tempWomenBaseInfo.ResidenceAddress = ResidenceAddress
      s tempWomenBaseInfo.AfMaAddress = AfMaAddress
      s tempWomenBaseInfo.AftBeAddress = AftBeAddress
      s tempWomenBaseInfo.bDose = bDose
            
      s tempWomenBaseInfo.IdCard = IdCard
      s tempWomenBaseInfo.Card = Card
      s tempWomenBaseInfo.CardType = CardType
      s tempWomenBaseInfo.InHosCode = InHosCode
      
      /// 丈夫基本信息
      
      s tempWomenBaseInfo.HusbandName = HusbandName

      i HusbandBirth '= "" d
      .s HusbandBirth=$zdh(HusbandBirth,3)
      s tempWomenBaseInfo.HusbandBirth=HusbandBirth

      s tempWomenBaseInfo.HusbandWorkUnit = HusbandWorkUnit
      s tempWomenBaseInfo.HusbandTele = HusbandTele
      s tempWomenBaseInfo.HusbandMobTele = HusbandMobTele
      s tempWomenBaseInfo.HusbandEmail = HusbandEmail
           
      
      /// 建册报告
      
      i EBPeriod '= "" d
      .s EBPeriodobj=##class(CHSS.DictWomenBookTime).%OpenId(EBPeriod)
      .s tempWomenBaseInfo.EBPeriod=EBPeriodobj
      
      s tempWomenBaseInfo.EBPeriodDes = EBPeriodDes

      i EBTime '= "" d
      .s EBTime=$zdh(EBTime,3)
      s tempWomenBaseInfo.EBTime=EBTime

      s tempWomenBaseInfo.EBunit = EBunit
      s tempWomenBaseInfo.EBbefore = EBbefore
      s tempWomenBaseInfo.EBnum = EBnum
      s tempWomenBaseInfo.EBfrontCode = EBfrontCode
      
      /// 本次填表情况
      
      s tempWomenBaseInfo.FinishTable = FinishTable
      
      ///i Operator '= "" d
      .///s Operatorobj=##class(User.SSUser).%OpenId(Operator)
      .///s tempWomenBaseInfo.Operator=Operatorobj

      i OperateDate'= "" d
      .s OperateDate=$zdh(OperateDate,3)
      s tempWomenBaseInfo.OperateDate=OperateDate

      s tempWomenBaseInfo.FinishIdentifier = FinishIdentifier
      
        
      s result=""
      s result=tempWomenBaseInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWomenBaseInfo.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWomenBaseInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-08-18
/// Description:更新妇女档案情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Update(WomanRowId As %Integer, PersonRowIdParref As %Integer, PersonName As %String, SpellCode As %String, WoAge As %String, Birth As %Date, WomanHandBookCode As %String, WorkUnit As %String, TelPhone As %String, CellPhone As %String, Email As %String, HusbandName As %String, HusbandBirth As %Date, HusbandWorkUnit As %String, HusbandTele As %String, HusbandMobTele As %String, HusbandEmail As %String, ResidenceAddress As %String, AfMaAddress As %String, AftBeAddress As %String, bDose As %String, IdCard As %String, Card As %String, CardType As %String, InHosCode As %String, EBPeriod As %Integer, EBPeriodDes As %String, EBTime As %Date, EBunit As %String, EBbefore As %String, EBnum As %Integer, EBfrontCode As %Integer, FinishTable As %String, Operator As %Integer, OperateDate As %Date, FinishIdentifier As %String) As %String
{
  
      q:($d(WomanRowId)=0)||(WomanRowId="")
      
      s tempWomenBaseInfo="",result=""
      s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      q:(tempWomenBaseInfo="") 0
      
      i PersonRowIdParref '= "" d
      .s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
      .s tempWomenBaseInfo.PersonRowIdParref=PersonRowIdParrefobj
       
      
      /// 妇女基本信息
      
      s tempWomenBaseInfo.PersonName = PersonName
      s tempWomenBaseInfo.SpellCode = SpellCode
      s tempWomenBaseInfo.WoAge = WoAge

      i Birth '= "" d
      .s Birth=$zdh(Birth ,3)
      s tempWomenBaseInfo.Birth=Birth

      s tempWomenBaseInfo.WomanHandBookCode = WomanHandBookCode
      s tempWomenBaseInfo.WorkUnit = WorkUnit
      s tempWomenBaseInfo.TelPhone = TelPhone
      s tempWomenBaseInfo.CellPhone = CellPhone
      s tempWomenBaseInfo.Email = Email
            
      s tempWomenBaseInfo.ResidenceAddress = ResidenceAddress
      s tempWomenBaseInfo.AfMaAddress = AfMaAddress
      s tempWomenBaseInfo.AftBeAddress = AftBeAddress
      s tempWomenBaseInfo.bDose = bDose
            
      s tempWomenBaseInfo.IdCard = IdCard
      s tempWomenBaseInfo.Card = Card
      s tempWomenBaseInfo.CardType = CardType
      s tempWomenBaseInfo.InHosCode = InHosCode
      
      /// 丈夫基本信息
      
      s tempWomenBaseInfo.HusbandName = HusbandName

      i HusbandBirth '= "" d
      .s HusbandBirth=$zdh(HusbandBirth,3)
      s tempWomenBaseInfo.HusbandBirth=HusbandBirth

      s tempWomenBaseInfo.HusbandWorkUnit = HusbandWorkUnit
      s tempWomenBaseInfo.HusbandTele = HusbandTele
      s tempWomenBaseInfo.HusbandMobTele = HusbandMobTele
      s tempWomenBaseInfo.HusbandEmail = HusbandEmail
           
      
      /// 建册报告
      
      i EBPeriod '= "" d
      .s EBPeriodobj=##class(CHSS.DictWomenBookTime).%OpenId(EBPeriod)
      .s tempWomenBaseInfo.EBPeriod=EBPeriodobj
      
      s tempWomenBaseInfo.EBPeriodDes = EBPeriodDes

      i EBTime '= "" d
      .s EBTime=$zdh(EBTime,3)
      s tempWomenBaseInfo.EBTime=EBTime

      s tempWomenBaseInfo.EBunit = EBunit
      s tempWomenBaseInfo.EBbefore = EBbefore
      s tempWomenBaseInfo.EBnum = EBnum
      s tempWomenBaseInfo.EBfrontCode = EBfrontCode
      
      /// 本次填表情况
      
      s tempWomenBaseInfo.FinishTable = FinishTable
      
      ///i Operator '= "" d
      .///s Operatorobj=##class(User.SSUser).%OpenId(Operator)
      .///s tempWomenBaseInfo.Operator=Operatorobj

      i OperateDate'= "" d
      .s OperateDate=$zdh(OperateDate,3)
      s tempWomenBaseInfo.OperateDate=OperateDate

      s tempWomenBaseInfo.FinishIdentifier = FinishIdentifier
      ///s tempWomenBaseInfo.CommunityCode = CommunityCode
        
        
      s result=""
      s result=tempWomenBaseInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_WomanRowId_"}"
      .///w "{""success"":""true"",""info"":"_WomanRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-04
/// Description:妇女档案情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod ListWoman(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select WomanRowId from CHSS.WomenBaseInfo where PersonRowIdParref="_PersonRowIdParref
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
          
      
      s WomanRowId = result.Data("WomanRowId")     
      
      
      
     s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
     
     
     q:tempWomenBaseInfo.FinishIdentifier="true"
     
     /// 妇女基本信息
     
     s PersonName = tempWomenBaseInfo.PersonName
     s SpellCode = tempWomenBaseInfo.SpellCode
     s WoAge = tempWomenBaseInfo.WoAge

     set Birth = tempWomenBaseInfo.Birth
     i Birth '= "" d
     .s Birth = $zd(Birth,3)

     s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
     s WorkUnit = tempWomenBaseInfo.WorkUnit
     s TelPhone = tempWomenBaseInfo.TelPhone
     s CellPhone = tempWomenBaseInfo.CellPhone
     s Email = tempWomenBaseInfo.Email
     
     s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
     s AfMaAddress = tempWomenBaseInfo.AfMaAddress
     s AftBeAddress = tempWomenBaseInfo.AftBeAddress
     s bDose = tempWomenBaseInfo.bDose

     s IdCard = tempWomenBaseInfo.IdCard
     s Card = tempWomenBaseInfo.Card
     s CardType = tempWomenBaseInfo.CardType
     s InHosCode = tempWomenBaseInfo.InHosCode
     
     /// 丈夫基本信息
     
     s HusbandName = tempWomenBaseInfo.HusbandName

     set HusbandBirth = tempWomenBaseInfo.HusbandBirth
     i HusbandBirth '= "" d
     .s HusbandBirth = $zd(HusbandBirth ,3)

     s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
     s HusbandTele = tempWomenBaseInfo.HusbandTele
     s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
     s HusbandEmail = tempWomenBaseInfo.HusbandEmail
     

     /// 建册报告
     
     set EBPeriodName = ""
     set EBPeriod = ""
     i tempWomenBaseInfo.EBPeriod '= "" d
     .s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
     .s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

     s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

     set EBTime = tempWomenBaseInfo.EBTime
     i EBTime '= "" d
     .s EBTime = $zd(EBTime ,3)

     s EBunit = tempWomenBaseInfo.EBunit
     s EBbefore = tempWomenBaseInfo.EBbefore
     s EBnum = tempWomenBaseInfo.EBnum
     s EBfrontCode = tempWomenBaseInfo.EBfrontCode
     
     /// 本次填表情况
     
     s FinishTable = tempWomenBaseInfo.FinishTable
     
     set OperatorName = ""
     set Operator = ""
     i tempWomenBaseInfo.Operator '= "" d
     .s Operator = tempWomenBaseInfo.Operator.%Id()
     .s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

     set OperateDate = tempWomenBaseInfo.OperateDate
     i OperateDate '= "" d
     .s OperateDate = $zd(OperateDate ,3)

     s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
     ///s CommunityCode = tempWomenBaseInfo.CommunityCode

     
     Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref
      

       s count = count+1
	   i (count>start)&(count<=end) d
	   .d json.InsertRowData(tmp)
	  
      
     }
     
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-05
/// Description:妇女档案归档情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod ListArc(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select WomanRowId from CHSS.WomenBaseInfo where CommunityCode="_CommunityCode
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
          
      
      s WomanRowId = result.Data("WomanRowId")     
      
      
      
     s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
     
     
     ;q:tempWomenBaseInfo.FinishIdentifier="true"
     
     /// 妇女基本信息
     
     s PersonName = tempWomenBaseInfo.PersonName
     s SpellCode = tempWomenBaseInfo.SpellCode
     s WoAge = tempWomenBaseInfo.WoAge

     set Birth = tempWomenBaseInfo.Birth
     i Birth '= "" d
     .s Birth = $zd(Birth,3)

     s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
     s WorkUnit = tempWomenBaseInfo.WorkUnit
     s TelPhone = tempWomenBaseInfo.TelPhone
     s CellPhone = tempWomenBaseInfo.CellPhone
     s Email = tempWomenBaseInfo.Email
     
     s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
     s AfMaAddress = tempWomenBaseInfo.AfMaAddress
     s AftBeAddress = tempWomenBaseInfo.AftBeAddress
     s bDose = tempWomenBaseInfo.bDose

     s IdCard = tempWomenBaseInfo.IdCard
     s Card = tempWomenBaseInfo.Card
     s CardType = tempWomenBaseInfo.CardType
     s InHosCode = tempWomenBaseInfo.InHosCode
     
     /// 丈夫基本信息
     
     s HusbandName = tempWomenBaseInfo.HusbandName

     set HusbandBirth = tempWomenBaseInfo.HusbandBirth
     i HusbandBirth '= "" d
     .s HusbandBirth = $zd(HusbandBirth ,3)

     s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
     s HusbandTele = tempWomenBaseInfo.HusbandTele
     s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
     s HusbandEmail = tempWomenBaseInfo.HusbandEmail
     

     /// 建册报告
     
     set EBPeriodName = ""
     set EBPeriod = ""
     i tempWomenBaseInfo.EBPeriod '= "" d
     .s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
     .s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

     s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

     set EBTime = tempWomenBaseInfo.EBTime
     i EBTime '= "" d
     .s EBTime = $zd(EBTime ,3)

     s EBunit = tempWomenBaseInfo.EBunit
     s EBbefore = tempWomenBaseInfo.EBbefore
     s EBnum = tempWomenBaseInfo.EBnum
     s EBfrontCode = tempWomenBaseInfo.EBfrontCode
     
     /// 本次填表情况
     
     s FinishTable = tempWomenBaseInfo.FinishTable
     
     set OperatorName = ""
     set Operator = ""
     i tempWomenBaseInfo.Operator '= "" d
     .s Operator = tempWomenBaseInfo.Operator.%Id()
     .s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

     set OperateDate = tempWomenBaseInfo.OperateDate
     i OperateDate '= "" d
     .s OperateDate = $zd(OperateDate ,3)

     s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
     ///s CommunityCode = tempWomenBaseInfo.CommunityCode
     
	 s ArcStatus = ""
	 i FinishIdentifier = "" d
	 .s ArcStatus = "<font color=green><b>未归档</b></font>"
	 i FinishIdentifier '= "" d
	 .i FinishIdentifier = "true" d
	 ..s ArcStatus = "<font color=red><b>已归档</b></font>"
	 .e  d
	 ..s ArcStatus = "<font color=green><b>未归档</b></font>"
     
     i tempWomenBaseInfo.PersonRowIdParref '= "" d
     .s PersonRowIdParref = tempWomenBaseInfo.PersonRowIdParref.%Id()
     

     
     Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref_"^"_ArcStatus
      

       s count = count+1
	   i (count>start)&(count<=end) d
	   .d json.InsertRowData(tmp)
	  
      
     }
     
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref^ArcStatus",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-05-
/// Description:妇女档案归档
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod EditArcStatus(WomanRowId As %Integer) As %String
{
      &sql(update CHSS.WomenBaseInfo set FinishIdentifier = 'true' where %ID=:WomanRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_WomanRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据归档出错!""}"
      
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-05
/// Description:妇女档案归档情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod ListArcName(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, PersonName As %String) As %String
{
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select WomanRowId from CHSS.WomenBaseInfo where CommunityCode="_CommunityCode_" and PersonName like '%"_PersonName_"%'"
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
          
      
      s WomanRowId = result.Data("WomanRowId")     
      
                  
     s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
     
     
     ;q:tempWomenBaseInfo.FinishIdentifier="true"
     
     /// 妇女基本信息
     
     s PersonName = tempWomenBaseInfo.PersonName
     s SpellCode = tempWomenBaseInfo.SpellCode
     s WoAge = tempWomenBaseInfo.WoAge

     set Birth = tempWomenBaseInfo.Birth
     i Birth '= "" d
     .s Birth = $zd(Birth,3)

     s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
     s WorkUnit = tempWomenBaseInfo.WorkUnit
     s TelPhone = tempWomenBaseInfo.TelPhone
     s CellPhone = tempWomenBaseInfo.CellPhone
     s Email = tempWomenBaseInfo.Email
     
     s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
     s AfMaAddress = tempWomenBaseInfo.AfMaAddress
     s AftBeAddress = tempWomenBaseInfo.AftBeAddress
     s bDose = tempWomenBaseInfo.bDose

     s IdCard = tempWomenBaseInfo.IdCard
     s Card = tempWomenBaseInfo.Card
     s CardType = tempWomenBaseInfo.CardType
     s InHosCode = tempWomenBaseInfo.InHosCode
     
     /// 丈夫基本信息
     
     s HusbandName = tempWomenBaseInfo.HusbandName

     set HusbandBirth = tempWomenBaseInfo.HusbandBirth
     i HusbandBirth '= "" d
     .s HusbandBirth = $zd(HusbandBirth ,3)

     s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
     s HusbandTele = tempWomenBaseInfo.HusbandTele
     s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
     s HusbandEmail = tempWomenBaseInfo.HusbandEmail
     

     /// 建册报告
     
     set EBPeriodName = ""
     set EBPeriod = ""
     i tempWomenBaseInfo.EBPeriod '= "" d
     .s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
     .s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

     s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

     set EBTime = tempWomenBaseInfo.EBTime
     i EBTime '= "" d
     .s EBTime = $zd(EBTime ,3)

     s EBunit = tempWomenBaseInfo.EBunit
     s EBbefore = tempWomenBaseInfo.EBbefore
     s EBnum = tempWomenBaseInfo.EBnum
     s EBfrontCode = tempWomenBaseInfo.EBfrontCode
     
     /// 本次填表情况
     
     s FinishTable = tempWomenBaseInfo.FinishTable
     
     set OperatorName = ""
     set Operator = ""
     i tempWomenBaseInfo.Operator '= "" d
     .s Operator = tempWomenBaseInfo.Operator.%Id()
     .s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

     set OperateDate = tempWomenBaseInfo.OperateDate
     i OperateDate '= "" d
     .s OperateDate = $zd(OperateDate ,3)

     s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
     ///s CommunityCode = tempWomenBaseInfo.CommunityCode
     
	 s ArcStatus = ""
	 i FinishIdentifier = "" d
	 .s ArcStatus = "<font color=green><b>未归档</b></font>"
	 i FinishIdentifier '= "" d
	 .i FinishIdentifier = "true" d
	 ..s ArcStatus = "<font color=red><b>已归档</b></font>"
	 .e  d
	 ..s ArcStatus = "<font color=green><b>未归档</b></font>"
     
     i tempWomenBaseInfo.PersonRowIdParref '= "" d
     .s PersonRowIdParref = tempWomenBaseInfo.PersonRowIdParref.%Id()
     

     
     Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref_"^"_ArcStatus
      

       s count = count+1
	   i (count>start)&(count<=end) d
	   .d json.InsertRowData(tmp)
	  
      
     }
     
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref^ArcStatus",count)
      k json
      d result.Close()
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-05-
/// Description: 妇女统计信息
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ListChart(CommunityCode As %String, StatType As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
    s AllArcNum=0
    s result = ##class(%Library.ResultSet).%New()
    
        
    if StatType="EducationDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where EducationDR is not null and CommunityCode ="_CommunityCode_" "_whereStr
    e  i StatType="ProfessionDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where ProfessionDR is not null and CommunityCode ="_CommunityCode_" "_whereStr
    
        
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s AllArcNum=result.Data("Num")
    }
    
    d result.Close()
    
    
    
    set StatName=0
    set ArcNum=0
    set PerNum=0
	
    s result = ##class(%Library.ResultSet).%New()
    
    if StatType="EducationDR" d
	.s sqlStr = "select EducationDR->EDU_Desc As StatName, count(EducationDR->EDU_Desc) ArcNum, ROUND(100*count(EducationDR->EDU_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where EducationDR is not null  and CommunityCode ="_CommunityCode_" "_whereStr_" group by EducationDR->EDU_Desc"
	e  i StatType="ProfessionDR" d
	.s sqlStr = "select ProfessionDR->CTOCC_Desc As StatName, count(ProfessionDR->CTOCC_Desc) ArcNum, ROUND(100*count(ProfessionDR->CTOCC_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where ProfessionDR is not null  and CommunityCode ="_CommunityCode_" "_whereStr_" group by ProfessionDR->CTOCC_Desc"
	     
				
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s StatName=result.Data("StatName")
		s ArcNum=result.Data("ArcNum")
		s PerNum=result.Data("PerNum")
		
		Set tmp = StatName_"^"_ArcNum_"^"_PerNum
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
  
    
     
    Set resultString = json.getJsonData("StatName^ArcNum^PerNum",count)
    k json
      
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06
/// Description:妇女档案归档情况
/// Table：WomenBaseInfo
/// Input: WomenBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod ListWomanSearch(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select WomanRowId from CHSS.WomenBaseInfo where CommunityCode="_CommunityCode_" "_whereStr_" and FinishIdentifier is null"
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
          
      
      s WomanRowId = result.Data("WomanRowId")     
      
                  
     s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
     
     
     ;q:tempWomenBaseInfo.FinishIdentifier="true"
     
     /// 妇女基本信息
     
     s PersonName = tempWomenBaseInfo.PersonName
     s SpellCode = tempWomenBaseInfo.SpellCode
     s WoAge = tempWomenBaseInfo.WoAge

     set Birth = tempWomenBaseInfo.Birth
     i Birth '= "" d
     .s Birth = $zd(Birth,3)

     s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
     s WorkUnit = tempWomenBaseInfo.WorkUnit
     s TelPhone = tempWomenBaseInfo.TelPhone
     s CellPhone = tempWomenBaseInfo.CellPhone
     s Email = tempWomenBaseInfo.Email
     
     s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
     s AfMaAddress = tempWomenBaseInfo.AfMaAddress
     s AftBeAddress = tempWomenBaseInfo.AftBeAddress
     s bDose = tempWomenBaseInfo.bDose

     s IdCard = tempWomenBaseInfo.IdCard
     s Card = tempWomenBaseInfo.Card
     s CardType = tempWomenBaseInfo.CardType
     s InHosCode = tempWomenBaseInfo.InHosCode
     
     /// 丈夫基本信息
     
     s HusbandName = tempWomenBaseInfo.HusbandName

     set HusbandBirth = tempWomenBaseInfo.HusbandBirth
     i HusbandBirth '= "" d
     .s HusbandBirth = $zd(HusbandBirth ,3)

     s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
     s HusbandTele = tempWomenBaseInfo.HusbandTele
     s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
     s HusbandEmail = tempWomenBaseInfo.HusbandEmail
     

     /// 建册报告
     
     set EBPeriodName = ""
     set EBPeriod = ""
     i tempWomenBaseInfo.EBPeriod '= "" d
     .s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
     .s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

     s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

     set EBTime = tempWomenBaseInfo.EBTime
     i EBTime '= "" d
     .s EBTime = $zd(EBTime ,3)

     s EBunit = tempWomenBaseInfo.EBunit
     s EBbefore = tempWomenBaseInfo.EBbefore
     s EBnum = tempWomenBaseInfo.EBnum
     s EBfrontCode = tempWomenBaseInfo.EBfrontCode
     
     /// 本次填表情况
     
     s FinishTable = tempWomenBaseInfo.FinishTable
     
     set OperatorName = ""
     set Operator = ""
     i tempWomenBaseInfo.Operator '= "" d
     .s Operator = tempWomenBaseInfo.Operator.%Id()
     .s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

     set OperateDate = tempWomenBaseInfo.OperateDate
     i OperateDate '= "" d
     .s OperateDate = $zd(OperateDate ,3)

     s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
     ///s CommunityCode = tempWomenBaseInfo.CommunityCode
     
	
     
     i tempWomenBaseInfo.PersonRowIdParref '= "" d
     .s PersonRowIdParref = tempWomenBaseInfo.PersonRowIdParref.%Id()
     

     
     Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref
      

       s count = count+1
	   i (count>start)&(count<=end) d
	   .d json.InsertRowData(tmp)
	  
      
     }
     
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref",count)
      k json
      d result.Close()
      
      Quit resultString
}

ClassMethod ListWomanEBDate(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select WomanRowIdParref as WomanRowId, EstimateBDate from CHSS.WomenFirstCheck where WomanRowIdParref->CommunityCode="_CommunityCode_" "_whereStr_" and EstimateBDate is not null"
    
    
    
    d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set tmp = ""
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
          
      
     s WomanRowId = result.Data("WomanRowId")     
      
                  
     s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
     
     
     ;q:tempWomenBaseInfo.FinishIdentifier="true"
     
     /// 妇女基本信息
     
     s PersonName = tempWomenBaseInfo.PersonName
     s SpellCode = tempWomenBaseInfo.SpellCode
     s WoAge = tempWomenBaseInfo.WoAge

     set Birth = tempWomenBaseInfo.Birth
     i Birth '= "" d
     .s Birth = $zd(Birth,3)

     s WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
     s WorkUnit = tempWomenBaseInfo.WorkUnit
     s TelPhone = tempWomenBaseInfo.TelPhone
     s CellPhone = tempWomenBaseInfo.CellPhone
     s Email = tempWomenBaseInfo.Email
     
     s ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
     s AfMaAddress = tempWomenBaseInfo.AfMaAddress
     s AftBeAddress = tempWomenBaseInfo.AftBeAddress
     s bDose = tempWomenBaseInfo.bDose

     s IdCard = tempWomenBaseInfo.IdCard
     s Card = tempWomenBaseInfo.Card
     s CardType = tempWomenBaseInfo.CardType
     s InHosCode = tempWomenBaseInfo.InHosCode
     
     /// 丈夫基本信息
     
     s HusbandName = tempWomenBaseInfo.HusbandName

     set HusbandBirth = tempWomenBaseInfo.HusbandBirth
     i HusbandBirth '= "" d
     .s HusbandBirth = $zd(HusbandBirth ,3)

     s HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
     s HusbandTele = tempWomenBaseInfo.HusbandTele
     s HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
     s HusbandEmail = tempWomenBaseInfo.HusbandEmail
     

     /// 建册报告
     
     set EBPeriodName = ""
     set EBPeriod = ""
     i tempWomenBaseInfo.EBPeriod '= "" d
     .s EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
     .s EBPeriodName = tempWomenBaseInfo.EBPeriod.Description

     s EBPeriodDes = tempWomenBaseInfo.EBPeriodDes

     set EBTime = tempWomenBaseInfo.EBTime
     i EBTime '= "" d
     .s EBTime = $zd(EBTime ,3)

     s EBunit = tempWomenBaseInfo.EBunit
     s EBbefore = tempWomenBaseInfo.EBbefore
     s EBnum = tempWomenBaseInfo.EBnum
     s EBfrontCode = tempWomenBaseInfo.EBfrontCode
     
     /// 本次填表情况
     
     s FinishTable = tempWomenBaseInfo.FinishTable
     
     set OperatorName = ""
     set Operator = ""
     i tempWomenBaseInfo.Operator '= "" d
     .s Operator = tempWomenBaseInfo.Operator.%Id()
     .s OperatorName = tempWomenBaseInfo.Operator.SSUSRName

     set OperateDate = tempWomenBaseInfo.OperateDate
     i OperateDate '= "" d
     .s OperateDate = $zd(OperateDate ,3)

     s FinishIdentifier = tempWomenBaseInfo.FinishIdentifier
     ///s CommunityCode = tempWomenBaseInfo.CommunityCode
     
	 
     
     i tempWomenBaseInfo.PersonRowIdParref '= "" d
     .s PersonRowIdParref = tempWomenBaseInfo.PersonRowIdParref.%Id()
     
     s EstimateBDate = result.Data("EstimateBDate")
     i EstimateBDate '= "" d
     .s EstimateBDate = $zd(EstimateBDate ,3)
     
     Set tmp = WomanRowId_"^"_PersonName_"^"_SpellCode_"^"_WoAge_"^"_Birth_"^"_WomanHandBookCode_"^"_WorkUnit_"^"_TelPhone_"^"_CellPhone_"^"_Email_"^"_HusbandName_"^"_HusbandBirth_"^"_HusbandWorkUnit_"^"_HusbandTele_"^"_HusbandMobTele_"^"_HusbandEmail_"^"_ResidenceAddress_"^"_AfMaAddress_"^"_AftBeAddress_"^"_bDose_"^"_IdCard_"^"_Card_"^"_CardType_"^"_InHosCode_"^"_EBPeriod_"^"_EBPeriodName_"^"_EBPeriodDes_"^"_EBTime_"^"_EBunit_"^"_EBbefore_"^"_EBnum_"^"_EBfrontCode_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateDate_"^"_FinishIdentifier_"^"_PersonRowIdParref_"^"_EstimateBDate
      

       s count = count+1
	   i (count>start)&(count<=end) d
	   .d json.InsertRowData(tmp)
	  
      
     }
     
      
      Set resultString = json.getJsonData("WomanRowId^PersonName1^SpellCode1^WoAge^Birth1^WomanHandBookCode^WorkUnit^TelPhone^CellPhone^Email^HusbandName^HusbandBirth^HusbandWorkUnit^HusbandTele^HusbandMobTele^HusbandEmail^ResidenceAddress^AfMaAddress^AftBeAddress^bDose^IdCard^Card^CardType^InHosCode^EBPeriod^EBPeriodName^EBPeriodDes^EBTime^EBunit^EBbefore^EBnum^EBfrontCode^FinishTable^Operator^OperatorName^OperateDate^FinishIdentifier^PersonRowIdParref^EstimateBDate",count)
      k json
      d result.Close()
      
      Quit resultString
}

ClassMethod PersonSearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	
		//q:searchField=""
		//q:searchValue=""
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s sqlStr = ""
		s result = ##class(%Library.ResultSet).%New()
		;s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3 "_whereStr
		
		
		i start=0 d
		.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3 "_whereStr
		e  d
		.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  and "_searchField_" like '%"_searchValue_"%'"
		
		;绵阳检索不限制社区
		;i start=0 d
		;.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3 "_whereStr
		;e  d
		;.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3 "_whereStr
		
		;w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set PersonRowId = result.Get("PersonRowId")
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		;个人编码
		set PersonCode = tempPerson.PersonCode
		;姓名
		set PersonName = tempPerson.PersonName
		;性别
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		;出生日期
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		.
		.
		.
		;个人状态
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		;拼音码
		set SpellCode = tempPerson.SpellCode
		;卡号
		set CardNumber = tempPerson.CardNumber
		;身份证号
		set IDCard = tempPerson.IDCard
		;登记日期
		s DateRegister = tempPerson.DateRegister
	    i DateRegister '= "" d
		.s DateRegister=$zd(DateRegister,3)
		;录入日期
		s DateInput = tempPerson.DateInput
	    i DateInput '= "" d
		.s DateInput=$zd(DateInput,3)
		;与户主关系
		s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		
		set RelationHourseHoldDR = ""
		set RelationHourseHoldName = ""
		i tempPerson.RelationHourseHoldDR '= "" d
		.set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		.set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		;负责医生
		set DoctorName = ""
		set DoctorRegister = ""
		i tempPerson.DoctorRegister '= "" d
		.s DoctorRegister = tempPerson.DoctorRegister
		.s DoctorName = tempPerson.DoctorRegister
		;操作人员
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.s OperatorInput = tempPerson.OperatorInput.%Id()
		.s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		;家庭编号
		s FamilyRowId = ""
		s HouseHoldName = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		;户主姓名
		s HouseHoldDR = ""
		S HouseHoldDRName = ""
		i tempPerson.HouseHoldTypeDR '= "" d
		.s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		.s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		
		
		s NationDR = ""
		S NationDRName = ""
		i tempPerson.NationDR '= "" d
		.s NationDR =tempPerson.NationDR.%Id()
		.s NationDRName = tempPerson.NationDR.CTNATDesc
		.
		
		.
		s MarriageDR = ""
		S MarriageDRName = ""
		i tempPerson.MarriageDR '= "" d
		.s MarriageDR =tempPerson.MarriageDR.%Id()
		.s MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		.
		.
		.
		s EducationDR = ""
		S EducationDRName = ""
		i tempPerson.EducationDR '= "" d
		.s EducationDR =tempPerson.EducationDR.%Id()
		.s EducationDRName = tempPerson.EducationDR.EDUDesc
		.
		.
		
		&sql(select Max(DateOfCheck), Checker into :DateOfCheck, :Checker from CHSS.WomenGeneralSurvey where PersonRowId= :PersonRowId)
		i SQLCODE '= 0 d
		.s DateOfCheck=""
		.s Checker=""
		
		i DateOfCheck '= "" d
		.s DateOfCheck=$zd(DateOfCheck,3)
		
	    s FamilyAddress = ""
	    ;家庭地址
	    i FamilyRowId '= "" d
	    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.i tempFamily.VillageDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .e  d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate

	    s Address = tempPerson.Address
	    
	    s LinkManName = tempPerson.LinkManName
		s LinkManPhone = tempPerson.LinkManPhone
		s PersonEmail = tempPerson.PersonEmail
		;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
	   
	    ;modify by wangbo 2009-12-08
	    Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone
		set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard_"^"_NationDR_"^"_NationDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_DateOfCheck_"^"_Checker

	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard^NationDR^NationDRName^MarriageDR^MarriageDRName^EducationDR^EducationDRName^DateOfCheck^Checker",count)
	 	k json
	 	
		Quit resultString
}

Storage Default
{
<Data name="WomenBaseInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomenBaseInfoServiceD</DataLocation>
<DefaultData>WomenBaseInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomenBaseInfoServiceD</IdLocation>
<IndexLocation>^CHSSWeb.WomenBaseInfoServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.WomenBaseInfoServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
