Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-04
/// Descript: 	PN计算主页
Class web.DHCCKBNutritionMain Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod get(key, admId)
{
	q:+admId=0 ""
	s patId=$p(^PAADM(admId),"^",1)
	s ret=""
	i key="weight" {
		s ret="62"
	}
	i key="height" {
		s ret="1.72"
	}
	i key="year" {
		s ret=+##Class(web.DHCBillInterface).GetPapmiAge(patId,admId)
	}
	q ret
}

/// 就诊ID
/// w ##class(web.DHCCKBNutritionMain).listNurInd(1)
ClassMethod listNurInd(admId)
{
	n (admId)
	s title="id^desc^thisValue"
	w "["
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionIndicatorsD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionIndicatorsD(id)
		s flag=$lg(itmLbData,6)
		continue:flag'="Y"
		s unit=$lg(itmLbData,4)
		s valueMethod=$lg(itmLbData,5)
		s thisValue=""
		i valueMethod'=""{
			s valueMethod="s thisValue="_valueMethod
			x valueMethod
		}
		s unitDesc=$p($g(^CT("UOM",+unit)),"^",2)
		s desc=$lg(itmLbData,3)
		s:unitDesc'="" desc=desc_"("_unitDesc_")"
		s tmp = id_"^"_desc_"^"_$g(thisValue)
		s count = count+1
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,tmp)
	}	
	w "]"
	q ""
}

