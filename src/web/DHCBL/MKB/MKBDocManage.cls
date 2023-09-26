/// 描述: 术语文献管理表User.MKBDocManage方法类
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2018-03-29
Class web.DHCBL.MKB.MKBDocManage Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Description：获取界面数据
/// Input:desc查询条件
/// return:
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDocManage","GetList","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,MKBDMType,MKBDMUpdateUser,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMKeyWord,MKBDMNote,MKBDMPath,MKBDMClassify")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBDMRowId=rowid
    s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
    s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
    s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
    s MKBDMSource=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),5)
    s MKBDMType=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),6)
    s MKBDMUpdateUser=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),7)
    s:MKBDMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBDMUpdateUser)),"^",2)
    s:MKBDMUpdateUser="" SSUSRName=""
    s MKBDMUpdateDate=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),8)
    s:MKBDMUpdateDate'="" MKBDMUpdateDate=$zd(MKBDMUpdateDate,3)
    s MKBDMKeyWord=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),9)
    s MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),10)
    s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),11)
    s MKBDMClassify=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),12)   
    d OutputRow
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

    s MKBDMRowId=0
    for{  
      s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
      s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
      s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
      s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
      s MKBDMSource=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),5)
      s MKBDMType=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),6)
      s MKBDMUpdateUser=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),7)
      s:MKBDMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBDMUpdateUser)),"^",2)
      s:MKBDMUpdateUser="" SSUSRName=""
      s MKBDMUpdateDate=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),8)
      s:MKBDMUpdateDate'="" MKBDMUpdateDate=$zd(MKBDMUpdateDate,3)
      s MKBDMKeyWord=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),9)
      s MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),10)
      s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),11)
      s MKBDMClassify=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),12)  
      s PINYIN=""
      s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBDMDesc)  
      if (($ZCONVERT(MKBDMDesc,"U")[desc)||(PINYIN[desc)) {
        d OutputRow
      }
    }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,MKBDMType,MKBDMUpdateUser,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMKeyWord,MKBDMNote,MKBDMPath,MKBDMClassify)
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

/// Description:为combobox查询取数据
/// Table：User.MKBDocManage
/// Input：rowid,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDocManage","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMPath")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBDMRowId=rowid
    s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
    s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
    s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
    d OutputRowCmb
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

    s MKBDMRowId=0
    for{  
      s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
      s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
      s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
      s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
      s MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),10)
      continue:MKBDMFlag="N"

      s PINYIN=""
      s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBDMDesc)  
      if (($ZCONVERT(MKBDMDesc,"U")[desc)||(PINYIN[desc)) {
        d OutputRowCmb
      }
    }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMPath)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2017-04-21    
/// w ##class(web.DHCBL.MKB.MKBTremExtendDetail).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc=""
    s:desc'="" flagc=$d(^User.MKBDocManageI("DescIndex"," "_desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s:desc'="" idc=$o(^User.MKBDocManageI("DescIndex"," "_desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Input:
/// Description：保存修改内容
/// return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.MKB.MKBDocManage) As %String
{
    
    s result = ""
    Set UpdateDate=$p($h,",",1)       //上传时间日期
    Set UpdateUserDR=%session.Get("LOGON.USERID")         //上传人
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.MKBDMRowId,eobj.MKBDMDesc)   
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'已存在相同名称的数据！'}"
        }
        else
        {   
            if (eobj.MKBDMRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MKBDocManage).%New()
                s obj.MKBDMUpdateDate = UpdateDate
                d:UpdateUserDR'="" obj.MKBDMUpdateUserSetObjectId(UpdateUserDR)
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBDocManage).%OpenId(eobj.MKBDMRowId)
                
                s bobj = ##class(web.Entity.MKB.MKBDocManage).%New()
                s bobj.MKBDMRowId = eobj.MKBDMRowId
                s bobj.MKBDMCode = obj.MKBDMCode
                s bobj.MKBDMDesc = obj.MKBDMDesc
                s bobj.MKBDMSource = obj.MKBDMSource
                s bobj.MKBDMType = obj.MKBDMType
                s bobj.MKBDMClassify = obj.MKBDMClassify
                s bobj.MKBDMUpdateUser = obj.MKBDMUpdateUser
                s bobj.MKBDMUpdateDate = obj.MKBDMUpdateDate
                s bobj.MKBDMFlag = obj.MKBDMFlag
                s bobj.MKBDMNote = obj.MKBDMNote
                s bobj.MKBDMPath = obj.MKBDMPath
                s bobj.MKBDMKeyWord=obj.MKBDMKeyWord
            }
            
            s obj.MKBDMCode = eobj.MKBDMCode
            s obj.MKBDMDesc = eobj.MKBDMDesc
            s obj.MKBDMSource = eobj.MKBDMSource
            s obj.MKBDMType = eobj.MKBDMType
            s obj.MKBDMClassify = eobj.MKBDMClassify
            
            //s obj.MKBDMUpdateDate = UpdateDate
            s obj.MKBDMFlag = eobj.MKBDMFlag
            s obj.MKBDMNote = eobj.MKBDMNote
            s obj.MKBDMPath = eobj.MKBDMPath
            s obj.MKBDMKeyWord=eobj.MKBDMKeyWord
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.MKBDMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_DocManage","User.MKBDocManage","术语文献管理",id,eobj.MKBDMDesc,"A",eobj)
                d:eobj.MKBDMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_DocManage","User.MKBDocManage","术语文献管理",eobj.MKBDMRowId,eobj.MKBDMDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                //s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语文献管理","web.DHCBL.MKB.MKBDocManage","SaveData",eobj)
                //s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   
    }   
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Input:对象id
/// Description：修改时打开的对象数据
/// return:对象json串
/// w ##class(web.DHCBL.MKB.MKBDocManage).OpenData(1881)
ClassMethod OpenData(RowId As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.MKB.MKBDocManage).%New()
    s pobj = ##class(User.MKBDocManage).%OpenId(RowId)
    s eobj.MKBDMRowId = RowId
    s eobj.MKBDMCode = pobj.MKBDMCode
    s eobj.MKBDMDesc = pobj.MKBDMDesc
    s eobj.MKBDMSource = pobj.MKBDMSource
    s eobj.MKBDMType = pobj.MKBDMType
    s eobj.MKBDMClassify = pobj.MKBDMClassify
    s eobj.MKBDMFlag = pobj.MKBDMFlag
    s eobj.MKBDMNote = pobj.MKBDMNote
    s eobj.MKBDMPath = pobj.MKBDMPath
    s eobj.MKBDMKeyWord=pobj.MKBDMKeyWord

    d pobj.%Close() 
    k pobj  

    s str = eobj.JsonS()    
   //s str = "{data:["_str_"]}"
    q str
}

