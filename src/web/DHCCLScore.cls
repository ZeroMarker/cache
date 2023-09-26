Import SQLUSER

Class web.DHCCLScore Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindScore(EpisodeID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "tCreateUser:%String,tCreateDate:%String,tCreateTime:%String,tUpdateUser:%String,tUpdateDate:%String,tUpdateTime:%String,tSCORERowId:%String") [ SqlProc ]
{
}

ClassMethod FindScoreExecute(ByRef qHandle As %Binary, EpisodeID As %String, StartDate As %String, EndDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	//s SCORERowId=""
	//f  s SCORERowId=$o(^DHCCLScore(SCORERowId)) q:SCORERowId=""  d
	i StartDate="" s StartDate=+$h
	i EndDate="" s EndDate=+$h
	s SCORERowId=""
	f  s SCORERowId=$o(^DHCCLScore(0,"Adm",EpisodeID,SCORERowId)) q:SCORERowId=""  d
	.s tCreateUserId=$p(^DHCCLScore(SCORERowId),"^",2)
	.s tCreateUser=""
	.i tCreateUserId'="" s tCreateUser=$p(^SSU("SSUSR",tCreateUserId),"^",2)
	.s tCreateDate=$p(^DHCCLScore(SCORERowId),"^",3)
	.q:(tCreateDate<StartDate)!(tCreateDate>EndDate)&((StartDate'="")&(EndDate'=""))
	.i tCreateDate'="" s tCreateDate=$zd(tCreateDate,4)
	.s tCreateTime=$p(^DHCCLScore(SCORERowId),"^",4)
	.i tCreateTime'="" s tCreateTime=$zt(tCreateTime,2)
	.s tUpdateUserId=$p(^DHCCLScore(SCORERowId),"^",5)
	.s tUpdateUser=""
	.i tUpdateUserId'="" s tUpdateUser=$p(^SSU("SSUSR",tUpdateUserId),"^",2)
	.s tUpdateDate=$p(^DHCCLScore(SCORERowId),"^",6)
	.i tUpdateDate'="" s tUpdateDate=$zd(tUpdateDate,4)
	.s tUpdateTime=$p(^DHCCLScore(SCORERowId),"^",7)
	.i tUpdateTime'="" s tUpdateTime=$zt(tUpdateTime,2)
	.s tSCORERowId=SCORERowId
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tCreateUser,tCreateDate,tCreateTime,tUpdateUser,tUpdateDate,tUpdateTime,tSCORERowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreExecute ]
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

ClassMethod FindScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InsertScore(adm, mainCLCSId) As %String
{
	q:adm=""!mainCLCSId="" "-1^未选中病人或评分项节点!"
	s userId=%session.Data("LOGON.USERID")
    s clsDate=+$h
	s clsTime=+$p($h,",",2)
	s updateDate=+$h
	s updateTime=+$p($h,",",2)
	s SQLCODE=0
	TSTART
	&SQL(insert into DHC_CL_Score(CLS_Adm_Dr,CLS_Date,CLS_Time,CLS_CLCS_Dr,CLS_UpdateDate,CLS_UpdateTime,CLS_UpdateUser_Dr) Values(:adm,:clsDate,:clsTime,:mainCLCSId,:updateDate,:updateTime,:userId))
	s mainCLSId=%ROWID
    i SQLCODE'=0  TRollBack  q "-2^插入主项id错误!"
	s id=""
	f  s id=$o(^DHCCLC("ScoreLink",id)) q:id=""  d
	.s str=$g(^DHCCLC("ScoreLink",id))
	.s mainId=$lg(str,1)
	.q:mainCLCSId'=mainId
	.s linkId=$lg(str,2)
	.q:linkId=""
	.s clcsId=linkId
	.&SQL(insert into DHC_CL_Score(CLS_Adm_Dr,CLS_Date,CLS_Time,CLS_CLCS_Dr,CLS_MainCLS_Dr,CLS_UpdateDate,CLS_UpdateTime,CLS_UpdateUser_Dr) Values(:adm,:clsDate,:clsTime,:clcsId,:mainCLSId,:updateDate,:updateTime,:userId))
	.q:SQLCODE'=0
	i SQLCODE'=0 TRollBack  q "-3^插入数据失败！"
	Tcommit
	q SQLCODE_"^"_mainCLSId
}

ClassMethod DeleteScore(menuId) As %String
{
 s mainClsId=$p(menuId,"||",2)
 q:mainClsId="" "未选中有效删除项"
 TSTART
 &SQL(delete from DHC_CL_Score where CLS_RowId=:mainClsId or CLS_MainCLS_Dr=:mainClsId)
 i SQLCODE'=0 TRollBack  q "删除数据失败！"
 Tcommit
 q SQLCODE
}

ClassMethod BuildItemJson(adm, dateFrom, dateTo) As %String
{
	s dateFrom=##Class(web.DHCClinicCom).ConvertToDateH(dateFrom)
	s dateTo=##Class(web.DHCClinicCom).ConvertToDateH(dateTo)
	s json=""
	s id=""  f  s id=$o(^DHCCLC("Score",id)) q:id=""  d
	.s str=$g(^DHCCLC("Score",id))
	.s code=$lg(str,1)
	.s desc=$lg(str,2)
	.s isMain=$lg(str,6)
	.q:isMain'=1
	.s:json'="" json=json_","
	.s json=json_"{"
    .s json=json_"id:"_id_","
    .s json=json_"text:"""_desc_""","
	.;;s json=json_"""iconCls"":"""_IconClass_""","
    .s json=json_"leaf:false"_","
    .;s json=json_"collapsed:false"_","
	.s rootChild=""
	.f date=dateFrom:1:dateTo d
	..s time=""
	..f  s time=$o(^DHCCLScore(0,"DateTime",date,adm,time))  q:time=""  d
	...s clsId=""
	...f  s clsId=$o(^DHCCLScore(0,"DateTime",date,adm,time,clsId))  q:clsId=""  d
	....s childId=id_"||"_clsId       //叶子节点由码表主项id和业务表rowid组成
	....s mainCLSDr=$lg(^DHCCLScore(clsId),7)
	....q:mainCLSDr'=""
	....s clcsDr=$lg(^DHCCLScore(clsId),4)
	....q:clcsDr'=id
	....s chlDesc=$zd(date,3)_" "_$zt(time)
	....s:rootChild'="" rootChild=rootChild_","
	....s rootChild=rootChild_"{"
	....s rootChild=rootChild_"id:"""_childId_""","
	....s rootChild=rootChild_"text:"""_chlDesc_""","
	....s rootChild=rootChild_"leaf:true"
	....s rootChild=rootChild_"}"
	.s json=json_"children:["_rootChild_"]"
	.s json=json_"}"
	
	q "["_json_"]"
}

ClassMethod GetMainCLCS(mainCLCSId) As %String
{
	s mainDesc=$lg(^DHCCLC("Score",mainCLCSId),2)
	q mainDesc
}

ClassMethod GetLinkCLCS(mainCLCSId) As %String
{
	s id="",linkCLCS=""
	f  s id=$o(^DHCCLC("ScoreLink",id)) q:id=""  d
	.s str=$g(^DHCCLC("ScoreLink",id))
	.s mainId=$lg(str,1)
	.q:mainCLCSId'=mainId
	.s linkId=$lg(str,2)
	.q:linkId=""
	.s linkDesc=$lg(^DHCCLC("Score",linkId),2)
	.q:linkDesc=""
	.s link=linkId_"!"_linkDesc
	.i linkCLCS="" s linkCLCS=link 
	.e  s linkCLCS=linkCLCS_"^"_link 
	q linkCLCS
}

ClassMethod GetRadioGroup(parRef) As %String
{
  s clcsType=$lg(^DHCCLC("Score",parRef),3)
  s clcsCode=$lg(^DHCCLC("Score",parRef),1)
  s sub="",itemJson=""
  f  s sub=$o(^DHCCLC("Score",parRef,"O",sub)) q:sub=""  d
  .s str=$g(^DHCCLC("Score",parRef,"O",sub))
  .s desc=$lg(str,2)
  .s scoreValue=$lg(str,5)
  .s label=desc_"("_scoreValue_"分)"
  .s val=parRef_"||"_sub
  .i clcsType'="C" d
  ..s:itemJson'="" itemJson=itemJson_"," 
  ..s itemJson=itemJson_"{"
  ..s itemJson=itemJson_"boxLabel"_":"""_label_""",name:"""_parRef_""",inputValue:"""_val_"""}"
  .e  d
  ..s:itemJson'="" itemJson=itemJson_"," 
  ..s itemJson=itemJson_"{"_"disabled:true," 
  ..s itemJson=itemJson_"boxLabel"_":"""_label_""",name:"""_parRef_""",inputValue:"""_val_"""}"
  s radioJson="{"_"xtype:"_"""radiogroup"","_"id:"_"""radio_"_parRef_""","_"itemCls:"_"""x-check-group-alt"","_"hideLabel:true,"_"columns:1,"
  s radioJson=radioJson_"items:["_itemJson_"]}"
  i (clcsType="C") d
  .s json="{"_"xtype:"_"""textfield"","_"id:"_"""txt_"_parRef_""","_"fieldLabel:"_"""数值"","
  .s json=json_"anchor:"_"""60%"""_",enableKeyEvents:true"_"}"
  .s json=json_","_radioJson
  e  s json=radioJson
  q "["_json_"]"
}

ClassMethod GetCLCSOId(parRef, quantity) As %String
{
  
  s id=""
  s sub=""
  f  s sub=$o(^DHCCLC("Score",parRef,"O",sub)) q:sub=""  d
  .s str=$g(^DHCCLC("Score",parRef,"O",sub))
  .s min=$lg(str,3)	
  .s max=$lg(str,4)
  .i '(quantity<min)&&'(quantity>max) d
  ..s id=parRef_"||"_sub
  q id
}

ClassMethod GetCLCSDesc(rowId) As %String
{
	q:rowId=""
	s desc=""
	&SQL(select CLCS_Desc into :desc from  DHC_CLC_Score where CLCS_RowId =:rowId)
	q desc
}

ClassMethod GetScoreValue(selOptionId) As %String
{
	q:selOptionId="" "未选中评分项"
	s scoreValue=0
	&SQL(select CLCSO_ScoreValue into :scoreValue from DHC_CLC_ScoreOption where CLCSO_RowId =:selOptionId)
	q scoreValue
}

ClassMethod UpdateSubCLScore(mainClsId, clsCLCSDr, clsCLCSODr, clsValue = "") As %String
{
  q:mainClsId="" -1   //业务表主项id为空
  q:clsCLCSDr="" -2	  //radiogroup id值为空
  q:clsCLCSODr="" -3  //没有选择选项
  s SQLCODE=0
  TSTART
  &SQL(update DHC_CL_Score set CLS_CLCSO_Dr=:clsCLCSODr,CLS_Value=:clsValue where CLS_CLCS_Dr=:clsCLCSDr and
  CLS_MainCLS_Dr=:mainClsId)
  i SQLCODE'=0 TRollBack  q "更新数据失败！"
  Tcommit
  q SQLCODE
}

ClassMethod UpdateMainCLScore(mainClsId, clsValue) As %String
{
  q:mainClsId="" -1
  s SQLCODE=0
  TSTART
  &SQL(update DHC_CL_Score set CLS_Value=:clsValue where CLS_RowId=:mainClsId)
  i SQLCODE'=0 TRollBack  q "总分更新数据失败！"
  Tcommit
  q SQLCODE
}

ClassMethod GetCLSRecord(mainCLSId)
{
  q:mainCLSId="" -1
  s mainCLSValue="",clsCLCSDr="",clsCLCSODr="",subCLSValue=""
  &SQL(select CLS_Value into :mainCLSValue from DHC_CL_Score where CLS_RowId=:mainCLSId)
  s retStr="",subRetStr=""
  &SQL(declare subCLSRecord cursor  for 
	select distinct CLS_CLCS_Dr,CLS_CLCSO_Dr,CLS_Value
	              from SQLUser.DHC_CL_Score
	              WHERE (CLS_MainCLS_Dr=:mainCLSId))
  &SQL(open subCLSRecord)
  f  &SQL(fetch subCLSRecord into :clsCLCSDr,:clsCLCSODr,:subCLSValue) q:SQLCODE  d
 	.i subRetStr="" s subRetStr=clsCLCSDr_"!"_clsCLCSODr_"!"_subCLSValue
 	.e  s subRetStr=subRetStr_"#"_clsCLCSDr_"!"_clsCLCSODr_"!"_subCLSValue	 	
  &SQL(close subCLSRecord)
  s retStr=mainCLSValue_"^"_subRetStr
  q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLScore","FindScoreOrder","25","2013-01-28","00:00","2013-01-29","00:00")
Query FindScoreOrder(EpisodeID As %String, startDate As %String = "", startTime As %String = "", endDate As %String = "", endTime As %String = "") As %Query(ROWSPEC = "Id:%String,EpisodeID:%String,ScoreDT:%String,ScoreItemId:%String,ScoreOptionId:%String,ScoreValue:%String,MainScoreItemId:%String,UpdateDT:%String,UpdateUserId:%String,IcuaId:%String,EditFlag:%String,OriginalScoreId:%String,EditedScoreId:%String") [ SqlProc ]
{
}

ClassMethod FindScoreOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, startDate As %String = "", startTime As %String = "", endDate As %String = "", endTime As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i (EpisodeID="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	f curDate=startDate:1:endDate  d
	.s curTime=""
	.f  s curTime=$o(^DHCCLScore(0,"DateTime",curDate,EpisodeID,curTime)) q:(curTime="")  d
	..s scoreId=""
	..f  s scoreId=$o(^DHCCLScore(0,"DateTime",curDate,EpisodeID,curTime,scoreId)) q:(scoreId="")  d
	...s scoreDate=$lg(^DHCCLScore(scoreId),2)
	...s scoreDate=##class(web.DHCClinicCom).ConvertToDate(scoreDate)
	...s scoreTime=$lg(^DHCCLScore(scoreId),3)
	...s scoreTime=##class(web.DHCClinicCom).ConvertToTime(scoreTime)
	...s scoreDT=scoreDate_" "_scoreTime
	...s scoreItemId=$lg(^DHCCLScore(scoreId),4)
	...s scoreOptionId=$lg(^DHCCLScore(scoreId),5)
	...s scoreValue=$lg(^DHCCLScore(scoreId),6)
	...s mainScoreItemId=$lg(^DHCCLScore(scoreId),7)
	...s updateDate=$lg(^DHCCLScore(scoreId),8)
	...s updateDate=##class(web.DHCClinicCom).ConvertToDate(updateDate)
	...s updateTime=$lg(^DHCCLScore(scoreId),9)
	...s updateTime=##class(web.DHCClinicCom).ConvertToTime(updateTime)
	...s updateDT=updateDate_" "_updateTime
	...s updateUserId=$lg(^DHCCLScore(scoreId),10)
	...s icuaId=$lg(^DHCCLScore(scoreId),11)
	...s editFlag=$lg(^DHCCLScore(scoreId),12)
	...s originalScoreId=$lg(^DHCCLScore(scoreId),13)
	...i (editFlag="N")&(originalScoreId="") s originalScoreId=scoreId
	...s editedScoreId=$lg(^DHCCLScore(scoreId),14)
	...d OrderOutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OrderOutputRow
	set Data=$lb(scoreId,EpisodeID,scoreDT,scoreItemId,scoreOptionId,scoreValue,mainScoreItemId,updateDT,updateUserId,icuaId,editFlag,originalScoreId,editedScoreId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindScoreOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreOrderExecute ]
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

ClassMethod FindScoreOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 批量保存重症监护评分数据
/// orderParaList由重症监护评分数据串拼接而成，以"^"分割。数据串以$c(3)分割，按照表DHC_CL_Score的SqlColumnNumber顺序拼接而成。
/// 数据串第一个字段固定为数据的RowId(ICUO_RowId)，如果是新增的数据，那么第一个字段为空。
/// 返回结果为保存后的数据Id串，以"^"分割
ClassMethod SaveScoreOrder(orderParaList As %String) As %String
{
	s result=""
	f i=1:1:$l(orderParaList,"^")  d
	.s orderPara=$p(orderParaList,"^",i)
	.q:(orderPara="")
	.s orderObj=..SetScoreOrderObj(orderPara)
	.d orderObj.%Save()
	.i result'="" s result=result_"^"
	.s result=result_orderObj.%Id()
	.d orderObj.%Close()
	q result
}

ClassMethod SetScoreOrderObj(orderPara As %String) As User.DHCCLScore
{
	s orderId=$p(orderPara,$c(3),1)
	s order=""
	q:(orderPara="") order
	i orderId="" s order=##class(User.DHCCLScore).%New()
	e  s order=##class(User.DHCCLScore).%OpenId(orderId)
	s order.CLSAdmDr=$p(orderPara,$c(3),2)
	s order.CLSDate=##class(web.DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),3))
	s order.CLSTime=##class(web.DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),4))
	;s order.CLSCLCSDr=$p(orderPara,$c(3),5)
	s scoreItemId=$p(orderPara,$c(3),5)
	i scoreItemId'="" s order.CLSCLCSDr=##class(User.DHCCLCScore).%OpenId(scoreItemId)
	;s order.CLSCLCSODr=$p(orderPara,$c(3),6)
	s scoreOptionId=$p(orderPara,$c(3),6)
	i scoreOptionId'="" s order.CLSCLCSODr=##class(User.DHCCLCScoreOption).%OpenId(scoreOptionId)
	s order.CLSValue=$p(orderPara,$c(3),7)
	;s order.CLSMainCLSDr=$p(orderPara,$c(3),8)
	s mainScoreItemId=$p(orderPara,$c(3),8)
	i mainScoreItemId'="" s order.CLSMainCLSDr=##class(User.DHCCLCScore).%OpenId(mainScoreItemId)
	s order.CLSUpdateDate=##class(web.DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),9))
	s order.CLSUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),10))
	s order.CLSUpdateUserDr=$p(orderPara,$c(3),11)
	s icuaId=$p(orderPara,$c(3),12)
	i icuaId'="" s order.CLSIcuaDr=##class(User.DHCICUArrange).%OpenId(icuaId)
	s order.CLSEditFlag=$p(orderPara,$c(3),13)
	;s order.CLSOriginalScore=$p(orderPara,$c(3),14)
	s originalScoreId=$p(orderPara,$c(3),14)
	i originalScoreId'="" s order.CLSOriginalScore=##class(User.DHCCLScore).%OpenId(originalScoreId)
	;s order.CLSEditedScore=$p(orderPara,$c(3),15)
	s editedScoreId=$p(orderPara,$c(3),15)
	i editedScoreId'="" s order.CLSEditedScore=##class(User.DHCCLScore).%OpenId(editedScoreId)
	q order
}

ClassMethod GetScoreByOption(clcsId, value) As %String
{
	q:clcsId="" ""
	s score=""
	s clcsoSub="",maxQtyValue="",minQtyValue=""
	f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
		.s minValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),3)
		.s maxValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),4)
		.i (value'<minValue)&(value'>maxValue) d
			..s score=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
	q score
}

/// 根据评分主项代码、值，取值对应的评分子项结果：ifValue为1取分值，为0取子项描述。
ClassMethod GetScoreByValue(clcsCode, value, ifValue) As %String
{
	q:clcsCode="" ""
	s clcsId=$o(^DHCCLC("Score",0,"Code",clcsCode,"")) 
	q:clcsId="" ""
	s score=""
	s clcsoSub="",maxQtyValue="",minQtyValue=""
	f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
		.s minValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),3)
		.s maxValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),4)
		.i (value'<minValue)&(value'>maxValue) d
			..i ifValue s score=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
			..e  s score=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
	q score
}

ClassMethod GetApacheOxygenation(icuaId, fromDate, fromTime, toDate, toTime, paO2ClcsId, aaDO2ClcsId, fiO2ClcsId) As %String
{
	// w ##class(web.DHCCLScore).GetApacheOxygenation(icuaId, fromDate, fromTime, toDate, toTime, paO2ClcsId, aaDO2ClcsId, fiO2ClcsId)
	q:(icuaId="")!(fiO2ClcsId="")!(paO2ClcsId="")!(aaDO2ClcsId="") ""
	s flowO2riID=5653,pCO2riID=5093
	
	s paO2IcucriCode=$lg(^DHCCLC("Score",paO2ClcsId),9)
	s paO2IcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(paO2IcucriCode)
	s aaDO2IcucriCode=$lg(^DHCCLC("Score",aaDO2ClcsId),9)
	s aaDO2IcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(aaDO2IcucriCode)
	s fiO2IcucriCode=$lg(^DHCCLC("Score",fiO2ClcsId),9)
	s fiO2IcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(fiO2IcucriCode)
	w "threeId "_paO2IcucriId,"\"_aaDO2IcucriId,"\"_fiO2IcucriId,!
	q:(paO2IcucriId="")!(aaDO2IcucriId="")!(aaDO2IcucriId="") ""
	
	s paO2Source="",aaDO2Source="",fiO2Source="",oxygenationScore=""

	s date=fromDate-1,ifQuit=0
	f  s date=$o(^DHCICUOrder(0,"RecordItem",paO2IcucriId,date)) q:(date="")!(date>toDate)!(ifQuit)  d
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",paO2IcucriId,date,icuaId,time)) q:time=""  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)
			..s icuoId="" //根据pO2找
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",paO2IcucriId,date,icuaId,time,icuoId)) q:(icuoId="")!(ifQuit)  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...s paO2Qty=##Class(web.DHCICUOrder).GetRecordValueSingle(icuoId) //取值
				...;s baseIcucriId=$lg(^DHCCLC("Score",paO2ClcsId),12)	//基准常用医嘱ID：样本类型
				...s baseIcucriCode=$lg(^DHCCLC("Score",paO2ClcsId),12)	//基准常用医嘱Code：样本类型
				...s baseValue=$lg(^DHCCLC("Score",paO2ClcsId),13)		//基准值
				...s type=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, baseIcucriId, date, time,0)
				...w $zd(date)_"\"_$zt(time)_"\"_paO2Qty_"\"_baseIcucriId_"\"_baseValue_"\"_type,!
				...// 只找动脉血气
				...q:type'=baseValue
				...s paO2Score=..GetScoreByOption(paO2ClcsId,paO2Qty) //计算评分
				...s fiO2IcuoId="",fiO2Qty="" //按时间段查找
				...s fiO2Qty=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, fiO2IcucriId, date, time,90)
				...s ventMode="",fRate=0,Flo2O2Qty=0
				...w "fiO2Qty="_fiO2Qty,!
				...
				...i fiO2Qty="" d // 查找呼吸模式
				....;s baseIcucriId=$lg(^DHCCLC("Score",fiO2ClcsId),12)
				....s baseIcucriCode=$lg(^DHCCLC("Score",fiO2ClcsId),12)
				....s ventMode=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, baseIcucriId, date, time,90)
				....w "ventMode="_ventMode,!
				....i ventMode'="" d
				.....i "储氧面罩吸氧;储氧面罩;"[(ventMode) s fiO2Qty=80
				.....i "双鼻导管吸氧;鼻导管;"[(ventMode) d
				......s flowO2Qty=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, flowO2riID, date, time,90)
				......s fiO2Qty=(((+flowO2Qty)*4)+21)
				......i fiO2Qty>50 s fiO2Qty=50
				...i 0=+fiO2Qty s fiO2Qty=21
				...i fiO2Qty<50 d // 按pO2评分
					....q:(oxygenationScore'="")&(oxygenationScore'>paO2Score)
					....s oxygenationScore=paO2Score,paO2Source=paO2Qty,fiO2Source=fiO2Qty,aaDO2Source=""
				...q:fiO2Qty<50   // 按A-aDO2评分
				...
				...;s fiO2Qty=(fiO2Qty/100) 计算时再计算
				...
				...s aadO2IcuoId="",aadO2Score="",aadO2Qty=""
				...s aadO2Qty=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, aaDO2IcucriId, date, time,0)
				...i aadO2Qty="" d 
				....; 血气中没有A-aDO2的值:通过公式计算
				....s PaCO2=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId, pCO2riID, date, time,90)
				....s aadO2Qty=((fiO2Qty/100)*(760-47)-(PaCO2/0.8))-paO2Qty
				...w "AaDO2:"_aadO2Qty,!
				...s aadO2Score=..GetScoreByOption(aaDO2ClcsId,aadO2Qty)
				...q:(oxygenationScore'="")&(oxygenationScore'>aadO2Score)
				...s oxygenationScore=aadO2Score,paO2Source="",fiO2Source=fiO2Qty,aaDO2Source=aadO2Qty
				
	//w "pO2:"_paO2ClcsId_"|"_paO2IcucriId_"|"_paO2Source_"|"_oxygenationScore,!
	//w "aaDO2:"_aaDO2ClcsId_"|"_aaDO2IcucriId_"|"_aaDO2Source_"|"_oxygenationScore,!
	//w "FiO2:"_fiO2ClcsId_"|"_fiO2IcucriId_"|"_fiO2Source_"|",!
	
	s retStr=paO2ClcsId_"|"_paO2IcucriId_"|"_paO2Source_"|"_oxygenationScore
	s retStr=retStr_"^"_aaDO2ClcsId_"|"_aaDO2IcucriId_"|"_aaDO2Source_"|"_oxygenationScore
	s retStr=retStr_"^"_fiO2ClcsId_"|"_fiO2IcucriId_"|"_fiO2Source_"|"
	q retStr
}

/// 创建人：俞沛之
/// 创建时间：2015-5-28
/// 功能：查询评分项对应时间范围内的评分值
/// 入参：EpisodeID就诊号,icuaId监护安排Id（非重症病人传空）, 开始日期、时间, 结束日期、时间, 
///       clcsIdStr：第一级用"^"分隔，对应评分项;第二级用"|"分隔:DHC_CLC_Score评分项目的Id，值（最小值），最大值
/// 返回值：第一级用"^"分隔，对应入参clcsIdStr串；第二级clcsId_"|"_各常用医嘱Id_"|"_最大(小)数据值_"|"_最大评分
ClassMethod CalculateScoreValue(EpisodeID As %String, icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, clcsStr As %String) As %String
{
    ///w ##class(web.DHCCLScore).CalculateScoreValue(3404693,"","2013-09-21",0,"2013-09-21",0,"11|110^12|120^13|130^14|40^15|350^16|160^18|170^19|180^20|200^21|210^22|220^2|E4-自发^3|V5-定向^4|M6-服从命令^1^16|160^36|360^25|250^23|230^24|伴器官衰竭并接受急诊手术^35|350^83|830")
	s calDuration=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,endDate,endTime) //计算两个时间的时间差
	;k ^Lynt
	s ifDefault=""
	i (+calDuration)>=86400 d 
	.s ifDefault="1"
	s retStr=..GetScoreValueByData(icuaId, startDate, startTime, endDate, endTime, clcsStr, EpisodeID,ifDefault)
	s ^Lynt("retStr")=retStr
	w retStr,!,!
	k clcsPosList
	s fiO2Pos=0
	s mainClcsStr="",topClcsId=""
	f i=1:1:$l(clcsStr,"^")  d //建立评分项对常用医嘱的映射关系
		.s curStr=$p(clcsStr,"^",i)
		.s clcsId=$p(curStr,"|")
		.q:'$d(^DHCCLC("Score",clcsId))
		.i $lg(^DHCCLC("Score",clcsId),1)="FiO2" s fiO2Pos=i
		.s ^Lynt(clcsId)=i
		.s clcsPosList(clcsId)=i
		.s clcslId=$o(^DHCCLC("ScoreLink",0,"S",clcsId,""))
		.i clcslId'="" d
			..s mainClcsId=$lg(^DHCCLC("ScoreLink",clcslId),1)
			..//w mainClcsId_"/"_mainClcsStr,!
			..i ("^"_mainClcsStr_"^")'[("^"_mainClcsId_"^") d
				...i mainClcsStr'="" s mainClcsStr=mainClcsStr_"^"
				...s mainClcsStr=mainClcsStr_mainClcsId
	s lastMainClcsStr=$p(mainClcsStr,"^",$l(mainClcsStr,"^"))
	s fio2Qty=0
	i fiO2Pos>0 d //调整呼吸评分
		.s fio2Str=$p(retStr,"^",fiO2Pos)
		.s fio2Qty=$p(fio2Str,"|",3)
		.i +fio2Qty=0 d
			..s fio2Qty=21
			..i $p(fio2Str,"|",1)="" s $p(fio2Str,"|",1)=+$p(clcsStr,"^",fiO2Pos)
			..s $p(fio2Str,"|",3)=fio2Qty
			..s $p(fio2Str,"|",4)=0
			..s $p(retStr,"^",fiO2Pos)=fio2Str
	f i=1:1:$l(mainClcsStr,"^")  d //高一层汇总
		.s clcsId=$p(mainClcsStr,"^",i)
		.q:clcsId=""
		.q:'$d(^DHCCLC("Score",clcsId))
		.s clcslId=$o(^DHCCLC("ScoreLink",0,"S",clcsId,""))
		.i clcslId'="" d
			..s mainClcsId=$lg(^DHCCLC("ScoreLink",clcslId),1)
			..//w mainClcsId_":"_$lg(^DHCCLC("Score",mainClcsId),2)_"/subClcsStr:"_clcsId_" "_$lg(^DHCCLC("Score",clcsId),2),!
			..i ("^"_mainClcsStr_"^")'[("^"_mainClcsId_"^") d
				...i mainClcsStr'="" s mainClcsStr=mainClcsStr_"^"
				...s mainClcsStr=mainClcsStr_mainClcsId
	f i=1:1:$l(mainClcsStr,"^") d //找顶部值
		.s mainClcsId=$p(mainClcsStr,"^",i)
		.q:mainClcsId=""
		.i $o(^DHCCLC("ScoreLink",0,"S",mainClcsId,""))="" s topClcsId=mainClcsId
	i topClcsId'="" d //按层次排序
		.s mainClcsStr=topClcsId
		.s subClcsIdStr=..GetSubClcsId(topClcsId)
		.s subClcsIdStr=..GetSubClcsId(subClcsIdStr)_"^"_subClcsIdStr
		.w subClcsIdStr,!
		.f i=$l(subClcsIdStr,"^"):-1:1 d
			..s subClcsId=$p(subClcsIdStr,"^",i)
			..//w subClcsId,!
			..q:$o(^DHCCLC("ScoreLink",0,"M",subClcsId,""))=""
			..s mainClcsStr=subClcsId_"^"_mainClcsStr
	w "main:"_mainClcsStr,!
	
	k calculateList
	f i=1:1:$l(mainClcsStr,"^") d
		.s mainClcsId=$p(mainClcsStr,"^",i)
		.q:mainClcsId=""
		.q:'$d(^DHCCLC("Score",mainClcsId))
		.q:$d(calculateList(mainClcsId))
		.s score=$lg(^DHCCLC("Score",mainClcsId),5)
		.s clcslId="",ifhaveSubScore=1
		.f  s clcslId=$o(^DHCCLC("ScoreLink",0,"M",mainClcsId,clcslId)) q:clcslId=""  d
			..s subClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:(fio2Qty<50)&($lg(^DHCCLC("Score",subClcsId),1)="AaDO2 ifFiO2≥50%")
			..q:(fio2Qty'<50)&($lg(^DHCCLC("Score",subClcsId),1)="PaO2 ifFiO2<50%")
			..w mainClcsId,"  main/sub "_subClcsId
			..i '$d(^DHCCLC("Score",subClcsId)) s ifhaveSubScore=0 w " No subNode",! q
			..s pos=$g(clcsPosList(subClcsId))
			..i pos<1 s ifhaveSubScore=0 q // w " No scoreItem",!
			..q:pos<1
			..s curScore=$p($p(retStr,"^",pos),"|",4)
			..i curScore="" s ifhaveSubScore=0 q  // w " No value",!
			..s score=score+($lg(^DHCCLC("Score",subClcsId),4)*curScore)
			..w " "_$lg(^DHCCLC("Score",subClcsId),2)_"  Yes:score="_score,!
		.i ifhaveSubScore d
			..s pos=$g(clcsPosList(mainClcsId))
			..i pos="" s pos=$l(retStr,"^")+1,clcsPosList(mainClcsId)=pos
			..s $p(retStr,"^",pos)=mainClcsId_"|||"_score
			..s calculateList(mainClcsId)=""
			..w "mainClcsId="_mainClcsId_"/sub:  "_$lg(^DHCCLC("Score",subClcsId),2)_",score="_score,!
	q retStr
}

