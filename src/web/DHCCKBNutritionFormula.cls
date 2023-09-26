Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-05
/// Descript: 	所需营养计算表达式
Class web.DHCCKBNutritionFormula Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存
ClassMethod save(params)
{
	n (params)
	s id=$p(params,"^",1)
	s patType=$p(params,"^",2)
	s nutType=$p(params,"^",3)
	s cat=$p(params,"^",4)
	s desc=$p(params,"^",5)
	s press=$p(params,"^",6)
	s flag=$p(params,"^",7)
	s scope=$p(params,"^",8)
	s note=$p(params,"^",9)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionFormula (NF_PatType,NF_NutType_Dr,NF_Cat,NF_Desc,NF_Press,NF_Scope,NF_Note,NF_ActiveFlag) 
			VALUES (:patType,:nutType,:cat,:desc,:press,:scope,:note,:flag))
	}else{
		&sql(UPDATE DHC_CKBNutritionFormula SET NF_PatType=:patType,NF_NutType_Dr=:nutType,NF_Cat=:cat,NF_Desc=:desc,NF_Press=:press,
			NF_Scope=:scope,NF_Note=:note,NF_ActiveFlag=:flag WHERE NF_RowID=:id)
	}
	q SQLCODE
}

/// Descript:删除
ClassMethod delete(id)
{
	n (id)
	&sql(DELETE DHC_CKBNutritionType WHERE NT_RowID=:id)	
	q SQLCODE
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionFormula).list(1,10,"A^")
ClassMethod list(page = 1, rows = 10, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inPatType=$p(params,"^",1)
	s inNutType=$p(params,"^",2)
	s inNutCat=$p(params,"^",3)
	
	s title="id^patType^nutType^press^pressDesc^flag^patTypeDesc^nutTypeDesc^cat^desc^scope^note"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionFormulaD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionFormulaD(id)
		s patType=$lg(itmLbData,2)
		continue:(inPatType'="")&&(inPatType'=patType)
		s nutType=$lg(itmLbData,3)
		continue:(inNutType'="")&&(inNutType'=nutType)
		s cat=$lg(itmLbData,6)
		continue:(inNutCat'="")&&(inNutCat'=cat)
		s press=$lg(itmLbData,4)
		s flag=$lg(itmLbData,5)
		s patTypeDesc=$case(patType,"C":"儿童","A":"成人","O":"老人")
		s nutTypeDesc=$lg($g(^User.DHCCKBNutritionTypeD(+nutType)),3)
	
		s desc=$lg(itmLbData,7)
		s scope=$lg(itmLbData,8)
		s note=$lg(itmLbData,9)
		s pressDesc=##class(web.DHCCKBNutritionFormula).pressDesc(press)
		s tmp = id_"^"_patType_"^"_nutType_"^"_press_"^"_pressDesc_"^"_flag_"^"_patTypeDesc_"^"_nutTypeDesc_"^"_cat_"^"_desc_"^"_scope_"^"_note
		s count = count+1
 		continue:count<start
		continue:count>end
		w $case(count,start:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,tmp)
	}
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	q ""
}

/// Descript:单位
/// w ##class(web.DHCCKBNutritionFormula).listPatType("")
ClassMethod listPatType(q)
{
	n (q)
	
	w "["
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","C^儿童") 
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text","A^成人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text","O^老人")
	w "]"
	q ""
}

/// Descript:营养
/// w ##class(web.DHCCKBNutritionFormula).listNutType("")
ClassMethod listNutType(q)
{
	n (q)
	
	w "["
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionTypeD(id))
		q:id=""
		s desc=$lg(^User.DHCCKBNutritionTypeD(id),3)
		s flag=$lg(^User.DHCCKBNutritionTypeD(id),5)
		continue:flag'="Y"
		continue:desc'[q
		s uom=$lg(^User.DHCCKBNutritionTypeD(id),4)
		s uomDesc=$p(^CT("UOM",uom),"^",2)
		s count=count+1
		s tmp=id_"^"_desc_"^"_uomDesc
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData("value^text^uom",tmp)
	}  
	w "]"
	q ""
}

/// Descript:营养
/// w ##class(web.DHCCKBNutritionFormula).listMenuData("")
ClassMethod listMenuData()
{
	
	
	w "["
	
	w "{"
	w """id"":""A"","
	w """desc"":""计算指标"","
	w """items"":["
	s id=0
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionIndicatorsD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionIndicatorsD(id)
		s desc=$lg(itmLbData,3)
		s count=count+1
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData("id^desc",id_"^"_desc)
	}
	w "]"
	w "}"
	
	w ",{"
	w """id"":""B"","
	w """desc"":""液体量"","
	w """items"":["
	w ##class(web.DHCAPPJsonCommon).getJsonData("id^desc","0^总液体量")
	w "]"
	w "}"
	
	w ",{"
	w """id"":""C"","
	w """desc"":""营养值"","
	w """items"":["
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionTypeD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionTypeD(id)
		s desc=$lg(itmLbData,3)
		s count=count+1
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData("id^desc",id_"^"_desc)
	}
	w "]"
	w "}"
	
	w "]"
	q ""
}

/// w ##class(web.DHCCKBNutritionFormula).pressDesc("[C:2]/[B:0]")
ClassMethod pressDesc(press)
{
	n (press)
	
	s ret=press
	s regStr="\[[\u4e00-\u9fa5_0-9A-D\|\:]+\]"
	s reg=##class(%Regex.Matcher).%New(regStr)
	s reg.Text=press
	while reg.Locate() {
		s one=reg.Group
		s one=$replace(one,"[","")
		s one=$replace(one,"]","")
		s type=$p(one,":",1)
		s point=$p(one,":",2)
		s typeDesc=##class(web.DHCCKBNutritionFormula).typeDesc(type)
		s pointDesc=##class(web.DHCCKBNutritionFormula).pointDesc(type,point)
		s oneDesc=typeDesc_":"_pointDesc
		s ret=$replace(ret,one,oneDesc)
	}
	q ret
}

/// w ##class(web.DHCCKBNutritionFormula).typeDesc("AS")
ClassMethod typeDesc(type)
{
	n (type)
	q:type="" ""
	q $case(type,"A":"计算指标","B":"液体量","C":"营养值",:type)
}

/// w ##class(web.DHCCKBNutritionFormula).pointDesc("A","5")
ClassMethod pointDesc(type, point)
{
	n (type, point)
	s ret=""
	i type="A" {
		s itmLbData=^User.DHCCKBNutritionIndicatorsD(point)
		s ret=$lg(itmLbData,3)	
	}elseif type="B" {
		s:point=0 ret="总液体量"
		i point'=0 {
				
		}
	}elseif type="C" {
		s itmLbData=^User.DHCCKBNutritionTypeD(point)
		s ret=$lg(itmLbData,3)
	}else{
		s ret=point
	}
	q ret
}

}
