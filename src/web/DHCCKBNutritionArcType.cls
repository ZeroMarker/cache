Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-04
/// Descript: 	营养成分字典
Class web.DHCCKBNutritionArcType Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存
ClassMethod save(params)
{
	n (params)
	
	ts
	
	s err=0
	s len=$l(params,"$$")
	f i=1:1:len{
		s oneParams=$p(params,"$$",i)
		q:oneParams=""
		s err=..saveOne(oneParams)
		q:err'=0
	}
	tro:err'=0
	q:err'=0 "保存失败,失败信息:"_err
	
	tc
	q 0
}

ClassMethod saveOne(params)
{
	n (params)
	s id=$p(params,"^",1)
	s code=$p(params,"^",2)
	s desc=$p(params,"^",3)
	s parDr=$p(params,"^",4)
	s flag=$p(params,"^",5)
	s no=$p(params,"^",6)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionArcType (NAT_Code,NAT_Desc,NAT_ActiveFlag,NAT_No,NAT_Par_Dr) 
			VALUES (:code,:desc,:flag,:no,:parDr))
	}else{
		&sql(UPDATE DHC_CKBNutritionArcType SET NAT_Code=:code,NAT_Desc=:desc,
			NAT_ActiveFlag=:flag,NAT_No=:no,NAT_Par_Dr=:parDr WHERE NAT_RowID=:id)
	}
	q SQLCODE
}

ClassMethod saveArc(params)
{
	n (params)
	s id=$p(params,"^",1)
	s nutArcType=$p(params,"^",2)
	s arc=$p(params,"^",3)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionArcLink (NAL_ArcType_Dr,NAL_Arc_Dr) 
			VALUES (:nutArcType,:arc))
	}else{
		&sql(UPDATE DHC_CKBNutritionArcLink SET NAL_ArcType_Dr=:nutArcType,NAL_Arc_Dr=:arc WHERE NAL_RowID=:id)
	}
	q SQLCODE
}

/// Descript:删除
ClassMethod delete(id)
{
	n (id)
	ts
	&sql(DELETE DHC_CKBNutritionArcType WHERE NAT_RowID=:id)	
	tro:SQLCODE'=0
	q:SQLCODE'=0 "删除DHC_CKBNutritionArcType异常,信息"_SQLCODE
	
	i $d(^User.DHCCKBNutritionArcLinkI("type",id)) {
		&sql(DELETE DHC_CKBNutritionArcLink WHERE NAL_ArcType_Dr=:id)
	}
	tro:SQLCODE'=0
	q:SQLCODE'=0 "删除DHC_CKBNutritionArcLink异常,信息"_SQLCODE
	
	tc
	q SQLCODE
}

/// Descript:删除
/// w ##class(web.DHCCKBNutritionArcType).deleteArc(25)
ClassMethod deleteArc(id)
{
	n (id)
	
	ts
	
	s SQLCODE=0
	
	s arcDr=$lg(^User.DHCCKBNutritionArcLinkD(id),3)
	q:+arcDr=0 SQLCODE
	
	i $d(^User.DHCCKBNutritionContentI("arc",arcDr)){
		&sql(DELETE DHC_CKBNutritionContent WHERE NC_Arc_Dr=:arcDr)
	}
	tro:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	
	&sql(DELETE DHC_CKBNutritionArcLink WHERE NAL_RowID=:id)
	tro:SQLCODE'=0
	q:SQLCODE'=0 SQLCOD
	
	tc

	q 0
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionArcType).list(1,10,"")
ClassMethod list(page = 1, rows = 10, params)
{
	n (page,rows,params)
	
	s inCode=$p(params,"^",1)
	s inDesc=$p(params,"^",2)
	
	s title="id^code^desc^flag^no^parDr^_parentId"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionArcTypeD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionArcTypeD(id)
		s code=$lg(itmLbData,2)
		continue:(code'[inCode)&&(code'="")
		s desc=$lg(itmLbData,3)
		continue:(desc'[inDesc)&&(inDesc'="")
		s flag=$lg(itmLbData,4)
		continue:flag'="Y"
		s no=$lg(itmLbData,5)
		s parId=$lg(itmLbData,6)
		s tmp = id_"^"_code_"^"_desc_"^"_flag_"^"_no_"^"_parId_"^"_parId
		s count = count+1
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,tmp)
	}
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	q ""
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionType).list(1,10,"")
ClassMethod listTableArc(page = 1, rows = 10, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inNutArcType=$p(params,"^",1)
	s inArcId=$p(params,"^",2)
	
	s title="id^nutArcType^nutArcTypeDesc^arc^arcDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionArcLinkD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionArcLinkD(id)
		s nutArcType=$lg(itmLbData,2)
		s nutArcTypeDesc=$lg(^User.DHCCKBNutritionArcTypeD(nutArcType),3)
		;continue:(inNutArcType'="")&&(nutArcType'=inNutArcType)
		continue:nutArcType'=inNutArcType
		s arc=$lg(itmLbData,3)
		continue:(inArcId'="")&&(arc'=inArcId)
		s arcDesc=$p($g(^ARCIM(+arc,$p(arc,"||",2),1)),"^",2)
		
		s tmp = id_"^"_nutArcType_"^"_nutArcTypeDesc_"^"_arc_"^"_arcDesc
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
/// w ##class(web.DHCCKBNutritionType).listUnit()
ClassMethod listUnit(q)
{
	n (q)
	
	w "["
	s id=0,count=0
	f {
		s id=$o(^CT("UOM",id))
		q:id=""
		s desc=$p(^CT("UOM",id),"^",2)
		continue:desc'[q
		s count=count+1
		s tmp=id_"^"_desc
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}  
	w "]"
	q ""
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionArcType).listArcType("")
ClassMethod listArcType(q)
{
	n (q)
	
	w "["
	s title="value^text"
	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionArcTypeD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionArcTypeD(id)
		s flag=$lg(itmLbData,4)
		continue:flag'="Y"
		s desc=$lg(itmLbData,3)
		continue:(desc'[q)&&(q'="")
		s tmp = id_"^"_desc
		s count = count+1
		w $case(count,1:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,tmp)
	}
	w "]"
	q ""
}

}
