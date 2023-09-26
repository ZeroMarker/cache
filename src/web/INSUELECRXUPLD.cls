/// 电子处方信息上传信息操作类
Class web.INSUELECRXUPLD Extends %RegisteredObject
{

/// 
/// 入参：	
/// 			Param:入参数组
///                    Param.GetAt("EpisodeID"):就诊rowid
///                    Param.GetAt("INFNO"):交易编号(3101,3102)
///                    Param.GetAt("HOSPID"):医院ID
///                    Param.GetAt("UserId"):操作员ID
///                    Param.GetAt("InsuType"):医保类别(00A,00B)
///             dataInputArgArr:data节点数组
/// ##class(INSU.OFFBIZ.BL.BIZ00A).InsuDocDetailedAuditService(Param,dataInputArgArr)
/// 出参：
/// 		成功:1^接口输出报文；失败：-1^描述
ClassMethod InsuDocDetailedAuditService(Param As %ArrayOfDataTypes, dataInputArgArr As %ArrayOfDataTypes, InsuType As %String = "00A") As %String
{
	//n (Param,dataInputArgArr)
	s rtnstr=""
	;s InsuType="00A"
	s InArgOBJ=##class(%ArrayOfDataTypes).%New()
	d InArgOBJ.SetAt(InsuType,"HI_TYPE")	;医保类型
	d InArgOBJ.SetAt(Param.GetAt("INFNO"),"INFNO")	;接口编号
	d InArgOBJ.SetAt(Param.GetAt("HOSPID"),"HOSPID")	;医院编号
	d InArgOBJ.SetAt(Param.GetAt("UserId"),"UserId")	;操作员ID

	q:InArgOBJ.GetAt("HI_TYPE")="" "-1^医保类型不能为空"
	q:InArgOBJ.GetAt("INFNO")="" "-1^交易编号不能为空"
	q:InArgOBJ.GetAt("HOSPID")="" "-1^医院ID不能为空"
	q:InArgOBJ.GetAt("UserId")="" "-1^操作员不能为空"
	
	s OutArgType=Param.GetAt("RTNSTR")
	
	s:OutArgType="" OutArgType="JSON"
	d InArgOBJ.SetAt(OutArgType,"RTNSTR")	;是否返回生成的字符串，STR:字符串
    s InArgType=""
	s InArgPortArr=##class(%ArrayOfDataTypes).%New()
	s rtnstr=##class(INSU.OFFBIZ.ADP.DataCom).DataAdpComBydataInput(InArgOBJ,InArgType,.InArgPortArr,dataInputArgArr)
	q:$p(rtnstr,"^",1)<0 rtnstr
	s rtnStr=##class(INSU.OFFBIZ.BI.CN00A).INSUAPI(rtnstr,InArgPortArr)
	//b ;w rtnStr
	q rtnStr
}

/// debugger: w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetParamObj(7275037,"3101",41,1)
ClassMethod GetParamObj(EpisodeID As %String, Type As %String, AdmReasonDr As %String, UserId As %String, InsuType As %String, HospDr As %String, Json As %String = "") As %ArrayOfDataTypes
{
	s Obj=##class(%ArrayOfDataTypes).%New()
	;s HospitalId="2"
	;s InsuType="00A"
	s HospitalId=HospDr
	s InsuType=InsuType
	s ParamObj=##class(%ArrayOfDataTypes).%New()
	d ParamObj.SetAt(Type,"INFNO")
	d ParamObj.SetAt(EpisodeID,"EpisodeID")
	d ParamObj.SetAt(HospitalId,"HOSPID")
	d ParamObj.SetAt(UserId,"UserId")
	d ParamObj.SetAt(InsuType,"InsuType")
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ParamObj)
		s JsonStr=JsonStream.Read()
		q JsonStr
	}

	q ParamObj
}

/// ---------------------------------------7101 start----------------------------------
/// Description: 【7101】电子处方上传	处方信息 data
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetPrescInfoTo7101","O22050800001")
/// Call web.NationInsuInfoUpload_GetPrescInfoTo7101("O22050800001")
Query GetPrescInfoTo7101(PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "hosp_rxno,init_rxno,rx_type_code,prsc_time,rx_drug_nums,rx_way_codg,rx_way_name,rx_freq_codg,rx_freq_name,rx_dosunt,rx_doscnt,rx_drord_dscr,valid_days,valid_end_time,rept_flag,max_rept_cnt,reptd_cnt,min_inrv_days,dr_sign_info,phar_sign_info,fixmedins_sign_info,rx_cotn_flag,rx_file") [ SqlProc ]
{
}