ClassMethod GetSubClcsId(mainClcsIdStr) As %String
{
	s clcsIdStr=""
	f i=1:1:$l(mainClcsIdStr,"^") d
		.s mainClcsId=$p(mainClcsIdStr,"^",i)
		.s clcslId=""
		.f  s clcslId=$o(^DHCCLC("ScoreLink",0,"M",mainClcsId,clcslId)) q:clcslId=""  d
			..q:'$d(^DHCCLC("ScoreLink",clcslId))
			..s subClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..i clcsIdStr'="" s clcsIdStr=clcsIdStr_"^"
			..s clcsIdStr=clcsIdStr_subClcsId
	q clcsIdStr
}

/// 查询评分项表对应时间范围内的评分值
/// 入参：icuaId监护安排Id, 开始日期、时间, 结束日期、时间, 
///       clcsStr：第一级用"^"分割; 第二级用"|"分隔:DHC_CLC_Score的Id,值，最小值，最大值
/// 返回值：第一级用"^"分隔，对应入参clcsIdStr串；第二级clcsId_"|"_各常用医嘱Id_"|"_最大(小)数据值_"|"_最大评分
ClassMethod GetScoreValueByData(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, clcsStr As %String, EpisodeID As %String = "", ifDefault As %String = "") As %String
{
	s result=""
	q:((icuaId="" & EpisodeID="")!(clcsStr="")) result
	s clcsIdStr=""
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s icucriIdStr="",maxQtyStr="",minQtyStr="",icucriIdPos=""
	;w "ifDefault++++++++++++++"_ifDefault,!
	;k ^Lynt
	s STX=$c(2)
	s ETX=$c(3)
	
	s sofaCVSPos=0
	f i=1:1:$l(clcsStr,"^")  d //建立评分项对常用医嘱的映射关系
		.s curStr=$p(clcsStr,"^",i)
		.s clcsId=$p(curStr,"|")
		.q:'$d(^DHCCLC("Score",clcsId))
		.s $p(clcsIdStr,"^",i)=clcsId
		.i $lg(^DHCCLC("Score",clcsId),3)="C" d
			..s $p(minQtyStr,"^",i)=$p(curStr,"|",2)
			..s $p(maxQtyStr,"^",i)=$p(curStr,"|",3)
			..i $p(curStr,"|",3)="" s $p(maxQtyStr,"^",i)=$p(curStr,"|",2)
		.i $lg(^DHCCLC("Score",clcsId),3)="S" d
			..q:$p(curStr,"|",2)=""
			..
		.i $lg(^DHCCLC("Score",clcsId),1)="SOFAHypotension" s sofaCVSPos=i
		.q:$lg(^DHCCLC("Score",clcsId),10)'=""
		.s $p(icucriIdStr,"^",i)=##class(web.DHCICUCom).GetIcuriIdByCode($lg(^DHCCLC("Score",clcsId),9))
		.q:$p(icucriIdStr,"^",i)=""
		.s icucriIdPos($p(icucriIdStr,"^",i))=i
	w icucriIdStr,!
	s qtyDataOptionId="",propertyId="",isFind=0
	f  s propertyId=$o(^DHCICUC("Property",propertyId)) q:(propertyId="")!(isFind)  d
		.i $lg(^DHCICUC("Property",propertyId),1)="QtyDataOption" s qtyDataOptionId=propertyId,isFind=1
	s wardLocId=$p($g(^PAWARD(+$p(^DHCICUArrange(+icuaId),"^",4))),"^",5)
	s icupId=$o(^DHCICUPara(0,"Ctloc",+wardLocId,""))
	i icupId>0,qtyDataOptionId>0 d //根据选项计算值的列表
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..q:$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)=""
			..s icupidSub=0
			..f  s icupidSub=$o(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...q:+^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)'=qtyDataOptionId
				...s qtyDataOptionList($p(^DHCICUPara(icupId,"I",icupiSub),"^",4))=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",2)
	
	s sofaCVSDoseSpeedIcucriId=$g(^DHCCLSet("ICU","DoseSpeedIcucriId"))
	s maxNESpeed=0,maxEpiSpeed=0,maxDASpeed=0,maxDobuSpeed=0
	s neIcupiId="",epiIcupiId="",daIcupiId="",dobuIcupiId=""
	s patWeight=$p(^DHCICUArrange(+icuaId),"^",25)
	
	w sofaCVSPos_"====================",!
	i sofaCVSPos>0 d //个人模板找持续泵的参数项
		.s icupId=$o(^DHCICUPara(0,"ICUA",+icuaId,""))
		.q:icupId=""
		.s icupiSub=10000,mainIcupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..i $p(^DHCICUPara(icupId,"I",icupiSub),"^",19)="" s mainIcupiSub=icupiSub
			..i $p(^DHCICUPara(icupId,"I",icupiSub),"^",19)=(icupId_"||"_mainIcupiSub),$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)=sofaCVSDoseSpeedIcucriId d
				...s icupiCode=$p(^DHCICUPara(icupId,"I",icupiSub),"^",13)
				...i (icupiCode[",NE")!(icupiCode[",去甲肾上腺素") s neIcupiId=icupId_"||"_icupiSub
				...i (icupiCode[",Epi")!(icupiCode[",肾上腺素") s epiIcupiId=icupId_"||"_icupiSub
				...i (icupiCode[",DA")!(icupiCode[",多巴胺") s daIcupiId=icupId_"||"_icupiSub
				...i (icupiCode[",Dobu")!(icupiCode[",多巴酚丁胺") s dobuIcupiId=icupId_"||"_icupiSub
	//w neIcupiId_"\"_epiIcupiId_"\"_daIcupiId_"\"_dobuIcupiId,!
	s orderTime=0
	f orderDate=startDate:1:endDate  d //提取重症监护数据计算最大最小值
		.f  s orderTime=$o(^DHCICUOrder(0,"SttDateTime",orderDate,+icuaId,orderTime)) q:(orderTime="")  d
			..q:((orderDate=startDate)&(orderTime'>startTime))
			..q:((orderDate=endDate)&(orderTime>endTime))
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",orderDate,+icuaId,orderTime,icuoId)) q:(icuoId="")  d
				...s icucriId=$p($g(^DHCICUOrder(icuoId)),"^",2)
				...q:icucriId=""
				...q:(("^"_icucriIdStr_"^"_sofaCVSDoseSpeedIcucriId_"^")'[("^"_icucriId_"^"))
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...//w icucriId,"\",icuoId,!
				...i sofaCVSPos>0,patWeight>0,icucriId=sofaCVSDoseSpeedIcucriId d //另外计算sofa药物
					....s curSpeedDose=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,patWeight,"",1)
					....//w icuoId_" icuoId,"_$p(^DHCICUOrder(icuoId),"^",38),"\"_$p(^DHCICUOrder(icuoId),"^",19)_"\"_curSpeedDose_"\"_patWeight,!
					....i neIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxNESpeed<curSpeedDose s maxNESpeed=curSpeedDose
					....i epiIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxEpiSpeed<curSpeedDose s maxEpiSpeed=curSpeedDose
					....i daIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxDASpeed<curSpeedDose s maxDASpeed=curSpeedDose
					....i dobuIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxDobuSpeed<curSpeedDose s maxDobuSpeed=curSpeedDose
					....//w maxNESpeed_"\"_maxEpiSpeed_"\"_maxDASpeed_"\"_maxDobuSpeed,!
				...s pos=$g(icucriIdPos(icucriId))
				...q:(pos="")
				...s baseIcucriId=$lg(^DHCCLC("Score",+$p(clcsIdStr,"^",pos)),12)
				...s baseValue=$lg(^DHCCLC("Score",$p(clcsIdStr,"^",pos)),13)
				...s ifQuit=0
				...i (baseIcucriId'="")&(baseValue'="") d
					....s baseIcuoId="",ifQuit=1
					....f  s baseIcuoId=$o(^DHCICUOrder(0,"RecordItem",baseIcucriId,orderDate,+icuaId,orderTime,baseIcuoId)) q:baseIcuoId=""  d
						.....q:'$d(^DHCICUOrder(baseIcuoId))
						.....q:"ICD"[$p(^DHCICUOrder(baseIcuoId),"^",25)
						.....//i baseValue="Arterial" w icuoId,"\",baseIcuoId,!
						.....i $p(^DHCICUOrder(baseIcuoId),"^",10)=baseValue s ifQuit=0
				...q:ifQuit
				...s icuoQty=$p($g(^DHCICUOrder(icuoId)),"^",11)
				...s icuoNote=$p(^DHCICUOrder(icuoId),"^",10)
				...i $d(qtyDataOptionList(icucriId))>0 d //按选项调整
					....s icucriOptions=$p(^DHCICUC("RecordItem",icucriId),"^",11)
					....s optionPos=0
					....//w icuoNote,"\"_icucriOptions
					....f j=1:1:$l(icucriOptions,";") d
						.....i $p(icucriOptions,";",j)=icuoNote d
							......s icuoQty=$p(qtyDataOptionList(icucriId),";",j)
				...//w icucriId_"\"_icuoQty,"\"_maxQtyStr_"\"_icuoId,!
				...i $lg(^DHCCLC("Score",$p(clcsIdStr,"^",pos)),11)="S" d
					....//w "icuoQty="_icuoQty,!
					....s $p(maxQtyStr,"^",pos)=$p(maxQtyStr,"^",pos)+icuoQty
					....s $p(minQtyStr,"^",pos)=$p(minQtyStr,"^",pos)+icuoQty
				...q:$lg(^DHCCLC("Score",$p(clcsIdStr,"^",pos)),11)="S"
				...i ($p(maxQtyStr,"^",pos)="")!(icuoQty>$p(maxQtyStr,"^",pos)) d
					....s $p(maxQtyStr,"^",pos)=icuoQty
					....s maxOptionNoteList(icucriId)=icuoNote
					....w icuoQty_" max\"_maxQtyStr,"/"_icuoId,"/"_maxOptionNoteList(icucriId),!
				...i ($p(minQtyStr,"^",pos)="")!(icuoQty<$p(minQtyStr,"^",pos)) d
					....s $p(minQtyStr,"^",pos)=icuoQty
					....s minOptionNoteList(icucriId)=icuoNote
					....w icuoQty_" min\"_minQtyStr,"/"_icuoId,"/"_minOptionNoteList(icucriId),!
	f i=1:1:$l(clcsIdStr,"^")  d //后补项调整
		.s clcsId=$p(clcsIdStr,"^",i)
		.q:'$d(^DHCCLC("Score",clcsId))
		.q:$p(maxQtyStr,"^",i)'=""
		.q:$lg(^DHCCLC("Score",clcsId),14)=""
		.s succeedComOrdCode=$lg(^DHCCLC("Score",clcsId),14) //调整
		.//w "succeedComOrdCode="_succeedComOrdCode,!
		.s succeedIcucriId=$o(^DHCICUC("RecordItem",0,"Code",succeedComOrdCode,""))
		.q:succeedIcucriId=""
		.s minMaxQty=##class(web.DHCICUOrder).GetRecordValue(+icuaId,succeedIcucriId,startDate,startTime,endDate,endTime,"MinMax")
		.s $p(minQtyStr,"^",i)=$p(minMaxQty,"#"),$p(maxQtyStr,"^",i)=$p(minMaxQty,"#",2)
	i maxNESpeed>0 s maxNESpeed=$fn(maxNESpeed,"",3)
	i maxEpiSpeed>0 s maxEpiSpeed=$fn(maxEpiSpeed,"",3)
	i maxDASpeed>0 s maxDASpeed=$fn(maxDASpeed,"",3)
	
	i icuaId>0 s EpisodeID=+^DHCICUArrange(+icuaId)
	w "EpisodeID="_EpisodeID_"++++++++++++++",!
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	f i=1:1:$l(clcsIdStr,"^") d //lab result
		.s clcsId=$p(clcsIdStr,"^",i)
		.q:'$d(^DHCCLC("Score",clcsId))
		.s standardCode=$lg(^DHCCLC("Score",clcsId),10)
		.q:standardCode=""
		.s testQtyStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standardCode, startDate, startTime, endDate, endTime)
		.//w standardCode_"\"_testQtyStr,!
		.f j=1:1:$l(testQtyStr,ETX) d
			..s testQty=$p(testQtyStr,ETX,j)
			..q:testQty=""
			..q:$p(testQty,STX)=""
			..s testQty=+testQty
			..//w "testQty="_testQty_STX_$p(maxQtyStr,"^",i),!
			..i ($p(maxQtyStr,"^",i)="")!(testQty>$p(maxQtyStr,"^",i)) s $p(maxQtyStr,"^",i)=testQty
			..i ($p(minQtyStr,"^",i)="")!(testQty<$p(minQtyStr,"^",i)) s $p(minQtyStr,"^",i)=testQty
	//w maxQtyStr_" max/min ",!
	//w minQtyStr,!
	f i=1:1:$l(clcsIdStr,"^")  d
		.s clcsId=$p(clcsIdStr,"^",i)
		.q:'$d(^DHCCLC("Score",clcsId))
		.s icucriId=$p(icucriIdStr,"^",i)
		.i $lg(^DHCCLC("Score",clcsId),3)="S" d //计算传入的选项值
			..s curStr=$p(clcsStr,"^",i)
			..//w "select:  curStr="_curStr,!
			..q:$p(curStr,"|",2)=""
			..s curValue=$p(curStr,"|",2)
			..s clcsoSub="",curScore=""
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...//w $lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)_"/"_curValue,!
				...i $lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)=curValue s curScore=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
			..//w curValue_"  curScore="_curScore,!
			..q:curScore=""
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_curScore
			..//w result,!
		.q:($lg(^DHCCLC("Score",clcsId),3)'="C")&(i'=sofaCVSPos)&($d(qtyDataOptionList(+icucriId))=0)
		.q:$p(maxQtyStr,"^",i)=""
		.s clcsoSub="",maxQtyValue="",minQtyValue=""
		.f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
			..s minValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),3)
			..s maxValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),4)
			..i ($p(minQtyStr,"^",i)'<minValue)&($p(minQtyStr,"^",i)'>maxValue) d
				...s minQtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...w clcsId_"/"_$p(minQtyStr,"^",i)_"minQtyValue="_minQtyValue,!
			..i ($p(maxQtyStr,"^",i)'<minValue)&($p(maxQtyStr,"^",i)'>maxValue) d
				...s maxQtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...w clcsId_"/"_$p(maxQtyStr,"^",i)_"maxQtyValue="_maxQtyValue,!
		.w maxQtyValue,"\"_minQtyValue,!
		.i maxQtyValue>minQtyValue d
			..q:maxQtyValue=""
			..s curValue=$p(maxQtyStr,"^",i)
			..i icucriId'="",$d(qtyDataOptionList(icucriId))>0 s curValue=$g(maxOptionNoteList(icucriId))
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_maxQtyValue
		.e  d
			..q:minQtyValue=""
			..s curValue=$p(minQtyStr,"^",i)
			..i icucriId'="",$d(qtyDataOptionList(icucriId))>0 s curValue=$g(minOptionNoteList(icucriId))
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_minQtyValue
	//w "~~~"_result_"~~~",!
	i sofaCVSPos>0 d //另外根据用药的计算低血压评分，大于1起作用
		.s cvsNote=$p(result,"^",sofaCVSPos)
		.i $p(cvsNote,"|",3)>0 s $p(cvsNote,"|",3)=$p($g(^DHCICUC("RecordItem",$p(cvsNote,"|",2))),"^",2)_":"_$p(cvsNote,"|",3)
		.s $p(result,"^",sofaCVSPos)=cvsNote
		.s sofaCVSScore=0,cvsSpeed=0,cvsStr="",sofaQty=0
		.i (maxNESpeed>0.1)!(maxEpiSpeed>0.1)!(maxDASpeed>15) d
			..//w maxNESpeed,"\",maxEpiSpeed,"\",maxDASpeed,!
			..s sofaCVSScore=4
			..i maxNESpeed>0.1 s cvsStr="去甲肾上腺素:",sofaQty=maxNESpeed
			..e  d
				...i maxEpiSpeed>0.1 s cvsStr="肾上腺素:",sofaQty=maxEpiSpeed
				...e  s cvsStr="多巴胺:",sofaQty=maxDASpeed
		.e  d
			..i (maxNESpeed>0)!(maxEpiSpeed>0)!(maxDASpeed>5) d
				...s sofaCVSScore=3
				...i maxNESpeed>0.1 s cvsStr="去甲肾上腺素:",sofaQty=maxNESpeed
					....e  d
						.....i maxEpiSpeed>0.1 s cvsStr="肾上腺素:",sofaQty=maxEpiSpeed
						.....e  s cvsStr="多巴胺:",sofaQty=maxDASpeed
			..e  d
				...i (maxDASpeed>5)!(maxDobuSpeed>0) d
					....s sofaCVSScore=2
					....i maxDASpeed>0 s cvsStr="多巴胺:",sofaQty=maxDASpeed
					....e  s cvsStr="多巴酚丁胺:",sofaQty=maxDobuSpeed
		.q:sofaCVSScore<2
		.s cvsNote=$p(clcsIdStr,"^",sofaCVSPos)_"||"_cvsStr_sofaQty_"|"_sofaCVSScore
		.s $p(result,"^",sofaCVSPos)=cvsNote
	//w "###"_result_"###",!,!
	w "@@@ "_clcsIdStr_" @@@",!
	f j=1:1:$l(clcsIdStr,"^") d
		.s clcsId=$p(clcsIdStr,"^",j)
		.q:clcsId=""
		.s scoreCode=$lg($g(^DHCCLC("Score",clcsId)),1)
		.q:scoreCode=""
		.s tmpIcucriId=""
		.s clcsComOrdCode=$lg(^DHCCLC("Score",clcsId),9) // 常用医嘱Code
		.i clcsComOrdCode'="" s tmpIcucriId=$o(^DHCICUC("RecordItem",0,"Code",clcsComOrdCode,"")) //常用医嘱ID
		.//w "?????????????"
		.i "AGE"=$$ALPHAUP^SSUTIL4(scoreCode) d //计算年龄
			..s age=+##class(web.DHCICUCom).GetPatientAgeByDate(+icuaId,endDate,EpisodeID)
			..s clcsoSub="",qtyValue=""
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s minValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),3)
				...s maxValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),4)
				...i (age'<minValue)&(age'>maxValue) d
					....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
			..//w " score="_qtyValue,!
			..//s $p(scoreValueList,"^",j)=clcsId_"||"_age_"|"_qtyValue
			..s $p(result,"^",j)=$p(clcsIdStr,"^",j)_"||"_age_"|"_qtyValue
		.i "ARF"=$$ALPHAUP^SSUTIL4(scoreCode) d //调整急性肾功能衰竭
			..s curStr=$p(clcsStr,"^",j)
			..s curVal=$p(curStr,"|",2)
			..s icuaAcuteRenalFailure="否"
			..i curVal="是" s icuaAcuteRenalFailure=curVal
			..i (icuaId>0)&($p(^DHCICUArrange(+icuaId),"^",26)="Y") s icuaAcuteRenalFailure="是"
			..//s $p(scoreValueList,"^",j)=clcsId_"||"_icuaAcuteRenalFailure_"|"
			..s $p(result,"^",j)=clcsId_"||"_icuaAcuteRenalFailure_"|"
			..//w "         ////Curent AFR ="_j_":"_$p(result,"^",j),!
			..q:icuaAcuteRenalFailure="否"
			..f k=1:1:$l(clcsIdStr,"^") d
				...s subClcsId=$p(clcsIdStr,"^",k)
				...q:subClcsId=""
				...s subScoreCode=$lg($g(^DHCCLC("Score",subClcsId)),1)
				...//w "   subcode:"_subScoreCode,!
				...i subScoreCode="Creatinine(ARF×2)" d
					....//w "Before        "_$p(result,"^",k),!
					....s arfStr=$p(result,"^",k)
					....s $p(arfStr,"|",4)=2*$p(arfStr,"|",4)
					....s $p(result,"^",k)=arfStr
					....//w "After        "_$p(result,"^",k),!
		.i "CHP"=$$ALPHAUP^SSUTIL4(scoreCode) d //调整慢性健康评分
			..q:+icuaId<1
			..s clcsoSub="",qtyValue=""
			..s icuaChronicHealthPoint=$p(^DHCICUArrange(+icuaId),"^",27)
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...i (icuaChronicHealthPoint=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)) d
					....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
			..//s $p(scoreValueList,"^",j)=clcsId_"||"_icuaChronicHealthPoint_"|"_qtyValue
			..s $p(result,"^",j)=clcsId_"||"_icuaChronicHealthPoint_"|"_qtyValue
		.i "FIO2"=$$ALPHAUP^SSUTIL4(scoreCode) d // FiO2评分
			..s fioStr=$p(result,"^",j)
			..s qtyValue=$p($g(fioStr),"|",4)
			..w "~~~~~~~~~~~~~~~"_clcsComOrdCode_","_tmpIcucriId_","_qtyValue_","_ifDefault_","_j,!
			..i (qtyValue="")&&(ifDefault="1") d
			...;s ^Lynt("FIO2")=clcsId_"|"_tmpIcucriId_"|21|0"
			...s $p(result,"^",j)= clcsId_"|"_tmpIcucriId_"|21|0"
		.i "PAO2IFFIO250"=$$ALPHAUP^SSUTIL4(scoreCode) d // pO2评分
			..s fioStr=$p(result,"^",j)
			..s qtyValue=$p($g(fioStr),"|",4)
			..w "~~~~~~~~~~~~~~~"_clcsComOrdCode_","_tmpIcucriId_","_qtyValue_","_ifDefault_","_j,!
			..i (qtyValue="")&&(ifDefault="1") d
			...;s ^Lynt("PAO2IFFIO250")=clcsId_"|"_tmpIcucriId_"|80|0"
			...s $p(result,"^",j)= clcsId_"|"_tmpIcucriId_"|80|0"
		.i "APACHEPH"=$$ALPHAUP^SSUTIL4(scoreCode) d // 动脉血酸碱度 pH
			..s fioStr=$p(result,"^",j)
			..s qtyValue=$p($g(fioStr),"|",4)
			..w "~~~~~~~~~~~~~~~"_clcsComOrdCode_","_tmpIcucriId_","_qtyValue_","_ifDefault_","_j,!
			..i (qtyValue="")&&(ifDefault="1") d
			...;s ^Lynt("APACHEPH")=clcsId_"|"_tmpIcucriId_"|7.4|0"
			...s $p(result,"^",j)= clcsId_"|"_tmpIcucriId_"|7.4|0"
		.i "AADO2IFFIO2≥50"=$$ALPHAUP^SSUTIL4(scoreCode) d // 肺泡动脉氧压差 常用医嘱Code AaDO2
			..s fioStr=$p(result,"^",j)
			..s qtyValue=$p($g(fioStr),"|",4)
			..w "~~~~~~~~~~~~~~~"_clcsComOrdCode_","_tmpIcucriId_","_qtyValue_","_ifDefault_","_j,!
			..i (qtyValue="")&&(ifDefault="1") d
			...;s ^Lynt("AADO2IFFIO2")=clcsId_"|"_tmpIcucriId_"|60|0"
			...s $p(result,"^",j)= clcsId_"|"_tmpIcucriId_"|60|0"
	//f i=1:1:$l(clcsIdStr,"^") d
	s clcslId=0
	f  s clcslId=$o(^DHCCLC("ScoreLink",clcslId)) q:clcslId=""  d
		.q
		.i ("^"_clcsIdStr_"^")[$lg(^DHCCLC("ScoreLink",i),2)
		.f  s clcslId=$o(^DHCCLC("ScoreLink",clcslId)) q:clcslId=""  d
			..s secondClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:secondClcsId=""
			..s clcsIdList(clcsId,secondClcsId)=""
	q result
}

// 手动执行插入评分数据

// w ##class(web.DHCCLScore).CheckAutoAddScoreOrderByHour("2013-07-01","4017","56",1)

ClassMethod CheckAutoAddScoreOrderByHour(indateList = "", IcuaIdList = "", WardLocIdList = "", ifDebug = 1) As %String
{
	s retstr=""	
	;s IcuaIdList="4026^4027^4034^4036^4039^4042^4044^4045^4053^4054^4055^4057^4059^4063^4064^4068^4069^4071^4074^4076^4078^4079^4082^4084^4085^4086^4089^4090^4092^4096^4097^4100^4102^4103^4104^4105^4108^4109^4113^4116^4117^4121^4123^4127^4131^4132^4135^4136^4137^4139^4141^4145^4146^4148^4149^4150^4151^4152^4154^4155^4156^4158"
	;s IcuaIdList="4018^4021^4023^4025^4028^4029^4030^4032^4033^4035^4038^4040^4041^4043^4048^4049^4051^4052^4056^4058^4060^4062^4065^4067^4070^4072^4073^4077^4080^4081^4083^4087^4088^4091^4094^4095^4098^4099^4106^4110^4111^4112^4114^4118^4119^4120^4126^4128^4130^4133^4134^4140^4142^4143^4144^4147^4153^4157^4160^4162"
	;s IcuaIdList="325^328^329^332^334^323^326^327^330^333"
	;f i=325:1:1294 d
	;.i IcuaIdList="" s IcuaIdList=i
	;.e  s IcuaIdList=IcuaIdList_"^"_i
	i IcuaIdList'="" d
	.f i=1:1:$l(IcuaIdList,"^") d
	..s icuaId=$p(IcuaIdList,"^",i)
	..q:icuaId="" 
	..s retstr=##class(web.DHCCLScore).AutoAddScoreOrderByHour("","",icuaId,"",26,232,"",ifDebug)
	i WardLocIdList'="" d
	.f i=1:1:$l(WardLocIdList,"^") d
	..s LocId=$p(WardLocIdList,"^",i)
	..q:LocId=""
	..f j=1:1:$l(indateList,"^") d
	...s indate=$p(indateList,"^",j)
	...q:indate=""
	...s retstr=##class(web.DHCCLScore).AutoAddScoreOrderByHour(indate,"","",LocId,26,232,"",ifDebug)
}

