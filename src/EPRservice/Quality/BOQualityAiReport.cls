/// 内涵质控报表
Class EPRservice.Quality.BOQualityAiReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 内涵质控汇总
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityAiReport","getAiSunnaryOut","A","2017-12-03","2022-11-30","96,98,99,100,102,103,104,105,106,107,108,109,110,1","N0002,N0001","E","")
Query getAiSunnaryOut(AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %Text = "", APoolDRs As %Text = "", AStatus As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "EpisodeID,AdmLocID,LocDesc,PoolID,Title,status") [ SqlProc ]
{
}

ClassMethod getAiSunnaryOutExecute(ByRef qHandle As %Binary, AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %Text = "", APoolDRs As %Text = "", AStatus As %String = "", AHospitalID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(APoolDRs="") $$$OK
	
	k ^CacheTemp("EPRQuality","AiSunnary",repid)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AlocID,",")
	
	s:(AdmFlag="") AdmFlag="A"
	
	
	s ListPoolDR = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(APoolDRs,",")
	q:($listlength(ListPoolDR) = 0) 
	for Tmpdate=StartDate:1:EndDate{
		s EpisodeID=""
		for {
			s:(AdmFlag="A") EpisodeID= $o(^PAADMi("PAADM_AdmDate",Tmpdate,EpisodeID))
			s:(AdmFlag="D") EpisodeID=$o(^PAADMi("DischDate",Tmpdate,EpisodeID) )
			
			q:(EpisodeID="")
			
			s TmpobjPaAdm = $g(^PAADM(+EpisodeID))
	        continue:(TmpobjPaAdm = "") 
	        s AdmStatus=$P(TmpobjPaAdm,"^",20)
	        continue:(AdmFlag'=AdmStatus)
			s TmpAdmLocID = $p(TmpobjPaAdm,"^",4)
	        continue:(TmpAdmLocID = "") 
	        
	        continue:($listlength(lstLocID) > 0)&&($listfind(lstLocID,TmpAdmLocID) = 0) 
	        s HospitalDR = $p(^CTLOC(+TmpAdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
	         						
			s LocDesc = $p($g(^CTLOC(+TmpAdmLocID)),"^",2) //add
			for i = 1:1:$listlength(ListPoolDR)
			{	          
			   s PoolDR = $listget(ListPoolDR,i)
			   q:(PoolDR = "")  
			   s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)			   
			   q:objPool=""
			   s Title=objPool.Title
			   s EntryID = ""
			   s Flag2=0
			   for {
		             
				    s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolDR,EntryID))
				    q:EntryID=""
			       	        
				    continue:Flag2>=1
				    s Flag2=Flag2+1
				    
				    s ParRef=""
				    for {		     
					s ParRef=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeID," "_AdmFlag,ParRef))
					q:ParRef=""

					s status=""
					for {			
		                		s status=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",ParRef," "_EntryID,status))
						q:status=""
						continue:(AStatus'="")&&(AStatus'=$tr(status," ",""))
						s detailid=""
						for{
							s detailid=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",ParRef," "_EntryID,status,detailid))
							q:detailid=""
							s title=$lg($g(^DHCEPRQ.QualityAiLogD(ParRef,"Details",detailid)),4)
							s ^CacheTemp("EPRQuality","AiSunnary",repid,TmpAdmLocID,Title,EpisodeID)=$lb(EpisodeID,TmpAdmLocID,LocDesc,PoolDR,Title,status)	
						}
				    }
					}

				
				}
			}
		}
	}
	s tmpAdmLocID=""
	for{
		s tmpAdmLocID=$o(^CacheTemp("EPRQuality","AiSunnary",repid,tmpAdmLocID))
		q:(tmpAdmLocID="")
		s temTitle=""
		for{
			s temTitle=$o(^CacheTemp("EPRQuality","AiSunnary",repid,tmpAdmLocID,temTitle))
			q:(temTitle="")
		   	s tmpEpisodeID=""
		   	for{
			   	s tmpEpisodeID=$o(^CacheTemp("EPRQuality","AiSunnary",repid,tmpAdmLocID,temTitle,tmpEpisodeID))
				q:(tmpEpisodeID="")
			     s Data = $g(^CacheTemp("EPRQuality","AiSunnary",repid,tmpAdmLocID,temTitle,tmpEpisodeID))
			     s ^CacheTemp(repid,ind) = Data
			     s ind = ind + 1	
		   	}
		}
	}
	k ^CacheTemp("EPRQuality","AiSunnary",repid)
	Quit $$$OK
}

ClassMethod getAiSunnaryOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getAiSunnaryOutExecute ]
{
    Set uid=$LIST(qHandle,2)
 	Kill ^CacheTemp(uid) 	

	Quit $$$OK
}

