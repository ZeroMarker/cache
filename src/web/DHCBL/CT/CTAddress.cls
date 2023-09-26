/// Creator: sunfengchao
/// CreateDate: 2015-11-12
/// Function: 地址维护
Class web.DHCBL.CT.CTAddress Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function: 后台分页 解决字符超长的问题
/// Table:    CT_Community
/// Return:   CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc,CTCMUNTNationalCode,CTCMUNTActiveFlag,CTCMUNTDateFrom,CTCMUNTDateTo
/// Other:    d ##class(web.DHCBL.CT.CTAddress).GetQuery("","","","","","","",0,3)
ClassMethod GetQuery(rowid As %String, code As %String, desc As %String, Chinese As %String, Province As %String, City As %String, CityArea As %String, start As %String, limit As %String) As %String
{
  s count=0
  if (rowid'="")
  { 
      s CTADDRowId=rowid
      s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
      s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
      /// 省
      s CTADDProvinceDR=$p($g(^CT("ADD",CTADDRowId)),"^",3)
      s:CTADDProvinceDR="" CTADDProvinceDR=""
      s:CTADDProvinceDR'="" CTADDProvinceDR=$p($g(^CT("PROV",CTADDProvinceDR)),"^",2)  
      /// 市
      s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4)
      s:CTADDCityDR="" CTADDCityDR=""
      s:CTADDCityDR'="" CTADDCityDR=$p($g(^CT("CIT",CTADDCityDR)),"^",2)
      /// 城市区域
      s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)
      s:CTADDCityAreaDR="" CTADDCityAreaDR=""
      s:CTADDCityAreaDR'="" CTADDCityAreaDR=$p($g(^CT("CITAREA",CTADDCityAreaDR)),"^",2)
      /// 街道/乡镇
      s CTADDStreetDR=$p($g(^CT("ADD",CTADDRowId)),"^",7)
      s:CTADDStreetDR="" CTADDStreetDR=""
      s:CTADDStreetDR'="" CTADDStreetDR=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",2)
      /// 社区/村
      s CTADDCommunityDR=$p($g(^CT("ADD",CTADDRowId)),"^",6)
      s:CTADDCommunityDR="" CTADDCommunityDR=""
      s:CTADDCommunityDR'="" CTADDCommunityDR=$p($g(^CT("CTCMUNT",CTADDCommunityDR)),"^",2)
      ///　拼音码
      s CTADDSearchCode=$p($g(^CT("ADD",CTADDRowId)),"^",8)
      s CTADDDateFrom=$p($g(^CT("ADD",CTADDRowId)),"^",9)
      s CTADDDateTo=$p($g(^CT("ADD",CTADDRowId)),"^",10)
      s:CTADDDateFrom'="" CTADDDateFrom=$zd(CTADDDateFrom,1)  
      s:CTADDDateTo'="" CTADDDateTo=$zd(CTADDDateTo,1)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Address",CTADDRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      S BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      s count=1 
      w "{""CTADDRowId"":"""_CTADDRowId_""",""CTADDCode"":"""_CTADDCode_""",""CTADDDesc"":"""_CTADDDesc_""",""CTADDProvinceDR"":"""_CTADDProvinceDR_""",""CTADDCityDR"":"""_CTADDCityDR_""",""CTADDCityAreaDR"":"""_CTADDCityAreaDR_""",""CTADDStreetDR"":"""_CTADDStreetDR_""",""CTADDCommunityDR"":"""_CTADDCommunityDR_""",""CTADDSearchCode"":"""_CTADDSearchCode_""",""CTADDDateFrom"":"""_CTADDDateFrom_""",""CTADDDateTo"":"""_CTADDDateTo_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode _""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}"  
  }
  else
  { 
     s BDPInternalCode=""
     s BDPInternalDesc=""
     s BDPHospNationalCode=""
     s BDPHospNationalDesc="" 
     s OpenFlag=""
     s constrastFlag=""
     s ShowStr=""
     if start="" s start=0
     if limit="" s limit=20
     s start=start+1
     s OpenFlag=##class(web.DHCBL.BDP.BDPStandardCode).IfOneKeyUp()
     s constrastFlag=##class(web.DHCBL.BDP.BDPStandardCode).IsContrast("CT_Address")
     s ShowStr=##class(web.DHCBL.BDP.BDPStandardCode).ShowGrid() 
  
     s AuStr=##class(web.DHCBL.Authorize.CTAddress).DHCGetDataByDefaultSession()
     s AuCTADDProvinceDRStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
     s AuCTADDCityDRStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
     s AuCTADDCityAreaDRStr= ##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
     s AuCTADDStreetDRStr=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
     s AuCTADDCommunityDRStr= ##class(web.DHCBL.Authorize.CTLocalityTypeOfCommunity).DHCGetDataByDefaultSession()
 
     s AuFlag=0, AuCTADDProvinceDRFlag=0,AuCTADDCityDRFlag=0,AuCTADDCityAreaDRFlag=0, AuCTADDStreetDRFlag=0
     s AuCTADDCommunityDRFlag=0
     ;未授权情况下，默认显示全部数据
     if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
     if (AuCTADDProvinceDRStr="")||(AuCTADDProvinceDRStr["limited:0") s AuCTADDProvinceDRFlag=1  
     if (AuCTADDCityDRStr="")||(AuCTADDCityDRStr["limited:0") s AuCTADDCityDRFlag=1 
     if (AuCTADDCityAreaDRStr="")||(AuCTADDCityAreaDRStr["limited:0") s AuCTADDCityAreaDRFlag=1 
     if (AuCTADDStreetDRStr="")||(AuCTADDStreetDRStr["limited:0") s AuCTADDStreetDRFlag=1 
     if (AuCTADDCommunityDRStr="")||(AuCTADDCommunityDRStr["limited:0") s AuCTADDCommunityDRFlag=1
 
     s:code'="" code=$ZCVT(code,"U")  
     s:desc'="" desc=$ZCVT(desc,"U")  
     s CTADDRowId=0
     for
     { 
         s CTADDRowId=$o(^CT("ADD",CTADDRowId)) 
         q:CTADDRowId=""   
         s strCTADDRowId="{ID:"_CTADDRowId_"}"
         s TextProvinceDR="",TextCity="",TextCityArea="",LOCTYPETypeC="",LOCTYPETypeS=""
         s CTADDProvinceDR=$p($g(^CT("ADD",CTADDRowId)),"^",3)
         s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4)
         s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)
         s CTADDCommunityDR=$p($g(^CT("ADD",CTADDRowId)),"^",6)
         s CTADDStreetDR=$p($g(^CT("ADD",CTADDRowId)),"^",7) 
         if (CTADDStreetDR'=""){
           s LOCTYPETypeS=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",4)
         }
         if (CTADDCommunityDR'=""){
           s LOCTYPETypeC=$p($g(^CT("LOCTYPE",CTADDCommunityDR)),"^",4)
         }      
         s strCTADDProvinceDR="{ID:"_CTADDProvinceDR_"}"
         s strCTADDCityDR="{ID:"_CTADDCityDR_"}"
         s strCTADDCityAreaDR="{ID:"_CTADDCityAreaDR_"}"
         s strCTADDStreetDR="{ID:"_CTADDStreetDR_"}"
         s strCTADDCommunityDR="{ID:"_CTADDCommunityDR_"}"
         if ((AuStr[strCTADDRowId)||(AuFlag=1))&((AuCTADDProvinceDRStr[strCTADDProvinceDR)||(AuCTADDProvinceDRFlag=1))&((AuCTADDCityDRStr[strCTADDCityDR)||(AuCTADDCityDRFlag=1))&((AuCTADDCityAreaDRStr[strCTADDCityAreaDR)||(AuCTADDCityAreaDRFlag=1))&((AuCTADDStreetDRStr[strCTADDStreetDR)||(AuCTADDStreetDRFlag=1)) &((AuCTADDCommunityDRStr[strCTADDCommunityDR)||(AuCTADDCommunityDRFlag=1))   
         {   
             s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
             s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
       
             /// 省
             s TextProvinceDR=CTADDProvinceDR
             s:CTADDProvinceDR="" CTADDProvinceDR=""
             s:CTADDProvinceDR'="" CTADDProvinceDR=$p($g(^CT("PROV",CTADDProvinceDR)),"^",2)  
             /// 市
             s TextCity=CTADDCityDR
             s:CTADDCityDR="" CTADDCityDR=""
             s:CTADDCityDR'="" CTADDCityDR=$p($g(^CT("CIT",CTADDCityDR)),"^",2)
             /// 城市区域
             s TextCityArea=CTADDCityAreaDR
             s:CTADDCityAreaDR="" CTADDCityAreaDR=""
             s:CTADDCityAreaDR'="" CTADDCityAreaDR=$p($g(^CT("CITAREA",CTADDCityAreaDR)),"^",2)
             /// 街道/乡镇
             s:CTADDStreetDR="" CTADDStreetDR=""
             s:CTADDStreetDR'="" CTADDStreetDR=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",2)
             /// 社区/村
             s:CTADDCommunityDR="" CTADDCommunityDR=""
             s:CTADDCommunityDR'="" CTADDCommunityDR=$p($g(^CT("CTCMUNT",CTADDCommunityDR)),"^",2)
             s CTADDSearchCode=$p($g(^CT("ADD",CTADDRowId)),"^",8)
             s CTADDDateFrom=$p($g(^CT("ADD",CTADDRowId)),"^",9)
             s CTADDDateTo=$p($g(^CT("ADD",CTADDRowId)),"^",10)
             s:CTADDDateFrom CTADDDateFrom=$zd(CTADDDateFrom,1)  
             s:CTADDDateTo CTADDDateTo=$zd(CTADDDateTo,1) 
     
             s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Address",CTADDRowId,OpenFlag,constrastFlag)
             s BDPInternalCode =$p($g(resultStr),"^",1)       
             s BDPInternalDesc = $p($g(resultStr),"^",2)  
             S BDPHospNationalCode=$p($g(resultStr),"^",3)         
             s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   
             if (desc'="")
             {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Address",CTADDRowId,CTADDDesc,desc)
             }
             else
             {
                s AliasFlag= 1   
             }     
             if (($ZCVT(CTADDCode,"U")[code)&(AliasFlag=1)&(($ZCVT(CTADDSearchCode,"U")[$ZCVT(Chinese,"U"))||(Chinese=""))&((TextProvinceDR=Province)||(Province=""))&((TextCity=City)||(City=""))&((TextCityArea=CityArea)||(CityArea="")))
             {
                   k ^TMP("web.BDPAddress","Count",$j)
                   s count=count+1
                   if (count<start) continue
                   if (count<(start+limit))
                   {
                        if ((count#limit)=1)
                        {
                           w "{""CTADDRowId"":"""_CTADDRowId_""",""CTADDCode"":"""_CTADDCode_""",""CTADDDesc"":"""_CTADDDesc_""",""CTADDProvinceDR"":"""_CTADDProvinceDR_""",""CTADDCityDR"":"""_CTADDCityDR_""",""CTADDCityAreaDR"":"""_CTADDCityAreaDR_""",""CTADDStreetDR"":"""_CTADDStreetDR_""",""CTADDCommunityDR"":"""_CTADDCommunityDR_""",""CTADDSearchCode"":"""_CTADDSearchCode_""",""CTADDDateFrom"":"""_CTADDDateFrom_""",""CTADDDateTo"":"""_CTADDDateTo_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode _""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
                        }
                        else
                        {
                           w ",{""CTADDRowId"":"""_CTADDRowId_""",""CTADDCode"":"""_CTADDCode_""",""CTADDDesc"":"""_CTADDDesc_""",""CTADDProvinceDR"":"""_CTADDProvinceDR_""",""CTADDCityDR"":"""_CTADDCityDR_""",""CTADDCityAreaDR"":"""_CTADDCityAreaDR_""",""CTADDStreetDR"":"""_CTADDStreetDR_""",""CTADDCommunityDR"":"""_CTADDCommunityDR_""",""CTADDSearchCode"":"""_CTADDSearchCode_""",""CTADDDateFrom"":"""_CTADDDateFrom_""",""CTADDDateTo"":"""_CTADDDateTo_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode _""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
                        }
                      }
                   }
                 }
            }   
          }  
     s ^TMP("web.BDPAddress","Count",$j)=count
}

/// Function: 调csp时拼装json串
/// CreateDate:2017-3-14
/// Creator:  sunfengchao
ClassMethod GetList(rowid As %String, code As %String, desc As %String, Chinese As %String, Province As %String, City As %String, CityArea As %String, start As %String, limit As %String) As %String
{
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..GetQuery(rowid,code,desc,Chinese,Province,City,CityArea,start,limit)
  w "]" 
  s count=$g(^TMP("web.BDPAddress","Count",$j))
  w ",total:"_count
  w "}"
}

/// Function:　地址维护查询列表
/// Creator:   sunfengchao
/// CreateDate:2015-11-12
/// Table：    CT_Address
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTAddress", "GetList","","","","","","","")
/// CTADDRowId CTADDCode  CTADDDesc  CTADDProvinceDR CTADDCityDR CTADDCityAreaDR CTADDStreetDR
/// CTADDCommunityDR  CTADDSearchCode CTADDDateFrom  CTADDDateTo
Query GetList(rowid As %String, code As %String, desc As %String, Chinese As %String, Province As %String, City As %String, CityArea As %String) As %Query(ROWSPEC = "CTADDRowId,CTADDCode,CTADDDesc,CTADDProvinceDR,CTADDCityDR,CTADDCityAreaDR,CTADDStreetDR,CTADDCommunityDR,CTADDSearchCode,CTADDDateFrom,CTADDDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, Chinese As %String, Province As %String, City As %String, CityArea As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1  
 s AuStr= ##class(web.DHCBL.Authorize.CTAddress).DHCGetDataByDefaultSession()
 s AuCTADDProvinceDRStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
 s AuCTADDCityDRStr= ##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
 s AuCTADDCityAreaDRStr= ##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
 s AuCTADDStreetDRStr=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
 s AuCTADDCommunityDRStr=##class(web.DHCBL.Authorize.CTLocalityTypeOfCommunity).DHCGetDataByDefaultSession()
 
 s AuFlag=0, AuCTADDProvinceDRFlag=0,AuCTADDCityDRFlag=0,AuCTADDCityAreaDRFlag=0, AuCTADDStreetDRFlag=0
 s AuCTADDCommunityDRFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (AuCTADDProvinceDRStr="")||(AuCTADDProvinceDRStr["limited:0") s AuCTADDProvinceDRFlag=1  
 if (AuCTADDCityDRStr="")||(AuCTADDCityDRStr["limited:0") s AuCTADDCityDRFlag=1 
 if (AuCTADDCityAreaDRStr="")||(AuCTADDCityAreaDRStr["limited:0") s AuCTADDCityAreaDRFlag=1 
 if (AuCTADDStreetDRStr="")||(AuCTADDStreetDRStr["limited:0") s AuCTADDStreetDRFlag=1 
 if (AuCTADDCommunityDRStr="")||(AuCTADDCommunityDRStr["limited:0") s AuCTADDCommunityDRFlag=1 
 if (rowid'="")  
 {
  s CTADDRowId=rowid
  s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
  s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
  /// 省
  s CTADDProvinceDR=$p($g(^CT("ADD",CTADDRowId)),"^",3)
  s:CTADDProvinceDR="" CTADDProvinceDR=""
  s:CTADDProvinceDR'="" CTADDProvinceDR=$p($g(^CT("PROV",CTADDProvinceDR)),"^",2)  
  /// 市
  s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4)
  s:CTADDCityDR="" CTADDCityDR=""
  s:CTADDCityDR'="" CTADDCityDR=$p($g(^CT("CIT",CTADDCityDR)),"^",2)
  /// 城市区域
  s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)
  s:CTADDCityAreaDR="" CTADDCityAreaDR=""
  s:CTADDCityAreaDR'="" CTADDCityAreaDR=$p($g(^CT("CITAREA",CTADDCityAreaDR)),"^",2)
  /// 街道/乡镇
  s CTADDStreetDR=$p($g(^CT("ADD",CTADDRowId)),"^",7)
  s:CTADDStreetDR="" CTADDStreetDR=""
  s:CTADDStreetDR'="" CTADDStreetDR=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",2)
  /// 社区/村
  s CTADDCommunityDR=$p($g(^CT("ADD",CTADDRowId)),"^",6)
  s:CTADDCommunityDR="" CTADDCommunityDR=""
  s:CTADDCommunityDR'="" CTADDCommunityDR=$p($g(^CT("CTCMUNT",CTADDCommunityDR)),"^",2)
  ///　拼音码
  s CTADDSearchCode=$p($g(^CT("ADD",CTADDRowId)),"^",8)
  s CTADDDateFrom=$p($g(^CT("ADD",CTADDRowId)),"^",9)
  s CTADDDateTo=$p($g(^CT("ADD",CTADDRowId)),"^",10)
  s:CTADDDateFrom'="" CTADDDateFrom=$zd(CTADDDateFrom,1)  
  s:CTADDDateTo'="" CTADDDateTo=$zd(CTADDDateTo,1)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Address",CTADDRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  S BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)
  d OutputRow
 }
 else
 {
   s BDPInternalCode=""
   s BDPInternalDesc=""
   s BDPHospNationalCode=""
   s BDPHospNationalDesc="" 
   s OpenFlag=""
   s constrastFlag=""
   s ShowStr=""
   s OpenFlag=##class(web.DHCBL.BDP.BDPStandardCode).IfOneKeyUp()
   s constrastFlag=##class(web.DHCBL.BDP.BDPStandardCode).IsContrast("CT_Address")
   s ShowStr=##class(web.DHCBL.BDP.BDPStandardCode).ShowGrid() 
 
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s CTADDRowId=0
   for
  { 
     s CTADDRowId=$o(^CT("ADD",CTADDRowId)) 
     q:CTADDRowId=""   
     s strCTADDRowId="{ID:"_CTADDRowId_"}"
     s TextProvinceDR="",TextCity="",TextCityArea="",LOCTYPETypeC="",LOCTYPETypeS=""
     s CTADDProvinceDR=$p($g(^CT("ADD",CTADDRowId)),"^",3)
     s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4)
     s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)
     s CTADDCommunityDR=$p($g(^CT("ADD",CTADDRowId)),"^",6)
     s CTADDStreetDR=$p($g(^CT("ADD",CTADDRowId)),"^",7) 
     if (CTADDStreetDR'=""){
       s LOCTYPETypeS=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",4)
     }
     if (CTADDCommunityDR'=""){
       s LOCTYPETypeC=$p($g(^CT("LOCTYPE",CTADDCommunityDR)),"^",4)
     }      
     s strCTADDProvinceDR="{ID:"_CTADDProvinceDR_"}"
     s strCTADDCityDR="{ID:"_CTADDCityDR_"}"
     s strCTADDCityAreaDR="{ID:"_CTADDCityAreaDR_"}"
     s strCTADDStreetDR="{ID:"_CTADDStreetDR_"}"
     s strCTADDCommunityDR="{ID:"_CTADDCommunityDR_"}"
     if ((AuStr[strCTADDRowId)||(AuFlag=1))&((AuCTADDProvinceDRStr[strCTADDProvinceDR)||(AuCTADDProvinceDRFlag=1))&((AuCTADDCityDRStr[strCTADDCityDR)||(AuCTADDCityDRFlag=1))&((AuCTADDCityAreaDRStr[strCTADDCityAreaDR)||(AuCTADDCityAreaDRFlag=1))&((AuCTADDStreetDRStr[strCTADDStreetDR)||(AuCTADDStreetDRFlag=1)) &((AuCTADDCommunityDRStr[strCTADDCommunityDR)||(AuCTADDCommunityDRFlag=1))   
     {   
      s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
      s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
       
     /// 省
     s TextProvinceDR=CTADDProvinceDR
     s:CTADDProvinceDR="" CTADDProvinceDR=""
     s:CTADDProvinceDR'="" CTADDProvinceDR=$p($g(^CT("PROV",CTADDProvinceDR)),"^",2)  
     /// 市
     s TextCity=CTADDCityDR
     s:CTADDCityDR="" CTADDCityDR=""
     s:CTADDCityDR'="" CTADDCityDR=$p($g(^CT("CIT",CTADDCityDR)),"^",2)
     /// 城市区域
     s TextCityArea=CTADDCityAreaDR
     s:CTADDCityAreaDR="" CTADDCityAreaDR=""
     s:CTADDCityAreaDR'="" CTADDCityAreaDR=$p($g(^CT("CITAREA",CTADDCityAreaDR)),"^",2)
     /// 街道/乡镇
     s:CTADDStreetDR="" CTADDStreetDR=""
     s:CTADDStreetDR'="" CTADDStreetDR=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",2)
     /// 社区/村
     s:CTADDCommunityDR="" CTADDCommunityDR=""
     s:CTADDCommunityDR'="" CTADDCommunityDR=$p($g(^CT("CTCMUNT",CTADDCommunityDR)),"^",2)
     s CTADDSearchCode=$p($g(^CT("ADD",CTADDRowId)),"^",8)
     s CTADDDateFrom=$p($g(^CT("ADD",CTADDRowId)),"^",9)
     s CTADDDateTo=$p($g(^CT("ADD",CTADDRowId)),"^",10)
     s:CTADDDateFrom CTADDDateFrom=$zd(CTADDDateFrom,1)  
     s:CTADDDateTo CTADDDateTo=$zd(CTADDDateTo,1) 
     
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Address",CTADDRowId,OpenFlag,constrastFlag)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     S BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   
     if (desc'="")
     {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Address",CTADDRowId,CTADDDesc,desc)
     }
     else
     {
        s AliasFlag= 1   
     }     
     if (($ZCVT(CTADDCode,"U")[code)&(AliasFlag=1)&((CTADDSearchCode[Chinese)||(Chinese=""))&((TextProvinceDR=Province)||(Province=""))&((TextCity=City)||(City=""))&((TextCityArea=CityArea)||(CityArea="")))
     {
       d OutputRow
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTADDRowId,CTADDCode,CTADDDesc,CTADDProvinceDR,CTADDCityDR,CTADDCityAreaDR,CTADDStreetDR,CTADDCommunityDR,CTADDSearchCode,CTADDDateFrom,CTADDDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:　地理信息—位置查询combox接口
/// Creator:   sunfengchao
/// CreateDate:2015-11-12
/// Tables:  CT_Address
/// Input:   code，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTAddress", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, Chinese As %String) As %Query(ROWSPEC = "CTADDRowId,CTADDCode,CTADDDesc")
{
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
      Set AtEnd=1
      Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, Chinese As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1 
 s AuStr=##class(web.DHCBL.Authorize.CTAddress).DHCGetDataByDefaultSession()
 s AuCTADDProvinceDRStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
 s AuCTADDCityDRStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
 s AuCTADDCityAreaDRStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
 s AuCTADDStreetDRStr=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
 s AuCTADDCommunityDRStr= ##class(web.DHCBL.Authorize.CTLocalityTypeOfCommunity).DHCGetDataByDefaultSession()
 
 s AuFlag=0, AuCTADDProvinceDRFlag=0,AuCTADDCityDRFlag=0,AuCTADDCityAreaDRFlag=0, AuCTADDStreetDRFlag=0
 s AuCTADDCommunityDRFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (AuCTADDProvinceDRStr="")||(AuCTADDProvinceDRStr["limited:0") s AuCTADDProvinceDRFlag=1  
 if (AuCTADDCityDRStr="")||(AuCTADDCityDRStr["limited:0") s AuCTADDCityDRFlag=1 
 if (AuCTADDCityAreaDRStr="")||(AuCTADDCityAreaDRStr["limited:0") s AuCTADDCityAreaDRFlag=1 
 if (AuCTADDStreetDRStr="")||(AuCTADDStreetDRStr["limited:0") s AuCTADDStreetDRFlag=1 
 if (AuCTADDCommunityDRStr="")||(AuCTADDCommunityDRStr["limited:0") s AuCTADDCommunityDRFlag=1 
 if (rowid'="")  
 {
  s CTADDRowId=rowid
  s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
  s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
  d OutputCmbRow
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s CTADDRowId=0
   for
  { 
     s CTADDRowId=$o(^CT("ADD",CTADDRowId)) q:CTADDRowId=""   
     s strCTADDRowId="{ID:"_CTADDRowId_"}"
     s TextProvinceDR="",TextCity="",TextCityArea="",LOCTYPETypeC="",LOCTYPETypeS=""
     s CTADDDateTo=$p($g(^CT("ADD",CTADDRowId)),"^",10)
     continue:(CTADDDateTo'="")&&(CTADDDateTo<+$h) 
     s CTADDProvinceDR=$p($g(^CT("ADD",CTADDRowId)),"^",3)
     s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4)
     s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)
     s CTADDCommunityDR=$p($g(^CT("ADD",CTADDRowId)),"^",6)
     s CTADDStreetDR=$p($g(^CT("ADD",CTADDRowId)),"^",7) 
     if (CTADDStreetDR'=""){
       s LOCTYPETypeS=$p($g(^CT("LOCTYPE",CTADDStreetDR)),"^",4)
     }
     if (CTADDCommunityDR'=""){
       s LOCTYPETypeC=$p($g(^CT("LOCTYPE",CTADDCommunityDR)),"^",4)
     }      
     s strCTADDProvinceDR="{ID:"_CTADDProvinceDR_"}"
     s strCTADDCityDR="{ID:"_CTADDCityDR_"}"
     s strCTADDCityAreaDR="{ID:"_CTADDCityAreaDR_"}"
     s strCTADDStreetDR="{ID:"_CTADDStreetDR_"}"
     s strCTADDCommunityDR="{ID:"_CTADDCommunityDR_"}" 
     if ((AuStr[strCTADDRowId)||(AuFlag=1))&((AuCTADDProvinceDRStr[strCTADDProvinceDR)||(AuCTADDProvinceDRFlag=1))&((AuCTADDCityDRStr[strCTADDCityDR)||(AuCTADDCityDRFlag=1))&((AuCTADDCityAreaDRStr[strCTADDCityAreaDR)||(AuCTADDCityAreaDRFlag=1))&((AuCTADDStreetDRStr[strCTADDStreetDR)||(AuCTADDStreetDRFlag=1)) &((AuCTADDCommunityDRStr[strCTADDCommunityDR)||(AuCTADDCommunityDRFlag=1))   
     {  
      s CTADDCode=$p($g(^CT("ADD",CTADDRowId)),"^",1)
      s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
      if (desc'="")
      {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Address",CTADDRowId,CTADDDesc,desc)
      }
      else
      {
        s AliasFlag= 1   
      }    
      if (($ZCVT(CTADDCode,"U")[code)&(AliasFlag= 1)&((CTADDSearchCode[Chinese)||(Chinese="")))  
      {
        d OutputCmbRow
      }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputCmbRow
  set Data=$lb(CTADDRowId,CTADDCode,CTADDDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function： 数据重复校验
/// Creator：  sunfengchao
/// CreatDate: 2012-12-7
/// Table：    CT_Address
/// Input：    id, code 
/// Return：   "1"(数据重复),"0"(数据不重复) ,desc As %String
ClassMethod FormValidate(id As %String, code As %String) As %String
{
 s flag=0,flagc=0
 s:code'="" code=$$ALPHAUP^SSUTIL4(code)
 s:code'="" flagc=$d(^CT("ADD",0,"Code",code))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0
 }
 else //如果不为空，修改时的重复判断
 {
   s idc=0
   if (code'="")
   {
    s idc=$o(^CT("ADD",0,"Code",code,0))
    if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   } 
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2015-11-13
/// Table： CT_Address
/// Others: w ##class(web.DHCBL.CT.CTAddress).OpenData("2")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
    s prbj = ##class(User.CTAddress).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTAddress).%New()
    s eobj.CTADDRowId = id
    s eobj.CTADDCode  = prbj.CTADDCode
    s eobj.CTADDDesc = prbj.CTADDDesc
    s:prbj.CTADDProvinceDR'="" eobj.CTADDProvinceDR = prbj.CTADDProvinceDR.%Id()
    s:prbj.CTADDCityDR'="" eobj.CTADDCityDR = prbj.CTADDCityDR.%Id()
    s:prbj.CTADDCityAreaDR'="" eobj.CTADDCityAreaDR = prbj.CTADDCityAreaDR.%Id()
    s:prbj.CTADDCommunityDR'="" eobj.CTADDCommunityDR = prbj.CTADDCommunityDR.%Id()
    s eobj.CTADDSearchCode = prbj.CTADDSearchCode 
    s:prbj.CTADDStreetDR'="" eobj.CTADDStreetDR = prbj.CTADDStreetDR.%Id()
    s:prbj.CTADDDateFrom'="" eobj.CTADDDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(prbj.CTADDDateFrom)
    s:prbj.CTADDDateTo'="" eobj.CTADDDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(prbj.CTADDDateTo)
    kill prbj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Function：保存修改地址内容
/// Creator：sunfengchao
/// CreatDate: 2015-11-12
/// Table： CT_Address
ClassMethod SaveEntity(eobj As web.Entity.CT.CTAddress) As %String
{
 s result="",jsonstr="",flag=""
 s Alias=""
 s listData=""
 s ret=""
 if eobj.CTADDDateFrom'="" s eobj.CTADDDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTADDDateFrom)
 s:eobj.CTADDDateFrom="" eobj.CTADDDateFrom=+$h   
 if eobj.CTADDDateTo'="" s eobj.CTADDDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTADDDateTo) 
 s:eobj.CTADDSearchCode="" eobj.CTADDSearchCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTADDDesc)
 s flag=..FormValidate(eobj.CTADDRowId,eobj.CTADDCode) 
 if (flag=1)
 {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
 }
 else
 {
   if ((eobj.CTADDRowId)="")                             
   { 
     s obj=##class(User.CTAddress).%New()
   }
   else                                                  
   {
      s obj=##class(User.CTAddress).%OpenId(eobj.CTADDRowId) 
      s bobj=##class(web.Entity.CT.CTAddress).%New()
      s bobj.CTADDRowId =eobj.CTADDRowId
      s bobj.CTADDCode  = obj.CTADDCode
      s bobj.CTADDDesc = obj.CTADDDesc
      s bobj.CTADDSearchCode = obj.CTADDSearchCode 
      s:obj.CTADDProvinceDR'="" bobj.CTADDProvinceDR = obj.CTADDProvinceDR.%Id()
      s:obj.CTADDCityDR'="" bobj.CTADDCityDR = obj.CTADDCityDR.%Id()
      s:obj.CTADDCityAreaDR'="" bobj.CTADDCityAreaDR = obj.CTADDCityAreaDR.%Id()
      s:obj.CTADDCommunityDR'="" bobj.CTADDCommunityDR = obj.CTADDCommunityDR.%Id()
      s:obj.CTADDStreetDR'="" bobj.CTADDStreetDR = obj.CTADDStreetDR.%Id()
      s:obj.CTADDDateFrom'="" bobj.CTADDDateFrom = $zd(obj.CTADDDateFrom,1)
      s:obj.CTADDDateTo'="" bobj.CTADDDateTo=$zd(obj.CTADDDateTo,1)
    } 
    s obj.CTADDCode = eobj.CTADDCode                     
    s obj.CTADDDesc = eobj.CTADDDesc 
    s obj.CTADDSearchCode = eobj.CTADDSearchCode
    d obj.CTADDProvinceDRSetObjectId(eobj.CTADDProvinceDR)   
    d obj.CTADDCityDRSetObjectId(eobj.CTADDCityDR)   
    d obj.CTADDCityAreaDRSetObjectId(eobj.CTADDCityAreaDR)   
    d obj.CTADDCommunityDRSetObjectId(eobj.CTADDCommunityDR)   
    d obj.CTADDStreetDRSetObjectId(eobj.CTADDStreetDR)   
    s obj.CTADDDateFrom = eobj.CTADDDateFrom 
    s obj.CTADDDateTo=eobj.CTADDDateTo
    Ts
    s sc=obj.%Save()
    s id = obj.%Id()
    d obj.%Close()
    If $$$ISOK(sc)
    {
     Tc
     if (eobj.CTADDRowId="")  //新增时加别名
     {
	     s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.CTADDDesc)
	     s listData ="^"_"CT_Address"_"^"_Alias_"^"_id
	     s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
     }
     s result = "{success:'true',id:'"_id_"'}"          
     d:eobj.CTADDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Address","User.CTAddress","地址",id,eobj.CTADDDesc,"A",eobj)
     d:eobj.CTADDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Address","User.CTAddress","地址",eobj.CTADDRowId,eobj.CTADDDesc,"U",eobj,bobj)
    }
    else
    {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("地址","web.DHCBL.CT.CTAddress","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  }   
  q result
}

/// Function：删除地址内容
/// Creator：sunfengchao
/// CreatDate: 2015-10-29
/// Table： ARC_Tariff
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s obj=##class(User.CTAddress).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTAddress).%New()
    s eobj.CTADDRowId = id
    s eobj.CTADDCode  = obj.CTADDCode
    s eobj.CTADDDesc = obj.CTADDDesc
    s:obj.CTADDProvinceDR'="" eobj.CTADDProvinceDR = obj.CTADDProvinceDR.%Id() 
    s:obj.CTADDCityDR'="" eobj.CTADDCityDR = obj.CTADDCityDR.%Id() 
    s:obj.CTADDCityAreaDR'="" eobj.CTADDCityAreaDR = obj.CTADDCityAreaDR.%Id() 
    s:obj.CTADDStreetDR'="" eobj.CTADDStreetDR = obj.CTADDStreetDR.%Id() 
    s:obj.CTADDCommunityDR'="" eobj.CTADDCommunityDR = obj.CTADDCommunityDR.%Id() 
    
    s eobj.CTADDSearchCode = obj.CTADDSearchCode
    s eobj.CTADDDateFrom = obj.CTADDDateFrom
    s eobj.CTADDDateTo = obj.CTADDDateTo
    s sc=##class(User.CTAddress).%DeleteId(id)
    IF $$$ISOK(sc)
    {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Address","User.CTAddress","地址",id,eobj.CTADDDesc,"D",eobj)
    }
    else
    {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("地址","web.DHCBL.CT.CTAddressas","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 q result
}

/// Function: 通过 省,市,城市区域,街道/乡镇,社区/村/村获取地址的code
/// Creator:  sunfengchao
/// CreateDate: 2015-11-13
/// Debug: w ##class(web.DHCBL.CT.CTAddress).GetCode()
ClassMethod GetCode(Province As %String, City As %String, CityArea As %String, Street As %String = "", Comunity As %String = "") As %String
{
   s result="" 
   s ProvinceCode="",CityCode="",CityAreaCode="",StreetCode=""
   s CTADDCode=""
   s:Province'="" ProvinceCode=$p($g(^CT("PROV",Province)),"^",1) 
   s:City'="" CityCode= $p($g(^CT("CIT",City)),"^",1)
   s:CityArea'="" CityAreaCode=$p($g(^CT("CITAREA",CityArea)),"^",1)
   s:Street'="" StreetCode=$p($g(^CT("LOCTYPE",Street)),"^",1)
   s:Street="" StreetCode=""
   s:Comunity'="" ComunityCode=$p($g(^CT("CTCMUNT",Comunity)),"^",1)
   s:Comunity="" ComunityCode=""
   if ((CityCode'="")&&(CityAreaCode="")) //当选到市时CTADDCode=市代码
   {
       s CTADDCode=CityCode
   }
   if ((CityAreaCode'="")&&(StreetCode="")) //当选到城市区域时CTADDCode=城市区域代码
   {
       s CTADDCode=CityAreaCode
   }
   if ((StreetCode'="")&&(ComunityCode="")) //当选到街道时CTADDCode=街道代码
   {
       s CTADDCode=StreetCode
   }
   if (ComunityCode'="") //当选到社区时CTADDCode=社区代码
   {
       s CTADDCode=ComunityCode
   }
   //s CTADDCode=ProvinceCode_CityCode_CityAreaCode_StreetCode_ComunityCode
   s result= "{success:'true',id:'"_CTADDCode_"'}"   
   q result
}

/// Function:提供根据地址信息获取邮编接口
/// CreateDate:2020-12-09
/// Creator:sunfengchao
/// Input: CTADDDesc 地址对应的描述
/// Debug: w ##class(web.DHCBL.CT.CTAddress).GetZIPDescByAddress("上海市市辖区宝山区庙行镇") 
ClassMethod GetZIPDescByAddress(CTADDDesc As %String) As %String
{
     q:CTADDDesc="" ""
     s CTADDRowId=$o(^CT("ADD",0,"Desc",$$ALPHAUP^SSUTIL4(CTADDDesc),0))
     q:CTADDRowId="" "" 
     s CTADDCityAreaDR=$p($g(^CT("ADD",CTADDRowId)),"^",5)  /// 城市区域 
     s CTZipRowId=""
     if ($d(^CT("ZIP",0,"CityArea",CTADDCityAreaDR)))   s CTZipRowId=$O(^CT("ZIP",0,"CityArea",CTADDCityAreaDR,0))  // 根据城市区域去找邮编id  
     if CTZipRowId=""
     {
        s CTADDCityDR=$p($g(^CT("ADD",CTADDRowId)),"^",4) /// 市
        s CTZipRowId=$O(^CT("ZIP",0,"City",CTADDCityDR,0))  // 根据城市去找邮编id  
     }  
     q:CTZipRowId="" "" 
     s CTZIPCode=$p($g(^CT("ZIP",CTZipRowId)),"^",1)   
     q CTZIPCode
}

/// Function:提供根据区县信息获取邮编接口
/// CreateDate:2020-12-09
/// Creator:sunfengchao
/// Input: CityAreaDesc 区县信息
/// Debug: w ##class(web.DHCBL.CT.CTAddress).GetZIPDescByCityArea("通州区") 
ClassMethod GetZIPDescByCityArea(CityAreaDesc As %String) As %String
{
     q:CityAreaDesc="" "" 
     s CTADDCityAreaDR=$o(^CT("CITAREA",0,"Desc",$$ALPHAUP^SSUTIL4(CityAreaDesc),0)) /// 城市区域 
     s CTZipRowId=""
     if ($d(^CT("ZIP",0,"CityArea",CTADDCityAreaDR)))   s CTZipRowId=$O(^CT("ZIP",0,"CityArea",CTADDCityAreaDR,0))  // 根据城市区域去找邮编id  
     if CTZipRowId=""
     {
        s CTADDCityDR= $p($g(^CT("CITAREA",CTADDCityAreaDR)),"^",3) /// 市
        s CTZipRowId=$O(^CT("ZIP",0,"City",CTADDCityDR,0))  // 根据城市去找邮编id  
     }   
     q:CTZipRowId="" "" 
     s CTZIPCode=$p($g(^CT("ZIP",CTZipRowId)),"^",1)   
     q CTZIPCode
}

/// 生成地址的拼音码
/// Others: w ##class(web.DHCBL.CT.CTAddress).SaveSearchCode()
ClassMethod SaveSearchCode() As %String
{
	s CTADDRowId=0
	for
	{ 
		s CTADDRowId=$o(^CT("ADD",CTADDRowId)) q:CTADDRowId=""   
		s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
		s CTADDSearchCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTADDDesc)
		s obj=##class(User.CTAddress).%OpenId(CTADDRowId) 
		s obj.CTADDSearchCode =CTADDSearchCode
		s sc=obj.%Save()
		w CTADDDesc_" "_CTADDSearchCode,!
	}
	Q ""
}

}