ClassMethod GetPrescInfoTo7101Execute(ByRef qHandle As %Binary, PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
	
	s (hosprxno,initrxno,rxtypecode,prsctime,rxdrugnums,rxwaycodg,rxwayname,rxfreqcodg,rxfreqname,rxdosunt,rxdoscnt,rxdrorddscr,validdays,validendtime,reptflag,maxreptcnt,reptdcnt,mininrvdays,drsigninfo,pharsigninfo,fixmedinssigninfo,rxcotnflag,rxfile)=""
	
	
	s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,""))
	i OEOrdRowID="" {
		quit $$$OK
	}
	s ItemType="",OrdDT="",duratfact="1",GJInstrCode="",GJInstrDesc="",GJFreqCode="",GJFreqDesc=""
	s EdDT=""
	s OEOrdItemSub=""
	f {
		s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,OEOrdItemSub)) q:(OEOrdItemSub="")||(ItemType'="")
		s ArcimID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",2)
		s ArcimRowID=$P(ArcimID,"||",1)
		continue:ArcimRowID=""
		s ArcimSub=$P(ArcimID,"||",2)
		continue:ArcimSub=""
		continue:'$d(^ARCIM(ArcimRowID,ArcimSub,1))
		S ItemCatDR=$p($g(^ARCIM(ArcimRowID,ArcimSub,1)),"^",10)
		s ItemType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
		S OrdDate=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,3)),"^",7)		// 开嘱日期
		S OrdTime=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",17)		// 开嘱时间
		i (OrdDate'="")&&(OrdTime'="") s OrdDT=$zd(OrdDate,3)_" "_$zt(OrdTime,1)
		s DuratDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",6)		// 疗程
		s duration="",duratfact="1"
		i DuratDR'="" {
			s duration=$p($g(^PHCDU(DuratDR)),"^",3)
			s duratfact=$p($g(^PHCDU(DuratDR)),"^",2)
		}
		s InstrDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",7)		// 用法 用药途径
		i InstrDR'="" s InstrDesc=$p($g(^PHCIN(InstrDR)),"^",2)
		e  s InstrDesc=""
		;s GJInstrCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,6,HospDr)
		;s GJInstrDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,7,HospDr)
		;upt Hanzh 20220712
 		s GJInstrInfo=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,0,HospDr)
 		s GJInstrCode=$p(GJInstrInfo,"^",6)
 		s GJInstrDesc=$p(GJInstrInfo,"^",7) 
 		
		s FreqDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",4)		// 频率
		i FreqDR'="" s FreqDesc=$p($g(^PHCFR(FreqDR)),"^",3)
		e  s FreqDesc=""
		;s GJFreqCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,6,HospDr)
		;s GJFreqDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,7,HospDr)	
		;upt Hanzh 20220712
 		s GJFreqInfo=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,0,HospDr)
 		s GJFreqCode=$p(GJFreqInfo,"^",6)
 		s GJFreqDesc=$p(GJFreqInfo,"^",7) 
		s DoseQty=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",1)		// 单次剂量
		s DoseQtyUomDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",3)		// 单次剂量单位
		i DoseQtyUomDR'="" s DoseQtyUom=$p($g(^CT("UOM",DoseQtyUomDR)),"^",2)
		e  s DoseQtyUom=""
		s PackQty=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,9)),"^",4)		// 数量 整
		s PackQtyUomDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,"DHC")),"^",13)		// 数量单位
		i PackQtyUomDR'="" s PackQtyUom=$p($g(^CT("UOM",PackQtyUomDR)),"^",2)
		e  s PackQtyUom=""
		
		s Note=$g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,"DEP",1))		// 备注
		s JDRemarks=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,"DHC")),"^",37)		// 静滴备注
		s CYNote=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",8)		// 草药备注
		s Notes=""							// 全部备注
		i Note'="" {
			i Notes'="" s Notes=Notes_","_Note
			e  s Notes=Note
		}
		i JDRemarks'="" {
			i Notes'="" s Notes=Notes_","_JDRemarks
			e  s Notes=JDRemarks
		}
		i CYNote'="" {
			i Notes'="" s Notes=Notes_","_CYNote
			e  s Notes=CYNote
		}
		
		s StDate=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",9)		// 医嘱开始日期
		s StTime=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",10)		// 医嘱开始时间
		s ValiEndDate=StDate+duratfact
		i (StDate'="")&&(StTime'="") s StDT=$zd(StDate,3)_" "_$zt(StTime,1),EdDT=$zd(ValiEndDate,3)_" "_$zt(StTime,1)
	}
	
	s hosprxno=PrescNo    // 定点医疗机构处方编号
	s initrxno=""    // 续方的原处方编号
	s rxtypecode=$case(ItemType,1:1,2:10,3:9,5:8,:99)    // 处方类别代码
	s prsctime=OrdDT    // 开方时间
	s rxdrugnums=PackQty    // 药品数量（剂数）
	s rxwaycodg=GJInstrCode    // 处方整剂用法编号
	s rxwayname=GJInstrDesc    // 处方整剂用法名称
	s rxfreqcodg=GJFreqCode    // 处方整剂频次编号
	s rxfreqname=GJFreqDesc    // 处方整剂频次名称
	s rxdosunt=DoseQty    // 处方整剂剂量单位
	s rxdoscnt=DoseQtyUom    // 处方整剂单次剂量数
	s rxdrorddscr=Notes    // 处方整剂医嘱说明
	s validdays=duratfact    // 处方有效天数
	s validendtime=EdDT    // 有效截止时间
	s reptflag="0"    // 复用（多次）使用标志 0否，1是
	s maxreptcnt=""    // 最大使用次数
	s reptdcnt=""    // 已使用次数
	s mininrvdays=""    // 使用最小间隔（天数）
	s drsigninfo="123"    // 开方医生电子签名信息
	s pharsigninfo="123"    // 审方药师电子签名信息
	s fixmedinssigninfo="123"    // 定点医疗机构签章信息
	s rxcotnflag="0"    // 续方标志	0否，1是
	s rxfile="JVBERi0xLjQKJcDIzNINCjEgMCBvYmoKPDwKL1RpdGxlIDxGRUZGODM2RjU0QzE4RDI2OUY4NDk1RUU5ODk4MDAyRTAwNjQwMDZGMDA2MzAwNzg+Ci9BdXRob3IgKEFkbWluc3RyYXRvcikKL0NyZWF0b3IgKHBkZkZhY3RvcnkgUHJvIHd3dy5maW5lcHJpbnQuY24pCi9Qcm9kdWNlciAocGRmRmFjdG9yeSBQcm8gMy41MiBcKFdpbmRvd3MgTlQgMTAuMDAgeDY0IENoaW5lc2UgXChTaW1wbGlmaWVkXClcKSkKL0NyZWF0aW9uRGF0ZSAoRDoyMDIyMDUyMjA5Mjc1MSswOCcwMCcpCj4+CmVuZG9iago0IDAgb2JqCjw8Ci9GaWx0ZXIvRmxhdGVEZWNvZGUKL0xlbmd0aCAxMjc5Cj4+c3RyZWFtDQpIia1Xa1ccRRD9vr+iw+6SxTC9/e6ZxGhCgJioCGQ1KhsfISEJjyBExRf4162q7p7pmYHg8chyWHqq63WrbnXPymwwXZe3JJOWV47N9gaCG+vYGVNsdsqs4M4wqxQvDZutMsElPN9lE3ZjYTgaL96cT+ZLH9xaXmKzfTCkWobQgA"    // 处方原件
	
	
	d GetPrescInfoTo7101Output		
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK	
GetPrescInfoTo7101Output
 	set Data=$lb(hosprxno,initrxno,rxtypecode,prsctime,rxdrugnums,rxwaycodg,rxwayname,rxfreqcodg,rxfreqname,rxdosunt,rxdoscnt,rxdrorddscr,validdays,validendtime,reptflag,maxreptcnt,reptdcnt,mininrvdays,drsigninfo,pharsigninfo,fixmedinssigninfo,rxcotnflag,rxfile)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 【7101】电子处方上传	处方明细信息 rxdrugdetail
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetPrescDetailsTo7101","O22050800001")
/// Call web.NationInsuInfoUpload_GetPrescDetailsTo7101("O22050800001")
Query GetPrescDetailsTo7101(PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,hosp_prep_flag,rx_item_type_code,rx_item_type_name,tcmdrug_type_name,tcmdrug_type_code,tcmherb_foote,medn_type_code,medn_type_name,main_medc_flag,urgt_flag,bas_medn_flag,imp_drug_flag,prod_barc,drug_prodname,genname_codg,drug_genname,chemname,drugstdcode,drug_dosform,drug_spec,prdr_name,drug_pric,drug_cnt,drug_sumamt,medc_way_codg,medc_way_dscr,medc_starttime,medc_endtime,medc_days,drug_dosunt,sin_doscnt,sin_dosunt,used_frqu_codg,used_frqu_name,drug_totlnt,drug_totlnt_emp,dise_codg,own_expense_flag") [ SqlProc ]
{
}

ClassMethod GetPrescDetailsTo7101Execute(ByRef qHandle As %Binary, PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
	
	s (medlistcodg,fixmedinshilistid,hospprepflag,rxitemtypecode,rxitemtypename,tcmdrugtypename,tcmdrugtypecode,tcmherbfoote,medntypecode,medntypename,mainmedcflag,urgtflag,basmednflag,impdrugflag,prodbarc,drugprodname,gennamecodg,druggenname,chemname,drugstdcode,drugdosform,drugspec,prdrname,drugpric,drugcnt,drugsumamt,medcwaycodg,medcwaydscr,medcstarttime,medcendtime,medcdays,drugdosunt,sindoscnt,sindosunt,usedfrqucodg,usedfrquname,drugtotlnt,drugtotlntemp,disecodg,ownexpenseflag)=""
	
	;s HospId="2"
	;s InsuType="00A"
	s OEOrdRowID=""
	f {
		s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID)) q:OEOrdRowID=""
		s EpisodeID=$p($g(^OEORD(OEOrdRowID)),"^",1)
		s AdmReasonDR=$p($g(^PAADM(EpisodeID,1)),"^",7)
		s InsuAdmInfo=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID)
		s OEOrdItemSub=""
		f {
			s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,OEOrdItemSub)) q:OEOrdItemSub=""
			s ArcimID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",2)
			s ArcimRowID=$P(ArcimID,"||",1)
			continue:ArcimRowID=""
			s ArcimSub=$P(ArcimID,"||",2)
			continue:ArcimSub=""
			continue:'$d(^ARCIM(ArcimRowID,ArcimSub,1))
			
			s TarRowID=""
			s OltTarRowID=""
			f {
				s OltTarRowID=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID)) q:(OltTarRowID="")||(TarRowID'="")
				s OltSttDate=""
				f {
					s OltSttDate=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID,OltSttDate)) q:(OltSttDate="")||(TarRowID'="")
					s OltRowID=""
					f {
						s OltRowID=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID,OltSttDate,OltRowID)) q:(OltRowID="")||(TarRowID'="")
						s OltEndDate=$p($g(^DHCOLT(OltRowID)),"^",5)
						continue:OltEndDate'=""
						s TarRowID=OltTarRowID
					}
				}
			}
			s TarRowID="322" ;测试用
			s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",HITYPE,HospDr),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
			s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarRowID,HITYPE,"",TariInsuFlag,HospDr)
			s HiListType=$p(TarItemInsuInfo,"^",7)  ;医保目录类别
			s TARISubCateDr=$p($g(^DHCTARI(+TarRowID)),"^",4)
			s ChrgType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_type_con"_HITYPE,TARISubCateDr,6,HospDr)
			s HiListCode=$p(TarItemInsuInfo,"^",3)   //医保目录代码,国家统一标准编码
			s HiListName=$p(TarItemInsuInfo,"^",4)			//医保目录名称,国家统一标准名称
			
			S ItemCatDR=$p($g(^ARCIM(ArcimRowID,ArcimSub,1)),"^",10)
			s ItemType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
			s InciRowID=$o(^INCI(0,"ARCIM_DR",ArcimRowID,""),-1)
			s Generic=##class(web.DHCSTCOMMONSRV).getGeneric(InciRowID)
			S PHCDF=$p($g(^ARCIM(ArcimRowID,ArcimSub,1)),"^",12)
			s preparation="",SPEC="",MANUFACDESC=""
			i PHCDF'="" {
				s PHCD=$P(PHCDF,"||",1)
				S PHCDLabelName1=$p($g(^PHCD(PHCD,2)),"^",7)
				s preparationid=$p($g(^PHCD(PHCD,"DF",$p(PHCDF,"||",2),1)),"^",1)
				i preparationid'="" s preparation=$p(^PHCF(preparationid),"^",2)
				s InciRowID=$o(^INCI(0,"ARCIM_DR",ArcimRowID,""),-1)
				i InciRowID'="" {
					s INFORowID=$o(^DHCITMINFO(0,"INCI",InciRowID,""))
					i INFORowID'="" s SPEC=$p($g(^DHCITMINFO(INFORowID)),"^",27)
				}
				S MANUFACID=$p($g(^PHCD(PHCD,2)),"^",4)
				i MANUFACID'="" s MANUFACDESC=$p($g(^PHMNF(MANUFACID)),"^",2)
				i MANUFACDESC["-" s MANUFACDESC=$p(MANUFACDESC,"-",2)
			}
			
			s InstrDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",7)		// 用法 用药途径
			;s ^temp("InstrDR")=InstrDR
			i InstrDR'="" s InstrDesc=$p($g(^PHCIN(InstrDR)),"^",2)
			e  s InstrDesc=""
			;s GJInstrCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,6,HospDr)
			;s GJInstrDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,7,HospDr)
			;upt Hanzh 20220712
			s GJInstrInfo=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_medc_way_codeCon"_HITYPE,InstrDR,0,HospDr)
			s GJInstrCode=$p(GJInstrInfo,"^",6)
			s GJInstrDesc=$p(GJInstrInfo,"^",7)
			s DuratDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",6)		// 疗程
			s duration="",duratfact="1"
			i DuratDR'="" {
				s duration=$p($g(^PHCDU(DuratDR)),"^",3)
				s duratfact=$p($g(^PHCDU(DuratDR)),"^",2)
			}
			s StDate=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",9)		// 医嘱开始日期
			s StTime=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",10)		// 医嘱开始时间
			s ValiEndDate=StDate+duratfact
			s StDT="",EdDT=""
			i (StDate'="")&&(StTime'="") s StDT=$zd(StDate,3)_" "_$zt(StTime,1),EdDT=$zd(ValiEndDate,3)_" "_$zt(StTime,1)
			s DoseQty=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",1)		// 单次剂量
			s DoseQtyUomDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",3)		// 单次剂量单位
			i DoseQtyUomDR'="" s DoseQtyUom=$p($g(^CT("UOM",DoseQtyUomDR)),"^",2)
			e  s DoseQtyUom=""
			s PackQty=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,9)),"^",4)		// 数量 整
			s PackQtyUomDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,"DHC")),"^",13)		// 数量单位
			i PackQtyUomDR'="" s PackQtyUom=$p($g(^CT("UOM",PackQtyUomDR)),"^",2)
			e  s PackQtyUom=""
			i (ItemType=3)&&(PackQtyUom="") {
				s PackQtyUom=DoseQtyUom
			}
			s unitprice=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",13)		// 数量单位 单价
			i unitprice="" s unitprice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReasonDR,ArcimID,+$H,"","","","",HospDr,""),"^",4)
			s feetotal=unitprice*PackQty
			i $e(unitprice,1)="." s unitprice="0"_unitprice
			i $e(feetotal,1)="." s feetotal="0"_feetotal			// 总价
			
			
			s FreqDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,2)),"^",4)		// 频率
			i FreqDR'="" s FreqDesc=$p($g(^PHCFR(FreqDR)),"^",3)
			e  s FreqDesc=""
			;s GJFreqCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,6,HospDr)
			;s GJFreqDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,7,HospDr)
			;upt Hanzh 20220712
			s GJFreqInfo=##class(web.INSUDicDataCom).GetDicByCodeAndInd("used_frquCon"_HITYPE,FreqDR,0,HospDr)
			s GJFreqCode=$p(GJFreqInfo,"^",6)
			s GJFreqCode=$p(GJFreqInfo,"^",7)	
			s ownexpenseflag=0
			i InsuAdmInfo="" s ownexpenseflag=1
		
			
			s medlistcodg=HiListCode    // 医疗目录编码
			s fixmedinshilistid=""    // 定点医药机构目录编号
			s hospprepflag="0"    // 医疗机构制剂标志  0否，1是
			s rxitemtypecode=""    // 处方项目分类代码
			s rxitemtypename=""    // 处方项目分类名称
			s tcmdrugtypename=""    // 中药类别名称
			s tcmdrugtypecode=""    // 中药类别代码
			s tcmherbfoote=""    // 草药脚注
			s medntypecode=""    // 药物类型代码
			s medntypename=""    // 药物类型
			s mainmedcflag=""    // 主要用药标志
			s urgtflag=""    // 加急标志
			s basmednflag=""    // 基本药物标志
			s impdrugflag=""    // 是否进口药品
			s prodbarc=""    // 药品条形编码
			s drugprodname=PHCDLabelName1    // 药品商品名
			s gennamecodg=""    // 通用名编码
			s druggenname=Generic    // 药品通用名
			s chemname=""    // 化学名称
			s drugstdcode=""    // 药品本位码
			s drugdosform=preparation    // 药品剂型
			s drugspec=SPEC    // 药品规格
			s prdrname=""		//MANUFACDESC    // 生厂厂家
			s drugpric=unitprice    // 药品单价
			s drugcnt=PackQty    // 药品数量
			s drugsumamt=feetotal    // 药品总金额
			s medcwaycodg=GJInstrCode    // 用药途径代码
			s medcwaydscr=GJInstrDesc    // 用药途径描述
			s medcstarttime=StDT    // 用药开始时间
			s medcendtime=EdDT    // 用药结束时间
			s medcdays=duratfact    // 用药天数
			s drugdosunt=""    // 药品剂量单位
			s sindoscnt=DoseQty    // 单次用量
			s sindosunt=DoseQtyUom    // 单次剂量单位
			s usedfrqucodg=GJFreqCode    // 使用频次编码
			s usedfrquname=GJFreqDesc    // 使用频次名称
			s drugtotlnt=PackQty    // 用药总量
			s drugtotlntemp=PackQtyUom    // 用药总量单位
			s disecodg=""    // 病种编码
			s ownexpenseflag=ownexpenseflag    // 自费标志	0非自费，1自费
			d GetPrescDetailsTo7101Output
		}
	}
	
			
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK	
GetPrescDetailsTo7101Output
 	set Data=$lb(medlistcodg,fixmedinshilistid,hospprepflag,rxitemtypecode,rxitemtypename,tcmdrugtypename,tcmdrugtypecode,tcmherbfoote,medntypecode,medntypename,mainmedcflag,urgtflag,basmednflag,impdrugflag,prodbarc,drugprodname,gennamecodg,druggenname,chemname,drugstdcode,drugdosform,drugspec,prdrname,drugpric,drugcnt,drugsumamt,medcwaycodg,medcwaydscr,medcstarttime,medcendtime,medcdays,drugdosunt,sindoscnt,sindosunt,usedfrqucodg,usedfrquname,drugtotlnt,drugtotlntemp,disecodg,ownexpenseflag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 【7101】电子处方上传	门诊信息 mdtrtinfo
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetOPInfoTo7101","O220627000016","00A","2")
/// Call web.NationInsuInfoUpload_GetOPInfoTo7101("O22050800001")
Query GetOPInfoTo7101(PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "mdtrt_id,med_type,ipt_op_no,psn_no,patn_name,age,patn_ht,patn_wt,gend,geso_val,nwb_flag,nwb_age,suck_prd_flag,algs_his,insuplc_admdvs,psn_cert_type,certno,insutype,prsc_dept_name,prsc_dept_code,prsc_dr_name,prsc_dr_cert_type,prsc_dr_certno,dr_profttl_codg,dr_profttl_name,phar_cert_type,phar_certno,phar_name,phar_prac_cert_no,phar_chk_time,mdtrt_time,dise_codg,dise_name,sp_dise_flag,diag_code,diag_name,dise_cond_dscr,hi_feesetl_type,hi_feesetl_name,rgst_fee,medfee_sumamt,fstdiag") [ SqlProc ]
{
}

ClassMethod GetOPInfoTo7101Execute(ByRef qHandle As %Binary, PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As %Status
{
	s ^temp("GetOPInfoTo7101")=$lb(PrescNo,HITYPE,HospDr)
	set repid=$I(^CacheTemp)
 	set ind=1
	
	s (mdtrtid,medtype,iptopno,psnno,patnname,age,patnht,patnwt,gend,gesoval,nwbflag,nwbage,suckprdflag,algshis,insuplcadmdvs,psncerttype,certno,insutype,prscdeptname,prscdeptcode,prscdrname,prscdrcerttype,prscdrcertno,drprofttlcodg,drprofttlname,pharcerttype,pharcertno,pharname,pharpraccertno,pharchktime,mdtrttime,disecodg,disename,spdiseflag,diagcode,diagname,diseconddscr,hifeesetltype,hifeesetlname,rgstfee,medfeesumamt,fstdiag)=""
	
	s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	s EpisodeID=$p($g(^OEORD(OEOrdRowID)),"^",1)
	s AdmReasonDR=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s InsuAdmInfo=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID)
	s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,""))
	s PatRowID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PatName=$p(^PAPER(PatRowID,"ALL"),"^",1)		// 姓名
	s PatRegNo=$p(^PAPER(PatRowID,"PAT",1),"^",2)	// 登记号
	s age=##class(web.DHCBillInterface).GetPapmiAge(PatRowID,EpisodeID,"","")
	s MRRowID=$p($g(^PAADM(EpisodeID)),"^",61)
	s Height=$p($g(^MR(MRRowID,"PRO",1)),"^",20)
	s Weight=$p($g(^MR(MRRowID,"PRO",1)),"^",27)
	s PatSex=$p(^PAPER(PatRowID,"ALL"),"^",7)
	i PatSex'="" s PatSex=$p(^CT("SEX",PatSex),"^",2)		// 性别
	s AddUserID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",1)		// 开嘱医生
	s AddUserCode=$p($g(^SSU("SSUSR",AddUserID)),"^",1)
	s AddUserName=$p($g(^SSU("SSUSR",AddUserID)),"^",2)
	s AddCtpRowID=$p($g(^SSU("SSUSR",AddUserID)),"^",14)
	s AddUserInsuCode=..GetDocInsuInfo(AddUserID)
	s AddLocID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",2)		// 开嘱科室
	i AddLocID'="" s AddLocDesc=$p($g(^CTLOC(AddLocID)),"^",2),AddLocCode=$p($g(^CTLOC(AddLocID)),"^",1)
	e  s AddLocDesc="",AddLocCode=""
	i AddLocDesc["-" s AddLocDesc=$p(AddLocDesc,"-",2)
	;s GJAddLocCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_HITYPE,AddLocCode,6,HospDr)
	;s GJAddLocDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_HITYPE,AddLocCode,7,HospDr)
	;upt Hanzh 20220712
	s GJAddLocInfo=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_HITYPE,AddLocCode,0,HospDr)
	s GJAddLocCode=$p(GJAddLocInfo,"^",6)
	s GJAddLocDesc=$p(GJAddLocInfo,"^",7)
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
	s AdmDT=""
	i (AdmDate'="")&&(AdmTime'="") s AdmDT=$zd(AdmDate,3)_" "_$zt(AdmTime,1)
	;测试用
	;s $p(InsuAdmInfo,"^",15)="11"
	;s $p(InsuAdmInfo,"^",8)="360199"
	;
	s InsuAdmType=$p(InsuAdmInfo,"^",15)
	s spdiseflag="0" 
	i InsuAdmType["14" s spdiseflag="1" 
	s DiagStr=..GetDiagsOrder(EpisodeID)
	s MainDaigStr=$p(DiagStr,$c(1),1)
	s MRDIARowID=$p(MainDaigStr,"^",1)
	s MRADMRowID=$p(MRDIARowID,"||",1)
	s MRDIASub=$p(MRDIARowID,"||",2)
	s MainICDRowID=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",1)
	s MainICDCode=$p(MainDaigStr,"^",2)
	s MainICDDesc=$p(MainDaigStr,"^",3)
	;s InsuDiagStr=$$GetConInfo^DHCINSUICDContrast(MainICDRowID,"00A","")
	//s MainICDRowID="322" ;测试用
	s InsuDiagStr=$$GetConInfo^DHCINSUICDContrast(MainICDRowID,HITYPE,"",HospDr) ;upt 20220701
	s MainICDCodeInsu=$p(InsuDiagStr,"^",3)
	s MainICDDescInsu=$p(InsuDiagStr,"^",4)
	s dmdvs=$p(InsuAdmInfo,"^",8)
	;i $e(dmdvs,1,4)="3302" s hifeesetltype="1",hifeesetlname="本地医疗保险结算"
	;upt HanZH 20220701
	s InsuCenterNo=$e(##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_HITYPE,"InsuCenterNo",4,HospDr),1,4)
	i $e(dmdvs,1,4)=InsuCenterNo s hifeesetltype="1",hifeesetlname="本地医疗保险结算"
	
	e  s hifeesetltype="2" ,hifeesetlname="异地医疗保险结算"
	i dmdvs="" s hifeesetltype="0",hifeesetlname="非医疗保险结算"
	s TotalAmt="",RegFee=""
	s DHCBCIRowID=""
	f {
		s DHCBCIRowID=$o(^DHCBCI(0,"ADM",EpisodeID,DHCBCIRowID)) q:DHCBCIRowID=""
		s PrtRowID=$p($g(^DHCBCI(DHCBCIRowID)),"^",1)
		continue:PrtRowID=""
		s PRTFlag=$p($g(^DHCINVPRT(PrtRowID)),"^",8)
		continue:PRTFlag'="N"
		s PRTFairType=$p($g(^DHCINVPRT(PrtRowID)),"^",34)
		s Amt=$p($g(^DHCINVPRT(PrtRowID)),"^",1)
		s TotalAmt=TotalAmt+Amt
		i PRTFairType="R" s RegFee=Amt
	}
	;s mdtrtid=$p(InsuAdmInfo,"^",10)  // 就诊ID
	s mdtrtid=$p(InsuAdmInfo,"^",2)  // 就诊ID upt 20220704 HanZH
	s medtype="11"    // 医疗类别  写死 41定点药店购药 ;宁波市医院测试患者医疗类别为门诊挂号(12)接口不支持，项目视具体情况而定
	s iptopno=PatRegNo    // 住院/门诊号
	s psnno=$p(InsuAdmInfo,"^",3)    // 人员编号
	//s psnno="33010099000000000011046419"    // 人员编号 测试用
	s patnname=PatName    // 患者姓名
	//s patnname="张弋平"    // 患者姓名 测试用
	s age=$tr(age,"岁月天","")    // 年龄
	s patnht=Height    // 患者身高
	s patnwt=Weight    // 患者体重
	//s gend=$case(PatSex,"男":1,"女":2,:9)    // 性别
	s gend=##class(web.INSUDicDataCom).GetDicByDescAndInd("gend"_HITYPE,PatSex,3,HospDr)	//upt HanHZ 20220704
	s gesoval=""    // 妊娠(孕周)
	s nwbflag=""    // 新生儿标志
	s nwbage=""    // 新生儿日、月龄
	s suckprdflag=""    // 哺乳期标志
	s algshis=""    // 过敏史
	s insuplcadmdvs=$p(InsuAdmInfo,"^",8)    // 参保地医保区划
	;s psncerttype="1"    // 人员证件类型
	s psncerttype=$p(InsuAdmInfo,"^",43)    // 人员证件类型 upt 20220704 HanZH
	s certno=$p(InsuAdmInfo,"^",44)  //  证件号码   
	s insutype=$p(InsuAdmInfo,"^",37)    // 险种类型
	//s prscdeptname=GJAddLocCode    // 开方科室名称
	s prscdeptname=GJAddLocDesc    // 开方科室名称 upt 20220704 HanZH
	s prscdeptcode=GJAddLocCode   // 开方科室编号
	s prscdrname=AddUserName    // 开方医师姓名
	s prscdrcerttype=""    // 开方医师证件类型
	s prscdrcertno=""    // 开方医师证件号码
	s drprofttlcodg=""    // 医生职称编码
	s drprofttlname=""    // 医生职称名称
	s pharcerttype=""    // 药师证件类型
	s pharcertno=""    // 药师证件号码
	s pharname=""    // 药师姓名
	s pharpraccertno=""    // 药师执业资格证号
	s pharchktime=""    // 医疗机构药师审方时间
	s mdtrttime=AdmDT    // 就诊时间
	s disecodg=""    // 病种编码
	s disename=""    // 病种名称
	s spdiseflag=spdiseflag    // 特殊病种标志
	s diagcode=MainICDCodeInsu    // 主诊断代码
	s diagname=MainICDDescInsu    // 主诊断名称
	s diseconddscr=""    // 疾病病情描述
	s hifeesetltype=hifeesetltype    // 医保费用结算类型
	s hifeesetlname=hifeesetlname    // 医保费用类别名称
	s rgstfee=RegFee    // 挂号费
	s medfeesumamt=TotalAmt    // 医疗费总额
	s fstdiag=""    // 是否初诊
	
	d GetOPInfoTo7101Output		
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK	
GetOPInfoTo7101Output
 	set Data=$lb(mdtrtid,medtype,iptopno,psnno,patnname,age,patnht,patnwt,gend,gesoval,nwbflag,nwbage,suckprdflag,algshis,insuplcadmdvs,psncerttype,certno,insutype,prscdeptname,prscdeptcode,prscdrname,prscdrcerttype,prscdrcertno,drprofttlcodg,drprofttlname,pharcerttype,pharcertno,pharname,pharpraccertno,pharchktime,mdtrttime,disecodg,disename,spdiseflag,diagcode,diagname,diseconddscr,hifeesetltype,hifeesetlname,rgstfee,medfeesumamt,fstdiag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 【7101】电子处方上传	诊断信息 diseinfo
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetDiagInfoTo7101","O220627000016","00A","2")
/// Call web.NationInsuInfoUpload_GetDiagInfoTo7101("O22050800001")
Query GetDiagInfoTo7101(PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "diag_type,maindiag_flag,diag_srt_no,diag_code,diag_name,diag_dept,dise_dor_no,dise_dor_name,diag_time") [ SqlProc ]
{
}

ClassMethod GetDiagInfoTo7101Execute(ByRef qHandle As %Binary, PrescNo As %String = "", HITYPE As %String = "", HospDr As %String = "") As %Status
{
	s ^temp("GetDiagInfoTo7101")=$lb(PrescNo,HITYPE,HospDr)
	set repid=$I(^CacheTemp)
 	set ind=1
	
	s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	s EpisodeID=$p($g(^OEORD(OEOrdRowID)),"^",1)
	s MRRowID=$p($g(^PAADM(EpisodeID)),"^",61)
	s DiagType=""
	s Inmainnum=0
	s Outmainnum=0
	s count=0
	//Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosListNew")
	//do rset.Execute(MRRowID,"",DiagType,"1") ;20160418 DingSH 医生站增加了一个入参 固定为1代表去空格
	Set rset=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	do rset.Execute(MRRowID,"",DiagType) ;20220107 DingSH 
	Set columns = rset.GetColumnCount()
	
	s AdmReasonDr=$p(^PAADM(EpisodeID,1),"^",7)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(EpisodeID) //+ DingSH 20200526
	s HITYPE=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HospDr)
	While (rset.Next()) {
		s count=count+1
		s DiagnosValue=rset.GetDataByName("DiagnosValue")	;诊断表ID(User.MRDiagnos)
		s DiagnosCodeRowid=rset.GetDataByName("DiagnosCodeRowid")	;诊断代码表ID(User.MRCICDDx)
		s DiagnosICDCode=rset.GetDataByName("DiagnosICDCode")	;诊断代码表ICD代码
		s DiagnosDesc=rset.GetDataByName("DiagnosDesc")	;ICD诊断描述
		s DiagnosMRDesc=rset.GetDataByName("DiagnosMRDesc")	;诊断注释
		
		s DiagnosType=rset.GetDataByName("DiagnosType")	;诊断类型描述
		s DiagnosDate=rset.GetDataByName("DiagnosDate")	;诊断日期
		s DiagnosOnsetDate=rset.GetDataByName("DiagnosOnsetDate")	;发病日期
		s DiagStat=rset.GetDataByName("DiagStat")	;诊断状态描述
		s DiagnosLeavel=rset.GetDataByName("DiagnosLeavel")	;诊断级别(数字)
		s InsuDiagInfo=""
		s:DiagnosCodeRowid'="" InsuDiagInfo=$$GetConInfo^DHCINSUICDContrast(DiagnosCodeRowid,HITYPE,"",HospDr) ;;;??????目录类型
		s InsuDiagCode=$P(InsuDiagInfo,"^",3) ;医保诊断编码
		s InsuDiagDesc=$P(InsuDiagInfo,"^",4) ;医保诊断描述
		;s InsuDiagCode="J00.x00x002"			;医保诊断编码		测试用
		;s InsuDiagDesc="病毒性感冒"				;医保诊断描述		测试用
	    s MainDiagFlag=rset.GetDataByName("MainDiagFlag") ;主诊断标识
		s DiagnosNumber=rset.GetDataByName("DiagnosNumber") ;诊断序号
		s MRCDiagLocDr=rset.GetDataByName("MRDIAAddLocDr") ;诊断科室dr
		s MRCDiagLocCode=rset.GetDataByName("MRDIAAddLocCode") ;诊断科室编码
		s MRCDiagLocDesc=rset.GetDataByName("MRDIAAddLocDesc") ;诊断科室名称
		s MRDIADocCode=rset.GetDataByName("MRDIADocCode") ;诊断医师编码
		s MRDIADocCode=..GetDocInsuInfo("",MRDIADocCode)
		s MRCDIADocDesc=rset.GetDataByName("MRCDIADocDesc") ;诊断医师名称
		s MRDiagnosTime=rset.GetDataByName("MRDiagnosTime") ;诊断时间
	
		s MainDiagFlag="N"
		s:($lf($lb("入院诊断","门诊诊断"),DiagnosType)) Inmainnum=Inmainnum+1
		s:($lf($lb("入院诊断","门诊诊断"),DiagnosType))&&(Inmainnum="1") MainDiagFlag="Y"
		s:($lf($lb("出院诊断"),DiagnosType)) Outmainnum=Outmainnum+1
		s:($lf($lb("出院诊断"),DiagnosType))&&(Outmainnum="1") MainDiagFlag="Y"
	
		s (diagtype,maindiagflag,diagsrtno,diagcode,diagname,diagdept,disedorno,disedorname,diagtime)=""
		s diagtype="1"    // 诊断类别	1西医诊断,2中医主病诊断,3中医主证诊断
		s maindiagflag=MainDiagFlag    // 主诊断标志
		s diagsrtno=count    // 诊断排序号
		s diagcode=InsuDiagCode    // 诊断代码
		s diagname=InsuDiagDesc    // 诊断名称
		s diagdept=MRCDiagLocDesc    // 诊断科室
		;s diagdept="A03.07"	;测试用
		s disedorno=MRDIADocCode    // 诊断医生编码
		s disedorname=MRCDIADocDesc    // 诊断医生姓名
		;s disedorno="ys01"	;测试用
		;s disedorname="医生01"	;测试用
		s diagtime=$zd(DiagnosDate,3)_" "_MRDiagnosTime    // 诊断时间
		d GetDiagInfoTo7101Output
	}	
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK	
GetDiagInfoTo7101Output
 	set Data=$lb(diagtype,maindiagflag,diagsrtno,diagcode,diagname,diagdept,disedorno,disedorname,diagtime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 获取医生医保编码
/// w ##class(web.NationInsuInfoUpload).GetDocInsuInfo("756")
ClassMethod GetDocInsuInfo(UserID As %String = "", UserCode As %String = "", UserDesc As %String = "") As %String
{
	s Return=""
	s DocInsuCode=""
	i UserID'="" {
		s DocInsuCode=$p($g(^SSU("SSUSR",UserID)),"^",124)
	}
	elseif UserCode'="" {
		s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
		i UserID'="" s DocInsuCode=$p($g(^SSU("SSUSR",UserID)),"^",124)
	}
	s Return=DocInsuCode
	q DocInsuCode
}

/// Description：根据就诊号，获取病人诊断,按照排序
/// Input： AdmRowID:就诊号,
/// Input:  pMRCDiagTypCode：DIS:出院诊断 ,OP:门诊诊断 ,M:主诊断 ,C008:入院诊断 ,XZZD:修正诊断 ,BCZD:补充诊断
/// w ##class(web.NationInsuInfoUpload).GetDiagsOrder("560803")
ClassMethod GetDiagsOrder(AdmRowID As %String = "", pMRCDiagTypCode As %String = "") As %String
{
	q:AdmRowID="" ""
	s MRADMRowID=$p($g(^PAADM(AdmRowID)),"^",61)
	q:MRADMRowID="" ""
	k ^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID)
	s MRDIASub="0"
	f {
		s MRDIASub=$o(^MR(MRADMRowID,"DIA",MRDIASub)) q:MRDIASub=""
		s Level=$p($g(^MR(MRADMRowID,"DIA",MRDIASub,"EPR")),"^",1)		// 级别
		s Order=$p($g(^MR(MRADMRowID,"DIA",MRDIASub,"EPR")),"^",2)		// 顺序
		i Order="" s Order="999"
		i Level="" s Level=1
		s MRDIARowID=MRADMRowID_"||"_MRDIASub
		s ^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID,Order,Level,MRDIARowID)=""
	}
	s Return=""
	s Order=""
	f {
		s Order=$o(^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID,Order)) q:Order=""
		s Level=""
		f {
			s Level=$o(^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID,Order,Level)) q:Level=""
			s MRDIARowID=""
			f {
				s MRDIARowID=$o(^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID,Order,Level,MRDIARowID)) q:MRDIARowID=""
				s MRADMRowID=$p(MRDIARowID,"||",1)
				s MRDIASub=$p(MRDIARowID,"||",2)
				s MRDIADesc=$g(^MR(MRADMRowID,"DIA",MRDIASub,"DES",1))
				s MRDIAICDCodeDR=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",1)
				i MRDIAICDCodeDR'="" s MRICDCode=$p(^MRC("ID",MRDIAICDCodeDR),"^",4),MRICDDesc=$p(^MRC("ID",MRDIAICDCodeDR),"^",2)
				e  s MRICDCode="",MRICDDesc=""
				continue:(MRICDDesc="")&&(MRDIADesc="")
				s TYPSub=$o(^MR(MRADMRowID,"DIA",MRDIASub,"TYP",""),-1)		// 诊断类型
				s MRCDiagTypCode="",MRCDiagTypDesc=""
				i TYPSub'="" {
					s MRCDiagTypDR=$p($g(^MR(MRADMRowID,"DIA",MRDIASub,"TYP",TYPSub)),"^",1)
					i MRCDiagTypDR'="" s MRCDiagTypCode=$p($g(^MRC("DTYP",MRCDiagTypDR)),"^",1),MRCDiagTypDesc=$p($g(^MRC("DTYP",MRCDiagTypDR)),"^",2)
				}
				continue:(pMRCDiagTypCode'="")&&(MRCDiagTypCode'=pMRCDiagTypCode)
				s MRDIADate=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",7)
				i MRDIADate'="" s MRDIADate=$zd(MRDIADate,3)
				s MRDIATime=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",8)
				i MRDIATime'="" s MRDIATime=$zt(MRDIATime,1)
				s DiagStatDR=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",9)		// 诊断状态
				i DiagStatDR'="" s DiagStatCode=$p($g(^MRC("DSTAT",DiagStatDR)),"^",1),DiagStatDesc=$p($g(^MRC("DSTAT",DiagStatDR)),"^",2)
				e  s DiagStatCode="",DiagStatDesc=""
				s DoctorDR=$p($g(^MR(MRADMRowID,"DIA",MRDIASub)),"^",4)
				i DoctorDR'="" s DoctorCode=$p($g(^CTPCP(DoctorDR,1)),"^",1),DoctorDesc=$p($g(^CTPCP(DoctorDR,1)),"^",2)
				e  s DoctorCode="",DoctorDesc=""
				s Str=MRDIARowID_"^"_MRICDCode_"^"_MRICDDesc_"^"_MRDIADesc_"^"_DoctorCode_"^"_DoctorDesc_"^"_MRDIADate_"^"_MRDIATime_"^"_MRCDiagTypDesc_"^"_DiagStatDesc
				i Return'="" s Return=Return_$c(1)_Str
				e  s Return=Str
			}
		}
	}
	k ^TempNBYZ("web.DHCNBYZ.PublicOne","GetDiagsOrder",AdmRowID)
	q Return
}

