Class web.DHCBL.MKB.MKBEChartsInterface Extends %RegisteredObject
{

/// Creator:范文凯
/// CreatDate:2019-08-13
/// Description：获取各版本icd结构化匹配条数
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetICDDataNum(526474)
ClassMethod GetICDDataNum(source)
{
	s Ptotal=0
    s Ntotal=0
	s MKBICDRowid=0
	for
	    {
           s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		   q:MKBICDRowid=""
		   s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		   s MKBICDStatus=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),18)
           if ((Sources[source)&(MKBICDStatus="1"))
           {
               s Ptotal = Ptotal+1
           }
           elseif ((Sources[source)&(MKBICDStatus'="1"))
           {
               s Ntotal = Ntotal+1 
           }

	    }
     q Ptotal_","_Ntotal
}

/// Creator:范文凯
/// CreatDate:2019-08-13
/// Description：获取各版本icd结构化匹配条数,前端接口
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetAllNum()
ClassMethod GetAllNum()
{
	s totalA =..GetICDDataNum("526474")
	s totalB =..GetICDDataNum("526475")
	s totalC =..GetICDDataNum("526476")
	s totalD =..GetICDDataNum("526477")
	q totalA_","_totalB_","_totalC_","_totalD
}

/// Creator:范文凯
/// CreatDate:2019-08-13
/// Description：获取数据处理工厂匹配度
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetSDDataNum("1")
ClassMethod GetSDDataNum(HospitalID As %String)
{
	s NICDtotal=0
    s NSDtotal=0
    s Allmatch=0
	s MKBSDRowid=0
	for
	    {
           s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",HospitalID,MKBSDRowid))
		   q:MKBSDRowid=""
		   s flag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		   continue:flag'=""
		   s ICD = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
		   s StructFlag = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)
		   if (ICD="")
		   {
			  s NICDtotal = NICDtotal+1 
		   }
		   if (StructFlag'=1)
		   {
			  s NSDtotal = NSDtotal+1
		   }
		   if (ICD'="")&&(StructFlag=1)
		   {
			   s Allmatch = Allmatch+1
		   }
	    }
	 q NSDtotal_","_NICDtotal_","_Allmatch
    // q NICDtotal_","_NSDtotal_","_Allmatch
}

/// Creator:范文凯
/// CreatDate:2019-08-14
/// Description：获取开立诊断频次
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetDiabetesFreq()
ClassMethod GetDiabetesFreq(diag, num)
{
	s DataDiag = diag
	s MKBSDRowid = 0
	s otherTotal = 0
	s result = ""
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		if (MKBSDDiag[DataDiag)
		{
			s MKBSDTotalFreq = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			if (MKBSDTotalFreq>=num)
			{
				 s result = result_MKBSDDiag_","_MKBSDTotalFreq_","
			}
			else
			{
				 s otherTotal = otherTotal+MKBSDTotalFreq
			}
		}
		s result = $zstrip(result,"<>W")
	} 
	q result_"其他,"_otherTotal
}

/// Creator:范文凯
/// CreatDate:2019-08-19
/// Description：获取个人某日维护数据数量
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetDataNumDay("","Demo Group","65244")
ClassMethod GetDataNumDay(op, username, dateto)
{
	s result = 0
	s ID =0
	s enddate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml((dateto))
	if (op="")
	{
		for 
		{
			s ID =  $o(^User.BDPDataChangeLogI("UpdateDateIndex",dateto,ID))
			q:ID=""
			s UpdateUserName = $lg($g(^User.BDPDataChangeLogD(ID)),6)
			s ClassName=$lg($g(^User.BDPDataChangeLogD(ID)),3)    
			continue:(($zcvt(ClassName,"U")'["USER.MKB")&&($zcvt(ClassName,"U")'="USER.BDPMENU"))
			if (UpdateUserName = username)
			{
				s result = result+1
			}
		}
	}
	if (op="U")
	{
		for 
		{
			s ID =  $o(^User.BDPDataChangeLogI("UpdateDateIndex",dateto,ID))
			q:ID=""
			s UpdateUserName = $lg($g(^User.BDPDataChangeLogD(ID)),6)
			s OperateType = $lg($g(^User.BDPDataChangeLogD(ID)),9)
			if (UpdateUserName = username) & (OperateType="U") 
			{
				s result = result+1
			}
		}
	}
	if (op="A")
	{
		for 
		{
			s ID =  $o(^User.BDPDataChangeLogI("UpdateDateIndex",dateto,ID))
			q:ID=""
			s UpdateUserName = $lg($g(^User.BDPDataChangeLogD(ID)),6)
			s OperateType = $lg($g(^User.BDPDataChangeLogD(ID)),9)
			if ((UpdateUserName = username)&(OperateType= op))
			{
				s result = result+1
			}
		}
	}
	if (op="D")
	{
		for 
		{
			s ID =  $o(^User.BDPDataChangeLogI("UpdateDateIndex",dateto,ID))
			q:ID=""
			s UpdateUserName = $lg($g(^User.BDPDataChangeLogD(ID)),6)
			s OperateType = $lg($g(^User.BDPDataChangeLogD(ID)),9)
			if ((UpdateUserName = username)&(OperateType= op))
			{
				s result = result+1
			}
		}
	}
	q enddate_","_result
}

/// Creator:范文凯
/// CreatDate:2019-08-16
/// Description：Echarts个人每日维护表数据接口
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).NumInterface("Demo Group","2019-08-13","2019-08-16")
ClassMethod NumInterface(op, username, startdate, enddate)
{
   
    s date =""
    s num =""
    s Startdate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(startdate)
	s Enddate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(enddate)
	for i=Startdate:1:Enddate
	{
		 s str = ..GetDataNumDay(op,username,i)
		 s date = date_$p(str,",",1)_" "
		 s num = num_$p(str,",",2)_" "  
	}
	s date = $zstrip(date,"<>W")
	s num = $zstrip(num,"<>W")
	s result =date_" "_num
	q result
}

/// Creator:范文凯
/// CreatDate:2019-08-19
/// Description：Echarts数据处理工厂每条诊断短语结构化结果条数
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).Test("1")
ClassMethod Test(HospitalID As %String)
{
	s id = 0
	s total1 = 0
	s total2 = 0
	s total3 = 0
	s other = 0
	for
	{   
	    s rowid = 0
	    s total = 0
		s id=$o(^User.MKBStructuredDataI("BaseIndex",HospitalID,id))
		q:id=""
		for
		{
			s rowid =$o(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid))
			q:rowid=""
			s total = total+1
		}
	    if (total=1)
	    {
		    s total1 = total1+1
		}
		elseif (total=2)
		{
			s total2 = total2+1
		}
		elseif (total=3)
		{
			s total3 = total3+1
		}
		elseif (total'=0)
		{
			s other = other+1
		}	
	}
	q total1_","_total2_","_total3_","_other
}

/// Creator:范文凯     被优化 不再使用  
/// CreatDate:2019-08-21
/// Description：Echarts基于中心词的开立诊断占比图   出参为排好序的频次。
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).DiagTotalFreq(15995)
ClassMethod DiagTotalFreq(centerid, ds)
{
	s MKBSDRowid = 0
	;s total =0
	s totalid = 0
	s num=0
	s result = ""
	for
	{
		s MKBSDRowid = $o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDCenterWordID = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		s MKBSDBaseDr = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)        
		s length = $l(MKBSDCenterWordID ,",")
		s name = MKBSDCenterWordID
		for i=1:1:length
		{   
		    s MKBSDCenterWordID=$p(name,",",i)
			s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			if (MKBSDCenterWordID=centerid)&(MKBSDTotalFreq'=0)&(MKBSDBaseDr=ds)
			{
			
				s ^FXK(MKBSDTotalFreq)=""     // =total

			}
		}
		//s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		//if (MKBSDCenterWordID=centerid)&(MKBSDTotalFreq'=0)
		//{
			;s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			;s total=total+1
			;s ^FWK(total)=MKBSDDiag      //创建临时global用来排序
			//s ^FXK(MKBSDTotalFreq)=""     // =total
			;w MKBSDDiag_","_MKBSDTotalFreq_"  "
		//}
	}
	for
	{
		s totalid = $o(^FXK(totalid))
		q:totalid=""
		s num = totalid
	}
	;s totalid = num
	;w num_","
	;s MKBSDDiag1= $g(^FWK(($g(^FXK(totalid)))))
	;w MKBSDDiag1_","_totalid_","
	for
	{   
		s totalid = $o(^FXK(totalid),-1)
		q:totalid=""
		;s FWKid=$g(^FXK(totalid))
		;w FWKid_","
		;s MKBSDDiag1= $g(^FWK(FWKid))
		s result = result_totalid_" "
	}
	s result =$zstrip(result,"<>W")
	k ^FXK
	q result
	;zw ^FXK
	;zw ^FWK
	;k ^FWK

	;w num_","
}

/// Creator:范文凯   不再使用
/// CreatDate:2019-08-21
/// Description：Echarts基于中心词的开立诊断占比图  有了诊断频次，有centerid 去取诊断名 返回给前端。
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).DiagCenterWordPct(15995)
ClassMethod DiagCenterWordPctold(centerid)
{
    
     s Freq =..DiagTotalFreq(centerid)
     s Freqnum = $l(Freq," ") 
     s MKBSDRowid = 0
     s result = ""
     s other = 0   //向前台传的条数
     s othernum = 0
     s totalnum = 0
     for i=1:1:Freqnum
     {
	     s num = $p(Freq," ",i)
	     for
	     {
		     s MKBSDRowid = $o(^User.MKBStructuredDataD(MKBSDRowid))
		     q:MKBSDRowid=""
		     s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		     s MKBSDCenterWordID = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		     s length = $l(MKBSDCenterWordID ,",")
			 s name = MKBSDCenterWordID
			 for j=1:1:length
			 {
				 s MKBSDCenterWordID=$p(name,",",j)
				 s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		     	 if ((MKBSDCenterWordID=centerid)&(MKBSDTotalFreq=num)&(other<8))
		     	 {
			     	s result = result_MKBSDDiag_" "_num_" "
			     	s other = other + 1
			 	 }
			 	 elseif ((MKBSDCenterWordID=centerid)&(MKBSDTotalFreq=num))
			 	 {
				 	 s othernum = othernum + num
				 }
			 }
		     //s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		     //if ((MKBSDCenterWordID=centerid)&(MKBSDTotalFreq=num))
		     //{
			   //  s result = result_MKBSDDiag_" "_num_" "
			     ;w MKBSDDiag_":"_num_" "
			 //}
		 }
	     
	     
	 }
	 s result = result_"其他"_" "_othernum
	 s result =$zstrip(result,"<>W")
     q result
}

/// Creator:范文凯   优化接口   不再使用
/// CreatDate:2019-08-21
/// Description：Echarts基于中心词的开立诊断占比图  其他的条数
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).DiagCenterWordPct(15995)
ClassMethod DiagCenterWordPct(centerid, ds)
{
    
     s Freq =..DiagTotalFreq(centerid,ds)
     s Freqnum = $l(Freq," ") 
     s MKBSDRowid = 0
     s result = ""
     s other = 0   //向前台传的条数
     s othernum = 0   //剩余的频次和
     s totalnum = 0    //所有的频次和
     for i=1:1:8
     {
	     s num = $p(Freq," ",i)
	     for
	     {
		     s MKBSDRowid = $o(^User.MKBStructuredDataD(MKBSDRowid))
		     q:MKBSDRowid=""
		     s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		     s MKBSDCenterWordID = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		     s MKBSDBaseDr = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)   
		     s length = $l(MKBSDCenterWordID ,",")
			 s name = MKBSDCenterWordID
			 for j=1:1:length
			 {
				 s MKBSDCenterWordID=$p(name,",",j)
				 s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
				 if (i=1)&(MKBSDCenterWordID=centerid)&(MKBSDBaseDr=ds)
		     	 {
			    	s totalnum = totalnum+MKBSDTotalFreq             //把所有的频次加在一起 获得了总频次
			 	 }
		     	 if ((MKBSDCenterWordID=centerid)&(MKBSDTotalFreq=num)&(other<8)&(MKBSDBaseDr=ds))
		     	 {
			     	s result = result_MKBSDDiag_" "_num_" "
			     	s other = other + 1
			     	s othernum = othernum+num          //传到前端的前八频次的总数量   
			 	 }
			 }
		 }    
	 }
	 s othernum = totalnum-othernum             //剩余的频次总和   
	 s result = result_"其他"_" "_othernum
	 s result =$zstrip(result,"<>W")
     q result
}

