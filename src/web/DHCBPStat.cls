Import SQLUser

Class web.DHCBPStat Extends %RegisteredObject
{

/// w ##class(web.DHCBPStat).FindBpInquiry("15",7,$h-20,$h)
/// w ##class(web.DHCBPStat).FindBpInquiry("15",105,"2017-4-1","2017-4-11","")
/// bpciId:统计项目 dateForWardType:I入病区时间,空为在病区时间 subType透析类型：H血透、P腹透
ClassMethod FindBpInquiry(ctlocIdStr, bpciId, inquiryFromDate = "", inquiryToDate = "", dateForWardType = "", subType = "H") As %String
{
	q:bpciId="" -11
	k ^DHCBPInquiry(+bpciId),^DHCBPInquiry(bpciId,"F")
	s sumStr="",patSum=0
	s ^DHCBPCInquiry(+bpciId,"count")=0
	s leaveCount=0,leaveDayPos=0,CirculVelocityPos=0,ScorePos=0,ScoreCount=0 //计算APPCHEII平均分数数量
	//  w ##class(web.DHCBPStat).FindBpInquiry("56^2166",6,"2014-3-1","2014-3-31")
	i 1=1 d  //$d(^DHCBPPara(0,"Ctloc",ctlocIdStr)) d
		.;若在科室模板中已配置
		.s retStr=$$FindBpInquiryByWardId(ctlocIdStr,bpciId,inquiryFromDate,inquiryToDate)
	e  d
		.;科室模板中未配置,认为是科室,查找出相应病区
		.s sub=0
		.f  s sub=$O(^CTLOC(ctlocIdStr,"LINK",sub)) q:sub=""  d
			..s linkWardId=^CTLOC(ctlocIdStr,"LINK",sub)
			..q:'$d(^DHCBPPara(0,"Ctloc",linkWardId))
			..s retStr=$$FindBpInquiryByWardId(linkWardId,bpciId,inquiryFromDate,inquiryToDate)
	i sumStr'="" d
		.s count=^DHCBPCInquiry(+bpciId,"count")+1
		.;w leaveDayPos_","_leaveCount,!
		.i leaveDayPos>0,leaveCount>0 d
			..i inquiryToDate'<inquiryFromDate s $p(sumStr,"^",CirculVelocityPos)=$fn(leaveCount/15,"",2)
			..s $p(sumStr,"^",leaveDayPos)=$fn($p(sumStr,"^",leaveDayPos)/leaveCount,"",2)
		.i (ScorePos>0)&&(ScoreCount>0) s $p(sumStr,"^",ScorePos)=$p(sumStr,"^",ScorePos)/ScoreCount //计算平均分数
		.//汇总计算
		.s bpciiSub=0
		.f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
			..i "^Percent^Multiply^"[("^"_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)_"^") d
				...s delimter="*"
				...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)="Percent" s delimter="/"
				...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)="Multiply" s delimter="*"
				...s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
				...s part=$p(refValue,delimter,1),total=$p(refValue,delimter,2)
				...s part=..Replace(part,"-","+-"),total=..Replace(total,"-","+-")
				...s partSum=0,totalSum=0
				...f iItem=1:1:$l(part,"+") d
					....s item=$p(part,"+",iItem)
					....q:item=""
					....s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
					....s partSum=(item/$zabs(item))*$p(sumStr,"^",itemPos)+partSum
				...f iItem=1:1:$l(total,"+") d
					....s item=$p(total,"+",iItem)
					....q:item=""
					....s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
					....s totalSum=(item/$zabs(item))*$p(sumStr,"^",itemPos)+totalSum
				...i totalSum>0 w "partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
				...q:totalSum=0
				...i delimter="*" s value=partSum*totalSum
				...i delimter="/" s value=partSum/totalSum
				...q:value=""
				...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)="Percent" s value=value*100
				...
				...s pos=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),20)
				...q:(pos<1) //!(partPos<1)!(totalPos<1)
				...s $p(sumStr,"^",pos)=$fn(value,"",2)
			..i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)="Average" d
				...s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",bpciiSub)),20)
				...
				...s curStr=$p(sumStr,"^",itemPos)
				...w itemPos_" curStr="_curStr,!
				...q:+$p(curStr,"/",2)=0
				...s $p(sumStr,"^",itemPos)=$fn(($p(curStr,"/",1)/$p(curStr,"/",2)),"",2)
		.s ^DHCBPInquiry(bpciId,count)=sumStr
		.;w "sum     "_sumStr,!
	q 0

