Class web.DHCCPW.MRIR.OrderItemAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 描述：缓存同一个病种，同一段时间内的数据。
ClassMethod ProcessOfCacheData(argDischStaDate As %String, argDischEndDate As %String, argCPWDID As %String, repid As %String)
{
	New (argDischStaDate,argDischEndDate,argCPWDID,repid)
	Set JIndex=$j,ZIndex=$ZN,DischStaDate=argDischStaDate,DischEndDate=argDischEndDate,
	    CPWDID=argCPWDID,Rtn=""
	    
	If ($d(^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA"))){
		Set ind=0
		For {
			Set ind=$o(^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA",ind))
			Quit:ind=""
			Set ^CacheTemp(repid,ind)=$g(^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA",ind))
		}
		;Do ..ClearOfCacheData()
		;M ^CacheTemp(repid)=^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA")
		Set Rtn="OK"
		Set ii=$i(^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA"))
		;Set ii=$i(^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA"))
	}
	;清楚缓存数据
	Do ..ClearOfCacheData()
	/*
	;清楚缓存数据
	Set ReadCacheOfCount=+$g(^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA")),
	    StepOfCount=+$g(^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID))
	Set StepOfCount=StepOfCount*2-1
	If (ReadCacheOfCount=StepOfCount){
		Kill ^TMP(ZIndex,JIndex,"DHCCPWOfCache")
	}
    */
	;b ;11
	;
	;Set ^TMP(ZIndex,JIndex,CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA",ind)=Data
	Quit Rtn
}

/// 描述：删除缓存数据 
/// 入参: Type--1 删除所有缓存数据1
/// Debug:w ##Class(web.DHCCPW.MRIR.OrderItemAnalysis).ClearOfCacheData()
ClassMethod ClearOfCacheData(Type As %String = "")
{
	New (Type)
	Set ZIndex=$ZN,JIndex=$J,Rtn=""
	Set $ZT="ClearOfCacheDataErr"
	If (Type=1){  ;删除所有缓存数
	    Kill ^TMP("DHCCPWOfCache")
	}Else{
		Set CPWDID=0
		For {
			Set CPWDID=$O(^TMP("DHCCPWOfCache",CPWDID))
			Quit:CPWDID=""
			Set StaDate=0
			For {
				Set StaDate=$O(	^TMP("DHCCPWOfCache",CPWDID,StaDate))
				Quit:StaDate=""
				;w CPWDID_","_StaDate,!
				Set EndDate=0
				For {
				    Set EndDate=$O(^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate))
				    Quit:EndDate=""
				    Set ProcessDT=$g(^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate))
				    ;w ProcessDT,!
				    If ProcessDT="" {
					    Kill ^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate)
				    } Else {
					    Set RtnVal=..IsOutTime(ProcessDT)
					    ;w RtnVal,!
					    Kill:RtnVal="1" ^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate)
				    } 
				}
			}	
		}
	}	
	Quit Rtn
ClearOfCacheDataErr
    Set $ZT=""
    Quit "-100"
}

/// Debug:w ##Class(web.DHCCPW.MRIR.OrderItemAnalysis).ShowOfCacheData()
ClassMethod ShowOfCacheData()
{
	Set ZIndex=$ZN,Count=0	
	Set CPWDID=0
	For {
		Set CPWDID=$O(^TMP("DHCCPWOfCache",CPWDID))
		Quit:CPWDID=""
		Set StaDate=0
		For {
			Set StaDate=$O(^TMP("DHCCPWOfCache",CPWDID,StaDate))
			Quit:StaDate=""
			
			Set EndDate=0
			For {
				Set EndDate=$O(^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate))
				Quit:EndDate=""
				
				Set Index=0
				For {
					Set Index=$O(^TMP("DHCCPWOfCache",CPWDID,StaDate,EndDate,"DHCCPWOfOA",Index))
					Quit:Index=""
					Set Count=$i(Count)	
				}
			}	
		}
		
	}
	Quit Count
}

/// Debug:w ##Class(web.DHCCPW.MRIR.OrderItemAnalysis).IsOutTime("62981,81")
ClassMethod IsOutTime(ProcessDT As %String) As %String
{
	New (ProcessDT)
	Set CurrDT=$H,Rtn="",BaseTime=10*60  ;10分钟
	
	Set ProcessDate=$P(ProcessDT,",",1)
	Set ProcessTime=$P(ProcessDT,",",2)
	Set CurrDate=$P(CurrDT,",",1)
	Set CurrTime=$P(CurrDT,",",2)
	
	Set MoreTime=(CurrDate-ProcessDate)*24*60*60+CurrTime-ProcessTime
	;w "MoreTime:"_MoreTime,!
	If +MoreTime>+BaseTime {
	   Set Rtn="1"
	}Else{
	   Set Rtn="-1"	
	}
	Quit Rtn
}

/// Creator:wangcs
/// CreateDate:2012-04-04
/// Description:医嘱项分析
/// Debug:d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.OrderItemAnalysis","OrdItemAnalysis","2013-05-01","2013-06-06",2)
Query OrdItemAnalysis(argDischStaDate As %String, argDischEndDate As %String, argCPWDID As %String) As %Query(ROWSPEC = "StepName:%String,ItemName:%String,ExecScale:%String,OrdType:%String,IsMust:%String") [ SqlProc ]
{
}

ClassMethod OrdItemAnalysisExecute(ByRef qHandle As %Binary, argDischStaDate As %String, argDischEndDate As %String, argCPWDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set DischStaDate=argDischStaDate
	Set:DischStaDate["-" DischStaDate=$zdh(DischStaDate,3)
	Set:DischStaDate["/" DischStaDate=$zdh(DischStaDate,4)
	Set DischEndDate=argDischEndDate
	Set:DischEndDate["-" DischEndDate=$zdh(DischEndDate,3)
	Set:DischEndDate["/" DischEndDate=$zdh(DischEndDate,4)
	
	Set CPWDID=argCPWDID   ;路径字典ID
	Quit:((argDischStaDate="")||(argDischEndDate="")||(argCPWDID="")) $$$OK
	Set ^Test("OrdItemAnalysisExecute")=argDischStaDate_","_argDischEndDate_","_argCPWDID
	Set ZIndex=$zn,JIndex=$j
	Set RtnVal=..ProcessOfCacheData(DischStaDate,DischEndDate,CPWDID,repid)
	Quit:RtnVal="OK" $$$OK
	Kill ^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis")
	
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	for DischgDate=DischStaDate:1:DischEndDate {
		Set Paadm=0
		for {
		    Set Paadm=$o(^PAADMi(DischDateIndex,DischgDate,Paadm))
		    Quit:Paadm=""
		    Set AdmInfo=##Class(web.DHCCPW.MR.PAADMSrv).GetAdmInfoByID(Paadm,"^")
		    Continue:AdmInfo=""
		    Set MrAdm=$p(AdmInfo,"^",13)
		    Continue:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm))   ;没有入径病人
		    Set TempCPWDID="",CPWRID=""  ;入径记录ID
		    
			Set CPWRID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm,CPWRID),-1)
			Continue:CPWRID=""
				
			Set CPWRObj=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWRID)
			Continue:'$IsObject(CPWRObj)
			Set TempCPWDr=CPWRObj.CPWPathwayDR  
			Continue:'$IsObject(TempCPWDr)
			Set VerDate=$zd(TempCPWDr.CPWVerDate,3)
			Set Version=" (V"_TempCPWDr.CPWVersion_".0 "_VerDate_")"
			Set CPWPathWayID=TempCPWDr.%Id() 
			Set TempCPWDID=TempCPWDr.CPWCPWDicDR.%Id()
			Continue:((CPWDID'="")&&(CPWDID'=TempCPWDID))
			Continue:CPWRObj.CPWStatus="O"  ;过滤出径病人
			Set Num=$i(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID))
		    Do ..AnalysisDataByEpisode(CPWRID,Paadm,CPWDID,Version)      ;分析入径病人的医嘱
		}
	}
	
	Set EPStep=0
	for {
		Set EPStep=$o(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep))
		Quit:EPStep=""
		
		Set EpStepOrdType="0"   ;重点医嘱执行情况
		do ..BuildData(CPWDID,EPStep,EpStepOrdType)
		Set EpStepOrdType="1"   ;路径外医嘱
		do ..BuildData(CPWDID,EPStep,EpStepOrdType)
		
    }
    ;记录系统数据处理日期时间
    ;Set ^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate)=$H
    ;Set ^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA")=1
    Set ^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate)=$H
    Kill ^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis")
	Quit $$$OK
}