/// 入参inDate, hour为空，自动找入院24小时后第一次，needWardLocId为空时，按needIcuaId找，
/// ifDebug为0插入数据，为1只组织数据不插入。
ClassMethod AutoAddScoreOrderByHour(inDate, hour, needIcuaId = "", needWardLocId = "", needClcsId = "", ancvcId = "", userId = "", ifDebug = 0) As %String
{
	//w ##class(web.DHCCLScore).AutoAddScoreOrderByHour("","",2874,"","APACHEII","APACHEII","",1) //这样调用换病人只改一个icuaIdr入参
	//w ##class(web.DHCCLScore).AutoAddScoreOrderByHour("2015-05-16","15",6113,"",38,233,"",1) //这样调用换病人只改一个icuaIdr入参
	//w ##class(web.DHCCLScore).AutoAddScoreOrderByHour("2015/08/04","14",7104,"","SOFA","SOFA",3879,1)
	q:(needIcuaId="")&(needWardLocId="") ""
	s inTime=hour*3600
	i (needIcuaId'="")&((inDate="")!(hour="")) d
		.w "in"
		.s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",needIcuaId,"","","^","D")
		.w inDateTime,!
		.i hour="" d
			..s inTime=$p(inDateTime,"^",2)
			..s inTime=inTime\3600*3600
		.i inDate="" s inDate=+inDateTime
		.w "inTime="_inTime,!
	q:inDate="" "null date"
	i needWardLocId="" d
		.s needWardLocId=##Class(web.DHCICUCom).GetWardCtlocId("",needIcuaId)
	s inDate=##class(web.DHCClinicCom).ConvertToDateH(inDate)
	w inDate_"/"_inTime,!
	w inDate_","_inTime,!
	w inDate+1_","_inTime_","_needIcuaId_","_needWardLocId_","_needClcsId_","_ancvcId_","_""_","_ifDebug
	
	q ##class(web.DHCCLScore).AutoAddScoreOrder(inDate,inTime,inDate+1,inTime,needIcuaId,needWardLocId,needClcsId,ancvcId,"",ifDebug)
}

/// 自动插入评分数据
/// 入参：日期、时间
/// startDate:开始日期,startTime:开始时间
/// endDate：评分日期, endTime：评价时间
/// needIcuaId:icuaId
/// needWardLocId:登陆科室
/// needClcsId:评分总分主项 APACHEII,SOFA
/// ancvcId:显示分类代码，APACHEII,SOFA
/// ifPerHour是否每小时执行（非24小时）
/// 旧方法
ClassMethod AutoAddScoreOrderOld(startDate, startTime, endDate, endTime, needIcuaId = "", needWardLocId = "", needClcsCode = "", ancvcCode = "", userId = "", ifDebug = 0, ifPerHour = 0) As %String
{
	//w ##class(web.DHCCLScore).AutoAddScoreOrder($h-1,13*3600,$h,13*3600,687,56,26,232,"",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder(63320,50400,63321,50400,2874,56,"APACHEII","APACHEII","",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder(63768,50400,63769,50400,7104,88,"APACHEII","APACHEII","3879",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder("2015-05-18","15:00:00","2015-05-18","15:00:00",6113,,38,233,"",1)
	//icucriList(icucriId):待插入数据；icupiSub^cat^value
	//scoreSrcList(scoreCode)评分代码对应源数据icucriId；
	//scoreList(scoreCode)评分代码对应评分值icucriId
	//mainScoreList(layer,clcsId,secondClcsId)主项到从项的树形结构，第一个节点是层
	
	s needClcsId=""
	i needClcsCode'="" d
		.i needClcsCode=+needClcsCode s needClcsId=needClcsCode
	 	.e  s needClcsId=$o(^DHCCLC("Score",0,"Code",needClcsCode,"")) 
	s ancvcId=""
	i ancvcCode'="" d
		.i ancvcCode=+ancvcCode s ancvcId=ancvcCode
		.e  s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	w needClcsId_"/"_ancvcId,!
	q:(needClcsId="")!(ancvcId="") -1
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	s startDateTime=startDate+((startTime+1)/100000)
	s endDateTime=endDate+((endTime+1)/100000)
	s calDuration=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,endDate,endTime) //计算两个时间的时间差
	k scoreCodeToIdList
	s clcsId=0
	f  s clcsId=$o(^DHCCLC("Score",clcsId)) q:clcsId=""  d
		.q:$lg(^DHCCLC("Score",clcsId),1)=""
		.s scoreCodeToIdList($lg(^DHCCLC("Score",clcsId),1))=clcsId
	i needClcsId="" s clcsIdList(26)=""
	e  s clcsIdList(needClcsId)=""
	//s clcsIdList(38)="" //!!
	i ancvcId="" s ancvcId="232" 
	w clcsIdList(needClcsId),!
	w ancvcId,!
	//s ancvcId="232^233" //!!
	s scoreItemStr=""
	k mainScoreList
	s clcsId=""
	//b
	f  s clcsId=$o(clcsIdList(clcsId)) q:clcsId=""  d  //评分关联项：主项到从项的树形结构
		.s clcslId=""
		.f  s clcslId=$o(^DHCCLC("ScoreLink",0,"M",clcsId,clcslId)) q:clcslId=""  d
			..s secondClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:secondClcsId=""
			..s clcsIdList(clcsId,secondClcsId)=""
			..s mainScoreList(1,clcsId,secondClcsId)="" //，
			..s curIcucriCode=$lg($g(^DHCCLC("Score",secondClcsId)),9)
			..s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
			..w clcsId_","_secondClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",secondClcsId)),1),!
			..s secondClcslId=""
			..f  s secondClcslId=$o(^DHCCLC("ScoreLink",0,"M",secondClcsId,secondClcslId)) q:secondClcslId=""  d
				...s thirdClcsId=$lg(^DHCCLC("ScoreLink",secondClcslId),2)
				...q:thirdClcsId=""
				...q:'$d(^DHCCLC("Score",thirdClcsId))
				...s clcsIdList(clcsId,secondClcsId,thirdClcsId)=""
				...s mainScoreList(2,secondClcsId,thirdClcsId)=""
				...s curIcucriCode=$lg($g(^DHCCLC("Score",thirdClcsId)),9)
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
				...w clcsId_","_secondClcsId_","_thirdClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",thirdClcsId)),1),!
				...s thirdClcslId=""
				...f  s thirdClcslId=$o(^DHCCLC("ScoreLink",0,"M",thirdClcsId,thirdClcslId)) q:thirdClcslId=""  d
					....s fourthClcsId=$lg(^DHCCLC("ScoreLink",thirdClcslId),2)
					....q:fourthClcsId=""
					....q:'$d(^DHCCLC("Score",fourthClcsId))
					....s clcsIdList(clcsId,secondClcsId,thirdClcsId,fourthClcsId)=""
					....s curIcucriCode=$lg($g(^DHCCLC("Score",fourthClcsId)),9)
					....s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
					....w clcsId_","_secondClcsId_","_thirdClcsId_","_fourthClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2),"\"_$lg($g(^DHCCLC("Score",fourthClcsId)),1),!
					....i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
					....s scoreItemStr=scoreItemStr_fourthClcsId
					....s mainScoreList(3,thirdClcsId,fourthClcsId)=""
				...//q:$d(clcsIdList(clcsId,secondClcsId,thirdClcsId))=11
				...i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
				...s scoreItemStr=scoreItemStr_thirdClcsId
			..q:$d(clcsIdList(clcsId,secondClcsId))=11
			..i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
			..s scoreItemStr=scoreItemStr_secondClcsId
	f i=1:1:$l(scoreItemStr,"^") d
		.s clcsId=$p(scoreItemStr,"^",i)
		.q:clcsId=""
		.s $p(scoreCodeStr,"^",i)=$lg(^DHCCLC("Score",clcsId),1)
	w scoreItemStr,!
	w scoreCodeStr,!
	s arfId=$o(^DHCCLC("Score",0,"Code","ARF",""))
	w arfId_"/"_$l(arfId),!
	i ("^"_scoreCodeStr_"^")["^Creatinine(ARF×2)^" s scoreItemStr=scoreItemStr_"^"_arfId //有Apache血清肌酐添加急性肾功能衰竭
	s nbpId=$o(^DHCCLC("Score",0,"Code","NBP",""))
	w nbpId_"/"_$l(nbpId),!
	i ("^"_scoreCodeStr_"^")["^AMBP^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有AMBP时添加NBP
	i ("^"_scoreCodeStr_"^")["^SOFAHypotension^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有SOFAHypotension,加AMBP，加NBP?
	s sofaUrineId=$o(^DHCCLC("Score",0,"Code","SOFAUrine",""))
	w sofaUrineId_"/"_$l(sofaUrineId),!
	i ("^"_scoreCodeStr_"^")["^SOFACreatinineAndUrine^" s scoreItemStr=scoreItemStr_"^"_sofaUrineId //在有肌酐umol/L时添加尿量
	w scoreItemStr,!
	
	//s icucriId=""
	//f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
	//	.q:("^"_ancvcId_"^")'[$p(^DHCICUC("RecordItem",icucriId),"^",5)
	//	.s icucriIdList(icucriId)=""
	//	.w icucriId_","_$p(^DHCICUC("RecordItem",icucriId),"^",2),!
	
	s propertyId="",scoreItemPropertyId="",isScorePropertyId="",affectiveScoreItemId=""
	f  s propertyId=$o(^DHCICUC("Property",propertyId)) q:propertyId=""  d
		.i $lg(^DHCICUC("Property",propertyId),1)="ScoreItemCode" s scoreItemPropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="IsScore" s isScorePropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="AffectiveScoreItemCode" s affectiveScoreItemId=propertyId
	//w scoreItemPropertyId_"\"_isScorePropertyId,!
	w "评分层次>===================================<科室模板",!
	
	s wardCtlocId="",retStr=""
	f  s wardCtlocId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId)) q:wardCtlocId=""  d
		.q:(needWardLocId'="")&(needWardLocId'=wardCtlocId)
		.k paraItemList
		.s icupId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId,""))
		.
		.s icupiSub=""
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..s icucriId=$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)
			..//w icupId_"||"_icupiSub,"\"_icucriId,!
			..q:icucriId=""
			..;q:("^"_ancvcId_"^")'[("^"_$p(^DHCICUC("RecordItem",icucriId),"^",5)_"^")
			..q:("^"_ancvcId_"^")'[$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..s icupidSub=0,scoreItemCode="",isScore=0
			..f  s icupidSub=$o(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...i scoreItemPropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) d
					....s scoreItemCode=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",2)
				...i isScorePropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) s isScore=1
			..s icucriList(icucriId)=icupiSub_"^"_$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..w icucriId_",=="_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"\"_scoreItemCode,"\",isScore,"\"_icupiSub,!
			..q:scoreItemCode=""
			..s clcsId=$g(scoreCodeToIdList(scoreItemCode))
			..q:clcsId=""
			..i $lg(^DHCCLC("Score",clcsId),6)=1 d
				...s scoreList(scoreItemCode)=icucriId
				...w "    mainScoreList:"_scoreItemCode_":"_icucriId,!
			..e  d 
				...i (isScore=1) d //!!
					....s scoreList(scoreItemCode)=icucriId
					....w "    scoreList:"_scoreItemCode_":"_icucriId,!
				...e  d
					....q:$p(^DHCICUPara(icupId,"I",icupiSub),"^",13)="ApacheFiO2ScoreSource"
					....s scoreSrcList(scoreItemCode)=icucriId
					....w "    scoreSrcList:"_scoreItemCode_":"_icucriId,!
			..i (icupiSub=326) s scoreList(scoreItemCode)=6394
		.w "    curCtlocId="_wardCtlocId,!
		.k wardEpisodeIDList
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",+needWardLocId,0))
		.s EpisodeID=""
		.i needIcuaId'="" s EpisodeID=$p($g(^DHCICUArrange(+needIcuaId)),"^",1)
		.w EpisodeID,!
		.i EpisodeID'="" d
			..s patList=""
			..q:+$p($g(^DHCICUArrange(needIcuaId)),"^",4)'=wardId
			..s patList=EpisodeID_"|||"_needIcuaId
		.e  d
			..s patList=##class(web.DHCICUCom).FindWardPatient("",wardCtlocId) //找当前病区病人
			..w EpisodeID_"/before "_patList,!
			..s searchDate=startDate-1 //查前一天病人和当天病人，考虑到转入时间与监护时间可能跨天
			..f  s searchDate=$o(^DHCICUOrder(0,"SttDateTime",searchDate)) q:(searchDate="")!(searchDate-1>startDate)  d
				...w searchDate,!
				...s icuaId=""
				...f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",searchDate,icuaId)) q:icuaId=""  d //当天来当天走的？
					....q:'$d(^DHCICUArrange(icuaId))
					....q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
					....s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
					....q:outDateTime=""
					....s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
					....q:outDate<startDate
					....s curEpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
					....q:curEpisodeID=""
					....q:("^"_patList_"|")[("^"_curEpisodeID_"|")
					....w icuaId_"\"_curEpisodeID_"\"_$zd(outDate,3)_"\"_$zt(outTime),!
					....s patList=patList_"^"_curEpisodeID_"|||"_icuaId
		.
		.w EpisodeID_"/patientList:== "_patList,!
		.s scoreStartDate=startDate
		.s scoreStartTime=startTime
		.s scoreEndDate=endDate
		.s scoreEndTime=endTime
		.f i=1:1:$l(patList,"^") d
			..s EpisodeID=+$p(patList,"^",i)
			..q:EpisodeID=0
			..s wardEpisodeIDList(EpisodeID)=""
			..s orderParaList=""
			..s icuaId=$p($p(patList,"^",i),"|",4)
			..q:icuaId=""
			..//s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
			..//q:'$d(transWardList) 	//没有转病区记录
			..//s dateTime=$o(transWardList(endDateTime),-1)
			..//q:dateTime=""
			..//w " "_transWardList(dateTime),!
			..//q:(needWardLocId'="")&(transWardList(dateTime)'=wardId)
			..//s inTime=(dateTime-$p(dateTime,"."))*100000
			..////s inDateTime=##class(web.DHCANOPCom).GetWardInDateTime(EpisodeID, startDate, startTime," ") //找入病区时间
			..////q:+inDateTime=0
			..////s inTime=##class(web.DHCANOPCom).ConvertToTimeH($p(inDateTime," ",2))
			..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			..s inDate=+inDateTime,inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
			..w EpisodeID_" inDatTeime:",inDate_"/"_inTime," endTime:",endTime_","_startDate_"/"_startTime,!
			..q:(inDate>startDate)!((inDate=startDate)&((inTime\3600*3600)>startTime))
			..q:(endDate>$h)!((endDate=+$h)&(endTime>$p($h,",",2)))
			..q:('ifPerHour)&&((inTime\3600)'=(endTime\3600)) //与入参时间不匹配则不插入
			..//s icuaId=##class(web.DHCICUCom).GetIcuaId(EpisodeID, "", "", "Y", "N", "", "", endDate, endTime)
			..w "intime mathed icuaId=="_icuaId,!
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..w " have outTime? outTime="_outDateTime
			..q:(inDate="")&(outDateTime="")
			..s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
			..i outDate=0 s outDate=+$h,outTime=$p($h,",",2)
			..w " outDate<startDate?e "_startDate
			..q:outDate<startDate
			..w "  needIcuaId?",!
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..w " start Create"
			..;===========同步数据之前============
			..s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),EpisodeID,"Before")="Apache："_preApacheII
			..
			..s retStr=$$CreateScoreData
			..;===========同步数据之后============
			..s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),EpisodeID,"After")="Apache："_afterApacheII
			..
			..w "retStr="_retStr,!
		.q:(needClcsId'="")&(needClcsId'=26)&(needClcsId'=38)
		.
		.w "             ============= Start trans and disch",!
		.s icuaId=""
		.w startDate_"///////////////////"
		.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId)) q:icuaId=""  d //当天来当天走的？
			..q:'$d(^DHCICUArrange(icuaId))
			..w "icuaId="_icuaId,!
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..w "wardId:"_wardId,!
			..q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
			..s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
			..q:EpisodeID=""
			..w "leave:EpisodeID="_EpisodeID
			..q:'$d(^PAADM(EpisodeID))
			..s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			..s paadmWardId=$p($g(^PAADM(EpisodeID)),"^",20)
			..w "/  "_needIcuaId_"/"_$d(wardEpisodeIDList(EpisodeID))
			..q:(paadmVisitStatus'="D")&(needIcuaId'="")&(paadmWardId=+$p(^DHCICUArrange(icuaId),"^",4))
			..//q:(needIcuaId'="")&($d(wardEpisodeIDList(EpisodeID)))
			..w icuaId_"/"_$p($g(^DHCICUArrange(icuaId)),"^",4),!
			..s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
			..q:'$d(transWardList) 	//没有转病区记录
			..//w "trans:"
			..
			..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			..s inDate=+inDateTime,inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
			..
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..q:outDateTime=""
			..s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
			..w startDate,"/"_endDate_"/"_inDate_"/"_inTime_"/"_outDate_"/"_outTime,!
			..q:endDate>outDate
			..q:outDate<startDate
			..s outDateTime=outDate+(outTime/100000)
			..//w "inDate="_inDate_"/"_startDate_"/"_scoreEndTime_"/"_inTime,!
			..i (inDate=startDate)&(scoreStartTime=((inTime\3600)*3600)) d //未满一天的病人
				...q:##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,outDate,outTime,"H")>24
				...s scoreEndDate=outDate,scoreEndTime=outTime
				...s orderParaList=""
				...;===========同步数据之前============
				...s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
				...i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"InOneDay","Before")="未满一天的病人 Apache："_preApacheII
				...
				...s retStr=$$CreateScoreData
				...;===========同步数据之后============
				...s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
				...i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"InOneDay","After")="未满一天的病人 Apache："_afterApacheII
			..
			..//s preEndTime=endTime-3600
			..//s preEndDate=endDate
			..//i preEndTime<0 s preEndTime=0,preEndDate=preEndDate-1
			..//s preEndDateTime=preEndDate+((preEndTime+1)/100000) //前一个小时，一小时前还在病区
			..//s dateTime=$o(transWardList(preEndDateTime),-1)
			..s dateTime=$o(transWardList(outDateTime),-1)
			..w outDateTime,!
			..//w $o(transWardList(outDateTime),-1),!
			..//w "dateTime="_dateTime_"  needWardLocId="_needWardLocId_" wardId="_wardId_" transDTWard:"_transWardList(dateTime),!
			..q:(dateTime'="")&&(needWardLocId'="")&&(transWardList(dateTime)'=wardId)
			..//w " 1 "_endDateTime_"\"_dateTime_"\"_preEndDateTime,!
			..//q:(endDateTime-dateTime>1)&(needClcsId=38) //有临出院评glasgow
			..//s inDateTime=dateTime
			..//s dateTime=$o(transWardList(preEndDateTime),1)
			..//w dateTime,!
			..//i dateTime="" d
				..//.w icuaId_" disch",! 
				..//.s dischDate=$p(^PAADM(EpisodeID),"^",17)
				..//.//q:dischDate'=endDate
				..//.s dischTime=$p(^PAADM(EpisodeID),"^",18)
				..//.s dateTime=dischDate+((dischTime)/100000)
			..//q:dateTime=""
			..//s outTime=(dateTime-$p(dateTime,"."))*100000
			..//w " 2 "_EpisodeID_"/"_dateTime_"/"_outTime_"/"_endDate_"/"_endTime,!
			..
			..//q:$p(dateTime,".")'=endDate
			..w "    still in",!
			..
			..s scoreEndDate=outDate
			..s scoreEndTime=(outTime\3600)*3600
			..i outTime-scoreEndTime>0 s scoreEndTime=scoreEndTime+3600 //出院非整点的后一小时
			..i scoreEndTime>86399 s scoreEndTime=scoreEndTime-86400,scoreEndDate=scoreEndDate+1
			..//w " 3 "_EpisodeID_"/"_outTime_"/"_scoreStartDate_"/"_scoreStartTime_"/"_scoreEndDate_"/"_scoreEndTime_"/"_endDate_"/"_endTime,!
			..q:scoreEndDate'=endDate
			..q:('ifPerHour)&&((scoreEndTime\3600)'=(endTime\3600))
			..w "  last in",!
			..s orderParaList=""
			..;===========同步数据之前============
			..s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"CreateScore","Before")="Apache："_preApacheII
			..
			..s retStr=$$CreateScoreData
			..;===========同步数据之后============
			..s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"CreateScore","After")="Apache："_afterApacheII
			..			
	q retStr
	//q scoreItemStr
