/// 创建日期：2013-09-03
/// 创建人：基础数据平台组 孙凤超
/// 功能： 电子病历-1 过敏原分类
/// 表： PAC_Allergy
Class web.DHCBL.CT.MRCAllType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询过敏原分类
/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  MRC_AllType 
/// Input: rowid, code, desc 
/// Output: MRCATRowId MRCATCode MRCATDesc MRCATTagDescription MRCATDateFrom MRCATDateTo
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCAllType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, cancel As %String) As %Query(ROWSPEC = "MRCATRowId,MRCATCode,MRCATDesc,MRCATTagDescription,MRCATDateFrom,MRCATDateTo, BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, cancel As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1  
   s AuStr= ##class(web.DHCBL.Authorize.MRCAllType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
   if (rowid'="")  
   {
     s MRCATRowId=rowid
     s MRCATCode=$p($g(^MRC("AT",rowid)),"^",1)
     s MRCATDesc=$p($g(^MRC("AT",rowid)),"^",2)
     s MRCATTagDescription=$p($g(^MRC("AT",rowid)),"^",6)
     s TagID=""
     s:MRCATTagDescription'="" TagID=$o(^websys.StandardTypeD("STD","AllergenTag","ITM",0,"Code",MRCATTagDescription,0))
     s:TagID'="" MRCATTagDescription=$p($g(^websys.StandardTypeD("STD","AllergenTag","ITM",TagID)),"^",3)
 
     s MRCATDateFrom=$p($g(^MRC("AT",rowid)),"^",9)
     s:MRCATDateFrom'="" MRCATDateFrom=$zd(MRCATDateFrom,1)
     s MRCATDateTo=$p($g(^MRC("AT",rowid)),"^",10)
     s:MRCATDateTo'="" MRCATDateTo=$zd(MRCATDateTo,1) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_AllType",MRCATRowId)
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
     s MRCATRowId=0
     s BDPStandardRowId="",MRCATTagDescriptionI=""
     for
     {  
        s MRCATRowId=$o(^MRC("AT",MRCATRowId)) q:MRCATRowId=""   
        s strMRCATRowId="{ID:"_MRCATRowId_"}"
        if (AuStr[strMRCATRowId)||(AuFlag=1) 
        { 
            s MRCATCode=$p($g(^MRC("AT",MRCATRowId)),"^",1)
            s MRCATDesc=$p($g(^MRC("AT",MRCATRowId)),"^",2) 
            s MRCATTagDescription=$p($g(^MRC("AT",MRCATRowId)),"^",6)
            s MRCATTagDescriptionI=MRCATTagDescription
            s TagID=""
            s:MRCATTagDescription'="" TagID=$o(^websys.StandardTypeD("STD","AllergenTag","ITM",0,"Code",MRCATTagDescription,0))
            s:TagID'="" MRCATTagDescription=$p($g(^websys.StandardTypeD("STD","AllergenTag","ITM",TagID)),"^",3)
     
            s MRCATDateFrom=$p($g(^MRC("AT",MRCATRowId)),"^",9)
            s:MRCATDateFrom'="" MRCATDateFrom=$zd(MRCATDateFrom,1)
            s MRCATDateTo=$p($g(^MRC("AT",MRCATRowId)),"^",10)
            s:MRCATDateTo'="" MRCATDateTo=$zd(MRCATDateTo,1)
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_AllType",MRCATRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc =$p($g(resultStr),"^",4)  
            if (desc'="")
            {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_AllType",MRCATRowId,MRCATDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }    
            
            if ($ZCVT(MRCATCode,"U")[code)&(AliasFlag=1)&((MRCATTagDescriptionI=cancel)||(cancel=""))  
            {
                d OutputRow
            }
        }
     }
  }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MRCATRowId,MRCATCode,MRCATDesc,MRCATTagDescription,MRCATDateFrom,MRCATDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalDesc,BDPHospNationalCode)
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

/// Function:进行数据检索，为查询过敏原分类 提供接口
/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: MRC_AllType
/// Input: rowid, code ，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCAllType", "GetDataForCmb1","","","") 
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "MRCATRowId:%String, MRCATCode:%String, MRCATDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U") 
   s AuStr=##class(web.DHCBL.Authorize.MRCAllType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   if (rowid'="")  
   {
     s MRCATRowId=rowid
     s MRCATCode=$p($g(^MRC("AT",rowid)),"^",1)
     s MRCATDesc=$p($g(^MRC("AT",rowid)),"^",2)
     d OutputRowCmb
   }
   else
   {
     s MRCATRowId=0
     for
     {  
        s MRCATRowId=$o(^MRC("AT",MRCATRowId)) q:MRCATRowId=""  
        s MRCATDateFrom=$p($g(^MRC("AT",MRCATRowId)),"^",9)
        continue:(MRCATDateFrom'="")&&(MRCATDateFrom>+$h) 
        s MRCATDateTo=$p($g(^MRC("AT",MRCATRowId)),"^",10) 
        continue:(MRCATDateTo'="")&&(MRCATDateTo<+$h) 
        s strMRCATRowId="{ID:"_MRCATRowId_"}"
        if (AuStr[strMRCATRowId)||(AuFlag=1) 
        { 
          s MRCATCode=$p($g(^MRC("AT",MRCATRowId)),"^",1)
          s MRCATDesc=$p($g(^MRC("AT",MRCATRowId)),"^",2)
          if (desc'="")
          {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_AllType",MRCATRowId,MRCATDesc,desc)
          }
          else
          {
              s AliasFlag= 1   
          }    
          if ($ZCVT(MRCATCode,"U")[code)&(AliasFlag=1)   
          {
            d OutputRowCmb
          }
        }
     }
   }
  
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(MRCATRowId,MRCATCode,MRCATDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:  查询过敏类型
/// CreateDate:2017-02-28
/// Creator:   基础数据平台公共产品组 sunfengchao
/// Tables:    websys.StandardTypeItem
/// Input:     rowid, code ，desc
/// Others:    w ##class(web.DHCBL.CT.MRCAllType).GetSelectItems()
ClassMethod GetSelectItems() As %String
{
 s result="",ID=0
 s count=0
 ;;zw ^websys.StandardTypeD("STD","AllergenTag")
 for 
 {
    s ID=$o(^websys.StandardTypeD("STD","AllergenTag","ITM",ID))
    q:ID=""
    s count=count+1
    s Description=$p($g(^websys.StandardTypeD("STD","AllergenTag","ITM",ID)),"^",3)
    s StoredValue=$p($g(^websys.StandardTypeD("STD","AllergenTag","ITM",ID)),"^",1)
    if (result="")
    {
        s result="{rowid:'"_ID_"',Description:'"_Description_"',StoredValue:'"_StoredValue_"'}"
    }
    else
    {
        s result=result_","_"{rowid:'"_ID_"',Description:'"_Description_"',StoredValue:'"_StoredValue_"'}"
    }
 }
 s result= "{""success"":""true"",""data"":["_result_"],"_"""total"":"""_count_""""_"}"
 q result
}

/// CreateDate:2013-09-03
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: MRC_AllType
/// Others: w ##Class(web.DHCBL.CT..MRCAllType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
   s str=""
   s pobj = ##class(User.MRCAllType).%OpenId(id)
   s eobj = ##class(web.Entity.CT.MRCAllType).%New()
   s eobj.MRCATRowId = id
   s eobj.MRCATCode=pobj.MRCATCode
   s eobj.MRCATDesc= pobj.MRCATDesc
   s eobj.MRCATTagDescription=pobj.MRCATTagDescription 
   s:pobj.MRCATDateFrom'="" eobj.MRCATDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.MRCATDateFrom)    
   s:pobj.MRCATDateTo'="" eobj.MRCATDateTo =  ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.MRCATDateTo)
  
   d pobj.%Close()
   k pobj
   s str = eobj.JsonS()
   s str = "{list:["_str_"]}"
   q str
}

/// Creator:基础数据平台组 孙凤超
/// CreatDate:2013-9-17
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Others:w ##class(web.DHCBL.CT.MRCAllType).GetRefFlag("02")
ClassMethod GetRefFlag(id As %String) As %String
{
   s found1=0, ALGRowId=0
   s return="",myInfo=""
   for
   {  
    s ALGRowId=$o(^PAC("ALG",ALGRowId))
    q:ALGRowId=""  
    q:found1=1
    s ALGTypeDR=$p($g(^PAC("ALG",ALGRowId)),"^",3)
    if (ALGTypeDR=id) s found1=1
   }
    if (found1=1)  s myInfo=myInfo_"<过敏原>"
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

/// Function:实现对过敏原分类的删除操作
/// Creator:孙凤超
/// CreateDate:2013-09-03
/// Desc:通过rowid来删除过敏原分类的信息
/// Input: id
/// Output:success:'true',info:'删除成功！ 失败时输出删除失败！
/// Tables:  MRC_AllType
/// Others:do ##class(web.DHCBL.CT.MRCAllType).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="" ,RefFlag=""   
   s re=##class(web.DHCBL.CT.MRCAllType).GetRefFlag(id)  
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {
     Tstart
     s pobj = ##class(User.MRCAllType).%OpenId(id)
     s eobj = ##class(web.Entity.CT.MRCAllType).%New()
     s eobj.MRCATRowId = id
     s eobj.MRCATCode=pobj.MRCATCode
     s eobj.MRCATDesc= pobj.MRCATDesc
     s eobj.MRCATTagDescription=pobj.MRCATTagDescription 
     s:pobj.MRCATDateFrom'="" eobj.MRCATDateFrom =pobj.MRCATDateFrom    
     s:pobj.MRCATDateTo'="" eobj.MRCATDateTo = pobj.MRCATDateTo
     s sc= ##class(User.MRCAllType).%DeleteId(id)
     if (sc=1)
     {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_AllType","User.MRCAllType","过敏原分类",id,eobj.MRCATDesc,"D",eobj)
       d eobj.%Close()
      }
      else
      {
       Trollback
       s result= "{success:'false',info:'删除失败!'}" 
       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原分类","web.DHCBL.CT.MRCAllType","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
      } 
   }
   q result
}

/// Function:实现对过敏原分类 数据重复校验
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-09-03
/// Tables： MRC_AllType
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd="" 
 s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
 s:code'="" flagc=$d(^MRC("AT",0,"Code",code))
 s:desc'="" flagd=$d(^MRC("AT",0,"MRCAA_Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0))
  {
   s flag=1  //返回重复标志
  }
  else
  {
   s flag=0 //返回不重复标志
  }
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^MRC("AT",0,"Code",code,0))
  s:desc'="" idd=$o(^MRC("AT",0,"MRCAA_Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  else
  {
   if (code="")
   {
    if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
   else
   {
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function:实现对过敏原分类的修改和保存操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-09-3
/// Function: 通过rowid来修改或保存规定资原信息
/// Output: success:'true',info:'添加成功！' 修改成功时输出修改成功！
///         success:'false',info:'添加失败' 修改失败时输出修改失败！
/// Tables:  MRC_AllType
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCAllType) As %String
{
  s result=""
  s:eobj.MRCATDateFrom'="" eobj.MRCATDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MRCATDateFrom)   
  s:eobj.MRCATDateTo'="" eobj.MRCATDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MRCATDateTo)       
  s:eobj.MRCATDateFrom="" eobj.MRCATDateFrom=+$h
  if (eobj.MRCATRowId="")       
  {   
    s obj=##class(User.MRCAllType).%New()
  }
  else  //如果RowId已赋值则修改
  {
   s obj=##class(User.MRCAllType).%OpenId(eobj.MRCATRowId)
   s bobj=##class(web.Entity.CT.MRCAllType).%New()
   s bobj.MRCATRowId=eobj.MRCATRowId
   s bobj.MRCATCode = obj.MRCATCode                    
   s bobj.MRCATDesc= obj.MRCATDesc
   s bobj.MRCATTagDescription=obj.MRCATTagDescription
   s bobj.MRCATDateFrom=obj.MRCATDateFrom
   s bobj.MRCATDateTo=obj.MRCATDateTo
  }
   s obj.MRCATCode = eobj.MRCATCode                   
   s obj.MRCATDesc= eobj.MRCATDesc
   if (eobj.MRCATTagDescription'="")   
   {                 
     S:eobj.MRCATTagDescription="Generic" eobj.MRCATTagDescription="G"
     S:eobj.MRCATTagDescription="Pharmacy Item" eobj.MRCATTagDescription="P"
     s:eobj.MRCATTagDescription="Ingredient" eobj.MRCATTagDescription="I"
    }
   else
   {
     s eobj.MRCATTagDescription=""
   }
   s obj.MRCATTagDescription=eobj.MRCATTagDescription
   s obj.MRCATDateFrom=eobj.MRCATDateFrom
   s obj.MRCATDateTo=eobj.MRCATDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.MRCATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_AllType","User.MRCAllType","过敏原分类",eobj.MRCATRowId,eobj.MRCATDesc,"U",eobj,bobj)
    d:eobj.MRCATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_AllType","User.MRCAllType","过敏原分类",id,eobj.MRCATDesc,"A",eobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原分类","web.DHCBL.CT.MRCAllType","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
  }
 q result
}

}
