Class DtPortal.MD.MD19PrescComments Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:	bianshuai---(##Class(%ResultSet).RunQuery("DtPortal.DD.DD08PrescriptReview","QueryCmtWaysDs")移过来)
/// CreateDate: 2015-12-24
/// Descript:	点评方式（供Portal调用）
/// gxi
/// 
/// d ##Class(%ResultSet).RunQuery("DtPortal.MD.MD19PrescComments","MD190101","")
Query MD190101(type As %String = "") As DtPortal.Query(ROWSPEC = "TCmtWayId:%String,TCmtWayCode:%String,TCmtWayDesc:%String") [ SqlProc ]
{
}

ClassMethod MD190101Execute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	set ifExist=##class(%Dictionary.QueryDefinition).%OpenId("PHA.PRC.Com.Store||PCNTSWayStore",0)
	if (ifExist){
		if type="O"{
		 	 set findType=1
		}elseif  type="I" {
			 set findType=2
		}else{
			 set findType=""
		}
		 
		Set object = ##class(%ResultSet).%New("PHA.PRC.Com.Store:PCNTSWayStore")
		//findType - 类型(1-门诊,2-住院), wayType - 方式类型(CNTS-点评方式,Audit-审方式)
		s wayType="CNTS"
		Do object.Execute(findType,wayType)
		//adm,prescno,result,resconinfo,commentdate,admloc
		While (object.Next()) {
			set WayId=object.Data("RowId")
			set WayDesc=object.Data("Description")
			S WayCode=$p(^DHCPCWAY(WayId),"^",1)   ///代码
			S ListData=$LB(WayId,WayCode,WayDesc)
			Set ^||CacheTemp(repid,ind)=ListData	
			Set ind=ind+1
		}
	
	}else{
		S WayId="0"
		f  S WayId=$o(^DHCPCWAY(WayId)) Q:WayId=""  D
		.S WayCode=$p(^DHCPCWAY(WayId),"^",1)   ///代码
		.Q:WayCode=""
		.q:(WayCode'="P")&&(WayCode'="IP")&&(WayCode'="K")&&(WayCode'="C")	//add by myq 20170727 仅统计四种点评方式
		.q:(type="O")&&(WayCode'="P")&&(WayCode'="K")&&(WayCode'="C")	//门诊的不取IP类型的
		.S WayDesc=$p(^DHCPCWAY(WayId),"^",2)   ///描述
		.Q:WayDesc=""
		.S WayActive=$p(^DHCPCWAY(WayId),"^",3) ///启用状态
		.Q:WayActive'="Y"
		.i $f(WayDesc,$C(13))  S WayDesc=$p(WayDesc,$C(13))
		.
		.S ListData=$LB(WayId,WayCode,WayDesc)
		.Set ^||CacheTemp(repid,ind)=ListData	
		.Set ind=ind+1
	}
	
	

	Quit $$$OK
}

/// Creator： 白明哲
/// CreatDate： 2019-01-07
/// Description: 查询处方点评不合格率趋势图
/// Input：   year-查询年     typeId-处方点评类型ID  hospitalId-院区ID
/// Return： 
/// 服务编码：MD19.01.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD19PrescComments","MD190102","2020-01-01","4","","all","","")
Query MD190102(year As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "Month:%String,persent:%String,year:%String,tooldate:%String,unreason,reason,notreason,typeId")
{
}

ClassMethod MD190102Execute(ByRef qHandle As %Binary, year As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//传all用户查询全部科室
	if locIdStr="" q $$$OK
	if (locIdStr="all") set locIdStr=""
	
	if year["-" s year=$p(year,"-",1)
	
	//按年查询，固定输出1-12月
	s startDate=year_"-01-01"
	s endDate=year_"-12-31"
	
	k ^||TMPPortalMD190102
	
	//初始化月份
	for i=1:1:12{
		i i<10 s tempMonth="0"_i
		e  s tempMonth=i
		s ^||TMPPortalMD190102(year_"-"_tempMonth,"Y")=0
		s ^||TMPPortalMD190102(year_"-"_tempMonth,"N")=0
		s ^||TMPPortalMD190102(year_"-"_tempMonth,"not")=0
		
	}
	
	
	
	Set object = ##class(%ResultSet).%New("web.DHCSTINTERFACE:QueryCommentInfo")
	Do object.Execute($zdh(startDate,3),$zdh(endDate,3),userCode,typeId,locIdStr)
	//adm,prescno,result,resconinfo,commentdate,admloc
	While (object.Next()) {
		//b ;0001
		s admloc=object.Data("admloc")
		continue:admloc=""
		s hospID=$p($g(^CTLOC(admloc)),"^",22)
		continue:(hospitalId'="")&&(hospID'=hospitalId)
		s adm=object.Data("adm")
		if (adm'=""){
			s admType=$p($g(^PAADM(adm)),"^",2)
			if ((ifOPEPConf'="")){
				continue:ifOPEPConf'[admType
			}
		}

		s prescno=object.Data("prescno")
		s result=object.Data("result")
		s resconinfo=object.Data("resconinfo")
		s commentdate=object.Data("commentdate")
		s commentMonth=$p(commentdate,"-",1)_"-"_$p(commentdate,"-",2)
		s resultTemp=result
		
		if resultTemp="" s resultTemp="not"  //未点评
		s ^||TMPPortalMD190102(commentMonth,resultTemp)=$g(^||TMPPortalMD190102(commentMonth,resultTemp))+1
	}
	s monthTemp=""
	for {
		s monthTemp=$o(^||TMPPortalMD190102(monthTemp))
		q:monthTemp=""
		s lastdate=monthTemp_"-01"
		s lastdate=$zdh(lastdate,3)
		continue:lastdate>+$h
		s unreason=+$g(^||TMPPortalMD190102(monthTemp,"N"))  //不合格
		s reason=+$g(^||TMPPortalMD190102(monthTemp,"Y"))  //合格
		s notreason=+$g(^||TMPPortalMD190102(monthTemp,"not"))  //未点评
		s total=unreason+reason
		s persent=0
		i total'=0 {
			s persent=(unreason)/total
			s persent=$fn(persent,"",3)*100
		}
		
		s month=$p(monthTemp,"-",2)_"月"
		Set ^||CacheTemp(repid,ind)=$lb(month,persent,year,monthTemp,unreason,reason,notreason,typeId) 
		s ind=ind+1
		
		
	}
	k ^||TMPPortalMD190102
	Quit $$$OK
}

/// Creator： 白明哲
/// CreatDate： 2019-01-07
/// Description: 查询处方点评不合格处方 信息
/// Input：   year-查询年     typeId-处方点评类型ID  hospitalId-院区ID
/// Return： 
/// 服务编码：MD19.01.03
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD19PrescComments","MD190103","2020-01-01","2020-01-31","4","","all")
Query MD190103(startDate As %String, endDate As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "locDesc,locId,totalAll,unreason,reason,notreason,persent,resconinfo,startDate,endDate")
{
}

ClassMethod MD190103Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//传all用户查询全部科室
	if locIdStr="" q $$$OK
	if (locIdStr="all") set locIdStr=""
	
	k ^||TMPPortalMD190103
	
	Set object = ##class(%ResultSet).%New("web.DHCSTINTERFACE:QueryCommentInfo")
	Do object.Execute($zdh(startDate,3),$zdh(endDate,3),userCode,typeId,locIdStr)
	//adm,prescno,result,resconinfo,commentdate,admloc
	While (object.Next()) {
		//b ;0001
		s admloc=object.Data("admloc")
		continue:admloc=""
		s hospID=$p($g(^CTLOC(admloc)),"^",22)
		//w !,hospID_"^"_admloc
		continue:(hospitalId'="")&&(hospID'=hospitalId)
		s adm=object.Data("adm")
		
		if (adm'=""){
			s admType=$p($g(^PAADM(adm)),"^",2)
			if ((ifOPEPConf'="")){
				continue:ifOPEPConf'[admType
			}
		}
		//w !,"adm="_adm_"^^"_$p(^PAADM(adm),"^",2)
		s prescno=object.Data("prescno")
		s result=object.Data("result")
		s resconinfo=object.Data("resconinfo")
		s commentdate=object.Data("commentdate")
		s resconinfo=object.Data("resconinfo")
		
		s commentMonth=$p(commentdate,"-",1)_"-"_$p(commentdate,"-",2)
		s resultTemp=result
		
		if resultTemp="" s resultTemp="not"  //未点评
		s ^||TMPPortalMD190103(admloc,resultTemp)=$g(^||TMPPortalMD190103(admloc,resultTemp))+1
		i resultTemp="N" {
			if ($g(^||TMPPortalMD190103(admloc,resultTemp,"resInfo"))=""){
				s ^||TMPPortalMD190103(admloc,resultTemp,"resInfo")=resconinfo
			}else{
				s ^||TMPPortalMD190103(admloc,resultTemp,"resInfo")=$g(^||TMPPortalMD190103(admloc,resultTemp,"resInfo"))_"##"_resconinfo
			}
		
		}
	}
	s locTemp=""
	for {
		s locTemp=$o(^||TMPPortalMD190103(locTemp))
		q:locTemp=""
		s unreason=+$g(^||TMPPortalMD190103(locTemp,"N"))  //不合格
		s reason=+$g(^||TMPPortalMD190103(locTemp,"Y"))  //合格
		s notreason=+$g(^||TMPPortalMD190103(locTemp,"not"))  //未点评
		s total=unreason+reason   //总点评处方数据
		
		s totalAll=unreason+reason+notreason   //总处方数据
		//合格率
		s persent=""
		i total'=0 {
			s persent=(reason)/total
			s persent=$fn(persent,"",3)*100
		}
		s locId=locTemp
		s locDesc=$p(^CTLOC(locId),"^",2)
		i locDesc["-"  s locDesc=$p(locDesc,"-",2)
		
		s resconinfo=$g(^||TMPPortalMD190103(locTemp,"N","resInfo"))
		s resconLength=$l(resconinfo,"##")
		s resconinfoTemp=""
		for i=1:1:resconLength{
			s resconinfoTemp2=$p(resconinfo,"##",i)
			continue:resconinfoTemp2=""
			
			set reasonSingle=""
			if ($l(resconinfoTemp2,"^")>1){
				for reasonIndex=1:1:$l(resconinfoTemp2,"^"){
					s reasonSingleTemp=$p(resconinfoTemp2,"^",reasonIndex)
					if (reasonSingle="") {
						s reasonSingle=$p(reasonSingleTemp,"$$",2)
					}else{
						s reasonSingle=reasonSingle_"；"_$p(reasonSingleTemp,"$$",2)
					}
				}
			}else{
				s reasonSingle=$p(resconinfoTemp2,"$$",2)
			}
			set resconinfoTemp=resconinfoTemp_"<br>"_i_"、"_reasonSingle
		}
		k ^||TMPPortalMD190103("reason")
		Set ^||CacheTemp(repid,ind)=$lb(locDesc,locId,totalAll,unreason,reason,notreason,persent,resconinfoTemp,startDate,endDate) 
		s ind=ind+1
		
		
	}
	k ^||TMPPortalMD190103
	Quit $$$OK
}

/// Creator： 白明哲
/// CreatDate： 2019-01-07
/// Description: 查询处方点评不合格率趋势图
/// Input：   year-查询年   typeId-处方点评类型ID    hospitalId-院区ID
/// Return： prescno-处方号,EpisodeID-就诊ID,arcimDescStr-医嘱信息,reasonStr-原因
/// 服务编码：MD19.01.04
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD19PrescComments","MD190104","2020-01-01","2020-01-31","3","","6^203","")
Query MD190104(startDate As %String, endDate As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "bedCode,medicareNo,name,sex,age,admReason,prescno,EpisodeID,arcimDescStr,reasonStr")
{
}

ClassMethod MD190104Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, hospitalId As %String = "", locIdStr As %String = "", userCode As %String = "", ifOPEPConf As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//传all用户查询全部科室
	if locIdStr="" q $$$OK
	if (locIdStr="all") set locIdStr=""
	
	q:typeId="" $$$OK
	Set object = ##class(%ResultSet).%New("web.DHCSTINTERFACE:QueryCommentInfo")
	Do object.Execute($zdh(startDate,3),$zdh(endDate,3),userCode,typeId,locIdStr)
	//adm,prescno,result,resconinfo,commentdate,admloc
	While (object.Next()) {
		//b ;0001
		s admloc=object.Data("admloc")
		continue:admloc=""
		s hospID=$p($g(^CTLOC(admloc)),"^",22)
		//w !,hospID_"^"_admloc
		continue:(hospitalId'="")&&(hospID'=hospitalId)
		s EpisodeID=object.Data("adm")
		
		if (EpisodeID'=""){
			s admType=$p($g(^PAADM(EpisodeID)),"^",2)
			if ((ifOPEPConf'="")){
				continue:ifOPEPConf'[admType
			}
		}
		
		s prescno=object.Data("prescno")
		s result=object.Data("result")
		
		continue:result'="N"
		
		s resconinfo=object.Data("resconinfo")
		s commentdate=object.Data("commentdate")
		s resconinfo=object.Data("resconinfo")
		
		s commentMonth=$p(commentdate,"-",1)_"-"_$p(commentdate,"-",2)
		s resultTemp=result
		s oeordIDStr=""
		S WayCode=$p(^DHCPCWAY(typeId),"^",1)   ///代码
		//住院医嘱点评
		//医嘱id1$$不合理原因1^医嘱id2$$不合理原因2^医嘱id3$$不合理原因3...
		s oeordNum=$l(resconinfo,"^")
		s arcimDescStr="",reasonStr=""
		for index=1:1:oeordNum{
			s resconinfoTemp=$p(resconinfo,"^",index)
			continue:resconinfoTemp=""
			s oeordOriID=$p(resconinfoTemp,"$$",1)
			s reason=$p(resconinfoTemp,"$$",2)
			s arcimDescTemp=..GetArcimDescStrByIDStr(oeordOriID)
			if arcimDescStr="" s arcimDescStr=arcimDescTemp
			else  s arcimDescStr=arcimDescStr_"<br>"_arcimDescTemp
			if reasonStr="" s reasonStr=reason
			else  s reasonStr=reasonStr_"<br>"_reason			
		}
		
		//病人信息
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		s bedCode=$p(patInfoStr,"^",1)
		s medicareNo=$p(patInfoStr,"^",5)
		s name=$p(patInfoStr,"^",2)
		s sex=$p(patInfoStr,"^",3)
		s age=$p(patInfoStr,"^",4)
		s admReason=$p(patInfoStr,"^",6)
		
		
		Set ^||CacheTemp(repid,ind)=$lb(bedCode,medicareNo,name,sex,age,admReason,prescno,EpisodeID,arcimDescStr,reasonStr) 
		s ind=ind+1
		
	}
	
	Quit $$$OK
}

// 根据医嘱ID串获取医嘱描述串

ClassMethod GetArcimDescStrByIDStr(ordIDStr) As %Library.String
{
	
    s retStr=""
    q:ordIDStr="" ""
    s num=$l(ordIDStr,",")
    for i=1:1:num{
	    s oeordOriID=$p(ordIDStr,",",i)
	    if oeordOriID="" continue
	    s oeordId=$p(oeordOriID,"||",1)
		s oeoriSub=$p(oeordOriID,"||",2)
		s OEORIItmMastDR=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)	//医嘱项DR
	 	s arcimDescTemp=##class(DtPortal.Common.PublicService).GetArcimDesc(OEORIItmMastDR)
	 	
		if (retStr=""){
			s retStr="(1)"_arcimDescTemp
		}else{
			s retStr=retStr_"；("_i_")"_arcimDescTemp
		}
	}
    q retStr
}

}
