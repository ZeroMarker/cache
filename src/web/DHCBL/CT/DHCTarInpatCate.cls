/// Function:　计费组 住院费用子类 业务类
/// Creator:   sunfengchao
/// CreateDate:2016-12-3
/// Table:     DHC_TarInpatCate
Class web.DHCBL.CT.DHCTarInpatCate Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarInpatCate";

/// Function:查询住院费用子类
/// CreateDate:2016-12-2
/// Creator:基础数据平台 sunfengchao
/// Table:  DHC_TarInpatCate
/// Input:  rowid, code, desc 
/// Output: TARIC_RowId  TARIC_Code  TARIC_Desc  TARIC_TARTIC_DR
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarInpatCate", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, taricdr As %String, hospid As %String) As %Query(ROWSPEC = "TARICRowId:%String,TARICCode:%String,TARICDesc:%String,TARICTARTICDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, taricdr As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s ret=0
  s AuStr=##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARICRowId=rowid
    s TARICCode=$p($g(^DHCTarC("IC",rowid)),"^",1)
    s TARICDesc=$p($g(^DHCTarC("IC",rowid)),"^",2)
    s TARICTARTICDR=$p($g(^DHCTarC("IC",rowid)),"^",3)
    if ((TARICTARTICDR'="")&&($d(^DHCTarC("TIC",TARICTARTICDR))>0))
    {
      s TARICTARTICDR=$p($g(^DHCTarC("TIC",TARICTARTICDR)),"^",2)
    }
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarInpatCate",TARICRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    d OutputRow
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARICRowId=0
   for
   { 
    s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) 
    q:TARICRowId=""    
    s strTARICRowId="{ID:"_TARICRowId_"}"
    if (AuStr[strTARICRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARICRowId,hospid)
		continue:showflag="N"
	  
      s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
      s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2) 
      s TARICTARTICDR=$p($g(^DHCTarC("IC",TARICRowId)),"^",3) 
      ;w TARICRowId_" "_TARICDesc _" "_TARICTARTICDR b ;;
      s TARCRowId=TARICTARTICDR
      if ((TARICTARTICDR'="")&&($d(^DHCTarC("TIC",TARICTARTICDR))>0))
      {
        s TARICTARTICDR=$p($g(^DHCTarC("TIC",TARICTARTICDR)),"^",2)
      }
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarInpatCate",TARICRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARICDesc)   
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarInpatCate",TARICRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (($ZCVT(TARICCode,"U")[code))&(($ZCVT(TARICDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc)&((taricdr="")||(TARCRowId=taricdr)))  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARICRowId,TARICCode,TARICDesc,TARICTARTICDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   为combo提供查询入院费用子类的接口
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 孙凤超
/// Tables:     DHC_TarInpatCate
/// Input:      desc
/// Output:     TARIC_RowId   TARIC_Desc 
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarInpatCate","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "TARICRowId:%String, TARICCode:%String,TARICDesc:%String ")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s AuStr= ##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {  
    s TARICRowId=rowid
    s TARICCode=$p($g(^DHCTarC("IC",rowid)),"^",1)
    s TARICDesc=$p($g(^DHCTarC("IC",rowid)),"^",2)
    d OutputRowCmb
  }
  else
 {
   s:code'="" code=$ZCVT(code,"U") 
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARICRowId=0
   for
   { 
    s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) 
    q:TARICRowId=""    
    s strTARICRowId="{ID:"_TARICRowId_"}"
    if (AuStr[strTARICRowId)||(AuFlag=1)
    {
	  s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARICRowId,hospid)
		continue:showflag="N"
	  
      s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
      s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2)
      s AliasRowId=0,ALIASText1=""
      for
      {
         s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_TarInpatCate",TARICRowId,AliasRowId))
         q:AliasRowId=""
         S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         ; 查询出对应rowid下的所有别名，用"^"进行连接
         s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      }
      s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARICDesc)  
      if (($ZCVT(TARICCode,"U")[code))&(($ZCVT(TARICDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc))  
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(TARICRowId,TARICCode,TARICDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   双击修改时的数据加载 
/// CreateDate: 2016-12-2
/// Creator:    基础数据平台 sunfengchao
/// Input:      id 
/// Others:     w ##class(web.DHCBL.CT.DHCTarInpatCate).OpenData("2") 
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCTarInpatCate).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCTarInpatCate).%New()
 s eobj.TARICRowId = id
 S eobj.TARICCode=pobj.TARICCode
 s eobj.TARICDesc= pobj.TARICDesc
 if $IsObject(pobj.TARICTARTICDR) {
		s eobj.TARICTARTICDR=pobj.TARICTARTICDR.%Id()
	}
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   用于删除时的逻辑判断 
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-11-8
/// Debug:      w ##class(web.DHCBL.CT.DHCTarInpatCate).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
     s return="", myInfo=""
     s found1=0
     if ($d( ^DHCTARI(0,"IC",+id)))  s found1=1
     if (found1=1)  s myInfo=myInfo_"<收费项目>"
     if (myInfo="")
    {
      s return="0^未被引用可删除！"
    }
     else 
    {
      s return="1^在"_myInfo_"表里被引用,不能删除!"
    }
     q return
}

/// Function:   实现删除操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2 
/// Output:     success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:     DHC_TarInpatCate
/// Others:     d ##class(web.DHCBL.CT.DHCTarInpatCate).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
     s result="",flag=""
     s re=..GetRefFlag(id)
     s RefFlag=$p(re,"^",1)
     if (RefFlag=1)
     { 
        s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
     }
	 else
	 {
	     
	     s pobj = ##class(User.DHCTarInpatCate).%OpenId(id)
	     s eobj = ##class(web.Entity.CT.DHCTarInpatCate).%New()
	     s eobj.TARICRowId = id
	     s eobj.TARICCode=pobj.TARICCode
	     s eobj.TARICDesc= pobj.TARICDesc
	     if $IsObject(pobj.TARICTARTICDR) {
				s eobj.TARICTARTICDR=pobj.TARICTARTICDR.%Id()
			}
		 Tstart
	     s sc=##class(User.DHCTarInpatCate).%DeleteId(id)
	     if $$$ISOK(sc)
	     {
	       Tc
	       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarInpatCate","User.DHCTarInpatCate","住院费用子类",id,eobj.TARICDesc,"D",eobj)
	       s result="{success:'true',info:'删除成功！'}"
	       d eobj.%Close()
	     }
	     else
	     {
	       Trollback
	       s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
	       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用子类","web.DHCBL.CT.DHCTarInpatCate","DeleteData",eobj)
	       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	     }
     } 
    q result
}

/// Function:   实现对收费项目子类修改增加操作
/// Creator:    基础数据平台 sunfengchao
/// CreateDate: 2016-12-2
/// Output:     success:'true',info:'添加成功！' 失败时输出添加失败！
/// Tables:     DHC_TarInpatCate
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarInpatCate) As %String
{
  ;s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
  {
	  s flag=..FormValidate(eobj.TARICRowId,eobj.TARICCode,eobj.TARICDesc,eobj.LinkHospId)  //调用重复验证
	  if (flag=1)
	  {
		  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	  }
	  else
	  {
		  if (eobj.TARICRowId="")  
		  {    
		    s obj=##class(User.DHCTarInpatCate).%New() 
		  }   
		  else  
		  { 
		   s obj=##class(User.DHCTarInpatCate).%OpenId(eobj.TARICRowId)
		   s bobj=##class(web.Entity.CT.DHCTarInpatCate).%New() 
		   s bobj.TARICRowId=eobj.TARICRowId
		   s bobj.TARICCode = obj.TARICCode                      
		   s bobj.TARICDesc= obj.TARICDesc                     
		   if $IsObject(obj.TARICTARTICDR) {
				s bobj.TARICTARTICDR=obj.TARICTARTICDR.%Id()
			}
		  }
		   s obj.TARICCode = eobj.TARICCode                      
		   s obj.TARICDesc= eobj.TARICDesc                     
		   d obj.TARICTARTICDRSetObjectId(eobj.TARICTARTICDR)
		   Tstart
		   s sc=obj.%Save()
		   if $$$ISOK(sc)
		   {
		       Tcommit
		       s id = obj.%Id()
		       s result = "{success:'true',id:'"_id_"'}"        
		       d:eobj.TARICRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarInpatCate","User.DHCTarInpatCate","住院费用子类",eobj.TARICRowId,eobj.TARICDesc,"U",eobj,bobj)
		       d:eobj.TARICRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarInpatCate","User.DHCTarInpatCate","住院费用子类",id,eobj.TARICDesc,"A",eobj)
		   }
		   else
		   {
		       Trollback
		       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
		       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用子类","web.DHCBL.CT.DHCTarInpatCate","SaveEntity",eobj)
		       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		   }
   	   }
   }
   else
   {
	  s result = "{success:'false',errorinfo:'对象不存在！'}"
   }
 q result
 ;ERROR
 ;s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院费用子类","web.DHCBL.CT.DHCTarInpatCate","SaveEntity",eobj)
 ;s ^ERRORLOGINFO(logid)=$ze
 ;q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      DHC_TarInpatCate
/// Debug:      w ##class(web.DHCBL.CT.DHCTarInpatCate).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCTarC("IC",0,"Code",code,idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	
	if desc'=""
	{
		s idd=0
		for
		{
	
			s idd=$o(^DHCTarC("IC",0,"Desc",desc,idd)) q:idd=""
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

}
