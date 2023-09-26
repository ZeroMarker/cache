Import SQLUser

Class web.DHCWMRFrontPageQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 77;

/// 通过卷Rowid(VolId)取编目信息
/// 病案首页 $c(1) 诊断和手术 $c(2) 诊断和手术 $c(1) 附加项 $c(2) 附加项
/// w ##Class(web.DHCWMRFrontPageQry).GetFrontPageInfo(VolId)
ClassMethod GetFrontPageInfo(VolId)
{
	n (VolId)
	set ^CacheTemp("GetFrontPageInfo")=VolId
	s ret=""
	s FrontPage="",FPICD="",FPExtra=""
	
	;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
	q:'$d(^DHCWMRFP(0,"VolumeDr",+VolId)) ret
	s FPId=$o(^DHCWMRFP(0,"VolumeDr",+VolId,""),-1)
	q:(FPId="")||(FPId=0) ret
	q:'$d(^DHCWMRFP(FPId)) ret
	s FrontPage=$g(^DHCWMRFP(FPId))
	;s $p(FrontPage,"^",3)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(FrontPage,"^",3))   //user: id/code/name
	s:$p(FrontPage,"^",4)'="" $p(FrontPage,"^",4)=$zd($p(FrontPage,"^",4),3)
	s:$p(FrontPage,"^",5)'="" $p(FrontPage,"^",5)=$zt($p(FrontPage,"^",5),2)
	s FrontPage=FPId_"^"_FrontPage
	;w !!,FrontPage
	
	;^DHCWMRFPICD(0,"FP",{FrontPageDr},{RowId})
	;update by zf 处理诊断排序错误 取值时排序,JS不做处理
	s JIndex=$j,ZIndex=$zn
	k ^TMP(ZIndex,JIndex)
	i $d(^DHCWMRFPICD(0,"FP",FPId)) d
	.s ICDId=0
	.f  s ICDId=$o(^DHCWMRFPICD(0,"FP",FPId,ICDId)) q:ICDId=""  d
	..s TMP=$g(^DHCWMRFPICD(ICDId))
	..s $p(TMP,"^",4)=##class(web.DHCMedBaseCtl).GetUsrStr($p(TMP,"^",4))   //user: id/code/name
	..s $p(TMP,"^",5)=##class(web.DHCMedBaseCtl).GetUsrStr($p(TMP,"^",5))   //user: id/code/name
	..s $p(TMP,"^",6)=##class(web.DHCMedBaseCtl).GetUsrStr($p(TMP,"^",6))   //user: id/code/name
	..s $p(TMP,"^",8)=##class(web.DHCMedBaseCtl).GetUsrStr($p(TMP,"^",8))   //user: id/code/name
	..s:$p(TMP,"^",13)'="" $p(TMP,"^",13)=$zd(+$p(TMP,"^",13),3)
	..s Pos=+$p(TMP,"^",11)
	..s TMP=ICDId_"^"_TMP
	..;w !!,TMP
	..s ^TMP(ZIndex,JIndex,Pos,ICDId)=TMP
	s Pos=""
	f  s Pos=$o(^TMP(ZIndex,JIndex,Pos)) q:Pos=""  d
	.s ICDId=""
	.f  s ICDId=$o(^TMP(ZIndex,JIndex,Pos,ICDId)) q:ICDId=""  d
	..s TMP=$g(^TMP(ZIndex,JIndex,Pos,ICDId))
	..s FPICD=FPICD_$c(2)_TMP
	.;s FPICD=$e(FPICD,2,$l(FPICD))
	
	;^DHCWMRFPE(0,"FP",{FrontPageDr},{RowId})
	i $d(^DHCWMRFPE(0,"FP",FPId)) d
	.s ExtraId=0
	.f  s ExtraId=$o(^DHCWMRFPE(0,"FP",FPId,ExtraId)) q:ExtraId=""  d
	..s TMP=$g(^DHCWMRFPE(ExtraId))
	..s TMP=ExtraId_"^"_TMP
	..;w !!,TMP
	..s FPExtra=FPExtra_$c(2)_TMP
	.s FPExtra=$e(FPExtra,2,$l(FPExtra))
	
	s ret=FrontPage_$c(1)_FPICD_$c(1)_FPExtra
	q ret
}

