/// 名称:  码表数据日志管理 供其他产品组调用
/// 编写者：基础数据平台组 sunfengchao
/// 编写日期: 2018-1-29
Class web.DHCBL.BDP.BDPDataChangeLogForOther Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function： 通过参数进行数据的查询 分页版
/// Creator:   sunfengchao
/// CreateDate: 2015-12-4
/// d ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).QueryByParams("","","","","","User.ARCItmMast^User.DHCOrderLinkTar",0,20)
ClassMethod QueryByParams2(OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, OperateTypeD As %String, UserClass As %String, ClassN As %String, dizzyDesc As %String, start As %String, limit As %String, ObjectId As %String = "") As %String
{
     new (OBJDESC,UserDR,datefrom, dateto,OperateTypeD,UserClass,ClassN,dizzyDesc,start,limit,%Session)
     s ID="", strResult=""  
     s count=0  
     s methodflag= ##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.BDP.FunLib","DateHtmlToLogical") 
     if (methodflag=1){
        s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)  
        s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
     }
     else{
        s:datefrom'="" datefrom=$zdh(datefrom,5) 
        s:dateto'="" dateto=$zdh(dateto,5) 
     }
    s:datefrom="" datefrom= +$h-365 ;; 默认查询一年的数据
    s:dateto="" dateto=+$h 
    s Len= $length(UserClass,"^") 
    for i=1:1:Len
    {
     s UserClassI = $p(UserClass,"^",i)
     s:UserClassI'="" UserClassI=$zcvt(UserClassI,"U")
    
     
     for
     {
          s ID=$o(^User.BDPDataChangeLogI("ClassNameIndex"," "_UserClassI,ID),-1)  
          q:ID=""   
          s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
          s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
          s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
          s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
          s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
          s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
          s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
          s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
          s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
          s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9) 
          s RelevantKey=$LISTGET($G(^User.BDPDataChangeLogD(ID)),15) 
          if (ClassName["^") s ClassName= $p(ClassName,"(",1)
          if ((($zcvt(ClassName,"U")=UserClassI)||(UserClassI=""))&((($zcvt(ClassNameDesc,"U")[ClassN)||(ClassN="")))&((UpdateDate>=datefrom)&&(UpdateDate<=dateto))&((UserDR="")||($zcvt(UpdateUserName,"U")[UserDR)||($$ALPHAUP^SSUTIL4(UpdateUserDR)[UserDR))&((OBJDESC="")||((OBJDESC'="")&((ObjectDesc[OBJDESC)||(ObjectReference[OBJDESC))))&((OperateTypeD="")||((OperateTypeD'="")&(OperateType=OperateTypeD)))&((dizzyDesc="")||((dizzyDesc'="")&(($$ALPHAUP^SSUTIL4(ClassName)[dizzyDesc)||(($$ALPHAUP^SSUTIL4(ClassNameDesc)[dizzyDesc) ||($zcvt(TableName,"U")[dizzyDesc)||($zcvt(ObjectReference,"U")[dizzyDesc)||($zcvt(ObjectDesc,"U")[dizzyDesc)||(($$ALPHAUP^SSUTIL4(UpdateUserDR)[dizzyDesc)))))))
          { 
               if (RelevantKey'="")
               {  
                 if ($d(^BDPChangeLogLogI("BDPLog",RelevantKey)))
                 {
                    s LogID=0
                    for
                    {
                        s LogID=$O(^BDPChangeLogLogI("BDPLog",RelevantKey,LogID))
                        q:LogID=""
                        s count=count+1
                        if (count<=start) continue
                        if (count<=(start+limit))
                        { 
                            if (strResult'="")
                            { 
                                s strResult=strResult_"^"_LogID
                            }
                            else
                            { 
                                s strResult=LogID
                            }       
                        } 
                    }        
                 } 
            } 
            else 
            { 
               s count=count+1
               if (count<=start) continue
               if (count<=(start+limit))
               {   
                  if (strResult'="")
                  { 
                    s strResult=strResult_"^"_ID
                  }
                  else
                  { 
                    s strResult=ID
                  }  
               }  
            }
          }
        } 
    }
    d ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).QueryByRowIds(strResult)
    k ^TMP("BDPDataChangelog","Count")
    s ^TMP("BDPDataChangelog","Count")=count
}

ClassMethod QueryByParams(OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, OperateTypeD As %String, UserClass As %String, ClassN As %String, dizzyDesc As %String, start As %String, limit As %String, ObjectId As %String = "") As %String
{
     new (OBJDESC,UserDR,datefrom, dateto,OperateTypeD,UserClass,ClassN,dizzyDesc,start,limit,ObjectId,%Session)
     s ID="", strResult=""  
     k TMPLOGArr
     s count=0  
     s total=0
     s methodflag= ##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.BDP.FunLib","DateHtmlToLogical") 
     if (methodflag=1){
        s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)  
        s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
     }
     else{
        s:datefrom'="" datefrom=$zdh(datefrom,5) 
        s:dateto'="" dateto=$zdh(dateto,5) 
     }
    s:datefrom="" datefrom= +$h-365 ;; 默认查询一年的数据
    s:dateto="" dateto=+$h 
    s Len= $length(UserClass,"^") 
    s ^TMPLOGArr1=datefrom_"^ "_dateto
    for i=1:1:Len
    {
         s UserClassI = $p(UserClass,"^",i)
         s:UserClassI'="" UserClassI=$zcvt(UserClassI,"U")
         
         for
         {
              s ID=$o(^User.BDPDataChangeLogI("ClassNameIndex"," "_UserClassI,ID),-1)  
              q:ID=""  
              s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7) 
              continue:(UpdateDate>dateto)||(UpdateDate<datefrom)
              
              s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
              s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
              s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
              s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
              s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
              s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
              s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
              s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6) 
              s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9) 
              s RelevantKey=$LISTGET($G(^User.BDPDataChangeLogD(ID)),15) 
              if (ClassName["^") s ClassName= $p(ClassName,"(",1)
            
              if ((($zcvt(ClassName,"U")=UserClassI)||(UserClassI=""))&((($zcvt(ClassNameDesc,"U")[ClassN)||(ClassN="")))&((UpdateDate>=datefrom)&&(UpdateDate<=dateto))&((UserDR="")||($zcvt(UpdateUserName,"U")[UserDR)||($$ALPHAUP^SSUTIL4(UpdateUserDR)[UserDR))&((OBJDESC="")||((OBJDESC'="")&((ObjectDesc[OBJDESC)||(ObjectReference[OBJDESC))))&((OperateTypeD="")||((OperateTypeD'="")&(OperateType=OperateTypeD)))&((ObjectReference=ObjectId)||(ObjectId=""))&((dizzyDesc="")||((dizzyDesc'="")&(($$ALPHAUP^SSUTIL4(ClassName)[dizzyDesc)||(($$ALPHAUP^SSUTIL4(ClassNameDesc)[dizzyDesc) ||($zcvt(TableName,"U")[dizzyDesc)||($zcvt(ObjectReference,"U")[dizzyDesc)||($zcvt(ObjectDesc,"U")[dizzyDesc)||(($$ALPHAUP^SSUTIL4(UpdateUserDR)[dizzyDesc)))))))
              { 
                s TMPLOGArr(ID)=""
                s total=total+1 
              } 
         }
    }
     
     s LogRID=""
     for
     {
        s LogRID=$O(TMPLOGArr(LogRID),-1) q:LogRID=""
        s count=count+1  
        if (count<=start) continue
        if (count<=(start+limit))
        { 
            if (strResult'="")
            { 
                s strResult=strResult_"^"_LogRID
            }
            else
            { 
                s strResult=LogRID
            }       
        }
        else
        {
            q 
        }    
     }    
    d ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).QueryByRowIds(strResult)
    k ^TMP("BDPDataChangelog","Count")
    s ^TMP("BDPDataChangelog","Count")=total
}

/// d ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).GetList("13","","","","","User.CSSDPackage","","","0","20")
ClassMethod GetList(OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, OperateTypeD As %String, UserClass As %String, ClassN As %String, dizzyDesc As %String, start As %String, limit As %String, ObjectId As %String = "") As %String
{
 
  new (OBJDESC,UserDR,datefrom, dateto,OperateTypeD,UserClass,ClassN,dizzyDesc,ObjectId,start,limit,%Session)
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..QueryByParams(OBJDESC,UserDR,datefrom, dateto,OperateTypeD,UserClass,ClassN,dizzyDesc,start,limit,ObjectId)
  w "]" 
  s count=$g(^TMP("BDPDataChangelog","Count"))
  w ",total:"_count
  w "}"
}

/// ////////////////////////////////////////////////////////////////////////
/// Function：  通过RowID 查询日志数据,批量查询
/// Creator:    sunfengchao
/// CreateDate: 2015-12-7
/// Debug:      d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByRowIds("16133^16132^16131^16130")
ClassMethod QueryByRowIds(strResult As %String) As %String
{
  n (strResult,%Session)
  s len=$length(strResult,"^") 
  for i=1:1:len
  {
    s ID=$p(strResult,"^",i)
    if (ID'="")
    {
    s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
    s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
    s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
    s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
    s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
    s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
    s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
    s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
    s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
    s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
    s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
    s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式 
    s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
    s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13) 
    s RelevantKey=$LISTGET($G(^User.BDPDataChangeLogD(ID)),15) 
    s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
    s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
    s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
    s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
    s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc) 
    s UpdateUserDR=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserDR)
    s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
    s IpAddress=##class(web.DHCBL.BDP.FunLib).EvalJSON(IpAddress)
    if (ClassName["^") s ClassName= $p(ClassName,"(",1)  
  
    if (ID=$p(strResult,"^",1))
    {          
     
     }
    else
    {
      w ","
    } 
    w "{""ID"":"""_ID_""",""IpAddress"":"""_IpAddress_""",""TableName"":"""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_""",""ObjectReference"":"""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_""",""OperateType"":"""_OperateType_""",""RelevantKey"":"""_RelevantKey_"""}" 
         
   }
  }
}

/// Function: 查看<日志数据明细>
/// Creator:  sunfengchao
/// CreateDate: 2016-1-20
/// Input:    id
/// Debugs:   w ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).GetDataDetail("1")
ClassMethod GetDataDetail(id As %String) As %String
{
    n (id,%Session)
    s resultStr =""
    if (id="")
    {
      q "ID为空,未查询到数据明细!"
    }
    else
    {
       s TableName=$LISTGET($G(^User.BDPDataChangeLogD(id)),2)
       s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(id)),3)
       s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(id)),9)
       s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),10)
       s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),14)
       s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue) 
       s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue) 
       s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
       s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
       if (ClassName["^") s ClassName= $p(ClassName,"(",1) 
       s str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",StrJson="" 
       if (OperateType="U")
       { 
         s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)
         s oldlen=$l(OldValue1,",")
         s newlen=$l(NewValue1,",") 
         for j=1:1:oldlen 
         { 
             s PropertyChinese=""
             s oldstr=$p(OldValue1,",",j)
             s newstr=$p(NewValue1,",",j)
             s Property=$p(oldstr,":",1)
             s PropertyValueOld=$p(oldstr,":",2)
             s PropertyValueNew=$p(newstr,":",2)
             s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
             s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
             s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
             if (PropertyValueOld'=PropertyValueNew) 
             {
               if (str="")
               {
                  s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
                }
                else 
                {
                  s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                }
                s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(str)
            }  
         }  
       }  
     else{ 
      if ((OperateType="D")||(OperateType="A"))  
      {
        s Property=""
        s NewValue1=$e(NewValue,2,$length(NewValue)-1)
        s StrJson=NewValue1   
        for k=1:1:$l(NewValue1,",") 
        {
          s newstr=$p(NewValue1,",",k)
          s Property=$p(newstr,":",1)
          s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
          s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
          if (str="") 
          {
            s str=Property_":"_PropertyValueNew 
          }
          else 
          {
            s str=str_","_Property_":"_PropertyValueNew 
          }
          s StrJson=str   
        } 
        s NewData=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue) 
        s OldData=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
       }
        s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
     }        
      s resultStr ="{""ID"":"""_id_""",""OldValue"":"""_OldValue_""",""NewValue"":"""_NewValue_""",""StrJson"":"""_StrJson_"""}"
   }
   q resultStr
}

/// Function: 根据菜单日志对照 取对照的表
/// CreateDate:2020-04-10
/// Creator:sunfengchao
/// Input:  ClassName :User类
/// Output: result:结果 User类1^User类2^User类3...
/// OHters: w ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).GetLinkTable("User.SSUser")
ClassMethod GetLinkTable(ClassName As %String) As %String
{
   s result=""  
   q:ClassName="" ""       
   s:ClassName'="" ClassName=$ZCONVERT(ClassName,"U") //转换成大写 
   s id=$O(^User.BDPTableListI("UqIndex"," "_ClassName,0)) 
   q:id="" "" 
   s table=$LISTGET($G(^User.BDPTableListD(id)),8) 
   q:table="" ""
   s menucode=##class(web.DHCBL.BDP.BDPExecutables).GetMenuNameByTable(table)  /// 获取菜单名
   s LinkTableName=0
   for
   {
     s LinkTableName=$o(^User.BDPMenuTableI("mt"," "_$zcvt(menucode,"U"),LinkTableName))   /// 获取菜单日志对照的授权数据
     q:LinkTableName=""
     s LinkTableNameI=$tr(LinkTableName," ","")   
     if result="" s result=  LinkTableNameI
     else  s result=result_"^"_LinkTableNameI
   }
   q result
}

/// Function:获取日志数据的修改详情 
/// Retrun:日志比对信息信息
/// CreateDate:2020-12-3
/// Creator:  sunfengchao
/// w ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).GetChangeInfo(407233)
ClassMethod GetChangeInfo(ID As %String) As %String
{
      s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
      s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
      s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
      s str="",str2="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr=""
      s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
      s NewValue1=$e(NewValue,2,$length(NewValue)-1)
      s oldlen=$l(OldValue1,",")
      s newlen=$l(NewValue1,",")
      
      for i=1:1:oldlen
      {
       s PropertyChinese=""
       s oldstr=$p(OldValue1,",",i)
       s newstr=$p(NewValue1,",",i)
       s Property=$p(oldstr,":",1)  
       s PropertyValueOld=$p(oldstr,":",2)
       s PropertyValueNew=$p(newstr,":",2) 
       s Property=$tr(Property,"""","")
     
       s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
       s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
       s PropertyValueOld=$tr(PropertyValueOld,"""","")
       s PropertyValueNew=$tr(PropertyValueNew,"""","")
       if (Property["Date") 
       { 
          if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")=1)&($l(PropertyValueNew,"/")=1))
          {
            s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(PropertyValueNew)
          }
          if ((PropertyValueOld'="")&($l(PropertyValueOld,"-")=1)&($l(PropertyValueOld,"/")=1))
          { 
            s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(PropertyValueOld)
          } 
       } 
       if (Property["Time")
       {  
          if (PropertyValueNew'="")&($l(PropertyValueNew,":")'="")
          {
            s:PropertyValueNew'="" PropertyValueNew=$zt(PropertyValueNew,1) 
          }
          if (PropertyValueOld'="")&($l(PropertyValueOld,":")'="")
          {
            s:PropertyValueOld'="" PropertyValueOld=$zt(PropertyValueOld,1) 
          }
       }  
       s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
       
       if (PropertyValueOld'=PropertyValueNew)
       { 
         if (str="")
         {
           s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
         }
         else
         {
           s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew 
         }
       }
      }
    s StrJson=str
    q StrJson
}

}
