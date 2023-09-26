/// 名称: web.DHCCPW.MR.VarianceAnalysis
/// 描述: 临床路径变异分析
/// 编写者：zhufei
/// 编写日期: 2010-10-29
Class web.DHCCPW.MR.VarianceAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  入径路径变异统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarianceByInDate","2010-01-01","2010-10-29","","")
Query QryVarianceByInDate(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,InCount:%String,OutCount:%String,CloseCount:%String,VarCount:%String,OutRatio:%String,CloseRatio:%String,VarRatio:%String")
{
}

ClassMethod QryVarianceByInDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Kill ^TMP($zn,$j,"VarianceByIn")
	//Index IndexInDate On (CPWInDate, CPWInTime);
	//^DHCMRi("CPW",0,"IndexInDate",61884,59220,1)
	For InDate=argDateFrom:1:argDateTo {
		Set InTime=0
		For {
			Set InTime=$o(^DHCMRi("CPW",0,"IndexInDate",InDate,InTime))
			Quit:InTime=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexInDate",InDate,InTime,PathWayID))
				Quit:PathWayID=""
				
				Set (Paadm,AdmLoc,AdmWard,CPWID,CPWStatus,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					Set MRAdm=objPathWay.CPWMRADMDR
					Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(CPWStatus="")||(CPWID="")||(Paadm="")
				
				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
				If $IsObject(objPaadm)
				{
					If $IsObject(objPaadm.PAADMDepCodeDR)
				    {
					    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
					}
				    If $IsObject(objPaadm.PAADMCurrentWardDR)
				    {
					    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
					    {
						    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
						}
					}
				}
				If objPaadm'="" Do objPaadm.%Close()
				Continue:(argLocID'="")&&(argLocID'=AdmLoc)
				Continue:(argWardID'="")&&(argWardID'=AdmWard)
				
				Set Count=$i(^TMP($zn,$j,"VarianceByIn"))                  //总人次
				Set Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID))            //路径入径人次=路径总人次
				Set:CPWStatus="O" Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID,"Out"))    //出径人次
				Set:CPWStatus="C" Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID,"Close"))  //关闭人次
				If OutReasonDR'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID,"OutReason",OutReasonDR))  //出径原因人次
				}
				
				Set SubID="",IsVariance=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID,"VarReason",VarReasonDR))  //变异原因数量
					Set IsVariance="Y"
				}
				If IsVariance'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByIn",CPWID,"Variance"))  //发生变异人次
				}
			}
		}
	}

	Set Count=+$g(^TMP($zn,$j,"VarianceByIn"))
	Quit:Count<1 $$$OK
	
	Set (InCountA,OutCountA,CloseCountA,VarCountA)=0
	Set CPWID=0
	For {
		Set CPWID=$o(^TMP($zn,$j,"VarianceByIn",CPWID))
		Quit:CPWID=""
		
		Set CPWDesc=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
		}
		Continue:CPWDesc=""
		
		Set InCount=+$g(^TMP($zn,$j,"VarianceByIn",CPWID))
		Set OutCount=+$g(^TMP($zn,$j,"VarianceByIn",CPWID,"Out"))
		Set CloseCount=+$g(^TMP($zn,$j,"VarianceByIn",CPWID,"Close"))
		Set VarCount=+$g(^TMP($zn,$j,"VarianceByIn",CPWID,"Variance"))
		If InCount="" {
			Set OutRatio="0.00%"
			Set CloseRatio="0.00%"
			Set VarRatio="0.00%"
		}Else{
			Set OutRatio=$fn((OutCount/InCount)*100,"",2)_"%"
			Set CloseRatio=$fn((CloseCount/InCount)*100,"",2)_"%"
			Set VarRatio=$fn((VarCount/InCount)*100,"",2)_"%"
		}
		
		Set InCountA=InCountA+InCount
		Set OutCountA=OutCountA+OutCount
		Set CloseCountA=CloseCountA+CloseCount
		Set VarCountA=VarCountA+VarCount
		
		Set Data=$lb(CPWID,CPWDesc,InCount,OutCount,CloseCount,VarCount,OutRatio,CloseRatio,VarRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If InCountA="" {
		Set OutRatioA="0.00%"
		Set CloseRatioA="0.00%"
		Set VarRatioA="0.00%"
	}Else{
		Set OutRatioA=$fn((OutCountA/InCountA)*100,"",2)_"%"
		Set CloseRatioA=$fn((CloseCountA/InCountA)*100,"",2)_"%"
		Set VarRatioA=$fn((VarCountA/InCountA)*100,"",2)_"%"
	}
	Set Data=$lb("0","合计",InCountA,OutCountA,CloseCountA,VarCountA,OutRatioA,CloseRatioA,VarRatioA)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"VarianceByIn")

	Quit $$$OK
}

ClassMethod QryVarianceByInDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceByInDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceByInDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceByInDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  入径路径出径原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryOutReasonByInDate",1,"2010-01-30","2010-10-30","","")
Query QryOutReasonByInDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryOutReasonByInDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"OutReasonByIn")
	//Index IndexPathWayInDate On (CPWPathwayDR As Exact, CPWInDate As Exact, CPWInTime As Exact);
	//^DHCMRi("CPW",0,"IndexPathWayInDate",1,-100000000000000,-100000000000000,2)
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID))
		Quit:CPWID=""
		Continue:(argCPWID'="")&&(CPWID'=argCPWID)
		
		For InDate=argDateFrom:1:argDateTo {
			Set InTime=0
			For {
				Set InTime=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,InDate,InTime))
				Quit:InTime=""
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,InDate,InTime,PathWayID))
					Quit:PathWayID=""
					
					Set (Paadm,AdmLoc,AdmWard,OutReasonDR)=""
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set MRAdm=objPathWay.CPWMRADMDR
						Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
						If $IsObject(objPathWay.CPWOutReasonDR){
							Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
						}
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:(Paadm="")||(OutReasonDR="")
					
					Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
					If $IsObject(objPaadm)
					{
						If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
						    {
							    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
							}
						}
					}
					If objPaadm'="" Do objPaadm.%Close()
					Continue:(argLocID'="")&&(argLocID'=AdmLoc)
					Continue:(argWardID'="")&&(argWardID'=AdmWard)
					
					Continue:OutReasonDR=""
					Set Count=$i(^TMP($zn,$j,"OutReasonByIn"))
					Set Count=$i(^TMP($zn,$j,"OutReasonByIn",OutReasonDR))  //出径原因数量
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"OutReasonByIn"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"OutReasonByIn",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"OutReasonByIn",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"OutReasonByIn")
	
	Quit $$$OK
}

