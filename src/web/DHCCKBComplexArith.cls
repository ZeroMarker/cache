/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-31
/// Descript: 		公式计算类
Class web.DHCCKBComplexArith Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-31
/// Descript: 		计算用量相关
/// w ##Class(web.DHCCKBComplexArith).CalcQty("","")
ClassMethod CalcQty(type, TmpArr) As %String
{
	n (type,TmpArr)
	
	s calcValue=0
	
	i type="BodyArea"	d
	.s weight=$g(TmpArr("Weight"))
	.s height=$g(TmpArr("Height"))
	.i $listvalid(weight)=1 s weight=$listtostring(weight)
	.i $listvalid(height)=1 s height=$listtostring(height)
	.s calcValue=..BodyArea(height,weight)

	q calcValue
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-31
/// Descript: 		体表面积用量计算
/// Input:			身高,体重
/// w ##Class(web.DHCCKBComplexArith).BodyArea(177,77)
ClassMethod BodyArea(height, weight) As %String
{
	n (height,weight)
	// 体表面积(m2)=0.0061*身高(cm)+0.0128*体重(kg)-0.1529
	q:(+height=0)||(+weight=0) 0
	
	s area=(0.0061*height)+(0.0128*weight)-0.1529
	
	q area
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		表达式计算方法
/// Input:			
/// w ##Class(web.DHCCKBComplexArith).CalcExpression("OnceDoseMax")
ClassMethod CalcExpression(prop, TmpArr) As %String
{
	
	n (prop,TmpArr)	
	
	s argExp=..GetCalcExpress(prop)		// 获取维护的表达式
	
	s runStr=..changeExpression(argExp)	// 转换表达式
	q:runStr="" ""
	s runStr="s value="_runStr  
	x runStr

	i ($listvalid(value)=1)&&($ll(value)=1)&&(+$lg(value)'=0) s value=$fn($lts(value),"N")
	i ($listvalid(value)=0)&&(+value'=0) s value = $fn(value,"N")
	//i value'="" s value = $fn(value,"N")
	s linkKey=..GetLinkKey(runStr)	// (##Class(web.DHCCKBGetFormula).GetPropValueByCode(.TmpArr,"OnceDose")) 拆除公式中的字符串OnceDose,暂时以"为分割	x runStr
	s TmpArr("LinkKey")=linkKey // 公式依赖某个因子，则找到需要依赖的这个因子：如每日最大量依赖单次剂量

	q value
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		通过属性获取属性所维护的表达式(没有配置界面之前，暂时先固定去写)
/// Input:			
/// w ##Class(web.DHCCKBComplexArith).GetCalcFunction(prop)
/// w ##Class(web.DHCCKBComplexArith).GetCalcExpress("OnceDoseMax")
ClassMethod GetCalcExpress(prop) As %String
{
	n (prop)
	
	s retStr=""
	
	i (prop="OnceDoseMax")||(prop="OnceAbsurdValue") d		// 单次最大量(或单次荒诞值)={药品.剂量} 
	.s retStr="(#Drug.OnceDose(.TmpArr,"_"""OnceDose"""_"))" 
	
	e  if prop="OnceDoseLimit"  d	// 单次极量={药品.剂量}
	.s retStr="(#Drug.LimitDose(.TmpArr,"_"""OnceDose"""_"))" 
	
	e  if (prop="DayDose")||(prop="DayDoseMax")||(prop="DayDoseLimit")||(prop="DayAbsurdValue")  d	// 每日用药量={药品.剂量}*{药品.频率}
	.s retStr="(#Drug.OnceDose(.TmpArr,"_"""OnceDose"""_"))*(#Drug.FreqNum(.TmpArr,"_"""DrugFreq.FreqFactorProp"""_"))"
	
	//e  if (prop="SolventProp") d	// 溶媒、溶液药品
	//.s retStr="(#Drug.SolventDrug(.TmpArr,"_"""SolventProp"""_"))" 
		
	e  if (prop="Solventvolume")||(prop="SolutionVolume")  d	// 溶媒/溶液体积={溶媒药品.剂量} 	
	.s findProp=$select(prop="Solventvolume":"SolventProp",prop="SolutionVolume":"SolutionProp",1:"")
	.q:findProp=""	
	.s retStr="(#Drug.SolventDose(.TmpArr,"_"""OnceDose"""_","_""""_findProp_""""_"))"
	
	e  if (prop="SolventDensity")||(prop="SolutionDensity")  d	// 溶媒/溶液浓度={溶质药品.剂量}/{溶媒药品.剂量} 
	.s findProp=$select(prop="SolventDensity":"SolventProp",prop="SolutionDensity":"SolutionProp",1:"")
	.q:findProp=""
	.s retStr="(#Drug.OnceDose(.TmpArr,"_"""OnceDose"""_")/(#Drug.SolventDose(.TmpArr,"_"""OnceDose"""_","_""""_findProp_""""_")))"	
	
	e  if (prop="万IU/m2")||(prop="单位/m2")||(prop="g/m2")||(prop="mg/m2") d // 体表面积
	.s retStr="(#Pat.BodyArea(.TmpArr,"_"""BodyArea"""_"))"	
	
	e  if (prop="g/kg")||(prop="mg/kg")||(prop="μg/kg")||(prop="ml/kg")||(prop="AXa IU/kg")||(prop="万单位/kg")||(prop="IU/kg")||(prop="单位/kg")||(prop="U/kg")||(prop="mmol/kg")||(prop="kcal/kg")||(prop="MBq/kg") d // 体重用药量
	.s retStr="(#Pat.Weight(.TmpArr,"_"""Weight"""_"))"	
	
	e  if (prop="本品过敏")  d
	.//s retStr="(distinct(.TmpArr,过敏源+药品,[{药品.药品名称}] ))"	
	
	e  if (prop="Ingredient")  d	// 成分
	.//s retStr="(#Drug.Ingr(.TmpArr,IngredientCode))"	
	
	e  if (prop="ProNameProp")  d	// 商品名
	.//s retStr="(#Drug.ProName(.TmpArr,ProNameProp))"
	
	e  if (prop="GenerNameProp")  d	// 通用名
	.//s retStr="(#Drug.ProName(.TmpArr,GenerNameProp))"
	
	e  if (prop="HighDangerFlag")  d	// 高危药品标记 2020/11/17
	.s retStr="(#Drug.HighDangerFlag(.TmpArr,"_"""HighDangerFlag"""_"))"
	
	e  if (prop="TreatBettenDayNum")  d	// 疗程间的间隔 2020/12/17
	.s retStr="(#Drug.TreatBettenDayNum(.TmpArr,"_"""Treatment"""_"))"   
	
	e  if (prop="SingleSolMass")  d	// 单只溶质量 2021/10/31
	.s retStr="(#Drug.SingleSolMass(.TmpArr,"_"""OnceDose"""_"))"  
	
	e  if (prop="PaediaDrugProp")  d	// 儿科用药标记 2022/02/28
	.s retStr="(#Drug.PaediaDrugProp(.TmpArr,"_"""PaediaDrugProp"""_"))"

	e  if (prop="IngredientDensity")  d	// 成分浓度=成分含量/{整组液体量} 2022/04/15
	.s retStr="(#Drug.IngredientDensity(.TmpArr))"
	
	e  if (prop="IngrSumDosage")  d	// 成分累计量 
	.s findProp="Ingredient"
	.q:findProp=""
	.s retStr="(#Drug.IngrSumDosage(.TmpArr,"_"""OnceDose"""_","_""""_findProp_""""_"))"
	
	e  if (prop="AuxDrugsNum")  d	// 辅助用药个数 2022/05/05
	.s retStr="(#Drug.AuxDrugsNum(.TmpArr))"
	
	e  if (prop="CombinationDrugsNum")  d	// 联合用药个数 2022/07/15
	.s retStr="(#Drug.CombinationDrugsNum(.TmpArr))"	
	
	e  if (prop="MedDrugNameProp")  d	// 西药药品名称 2022/11/09
	.s retStr="(#Drug.MedDrugNameProp(.TmpArr))"
	
	e  d	
	.//s:prop="CombinedDrugCategory" prop="DrugCategory"
	.s retStr="(#Drug.ComParams(.TmpArr,"_""""_prop_""""_"))"	// 增加默认方法,从知识库中取值
	q retStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-20