ClassMethod getAiSunnaryOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getAiSunnaryOutExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

/// 内涵质控明细
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityAiReport","getAiSunnaryDetail","","2018-01-01","2023-01-01","93,95","N0001","E")
Query getAiSunnaryDetail(AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %Text = "", APoolDRs As %Text = "", AStatus As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "AEpisodeID,RegNo,MRNo,Name,Gender,AdmLocID,LocDesc,AdmWardID,WardDesc,DoctorDesc,AdmitDate,DischDate,AEntryID,ATitle") [ SqlProc ]
{
}

ClassMethod getAiSunnaryDetailExecute(ByRef qHandle As %Binary, AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %Text = "", APoolDRs As %Text = "", AStatus As %String = "", AHospitalID As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(APoolDRs="") $$$OK
	
	k ^CacheTemp("EPRQuality","AiDeatil",repid)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AlocID,",")
	
	s:(AdmFlag="") AdmFlag="A"
	
	
	s ListPoolDR = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(APoolDRs,",")
	q:($listlength(ListPoolDR) = 0) 
	for Tmpdate=StartDate:1:EndDate{
		s EpisodeID=""
		for {
			s:(AdmFlag="A") EpisodeID= $o(^PAADMi("PAADM_AdmDate",Tmpdate,EpisodeID))
			s:(AdmFlag="D") EpisodeID=$o(^PAADMi("DischDate",Tmpdate,EpisodeID) )
			
			q:(EpisodeID="")
			
			s TmpobjPaAdm = $g(^PAADM(+EpisodeID))
	        continue:(TmpobjPaAdm = "") 
			s TmpAdmLocID = $p(TmpobjPaAdm,"^",4)
	        continue:(TmpAdmLocID = "") 
	        
	        continue:($listlength(lstLocID) > 0)&&($listfind(lstLocID,TmpAdmLocID) = 0) 
	        s HospitalDR = $p(^CTLOC(+TmpAdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
	         						
			s LocDesc = $p($g(^CTLOC(+TmpAdmLocID)),"^",2) //add
			for i = 1:1:$listlength(ListPoolDR)
			{	          
			   s PoolDR = $listget(ListPoolDR,i)
			   q:(PoolDR = "")  
			   /*s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)			   
			   q:objPool=""
			   s Title=objPool.Title*/
			   s EntryID = ""
			   s Flag2=0
			   for {
		             
				    s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolDR,EntryID))
				    q:EntryID=""
			       	        
				    continue:Flag2>=1
				    s Flag2=Flag2+1
				    s num=0
				    s ParRef=""
				    for {		     
					s ParRef=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeID," "_AdmFlag,ParRef))
					q:ParRef=""
					s status=""
					for {			
		                		s status=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",ParRef," "_EntryID,status))
						q:status=""
						continue:(AStatus'="")&&(AStatus'=$tr(status," ",""))
						s:(status["U") Status="触犯"
						s:(status["R") Status="已修复"
						s detailid=""
						for{
							s detailid=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",ParRef," "_EntryID,status,detailid))
							q:detailid=""
							s title=$lg($g(^DHCEPRQ.QualityAiLogD(ParRef,"Details",detailid)),4)
							s flag=..getAiSunnaryDetailList(EpisodeID,EntryID,title,status,num,repid)
							s num=num+1
						}
				      }
					}
				}
			}
		}
	}
	// 排序
	s tmpWard = ""
	for {
		
		s tmpWard = $o(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard))
		q:(tmpWard = "")
		
		s tmpDoctor = ""
		for {
			s tmpDoctor = $o(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard,tmpDoctor))
			q:(tmpDoctor = "")
			
			s tmpAdmID = ""
			for {
				s tmpAdmID = $o(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard,tmpDoctor,tmpAdmID))
				q:(tmpAdmID = "")
				s temEntryID=""
				for{
					s temEntryID=$o(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard,tmpDoctor,tmpAdmID,temEntryID))
					q:(temEntryID="")
				   	s num=""
				   	for{
					   	s num=$o(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard,tmpDoctor,tmpAdmID,temEntryID,num))
						q:(num="")
					     s Data = $g(^CacheTemp("EPRQuality","AiDeatil",repid,tmpWard,tmpDoctor,tmpAdmID,temEntryID,num))
					     s ^CacheTemp(repid,ind) = Data
					     s ind = ind + 1	
				   	}
				}
			}
		}
	}
	k ^CacheTemp("EPRQuality","AiDeatil",repid)
	Quit $$$OK
}

ClassMethod getAiSunnaryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getAiSunnaryDetailExecute ]
{
    Set uid=$LIST(qHandle,2)
 	Kill ^CacheTemp(uid) 	

	Quit $$$OK
}