ClassMethod QryOutReasonByInDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutReasonByInDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutReasonByInDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutReasonByInDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  入径路径变异原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarReasonByInDate","","2010-01-30","2010-10-30","","")
Query QryVarReasonByInDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryVarReasonByInDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"VarReasonByIn")
	//Index IndexPathWayInDate On (CPWPathwayDR As Exact, CPWInDate As Exact, CPWInTime As Exact);
	//^DHCMRi("CPW",0,"IndexPathWayInDate",1,-100000000000000,-100000000000000,2)
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID))
		Quit:CPWID=""
		Continue:(argCPWID'="")&&(CPWID'=argCPWID)
		
		For InDate=argDateFrom:1:argDateTo {
			Set InTime=0
			For {
				Set InTime=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,InDate,InTime))
				Quit:InTime=""
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,InDate,InTime,PathWayID))
					Quit:PathWayID=""
					
					Set (Paadm,AdmLoc,AdmWard)=""
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set MRAdm=objPathWay.CPWMRADMDR
						Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:Paadm=""
					
					Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
					If $IsObject(objPaadm)
					{
						If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
						    {
							    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
							}
						}
					}
					If objPaadm'="" Do objPaadm.%Close()
					Continue:(argLocID'="")&&(argLocID'=AdmLoc)
					Continue:(argWardID'="")&&(argWardID'=AdmWard)
					
					Set SubID=""
					For {
						Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
						Quit:SubID=""
						Set VarianceID=PathWayID_"||"_SubID
						Set VarReasonDR=""
						Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
						If $IsObject(objVariance) {
							Set VarUpdoFlag=objVariance.CPWVUpdoFlag
							Continue:VarUpdoFlag="Y"
							If $IsObject(objVariance.CPWVReasonDR) {
								Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
							}
						}
						Continue:VarReasonDR=""
						Set Count=$i(^TMP($zn,$j,"VarReasonByIn"))
						Set Count=$i(^TMP($zn,$j,"VarReasonByIn",VarReasonDR))  //变异原因数量
					}
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarReasonByIn"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"VarReasonByIn",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"VarReasonByIn",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"VarReasonByIn")
	
	Quit $$$OK
}

ClassMethod QryVarReasonByInDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonByInDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonByInDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonByInDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  出径路径变异统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarianceByOutDate","2010-01-01","2010-10-29","","")
Query QryVarianceByOutDate(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,InCount:%String,OutCount:%String,CloseCount:%String,VarCount:%String,OutRatio:%String,CloseRatio:%String,VarRatio:%String")
{
}

ClassMethod QryVarianceByOutDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Kill ^TMP($zn,$j,"VarianceByIn")
	//Index IndexOutDate On (CPWOutDate, CPWOutTime);
	//^DHCMRi("CPW",0,"IndexOutDate",61884,59220,1)
	For OutDate=argDateFrom:1:argDateTo {
		Set OutTime=0
		For {
			Set OutTime=$o(^DHCMRi("CPW",0,"IndexOutDate",OutDate,OutTime))
			Quit:OutTime=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexOutDate",OutDate,OutTime,PathWayID))
				Quit:PathWayID=""
				
				Set (Paadm,AdmLoc,AdmWard,CPWID,CPWStatus,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					Set MRAdm=objPathWay.CPWMRADMDR
					Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(CPWStatus="")||(CPWID="")||(Paadm="")
				
				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
				If $IsObject(objPaadm)
				{
					If $IsObject(objPaadm.PAADMDepCodeDR)
				    {
					    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
					}
				    If $IsObject(objPaadm.PAADMCurrentWardDR)
				    {
					    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
					    {
						    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
						}
					}
				}
				If objPaadm'="" Do objPaadm.%Close()
				Continue:(argLocID'="")&&(argLocID'=AdmLoc)
				Continue:(argWardID'="")&&(argWardID'=AdmWard)
				
				Set Count=$i(^TMP($zn,$j,"VarianceByOut"))                  //总人次
				Set Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID))            //路径入径人次=路径总人次
				Set:CPWStatus="O" Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID,"Out"))    //出径人次
				Set:CPWStatus="C" Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID,"Close"))  //完成人次
				If OutReasonDR'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID,"OutReason",OutReasonDR))  //出径原因人次
				}
				
				Set SubID="",IsVariance=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID,"VarReason",VarReasonDR))  //变异原因数量
					Set IsVariance="Y"
				}
				If IsVariance'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByOut",CPWID,"Variance"))  //发生变异人次
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarianceByOut"))
	Quit:Count<1 $$$OK
	
	Set (InCountA,OutCountA,CloseCountA,VarCountA)=0
	Set CPWID=0
	For {
		Set CPWID=$o(^TMP($zn,$j,"VarianceByOut",CPWID))
		Quit:CPWID=""
		
		Set CPWDesc=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
		}
		Continue:CPWDesc=""
		
		Set InCount=+$g(^TMP($zn,$j,"VarianceByOut",CPWID))
		Set OutCount=+$g(^TMP($zn,$j,"VarianceByOut",CPWID,"Out"))
		Set CloseCount=+$g(^TMP($zn,$j,"VarianceByOut",CPWID,"Close"))
		Set VarCount=+$g(^TMP($zn,$j,"VarianceByOut",CPWID,"Variance"))
		If InCount="" {
			Set OutRatio="0.00%"
			Set CloseRatio="0.00%"
			Set VarRatio="0.00%"
		}Else{
			Set OutRatio=$fn((OutCount/InCount)*100,"",2)_"%"
			Set CloseRatio=$fn((CloseCount/InCount)*100,"",2)_"%"
			Set VarRatio=$fn((VarCount/InCount)*100,"",2)_"%"
		}
		
		Set InCountA=InCountA+InCount
		Set OutCountA=OutCountA+OutCount
		Set CloseCountA=CloseCountA+CloseCount
		Set VarCountA=VarCountA+VarCount
		
		Set Data=$lb(CPWID,CPWDesc,InCount,OutCount,CloseCount,VarCount,OutRatio,CloseRatio,VarRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If InCountA="" {
		Set OutRatioA="0.00%"
		Set CloseRatioA="0.00%"
		Set VarRatioA="0.00%"
	}Else{
		Set OutRatioA=$fn((OutCountA/InCountA)*100,"",2)_"%"
		Set CloseRatioA=$fn((CloseCountA/InCountA)*100,"",2)_"%"
		Set VarRatioA=$fn((VarCountA/InCountA)*100,"",2)_"%"
	}
	Set Data=$lb("0","合计",InCountA,OutCountA,CloseCountA,VarCountA,OutRatioA,CloseRatioA,VarRatioA)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"VarianceByOut")
	
	Quit $$$OK
}

ClassMethod QryVarianceByOutDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceByOutDateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceByOutDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceByOutDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  出径路径出径原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryOutReasonByOutDate",28,"2010-01-01","2010-10-29","","")
Query QryOutReasonByOutDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryOutReasonByOutDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"OutReasonByOut")
	//Index IndexPathWayOutDate On (CPWPathwayDR As Exact, CPWOutDate As Exact, CPWOutTime As Exact);
	//^DHCMRi("CPW",0,"IndexPathWayOutDate",1,-100000000000000,-100000000000000,2)
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID))
		Quit:CPWID=""
		Continue:(argCPWID'="")&&(CPWID'=argCPWID)
		
		For OutDate=argDateFrom:1:argDateTo {
			Set OutTime=0
			For {
				Set OutTime=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime))
				Quit:OutTime=""
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime,PathWayID))
					Quit:PathWayID=""
					
					Set (Paadm,AdmLoc,AdmWard,OutReasonDR)=""
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set MRAdm=objPathWay.CPWMRADMDR
						Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
						If $IsObject(objPathWay.CPWOutReasonDR){
							Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
						}
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:(Paadm="")||(OutReasonDR="")
					
					Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
					If $IsObject(objPaadm)
					{
						If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
						    {
							    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
							}
						}
					}
					If objPaadm'="" Do objPaadm.%Close()
					Continue:(argLocID'="")&&(argLocID'=AdmLoc)
					Continue:(argWardID'="")&&(argWardID'=AdmWard)
					
					Continue:OutReasonDR=""
					Set Count=$i(^TMP($zn,$j,"OutReasonByOut"))
					Set Count=$i(^TMP($zn,$j,"OutReasonByOut",OutReasonDR))  //出径原因数量
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"OutReasonByOut"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"OutReasonByOut",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"OutReasonByOut",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"OutReasonByOut")
	
	Quit $$$OK
}

