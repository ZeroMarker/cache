Class CHSSWeb.CommunityBaseInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-01-
/// Description: 社区档案
/// Table：CommunityBaseInfo
/// Input: CommunityBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod List(CommunityRowidId As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set CommunityRowidId=$G(CommunityRowidId)
      //Set CommunityCode=" "_CommunityCode
      q:CommunityRowidId="" ""
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set CommunityRowId =CommunityRowidId
      Set tmp = ""
       
      
      
      
      s tempCommunityBaseInfo=##class(CHSS.CommunityBaseInfo).%OpenId(CommunityRowidId)

      /// 基本信息
      s CommunityCode=tempCommunityBaseInfo.CommunityCode
      s CommunityName=tempCommunityBaseInfo.CommunityName
      s CommunityAddress=tempCommunityBaseInfo.CommunityAddress
      s LinkMan=tempCommunityBaseInfo.LinkMan
      s LinkPhone=tempCommunityBaseInfo.LinkPhone
      s Post=tempCommunityBaseInfo.Post
      s Area=tempCommunityBaseInfo.Area
      s TotalFamilyNum=tempCommunityBaseInfo.TotalFamilyNum
      s TotalPersonNum=tempCommunityBaseInfo.TotalPersonNum
      s ResidentPersonNum=tempCommunityBaseInfo.ResidentPersonNum
      s MaleNum=tempCommunityBaseInfo.MaleNum
      s FemaleNum=tempCommunityBaseInfo.FemaleNum
      s OverSixtyNum=tempCommunityBaseInfo.OverSixtyNum
      s BelowSevenNum=tempCommunityBaseInfo.BelowSevenNum
      s BirthFemaleNum=tempCommunityBaseInfo.BirthFemaleNum
      s PreYearBirth=tempCommunityBaseInfo.PreYearBirth
      s PreYearDead=tempCommunityBaseInfo.PreYearDead
      s GrowRate=tempCommunityBaseInfo.GrowRate
      s FluxionNum=tempCommunityBaseInfo.FluxionNum
      s OrganNum=tempCommunityBaseInfo.OrganNum
      s CorNum=tempCommunityBaseInfo.CorNum
      s GradeSchoolNum=tempCommunityBaseInfo.GradeSchoolNum
      s JuniorCollegeNum=tempCommunityBaseInfo.JuniorCollegeNum
      s InfantOrg=tempCommunityBaseInfo.InfantOrg
      s HosOrg=tempCommunityBaseInfo.HosOrg
      s RVNum=tempCommunityBaseInfo.RVNum
      s MarketPlace=tempCommunityBaseInfo.MarketPlace
      s HotelNum=tempCommunityBaseInfo.HotelNum
      s FoodIndustryNum=tempCommunityBaseInfo.FoodIndustryNum
      s TNBNum=tempCommunityBaseInfo.TNBNum
      s GXYNum=tempCommunityBaseInfo.GXYNum
      s CHDNum=tempCommunityBaseInfo.CHDNum
      s NZZNum=tempCommunityBaseInfo.NZZNum
      s EXZLNum=tempCommunityBaseInfo.EXZLNum
      s JSBNum=tempCommunityBaseInfo.JSBNum
      s CJRNum=tempCommunityBaseInfo.CJRNum
      s Year = tempCommunityBaseInfo.Year
           
      Set tmp = CommunityRowId_"^"_CommunityCode_"^"_CommunityName_"^"_CommunityAddress_"^"_LinkMan_"^"_LinkPhone_"^"_Post_"^"_Area_"^"_TotalFamilyNum_"^"_TotalPersonNum_"^"_ResidentPersonNum_"^"_MaleNum_"^"_FemaleNum_"^"_OverSixtyNum_"^"_BelowSevenNum_"^"_BirthFemaleNum_"^"_PreYearBirth_"^"_PreYearDead_"^"_GrowRate_"^"_FluxionNum_"^"_OrganNum_"^"_CorNum_"^"_GradeSchoolNum_"^"_JuniorCollegeNum_"^"_InfantOrg_"^"_HosOrg_"^"_RVNum_"^"_MarketPlace_"^"_HotelNum_"^"_FoodIndustryNum_"^"_TNBNum_"^"_GXYNum_"^"_CHDNum_"^"_NZZNum_"^"_EXZLNum_"^"_JSBNum_"^"_CJRNum_"^"_Year


      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
      
      
      Set resultString = json.getJsonData("CommunityRowId^CommunityCode^CommunityName^CommunityAddress^LinkMan^LinkPhone^Post^Area^TotalFamilyNum^TotalPersonNum^ResidentPersonNum^MaleNum^FemaleNum^OverSixtyNum^BelowSevenNum^BirthFemaleNum^PreYearBirth^PreYearDead^GrowRate^FluxionNum^OrganNum^CorNum^GradeSchoolNum^JuniorCollegeNum^InfantOrg^HosOrg^RVNum^MarketPlace^HotelNum^FoodIndustryNum^TNBNum^GXYNum^CHDNum^NZZNum^EXZLNum^JSBNum^CJRNum^Year",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-01-
/// Description: 添加社区档案
/// Table：CommunityBaseInfo
/// Input: CommunityBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Insert(CommunityCode As %String, CommunityName As %String, CommunityAddress As %String, LinkMan As %String, LinkPhone As %String, Post As %String, Area As %Float, TotalFamilyNum As %Numeric, TotalPersonNum As %Numeric, ResidentPersonNum As %Numeric, MaleNum As %Numeric, FemaleNum As %Numeric, OverSixtyNum As %Numeric, BelowSevenNum As %Numeric, BirthFemaleNum As %Numeric, PreYearBirth As %Numeric, PreYearDead As %Numeric, GrowRate As %Numeric, FluxionNum As %Numeric, OrganNum As %Numeric, CorNum As %Numeric, GradeSchoolNum As %Numeric, JuniorCollegeNum As %Numeric, InfantOrg As %Numeric, HosOrg As %Numeric, RVNum As %Numeric, MarketPlace As %Numeric, HotelNum As %Numeric, FoodIndustryNum As %Numeric, TNBNum As %Numeric, GXYNum As %Numeric, CHDNum As %Numeric, NZZNum As %Numeric, EXZLNum As %Numeric, JSBNum As %Numeric, CJRNum As %Numeric, Year) As %String
{
      s tempCommunityBaseInfo=""
      s tempCommunityBaseInfo=##class(CHSS.CommunityBaseInfo).%New()
      q:(tempCommunityBaseInfo="") 0
      
      
      /// 基本信息
      s tempCommunityBaseInfo.CommunityCode=CommunityCode
      s tempCommunityBaseInfo.CommunityName=CommunityName
      s tempCommunityBaseInfo.CommunityAddress=CommunityAddress
      s tempCommunityBaseInfo.LinkMan=LinkMan
      s tempCommunityBaseInfo.LinkPhone=LinkPhone
      s tempCommunityBaseInfo.Post=Post
      s tempCommunityBaseInfo.Area=Area
      s tempCommunityBaseInfo.TotalFamilyNum=TotalFamilyNum
      s tempCommunityBaseInfo.TotalPersonNum=TotalPersonNum
      s tempCommunityBaseInfo.ResidentPersonNum=ResidentPersonNum
      s tempCommunityBaseInfo.MaleNum=MaleNum
      s tempCommunityBaseInfo.FemaleNum=FemaleNum
      s tempCommunityBaseInfo.OverSixtyNum=OverSixtyNum
      s tempCommunityBaseInfo.BelowSevenNum=BelowSevenNum
     
      s tempCommunityBaseInfo.BirthFemaleNum=BirthFemaleNum
      s tempCommunityBaseInfo.PreYearBirth=PreYearBirth
      s tempCommunityBaseInfo.PreYearDead=PreYearDead
      s tempCommunityBaseInfo.GrowRate=GrowRate
      s tempCommunityBaseInfo.FluxionNum=FluxionNum
      s tempCommunityBaseInfo.OrganNum=OrganNum
      s tempCommunityBaseInfo.CorNum=CorNum
      s tempCommunityBaseInfo.GradeSchoolNum=GradeSchoolNum
      s tempCommunityBaseInfo.JuniorCollegeNum=JuniorCollegeNum
      s tempCommunityBaseInfo.InfantOrg=InfantOrg
      s tempCommunityBaseInfo.HosOrg=HosOrg
      s tempCommunityBaseInfo.RVNum=RVNum
   
      s tempCommunityBaseInfo.MarketPlace=MarketPlace
      s tempCommunityBaseInfo.HotelNum=HotelNum
      s tempCommunityBaseInfo.FoodIndustryNum=FoodIndustryNum
      s tempCommunityBaseInfo.TNBNum=TNBNum
      s tempCommunityBaseInfo.GXYNum=GXYNum
      s tempCommunityBaseInfo.CHDNum=CHDNum
      s tempCommunityBaseInfo.NZZNum=NZZNum
     
      s tempCommunityBaseInfo.EXZLNum=EXZLNum
      s tempCommunityBaseInfo.JSBNum=JSBNum
  
      s tempCommunityBaseInfo.CJRNum=CJRNum
      
      s tempCommunityBaseInfo.Year = Year
        
      s result=""
      s result=tempCommunityBaseInfo.%Save()
      Set resultString = ""
     
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempCommunityBaseInfo.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempCommunityBaseInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-01-
/// Description: 更新社区档案
/// Table：CommunityBaseInfo
/// Input: CommunityBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Update(CommunityRowId As %Integer, CommunityName As %String, CommunityAddress As %String, LinkMan As %String, LinkPhone As %String, Post As %String, Area As %Float, TotalFamilyNum As %Numeric, TotalPersonNum As %Numeric, ResidentPersonNum As %Numeric, MaleNum As %Numeric, FemaleNum As %Numeric, OverSixtyNum As %Numeric, BelowSevenNum As %Numeric, BirthFemaleNum As %Numeric, PreYearBirth As %Numeric, PreYearDead As %Numeric, GrowRate As %Numeric, FluxionNum As %Numeric, OrganNum As %Numeric, CorNum As %Numeric, GradeSchoolNum As %Numeric, JuniorCollegeNum As %Numeric, InfantOrg As %Numeric, HosOrg As %Numeric, RVNum As %Numeric, MarketPlace As %Numeric, HotelNum As %Numeric, FoodIndustryNum As %Numeric, TNBNum As %Numeric, GXYNum As %Numeric, CHDNum As %Numeric, NZZNum As %Numeric, EXZLNum As %Numeric, JSBNum As %Numeric, CJRNum As %Numeric, Year) As %String
{
  
      q:($d(CommunityRowId)=0)||(CommunityRowId="")
      
      s tempCommunityBaseInfo="",result=""
      s tempCommunityBaseInfo=##class(CHSS.CommunityBaseInfo).%OpenId(CommunityRowId)
      q:(tempCommunityBaseInfo="") 0
              
	  
	  /// 基本信息
      
      s tempCommunityBaseInfo.CommunityName=CommunityName
      s tempCommunityBaseInfo.CommunityAddress=CommunityAddress
      s tempCommunityBaseInfo.LinkMan=LinkMan
      s tempCommunityBaseInfo.LinkPhone=LinkPhone
      s tempCommunityBaseInfo.Post=Post
      s tempCommunityBaseInfo.Area=Area
      s tempCommunityBaseInfo.TotalFamilyNum=TotalFamilyNum
      s tempCommunityBaseInfo.TotalPersonNum=TotalPersonNum
      s tempCommunityBaseInfo.ResidentPersonNum=ResidentPersonNum
      s tempCommunityBaseInfo.MaleNum=MaleNum
      s tempCommunityBaseInfo.FemaleNum=FemaleNum
      s tempCommunityBaseInfo.OverSixtyNum=OverSixtyNum
      s tempCommunityBaseInfo.BelowSevenNum=BelowSevenNum
      s tempCommunityBaseInfo.BirthFemaleNum=BirthFemaleNum
      s tempCommunityBaseInfo.PreYearBirth=PreYearBirth
      s tempCommunityBaseInfo.PreYearDead=PreYearDead
      s tempCommunityBaseInfo.GrowRate=GrowRate
      s tempCommunityBaseInfo.FluxionNum=FluxionNum
      s tempCommunityBaseInfo.OrganNum=OrganNum
      s tempCommunityBaseInfo.CorNum=CorNum
      s tempCommunityBaseInfo.GradeSchoolNum=GradeSchoolNum
      s tempCommunityBaseInfo.JuniorCollegeNum=JuniorCollegeNum
      s tempCommunityBaseInfo.InfantOrg=InfantOrg
      s tempCommunityBaseInfo.HosOrg=HosOrg
      s tempCommunityBaseInfo.RVNum=RVNum
      s tempCommunityBaseInfo.MarketPlace=MarketPlace
      s tempCommunityBaseInfo.HotelNum=HotelNum
      s tempCommunityBaseInfo.FoodIndustryNum=FoodIndustryNum
      s tempCommunityBaseInfo.TNBNum=TNBNum
      s tempCommunityBaseInfo.GXYNum=GXYNum
      s tempCommunityBaseInfo.CHDNum=CHDNum
      s tempCommunityBaseInfo.NZZNum=NZZNum
      s tempCommunityBaseInfo.EXZLNum=EXZLNum
      s tempCommunityBaseInfo.JSBNum=JSBNum
      s tempCommunityBaseInfo.CJRNum=CJRNum
      s tempCommunityBaseInfo.Year = Year
        
      s result=""
      s result=tempCommunityBaseInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_CommunityRowId_"}"
      .///w "{""success"":""true"",""info"":"_CommunityRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="CommunityBaseInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityBas99DD</DataLocation>
<DefaultData>CommunityBaseInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityBas99DD</IdLocation>
<IndexLocation>^CHSSWeb.CommunityBas99DI</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityBas99DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
