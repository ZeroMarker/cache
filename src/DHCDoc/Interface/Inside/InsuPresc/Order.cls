Class DHCDoc.Interface.Inside.InsuPresc.Order Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 根据审核后的医嘱数据,得到对应的处方号数据
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetPrescStrByOrdList("71||1*6875||2*V*^69||1*6875||3*V*^")
ClassMethod GetPrescStrByOrdList(OrderStr As %String) As %String
{
	s ^jm("GetPrescStrByOrdList")=OrderStr
	s PrescStr=""
	for i=1:1:$l(OrderStr,"^"){
		s OEORIRowid=$p($p(OrderStr,"^",i),"*",2)
		continue:..CheckIsUpldByOrder(OEORIRowid)'="Y"
		s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		if (PrescStr="") {
			s PrescStr=PrescNo
		}elseif (("^"_PrescStr_"^")'[("^"_PrescNo_"^")) {
			s PrescStr=PrescStr_"^"_PrescNo
		}
	}
	Q PrescStr
}

/// 根据医嘱id判断是否进行处方流转
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).CheckIsUpldByOrder("6875||2")
ClassMethod CheckIsUpldByOrder(OEORIRowid As %String) As %String
{
	Q:OEORIRowid="" "N"
	s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
	Q:PrescNo="" "N"
	;接收科室是双通道药房的才调用
	s RecDepRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),3)),"^",6)
	s RecDepDesc=$p($g(^CTLOC(RecDepRowid)),"^",2)
	Q:RecDepDesc'["双通道" "N"
	Q "Y"
}