ClassMethod QryOutReasonByOutDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutReasonByOutDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutReasonByOutDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutReasonByOutDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  出径路径变异原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarReasonByOutDate",28,"2010-01-01","2010-10-29","","")
Query QryVarReasonByOutDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryVarReasonByOutDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"VarReasonByOut")
	//Index IndexPathWayOutDate On (CPWPathwayDR As Exact, CPWOutDate As Exact, CPWOutTime As Exact);
	//^DHCMRi("CPW",0,"IndexPathWayOutDate",1,-100000000000000,-100000000000000,2)
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID))
		Quit:CPWID=""
		Continue:(argCPWID'="")&&(CPWID'=argCPWID)
		
		For OutDate=argDateFrom:1:argDateTo {
			Set OutTime=0
			For {
				Set OutTime=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime))
				Quit:OutTime=""
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime,PathWayID))
					Quit:PathWayID=""
					
					Set (Paadm,AdmLoc,AdmWard)=""
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set MRAdm=objPathWay.CPWMRADMDR
						Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:Paadm=""
					
					Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
					If $IsObject(objPaadm)
					{
						If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
						    {
							    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
							}
						}
					}
					If objPaadm'="" Do objPaadm.%Close()
					Continue:(argLocID'="")&&(argLocID'=AdmLoc)
					Continue:(argWardID'="")&&(argWardID'=AdmWard)
					
					Set SubID=""
					For {
						Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
						Quit:SubID=""
						Set VarianceID=PathWayID_"||"_SubID
						Set VarReasonDR=""
						Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
						If $IsObject(objVariance) {
							Set VarUpdoFlag=objVariance.CPWVUpdoFlag
							Continue:VarUpdoFlag="Y"
							If $IsObject(objVariance.CPWVReasonDR) {
								Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
							}
						}
						Continue:VarReasonDR=""
						Set Count=$i(^TMP($zn,$j,"VarReasonByOut"))
						Set Count=$i(^TMP($zn,$j,"VarReasonByOut",VarReasonDR))  //变异原因数量
					}
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarReasonByOut"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"VarReasonByOut",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"VarReasonByOut",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"VarReasonByOut")
	
	Quit $$$OK
}

ClassMethod QryVarReasonByOutDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonByOutDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonByOutDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonByOutDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-09-10
/// Description:  入径路径变异统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarianceByAdmDate","2010-01-01","2010-10-29","","")
Query QryVarianceByAdmDate(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,InCount:%String,OutCount:%String,CloseCount:%String,VarCount:%String,OutRatio:%String,CloseRatio:%String,VarRatio:%String")
{
}

ClassMethod QryVarianceByAdmDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Kill ^TMP($zn,$j,"VarianceByAdm")
	
	//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
	For AdmDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(AdmDateIndex,AdmDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set (CPWID,CPWStatus,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(CPWStatus="")||(CPWID="")
				
				Set Count=$i(^TMP($zn,$j,"VarianceByAdm"))                  //总人次
				Set Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID))            //路径入径人次=路径总人次
				Set:CPWStatus="O" Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID,"Out"))    //出径人次
				Set:CPWStatus="C" Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID,"Close"))  //关闭人次
				If OutReasonDR'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID,"OutReason",OutReasonDR))  //出径原因人次
				}
				
				Set SubID="",IsVariance=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID,"VarReason",VarReasonDR))  //变异原因数量
					Set IsVariance="Y"
				}
				If IsVariance'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByAdm",CPWID,"Variance"))  //发生变异人次
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarianceByAdm"))
	Quit:Count<1 $$$OK
	
	Set (InCountA,OutCountA,CloseCountA,VarCountA)=0
	Set CPWID=0
	For {
		Set CPWID=$o(^TMP($zn,$j,"VarianceByAdm",CPWID))
		Quit:CPWID=""
		
		Set CPWDesc=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
		}
		Continue:CPWDesc=""
		
		Set InCount=+$g(^TMP($zn,$j,"VarianceByAdm",CPWID))
		Set OutCount=+$g(^TMP($zn,$j,"VarianceByAdm",CPWID,"Out"))
		Set CloseCount=+$g(^TMP($zn,$j,"VarianceByAdm",CPWID,"Close"))
		Set VarCount=+$g(^TMP($zn,$j,"VarianceByAdm",CPWID,"Variance"))
		If InCount="" {
			Set OutRatio="0.00%"
			Set CloseRatio="0.00%"
			Set VarRatio="0.00%"
		}Else{
			Set OutRatio=$fn((OutCount/InCount)*100,"",2)_"%"
			Set CloseRatio=$fn((CloseCount/InCount)*100,"",2)_"%"
			Set VarRatio=$fn((VarCount/InCount)*100,"",2)_"%"
		}
		
		Set InCountA=InCountA+InCount
		Set OutCountA=OutCountA+OutCount
		Set CloseCountA=CloseCountA+CloseCount
		Set VarCountA=VarCountA+VarCount
		
		Set Data=$lb(CPWID,CPWDesc,InCount,OutCount,CloseCount,VarCount,OutRatio,CloseRatio,VarRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If InCountA="" {
		Set OutRatioA="0.00%"
		Set CloseRatioA="0.00%"
		Set VarRatioA="0.00%"
	}Else{
		Set OutRatioA=$fn((OutCountA/InCountA)*100,"",2)_"%"
		Set CloseRatioA=$fn((CloseCountA/InCountA)*100,"",2)_"%"
		Set VarRatioA=$fn((VarCountA/InCountA)*100,"",2)_"%"
	}
	Set Data=$lb("0","合计",InCountA,OutCountA,CloseCountA,VarCountA,OutRatioA,CloseRatioA,VarRatioA)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"VarianceByAdm")

	Quit $$$OK
}

