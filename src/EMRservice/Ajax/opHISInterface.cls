/// 门诊与HIS的数据接口类
Class EMRservice.Ajax.opHISInterface Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	
	s action=$g(%request.Data("action",1),"")
	if (action="getDiag")  //链接单元获取诊断
	{ 
		s episodeID=$g(%request.Data("EpisodeID", 1), "")
		//s ret=..GetMRDiagnosDesc(episodeID,";")
		s ret=..getDiag(episodeID,"\r\n")
		w "{""Value"":"""_ret_"""}"
	} 
	elseif (action="getOeord") //链接单元获取医嘱
	{
		s episodeID=$g(%request.Data("EpisodeID", 1), "")
		s ssgroup=$g(%request.Data("ssgroup", 1), "")
		s HospitalName=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		if ("BJXHYY"=HospitalName) { 
			s ret = ..getOeordXH(episodeID, ssgroup)
		} else {
			s ret = ..getOeord(episodeID, ssgroup)
		}
		w ret
	}
	elseif (action="getOeordForGrd") //右侧医嘱列表
	{
		S episodeID=$g(%request.Data("episodeID", 1), "")
		S ssgroup=$g(%request.Data("ssgroup", 1), "")
		w ..getOeordForGrd(episodeID, ssgroup)
	}	
	elseif (action="admComplete")
	{
		S episodeID=$g(%request.Data("EpisodeID", 1), "")
		w ..AdmComplete(episodeID)
	}
	elseif (action="getDiagnos")  //右侧诊断列表
	{
		S episodeId=$g(%request.Data("EpisodeID", 1), "")
		w ..getDiagnos(episodeId)
	}
	elseif (action="getOPToolsLink")  //获取HIS功能链接
	{
		w ..getOPToolsLink()
	}				
	else
	{

		w ""
	}
 
	Quit $$$OK
ErrorHandler
   w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   Quit $$$OK
}

ClassMethod convertOrderFreq(OrderFreq As %String) As %String
{
	q:("ONCE"=OrderFreq) "一次"
	q:("Bid"=OrderFreq) "每日两次"
	q:("Tid"=OrderFreq) "每日三次"
	q:("QD"=OrderFreq) "每日一次"
	q:("Qod"=OrderFreq) "隔日一次"
	q:("TIDAC"=OrderFreq) "每日三次,餐前服用"
	q OrderFreq
}

/*
协和医嘱格式，西药用法换到第二行
*/
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLOrderData","FindAdmOrderItems","4067607","299","","","","")
/// w ##Class(EMRservice.Ajax.opHISInterface).getOeordXH("11143185","299")
ClassMethod getOeordXH(episodeID, ssGroup As %String) As %String
{
	s liner = "\r\n"
	
	s pascData = ""
	s lisData = ""
	s medData = ""

	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,ssGroup,"","","",""," I E V ")
	While (rset.Next()) {
		if ("检查"=rset.Get("TypeClass")) { 
			if (pascData="") { s pascData=" "_rset.OrderName }
			else { s pascData = pascData_", "_rset.OrderName }		
		} elseif ("检验"=rset.Get("TypeClass")) {
			if (lisData="") { s lisData=" "_rset.OrderName }
			else { s lisData = lisData_", "_rset.OrderName }				
		} elseif ("西药"=rset.Get("TypeClass")) {  // 特殊处理子医嘱	
			s drugInfo = "" 
			if (rset.Get("OrderSeqNo")[".") {
				s drugInfo="@."_$P(rset.Get("OrderSeqNo"),".",2)_" "_rset.OrderName
			} else {
				s drugInfo=" "_rset.OrderName
			}
					
			s drugInfo = drugInfo_" "_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
			s drugInfo = drugInfo_" "_rset.Get("OrderPackQty")_rset.Get("OrderPackUOM")
			s drugInfo = drugInfo_"\r\n    用法："
			s drugInfo = drugInfo_"每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
			s drugInfo = drugInfo_" "_..convertOrderFreq(rset.Get("OrderFreq"))
			s drugInfo = drugInfo_" "_$P($P(rset.Get("OrderInstr"),"-",2),"(",1)	
				
			if (medData="") { s medData=drugInfo }
			else { s medData = medData_","_drugInfo }	 	 
		}
	}
 
	Do rset.Close()
	
	s idx=0
	if (""'=pascData) {
		s count = $Length(pascData,",")
		for I = 1:1:count {
			s idx=idx+1
			s ret = ret_liner_idx_""_$p(pascData,",",I)
		}
	}
	if (""'=lisData) {
		s idx=idx+1
		s ret = ret_liner_idx_""_lisData
	}
	
	if (""'=medData) {
		s count = $Length(medData,",")
		for I = 1:1:count {
			s dragInfo=$p(medData,",",I)
			if (dragInfo["@") {
				s ret = ret_liner_$tr(dragInfo,"@",idx)
			} else {
				s idx=idx+1
				s ret = ret_liner_idx_""_dragInfo
			}
			
		}		
	}
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(episodeID,"","","","","","","","Z")
	while result.%Next() 
	{ 		
		s idx=idx+1
		s ret = ret_liner_idx_" "_..ReplaceEnterChar(result.Data("ArcimDesc")_" "_$P(result.Data("Instr"),"-",2))   //_""",""oeordType"":""草药""}"
	}

	q "{""Value"":"""_ret_"""}"
}

/*
   检查类  每条一行列出 
   检验类  合并成一行
   药品类  每条一行列出
*/
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLOrderData","FindAdmOrderItems","4067607","299","","","","")
/// w ##Class(EMRservice.Ajax.opHISInterface).getOeord("11411","299")
ClassMethod getOeord(episodeID, ssGroup As %String) As %String
{
	s liner = "\r\n"
	
	s pascData = ""
	s lisData = ""
	s medData = ""
	s lastDrugRow = "" //上一条医嘱记录 
	s lastDrugName = ""
	s lastDrugInfo = ""  //用法
	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,ssGroup,"","","",""," I E V ")
	While (rset.Next()) {
		if ("检查"=rset.Get("TypeClass")) { 
			if (pascData="") { s pascData =  rset.OrderName }
			else { s pascData = pascData_","_ rset.OrderName }		
		} elseif ("检验"=rset.Get("TypeClass")) {
			if (lisData="") { s lisData =  rset.OrderName }
			else { s lisData = lisData_","_ rset.OrderName }				
		} elseif ("西药"=rset.Get("TypeClass")) {  // 特殊处理子医嘱	

			if (rset.Get("OrderSeqNo")[".") {
				if (lastDrugRow = "") {
					s medData=medData_" + "_rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				} else {	 
					s row=lastDrugName_" + "_rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
					if (medData="") { s medData = row }
					else { s medData = medData_","_row }
					s lastDrugRow = ""
				}
			} else {
				if (lastDrugRow'="") {
					if (medData="") { s medData = lastDrugRow }
					else { s medData = medData_","_lastDrugRow }
				}else {
					if (medData'="") { s medData = medData_" "_lastDrugInfo}
				}
			 
				s lastDrugRow = rset.OrderName
				s lastDrugRow = lastDrugRow_" 每次"_rset.Get("OrderDoseQty")
				s lastDrugRow = lastDrugRow_rset.Get("OrderDoseUOM")
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderInstr")
				s lastDrugRow = lastDrugRow_" "_..convertOrderFreq(rset.Get("OrderFreq"))
				s lastDrugRow = lastDrugRow_" × "_rset.Get("OrderDur")
				
				s lastDrugName = rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				s lastDrugInfo = rset.Get("OrderInstr")_" "_..convertOrderFreq(rset.Get("OrderFreq"))_" × "_rset.Get("OrderDur")
			}	 
		}
	}
 
	Do rset.Close()
	
	if (lastDrugRow'="") {
		if (medData="") { s medData = lastDrugRow }
		else { s medData = medData_","_lastDrugRow }	
	}else {
		if (medData'="") { s medData = medData_" "_lastDrugInfo}
	}
 
	s idx=0
	if (""'=pascData) {
		s count = $Length(pascData,",")
		for I = 1:1:count {
			s idx=idx+1
			s ret = ret_idx_"."_$p(pascData,",",I)_liner
		}
	}
	if (""'=lisData) {
		s idx=idx+1
		s ret = ret_idx_"."_lisData_liner
	}
	
	if (""'=medData) {
		s count = $Length(medData,",")
		for I = 1:1:count {
			s idx=idx+1
			s ret = ret_idx_"."_$p(medData,",",I)_liner
		}		
	}
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(episodeID,"","","","","",""," E V ","Z")
	while result.%Next() 
	{ 		
		s idx=idx+1
		s ret = ret_idx_"."_..ReplaceEnterChar(result.Data("ArcimDesc")_" "_$P(result.Data("Instr"),"-",2)_liner)    //_""",""oeordType"":""草药""}"
	}	
	
	q "{""Value"":"""_ret_"""}"
}

/// w ##Class(EMRservice.Ajax.opHISInterface).getOeordForGrd(11143185, 299)
ClassMethod getOeordForGrd(episodeID, ssGroup As %String) As %String
{
	s rows=""
	s count=0
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,ssGroup,"","","",""," I E V ", "Y")
	s caoyao="", split="", caoyaoCount =0
	s medData = ""
	s lastDrugRow = "" //上一条医嘱记录 
	s lastDrugName = ""
	s lastDrugInfo = ""  //用法
	While (rset.Next()) {
		//s:(rows'="") rows=rows_"," 
		if (rset.Get("TypeClass")["草药") {
			/*if (4=caoyaoCount){
				s split="\n"
				s caoyaoCount=0
			}
			else {
				s split="\t"
			}
			s item = ..FilterIlleaglChar(rset.Get(1))_rset.Get(6)_rset.Get(7)
			if (""=caoyao) { s caoyao = item }
			else { s caoyao = caoyao_split_item }
			s caoyaoCount=caoyaoCount+1*/	
		}
		elseif ("西药"=rset.Get("TypeClass")) {

			if (rset.Get("OrderSeqNo")[".") {
				if (lastDrugRow = "") {
					s medData=medData_" + "_rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				} else {
					s row=lastDrugName_" + "_rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
					if (medData="") { s medData = row }
					else { s medData = medData_","_row }
					s lastDrugRow = ""
				}
			} else {
				if (lastDrugRow'="") {
					if (medData="") { s medData = lastDrugRow }
					else { s medData = medData_","_lastDrugRow }
				}else {
					if (medData'="") { s medData = medData_" "_lastDrugInfo}
				}
			 
				s lastDrugRow = rset.Get("OrderName")
				s lastDrugRow = lastDrugRow_" 每次"_rset.Get("OrderDoseQty")
				s lastDrugRow = lastDrugRow_rset.Get("OrderDoseUOM")
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderInstr")
				s lastDrugRow = lastDrugRow_" "_..convertOrderFreq(rset.Get("OrderFreq"))
				s lastDrugRow = lastDrugRow_" × "_rset.Get("OrderDur")
				
				s lastDrugName = rset.Get("OrderName")_" 每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				s lastDrugInfo = rset.Get("OrderInstr")_" "_..convertOrderFreq(rset.Get("OrderFreq"))_" × "_rset.Get("OrderDur")
			}	
		}		
		else {
			s oeord=..FilterIlleaglChar(rset.Get("OrderName"))
			s:(rows'="") rows=rows_"," 
			s rows = rows_"{""oeord"":"""_oeord_""",""oeordType"":"""_rset.Get("TypeClass")_"""}"
			s count=count+1	
		}
	}
	Do rset.Close()
	
	/*if (caoyao'=""){
		s:(rows'="") rows=rows_"," 
		s rows = rows_"{""oeord"":"""_caoyao_""",""oeordType"":""草药""}"
		s count=count+1	
	}*/
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(episodeID,"","","","","","","","Z")
	while result.%Next() 
	{ 
		s:(rows'="") rows=rows_"," 
		s rows = rows_"{""oeord"":"""_..ReplaceEnterChar(result.Data("ArcimDesc")_" "_$P(result.Data("Instr"),"-",2))_""",""oeordType"":""草药""}"	
		s count = count + 1
	}	
	
	if (lastDrugRow'="") {
		if (medData="") { s medData = lastDrugRow }
		else { s medData = medData_","_lastDrugRow }	
	}else {
		if (medData'="") { s medData = medData_" "_lastDrugInfo}
	}


	if (""'=medData) {
		s length = $Length(medData,",")
		for I = 1:1:length {
			s:(rows'="") rows=rows_"," 
			s rows = rows_"{""oeord"":"""_$p(medData,",",I)_""",""oeordType"":""西药""}"
			s count=count+1	
		}		
	}
	
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"

	q ret
}

/// w ##Class(EMRservice.Ajax.opHISInterface).AdmComplete("4067282")
ClassMethod AdmComplete(adm As %String) As %String
{
	s AdmComplete = $p($g(^PAADM(adm,1)),"^",23)
	q:(AdmComplete'="Y") "{""Value"":""N""}"
	q "{""Value"":"""_AdmComplete_"""}"
}

/// w ##Class(EMRservice.Ajax.opHISInterface).getDiagnos(1067131)
ClassMethod getDiagnos(episodeId As %String) As %String
{
	s json = ""
	q:(episodeId = "") "{""total"":0,""rows"":["_json_"]}"
	s count = 0

	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosList")
	d ds.Execute(episodeId,"")
	While (ds.Next())
	{
		s count = count + 1
		d setJson
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
setJson
	s json = json_"{"
	s json = json_"""ARowID"":"""_ds.Data("ARowID")_""","
	s json = json_"""ADiagnosType"":"""_ds.Data("ADiagnosType")_""","
	s json = json_"""ADiagnosName"":"""_ds.Data("ADiagnosName")_"""," 
	s json = json_"""ADemo"":"""_ds.Data("ADemo")_"""," 
	s json = json_"""AEvaluationDesc"":"""_ds.Data("AEvaluationDesc")_""","
	s json = json_"""AICDCode"":"""_ds.Data("AICDCode")_""","
	s json = json_"""AEffectsDesc"":"""_ds.Data("AEffectsDesc")_""","
	s json = json_"""ALevel"":"""_ds.Data("ALevel")_""","
	s json = json_"""AUserName"":"""_ds.Data("AUserName")_""","
	s json = json_"""ADateTime"":"""_ds.Data("ADateTime")_""""
	s json = json_"}"	
	s json =json_","
}

/// w ##Class(web.DHCMRDiagnos).GetMRDiagnosDesc(11411,";")
/// w ##Class(EMRservice.Ajax.opHISInterface).GetMRDiagnosDesc(11411,";")
ClassMethod GetMRDiagnosDescOld(MRAdmRowid As %String, DelimStr As %String) As %String
{
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.s MRStatus=""
	.s MRStatusRowid=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",9)
	.i MRStatusRowid'="" s MRStatus=$p($g(^MRC("DSTAT",MRStatusRowid)),"^",2)
 	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.i Desc'="" s Desc=Desc   ;_"  "_MRStatus
	.s i=i+1
	.s Desc=i_"."_Desc
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	q $ZCVT(retval,"O","JS")
}

//根据诊断级别，设置诊断前的空格

ClassMethod SetDiagnosLeavel(MRAdmRowid As %String) As %String
{
	s DiagnosLeavel=$P($G(^MR($P(MRAdmRowid,"||",1),"DIA",$P(MRAdmRowid,"||",2),"EPR")),"^",1) 
	q:(""=DiagnosLeavel) ""
	s prefix = "    "
	s ret=""
	for i = 2:1:DiagnosLeavel
	{
		s ret = ret_prefix
	}
	q ret
}

/// w ##Class(EMRservice.Ajax.opHISInterface).GetMRDiagnosDesc(942,"\r\n")
ClassMethod getDiag(EpisodeID, ssgroup As %String, DelimStr As %String = "\r\n") As %String
{
	s retval=""
	s i=0
	q:(EpisodeID="") "{""Value"":"""_retval_"""}"
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.s MRStatus=""
	.s MRStatusRowid=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",9)
	.i MRStatusRowid'="" s MRStatus=$p($g(^MRC("DSTAT",MRStatusRowid)),"^",2)
 	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.i Desc'="" s Desc=Desc   ;_"  "_MRStatus
	.s i=i+1
	.;s Desc=i_"."_Desc
	.s status=""
	.s st=(MRStatus'="")&&(1'=(MRStatus["确诊"))
	.;w st,!
	.i st s status=" ("_MRStatus_")"
	.;w status,!
	.s diagnosPrefix=..SetDiagnosLeavel(Rowid)
	.if retval="" s retval=Desc_status
	.e  s retval=retval_DelimStr_diagnosPrefix_Desc_status
	d obj.Close()
	//q retval
	//q $ZCVT(retval,"O","JS")
	q "{""Value"":"""_retval_"""}"
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

/// Desc:	替换掉json串中的回车换行符号
ClassMethod ReplaceEnterChar(inputStr As %String) As %String
{
	s fromStr = $c(13)
	s toStr = "\r\n"
	set count = $Length(inputStr, fromStr)
    quit:(count <= 1) inputStr
    
    set outStr = $p(inputStr,fromStr,1)
	for i = 2:1:count
	{
		set outStr = outStr_toStr_$p(inputStr,fromStr,i)
	}
	
	q outStr
}

/// 通过后台方法获取HIS功能链接
ClassMethod getOPToolsLink(func As %String = "") As %String
{
	s:(func="") func=$g(%request.Data("func", 1), "")
	if (func="DHCOPAdmRegSDSL")
	{ 
	    // 山东省立第三方预约界面
		s userLocID=%session.Get("LOGON.CTLOCID")
		s patientID=$g(%request.Data("patID", 1), "")
		
		s eastuname="sph"_%session.Get("LOGON.USERCODE")
		s eastucode=eastuname
		
		s ctlocCode=##Class(web.DHCOPAdmReg).GetDepCodeByRowid(userLocID)
		s PatDetails=##Class(web.DHCOPAdmReg).GetPatDetailsByPatientID(patientID)
		s param=eastuname_"^"_eastucode_"^"_userLocID_"^"_PatDetails
		s ret=##Class(web.DHCOPAdmReg).GetUrlString(param)
		q ret
	}	
	elseif (func="SetComplate")
	{
		s Adm=$g(%request.Data("Adm", 1), "")
		s LocId=$g(%request.Data("LocId", 1), "")
		s UserId=$g(%request.Data("UserId", 1), "")
		s IPAddress=$g(%request.Data("IPAddress", 1), "")
		s ret=##Class(web.DHCDocOutPatientList).SetComplate(Adm, LocId, UserId)
		d:($p(ret,"^",1)="0") ##class(EMRservice.BL.opInterface).AddHisDHStatInfo(Adm, LocId, UserId, IPAddress)
		q ret
	}
	elseif (func="checkUnSendPAC")
	{
		s Adm=$g(%request.Data("patID", 1), "")
		s ret = ##class(web.DHCRisApplicationBill).hasNoSendOrder(Adm)
		if (ret'="")
		{
			s id=$O(^DHCEMRM.OPHisToolsI("IdxName"," "_$zcvt("examination","U"),""))
			q:(""'=id)
			s obj = ##Class(EMRmeta.OPHisTools).%OpenId(1)
			s ret = obj.Link
		} 
		q ret
	}
	elseif (func="getOunterPage")
	{
		//s patientid=$g(%request.Data("patID", 1), "")
		S CardNo=$p(^PAPER(patientID,"ALL"),"^",9)
		s url="http://172.18.1.42/ehr/pageApi/pageApiCtrl.htm?BLHMI=getOunterPage&pageType=patmainPage&identifyCardValue="_CardNo
		q ret
	}		
	
	q ""
}

/*
      9 医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，
      9 疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，
      9 处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，
      医嘱ID，医嘱项ID，开始日期，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，
      数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，
      开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，
      医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID
*/

// 10369876  4067282 10512709

/// d ##Class(EMRservice.Ajax.opHISInterface).testFindAdmOrderItems("11143185","299")
ClassMethod testFindAdmOrderItems(epsoideid, ssgroup As %String)
{
	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	//w "columns:"_columns,!
	Set sc = rset.Execute(epsoideid, ssgroup,"","","",""," I E V ", "Y")
	While (rset.Next()) {
		if ("西药"'=rset.Get("TypeClass")) { continue }
		for col=1:1:columns {
		s name=rset.GetColumnName(col)
		w col_"   "_name_": "_rset.Get(name),!
		}
		w "===============",!
	}
	Do rset.Close()
}

/// 10369876  4067282 10512709
/// d ##Class(EMRservice.Ajax.opHISInterface).test(1067131,32)
ClassMethod test(episodeID, ssgroup As %String)
{
	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	//w "columns:"_columns,!
	//b
	Set sc = rset.Execute(episodeID,ssgroup,"","","",""," I E V ", "Y")
	While (rset.Next()) {
		//if ("西药"'=rset.GetData(56)) { continue }
		for col=1:1:columns {
		s name=rset.GetColumnName(col)
		w name_": "_rset.GetData(col),!
		}
		w "===============",!
	}
	Do rset.Close()
}

/// d ##Class(EMRservice.Ajax.opHISInterface).testZY(11143185)
ClassMethod testZY(episodeID As %String)
{
	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,"","","","","","","","Z")

	While (rset.Next()) {
		for col=1:1:columns {
		s name=rset.GetColumnName(col)
		w name_": "_rset.GetData(col),!
		}
		w "===============",!
	}
	Do rset.Close()
}

/// 医生站提供的格式化处方的方法
/// /w ##Class(web.UDHCPrescript).GetOrdInfo(184)
ClassMethod GetOrdInfo(AdmRowId As %String) As %String
{
	s OrderInfo=""
	s Num=0
	s CMSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	s CMKLSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedKLItemCat")
	s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
	s Sub=0
	for {
		s Sub=$O(^OEORD(OEOrd,"I",Sub))
		q:Sub=""
		s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
		s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
		s ItemCatRowid=$p($g(^ARCIM(+ARCIMDr,$p(ARCIMDr,"||",2),1)),"^",10)
		continue:("^"_CMSubCategory_"^")[("^"_ItemCatRowid_"^")
		continue:("^"_CMKLSubCategory_"^")[("^"_ItemCatRowid_"^")
		//w ArcimName_"@@@"_ItemCatRowid_"@@"_CMKLSubCategory_"@@@"_$P(^ARC("IC",ItemCatRowid),"^",2),!
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:OrderType'="R"
		s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
		s statcode=""
		i TtemStat'="" {
			s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
		}
		continue:statcode'="V"

		s OrderInstrRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",7)
		//w ArcimName_","_OrderInstrRowid,!
		s OrderInstrDesc=$$ALPHAUP^SSUTIL4($p(^PHCIN(OrderInstrRowid),"^",2))
		
		s OrderDoseQty=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",1) ;OEORI_DoseQty
		s OrderDoseUOMRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",3) ;OEORI_Unit_DR
		s ItemDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
		
		s OrderFreqRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",4) ; OEORI_PHFreq_DR
		s OrderFreqDesc=$P($g(^PHCFR(OrderFreqRowid)),"^",1)
		
		s OrderPackUOM=""
		s OrderPackQty=$P($G(^OEORD(OEOrd,"I",Sub,9)),"^",4) ;OEORIQtyPackUOM
		s PackUOMDR=$p($g(^OEORD(OEOrd,"I",Sub,"DHC")),"^",13)
		i PackUOMDR'="" {
			s OrderPackUOM=$p($g(^CT("UOM",PackUOMDR)),"^",2)
		}
		
		s MainOEORIDR=$P($G(^OEORD(OEOrd,"I",Sub,11)),"^",39)
		if (MainOEORIDR=""){
			s Num=Num+1
			s OneOrderInfo=Num_"、"_ArcimName_"*"_OrderPackQty_OrderPackUOM_"^"_OrderDoseQty_ItemDoseUOM_"^"_OrderFreqDesc_"^"_OrderInstrDesc
		}else{
			s OneOrderInfo="   "_ArcimName_"^"_"   "_OrderDoseQty_ItemDoseUOM_"^^"
		}
		if (OrderInfo=""){
			s OrderInfo=OneOrderInfo
		}else{
			s OrderInfo=OrderInfo_$C(2)_OneOrderInfo
		}
		
	}
	
	q OrderInfo
}

/// /w ##Class(web.UDHCPrescript).GetCMOrdInfo(184)
ClassMethod GetCMOrdInfo(AdmRowId As %String) As %String
{
	s OrderInfo=""
	///设置每行应该显示几个草药
	s CountH=2
	s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
	s QUE1RowID=0
	for {
		s QUE1RowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",AdmRowId,QUE1RowID))
		q:QUE1RowID=""
		s OnePrescInfo=""
		s PrescNo=$P(^PAQUE1(QUE1RowID),"^",14)
		continue:PrescNo=""
		s PrescCookMode=$P($g(^PAQUE1(QUE1RowID,"DHC")),"^",15)
		s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
		continue:prestype'="3"			///草药处方应该都有煎药方式才对吧-，-
		s Sub=0
		s count=0
		for {
			s Sub=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),OEOrd,Sub))
			q:Sub=""
			s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
			s statcode=""
			i TtemStat'="" {
				s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
			}
			continue:statcode'="V"
			s count=count+1
			s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
			s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
			s DoseQty=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",1)
			s OrderDoseUOMRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",3)
			s ItemDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
			s PhSpecInstr=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",8)
			s PhSpecInstrCode=##Class(web.UDHCPrescript).PhSpecInstrDesc(PhSpecInstr)
			if (PhSpecInstrCode'=""){
				s PhSpecInstrCode="("_PhSpecInstrCode_")"
			}
			if (count#CountH)=1{
				if (OnePrescInfo="") s OnePrescInfo=ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
				e  s OnePrescInfo=OnePrescInfo_"&"_ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
			}else{
				s OnePrescInfo=OnePrescInfo_"#"_ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
			}	
		}
		continue:OnePrescInfo=""
		///补齐最后一行的数据
		for i=1:1:(count#CountH) {
			s OnePrescInfo=OnePrescInfo_"#"
		}
		
		
		s OrderDurRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",10)
		s OrderDurDesc=$P($g(^PHCDU(OrderDurRowid)),"^",3)
		s PrescInstrRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",11)
		s OrderInstrDesc=$$ALPHAUP^SSUTIL4($p(^PHCIN(PrescInstrRowid),"^",2))
		s PrescCookModeDesc=##Class(web.UDHCPrescript).CookModeDesc(PrescCookMode)
		
		if (OrderInfo="") s OrderInfo=OnePrescInfo_"||"_OrderDurDesc_"  "_PrescCookModeDesc
		e  s OrderInfo=OrderInfo_$C(2)_OnePrescInfo_"||"_OrderDurDesc_"  "_PrescCookModeDesc
	}
	q OrderInfo
}

/// 通过后台方法获取HIS功能链接
ClassMethod DHCOPAdmRegSDSL(patientID As %String, userLocID As %String, usercode As %String) As %String
{
		// 山东省立第三方预约界面
		s eastuname="sph"_usercode
		s eastucode=eastuname
		
		s ctlocCode=##Class(web.DHCOPAdmReg).GetDepCodeByRowid(userLocID)
		s PatDetails=##Class(web.DHCOPAdmReg).GetPatDetailsByPatientID(patientID)
		s param=eastuname_"^"_eastucode_"^"_userLocID_"^"_PatDetails
		s ret=##Class(web.DHCOPAdmReg).GetUrlString(param)
		q ret
}

/// w ##class(EMRservice.Ajax.opHISInterface).GetMRDiagnoseCount(6420)
/// 参考自##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(6365) 修改入参由mradmID为EpisodeID 
ClassMethod GetMRDiagnoseCount(Adm As %String) As %String
{
	s DiagnoseCount=0
	
	q:($d(^PAADM(Adm))=0)||(Adm="") DiagnoseCount
	s MRADMID = $P(^PAADM(Adm),"^",61)
 	q:(MRADMID = "") DiagnoseCount
 	
	&sql(Select Count(*) into :DiagnoseCount From SQLUser.MR_Diagnos Where MRDIA_MRADM_Parref=:MRADMID)
	q DiagnoseCount
}

/// 通过后台方法获取HIS功能链接
/// w ##Class(EMRservice.Ajax.opHISInterface).DHCPHRNBYZ(1067131,32)
ClassMethod DHCPHRNBYZ(patientID As %String, usercode As %String) As %String
{
	s $zt = "Error"	
	// 宁波鄞州获取打开第三方居民健康档案
	s cardID = ##Class(EMRservice.HISInterface.PatientInfoAssist).IDCard(patientID)
	q:(cardID = "") "0"
	
	s UserCode = ##Class(web.DHCDocOrderEntry).GetUserCode(usercode)
	s UserCode = "41961191"_UserCode
	s Link = "http://172.22.2.211:8080/PersonInfo.aspx?visittype=home&idcard="_cardID_"&name=&cardid=&healthid=&headtype=&empcode="_UserCode_"&key="
	q Link
Error
	q "-1"
}

}
