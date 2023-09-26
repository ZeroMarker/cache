/// Function: 国际编码 映射 北京编码 业务类
/// CreateDate: 2016-12-20
/// Creator:  sunfengchao
Class web.DHCBL.CT.DKBICDContrast Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：查询已映射的表内容
/// CreatDate: 2016-12-20
/// Creator： sunfengchao
/// Input：rowid, code, desc
/// Output: DKBCT_RowId DKBCT_IntCode   DKBCT_IntDesc   DBKCT_IntLongDesc   DBKCT_PekCode   DBKCT_PekDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DKBICDContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "DKBCTRowId,DKBCTIntCode,DKBCTIntDesc,DBKCTIntLongDesc,DBKCTPekCode,DBKCTPekDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (id'="")
    {
        s code=$p($g(^DKBICDINT(id)),"^",1)
        s:code'="" code="<"_$ZCONVERT(code,"U")_">"
        s desc=""
        if ($d(^DKBICDINT(id,"Desc"))>0)
        {
          s desc=$listget(^DKBICDINT(id,"Desc"))  
        }
        s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
          
        s DKBCTRowId=0
        for  
        {    
            s DKBCTRowId=$o(^DBKICDCONSTRAST(DKBCTRowId)) 
            q:DKBCTRowId="" 
            s DKBCTIntCode=$p($g(^DBKICDCONSTRAST(DKBCTRowId)),"^",3)  //代码
            s DKBCTIntCodeU="<"_$ZCONVERT(DKBCTIntCode,"U")_">"
            s DKBCTIntDesc=""
            if ($d(^DBKICDCONSTRAST(DKBCTRowId,"IntDesc"))>0)
            {
              s DKBCTIntDesc=$listget(^DBKICDCONSTRAST(DKBCTRowId,"IntDesc"))  
            }
            s DKBCTIntDescU="<"_$ZCONVERT(DKBCTIntDesc,"U")_">"
         
            s DBKCTIntLongDesc=$p($g(^DBKICDCONSTRAST(DKBCTRowId)),"^",3)
            s DBKCTIntLongDescU=""
            if ($d(^DBKICDCONSTRAST(DKBCTRowId,"IntLongDesc"))>0)
            {
              s DBKCTIntLongDescU=$listget(^DBKICDCONSTRAST(DKBCTRowId,"IntLongDesc"))  
            } 
            s DBKCTIntLongDescU="<"_$ZCONVERT(DBKCTIntLongDesc,"U")_">"
            s DBKCTPekCode=$p($g(^DBKICDCONSTRAST(DKBCTRowId)),"^",1) //his代码
            s DBKCTPekDesc=$p($g(^DBKICDCONSTRAST(DKBCTRowId)),"^",2) //his描述
            if (DKBCTIntCodeU[code)&(DKBCTIntDescU[desc)   //条件
            {
                d OutputRow
            }       
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(DKBCTRowId,DKBCTIntCode,DKBCTIntDesc,DBKCTIntLongDesc,DBKCTPekCode,DBKCTPekDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:   根据id删除
/// Creator:    sunfengchao
/// CreatDate:  2016-12-20
/// Return:     成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Debug：     d ##class(web.DHCBL.CT.DKBICDContrast).DeleteData("8")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    Tstart
    s eobj = ##class(web.Entity.CT.DKBICDContrast).%New()
    s pobj = ##class(User.DKBICDContrast).%OpenId(id)
    s eobj.DKBCTRowId = id
    s eobj.DBKCTPekCode = pobj.DKBCTPekCode
    s eobj.DBKCTPekDesc = pobj.DKBCTIntDesc
    s eobj.DKBCTIntCode = pobj.DKBCTIntCode
    s eobj.DBKCTIntLongDesc = pobj.DKBCTIntLongDescription
    s eobj.DKBCTIntDesc=pobj.DKBCTIntDesc

    s sc=##class(User.DKBICDContrast).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DKB_ICDContrast","User.DKBICDContrast","新装ICD诊断码映射",id,eobj.DBKCTPekDesc,"D",eobj)
    }
    else
    {
        Trollback
        s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新装ICD诊断码映射","web.DHCBL.CT.DKBICDContrast","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
    }
    q result
}

/// Description：获取已映射检查部位中的hiscode
/// Other: w ##class(web.DHCBL.CT.DKBICDContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s DKBCTRowId=0,str=""
 for  
 {    
   s DKBCTRowId=$o(^DBKICDCONSTRAST(DKBCTRowId)) 
   q:DKBCTRowId="" 
   s DBKCTPekCode=$p($g(^DBKICDCONSTRAST(DKBCTRowId)),"^",2)
   s str="<"_DBKCTPekCode_">^"_str
  }
 q str
}

/// Description：数据映射
/// Creator:     sunfengchao
/// CreatDate:   2016-12-20
/// Return：     成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Debug：      d ##class(web.DHCBL.CT.DKBICDContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
    s result = ""
    s rowid=$p(ids,"^",1)    //rowid
    s pekrowid=$p(ids,"^",2) // pekrowid
    
    ; 取 国标码的信息
    s intcode=$p($g(^DKBICDINT(rowid)),"^",1)
    if ($d(^DKBICDINT(rowid,"Desc"))>0)
    {
      s intdesc=$listget(^DKBICDINT(rowid,"Desc"))  
    }
    else
    {
       s intdesc=""
    } 
    if ($d(^DKBICDINT(rowid,"LONGDesc"))>0)
    {
      s LongDesc=$listget(^DKBICDINT(rowid,"LONGDesc"))  
    }
    else
    {
       s LongDesc=""
    } 
    ;取北京编码的信息  
    s pekcode=$p($g(^DKBICDPEK(pekrowid)),"^",1)
    s pekdesc=$p($g(^DKBICDPEK(pekrowid)),"^",2)

    If pekcode'="" s pekcoderowid=$o(^DBKICDCONSTRAST(0,"PekCode",pekcode,""))
    If intcode'="" s intcoderowid=$o(^DBKICDCONSTRAST(0,"Code",intcode,pekcode,""))
    If ((pekcoderowid'="")&&(intcoderowid'="")) Quit "{success:'false',info:'该记录已映射, 不能重复映射!'}"  

    s codeStr = ##class(web.DHCBL.CT.DKBICDContrast).GetHisCode()
    s hcode = "<"_pekcode_">"
    if (codeStr[hcode) Quit "{success:'false',info:'该记录已映射, 请删除后再映射!'}" 
    s obj=##class(User.DKBICDContrast).%New()
    s obj.DKBCTIntCode = intcode
    s DKBCTIntDesc=##class(%ListOfDataTypes).%New()
    do DKBCTIntDesc.Insert(intdesc)
    s obj.DKBCTIntDesc = DKBCTIntDesc
    s DKBCTIntLongDescription=##class(%ListOfDataTypes).%New()
    do DKBCTIntLongDescription.Insert(LongDesc)
    s obj.DKBCTIntLongDescription = DKBCTIntLongDescription 
    s obj.DKBCTPekCode = pekcode
    s obj.DKBCTPekDesc = pekdesc
    s logJson="{DKBCTIntCode:"_$c(34)_intcode_$c(34)_",DKBCTIntDesc:"_$c(34)_intdesc_$c(34)_",DKBCTIntLongDescription:"_$c(34)_LongDesc_$c(34)_",DKBCTPekCode:"_$c(34)_pekcode_",DKBCTPekDesc:"_$c(34)_pekdesc_$c(34)_"}"
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    { 
        Tc      
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" 
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DKB_ICDContrast","User.DKBICDContrast","新装ICD诊断码映射",id,pekdesc,"A",logJson)
    }
    else
    {
        Trollback
        s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新装ICD诊断码映射","web.DHCBL.CT.DKBICDContrast","SaveData",logJson)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
    }
    q result
}

/// Description：批量数据映射
/// Creator:     sunfengchao
/// CreatDate:   2016-12-23
/// Return：     成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Debug：      d ##class(web.DHCBL.CT.DKBICDContrast).MultiSaveData("8#6^7")
ClassMethod MultiSaveData(ids As %String) As %String
{
   s introwid="",pekrowids="",pekid="",idstr="",result=""
   s resultstr=""
   s introwid=$p(ids,"#",1)
   s pekrowids=$p(ids,"#",2)
   for i=1:1:$l(pekrowids,"^")
   {
       s pekid=$P(pekrowids,"^",i)
       s idstr=introwid_"^"_pekid
       if (idstr'="")
       {
         s result= ..SaveData(idstr) 
         if (resultstr="") s resultstr=result
         else  s resultstr=resultstr_"##"_result
       }
       ; s ^tmp("resultstr")=resultstr
       if (resultstr'["false") 
       {
         s result = "{success:'true'}"   
       }
       else
       {
         s result = "{success:'false',info:'批量映射失败!'}"   
       }
   }   
   q result
}

}
