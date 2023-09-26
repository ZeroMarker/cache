/// 沈阳移植新增类  DanPJ--2016-07-15
/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：csq
/// 编写日期:2016-03-04
/// inpatientAmount^averagedInhospital^wardRate^deathsWard^DeathsEmergencyNum^HospitalMortalityNum^ReoperationNum^MoreThan60Num^OperationNum^ReturnIn24hNum
Class DtPortal.MD.MD36Docoperation Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 查询全院各科某月手术例数的数量
/// 服务序号:MD36.01.01
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData01","2","2018")
Query MainData01(dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "monthy,opleve,opleveDesc,oneNum,twoNum,threeNum,fourNum,noneNum,Num") [ SqlProc ]
{
}

ClassMethod MainData01Execute(ByRef qHandle As %Binary, dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,dtype,startDate,hospitalId,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s endDate=startDate
	
	s dateType="byMonth"
	s mode="H"
	 
	s kpiRule="KPPDD070101A"
	
	;i hospitalId'="" S filterRule="KPPDD070101A:({Loc.LocHospid}="_hospitalId_")"
	;S filterRule="KPPDD070101A:({Loc.LocHospid}="_hospitalId_")"
	
	b ;01
	s CTLOCNum=0
	k ^TEMPDHCWL($j)
	i dtype=1{
		s startDaten=startDate, endDate=startDate
	}
	
	i dtype=2{
		s startDaten=startDate_"-01", endDate=startDate_"-12"   
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年01月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年02月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年03月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年04月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年05月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年06月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年07月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年08月")=0
    	s ^TEMPDHCWL($j,"opLevelId",startDate_"年09月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年10月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年11月")=0
		s ^TEMPDHCWL($j,"opLevelId",startDate_"年12月")=0
	
	}
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDaten,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s locId=$g(rs.Data("dimIdCol1"))
		s levels=$g(rs.Data("dimIdCol3"))
		
		q:locId=""
		set hospID=$p($g(^CTLOC(locId)),"^",22)
	    
		i hospitalId'=""  continue:hospID'=hospitalId
		set Length=$L(levels,"|")
 			
 		For i=1:1:Length{
	 		s opLevelId=$p(levels,"|",i)   ;手术级别
			s OPNum=$g(rs.Data("kpiValueCol1"))  ; 手术人数 
			s month=rs.Data("month")
		
        	s ^TEMPDHCWL($j,"opLevelId",month,opLevelId)=$g(^TEMPDHCWL($j,"opLevelId",month,opLevelId))+OPNum
	 			
	 	}
 			
		
	}
	
	s month=""
	f  s month=$o(^TEMPDHCWL($j,"opLevelId",month)) q:month=""  d
	.s monthn=$tr(month,"年","-"), monthy=$tr(monthn,"月","")
	.s oneNum=$g(^TEMPDHCWL($j,"opLevelId",month,19))
	.s twoNum=$g(^TEMPDHCWL($j,"opLevelId",month,20))
	.s threeNum=$g(^TEMPDHCWL($j,"opLevelId",month,21))
	.s fourNum=$g(^TEMPDHCWL($j,"opLevelId",month,22))
	.s noneNum=$g(^TEMPDHCWL($j,"opLevelId",month,9999))	//未知手术级别
	.i oneNum="" s oneNum=0 
	.i twoNum="" s twoNum=0 
	.i threeNum="" s threeNum=0 
	.i fourNum="" s fourNum=0 
	.i noneNum="" s noneNum=0
	.s num=oneNum+twoNum+threeNum+fourNum+noneNum
	.;i $d(^DHCANC("OPLevel",opleve)) s opLevelDesc=$p(^DHCANC("OPLevel",opleve),"^",2) ;手术级别 
	.s opleve="ALL" ,opleveDesc="手术分级"  
	.s ^||CacheTemp(repid,ind)=$lb(monthy,opleve,opleveDesc,oneNum,twoNum,threeNum,fourNum,noneNum,num) 
    .S ind=ind+1
 	 k ^TEMPDHCWL($j)   
	Quit $$$OK
}

/// 查询全院某月某手术例数的科室分布
/// 按手术级别
/// 服务序号:MD36.01.02
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData02","2","2017-08","")
Query MainData02(dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String = "", dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "ind,CtlocId,locDesc,oneNum,twoNum,threeNum,fourNum,noneNum,totalNum") [ SqlProc ]
{
}

ClassMethod MainData02Execute(ByRef qHandle As %Binary, dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String = "", dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,dtype,startDate,hospitalId,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j) 
	
	s endDate=startDate
	
	s mode="H"
	s kpiRule="KPPDD070101A"
    s dateType="byMonth"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s locId=$g(rs.Data("dimIdCol1")) 
		s levels=$g(rs.Data("dimIdCol3"))
		q:locId=""
		set hospID=$p($g(^CTLOC(locId)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		set Length=$L(levels,"|")
 			
 		For i=1:1:Length{
	 		
        	set PatLocDR=$g(rs.Data("dimIdCol1"))	//病人科室Dr
	
			set OPCategory=$p(levels,"|",i)	//手术级别id
			set OpNum=$g(rs.Data("kpiValueCol1"))	//手术量

			set ^TEMPDHCWL($j,"Loc",PatLocDR,OPCategory)=$g(^TEMPDHCWL($j,"Loc",PatLocDR,OPCategory))+$g(OpNum)
	 			
	 	}
		
	}
	
      s CtlocId=""
      S totalNum=0
	  f  s CtlocId=$o(^TEMPDHCWL($j,"Loc",CtlocId))  q:CtlocId=""  d
	 
	  .s locDesc=$p(^CTLOC(CtlocId),"^",2)
	  .s locId=$o(^CTLOC(0,"Desc",CtlocId,""))
	  .s oneNum=$g(^TEMPDHCWL($j,"Loc",CtlocId,19))
	  .s twoNum=$g(^TEMPDHCWL($j,"Loc",CtlocId,20))
	  .s threeNum=$g(^TEMPDHCWL($j,"Loc",CtlocId,21))
	  .s fourNum=$g(^TEMPDHCWL($j,"Loc",CtlocId,22))
	  .s noneNum=$g(^TEMPDHCWL($j,"Loc",CtlocId,9999))
	  .i oneNum="" s oneNum=0 
	  .i twoNum="" s twoNum=0 
	  .i threeNum="" s threeNum=0 
	  .i fourNum="" s fourNum=0
	  .i noneNum="" s noneNum=0 
	  .S totalNum = oneNum+twoNum+threeNum+fourNum+noneNum
	  .s ^||CacheTemp(repid,ind)=$lb(ind,CtlocId,locDesc,oneNum,twoNum,threeNum,fourNum,noneNum,totalNum) 
	  .S ind=ind+1
 	 k ^TEMPDHCWL($j)   
	Quit $$$OK
}

/// 查询全院某月某手术例数的科室主诊组分布
/// 按主诊组分
/// 服务序号:MD36.01.03
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData011","1","2017-03","ALL")
Query MainData011(LocId As %String, startDate As %String, opLevelId As %String, endDate As %String = "", dateType As %String = "", hospitalId As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "ind,LocId,locDesc,oneNum,twoNum,threeNum,fourNum,noneNum,totalNum") [ SqlProc ]
{
}

