Class web.DHCBL.BDP.BDPMenuUseFrency Extends %RegisteredObject
{

/// Function: 数据检索时创建临时索引用于检索数据
/// CreateDate: 2015-12-23
/// Creator:  sunfengchao
/// Debug:    d ##class(web.DHCBL.BDP.BDPMenuUseFrency).CreatUseCountData()
ClassMethod CreatUseCountData() As %String
{
    k ^TMP($j,"DataAnalysis") 
    s myRowID=0,Count=0    
    for 
    {
      s myRowID=$o(^User.BDPDataChangeLogD(myRowID)) ; 遍历日志数据的ID
      q:(myRowID="")   
      s TableName=$LISTGET($G(^User.BDPDataChangeLogD(myRowID)),2) ;取 表名称
      s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(myRowID)),3) ;取 类名称  
      s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(myRowID)),7) ; 更新日期  
      s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(myRowID)),11) ;类描述
      s ClassName=##class(web.BDP.util.String).EvalJSON(ClassName)  
      s ClassNameDesc=##class(web.BDP.util.String).EvalJSON(ClassNameDesc)
      s TableName=##class(web.BDP.util.String).EvalJSON(TableName)    
      if (ClassName["^") 
      { 
        s ClassName=$p(ClassName,"(",1) ; 处理新病案首页这样的已Global做为表名进行存储日志的情况
      }  
      if (ClassName'="")&(ClassNameDesc'="")&(myRowID'="")
      { 
        s ^TMP($j,"DataAnalysis",ClassName,ClassNameDesc,myRowID)=""   ;生成临时Global用于页面分析  
      }
  }
}

/// FUnction: 没有参数时进行查询数据明细
/// CreateDate: 2015-12-23
/// Creator:  sunfengchao
/// d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataListByNoParams()
ClassMethod GetDataListByNoParams() As %String
{
     k ^TMP($j,"DataAnalysis","Count")
     k ^TMP($j,"DataAnalysis","Sort") 
     d ##class(web.DHCBL.BDP.BDPMenuUseFrency).CreatUseCountData() 
     s ClassName=0   
     for 
     {
         s ClassName=$o(^TMP($j,"DataAnalysis",ClassName)) 
         ; 通过临时Global里的类名称 用来统计页面
         q:ClassName=""
         s ClassNameDesc=0
         for
         {
           ; 通过遍历 类名和类名称来确定统计的是同一个页面 (排除特殊情况： 资源定义和分配资源到科室 的情况)
           s ClassNameDesc=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc))
           q:(ClassNameDesc="")
           s PageCount=0 ; 用来存放 页面使用次数
           s MyRowID=0
           for 
           {
             s MyRowID=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc,MyRowID))
             q:(MyRowID="")
             s PageCount=PageCount+1
           }
           if ((ClassName'="")&(ClassNameDesc'=""))
           {
            ; 生成 临时Global存放 页面的使用次数
            s ^TMP($j,"DataAnalysis","Sort",PageCount,ClassName,ClassNameDesc)="" 
            s ^TMP($j,"DataAnalysis","Count",ClassName,ClassNameDesc)=ClassName_"^"_ClassNameDesc_"^"_PageCount   
           }
       }   
    }
}

/// Function:   通过描述进行查询数据
/// CreateDate: 2015-12-23
/// Creator:    sunfengchao
/// Debug:      d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataByDesc()
ClassMethod GetDataByDesc() As %String
{
   k ^TMP($j,"DataAnalysis","DescSort")
   k ^TMP($j,"DataAnalysis","ClassNameDesc")
   d ##class(web.DHCBL.BDP.BDPMenuUseFrency).CreatUseCountData() ; 生成索引
   s ClassName=0 
   for 
   {
       s ClassName=$o(^TMP($j,"DataAnalysis",ClassName)) ; 遍历索引
       q:(ClassName="")        
       s ClassNameDesc=0 
       for
       { 
         ;根据类描述去遍历
         s ClassNameDesc=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc))
         q:(ClassNameDesc="")
         s MyRowID=0
         s PageCount=0 //统计数
         for 
         {
           s MyRowID=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc,MyRowID))
           q:(MyRowID="")
           s PageCount=PageCount+1  ;累计
         }
         if (ClassName'="")&(ClassNameDesc'="")
         {
          s ^TMP($j,"DataAnalysis","DescSort",PageCount,ClassName,ClassNameDesc)="" ; 生成描述索引
          s ^TMP($j,"DataAnalysis","ClassNameDesc",ClassNameDesc,ClassName)= ClassName_"^"_ClassNameDesc_"^"_PageCount   ;生成取数据详情时的Global
         }       
     }   
   }
}

