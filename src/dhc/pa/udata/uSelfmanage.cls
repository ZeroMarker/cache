/// 绩效考核---自查定义
/// Creator: 何佳兵
/// CreatDate: 2015-05-07
/// Description: 
Class dhc.pa.udata.uSelfmanage Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Description: 查询自查项目明细(树的添加自查明细功能)
/// Table：  dhc_pa_data.DeptKPIIndex
/// others:w ##class(dhc.pa.udata.uSelfmanage).GetDeptdetail(5)
ClassMethod GetDeptdetail(DSDrowid) As %String
{
	n (DSDrowid)
	
	s sqlStr="SELECT DKX_Rowid, DKX_name FROM dhc_pa_data.Dept_KPIIndex where DKX_isEnd='Y'  "
	_"and DKX_Rowid not in(select DSD_DKPIDr from dhc_pa_data.DeptSchemDetail where DSD_Dschem='"_DSDrowid_"')"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next())
	{   
		s rowid= result.Data("DKX_Rowid")
		s name= result.Data("DKX_name")
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Description: 查询
/// Table：  dhc.pa.data.DeptSchem
/// others:w ##class(dhc.pa.udata.uSelfmanage).List("","",0,15)
ClassMethod List(sortField, sortDir, start, limit) As %String
{
	n (sortField, sortDir, start, limit)
	s sqlStr="SELECT * FROM dhc_pa_data.DeptSchem "
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^code^name^frequency^periodTypeName^shortcut^desc^isStop"
	While(result.Next())
	{   
		s rowid= result.Data("DSC_rowid")
		s code= result.Data("DSC_code")
		s name= result.Data("DSC_name")
		s isStop= result.Data("DSC_isStop") //2016-8-3 add cyl
		s periodType = result.Data("DSC_frequency")
	    i periodType="M" s periodTypeName="月份"
	    i periodType="Q" s periodTypeName="季度"
	    i periodType="H" s periodTypeName="半年"
	    i periodType="Y" s periodTypeName="年度"
	    s shortcut=result.Data("DSC_shortcut")
		s desc=result.Data("DSC_desc")
		s tmp=rowid_"^"_code_"^"_name_"^"_periodType_"^"_periodTypeName_"^"_shortcut_"^"_desc_"^"_isStop
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Description: 删除(左边grid)
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Delete(1)
ClassMethod Delete(rowid) As %String
{
	 n (rowid)
   	 &sql(delete from  dhc_pa_data.DeptSchem where DSC_rowid=:rowid )	
   	 q SQLCODE
}

/// Description: 右边树的查询
/// Table：  dhc_pa_data.Dept_KPIIndex,dhc.pa.data.DeptSchemDetail,dhc_pa_data.DeptSchem
/// Others: w ##class(dhc.pa.udata.uSelfmanage).ListTree("roo","")
ClassMethod ListTree(parent, rowid) As %String
{
	n (parent,rowid)

		s sqlStr=" SELECT  a.DKX_name,a.DKX_code,a.DKX_Rowid,a.DKX_calUnitDr->CalUnit_name as DKX_unit,a.DKX_level,a.DKX_type,a.DKX_desc,a.DKX_isEnd,b.DSD_order,b.DSD_rate"
		_" FROM dhc_pa_data.Dept_KPIIndex a,dhc_pa_data.DeptSchemDetail b"

		i parent="roo"  s whereStr=" where  a.DKX_parent = 0 and b.DSD_Dschem='"_rowid_"'  and b.DSD_DKPIDr=a.DKX_Rowid "
		e  s whereStr=" where a.DKX_parent='"_parent_"' and b.DSD_Dschem='"_rowid_"' and b.DSD_DKPIDr=a.DKX_Rowid"
		s sqlStr=sqlStr_whereStr

	//w sqlStr
	;s ^TMPWYY(1)="sqlStr:"_sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString="["
	While(result.Next())
	{	
		s name= result.Data("DKX_name")
		s code= result.Data("DKX_code")
		s rowid= result.Data("DKX_Rowid")
		s unit= result.Data("DKX_unit")
		s type= result.Data("DKX_type")
		i type=1 s type="多文本描述"
		i type=2 s type="选项"
		i type=3 s type="单文本描述"
		s level= result.Data("DKX_level")
		s desc= result.Data("DKX_desc")
		s isend= result.Data("DKX_isEnd")
		s order= result.Data("DSD_order")
		s rate= result.Data("DSD_rate")
		i rate'="" s rate=$fn(rate,",","2")
		
		i isend="Y" s leaf = "true"
		i isend="N" s leaf = "false"
		
		
		s tmp="{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',unit:'"_unit_"',type:'"_type_"',level:'"_level_"',desc:'"_desc_"',isend:'"_isend_"',order:'"_order_"',rate:'"_rate_"',leaf:"_leaf_",uiProvider:'col'}"
		
		i resultString = "[" d
		.s resultString = resultString_tmp
		e  d
		.s resultString = resultString_","_tmp
					
		s count=count+1
	}
	d result.Close()
	s resultString = resultString_"]"
	;s ^TMPWYY(2)= resultString
	q resultString
}

/// Description: 判断名称是否重复
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others: w ##class(dhc.pa.udata.uSelfmanage).IfNameTree("病床使用率")
ClassMethod IfNameTree(name) As %String
{
	new (name)
	s rowid=""
	&SQL(select DKX_Rowid into :rowid from dhc_pa_data.Dept_KPIIndex where DKX_name=:name  )  
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 判断顺序号是否重复
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others: w ##class(dhc.pa.udata.uSelfmanage).IfOrder("123")
ClassMethod IfOrder(order) As %String
{
	new (order)
	s rowid=""
	&SQL(select DSD_rowid into :rowid from dhc_pa_data.DeptSchemDetail where DSD_order=:order  )  
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 右边树的添加自查项目
/// Table：  dhc_pa_data.Dept_KPIIndex,dhc.pa.data.DeptSchemDetail,dhc_pa_data.DeptSchem
/// Others： w ##class(dhc.pa.udata.uSelfmanage).InsertInfo("2^12-13-14-15-16-17")
ClassMethod InsertInfo(data) As %String
{
	n (data)
	k PLIST
	q:data="" "EmptyRecData"
	
	s parent="",DSDDschem="",rowid="",lastparent=""
	s DSDrowid=$p(data,"^",1)
	s str=$p(data,"^",2)
	s len = $l(str,"-")
    for i=1:1:len
    {
	    s DKPIDr = $p(str,"-",i)
	    s parent=..Findparent(DKPIDr)
	    s tmpstr=parent
		while (parent'=0){
			s parent=..Findparent(parent)
			s tmpstr=tmpstr_"^"_parent	
		}
	    s length = $l(tmpstr,"^")
	    for j=1:1:length
	    {
		 	s parent = $p(tmpstr,"^",length-j)
		 	s flag=..IsExist(parent,DSDrowid)
		 	if (flag="") && (parent'=""){
			 	s lastparent=..Findparent(parent)
			 	s order=..Lastorder()
				&sql(insert into dhc_pa_data.DeptSchemDetail(DSD_order,DSD_Dschem,DSD_DKPIDr,DSD_parent) values(:order,:DSDrowid,:parent,:lastparent))
				i SQLCODE'=0 d ##class(dhc.pa.udata.uPALogger).Insert("dhc.pa.udata.uSelfmanage^InsertInfo","",SQLCODE,"插入失败")				
			 }
		 }
		 
		 s lastparent=..Findparent(DKPIDr)
		 s order=..Lastorder()
		 &sql(insert into dhc_pa_data.DeptSchemDetail(DSD_order,DSD_Dschem,DSD_DKPIDr,DSD_parent) values(:order,:DSDrowid,:DKPIDr,:lastparent))
		 i SQLCODE'=0 d ##class(dhc.pa.udata.uPALogger).Insert("dhc.pa.udata.uSelfmanage^InsertInfo","",SQLCODE,"插入失败")
		
	} 	
   	 q 0
}

/// Description: 找父节点
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Findparent("3")
ClassMethod Findparent(rowid) As %String
{
	 n (rowid)
	 s tmp=""
   	 &sql(select DKX_parent into:tmp from  dhc_pa_data.Dept_KPIIndex where DKX_Rowid=:rowid )
   	q tmp
}

/// Description: 判断父节点是否已存在
/// Table：  dhc_pa_data.DeptSchemDetail
/// Others： w ##class(dhc.pa.udata.uSelfmanage).IsExist("8",1)
ClassMethod IsExist(parent, DSDrowid) As %String
{
	 n (parent,DSDrowid)
	 s rowid=""
   	 &sql(select DSD_rowid into:rowid from dhc_pa_data.DeptSchemDetail where DSD_DKPIDr=:parent and DSD_Dschem=:DSDrowid )
   	 q rowid
}

/// Description: 树的删除
/// Table：  dhc.pa.data.DeptSchemDetail
/// Others： w ##class(dhc.pa.udata.uSelfmanage).DeleteTree()
ClassMethod DeleteTree(rowid, schemId) As %String
{
	 n (rowid,schemId)
   	 &sql(delete from  dhc_pa_data.DeptSchemDetail where DSD_DKPIDr=:rowid and DSD_Dschem=:schemId )	
   	 q SQLCODE
}

/// Description: 设置扣分系数
/// Table：  dhc.pa.data.DeptSchemDetail
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Setdeductpoints(1,"0.5")
ClassMethod Setdeductpoints(rowid, newrate) As %String
{
	n (rowid,newrate)
	&sql(update dhc_pa_data.DeptSchemDetail set DSD_rate=:newrate where DSD_DKPIDr=:rowid)
	q SQLCODE
}

/// Description: 判断是否存在孩子节点
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Findchildren("4")
ClassMethod Findchildren(rowid, schemId) As %String
{
	 n (rowid,schemId)
	 s ID=""
   	 &sql(select DSD_rowid into:ID from  dhc_pa_data.DeptSchemDetail where DSD_Dschem=:schemId and DSD_parent=:rowid )
   	 i ID'="" q "childNode"
   	 e  q SQLCODE
}

/// Description: 判断父节点下的最后一个节点的code,添加节点的的code接在该节点之后(自动生成)
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Lastcode(1)
ClassMethod Lastcode(parent) As %String
{
	n (parent)
	s code=""
	&sql(select top 1 DKX_code into:code from dhc_pa_data.Dept_KPIIndex where DKX_parent=:parent order by DKX_code desc )
	s code=code+1
	s code="00"_code
	q code
}

/// Description: 获取单位
/// Table：  dhc.pa.data.CalUnit
/// Others： w ##class(dhc.pa.udata.uSelfmanage).GetCalUnit("0","10")
ClassMethod GetCalUnit(start, limit) As %String
{
	n (start, limit)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CalUnit_rowid,CalUnit_name from dhc_pa_data.CalUnit "
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("CalUnit_rowid")
		s name = result.Data("CalUnit_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Description: 
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Lastorder()
ClassMethod Lastorder() As %String
{
	s order=""
	&sql(select top 1 DSD_order into:order from dhc_pa_data.DeptSchemDetail  order by DSD_order desc )
	s order=order+1
	q order
}

/// Creator: wang ying
/// CreatDate:  2015-07-13
/// Description: 查询输入自查项目的所有父节点
/// Table: dhc.pa.data.SchemDetail
/// Input: KPI-自查项目id
/// Output: 
/// Return: 所有父节点
/// Others: w ##class(dhc.pa.udata.uSelfmanage).getParent(13,"")
ClassMethod getParent(KPI, parentAll) As %String
{
	
	n (KPI,parentAll)
	i parentAll="" s parentAll=KPI
	;s parent = KPI
	;s parentAll = KPI
	s parent = $LIST($g(^DHCCJXPADeptKPIIndexD(KPI)),10) 
	;w parent,!
	i (parent'=0)&&(parent'="") d
	.s parentAll = parent_"^"_..getParent(parent,parentAll) 
    q parentAll
}

/// Description: 停用/启用自查管理
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmanage).Delete(1)
ClassMethod StopDeptSchem(rowid, flag) As %String
{
	 n (rowid,flag)
	 if flag="stop" d 
   	 .&sql(UPDATE dhc_pa_data.DeptSchem SET DSC_isStop ='Y' WHERE DSC_rowid=:rowid )
   	 e  d
   	 .&sql(UPDATE dhc_pa_data.DeptSchem SET DSC_isStop ='N' WHERE DSC_rowid=:rowid )	
   	 q SQLCODE
}

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.pa.udata.uSelfmanageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