FindBpInquiryByWardId(ctlocIdStr, bpciId, inquiryFromDate = "", inquiryToDate = "")
	s preDT=$h
	q:ctlocIdStr="" -1
	q:bpciId="" -2
	s pos=0,titleStr=""
	k posList
	s bpciIsByDate=$lg(^DHCBPCInquiry(bpciId),9) //?
	;i inquiryFromDate'="" d
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	s adjInquiryToDate=inquiryToDate
	i adjInquiryToDate<63520 s adjInquiryToDate=63520
	s bpciiSub=0,isArrange=0
	f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
		.i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),4)=1 d //查找项
			..//q:$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),21)=""
			..//w bpciiSub_"/"_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),21),!
			..i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="curPatRegister" q
			..s searchList(+$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),21),bpciiSub)=""
		.i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),5)=1 d //显示项
			..s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
			..s pos=pos+1
			..//s posList(bpciiCode_","_dataField_","_needNote_oeoriNote_","_refValue)=pos
			..s posList(posCode)=pos		
			..s $p(titleStr,"^",pos)=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),2)
			
	s ^DHCBPInquiry(bpciId,0)=titleStr
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d             //?
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId		
	s wardIdStr=##Class(web.DHCBPCom).GetLinkLocByLocId(ctlocIdStr) //科室关联
	s bpprId=0,bpStr="",searchLevel=1
	s count=^DHCBPCInquiry(+bpciId,"count")
	s ClassifyCode=$lg(^DHCBPCInquiry(bpciId),15)
	s bpciDTType=$lg(^DHCBPCInquiry(+bpciId),11) //检索类型
	w "bpciDTType:"_bpciDTType,!
	i bpciDTType="CP" d //当前在透病人
		.s bpprId="0"
		.f  s bpprId=$o(^DHCBPPatRegister(0,"Status","N",bpprId)) q:(bpprId="")  d
			..;q:$lg(^DHCBPPatRegister(bpprId),25)'="N"
			..;;;
			..s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
			..q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
			..s bpprStartDate=$lg($g(^DHCBPPatRegister(+bpprId)),12)
			..s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
			..s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)
			..s curPatBPYear=##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,1)
			..//w bpprId_"/"_bpprStartDate_"/"_bpprDate_"/"_curPatBPYear,!
			..s searchLevel="",inLevel=1
			..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d //
				...q:inLevel=0
				...s inLevel=0
				...s bpciiSub=0
				...//w searchLevel,!
				...f  s bpciiSub=$o(searchList(searchLevel,bpciiSub)) q:bpciiSub=""  d //查找项筛选
					....w searchLevel_"/"_bpciiSub_"/"_inLevel,!
					....//b
					....q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),4)
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="P" d
						.....s value=..GetInfoByBpprId(bpciId, bpciiSub, bpprId,inquiryFromDate,inquiryToDate)
						.....//w bpprId_"    value="_value_"/"_inquiryFromDate_"/"_inquiryToDate_"   "
						.....q:value=""
						.....s inLevel=1
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="O" d	
						.....;i regNo="C879608" w regNo_"/"_bpciiCode_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_needNote_"/"_dataField,!	
						.....s value=##class(web.DHCBPCom).GetOeordResult("",regNo,bpciiCode, inquiryFromDate, "0", inquiryToDate, "23:59:59","","","1", needNote, dataField,"","","")
						.....q:(dataField="Times")&&(value=0)
						.....q:value=""
						.....s inLevel=1
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="L" d		
						.....s value=..GetBPTestResult(bpciId,bpciiSub,bpprId,"",inquiryFromDate,inquiryToDate)
						.....q:value=""
						.....s inLevel=1				
			..i inLevel d
				...;w "inLevel:"_inLevel,!
				...s ^DHCBPInquiry(bpciId,"F",bpprId)=""
				...s bpaId=""
				...f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
					....q:($lg(^DHCBPArrange(bpaId),9)'="F")&&(subType="H")		
					....s bpaStartDate=$lg(^DHCBPArrange(bpaId),4)
					....q:(bpaStartDate<inquiryFromDate)!(bpaStartDate>inquiryToDate)
					....s ^DHCBPInquiry(bpciId,"F",bpprId,bpaId)=""
	e  i bpciDTType="D" d
		.s ^DHCBPInquiry(bpciId,"F",0)=""
	e  i bpciDTType="P"  d
		.s bpciCode=$lg(^DHCBPCInquiry(+bpciId),1)
	    .i ((bpciCode="patMonthSum")||(bpciCode="patOutMonthSum")) d
	    	..s inquiryFromDate=0 //检索月病人总数、转归病人(腹透)
		.s bpprId="0"
		.f  s bpprId=$o(^DHCBPPatRegister(bpprId)) q:(bpprId="")!(bpprId=0)   d				
			..//q:$lg(^DHCBPPatRegister(bpprId),25)'="N"
			..s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
			..q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
			..s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
			..q:(papmiId="")	
			..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
			..s admId=$lg(^DHCBPPatRegister(bpprId),26) //透析登记时病人就诊ID
			..s paadmtype=$p($g(^PAADM(admId)),"^",2)
			..s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
			..//i papmiMedicare="C879608" w "病案号"_papmiMedicare_"/"_regNo,!				
			..s bpprDate=$lg(^DHCBPPatRegister(bpprId),8) //登记日期
			..s bpprStartDate=$lg(^DHCBPPatRegister(bpprId),12)
			..s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
			..;q:(inquiryFromDate'="")&(bpprStartDate'="")&(inquiryFromDate>bpprStartDate)
			..;q:(inquiryFromDate'="")&(bpprDate'="")&(inquiryFromDate>bpprDate)				
			..q:((bpprEndDate'="")&(inquiryFromDate'=""))&(inquiryFromDate>bpprEndDate)
			..q:((bpprEndDate'="")&(inquiryToDate'=""))&(inquiryToDate<bpprEndDate)&&(subType="H")	
			..q:((bpprEndDate="")&(inquiryFromDate'=""))&(inquiryFromDate>bpprDate)&&(subType="H")			
			..q:(inquiryToDate'="")&(inquiryToDate<bpprDate)
			..s curPatBPYear=##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,1)	
			..//w regNo_"/"_bpprId,!			
			..//w bpprId_"/"_bpprStartDate_"/"_bpprDate_"/"_curPatBPYear,!
			..s searchLevel="",inLevel=1
			..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
				...q:inLevel=0
				...s inLevel=0
				...s bpciiSub=0
				...f  s bpciiSub=$o(searchList(searchLevel,bpciiSub)) q:bpciiSub=""  d //查找项筛选
					....;w searchLevel_"/"_bpciiSub_"/"_searchList(searchLevel,bpciiSub),!
					....q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),4)
					....s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
					....s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
					....s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选			
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="P" d							
						.....s value=..GetInfoByBpprId(bpciId, bpciiSub, bpprId,inquiryFromDate,inquiryToDate)
						.....;w "value:"_value_"/"_bpciId_"/"_bpciiSub_"/"_bpprId,!
						.....;s ^dhcbpmfc(bpciId,bpciiSub,bpprId)=value
						.....q:value=""
						.....s inLevel=1
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="O" d	
						.....i regNo="C879608" w regNo_"/"_bpciiCode_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_needNote_"/"_dataField,!	
						.....s value=##class(web.DHCBPCom).GetOeordResult("",regNo,bpciiCode, inquiryFromDate, "0", inquiryToDate, "23:59:59","","","1", needNote, dataField,"","","")
						.....q:(dataField="Times")&&(value=0)
						.....q:value=""
						.....s inLevel=1
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="L" d		
						.....;f j=1:1:$l(bpciiCode,"^")  d
						.....;s testCode=$p(bpciiCode,"^",j)
						.....;s value=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, inquiryFromDate, "0", inquiryToDate, "23:59:59", "0", needNote, dataField)
						.....;q:value=""
						.....;s inLevel=1
						.....s value=..GetBPTestResult(bpciId,bpciiSub,bpprId,"",inquiryFromDate,inquiryToDate)
						.....q:value=""
						.....s inLevel=1
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="A" d
						.....s bpaId=""
						.....f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d						
							......s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
							......q:(bpaStatus="")||(bpaStatus="D")
							......q:($lg(^DHCBPArrange(bpaId),9)'="F")&&(subType="H")
							......s bpaDate=$lg(^DHCBPArrange(bpaId),4)
							......q:(bpaDate'="")&(bpaDate>inquiryToDate)
							......q:(bpaDate'="")&(bpaDate<inquiryFromDate)
							......s value=..GetInfoByBpaId(bpciId, bpciiSub, bpaId,bpprId)
							......q:value=""
							......;s ^dhctmpmfc(bpprId,bpaId,"bpaStatus")=bpaStatus_"/"_value_"/"_bpaDate_"/"_inquiryFromDate_"/"_inquiryToDate
							......s ^DHCBPInquiry(bpciId,"F",bpprId)=""
							......s ^DHCBPInquiry(bpciId,"F",bpprId,bpaId)=""						
			..i inLevel d
				...;w "inLevel:"_inLevel,!
				...s ^DHCBPInquiry(bpciId,"F",bpprId)=""
				...s bpaId=""
				...f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
					....q:($lg(^DHCBPArrange(bpaId),9)'="F")&&(subType="H")
					....s bpaStartDate=$lg(^DHCBPArrange(bpaId),4)
					....q:(bpaStartDate<inquiryFromDate)!(bpaStartDate>inquiryToDate)
					....s ^DHCBPInquiry(bpciId,"F",bpprId,bpaId)=""
				
	e  d	//按透析记录
		.f date=inquiryFromDate:1:adjInquiryToDate d
			..//w "isArrange:in"_date_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_adjInquiryToDate,!
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"Date",date,bpaId)) q:bpaId=""  d
				...//w "date"
				...//q:$lg(^DHCBPArrange(bpaId),10)'="M"
				...//q:"MTF"'[$lg(^DHCBPArrange(bpprId),11)			
				...s bpprId=$lg(^DHCBPArrange(bpaId),1)
				...q:($lg(^DHCBPArrange(bpaId),9)'="F")&&(subType="H") //腹透过滤
				...//q:($d(^DHCBPInquiry(bpciId,"F",bpprId))=11) //病人满足条件不再执行记录
				...//w $d(^DHCBPInquiry(bpciId,"F",bpprId))="11",!
				...;q:$lg(^DHCBPPatRegister(bpprId),25)'="N" //常规、临时透析
				...s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
				...q:(papmiId="")	
				...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
				...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
				...q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
				...s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)
				...s bpprStartDate=$lg(^DHCBPPatRegister(bpprId),12)
				...s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
				...q:(inquiryFromDate'="")&(bpprEndDate'="")&(inquiryFromDate>bpprEndDate)
				...q:(inquiryToDate'="")&(inquiryToDate<bpprDate)				
				...;s ^dhctmpmfc("date",bpaId)=bpaId_"/"_bpprDate_"/"_bpprStartDate_"/"_bpprEndDate_"/"_inquiryFromDate_"/"_inquiryToDate
				...s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)
				...s curPatBPYear=##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,1)
				...//w bpprId_"/"_bpprStartDate_"/"_bpprDate_"/"_curPatBPYear,!
				...s searchLevel="",search=0,inLevel=0
				...f  s searchLevel=$o(searchList(searchLevel)) q:(searchLevel="")||(inLevel)  d
					....;w "insearch arr",!					
					....;q:inLevel=0
					....;s inLevel=0
					....s search=1
					....s bpciiSub=0
					....f  s bpciiSub=$o(searchList(searchLevel,bpciiSub)) q:(bpciiSub="")||(inLevel)  d //查找项筛选
						.....;w searchLevel_"/"_bpciiSub_"/"_searchList(searchLevel,bpciiSub),!
						.....q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),4)
						.....s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
						.....s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
						.....s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选													
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="P" d
							......s value=..GetInfoByBpprId(bpciId, bpciiSub, bpprId)
							......q:value=""
							......;i bpciiSub=7 w "P_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value,!
							......s inLevel=1
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="A" d
							......;q //未用！
							......;//w "bpaId="_bpaId
							......;w bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!	
							......s value=..GetInfoByBpaId(bpciId, bpciiSub, bpaId,bpprId)
							......;s ^dhctmpmfc("date",bpciId,bpciiSub,bpaId,bpprId)=value							
							......q:value=""
							......;w value,!
							......;i bpaId=69216 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
							......//i bpciiSub=6 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
							......s inLevel=1
						
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="O" d
							......s bpaSum=0,bpaCount=0
							......;s ^dhctmpmfc(bpprId)=EpisodeID_"/"_bpciiCode_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_needNote_"/"_dataField					
							......s value=##class(web.DHCBPCom).GetOeordResult("",regNo,bpciiCode, inquiryFromDate, "0", inquiryToDate, "23:59:59","","","0", needNote, dataField,"","","")
							......q:value=""
							......s inLevel=1
						
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="AO" d
							......;q //未用！
							......;//w "bpaId="_bpaId
							......;w bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!						
							......s value=##Class(web.DHCBPOrder).GetOrderByArrangeId(bpaId, bpciiCode, "N", "E", dataField)
							......;s ^dhctmpmfc("date",bpciId,bpciiSub,bpaId,bpprId)=value							
							......q:value=""
							......;w value,!
							......;i bpaId=69216 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
							......//i bpciiSub=6 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
							......s inLevel=1
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="R" d //监护数据
							......s bpciiId=##class(web.DHCBPCRecordItem).GetRecordItemIdByCode(bpciiCode)
							......s value=##Class(web.DHCBPRecord).GetBPRecordValue(bpaId,bpciiId)
							......;i bpprId=1115 w bpaId,!				
							......q:value=""	
							......;i bpprId=1115 w bpStr_"/"_value,!
							......s inLevel=1
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="L" d
							......;w bpciId_"/"_bpciiSub_"/"_bpprId_"/"_inquiryFromDate_"/"_inquiryToDate,!
							......s value=..GetBPTestResult(bpciId,bpciiSub,bpprId,"",inquiryFromDate,inquiryToDate)
							......q:value=""
							......s inLevel=1
				...i ((search)&&(inLevel))||(('search)&&('inLevel)) d
					....//i bpaId=69672 w "bpaId1="_bpaId,! 
					....;w "F_bpaId1="_date_"/"_bpprId_"/"_bpaId,!
					....;i bpaId=69216 w "F_bpaId1="_date_"/"_bpprId_"/"_bpaId,!
					....s ^DHCBPInquiry(bpciId,"F",bpprId)=""
					....s ^DHCBPInquiry(bpciId,"F",bpprId,bpaId)=""				
			
	////////////////////////////////显示项，输出
	i bpciDTType="D" d //质量检测
		.f date=inquiryFromDate:1:adjInquiryToDate d
			..s bpdId="",bpStr=""
			..f  s bpdId=$o(^DHCBPDetection(0,"Date",date,bpdId)) q:bpdId=""  d
				...s bpcdId=$li($g(^DHCBPDetection(bpdId)),1)
				...f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
					....//w bpdId_" bpciId="_bpciId," ",bpciiSub,!
					....q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),5)
					....s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
					....//w bpdId_"/"_bpciiSub_"/"_bpciiCode_" ==? "_$lg($g(^DHCBPC("Detection",bpcdId)),1),!
					....q:bpciiCode'=$lg($g(^DHCBPC("Detection",bpcdId)),1)
					....s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
					....s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
					....s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
					....s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
					....s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
					....s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
					....i $li($g(^DHCBPDetection(bpdId)),10)=1 s valueStr="合格"
					....e  s valueStr="不合格"
					....q:(needNote'="")&(("^"_needNote_"^")'[("^"_valueStr_"^"))
					....s value=""
					....i dataField="" s value=valueStr
					....//i dataField="Date" s value=$zd(date,3)
					....i dataField="Date" s value=##class(web.DHCClinicCom).ConvertToDate(date)
					....i dataField="Times" s value=$p(bpStr,"^",posList(posCode))+1
					....q:value=""
					....s $p(bpStr,"^",posList(posCode))=value
					....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)					
			..q:bpStr=""
			..s count=count+1
			..s ^DHCBPCInquiry(+bpciId,"count")=count
			..s ^DHCBPInquiry(bpciId,count)=bpStr
			
	q:(bpciDTType="D") 0
	
	i (ClassifyCode="S") d	//班次相关
		.s retStr=$$FindBpBed(ctlocIdStr)
		.f j=1:1:$l(retStr,"@") d
			..s resultStr=$p(retStr,"@",j)
			..s bedId=$p(resultStr,"#",1)
			..s bedCode=$p(resultStr,"#",2)
			..s bedDesc=$p(resultStr,"#",3)
			
			..i bedId=1 w bedId,!
			..s bpStr=""
			..s bpciiSub=0		
			..f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
				...q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),5)
				...s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
				...s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
				...s bpciiDesc=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),2)
				...s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
				...;i bedId=1 w needNote,!
				...s summaryType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)
				...;i (bpciiCode="bpaBedDesc") w bedDesc,!	
				...i (bpciiCode="bpaBedDesc") s $p(bpStr,"^",posList(posCode))=bedDesc		
				...q:(summaryType'="SeqNo") //汇总类型(班次循环)					
				...s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
				...s bpprId=""
				...f  s bpprId=$o(^DHCBPInquiry(bpciId,"F",bpprId)) q:bpprId=""  d
					....s bpaId="",bedDesc=""
					....f  s bpaId=$o(^DHCBPInquiry(bpciId,"F",bpprId,bpaId)) q:(bpaId="")  d
						.....//w bpprId_"/"_bpaId,!
						.....;s bpStr=""
						.....s arrDate=$lg(^DHCBPArrange(bpaId),4)
						.....s week= $zd(arrDate,10)
						.....q:(bpciiDesc'[$$FindWeek(week))
						.....;q:arrDate'=date
						.....;i bedId=1 w bpciiDesc,!
						.....s arrStat=$lg(^DHCBPArrange(bpaId),9)
						.....;w arrStat_"/"_ctlocIdStr,!
						.....q:(arrStat'="F")&&(subType="H") //腹透过滤
						.....s seqNo=$lg(^DHCBPArrange(+bpaId),6)
						.....i seqNo="A" s seqDesc="上午"
						.....i seqNo="P" s seqDesc="下午"
						.....i seqNo="E" s seqDesc="晚上"
						.....q:seqDesc'=needNote
						.....;i bedId=1 w seqDesc,!
						.....s bpBedId=$lg(^DHCBPArrange(+bpaId),7)
						.....s bedDesc=$lg($g(^DHCBPC("Bed",+bpBedId)),2)
						.....q:bpBedId'=bedId
						.....;i bedId=1 w bpBedId,!
						.....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="A" d
							......s bpaSum=0,bpaCount=0		
							......//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!					
							......s value=..GetInfoByBpaId(bpciId, bpciiSub, bpaId,bpprId)
							......//i bpciiSub=7 w bpprId_"/"_bpaId_"/"_value,!				
							......w value,!
							......q:value=""	

							......i bedId=1 w value,!
							......;i bpciiSub=7 w bpprId_"/"_value,!				
							......s $p(bpStr,"^",posList(posCode))=value
							......;w bpStr,!
							......;i (bpprId=1127)&(bpciiSub=9) w bpStr_"/"_bpprId_"/"_value,! 
							......;s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
			..;i bedId=1 w bpStr,!
			..;w bpStr,!
			..s count=count+1
			..;w count,!
			..s ^DHCBPCInquiry(+bpciId,"count")=count
			..s ^DHCBPInquiry(bpciId,count)=bpStr
			..;w count_"       "_bpStr,!
			..;s bpStr=""

	q:(bpciDTType="S") 0
	
	
	s bpprId="",tmpCount=0,mainToTime="23:59:59"
	f  s bpprId=$o(^DHCBPInquiry(bpciId,"F",bpprId)) q:bpprId=""  d
		.q:'$d(^DHCBPPatRegister(bpprId))
		.s EpisodeID=$lg(^DHCBPPatRegister(bpprId),26)
		.s papmiId=$lg(^DHCBPPatRegister(bpprId),1)	
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;w "bpprId="_bpprId,!
		.s inDate=$lg(^DHCBPPatRegister(bpprId),4),inTime=$lg(^DHCBPPatRegister(bpprId),5)
		.s inDateTime=inDate+(inTime/100000)
		.s bpStr=""
		.s ClassifyCode=$lg(^DHCBPCInquiry(bpciId),15)
		.i (ClassifyCode="")||(ClassifyCode="P") d	//透析病人相关	
		..s bpciiSub=0
		..//w ClassifyCode,!		
		..f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
			...q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),5)
			...s type=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)
			...s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
			...s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //关联主项
			...s refPosCode=0
			...i refBpciiSub'="" d
				....s refPosCode=..GetIcuciPosCode(bpciId,refBpciiSub)
			...q:(refBpciiSub'="")&($p(bpStr,"^",$g(posList(refPosCode)))="")
			...;w " in",!
			...s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
			...s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
			...s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
			...s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
			...s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
			...s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
			...s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
			...s minUnit=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),25) //add mfc 20140613间隔分钟单位
			...s oeoriNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),14) //持续泵用		
			...i minUnit="" s minUnit="60"
			...s startDate=inDate,startTime=inTime
			...s durationHour=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),13)
			...s touchQtyV="",MinV="",MaxV="",MinDTV="",MaxDTV="",touchQtyV=""
			...s bpaSum=0,bpaCount=0,ifFind=0
			...//w "sumType="_sumType,!
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="P" d
				....s value=..GetInfoByBpprId(bpciId, bpciiSub, bpprId,inquiryFromDate,inquiryToDate)
				....q:value=""
				....//w value_"/"_bpciId_"/"_bpciiSub_"/"_bpprId,!
				....//s typeName=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)				
				....//q:(typeName="patRegDate")&&((value<inquiryFromDate)!(value>inquiryToDate))
				....s $p(bpStr,"^",posList(posCode))=value
				....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="L" d
				....s value=..GetBPTestResult(bpciId,bpciiSub,bpprId,"",inquiryFromDate,inquiryToDate)
				....q:value=""
				....//w "结果"_"/"_bpprId_"/"_value,!
				....s $p(bpStr,"^",posList(posCode))=value	
				....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)			
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="A" d
				....s bpaSum=0,bpaCount=0
				....s ifFind=0		
				....s bpaId=""
				....f  s bpaId=$o(^DHCBPInquiry(bpciId,"F",bpprId,bpaId),-1) q:(bpaId="")||(ifFind)  d
					.....//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!
					.....q:($lg(^DHCBPArrange(bpaId),9)'="F")
					.....s value=..GetInfoByBpaId(bpciId, bpciiSub, bpaId,bpprId)
					.....;s ^dhctmpmfc("date",bpciId, bpciiSub, bpaId,bpprId,"A")=value
					.....;i bpciiSub=7 w bpprId_"/"_value,!				
					.....q:value=""	
					.....;i bpciiSub=7 w bpprId_"/"_value,!
					.....i (dataField="Min")||(dataField="MinDT") d //最小值
						......i MinV="" s MinV=value,MinDTV=value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3)
						......i value<MinV s MinV=value,MinDTV=value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3)
						......i (dataField="Min") s value=MinV	
						......i (dataField="MinDT") s value=MinDTV
					.....i (dataField="Max")||(dataField="MaxDT") d  //最大值
						......i MaxV="" s MaxV=value,MaxDTV=value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3) 
						......i value>MaxV s MaxV=value,MaxDTV=value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3)
						......i (dataField="Max") s value=MaxV	
						......i (dataField="MaxDT") s value=MaxDTV
					.....i dataField="touchQty" d  //连续值
						......i touchQtyV="" s touchQtyV=value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3)
						......e  s touchQtyV=touchQtyV_"#"_value_" "_$zd($lg(^DHCBPArrange(bpaId),4),3)
						......s value=touchQtyV
					.....s bpaSum=bpaSum+value,bpaCount=bpaCount+1
					.....q:dataField="Average"					
					.....i dataField="Times" s value=bpaCount
					.....s $p(bpStr,"^",posList(posCode))=value
					.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					.....i dataField="" s ifFind=1 
				....i dataField="Average",bpaCount>0 d
					.....s value=$fn(bpaSum/bpaCount,"",2)
					.....s $p(bpStr,"^",posList(posCode))=value
					.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="O" d
				....s bpaSum=0,bpaCount=0
				....;s ^dhctmpmfc(bpprId)=EpisodeID_"/"_bpciiCode_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_needNote_"/"_dataField					
				....s value=##class(web.DHCBPCom).GetOeordResult("",regNo,bpciiCode, inquiryFromDate, "0", inquiryToDate, "23:59:59","","","0", needNote, dataField,"","","")
				....q:(dataField="Times")&&(value=0)
				....//w bpprId_"/"_value,!
				....q:value=""
				....;i regNo="C879608" w "测试:"_value,!			
				....s $p(bpStr,"^",posList(posCode))=value					
				....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="AO" d				
				....s bpaId=""
				....f  s bpaId=$o(^DHCBPInquiry(bpciId,"F",bpprId,bpaId),-1) q:(bpaId="")||(ifFind)  d
					.....//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!
					.....;q:($lg(^DHCBPArrange(bpaId),9)'="F")					
					.....s value=##Class(web.DHCBPOrder).GetOrderByArrangeId(bpaId, bpciiCode, "N", "E", dataField)
					.....;i bpciiSub=6 w bpprId_"/"_value,!				
					.....q:value=""	
					.....;i bpciiSub=6 w bpprId_"/"_value,!				
					.....i value>0 s bpaCount=bpaCount+1,bpaSum=bpaSum+value
					.....;i bpciiSub=6 w bpprId_"/"_value_"/"_bpaCount_"/"_bpaSum,!	
					.....i dataField="Times" s value=bpaCount
					.....i dataField="Sum" s value=bpaSum					
					.....s $p(bpStr,"^",posList(posCode))=value
					.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					.....i dataField="" s ifFind=1
			...i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="R" d //监护数据
				....s bpaSum=0,bpaCount=0		
				....s bpaId="",ifFind=0
				....f  s bpaId=$o(^DHCBPInquiry(bpciId,"F",bpprId,bpaId),-1) q:(bpaId="")||(ifFind)  d
					.....//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!					
					.....q:($lg(^DHCBPArrange(bpaId),9)'="F")
					.....s bpciiId=##class(web.DHCBPCRecordItem).GetRecordItemIdByCode(bpciiCode)
					.....s value=##Class(web.DHCBPRecord).GetBPRecordValue(bpaId,bpciiId)
					.....i bpciiSub=6 w bpaId_"/"_value,!				
					.....q:value=""	
					.....;i bpprId=1115 w bpStr_"/"_value,!
					.....s $p(bpStr,"^",posList(posCode))=value
					.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					.....i dataField="" s ifFind=1 
		
		.e  i (ClassifyCode="A") d	//透析记录相关		
			..//w ClassifyCode,!
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPInquiry(bpciId,"F",bpprId,bpaId)) q:(bpaId="")  d
				...//w bpprId_"/"_bpaId,!
				...s bpStr=""
				...s bpciiSub=0		
				...f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
					....q:'$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),5)
					....s type=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)
					....s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
					....s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //关联主项
					....s refPosCode=0
					....i refBpciiSub'="" d
					.....s refPosCode=..GetIcuciPosCode(bpciId,refBpciiSub)
					....q:(refBpciiSub'="")&($p(bpStr,"^",$g(posList(refPosCode)))="")
					....;w " in",!
					....s bpciiCode=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
					....s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
					....s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
					....s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
					....s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
					....s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
					....s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
					....s minUnit=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),25) //add mfc 20140613间隔分钟单位
					....s oeoriNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),14) //持续泵用		
					....i minUnit="" s minUnit="60"
					....s startDate=inDate,startTime=inTime
					....s durationHour=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),13)
					....//w "sumType="_sumType,!
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="P" d
						.....s value=..GetInfoByBpprId(bpciId, bpciiSub, bpprId)
						.....s typeName=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
						.....//q:(typeName="patRegDate")&&((value<inquiryFromDate)!(value>inquiryToDate))
						.....s $p(bpStr,"^",posList(posCode))=value
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="L" d
						.....s value=..GetBPTestResult(bpciId,bpciiSub,bpprId,"",inquiryFromDate,inquiryToDate)
						.....q:value=""
						.....s $p(bpStr,"^",posList(posCode))=value	
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)			
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="A" d
						.....s bpaSum=0,bpaCount=0		
						.....//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!					
						.....s value=..GetInfoByBpaId(bpciId, bpciiSub, bpaId,bpprId)
						.....//i bpciiSub=7 w bpprId_"/"_bpaId_"/"_value,!				
						.....q:value=""	
						.....;i bpciiSub=7 w bpprId_"/"_value,!				
						.....s bpaSum=bpaSum+value,bpaCount=bpaCount+1
						.....q:dataField="Average"					
						.....i dataField="Times" s value=bpaCount
						.....s $p(bpStr,"^",posList(posCode))=value
						.....i (bpprId=1127)&(bpciiSub=9) w bpStr_"/"_bpprId_"/"_value,! 
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
						.....i dataField="Average",bpaCount>0 d
						......s value=$fn(bpaSum/bpaCount,"",2)
						......s $p(bpStr,"^",posList(posCode))=value
						......s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)				

					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="O" d
						.....s bpaSum=0,bpaCount=0
						.....;s ^dhctmpmfc(bpprId)=EpisodeID_"/"_bpciiCode_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_needNote_"/"_dataField					
						.....s value=##class(web.DHCBPCom).GetOeordResult("",regNo,bpciiCode, inquiryFromDate, "0", inquiryToDate, "23:59:59","","","0", needNote, dataField,"","","")
						.....q:(dataField="Times")&&(value=0)
						.....q:value=""
						.....;i regNo="C879608" w "测试:"_value,!			
						.....s $p(bpStr,"^",posList(posCode))=value					
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="AO" d
						.....;q //未用！
						.....;//w "bpaId="_bpaId
						.....//w bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!						
						.....s value=##Class(web.DHCBPOrder).GetOrderByArrangeId(bpaId, bpciiCode, "N", "E",dataField)
						.....;s ^dhctmpmfc("date",bpciId,bpciiSub,bpaId,bpprId)=value							
						.....q:value=""
						.....;w value,!
						.....;i bpaId=69216 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
						.....//i bpciiSub=6 w "A_value1="_bpciId_"/"_bpciiSub_"/"_bpprId_"/"_bpaId_"/"_value_"/"_searchLevel,!
						.....s $p(bpStr,"^",posList(posCode))=value
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)	
				
					....i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)="R" d //监护数据
						.....s bpaSum=0,bpaCount=0
						.....//w "结果:"_bpciId_"/"_bpciiSub_"/"_bpaId_"/"_bpprId,!					
						.....s bpaSum=0,bpaCount=0
						.....s bpciiId=##class(web.DHCBPCRecordItem).GetRecordItemIdByCode(bpciiCode)
						.....s value=##Class(web.DHCBPRecord).GetBPRecordValue(bpaId,bpciiId)
						.....;i bpprId=1115 w bpaId,!				
						.....q:value=""	
						.....;i bpprId=1115 w bpStr_"/"_value,!
						.....s $p(bpStr,"^",posList(posCode))=value
						.....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)						
				...s count=count+1
				...s ^DHCBPCInquiry(+bpciId,"count")=count
				...s ^DHCBPInquiry(bpciId,count)=bpStr
				...;w count_"       "_bpStr,!
				...s bpStr=""
		
		.//项目计算
		.s bpciiSub=0
		.f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
			..q:$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)'="C"
			..
			..s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //关联主项
			..s refPosCode=0
			..i refBpciiSub'="" d
				...s refPosCode=..GetIcuciPosCode(bpciId,refBpciiSub)
			..q:(refBpciiSub'="")&($p(bpStr,"^",$g(posList(refPosCode)))="")
			..		
			..s value=""
			..q:("^Percent^Multiply^")'[("^"_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)_"^")
			..s delimter="*"
			..i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Percent" s delimter="/"
			..i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Multiply" s delimter="*"
			..s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
			..s part=$p(refValue,delimter,1),total=$p(refValue,delimter,2)
			..s part=..Replace(part,"-","+-"),total=..Replace(total,"-","+-")
			..s partSum=0,totalSum=0
			..f iItem=1:1:$l(part,"+") d
				...s item=$p(part,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
				...s partSum=(item/$zabs(item))*$p(bpStr,"^",itemPos)+partSum
			..f iItem=1:1:$l(total,"+") d
				...s item=$p(total,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
				...s totalSum=(item/$zabs(item))*$p(bpStr,"^",itemPos)+totalSum
			..i totalSum>0 w "partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
			..q:totalSum=0
			..i delimter="*" s value=partSum*totalSum
			..i delimter="/" s value=partSum/totalSum
			..q:value=""
			..i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Percent" s value=value*100
			..
			..s pos=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),20)
			..q:(pos<1) //!(partPos<1)!(totalPos<1)
			..s $p(bpStr,"^",pos)=$fn(value,"",2)
			..s posCode=..GetIcuciPosCode(bpciId,bpciiSub)
			..s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24)
			..s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
		.i (ClassifyCode'="R") d
			..s count=count+1
			..s ^DHCBPCInquiry(+bpciId,"count")=count
			..s ^DHCBPInquiry(bpciId,count)=bpStr
			..;w count_"       "_bpStr,!
			..s bpStr=""
 	;w preDT_" pre\now "_$h_" duration:"_($p($h,",",2)-$p(preDT,",",2)),!
 	q 0
FindBpBed(ctlocIdStr)
	s ret=""
	s rset=##class(%ResultSet).%New("web.DHCBPCBed:GetBedList")	
	do rset.Execute(ctlocIdStr)
	while (rset.Next()) {		
		i ret=""  s ret=rset.GetData(1)_"#"_rset.GetData(2)_"#"_rset.GetData(3)
		e  s ret=ret_"@"_rset.GetData(1)_"#"_rset.GetData(2)_"#"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
FindWeek(weekNo)
	s ret=""
	i weekNo=1 s ret="周一"
	i weekNo=2 s ret="周二"
	i weekNo=3 s ret="周三"
	i weekNo=4 s ret="周四"
	i weekNo=5 s ret="周五"
	i weekNo=6 s ret="周六"
	i weekNo=0 s ret="周日"
	q ret
}

ClassMethod CalculateInquiryItem(bpciId, bpciiSub, calType, bpStr)
{
	//项目计算
	s bpciiSub=0
	f  s bpciiSub=$o(^DHCBPCInquiry(bpciId,"I",bpciiSub)) q:bpciiSub=""  d
		.q:$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),3)'="C"
		.
		.s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //关联主项
		.s refPosCode=0
		.i refBpciiSub'="" d
			..s refPosCode=..GetIcuciPosCode(bpciId,refBpciiSub)
		.q:(refBpciiSub'="")&($p(bpStr,"^",$g(posList(refPosCode)))="")
		.		
		.s value=""
		.q:("^Percent^Multiply^")'[("^"_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)_"^")
		.s delimter="*"
		.i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Percent" s delimter="/"
		.i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Multiply" s delimter="*"
		.s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
		.s part=$p(refValue,delimter,1),total=$p(refValue,delimter,2)
		.s part=..Replace(part,"-","+-"),total=..Replace(total,"-","+-")
		.s partSum=0,totalSum=0
		.f iItem=1:1:$l(part,"+") d
			..s item=$p(part,"+",iItem)
			..q:item=""
			..s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
			..s partSum=(item/$zabs(item))*$p(bpStr,"^",itemPos)+partSum
		.f iItem=1:1:$l(total,"+") d
			..s item=$p(total,"+",iItem)
			..q:item=""
			..s itemPos=$lg($g(^DHCBPCInquiry(bpciId,"I",$zabs(item))),20)
			..s totalSum=(item/$zabs(item))*$p(bpStr,"^",itemPos)+totalSum
		.i totalSum>0 w "partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
		.q:totalSum=0
		.i delimter="*" s value=partSum*totalSum
		.i delimter="/" s value=partSum/totalSum
		.q:value=""
		.i $lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)="Percent" s value=value*100
		.
		.s pos=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),20)
		.q:(pos<1) //!(partPos<1)!(totalPos<1)
		.s $p(bpStr,"^",pos)=$fn(value,"",2)
	q bpStr
}

