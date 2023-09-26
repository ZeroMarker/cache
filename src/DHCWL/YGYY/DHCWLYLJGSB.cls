/// 名称: DHCWL.YGYY.DHCWLYLJGSB
/// 描述: 医疗机构抗菌药物临床应用上报表
/// 编写者：zyb
/// 编写日期:2019-08-27
/// 
Class DHCWL.YGYY.DHCWLYLJGSB Extends %RegisteredObject
{

Query QueryAntPatOperData1(startDate As %String, endDate As %String, hospid As %String) As %Query(ROWSPEC = "name:%String,code:%String,operNums:%String,ICutOperNums:%Float,ICutOperYFNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryAntPatOperData1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	k ^TEMPDHCWL($j)
	set startDate=$zdh(startDate,3)
	set endDate=$zdh(endDate,3)
	;s cutCode="切口愈合等级11.O0042^#TYPE:Simple#TID:325#TVER:0#SCODE:O0042#VTYPE:C" 
	f date=startDate:1:endDate d
	.s admId=0
	.f  s admId=$o(^PAADMi("DisDateT","I",date,admId)) q:admId=""  d
	..s dept=$p(^PAADM(admId),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	..s status=$p($G(^PAADM(admId)),"^",20)
	..q:status'="D"
	..;s arr =  ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(admId,"HDSD00.11")
	..;s mOperCut=arr.GetAt("HDSD00.11.082")		///	082 code  616 desc
	..;s mOperCut=$p($G(mOperCut),"/",1)			///手术切口
	..;s mOperCut=##class(EPRservice.BOScatterData).GetEPRData(admId,cutCode)
	..s mOperStr1=##Class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(admId,"O/1","1") 
	..s operCode=$p(mOperStr1,$c(2),1) 	//手术编码
	..s operName=$p(mOperStr1,$c(2),2) 	//手术名称
	..s mOperCut=$p($p(mOperStr1,"/",2),$c(2),2) 
	..i (operCode'="") d
	...s ^TEMPDHCWL($j,"OperNum")=$g(^TEMPDHCWL($j,"OperNum"))+1 
	..q:mOperCut'="一类切口"
	..;q:mOperCut'=$c(8544)    //I类切口
	..;q:operCode'="13.4100x001"
	..i '$d(^TEMPDHCWL($j,operName,operCode,admId,"Oper")) d
	...s ^TEMPDHCWL($j,operName,operCode,"Oper")=$g(^TEMPDHCWL($j,operName,operCode,"Oper"))+1 
	...s ^TEMPDHCWL($j,operName,operCode,admId,"Oper")=""
	..s drugNums=0,preOperPat=0
 	..s ord=0 f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d              
 	...s ordSub=0 f  s ordSub=$o(^OEORD(ord,"I",ordSub)) q:ordSub=""  d 
 	....q:preOperPat=1           
 	....s priority=$p($g(^OEORD(ord,"I",ordSub,1)),"^",8) q:priority=""   
 	....q:priority=7	//出院带药不参与计算
 	....q:..GetBaseQty(ord_"||"_ordSub)=0   //发药数量为0
 	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2) q:arcim="" 
 	....s phcdf=..GetPHCDFByarcim(arcim) q:phcdf=""
 	....q:..IsAntiDrg(phcdf)=0  
 	....///手术预防用抗生素
 	....s instrReaCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeMainCode(ord_"||"_ordSub) 
 	....s instrReaSubCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeItemCode(ord_"||"_ordSub)
 	....i (instrReaCatCode="YF")&&(instrReaSubCatCode="2-1") d
 	.....s preOperPat=1
 	..i (preOperPat=1)&&('$d(^TEMPDHCWL($j,operName,operCode,admId,"YF"))) d
 	...s ^TEMPDHCWL($j,operName,operCode,"YF")=$g(^TEMPDHCWL($j,operName,operCode,"YF"))+1
	...s ^TEMPDHCWL($j,operName,operCode,admId,"YF")=""
	
	s name="" f  s name=$o(^TEMPDHCWL($j,name)) q:name=""  d
	.s code="" f  s code=$o(^TEMPDHCWL($j,name,code)) q:code=""  d
	..s ICutOperNums=+$g(^TEMPDHCWL($j,name,code,"Oper"))
	..s ICutOperYFNums=+$g(^TEMPDHCWL($j,name,code,"YF"))
	..s operNums=$g(^TEMPDHCWL($j,"OperNum"))
    ..d OutPutRow
    
    k ^TEMPDHCWL($j)
	
	Quit $$$OK
	
OutPutRow	
	  
    s Data=$lb(name,code,operNums,ICutOperNums,ICutOperYFNums)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod QueryAntPatOperData1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntPatOperData1Execute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAntPatOperData1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntPatOperData1Execute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryTable4","2019-2-01","2019-9-30","")

/// Creator：      zyb
/// CreatDate：    2019-08-27
/// Description:   【表4-医疗机构抗菌药物临床应用指标数据上报表】
/// Table：        
/// Input：        startDate:开始日期,endDate：结束日期
/// Output：       mzAntNums:门诊抗菌药物品种数,jzAntNums:急诊抗菌药物品种数,mSPDDDs:出院患者特殊使用级抗菌药物使用量,mOPYFNums:住院患者预防使用抗菌药物手术例次,mOPYFHLNums:住院手术患者预防使用抗菌药物用药时机合理例次,mGMZYNums:单纯冠脉造影手术例次,mOPYFGMZYNums:单纯冠脉造影预防使用抗菌药物例次   
/// Return：       
/// Others：        
Query QueryTable4(startDate As %String, endDate As %String, hospid As %String) As %Query(ROWSPEC = "mzAntNums:%Float,jzAntNums:%Float,mSPDDDs:%Float,mOPYFNums:%Float,mOPYFHLNums:%Float,mGMZYNums:%Float,mOPYFGMZYNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryTable4Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	k ^TEMPDHCWL($j)
	set startDate=$zdh(startDate,3)
	set endDate=$zdh(endDate,3)
    
    //门诊数据
	f mdate=startDate:1:endDate d
	.s phLoc=0 
	.f  s phLoc=$o(^DHCPHDISPi("FYDATE",mdate,phLoc)) q:phLoc=""  d  
	..s phId=0 
	..f  s phId=$o(^DHCPHDISPi("FYDATE",mdate,phLoc,phId)) q:phId=""  d 
	...s phSub="" 
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:(phSub="")  d
	....s oeori=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",5)
	....s ord=+oeori
	....s admId=$p(^OEORD(ord),"^",1) 
	....s dept=$p(^PAADM(admId),"^",4)
	....s hosp=$p(^CTLOC(dept),"^",22) 
	....q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	....s admType=$p(^PAADM(admId),"^",2) 
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) q:phcdf=""
	....q:..IsAntiDrg(phcdf)=0 
	....i ('$d(^TEMPDHCWL($j,"AntNumMZ",phcdf)))&&(admType="O") d
	.....s ^TEMPDHCWL($j,"AntNumMZ")=$g(^TEMPDHCWL($j,"AntNumMZ"))+1    ;门诊抗菌药物品种数
	.....s ^TEMPDHCWL($j,"AntNumMZ",phcdf)=""
	....i ('$d(^TEMPDHCWL($j,"AntNumJZ",phcdf)))&&(admType="E") d
	.....s ^TEMPDHCWL($j,"AntNumJZ")=$g(^TEMPDHCWL($j,"AntNumJZ"))+1    ;急诊抗菌药物品种数
	.....s ^TEMPDHCWL($j,"AntNumJZ",phcdf)=""
	
	//出院数据(手术)
	f Date=startDate:1:endDate d
 	.s date=$zd(Date,3)
 	.s status=##class(DHCWL.YGYY.DischaCFG).GetDischCFGAdmPADI(date,.admData)  q:status'=1
 	.s admid="" f  s admid=$o(admData(admid)) q:admid=""  d
 	..s dept=$p(^PAADM(admid),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	..s spDDD=$$GetPatSpDDD(admid)
	..s ^TEMPDHCWL($j,"spDDD")=$g(^TEMPDHCWL($j,"spDDD"))+spDDD		;出院患者特殊使用级抗菌药物使用量
	..i $$GetOperYFFlag(admid)=1 d 
	...s ^TEMPDHCWL($j,"opYF")=$g(^TEMPDHCWL($j,"opYF"))+1		    ;住院患者预防使用抗菌药物手术例次
	..i $$GetOperYFHLFlag(admid)=1 d 
	...s ^TEMPDHCWL($j,"opYFHL")=$g(^TEMPDHCWL($j,"opYFHL"))+1		;住院手术患者预防使用抗菌药物用药时机合理例次
    ..s operName=..GetOperNa(admid)
    ..i (operName [ "冠脉造影") d
    ...s ^TEMPDHCWL($j,"OPGMZY")=$g(^TEMPDHCWL($j,"OPGMZY"))+1		 ;单纯冠脉造影手术例次
    ..i ($$GetOperYFFlag(admid)=1)&&(operName [ "冠脉造影") d
    ...s ^TEMPDHCWL($j,"OPYFGMZY")=$g(^TEMPDHCWL($j,"OPYFGMZY"))+1	 ;单纯冠脉造影预防使用抗菌药物例次
    
    s (mzAntNums,jzAntNums,mSPDDDs,mOPYFNums,mOPYFHLNums,mGMZYNums,mOPYFGMZYNums)=0
    
    s mzAntNums=+$g(^TEMPDHCWL($j,"AntNumMZ"))
    s jzAntNums=+$g(^TEMPDHCWL($j,"AntNumJZ")) 
    s mSPDDDs=+$g(^TEMPDHCWL($j,"spDDD"))
    s mOPYFNums=+$g(^TEMPDHCWL($j,"opYF"))
    s mOPYFHLNums=+$g(^TEMPDHCWL($j,"opYFHL"))
    s mGMZYNums=+$g(^TEMPDHCWL($j,"OPGMZY"))
    s mOPYFGMZYNums=+$g(^TEMPDHCWL($j,"OPYFGMZY"))
    d OutPutRow
    
    k ^TEMPDHCWL($j) 
    Quit $$$OK
        
OutPutRow
 
    s Data=$lb(mzAntNums,jzAntNums,mSPDDDs,mOPYFNums,mOPYFHLNums,mGMZYNums,mOPYFGMZYNums)
    s ^CacheTemp(repid,ind)=Data 
    s ind=ind+1
    q
    
 ///根据admid获取出院患者特殊使用级抗菌药物使用量
GetPatSpDDD(admId) 

 s spddd=0 
 s spddd=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"SpAntiDDDs","YGYYDate")    
 s spddd=$p($g(spddd),":",2) 

 q $g(spddd)
 
  ///根据admid判断是否为出院患者预防使用抗菌药物手术
GetOperYFFlag(admId) 

 s flag=0 
 s flag=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperYFAntiFlag","YGYYDate")    
 s flag=$p($g(flag),":",2) 

 q $g(flag)
 
   ///根据admid判断是否为住院手术患者预防使用抗菌药物用药时机合理率(0.5-2h)
GetOperYFHLFlag(admId) 
 
 s flag=0 
 s flag=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperYFAntiHLFlag","YGYYDate")    
 s flag=$p($g(flag),":",2) 

 q $g(flag)
}

ClassMethod QueryTable4Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTable4Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTable4Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTable4Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryAntPatOperData","2018-1-1","2019-12-31","")     

/// Creator：      zyb
/// CreatDate：    2019-08-27
/// Description:： 【医疗机构I类切口手术用药情况调查表】
/// Table：        DHC_AntUsePurpose 抗菌药物使用目的表
/// 			   DHC_AN_OPArrange 手术申请表  OR_Anaesthesia  麻醉表
/// Input：        startDate:开始日期,endDate：结束日期
/// Output：       name:手术名称,code:手术编码,ICutOperNums:I类切口手术例数,ICutOperYFNums:I类切口预防用抗菌药物手术例数	  
/// Return：        
/// Others： 
Query QueryAntPatOperData(startDate As %String, endDate As %String, hospid As %String) As %Query(ROWSPEC = "name:%String,code:%String,operNums:%String,ICutOperNums:%Float,ICutOperYFNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryAntPatOperDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	k ^TEMPDHCWL($j)
	set startDate=$zdh(startDate,3)
	set endDate=$zdh(endDate,3)
	;s cutCode="切口愈合等级11.O0042^#TYPE:Simple#TID:325#TVER:0#SCODE:O0042#VTYPE:C" 
	f date=startDate:1:endDate d
	.s admId=0
	.f  s admId=$o(^PAADMi("DisDateT","I",date,admId)) q:admId=""  d
	..s dept=$p(^PAADM(admId),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	..s status=$p($G(^PAADM(admId)),"^",20)
	..q:status'="D"
	..;s arr =  ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(admId,"HDSD00.11")
	..;s mOperCut=arr.GetAt("HDSD00.11.082")		///	082 code  616 desc
	..;s mOperCut=$p($G(mOperCut),"/",1)			///手术切口
	..;s mOperCut=##class(EPRservice.BOScatterData).GetEPRData(admId,cutCode)
	..;s mOperStr1=##Class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(admId,"O/1","1") 
	..s operName=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperId","YGYYDate")    s operName=$p($g(operName),":",2) 
	..s operCode=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperICD","YGYYDate")    s operCode=$p($g(operCode),":",2) 
	..s mOperCut=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperBladeType","YGYYDate")    s mOperCut=$p($g(mOperCut),":",2) 
	..;s operCode=$p(mOperStr1,$c(2),1) 	//手术编码
	..;s operName=$p(mOperStr1,$c(2),2) 	//手术名称
	..;s mOperCut=$p($p(mOperStr1,"/",2),$c(2),2) 
	..i (operCode'="") d
	...s ^TEMPDHCWL($j,"OperNum")=$g(^TEMPDHCWL($j,"OperNum"))+1 
	..;q:mOperCut'="一类切口"
	..;q:mOperCut'=$c(8544)    //I类切口
	..;q:operCode'="13.4100x001"
	..q:mOperCut'=1
	..i '$d(^TEMPDHCWL($j,operName,operCode,admId,"Oper")) d
	...s ^TEMPDHCWL($j,operName,operCode,"Oper")=$g(^TEMPDHCWL($j,operName,operCode,"Oper"))+1 
	...s ^TEMPDHCWL($j,operName,operCode,admId,"Oper")=""
	..s drugNums=0,preOperPat=0
 	..s ord=0 f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d              
 	...s ordSub=0 f  s ordSub=$o(^OEORD(ord,"I",ordSub)) q:ordSub=""  d 
 	....q:preOperPat=1           
 	....s priority=$p($g(^OEORD(ord,"I",ordSub,1)),"^",8) q:priority=""   
 	....q:priority=7	//出院带药不参与计算
 	....q:..GetBaseQty(ord_"||"_ordSub)=0   //发药数量为0
 	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2) q:arcim="" 
 	....s phcdf=..GetPHCDFByarcim(arcim) q:phcdf=""
 	....q:..IsAntiDrg(phcdf)=0  
 	....///手术预防用抗生素
 	....s instrReaCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeMainCode(ord_"||"_ordSub) 
 	....s instrReaSubCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeItemCode(ord_"||"_ordSub)
 	....i (instrReaCatCode="YF")&&(instrReaSubCatCode="2-1") d
 	.....s preOperPat=1
 	..i (preOperPat=1)&&('$d(^TEMPDHCWL($j,operName,operCode,admId,"YF"))) d
 	...s ^TEMPDHCWL($j,operName,operCode,"YF")=$g(^TEMPDHCWL($j,operName,operCode,"YF"))+1
	...s ^TEMPDHCWL($j,operName,operCode,admId,"YF")=""
	
	s name="" f  s name=$o(^TEMPDHCWL($j,name)) q:name=""  d
	.s code="" f  s code=$o(^TEMPDHCWL($j,name,code)) q:code=""  d
	..s ICutOperNums=+$g(^TEMPDHCWL($j,name,code,"Oper"))
	..s ICutOperYFNums=+$g(^TEMPDHCWL($j,name,code,"YF"))
	..s operNums=$g(^TEMPDHCWL($j,"OperNum"))
    ..d OutPutRow
    
    k ^TEMPDHCWL($j)
	
	Quit $$$OK
	
OutPutRow	
	  
    s Data=$lb(name,code,operNums,ICutOperNums,ICutOperYFNums)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod QueryAntPatOperDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntPatOperDataExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAntPatOperDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntPatOperDataExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 根据关键字查询手术名称

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","GetOperName","切除术")	

Query GetOperName(desc As %Text) As %Query(ROWSPEC = "opercode:%String,opername:%String") [ SqlProc ]
{
}

ClassMethod GetOperNameExecute(ByRef qHandle As %Binary, desc As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	q:desc="" $$$OK
 
 	s operid=0
 	f  s operid=$o(^ORC("OPER",operid)) q:operid=""  d
 	.q:$g(^ORC("OPER",operid))=""
 	.s opercode=$p(^ORC("OPER",operid),"^",1)
	.s opername=$p(^ORC("OPER",operid),"^",2)
	.q:opername'[desc
	.Do OutputRows
 
	Quit $$$OK
OutputRows
	set Data=$lb(opercode,opername)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperNameExecute ]
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

ClassMethod GetOperNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryAntPatOperMX","2018-11-1","2018-11-18","13.4100x001")     

/// Creator：      zyb
/// CreatDate：    2019-08-27
/// Description:： I类切口手术患者明细
/// Table：        DHC_AntUsePurpose 抗菌药物使用目的表
/// 			   DHC_AN_OPArrange 手术申请表  OR_Anaesthesia  麻醉表
/// Input：        startDate:开始日期,endDate：结束日期,operCode: 手术编码
/// Output：       admId:就诊rowid,zyh:住院号,sex:性别,age:年龄,admDate:入院日期,disDate:出院日期,preOperPat:预防用药标志,drugNums:预防用抗菌药物品种数,durData:用药疗程		  
/// Return：       
/// Others： 
Query QueryAntPatOperMX(startDate As %String, endDate As %String, operCode As %String, hospid As %String) As %Query(ROWSPEC = "admId:%String,zyh:%String,sex:%String,age:%String,admDate:%String,disDate:%String,preOperPat:%String,drugNums:%Float,durData:%Float") [ SqlProc ]
{
}

ClassMethod QueryAntPatOperMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, operCode As %String, hospid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	k ^TEMPDHCWL($j)
	set startDate=$zdh(startDate,3)
	set endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
	.s admId=0
	.f  s admId=$o(^PAADMi("DisDateT","I",date,admId)) q:admId=""  d
	..s dept=$p(^PAADM(admId),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	..s status=$p($G(^PAADM(admId)),"^",20)
	..q:status'="D"
	..s operName=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperId","YGYYDate")    s operName=$p($g(operName),":",2) 
	..s mOperCode=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperICD","YGYYDate")    s mOperCode=$p($g(mOperCode),":",2) 
	..s mOperCut=$$GetPatBaseInfor^DHCWLPatBaseLoadA(admId,"OperBladeType","YGYYDate")    s mOperCut=$p($g(mOperCut),":",2) 
	..;s mOperStr=##Class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(admId,"O/1","1")
	..;s mOperCode=$p(mOperStr,$c(2),1)	 //手术编码
	..;s operName=$p(mOperStr,$c(2),2) 	//手术名称
	..;s mOperCut=$p($p(mOperStr,"/",2),$c(2),2) 
	..;q:mOperCut'="一类切口"
	..;q:mOperCut'=$c(8544)    //I类切口
	..;q:mOperCode'="65.2501"
	..q:mOperCut'=1
	..q:(operCode'="")&&(operCode'=mOperCode)
 	..s drugNums=0,preOperPat=0,durData=0
 	..s ord=0 f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d              
 	...s ordSub=0 f  s ordSub=$o(^OEORD(ord,"I",ordSub)) q:ordSub=""  d            
 	....s priority=$p($g(^OEORD(ord,"I",ordSub,1)),"^",8) q:priority=""   
 	....q:priority=7	//出院带药不参与计算
 	....q:..GetBaseQty(ord_"||"_ordSub)=0   //发药数量为0
 	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2) q:arcim="" 
 	....s phcdf=..GetPHCDFByarcim(arcim) q:phcdf=""
 	....s antiType=..IsAntiDrg(phcdf)  
	....i antiType'=0  d
  	.....s instrReaCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeMainCode(ord_"||"_ordSub) 
 	.....s instrReaSubCatCode=##class(DHCAnt.Serve.ComOut).GetUsePurposeItemCode(ord_"||"_ordSub)
 	.....///手术预防用抗生素
 	.....i (instrReaCatCode="YF")&&(instrReaSubCatCode="2-1") d
 	......s preOperPat=1 
 	......i '$d(^TEMPDHCWL($j,"Ant",admId,+phcdf)) d
 	.......s drugNums=drugNums+1 	//抗菌药物品种数
 	.......s ^TEMPDHCWL($j,"Ant",admId,+phcdf)=""
 	......s duratdr=$p($g(^OEORD(ord,"I",ordSub,2)),"^",6) 
 	......s durData=0
 	......i duratdr'="" d
	.......s duratDays=$p($g(^PHCDU(duratdr)),"^",2)	 ;疗程（天数）取最长疗程
	.......i durData<duratDays  s durData=duratDays 
    ..d OutPutRowMX
    
    k ^TEMPDHCWL($j)
	
	Quit $$$OK
	
OutPutRowMX	
	s papmidr=$p(^PAADM(admId),"^",1) 
    ;s zyh=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId) //住院号
    s zyh=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(admId) 
    s sex=$$GetSex^DHCWLCommon(papmidr)			 //性别
	s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s ageDR=..CalAge(birth,+$h)
    s ageY=$p(ageDR,"Y",1)  
    s age=ageY_""_"岁"
    i ageY<1 d
    .s age=$p(ageDR," ",2)
    .i +age>0 s age=$replace(age,"M","月")
    .i +age=0 s age=$replace($p(ageDR," ",3),"D","天")
    s admDate=$p(^PAADM(admId,"DHC"),"^",31)	;入院日期
    s disDate=$p(^PAADM(admId),"^",17)  ;出院日期
  
    s Data=$lb(admId,zyh,sex,age,$zd(admDate,3),$zd(disDate,3),preOperPat,+$g(drugNums),+$g(durData))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod QueryAntPatOperMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntPatOperMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAntPatOperMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntPatOperMXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据出生日计算年龄
ClassMethod CalAge(mIBirth, mIToday) As %Status
{
    s mIBirth=$g(mIBirth),mIToday=$g(mIToday)
    i mIBirth>2980000 s mIBirth=""
    i mIBirth<0 s mIBirth=""
    q:'$g(mIBirth) ""
    s xBirth=$zd(mIBirth)
    s xToday=$zd(mIToday)
    s ageMth=xToday-xBirth
    s ageDay=$p(xToday,"/",2)-$p(xBirth,"/",2)
    s mCurrYear=$p(xToday,"/",3) s:mCurrYear<100 mCurrYear=mCurrYear+1900
    s mBirthYear=$p(xBirth,"/",3) s:mBirthYear<100 mBirthYear=mBirthYear+1900
    s ageYear=mCurrYear-mBirthYear
    i ageDay<0 d
    . s ageMth=ageMth-1
	. s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+xToday)
	. q:xToday'=2
	. s:((mCurrYear#4)=0)&(((mCurrYear#100)'=0)!((mCurrYear#400)=0)) ageDay=ageDay+1
	i ageMth<0 s ageMth=ageMth+12,ageYear=ageYear-1
	s $p(AgeYr,"|",12)=ageYear
	s reage=$p(AgeYr,"|",12)_"Y "_ageMth_"M "_ageDay_"D"
	q reage
}

/// 判断药学项是否抗菌素,是返回1,否则返回0  
ClassMethod IsAntiDrg(phcdf) As %Status
{
	s phcm=+phcdf  
	q:'$d(^PHCD(phcm,1)) 0
	s phcpo=$p(^PHCD(phcm,1),"^",4) q:phcpo="" 0
	s phcpoCode=$zcvt($p($g(^PHCPO(phcpo)),"^",1),"U")  
    
    q:phcpoCode["KSS1" 1  //非限制使用抗菌药
    q:phcpoCode["KSS2" 2  //限制使用抗菌药
    q:phcpoCode["KSS3" 3  //特殊使用抗菌药
 
	q 0
}

/// 根据admId获取手术名称 
/// w ##class(DHCWL.YGYY.DHCWLYLJGSB).GetOperNa("920")     
ClassMethod GetOperNa(mAdmid) As %Status
{
	s opaId="",opername=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",mAdmid,opaId)) q:opaId=""  d
	.q:opername'=""
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:opaStatus'="F" 	;完成状态
	.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2) ;手术麻醉Id
	.s anaSub=$P(anaId,"||",2)
	.s opername=$p($g(^OR(mAdmid,"ANA",anaSub,"OP",1,"DHC")),"^",2) 
	.q:opername=""
	.i $d(^ORC("OPER",opername)) d
	..s opername=$P(^ORC("OPER",+opername),"^",2)

	q $g(opername)
}

/// 通过医嘱项取得药学项
ClassMethod GetPHCDFByarcim(arcim) As %Status
{
	s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	q phcdf
}

/// 获取发药数量
ClassMethod GetBaseQty(OEORI) As %Status
{
	s chll=0,qty=0
	for  s chll=$o(^DHCOEDISQTY(0,"OEORI",OEORI,chll))  q:chll=""  d
	.s temqty=$p(^DHCOEDISQTY(chll),"^",5)
	.s disStatus=$p(^DHCOEDISQTY(chll),"^",7)
	.;w temqty_"^"_disStatus,!
	.if (disStatus="C") d
	..S qty=qty+temqty
	.if disStatus="R"  d
	..S qty=qty-temqty
	Q qty
}

/// Creator：		zyb
/// CreatDate：		2019-8-28 
/// Description：	【基本药物使用情况表】
/// Table：			DHC_PHDISPEN,DHC_PHDISITEM、DHC_PHACollected,DHC_PHACollectItm
/// Input：			startDate，endDate, hopsid：院区
/// Output：		mBaseDrugNum：基本药物品种数,mGJBaseDrugNum：国家基本药物品种数,mSJBaseDrugNum：省级基本药物品种数
/// Return： 		无
/// Others： 		
/// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryBaseData","2019-1-22","2019-7-01","")
Query QueryBaseData(startDate As %String, endDate As %String, hospid As %String) As %Query(ROWSPEC = "mBaseDrugNum:%Float,mGJBaseDrugNum:%Float,mSJBaseDrugNum:%Float") [ SqlProc ]
{
}

ClassMethod QueryBaseDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
	k ^TEMPDHCWL($j)
 
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)
    //门诊发药
	f mdate=startDate:1:endDate d
	.s phLoc=0
	.f  s phLoc=$o(^DHCPHDISPi("FYDATE",mdate,phLoc)) q:phLoc=""  d   ;门诊发药表
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",mdate,phLoc,phId)) q:phId=""  d  ;门诊发药子表
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:(phSub="")  d
	....s oeori=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",5)
	....s ord=+oeori
	....s admId=$p(^OEORD(ord),"^",1) 
	....s dept=$p(^PAADM(admId),"^",4)
	....s hosp=$p(^CTLOC(dept),"^",22) 
	....q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) q:phcdf=""
	....s baseFlag=$$IntfaceJB^DHCWLBuildKPICommon(oeori) 
	....i ((baseFlag=1))&&('$d(^TEMPDHCWL($j,"GJBaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"GJBaseDrugNum")=$g(^TEMPDHCWL($j,"GJBaseDrugNum"))+1  ;国家基本药物品规数
	.....s ^TEMPDHCWL($j,"GJBaseDrugNumFY",phcdf)=""
	....i ((baseFlag=2))&&('$d(^TEMPDHCWL($j,"SJBaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"SJBaseDrugNum")=$g(^TEMPDHCWL($j,"SJBaseDrugNum"))+1  ;省级基本药物品规数
	.....s ^TEMPDHCWL($j,"SJBaseDrugNumFY",phcdf)=""
	....i ((baseFlag=1)||(baseFlag=2))&&('$d(^TEMPDHCWL($j,"BaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"BaseDrugNum")=$g(^TEMPDHCWL($j,"BaseDrugNum"))+1		;基本药物品规数
	.....s ^TEMPDHCWL($j,"BaseDrugNumFY",phcdf)=""
	//住院发药
	f date=startDate:1:endDate d
	.s phaLoacId=0
	.f  s phaLoacId=$o(^DHCPHAC(0,"PHA",phaLoacId)) q:phaLoacId=""  d
	..s phaId=0
	..s admLoc=""
	..f  s phaId=$o(^DHCPHAC(0,"PHA",phaLoacId,"DATE",date,phaId)) q:phaId=""  d
	...s phaSubId=0
	...f  s phaSubId=$o(^DHCPHAC(phaId,"I",phaSubId)) q:phaSubId=""  d
	....s oeori=$p(^DHCPHAC(phaId,"I",phaSubId),"^",7)
	....s ord=+oeori
	....s admId=$p(^OEORD(ord),"^",1) 
	....s dept=$p(^PAADM(admId),"^",4)
	....s hosp=$p(^CTLOC(dept),"^",22) 
	....q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0) 
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) q:phcdf=""
	....s baseFlag=$$IntfaceJB^DHCWLBuildKPICommon(oeori) 
	....i ((baseFlag=1))&&('$d(^TEMPDHCWL($j,"GJBaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"GJBaseDrugNum")=$g(^TEMPDHCWL($j,"GJBaseDrugNum"))+1  ;国家基本药物品规数
	.....s ^TEMPDHCWL($j,"GJBaseDrugNumFY",phcdf)=""
	....i ((baseFlag=2))&&('$d(^TEMPDHCWL($j,"SJBaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"SJBaseDrugNum")=$g(^TEMPDHCWL($j,"SJBaseDrugNum"))+1  ;省级基本药物品规数
	.....s ^TEMPDHCWL($j,"SJBaseDrugNumFY",phcdf)=""
	....i ((baseFlag=1)||(baseFlag=2))&&('$d(^TEMPDHCWL($j,"BaseDrugNumFY",phcdf))) d
	.....s ^TEMPDHCWL($j,"BaseDrugNum")=$g(^TEMPDHCWL($j,"BaseDrugNum"))+1		;基本药物品规数
	.....s ^TEMPDHCWL($j,"BaseDrugNumFY",phcdf)=""
		
	s mBaseDrugNum=$g(^TEMPDHCWL($j,"BaseDrugNum"))
	s mGJBaseDrugNum=$g(^TEMPDHCWL($j,"GJBaseDrugNum"))
	s mSJBaseDrugNum=$g(^TEMPDHCWL($j,"SJBaseDrugNum"))
			
	set Data=$lb(mBaseDrugNum,mGJBaseDrugNum,mSJBaseDrugNum)
	d OuputRowBase
	
	k ^TEMPDHCWL($j)
 	Quit $$$OK

 
OuputRowBase
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryBaseDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBaseDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryBaseDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBaseDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryOperPatMX","2019-11-01","2020-06-15")

/// Creator：      zyb
/// CreatDate：    2019-08-28
/// Description:：【手术病人使用抗菌药物情况表】
/// Table：       
/// 			   DHC_AN_OPArrange 手术申请表  OR_Anaesthesia  麻醉表
/// Input：        startDate:开始日期,endDate：结束日期,hospid: 院区,MrNo: 病历号
/// Output：       zyNo：住院号,patName：患者姓名,sex：性别,age：年龄,weight：体重,admDate：入院日期,disDate：出院日期,ryks：入院科室,cyks：出院科室,zyts：住院天数,diagno：出院诊断,gms：过敏史,operName：手术名称,operCut：手术切口等级,operSDate：手术开始日期,operEDate：手术结束日期,totalFee：总费用,drugFee：药品费用,antFee：抗菌药物费用		  
/// Return：       
/// Others： 
ClassMethod QueryOperPatMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, MrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	 
    f date=startDate:1:endDate d
	.s admId=0,totalFee=0,drugFee=0,antFee=0,operName="",operCut="",operDate=""
	.f  s admId=$o(^PAADMi("DischDate",date,admId)) q:admId=""  d
	..s admType=$P(^PAADM(admId),"^",2)
 	..q:admType'="I"
 	..;s zyNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId)	;病历号
 	..s zyNo=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(admId)
 	..q:(MrNo'="")&&(MrNo'=zyNo)
 	..s dept=$p(^PAADM(admId),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0) 
	..s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",admId,opaId)) q:opaId=""  d
	...s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	...q:opaStatus'="F" 	;完成状态
	...s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2) ;手术麻醉Id
	...s anaSub=$P(anaId,"||",2)
	...s anaopSub=0 
	...s anaopSub=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub)) 
	...s curOperId=$P(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",6) ;ANAOP_Type_DR；手术名称
	...i curOperId'="" s operName=$p(^ORC("OPER",curOperId),"^",2)  ;手术名称
	...;e  s operName=$G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"REM",2)) 
	...e  s operName=$p($g(^OR(admId,"ANA",anaSub,"OP",1,"DHC")),"^",2)
	...s startDate=$p($g(^OR(admId,"ANA",anaSub)),"^",39) 
	...s startTime=$p($g(^OR(admId,"ANA",anaSub)),"^",40) 
	...s endDate=$p($g(^OR(admId,"ANA",anaSub)),"^",41)
	...s endTime=$p($g(^OR(admId,"ANA",anaSub)),"^",42)
	...i startDate="" s startDate=$P(^DHCANOPArrange(opaId),"^",14)
	...i startTime="" s startTime=$P(^DHCANOPArrange(opaId),"^",15) 
	...i endDate="" s endDate=$P(^DHCANOPArrange(opaId),"^",16)
	...i endTime="" s endTime=$P(^DHCANOPArrange(opaId),"^",17)
	...s operSDate=$zd(startDate,3)_" "_$zt(startTime,3)
	...i operSDate["1840-12-31" s operSDate="" 
    ...s operEDate=$zd(endDate,3)_" "_$zt(endTime,3)
	...i operEDate["1840-12-31" s operEDate=""
	...s anaopSub=0,bladeDr=""
	...f  s anaopSub=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	....q:bladeDr'=""
	....s bladeDr=$P($g(^OR(admId,"ANA",anaSub,"OP",anaopSub)),"^",9)		 ;ANAOP_Blade_DR；手术切口
	....i $d(^ORC("BLDTP",bladeDr)) s operCut=$p($g(^ORC("BLDTP",bladeDr)),"^",2) 
	...d OutputRow2
	
	
	
 	
 	q $$$OK	
 	
      
OutputRow2
	
	s disLoc=$p(^PAADM(admId),"^",4)
	s papmidr=$p(^PAADM(admId),"^",1)
    s patName=$$GetPapmiName^DHCWLCommon(papmidr)
    i zyNo["BB" d
    .s admIdBB=$p(^PAADM(admId),"^",75) 
    .s deptBB=$p(^PAADM(admIdBB),"^",4)
    ;q:(zyNo["BB")&&(dept=deptBB)
    s sex=$$GetSex^DHCWLCommon(papmidr) 	//性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s ageDR=..CalAge(birth,+$h)
    s ageY=$p(ageDR,"Y",1)  
    s age=ageY_""_"岁"
    i ageY<1 d
    .s age=$p(ageDR," ",2)
    .i +age>0 s age=$replace(age,"M","月")
    .i +age=0 s age=$replace($p(ageDR," ",3),"D","天")
    s mRadmId=$p(^PAADM(admId),"^",61) 
	s weight=$p(^MR(mRadmId,"PRO",1),"^",27)	//体重
	;s:weight="" weight=##class(web.DHCQueryInfo).GetMRObservationsTZ(admId)
	i $number(weight)="" s weight=""
    s diagna=$$GetFriDisDiagnos^DHCWLCommon(admId,"DIS")    
    s diagno=$p($g(diagna),"^",1)
	s admDate=$p(^PAADM(admId,"DHC"),"^",31)
	s admTime=$p(^PAADM(admId,"DHC"),"^",32)	
	s disDate=$p(^PAADM(admId),"^",17)
	s disTime=$p(^PAADM(admId),"^",18)
	s zyts=disDate-admDate		//住院天数
	i zyts=0 s zyts=1
	s admDate=$zd(admDate,3)_" "_$zt(admTime,2) 
	s disDate=$zd(disDate,3)_" "_$zt(disTime,2)
	s admLoc=..GetRYKS(admId)
	//过敏史
	s gms=""
	;s gms=##Class(EMRservice.HISInterface.PatientInfoAssist).GetDataByGlossary(admId,"HDSD00.11.116","0") 
    s feeStr=..GetDisFee(admId)
    s totalFee=+feeStr
    s drugFee=$p(feeStr,"^",2)
    s antFee=$p(feeStr,"^",3)
 	i $d(^CTLOC(admLoc)) d
    .s ryks=$p(^CTLOC(admLoc),"^",2) ;入院科室
    .i ryks [ "-" s ryks=$p(ryks,"-",2)
    
    i $d(^CTLOC(disLoc)) d
    .s cyks=$p(^CTLOC(disLoc),"^",2) ;出院科室
    .i cyks [ "-" s cyks=$p(cyks,"-",2)
    
	s Data=$lb(zyNo,patName,sex,age,weight,admDate,disDate,ryks,cyks,zyts,diagno,gms,operName,operCut,operSDate,operEDate,totalFee,drugFee,antFee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

ClassMethod QueryOperPatMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOperPatMXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOperPatMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOperPatMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryOperPatMX(startDate As %String, endDate As %String, hospid As %String, MrNo As %String) As %Query(ROWSPEC = "zyNo:%String,patName:%String,sex:%String,age:%String,weight:%String,admDate:%String,disDate:%String,ryks:%String,cyks:%String,zyts:%String,diagno:%String,gms:%String,operName:%String,operCut:%String,operSDate:%String,operEDate:%String,totalFee:%Float,drugFee:%Float,antFee:%Float") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCWL.YGYY.DHCWLYLJGSB","QueryUnOperPatMX","2019-01-01","2019-12-31","","")

/// Creator：      zyb
/// CreatDate：    2019-08-28
/// Description:：【非手术病人使用抗菌药物情况表】
/// Table：       
/// 			   DHC_AN_OPArrange 手术申请表  OR_Anaesthesia  麻醉表
/// Input：        startDate:开始日期,endDate：结束日期,hospid: 院区,MrNo: 病历号
/// Output：       zyNo：住院号,patName：患者姓名,sex：性别,age：年龄,weight：体重,admDate：入院日期,disDate：出院日期,ryks：入院科室,cyks：出院科室,zyts：住院天数,diagno：出院诊断,gms：过敏史,operName：手术名称,operCut：手术切口等级,operSDate：手术开始日期,operEDate：手术结束日期,totalFee：总费用,drugFee：药品费用,antFee：抗菌药物费用		  
/// Return：       
/// Others： 
ClassMethod QueryUnOperPatMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, MrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	 
    f date=startDate:1:endDate d
	.s admId=0,totalFee=0,drugFee=0,antFee=0,operName="",operCut="",operDate=""
	.f  s admId=$o(^PAADMi("DischDate",date,admId)) q:admId=""  d
	..s admType=$P(^PAADM(admId),"^",2)
 	..q:admType'="I"
 	..;s zyNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId)	;病历号
 	..s zyNo=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(admId)
 	..q:(MrNo'="")&&(MrNo'=zyNo)
 	..s dept=$p(^PAADM(admId),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22) 
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0) 
 	..s operName=..GetOperNa(admId) 	//手术名称
 	..i operName="" d		//非手术病人
 	...d OutputRow3
 	
 	q $$$OK	
 	
      
OutputRow3
	
	s disLoc=$p(^PAADM(admId),"^",4)
	s papmidr=$p(^PAADM(admId),"^",1)
    s patName=$$GetPapmiName^DHCWLCommon(papmidr)
    i zyNo["BB" d
    .s admIdBB=$p(^PAADM(admId),"^",75) 
    .s deptBB=$p(^PAADM(admIdBB),"^",4)
    ;q:(zyNo["BB")&&(dept=deptBB)
    s sex=$$GetSex^DHCWLCommon(papmidr) 	//性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s ageDR=..CalAge(birth,+$h)
    s ageY=$p(ageDR,"Y",1)  
    s age=ageY_""_"岁"
    i ageY<1 d
    .s age=$p(ageDR," ",2)
    .i +age>0 s age=$replace(age,"M","月")
    .i +age=0 s age=$replace($p(ageDR," ",3),"D","天")
    s mRadmId=$p(^PAADM(admId),"^",61) 
	s weight=$p(^MR(mRadmId,"PRO",1),"^",27)	//体重
	;s:weight="" weight=##class(web.DHCQueryInfo).GetMRObservationsTZ(admId)
	i $number(weight)="" s weight=""
    s diagna=$$GetFriDisDiagnos^DHCWLCommon(admId,"DIS")  
    s diagno=$p($g(diagna),"^",1)
	s admDate=$p(^PAADM(admId,"DHC"),"^",31)
	s admTime=$p(^PAADM(admId,"DHC"),"^",32)	
	s disDate=$p(^PAADM(admId),"^",17)
	s disTime=$p(^PAADM(admId),"^",18)
	s zyts=disDate-admDate		//住院天数
	i zyts=0 s zyts=1
	s admDate=$zd(admDate,3)_" "_$zt(admTime,2) 
	s disDate=$zd(disDate,3)_" "_$zt(disTime,2)
	s admLoc=..GetRYKS(admId)
	//过敏史
	s gms=""
	;s gms=##Class(EMRservice.HISInterface.PatientInfoAssist).GetDataByGlossary(admId,"HDSD00.11.116","0") 
    ;s operCut=..GetOperCut(admId)
    ;s opDate=..GetOperDate(admId)
    ;s operSDate=$p(opDate,"^",1)
    ;s operSTime=$p(opDate,"^",2)
    ;s operEDate=$p(opDate,"^",3)
    ;s operETime=$p(opDate,"^",4) 
    s feeStr=..GetDisFee(admId)
    s totalFee=+feeStr
    s drugFee=$p(feeStr,"^",2)
    s antFee=$p(feeStr,"^",3)
 	i $d(^CTLOC(admLoc)) d
    .s ryks=$p(^CTLOC(admLoc),"^",2) ;入院科室
    .i ryks [ "-" s ryks=$p(ryks,"-",2)
    
    i $d(^CTLOC(disLoc)) d
    .s cyks=$p(^CTLOC(disLoc),"^",2) ;出院科室
    .i cyks [ "-" s cyks=$p(cyks,"-",2)
    
	s Data=$lb(zyNo,patName,sex,age,weight,admDate,disDate,ryks,cyks,zyts,diagno,gms,totalFee,drugFee,antFee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

ClassMethod QueryUnOperPatMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUnOperPatMXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUnOperPatMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUnOperPatMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryUnOperPatMX(startDate As %String, endDate As %String, hospid As %String, MrNo As %String) As %Query(ROWSPEC = "zyNo:%String,patName:%String,sex:%String,age:%String,weight:%String,admDate:%String,disDate:%String,ryks:%String,cyks:%String,zyts:%String,diagno:%String,gms:%String,totalFee:%Float,drugFee:%Float,antFee:%Float") [ SqlProc ]
{
}

/// 根据admId获取手术时间     
/// w ##class(DHCWL.YGYY.DHCWLYLJGSB).GetOperDate(920) 
ClassMethod GetOperDate(mAdmid) As %Status
{
	s opaId="",opername="",anaSub=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",mAdmid,opaId)) q:opaId=""  d
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:opaStatus'="F" 	;完成状态
	.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2) ;手术麻醉Id
	.q:anaSub'=""
	.s anaSub=$P(anaId,"||",2)
	.s startDate=$p($g(^OR(mAdmid,"ANA",anaSub)),"^",39) 
	.s startTime=$p($g(^OR(mAdmid,"ANA",anaSub)),"^",40) 
	.s endDate=$p($g(^OR(mAdmid,"ANA",anaSub)),"^",41)
	.s endTime=$p($g(^OR(mAdmid,"ANA",anaSub)),"^",42)
	.i startDate="" s startDate=$P(^DHCANOPArrange(opaId),"^",14)
	.i startTime="" s startTime=$P(^DHCANOPArrange(opaId),"^",15) 
	.i endDate="" s endDate=$P(^DHCANOPArrange(opaId),"^",16)
	.i endTime="" s endTime=$P(^DHCANOPArrange(opaId),"^",17)
	
	q $zd(startDate,3)_"^"_$zt(startTime,3)_"^"_$zd(endDate,3)_"^"_$zt(endTime,3)
}

/// 根据admId获取手术切口     
/// w ##class(DHCWL.YGYY.DHCWLYLJGSB).GetOperCut(920) 	
ClassMethod GetOperCut(mAdmid) As %Status
{
	s opaId="",bladeType=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",mAdmid,opaId)) q:opaId=""  d
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:opaStatus'="F" 	;完成状态
	.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2) ;手术麻醉Id
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0 
	.f  s anaopSub=$O(^OR(mAdmid,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	..q:bladeType'=""
	..s bladeDr=$P($g(^OR(mAdmid,"ANA",anaSub,"OP",anaopSub)),"^",9) q:bladeDr=""  ;ANAOP_Blade_DR；手术切口
	..i $d(^ORC("BLDTP",bladeDr)) d
	...s bladeType=$p($g(^ORC("BLDTP",bladeDr)),"^",2)  
	q $g(bladeType)
}

// 通过admid获取病人入院科室

/// w ##class(DHCWL.YGYY.DHCWLYLJGSB).GetRYKS(mAdmid) 
ClassMethod GetRYKS(admid) As %Status
{
	s childSub=0,loc=""
	f  s childSub=$o(^PAADM(admid,"TRANS",childSub)) q:childSub=""  d
	.q:loc'=""
	.s loc=$p(^PAADM(admid,"TRANS",childSub),"^",6)
	
	q $g(loc)
}

/// 根据admId获取住院病人药品收入及抗菌药物收入     
/// w ##class(DHCWL.YGYY.DHCWLYLJGSB).GetDisFee("29") 
ClassMethod GetDisFee(admid) As %Status
{
	s wlRowid="",totalFee=0,fee=0,antFee=0
	f  s wlRowid=$o(^DHCWorkLoad(0,"PAADM",admid,wlRowid)) q:wlRowid=""  d
 	.s arcim=$p(^DHCWorkLoad(wlRowid),"^",2)     ;医嘱项
 	.s amount=$p(^DHCWorkLoad(wlRowid),"^",16)
 	.s totalFee=totalFee+amount
 	.s TarCate=$p(^DHCWorkLoad(wlRowid),"^",9)    ;医嘱子分类	
 	.q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
 	.s fee=fee+amount
 	.s phcdf=..GetPHCDFByarcim(arcim) q:phcdf=""
	.q:..IsAntiDrg(phcdf)=0
	.s antFee=antFee+amount
	
	q $g(totalFee)_"^"_$g(fee)_"^"_$g(antFee)
}

}
