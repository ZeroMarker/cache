Class web.DHCNURZSKOnPage Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//s userLoc = %session.Get("LOGON.CTLOCID")
	s Loc = $Get(%request.Data("Loc",1),"")
	s ^objccc=Loc
	q:(Loc="") $$$OK
	s ^TEMPGuoxubo("1029")=Loc
	s userLoc = Loc			//当前登录用户科室
	d ..Getxmlstr(userLoc)	
	Quit $$$OK
}

ClassMethod GetListKn(loc As %String) As %String
{
 //s a=##class(web.DHCNurknowInterface).GetListKn("27")
   s ret=""
   s rw="" f  s rw=$O(^NurEmr.KnowledgeLocI("Loc"," "_loc,rw)) q:rw=""  d
   .s a=^NurEmr.KnowledgeLocD(rw)
   .s code=$list(a,3)
   .s id=##class(NurEmr.NurEmrSub).getId(code)
   .q:id=""
   .s b=##class(NurEmr.NurEmrSub).%OpenId(id)
   .b ;
   .q:b=""
   .s desc=b.EmrSubDesc
   .s flag=$listget(a,4)
   .s ret=ret_code_"|"_desc_"|"_flag_"&"
   q ret
}

/// InPut： session['LOGON.CTLOCID']
/// w ##class(web.DHCNURZSKOnPage).Getxmlstr("27")
ClassMethod Getxmlstr(userLoc)
{
   s liststr=..GetListKn(userLoc)
   s listLength=$l(liststr,"&")
   b ;

   w "["
   f i=1:1:(listLength-1)
   {
	    s keystr=$p(liststr,"&",i)
   		//s keystr=$p(str,"^",1)
   		s treename=$p(keystr,"|",1)
   		s title=$p($p(keystr,"|",2),"-",2)
   		if 1'=i w ","
   		w "{id:'"_treename_"'"
   		w ",text:'"_title_"'"
   	    w ",cls:'folder'"
   	    w ",children:"	  
   		d ..GetNodeByXML(treename,i)
   		w "}"
	
   }
   w "]"
   /*
   s xmlstr=""
   s id=##class(NurEmr.NurEmrSub).getData(treename)
   s chr=0  for  s chr=$o(^NurEmr.NurEmrSubS(id,chr))  q:chr=""  d
   .s temstr=$g(^NurEmr.NurEmrSubS(id,chr))
   .s xmlstr=$g(xmlstr)_temstr
   q xmlstr
   */
}

