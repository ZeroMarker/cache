/// Creator: 李明忠
/// CreatDate: 2010-08-05
/// Description: 分组显示维护
Class dhc.pa.udata.uJXGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-8-5
/// Description:根据传入的类别查询相关记录
/// Table:dhc_pa_data.JXGroup
/// Input:type-科室与指标分组类别(1:指标,2:科室);searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXGroup).List(2,"","","rowid","DESC",0,25)
ClassMethod List(type, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
    n (type, searchField, searchValue, sortField, sortDir, start, limit)
    
    s sqlStr="select JXGroup_rowid,JXGroup_code,JXGroup_name,JXGroup_IDSet,JXGroup_isInput,JXGroup_type,JXGroup_desc from dhc_pa_data.JXGroup"
    s whereStr=" where %ID>0"
    i type'="" s whereStr=whereStr_" and JXGroup_type='"_type_"'"
    s sortStr="",sortField1=""
    
    i sortField'="" d
    .i sortField="rowid" s sortField1="JXGroup_rowid"
    .i sortField="code" s sortField1="JXGroup_code"
    .i sortField="name" s sortField1="JXGroup_name"
    .i sortField="isInput" s sortField1="JXGroup_isInput"
    .i sortField="typeName" s sortField1="JXGroup_type"
    .i sortField="desc" s sortField1="JXGroup_desc"
    
    i sortField1'="" d
    .s sortDir=$ZCONVERT(sortDir,"u")
    .i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
    .e  s sortStr=" order by "_sortField1_" asc"
    e  s sortStr=" order by %ID desc"
    
    s sqlStr=sqlStr_whereStr_sortStr
    s result=##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    d result.Execute()
    
    s count=0
    s resultString=""
    s end=start+limit-1
    
    s json=##class(dhc.pa.comm.JsonObj).%New()
    s jsonTitle="rowid^code^name^IDSet^NameStr^isInput^type^typeName^desc"
    
    While(result.Next()){
        //集体初始化
        s KPIName="异常指标",deptName="异常单元",typeName="",NameStr=""
        
        s rowid=result.Data("JXGroup_rowid")
        s code=result.Data("JXGroup_code")
        s name=result.Data("JXGroup_name")
        s IDSet=result.Data("JXGroup_IDSet")
        s isInput=result.Data("JXGroup_isInput")
        i isInput=1  s isInput="否"
        e  d
        .s isInput="是"
        s type=result.Data("JXGroup_type")
        i type=1 d
        .s typeName="指标组"
        .s KPINameStr=""
        .s Length=$L(IDSet,"-")
        .f i=1:1:Length d
        ..s KPIDr=$P(IDSet,"-",i)
        ..i KPIDr'="" d
        ...i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
        ....i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
        .....s KPIName=$P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
        ..i KPINameStr="" s KPINameStr=KPIName
        ..e  s KPINameStr=KPINameStr_"-"_KPIName
        .s NameStr=KPINameStr
        i type=2 d
        .s typeName="绩效单元组"
        .s deptNameStr=""
        .s Length=$L(IDSet,"-")
        .f k=1:1:Length d
        ..s deptDr=$P(IDSet,"-",k)
        ..i deptDr'="" d
        ...i $D(^DHCCJXPAJXUNIT(deptDr)) d
        ....i $G(^DHCCJXPAJXUNIT(deptDr))'="" d
        .....s deptName=$P($G(^DHCCJXPAJXUNIT(deptDr)),"^",3)
        ..i deptNameStr="" s deptNameStr=deptName
        ..e  s deptNameStr=deptNameStr_"-"_deptName
        .s NameStr=deptNameStr
        s desc=result.Data("JXGroup_desc")
        
        s tmp=rowid_"^"_code_"^"_name_"^"_IDSet_"^"_NameStr_"^"_isInput_"^"_type_"^"_typeName_"^"_desc
        
        i searchValue'="" d
        .q:(searchField = "code")&(code'[searchValue)
        .q:(searchField = "name")&(name'[searchValue)
        .q:(searchField = "typeName")&(typeName'[searchValue)
        .i (count>=start)&(count<=end) d
        ..d json.InsertRowData(tmp)
        .s count=count+1
        e  d
        .i (count>=start)&(count<=end) d
        ..d json.InsertRowData(tmp)
        .s count=count+1
    }
    d result.Close()
    s resultString = json.getJsonData(jsonTitle,count)
    k json
    q resultString
}

/// Creator: 李明忠
/// CreatDate: 2010-8-5
/// Description: 删除分组记录
/// Table：dhc_pa_data.JXGroup
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uJXGroup).Delete(4)
ClassMethod Delete(rowid) As %String
{
    n (rowid)
    
    &SQL(DELETE FROM dhc_pa_data.JXGroup WHERE %ID=:rowid)
    q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-5
/// Description: 获取末端KPI记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：userCode-用户代码
/// Output：
/// Return：有效末端KPI记录字符串
/// Others：w ##class(dhc.pa.udata.uJXGroup).GetEndKPI("demo")
ClassMethod GetEndKPI(userCode) As %String
{
    n (userCode)
    
    q:userCode="" "NoData"
    
    s userCode=$$ALPHAUP^SSUTIL4(userCode)
    //根据用户Code查找用户ID
    s userId=0
    s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
    q:userId="" "NoData"
    
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select KPIAudit_KPIDr from dhc_pa_data.KPIAudit where %ID>0 and KPIAudit_userDr="_userId

    d result.Prepare(sqlStr)
    d result.Execute()

    s count = 0
    s resultString = ""
    s json = ##class(dhc.pa.comm.JsonObj).%New()
    While(result.Next()){
        s KPIDr = result.Data("KPIAudit_KPIDr")
        i KPIDr'="" d 
        .i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
        ..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
        ...s KPIName=$P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
        ...s tmp=KPIDr_"^"_KPIName
        ...d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("KPIDr^KPIName",count)
    k json
    q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-5(2010-10-19修改)
/// Description: 获取当前战略下的绩效单元记录
/// Table：dhc_pa_data.JXUnit
/// Input：unitTypeDr-单元类别Dr
/// Output：
/// Return：有效战略下的绩效单元记录字符串
/// Others：w ##class(dhc.pa.udata.uJXGroup).GetJXUnit(1)
ClassMethod GetJXUnit(unitTypeDr) As %String
{
    n (unitTypeDr)
    
    s Stratagem = ""
    s curreStratagemDr = ""
    f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
    .i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
    ..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
    ...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
    ...i curreStratagem="Y" d
    ....s curreStratagemDr = Stratagem
    
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select JXUnit_rowid,JXUnit_name,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_appSysDr=2 and JXUnit_isEnd='Y' and JXUnit_parent="_unitTypeDr
        
    d result.Prepare(sqlStr)
    d result.Execute()

    s count = 0
    s resultString = ""
    s json = ##class(dhc.pa.comm.JsonObj).%New()
    While(result.Next()){
        s deptID = result.Data("JXUnit_rowid")
        s deptName = result.Data("JXUnit_name")
        s tmp=deptID_"^"_deptName
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("deptID^deptName",count)
    k json
    q resultString
}

/// Creator：李明忠
/// CreatDate：2010-8-5
/// Description: 判断分组代码是否存在
/// Table：dhc_pa_data.JXGroup
/// Input：Code-分组代码
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.pa.udata.uJXGroup).IfRepCode("003")
ClassMethod IfRepCode(Code) As %String
{
    n (Code)
    s RowId=0
    s RowId=$o(^DHCCJXPAJXGROUP(0,"Code",Code,RowId))
    i RowId="" d  s RowId=0
    q RowId
}

/// Creator：李明忠
/// CreatDate：2010-8-5
/// Description: 判断分组名称是否存在
/// Table：dhc_pa_data.JXGroup
/// Input：Name-分组名称
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.pa.udata.uJXGroup).IfRepName("经济指标")
ClassMethod IfRepName(Name) As %String
{
    n (Name)
    s RowId=0
    s RowId=$o(^DHCCJXPAJXGROUP(0,"Name",Name,RowId))
    i RowId="" d  s RowId=0
    q RowId
}

/// Creator：李明忠
/// CreatDate：2010-8-5
/// Description: 添加分组记录
/// Table：dhc_pa_data.JXGroup
/// Input：data-分组记录(code^name^IDSet^isInput^type^desc)
/// Output：
/// Return：代码重复返回RepCode,名称重复返回RepName,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXGroup).Insert("003^科室集合^1-2-3^1^2^003-科室集合")
ClassMethod Insert(data) As %String
{
    n (data)
    s ^TMPLY(1)=data
    q:data="" "dataEmpt"                    //空数据dataEmpt
    k PLIST
    
    s RowId=""
    
    s code=$p(data,"^",1)                   //分组代码
    s RowId=..IfRepCode(code)
    q:RowId'=0 "RepCode"
    i code'="" s PLIST(2)=code 
    
    s name=$p(data,"^",2)                   //分组名称
    s RowId=..IfRepName(name)
    q:RowId'=0 "RepName"
    i name'="" s PLIST(3)=name 
    
    s IDSet=$p(data,"^",3)                  //指标或科室ID集合
    i IDSet'="" s PLIST(4)=IDSet
    
    s isInput=$p(data,"^",4)                //是否录入
    i isInput'="" s PLIST(5)=isInput
    
    s type=$p(data,"^",5)                   //分组类别
    i type'="" s PLIST(6)=type
    
    s desc=$p(data,"^",6)                   //分组描述
    i desc'="" s PLIST(7)=desc
    
    &SQL(insert into dhc_pa_data.JXGroup VALUES PLIST())
    q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-8-5
/// Description: 更新分组记录
/// Table：dhc_pa_data.JXGroup
/// Input：rowid-所在行号;data-数据字符串(code^name^IDSet^isInput^type^desc);
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXGroup).Update(4,"003^科室集合^1-2-3^1^2^003-科室集合")
ClassMethod Update(rowid, data) As %String
{
    n (rowid, data)
    
    q:rowid="" "rowidEmpt"                  //错误数据
    q:data="" "dataEmpt"                    //空数据dataEmpt
    k PLIST
    s RowId=""
    
    s code=$p(data,"^",1)                   //代码
    s RowId=..IfRepCode(code)
    q:(RowId'=0)&(RowId'=rowid) "RepCode"
    s PLIST(2)=code             
    
    s name=$p(data,"^",2)                   //名称
    s RowId=..IfRepName(name)
    q:(RowId'=0)&(RowId'=rowid) "RepName"
    s PLIST(3)=name             
    
    s IDSet=$p(data,"^",3)                  //指标或科室ID集合
    s PLIST(4)=IDSet
    
    s isInput=$p(data,"^",4)                //是否录入
    s PLIST(5)=isInput
    
    s type=$p(data,"^",5)                   //分组类别
    s PLIST(6)=type
    
    s desc=$p(data,"^",6)                   //分组描述
    s PLIST(7)=desc
    
    &sql(update dhc_pa_data.JXGroup values PLIST() where %ID=:rowid)
    q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2011-1-6
/// Description: 获取绩效单元类别
/// Table：dhc_pa_data.JXUnit
/// Input：
/// Output：
/// Return：有效战略下的绩效单元记录字符串
/// Others：w ##class(dhc.pa.udata.uJXGroup).GetUnitType("")
ClassMethod GetUnitType(str) As %String
{
    n (str)
    
    s Stratagem = ""
    s curreStratagemDr = ""
    f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
    .i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
    ..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
    ...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
    ...i curreStratagem="Y" d
    ....s curreStratagemDr = Stratagem
    
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select JXUnit_rowid,JXUnit_name,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_appSysDr=2 and JXUnit_parent=0"
        
    s whereStr=""
    i str'="" s whereStr=" and JXUnit_shortcut like'"_str_"'"
    s sqlStr=sqlStr_whereStr
    
    d result.Prepare(sqlStr)
    d result.Execute()

    s count = 0
    s resultString = ""
    s json = ##class(dhc.pa.comm.JsonObj).%New()
    While(result.Next()){
        s deptID = result.Data("JXUnit_rowid")
        s deptName = result.Data("JXUnit_name")
        s tmp=deptID_"^"_deptName
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("deptID^deptName",count)
    k json
    q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXGroupS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