/// 根据就诊id和处方号获取打印的处方数据(用于外购处方的PDF生成base64串)
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetPrintInfoByPrescNo("7543","O230213000044")
ClassMethod GetPrintInfoByPrescNo(EpisodeID As %String, PrescNo As %String) As %String
{
	s ^jm("GetPrintInfoByPrescNo")=$lb(EpisodeID,PrescNo)
	;基本信息
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s HospitalDesc=$p($g(^CT("HOSP",HospitalId)),"^",2)
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	;登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)	;姓名
	s PatSex=$p(^PAPER(PatientID,"ALL"),"^",7)	;性别
	if (PatSex'="") s PatSex=$p(^CT("SEX",PatSex),"^",2)	
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID,HospitalId)	;年龄
	s PatTel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)	;联系电话
	s Address=$p($g(^PAPER(PatientID,"PER","ADD",1)),"^",1)	;现住址	
	s AdmLoc=$p(^PAADM(EpisodeID),"^",4)	;就诊科室
	if (AdmLoc'="") s AdmLoc=$p($g(^CTLOC(AdmLoc)),"^",2)
	s AdmReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)	;费别
	s BillType=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	s DiagDesc=""	;诊断
	s MRAdmRowid=$p(^PAADM(EpisodeID),"^",61)
  	s ChildSub=0 for {
		s ChildSub=$o(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""	
		s ICDCodeDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)	
		continue:ICDCodeDr=""
		s ICDDesc=$p($g(^MRC("ID",ICDCodeDr)),"^",2)
		if (DiagDesc="") s DiagDesc=ICDDesc
		else  s DiagDesc=DiagDesc_"、"_ICDDesc
	}
	;处方信息
	s Obj=##class(DHCDoc.Util.ArrayData).%New()
	s SeqNo=1
	s (DocName,AuditName,PyName,FyName,InsertDate)=""
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	s ChildSub=0 for {
		s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub)) 
		Q:ChildSub=""
		s OrdStatusDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
        s StatusCode=$case(OrdStatusDr,"":"",:$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1))
        continue:(StatusCode'="V")&&(StatusCode'="E")
		s OEORIRowid=OrderRowid_"||"_ChildSub
		s DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,0))
		continue:DspRowid=""
		s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",2)
		s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)
		if (+PackQty=0) {
			;打包表数量
			s DspRowid=0 for {
				s DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,DspRowid))
				Q:DspRowid=""
				s DspQty=$p(^DHCOEDISQTY(DspRowid),"^",5)
				s DspUomDr=$p(^DHCOEDISQTY(DspRowid),"^",6)
				s DspStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
				if ((DspStatus="C")||(DspStatus="TC")) {
					s PackQty=PackQty+DspQty
				}
			}
			s PackUomDr=$g(DspUomDr)
			if (PackUomDr="") {
				s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
				s PackUomDr=$p($g(^INCI(INCIRowid,1)),"^",10)
			}
		}else{
			s PackUomDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
		    if (PackUomDr="") s PackUomDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
	    }
  		s PackUom=$p($g(^CT("UOM",PackUomDr)),"^",2)
  		s DrugInfo=ARCIMDesc_"  X  "_PackQty_PackUom
	 	;
	 	s DoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
	 	if (DoseQty[".")&&($p(DoseQty,".",1)="") s DoseQty="0"_DoseQty
		s DoseUomDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)
		s DoseUom=$p($g(^CT("UOM",DoseUomDr)),"^",2)
		s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)
		if (InstrRowid'="") s InstrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
		s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)
  		if (FreqRowid'="") s FreqDesc=$p($g(^PHCFR(FreqRowid)),"^",3)
		s OrderNote=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1)) 
		s InstInfo="用法："_"每次"_DoseQty_DoseUom_" "_$g(InstrDesc)_" "_$g(FreqDesc)_" "_OrderNote
		;
	    s AddUserDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
	    if (AddUserDr'="") s DocName=$p($g(^SSU("SSUSR",AddUserDr)),"^",2)
		s InsertDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		d Obj.%Set("DrugInfo"_SeqNo,DrugInfo)
		d Obj.%Set("InstInfo"_SeqNo,InstInfo)
		s SeqNo=SeqNo+1
  	}
  	if (InsertDate'="") s InsertDate=$zd(InsertDate,3)
  	s rxTraceCode=""
  	s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
  	if (PrescBaseRowid'="") s rxTraceCode=$lg(^DOC.Interface.PrescBaseD(PrescBaseRowid),7)
  	;
	s Obj.HospName=HospitalDesc
	s Obj.PatNo=PatNo
	s Obj.PatName=PatName
	s Obj.PatSex=PatSex
	s Obj.PatAge=PatAge
	s Obj.PatTel=PatTel
	s Obj.Address=Address
	s Obj.AdmLoc=AdmLoc
	s Obj.BillType=BillType
	s Obj.PrescNo=PrescNo
	s Obj.Diagnose=DiagDesc
	s Obj.DocName=DocName
	s Obj.InsertDate=InsertDate
	s Obj.rxTraceCode=rxTraceCode
	Q Obj.%ToJSON().Read()
}

/// 通过待停止的医嘱数据,得到全部待停止医嘱(保证单个双通道处方的药品一起停止)
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetInsuOrdListByStop("6875||2^6875||3")
ClassMethod GetInsuOrdListByStop(OrderStr As %String) As %String
{
	s ^jm("GetInsuOrdListByStop")=OrderStr
	;获取所有的双通道处方
	s InsuPrescStr=""
	for i=1:1:$l(OrderStr,"^"){
		s OEORIRowid=$p($p(OrderStr,"^",i),"&",1)
		continue:..CheckIsUpldByOrder(OEORIRowid)'="Y"
		s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		if (InsuPrescStr="") {
			s InsuPrescStr=PrescNo
		}elseif (("^"_InsuPrescStr_"^")'[("^"_PrescNo_"^")) {
			s InsuPrescStr=InsuPrescStr_"^"_PrescNo
		}
	}
	;获取待停止医嘱
	s InsuOrdList=OrderStr
	for j=1:1:$l(InsuPrescStr,"^") {
		s PrescNo=$p(InsuPrescStr,"^",j)
		continue:PrescNo=""
		s OrderRowid=0 for {
			s OrderRowid=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid)) 
			Q:OrderRowid=""
			s ChildSub=0 for {
				s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub)) 
				Q:ChildSub=""
				s OrdStatusDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
		        s StatusCode=$case(OrdStatusDr,"":"",:$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1))
		        continue:(StatusCode'="V")&&(StatusCode'="E")
		        if (InsuOrdList="") {
					s InsuOrdList=OrderRowid_"||"_ChildSub
				}elseif ((("^"_InsuOrdList_"&")'[("^"_OrderRowid_"||"_ChildSub_"&"))&&(("^"_InsuOrdList_"^")'[("^"_OrderRowid_"||"_ChildSub_"^"))) {
					s InsuOrdList=InsuOrdList_"^"_OrderRowid_"||"_ChildSub
				}
			}
		}
	}
	Q InsuOrdList
}