ClassMethod QryVarianceByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceByAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceByAdmDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  入径路径变异统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarianceByDischDate","2010-01-01","2010-10-29","","")
Query QryVarianceByDischDate(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,InCount:%String,OutCount:%String,CloseCount:%String,VarCount:%String,OutRatio:%String,CloseRatio:%String,VarRatio:%String")
{
}

ClassMethod QryVarianceByDischDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Kill ^TMP($zn,$j,"VarianceByDisch")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)  //add by zf 2012-07-06
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set (CPWID,CPWStatus,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(CPWStatus="")||(CPWID="")
				
				Set Count=$i(^TMP($zn,$j,"VarianceByDisch"))                  //总人次
				Set Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID))            //路径入径人次=路径总人次
				Set:CPWStatus="O" Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID,"Out"))    //出径人次
				Set:CPWStatus="C" Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID,"Close"))  //关闭人次
				If OutReasonDR'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID,"OutReason",OutReasonDR))  //出径原因人次
				}
				
				Set SubID="",IsVariance=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID,"VarReason",VarReasonDR))  //变异原因数量
					Set IsVariance="Y"
				}
				If IsVariance'="" {
					Set Count=$i(^TMP($zn,$j,"VarianceByDisch",CPWID,"Variance"))  //发生变异人次
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarianceByDisch"))
	Quit:Count<1 $$$OK
	
	Set (InCountA,OutCountA,CloseCountA,VarCountA)=0
	Set CPWID=0
	For {
		Set CPWID=$o(^TMP($zn,$j,"VarianceByDisch",CPWID))
		Quit:CPWID=""
		
		Set CPWDesc=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
		}
		Continue:CPWDesc=""
		
		Set InCount=+$g(^TMP($zn,$j,"VarianceByDisch",CPWID))
		Set OutCount=+$g(^TMP($zn,$j,"VarianceByDisch",CPWID,"Out"))
		Set CloseCount=+$g(^TMP($zn,$j,"VarianceByDisch",CPWID,"Close"))
		Set VarCount=+$g(^TMP($zn,$j,"VarianceByDisch",CPWID,"Variance"))
		If InCount="" {
			Set OutRatio="0.00%"
			Set CloseRatio="0.00%"
			Set VarRatio="0.00%"
		}Else{
			Set OutRatio=$fn((OutCount/InCount)*100,"",2)_"%"
			Set CloseRatio=$fn((CloseCount/InCount)*100,"",2)_"%"
			Set VarRatio=$fn((VarCount/InCount)*100,"",2)_"%"
		}
		
		Set InCountA=InCountA+InCount
		Set OutCountA=OutCountA+OutCount
		Set CloseCountA=CloseCountA+CloseCount
		Set VarCountA=VarCountA+VarCount
		
		Set Data=$lb(CPWID,CPWDesc,InCount,OutCount,CloseCount,VarCount,OutRatio,CloseRatio,VarRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If InCountA="" {
		Set OutRatioA="0.00%"
		Set CloseRatioA="0.00%"
		Set VarRatioA="0.00%"
	}Else{
		Set OutRatioA=$fn((OutCountA/InCountA)*100,"",2)_"%"
		Set CloseRatioA=$fn((CloseCountA/InCountA)*100,"",2)_"%"
		Set VarRatioA=$fn((VarCountA/InCountA)*100,"",2)_"%"
	}
	Set Data=$lb("0","合计",InCountA,OutCountA,CloseCountA,VarCountA,OutRatioA,CloseRatioA,VarRatioA)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"VarianceByDisch")

	Quit $$$OK
}

ClassMethod QryVarianceByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceByDischDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-09-10
/// Description:  入径路径出径原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryOutReasonByAdmDate",1,"2010-01-30","2010-10-30","","")
Query QryOutReasonByAdmDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryOutReasonByAdmDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"OutReasonByAdm")
	
	//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
	For AdmDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(AdmDateIndex,AdmDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set (CPWID,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(argCPWID'="")&&(CPWID'=argCPWID)
				
				Continue:OutReasonDR=""
				Set Count=$i(^TMP($zn,$j,"OutReasonByAdm"))
				Set Count=$i(^TMP($zn,$j,"OutReasonByAdm",OutReasonDR))  //出径原因数量
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"OutReasonByAdm"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"OutReasonByAdm",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"OutReasonByAdm",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"OutReasonByAdm")
	
	Quit $$$OK
}

ClassMethod QryOutReasonByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutReasonByAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutReasonByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutReasonByAdmDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-09-10
/// Description:  入径路径出径原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryOutReasonByDischDate",1,"2010-01-30","2010-10-30","","")
Query QryOutReasonByDischDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryOutReasonByDischDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"OutReasonByDisch")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set (CPWID,OutReasonDR)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					If $IsObject(objPathWay.CPWOutReasonDR){
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(argCPWID'="")&&(CPWID'=argCPWID)
				
				Continue:OutReasonDR=""
				Set Count=$i(^TMP($zn,$j,"OutReasonByDisch"))
				Set Count=$i(^TMP($zn,$j,"OutReasonByDisch",OutReasonDR))  //出径原因数量
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"OutReasonByDisch"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"OutReasonByDisch",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"OutReasonByDisch",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"OutReasonByDisch")
	
	Quit $$$OK
}

ClassMethod QryOutReasonByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutReasonByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutReasonByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutReasonByDischDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-09-10
/// Description:  入径路径变异原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarReasonByAdmDate","","2010-01-30","2010-10-30","","")
Query QryVarReasonByAdmDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryVarReasonByAdmDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"VarReasonByAdm")
	
	//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
	For AdmDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(AdmDateIndex,AdmDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set CPWID=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(argCPWID'="")&&(CPWID'=argCPWID)
				
				Set SubID=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarReasonByAdm"))
					Set Count=$i(^TMP($zn,$j,"VarReasonByAdm",VarReasonDR))  //变异原因数量
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarReasonByAdm"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"VarReasonByAdm",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"VarReasonByAdm",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"VarReasonByAdm")
	
	Quit $$$OK
}

ClassMethod QryVarReasonByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonByAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonByAdmDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-09-10
/// Description:  入径路径变异原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarReasonByDischDate","","2010-01-30","2010-10-30","","")
Query QryVarReasonByDischDate(argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "ReasonDesc:%String,CategDesc:%String,ItemCount:%String,Ratio:%String")
{
}

ClassMethod QryVarReasonByDischDateExecute(ByRef qHandle As %Binary, argCPWID As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set:+argCPWID=0 argCPWID=""
	
	Kill ^TMP($zn,$j,"VarReasonByDisch")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set CPWID=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
				}
				If objPathWay'="" Do objPathWay.%Close()
				Continue:(argCPWID'="")&&(CPWID'=argCPWID)
				
				Set SubID=""
				For {
					Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
					Quit:SubID=""
					Set VarianceID=PathWayID_"||"_SubID
					Set VarReasonDR=""
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
					If $IsObject(objVariance) {
						Set VarUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VarUpdoFlag="Y"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
					}
					Continue:VarReasonDR=""
					Set Count=$i(^TMP($zn,$j,"VarReasonByDisch"))
					Set Count=$i(^TMP($zn,$j,"VarReasonByDisch",VarReasonDR))  //变异原因数量
				}
			}
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,"VarReasonByDisch"))
	Quit:Count<1 $$$OK
	
	Set ReasonID=0
	For {
		Set ReasonID=$o(^TMP($zn,$j,"VarReasonByDisch",ReasonID))
		Quit:ReasonID=""
		
		Set (ReasonDesc,CategDesc)=""
		Set objReason=##Class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		If $IsObject(objReason) {
			Set ReasonDesc=objReason.VRDesc
			If $IsObject(objReason.VRVarCategDR) {
				Set CategDesc=objReason.VRVarCategDR.VCDesc
			}
		}
		Continue:ReasonDesc=""
		
		Set ItemCount=+$g(^TMP($zn,$j,"VarReasonByDisch",ReasonID))
		Set Ratio=$fn((ItemCount/Count)*100,"",2)_"%"
		
		Set Data=$lb(ReasonDesc,CategDesc,ItemCount,Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"VarReasonByDisch")
	
	Quit $$$OK
}