ClassMethod MainData011Execute(ByRef qHandle As %Binary, LocId As %String, startDate As %String, opLevelId As %String = "", endDate As %String = "", dateType As %String = "", hospitalId As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,dtype,LocId,startDate,opLevelId,endDate,dateType,hospitalId,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s ^sjn(0)=$lb(LocId,startDate,opLevelId,endDate)
	k ^TEMPDHCWL($j)
	s endDate=startDate
	s docrowid=""
	
   
    s kpiRule="KPPDD070101A"
    s dateType="byMonth"
    //s filterRule="PMD36:({loc}="_LocId_")"
    ;b ;12
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s LodDr=rs.Data("dimIdCol1")	//loc
		continue:LocId'=LodDr
		s OpNum=$g(rs.Data("kpiValueCol1"))		//手术人数
		s OpLevelId=rs.Data("dimIdCol3")	//OpLevelId
		s ^TEMPDHCWL($j,"OpLevelId",OpLevelId)=$g(^TEMPDHCWL($j,"OpLevelId",OpLevelId))+$g(OpNum)
		
	}
	s oneNum=$g(^TEMPDHCWL($j,"OpLevelId",19))
	s twoNum=$g(^TEMPDHCWL($j,"OpLevelId",20))
	s threeNum=$g(^TEMPDHCWL($j,"OpLevelId",21))
	s fourNum=$g(^TEMPDHCWL($j,"OpLevelId",22))
	s noneNum=$g(^TEMPDHCWL($j,"OpLevelId",9999))
	s:oneNum="" oneNum=0
	s:twoNum="" twoNum=0
	s:threeNum="" threeNum=0
	s:fourNum="" fourNum=0
	s:noneNum="" noneNum=0
	s totalNum=$g(oneNum)+$g(twoNum)+$g(threeNum)+$g(fourNum)+$g(noneNum)
	s locDesc=$p(^CTLOC(LocId),"^",2)
	s:locDesc["-" locDesc=$p(locDesc,"-",2)
	s ^||CacheTemp(repid,ind)=$lb(ind,LocId,locDesc,oneNum,twoNum,threeNum,fourNum,noneNum,totalNum)
	S ind=ind+1
	
	k ^TEMPDHCWL($j)   
	Quit $$$OK
	/*s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		s loc=(rs.Data("dimIdCol1"))
		s opleve=(rs.Data("dimIdCol3"))
	    s docdr=(rs.Data("dimIdCol2"))       ;主诊组
		s OPNum=$g(rs.Data("kpiValueCol1"))  ; 手术人数
		
		s docrowid=""
		s docrowid=$o(^SSU("SSUSR",0,"CTPCP",docdr,docrowid)) 
		continue:docdr=""
		continue:docrowid=""
		s docdID=$P(^SSU("SSUSR",+docrowid),"^",1)
		s DocGroupStr=##class(DtPortal.Common.PaadmService).GetMUIDDesc(loc,docdID)
	    i DocGroupStr="" s DocGroupStr=LocId_"||0^无"
        s DocGroupID=$p(DocGroupStr,"^",1)
        i opleve=5 s opleve=4
	    s ^TEMPDHCWL($j,"Loc",DocGroupID,opleve)=$g(^TEMPDHCWL($j,"Loc",DocGroupID,opleve))+OPNum 
	}
      ;b  ;
	  s docgroupid=""
	  f  s docgroupid=$o(^TEMPDHCWL($j,"Loc",docgroupid))  q:docgroupid=""  d  
	   
	   .i docgroupid'["||0" s MuLocID=$p(docgroupid,"||",1), MuID=$p(docgroupid,"||",2), docgroupdesc=$p(^CTLOC(MuLocID,"MU",MuID),"^",2)
	   .else  s docgroupdesc="其他"
	   .s oneNum=$g(^TEMPDHCWL($j,"Loc",docgroupid,1))
	   .s twoNum=$g(^TEMPDHCWL($j,"Loc",docgroupid,2))
	   .s threeNum=$g(^TEMPDHCWL($j,"Loc",docgroupid,3))
	   .s fourNum=$g(^TEMPDHCWL($j,"Loc",docgroupid,4))
	   .i oneNum="" s oneNum=0 
	   .i twoNum="" s twoNum=0 
	   .i threeNum="" s threeNum=0 
	   .i fourNum="" s fourNum=0 
	   .s ^||CacheTemp(repid,ind)=$lb(docgroupid,docgroupdesc,oneNum,twoNum,threeNum,fourNum,opLevelId) 
	  .S ind=ind+1*/
}

/// 查询各个科室主诊组手术例数详细信息
/// 服务序号:MD36.01.04    11219  12190
/// ^Data.AnaesthesiaI("OPSDateIdx",OPStartDate,id)    修改为新表结构 By Zhaoruixiao1 2017.2.9
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData03","2019-03","93","19")
Query MainData03(stratdate As %String, locId As %String, opLevelId As %String, CTMUCode As %String = "") As DtPortal.Query(ROWSPEC = "index,OPAStartDateTime,SurgeonStartTime,PatName,OpName,Sex,Age,MedCareNo,OPAOpRoom,OPASeq,opLevelId,anmetDesc,PaadmType") [ SqlProc ]
{
}

