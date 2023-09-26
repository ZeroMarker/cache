/// Creator:wangcs
/// CreateDate:2012-02-26
/// Description:三级医院院感评审指标
Class DHCMed.NINFService.Sta.InfStatTarget Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 描述：获取一段时间内出院的院感病人数据
/// 自动任务批量处理数据：w ##class(DHCMed.NINFService.Sta.InfStatTarget).BatchAnalysisData(+$h-1,+$h-1,"0")
/// 重复处理数据批处理任务：w ##class(DHCMed.NINFService.Sta.InfStatTarget).BatchAnalysisData("2013-03-01","2013-04-23","1")
/// 补充处理数据批处理任务：w ##class(DHCMed.NINFService.Sta.InfStatTarget).BatchAnalysisData("2011-01-01","2011-02-01","2")
ClassMethod BatchAnalysisData(aDateFrom As %String, aDateTo As %String, aType As %String)
{
	New (aDateFrom,aDateTo,aType)
	Set return=-1
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(+aType'=0)&&(+aType'=1)&&(+aType'=2) return
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set BatDate=$o(^DHCMedInfStatBase("Inf-Batch","BatDate",""),-1)
	If BatDate="" {
		//设置初始批处理开始日期（首次执行此方法的开始时间）
		Set ^DHCMedInfStatBase("Inf-Batch","BatDate",$zd(aDateFrom,3))=""
	}
	
	Set BatDateFrom=$o(^DHCMedInfStatBase("Inf-Batch","BatDate",""))
	Set BatDateFrom=$zdh(BatDateFrom,3)
	Set BatDateTo=$o(^DHCMedInfStatBase("Inf-Batch","BatDate",""),-1)
	Set BatDateTo=$zdh(BatDateTo,3)
	If +aType=0 {
		//自动任务处理统计数据
		Set:aDateFrom>BatDateTo aDateFrom=BatDateTo
		Set:aDateTo<aDateFrom aDateTo=aDateFrom
	}ElseIf +aType=1 {
		//强制重复处理统计数据
		//Set:aDateFrom<BatDateFrom aDateFrom=BatDateFrom
		//Set:aDateTo>BatDateTo aDateTo=BatDateTo
	}Else {
		//补充处理统计数据
		Set:aDateFrom<BatDateFrom aDateFrom=BatDateFrom
		Set:aDateTo>BatDateTo aDateTo=BatDateTo
	}
	
	Set Count=0
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=aDateFrom:1:aDateTo {
		//自动任务处理统计数据：记录已处理日期
		Set:+aType=0 ^DHCMedInfStatBase("Inf-Batch","BatDate",$zd(DischDate,3))=""
		Set:+aType=2 ^DHCMedInfStatBase("Inf-Batch","BatDate",$zd(DischDate,3))=""
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //退院状态过滤
			Continue:$p(AdmInfo,"^",6)=""    //入院日期为空过滤
			
			//自动任务处理统计数据：不重复处理数据筛查、记录处理数据记录数
			If +aType=0 {
				Set StatBaseID=$O(^DHCMed.NINF.Srv.InfStatBaseI("IndexOfPaadm"," "_Paadm,0))
				Continue:StatBaseID'=""  //不重复处理数据
				Set num=$i(^DHCMedInfStatBase("Inf-Batch","BatDate",$zd(DischDate,3),"Count"))  //记录处理数据记录数
			}
			If +aType=2 {
				Set StatBaseID=$O(^DHCMed.NINF.Srv.InfStatBaseI("IndexOfPaadm"," "_Paadm,0))
				Set:StatBaseID="" num=$i(^DHCMedInfStatBase("Inf-Batch","BatDate",$zd(DischDate,3),"Count"))  //记录处理数据记录数
			}
			Set flg=..GetPaadmOfData(Paadm)  //按就诊处理统计数据
			Set:flg>0 Count=Count+1
			w "Paadm="_Paadm_",flg="_flg,!
		}
	}
	
	//错误就诊记录，重复导入
	//程序异常结果存在: ^DHCMedInfStatBase("Inf-Batch","PaadmErr",Paadm)=ErrorInfo
	Set Paadm=0
	For {
		Set Paadm=$o(^DHCMedInfStatBase("Inf-Batch","PaadmErr",Paadm))
		Quit:Paadm=""
		Set flg=..GetPaadmOfData(Paadm)  //按就诊处理统计数据
		Set:flg>0 Count=Count+1
		w "Paadm="_Paadm_",flg="_flg,!
	}
	Set return=Count
	
	//处理月数据
	Set Now=$zd($h,3),IsRunNian="N" ;是否闰年
	Set Month=+$P(Now,"-",2)
	Set Day=+$P(Now,"-",3)
	Set Year=$P(Now,"-",1)
	Set MaxDays=..GetMaxDays(Year,Month)
      If ((Day=MaxDays)||(+aType=0)||(+aType=2)){
	    Set StaDate=$zdh(Year_"-"_Month_"-"_"1",3)
          Set EndDate=$zdh(Year_"-"_Month_"-"_MaxDays,3)
          Set Rtn=..GetMonthOfData(StaDate,EndDate)
      }ElseIf(+aType=1) {
	    Set aDateToOfMonth=+$p($zd(aDateTo,3),"-",2),
	          aDateToOfYear=+$p($zd(aDateTo,3),"-",1),
	          aDateFromOfYear=+$p($zd(aDateFrom,3),"-",1),
	          aDateFromOfMonth=+$p($zd(aDateFrom,3),"-",2)
	     For CurrYear=aDateFromOfYear:1:aDateToOfYear {
		     Set:aDateToOfYear>CurrYear EndMonth=12
		     Set:aDateToOfYear=CurrYear EndMonth=aDateToOfMonth
		     Set:aDateFromOfYear=CurrYear StaMonth=aDateFromOfMonth
		     Set:aDateFromOfYear<CurrYear StaMonth=1
		     For CurrMonth=StaMonth:1:EndMonth {
			    Set MaxDays=..GetMaxDays(CurrYear,CurrMonth)
			    Set StaDate=$zdh(CurrYear_"-"_CurrMonth_"-1",3)
			    Set EndDate=$zdh(CurrYear_"-"_CurrMonth_"-"_MaxDays,3)
			    Set Rtn=..GetMonthOfData(StaDate,EndDate)
		    }
	    }
      }
	Quit return
}