/// Descript: 		表达式拆分转换
/// Input:			表达式字符串
/// w ##Class(web.DHCCKBComplexArith).changeExpression("")
ClassMethod changeExpression(argExp As %String) As %String
{
		
		n (argExp)
		Set return=""
		Quit:argExp="" return
		Set $ZT="changeExpressionErr"
		Set (strLeft,strCenter,strRight)=""
		Set strRight=argExp
		For ind=1:1:$l(argExp,"#")-1
		{
			Set strLeft=$p(strRight,"#",1)
			Set strRight=$e(strRight,$l(strLeft)+2,$l(strRight))
			Set strCenter=$p(strRight,"(",1)		
			If ($l(strCenter,".")=2)&&(..checkMethod(strCenter)>0) {
				Set strClassMethod=..getClassMethod(strCenter)  //如:  A.B( --> ##AAA.BBB()
				Set strClassMethod=$p(strClassMethod,")",1)_")"_$p(strClassMethod,")",2)
				Set strLeft=strLeft_strClassMethod
				Set strRight=$e(strRight,$l(strCenter)+2,$l(strRight))

			}Else{
				Set strLeft=strLeft_"#"
			}
			Set return=return_strLeft
		}
		Set return=return_strRight
		//Set return=..ReplaceString(return,".and.","&&")
		//Set return=..ReplaceString(return,".or.","||")
		//Set return=..ReplaceString(return,".not","!")
		Set return=..ReplaceString(return,"[","""")
		Set return=..ReplaceString(return,"]","""")

		Quit return
	
changeExpressionErr
		Write "Error:"_$ZERROR,!
		Quit ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-20
/// Descript: 		表达式字符限定判断
/// Input:			
/// w ##Class(web.DHCCKBComplexArith).changeExpression(177,77)
ClassMethod checkMethod(argMethod As %String) As %String
{
		n (argMethod)
		Set return=1
		Quit:argMethod="" return
		For i=1:1:$l(argMethod)
		{
			Set tmp=$e(argMethod,i,i)
			Continue:tmp="."
			Set tmpASCII=$ASCII(tmp)
			If ((tmpASCII<48)||((tmpASCII>57)&&(tmpASCII<65))||((tmpASCII>90)&&(tmpASCII<97))||(tmpASCII>122)){
				Set return=-1
				Quit
			}
		}
		Quit return
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-20
/// Descript: 		通过表达式的因子，获取计算类方法
/// Input:			表达式字符串
/// w ##Class(web.DHCCKBComplexArith).getClassMethod("Drug.OnceDose")
ClassMethod getClassMethod(argMethod As %String) As %String
{
		n (argMethod)
		
		q:'$d(^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code",argMethod)) ""
				
		Quit $g(^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code",argMethod))
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-20
/// Descript: 		字符替换
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
		n (Str, OldStr, NewStr)
		set intCounter = 1
		while (1)
		{
			set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
			if (tmp = OldStr)
			{
				 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
				 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
			}
			quit:intCounter>=$l(Str)
			set intCounter = intCounter + 1
		}
		quit Str
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-25
/// Descript: 	    设置计算因子关联的类方法(没有做配置前,暂时用临时global表示)
/// w ##Class(web.DHCCKBComplexArith).SetCalcClassMethod()
ClassMethod SetCalcClassMethod()
{
	// 单次最大量
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.OnceDose")="##Class(web.DHCCKBGetFormula).GetPropValueByCode()"
	
	// 单次极量
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.LimitDose")="##Class(web.DHCCKBGetFormula).GetPropValueByCode()"
	
	// 频次系数
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.FreqNum")="##Class(web.DHCCKBGetFormula).GetPropValueByCode()"
	
	// 溶媒,溶液 药品(暂时走之前的规则)
	//s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.SolventDrug")="##Class(web.DHCCKBGetFormula).GetDataSourceByCode()"
	
	// 溶媒,溶液体积
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.SolventDose")="##Class(web.DHCCKBGetFormula).GetUnionItmValue()"
	
	// 体表面积
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Pat.BodyArea")="##Class(web.DHCCKBGetFormula).GetComPropValueByCode()"

	// 体重用药量
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Pat.Weight")="##Class(web.DHCCKBGetFormula).GetComPropValueByCode()"
	
	// 年龄
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Pat.Age")="##Class(web.DHCCKBGetFormula).GetComPropValueByCode()"
	
	// 身高
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Pat.Height")="##Class(web.DHCCKBGetFormula).GetComPropValueByCode()"
	
	// 高危药品标记
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.HighDangerFlag")="##Class(web.DHCCKBGetFormula).GetSysPropByCode()"

	// 疗程间间隔时长
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.TreatBettenDayNum")="##Class(web.DHCCKBGetFormula).CalcTreatBettenDayNum()"

	// 单只溶质量
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.SingleSolMass")="##Class(web.DHCCKBGetFormula).GetPropValueByCode()"

	// 高危药品标记 2022-02-28
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.PaediaDrugProp")="##Class(web.DHCCKBGetFormula).GetSysPropByCode()"
	
	// 成分浓度 2022-04-15
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.IngredientDensity")="##Class(web.DHCCKBGetFormula).GetIngrDensityValue()"

	// 成分累积量 2022-04-28
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.IngrSumDosage")="##Class(web.DHCCKBGetFormula).GetIngrSumDosageValue()"
	
	// 辅助用药个数 2022-05-05
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.AuxDrugsNum")="##Class(web.DHCCKBGetFormula).GetAuxDrugsNum()" 
	
	// 默认用属性取知识库的值
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.ComParams")="##Class(web.DHCCKBGetFormula).GetSysPropByCode()" 
	
	// 联合用药个数 2022-07-15
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.CombinationDrugsNum")="##Class(web.DHCCKBGetFormula).GetCombinaDrugsNum()" 
	
	// 西药的药品名称 2022-11-08
	s ^TMP("DHCCKB","web.DHCCKBComplexArith","SetCalcClassMethod","Code","Drug.MedDrugNameProp")="##Class(web.DHCCKBGetFormula).GetAllDrugName()" 

	//.s retStr="(#Drug.PaediaDrugProp(.TmpArr,"_"""PaediaDrugProp"""_"))"
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-06-08
/// Descript: 	    获取表达式中的常量，用于单位判断
/// w ##Class(web.DHCCKBComplexArith).GetLinkKey(str)
ClassMethod GetLinkKey(str)
{
	n (str)
	
	q:str="" ""
	
	q $p(str,"""",2)
}

}