CreateScoreData()
	q:+icuaId=0 -1
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	q:icupId="" -2
	
	s ifDefault=""
	i (+calDuration)>=86400 d 
	.s ifDefault="1"
	w "calDuration~~~~~~~~~~~~~~~~~~"_calDuration_","_ifDefault,!,!
	w "GetScoreValueByData~~~arg:"_icuaId_","_startDate_","_startTime_","_scoreEndDate_","_ scoreEndTime_","_ scoreItemStr_","_ifDefault,!
	s scoreValueList=..GetScoreValueByData(icuaId, startDate, startTime, scoreEndDate, scoreEndTime, scoreItemStr,"",ifDefault) //取计算评分
	;s ^Lynt("CreateScoreData")=startDate_"/"_startTime_"/"_scoreEndDate_"/"_scoreEndTime_"/"_ifDefault_"/scoreItemStr="_scoreItemStr
	w startDate_"/"_startTime_"/"_scoreEndDate_"/"_scoreEndTime_"/scoreItemStr="_scoreItemStr,!
	w "scoreValueList:"_scoreValueList,!
	s fiO2Pos="",paO2Pos="",aaDO2Pos="",ambpPos="",nbpPos="",fiO2ClcsId="",paO2ClcsId="",aaDO2ClcsId=""
	s GCSPos="",EyeOpeningPos="",VerbalResponsePos="",MotorResponsePos="",ApachePHPos=""
	s EyeOpeningValueID="6403", VerbalResponseValueID="6405", MotorResponseValueID="6407", EyeOpeningScoreID="6404", VerbalResponseScoreID="6406", MotorResponseScoreID="6408",GCSID="6382"
	s inEyeOpeningValue="", inVerbalResponseValue="", inMotorResponseValue="", inEyeOpeningScore="", inVerbalResponseScore="", inMotorResponseScore="",inGCSScore=""
	s ICUAEyeOpeningCLCSODr="",ICUAEyeOpeningCLCSODr="",ICUAMotorResponseCLCSODr="",ICUAGlasgowPoint=""
	s ICUAEyeOpeningrecordeitemID="",ICUAVerbalResponserecordeitemID="",ICUAMotorResponserecordeitemID=""
	s ICUAEyeOpeningCLCDr="",ICUAVerbalResponseCLCDr="",ICUAMotorResponseCLCDr=""
	f j=1:1:$l(scoreItemStr,"^") d
		.s clcsId=$p(scoreItemStr,"^",j)
		.q:clcsId=""
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.i scoreCode="FiO2" s fiO2Pos=j,fiO2ClcsId=clcsId
		.i scoreCode="PaO2 ifFiO2<50%" s paO2Pos=j,paO2ClcsId=clcsId
		.i scoreCode="AaDO2 ifFiO2≥50%" s aaDO2Pos=j,aaDO2ClcsId=clcsId
		.i scoreCode="AMBP" s ambpPos=j
		.i scoreCode="NBP" s nbpPos=j
		.i scoreCode="GCS" s GCSPos=j
		.i scoreCode="EyeOpening" s EyeOpeningPos=j
		.i scoreCode="VerbalResponse" s VerbalResponsePos=j
		.i scoreCode="MotorResponse" s MotorResponsePos=j
		.i scoreCode="ARF" s arfPos=j
		.i scoreCode="ApachePH" s ApachePHPos=j 
	s inWardDateTimeStr=##class(web.DHCClinicCom).GetWardInDateTime(EpisodeID,startDate,startTime," ")
	s inWardDate=startDate,inWardTime=startTime
	w "scoreValueList:in createdata "_scoreValueList,!
	w "fiO2 "_fiO2Pos_","_fiO2ClcsId,!
	w "PaO2 "_paO2Pos_","_paO2ClcsId,!
	w "AaDO2 "_aaDO2Pos_","_aaDO2ClcsId,!
	i inWardDateTimeStr'=" " d
	.s inWardDate=##class(web.DHCClinicCom).ConvertToDateH($p(inWardDateTimeStr," "))
	.s inWardTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inWardDateTimeStr," ",2))
	
    i inWardDate'="" d
    .s ICUAEyeOpeningCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",33)
	.s ICUAVerbalResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",34)
	.s ICUAMotorResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",35)
	.q:(ICUAEyeOpeningCLCSODr="")!(ICUAVerbalResponseCLCSODr="")!(ICUAMotorResponseCLCSODr="")
	.s inEyeOpeningValue=$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",1)
	.s inEyeOpeningScore=$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",2)
	.s ICUAEyeOpeningrecordeitemID =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",3)
	.s ICUAEyeOpeningCLCDr =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",4)
	.s inEyeOpeningStr=$p(scoreValueList,"^",EyeOpeningPos)
	.;i inEyeOpeningStr'="" s $p(inEyeOpeningStr,"|",3) =inEyeOpeningValue
	. s $p(inEyeOpeningStr,"|",3) =inEyeOpeningValue
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningStr
    .w $p(scoreValueList,"^",EyeOpeningPos),"\"_inEyeOpeningStr_"\"_inEyeOpeningValue,!
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",4)=inEyeOpeningScore 
	. s $p(inEyeOpeningScoreStr ,"|",4)=inEyeOpeningScore 
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",2)=ICUAEyeOpeningrecordeitemID 
	.s $p(inEyeOpeningScoreStr ,"|",2)=ICUAEyeOpeningrecordeitemID 
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",1)=ICUAEyeOpeningCLCDr
	.i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",1)=ICUAEyeOpeningCLCDr
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.
	.s inVerbalResponseValue=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",1)
	.s inVerbalResponseScore=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",2)
	.s ICUAVerbalResponserecordeitemID=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",3)
	.s ICUAVerbalResponseCLCDr=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",4)
	.s inVerbalResponseStr=$p(scoreValueList,"^",VerbalResponsePos)
	.s $p(inVerbalResponseStr ,"|",3)=inVerbalResponseValue 
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseStr 
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",4)=inVerbalResponseScore 
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",2)=ICUAVerbalResponserecordeitemID
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr 
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",1)=ICUAVerbalResponseCLCDr
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr  
	.
	.s inMotorResponseStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseStr ,"|",3)=inMotorResponseValue
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseStr 
	.s inMotorResponseValue=$p(..GetValueAndScore(ICUAMotorResponseCLCSODr),"^",1)
	.s inMotorResponseScore=$p(..GetValueAndScore(ICUAMotorResponseCLCSODr),"^",2)
	.s ICUAMotorResponserecordeitemID =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",3)
    .s ICUAMotorResponseCLCDr =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",4)
	.;s inGCSScore=ICUAGlasgowPoint
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",4)=inMotorResponseScore
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",2)=ICUAMotorResponserecordeitemID 
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",1)=ICUAMotorResponseCLCDr
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.;b ;"2"
	
		w "scoreValueList:after gcs "_scoreValueList,!

	// 血气评分计算 Add 2014-02-28 17-33-41
	w icuaId_","_startDate_","_startTime_","_endDate_","_endTime_","_paO2ClcsId_","_aaDO2ClcsId_","_fiO2ClcsId,!
	s apacheScoreStr=##class(web.DHCCLScore).GetApacheOxygenation(icuaId, startDate, startTime, endDate, endTime, paO2ClcsId, aaDO2ClcsId, fiO2ClcsId)
	w apacheScoreStr,!	
	// 如果没有下血气医嘱,把血气评分值默认为0(正常) 20141120
	i (needIcuaId'="")&&(EpisodeID="") s EpisodeID=$p($g(^DHCICUArrange(+needIcuaId)),"^",1)
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	/*f j=1:1:$l(scoreValueList,"^") d
		.s tmpScoreValue=$p(scoreValueList,"^",j)
		.q:tmpScoreValue=""
		.s tmpScoreId=$p(tmpScoreValue,"|",1)
		.q:tmpScoreId=""
		.s tmpScoreCode=$lg(^DHCCLC("Score",tmpScoreId),1)
		.q:(tmpScoreId'="")&&(tmpScoreId'=paO2Pos)&&(tmpScoreId'=aaDO2Pos)&&(tmpScoreId'=ApachePHPos)
		.i tmpScoreId=paO2Pos s tmpArcimId=""
		.i tmpScoreId=aaDO2Pos s tmpArcimId=""
		.i tmpScoreId=ApachePHPos s tmpArcimId=""
		.s tmpIcucriId=$p(tmpScoreValue,"|",2)
		.s tmpValue=$p(tmpScoreValue,"|",3)
		.s tmpScore=$p(tmpScoreValue,"|",4)
		.i tmpValue="" d //只获取备注是动脉血气的医嘱
		..s OeOrdDesc=##class(web.DHCICUStat).getOeOrdAndDateTime(startDate, startTime, endDate, endTime,"","","33483||1",oeordId,"","oerIdAndDT","V","动脉")
		..i OeOrdDesc="" s tmpScore="0"
		.i tmpScoreId=paO2Pos s $p(scoreValueList,"^",paO2Pos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
		.i tmpScoreId=aaDO2Pos s $p(scoreValueList,"^",aaDO2Pos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
		.i tmpScoreId=ApachePHPos s $p(scoreValueList,"^",ApachePHPos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
	w "scoreValueList:before paO2 "_scoreValueList,!*/
	;w $p(apacheScoreStr,"^",1),!
	i (paO2Pos>0)&&($p($p(apacheScoreStr,"^",1),"|",3)'="") s $p(scoreValueList,"^",paO2Pos)=$p(apacheScoreStr,"^",1)
	i (aaDO2Pos>0)&&($p($p(apacheScoreStr,"^",2),"|",3)'="") s $p(scoreValueList,"^",aaDO2Pos)=$p(apacheScoreStr,"^",2)
	i (fiO2Pos>0)&&($p($p(apacheScoreStr,"^",3),"|",3)'="") s $p(scoreValueList,"^",fiO2Pos)=$p(apacheScoreStr,"^",3)
	w "scoreValueList:after paO2 "_scoreValueList,!
	f j=1:1:$l(scoreItemStr,"^") d  //叶结点数据对应常用医嘱项
		.s clcsId=$p(scoreItemStr,"^",j)
		.q:clcsId=""
		.w j_" "_clcsId_" "
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.q:scoreCode=""
		.s scoreValue=$p(scoreValueList,"^",j)
		.//q:scoreValue=""
		.w scoreCode_"/"_$g(scoreSrcList(scoreCode)),"/"_$g(scoreList(scoreCode)),!
		.
		.i $d(scoreSrcList(scoreCode)) d	//数据项
			..s $p(icucriList(scoreSrcList(scoreCode)),"^",3)=$p(scoreValue,"|",3)
			..i scoreCode="FiO2" d
				...//tobe//i $p(icucriList(scoreSrcList(scoreCode)),"^",3)="" d
				...
				...
				...i $p(icucriList(scoreSrcList(scoreCode)),"^",3)<50 d
					....s $p(icucriList(6419),"^",3)="PaO2"
					....w "before<50:"_scoreValueList,!
					....i $p(icucriList(scoreSrcList(scoreCode)),"^",3)="" d
						....//.s $p(icucriList(scoreSrcList(scoreCode)),"^",3)=21
					....
					....//s paO2Str=$p(scoreValueList,"^",paO2Pos)
					....w "after<50:"_scoreValueList,!
				...e  d
					....s $p(icucriList(6419),"^",3)="A-aDO2"
					....s paO2Str=$p(scoreValueList,"^",paO2Pos)
					....s $p(paO2Str,"|",3)=""
					....w "before:"_scoreValueList,!
					....s $p(paO2Str,"|",4)=$p($p(scoreValueList,"^",aaDO2Pos),"|",4)
					....s $p(scoreValueList,"^",paO2Pos)=paO2Str
					....w "after:"_scoreValueList,!
					....//s $p(icucriList(6393),"^",3)=$p(paO2Str,"|",4)
					....q
					....
					....s aaDO2Str=$p(scoreValueList,"^",aaDO2Pos)
					....w aaDO2Pos_" paO2Str="_aaDO2Str,!
					....s $p(aaDO2Str,"|",4)=$p($p(scoreValueList,"^",paO2Pos),"|",4)
					....w aaDO2Pos_" paO2Str="_aaDO2Str,!
					....s $p(scoreValueList,"^",aaDO2Pos)=aaDO2Str
					....s $p(icucriList(6394),"^",3)=$p(aaDO2Str,"|",4)
		.i $d(scoreList(scoreCode)) d	//分值项
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=$p(scoreValue,"|",4)
		.i (scoreCode="AMBP")!(scoreCode="SOFAHypotension") d
			..q:$g(scoreList(scoreCode))=""
			..w "From AMBP--------------------",$g(scoreList(scoreCode)),!
			..q:$p(icucriList(scoreList(scoreCode)),"^",3)'=""
			..f k=1:1:$l(scoreItemStr,"^") d
				...s tmpClcsId=$p(scoreItemStr,"^",k)
				...q:tmpClcsId=""
				...s tmpScoreValue=$p(scoreValueList,"^",k)
				...q:tmpScoreValue=""
				...s tmpScoreCode=$lg(^DHCCLC("Score",tmpClcsId),1)
				...q:tmpScoreCode'="NBP"
				...s ambpIcucriId=$p(tmpScoreValue,"|",2)
				...q:ambpIcucriId=""
				...q:$p(tmpScoreValue,"|",3)=""
				...s ambpScore=$p(tmpScoreValue,"|",4)
				...q:ambpScore=""
				...//w !,scoreCode_"\"_scoreList(scoreCode)_"\"_icucriList(scoreList(scoreCode))_"\"_scoreValue_"\"_tmpScoreValue,!
				...s srcIcucriId=scoreSrcList(scoreCode)
				...s $p(icucriList(srcIcucriId),"^",3)=$p(^DHCICUC("RecordItem",ambpIcucriId),"^",2)_":"_$p(tmpScoreValue,"|",3)
				...s $p(icucriList(scoreList(scoreCode)),"^",3)=ambpScore
		.//i scoreCode="AMBP" s ambpScore=$p(scoreValue,"|",4)
		.i scoreCode="SOFACreatinineAndUrine" d
			..w "SOFACreatinineAndUrine--------------------"
			..q:$p(icucriList(scoreList(scoreCode)),"^",3)'=""
			..f k=1:1:$l(scoreItemStr,"^") d
				...s tmpClcsId=$p(scoreItemStr,"^",k)
				...q:tmpClcsId=""
				...s tmpScoreValue=$p(scoreValueList,"^",k)
				...q:tmpScoreValue=""
				...s tmpScoreCode=$lg(^DHCCLC("Score",tmpClcsId),1)
				...q:tmpScoreCode'="SOFAUrine"
				...s ambpScore=$p(tmpScoreValue,"|",4)
				...w scoreValue_"\"_tmpScoreValue
				...s $p(icucriList(scoreList(scoreCode)),"^",3)=ambpScore
	s layer=""
	f  s layer=$o(mainScoreList(layer),-1) q:layer=""  d  //评分主项到从项的树形汇总
		.s mainClcsId=""
		.f  s mainClcsId=$o(mainScoreList(layer,mainClcsId)) q:mainClcsId=""  d
			..w "layer:"_layer_"\"_mainClcsId_":"_$lg(^DHCCLC("Score",mainClcsId),2),!
			..q:'$d(^DHCCLC("Score",mainClcsId))
			..s score=$lg(^DHCCLC("Score",mainClcsId),5)
			..s subClcsId="",ifhaveSubScore=1
			..f  s subClcsId=$o(mainScoreList(layer,mainClcsId,subClcsId)) q:subClcsId=""  d
				...w "    subId:"_subClcsId_":"_$lg(^DHCCLC("Score",subClcsId),2)_"\haveSub: "_ifhaveSubScore
				...i '$d(^DHCCLC("Score",subClcsId)) q
				...s scoreCode=$lg(^DHCCLC("Score",subClcsId),1)
				...;b ;"rrrrrr"
				...i scoreCode="" s ifhaveSubScore=0 w " No scoreItem",! q
				...i '$d(scoreList(scoreCode)) w " No Score Qty",! q
				...w " "_scoreList(scoreCode)_","_$g(icucriList(scoreList(scoreCode)))
				...i $p($g(icucriList(scoreList(scoreCode))),"^",3)="" s ifhaveSubScore=0  w " No Para item data ",! q
				...s score=score+($lg(^DHCCLC("Score",subClcsId),4)*$p($g(icucriList(scoreList(scoreCode))),"^",3))
				...w "  Yes:score="_score,!
			..w "  haveAllSubScore:"_ifhaveSubScore,!
			..q:'ifhaveSubScore
			..s scoreCode=$lg(^DHCCLC("Score",mainClcsId),1)
			..q:scoreCode=""
			..q:'$d(scoreList(scoreCode))
			..w "   "_scoreList(scoreCode)_"\"_icucriList(scoreList(scoreCode))_"\"_score,!
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=score
	//w "//////////"_$d(icucriList(icucriId)),!
	s icucriId=""
	f  s icucriId=$o(icucriList(icucriId)) q:icucriId=""  d
		.//w icucriId_"/"_icucriList(icucriId),!
		.q:$p(icucriList(icucriId),"^",3)=""
		.s $p(orderPara,$c(3),2)=icuaId
		.s $p(orderPara,$c(3),3)=icucriId
		.s $p(orderPara,$c(3),5)=userId
		.s $p(orderPara,$c(3),6,9)=endDate_$c(3)_endTime_$c(3)_endDate_$c(3)_endTime
		.s $p(orderPara,$c(3),11)=""
		.s $p(orderPara,$c(3),12)=""
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Note" s $p(orderPara,$c(3),11)=$p(icucriList(icucriId),"^",3)
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Qty" s $p(orderPara,$c(3),12)=$p(icucriList(icucriId),"^",3)
		.s $p(orderPara,$c(3),17)=$p(icucriList(icucriId),"^",2) //viewCat
		.s $p(orderPara,$c(3),18)="N"
		.s $p(orderPara,$c(3),22)=+$h
		.s $p(orderPara,$c(3),23)=$p($h,",",2)
		.s $p(orderPara,$c(3),26)="N"
		.s $p(orderPara,$c(3),39)=icupId_"||"_$p(icucriList(icucriId),"^",1)
		.i orderParaList'="" s orderParaList=orderParaList_"^"
		.s orderParaList=orderParaList_orderPara
		.//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_icucriList(icucriId),"\"_
		.w $p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_":"_orderPara,!
		.s $p(icucriList(icucriId),"^",3)="" //赋值后清空
	w "debug="_ifDebug,!
	i 'ifDebug d
	    .w "save"
	    .s ^tmpdebug("SaveICUOrder")=orderParaList
	    .s beforeApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"ifDebug","Before")="Apache:"_beforeApacheII
		.
		.s retStr=##class(web.DHCICUOrder).SaveICUOrder(orderParaList)
		.//i (needClcsCode="APACHEII")&(inDate=startDate) d 
		.i (needClcsCode="APACHEII")&(inDate=startDate)&(endTime=(inTime\3600*3600)) d //考虑当天入出的，大于一天的判断两次
			..//s $p(^DHCICUArrange(icuaId),"^",40)=score
			..s adjRet=..AdjustICUADeathProbability(icuaId)
		.//w retStr,!
		.s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"ifDebug","After")="Apache:"_afterApacheII
		.
		.s ^DHCANICUDEBUG("ComfirmCollectData",endDate,endTime)=orderParaList
		.k orderParaList
		.
	//w
	q retStr
}

// d ##class(%ResultSet).RunQuery("web.DHCCLScore","FindICUArrangeScore","2013-11-01","2013-11-05","","","","","")

Query FindICUArrangeScore(fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "", atward As %String = "") As %Query(ROWSPEC = "WardInDateTime:%String,WardOutDateTime:%String,RegNo:%String,PatName:%String,IcuWardDesc:%String,Status:%String,BedCode:%String,DiagDesc:%String,CurWardDesc:%String,icuaId:%String,EpisodeID:%String,MediCareNo:%String,WardInOutNote:%String,InApacheScore:%String,InSofaScore:%String,OutApacheScore:%String,OutSofaScore:%String,ResidentCtcp:%String,AttendingCtcp:%String,Temper:%String,HR:%String,RR:%String,PaO2:%String,AaDO2ifFiO250:%String,ApachePH:%String,SerumNa:%String,Serumk:%String,CreatinineARF2:%String,Hematocrit:%String,WBCcount:%String,age:%String,CHP:%String,GCS:%String,EyeOpening:%String,VerbalResponse:%String,MotorResponse:%String,FiO2:%String,NBP:%String,ARFValue:%String,bedusedays:%String,death:%String,In24hours:%String") [ SqlProc ]
{
}

ClassMethod FindICUArrangeScoreExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "True", atward As %String = "False") As %Status
{
	s TemperID="6370",HRID="6372",RRID="6386",PaO2ID="6373",AaDO2ifFiO250ID="6374",ApachePHID="6375",SerumNaID="6377",SerumkID="6378",CreatinineARF2ID="6379",HematocritID="6380",WBCcountID="6381",CHPID="6384",GCSID="6382",FiO2ID="5578",NBPID="6597"
	s TemperScoreID="6389",HRScoreID="6391",RRScoreID="6392",PaO2ScoreID="6393",AaDO2ifFiO250ScoreID="6394",ApachePHScoreID="6395",SerumNaScoreID="6397",SerumkScoreID="6398",CreatinineARF2ScoreID="6400",HematocritScoreID="6401",WBCcountScoreID="6402",CHPScoreID="6412",GCSScoreID="",FiO2ScoreID="6419",NBPScoreID="6390"
	s Temper="",HR="",RR="",PaO2="",AaDO2ifFiO250="",ApachePH="",SerumNa="",Serumk="",CreatinineARF2="",Hematocrit="",WBCcount="",age="",CHP="",GCS="",FiO2="",NBP=""
	s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
	s outTemperScore="",outHRScore="",outRRScore="",outPaO2Score="",outAaDO2ifFiO250Score="",outApachePHScore="",outSerumNaScore="",outSerumkScore="",outCreatinineARF2Score="",outHematocritScore="",outWBCcountScore="",outCHPScore="",outGCSScore="",outFiO2Score="",outNBPScore=""
	s inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
	s outTemperValue="",outHRValue="",outRRValue="",outPaO2Value="",outAaDO2ifFiO250Value="",outApachePHValue="",outSerumNaValue="",outSerumkValue="",outCreatinineARF2Value="",outHematocritValue="",outWBCcountValue="",outCHPValue="",outGCSValue="",outFiO2Value="",outNBPValue=""
	s ageScore="",ageScoreID="6410",ageID="6383"
	s apcheID="6385",SofaID="5453"	
	s EyeOpeningValueID="6403",  VerbalResponseValueID="6405", MotorResponseValueID="6407", EyeOpeningScoreID="6404",  VerbalResponseScoreID="6406", MotorResponseScoreID="6408"
	s inEyeOpening="",  inVerbalResponse="", inMotorResponse="", outEyeOpening="",  outVerbalResponse="", outMotorResponse=""
	s EyeOpening="",  VerbalResponse="", MotorResponse=""
	s inEyeOpeningValue="",  inVerbalResponseValue="", inMotorResponseValue="", inEyeOpeningScore="",  inVerbalResponseScore="", inMotorResponseScore=""
	s outEyeOpeningValue="",  outVerbalResponseValue="", outMotorResponseValue="", outEyeOpeningScore="",  outVerbalResponseScore="", outMotorResponseScore=""
	s inApacheScore="",inSofaScore="",outApacheScore="",outSofaScore="",startTime="",startDate="",startDateTime=""
  	s ARFID="6399",inARFValue="",outARFValue="",ARFValue=""
  	s death="",In24hours=""
  	s IsValid="N"
  	Set repid=$I(^CacheTemp)
  	s needGroupId=315
  	s atward=atward
  	s ^TEMPLLL("atward")=atward
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s EpisodeIDList=""
 	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr")=EpisodeIDList
	s ifSingle="N"
	i needRegNo="",papmiMedicare="",papmiName="" s ifSingle="Y",tBodySquare=""

	;s ctlocId=39
	
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
	s icuaBedList="",icuward="",linkLocIdStrTemp=""
	s linkLocIdStrTemp=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

    i linkLocIdStrTemp["39" s ctlocId=39 
	i linkLocIdStrTemp["88" s ctlocId=88 
	s linkLocIdStr=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

	s wardIdStr=""
	f i=1:1:$l(linkLocIdStr,"^") d
		.s curLocId=$p(linkLocIdStr,"^",i)
		.q:curLocId=""
		.s curWardId=$o(^PAWARD(0,"WARD_LocationDR",curLocId,0))
		.q:curWardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_curWardId
	//$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId
	k icuaIdList
	//时间段进病区
	s icuidtest="2994"
	i ifSingle="Y", needRegNo="" d
		.s icuaBedList=""
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..i icuaId=icuidtest  b ;"in"
			..f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
    //时间段在病区	
   	;b ;"at"	
    i (atward="True"), needRegNo="" d
		.s icuaBedList=""
		.;b ;"atrrue"
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..i icuaId=icuidtest  b ;"at"
			..f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
	//w EpisodeIDList
	;s ^TEMPWH("icuaIdList")=icuaIdList
	i needRegNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(needRegNo,"")
	s icuaId=""
	f  s icuaId=$o(icuaIdList(icuaId)) q:icuaId=""  d
		.//w icuaId,!		
	    .s IsValid=##class(web.DHCICUCom).CheckValidICUAID(icuaId)
	    .q:IsValid="N"
		.s curIcuaStatusCode=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.q:curIcuaStatusCode=""	;20120625
		.s leavePat=1
		.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
		.q:EpisodeID=""
		.s patHeight=$p(^DHCICUArrange(icuaId),"^",24)
		.s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
		.s tBodySquare=0 //..Sqr((patHeight*patWeight)/3600)
		.;q:(icuaStatusCode'="")&(curIcuaStatusCode'=icuaStatusCode)
		.s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
		.s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
		.s startDateTime=startDate+(startTime/100000)
		.s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
		.s inWardDateTimeStr=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
		.s inWardDate=startDate,inWardTime=startTime
		.i inWardDateTimeStr'=" " d
			..s inWardDate=$p(inWardDateTimeStr,"^"),inWardTime=$p(inWardDateTimeStr,"^",2)
		.s inWardDateTime=inWardDate+(inWardTime/100000)
		.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
		.s curDateTime=$h+($p($h,",",2)/100000)
		.s curDate=($p($h,",",1))
		.s wardInOutNote=""
		.i outDateTime="" d
			..s duration=curDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天(在院)"
			..e  s wardInOutNote="<1天(在院)"
		.e  d
			..s outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			..s outDateTime=outDate+(outTime/100000)
			..s leavePat=0
			..s duration=outDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天"
			..e  s wardInOutNote="<1天"
		.i outDateTime="" s outDate=+$h,outTime=$p($h,",",2)
		.e  d
			..s outDate=$p(outDateTime,".",1)
			..s outTime=(outDateTime-outDate)*100000
			..//s outDate=$zd(outDate,3)
		.		
		.
		.s fromD=##class(web.DHCClinicCom).ConvertToDateH($p(fromDate," "))
		.s fromT=##class(web.DHCClinicCom).ConvertToTimeH($p(fromDate," ",2))
		.s fromDT=fromD+(fromT/100000)    
        .s toD=##class(web.DHCClinicCom).ConvertToDateH($p(toDate," "))
		.s toT=##class(web.DHCClinicCom).ConvertToTimeH($p(toDate," ",2))
	    .s toDT=toD+(toT/100000)  
	    .;b ;"toDT"     
	    .
		.i outDateTime="" d
            ..i (fromDT<inWardDateTime)&(curDateTime<toDT)  d
              ...i icuaId=icuidtest  b ;"1"
			  ...s duration=curDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT<inWardDateTime)&(curDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"2"
		      ...s duration=toDT-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(curDateTime>toDT)  d
			   ...i icuaId=icuidtest  b ;"3"
		       ...s duration=toD-fromD
			   ...i duration>1 s bedusedays=$p(duration,".")
			   ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(curDateTime<toDT)  d
			   ...i icuaId=icuidtest  b ;"3"
		       ...s duration=curDate-fromD
			   ...i duration>1 s bedusedays=$p(duration,".")
			   ...e  s bedusedays="0"
		.e  d
            ..i (fromDT<inWardDateTime)&(outDateTime<toDT)  d
              ...i icuaId=icuidtest  b ;"4"
			  ...s duration=outDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT<inWardDateTime)&(outDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"5"
		      ...s duration=toD-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(outDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"6"
		      ...s duration=toD-fromD
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(outDateTime<toDT)  d
			  ...i icuaId=icuidtest  b ;"7"
		      ...s duration=outDate-fromDT+2
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"  
		.	  
		.	  
		.	  
		.i icuaId=icuidtest  b ;"8"		
		.	
		.s birth=$p($g(^PAPER(EpisodeID,"ALL")),"^",6)
		.s age=##class(web.DHCClinicCom).CalAge(birth,$h)
		.s inApacheScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,apcheID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max") //GetOrderValueByIdAndDate(apcheID,icuaId,inWardDate,inWardDate+1)
		.s outApacheScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,apcheID,outDate-1,outTime,outDate,outTime,"Max") //GetOrderValueByIdAndDate(apcheID,icuaId,outDate-1,outDate+1)
		.s inSofaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SofaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s outSofaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SofaID,outDate-1,outTime,outDate,outTime,"Max")
        .
		.s AttendingCtcp=""
		.s inTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.
        .s ageScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ageScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inTemperScore'="" s inTemperScore=inTemperScore_"分"
		.s inHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHRScore'="" s inHRScore=inHRScore_"分"
		.s inRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inRRScore'="" s inRRScore=inRRScore_"分"
		.s inPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inPaO2Score'="" s inPaO2Score=inPaO2Score_"分"
		.s inAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inAaDO2ifFiO250Score'="" s inAaDO2ifFiO250Score=inAaDO2ifFiO250Score_"分"
		.s inApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inApachePHScore'="" s inApachePHScore=inApachePHScore_"分"
		.s inSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumNaScore'="" s inSerumNaScore=inSerumNaScore_"分"
		.s inSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumkScore'="" s inSerumkScore=inSerumkScore_"分"
		.s inCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCreatinineARF2Score'="" s inCreatinineARF2Score=inCreatinineARF2Score_"分"
		.s inHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHematocritScore'="" s inHematocritScore=inHematocritScore_"分"
		.s inWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inWBCcountScore'="" s inWBCcountScore=inWBCcountScore_"分"
		.s inCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCHPScore'="" s inCHPScore=inCHPScore_"分"
		.s inGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inGCSScore'="" s inGCSScore=inGCSScore_"分"
		.s inFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inFiO2Score'="" s inFiO2Score=inFiO2Score_"分"
		.s inNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inNBPScore'="" s inNBPScore=inNBPScore_"分"
		.
		.s inEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inEyeOpeningScore'="" s inEyeOpeningScore=inEyeOpeningScore_"分"
		.s inVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inVerbalResponseScore'="" s inVerbalResponseScore=inVerbalResponseScore_"分"
		.s inMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inMotorResponseScore'="" s inMotorResponseScore=inMotorResponseScore_"分"
		.
		.
		.s outTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.
		.
		.s outTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outTemperScore'="" s outTemperScore=outTemperScore_"分"
		.s outHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHRScore'="" s outHRScore=outHRScore_"分"
		.s outRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outRRScore'="" s outRRScore=outRRScore_"分"
		.s outPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outPaO2Score'="" s outPaO2Score=outPaO2Score_"分"
		.s outAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outAaDO2ifFiO250Score'="" s outAaDO2ifFiO250Score=outAaDO2ifFiO250Score_"分"
		.s outApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outApachePHScore'="" s outApachePHScore=outApachePHScore_"分"
		.s outSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumNaScore'="" s outSerumNaScore=outSerumNaScore_"分"
		.s outSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumkScore'="" s outSerumkScore=outSerumkScore_"分"
		.s outCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCreatinineARF2Score'="" s outCreatinineARF2Score=outCreatinineARF2Score_"分"
		.s outHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHematocritScore'="" s outHematocritScore=outHematocritScore_"分"
		.s outWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outWBCcountScore'="" s outWBCcountScore=outWBCcountScore_"分"
		.s outCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCHPScore'="" s outCHPScore=outCHPScore_"分"
		.s outGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outGCSScore'="" s outGCSScore=outGCSScore_"分"
		.s outFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outFiO2Score'="" s outFiO2Score=outFiO2Score_"分"
		.s outNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outNBPScore'="" s outNBPScore=outNBPScore_"分"
	    .
	    .s outEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outEyeOpeningScore'="" s outEyeOpeningScore=outEyeOpeningScore_"分"
		.s outVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outVerbalResponseScore'="" s outVerbalResponseScore=outVerbalResponseScore_"分"
		.s outMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outMotorResponseScore'="" s outMotorResponseScore=outMotorResponseScore_"分"
		.
        .;i icuaId=2043 w inTemperValue ! outTemperValue b ;"5"
		.;i outDate-inWardDate<2 s inApacheScore="-",inSofaScore="-",inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
        .;i outDate-inWardDate<2 s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
        .s ^TEMPWHL(EpisodeID)=EpisodeID_"^"_ctlocId
        .s ret=##class(web.DHCCLCScore).FindResidentAndAttendingCtcp(EpisodeID,ctlocId)
		.s ResidentCtcp=##class(web.DHCCLScore).GetUserName($p($g(^DHCICUArrange(+icuaId)),"^",28)) ;$p(ret,"^",1)
		.s AttendingCtcp=##class(web.DHCCLScore).GetUserName($p($g(^DHCICUArrange(+icuaId)),"^",29)) ;$p(ret,"^",2)
		.i ResidentCtcp="" s ResidentCtcp=$p(ret,"^",1)
		.i AttendingCtcp="" s AttendingCtcp=$p(ret,"^",2)
		.s FGF="_"
		.s Temper=inTemperValue ;_FGF_inTemperScore_"@"_outTemperValue_FGF_outTemperScore
		.s HR=inHRValue ;_FGF_inHRScore_"@"_outHRValue_FGF_outHRScore
		.s RR=inRRValue ;_FGF_inRRScore_"@"_outRRValue_FGF_outRRScore
		.s PaO2=inPaO2Value ;_FGF_inPaO2Score_"@"_outPaO2Value_FGF_outPaO2Score
		.s AaDO2ifFiO250=inAaDO2ifFiO250Value ;_FGF_inAaDO2ifFiO250Score_"@"_outAaDO2ifFiO250Value_FGF_outAaDO2ifFiO250Score
		.s ApachePH=inApachePHValue ;_FGF_inApachePHScore_"@"_outApachePHValue_FGF_outApachePHScore
		.s SerumNa=inSerumNaValue ;_FGF_inSerumNaScore_"@"_outSerumNaValue_FGF_outSerumNaScore
		.s Serumk=inSerumkValue ;_FGF_inSerumkScore_"@"_outSerumkValue_FGF_outSerumkScore
		.s CreatinineARF2=inCreatinineARF2Value ;_FGF_inCreatinineARF2Score_"@"_outCreatinineARF2Value_FGF_outCreatinineARF2Score
		.s Hematocrit=inHematocritValue ;_FGF_inHematocritScore_"@"_outHematocritValue_FGF_outHematocritScore
		.s WBCcount=inWBCcountValue ;_FGF_inWBCcountScore_"@"_outWBCcountValue_FGF_outWBCcountScore
		.s age=age ;_FGF_ageScore_"分"
		.s CHP=inCHPValue ;_FGF_inCHPScore_"@"_outCHPValue_FGF_outCHPScore
		.s GCS=inGCSValue ;_"分"_"@"_outGCSValue_"分"
		.s FiO2=inFiO2Value ;_FGF_inFiO2Score_"@"_outFiO2Value_FGF_outFiO2Score
		.s NBP=inNBPValue ;_FGF_inNBPScore_"@"_outNBPValue_FGF_outNBPScore
		.
        .s EyeOpening=inEyeOpeningValue ;_FGF_inEyeOpeningScore_"@"_outEyeOpeningValue_FGF_outEyeOpeningScore
        .s VerbalResponse=inVerbalResponseValue ;_FGF_inVerbalResponseScore_"@"_outVerbalResponseValue_FGF_outVerbalResponseScore
        .s MotorResponse=inMotorResponseValue ;_FGF_inMotorResponseScore_"@"_outMotorResponseValue_FGF_outMotorResponseScore
		.s ARFValue=inARFValue
		.s icuaEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/7:after end date?"
		.s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
		.s icuWardDesc=$P($g(^PAWARD(+icuBedId)),"^",2)
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s curWardDesc=$P($g(^PAWARD(+curWardId)),"^",2)
		.s icuBedSub=$p(icuBedId,"||",2)
		.s bedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
		.i bedCode="" s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
		.s papmiId=$p($g(^PAADM($p(^DHCICUArrange(icuaId),"^",1))),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;病案号
		.s deathoutDate=$p(^PAPER(papmiId,"ALL"),"^",13) //死亡日期
		.s deathoutTime=$p(^PAPER(papmiId,"ALL"),"^",8) //死亡时间
        .i (deathoutDate'="")&(deathoutTime'="") s death="是"
        .e  s death="否"
        .s In24hours=..GetFYQ(icuaId,fromDate,24)
        .;b ;"11111111"
 		.s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
		.s wardInDateTime=""
		.i startDate'="" d
			..s wardInDateTime=$zd(inWardDate,3)
			..s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
			..s wardInDateTime=wardInDateTime_" "_$zt(inWardTime,2)
		.s wardOutDateTime=""
		.i icuaEndDate'="" d
			..//s wardOutDateTime=$zd(icuaEndDate,3)
			..//s endTime=+$p($g(^DHCICUArrange(+icuaId)),"^",9)
			..//s wardOutDateTime=wardOutDateTime_" "_$zt(endTime)
		.;病人姓名
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s status=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.;病人诊断
		.s diagDesc=""
		.s tDiagdr=$p($g(^DHCICUArrange(+icuaId)),"^",20)
		.s num=$l(tDiagdr,"|")
		.f k=1:1:num  d
			..s Diagdr=$p(tDiagdr,"|",k)
			..q:Diagdr=""
			..i diagDesc="" s diagDesc=$p(^MRC("ID",Diagdr),"^",2)
			..e  s diagDesc=diagDesc_";"_$p(^MRC("ID",Diagdr),"^",2)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/10:OK!"
		.s tICUANormalStartDate=##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUArrange(icuaId),"^",22),"")
		.s tICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUArrange(icuaId),"^",23),"")
		.i outDateTime'="" s wardOutDateTime=$zd(outDate,3)_" "_$zt(outTime,2)
		.i $p(icuWardDesc,"-",2)'="" s icuWardDesc=$p(icuWardDesc,"-",2)
		.i $p(curWardDesc,"-",2)'="" s curWardDesc=$p(curWardDesc,"-",2)
		.;ADD mfc 20140207导出病人评分汇总项
		.;s ^tempICUScore(+icuBedId,icuaId)=patName_"^"_regNo_"^"_icuWardDesc_"^"_bedCode_"^"_wardInOutNote_"^"_wardInDateTime_"^"_inApacheScore_"^"_wardOutDateTime_"^"_outApacheScore_"^"_curWardDesc_"^"_icuaId
		.s tmpList((+icuBedId)_leavePat_bedCode,EpisodeID_"."_+icuaId)=$lb(wardInDateTime,wardOutDateTime,regNo,patName,icuWardDesc,status,bedCode,diagDesc,curWardDesc,icuaId,EpisodeID,medicareNo,wardInOutNote,inApacheScore,inSofaScore,outApacheScore,outSofaScore,ResidentCtcp,AttendingCtcp,Temper,HR,RR,PaO2,AaDO2ifFiO250,ApachePH,SerumNa,Serumk,CreatinineARF2,Hematocrit,WBCcount,age,CHP,GCS,EyeOpening,VerbalResponse,MotorResponse,FiO2,NBP,ARFValue,bedusedays,death,In24hours)
	    .;b ;"56"
	s bedCode=0,curWardId=""
	;f  s curWardId=$o(tmpList(curWardId)) q:curWardId=""  d
	f  s bedCode=$o(tmpList(bedCode)) q:bedCode=""  d 
		.s icuaId=0
		.f  s icuaId=$o(tmpList(bedCode,icuaId)) q:icuaId=""  d
			..d OutputRoww
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoww
	set Data=tmpList(bedCode,icuaId) //$lb(wardInDateTime,wardOutDateTime,regNo,patName,admLocDesc,status,bedCode,diagDesc,wardDesc,icuaId,EpisodeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUArrangeScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUArrangeScoreExecute ]
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

ClassMethod FindICUArrangeScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUArrangeScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetScoreDetail(SCORERowId As %String, ScoreType As %String)
{
	i SCORERowId="" q ""
	i ScoreType="" q -2
	s Str=""
	i ScoreType="CRAMS" d
	.s CRAMSChildSub=$o(^DHCCLScore(SCORERowId,"CRAMS","0"))
	.q:CRAMSChildSub=""
	.s CRAMSScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",1)
	.s CirculScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",3)
	.s RespScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",5)
	.s AbdomenScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",7)
	.s MotorScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",9)
	.s SpeechScore=$p(^DHCCLScore(SCORERowId,"CRAMS",CRAMSChildSub),"^",11)
	.s Str=CRAMSScore_"^"_CirculScore_"^"_RespScore_"^"_AbdomenScore_"^"_MotorScore_"^"_SpeechScore
 	i ScoreType="GLASG" d
	.s GLASGChildSub=$o(^DHCCLScore(SCORERowId,"Glasgow","0")) 
	.q:GLASGChildSub=""
	.s GLASGScore=$p(^DHCCLScore(SCORERowId,"Glasgow",GLASGChildSub),"^",1)
	.s EyeScore=$p(^DHCCLScore(SCORERowId,"Glasgow",GLASGChildSub),"^",3)
	.s VerbalScore=$p(^DHCCLScore(SCORERowId,"Glasgow",GLASGChildSub),"^",5)
	.s MotorScore=$p(^DHCCLScore(SCORERowId,"Glasgow",GLASGChildSub),"^",7)
	.s Str=GLASGScore_"^"_EyeScore_"^"_VerbalScore_"^"_MotorScore
	i ScoreType="RTS" d
	.s RTSChildSub=$o(^DHCCLScore(SCORERowId,"RTS","0")) 
	.q:RTSChildSub=""
	.s RTSScore=$p(^DHCCLScore(SCORERowId,"RTS",RTSChildSub),"^",1)
	.s GlasgowScore=$p(^DHCCLScore(SCORERowId,"RTS",RTSChildSub),"^",3)
	.s SystolicBPScore=$p(^DHCCLScore(SCORERowId,"RTS",RTSChildSub),"^",5)
	.s RespRateScore=$p(^DHCCLScore(SCORERowId,"RTS",RTSChildSub),"^",7)
	.s Str=RTSScore_"^"_GlasgowScore_"^"_SystolicBPScore_"^"_RespRateScore
	i ScoreType="GUSTL" d
	.s GUSTLChildSub=$o(^DHCCLScore(SCORERowId,"Gustilo","0")) 
	.q:GUSTLChildSub=""
	.s GUSTLScore=$p(^DHCCLScore(SCORERowId,"Gustilo",GUSTLChildSub),"^",1)
	.s GUSTLInfectionRate=$p(^DHCCLScore(SCORERowId,"Gustilo",GUSTLChildSub),"^",2)
	.s AmputationRate=$p(^DHCCLScore(SCORERowId,"Gustilo",GUSTLChildSub),"^",3)
	.s Str=GUSTLScore_"^"_GUSTLInfectionRate_"^"_AmputationRate
	i ScoreType="ISS" d
	.s ISSChildSub=$o(^DHCCLScore(SCORERowId,"ISS","0")) 
	.q:ISSChildSub=""
	.s ISSScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",1)
	.s HeadNeckScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",2)
	.s FaceScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",3)
	.s ChestScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",4)
	.s AbdomenScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",5)
	.s ExtremityScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",6)
	.s ExternalScore=$p(^DHCCLScore(SCORERowId,"ISS",ISSChildSub),"^",7)
	.s Str=ISSScore_"^"_HeadNeckScore_"^"_FaceScore_"^"_ChestScore_"^"_AbdomenScore_"^"_ExtremityScore_"^"_ExternalScore
	i ScoreType="SOFA" d
	.s SOFAChildSub=$o(^DHCCLScore(SCORERowId,"SOFA","0"))
	.q:SOFAChildSub=""
	.s SOFAScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",1)
	.s RespScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",3)
	.s CoagulationScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",5)
	.s LiverScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",7)
	.s CardiovascularScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",9)
	.s CentralNervousScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",11)
	.s RenalScore=$p(^DHCCLScore(SCORERowId,"SOFA",SOFAChildSub),"^",13)
	.s Str=SOFAScore_"^"_RespScore_"^"_CoagulationScore_"^"_LiverScore_"^"_CardiovascularScore_"^"_CentralNervousScore_"^"_RenalScore
	i ScoreType="MEDS" d
	.s MEDSChildSub=$o(^DHCCLScore(SCORERowId,"MEDS","0")) 
	.q:MEDSChildSub=""
	.s MEDSScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",1)
	.s AgeScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",3)
	.s NurHomeResidentScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",5)
	.s TerminalIllnessScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",7)
	.s LowerRespInfectScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",9)
	.s BandProportionScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",11)
	.s TachypneaHypoxiaScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",13)
	.s SepticShockScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",15)
	.s PlateletCountScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",17)
	.s AltMentalStatusScore=$p(^DHCCLScore(SCORERowId,"MEDS",MEDSChildSub),"^",19)
	.s Str=MEDSScore_"^"_AgeScore_"^"_NurHomeResidentScore_"^"_TerminalIllnessScore_"^"_LowerRespInfectScore_"^"_BandProportionScore_"^"_TachypneaHypoxiaScore_"^"_SepticShockScore_"^"_PlateletCountScore_"^"_AltMentalStatusScore
 	i ScoreType="APACHE" d
	.s APACHEChildSub=$o(^DHCCLScore(SCORERowId,"APACHE","0")) 
	.q:APACHEChildSub=""
	.s APACHEScore=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",1)
	.s TempVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",2)
	.s DiaArtPressVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",4)
	.s SysArtPressVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",5)
	.s MeanArtPresVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",6)
	.s HeartRateVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",8)
	.s RespRateVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",10)
	.s FiO2Val=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",12)
	.s PaO2Val=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",13)
	.s PaCO2Val=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",14)
	.s AtmosPressureVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",15)
	.s H2OPressureVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",16)
	.s OxygenIndexVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",17)
	.s ArterialPHVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",19)
	.s SodiumVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",21)
	.s PotassiumVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",23)
	.s AcuteRenalFailur=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",25)
	.s CreatinineVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",26)
	.s HematocritVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",28)
	.s WhiteBloodCellVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",30)
	.s SerumHCO3Val=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",32)
	.s GlasgowVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",34)
	.s AgeVal=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",36)
	.s ChronOrganFailScore=$p(^DHCCLScore(SCORERowId,"APACHE",APACHEChildSub),"^",39)
	.s Str=APACHEScore_"^"_TempVal_"^"_DiaArtPressVal_"^"_SysArtPressVal_"^"_MeanArtPresVal_"^"_HeartRateVal_"^"_RespRateVal_"^"_FiO2Val_"^"_PaO2Val_"^"_PaCO2Val_"^"_AtmosPressureVal_"^"_H2OPressureVal_"^"_OxygenIndexVal_"^"_ArterialPHVal_"^"_SodiumVal_"^"_PotassiumVal_"^"_AcuteRenalFailur_"^"_CreatinineVal_"^"_HematocritVal_"^"_WhiteBloodCellVal_"^"_SerumHCO3Val_"^"_GlasgowVal_"^"_AgeVal_"^"_ChronOrganFailScore
 	i ScoreType="CPugh" d
	.s ChildPughChildSub=$o(^DHCCLScore(SCORERowId,"ChildPugh","0")) 
	.q:ChildPughChildSub=""
	.s ChildPughScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",1)
	.s HepatEncephalScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",3)
	.s AscitesScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",5)
	.s TotalBilirubinScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",7)
	.s SerumAlbuminScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",9)
	.s ProthrombinTimeScore=$p(^DHCCLScore(SCORERowId,"ChildPugh",ChildPughChildSub),"^",11)
	.s Str=ChildPughScore_"^"_HepatEncephalScore_"^"_AscitesScore_"^"_TotalBilirubinScore_"^"_SerumAlbuminScore_"^"_ProthrombinTimeScore
 	q Str
}

/// 获取住院（管床）医生_"^"_主治医生
ClassMethod FindResidentAndAttendingCtcp(paadm As %String, locid As %String) As %String
{
    s ResidentCtcp="",AttendingCtcp="",rowid="",ResidentCtcpName="",AttendingCtcpName="",LocID=""
    s ResidentCtcpDr="",ResidentCtcpDr="",ctcpLocID=""
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(paadm,"TRANS",rowid),"^",6)
	.q:LocID'=locid
	.;b ;"2"
	.s TRANSMain=$p(^PAADM(paadm,"TRANS",rowid),"^",13)
	.;q:TRANSMain'="Yes"
	.s ResidentCtcpDr=$p(^PAADM(paadm,"TRANS",rowid),"^",5) //住院医生
	.q:ResidentCtcpDr=""
	.s ctcpLocID=$p($g(^SSU("SSUSR",ResidentCtcpDr)),"^",4)
	.;b ;"3"
	.;$P($g(^CTPCP(Doctor,1)),"^",2)
	.s AttendingCtcpName=##class(web.DHCDocInPatientList).GetHadeUniteDoc(ResidentCtcpDr,LocID)
	.s ResidentCtcpName=$P($g(^CTPCP(ResidentCtcpDr,1)),"^",2) ;$p($g(^SSU("SSUSR",+ResidentCtcpDr)),"^",2) ;$TR($P(^CTPCP(+ResidentCtcpDr,1),"^",2)," ","")
	.;s AttendingCtcpName=$P($g(^CTPCP(AttendingCtcpDr,1)),"^",2) ;$TR($P(^CTPCP(+AttendingCtcpDr,1),"^",2)," ","")
	;b ;"5"
	q ResidentCtcpName_"^"_AttendingCtcpName
}

