Import SQLUser

/// Function:     别名维护
/// CreateDate:   2014-04-08
/// Creator:      基础数据平台组 - sunfnegchao
Class web.DHCBL.BDP.BDPAlias Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 根据"表名称" 和"数据rowid"进行查询别名
/// CreateDate:2014-04-08
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: User.BDPAlias
/// Input:  TableN: 表名  DataRefer: 表的rowid号
/// Output: DataReference ,AliasRowId ,DataAlias 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPAlias","GetList","","")
Query GetList(TableN As %String, DataRefer As %String) As %Query(ROWSPEC = "DataReference:%String,AliasRowId:%String,DataAlias:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TableN As %String, DataRefer As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:TableN'="" TableN= $zcvt(TableN,"U")
    s:DataRefer'="" DataRefer=$zcvt(DataRefer,"U")
 
 
    s AliasRowId=0
    for
    {  
      s AliasRowId=$o(^User.BDPAliasD(AliasRowId))
      q:AliasRowId="" 
      s TableName=$LISTGET($g(^User.BDPAliasD(AliasRowId)),1)  
      s DataAlias=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
      s DataReference=$LISTGET($g(^User.BDPAliasD(AliasRowId)),3)
      ; 如果 表名称跟rowid和入参中的对应匹配，那就直接可以输出，否则的话就不输出
      if ((TableN'="")&&($zcvt(TableName,"U")=TableN))&&((DataRefer'="")&&($zcvt(DataReference,"U")=DataRefer))
      {
          d OutputRow
      }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(DataReference,AliasRowId,DataAlias)
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

/// Function:  删除别名的类方法
/// CreateDate:2014-04-09
/// Creator: 基础数据平台组 孙凤超
/// Input: id
/// Output: "{success:'true',info:'删除成功！'}"
/// Debug: d ##class(web.DHCBL.BDP.BDPAlias).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    new (id,%session)
    s result=""
    Tstart
    s pobj = ##class(User.BDPAlias).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPAlias).%New()     
    s eobj.TableName = pobj.TableName
    s eobj.DataAlias = pobj.DataAlias
    s eobj.DataReference=pobj.DataReference
    s sc=##class(User.BDPAlias).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Alias","User.BDPAlias","别名",id,eobj.DataAlias,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("别名:"_eobj.TableName_"->"_eobj.DataReference,"web.DHCBL.BDP.BDPAlias","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
    }
    q result
}

/// Function: 保存别名，用于添加时的操作
/// CreateDate: 2014-04-09
/// Creator:  基础数据平台组 sunfenghao
/// Debug:   添加数据时  w ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_Title^a1^#^CT_Title^a2^")
///          修改数据时  w ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("144^PAC_BabyPositon^AB1^48#145^PAC_BabyPositon^AB2^48#146^PAC_BabyPositon^AB3^48")                                          
/// Others:  别名里的DataReference 即是该条数据的rowid、
ClassMethod SaveEntity(listData As %String) As %String
{
  new (listData,%session)
  s result="" 
  s msg=0
  s err=""
  s resultstr=""
  s length=$length($g(listData),"#")
   
  for i=1:1:length 
  {
    q:msg'=0   
    s DataStr=$p($g(listData),"#",i)
    s DataStrlength=$length($g(DataStr),"^")   
    s rowid=$p($g(DataStr),"^",1)
    s TableN=$p($g(DataStr),"^",2)   
    s Alias=$p($g(DataStr),"^",3)
    s DataRefer=$p($g(DataStr),"^",4) 
    if (rowid="") 
    {
       s ret=..Insert(TableN,Alias,DataRefer)
       if (ret=1)  
       {
          s result= "{success:'true',info:'保存成功！'}"
       }
       else 
       { 
         s result= "{success:'false',errorinfo:'保存失败！'}" 
       }
    }
    else  
    {
        s ret=..Update(rowid,TableN,Alias,DataRefer)
        if (ret=1) 
        {
           s result= "{success:'true',info:'保存成功！'}"
        }
        else
        {
          s result= "{success:'false',errorinfo:'保存失败！'}" 
        }
    } 
  }
  q result
}