/// 根据医嘱id判断是否允许撤销(目的是保证外院药房已经审核通过的药品不让医生撤销)
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).CheckPrescUndoByOrder("6875||3","1")
ClassMethod CheckPrescUndoByOrder(OEORIRowid As %String, ExpStr As %String = "") As %String
{
	s ^jm("CheckPrescUndoByOrder")=$lb(OEORIRowid,ExpStr)
	s rtn="0^"
	if (..CheckIsUpldByOrder(OEORIRowid)="Y") {
		s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
		if (PrescBaseRowid'="") {
			;调用电子处方审核结果查询接口
			s rxChkStasCodg="0"
			;s EpisodeID=$p($g(^OEORD(+OEORIRowid)),"^",1)
			;s RxChkInfoQuery=..SavePrescBaseData("rxChkInfoQuery",EpisodeID,PrescNo,ExpStr)
			;if (+RxChkInfoQuery="0") s rxChkStasCodg=$p(RxChkInfoQuery,"^",3)
			if (rxChkStasCodg="1") s rtn="-1"_"^"_"属于外购药品,医保已经审核通过,不允许撤销"
		}
	}
	Q rtn
}

/// 根据待停止的医嘱数据,得到对应的上传成功的处方号数据
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetPrescStrByStop("6876||17^6876||16")
ClassMethod GetPrescStrByStop(OrderStr As %String) As %String
{
	s ^jm("GetPrescStrByStop")=OrderStr
	s SuccPrescStr=""
	for i=1:1:$l(OrderStr,"^"){
		s OEORIRowid=$p($p(OrderStr,"^",i),"&",1)
		continue:..CheckIsUpldByOrder(OEORIRowid)'="Y"
		s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		s PrescRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
		continue:PrescRowid=""
		s CurrentStatus=$lg(^DOC.Interface.PrescBaseD(PrescRowid),13)
		continue:CurrentStatus'="1"
		if (SuccPrescStr="") {
			s SuccPrescStr=PrescNo
		}elseif (("^"_SuccPrescStr_"^")'[("^"_PrescNo_"^")) {
			s SuccPrescStr=SuccPrescStr_"^"_PrescNo
		}
	}
	Q SuccPrescStr
}

/// 保存处方流转数据
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SavePrescBaseData("uploadChk","7543","O230213000051","18881^55^28^2")
ClassMethod SavePrescBaseData(InvokeType As %String, EpisodeID As %String, PrescNo As %String, ExpStr As %String) As %String
{
	s $zt="SavePrescBaseDataErr"
	s ^jm("SavePrescBaseData")=$lb(InvokeType,EpisodeID,PrescNo,ExpStr)
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s InputObj=##class(DHCDoc.Util.ArrayData).%New()
	;医保类型
	s InputObj."HI_TYPE"="00A"
	;交易类型编码
	s InputObj."INFNO"=InvokeType
	s InputObj."InfoType"=InvokeType
	;院区ID
	s InputObj."HOSPID"=HospitalId
	;操作员ID
	s InputObj."UserId"=$p(ExpStr,"^",1)
	;?  ?  ?
	s InputObj."TYPE"="0"
	s InputObj."list_type"="102"
	s InputObj."begnrow"="1"
	;就诊号
	s InputObj."PAADM"=EpisodeID
	s InputObj."EpisodeID"=EpisodeID
	;处方号
	s InputObj."PrescNo"=PrescNo
	s InputJson=InputObj.%ToJSON().Read()
	if (InvokeType="uploadChk") {	;预核验
		Q ..SaveUploadChk(EpisodeID,PrescNo,InputJson)
	}else{
		s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
	    Q:PrescBaseRowid="" "-1^未进行处方预核验"
	    s hiRxno=$lg(^DOC.Interface.PrescBaseD(PrescBaseRowid),8)
	    Q:hiRxno="" "-1^未生成医保处方编号"
		if (InvokeType="rxFixmedinsSign") {	;签名
			Q ..SaveRxFixmedinsSign(EpisodeID,PrescNo,InputJson,ExpStr)
		}elseif (InvokeType="rxFileUpld") {	;上传
			Q ..SaveRxFileUpld(EpisodeID,PrescNo,InputJson,ExpStr)
	    }else{
		    s CurrentStatus=$lg(^DOC.Interface.PrescBaseD(PrescBaseRowid),13)
			Q:CurrentStatus'="1" "-1^该处方在医保流转系统不是有效状态"
			if (InvokeType="rxUndo") {		;撤销
    			Q ..SaveRxUndo(EpisodeID,PrescNo,InputJson,ExpStr)
			}elseif (InvokeType="hospRxDetlQuery") {	;信息查询
    			Q ..SaveHospRxDetlQuery(EpisodeID,PrescNo,InputJson)
			}elseif (InvokeType="rxChkInfoQuery") {		;审核结果查询
    			Q ..SaveRxChkInfoQuery(EpisodeID,PrescNo,InputJson)
			}elseif (InvokeType="rxSetlInfoQuery") {	;取药结果查询
    			Q ..SaveRxSetlInfoQuery(EpisodeID,PrescNo,InputJson)
			}
	    }
	}
	Q "-1"_"^"_"未找到对应方法"
SavePrescBaseDataErr
	s $zt=""
	Q "-1"_"^"_$replace($ze,"^","#")
}