ClassMethod QryVarReasonByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonByDischDateExecute ]
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

/// ************************************************************************
/// Creator：     zhufei
/// CreatDate：   2012-11-08
/// Description:  临床路径变异原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarAnalysisByDate",1,"2011-11-01","2012-11-08")
Query QryVarAnalysisByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "PathWayID:%String,CPWDR:%String,CPWDesc:%String,CPWTypeDR:%String,CPWTypeDesc:%String,EpDR:%String,EpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutCategDR:%String,OutCategDesc:%String,OutReasonDR:%String,OutReasonDesc:%String,Comments:%String,Paadm:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,VarianceID:%String,VarReasonDR:%String,VarReasonDesc:%String,VarCategDr:%String,VarCategDesc:%String,VarNote:%String,VarEpStepDR:%String,VarEpStepDesc:%String,VarUserDR:%String,VarUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVarAnalysisByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	
	If aDateType=1 {
		//^DHCMRi("CPW",0,"IndexInDate",61884,59220,1)
		For xInDate=aDateFrom:1:aDateTo {
			Set xInTime=0
			For {
				Set xInTime=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime))
				Quit:xInTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToValAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=2 {
		//^DHCMRi("CPW",0,"IndexOutDate",62538,85101,1)
		For xOutDate=aDateFrom:1:aDateTo {
			Set xOutTime=0
			For {
				Set xOutTime=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime))
				Quit:xOutTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToValAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=3 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
		For xAdmDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xAdmDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToValAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=4 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
		For xDischDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDischDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))	// zhaoyu 2013-03-28 Paadm->xPaadm
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToValAnalysis(xPathWayID)
				}
			}
		}
	}
	
	Quit $$$OK
	
BuildDataToValAnalysis(PathWayID)
	Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay)
	
	//************************************************************
	Set (CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc)=""
	Set (EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)=""
	Set (InDoctorDR,InDoctorDesc,InDate,InTime)=""
	Set (OutDoctorDR,OutDoctorDesc,OutDate,OutTime)=""
	Set (OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)=""
	//路径信息
	If $IsObject(objPathWay.CPWPathwayDR) {
		If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) {
			Set CPWDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
			If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR) {
				Set CPWTypeDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.%Id()
				Set CPWTypeDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.CLPTDesc
			}
		}
	}
	Quit:CPWDesc=""
	If $IsObject(objPathWay.CPWPathwayEpStepDR) {
		Set EpStepDR=objPathWay.CPWPathwayEpStepDR.%Id()
		Set EPStepDesc=objPathWay.CPWPathwayEpStepDR.CPWSDesc
		Set EpDR=objPathWay.CPWPathwayEpStepDR.CPWSParRef.%Id()
		Set EpDesc=objPathWay.CPWPathwayEpStepDR.CPWSParRef.EPDesc
	}
	Set Status=objPathWay.CPWStatus
	Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
	Set InDoctorDR=objPathWay.CPWInDoctorDR
	Set:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
	Set InDate=objPathWay.CPWInDate
	Set InTime=objPathWay.CPWInTime
	Set:InDate'="" InDate=$zd(+InDate,3)
	Set:InTime'="" InTime=$zt(+InTime,2)
	Set OutDoctorDR=objPathWay.CPWOutDoctorDR
	Set:OutDoctorDR'="" OutDoctorDesc=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
	Set OutDate=objPathWay.CPWOutDate
	Set OutTime=objPathWay.CPWOutTime
	Set:OutDate'="" OutDate=$zd(+OutDate,3)
	Set:OutTime'="" OutTime=$zt(+OutTime,2)
	If $IsObject(objPathWay.CPWOutReasonDR) {
		Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
		Set OutReasonDesc=objPathWay.CPWOutReasonDR.VRDesc
		
		If $IsObject(objPathWay.CPWOutReasonDR.VRVarCategDR) {
			Set OutCategDR=objPathWay.CPWOutReasonDR.VRVarCategDR.%Id()
			Set OutCategDesc=objPathWay.CPWOutReasonDR.VRVarCategDR.VCDesc
		}
	}
	Set Comments=objPathWay.CPWComments
	
	Set MRAdm=objPathWay.CPWMRADMDR
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	
	//患者信息
	Set (PatientID,PapmiNo,InMedicare,PatName)=""
	Set (Sex,Birthday,Age,PersonalID)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)=""
	Set (AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)=""
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
    If $IsObject(objPaadm)
    {
	    If $IsObject(objPaadm.PAADMPAPMIDR)
	    {
		    Set objPatient=objPaadm.PAADMPAPMIDR
		    Set PatientID=objPatient.%Id()
		    //Set PapmiNo=objPatient.PAPMINo
		    Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    Set PatName=objPatient.PAPMIName
		    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
		    Set Birthday=objPatient.PAPMIDOB
		    Set:Birthday'="" Birthda=$zd(Birthday,3)
			
		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”

		    Set PersonalID=objPatient.PAPMIID
		}
		
	   // Set AdmitDate=objPaadm.PAADMAdmDate
	   // Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DisDate=objPaadm.PAADMDischgDate
    	//Set DisTime=objPaadm.PAADMDischgTime
    	//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DisDate=$p(DischDateTime,"^",1)
		Set DisTime=$p(DischDateTime,"^",2)
	    If DisDate'="" {
		    Set AdmDays=DisDate-AdmitDate
	    } Else {
			Set AdmDays=+$h-AdmitDate
		}
	    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	    Set:DisDate'="" DisDate=$zd(DisDate,3)
	    Set:DisTime'="" DisTime=$zt(DisTime,1)
	    If $IsObject(objPaadm.PAADMDepCodeDR)
	    {
		    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
	    If $IsObject(objPaadm.PAADMCurrentWardDR)
	    {
		    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		}
		If $IsObject(objPaadm.PAADMCurrentRoomDR)
		{
			Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
		}
		If $IsObject(objPaadm.PAADMCurrentBedDR)
		{
			Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
		}
		If $IsObject(objPaadm.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
		}
		Set AdmStatus=objPaadm.PAADMVisitStatus
	}
	If objPaadm'="" Do objPaadm.%Close()
    Set InMedicare=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)
	
	//路径信息
	Set xData=$lb(PathWayID,CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc)
	Set xData=xData_$lb(EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)
	Set xData=xData_$lb(InDoctorDR,InDoctorDesc,InDate,InTime)
	Set xData=xData_$lb(OutDoctorDR,OutDoctorDesc,OutDate,OutTime)
	Set xData=xData_$lb(OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)
	
	//就诊信息
	Set xData=xData_$lb(Paadm,PatientID,PapmiNo,InMedicare,PatName)
	Set xData=xData_$lb(Sex,Birthday,Age,PersonalID)
	Set xData=xData_$lb(AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)
	Set xData=xData_$lb(AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)
	
	//*************************************************************
	
	Set SubID="",IsVariance="N"
	For {
		Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
		Quit:SubID=""
		Set VarianceID=PathWayID_"||"_SubID
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
		Continue:'$IsObject(objVariance)
		Continue:'$IsObject(objVariance.CPWVReasonDR)
		
		//变异信息
		Set (VarReasonDR,VarReasonDesc,VarCategDr,VarCategDesc,VarNote)=""
		Set (VarEpStepDR,VarEpStepDesc,VarUserDR,VarUserDesc)=""
		
		Set VarUpdoFlag=objVariance.CPWVUpdoFlag
		Continue:VarUpdoFlag="Y"
		Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
		Continue:VarReasonDR=""
		Set VarReasonDesc=objVariance.CPWVReasonDR.VRDesc
		If $IsObject(objVariance.CPWVReasonDR.VRVarCategDR) {
			Set VarCategDr=objVariance.CPWVReasonDR.VRVarCategDR.%Id()
			Set VarCategDesc=objVariance.CPWVReasonDR.VRVarCategDR.VCDesc
		}
		If $IsObject(objVariance.CPWVEpStepDR) {
			Set VarEpStepDR=objVariance.CPWVEpStepDR.%Id()
			Set VarEpStepDesc=objVariance.CPWVEpStepDR.CPWSDesc
		}
		Set VarUserDR=objVariance.CPWVUserDR
		Set VarUserDesc=$p($g(^SSU("SSUSR",+VarUserDR)),"^",2)
		Set VarNote=objVariance.CPWVNote
		
		Set IsVariance="Y"
		
		Set Data=xData_$lb(VarianceID,VarReasonDR,VarReasonDesc,VarCategDr,VarCategDesc,VarNote)
		Set Data=Data_$lb(VarEpStepDR,VarEpStepDesc,VarUserDR,VarUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit
}

ClassMethod QryVarAnalysisByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarAnalysisByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarAnalysisByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarAnalysisByDateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-11-14
/// Description:  临床路径出径原因统计分析
/// Input：       DateFrom(开始日期),DateTo(结束日期)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryOutAnalysisByDate",1,"2011-11-01","2012-11-08")
Query QryOutAnalysisByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "PathWayID:%String,CPWDR:%String,CPWDesc:%String,CPWTypeDR:%String,CPWTypeDesc:%String,EpDR:%String,EpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutCategDR:%String,OutCategDesc:%String,OutReasonDR:%String,OutReasonDesc:%String,Comments:%String,Paadm:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String") [ SqlProc ]
{
}