/// w ##class(web.DHCBL.MKB.MKBDocManage).GetDesc(1881)
ClassMethod GetDesc(RowId As %String) As %String
{
    s str=""    
    s:RowId'="" str=$LISTGET($G(^User.MKBDocManageD(RowId)),3)
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.MKB.MKBDocManage).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
    s myChildFlag=$d(^User.DHCDSSDiseJoinliteratureI("DocDiseIndex",id))
    if (myChildFlag){
	    s diaNameStr=""
	    s diaId=0 
        for{
            s diaId=$o(^User.DHCDSSDiseJoinliteratureI("DocDiseIndex",id,diaId))
            q:diaId=""
            s diaName=$LISTGET($G(^User.DHCDSSDiseaseDictD(diaId)),3)
            if (diaNameStr'="")
            {
	            s diaNameStr=diaNameStr_"、"
            }
            s diaNameStr=diaNameStr_diaName
        } 
	  
	    s myInfo=myInfo_diaNameStr_"的<疾病关联指南>"   
    }
    //评估表关联文献
    s myChildFlag=$d(^User.DHCDSSAssConDocI("DocIndex",id))
    if (myChildFlag){
	    s AssDescStr=""
	    s AssConDocId=0 
        for{
            s AssConDocId=$o(^User.DHCDSSAssConDocI("DocIndex",id,AssConDocId))
            q:AssConDocId=""
            s AssDR=$LISTGET($G(^User.DHCDSSAssConDocD(AssConDocId)),2)
            s AssDesc=$LISTGET($G(^User.MKBAssessmentBaseD(AssDR)),3)
            if (AssDescStr'="")
            {
	            s AssDescStr=AssDescStr_"、"
            }
            s AssDescStr=AssDescStr_AssDesc
        } 
	  
	    s myInfo=myInfo_AssDescStr_"的<评估表关联文献>"   
    }
        
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用，不能删除!"
 	q return
}

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Input:对象id
/// Description：删除对象
/// Return：成功返回true，失败返回false和失败原因
/// w ##class(web.DHCBL.MKB.MKBDocManage).DeleteData(13)
ClassMethod DeleteData(id) As %String
{
  s result=""
  s errorinfo = ##class(web.DHCBL.MKB.MKBReference).DeleteData("DOC",id)
  if (errorinfo'="")
  {
	 s result = "{success:'false',info:'"_errorinfo_"'}"
	 q result 	 
  }	
  s re=..GetRefFlag(id)  //删除限制
  s RefFlag=$p(re,"^",1)
  if (RefFlag'=0)
  {
      s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  { 
	  s eobj=##class(web.Entity.MKB.MKBDocManage).%New()
	  s eobj.MKBDMRowId=id
	  s eobj.MKBDMCode=$LISTGET($G(^User.MKBDocManageD(id)),2)
	  s eobj.MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(id)),3)
	  s eobj.MKBDMPath=$LISTGET($G(^User.MKBDocManageD(id)),4)
	  s eobj.MKBDMSource=$LISTGET($G(^User.MKBDocManageD(id)),5)
	  s eobj.MKBDMType=$LISTGET($G(^User.MKBDocManageD(id)),6)
	  s eobj.MKBDMUpdateUser=$LISTGET($G(^User.MKBDocManageD(id)),7)
	  s eobj.MKBDMUpdateDate=$LISTGET($G(^User.MKBDocManageD(id)),8)
	  s eobj.MKBDMKeyWord=$LISTGET($G(^User.MKBDocManageD(id)),9)
	  s eobj.MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(id)),10)
	  s eobj.MKBDMNote=$LISTGET($G(^User.MKBDocManageD(id)),11)

	  Tstart
	  s sc=##class(User.MKBDocManage).%DeleteId(id)
	  IF $$$ISOK(sc) {
	   Tc
	   s result="{success:'true',info:'删除成功'}"
	   //保存日志
	   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_DocManage","User.MKBDocManage","术语文献管理",id,eobj.MKBDMDesc,"D",eobj)
	   d eobj.%Close()
	   d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("DOC",id)
	  }
	  else 
	  {
	     Trollback
	     //s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	     s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}"
	     //s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语文献管理","web.DHCBL.MKB.MKBDocManage","DeleteData",eobj)
	     //s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
	  }
  }
  q result
}

/// Description:代码自动生成  TD0000000 代码最大值加1
/// update:chenghegui
/// w ##class(web.DHCBL.MKB.MKBDocManage).GetLastCode()
ClassMethod GetLastCode() As %String
{
    s CodeLen="9"    //代码长度
    s StartCode="TD"  //代码起始字符
    s code=""
    s flag=0
    s StartCodeLen=$Length(StartCode)
    s preCode=""    //寻找符合规则的最大的代码
        for{
            s preCode=$o(^User.MKBDocManageI("CodeIndex",preCode),"-1")
            s MKBDMRowId=""
            if ($d(^User.MKBDocManageI("CodeIndex"))=0)  //判断是否是第一次生成代码  
                {
                    s mycode="TD0000001"
                    q
                }
            for
                {  
                    s MKBDMRowId = $o(^User.MKBDocManageI("CodeIndex",preCode,MKBDMRowId),"-1")
                    q:MKBDMRowId=""
                    s MKBDMCode=$listget($g(^User.MKBDocManageD(MKBDMRowId)),2)
                    if (($e(MKBDMCode,1,StartCodeLen)=StartCode)&&($l(MKBDMCode)=CodeLen))
                        {
                            s preCode=MKBDMCode
                            s flag=-9999
                            q
                        }
                
                }
             q:flag=-9999
      }
    s CodeNum=""
    if (preCode="")   //如果没有符合规则的代码，则生成第一个数字1
    {
        s CodeNum=1
    }
    else  //如果有符合规则的代码，则起始字符后的数字+1
    {       
        s CodeNum=$p(preCode,StartCode,2)+1     //起始字符后的数字+1
    }
    s CodeNumLen=$Length(CodeNum)     //数字的长度

    s zeroLen=CodeLen-StartCodeLen-CodeNumLen  //中间0串的长度
    s zeroStr=""  //中间0串
    s count=0
    for
    {
        s count=count+1
        q:count>zeroLen
        s zeroStr=zeroStr_"0"
    }
    
    s mycode=StartCode_zeroStr_CodeNum  //起始字符_0串_数字 的组合

    q mycode
}

/// w ##class(web.DHCBL.MKB.MKBDocManage).Test()
ClassMethod Test() As %String
{
    
    s result = "818-12995:303*305*306*307"  //"818-12995:292*294" "818-12995:279"
    //"818-12995:303*305,12992:43071*257*260*267"  //"818-12995:303*305,12992:43071*257*260*267"
    q result
}