/// 电子处方上传预核验
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveUploadChk()
ClassMethod SaveUploadChk(EpisodeID As %String, PrescNo As %String, InputJson As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
	s OutputObj=##class(DHCDoc.Util.ArrayData).%New()
	s OutputObj=OutputObj.%FromJSON(OutputJson)
	s rxTraceCode=OutputObj.rxTraceCode	;处方追溯码
	s hiRxno=OutputObj.hiRxno			;医保处方编号
	s OEORIRowidStr=""					;医嘱ID串
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	s ChildSub=0 for {
		s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub)) 
		Q:ChildSub=""
		s OrdStatusDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
        s StatusCode=$case(OrdStatusDr,"":"",:$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1))
        continue:(StatusCode'="V")&&(StatusCode'="E")
		if (OEORIRowidStr="") s OEORIRowidStr=OrderRowid_"||"_ChildSub
		else  s OEORIRowidStr=OEORIRowidStr_"#"_OrderRowid_"||"_ChildSub
	}
	s PrescObj=##class(DOC.Interface.PrescBase).%New()
	s PrescObj.PrescNo=PrescNo
	s PrescObj.OrderIdStr=OEORIRowidStr
	s PrescObj.rxTraceCode=rxTraceCode
	s PrescObj.hiRxno=hiRxno
	s PrescObj.CreateDate=$p($h,",",1)
	s PrescObj.CreateTime=$p($h,",",2)
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存预核验数据失败"
	}
	Q "0"_"^"_PrescObj.%Id()
}

/// 保存Base64数据
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveBase64()
ClassMethod SaveBase64(PrescNo As %String, Base64Str As %String) As %String
{
	s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
	Q:PrescBaseRowid="" "-1^未进行处方预核验"
	s Base64Stream=##Class(%CSP.CharacterStream).%New()
	if $IsObject(Base64Str){
		d Base64Stream.CopyFrom(Base64Str)
	}else{
		s obj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	    s Base64StreamOld=obj.Base64Str
	    d Base64Stream.CopyFrom(Base64StreamOld)
		d Base64Stream.Write(Base64Str)
	}
	s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	d PrescObj.Base64Str.CopyFrom(Base64Stream)
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存Base64数据失败"
	}
	Q "0"_"^"_PrescObj.%Id()
}