ClassMethod QryOutAnalysisByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	
	If aDateType=1 {
		//^DHCMRi("CPW",0,"IndexInDate",61884,59220,1)
		For xInDate=aDateFrom:1:aDateTo {
			Set xInTime=0
			For {
				Set xInTime=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime))
				Quit:xInTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToOutAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=2 {
		//^DHCMRi("CPW",0,"IndexOutDate",62538,85101,1)
		For xOutDate=aDateFrom:1:aDateTo {
			Set xOutTime=0
			For {
				Set xOutTime=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime))
				Quit:xOutTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToOutAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=3 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
		For xAdmDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xAdmDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToOutAnalysis(xPathWayID)
				}
			}
		}
	} ElseIf aDateType=4 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
		For xDischDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDischDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))	// zhaoyu 2013-03-28 Paadm->xPaadm
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToOutAnalysis(xPathWayID)
				}
			}
		}
	}
	
	Quit $$$OK
	
BuildDataToOutAnalysis(PathWayID)
	Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay)
	Quit:objPathWay.CPWStatus'="O"
	
	Set (CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc)=""
	Set (EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)=""
	Set (InDoctorDR,InDoctorDesc,InDate,InTime)=""
	Set (OutDoctorDR,OutDoctorDesc,OutDate,OutTime)=""
	Set (OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)=""
	//路径信息
	If $IsObject(objPathWay.CPWPathwayDR) {
		If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) {
			Set CPWDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
			If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR) {
				Set CPWTypeDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.%Id()
				Set CPWTypeDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.CLPTDesc
			}
		}
	}
	Quit:CPWDesc=""
	If $IsObject(objPathWay.CPWPathwayEpStepDR) {
		Set EpStepDR=objPathWay.CPWPathwayEpStepDR.%Id()
		Set EPStepDesc=objPathWay.CPWPathwayEpStepDR.CPWSDesc
		Set EpDR=objPathWay.CPWPathwayEpStepDR.CPWSParRef.%Id()
		Set EpDesc=objPathWay.CPWPathwayEpStepDR.CPWSParRef.EPDesc
	}
	Set Status=objPathWay.CPWStatus
	Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
	Set InDoctorDR=objPathWay.CPWInDoctorDR
	Set:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
	Set InDate=objPathWay.CPWInDate
	Set InTime=objPathWay.CPWInTime
	Set:InDate'="" InDate=$zd(+InDate,3)
	Set:InTime'="" InTime=$zt(+InTime,2)
	Set OutDoctorDR=objPathWay.CPWOutDoctorDR
	Set:OutDoctorDR'="" OutDoctorDesc=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
	Set OutDate=objPathWay.CPWOutDate
	Set OutTime=objPathWay.CPWOutTime
	Set:OutDate'="" OutDate=$zd(+OutDate,3)
	Set:OutTime'="" OutTime=$zt(+OutTime,2)
	If $IsObject(objPathWay.CPWOutReasonDR) {
		Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
		Set OutReasonDesc=objPathWay.CPWOutReasonDR.VRDesc
		
		If $IsObject(objPathWay.CPWOutReasonDR.VRVarCategDR) {
			Set OutCategDR=objPathWay.CPWOutReasonDR.VRVarCategDR.%Id()
			Set OutCategDesc=objPathWay.CPWOutReasonDR.VRVarCategDR.VCDesc
		}
	}
	Set Comments=objPathWay.CPWComments
	
	Set MRAdm=objPathWay.CPWMRADMDR
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	
	//患者信息
	Set (PatientID,PapmiNo,InMedicare,PatName)=""
	Set (Sex,Birthday,Age,PersonalID)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)=""
	Set (AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)=""
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
    If $IsObject(objPaadm)
    {
	    If $IsObject(objPaadm.PAADMPAPMIDR)
	    {
		    Set objPatient=objPaadm.PAADMPAPMIDR
		    Set PatientID=objPatient.%Id()
		    //Set PapmiNo=objPatient.PAPMINo
		    Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    Set PatName=objPatient.PAPMIName
		    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
		    Set Birthday=objPatient.PAPMIDOB
		    Set:Birthday'="" Birthda=$zd(Birthday,3)
			
		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”

		    Set PersonalID=objPatient.PAPMIID
		}
		
	    //Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DisDate=objPaadm.PAADMDischgDate
    	//Set DisTime=objPaadm.PAADMDischgTime
    	//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DisDate=$p(DischDateTime,"^",1)
		Set DisTime=$p(DischDateTime,"^",2)
	    If DisDate'="" {
		    Set AdmDays=DisDate-AdmitDate
	    } Else {
			Set AdmDays=+$h-AdmitDate
		}
	    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	    Set:DisDate'="" DisDate=$zd(DisDate,3)
	    Set:DisTime'="" DisTime=$zt(DisTime,1)
	    If $IsObject(objPaadm.PAADMDepCodeDR)
	    {
		    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
	    If $IsObject(objPaadm.PAADMCurrentWardDR)
	    {
		    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		}
		If $IsObject(objPaadm.PAADMCurrentRoomDR)
		{
			Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
		}
		If $IsObject(objPaadm.PAADMCurrentBedDR)
		{
			Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
		}
		If $IsObject(objPaadm.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
		}
		Set AdmStatus=objPaadm.PAADMVisitStatus
	}
	If objPaadm'="" Do objPaadm.%Close()
    Set InMedicare=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)
	
	//路径信息
	Set Data=$lb(PathWayID,CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc)
	Set Data=Data_$lb(EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)
	Set Data=Data_$lb(InDoctorDR,InDoctorDesc,InDate,InTime)
	Set Data=Data_$lb(OutDoctorDR,OutDoctorDesc,OutDate,OutTime)
	Set Data=Data_$lb(OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)
	
	//就诊信息
	Set Data=Data_$lb(Paadm,PatientID,PapmiNo,InMedicare,PatName)
	Set Data=Data_$lb(Sex,Birthday,Age,PersonalID)
	Set Data=Data_$lb(AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)
	Set Data=Data_$lb(AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryOutAnalysisByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutAnalysisByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutAnalysisByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutAnalysisByDateExecute ]
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