ClassMethod GetIcuciPosCode(bpciId, bpciiSub)
{
	s retStr=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)				//code
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6)	//dataField
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)	//minQty
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)	//maxQty
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10)	//note
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),14)	//oeoriNote
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18)	//refId
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)	//refValue
	s retStr=retStr_","_$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),20)	//seqNo
	q retStr
}

ClassMethod GetInfoByBpprId(bpciId, bpciiSub, bpprId, fdate = "", tdate = "")
{
	s type=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
	s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
	s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
	s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
	s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
	s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //
	s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
	s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
	s oeoriNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),14) //持续泵用

	s value=""
	s inDate=tdate
	i inDate="" s inDate=+$h
	s bpprdiag=$lg(^DHCBPPatRegister(bpprId),6)    ////诊断
	s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)		
	s bpprTime=$lg(^DHCBPPatRegister(bpprId),9)
	s bpprStartDate=$lg(^DHCBPPatRegister(bpprId),12)
	i bpprStartDate="" s bpprStartDate=bpprDate
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	s EpisodeID=$lg(^DHCBPPatRegister(bpprId),26)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	;w "papmiId="_papmiId,!
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	i type="curPatBPYear" d
	.s curPatBPYear=+##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,1)
	.s value=curPatBPYear
	i type="curPatBPMonth" d
	.s curPatBPMonth=+##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,0,"M")
	.;w $zd(bpprStartDate)_"/"_curPatBPMonth,!
	.s value=curPatBPMonth	
	i type="regNo" s value=regNo
	//i type="papmiMedicare" s value=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	i type="papmiMedicare" d
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s value=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	i type="patName" s value=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	i type="patSex" s value=$p($g(^CT("SEX",+$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	i type="dateOfBirth" s birDate=$p($g(^PAPER(papmiId,"ALL")),"^",6),value=$zd(birDate,3) //出生日期
	i type="nation" d  //民族	
	.s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
	.i NationDr'="" s value=$P(^CT("NAT",NationDr),"^",2)
	i type="homeAddres" s value=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
	i type="homeTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	i type="workTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
	i type="handtel" s value=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
	i type="papmiDecease" d
		.i $p($g(^DHCBPArrange(bpaId)),"^",43)="D" s value="是" 
	i type="patStatus" d //病人状态
		.s patStatus=$lg(^DHCBPPatRegister(bpprId),14)
		.i patStatus="N" s patStatus="正常"
		.i patStatus="D" s patStatus="转归"
		.s value=patStatus
	i type="patType" d //病人类型
		.s PatType=$lg(^DHCBPPatRegister(bpprId),25)
		.i PatType="N" s PatType ="常规"        
        .e  s PatType="临时"
        .s value=PatType             
	i type="bpLeaveCondition" d
		.s value=$lg(^DHCBPPatRegister(bpprId),14)
		.s val=value
		.s value=$s(val="":"",val="N":"在院",value="D":"转归")
	i type="bpVisitStatus" d		
		.s bpcvsId=$lg(^DHCBPPatRegister(bpprId),15)
		.q:bpcvsId=""
		.s value=$lg($g(^DHCBPC("VisitStatus",bpcvsId)),2)
	i type="deceaseReason" d
		.s bpcdrId=$lg(^DHCBPPatRegister(bpprId),16)
		.q:bpcdrId=""
		.s value=$lg($g(^DHCBPC("DeceaseReason",bpcdrId)),2)
	i type="diag" d //HIS带入主诊断
		.s value=##Class(web.DHCClinicCom).GetMRDiagnos($P(^PAADM(EpisodeID),"^",61))
		.;w "EpisodeID="_EpisodeID_"/"_$P(^PAADM(EpisodeID),"^",61)_"/"_value,!	
	i type="bpDiagDesc" d //诊断描述
		.s value=$lg(^DHCBPPatRegister(bpprId),6)
	i (type="bpMainDiag")||(type="bpSubDiag")||(type="bpOtherDiag") d //主诊断、伴随诊断、其他诊断
		.s diagnosId="",diagStr=""
		.f  s diagnosId=$o(^DHCBPDiagnos(0,"BPPReg",bpprId,diagnosId)) q:diagnosId=""  d			
			..s diag=$lg(^DHCBPDiagnos(diagnosId),3)
			..s diagType=$lg(^DHCBPDiagnos(diagnosId),4)
			..i (type="bpMainDiag")&&(diagType="M") d				
				...i (diagStr="") s diagStr=diag
				...e  s diagStr=diagStr_";"_diag
			..i (type="bpSubDiag")&&(diagType="S") d				
				...i (diagStr="") s diagStr=diag
				...e  s diagStr=diagStr_";"_diag
			..i (type="bpOtherDiag")&&(diagType="O") d				
				...i (diagStr="") s diagStr=diag
				...e  s diagStr=diagStr_";"_diag			
		.s value=diagStr
	i type="inBPDiag" d
		.s icdId=$lg(^DHCBPPatRegister(bpprId),28)
		.q:icdId=""
		.s value=$p($g(^MRC("ID",icdId)),"^",2)
		.i value="尿毒症" s value="不详"
	i type="deceaseBPDiag" d
		.s icdId=$lg(^DHCBPPatRegister(bpprId),29)
		.q:icdId=""
		.s value=$p($g(^MRC("ID",icdId)),"^",2)
	i type="patBPNo" s value=$lg(^DHCBPPatRegister(bpprId),17)
	i type="patAge" d
		.s value=##class(web.DHCClinicCom).CalAge($p($g(^PAPER(papmiId,"ALL")),"^",6),inDate,"","Y")
	i type="bpabpcvaVary" d //血管通路趋势变化	
		.s value=##class(web.DHCBPCVascularAccess).GetVascularAccessDesc(bpprId,needNote)
	i type="bpabpcBPMode" d //透析方式
		.s value=##class(web.DHCBPArrangeScheme).GetBPCModeDesc(bpprId,needNote)		
	i type="patRegDate" d
		.q:(+fdate>0)&((bpprDate<fdate)!(bpprDate>tdate))
		.s value=$zd(bpprDate,3)
	i (type="patStartDate")&&(bpprStartDate'="") s value=$zd(bpprStartDate,3)
	i (type="patOutDate")&&(bpprEndDate'="") s value=$zd(bpprEndDate,3)
	
	s fromD= $zd(fdate,3)
	s fromYear=$p(fromD,"-",1)
	s fromMonth=$p(fromD,"-",2)
	s toD = $zd(tdate,3)
	s toYear=$p(toD,"-",1)
	s toMonth=$p(toD,"-",2)
	s prStartDate="",prStartYear="",prStartMonth="",prEndDate="",prEndYear="",prEndMonth=""
	i bpprDate'="" d
		.s prDate =$zd(bpprDate,3)
		.s prYear=$p(prDate,"-",1)
	i bpprStartDate'="" d
		.s prStartDate =$zd(bpprStartDate,3)
		.s prStartYear=$p(prStartDate,"-",1)
		.s prStartMonth=$p(prStartDate,"-",2) 
	i bpprEndDate'="" d
		.s prEndDate = $zd(bpprEndDate,3)	
		.s prEndYear=$p(prEndDate,"-",1)	
		.s prEndMonth=$p(prEndDate,"-",2)
	i (type="pdOneMonth")||(type="pdInOneMonth")||(type="pdOutOneMonth") s monthNum=1
	i (type="pdTwoMonth")||(type="pdInTwoMonth")||(type="pdOutTwoMonth") s monthNum=2
	i (type="pdThreeMonth")||(type="pdInThreeMonth")||(type="pdOutThreeMonth") s monthNum=3
	i (type="pdFourMonth")||(type="pdInFourMonth")||(type="pdOutFourMonth") s monthNum=4
	i (type="pdFiveMonth")||(type="pdInFiveMonth")||(type="pdOutFiveMonth") s monthNum=5
	i (type="pdSixMonth")||(type="pdInSixMonth")||(type="pdOutSixMonth") s monthNum=6
	i (type="pdSevenMonth")||(type="pdInSevenMonth")||(type="pdOutSevenMonth") s monthNum=7
	i (type="pdEightMonth")||(type="pdInEightMonth")||(type="pdOutEightMonth") s monthNum=8
	i (type="pdNineMonth")||(type="pdInNineMonth")||(type="pdOutNineMonth") s monthNum=9
	i (type="pdTenMonth")||(type="pdInTenMonth")||(type="pdOutTenMonth") s monthNum=10
	i (type="pdElevenMonth")||(type="pdInElevenMonth")||(type="pdOutElevenMonth") s monthNum=11
	i (type="pdTwelveMonth")||(type="pdInTwelveMonth")||(type="pdOutTwelveMonth") s monthNum=12	
	;w bpprStartDate_"/"_bpprEndDate_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),!
	//病人总数(腹透)(月)
	i "pdOneMonth^pdTwoMonth^pdThreeMonth^pdFourMonth^pdFiveMonth^pdSixMonth^pdSevenMonth^pdEightMonth^pdNineMonth^pdTenMonth^pdElevenMonth^pdTwelveMonth"[type d
		.;i $p($g(^PAPER(papmiId,"ALL")),"^",1)="何培新" w "2本年度的"_prStartDate_"/"_prEndDate_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
		.s ^tmpmfcbp(bpprId,bpciId,bpciiSub)=prEndYear_"/"_toYear_"/"_toMonth_"/"_+prEndMonth_"/"_monthNum_"/"_prStartYear_"/"_prStartMonth_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.q:(prEndYear'="")&&(prEndYear<toYear) //转归非本年度过滤
		.q:(prEndYear'="")&&(prEndYear=toYear)&&(+prEndMonth<monthNum) //本年度转归病人过滤
		.q:(prEndYear="")&&(prStartYear=toYear)&&(prStartMonth>monthNum) //本年度未转归病人过滤
		.//i bpprId=432 s ^dhcbpmfc(bpprId)=fdate_"/"_tdate_"/"_prEndYear_"/"_prStartYear_"/"_fromYear_"/"_toMonth_"/"_monthNum
		.q:(prEndYear="")&&(prStartYear<=toYear)&&(+toMonth<monthNum) //本年度未转归，超出查询日期(月份)病人过滤
		.q:(prEndYear'="")&&(prStartYear=toYear)&&(monthNum<prStartMonth)
		.;i $p($g(^PAPER(papmiId,"ALL")),"^",1)="何培新" w "2本年度的"_prStartDate_"/"_prEndDate_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
		.s value= $p($g(^PAPER(papmiId,"ALL")),"^",1)		
	//新进入病人(月)
	i "pdInOneMonth^pdInTwoMonth^pdInThreeMonth^pdInFourMonth^pdInFiveMonth^pdInSixMonth^pdInSevenMonth^pdInEightMonth^pdInNineMonth^pdInTenMonth^pdInElevenMonth^pdInTwelveMonth"[type d
		.//s ^tmpmfcbp(bpprId)=prStartYear_"/"_toYear_"/"_+prStartMonth_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.i fromYear<toYear s toYear=fromYear //已开始年度的为主
		.q:(prStartYear'="")&&(prStartYear'=toYear)
		.q:(+prStartMonth'=monthNum)
		.;q:(+prStartMonth>monthNum)
		.;q:(prEndYear'="")&&(+prEndMonth<monthNum)
		.s value= $p($g(^PAPER(papmiId,"ALL")),"^",1)
		.;i $p($g(^PAPER(papmiId,"ALL")),"^",1)="曹桂芳" w "2本年度的"_prStartDate_"/"_prEndDate_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
	//转归病人(月)
	i "pdOutOneMonth^pdOutTwoMonth^pdOutThreeMonth^pdOutFourMonth^pdOutFiveMonth^pdOutSixMonth^pdOutSevenMonth^pdOutEightMonth^pdOutNineMonth^pdOutTenMonth^pdOutElevenMonth^pdOutTwelveMonth"[type d
		.q:(prEndYear="") //非转归病人过滤
		.;i $p($g(^PAPER(papmiId,"ALL")),"^",1)="郝冠士" w "1本年度的"_prStartDate_"/"_prEndDate_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
		.q:(prEndYear'="")&&(prEndYear'=toYear) //转归非本年度过滤
		.q:(+prEndMonth'=monthNum)
		.s value= $p($g(^PAPER(papmiId,"ALL")),"^",1)
		.;i $p($g(^PAPER(papmiId,"ALL")),"^",1)="郝冠士" w "4本年度的"_prStartDate_"/"_prEndDate_"/"_monthNum_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
	i type="pdInPat" d //新进入病人
		.q:(prStartYear'="")&&(prStartYear'=toYear) //转归非本年度过滤
		.s value= $p($g(^PAPER(papmiId,"ALL")),"^",1)
	i type="pdOutPat" d //转归病人信息
	    .i $p($g(^PAPER(papmiId,"ALL")),"^",1)="郭有春" w "1本年度的"_prStartDate_"/"_prEndDate_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
		.q:(prEndYear="")
		.q:(prEndYear'="")&&(prEndYear'=toYear) //转归非本年度过滤
		.i $p($g(^PAPER(papmiId,"ALL")),"^",1)="郭有春" w "2本年度的"_prStartDate_"/"_prEndDate_"/"_$p($g(^PAPER(papmiId,"ALL")),"^",1),! 
		.s value= $p($g(^PAPER(papmiId,"ALL")),"^",1)
	//w bpprId_"/"_value_"/"_needNote,!
	i type="pdFollowUpDialysisAge" d //复诊记录透析时间
		.;s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,""),-1)
		.s bpaId="",ifExist=0
		.f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId),-1) q:(bpaId="")||(ifExist)  d		
		..s arrangeExtendValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"PDFollowUpDialysisAge")
		..i (arrangeExtendValue'="") d
			...s value= $p(arrangeExtendValue,$c(3),1)
			...s ifExist=1	
	i (value'="")&(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^")) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""
	//w "结果"_bpprId_"/"_value_"/"_needNote,!
	q value
}

ClassMethod GetInfoByBpaId(bpciId As %String = "", bpciiSub As %String = "", bpaId As %String = "", bpprId As %String = "", fdate As %String = "", tdate As %String = "")
{
	s type=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
	s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
	s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
	s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
	s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
	s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //
	s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
	s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用
	s oeoriNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),14) //持续泵用
	s value=""
	s inDate=tdate
	i inDate="" s inDate=+$h
	s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)	
	s bpprTime=$lg(^DHCBPPatRegister(bpprId),9)
	s bpprStartDate=$lg(^DHCBPPatRegister(bpprId),12)
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	s curPatBPYear=+##class(web.DHCClinicCom).CalAge(bpprDate,+$h,1,"M")
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	;w "papmiId="_papmiId,!
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s EpisodeID=$lg(^DHCBPPatRegister(+bpprId),26)
	i type="curPatBPYear" s value=curPatBPYear
	i type="curPatBPMonth" d
	.s curPatBPMonth=+##class(web.DHCClinicCom).CalAge(bpprStartDate,+$h,1,"M")
	.s value=curPatBPMonth
	i type="regNo" s value=regNo
	//i type="papmiMedicare" s value=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	i type="papmiMedicare" d
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s value=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	i type="patName" s value=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	i type="patSex" s value=$p($g(^CT("SEX",+$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	i type="dateOfBirth" s birDate=$p($g(^PAPER(papmiId,"ALL")),"^",6),value=$zd(birDate,3) //出生日期
	i type="nation" d  //民族	
	.s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
	.i NationDr'="" s value=$P(^CT("NAT",NationDr),"^",2)
	i type="homeAddres" s value=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
	i type="homeTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	i type="workTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
	i type="handtel" s value=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
		i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""		
	q:(value'="") value
	
	i type="bpaDate" d //透析日期
	.s value=$zd($lg(^DHCBPArrange(bpaId),4),3)	
	i type="bpcTime" d //透析时间
	.s value=$zt($lg(^DHCBPArrange(bpaId),5),4)	
	i type="bpaBedDesc" d
	.s bpBedId=$lg(^DHCBPArrange(+bpaId),7)
	.s value=$lg($g(^DHCBPC("Bed",+bpBedId)),2)
	i type="bpaDaySeqNo" d
	.s bpDaySeqNo=$lg(^DHCBPArrange(+bpaId),6)
	.i bpDaySeqNo="A" s value="上午"
	.i bpDaySeqNo="P" s value="下午"
	.i bpDaySeqNo="E" s value="晚上"	
	i type="bpcMode" d //透析方式
	.s bpcbpModeId=$lg(^DHCBPArrange(bpaId),26)	
	.i bpcbpModeId'="" s value=$lg($g(^DHCBPC("BloodPurificationMode",+bpcbpModeId)),2)
	
	i type="anticoagulantMode" d // 抗凝方式
		.s bpaAnticoagulantModeDr=$lg(^DHCBPArrange(bpaId),77)
		.s value=$lg($g(^DHCBPC("AnticoagulantMode",+bpaAnticoagulantModeDr)),2)
	
	i type="PDAnticoagulantMode" d // 抗凝方式(腹透)	
		.s adDescStr=""
		.s obj=##class(%ResultSet).%New("web.DHCBPArrange:GetArrangeAnticoagulantDrugList")
		.d obj.Execute(bpaId)
		.f  q:'obj.Next()  d
			..s adId=obj.Data("AnticoagulantDrugId")
			..s adDesc=$lg($g(^DHCBPC("AnticoagulantDrug",adId)),2)	
			..i adDescStr="" s adDescStr=adDesc
			..e  s adDescStr=adDescStr_"#"_adDesc 
		.s value=adDescStr
	i type="bpaurr" s value=$lg(^DHCBPArrange(bpaId),57)
	i type="bpaktv" s value=$lg(^DHCBPArrange(bpaId),58)	
	i type="therapyDurationStr" d //透析时长
		.s therapyDuration=$lg(^DHCBPArrange(bpaId),18)		
		.s value=(therapyDuration \ 60)_"小时"_(therapyDuration-((therapyDuration \ 60)*60))_"分钟"
			
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""		
	q:(value'="") value
	
	i type="papmiDecease" d
	.i $p($g(^DHCBPArrange(bpaId)),"^",43)="D" s value="是" 
	//i type="diag" d
		.s value=##Class(web.DHCClinicCom).GetMRDiagnos($P(^PAADM(EpisodeID),"^",61))
		.w "EpisodeID="_EpisodeID_"/"_$P(^PAADM(EpisodeID),"^",61)_"/"_value,!
	i type="bpLeaveCondition" d
		.s value=$lg(^DHCBPPatRegister(bpprId),14)
		.s val=value
		.s value=$s(val="":"",val="N":"在院",value="D":"转归")
	i type="bpVisitStatus" d
		.s value=""
		.s bpcvsId=$lg(^DHCBPPatRegister(bpprId),15)
		.q:bpcvsId=""
		.s value=$lg($g(^DHCBPC("VisitStatus",bpcvsId)),2)
	i type="deceaseReason" d
		.s value=""
		.s bpcdrId=$lg(^DHCBPPatRegister(bpprId),16)
		.q:bpcdrId=""
		.s value=$lg($g(^DHCBPC("DeceaseReason",bpcdrId)),2)
	q:type="patAge" ##class(web.DHCClinicCom).CalAge($p($g(^PAPER(papmiId,"ALL")),"^",6),inDate)	
	q:type="patRegDate" bpprDate		
	
	i type="bpaBedDesc" d
	.s bpBedId=$lg(^DHCBPArrange(+bpaId),7)
	.s value=$lg($g(^DHCBPC("Bed",+bpBedId)),2)
	i type="bpaDaySeqNo" d
	.s bpDaySeqNo=$lg(^DHCBPArrange(+bpaId),6)
	.i bpDaySeqNo="A" s value="上午"
	.i bpDaySeqNo="P" s value="下午"
	.i bpDaySeqNo="E" s value="晚上"
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s dischgDate=$p($g(^PAADM(EpisodeID)),"^",17)
	
	i type="fromInWard" d
	.s formWardList=##class(web.DHCBPCom).GetWardInInfo("",bpaId,"","","D")
	.i formWardList'="" s formWard=$p($p(formWardList,"^",3),"-",2)
	.i formWard'="" s value=formWard
	i type="hospital" d
	.s locId=$p($g(^DHCBPArrange(+bpaId)),"^",2)
	.i locId'="" d
	..s hospitalDr=$P($g(^CTLOC(locId)),"^",22)
	..i hospitalDr'="" s value=$p($g(^CT("HOSP",hospitalDr)),"^",2)
	
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value
	
	//血管通路码表指针
	i type="bpaVACDesc" d
	.s bpaVACDr=$lg(^DHCBPArrange(bpaId),75)
	.i bpaVACDr'="" s value=$lg(^DHCBPC("VascularAccess",bpaVACDr),2)
	
	//血管通路建立部位指针
	i type="bpaVABodySiteDesc" d
    .s bpaVABodySiteDr=$lg(^DHCBPArrange(bpaId),76)
	.i bpaVABodySiteDr'="" s value =$lg(^DHCCLC("BodySite",bpaVABodySiteDr),2)
		
	/// 血流速
	i type="bpaBFR" d
    .s value=$lg(^DHCBPArrange(bpaId),73)
    /// 超滤量
    i type="bpaUFV" d
	.s value=$lg(^DHCBPArrange(bpaId),13)	
	// 透析前舒张压 
	i type="bpaStartDP" d
    .s value=$lg(^DHCBPArrange(bpaId),62)
    // 透析后舒张压
    i type="bpaEndDP" d
    .s value=$lg(^DHCBPArrange(bpaId),63)
    // 透析前收缩压
    i type="bpaStartSP" d
    .s value=$lg(^DHCBPArrange(bpaId),64)
    /// 透析后收缩压
    i type="bpaEndSP" d
    .s value=$lg(^DHCBPArrange(bpaId),65)
    /// 透析前心率(脉搏)
    i type="bpaStartHR" d
    .s value=$lg(^DHCBPArrange(bpaId),66)
    /// 透析后心率(脉搏)
    i type="bpaEndHR" d
    .s value=$lg(^DHCBPArrange(bpaId),67)
    /// 稀释方式
    i type="bpaFilterRMode" d
    .s value=$lg(^DHCBPArrange(bpaId),46)
    /// 稀释量
    i type="bpaFilterRAmount" d
	.s value =$lg(^DHCBPArrange(bpaId),47)
			
	i type="BPDay" d
	.i dischgDate'=""  s value=(dischgDate-admDate)+1
	.e  s value=(outDate-inDate)+1
	;s value=outDate-inDate
	i type="patSource" d //病人来源
	.s opExecute=$p($g(^DHCBPArrange(+bpaId)),"^",30) //非手术
	.i opExecute="N" d
	..s formWardList=##class(web.DHCBPCom).GetWardInInfo("",bpaId,"","","D")
	..i formWardList'="" s formWard=$p($p(formWardList,"^",3),"-",2)
	..i formWard'="" s value=formWard
	..e  s value="其它医院"	
	.i opExecute="E" s value="急诊手术"
	.i opExecute="B" s value="择期手术"	
	
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value
	
	/// 下机护士
    i type="bpaEndOpNurse" d
		.s bpaEndOperationNurseDr=$lg(^DHCBPArrange(bpaId),106)
		.i bpaEndOperationNurseDr'="" s value=##class(web.DHCANOPCom).GetNameById(bpaEndOperationNurseDr)
		.i value="用户不存在!" s value=""
	
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value
		
	i type="autoLeave" d
	.i $p($g(^DHCBPArrange(bpaId)),"^",43)="A" s value="是"
	.;e  i $p($g(^DHCBPArrange(bpaId)),"^",43)="" s value=$p(^PAPER(papmiId,"ALL"),"^",12)
	i type="bpaConsumable" d //透析器(主、附加)
		.s tRowid=0
		.f  s tRowid=$o(^DHCBPArrangeConsumable(0,"Arrange",bpaId,tRowid)) q:tRowid=""  d
			..q:($lg(^DHCBPArrangeConsumable(tRowid),6)="Y")
			..s consumableType=$lg(^DHCBPArrangeConsumable(tRowid),3)
			..q:(consumableType="R")
			..s consumableId=$lg(^DHCBPArrangeConsumable(tRowid),2)
			..q:(consumableId="")
			..s tBPCCType=$lg(^DHCBPC("Consumable",consumableId),3)
			..q:(tBPCCType'="D")&&(tBPCCType'="F")
			..s value=$lg(^DHCBPC("Consumable",consumableId),2)	
	
	i type="changedConsumable" d //更换透析器
		.s tRowid=0
		.f  s tRowid=$o(^DHCBPArrangeConsumable(0,"Arrange",bpaId,tRowid)) q:tRowid=""  d
			..q:($lg(^DHCBPArrangeConsumable(tRowid),6)="Y")
			..s consumableType=$lg(^DHCBPArrangeConsumable(tRowid),3)
			..q:(consumableType'="R")
			..s consumableId=$lg(^DHCBPArrangeConsumable(tRowid),2)
			..q:(consumableId="")
			..s tBPCCType=$lg(^DHCBPC("Consumable",consumableId),3)
			..q:(tBPCCType'="D")&&(tBPCCType'="F")
			..s value=$lg(^DHCBPC("Consumable",consumableId),2)	
	i type="replacedPipe" d  //更换管路
		.s tRowid=0
		.f  s tRowid=$o(^DHCBPArrangeConsumable(0,"Arrange",bpaId,tRowid)) q:tRowid=""  d
			..q:($lg(^DHCBPArrangeConsumable(tRowid),6)="Y")
			..s consumableType=$lg(^DHCBPArrangeConsumable(tRowid),3)
			..q:(consumableType'="R")
			..s consumableId=$lg(^DHCBPArrangeConsumable(tRowid),2)
			..q:(consumableId="")
			..s tBPCCType=$lg(^DHCBPC("Consumable",consumableId),3)
			..q:(tBPCCType'="O")
			..s value=$lg(^DHCBPC("Consumable",consumableId),2)	
	
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value

	i type="bpaId" s value=bpaId
	//数值型
	i type="BPPreInterval" d
		.s value=##class(web.DHCBPCom).GetPreBpaIdInterval(bpaId)
		.//w "Interval="_value,!
	i type="24BPPre" s value=##class(web.DHCCLScore).GetFYQ(bpaId,fdate,24)
	i type="LeaveDay" d
		.q:$p(^DHCBPArrange(bpaId),"^",43)=""
		.s value=(outDate-inDate)+1
		.//s value=outDate-inDate
	i type="LeaveHour" d
		.q:$p(^DHCBPArrange(bpaId),"^",43)=""
		.s value=bpHour
	i (value'="")&(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^")) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value
	
	// 复杂计算的
	i type="wardDesc" d
	.s wardDesc=$p(^PAWARD(+bpBedId),"^",2)
	.s value=$p(wardDesc,"-",2)	
	e  i type="MainDoctor" d
	.s docID=$P($g(^DHCBPArrange(bpaId)),"^",29)
	.q:docID=""
	.s value=$p(##class(web.DHCClinicCom).GetUserTypeName(docID),"^",2)
	e  i type="ResidentDoctor" d
	.s docID=$P($g(^DHCBPArrange(bpaId)),"^",28)
	.q:docID=""
	.s value=$p(##class(web.DHCClinicCom).GetUserTypeName(docID),"^",2)
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	q:(value'="") value
	
	i (type'="") d  //扩展表
		.s arrangeExtendValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,type)
		.i (arrangeExtendValue'="") s value= $p(arrangeExtendValue,$c(3),1)
			
	i (value'="")&(needNote'="")&(needNote'[value) s value=""
	i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s value=""	
	//q:(value'="") value
	q value
}

ClassMethod SetSumStr(sumStr, sumType, pos, value)
{
	q:sumType="" sumStr
	i sumType="Sum" s $p(sumStr,"^",pos)=$p(sumStr,"^",pos)+value
	i sumType="Times",value'="" s $p(sumStr,"^",pos)=$p(sumStr,"^",pos)+1
	i sumType="Average",value'="" d
		.s curStr=$p(sumStr,"^",pos)
		.s $p(curStr,"/")=$p(curStr,"/")+value
		.s $p(curStr,"/",2)=$p(curStr,"/",2)+1
		.s $p(sumStr,"^",pos)=curStr
		.q:curStr=""
		.//w sumStr_"    curStr="_curStr,!
	i sumType="Max",value>$p(sumStr,"^",pos) s $p(sumStr,"^",pos)=value	
	q sumStr
}

/// w ##class(web.DHCBPStat).GetBPTestResult(7,6,126,"",$h-20,$h-1)
/// w ##class(web.DHCBPStat).GetBPTestResult(11,6,126,"",$h-100,$h-1)
ClassMethod GetBPTestResult(bpciId, bpciiSub, bpprId = "", bpaId = "", fDate = "", tDate = "")
{
	s type=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
	s labDesc=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),2)
	s dataField=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),6) //显示字段
	s minQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),8)
	s maxQty=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),9)
	s needNote=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),10) //数据的筛选
	s refBpciiSub=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),18) //
	s refValue=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),19)
	s sumType=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),24) //汇总用

	s isSingle=1
	i (dataField["Average")||(dataField["DateTime")||(dataField["TestSet")||(dataField["TestCode")||(dataField["PreBPAverage")||(dataField["PostBPAverage") d
		.s isSingle=0
	s i=0,testQty="",testQtyStr=""
	s testCodeList=$lg(^DHCBPCInquiry(bpciId,"I",bpciiSub),1)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	
	s tmpDataField=dataField
	i ("^Min^Max^FirstDT^MinDT^MaxDT^First^touchQty^")'[("^"_dataField_"^") s tmpDataField=""
	
	s STX=$c(2)
	s ETX=$c(3)
	s value="",sum=0,retStr=""
	f j=1:1:$l(testCodeList,"^")  d
		.s testCode=$p(testCodeList,"^",j)
		.q:testCode=""
		.;i bpciiSub=9 w "开始"_bpprId_"/"_testCode,!
		.;i bpciiSub=9 s dataField=""
		.;s ^dhctmpmfc(regNo,testCode,labDesc,0)=regNo_"/"_testCode_"/"_fDate_"/"_"0"_"/"_tDate_"/"_"0"_"/"_isSingle		
		.s testStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, fDate, "0", tDate, "23:59", isSingle,needNote,tmpDataField)		
		.;s ^dhctmpmfc(regNo,testCode,labDesc,j)=testStr_"/"_tmpDataField
		.;w bpciId_"/"_bpciiSub_"/"_"testStr=          "_testStr,!		
		.//i testStr[">" b
		.k testResultList
		.f k=1:1:$l(testStr,ETX) d
			..i k>195 s retStr=retStr_"#"_"等等",k=$l(testStr,ETX) q  //防止String长度报错(两组时单组限制)
			..s tmpStr=$p(testStr,ETX,k)
			..q:tmpStr=""
			..;i dataField="" s tmpStr=$p(tmpStr,STX)
			..;b ;datetime
			..;i dataField="DateTime" s ^dhctmpmfc(regNo,labDesc,"tmpStr",k,0)=tmpStr
			..i dataField="DateTime" d
				...i $p(tmpStr,STX,4)="" s tmpStr=""
				...e  i $p(tmpStr,STX,4)'="" s tmpStr=$zd($p(tmpStr,STX,4))_" "_$zt($p(tmpStr,STX,5),2)				
			..;b ;datetimevalue
			..i dataField="TestSet" d
				...s tmpStr=$p(tmpStr,STX,12)
				...q:tmpStr=""
				...s oeoriSub=$p(tmpStr,"||",2)
				...q:oeoriSub=""
				...;s ^dhctmpmfc(regNo,labDesc,"TestSet",k,0)=tmpStr
				...;s tmpStr=$p(^TTAB("TS",tmpStr),"\")
				...s tmpStr=$p($g(^OEORD(+tmpStr,"I",oeoriSub,1)),"^",2)
				...q:tmpStr=""
				...s arcimSub=$p(tmpStr,"||",2)
				...s tmpStr=$p($g(^ARCIM(+tmpStr,arcimSub,1)),"^",2)	
			..i dataField="TestCode" d
				...s tmpStr=$p(tmpStr,STX,7)
				...q:tmpStr=""
				...s tmpStr=$p(^TTAB("TC",tmpStr),"\")
			..s qty=$p(tmpStr,STX)
			..;i dataField="DateTime" s ^dhctmpmfc(regNo,labDesc,"qty",k)=qty
			..;w "before:"_qty,!
			..i $p(qty,">")="" s qty=$p(qty,">",2) //针对PTH数据有非数值型的">2500"
			..;w "after"_qty,!
			..i dataField="Average" s sum=sum+qty //$p(tmpStr,STX)
			..i (dataField="PreBPAverage")!(dataField="PostBPAverage") d
				...s testDate=$p(tmpStr,STX,4)
				...//w tmpStr_"   preBP/"_testDate,!
				...q:testDate=""
				...s testResultList(testDate)=$g(testResultList(testDate))+1
				...s testResultList(testDate,+$p(tmpStr,STX,5))=qty //$p(tmpStr,STX)
			..i retStr="" s retStr=qty
			..e  s retStr=retStr_"#"_qty
			..;i dataField="DateTime" s ^dhctmpmfc(regNo,labDesc,"retStr",k)=retStr	
			..;b ;retStr
		.i dataField="Average",testStr'="",k>0 s retStr=$fn(sum/k,"",2)
		.i (dataField="PreBPAverage")!(dataField="PostBPAverage") d
			..//zw testResultList
			..s testDate="",sum="",preCount=0,retStr=""
			..f  s testDate=$o(testResultList(testDate)) q:testDate=""  d
				...s testTime=$o(testResultList(testDate,""))
				...q:testTime=""
				...i (dataField="PreBPAverage") d
					....s sum=sum+testResultList(testDate,testTime)
					....s preCount=preCount+1
				...e  d //透析后
					....s testTime=$o(testResultList(testDate,testTime))
					....q:testTime=""
					....s sum=sum+testResultList(testDate,testTime)
					....s preCount=preCount+1
			..i preCount'=0 s retStr=$fn(sum/preCount,"",2)
			..//w retStr,!
		.q:(minQty'="")&(maxQty'="")&((retStr<minQty)!(retStr>maxQty))
		.s value=retStr
	//w sum,"/"_value,!
	//b ;value
	q value
}

/// creater: mfc 20141022
/// input:	inquiryFromDate开始日期,inquiryToDate结束日期,inDateTime入病区日期时间,outDateTime出病区日期时间,arcimIdStr医嘱IDID串,oeordId医嘱项目ID,SpecimenStr采集标本ID,dataField获取结果格式(医嘱ID+日期时间),ordStat医嘱状态(E执行V审核)
/// output:	oeoriId医嘱单项号,oeoriSttDat下医嘱日期,oeoriSttTim下医嘱时间
/// Desc：	返回医嘱ID或者下医嘱日期时间，"#"分割的多条结果，"！"分割医嘱单项号和下医嘱日期时间
ClassMethod getOeOrdAndDateTime(inquiryFromDate, inquiryFromTime, inquiryToDate, inquiryToTime, inDateTime = "", outDateTime = "", arcimIdStr, oeordId, SpecimenStr = "", dataField = "oerIdAndDT", ordStat = "E")
{
	q:(inquiryFromDate="")||(inquiryToDate="")||(arcimIdStr="") ""
	q:(oeordId="") ""
	;s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	;s inquiryFromTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryFromTime)
	;s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	;s inquiryToTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryToTime)
	s ArcimDescDT=""
	f i=1:1:$l(arcimIdStr,"^") d
	.s arcimId=$p(arcimIdStr,"^",i)
	.q:arcimId=""
	.s oeoriSttDate=""
	.;s ^tempmfc(arcimId)=oeordId_"^"_arcimId
	.i (inquiryFromDate'="") s oeoriSttDate=inquiryFromDate-1
	.f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")  d
	..i (inquiryFromDate'="")&(oeoriSttDate>inquiryToDate) s oeoriSttDate=$h+10000 //退出
	..s oeoriSub=""
	..f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
	...q:'$d(^OEORD(oeordId,"I",oeoriSub))
	...s oeoriId=oeordId_"||"_oeoriSub
	...q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""
	...s Specimen=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^",1)
	...i (SpecimenStr'="")&&($l(SpecimenStr,"!")>1) q:(SpecimenStr'="")&&(("^"_$p(SpecimenStr,"!",2)_"^")[("^"_Specimen_"^"))
	...i (SpecimenStr'="")&&($l(SpecimenStr,"!")=1) q:(SpecimenStr'="")&&(("^"_SpecimenStr_"^")'[("^"_Specimen_"^"))
	...s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	...;q:(("E"'[ordStatCode))&&("V"'[ordStatCode)
	...q:ordStatCode'=ordStat								
	...s oeoriSttDat=$p(^OEORD(oeordId,"I",oeoriSub,"ST",1),"^",1) //下医嘱日期
	...s oeoriSttTim=$p(^OEORD(oeordId,"I",oeoriSub,"ST",1),"^",2)
	...q:((inquiryFromDate'="")&&(inquiryFromDate>oeoriSttDat))||((inquiryToDate'="")&&(inquiryToDate<oeoriSttDat))
	...q:((inquiryFromDate=oeoriSttDat)&&(inquiryFromTime'="")&&(inquiryFromTime>oeoriSttTim))||((inquiryToDate=oeoriSttDat)&&(inquiryToTime'="")&&(inquiryToTime<oeoriSttTim))
	...s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)					
	...i inDateTime="" d	
	....s inDateTimeStr=##class(web.DHCClinicCom).GetWardInDateTime("",bpprId,"","","^","D")
	....q:inDateTimeStr=""		
	....s inDate=$p(inDateTimeStr,"^"),inTime=$p(inDateTimeStr,"^",2)
	....s inDateTime=inDate+(inTime/100000)
	...i outDateTime="" d
	....s outDateTimeStr=##class(web.DHCBPCom).GetWardOutDateTime("",bpprId,"","","^","D")
	....i outDateTimeStr="" d
	.....s outDateTime=$h+($p($h,",",2)/100000)
	....e  d
	.....s outDate=$p(outDateTimeStr,"^"),outTime=$p(outDateTimeStr,"^",2)
	.....s outDateTime=outDate+(outTime/100000)
	...q:oeoriSttDateTime<inDateTime
	...q:oeoriSttDateTime>outDateTime							 					
	...i (dataField["oerIdAndDT") d
	....i ArcimDescDT="" s ArcimDescDT=oeoriId_"!"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
	....e  s ArcimDescDT=ArcimDescDT_"#"_oeoriId_"!"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
	q ArcimDescDT
}

/// creater: mfc 20141022
/// input:	NowDate日期,NowTime时间,operAS运算符("+"向后算时间、"-"向前算时间),HourV前、后几小时
/// output:	returnDate前、后几小时日期,returnTime前、后几小时时间
/// Desc：	根据输入的日期时间,换算出HourV小时前、后的日期时间,根据operAS运算符决定往前还是往后
/// w ##class(web.DHCBPStat).getPreDateTime("2014-10-30","01:00","-","3")
ClassMethod getPreDateTime(NowDate, NowTime, operAS, HourV = 0)
{
	q:NowDate=""||NowTime=""
	s NowDate=##class(web.DHCClinicCom).ConvertToDateH(NowDate)
	s NowTime=##class(web.DHCClinicCom).ConvertToTimeH(NowTime)
	s returnDate="",returnTime=""
	i operAS="-" d
	.s returnDate=NowDate
	.s returnTime=NowTime-(HourV*3600)
	.i returnTime<0 d
	..s returnDate=returnDate+(returnTime\86400)-1
	..s returnTime=returnTime#86400
	..;s returnDate=returnDate-1
	..;s returnTime=86400+returnTime
	i operAS="+" d
	.s returnDate=NowDate
	.s returnTime=NowTime+(HourV*3600)
	.i returnTime>=86400 d
	..s returnDate=returnDate+(returnTime\86400)
	..s returnTime=returnTime#86400
	q returnDate_" "_returnTime
}

/// 功能:通过医嘱名称,获取相关医嘱的开始时间
/// 入参:arcimDesc医嘱名称,EpisodeID就诊号
/// 返回:retstr医嘱开始时间串，通过"^"分割
ClassMethod insertOrOutTube(arcimDesc As %String, EpisodeID As %String) As %String
{
	s arcimId=0,arcimRowId="",retstr=""
    f  s arcimId=$o(^ARCIM(arcimId)) q:arcimId=""  d
    .q:$p($g(^ARCIM(arcimId,1,1)),"^",2)'[arcimDesc       
	.s arcimRowId=arcimId_"||1"	 
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))				
    s oeoriSttDate=""
    f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimRowId,oeoriSttDate)) q:(oeoriSttDate="")  d
    .i retstr="" s retstr=oeoriSttDate
    .e  s retstr=retstr_"^"_oeoriSttDate
    q retstr
}

/// w ##class(web.DHCBPStat).FindCLScoreNumber("2014-02-01","2014-02-28","56^2166","")
/// 创建：Add mfc 20140213
/// 说明：获取月收治患者数量和评分
/// 功能：根据数量，得出评分
/// 入参：fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,arcimDesc:医嘱名称,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回：以"$"分割的记录
ClassMethod FindCLScoreNumber(fromDate As %String, toDate As %String, ctlocIdStr As %String, CTMUDesc As %String = "") As %String
{
	s retstr=""
	s ArrSum=0 //计算监护病人总数	
	s CTMUDesc=CTMUDesc //医生所在分组
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	f date=fromDate:1:toDate d
	.s bpprId=""
    .f  s bpprId=$o(^DHCBPPatRegister(0,"SDate",date,bpprId)) q:bpprId=""  d
    ..q:'$d(^DHCBPPatRegister(bpprId))    
    ..s EpisodeID=$p(^DHCBPPatRegister(bpprId),"^",1)
	..q:EpisodeID=""
	..s inDateTime=##class(web.DHCClinicCom).GetWardInDateTime("",bpprId,"","","^","D")
	..s outDateTime=##class(web.DHCBPCom).GetWardOutDateTime("",bpprId,"","","^","D")	
	..s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	..i outDateTime'="" s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	..e  s WardoutDate="",WardoutTime=""
	..;q:(date<WardinDate)||((outDateTime'="")&&(date>WardoutDate))
	..&SQL(select BPR_RowId into :tableFlag from DHC_BP_Record where BPR_BPArrange_Dr=:bpprId)
	..q:(tableFlag="")  //数据为空
	..s arrsttime=$p(^DHCBPPatRegister(bpprId),"^",8)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s bpBedId=$p($g(^DHCBPPatRegister(bpprId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+bpBedId)_"^"))
	..s wardLocId=$p(^PAWARD(+bpBedId),"^",5)	
	..s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s cTGroupDesc="",bedDoctorDesc=""
	..s CTLocDr=$p(^DHCBPPatRegister(bpprId),"^",2)
	..s rowid=""	
	..f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	...s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	...q:LocID'=CTLocDr
	...s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	...q:bedDoctorDr=""	
	...s CTChildsub="",MUCPChildsub=""  //分组查询
	...f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ....f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    .....s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    .....q:MUCPDoctorDR'=bedDoctorDr
    .....s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    .....s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
    ..q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
    ..i retstr="" s retstr=EpisodeID_"^"_bpprId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc
	..e  s retstr=retstr_"$"_EpisodeID_"^"_bpprId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc	
	..s ArrSum=ArrSum+1  ///月收治患者数量	
	s ArrNumberScore= 20+(ArrSum-49) //月收治患者数量评分 基础分20   
    s ^tempApacheScore("ArrNumber")="月收治患者数量"_"^"_"20"_"^"_ArrNumberScore_"^"_ArrSum
   q retstr
}

/// ##class(web.DHCBPStat).FindBedItem("56^2166")
/// 创建： Add mfc 20140213
/// 功能：根据病区索引获取床位索引
/// 入参：ctlocIdStr病区，"^"分割
/// 返回："^"分割的床位索引
ClassMethod FindBedItem(ctlocIdStr = "") As %String
{
	q:ctlocIdStr=""
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	q wardIdStr
}

/// w ##class(web.DHCBPStat).FindCLScoreRecord("2014-03-01","2014-03-31","","56^2166","")
/// 创建： Add mfc 20140213
/// 功能:获取相关监护安排记录
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割的，获取有数据的监护安排
ClassMethod FindCLScoreRecord(fromDate As %String, toDate As %String, RecordItemId As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""	
	i RecordItemId="" s RecordItemId="6385" //ApacheII默认医嘱	
	s CTMUDesc=CTMUDesc //医生所在分组
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s wardIdStr=..FindBedItem(ctlocIdStr)	
	s bpaIdList=""
	f date=fromDate:1:toDate d
	.s bpaId=""
	.f  s bpaId=$o(^DHCBPRecord(0,"SttDateTime",date,bpaId)) q:bpaId=""  d
	..q:'$d(^DHCBPArrange(bpaId))
	..i bpaIdList="" s bpaIdList=bpaId
	..e  i (("^"_bpaIdList_"^")'[("^"_bpaId_"^")) s bpaIdList=bpaIdList_"^"_bpaId
	f i=1:1:$l(bpaIdList,"^") d
	.s bpaId=$p(bpaIdList,"^",i)   
    .s EpisodeID=$p(^DHCBPArrange(bpaId),"^",1)
	.q:EpisodeID=""
	.s inDateTime=##class(web.DHCClinicCom).GetWardInDateTime("",bpaId,"","","^","D")
	.s outDateTime=##class(web.DHCBPCom).GetWardOutDateTime("",bpaId,"","","^","D")	
	.s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	.i outDateTime'="" s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	.e  s WardoutDate="",WardoutTime=""	
	.q:((outDateTime'="")&&(WardoutDate<fromDate))||(WardinDate>toDate)
	.;&SQL(select BPR_RowId into :tableFlag from DHC_BP_Record where BPR_BPArrange_Dr=:bpaId)
	.;q:(tableFlag="")  //数据为空
	.s arrstdate=$p(^DHCBPArrange(bpaId),"^",6)
	.s arrsttime=$p(^DHCBPArrange(bpaId),"^",8)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s bpBedId=$p($g(^DHCBPArrange(bpaId)),"^",4)
	.q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+bpBedId)_"^"))
	.s wardLocId=$p(^PAWARD(+bpBedId),"^",5)	
	.s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s cTGroupDesc="",bedDoctorDesc=""
	.s CTLocDr=$p(^DHCBPArrange(bpaId),"^",2)
	.s rowid=""	
	.f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	..s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	..q:LocID'=CTLocDr
	..s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	..q:bedDoctorDr=""	
	..s CTChildsub="",MUCPChildsub=""  //分组查询
	..f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ...f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    ....s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    ....q:MUCPDoctorDR'=bedDoctorDr
    ....s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    ....s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2) 
    .q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
	.;w EpisodeID_"^"_bpaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc_"$"	
	.i retstr="" s retstr=EpisodeID_"^"_bpaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(arrstdate,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc
	.e  s retstr=retstr_"$"_EpisodeID_"^"_bpaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(arrstdate,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc	
	q retstr
}

/// w ##class(web.DHCBPStat).FindBPOut("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:死亡数量病人数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^bpaId^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindBPOut(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""	
	s outSum=0 //死亡数量
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s bpaId=$p(clScoreRecord,"^",2)
	.q:bpaId=""
	.s WardinDate=$zdh($p($p(clScoreRecord,"^",4)," ",1),3)
	.s WardinTime=$zth($p($p(clScoreRecord,"^",4)," ",2))
	.s WardoutDate=$zdh($p($p(clScoreRecord,"^",5)," ",1),3)
	.s WardoutTime=$zth($p($p(clScoreRecord,"^",5)," ",2))	
	.s EpisodeID=$p(^DHCBPArrange(bpaId),"^",1)
	.q:EpisodeID=""
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s outDate=$p(^PAPER(papmiId,"ALL"),"^",13) //死亡日期
	.s outTime=$p(^PAPER(papmiId,"ALL"),"^",8) //死亡时间
	.i outDate'="" d 
    ..i ((WardinDate<outDate)&&(WardoutDate>outDate)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr=EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9) 
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ..i ((WardinDate=outDate)&&(WardinTime<=outTime)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr= EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ..e  i ((WardoutDate=outDate)&&(WardoutTime>=outTime)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr=EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    s OutNumberScore= 20-(outSum-1)*2  //月死亡病例数 基础分20
    s ^tempApacheScore("OutNumber")="月死亡病例数"_"^"_"20"_"^"_OutNumberScore_"^"_outSum    
	q retstr
}

/// w ##class(web.DHCBPStat).FindInbedSum("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:压床病例数（入BP 4W以上)，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^bpaId^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindInbedSum(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""
	s inbedSum=0 //压床病例数（入BP 4W以上)
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s bpaId=$p(clScoreRecord,"^",2)
	.q:bpaId=""
	.s WardinDate=$zdh($p($p(clScoreRecord,"^",4)," ",1),3)
	.s WardinTime=$zth($p($p(clScoreRecord,"^",4)," ",2))
	.s WardoutDate=$zdh($p($p(clScoreRecord,"^",5)," ",1),3)
	.s WardoutTime=$zth($p($p(clScoreRecord,"^",5)," ",2))	
    .//压床病例数（入BP 4W以上)
    .s bpHour=(WardoutTime-WardinTime)\3600+((WardoutDate-WardinDate)*24)
    .s bpDay=bpHour\24
    .i bpDay>28 d
    ..s inbedSum=inbedSum+1
    ..;w EpisodeID_"^"_bpaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_bpDay_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"$"
	..i retstr="" s retstr=$p(clScoreRecord,"^",1)_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_bpDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
	..e  s retstr=retstr_"$"_$p(clScoreRecord,"^",1)_"^"_bpaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_bpDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
	s inbedSumScore=5-(inbedSum-1)*2 //压床病例数（入BP 4W以上）基础分5
	s ^tempApacheScore("inbedSum")="压床病例数(入BP 4W以上)"_"^"_"5"_"^"_inbedSumScore_"^"_inbedSum
    q retstr
}

/// w ##class(web.DHCBPStat).GetDocGroup(2150,"")
ClassMethod GetDocGroup(bpaId As %String = "", CTMUDesc As %String = "") As %String
{
	s cTGroupDesc="",bedDoctorDesc=""
	s CTLocDr=$p(^DHCBPArrange(bpaId),"^",2)
	s EpisodeID=$p(^DHCBPArrange(bpaId),"^",1)
	s rowid=""	
	f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	.q:LocID'=CTLocDr
	.s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	.q:bedDoctorDr=""	
	.s CTChildsub="",MUCPChildsub=""  //分组查询
	.f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ..f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    ...s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    ...q:MUCPDoctorDR'=bedDoctorDr
    ...s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    ...s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
    q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
    q cTGroupDesc
}

/// w ##class(web.DHCBPStat).CompareInBedTime(2150,2161,"","")
ClassMethod CompareInBedTime(bpaId As %String = "", bpaId2 As %String = "", patName As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr="",bpHour=""
	s againSum=0 //48小时再转入BP病例数	
	s inDateTime=##class(web.DHCClinicCom).GetWardInDateTime("",bpaId,"","","^","D")
    s outDateTime=##class(web.DHCBPCom).GetWardOutDateTime("",bpaId,"","","^","D")
    s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	s WardoutDate=$p(outDateTime,"^",1),WardoutTime=	$p(outDateTime,"^",2)
	s bpBedId=$p($g(^DHCBPArrange(bpaId)),"^",4)
	s wardLocId=$p(^PAWARD(+bpBedId),"^",5)
	s EpisodeID=$p(^DHCBPArrange(bpaId),"^",1)
	s cTGroupDesc=..GetDocGroup(bpaId,CTMUDesc)
	s inDateTime2=##class(web.DHCClinicCom).GetWardInDateTime("",bpaId2,"","","^","D")
    s outDateTime2=##class(web.DHCBPCom).GetWardOutDateTime("",bpaId2,"","","^","D")
    s WardinDate2=$p(inDateTime2,"^",1),WardinTime2=	$p(inDateTime2,"^",2)
	s WardoutDate2=$p(outDateTime2,"^",1),WardoutTime2=	$p(outDateTime2,"^",2)
	s bpBedId2=$p($g(^DHCBPArrange(bpaId2)),"^",4)
	s wardLocId2=$p(^PAWARD(+bpBedId2),"^",5)
	s cTGroupDesc2=..GetDocGroup(bpaId2,CTMUDesc)
    i WardoutDate<WardinDate2 s bpHour=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24)
    i bpHour<=48  d 
    .s againSum=againSum+1
    .i retstr="" s retstr=EpisodeID_"^"_bpaId_"^"_patName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"^"_bpaId2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId2)),"^",2)_"^"_cTGroupDesc2 
    .e  s retstr=retstr_"$"_EpisodeID_"^"_bpaId_"^"_patName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"^"_bpaId2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId2)),"^",2)_"^"_cTGroupDesc2 
    s againSumScore=5-(againSum-0)*2 //48小时再转入BP病例数(非预期）基础分5
    s ^tempApacheScore("againSum")="48小时再转入BP病例数(非预期)"_"^"_"5"_"^"_againSumScore_"^"_againSum
    q retstr
}

/// w ##class(web.DHCBPStat).FindBeginInLoc("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:48小时再转入BP病例数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^bpaId^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindBeginInLoc(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr="",EpisodeIDList=""
	s againSum=0 //48小时再转入BP病例数
	s wardIdStr=..FindBedItem(ctlocIdStr)	
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)	
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)	
	.s bpaId=$p(clScoreRecord,"^",2)
	.q:bpaId=""
	.s EpisodeID=$p(^DHCBPArrange(bpaId),"^",1)	
	.q:(EpisodeIDList[EpisodeID)	
	.//48小时再转入BP病例数(非预期）
    .s bpaId2="",bpaIdList=""
    .f  s bpaId2=$o(^DHCBPArrange(0,"Adm",EpisodeID,bpaId2)) q:bpaId2=""  d
    ..;q:bpaId>=bpaId2
    ..q:'$d(^DHCBPArrange(bpaId2))
    ..i bpaIdList="" s bpaIdList=bpaId2
    ..e  s bpaIdList=bpaIdList_"^"_bpaId2
    .f i=1:1:$l(bpaIdList,"^") d
    ..s bpaId3=$p(bpaIdList,"^",i)  //当前安排记录
    ..s bpaIdNext=$p(bpaIdList,"^",i+1) //下一次安排
    ..q:bpaIdNext=""
    ..s bpHour3=""    
	..s bpBedId3=$p($g(^DHCBPArrange(bpaId3)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+bpBedId3)_"^"))
	..s bpBedIdNext=$p($g(^DHCBPArrange(bpaIdNext)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+bpBedIdNext)_"^"))	
	..&SQL(select BPR_RowId into :tableFlag2 from SQLUSER.DHC_BP_Record where BPR_BPArrange_Dr=:bpaId3)
	..q:(tableFlag2="")
	..&SQL(select BPR_RowId into :tableFlag2 from SQLUSER.DHC_BP_Record where BPR_BPArrange_Dr=:bpaIdNext)
	..q:(tableFlag2="")
	..i retstr="" s retstr=..CompareInBedTime(bpaId3,bpaIdNext,$p(clScoreRecord,"^",3))
	..e  s retstr=retstr_"$"_..CompareInBedTime(bpaId3,bpaIdNext,$p(clScoreRecord,"^",3))
    ..;i WardoutDate<WardinDate2 s bpHour3=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24) 
    ..;i inDateTime>=inDateTime2 s bpHour2=(WardoutTime-WardinTime2)\3600+((WardoutDate-WardinDate2)*24) 
    ..;i bpHour3<=48  d 
    ...;s againSum=againSum+1
    ...;w EpisodeID_"^"_bpaId_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_bpaId2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"$"
	.s EpisodeIDList= EpisodeIDList_"^"_EpisodeID
	q retstr
}

/// Add mfc 20140226
/// 根据统计名称获取相关列名(显示自动)自动获取
/// 入参:ColumnHeaderText统计项目名称
/// 返回：TColumnTitle统计项目名称，TOrderClassName统计主项(科室)类名,TOrderMethodName统计主项的方法
///       TSubClassName统计字段(子项)类名,TSubMethodName统计字段(子项)方法
/// 说明：ClassOrMetNameList讲统计项目名称、主项类名、主项方法、统计字段类名(子项)、统计字段方法
///      多个用"$"分割,单个用"^"分割
/// d ##class(%ResultSet).RunQuery("web.DHCBPStat","FindTemplateTotalData","ApacheII")
Query FindTemplateTotalData(BPCIRowid As %String, bpaId As %String) As %Query(ROWSPEC = "ColumnTitle:%String") [ SqlProc ]
{
}

ClassMethod FindTemplateTotalDataExecute(ByRef qHandle As %Binary, BPCIRowid As %String, args As %String) As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCBPStat","FindTemplateTotalData",5,"1^2014-04-01 14-57-54^2014-04-15 14-58-19")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s icirowid=0,datalb=""
	s bpaId=+args
	q:'##class(User.DHCBPCInquiry).%ExistsId(BPCIRowid)
	s obj=##class(User.DHCBPCInquiry).%OpenId(BPCIRowid)
	// 生成序号与rowId索引
	s sub=0
	s index=1
	f  s sub=$o(^DHCBPCInquiry(BPCIRowid,"I",sub)) q:sub=""  d
	.s itemRowId=BPCIRowid_"||"_sub
	.q:'##class(User.DHCBPCInquiryItem).%ExistsId(itemRowId)
	.s itemObj=##class(User.DHCBPCInquiryItem).%OpenId(itemRowId)
	.q:('itemObj.BPCIIIsDisplay)	
	.s TmpSeqRowId(itemObj.BPCIISeqNo)=index	
	.w index
	.s index=index+1	
	.b ;type	
	i obj.BPCIDataType="P" d
	.
	.d FindDataByRecordId(BPCIRowid,bpaId)
	e  i obj.BPCIDataType="M" d
	.d FindDataByLocId(BPCIRowid,args)
	e  d
	.;b ;type=""
	.f  s icirowid=$o(^DHCBPInquiry(BPCIRowid,icirowid)) q:icirowid=""  d
	..q:+icirowid=0
	..q:(^DHCBPInquiry(BPCIRowid,icirowid)="")
	..s datalb=""
	..s seq=""
	..f  s seq=$O(TmpSeqRowId(seq)) q:seq=""  d
	...s index=$g(TmpSeqRowId(seq))
	...s InquiryData=$p($g(^DHCBPInquiry(BPCIRowid,icirowid)),"^",index)
	...i InquiryData="" s InquiryData=" "
	...i datalb="" s datalb=InquiryData
	...e  s datalb=datalb_"^"_InquiryData
	..s datalb=$lb(datalb)
	..d OutputRow11
	..

	d obj.%Close()
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow11
	set Data=datalb
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
FindDataByRecordId(BPCIRowid,bpaId,argType="bpaId",scope=0,fromDate=0,fromTime=0,toDate=0,toTime=0)
	s rset=##class(%ResultSet).%New("web.DHCBPStat:FindDataByRecordId")
	s ret=""	
	do rset.Execute(BPCIRowid,bpaId,argType,scope,fromDate,fromTime,toDate,toTime)
	while (rset.Next()) {
	s data=rset.GetData(1)
	s datalb=$lb(data)
	d OutputRow11
	}
	d rset.Close()
	q
FindDataByLocId(BPCIRowid,args)
	s stDate=$p(args,"^",2) s stDate=$p(stDate," ",1)
	s endDate=$p(args,"^",3) s endDate=$p(endDate," ",1)
	q:'##class(User.DHCBPCInquiry).%ExistsId(BPCIRowid)
	s itemObj=##class(User.DHCBPCInquiry).%OpenId(BPCIRowid)
	d itemObj.%Close()
	s tagWardId=itemObj.BPCICtlocDr
	q:tagWardId=""
	s linkSub=""
	s scope=0
	i $d(^DHCBPPara(0,"Ctloc",tagWardId)) d
	.b ;若在科室模板中已配置
	.d FindDataByRecordId(BPCIRowid,tagWardId,"wardId",scope,stDate,0,endDate,0)
	e  d
	.;科室模板中未配置,认为是科室,查找出相应病区
	.f  s sub=$O(^CTLOC(tagWardId,"LINK",sub)) q:sub=""  d
	..q:sub=""
	..s linkWardId=^CTLOC(tagWardId,"LINK",sub)
	..q:'$d(^DHCBPPara(0,"Ctloc",linkWardId))
	..b ;why
	..d FindDataByRecordId(BPCIRowid,linkWardId,"wardId",scope,stDate,0,endDate,0)
	q

	// 查询出有数据的bpaId
	s stDate=##class(web.DHCClinicCom).ConvertToDateH(stDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s recordId=6737
	q:'##class(User.DHCBPCInquiry).%ExistsId(BPCIRowid)
	s itemObj=##class(User.DHCBPCInquiry).%OpenId(BPCIRowid)
	d itemObj.%Close()
	s tagWardId=itemObj.BPCICtlocDr
	w "stDate:",stDate,!
	b ;date
	f  s stDate=$O(^DHCBPRecord(0,"RecordItem",recordId,stDate)) q:((stDate="")||(stDate>endDate))  d
	.s id=""
	.;w "date:",stDate,!
	.f  s id=$O(^DHCBPRecord(0,"RecordItem",recordId,stDate,id)) q:id=""  d
	..q:'##class(User.DHCBPArrange).%ExistsId(id)
	..s arrangeObj=##class(User.DHCBPArrange).%OpenId(id)
	..s bpBedId=arrangeObj.BPABedDr
	..d arrangeObj.%Close()
	..s wardId=$P($g(^PAWARD(+bpBedId)),"^",5)
	..q:tagWardId'=wardId
	..w "bpaId:",id,!
	..s TMPArrangId(id)=id
	s bpaId=""
	f  s bpaId=$O(TMPArrangId(bpaId)) q:bpaId=""  d
	.d FindDataByRecordId(BPCIRowid,bpaId)
}

ClassMethod FindTemplateTotalDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateTotalDataExecute ]
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

ClassMethod FindTemplateTotalDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateTotalDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 返回值格式: Value1^Value1^Value3...
///             Value的是以"^"分隔开的，数量顺序由queryId中配置确定
/// 			用queryId中的查询项目查询，然后以queryId显示项目显示
/// scope       :  查询数据时的查找范围
/// bpaId      : DHC_BP_Arrange的RowId
/// queryIdStr  : 要查询的Id串，是逻辑与的关系，同一时间内包含所以ID才能满足条件
/// displayIdStr: 要显示的ID串
/// fromDate,fromTime: 起始时间点
/// toDate,toTime    : 结束时间点 
///        toDate是0时，查询fromDate的fromTime开始fromDate这一天的数据
/// 查找显示项的时间范围，为0时精确查找
/// d ##class(%ResultSet).RunQuery("web.DHCBPStat","FindDataByRecordId",bpaId,queryId)
Query FindDataByRecordId(queryId, bpaIdOrWardId, argType = "bpaId", scope = 0, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0) As %Query(ROWSPEC = "Items:%String") [ SqlProc ]
{
}

ClassMethod FindDataByRecordIdExecute(ByRef qHandle As %Binary, queryId, bpaIdOrWardId, argType = "bpaId", scope = 0, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	// D ##class(%ResultSet).RunQuery("web.DHCBPStat","FindDataByRecordId",bpaId,quryId)
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s itemNameStr="",queryIdStr="", displayIdStr="",sub=""
	i $ISVALIDNUM(fromDate) d Init

	w "displayIdStr:",displayIdStr,!
	w "queryIdStr:",queryIdStr,!
	
	i ((fromDate)&(toDate=0)) d
	.;查fromdate一天的数据
	.s toDate=fromDate+1
	.s toTime=0
	s daySecs=3600*24
	s fromDateTime=(daySecs*fromDate)+fromTime
	s toDateTime=(daySecs*toDate)+fromTime
	
	s queryIdCount=$l(queryIdStr,"^")
	s diplayIdCount=$l(displayIdStr,"^")
	
	s bpcriId=$p(queryIdStr,"^",1)
	q:bpcriId="" $$$OK
	b ;//////////////////
	// 通过queryIdStr、fromDate、fromTime、fromDate、fromTime找出时间点
	s date=fromDate,time=fromTime
	i fromDate>0 s date=date-1
	i fromTime>0 s time=time-1
	s quit=0
	f  s date=$o(^DHCBPRecord(0,"RecordItem",bpcriId,date)) q:((quit=1)||(date=""))  d
	.i date'=fromDate s time=0
	.i ((toDate'=0)&&(date>toDate)) s quit=1 
	.q:quit=1
	.s bpaId=""
	.f  s bpaId=$o(^DHCBPRecord(0,"RecordItem",bpcriId,date,bpaId)) q:((quit=1)||(date="")||(bpaId=""))  d
	..q:((argType="bpaId")&&(bpaId'=bpaIdOrWardId))
	..s bpBedId=$p($g(^DHCBPArrange(bpaId)),"^",4)  ;不要查询的重症记录
	..s wardId=$P($g(^PAWARD(+bpBedId)),"^",5)
	..w "wardId:",wardId,"bpaId:",bpaId,!
	..q:((argType="wardId")&&(wardId'=bpaIdOrWardId)) ;不是这个病区的退出
	..f  s time=$o(^DHCBPRecord(0,"RecordItem",bpcriId,date,bpaId,time)) q:((quit=1)||(time=""))  d
	...s dateTime=(date*daySecs)+time
	...i ((toDate'=0)&&(dateTime>toDateTime)) s quit=1 b
	...q:quit=1
	...s rowId=""
	...s rowId=$o(^DHCBPRecord(0,"RecordItem",bpcriId,date,bpaId,time,rowId))
	...s status=$$GetStatus(rowId)
	...q:("NE"'[status)
	...s isAll=1
	...f i=2:1:queryIdCount q:(isAll=0)  d
	....s rowId=$o(^DHCBPRecord(0,"RecordItem",bpcriId,date,bpaId,rowId))
	....q:("NE"'[$$GetStatus(rowId))
	....i isAll=1 d
	.....s theID=$p(queryIdStr,"^",i)
	.....s theTime=$o(^DHCBPRecord(0,"RecordItem",theID,date,time))
	.....i theTime="" s isAll=0
	...i isAll=1 d
	....s TimeArray(bpaId,dateTime)=dateTime
	
	// 通过displayIdStr中的ID取各时间点的数据
	s sub="",bpaId=""
	f  s bpaId=$O(TimeArray(bpaId)) q:bpaId=""  d
	.s sub=""
	.f  s sub=$O(TimeArray(bpaId,sub)) q:sub=""  d
	..
	..s dateTime=TimeArray(bpaId,sub)
	..s qDate=dateTime\daySecs
	..s qTime=dateTime#daySecs
	..s regNo=..GetInfoByBpprId(bpaId,"regNo")
	..s valueStr=$$OneTimePoint(bpaId,queryId,qDate,qTime,regNo)
	..s ret=$$OutputRow1(valueStr)
	..w valueStr,!
	..
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Init
	// 按序号排序
	s sub="" f  s sub=$O(^DHCBPCInquiry(queryId,"I",sub)) q:sub=""  d
	.s itemStr=$g(^DHCBPCInquiry(queryId,"I",sub))
	.q:itemStr=""
	.s seqNo=$LG(itemStr,20)
	.s name=$LG(itemStr,2)
	.s isSearch=$LG(itemStr,4)
	.s isDisplay=$LG(itemStr,5)
	.s recordId=$LG(itemStr,1)
	.s fieldStr=$LG(itemStr,6) ; 字段
	.s code=$lg(itemStr,1)
	.s isSingle=$lg(itemStr,7)
	.i recordId'=+recordId s code=recordId s recordId="" s recordId=$O(^DHCBPC("RecordItem",0,"Code",code,recordId))
	.s type=$lg(itemStr,3)
	.s TmpSeq(seqNo)=name_"^"_isSearch_"^"_isDisplay_"^"_recordId_"^"_fieldStr_"^"_type
	.s TmpSeq(seqNo,"Code")=code
	.s TmpSeq(seqNo,"isSingle")=isSingle
	.s TmpSeq(seqNo,"Filed")=fieldStr
	.s TmpSeq(seqNo,"gap")=$LG(itemStr,10)
	.w "seqNo"_seqNo_" "_TmpSeq(seqNo)
	
	s sub="",itemNameStr="" f  s sub=$O(TmpSeq(sub)) q:sub=""  d
	.s itemStr=$g(TmpSeq(sub))
	.q:itemStr=""
	.s name=$p(itemStr,"^",1)
	.s isSearch=$p(itemStr,"^",2)
	.s isDisplay=$p(itemStr,"^",3)
	.s recordId=$p(itemStr,"^",4)
	.s fieldStr=$p(itemStr,"^",5)
	.i name="" s itemNameStr=name
	.e  s itemNameStr=itemNameStr_"^"_name
	.i isDisplay d
	..i displayIdStr="" s displayIdStr=recordId
	..e  s displayIdStr=displayIdStr_"^"_recordId
	.
	.i isSearch d
	..i queryIdStr="" s queryIdStr=recordId
	..e  s queryIdStr=queryIdStr_"^"_recordId
	..	
	q
OneTimePoint(bpaId,bpciId,qDate,qTime,regNo)
	// 返回一个电间点各查寻项目的值
	s dateTime=$zd(qDate,3)_" "_$zt(qTime)
	w "DateTime:",dateTime,!
	s seq="",valueStr=""
	s index=1
	f  s seq=$O(TmpSeq(seq)) q:seq=""  d
	.s itemStr=$g(TmpSeq(seq))
	.q:itemStr=""
	.s isDisplay=$p(itemStr,"^",3)
	.q:('isDisplay)
	.s recordId=$p(itemStr,"^",4)
	.s fieldStr=$p(itemStr,"^",5)
	.s type=$p(itemStr,"^",6)
	.i type="L" d
	..;检验项目
	..s testCode=TmpSeq(seq,"Code")
	..s isSingle=TmpSeq(seq,"isSingle")
	..
	..s STX=$c(2)
	..s ETX=$c(3)
	..s value=##class(web.DHCClinicCom).GetTestResultByScope("", regNo, "", testCode, qDate, qTime,scope, isSingle)
	..s value=$p(value,STX,1)
	..i value'="" 
	.e  i type="R" d
	..;普通项(如血气、PICCO、血糖)
	..s gap=+$g(TmpSeq(seq,"gap"))
	..i gap>0 s scope=gap*60
	..s value=##class(web.DHCBPRecord).GetRecordValueByScope(bpaId,recordId,qDate,qTime,scope)
	..
	.e  i type="P" d
	..s typeName=$g(TmpSeq(seq,"Code"))
	..s value=..GetInfoByBpprId(bpaId,typeName)
	..
	.i fieldStr="DateTime" s value=dateTime
	.i index=1 s valueStr=value
	.e  s valueStr=valueStr_"^"_value
	.s index=index+1
	q valueStr

GetStatus(rowId)
	q:'##class(User.DHCBPRecord).%ExistsId(rowId) "Invalid RowId"
	s obj=##class(User.DHCBPRecord).%OpenId(rowId)
	s editFlag=obj.BPREditFlag
	d obj.%Close()	
	q editFlag
OutputRow1(data)
	set Data=$lb(data)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit ind
}

ClassMethod FindDataByRecordIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCInquiryExecute ]
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

ClassMethod FindDataByRecordIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCBPStat).GetInWardInfoByBpaId(3726,"Researchon-SOFANoradrenaline1.1","2014-08-07","19:30","2014-08-07","19:30","EPI")

/// 获取项目数值
/// Input: bpaId监护ID,type项目参数,inDate入病区日期,inTime入病区时间,outDate出病区日期,outTime出病区时间,oeoriNote项目备注
/// Output:返回项目数值 value项目值 ifValue是否有值
ClassMethod GetInWardInfoByBpaId(bpaId, type, inDate = "", inTime = "", outDate = "", outTime = "", oeoriNote = "") As %String
{
	s value="",ifValue="0",lessValue="0"
	q value_"/"_ifValue
}

/// Add mfc 20141127
/// 获取汇总数据
/// 入参:BPCIRowid汇总项目名称，args相关参数
/// 返回：汇总数据，"^"分割
/// d ##class(%ResultSet).RunQuery("web.DHCBPStat","FindGatherData","10","Data")
Query FindGatherData(BPCIRowid As %String, args As %String) As %Query(ROWSPEC = "ColumnTitle:%String") [ SqlProc ]
{
}

ClassMethod FindGatherDataExecute(ByRef qHandle As %Binary, BPCIRowid As %String, args As %String) As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCBPStat","FindTemplateTotalData",5,"1^2014-04-01 14-57-54^2014-04-15 14-58-19")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s icirowid="",datalb=""
	i '##class(User.DHCBPCInquiry).%ExistsId(BPCIRowid) Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s icirowid=$o(^DHCBPInquiry(BPCIRowid,"Sum",icirowid)) q:icirowid=""  d
	.;w icirowid,!
	.q:(+icirowid'=0)&&(args="Title")
	.q:(+icirowid=0)&&(args="Data")
	.q:$g(^DHCBPInquiry(BPCIRowid,"Sum",icirowid))=""
	.s datalb=$g(^DHCBPInquiry(BPCIRowid,"Sum",icirowid))		
	.s datalb=$lb(datalb)
	.d OutputRow16
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow16
	set Data=datalb
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindGatherDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGatherDataExecute ]
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

ClassMethod FindGatherDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGatherDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Replace(str As %String, srcStr As %String, tarStr As %String) As %String
{
	s retStr=$p(str,srcStr)
	f i=2:1:$l(str,srcStr) d
		.s retStr=retStr_tarStr_$p(str,srcStr,i)
	q retStr
}

/// 保存血液净化统计数据
/// 保存统计配置表指针，统计代码，统计描述、类型(M月，S季，Y年)，开始日期，结束日期，用户Id。
/// 返回结果为bpisId
/// 
/// w ##class(web.DHCBPStat).SaveInquiryStat("",1,"code","desc","M",$h-100,$h-30,"7")
ClassMethod SaveInquiryStat(bpisId As %String, bpisBPCIId As %String, bpisCode As %String, bpisDesc As %String, bpisType As %String, bpisStartDate As %String, bpisEndDate As %String, bpisUserId As %String) As %String
{
	q:(bpisBPCIId="")!(bpisCode="")!(bpisDesc="")!(bpisType="")!(bpisStartDate="")!(bpisEndDate="") "-1"
	q:bpisStartDate>bpisEndDate "统计开始日期不能晚于结束日期!"
	s subId=$o(^DHCBPInquiry(bpisBPCIId,999999999),-1)
	q:+subId=0 "没有生成查询数据!"
	s result=0,obj=""
	i bpisId="" s obj=##class(User.DHCBPInquiryStat).%New()
	e  i ##class(User.DHCBPInquiryStat).%ExistsId(bpisId) s obj=##class(User.DHCBPInquiryStat).%OpenId(bpisId)
	q:obj="" -11
	s obj.BPISBPCIDr=##class(User.DHCBPCInquiry).%OpenId(bpisBPCIId)
	s obj.BPISCode=bpisCode
	s obj.BPISDesc=bpisDesc
	s obj.BPISType=bpisType
	s obj.BPISStartDate=##class(web.DHCClinicCom).ConvertToDateH(bpisStartDate)
	s obj.BPISEndDate=##class(web.DHCClinicCom).ConvertToDateH(bpisEndDate)
	s obj.BPISUpdateUserDr=bpisUserId
	s obj.BPISUpdateDate=+$h
	s obj.BPISUpdateTime=+$p($h,",",2)
	s result=obj.%Save()
	s bpisId=obj.%Id()
	d obj.%Close()
	q:bpisId<1 "保存失败!"
	m ^DHCBPInquiryStat(bpisId,"Stat")=^DHCBPInquiry(bpisBPCIId,subId)
	q bpisId
}

/// w ##class(web.DHCBPStat).DeleteInquiryStat(1)
ClassMethod DeleteInquiryStat(bpisId) As %String
{
	q:(bpisId="") "Id不能为空!"
	q:'##class(User.DHCBPInquiryStat).%ExistsId(bpisId) "无对应记录!"
	s deleteStatus=##class(User.DHCBPInquiryStat).%DeleteId(bpisId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// Creater YPZ 20150108
/// 查询
/// 入参:User.DHCBPCInquiry表指针，bpisType类型(M月，S季，Y年),bpisIdList自选要显示的统计
/// 返回：统计数据
/// d ##class(%ResultSet).RunQuery("web.DHCBPStat","FindBPCInquiryStatList","1","M",)
Query FindBPCInquiryStatList(bpisBPCIId As %String, bpisType As %String = "", fromDate As %String = "", toDate As %String = "", bpisIdList As %String = "") As %Query(ROWSPEC = "BpisId:%String,BpisBPCIDr:%String,BpisCode:%String,BpisDesc:%String,BpisType:%String,BpisStartDate:%String,BpisEndDate:%String,BpisUserId:%String,BpisUserDesc:%String,BpisUpdateDate:%String,BpisUpdateTime:%String") [ SqlProc ]
{
}

ClassMethod FindBPCInquiryStatListExecute(ByRef qHandle As %Binary, bpisBPCIId As %String, bpisType As %String = "", fromDate As %String = "", toDate As %String = "", bpisIdList As %String = "") As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCBPStat","FindTemplateTotalData",5,"1^2014-04-01 14-57-54^2014-04-15 14-58-19")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i fromDate'="" s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i toDate'="" s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '##class(User.DHCBPCInquiry).%ExistsId(bpisBPCIId) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s bpisId=0
    f  s bpisId=$o(^DHCBPInquiryStat(bpisId))  q:bpisId=""  d
    .q:'$d(^DHCBPInquiryStat(bpisId))
    .q:(bpisIdList'="")&&(("^"_bpisIdList_"^")'[("^"_bpisId_"^"))
   	.s BpisStartDate=$lg(^DHCBPInquiryStat(bpisId),5)
   	.q:(fromDate'="")&&(BpisStartDate<fromDate)   	
    .s BpisEndDate=$lg(^DHCBPInquiryStat(bpisId),6)
    .q:(toDate'="")&&(BpisEndDate>toDate)
    .s BpisStartDate=$zd(BpisStartDate,3)
    .s BpisEndDate=$zd(BpisEndDate,3)
    .s BpisId=bpisId
    .s BpisBPCIDr=$lg(^DHCBPInquiryStat(bpisId),1)
    .q:(bpisBPCIId'="")&&(bpisBPCIId'=BpisBPCIDr)
    .s BpisCode=$lg(^DHCBPInquiryStat(bpisId),2)
    .s BpisDesc=$lg(^DHCBPInquiryStat(bpisId),3)
    .s BpisType=$lg(^DHCBPInquiryStat(bpisId),4)
    .q:(bpisType'="")&&(bpisType'=BpisType)
    .s BpisUserId=$lg(^DHCBPInquiryStat(bpisId),7)    
    .i BpisUserId'="" s BpisUserDesc=##class(web.DHCClinicCom).GetNameById(BpisUserId)
    .e  s BpisUserDesc=""
    .s BpisUpdateDate=$lg(^DHCBPInquiryStat(bpisId),8)
    .s BpisUpdateDate=$zd(BpisUpdateDate,3) 
    .s BpisUpdateTime=$lg(^DHCBPInquiryStat(bpisId),9)
    .s BpisUpdateTime=$zt(BpisUpdateTime,2)
	.d OutputRow18
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow18
	set Data=$lb(BpisId,BpisBPCIDr,BpisCode,BpisDesc,BpisType,BpisStartDate,BpisEndDate,BpisUserId,BpisUserDesc,BpisUpdateDate,BpisUpdateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCInquiryStatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCInquiryStatListExecute ]
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

ClassMethod FindBPCInquiryStatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCInquiryStatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creater YPZ 20150109
/// 获取保存后的统计数据
/// 入参:BPCIRowid汇总项目名称，args相关参数，bpisIdList自选要显示的统计
/// 返回：汇总数据，"^"分割
/// d ##class(%ResultSet).RunQuery("web.DHCBPStat","FindInquiryStat","10","Data")
Query FindInquiryStat(bpisBPCIId As %String, bpisType As %String, fromDate As %String = "", toDate As %String = "", bpisIdList As %String = "") As %Query(ROWSPEC = "StatData:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryStatExecute(ByRef qHandle As %Binary, bpisBPCIId As %String, bpisType As %String, fromDate As %String = "", toDate As %String = "", bpisIdList As %String = "") As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCBPStat","FindTemplateTotalData",5,"1^2014-04-01 14-57-54^2014-04-15 14-58-19")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s datalb=""
	i fromDate'="" s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i toDate'="" s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '##class(User.DHCBPCInquiry).%ExistsId(bpisBPCIId) Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	f  s bpisType=$o(^DHCBPInquiryStat(0,"BPCIType",bpisBPCIId,bpisType)) q:bpisType=""  d
	.s bpisId=0
	.f  s bpisId=$o(^DHCBPInquiryStat(0,"BPCIType",bpisBPCIId,bpisType,bpisId)) q:bpisId=""  d
	..q:(bpisIdList'="")&&(("^"_bpisIdList_"^")'[("^"_bpisId_"^"))
	..q:'$d(^DHCBPInquiryStat(bpisId,"Stat"))
	..q:$g(^DHCBPInquiryStat(bpisId,"Stat"))=""
    ..q:'$d(^DHCBPInquiryStat(bpisId))
   	..s BpisStartDate=$lg(^DHCBPInquiryStat(bpisId),5)
   	..q:(fromDate'="")&&(BpisStartDate<fromDate)   	
    ..s BpisEndDate=$lg(^DHCBPInquiryStat(bpisId),6)
    ..q:(toDate'="")&&(BpisEndDate>toDate)    
	..s datalb=$g(^DHCBPInquiryStat(bpisId,"Stat"))		
	..s datalb=$lb(datalb)
	..d OutputRow17
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow17
	set Data=datalb
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInquiryStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInquiryStatExecute ]
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

ClassMethod FindInquiryStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInquiryStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