/// 电子处方医保电子签名
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveRxFixmedinsSign()
ClassMethod SaveRxFixmedinsSign(EpisodeID As %String, PrescNo As %String, InputJson As %String, ExpStr As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
	s OutputObj=##class(DHCDoc.Util.ArrayData).%New()
	s OutputObj=OutputObj.%FromJSON(OutputJson)
	;处方文件(医保电子签名后的base64值)
	s rxFile=OutputObj.rxFile
	s rxFileStream=##Class(%CSP.CharacterStream).%New()
	if $IsObject(rxFile){
		d rxFileStream.CopyFrom(rxFile)
	}else{
		d rxFileStream.Write(rxFile)
	}
	;签名/章摘要值
	s signDigest=OutputObj.signDigest
	s signDigestStream=##Class(%CSP.CharacterStream).%New()
	if $IsObject(signDigest){
		d signDigestStream.CopyFrom(signDigest)
	}else{
		d signDigestStream.Write(signDigest)
	}
	;签名机构证书SN
	s signCertSn=OutputObj.signCertSn
	;签名机构证书DN
	s signCertDn=OutputObj.signCertDn
    ;保存数据
    s UserID=$p(ExpStr,"^",1)
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
    d PrescObj.rxFile.CopyFrom(rxFileStream)
    d PrescObj.signDigest.CopyFrom(signDigestStream)
	s PrescObj.signCertSn=signCertSn
	s PrescObj.signCertDn=signCertDn
	s PrescObj.UpdateDate=$p($h,",",1)
	s PrescObj.UpdateTime=$p($h,",",2)
	d PrescObj.UpdateUserIDSetObjectId(UserID)
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存医保电子签名数据失败"
	}
	Q "0"_"^"_PrescObj.%Id()
}

/// 电子处方上传
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveRxFileUpld()
ClassMethod SaveRxFileUpld(EpisodeID As %String, PrescNo As %String, InputJson As %String, ExpStr As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
	s OutputObj=##class(DHCDoc.Util.ArrayData).%New()
	s OutputObj=OutputObj.%FromJSON(OutputJson)
	s rxStasCodg=OutputObj.rxStasCodg	;医保处方状态编码
	s rxStasName=OutputObj.rxStasName	;医保处方状态名称
    ;保存数据
    s UserID=$p(ExpStr,"^",1)
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	s PrescObj.CurrentStatus=rxStasCodg
	s PrescObj.UpdateDate=$p($h,",",1)
	s PrescObj.UpdateTime=$p($h,",",2)
	d PrescObj.UpdateUserIDSetObjectId(UserID)
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存电子处方上传数据失败"
	}
	Q "0"_"^"_PrescObj.%Id()
}

/// 电子处方撤销
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveRxUndo()
ClassMethod SaveRxUndo(EpisodeID As %String, PrescNo As %String, InputJson As %String, ExpStr As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
	s OutputObj=##class(DHCDoc.Util.ArrayData).%New()
	s OutputObj=OutputObj.%FromJSON(OutputJson)
	s rxStasCodg=OutputObj.rxStasCodg	;医保处方状态编码
	s rxStasName=OutputObj.rxStasName	;医保处方状态名称
    ;保存数据
    s UserID=$p(ExpStr,"^",1)
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	s PrescObj.CurrentStatus=rxStasCodg
	s PrescObj.UpdateDate=$p($h,",",1)
	s PrescObj.UpdateTime=$p($h,",",2)
	d PrescObj.UpdateUserIDSetObjectId(UserID)
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存电子处方撤销数据失败"
	}
	Q "0"_"^"_PrescObj.%Id()
}

/// 电子处方信息查询
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveHospRxDetlQuery()
ClassMethod SaveHospRxDetlQuery(EpisodeID As %String, PrescNo As %String, InputJson As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
    ;保存数据
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	s PrescObj.hospRxDetlQuery=OutputJson
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存电子处方信息查询数据失败"
	}
	Q "0"_"^"_OutputJson
}

/// 电子处方审核结果查询
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveRxChkInfoQuery()
ClassMethod SaveRxChkInfoQuery(EpisodeID As %String, PrescNo As %String, InputJson As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
    ;保存数据
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	s PrescObj.rxChkInfoQuery=OutputJson
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"保存电子处方审核结果数据失败"
	}
	Q "0"_"^"_OutputJson
}