/// Function:   添加别名的操作
/// CreateDate: 2014-4-14
/// Creator:    sunfengchao
/// Input:      TableN ,Alias ,DataRefer
ClassMethod Insert(TableN As %String, Alias As %String, DataRefer As %String) As %String
{
    new (TableN,Alias,DataRefer,%session)
    s obj=##class(User.BDPAlias).%New()
    s obj.TableName=TableN
    s obj.DataAlias=Alias
    s obj.DataReference=DataRefer
    Tstart
    s sc=obj.%Save()    
    if $$$ISOK(sc)
    {
      Tcommit
      s id = obj.%Id()  
      s ALiasJson="{AliasRowId:"_$c(34)_id_$c(34)_",DataAlias:"_$c(34)_Alias_$c(34)_",DataReference:"_$c(34)_DataRefer_$c(34)_",TableName:"_$c(34)_TableN_$c(34)_"}" 
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Alias","User.BDPAlias","别名",id,Alias,"A",ALiasJson)
      s result =1    //保存数据后,通过RowId返回到这条数
    }
    else
    {
      Trollback
      s ALiasJson="{AliasRowId:"_$c(34)_""_$c(34)_",DataAlias:"_$c(34)_Alias_$c(34)_",DataReference:"_$c(34)_DataRefer_$c(34)_",TableName:"_$c(34)_TableN_$c(34)_"}" 
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("别名:"_TableN_"->"_DataRefer,"web.DHCBL.BDP.BDPAlias","Insert",ALiasJson)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
      s result =0_""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)    //返回错误信息
    }  
  q result
}

/// Function: 修改别名时的操作
/// CreateDate:2014-04-14
/// Creator:   基础数据平台组 孙凤超
/// Input:     rowid ,TableN,Alias,DataRefer
ClassMethod Update(rowid As %String, TableN As %String, Alias As %String, DataRefer As %String) As %String
{
    new (rowid,TableN,Alias,DataRefer,%session)
    s $zt="ERROR"
    s obj=##class(User.BDPAlias).%OpenId(rowid)
    s bobj=##class(web.Entity.CT.BDPAlias).%New()
    s bobj.TableName=obj.TableName
    s bobj.DataAlias=obj.DataAlias
    s bobj.DataReference=obj.DataReference
    s bobj.AliasRowId=rowid
    s ALiasOldJson="{AliasRowId:"_$c(34)_rowid_$c(34)_",DataAlias:"_$c(34)_bobj.DataAlias_$c(34)_",DataReference:"_$c(34)_bobj.DataReference_$c(34)_",TableName:"_$c(34)_bobj.TableName_$c(34)_"}"
    s obj.TableName=TableN
    s obj.DataAlias=Alias
    s obj.DataReference=DataRefer
    Tstart
    s sc=obj.%Save()
    if $$$ISOK(sc)
    {
      Tcommit
      s id = obj.%Id()  
      s ALiasJson="{AliasRowId:"_$c(34)_id_$c(34)_",DataAlias:"_$c(34)_Alias_$c(34)_",DataReference:"_$c(34)_DataRefer_$c(34)_",TableName:"_$c(34)_TableN_$c(34)_"}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Alias","User.BDPAlias","别名",rowid,Alias,"U",ALiasJson,ALiasOldJson)
      s result =1
    }
    else
    {
      Trollback
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("别名:"_TableN_"->"_DataRefer,"web.DHCBL.BDP.BDPAlias","Update",ALiasJson)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
      s result =0  
    }  
  q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("别名:"_TableN_"->"_DataRefer,"web.DHCBL.BDP.BDPAlias","Update",ALiasJson)
  s ^ERRORLOGINFO(logid)=$ze
  q result=0
}

