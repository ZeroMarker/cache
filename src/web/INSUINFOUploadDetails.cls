Class web.INSUINFOUploadDetails Extends (%RegisteredObject, %XML.Adaptor)
{

// 根据账单事情取医嘱信息集合[内部函数]

// s list=##class(web.INSUINFOUploadDetails).GetOEORDINFO(25113869)

// ##class(web.INSUINFOUploadDetails).GetOEORDINFO(25304100)

// w ##class(web.INSUINFOUploadDetails).GetOEORDINFO(25495959)

ClassMethod GetOEORDINFO(BILLNO As %String = "") As %ListOfDataTypes [ Internal ]
{
	s sub=$i(^||GetOEORDINFO)
	s subd=$i(^||GetOEORDINFOD)
	s rtnList=##class(%ListOfDataTypes).%New()
	q:BILLNO="" rtnList
	s OEORDInfo=""
	s mCurrRowPatientBill=$g(^DHCPB(BILLNO))
	s AdmDr=$p(mCurrRowPatientBill,"^",1)
	s AdmreasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	s AdmDr=$p(mCurrRowPatientBill,"^",1)
	s DischgDate="",DischgTime="" 
	s:AdmDr'="" DischgDate=$P(^PAADM(AdmDr),"^",17)
	s:AdmDr'="" DischgTime=$P(^PAADM(AdmDr),"^",18)
	s PBOChildSub="0"
	f  s PBOChildSub=$o(^DHCPB(BILLNO,"O",PBOChildSub)) q:(PBOChildSub="")  d
	.s PBOARCIMDR=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",3)	;取每一条医嘱的PBO_Arcim_Dr
	.s PBOOEORIDR=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",4)   ;医嘱Rowid
	.;根据项目不同判断上传标志位置也不同
	.s UpFlag=$P($$CheckOEORIUpFlag^DHCINSUOEORIUpDetails(PBOOEORIDR,PBOOEORIDR),"^",1) ;DingSH 20160520
	.q:UpFlag="Y" ;DingSH 20160520
	.q:$d(^INSUOEORDUPLOADDETAILS(PBOOEORIDR,BILLNO_"||"_PBOChildSub))	;如果没有执行记录就用此行
	.;b ;0
	.s ItmBaseInfo=##class(web.DHCINSUPortUse).GetItmBaseInfo("",PBOARCIMDR,0)
	.s PBOOrdExecDr=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",20) ;执行记录的rowid
	.s OEORIRowId=+PBOOEORIDR
	.s OEORIChildsub=$p(PBOOEORIDR,"||",2) 
	.s (DRGOrder,XDoctName,XDoctCode,DoctorName,DoctorCode,PBOOrderDate,PBOOrderTime,PBOOrderExecName,PBOOrderExecCode,OrdDeptCode,OrdDeptDesc,UomDesc,PhQtyOrd,DoseQty,YPYF,YPYFDesc,YPPC,Factor,Durat,XDate,XTime,arcitmcode,arcitmdesc,PBOOrderXDate,PBOOrderXTime,OEORIArcItmCatCode)=""
	.s OEORDDoctorDr=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",11)
	.i OEORDDoctorDr'="" d
	..s DoctorName=$p($g(^CTPCP(OEORDDoctorDr,1)),"^",2)   ///医生
	..s DoctorCode=$p($g(^CTPCP(OEORDDoctorDr,1)),"^",1)
	.s PBOOrderDate=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",12)	;医嘱日期
	.s PBOOrderTime=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",13)	;医嘱时间
	.i ((DischgDate'="")&&(DischgDate-PBOOrderDate)<0) d
	..s PBOOrderDate=DischgDate
	..s PBOOrderTime=DischgTime 
	.i PBOOrderDate'=""  d
	..s PBOOrderDate=$zd(PBOOrderDate,3)
	.i PBOOrderTime'=""  d
	..s PBOOrderTime=$zt(PBOOrderTime)
	..s PBOOrderTime=PBOOrderDate_" "_PBOOrderTime ;DingSH 16-05-18
	.s XDate=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,3),"^",34) //结束日期
	.s:XDate'="" XDate=$zd(XDate,3)
	.s:$d(^OEORD(OEORIRowId,"I",OEORIChildsub,2)) XTime=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,2),"^",15) //结束时间
	.s:XTime'="" XTime=$zt(XTime)
	.s:XTime'="" XTime=XDate_" "_XTime ;DingSH 16-05-18
	.s XDoctorDr=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,3)),"^",29)
	.i XDoctorDr'="" d ;DingSH 20160520
	..s XDoctName=$p($g(^CTPCP(XDoctorDr,1)),"^",2)   ///医生
	..s XDoctCode=$p($g(^CTPCP(XDoctorDr,1)),"^",1)
	.i XDoctCode="" d
	..s XDoctCode=DoctorCode
	..s XDoctName=DoctorName
	.s DRGOrder=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,6)),"^",6)  	;add by DingSH 单病种
	.i $g(DRGOrder)'="" d
	..s DRGOrder=$p($g(^DHCDiagnosCat(DRGOrder)),"^",6)
	
	.s arcitmcode=$p(^ARCIM(+PBOARCIMDR,$p(PBOARCIMDR,"||",2),1),"^",1)	;医嘱项代码
	.s arcitmdesc=$p(^ARCIM(+PBOARCIMDR,$p(PBOARCIMDR,"||",2),1),"^",2)	;医嘱项
	.s ArcGrp=$p($g(^ARCIM(+PBOARCIMDR,$p(PBOARCIMDR,"||",2),1)),"^",10) ;医嘱子类Dr
	.s OEORIArcItmCatCode=$p($g(^ARC("IC",ArcGrp)),"^",1) ;医嘱子分类Code
	.s CatGrp=$p($g(^ARC("IC",ArcGrp)),"^",8)                           ;医嘱大类             
	.s OrdCateType=$p($g(^ARC("IC",ArcGrp)),"^",7)                      ;R为药品
	.;q:OrdCateType'="R"	;测试用
	.s OEPriorDr=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",8)   ;指向医嘱类型->OEC_Priority
	.s OEPirorCode=$p($g(^OECPR(+OEPriorDr)),"^",1)	;医嘱类型代码;(STAT^即刻;PRN^PRN,NORM^临时;ONE^取药;S^长期;OM^自备药即刻;OUT^出院带药;OMST^自备药长期)
	
	.;b ;1
	.s PBOUnitPrice=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",7)	;单价
	.s PBOBillQty=+$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",5)		;数量
	.s PBOReFundQty=+$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",6)	;回退数量
	.s PBOBillQty=PBOBillQty+PBOReFundQty	;合计数量
	.s PBOToTalAmount=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",8)	;金额
	.;q:(PBOToTalAmount=0)
	
	.s UnitDR=+$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,2)),"^",3) ///剂量单位 OEORI_Unit_DR
	.i +UnitDR=0 d
	..s PBDTARIDR=$o(^DHCOLT(0,"ARTTA",PBOARCIMDR,""),-1)
	..s:PBDTARIDR'="" UnitDR=+$p(^DHCTARI(PBDTARIDR),"^",3)
	..i +UnitDR=0 d
	...s UomDesc="次"
	..e  s UomDesc=$p(^CT("UOM",UnitDR),"^",1)
	.e  s UomDesc=$p(^CT("UOM",UnitDR),"^",1)
	.s PhQtyOrd=+$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",12) //总剂量 OEORI_PhQtyOrd
	.s DoseQty=+$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,2)),"^",1) //单次数量 OEORI_DoseQty
	.i +DoseQty=0 d
	..s DoseQty=1
	.s PLDR=+$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,2)),"^",4) //频率 OEORI_PHFreq_DR
	.i PLDR=0 d
	..s YPPC=""
	.e  s YPPC=$P($g(^PHCFR(PLDR)),"^",1) //频次
	.s DuratDR=+$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,2)),"^",6) //疗程(天数)
	.i +DuratDR=0 d
	..s Durat=1
	.e  s Durat=+$P(^PHCDU(DuratDR),"^",2)
	
	.s OEORIInstrDR=$p($G(^OEORD(OEORIRowId,"I",OEORIChildsub,2)),"^",7) //用法
	.i OEORIInstrDR'="" s YPYF=$p(^PHCIN(OEORIInstrDR),"^",1) , YPYFDesc=$p(^PHCIN(OEORIInstrDR),"^",2) //用法
	.;b ;0
	
	.s OrdDeptDR=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,1),"^",3)  ///开单科室
	.i OrdDeptDR'="" s OrdDeptDesc=$p(^CTLOC(OrdDeptDR),"^",2),OrdDeptCode=$p(^CTLOC(OrdDeptDR),"^",1)
	.s RecDepDR=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,3),"^",6)   ///如果开单科室为空就取接收科室
	.i (RecDepDR'="")&(OrdDeptCode="") s OrdDeptDesc=$p(^CTLOC(RecDepDR),"^",2),OrdDeptCode=$p(^CTLOC(RecDepDR),"^",1)
	
    .i $d(^||GetOEORDINFO(sub,PBOOEORIDR))=0 d
    ..s oeobj=##class(web.INSUOEORDInfo).%New()
    ..s oeobj.PBORowId=BILLNO_"||"_PBOChildSub	;不建议用此做流水号
	..s oeobj.OEORICatType=CatGrp
	..s oeobj.OEORIArcItmCatCode=OEORIArcItmCatCode ;医嘱子分类Code ;DingSH 160524
	..s oeobj.BZGG=$p(ItmBaseInfo,"^",5)	;包装规格
	..s oeobj.DoseQty=DoseQty	;剂量
	..s oeobj.DoseQtyUom=UomDesc	;剂量单位
	..s oeobj.Durat=DuratDR	;疗程
	..s oeobj.GG=$p(ItmBaseInfo,"^",4)
	..s oeobj.Instr=YPYF	;用法Code;需要对照
	..s oeobj.InstrDesc=YPYFDesc	;用法描述
	..s oeobj.OEORICode=arcitmcode
	..s oeobj.OEORIDATE=PBOOrderDate
	..s oeobj.OEORIDesc=arcitmdesc
	..s oeobj.OEORIDoctor=DoctorName
	..s oeobj.OEORIDoctorCode=DoctorCode ;DingSH 20160520
	..s oeobj.OEORIStopDoctor=XDoctName
	..s oeobj.OEORIStopDoctorCode=XDoctCode
	..s oeobj.OEORIOrdDeptCode=OrdDeptCode
	..s oeobj.OEORIOrdDeptDesc=OrdDeptDesc
	..s oeobj.OEORIRowid=PBOOEORIDR
	..s oeobj.OEORITIME=PBOOrderTime
	..;s OEPirorCode=$Case(OEPirorCode,"STAT":2,"NORM":2,"OUT":3,"ONE":2,"S":1,"OM":2,"OMST":1,"":2) ;DingSH2016
	..s oeobj.OEORIType=OEPirorCode	;医嘱类型
	..s oeobj.PHFreq=YPPC	;频次	;需要对照
	..s oeobj.PhQtyOrd=PhQtyOrd	;总剂量
	..s oeobj.XString1=DRGOrder
    .e  d
    ..s oeobj=rtnList.GetAt(^||GetOEORDINFO(sub,PBOOEORIDR))
	.i PBOOrdExecDr'="" d ///执行记录 要求执行时间
	..s tmpPBOOrdExecDr=PBOOrdExecDr
	..q:$d(^INSUOEORDUPLOADDETAILS(PBOOEORIDR,PBOOrdExecDr))
	..s PBOOrderXDate=$zd($p($g(^OEORD($P(PBOOrdExecDr,"||",1),"I",$P(PBOOrdExecDr,"||",2),"X",$P(PBOOrdExecDr,"||",3))),"^",1),3)
	..s PBOOrderXTime=$zt($p($g(^OEORD($P(PBOOrdExecDr,"||",1),"I",$P(PBOOrdExecDr,"||",2),"X",$P(PBOOrdExecDr,"||",3))),"^",2)) 
	..s PBOOrderXTime=PBOOrderXDate_" "_PBOOrderXTime ;DingSH 16-05-18
	..s PBOOrderExecDoctorDr=$p($g(^OEORD($P(PBOOrdExecDr,"||",1),"I",$P(PBOOrdExecDr,"||",2),"X",$P(PBOOrdExecDr,"||",3),"STCH",1)),"^",5) 
	..i PBOOrderExecDoctorDr="" d
	...s PBOOrderExecName=""
	..e  d
	...s PBOOrderExecName=$p($g(^SSU("SSUSR",PBOOrderExecDoctorDr)),"^",2) ///执行人
	...s PBOOrderExecCode=$p($g(^SSU("SSUSR",PBOOrderExecDoctorDr)),"^",1) ///执行人Code
    ..s XXDate=$p(^OEORD(+PBOOrdExecDr,"I",$p(PBOOrdExecDr,"||",2),"X",$p(PBOOrdExecDr,"||",3)),"^",12)
    ..s:XDate'="" XDate=$zd(XXDate,3)
    ..s XXTime=$p(^OEORD(+PBOOrdExecDr,"I",$p(PBOOrdExecDr,"||",2),"X",$p(PBOOrdExecDr,"||",3)),"^",14)
    ..s:XTime'="" XTime=$zt(XXTime)
    ..s:XTime'="" XTime=XDate_" "_XTime ;DingSH 16-05-18
    ..q:$d(^INSUOEORDUPLOADDETAILS(PBOOEORIDR,tmpPBOOrdExecDr))
	..s execObj=##class(web.INSUOEORDInfoSub).%New()
	..s execObj.OEExecDATE=PBOOrderXDate
	..s execObj.OEExecDoctor=PBOOrderExecName
	..s execObj.OEExecDoctorCode=PBOOrderExecCode
	..s execObj.OEExecDr=PBOOrdExecDr
	..s execObj.OEExecTIME=PBOOrderXTime
	..s execObj.OEExecDr=PBOOrdExecDr
	..;d oeobj.OEORIExe.Insert(execObj)	;
	.e  d	;无执行记录的医院（或门诊）
	..s tmpPBOOrdExecDr=BILLNO_"||"_PBOChildSub
    ..q:$d(^INSUOEORDUPLOADDETAILS(PBOOEORIDR,tmpPBOOrdExecDr))
	..s execObj=##class(web.INSUOEORDInfoSub).%New()
	..s execObj.OEExecDATE=PBOOrderDate
	..s execObj.OEExecDoctor=DoctorName
	..s execObj.OEExecDoctorCode=DoctorCode
	..s execObj.OEExecDr=tmpPBOOrdExecDr
	..s execObj.OEExecTIME=PBOOrderTime
	..s execObj.OEExecDr=PBOOrdExecDr
	..;d oeobj.OEORIExe.Insert(execObj)	;
	.;s TarObj=##class(web.INSUOEORDTarInfoSub).%New() ;DingSH 20160521 注释掉 句柄相同插入到list中会有问题,都是相同的
	.s PBDChildSub="0",ind=0	;循环账单的明细表,主要是取收费项及单价等,
	.;k ^CacheTemp("TarIsExistsId")
	.f  s PBDChildSub=$o(^DHCPB(BILLNO,"O",PBOChildSub,"D",PBDChildSub)) q:(PBDChildSub="")  d
	..s mCurrRowPatBillDetails=$g(^DHCPB(BILLNO,"O",PBOChildSub,"D",PBDChildSub))
	..s PBDID=BILLNO_"||"_PBOChildSub_"||"_PBDChildSub     ;add 2007 01 29 
	..s PBAdmDr=$p(mCurrRowPatientBill,"^",1)
	..s PBPayedFlag=$p(mCurrRowPatientBill,"^",16)
	..s PBDateFrom=$ZD($p(mCurrRowPatientBill,"^",6),3)
	..s PBDateTo=$ZD($p(mCurrRowPatientBill,"^",7),3)
	..s PBDTARIDR=$p(mCurrRowPatBillDetails,"^",3)
	..s BillQty=$p(mCurrRowPatBillDetails,"^",5)
	..s UnitPrice=$p(mCurrRowPatBillDetails,"^",4)
	..;q:(BillQty=0)!(UnitPrice=0)
	..s TotalAmount=$p(mCurrRowPatBillDetails,"^",7)
    ..s tarDr=$p(mCurrRowPatBillDetails,"^",3)
    ..s tmpdind=0
	..i $d(^||GetOEORDINFOD(subd,tmpPBOOrdExecDr,tarDr))=0 d
	...s TarObj=##class(web.INSUOEORDTarInfoSub).%New() ;DingSH 20160521
	...s ind=ind+1
	...s ^||GetOEORDINFOD(subd,tmpPBOOrdExecDr,tarDr)=ind
	...s tmpdind=ind
	...;b ;011
	..e  d
	...s tmpdind=^||GetOEORDINFOD(subd,tmpPBOOrdExecDr,tarDr)
	...s TarObj=execObj.OEORITar.GetAt(tmpdind)
	...;d execObj.OEORITar.RemoveAt(tmpdind) 
	...;b ;012
	..s TarObj.TarDr=tarDr
	..s TarObj.TARICode=$p(^DHCTARI(tarDr),"^",1)
	..s TarObj.TARIDesc=$p(^DHCTARI(tarDr),"^",2)
	..s TarObj.Pricce=UnitPrice
	..s TarObj.Qty=TarObj.Qty+BillQty
	..s TarObj.Amount=TarObj.Amount+TotalAmount
	..s TarObj.UOMDesc=UomDesc	;单位
	
	..d execObj.OEORITar.InsertAt(TarObj,tmpdind)
	..d execObj.OEORITar.InsertAt(TarObj,tmpdind)	;test
	.d oeobj.OEORIExe.Insert(execObj)	;
	
	.;;test->
	.;s tmpexeobj=##class(web.INSUOEORDInfoSub).%New()
	.;s tmpexeobj.OEExecDATE=PBOOrderDate
	.;s tmpexeobj.OEExecDoctor=DoctorName
	.;s tmpexeobj.OEExecDoctorCode=DoctorCode
	.;s tmpexeobj.OEExecDr=execObj.OEExecDr_"-1"
	.;d oeobj.OEORIExe.Insert(tmpexeobj)	;<-test
	
	.i $d(^||GetOEORDINFO(sub,PBOOEORIDR))=0 d
	..;b ;01
	..d rtnList.Insert(oeobj)
	..s ^||GetOEORDINFO(sub,PBOOEORIDR)=1
	.e  d
	..;b ;02
	..d rtnList.InsertAt(oeobj,^||GetOEORDINFO(sub,PBOOEORIDR))
	..s ^||GetOEORDINFO(sub,PBOOEORIDR)=+^||GetOEORDINFO(sub,PBOOEORIDR)+1
	..;b ;03
	;k ^CacheTemp("TarIsExistsId")
	q rtnList
}