/// 电子处方取药结果查询
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).SaveRxSetlInfoQuery()
ClassMethod SaveRxSetlInfoQuery(EpisodeID As %String, PrescNo As %String, InputJson As %String) As %String
{
	;调用接口
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputJson,"JSON","JSON")
	if (+rtn'=1) {
		Q "-1"_"^"_$replace($p(rtn,"^",2,$l(rtn,"^")),"^","#")
	}
	s OutputJson=$p(rtn,"^",2)
    ;保存数据
    s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
    s PrescObj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
	s PrescObj.rxSetlInfoQuery=OutputJson
	s sc=PrescObj.%Save()
	if $$$ISERR(sc){
	 	Q "-1"_"^"_"电子处方取药结果数据失败"
	}
	Q "0"_"^"_OutputJson
}

/*----------------------------补传界面----------------------------*/
ClassMethod GetViewScopeDescJson() As %String
{
	s DefaultValue="All"
	s Json="["
	d ..SetJson(.Json,"All","全部",DefaultValue)
	s Json=Json_","
	d ..SetJson(.Json,"Upld","已成功",DefaultValue)
	s Json=Json_","
	d ..SetJson(.Json,"UnUpld","未成功",DefaultValue)
	s Json=Json_"]"
	Q Json
}

ClassMethod SetJson(ByRef Json, id, text, defaultid)
{
	s Json=Json_"{'id':'"_id_"','text':'"_text_"'"
	if (defaultid=id){
		s Json=Json_",'selected':true"
	}
	s Json=Json_"}"
	Q
}

Query GetOrdByAdm(EpisodeID As %String, orderDesc As %String, scopeDesc As %String, StopFlag As %String) As %Query(ROWSPEC = "OEItemID,InsuResult,ARCIMDesc,DoseQty,Instr,PHFreq,Dura,PackQty,OrdStatus,PrescNo,ReLoc,OrdDepProcNotes,UserDep,Doctor,AdmReason,OrdStartDate,OrdXTime,OrderUsableDays,hiRxno")
{
}