ClassMethod MainData03Execute(ByRef qHandle As %Binary, stratdate As %String, locId As %String, opLevelId As %String, CTMUCode As %String = "") As %Status
{
	n (qHandle,stratdate,locId,opLevelId,CTMUCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set startTime=$p($h,",",2)

	s docrowid=""   s docdID=""
	s currentYear=$p($zd(+$H,3),"-",1)		//当前年
	s currentMonth=$p($zd(+$H,3),"-",2)		//当前月
	s currentYM=currentYear_"-"_currentMonth	//当前年月
	if stratdate=currentYM{
		s endDate=$Zd(+$H-1,3)
		
	}else{
		s days=##class(DHCWL.util.DateUtil).GetMonthDays(stratdate)	//获取当月的天数
		s endDate=stratdate_"-"_days
	}
	
	
   	set startDate=stratdate_"-01"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)

	
	//for date=startDate:1:endDate{
		//调用手麻接口获取患者信息
		s obj2=##class(web.DHCANAdaptor).GetANOperation(startDate,endDate,"","","LF")
		Set reader = ##class(%XML.Reader).%New()
		Do reader.OpenStream(obj2)
		Do reader.Correlate("PatInfo","web.DHCANInterface")
		Set Num2=0
		While (reader.Next(.object,.sc)) {	
			
			s opaPatDeptDr=object.OPAAppLocDr 
			
			continue:opaPatDeptDr'=locId
			
			
			s OpLevelId=object.opLevelId
			s:OpLevelId="" OpLevelId=9999
			continue:OpLevelId'[opLevelId
		
			set OpName=object.OpName	//手术ID
			set PatName=object.PatName	//姓名
			set EpisodeID=object.EpisodeID	//就诊号
			set RegNo=object.RegNo		//登记号
			set OpDate=object.OpDate	//手术日期
			set OPAStartDateTime=$p(object.OPAStartDateTime," ",2)	//手术开始时间
			set OpName=object.OpName	//手术名称
			
			set nameStr=""
	       	s len=$l(OpLevelId,"|")
			for i=1:1:len d
			.s tempstr=$p(OpLevelId,"|",i)
			
			.i (tempstr[opLevelId)&(nameStr'="")  s nameStr=nameStr_","_$p(OpName,",",i)
			.i (tempstr[opLevelId)&(nameStr="")  s nameStr=$p(OpName,",",i)
			
			
			set OpName=nameStr
			set Age=object.Age		//年龄
			set Sex=object.Sex		//性别
			set MedCareNo=object.MedCareNo	//病案号
			set PaadmType=$p($g(^PAADM(EpisodeID)),"^",2)	//就诊类型,I,O,E
			
			;set MedCareNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(EpisodeID,PaadmType)
			set OPAOpRoom=object.OPAOpRoom	//手术间描述
			set OPASeq=object.OPASeq		//手术台次
			if opLevelId=9999 {
				set opLevelDesc="其他"
			}else{
				set opLevelDesc=object.opLevelDesc		//手术级别	
			}
			set AnaMethod=object.AnaMethod	//麻醉方法
				set ^||CacheTemp(repid,ind)=$lb(ind,OpDate,OPAStartDateTime,PatName,OpName,Sex,Age,MedCareNo,OPAOpRoom,OPASeq,opLevelDesc,AnaMethod,PaadmType)
			Set ind=ind+1
		} 	
	//}
	
	Quit $$$OK
    /*f date=startDate:1:endDate d 
    .s bTime=$p($h,",",2)
	.s wlanrowid=0 f  s wlanrowid=$o(^Data.AnaesthesiaI("OPSDateIdx",date,wlanrowid)) q:wlanrowid=""  d
    ..s PatLocDr=$list(^Data.AnaesthesiaD(wlanrowid),37)    //病人所在科室 
    ..quit:PatLocDr=""
    ..s DocDepDR=$list(^Data.AnaesthesiaD(wlanrowid),23)    //申请科室
    ..if (DocDepDR=""||DocDepDR=0) set DocDepDR=PatLocDr		//当申请科室为空，就取病人科室 
    ..quit:PatLocDr'=locId
    ..s OPCategory=$list(^Data.AnaesthesiaD(wlanrowid),68)   //手术级别
    ..s:OPCategory="" OPCategory=9999
    ..quit:OPCategory'=opLevelId
    ..s operdocdr=$list(^Data.AnaesthesiaD(wlanrowid),32)    //主刀医生
    
    ..//s CTMUStr=##class(DtPortal.Common.PublicService).getCTMUDesc(operdocdr,date,"")	//根据综合查询的方法获取到医师组的描述_"^"_code
    ..//s MUCode=$p(CTMUStr,"^",2)
    ..//s:MUCode="" MUCode=0
    ..//quit:MUCode'=CTMUCode

    ..//获取科室组对应的科室
    ..//s MULocId=$p(CTMUStr,"^",3)
    ..//i MULocId="" s MULocId=DocDepDR	//当没有维护科室组的，就为申请科室
    ..//i operdocdr="" s MULocId=PatLocDr	//当主刀医师为空，就为病人所在科室
    ..//q:MULocId'=locId
    ..s EpisodeID=$list(^Data.AnaesthesiaD(wlanrowid),33) 	//就诊号
  
  	..s operdocdesc=""
    ..i +$g(operdocdr)'=0  d
    ...s docrowid=$o(^SSU("SSUSR",0,"CTPCP",operdocdr,docrowid)) 
    ...q:docrowid=""
	...s docdID=$P(^SSU("SSUSR",+docrowid),"^",1)
	...s operdocdesc=$P(^SSU("SSUSR",+docrowid),"^",2)
	..e  s operdocdesc=operdocdr	//存在主刀医师为汉字的情况

	
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)    ;姓名
	
	..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)  ;登记号
	..s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)  ;住院号
	..s opNamenew=$list(^Data.AnaesthesiaD(wlanrowid),30)	;手术名称
	..s topdate=$zd(date,3)
	
	..s opaStartTime=$zt($list(^Data.AnaesthesiaD(wlanrowid),57),3)  //   手术开始

    ..s ^||CacheTemp(repid,ind)=$lb(wlanrowid,patName,medCareNo,topdate,opaStartTime,operdocdesc,opNamenew)
	..S ind=ind+1*/
}

/// 查询全院各科某月手术工作量的数量
/// 服务序号:MD36.02.01
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData04","2","2016")
Query MainData04(dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "monthy,opleve,opleveDesc,Num") [ SqlProc ]
{
}

ClassMethod MainData04Execute(ByRef qHandle As %Binary, dtype As %String, startDate As %String, hospitalId As %String = "", endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,dtype,opLevelId,startDate,hospitalId ,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s endDate=startDate
    s kpiRule="KPPDD070201A"
    i dtype=2 s dateType="byMonth"
    k ^TEMPDHCWL($j)
	s startDaten=startDate_"-01", endDate=startDate_"-12"   
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年01月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年02月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年03月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年04月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年05月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年06月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年07月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年08月")=0
    s ^TEMPDHCWL($j,"opLevelId",startDate_"年09月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年10月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年11月")=0
	s ^TEMPDHCWL($j,"opLevelId",startDate_"年12月")=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDaten,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		
		s locId=$g(rs.Data("dimIdCol1")) 
		
		q:locId=""
		set hospID=$p($g(^CTLOC(locId)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		
		s opLeveDesc=(rs.Data("dimDesCol3"))   ;手术类型描述
		s opLeveId=(rs.Data("dimIdCol3"))   ;手术类型描述
		s OPNum=$g(rs.Data("kpiValueCol1"))  ; 手术人数 
		s month=rs.Data("month")
		s opLevel=opLeveId_"^"_opLeveDesc
	    s ^TEMPDHCWL($j,"opLeveDesc",month,opLevel)=$g(^TEMPDHCWL($j,"opLeveDesc",month,opLevel))+$g(OPNum) 
	}
	
    s month="",opleveDesc=""
	f  s month=$o(^TEMPDHCWL($j,"opLeveDesc",month)) q:month=""  d
	.s monthn=$tr(month,"年","-"), monthy=$tr(monthn,"月","")
    .s oplevel=""
	. f  s oplevel=$o(^TEMPDHCWL($j,"opLeveDesc",month,oplevel))  q:oplevel=""  d
	..s Num=$g(^TEMPDHCWL($j,"opLeveDesc",month,oplevel))
	..s optype=$p(oplevel,"^",1)
	..s opTypeDesc=$p(oplevel,"^",2)  
	..s ^||CacheTemp(repid,ind)=$lb(month,optype,opTypeDesc,Num) 
	..S ind=ind+1
 	k ^TEMPDHCWL($j)   
	Quit $$$OK
}

// 获取手术名称

// 17243668^1

// w ##class(DtPortal.MD.MDDocoperation).GetopName("17153135","1")

ClassMethod GetopName(EpisodeID, anaSub)
{
	new (EpisodeID,anaSub)
	s i=0
	s opName="",anaOPSurgeonDR="",operId="",opLevelDesc="",opLevelId=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	    .s i=i+1
		.q:i>1
		.s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
		.s anaOPSurgeonDR=$g(docdr)
		.s anaOpSurgeon=##class(web.DHCANOPCom).GetNameById(anaOPSurgeonDR)
		.s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
		.i curOperId'="" d
		..i $d(^ORC("OPER",curOperId)) d
		...i opName="" s opName=$P(^ORC("OPER",curOperId),"^",2),operId=curOperId
		...e  s opName=$G(opName)_","_$P(^ORC("OPER",curOperId),"^",2),operId=operId_"|"_curOperId
		.e  d
		..i $G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))'="" d
		...i opName'="" s opName=opName_","
		...s opName=opName_$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)),operId=operId_"|"_curOperId
	q opName
}

// 取手术分级

// w ##class(DtPortal.MD.MDDocoperation).GetANCOPLDesc("3")

ClassMethod GetANCOPLDesc(mANCOPLId)
{
 	q:$g(mANCOPLId)="" "其他"
 	s mReturn="Null"
 	i $d(^ORC("CATEG",mANCOPLId)) s mANCOPLDesc=$p(^ORC("CATEG",mANCOPLId),"^",2)   
 	e  s mANCOPLDesc="其他"
 	i $G(mANCOPLDesc)="" s mANCOPLDesc="其他"
	s mReturn=mANCOPLDesc 
 	q $g(mReturn)
}

// w ##class(DtPortal.MD.MDDocoperation).ceshi()

// csq 2016-08-01

// 如果查询当前月并且当前月日期>7则当前月日期-7，否则按01处理

// 如果查询当前月上个月，判断当前月日子是否超过7号，超过7号则正常显示一个月总和，不超过则按照当前日期-8。

// 如果小于当前月1月以上，则不做判断正常显示。

// d ##class(DtPortal.MD.MDDHCAnopTime).GetTime("2016-07")

ClassMethod GetTime(stratdaten)
{
	
	    s yea=$p(stratdaten,"-",1)
		s stratdate=stratdaten_"-01"
		s mon=$p($zd($zdh(stratdate,3),13),"/",2)
		i mon'=12 s mon=mon+1,endDate=$zd($zdh(yea_"-"_mon_"-01",3)-1,3)
		else  s endDate=yea_"-12-31"
		i $zdh(endDate,3)>($p($h,",",1)-1) s endDate=$zd($p($h,",",1),3)	
		s mon=$p(stratdaten,"-",2),monnew=$p($zd(+$h,3),"-",2),daynew=$p($zd(+$h,3),"-",3)
		i (mon=monnew)&&(daynew>7) s endDate=$zd(($zdh(endDate,3)-7),3)
		i (mon=monnew)&&(daynew<8) s endDate=$p(endDate,"-",1)_"-"_$p(endDate,"-",2)_"-"_"01"
		i (monnew-mon=1)&&(daynew<8) s endDate=$zd((+$h-8),3) 
		;w stratdate_"###"_endDate,!
		q stratdate_"^"_endDate
}

