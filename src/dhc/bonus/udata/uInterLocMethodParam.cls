Class dhc.bonus.udata.uInterLocMethodParam Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-26
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterLocMethodParam).List(9,"","",1,5)
ClassMethod List(InterMethodDr, sortField, sortDir, start, limit)
{
	n (InterMethodDr, sortField, sortDir, start, limit)
	
	s sqlStr=" SELECT InterMethodParam_rowid,InterMethodParam_ParamCode,InterParam_ParamName,InterMethodParam_ParamValue,"_
		" InterMethodParam_ParamOrder,InterLocMethod_rowid,InterLocMethod_rowid->InterLocMethod_methodDesc"_
		" FROM dhc_bonus_inter.InterMethodParam a ,dhc_bonus_inter.InterParam b"_
		" where InterMethodParam_ParamCode= b.InterParam_ParamCode and InterLocMethod_rowid="_InterMethodDr 
	
	
	s sortStr=""
	s sortField1=""	
	s sortField=""
	
	i sortField'="" d
	.i sortField="ParamCode" s sortField1="InterMethodParam_ParamCode"
	.i sortField="ParamName" s sortField1="InterParam_ParamName"
	.i sortField="ParamValue" s sortField1="InterMethodParam_ParamValue"
	.i sortField="ParamOrder" s sortField1="InterMethodParam_ParamOrder"

	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY InterMethodParam_ParamCode"

	s sqlStr=sqlStr_sortStr
	
	//w sqlStr,!	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid|Methodrowid|ParamCode|ParamName|ParamValue|ParamOrder"

	//s jsonTitle="rowid^code^name^unitDr^unitName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("InterMethodParam_rowid")
		s Methodrowid = result.Data("InterLocMethod_rowid")
		s ParamCode = result.Data("InterMethodParam_ParamCode")
		s ParamName = result.Data("InterParam_ParamName")
		s ParamValue = result.Data("InterMethodParam_ParamValue")
		s ParamOrder = result.Data("InterMethodParam_ParamOrder")
					
		s tmp=rowid_"|"_Methodrowid_"|"_ParamCode_"|"_ParamName_"|"_ParamValue_"|"_ParamOrder
		//w "tmp:"_tmp,!
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// Creator：zhaoliguo
/// CreatDate：2011-4-26
/// Description: 插入一条新数据
/// Table：dhc_bonus_inter.InterLocMethod
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocMethodParam).InsertRec("4^5^04^eeee^201^errrrr^Y")
ClassMethod InsertRec(data) As %String
{
	
	n (data)

	s Methodrowid = $p(data,"~",1)
	i Methodrowid'="" s PLIST(2)=Methodrowid
	
	s ParamCode = $p(data,"~",2)
	i ParamCode'="" s PLIST(3)=ParamCode
	
	s ParamValue = $p(data,"~",3)
	i ParamValue'="" s PLIST(5)=ParamValue
	
	s ParamOrder =$p(data,"~",4)
	i ParamOrder'="" s PLIST(6)=ParamOrder
	s PLIST(4)=1

	&sql(insert into dhc_bonus_inter.InterMethodParam values PLIST())
	q SQLCODE
}

/// Creator：zhaoliguo
/// CreatDate：2011-4-26
/// Description: 插入一条新数据
/// Table：dhc_bonus_inter.InterLocMethod
/// Input：InterLocSet_rowid,InterLocMethod_methodCode, InterLocMethod_methodName ,InterLocMethod_ReturnType,InterLocMethod_order, InterLocMethod_ReturnName,InterLocMethod_active
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocMethodParam).UpdateRec("^101^^2",16)
ClassMethod UpdateRec(data, rowID) As %String
{
	
	n (data,rowID)
	
	//s Methodrowid = $p(data,"^",1)
	//i Methodrowid'="" s PLIST(2)=Methodrowid
	
	s ParamCode = $p(data,"~",2)
	i ParamCode'="" s PLIST(3)=ParamCode
	
	s ParamValue = $p(data,"~",3)
	s PLIST(5)=ParamValue
	
	s ParamOrder =$p(data,"~",4)
	i ParamOrder'="" s PLIST(6)=ParamOrder
	s PLIST(4)=1

	&sql(update dhc_bonus_inter.InterMethodParam values PLIST() where %ID=:rowID)
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate: 2011-4-26
/// Description: 删除记录
/// Table：dhc_bonus_inter.InterLocMethod
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterLocMethodParam).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from  dhc_bonus_inter.InterMethodParam  WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-26
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterLocMethodParam).getMethodParam(0,5,1)
ClassMethod getMethodParam(start, limit, flag)
{
	n (start, limit,flag)
	
	s sqlStr=" SELECT InterParam_paramCode scode,InterParam_ParamName sname  FROM dhc_bonus_inter.InterParam "_
	" where InterParam_Type="_flag_" and InterParam_active='Y' order by InterParam_paramCode"

	
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	//w sqlStr,!	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="code|name"

	//取结构
	While(result.Next()){
		
		s scode = result.Data("scode")
		s sname = result.Data("sname")
					
		s tmp=scode_"|"_sname

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uInterLocMet7E7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