/// Description: 获取电子处方，用户前台界面
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetPrescNoInfo","01/05/2022","01/06/2022","0001434496","","","Y")
/// Call web.NationInsuInfoUpload_GetPrescNoInfo("")
Query GetPrescNoInfo(SttDate As %String = "", EndDate As %String = "", RegNo As %String = "", EpisodeID As %String = "", PrescNo As %String = "", UpFlag As %String = "") As websys.Query(ROWSPEC = "PatName,PatRegNo,AdmDate,AdmLocDeptDesc,DiagDesc,ResLocDesc,ResDocName,PrescNo,OrdDate,UpFlag,EpisodeID,hirxno,AuditResult,BuyResult") [ SqlProc ]
{
}

ClassMethod GetPrescNoInfoExecute(ByRef qHandle As %Binary, SttDate As %String = "", EndDate As %String = "", RegNo As %String = "", EpisodeID As %String = "", PrescNo As %String = "", UpFlag As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
	set qHandle=$lb(0,repid,0)
	set ^CacheTMP("GetPrescNoInfo")=$lb(SttDate, EndDate, RegNo, EpisodeID, PrescNo, UpFlag)
	i SttDate'="" s SttDate=##class(websys.Conversions).DateHtmlToLogical(SttDate)
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	s pid=$j
	k ^||TempPrescNo("PrescNo",pid)
	
	i PrescNo'="" {
		s TmpPrscNo=PrescNo
		s ^||TempPrescNo("PrescNo",pid,TmpPrscNo)=""
	}
	elseif EpisodeID'="" {
		s TmpOEOrdRowID=$O(^OEORD(0,"Adm",EpisodeID,""))
		q:TmpOEOrdRowID="" $$$OK
		s TmpOEOrdItemSub=""
		f {
			s TmpOEOrdItemSub=$O(^OEORD(TmpOEOrdRowID,"I",TmpOEOrdItemSub)) q:TmpOEOrdItemSub=""
			s TmpPrescNo=$P($g(^OEORD(TmpOEOrdRowID,"I",TmpOEOrdItemSub,1)),"^",14)
			continue:TmpPrescNo=""
			s ^||TempPrescNo("PrescNo",pid,TmpPrescNo)=""
		}
	}
	elseif RegNo'="" {
		s PatRowID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
		s AdmType=""
		f {
			s AdmType=$o(^PAPERdr(PatRowID,"ADM",AdmType)) q:AdmType=""
			s TmpEpisodeID=""
			f {
				s TmpEpisodeID=$o(^PAPERdr(PatRowID,"ADM",AdmType,TmpEpisodeID)) q:TmpEpisodeID=""
				s TmpAdmDate=$p($g(^PAADM(TmpEpisodeID)),"^",6)
				continue:((TmpAdmDate<SttDate)&&(SttDate'=""))||((TmpAdmDate>EndDate)&&(EndDate'=""))
				s TmpOEOrdRowID=$O(^OEORD(0,"Adm",TmpEpisodeID,""))
				continue:TmpOEOrdRowID=""
				s TmpOEOrdItemSub=""
				f {
					s TmpOEOrdItemSub=$O(^OEORD(TmpOEOrdRowID,"I",TmpOEOrdItemSub)) q:TmpOEOrdItemSub=""
					s TmpPrescNo=$P($g(^OEORD(TmpOEOrdRowID,"I",TmpOEOrdItemSub,1)),"^",14)
					continue:TmpPrescNo=""
					s ^||TempPrescNo("PrescNo",pid,TmpPrescNo)=""
				}
			}
		}
	}
 	elseif (PrescNo="")&&(EpisodeID="")&&(RegNo="")&&(SttDate'="")&&(EndDate'="") {
		f Date=SttDate:1:EndDate {
			s TmpOEOrdRowID=""
			f {
				s TmpOEOrdRowID=$o(^OEORDi(0,"StDt",Date,TmpOEOrdRowID)) q:TmpOEOrdRowID=""
				s TmpOEOrdItemSub=""
				f {
					s TmpOEOrdItemSub=$o(^OEORDi(0,"StDt",Date,TmpOEOrdRowID,TmpOEOrdItemSub)) q:TmpOEOrdItemSub=""
					s TmpPrescNo=$P($g(^OEORD(TmpOEOrdRowID,"I",TmpOEOrdItemSub,1)),"^",14)
					continue:TmpPrescNo=""
					s WPFlag=..GetWPPrescNoFlag(TmpPrescNo)
	 				continue:WPFlag="0"
					s ^||TempPrescNo("PrescNo",pid,TmpPrescNo)=""
				}
			}
		}
	}
 	
 	s (PatName,PatRegNo,AdmDate,AdmLocDeptDesc,DiagDesc,ResLocDesc,ResDocName,PrescNo,OrdDate,UpFalg,hirxno)=""
 	s PrescNo=""
 	f {
	 	s PrescNo=$o(^||TempPrescNo("PrescNo",pid,PrescNo)) q:PrescNo=""
	 	s WPFlag=..GetWPPrescNoFlag(PrescNo)
	 	continue:WPFlag="0"
		s OEOrdRowID=""
		f {
			s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID)) q:OEOrdRowID=""
			s EpisodeID=$p($g(^OEORD(OEOrdRowID)),"^",1)
			s PatRowID=$p($g(^PAADM(EpisodeID)),"^",1)
			s PatName=$p(^PAPER(PatRowID,"ALL"),"^",1)		// 姓名
			s PatRegNo=$p(^PAPER(PatRowID,"PAT",1),"^",2)	// 登记号
			s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
			i AdmDate'="" s AdmDate=$zd(AdmDate,3)
			s AdmLocDeptID=$p($g(^PAADM(EpisodeID)),"^",4)
			s AdmLocDeptDesc=$p(^CTLOC(AdmLocDeptID),"^",2)
			i AdmLocDeptDesc["-" s AdmLocDeptDesc=$p(AdmLocDeptDesc,"-",2)
			s DiagStr=..GetDiagsOrder(EpisodeID)
			s MainDaigStr=$p(DiagStr,$c(1),1)
			s MRDIARowID=$p(MainDaigStr,"^",1)
			s MRADMRowID=$p(MRDIARowID,"||",1)
			s MRDIASub=$p(MRDIARowID,"||",2)
			s MainICDCode=$p(MainDaigStr,"^",2)
			s MainICDDesc=$p(MainDaigStr,"^",3)
			s DiagDesc=MainICDDesc
			s ResDocName=""
			s ResLocDesc=""
			s OrdDate=""
			s OEStatusFlag="-1"		// 非正常
			s OEOrdItemSub=""
			f {
				s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,OEOrdItemSub)) q:OEOrdItemSub=""
				s OEORIItemStatDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",13)
				i (OEORIItemStatDR="1")||(OEORIItemStatDR="6") {
					s OEStatusFlag="1"		// 正常
				}
				s ResDocUserID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",1)		// 开嘱医生
				i ResDocName="" s ResDocName=$p($g(^SSU("SSUSR",ResDocUserID)),"^",2)
				s ResLocID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",2)		// 开嘱科室
				i ResLocID'="" {
					i ResLocDesc="" s ResLocDesc=$p($g(^CTLOC(ResLocID)),"^",2)
				}
				i ResLocDesc["-" s ResLocDesc=$p(ResLocDesc,"-",2)
				i OrdDate="" S OrdDate=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,3)),"^",7)		// 开嘱日期
				S OrdTime=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",17)		// 开嘱时间
				i OrdDate'="" s OrdDate=$zd(OrdDate,3)
			}
			continue:OEStatusFlag="-1"
			;增加上传标志获取
			s hirxno=""
			set SaveUPFlag=##class(web.DHCINSUDataUL).CheckUPFlag("7101",PrescNo)
			continue:(SaveUPFlag'=UpFlag)&&(UpFlag'="")
			if SaveUPFlag="Y" S hirxno=##class(web.DHCINSUDataUL).GetOutputData("7101",PrescNo)
			s AuditResult="",BuyResult=""
			d GetPrescNoInfoOutput
		}
 	}
 	k ^||TempPrescNo("PrescNo",pid)
	quit $$$OK	