/// 查询全院各科室某年（1-12月）的手术时间
/// 服务序号:MD36.03.01
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData06","2","2016-01")
Query MainData06(type As %String, startDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locDesc,TimeHours") [ SqlProc ]
{
}

ClassMethod MainData06Execute(ByRef qHandle As %Binary, type As %String, startDate As %String, hospitalId As %String = "") As %Status
{
	n (qHandle,type,startDate,hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	;dateType,kpiRule,filterRule,mode,contract
	s dateType="",kpiRule="",filterRule="",mode="H",contract=""
	;s kpiRule="KPPDD070201B" ,CTLOCNum=0  
	s kpiRule="KPPMD290101" ,CTLOCNum=0
	s dateType="byMonth"
	k ^TEMPDHCWL($j)
    ;s filterRule="HLGZL:({war}="_ward_")"
    i type=1   
    {
	 s startDaten=startDate_"-01", endDate=startDate_"-12"    
	s TimeNum=0 
	s ^TEMPDHCWL($j,startDate_"年01月")=0
	s ^TEMPDHCWL($j,startDate_"年02月")=0
	s ^TEMPDHCWL($j,startDate_"年03月")=0
	s ^TEMPDHCWL($j,startDate_"年04月")=0
	s ^TEMPDHCWL($j,startDate_"年05月")=0
	s ^TEMPDHCWL($j,startDate_"年06月")=0
	s ^TEMPDHCWL($j,startDate_"年07月")=0
	s ^TEMPDHCWL($j,startDate_"年08月")=0
    s ^TEMPDHCWL($j,startDate_"年09月")=0
	s ^TEMPDHCWL($j,startDate_"年10月")=0
	s ^TEMPDHCWL($j,startDate_"年11月")=0
	s ^TEMPDHCWL($j,startDate_"年12月")=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDaten,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s locDescID=(rs.Data("dimIdCol1"))
		set hospID=$p($g(^CTLOC(locDescID)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		s locDesc=$p($g(^CTLOC(locDescID)),"^",2)
		i locDesc["-" s locDesc=$p(locDesc,"-",2)
		s month=(rs.Data("month"))
		s Time=$fn($g(rs.Data("kpiValueCol1")),"",2)  ; 手术时间
		s ^TEMPDHCWL($j,month)=$g(^TEMPDHCWL($j,month))+Time
	    
	}
	b ;data
	s month="",locDesc="全院"
	f  s month=$o(^TEMPDHCWL($j,month)) q:month=""  d
	 .s TimeNum=$g(^TEMPDHCWL($j,month))
	 .s monthn=$tr(month,"年","-"), monthy=$tr(monthn,"月","")
	 .s ^||CacheTemp(repid,ind)=$lb(monthy,TimeNum) 
	 .S ind=ind+1
	
	}
	i type=2
	{
		
	 	s yea=$p(startDate,"-",1)
	s startDate=startDate_"-01"
	s mon=$p($zd($zdh(startDate,3),13),"/",2)
	i mon'=12 s mon=mon+1,endDate=$zd($zdh(yea_"-"_mon_"-01",3)-1,3)
	else  s endDate=yea_"-12-31"
	i $zdh(endDate,3)>($p($h,",",1)-1) s endDate=$zd($p($h,",",1)-1,3)	

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
	
		s locDescID=(rs.Data("dimIdCol1"))
		set hospID=$p($g(^CTLOC(locDescID)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		s locDesc=$p($g(^CTLOC(locDescID)),"^",2)
		i locDesc["-" s locDesc=$p(locDesc,"-",2)
		s Time=$fn($g(rs.Data("kpiValueCol1")),"",2)  ; 手术时间
		//s TimeHours=$fn(Time/3600,"",2)
	    s ^||CacheTemp(repid,ind)=$lb(locDesc,Time) 
	    S ind=ind+1
	}
		
	}
	k ^TEMPDHCWL($j)
	  
	Quit $$$OK
}

/// 查询全院某月某手术工作量的科室分布
/// 按主诊组分
/// 服务序号:MD36.02.03
/// LocId:科室Id;startDate:日期；opTypeId：手术类型Code(EL：择期；EM:急诊；TO:超时执行)
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData010","1","2017-03","EL")
Query MainData010(LocId As %String, startDate As %String, opTypeId As %String, endDate As %String = "", dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "ind,LocId,opTypeId,locDescID,locDesc,Num") [ SqlProc ]
{
}

ClassMethod MainData010Execute(ByRef qHandle As %Binary, LocId As %String, startDate As %String, opTypeId As %String = "", endDate As %String = "", dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,dtype,LocId,startDate,opTypeId,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s endDate=startDate
	//s kpiRule="KPPMDOptype01" ,CTLOCNum=0
	s kpiRule="PMDOPTYPE36"
	s dateType="byMonth"
    s filterRule=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locDescID=(rs.Data("dimIdCol1"))	//科室id
		continue:locDescID'=LocId
		set opType=rs.Data("dimIdCol3")   		//手术类别
		continue:opType'=opTypeId
		set CTMUCode=rs.Data("dimIdCol2")   		//主诊组Code，按照主刀医师和手术开始时间来获取的
		set opNum=$g(rs.Data("kpiValueCol1"))  		// 手术人数
		//w "LocId="_LocId_"^opTypeId="_opTypeId_"^CTMUCode="_CTMUCode_"^opNum="_opNum,!
		set ^TEMPDHCWL($j,"CTMUCode",CTMUCode)=$g(^TEMPDHCWL($j,"CTMUCode",CTMUCode))+$g(opNum)
	}
	set CTMUCode=""
	for{
		set CTMUCode=$o(^TEMPDHCWL($j,"CTMUCode",CTMUCode))
		quit:CTMUCode=""
		if CTMUCode=0{
			set CTMUDesc="其他"
		}else{
			//根据主诊组Code获取到描述
			set CTMUDesc=$p(##class(DtPortal.Common.PublicService).getCTMUDescByCTMUCode(CTMUCode),"^",1)
		}
		set opNum=$g(^TEMPDHCWL($j,"CTMUCode",CTMUCode))	//手术量
		set ^||CacheTemp(repid,ind)=$lb(ind,LocId,opTypeId,CTMUCode,CTMUDesc,opNum) 
		set ind=ind+1
	}
	 
	k ^TEMPDHCWL($j)   
	Quit $$$OK
	/*While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s locDescID=(rs.Data("dimIdCol1"))
		continue:locDescID'=LocId
		s locDesc=$p($g(^CTLOC(locDescID)),"^",2)
		s opType=rs.Data("dimIdCol3")   ;手术类别
		s docdr=rs.Data("dimIdCol2")
		continue:+docdr=0
		s docrowid=""
		s docrowid=$o(^SSU("SSUSR",0,"CTPCP",docdr,docrowid)) 
	    s docdID=$P(^SSU("SSUSR",+docrowid),"^",1)
		s OPNum=$g(rs.Data("kpiValueCol1"))  ; 手术人数
		s DocGroupStr=##class(DtPortal.Common.PaadmService).GetMUIDDesc(LocId,docdID)
        s DocGroupID=$p(DocGroupStr,"^",1) 
        i DocGroupID="" s DocGroupID=LocId_"||0"
        continue:DocGroupID=""
        i opTypeId=1 s opTyepDesc="急诊"
        i opTypeId=2 s opTyepDesc="择期"      
        continue:opTyepDesc'=opType
	    s ^TEMPDHCWL($j,"Loc",DocGroupID)=$g(^TEMPDHCWL($j,"Loc",DocGroupID))+OPNum 
	}
	  s docgroupid=""
	  f  s docgroupid=$o(^TEMPDHCWL($j,"Loc",docgroupid))  q:docgroupid=""  d
	   .i docgroupid'["||0" s MuLocID=$p(docgroupid,"||",1), MuID=$p(docgroupid,"||",2), docgroupdesc=$p(^CTLOC(MuLocID,"MU",MuID),"^",2)
	   .else  s docgroupdesc="其他"
	   .s Num=$g(^TEMPDHCWL($j,"Loc",docgroupid))
	  .s ^||CacheTemp(repid,ind)=$lb(docgroupid,docgroupdesc,Num) 
	  .S ind=ind+1*/
}

// 134||26:朱富高组:8:1:

/// 查询各个科室主诊组手术工作量详细信息
/// 服务序号:MD36.02.04
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MainData031","2017-03","1","0","EL")
/// 134||30:姜彦组:5:2:
Query MainData031(stratdate As %String, locId As %String, CTMUCode As %String, opTypeId As %String) As DtPortal.Query(ROWSPEC = "ind,patName,regNo,medCareNo,anaSourceTypeDesc,docgroupdesc,opNamenew,operdocdesc,opaStartTime,topdate") [ SqlProc ]
{
}

ClassMethod MainData031Execute(ByRef qHandle As %Binary, stratdate As %String, locId As %String, CTMUCode As %String, opTypeId As %String) As %Status
{
	n (qHandle,stratdate,locId,CTMUCode,opTypeId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//b ;111
	set currentYear=$p($zd(+$H,3),"-",1)		//当前年
	set currentMonth=$p($zd(+$H,3),"-",2)		//当前月
	set currentYM=currentYear_"-"_currentMonth	//当前年月
	if stratdate=currentYM{
		set endDate=$Zd(+$H,3)
	}else{
		set days=##class(DHCWL.util.DateUtil).GetMonthDays(startDate)	//获取当月的天数
		set endDate=stratdate_"-"_days
	}
	set startDate=stratdate_"-01"
	//数字格式的时间
	set startDateNo=$zdh(startDate,3)
	set endDateNo=$zdh(endDate,3)
	//b ;
	set date=""
	for date=startDateNo:1:endDateNo{
		set wlanrowid=0 
		for{
			  set wlanrowid=$o(^Data.AnaesthesiaI("OPSDateIdx",date,wlanrowid)) 
			  quit:wlanrowid=""
			  set PatLocDr=$list(^Data.AnaesthesiaD(wlanrowid),37)    //病人所在科室 
    		  quit:PatLocDr=""
    		  set DocDepDR=$list(^Data.AnaesthesiaD(wlanrowid),23)    //申请科室 
    		  if (DocDepDR=""||DocDepDR=0) set DocDepDR=PatLocDr		//当申请科室为空，就取病人科室
			  set ANOPType=$list(^Data.AnaesthesiaD(wlanrowid),3)	//手术类型
			  continue:ANOPType'=opTypeId
			  set operdocdr=$list(^Data.AnaesthesiaD(wlanrowid),32)    //主刀医生 
			  set CTMUStr=##class(DtPortal.Common.PublicService).getCTMUDesc(operdocdr,date,"")	//根据综合查询的方法获取到医师组的描述_"^"_code
			  set MUCode=$p(CTMUStr,"^",2)
    		  set:MUCode="" MUCode=0
    		  continue:MUCode'=CTMUCode
    		  //医生科室组描述
    		  set CTMUDesc=""
    		  if MUCode=0{
	    	  	set CTMUDesc="其他"
	    	  }else{
		     	set CTMUDesc=$p(CTMUStr,"^",1)	 
		      }
    		 
    		 //获取科室组对应的科室
    		set MULocId=$p(CTMUStr,"^",3)
    		if MULocId="" set MULocId=DocDepDR	//当没有维护科室组的，就为申请科室
    		if operdocdr="" set MULocId=PatLocDr	//当主刀医师为空，就为病人所在科室
    		continue:MULocId'=locId
    		  
    		  //获取手术类型描述
    		  set ANOPTypeDesc=""
    		  if ANOPType="EL"{
	    	  	set ANOPTypeDesc="择期"
	    	  }
	    	  if ANOPType="EM"{
	    	  	set ANOPTypeDesc="急诊"
	    	  }
	    	  if ANOPType="TO"{
	    	  	set ANOPTypeDesc="超时执行"
	    	  }
  
  			  set operdocdesc=""
    	      if +$g(operdocdr)'=0{
	    	  	 set docrowid=$o(^SSU("SSUSR",0,"CTPCP",operdocdr,"")) 
    		  	 quit:docrowid=""
				 set docdID=$P(^SSU("SSUSR",+docrowid),"^",1)
				 set operdocdesc=$P(^SSU("SSUSR",+docrowid),"^",2)
	    	  }
			  else{
				s operdocdesc=operdocdr	//存在主刀医师为汉字的情况
			  }  

			  set EpisodeID=$list(^Data.AnaesthesiaD(wlanrowid),33) 	//就诊号
			  set papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			  set patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)    ;姓名
	
			  set regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)  ;登记号
			  set medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)  ;住院号
			  set opNamenew=$list(^Data.AnaesthesiaD(wlanrowid),30)	;手术名称
			  set topdate=$zd(date,3)
			  set opaStartTime=$zT($list(^Data.AnaesthesiaD(wlanrowid),57),3)  //   手术开始
			 // w "PatLocDr="_PatLocDr_"^MUCode="_MUCode_"^ANOPType="_ANOPType_"^EpisodeID="_EpisodeID,!
			  //b ;111
			  set ^||CacheTemp(repid,ind)=$lb(ind,patName,regNo,medCareNo,ANOPTypeDesc,CTMUDesc,opNamenew,operdocdesc,opaStartTime,topdate)
			  set ind=ind+1
		} 
	}
	Quit $$$OK
	/*n (qHandle,stratdate,docgroupid,opLevelId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		s enddate=stratdate
		s LocId=$p(docgroupid,"||",1)
	i opLevelId=1 s opflag="B"
	i opLevelId=2 s opflag="E"
    s datenew=..GetTime(stratdate)
	s stratdate=$p(datenew,"^",1),endDate=$p(datenew,"^",2)	
	s num=0
	s startDate=$zdh(stratdate,3)
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d 
	.s wlanrowid=0 f  s wlanrowid=$o(^DHCWLAnaesthesia(0,"STATDATE",date,wlanrowid)) q:wlanrowid=""  d
    ..s optype=$p(^DHCWLAnaesthesia(wlanrowid),"^",4)   ;就诊类型
    ..s recopdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",63)   ;接收科室
    ..s opLevelCodene=$p(^DHCWLAnaesthesia(wlanrowid),"^",72)    ;手术级别
    ..s OPArowid=$p(^DHCWLAnaesthesia(wlanrowid),"^",66)	;手术申请表ID
    ..s PatLocDr=$p(^DHCANOPArrange(OPArowid),"^",54)	;手术申请科室
    ..s operdocdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",50)    ;主刀医生
    ..s operdocdesc=$p($g(^CTPCP(operdocdr,1)),"^",2)    ;主刀医生
    ..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s EpisodeID=$P($g(^DHCANOPArrange(OPArowid)),"^",1)
    ..s anaSub=$P(anaId,"||",2)
    ..s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	..i anaSourceType="E" s anaSourceTypeDesc="急诊"
	..e  s anaSourceTypeDesc="择期"
	..i anaSourceType'="E" s anaSourceType="B"
	..q:anaSourceType'=opflag
	..s docid=$tr($p($g(^CTPCP(operdocdr,1)),"^",1),"-","")       ;主诊组
	..;w docid,!
    ..s docstr=##class(DtPortal.Common.PaadmService).GetMUIDDesc(PatLocDr,operdocdr)
   	..s opaStartTime=##class(web.DHCANOrder).GetAnoEventSingle(OPArowid,"szsj004",1,"Y","","")  //   手术开始
	..s docgroup=$p(docstr,"^",1)
	..q:docgroup'=docgroupid
	..;w docgroup,!
	..s docgroupdesc=$p(docstr,"^",2)
	..;w docgroup_"^"_operdocdr,!
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)    ;姓名
	..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)  ;登记号
	..s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)  ;住院号
	..s opNamenew=..GetopName(EpisodeID,anaSub)
	..s topdate=$zd(date,3)
	..;w EpisodeID,!
	..s num=num+1
    ..s ^||CacheTemp(repid,ind)=$lb(patName,regNo,medCareNo,anaSourceTypeDesc,docgroupdesc,opNamenew,operdocdesc,opaStartTime,topdate)
	..S ind=ind+1
	Quit $$$OK*/
}

// MD36.04.01统计各个科室各个类型停台率的数目和比例

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MD360401","2017-07")

Query MD360401(startDate As %String) As DtPortal.Query(ROWSPEC = "locDescID,OPAllANum,OPStopCNum,OPStopCRate,OPStopSNum,OPStopSRate,OPStopANum,OPStopARate") [ SqlProc ]
{
}

ClassMethod MD360401Execute(ByRef qHandle As %Binary, startDate As %String) As %Status
{
	n (qHandle,startDate,endDate,locid)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s monthdays=##class(DHCWL.util.DateUtil).GetMonthDays(startDate)
	s endDate=startDate
	s startDate=startDate_"-01"
	s endDate=endDate_"-"_monthdays
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
 	f day=SDate:1:EDate d
	.s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
	..s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室	
	..s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	..i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	
	..s ^TEMPDHCWL($j,appLocId,"zs")=$g(^TEMPDHCWL($j,appLocId,"zs"))+1
	..s OPAStatus=$p(^DHCANOPArrange(OPArowid),"^",27)
	..q:OPAStatus'="D"
	..s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s anaSub=$P(anaId,"||",2)
    ..s operLocId=""
    ..s anaopSub=""
	..f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	...q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
	...s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)
	..i operLocId="" s ^TEMPDHCWL($j,appLocId,"ssstt")=$g(^TEMPDHCWL($j,appLocId,"ssstt"))+1
	..e  s ^TEMPDHCWL($j,appLocId,"bqtt")=$g(^TEMPDHCWL($j,appLocId,"bqtt"))+1
	

	s appLocId="" f  s appLocId=$o(^TEMPDHCWL($j,appLocId)) q:appLocId=""  d
	.s locDescID=$p(^CTLOC(appLocId),"^",2)
	.s OPAllANum=$g(^TEMPDHCWL($j,appLocId,"zs"))
	.s OPStopCNum=$g(^TEMPDHCWL($j,appLocId,"ssstt"))
	.s OPStopSNum=$g(^TEMPDHCWL($j,appLocId,"bqtt"))
	.s OPStopANum=OPStopCNum+OPStopSNum
	.s OPStopCRate=OPStopCNum/OPAllANum
	.s OPStopSRate=OPStopSNum/OPAllANum
	.s OPStopCRate=OPStopCNum/OPAllANum
	.s OPStopARate=OPStopANum/OPAllANum

	.s ^||CacheTemp(repid,ind)=$lb(locDescID,OPAllANum,OPStopCNum,OPStopCRate,OPStopSNum,OPStopSRate,OPStopANum,OPStopARate)
 	.s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

// MD36.04.03查询可是某月某类型手术的详情

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","MD360403","2018-08","2","114","2")

Query MD360403(startDater As %String, sslx As %String, loc As %String, sx As %String) As DtPortal.Query(ROWSPEC = "OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo,OpOrdNo") [ SqlProc ]
{
}

ClassMethod MD360403Execute(ByRef qHandle As %Binary, startDate As %String, sslx As %String, loc As %String, sx As %String) As %Status
{
	n (qHandle,startDate,endDate,sslx,loc,sx)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s monthdays=##class(DHCWL.util.DateUtil).GetMonthDays(startDate)
	s endDate=startDate
	s startDate=startDate_"-01"
	s endDate=endDate_"-"_monthdays
	
	s (OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo,OpOrdNo)=""
	if sx=1{
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
 	f day=SDate:1:EDate d
	.s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
	..s OPAStatus=$p(^DHCANOPArrange(OPArowid),"^",27)
	..q:OPAStatus'="D"	
	
	..s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
	..s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	..i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	
	..i loc'="" q:loc'=appLocId
	..s OpRoom=""
	..s oproomdr=$P(^DHCANOPArrange(OPArowid),"^",20)
	..i oproomdr'="" s OpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2) ;手术间

	
	..s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s anaSub=$P(anaId,"||",2)
   	..s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; 麻醉医师
    
	..s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	..i anaSourceType="E" s anaSourceTypeDesc="1"
	..e  s anaSourceTypeDesc="2"    
	..i sslx'="" q:sslx'=anaSourceTypeDesc
	
	..s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; 麻醉医师
	
	..s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40) ;入室时间
	..s rettimedate=##class(web.DHCANCom).GetANDateTime(OPArowid) ;麻醉开始时间
	..s opsttime=$P(^DHCANOPArrange(OPArowid),"^",15)	;手术开始时间
	..s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	..s anaMethod=""
	..i anmthdr'="" d
	...s anmetNum=$l(anmthdr,"|")
	...f i=1:1:anmetNum d
	....s anmetId=$p(anmthdr,"|",i)
	....s anmetDesc=""
	....i anmetId="" s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
	....i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	....i anaMethod="" s anaMethod=anmetDesc
	....e  s anaMethod=anaMethod_"^"_anmetDesc


   
    ..s operLocId=""
    ..s anaopSub=""
	..f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	...s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8) ;主刀医生
	
	
	...q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
	...s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)
	...;w $p(^CTLOC(operLocId),"^",2)
	..q:operLocId=""
	
	..s OpDate=$zd(day,3)
	..i docdr'="" s Surgon=$p(^CTPCP(docdr,1),"^",2)
	..i anadr'="" s AnaDoc=$p(^CTPCP(anadr,1),"^",2)
	..s InroomTime=$zt(inRoomTime)
	..s AnaStartTime=$zt(rettimedate)
	..s OpaStartTime=$zt(opsttime)
	..s AppLoc=$p(^CTLOC(appLocId),"^",2)
	..s AnaMehtod=anaMethod
	..s papmi=$p(^PAADM(EpisodeID),"^",1)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)
	..s RegNo=$$GetPapmiNo^DHCWLCommon(papmi)
	..s OpOrdNo=""
	..s ^||CacheTemp(repid,ind)=$lb(OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo,OpOrdNo)
 	..s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

	if sx=2{
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
 	f day=SDate:1:EDate d
	.s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
	..s OPAStatus=$p(^DHCANOPArrange(OPArowid),"^",27)
	..q:OPAStatus'="C"
	..s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
	..s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	..i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	..i loc'="" q:loc'=appLocId
	
	..s OpRoom=""
	..s oproomdr=$P(^DHCANOPArrange(OPArowid),"^",20)
	..i oproomdr'="" s OpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2) ;手术间

	
	..s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s anaSub=$P(anaId,"||",2)
    
	..s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	..i anaSourceType="E" s anaSourceTypeDesc="1"
	..e  s anaSourceTypeDesc="2"    
	..i sslx'="" q:sslx'=anaSourceTypeDesc
	
	..s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; 麻醉医师
	
	..s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40) ;入室时间
	..s rettimedate=##class(web.DHCANCom).GetANDateTime(OPArowid) ;麻醉开始时间
	..s opsttime=$P(^DHCANOPArrange(OPArowid),"^",15)	;手术开始时间
	..s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	..s anaMethod=""        
	..i anmthdr'="" d
	...s anmetNum=$l(anmthdr,"|")
	...f i=1:1:anmetNum d
	....s anmetId=$p(anmthdr,"|",i)
	....q:anmetId=""
	....s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
	....i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	....i anaMethod="" s anaMethod=anmetDesc
	....e  s anaMethod=anaMethod_"^"_anmetDesc


    
    ..s operLocId=""
    ..s anaopSub=""
	..f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	...s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8) ;主刀医生
	
	
	...q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
	...s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)
	..q:operLocId=""
	
	..s OpDate=$zd(day,3)
	..s Surgon=""
	..i docdr'="" s Surgon=$p(^CTPCP(docdr,1),"^",2)
	..s AnaDoc=""
	..i anadr'="" s AnaDoc=$p(^CTPCP(anadr,1),"^",2)
	..s InroomTime=$zt(inRoomTime)
	..s AnaStartTime=$zt(rettimedate)
	..s OpaStartTime=$zt(opsttime)
	..s AppLoc=$p(^CTLOC(appLocId),"^",2)
	..s AnaMehtod=anaMethod
	..s papmi=$p(^PAADM(EpisodeID),"^",1)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)
	..s RegNo=$$GetPapmiNo^DHCWLCommon(papmi)
	..s OpOrdNo=$P(^DHCANOPArrange(OPArowid),"^",26)
	..s ^||CacheTemp(repid,ind)=$lb(OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo,OpOrdNo)
 	..s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}
	if sx=3{
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
 	f day=SDate:1:EDate d
	.s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
	
	..s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
	..s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	..i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	..i loc'="" q:loc'=appLocId
	..s OpRoom=""
	..s oproomdr=$P(^DHCANOPArrange(OPArowid),"^",20) q:oproomdr=""
	
	..s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	..s opordno=$P(^DHCANOPArrange(OPArowid),"^",26)
	..q:opordno'=1
	..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s anaSub=$P(anaId,"||",2)
    
	..s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	..i anaSourceType="E" s anaSourceTypeDesc="1"
	..e  s anaSourceTypeDesc="2"    
	..i sslx'="" q:sslx'=anaSourceTypeDesc
	
	
	..s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40) ;入室时间
	..q:inRoomTime=""
	..s ^TEMPDHCWL($j,day,oproomdr,inRoomTime)=OPArowid
	s dayy="" f  s dayy=$o(^TEMPDHCWL($j,dayy)) q:dayy=""  d
	
	.s oproomdr="" f  s oproomdr=$o(^TEMPDHCWL($j,dayy,oproomdr)) q:oproomdr=""  d
	..s inRoomTime=$o(^TEMPDHCWL($j,dayy,oproomdr,"")) q:inRoomTime=""  
	..q:inRoomTime<32400  d
	...s OPArowid=$g(^TEMPDHCWL($j,dayy,oproomdr,inRoomTime))
	...s day=$P(^DHCANOPArrange(OPArowid),"^",14) 
	
	...s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	...s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ...s anaSub=$P(anaId,"||",2)
   	...s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; 麻醉医师
   	...s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
   	...s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	...i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)

	

	
	...s rettimedate=##class(web.DHCANCom).GetANDateTime(OPArowid) ;麻醉开始时间
	...s ANAStartDate=$p($g(rettimedate),"^",9) ;麻醉开始日期
	...s anaStartTime=""
	...s surgeonStartTime=""
    ...i anaStartTime=""	s anaStartTime=$p($g(rettimedate),"^",10) ;麻醉开始时间
    ...s SurgeonStartDate=$p($g(rettimedate),"^",13) ;手术开始日期
	...s surgeonStartTime=$p($g(rettimedate),"^",14) ;手术开始时间
    
    ...w surgeonStartTime,!
	...s opInDepttime=$p($g(rettimedate),"^",6) ;	;入室时间
	...s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	...s anaMethod=""        
	...i anmthdr'="" d
	....s anmetNum=$l(anmthdr,"|")
	....f i=1:1:anmetNum d
	.....s anmetId=$p(anmthdr,"|",i)
	.....q:anmetId=""
	.....s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
	.....i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	.....i anaMethod="" s anaMethod=anmetDesc
	.....e  s anaMethod=anaMethod_"^"_anmetDesc


    
    ...s operLocId=""
    ...s anaopSub=""
	...f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	....s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8) ;主刀医生
	
	
	....q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
	....s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)
	...;q:operLocId'=""
	
	...s OpDate=$zd(day,3)
	...s OpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2) ;手术间
	...s Surgon="",AnaDoc=""
	...i docdr'="" s Surgon=$p(^CTPCP(docdr,1),"^",2)
	...i anadr'="" s AnaDoc=$p(^CTPCP(anadr,1),"^",2)
	...s InroomTime=opInDepttime ;$zt(inRoomTime)
	...s AnaStartTime=anaStartTime
	...s OpaStartTime=surgeonStartTime
	...i OpaStartTime="" s OpaStartTime=$zt(inRoomTime),InroomTime=""
	...s AppLoc=$p(^CTLOC(appLocId),"^",2)
	...s AnaMehtod=anaMethod
	...s papmi=$p(^PAADM(EpisodeID),"^",1)
	...s patName=$$GetPapmiName^DHCWLCommon(papmi)
	...s RegNo=$$GetPapmiNo^DHCWLCommon(papmi)
	...s ^||CacheTemp(repid,ind)=$lb(OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo)
 	...s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}
	if sx=4{
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
 	f day=SDate:1:EDate d
	.s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
	
	..s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
	..s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	..i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	..i loc'="" q:loc'=appLocId
	
	..s OpRoom=""
	..s oproomdr=$P(^DHCANOPArrange(OPArowid),"^",20) 
	..i oproomdr="" s oproomdr="88888"

	
	..s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	..s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ..s anaSub=$P(anaId,"||",2)
    
	..s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
	..i anaSourceType="E" s anaSourceTypeDesc="1"
	..e  s anaSourceTypeDesc="2"    
	..i sslx'="" q:sslx'=anaSourceTypeDesc
	
	
	..s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40) ;入室时间
	..s opendtime=$P(^DHCANOPArrange(OPArowid),"^",17) q:opendtime=""
	..s ^TEMPDHCWL($j,day,oproomdr,opendtime)=OPArowid
	
	s dayy="" f  s dayy=$o(^TEMPDHCWL($j,dayy)) q:dayy=""  d
	.s oproomdr="" f  s oproomdr=$o(^TEMPDHCWL($j,dayy,oproomdr)) q:oproomdr=""  d
	..s opendtime=$o(^TEMPDHCWL($j,dayy,oproomdr,""),-1) q:opendtime=""  
	..q:opendtime<61200  d
	...s OPArowid=$g(^TEMPDHCWL($j,dayy,oproomdr,opendtime))
	...s day=$P(^DHCANOPArrange(OPArowid),"^",14) 
	
	...s EpisodeID=$P(^DHCANOPArrange(OPArowid),"^",1)   ;就诊号
	...s anaId=$P(^DHCANOPArrange(OPArowid),"^",2) ;手术麻醉Id
    ...s anaSub=$P(anaId,"||",2)
   	...s anadr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; 麻醉医师
   	...s appLocId=$P($G(^DHCANOPArrange(OPArowid)),"^",54)  ;申请科室
   	...s adm=$P(^DHCANOPArrange(OPArowid),"^",1)
	...i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
	...s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40) ;入室时间
	
	
	...s rettimedate=##class(web.DHCANCom).GetANDateTime(OPArowid) ;麻醉开始时间
	...s opsttime=$P(^DHCANOPArrange(OPArowid),"^",15)	;手术开始时间
	...s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	...s anaMethod=""        
	...i anmthdr'="" d
	....s anmetNum=$l(anmthdr,"|")
	....f i=1:1:anmetNum d
	.....s anmetId=$p(anmthdr,"|",i)
	.....q:anmetId=""
	.....s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
	.....i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	.....i anaMethod="" s anaMethod=anmetDesc
	.....e  s anaMethod=anaMethod_"^"_anmetDesc


    
    ...s operLocId=""
    ...s anaopSub=""
	...f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	....s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8) ;主刀医生
	
	
	....q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
	....s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)
	...;q:operLocId'=""
	
	...s OpDate=$zd(day,3)
	...s OpRoom=""
	...i oproomdr'="88888" s OpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2) ;手术间
	...s Surgon="",AnaDoc=""
	...i docdr'="" s Surgon=$p(^CTPCP(docdr,1),"^",2)
	...i anadr'="" s AnaDoc=$p(^CTPCP(anadr,1),"^",2)
	...s InroomTime=$zt(inRoomTime)
	...s AnaStartTime=$zt(rettimedate)
	...s OpaStartTime=$zt(opsttime)
	...s AppLoc=$p(^CTLOC(appLocId),"^",2)
	...s AnaMehtod=anaMethod
	...s papmi=$p(^PAADM(EpisodeID),"^",1)
	...s patName=$$GetPapmiName^DHCWLCommon(papmi)
	...s RegNo=$$GetPapmiNo^DHCWLCommon(papmi)
	...s OpOrdNo=$P(^DHCANOPArrange(OPArowid),"^",26)
	...s ^||CacheTemp(repid,ind)=$lb(OpDate,OpRoom,Surgon,AnaDoc,InroomTime,AnaStartTime,OpaStartTime,AppLoc,AnaMehtod,patName,RegNo,OpOrdNo)
 	...s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}
}