/// 描述：获得某个月的最大天数
ClassMethod GetMaxDays(Year As %String, Month As %String)
{
	New (Year,Month)
	Set MaxDays=0,IsRunNian="N"
	Set:((Year/4=0)&&(Year/100'=0))||((Year/100=0)&&(Year/400'=0)) IsRunNian="Y"
      Set:(+Month=1)||(+Month=3)||(+Month=5)||(+Month=7)||(+Month=8)||(+Month=10)||(+Month=12) MaxDays=31  ;1、3、5、7、8、10、12月 31天
      Set:(+Month=4)||(+Month=6)||(+Month=9)||(+Month=11) MaxDays=30  ;4、6、9、11月 30天
      Set:(+Month=2)&&(IsRunNian="Y") MaxDays=29                               ;2月 闰年29天
      Set:(+Month=2)&&(IsRunNian="N") MaxDays=28                               ;2月 普通28天
      Quit MaxDays
}

/// 描述：处理月数据
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetMonthOfData(62457,62913,1)
ClassMethod GetMonthOfData(StaDate As %String, EndDate As %String)
{
	New (StaDate,EndDate)
	Set DischDate=StaDate-1,
	      (InfOfCount,DischOfCount,OperInfOfCount,OperDischOfCount,OperPulmInfOfCount,NewBornInfOfCount,NewBornDischOfCount,SelTimeOperDischOfCount,
             OperPosiInfofCount,SelTimeOperOfCount,SelTimeOperPulmInfOfCount,Lev0OperInfOfCount,Lev0OperDischOfCount,Lev1OperInfOfCount,
             Lev1OperInfOfCount,Lev1OperDischOfCount,Lev2OperInfOfCount,Lev2OperDischOfCount,Lev3OperInfOfCount,Lev3OperDischOfCount,
             VenousBloodInfOfCount,VenousCatheterOfCount,RespPlumInfOfCount,RespOfCount,CathUrinaryTractInfoOfCount,CathOfCount,
             BloodInfOfCount,HemodialysisOfCount)=0
	For DischDate=StaDate:1:EndDate {
		Set BaseID=0
		For {
			Set BaseID=	$O(^DHCMed.NINF.Srv.InfStatBaseI("IndexOfDischDate",DischDate,BaseID))
			Quit:BaseID=""
			
			Set ObjBase=##Class(DHCMed.NINF.Srv.InfStatBaseInfo).%OpenId(BaseID)
			If ($IsObject(ObjBase)){
				Set DischOfCount=$i(DischOfCount)
				Set ReportTimes=ObjBase.ReportTimes
				Set:+ReportTimes>0 InfOfCount=$i(InfOfCount)
				Set:+ObjBase.OperRelaInfTimes>0 OperInfOfCount=OperInfOfCount+ObjBase.OperRelaInfTimes             ;手术相关感染次数
				Set:+ObjBase.OperTimes>0 OperDischOfCount=OperDischOfCount+ObjBase.OperTimes                          ;手术次数
				Set:+ObjBase.OperBellInfTimes>0 OperPulmInfOfCount=OperPulmInfOfCount+ObjBase.OperBellInfTimes ;手术肺部感染次数
				Set:(ObjBase.IsNewBorn="Y")&&(+ReportTimes>0) NewBornInfOfCount=$i(NewBornInfOfCount)          ;新生儿感染次数
				Set:(ObjBase.IsNewBorn="Y") NewBornDischOfCount=$i(NewBornDischOfCount)          ;新生儿次数
				Set:+ObjBase.OperPosiInfTimes>0 OperPosiInfofCount=OperPosiInfofCount+ObjBase.OperPosiInfTimes    ;手术部位感染例数
				Set:+ObjBase.SeleOperInfTimes>0 SelTimeOperOfCount=SelTimeOperOfCount+ObjBase.SeleOperInfTimes ;择期手术感染次数
				Set:+ObjBase.SeleOperTimes>0 SelTimeOperDischOfCount=SelTimeOperDischOfCount+ObjBase.SeleOperTimes ;择期手术人次
				Set:+ObjBase.SeleOperBellInfTimes>0 SelTimeOperPulmInfOfCount=SelTimeOperPulmInfOfCount+ObjBase.SeleOperBellInfTimes ;择期手术肺部感染人次
				Set:+ObjBase.Rank0OperInfTimes>0 Lev0OperInfOfCount=Lev0OperInfOfCount+ObjBase.Rank0OperInfTimes ;0级手术感染人次
				Set:+ObjBase.Rank0OperTimes>0 Lev0OperDischOfCount=Lev0OperDischOfCount+ObjBase.Rank0OperTimes ;0级手术人次
				Set:+ObjBase.Rank1OperInfTimes>0 Lev1OperInfOfCount=Lev1OperInfOfCount+ObjBase.Rank1OperInfTimes ;1级手术感染人次
				Set:+ObjBase.Rank1OperTimes>0 Lev1OperDischOfCount=Lev1OperDischOfCount+ObjBase.Rank1OperTimes ;1级手术人次
				Set:+ObjBase.Rank2OperInfTimes>0 Lev2OperInfOfCount=Lev2OperInfOfCount+ObjBase.Rank2OperInfTimes ;2级手术感染人次
				Set:+ObjBase.Rank2OperTimes>0 Lev2OperDischOfCount=Lev2OperDischOfCount+ObjBase.Rank2OperTimes ;2级手术人次
				Set:+ObjBase.Rank3OperInfTimes>0 Lev3OperInfOfCount=Lev3OperInfOfCount+ObjBase.Rank3OperInfTimes ;3级手术感染人次
				Set:+ObjBase.Rank3OperTimes>0 Lev3OperDischOfCount=Lev3OperDischOfCount+ObjBase.Rank3OperTimes ;3级手术人次
				Set:+ObjBase.VenousBloodInfTimes>0 VenousBloodInfOfCount=VenousBloodInfOfCount+ObjBase.VenousBloodInfTimes ;中心静脉相关血源性感染例数
				Set:+ObjBase.VenousBloodDays>0 VenousCatheterOfCount=VenousCatheterOfCount+ObjBase.VenousBloodDays ;中心静脉置管病人日数
				Set:+ObjBase.RespPlumInfTimes>0 RespPlumInfOfCount=RespPlumInfOfCount+ObjBase.RespPlumInfTimes ;呼吸机相关肺部感染人数
				Set:+ObjBase.RespPlumDays>0 RespOfCount=RespOfCount+ObjBase.RespPlumDays  ;呼吸机使用天数
				Set:+ObjBase.CathUrinaryTractInfTimes>0 CathUrinaryTractInfoOfCount=CathUrinaryTractInfoOfCount+ObjBase.CathUrinaryTractInfTimes ;留置导尿管相关泌尿道感染例数
				Set:+ObjBase.CathOfDays>0 CathOfCount=CathOfCount+ObjBase.CathOfDays          ;留置导尿管病人日数
				Set:+ObjBase.BloodInfTimes>0 BloodInfOfCount=BloodInfOfCount+ObjBase.BloodInfTimes ;血液感染例数
				Set:+ObjBase.HemodialysisTimes>0 HemodialysisOfCount=HemodialysisOfCount+ObjBase.HemodialysisTimes ;血液透析例数
			}
		}
	}
	Set Count=##Class(DHCMed.NINF.Srv.InfStatTarget).DeleteTargetByStaData(StaDate)
	Set ObjTarget=##Class(DHCMed.NINF.Srv.InfStatTarget).%New()
	Set ObjTarget.DischStaDate=StaDate,
	     ObjTarget.DischEndDate=EndDate,
	     ObjTarget.Month=$P($zd(StaDate,3),"-",1)_"-"_$P($zd(StaDate,3),"-",2),
	     ObjTarget.InfOfCount=InfOfCount,
	     ObjTarget.DischOfCount=DischOfCount,
	     ObjTarget.OperInfOfCount=OperInfOfCount,
	     ObjTarget.OperDischOfCount=OperDischOfCount,
	     ObjTarget.OperPulmInfOfCount=OperPulmInfOfCount,
	     ObjTarget.NewBornInfOfCount=NewBornInfOfCount,
	     ObjTarget.NewBornDischOfCount=NewBornDischOfCount,
	     ObjTarget.OperPosiInfofCount=OperPosiInfofCount,
	     ObjTarget.SelTimeOperOfCount=SelTimeOperOfCount,
	     ObjTarget.SelTimeOperDischOfCount=SelTimeOperDischOfCount,
	     ObjTarget.SelTimeOperPulmInfOfCount=SelTimeOperPulmInfOfCount,
	     ObjTarget.Lev0OperInfOfCount=Lev0OperInfOfCount,
	     ObjTarget.Lev0OperDischOfCount=Lev0OperDischOfCount,
	     ObjTarget.Lev1OperInfOfCount=Lev1OperInfOfCount,
	     ObjTarget.Lev1OperDischOfCount=Lev1OperDischOfCount,
	     ObjTarget.Lev2OperInfOfCount=Lev2OperInfOfCount,
	     ObjTarget.Lev2OperDischOfCount=Lev2OperDischOfCount,
	     ObjTarget.Lev3OperInfOfCount=Lev3OperInfOfCount,
	     ObjTarget.Lev3OperDischOfCount=Lev3OperDischOfCount,
	     ObjTarget.VenousBloodInfOfCount=VenousBloodInfOfCount,
	     ObjTarget.VenousCatheterOfDays=VenousCatheterOfCount,
	     ObjTarget.RespPlumInfOfCount=RespPlumInfOfCount,
	     ObjTarget.RespOfDays=RespOfCount,
	     ObjTarget.CathUrinaryTractInfoOfCount=CathUrinaryTractInfoOfCount,
	     ObjTarget.CathOfDays=CathOfCount,
	     ObjTarget.BloodInfOfCount=BloodInfOfCount,
	     ObjTarget.HemodialysisOfCount=HemodialysisOfCount
	     
	      //保存数据
	    Set sc=ObjTarget.%Save()
	    If $System.Status.IsError(sc) {  //检查Save是否成功
   		   Do $System.OBJ.DisplayError(sc)
   		   Set Rtn=-1
	    } Else {
		   Set Rtn=ObjTarget.%Id()
	    }
	    Do ObjTarget.%Close()
	    Quit Rtn
}

