Class web.DHCBL.MKB.MKBDataChangeLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:范文凯   
/// CreatDate:2019-08-28
/// Description：查看日志我们这边传ClassName和ObjectReference 这两个参数过去。弹窗里显示相关的日志列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","DataChangeLog","User.MKBVersion","1")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataChangeLog","DataChangeLog","","")
Query DataChangeLog(classname, obj) As %Query(ROWSPEC = "ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName")
{
}

ClassMethod DataChangeLogExecute(ByRef qHandle As %Binary, classname, obj) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ID = 0
	for
	{   
		s ID =$o(^User.MKBDataChangeLogI("ObjectReferIndex",classname,obj,ID))
		q:ID=""
		s TableName = $lg($g(^User.MKBDataChangeLogD(ID)),2)
		s ClassName = $lg($g(^User.MKBDataChangeLogD(ID)),3)
		s ObjectReference = $lg($g(^User.MKBDataChangeLogD(ID)),4)
		s UpdateHospital = $lg($g(^User.MKBDataChangeLogD(ID)),5)
		s UpdateLoc = $lg($g(^User.MKBDataChangeLogD(ID)),6)
		s UpdateUserName = $lg($g(^User.MKBDataChangeLogD(ID)),7)
		s UpdateDate = $lg($g(^User.MKBDataChangeLogD(ID)),8)
		s UpdateDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
		s UpdateTime = $lg($g(^User.MKBDataChangeLogD(ID)),9)
		s UpdateTime = ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
		s OperateType = $lg($g(^User.MKBDataChangeLogD(ID)),10)
		s NewValue = $lg($g(^User.MKBDataChangeLogD(ID)),11)
		s ClassNameDesc = $lg($g(^User.MKBDataChangeLogD(ID)),12)
		s ObjectDesc = $lg($g(^User.MKBDataChangeLogD(ID)),13)
		s IpAddress = $lg($g(^User.MKBDataChangeLogD(ID)),14)
		s OldValue = $lg($g(^User.MKBDataChangeLogD(ID)),15)
		s RelevantKey = $lg($g(^User.MKBDataChangeLogD(ID)),16)
		d OutputRow
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DataChangeLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DataChangeLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataChangeLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CreateDate: 2019-08-29、2021-10-28
/// Function:　mkbdatachangelog数据生命周期 生成一个时间轴 
/// Creator:   范文凯、徐凯
/// d ##class(web.DHCBL.MKB.MKBEChartsInterface).ProduceTimeLine("User.MKBKLMappingBase","1","阿萨德")
ClassMethod ProduceTimeLine(ClassN As %String, OBJDESC As %String, ObjectDESC As %String, ClassDesc As %String = "")
{
  s count=1,oldlen=0,newlen=0,StrJson="" ,resultStr="",showResultStr=""
  s TableNewValue="",flag=0
  if (ClassDesc="新病案首页大类")
  {
    s ClassN="^DHCTarC(""TMCNew"")"
  }
  if (ClassDesc="新病案首页子类")
  {
    s ClassN="^DHCTARC(""MCNew"")"
  }
  s:ClassN'="" ClassN=" "_$zcvt(ClassN,"U") 

  s ID=""
  for
  {
     s ID=$o(^User.MKBDataChangeLogI("ClassNameIndex",ClassN,ID),-1)   
     q:ID=""  
    
     s str=""
     s TableName=$LISTGET($G(^User.MKBDataChangeLogD(ID)),2)
     s ClassName=$LISTGET($G(^User.MKBDataChangeLogD(ID)),3)
     s ClassNameDesc=$LISTGET($G(^User.MKBDataChangeLogD(ID)),12)   //新增类描述
     s ObjectReference=$LISTGET($G(^User.MKBDataChangeLogD(ID)),4)
     s ObjectDesc=$LISTGET($G(^User.MKBDataChangeLogD(ID)),13)   //新增对象描述
     s UpdateHospital = $LISTGET($G(^User.MKBDataChangeLogD(ID)),5)   //操作医院名称
     s UpdateLoc = $LISTGET($G(^User.MKBDataChangeLogD(ID)),6)        //操作科室名称
     s UpdateUserName=$LISTGET($G(^User.MKBDataChangeLogD(ID)),7)
     s UpdateDate=$LISTGET($G(^User.MKBDataChangeLogD(ID)),8)
     s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
     s UpdateTime=$LISTGET($G(^User.MKBDataChangeLogD(ID)),9)
     s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式 
     s OperateType=$LISTGET($G(^User.MKBDataChangeLogD(ID)),10)
     s IpAddress=$LISTGET($G(^User.MKBDataChangeLogD(ID)),14)
     s NewValue=$LISTGET($G(^User.MKBDataChangeLogD(ID)),11)
     s OldValue=$LISTGET($G(^User.MKBDataChangeLogD(ID)),15)

     
     //s NewValue=##class(web.BDP.util.String).EvalJSON(NewValue)
     //s OldValue=##class(web.BDP.util.String).EvalJSON(OldValue)
     //s TableName=##class(web.BDP.util.String).EvalJSON(TableName)
     //s ClassName=##class(web.BDP.util.String).EvalJSON(ClassName)
     //s ClassNameDesc=##class(web.BDP.util.String).EvalJSON(ClassNameDesc)
     //s ObjectReference=##class(web.BDP.util.String).EvalJSON(ObjectReference)
     //s ObjectDesc=##class(web.BDP.util.String).EvalJSON(ObjectDesc)
     //s UpdateUserName=##class(web.BDP.util.String).EvalJSON(UpdateUserName)
     //s UpdateDate=##class(web.BDP.util.String).EvalJSON(UpdateDate)
     //s UpdateTime=##class(web.BDP.util.String).EvalJSON(UpdateTime)
     //s OperateType=##class(web.BDP.util.String).EvalJSON(OperateType)
     //s IpAddress=##class(web.BDP.util.String).EvalJSON(IpAddress)
     //s UpdateHospital = ##class(web.BDP.util.String).EvalJSON(UpdateHospital)
     
     if ((OBJDESC="")||((OBJDESC'="")&((ObjectDesc=OBJDESC)||(ObjectReference=OBJDESC)))&((NewValue'="")||((OperateType="U")&(OldValue'="")&(NewValue'=""))))
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
       s Property=$p(oldstr,":",1)
       s PropertyValueOld=$p(oldstr,":",2)
       s PropertyValueNew=$p(newstr,":",2)
      
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
       ///去除中文双引号
       //s Property=##class(web.BDP.util.String).EvalJSON(Property)
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
#;       s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)  
         ///用web.BDP.util.String的EvalJson去除中文双引号
       //s StrJson=##class(web.BDP.util.String).EvalJSON(StrJson)
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
       s showdate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($LISTGET($G(^User.MKBDataChangeLogD(ID)),8)) 
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
       w "<th>医院</th>"
       w "<th>科室</th>"
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
        w "<td>"_UpdateHospital_"</td>"
        w "<td>"_UpdateLoc_"</td>"
        w "<td>"_UpdateUserName_"</td>"
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
           s PropertyValueNew=$p(newstr,":",2)
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
             else{
                  s TableNewValue=TableNewValue
             }
           }
         }
          //s:TableNewValue="" TableNewValue=##class(web.BDP.util.String).EvalJSON(NewValue1)
          //s TableNewValue=##class(web.BDP.util.String).EvalJSON(TableNewValue)  
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue_"</td>"
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
          //s:TableNewValue="" TableNewValue=##class(web.BDP.util.String).EvalJSON(NewValue1)
          //s TableNewValue=##class(web.BDP.util.String).EvalJSON(TableNewValue)
          if $l(TableNewValue)>32000 s TableNewValue=$e(TableNewValue,1,32000)
          w "<td style=""word-break:break-all"">"_TableNewValue_"</td>"
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

/// Function:查看数据明细
/// Creator:  范文凯、徐凯
/// CreateDate: 2019-08-29、2021-10-28
/// Debug:  d ##class(web.DHCBL.MKB.MKBEChartsInterface).ProductTable("")
/// 			d ##class(web.DHCBL.MKB.MKBDataChangeLog).ProductTable("1314550")
ClassMethod ProductTable(id) As %String
{
  if (id="")
  {
    q "ID为空,未查询到数据明细!"
  }
  else
  { 
     w "<table  border=""1"" width=""1060px"" height=""400px"">"
     w "<tr>"  
     w "<th width=""10%"">序号</th>"
     w "<th width=""20%"">字段 </th>"
     w "<th width=""20%"">名称</th>"     
     s TableName=$LISTGET($G(^User.MKBDataChangeLogD(id)),2)
     s ClassName=$LISTGET($G(^User.MKBDataChangeLogD(id)),3)
     s OperateType=$LISTGET($G(^User.MKBDataChangeLogD(id)),10)
     s NewValue=$LISTGET($G(^User.MKBDataChangeLogD(id)),11)
     s OldValue=$LISTGET($G(^User.MKBDataChangeLogD(id)),15)

     //s NewValue=##class(web.BDP.util.String).EvalJSON(NewValue) 
     //s OldValue=##class(web.BDP.util.String).EvalJSON(OldValue) 
     //s TableName=##class(web.BDP.util.String).EvalJSON(TableName)
     //s ClassName=##class(web.BDP.util.String).EvalJSON(ClassName)
     s:ClassName="User.ArcItmMast" ClassName="User.ARCItmMast"
     if (ClassName["^") s ClassName= $p(ClassName,"(",1) 
     //if (ClassName["^") s ClassName= $p($p(ClassName,"(",1),"^",2)
     s str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",StrJson="" 
     if (OperateType="U")
     { 
       w "<th width=""25%"">原值</th>"
       w "<th width=""25%"">新值</th>"
       w "</tr>"
       if TableName["BDP_Preferences"
       { 
         if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
         if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
         if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
         if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString" 
       } 
       s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
       s NewValue1=$e(NewValue,2,$length(NewValue)-1)
       s oldlen=$l(OldValue1,""",")	
       s newlen=$l(NewValue1,""",")
  	//b ;1
       for j=1:1:oldlen 
       { 
         s PropertyChinese=""
         s oldstr=$p(OldValue1,""",",j)	
         s newstr=$p(NewValue1,""",",j)  
         s Property=$p(oldstr,":",1)
         //b ;2
         s:Property["""" Property=$tr(Property,"""","")

         if (ClassName="User.ARCItmMast")
         {
          s:Property["_" Property=$tr(Property,"_","")
         }
         s PropertyValueOld="",PropertyValueNew=""
         s PropertyValueOld=$p(oldstr,":",2)
         s PropertyValueNew=$p(newstr,":",2)      
         s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
         s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
         s PropertyValueOld=$tr(PropertyValueOld,"""","")
         s PropertyValueNew=$tr(PropertyValueNew,"""","")
         if (Property["Date") 
         {
            if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")=1)&($l(PropertyValueNew,"/")=1))
            {
              s PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueNew)  
            }
            if ((PropertyValueOld'="")&((PropertyValueOld'["-")||($l(PropertyValueOld,"-")'=3))&((PropertyValueOld'["/")||($l(PropertyValueOld,"/")'=3)))
            { 
              s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueOld)  
            } 
         } 
         ;时间格式的转换
         if (Property["Time")
         {  
           if (PropertyValueNew'="")&($l(PropertyValueNew,":")'=3)
           {
             s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(PropertyValueNew)   //  
           }
         } 
         s:PropertyValueNew'=PropertyValueOld PropertyValueNew="<font color=red>"_PropertyValueNew_"</font>"
         s:PropertyValueNew'=PropertyValueOld PropertyValueOld="<font color=blue>"_PropertyValueOld_"</font>"
         if (PropertyValueNew'=PropertyValueOld)
         {
           w " <tr bgcolor=PowderBlue align=center valign=bottom>"
         }
         else
         {
           w "<tr>"
         }
         w "<td>"_j_"</td>"
         w "<td>"_Property_"</td>"
         w "<td>"_##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)_"</td>"
         w "<td style=""word-break:break-all"">"_PropertyValueOld_"</td>"
         w "<td style=""word-break:break-all"">"_PropertyValueNew_"</td>"
         w "</tr>"
       }  
     }  
     else
     { 
      if ((OperateType="D")||(OperateType="A"))  
      {
        w "<th width=""25%"">数据明细</th>"
        w "</tr>"
        s Property=""
        s NewValue1=$e(NewValue,2,$length(NewValue)-1)
        s StrJson=NewValue1 
        if TableName["BDP_Preferences"
        { 
           if (OperateType="D")
           {
              if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
              if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
           }
           if (OperateType="A")
           {
             if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
             if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
           }
        }
        for k=1:1:$l(NewValue1,",") 
        {
          s newstr=$p(NewValue1,",",k)
          s Property=$p(newstr,":",1)
          s:Property["""" Property=$tr(Property,"""","")
          if (ClassName="User.ARCItmMast")
          {
            s:Property["_" Property=$tr(Property,"_","")
          }
          s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
          s PropertyValueOld=""
          s PropertyValueNew=$tr(PropertyValueNew,"""","")
          ; 日期格式的转换
          if (Property["Date")
          {
            if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")'=3)&($l(PropertyValueNew,"/")'=3))
            {
              s PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueNew)  
            }
          } 
         ;时间格式的转换
         if (Property["Time")
         {  
            if (PropertyValueNew'="")&($l(PropertyValueNew,":")'=3)
            {
              s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(PropertyValueNew)  
            }
         } 
          w "<tr>"
          w "<td>"_k_"</td>"
          w "<td>"_Property_"</td>"
          w "<td>"_##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)_"</td>"
          w "<td style=""word-break:break-all"">"_PropertyValueNew_"</td>"
          w "</tr>"
        }  
       }
      }
       w "</table>"  
    }
}

/// Function：添加码表数据日志
/// Creator:  范文凯
/// CreatDate:2019-08-30
/// Table：   MKB_DataChangeLog
/// Other:    w ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("BDP_DataChangeLog","User.BDPMenu","ICD版本","2140","获取版本测试","U","rows=1","rows=2")
ClassMethod SaveLog(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "") As %String
{
   new (TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue ,%session)
   s result=""
   if (TableName="") 
   {
      s result="表名不能为空!"
   }
   elseif(ClassName="") 
   {
      s result="类名不能为空!"
   }
   elseif(ObjectReference="") 
   {
      s result="对象ID不能为空!"
   }
   elseif(OperateType="") 
   {
      s result="修改类型不能为空!"
   }
   elseif('$d(%session))
   {
      s result="获取不到session!"
   }
   else 
   {   
      Ts
      s obj=##class(User.MKBDataChangeLog).%New()
      s obj.TableName = TableName
      s obj.ClassName = ClassName
      s obj.ClassNameDesc = ClassNameDesc    //类描述
      s obj.ObjectReference = ObjectReference
      if $l(ObjectDesc)>50 s ObjectDesc=$e(ObjectDesc,1,50)  //对象描述
      s obj.ObjectDesc = ObjectDesc  //对象描述
      s obj.IpAddress = $Get(%session.Data("REMOTE_ADDR"))
      s HospitalID=($Get(%session.Data("LOGON.HOSPID")))
      s LocID=($Get(%session.Data("LOGON.CTLOCID")))
      s obj.UpdateHospital=$p($Get(^CT("HOSP",HospitalID)),"^",2)
      s obj.UpdateLoc=$p($Get(^CTLOC(LocID)),"^",2)
      s obj.UpdateUserName = $Get(%session.Data("LOGON.USERNAME"))
      s obj.OperateType = OperateType  
      s:NewValue'="" obj.NewValue = NewValue.JsonS()
      s:OldValue'="" obj.OldValue = OldValue.JsonS()
      s sc=obj.%Save()
      s id=obj.%Id()
      d obj.%Close()
      If $$$ISOK(sc) 
      {
         Tc
         s result=id_"^"_"添加成功!"  
      } 
      else 
      {
         Trollback
         s result="添加失败!"
      } 
    }
   q result
}

/// CreatDate:    2021-10-26
/// Description： 添加码表数据日志,用于项目没有对象的情况,直接存JSON串。
/// Table：       User.MKBDataChangeLog
/// Other:        d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLogForOther("","","","","","U","{OTHLLCTLOCDR:"22",OTHLLHospitalDR:"",OTHLLParRef:"284",OTHLLRowId:"284||1",OTHLLUserGroupDR:"103"}")
ClassMethod SaveLogForOther(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "", UserId As %String = "") As %String
{
 new (TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue,UserId,%session)
 s result=""
 if (TableName="") 
 {
   s result="表名不能为空!"
 }
 elseif(ClassName="") 
 {
   s result="类名不能为空!"
 }
 elseif(ObjectReference="") 
 {
   s result="对象ID不能为空!"
 }
 elseif(OperateType="") 
 {
   s result="修改类型不能为空!"
 } 
 elseif(('$d(%session))&(UserId="")) {
    s result="无法获取session!"  
 }
 else 
 {
   if ('$d(%session))&(UserId'=""){
        s IPAddress=""
        s LoginUserID=UserId
        s LoginUserName=$p($g(^SSU("SSUSR",UserId)),"^",2)   
    }
    elseif ($d(%session))
    {
      s IPAddress=$Get(%session.Data("REMOTE_ADDR")) 
      s LoginUserID=$Get(%session.Data("LOGON.USERID"))
      s LoginUserName=$Get(%session.Data("LOGON.USERNAME")) 
    }  
    s ProgressID=""
    s menuCspName="" 
    ;s LogFlagID=..GetLogFlagID() 
    Tstart
    s obj=##class(User.MKBDataChangeLog).%New()
    s obj.TableName = TableName
    s obj.ClassName = ClassName
    s obj.ClassNameDesc = ClassNameDesc //类描述
    s obj.ObjectReference = ObjectReference
    if $l(ObjectDesc)>50 s ObjectDesc=$e(ObjectDesc,1,50)  //对象描述
    s obj.ObjectDesc = ObjectDesc  //对象描述
    s obj.IpAddress = IPAddress 
    ;s obj.RelevantKey =LogFlagID 
    ;d obj.UpdateUserDRSetObjectId(LoginUserID)
    s obj.UpdateUserName =LoginUserName 
    s obj.OperateType = OperateType
    s obj.NewValue = NewValue
    s obj.OldValue = OldValue
    s HospitalID=($Get(%session.Data("LOGON.HOSPID")))
    s LocID=($Get(%session.Data("LOGON.CTLOCID")))
    s obj.UpdateHospital=$p($Get(^CT("HOSP",HospitalID)),"^",2)
    s obj.UpdateLoc=$p($Get(^CTLOC(LocID)),"^",2)
    s sc=obj.%Save()
    s id=obj.%Id()
    ; 记录具有关联关系的日志索引
    ;if (LogFlagID'=""){
        ;s ^BDPChangeLogLogI("BDPLog",LogFlagID,id)=""
    ;}
    d obj.%Close()
    If $$$ISOK(sc) 
    {
         Tcommit
         s result=id_"^"_"添加成功!"
    }
    else 
    {
        Trollback
        s result="添加失败!"
    }
   }
   q result
}

/// Function: 获取默认日期
/// Return:  七天前_"^"_当天日期 yyyy-mm-dd 
/// Debug:   w ##class(web.DHCBL.MKB.MKBDataChangeLog).GetDefaultDate()
ClassMethod GetDefaultDate() As %String
{
    set reuslt=""
    set EndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)     
    set StartDate=+$h-6
    set StartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StartDate)
    set reuslt=StartDate_"^"_EndDate     
    quit reuslt
}

/// Creator:徐 凯
/// CreatDate:2021-10-26
/// Description：获取知识库日志管理MKB表的数据
/// Input：fuzzyserch-全文搜索，classname-功能描述, objectdesc-对象描述, userdr-操作人, operatetype-操作类型 datefrom-开始日期, dateto-结束日期
/// Return:ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataChangeLog","GetList","","","","","A",66000,66666)
Query GetList(fuzzyserch, classname, objectdesc, userdr, operatetype, datefrom, dateto) As %Query(ROWSPEC = "ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, fuzzyserch, classname, objectdesc, userdr, operatetype, datefrom, dateto) As %Status
{
 	Set repid=$I(^CacheTemp)
 	//If $g(ind)="" 
 	s ind=1 
 	
 	if ((datefrom="")&(dateto="")){
	 	s ID ="" 
	 	for
	 	{	
	 		s ID=$o(^User.MKBDataChangeLogD(ID),-1)
			q:ID=""
			s TableName = $lg($g(^User.MKBDataChangeLogD(ID)),2)
			s ClassName = $lg($g(^User.MKBDataChangeLogD(ID)),3)
			s ObjectReference = $lg($g(^User.MKBDataChangeLogD(ID)),4)
			s UpdateHospital = $lg($g(^User.MKBDataChangeLogD(ID)),5)
			s UpdateLoc = $lg($g(^User.MKBDataChangeLogD(ID)),6)
			s UpdateUserName = $lg($g(^User.MKBDataChangeLogD(ID)),7)
			s UpdateDate = $lg($g(^User.MKBDataChangeLogD(ID)),8)
			s UpdateDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
			s UpdateTime = $lg($g(^User.MKBDataChangeLogD(ID)),9)
			s UpdateTime = ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
			s OperateType = $lg($g(^User.MKBDataChangeLogD(ID)),10)
			s NewValue = $lg($g(^User.MKBDataChangeLogD(ID)),11)
			s ClassNameDesc = $lg($g(^User.MKBDataChangeLogD(ID)),12)
			s ObjectDesc = $lg($g(^User.MKBDataChangeLogD(ID)),13)
			s IpAddress = $lg($g(^User.MKBDataChangeLogD(ID)),14)
			s OldValue = $lg($g(^User.MKBDataChangeLogD(ID)),15)
			s RelevantKey = $lg($g(^User.MKBDataChangeLogD(ID)),16)
			d OutputRowMKBLog
	 	}
	}
	else
	{
		s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
		s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
		s:datefrom="" datefrom=+$h-730 //起始日期未输入，默认查近二年 
		s:dateto="" dateto=+$h
	    s Date=dateto+1
	    for
	    { 
	      	s Date=$o(^User.MKBDataChangeLogI("UpdateDateIndex",Date),-1)
	        q:(Date<datefrom)||(Date="")
		    s ID=""
	        for
	        {
		        s ID=$o(^User.MKBDataChangeLogI("UpdateDateIndex",Date,ID),-1)
		        q:ID=""
				s TableName = $lg($g(^User.MKBDataChangeLogD(ID)),2)
				s ClassName = $lg($g(^User.MKBDataChangeLogD(ID)),3)
				s ObjectReference = $lg($g(^User.MKBDataChangeLogD(ID)),4)
				s UpdateHospital = $lg($g(^User.MKBDataChangeLogD(ID)),5)
				s UpdateLoc = $lg($g(^User.MKBDataChangeLogD(ID)),6)
				s UpdateUserName = $lg($g(^User.MKBDataChangeLogD(ID)),7)
				s UpdateDateTemp = $lg($g(^User.MKBDataChangeLogD(ID)),8)
				s UpdateDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateTemp)
				s UpdateTimeTemp = $lg($g(^User.MKBDataChangeLogD(ID)),9)
				s UpdateTime = ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeTemp)
				s OperateType = $lg($g(^User.MKBDataChangeLogD(ID)),10)
				s NewValue = $lg($g(^User.MKBDataChangeLogD(ID)),11)
				s ClassNameDesc = $lg($g(^User.MKBDataChangeLogD(ID)),12)
				s ObjectDesc = $lg($g(^User.MKBDataChangeLogD(ID)),13)
				s IpAddress = $lg($g(^User.MKBDataChangeLogD(ID)),14)
				s OldValue = $lg($g(^User.MKBDataChangeLogD(ID)),15)
				s RelevantKey = $lg($g(^User.MKBDataChangeLogD(ID)),16)
	            if (((operatetype="")||((operatetype'="")&&(OperateType = operatetype)))&&((userdr="")||((userdr'="")&&($zcvt(UpdateUserName,"U")[$zcvt(userdr,"U"))))&&((UpdateDateTemp>=datefrom)&&(UpdateDateTemp<=dateto))&&((objectdesc="")||(ObjectDesc[objectdesc))&&(($zcvt(ClassNameDesc,"U")[classname)||($zcvt(ClassName,"U")[classname)||(classname=""))&&((objectdesc="")||(ObjectDesc[objectdesc))&&((fuzzyserch="")||((fuzzyserch'="")&&(($$ALPHAUP^SSUTIL4(ClassName)[fuzzyserch)||($$ALPHAUP^SSUTIL4(ClassNameDesc)[fuzzyserch)||($zcvt(UpdateUserName,"U")[$zcvt(fuzzyserch,"U")||($zcvt(TableName,"U")[fuzzyserch)||($zcvt(ObjectReference,"U")[fuzzyserch)||($zcvt(ObjectDesc,"U")[fuzzyserch)||(IpAddress[fuzzyserch)||(UpdateDate[fuzzyserch)||(UpdateTime[fuzzyserch))))))
	            {
			  		d OutputRowMKBLog
	            }
			 }
  	    }
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowMKBLog
	set Data=$lb(ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
