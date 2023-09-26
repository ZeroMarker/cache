/// CTOR: QP
/// DATE: 2020-08-20
/// DESC: 化疗导入操作
Class DHCDoc.Chemo.BS.Ext.Import Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-20
/// DESC: 导入模板
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).TPL()
ClassMethod TPL(PList)
{
	s PLNum=$o(PList(""),-1)
	Q:(PLNum="")||(PLNum=1) "-1^模板没有维护数据！"
	
	//数据整合
	s FieldList=PList(1)
	s VNum=0
	f i=2:1:PLNum {
		s VList=PList(i)
		s VLen=$L(VList,$C(1))
		s VOBJ=##class(DHCDoc.Chemo.Model.ImportTPL).%New()
		f j=1:1:VLen {
			s cName=$p(FieldList,$c(1),j)
			s cValue=$P(VList,$c(1),j)
			i cValue["^" s cValue=$tr(cValue,"^",",")
			continue:cName=""
			s $ZOBJPROPERTY(VOBJ, cName)=cValue
		}
		continue:VOBJ.TPName=""
		s VNum=VNum+1
		s VDATA(VNum)=VOBJ
	}
	s tmpLen=$o(VDATA(""),-1)
	Q:tmpLen="" "-1^模板没有维护数据！"
	
	//字段对照和校验
	s IsPassStr=..CompactField(.VDATA)
	s IsPass=$p(IsPassStr,$C(2),1)
	Q:IsPass=0 "-1^"_$p(IsPassStr,$C(2),2)
	
	//数据存储
	s VLen=$o(VDATA(""),-1)
	//s ^QP("Import","VLen")=VLen
	
	TS
	s saveFlag=0
	f i=1:1:VLen {
		s COBJ=VDATA(i)
		;s ^QP("Import","COBJ",i)=COBJ.TPType_": "_COBJ.TPDesc
		;存储模板
		s saveFlag=##class(DHCDoc.Chemo.CFG.Template).SaveTPL("", COBJ)
		q:saveFlag<0
		s TPID=saveFlag
		;存储阶段
		s saveFlag=##class(DHCDoc.Chemo.CFG.Stage).Save(TPID,"",COBJ)
		q:+saveFlag<0
		s TSID=saveFlag
		;存储化疗组
		s saveFlag=##class(DHCDoc.Chemo.CFG.Group).Save(TSID,"",COBJ)
		q:+saveFlag<0
		s TGID=saveFlag
		continue:COBJ.TIArcim=""
		;存储化疗项目
		;一个组内是否可以存在相同的医嘱，目前允许
		s saveFlag=##class(DHCDoc.Chemo.CFG.Item).SaveTPLGroupItem(TGID,"",COBJ)
		q:saveFlag<0
	}
	
	i +saveFlag<0 {
		TRO
		s ^QP("Import","Error")=$lb(saveFlag,COBJ.TIArcim,i)
		Q -1_"^保存失败！"	
	}
	
	TC
	
	Q 1_"^导入成功！"
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 导入模板备注
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).TPLNote()
ClassMethod TPLNote(PList)
{
	s PLNum=$o(PList(""),-1)
	Q:(PLNum="")||(PLNum=1) "-1^模板没有维护数据！"
	
	//数据整合
	s FieldList=PList(1)
	s VNum=0
	f i=2:1:PLNum {
		s VList=PList(i)
		s VLen=$L(VList,$C(1))
		s VOBJ=##class(DHCDoc.Chemo.Model.ImportTPLNote).%New()
		f j=1:1:VLen {
			s cName=$p(FieldList,$c(1),j)
			s cValue=$P(VList,$c(1),j)
			i cValue["^" s cValue=$tr(cValue,"^",",")
			continue:cName=""
			s $ZOBJPROPERTY(VOBJ, cName)=cValue
		}
		continue:VOBJ.TPName=""
		s VNum=VNum+1
		s VDATA(VNum)=VOBJ
	}
	s tmpLen=$o(VDATA(""),-1)
	Q:tmpLen="" "-1^模板没有维护数据！"
	
	//字段对照和校验
	s IsPassStr=..CompactNote(.VDATA)
	s IsPass=$p(IsPassStr,$C(2),1)
	Q:IsPass=0 "-1^"_$p(IsPassStr,$C(2),2)
	
	//数据存储
	s VLen=$o(VDATA(""),-1)
	
	TS
	s saveFlag=0
	f i=1:1:VLen {
		s COBJ=VDATA(i)
		;存储模板
		s saveFlag=##class(DHCDoc.Chemo.CFG.Template).SaveTPLNote(COBJ)
		q:saveFlag<0
	}
	
	i +saveFlag<0 {
		TRO
		Q -1_"^保存失败！"	
	}
	
	TC
	
	Q 1_"^导入成功！"
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 字段对照
/// IN  : 
/// OUT : 0：对照失败，字段有错，1: 对照通过
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CompactField(VDATA)
{
	s mRtn=1,Msg=""
	
	s VLen=$o(VDATA(""),-1)
	f i=1:1:VLen {
		Q:mRtn'=1
		
		;校验模板相关字段
		s tplCheck=..CheckTPL(VDATA(i),i)
		i +tplCheck=0 {
			s mRtn=0,Msg=$p(tplCheck,$C(2),2)
		}
		Q:mRtn'=1
		
		;校验周期相关字段
		s stageCheck=..CheckStage(VDATA(i),i)
		i +stageCheck=0 {
			s mRtn=0,Msg=$p(stageCheck,$C(2),2)
		}
		Q:mRtn'=1
		
		;校验化疗组相关字段
		s groupCheck=..CheckGroup(VDATA(i),i)
		i +groupCheck=0 {
			s mRtn=0,Msg=$p(groupCheck,$C(2),2)
		}
		Q:mRtn'=1
		
		;校验化疗项目相关字段
		s itemCheck=..CheckItem(VDATA(i),i)
		i +itemCheck=0 {
			s mRtn=0,Msg=$p(itemCheck,$C(2),2)
		}
		Q:mRtn'=1
		
	}
	
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 字段对照
/// IN  : 
/// OUT : 0：对照失败，字段有错，1: 对照通过
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CompactNote(VDATA)
{
	s mRtn=1,Msg=""
	
	s VLen=$o(VDATA(""),-1)
	f i=1:1:VLen {
		Q:mRtn'=1
		
		;校验模板相关字段
		s tplCheck=..CheckTPLNote(VDATA(i),i)
		i +tplCheck=0 {
			s mRtn=0,Msg=$p(tplCheck,$C(2),2)
		}
		Q:mRtn'=1
		
	}
	
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 校验化疗项目相关字段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CheckItem(COBJ As DHCDoc.Chemo.Model.ImportTPL, i = 0)
{
	s mRtn=1,Msg=""
	
	Q:COBJ.TIArcimCode="" mRtn_$C(2)_Msg	//只导入组
	
	/* QP 2020-09-27 REMOVE
	;药品rowid	
	i COBJ.TIArcim="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【药品rowid】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s len=$l(COBJ.TIArcim,"||")
		i len'=2 {
			s mRtn=0,Msg="第"_(i+3)_"行，【药品rowid："_COBJ.TIArcim_"】格式错误，格式为：71||1 ！"
			Q mRtn_$C(2)_Msg	
		} else {
			s arc=+COBJ.TIArcim,sub=$p(COBJ.TIArcim,"||",2)
			i '$d(^ARCIM(arc,sub)) {
				s mRtn=0,Msg="第"_(i+3)_"行，【药品rowid："_COBJ.TIArcim_"】在HIS库中匹配失败 ！"
				Q mRtn_$C(2)_Msg	
			}
		}	
	}*/
	;药品code
	i COBJ.TIArcimCode="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【药品code】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		//^ARCIM(0,"Code",$$ALPHAUP({ARCIM_Code}),{ARCIM_Subscript},{ARCIM_Version})
		s COBJ.TIArcimCode=$zcvt(COBJ.TIArcimCode,"U")
		i '$d(^ARCIM(0,"Code",COBJ.TIArcimCode)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【剂量单位："_COBJ.TIArcimCode_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s arc=$O(^ARCIM(0,"Code",COBJ.TIArcimCode,""))
			s arcimDr=arc_"||"_1
			s COBJ.TIArcim=arcimDr
		}
			
	}
	;药品名称
	i COBJ.TIOrderName="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【药品名称】为空！"
		Q mRtn_$C(2)_Msg
	}
	
	;关联
	i COBJ.TILink="" {
		//todo	
	} else {
		s Len=$l(COBJ.TILink)
		s TILink=+COBJ.TILink
		s nLen=$l(TILink)
		i (Len'=nLen)||(TILink'=COBJ.TILink) {
			s mRtn=0,Msg="第"_(i+3)_"行，【关联："_COBJ.TILink_"】格式错误，格式为：1或1.1 ！"
			Q mRtn_$C(2)_Msg
		}		
	}
	
	;显示日期
	i COBJ.TIShowDate="" {
		//s mRtn=0,Msg="第"_(i+3)_"行，【显示日期】为空，格式为：t,t+1 ！"
		//Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TIShowDate)
		i Len=1 {
			i COBJ.TIShowDate'="t" {
				s mRtn=0,Msg="第"_(i+3)_"行，【显示日期："_COBJ.TIShowDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg	
			}
		} else {
			i (COBJ.TIShowDate'["+")||(COBJ.TIShowDate'[",") {
				s mRtn=0,Msg="第"_(i+3)_"行，【多选化疗日期："_COBJ.TIShowDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg
			}
		}
	}
	
	;输入值
	i COBJ.TIInput="" {
		//todo	
	} else {
		//todo	
	}
	
	;计算公式
	s TIFormulaArr="BSA,GFR,WGT"
	i COBJ.TIFormula="" {
		//todo	
	} else {
		i TIFormulaArr'[COBJ.TIFormula {
			s mRtn=0,Msg="第"_(i+3)_"行，【关联："_COBJ.TIFormula_"】格式错误，格式为：BSA或GFR或WGT ！"
			Q mRtn_$C(2)_Msg
		}
	}
	
	;标准值
	i COBJ.TISTValue="" {
		i COBJ.TIFormula="GFR" {
			s mRtn=0,Msg="第"_(i+3)_"行，当公式为GFR时，【标准值】不能为空 ！"
			Q mRtn_$C(2)_Msg		
		}
	} else {
		//
	}
	
	;是否主药
	s TGMainDrugArr="是,否"
	i COBJ.TIMainDrug="" {
		s COBJ.TIMainDrug="N"
	} else {
		i TGMainDrugArr'[COBJ.TIMainDrug {
			s mRtn=0,Msg="第"_(i+3)_"行，【是否主药："_COBJ.TIMainDrug_"】格式错误，格式为：是或否 ！"
			Q mRtn_$C(2)_Msg	
		} else {
			i COBJ.TIMainDrug="是" s COBJ.TIMainDrug="Y"
			e  s COBJ.TIMainDrug="N"
		}
	}
	
	;单次剂量	
	i COBJ.TIDose="" {
		//todo
	}
	
	;剂量单位		
	i COBJ.TIDoseUom="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【剂量单位】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TIDoseUom=$zcvt(COBJ.TIDoseUom,"U")
		i '$d(^CT("UOM",0,"Desc",COBJ.TIDoseUom)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【剂量单位："_COBJ.TIDoseUom_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^CT("UOM",0,"Desc",COBJ.TIDoseUom,""))
			s COBJ.TIDoseUom=uomDR
		}
	}
	
	;频次		
	i COBJ.TIFreq="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【频次】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TIFreq=$zcvt(COBJ.TIFreq,"U")
		i '$d(^PHCFR(0,"Desc1",COBJ.TIFreq)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【频次："_COBJ.TIFreq_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^PHCFR(0,"Desc1",COBJ.TIFreq,""))
			s COBJ.TIFreq=uomDR
		}
	}
	
	;用法		
	i COBJ.TIInstruc="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【用法】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		i '$d(^PHCIN(0,"Desc1",COBJ.TIInstruc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【用法："_COBJ.TIInstruc_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^PHCIN(0,"Desc1",COBJ.TIInstruc,""))
			s COBJ.TIInstruc=uomDR
		}
	}
	
	;疗程		
	i COBJ.TIDura="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【疗程】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		i '$d(^PHCDU(0,"Desc1",COBJ.TIDura)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【疗程："_COBJ.TIDura_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^PHCDU(0,"Desc1",COBJ.TIDura,""))
			s COBJ.TIDura=uomDR
		}
	}
	
	;数量	
	i COBJ.TIDose="" {
		//todo
	}
	
	;单位		
	i COBJ.TIUom="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【单位】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TIUom=$zcvt(COBJ.TIUom,"U")
		i '$d(^CT("UOM",0,"Desc",COBJ.TIUom)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【单位："_COBJ.TIUom_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^CT("UOM",0,"Desc",COBJ.TIUom,""))
			s COBJ.TIUom=uomDR
		}
	}
	
	;备注	
	i COBJ.TINote="" {
		//todo
	}
	
	;医嘱类型		
	i COBJ.TIPrior="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【医嘱类型】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s TIPrior=$zcvt(COBJ.TIPrior,"U")
		i '$d(^OECPR(0,"Desc",TIPrior)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【医嘱类型："_COBJ.TIPrior_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^OECPR(0,"Desc",TIPrior,""))
			s COBJ.TIPrior=uomDR
		}
	}
	
	;接受科室		
	i COBJ.TIRecLoc="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【接受科室】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TIRecLoc=$$ALPHAUP^SSUTIL4(COBJ.TIRecLoc)
		i '$d(^CTLOC(0,"Desc",COBJ.TIRecLoc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【接受科室："_COBJ.TIRecLoc_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^CTLOC(0,"Desc",COBJ.TIRecLoc,""))
			s COBJ.TIRecLoc=uomDR
		}
	}
	
	;输液流速
	i COBJ.TISpeed="" {
		//todo
	}
	
	;流速单位
	i COBJ.TISpeedUom="" {
		//todo
	} else {
		i '$d(^OEC("SFR",0,"Desc",COBJ.TISpeedUom)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【接受科室："_COBJ.TISpeedUom_"】在HIS库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s uomDR=$O(^OEC("SFR",0,"Desc",COBJ.TISpeedUom,""))
			s COBJ.TISpeedUom=uomDR
		}
	}
	
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 校验化疗组相关字段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CheckGroup(COBJ As DHCDoc.Chemo.Model.ImportTPL, i = 0)
{
	s mRtn=1,Msg=""
	
	;组编号校验
	i COBJ.TGCode="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【组编号】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TGCode)
		s TGCode=+COBJ.TGCode
		s nLen=$l(TGCode)
		i (Len'=nLen)||(TGCode'=COBJ.TGCode) {
			s mRtn=0,Msg="第"_(i+3)_"行，【组编号："_COBJ.TGCode_"】格式错误，只能为数字1,2,3...！"
			Q mRtn_$C(2)_Msg
		}	
	}
	
	;组描述校验
	i COBJ.TGDesc="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【组描述】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s hasGroupDesc=##class(DHCDoc.Chemo.COM.Func2).GetChemoDicIdByDesc("CHEMOGORUP",COBJ.TGDesc)
		i hasGroupDesc="" {
			s mRtn=0,Msg="第"_(i+3)_"行，【组编号："_COBJ.TGDesc_"】组描述错误，与HIS库不匹配！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TGDesc=hasGroupDesc
		
	}
	
	;多选化疗日期
	i COBJ.TGPlanDate="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【多选化疗日期】为空，格式为：t,t+1 ！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TGPlanDate)
		i Len=1 {
			i COBJ.TGPlanDate'="t" {
				s mRtn=0,Msg="第"_(i+3)_"行，【多选化疗日期："_COBJ.TGPlanDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg	
			}
		} else {
			i (COBJ.TGPlanDate'["+")||(COBJ.TGPlanDate'[",") {
				s mRtn=0,Msg="第"_(i+3)_"行，【多选化疗日期："_COBJ.TGPlanDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg
			}
		}
	}
	
	;是否主药组	
	s TGMainDrugArr="是,否"
	i COBJ.TGMainDrug="" {
		s COBJ.TGMainDrug="N"
	} else {
		i TGMainDrugArr'[COBJ.TGMainDrug {
			s mRtn=0,Msg="第"_(i+3)_"行，【是否主药组："_COBJ.TGMainDrug_"】格式错误，格式为：是或否 ！"
			Q mRtn_$C(2)_Msg	
		} else {
			i COBJ.TGMainDrug="是" s COBJ.TGMainDrug="Y"
			e  s COBJ.TGMainDrug="N"
		}
	}
	
		
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 校验周期相关字段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CheckStage(COBJ As DHCDoc.Chemo.Model.ImportTPL, i = 0)
{
	s mRtn=1,Msg=""
	
	;周期代码校验
	i COBJ.TSCode="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【周期代码】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TSCode)
		s TSCode=+COBJ.TSCode
		s nLen=$l(TSCode)
		i (Len'=nLen)||(TSCode'=COBJ.TSCode) {
			s mRtn=0,Msg="第"_(i+3)_"行，【周期代码："_COBJ.TSCode_"】格式错误，只能为数字1,2,3...！"
			Q mRtn_$C(2)_Msg
		}	
	}
	
	;周期描述校验
	i COBJ.TSDesc="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【周期描述】为空！"
		Q mRtn_$C(2)_Msg
	} 
	
	;周期开始日期
	i COBJ.TSStartDate="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【周期开始日期】为空，格式为：t或t+1 ！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TSStartDate)
		i Len=1 {
			i COBJ.TSStartDate'="t" {
				s mRtn=0,Msg="第"_(i+3)_"行，【周期开始日期："_COBJ.TSStartDate_"】格式错误，格式为：t或t+1 ！"
				Q mRtn_$C(2)_Msg	
			}
		} else {
			i COBJ.TSStartDate'["+" {
				s mRtn=0,Msg="第"_(i+3)_"行，【周期开始日期："_COBJ.TSStartDate_"】格式错误，格式为：t或t+1 ！"
				Q mRtn_$C(2)_Msg
			}
		}
	}
	
	;周期结束日期
	i COBJ.TSEndDate="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【周期结束日期】为空，格式为：t或t+1 ！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TSEndDate)
		i Len=1 {
			i COBJ.TSEndDate'="t" {
				s mRtn=0,Msg="第"_(i+3)_"行，【周期开始日期："_COBJ.TSEndDate_"】格式错误，格式为：t或t+1 ！"
				Q mRtn_$C(2)_Msg	
			}
		} else {
			i COBJ.TSEndDate'["+" {
				s mRtn=0,Msg="第"_(i+3)_"行，【周期开始日期："_COBJ.TSEndDate_"】格式错误，格式为：t或t+1 ！"
				Q mRtn_$C(2)_Msg
			}
		}
	}
	
	;周期数
	i COBJ.TSNextNum="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【周期数】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TSNextNum)
		s TSNextNum=+COBJ.TSNextNum
		s nLen=$l(TSNextNum)
		i (Len'=nLen)||(TSNextNum'=COBJ.TSNextNum) {
			s mRtn=0,Msg="第"_(i+3)_"行，【周期代码："_COBJ.TSNextNum_"】格式错误，只能为数字1,2,3...！"
			Q mRtn_$C(2)_Msg
		}	
	}
	
	;化疗日期
	i COBJ.TSChemoDate="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【化疗日期】为空，格式为：t,t+1 ！"
		Q mRtn_$C(2)_Msg
	} else {
		s Len=$l(COBJ.TSChemoDate)
		i Len=1 {
			i COBJ.TSChemoDate'="t" {
				s mRtn=0,Msg="第"_(i+3)_"行，【化疗日期："_COBJ.TSChemoDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg	
			}
		} else {
			i (COBJ.TSChemoDate'["+")||(COBJ.TSChemoDate'[",") {
				s mRtn=0,Msg="第"_(i+3)_"行，【多选化疗日期："_COBJ.TGPlanDate_"】格式错误，格式为：t,t+1 ！"
				Q mRtn_$C(2)_Msg
			}
		}
	}
	
		
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-08-21
/// DESC: 校验模板相关字段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CheckTPL(COBJ As DHCDoc.Chemo.Model.ImportTPL, i = 0)
{
	s mRtn=1,Msg=""
	s TPTypeArr="医院,科室,用户"
	i TPTypeArr'[COBJ.TPType {
		s mRtn=0,Msg="第"_(i+3)_"行，【模板类型："_COBJ.TPType_"】错误，模板类型为：医院、科室、用户！"
	}
	i COBJ.TPType="医院" {
		s COBJ.TPType="HOSP"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^CT("HOSP",0,"Desc",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s HospID=$O(^CT("HOSP",0,"Desc",COBJ.TPDesc,""))
			s COBJ.TPDesc=HospID
		}
		
	} elseif (COBJ.TPType="科室") {
		s COBJ.TPType="DEP"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^CTLOC(0,"Desc",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s LocID=$O(^CTLOC(0,"Desc",COBJ.TPDesc,""))
			s COBJ.TPDesc=LocID
		}
	} else {
		s COBJ.TPType="USER"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^SSU("SSUSR",0,"SSUSR_Name",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s LocID=$O(^SSU("SSUSR",0,"SSUSR_Name",COBJ.TPDesc,""))
			s COBJ.TPDesc=LocID
		}
	}
	
	;方案名称校验
	i COBJ.TPName="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【化疗方案名称】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",COBJ.TPType,COBJ.TPDesc,COBJ.TPName)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【化疗方案名称】已经存在，不能再次导入！"
			Q mRtn_$C(2)_Msg
		}

	}
	
	;总周期数校验
	i COBJ.TPStageNum="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【总周期数】为空！"
		Q mRtn_$C(2)_Msg
	}
	
	;所属院区为空
	i COBJ.TPHosp="" {
		s mRtn=0,Msg="第"_(i+3)_"行，【所属院区】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TPHosp=$$ALPHAUP^SSUTIL4(COBJ.TPHosp)
		i '$d(^CT("HOSP",0,"Desc",COBJ.TPHosp)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【所属院区："_COBJ.TPHosp_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s HospID=$O(^CT("HOSP",0,"Desc",COBJ.TPHosp,""))
			s COBJ.TPHosp=HospID
		}
	}
	
	Q mRtn_$C(2)_Msg
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 校验模板相关字段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Import).CompactField()
ClassMethod CheckTPLNote(COBJ As DHCDoc.Chemo.Model.ImportTPLNote, i = 0)
{
	s mRtn=1,Msg=""
	
	s TPTypeArr="医院,科室,用户"
	
	;模板类型
	i COBJ.TPType="" {
		s mRtn=0,Msg="第"_(i+2)_"行，【模板类型】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		i TPTypeArr'[COBJ.TPType {
			s mRtn=0,Msg="第"_(i+2)_"行，【模板类型："_COBJ.TPType_"】错误，模板类型为：医院、科室、用户！"
			Q mRtn_$C(2)_Msg
		}
	}
	
	;模板描述
	i COBJ.TPType="医院" {
		s COBJ.TPType="HOSP"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+2)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^CT("HOSP",0,"Desc",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+2)_"行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s HospID=$O(^CT("HOSP",0,"Desc",COBJ.TPDesc,""))
			s COBJ.TPDesc=HospID
		}
		
	} elseif (COBJ.TPType="科室") {
		s COBJ.TPType="DEP"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+2)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^CTLOC(0,"Desc",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+2)_"、行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s LocID=$O(^CTLOC(0,"Desc",COBJ.TPDesc,""))
			s COBJ.TPDesc=LocID
		}
	} else {
		s COBJ.TPType="USER"
		
		;模板描述校验
		i COBJ.TPDesc="" {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述】为空！"
			Q mRtn_$C(2)_Msg
		}
		s COBJ.TPDesc=$$ALPHAUP^SSUTIL4(COBJ.TPDesc)
		i '$d(^SSU("SSUSR",0,"SSUSR_Name",COBJ.TPDesc)) {
			s mRtn=0,Msg="第"_(i+3)_"行，【模板描述："_COBJ.TPDesc_"】在HIS字典库中匹配失败！"
			Q mRtn_$C(2)_Msg
		} else {
			s LocID=$O(^SSU("SSUSR",0,"SSUSR_Name",COBJ.TPDesc,""))
			s COBJ.TPDesc=LocID
		}
	}
	
	;方案名称
	i COBJ.TPName="" {
		s mRtn=0,Msg="第"_(i+2)_"行，【方案名称】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		//检查方案是否存在
		i '$d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",COBJ.TPType,COBJ.TPDesc,COBJ.TPName)) {
			s mRtn=0,Msg="第"_(i+2)_"行，【方案名称】在数据库里不存在！"
			Q mRtn_$C(2)_Msg
		} else {
			s TPID=$O(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",COBJ.TPType,COBJ.TPDesc,COBJ.TPName,"")) 
			s COBJ.TPID=TPID
		}
	}
	
	;主药备注
	i COBJ.TPNote="" {
		s mRtn=0,Msg="第"_(i+2)_"行，【主药备注】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TPNote=$tr(COBJ.TPNote,"#",$c(10))
	}
	
	;化疗标题
	i COBJ.TPTitle="" {
		s mRtn=0,Msg="第"_(i+2)_"行，【化疗标题】为空！"
		Q mRtn_$C(2)_Msg
	} else {
		s COBJ.TPTitle=$tr(COBJ.TPTitle,"#",$c(10))
	}
	
	
	Q mRtn_$C(2)_Msg
}

}