/// 描述：提取病人的感染数据存储到感染统计基本信息表(DHCMed.NINF.Srv.InfStatBaseInfo)
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetPaadmOfData(511)
ClassMethod GetPaadmOfData(Paadm As %String)
{
	New (Paadm)
	Set Rtn=-100
	
	;Set $ZT="GetPaadmOfDataErr"
	//已存在记录不重复处理
	Set BaseID=$O(^DHCMed.NINF.Srv.InfStatBaseI("IndexOfPaadm"," "_Paadm,0))
	//Quit:(Type=2)&&(BaseID'="") Rtn
	If (BaseID'=""){
		Set InfStatBaseObj=##Class(DHCMed.NINF.Srv.InfStatBaseInfo).%OpenId(BaseID)
	}Else{
	      Set InfStatBaseObj=##Class(DHCMed.NINF.Srv.InfStatBaseInfo).%New()
	}
	Set PaadmObj=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	If ($IsObject(PaadmObj)){
		//处理病人手术数据
		Set Rtn=##Class(DHCMed.NINFService.Sta.InfStatOperInfo).ProcessOperData(Paadm)
		//处理病人ICU数据
		Set Rtn=##Class(DHCMed.NINFService.Sta.InfStatICUInf).ProcessICUData(Paadm)
	       Set InfStatBaseObj.Paadm=Paadm
             Set AdmDate=PaadmObj.AdmitDate
             Set:AdmDate["-" AdmDate=+$zdh(AdmDate,3)
	       Set InfStatBaseObj.AdmDate=AdmDate
	       Set InfStatBaseObj.AdmLoc=PaadmObj.Department
	       Set DischDate=PaadmObj.DisDate
	       Set:DischDate["-" DischDate=+$zdh(DischDate,3)
	       Set InfStatBaseObj.DischDate=DischDate
	       Set InfStatBaseObj.DischLoc=PaadmObj.Department
	    
	       Set InfStatBaseObj.ReportTimes=..GetPatInfCount(Paadm)    ;院感次数
	      //是否新生儿
	      Set InfStatBaseObj.IsNewBorn=..IsNewBorn(Paadm)
	      //获取病人手术感染数据     --手术相关感染次数、肺部感染次数、手术部位感染次数、择期手术感染次数、择期手术肺部感染次数
	      Set OperInfListBuild=..GetRepOfOperInfo(Paadm),
	          (OperRelateTimes,BellInfTimes,OperPosiInfTimes,SeleOperInfTimes,SeleOperBellInfTimes)=0
	   
	    Set OperRelateTimes=$list(OperInfListBuild,1)                           ;手术相关感染次数
	    Set BellInfTimes=$list(OperInfListBuild,2)                                  ;肺部感染次数
	    Set OperPosiInfTimes=$list(OperInfListBuild,3)                          ;手术部位感染次数
	    Set SeleOperInfTimes=$list(OperInfListBuild,4)                          ;择期手术感染次数
	    Set SeleOperBellInfTimes=$list(OperInfListBuild,5)                    ;择期手术肺部感染次数
	    ;Set OperRelateTimes=..GetPatRepCount(Paadm,"")
	     
	     Set InfStatBaseObj.OperRelaInfTimes=OperRelateTimes
	     Set InfStatBaseObj.OperPosiInfTimes=OperPosiInfTimes
	     Set InfStatBaseObj.OperBellInfTimes=BellInfTimes
	     Set InfStatBaseObj.SeleOperInfTimes=SeleOperInfTimes
	     Set InfStatBaseObj.SeleOperBellInfTimes=SeleOperBellInfTimes
	    //获取手术数据   --手术总数、择期手术次数、急诊手术次数
	    Set OperListBuild=..GetOperInfo(Paadm),
	         (OperCount,SeleOperTimes,EmeOperTimes)=0
	    Set OperCount=$list(OperListBuild,1)
	    Set SeleOperTimes=$list(OperListBuild,2)
	    Set EmeOperTimes=$list(OperListBuild,3)
	    
	    Set InfStatBaseObj.OperTimes=OperCount
	    Set InfStatBaseObj.SeleOperTimes=SeleOperTimes
	    Set InfStatBaseObj.EmerOperTimes=EmeOperTimes
	    /*
	      获取手术分级数据 
	      --0级手术感染次数、0级手术次数、1级手术感染次数、1级手术次数、2级手术感染次数、2级手术次数、
	      3级手术感染次数、3级手术次数
	    */
	   
	    
	    Set OperRankListBuild=..GetOperRankOfPatient(Paadm),
	         (Rank0OperTimes,Rank0OperInfTimes,Rank1OperTimes,Rank1OperInfTimes,Rank2OperTimes,
	          Rank2OperInfTimes,Rank3OperTimes,Rank3OperInfTimes)=0
	    Set Rank0OperTimes=$list(OperRankListBuild,1),
	        Rank0OperInfTimes=$list(OperRankListBuild,2),
	        Rank1OperTimes=$list(OperRankListBuild,3),
	        Rank1OperInfTimes=$list(OperRankListBuild,4),
	        Rank2OperTimes=$list(OperRankListBuild,5),
	        Rank2OperInfTimes=$list(OperRankListBuild,6),
	        Rank3OperTimes=$list(OperRankListBuild,7),
	        Rank3OperInfTimes=$list(OperRankListBuild,8)
	         
	    Set InfStatBaseObj.Rank0OperInfTimes=Rank0OperInfTimes
	    Set InfStatBaseObj.Rank0OperTimes=Rank0OperTimes
	    Set InfStatBaseObj.Rank1OperInfTimes=Rank1OperInfTimes
	    Set InfStatBaseObj.Rank1OperTimes=Rank1OperTimes
	    Set InfStatBaseObj.Rank2OperInfTimes=Rank2OperInfTimes
	    Set InfStatBaseObj.Rank2OperTimes=Rank2OperTimes
	    Set InfStatBaseObj.Rank3OperInfTimes=Rank3OperInfTimes
	    Set InfStatBaseObj.Rank3OperTimes=Rank3OperTimes
	    
	    
	    //中心静脉数据
	    Set VenousBloodInfTimes=..GetVenousBloodInfTimes(Paadm) ;中心静脉相关血源性感染次数
	    Set VenousBloodDays=..GetVenousBloodDays(Paadm)            ;中心静脉置管使用日数
	    Set InfStatBaseObj.VenousBloodInfTimes=VenousBloodInfTimes
	    Set InfStatBaseObj.VenousBloodDays=VenousBloodDays
	    
	    //呼吸机相关数据
	    Set RespPlumInfTimes=..GetRespPlumInfTimes(Paadm)
	    Set RespPlumDays=..GetRespPlumDays(Paadm)
	    Set InfStatBaseObj.RespPlumInfTimes=RespPlumInfTimes
	    Set InfStatBaseObj.RespPlumDays=RespPlumDays
	    
	    //留置导尿管
	    Set CathUrinaryTractInfTimes=..GetCathUrinaryTractInfTimes(Paadm)
	    Set CathOfDays=..GetCathOfDays(Paadm)
	    Set InfStatBaseObj.CathUrinaryTractInfTimes=CathUrinaryTractInfTimes
	    Set InfStatBaseObj.CathOfDays=CathOfDays
	    
	    //血液透析
	    Set BloodInfTimes=..GetBloodInfTimes(Paadm)
	    Set HemodialysisTimes=..GetHemodialysisTimes(Paadm)
	    Set InfStatBaseObj.BloodInfTimes=BloodInfTimes
	    Set InfStatBaseObj.HemodialysisTimes=HemodialysisTimes
	  
	    //保存数据
	    Set sc=InfStatBaseObj.%Save()
	    If $System.Status.IsError(sc) {  //检查Save是否成功
   		   Do $System.OBJ.DisplayError(sc)
   		   Set Rtn=-1
	    } Else {
		   Set Rtn=InfStatBaseObj.%Id()
	    }
	    Do InfStatBaseObj.%Close()
    }
    Quit Rtn
    /*
GetPaadmOfDataErr
      Set $ZT=""
	Set ^DHCMedInfStatBase("Inf-Batch","PaadmErr",+Paadm)=$ZERROR
	Set Rtn=-1
	Quit Rtn
	*/
}

/// 描述：得到病人本次就诊期间感染次数，根据上报次数判断
ClassMethod GetPatInfCount(Paadm As %String)
{
	New (Paadm)
	;^DHCMed.NINFi("InfRep",0,"IndexPaadm",532,45)
	Set (ReportID,RepCount)=0
	For {
		Set ReportID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,ReportID))	
		Quit:ReportID=""
		
		Set ObjRep=##Class(DHCMed.NINF.Rep.InfReport).%OpenId(ReportID)
		If ($IsObject(ObjRep)){
			If ($IsObject(ObjRep.ReportStatus)){
			    Set:(ObjRep.ReportStatus.Code'="5")&&(ObjRep.ReportStatus.Code'="0" ) RepCount=$i(RepCount)  ;去掉 删除 退回的报告
			}
		}
	}
	Quit RepCount
}

