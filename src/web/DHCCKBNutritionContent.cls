Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-04
/// Descript: 	药品需营养计算
Class web.DHCCKBNutritionContent Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存
/// w ##class(web.DHCCKBNutritionContent).save()
ClassMethod save(params)
{
	n (params)
	;^对的^对的^4^123^Y^对的
	s id=$p(params,"^",1)
	s arcDr=$p(params,"^",2)
	s nutTypeDr=$p(params,"^",3)
	s arcDose=$p(params,"^",4)
	s nutDose=$p(params,"^",5)
	s flag=$p(params,"^",6)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionContent (NC_Arc_Dr,NC_NutType_Dr,NC_Dose,NC_Content,NC_ActiveFlag) 
			VALUES (:arcDr,:nutTypeDr,:arcDose,:nutDose,:flag))
	}else{
		&sql(UPDATE DHC_CKBNutritionContent SET NC_Arc_Dr=:arcDr,NC_NutType_Dr=:nutTypeDr,NC_Dose=:arcDose
			,NC_Content=:nutDose,NC_ActiveFlag=:flag WHERE NC_RowID=:id)
	}
	q SQLCODE
}

/// Descript:删除
/// w ##class(web.DHCCKBNutritionContent).delete()
ClassMethod delete(id)
{
	n (id)
	&sql(DELETE DHC_CKBNutritionContent WHERE NC_RowID=:id)	
	q SQLCODE
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionContent).list(1,10,"")
ClassMethod list(page = 1, rows = 10, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inArcDr=$p(params,"^",1)
	s inNutTypeDr=$p(params,"^",2)
	
	s title="id^arcDr^arc^nutTypeDr^nutType^arcDose^nutDose^nutTypeUom^flag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionContentD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionContentD(id)
		s arcDr=$lg(itmLbData,2)
		s arc=$p(^ARCIM(+arcDr,$p(arcDr,"||",2),1),"^",2)
		continue:(inArcDr'="")&&(inArcDr'=arcDr)
		s nutTypeDr=$lg(itmLbData,3)
		continue:(inNutTypeDr'="")&&(inNutTypeDr'=nutTypeDr)
		s nutType = $lg(^User.DHCCKBNutritionTypeD(nutTypeDr),3)
		s arcDose=$lg(itmLbData,4)
		s nutDose=$lg(itmLbData,5)
		s flag=$lg(itmLbData,6)
		s uom=$lg(^User.DHCCKBNutritionTypeD(nutTypeDr),4)
		s nutTypeUom=$p(^CT("UOM",uom),"^",2)
		s tmp = id_"^"_arcDr_"^"_arc_"^"_nutTypeDr_"^"_nutType_"^"_arcDose_"^"_nutDose_"^"_nutTypeUom_"^"_flag
		s count = count+1
 		continue:count<start
		continue:count>end
		w $case(count,start:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,tmp)
	}
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	q ""
}

/// w ##class(web.DHCCKBNutritionContent).listOneArc(1,10,"")
ClassMethod listOneArc(page, rows, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inArcDr=$p(params,"^",1)
	q:+inArcDr=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) ///空字符串
	
	
	s title="id^arcDr^arc^nutTypeDr^nutType^arcDose^nutDose^nutTypeUom^flag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionContentI("arc",inArcDr,id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionContentD(id)
		s arcDr=$lg(itmLbData,2)
		s arc=$p(^ARCIM(+arcDr,$p(arcDr,"||",2),1),"^",2)
		;continue:(inArcDr'="")&&(inArcDr'=arcDr)
		s nutTypeDr=$lg(itmLbData,3)
		;continue:(inNutTypeDr'="")&&(inNutTypeDr'=nutTypeDr)
		s nutType = $lg(^User.DHCCKBNutritionTypeD(nutTypeDr),3)
		s arcDose=$lg(itmLbData,4)
		s nutDose=$lg(itmLbData,5)
		s flag=$lg(itmLbData,6)
		s uom=$lg(^User.DHCCKBNutritionTypeD(nutTypeDr),4)
		s nutTypeUom=$p(^CT("UOM",uom),"^",2)
		s tmp = id_"^"_arcDr_"^"_arc_"^"_nutTypeDr_"^"_nutType_"^"_arcDose_"^"_nutDose_"^"_nutTypeUom_"^"_flag
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
/// w ##class(web.DHCCKBNutritionContent).listArc("ptt")
ClassMethod listArc(q)
{
	n (q)
	
	s q=$zcvt(q,"U")
	w "["
	s id=0,count=0
	f {
		s id=$o(^ARCIM(id))
		q:id=""
		s sub=0
		f {
			s sub=$o(^ARCIM(id,sub))
			q:sub=""	
			s desc=$p(^ARCIM(id,sub,1),"^",2)
			s thisId=id_"||"_sub
			s py=##class(web.DHCCKBNutritionContent).arcPy(thisId)
			s allDesc=py_desc
			continue:allDesc'[q
			;q:count>500
			s count=count+1
			s tmp=thisId_"^"_desc
			w $case(count,1:"",:",") 
			w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		}
	}  
	w "]"
	q ""
}

/// w ##class(web.DHCCKBNutritionContent).arcPy("254||2")
ClassMethod arcPy(arcId)
{
	n (arcId)
	s ret=""
	s arcAliasId=0
	f {
		s arcAliasId=$o(^ARC("ALIAS",0,"ARCIM",arcId,arcAliasId))
		q:ret'=""
		q:arcAliasId=""
		s ret=$p($g(^ARC("ALIAS",arcAliasId)),"^",6)
	}
	q ret
}

}
