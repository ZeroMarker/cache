/// 名称: 码表数据日志审计
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2015-1-5
Class web.DHCBL.BDP.BDPDataAudit Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description：查询码表数据日志审计数据
/// Creator：陈莹
/// CreatDate:  2015-1-5
/// Table：User.BDPDataChangeLog  User.BDPDataAudit
/// ClassN 功能描述,UserName操作用户,OBJDESC As %String,Date更新日期 01/06/2015
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataAudit","GetList","","","","","","","","")
Query GetList(ClassN As %String, UserName As %String, OBJDESC As %String, Date As %String, Status As %String, Result As %String, AuditUser As %String, AuditDate As %String, start As %String, limit As %String) As %Query(ROWSPEC = "ID:%String,IpAddress:%String,TableName:%String,ClassName:%String,ClassNameDesc,ObjectReference:%String,ObjectDesc,UpdateUserDR:%String,UpdateUserName:%String,UpdateDate:%String,UpdateTime:%String,OperateType:%String,OldValue:%String,NewValue:%String,StrJson:%String,BDPDataAuditDataLogDR,BDPDataAuditRowId,BDPDataAuditStatus,BDPDataAuditDate,BDPDataAuditTime,BDPDataAuditUser,BDPDataAuditResult,BDPDataAuditNote")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ClassN As %String, UserName As %String, OBJDESC As %String, Date As %String, Status As %String, Result As %String, AuditUser As %String, AuditDate As %String, start As %String, limit As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s count=1
    
    s:ClassN'="" ClassN=$zcvt(ClassN,"U") 
    s:UserName'="" UserName=$zcvt(UserName,"U")
    s:OBJDESC'="" OBJDESC=$zcvt(OBJDESC,"U")
    s:AuditUser'="" AuditUser=$zcvt(AuditUser,"U")
    
    if start="" s start=0
    if limit="" s limit=20
    
    s ID=""
    s n=0
    for
    {
        
        s ID=$o(^User.BDPDataChangeLogD(ID),-1) q:(ID=0)||(ID="")
        s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)  //SS_User
        // continue:'(TableName[("SS_User"))&'(TableName[("SS_Group"))&'(TableName[("epr.GroupSettings"))&'(TableName[("BDP_Preferences"))    //除用户和安全相关的日志，跳出本次循环
        s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.SSUser
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
        
        ;审计
        s BDPDataAuditRowId=$O(^BDPDATAAUDIT("0","LOG",ID,0))
        if (BDPDataAuditRowId'="")
        {   
            s BDPDataAuditDataLogDR=ID
            s BDPDataAuditStatus=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",2)
            s BDPDataAuditDate=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",3)
            s BDPDataAuditTime=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",4)   
            s:BDPDataAuditDate'="" BDPDataAuditDate=$zd(BDPDataAuditDate,1)
            s:BDPDataAuditTime'="" BDPDataAuditTime=$zt(BDPDataAuditTime,1)
            
            
            s BDPDataAuditUser=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",5)
            if BDPDataAuditUser'="" s BDPDataAuditUser=$p($g(^SSU("SSUSR",BDPDataAuditUser)),"^",2)
            s BDPDataAuditResult=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",6)
            s BDPDataAuditNote=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",7)
        }
        else
        {   
            s BDPDataAuditDataLogDR=""
            s BDPDataAuditStatus="N" ///未审计
            s BDPDataAuditDate=""
            s BDPDataAuditTime=""
            s BDPDataAuditUser=""
            s BDPDataAuditResult=""
            s BDPDataAuditNote=""
        }
        i (($zcvt(ClassName,"U")[ClassN)||($ZCVT(ClassNameDesc,"U")[ClassN))&($ZCVT(UpdateUserName,"U")[UserName)&((UpdateDate=Date)||(Date=""))&((OBJDESC="")||(OBJDESC'=""&($ZCVT(ObjectDesc,"U")[OBJDESC)))&((Status="")||(BDPDataAuditStatus=Status))&((Result="")||(BDPDataAuditResult=Result))&($ZCVT(BDPDataAuditUser,"U")[AuditUser)&((BDPDataAuditDate=AuditDate)||(AuditDate=""))
        {
            
            s n=n+1
            if (n<=start)||(n>(start+limit))
            {
                 set Data=$lb("","","","","","","","","","","","","","","","","","","","","","","")
                // s UDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7) //更新日期
                // s UTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8) //更新时间
                // set ^CacheTemp("BDPDataChangeLog",$j,UDate,UTime,count)=Data
                // s count=count+1
                 set ^CacheTemp(repid,ind)=Data
                 Set ind=ind+1
                 continue
            }
            s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
            s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
            s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
 
            s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
          
            s StrJson="",str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr=""
 
            if (OperateType="U")
            {
                if TableName["BDP_Preferences"
                {
                     if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
                     if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
                     if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
                     if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
                     s OldData=OldValue
                     s NewData=NewValue
                     s StrJson=OldData_" -> "_NewData 
                }
                else
                {
            
                    s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
                    s NewValue1=$e(NewValue,2,$length(NewValue)-1)
                    s oldlen=$l(OldValue1,",")
                    s newlen=$l(NewValue1,",")
                    s result=""
                    try{
                
                        for i=1:1:oldlen
                        {
                            s PropertyChinese=""
                            s oldstr=$p(OldValue1,",",i)
                            s newstr=$p(NewValue1,",",i)
                            s Property=$p(oldstr,":",1)
                            s PropertyValueOld=$p(oldstr,":",2)
                            s PropertyValueNew=$p(newstr,":",2)
                            s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
                            s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
                            s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
                            if (PropertyValueOld'=PropertyValueNew)
                            {
                                if (str="") s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
                                else  s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                            }
                        }
                        s StrJson=str  
                
                        }catch myvar{
                            s result = myvar.Name
                            ;myvar.Name 会显示报错信息
            
                            if (result="<SYNTAX>")
                            {
                                if OldData'=NewData   s StrJson=OldData_" -> "_NewData
                                else  s StrJson=""
                            }   
                        }
                    }
                }
                else  //if ((OperateType="D")||(OperateType="A"))
                {
            
                    if TableName["BDP_Preferences" 
                    {
                ;;(ObjectDesc["ARC_ItmMast")||(ObjectDesc["MRC_ICDDx")
                 if (OperateType="D")
                 {
                 
                    if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
                    if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
                    if OldValue["1#"  s $p(OldValue,":",5)="""1#"",DataSplitString"
                    if OldValue["0#"  s $p(OldValue,":",5)="""0#"",DataSplitString"
                 }
                 if (OperateType="A")
                 {
                 
                    if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
                    if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
                    if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
                    if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
                 }
                 s OldData=OldValue
                 s NewData=NewValue
                 s StrJson=NewData 
             
            }
            else
            {
                s Property=""
                s NewValue1=$e(NewValue,2,$length(NewValue)-1)
                s StrJson=NewValue1 
                
                s result=""
                try{
                
                    for i=1:1:$l(NewValue1,",")
                    {
                        s PropertyChinese=""
                        s newstr=$p(NewValue1,",",i)
                        s Property=$p(newstr,":",1)
                        ; s PropertyValueNew=$p(newstr,":",2)
                        s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
                        s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
                        if (str="")  s str=Property_":"_PropertyValueNew 
                        else  s str=str_","_Property_":"_PropertyValueNew 
                    }
                    s StrJson=str
                
                    }catch myvar{
                        s result = myvar.Name
                        ;myvar.Name 会显示报错信息
        
                        if (result="<SYNTAX>")
                        {
                            s StrJson=NewValue
                        }       
                    }
                }
            }
    
 
            s lengthstr=$l(StrJson)
            if lengthstr>300 s StrJson=$e(StrJson,1,300)
    
 
 
        
            d OutputRow
        }
    }
 
    ////按照更新时间 将日志倒序排列
    //20130709 Print Start
    /*s L0="" for  s L0=$o(^CacheTemp("BDPDataChangeLog",$j,L0),-1)  q:L0=""  d
    .s L1="" for  s L1=$o(^CacheTemp("BDPDataChangeLog",$j,L0,L1),-1)  q:L1=""  d
    ..s L2="" for  s L2=$o(^CacheTemp("BDPDataChangeLog",$j,L0,L1,L2),-1)  q:L2=""  d
    ...Set ^CacheTemp(repid,ind)=^CacheTemp("BDPDataChangeLog",$j,L0,L1,L2)
    ...Set ind=ind+1
    */
    //end
  
    Set qHandle=$lb(0,repid,0)
    ;k ^CacheTemp("BDPDataChangeLog",$j)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,IpAddress,TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType,OldValue,NewValue,StrJson,BDPDataAuditDataLogDR,BDPDataAuditRowId,BDPDataAuditStatus,BDPDataAuditDate,BDPDataAuditTime,BDPDataAuditUser,BDPDataAuditResult,BDPDataAuditNote)
    //s UDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7) //更新日期
    //s UTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8) //更新时间
    //set ^CacheTemp("BDPDataChangeLog",$j,UDate,UTime,count)=Data
    //s count=count+1
    
    Set ^CacheTemp(repid,ind)=Data
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

/// 审计为正常
/// Other: d ##class(web.DHCBL.BDP.BDPDataAudit).AuditN("1^2")
ClassMethod AuditN(IDstr As %String) As %String
{
    s length=$L(IDstr,"^")
    s i=0
    s result=1
    for
    {
        s i=i+1
        q:i>length
        s ID=$P(IDstr,"^",i)
        continue:ID=""
        ;审计
        s BDPDataAuditRowId=$O(^BDPDATAAUDIT("0","LOG",ID,0))
        if (BDPDataAuditRowId'="")
        {
            s obj=##class(User.BDPDataAudit).%OpenId(BDPDataAuditRowId)
            d obj.BDPDataAuditDataLogDRSetObjectId(ID)
            s obj.BDPDataAuditStatus="Y"   //已审计
            s obj.BDPDataAuditDate=+$h
            s obj.BDPDataAuditTime=$p($h,",",2)
            d obj.BDPDataAuditUserSetObjectId($Get(%session.Data("LOGON.USERID")))
            s obj.BDPDataAuditResult="N"  ///审计正常
            s obj.BDPDataAuditNote=""
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
            }
            else 
            {
                Trollback
                s result=0
            }
        }
        else
        {
            s obj=##class(User.BDPDataAudit).%New()
            d obj.BDPDataAuditDataLogDRSetObjectId(ID)
            s obj.BDPDataAuditStatus="Y"
            s obj.BDPDataAuditDate=+$h
            s obj.BDPDataAuditTime=$p($h,",",2)
            d obj.BDPDataAuditUserSetObjectId("1") //($Get(%session.Data("LOGON.USERID")))
            s obj.BDPDataAuditResult="N"  ///审计正常
            s obj.BDPDataAuditNote=""
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc) {
                Tc
            }else {
                Trollback
                s result=0
            }
        
        }
    }
    if result=0  s result = "{success:'false',info:'ERROR'}"  //返回错误信息
    else  s result = "{success:'true',info:'OK！'}"
    q result
}

/// 审计为异常
ClassMethod AuditA(IDstr As %String) As %String
{
    s length=$L(IDstr,"^")
    s i=0
    s result=1
    for
    {
        s i=i+1
        q:i>length
        s ID=$P(IDstr,"^",i)
        continue:ID=""
        ;审计
        s BDPDataAuditRowId=$O(^BDPDATAAUDIT("0","LOG",ID,0))
        if (BDPDataAuditRowId'="")
        {
            s obj=##class(User.BDPDataAudit).%OpenId(BDPDataAuditRowId)
            d obj.BDPDataAuditDataLogDRSetObjectId(ID)
            s obj.BDPDataAuditStatus="Y"   //已审计
            s obj.BDPDataAuditDate=+$h
            s obj.BDPDataAuditTime=$p($h,",",2)
            d obj.BDPDataAuditUserSetObjectId($Get(%session.Data("LOGON.USERID")))
            s obj.BDPDataAuditResult="A"  ///审计正常
            s obj.BDPDataAuditNote=""
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc) 
            {
                Tc
            }
            else 
            {
                Trollback
                s result=0
            }
        }
        else
        {
            s obj=##class(User.BDPDataAudit).%New()
            d obj.BDPDataAuditDataLogDRSetObjectId(ID)
            s obj.BDPDataAuditStatus="Y"
            s obj.BDPDataAuditDate=+$h
            s obj.BDPDataAuditTime=$p($h,",",2)
            d obj.BDPDataAuditUserSetObjectId($Get(%session.Data("LOGON.USERID")))
            s obj.BDPDataAuditResult="A"  ///审计正常
            s obj.BDPDataAuditNote=""
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc) 
            {
                Tc
            }
            else 
            {
                Trollback
                s result=0
            }
        
        }
    }
    if result=0  s result = "{success:'false',info:'ERROR'}"  //返回错误信息
    else  s result = "{success:'true',info:'OK！'}"
    q result
}

/// Function: 后台分页版 数据查询
/// Creator:  sunfengchao
/// CreateDate:2020-04-09
/// Debug:    d ##class(web.DHCBL.BDP.BDPDataAudit).GetList("","","","","","","","","",0,20)
ClassMethod GetList(ClassN As %String, UserName As %String, OBJDESC As %String, DateFrom As %String, DateTo As %String, Status As %String, Result As %String, AuditUser As %String, AuditDate As %String, start As %String, limit As %String) As %String
{
    w "{""success"":""true"",""data"":[" 
    s:ClassN'="" ClassN=$zcvt(ClassN,"U") 
    s:UserName'="" UserName=$zcvt(UserName,"U")
    s:OBJDESC'="" OBJDESC=$zcvt(OBJDESC,"U")
    s:AuditUser'="" AuditUser=$zcvt(AuditUser,"U")
    s count=0
    if start="" s start=0
    if limit="" s limit=20
    s start=start+1
    
    s:DateFrom'="" DateFrom=$zdh(DateFrom,1)
    s:DateTo'="" DateTo= $zdh(DateTo,1)

    if (DateTo="")  s DateTo=+$h  
    if (DateFrom="") s DateFrom=+$H-7 // 默认显示一周数据 
    s ^TMPData=DateFrom_"-"_DateTo
    
    s CurrentDate=DateTo+1
    for
    {
        s CurrentDate =$o(^User.BDPDataChangeLogI("UpdateDateIndex",CurrentDate),-1)
        q:(CurrentDate<DateFrom)||(CurrentDate="")
   
        s ID=""
        for
        {
            s ID=$o(^User.BDPDataChangeLogI("UpdateDateIndex",CurrentDate,ID),-1)
            q:(ID=0)||(ID="") 
            s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)  //SS_User
            //continue:'(TableName[("SS_User"))&'(TableName[("SS_Group"))&'(TableName[("epr.GroupSettings"))&'(TableName[("BDP_Preferences"))    //除用户和安全相关的日志，跳出本次循环
            s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.SSUser
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
        
            ;审计
            s BDPDataAuditRowId=$O(^BDPDATAAUDIT("0","LOG",ID,0))
            if (BDPDataAuditRowId'="")
            {   
                s BDPDataAuditDataLogDR=ID
                s BDPDataAuditStatus=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",2)
                s BDPDataAuditDate=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",3)
                s BDPDataAuditTime=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",4)   
                s:BDPDataAuditDate'="" BDPDataAuditDate=$zd(BDPDataAuditDate,1)
                s:BDPDataAuditTime'="" BDPDataAuditTime=$zt(BDPDataAuditTime,1)
                
                
                s BDPDataAuditUser=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",5)
                if BDPDataAuditUser'="" s BDPDataAuditUser=$p($g(^SSU("SSUSR",BDPDataAuditUser)),"^",2)
                s BDPDataAuditResult=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",6)
                s BDPDataAuditNote=$p($g(^BDPDATAAUDIT(BDPDataAuditRowId)),"^",7)
            }
            else
            {   
                s BDPDataAuditDataLogDR=""
                s BDPDataAuditStatus="N" ///未审计
                s BDPDataAuditDate=""
                s BDPDataAuditTime=""
                s BDPDataAuditUser=""
                s BDPDataAuditResult=""
                s BDPDataAuditNote=""
            }
            i (($zcvt(ClassName,"U")[ClassN)||($ZCVT(ClassNameDesc,"U")[ClassN))&($ZCVT(UpdateUserName,"U")[UserName)&((OBJDESC="")||(OBJDESC'=""&($ZCVT(ObjectDesc,"U")[OBJDESC)))&((Status="")||(BDPDataAuditStatus=Status))&((Result="")||(BDPDataAuditResult=Result))&($ZCVT(BDPDataAuditUser,"U")[AuditUser)&((BDPDataAuditDate=AuditDate)||(AuditDate=""))
            { 
                k ^TMP("BDPDataAuit","Count",$j)
                s count=count+1
                if (count<start) continue
                if (count<(start+limit))
                { 
               
                s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
                s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
                s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10) 
                s:NewValue'="" NewValue=$tr(NewValue,"""","''")
                s OldValue= $LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
                s:OldValue'="" OldValue=$tr(OldValue,"""","''")
                s StrJson="",str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr=""
     
                if (OperateType="U")
                {
                    if TableName["BDP_Preferences"
                    {
                         if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
                         if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
                         if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
                         if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
                         s OldData=OldValue
                         s NewData=NewValue
                         s StrJson=OldData_" -> "_NewData 
                    }
                    else
                    {
                
                        s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
                        s NewValue1=$e(NewValue,2,$length(NewValue)-1)
                        s oldlen=$l(OldValue1,",")
                        s newlen=$l(NewValue1,",")
                        s result=""
                        try{
                    
                            for i=1:1:oldlen
                            {
                                s PropertyChinese=""
                                s oldstr=$p(OldValue1,",",i)
                                s newstr=$p(NewValue1,",",i)
                                s Property=$p(oldstr,":",1)
                                s PropertyValueOld=$p(oldstr,":",2)
                                s PropertyValueNew=$p(newstr,":",2)
                                s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
                                s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
                                s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
                                if (PropertyValueOld'=PropertyValueNew)
                                {
                                    if (str="") s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
                                    else  s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                                }
                            }
                               s StrJson=str  
                
                            }catch myvar{
                                s result = myvar.Name
                                ;myvar.Name 会显示报错信息
                
                                if (result="<SYNTAX>")
                                {
                                    if OldData'=NewData   s StrJson=OldData_" -> "_NewData
                                    else  s StrJson=""
                                }   
                            }
                        }
                    }
                    else  //if ((OperateType="D")||(OperateType="A"))
                    {
                     if TableName["BDP_Preferences" 
                     { 
                         if (OperateType="D")
                         {
                         
                            if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
                            if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
                            if OldValue["1#"  s $p(OldValue,":",5)="""1#"",DataSplitString"
                            if OldValue["0#"  s $p(OldValue,":",5)="""0#"",DataSplitString"
                         }
                         if (OperateType="A")
                         {
                         
                            if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
                            if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
                            if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
                            if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
                         }
                         s OldData=OldValue
                         s NewData=NewValue
                         s StrJson=NewData 
                }
                else
                {
                    s Property=""
                    s NewValue1=$e(NewValue,2,$length(NewValue)-1)
                    s StrJson=NewValue1 
                
                    s result=""
                    try{
                    
                    for i=1:1:$l(NewValue1,",")
                    {
                        s PropertyChinese=""
                        s newstr=$p(NewValue1,",",i)
                        s Property=$p(newstr,":",1)
                        ; s PropertyValueNew=$p(newstr,":",2)
                        s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
                        s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
                        if (str="")  s str=Property_":"_PropertyValueNew 
                        else  s str=str_","_Property_":"_PropertyValueNew 
                    }
                    s StrJson=str
                
                    }catch myvar{
                        s result = myvar.Name
                        ;myvar.Name 会显示报错信息
        
                        if (result="<SYNTAX>")
                        {
                            s StrJson=NewValue
                        }       
                    }
                }
            }
                s lengthstr=$l(StrJson)
                if lengthstr>300 s StrJson=$e(StrJson,1,300)
                s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
                s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
                s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
                if ((count#limit)=1)
                {
                   w "{""ID"":"""_ID_""",""IpAddress"":"""_IpAddress_""",""TableName"":"""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_""",""ObjectReference"":"""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_""",""OperateType"":"""_OperateType_""",""BDPDataAuditDataLogDR"":"""_BDPDataAuditDataLogDR_""",""BDPDataAuditRowId"":"""_BDPDataAuditRowId_""",""BDPDataAuditStatus"":"""_BDPDataAuditStatus_""",""BDPDataAuditDate"":"""_BDPDataAuditDate_""",""BDPDataAuditTime"":"""_BDPDataAuditTime_""",""BDPDataAuditUser"":"""_BDPDataAuditUser_""",""BDPDataAuditResult"":"""_BDPDataAuditResult_""",""BDPDataAuditNote"":"""_BDPDataAuditNote_""",""OldValue"":"""_OldValue_""",""NewValue"":"""_NewValue_""",""StrJson"":"""_StrJson_"""}"
                    
                }
                else
                {
                   w ",{""ID"":"""_ID_""",""IpAddress"":"""_IpAddress_""",""TableName"":"""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_""",""ObjectReference"":"""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_""",""OperateType"":"""_OperateType_""",""BDPDataAuditDataLogDR"":"""_BDPDataAuditDataLogDR_""",""BDPDataAuditRowId"":"""_BDPDataAuditRowId_""",""BDPDataAuditStatus"":"""_BDPDataAuditStatus_""",""BDPDataAuditDate"":"""_BDPDataAuditDate_""",""BDPDataAuditTime"":"""_BDPDataAuditTime_""",""BDPDataAuditUser"":"""_BDPDataAuditUser_""",""BDPDataAuditResult"":"""_BDPDataAuditResult_""",""BDPDataAuditNote"":"""_BDPDataAuditNote_""",""OldValue"":"""_OldValue_""",""NewValue"":"""_NewValue_""",""StrJson"":"""_StrJson_"""}" 
                }  
            }
            
        }
    }
  }  
     w "],""total"":"_count_"}"
}

}
