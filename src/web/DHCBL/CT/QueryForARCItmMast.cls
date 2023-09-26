Import SQLUSER

/// Function: 为 医嘱项里的combox 查询数据
/// CreateDate: 2014-8-22
/// Creator:   sunfengchao
Class web.DHCBL.CT.QueryForARCItmMast Extends %RegisteredObject
{

/// Function: 药物查找
/// CreateDate: 2013-8-22 
/// Creator:  sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","GetDrugList","","","")
Query GetDrugList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDRowId:%String,PHCDCode:%String,PHCDName:%String")
{
}

ClassMethod GetDrugListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") 
 {
   s PHCDRowId=rowid
   s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
   s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
   d OutputRow
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
   s PHCDRowId=0
   for
   {
      s PHCDRowId=$o(^PHCD(PHCDRowId))
      q:(PHCDRowId="")||(PHCDRowId="DF_Form")
      s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
      s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
      continue:(PHCDCode="")||(PHCDName="") //屏蔽垃圾数据
      s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCDName)
      if ($ZCONVERT(PHCDCode,"U")[code)&(($ZCONVERT(PHCDName,"U")[desc) ||(PINYIN[desc) )
      {
        d OutputRow
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PHCDRowId,PHCDCode,PHCDName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugListExecute ]
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

/// Function:其他明细中的药物combox
/// CreateDate: 2014-8-22
/// Creator: sunfengchao
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","drugmast","","","","","","")
ClassMethod drugmast(start, limit, sort, dir, callback, drugdesc) As %String
{
 
 If $g(drugdesc)'="" Do
 .Set ConExp="'%"_drugdesc_"%'" 
 .Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm where PHCDF_PHCD_ParRef->PHCD_Name like"_"  "_ConExp
 Else  Do
 .Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm"
 
 
 //排序
 s strSort=""
 s sortField=""
 
 i sort'="" d
 .i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
 .i sort="code"  s sortField="PHCD_Code"
 .i sort="desc"  s sortField="PHCD_Name"
 
 i sortField'="" d
 .s dir=$ZCONVERT(dir,"U")
 .i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
 .e  s strSort=" ORDER BY "_sortField_" DESC"
 e  d
 .s strSort=" ORDER BY %ID DESC"
 s strSql=strSql_strSort
 
 
 s result=##class(%Library.ResultSet).%New()
 
 d result.Prepare(strSql)
 d result.Execute()
 
 s count=0
 s strResult=""
 s drgform="[,'']"
 s end=start+limit
 
 While(result.Next())
 {
  s rowid=result.Data("PHCDF_PHCD_ParRef")
  s code=##class(ext.util.String).EvalJSON(result.Data("PHCD_Code"))
  s desc=##class(ext.util.String).EvalJSON(result.Data("PHCD_Name"))

  s count=count+1
  
  i (count>start) & (count<=end) d
   .i strResult'="" d
   ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
   .e  d
   ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
 }
 
 d result.Close()
 
 i callback'="" d
 .s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
 e  d
 .s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
 
 q strResult
}

/// Function:其他明细中的药物形态combox
/// CreateDate: 2014-8-23
/// Creator: sunfengchao
ClassMethod drugform(start, limit, sort, dir, callback, drugformrowid) As %String
{
 s strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCF_DR->PHCF_Code,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm  where  PHCDF_PHCD_ParRef="_drugformrowid
 //排序
 s strSort=""
 s sortField=""
 
 i sort'="" d
 .i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
 .i sort="code"  s sortField="PHCF_Code"
 .i sort="desc"  s sortField="PHCF_Desc"
 
 i sortField'="" d
 .s dir=$ZCONVERT(dir,"U")
 .i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
 .e  s strSort=" ORDER BY "_sortField_" DESC"
 e  d
 .s strSort=" ORDER BY %ID DESC"
 s strSql=strSql_strSort
 
 
 s result=##class(%Library.ResultSet).%New()
 
 d result.Prepare(strSql)
 d result.Execute()
 
 s count=0
 s strResult=""
 s end=start+limit
 
 While(result.Next())
 {
  s rowid=result.Data("PHCDF_PHCD_ParRef")
  s code=##class(ext.util.String).EvalJSON(result.Data("PHCF_Code"))
  s desc=##class(ext.util.String).EvalJSON(result.Data("PHCF_Desc"))
  
  s count=count+1
  
  i (count>start) & (count<=end) d
   .i strResult'="" d
   ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
   .e  d
   ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
 }
 
 d result.Close()
 
 i callback'="" d
 .s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
 e  d
 .s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
 
 q strResult
}

//*******************************以下 关联零收费项*************** / 

/// Function: 关联零收费项-收费项目子类   TARISubCate As User.DHCTarSubCate
/// CreateDate: 2016-4-12 陈莹
/// Table:User.DHCTarSubCate    
/// Creator: sunfengchao
/// Debug:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","chargesubcat","","","")
Query chargesubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARSCRowId:%String,TARSCCode:%String,TARSCDesc:%String")
{
}

ClassMethod chargesubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TARSCRowId=rowid
  s TARSCCode=$p($g(^DHCTarC("SC",TARSCRowId)),"^",1)
  s TARSCDesc=$p($g(^DHCTarC("SC",TARSCRowId)),"^",2)
  d OutputRowTARSC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TARSCRowId=0
  f  s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId)) q:TARSCRowId=""  d
  .s TARSCCode=$p($g(^DHCTarC("SC",TARSCRowId)),"^",1)
  .s TARSCDesc=$p($g(^DHCTarC("SC",TARSCRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARSCDesc)
  .i ($ZCONVERT(TARSCCode,"U")[code)&(($ZCONVERT(TARSCDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTARSC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTARSC
    set Data=$lb(TARSCRowId,TARSCCode,TARSCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod chargesubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = chargesubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod chargesubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = chargesubcatExecute ]
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

/// Function:   关联零收费项-住院子分类 combox
/// CreateDate: 2014-8-23    
/// Table : User.DHCTarInpatCate
/// Creator:    sunfengchao
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","inpatsubcat","","","")
Query inpatsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARICRowId:%String,TARICCode:%String,TARICDesc:%String")
{
}

ClassMethod inpatsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TARICRowId=rowid
  s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
  s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2)
  d OutputRowTARIC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TARICRowId=0
  f  s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""  d
  .s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
  .s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARICDesc)
  .i ($ZCONVERT(TARICCode,"U")[code)&(($ZCONVERT(TARICDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTARIC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTARIC
    set Data=$lb(TARICRowId,TARICCode,TARICDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod inpatsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = inpatsubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod inpatsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = inpatsubcatExecute ]
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

/// Function:   关联零收费项-门诊子分类combox
/// CreateDate: 2013-8-22   User.DHCTarOutpatCate
/// Creator:    by sunfengchao
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","outpatsubcat","","","")
Query outpatsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TAROCRowId:%String,TAROCCode:%String,TAROCDesc:%String")
{
}

ClassMethod outpatsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TAROCRowId=rowid
  s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
  s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2)
  d OutputRowTAROC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TAROCRowId=0
  f  s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId)) q:TAROCRowId=""  d
  .s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
  .s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TAROCDesc)
  .i ($ZCONVERT(TAROCCode,"U")[code)&(($ZCONVERT(TAROCDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTAROC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTAROC
    set Data=$lb(TAROCRowId,TAROCCode,TAROCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod outpatsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outpatsubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod outpatsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outpatsubcatExecute ]
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

/// Function: 关联零收费项-病案首页子分类combox
/// CreateDate:2014-8-23   User.DHCTarMRCate
/// Creator:   by sunfengchao
/// Debug:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","mrsubcat","","","")
Query mrsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARMCRowId:%String,TARMCCode:%String,TARMCDesc:%String")
{
}

ClassMethod mrsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TARMCRowId=rowid
  s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
  s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2)
  d OutputRowTARMC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TARMCRowId=0
  f  s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) q:TARMCRowId=""  d
  .s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
  .s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARMCDesc)
  .i ($ZCONVERT(TARMCCode,"U")[code)&(($ZCONVERT(TARMCDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTARMC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTARMC
    set Data=$lb(TARMCRowId,TARMCCode,TARMCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod mrsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = mrsubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod mrsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = mrsubcatExecute ]
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

/// Function: 关联零收费项-新病案首页子分类combox
/// CreateDate:2014-8-23  DHCTarC("MCNew")
/// Creator: by sunfengchao
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","GetMCNew","","","")
Query GetMCNew(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "NTARMCRowId:%String,NTARMCCode:%String,NTARMCDesc:%String")
{
}

ClassMethod GetMCNewExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s NTARMCRowId=rowid
  s NTARMCCode=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",1)
  s NTARMCDesc=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",2)
  d OutputRowMCNew
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s NTARMCRowId=0
  f  s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId)) q:NTARMCRowId=""  d
  .s NTARMCCode=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",1)
  .s NTARMCDesc=$p($g(^DHCTarC("MCNew",NTARMCRowId)),"^",2)
  .s PINYIN=""
  .s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(NTARMCDesc)
  .i ($ZCONVERT(NTARMCCode,"U")[code)&(($ZCONVERT(NTARMCDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowMCNew
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowMCNew
    set Data=$lb(NTARMCRowId,NTARMCCode,NTARMCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetMCNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMCNewExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetMCNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMCNewExecute ]
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

/// Function:   关联零收费项-收费会计子分类combox
/// CreateDate: 2013-8-23  User.DHCTarAcctCate
/// Creator:    by sunfengchao 
/// Debugs :    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","acctsubcat","","","")
Query acctsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARACRowId:%String,TARACCode:%String,TARACDesc:%String")
{
}

ClassMethod acctsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TARACRowId=rowid
  s TARACCode=$p($g(^DHCTarC("AC",TARACRowId)),"^",1)
  s TARACDesc=$p($g(^DHCTarC("AC",TARACRowId)),"^",2)
  d OutputRowTARAC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TARACRowId=0
  f  s TARACRowId=$o(^DHCTarC("AC",TARACRowId)) q:TARACRowId=""  d
  .s TARACCode=$p($g(^DHCTarC("AC",TARACRowId)),"^",1)
  .s TARACDesc=$p($g(^DHCTarC("AC",TARACRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARACDesc)
  .i ($ZCONVERT(TARACCode,"U")[code)&(($ZCONVERT(TARACDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTARAC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTARAC
    set Data=$lb(TARACRowId,TARACCode,TARACDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod acctsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = acctsubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod acctsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = acctsubcatExecute ]
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

/// Function:   关联零收费项-经济核算子分类combox
/// CreateDate: 2013-8-22   User.DHCTarEMCCate
/// Creator:   by sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","emcsubcat","","","")
Query emcsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARECRowId:%String,TARECCode:%String,TARECDesc:%String")
{
}

ClassMethod emcsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TARECRowId=rowid
  s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
  s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2)
  d OutputRowTAREC
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TARECRowId=0
  f  s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) q:TARECRowId=""  d
  .s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
  .s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2)
  .s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARECDesc)
  .i ($ZCONVERT(TARECCode,"U")[code)&(($ZCONVERT(TARECDesc,"U")[desc)||(PINYIN[desc)) d
  ..d OutputRowTAREC
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTAREC
    set Data=$lb(TARECRowId,TARECCode,TARECDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod emcsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = emcsubcatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod emcsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = emcsubcatExecute ]
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

//******以上*** 关联零收费项**********************************//

/// Function: 用于"收费项"放大镜
/// CreateDate: 2014-8-23
/// Creator:  by sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","TaritemList","","")
Query TaritemList(tarcode As %String, tarname As %String) As %Query(ROWSPEC = "tarirowid:%String:收费项目ID, taricode:%String:收费项目代码, taridesc:%String:收费项目名称, ItmPrice:%String:价格(元), tariuom:%String:单位")
{
}

ClassMethod TaritemListExecute(ByRef qHandle As %Binary, tarcode As %String = "", tarname As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s HOSPtalID=%session.Get("LOGON.HOSPID") 
	s tarcode=$ZCONVERT(tarcode,"U")
	S tarname=$ZCONVERT(tarname,"U")
	Set trowid=0
	For
	{
		Set trowid=$o(^DHCTARI(trowid))
		Quit:trowid=""
		Set tcode=$P($g(^DHCTARI(trowid)),"^",1) 
		Set tdesc=$P($g(^DHCTARI(trowid)),"^",2)
		Set tariuom=$P($g(^DHCTARI(trowid)),"^",3) 
		Set:tariuom'="" tariuom=$P($g(^CT("UOM",tariuom)),"^",2)   
		Set TARIActiveFlag=$P($g(^DHCTARI(trowid)),"^",7)
		Set TARIEndDate=$P($g(^DHCTARI(trowid)),"^",12)
		s aliaid=0
		s AFlag=0

		if tarname'=""
		{
			for 
			{
				Set aliaid=$o(^DHCTARAL("A",trowid,aliaid)) q:aliaid=""
				Set talias=$P(^DHCTARAL(aliaid),"^",3)
				if ($ZCONVERT(talias,"U")[tarname)
				{
					s AFlag=1
					q
				}
			}
		}
		s PINYIN=""
		s:tarname'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(tdesc)
		If ((TARIActiveFlag="Y")&((tarcode="")||($ZCONVERT(tcode,"U")[tarcode))&((tarname="")||(($ZCONVERT(tdesc,"U")[tarname))||((PINYIN[tarname))||(AFlag=1)))&((TARIEndDate="")||((TARIEndDate'="")&(TARIEndDate>+$h)))
		{
			s ItmPrice=""
			s ItmPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(trowid,HOSPtalID)
			Do OutputRowTARI
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
OutputRowTARI
 set Data=$lb(trowid,tcode,tdesc,ItmPrice,tariuom)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod TaritemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TaritemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { 
     // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
 }
 Else      {
  // fetch row
  Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod TaritemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TaritemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function: OEC_ResultDisplayGroup  查找
/// CreateDate: 2015-1-12 
/// Creator:  sunfengchao
/// GetResultDisplayGroupList
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","GetRDGroupList","","","")
Query GetRDGroupList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RESDGRPRowId:%String,RESDGRPCode:%String,RESDGRPDesc:%String")
{
}

ClassMethod GetRDGroupListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") 
 { 
   s RESDGRPRowId=rowid
   s RESDGRPCode=$p($g(^OEC("RESDGRP",RESDGRPRowId)),"^",1)
   s RESDGRPDesc=$p($g(^OEC("RESDGRP",RESDGRPRowId)),"^",2)
   d OutputRowRDGroup
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U")  
   s:desc'="" desc=$ZCONVERT(desc,"U")  
   s RESDGRPRowId=0
   for
   {
      s RESDGRPRowId=$o(^OEC("RESDGRP",RESDGRPRowId))
      q:(RESDGRPRowId="")
      s RESDGRPCode=$p($g(^OEC("RESDGRP",RESDGRPRowId)),"^",1)
      s RESDGRPDesc=$p($g(^OEC("RESDGRP",RESDGRPRowId)),"^",2)
      s PINYIN=""
      s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(RESDGRPDesc)
      if ($ZCONVERT(RESDGRPCode,"U")[code)&(($ZCONVERT(RESDGRPDesc,"U")[desc) ||(PINYIN[desc))
      {
        d OutputRowRDGroup
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowRDGroup
    set Data=$lb(RESDGRPRowId,RESDGRPCode,RESDGRPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRDGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRDGroupListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetRDGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRDGroupListExecute ]
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

/// Function:  SS_UserDefWindow查找
/// Table:     SS_UserDefWindow
/// CreateDate: 2015-1-12 
/// Creator:  sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","GetSSUserDefWindowList","","","")
Query GetSSUserDefWindowList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "WINRowId:%String,WINCode:%String,WINDesc:%String")
{
}

ClassMethod GetSSUserDefWindowListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") 
 {
   s WINRowId=rowid
   s WINCode=$p($g(^SSU("WIN",WINRowId)),"^",1)
   s WINDesc=$p($g(^SSU("WIN",WINRowId)),"^",2)
   d OutputRowWIN
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U") 
   s:desc'="" desc=$ZCONVERT(desc,"U")  
   s WINRowId=0
   for
   {
      s WINRowId=$o(^SSU("WIN",WINRowId))
      q:(WINRowId="") 
      s WINCode=$p($g(^SSU("WIN",WINRowId)),"^",1)
      s WINDesc=$p($g(^SSU("WIN",WINRowId)),"^",2)
      s PINYIN=""
      s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(WINDesc)
      if ($ZCONVERT(WINCode,"U")[code)&(($ZCONVERT(WINDesc,"U")[desc)||(PINYIN[desc) ) 
      {
        d OutputRowWIN
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowWIN
    set Data=$lb(WINRowId,WINCode,WINDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSSUserDefWindowListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSUserDefWindowListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetSSUserDefWindowListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSUserDefWindowListExecute ]
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

/// Function:  ARCIMDentalStateDR  查找
/// Table:     OEC_DentalState
/// CreateDate: 2015-1-13 
/// Creator:  sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.QueryForARCItmMast","GetOECDentalStateList","","","")
Query GetOECDentalStateList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DENSTRowId:%String,DENSTCode:%String,DENSTDesc:%String")
{
}

ClassMethod GetOECDentalStateListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") 
 {
   s DENSTRowId=rowid
   s DENSTCode=$p($g(^OEC("DENST",DENSTRowId)),"^",1)
   s DENSTDesc=$p($g(^OEC("DENST",DENSTRowId)),"^",2)
   d OutputRowDENST
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U") 
   s:desc'="" desc=$ZCONVERT(desc,"U")  
   s DENSTRowId=0
   for
   {
      s DENSTRowId=$o(^OEC("DENST",DENSTRowId))
      q:(DENSTRowId="") 
      s DENSTCode=$p($g(^OEC("DENST",DENSTRowId)),"^",1)
      s DENSTDesc=$p($g(^OEC("DENST",DENSTRowId)),"^",2)
      s PINYIN=""
      s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DENSTDesc)
      if ($ZCONVERT(DENSTCode,"U")[code)&(($ZCONVERT(DENSTDesc,"U")[desc)||(PINYIN[desc) ) 
      {
        d OutputRowDENST
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowDENST
    set Data=$lb(DENSTRowId,DENSTCode,DENSTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOECDentalStateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOECDentalStateListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOECDentalStateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSUserDefWindowListExecute ]
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

}