ClassMethod BuildData(repid, ind, s)
{
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod QueryFPICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPICDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPICDExecute(ByRef qHandle As %Binary, FrontPageID As %String, ItemType As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:+FrontPageID=0 $$$OK
	s ItemType=$g(ItemType)
	s:ItemType'="" ItemType=$s(ItemType["O":"O",1:"D")
	;^DHCWMRFPICD(0,"FP",{FrontPageDr},{RowId})
	s id=0
	f  s id=$o(^DHCWMRFPICD(0,"FP",+FrontPageID,id)) q:id=""  d
	.q:'$d(^DHCWMRFPICD(id))
	.s s=$g(^DHCWMRFPICD(id))
	.s tmpType=$p(s,"^",10)
	.;q:((ItemType'="")&&(ItemType'=tmpType))
	.s tmpType=$p($g(^DHCWMRDIC(+tmpType)),"^",2)
	.q:((ItemType'="")&&(ItemType'=tmpType))
	.;Modify by wuqk 2008-05-07  根据当前医院设置决定取哪个编目字典
	.;s $p(s,"^",2)=$tr(##class(web.DHCWMRICDCtl).GetICDDx($p(s,"^",2)),"^","/")   //ICDDx
	.s ICDSetting="",ICDDxString=""
	.s:ItemType="D" ICDDxString=##class(web.DHCWMRICDCtl).GetMyICDByRowId($p(s,"^",2))
	.s:ItemType="O" ICDDxString=##class(web.DHCWMRICDCtl).GetMyOperByRowId($p(s,"^",2))
	.s ICDDxString=$tr(ICDDxString,"^","/")
	.;end by wuqk 
	.s $p(s,"^",3)=$$xGetWMRDic($p(s,"^",3))    //dic: id/code/desc
	.s $p(s,"^",4)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",4))   //user: id/code/name
	.s $p(s,"^",5)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",5))   //user: id/code/name
	.s $p(s,"^",6)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",6))   //user: id/code/name
	.s $p(s,"^",7)=$$xGetWMRDic($p(s,"^",7))    //dic: id/code/desc
	.s $p(s,"^",8)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",8))   //user: id/code/name
	.s $p(s,"^",9)=$$xGetWMRDic($p(s,"^",9))    //dic: id/code/desc
	.s:$p(s,"^",13)'="" $p(s,"^",13)=$zd(+$p(s,"^",13),3)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
	
xGetWMRDic(DicID)
    n (DicID)
    s ret=""
    s ret=$g(^DHCWMRDIC(+DicID))
    s ret=DicID_"/"_$p(ret,"^",2)_"/"_$p(ret,"^",3)
    q ret
}

ClassMethod QueryFPICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPICDExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFrontPageQry","QueryFPICD",FrontPageID,ItemType)
Query QueryFPICD(FrontPageID As %String, ItemType As %String) As %Query(ROWSPEC = "ID:%String,FrontPageID:%String,ICDDx:%String,Result:%String,OperDoc:%String,Assistant1:%String,Assistant2:%String,NarcosisType:%String,NarcosisDoc:%String,CloseUp:%String,ICDType:%String,Pos:%String,Resume:%String,OperDate:%String")
{
}

ClassMethod QueryFPExtraClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPExtraExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPExtraExecute(ByRef qHandle As %Binary, FrontPageID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:+FrontPageID=0 $$$OK
	;^DHCWMRFPE(0,"FP",{FrontPageDr},{RowId})
	s id=0
	f  s id=$o(^DHCWMRFPE(0,"FP",+FrontPageID,id)) q:id=""  d
	.q:'$d(^DHCWMRFPE(id))
	.s s=$g(^DHCWMRFPE(id))
	.s $p(s,"^",2)=$tr(##Class(web.DHCWMRFPTempCtl).GetItem(+$p(s,"^",2)),"^","/")
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPExtraFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPExtraExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFrontPageQry","QueryFPExtra",FrontPageID)
Query QueryFPExtra(FrontPageID As %String) As %Query(ROWSPEC = "ID:%String,FrontPageID:%String,FPItem:%String,ItemValue:%String,Pos:%String")
{
}

/// Creator:wangCS
/// CreateDate:2011-10-25
/// Description:按照科室统计一段时间内的诊断愈合情况
/// Input： startDate出院开始日期  endDate出院结束日期
/// Output：loc、治愈、好转、未愈、死亡、合计、治愈率、好转率、病死率、
/// Debug：d ##Class(%ResultSet).RunQuery("web.DHCWMRFrontPageQry","QueryDisResult",58737,62389)
Query QueryDisResult(startDate As %String, endDate As %String) As %Query(ROWSPEC = "Loc:%String,CureCount:%String,ImpoveCount:%String,NotImpoveCount:%String,DeadCount:%String,Total:%String,CureRate:%String,ImpoveRate:%String,DeadRate:%String")
{
}

ClassMethod QueryDisResultExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set:startDate["-" startDate=+$zdh(startDate,3)
	set:startDate["/" startDate=+$zdh(startDate,4)
	set:endDate["-" endDate=+$zdh(endDate,3)
	set:endDate["/" endDate=+$zdh(endDate,4)
	k ^CacheTemp($j,"QueryDisResult")
	
	;^PAADMi("DisDateT",{PAADM_Type},{PAADM_DischgDate},{PAADM_RowID}) 
	for admDate=startDate:1:endDate {
		continue:'$d(^PAADMi("DisDateT","I",admDate))
		set paadm=0
		set paadm=$o(^PAADMi("DisDateT","I",admDate,paadm))
		while(paadm'=""){
			set mrPaadm=paadm
			set paadm=$o(^PAADMi("DisDateT","I",admDate,paadm))
			;^PAADM({PAADM_RowID})
			set loc=$p($g(^PAADM(mrPaadm)),"^",4)                    ;loc
			;^DHCWMRVOL(0,"PaadmDr",{Paadm_Dr},{Rowid})
			continue:'$d(^DHCWMRVOL(0,"PaadmDr",mrPaadm))
			set volumeId=0
			set volumeId=$o(^DHCWMRVOL(0,"PaadmDr",mrPaadm,volumeId))
			continue:volumeId=""
			;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
			set fpId=0
			set fpId=$o(^DHCWMRFP(0,"VolumeDr",volumeId,fpId))
			while(fpId'=""){
				;^DHCWMRFPICD(0,"FP",{FrontPageDr},{RowId})
				set fpICDId=0
				set fpICDId=$o(^DHCWMRFPICD(0,"FP",fpId,fpICDId))
				while(fpICDId'=""){
			 		;^DHCWMRFPICD({RowId})
			 	 	set fpICDRowId=fpICDId
			 	 	set fpICDId=$o(^DHCWMRFPICD(0,"FP",fpId,fpICDId))
				 	set disResult=$p($g(^DHCWMRFPICD(fpICDRowId)),"^",3)  ;result
					 continue:disResult=""
			   		 ;w !,"loc:"_loc_"  result:"_disResult_"  paadm:"_mrPaadm_" fpICDId:"_fpICDId
					 if ($d(^CacheTemp($j,"QueryDisResult",loc,disResult))){
				 		set ^CacheTemp($j,"QueryDisResult",loc,disResult)=+^CacheTemp($j,"QueryDisResult",loc,disResult)+1	
				 	}else{
				 	    set ^CacheTemp($j,"QueryDisResult",loc,disResult)=1
					 }
				}
				set fpId=$o(^DHCWMRFP(0,"VolumeDr",volumeId,fpId))
			}
		}
	}
	set locId=0
	set locId=$o(^CacheTemp($j,"QueryDisResult",locId))
	while(locId'=""){
		set locRowId=locId
		set locId=$o(^CacheTemp($j,"QueryDisResult",locId))
		set locDesc=$p($g(^CTLOC(locRowId)),"^",1)   ;ctloc_code
		set cureCount=0,impoveCount=0,notImpCount=0,deadCount=0,total=0,cureRate=0,impRate=0,deadRate=0
		set result=0
		set result=$o(^CacheTemp($j,"QueryDisResult",locRowId,result))
		while(result'=""){
			set dicId=result
			set result=$o(^CacheTemp($j,"QueryDisResult",locRowId,result))
			set dicDesc=$p($g(^DHCWMRDIC(dicId)),"^",3)      ;description
			set:dicDesc="治愈" cureCount=+$g(^CacheTemp($j,"QueryDisResult",locRowId,dicId))
			set:dicDesc="好转" impoveCount=+$g(^CacheTemp($j,"QueryDisResult",locRowId,dicId))
			set:dicDesc="未愈" notImpCount=+$g(^CacheTemp($j,"QueryDisResult",locRowId,dicId))
			set:dicDesc="死亡" deadCount=+$g(^CacheTemp($j,"QueryDisResult",locRowId,dicId))
		}
		;w !,locDesc_" cureCount:"_cureCount_" impoveCount:"_impoveCount_" notImpCount:"_notImpCount_" deadCount:"_deadCount
		set total=cureCount+impoveCount+notImpCount+deadCount
		if (total>0){
		 set cureRate=(cureCount/+total)*100
		 set cureRate=$e(cureRate,0,$f(cureRate,".")+3)
		 set impRate=(impoveCount/+total)*100
		 set impRate=$e(impRate,0,$f(impRate,".")+3)
		 set deadRate=(deadCount/+total)*100
		 set deadRate=$e(deadRate,0,$f(deadRate,".")+3)
		 set data=$lb(locDesc,cureCount,impoveCount,notImpCount,deadCount,total,cureRate,impRate,deadRate)
		 set ^CacheTemp(repid,ind)=data
		 set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryDisResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDisResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	k ^CacheTemp($j,"QueryDisResult")
 	Quit $$$OK
}

ClassMethod QueryDisResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDisResultExecute ]
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

/// Creator:wangCS
/// CreatDate:2011-10-26
/// Description:Excel打印
/// Input：argument startDate^endDate
/// Debug:
ClassMethod QueryDisResultPrint(itemJs As %String = "", argument As %String = "") As %String
{
	n (itemJs,argument)
	
	set startDate=$p($g(argument),"^",1)
	set endDate=$p($g(argument),"^",2)
	s ^CacheTemp("QueryDisResultPrint")=startDate_","_endDate
	s rs=##Class(%Library.ResultSet).%New("web.DHCWMRFrontPageQry:QueryDisResult")
	d rs.Execute(startDate,endDate)
	s startRow=4
	while(rs.Next()){
		;Loc,CureCount,ImpoveCount,NotImpoveCount,DeadCount,Total,CureRate,ImpoveRate,DeadRate
		s loc=rs.Data("Loc")                               ;科室
		s cureCount=rs.Data("CureCount")                   ;治愈数量
		s impCount=rs.Data("ImpoveCount")                  ;好转数量
		s notImpCount=rs.Data("NotImpoveCount") 	       ;未愈数量
		s deadCount=rs.Data("DeadCount")                   ;死亡数量
		s total=rs.Data("Total")                           ;总计
		s cureRate=rs.Data("CureRate")                     ;治愈%
		s impRate=rs.Data("ImpoveRate")                    ;好转%
		s deadRate=rs.Data("DeadRate")                     ;死亡%
		s excelRow=loc_$c(1)_cureCount_$c(1)_impCount_$c(1)_notImpCount_$c(1)_deadCount_$C(1)_cureRate_$c(1)_impRate_$c(1)_deadRate_$c(1)_total
		
		s ret=itemJs_"(xlSheet,'"_$ZCVT(excelRow,"O","JS")_"',"_startRow_",1);"
		&javascript<#(ret)#>
		s startRow=startRow+1
	}
	d rs.Close()
	set excelCell=" 开始日期："_$zd($zdh(startDate,4),3)_" 至 结束日期:"_$zd($zdh(endDate,4),3)
	s ret=itemJs_"(xlSheet,'"_$ZCVT(excelCell,"O","JS")_"',2,1);"
	&javascript<#(ret)#>
	q startRow
}

}