/// 医保处方流转结果查询
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.Order","GetOrdByAdm","7543","","All","")
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String, orderDesc As %String, scopeDesc As %String, StopFlag As %String) As %Status
{
	s ^jm("GetOrdByAdm")=$lb(EpisodeID,orderDesc,scopeDesc,StopFlag)
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	;
	s obj=##class(%ResultSet).%New("web.DHCDocOPOrdInfo:GetOrdByAdm")
	d obj.Execute(EpisodeID,"")
	While (obj.Next()) {
		s OEItemID=obj.GetDataByName("OEItemID") 
		continue:OEItemID=""
		continue:'(..MatchAliasOrd(OEItemID,orderDesc))
		;是否需要进行处方流转
		continue:..CheckIsUpldByOrder(OEItemID)'="Y"
		;流转结果
		s PrescNo=obj.GetDataByName("PrescNo")
		s InsuResult=..GetInsuResultByNo(PrescNo,StopFlag,EpisodeID)
		continue:(scopeDesc="Upld")&&(InsuResult'["成功")
		continue:(scopeDesc="UnUpld")&&(InsuResult["成功")
		;是否停止
		s OrdStatusDr=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",13)
		s OrdStatusCode=$case(OrdStatusDr,"":"",:$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1))
		continue:(StopFlag="Stop")&&((OrdStatusCode="V")||(OrdStatusCode="E"))
		continue:(StopFlag'="Stop")&&((OrdStatusCode'="V")&&(OrdStatusCode'="E"))
		s ARCIMDesc=obj.GetDataByName("Desc")
		s DoseQty=obj.GetDataByName("DoseQty")
		s Instr=obj.GetDataByName("Instr") 
		s PHFreq=obj.GetDataByName("PHFreq")
		s Dura=obj.GetDataByName("Dura")
		s PackQty=obj.GetDataByName("PackQty")
		s OrdStatus=obj.GetDataByName("OrdStatus")
		s ReLoc=obj.GetDataByName("ReLoc")
		s OrdDepProcNotes=obj.GetDataByName("OrdDepProcNotes")
		s UserDep=obj.GetDataByName("UserDep")
		s Doctor=obj.GetDataByName("Doctor")
		s AdmReason=obj.GetDataByName("AdmReason")
		s OrdStartDate=obj.GetDataByName("OrdStartDate")
		s OrdXTime=obj.GetDataByName("OrdXDate")_" "_obj.GetDataByName("OrdXTime")
		s OrderUsableDays=obj.GetDataByName("OrderUsableDays")
	    d OutputRow
	}
	d obj.Close()
	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
OutputRow
	Set Data=$lb(OEItemID,InsuResult,ARCIMDesc,DoseQty,Instr,PHFreq,Dura,PackQty,OrdStatus,PrescNo,ReLoc,OrdDepProcNotes,UserDep,Doctor,AdmReason,OrdStartDate,OrdXTime,OrderUsableDays,$g(hiRxno))
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetOrdByAdmClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetOrdByAdmFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
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

ClassMethod MatchAliasOrd(oeori As %String, Alias As %String) As %String
{
	s orderParref=$P(oeori,"||",1)
	s orderId=$P(oeori,"||",2)
	s MainOrdRowID=$p($G(^OEORD(orderParref,"I",orderId,11)),"^",39)
	if (MainOrdRowID'=""){
		s orderId=$P(MainOrdRowID,"||",2)
	}
	s ItmMastDR=$p($G(^OEORD(orderParref,"I",orderId,1)),"^",2)	
	s MatchFlag=##class(web.DHCDocMain).MatchAlias(ItmMastDR,Alias)
	q:MatchFlag="1" MatchFlag
	s Sub=0 for {
		s Sub=$O(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_orderId,Sub))
		q:Sub=""
		s ItmMastDR=$p($G(^OEORD(orderParref,"I",Sub,1)),"^",2)
		s MatchFlag=##class(web.DHCDocMain).MatchAlias(ItmMastDR,Alias)
		q:MatchFlag="1"
	}
	q MatchFlag
}

/// 根据处方号获取处方流转结果
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetInsuResultByNo("O220928000003","")
ClassMethod GetInsuResultByNo(PrescNo As %String, StopFlag As %String, EpisodeID As %String) As %String
{
	s InsuResult=""
	s PrescRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
	if (StopFlag="Stop") {
		s InsuResult="无需撤回"
		if (PrescRowid'="") {
			s CurrentStatus=$lg(^DOC.Interface.PrescBaseD(PrescRowid),13)
			if (CurrentStatus="1") {
				s InsuResult="撤回失败"
			}elseif (CurrentStatus="3") {
				s InsuResult="撤回成功"
			}
		}
	}else{
		if (PrescRowid="") {
			s InsuResult="预核验失败"
		}else{
			s hiRxno=$lg(^DOC.Interface.PrescBaseD(PrescRowid),8)
			if (hiRxno="") {
				s InsuResult="预核验失败"
			}else{
				s Base64Str=$lg(^DOC.Interface.PrescBaseD(PrescRowid),4)
				if (Base64Str="") {
					s InsuResult="未生成Base64编码"
				}else{
					s signDigest=$lg(^DOC.Interface.PrescBaseD(PrescRowid),10)
					if (signDigest="") {
						s InsuResult="医保电子签名失败"
					}else{
						s CurrentStatus=$lg(^DOC.Interface.PrescBaseD(PrescRowid),13)
						if (CurrentStatus="") {
							s InsuResult="上传失败"
						}elseif (CurrentStatus="1") {
							s InsuResult="上传成功"
						}elseif (CurrentStatus="1") {
							s InsuResult="上传成功,已失效"
						}elseif (CurrentStatus="1") {
							s InsuResult="上传成功,已撤销,请及时停医嘱"
						}
					}
				}
			}
		}
	}
	Q InsuResult
}

/// 根据处方号获取Base64数据
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Order).GetRxFile("O220928000003")
ClassMethod GetPrescBase64(PrescNo As %String, Type As %String) As %String
{
	s ^jm("GetPrescBase64")=$lb(PrescNo,Type)
	Q:PrescNo="" ""
	s PrescBaseRowid=$o(^User.DHCDocPrescBaseI("IdxPrescNo",PrescNo,0))
	Q:PrescBaseRowid="" ""
	s Base64=""
    s obj=##class(User.DHCDocPrescBase).%OpenId(PrescBaseRowid)
    if (Type="HIS") s Base64Stream=obj.Base64Str
    if (Type="INSU") s Base64Stream=obj.rxFile
    if ($ISObject(Base64Stream)) {
	    s Base64=Base64Stream.Read(Base64Stream.Size)
    }
	Q Base64
}

}