/// ************************************************************************
/// Creator：     zhaoyu
/// CreatDate：   2013-03-15
/// Description:  临床路径 变异&出径 统计分析
/// Input：       DateType(日期类型),DateFrom(开始日期),DateTo(结束日期)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.VarianceAnalysis","QryVarOutAnalysisByDate",1,"2012-01-01","2013-03-15")
Query QryVarOutAnalysisByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, argCPWInLoc As %String, argCPWDesc As %String) As %Query(ROWSPEC = "PathWayID:%String,CPWDR:%String,CPWDesc:%String,CPWTypeDR:%String,CPWTypeDesc:%String,CPWInLoc:%String,EpDR:%String,EpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutCategDR:%String,OutCategDesc:%String,OutReasonDR:%String,OutReasonDesc:%String,Comments:%String,Paadm:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,VarianceID:%String,VarReasonDR:%String,VarReasonDesc:%String,VarCategDr:%String,VarCategDesc:%String,VarNote:%String,VarEpStepDR:%String,VarEpStepDesc:%String,VarUserDR:%String,VarUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVarOutAnalysisByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, argCPWInLoc As %String, argCPWDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	//, argCPWInLoc As %String, argCPWDesc As %String
	Set:'$d(argCPWInLoc) argCPWInLoc=""
	Set:'$d(argCPWDesc) argCPWDesc=""
	
	If (aDateType=1){
		//^DHCMRi("CPW",0,"IndexInDate",61884,59220,1)
		For xInDate=aDateFrom:1:aDateTo {
			Set xInTime=0
			For {
				Set xInTime=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime))
				Quit:xInTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexInDate",xInDate,xInTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToVarOutAnalysis(xPathWayID,argCPWInLoc,argCPWDesc)
				}
			}
		}
	}ElseIf (aDateType=2){
		//^DHCMRi("CPW",0,"IndexOutDate",62538,85101,1)
		For xOutDate=aDateFrom:1:aDateTo {
			Set xOutTime=0
			For {
				Set xOutTime=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime))
				Quit:xOutTime=""
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexOutDate",xOutDate,xOutTime,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToVarOutAnalysis(xPathWayID,argCPWInLoc,argCPWDesc)
				}
			}
		}
	}ElseIf (aDateType=3){
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
		For xAdmDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xAdmDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(xPaadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToVarOutAnalysis(xPathWayID,argCPWInLoc,argCPWDesc)
				}
			}
		}
	} ElseIf aDateType=4 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
		For xDischDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDischDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(xPaadm)
				Continue:MRAdm=""
				
				Set xPathWayID=0
				For {
					Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
					Quit:xPathWayID=""
					Do BuildDataToVarOutAnalysis(xPathWayID,argCPWInLoc,argCPWDesc)
				}
			}
		}
	}
	
	Quit $$$OK
	