/// Description:装填返回数据  
/// Input:EpStepOrdType   -重点医嘱执行情况
///                       -路径外医嘱
ClassMethod BuildData(CPWDID As %String, EPStep As %String, EpStepOrdType As %String)
{
	Set Data=""
	Set PathOrd=$s(EpStepOrdType="0":"PathInOrd",EpStepOrdType="1":"PathOutOrd")
	
	Set Total=+$g(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID))
	Set ItemID=""
	for {
		   Set ItemID=$o(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,PathOrd,ItemID))
		   Quit:ItemID=""
		   Set (ExeScale,ExecCnt,EPStepDesc,ItemDesc,IsMust)=""
		   
		   Set EPStepDesc=$p(EPStep,$C(1),1)
		   Set Ver=$p(EPStep,$C(1),3)
		   If (EpStepOrdType="1") {
		      Set ItemDesc=$p($g(^ARCIM($p(ItemID,"||",1),$p(ItemID,"||",2),1)),"^",2)
		      Set ItemDesc=ItemDesc_Ver
		      Continue:ItemDesc=""
		      Set IsMust="N"
		   }ElseIf(EpStepOrdType="0"){
			  Set ObjItem=##Class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
			  Continue:'$IsObject(ObjItem)
			  Continue:'$IsObject(ObjItem.CPWSIParRef)||'$IsObject(ObjItem.CPWSIParRef.CPWSParRef)||'$IsObject(ObjItem.CPWSIParRef.CPWSParRef.EPParRef)
			  Set Version=ObjItem.CPWSIParRef.CPWSParRef.EPParRef.CPWVersion
			  Set VerDate=ObjItem.CPWSIParRef.CPWSParRef.EPParRef.CPWVerDate
			  Set ItemDesc=ObjItem.CPWSIDesc_Ver  ;"(V "_Version_".0 "_VerDate_")"
			  Set IsMust=ObjItem.CPWSIIsMust
		   }
		   Set ExecCnt=+$g(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,PathOrd,ItemID))
		  
		   Set ExeScale=$fn((ExecCnt/Total)*100,"",2)_"%"
		   ;截取项目名称和医嘱项名称最大长度
		   ;Set MaxLen=30
		   ;Set:$l(ItemDesc)>MaxLen ItemDesc=$e(ItemDesc,0,MaxLen)_"..."
		   ;Set ItemDesc=$tr(ItemDesc," ","")
		   ;Set ItemDesc=$tr(ItemDesc,$c(10),"")
		   ;Set ItemDesc=$tr(ItemDesc,$c(13),"")
		  
		   Set Data=$lb(EPStepDesc,ItemDesc,ExeScale,EpStepOrdType,IsMust)
		   Set ^CacheTemp(repid,ind)=Data
		   ;使用缓存数据
		   ;Set ^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA",ind)=Data
		   Set ^TMP("DHCCPWOfCache",CPWDID,DischStaDate,DischEndDate,"DHCCPWOfOA",ind)=Data
		   Set ind=ind+1
		   
	}
}