/// Function: 通过日期进行查询数据
/// CreateDate:2015-12-23
/// Creator:  sunfegncaho
/// Debug:    d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataByDate()
ClassMethod GetDataByDate() As %String
{
     k ^TMP($j,"DataAnalysis","UpdateDate")
     ; 生成页面使用的临时Global
     d ##class(web.DHCBL.BDP.BDPMenuUseFrency).CreatUseCountData() 
     s ClassName=0   
     for 
     {
         s ClassName=$o(^TMP($j,"DataAnalysis",ClassName))
         q:(ClassName="")        
         s ClassNameDesc=0
         for
         {
           s ClassNameDesc=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc))
           q:(ClassNameDesc="")
           s MyRowID=0
           for 
           {
             s MyRowID=$o(^TMP($j,"DataAnalysis",ClassName,ClassNameDesc,MyRowID))
             q:(MyRowID="")
             s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(MyRowID)),7)
             if (ClassName'="")&(ClassNameDesc'="")&(MyRowID'="")
             {
                 ; 生成日期的临时Global
               s ^TMP($j,"DataAnalysis","UpdateDate",ClassName,ClassNameDesc,MyRowID)=ClassName_"^"_ClassNameDesc_"^"_UpdateDate   
             }
           }   
       }   
     }
}