// 根据账单事情取医嘱信息集合[内部函数]

// s list=##class(web.INSUINFOUploadDetails).GetDiagnosINFO(25113869)

// w ##class(web.INSUINFOUploadDetails).GetDiagnosINFO(10)

ClassMethod GetDiagnosINFO(PAADM As %String = "") As %ListOfDataTypes [ Internal ]
{
	s rtnList=##class(%ListOfDataTypes).%New()
	q:PAADM="" rtnList
	s count=0
	s MRadm=$p($g(^PAADM(PAADM)),"^",61) ;指向MRADM
	Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")  //DingSH 20210108 
	do rset.Execute(MRadm,"","","1")
	While (rset.Next()) {
		s tmpldiagobj=##class(web.INSUDIAGsInfo).%New()
		s MRCRowid=rset.GetDataByName("DiagnosValue")	;诊断表ID(User.MRDiagnos)
		s tmpldiagobj.MRCRowid=MRCRowid
		;s DiagnosCodeRowid=rset.GetDataByName("DiagnosCodeRowid")	;诊断代码表ID(User.MRCICDDx)
		s tmpldiagobj.MRCCode=rset.GetDataByName("DiagnosICDCode")	;诊断代码表ICD代码
		s tmpldiagobj.MRCDesc=rset.GetDataByName("DiagnosDesc")	;ICD诊断描述
		s tmpldiagobj.MRCNode=rset.GetDataByName("DiagnosMRDesc")	;诊断注释
		
		s tmpldiagobj.MRCType=rset.GetDataByName("DiagnosType")	;诊断类型描述
		s tmpldiagobj.MRCDateTime=rset.GetDataByName("DiagnosDate")	;诊断日期
		;s DiagnosOnsetDate=rset.GetDataByName("DiagnosOnsetDate")	;发病日期
		;s DiagStat=rset.GetDataByName("DiagStat")	;诊断状态描述
		;s DiagnosLeavel=rset.GetDataByName("DiagnosLeavel")	;诊断级别(数字)
		s mrcStr=^MR($p(MRCRowid,"||",1),"DIA",$p(MRCRowid,"||",2))
		s ctpcpstr="",ctpcpstr2=""
		s docdr=$p(mrcStr,"^",4)	//诊断医生
		s mrdate=$p(mrcStr,"^",7)
		s mrtime=$p(mrcStr,"^",8)
		s:mrdate'="" tmpldiagobj.MRCDateTime=$zd(mrdate,3)_" "_$zt(mrtime,1)
		s:docdr'="" ctpcpstr=^CTPCP(docdr,1),ctpcpstr2=^CTPCP(docdr,2)
		s tmpldiagobj.MRCDocCode=$p(ctpcpstr,"^",1)	//诊断医生编码
		s tmpldiagobj.MRCDocDesc=$p(ctpcpstr,"^",2)
		s tmpldiagobj.MRCDocID=$p(ctpcpstr2,"^",8)	//执业资格证号
		
		s admDocDr=$p(^PAADM(PAADM),"^",9)  //主治医生
		s ctpcpstr="",ctpcpstr2=""
		s:admDocDr'="" ctpcpstr=^CTPCP(docdr,1),ctpcpstr2=^CTPCP(docdr,2)
		s tmpldiagobj.MRCMDocCode=$p(ctpcpstr,"^",1)	//主治医生编码
		s tmpldiagobj.MRCMDocDesc=$p(ctpcpstr,"^",2)
		s tmpldiagobj.MRCMDocID=$p(ctpcpstr2,"^",8)	//执业资格证号
		
		s tmpldiagobj.MRCId=count
		
		s count=count+1
		d rtnList.Insert(tmpldiagobj)
	}
	d rset.Close()
	
	q rtnList
}

