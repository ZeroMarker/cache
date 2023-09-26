Class dhc.bonus.udata.uInterLocMethod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-26
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterLocMethod).List(1,"order","asc",1,5)
ClassMethod List(InterLocSetDr, sortField, sortDir, start, limit)
{
	n (InterLocSetDr, sortField, sortDir, start, limit)
	
	s sqlStr=" SELECT InterLocMethod_rowid,InterLocSet_rowid,InterLocSet_rowid->InterLocSet_name BonusSchemeName,InterLocMethod_methodDesc , InterLocMethod_methodName ,InterLocMethod_ReturnType,InterLocMethod_ReturnName,InterLocMethod_order,InterLocMethod_active"_
 		" FROM dhc_bonus_inter.InterLocMethod a"_
		" where a.%ID>0"_
		"  AND InterLocSet_rowid="_InterLocSetDr
	//w sqlStr,!
	s sortStr="" 
	s sortField1=""	
	s sortField=""
	
	i sortField'="" d
	.i sortField="LocSet_name" s sortField1="InterLocSet_rowid->BonusSchemeName"
	.i sortField="methodDesc" s sortField1="InterLocMethod_methodDesc"
	.i sortField="methodName" s sortField1="InterLocMethod_methodName"
	.i sortField="Order" s sortField1="InterLocMethod_order"
	.i sortField="active" s sortField1="InterLocMethod_active"
	
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY InterLocMethod_methodCode"

	s sqlStr=sqlStr_sortStr
	
	;w sqlStr,!	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid|LocSetrowid|LocSetname|methodDesc|methodName|ReturnType|ReturnName|Order|active"


	//取结构
	While(result.Next()){
		
		s rowid = result.Data("InterLocMethod_rowid")
		s LocSetrowid = result.Data("InterLocSet_rowid")
		s LocSetname = result.Data("BonusSchemeName")
		
		s methodDesc = result.Data("InterLocMethod_methodDesc")
		
		s methodName = result.Data("InterLocMethod_methodName")
		
		s ReturnType = result.Data("InterLocMethod_ReturnType")
		s ReturnName = result.Data("InterLocMethod_ReturnName")
		s Order = result.Data("InterLocMethod_order")
		s active = result.Data("InterLocMethod_active")		
				
		s tmp=rowid_"|"_LocSetrowid_"|"_LocSetname_"|"_methodDesc_"|"_methodName_"|"_ReturnType_"|"_ReturnName_"|"_Order_"|"_active
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

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-26
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterLocMethod).GetMethodList("","",0,20,17)
ClassMethod GetMethodList(sortField, sortDir, start, limit, interLocsetDr)
{
	n (InterLocSetDr, sortField, sortDir, start, limit,interLocsetDr)
	
	s sqlStr=" SELECT InterLocMethod_rowid,InterLocSet_rowid->InterLocSet_name , InterLocMethod_methodDesc  "_
 		" FROM dhc_bonus_inter.InterLocMethod a ,dhc_bonus_inter.InterParam b"_
		" where a.InterLocMethod_ReturnType=b.InterParam_ParamCode"_
		"  AND InterLocMethod_active = 'Y'"
		
	i interLocsetDr'="" d 
	.s sqlStr=sqlStr_" and InterLocSet_rowid="_interLocsetDr
	
	//s sqlStr=sqlStr_" ORDER BY InterLocSet_rowid->BonusSchemeName,InterLocMethod_methodDesc" 
	
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid|name"

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("InterLocMethod_rowid")
		s LocSetname = result.Data("InterLocSet_name")
		s methodDesc = result.Data("InterLocMethod_methodDesc")
		
				
		s tmp=rowid_"|"_methodDesc
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-26
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterLocMethod).GetMethodList2("","",1,5,"")
ClassMethod GetMethodList2(sortField, sortDir, start, limit, interLocsetDr)
{
	n (InterLocSetDr, sortField, sortDir, start, limit,interLocsetDr)
	
	
	
	s sqlStr=" SELECT InterLocMethod_rowid,InterLocSet_rowid->InterLocSet_name, InterLocMethod_methodDesc  "_
 		" FROM dhc_bonus_inter.InterLocMethod a ,dhc_bonus_inter.InterParam b"_
		" where a.InterLocMethod_ReturnType=b.InterParam_ParamCode"_
		"  AND InterLocMethod_active = 'Y'"
	s sqlStr=sqlStr_" and InterLocSet_rowid="_interLocsetDr
	
	s sqlStr=sqlStr_" ORDER BY InterLocSet_rowid->InterLocSet_name,InterLocMethod_methodDesc" 
	
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid|name"

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("InterLocMethod_rowid")
		s LocSetname = result.Data("InterLocSet_name")
		s methodDesc = result.Data("InterLocMethod_methodDesc")
		
				
		s tmp=rowid_"|"_methodDesc
	
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
/// Input：InterLocSet_rowid,InterLocMethod_methodCode, InterLocMethod_methodName ,InterLocMethod_ReturnType,InterLocMethod_order, InterLocMethod_ReturnName,InterLocMethod_active
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).InsertRec("4~5~04~eeee~201~errrrr~Y")
ClassMethod InsertRec(data) As %String
{
	
	n (data)
	s rowid=0

	set isValid =1
	s Order = $p(data,"~",1)
	s sum=""
	s sum=..IfRepOrder(Order)
	q:sum>0 "RepOrder"
	
    s Setrowid = $p(data,"~",2)
    s methodDesc= $p(data,"~",3)
    s sum=""
	s sum=..IfRepDesc(methodDesc)
	q:sum>0 "RepDesc"
	
    s methodName = $p(data,"~",4)
    s sum=""
    s sum=..IfRepName(methodName)
	q:sum>0 "RepName"
	
    s ReturnType= $p(data,"~",5)
    s ReturnName= $p(data,"~",6)
    s active= "Y"

	&sql(insert into dhc_bonus_inter.InterLocMethod(InterLocSet_rowid,InterLocMethod_methodDesc, InterLocMethod_methodName ,InterLocMethod_ReturnType,InterLocMethod_order, InterLocMethod_ReturnName,InterLocMethod_active) values(:Setrowid,:methodDesc, :methodName ,:ReturnType,:Order, :ReturnName,:active))
	q SQLCODE
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).IfRepOrder(1)
ClassMethod IfRepOrder(Order) As %String
{
	n (Order)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_order=:Order and InterLocMethod_active='Y')
	i sum="" d  s sum=0
	q sum
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).IfRepDesc("测试")
ClassMethod IfRepDesc(Desc) As %String
{
	n (Desc)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_methodDesc=:Desc and InterLocMethod_active='Y')
	i sum="" d  s sum=0
	q sum
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).IfRepName("测试")
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_methodName=:Name and InterLocMethod_active='Y')
	i sum="" d  s sum=0
	q sum
}