/// 描述：是否某个监测项目的上报病人
/// 返回值：病人上报次数
ClassMethod GetPatRepCount(Paadm As %String, ProjectCode As %String)
{
	New (Paadm,ProjectCode)
	Set ReportID=0,NPaadm=" "_Paadm,PatRepCount=0
	For {
		Set ReportID=$O(^DHCMed.CR.ReportI("EpisodeID",NPaadm,ReportID))
		Quit:ReportID=""
		
		Set ObjProject=##Class(DHCMed.CR.Project).%OpenId(ReportID)
		Continue:'$IsObject(ObjProject)
		
		Set ProCode=ObjProject.Code
		Continue:ProCode'=ProjectCode
		Set:ProCode=ProjectCode PatRepCount=$i(PatRepCount)
	}
	Quit PatRepCount
}

/// 描述：是否是新生儿
/// 返回:   N不是  Y是
ClassMethod IsNewBorn(Paadm As %String)
{
	New (Paadm)
	Set Rtn="N"
	Set Papmi=$P(^PAADM(Paadm),"^",1)
	//Set DischDate=+$P(^PAADM(Paadm),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Quit:Papmi="" Rtn
	Set DOB=+$p(^PAPER(Papmi,"ALL"),"^",6)
	Set:AdmitDate-DOB<=28 Rtn="Y"
	Quit Rtn
}