/// Description：对诊断id串从小到大进行排序
/// Creator：chenghegui
/// CreatedDate：2018-01-17
/// Input: id串
/// return: 从小到大的id串
/// Debug: w ##class(web.DHCBL.MKB.MKBDocManage).GetDiagSort("818-18920:43044*43041,18919:43041*43042*4305")
ClassMethod GetDiagSort(idstr) As %String
{
 
    //818-18920:43044,18919:43041*43042
    s TremId= $p($g(idstr),"-",1)
    s CatAndExt = $p($g(idstr),"-",2)
    s CatAndExtLen = $L($g(CatAndExt),",")
    s IdNewStr = ""
    for i=1:1:CatAndExtLen
    {   
         s CatAndExti = $p($g(CatAndExt),",",i)
         s CatIdi = $p($g(CatAndExti),":",1) 
         s:CatIdi'="" ^TMP(0,"CatIdi",CatIdi)=CatIdi
         s ExtIdStri = $p($g(CatAndExti),":",2) 
         for j=1:1:$l($g(ExtIdStri),"*")
         {
             s ExtIdj = $p($g(ExtIdStri),"*",j)
             s:((CatIdi'="")&(ExtIdj'="")) ^TMP(0,"CatIdiAndExtIdj",CatIdi,ExtIdj)=CatIdi_"^"_ExtIdj
         }
    }
    s CatId=""
    s CatIdAndExtNewStr=""
    for 
    {
         s CatId = $o(^TMP(0,"CatIdi",CatId)) q:CatId=""
         s ExtId=""
         s ExtIdNewStr= ""
         for 
         {
             s ExtId=$o(^TMP(0,"CatIdiAndExtIdj",CatId,ExtId)) q:ExtId=""
             s:ExtIdNewStr'="" ExtIdNewStr=ExtIdNewStr_"*"_ExtId
             s:ExtIdNewStr="" ExtIdNewStr=ExtId
         }
            s:CatIdAndExtNewStr'="" CatIdAndExtNewStr=CatIdAndExtNewStr_","_CatId_":"_ExtIdNewStr
            s:CatIdAndExtNewStr="" CatIdAndExtNewStr=CatId_":"_ExtIdNewStr
           
         
    }
    s:IdNewStr="" IdNewStr=TremId_"-"_CatIdAndExtNewStr
    k ^TMP(0,"CatIdiAndExtIdj")
    k ^TMP(0,"CatIdi")
    q IdNewStr
}

/// Description：对Id串的属性内容Id加()处理ReletedDocString
/// Creator：chenghegui
/// CreatedDate：2018-01-17
/// Input: id串
/// return: 属性内容加()的Id串
/// Debug: w ##class(web.DHCBL.MKB.MKBDocManage).ReletedDocString("818-12992:261*263,12995:303*305")
ClassMethod ReletedDocString(diagm) As %String
{
  
    //s:diagm'="" diagm=..GetDiagSort(diagm)
    s catAndextm = $p($g(diagm),"-",2)
    s catAndextymn =""
    s result=""
      for ym=1:1:$l($g(catAndextm),",")
      {
          s catAndextym = $p($g(catAndextm),",",ym)
          s extidsm = $p($g(catAndextym),":",2)
          s resultext=""
          for xm=1:1:$l($g(extidsm),"*") 
          {
            s extidxm= $p($g(extidsm),"*",xm) 
            s extidxm ="("_extidxm_")"
            s:resultext'="" resultext=resultext_"*"_extidxm
            s:resultext="" resultext=extidxm
          }
          s:catAndextymn'="" catAndextymn= catAndextymn_","_$p($g(catAndextym),":",1)_":"_resultext
          s:catAndextymn="" catAndextymn=$p($g(catAndextym),":",1)_":"_resultext
      }
       s result= $p($g(diagm),"-",1)_"-"_catAndextymn
       q result
}

