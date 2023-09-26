Class web.DHCBL.MKB.SDSDiagnosTimeline Extends %RegisteredObject
{

/// Creator: 范文凯
/// CreatDate: 2019-09-20
/// Description: 患者的结构化诊断生命周期
/// Table: 
/// Input:患者id
/// Return:该患者所有的结构化诊断
/// Other：w ##class(web.DHCBL.MKB.SDSDiagnosTimeline).ProduceSDSTimeLine("239")
ClassMethod ProduceSDSTimeLine(SDSPMINo As %String)
{
	k ^Temptimesort
	s SDSADMRowId = $o(^User.SDSAdmI("ADMPMIIndex",SDSPMINo,0))        //通过入参， 在SDS_Adm 表中找到患者id对应的SDSADM_Rowid
	d ..AllDiagnos(SDSADMRowId)
    
	s SDSDiagnosId = ""
	for
	{
		//s SDSDiagnosId = $o(^User.SDSDiagnosLogI("AdmTypeIndex","A",SDSADMRowId,SDSDiagnosId),-1)        //该患者下过所有诊断的id
		s SDSDiagnosId = $o(^TmpAllDiag(SDSDiagnosId),-1)
		q:SDSDiagnosId=""
		//修改前
		s diagnoslasttime = $o(^User.SDSDiagnosLogI("RefIndex",SDSDiagnosId,""),-1)           //取该诊断对应的日志最后一条数据的id
		s ^Temptimesort(diagnoslasttime)=SDSDiagnosId
		
	}	
	//b
	s lasttime=""
	for
	{
		s lasttime = $o(^Temptimesort(lasttime),-1)
		//b
		q:lasttime=""
		s SDSDiagnosId = ^Temptimesort(lasttime)
		//修改后
		s num = 0
		s DiagnosLogId =""
		for
		{
			s DiagnosLogId = $o(^User.SDSDiagnosLogI("RefIndex",SDSDiagnosId,DiagnosLogId),-1)                      //取该诊断对应的日志最后一条数据的id
			s num = num + 1
			q:DiagnosLogId=""
			
			s str = ""
			//右边放操作类型、科室、操作人、用户IP、操作日期、诊断id、数据明细
			s OperateType = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),5)
			s UpdateLoc = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),8)
			s UpdateLoc = $p($g(^CTLOC(UpdateLoc)),"^",2)
			s UpdateUser = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),2)
			s UpdateUser = $p($g(^SSU("SSUSR",UpdateUser)),"^",2)
			s IpAddress = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),10)
			s UpdateDate = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),3)
			s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
			s UpdateTime =  $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),4)
			s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式 
			s NewValue = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),7)
			s OldValue = $lg($g(^User.SDSDiagnosLogD(DiagnosLogId)),6) 
			s OperateType=##class(web.BDP.util.String).EvalJSON(OperateType)
			s UpdateLoc=##class(web.BDP.util.String).EvalJSON(UpdateLoc)
			s UpdateUser=##class(web.BDP.util.String).EvalJSON(UpdateUser)
			s IpAddress=##class(web.BDP.util.String).EvalJSON(IpAddress)
			s UpdateDate=##class(web.BDP.util.String).EvalJSON(UpdateDate)
			s UpdateTime=##class(web.BDP.util.String).EvalJSON(UpdateTime)
			s NewValue=##class(web.BDP.util.String).EvalJSON(NewValue)
			s OldValue=##class(web.BDP.util.String).EvalJSON(OldValue)
			s DiagnosExp = ""
			
			
		if (OperateType="U")
		{
			s str="",str2="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",SDSTermDR="",SDSValue=""
      		s OldValue1=$e(OldValue,2,$length(OldValue)-1)                // 去掉花括号 {}
      		s NewValue1=$e(NewValue,2,$length(NewValue)-1)
      		s oldlen=$l(OldValue1,",""")
      		s newlen=$l(NewValue1,",""")
     
      		for i=1:1:oldlen
      		{
       			;s PropertyChinese=""
       			s oldstr=$p(OldValue1,",""",i)
       			s newstr=$p(NewValue1,",""",i)
       			s Property=$p(oldstr,":""",1)
       			s temp = $e(Property,0,1)
       			if (temp'="""")
       			{
	       			s Property = """"_Property
	       		}
       			s PropertyValueOld=$p(oldstr,":""",2)
       			s PropertyValueNew=$p(newstr,":""",2)
       			if (i=1)
       			{
       				s SDSTermDR = PropertyValueNew
       				s SDSTermDR = $tr(SDSTermDR,"""","")
       			}
       			if (i=2)
       			{
	       			s SDSValue = PropertyValueNew
	       			s SDSValue = $tr(SDSValue,"""","")
	       		}
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
       			if (SDSTermDR'="")
       			{
	       			s DiagnosExp = ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	       		}
      	    }
		}
		if (OperateType="D")
		{
			s strA = "" 
			s SDSTermDR=""
			s SDSValue =""
			s OldValue1=$e(OldValue,2,$length(OldValue)-1)
			s oldlen=$l(OldValue1,",""")
			for i=1:1:oldlen
      		{
       			s oldstr=$p(OldValue1,",""",i)
       			s Property=$p(oldstr,":""",1)
       			s temp = $e(Property,0,1)
       			if (temp'="""")
       			{
	       			s Property = """"_Property
	       		}
       			s PropertyValueOld=$p(oldstr,":""",2)
       			s PropertyValueOld=$tr(PropertyValueOld,"""","")
       			if (i=1)
       			{
       				s SDSTermDR = PropertyValueOld
       				s SDSTermDR = $tr(SDSTermDR,"""","")
       			}
       			if (i=2)
       			{
	       			s SDSValue = PropertyValueOld
	       			s SDSValue = $tr(SDSValue,"""","")
	       		}
	       		if (SDSTermDR'="")
       			{
	       			s DiagnosExp = ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	       			s DiagnosExp=DiagnosExp_"(被删除)"
	       		}
       			continue:PropertyValueOld=""
       			s strA =strA_Property_":"_PropertyValueOld_","
      		}
			s str = $e(strA,0,*-0)
			;s DiagnosExp = "该诊断被删除"
		}
		if (OperateType="A")||(OperateType="R")
		{
			s strA = "" 
			s SDSTermDR=""
			s SDSValue =""
			s NewValue1=$e(NewValue,2,$length(NewValue)-1)
			s newlen=$l(NewValue1,",""")
			for i=1:1:newlen
      		{
       			s newstr=$p(NewValue1,",""",i)
       			s Property=$p(newstr,":""",1)
       			s temp = $e(Property,0,1)
       			if (temp'="""")
       			{
	       			s Property = """"_Property
	       		}
       			s PropertyValueNew=$p(newstr,":""",2)
       			s PropertyValueNew=$tr(PropertyValueNew,"""","")
       			if (i=1)
       			{
       				s SDSTermDR = PropertyValueNew
       				s SDSTermDR = $tr(SDSTermDR,"""","")
       			}
       			if (i=2)
       			{
	       			s SDSValue = PropertyValueNew
	       			s SDSValue = $tr(SDSValue,"""","")
	       		}
	       		if (SDSTermDR'="")
       			{
	       			s DiagnosExp = ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	       		}
       			continue:PropertyValueNew=""
       			s strA =strA_Property_":"_PropertyValueNew_","
      		}
      		s str = $e(strA,0,*-0)	 
		}
       s StrJson=str
       s StrJson=##class(web.BDP.util.String).EvalJSON(StrJson)
       
       
       if (num=1)
       { 
          w "<div class=""timeline""  style=""margin-top:0px ;width:1070px;height:8000px ; height:auto;"">" ,!
          w "<div style=""font: 0px/0px sans-serif;clear: both;display: block""> </div>",!
          s flag=1
          w "<div class=""timeline-date"">",!
          w "<ul>",!
          w "<h2 class=""second"" style=""position: relative;"">",!
          w "<span>"_DiagnosExp_"</span>",! 
          w " </h2>",!
          w " <li>",!
          w "<h3><span>"_UpdateDate_"<br/>"_UpdateTime_" </span></h3>",!
       	  w " <dl class=""left"">",!
       	  w " <span>"
       	  w "<table  border=""1"" width=""945px"">"
       	  w "<tr>"
       	  w "<th>诊断ID</th>"  
          w "<th>操作类型</th>"
          w "<th>科室</th>"
          w "<th>操作人</th>"
          w "<th>用户IP</th>"
          w "<th>操作日期</th>"
          w "<th>操作时间</th>"
          w "<th>诊断表达式</th>"
          w "<th>数据明细</th>"
          w "</tr>"
          w "<tr>"
          w "<tr>"
          w "<td>"_SDSDiagnosId_"</td>"
          w "<td>"
      
          if (OperateType="A")   w "<img  src= ""../scripts/bdp/Framework/icons/add.gif"">"_"添加" 
          if (OperateType="D")  w "<img  src= ""../scripts/bdp/Framework/icons/delete.gif"">"_"删除"
          if (OperateType="U") w "<img src= ""../scripts/bdp/Framework/icons/update.gif"">"_"修改"
          if (OperateType="R") w "<img src= ""../scripts/bdp/Framework/icons/edit.png"">"_"引用" 
   
          w "</td>"
          w "<td>"_UpdateLoc_"</td>"
          w "<td>"_UpdateUser_"</td>"
          w "<td>"_IpAddress_"</td>"
          w "<td>"_UpdateDate_"</td>"
          w "<td>"_UpdateTime_"</td>"
          w "<td>"_DiagnosExp_"</td>"
          w "<td style=""word-break:break-all"">"_StrJson_"</td>"
       
       	  w "</tr>"
       }
       else
       {
	      w "<tr>"
	      w "<tr>"
	      w "<td>"_SDSDiagnosId_"</td>"
          w "<td>"
      
          if (OperateType="A")   w "<img  src= ""../scripts/bdp/Framework/icons/add.gif"">"_"添加" 
          if (OperateType="D")  w "<img  src= ""../scripts/bdp/Framework/icons/delete.gif"">"_"删除"
          if (OperateType="U") w "<img src= ""../scripts/bdp/Framework/icons/update.gif"">"_"修改"  
          if (OperateType="R") w "<img src= ""../scripts/bdp/Framework/icons/edit.png"">"_"引用" 
   
          w "</td>"
          w "<td>"_UpdateLoc_"</td>"
          w "<td>"_UpdateUser_"</td>"
          w "<td>"_IpAddress_"</td>"
          w "<td>"_UpdateDate_"</td>"
          w "<td>"_UpdateTime_"</td>"
          w "<td>"_DiagnosExp_"</td>"
          w "<td style=""word-break:break-all"">"_StrJson_"</td>"
       
       	  w "</tr>"
       	  w "</tr>"
	   }
	   
     }
		w "</table>"
       w "</span>",!
       w "</dl>",! 
       w "</li>",!
       w "</ul>",!
       w "</div>",!
       if (flag=0)
  	   {  
     	  w "<ul>",!
     	  w "<img src=""../scripts/bdp/Framework/imgs/lifeerror.png"" align=""center"" width=""700"" height=""460"" /> "
     	  w " <li>",!  
   	   } 
  	   w "</div>",!
       w "</div>",!
       w "</div>",!	 
		
	}
	;k ^Temptimesort
	q ""
}

/// 获得该患者的所有诊断
/// Other：w ##class(web.DHCBL.MKB.SDSDiagnosTimeline).AllDiagnos("5")
ClassMethod AllDiagnos(SDSADMRowId As %String)
{
	s SDSDiagnosId = ""
	k ^TmpAllDiag
	for
	{
		s SDSDiagnosId = $o(^User.SDSDiagnosLogI("AdmTypeIndex","A",SDSADMRowId,SDSDiagnosId),-1)        //该患者下过所有诊断的id
		q:SDSDiagnosId=""
		s ^TmpAllDiag(SDSDiagnosId)=""
	}
	for
	{
		s SDSDiagnosId = $o(^User.SDSDiagnosLogI("AdmTypeIndex","U",SDSADMRowId,SDSDiagnosId),-1)        //该患者下过所有诊断的id
		q:SDSDiagnosId=""
		s ^TmpAllDiag(SDSDiagnosId)=""
	}
	for
	{
		s SDSDiagnosId = $o(^User.SDSDiagnosLogI("AdmTypeIndex","D",SDSADMRowId,SDSDiagnosId),-1)        //该患者下过所有诊断的id
		q:SDSDiagnosId=""
		s ^TmpAllDiag(SDSDiagnosId)=""
	}
	for
	{
		s SDSDiagnosId = $o(^User.SDSDiagnosLogI("AdmTypeIndex","R",SDSADMRowId,SDSDiagnosId),-1)        //该患者下过所有诊断的id
		q:SDSDiagnosId=""
		s ^TmpAllDiag(SDSDiagnosId)=""
	}
	q ""
}

}