/// Creator：zhaoliguo
/// CreatDate：2011-4-26
/// Description: 插入一条新数据
/// Table：dhc_bonus_inter.InterLocMethod
/// Input：InterLocSet_rowid,InterLocMethod_methodCode, InterLocMethod_methodName ,InterLocMethod_ReturnType,InterLocMethod_order, InterLocMethod_ReturnName,InterLocMethod_active
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).UpdateRec("dfsfss^fsfsfs^6^202^5^99998f^Y",16)
ClassMethod UpdateRec(data, rowID) As %String
{
	
	n (data,rowID)
	
	s Order = $p(data,"~",3)
	i Order'="" s PLIST(7)=Order
	s sum=""
	s sum=..UpRepOrder(rowID,Order)
	q:sum>0 "RepOrder"
	
    s Setrowid = $p(data,"~",5)
    i Setrowid'="" s PLIST(6)=Setrowid
    
    s methodDesc= $p(data,"~",1)
    s sum=""
	s sum=..UpRepDesc(rowID,methodDesc)
	q:sum>0 "RepDesc"
    i methodDesc'="" s PLIST(9)=methodDesc
    
    s methodName = $p(data,"~",2)
    s sum=""
    s sum=..UpRepName(rowID,methodName)
	q:sum>0 "RepName"
    i methodName'="" s PLIST(3)=methodName
    
    s ReturnType= $p(data,"~",4)
    i ReturnType'="" s PLIST(4)=ReturnType
    
    s ReturnName= $p(data,"~",6)
    i ReturnName'="" s PLIST(5)=ReturnName
    
    s active= $p(data,"~",7)
     i active'="" s PLIST(8)=active
	
	
	&sql(update dhc_bonus_inter.InterLocMethod Values PLIST() where %ID=:rowID)
	q SQLCODE
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).UpRepOrder(1)
ClassMethod UpRepOrder(rowID, Order) As %String
{
	n (rowID,Order)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_order=:Order and InterLocMethod_active='Y' and InterLocMethod_rowid not in (:rowID))
	i sum="" d  s sum=0
	q sum
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).UpRepDesc("测试")
ClassMethod UpRepDesc(rowID, Desc) As %String
{
	n (rowID,Desc)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_methodDesc=:Desc and InterLocMethod_active='Y' and InterLocMethod_rowid not in (:rowID))
	i sum="" d  s sum=0
	q sum
}

/// Others：w ##class(dhc.bonus.udata.uInterLocMethod).UpRepName("测试")
ClassMethod UpRepName(rowID, Name) As %String
{
	n (rowID,Name)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocMethod
	WHERE InterLocMethod_methodName=:Name and InterLocMethod_active='Y' and InterLocMethod_rowid not in (:rowID))
	i sum="" d  s sum=0
	q sum
}

/// Creator: zhao liguo
/// CreatDate: 2011-4-26
/// Description: 删除记录
/// Table：dhc_bonus_inter.InterLocMethod
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmployee).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from  dhc_bonus_inter.InterMethodParam  WHERE InterLocMethod_rowid=:rowid)
	&SQL(delete from  dhc_bonus_inter.InterLocMethod  WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uInterLocMet5F6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