/// 解析xml
/// InPut：Emrcode,模板的顺序(用来区分父节点的id)
/// Output：指定的Ext树节点
/// w ##class(web.DHCNURZSKOnPage).GetNodeByXML("42Kn")
ClassMethod GetNodeByXML(code As %String, n) As %String
{
	   //取xml的头指针Reader
	   s str=##class(NurEmr.NurEmrSub).GetKCode(code)
       if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
       s Data=""
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }
	   q:str="" 
	   d Data.Rewind()
	   s itmRelName=""
	   s Reader=##class(web.DHCNUREMR).GetReader(code,Data)
	   
	   
	   /**************************静态加载树*****************************/
	   
	   //存储有删除标记的数据路径
	  s DELStr=""
	  s i=0
	  while Reader.Read()
	  {
	   if Reader.MoveToAttributeName("Delflag")
		 { 
		     if (Reader.Value="Y")
		       {
			      //s DELStr=$g(DELStr)_","_Reader.Path 
			      s i=i+1
			      s DELStr(i)=Reader.Path  
			   }
		 }
	   
	  }
	   
	   
	      d Reader.Rewind()   //初始化指针Reader，指向xml的开始位置
	   	  s startNodeFlag=1 
	      s minPathLength=4   //最短的，eg：/ROOT/NOD/fold2
	      s lastPath=""  
	      s delPath=""
	      s j=0
          w "["  
          while Reader.Read()
	      {
		    s pathLength=$l(Reader.Path,"/")
		    continue:pathLength<minPathLength
		    s quitFlag=..IfDelPath(pathLength,Reader.Path,.DELStr)
		    continue:quitFlag=1
		    	
		   if Reader.NodeType'="endelement"  
		   {  
		      s val=Reader.Value
		      s val=$tr(val,"\","")
		      if Reader.Name["fold"
		      {
			     if startNodeFlag=1  w "{"
	             else  w ",{"
			     ;if Reader.MoveToAttributeName("RelName") w "id:'"_Reader.Value_"'" 
			     if Reader.MoveToAttributeName("Title") w "id:'"_$p(Reader.Path,"/",pathLength)_"_"_n_"_"_$I(j)_"'" //n:区分不同模板，j：解决知识库生成的xml里的bug
			     if Reader.MoveToAttributeName("Title") w ",text:'"_$tr(Reader.Value,"\","")_"'"
			     w ",cls:'folder'"	        
		      }
		      if Reader.Name["itm"
		      {
		        if (lastPath'="")&(Reader.Path[lastPath)&(lastPath'=Reader.Path) 
			    { 
			       if Reader.MoveToAttributeName("RelName") s qtipstr=..GetKnowledge(Reader.Value)
			       w ",children:["
			       w "{"
			       if Reader.MoveToAttributeName("RelName") w "id:'"_$tr(Reader.Value,"\","")_"'"
			      
			       if Reader.MoveToAttributeName("RelName") w ",qtip:'"_qtipstr_"'"
			       if Reader.MoveToAttributeName("Title") w ",text:'"_$tr(Reader.Value,"\","")_"'"
			       w ",leaf:'true'"
			       w ",icon:'../images/tree/book.gif'"
			       w ",cls:'folder'"
	            }
	            else
		        {
			       if Reader.MoveToAttributeName("RelName") s qtipstr=..GetKnowledge(Reader.Value)
		           if startNodeFlag=1  w "{"
	               else  w ",{"
			       if Reader.MoveToAttributeName("RelName") w "id:'"_$tr(Reader.Value,"\","")_"'"
			       if Reader.MoveToAttributeName("RelName") w ",qtip:'"_qtipstr_"'"
			       if Reader.MoveToAttributeName("Title") w ",text:'"_$tr(Reader.Value,"\","")_"'"
			       w ",leaf:'true'"
			       w ",icon:'../images/tree/book.gif'"
			       w ",cls:'folder'"		  	
			    }
		      }
		  }
		  		  
		 if Reader.NodeType="endelement"
		 {
		   if (lastPath'="")&(lastPath[Reader.Path)&(lastPath'=Reader.Path)  
			{ 
			    w "]"
			    
			}
		  if (lastPath'="")&(Reader.Path=lastPath)&(Reader.Name["fold")
			{
			    w ",children:[]"
		    }
		    
		    w "}"
		 } 
		  
		  s lastPath=Reader.Path
		  s startNodeFlag=0
		    
	  }

        w "]"

		  	   
     
       /*********************************************************************
       //动态加载树时可以用
       
        //取最长的路径长度
	   s maxPathLength=0
	    while Reader.Read()
	   { s pathLength=$l(Reader.Path,"/")
	     if pathLength>maxPathLength s maxPathLength=pathLength
	   }
	   s minPathLength=4   //最短的，eg：/ROOT/NOD/fold2
       
	   //按层读出节点
	   w "["
	   for L=minPathLength:1:maxPathLength
	   { 
	      d Reader.Rewind()
	     // w "["
          while Reader.Read()
	      {
		    s pathLength=$l(Reader.Path,"/")
		    continue:pathLength'=L
		    continue:Reader.NodeType="endelement"
		    
		    if Reader.Name["itm"
		    {
		       w "{"
			   if Reader.MoveToAttributeName("RelName") w "id:'"_Reader.Value_"'"
			   if Reader.MoveToAttributeName("Title") w ",text:'"_Reader.Value_"'"
			   w ",leaf:'ture'"
			   w ",cls:'folder'"
			   w "},"	
			}
			
			if (Reader.Name'["itm")&(Reader.Name["fold")
		    {
	           w "{"
			   if Reader.MoveToAttributeName("RelName") w "id:'"_Reader.Value_"'"
			   if Reader.MoveToAttributeName("Title") w ",text:'"_Reader.Value_"'"
			   w ",cls:'folder'"
			   w "},"	 
		    }
	      	
	      }
	   }
	  w "]"
	   ********************************************************************************/
}

/// InPut： PathLength,Reader.Path,delarry
/// OutPut:1(是有删除标记的路径)
/// w ##class(web.DHCNURZSKOnPage)IfDelPath("42")
ClassMethod IfDelPath(length, path, delarry)
{
	;b ;000
	s ret=0
	s n="" for  s n=$o(delarry(n)) q:(n="")||(ret=1)  d
	.i path=delarry(n) d  
	..s ret=1
	.i $p(path,1,length-1)=delarry(n) d  
	..s ret=1
	q ret
}

/// 通过code取知识库数据
/// InPut: 知识库树节点：RelName
/// OutPut: 知识库xml转化的字符串
/// w ##class(web.DHCNURZSKOnPage).GetKnowledge("500Kn.NODitm4")
ClassMethod GetKnowledge(code) As %String
{
   	s ^tmpyjn("GetKnowledge")=code
    //取知识库数据XML头指针Reader  
	q:""=code ""
	s KnowledgeXml=##class(web.DHCNurknowInterface).GetZSKStream(code)
	q:""=KnowledgeXml ""
	d KnowledgeXml.Rewind()
	s Reader=##class(web.DHCNUREMR).GetReader(code,KnowledgeXml)
	
	s txt=""
	//转化Xml	
	while Reader.Read()
	  {
		  continue:(Reader.Path)'["InstanceData"		  
		  s itmType=$E($p(Reader.Path,"/",4),0,1)
		  s value=""
		  if $p(Reader.Path,"/",4)="FreeText"
		  {
		     s itm=Reader.Value
		    // s itm=$TR(itm,"&nbsp;","")	  
		    // s itm=$TR(itm,"&KeyEnter;","\n\r")
		     s txt=txt_itm  
		  } 
		  else 
		  {
			  s value=Reader.Value
		  }
		  
		  if itmType="S"
		  {
			  s txt=txt_value
		  }
		  if itmType="O"
		  {
			 s txt=txt_"【"
			  while Reader.Read()
			   {
				  s pathLength=$L(Reader.Path,"/")
				  q:pathLength=4
				  if Reader.Name="" s txt=txt_Reader.Value_","
			   }
			  s txt=txt_"】"
		  }
		   if itmType="M"
		  {
			  s txt=txt_"【"
			  while Reader.Read()
			   {
				  s pathLength=$L(Reader.Path,"/")
				  q:pathLength=4
				  if Reader.Name="" s txt=txt_Reader.Value_","
			   }
			   s txt=txt_"】"
		  }
		    if itmType="D"
		  {
			 s value="",tFlag="",value=""
		  	 if Reader.MoveToAttributeName("DateFlag") s dFlag=Reader.Value
		  	 if Reader.MoveToAttributeName("TimeFlag") s tFlag=Reader.Value
		  	 if Reader.MoveToAttributeName("Value")    s value=Reader.Value
		  	
		     if (dFlag="Y")&(tFlag="Y")
            	{
	                s value=value
                }
             if (dFlag="Y")&(tFlag="N")
            	{
	                s value=$p(value," ",1)
                }
             if (dFlag="N")&(tFlag="Y")
            	{
	                s value=$p(value," ",2)
                }
             s txt=txt_value    	
                   	   
		   
		  
		  }
		 
	  }
	s txt=$tr(txt,$char(129),"")
	s txt=$tr(txt,$char(10),"")
	s txt=$tr(txt,$char(13),"")
	s txt=$tr(txt,"\r","")
	s txt=$tr(txt,"\n","")
	s txt=$tr(txt,"\","")
	s txt=$tr(txt,",","，")
	s txt=$tr(txt,"'","‘")
	s txt=$tr(txt,"&KeyEte;","")
	Quit txt
}

/// 取科室combox的json数据
/// w ##class(web.DHCNURZSKOnPage).GetListAllLoc()
ClassMethod GetListAllLoc() As %String
{
   s ret=""
   s rw="" f  s rw=$O(^NurEmr.KnowledgeLocI("Loc",rw)) q:rw=""  d
   .s id=$tr(rw," """)
   .q:id=""
   .s des=$p(^CTLOC(id),"^",2)
   .i ret="" s ret="["_id_",'"_des_"']"
   .e  s ret=ret_","_"["_id_",'"_des_"']"
   q "["_ret_"]"
}

ClassMethod GetLocDesc(LocID) As %String
{
	q:LocID="" ""
	s desc=$p(^CTLOC(LocID),"^",2)
	q desc
}

ClassMethod GetMoudleNums(LocID) As %String
{
    s liststr=..GetListKn(LocID)
    s listLength=$l(liststr,"&")
    q listLength-1
}

/**************************************************/
/// 取某次就诊的开始日期，结束日期
/// InPut:EpisodeID
/// OutPut:StartDate,EndDate
ClassMethod GetDateByAdm(EpisodeID) As %String
{
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	i AdmDate'=""  s StartDate=$zd(AdmDate,3)
	else  s StartDate=$Zd(+$h,3)
	s DischgDate=$p($g(^PAADM(EpisodeID)),"^",59)
    i DischgDate'=""  s EndDate=$zd(DischgDate,3)
    else  s EndDate=$Zd(+$h,3)
    
    q StartDate_"^"_EndDate
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称,医嘱申请日期和时间,结果状态,检验号,
///                报告ID,标本,标本采集日期和时间,接收日期和时间
///                审核日期和时间,是否有预报告,危急提示
///                OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,
///                LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,
///                AuthDate,AuthTime,PreReport,WarnComm
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderList(parr As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OrdItemName:%String,OrdItemDate:%String,OrdItemTime:%String,ResultStatus:%String,LabEpisode:%String,LabTestSetRow:%String,OrdSpecimen:%String,SpecDate:%String,SpecTime:%String,RecDate:%String,RecTime:%String,AuthDate:%String,AuthTime:%String,PreReport:%String,WarnComm:%String,ResultFlagDesc:%String,Note:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","QueryOrderList","76##^^^^#2017-03-14#2017-03-29")

ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^tmpyjn("QueryOrderList")=$lb(parr)
    s EpisodeID=$p(parr,"#",1)
	s PatientID=$p(parr,"#",2)
	s Search=$p(parr,"#",3)
	s stdate=$p(parr,"#",4)
	s edate=$p(parr,"#",5)
	
	
	s ^obj65(1)=EpisodeID
	s ^obj65(2)=PatientID
	s ^obj65(3)=Search
	s ^obj65(4)=stdate
	s ^obj65(5)=edate
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//i '$l(AuthFlag) s AuthFlag="N"
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	k ^TMP($zn,$j)
    s ^WANGLI("LIS",EpisodeID)=EpisodeID_","_PatientID_","_SearchCriteria
	i AuthFlag="N",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="Y",$l(PatientID) d
	.//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	.//s PAPERId=$o(^PAPERi("PAPMI_PatNo",CardID,""))
	.//i '$l(PAPERId) q
	.//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	s date="" f  s date=$o(^TMP($zn,$j,date),-1) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,date,time),-1) q:time=""  d
	..s LabNo="" f  s LabNo=$o(^TMP($zn,$j,date,time,LabNo)) q:LabNo=""  d
	...s OrdId="" f  s OrdId=$o(^TMP($zn,$j,date,time,LabNo,OrdId)) q:OrdId=""  d
	....s Data=$g(^TMP($zn,$j,date,time,LabNo,OrdId))
	....d OutputRow
	//i '$l(EpisodeID)	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	k LabNoInfo
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s ItmStatusDD=$p(OrdStr1,"^",13)
			
			s ItmStatusFlag="N"
			i ItmStatusDD="2" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="4" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="10" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			
			i $l(ItmMastDr),##class(web.DHCNurknowInterface).isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				s Stdate="",Edate=""
				i stdate'="" s Stdate=$zdh(stdate,3)
				i edate'="" s Edate=$zdh(edate,3)
				q:(Stdate'="")&(ReqDate<Stdate)
				q:(Edate'="")&(ReqDate>Edate)
				//比较日期
				s flag="N"
				//b 100
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				//i flag="N",$l(
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//b 20
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm)=""
				s ReportFlag="N"  //预报告
				//b 200 
			
				i flag="N"{
					i $l(LabTestSetRow){
						//i LabNo="2003044081" b ;预报告
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
					
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
						
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							//i ('$l(AuthFlag))!('((ReportStus="N")&(AuthFlag="Y")))
							
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//b 200
								//接收日期时间
								/*
								s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
								i $l(RecDate) s RecDate=$zd(RecDate,3)
								s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
								i $l(RecTime) s RecTime=$zt(RecTime*60,2)
								s RecDate="2009-09-08"
								;$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
								s RecTime="19:09:08"
								;=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
								
								*/
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								s LabNoInfo(LabNo)=AuthDate_"^"_AuthTime
								
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
								//危急提示
								s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p($g(^TTAB("SPEC",SpecCode)),"\",1)
					}
					/*采集日期时间Collection
					s (SpecDate,SpecTime)=""
					s OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OrdRowId,""),-1)
					i $l(OrdExecId){
						s SpecDate=$p(^DHCOrdExec(OrdExecId),"^",13)
						i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
						s SpecTime=$p(^DHCOrdExec(OrdExecId),"^",14)
						i $l(SpecTime) s SpecTime=$zt(SpecTime,2)
					}
					*/
					
					s SpecDate=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
					s SpecTime=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
					
					//b 400					
					;s RecDate=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",1)
					;s RecTime=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",2)
					s RecDate=""
					s RecTime=""		
					s ResultFlag=$p(^OEORD(OrdId,"I",SubId,1),"^",5)
					
	
					s ResultFlag=$$ALPHAUP^SSUTIL4(ResultFlag)
					s ResStatDR=$o(^OEC("RESST",0,"Code",ResultFlag,""),-1)
					i ResStatDR'="" d
					.s ResultFlagDesc=$p($g(^OEC("RESST",ResStatDR)),"^",2)
					e  d
					.s ResultFlagDesc=""
					
					s RESSUB=$o(^OEORD(OrdId,"I",SubId,"RES",""),-1)
					i RESSUB'="" d
					.s Note=$g(^OEORD(OrdId,"I",SubId,"RES",RESSUB,"TXT"))
					e  d
					.s Note=""
					i LabEpisode'="" {
						i $d(LabNoInfo(LabEpisode)) d
						.s ReportStus="Y"
						.s AuthDate=$p(LabNoInfo(LabEpisode),"^",1)
						.s AuthTime=$p(LabNoInfo(LabEpisode),"^",2)
					}else{
						s LabEpisode="No LabNo"
						s ReportStus="N",AuthDate="",AuthTime=""
					}
			        
					if ReportStus'="Y",ResultFlag'="RE" s ReportStus="N"
					if ItmStatusFlag="N" {
						set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm,ResultFlagDesc,Note)
						s ^TMP($zn,$j,ReqDate,ReqTime,LabEpisode,OrdRowId)=Data
					}
				}
				//d OutputRow
			}
		}
	}
	q
	
OutputRow
	//set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称
///                OrdRowId,OrdName,
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderListLis(parr As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OrdItemName:%String,TSResultAnomaly:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","QueryOrderListLis","76##^^^^#2017-03-14#2017-03-29")

ClassMethod QueryOrderListLisExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

    s EpisodeID=$p(parr,"#",1)
	s PatientID=$p(parr,"#",2)
	s Search=$p(parr,"#",3)
	s stdate=$p(parr,"#",4)
	s edate=$p(parr,"#",5)
	;b ;11
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	k ^TMP($zn,$j)
    s ^WANGLI("LIS",EpisodeID)=EpisodeID_","_PatientID_","_SearchCriteria
	i AuthFlag="N",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="Y",$l(PatientID) d
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	s date="" f  s date=$o(^TMP($zn,$j,date),-1) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,date,time),-1) q:time=""  d
	..s LabNo="" f  s LabNo=$o(^TMP($zn,$j,date,time,LabNo)) q:LabNo=""  d
	...s OrdId="" f  s OrdId=$o(^TMP($zn,$j,date,time,LabNo,OrdId)) q:OrdId=""  d
	....s Data=$g(^TMP($zn,$j,date,time,LabNo,OrdId))
	....d OutputRow
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	k LabNoInfo
	s TSResultAnomaly=""
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s ItmStatusDD=$p(OrdStr1,"^",13)
			
			s ItmStatusFlag="N"
			i ItmStatusDD="2" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="4" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="10" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			
			i $l(ItmMastDr),##class(web.DHCNurknowInterface).isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				s Stdate="",Edate=""
				i stdate'="" s Stdate=$zdh(stdate,3)
				i edate'="" s Edate=$zdh(edate,3)
				q:(Stdate'="")&(ReqDate<Stdate)
				q:(Edate'="")&(ReqDate>Edate)
				//比较日期
				s flag="N"
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm)=""
				s ReportFlag="N"  //预报告
			
				i flag="N"{
					i $l(LabTestSetRow){
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
					
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
						
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								s LabNoInfo(LabNo)=AuthDate_"^"_AuthTime
								
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
								//危急提示
								s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
								//结果异常标志
								s TSResultAnomaly=##class(web.DHCLabResultStatus).checkTSResultStatus(LabTestSetRow)

							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)
					}
					
					s SpecDate=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
					s SpecTime=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
								
					;s RecDate=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",1)
					;s RecTime=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",2)
					s RecDate=""
					s RecTime=""
							
					s ResultFlag=$p(^OEORD(OrdId,"I",SubId,1),"^",5)
					
	
					s ResultFlag=$$ALPHAUP^SSUTIL4(ResultFlag)
					s ResStatDR=$o(^OEC("RESST",0,"Code",ResultFlag,""),-1)
					i ResStatDR'="" d
					.s ResultFlagDesc=$p($g(^OEC("RESST",ResStatDR)),"^",2)
					e  d
					.s ResultFlagDesc=""
					
					s RESSUB=$o(^OEORD(OrdId,"I",SubId,"RES",""),-1)
					i RESSUB'="" d
					.s Note=$g(^OEORD(OrdId,"I",SubId,"RES",RESSUB,"TXT"))
					e  d
					.s Note=""
					i LabEpisode'="" {
						i $d(LabNoInfo(LabEpisode)) d
						.s ReportStus="Y"
						.s AuthDate=$p(LabNoInfo(LabEpisode),"^",1)
						.s AuthTime=$p(LabNoInfo(LabEpisode),"^",2)
					}else{
						s LabEpisode="No LabNo"
						s ReportStus="N",AuthDate="",AuthTime=""
					}
			        
					if ReportStus'="Y",ResultFlag'="RE" s ReportStus="N"
					if (ItmStatusFlag="N")&(ReportStus="Y") {
						set Data=$lb(OrdRowId,OrdName,TSResultAnomaly)
						s ^TMP($zn,$j,ReqDate,ReqTime,LabEpisode,OrdRowId)=Data
					}
				}
			}
		}
	}
	q
	
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListLisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListLisExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrderListLisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListLisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到就诊诊断列表
/// Table：        MR_Diagnos
/// Input：        就诊号
/// OutPut:        诊断类型,诊断ICD描述,诊断注释,诊断状态,下诊断医生,下诊断日期,下诊断时间
/// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","GetPatDiga","107101")
Query GetPatDiga(Adm As %String) As %Query(ROWSPEC = "DigaType,DigaICDDesc,DigaNoteDesc,DigaStatus,DigaDoc,DigaDate,DigaTime")
{
}

ClassMethod GetPatDigaExecute(ByRef qHandle As %Binary, Adm) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    i Adm="" Quit $$$OK
        
     f a2=1:1:$g(^MR(Adm,"DIA",0)) d
     .s icdr=$p($g(^MR(Adm,"DIA",a2)),"^",1)
     .s diatypeId=$o(^MR(Adm,"DIA",a2,"TYP",0))
     .q:diatypeId=""
     .s diatypedr=$p(^MR(Adm,"DIA",a2,"TYP",diatypeId),"^",1)
     .i $g(diatypedr)'="" s DigaType=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;诊断类型
     .e  s DigaType=""
     .s DocCtProve=$p($g(^MR(Adm,"DIA",a2)),"^",4)
     .s statusdr=$p($g(^MR(Adm,"DIA",a2)),"^",9)
     .i statusdr'="" s DigaStatus=$p(^MRC("DSTAT",statusdr),"^",2) ;状态
     .e  s DigaStatus=""
     .s DigaDoc=$p(^CTPCP(DocCtProve,1),"^",2)  ;医生
     .s DigaDate=$ZD($p($g(^MR(Adm,"DIA",a2)),"^",7),3) ;日期
     .s DigaTime=$ZT($p($g(^MR(Adm,"DIA",a2)),"^",8),2) ;时间
     .s DigaNoteDesc=""
     .f de=1:1:$g(^MR(Adm,"DIA",a2,"DES",0)) d
     ..s DigaNoteDesc=$g(DigaNoteDesc)_$g(^MR(Adm,"DIA",a2,"DES",de)) ;注释
     .i icdr'="" d
     ..s DigaICDDesc=$P($g(^MRC("ID",icdr)),"^",2)   ;ICD疾病描述
     ..d OutPutDiga
     .e  d 
     ..s DigaICDDesc=""
     ..d OutPutDiga
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutDiga
	set Data=$lb(DigaType,DigaICDDesc,DigaNoteDesc,DigaStatus,DigaDoc,DigaDate,DigaTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatDigaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatDigaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatDigaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatDigaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