// 获取医疗组组长

ClassMethod MedUnitPerson(locid As %String, CtPCP As %String) As %String
{
	s ind=1   
    s CTLocDr=locid
    s MUCPDoctorDR=""
    s CTMUChildsub=""
    s MUCPChildsub=""
    f  s CTMUChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub))    q:CTMUChildsub=""   d
    .f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    q:MUCPChildsub=""   d
    ..s MUCPDateFrom="",MUCPDateTo=""
    ..s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",1)
    ..q:MUCPDoctorDR="" 
    ..q:MUCPDoctorDR'=CtPCP
    ..s TMPMUCPRowid=CTLocDr_"||"_ CTMUChildsub_"||"_MUCPChildsub
    ..s CTPCPCode=$p(^CTPCP(MUCPDoctorDR,1),"^",1)
	..s CTPCPDescNew=$p(^CTPCP(MUCPDoctorDR,1),"^",2)
	..s TMUCPLeader=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",2)
    ..;s:TMUCPLeader="Y" MUCPLeaderFlag="是"
    ..;s:TMUCPLeader="N" MUCPLeaderFlag="否"
    ..q:TMUCPLeader'="Y"
    ..;s TMUCPOP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",3)
	..;s:TMUCPOP="Y" MUCPOPFlag="出诊"
    ..;s:TMUCPOP="N" MUCPOPFlag="不出诊"
    ..;s TMUCPIP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",4)
	..;s:TMUCPIP="N" MUCPIPFlag="不出诊"
	..;s:TMUCPIP="Y" MUCPIPFlag="出诊"
    q MUCPDoctorDR
    ;q $p($g(^SSU("SSUSR",++MUCPDoctorDR)),"^",2)
}

ClassMethod ClearDHCICUUnderlyingDisease(icuaId As %String) As %String
{
	TSTART
	&SQL(delete from DHC_ICU_UnderlyingDisease where ICUCUD_ICUA_Dr=:icuaId )
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

// 获取用户姓名SS_User

ClassMethod GetUserName(argUserID As %String) As %String
{
	s ssuser=""
	Set ssuser=##class(User.SSUser).%OpenId(argUserID)
	q:(ssuser="") ""
	q ssuser.SSUSRName
}

/// 再入ICU
ClassMethod GetFYQ(icuaId As %String, fromDate As %String, interValHour As %String) As %String
{
    s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
    s icuaId2="",retstr="否",EpisodeID="",wardIdStr="",WardoutDate="",WardoutTime=""
    s EpisodeID=+^DHCICUArrange(+icuaId)
    ;b ;"9"
    f  s icuaId2=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId2)) q:icuaId2=""  d
    .;b ;"10"
    .q:icuaId>=icuaId2
    .;b ;"3"
    .q:'$d(^DHCICUArrange(icuaId2)) 
    .s icuHour2=""
    .s inDateTime2=##class(web.DHCICUCom).GetWardInDateTime("",icuaId2,"","","^","D")
    .s outDateTime2=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId2,"","","^","D")
    .s WardinDate2=$p(inDateTime2,"^",1),WardinTime2=	$p(inDateTime2,"^",2)
	.s WardoutDate2=$p(outDateTime2,"^",1),WardoutTime2=	$p(outDateTime2,"^",2)
	.q:(fromDate>WardinDate2)
	.;b ;"4"
	.s icuBedId2=$p($g(^DHCICUArrange(icuaId2)),"^",4)
	.q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId2)_"^"))	
	.&SQL(select ICUO_RowId into :tableFlag2 from DHC_ICU_Order where ICUO_ICUA_Dr=:icuaId2)
	 .;b ;"5"
	.q:(tableFlag2="")
    .i WardoutDate<WardinDate2 s icuHour2=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24) 
     .;b ;"6"
    .;i inDateTime>=inDateTime2 s icuHour2=(WardoutTime-WardinTime2)\3600+((WardoutDate-WardinDate2)*24) 
    .i icuHour2<=interValHour  s retstr="是" 
    
    ;b ;"2"
    q retstr
}

// 入参选项id  返回值 值^f分数

ClassMethod GetValueAndScore(clcsoId As %String) As %String
{
	s value="",score="",recordeitemID="",clcid=""
	s clcsId=$p(clcsoId,"||",1)
	q:clcsoId="" "^"
	s value=$lg(^DHCCLC("Score",$p(clcsoId,"||",1),"O",$p(clcsoId,"||",2)),2)
	s score=$lg(^DHCCLC("Score",$p(clcsoId,"||",1),"O",$p(clcsoId,"||",2)),5)
	s recordeitemCode=$lg(^DHCCLC("Score",clcsId),9)
	s recordeitemId=##class(web.DHCICUCom).GetIcuriIdByCode(recordeitemCode)
	q value_"^"_score_"^"_recordeitemId_"^"_clcsId
}

// 多天刷评分

/// w ##class(web.DHCCLScore).AutoAddScoreOrderBatch("2015-05-06","15")
/// w ##class(web.DHCCLScore).AutoAddScoreOrderBatch("2015/08/27","14:00:00","2015/08/27","14:00:00",7333,"56","APACHEII","APACHEII","",1,1)
ClassMethod AutoAddScoreOrderBatch(startDate, startTime, endDate, endTime, needIcuaId = "", needWardLocId = "", needClcsId = "", ancvcId = "", userId = "", ifDebug = 0, totalDay = 0) As %String
{
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i needWardLocId="" d
	.s needWardLocId=##Class(web.DHCICUCom).GetWardCtlocId("",needIcuaId)
 	f iDay=0:1:totalDay  d
 		.//i startTime=72000 b ;11
 		.s ret=##class(web.DHCCLScore).AutoAddScoreOrder(startDate+iDay,startTime,endDate+iDay,endTime,needIcuaId, needWardLocId, needClcsId, ancvcId, userId, ifDebug)
 	q "0"
}

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuOrder3(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindIcuOrder",1945,60000,0,66000,0,"","","","MAI")
ClassMethod FindIcuOrder3Execute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	
	k ^TMPICU("Order",$j)
	//k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	i icuaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	
	//s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	//s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
	    .q:ancvcIdStr'=""
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..i icuoSourceStr="I" d
	        	...s curTime=""
	        	...f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")  d
	        		....s icucdSub=""
	        		....f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	        			.....q:$$GetCollectData("Y")<0
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:$$GetIcuoData("Y")<0
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^")
	                ....q:icucriCode=""
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
			..s icuoStartDateTime=""
			..f  s icuoStartDateTime=$o(adjTimeList(icuoStartDateTime)) q:icuoStartDateTime=""  d
				...s mainIcuoId=$o(adjTimeList(icuoStartDateTime,"")) //第一个时间不调整
				...f  s mainIcuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId)) q:mainIcuoId=""  d
					....q //新版暂不自动调整时间
					....
					....s curDateTime=icuoStartDateTime
					....s isFind=0,newDateTime=""
					....
					....f j=1:1:20 d //暂用20个
						.....s curDateTime=curDateTime+0.00001
						.....i curDateTime-$p(curDateTime,".")>0.86399 s curDateTime=$p(curDateTime,".")+1
						.....q:$d(adjTimeList(curDateTime))
						.....q:isFind
						.....s newDateTime=curDateTime
						.....s isFind=1
					....//w mainIcuoId_"/"_icuoStartDateTime_"/"_newDateTime,!
					....q:newDateTime=""
					....s adjTimeList(newDateTime)=""
					....s adjTimeList(icuoStartDateTime,mainIcuoId)=newDateTime
					....s icuoStartTime=(icuoStartDateTime-$p(icuoStartDateTime,"."))*100000
					....s newTime=(newDateTime-$p(newDateTime,"."))*100000
					....s icuoId=""
					....f  s icuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)) q:icuoId=""  d
						.....s updateDateTime=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",1)
						.....s oreGroupStr=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",2)
						.....q:'$d(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId))
						.....s $p(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId),"^",6)=$zt(newTime)
						.....k ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,icuoStartTime,icuoId)
						.....s ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,newTime,icuoId)=""
						.....s $p(^DHCICUOrder(icuoId),"^",6)=newTime
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:$$GetIcuoData("Y")<0
	
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....//s i=i+1
	             	....//s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s icuoConcentration=$p(^DHCICUOrder(icuoId),"^",13) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr=$p(^DHCICUOrder(icuoId),"^",14) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag=$p(^DHCICUOrder(icuoId),"^",17) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s icuoDrugMode=$p(^DHCICUOrder(icuoId),"^",18) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s icuoSpeed=$p(^DHCICUOrder(icuoId),"^",19) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s icuoReason=$p(^DHCICUOrder(icuoId),"^",24) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curEditedId=$p(^DHCICUOrder(icuoId),"^",23) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s icuoRecLocId=$p(^DHCICUOrder(icuoId),"^",26) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icuoType=$p(^DHCICUOrder(icuoId),"^",30) //tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s icuoPreparedVolume=+$p(^DHCICUOrder(icuoId),"^",31) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId=$p(^DHCICUOrder(icuoId),"^",32) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=$p(^DHCICUOrder(icuoId),"^",33) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoMainIcuoDr=$p(^DHCICUOrder(icuoId),"^",36) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curTimeStr=icucriId_","_oeoreId_","_icuoIcupiDr_"^"_icuoStartDateTime
	s originalAncvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)
	//i ("^"_$g(^DHCCLSet("CollectAncvcId"))_"^")[originalAncvcId s curTimeStr=icucriId_","
	i icucriId>0,"EN"[mainIcuoEditFlag,$g(tmpCurTime(curTimeStr))'="" d //clear duplicate data
		.//w updateDateTime_" update/"_icucriId_"/"_icuoId_": "_tmpCurTime(curTimeStr),!
		.i updateDateTime'<$g(tmpCurTime(curTimeStr)) d
			..k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(curTimeStr),"^"),$p(tmpCurTime(curTimeStr),"^",2),$p(tmpCurTime(curTimeStr),"^",3))
			..s clearIcuoId=+$p(tmpCurTime(curTimeStr),"^",3)
			..q:'$d(^DHCICUOrder(clearIcuoId))
			..s $p(^DHCICUOrder(clearIcuoId),"^",25)=""
			..s ^TMPICUClear(clearIcuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
		.e  d
			..//w icuoId_"/"_curTimeStr_"/"_$g(tmpCurTime(curTimeStr)),!
			..s $p(^DHCICUOrder(icuoId),"^",25)=""
			..s ^TMPICUClear(icuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
			..//w "k:"_icuoId
	q:("EN"[mainIcuoEditFlag)&(updateDateTime<$g(tmpCurTime(curTimeStr))) -11 //当前时间点有正常数据，但不是最新修改
	i startDate=63204,icucriId=5330 w mainIcuoEditFlag_"/3:"_updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId,!
	i ("EN"[mainIcuoEditFlag)&(icucriId>0) d
		.s tmpCurTime(curTimeStr)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId //记录最新修改数据
	 	.i startDate=63204,icucriId=5330 w curTimeStr_"/4:"_tmpCurTime(curTimeStr),!
	 	.//w curTimeStr_"/tmpCurTime:"_tmpCurTime(curTimeStr),!
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	//w "all:"_tmpStr,!
	f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
		.q //未用
		.
		.q:"C"[mainIcuoEditFlag
		.q:$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12)["D"
		.s icuodStartDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)
		.s icuodStartTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)
		.s icuodStartDateTime=icuodStartDate+(icuodStartTime/100000)
		.q:endDateTime'>icuodStartDateTime
	 	.s icuodEndDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)
		.s icuodEndTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)
		.s icuodEndDateTime=icuodEndDate+(icuodEndTime/100000)
		.q:sttDateTime>icuodEndDateTime
		.
		.s curId=icuoId_"||"_icuodSub //s $p(tmpStr,"^",1)=icuoId_"||"_icuodSub
		.s curStartDate=$zd(icuodStartDate,3) //s $p(tmpStr,"^",5)=$ZD(icuodStartDate,3)
	 	.s curStartTime=$zt(icuodStartTime) //s $p(tmpStr,"^",6)=$ZT(icuodStartTime)
		.s curEndDate=$zd(icuodEndDate,3) //s $p(tmpStr,"^",7)=$ZD(icuodEndDate,3)
		.s curEndTime=$zt(icuodEndTime) //s $p(tmpStr,"^",8)=$ZT(icuodEndTime)
		.s curIcucriId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //ICUOD_ComOrd_Dr
		.s curAbbreviate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //ICUOD_Abbreviate
		.s curQty=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //icuod_Qty
		.s curNote=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //icuod_Note
		.s curUserId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //icuod_User_Dr
		.s curUpdateDate=$zd($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10),3) //icuod_UpdateDate
		.s curUpdateTime=$zt($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //icuod_UpdateTime
		.s curEditFlag=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //icuod_EditFlag
	    .s curEditedId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) //icuod_icuod_Dr
		.s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
		.//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	q 0
    
OutputIcuOrder
	//s Data=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,icucriDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuOrder3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuOrder3Execute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuOrder3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuOrder3Execute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuOrder(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLScore","FindIcuOrder",3816,$h,0,$h+1,0,"","","","MAI")
ClassMethod FindIcuOrderExecute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	
	s EpisodeID = "", ctlocId = "", ancvcIdStr = "", shiftStartTime = ""
	k ^TMPICU("Order",$j)
	//k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	i icuaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	
	//s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	//s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
	    .q:ancvcIdStr'=""
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..i icuoSourceStr="I" d
	        	...s curTime=""
	        	...f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")  d
	        		....s icucdSub=""
	        		....f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	        			.....w "."_..GetCollectData("Y",icuaId,icucdSub,sttDateTime,endDateTime)
	        			.....q:..GetCollectData("Y",icuaId,icucdSub,sttDateTime,endDateTime)<0
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:..GetIcuoData("Y",icucriId,icuaId,icuoId,icuoSourceStr,sttDateTime,endDateTime,icucriIdStr,seq)<0
	                ....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)  ////temp
	                ....s icuoStartDateTime=curDate+(icuoSttTime/100000)  ////temp
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^")
	                ....q:icucriCode=""
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....q  ////temp
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:..GetIcuoData("Y",icucriId,icuaId,icuoId,icuoSourceStr,sttDateTime,endDateTime,icucriIdStr,seq)<0
	
	s i=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s i=i+1
	             	....//s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
	w "count="_i,!
	b
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputIcuOrder
	//s Data=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,icucriDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuOrderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetIcuoData(ifByDateTime = "", icucriId, icuaId, icuoId, icuoSourceStr, sttDateTime, endDateTime, icucriIdStr, seq) As %String
{
	q:'$d(^DHCICUOrder(icuoId)) -1
	//s ^TMPICU("Order",$j,icuaId,1,2_","_icucriId_","_3,icuoId)=$lb(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,icuaId,6,7,8,9,0,1,2,3,4,5,6)
	//s ^TMPICU("Order",$j,icuaId,1,2_","_icucriId_","_3,icuoId)=$lb(1,2,3,4,5,6,7,8)
	//q 0
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s icuoConcentration=$p(^DHCICUOrder(icuoId),"^",13) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr=$p(^DHCICUOrder(icuoId),"^",14) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag=$p(^DHCICUOrder(icuoId),"^",17) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s icuoDrugMode=$p(^DHCICUOrder(icuoId),"^",18) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s icuoSpeed=$p(^DHCICUOrder(icuoId),"^",19) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s icuoReason=$p(^DHCICUOrder(icuoId),"^",24) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curEditedId=$p(^DHCICUOrder(icuoId),"^",23) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s icuoRecLocId=$p(^DHCICUOrder(icuoId),"^",26) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icuoType=$p(^DHCICUOrder(icuoId),"^",30) //tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s icuoPreparedVolume=+$p(^DHCICUOrder(icuoId),"^",31) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId=$p(^DHCICUOrder(icuoId),"^",32) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=$p(^DHCICUOrder(icuoId),"^",33) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoMainIcuoDr=$p(^DHCICUOrder(icuoId),"^",36) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curTimeStr=icucriId_","_oeoreId_","_icuoIcupiDr_"^"_icuoStartDateTime
	s originalAncvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)
	//i ("^"_$g(^DHCCLSet("CollectAncvcId"))_"^")[originalAncvcId s curTimeStr=icucriId_","
	i icucriId>0,"EN"[mainIcuoEditFlag,$g(tmpCurTime(curTimeStr))'="" d //clear duplicate data
		.//w updateDateTime_" update/"_icucriId_"/"_icuoId_": "_tmpCurTime(curTimeStr),!
		.i updateDateTime'<$g(tmpCurTime(curTimeStr)) d
			..k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(curTimeStr),"^"),$p(tmpCurTime(curTimeStr),"^",2),$p(tmpCurTime(curTimeStr),"^",3))
			..s clearIcuoId=+$p(tmpCurTime(curTimeStr),"^",3)
			..q:'$d(^DHCICUOrder(clearIcuoId))
			..s $p(^DHCICUOrder(clearIcuoId),"^",25)=""
			..s ^TMPICUClear(clearIcuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
		.e  d
			..//w icuoId_"/"_curTimeStr_"/"_$g(tmpCurTime(curTimeStr)),!
			..s $p(^DHCICUOrder(icuoId),"^",25)=""
			..s ^TMPICUClear(icuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
			..//w "k:"_icuoId
	q:("EN"[mainIcuoEditFlag)&(updateDateTime<$g(tmpCurTime(curTimeStr))) -11 //当前时间点有正常数据，但不是最新修改
	i ("EN"[mainIcuoEditFlag)&(icucriId>0) d
		.s tmpCurTime(curTimeStr)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId //记录最新修改数据
	 	.//w curTimeStr_"/tmpCurTime:"_tmpCurTime(curTimeStr),!
	s curId=icuoId
	s icuodSub=0
	//s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime)
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	////s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	////s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	q 0
}

ClassMethod GetCollectData(ifByDateTime = "", icuaId, icucdSub, sttDateTime, endDateTime) As %String
{
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	q 0
}

ClassMethod GetICUOrditemInfo(icuoId) As %String
{
	q:icuoId="" ""
	q:'$d(^DHCICUOrder(icuoId)) ""
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35)	//主医嘱|从医嘱|优先级Id|频率Id|医嘱备注
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)			//ICUO_Instr_Dr
	s phcinCode="",phcinDesc=""
	i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p(icuoOrdItemNote,"|",1)
	s subOeoriId=$p(icuoOrdItemNote,"|",2)
	s oecprId=$p(icuoOrdItemNote,"|",3)	
	s oecprCode=""
	i oecprId>0 s oecprCode=$p(^OECPR(+oecprId),"^",1)	//优先级
	s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcfrId=$p(icuoOrdItemNote,"|",4)
    //w $g(^PHCFR(+phcfrId)),!
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p($g(^PHCFR(+phcfrId)),"^",2)
    s oeoriNote=$p(icuoOrdItemNote,"|",5)
    
    s defPhcinId="",defPhcinCode="",defPhcinDesc="",oriQty="",unitUomId=""
	q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oeoriNote
}

ClassMethod GetOeorditemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCICUOrder).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
    q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
    s phcinCode="",phcinDesc="" 
    i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s volume=##Class(web.DHCClinicCom).GetVolume(oeoriId)
	s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	s subOeoriId=""
	i oeoriSub'="" d
	    .s curOriSub=""
	    .f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
			..s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+curArcimId,+$p(curArcimId,"||",2),1)),"^",2)
			..q:arcimDesc=""
		    ..q:(arcicOrderType="R")&(##Class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType)
		    ..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
		    ..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub
		    ..s volume=volume+##Class(web.DHCClinicCom).GetVolume(oeordId_"||"_curOriSub)
	
	//for 第三方HIS begin
	s EpisodeID=+^OEORD(+oeoriId)
	s lhnOrderNo=$o(^DHCLHN(0,"OEORI",EpisodeID,oeoriId,""))
	i lhnOrderNo'="" d //以此为标志
	    .s mainOeoriId=""
	    .s subOeoriId=""
	    .s mainLhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,1,""))
	    .q:mainLhnId=""
	    .q:'$d(^DHCLHN(mainLhnId))
	    .i oeoriId'=$p(^DHCLHN(mainLhnId),"^",4) s mainOeoriId=$p(^DHCLHN(mainLhnId),"^",4)
	    .q:mainOeoriId'="" //有主医嘱指针，是从医嘱
	    .s lhnOrderSubNo=1
	    .f  s lhnOrderSubNo=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo)) q:lhnOrderSubNo=""  d
	        ..s lhnId=""
	        ..f  s lhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo,lhnId)) q:lhnId=""  d
	        	...q:'$d(^DHCLHN(lhnId)) 
	        	...i subOeoriId'="" s subOeoriId=subOeoriId_"!"
	        	...s subOeoriId=subOeoriId_$p(^DHCLHN(lhnId),"^",4)
	//w mainOeoriId_"/"_subOeoriId,!
	//for 第三方HIS end
	
	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
    s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
    s defPhcinCode=$p($g(^PHCIN(defPhcinId)),"^",1),defPhcinDesc=$p($g(^PHCIN(defPhcinId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p(^PHCFR(+phcfrId),"^",2)

    s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	s phOrdQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12)
	i doseQty="",phOrdQty="" s unitUomId=""
	i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
	s oriQty=doseQty
	i oriQty="" s oriQty=phOrdQty
	s oeoriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
    
    q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oeoriNote_"^"_volume
}

/// w ##class(web.DHCCLScore).AutoAddScoreOrderByTime("2015-05-06","2015-05-18","15",6113,"",38,233,"",1)
ClassMethod AutoAddScoreOrderByTime(startDate, endDate, hour, needIcuaId = "", needWardLocId = "", needClcsId = "", ancvcId = "", userId = "", ifDebug = 0) As %String
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	B
	f iDay=startDate:1:endDate  d
	.s iDay =##class(web.DHCClinicCom).ConvertToDate(iDay)
	.w iDay,!
	.//w ##class(web.DHCCLScore).AutoAddScoreOrderByHour(iDay,hour,needIcuaId,needWardLocId,needClcsId,ancvcId,userId,ifDebug)
	
	q "0"
}

ClassMethod AutoAddScoreByDate(hour)
{
	s startD=+$h-5
	s endD=+$H-1
	f i=startD:1:endD  d
	.w ##class(web.DHCCLScore).AutoAddScoreOrder(startD,hour*3600,startD+1,hour*3600,"",56,"APACHEII","APACHEII","",1)
}

// 计算死亡率

ClassMethod GetICUADeathProbability(icuaId, fromDate = "", fromTime = "", toDate = "", toTime = "") As %String
{
	//w ##class(web.DHCCLScore).GetICUADeathProbability(7725)
	q:icuaId="" ""
	i fromDate="" d
		.s fromDate=$p($g(^DHCICUArrange(icuaId)),"^",6),fromTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.s toDate=fromDate+1,toTime=(fromTime\3600)*3600
		.//s apacheIIScore=$p($g(^DHCICUArrange(icuaId)),"^",40)
	s apacheIIScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",fromDate,fromTime,toDate,toTime,"Max")
	w apacheIIScore,!
	q:apacheIIScore="" ""
	s value=-3.517+(apacheIIScore*0.146)
	s icuaSurgeryType=$p($g(^DHCICUArrange(icuaId)),"^",30)
	i icuaSurgeryType="E" s value=value+0.603
	s icuaDiagnosticCatCLCSOId=$p($g(^DHCICUArrange(icuaId)),"^",41)
	s clcsId=+icuaDiagnosticCatCLCSOId,clcsSub=+$p(icuaDiagnosticCatCLCSOId,"||",2)
	s diagnosticCatWeight=""
	i clcsSub>0 s diagnosticCatWeight=$lg(^DHCCLC("Score",clcsId,"O",clcsSub),5)
	w apacheIIScore_"/"_icuaDiagnosticCatCLCSOId_"/"_diagnosticCatWeight,!
	q:diagnosticCatWeight="" ""
	
	s value=value+diagnosticCatWeight
	//w "value="_value,!
	s value=$zexp(value)
	s deathProbability=value/(1+value)
	q deathProbability
}

// 调整入科死亡率

ClassMethod AdjustICUADeathProbability(icuaId) As %String
{
	//w ##class(web.DHCCLScore).AdjustICUADeathProbability()
	s retVal=0
	q:icuaId="" ""
	//q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=33 ""
	q:'$d(^DHCICUArrange(icuaId)) -11
	q:$p($g(^DHCICUArrange(icuaId)),"^",10)="A" -1
	s icuaDeathProbability=..GetICUADeathProbability(icuaId)
	//i icuaDeathProbability="" w icuaId,!
	q:+icuaDeathProbability=0 -2
	s diff=icuaDeathProbability-$p($g(^DHCICUArrange(icuaId)),"^",42)
	i $zabs(diff)>0.001 d
		.w icuaId,"/not equal:"_$p($g(^DHCICUArrange(icuaId)),"^",4)_"/"_icuaDeathProbability,"/"_$p($g(^DHCICUArrange(icuaId)),"^",42),"    "_diff,!
		.s retVal=-3
		.s ^DHCICUScoreLogTmp($h,icuaId,"not equal")=icuaId_"/not equal:"_$p($g(^DHCICUArrange(icuaId)),"^",4)_"/"_icuaDeathProbability_"/"_$p($g(^DHCICUArrange(icuaId)),"^",42)_"    "_diff
		.s $p(^DHCICUArrange(icuaId),"^",42)=icuaDeathProbability
	e  d
		.w icuaId,"/equal:"_$p($g(^DHCICUArrange(icuaId)),"^",4)_"/"_icuaDeathProbability,"/"_$p($g(^DHCICUArrange(icuaId)),"^",42),"     "_diff,!
		.s retVal=-4
	q retVal
}