GetPrescNoInfoOutput
	

 	set Data=$lb(PatName,PatRegNo,AdmDate,AdmLocDeptDesc,DiagDesc,ResLocDesc,ResDocName,PrescNo,OrdDate,SaveUPFlag,EpisodeID,hirxno,AuditResult,BuyResult)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 获取处方医嘱明细
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetPrescNoDetailInfo","O220624000015","00A","2")
/// Call web.NationInsuInfoUpload_GetPrescNoDetailInfo("")
Query GetPrescNoDetailInfo(PrescNo As %String = "", InsuType As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "PatName,PatRegNo,ArcimCode,ArcimDesc,TarItemInsuCode,OEORIItemStatDesc,PrescNo,ResDocName,ResLocDesc,OrdDate") [ SqlProc ]
{
}

ClassMethod GetPrescNoDetailInfoExecute(ByRef qHandle As %Binary, PrescNo As %String = "", InsuType As %String = "", HospDr As %String = "") As %Status
{
	s ^temp("GetPrescNoDetailInfo")=$Lb(PrescNo,InsuType,HospDr)
	set repid=$I(^CacheTemp)
 	set ind=1
	set qHandle=$lb(0,repid,0)

	q:PrescNo="" $$$OK
 	s (PatName,PatRegNo,ArcimCode,ArcimDesc,ResDocName,ResLocDesc,OrdDate)=""
 	;s InsuType="00A"
	s OEOrdRowID=""
	;s HospDr="2"
	f {
		s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID)) q:OEOrdRowID=""
		s EpisodeID=$p($g(^OEORD(OEOrdRowID)),"^",1)
		s PatRowID=$p($g(^PAADM(EpisodeID)),"^",1)
		s PatName=$p(^PAPER(PatRowID,"ALL"),"^",1)		// 姓名
		s PatRegNo=$p(^PAPER(PatRowID,"PAT",1),"^",2)	// 登记号
		s OEOrdItemSub=""
		f {
			s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,OEOrdItemSub)) q:OEOrdItemSub=""
			s ArcimID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",2)
			continue:ArcimID=""
			s ArcimRowID=$p(ArcimID,"||",1)
			s ArcimSub=$p(ArcimID,"||",2)
			s ArcimCode=$p($g(^ARCIM(ArcimRowID,ArcimSub,1)),"^",1)
			s ArcimDesc=$p($g(^ARCIM(ArcimRowID,ArcimSub,1)),"^",2)
			s TarRowID=""
			s OltTarRowID=""
			f {
				s OltTarRowID=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID)) q:(OltTarRowID="")||(TarRowID'="")
				s OltSttDate=""
				f {
					s OltSttDate=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID,OltSttDate)) q:(OltSttDate="")||(TarRowID'="")
					s OltRowID=""
					f {
						s OltRowID=$o(^DHCOLT(0,"ARTTA",ArcimID,OltTarRowID,OltSttDate,OltRowID)) q:(OltRowID="")||(TarRowID'="")
						s OltEndDate=$p($g(^DHCOLT(OltRowID)),"^",5)
						continue:OltEndDate'=""
						s TarRowID=OltTarRowID
					}
				}
			}
			
			;s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
			;s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarRowID,InsuType,"",TariInsuFlag)
			b ;upt 20220618 HanZH
			;s TarRowID="322" ;测试用
			s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,HospDr),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
			s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarRowID,InsuType,"",TariInsuFlag,HospDr)
			s TarItemInsuCode=$p(TarItemInsuInfo,"^",3)
			s OEORIItemStatDR=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",13)
			s OEORIItemStatDesc=$p($g(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
			s ResDocUserID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",1)		// 开嘱医生
			i ResDocName="" s ResDocName=$p($g(^SSU("SSUSR",ResDocUserID)),"^",2)
			s ResLocID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,7)),"^",2)		// 开嘱科室
			i ResLocID'="" {
				i ResLocDesc="" s ResLocDesc=$p($g(^CTLOC(ResLocID)),"^",2)
			}
			i ResLocDesc["-" s ResLocDesc=$p(ResLocDesc,"-",2)
			S OrdDate=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,3)),"^",7)		// 开嘱日期
			S OrdTime=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",17)		// 开嘱时间
			s OrdDate=$zd(OrdDate,3)
			d GetPrescNoDetailInfoOutput
		}
		
	}
	quit $$$OK	
