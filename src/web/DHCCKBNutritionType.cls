Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2022-07-04
/// Descript: 	营养成分字典
Class web.DHCCKBNutritionType Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
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
	s flag=$p(params,"^",5)
	
	i (+id=0){
		&sql(INSERT INTO DHC_CKBNutritionType (NT_Code,NT_Desc,NT_Unit_Dr,NT_ActiveFlag) 
			VALUES (:code,:desc,:uom,:flag))
	}else{
		&sql(UPDATE DHC_CKBNutritionType SET NT_Code=:code,NT_Desc=:desc,NT_Unit_Dr=:uom,
			NT_ActiveFlag=:flag WHERE NT_RowID=:id)
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
/// w ##class(web.DHCCKBNutritionType).list(1,10,"")
ClassMethod list(page = 1, rows = 10, params)
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	
	s inCode=$p(params,"^",1)
	s inDesc=$p(params,"^",2)
	
	s title="id^code^desc^unit^flag^unitDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()

	s id=0,count=0
	f {
		s id=$o(^User.DHCCKBNutritionTypeD(id))
		q:id=""
		s itmLbData=^User.DHCCKBNutritionTypeD(id)
		s code=$lg(itmLbData,2)
		continue:code'[inCode
		s desc=$lg(itmLbData,3)
		continue:desc'[inDesc
		s unit=$lg(itmLbData,4)
		s flag=$lg(itmLbData,5)
		s unitDesc=$p(^CT("UOM",unit),"^",2)
		s tmp = id_"^"_code_"^"_desc_"^"_unit_"^"_flag_"^"_unitDesc
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

}