/// Description:分析入径病人的重点医嘱和路径外医嘱
ClassMethod AnalysisDataByEpisode(CPWRID As %String, EpisodeID As %String, CPWDID As %String, Version As %String)
{
    new (CPWRID,EpisodeID,CPWDID,Version)
    
    Set ZIndex=$zn,JIndex=$j
    
    Set StepID=0
    For {
	    Set StepID=$O(^DHCMR("IMPL",CPWRID,"EpStep",StepID))
	    Quit:StepID=""
	    
	    Set EpStepObj=##Class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepID)
		Continue:'$IsObject(EpStepObj)
		Set EPStepDesc=EpStepObj.CPWSDesc
	    Set EPStep=EPStepDesc_$C(1)_StepID_$c(1)_Version
	    ;处理路径内医嘱
        Set ARCIMID=0
        For {
		   Set ARCIMID=$o(^DHCMR("IMPL",CPWRID,"EpStep",StepID,"ARCIM",ARCIMID))
		   Quit:(ARCIMID="")
		   		   
		   Set ItemID=0,InPathOrdOfFlag="PathInOrd"
		   Set ItemID=$O(^DHCMR("IMPL",CPWRID,"EpStep",StepID,"ARCIM",ARCIMID,ItemID))
		   Continue:$d(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis","CPWRID",CPWRID,EPStep,ItemID))   ;不重复计算同一个项目下的多个医嘱
		   Set ^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,InPathOrdOfFlag,ItemID)=$i(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,InPathOrdOfFlag,ItemID))
		   Set ^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis","CPWRID",CPWRID,EPStep,ItemID)=ARCIMID
        } 
        ;路径外医嘱
		Do ..AnalysisOutOrd(CPWRID,StepID,CPWDID,EPStep)   
    }
}