/// 描述：从院感报告中获取手术相关感染次数、肺部感染次数、手术部位感染次数、择期手术感染次数、择期手术肺部感染次数
///           调用取手术相关信息的Query
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetRepOfOperInfo(511)
ClassMethod GetRepOfOperInfo(Paadm As %String)
{
	New (Paadm)
	Set (ReportID,OpeRelaInfTimes,BellInfTimes,OperPosiInfTimes,SeleOperInfTimes,SeleOperBellInfTimes)=0  ;依次手术相关感染次数、肺部感染次数、手术部位感染次数、择期手术感染次数、择期手术肺部感染次数
	For {
		Set ReportID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,ReportID))
		Quit:ReportID=""
		
		Set ObjRep=##Class(DHCMed.NINF.Rep.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(ObjRep)
		Continue:ObjRep.ReportType.Code'="COMP"
		Continue:(ObjRep.ReportStatus.Code="5")||(ObjRep.ReportStatus.Code="0") //去掉 删除 退回的报告
		Set SubID=0,IsBellInf="N",InfPosi=""
		For {
			Set SubID=$O(^DHCMed.NINF("InfRep",ReportID,"InfPos",SubID))
			Quit:(SubID="")||(IsBellInf="Y")
			
			Set PosSubID=ReportID_"||"_SubID
			Set ObjPos=##Class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(PosSubID)
			If ($IsObject(ObjPos)){
			     Set PosDic=ObjPos.InfPos
			     If ($IsObject(PosDic)){
					Set InfPosi=PosDic.IPDesc
					Set:InfPosi="下呼吸道" IsBellInf="Y"
			     }
			}
		}
		//从院感报告手术相关信息中获取上报手术信息
		Set ResultSet=##Class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec"),IsOperPosiPat="N",IsSeleOper="N"
		Do ResultSet.Execute(ReportID,"")	
		While(ResultSet.Next()){
			Set CuteInfFlagDesc=ResultSet.Data("OperInfTypeDesc")
			Set:(CuteInfFlagDesc["表浅切口")||(CuteInfFlagDesc["深部切口")||(CuteInfFlagDesc["器官/腔隙") IsOperPosiPat="Y" ;手术部位感染
			Set OperType=ResultSet.Data("OperationTypeDesc")
			Set:OperType["择期" SeleOperInfTimes=$i(SeleOperInfTimes)                                           ;择期手术感染次数
			Set:(OperType["择期")&&(IsBellInf="Y" ) SeleOperBellInfTimes=$i(SeleOperBellInfTimes)  ;择期肺部感染次数
			Set OperDate=ResultSet.Data("OperStartDate")                                                                ;院感报告-手术相关-手术开始日期
			Set OpeRelaInfTimes=OpeRelaInfTimes+1
			;b:OpeRelaInfTimes>0
			;Set:OperDate'="" OpeRelaInfTimes=$i(OpeRelaInfTimes)                                                  ;手术相关感染
		}
		Do ResultSet.Close()
		Set:IsBellInf="Y" BellInfTimes=$i(BellInfTimes)
		Set:IsOperPosiPat="Y" OperPosiInfTimes=$i(OperPosiInfTimes)
	}
	Set Rtn=$lb(OpeRelaInfTimes,BellInfTimes,OperPosiInfTimes,SeleOperInfTimes,SeleOperBellInfTimes)
	Quit Rtn
}

/// 描述：获取手术信息
/// 择期手术次数、急诊手术次数、手术次数
ClassMethod GetOperInfo(Paadm As %String)
{
	New (Paadm)
	Set (OperCount,SeleOperTimes,EmeOperTimes)=0,NPaadm=" "_Paadm
	Set OperID=0
	For {
		Set OperID=$O(^DHCMed.NINF.Srv.InfStatOperI("IndexOfPaadm",NPaadm,OperID))	
		Quit:OperID=""
		
		Set OprObj=##Class(DHCMed.NINF.Srv.InfStatOperInfo).%OpenId(OperID)
		Continue:'$IsObject(OprObj)
		Set OperCount=$i(OperCount)
		Set OprType=OprObj.OperationType
		If (OprType["急诊")
		{
		   Set EmeOperTimes=$i(EmeOperTimes)
		}Else{
		   Set SeleOperTimes=$i(SeleOperTimes)
		}
	}
	Set Rtn=$lb(OperCount,SeleOperTimes,EmeOperTimes)
	Quit Rtn
}

/// 描述：获取病人手术分级相关信息
ClassMethod GetOperRankOfPatient(Paadm As %String)
{
	New (Paadm)
	Set (OperID,Rank0OperInfTimes,Rank0OperTimes,Rank1OperInfTimes,Rank1OperTimes,
	       Rank2OperInfTimes,Rank2OperTimes,Rank3OperInfTimes,Rank3OperTimes)=0,
	       NPaadm=" "_Paadm
	For {
		Set OperID=$O(^DHCMed.NINF.Srv.InfStatOperI("IndexOfPaadm",NPaadm,OperID))
		Quit:OperID=""
		
		Set ObjOper=##Class(DHCMed.NINF.Srv.InfStatOperInfo).%OpenId(OperID)
		Continue:'$IsObject(ObjOper)
		Set OperDate=ObjOper.OperDate
		Set OperDate=$zd(OperDate,3)
		
		Set OperRank=ObjOper.OperRank ;手术分级=手术持续时间(打分)+ASA(打分)+切口等级(打分)
		Set:OperRank=0 Rank0OperTimes=$i(Rank0OperTimes)
		Set:OperRank=1 Rank1OperTimes=$i(Rank1OperTimes)
		Set:OperRank=2 Rank2OperTimes=$i(Rank2OperTimes)
		Set:OperRank=3 Rank3OperTimes=$i(Rank3OperTimes)
		//从院感报告里面提取手术日期和SSI手术日期比对，确定是否本次手术感染
		Set IsOprInf=ObjOper.IsInf
		If (IsOprInf="Y"){
			 Set:OperRank=0 Rank0OperInfTimes=$i(Rank0OperTimes)
		       Set:OperRank=1 Rank1OperInfTimes=$i(Rank1OperTimes)
		       Set:OperRank=2 Rank2OperInfTimes=$i(Rank2OperTimes)
		       Set:OperRank=3 Rank3OperInfTimes=$i(Rank3OperTimes)	
		} 
	}
	Set Rtn=$lb(Rank0OperTimes,Rank0OperInfTimes,Rank1OperTimes,Rank1OperInfTimes,Rank2OperTimes,Rank2OperInfTimes,Rank3OperTimes,Rank3OperInfTimes)
	Quit Rtn
}

/// 描述：中心静脉置管使用日数
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetVenousBloodDays(511)
ClassMethod GetVenousBloodDays(Paadm As %String)
{
	New (Paadm)
	Set (ICUID,Days)=0,NPaadm=" "_Paadm,ObjICU="",ICUType="VC"
	For {
		Set ICUID=$O(^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm",NPaadm,ICUID))	
		Quit:ICUID=""
		Set ObjICU=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%OpenId(ICUID)
		Continue:'$IsObject(ObjICU)
		Set Type=ObjICU.Type
		Continue:Type'=ICUType
	      Set Day=..GetPipeUseDays(ObjICU)
	      Set Days=Days+Day
	}
	Quit Days
}

/// 描述:获取呼吸机使用日数
ClassMethod GetRespPlumDays(Paadm As %String)
{
	New (Paadm)
	Set (ICUID,Days)=0,NPaadm=" "_Paadm,ObjICURep="",ICUType="VT"
	For {
		Set ICUID=$O(^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm",NPaadm,ICUID))	
		Quit:ICUID=""
		Set ObjICU=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%OpenId(ICUID)
		Continue:'$IsObject(ObjICU)
		Set Type=ObjICU.Type
		Continue:Type'=ICUType
	      Set Day=..GetPipeUseDays(ObjICU)
	      Set Days=Days+Day
	}
	Quit Days
}

/// 描述：留置导尿管病人日数
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetCathOfDays(20001613)
ClassMethod GetCathOfDays(Paadm As %String)
{
	New (Paadm)
	Set (ICUID,Days)=0,NPaadm=" "_Paadm,ObjICU="",ICUType="C"
	For {
		Set ICUID=$O(^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm",NPaadm,ICUID))	
		Quit:ICUID=""
		Set ObjICU=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%OpenId(ICUID)
		Continue:'$IsObject(ObjICU)
		Set Type=ObjICU.Type
		Continue:Type'=ICUType
	      Set Day=..GetPipeUseDays(ObjICU)
	      Set Days=Days+Day
	}
	Quit Days
}

/// 描述：获取三管使用日数
ClassMethod GetPipeUseDays(ICURepObj As DHCMed.NINF.Srv.InfStatICUInfo)
{
	New (ICURepObj)
	Set Days=0
	Quit:'$IsObject(ICURepObj) Days
	Set StaDate=ICURepObj.InDate
	Set OutDate=ICURepObj.OutDate
	Set:(StaDate>0)&&(OutDate>0) Days=OutDate-StaDate+1
	Quit Days
}

/// 描述：获取进行血液透析次数
ClassMethod GetHemodialysisTimes(Paadm As %String)
{
	New (Paadm)
	Set Count=0,SubCatName="血液透析"
	Set Count=..GetOEOrdOfCount(Paadm,"",SubCatName,"")  ;..GetPatRepCount(Paadm,ProjectName)
	Quit Count
}

/// 描述：根据Paadm获取ICUReport对象
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetICUReportByPaadm(511)
ClassMethod GetICUReportByPaadm(Paadm As %String) As DHCMed.NINF.Aim.ICUReport
{
	New (Paadm)
	Set ICURepID=0,NPaadm=" "_Paadm,ObjICURep=""
	For {
		Set ICURepID=$O(^DHCMed.CR.ReportI("EpisodeID",NPaadm,ICURepID))	
		Quit:ICURepID=""
		Set ObjICURep=##Class(DHCMed.NINF.Aim.ICUReport).GetObjById(ICURepID)
	}	
	Quit ObjICURep
}

/// 描述：获取病人中心静脉相关血源性感染次数
ClassMethod GetVenousBloodInfTimes(Paadm As %String)
{
	New (Paadm)
	Set Position="血液",Operation="插管"
	Set InfPosiCount=..GetPosiInfTimes(Paadm,Position,Operation)
	Quit InfPosiCount
}

/// 描述：获取病人呼吸机相关肺部感染次数
ClassMethod GetRespPlumInfTimes(Paadm As %String)
{
	New (Paadm)
	Set Position="下呼吸道",Operation="插管"
	Set InfPosiCount=..GetPosiInfTimes(Paadm,Position,Operation)
	Quit InfPosiCount
}

/// 描述：获取留置导尿管相关泌尿道感染次数
ClassMethod GetCathUrinaryTractInfTimes(Paadm As %String)
{
	New (Paadm)
	Set Position="泌尿道",Operation="插管"
	Set InfPosiCount=..GetPosiInfTimes(Paadm,Position,Operation)
	Quit InfPosiCount
}

/// 描述：获取与血液透析相关血液感染次数
ClassMethod GetBloodInfTimes(Paadm As %String)
{
	New (Paadm)
	Set Position="血管",Operation="血液透析"
	Set InfPosiCount=..GetPosiInfTimes(Paadm,Position,Operation)
	Quit InfPosiCount
}

/// 描述：根据病人就诊获取院感报告中某部位的感染次数
/// Input:Paadm：就诊ID   Position：感染部位  Operation：操作
ClassMethod GetPosiInfTimes(Paadm As %String, Position As %String = "", Operation As %String = "")
{
	New (Paadm,Position,Operation)
	Set (ReportID,InfPosiCount)=0,NPaadm=Paadm
	For {
		Set ReportID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",NPaadm,ReportID))	
		Quit:ReportID=""
		
		Set ObjRep=##Class(DHCMed.NINF.Rep.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(ObjRep)
		Continue:(ObjRep.ReportStatus.Code="5")||(ObjRep.ReportStatus.Code="0") //去掉 删除 退回的报告
		Set SubID=0,IsInfPosi="N",InfPosi=""
		For {
			Set SubID=$O(^DHCMed.NINF("InfRep",ReportID,"InfPos",SubID))
			Quit:(SubID="")||(IsInfPosi="Y")
			
			Set PosSubID=ReportID_"||"_SubID
			Set ObjPos=##Class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(PosSubID)
			If ($IsObject(ObjPos)){
			     Set PosDic=ObjPos.InfPos
			     If ($IsObject(PosDic)){
					Set InfPosi=PosDic.IPDesc
					Set InfOperation=ObjPos.InfPosOpr
					Continue:(InfPosi'=Position)&&(Position'="")
					If (Operation'=""){  //侵害操作不空，判断侵害操作
						Set Count=InfOperation.Count()
						For Index=1:1:Count {
						      Set ObjPos=InfOperation.GetAt(Index)
						      If ($IsObject(ObjPos.InvasiveOper)) {
						           Set PosDesc=ObjPos.InvasiveOper.Description
						           Set:PosDesc[Operation IsInfPosi="Y"
						      }
					      }
				       }
			       }
		        }
	       }
		Set:IsInfPosi="Y" InfPosiCount=$i(InfPosiCount)
	}
	Quit InfPosiCount
}

/// 描述：提取某个种类的医嘱信息
/// Input:Paadm            就诊ID 
///         ArcDesc         医嘱名称描述
///         SubCateDesc  医嘱子类描述  
///         CateDesc       医嘱大类描述
/// w ##Class(DHCMed.NINFService.Sta.InfStatTarget).GetOEOrdOfCount(345,"","血液透析","")
ClassMethod GetOEOrdOfCount(Paadm As %String, ArcDesc As %String = "", SubCateDesc As %String = "", CateDesc As %String = "")
{
	New (Paadm,ArcDesc,SubCateDesc,CateDesc)
	Quit:Paadm="" -100
	Set Count=0
	;Quit:(ArcDesc="")&&(SubCateDesc="")&&(CateDesc="") Count
      Set xOrdID=$o(^OEORD(0,"Adm",+Paadm,""))
	Set xArcimID=""
	For {
		Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
		Quit:xArcimID=""
		Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		Continue:'$IsObject(objArcim)
		Set ARCItmSubCatDesc=objArcim.ARCICDesc
		Set ARCItmCatDesc=objArcim.ORCATDesc
		
		Continue:(CateDesc'="")&&(ARCItmCatDesc'[CateDesc)
		Continue:(SubCateDesc'="")&&(ARCItmSubCatDesc'[SubCateDesc)
		 
		Set ArcimID=xArcimID
		Set ArcimDesc=objArcim.ARCIMDesc
		Continue:(ArcDesc'="")&&(ArcimDesc'[ArcDesc)	
		;w ArcimDesc_","_ARCItmSubCatDesc_","_ARCItmCatDesc ,!
	
		Set xOrdDate=0
		For {
			Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
			Quit:xOrdDate=""
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
				Quit:xSubID=""
						
				Set OEItemID=xOrdID_"||"_xSubID
				Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
				Continue:'$IsObject(objOEItem)
				Set StatusCode=objOEItem.OSTATCode
				Continue:(StatusCode="D")||(StatusCode="S")
				Set Count=$i(Count)
			}
		}
      }
      Quit Count
}

}
