Class DHCMed.CR.BO.InitData Extends %RegisteredObject
{

/// Creator : wuqk
/// CreatDate : 2012-11-29
/// Description : 从^tmpcrf("saveFunction")读数据写入 Function
/// Input : 
///        ^tmpcrf("saveFunction")
/// Table : DHCMed.CR.PO.Function
/// Output ：
/// Return ：成功标记
/// 先从xml文件将Function定义读入^tmpcrf("saveFunction")
/// d ##class(DHCMed.CR.BO.InitData).LoadFunction()
ClassMethod LoadFunction()
{

	s index=0
	
	for {
		w !,index
		quit:'$d(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][caption]"))
		set o=##class(DHCMed.CR.PO.Function).%New()
		set o.caption=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][caption]",1))
		set o.data=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][data]",1))
		set o.caption=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][caption]",1))
		set o.type=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][type]",1))
		set o.description=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][description]",1))
		set o.name=$g(^tmpcrf("saveFunction",1884,"62787,62523","o["_index_"][name]",1))
		s sc= o.%Save()
		if $$$ISERR(o){
			d $system.OBJ.DisplayError(o) 	
		}
		w "  sc="_sc
		s index=index+1
		
	}
}

/// Creator : wuqk
/// CreatDate : 2012-11-29
/// Description : 测试导出Function方法
/// Input : 
/// Table : DHCMed.CR.PO.Function
/// Output ：
/// Return ：
/// d ##class(DHCMed.CR.BO.InitData).ExportFunctionList()
ClassMethod ExportFunctionList()
{
	set list = ..%New()
	set id=0
	for {
		set id = $o(^DHCMed.CR.PO.FunctionD(id))
		quit:id>3
		set funcion = ##class(DHCMed.CR.PO.Function).%OpenId(id)
		do list.list.Insert(funcion)
	}
	set index=0
	/*
	#dim stream as %Stream.Object
	set sc = list.XMLExportToStream(.stream)
	for {
		set f=stream.ReadLine(,.sc,.e)
		quit:e=0
		//quit:f=""
		w !,index,"len= sc=",sc," end=",e
		write:f'="" !,f
		set index=index+1
	}*/
	s sc=list.XMLExportToString(.s)
	w s
	q
}

/// Creator : wuqk
/// CreatDate : 2012-11-29
/// Description : 初始化Dic，默认读DHCMed.Base包中的所有类
/// Input : 
/// Table : DHCMed.CR.PO.Dic
/// Output ：
/// Return ：成功标记
/// d ##class(DHCMed.CR.BO.InitData).LoadDic()
ClassMethod LoadDic()
{
	set ackagename = "DHCMed.Base"
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	set clskey=""
	for  {
		set clskey=$o(arrarylistcls(clskey))
		quit:clskey=""
		set dcc = ##class(%Dictionary.CompiledClass).%OpenId(clskey)
		continue:'$IsObject(dcc)
		set count = dcc.Queries.Count() 
		continue:count=0
		
		set objDic = ##class(DHCMed.CR.PO.Dic).%New()
		set objDic.dicCode = $p(clskey,".",3)
		set objDic.dicName = objDic.dicCode
		set objDic.className = clskey
		
		//for index=1:1:1 {
			#dim qdf As %Dictionary.CompiledQuery
			set qdf = dcc.Queries.GetAt(1)
			set name = qdf.Name
			set type = qdf.Type
			set formalSpec = qdf.FormalSpec
			set fields = ""
			w !,clskey," ",name," ",type
			if type = "%Library.Query" {
				//FormalSpec = "ARCIMDesc:%String,OrderType:%String"
				set fields = qdf.Parameters.GetAt("ROWSPEC")
			}
			elseif type= "%Library.SQLQuery" {
				set ColNames = qdf.ColNames
				for i=1:1:$ll(ColNames) {
					//set $p($p(fields,",",i),":",1)=$li(ColNames,i)
					set $p(fields,",",i) = $li(ColNames,i)
				}
			}
			set objDic.fields = fields
			set objDic.queryName = qdf.Name
			set objDic.formalSpec = formalSpec
			//b
			do objDic.%Save()
		//}
		
	}
	quit
}

/// Creator : wuqk
/// CreatDate : 2012-11-29
/// Description : 初始化LoadInterface，默认读DHCMed.Base包中的所有包含GetObjById的类
/// Input : 
/// Table : DHCMed.CR.PO.Interface
/// Output ：
/// Return ：成功标记
/// d ##class(DHCMed.CR.BO.InitData).LoadInterface()
ClassMethod LoadInterface()
{
	set ackagename = "DHCMed.Base"
	w $system.OBJ.GetPackageList(.arrarylistcls,ackagename)
	set clskey=""
	for  {
		set clskey=$o(arrarylistcls(clskey))
		quit:clskey=""
		set dcc = ##class(%Dictionary.CompiledClass).%OpenId(clskey)
		continue:'$IsObject(dcc)
		
		set mdf = ##class(%Dictionary.CompiledMethod).%OpenId(clskey_"||GetObjById")
		continue:'$IsObject(mdf)
		
		set objInterface = ##class(DHCMed.CR.PO.Interface).%New()
		set objInterface.CategoryCode = "01"
		set objInterface.InterfaceClassMethod = clskey_"||GetObjById"
		set objInterface.InterfaceCode = $p(clskey,".",3)
		set objInterface.InterfaceName = $p(clskey,".",3)
		set objInterface.ReturnType = clskey
		set objInterface.Arguments = mdf.FormalSpec
		
		do objInterface.%Save()
		
		
	}
	quit
}

/// d ##class(DHCMed.CR.BO.InitData).Test("shhh")
ClassMethod Test(s)
{
	Set $ZT="SaveDataErr"
	//Set $ETRAP="SaveDataErr"
	//SET $ZERROR="Any String"
	s $ECODE="A,1,2,3,s"
	w s
	q s
SaveDataErr
	w $ze
	q
}

/// d ##class(DHCMed.CR.BO.InitData).Tests("shhh")
ClassMethod Tests(s)
{
		set clskey="DHCMed.CR.PO.FormVer"

		set dcc = ##class(%Dictionary.CompiledClass).%OpenId(clskey)
		
		set mdf = ##class(%Dictionary.CompiledMethod).%OpenId(clskey_"||GetObjById")		
		set objInterface = ##class(DHCMed.CR.PO.Interface).%New()
		set objInterface.CategoryCode = "01"
		set objInterface.InterfaceClassMethod = clskey_"||GetObjById"
		set objInterface.InterfaceCode = $p(clskey,".",3)
		set objInterface.InterfaceName = $p(clskey,".",3)
		set objInterface.ReturnType = clskey
		set objInterface.Arguments = mdf.FormalSpec
		w !,objInterface.Arguments
		do objInterface.%Save()
}

}