/// 描述:从变异记录分析每个阶段的路径外医嘱
ClassMethod AnalysisOutOrd(CPWRID As %String, StepID As %String, CPWDID As %String, EPStep As %String)
{
  New (CPWRID,StepID,CPWDID,EPStep)
  Set ZIndex=$ZN,JIndex=$j,Rtn="",OutPathOrdOfFlag="PathOutOrd"
  ;变异记录查找路径外医嘱
  Set VARID=0
  For {
      Set VARID=$O(^DHCMRi(0,"VAR","IndexEpStep",CPWRID,StepID,VARID))
	  Quit:VARID="" 
				
	  Set ObjVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWRID_"||"_VARID)
	  Set UpdoFlag=ObjVar.CPWVUpdoFlag
	  Continue:UpdoFlag="Y"  ;过滤撤销的变异
	  Set ExtraValues=ObjVar.CPWVExtraValues ;附加项内容
	  Continue:ExtraValues'["OEITEM:"
	  Set Len=$l(ExtraValues,"OEITEM:")
	  For Index=2:1:Len {
		  Set OEITEMID=$P($P(ExtraValues,"OEITEM:",Index),"-",1)
		  Set:($P(OEITEMID,"||",1)'="")&&($P(OEITEMID,"||",2)'="")&&$d(^OEORD($P(OEITEMID,"||",1),"I",$P(OEITEMID,"||",2))) ARCIMID=$P(^OEORD($P(OEITEMID,"||",1),"I",$P(OEITEMID,"||",2),1),"^",2)
		  Set ^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,OutPathOrdOfFlag,ARCIMID)=$i(^CacheTemp(ZIndex,JIndex,"OrdItemAnalysis",CPWDID,EPStep,OutPathOrdOfFlag,ARCIMID))
	  }
   }	
   Quit Rtn
}

ClassMethod OrdItemAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdItemAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
	
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OrdItemAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdItemAnalysisExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator:wangcs
/// CreateDate:2012-07-11
/// Description:查询阶段名称根据路径字典ID
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.OrderItemAnalysis","QryEpStepDesc",1)
Query QryEpStepDesc(argCPWDID As %String) As %Query(ROWSPEC = "RowId:%String,EpStepDesc:%String") [ SqlProc ]
{
}

ClassMethod QryEpStepDescExecute(ByRef qHandle As %Binary, argCPWDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Quit:argCPWDID="" $$$OK
	Set CPWDID=argCPWDID
	Set CPWDObj=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
	Quit:'$IsObject(CPWDObj) $$$OK
	
	Set CPWDVersion=CPWDObj.CPWDVersion
	;Set CPWObj=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetById(CPWDVersion)
	Quit:CPWDVersion="" $$$OK	//Add by zhaoyu 2013-01-08 医嘱项分析报错对象不存在
	Quit:'$d(^DHCMRC("CPW",CPWDVersion)) $$$OK
	
	Set EPID=0
	For {
		Set EPID=$o(^DHCMRC("CPW",CPWDVersion,"EP",EPID))
		Quit:EPID=""
		Set EPStepID=0,EPStepCount=0
		For {
		   Set EPStepID=$o(^DHCMRC("CPW",CPWDVersion,"EP",EPID,"STEP",EPStepID))
		   Quit:EPStepID=""
		   Set EPStepRowID=CPWDVersion_"||"_EPID_"||"_EPStepID
		   Set EPStepObj=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EPStepRowID)
		   Continue:'$IsObject(EPStepObj)
		   Set EPStepDesc=EPStepObj.CPWSDesc
		   Set Data=$lb(EPStepRowID,EPStepDesc)
		   Set ^CacheTemp(repid,ind)=Data
		   Set ind=ind+1,EPStepCount=EPStepCount+1
		}
	}
	Set ^TMP(ZIndex,JIndex,"DHCCPWOfCache",CPWDID)=EPStepCount
	Quit $$$OK
}