/// Function:对别名维护进行数据校验
/// CreateDate: 2014-04-11
/// Creator:  基础数据平台组 孙凤超
/// debug: w ##class(web.DHCBL.BDP.BDPAlias).AliasValidate("","PAC_BabyPositon","48","顶顶顶顶")
ClassMethod AliasValidate(rowid As %String, TableN As %String, DataRefer As %String, Alias As %String) As %String
{
  new (rowid,TableN,Alias,DataRefer,%session)
  s flag="",flagc="" 
  s:TableN'="" flagc=$d(^User.BDPAliasI("AliasRef",TableN,Alias,DataRefer)) 
  if (rowid="")
  {
   if (flagc>0)
   {
     s flag=1 ;重复 
   }
   else
   {
    s flag=0
   }
 }
  else  ; 修改时的数据校验
  {
    s idc=""
    s:TableN'="" idc=$o(^User.BDPAliasI("AliasRef",TableN,Alias,DataRefer,0))
    if ((idc'=rowid)&(flagc>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
  }   
  q flag
}

/// Function:   遍历DataReference 获取全部别名rowid,然后循环删除 供基础码表数据维护中删除操作调用
/// CreateDate: 2014-04-22
/// Creator:    基础数据平台组 孙凤超
/// Debug:      w ##class(web.DHCBL.BDP.BDPAlias).DeleteAll("PAC_DeliveryMethod","59")
ClassMethod DeleteAll(TableN As %String, DataRefer As %String) As %String
{
  new (TableN,DataRefer,%session)
  s result="" 
  ; 判断是否有别名时的删除，当没有别名却要执行全部删除别名时为了删除数据
  ; 需要在没别名的全删除时返回一个 {sucess:true}
  if ($d(^User.BDPAliasI("DataRef",TableN,DataRefer))>0 ) 
  {
   s ID=0
   for 
   { 
    s ID=$o(^User.BDPAliasI("DataRef",TableN,DataRefer,ID)) 
    q:ID=""   
    Tstart 
    s pobj = ##class(User.BDPAlias).%OpenId(ID)
    s eobj = ##class(web.Entity.CT.BDPAlias).%New() 
    s eobj.TableName = TableN
    s eobj.DataAlias = pobj.DataAlias
    s eobj.DataReference=DataRefer
    s sc=##class(User.BDPAlias).%DeleteId(ID)
    IF $$$ISOK(sc)
    {
      Tc
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Alias","User.BDPAlias","别名",ID,eobj.DataAlias,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"
      d eobj.%Close()
    }
    else
    {
      Trollback
      s result="{success:'false',info:'删除失败！'}"
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("别名:"_eobj.TableName_"->"_eobj.DataReference,"web.DHCBL.BDP.BDPAlias","DeleteAll",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
    } 
  }
}
  else{
    s result="{success:'true'}"
  }
  q result
}

/// Function: 通过表名和对应rowid获取别名串
/// CreateDate:2015-12-27
/// Creator:基础数据平台组 sunfengchao
/// Tables: User.BDPAlias
/// Input:  TableN: 表名(必填)，  DataRefer: 表里数据对应的rowid(必填)
/// Output: DataAlias1^DataAlias2^DataAlias3
/// Others:  w ##class(web.DHCBL.BDP.BDPAlias).GetDataStr("PAC_BabyPosition","182")
ClassMethod GetDataStr(TableN As %String, DataRefer As %String) As %String
{
  new (TableN,DataRefer,%session)
  s str=""  
  if ($d(^User.BDPAliasI("DataRef",TableN,DataRefer))>0 ) 
  { 
    s AliasRowId=0 
    for 
    { 
        s AliasRowId=$o(^User.BDPAliasI("DataRef",TableN,DataRefer,AliasRowId)) 
        q:AliasRowId=""   
        s DataAlias=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2) 
        if str'="" s str=str_"^"_DataAlias
        if str="" s str=DataAlias 
     }
  }
  q str
}

/// Function:通过表名 对应rowid 查询模式 来获取别名串
/// Creator: sunfengchao
/// CreateDate:2017-7-11
/// Tables: User.BDPAlias
/// Input:  TableN: 表名   Alias: 别名 LookUpMode:检索模式参数: A 精确检索  F 模糊检索  L 左匹配检索"" 默认模糊检索
/// Output: id1 ^id2 ^id3 ...  
/// Debug:  w ##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("表名","别名","检索模式参数")
///         w ##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("PAC_BabyPosition","a","A")
ClassMethod GetDataStrByAlias(TableN As %String, Alias As %String, LookUpMode As %String = "") As %String
{
    new (TableN,Alias,LookUpMode,%session)
    s str="",tableI=""  
    s:Alias'="" Alias=$zcvt(Alias,"U") 
    if ($d(^User.BDPAliasI("DataRef",TableN))>0 ) 
    {
        s str=""  
        s DataReference=0
        for
        {
           ;数据的rowid
           s DataReference=$o(^User.BDPAliasI("DataRef",TableN,DataReference))
           q:DataReference="" 
           s AliasRowId=0 
           for 
           { 
                s AliasRowId=$o(^User.BDPAliasI("DataRef",TableN,DataReference,AliasRowId)) 
                q:AliasRowId=""    
                s DataAlias=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)  ; 别名
       
                ;1 检索模式为空或者是 F 时 :模糊检索
                if ((LookUpMode="")||(LookUpMode="F"))
                {
                    if ($zcvt(DataAlias,"U")[Alias)
                    {
                      if (str="")
                      { 
                          s str=DataReference
                      }
                      else
                      {
                          if (str[DataReference) 
                          {
                              s str=str
                          }
                          else
                          { 
                            s str=str_"^"_DataReference
                          }
                      }
                    }
               }
               else
               {
                 ;2检索模式不为空； A 精确检索   
                 if (LookUpMode="A")
                 {
                    if ($zcvt(DataAlias,"U")=Alias)
                    {
                      if (str="")
                      {   
                        s str=DataReference
                      }
                      else
                      {
                          if (str[DataReference) 
                          {
                              s str=str
                          }
                          else
                          {
                    
                            s str=str_"^"_DataReference
                          }
                      }
                    }
                 } 
                 ;3 当查询模式为 L: 左匹配检索
                 if (LookUpMode="L")
                 {
                    s AliasLen=0,DataAliasS=""
                    s AliasLen=$length(Alias)
                    s DataAliasS=$e(DataAlias,1,AliasLen)  
                    if ($zcvt(DataAliasS,"U")=Alias)
                    {
                      if (str="")
                      {
                        s str=DataReference
                      }
                      else
                      {
                          if (str[DataReference) 
                          {
                              s str=str
                          }
                          else
                          {
                            s str=str_"^"_DataReference
                          }
                      }
                    } 
                 }
               }
            }
        }
    }
    q str
}

/// Function:保存别名配置
/// Creator: sunfengchao
/// CreateData:2017-07-10
/// Debug:  w ##class(web.DHCBL.BDP.BDPAlias).SaveLookUpConfig("","")
ClassMethod SaveLookUpConfig(table As %String, lookUpVal) As %String
{
    new (table,lookUpVal,%session) 
    if ('$d(%session))
    {
      s result="" 
    }
    s userid=$Get(%session.Data("LOGON.USERID"))
    
    if ($d(^User.BDPAliasConfigureI("AliasConfigRef",userid,table))>0)
    {
        ; 修改
        s configvalue="",ID=0
        s configvalue=$O(^User.BDPAliasConfigureI("AliasConfigRef",userid,table,configvalue))
        q:configvalue=""
        s ID=$O(^User.BDPAliasConfigureI("AliasConfigRef",userid,table,configvalue,ID))
        q:ID=""
        s obj=##class(User.BDPAliasConfigure).%OpenId(ID) 
    }
    else
    { 
        ; 新增
        s obj=##class(User.BDPAliasConfigure).%New()
    }
    TS
    s obj.UserID=userid
    s obj.TableName=table
    s obj.AliasConfig=lookUpVal 
    s sc=obj.%Save()
    if (sc=1)
    {
        Tcommit
        s id = obj.%Id()
        s result = 1      
    }
    else
    {
        Trollback
    } 
    q result
}

/// Creator：  sunfengchao
/// CreatDate: 2017-07-07
/// Function:  查询别名配置信息
/// Others:    w ##class(web.DHCBL.BDP.BDPAlias).GetConfig("MRC_ICDdxSix")
ClassMethod GetConfig(table) As %String
{
    new (table,%session)
    s configvalue="" ,userid=""
    if ('$d(%session)) q "获取不到session!" 
    s userid=$Get(%session.Data("LOGON.USERID"))  
    q:userid="" "" 
    if ($d(^User.BDPAliasConfigureI("AliasConfigRef",userid,table))>0)
    {
        s configvalue=$O(^User.BDPAliasConfigureI("AliasConfigRef",userid,table,configvalue))
        q:configvalue="" "" 
    }
    q configvalue
}

///  Function:判断是否存全是字母或者数据
///  CreateDate:2019-02-12
///  Creator: sunfengchao
///  Debug:   w ##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag("123a23")
ClassMethod GetPINYINFlag(Alias As %String) As %String
{
    new (Alias,%session)
    q:Alias="" 0
    s str=""
    s reslut=0
    s Alias=$zcvt(Alias,"U") 
    for j=1:1:$length(Alias)
    {
       s HANZI=$e(Alias,j) 
       s:HANZI'="" ASCIICODE=$ASCII(HANZI) 
       if (ASCIICODE>=65)&(ASCIICODE<=90) /// 是字母
       { 
         s reslut=1  
       } 
       else
       { 
         q 
       }
     } 
    q reslut
}

/// Function: 提供query查询的接口
/// CreateDate:2017-07-07
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_ICDdxSix","39","霍乱","霍乱")
ClassMethod GetAlisForQuery(table As %String, dataid As %String, desc As %String, alias As %String) As %String
{
   new (table,dataid,desc,alias,%session) 
   s lookupidstr="",LookUpMode="",result=0,PINYINCODE=""
   if (alias'="")&(desc="") q 0
   s:alias'="" alias=$zcvt(alias,"U")
   s:desc'="" desc=$zcvt(desc,"U")
   s PINYINFlag=""
   if (alias'="")
   {
      s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(alias) /// 是拼音 才去转换拼音码
      if (PINYINFlag=1)
      {
          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc) 
      }
   } 
   s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig(table)
   s AliasRowId=0,ALIASText1="",aliaslen=0,  AlasFlag=0
   for
   {
      s AliasRowId=$o(^User.BDPAliasI("DataRef",table,dataid,AliasRowId))
      q:AliasRowId=""
      S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
      ; 查询出对应rowid下的所有别名，用"^"进行连接
      s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
      if (ALIASText1[alias) s AlasFlag=1
   }
 
    ;1 检索模式为空或者是 F 时 :模糊检索
    if ((LookUpMode="")||(LookUpMode="F"))
    {
        if ((AlasFlag=1)||(desc[alias)||(PINYINCODE[alias))
        { 
          s result=1
        }
    }
     
    ;;2检索模式不为空； A 精确检索  
     if (LookUpMode="A")
     {
         s AlasFlag=0 
         ; 别名检索
         s aliaslen=$Length(ALIASText1,"^")
         for j=1:1:aliaslen
         {
             s SearchAlias=$p(ALIASText1,"^",j)
             if (SearchAlias=alias) s AlasFlag=1
         }

        if ((AlasFlag=1)||(desc=alias)||(PINYINCODE=alias)) 
        { 
           s result=1
        }
     }
          
     ;3 当查询模式为 L: 左匹配检索
     if (LookUpMode="L")
     { 
        s AliasLen=0,DataAliasS=""
        s AliasLen=$length(alias)
        s DataDescS=$e(desc,1,AliasLen)  
        s DataPINYIN=$e(PINYINCODE,1,AliasLen)  
       
        s AlasFlag=0 
        ; 别名检索
        s aliaslen=$Length(ALIASText1,"^")
        for j=1:1:aliaslen
        {
             s SearchAlias=$p(ALIASText1,"^",j)
             s SearchAliasS=$e(SearchAlias,1,AliasLen)  
             if (SearchAliasS[alias) s AlasFlag=1
        }
         
        if ((AlasFlag=1)||(DataDescS[alias)||(DataPINYIN[alias))
        {
            s result=1
        }   
     }   
   q result
}

}