/// Function:   获取使用频率，用于Echarts页面数据分析
/// Creator:    sunfengchao
/// CreateDate:   2015/9/22
/// Tables:     BDP_BDPDataChangeLog
/// Debugs:     w ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetFrecency("2018-02-01T00:00:00","2018-02-09T00:00:00","医生专长",0,20,"")
ClassMethod GetFrecency(datefrom As %String, dateto As %String, classDesc As %String, start As %String, limit As %String, dir As %String) As %String
{
  s EchartStr="" 
  if ((datefrom'="")||(dateto'=""))
  { 
     if (datefrom["T") s datefrom=$p(datefrom,"T",1)
     if (dateto["T") s dateto=$p(dateto,"T",1)
     s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
     s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
     s:dateto="" dateto=+$h
    /// 日期和类描述都不为空
    if (classDesc'="")
    {     
      k ^TMP($j,"DataAnalysis","DateDscSort")
      ; 按照日期进行统计
      d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataByDate()
      s EchartStr=""
      s ClassN=0,Count2=0,Count3=0
      
      for 
      {
         s ClassN=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN))
         q:(ClassN="")
         s classDes=0
         for
         {
           s classDes=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes))
           q:classDes="" 
           s Count=0 
           s myRowID=0
           for
           {
              s myRowID=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes,myRowID))
              q:myRowID=""
              s UpdateDate=$p($g(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes,myRowID)),"^",3)
              if ((UpdateDate>=datefrom)&(UpdateDate<=dateto)&(classDes[classDesc))  
              {
                s Count=Count+1
              }
              else 
              {
                continue
              }
            }
            if (Count>0) s ^TMP($j,"DataAnalysis","DateDscSort",Count,ClassN,classDes)=""   
          }
       }  
 
     s ClassN=0,Count4=0,EchartStr=""  
     s SortNum=""
     for 
     { 
       if (dir="DESC")
       {
        s SortNum=$o(^TMP($j,"DataAnalysis","DateDscSort",SortNum),-1)
        q:SortNum=""
       }
       else
       {
        s SortNum=$o(^TMP($j,"DataAnalysis","DateDscSort",SortNum))
        q:SortNum=""
       }
       s Count=0
       s ClassNa=0
       for
       { 
         s ClassNa=$o(^TMP($j,"DataAnalysis","DateDscSort",SortNum,ClassNa))
         q:ClassNa=""
         s Count4=Count4+1
         s ClassDsc=0
         for
         {
           s ClassDsc=$o(^TMP($j,"DataAnalysis","DateDscSort",SortNum,ClassNa,ClassDsc))
           q:ClassDsc=""
           s Count2=Count2+1
           if (Count2<=start) continue
           if (Count2<=(start+limit))
           {
             
                if (EchartStr="") 
                {  
                  s EchartStr= "{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                }
                else
                {  
                 s EchartStr=EchartStr_",{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                }
           }    
        }
     }
  }
   s Count2=Count4
}
    else
    {  
      //// 日期不为空,classDesc=""
      s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
      s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
      s:dateto="" dateto=$p($h,",",1)
      k ^TMP($j,"DataAnalysis","DateSort")
      d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataByDate()
      s EchartStr=""
      s ClassN=0,Count2=0 
      for 
      {
         s ClassN=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN))
         q:(ClassN="")
         s classDes=0
         for
         {
           s classDes=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes))
           q:classDes=""
           s Count=0 
           s myRowID=0
           for
           {
              s myRowID=$o(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes,myRowID))
              q:myRowID=""
              s UpdateDate=$p($g(^TMP($j,"DataAnalysis","UpdateDate",ClassN,classDes,myRowID)),"^",3)
              if ((UpdateDate>=datefrom)&(UpdateDate<=dateto)&(classDes[classDesc))  
              {
                s Count=Count+1
              }
              else 
              {
                continue
              }
            }
            if (Count>0) s ^TMP($j,"DataAnalysis","DateSort",Count,ClassN,classDes)=""   
           }
        }  
     s ClassN=0,Count4=0,EchartStr=""  
     s SortNum=""
     for 
     {
       if (dir="DESC")
       {
        s SortNum=$o(^TMP($j,"DataAnalysis","DateSort",SortNum),-1)
        q:SortNum=""
       }
       else
       {
        s SortNum=$o(^TMP($j,"DataAnalysis","DateSort",SortNum))
        q:SortNum=""
       }
       s Count=0
       s ClassNa=0
       for
       { 
         s ClassNa=$o(^TMP($j,"DataAnalysis","DateSort",SortNum,ClassNa))
         q:ClassNa=""
         s Count4=Count4+1
         s ClassDsc=0
         for
         {
           s ClassDsc=$o(^TMP($j,"DataAnalysis","DateSort",SortNum,ClassNa,ClassDsc))
           q:ClassDsc=""
           s Count2=Count2+1
           if (Count2<=start) continue
           if (Count2<=(start+limit))
           {
                if (EchartStr="") 
                {  
                  s EchartStr= "{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                }
                else
                {  
                 s EchartStr=EchartStr_",{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                }
           }  
        }
     }
   }
  }
   s Count2=Count4 
}    
 else
 {   
    /// classDesc不为空 日期为空
    if (classDesc'="")
    {
        d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataByDesc() 
        s ClassN=0,Count2=0,EchartStr=""  
        s SortNum=""
        for 
        {
             if (dir="DESC")
             {
                  s SortNum=$o(^TMP($j,"DataAnalysis","DescSort",SortNum),-1)
                  q:SortNum=""
             }
             else{ 
                  s SortNum=$o(^TMP($j,"DataAnalysis","DescSort",SortNum))
                  q:SortNum=""  
             }
             s Count=0
             s ClassNa=0
             for
             { 
                 s ClassNa=$o(^TMP($j,"DataAnalysis","DescSort",SortNum,ClassNa))
                 q:ClassNa=""
                 
                 s Count=Count+1
                 s ClassDsc=0
                 for
                 {
                   s ClassDsc=$o(^TMP($j,"DataAnalysis","DescSort",SortNum,ClassNa,ClassDsc))
                   q:ClassDsc=""
                   
                   if (ClassDsc[classDesc)
                   {
                       s Count2=Count2+1
                       if (Count2<=start) continue
                       if (Count2<=(start+limit))
                       { 
                            if (EchartStr="") 
                            {  
                              s EchartStr= "{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                            }
                            else
                            {  
                             s EchartStr=EchartStr_",{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
                            }   
                        }  
                   }
                } 
             }     
        }
   }
   else
   {  
     /// 日期,类描述都为空 
     d ##class(web.DHCBL.BDP.BDPMenuUseFrency).GetDataListByNoParams()
     s ClassN=0,Count2=0,EchartStr=""  
     s SortNum=""
     for 
     {
       if (dir="DESC"){
        s SortNum=$o(^TMP($j,"DataAnalysis","Sort",SortNum),-1)
        q:SortNum=""
       }
       else{
         s SortNum=$o(^TMP($j,"DataAnalysis","Sort",SortNum))
         q:SortNum=""
       }
       
       s Count=0
       s ClassNa=0
       for
       { 
         s ClassNa=$o(^TMP($j,"DataAnalysis","Sort",SortNum,ClassNa))
         q:ClassNa=""
         s Count=Count+1
         s ClassDsc=0
         for
         {
           s ClassDsc=$o(^TMP($j,"DataAnalysis","Sort",SortNum,ClassNa,ClassDsc))
           q:ClassDsc=""
           s Count2=Count2+1
           if (Count2<=start) continue
           if (Count2<=(start+limit))
           { 
            if (EchartStr="") 
            {  
              s EchartStr= "{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
            }
            else
            {  
             s EchartStr=EchartStr_",{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}" 
            }    
         }
            
       }
     }
    } 
   }
  }
    if (Count2=0)
    {
          s SortNum=0
          s ClassNa="NoPageUse"
          s ClassDsc="没有符合查询条件的页面使用记录"
          s EchartStr= "{""Count"":"""_SortNum_""",""success"":""true"",""ClassName"":"""_ClassNa_""",""ClassNameDesc"":"""_ClassDsc_"""}"  
     } 
   s EchartStr="{""total"":"""_Count2_""",""data"":["_EchartStr_"]}"
   q EchartStr
}

/// Function: 统计各页面的使用频率
/// Creator:  sunfengchao
/// Createdate： 2015-9-7
/// debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMenuUseFrency","GetList","2015-09-25T00:00:00","2015-12-25T00:00:00","账单子组")
Query GetList(datefrom As %String, dateto As %String, UserClass As %String = "", UserClassNameDesc As %String = "") As %Query(ROWSPEC = "ID:%String,IpAddress:%String,TableName:%String,ClassName:%String,ClassNameDesc,ObjectReference:%String,ObjectDesc,UpdateUserDR:%String,UpdateUserName:%String,UpdateDate:%String,UpdateTime:%String,OperateType:%String,OldValue:%String,NewValue:%String,StrJson:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, datefrom As %String, dateto As %String, UserClass As %String = "", UserClassNameDesc As %String = "") As %Status
{
      s repid=$I(^CacheTemp)
      s ind=1
     
      s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
      s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
      s:dateto="" dateto=$p($h,",",1)
      s:UserClass'="" UserClass=" "_$zcvt(UserClass,"U")
      s:UserClassNameDesc'="" UserClassNameDesc=" "_$zcvt(UserClassNameDesc,"U")
      s UserClass2="",UserClass3=""
      if (UserClass["^") 
      { 
       s UserClass3=$p(UserClass,"(",1)
       s UserClass2=$p(UserClass,"(",2)
       if (UserClass["^DHCJFCONFIG") s UserClass=" ^DHCJFCONFIG(""ZYJFCONFIG"")"
       if (UserClass["^DHCTARC") s UserClass=" ^DHCTARC(""TMCNEW"")"
      }  
      s ID=0
      for
      {
      s str=""
      s ID=$o(^User.BDPDataChangeLogI("ClassNameIndex",UserClass,ID)) q:ID=""  
      s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
      s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
      s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
      s ClassName=##class(web.BDP.util.String).EvalJSON(ClassName)  
      s ClassNameDesc=##class(web.BDP.util.String).EvalJSON(ClassNameDesc) 
      if ((datefrom="")||(UpdateDate>=datefrom))&((dateto="")||(UpdateDate<=dateto))&((UserClass="")||(" "_$zcvt(ClassName,"U")=UserClass))&((UserClassNameDesc="")||(" "_$zcvt(ClassNameDesc,"U")=UserClassNameDesc))
      {  
        s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
        s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述   
        s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
        s TableName=##class(web.BDP.util.String).EvalJSON(TableName) 
        s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
        s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
        s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
        s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
        s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
        s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
        s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式 
        s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
        s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
        s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
        s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
        s NewValue=##class(web.BDP.util.String).EvalJSON(NewValue)
        s OldValue=##class(web.BDP.util.String).EvalJSON(OldValue)
        if ((OperateType="U")&(OldValue'="")&(NewValue'="")&(OldValue'="{}")&(NewValue'="{}"))
        {
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
             s PropertyValueOld=$p(oldstr,":",2)
             s PropertyValueNew=$p(newstr,":",2)
             s Property=$p(oldstr,":",1)
     
             s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
             s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
             s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
             if (PropertyValueOld'=PropertyValueNew)
             { 
                if (str="")
                {  
                  s str=Property_":"_PropertyValueOld_"->"_PropertyValueNew
                  s str2 =Property_":"_PropertyValueOld_"->"_PropertyValueNew
                }
                else
                {
                  s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                  s str2=str2_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                }
              }
          }
        s StrJson=str
        s StrJson=##class(web.BDP.util.String).EvalJSON(StrJson)
        if (TableName["BDP_Preferences")
        {
          if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
          if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
          if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
          if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
          s OldData=OldValue
          s NewData=NewValue
          s StrJson=OldData_" -> "_NewData 
        }
     }
     elseif ((OperateType="D")||(OperateType="A"))
      {
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)
         s StrJson=NewValue1 
         for i=1:1:$l(NewValue1,",") 
         {
           s PropertyValueNew=""
           s newstr=$p(NewValue1,",",i)
           s Property=$p(newstr,":",1)
           s PropertyValueNew=$p(newstr,":",2)
           s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew)
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
           if (str="") 
           {
             s str=Property_":"_PropertyValueNew 
           }
           else  
           {
             s str=str_","_Property_":"_PropertyValueNew 
           }
        }
        s StrJson=str
        if (TableName["BDP_Preferences")
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
         s OldData=##class(web.BDP.util.String).EvalJSON(OldData)
         s NewData=##class(web.BDP.util.String).EvalJSON(NewData)
         s StrJson=##class(web.BDP.util.String).EvalJSON(StrJson)
        }
      }
        d OutputRow   
      }  
   }     
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,IpAddress,TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType,OldValue,NewValue,StrJson)
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

/// CreateDate: 2015-11-20
/// Function:　生成一个时间轴 
/// Creator:   sunfengchao
/// d ##class(web.DHCBL.BDP.BDPMenuUseFrency).ProduceTimeLine("User.CTMedicalStaffType","11","[南]针灸二病房N15(原针10) 22222","")
ClassMethod ProduceTimeLine2(ClassN As %String, OBJDESC As %String, ObjectDESC As %String, ClassDesc As %String = "")
{
  s count=1,oldlen=0,newlen=0,StrJson="" ,resultStr="",showResultStr=""
  s TableNewValue="",flag=0
  if (ClassDesc="新病案首页大类") s ClassN="^DHCTarC(""TMCNew"")" 
  if (ClassDesc="新病案首页子类") s ClassN="^DHCTARC(""MCNew"")" 
  s:ClassN'="" ClassN=" "_$zcvt(ClassN,"U")  
  s ID=""
  for
  {
     s ID=$o(^User.BDPDataChangeLogI("ClassNameIndex",ClassN,ID),-1)   
     q:ID=""  
    
     s str=""
     s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
     s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
     s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
     s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
     s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
     s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
      
     if ((OBJDESC="")||((OBJDESC'="")&((ObjectDesc=OBJDESC)||(ObjectReference=OBJDESC)))&((NewValue'="")||((OperateType="U")&(OldValue'="")&(NewValue'=""))))
     { 
      s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
      s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述  
      s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
      s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
      s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
      s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
      s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
      s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
      s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式  
      s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13) 
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
       s PropertyValueNew=$tr(PropertyValueNew,"""","")  b ;1
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
       s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property) //属性 转为中文含义
       
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
   
       if (TableName["BDP_Preferences")
       {
         if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
         if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
         if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
         if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
         s StrJson=OldValue_"->"_NewValue 
       }
     }
     else
     {
      if ((OperateType="D")||(OperateType="A"))
      {  
        if (TableName["BDP_Preferences")
        {
          if (OperateType="D")||(OperateType="A")
          {
            if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
            if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
          }
         s TableNewValue=NewValue   
        }  
      }
    }
 
   if ((OBJDESC="")||(ObjectReference=OBJDESC))&((ObjectDESC="")||($zcvt(ObjectDESC,"U")[$zcvt(ObjectDesc,"U")))
   {
       w "<div class=""timeline""  style=""margin-top:0px ;width:1070px;height:8000px ; height:auto;"">" ,!
       w "<div style=""font: 0px/0px sans-serif;clear: both;display: block""> </div>",!
       s showdate=""
       ;s ^Temp("timedate")=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
       s showdate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($LISTGET($G(^User.BDPDataChangeLogD(ID)),7)) 
       ;$p(UpdateDate,"/",3)_"-"_$p(UpdateDate,"/",1)_"-"_$p(UpdateDate,"/",2)
       s flag=1
       w "<div class=""timeline-date"">",!
       w "<ul>",!
       w "<h2 class=""second"" style=""position: relative;"">",!
       w "<span>"_showdate_"</span>",! 
       w " </h2>",!
       w " <li>",!
       w "<h3><span>"_showdate_"<br/>"_UpdateTime_" </span></h3>",!
       w " <dl class=""left"">",!
       w " <span>"
       w "<table  border=""1"" width=""945px"">"
       w "<tr>"  
       w "<th>操作类型</th>"
       w "<th>操作人</th>"
       w "<th>用户IP</th>"
       w "<th>操作日期</th>"
       w "<th>表名称</th>"
       w "<th>类描述</th>"
       w "<th>对象ID</th>"
       w "<th>对象描述</th>"
       w "<th>数据明细</th>"
       w "</tr>"
       w "<tr>"
       w "<tr>"
       w "<td>"
      
       if (OperateType="A")   w "<img  src= ""../scripts/bdp/Framework/icons/add.gif"">"_"添加" 
       if (OperateType="D")  w "<img  src= ""../scripts/bdp/Framework/icons/delete.gif"">"_"删除"
       if (OperateType="U") w "<img src= ""../scripts/bdp/Framework/icons/update.gif"">"_"修改"  
   
        w "</td>"
        w "<td>"_UpdateUserDR_"</td>"
        w "<td>"_IpAddress_"</td>"
        w "<td>"_showdate_"</td>"
        w "<td>"_TableName_"</td>"
        w "<td>"_ClassNameDesc_"</td>"
        w "<td>"_ObjectReference_"</td>"
        w "<td>"_ObjectDesc_"</td>"
        if (OperateType="U")  
        {
           s:StrJson="" StrJson="无数据改动"
           w "<td style=""word-break:break-all"">"_StrJson_"</td>"
        }
        if (OperateType="D")  
        { 
         
         s TableNewValue=""  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)  
     
         for i=1:1:$l(NewValue1,",") 
         {
           s PropertyValueNew=""
           s newstr=$p(NewValue1,",",i)
           s Property=$p(newstr,":",1)
           s Property=$tr(Property,"""","") 
           s PropertyValueNew=$p(newstr,":",2)
           s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew)
           s PropertyValueNew=$tr(PropertyValueNew,"""","") 
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
           
           if (TableNewValue="") 
           {
             s TableNewValue=Property_":"_PropertyValueNew 
           }
           else  
           {
             if ($l(TableNewValue)<=32000)
             {
                s TableNewValue=TableNewValue_","_Property_":"_PropertyValueNew 
             }
             else{
                  s TableNewValue=TableNewValue
             }
           }
         }
          s:TableNewValue="" TableNewValue=NewValue1
          //s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue _"</td>"
        }
        if (OperateType="A")  
        { 
         s TableNewValue=""  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)  
     
         for i=1:1:$l(NewValue1,",") 
         {
           s PropertyValueNew=""
           s newstr=$p(NewValue1,",",i)
           s Property=$p(newstr,":",1)
           s PropertyValueNew=$p(newstr,":",2)
           s Property=$tr(Property,"""","") 
           s PropertyValueNew=$tr(PropertyValueNew,"""","") 
           s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew)
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
           
           if (TableNewValue="") 
           {
             s TableNewValue=Property_":"_PropertyValueNew 
           }
           else  
           {
             if ($l(TableNewValue)<=32000)
             {
                s TableNewValue=TableNewValue_","_Property_":"_PropertyValueNew 
             }
             else
             {
                  s TableNewValue=TableNewValue
             }
           } 
          }
          s:TableNewValue="" TableNewValue=NewValue1
          //s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue _"</td>"
        }  
        w "</tr>"
        w "</table>"
        w "</span>",!
        w "</dl>",! 
        w "</li>",!
        w "</ul>",!
        w "</div>",!
     }    
  } 
  if (flag=0)
  {  
     w "<ul>",!
     w "<img src=""../scripts/bdp/Framework/imgs/lifeerror.png"" align=""center"" width=""700"" height=""460"" /> "
     w " <li>",!  
   } 
  w "</div>",!
  w "</div>",!
  w "</div>",!
  d
}

/// CreateDate: 2015-11-20
/// Function:　生成一个时间轴 
/// Creator:   sunfengchao
/// d ##class(web.DHCBL.BDP.BDPMenuUseFrency).ProduceTimeLine("User.PACOutcomeOfPregnancy","2","","")
ClassMethod ProduceTimeLine(ClassN As %String, OBJDESC As %String, ObjectDESC As %String, ClassDesc As %String = "")
{
  s count=1,oldlen=0,newlen=0,StrJson="" ,resultStr="",showResultStr=""
  s TableNewValue="",flag=0
  if (ClassDesc="新病案首页大类") s ClassN="^DHCTarC(""TMCNew"")" 
  if (ClassDesc="新病案首页子类") s ClassN="^DHCTARC(""MCNew"")" 
  s ClassNLinkMenu= ##class(web.DHCBL.BDP.BDPDataChangeLogForOther).GetLinkTable(ClassN)
  if (ClassNLinkMenu="") s ClassNLinkMenu=ClassN  // 处理 手术扩展表 特殊情况 
  //s ClassN="User.SSUser^User.SSUserOtherLogonLoc^User.RBResource^User.CTCareProv"
  
   k ^TMPLOGArr
   s Len= $length(ClassNLinkMenu,"^")  
    for i=1:1:Len
    {  
         s UserClassI = $p(ClassNLinkMenu,"^",i)
         s:UserClassI'="" UserClassI=$zcvt(UserClassI,"U")
         s ID=""
         for
         {
             s ID=$o(^User.BDPDataChangeLogI("ClassNameIndex"," "_UserClassI,ID),-1)  
             q:ID=""   
             s str=""
             s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
             s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
             s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
             s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
             s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
             s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
             s RelevantKey=$LISTGET($G(^User.BDPDataChangeLogD(ID)),15) 
           
             ;if RelevantKey'=""  w ObjectReference_"^ "_RelevantKey_"^ "_OBJDESC  
             if ((ObjectReference=OBJDESC)||(RelevantKey=OBJDESC))&((NewValue'="")||((OperateType="U")&(OldValue'="")&(NewValue'="")))    // (ObjectDesc=OBJDESC)|| 
             {  
                s ^TMPLOGArr(ID)=""
                if (RelevantKey'="")
                {  
                 if ($d(^BDPChangeLogLogI("BDPLog",RelevantKey)))
                 {
                    s LogID=0
                    for
                    {
                        s LogID=$O(^BDPChangeLogLogI("BDPLog",RelevantKey,LogID))
                        q:LogID=""
                        s ^TMPLOGArr(LogID)=""
                    }
                 }
              } 
            } 
         }
    }
     s ID=""
     s LogRID=""
     for
     {
         s LogRID=$O(^TMPLOGArr(LogRID),-1) q:LogRID=""
         s ID=LogRID
  
         s str=""
         s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
         s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
         s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
         s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
         s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
         s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
          
         if ((NewValue'="")||((OperateType="U")&(OldValue'="")&(NewValue'=""))) //((OBJDESC="")||((OBJDESC'="")&((ObjectDesc=OBJDESC)||(ObjectReference=OBJDESC)||(RelevantKey=ObjectReference)))&((NewValue'="")||((OperateType="U")&(OldValue'="")&(NewValue'=""))))
         { 
          s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
          s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述  
          s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
          s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
          s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
          s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
          s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
          s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
          s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式  
          s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13) 
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
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property) //属性 转为中文含义
           
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
       
           if (TableName["BDP_Preferences")
           {
             if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
             if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
             if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
             if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
             s StrJson=OldValue_"->"_NewValue 
           }
         }
         else
         {
          if ((OperateType="D")||(OperateType="A"))
          {  
            if (TableName["BDP_Preferences")
            {
              if (OperateType="D")||(OperateType="A")
              {
                if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
                if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
              }
             s TableNewValue=NewValue   
            }  
          }
        }
     
        
       w "<div class=""timeline""  style=""margin-top:0px ;width:1070px;height:8000px ; height:auto;"">" ,!
       w "<div style=""font: 0px/0px sans-serif;clear: both;display: block""> </div>",!
       s showdate=""
       ;s ^Temp("timedate")=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
       s showdate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($LISTGET($G(^User.BDPDataChangeLogD(ID)),7)) 
       ;$p(UpdateDate,"/",3)_"-"_$p(UpdateDate,"/",1)_"-"_$p(UpdateDate,"/",2)
       s flag=1
       w "<div class=""timeline-date"">",!
       w "<ul>",!
       w "<h2 class=""second"" style=""position: relative;"">",!
       w "<span>"_showdate_"</span>",! 
       w " </h2>",!
       w " <li>",!
       w "<h3><span>"_showdate_"<br/>"_UpdateTime_" </span></h3>",!
       w " <dl class=""left"">",!
       w " <span>"
       w "<table  border=""1"" width=""945px"">"
       w "<tr>"  
       w "<th>操作类型</th>"
       w "<th>操作人</th>"
       w "<th>用户IP</th>"
       w "<th>操作日期</th>"
       w "<th>表名称</th>"
       w "<th>类描述</th>"
       w "<th>对象ID</th>"
       w "<th>对象描述</th>"
       w "<th>数据明细</th>"
       w "</tr>"
       w "<tr>"
       w "<tr>"
       w "<td>"
      
       if (OperateType="A")   w "<img  src= ""../scripts/bdp/Framework/icons/add.gif"">"_"添加" 
       if (OperateType="D")  w "<img  src= ""../scripts/bdp/Framework/icons/delete.gif"">"_"删除"
       if (OperateType="U") w "<img src= ""../scripts/bdp/Framework/icons/update.gif"">"_"修改"  
   
        w "</td>"
        w "<td>"_UpdateUserDR_"</td>"
        w "<td>"_IpAddress_"</td>"
        w "<td>"_showdate_"</td>"
        w "<td>"_TableName_"</td>"
        w "<td>"_ClassNameDesc_"</td>"
        w "<td>"_ObjectReference_"</td>"
        w "<td>"_ObjectDesc_"</td>"
        if (OperateType="U")  
        {
           s:StrJson="" StrJson="无数据改动"
           w "<td style=""word-break:break-all"">"_StrJson_"</td>"
        }
        if (OperateType="D")  
        { 
         
         s TableNewValue=""  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)  
     
         for i=1:1:$l(NewValue1,",") 
         {
           s PropertyValueNew=""
           s newstr=$p(NewValue1,",",i)
           s Property=$p(newstr,":",1)
           s Property=$tr(Property,"""","") 
           s PropertyValueNew=$p(newstr,":",2)
           s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew)
           s PropertyValueNew=$tr(PropertyValueNew,"""","") 
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
           
           if (TableNewValue="") 
           {
             s TableNewValue=Property_":"_PropertyValueNew 
           }
           else  
           {
             if ($l(TableNewValue)<=32000)
             {
                s TableNewValue=TableNewValue_","_Property_":"_PropertyValueNew 
             }
             else{
                  s TableNewValue=TableNewValue
             }
           }
         }
          s:TableNewValue="" TableNewValue=NewValue1
          //s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue _"</td>"
        }
        if (OperateType="A")  
        { 
         s TableNewValue=""  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)  
     
         for i=1:1:$l(NewValue1,",") 
         {
           s PropertyValueNew=""
           s newstr=$p(NewValue1,",",i)
           s Property=$p(newstr,":",1)
           s PropertyValueNew=$p(newstr,":",2)
           s Property=$tr(Property,"""","") 
           s PropertyValueNew=$tr(PropertyValueNew,"""","") 
           s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew)
           s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
           
           if (TableNewValue="") 
           {
             s TableNewValue=Property_":"_PropertyValueNew 
           }
           else  
           {
             if ($l(TableNewValue)<=32000)
             {
                s TableNewValue=TableNewValue_","_Property_":"_PropertyValueNew 
             }
             else
             {
                  s TableNewValue=TableNewValue
             }
           } 
          }
          s:TableNewValue="" TableNewValue=NewValue1
          //s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue _"</td>"
        }  
        w "</tr>"
        w "</table>"
        w "</span>",!
        w "</dl>",! 
        w "</li>",!
        w "</ul>",!
        w "</div>",!
        
        
  } 
  if (flag=0)
  {  
     w "<ul>",!
     w "<img src=""../scripts/bdp/Framework/imgs/lifeerror.png"" align=""center"" width=""700"" height=""460"" /> "
     w " <li>",!  
   } 
  w "</div>",!
  w "</div>",!
  w "</div>",!
  d
}

}