ClassMethod StatICUADeathProbability() As %String
{
	//w ##class(web.DHCCLScore).StatICUADeathProbability()
	s countA=0,countNull=0,countError=0,countEqual=0
	f icuaId=1:1:^DHCICUArrange(0) d
		.s retStr=-1
		.s retStr=..AdjustICUADeathProbability(icuaId)
		.
		.//q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=33
		.s apacheIIScore=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s fromDate=$p($g(^DHCICUArrange(icuaId)),"^",6),fromTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.s toDate=fromDate+1,toTime=(fromTime\3600)*3600
		.//i apacheIIScore'="" d
			..i apacheIIScore=0 s retStr=-2 q
			..s apacheIIScoreCal=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",fromDate,fromTime,toDate,toTime,"Max")
			..i (apacheIIScore'="")&($zabs(apacheIIScore-apacheIIScoreCal)>0.001) s retStr=-3 w icuaId_"/"_apacheIIScore_"/"_apacheIIScoreCal,!
			..e  s retStr=-4
		.
		.i retStr=-1 s countA=countA+1
		.i retStr=-2 s countNull=countNull+1
		.i retStr=-3 s countError=countError+1
		.i retStr=-4 s countEqual=countEqual+1
	q countA_"/"_countNull_"/"_countError_"/"_countEqual
}

/// 自动插入质控数据
/// 入参：日期、时间
/// startDate:开始日期,startTime:开始时间
/// endDate：评分日期, endTime：评价时间
/// needIcuaId:icuaId
/// needWardLocId:登陆科室
/// needClcsId:评分总分主项 APACHEII,SOFA
/// ancvcId:显示分类代码，APACHEII,SOFA
ClassMethod AutoAddQualityControlOrder(startDate, startTime, endDate, endTime, needIcuaId = "", needWardLocId = "", needClcsCode = "", ancvcCode = "", userId = "", ifDebug = 0) As %String
{
	//w ##class(web.DHCCLScore).AutoAddScoreOrder($h-1,13*3600,$h,13*3600,687,56,26,232,"",1)
	//w ##class(web.DHCCLScore).AutoAddQualityControlOrder(64724,0,64725,68407,18830,56,"VAPFSLTotal","VAPIncidence","",1)
	//w ##class(web.DHCCLScore).AutoAddQualityControlOrder(64726,36000,64727,36000,18744,56,"VAPFSLTotal","VAPIncidence","",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder("2015-05-18","15:00:00","2015-05-18","15:00:00",6113,,38,233,"",1)
	//icucriList(icucriId):待插入数据；icupiSub^cat^value
	//scoreSrcList(scoreCode)评分代码对应源数据icucriId；
	//scoreList(scoreCode)评分代码对应评分值icucriId
	//mainScoreList(layer,clcsId,secondClcsId)主项到从项的树形结构，第一个节点是层
	
	s STX=$c(2)
	s ETX=$c(3)
	s needClcsId=""
	i needClcsCode'="" d
		.i needClcsCode=+needClcsCode s needClcsId=needClcsCode
	 	.e  s needClcsId=$o(^DHCCLC("Score",0,"Code",needClcsCode,"")) 
	s ancvcId=""
	i ancvcCode'="" d
		.i ancvcCode=+ancvcCode s ancvcId=ancvcCode
		.e  s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	w needClcsId_"/"_ancvcId,!
	q:(needClcsId="")!(ancvcId="") -1
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	s startDateTime=startDate+((startTime+1)/100000)
	s endDateTime=endDate+((endTime+1)/100000)
	s calDuration=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,endDate,endTime) //计算两个时间的时间差
	k scoreCodeToIdList
	s clcsId=0
	f  s clcsId=$o(^DHCCLC("Score",clcsId)) q:clcsId=""  d
		.q:$lg(^DHCCLC("Score",clcsId),1)=""
		.s scoreCodeToIdList($lg(^DHCCLC("Score",clcsId),1))=clcsId
	i needClcsId="" s clcsIdList(26)=""
	e  s clcsIdList(needClcsId)=""
	//s clcsIdList(38)="" //!!
	i ancvcId="" s ancvcId="232" 
	w clcsIdList(needClcsId),!
	w ancvcId,!
	//s ancvcId="232^233" //!!
	s scoreItemStr=""	
	k mainScoreList
	s clcsId=""
	//b
	f  s clcsId=$o(clcsIdList(clcsId)) q:clcsId=""  d  //评分关联项：主项到从项的树形结构
		.s clcslId=""
		.f  s clcslId=$o(^DHCCLC("ScoreLink",0,"M",clcsId,clcslId)) q:clcslId=""  d
			..s secondClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:secondClcsId=""
			..s clcsIdList(clcsId,secondClcsId)=""
			..s mainScoreList(1,clcsId,secondClcsId)="" //，
			..s curIcucriCode=$lg($g(^DHCCLC("Score",secondClcsId)),9)
			..s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
			..w clcsId_","_secondClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",secondClcsId)),1),!
			..s secondClcslId=""
			..f  s secondClcslId=$o(^DHCCLC("ScoreLink",0,"M",secondClcsId,secondClcslId)) q:secondClcslId=""  d
				...s thirdClcsId=$lg(^DHCCLC("ScoreLink",secondClcslId),2)
				...q:thirdClcsId=""
				...q:'$d(^DHCCLC("Score",thirdClcsId))
				...s clcsIdList(clcsId,secondClcsId,thirdClcsId)=""
				...s mainScoreList(2,secondClcsId,thirdClcsId)=""
				...s curIcucriCode=$lg($g(^DHCCLC("Score",thirdClcsId)),9)
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
				...w clcsId_","_secondClcsId_","_thirdClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",thirdClcsId)),1),!
				...s thirdClcslId=""
				...f  s thirdClcslId=$o(^DHCCLC("ScoreLink",0,"M",thirdClcsId,thirdClcslId)) q:thirdClcslId=""  d
					....s fourthClcsId=$lg(^DHCCLC("ScoreLink",thirdClcslId),2)
					....q:fourthClcsId=""
					....q:'$d(^DHCCLC("Score",fourthClcsId))
					....s clcsIdList(clcsId,secondClcsId,thirdClcsId,fourthClcsId)=""
					....s curIcucriCode=$lg($g(^DHCCLC("Score",fourthClcsId)),9)
					....s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
					....w clcsId_","_secondClcsId_","_thirdClcsId_","_fourthClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2),"\"_$lg($g(^DHCCLC("Score",fourthClcsId)),1),!
					....i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
					....s scoreItemStr=scoreItemStr_fourthClcsId
					....s mainScoreList(3,thirdClcsId,fourthClcsId)=""
				...//q:$d(clcsIdList(clcsId,secondClcsId,thirdClcsId))=11
				...i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
				...s scoreItemStr=scoreItemStr_thirdClcsId
			..q:$d(clcsIdList(clcsId,secondClcsId))=11
			..i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
			..s scoreItemStr=scoreItemStr_secondClcsId
	f i=1:1:$l(scoreItemStr,"^") d
		.s clcsId=$p(scoreItemStr,"^",i)
		.q:clcsId=""
		.s $p(scoreCodeStr,"^",i)=$lg(^DHCCLC("Score",clcsId),1)
	w scoreItemStr,!
	w scoreCodeStr,!
	s arfId=$o(^DHCCLC("Score",0,"Code","ARF",""))
	w arfId_"/"_$l(arfId),!
	i ("^"_scoreCodeStr_"^")["^Creatinine(ARF×2)^" s scoreItemStr=scoreItemStr_"^"_arfId //有Apache血清肌酐添加急性肾功能衰竭
	s nbpId=$o(^DHCCLC("Score",0,"Code","NBP",""))
	w nbpId_"/"_$l(nbpId),!
	i ("^"_scoreCodeStr_"^")["^AMBP^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有AMBP时添加NBP
	i ("^"_scoreCodeStr_"^")["^SOFAHypotension^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有SOFAHypotension,加AMBP，加NBP?
	s sofaUrineId=$o(^DHCCLC("Score",0,"Code","SOFAUrine",""))
	w sofaUrineId_"/"_$l(sofaUrineId),!
	i ("^"_scoreCodeStr_"^")["^SOFACreatinineAndUrine^" s scoreItemStr=scoreItemStr_"^"_sofaUrineId //在有肌酐umol/L时添加尿量
	w scoreItemStr,!
	
	//s icucriId=""
	//f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
	//	.q:("^"_ancvcId_"^")'[$p(^DHCICUC("RecordItem",icucriId),"^",5)
	//	.s icucriIdList(icucriId)=""
	//	.w icucriId_","_$p(^DHCICUC("RecordItem",icucriId),"^",2),!
	
	s propertyId="",scoreItemPropertyId="",isScorePropertyId="",affectiveScoreItemId=""
	f  s propertyId=$o(^DHCICUC("Property",propertyId)) q:propertyId=""  d
		.i $lg(^DHCICUC("Property",propertyId),1)="ScoreItemCode" s scoreItemPropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="IsScore" s isScorePropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="AffectiveScoreItemCode" s affectiveScoreItemId=propertyId
	//w scoreItemPropertyId_"\"_isScorePropertyId,!
	w "评分层次>===================================<科室模板",!
	s wardCtlocId="",retStr=""
	f  s wardCtlocId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId)) q:wardCtlocId=""  d
		.q:(needWardLocId'="")&(needWardLocId'=wardCtlocId)
		.k paraItemList
		.s icupId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId,""))
		.
		.s icupiSub=""
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..s icucriId=$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)
			..//w icupId_"||"_icupiSub,"\"_icucriId,!
			..q:icucriId=""
			..;q:("^"_ancvcId_"^")'[("^"_$p(^DHCICUC("RecordItem",icucriId),"^",5)_"^")
			..q:("^"_ancvcId_"^")'[$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..s icupidSub=0,scoreItemCode="",isScore=0
			..f  s icupidSub=$o(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...i scoreItemPropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) d
					....s scoreItemCode=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",2)
				...i isScorePropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) s isScore=1
			..s recordItemCode=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
			..;w "recordItemCode"_recordItemCode,!
			..i (recordItemCode="VAP48hMechV")||(recordItemCode="CAUTICatheter") d //主查询项目条件显示模板
				...s icuMainCriList(icucriId)=icupiSub_"^"_$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
				...w "recordItemCode:"_recordItemCode_"/"_icuMainCriList(icucriId),!
			..s icucriList(icucriId)=icupiSub_"^"_$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..w icucriId_",=="_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"\"_scoreItemCode,"\",isScore,"\"_icupiSub,!
			..q:scoreItemCode=""
			..s clcsId=$g(scoreCodeToIdList(scoreItemCode))
			..q:clcsId=""
			..i $lg(^DHCCLC("Score",clcsId),6)=1 d
				...s scoreList(scoreItemCode)=icucriId
				...w "    mainScoreList:"_scoreItemCode_":"_icucriId,!
			..e  d 
				...i (isScore=1) d //!!
					....s scoreList(scoreItemCode)=icucriId
					....w "    scoreList:"_scoreItemCode_":"_icucriId,!
				...e  d
					....q:$p(^DHCICUPara(icupId,"I",icupiSub),"^",13)="ApacheFiO2ScoreSource"
					....s scoreSrcList(scoreItemCode)=icucriId
					....w "    scoreSrcList:"_scoreItemCode_":"_icucriId,!
			..i (icupiSub=326) s scoreList(scoreItemCode)=6394
		.w "    curCtlocId="_wardCtlocId,!
		.k wardEpisodeIDList
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",+needWardLocId,0))
		.s EpisodeID=""
		.i needIcuaId'="" s EpisodeID=$p($g(^DHCICUArrange(+needIcuaId)),"^",1)
		.w EpisodeID,!
		.i EpisodeID'="" d
			..s patList=""
			..q:+$p($g(^DHCICUArrange(needIcuaId)),"^",4)'=wardId
			..s patList=EpisodeID_"|||"_needIcuaId
		.e  d
			..s patList=##class(web.DHCICUCom).FindWardPatient("",wardCtlocId) //找当前病区病人
			..w EpisodeID_"/before "_patList,!
			..s searchDate=startDate-1 //查前一天病人和当天病人，考虑到转入时间与监护时间可能跨天
			..f  s searchDate=$o(^DHCICUOrder(0,"SttDateTime",searchDate)) q:(searchDate="")!(searchDate-1>startDate)  d
				...w searchDate,!
				...s icuaId=""
				...f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",searchDate,icuaId)) q:icuaId=""  d //当天来当天走的？
					....q:'$d(^DHCICUArrange(icuaId))
					....q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
					....s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
					....q:outDateTime=""
					....s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
					....q:outDate<startDate
					....s curEpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
					....q:curEpisodeID=""
					....q:("^"_patList_"|")[("^"_curEpisodeID_"|")
					....w icuaId_"\"_curEpisodeID_"\"_$zd(outDate,3)_"\"_$zt(outTime),!
					....s patList=patList_"^"_curEpisodeID_"|||"_icuaId
		.
		.w EpisodeID_"/patientList:== "_patList,!
		.s scoreStartDate=startDate
		.s scoreStartTime=startTime
		.s scoreStartDateTime=startDate+(startTime/100000)
		.s scoreEndDate=endDate
		.s scoreEndTime=endTime
		.s scoreEndDateTime=endDate+(endTime/100000)
		.f i=1:1:$l(patList,"^") d
			..s EpisodeID=+$p(patList,"^",i)
			..q:EpisodeID=0
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..s wardEpisodeIDList(EpisodeID)=""
			..s mainOrderParaList=""
			..s icuaId=$p($p(patList,"^",i),"|",4)
			..q:icuaId=""
			..s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
			..q:icupId=""
			..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			..s inDate=+inDateTime,inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
			..w EpisodeID_" inDatTeime:",inDate_"/"_inTime," endTime:",endTime_","_startDate_"/"_startTime,!
			..q:(inDate>startDate)!((inDate=startDate)&((inTime\3600*3600)>startTime))
			..q:(endDate>$h)!((endDate=+$h)&(endTime>$p($h,",",2)))
			..q:((inTime\3600)'=(endTime\3600)) //与入参时间不匹配则不插入
			..//s icuaId=##class(web.DHCICUCom).GetIcuaId(EpisodeID, "", "", "Y", "N", "", "", endDate, endTime)
			..w "intime mathed icuaId=="_icuaId,!
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..w " have outTime? outTime="_outDateTime
			..q:(inDate="")&(outDateTime="")
			..s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
			..i outDate=0 s outDate=+$h,outTime=$p($h,",",2)
			..w " outDate<startDate?e "_startDate
			..q:outDate<startDate
			..w "  needIcuaId?",!
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)			
			..w needClcsCode_":"_" start",!
			..s retQuit=0
			..i needClcsCode="VAPFSLTotal" d  //VAP/机械通气(48小时内)
				...s deviceName=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"VDeviceName",startDate-2,startTime,endDate,endTime,"","","","","AddDateTime","","","PB840^Maquet^EvitaXL^Drager^Hamilton^Taema^Mindry^Maquet Servo-s^Evita 4")
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode("VAP48hMechV")
				...s deviceVal=$p(deviceName,"~",1)
				...s deviceDT=$p(deviceName,"~",2)
				...i deviceVal="" d
					....s retQuit=1 //无值退出
					....s $p(icuMainCriList(curIcucriId),"^",3)="否"
				...e  d
					....s retQuit=0					
					....s deviceDate=$zdh($p(deviceDT," ",1),3)
					....s deviceTime=$zth($p(deviceDT," ",2),2)
					....;s deviceDateTime=deviceDate+(deviceTime/100000)
					....s deviceDateTime48h=(deviceDate+2)+(deviceTime/100000)
					....i deviceDateTime48h<scoreEndDateTime s scoreEndTime=deviceTime
					....w "deviceDateTime48h:"_deviceDateTime48h_"/"_scoreEndDateTime_"/"_deviceName,!
					....s $p(icuMainCriList(curIcucriId),"^",3)="是"
			..i needClcsCode="CAUTIFSLTotal" d  //CAUTI/尿导管+置管拔管+48小时内
				...s cgValue=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"CgDate",inDate,startTime,endDate,endTime,"Exact",endDate,endTime) //插管时间
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode("CAUTICatheter")
				...i cgValue'="" d
					....s cgDate=$zdh($p(cgValue," ",1),3)
					....s cgTime=$zth($p(cgValue," ",2),2) 
					....s bgValue=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"BgDate",cgDate,cgTime,endDate,endTime,"Exact",endDate,endTime) //拔管时间
					....i bgValue="" d
						.....s $p(icuMainCriList(curIcucriId),"^",3)="是"
						.....w "NotbgValue:"_cgValue_"/"_bgValue,!
					....e  d
						.....s bgDate=$zdh($p(bgValue," ",1),3)
						.....s bgTime=$zth($p(bgValue," ",2),2) 
						
						.....s deviceDateTime48h=(bgDate+2)+(bgTime/100000)
						.....w "bgValue:"_cgValue_"/"_bgValue_"/"_deviceDateTime48h_"/"_scoreStartDateTime_"/"_scoreEndDateTime,!
						.....i deviceDateTime48h<scoreStartDateTime s retQuit=1,$p(icuMainCriList(curIcucriId),"^",3)="否" q
						.....i deviceDateTime48h<scoreEndDateTime s scoreEndTime=bgTime
						.....s $p(icuMainCriList(curIcucriId),"^",3)="是"
				...e  d
					....s retQuit=1
					....s $p(icuMainCriList(curIcucriId),"^",3)="否"
			
			..i needClcsCode="CIFSLTotal" d   //导管感染发生率/导管血样本
				...s testDGXStr=""
				...s standCodeStr="CUL322^CUL2609^CUL5056^CUL5135^CUL310^CUL311^CUL323^CUL2610^CUL5055^CUL5134^CUL4366"
				...//导管血需氧、厌氧			
				...f x=1:1:$l(standCodeStr,"^") d
					....s standCode=$p(standCodeStr,"^",x)
					....s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standCode, startDate, startTime, endDate, endTime,0,"SP128^SP129^SP130^SP215^SP258^SP226^SP48^SP271^SP232^SP243","touchQty")
					....i (testDGXStr="")&&(testRetStr'="") s testDGXStr =testRetStr
					....e  i (testDGXStr'="")&&(testRetStr'="") s testDGXStr =testDGXStr_ETX_testRetStr
					....;w "testDGXStr"_regNo_"\"_standardCode_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_testRetStr,!
					....;w "testRetStr"_testRetStr,!
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode("CICBSpec")
				...i testDGXStr'="" d
					....s bbDescStr=""
					....f y=1:1:$l(testDGXStr,ETX) d
						.....s testStr=$p(testDGXStr,ETX,y)
						.....q:$p(testStr,STX)=""
						.....s testValue=$p(testStr,STX)
						.....s labNo=$p(testStr,STX,9)
						.....s bbDesc=$p(testStr,STX,10)
						.....i bbDescStr="" s bbDescStr=bbDesc
						.....e  i bbDescStr'[bbDesc  s bbDescStr=bbDescStr_" "_bbDesc
					....s $p(icuMainCriList(curIcucriId),"^",3)=bbDesc
					....w "bbDesc:"_curIcucriId_"/"_bbDesc,!		
			
			..w "retQuit"_retQuit,!	
			..q:retQuit
			..
			..s icucriId=""
			..f  s icucriId=$o(icuMainCriList(icucriId)) q:icucriId=""  d
				...w icucriId_"/"_icuMainCriList(icucriId),!
				...q:$p(icuMainCriList(icucriId),"^",3)=""
				...s $p(mainOrderPara,$c(3),2)=icuaId
				...s $p(mainOrderPara,$c(3),3)=icucriId
				...s $p(mainOrderPara,$c(3),5)=userId
				...s $p(mainOrderPara,$c(3),6,9)=endDate_$c(3)_endTime_$c(3)_endDate_$c(3)_endTime
				...s $p(mainOrderPara,$c(3),11)=""
				...s $p(mainOrderPara,$c(3),12)=""
				...i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Note" s $p(mainOrderPara,$c(3),11)=$p(icuMainCriList(icucriId),"^",3)
				...i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Qty" s $p(mainOrderPara,$c(3),12)=$p(icuMainCriList(icucriId),"^",3)
				...s $p(mainOrderPara,$c(3),17)=$p(icuMainCriList(icucriId),"^",2) //viewCat
				...s $p(mainOrderPara,$c(3),18)="N"
				...s $p(mainOrderPara,$c(3),22)=+$h
				...s $p(mainOrderPara,$c(3),23)=$p($h,",",2)
				...s $p(mainOrderPara,$c(3),26)="N"
				...s $p(mainOrderPara,$c(3),39)=icupId_"||"_$p(icuMainCriList(icucriId),"^",1)
				...i mainOrderParaList'="" s mainOrderParaList=mainOrderParaList_"^"
				...s mainOrderParaList=mainOrderParaList_mainOrderPara
				...//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_icuMainCriList(icucriId),"\"_
				...w $p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_":"_mainOrderPara,!
				...s $p(icuMainCriList(icucriId),"^",3)="" //赋值后清空
			..w "debug="_ifDebug,!
			..i 'ifDebug d
	    		...w "save"
	    		...s ^tmpdebug("SaveICUOrder","VAPFSLTotal")=mainOrderParaList
				...s retStr=##class(web.DHCICUOrder).SaveICUOrder(mainOrderParaList)
				...s ^DHCANICUDEBUG("ComfirmCollectData",endDate,endTime)=mainOrderParaList
				...k mainOrderParaList			
			..
			..w " start Create"
			..s retStr=$$CreateScoreDataNew
			..w "retStr="_retStr,!
	q retStr
	//q scoreItemStr
CreateScoreDataNew()
	q:+icuaId=0 -1
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	q:icupId="" -2
	
	s ifDefault=""
	i (+calDuration)>=86400 d 
	.s ifDefault="1"
	w "calDuration~~~~~~~~~~~~~~~~~~"_calDuration_","_ifDefault,!,!
	w "GetQCScoreValueByData~~~arg:"_icuaId_","_startDate_","_startTime_","_scoreEndDate_","_ scoreEndTime_","_ scoreItemStr_","_ifDefault,!
	s scoreValueList=..GetQCScoreValueByData(icuaId, startDate, startTime, scoreEndDate, scoreEndTime, scoreItemStr,"",ifDefault) //取计算评分
	;s ^Lynt("CreateScoreData")=startDate_"/"_startTime_"/"_scoreEndDate_"/"_scoreEndTime_"/"_ifDefault_"/scoreItemStr="_scoreItemStr
	w startDate_"/"_startTime_"/"_scoreEndDate_"/"_scoreEndTime_"/scoreItemStr="_scoreItemStr,!
	w "scoreValueList:"_scoreValueList,!
	
	f j=1:1:$l(scoreItemStr,"^") d  //叶结点数据对应常用医嘱项
		.s clcsId=$p(scoreItemStr,"^",j)
		.q:clcsId=""
		.w j_" "_clcsId_" "
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.q:scoreCode=""
		.s scoreValue=$p(scoreValueList,"^",j)
		.//q:scoreValue=""
		.w scoreCode_"/"_$g(scoreSrcList(scoreCode)),"/"_$g(scoreList(scoreCode)),!
		.
		.i $d(scoreSrcList(scoreCode)) d	//数据项
			..s $p(icucriList(scoreSrcList(scoreCode)),"^",3)=$p(scoreValue,"|",3)
		.i $d(scoreList(scoreCode)) d	//分值项
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=$p(scoreValue,"|",4)
		.w icucriList(scoreSrcList(scoreCode)),!
		.w icucriList(scoreList(scoreCode)),!

	s layer=""
	f  s layer=$o(mainScoreList(layer),-1) q:layer=""  d  //评分主项到从项的树形汇总
		.s mainClcsId=""
		.f  s mainClcsId=$o(mainScoreList(layer,mainClcsId)) q:mainClcsId=""  d
			..w "layer:"_layer_"\"_mainClcsId_":"_$lg(^DHCCLC("Score",mainClcsId),2),!
			..q:'$d(^DHCCLC("Score",mainClcsId))
			..s score=$lg(^DHCCLC("Score",mainClcsId),5)
			..s subClcsId="",ifhaveSubScore=1
			..f  s subClcsId=$o(mainScoreList(layer,mainClcsId,subClcsId)) q:subClcsId=""  d
				...w "    subId:"_subClcsId_":"_$lg(^DHCCLC("Score",subClcsId),2)_"\haveSub: "_ifhaveSubScore
				...i '$d(^DHCCLC("Score",subClcsId)) q
				...s scoreCode=$lg(^DHCCLC("Score",subClcsId),1)
				...;b ;"rrrrrr"
				...i scoreCode="" s ifhaveSubScore=0 w " No scoreItem",! q
				...i '$d(scoreList(scoreCode)) w " No Score Qty",! q
				...w " "_scoreList(scoreCode)_","_$g(icucriList(scoreList(scoreCode)))
				...i $p($g(icucriList(scoreList(scoreCode))),"^",3)="" s ifhaveSubScore=0  w " No Para item data ",! q
				...s score=score+($lg(^DHCCLC("Score",subClcsId),4)*$p($g(icucriList(scoreList(scoreCode))),"^",3))
				...w "  Yes:score="_score,!
			..w "  haveAllSubScore:"_ifhaveSubScore,!
			..q:'ifhaveSubScore
			..s scoreCode=$lg(^DHCCLC("Score",mainClcsId),1)
			..q:scoreCode=""
			..q:'$d(scoreList(scoreCode))
			..w "   "_scoreList(scoreCode)_"\"_icucriList(scoreList(scoreCode))_"\"_score,!
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=score
	//w "//////////"_$d(icucriList(icucriId)),!
	s icucriId="",orderParaList=""
	f  s icucriId=$o(icucriList(icucriId)) q:icucriId=""  d
		.w icucriId_"/"_icucriList(icucriId),!
		.q:$p(icucriList(icucriId),"^",3)=""
		.s $p(orderPara,$c(3),2)=icuaId
		.s $p(orderPara,$c(3),3)=icucriId
		.s $p(orderPara,$c(3),5)=userId
		.s $p(orderPara,$c(3),6,9)=endDate_$c(3)_endTime_$c(3)_endDate_$c(3)_endTime
		.s $p(orderPara,$c(3),11)=""
		.s $p(orderPara,$c(3),12)=""
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Note" s $p(orderPara,$c(3),11)=$p(icucriList(icucriId),"^",3)
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Qty" s $p(orderPara,$c(3),12)=$p(icucriList(icucriId),"^",3)
		.s $p(orderPara,$c(3),17)=$p(icucriList(icucriId),"^",2) //viewCat
		.s $p(orderPara,$c(3),18)="N"
		.s $p(orderPara,$c(3),22)=+$h
		.s $p(orderPara,$c(3),23)=$p($h,",",2)
		.s $p(orderPara,$c(3),26)="N"
		.s $p(orderPara,$c(3),39)=icupId_"||"_$p(icucriList(icucriId),"^",1)
		.i orderParaList'="" s orderParaList=orderParaList_"^"
		.s orderParaList=orderParaList_orderPara
		.//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_icucriList(icucriId),"\"_
		.w $p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_":"_orderPara,!
		.s $p(icucriList(icucriId),"^",3)="" //赋值后清空
	w "debug="_ifDebug,!
	i 'ifDebug d
	    .w "save"
	    .s ^tmpdebug("SaveICUOrder","VAPFSLTotal")=orderParaList
	    .s beforeApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s retStr=##class(web.DHCICUOrder).SaveICUOrder(orderParaList)
		.s ^DHCANICUDEBUG("ComfirmCollectData",endDate,endTime)=orderParaList
		.k orderParaList
		.
	//w
	q retStr
}