ClassMethod getAiSunnaryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getAiSunnaryDetailExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

/// w ##class(EPRservice.Quality.BOQualityReport).EpisodeIDRuleSearchDataNew(6,95,122,61178,63023,547,"F",6,18,"住院患者至少30天1次阶段小结(2天宽限),请及时书写!")
ClassMethod getAiSunnaryDetailList(AEpisodeID As %String, AEntryID As %String, ATitle As %String, AStauts As %String, Anum As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	

	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret

    s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	
	s AdmWardID = $p(objPaAdm,"^",70)				
	q:(AdmWardID="") ret

	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"	
	
    s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
    s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	//s Grade = $p($list(objResult,8),"@",1)
	//s Score = 100 - (+$list(objResult,2))

    s AdmitDate = $p($g(objPaAdm),"^",6)
    s DischDate = $p($g(objPaAdm),"^",17)

     // 以下取患者基本信息和就诊信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	s MRNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s:(AdmitDate'="") AdmitDate = $zd(AdmitDate,3)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")

	s ^CacheTemp("EPRQuality","AiDeatil",AUniqueKey,LocDesc,DoctorDesc,AEpisodeID,AEntryID,Anum) = $lb(AEpisodeID,RegNo,MRNo,Name,Gender,AdmLocID,LocDesc,AdmWardID,WardDesc,DoctorDesc,AdmitDate,DischDate,AEntryID,ATitle)
	
	s ret = 1
	q ret
}

/// 内涵条目触犯报表（测试）
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetNLPQualityResultset","1807,1839","","2021-01-01","2021-01-01")
Query GetNLPQualityResultset(EntryIDs As %Text, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, AHospitalID As %String = "") As %Query(ROWSPEC = "MedicareNo,PAADMRowID,RegNo,PoolDR,Title,ExpressionResult") [ SqlProc ]
{
}

ClassMethod GetNLPQualityResultsetExecute(ByRef qHandle As %Binary, EntryIDs As %Text, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	s AStartDate=$tr(AStartDate," "),AEndDate=$tr(AEndDate," "),EntryIDs=$tr(EntryIDs," "),EntryIDs=$tr(EntryIDs," ")
	q:(AStartDate="")||(AEndDate="")||(EntryIDs="") $$$OK
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	s ^CacheTempResponseFlag(repid) = 1
	s AStartDate=$zdh(AStartDate,3),AEndDate=$zdh(AEndDate,3)
	for i=AStartDate:1:AEndDate
	{
		s PAADMRowID = ""
		for
		{	
			s PAADMRowID = $o(^PAADMi("DischDate",i,PAADMRowID))
			q:(PAADMRowID = "")
			s mCurrRow=$g(^PAADM(PAADMRowID))
			s AdmType=$P(mCurrRow,"^",2)
			continue:AdmType'="I"
			s LocDR = ##class(EPRservice.Quality.DataGather.AdmInfo).GetAdmLoc(PAADMRowID)
			continue:($listlength(lstLocID) > 0)&&($listfind(lstLocID,LocDR) = 0) 
			
			s HospitalDR = $p(^CTLOC(+LocDR),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s PAPMIDR = $p(mCurrRow,"^",1)
			s RegNo = $p($g(^PAPER(+PAPMIDR,"PAT",1)),"^",1)
			s MedicareNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(PAADMRowID,"")
			for n=1:1:$l(EntryIDs,",")
			{
				s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId($p(EntryIDs,",",n))  
				continue:(objEntry = "")
				s EntryConditionDR = objEntry.EntryConditionDR 
			    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
			    {
			       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(PAADMRowID,EntryConditionDR)
			       continue:(flag '= "1")  
			    }
				s ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(PAADMRowID,$p(EntryIDs,",",n),"",repid)
				q:(^CacheTempResponseFlag(repid)=0)
				continue:($e(ExpressionResult,1,2)'=-1)
				s PoolObj = ##class(EPRmeta.Quality.QualityPool).%OpenId(objEntry.PoolDR)
				s Title = PoolObj.Title
				s ^CacheTemp(repid,ind) = $lb(MedicareNo,PAADMRowID,RegNo,objEntry.PoolDR,Title,ExpressionResult)
				s ind = ind + 1	
			}
			q:(^CacheTempResponseFlag(repid)=0)
		}
		q:(^CacheTempResponseFlag(repid)=0)
	}	
	K ^CacheTempResponseFlag(repid)
	Quit $$$OK
}

ClassMethod GetNLPQualityResultsetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNLPQualityResultsetExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
	
	Quit $$$OK
}

ClassMethod GetNLPQualityResultsetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNLPQualityResultsetExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
