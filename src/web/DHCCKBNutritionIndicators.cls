Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-04
/// Descript: 	计算指标字典模块
Class web.DHCCKBNutritionIndicators Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存
ClassMethod save(params)
{
	n (params)
	;^对的^对的^4^123^Y^对的
	s id=$p(params,"^",1)
	s code=$p(params,"^",2)
	s desc=$p(params,"^",3)
	s uom=$p(params,"^",4)
	s valueMethod=$p(params,"^",5)
	s flag=$p(params,"^",6)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionIndicators (NI_Code,NI_Desc,NI_Unit,NI_ValueMethod,NI_ActiveFlag) 
			VALUES (:code,:desc,:uom,:valueMethod,:flag))
	}else{
		&sql(UPDATE DHC_CKBNutritionIndicators SET NI_Code=:code,NI_Desc=:desc,NI_Unit=:uom,NI_ValueMethod=:valueMethod,
			NI_ActiveFlag=:flag WHERE NI_RowID=:id)
	}
	q SQLCODE
}

/// Descript:删除
ClassMethod delete(id)
{
	n (id)
	&sql(DELETE DHC_CKBNutritionIndicators WHERE NI_RowID=:id)	
	q SQLCODE
}

/// Descript:列表
/// w ##class(web.DHCCKBNutritionIndicators).list(1,10,"")
ClassMethod list(page = 1, rows = 10, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inCode=$p(params,"^",1)
	s inDesc=$p(params,"^",2)
	
	s title="id^code^desc^valueMethod^flag^unitDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionIndicatorsD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionIndicatorsD(id)
		s code=$lg(itmLbData,2)
		continue:code'[inCode
		s desc=$lg(itmLbData,3)
		continue:desc'[inDesc
		s unitDesc=$lg(itmLbData,4)
		s valueMethod=$lg(itmLbData,5)
		s flag=$lg(itmLbData,6)
		s tmp = id_"^"_code_"^"_desc_"^"_valueMethod_"^"_flag_"^"_unitDesc
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
/// w ##class(web.DHCCKBNutritionIndicators).listUnit()
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

}