/// 查询评分项表对应时间范围内的评分值(质量控制数据)
/// 入参：icuaId监护安排Id, 开始日期、时间, 结束日期、时间, 
///       clcsStr：第一级用"^"分割; 第二级用"|"分隔:DHC_CLC_Score的Id,值，最小值，最大值;checkScoreValue:条件评分结果值
/// 返回值：第一级用"^"分隔，对应入参clcsIdStr串；第二级clcsId_"|"_各常用医嘱Id_"|"_最大(小)数据值_"|"_最大评分
ClassMethod GetQCScoreValueByData(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, clcsStr As %String, EpisodeID As %String = "", ifDefault As %String = "") As %String
{
	s result=""
	q:((icuaId="" & EpisodeID="")!(clcsStr="")) result

	s STX=$c(2)
	s ETX=$c(3)
	s clcsIdStr=""
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s icucriIdStr="",maxQtyStr="",minQtyStr="",avgQtyStr="",icucriIdPos=""
	;w "ifDefault++++++++++++++"_ifDefault,!
	;k ^Lynt
	s sofaCVSPos=0
	f i=1:1:$l(clcsStr,"^")  d //建立评分项对常用医嘱的映射关系
		.s curStr=$p(clcsStr,"^",i)
		.s clcsId=$p(curStr,"|")
		.q:'$d(^DHCCLC("Score",clcsId))
		.s $p(clcsIdStr,"^",i)=clcsId
		.i $lg(^DHCCLC("Score",clcsId),3)="C" d
			..s $p(minQtyStr,"^",i)=$p(curStr,"|",2)
			..s $p(maxQtyStr,"^",i)=$p(curStr,"|",3)
			..i $p(curStr,"|",3)="" s $p(maxQtyStr,"^",i)=$p(curStr,"|",2)
		.i $lg(^DHCCLC("Score",clcsId),3)="S" d
			..q:$p(curStr,"|",2)=""
			..
		.i $lg(^DHCCLC("Score",clcsId),1)="SOFAHypotension" s sofaCVSPos=i
		.;q:$lg(^DHCCLC("Score",clcsId),10)'=""
		.s $p(icucriIdStr,"^",i)=##class(web.DHCICUCom).GetIcuriIdByCode($lg(^DHCCLC("Score",clcsId),9))
		.q:$p(icucriIdStr,"^",i)=""
		.s icucriIdPos($p(icucriIdStr,"^",i))=i
	w "clcsStr:"_clcsStr_"/"_minQtyStr_"/"_maxQtyStr,!
	w icucriIdStr,!
	s qtyDataOptionId="",propertyId="",isFind=0
	f  s propertyId=$o(^DHCICUC("Property",propertyId)) q:(propertyId="")!(isFind)  d
		.i $lg(^DHCICUC("Property",propertyId),1)="QtyDataOption" s qtyDataOptionId=propertyId,isFind=1
	s wardLocId=$p($g(^PAWARD(+$p(^DHCICUArrange(+icuaId),"^",4))),"^",5)
	s icupId=$o(^DHCICUPara(0,"Ctloc",+wardLocId,""))
	i icupId>0,qtyDataOptionId>0 d //根据选项计算值的列表
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..q:$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)=""
			..s icupidSub=0
			..f  s icupidSub=$o(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...q:+^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)'=qtyDataOptionId
				...s qtyDataOptionList($p(^DHCICUPara(icupId,"I",icupiSub),"^",4))=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",2)
	
	s sofaCVSDoseSpeedIcucriId=$g(^DHCCLSet("ICU","DoseSpeedIcucriId"))
	s maxNESpeed=0,maxEpiSpeed=0,maxDASpeed=0,maxDobuSpeed=0
	s neIcupiId="",epiIcupiId="",daIcupiId="",dobuIcupiId=""
	s patWeight=$p(^DHCICUArrange(+icuaId),"^",25)
	
	i icuaId>0 s EpisodeID=+^DHCICUArrange(+icuaId)
	w "EpisodeID="_EpisodeID_"++++++++++++++",!
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	f i=1:1:$l(clcsIdStr,"^") d //lab result
		.s clcsId=$p(clcsIdStr,"^",i)
		.q:'$d(^DHCCLC("Score",clcsId))
		.s standardCode=$lg(^DHCCLC("Score",clcsId),10)
		.q:standardCode=""
		.s tmpIcucriId="",preQtyValue=0
		.s clcsComOrdCode=$lg(^DHCCLC("Score",clcsId),9) // 常用医嘱Code
		.i clcsComOrdCode'="" s tmpIcucriId=$o(^DHCICUC("RecordItem",0,"Code",clcsComOrdCode,"")) //常用医嘱ID
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.i scoreCode="CAUTIUC" d //返回检验结果，根据检验号获取医嘱时间，改变其他值查询日期范围(尿培养CAUTI发生率)
			..s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standardCode, startDate, startTime, endDate, endTime,0,"SP131^SP26^SP132^SP72","Last")
			..w "testRetStr"_regNo_"\"_standardCode_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_testRetStr,!
			..f z=1:1:$l(testRetStr,ETX) d
				...s testStr=$p(testRetStr,ETX,z)
				...;q:$p(testStr,STX)=""
				...s testValue=$p(testStr,STX)
				...s labNo=$p(testStr,STX,9)
				...s clcsoSub=""
				...f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
					....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
					....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
					....i (testValue="")&&(scoreDesc="无") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....w testValue_"/"_clcsId_"/"_tmpIcucriId_"/"_scoreDesc_"/"_qtyValue,!
						.....s $p(result,"^",i)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
					....e  i (testValue["无细菌生长")&&(scoreDesc="无致病菌") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....s $p(result,"^",i)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
					....e  i (testValue'="")&&(testValue'["无细菌生长")&&(scoreDesc="有致病菌生长") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....w testValue_"/"_clcsId_"/"_tmpIcucriId_"/"_scoreDesc_"/"_qtyValue,!
						.....s $p(result,"^",i)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue				
				...q:labNo=""
				...s oeordStr=##class(web.DHCClinicCom).GetOEORDStrByLabNo(labNo,"")
				...i oeordStr'="" d
					....s oeoriSttDat=$p(oeordStr,"^",2)
					....s oeoriSttTim=$p(oeordStr,"^",3) 
					....s startDate=oeoriSttDat,endDate=oeoriSttDat+1
		
		.e  i scoreCode="ISTrain" d //相关培养（感染评分）	
			..s firstTestRet="",firstTestDate=0,firstTestTime=0
			..s standCodeStr="CUL322^CUL2609^CUL5056^CUL5135^CUL310^CUL311^CUL323^CUL2610^CUL5055^CUL5134^CUL4366"
			..s standCodeStr=standCodeStr_"^"_"IDT1^IDT2" //微生物鉴定(细菌涂片、真菌培养、尿培养)
			..s standCodeStr=standCodeStr_"^"_"CUL1729"  //结核/真菌瓶(全自动化真菌培养)
			..//血需氧、厌氧，尿、痰培养，引流、积液培养			
			..f x=1:1:$l(standCodeStr,"^") d				
				...s standCode=$p(standCodeStr,"^",x)
				...s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standCode, startDate, startTime, endDate, endTime,0,"SP128^SP129^SP130^SP215^SP258^SP226^SP48^SP271^SP232^SP243^SP127^SP14^SP131^SP132^SP133^SP134^SP24^SP26^SP61^SP72^SP73^SP99^SP131^SP132^SP133^SP134^SP24^SP26^SP61^SP72^SP73^SP99^SP103^SP104","FirstDT")
				...s testValue=$p(testRetStr,STX)
				...q:testValue=""
				...s receiveDate=$p(testRetStr,STX,4)
				...s receiveTime=$p(testRetStr,STX,5)
				...i firstTestDate=0 s firstTestDate=receiveDate,firstTestTime=receiveTime
				...q:firstTestDate<receiveDate 
				...q:(firstTestDate=receiveDate)&&(firstTestTime<receiveTime)
				...s firstTestDate=receiveDate,firstTestTime=receiveTime
				...s firstTestRet=testRetStr
			..w "firstTestRet:"_firstTestRet,!			
			..s testValue=$p(firstTestRet,STX)	
			..s labNo=$p(firstTestRet,STX,9)
			..s receiveDate=$p(firstTestRet,STX,4)
			..s receiveTime=$p(firstTestRet,STX,5)
			..s clcsoSub=""
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
				...s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...i (testValue="")&&(scoreDesc="未培养") d
					....;w testValue_"/"_clcsId_"/"_tmpIcucriId_"/"_scoreDesc_"/"_qtyValue,!
					....s $p(result,"^",i)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...e  i (testValue'="")&&(scoreDesc="培养") d
					....s $p(result,"^",i)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
					....s startDate=receiveDate-2,startTime=receiveTime, endDate=receiveDate+2, endTime=receiveTime

		.e  d
			..s testQtyStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standardCode, startDate, startTime, endDate, endTime)
		
			..//w standardCode_"\"_testQtyStr,!
			..f j=1:1:$l(testQtyStr,ETX) d
				...s testQty=$p(testQtyStr,ETX,j)
				...q:testQty=""
				...q:$p(testQtyStr,STX)=""
				...s testQty=+testQty
				...//w "testQty="_testQty_"\"_$p(maxQtyStr,"^",i),!
				...i ($p(maxQtyStr,"^",i)="")!(testQty>$p(maxQtyStr,"^",i)) s $p(maxQtyStr,"^",i)=testQty
				...i ($p(minQtyStr,"^",i)="")!(testQty<$p(minQtyStr,"^",i)) s $p(minQtyStr,"^",i)=testQty
	s avgQtyNum=""
	s orderTime=0
	f orderDate=startDate:1:endDate  d //提取重症监护数据计算最大最小值
		.f  s orderTime=$o(^DHCICUOrder(0,"SttDateTime",orderDate,+icuaId,orderTime)) q:(orderTime="")  d
			..q:((orderDate=startDate)&(orderTime'>startTime))
			..q:((orderDate=endDate)&(orderTime>endTime))
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",orderDate,+icuaId,orderTime,icuoId)) q:(icuoId="")  d
				...s icucriId=$p($g(^DHCICUOrder(icuoId)),"^",2)
				...q:icucriId=""
				...q:(("^"_icucriIdStr_"^"_sofaCVSDoseSpeedIcucriId_"^")'[("^"_icucriId_"^"))
				...//w "开始"_icucriIdStr_"/"_icucriId,!
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...//w icucriId,"\",icuoId,!
				...i sofaCVSPos>0,patWeight>0,icucriId=sofaCVSDoseSpeedIcucriId d //另外计算sofa药物
					....s curSpeedDose=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,patWeight,"",1)
					....//w icuoId_" icuoId,"_$p(^DHCICUOrder(icuoId),"^",38),"\"_$p(^DHCICUOrder(icuoId),"^",19)_"\"_curSpeedDose_"\"_patWeight,!
					....i neIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxNESpeed<curSpeedDose s maxNESpeed=curSpeedDose
					....i epiIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxEpiSpeed<curSpeedDose s maxEpiSpeed=curSpeedDose
					....i daIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxDASpeed<curSpeedDose s maxDASpeed=curSpeedDose
					....i dobuIcupiId=$p(^DHCICUOrder(icuoId),"^",38) d
						.....i maxDobuSpeed<curSpeedDose s maxDobuSpeed=curSpeedDose
					....//w maxNESpeed_"\"_maxEpiSpeed_"\"_maxDASpeed_"\"_maxDobuSpeed,!
				...s pos=$g(icucriIdPos(icucriId))
				...q:(pos="")
				...s strategy=$lg(^DHCCLC("Score",$p(clcsIdStr,"^",pos)),11)
				...s baseIcucriId=$lg(^DHCCLC("Score",+$p(clcsIdStr,"^",pos)),12)
				...s baseValue=$lg(^DHCCLC("Score",$p(clcsIdStr,"^",pos)),13)
				...s ifQuit=0
				...i (baseIcucriId'="")&(baseValue'="") d
					....s baseIcuoId="",ifQuit=1
					....f  s baseIcuoId=$o(^DHCICUOrder(0,"RecordItem",baseIcucriId,orderDate,+icuaId,orderTime,baseIcuoId)) q:baseIcuoId=""  d
						.....q:'$d(^DHCICUOrder(baseIcuoId))
						.....q:"ICD"[$p(^DHCICUOrder(baseIcuoId),"^",25)
						.....//i baseValue="Arterial" w icuoId,"\",baseIcuoId,!
						.....i $p(^DHCICUOrder(baseIcuoId),"^",10)=baseValue s ifQuit=0
				...q:ifQuit
				...s icuoQty=$p($g(^DHCICUOrder(icuoId)),"^",11)
				...s icuoNote=$p(^DHCICUOrder(icuoId),"^",10)
				...i $d(qtyDataOptionList(icucriId))>0 d //按选项调整
					....s icucriOptions=$p(^DHCICUC("RecordItem",icucriId),"^",11)
					....s optionPos=0
					....//w icuoNote,"\"_icucriOptions
					....f j=1:1:$l(icucriOptions,";") d
						.....i $p(icucriOptions,";",j)=icuoNote d
							......s icuoQty=$p(qtyDataOptionList(icucriId),";",j)
				...//w icucriId_"\"_icuoQty,"\"_maxQtyStr_"\"_icuoId,!
				...i strategy="S" d //总和
					....//w "icuoQty="_icuoQty,!
					....s $p(maxQtyStr,"^",pos)=$p(maxQtyStr,"^",pos)+icuoQty
					....s $p(minQtyStr,"^",pos)=$p(minQtyStr,"^",pos)+icuoQty
				...i strategy="A" d //平均值		
					....s $p(maxQtyStr,"^",pos)=$p(maxQtyStr,"^",pos)+icuoQty
					....s $p(minQtyStr,"^",pos)=$p(minQtyStr,"^",pos)+icuoQty
					....i icuoQty>0 d 
						.....s $p(avgQtyNum,"^",pos)=$p(avgQtyNum,"^",pos)+1
						.....s $p(avgQtyStr,"^",pos)=$FN(($p(maxQtyStr,"^",pos)/$p(avgQtyNum,"^",pos)),"",2)
						.....w icuoQty_" avg\"_avgQtyStr_"/"_icuoId,!						
				...q:(strategy="S")||(strategy="A")
				...i ($p(maxQtyStr,"^",pos)="")!(icuoQty>$p(maxQtyStr,"^",pos)) d
					....s $p(maxQtyStr,"^",pos)=icuoQty
					....s maxOptionNoteList(icucriId)=icuoNote
					....w icuoQty_" max\"_maxQtyStr,"/"_icuoId,"/"_maxOptionNoteList(icucriId),!
				...i ($p(minQtyStr,"^",pos)="")!(icuoQty<$p(minQtyStr,"^",pos)) d
					....s $p(minQtyStr,"^",pos)=icuoQty
					....s minOptionNoteList(icucriId)=icuoNote
					....w icuoQty_" min\"_minQtyStr,"/"_icuoId,"/"_minOptionNoteList(icucriId),!
				...;i icucriId=5971 w "结果："_icucriId_"/"_maxQtyStr_"/"_minQtyStr,!
	//w maxQtyStr_" max/min ",!
	//w minQtyStr,!
	f i=1:1:$l(clcsIdStr,"^")  d
		.s clcsId=$p(clcsIdStr,"^",i)
		.q:'$d(^DHCCLC("Score",clcsId))
		.s icucriId=$p(icucriIdStr,"^",i)		
		.i $lg(^DHCCLC("Score",clcsId),3)="S" d //计算传入的选项值
			..s curStr=$p(clcsStr,"^",i)
			..//w "select:  curStr="_curStr,!
			..q:$p(curStr,"|",2)=""
			..s curValue=$p(curStr,"|",2)
			..s clcsoSub="",curScore=""
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...//w $lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)_"/"_curValue,!
				...i $lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)=curValue s curScore=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
			..//w curValue_"  curScore="_curScore,!
			..q:curScore=""
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_curScore
			..//w result,!
		.;q:($lg(^DHCCLC("Score",clcsId),3)'="C")&(i'=sofaCVSPos)&($d(qtyDataOptionList(+icucriId))=0)
		.q:$p(maxQtyStr,"^",i)=""
		.;w maxQtyStr,"\"_minQtyStr,!
		.;w clcsIdStr_"/"_clcsId_"/"_i,!
		.s clcsoSub="",maxQtyValue="",minQtyValue="",avgQtyValue=""
		.f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
			..s minValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),3)
			..s maxValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),4)
			..i ($p(minQtyStr,"^",i)'<minValue)&($p(minQtyStr,"^",i)'>maxValue) d
				...s minQtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...w clcsId_"/"_$p(minQtyStr,"^",i)_"minQtyValue="_minQtyValue,!
			..i ($p(maxQtyStr,"^",i)'<minValue)&($p(maxQtyStr,"^",i)'>maxValue) d
				...s maxQtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...w clcsId_"/"_$p(maxQtyStr,"^",i)_"maxQtyValue="_maxQtyValue,!
			..i ($p(avgQtyStr,"^",i)'<minValue)&($p(avgQtyStr,"^",i)'>maxValue) d
				...s avgQtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...w clcsId_"/"_$p(avgQtyStr,"^",i)_"avgQtyValue="_avgQtyValue,!
		.i $lg(^DHCCLC("Score",clcsId),11)="A" d //平均值
			..q:avgQtyValue=""
			..s curValue=$p(avgQtyStr,"^",i)
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_avgQtyValue
		.q:$lg(^DHCCLC("Score",clcsId),11)="A"
		.w maxQtyValue,"\"_minQtyValue,!
		.i maxQtyValue>minQtyValue d
			..q:maxQtyValue=""
			..s curValue=$p(maxQtyStr,"^",i)
			..i icucriId'="",$d(qtyDataOptionList(icucriId))>0 s curValue=$g(maxOptionNoteList(icucriId))
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_maxQtyValue
		.e  d
			..q:minQtyValue=""
			..s curValue=$p(minQtyStr,"^",i)
			..i icucriId'="",$d(qtyDataOptionList(icucriId))>0 s curValue=$g(minOptionNoteList(icucriId))
			..s $p(result,"^",i)=clcsId_"|"_icucriId_"|"_curValue_"|"_minQtyValue
	//w "~~~"_result_"~~~",!
	
	//w "###"_result_"###",!,!
	w "@@@ "_clcsIdStr_" @@@",!
	s zbjWZXStr="",zbjDGXStr="",zbjIfEqual=0 //致病菌
	s yxWZXStr="",yxDGXStr=""	//外周血、导管血阳性

	f j=1:1:$l(clcsIdStr,"^") d
		.s clcsId=$p(clcsIdStr,"^",j)
		.q:clcsId=""
		.s scoreCode=$lg($g(^DHCCLC("Score",clcsId)),1)
		.q:scoreCode=""
		.s tmpIcucriId=""
		.s clcsComOrdCode=$lg(^DHCCLC("Score",clcsId),9) // 常用医嘱Code
		.i clcsComOrdCode'="" s tmpIcucriId=$o(^DHCICUC("RecordItem",0,"Code",clcsComOrdCode,"")) //常用医嘱ID
		.w "?????????????",!
		.i "VAPSecretion"=scoreCode d //分泌物(VAP发生率)
			..s secretion=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"SputumSuctionVol",startDate,startTime,endDate,endTime,"")
			..w "secretion:"_secretion,!
			..s clcsoSub="",preQtyValue=0
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
				...s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...i ((secretion["少量")||(secretion=""))&&(scoreDesc["少量") d	
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue				
					....s $p(result,"^",j)=$p(clcsIdStr,"^",j)_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...i ((secretion["中量")||(secretion["大量"))&&(scoreDesc="中大量非脓性") d					
					....s secondSecretion=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"SputumProperty",startDate,startTime,endDate,endTime,"")
					....q:secondSecretion=""
					....w "secondSecretion"_secondSecretion,!
					....i (secondSecretion="非脓性") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue	
						.....s $p(result,"^",j)=$p(clcsIdStr,"^",j)_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...i ((secretion["中量")||(secretion["大量"))&&(scoreDesc="中大量脓性") d					
					....s secondSecretion=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"SputumProperty",startDate,startTime,endDate,endTime,"")
					....q:secondSecretion=""
					....w "secondSecretion"_secondSecretion,!
					....i (secondSecretion="脓性") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue	
						.....s $p(result,"^",j)=$p(clcsIdStr,"^",j)_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
			..;w "VAPSecretion score="_secretion_"/"_secondSecretion_"/"_qtyValue,!
			..//s $p(scoreValueList,"^",j)=clcsId_"||"_age_"|"_qtyValue
			..;s $p(result,"^",j)=$p(clcsIdStr,"^",j)_"|"_tmpIcucriId_"|"_secretion_"|"_qtyValue
		.i "VAPSputumCul"=scoreCode d //痰培养(VAP发生率)
			..s standardCode=$lg(^DHCCLC("Score",clcsId),10)
			..q:standardCode=""
			..s tmpStartDate=endDate-3
			..s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standardCode, tmpStartDate, startTime, endDate, endTime,0,"SP14^SP255^SP256^SP257^SP272","touchQty")
			..s testValueList="",preQtyValue=0
			..;w "testRetStr"_regNo_"\"_standardCode_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_testRetStr,!
			..f k=1:1:$l(testRetStr,ETX) d
				...s testStr=$p(testRetStr,ETX,k)
				...q:$p(testStr,STX)=""
				...s testValue=$p(testStr,STX)
				...f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
					....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
					....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
					....i (testValue["无菌生长")&&(scoreDesc="无致病菌") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
					....e  i (testValue'["无菌生长")&&("^"_testValueList_"^"'[testValue)&&(scoreDesc="有致病菌生长") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....;w testValue_"/"_testValueList_"/"_scoreDesc,!
						.....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
					....e  i (testValue'["无菌生长")&&("^"_testValueList_"^"[testValue)&&(scoreDesc="多次培养") d
						.....q:(preQtyValue>qtyValue)
						.....s preQtyValue=qtyValue
						.....;w testValue_"/"_testValueList_"/"_scoreDesc,!	
						.....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...s testValueList=testValueList_testValue
				...s testValueList=testValueList_"^"
				...;i ($p(maxQtyStr,"^",i)="")!(testQty>$p(maxQtyStr,"^",i)) s $p(maxQtyStr,"^",i)=testQty
				...;i ($p(minQtyStr,"^",i)="")!(testQty<$p(minQtyStr,"^",i)) s $p(minQtyStr,"^",i)=testQty
		.i ("CIPB"=scoreCode) d //外周血(导管感染发生率)
			..
			..s testWZXStr=""
			..s standCodeStr="CUL322^CUL2609^CUL5056^CUL5135^CUL310^CUL311^CUL323^CUL2610^CUL5055^CUL5134^CUL4366"
			..//外周血需氧、厌氧
			..f v=1:1:$l(standCodeStr,"^") d
				...s standCode=$p(standCodeStr,"^",v)
				...s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standCode, startDate, startTime, endDate, endTime,0,"SP127","touchQty")
				...i (testWZXStr="")&&(testRetStr'="") s testWZXStr =testRetStr
				...e  i (testWZXStr'="")&&(testRetStr'="") s testWZXStr =testWZXStr_"^"_testRetStr
				...;w "testWZXStr"_regNo_"\"_standCode_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_testRetStr,!
				...;w "testStr"_testWZXStr,!
			..s preQtyValue=0
			..i testWZXStr'="" d
				...f b=1:1:$l(testWZXStr,ETX) d
					....s testStr=$p(testWZXStr,ETX,b)
					....q:$p(testStr,STX)=""
					....s testValue=$p(testStr,STX)
					....s labNo=$p(testStr,STX,9)
					....s clcsoSub=""
					....f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
						.....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
						.....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
						.....i (testValue["阳性")&&(scoreDesc="阳性") d
							......s zbjWZXRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", "IDT1", startDate, startTime, endDate, endTime,0,"SP127","",labNo) 
							......;s zbjWZXRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", "IDT1", startDate, startTime, endDate, endTime,0,"SP127","touchQty") 
							......;w "zbjWZXRetStr"_zbjWZXRetStr,!
							......f c=1:1:$l(zbjWZXRetStr,ETX) d
								.......s zbjRet=$p(zbjWZXRetStr,ETX,c)
								.......q:$p(zbjRet,STX)=""
								.......s zbjValue=$p(zbjRet,STX)					
								.......i zbjValue'="" d
								........i zbjWZXStr="" s zbjWZXStr=zbjValue
								........e  s zbjWZXStr=zbjWZXStr_ETX_zbjValue
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......q:"CIPB"'=scoreCode
							......i yxWZXStr="" s yxWZXStr=testValue
							......e  s yxWZXStr=yxWZXStr_ETX_testValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
						.....e  i (testValue["阴性")&&(scoreDesc="阴性") d 
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......q:"CIPB"'=scoreCode
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
		.i ("CICB"=scoreCode) d  //导管血(导管感染发生率)	
			..s testDGXStr=""
			..s standCodeStr="CUL322^CUL2609^CUL5056^CUL5135^CUL310^CUL311^CUL323^CUL2610^CUL5055^CUL5134^CUL4366"
			..//导管血需氧、厌氧			
			..f x=1:1:$l(standCodeStr,"^") d
				...s standCode=$p(standCodeStr,"^",x)
				...s testRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standCode, startDate, startTime, endDate, endTime,0,"SP128^SP129^SP130^SP215^SP258^SP226^SP48^SP271^SP232^SP243","touchQty")
				...i (testDGXStr="")&&(testRetStr'="") s testDGXStr =testRetStr
				...e  i (testDGXStr'="")&&(testRetStr'="") s testDGXStr =testDGXStr_ETX_testRetStr
				...;w "testDGXStr"_regNo_"\"_standCode_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_testRetStr,!
				...;w "testStr"_testDGXStr,!
			..s preQtyValue=0
			..i testDGXStr'="" d
				...f y=1:1:$l(testDGXStr,ETX) d
					....s testStr=$p(testDGXStr,ETX,y)
					....q:$p(testStr,STX)=""
					....s testValue=$p(testStr,STX)
					....s labNo=$p(testStr,STX,9)
					....s clcsoSub=""
					....f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
						.....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
						.....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
						.....i (testValue["阳性")&&(scoreDesc="阳性") d 
							......s zbjDGXRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", "IDT1", startDate, startTime, endDate, endTime,0,"SP128^SP129^SP130^SP215^SP258^SP226^SP48^SP271^SP232^SP243","touchQty",labNo) 
							......;s zbjDGXRetStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", "IDT1", startDate, startTime, endDate, endTime,0,"SP128^SP129^SP130^SP215^SP258^SP226^SP48^SP271^SP232^SP243","touchQty") 
							......;w "zbjDGXRetStr"_zbjDGXRetStr,!
							......f z=1:1:$l(zbjDGXRetStr,ETX) d
								.......s zbjRet=$p(zbjDGXRetStr,ETX,z)
								.......q:$p(zbjRet,STX)=""
								.......s zbjValue=$p(zbjRet,STX)					
								.......i zbjValue'="" d
								........i zbjDGXStr="" s zbjDGXStr= zbjValue
								........e  s zbjDGXStr= zbjDGXStr_ETX_zbjValue
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......q:"CICB"'=scoreCode
							......i yxDGXStr="" s yxDGXStr=testValue
							......e  s yxDGXStr=yxDGXStr_ETX_testValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
						.....e  i (testValue["阴性")&&(scoreDesc="阴性") d 
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......q:"CICB"'=scoreCode
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
			..;w "result:"_result,!
		.i ("CIXTZBJ"=scoreCode) d  //相同致病菌(导管感染发生率)
			..w "zbjWZXStr"_zbjWZXStr,!
			..w "zbjDGXStr"_zbjDGXStr,!
			..s preQtyValue=0
			..f k=1:1:$l(zbjWZXStr,ETX) d
				...s zbjWZX=$p(zbjWZXStr,ETX,k)
				...q:zbjWZX=""
				...f l=1:1:$l(zbjDGXStr,ETX) d
					....s zbjDGX=$p(zbjDGXStr,ETX,l)
					....q:zbjDGX=""
					....s clcsoSub=""
					....;w zbjWZX_"/"_zbjDGX,!
					....f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
						.....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
						.....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
						.....i (zbjWZX=zbjDGX)&&(scoreDesc="相同") d
							......s zbjIfEqual=1
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
						.....e  i (zbjWZX'=zbjDGX)&&(scoreDesc="不同") d
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
		.i ("CIWZXDYDGX2h"=scoreCode) d //外周血大于导管血2h(导管感染发生率)
			..q:zbjIfEqual=0
			..s preQtyValue=0
			..f t=1:1:$l(yxWZXStr,ETX) d
				...s yxWZXValue=$p(yxWZXStr,ETX,t) 
				...s yxWZXValue=$p(yxWZXValue,"小时",1)
				...i yxWZXValue'=+yxWZXValue s yxWZXValue=+yxWZXValue 
				...f h=1:1:$l(yxDGXStr,ETX) d
					....s yxDGXValue=$p(yxDGXStr,ETX,h) 
					....s yxWZXValue=$p(yxWZXValue,"小时",1)
					....i yxDGXValue'=+yxDGXValue s yxDGXValue=+yxDGXValue
					....s yxscoreValue=(yxWZXValue-yxDGXValue)
					....;w zbjWZX_"/"_zbjDGX,!
					....s clcsoSub=""					
					....f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
						.....s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
						.....s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
						.....i (yxscoreValue>2)&&(scoreDesc="大于") d
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
						.....e  i (yxscoreValue'>2)&&(scoreDesc="不大于") d
							......q:(preQtyValue>qtyValue)
							......s preQtyValue=qtyValue
							......s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue	
		.i ("ISAntibiotics"=scoreCode) d //抗生素(感染性休克)
			..s preQtyValue=0
			..s antibioticsStr=##class(web.DHCICUStat).GetVasoactiveAgents(icuaId,"",startDate,endDate,"KSS3^KSS2")
			..s clcsoSub=""					
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
				...s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...i (antibioticsStr=1)&&(scoreDesc="治疗") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...e  i (antibioticsStr=0)&&(scoreDesc="未治疗") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue		
		.i ("ISSepsis"=scoreCode) d //Sepsis评分(感染性休克)
			..s preQtyValue=0
			..w "ISSepsis:"_icuaId_"\"_startDate_"\"_startTime_"\"_endDate_"\"_endTime_"\"_wardLocId,!
			..s recordValueStr=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"SOFATotal",startDate,startTime,endDate,endTime,"touchQty","","","","","","","","2")
			..w "结果ISSepsis:"_recordValue,!

		.i ("ISNoradrenaline"=scoreCode) d //应用去甲肾上腺素(感染性休克)
			..s preQtyValue=0
			..s recordValue=##class(web.DHCICUOrder).GetRecordValue(+icuaId,"DetailDosePump",startDate,startTime,endDate,endTime,"First","","","去甲肾上腺素")	
			..w "结果ISNoradrenaline:"_recordValue,!
			..s clcsoSub=""								
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
				...s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...i (recordValue'="")&&(scoreDesc="应用") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...e  i (recordValue="")&&(scoreDesc="未应用") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
		.i ("PODVTDrugOrAppara"=scoreCode) d //药品或者器械应用(深静脉血栓预防率)
			..s preQtyValue=0
			..s arcimIdStr="2060||1^2215||1^1173||1^1960||1^1961||1^2049||1^1924||1^1926||1^32544||1^34560||1^34576||1^894||1^916||1^615||1^36836||1"
			..s arcimIdStr=arcimIdStr_"^"_"17125||1^17126||1^2971||1"
			..s ordRetStr=##class(web.DHCICUStat).GetVasoactiveAgents(icuaId,"",startDate,endDate,"",arcimIdStr)	
			..s clcsoSub=""					
			..f  s clcsoSub=$o(^DHCCLC("Score",clcsId,"O",clcsoSub)) q:clcsoSub=""  d
				...s scoreDesc=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),2)
				...s qtyValue=$lg(^DHCCLC("Score",clcsId,"O",clcsoSub),5)
				...i (ordRetStr=1)&&(scoreDesc="治疗") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue
				...e  i (ordRetStr=0)&&(scoreDesc="未治疗") d
					....q:(preQtyValue>qtyValue)
					....s preQtyValue=qtyValue
					....s $p(result,"^",j)=clcsId_"|"_tmpIcucriId_"|"_scoreDesc_"|"_qtyValue		
	//f i=1:1:$l(clcsIdStr,"^") d
	s clcslId=0
	f  s clcslId=$o(^DHCCLC("ScoreLink",clcslId)) q:clcslId=""  d
		.q
		.i ("^"_clcsIdStr_"^")[$lg(^DHCCLC("ScoreLink",i),2)
		.f  s clcslId=$o(^DHCCLC("ScoreLink",clcslId)) q:clcslId=""  d
			..s secondClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:secondClcsId=""
			..s clcsIdList(clcsId,secondClcsId)=""
	q result
}

/// 自动插入评分数据
/// 入参：日期、时间
/// startDate:开始日期,startTime:开始时间
/// endDate：评分日期, endTime：评价时间
/// needIcuaId:icuaId
/// needWardLocId:登陆科室
/// needClcsId:评分总分主项 APACHEII,SOFA
/// ancvcId:显示分类代码，APACHEII,SOFA
/// ifPerHour是否每小时执行（非24小时）
ClassMethod AutoAddScoreOrder(startDate, startTime, endDate, endTime, needIcuaId = "", needWardLocId = "", needClcsCode = "", ancvcCode = "", userId = "", ifDebug = 0, ifPerHour = 0) As %String
{
	//w ##class(web.DHCCLScore).AutoAddScoreOrder($h-1,13*3600,$h,13*3600,687,56,26,232,"",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder(63320,50400,63321,50400,2874,56,"APACHEII","APACHEII","",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder(63768,50400,63769,50400,7104,88,"APACHEII","APACHEII","3879",1)
	//w ##class(web.DHCCLScore).AutoAddScoreOrder("2015-05-18","15:00:00","2015-05-18","15:00:00",6113,,38,233,"",1)
	//icucriList(icucriId):待插入数据；icupiSub^cat^value
	//scoreSrcList(scoreCode)评分代码对应源数据icucriId；
	//scoreList(scoreCode)评分代码对应评分值icucriId
	//mainScoreList(layer,clcsId,secondClcsId)主项到从项的树形结构，第一个节点是层
	
	s needClcsId=""
	i needClcsCode'="" d
		.i needClcsCode=+needClcsCode s needClcsId=needClcsCode
	 	.e  s needClcsId=$o(^DHCCLC("Score",0,"Code",needClcsCode,"")) 
	s ancvcId=""
	i ancvcCode'="" d
		.i ancvcCode=+ancvcCode s ancvcId=ancvcCode
		.e  s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	//w needClcsId_"/"_ancvcId,!
	q:(needClcsId="")!(ancvcId="") -1
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	s startDateTime=startDate+((startTime+1)/100000)
	s endDateTime=endDate+((endTime+1)/100000)
	s calDuration=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,endDate,endTime) //计算两个时间的时间差
	k scoreCodeToIdList
	s clcsId=0
	f  s clcsId=$o(^DHCCLC("Score",clcsId)) q:clcsId=""  d
		.q:$lg(^DHCCLC("Score",clcsId),1)=""
		.s scoreCodeToIdList($lg(^DHCCLC("Score",clcsId),1))=clcsId
	i needClcsId="" s clcsIdList(26)=""
	e  s clcsIdList(needClcsId)=""
	//s clcsIdList(38)="" //!!
	i ancvcId="" s ancvcId="232" 
	w clcsIdList(needClcsId),!
	w ancvcId,!
	//s ancvcId="232^233" //!!
	s scoreItemStr=""
	k mainScoreList
	s clcsId=""
	//b
	f  s clcsId=$o(clcsIdList(clcsId)) q:clcsId=""  d  //评分关联项：主项到从项的树形结构
		.s clcslId=""
		.f  s clcslId=$o(^DHCCLC("ScoreLink",0,"M",clcsId,clcslId)) q:clcslId=""  d
			..s secondClcsId=$lg(^DHCCLC("ScoreLink",clcslId),2)
			..q:secondClcsId=""
			..s clcsIdList(clcsId,secondClcsId)=""
			..s mainScoreList(1,clcsId,secondClcsId)="" //，
			..s curIcucriCode=$lg($g(^DHCCLC("Score",secondClcsId)),9)
			..s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
			..w clcsId_","_secondClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",secondClcsId)),1),!
			..s secondClcslId=""
			..f  s secondClcslId=$o(^DHCCLC("ScoreLink",0,"M",secondClcsId,secondClcslId)) q:secondClcslId=""  d
				...s thirdClcsId=$lg(^DHCCLC("ScoreLink",secondClcslId),2)
				...q:thirdClcsId=""
				...q:'$d(^DHCCLC("Score",thirdClcsId))
				...s clcsIdList(clcsId,secondClcsId,thirdClcsId)=""
				...s mainScoreList(2,secondClcsId,thirdClcsId)=""
				...s curIcucriCode=$lg($g(^DHCCLC("Score",thirdClcsId)),9)
				...s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
				...w clcsId_","_secondClcsId_","_thirdClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2)_"\"_$lg($g(^DHCCLC("Score",thirdClcsId)),1),!
				...s thirdClcslId=""
				...f  s thirdClcslId=$o(^DHCCLC("ScoreLink",0,"M",thirdClcsId,thirdClcslId)) q:thirdClcslId=""  d
					....s fourthClcsId=$lg(^DHCCLC("ScoreLink",thirdClcslId),2)
					....q:fourthClcsId=""
					....q:'$d(^DHCCLC("Score",fourthClcsId))
					....s clcsIdList(clcsId,secondClcsId,thirdClcsId,fourthClcsId)=""
					....s curIcucriCode=$lg($g(^DHCCLC("Score",fourthClcsId)),9)
					....s curIcucriId=##class(web.DHCICUCom).GetIcuriIdByCode(curIcucriCode)
					....w clcsId_","_secondClcsId_","_thirdClcsId_","_fourthClcsId_"\"_curIcucriId_","_$p($g(^DHCICUC("RecordItem",+curIcucriId)),"^",2),"\"_$lg($g(^DHCCLC("Score",fourthClcsId)),1),!
					....i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
					....s scoreItemStr=scoreItemStr_fourthClcsId
					....s mainScoreList(3,thirdClcsId,fourthClcsId)=""
				...//q:$d(clcsIdList(clcsId,secondClcsId,thirdClcsId))=11
				...i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
				...s scoreItemStr=scoreItemStr_thirdClcsId
			..q:$d(clcsIdList(clcsId,secondClcsId))=11
			..i scoreItemStr'="" s scoreItemStr=scoreItemStr_"^"
			..s scoreItemStr=scoreItemStr_secondClcsId
	f i=1:1:$l(scoreItemStr,"^") d
		.s clcsId=$p(scoreItemStr,"^",i)
		.q:clcsId=""
		.s $p(scoreCodeStr,"^",i)=$lg(^DHCCLC("Score",clcsId),1)
	w scoreItemStr,!
	w scoreCodeStr,!
	s arfId=$o(^DHCCLC("Score",0,"Code","ARF",""))
	w arfId_"/"_$l(arfId),!
	i ("^"_scoreCodeStr_"^")["^Creatinine(ARF×2)^" s scoreItemStr=scoreItemStr_"^"_arfId //有Apache血清肌酐添加急性肾功能衰竭
	s nbpId=$o(^DHCCLC("Score",0,"Code","NBP",""))
	w nbpId_"/"_$l(nbpId),!
	i ("^"_scoreCodeStr_"^")["^AMBP^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有AMBP时添加NBP
	i ("^"_scoreCodeStr_"^")["^SOFAHypotension^" s scoreItemStr=scoreItemStr_"^"_nbpId //在有SOFAHypotension,加AMBP，加NBP?
	s sofaUrineId=$o(^DHCCLC("Score",0,"Code","SOFAUrine",""))
	w sofaUrineId_"/"_$l(sofaUrineId),!
	i ("^"_scoreCodeStr_"^")["^SOFACreatinineAndUrine^" s scoreItemStr=scoreItemStr_"^"_sofaUrineId //在有肌酐umol/L时添加尿量
	w scoreItemStr,!
	
	//s icucriId=""
	//f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
	//	.q:("^"_ancvcId_"^")'[$p(^DHCICUC("RecordItem",icucriId),"^",5)
	//	.s icucriIdList(icucriId)=""
	//	.w icucriId_","_$p(^DHCICUC("RecordItem",icucriId),"^",2),!
	
	s propertyId="",scoreItemPropertyId="",isScorePropertyId="",affectiveScoreItemId=""
	f  s propertyId=$o(^DHCICUC("Property",propertyId)) q:propertyId=""  d
		.i $lg(^DHCICUC("Property",propertyId),1)="ScoreItemCode" s scoreItemPropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="IsScore" s isScorePropertyId=propertyId
		.i $lg(^DHCICUC("Property",propertyId),1)="AffectiveScoreItemCode" s affectiveScoreItemId=propertyId
	//w scoreItemPropertyId_"\"_isScorePropertyId,!
	w "评分层次>===================================<科室模板",!
	
	s wardCtlocId="",retStr=""
	f  s wardCtlocId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId)) q:wardCtlocId=""  d
		.q:(needWardLocId'="")&(needWardLocId'=wardCtlocId)
		.k paraItemList
		.s icupId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId,""))
		.
		.s icupiSub=""
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
			..s icucriId=$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)
			..//w icupId_"||"_icupiSub,"\"_icucriId,!
			..q:icucriId=""
			..;q:("^"_ancvcId_"^")'[("^"_$p(^DHCICUC("RecordItem",icucriId),"^",5)_"^")
			..q:("^"_ancvcId_"^")'[$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..s icupidSub=0,scoreItemCode="",isScore=0
			..f  s icupidSub=$o(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...i scoreItemPropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) d
					....s scoreItemCode=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",2)
				...i isScorePropertyId=$p(^DHCICUPara(icupId,"I",icupiSub,"D",icupidSub),"^",1) s isScore=1
			..s icucriList(icucriId)=icupiSub_"^"_$p(^DHCICUPara(icupId,"I",icupiSub),"^",11)
			..w icucriId_",=="_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"\"_scoreItemCode,"\",isScore,"\"_icupiSub,!
			..q:scoreItemCode=""
			..s clcsId=$g(scoreCodeToIdList(scoreItemCode))
			..q:clcsId=""
			..i $lg(^DHCCLC("Score",clcsId),6)=1 d
				...s scoreList(scoreItemCode)=icucriId
				...w "    mainScoreList:"_scoreItemCode_":"_icucriId,!
			..e  d 
				...i (isScore=1) d //!!
					....s scoreList(scoreItemCode)=icucriId
					....w "    scoreList:"_scoreItemCode_":"_icucriId,!
				...e  d
					....q:$p(^DHCICUPara(icupId,"I",icupiSub),"^",13)="ApacheFiO2ScoreSource"
					....s scoreSrcList(scoreItemCode)=icucriId
					....w "    scoreSrcList:"_scoreItemCode_":"_icucriId,!
			..i (icupiSub=326) s scoreList(scoreItemCode)=6394
		.w "    curCtlocId="_wardCtlocId,!
		.k wardEpisodeIDList
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",+needWardLocId,0))
		.s EpisodeID=""
		.i needIcuaId'="" s EpisodeID=$p($g(^DHCICUArrange(+needIcuaId)),"^",1)
		.w EpisodeID,!
		.i EpisodeID'="" d
			..s patList=""
			..q:+$p($g(^DHCICUArrange(needIcuaId)),"^",4)'=wardId
			..s patList=EpisodeID_"|||"_needIcuaId
		.e  d
			..s patList=##class(web.DHCICUCom).FindWardPatient("",wardCtlocId) //找当前病区病人
			..w EpisodeID_"/before "_patList,!
			..s searchDate=startDate-1 //查前一天病人和当天病人，考虑到转入时间与监护时间可能跨天
			..f  s searchDate=$o(^DHCICUOrder(0,"SttDateTime",searchDate)) q:(searchDate="")!(searchDate-1>startDate)  d
				...w searchDate,!
				...s icuaId=""
				...f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",searchDate,icuaId)) q:icuaId=""  d //当天来当天走的？
					....q:'$d(^DHCICUArrange(icuaId))
					....q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
					....s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
					....q:outDateTime=""
					....s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
					....q:outDate<startDate
					....s curEpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
					....q:curEpisodeID=""
					....q:("^"_patList_"|")[("^"_curEpisodeID_"|")
					....w icuaId_"\"_curEpisodeID_"\"_$zd(outDate,3)_"\"_$zt(outTime),!
					....s patList=patList_"^"_curEpisodeID_"|||"_icuaId
		.
		.w EpisodeID_"/patientList:== "_patList,!
		.s scoreStartDate=startDate
		.s scoreStartTime=startTime
		.s scoreEndDate=endDate
		.s scoreEndTime=endTime
		.f i=1:1:$l(patList,"^") d
			..s EpisodeID=+$p(patList,"^",i)
			..q:EpisodeID=0
			..s wardEpisodeIDList(EpisodeID)=""
			..s orderParaList=""
			..s icuaId=$p($p(patList,"^",i),"|",4)
			..q:icuaId=""
			..//s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
			..//q:'$d(transWardList) 	//没有转病区记录
			..//s dateTime=$o(transWardList(endDateTime),-1)
			..//q:dateTime=""
			..//w " "_transWardList(dateTime),!
			..//q:(needWardLocId'="")&(transWardList(dateTime)'=wardId)
			..//s inTime=(dateTime-$p(dateTime,"."))*100000
			..////s inDateTime=##class(web.DHCANOPCom).GetWardInDateTime(EpisodeID, startDate, startTime," ") //找入病区时间
			..////q:+inDateTime=0
			..////s inTime=##class(web.DHCANOPCom).ConvertToTimeH($p(inDateTime," ",2))
			..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			..s inDate=+inDateTime,inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
			..w EpisodeID_" inDatTeime:",inDate_"/"_inTime," endTime:",endTime_","_startDate_"/"_startTime,!
			..q:('ifPerHour)&&((inDate>startDate)!((inDate=startDate)&((inTime\3600*3600)>startTime)))
			..q:(endDate>$h)!((endDate=+$h)&(endTime>$p($h,",",2)))
			..q:('ifPerHour)&&((inTime\3600)'=(endTime\3600)) //与入参时间不匹配则不插入
			..q:(ifPerHour)&&((inDate>endDate)!((inDate=endDate)&((inTime\3600*3600)>(endTime\3600*3600))))	
			..i (ifPerHour)&&((inDate=startDate)&&((inTime\3600*3600)>startTime)) d
				...s scoreStartDate=startDate,scoreStartTime=(inTime\3600*3600)
			..e  i (ifPerHour)&&((inDate=endDate)&&((inTime\3600*3600)<(endTime\3600*3600))) d
				...s scoreStartDate=endDate,scoreStartTime=(inTime\3600*3600)
			..e  d
				...s scoreStartDate=startDate,scoreStartTime=startTime		
			..//s icuaId=##class(web.DHCICUCom).GetIcuaId(EpisodeID, "", "", "Y", "N", "", "", endDate, endTime)
			..w "intime mathed icuaId=="_icuaId,!
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..w " have outTime? outTime="_outDateTime
			..q:(inDate="")&(outDateTime="")
			..s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
			..i outDate=0 s outDate=+$h,outTime=$p($h,",",2)
			..w " outDate<startDate?e "_startDate,!
			..q:outDate<startDate
			..q:(ifPerHour)&&((outDate=endDate)&&((outTime\3600*3600)<(endTime\3600*3600)))
			..w "DateTime:"_" inDatTeime:",inDate_"/"_inTime," outDateTime:",outDate_"/"_outTime_","_startDate_"/"_startTime_","_scoreStartDate_"/"_scoreStartTime,!
			..w "  needIcuaId?",!
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..w " start Create"
			..;===========同步数据之前============
			..s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),EpisodeID,"Before")="Apache："_preApacheII
			..
			..s retStr=$$CreateScoreData
			..;===========同步数据之后============
			..s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),EpisodeID,"After")="Apache："_afterApacheII
			..
			..w "retStr="_retStr,!
		.q:(needClcsId'="")&(needClcsId'=26)&(needClcsId'=38)
		.
		.w "             ============= Start trans and disch",!
		.s icuaId=""
		.w startDate_"///////////////////"
		.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId)) q:icuaId=""  d //当天来当天走的？
			..q:'$d(^DHCICUArrange(icuaId))
			..w "icuaId="_icuaId,!
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..w "wardId:"_wardId,!
			..q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
			..s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
			..q:EpisodeID=""
			..w "leave:EpisodeID="_EpisodeID
			..q:'$d(^PAADM(EpisodeID))
			..s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			..s paadmWardId=$p($g(^PAADM(EpisodeID)),"^",20)
			..w "/  "_needIcuaId_"/"_$d(wardEpisodeIDList(EpisodeID))
			..q:(paadmVisitStatus'="D")&(needIcuaId'="")&(paadmWardId=+$p(^DHCICUArrange(icuaId),"^",4))
			..//q:(needIcuaId'="")&($d(wardEpisodeIDList(EpisodeID)))
			..w icuaId_"/"_$p($g(^DHCICUArrange(icuaId)),"^",4),!
			..s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
			..q:'$d(transWardList) 	//没有转病区记录
			..//w "trans:"
			..
			..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			..s inDate=+inDateTime,inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
			..
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..q:outDateTime=""
			..s outDate=+outDateTime,outTime=$p(outDateTime,"^",2)
			..w startDate,"/"_endDate_"/"_inDate_"/"_inTime_"/"_outDate_"/"_outTime,!
			..q:(ifPerHour)&&((outDate=endDate)&&((outTime\3600*3600)<(endTime\3600*3600)))
			..q:endDate>outDate
			..q:outDate<startDate
			..s outDateTime=outDate+(outTime/100000)
			..//w "inDate="_inDate_"/"_startDate_"/"_scoreEndTime_"/"_inTime,!
			..i (inDate=startDate)&(startTime=((inTime\3600)*3600)) d //未满一天的病人
				...q:##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,outDate,outTime,"H")>24
				...s scoreEndDate=outDate,scoreEndTime=outTime
				...s orderParaList=""
				...;===========同步数据之前============
				...s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
				...i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"InOneDay","Before")="未满一天的病人 Apache："_preApacheII
				...
				...s retStr=$$CreateScoreData
				...;===========同步数据之后============
				...s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
				...i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"InOneDay","After")="未满一天的病人 Apache："_afterApacheII
			..
			..//s preEndTime=endTime-3600
			..//s preEndDate=endDate
			..//i preEndTime<0 s preEndTime=0,preEndDate=preEndDate-1
			..//s preEndDateTime=preEndDate+((preEndTime+1)/100000) //前一个小时，一小时前还在病区
			..//s dateTime=$o(transWardList(preEndDateTime),-1)
			..s dateTime=$o(transWardList(outDateTime),-1)
			..w outDateTime,!
			..//w $o(transWardList(outDateTime),-1),!
			..//w "dateTime="_dateTime_"  needWardLocId="_needWardLocId_" wardId="_wardId_" transDTWard:"_transWardList(dateTime),!
			..q:(dateTime'="")&&(needWardLocId'="")&&(transWardList(dateTime)'=wardId)
			..//w " 1 "_endDateTime_"\"_dateTime_"\"_preEndDateTime,!
			..//q:(endDateTime-dateTime>1)&(needClcsId=38) //有临出院评glasgow
			..//s inDateTime=dateTime
			..//s dateTime=$o(transWardList(preEndDateTime),1)
			..//w dateTime,!
			..//i dateTime="" d
				..//.w icuaId_" disch",! 
				..//.s dischDate=$p(^PAADM(EpisodeID),"^",17)
				..//.//q:dischDate'=endDate
				..//.s dischTime=$p(^PAADM(EpisodeID),"^",18)
				..//.s dateTime=dischDate+((dischTime)/100000)
			..//q:dateTime=""
			..//s outTime=(dateTime-$p(dateTime,"."))*100000
			..//w " 2 "_EpisodeID_"/"_dateTime_"/"_outTime_"/"_endDate_"/"_endTime,!
			..
			..//q:$p(dateTime,".")'=endDate
			..w "    still in",!
			..
			..s scoreEndDate=outDate
			..s scoreEndTime=(outTime\3600)*3600
			..i outTime-scoreEndTime>0 s scoreEndTime=scoreEndTime+3600 //出院非整点的后一小时
			..i scoreEndTime>86399 s scoreEndTime=scoreEndTime-86400,scoreEndDate=scoreEndDate+1
			..//w " 3 "_EpisodeID_"/"_outTime_"/"_scoreStartDate_"/"_scoreStartTime_"/"_scoreEndDate_"/"_scoreEndTime_"/"_endDate_"/"_endTime,!
			..q:scoreEndDate'=endDate
			..q:('ifPerHour)&&((scoreEndTime\3600)'=(endTime\3600))
			..w "  last in",!
			..s orderParaList=""
			..;===========同步数据之前============
			..s preApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"CreateScore","Before")="Apache："_preApacheII
			..
			..s retStr=$$CreateScoreData
			..;===========同步数据之后============
			..s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
			..i 'ifDebug s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"CreateScore","After")="Apache："_afterApacheII
			..			
	q retStr
	//q scoreItemStr
CreateScoreData()
	q:+icuaId=0 -1
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	q:icupId="" -2
	
	s ifDefault=""
	i (+calDuration)>=86400 d 
	.s ifDefault="1"
	w "calDuration~~~~~~~~~~~~~~~~~~"_calDuration_","_ifDefault,!,!
	;w "GetScoreValueByData~~~arg:"_icuaId_","_startDate_","_startTime_","_scoreEndDate_","_ scoreEndTime_","_ scoreItemStr_","_ifDefault,!
	w "GetScoreValueByData~~~arg:"_icuaId_","_scoreStartDate_","_scoreStartTime_","_scoreEndDate_","_ scoreEndTime_","_ scoreItemStr_","_ifDefault,!
	s scoreValueList=..GetScoreValueByData(icuaId, scoreStartDate, scoreStartTime, scoreEndDate, scoreEndTime, scoreItemStr,"",ifDefault) //取计算评分
	;s ^Lynt("CreateScoreData")=startDate_"/"_startTime_"/"_scoreEndDate_"/"_scoreEndTime_"/"_ifDefault_"/scoreItemStr="_scoreItemStr
	w scoreStartDate_"/"_scoreStartTime_"/"_scoreEndDate_"/"_scoreEndTime_"/scoreItemStr="_scoreItemStr,!
	w "scoreValueList:"_scoreValueList,!
	s fiO2Pos="",paO2Pos="",aaDO2Pos="",ambpPos="",nbpPos="",fiO2ClcsId="",paO2ClcsId="",aaDO2ClcsId=""
	s GCSPos="",EyeOpeningPos="",VerbalResponsePos="",MotorResponsePos="",ApachePHPos=""
	s EyeOpeningValueID="6403", VerbalResponseValueID="6405", MotorResponseValueID="6407", EyeOpeningScoreID="6404", VerbalResponseScoreID="6406", MotorResponseScoreID="6408",GCSID="6382"
	s inEyeOpeningValue="", inVerbalResponseValue="", inMotorResponseValue="", inEyeOpeningScore="", inVerbalResponseScore="", inMotorResponseScore="",inGCSScore=""
	s ICUAEyeOpeningCLCSODr="",ICUAEyeOpeningCLCSODr="",ICUAMotorResponseCLCSODr="",ICUAGlasgowPoint=""
	s ICUAEyeOpeningrecordeitemID="",ICUAVerbalResponserecordeitemID="",ICUAMotorResponserecordeitemID=""
	s ICUAEyeOpeningCLCDr="",ICUAVerbalResponseCLCDr="",ICUAMotorResponseCLCDr=""
	f j=1:1:$l(scoreItemStr,"^") d
		.s clcsId=$p(scoreItemStr,"^",j)
		.q:clcsId=""
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.i scoreCode="FiO2" s fiO2Pos=j,fiO2ClcsId=clcsId
		.i scoreCode="PaO2 ifFiO2<50%" s paO2Pos=j,paO2ClcsId=clcsId
		.i scoreCode="AaDO2 ifFiO2≥50%" s aaDO2Pos=j,aaDO2ClcsId=clcsId
		.i scoreCode="AMBP" s ambpPos=j
		.i scoreCode="NBP" s nbpPos=j
		.i scoreCode="GCS" s GCSPos=j
		.i scoreCode="EyeOpening" s EyeOpeningPos=j
		.i scoreCode="VerbalResponse" s VerbalResponsePos=j
		.i scoreCode="MotorResponse" s MotorResponsePos=j
		.i scoreCode="ARF" s arfPos=j
		.i scoreCode="ApachePH" s ApachePHPos=j 
	s inWardDateTimeStr=##class(web.DHCClinicCom).GetWardInDateTime(EpisodeID,startDate,startTime," ")
	s inWardDate=startDate,inWardTime=startTime
	w "scoreValueList:in createdata "_scoreValueList,!
	w "fiO2 "_fiO2Pos_","_fiO2ClcsId,!
	w "PaO2 "_paO2Pos_","_paO2ClcsId,!
	w "AaDO2 "_aaDO2Pos_","_aaDO2ClcsId,!
	i inWardDateTimeStr'=" " d
	.s inWardDate=##class(web.DHCClinicCom).ConvertToDateH($p(inWardDateTimeStr," "))
	.s inWardTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inWardDateTimeStr," ",2))
	
    i inWardDate'="" d
    .s ICUAEyeOpeningCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",33)
	.s ICUAVerbalResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",34)
	.s ICUAMotorResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",35)
	.q:(ICUAEyeOpeningCLCSODr="")!(ICUAVerbalResponseCLCSODr="")!(ICUAMotorResponseCLCSODr="")
	.s inEyeOpeningValue=$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",1)
	.s inEyeOpeningScore=$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",2)
	.s ICUAEyeOpeningrecordeitemID =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",3)
	.s ICUAEyeOpeningCLCDr =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",4)
	.s inEyeOpeningStr=$p(scoreValueList,"^",EyeOpeningPos)
	.;i inEyeOpeningStr'="" s $p(inEyeOpeningStr,"|",3) =inEyeOpeningValue
	. s $p(inEyeOpeningStr,"|",3) =inEyeOpeningValue
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningStr
    .w $p(scoreValueList,"^",EyeOpeningPos),"\"_inEyeOpeningStr_"\"_inEyeOpeningValue,!
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",4)=inEyeOpeningScore 
	. s $p(inEyeOpeningScoreStr ,"|",4)=inEyeOpeningScore 
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",2)=ICUAEyeOpeningrecordeitemID 
	.s $p(inEyeOpeningScoreStr ,"|",2)=ICUAEyeOpeningrecordeitemID 
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.s inEyeOpeningScoreStr=$p(scoreValueList,"^",EyeOpeningPos) 
	.;i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",1)=ICUAEyeOpeningCLCDr
	.i inEyeOpeningScoreStr'="" s $p(inEyeOpeningScoreStr ,"|",1)=ICUAEyeOpeningCLCDr
	.s $p(scoreValueList,"^",EyeOpeningPos)=inEyeOpeningScoreStr 
	.
	.s inVerbalResponseValue=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",1)
	.s inVerbalResponseScore=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",2)
	.s ICUAVerbalResponserecordeitemID=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",3)
	.s ICUAVerbalResponseCLCDr=$p(..GetValueAndScore(ICUAVerbalResponseCLCSODr),"^",4)
	.s inVerbalResponseStr=$p(scoreValueList,"^",VerbalResponsePos)
	.s $p(inVerbalResponseStr ,"|",3)=inVerbalResponseValue 
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseStr 
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",4)=inVerbalResponseScore 
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",2)=ICUAVerbalResponserecordeitemID
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr 
	.s inVerbalResponseScoreStr=$p(scoreValueList,"^",VerbalResponsePos) 
	.s $p(inVerbalResponseScoreStr,"|",1)=ICUAVerbalResponseCLCDr
	.s $p(scoreValueList,"^",VerbalResponsePos)=inVerbalResponseScoreStr  
	.
	.s inMotorResponseStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseStr ,"|",3)=inMotorResponseValue
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseStr 
	.s inMotorResponseValue=$p(..GetValueAndScore(ICUAMotorResponseCLCSODr),"^",1)
	.s inMotorResponseScore=$p(..GetValueAndScore(ICUAMotorResponseCLCSODr),"^",2)
	.s ICUAMotorResponserecordeitemID =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",3)
    .s ICUAMotorResponseCLCDr =$p(..GetValueAndScore(ICUAEyeOpeningCLCSODr),"^",4)
	.;s inGCSScore=ICUAGlasgowPoint
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",4)=inMotorResponseScore
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",2)=ICUAMotorResponserecordeitemID 
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.s inMotorResponseScoreStr=$p(scoreValueList,"^",MotorResponsePos) 
	.s $p(inMotorResponseScoreStr,"|",1)=ICUAMotorResponseCLCDr
	.s $p(scoreValueList,"^",MotorResponsePos)=inMotorResponseScoreStr
	.;b ;"2"
	
		w "scoreValueList:after gcs "_scoreValueList,!

	// 血气评分计算 Add 2014-02-28 17-33-41
	w icuaId_","_startDate_","_startTime_","_endDate_","_endTime_","_paO2ClcsId_","_aaDO2ClcsId_","_fiO2ClcsId,!
	s apacheScoreStr=##class(web.DHCCLScore).GetApacheOxygenation(icuaId, startDate, startTime, endDate, endTime, paO2ClcsId, aaDO2ClcsId, fiO2ClcsId)
	w apacheScoreStr,!	
	// 如果没有下血气医嘱,把血气评分值默认为0(正常) 20141120
	i (needIcuaId'="")&&(EpisodeID="") s EpisodeID=$p($g(^DHCICUArrange(+needIcuaId)),"^",1)
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	/*f j=1:1:$l(scoreValueList,"^") d
		.s tmpScoreValue=$p(scoreValueList,"^",j)
		.q:tmpScoreValue=""
		.s tmpScoreId=$p(tmpScoreValue,"|",1)
		.q:tmpScoreId=""
		.s tmpScoreCode=$lg(^DHCCLC("Score",tmpScoreId),1)
		.q:(tmpScoreId'="")&&(tmpScoreId'=paO2Pos)&&(tmpScoreId'=aaDO2Pos)&&(tmpScoreId'=ApachePHPos)
		.i tmpScoreId=paO2Pos s tmpArcimId=""
		.i tmpScoreId=aaDO2Pos s tmpArcimId=""
		.i tmpScoreId=ApachePHPos s tmpArcimId=""
		.s tmpIcucriId=$p(tmpScoreValue,"|",2)
		.s tmpValue=$p(tmpScoreValue,"|",3)
		.s tmpScore=$p(tmpScoreValue,"|",4)
		.i tmpValue="" d //只获取备注是动脉血气的医嘱
		..s OeOrdDesc=##class(web.DHCICUStat).getOeOrdAndDateTime(startDate, startTime, endDate, endTime,"","","33483||1",oeordId,"","oerIdAndDT","V","动脉")
		..i OeOrdDesc="" s tmpScore="0"
		.i tmpScoreId=paO2Pos s $p(scoreValueList,"^",paO2Pos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
		.i tmpScoreId=aaDO2Pos s $p(scoreValueList,"^",aaDO2Pos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
		.i tmpScoreId=ApachePHPos s $p(scoreValueList,"^",ApachePHPos)=tmpScoreId_"|"_tmpIcucriId_"|"_tmpValue_"|"_tmpScore
	w "scoreValueList:before paO2 "_scoreValueList,!*/
	;w $p(apacheScoreStr,"^",1),!
	i (paO2Pos>0)&&($p($p(apacheScoreStr,"^",1),"|",3)'="") s $p(scoreValueList,"^",paO2Pos)=$p(apacheScoreStr,"^",1)
	i (aaDO2Pos>0)&&($p($p(apacheScoreStr,"^",2),"|",3)'="") s $p(scoreValueList,"^",aaDO2Pos)=$p(apacheScoreStr,"^",2)
	i (fiO2Pos>0)&&($p($p(apacheScoreStr,"^",3),"|",3)'="") s $p(scoreValueList,"^",fiO2Pos)=$p(apacheScoreStr,"^",3)
	w "scoreValueList:after paO2 "_scoreValueList,!
	f j=1:1:$l(scoreItemStr,"^") d  //叶结点数据对应常用医嘱项
		.s clcsId=$p(scoreItemStr,"^",j)
		.q:clcsId=""
		.w j_" "_clcsId_" "
		.s scoreCode=$lg(^DHCCLC("Score",clcsId),1)
		.q:scoreCode=""
		.s scoreValue=$p(scoreValueList,"^",j)
		.//q:scoreValue=""
		.w scoreCode_"/"_$g(scoreSrcList(scoreCode)),"/"_$g(scoreList(scoreCode)),!
		.
		.i $d(scoreSrcList(scoreCode)) d	//数据项
			..s $p(icucriList(scoreSrcList(scoreCode)),"^",3)=$p(scoreValue,"|",3)
			..i scoreCode="FiO2" d
				...//tobe//i $p(icucriList(scoreSrcList(scoreCode)),"^",3)="" d
				...
				...
				...i $p(icucriList(scoreSrcList(scoreCode)),"^",3)<50 d
					....s $p(icucriList(6419),"^",3)="PaO2"
					....w "before<50:"_scoreValueList,!
					....i $p(icucriList(scoreSrcList(scoreCode)),"^",3)="" d
						....//.s $p(icucriList(scoreSrcList(scoreCode)),"^",3)=21
					....
					....//s paO2Str=$p(scoreValueList,"^",paO2Pos)
					....w "after<50:"_scoreValueList,!
				...e  d
					....s $p(icucriList(6419),"^",3)="A-aDO2"
					....s paO2Str=$p(scoreValueList,"^",paO2Pos)
					....s $p(paO2Str,"|",3)=""
					....w "before:"_scoreValueList,!
					....s $p(paO2Str,"|",4)=$p($p(scoreValueList,"^",aaDO2Pos),"|",4)
					....s $p(scoreValueList,"^",paO2Pos)=paO2Str
					....w "after:"_scoreValueList,!
					....//s $p(icucriList(6393),"^",3)=$p(paO2Str,"|",4)
					....q
					....
					....s aaDO2Str=$p(scoreValueList,"^",aaDO2Pos)
					....w aaDO2Pos_" paO2Str="_aaDO2Str,!
					....s $p(aaDO2Str,"|",4)=$p($p(scoreValueList,"^",paO2Pos),"|",4)
					....w aaDO2Pos_" paO2Str="_aaDO2Str,!
					....s $p(scoreValueList,"^",aaDO2Pos)=aaDO2Str
					....s $p(icucriList(6394),"^",3)=$p(aaDO2Str,"|",4)
		.i $d(scoreList(scoreCode)) d	//分值项
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=$p(scoreValue,"|",4)
		.i (scoreCode="AMBP")!(scoreCode="SOFAHypotension") d
			..q:$g(scoreList(scoreCode))=""
			..w "From AMBP--------------------",$g(scoreList(scoreCode)),!
			..q:$p(icucriList(scoreList(scoreCode)),"^",3)'=""
			..f k=1:1:$l(scoreItemStr,"^") d
				...s tmpClcsId=$p(scoreItemStr,"^",k)
				...q:tmpClcsId=""
				...s tmpScoreValue=$p(scoreValueList,"^",k)
				...q:tmpScoreValue=""
				...s tmpScoreCode=$lg(^DHCCLC("Score",tmpClcsId),1)
				...q:tmpScoreCode'="NBP"
				...s ambpIcucriId=$p(tmpScoreValue,"|",2)
				...q:ambpIcucriId=""
				...q:$p(tmpScoreValue,"|",3)=""
				...s ambpScore=$p(tmpScoreValue,"|",4)
				...q:ambpScore=""
				...//w !,scoreCode_"\"_scoreList(scoreCode)_"\"_icucriList(scoreList(scoreCode))_"\"_scoreValue_"\"_tmpScoreValue,!
				...s srcIcucriId=scoreSrcList(scoreCode)
				...s $p(icucriList(srcIcucriId),"^",3)=$p(^DHCICUC("RecordItem",ambpIcucriId),"^",2)_":"_$p(tmpScoreValue,"|",3)
				...s $p(icucriList(scoreList(scoreCode)),"^",3)=ambpScore
		.//i scoreCode="AMBP" s ambpScore=$p(scoreValue,"|",4)
		.i (scoreCode="SOFACreatinineAndUrine") d
			..w "SOFACreatinineAndUrine--------------------"
			..w icucriList(scoreList(scoreCode)),!
			..q:$p(icucriList(scoreList(scoreCode)),"^",3)'=""
			..f k=1:1:$l(scoreItemStr,"^") d
				...s tmpClcsId=$p(scoreItemStr,"^",k)
				...q:tmpClcsId=""
				...s tmpScoreValue=$p(scoreValueList,"^",k)
				...q:tmpScoreValue=""
				...s tmpScoreCode=$lg(^DHCCLC("Score",tmpClcsId),1)
				...q:tmpScoreCode'="SOFAUrine"
				...s ambpScore=$p(tmpScoreValue,"|",4)
				...w scoreValue_"\"_tmpScoreValue,!
				...q:(ifPerHour)&&(##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,endDate,endTime,"H")<24) //尿量24小时计算
				...;i (ifPerHour)&&((inTime\3600)'=(scoreEndTime\3600)) s ambpScore=0 
				...s $p(icucriList(scoreList(scoreCode)),"^",3)=ambpScore
	s layer=""
	f  s layer=$o(mainScoreList(layer),-1) q:layer=""  d  //评分主项到从项的树形汇总
		.s mainClcsId=""
		.f  s mainClcsId=$o(mainScoreList(layer,mainClcsId)) q:mainClcsId=""  d
			..w "layer:"_layer_"\"_mainClcsId_":"_$lg(^DHCCLC("Score",mainClcsId),2),!
			..q:'$d(^DHCCLC("Score",mainClcsId))
			..s score=$lg(^DHCCLC("Score",mainClcsId),5)
			..s subClcsId="",ifhaveSubScore=1
			..f  s subClcsId=$o(mainScoreList(layer,mainClcsId,subClcsId)) q:subClcsId=""  d
				...w "    subId:"_subClcsId_":"_$lg(^DHCCLC("Score",subClcsId),2)_"\haveSub: "_ifhaveSubScore
				...i '$d(^DHCCLC("Score",subClcsId)) q
				...s scoreCode=$lg(^DHCCLC("Score",subClcsId),1)
				...;b ;"rrrrrr"
				...i scoreCode="" s ifhaveSubScore=0 w " No scoreItem",! q
				...i '$d(scoreList(scoreCode)) w " No Score Qty",! q
				...w " "_scoreList(scoreCode)_","_$g(icucriList(scoreList(scoreCode)))
				...;i $p($g(icucriList(scoreList(scoreCode))),"^",3)="" w " No Para item data ",! q
				...;e  s ifhaveSubScore=1 
				...i $p($g(icucriList(scoreList(scoreCode))),"^",3)="" s ifhaveSubScore=0  w " No Para item data ",! q
				...s score=score+($lg(^DHCCLC("Score",subClcsId),4)*$p($g(icucriList(scoreList(scoreCode))),"^",3))
				...w "  Yes:score="_score,!
			..w "  haveAllSubScore:"_ifhaveSubScore,!			
			..s scoreCode=$lg(^DHCCLC("Score",mainClcsId),1)
			..q:scoreCode=""
			..i (score="")&&(scoreCode="SOFA") s score=0,ifhaveSubScore=1
			..;w scoreCode,!
			..q:('ifhaveSubScore)&&(scoreCode="APACHEII") //APACHEII评分的子项都有评分，出总分		
			..;q:('ifhaveSubScore)
			..q:'$d(scoreList(scoreCode))
			..w "   "_scoreList(scoreCode)_"\"_icucriList(scoreList(scoreCode))_"\"_score,!
			..s $p(icucriList(scoreList(scoreCode)),"^",3)=score
	//w "//////////"_$d(icucriList(icucriId)),!
	s icucriId=""
	f  s icucriId=$o(icucriList(icucriId)) q:icucriId=""  d
		.//w icucriId_"/"_icucriList(icucriId),!
		.q:$p(icucriList(icucriId),"^",3)=""
		.s $p(orderPara,$c(3),2)=icuaId
		.s $p(orderPara,$c(3),3)=icucriId
		.s $p(orderPara,$c(3),5)=userId
		.s $p(orderPara,$c(3),6,9)=endDate_$c(3)_endTime_$c(3)_endDate_$c(3)_endTime
		.s $p(orderPara,$c(3),11)=""
		.s $p(orderPara,$c(3),12)=""
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Note" s $p(orderPara,$c(3),11)=$p(icucriList(icucriId),"^",3)
		.i $p(^DHCICUC("RecordItem",icucriId),"^",24)="Qty" s $p(orderPara,$c(3),12)=$p(icucriList(icucriId),"^",3)
		.s $p(orderPara,$c(3),17)=$p(icucriList(icucriId),"^",2) //viewCat
		.s $p(orderPara,$c(3),18)="N"
		.s $p(orderPara,$c(3),22)=+$h
		.s $p(orderPara,$c(3),23)=$p($h,",",2)
		.s $p(orderPara,$c(3),26)="N"
		.s $p(orderPara,$c(3),39)=icupId_"||"_$p(icucriList(icucriId),"^",1)
		.i orderParaList'="" s orderParaList=orderParaList_"^"
		.s orderParaList=orderParaList_orderPara
		.//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_icucriList(icucriId),"\"_
		.w $p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_":"_orderPara,!
		.s $p(icucriList(icucriId),"^",3)="" //赋值后清空
	w "debug="_ifDebug,!
	i 'ifDebug d
	    .w "save"
	    .s ^tmpdebug("SaveICUOrder")=orderParaList
	    .s beforeApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"ifDebug","Before")="Apache:"_beforeApacheII
		.
		.s retStr=##class(web.DHCICUOrder).SaveICUOrder(orderParaList)
		.//i (needClcsCode="APACHEII")&(inDate=startDate) d 
		.i (needClcsCode="APACHEII")&(inDate=startDate)&(endTime=(inTime\3600*3600)) d //考虑当天入出的，大于一天的判断两次
			..//s $p(^DHCICUArrange(icuaId),"^",40)=score
			..s adjRet=..AdjustICUADeathProbability(icuaId)
		.//w retStr,!
		.s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
		.s ^ICUBaseLinesLog(icuaId,+$h,$p($h,",",2),"ifDebug","After")="Apache:"_afterApacheII
		.
		.s ^DHCANICUDEBUG("ComfirmCollectData",endDate,endTime)=orderParaList
		.k orderParaList
		.
	//w
	q retStr
}

}