GetPrescNoDetailInfoOutput
 	set Data=$lb(PatName,PatRegNo,ArcimCode,ArcimDesc,TarItemInsuCode,OEORIItemStatDesc,PrescNo,ResDocName,ResLocDesc,OrdDate)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 获取处方审核结果，处方购药结果
/// Input:
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.NationInsuInfoUpload","GetPrescNoybInfo","7160","330220220622000000744322")
/// Call web.NationInsuInfoUpload_GetPrescNoDetailInfo("")
Query GetPrescNoybInfo(InterType As %String = "", hirxno As %String = "", UserID As %String = "", InsuType As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "valueDesc,value") [ SqlProc ]
{
}

ClassMethod GetPrescNoybInfoExecute(ByRef qHandle As %Binary, InterType As %String = "", hirxno As %String = "", UserID As %String = "", InsuType As %String = "", HospDr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
	set qHandle=$lb(0,repid,0)
	s ^TempPrescNo("PrescNo")=$lb(InterType,hirxno,InsuType,HospDr)
	q:(InterType="")||(hirxno="") $$$OK
 	
 	s EpisodeID=""
 	i UserID="" s UserID="1"
	/*i InterType="7160" {
		s Param=..GetParamObj(EpisodeID,InterType,1,UserID,InsuType,HospDr)
		s DataObj=##class(%ArrayOfDataTypes).%New()
		d DataObj.SetAt(hirxno,"hi_rxno")  // 医保处方编号
		s dataInputArgArr=##class(%ArrayOfDataTypes).%New()
		d dataInputArgArr.SetAt(DataObj,"data")
		s outputData=..InsuDocDetailedAuditService(Param,dataInputArgArr,InsuType)
		s flag=$p(outputData,"^",1)
		i flag="1" {
			s jsonOutputObj=##class(INSU.Utils.COM.Object).FromJSON(outputData)
			s infcode=jsonOutputObj.Get("infcode")
			i infcode'="0" {
				s valueDesc=infcode
				s value=jsonOutputObj.Get("err_msg")		// 错误消息
				d GetPrescNoybInfoOutput
			}
			q:infcode'="0" $$$OK
			s valueDesc="医保处方编号"
			s value=jsonOutputObj.output.data.Get("hi_rxno")		// 医保处方编号
			d GetPrescNoybInfoOutput
			
			s valueDesc="医药机构名称（审方）"
			s value=jsonOutputObj.output.data.Get("fixmedins_name")		// 医药机构名称（审方）
			d GetPrescNoybInfoOutput
			
			s valueDesc="医药机构编号（审方）"
			s value=jsonOutputObj.output.data.Get("fixmedins_code")		// 医药机构编号（审方）
			d GetPrescNoybInfoOutput
			
			s valueDesc="药师证件类型"
			s value=jsonOutputObj.output.data.Get("phar_cert_type")		// 药师证件类型
			s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
			d GetPrescNoybInfoOutput
			
			s valueDesc="药师证件号码"
			s value=jsonOutputObj.output.data.Get("phar_certno")		// 药师证件号码
			d GetPrescNoybInfoOutput
			
			s valueDesc="药师姓名"
			s value=jsonOutputObj.output.data.Get("phar_name")		// 药师姓名
			d GetPrescNoybInfoOutput
			
			s valueDesc="药师执业资格证号"
			s value=jsonOutputObj.output.data.Get("phar_prac_cert_no")		// 药师执业资格证号
			d GetPrescNoybInfoOutput
			
			s valueDesc="复核药师证件类型"
			s value=jsonOutputObj.output.data.Get("rchk_phar_cert_type")		// 复核药师证件类型
			s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
			d GetPrescNoybInfoOutput
			
			s valueDesc="复核药师证件编号"
			s value=jsonOutputObj.output.data.Get("rchk_phar_certno")		// 复核药师证件编号
			d GetPrescNoybInfoOutput
			
			s valueDesc="复核药师姓名"
			s value=jsonOutputObj.output.data.Get("rchk_phar_name")		// 复核药师姓名
			d GetPrescNoybInfoOutput
			
			s valueDesc="配药人证件类型"
			s value=jsonOutputObj.output.data.Get("dspeer_cert_type")		// 配药人证件类型
			s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
			d GetPrescNoybInfoOutput
			
			s valueDesc="配药人证件编号"
			s value=jsonOutputObj.output.data.Get("dspeer_certno")		// 配药人证件编号
			d GetPrescNoybInfoOutput
			
			s valueDesc="配药人姓名"
			s value=jsonOutputObj.output.data.Get("dspeer_name") 		// 配药人姓名
			d GetPrescNoybInfoOutput
			
			s valueDesc="处方审核状态代码"
			s value=jsonOutputObj.output.data.Get("rx_chk_stas_codg") 		// 处方审核状态代码
			s value=$case(value,"0":"审核不通过","1":"审核通过")
			d GetPrescNoybInfoOutput
			
			s valueDesc="处方审核意见"
			s value=jsonOutputObj.output.data.Get("rx_chk_opnn") 		// 处方审核意见
			d GetPrescNoybInfoOutput
			
			s valueDesc="处方审核时间"
			s value=jsonOutputObj.output.data.Get("rx_chk_time") 		// 处方审核时间
			d GetPrescNoybInfoOutput
		}
		elseif flag'="1" {
			s valueDesc=$p(outputData,"^",1)
			s value=$p(outputData,"^",2) 		
			d GetPrescNoybInfoOutput
		}
	}
	i InterType="7161" {
		s Param=..GetParamObj(EpisodeID,InterType,1,UserID,InsuType,HospDr)
		s DataObj=##class(%ArrayOfDataTypes).%New()
		d DataObj.SetAt(hirxno,"hi_rxno")  // 医保处方编号
		s dataInputArgArr=##class(%ArrayOfDataTypes).%New()
		d dataInputArgArr.SetAt(DataObj,"data")
		s outputData=..InsuDocDetailedAuditService(Param,dataInputArgArr,InsuType)
		s flag=$p(outputData,"^",1)
		i flag="1" {
			s jsonOutputObj=##class(INSU.Utils.COM.Object).FromJSON(outputData)
			s infcode=jsonOutputObj.Get("infcode")
			i infcode'="0" {
				s valueDesc=infcode
				s value=jsonOutputObj.Get("err_msg")		// 错误消息
				d GetPrescNoybInfoOutput
			}
			q:infcode'="0" $$$OK
			s selts=jsonOutputObj.output.selts
			s cnt=feedetail.Size(),inum=0
			s insuinfo=""
			f inum=0:1:(cnt-1)
			{
				s valueDesc="医保处方编号"
				s value=feedetail.Get(inum).Get("hi_rxno")		// 医保处方编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="医保处方使用编号"
				s value=feedetail.Get(inum).Get("hi_rxusno")		// 医保处方使用编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="基金支付总额"
				s value=feedetail.Get(inum).Get("fund_pay_sumamt")		// 基金支付总额
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人负担总金额"
				s value=feedetail.Get(inum).Get("psn_part_amt")		// 个人负担总金额
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人账户支出"
				s value=feedetail.Get(inum).Get("acct_pay")		// 个人账户支出
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人现金支出"
				s value=feedetail.Get(inum).Get("psn_cash_pay")		// 个人现金支出
				d GetPrescNoybInfoOutput
				
				s valueDesc="结算时间"
				s value=feedetail.Get(inum).Get("setl_time")		// 结算时间
				d GetPrescNoybInfoOutput
				
				s valueDesc="定点医药机构编号(结算)"
				s value=feedetail.Get(inum).Get("fixmedins_code")		// 定点医药机构编号(结算)
				d GetPrescNoybInfoOutput
				
				s valueDesc="定点医药机构名称(结算)"
				s value=feedetail.Get(inum).Get("fixmedins_name")		// 定点医药机构名称(结算)
				d GetPrescNoybInfoOutput
			}
		}
		elseif flag'="1" {
			s valueDesc=$p(outputData,"^",1)
			s value=$p(outputData,"^",2) 		
			d GetPrescNoybInfoOutput
		}
	}*/
	;start upt HanZH 20220630
	s Param=..GetParamObj(EpisodeID,InterType,1,UserID,InsuType,HospDr)
	s DataObj=##class(%ArrayOfDataTypes).%New()
	d DataObj.SetAt(hirxno,"hi_rxno")  // 医保处方编号
	s dataInputArgArr=##class(%ArrayOfDataTypes).%New()
	d dataInputArgArr.SetAt(DataObj,"data")
	s outputData=..InsuDocDetailedAuditService(Param,dataInputArgArr,InsuType)
	s flag=$p(outputData,"^",1)
	i flag="1" {
		s jsonOutputObj=##class(INSU.Utils.COM.Object).FromJSON(outputData)
		s infcode=jsonOutputObj.Get("infcode")
		i infcode'="0" {
			s valueDesc=infcode
			s value=jsonOutputObj.Get("err_msg")		// 错误消息
			d GetPrescNoybInfoOutput
		}
		q:infcode'="0" $$$OK
		s selts=jsonOutputObj.output.selts
		s cnt=feedetail.Size(),inum=0
		s insuinfo=""
		i InterType="7103"{
			f inum=0:1:(cnt-1)
			{
				s valueDesc="医保处方编号"
				s value=feedetail.Get(inum).Get("hi_rxno")		// 医保处方编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="医保处方使用编号"
				s value=feedetail.Get(inum).Get("hi_rxusno")		// 医保处方使用编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="基金支付总额"
				s value=feedetail.Get(inum).Get("fund_pay_sumamt")		// 基金支付总额
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人负担总金额"
				s value=feedetail.Get(inum).Get("psn_part_amt")		// 个人负担总金额
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人账户支出"
				s value=feedetail.Get(inum).Get("acct_pay")		// 个人账户支出
				d GetPrescNoybInfoOutput
				
				s valueDesc="个人现金支出"
				s value=feedetail.Get(inum).Get("psn_cash_pay")		// 个人现金支出
				d GetPrescNoybInfoOutput
				
				s valueDesc="结算时间"
				s value=feedetail.Get(inum).Get("setl_time")		// 结算时间
				d GetPrescNoybInfoOutput
				
				s valueDesc="定点医药机构编号(结算)"
				s value=feedetail.Get(inum).Get("fixmedins_code")		// 定点医药机构编号(结算)
				d GetPrescNoybInfoOutput
				
				s valueDesc="定点医药机构名称(结算)"
				s value=feedetail.Get(inum).Get("fixmedins_name")		// 定点医药机构名称(结算)
				d GetPrescNoybInfoOutput
			}
		}
		
		i InterType="7102"{
			f inum=0:1:(cnt-1)
			{
				s valueDesc="医保处方编号"
				s value=jsonOutputObj.output.data.Get("hi_rxno")		// 医保处方编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="医药机构名称（审方）"
				s value=jsonOutputObj.output.data.Get("fixmedins_name")		// 医药机构名称（审方）
				d GetPrescNoybInfoOutput
				
				s valueDesc="医药机构编号（审方）"
				s value=jsonOutputObj.output.data.Get("fixmedins_code")		// 医药机构编号（审方）
				d GetPrescNoybInfoOutput
				
				s valueDesc="药师证件类型"
				s value=jsonOutputObj.output.data.Get("phar_cert_type")		// 药师证件类型
				//s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
				s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type"_InsuType,value,4,HospDr)
				d GetPrescNoybInfoOutput
				
				s valueDesc="药师证件号码"
				s value=jsonOutputObj.output.data.Get("phar_certno")		// 药师证件号码
				d GetPrescNoybInfoOutput
				
				s valueDesc="药师姓名"
				s value=jsonOutputObj.output.data.Get("phar_name")		// 药师姓名
				d GetPrescNoybInfoOutput
				
				s valueDesc="药师执业资格证号"
				s value=jsonOutputObj.output.data.Get("phar_prac_cert_no")		// 药师执业资格证号
				d GetPrescNoybInfoOutput
				
				s valueDesc="复核药师证件类型"
				s value=jsonOutputObj.output.data.Get("rchk_phar_cert_type")		// 复核药师证件类型
				//s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
				s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type"_InsuType,value,4,HospDr)
				d GetPrescNoybInfoOutput
				
				s valueDesc="复核药师证件编号"
				s value=jsonOutputObj.output.data.Get("rchk_phar_certno")		// 复核药师证件编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="复核药师姓名"
				s value=jsonOutputObj.output.data.Get("rchk_phar_name")		// 复核药师姓名
				d GetPrescNoybInfoOutput
				
				s valueDesc="配药人证件类型"
				s value=jsonOutputObj.output.data.Get("dspeer_cert_type")		// 配药人证件类型
				//s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type00A",value,4)
				s value=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_cert_type"_InsuType,value,4,HospDr)
				d GetPrescNoybInfoOutput
				
				s valueDesc="配药人证件编号"
				s value=jsonOutputObj.output.data.Get("dspeer_certno")		// 配药人证件编号
				d GetPrescNoybInfoOutput
				
				s valueDesc="配药人姓名"
				s value=jsonOutputObj.output.data.Get("dspeer_name") 		// 配药人姓名
				d GetPrescNoybInfoOutput
				
				s valueDesc="处方审核状态代码"
				s value=jsonOutputObj.output.data.Get("rx_chk_stas_codg") 		// 处方审核状态代码
				s value=$case(value,"0":"审核不通过","1":"审核通过")
				d GetPrescNoybInfoOutput
				
				s valueDesc="处方审核意见"
				s value=jsonOutputObj.output.data.Get("rx_chk_opnn") 		// 处方审核意见
				d GetPrescNoybInfoOutput
				
				s valueDesc="处方审核时间"
				s value=jsonOutputObj.output.data.Get("rx_chk_time") 		// 处方审核时间
				d GetPrescNoybInfoOutput
			}
			
		}
			
			
	}
	elseif flag'="1" {
		s valueDesc=$p(outputData,"^",1)
		s value=$p(outputData,"^",2) 		
		d GetPrescNoybInfoOutput
	}
	;end upt HanZH 20220630
	
	quit $$$OK	
GetPrescNoybInfoOutput
 	set Data=$lb(valueDesc,value)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Description: 判断是否是外配处方,是否需要上传  。根据项目上自行调整
/// Input: 处方号
/// Output: Return:0普通,1外配处方需要上传
/// Debug: w ##class(web.NationInsuInfoUpload).GetWPPrescNoFlag("O22050800001")
ClassMethod GetWPPrescNoFlag(PrescNo As %String = "") As %String
{
	s Return="0"
	s OEOrdRowID=""
	f {
		s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID)) q:OEOrdRowID=""
		s OEOrdItemSub=""
		f {
			s OEOrdItemSub=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,OEOrdItemSub)) q:(OEOrdItemSub="")||(Return="1")
			s ArcimID=$p($g(^OEORD(OEOrdRowID,"I",OEOrdItemSub,1)),"^",2)
			s ArcimRowID=+ArcimID
			s ArcimSub=$p(ArcimID,"||",2)
			s ArcimDesc=$p(^ARCIM(ArcimRowID,ArcimSub,1),"^",2)
			;i ArcimDesc["外配" s Return=1
			s Return=1
		}
	}
 	q Return
}

///       ---------------------------------------7101 end----------------------------------

}
