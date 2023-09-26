/// Function: 医疗单元业务类
/// Creator:  基础数据平台组 sunfengchao
/// CreateDate:2015-12-29
Class web.DHCBL.CT.DHCCTLocMedUnit Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "DHC_CTLoc_MedUnit";

/// Function：医疗单元查询
/// Creator:  sunfengchao
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnit","QueryMedUnit1","6||1","","","")
Query QueryMedUnit1(rowid As %String, CTLocDr As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "CTMUCode,CTMUDesc,CTMUActiveFlag,CTMUDateFrom,CTMUDateTo,CTLocDr,CTLOCCode,CTLOCDesc,MURowId,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod QueryMedUnit1Execute(ByRef qHandle As %Binary, rowid As %String, CTLocDr As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1   
  s:code'="" code=$zcvt(code,"U")
  s:desc'="" desc=$zcvt(desc,"U")
  s AuStr=##class(web.DHCBL.Authorize.DHCCTLocMedUnit).DHCGetDataByDefaultSession()
  s AuFlag=0
  s CTLocDrStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
  s AuCTLocDrFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (CTLocDrStr="")||(CTLocDrStr["limited:0") s AuCTLocDrFlag=1
  
  //需要翻译的语言
  s langid=20
  s langcode="CH"
  if ($d(%session))
  {
	  s langid=$g(%session.Data("LOGON.LANGID"))
	  s langcode=$g(%session.Data("LOGON.LANGCODE"))
  }
  
  if (rowid'="")
  {
    s ParRef=$p(rowid,"||",1)
    s Childsub=$p(rowid,"||",2)
    s MURowId=rowid
    s CTLocDr=ParRef
    s CTLOCCode=$p($g(^CTLOC(CTLocDr)),"^",1)
    s CTLOCDesc=$p($g(^CTLOC(CTLocDr)),"^",2)
    s CTLOCDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",langcode,CTLOCDesc)
    s CTMUCode=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",1)       
    s CTMUCode=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUCode",CTMUCode,langid)            
    s CTMUDesc=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",2)   
    s CTMUDesc=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUDesc",CTMUDesc,langid)                
    s CTMUActiveFlag=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",3)
    s CTMUDateFrom=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",4)
    s:CTMUDateFrom'="" CTMUDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateFrom) 
    s CTMUDateTo=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",5)
    s:CTMUDateTo'="" CTMUDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateTo) 
    ;s:CTMUDateFrom'="" CTMUDateFrom=$zd(CTMUDateFrom,1)                          
    ;s:CTMUDateTo'="" CTMUDateTo=$zd(CTMUDateTo,1)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_CTLoc_MedUnit",MURowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
    d BuildCont1
  }
  else
  {
  if (CTLocDr="") 
  {                                                         
    s CTLocDr="0"
    for
    {
      s CTLocDr=$o(^CTLOC(CTLocDr)) 
      q:CTLocDr=""  
      s CTChildsub=0                                                   
       s CTLOCCode=$p($g(^CTLOC(CTLocDr)),"^",1)
     s CTLOCDesc=$p($g(^CTLOC(CTLocDr)),"^",2)   
     s CTLOCDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",langcode,CTLOCDesc)                 
      for
      {
        s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  
        q:CTChildsub=""    
        s MURowId=CTLocDr_"||"_CTChildsub
        s strARCBGRowId="{ID:"_MURowId_"}"
        s strCTLocDr="{ID:"_CTLocDr_"}"
        if ((AuStr[strARCBGRowId)||(AuFlag=1))&&((CTLocDrStr[strCTLocDr)||(AuCTLocDrFlag=1)) 
        {
          s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",CTLocDr,hospid)
	  	  continue:showflag="N"
          
          s CTMUCode=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",1)         
          s CTMUCode=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUCode",CTMUCode,langid)             
          s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2)              
          s CTMUDesc=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUDesc",CTMUDesc,langid)    
          s CTMUActiveFlag=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",3)
          s CTMUDateFrom=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",4)  
          s:CTMUDateFrom'="" CTMUDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateFrom)                     
          s CTMUDateTo=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",5)
          s:CTMUDateTo'="" CTMUDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateTo) 
          ;s:CTMUDateFrom'="" CTMUDateFrom=$zd(CTMUDateFrom,1)    
          ;s:CTMUDateTo'="" CTMUDateTo=$zd(CTMUDateTo,1)
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_CTLoc_MedUnit",MURowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CTLoc_MedUnit",MURowId,CTMUDesc,desc)
          }
          else
          {
             s AliasFlag= 1   
          }   
          if ($ZCVT(CTMUCode,"U")[code)&(AliasFlag=1)   
          {
            d BuildCont1
          }
        }
      }
    }
  }
  else
  {         
    q:($d(^CTLOC(CTLocDr))=0)      
    s CTChildsub=0
    s TCTLocDr=CTLocDr               
    s CTLOCCode=$p($g(^CTLOC(CTLocDr)),"^",1)
    s CTLOCDesc=$p($g(^CTLOC(CTLocDr)),"^",2)
    s CTLOCDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",langcode,CTLOCDesc)
                                  
    for
    {
      s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  
      q:CTChildsub=""  
      s MURowId=CTLocDr_"||"_CTChildsub
      s strARCBGRowId="{ID:"_MURowId_"}"
      if (AuStr[strARCBGRowId)||(AuFlag=1) 
      { 
        s CTMUCode=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",1)
        s CTMUCode=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUCode",CTMUCode,langid)
        s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2)
        s CTMUDesc=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUDesc",CTMUDesc,langid)  
        s CTMUActiveFlag=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",3)
        
        s CTMUDateFrom=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",4)
        s:CTMUDateFrom'="" CTMUDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateFrom)  
        s CTMUDateTo=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",5)
        s:CTMUDateTo'="" CTMUDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTMUDateTo) 
        ;s:CTMUDateFrom'="" CTMUDateFrom=$zd(CTMUDateFrom,1)
        ;s:CTMUDateTo'="" CTMUDateTo=$zd(CTMUDateTo,1)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_CTLoc_MedUnit",MURowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CTLoc_MedUnit",MURowId,CTMUDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }   
        if ($ZCVT(CTMUCode,"U")[code)&(AliasFlag=1)    
        {
           d BuildCont1
        }
      }
     }
   }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
BuildCont1      
  set Data=$lb(CTMUCode,CTMUDesc,CTMUActiveFlag,CTMUDateFrom,CTMUDateTo,CTLocDr,CTLOCCode,CTLOCDesc,MURowId,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod QueryMedUnit1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMedUnit1Execute ]
{
  
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  //
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {       // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
  }
  Else      {       // fetch row
    Set Row=^CacheTemp(repid,ind)
  }
  // Save QHandle
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod QueryMedUnit1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMedUnit1Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

/// Function:进行数据检索，为combox查询提供接口 
/// CreateDate:2015-12-31
/// Creator:基础数据平台组 sunfengchao
/// Input:  code,desc     
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnit","GetDataForCmb1","6||1","","","")
Query GetDataForCmb1(rowid As %String, CTLocDr As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "MURowId:%String,CTMUCode:%String,CTMUDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, CTLocDr As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.DHCCTLocMedUnit).DHCGetDataByDefaultSession()
  s AuFlag=0
  s CTLocDrStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
  s AuCTLocDrFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (CTLocDrStr="")||(CTLocDrStr["limited:0") s AuCTLocDrFlag=1
  if (rowid'="")
  {
    s ParRef=$p(rowid,"||",1)
    s Childsub=$p(rowid,"||",2)
    s MURowId=rowid
    s CTLocDr=ParRef
    s CTCode=$p($g(^CTLOC(CTLocDr)),"^",2) 
    s CTMUCode=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",1)                   
    s CTMUDesc=$p($g(^CTLOC(ParRef,"MU",Childsub)),"^",2)                   
    d OutputRow2
  }
  else
  {
  if (CTLocDr="") 
  {                                                         
    s CTLocDr="0"
    for
    {
      s CTLocDr=$o(^CTLOC(CTLocDr)) 
      q:CTLocDr=""  
      s CTChildsub=0                                                   
      s CTCode=$p($g(^CTLOC(CTLocDr)),"^",2)                                   
      for
      {
        s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  
        q:CTChildsub=""    
        s MURowId=CTLocDr_"||"_CTChildsub
        s CTMUDateFrom=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",4)
        s CTMUDateTo=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",5)
        continue:(CTMUDateFrom'="")&&(CTMUDateFrom>+$h)
        continue:(CTMUDateTo'="")&&(CTMUDateTo<+$h)  
        
        s strARCBGRowId="{ID:"_MURowId_"}"
        s strCTLocDr="{ID:"_CTLocDr_"}"
        if ((AuStr[strARCBGRowId)||(AuFlag=1))&&((CTLocDrStr[strCTLocDr)||(AuCTLocDrFlag=1)) 
        {
	      s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",CTLocDr,hospid)
	  	  continue:showflag="N"
	        
          s CTMUCode=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",1)                   
          s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2)   
          s tmpCTMUActiveFlag=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",3) 
       
          if (desc'="")
          {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CTLoc_MedUnit",MURowId,CTMUDesc,desc)
          }
          else
          {
             s AliasFlag= 1   
          }
          if (($zcvt(CTMUCode,"U")[code)||(code=""))&(AliasFlag=1)&(tmpCTMUActiveFlag="Y")
          {
            d OutputRow2
          }
        }
      }
    }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(MURowId,CTMUCode,CTMUDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:删除限制
/// CreatDate:2015-12-30
/// Creator: sunfengchao
/// Return:1-被引用不可删除,0-未被引用可删除
/// Others:w ##class(web.DHCBL.CT.DHCCTLocMedUnit).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 s found1=0
 s CTLocDr=$p(id,"||",1)
 s CTMUChildsub=$p(id,"||",2)
 if ($d(^CTLOC(CTLocDr,"MU",CTMUChildsub,"CP"))'=0) 
 {
   s MUCPChildsub=0
   for
   {
     s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU",CTMUChildsub,"CP",MUCPChildsub))
     q:MUCPChildsub=""
     s MUCPDoctorDR=$p($g(^CTLOC(CTLocDr,"MU",CTMUChildsub,"CP",MUCPChildsub)),"^",1)
     if (MUCPDoctorDR="") continue 
     if (MUCPDoctorDR'="") s found1=1
   }
 }
 if (found1=1)  s myInfo=myInfo_"<关联医护人员>"
 if (myInfo="")
 {
   s return="0^可删除！"
 }
  else 
 {
   s return="1^在"_myInfo_"表里有数据,不能删除!"
 }
  q return
}

/// Function：代码，描述进行数据校验
/// Creator：基础数据平台组 sunfengchao
/// CreatDate: 2015-12-31
/// Input：id,code,desc
/// debug: w ##class(web.DHCBL.CT.DHCCTLocMedUnit).FormValidate("1","1||1","CK产科","")
ClassMethod FormValidate(ParRef As %String, id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	s hospid=""
	s:ParRef'="" hospid=$p($g(^CTLOC(ParRef)),"^",22)     //医院
	s CTLocDr=0
	for
	{
		s CTLocDr=$o(^CTLOC(CTLocDr)) q:((CTLocDr="")||(flag=1)) 
		s CTChildsub=0                                                                                 
		for
		{
			s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:((CTChildsub="")||(flag=1)) 
			s MURowId=CTLocDr_"||"_CTChildsub
			s CTMUCode=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",1)                   
			s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2) 
			if ($zcvt(CTMUCode,"U")=$zcvt(code,"U"))&&(MURowId'=id)
			{
				s flag=1
			}
			if ($zcvt(CTMUDesc,"U")=$zcvt(desc,"U"))&&(MURowId'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",CTLocDr,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Function: 双击时显示医疗单元信息
/// CreateDate:2015-12-30
/// Creator:基础数据平台组 sunfengchao 
/// Others:w ##Class(web.DHCBL.CT.DHCCTLocMedUnit).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
  s str=""
  s ParRef=$p(id,"||",1)
  s ChildSub=$p(id,"||",2)
  s eobj = ##class(web.Entity.CT.DHCCTLocMedUnit).%New()
  s eobj.CTLocDr=ParRef
  s eobj.CTMUCode=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",1)
  s eobj.CTMUDesc=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",2) 
  s eobj.CTMUActiveFlag=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",3)
  s:eobj.CTMUActiveFlag="Y" eobj.CTMUActiveFlag="true"
  s:(eobj.CTMUActiveFlag="N"||eobj.CTMUActiveFlag="") eobj.CTMUActiveFlag="false"
  s eobj.CTMUDateFrom=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",4)
  s:eobj.CTMUDateFrom'="" eobj.CTMUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMUDateFrom)
  s eobj.CTMUDateTo=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",5)
  s:eobj.CTMUDateTo'="" eobj.CTMUDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMUDateTo)
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Function: 双击时显示医疗单元信息 HISUI版用
/// CreateDate:2023-02-28
/// Creator:基础数据平台组 gss
/// Others:w ##Class(web.DHCBL.CT.DHCCTLocMedUnit).OpenData2("1")
ClassMethod OpenData2(id As %String) As %String
{
  s str=""
  s ParRef=$p(id,"||",1)
  s ChildSub=$p(id,"||",2)
  s eobj = ##class(web.Entity.CT.DHCCTLocMedUnit).%New()
  s eobj.CTLocDr=ParRef
  s eobj.CTMUCode=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",1)
  s eobj.CTMUDesc=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",2) 
  s eobj.CTMUActiveFlag=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",3)
  s eobj.CTMUDateFrom=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",4)
  s:eobj.CTMUDateFrom'="" eobj.CTMUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMUDateFrom)
  s eobj.CTMUDateTo=$p($g(^CTLOC(ParRef,"MU",ChildSub)),"^",5)
  s:eobj.CTMUDateTo'="" eobj.CTMUDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMUDateTo)
  s str = eobj.JsonS()
  q str
}

/// Function:删除数据
/// Creator: sunfengchao
/// CreateDate:2015-12-30
/// Debug:  w ##class(web.DHCBL.CT.DHCCTLocMedUnit).DeleleData("")
ClassMethod DeleteData(id As %String) As %String
{
  s result="",flag=""
  s re=##class(web.DHCBL.CT.DHCCTLocMedUnit).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
   s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
    Tstart
    s eobj = ##class(web.Entity.CT.DHCCTLocMedUnit).%New()
    s obj = ##class(User.DHCCTLocMedUnit).%OpenId(id)
    s eobj.MURowId=id
    s eobj.CTMUCode = obj.CTMUCode
    s eobj.CTMUDesc= obj.CTMUDesc
    s eobj.CTMUDateFrom = obj.CTMUDateFrom
    s eobj.CTMUDateTo=obj.CTMUDateTo
    s eobj.CTMUActiveFlag=obj.CTMUActiveFlag
    s eobj.CTMUCTLOCParRef=obj.CTMUCTLOCParRef
    s sc=##class(User.DHCCTLocMedUnit).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnit","User.DHCCTLocMedUnit","医疗单元",id,eobj.CTMUDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}" 
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗单元","web.DHCBL.CT.DHCCTLocMedUnit","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
    }
  }
    q result
}

/// Function:实现对数据的修改和保存操作
/// Creator: sunfengchao
/// CreateDate:2015-12-31
/// Tables: DHC_CTLoc_MedUnit
/// Desc:通过rowid来修改或保存规定资源信息
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
ClassMethod SaveEntity(rowid As %String, activeflag As %String, eobj As web.Entity.CT.DHCCTLocMedUnit) As %String
{
  s result=""
  s:eobj.CTMUDateFrom'="" eobj.CTMUDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTMUDateFrom)  
  s:eobj.CTMUDateTo'="" eobj.CTMUDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTMUDateTo)     
  s:eobj.CTMUDateFrom="" eobj.CTMUDateFrom=+$h
  
	s flag=..FormValidate(eobj.CTLocDr,rowid,eobj.CTMUCode,eobj.CTMUDesc)  //调用重复验证
	if (flag=1)
	{
	    s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
	  if (rowid="")       
	  {   
	   s obj=##class(User.DHCCTLocMedUnit).%New(eobj.CTLocDr)
	   s obj.CTMUCode = eobj.CTMUCode                      
	   s obj.CTMUDesc= eobj.CTMUDesc
	   d obj.CTMUCTLOCParRefSetObjectId(eobj.CTLocDr)
	   s obj.CTMUDateFrom=eobj.CTMUDateFrom
	   s obj.CTMUDateTo=eobj.CTMUDateTo
	   s:eobj.CTMUActiveFlag="" eobj.CTMUActiveFlag="N"
	   s:eobj.CTMUActiveFlag="false" eobj.CTMUActiveFlag="N"
	   s:eobj.CTMUActiveFlag="true" eobj.CTMUActiveFlag="Y" 
	   s obj.CTMUActiveFlag=eobj.CTMUActiveFlag
	   Tstart
	   s sc=obj.%Save()
	   if $$$ISOK(sc){
	    Tcommit
	    s id = obj.%Id()
	    s result = "{success:'true',id:'"_id_"'}"         
	    d:eobj.MURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnit","User.DHCCTLocMedUnit","医疗单元",id,eobj.CTMUDesc,"A",eobj)
	   }
	   else
	   {
	    Trollback
	    s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
	    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗单元","web.DHCBL.CT.DHCCTLocMedUnit","SaveEntity",eobj)
	    s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	   } 
	  }
	  else   
	  {
	    s obj=##class(User.DHCCTLocMedUnit).%OpenId(rowid)
	    s bobj=##class(web.Entity.CT.DHCCTLocMedUnit).%New()
	    s bobj.MURowId=rowid
	    s bobj.CTMUCode = obj.CTMUCode                     
	    s bobj.CTMUDesc= obj.CTMUDesc
	    s bobj.CTMUDateFrom=obj.CTMUDateFrom
	    s bobj.CTMUDateTo=obj.CTMUDateTo
	    s bobj.CTMUActiveFlag=obj.CTMUActiveFlag
	    s:bobj.CTMUActiveFlag="" bobj.CTMUActiveFlag="N" 
	    s bobj.CTLocDr= $p(rowid,"||",1)
	    
	   ;;  开始修改数据
	   s eobj.MURowId=rowid
	   s obj.CTMUCode = eobj.CTMUCode                      
	   s obj.CTMUDesc= eobj.CTMUDesc
	   d obj.CTMUCTLOCParRefSetObjectId(eobj.CTLocDr)
	   s obj.CTMUDateFrom=eobj.CTMUDateFrom
	   s obj.CTMUDateTo=eobj.CTMUDateTo
	   s:activeflag="false" activeflag="N",eobj.CTMUActiveFlag="N"
	   s:activeflag="" activeflag="N",eobj.CTMUActiveFlag="N"
	   s:activeflag="true" activeflag="Y" 
	   s obj.CTMUActiveFlag=activeflag
	   Tstart
	   s sc=obj.%Save()
	   if $$$ISOK(sc){
	    Tcommit
	    s result = "{success:'true',id:'"_rowid_"'}"         
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnit","User.DHCCTLocMedUnit","医疗单元",rowid,eobj.CTMUDesc,"U",eobj,bobj)
	   }
	   else
	   {
	    Trollback
	    s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
	    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗单元","web.DHCBL.CT.DHCCTLocMedUnit","SaveEntity",eobj)
	    s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	   } 
	 }
	}
 q result
}

}
