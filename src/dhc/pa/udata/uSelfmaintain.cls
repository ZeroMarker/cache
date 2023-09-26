/// 绩效考核---自查定义
/// Creator: 何佳兵
/// CreatDate: 2015-05-08
/// Description:
Class dhc.pa.udata.uSelfmaintain Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Description: 判断编码是否重复
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others: w ##class(dhc.pa.udata.uSelfmaintain).IfCode("001")
ClassMethod IfCode(code) As %String
{
	new (code)
	s rowid=0
	s rowid=$o(^herpacctAcctBookI("DKXcode",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 判断名称是否重复
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others: w ##class(dhc.pa.udata.uSelfmaintain).IfName("病床使用率")
ClassMethod IfName(name) As %String
{
	new (name)
	s rowid=""
	&SQL(select DKX_Rowid into :rowid from dhc_pa_data.Dept_KPIIndex where DKX_name=:name  )  
	i rowid="" d  s rowid=0
	q rowid
}

/// Description: 查询
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others: w ##class(dhc.pa.udata.uSelfmaintain).List("roo")
ClassMethod List(parent) As %String
{
	n (parent)
	
	s sqlStr=" SELECT  DKX_name,DKX_code,DKX_Rowid,DKX_calUnitDr->CalUnit_name as DKX_unit,DKX_level,DKX_type,DKX_desc,DKX_isEnd,DKX_parent"
	_" FROM dhc_pa_data.Dept_KPIIndex"

	i parent="roo"  s whereStr=" where  DKX_parent = 0  "
	e  s whereStr=" where DKX_parent='"_parent_"'"
	s sqlStr=sqlStr_whereStr
	s ^TMPWYY(1)="sqlStr:"_sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString="["
	While(result.Next())
	{	
	    s typename=""
		s name= result.Data("DKX_name")
		s code= result.Data("DKX_code")
		s rowid= result.Data("DKX_Rowid")
		s unit= result.Data("DKX_unit")
		s type= result.Data("DKX_type")
		s level= result.Data("DKX_level")
		s desc= result.Data("DKX_desc")
		s isend= result.Data("DKX_isEnd")
		s parentid= result.Data("DKX_parent")
		i isend="Y" s leaf = "true"
		i isend="N" s leaf = "false"
		i type=1 s typename="多文本描述"
		i type=2 s typename="选项"
		i type=3 s typename="单文本描述"
		s tmp="{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',unit:'"_unit_"',type:'"_typename_"',level:'"_level_"',desc:'"_desc_"',isend:'"_isend_"',parentid:'"_parentid_"',leaf:"_leaf_",uiProvider:'col'}"
		
		i resultString = "[" d
		.s resultString = resultString_tmp
		e  d
		.s resultString = resultString_","_tmp
					
		s count=count+1
	}
	d result.Close()
	s resultString = resultString_"]"
	s ^TMPWYY(2)= resultString
	q resultString
}

/// Description: 获取单位
/// Table：  dhc.pa.data.CalUnit
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).GetCalUnit("0","10")
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

/// Description: 获取项目名称
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Getparent("0","10")
ClassMethod Getparent(start, limit) As %String
{
	n (start, limit)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DKX_Rowid,DKX_name from dhc_pa_data.Dept_KPIIndex where DKX_isEnd='N'"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("DKX_Rowid")
		s name = result.Data("DKX_name")
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

/// Description: 获取上级项目名称
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Getparentname(1)
ClassMethod Getparentname(parent) As %String
{
	n (parent)
	s name="",rowid=""
	&sql(select DKX_name,DKX_Rowid into:name,:rowid from dhc_pa_data.Dept_KPIIndex where DKX_Rowid=:parent  )
	q name
}

/// Description: 添加
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).InsertInfo("病床使用率3","0010103","","文本描述","","2","","Y","00101")
ClassMethod InsertInfo(name, code, type, desc, calunit, level, isend, parent) As %String
{
	 n (name,code,type,desc,calunit,level,isend,parent)
	 s shortcut=code_"_"_name
     s rowid=0
     s rowid=..IfName(name)
   	 q:rowid>0 "RepName"
     
    
   	 &sql(insert into dhc_pa_data.Dept_KPIIndex(DKX_name,DKX_code,DKX_shortcut,DKX_type,DKX_desc,DKX_calUnitDr,DKX_level,DKX_isEnd,DKX_parent) 
   	 values(:name,:code,:shortcut,:type,:desc,:calunit,:level,:isend,:parent))	
   	 q SQLCODE
}

/// Description: 删除
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Delete()
ClassMethod Delete(rowid) As %String
{
	 n (rowid)
   	 &sql(delete from  dhc_pa_data.Dept_KPIIndex where DKX_Rowid=:rowid )	
   	 q SQLCODE
}

/// Description: 判断是否存在孩子节点
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Findchildren("4")
ClassMethod Findchildren(rowid) As %String
{
	 n (rowid)
	 s ID=""
   	 &sql(select DKX_Rowid into:ID from  dhc_pa_data.Dept_KPIIndex where DKX_parent=:rowid )
   	 i ID'="" q "childNode"
   	 e  q SQLCODE
}

/// Description: 修改
/// Table：  dhc_pa_data.Dept_KPIIndex
/// w ##class(dhc.pa.udata.uSelfmaintain).Update(28,"123","病床使用率","2","文本描述new","这是修改后的",1)
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Update(13,"0010102","出院病人总数2","","","医疗指标定期分析",0)
ClassMethod Update(rowid, newcode, newname, newunit, newdesc, newtype, parent, flag) As %String
{
	n (rowid,newcode,newname,newunit,newdesc,newtype,parent,flag)
	i parent="项目管理" s parent=0
	s tmprowid=""
	
	s PLIST(2)=newcode
	s PLIST(3)=newname
	s PLIST(8)=newdesc

	i $ISVALIDNUM(newtype)=1 s PLIST(7)=newtype
	i $ISVALIDNUM(newunit)=1 s PLIST(6)=newunit
	
	
	if (flag=0){		
		s tmprowid=..IfName(newname)
		i (tmprowid>0)&&(tmprowid'=rowid) q "RepName"
		e  d
		.;&sql(update dhc_pa_data.Dept_KPIIndex set  DKX_code=:newcode,DKX_name=:newname,DKX_calUnitDr=:newunit,DKX_desc=:newdesc where DKX_Rowid=:rowid )
		.&sql(update dhc_pa_data.Dept_KPIIndex values PLIST() where %ID=:rowid)
		q SQLCODE
	}elseif(flag=1){
		s tmprowid=..IfName(newname)
		i (tmprowid>0)&&(tmprowid'=rowid) q "RepName"
		e  d
		.;&sql(update dhc_pa_data.Dept_KPIIndex set  DKX_code=:newcode,DKX_name=:newname,DKX_calUnitDr=:newunit,DKX_desc=:newdesc where DKX_Rowid=:rowid )	
		.&sql(update dhc_pa_data.Dept_KPIIndex values PLIST() where %ID=:rowid)
		q SQLCODE
	}
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

/// Description: 修改时找到新父节点的code
/// Table：  dhc_pa_data.Dept_KPIIndex
/// Others： w ##class(dhc.pa.udata.uSelfmaintain).Findparentcode(24)
ClassMethod Findparentcode(parent) As %String
{
	n (parent)
	s code=""
	&sql(select DKX_code into:code from dhc_pa_data.Dept_KPIIndex where DKX_Rowid=:parent)
	q code
}

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.pa.udata.uSelfmaintainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