/// 20170809+dyl+停台率
/// 入参：stdate：开始日期,enddate:结束日期
/// 返回结果：AppLocId：申请科室Id,AppLoc：申请科室描述
/// ,AllOperNum:科室内手术总数,DeclineOperNum：拒绝手术总数,CancelOperNum：撤销手术总数
/// ,DeclinePer:拒绝百分比,CancelPer:撤销百分比
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","OperPercent","2018-08-01","2018-08-27")
Query OperPercent(stdate, enddate, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locID,locDescID,OPAllPNum,OPStopCNum,OPStopSNum,OpStopCRate,OpStopSRate,OPStopANum,OpStopARate")
{
}

ClassMethod OperPercentExecute(ByRef qHandle As %Binary, stdate, enddate, hospitalId As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k LocAllOpList,LocDeclineOpList,LocCancelOpList
	f date=sdate:1:edate
    {
	s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i opaStatus="A" s status="申请"
		.i (opaStatus="D") s status="拒绝",LocDeclineOpList(appLocId,opaId)=""
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕"
		.i opaStatus="F" s status="完成"
		.i (opaStatus="C") s status="撤销",LocCancelOpList(appLocId,opaId)=""
		.q:opaStatus="A"	;申请没有安排不在统计之内
		.s LocAllOpList(appLocId,opaId)=""
    }	
    	s locId="" f  s locId=$o(LocAllOpList(locId)) q:locId=""  d
    	.s apploc=$p(^CTLOC(locId),"^",2)
		.s hospID=$p($g(^CTLOC(locId)),"^",22)
		.q:(hospitalId'="")&&(hospID'=hospitalId)
		
    	
			.s locallnum=0,locdnum=0,loccnum=0,dper="0.00%",cper="0.00%",OPStopANum=0,OpStopARate="0.00%"
			.s topaId="" f  s topaId=$o(LocAllOpList(locId,topaId)) q:topaId=""  d
				..s locallnum=locallnum+1
			.s dopaId="" f  s dopaId=$o(LocDeclineOpList(locId,dopaId)) q:dopaId=""  d
				..s locdnum=locdnum+1
			.s copaId="" f  s copaId=$o(LocCancelOpList(locId,copaId)) q:copaId=""  d
				..s loccnum=loccnum+1
			.s OPStopANum=locdnum+loccnum
			.i locallnum'=0 d
			..s OpStopARate=$fn(100*(OPStopANum/locallnum),"",2)_"%"
			..i locdnum'=0 d
			...s dper=$fn(100*(locdnum/locallnum),"",2)_"%"
			..i loccnum'=0 d
			...s cper=$fn(100*(loccnum/locallnum),"",2)_"%"
			.d Output2

     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

Output2
	 set Data=$lb(locId,apploc,locallnum,loccnum,locdnum,dper,cper,OPStopANum,OpStopARate)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod OperPercentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperPercentExecute ]
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

ClassMethod OperPercentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperPercentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 20170809+dyl+手术类型:  停台率  MD28.02.02
/// 入参：stdate：开始日期,enddate:结束日期
/// 返回结果：CtlocId：申请科室Id,locDesc：申请科室描述
/// ,AllOperNum:科室内手术总数,StopS：拒绝手术总数+比例,StopA：撤销手术总数+比例
/// ,StartEarly:首台过9:00,FinishLate:手术完成时间超过17:00，LocAllNum科室内总手术数(除去申请状态)
/// ,OverNum:不管是不是台次1，只要是最早，且大于9点的，统计,OverPer：超时+比例
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD36Docoperation","OperActInfo","2018-03-01","2018-03-14","2")
Query OperActInfo(stdate, enddate, type, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "CtlocId,locDesc,StopS,StopA,OpNum,StartEarly,FinishLate,LocAllNum,OverNum,OverPer")
{
}

ClassMethod OperActInfoExecute(ByRef qHandle As %Binary, stdate, enddate, type, hospitalId As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k LocAllOpList,LocDeclineOpList,LocCancelOpList,LocFinishOpList,RoomLastList,RoomFirstList
	f date=sdate:1:edate
    {
	s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)
		.i jz="E" s jzstat="1"
		.e  s jzstat=2
		 
		.q:(type'="")&&(type'=jzstat)
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
		.i appLocId="" s appLocId=$p($g(^PAADM(adm)),"^",4)
		
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i opaStatus="A" s status="申请"
		.i (opaStatus="D") s status="拒绝",LocDeclineOpList(appLocId,opaId)=""
		.i opaStatus="R" s status="安排"
		.i opaStatus="N" s status="非预约"
		.i opaStatus="I" s status="术中"
		.i opaStatus="P" s status="恢复室"
		.i opaStatus="L" s status="术毕",LocFinishOpList(appLocId,opaId)=""
		.i opaStatus="F" s status="完成",LocFinishOpList(appLocId,opaId)=""
		.i (opaStatus="C") s status="撤销",LocCancelOpList(appLocId,opaId)=""
		.q:opaStatus="A"	;申请没有安排不在统计之内
		.s LocAllOpList(appLocId,opaId)=""
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;超时开台判断使用入室时间
		.s inRoomTime=$p(^OR(+anaId,"ANA",chl),"^",40) ;入室时间
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.q:oproomdr="" 
		.s lastroomtime=$g(RoomNewList(appLocId,opstdate,oproomdr))
		.i (lastroomtime>opsttime) s lastroomtime=opsttime
		.e  s lastroomtime=opsttime
		.i oproomdr'="" s RoomNewList(appLocId,opstdate,oproomdr)=lastroomtime
		.i (opordno=1)&&(inRoomTime>32400) s RoomFirstList(appLocId,opstdate,oproomdr)=""
		.i (opendtime>61200) s RoomLastList(appLocId,opaId)=""
    
    }	
    	
    	s locId="" f  s locId=$o(LocAllOpList(locId)) q:locId=""  d
    		.s apploc=$p(^CTLOC(locId),"^",2)
    		.s hospID=$p($g(^CTLOC(locId)),"^",22)
		  	.q:(hospitalId'="")&&(hospID'=hospitalId)
			.s locallnum=0,locdnum=0,loccnum=0,dper="",cper="",flocnum=0,fper="",lper=""
	    	.s postnum=0,pper=""
	    	.s newday=""  f  s newday=$o(RoomNewList(locId,newday)) q:newday=""  d
	    		..s nroomdr=""  f  s nroomdr=$o(RoomNewList(locId,newday,nroomdr)) q:nroomdr=""  d
	    			...s posttime=$g(RoomNewList(locId,newday,nroomdr))
	    			...i posttime>32400 s postnum=postnum+1
	    	.s firstnum=0,lastnum=0,locd="",locc="",locf="",lloc=""
	    	.s day1=""  f  s day1=$o(RoomFirstList(locId,day1)) q:day1=""  d
	    		..s room=""  f  s room=$o(RoomFirstList(locId,day1,room)) q:room=""  d
	    			...s firstnum=firstnum+1
	    	.s day2=""  f  s day2=$o(RoomLastList(locId,day2)) q:day2=""  d
    				..s lastnum=lastnum+1
			.s topaId="" f  s topaId=$o(LocAllOpList(locId,topaId)) q:topaId=""  d
				..s locallnum=locallnum+1
			.s fopaId="" f  s fopaId=$o(LocFinishOpList(locId,fopaId)) q:fopaId=""  d
				..s flocnum=flocnum+1
			.s dopaId="" f  s dopaId=$o(LocDeclineOpList(locId,dopaId)) q:dopaId=""  d
				..s locdnum=locdnum+1
			.s copaId="" f  s copaId=$o(LocCancelOpList(locId,copaId)) q:copaId=""  d
				..s loccnum=loccnum+1
			.i locallnum'=0 d
				..i locdnum'=0 d
					...s dper=$fn(100*(locdnum/locallnum),"",2)_"%"
				..i loccnum'=0 d
					...s cper=$fn(100*(loccnum/locallnum),"",2)_"%"
				..i firstnum'=0 d
					...s fper=$fn(100*(firstnum/locallnum),"",2)_"%"
				..i lastnum'=0 d
					...s lper=$fn(100*(lastnum/locallnum),"",2)_"%"
				..i postnum'=0 d
					...s pper=$fn(100*(postnum/locallnum),"",2)_"%"
			.i dper'="" s locd=locdnum_"("_dper_")"
			.e  s locd=locdnum
			.i cper'="" s locc=loccnum_"("_cper_")"
			.e  s locc=loccnum
			.i fper'="" s locf=firstnum_"("_fper_")"
			.e  s locf=firstnum
			.i lper'="" s lloc=lastnum_"("_lper_")"
			.e  s lloc=lastnum
			.i pper'="" s ploc=postnum_"("_pper_")"
			.e  s ploc=postnum
			.d OutputAI

     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

OutputAI
	 set Data=$lb(locId,apploc,locd,locc,flocnum,locf,lloc,locallnum,postnum,ploc)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod OperActInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperActInfoExecute ]
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

ClassMethod OperActInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperActInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