/// Description：对匹配度进行排序GetListReletedDocSort
/// Creator：chenghegui
/// CreatedDate：2018-01-17
/// Input: id串
/// return: 匹配度从高到低的返回json数据
/// Debug: w ##class(web.DHCBL.MKB.MKBDocManage).GetListReletedDocSort("818-12992:261*263,12995:303*305","","","","")
ClassMethod GetListReletedDocSort(diag, key, desc, rows, page) As %String
{
    s total=0
    //s:rows="NaN" rows=20
    s endpage=page*rows  //结束行
    s stpage=((page-1)*rows)+1 //开始行
    if (diag="")
    { 
       q "{""rows"":["_" "_"],""total"":"_"0"_"}"
    }
    s:desc'="" desc=$zcvt(desc,"U")
    s:key'="" key=$zcvt(key,"U")
    s docidstr=""
    s diagstr=""
    s re=""
    s diagLen = $L($g(diag),"+")
        for i=1:1:diagLen
        {
            s diagi = $p($g(diag),"+",i)
            s:diagi'="" diagi=..GetDiagSort(diagi)
            //高
            s MKBDRRowId=0
            s diagflag=""
            s keyflag=""
            for
            {
                
                s MKBDRRowId = $o(^MKBDR(MKBDRRowId)) q:MKBDRRowId=""
                s MKBDRDiag1 = $p($g(^MKBDR(MKBDRRowId)),"^",1)
                s MKBDRDiag2 = $p($g(^MKBDR(MKBDRRowId)),"^",2)
                s MKBDRDiag3 = $p($g(^MKBDR(MKBDRRowId)),"^",3)
    
                s MKBDRDocManDR = $p($g(^MKBDR(MKBDRRowId)),"^",4)  
                s MKBDRKey1 = $p($g(^MKBDR(MKBDRRowId)),"^",7)  
                s MKBDRKey2 = $p($g(^MKBDR(MKBDRRowId)),"^",8)  
                s MKBDRKey3 = $p($g(^MKBDR(MKBDRRowId)),"^",9)  
                
                s MKBDocRowId = MKBDRDocManDR
                s MKBDocDesc=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),3)
                s MKBDocDesc = ##class(web.DHCBL.BDP.FunLib).Utilstring(MKBDocDesc)
                s MKBDocSource=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),5)
                s MKBDocPath = $LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),4)
                s keyflag = ($zcvt(MKBDRKey1 ,"U")[key)||($zcvt(MKBDRKey2 ,"U")[key)||($zcvt(MKBDRKey3 ,"U")[key)
                s diagflag= ((..GetDiagSort(MKBDRDiag1))=diagi)||((..GetDiagSort(MKBDRDiag2))=diagi)||((..GetDiagSort(MKBDRDiag3))=diagi)
                if ((keyflag)&&(diagflag)&&($zcvt(MKBDocDesc ,"U")[desc))  //精确查询
                    {
                    
                        s MKBDRDiag1Desc=""
                        s MKBDRDiag2Desc=""
                        s MKBDRDiag3Desc=""
                        s total=total+1
                        if (total<stpage) continue
                        if (total<=endpage)
                        {
                            s:MKBDRDiag1'="" MKBDRDiag1Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag1)
                            s:MKBDRDiag2'="" MKBDRDiag2Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag2)
                            s:MKBDRDiag3'="" MKBDRDiag3Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag3)
                            s:re'="" re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=red><b>高</b></font>"_"""}"
                            s:re="" re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=red><b>高</b></font>"_"""}"
                        }
                    
                    }
            }
            //中
            s MKBDRRowId=0
            s diagflag=""
            s keyflag=""
            for
            {
                
                s MKBDRRowId = $o(^MKBDR(MKBDRRowId)) q:MKBDRRowId=""
                s MKBDRDiag1 = $p($g(^MKBDR(MKBDRRowId)),"^",1)
                s MKBDRDiag2 = $p($g(^MKBDR(MKBDRRowId)),"^",2)
                s MKBDRDiag3 = $p($g(^MKBDR(MKBDRRowId)),"^",3)
                s MKBDRDiag1s =..ReletedDocString(MKBDRDiag1)
                s MKBDRDiag2s =..ReletedDocString(MKBDRDiag2)
                s MKBDRDiag3s =..ReletedDocString(MKBDRDiag3)
    
                s MKBDRDocManDR = $p($g(^MKBDR(MKBDRRowId)),"^",4)  
                s MKBDRKey1 = $p($g(^MKBDR(MKBDRRowId)),"^",7)  
                s MKBDRKey2 = $p($g(^MKBDR(MKBDRRowId)),"^",8)  
                s MKBDRKey3 = $p($g(^MKBDR(MKBDRRowId)),"^",9)  
                
                s MKBDocRowId = MKBDRDocManDR
                s MKBDocDesc=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),3)
                s MKBDocDesc = ##class(web.DHCBL.BDP.FunLib).Utilstring(MKBDocDesc)
                s MKBDocSource=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),5)
                s MKBDocPath = $LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),4)
                s keyflag = ($zcvt(MKBDRKey1 ,"U")[key)||($zcvt(MKBDRKey2 ,"U")[key)||($zcvt(MKBDRKey3 ,"U")[key)
                    s TremIdm = $p(diagi,"-",1)    
                    s TremIdo1 = $p(MKBDRDiag1,"-",1)
                    s TremIdo2 = $p(MKBDRDiag2,"-",1)
                    s TremIdo3 = $p(MKBDRDiag3,"-",1)
                    s extidxflag=""  
                   if ((TremIdm'=TremIdo1)&(TremIdm'=TremIdo2)&(TremIdm'=TremIdo3))
                   {
                       continue
                   }else{
                      s catAndext = $p($g(diagi),"-",2)
                      for y=1:1:$l($g(catAndext),",")
                      {
                          s catAndexty = $p($g(catAndext),",",y)
                          s extids = $p($g(catAndexty),":",2)
                          for x=1:1:$l($g(extids),"*") 
                          {
                            s flagx1="",flagx2="",flagx3=""
                            s extidx= $p($g(extids),"*",x) 
                            s extidx="("_extidx_")"
                            s:(TremIdm=TremIdo1) flagx1 = (($p($g(MKBDRDiag1s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag1s),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag1)'=diagi)
                            s:(TremIdm=TremIdo2) flagx2 = (($p($g(MKBDRDiag2s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag2s),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag1)'=diagi)
                            s:(TremIdm=TremIdo3) flagx3 = (($p($g(MKBDRDiag3s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag3s),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag1)'=diagi)
                     
                            if (flagx1||flagx2||flagx3)
                              {
                                  
                                  s:extidxflag'="" extidxflag=extidxflag_"1"
                                  s:extidxflag="" extidxflag="1"

                              }else{
                                  
                                  s:extidxflag'="" extidxflag=extidxflag_"0"
                                  s:extidxflag="" extidxflag="0"  
                              }
                             
                      
                          } 
                         
                           
                          
                       }      
                   
                   If ('(extidxflag[0))&&(keyflag)&&($zcvt(MKBDocDesc ,"U")[desc)
                            {
                               
                                s MKBDRDiag1Desc=""
                                s MKBDRDiag2Desc=""
                                s MKBDRDiag3Desc=""
                  
                               s total=total+1
                               if (total<stpage) continue
                               if (total<=endpage)

                                {   
                                    s:MKBDRDiag1'="" MKBDRDiag1Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag1)
                                    s:MKBDRDiag2'="" MKBDRDiag2Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag2)
                                    s:MKBDRDiag3'="" MKBDRDiag3Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag3)
                                    s:re'="" re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=#00ff00><b>中</b></font>"_"""}"
                                    s:re="" re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=#00ff00><b>中</b></font>"_"""}"
                                    
                                }
                            }
                            
                   }
                 
                }
               //低
            s MKBDRRowId=0
            s diagflag=""
            s keyflag=""
            for
            {
                
                s MKBDRRowId = $o(^MKBDR(MKBDRRowId)) q:MKBDRRowId=""
                s MKBDRDiag1 = $p($g(^MKBDR(MKBDRRowId)),"^",1)
                s MKBDRDiag2 = $p($g(^MKBDR(MKBDRRowId)),"^",2)
                s MKBDRDiag3 = $p($g(^MKBDR(MKBDRRowId)),"^",3)
                s MKBDRDiag1s =..ReletedDocString(MKBDRDiag1)
                s MKBDRDiag2s =..ReletedDocString(MKBDRDiag2)
                s MKBDRDiag3s =..ReletedDocString(MKBDRDiag3)
    
                s MKBDRDocManDR = $p($g(^MKBDR(MKBDRRowId)),"^",4)  
                s MKBDRKey1 = $p($g(^MKBDR(MKBDRRowId)),"^",7)  
                s MKBDRKey2 = $p($g(^MKBDR(MKBDRRowId)),"^",8)  
                s MKBDRKey3 = $p($g(^MKBDR(MKBDRRowId)),"^",9)  
                
                s MKBDocRowId = MKBDRDocManDR
                s MKBDocDesc=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),3)
                s MKBDocDesc = ##class(web.DHCBL.BDP.FunLib).Utilstring(MKBDocDesc)
                s MKBDocSource=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),5)
                s MKBDocPath = $LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),4)
                s keyflag = ($zcvt(MKBDRKey1 ,"U")[key)||($zcvt(MKBDRKey2 ,"U")[key)||($zcvt(MKBDRKey3 ,"U")[key)
                    s TremIdm = $p(diagi,"-",1)    
                    s TremIdo1 = $p(MKBDRDiag1,"-",1)
                    s TremIdo2 = $p(MKBDRDiag2,"-",1)
                    s TremIdo3 = $p(MKBDRDiag3,"-",1)
                    s extidxflag=""  
                   if ((TremIdm'=TremIdo1)&(TremIdm'=TremIdo2)&(TremIdm'=TremIdo3))
                   {
                       continue
                   }else{
                      s catAndext = $p($g(diagi),"-",2)
                      for y=1:1:$l($g(catAndext),",")
                      {
                          s catAndexty = $p($g(catAndext),",",y)
                          s extids = $p($g(catAndexty),":",2)
                          for x=1:1:$l($g(extids),"*") 
                          {
                            s flagx1="",flagx2="",flagx3=""
                            s extidx= $p($g(extids),"*",x) 
                            s extidx="("_extidx_")"
                            s:(TremIdm=TremIdo1) flagx1 = (($p($g(MKBDRDiag1s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag1s),"-",2)[("*"_extidx)))
                            s:(TremIdm=TremIdo2) flagx2 = (($p($g(MKBDRDiag2s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag2s),"-",2)[("*"_extidx)))
                            s:(TremIdm=TremIdo3) flagx3 = (($p($g(MKBDRDiag3s),"-",2)[(":"_extidx))||($p($g(MKBDRDiag3s),"-",2)[("*"_extidx)))
                     
                            if (flagx1||flagx2||flagx3)
                              {  
                                  s:extidxflag'="" extidxflag=extidxflag_"1"
                                  s:extidxflag="" extidxflag="1" 
                              }else{    
                                  s:extidxflag'="" extidxflag=extidxflag_"0"
                                  s:extidxflag="" extidxflag="0"
                                  
                              }
                      
                          } 
                          
                       }    
                     
                     If (extidxflag[0)&&(keyflag)&&($zcvt(MKBDocDesc ,"U")[desc)
                            {
                                s MKBDRDiag1Desc=""
                                s MKBDRDiag2Desc=""
                                s MKBDRDiag3Desc=""
                                s total=total+1
                                if (total<stpage) continue
                                if (total<=endpage)
                                {   
                                    s:MKBDRDiag1'="" MKBDRDiag1Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag1)
                                    s:MKBDRDiag2'="" MKBDRDiag2Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag2)
                                    s:MKBDRDiag3'="" MKBDRDiag3Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag3)
                                    s:re'="" re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"低"_"""}"
                                    s:re="" re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"低"_"""}"
                                    
                                }
                            }
                            
                   }
                 
                }
            
            }
     
      q "{""rows"":["_re_"],""total"":"_total_"}"
}

/// Description：文献应用--相关文献GetListDoc
/// Creator：chenghegui
/// CreatedDate：2017-12-20
/// Input: diag, key, desc, start, limit
/// Debug: w ##class(web.DHCBL.MKB.MKBDocManage).GetListReletedDoc("818-12992:261*263,12995:303*305","","","","")
ClassMethod GetListReletedDoc(diag, key, desc, start, limit) As %String
{
    
    if start="" s start=0
    if limit="" s limit=20
    if (diag="")
    { 
       q "{""rows"":["_" "_"],""total"":"_"0"_"}"
    }
    s:desc'="" desc=$zcvt(desc,"U")
    s:key'="" key=$zcvt(key,"U")
    s count=0
    s start=start+1  ///2016/7/26 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条
    s docidstr=""
    s diagstr=""
    s re=""
    s diagLen = $L($g(diag),"+")
        for i=1:1:diagLen
        {
            s diagi = $p($g(diag),"+",i)
            s:diagi'="" diagi=..GetDiagSort(diagi)
            //s diagflag1= $d(^MKBDR(0,"Diag1",diagi))
            //s diagflag2= $d(^MKBDR(0,"Diag2",diagi))
            //s diagflag3= $d(^MKBDR(0,"Diag3",diagi))
            s MKBDRRowId=0
            s diagflag=""
            s keyflag=""
            for
            {
                
                s MKBDRRowId = $o(^MKBDR(MKBDRRowId)) q:MKBDRRowId=""
                s MKBDRDiag1 = $p($g(^MKBDR(MKBDRRowId)),"^",1)
                s MKBDRDiag2 = $p($g(^MKBDR(MKBDRRowId)),"^",2)
                s MKBDRDiag3 = $p($g(^MKBDR(MKBDRRowId)),"^",3)
    
                s MKBDRDocManDR = $p($g(^MKBDR(MKBDRRowId)),"^",4)  
                s MKBDRKey1 = $p($g(^MKBDR(MKBDRRowId)),"^",7)  
                s MKBDRKey2 = $p($g(^MKBDR(MKBDRRowId)),"^",8)  
                s MKBDRKey3 = $p($g(^MKBDR(MKBDRRowId)),"^",9)  
                
                s MKBDocRowId = MKBDRDocManDR
                s MKBDocDesc=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),3)
                s MKBDocDesc = ##class(web.DHCBL.BDP.FunLib).Utilstring(MKBDocDesc)
                s MKBDocSource=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),5)
                s MKBDocPath = $LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),4)
                s keyflag = ($zcvt(MKBDRKey1 ,"U")[key)||($zcvt(MKBDRKey2 ,"U")[key)||($zcvt(MKBDRKey3 ,"U")[key)
                s diagflag= ((..GetDiagSort(MKBDRDiag1))=diagi)||((..GetDiagSort(MKBDRDiag2))=diagi)||((..GetDiagSort(MKBDRDiag3))=diagi)
                if ((keyflag)&&(diagflag)&&($zcvt(MKBDocDesc ,"U")[desc))  //精确查询
                    {
                        s count=count+1
                        s MKBDRDiag1Desc=""
                        s MKBDRDiag2Desc=""
                        s MKBDRDiag3Desc=""
                        if (count<start) continue
                        if ((count<(start+limit)))
                        {   
                            /*s:docidstr'="" docidstr=docidstr_"^"_MKBDRDocManDR
                            s:docidstr="" docidstr=MKBDRDocManDR
                            s:diagstr'="" diagstr=diagstr_"^"_MKBDRRowId
                            s:diagstr="" diagstr=MKBDRRowId*/
                            s:MKBDRDiag1'="" MKBDRDiag1Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag1)
                            s:MKBDRDiag2'="" MKBDRDiag2Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag2)
                            s:MKBDRDiag3'="" MKBDRDiag3Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag3)
                            s:count=1 re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=red>精确</font>"_"""}"
                            s:count>1 re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"<font color=red>精确</font>"_"""}"
                       
                        }
                    
                    }
                    s TremIdm = $p(diagi,"-",1)    //模糊查询
                    s TremIdo1 = $p(MKBDRDiag1,"-",1)
                    s TremIdo2 = $p(MKBDRDiag2,"-",1)
                    s TremIdo3 = $p(MKBDRDiag3,"-",1)
                    s extidxflag=""  
                   if ((TremIdm'=TremIdo1)&(TremIdm'=TremIdo2)&(TremIdm'=TremIdo3))
                   {
                       continue
                   }else{
                      s catAndext = $p($g(diagi),"-",2)
                      for y=1:1:$l($g(catAndext),",")
                      {
                          s catAndexty = $p($g(catAndext),",",y)
                          s extids = $p($g(catAndexty),":",2)
                          for x=1:1:$l($g(extids),"*") 
                          {
                            s flagx1="",flagx2="",flagx3=""
                            s extidx= $p($g(extids),"*",x) 
                            s:(TremIdm=TremIdo1) flagx1 = (($p($g(MKBDRDiag1),"-",2)[(":"_extidx))||($p($g(MKBDRDiag1),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag1)'=diagi)
                            s:(TremIdm=TremIdo2) flagx2 = (($p($g(MKBDRDiag2),"-",2)[(":"_extidx))||($p($g(MKBDRDiag2),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag2)'=diagi)
                            s:(TremIdm=TremIdo3) flagx3 = (($p($g(MKBDRDiag3),"-",2)[(":"_extidx))||($p($g(MKBDRDiag3),"-",2)[("*"_extidx)))&&(..GetDiagSort(MKBDRDiag3)'=diagi)
                     
                            if (flagx1||flagx2||flagx3)
                              {
                                  
                                  s:extidxflag'="" extidxflag=extidxflag_"1"
                                  s:extidxflag="" extidxflag="1"
                                 
                                
                              }else{
                                  
                                  s:extidxflag'="" extidxflag=extidxflag_"0"
                                  s:extidxflag="" extidxflag="0"
                                  
                              }
                      
                          } 
                          If (extidxflag>0)&&(keyflag)&&($zcvt(MKBDocDesc ,"U")[desc)
                            {
                                s count=count+1
                                s MKBDRDiag1Desc=""
                                s MKBDRDiag2Desc=""
                                s MKBDRDiag3Desc=""
                                if (count<start) continue
                                if (count<(start+limit))
                                {   
                                    /*s:docidstr'="" docidstr=docidstr_"^"_MKBDRDocManDR
                                    s:docidstr="" docidstr=MKBDRDocManDR
                                    s:diagstr'="" diagstr=diagstr_"^"_MKBDRRowId
                                    s:diagstr="" diagstr=MKBDRRowId*/
                                    s:MKBDRDiag1'="" MKBDRDiag1Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag1)
                                    s:MKBDRDiag2'="" MKBDRDiag2Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag2)
                                    s:MKBDRDiag3'="" MKBDRDiag3Desc = ##class(web.DHCBL.MKB.MKBDocRelation).GetDiagDesc(MKBDRDiag3)
                                     //re["{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"模糊"_"""}"
                                    s:re'="" re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"模糊"_"""}"
                                    s:re="" re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_""",""MKBDRDiag1Desc"":"""_MKBDRDiag1Desc_""",""MKBDRDiag2Desc"":"""_MKBDRDiag2Desc_""",""MKBDRDiag3Desc"":"""_MKBDRDiag3Desc_""",""flag"":"""_"模糊"_"""}"
                                    
                                }
                            }
                       }           
                 
                   
                            
                   }
                 
                }
            }
       /*s total=0
       for docidi=1:1:$L($g(docidstr),"^")
       {
            s MKBDocRowId = $p($g(docidstr),"^",docidi)
            s rowidN = $p($g(docidstr),"^",docidi+1,$L($g(docidstr),"^"))  //这两行代码去重
            continue:rowidN[MKBDocRowId                                    //
            s MKBDocDesc=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),3)
            s MKBDocDesc = ##class(web.DHCBL.BDP.FunLib).Utilstring(MKBDocDesc)
            s MKBDocSource=$LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),5)
            s MKBDocPath = $LISTGET($G(^User.MKBDocManageD(MKBDocRowId)),4) 
            if ($zcvt(MKBDocDesc ,"U")[desc){
                s total=total+1
                s:re'="" re=re_","_"{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_"""}"
                s:re="" re="{""MKBDocRowId"":"""_MKBDocRowId_""",""MKBDocDesc"":"""_MKBDocDesc_""",""MKBDocPath2"":"""_MKBDocPath_""",""MKBDocPath3"":"""_MKBDocPath_""",""MKBDocPath"":"""_MKBDocPath_""",""MKBDocSource"":"""_MKBDocSource_"""}"
            } 
       }  */   
       
      q "{""rows"":["_re_"],""total"":"_count_"}"
}

/// Description：文献应用--相关文献GetListDesc
/// Creator：chenghegui
/// CreatedDate：2017-12-20
/// Input: 类似818-12995:303,818-12995:305的id字符串818是诊断id,12995是属性id,303和305是明细id
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDocManage","GetListDesc","818-12995:303*305,12992:43071*257*260*267"")
Query GetListDesc(rowidstr As %String) As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod GetListDescExecute(ByRef qHandle As %Binary, rowidstr As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
    q:rowidstr="" ""
    if (rowidstr["-"=0)
    {
        s rowidstr=rowidstr_"-" 
    }
    s RowId1 = $p($g(rowidstr),"-",1)
    //s termDesc = ##class(web.DHCBL.MKB.MKBICDRelation).GetICDTremInfo(RowId1)
    s RowId2Str = $p($g(rowidstr),"-",2)
    q:RowId2Str="" ""
    s RowId3strL = $l(RowId2Str,",")
    for j=1:1:RowId3strL {
        s RowId4Str = $p($g(RowId2Str),",",j)
        s extendId =  $p($g(RowId4Str),":",1)
        s detailIds = $p($G(RowId4Str),":",2)
        /*s DescOld = ##class(web.DHCBL.MKB.MKBICDRelation).GetICDConInfo(extendId,detailIds)
        s xtendDesc = $p($g(DescOld),"=",1)
        s xtendDesc = $p($g(xtendDesc),"(",2)
        s detailDesc =$p($g(DescOld),"=",2)
        s Desc = xtendDesc_"("_detailDesc*/
        s DescStr =..GetICDConInfo(extendId,detailIds,"")
        s extendDesc = $p($g(DescStr),"^",1)
        s DescDetail = $p($g(DescStr),"^",2)
        s RowIdstr = $p($g(DescStr),"^",3)
        s DescLen = $L(DescDetail,",")
        for i=1:1:DescLen
        {
            
            s Desc = $p(DescDetail,",",i)_"("_extendDesc_")"
            s RowId = RowId1_"-"_extendId_":"_$p(RowIdstr,",",i)
            d OutputRow 
        }
    
    }
      
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RowId,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListDescExecute ]
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

/// Description：获取属性描述及属性内容信息（多条）
/// Creator：chenghegui
/// Input:xtendId-属性User.MKBTremExtend表的ID  detailIds-属性内容User.MKBTremExtendDetail表的ID，flag标志
/// return:flag为"textare"时：属性{属性明细1,属性明细2},否则：属性"^"属性明细1,属性明细2"^"明细id1,明细id2
/// Debug: w ##class(web.DHCBL.MKB.MKBDocManage).GetICDConInfo("3","1*2","")
ClassMethod GetICDConInfo(extendId As %String, detailIds As %String, flag As %String) As %String
{
    s detailDesc="",extendDesc="",result="",RowId=""
    if (extendId'="")
    {
        s extendDesc=$p($g(^MKBTREEXT(extendId)),"^",2)  //属性描述
        s MKBTEType=$p($g(^MKBTREEXT(extendId)),"^",3)
        if (MKBTEType="TX")  //文本型
        {
            s MKBTDRowId=$o(^MKBTREEXTDTLi(0,"Ext",extendId,0))
            s:MKBTDRowId'="" detailDesc=$p($g(^MKBTREEXTDTL(MKBTDRowId)),"^",2)
            s:detailDesc'="" detailDesc=$tr(detailDesc,$c(10),"")
            s:RowId'="" RowId=RowId_","_MKBTDRowId
            s:RowId="" RowId=MKBTDRowId
        }
        elseif (MKBTEType="S")  //引用术语型
        {
            s MKBTDRowId=$o(^MKBTREEXTDTLi(0,"Ext",extendId,0))
            s descids=""
            s:MKBTDRowId'="" descids=$p($g(^MKBTREEXTDTL(MKBTDRowId)),"^",2)
            if (descids'="")
            {
                s argsLen=$Length(descids,",")
                for i=1:1:argsLen   
                {     
                    s MKBTRBRowId=$p(descids,",",i)
                    s MKBTRBDesc=$p($g(^MKBTREM(MKBTRBRowId)),"^",2) //引用术语描述
                    s:detailDesc'="" detailDesc=detailDesc_","_MKBTRBDesc
                    s:detailDesc="" detailDesc=MKBTRBDesc
                    s:RowId'="" RowId=RowId_","_MKBTRBRowId
                    s:RowId="" RowId=MKBTRBRowId
                }
            }
        }
        elseif(MKBTEType="C")  //为引用属性型
        {
            s MKBTDRowId=$o(^MKBTREEXTDTLi(0,"Ext",extendId,0))   //属性明细表ID
            s descStr=""
            s:MKBTDRowId'="" descStr=$p($g(^MKBTREEXTDTL(MKBTDRowId)),"^",2) //属性内容
            if (descStr'="")
            {
                s argsLen=$Length(descStr,",")
                for i=1:1:argsLen   
                {     
                  s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
                  s MKBTERowId=$p(descAndType,"*",1)  //术语属性id
                  s MKBTEDesc=$p($g(^MKBTREEXT(MKBTERowId)),"^",2)  //术语属性描述
                  s:detailDesc'="" detailDesc=detailDesc_","_MKBTEDesc
                  s:detailDesc="" detailDesc=MKBTEDesc
                  s:RowId'="" RowId=RowId_","_MKBTERowId
                  s:RowId="" RowId=MKBTERowId
                }
            }
            
        }
        else  //树形或列表型
        {
            if (detailIds'="")
            { 
                s detailIdLen=$Length(detailIds,"*")
                for i=1:1:detailIdLen{
                    s detailId=$p(detailIds,"*",i)
                    s detailDescp=$p($g(^MKBTREEXTDTL(detailId)),"^",2)  //属性内容描述   
                    if (detailDesc=""){
                        s detailDesc=detailDescp
                    }
                    else{
                        s detailDesc=detailDesc_","_detailDescp
                    }
                    s:RowId'="" RowId=RowId_","_detailId
                    s:RowId="" RowId=detailId           
                }
                    
            }
        }
    }
    if (detailDesc'="")
    {
        //s result="("_extendDesc_"="_detailDesc_")"
        if (flag="textare"){      //标志 
                s result= extendDesc_"{"_detailDesc_"}"
            }else{
                s result= extendDesc_"^"_detailDesc_"^"_RowId
            }
    }
    q result
}

/// Desc:根据传入的id串获取对应的诊断描述
/// Creator:李欣
/// Date:20180410
/// Input:ids : 诊断代码串
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetRelationList","","")
ClassMethod GetDiagDesc(ids As %String) As %String
{
 //qqqq
	;w ##class(web.DHCBL.MKB.TKBICDRelation).GetDiagDesc("10-6:")
	s result=""
	if (ids'=""){
		s termId=$p(ids,"-",1) //诊断id
		s termDesc=..GetICDTermInfo(termId)	//获取术语描述
		s property=$p(ids,"-",2) //属性及内容多条
		if (property'=""){
			s extendDesc=""
			s propertyLen=$Length(property,",")
			for i=1:1:propertyLen
			{
				s extend=$p(property,",",i)
				s extendId=$p(extend,":",1)
				s detailIds=$p(extend,":",2)
				s detailDesc=..GetICDPDInfo(extendId,detailIds)	
				if (extendDesc="")
				{
					s extendDesc=detailDesc
				}else
				{
					s extendDesc=extendDesc_detailDesc
				}
			}
			s result=termDesc_extendDesc
		}
		else
		{
			s result=termDesc
		}
	}
	q result
}

/// 获取属性描述及属性内容信息（多条）
/// Input:proid-属性User.MKBTermProperty表的ID  detailIds-属性内容User.MKBTermProDetail表的ID
/// return:属性描述=属性内容1,属性内容2
/// Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).GetICDPDInfo("3","1*2")
ClassMethod GetICDPDInfo(proid As %String, detailIds As %String) As %String
{
	s detailDesc="",proDesc="",result=""
	if (proid'="")
	{
		s proDesc = $LG($G(^User.MKBTermPropertyD(proid)),3) //属性描述
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(proid)),4) //属性类型
		/*
		if (MKBTPType="TX")  //文本型
		{
			s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",proid,0))
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0))
			s:MKBTPDRowId'="" detailDesc=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s:detailDesc'="" detailDesc=$tr(detailDesc,$c(10),"")
		}
		elseif (MKBTPType="S")  //引用术语型
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0))
			s descids=""
			s:MKBTPDRowId'="" descids=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if (descids'="")
			{
				s argsLen=$Length(descids,",")
			    for i=1:1:argsLen   
			    {     
			        s MKBTRowId=$p(descids,",",i)
				    s MKBTDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)
				    s:detailDesc'="" detailDesc=detailDesc_","_TKBTRBDesc
				    s:detailDesc="" detailDesc=TKBTRBDesc
			    }
			}
		}
		elseif(MKBTPType="P")  //为引用属性型
		{ 
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0)) //属性内容表ID
			s descStr=""
			s:MKBTPDRowId'="" descStr=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) //属性内容
			if (descStr'="")
			{
				s argsLen=$Length(descStr,",")
			    for i=1:1:argsLen   
			    {     
			      s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
			      s TKBTERowId=$p(descAndType,"*",1)  //术语属性id
				  s TKBTEDesc=$p($g(^TKBTREEXT(TKBTERowId)),"^",2)  //术语属性描述
				  s:detailDesc'="" detailDesc=detailDesc_","_TKBTEDesc
				  s:detailDesc="" detailDesc=TKBTEDesc
			    }
			}
			
		}
		*/
		if (MKBTPType="T")||(MKBTPType="L")  //树形或列表型
		{
			if (detailIds'="")
			{ 
				s detailIdLen=$Length(detailIds,"*")
				for i=1:1:detailIdLen
				{
					s detailId=$p(detailIds,"*",i)	
					s detailDescp=$LG($G(^User.MKBTermProDetailD(detailId)),3) //属性内容描述	
					if (detailDesc="")
					{
						s detailDesc=detailDescp
					}
					else
					{
						s detailDesc=detailDesc_","_detailDescp
					}				
				}
					
			}
		}
	}
	if (detailDesc'="")
	{
		s result="("_proDesc_"="_detailDesc_")"
	}
	q result
}

/// Desc:根据传入的id串获取对应的诊断描述
/// Creator:李欣
/// Date:20180410
/// Input:ids : 诊断代码串
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetRelationList","","")
ClassMethod GetDiagDescT(ids As %String) As %String
{
	;w ##class(web.DHCBL.MKB.TKBICDRelation).GetDiagDesc("10-6:")
	s result=""
	if (ids'=""){
		s termId=$p(ids,"-",1) //诊断id
		s termDesc=..GetICDTermInfo(termId)	//获取术语描述
		s property=$p(ids,"-",2) //属性及内容多条
		if (property'=""){
			s extendDesc=""
			s propertyLen=$Length(property,",")
			for i=1:1:propertyLen
			{
				s extend=$p(property,",",i)
				s extendId=$p(extend,":",1)
				s detailIds=$p(extend,":",2)
				s detailDesc=..GetICDPDInfo(extendId,detailIds)	
				if (extendDesc="")
				{
					s extendDesc=detailDesc
				}else
				{
					s extendDesc=extendDesc_detailDesc
				}
			}
			s result=termDesc_extendDesc
		}
		else
		{
			s result=termDesc
		}
	}
	q result
}

/// Desc:根据传入的术语id，判断术语常用名，别名及检索码是否包含desc
/// Creator:李欣
/// Date:20180410
/// Input:termid : 术语id desc : 要判断包含的字符串
/// Other:
ClassMethod GetComHasFlag(termid, desc)
{
	s Com = ""
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s Flag="N"
	s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",termid," 常用名",0))
	s MKBTEPChildSub = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 检索码",0))
	s MKBTEPRowId = MKBTPRowId_"||"_MKBTEPChildSub
	s MKBTPDRowId = 0
	for
	{
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
		q:MKBTPDRowId=""
		s Com=Com_"&%"_$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBTEPVRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))
		s Com=Com_"&%"_$LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
	}
	if (Com[desc)
	{
		s Flag="Y"	
	}
	q Flag
}

/// 获取临床实用诊断术语描述
/// Input:termid-术语User.MKBTrem表的ID
/// return:术语描述
/// Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).GetICDTermInfo(14495)
ClassMethod GetICDTermInfo(termid As %String) As %String
{
	s result=""
	if (termid'="")
	{ 
		s termDesc = $LG($G(^User.MKBTermD(termid)),3) //术语描述
		s termCode = $LG($G(^User.MKBTermD(termid)),2) //术语代码	
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",termid," 常用名",0))
		if (MKBTPRowId="")
		{
			s result=termDesc
		}
		else
		{
			S MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) 
			if (MKBTPDDesc'="")
			{
				s result=MKBTPDDesc
			}
			else
			{
				s result=termDesc	//如果常用名为空则常用名=诊断中心词
			} 	
		}	
	}
	q result
}

/// 石萧伟
/// 取平台配置的ftp开启配置
/// w ##class(web.DHCBL.MKB.MKBDocManage).findFTPFlag()
ClassMethod findFTPFlag() As %String
{
	s flag="false"
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPPlatformConfig||FindStr")
    i ($IsObject(myobj)){
		//取index
		s id=""
		s id=$o(^User.BDPConfigI("ConfigDescI"," 是否开启FTP配置",0))
		s:id'="" flag=$LISTGET($G(^User.BDPConfigD(id)),3)
		q flag	    
     }
     else 
     {
	     q "false"
	 }
}

/// 石萧伟
/// 获取平台配置发图片用户名密码及端口号
/// "127.0.0.1^dhcbdp^1^21"   //固定配置：IP，User，pass，port
/// w ##class(web.DHCBL.MKB.MKBDocManage).findPortS()
ClassMethod findPortS()
{
	s ipDesc=""
	s userDesc=""
	s passDesc=""
	s portDesc=""
	s ipId=$o(^User.BDPConfigI("ConfigDescI"," 附件服务器IP",0))
	if (ipId'="")
	{
		s ipDesc=$LISTGET($G(^User.BDPConfigD(ipId)),3)
		
		s usertId=$o(^User.BDPConfigI("ConfigDescI"," 用户名",0))
		s:usertId'="" userDesc=$LISTGET($G(^User.BDPConfigD(usertId)),3)
		
		s passId=$o(^User.BDPConfigI("ConfigDescI"," 密码",0))
		s:passId'="" passDesc=$LISTGET($G(^User.BDPConfigD(passId)),3)
		
		s portId=$o(^User.BDPConfigI("ConfigDescI"," 端口",0))
		s:portId'="" portDesc=$LISTGET($G(^User.BDPConfigD(portId)),3)
		
		q ipDesc_"^"_userDesc_"^"_passDesc_"^"_portDesc	
	}
	else
	{
		q ""
	}
}

/// Creator:李得原
/// CreatDate:2019-04-29
/// Description:根据word文件名生成pdf文件
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBDocManage).Word2Pdf("临床知识库使用说明书.doc")
ClassMethod Word2Pdf(filename)
{
	
	s cmd1="word2pdf.exe.lnk /source ""D:\DtHealth\app\dthis\web\scripts\bdp\MKB\Doc\Doc\"""_filename
	s cmd2="/target ""D:\DtHealth\app\dthis\web\scripts\bdp\MKB\Doc\Doc\"""
	s cmd=cmd1_" "_cmd2
	s sc=$zf(-2,cmd)
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2020-05-14
/// Description:文献导入到知识库
/// Table:User.MKBDocManage
/// Input:FilePath-csv文件路径
/// Return:导入结果
/// Other:w ##class(web.DHCBL.MKB.MKBDocManage).ImportMKBDoc("E:\BDP文档\医学知识库\文献.csv")
ClassMethod ImportMKBDoc(FilePath)
{
	s file=##class(%File).%New(FilePath)
	s result=""
	d file.Open("RS")
	d file.ReadLine()
	
	TS 
	while 'file.AtEnd
	{
		s str=file.ReadLine()

	    s MKBDMDesc=$p(str,",",1)  
	    s MKBDMDesc=$Zstrip(MKBDMDesc,"<>W")
		continue:MKBDMDesc=""
        s flag=..FormValidate("",MKBDMDesc)   
        if (flag=1)
        {
            //s result = "{success:'false',errorinfo:'已存在相同名称的数据！'}"
        }
        else
        { 
       		s obj=##class(User.MKBDocManage).%New()	
       		s obj.MKBDMCode=..GetLastCode()
       		s obj.MKBDMDesc=MKBDMDesc
       		s obj.MKBDMPath=MKBDMDesc
       		s obj.MKBDMType="P"
       		s obj.MKBDMFlag="F"
       		s obj.MKBDMUpdateDate=$p($h,",",1)
       		d obj.MKBDMUpdateUserSetObjectId(1)
       		s obj.MKBDMSource=$p(str,",",3)
       		s obj.MKBDMKeyWord=$p(str,",",2)
       	    s obj.MKBDMClassify=$p(str,",",6)
       		s obj.MKBDMNote=$p(str,",",8)
       		s sc=obj.%Save()
			d obj.%Close()
        	if '$$$ISOK(sc)
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				q
			}
        }
	}

	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="{success:'true',info:'文献上传成功！'}"
	}
	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-09-07
/// Input:docPath-文献所在的文件夹
/// Description: 导出不能预览的文献
/// Table: User.MKBDocManage
/// w ##class(web.DHCBL.MKB.MKBDocManage).ExportUnReadDoc()
ClassMethod ExportUnReadDoc()
{
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理列表.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	s Wfile=##class(%File).%New(P)
	d Wfile.Open("NWS")
	
	d Wfile.WriteLine("ID,文献名,能否预览,能否删除")
    s MKBDMRowId=0
    for{  
      s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
      s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
      s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
      s path=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\Doc\Doc\"_MKBDMPath
      s ExistsFlag=##class(%File).Exists(path)
      s DeleteFlag=##class(web.DHCBL.MKB.MKBDocManage).GetRefFlag(MKBDMRowId)
      s str=MKBDMRowId_","_MKBDMDesc_","_ExistsFlag_","_DeleteFlag
      d Wfile.WriteLine(str)    
    }
	
	d Wfile.%Save()
	d Wfile.%Close()
	q fileName
}

}
