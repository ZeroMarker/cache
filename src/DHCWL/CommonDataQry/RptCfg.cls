/// 名称: DHCWL.CommonDataQry.RptCfg
/// 描述: 通用简单数据定义类
/// 编写者：王峥
/// 编写日期: 2017-8
/// d ##class(DHCWL.CommonDataQry.RptCfg).%BuildIndices()
Class DHCWL.CommonDataQry.RptCfg Extends %Persistent
{

/// 查询名称(v2.1.0版本及后续办法废弃)
Property QryName As %String(COLLATION = "EXACT");

/// 名字空间
Property NameSpace As %String(COLLATION = "EXACT");

/// routine
Property Routine As %String(COLLATION = "EXACT");

/// 函数
Property Fun As %String(COLLATION = "EXACT");

/// 其他参数
Property OtherParam As %String(COLLATION = "EXACT");

/// 报表标题(v2.1.0版本及后续办法废弃)
Property RptTitle As %String(COLLATION = "EXACT");

/// 产品类型(v2.1.0版本新增)	：收入，挂号，出入转，手术，病案，其他
Property PdtType As %String(COLLATION = "EXACT");

/// 创建者ID(v2.1.0版本新增)
Property UserDr As User.SSUser;

/// 报表Name；报表标题：显示在表头的标题；描述：对报表的简单描述；标题和描述都有可能修改，名字不能修改
/// (v2.1.0版本新增)
Property RptName As %String(COLLATION = "EXACT");

/// 描述(v2.1.0版本新增)
Property Descript As %String(COLLATION = "EXACT");

/// 编码(v2.1.0版本新增)
Property Code As %String(COLLATION = "EXACT");

Index InxSpaceRouFun On (NameSpace, Routine, Fun);

Index InxName On RptName;

Index InxCode On Code;

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	插入通用简单数据查询记录
/// Table：       	DHCWL.CommonDataQry.RptCfg
/// Input：         inParam-入参，outParam-出参
/// Output： 
/// Return：		成功——空串；失败——失败原因	
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.CommonDataQry.RptCfg).%New()
	
	s newObj.Code=$g(inParam("Code"))
	s newObj.RptName=$g(inParam("RptName"))
	s newObj.Descript=$g(inParam("Descript"))
	s newObj.PdtType=$g(inParam("PdtType"))
	s usrObj=##class(User.SSUser).%OpenId(inParam("UserID"))
	s newObj.UserDr=usrObj	
	
	s newObj.NameSpace=$g(inParam("NameSpace"))
	s newObj.Routine=$g(inParam("Routine"))
	s newObj.Fun=$g(inParam("Function"))
	s newObj.OtherParam=$g(inParam("OtherParam"))
	
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="保存配置对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("rowID")=newObj.%Id() 
	d newObj.%Close()
	q ret
SQLErr
	if ret="" s ret="保存配置对象失败:未知错误!"
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	更新通用简单数据查询记录
/// Table：       	DHCWL.CommonDataQry.RptCfg
/// Input：         inParam-入参，outParam-出参
/// Output： 
/// Return：		成功——空串；失败——失败原因	
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s rowID=$g(inParam("rowID"))
	s newObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(rowID)

	s newObj.NameSpace=$g(inParam("NameSpace"))
	s newObj.Routine=$g(inParam("Routine"))
	s newObj.Fun=$g(inParam("Function"))
	s newObj.OtherParam=$g(inParam("OtherParam"))
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新配置对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}

	d newObj.%Close()
	q ret
SQLErr
	if ret="" s ret="更新配置对象失败:未知错误!"
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2018-9
/// Description:   	删除通用简单数据查询记录
/// Table：       	DHCWL.CommonDataQry.RptCfg
/// Input：         rptID-报表ID
/// Output： 
/// Return：		成功——空串；失败——失败原因	
ClassMethod DelRpt(ID As %String) As %String
{
	s $zt="SQLErr"
	s ret=""	

	&sql(DELETE FROM DHCWL_CommonDataQry.RptCfg WHERE ID=:ID)
	
	if SQLCODE'=0 && (SQLCODE'=100) s ret="删除报表失败，SQLCODE DESC="_$SYSTEM.SQL.SQLCODE(SQLCODE)
	q ret