/// Creator:范文凯   优化接口
/// CreatDate:2019-08-21
/// Description：Echarts基于中心词的开立诊断占比图  诊断中心词列表内容读取。
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetCenterWord("tnb",20,1)
ClassMethod GetCenterWord(desc As %String, rows, page)
{
	;s:desc'="" TextPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
	s desc =$ZCONVERT(desc,"U")
    s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s DetailCount = 0         
	s rowid =1000000000
	s total =0         				//当desc入参为空时， 返回的总条数
	s desctotal=0      				//当desc入参非空时， 返回的总条数
	s mainStr=""       				//当desc入参为空时，拼接json字符串
	s mainStrB=""      				//当desc入参非空时，拼接json字符串
	w "{""rows"":["
	for
	{
		s rowid = $o(^User.MKBTermI("DCountIndex",5,rowid),-1)
		q:rowid=""
		s MKBTDetailCount =rowid
		s MKBTRowid=1000000000
		s baseId = $o(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0))
		for
		{
			s MKBTRowid = $o(^User.MKBTermI("DCountIndex",baseId,rowid,MKBTRowid),-1)
			q:MKBTRowid=""
			s total =total+1
			s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			s MKBTPYCode = $lg($g(^User.MKBTermD(MKBTRowid)),6)
			s MKBTActiveFlag = $lg($g(^User.MKBTermD(MKBTRowid)),9)
			if (desc'="")
			{   
			    s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)  
				s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
				s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
				s aliasDescU=$ZCONVERT(aliasDesc,"U")
				s aliasKeyU=$ZCONVERT(aliasKey,"U")
				s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
				s MKBTPYCodeU =$ZCONVERT(MKBTPYCode,"U")
				if ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc)) 
				{
					s desctotal = desctotal+1
					if (stpage<=desctotal)&(desctotal<=endpage)
					{
						s mainStrB = mainStrB_"{""MKBTRowId"":"""_MKBTRowid_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_"""}"_","
					}
				}
			}
			else
			{
				if (stpage<=total)&(total<=endpage)
				{
					s mainStr = mainStr_"{""MKBTRowId"":"""_MKBTRowid_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_"""}"_","
				}
			}
		}
	}
	if (mainStr'="")
	{
		s mainStr =$zstrip(mainStr,"<>W")
		s length = $l(mainStr)
		s mainStr = $e(mainStr,1,length-1)
		w mainStr
	}
	
	if (mainStrB'="")
	{
		s mainStrB =$zstrip(mainStrB,"<>W")
		s length = $l(mainStrB)
		s mainStrB = $e(mainStrB,1,length-1)
		w mainStrB
	}
	if (desctotal'=0)
	{
		w "], ""total"":"_desctotal_"}"
	}
	else
	{
		w "], ""total"":"_total_"}"
	}
	
	q ""
}

/// Creator:范文凯
/// CreatDate:2019-08-26
/// Description：获取开立诊断频次  （输入诊断名版本）
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewDiabetesFreq("糖尿病")
ClassMethod NewDiabetesFreq(desc, ds, datatype)
{
	s:datatype="全部" datatype=""
	s desc =$ZCONVERT(desc,"U")
	s descpy = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
	s rowid = 0
	s Freq=10000000000
	s num =0
	s othernum =0
	s mainStr = ""
	w "{""rows"":["
	for
	{
		s rowid = $o(^User.MKBStructuredDataD(rowid))
		q:rowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
		s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(rowid)),19)
		s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(rowid)),12)
		s MKBSDAliasPYCode=""
		s:MKBSDAlias'="" MKBSDAliasPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDAlias)
		s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(rowid)),13)
		s MKBSDBaseDr = $lg($g(^User.MKBStructuredDataD(rowid)),22) 
		s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(rowid)),10)
		;if ((MKBSDDiag[desc)||(MKBSDDiagPYCode[descpy)||(MKBSDAlias[desc)||(MKBSDAliasPYCode[descpy))
		if ((MKBSDDiag[desc)||(MKBSDAlias[desc))&(MKBSDBaseDr=ds)&(MKBSDDiaSource[datatype)
		{
			s ^FWK(MKBSDTotalFreq,rowid)=MKBSDDiag
		}
	}
	for
	{
		;s num = num+1
		s Freq = $o(^FWK(Freq),-1)
		q:Freq=""
			for
			{
				s rowid = $o(^FWK(Freq,rowid))
				q:rowid=""
				if (num<8)
				{
				s MKBSDDiag=$g(^FWK(Freq,rowid))
				s num=num+1
				;w MKBSDDiag_","_Freq_","
				s mainStr = mainStr_"{""MKBSDDiag"":"""_MKBSDDiag_""",""Freq"":"""_Freq_"""}"_","
				}
				elseif (Freq'=0)
				{
					s othernum=othernum+Freq
				}
			}
		
	}
	s mainStr=mainStr_"{""MKBSDDiag"":""其他"",""Freq"":"""_othernum_"""}"
	w mainStr
	w "]}"
	k ^FWK
	q ""
	;w "其他"_","_othernum
}

/// Creator:范文凯   不再使用 
/// CreatDate:2019-08-27
/// Description：获取开立诊断数据来源列表   返回所有的数据源  
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).DataSource()
ClassMethod DataSource()
{
	s rowid = 0
	s mainStr = ""
	w "{""rows"":["
	for
	{
		s rowid =$o(^User.MKBStructuredBaseD(rowid))
		q:rowid=""
		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(rowid)),2)
		s mainStr = mainStr_"{""ID"":"""_rowid_""",""MKBSTBDesc"":"""_MKBSTBDesc_"""}"_","
	}
	s mainStr =$zstrip(mainStr,"<>W")
	s length = $l(mainStr)
	s mainStr = $e(mainStr,1,length-1)
	w mainStr
	w "]}"
	q ""
}

/// Creator:范文凯
/// CreatDate:2019-08-27
/// Description：获取开立诊断数据来源列表   返回所有的数据源  
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","DataSource")
Query DataSource() As %Query(ROWSPEC = "ID, MKBSTBDesc")
{
}

ClassMethod DataSourceExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ID = 0
 	for
 	{
	 	s ID =$o(^User.MKBStructuredBaseD(ID))
		q:ID=""
		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(ID)),2)
		d OutputRow8
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ID, MKBSTBDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DataSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod DataSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯   优化方法
/// CreatDate:2019-08-27
/// Description：优化  开立诊断占比图（点击中心词）接口方法
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewDiagCenterWordPct("14870","3","全部")
ClassMethod NewDiagCenterWordPct(centerid, ds, datatype)
{
	if (datatype="全部")
	{
		s datatype =""
	}
	s MKBSDRowid = 0
	s totalid = 0
	s num=0
	s othernum = 0
	s mainStr = ""
	w "{""rows"":["
	s Freq=10000000000
	for
	{
		s MKBSDTotalFreq = 0                                                         //频次初始化 
		s MKBSDRowid = $o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)   //判断是否结构化了
		continue:MKBSDChildStructFlag'="1"                                          //未结构化就跳过
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)     //诊断名
		s MKBSDBaseDr = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)    //医院指向
		s:datatype="" MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)   //频次       频次要根据数据类型去取  全部的时候取13字段
		if (datatype="出院")                                                           //datatype="出院"   取出院频次
		{
			s totalcount = 0
			s LocId = 0
			for
			{
				s LocId = $o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId))
				q:LocId=""
				s MKBSDLocSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId)),4)       //获得是L 还是 O
				continue:MKBSDLocSource="O"
				s MKBSDFrequency =$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId)),3)      //获得频次
				s MKBSDTotalFreq = MKBSDTotalFreq + MKBSDFrequency
			}
			
		}
		if (datatype="门急诊")                                                           //datatype="出院"   取出院频次
		{
			s totalcount = 0
			s LocId = 0
			for
			{
				s LocId = $o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId))
				q:LocId=""
				s MKBSDLocSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId)),4)       //获得是L 还是 O
				continue:MKBSDLocSource="L"
				s MKBSDFrequency =$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocId)),3)      //获得频次
				s MKBSDTotalFreq = MKBSDTotalFreq + MKBSDFrequency
			}
			
		}
		/*s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)  //诊断类型 */
		continue:'((MKBSDTotalFreq'=0)&(MKBSDBaseDr=ds))  
		//s MKBSDCenterWordID = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)            不是根据这个中心词去判断的
		s MKBSDResultId = 0
		for
		{
			s MKBSDResultId = $o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDResultId))
			q:MKBSDResultId=""
			s MKBSDTermDR = $lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDResultId)),4)     //获得中心词的id
			if (MKBSDTermDR=centerid)
			{
				s ^FXK(MKBSDTotalFreq,MKBSDRowid)=MKBSDDiag
			}
		}
		   
		/*s length = $l(MKBSDCenterWordID ,",")
		s name = MKBSDCenterWordID
		for i=1:1:length
		{   
		    s MKBSDCenterWordID=$p(name,",",i)
			if (MKBSDCenterWordID=centerid)&(MKBSDTotalFreq'=0)&(MKBSDBaseDr=ds)&(MKBSDDiaSource[datatype)
			{
				s ^FXK(MKBSDTotalFreq,MKBSDRowid)=MKBSDDiag     // =total
			}
		}*/
	}
	for
	{
		s Freq = $o(^FXK(Freq),-1)
		q:Freq=""
		for
		{
			s MKBSDRowid = $o(^FXK(Freq,MKBSDRowid))
			q:MKBSDRowid=""
			if (num<8)
			{
				s MKBSDDiag=$g(^FXK(Freq,MKBSDRowid))
				s num=num+1
				s mainStr = mainStr_"{""MKBSDDiag"":"""_MKBSDDiag_""",""Freq"":"""_Freq_"""}"_","
			}
			elseif (Freq'=0)
			{
				s othernum=othernum+Freq
			}
		}
	}
	s mainStr=mainStr_"{""MKBSDDiag"":""其他"",""Freq"":"""_othernum_"""}"
	w mainStr
	w "]}"
	k ^FXK
	q ""
}

/*ClassMethod NewDiagCenterWordPct(centerid, ds, datatype)
{
	if (datatype="全部")
	{
		s datatype =""
	}
	s MKBSDRowid = 0
	s totalid = 0
	s num=0
	s othernum = 0
	s mainStr = ""
	w "{""rows"":["
	s Freq=10000000000
	for
	{
		s MKBSDRowid = $o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)     //诊断名
		s MKBSDCenterWordID = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		s MKBSDBaseDr = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22) 
		s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)  //频次  
		s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)  //诊断类型      
		s length = $l(MKBSDCenterWordID ,",")
		s name = MKBSDCenterWordID
		for i=1:1:length
		{   
		    s MKBSDCenterWordID=$p(name,",",i)
			if (MKBSDCenterWordID=centerid)&(MKBSDTotalFreq'=0)&(MKBSDBaseDr=ds)&(MKBSDDiaSource[datatype)
			{
				s ^FXK(MKBSDTotalFreq,MKBSDRowid)=MKBSDDiag     // =total
			}
		}
	}
	for
	{
		s Freq = $o(^FXK(Freq),-1)
		q:Freq=""
		for
		{
			s MKBSDRowid = $o(^FXK(Freq,MKBSDRowid))
			q:MKBSDRowid=""
			if (num<8)
			{
				s MKBSDDiag=$g(^FXK(Freq,MKBSDRowid))
				s num=num+1
				s mainStr = mainStr_"{""MKBSDDiag"":"""_MKBSDDiag_""",""Freq"":"""_Freq_"""}"_","
			}
			elseif (Freq'=0)
			{
				s othernum=othernum+Freq
			}
		}
	}
	s mainStr=mainStr_"{""MKBSDDiag"":""其他"",""Freq"":"""_othernum_"""}"
	w mainStr
	w "]}"
	k ^FXK
	q ""
}*/
/// Creator:范文凯   
/// CreatDate:2019-08-28
/// Description：查看版本我们这边传MKBVDataFlag 和 MKBVDataID 这两个参数过去，弹窗里要显示版本列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetMKBVersion","D",2)
Query GetMKBVersion(dataflag, dataid) As %Query(ROWSPEC = "MKBTDesc")
{
}

ClassMethod GetMKBVersionExecute(ByRef qHandle As %Binary, dataflag, dataid) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $o(^User.MKBVersionI("DataVersionIdx",dataflag,dataid,MKBTRowId))
		q:MKBTRowId=""
		s MKBTDesc = $lg($g(^User.MKBTermD(MKBTRowId)),3)
		d OutputRow8
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBTDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMKBVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetMKBVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMKBVersionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯   
/// CreatDate:2019-08-28
/// Description：查看日志我们这边传ClassName和ObjectReference 这两个参数过去。弹窗里显示相关的日志列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","DataChangeLog","User.MKBVersion","1")
Query DataChangeLog(classname, obj) As %Query(ROWSPEC = "ID, ClassName, ClassNameDesc, IpAddress, NewValue, ObjectDesc, ObjectReference, OldValue, OperateType, RelevantKey, TableName, UpdateDate, UpdateHospital, UpdateLoc, UpdateTime, UpdateUserName")
{
}

ClassMethod DataChangeLogExecute(ByRef qHandle As %Binary, classname, obj) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ID = 0
	for
	{   s ID =$o(^User.MKBDataChangeLogI("ObjectReferIndex",classname,obj,ID))
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
		d OutputRow8
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
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

/// CreateDate: 2019-08-29
/// Function:　mkbdatachangelog数据生命周期 生成一个时间轴 
/// Creator:   范文凯
/// d ##class(web.DHCBL.MKB.MKBEChartsInterface).ProduceTimeLine("User.BDPMenu","2140","获取版本测试","")
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
     s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
     s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
     s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
     s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
     s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
     s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
     s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
     s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
     s UpdateDate=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateDate)
     s UpdateTime=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateTime)
     s OperateType=##class(web.DHCBL.BDP.FunLib).EvalJSON(OperateType)
     s IpAddress=##class(web.DHCBL.BDP.FunLib).EvalJSON(IpAddress)
     s UpdateHospital = ##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateHospital)
     
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
       s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
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
          s:TableNewValue="" TableNewValue=NewValue1
          s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
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
          s TableNewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableNewValue) 
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

/// Function:查看数据明细
/// Creator:  范文凯
/// CreateDate: 2019-08-29
/// Debug:  d ##class(web.DHCBL.MKB.MKBEChartsInterface).ProductTable("")
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
     s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue) 
     s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue) 
     s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
     s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
     s:ClassName="User.ArcItmMast" ClassName="User.ARCItmMast"
     if (ClassName["^") s ClassName= $p(ClassName,"(",1) 
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
       s oldlen=$l(OldValue1,",")
       s newlen=$l(NewValue1,",")
  
       for j=1:1:oldlen 
       { 
         s PropertyChinese=""
         s oldstr=$p(OldValue1,",",j)
         s newstr=$p(NewValue1,",",j)  
         s Property=$p(oldstr,":",1)
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

/// 学习编写导入方法
/// Creator:李得原
/// CreatDate:2019-01-16
/// Description:ICD诊断匹配到的中心词记录
/// Table:
/// Input:
/// Return:匹配结果
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).DataMatch()
ClassMethod DataMatch() As %String
{
	k ^TempTermData
	set m=0
	set p=0
	s ICDRowid=0
	for
	{
		s ICDRowid=$o(^MRC("ID",ICDRowid))
		q:ICDRowid=""
		s Diag=$p($g(^MRC("ID",ICDRowid)),"^",2)
		s Diag=$Zstrip(Diag,"<>W")
		s Diag=$Replace(Diag,")","）")
		s Diag=$Replace(Diag,"(","（")
		s Diag=$Replace(Diag,",","，")

		set MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
		s MKBTRowid = 0
		for
		{
			set MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
			quit:MKBTRowid="" 
			set TermData=$lg($g(^User.MKBTermD(MKBTRowid)),3)  ;获取中心词
			
			if Diag[TermData
			{
				s ^TempTermData(Diag,MKBTRowid)=""     ;存储中心词rowid
			}
			else
			{
				set AliasItem=""
				;获取未匹配到的中心词的别名
				s AliasNum=0
				set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
				set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
				set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
				for i=1:1:AliasNum
				{
					set AliasItem=$p(TermDataAlias,",",i)
					if Diag[AliasItem
					{
						s ^TempTermData(Diag,MKBTRowid)=""

					}
				}
			}
			
		}
	} 
	quit "完成"
}

/// 编写数据导入
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportLData("D:\YDYSJ\锦江院区生殖男科.csv","7")
ClassMethod ImportLData(path As %String, basedr As %String)
{
	;s basedr = 3
	s result = ""
	s res = ""
	s sc=0
	s sc1=0
	s stop = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\YDYtestL1.csv")
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                          //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		// s Icd = $p(str,",",3) 
		// s IcdDesc=$p(str,",",4)
		s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		// s Icd =$Zstrip(Icd,"<>W") 
		// s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		/*s IcdDesc=$Replace(IcdDesc,")","）")
		s IcdDesc=$Replace(IcdDesc,"(","（")
		s IcdDesc=$Replace(IcdDesc,",","，")*/
		
		/*
		k ^TmpIcd                                     //临时global 用于存一行中的多个icd编码
		do
		{
			s n = $LOCATE(Icd,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcd(Icd)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICD = $e(Icd,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcd(ICD)=""
				s Icd = $e(Icd,n+1,*-0)
			}
			
		}while(n'=0)
		
		
		
		k ^TmpIcdDesc                                    //临时global 用于存一行中的多个icd描述
		do
		{
			s n = $LOCATE(IcdDesc,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcdDesc(IcdDesc)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICDDesc = $e(IcdDesc,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcdDesc(ICDDesc)=""
				s IcdDesc = $e(IcdDesc,n+1,*-0)
			}
			
		}while(n'=0)
		
		
		*/
		//取diag
		k ^Tmpdiag                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(diag,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^Tmpdiag(diag)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s Diag = $e(diag,0,n-1)                       //返回值不为0，取出相应的位置
				s ^Tmpdiag(Diag)=""
				s diag = $e(diag,n+1,*-0)
			}
			
		}while(n'=0)
		s diagi=0
		//s icd=0                                           //用于对^Tmpdiag 的循环 
		//s icddesc = 0
		for
		{
			s diagi = $o(^Tmpdiag(diagi))
			//s icd = $o(^TmpIcd(icd))
			//s icddesc = $o(^TmpIcdDesc(icddesc))
			q:diagi=""
			s Diagi = $e(diagi,4,*-0)                         //对诊断进行处理， 去掉"1. "的部分 
			//s icdi = $e(icd,4,*-0) 
			//s icddesci =  $e(icddesc,4,*-0)   
			;s Diagi = $Zstrip(Diagi,"<>W")
			s Diagi = $tr(Diagi," ","")
			//s icdi = $tr(icdi," ","")
			//s icddesci =$tr(icddesci," ","")
			/*if (icdi="无")
			{
			   s icdi = ""
			}
			if (icddesci="无")
			{
			   s icddesci = ""
			}*/
			if (Diagi="")
			{
				continue
			}
			s diagindex =" "_Diagi                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = Diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "出院"
			   // s obj.MKBSDICD = icdi
			   // s obj.MKBSDICDDesc = icddesci
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			  /*  s res =..AutoProcessingStructData(Diagi,id,icddesci,basedr)    //通过数据处理工厂已处理的进行自动结构化
			    if (res="true")
			    {
				   s snobj =##class(User.MKBStructuredData).%OpenId(id)
				   s snobj.MKBSDChildStructFlag = 1
				   s fwk = snobj.%Save()
				}*/
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	;s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "L"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
					   
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	//b 
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	//b 
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    w diagindex,! 
					    w loc,! 
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="L"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			}
		}		
	}
	//b
	if (stop=0)
	{
		
		s result ="导入成功"
	}
	else
	{
	
		s result ="导入失败"
	}
	q result
}

/// 诊断中心词CenterWord
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewDataMatch()
ClassMethod NewDataMatch()
{
	k ^TempFWK
	set m=0
	set p=0
	s num=0
	s Diagid = 0
	for
	{
		s Diagid =$o(^TempDiagXh0413(Diagid))
		q:Diagid=""
		s Diag = ^TempDiagXh0413(Diagid) 
		;s rowid = $o(User.MKBStructuredDataI("MKBSDDiagIndex",2,Diag,0))	
		s Diag=$Zstrip(Diag,"<>W")
		s Diag=$Replace(Diag,")","）")
		s Diag=$Replace(Diag,"(","（")
		s Diag=$Replace(Diag,",","，")
		set MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
		s MKBTRowid = 0
		for
		{
			set MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
			quit:MKBTRowid="" 
			set TermData=$lg($g(^User.MKBTermD(MKBTRowid)),3)  ;获取中心词
			
			if (Diag[TermData)
			{
				s ^TempFWK(Diagid,MKBTRowid)=""     ;存储中心词rowid
			}
			else
			{
				set AliasItem=""
				;获取未匹配到的中心词的别名
				s AliasNum=0
				set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
				set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
				set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
				for i=1:1:AliasNum
				{
					set AliasItem=$p(TermDataAlias,",",i)
					if Diag[AliasItem
					{
						s ^TempFWK(Diagid,MKBTRowid)=""

					}
				}
			}
			
		}
		;w "1111"
	} 
	quit "完成"
}

/// 诊断中心词写入
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).WCenterWord()
ClassMethod WCenterWord()
{
	s Diagid =0
	for
	{
		s Diagid = $o(^TempFWK(Diagid))
		q:Diagid=""
		Ts
		s obj =##class(User.MKBStructuredData).%OpenId(Diagid)
		s MKBTRowid = 0
		s result = ""
		for
		{
			s MKBTRowid = $o(^TempFWK(Diagid,MKBTRowid)) 
			q:MKBTRowid=""
			s result = result_MKBTRowid_","
		}
		s result=$Zstrip(result,"<>W")
		s result = $e(result,0,*-1)
		s obj.MKBSDCenterWordID = result
		s sc = obj.%Save()
		if (sc=1)
		{
			Tc
		}
		else
		{
			Tro
		}
	}
	q "导入完成"
}

/// 新的导入门急诊
ClassMethod NewImportOData(path As %String, basedr As %String)
{
	;s basedr = 2                                                         //修改医院指向
	s result = ""
	s sc=0
	s sc1=0
	s stop = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\XHdataO04.13.csv")             //修改文件路径
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                          //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		s Icd = $p(str,",",3) 
		s IcdDesc=$p(str,",",4)
		s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		s Icd =$Zstrip(Icd,"<>W") 
		s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		s Icd=$Replace(Icd,")","）")
		s Icd=$Replace(Icd,"(","（")
		s Icd=$Replace(Icd,",","，")
		s IcdDesc=$Replace(IcdDesc,")","）")
		s IcdDesc=$Replace(IcdDesc,"(","（")
		s IcdDesc=$Replace(IcdDesc,",","，")
		
		
		k ^TmpIcd                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(Icd,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcd(Icd)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICD = $e(Icd,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcd(ICD)=""
				s Icd = $e(Icd,n+1,*-0)
			}
			
		}while(n'=0)
		
		k ^TmpIcdDesc                                    //临时global 用于存一行中的多个icd描述
		do
		{
			s n = $LOCATE(IcdDesc,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcdDesc(IcdDesc)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICDDesc = $e(IcdDesc,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcdDesc(ICDDesc)=""
				s IcdDesc = $e(IcdDesc,n+1,*-0)
			}
			
		}while(n'=0)
		
		
		//取diag
		k ^Tmpdiag                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(diag,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^Tmpdiag(diag)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s Diag = $e(diag,0,n-1)                       //返回值不为0，取出相应的位置
				s Diag = $Zstrip(Diag,"<>W")
				s ^Tmpdiag(Diag)=""
				s diag = $e(diag,n+1,*-0)
			}
			
		}while(n'=0)
		s diagi =0                                           //用于对^Tmpdiag 的循环 
		s icd=0  
		s icddesc = 0
		for
		{
			s diagi = $o(^Tmpdiag(diagi))
			s icd = $o(^TmpIcd(icd))
			s icddesc = $o(^TmpIcdDesc(icddesc))
			q:diagi=""
			s Diagi = $e(diagi,4,*-0)                         //对诊断进行处理， 去掉"1. "的部分 
			s icdi = $e(icd,4,*-0)   
			s icddesci =  $e(icddesc,4,*-0)  
			;s Diagi = $Zstrip(Diagi,"<>W")
			s Diagi = $tr(Diagi," ","")
			s icdi = $tr(icdi," ","")
			s icddesci =$tr(icddesci," ","")
			
			if (icdi="无")
			{
			   s icdi = ""
			}
			if (icddesci="无")
			{
			   s icddesci = ""
			}
			if (Diagi="")
			{
				continue
			}
			s diagindex =" "_Diagi                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = Diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "门急诊"
			    s obj.MKBSDICD = icdi
			    s obj.MKBSDICDDesc = icddesci
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			    s res =..AutoProcessingStructData(Diagi,id,icddesci,basedr)    //通过数据处理工厂已处理的进行自动结构化
			    if (res="true")
			    {
				   s snobj =##class(User.MKBStructuredData).%OpenId(id)
				   s snobj.MKBSDChildStructFlag = 1
				   s fwk = snobj.%Save()
				}
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "O"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s DiagSource = obj.MKBSDDiaSource
			    if (DiagSource'["门急诊")
			    {
				    s DiagSource = DiagSource_"&门急诊"
				    s obj.MKBSDDiaSource = DiagSource
				}
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="O"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			}
		}		
	}
	if (stop=0)
	{
		//TC  
		s result ="导入成功"
	}
	else
	{
		//Trollback
		s result ="导入失败"
	}
	q result
}

/// 编写数据导入   协和门急诊数据导入
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportOData()
ClassMethod ImportOData()
{
	s basedr = 2
	s result = ""
	s sc=0
	s sc1=0
	s stop = 0
	Ts 
	s file=##class(%File).%New("D:\协和测试\XHdataO04.13.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if str=""
		{
			q
		}
		s loc = $p(str,",",1)
		s diag =$p(str,",",2)
		s loc = $Zstrip(loc,"<>W")
		s diag = $Zstrip(diag,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		s diagnum = $l(diag,";")
		for i=1:1:diagnum
		{   
			s diagi = $p(diag,";",i)
			s diagi = $e(diagi,4,*-0)    //诊断拿到了  
			s diagi = $Zstrip(diagi,"<>W")
			if (diagi="")
			{
				continue
			}
			s diagindex =" "_diagi           //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",2,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "门急诊"
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()                                      //父表保存成功后，操作子表
			    if (sc=1) 
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",2,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "O"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        s ^TempDiagXh0413(id)=diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",2,diagindex,0))    //取到该诊断的id
				s obj=##class(User.MKBStructuredData).%OpenId(id)                      //打开该诊断的对象
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1                                        //该诊断频次+1
			    s DiagSource = obj.MKBSDDiaSource
			    if (DiagSource'["门急诊")
			    {
				    s DiagSource = DiagSource_"&门急诊"
				    s obj.MKBSDDiaSource = DiagSource
				}
			    s sc=obj.%Save()                                                       //父表操作完成，开始操作子表
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                                              //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="O"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			}	
		}
	}
	if (stop=0)
	{
		TC  
		s result ="导入成功"
	}
	else
	{
		Trollback
		s result ="导入失败"
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-08-02
/// Description：数据处理工厂上传数据时候自动结构化
/// Table：User.MKBStructuredData
/// Input：父表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).AutoProcessingStructData()
ClassMethod AutoProcessingStructData(desc As %String, rowid As %String, icddesc As %String, basedr As %String) As %String
{
	s result=""
	s desc=$zconvert(desc,"U")
	s AnzhenBasedr=$o(^User.MKBStructuredBaseI("DescIndex"," 安贞数据处理工厂",0))
	s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",AnzhenBasedr," "_desc,0))
	if MKBSDRowid'=""
	{
		if $d(^User.MKBStructuredDataI("StructIndex",1,MKBSDRowid))
		{
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSequence=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
				s MKBRTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s MKBRResult=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s sobj=##class(User.MKBStructuredDataResult).%New(rowid)
				d sobj.MKBSDStructDataSetObjectId(rowid)
				s sobj.MKBSDSequence=MKBSequence
				s sobj.MKBSDStructResultID=MKBRResult
				d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
				s ssc=sobj.%Save()
				d sobj.%Close()
				if $$$ISERR(ssc)
				{
					s result=$system.OBJ.DisplayError(ssc)
				}
				else
				{
					s result="true"
				}
			}
		}
	}
	if (icddesc'="")&&($d(^TempAZicddesc(icddesc_"Best")))&&(result'="true")
	{
		s MKBSDRowid = ^TempAZicddesc(icddesc_"Best")
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSequence=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
			s MKBRTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBRResult=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s sobj=##class(User.MKBStructuredDataResult).%New(rowid)
			d sobj.MKBSDStructDataSetObjectId(rowid)
			s sobj.MKBSDSequence=MKBSequence
			s sobj.MKBSDStructResultID=MKBRResult
			d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
			s ssc=sobj.%Save()
			d sobj.%Close()
			if $$$ISERR(ssc)
			{
				s result=$system.OBJ.DisplayError(ssc)
			}
			else
			{
				s result="true"
			}
		}
	}
	elseif (icddesc'="")&&($d(^TempAZicddesc(icddesc)))&&(result'="true")
	{
		s MKBSDRowid = ^TempAZicddesc(icddesc)
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSequence=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
			s MKBRTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBRResult=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s sobj=##class(User.MKBStructuredDataResult).%New(rowid)
			d sobj.MKBSDStructDataSetObjectId(rowid)
			s sobj.MKBSDSequence=MKBSequence
			s sobj.MKBSDStructResultID=MKBRResult
			d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
			s ssc=sobj.%Save()
			d sobj.%Close()
			if $$$ISERR(ssc)
			{
				s result=$system.OBJ.DisplayError(ssc)
			}
			else
			{
				s result="true"
			}
		}
	}
	q result
}

/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportCDSSData()
ClassMethod ImportCDSSData()
{
	s result = ""
	s basedr = $o(^User.MKBTermBaseI("DescIndex"," 诊断因子字典表",0))             //获得MKB_TermBase诊断因子字典表的
	Ts 
	s file=##class(%File).%New("D:\协和测试\诊断因子表测试表.csv")               //获取csv文件
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str =file.ReadLine()
		s num = $l(str,"、")
		for i=1:1:num
		{
			s symptom = $p(str,"、",i)
			s symptom = $tr(symptom," ","")                                      //去除空格
			s Desc = 0
			s Flag = 1                                                       //是否存在的标志  1.不存在 0.已经存在
			for
			{
				s Desc = $o(^User.MKBTermI("DescIndex",basedr,""_Desc)) //判断中心词是否已经存在
				q:Desc=""
				if (symptom=Desc)
				{
					s Flag = 0
				}
			}
			if (Flag=1)                                           //如果不存在，新建对象 导入
			{
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTDesc = symptom
				d obj.MKBTBaseDRSetObjectId(basedr)
				s SymptomPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(symptom)
				s obj.MKBTPYCode = SymptomPYCode
				s sc = ##class(web.DHCBL.MKB.MKBTerm).SaveData(obj)
				if (sc'=sce)
				{
					w sc
					b
				}
			}   

		}
	}
	if (sc=1)
	{
		Tc
		s result = "导入成功"
	}
	else
	{
		Tro 
		s result = "导入失败"
	}
	b
	q result
}

/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewImportCDSSData()
ClassMethod NewImportCDSSData()
{
	s result = ""
	s basedr = $o(^User.MKBTermBaseI("DescIndex"," 诊断因子字典表",0))             //获得MKB_TermBase诊断因子字典表的
	Ts 
	s file=##class(%File).%New("D:\协和测试\诊断因子表测试表.csv")               //获取csv文件
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str =file.ReadLine()
		if (str="")
		{
			continue
		}
		s num = $l(str,"、")
		for i=1:1:num
		{
			s symptom = $p(str,"、",i)
			s symptom = $tr(symptom," ","") 
			if (symptom="")
			{
				continue
			}
			s eobj=##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTRowId = ""
			s eobj.MKBTDesc =symptom
			s eobj.MKBTCode = ""
			s eobj.MKBTBaseDR = basedr
			s sc = ##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			if (sc["该记录已经存在")
			{
				continue
			}
		}
	}
	Tc
	q 1
}

/// 为了自动结构化匹配创建的临时global 
///  w ##class(web.DHCBL.MKB.MKBEChartsInterface).TempAZicd()
ClassMethod TempAZicd()
{
	s rowid = 0
	for
	{
		s rowid = $o(^User.MKBStructuredDataI("BaseIndex",1,rowid))
		q:rowid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(rowid)),14)
		s MKBSDICD = $lg($g(^User.MKBStructuredDataD(rowid)),20)
		if ((MKBSDChildStructFlag =1)&(MKBSDICD'=""))
		{
			s ^TempAZicd(MKBSDICD)=rowid
		}
	}
	q "成功"
}

/// 为了自动结构化匹配创建的临时global 
///  w ##class(web.DHCBL.MKB.MKBEChartsInterface).TempAZicddesc()
ClassMethod TempAZicddesc()
{
	k ^TempAZicddesc
	s num =0
	s rowid = 0
	s AnzhenBasedr=$o(^User.MKBStructuredBaseI("DescIndex"," 安贞数据处理工厂",0))
	;s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",AnzhenBasedr," "_desc,))
	for
	{
		s rowid = $o(^User.MKBStructuredDataI("BaseIndex",1,rowid))
		q:rowid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(rowid)),14)
		s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(rowid)),21)
		s MKBSDICDDesc=$zconvert(MKBSDICDDesc,"U")
		s MKBSDInitialICD = $lg($g(^User.MKBStructuredDataD(rowid)),18)             //是否为最优匹配
		if ((MKBSDChildStructFlag =1)&(MKBSDICDDesc'=""))
		{
			s ^TempAZicddesc(MKBSDICDDesc)=rowid
			s num = num+1
		}
		if ((MKBSDChildStructFlag =1)&(MKBSDICDDesc'="")&(MKBSDInitialICD="Y"))     //该结构化诊断为最优匹配
		{
			s ^TempAZicddesc(MKBSDICDDesc_"Best")=rowid
			continue
		}
		if ((MKBSDChildStructFlag =1)&(MKBSDICDDesc'="")&($d(^User.MKBStructuredDataI("MKBSDDiagIndex",AnzhenBasedr," "_MKBSDICDDesc))))   //icd描述是否有相同的诊断
		{
			s MKBSDRowid = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",AnzhenBasedr," "_MKBSDICDDesc,0))
			if $d(^User.MKBStructuredDataI("StructIndex",1,MKBSDRowid))
			{
				s ^TempAZicddesc(MKBSDICDDesc_"Best")=MKBSDRowid
			}
		}
	}
	q "成功"_num
}

/// 09.12 fwk
/// 导入疾病关联诊断因子表
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetFileData()
ClassMethod GetFileData()
{
	k ^TmpProDetail
	TS
	;s (SaveSum,NoNationSum,NoPekingSum)=0                                      //初始化计数器，保存了多少条，国家的和北京的不匹配的多少条
	
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 疾病关联诊断因子表",0))       //获得规则管理注册id
	
	s ZDYZZDBBase=$o(^User.MKBTermBaseI("DescIndex"," 诊断因子字典表",0))                //获得诊断字典表id  
	
	s JBZDBBase=$o(^User.MKBTermBaseI("DescIndex"," 疾病字典表",0))               //获取疾病字段表的id
	
	s desc = 0 
	
	//疾病字典表的ICD-10名称 全部放入临时golobal中  用于 和诊断字典表中的 疾病名称比较
	for 
	{
		s desc = $o(^User.MKBTermI("DescIndex",JBZDBBase,desc))
		q:desc=""
		s TermRowID=$o(^User.MKBTermI("DescIndex",JBZDBBase,desc,0))  //通过中心词找到对应术语id
		s propertyID = $o(^User.MKBTermPropertyI("DescIndex",TermRowID," ICD-10名称",0))  //取得ICD-10属性的id
	    s prodetailID = $o(^User.MKBTermProDetailI("ProIdx",propertyID,0))
	    s prodetail = $lg($g(^User.MKBTermProDetailD(prodetailID)),3)
		s ^TmpProDetail(prodetail) = TermRowID
	}
	
	
	
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 疾病关联诊断因子表",0)) 
	s MKBKLMFNRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 疾病",0))    //获取列的id
	s MKBKLMFPRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 诊断因子",0))  
	
	s file=##class(%File).%New("E:\疾病关联诊断因子test.csv")      //读取疾病诊断因子表
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Line=##class(web.DHCBL.BDP.FunLib).EvalJSON(Line)
		s diseasename = $p(Line,",",1)                     //读取疾病名字段
		s diseasename=$tr(diseasename," ","")          //对字段进行特殊符号处理
		s Flag = 0
		
		//判断 ^TmpProDetail 中是否存在 该疾病 
		
		if ($d(^TmpProDetail(diseasename)))
		{
			s JBRowID = ^TmpProDetail(diseasename)         //关系表的 疾病诊断id  
			s sysmptom = $p(Line,",",2)                    //读取诊断因子 
			s num = $l(sysmptom,"、")
			for i=1:1:num
			{
				s sysmptomname = $p(sysmptom,"、",i)        //取出诊断因子
				s sysmptomname = $tr(sysmptomname," ","")   //空格处理
				s ZDYZRowid = $o(^User.MKBTermI("DescIndex",ZDYZZDBBase," "_sysmptomname,0))     //关系表的 诊断因子id
				continue:ZDYZRowid="" 
				
				
				;s fieldValueStr=JBRowID_"[A]"_ZDYZRowid
				s fieldValueStr=MKBKLMFNRowid_"[A]"_JBRowID_"[N]"_MKBKLMFPRowid_"[A]"_ZDYZRowid 
				s Result= ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBKLMBRowid,fieldValueStr)	
				;s SaveSum=SaveSum+1
				if Result["该记录已经存在"
				{
					continue
				}
				elseif((Result["false")&(Result'["该记录已经存在"))
				{
					b
				}	
			}
		}
	}
	q "成功"
}

/// 导入疾病关联诊断表   疾病详述表相关字段
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportJBXSB()
ClassMethod ImportJBXSB()
{
	Ts
	s count = 0
	s file=##class(%File).%New("D:\疾病详述表.csv")      //读取疾病诊断因子表
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Line=##class(web.DHCBL.BDP.FunLib).Util(Line)
		s diseasename = $p(Line,",",5)                     //读取疾病名字段
		s diseasename=##class(web.DHCBL.BDP.FunLib).Util(diseasename)         //对字段进行特殊符号处理
		s Flag = 0
		
		//判断 ^TmpProDetail 中是否存在 该疾病 
		if ($d(^TmpProDetail(diseasename)))
		{
			s PropertyDetail = $p(Line,",",7) 
			continue:PropertyDetail=""
        	s PropertyDetail=##class(web.DHCBL.BDP.FunLib).Util(PropertyDetail)
			s JBRowID = ^TmpProDetail(diseasename)         //关系表的 疾病诊断id  
			s MKBTPRowId = $o(^User.MKBTermPropertyI("DescIndex",JBRowID," 疾病关联辅助检查检验表",0))
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
        	s eobj.MKBTPDDesc=PropertyDetail
        	s eobj.MKBTPDProDR=MKBTPRowId
        	s Result= ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			s sc=Result["success"
       		s count=count+1
        	if $$$ISOK(sc)
			{
			
			}
			else
			{
			
			}
		}	
	}
	w "导入数据总条数："_count,!
	q "成功"
}

/// 编写数据导入 导入协和诊断数据 
/// 添加了 icd描述字段
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportXHLData("D:\YDYSJ\小儿消化.csv","7")
ClassMethod ImportXHLData(path, basedr)
{
	;s basedr = 3
	s result = ""
	s res = ""
	s sc=0
	s sc1=0
	s stop = 0
	s num = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\YDYtestL1.csv")
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                          //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		s Icd = $p(str,",",3) 
		s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		s Icd =$Zstrip(Icd,"<>W") 
		;s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		;s IcdDesc=diag
		;s IcdDesc=$Replace(IcdDesc,")","）")
		;s IcdDesc=$Replace(IcdDesc,"(","（")
		;s IcdDesc=$Replace(IcdDesc,",","，")
		
		
		k ^TmpIcd                                     //临时global 用于存一行中的多个icd编码
		do
		{
			s n = $LOCATE(Icd,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcd(Icd)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICD = $e(Icd,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcd(ICD)=""
				s Icd = $e(Icd,n+1,*-0)
			}
			
		}while(n'=0)
		
		
		/*
		k ^TmpIcdDesc                                    //临时global 用于存一行中的多个icd描述
		do
		{
			s n = $LOCATE(IcdDesc,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s IcdDesc = $p(IcdDesc,"[",1)
				s ^TmpIcdDesc(IcdDesc)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s IcdDesc = $e(IcdDesc,0,n-1)                       //返回值不为0，取出相应的位置
				s ICDDesc = $p(IcdDesc,"[",1)
				s ^TmpIcdDesc(ICDDesc)=""
				s IcdDesc = $e(IcdDesc,n+1,*-0)
			}
			
		}while(n'=0)
		
		*/
		
		//取diag
		k ^Tmpdiag                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(diag,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^Tmpdiag(diag)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s Diag = $e(diag,0,n-1)                       //返回值不为0，取出相应的位置
				s ^Tmpdiag(Diag)=""
				s diag = $e(diag,n+1,*-0)
			}
			
		}while(n'=0)
		s diagi=0
		s icd=0                                           //用于对^Tmpdiag 的循环 
		;s icddesc = 0
		for
		{
			s diagi = $o(^Tmpdiag(diagi))
			q:diagi=""
			s icd = $o(^TmpIcd(icd))
			;s icddesc = $o(^TmpIcdDesc(icddesc))
			//	
			
			s Diagi = $e(diagi,4,*-0)                         //对诊断进行处理， 去掉"1. "的部分 
			s icdi = $e(icd,4,*-0) 
			;s icddesci =  $e(icddesc,4,*-0)   
			;s Diagi = $Zstrip(Diagi,"<>W")
			s Diagi = $tr(Diagi," ","")
			s icdi = $tr(icdi," ","")
			;s icddesci =$tr(icddesci," ","")
			s icddesci =Diagi
			
			if (icdi["无")
			{
				s icddesci = icdi
			}
			if ($d(^TempAZicddesc(icddesci)))
			{
	
			}
			else
			{
				s icddesci = $p(icddesci,"[",1)
			}
			
			if (icdi="无")
			{
			   s icdi = ""
			}
			if (icddesci="无")
			{
			   s icddesci = ""
			}
			if (Diagi="")
			{
				continue
			}
			s diagindex =" "_Diagi                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = Diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "出院"
			    s obj.MKBSDICD = icdi
			    s obj.MKBSDICDDesc = icddesci
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			    s res =..AutoProcessingStructData(Diagi,id,icddesci,basedr)    //通过数据处理工厂已处理的进行自动结构化
			    if (res="true")
			    {
				   s snobj =##class(User.MKBStructuredData).%OpenId(id)
				   s snobj.MKBSDChildStructFlag = 1
				   s fwk = snobj.%Save()
				}
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	;s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "L"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="L"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			}
		}		
	}
	b
	if (stop=0)
	{
		//TC  
		s result ="导入成功"
	}
	else
	{
		Trollback
		s result ="导入失败"
	}
	q result
}

/// 09.19  协和门急诊数据导入   增加icd描述 
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewImportXHOData("D:\YDYSJ\华西门急诊02.csv","7")
ClassMethod NewImportXHOData(path, basedr)
{
	;s basedr = 2                                                         //修改医院指向
	s result = ""
	s sc=0
	s sc1=0
	s stop = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\XHdataO04.13.csv")             //修改文件路径
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                          //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		s Icd = $p(str,",",3) 
		;s IcdDesc=$p(str,",",4)
		s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		s Icd =$Zstrip(Icd,"<>W") 
		;s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		s Icd=$Replace(Icd,")","）")
		s Icd=$Replace(Icd,"(","（")
		s Icd=$Replace(Icd,",","，")
		;s IcdDesc=$Replace(IcdDesc,")","）")
		;s IcdDesc=$Replace(IcdDesc,"(","（")
		;s IcdDesc=$Replace(IcdDesc,",","，")
		
		
		k ^TmpIcd                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(Icd,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcd(Icd)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICD = $e(Icd,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcd(ICD)=""
				s Icd = $e(Icd,n+1,*-0)
			}
			
		}while(n'=0)
		
		/*
		k ^TmpIcdDesc                                    //临时global 用于存一行中的多个icd描述
		do
		{
			s n = $LOCATE(IcdDesc,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^TmpIcdDesc(IcdDesc)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s ICDDesc = $e(IcdDesc,0,n-1)                       //返回值不为0，取出相应的位置
				s ^TmpIcdDesc(ICDDesc)=""
				s IcdDesc = $e(IcdDesc,n+1,*-0)
			}
			
		}while(n'=0)
		*/
		
		
		//取diag
		k ^Tmpdiag                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(diag,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^Tmpdiag(diag)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s Diag = $e(diag,0,n-1)                       //返回值不为0，取出相应的位置
				s Diag = $Zstrip(Diag,"<>W")
				s ^Tmpdiag(Diag)=""
				s diag = $e(diag,n+1,*-0)
			}
			
		}while(n'=0)
		s diagi =0                                           //用于对^Tmpdiag 的循环 
		s icd=0  
		;s icddesc = 0
		for
		{
			s diagi = $o(^Tmpdiag(diagi))
			q:diagi=""
			s icd = $o(^TmpIcd(icd))
			;s icddesc = $o(^TmpIcdDesc(icddesc))
			//	
			
			s Diagi = $e(diagi,4,*-0)                         //对诊断进行处理， 去掉"1. "的部分 
			s icdi = $e(icd,4,*-0) 
			;s icddesci =  $e(icddesc,4,*-0)   
			;s Diagi = $Zstrip(Diagi,"<>W")
			s Diagi = $tr(Diagi," ","")
			s icdi = $tr(icdi," ","")
			;s icddesci =$tr(icddesci," ","")
			s icddesci =Diagi
			
			if (icdi["无")
			{
				s icddesci = icdi
			}
			
			if $d(^TempAZicddesc(icddesci))
			{
				if icddesci["["
				{
					w icddesci
					w !
				}
			}
			else
			{
				s icddesci = $p(icddesci,"[",1)
			}
			
			if (icdi="无")
			{
			   s icdi = ""
			}
			if (icddesci="无")
			{
			   s icddesci = ""
			}
			if (Diagi="")
			{
				continue
			}
			s diagindex =" "_Diagi                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = Diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "门急诊"
			    s obj.MKBSDICD = icdi
			    s obj.MKBSDICDDesc = icddesci
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			    s res =..AutoProcessingStructData(Diagi,id,icddesci,basedr)    //通过数据处理工厂已处理的进行自动结构化
			    if (res="true")
			    {
				   s snobj =##class(User.MKBStructuredData).%OpenId(id)
				   s snobj.MKBSDChildStructFlag = 1
				   s fwk = snobj.%Save()
				}
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "O"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s DiagSource = obj.MKBSDDiaSource
			    if (DiagSource'["门急诊")
			    {
				    s DiagSource = DiagSource_"&门急诊"
				    s obj.MKBSDDiaSource = DiagSource
				}
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="O"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			}
		}		
	}
	if (stop=0)
	{
		TC  
		s result ="导入成功"
	}
	else
	{
		Trollback
		s result ="导入失败"
	}
	q result
}

/// Creator：范文凯
/// CreatDate:2019-09-30
/// Description：数据处理工厂未结构化匹配的数据和各版本icd对照的数据进行匹配
/// Table：User.MKBStructuredData
/// Input：数据处理工厂termbaseid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewAutoProcessingStructData(2)
ClassMethod NewAutoProcessingStructData(termbaseid)
{
	TS
	s num = 0
	s dataid = 0
	for 
	{
		s dataid = $o(^User.MKBStructuredDataI("BaseIndex",termbaseid,dataid))
		q:dataid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(dataid)),14)
		continue:MKBSDChildStructFlag=1
		s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)
		continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc))
		s rowid=0
		for
		{
			s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc,rowid))
			q:rowid=""
			s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
			continue:MKBICDChildStructFlag'=1
			q:MKBICDChildStructFlag=1
		}
		s childsub = 0
		continue:rowid=""
		for
		{
			s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
			q:childsub=""
			s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
			s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
			s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
			s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
			d sobj.MKBSDStructDataSetObjectId(dataid)
			s sobj.MKBSDSequence=MKBSequence
			s sobj.MKBSDStructResultID=MKBRResult
			d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
			s ssc=sobj.%Save()
			d sobj.%Close()
			
			if $$$ISERR(ssc)
			{
				s result=$system.OBJ.DisplayError(ssc)
				Tro
			}
			else
			{
				s num=num+1
				s result="true"
				s snobj =##class(User.MKBStructuredData).%OpenId(dataid)
				s snobj.MKBSDChildStructFlag = 1
				s fwk = snobj.%Save()
				if $$$ISERR(fwk)
				{
					b
				}
				w num
				w !
			}
		}
		
	}
	q "成功匹配"_num_"条"
}

/// Creator:范文凯
/// CreatDate:2019-10-16
/// Description:导入临床实用手术引用术语类型数据
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportOperationRef("肝胆外科.csv")
ClassMethod ImportOperationRef(FileName As %String)
{
	k ^tmpopdata
	s result = ""
	s count = 1
	s basedr = $o(^User.MKBTermBaseI("DescIndex"," 北京临床-ICD9手术分类临床版",0))             //获得MKB_TermBase中北京临床-ICD9手术分类临床版的baseid
	s ZLSHid = $o(^User.MKBTermBaseI("DescIndex"," 治疗手术",0)) 
	Ts 
	s file=##class(%File).%New("D:\DataFile\全院手术对照\"_FileName)               //获取csv文件
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str =file.Read()
		s count=count+1
		s OpDesc = $p(str,",",6)
		s OpDesc=##class(web.DHCBL.BDP.FunLib).Util(OpDesc)       //我院手术名称 特殊符号处理
		s GJDesc = $p(str,",",3)
		s GJDesc=##class(web.DHCBL.BDP.FunLib).Util(GJDesc)       //国家名称  特殊符号处理
		continue:OpDesc=""
		continue:GJDesc=""
		s Termid = $o(^User.MKBTermI("DescIndex",ZLSHid," "_OpDesc,0))
		continue:Termid=""
		s BJTermid = $o(^User.MKBTermI("DescIndex",basedr," "_GJDesc,0))                       //获得要存进去的id   如果这个为空  说明没有对照上 要保存记录
		if (BJTermid="")
		{
			s Code = $p(str,",",2)  //获得编码
			s ^tmpopdata(count)=count_","_OpDesc_","_GJDesc_","_Code                                               //去执行生成csv文件    输出OpDESC 以及 GJDesc
			continue
		}
		s MKBTPRowId = $o(^User.MKBTermPropertyI("TermIndex",Termid," "),-1)              //获得属性的id 
		s obj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s obj.MKBTPDDesc = BJTermid
		s obj.MKBTPDProDR = MKBTPRowId
		s sc = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(obj)
		if (sc["false")
		{
			w sc
			//b
		}
	}
	if (sc["true")
	{
		s result = "导入成功"
	}
	else
	{
		//Tro 
		s result = "导入失败"
	}
	d ..NoMatchOpData(FileName)
	tc
	q result
}

/// 记录手术匹配北京版的过程中，那些手术没有匹配成功
/// 
ClassMethod NoMatchOpData(FileName As %String)
{
	s Path="D:\DataFile\NoMatch\"
	;行数，我院手术名称，国家名称，编码
		
	s file=##class(%File).%New(Path_"NotMatch"_FileName)
	d file.Open("NWS")
	d file.Write("行数"_",")
	d file.Write("我院手术名称"_",")
	d file.Write("国家名称"_",")
	d file.Write("编码")
	d file.WriteLine()
	s id = 0
	for
	{
		s id = $o(^tmpopdata(id))
		q:id=""
		d file.Write($g(^tmpopdata(id)))
		d file.WriteLine()
	}
}

/// 执行方法 导入剩余科室的手术数据
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).GoGoGo()
ClassMethod GoGoGo()
{
	ts
	d ..ImportOperationRef("产科.csv")                                                    
	d ..ImportOperationRef("耳鼻咽喉科.csv")                                    
	d ..ImportOperationRef("妇科.csv")                                          
	d ..ImportOperationRef("肝胆外科.csv")                                    
	d ..ImportOperationRef("肛肠外科.csv")                                     
	d ..ImportOperationRef("骨科.csv")                                         
	d ..ImportOperationRef("甲状腺烧伤.csv")          
	d ..ImportOperationRef("介入科.csv")                                         
	d ..ImportOperationRef("泌尿外科.csv")                                        
	d ..ImportOperationRef("皮肤科.csv")                                          
	d ..ImportOperationRef("乳腺外科.csv")                                       
	d ..ImportOperationRef("神经外科.csv")                                      
	d ..ImportOperationRef("疼痛科.csv")                                         
	d ..ImportOperationRef("胃肠疝外科.csv")           
	d ..ImportOperationRef("胃肠肿瘤外科.csv")    
	d ..ImportOperationRef("心脏外科.csv")                                      
	d ..ImportOperationRef("胸外科.csv")                                        
	d ..ImportOperationRef("血管甲状腺外科.csv")      
	d ..ImportOperationRef("眼科.csv")                                          
	d ..ImportOperationRef("胰胆外科.csv")
	d ..ImportOperationRef("运动医学.csv")                                     
	d ..ImportOperationRef("整形外科.csv")                                      
	q "yes"
}

/// 删掉错误导入的数据 治疗手术的病情描述下的属性
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).DeleteOpData()
ClassMethod DeleteOpData()
{
	TS
	s MKBTermId = 0
	s count=0
	for
	{
		s MKBTermId = $o(^User.MKBTermI("BaseIndex",20,MKBTermId))
		q:MKBTermId=""
		s MKBTPRowId = $o(^User.MKBTermPropertyI("TermIndex",MKBTermId," "),-1)
		s MKBTPDRowId = 0
		s num = 0 
		for
		{
			s MKBTPDRowId = $o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			s num=num+1
			continue:num=1
			q:MKBTPDRowId=""
			s result=##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)
			if (result["false")
			{
				b
			}
			else
			{
				s count = count+1
			}
		}	
	}
   q "yes,"_count
}

/// Creator:范文凯
/// CreatDate:2019-10-28
/// Description：获取开立诊断数据类型列表   返回符合医院的数据类型 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","DataType","1")
Query DataType(id As %String) As %Query(ROWSPEC = "MKBSTBSource")
{
}

ClassMethod DataTypeExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s MKBSTBSource = $lg($g(^User.MKBStructuredBaseD(id)),6)
 	d OutputRow8
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBSTBSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod DataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2019-10-28
/// Description：获取开立诊断数据类型列表   返回符合医院的数据类型 
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).GetDataType()
ClassMethod GetDataType(id As %String)
{
	s MKBSTBSource = $lg($g(^User.MKBStructuredBaseD(id)),6)
	q MKBSTBSource
}

/// Creator：范文凯
/// CreatDate:2020-04-28
/// Description：遍历数据处理工厂所有数据和各版本icd对照的数据进行匹配 修正后方法
/// Table：User.MKBStructuredData
/// Input：数据处理工厂termbaseid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewMatchICDContrast(3)
ClassMethod NewMatchICDContrast(termbaseid)
{
	TS
	s ICDTermBaseID = $o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	s ICDTermID = $o(^User.MKBTermI("DescIndex",ICDTermBaseID," 疾病分类与代码国家临床版2.0",0))
	s num = 0
	s dataid = 0
	for 
	{
		s dataid = $o(^User.MKBStructuredDataI("BaseIndex",termbaseid,dataid))         //遍历所有医大一的数据
		q:dataid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(dataid)),14)          //获得是否结构化匹配的标识Flag
		if (MKBSDChildStructFlag=1)                                                    //如果是已经匹配过的，删掉已有的，把新的存进去
		{
			s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			continue:'$d(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDICDDesc,"U")))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=0
			for
			{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDICDDesc,"U"),rowid))
				q:rowid=""
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				s MKBICDDiaSource = $lg($g(^User.MKBICDContrastD(rowid)),6)           //获取icd来源 判断是否是2.0  不是2.0则跳出
				if (MKBICDDiaSource'[ICDTermID)
				{ 
					continue
				}
				continue:MKBICDChildStructFlag'=1
				s childid = 0
				for
				{
					s childid = $o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",dataid,childid))
					q:childid=""
					s ID = dataid_"||"_childid
					s sc=##class(User.MKBStructuredDataResult).%DeleteId(ID)
					if $$$ISERR(sc)
					{
						b
					}
				}
				s childsub = 0
				for
				{
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s num=num+1
						s result="true"
						w num
						w !
					}
				}
			}
		}
		else
		{
			s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			continue:'$d(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDICDDesc,"U")))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=0
			for
			{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDICDDesc,"U"),rowid))
				q:rowid=""
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				s MKBICDDiaSource = $lg($g(^User.MKBICDContrastD(rowid)),6)           //获取icd来源 判断是否是2.0
				if (MKBICDDiaSource'[ICDTermID)
				{
					continue
				}
				continue:MKBICDChildStructFlag'=1
				s childsub = 0
				for
				{
				
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s num=num+1
						s result="true"
						w num
						w !
					}
					if (result="true")
					{
						s snobj =##class(User.MKBStructuredData).%OpenId(dataid)
						s snobj.MKBSDChildStructFlag = 1
						s fwk = snobj.%Save()
					}
					if $$$ISERR(fwk)
					{
						b
					}
				}
			}
		}	
	}
	b
	q "成功匹配"_num_"条"
}

/// Creator：范文凯
/// CreatDate:2019-10-29
/// Description：遍历数据处理工厂所有数据和各版本icd对照的数据进行匹配
/// Table：User.MKBStructuredData
/// Input：数据处理工厂termbaseid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).MatchICDContrast(3)
ClassMethod MatchICDContrast(termbaseid)
{
	TS
	s ICDTermBaseID = $o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	s ICDTermID = $o(^User.MKBTermI("DescIndex",ICDTermBaseID," 疾病分类与代码国家临床版2.0",0))
	s num = 0
	s dataid = 0
	for 
	{
		s dataid = $o(^User.MKBStructuredDataI("BaseIndex",termbaseid,dataid))         //遍历所有医大一的数据
		q:dataid=""
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(dataid)),14)          //获得是否结构化匹配的标识Flag
		if (MKBSDChildStructFlag=1)                                                    //如果是已经匹配过的，删掉已有的，把新的存进去
		{
			s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=""
			//for
			//{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc,rowid),-1)
				continue:rowid=""
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				continue:MKBICDChildStructFlag'=1
				s MKBICDResultRelation = $lg($g(^User.MKBICDContrastD(rowid)),19)
				s fwkobj = ##class(User.MKBStructuredData).%OpenId(dataid)
				s fwkobj.MKBSDResultRelation = MKBICDResultRelation 
				d fwkobj.%Save()
				d fwkobj.%Close()
				//删除掉已经匹配好的数据
				s childid = 0
				for
				{
					 s childid = $o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",dataid,childid))
					 q:childid=""
					 s ID = dataid_"||"_childid
					 s sc=##class(User.MKBStructuredDataResult).%DeleteId(ID)
					if $$$ISERR(sc)
					{
						b
					}
				}
				s childsub = 0
				for
				{
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s num=num+1
						s result="true"
						w num
						w !
					}
				}
			//}
		}
		else
		{
			s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=""
			//for
			//{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc,rowid),-1)
				continue:rowid=""
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				continue:MKBICDChildStructFlag'=1
				s MKBICDResultRelation = $lg($g(^User.MKBICDContrastD(rowid)),19)
				s fwkobj = ##class(User.MKBStructuredData).%OpenId(dataid)
				s fwkobj.MKBSDResultRelation = MKBICDResultRelation 
				d fwkobj.%Save()
				d fwkobj.%Close()
				s childsub = 0
				for
				{
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s num=num+1
						s result="true"
						w num
						w !
					}
					if (result="true")
					{
						s snobj =##class(User.MKBStructuredData).%OpenId(dataid)
						s snobj.MKBSDChildStructFlag = 1
						s fwk = snobj.%Save()
					}
					if $$$ISERR(fwk)
					{
						b
					}
				}
			//}
		}
		
	}
	b
	q "成功匹配"_num_"条"
}

/// Creator：范文凯
/// CreatDate:2019-10-29
/// Description：遍历数据处理工厂所有数据和各版本icd对照的数据进行匹配
/// Table：User.MKBStructuredData
/// Input：数据处理工厂termbaseid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).AZMatchICDContrast(1)
ClassMethod AZMatchICDContrast(termbaseid)
{
	TS
	s delnum = 0
	s modnum = 0
	s addnum = 0
	s dataid = 0
	for 
	{
		s dataid = $o(^User.MKBStructuredDataI("BaseIndex",termbaseid,dataid))         //遍历所有医大一的数据
		q:dataid=""
		s MKBSDDiag = $lg($g(^User.MKBStructuredDataD(dataid)),2)                      //获得安贞数据的诊断名
		//if (MKBSDDiag="慢性中耳炎")
		//{
			//b ;11;;
		//}
		continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDDiag))                 //判断该诊断名是否存在于各版本icd对照中 如果存在去执行更新操作，不存在则不执行更新操作
		s MKBSDChildStructFlag = $lg($g(^User.MKBStructuredDataD(dataid)),14)          //获得是否结构化匹配的标识Flag
		if (MKBSDChildStructFlag=1)                                                    //如果是已经匹配过的，删掉已有的，把新的存进去
		{
			//s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			//continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=0
			for
			{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_MKBSDDiag,rowid))
				q:rowid=""
				s icdbaseid = $lg($g(^User.MKBICDContrastD(rowid)),6) 
				continue:icdbaseid'["526477"
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				continue:MKBICDChildStructFlag'=1
				s MKBICDResultRelation = $lg($g(^User.MKBICDContrastD(rowid)),19)
				s fwkobj = ##class(User.MKBStructuredData).%OpenId(dataid)
				d fwkobj.MKBSDUpdateUserSetObjectId(6470)
				s fwkobj.MKBSDResultRelation = MKBICDResultRelation 
				d fwkobj.%Save()
				d fwkobj.%Close()
				//删除掉已经匹配好的数据
				s childid = 0
				for
				{
					 s childid = $o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",dataid,childid))
					 q:childid=""
					 s ID = dataid_"||"_childid
					 s sc=##class(User.MKBStructuredDataResult).%DeleteId(ID)
					if $$$ISOK(sc)
					{
						s delnum = delnum+1
					}
				}
				s childsub = 0
				for
				{
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s modnum=modnum+1
						s result="true"
					}
				}
			}
		}
		else
		{
			//s MKBSDICDDesc = $lg($g(^User.MKBStructuredDataD(dataid)),21)              //获得icd描述
			//continue:'$d(^User.MKBICDContrastI("DescIndex"," "_MKBSDICDDesc))          //判断该icd描述是否存在于各版本icd对照中  不存在则退出
			s rowid=0
			for
			{
				s rowid = $o(^User.MKBICDContrastI("DescIndex"," "_MKBSDDiag,rowid))
				q:rowid=""
				s icdbaseid = $lg($g(^User.MKBICDContrastD(rowid)),6) 
				continue:icdbaseid'["526477"
				s MKBICDChildStructFlag = $lg($g(^User.MKBICDContrastD(rowid)),18)
				continue:MKBICDChildStructFlag'=1
				s MKBICDResultRelation = $lg($g(^User.MKBICDContrastD(rowid)),19)
				s fwkobj = ##class(User.MKBStructuredData).%OpenId(dataid)
				d fwkobj.MKBSDUpdateUserSetObjectId(6470)
				s fwkobj.MKBSDResultRelation = MKBICDResultRelation 
				d fwkobj.%Save()
				d fwkobj.%Close()
				s childsub = 0
				for
				{
					s childsub = $o(^User.MKBICDContrastResultI("MKBICDContrastIndex",rowid,childsub))
					q:childsub=""
					s MKBSequence=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),7)
					s MKBRTermdr=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),4)
					s MKBRResult=$lg($g(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",childsub)),2)
					s sobj=##class(User.MKBStructuredDataResult).%New(dataid)
					d sobj.MKBSDStructDataSetObjectId(dataid)
					s sobj.MKBSDSequence=MKBSequence
					s sobj.MKBSDStructResultID=MKBRResult
					d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISERR(ssc)
					{
						s result=$system.OBJ.DisplayError(ssc)
						Tro
					}
					else
					{
						s addnum=addnum+1
						s result="true"
						w !
					}
					if (result="true")
					{
						s snobj =##class(User.MKBStructuredData).%OpenId(dataid)
						s snobj.MKBSDChildStructFlag = 1
						s fwk = snobj.%Save()
					}
					if $$$ISERR(fwk)
					{
						b
					}
				}
			}
		}
		
	}
	w "删除"_delnum_"修改"_modnum_"新匹配"_addnum
	b
	q "成功匹配"_num_"条"
}

/// Creator：范文凯
/// CreatDate:2019-10-30
/// Description：导入手术数据对照，为列表属性 
/// Table：User.MKBStructuredData
/// Input：数据处理工厂termbaseid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportYDYOpData("产科.csv")
ClassMethod ImportYDYOpData(FileName As %String)
{
	//k ^tmpopdata
	s result = ""
	s count = 0
	s flag = ""          //
 	s basedr = $o(^User.MKBTermBaseI("DescIndex"," 北京临床-ICD9手术分类临床版",0))             //获得MKB_TermBase中北京临床-ICD9手术分类临床版的baseid
	s ZLSHid = $o(^User.MKBTermBaseI("DescIndex"," 治疗手术",0)) 
	Ts 
	s file=##class(%File).%New("D:\DataFile\全院手术对照\"_FileName)               //获取csv文件
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s flag = 0
		s str =file.Read()
		//s count=count+1
		s OpDesc = $p(str,",",6)
		s OpDesc=##class(web.DHCBL.BDP.FunLib).Util(OpDesc)       //我院手术名称 特殊符号处理
		s GJDesc = $p(str,",",3)
		s GJDesc=##class(web.DHCBL.BDP.FunLib).Util(GJDesc)       //国家名称  特殊符号处理
		continue:OpDesc=""
		continue:GJDesc=""
		s Termid = $o(^User.MKBTermI("DescIndex",ZLSHid," "_OpDesc,0))               //获得我院手术名称在term表中的id
		continue:Termid=""
		
		/*s BJTermid = $o(^User.MKBTermI("DescIndex",basedr," "_GJDesc,0))                       //获得要存进去的id   如果这个为空  说明没有对照上 要保存记录
		if (BJTermid="")
		{
			s Code = $p(str,",",2)  //获得编码
			s ^tmpopdata(count)=count_","_OpDesc_","_GJDesc_","_Code                                               //去执行生成csv文件    输出OpDESC 以及 GJDesc
			continue
		}*/
		s MKBTPRowId = $o(^User.MKBTermPropertyI("TermIndex",Termid," "),-1)              //获得列表属性的id 
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			s tmpDesc = $lg($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)                 // 
			if (GJDesc = tmpDesc)
			{
				s flag = 1
				w MKBTPRowId,!
			}
		}
		continue:flag=1
		s obj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s obj.MKBTPDDesc = GJDesc
		s obj.MKBTPDProDR = MKBTPRowId
		s sc = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(obj)
		if (sc["false")
		{
			w sc
			//b
		}
		else
		{
			s count = count+1
		}
	}
	/*if (sc["true")
	{
		s result = "导入成功"
	}
	else
	{
		//Tro 
		s result = "导入失败"
	}*/
	//d ..NoMatchOpData(FileName)
	tc
	w "保存成功共"_count_"条数据"
	q result
}

/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).YDYopData()
ClassMethod YDYopData()
{
	ts
	d ..ImportOpDataExtend("产科.csv")                                                    
	d ..ImportOpDataExtend("耳鼻咽喉科.csv")                                    
	d ..ImportOpDataExtend("妇科.csv")                                          
	d ..ImportOpDataExtend("肝胆外科.csv")                                    
	d ..ImportOpDataExtend("肛肠外科.csv")                                     
	d ..ImportOpDataExtend("骨科.csv")                                         
	d ..ImportOpDataExtend("甲状腺烧伤.csv")          
	d ..ImportOpDataExtend("介入科.csv")                                         
	d ..ImportOpDataExtend("泌尿外科.csv")                                        
	d ..ImportOpDataExtend("皮肤科.csv")                                          
	d ..ImportOpDataExtend("乳腺外科.csv")                                       
	d ..ImportOpDataExtend("神经外科.csv")                                      
	d ..ImportOpDataExtend("疼痛科.csv")                                         
	d ..ImportOpDataExtend("胃肠疝外科.csv")           
	d ..ImportOpDataExtend("胃肠肿瘤外科.csv")    
	d ..ImportOpDataExtend("心脏外科.csv")                                      
	d ..ImportOpDataExtend("胸外科.csv")                                        
	d ..ImportOpDataExtend("血管甲状腺外科.csv")      
	d ..ImportOpDataExtend("眼科.csv")                                          
	d ..ImportOpDataExtend("胰胆外科.csv")
	d ..ImportOpDataExtend("运动医学.csv")                                     
	d ..ImportOpDataExtend("整形外科.csv")                                   
	q "yes"
}

/// Creator:范文凯
/// CreatDate:2019-10-31
/// Description:导入治疗手术的扩展属性
/// Table:
/// Input: 
/// Return:
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportOpDataExtend("眼科.csv")
ClassMethod ImportOpDataExtend(FileName As %String)
{
	s result = ""
	s count = 0
	//获得四个手术的baseid
	s base1 = $o(^User.MKBTermBaseI("DescIndex"," 国家临床1.1-手术操作分类代码",0)) 
	s base2 = $o(^User.MKBTermBaseI("DescIndex"," 国家临床2.0-手术操作分类代码",0))
	s base3 = $o(^User.MKBTermBaseI("DescIndex"," 国家标准版-ICD9字典库2011",0))
	s base4 = $o(^User.MKBTermBaseI("DescIndex"," 北京临床-ICD9手术分类临床版",0))
	
	s ZLSHid = $o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0))                                  //获得治疗手术的termbaseid
	Ts 
	s file=##class(%File).%New("D:\DataFile\江苏全院手术对照\"_FileName)               //获取csv文件
	d file.Open("RS")
	//d file.ReadLine()
	while 'file.AtEnd
	{
		s str =file.Read()
		//b
		s OpDesc = $p(str,",",2)
		s OpDesc=##class(web.DHCBL.BDP.FunLib).Util(OpDesc)       //我院手术名称 特殊符号处理
		s GJDesc = $p(str,",",5)
		s GJDesc=##class(web.DHCBL.BDP.FunLib).Util(GJDesc)       //国家名称  特殊符号处理
		//s PYCode = $p(str,",",4)
		//s PYCode=##class(web.DHCBL.BDP.FunLib).Util(PYCode)       //检索码  特殊符号处理
		continue:OpDesc=""
		continue:GJDesc=""
		s Termid = $o(^User.MKBTermI("DescIndex",ZLSHid," "_OpDesc,0))               //获得我院手术名称在term表中的id
		continue:Termid=""
		s MKBTPRowId = $o(^User.MKBTermPropertyI("TermIndex",Termid," "),-1)              //获得列表属性的id              获得了列表属性的id 之后 用这个id去获得他的扩展属性
		//s MKBTPDRowId =0                                                                  //获得属性ProDetail表的id
		//for
		//{
			//s MKBTPDRowId = $o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			//q:MKBTPDRowId=""
			//s tmpDesc = $lg($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)  
			//continue:(tmpDesc'=GJDesc)
			s MKBTepSeq = 0
			s endresult=""
			for
			{
				s MKBTepSeq = $o(^User.MKBTermExtendProI("SeqIndex",MKBTPRowId,MKBTepSeq))
				q:MKBTepSeq=""
				s MKBTepID = $o(^User.MKBTermExtendProI("SeqIndex",MKBTPRowId,MKBTepSeq,0))          //获得childSub  然后就是拼内容了
				if (MKBTepSeq=1)
				{
					s MKBTepCode = $p(str,",",4)
				    if ($l(MKBTepCode)<6)
				    {
					    s ZeroL = 6 - $l(MKBTepCode)
					    for i = 1:1:ZeroL
					    {
						    s MKBTepCode = MKBTepCode_"0"
						}
					}
					s MKBTepCode=##class(web.DHCBL.BDP.FunLib).Util(MKBTepCode)            //获得手术编码 特殊符号处理
					s saveresult=MKBTepID_"[A]"_MKBTepCode_"[N]"
				}
				if (MKBTepSeq=2)
				{
					s MKBTeqFJ = $p(str,",",3)
					s MKBTeqFJ=##class(web.DHCBL.BDP.FunLib).Util(MKBTeqFJ)                //获得了手术等级
					s saveresult=saveresult_MKBTepID_"[A]"_MKBTeqFJ_"[N]"
				}
				if (MKBTepSeq=3)                                                           //获得了对应标准版
				{
					s DYBZB = ""
					//判断国家名称对上了几个 , 把对上的用,拼成字符串
					if ($d(^User.MKBTermI("DescIndex",base1," "_GJDesc)))
					{
				    	s DYBZB ="国家临床1.1"_"&%"
					}
					if ($d(^User.MKBTermI("DescIndex",base2," "_GJDesc)))
					{
						s DYBZB =DYBZB_"国家临床2.0"_"&%"
					}
					if ($d(^User.MKBTermI("DescIndex",base3," "_GJDesc)))
					{
						s DYBZB =DYBZB_"国家标准版"_"&%"
					}
					if ($d(^User.MKBTermI("DescIndex",base4," "_GJDesc)))
					{
						s DYBZB =DYBZB_"北京临床"_"&%"
					}
					s DYBZB = $e(DYBZB,0,*-2)
					s saveresult=saveresult_MKBTepID_"[A]"_DYBZB
					s endresult = saveresult
					//b
				}
			}
			//s obj = ##class(User.MKBTermProDetail).%New()  //(MKBTPDRowId)
			
			s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDDesc = GJDesc
			s eobj.MKBTPDProDR = MKBTPRowId
			//s eobj.MKBTPDPYCode = PYCode
			//s eobj.MKBTPDSequence = obj.MKBTPDSequence
			//s eobj.MKBTPDActiveFlag = obj.MKBTPDActiveFlag
			s eobj.MKBTPDExtend = endresult
			s sc = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
		    if (sc["success")
		    {
			   // w "success"_MKBTPDRowId,!
			    //d obj.%Close()
			    d eobj.%Close()
			    //b
			}
			if (sc["false")
			{
				//w MKBTPRowId,!
				//w MKBTPDRowId,!
				//w eobj.MKBTPDDesc,!
				//d obj.%Close()
			    d eobj.%Close()
				w sc,!
				//b
			}	
		}
	//}
	//tc
	q result
}

/// 把主要部位里的数据全部复制到主要部位测试中去
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).CopyZYBW()
ClassMethod CopyZYBW()
{
	Ts
	s MKBTRowId = 0
	for 
	{
		s MKBTRowId = $o(^User.MKBTermI("BaseIndex",6,MKBTRowId))
		q:MKBTRowId=""
	    s obj = ##class(User.MKBTerm).%OpenId(MKBTRowId)
	    s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
	   // s eobj.MKBTActiveFlag = obj.MKBTActiveFlag
	    s eobj.MKBTBaseDR = "102"
	    s eobj.MKBTDesc = obj.MKBTDesc
	    s eobj.MKBTLastLevel = MKBTRowId
	    s eobj.MKBTNote = obj.MKBTNote
	    s eobj.MKBTPYCode = obj.MKBTPYCode
	    s eobj.MKBTSequence = obj.MKBTSequence
	    s rs = ##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
	    if rs["false"
	    {
		    b 
		}
	    d obj.%Close()
	    d eobj.%Close()
	    //s obj.%Save()
	}
	q "yes"
}

/// 重新复制的表的上级节点梳理一遍
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).DoLastLevel()
ClassMethod DoLastLevel()
{
	Ts
	s MKBTRowId = 0
	for 
	{
		s MKBTRowId = $o(^User.MKBTermI("BaseIndex",6,MKBTRowId))
		q:MKBTRowId=""
		s obj = ##class(User.MKBTerm).%OpenId(MKBTRowId)                //打开这个对象
		s LastLevel = obj.MKBTLastLevel                              //获得上级节点
		if (LastLevel'="")
		{
			s LastLevelID = LastLevel.%Id()
		}
		else
		{
			s LastLevelID =""
		}
		s CSRowID = ^TmpZYBWDY(MKBTRowId)                               //获得测试表的rowid
		s nobj = ##class(User.MKBTerm).%OpenId(CSRowID) 
		if (LastLevelID="")
		{
			d nobj.MKBTLastLevelSetObjectId("")
			
			d nobj.%Save()
			//s rs = ##class(web.DHCBL.MKB.MKBTerm).SaveData(nobj)
			//if rs["false"
	    	//{
		    	//b 
			//}
		}
		else
		{
			s NewID = $g(^TmpZYBWDY(LastLevelID))
			d nobj.MKBTLastLevelSetObjectId(NewID)
			d nobj.%Save()
			/*s rs = ##class(web.DHCBL.MKB.MKBTerm).SaveData(nobj)
			if rs["false"
	    	{
		    	b 
			}*/
		}
		d nobj.%Close()
		d obj.%Close()	
	}
	k ^TmpZYBWDY
	q "yes"
}

/// 为上一个方法服务
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).FWKDo()
ClassMethod FWKDo()
{
	 s MKBTRowId = 0
	 for
	 {
		 s MKBTRowId = $o(^User.MKBTermI("BaseIndex",102,MKBTRowId))
		 q:MKBTRowId=""
		 s LastLevel =$lg($g(^User.MKBTermD(MKBTRowId)),5)
		 s ^TmpZYBWDY(LastLevel)=MKBTRowId 
	 }
	 q "yes"
}

/// 阳光融合科室准备数据导入   basedr = 5
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportYGRHData("D:\DataFile\阳光融合科室准备数据.csv","5")
ClassMethod ImportYGRHData(path As %String, basedr As %String)
{
		;s basedr = 2                                                         //修改医院指向
	s newcatchnum = 0
	s result = ""
	s sc=0
	s sc1=0
	s stop = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\XHdataO04.13.csv")             //修改文件路径
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                       //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		s Icd = $p(str,",",3) 
		s IcdDesc=$p(str,",",4)
		//s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		s Icd =$Zstrip(Icd,"<>W") 
		s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		s Icd=$Replace(Icd,")","）")
		s Icd=$Replace(Icd,"(","（")
		s Icd=$Replace(Icd,",","，")
		s IcdDesc=$Replace(IcdDesc,")","）")
		s IcdDesc=$Replace(IcdDesc,"(","（")
		s IcdDesc=$Replace(IcdDesc,",","，")
		
		
			s diagindex =" "_diag                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在    不存在就新增，存在就判断icd编码是否一致，不一致就修改
		    {   
		        s newcatchnum = newcatchnum+1
		        w newcatchnum
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = diag
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "各科室准备数据"
			    s obj.MKBSDICD = Icd
			    s obj.MKBSDICDDesc = IcdDesc
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			    s res =..AutoProcessingStructData(diag,id,IcdDesc,basedr)    //通过数据处理工厂已处理的进行自动结构化
			    if (res="true")
			    {
				   s snobj =##class(User.MKBStructuredData).%OpenId(id)
				   s snobj.MKBSDChildStructFlag = 1
				   s fwk = snobj.%Save()
				}
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "L"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   {b}
					}
			    }
			}
			else                                                                  //该诊断存在   去判断icd编码是否相同。
			{   
				s sc=0
				s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s icdcodeold = $lg($g(^User.MKBMKBStructuredDataD(id)),20)  //获得原有icd编码
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				if (icdcodeold '=Icd)
				{
					s obj.MKBSDICD = Icd
				}
				s DiagSource = obj.MKBSDDiaSource
				if (DiagSource'["各科室准备数据")
				{
					s obj.MKBSDDiaSource = DiagSource_"&各科室准备数据"
				}
				s sc = obj.%Save()
				d obj.%Close()
				if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s sc1=1
					    	/*s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}*/
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="L"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}
			    /*s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s DiagSource = obj.MKBSDDiaSource
			    if (DiagSource'["门急诊")
			    {
				    s DiagSource = DiagSource_"&门急诊"
				    s obj.MKBSDDiaSource = DiagSource
				}
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="O"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	{b}
					    }	
					} 
				}*/
			}		
	}
	if (stop=0)
	{
		//TC  
		s result ="导入成功"
	}
	else
	{
		//Trollback
		s result ="导入失败"
	}
	q result
}

// 最优匹配的赋值

/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).InitialICD()
ClassMethod InitialICD()
{
	Ts 
	s num=0
	s StructuredData = 0
	for
	{
		s StructuredData = $o(^User.MKBStructuredDataD(StructuredData))         //遍历数据处理工厂的数据
		//b
		q:StructuredData=""
		s SDInitialICD = $lg($g(^User.MKBStructuredDataD(StructuredData)),18)     //获取最优匹配字段
		//w SDInitialICD
		continue:SDInitialICD'="Y"                                               //不是最优匹配则跳出循环
		s SDICDDesc = $lg($g(^User.MKBStructuredDataD(StructuredData)),21)        //如果是最优匹配，获得ICDDesc 字段 去各版本icd中匹配
		s childid=0
		s SDResult=""
		for
		{
			s childid =  $o(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid))
			q:childid=""
			s SDResult = SDResult_","_$lg($g(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid)),2)   //获得结构化匹配结构
		}
		//w SDResult
		//用ICDDesc 去匹配各版本icd对照表中的ICDDesc
		//b
		if $d(^User.MKBICDContrastI("DescIndex"," "_SDICDDesc))    //如果存在，则进行操作        
		{
			//b
			s ICDContrastID = 0
			for
			{
				s ICDContrastID = $o(^User.MKBICDContrastI("DescIndex"," "_SDICDDesc,ICDContrastID))
				q:ICDContrastID="" 
				s ICDCInitial = $lg($g(^User.MKBICDContrastD(ICDContrastID)),17)     //如果已经最优 则退
				continue:ICDCInitial="Y" 
				s ICDchildid=0
				s ICDSDResult=""
				for
				{
					//b
					s ICDchildid =  $o(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid))
					q:ICDchildid=""
					s ICDSDResult = ICDSDResult_","_$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid)),2)   //获得结构化匹配结构
					//b
				}
				w ICDSDResult,!
				if (ICDSDResult=SDResult)          //如果结构化结果一致 则设为最优
				{
					s obj =##class(User.MKBICDContrast).%OpenId(ICDContrastID)
					s obj.MKBICDInitialICD = "Y"
					s sc = obj.%Save()
					if (sc=1)
					{
						s num = num+ 1
					}
					d obj.%Close()
				}
 			}
		}
		
	}
	w num
	q "yes"
}

/// 最优匹配的赋值 icd to sd
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).InitialICDToSD()
ClassMethod InitialICDToSD()
{
	Ts 
	s num=0
	s StructuredData = 0
	for
	{
		s StructuredData = $o(^User.MKBStructuredDataD(StructuredData))         //遍历数据处理工厂的数据
		//b
		q:StructuredData=""
		s SDInitialICD = $lg($g(^User.MKBStructuredDataD(StructuredData)),18)     //获取最优匹配字段
		//w SDInitialICD
		continue:SDInitialICD="Y"                                               //不是最优匹配则跳出循环
		s SDDiag = $lg($g(^User.MKBStructuredDataD(StructuredData)),2)        //如果是最优匹配，获得 Diag 字段 去各版本icd中匹配
		s childid=0
		s SDResult=""
		//s SDCenter=""
		for
		{
			s childid =  $o(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid))
			q:childid=""
			s SDResult = SDResult_","_$lg($g(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid)),2)   //获得结构化匹配结构
			//s SDCenter = SDCenter_","_$lg($g(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid)),4)   //获得中心词
		}
		//w SDResult
		//用ICDDesc 去匹配各版本icd对照表中的ICDDesc
		//b
		
		if $d(^User.MKBICDContrastI("DescIndex"," "_SDDiag))    //如果存在，则进行操作        
		{
			
			s ICDContrastID = 0
			//b ;;1
			for
			{
				s ICDContrastID = $o(^User.MKBICDContrastI("DescIndex"," "_SDDiag,ICDContrastID))
				b:SDDiag="伤寒"
				//w ICDContrastID
				q:ICDContrastID="" 
				s ICDCInitial = $lg($g(^User.MKBICDContrastD(ICDContrastID)),17)     //如果已经最优 则退
				//w "1"
				continue:ICDCInitial'="Y" 
				//b ;;2
				s ICDchildid=0
				s ICDSDResult=""
				//s ICDCenter=""
				for
				{
					
					s ICDchildid =  $o(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid))
					q:ICDchildid=""
					s ICDSDResult = ICDSDResult_","_$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid)),2)   //获得结构化匹配结构
					//s ICDCenter = ICDCenter_","_$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid)),4)
				}
				/*if (ICDSDResult="")
				{
					if (ICDCenter=SDCenter)
					{
						s obj =##class(User.MKBStructuredData).%OpenId(StructuredData)
						s obj.MKBSDInitialICD = "Y"
						s sc = obj.%Save()
						if (sc=1)
						{
							s num = num+ 1
						}
						d obj.%Close()
					}
				}*/
				if (ICDSDResult=SDResult)          //如果结构化结果一致 则设为最优
				{
					//b
					s obj =##class(User.MKBStructuredData).%OpenId(StructuredData)
					s obj.MKBSDInitialICD = "Y"
					s sc = obj.%Save()
					if (sc=1)
					{
						s num = num+ 1
					}
					d obj.%Close()
				}
 			}
		}
		
	}
	w num
	q "yes"
}

/// 各版本icd对照 结构化结果[] = ICD描述的设置为最优匹配
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ICDZYPP()
ClassMethod ICDZYPP()
{
	Ts
	s num = 0
	s ICDContrastID = 0
	for
	{
		s ICDContrastID  = $o(^User.MKBICDContrastD(ICDContrastID))
	    q:ICDContrastID="" 
	    s ICDCInitial = $lg($g(^User.MKBICDContrastD(ICDContrastID)),17)     //如果已经最优 则退
	    s ICDDesc = $lg($g(^User.MKBICDContrastD(ICDContrastID)),3) 
		continue:ICDCInitial="Y"
		s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",ICDContrastID,0))
		if sequence'=""
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",ICDContrastID,sequence,0))
			if MKBICDRRowid'=""
			{
				s MKBICDDResultID=$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				if MKBICDResultTermdr'=""
				{
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDDResultID,MKBICDResultTermdr)
				}
				else
				{
					s Result=""
				}
				s MKBICDSupplement=$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid)),5)
				if MKBICDSupplement'=""
				{
					if Result["]"
					{
						s str=$e(Result,1,*-1)
						s Result=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s Result=Result_"[("_MKBICDSupplement_")]"
					}
				}					
			}
			else
			{
				s Result=""
			}
		}
		if (Result["[")
		{
			s result1 = $p(Result,"[",2)
			s result1 = $p(result1,"]",1)
			if (result1=ICDDesc)
			{
				s obj =##class(User.MKBICDContrast).%OpenId(ICDContrastID)
				s obj.MKBICDInitialICD = "Y"
				s sc = obj.%Save()
				if (sc=1)
				{
					s num = num+ 1
				}
				d obj.%Close()
				w result1_"^^^^^"_ICDDesc_"^^^^^"_ICDContrastID,!
				//b
			}
			//w Result,!
			//w result1,!
			
		}
	    //b
	}
	q num
}

/// 为关键字js 返回知识库里包含医院的数组
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).ArrayForKeyWords()
ClassMethod ArrayForKeyWords()
{
	s ID = 0
	s Count=0
	s result="["
 	for
 	{
	 	s ID =$o(^User.MKBStructuredBaseD(ID))
		q:ID=""
		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(ID)),2)
		s Count=Count+1
		if (Count=1)
		{
			s result= result_"{text:'"_MKBSTBDesc_"',id:'"_ID_"',selected:'true'}^"
		}
		else
		{
			s result= result_"{text:'"_MKBSTBDesc_"',id:'"_ID_"'}^"
		}
	}
	s result=$e(result,0,*-1)
	q result_"]"
}

/// 最优匹配的赋值 icd to sd
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).NewInitialICDToSD()
ClassMethod NewInitialICDToSD()
{
	Ts 
	s num=0
	s StructuredData = 0
	for
	{
		s StructuredData = $o(^User.MKBStructuredDataD(StructuredData))         //遍历数据处理工厂的数据
		//b
		q:StructuredData=""
		s SDInitialICD = $lg($g(^User.MKBStructuredDataD(StructuredData)),18)     //获取最优匹配字段
		//w SDInitialICD
		continue:SDInitialICD="Y"                                               //已经是最优匹配则跳出循环
		s SDICDDesc = $lg($g(^User.MKBStructuredDataD(StructuredData)),2)        //获得不是最优匹配的诊断短语名
		s childid=0
		s SDResult=""
		for
		{
			s childid =  $o(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid))
			q:childid=""
			s SDResult = SDResult_","_$lg($g(^User.MKBStructuredDataD(StructuredData,"MKBSDStructResult",childid)),2)   //获得结构化匹配结构
		}
		//w SDResult
		//用ICDDesc 去匹配各版本icd对照表中的ICDDesc
		//b
		if $d(^User.MKBICDContrastI("DescIndex"," "_SDICDDesc))    //如果存在，则进行操作        
		{
			//b
			s ICDContrastID = 0
			for
			{
				s ICDContrastID = $o(^User.MKBICDContrastI("DescIndex"," "_SDICDDesc,ICDContrastID))
				q:ICDContrastID="" 
				s ICDCInitial = $lg($g(^User.MKBICDContrastD(ICDContrastID)),17)     //如果不是最优则退
				s ICDDiaSource =  $lg($g(^User.MKBICDContrastD(ICDContrastID)),6)    //获得数据来源
				continue:ICDDiaSource'["526477"
				continue:ICDCInitial'="Y" 
				s ICDchildid=0
				s ICDSDResult=""
				for
				{
					//b
					s ICDchildid =  $o(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid))
					q:ICDchildid=""
					s ICDSDResult = ICDSDResult_","_$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",ICDchildid)),2)   //获得结构化匹配结构
					//b
				}
				w ICDSDResult,!
				if (ICDSDResult=SDResult)          //如果结构化结果一致 则设为最优
				{
					s obj =##class(User.MKBStructuredData).%OpenId(StructuredData)
					s obj.MKBSDInitialICD = "Y"
					s sc = obj.%Save()
					if (sc=1)
					{
						s num = num+ 1
					}
					d obj.%Close()
				}
 			}
		}
		
	}
	w num
	q "yes"
}

/// 12.17 数据处理工厂里没有ICD的取消最优
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).DeleteZYPP()
ClassMethod DeleteZYPP()
{
	Ts 
	s num=0
	s StructuredData = 0                         
	for
	{
		s StructuredData = $o(^User.MKBStructuredDataD(StructuredData))         //遍历数据处理工厂的数据
		//b
		q:StructuredData=""
		s SDInitialICD = $lg($g(^User.MKBStructuredDataD(StructuredData)),18)     //获取最优匹配字段
		//w SDInitialICD
		continue:SDInitialICD'="Y"                                               //过滤掉不是最优匹配的
		s SDICD = $lg($g(^User.MKBStructuredDataD(StructuredData)),20)        //获得最优匹配数据的ICD
		if (SDICD="")                                                         //如果该数据没有ICD 则取消最优匹配
		{
			s obj =##class(User.MKBStructuredData).%OpenId(StructuredData)
			s obj.MKBSDInitialICD= ""
			s sc = obj.%Save()
			if (sc=1)
			{
				s num = num+ 1
			}
			d obj.%Close()
		}
	}
	q num
}

/*
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetCDSSDisease","")
Query GetCDSSDisease(desc As %String) As %Query(ROWSPEC = "CDSSDiseaseRowId,DiseaseCode,DiseaseName,DiseaseEnName,DiseaseDeptCode,DiseaseDeptName,DiseaseAliasName,DiseaseBodyPartDR,MedicalCompanyCode,ICD9Code,ICD9Name,ICD10Code,ICD10Name,ICD10LocalCode,ICD10LocalName,ICD11Code,ICD11Name,UseFlag,RareDiseaseFlag,CreateDate,CreateUserID,Remarks")
{
}

ClassMethod GetCDSSDiseaseExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
 	if (desc="")
 	{
 		s CDSSDiseaseRowId=0
 		for
 		{
	 		s CDSSDiseaseRowId = $o(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId))
	 		q:CDSSDiseaseRowId=""
	 		s DiseaseCode=$lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),2)
	 		s DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),3)
	 		s DiseaseEnName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),4)
	 		s DiseaseDeptCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),5)
	 		s DiseaseDeptName  = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),6)
	 		s DiseaseAliasName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),7)
	 		s DiseaseBodyPartDR = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),8)
	 		s MedicalCompanyCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),9)
	 		s ICD9Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),10)
	 		s ICD9Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),11)
	 		s ICD10Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),12)
	 		s ICD10Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),13)
	 		s ICD10LocalCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),14)
	 		s ICD10LocalName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),15)
	 		s ICD11Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),16)
	 		s ICD11Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),17)
	 		s UseFlag = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),18)
	 		s RareDiseaseFlag = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),19)
	 		s CreateDate = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),20)
	 		s CreateUserID = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),21)
	 		s Remarks = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),22)
	 		d OutputRow8
		}
 	}
 	else
 	{
	 	s CDSSDiseaseRowId = 0
	 	for
	 	{
		 	s CDSSDiseaseRowId = $o(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId))
		 	q:CDSSDiseaseRowId=""
		 	s DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),3)
		 	if (DiseaseName[desc)
		 	{
			 	s DiseaseCode=$lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),2)
			 	s DiseaseEnName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),4)
	 			s DiseaseDeptCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),5)
	 			s DiseaseDeptName  = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),6)
	 			s DiseaseAliasName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),7)
	 			s DiseaseBodyPartDR = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),8)
	 			s MedicalCompanyCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),9)
	 			s ICD9Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),10)
	 			s ICD9Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),11)
	 			s ICD10Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),12)
	 			s ICD10Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),13)
	 			s ICD10LocalCode = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),14)
	 			s ICD10LocalName = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),15)
	 			s ICD11Code = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),16)
	 			s ICD11Name = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),17)
	 			s UseFlag = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),18)
	 			s RareDiseaseFlag = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),19)
	 			s CreateDate = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),20)
	 			s CreateUserID = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),21)
	 			s Remarks = $lg($g(^User.DHCDSSDiseaseDictD(CDSSDiseaseRowId)),22)
			 	d OutputRow8
			}
		}
	}
    
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CDSSDiseaseRowId,DiseaseCode,DiseaseName,DiseaseEnName,DiseaseDeptCode,DiseaseDeptName,DiseaseAliasName,DiseaseBodyPartDR,MedicalCompanyCode,ICD9Code,ICD9Name,ICD10Code,ICD10Name,ICD10LocalCode,ICD10LocalName,ICD11Code,ICD11Name,UseFlag,RareDiseaseFlag,CreateDate,CreateUserID,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCDSSDiseaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetCDSSDiseaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCDSSDiseaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2019-12-26
/// Description:CDSS疾病字典表 属性维护
/// Input：中心词
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetCDSSDiseasePro","1")
Query GetCDSSDiseasePro(Id As %String) As %Query(ROWSPEC = "DiseaseProName,DiseaseProDetail,DiseaseProType")
{
}

ClassMethod GetCDSSDiseaseProExecute(ByRef qHandle As %Binary, Id As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// 在全局化词表中查找
 	s DiseaseProName = "疾病编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),2)
    s DiseaseProType = "TX"
    d OutputRow8
    s DiseaseProName = "疾病名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),3)
    s DiseaseProType = "TX"
    d OutputRow8
    s DiseaseProName = "疾病英文名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),4)
    s DiseaseProType = "TX"
    d OutputRow8
    s DiseaseProName = "疾病关联诊断因子"
    s DiseaseProDetail = ""
    s DiseaseProType = "L1"
    d OutputRow8
    s DiseaseProName = "疾病关联诊断"
    s DiseaseProDetail = ""
    s DiseaseProType = "L2"
    d OutputRow8
    s DiseaseProName = "疾病所属科室编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),5)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "疾病别名名称"
    s DiseaseProDetail=  $lg($g(^User.DHCDSSDiseaseDictD(Id)),6)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "疾病部位"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),7)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "公司临床医学知识体系编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),8)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-9编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),9)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-9名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),10)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-10编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),11)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-10名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),12)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-10-地方编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),13)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-10-地方名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),14)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-11编码"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),15)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "ICD-11名称"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),16)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "使用标志"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),17)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "罕见病标记"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),18)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "创建时间"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),19)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "创建人员"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),20)
    s DiseaseProType = "TX"
    d OutputRow8 
    s DiseaseProName = "备注"
    s DiseaseProDetail = $lg($g(^User.DHCDSSDiseaseDictD(Id)),21)
    s DiseaseProType = "TX"
    d OutputRow8 
    
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiseaseProName,DiseaseProDetail,DiseaseProType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCDSSDiseaseProFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetCDSSDiseaseProClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCDSSDiseaseProExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// GetDiseJoinFactor
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetDiseJoinFactor","185","JoinFactor")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetDiseJoinFactor","185","JoinDiffDiag")
Query GetDiseJoinFactor(DiseID As %String, TableName As %String) As %Query(ROWSPEC = "DiseJFRowId,DiseJFDesc")
{
}

ClassMethod GetDiseJoinFactorExecute(ByRef qHandle As %Binary, DiseID As %String, TableName As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (TableName ="JoinFactor")
 	{
	 	s DiagFactorDR = 0
	 	for
	 	{
		 	s DiagFactorDR = $o(^User.DHCDSSDiseJoinFactorI("DiseFacorIndex",DiseID,DiagFactorDR))
		 	q:DiagFactorDR=""
		 	s DiseJFRowId = $o(^User.DHCDSSDiseJoinFactorI("DiseFacorIndex",DiseID,DiagFactorDR,0))
		 	s DiseJFDesc = $lg($g(^User.DHCDSSDiagFactorDictD(DiagFactorDR)),3)
		 	d OutputRow8
		}
	}
	if (TableName ="JoinDiffDiag")
	{
		s DiseJDifRowId = 0
		for
		{
			s DiseJDifRowId = $o(^User.DHCDSSDiseJoinDiffDiagI("DiseaseDRIndex",DiseID,DiseJDifRowId))
			q:DiseJDifRowId=""
			s DiseJFRowId  = $lg($g(^User.DHCDSSDiseJoinDiffDiagD(DiseJDifRowId)),4)
			s DiseJFDesc = $lg($g(^User.DHCDSSDiseaseDictD(DiseJFRowId)),3) 
			d OutputRow8
		}
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiseJFRowId,DiseJFDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDiseJoinFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetDiseJoinFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseJoinFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// GetJoinFactor
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetDiseJoinFactor","185","JoinFactor")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetJoinFactor","1")
Query GetJoinFactor(DiseID As %String) As %Query(ROWSPEC = "DiseJFRowId,DiseJFDesc,ShowContinueTime,DiagFactorGrade,DiagFactorDR,DiagFactorWeights,DiagFactorType,DiagFactorValOperator,DiagFactorValMin,DiagFactorValMax,UseFlag,Remarks")
{
}

ClassMethod GetJoinFactorExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
	s DiagFactorDR = 0
	for
	{
		s DiagFactorDR = $o(^User.DHCDSSDiseJoinFactorI("DiseFacorIndex",DiseID,DiagFactorDR))
		q:DiagFactorDR=""
		s DiseJFRowId=0
		for
		{
			s DiseJFRowId = $o(^User.DHCDSSDiseJoinFactorI("DiseFacorIndex",DiseID,DiagFactorDR,DiseJFRowId))
			q:DiseJFRowId=""
			s DiseJFDesc = $lg($g(^User.DHCDSSDiagFactorDictD(DiagFactorDR)),3)
			s ShowContinueTime = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),3)
			s DiagFactorGrade = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),4)
			s:DiagFactorGrade'="" DiagFactorGrade = $FNUMBer(DiagFactorGrade,"T")
			s DiagFactorDR = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),5)
			s DiagFactorWeights = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),6)
			s:DiagFactorWeights'="" DiagFactorWeights = $FNUMBer(DiagFactorWeights,"T")
			s DiagFactorType = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),7)
			s DiagFactorValOperator = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),8)
			s DiagFactorValMin = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),9)
			s DiagFactorValMax = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),10)
			s UseFlag = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),11)
			s Remarks = $lg($g(^User.DHCDSSDiseJoinFactorD(DiseJFRowId)),11)
			d OutputRow8
		}
	}
    
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiseJFRowId,DiseJFDesc,ShowContinueTime,DiagFactorGrade,DiagFactorDR,DiagFactorWeights,DiagFactorType,DiagFactorValOperator,DiagFactorValMin,DiagFactorValMax,UseFlag,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetJoinFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetJoinFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJoinFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// GetJoinDiffDiag
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetDiseJoinFactor","185","JoinFactor")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetJoinDiffDiag","359")
Query GetJoinDiffDiag(DiseID As %String) As %Query(ROWSPEC = "DiseJDifRowId,DiffDiagDR,DiffDiagDesc,DiffDiagNum,UseFlag,Remarks")
{
}

ClassMethod GetJoinDiffDiagExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
	s DiseJDifRowId = 0
	for
	{
		s DiseJDifRowId = $o(^User.DHCDSSDiseJoinDiffDiagI("DiseaseDRIndex",DiseID,DiseJDifRowId))
		q:DiseJDifRowId=""
		s DiffDiagDR  = $lg($g(^User.DHCDSSDiseJoinDiffDiagD(DiseJDifRowId)),4)
		s DiffDiagDesc = $lg($g(^User.DHCDSSDiseaseDictD(DiffDiagDR)),3) 
		s DiffDiagNum = $lg($g(^User.DHCDSSDiseJoinDiffDiagD(DiseJDifRowId)),3) 
		s UseFlag = $lg($g(^User.DHCDSSDiseJoinDiffDiagD(DiseJDifRowId)),6)
		s Remarks = $lg($g(^User.DHCDSSDiseJoinDiffDiagD(DiseJDifRowId)),7)
		d OutputRow8
	}
    
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiseJDifRowId,DiffDiagDR,DiffDiagDesc,DiffDiagNum,UseFlag,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetJoinDiffDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetJoinDiffDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJoinDiffDiagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// FactorSource
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetDiseJoinFactor","185","JoinFactor")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","FactorSource")
Query FactorSource() As %Query(ROWSPEC = "DiagFactorDR,DiagFactorDesc")
{
}

ClassMethod FactorSourceExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
	s DiagFactorID = ""
	for
	{
		s DiagFactorID = $o(^User.DHCDSSDiagFactorDictD(DiagFactorID),-1)
		q:DiagFactorID=""
		s DiagFactorDR = DiagFactorID
		s DiagFactorDesc = $lg($g(^User.DHCDSSDiagFactorDictD(DiagFactorID)),3)
		d OutputRow8
	}
    
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiagFactorDR,DiagFactorDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FactorSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod FactorSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FactorSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// DiffDiagSource
/// 返回疾病list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","DiffDiagSource")
Query DiffDiagSource() As %Query(ROWSPEC = "DiffDiagDR,DiffDiagDesc")
{
}

ClassMethod DiffDiagSourceExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
	s DiagID = 0
	for
	{
		s DiagID = $o(^User.DHCDSSDiseaseDictD(DiagID))
		q:DiagID=""
		s DiffDiagDR = DiagID
		s DiffDiagDesc = $lg($g(^User.DHCDSSDiseaseDictD(DiagID)),3)
		d OutputRow8
	}
    
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DiffDiagDR,DiffDiagDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DiffDiagSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod DiffDiagSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiffDiagSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 修改疾病关联诊断因子数据
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).OpenJFData("1")
ClassMethod OpenJFData(id As %String)
{
	s str=""
	s eobj = ##class(web.Entity.CDSS.DHCDSSDiseJoinFactor).%New()
	SET $NAMESPACE="DHCDSS"	
	s eobj.RowId = id
	s FactorID = $LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),5)
	s eobj.DiagFactorDR = FactorID
	s eobj.DiagFactorDesc =$LISTGET($G(^User.DHCDSSDiagFactorDictD(FactorID)),3)
	s eobj.ShowContinueTime = $LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),3)
	s eobj.DiagFactorGrade=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),4)
	
	s eobj.DiagFactorWeights=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),6)

	s eobj.DiagFactorType=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),7)
	s eobj.DiagFactorValOperator=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),8)
	s eobj.DiagFactorValMin=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),9)
	s eobj.DiagFactorValMax=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),10)
	s eobj.UseFlag=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),11)
	s eobj.Remarks2=$LISTGET($G(^User.DHCDSSDiseJoinFactorD(id)),12)
	/*s eobj.MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),3))
	s eobj.MKBTPYCode=$LISTGET($G(^User.MKBTermD(id)),6)
	s eobj.MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),7))
	s eobj.MKBTNote=##class(web.BDP.util.String).Replace(eobj.MKBTNote,"<br/>","\n")
	s eobj.Remarks=$LISTGET($G(^User.MKBTermD(id)),5)
	
	SET $NAMESPACE="DHC-APP"
	s eobj.DiagFactorDesc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(eobj.DiagFactorDesc)
	s:eobj.DiagFactorGrade'="" eobj.DiagFactorGrade = $FNUMBer(eobj.DiagFactorGrade,"T")
	s:eobj.DiagFactorWeights'="" eobj.DiagFactorWeights = $FNUMBer(eobj.DiagFactorWeights,"T")
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// 修改诊断因子字典表数据
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).OpenDiagFactor("1")
ClassMethod OpenDiagFactor(id As %String)
{
	s str=""	
	s eobj = ##class(web.Entity.CDSS.DHCDSSDiagFactorDict).%New()
	SET $NAMESPACE="DHCDSS"
	s eobj.RowId = id
	s eobj.DiagFactorName = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),3)
	s eobj.DiagFactorClass = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),4)
	s eobj.DiagFactorGrade = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),5)
	s eobj.DiagFactorValue = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),6)
	s eobj.DiagFactorBodyPartDR = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),7)
	s eobj.UseFlag = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),8)
	s eobj.Remarks = $LISTGET($G(^User.DHCDSSDiagFactorDictD(id)),11)
	
	/*s eobj.MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),3))
	s eobj.MKBTPYCode=$LISTGET($G(^User.MKBTermD(id)),6)
	s eobj.MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),7))
	s eobj.MKBTNote=##class(web.BDP.util.String).Replace(eobj.MKBTNote,"<br/>","\n")
	s eobj.Remarks=$LISTGET($G(^User.MKBTermD(id)),5)
	
	SET $NAMESPACE="DHC-APP"
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// 修改疾病字典表数据
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).OpenDisease("1")
ClassMethod OpenDisease(id As %String)
{
	s str=""	
	s eobj = ##class(web.Entity.CDSS.DHCDSSDiseaseDict).%New()
	SET $NAMESPACE="DHCDSS"
	s eobj.RowId = id
    s eobj.DiseaseCode = $lg($g(^User.DHCDSSDiseaseDictD(id)),2)
    s eobj.DiseaseName = $lg($g(^User.DHCDSSDiseaseDictD(id)),3)
    s eobj.DiseaseEnName = $lg($g(^User.DHCDSSDiseaseDictD(id)),4)
    s eobj.DiseaseDeptName = $lg($g(^User.DHCDSSDiseaseDictD(id)),6)
    s eobj.DiseaseAliasName = $lg($g(^User.DHCDSSDiseaseDictD(id)),7)
	s eobj.ICD9Code = $lg($g(^User.DHCDSSDiseaseDictD(id)),10)
	s eobj.ICD9Name = $lg($g(^User.DHCDSSDiseaseDictD(id)),11)
	s eobj.ICD10Code = $lg($g(^User.DHCDSSDiseaseDictD(id)),12)
	s eobj.ICD10Name = $lg($g(^User.DHCDSSDiseaseDictD(id)),13)
	s eobj.ICD10LocalCode = $lg($g(^User.DHCDSSDiseaseDictD(id)),14)
	s eobj.ICD10LocaName= $lg($g(^User.DHCDSSDiseaseDictD(id)),15)
	s eobj.ICD11Code = $lg($g(^User.DHCDSSDiseaseDictD(id)),16)
	s eobj.ICD11Name = $lg($g(^User.DHCDSSDiseaseDictD(id)),17)
	s eobj.Remarks1 = $lg($g(^User.DHCDSSDiseaseDictD(id)),22)
	/*s eobj.MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),3))
	s eobj.MKBTPYCode=$LISTGET($G(^User.MKBTermD(id)),6)
	s eobj.MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),7))
	s eobj.MKBTNote=##class(web.BDP.util.String).Replace(eobj.MKBTNote,"<br/>","\n")
	s eobj.Remarks=$LISTGET($G(^User.MKBTermD(id)),5)
	
	SET $NAMESPACE="DHC-APP"
	s str = eobj.JsonS()
	d eobj.%Close()

	q str
}

/// 修改疾病关联鉴别诊断数据
/// w ##class(web.DHCBL.MKB.MKBEChartsInterface).OpenJDData("1")
ClassMethod OpenJDData(id As %String)
{
	s str=""	
	s eobj = ##class(web.Entity.CDSS.DHCDSSDiseJoinDiffDiag).%New()
	SET $NAMESPACE="DHCDSS"
	s eobj.RowId = id
	s eobj.DiseaseDR = $LISTGET($G(^User.DHCDSSDiseJoinDiffDiagD(id)),2)
	s eobj.DiffDiagNum = $LISTGET($G(^User.DHCDSSDiseJoinDiffDiagD(id)),3)
	s eobj.DiffDiagDR = $LISTGET($G(^User.DHCDSSDiseJoinDiffDiagD(id)),4)
	s eobj.DiffDiagDesc = $LISTGET($G(^User.DHCDSSDiseaseDictD(eobj.DiffDiagDR)),3)
	s eobj.UseFlag = $LISTGET($G(^User.DHCDSSDiseJoinDiffDiagD(id)),6)
	s eobj.Remarks3 = $LISTGET($G(^User.DHCDSSDiseJoinDiffDiagD(id)),7)
	
	/*s eobj.MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),3))
	s eobj.MKBTPYCode=$LISTGET($G(^User.MKBTermD(id)),6)
	s eobj.MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB($LISTGET($G(^User.MKBTermD(id)),7))
	s eobj.MKBTNote=##class(web.BDP.util.String).Replace(eobj.MKBTNote,"<br/>","\n")
	s eobj.Remarks=$LISTGET($G(^User.MKBTermD(id)),5)
	
	SET $NAMESPACE="DHC-APP"
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// 保存诊断因子字典表数据
ClassMethod SaveDiagFactor(eobj As web.Entity.CDSS.DHCDSSDiagFactorDict)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.DHCDSSDiagFactorDict).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.DHCDSSDiagFactorDict).%OpenId(eobj.RowId)
		}
		
		s obj.DiagFactorName = eobj.DiagFactorName
		s obj.DiagFactorClass = eobj.DiagFactorClass
		s obj.DiagFactorGrade = eobj.DiagFactorGrade
		s obj.DiagFactorValue = eobj.DiagFactorValue
		s obj.Remarks = eobj.Remarks
		if (obj.DiagFactorCode="")
		{	
			s dataid = $o(^User.DHCDSSDiagFactorDictD(" "),-1)
			s code = $lg($g(^User.DHCDSSDiagFactorDictD(dataid)),2)
			s obj.DiagFactorCode = code+1
		}
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
			
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 保存疾病字典表数据
ClassMethod SaveDisease(eobj As web.Entity.CDSS.DHCDSSDiseaseDict)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.DHCDSSDiseaseDict).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.DHCDSSDiseaseDict).%OpenId(eobj.RowId)
		}
		
		s obj.DiseaseCode = eobj.DiseaseCode
		s obj.DiseaseName = eobj.DiseaseName
		s obj.DiseaseEnName = eobj.DiseaseEnName
		s obj.DiseaseDeptName = eobj.DiseaseDeptName
		s obj.DiseaseAliasName = eobj.DiseaseAliasName
		s obj.ICD9Code = eobj.ICD9Code
		s obj.ICD9Name = eobj.ICD9Name
		s obj.ICD10Code = eobj.ICD10Code
		s obj.ICD10Name = eobj.ICD10Name
		s obj.ICD10LocalCode = eobj.ICD10LocalCode
		s obj.ICD10LocaName = eobj.ICD10LocaName
		s obj.ICD11Code = eobj.ICD11Code
		s obj.ICD11Name = eobj.ICD11Name
		s obj.Remarks = eobj.Remarks1
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
			
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 保存疾病关联诊断因子表数据
ClassMethod SaveJFData(eobj As web.Entity.CDSS.DHCDSSDiseJoinFactor)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.DHCDSSDiseJoinFactor).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.DHCDSSDiseJoinFactor).%OpenId(eobj.RowId)
		}
		d:eobj.DiagFactorDR'="" obj.DiagFactorDRSetObjectId(eobj.DiagFactorDR)
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		s obj.ShowContinueTime = eobj.ShowContinueTime
		s obj.DiagFactorGrade =$Zstrip(eobj.DiagFactorGrade,"<>W")
		s obj.DiagFactorType = eobj.DiagFactorType
		s obj.DiagFactorValMax = eobj.DiagFactorValMax
		s obj.DiagFactorValMin = eobj.DiagFactorValMin
		s obj.DiagFactorValOperator = eobj.DiagFactorValOperator
		s obj.DiagFactorWeights = $Zstrip(eobj.DiagFactorWeights,"<>W")
		s obj.Remarks = eobj.Remarks2
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
			
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 保存疾病关联鉴别诊断表数据
ClassMethod SaveJDData(eobj As web.Entity.CDSS.DHCDSSDiseJoinDiffDiag)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.DHCDSSDiseJoinDiffDiag).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.DHCDSSDiseJoinDiffDiag).%OpenId(eobj.RowId)
		}
		d:eobj.DiffDiagDR'="" obj.DiffDiagDRSetObjectId(eobj.DiffDiagDR)
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		s difid = eobj.DiffDiagDR
		s:eobj.DiffDiagDR="" difid="空"
		s obj.Remarks =eobj.Remarks3
		s obj.DiffDiagNum = eobj.DiffDiagNum
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败',difid:'"_difid_"'}"   //返回错误信息
		}
			
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 删除诊断因子字典表数据
ClassMethod DeleteDiagFactor(id As %String)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	Ts
	s sc=##class(User.DHCDSSDiagFactorDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 删除疾病字典表数据
ClassMethod DeleteDisease(id As %String)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	Ts
	s sc=##class(User.DHCDSSDiseaseDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 删除关联诊断因子
ClassMethod DeleteJoinFactor(id As %String)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	Ts
	s sc=##class(User.DHCDSSDiseJoinFactor).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	SET $NAMESPACE="DHC-APP"
	q result
}

/// 删除关联鉴别诊断
ClassMethod DeleteJoinDiffDiag(id As %String)
{
	s result=""
	SET $NAMESPACE="DHCDSS"
	Ts
	s sc=##class(User.DHCDSSDiseJoinDiffDiag).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	SET $NAMESPACE="DHC-APP"
	q result
}
/*
/// 12.18 全局化词表导入 知识库名、公有属性名、中心词、私有属性名
/// 
/// CDSS界面接口
/// 
/// Creator:范文凯
/// CreatDate:2019-10-28
/// Description：获取开立诊断数据类型列表   返回符合医院的数据类型 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","GetCDSSCenterWord","红色")
Query GetCDSSCenterWord(desc As %String) As %Query(ROWSPEC = "CDSSDiagFactorRowId,DiagFactorCode,DiagFactorDesc,DiagFactorClass,DiagFactorGrade,DiagFactorValue,DiagFactorBodyPartDR,UseFlag,CreateDate,CreateUserID,Remarks")
{
}

ClassMethod GetCDSSCenterWordExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	SET $NAMESPACE="DHCDSS"
 	if (desc="")
 	{
 		s CDSSDiagFactorRowId=0
 		for
 		{
	 		s CDSSDiagFactorRowId = $o(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId))
	 		q:CDSSDiagFactorRowId=""
	 		s DiagFactorCode = $lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),2)
	 		s DiagFactorDesc=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),3)
	 		s DiagFactorClass=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),4)
	 		s DiagFactorGrade=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),5)
	 		s DiagFactorValue=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),6)
	 		s DiagFactorBodyPartDR=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),7)
	 		s UseFlag=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),8)
	 		s CreateDate=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),9)
	 		s CreateUserID=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),10)
	 		s Remarks=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),11)
	 		d OutputRow8
		}
 	}
 	else
 	{
	 	s CDSSDiagFactorRowId = 0
	 	for
	 	{
		 	s CDSSDiagFactorRowId = $o(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId))
		 	q:CDSSDiagFactorRowId=""
		 	s DiagFactorDesc=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),3)
		 	if (DiagFactorDesc[desc)
		 	{
			 	s DiagFactorCode = $lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),2)
			 	s DiagFactorClass=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),4)
	 			s DiagFactorGrade=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),5)
	 			s DiagFactorValue=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),6)
	 			s DiagFactorBodyPartDR=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),7)
	 			s UseFlag=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),8)
	 			s CreateDate=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),9)
	 			s CreateUserID=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),10)
	 			s Remarks=$lg($g(^User.DHCDSSDiagFactorDictD(CDSSDiagFactorRowId)),11)
			 	d OutputRow8
			}
		}
	}
    SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CDSSDiagFactorRowId,DiagFactorCode,DiagFactorDesc,DiagFactorClass,DiagFactorGrade,DiagFactorValue,DiagFactorBodyPartDR,UseFlag,CreateDate,CreateUserID,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCDSSCenterWordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetCDSSCenterWordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCDSSCenterWordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
/// CDSS相关代码
/// Creator:范文凯
/// CreatDate:2020-02-11
/// Description：医为百科访问日志Echarts接口
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).EncyclopediaNumDay("65420")
ClassMethod EncyclopediaNumDay(dateto)
{
	s result = 0
	s ID =0
	s V=0
	s R=0
	s D=0
	s enddate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml((dateto))
    for 
	{
		s ID =  $o(^User.BDPVisitLogI("DateTypeIndex",dateto,"V",ID))
		q:ID=""
		s V = V+1
	}
	for 
	{
		s ID =  $o(^User.BDPVisitLogI("DateTypeIndex",dateto,"R",ID))
		q:ID=""
		s R = R+1
	}
	for 
	{
		s ID =  $o(^User.BDPVisitLogI("DateTypeIndex",dateto,"D",ID))
		q:ID=""
		s D = D+1
	}
	q enddate_","_V_"^"_R_"^"_D
}

/// Creator:范文凯
/// CreatDate:2020-02-20
/// Description：Echarts个人每日维护表数据接口
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).EncyclopediaInterface("2020-02-08","2020-02-11")
ClassMethod EncyclopediaInterface(startdate, enddate)
{
   
    s date =""
    s num =""
    s V=""
    s R=""
    s D=""
    s Startdate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(startdate)
	s Enddate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(enddate)
	for i=Startdate:1:Enddate
	{
		 s str = ..EncyclopediaNumDay(i)
		 s date = date_$p(str,",",1)_" "
		 //s num = num_$p(str,",",2)_" "  
		 s num=$p(str,",",2)
		 s V  = V_$p(num,"^",1)_" "
		 s R  = R_$p(num,"^",2)_" "
		 s D  = D_$p(num,"^",3)_" "
		 
	}
	s date = $zstrip(date,"<>W")
	s V = $zstrip(V,"<>W")
	s R = $zstrip(R,"<>W")
	s D = $zstrip(D,"<>W")
	s result =date_" "_V_" "_R_" "_D
	q result
}

/// 2020-02-07
/// 为数据处理工厂 操作人占比Echarts图 提供数据
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).OperatorsData("1")
ClassMethod OperatorsData(HospitalID As %String)
{
	k ^TMPOperatorsData
	k ^TMPOperatorsName
	s ^TMPOperatorsData=""
	s ^TMPOperatorsName=""
	s StructuredDataID = 0
	s nullnumber = 0
	s othernumber = 0
	for
	{
		s StructuredDataID = $o(^User.MKBStructuredDataI("BaseIndex",HospitalID,StructuredDataID))
		q:StructuredDataID=""
		s MKBSDUpdateUser = $lg($g(^User.MKBStructuredDataD(StructuredDataID)),8)
		s:MKBSDUpdateUser="" nullnumber=nullnumber+1
		continue:MKBSDUpdateUser=""
		if ($d(^TMPOperatorsData(MKBSDUpdateUser)))
		{
			s ^TMPOperatorsData(MKBSDUpdateUser) = $g(^TMPOperatorsData(MKBSDUpdateUser))+1
		}
		else
		{
			s ^TMPOperatorsData(MKBSDUpdateUser)=1
		}
	}
	s UserID = 0
	for
	{
		s UserID = $o(^TMPOperatorsData(UserID))
		q:UserID=""
		s UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
		continue:UserName=""
		//continue:$g(^TMPOperatorsData(UserID))<50
		s:(UserID'=6482)&(UserID'=6479)&(UserID'=6470)&(UserID'=6468) othernumber=othernumber+1
		continue:(UserID'=6482)&(UserID'=6479)&(UserID'=6470)&(UserID'=6468)
		s ^TMPOperatorsName(UserName)=$g(^TMPOperatorsData(UserID))	
	}
	if (nullnumber'=0)
	{
		s ^TMPOperatorsName("空")=nullnumber
	}
	if (othernumber'=0)
	{
		s ^TMPOperatorsName("其他")=othernumber
	}
	q "yes"
}

/// 2020-02-07
/// 提供legenddata图例数据
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).OperatorsLegend()
ClassMethod OperatorsLegend()
{
	/*
	s ID = 0
	s result="["
 	for
 	{
	 	s ID =$o(^User.MKBStructuredBaseD(ID))
		q:ID=""
		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(ID)),2)
		s result= result_"{text:'"_MKBSTBDesc_"',id:'"_ID_"'}^"
	}
	s result=$e(result,0,*-1)
	q result_"]"
	['结构化诊断未匹配', 'ICD编码未匹配', '全匹配'],
	*/
	s UserName =0
	s result="["
	for
	{
		s UserName = $o(^TMPOperatorsName(UserName))
		q:UserName=""
		s result=result_"'"_UserName_"',"
	}
	s result=$e(result,0,*-1)
	q result_"]"
}

/// Creator:范文凯
/// CreatDate:2020-02-07
/// Description：提供legenddata图例数据  
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","OperatorsLegend")
Query OperatorsLegend() As %Query(ROWSPEC = "UserName")
{
}

ClassMethod OperatorsLegendExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s UserName =0
	for
	{
		s UserName = $o(^TMPOperatorsName(UserName))
		q:UserName=""
		d OutputRow8 
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OperatorsLegendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod OperatorsLegendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperatorsLegendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2020-02-07
/// 提供legenddata图例数据
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).OperatorsDetail()
ClassMethod OperatorsDetail()
{
	/*
	s ID = 0
	s result="["
 	for
 	{
	 	s ID =$o(^User.MKBStructuredBaseD(ID))
		q:ID=""
		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(ID)),2)
		s result= result_"{text:'"_MKBSTBDesc_"',id:'"_ID_"'}^"
	}
	s result=$e(result,0,*-1)
	q result_"]"
	['结构化诊断未匹配', 'ICD编码未匹配', '全匹配'],
	*/
	s UserName =0
	s result="["
	for
	{
		s UserName = $o(^TMPOperatorsName(UserName))
		q:UserName=""
		s Number =$g(^TMPOperatorsName(UserName))
		s result=result_"{value:'"_Number_"',name:'"_UserName_"'}^"
	}
	s result=$e(result,0,*-1)
	q result_"]"
}

/// Creator:范文凯
/// CreatDate:2020-02-07
/// Description：提供legenddata详细数据  
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEChartsInterface","OperatorsData")
Query OperatorsData() As %Query(ROWSPEC = "UserName,Number")
{
}

ClassMethod OperatorsDataExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s UserName =0
	for
	{
		s UserName = $o(^TMPOperatorsName(UserName))
		q:UserName=""
		s Number =$g(^TMPOperatorsName(UserName))
		d OutputRow8 
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(UserName,Number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OperatorsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod OperatorsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperatorsDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2020-07-21
/// Description：提供评估表MKB-CDSS的对照
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).MKBAssessmentToCDSS()
ClassMethod MKBAssessmentToCDSS()
{
	Ts
	k ^User.DHCDSSRatingScaleDictI
	k ^User.DHCDSSRatingScaleDictD
	s AssessmentBaseID = 0
	for
	{
		s AssessmentBaseID = $o(^User.MKBAssessmentBaseD(AssessmentBaseID))
		q:AssessmentBaseID=""
		s mkbobj = ##class(User.MKBAssessmentBase).%OpenId(AssessmentBaseID)
		s cdssobj = ##class(User.DHCDSSRatingScaleDict).%New()
		s cdssobj.MKBAssessmentDR = AssessmentBaseID
		s cdssobj.RatingScaleCode = mkbobj.MKBABCode
		s cdssobj.RatingScaleName = mkbobj.MKBABDesc
		s cdssobj.Remarks = mkbobj.MKBABNote
		d cdssobj.%Save()
	}
	q ""
}

/// 编写数据导入 导入协和诊断数据 
/// 添加了 icd描述字段
/// Other:w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportHXLData("D:\YDYSJ\锦江院区生殖男科.csv","7")
ClassMethod ImportHXLData(path, basedr)
{
	;s basedr = 3
	s result = ""
	s res = ""
	s sc=0
	s sc1=0
	s stop = 0
	s num = 0
	Ts 
	;s file=##class(%File).%New("D:\协和测试\YDYtestL1.csv")
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{   
	    s sc=0
		s sc1=0
		s str =file.ReadLine()
		if (str=",")                                   //如果数据中存在空行，则跳出本次循环，继续读取下一行
		{
			continue
		}
		if (str = "")                                  //如果数据已经读完，则跳出循环 
		{
			q                             
		}
		s loc = $p(str,",",1)                          //取到表格中的科室
		s diag =$p(str,",",2)                          //取到表格中的诊断
		s loc = $Zstrip(loc,"<>W")                     //去空格，符号处理
		s diag = $Zstrip(diag,"<>W")
		;s IcdDesc =$Zstrip(IcdDesc,"<>W")
		s diag=$Replace(diag,")","）")
		s diag=$Replace(diag,"(","（")
		s diag=$Replace(diag,",","，")
		;s IcdDesc=diag
		;s IcdDesc=$Replace(IcdDesc,")","）")
		;s IcdDesc=$Replace(IcdDesc,"(","（")
		;s IcdDesc=$Replace(IcdDesc,",","，")
		
		
		
		/*
		k ^TmpIcdDesc                                    //临时global 用于存一行中的多个icd描述
		do
		{
			s n = $LOCATE(IcdDesc,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s IcdDesc = $p(IcdDesc,"[",1)
				s ^TmpIcdDesc(IcdDesc)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s IcdDesc = $e(IcdDesc,0,n-1)                       //返回值不为0，取出相应的位置
				s ICDDesc = $p(IcdDesc,"[",1)
				s ^TmpIcdDesc(ICDDesc)=""
				s IcdDesc = $e(IcdDesc,n+1,*-0)
			}
			
		}while(n'=0)
		
		*/
		
		//取diag
		k ^Tmpdiag                                     //临时global 用于存一行中的多个诊断
		do
		{
			s n = $LOCATE(diag,"(;[0-9])+")                   //正则表达式，取;2的位置
			if (n=0)
			{
				s ^Tmpdiag(diag)=""                           //返回值为0  说明没有  ;加数字  则全取
			}
			else
			{
				s Diag = $e(diag,0,n-1)                       //返回值不为0，取出相应的位置
				s ^Tmpdiag(Diag)=""
				s diag = $e(diag,n+1,*-0)
			}
			
		}while(n'=0)
		s diagi=0                                          //用于对^Tmpdiag 的循环 
		;s icddesc = 0
		for
		{
			s diagi = $o(^Tmpdiag(diagi))
			//w diagi,!
			q:diagi=""
			;s icddesc = $o(^TmpIcdDesc(icddesc))
			//	
			
			s Diagi = $e(diagi,4,*-0)                         //对诊断进行处理， 去掉"1. "的部分 
			;s icddesci =  $e(icddesc,4,*-0)   
			;s Diagi = $Zstrip(Diagi,"<>W")
			s Diagi = $tr(Diagi," ","")
			;s icddesci =$tr(icddesci," ","")
			

			if (Diagi="")
			{
				continue
			}
			s diagindex =" "_Diagi                            //满足索引里的诊断前面加空格
			s diagindex = $ZCONVERT(diagindex,"U")
		    s tmp = $d(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex))    //判断该诊断是否存在
		    if (tmp=0)                                                            //该诊断不存在
		    {   
			    s sc=0
			    s sc1=0
			    s obj=##class(User.MKBStructuredData).%New()
			    s obj.MKBSDDiag = Diagi
			    d obj.MKBSDBaseDrSetObjectId(basedr)
			    s obj.MKBSDDiaSource = "出院"
			    s diagpy =  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diagi)
			    s obj.MKBSDDiagPYCode = diagpy
			    s obj.MKBSDStatus = "N"
			    s obj.MKBSDTotalFreq = 1
			    s sc=obj.%Save()
			    s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
			    if (sc=1)
			    {
			    	s zobj = ##class(User.MKBStructuredDataLoc).%New()
			    	;s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))   //获得诊断id
			    	d zobj.MKBSDStructDataSetObjectId(id)
			    	s zobj.MKBSDLoc =loc
			    	s zobj.MKBSDLocSource = "L"
			    	s zobj.MKBSDFrequency = 1
			        s sc1=zobj.%Save()
			        if (sc=1)&(sc1=1)
			        {
				        ;s ^TempDiag(id)=Diagi
				    }
				    else
				    {
					   s stop=1
					   if (stop=1)
					   //{b}
					}
			    }
			}
			else                                                                  //该诊断存在
			{   
			    s sc = 0
			    ;s sc1=0
				s id = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr,diagindex,0))
				s obj=##class(User.MKBStructuredData).%OpenId(id)
				s freq = obj.MKBSDTotalFreq
			    s obj.MKBSDTotalFreq = freq + 1
			    s sc=obj.%Save()
			    if (sc=1)
			    {
				    s diaglocindex = 0
				    for
				    {
				    	s diaglocindex = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex))
				    	q:diaglocindex=""
				    	s diagloc =$Zstrip(diaglocindex,"<>W")
				    	if (loc=diagloc)                     //该诊断的科室已经存在  频次+1
				    	{
					    	w num+1 ,!
					    	w diagindex ,!
					    	s diagfreq = 0
					    	s childsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",id,diaglocindex,0))
					    	s zobjid = id_"||"_childsub
					    	s zobj = ##class(User.MKBStructuredDataLoc).%OpenId(zobjid)
					    	s diagfreq = zobj.MKBSDFrequency 
					    	s zobj.MKBSDFrequency=diagfreq+1
					    	s zobj.DiagName = diagindex
					    	s sc1=zobj.%Save()
					    	if (sc=1)&(sc1=1)
			        		{	
				    		}
				    		else
				    		{
					    		s stop=1
					    		if (stop=1)
					    		//{b}
					    	}	
					    	
					    }
				    }
				    if (sc1'=1)           //该诊断的科室不存在， 需要填新的科室
				    {
					    w num +1 ,!
					    s zobj = ##class(User.MKBStructuredDataLoc).%New()
					    s zobj.MKBSDFrequency=1
					    s zobj.MKBSDLoc=loc
					    s zobj.MKBSDLocSource="L"
					    d zobj.MKBSDStructDataSetObjectId(id)
					    s zobj.DiagName = diagindex
					    s sc1 = zobj.%Save()
					    if (sc=1)&(sc1=1)
			        	{
				        		
				    	}
				    	else
				    	{
					    	s stop=1
					    	if (stop=1)
					    	//{b}
					    }	
					} 
				}
			}
		}		
	}
	b
	if (stop=0)
	{
		//TC  
		s result ="导入成功"
	}
	else
	{
		Trollback
		s result ="导入失败"
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-3-10
/// Description：导入数据到处理工厂
/// Table:User.MKBStructuredData
/// Input： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).ImportStructuredData("")
ClassMethod ImportStructuredData(path, base) As %String
{
	s savecount=0
	s nosavecount=0
	s continuecount=0
	s existcount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s num=0
	k myFileAry
	
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		//诊断代码^诊断名称^诊断ICD10^开始日期^结束日期^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志
		//^HIS RowId^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）^诊断类型描述^性别描述^开始年龄^结束年龄^副编码^ICD9代码^注释^国家标准名称
		s splitsymbol=$c(9)
		s:$l(data,"^")>=4 splitsymbol="^"
		s DataCode=$p(data,splitsymbol,1)	//诊断代码
		s DataDesc=$p(data,splitsymbol,2)	//诊断名称
		if (DataDesc="") 
		{
			s continuecount=continuecount+1
			continue
		}
		s ICDCode=$p(data,splitsymbol,3)	//诊断ICD10
		if ((ICDCode="")&&(DataCode=""))
		{
			s continuecount=continuecount+1
			continue
		}
		s:ICDCode["?" ICDCode=$tr(ICDCode,"?","†")		//替换特殊符号小剑
		s StartDate=$p(data,splitsymbol,4)	//开始日期
		s EndDate=$p(data,splitsymbol,5)	//结束日期
		if (StartDate'="")
		{
			s StartDate=$p(StartDate," ",1)
			s StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			s:StartDate="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate)
			//##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate) 
		}
		if (EndDate'="")
		{
			s EndDate=$p(EndDate," ",1)
			s EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			s:EndDate="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过滤过期数据
		{
			//2018/7/5 0:00:00
			s continuecount=continuecount+1
			continue	
			
		}
		
		s IsCFlag=$p(data,splitsymbol,6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,splitsymbol,7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,splitsymbol,8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,splitsymbol,9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		
		s HisRowID=$p(data,splitsymbol,10)	//his诊断ID
		s ClinicType=$p(data,splitsymbol,11)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
		s Classification=$p(data,splitsymbol,12)		//icd诊断分类
		s LimitSex=$p(data,splitsymbol,13)		//限制性别
		s AgeFrom=$p(data,splitsymbol,14)		// 从年龄
		s AgeTo=$p(data,splitsymbol,15)		//到年龄
		s DeputyCode=$p(data,splitsymbol,16)	//icd10副编码
		s ICD9Code=$p(data,splitsymbol,17)		//icd9代码
		s:ICD9Code["?" ICD9Code=$tr(ICD9Code,"?","†")		//替换特殊符号小剑
		s HisRemark=$p(data,splitsymbol,18)		//注释
		s NationalDesc=$p(data,splitsymbol,19)	// 国家标准名称
				
		
		//s Remark=IsCFlag_"#"_IsCType_"#"_CodeFlag_"#"_ReasonFlag
		//Index HisIDIndex On (MKBSDBaseDr, MKBSDHisRowID As Exact);
		if (HisRowID="")
		{
			s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,ICDCode,0))
		}
		else
		{
			s StructureID = $o(^User.MKBStructuredDataI("HisIDIndex",base,HisRowID,"")) 
		}
		//s StructureID = $o(^User.MKBStructuredDataI("HisIDIndex",base,HisRowID,""))    //判断该诊断是否存在
		if (StructureID="")
		{
			//Index NumberIndex On MKBICDConNumber;
			s obj=##class(User.MKBStructuredData).%New()		//保存到父表
		    s obj.MKBSDDiag = DataDesc
		    d obj.MKBSDBaseDrSetObjectId(base)
		    s obj.MKBSDDiaSource = "HIS诊断"
		    s obj.MKBSDICD = ICDCode
		    s obj.MKBSDICDDesc = DataDesc
		    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DataDesc)
		    s obj.MKBSDStatus = "N"
		    s obj.MKBSDTotalFreq = "0"
		    s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
			s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
			s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
			s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
			s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
			s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
			
			s obj.MKBSDHisRowID=HisRowID	//his诊断ID
			s obj.MKBSDHisCode=DataCode		//HIS诊断代码
			s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
			s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
			s obj.MKBSDClassification=Classification		//icd诊断分类
			s obj.MKBSDLimitSex=LimitSex		//限制性别
			s obj.MKBSDHisRemark=HisRemark		//注释
			s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
			s obj.MKBSDAgeTo=AgeTo		//到年龄
			s obj.MKBSDICD9Code=ICD9Code		//icd9代码
			s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称

		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s savecount=savecount+1
			    w !,savecount
			    s id = obj.%Id()
			    d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		    }
		    else
		    {
			    s re=$system.OBJ.DisplayError(sc)
			    s nosavecount=nosavecount+1
		    }
		    
		}
		else
		{
			s existcount=existcount+1
			s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
		    s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
			s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
			s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
			s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
			s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
			s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
			s:obj.MKBSDNote["N" obj.MKBSDNote=""
			
			s obj.MKBSDHisRowID=HisRowID	//his诊断ID
			s obj.MKBSDHisCode=DataCode		//HIS诊断代码
			s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
			s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
			s obj.MKBSDClassification=Classification		//icd诊断分类
			s obj.MKBSDLimitSex=LimitSex		//限制性别
			s obj.MKBSDHisRemark=HisRemark		//注释
			s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
			s obj.MKBSDAgeTo=AgeTo		//到年龄
			s obj.MKBSDICD9Code=ICD9Code		//icd9代码
			s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称
		    s sc=obj.%Save()
		    d obj.%Close()
		}
	}
	c file
	k file
	w "读取数据总共"_(num-1)_"条",!
	
	w "保存成功:"_savecount,!
	w "保存失败:"_nosavecount,!
	w "修改数据："_existcount,!
	w "跳过数据："_continuecount,!
	
	q "{success:'true'}"
}

/// Creator：钟荣枫 
/// CreatDate: 2021-3-10
/// Description：计算科室频率
/// Table:User.MKBStructuredData
/// Input： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBEChartsInterface).CountLocFreq("")
ClassMethod CountLocFreq(path, base) As %String
{
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("RS")
	s num=0
	k myFileAry
	
	s errorflag=0
	TS
	for i=1:1:file.Size 
	{
		s data=file.ReadLine()
		if (data="")
		{
			if (i<=5)
			{
				continue
			}
			else
			{
				q	
			}
			
		}
		s num=num+1
		continue:num=1  //跳过第一行
		s data=$Replace(data,"\","\\")
		s myFileAry(i)=data
		//continue:num<242690
		//s data="0001602834^周小平^男^1956-08-29^市医保^2020-10-17^肿瘤科忠山一病区^1. 右肺恶性肿瘤;2. 为肿瘤化学治疗疗程;3. 恶性肿瘤靶向治疗;4. 肾上腺继发性恶性肿瘤[肺癌左肾上腺转移];5. 咳嗽;6. 骨继发恶性肿瘤[肺癌骨转移];7. 疼痛[中度癌痛];8. 支气管或肺恶性肿瘤[右肺腺癌伴肺门、纵隔淋巴结、左肾上腺、多发骨转移（cT4N2M1c IVB期）];9. 化疗后骨髓抑制;10. 白细胞减少;11. 为肿瘤化学治疗疗程;12. 恶性肿瘤靶向治疗;13. 肾上腺继发性恶性肿瘤[肺癌左肾上腺转移];14. 咳嗽;15. 骨继发恶性肿瘤[肺癌骨转移];16. 疼痛[中度癌痛];17. 支气管或肺恶性肿瘤[右肺腺癌伴肺门、纵隔淋巴结、左肾上腺、多发骨转移（cT4N2M1c IVB期）];18. 化疗后骨髓抑制;19. 白细胞减少;20. 白细胞减少;21. 化疗后骨髓抑制;22. 支气管或肺恶性肿瘤[右肺腺癌伴肺门、纵隔淋巴结、左肾上腺、多发骨转移（cT4N2M1c IVB期）];23. 疼痛[中度癌痛];24. 骨继发恶性肿瘤[肺癌骨转移];25. 咳嗽;26. 肾上腺继发性恶性肿瘤[肺癌左肾上腺转移];27. 恶性肿瘤靶向治疗;28. 为肿瘤化学治疗疗程^1. C34.900x005;2. Z51.100;3. Z51.801;4. C79.700;5. R05.x00;6. C79.500x001;7. R52.900;8. C34.900;9. D61.101;10. D70.x04;11. Z51.100;12. Z51.801;13. C79.700;14. R05.x00;15. C79.500x001;16. R52.900;17. C34.900;18. D61.101;19. D70.x04;20. D70.x04;21. D61.101;22. C34.900;23. R52.900;24. C79.500x001;25. R05.x00;26. C79.700;27. Z51.801;28. Z51.100^1. 右肺恶性肿瘤;2. 为肿瘤化学治疗疗程;3. 恶性肿瘤靶向治疗;4. 肾上腺继发性恶性肿瘤;5. 咳嗽;6. 骨继发恶性肿瘤;7. 疼痛;8. 支气管或肺恶性肿瘤;9. 化疗后骨髓抑制;10. 白细胞减少;11. 为肿瘤化学治疗疗程;12. 恶性肿瘤靶向治疗;13. 肾上腺继发性恶性肿瘤;14. 咳嗽;15. 骨继发恶性肿瘤;16. 疼痛;17. 支气管或肺恶性肿瘤;18. 化疗后骨髓抑制;19. 白细胞减少;20. 白细胞减少;21. 化疗后骨髓抑制;22. 支气管或肺恶性肿瘤;23. 疼痛;24. 骨继发恶性肿瘤;25. 咳嗽;26. 肾上腺继发性恶性肿瘤;27. 恶性肿瘤靶向治疗;28. 为肿瘤化学治疗疗程0001757953^李先华^男^1968-03-04^市医保^2020-10-17^感染呼吸科病区(忠山院区)^1. 继发性肺结核;2. 预防肝功能损伤;3. 继发性肺结核[涂（+）DNA(+)初治];4. 结核性胸膜炎[伴胸腔积液];5. 支气管扩张伴感染;6. 肝功能不全;7. 电解质代谢紊乱;8. 肝功能不全;9. 支气管扩张伴感染;10. 结核性胸膜炎[伴胸腔积液];11. 电解质代谢紊乱;12. 继发性肺结核[涂（+）DNA(+)初治]^1. A16.200x015;2. 无;3. A16.200x015;4. A16.500x004;5. J47.x03;6. K72.905;7. E87.801;8. K72.905;9. J47.x03;10. A16.500x004;11. E87.801;12. A16.200x015^1. 继发性肺结核;2. 无;3. 继发性肺结核;4. 结核性胸膜炎;5. 支气管扩张伴感染;6. 肝功能不全;7. 电解质代谢紊乱;8. 肝功能不全;9. 支气管扩张伴感染;10. 结核性胸膜炎;11. 电解质代谢紊乱;12. 继发性肺结核"
		//登记号^姓名^性别^出生日期^费别^就诊日期^就诊科室^诊断^ICD编码^ICD描述
		//登记号^姓名^性别^出生日期^费别^就诊日期^就诊科室^就诊类型^诊断^行数
		
		if ($l(data,"^")=10)	//字段之间是用"^"分割
		{
			s Code=$p(data,"^",1)	//登记号
			continue:Code=""
			s PatientID=$p(data,"^",2)		//病人id
			s PatientName=$p(data,"^",3)		//病人名
			continue:((PatientID="")&&(PatientName=""))
			s Loc=$p(data,"^",7)	//就诊科室
			s Diag=$p(data,"^",9)	//诊断
		}
		elseif ($l(data,"，")>=9)	//香港大学深圳医院 字段之间是用"，"分割：source_id，病人号，patient_name，sex_name，birth_date，reg_time，visit_dept_name，就诊类型，diag_name
		{
			s Code=$p(data,"，",1)	//登记号
			continue:Code=""
			s PatientID=$p(data,"，",2)		//病人id
			s PatientName=$p(data,"，",3)		//病人名
			continue:((PatientID="")&&(PatientName=""))
			s Loc=$p(data,"，",7)	//就诊科室
			s Diag=$p(data,"，",9)	//诊断
			
		}
		else
		{
			//数据间用tab分割
			s Code=$p(data,$c(9),1)	//登记号
			continue:Code=""
			s PatientID=$p(data,$c(9),2)		//病人id
			s PatientName=$p(data,$c(9),3)		//病人名
			continue:((PatientID="")&&(PatientName=""))
			s Loc=$p(data,$c(9),7)	//就诊科室
			s Diag=$p(data,$c(9),9)	//诊断
		}
		
		q:errorflag=1
		//[{"number":"1","MRCIDDesc":"诊断1","ICD10":"A00.001","Remarks":"注释","ICDType":"主诊断"},{"number":"2","MRCIDDesc":"诊断2","ICD10":"A00.002","Remarks":"","ICDType":"出院诊断"}]
		w !,num
		
		s jsonstr=[].%FromJSON(Diag)
		for s1=0:1:(jsonstr.%Size()-1)
		{
			s ICDJson=jsonstr.%Get(s1)
			
			s CodePice=ICDJson.%Get("ICD10")		//ICD代码
			s:CodePice["?" CodePice=$tr(CodePice,"?","†")		//替换特殊符号小剑
			s DescPice=ICDJson.%Get("MRCIDDesc")		//ICD描述
			continue:((DescPice="")||(DescPice="无"))
			continue:((CodePice="")||(CodePice="无"))
			s NewDiag =$replace(DescPice," ","")
			s CodePice=$replace(CodePice," ","")
			s NewDiag=##class(web.BDP.util.String).Replace(NewDiag,"""","“")
			
			///// 诊断+ICD编码为唯一索引 2021-04-15
			///Index DiagICDIndex On (MKBSDBaseDr, MKBSDDiag As Exact, MKBSDICD As Exact);
			if ($l(NewDiag)>100) 
			{
				s MKBSDRowid=""
			}
			else
			{
				s MKBSDRowid=$O(^User.MKBStructuredDataI("DiagICDIndex",base,NewDiag,CodePice,""))	
			}
			//w !,"CodePice:"_CodePice
			//w !,"MKBSDRowid:"_MKBSDRowid
			if (MKBSDRowid'="")		//诊断出现频次+1
			{
				s tobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				continue:tobj="" 
				s oldfreq=tobj.MKBSDFrequency
				s:oldfreq="" oldfreq=1
			 	s tobj.MKBSDFrequency = oldfreq+1
			    s mastersc = tobj.%Save()
			    d tobj.%Close()
			    if (mastersc'=1)
			    {
				    s errorflag=1
			    }
			    q:errorflag=1
			    s LOCSsub =$o(^User.MKBStructuredDataLocI("LocIndex"," "_$zconvert(Loc,"U"),MKBSDRowid,""))
			    
				//s LOCSsub = $o(^User.MKBStructuredDataLocI("NewLocIndex",MKBSDRowid," "_$zconvert(Loc,"U"),""))
				if (LOCSsub'="")		//科室频次存在	科室频次加1
				{
					s locid = MKBSDRowid_"||"_LOCSsub
			    	s locobj = ##class(User.MKBStructuredDataLoc).%OpenId(locid)
			    	s freq = locobj.MKBSDFrequency 
			    	s:freq="" freq=1
			    	s locobj.MKBSDFrequency=freq+1
			    	s locsc=locobj.%Save()
			    	d locobj.%Close()
			    	;b ;up
			    	if (locsc'=1)
				    {
					    s errorflag=1
				    }
			    
			
				}
				else
				{
					s locobj = ##class(User.MKBStructuredDataLoc).%New()
				    s locobj.MKBSDFrequency=1
				    s locobj.MKBSDLoc=Loc
				    s locobj.MKBSDLocSource="L"
				    d locobj.MKBSDStructDataSetObjectId(MKBSDRowid)
				    s locsc = locobj.%Save()
				    d locobj.%Close()
				    //b ;add
				    if (locsc'=1)
				    {
					    s errorflag=1
				    }
				}
			}
		}
		//b ;1
		
		
	}
	if (errorflag=0)
	{
		s MKBSDRowid=0
		for
		{
			//Index BaseIndex On MKBSDBaseDr;
			s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
			q:MKBSDRowid=""
			s locfreq=0
			
			//Index NewLocIndex On (MKBSDStructData, MKBSDLoc);
			s LocDesc=""
			for
			{
				s LocDesc=$o(^User.MKBStructuredDataLocI("NewLocIndex",MKBSDRowid,LocDesc))
				q:LocDesc=""
				s LOCid=""
				for
				{
					s LOCid=$o(^User.MKBStructuredDataLocI("NewLocIndex",MKBSDRowid,LocDesc,LOCid))
					q:LOCid=""
					s MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LOCid)),3)
					s locfreq=locfreq+MKBSDFrequency
				}
				
			}
			
			if (locfreq'=0)		//修改科室总频次
			{
				
				s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			 	s snobj.MKBSDTotalFreq = locfreq
			    s mastersc = snobj.%Save()
			    d snobj.%Close()
			}
			
		}
	}
	w "读取数据总共"_(num-1)_"条",!
	close file
    k file
    //tc
	q "{success:'true'}"
}

}