ClassMethod QryEpStepDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpStepDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpStepDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpStepDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 描述：处理病人的医嘱数据
/// Debug:w ##Class(web.DHCCPW.MRIR.OrderItemAnalysis).GetOrdOfDataByEpisodeID(13516211)
ClassMethod GetOrdOfDataByEpisodeID(EpisodeID As %String)
{
	New (EpisodeID)
	Set Rtn=""
	Set $ZT="GetOrdOfDataByEpisodeIDErr"
	Set AdmInfo=##Class(web.DHCCPW.MR.PAADMSrv).GetAdmInfoByID(EpisodeID,"^")
	Quit:AdmInfo="" "就诊信息不存在"
	Set MrAdm=$p(AdmInfo,"^",13)
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm)) "不是入径病人"                ;没有入径病人
	Set TempCPWDID=""
	Set CPWRID=0  ;入径记录ID
	for {
		Set CPWRID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm,CPWRID))
		Quit:CPWRID=""
		
		Set CPWRObj=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWRID)
		Set CPWObj=CPWRObj.CPWPathwayDR
		Continue:'$IsObject(CPWObj)
		Set CPWID=CPWObj.%Id()
		
		Set EPID=0
		For {
			Set EPID=$O(^DHCMRC("CPW",CPWID,"EP",EPID))
			Quit:EPID=""
			
			Set StepID=0
			For {
			    Set StepID=$O(^DHCMRC("CPW",CPWID,"EP",EPID,"STEP",StepID))
			    Quit:StepID=""
			    
			    Set sStepID=CPWID_"||"_EPID_"||"_StepID
			    Set RtnVal=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(CPWRID,sStepID,"")
			}
		}
	}
    Quit 1
GetOrdOfDataByEpisodeIDErr
    Set $ZT=""
    Quit "-1"
}

/// 处理出院临床路径病人的医嘱执行数据
/// Debug:w ##Class(web.DHCCPW.MRIR.OrderItemAnalysis).ProcessOrdOfDataByDisData("2013-05-01","2013-06-01")
ClassMethod ProcessOrdOfDataByDisData(DischStaDate As %String, DischEndDate As %String)
{
	New (DischStaDate,DischEndDate)
	
	Set:DischStaDate["-" DischStaDate=$zdh(DischStaDate,3)
	Set:DischStaDate["/" DischStaDate=$zdh(DischStaDate,4)
	Set DischStaDate=+DischStaDate
	Set:DischEndDate["-" DischEndDate=$zdh(DischEndDate,3)
	Set:DischEndDate["/" DischEndDate=$zdh(DischEndDate,4)
	Set DischEndDate=+DischEndDate
	Set Count=0
	;Set DischDate=DischStaDate-1
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=DischStaDate:1:DischEndDate {
		Set Paadm=0
		For {
	        Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
	        Quit:Paadm=""
	        
	        Set AdmType=$P(^PAADM(Paadm),"^",2)
	        Continue:AdmType'="I"
	        Set VisitStatus=$P(^PAADM(Paadm),"^",20)
	        Continue:VisitStatus'="D"
	        
	        Set RtnVal=..GetOrdOfDataByEpisodeID(Paadm)
	        w "return="_RtnVal_",Paadm="_Paadm,!
	        Set Count=$I(Count)
		}
	}
	w "合计："_Count,!
	Quit "Ok"
}

}