SQLErr
	if ret="" s ret="新建报表项失败:"_$ZERROR
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	判断某条配置是否存在，判断标准：相同nameSpace且相同routine且
/// 					相同function就是同一条配置				
/// Table：       	DHCWL.CommonDataQry.RptCfg
/// Input：         inParam-入参，outParam-出参
/// Output： 
/// Return：		0——不存在；1——存在	
ClassMethod IsExistRec(ByRef inParam, ByRef outParam) As %String
{
	//Index InxSpaceRouFun On (NameSpace, Routine, Function);
	s nameSpace=$g(inParam("NameSpace"))
	s routine=$g(inParam("Routine"))
	s function=$g(inParam("Function"))
	
	s inRowID=$g(inParam("rowID"))

	q:'$d(^DHCWL.CommonDataQry.RptCfgI("InxSpaceRouFun")) 0
	s rowID=$o(^DHCWL.CommonDataQry.RptCfgI("InxSpaceRouFun",nameSpace,routine,function,""))
	
	s outParam("existRowID")=$g(rowID)
	
	q:rowID="" 0
	q:rowID'="" 1
}

/// Creator：      	王峥
/// CreatDate：    	2018-6
/// Description:   	安装指标数据查询版本
/// Table：       	
/// Input：         
/// Output： 
/// Return：
/// d ##class(DHCWL.CommonDataQry.RptCfg).updateVersion()	
ClassMethod updateVersion() As %String
{
	//2018-6增加了CODE，Descript属性和InxCode索引
	s ret=""
	s rowID=""
	f {
		s rowID=$o(^DHCWL.CommonDataQry.RptCfgD(rowID))
		q:rowID=""
		
		s newObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(rowID)
		s name=newObj.RptName
		s descript=newObj.Descript
		s pdtType=newObj.PdtType
		s userID=newObj.UserID
		if name="" {
			s newObj.RptName=..CreateNameByTitle(newObj.RptTitle)
		}
		if descript="" {
			s newObj.Descript=newObj.RptTitle
		}
		if pdtType="" {
			s newObj.PdtType="其他"
		}		

		if userID="" {
			s newObj.UserID=1
		}
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="更新配置对象失败:"_$System.Status.GetErrorText(sc)
			q
	 	}

		d newObj.%Close()
		
	}
	
	//重建索引数据
	k ^DHCWL.CommonDataQry.RptCfgI
	d ##class(DHCWL.CommonDataQry.RptCfg).%BuildIndices()
	
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2018-6
/// Description:   	安装指标数据查询版本
/// Table：       	
/// Input：         
/// Output： 
/// Return：暂时没有使用		
ClassMethod CreateNameByTitle(Title As %String) As %String
{
	s name=Title
	s inParam("RptName")=name
	s isExist=..IsExistRec(.inParam, .outParam)
	if isExist'=0 {
		s inx=1
		s name=""
		f {
			s name="00000"_inx
			s name=$EXTRACT(name,*-5,*)
			s name=Title_"_"_name
			s inParam("RptName")=name
			s isExist=..IsExistRec(.inParam, .outParam)	
			q:isExist=0
			q:inx>99999
			s inx=inx+1
			
		}
	}
	q name
}

ClassMethod GetById(ID As %String) As RptCfg
{
	q ##class(RptCfg).%OpenId(ID)
}

Storage Default
{
<Data name="RptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QryName</Value>
</Value>
<Value name="3">
<Value>NameSpace</Value>
</Value>
<Value name="4">
<Value>Routine</Value>
</Value>
<Value name="5">
<Value>Fun</Value>
</Value>
<Value name="6">
<Value>OtherParam</Value>
</Value>
<Value name="7">
<Value>RptTitle</Value>
</Value>
<Value name="8">
<Value>PdtType</Value>
</Value>
<Value name="9">
<Value>RptName</Value>
</Value>
<Value name="10">
<Value>Descript</Value>
</Value>
<Value name="11">
<Value>Code</Value>
</Value>
<Value name="12">
<Value>UserDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CommonDataQry.RptCfgD</DataLocation>
<DefaultData>RptCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.CommonDataQry.RptCfgD</IdLocation>
<IndexLocation>^DHCWL.CommonDataQry.RptCfgI</IndexLocation>
<StreamLocation>^DHCWL.CommonDataQry.RptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
