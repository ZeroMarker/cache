/// CTOR: QP
/// DATE: 2016-03-09
/// DESC: 公共类：抗菌药物统计分析模块公共Method
Class DHCAnt.QRY.Common.Method Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-05-09
/// DESC: 获取主要诊断
/// IN  : 就诊ID   argAdmDiagTypeId：主要诊断类型id
/// OUT : RowId^诊断代码^诊断描述
/// EXEC: w ##class(DHCAnt.QRY.Common.Method).GetMainDiagnos()
ClassMethod GetMainDiagnos(argAdmId As %String) As %String
{
	n (argAdmId)
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s mainDiagTypeId = ""
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	q:(mainDiagTypeId = "") ""
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// CTOR: QP
/// DATE: 2017-03-27
/// DESC: 获取药品通用名id
/// IN  : 医嘱id
/// OUT :
/// Table: PHCGeneric
/// w ##class(DHCAnt.QRY.Common.Method).GetGenericName("16||18")
ClassMethod GetGenericName(oeori) As %String
{
	n (oeori)
	s mRtn=""
	q:oeori="" mRtn
	s ord=$p(oeori,"||",1),ordSub=$p(oeori,"||",2)
	s arcitm=$p(^OEORD(ord,"I",ordSub,1),"^",2)	//医嘱项
	q:arcitm="" mRtn
    s arcord=$p(arcitm,"||",1),arcsub=$p(arcitm,"||",2)
    s genericDr=$p(^ARCIM(arcord,arcsub,8),"^",20)	//药品通用名
	s mRtn=genericDr
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-27
/// DESC: 获取医嘱类型代码
/// IN  : 
/// OUT : STAT/NORM/S/OUT	--  (即刻医嘱/临时医嘱/长期医嘱/出院带药)
/// Table: OEC_Priority
/// w ##class(DHCAnt.QRY.Common.Method).GetOrdType("16||18")
ClassMethod GetOrdType(oeori) As %String
{
	n (oeori)
	s mRtn=0
	q:oeori="" mRtn
	s ord=$p(oeori,"||",1),ordSub=$p(oeori,"||",2)
	s prioriDr=$p(^OEORD(ord,"I",ordSub,1),"^",8)
	q:prioriDr="" mRtn
	s mRtn=$p(^OECPR(prioriDr),"^",1)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-27
/// DESC: 获取医嘱状态代码
/// IN  : 
/// OUT : ""/V/U/D/C/ -- (/核实/作废/停止/撤销)
/// Table: OEC_OrderStatus
/// w ##class(DHCAnt.QRY.Common.Method).GetOrdStatusCode("16||18")
ClassMethod GetOrdStatusCode(oeori) As %String
{
	n (oeori)
	s mRtn=""
	q:oeori="" mRtn
	s ord=$p(oeori,"||",1),ordSub=$p(oeori,"||",2)
	s ordStatusId=$p(^OEORD(ord,"I",ordSub,1),"^",13)	//OECOrderStatus
	q:ordStatusId="" mRtn
	s mRtn=$p(^OEC("OSTAT",ordStatusId),"^",1)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-27
/// DESC: 获取执行记录的状态代码
/// IN  : 
/// OUT : ""/F/D/C/A/R -- (/已执行/停止/撤销/接受/拒绝执行)
/// Table: OE_OrdExec/OE_OrdExecStatus/OEC_Order_AdminStatus
/// w ##class(DHCAnt.QRY.Common.Method).GetOrdExecStatusCode("16||47||1")
ClassMethod GetOrdExecStatusCode(ordExecId) As %String
{
	n (ordExecId)
	s mRtn="",rowId=""
	q:ordExecId="" mRtn
	s ord=$p(ordExecId,"||",1),ordSub=$p(ordExecId,"||",2),ordExec=$p(ordExecId,"||",3)
	i $d(^OEORD(ord,"I",ordSub,"X",ordExec,"STCH",0)) s rowId=$o(^OEORD(ord,"I",ordSub,"X",ordExec,"STCH",""),-1)
	i (rowId'="")&&(rowId'=0) d
	.s statusId=$p(^OEORD(ord,"I",ordSub,"X",ordExec,"STCH",rowId),"^",1)
	.i statusId'="" s mRtn=$p(^OEC("STAT",statusId),"^",1)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-27
/// DESC: 根据医嘱id判断是否为抗生素
/// IN  : 
/// OUT : ""/F/D/C/A/R
/// w ##class(DHCAnt.QRY.Common.Method).ComIsAntiDrug("16||18")
ClassMethod ComIsAntiDrug(oeori) As %String
{
	n (oeori)
	s mRtn=0
	q:oeori="" mRtn
	s ord=$p(oeori,"||",1),ordSub=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	q:arcim="" mRtn
	s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)	//药学项 PHCDrgForm
	q:phcdf="" mRtn
	s phcm=+phcdf   
	s phcpo=$p(^PHCD(phcm,1),"^",4) //PHCPoison
	q:phcpo="" mRtn	//PHCDrgMast
	s phcpoCode=$zcvt($p($g(^PHCPO(phcpo)),"^",1),"U")  
    i phcpoCode["KSS" s mRtn=1
 	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-05-09
/// DESC: 是否上线了抗菌药物统计分析配置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.QRY.Common.Method).ComIsQryConfig()
ClassMethod ComIsQryConfig() As %String
{
	n 
	s mRtn=0
	i $d(^DHCAntQRYBaseRAQConfigD) s mRtn=1
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-05-09
/// DESC: 是否上线了新版抗菌药物统
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.QRY.Common.Method).ComIsNewKSSVersion()
ClassMethod ComIsNewKSSVersion() As %String
{
	n 
	s mRtn=0
	i $d(^DHCAntBaseMainConfigD) s mRtn=1
	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.QRY.Common.Method).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	n (kssarray,docId)
	s rtn=0,data=""
	s multiLen=$l(kssarray,",")
	f len=1:1:multiLen {
		s data=$p(kssarray,",",len)
		q:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据检验id获取相关描述
/// IN  : 
/// OUT : 2002559738||N0828||2||N6001||CIP||S^1^2013-05-17^2002559738^^13766^苯唑西林敏感的金黄色葡萄球菌^敏感^
///        Staphylococcus aureus (MSSA)^环丙沙星^^^细菌培养+药敏^皮下引流液^
/// 
/// EXEC: w ##class(DHCAnt.QRY.Common.Method).GetLabDescById("2002559738||N0828||2||N6001||CIP||S",1958178)
ClassMethod GetLabDescById(episInfo As %String, AdmId As %String) As %String
{
	n (episInfo,AdmId)
	
	//epis_"||"_ts_"||"_cnt_"||"_tc_"||"_ant_"||"_SenDr
	//2002559738||N0828||2||N6001||AMC||S
	s epis=$p(episInfo,"||",1)
	s ts=$p(episInfo,"||",2)
	s cnt=$p(episInfo,"||",3)
	s tc=$p(episInfo,"||",4)
	s ant=$p(episInfo,"||",5)
	s SenDr=$p(episInfo,"||",6)
	
	s AdmNo=$p(^PAADM(AdmId),"^",81)
	s Papmi=$p(^PAADM(AdmId),"^",1)
	s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	
	s RetStr=""
	s num=1
	
	s ordrowid=$o(^OEORD(0,"Adm",AdmId,"")) 
	q:ordrowid="" ""
	
	
	s AuthDate=$p(^TEPI(epis,1,ts,cnt),"\",4)
	i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
	
	s OrgCode=$p(^TEPI(epis,1,ts,cnt,"DATA",tc),"\",1)
	s (OrgName,OrgEName)=""
	i $l(OrgCode),$d(^TTAB("BUG",OrgCode)) d
	.s OrgName=$p(^TTAB("BUG",OrgCode),"\",1)
	.s OrgEName=$p(^TTAB("BUG",OrgCode),"\",3)
	
	s SenDesc=""
	i $l(SenDr),$d(^TTAB("SENS",SenDr)) s SenDesc=$p(^TTAB("SENS",SenDr),"\",1)
	
	s AntDesc=$p(^TTAB("ANT",ant),"\",1)
	s AntWhonet=$p($g(^["LABDATA"]DHCANTIBIOTICS(ant)),"\",3)
	
	s TSName=""
	i $d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)  //项目
	s SPName=""
	s SPCode=$p(^TEPI(epis,1,ts,cnt),"\",46)
	i $l(SPCode),$d(^TTAB("SPEC",SPCode)) s SPName=$p(^TTAB("SPEC",SPCode),"\",1) //标本
	s RecDate=$p(^TEPI(epis,1,ts,cnt),"\",21)
	i $l(RecDate) s RecDate=$zd(RecDate,3) //送检日期
	//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
	s list=epis_"||"_ts_"||"_cnt_"||"_tc_"||"_ant_"||"_SenDr_"^"_num_"^"_AuthDate_"^"_epis_"^^"_OrgCode_"^"_OrgName_"^"_SenDesc_"^"_OrgEName_"^"_AntDesc_"^^"_AntWhonet_"^"_TSName_"^"_SPName_"^"_RecDate
	s RetStr=RetStr_list_"!"
	s num=num+1
	s RetStr=$p(RetStr,"!",1,$l(RetStr,"!")-1)
	q RetStr
}

/// /w ##class(DHCAnt.QRY.Common.Method).GetRetStatus("2","6297")
/// 判断退药数量是否等于发药数量
ClassMethod GetRetStatus(PHRetId As %String, PHRetSub As %String) As %String
{
	n (PHRetId,PHRetSub)
	q:'$d(^DHCPHRTI(PHRetId,"RTI",PHRetSub)) 0
	s TYQty=$p(^DHCPHRTI(PHRetId,"RTI",PHRetSub),"^",3)  //退药数量
	s PHDRowid=$p(^DHCPHRET(PHRetId),"^",6)
	s OEOrdId=$p(^DHCPHRTI(PHRetId,"RTI",PHRetSub),"^",2) 
	s DSPRowId=""
	f  s DSPRowId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdId,DSPRowId)) q:DSPRowId=""  d
	.s DSPStatus=$p(^DHCOEDISQTY(DSPRowId),"^",7)
	.q:DSPStatus'="C"
	.s FYQty=$p(^DHCOEDISQTY(DSPRowId),"^",5)
	q:($g(TYQty)=$g(FYQty)) 1
	 
	q 0
}

}