// ----------------------------------------------------------------------------------------------//

// 保存上传记录

// 入参：InArgs：医嘱明细ID$执行记录ID

ClassMethod SaveUploadFlag(InArgs As %String, ExtStr As %String) As %String
{
	q:InArgs="" -1
	s cnt=$l(InArgs,"^")
	f i=1:1:cnt d
	.s tmpoeidstr=$P(InArgs,"^",i)
	.s tmpoeid=$p(tmpoeidstr,"$",1)
	.s tmpoeExeid=$p(tmpoeidstr,"$",2)
	.q:(tmpoeid="")||(tmpoeExeid="")
	.s ^INSUOEORDUPLOADDETAILS(tmpoeid,tmpoeExeid)=$p(tmpoeidstr,"$",3)_"^"_ExtStr
	q 0
}

// 获取上传记录

// 入参：BillNo：账单

ClassMethod GetUploadFlag(BILLNO As %String, ExtStr As %String) As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	q:(BILLNO="") objstream
	s OEORDInfo=""
	s mCurrRowPatientBill=$g(^DHCPB(BILLNO))
	s AdmDr=$p(mCurrRowPatientBill,"^",1)
	s AdmreasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	s PBOChildSub="0"
	f  s PBOChildSub=$o(^DHCPB(BILLNO,"O",PBOChildSub)) q:(PBOChildSub="")  d
	.s PBOOEORIDR=$p($g(^DHCPB(BILLNO,"O",PBOChildSub)),"^",4)   ;医嘱Rowid
	.q:$d(^INSUOEORDUPLOADDETAILS(PBOOEORIDR))=0
	.d objstream.Write(PBOOEORIDR_$c(0))
	q objstream
}

// 删除上传记录

// 入参：InArgs：医嘱明细ID$执行记录ID

ClassMethod DelUploadFlag(InArgs As %String, ExtStr As %String) As %String
{
	q:InArgs="" -1
	s cnt=$l(InArgs,"^")
	f ind=1:1:cnt d
	.s tmpoeidstr=$P(InArgs,"^",ind)
	.s tmpoeid=$p(tmpoeidstr,"$",1)
	.s tmpoeExeid=$p(tmpoeidstr,"$",2)
	.q:(tmpoeid="")
	.i tmpoeExeid="" d
	..k ^INSUOEORDUPLOADDETAILS(tmpoeid)
	.e  d
	..k ^INSUOEORDUPLOADDETAILS(tmpoeid,tmpoeExeid)
	q 0
}

}