/// arcContent:医嘱项id1^剂量1^剂量单位1##医嘱项id2^剂量2^剂量单位2...
/// w ##class(web.DHCCKBNutritionMain).listArc(1,"E190131000005","")
ClassMethod listArc(admId, precNo, arcContent = "")
{
	n (admId,precNo,arcContent)
	
	k TMPData("arc") ;医嘱项,剂量还有单位
	
	;获取排序
	s id=0
	f {
		s id=$o(^User.DHCCKBNutritionArcTypeD(id))
		q:id=""
		s no=$lg(^User.DHCCKBNutritionArcTypeD(id),5)
		s:no="" no=999
		s par=$lg(^User.DHCCKBNutritionArcTypeD(id),6)
		i +par=0 {
			s TMPData("arc","order",no,id)=""
		}else{
			;子项目，关联医嘱项目
			s TMPData("arc","data",par,no,id)=""
		}
	}
	
	;关联医嘱项目	
#;	s nutArcLinkId=0
#;	f {
#;		s nutArcLinkId=$o(^User.DHCCKBNutritionArcLinkD(nutArcLinkId))
#;		q:nutArcLinkId=""
#;		s typeId=$lg(^User.DHCCKBNutritionArcLinkD(nutArcLinkId),2)
#;		s arcType=$lg(^User.DHCCKBNutritionArcTypeD(typeId),3)
#;		s arcimId=$lg(^User.DHCCKBNutritionArcLinkD(nutArcLinkId),3)
#;		s TMPData("arc","data",arcType,arcimId)=""
#;	}
	
	if (precNo'=""){
		s ord=0
		f {
			s ord=$o(^OEORD(0,"PrescNo",precNo,ord))
			q:ord=""
			s itm=0
			f {
				s itm=$o(^OEORD(0,"PrescNo",precNo,ord,itm))
				q:itm=""
				s arcimId =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
				s doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
    			s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    			s nutArcLinkId = $o(^User.DHCCKBNutritionArcLinkI("arc",arcimId,""),-1)
    			continue:+nutArcLinkId=0
    			s nutArcTypeId=$lg(^User.DHCCKBNutritionArcLinkD(nutArcLinkId),2)
    			s nowValue=$g(TMPData("arc","uom",nutArcTypeId))
    			s nowDoseQty=$p(nowValue,"^",1)
				s TMPData("arc","uom",nutArcTypeId)=(nowDoseQty+doseQty)_"^"_unitUomId
			}
		}	
	}
	
	///
	if (arcContent'=""){
		s len=$l(arcContent,"##")
		f i=1:1:len{
			s itmData=$p(arcContent,"##",i)
			s arcimId=$p(itmData,"^",1)
			s doseQty=$p(itmData,"^",2)
			s unitUomId=$p(itmData,"^",3)
			s nutArcLinkId = $o(^User.DHCCKBNutritionArcLinkI("arc",arcimId,""),-1)
			continue:+nutArcLinkId=0
			s nutArcTypeId=$lg(^User.DHCCKBNutritionArcLinkD(nutArcLinkId),2)
			s nowValue=$g(TMPData("arc","uom",nutArcTypeId))
			s nowDoseQty=$p(nowValue,"^",1)
			s TMPData("arc","uom",nutArcTypeId)=(nowDoseQty+doseQty)_"^"_unitUomId
		}
	}
	
	b ;data
	
	s title="id^desc^thisValue"
	w "{"
	
	s oneNo="",typeCount=0
	f {
		s oneNo=$o(TMPData("arc","order",oneNo))
		q:oneNo=""
		s oneTypeId=0
		f {
			s oneTypeId=$o(TMPData("arc","order",oneNo,oneTypeId))
			q:oneTypeId=""
			
			s arcType=$lg(^User.DHCCKBNutritionArcTypeD(oneTypeId),3)
			s typeCount=typeCount+1
			w $case(typeCount,1:"",:",")
			w """"_arcType_""":["
			s count=0,twoNo=""
			f {
				s twoNo=$o(TMPData("arc","data",oneTypeId,twoNo))
				q:twoNo=""
				s twoTypeId=0
				f {
					s twoTypeId=$o(TMPData("arc","data",oneTypeId,twoNo,twoTypeId))
					q:twoTypeId=""
					s itmData=$g(TMPData("arc","uom",twoTypeId))
					s nutTypeDesc=$lg(^User.DHCCKBNutritionArcTypeD(twoTypeId),3)
					s dosc=$p(itmData,"^",1)
					s uomId=$p(itmData,"^",2)
					s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
					s count=count+1
					w $case(count,1:"",:",")
					s tmp=twoTypeId_"^"_nutTypeDesc_"^"_dosc_"^"_uomId_"^"_uomDesc
					w ##class(web.DHCAPPJsonCommon).getJsonData("nutTypeId^nutTypeDesc^dosc^uomId^uomDesc",tmp)
				}
			}
			w "]"
		}
	}
	w "}"
	q ""
}

/// arcContent:医嘱项id1^剂量1^剂量单位1##医嘱项id2^剂量2^剂量单位2...
/// w ##class(web.DHCCKBNutritionMain).listNutForm(1,"E190131000005","")
ClassMethod listNutForm(admId, precNo, arcContent = "")
{
	n (admId,precNo,arcContent)
	
	;k TMPData("arc") ;医嘱项,剂量还有单位
	k TMPData
	;计算指标值
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionIndicatorsD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionIndicatorsD(id)
		s flag=$lg(itmLbData,6)
		continue:flag'="Y"
		s unit=$lg(itmLbData,4)
		s valueMethod=$lg(itmLbData,5)
		s thisValue=""
		i valueMethod'=""{
			s valueMethod="s thisValue="_valueMethod
			x valueMethod
		}
		s unitDesc=$p($g(^CT("UOM",+unit)),"^",2)
		s desc=$lg(itmLbData,3)
		s TMPData("A:"_id)=thisValue
	}	
	;液体量值,营养值
	if (precNo'=""){
		s ord=0
		f {
			s ord=$o(^OEORD(0,"PrescNo",precNo,ord))
			q:ord=""
			s itm=0
			f {
				s itm=$o(^OEORD(0,"PrescNo",precNo,ord,itm))
				q:itm=""
				s arcimId =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
				s doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
    			s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    			s arcType=##class(web.DHCCKBNutritionMain).nutArcType(arcimId)
    			q:arcType=""
    			;b ;err???
				;s TMPData("order",arcType,arcimId)=doseQty_"^"_unitUomId ;输出的
				s TMPData("B:"_arcimId)=doseQty
				s TMPData("B:0")=$g(TMPData("A:0"))+doseQty
				i $d(^User.DHCCKBNutritionContentI("arc",arcimId)) {
					s ncId=0
					f {
						s ncId=$o(^User.DHCCKBNutritionContentI("arc",arcimId,ncId)) 
						q:ncId=""
						s nutTypeId=$lg(^User.DHCCKBNutritionContentD(ncId),3)
						continue:+nutTypeId=0
						s ncArcDose=$lg(^User.DHCCKBNutritionContentD(ncId),4)
						s ncNutDose=$lg(^User.DHCCKBNutritionContentD(ncId),5)
						s arcNutContDose=doseQty/ncArcDose*ncNutDose
						s noteValue = "C:"_nutTypeId
						s TMPData(noteValue)=$g(TMPData(noteValue))+arcNutContDose
					}
				}
				
			}
		}	
	}
	
	b ;errData
	
	s types="患者信息^脂肪乳稳定性^营养供给分析^其他"
	s len=$l(types,"^")
	w "{"
	s type="",typeCount=0
	f i=1:1:len{
		s type=$p(types,"^",i)
		q:type=""
		s typeCount=typeCount+1
		w $case(typeCount,1:"",:",")
		s nutFormId="",count=0
		w """"_type_""":["
		f {
			s nutFormId=$o(^User.DHCCKBNutritionFormulaI("cat",type,nutFormId))
			q:nutFormId=""
			s itmLbData=^User.DHCCKBNutritionFormulaD(nutFormId)
			s patType=$lg(itmLbData,2)
			s nutType=$lg(itmLbData,3)
			s press=$lg(itmLbData,4)
			s pressName=$lg(itmLbData,7)
			s press=$replace(press,"[","$g(TMPData(""")
			s press=$replace(press,"]","""))")
			s value=""
			i press'="" {
				try {
					s press="s value="_press
					x press
				}catch {
					s value="ERROR"
				}
			}
			;b:pressName["BSA-男" ;err
			s flag=$lg(itmLbData,5)
			s patTypeDesc=$case(patType,"C":"儿童","A":"成人","O":"老人")
			s nutTypeDesc=$lg($g(^User.DHCCKBNutritionTypeD(+nutType)),3)
			s cat=$lg(itmLbData,6)
			s desc=$lg(itmLbData,7)
			s scope=$lg(itmLbData,8)
			s note=$lg(itmLbData,9)
			s min="",max="",hint=""
			i scope["-" {
				s min=$p(scope,"-",1)
				s max=$p(scope,"-",2)
				i value<min s hint="min" ;"<span style='color:blue'>↓</span>"
				i (value>max)&&(max'="") s hint="max" ;"<span style='color:red'>↑</span>"
				s:max="" max="max"
				s $p(scope,"-",2)=max
			}
			i scope'["-" {
				s min=scope,max=scope
				i value<min s hint="min" ;"<span style='color:blue'>↓</span>"
				i (value>max)&&(max'="") s hint="max" ;"<span style='color:red'>↑</span>"
			}
			
			s count=count+1
			w $case(count,1:"",:",")
			;s value=value_hint
			s:value=0 value=""
			s tmp=nutFormId_"^"_desc_"^"_scope_"^"_value_"^"_note_"^"_hint
			w ##class(web.DHCAPPJsonCommon).getJsonData("nutFormId^desc^scope^value^note^hint ",tmp)
		}
		w "]"
	}	
	w "}"
	q ""
}

/// w ##class(web.DHCCKBNutritionMain).nutArcType("5545||1")
ClassMethod nutArcType(arcId)
{
	n (arcId)
	q:arcId="" ""
	s nutArcLinkId=$o(^User.DHCCKBNutritionArcLinkI("arc",arcId,""))
	q:+nutArcLinkId=0 "" ;"未分类"
	s nutArcType=$lg(^User.DHCCKBNutritionArcLinkD(nutArcLinkId),2)
	s nutArcTypeDesc=$lg(^User.DHCCKBNutritionArcTypeD(nutArcType),3)
	q nutArcTypeDesc
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-04-16
/// Descript:	  获取病人基本就诊信息
/// w ##Class(web.DHCCKBNutritionMain).patEssInfo("","1")
ClassMethod patEssInfo(patId As %String, admId As %String) As %String
{
	n (patId, admId)
	s:admId'="" patId=$p(^PAADM(admId),"^",1)
	
	s patName=$p(^PAPER(patId,"ALL"),"^",1)  /// 姓名
	s sexId=$p(^PAPER(patId,"ALL"),"^",7)    /// 姓别
	s patSex=$p($g(^CT("SEX",+sexId)),"^",2)
	s patBDay=$p(^PAPER(patId,"ALL"),"^",6)  /// 出生日期
	i patBDay'="" s patBDay=##Class(web.DHCMDTCom).DateLogicalToHtml(patBDay)
	s patAge=##Class(web.DHCBillInterface).GetPapmiAge(patId,admId) /// 年龄
	s mradm=$p(^PAADM(admId),"^",61)
	s patDiag=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)
	s patType=$p(^PAADM(admId),"^",2) 	           /// 就诊类型
	s admLocId=$p(^PAADM(admId),"^",4) 	  /// 就诊科室
	s patAdmLoc=$p($g(^CTLOC(admLocId)),"^",2)
	s admDoctorId=$P($g(^PAADM(admLocId)),"^",9)
	s admDoctor=$p(^CTPCP(admDoctorId,1),"^",2)
	s patAdmLocDoctor=patAdmLoc_"("_admDoctor_")"
	s admDate=$p(^PAADM(admId),"^",6)
	s admTime=$p(^PAADM(admId),"^",7)
	i admDate'="" s admDate=##Class(web.DHCMDTCom).DateLogicalToHtml(admDate)
	s admTime=$zt(admTime,1)
	s patAdmDateTime=admDate_" "_admTime
	s patPhoto=$p(^PAPER(patId,"PER",6),"^",5)	   /// 照片
	
	s title="patName^patSex^patBDay^patAge^patType^patPhoto^patDiag^patAdmLocDoctor^patAdmDateTime"
	s data=patName_"^"_patSex_"^"_patBDay_"^"_patAge_"^"_patType_"^"_patPhoto_"^"_patDiag_"^"_patAdmLocDoctor_"^"_patAdmDateTime
	w ##class(web.DHCAPPJsonCommon).getJsonData(title,data)
	q ""
}

}