BuildDataToVarOutAnalysis(PathWayID,argCPWInLoc,argCPWDesc)
	Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay)
	//************************************************************
	Set (CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc)=""
	Set (EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)=""
	Set (InDoctorDR,InDoctorDesc,InDate,InTime)=""
	Set (OutDoctorDR,OutDoctorDesc,OutDate,OutTime)=""
	Set (OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)=""
	//路径信息
	If $IsObject(objPathWay.CPWPathwayDR) {
		If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) {
			Set CPWDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
			If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR) {
				Set CPWTypeDR=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.%Id()
				Set CPWTypeDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDCPWTypeDR.CLPTDesc
			}
		}
	}
	Quit:(CPWDesc="")
	If $IsObject(objPathWay.CPWPathwayEpStepDR) {
		Set EpStepDR=objPathWay.CPWPathwayEpStepDR.%Id()
		Set EPStepDesc=objPathWay.CPWPathwayEpStepDR.CPWSDesc
		Set EpDR=objPathWay.CPWPathwayEpStepDR.CPWSParRef.%Id()
		Set EpDesc=objPathWay.CPWPathwayEpStepDR.CPWSParRef.EPDesc
	}
	Set Status=objPathWay.CPWStatus
	Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
	Set InDoctorDR=objPathWay.CPWInDoctorDR
	Set:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
	Set InDate=objPathWay.CPWInDate
	Set InTime=objPathWay.CPWInTime
	Set:InDate'="" InDate=$zd(+InDate,3)
	Set:InTime'="" InTime=$zt(+InTime,2)
	Set OutDoctorDR=objPathWay.CPWOutDoctorDR
	Set:OutDoctorDR'="" OutDoctorDesc=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
	Set OutDate=objPathWay.CPWOutDate
	Set OutTime=objPathWay.CPWOutTime
	Set:OutDate'="" OutDate=$zd(+OutDate,3)
	Set:OutTime'="" OutTime=$zt(+OutTime,2)
	If $IsObject(objPathWay.CPWOutReasonDR) {
		Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
		Set OutReasonDesc=objPathWay.CPWOutReasonDR.VRDesc
		If $IsObject(objPathWay.CPWOutReasonDR.VRVarCategDR) {
			Set OutCategDR=objPathWay.CPWOutReasonDR.VRVarCategDR.%Id()
			Set OutCategDesc=objPathWay.CPWOutReasonDR.VRVarCategDR.VCDesc
		}
	}
	Set Comments=objPathWay.CPWComments
	
	Set MRAdm=objPathWay.CPWMRADMDR
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	Set AdmInfo=$g(^PAADM(Paadm))
	Quit:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	Quit:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	//患者信息
	Set (PatientID,PapmiNo,InMedicare,PatName)=""
	Set (Sex,Birthday,Age,PersonalID)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)=""
	Set (AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)=""
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
    If $IsObject(objPaadm)
    {
	    If $IsObject(objPaadm.PAADMPAPMIDR)
	    {
		    Set objPatient=objPaadm.PAADMPAPMIDR
		    Set PatientID=objPatient.%Id()
		    //Set PapmiNo=objPatient.PAPMINo
		    Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    Set PatName=objPatient.PAPMIName
		    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
		    Set Birthday=objPatient.PAPMIDOB
		    Set:Birthday'="" Birthda=$zd(Birthday,3)
			
		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”

		    Set PersonalID=objPatient.PAPMIID
		}
		//Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	   
	    //Set DisDate=objPaadm.PAADMDischgDate
    	//Set DisTime=objPaadm.PAADMDischgTime
   		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DisDate=$p(DischDateTime,"^",1)
		Set DisTime=$p(DischDateTime,"^",2)
	    If DisDate'="" {
		    Set AdmDays=DisDate-AdmitDate
	    } Else {
			Set AdmDays=+$h-AdmitDate
		}
	    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	    Set:DisDate'="" DisDate=$zd(DisDate,3)
	    Set:DisTime'="" DisTime=$zt(DisTime,1)
	    If $IsObject(objPaadm.PAADMDepCodeDR)
	    {
		    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
	    If $IsObject(objPaadm.PAADMCurrentWardDR)
	    {
		    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		}
		If $IsObject(objPaadm.PAADMCurrentRoomDR)
		{
			Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
		}
		If $IsObject(objPaadm.PAADMCurrentBedDR)
		{
			Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
		}
		If $IsObject(objPaadm.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
		}
		Set AdmStatus=objPaadm.PAADMVisitStatus
	}
	If objPaadm'="" Do objPaadm.%Close()
		// zhaoyu 2013-05-07 病案号
    //Set InMedicare=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)	// Old
    //Set InMedicare=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(Paadm)	// New
    // 取路径科室，若路径科室为空，取就诊科室
	Set CPWInLoc=objPathWay.CPWInLoc
	If (CPWInLoc'=""){
		Set CPWInLoc=$p($g(^CTLOC(CPWInLoc)),"^",2)
		Set:$p(CPWInLoc,"-",2)'="" CPWInLoc=$p(CPWInLoc,"-",2)
	}
	Set:CPWInLoc="" CPWInLoc=AdmLoc
	Quit:CPWInLoc=""
	// 过滤科室、病种
	Quit:(argCPWDesc'="")&&(argCPWDesc'=CPWDesc)
	Quit:(argCPWInLoc'="")&&(argCPWInLoc'=CPWInLoc)
	//路径信息
	Set xData=$lb(PathWayID,CPWDR,CPWDesc,CPWTypeDR,CPWTypeDesc,CPWInLoc)
	Set xData=xData_$lb(EpDR,EpDesc,EpStepDR,EPStepDesc,Status,StatusDesc)
	Set xData=xData_$lb(InDoctorDR,InDoctorDesc,InDate,InTime)
	Set xData=xData_$lb(OutDoctorDR,OutDoctorDesc,OutDate,OutTime)
	Set xData=xData_$lb(OutCategDR,OutCategDesc,OutReasonDR,OutReasonDesc,Comments)
	//就诊信息
	Set xData=xData_$lb(Paadm,PatientID,PapmiNo,InMedicare,PatName)
	Set xData=xData_$lb(Sex,Birthday,Age,PersonalID)
	Set xData=xData_$lb(AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc)
	Set xData=xData_$lb(AdmWard,AdmRoom,AdmBed,AdmDoc,AdmStatus,AdmDays)
	//"PathWayID:%String,CPWDR:%String,CPWDesc:%String,CPWTypeDR:%String,CPWTypeDesc:%String,CPWInLoc:%String,EpDR:%String,EpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutCategDR:%String,OutCategDesc:%String,OutReasonDR:%String,OutReasonDesc:%String,Comments:%String,Paadm:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,VarianceID:%String,VarReasonDR:%String,VarReasonDesc:%String,VarCategDr:%String,VarCategDesc:%String,VarNote:%String,VarEpStepDR:%String,VarEpStepDesc:%String,VarUserDR:%String,VarUserDesc:%String"
	//*************************************************************
	Set SubID="",IsVariance="N"
	//Set flag=$s(Status'="O":-1,1:0)
	Set flag=0	// zhaoyu 2013-05-07
	For {
		Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
		//Quit:SubID=""
		Quit:(flag'=0)&&(SubID="")
		//变异信息
		Set (VarReasonDR,VarReasonDesc,VarCategDr,VarCategDesc,VarNote)=""
		Set (VarEpStepDR,VarEpStepDesc,VarUserDR,VarUserDesc)=""
		
		If (SubID="")&&(flag=0){
			Set flag=1
			Set VarianceID="其它"
		}Else{
			Set flag=2
			Set VarianceID=PathWayID_"||"_SubID
			Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
			//Continue:'$IsObject(objVariance)
			//Continue:'$IsObject(objVariance.CPWVReasonDR)
			Set flgVar=0
			If $IsObject(objVariance) {
				Set VarUpdoFlag=objVariance.CPWVUpdoFlag
				Set:($IsObject(objVariance.CPWVReasonDR)&&(VarUpdoFlag'="Y")) flgVar=1
			}
			If (flgVar=0) {
				Set VarianceID="其它"
			} Else {
			//If ($IsObject(objVariance))&&($IsObject(objVariance.CPWVReasonDR)){
				//Set VarUpdoFlag=objVariance.CPWVUpdoFlag
				//Continue:VarUpdoFlag="Y"
				Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
				//Continue:VarReasonDR=""
				Set VarReasonDesc=objVariance.CPWVReasonDR.VRDesc
				If $IsObject(objVariance.CPWVReasonDR.VRVarCategDR) {
					Set VarCategDr=objVariance.CPWVReasonDR.VRVarCategDR.%Id()
					Set VarCategDesc=objVariance.CPWVReasonDR.VRVarCategDR.VCDesc
				}
				If $IsObject(objVariance.CPWVEpStepDR) {
					Set VarEpStepDR=objVariance.CPWVEpStepDR.%Id()
					Set VarEpStepDesc=objVariance.CPWVEpStepDR.CPWSDesc
				}
				Set VarUserDR=objVariance.CPWVUserDR
				Set VarUserDesc=$p($g(^SSU("SSUSR",+VarUserDR)),"^",2)
				Set VarNote=objVariance.CPWVNote
				
				Set IsVariance="Y"
			}
		}
		Set Data=xData_$lb(VarianceID,VarReasonDR,VarReasonDesc,VarCategDr,VarCategDesc,VarNote)
		Set Data=Data_$lb(VarEpStepDR,VarEpStepDesc,VarUserDR,VarUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit
}

ClassMethod QryVarOutAnalysisByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarOutAnalysisByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarOutAnalysisByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarOutAnalysisByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
