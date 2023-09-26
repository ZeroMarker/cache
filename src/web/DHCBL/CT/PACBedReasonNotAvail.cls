Import SQLUser

/// 名称: 科室 - 2、床位不可用原因维护    
/// 描述: 床位不可用原因维护, 包含增删改查功能
/// 编写者：基础平台组 - 蔡昊哲
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.PACBedReasonNotAvail Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：蔡昊哲
/// CreatDate: 2012-9-4
/// Description：查询床位不可用原因的内容
/// Table：User.PACBedReasonNotAvail
/// Input：rowid,code,desc
/// Return：RNAVRowId,RNAVCode,RNAVDesc,RNAVDateFrom,RNAVDateTo
/// Other:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedReasonNotAvail", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RNAVRowId:%String,RNAVCode:%String,RNAVDesc:%String,RNAVDateFrom:%String,RNAVDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.PACBedReasonNotAvail).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="")  
    {
        s RNAVRowId=rowid
        //^PAC("RNAV",3
        
        s RFRCode=$p($g(^PAC("RNAV",RNAVRowId)),"^",1)
        s RFRDesc=$p($g(^PAC("RNAV",RNAVRowId)),"^",2)
        s RNAVDateFrom=$p($g(^PAC("RNAV",RNAVRowId)),"^",3)
        s RNAVDateTo=$p($g(^PAC("RNAV",RNAVRowId)),"^",4)
        s:RNAVDateFrom'="" RNAVDateFrom=$zd(RNAVDateFrom,1)
        s:RNAVDateTo'="" RNAVDateTo=$zd(RNAVDateTo,1)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedReasonNotAvail",RNAVRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        d OutputRow
    }
    else
    {
        s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
        s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
        s RNAVRowId=0
        for  
        {   
            s RNAVRowId=$o(^PAC("RNAV",RNAVRowId)) q:RNAVRowId=""
            s strRowId = "{ID:"_RNAVRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s RFRCode=$p($g(^PAC("RNAV",RNAVRowId)),"^",1)
                s RFRDesc=$p($g(^PAC("RNAV",RNAVRowId)),"^",2)
                s RNAVDateFrom=$p($g(^PAC("RNAV",RNAVRowId)),"^",3)
                s RNAVDateTo=$p($g(^PAC("RNAV",RNAVRowId)),"^",4)
                s:RNAVDateFrom'="" RNAVDateFrom=$zd(RNAVDateFrom,1)
                s:RNAVDateTo'="" RNAVDateTo=$zd(RNAVDateTo,1)
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedReasonNotAvail",RNAVRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)       
                s BDPInternalDesc = $p($g(resultStr),"^",2)  
                s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                /*
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_BedReasonNotAvail",RNAVRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(RFRDesc))
                */
                if (desc'="")
               {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedReasonNotAvail",RNAVRowId,RFRDesc,desc)
               }
                else
               {
                    s AliasFlag= 1   
               }
                i ((RFRCode[code)||($$ALPHAUP^SSUTIL4(RFRCode)[code))&(AliasFlag=1)
                /*((RFRDesc[desc)||(PINYIN[desc)||($$ALPHAUP^SSUTIL4(RFRDesc)[desc)||(ALIASText1[desc))*/
                {
                    d OutputRow
                }
            }

        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RNAVRowId,RFRCode,RFRDesc,RNAVDateFrom,RNAVDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：蔡昊哲
/// CreatDate: 2012-9-4
/// Description：为combobox查询取数据
/// Table：User.PACBedReasonNotAvail
/// Input：rowid,code,desc
/// Return：RNAVRowId,RNAVCode,RNAVDesc
/// Other:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedReasonNotAvail", "GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "RNAVRowId:%String,RNAVCode:%String,RNAVDesc:%String")
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
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1  
    i desc'="" d   ///描述不为空  
 
    .s RNAVRowId=0
    .f  s RNAVRowId=$o(^PAC("RNAV",0,"Desc",RNAVRowId))  q:RNAVRowId=""  d
        ..s RFRCode=$p($g(^PAC("RNAV",RNAVRowId)),"^",1)
        ..s RFRDesc=$p($g(^PAC("RNAV",RNAVRowId)),"^",2)
        ..s RNAVDateTo=$p($g(^PAC("RNAV",RNAVRowId)),"^",4)
        ..d OutputRow1
     else  d ///描述为空
    .s RNAVRowId=0
    .f  s RNAVRowId=$o(^PAC("RNAV",RNAVRowId)) q:RNAVRowId=""  d 
      ..s RFRCode=$p($g(^PAC("RNAV",RNAVRowId)),"^",1)
      ..s RFRDesc=$p($g(^PAC("RNAV",RNAVRowId)),"^",2)
      ..s RNAVDateTo=$p($g(^PAC("RNAV",RNAVRowId)),"^",4)
      ..if (desc'="")
         ;需要对描述或者别名进行检索      
        ...s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedReasonNotAvail",RNAVRowId,RFRDesc,desc)
        ..else
        ...s AliasFlag= 1   
        .. i (AliasFlag=1)    
       ...d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1   
    set Data=$lb(RNAVRowId,RFRCode,RFRDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-24
/// Description：数据重复验证方法,js调用
/// Table：User.PACBedReasonNotAvail
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    ;new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^PAC("RNAV",0,"Code",code))
    s:desc'="" flagd=$d(^PAC("RNAV",0,"Desc",desc))
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
        s idc=""
        s idd=""
        s:code'="" idc=$o(^PAC("RNAV",0,"Code",code,0))
        s:desc'="" idd=$o(^PAC("RNAV",0,"Desc",desc,0))
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
                if ((idc'=id)||(idd'=id))&((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
                else  s flag=0 //返回不重复标志
            }
        }
    }
    q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-9-4
/// Description：双击修改时,从后台取数据
/// Table：User.PACBedReasonNotAvail
/// Input：id
/// Return：Json格式的字符串str={list:[RNAVCode,RNAVDesc,RNAVDateFrom,RNAVDateTo,RNAVRowId]}
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.PACBedReasonNotAvail).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBedReasonNotAvail).%New()
    s eobj.RNAVRowId = id
    s eobj.RNAVCode = pobj.RNAVCode
    s eobj.RNAVDesc = pobj.RNAVDesc
    ;s:pobj.RNAVDateFrom'="" eobj.RNAVDateFrom =$zd(pobj.RNAVDateFrom,1)   //从后台去数据为61999的数字格式,转化成日期格式
    ;s:pobj.RNAVDateTo'="" eobj.RNAVDateTo = $zd(pobj.RNAVDateTo,1)
    s:pobj.RNAVDateFrom'="" eobj.RNAVDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RNAVDateFrom)   
    s:pobj.RNAVDateTo'="" eobj.RNAVDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RNAVDateTo)
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：蔡昊哲
/// CreatDate: 2012-9-4
/// Description：增加、修改床位不可用原因的内容
/// Table：User.PACBedReasonNotAvail
/// Input：web.Entity.CT.PACBedReasonNotAvail
/// Return：成功返回success:'true'和新增或修改的数据的RNAVRowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBedReasonNotAvail) As %String
{
    ;new (eobj)
    ; d ##class(web.DHCBL.CT.PACBedReasonNotAvail).SaveEntity()
    s $zt="ERROR"
    s result=""
    if $IsObject(eobj)
    {
        ;s:eobj.RNAVDateFrom'="" eobj.RNAVDateFrom=$zdh(eobj.RNAVDateFrom,15)  //转换日期
        ;s:eobj.RNAVDateTo'="" eobj.RNAVDateTo=$zdh(eobj.RNAVDateTo,15)      //转换日期
        s:eobj.RNAVDateFrom'="" eobj.RNAVDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RNAVDateFrom)  //转换日期
        s:eobj.RNAVDateTo'="" eobj.RNAVDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RNAVDateTo)      //转换日期
        s:eobj.RNAVDateFrom="" eobj.RNAVDateFrom=+$h
        //如果RowId未赋值则增加
        if (eobj.RNAVRowId="")       
        {
            //RowId未赋值,增加
            s obj=##class(User.PACBedReasonNotAvail).%New()
            //判断空值,前台js也已添加空值判断allowblank
            if ((eobj.RNAVCode'="")&(eobj.RNAVDesc'=""))  //判断是否为空值
            {
                s TempRNAVCode=$ZCONVERT(eobj.RNAVCode,"U")   //$$ALPHAUP^SSUTIL4(eobj.RNAVCode)
                s TempCode=$d(^PAC("RNAV",0,"Code",TempRNAVCode))   
                if (TempCode=0)  //判断Code是否重复
                {
                    s TempRNAVDesc=$ZCONVERT(eobj.RNAVDesc,"U") 
                    s TempDesc=$d(^PAC("RNAV",0,"Desc",TempRNAVDesc))   
                    if (TempDesc=0) //判断Desc是否重复
                    {
                        s obj.RNAVCode = eobj.RNAVCode
                        s obj.RNAVDesc = eobj.RNAVDesc
                        //已在js里判断开始日期是否小于结束日期,故此处不加判断
                        s obj.RNAVDateFrom= eobj.RNAVDateFrom
                        s obj.RNAVDateTo= eobj.RNAVDateTo
                        Tstart
                        s sc=obj.%Save()
                        do obj.%Close()
                        if $$$ISOK(sc){
                            Tcommit
                            s id = obj.%Id()
                            s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedReasonNotAvail","User.PACBedReasonNotAvail","床位不可用原因",id,eobj.RNAVDesc,"A",eobj)
                        }else{
                            Trollback
                            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位不可用原因","web.DHCBL.CT.PACBedReasonNotAvail","SaveEntity",eobj)
                            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                        }   
                    }
                    else  //如果Desc重复
                    {
                        s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
                    }
                }
                else //如果Code重复
                {
                    s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
                }
            }
            else //如果两者中存在空值
            {
                s result="{success:'false',errorinfo:'代码或描述不可为空，请重新填写！'}"
            }
        }
        //如果RowId已赋值则修改
        else                           
        {
            //RowId已存在,修改
            s obj=##class(User.PACBedReasonNotAvail).%OpenId(eobj.RNAVRowId)
            s bobj=##class(web.Entity.CT.PACBedReasonNotAvail).%New()
            s bobj.RNAVRowId=eobj.RNAVRowId
            s bobj.RNAVCode = obj.RNAVCode
            s bobj.RNAVDesc = obj.RNAVDesc
            s bobj.RNAVDateFrom=obj.RNAVDateFrom
            s bobj.RNAVDateTo=obj.RNAVDateTo
                           
            
            //判断空值,前台js也已添加空值判断allowblank
            if ((eobj.RNAVCode'="")&(eobj.RNAVDesc'=""))  //判断是否为空值
            {
                s TempRNAVCode=$ZCONVERT(eobj.RNAVCode,"U")
                s TempCode=$d(^PAC("RNAV",0,"Code",TempRNAVCode))   
                s TempRowId1=$o(^PAC("RNAV",0,"Code",TempRNAVCode,0))
                if (TempCode=0)||((TempCode'=0)&(eobj.RNAVRowId=TempRowId1)) //判断Code是否重复
                {
                    s TempRNAVDesc=$ZCONVERT(eobj.RNAVDesc,"U")
                    s TempDesc=$d(^PAC("RNAV",0,"Desc",TempRNAVDesc))   
                    s TempRowId2=$o(^PAC("RNAV",0,"Desc",TempRNAVDesc,0))
                    if (TempDesc=0)||((TempDesc'=0)&(eobj.RNAVRowId=TempRowId2)) //判断Desc是否重复
                    {
                        s obj.RNAVCode = eobj.RNAVCode
                        s obj.RNAVDesc = eobj.RNAVDesc
                        //已在js里判断开始日期是否小于结束日期,故此处不加判断
                        s:eobj.RNAVDateFrom'="" obj.RNAVDateFrom = eobj.RNAVDateFrom
                        s:eobj.RNAVDateFrom="" obj.RNAVDateFrom =""
                        s:eobj.RNAVDateTo="" obj.RNAVDateTo =""
                        s:eobj.RNAVDateTo'="" obj.RNAVDateTo = eobj.RNAVDateTo
                           
                        Tstart
                        s sc=obj.%Save()
                        do obj.%Close()
                        if $$$ISOK(sc){
                            Tcommit
                            s id = obj.%Id()
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedReasonNotAvail","User.PACBedReasonNotAvail","床位不可用原因",eobj.RNAVRowId,eobj.RNAVDesc,"U",eobj,bobj)
                            s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
                        }else{
                            Trollback
                            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位不可用原因","web.DHCBL.CT.PACBedReasonNotAvail","SaveEntity",eobj)
                            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                        }   
                    }
                    else //如果Desc重复
                    {
                        s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
                    }
                }
                else //如果Code重复
                {
                    s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
                }   
            }
            else //如果两者中存在空值
            {
                s result="{success:'false',errorinfo:'代码或描述因不可为空，请重新填写！'}"
            }
        }   
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
ERROR
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位不可用原因","web.DHCBL.CT.PACBedReasonNotAvail","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:  用于数据删除时的逻辑判断 要判断在User.PACBedAvailRestriction里有没有被引用
/// CreateDate:2020-5-13
/// Ctreator:Sunfengchao
/// Input:rowid 床位不可用原因rowid
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.PACBedReasonNotAvail).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return=""
  s myInfo="" 
  s found=0
  ///  {PAC_Ward.WARD_RowID} ^PAWARD(2,"BED",29,"AVR",2)
  s WARDRowID=0
  for
  {
      s WARDRowID =$O(^PAWARD(WARDRowID)) q:WARDRowID=""
      s BEDChildsub=0
      for
      {
          s BEDChildsub=$O(^PAWARD(WARDRowID,"BED",BEDChildsub)) q:BEDChildsub=""
          s AVRChildsub=0
          for
          {
              s AVRChildsub =$O(^PAWARD(WARDRowID,"BED",BEDChildsub,"AVR",AVRChildsub)) q:AVRChildsub=""
              s AVRReasonNotAvailDR =$P($g(^PAWARD(WARDRowID,"BED",BEDChildsub,"AVR",AVRChildsub)),"^",3)
              if AVRReasonNotAvailDR=id
              {
                   s found=1
                   q
              } 
          }
      }
  }
  if (found=1) s myInfo=myInfo_"<床位使用限制User.PACBedAvailRestriction>"  
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

/// Creator：蔡昊哲
/// CreatDate: 2012-9-4
/// Description：根据id删除床位不可用原因的内容
/// Table：User.PACBedReasonNotAvail
/// Input：id(PACBedReasonNotAvail的RNAVRowId) 
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
  s result="" 
  s re=..GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  { 
    s pobj = ##class(User.PACBedReasonNotAvail).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBedReasonNotAvail).%New()
    s eobj.RNAVRowId = id
    s eobj.RNAVCode = pobj.RNAVCode
    s eobj.RNAVDesc = pobj.RNAVDesc
    Tstart
    s sc=##class(User.PACBedReasonNotAvail).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedReasonNotAvail","User.PACBedReasonNotAvail","床位不可用原因",id,eobj.RNAVDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位不可用原因","web.DHCBL.CT.PACBedReasonNotAvail","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  }
    q result
}

}
