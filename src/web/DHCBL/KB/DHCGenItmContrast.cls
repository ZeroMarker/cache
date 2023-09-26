Class web.DHCBL.KB.DHCGenItmContrast Extends %RegisteredObject
{

/// 根据his通用名代码获取药品通用名id
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getGenRowId("药箅子")
ClassMethod getGenRowId(code As %String) As %String
{
	s str=-1
	s GICTId=$o(^DHCPHGENCON(0,"HisCode",code,0))  //获取对照表id
	if (GICTId'=""){
		s GICTDesc = $p($g(^DHCPHGENCON(GICTId)),"^",2)  //获取通用名描述
		s GICTDescU=$ZCONVERT(GICTDesc,"U")
		s id = $o(^DHCPHEGENi(0,"Desc",GICTDescU,0))  
		if (id=""){q str}
		s str=id
	}
	q str
}

/// 根据his通用名代码获取药品通用名desc
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getGenDesc("药箅子")
ClassMethod getGenDesc(code As %String) As %String
{
	s str=""
	s GICTId=$o(^DHCPHGENCON(0,"HisCode",code,0))  //获取对照表id
	if (GICTId'=""){
		s GICTDesc = $p($g(^DHCPHGENCON(GICTId)),"^",2)  //获取通用名描述
		s str=GICTDesc
	}
	q str
}

/// 根据his通用名代码获取剂型id
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getFormRowId("分散片")
ClassMethod getFormRowId(code As %String) As %String
{
	s str=-1
	s FormId=$o(^DHCPHFOCON(0,"HisCode",code,0))  //获取对照表id
	if (FormId'=""){
		s FormDesc = $p($g(^DHCPHFOCON(FormId)),"^",2)  //获取剂型描述
		s FormDescU=$ZCONVERT(FormDesc,"U")
		s id = $o(^DHCPHEFi(0,"Desc",FormDescU,0)) 
		if (id=""){q str}
		s str=id
	}
	q str
}

/// 根据his通用名代码获取剂型desc
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getFormDesc("分散片")
ClassMethod getFormDesc(code As %String) As %String
{
	s str=""
	s FormId=$o(^DHCPHFOCON(0,"HisCode",code,0))  //获取对照表id
	if (FormId'=""){
		s FormDesc = $p($g(^DHCPHFOCON(FormId)),"^",2)  //获取剂型描述 
		s str=FormDesc
	}
	q str
}

/// Creator：高姗姗
/// CreatDate: 2014-11-4
/// Description：查询已对照通用名表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenItmContrast","GetList","")
Query GetList(id) As %Query(ROWSPEC = "GICTRowId,GICTCode,GICTDesc,GICTHisCode,GICTHisDesc,GICTCoeff")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (id'=""){
		s code=$p($g(^DHCPHEGEN(id)),"^",1)
    	s desc=$p($g(^DHCPHEGEN(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s GICTRowId=0
		for  
		{	
			s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId="" 
			s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1)  //代码
			s GICTCodeU="<"_$ZCONVERT(GICTCode,"U")_">"
			s GICTDesc=$p($g(^DHCPHGENCON(GICTRowId)),"^",2)  //描述
			s GICTDescU="<"_$ZCONVERT(GICTDesc,"U")_">"
			s GICTHisCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",3)  //his代码
			s GICTHisDesc=$p($g(^DHCPHGENCON(GICTRowId)),"^",4)  //his描述
			s GICTCoeff=$p($g(^DHCPHGENCON(GICTRowId)),"^",9)  //转换系数
		
			i (GICTCodeU[code)&(GICTDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(GICTRowId,GICTCode,GICTDesc,GICTHisCode,GICTHisDesc,GICTCoeff)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2014-11-24
/// Description：查询标识为药品的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetGenList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetGenListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
			
		d OutputRowGen
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="DRUG")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowGen
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGen
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGenListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGenListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGenListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGenListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2014-11-24
/// Description：查询标识为检验项目的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenItmContrast","GetLABList","","","","")
Query GetLABList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag,OTFlag")
{
}

ClassMethod GetLABListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s LGPRowID=$o(^DHCLISGPi("0","Gen",PHEGRowId,0)) 
		s:LGPRowID'="" OTFlag=$p($g(^DHCLISGP(LGPRowID)),"^",5) //医嘱类型标识
		s:LGPRowID="" OTFlag=""
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowLAB
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s LGPRowID=$o(^DHCLISGPi("0","Gen",PHEGRowId,0)) 
				s:LGPRowID'="" OTFlag=$p($g(^DHCLISGP(LGPRowID)),"^",5) //医嘱类型标识
				s:LGPRowID="" OTFlag=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="LAB")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowLAB
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLAB
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag,OTFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLABListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLABListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLABListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLABListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2014-11-24
/// Description：查询标识为检验标本的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetSPECList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetSPECListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowSPEC
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="SPEC")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowSPEC
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSPEC
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSPECListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSPECListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSPECListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSPECListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2015-1-27
/// Description：查询标识为检查项目的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetPartList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetPartListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowPart
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i ((PHLICodeU="CHECK")||(PHLICodeU="ULTR")||(PHLICodeU="RADI")||(PHLICodeU="ENDO"))&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowPart
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPart
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPartListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPartListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2015-1-28
/// Description：查询标识为心电项目的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetElectList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetElectListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowElect
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="ELECT")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowElect
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowElect
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetElectListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetElectListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetElectListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetElectListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2017-4-10
/// Description：查询标识为手术项目的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenItmContrast","GetOperList","","","","")
Query GetOperList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetOperListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowOper
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="OPERATION")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowOper
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowOper
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOperListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2018-03-13
/// Description：查询标识为治疗项目的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenItmContrast","GetTreatmentList","","","","")
Query GetTreatmentList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetTreatmentListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowTreatment
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="TREAT")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowTreatment
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTreatment
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTreatmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTreatmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTreatmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTreatmentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2019-12-13
/// Description：查询标识为检查测值的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetCheckValuesList","","","","","")
Query GetCheckValuesList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetCheckValuesListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
		s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
		d OutputRowCheckValues
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
				s:PHEGSysFlag'="N" PHEGSysFlag="Y"
		
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
				i (PHLICodeU="CHECKVALUES")&(PHEGCodeU[code)&((PHEGDescU[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRowCheckValues
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCheckValues
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCheckValuesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckValuesListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCheckValuesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckValuesListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：获取已对照药品通用名中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCGenItmContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s GICTRowId=0
	for
	{
		s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId=""
		s GICTHisCode=$p(^DHCPHGENCON(GICTRowId),"^",3) //HisCode
		s str="<"_GICTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SaveData("8^10")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEGEN(rowid)),"^",1)
	s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)
	s hiscode=$p($g(^PHCGE("GE",hisrowid)),"^",1)
	s hisdesc=$p($g(^PHCGE("GE",hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHGENCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHGENCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHGENCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	
	/*s codeStr = ##class(web.DHCBL.KB.DHCGenItmContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCGenItmContrast).%New()
	s obj.GICTCode = code
	s obj.GICTDesc = desc
	s obj.GICTHisCode = hiscode
	s obj.GICTHisDesc = hisdesc
	s logJson="{GICTCode:"_$c(34)_code_$c(34)_",GICTDesc:"_$c(34)_desc_$c(34)_",GICTHisCode:"_$c(34)_hiscode_$c(34)_",GICTHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2014-11-25
/// Description：检验项目检验标本对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SaveData("8^9^LAB")
ClassMethod SaveLisData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s flag=$p(ids,"^",3) //flag
    s otflag=$p(ids,"^",4) //flag
    s code=$p($g(^DHCPHEGEN(rowid)),"^",1)
	s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)
	
	if ($d(^DHCLISBSVersion(1))){
		if (flag="LAB"){
			if (otflag="TS"){
				s hiscode=$listget($g(^dbo.BTTestSetD(hisrowid)),2)
				s hisdesc=$listget($g(^dbo.BTTestSetD(hisrowid)),3)
			}else{
				s hiscode=$listget($g(^dbo.BTTestCodeD(hisrowid)),2)
				s hisdesc=$listget($g(^dbo.BTTestCodeD(hisrowid)),3)	
			}
		}
		else{		
			s hiscode=$listget($g(^dbo.BTSpecimenD(hisrowid)),2)
			s hisdesc=$listget($g(^dbo.BTSpecimenD(hisrowid)),3)
		}	
	}
	else {
		s hiscode=hisrowid
		if (flag="LAB"){
			if (otflag="TS"){
				s Subscript=$p(hisrowid,"||",1)
				s Version=$p(hisrowid,"||",2)
				s hiscode=$p($g(^ARCIM(Subscript,Version,1)),"^",1) 
				s hisdesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 
				//s hisdesc=$p($g(^TTAB("TS",hisrowid)),"\",1)
			}else{
				s hisdesc=$p($g(^TTAB("TC",hisrowid)),"\",1)	
			}
		}
		else{		
			s hisdesc=$p($g(^TTAB("SPEC",hisrowid)),"\",1)
		}	
	}
	
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHGENCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHGENCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHGENCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCGenItmContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCGenItmContrast).%New()
	s obj.GICTCode = code
	s obj.GICTDesc = desc
	s obj.GICTHisCode = hiscode
	s obj.GICTHisDesc = hisdesc
	s logJson="{GICTCode:"_$c(34)_code_$c(34)_",GICTDesc:"_$c(34)_desc_$c(34)_",GICTHisCode:"_$c(34)_hiscode_$c(34)_",GICTHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveLisData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2015-1-27
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SavePartData("8^9")
ClassMethod SavePartData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEGEN(rowid)),"^",1)
	s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)
	s ARCIMSubscript = $p(hisrowid,"||",1)
	s ARCIMVersion = $p(hisrowid,"||",2)
	s hiscode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
	s hisdesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHGENCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHGENCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHGENCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCGenItmContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCGenItmContrast).%New()
	s obj.GICTCode = code
	s obj.GICTDesc = desc
	s obj.GICTHisCode = hiscode
	s obj.GICTHisDesc = hisdesc
	s logJson="{GICTCode:"_$c(34)_code_$c(34)_",GICTDesc:"_$c(34)_desc_$c(34)_",GICTHisCode:"_$c(34)_hiscode_$c(34)_",GICTHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SavePartData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:丁亚男
/// CreatDate: 2019-12-13
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SaveData("8^10")
ClassMethod SaveCheckValues(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEGEN(rowid)),"^",1)
	s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)
	s hiscode=$p(ids,"^",3)
	s hisdesc=$p(ids,"^",4)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHGENCON(0,"HisCode",hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHGENCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	
	s obj=##class(User.DHCGenItmContrast).%New()
	s obj.GICTCode = code
	s obj.GICTDesc = desc
	s obj.GICTHisCode = hiscode
	s obj.GICTHisDesc = hisdesc
	s logJson="{GICTCode:"_$c(34)_code_$c(34)_",GICTDesc:"_$c(34)_desc_$c(34)_",GICTHisCode:"_$c(34)_hiscode_$c(34)_",GICTHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2015-1-20
/// Description：检验项目检验标本对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCGenItmContrast).SaveCoeff("8^9^LAB")
ClassMethod SaveCoeff(id As %String, coeff As %String) As %String
{
	s result = ""
	
	s obj=##class(User.DHCGenItmContrast).%OpenId(id)
	s obj.GICTCoeff = coeff
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2014-11-5
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCGenItmContrast).%New()
		s pobj = ##class(User.DHCGenItmContrast).%OpenId(id)
		s eobj.GICTRowId = id
		s eobj.GICTCode = pobj.GICTCode
		s eobj.GICTDesc = pobj.GICTDesc
		s eobj.GICTHisCode = pobj.GICTHisCode
		s eobj.GICTHisDesc = pobj.GICTHisDesc
	
		s sc=##class(User.DHCGenItmContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,eobj.GICTDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator:丁亚男		
/// CreatDate:2019-12-13
/// Description:查询 Pacs的检查测值
/// Table:
/// Input: code, desc(name)
/// Output:PHCGERowId,PHCGECode,PHCGEName
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenItmContrast","GetDataForCheckValues","")
Query GetDataForCheckValues(desc As %String) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetDataForCheckValuesExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s str=""
	
	SET $NAMESPACE="DHC-PACS"
	s str=##Class(PACS.RISInterfaceExt).GetMeasureBase()
	SET $NAMESPACE="DHC-APP"
	//s str="1~描述1~code1^2~描述2~code2"
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s length=$length(str,"^")	
	for i=1:1:length
	{
		s istr=$p(str,"^",i)
		s RowId=$p(istr,"~",1)
		s Code=$p(istr,"~",2)
		s Desc = $p(istr,"~",3)
		s PINYIN=""
		s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
		i (($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))  
		{
			d OutputRowCmbCheckValues
		}
		
		
	}
		
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbCheckValues
    set Data=$lb(RowId,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCheckValuesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCheckValuesExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCheckValuesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCheckValuesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照-药品通用名和his对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastItmData()
ClassMethod AutoContrastItmData() As %String
{
	s count=0
	//遍历字典表
	s GenItmRowId=0
    for {
        s GenItmRowId=$o(^DHCPHEGEN(GenItmRowId)) q:GenItmRowId=""
        s GenItmCode=$p($g(^DHCPHEGEN(GenItmRowId)),"^",1)
        s GenItmDesc=$p($g(^DHCPHEGEN(GenItmRowId)),"^",2)
        s GenItmAcitveFlag=$p($g(^DHCPHEGEN(GenItmRowId)),"^",6)
        s GenItmSysFlag=$p($g(^DHCPHEGEN(GenItmRowId)),"^",8)
        continue:GenItmAcitveFlag="N" 
        s PHEGLibDr=$p($g(^DHCPHEGEN(GenItmRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
			
        continue:(PHLICodeU'="DRUG")
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^PHCGE("GE",0,"Name",$$ALPHAUP^SSUTIL4(GenItmDesc),RowId)) q:RowId=""
			s Code=$p($g(^PHCGE("GE",RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCGenItmContrast).%New()
				s obj.GICTCode = GenItmCode
				s obj.GICTDesc = GenItmDesc
				s obj.GICTHisCode = Code
				s obj.GICTHisDesc = GenItmDesc
				s logJson="{GICTCode:"_$c(34)_GenItmCode_$c(34)_",GICTDesc:"_$c(34)_GenItmDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_GenItmDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,GenItmDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照-心电项目和his对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastElectData()
ClassMethod AutoContrastElectData() As %String
{
	s count=0
	//遍历字典表
	s GenElectRowId=0
    for {
        s GenElectRowId=$o(^DHCPHEGEN(GenElectRowId)) q:GenElectRowId=""
        s GenElectCode=$p($g(^DHCPHEGEN(GenElectRowId)),"^",1)
        s GenElectDesc=$p($g(^DHCPHEGEN(GenElectRowId)),"^",2)
        s GenElectAcitveFlag=$p($g(^DHCPHEGEN(GenElectRowId)),"^",6)
        s GenElectSysFlag=$p($g(^DHCPHEGEN(GenElectRowId)),"^",8)
        continue:GenElectAcitveFlag="N" 
        s PHEGLibDr=$p($g(^DHCPHEGEN(GenElectRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
			
        continue:(PHLICodeU'="ELECT")
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(GenElectDesc),RowId)) q:RowId=""
			s Version=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(GenElectDesc),RowId,0))
			s Code=$p($g(^ARCIM(RowId,Version,1)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCGenItmContrast).%New()
				s obj.GICTCode = GenElectCode
				s obj.GICTDesc = GenElectDesc
				s obj.GICTHisCode = Code
				s obj.GICTHisDesc = GenElectDesc
				s logJson="{GICTCode:"_$c(34)_GenElectCode_$c(34)_",GICTDesc:"_$c(34)_GenElectDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_GenElectDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,GenElectDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照-检验通用名和his对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastLisData("LAB")
ClassMethod AutoContrastLisData(flag As %String) As %String
{
	s count=0
	//遍历字典表
	s GenLisRowId=0
    for {
        s GenLisRowId=$o(^DHCPHEGEN(GenLisRowId)) q:GenLisRowId=""
        s GenLisCode=$p($g(^DHCPHEGEN(GenLisRowId)),"^",1)
        s GenLisDesc=$p($g(^DHCPHEGEN(GenLisRowId)),"^",2)
        s GenLisAcitveFlag=$p($g(^DHCPHEGEN(GenLisRowId)),"^",6)
        s GenLisSysFlag=$p($g(^DHCPHEGEN(GenLisRowId)),"^",8)
        s LGPRowID=$o(^DHCLISGPi("0","Gen",GenLisRowId,0)) 
		s:LGPRowID'="" OTFlag=$p($g(^DHCLISGP(LGPRowID)),"^",5) //医嘱类型标识
		s:LGPRowID="" OTFlag=""
        continue:GenLisAcitveFlag="N" 
        s PHEGLibDr=$p($g(^DHCPHEGEN(GenLisRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
		continue:(PHLICodeU'=flag)
		
        s RowId=0,Code=""
        if ($d(^DHCLISBSVersion(1))){
			if (flag="LAB"){
				if (OTFlag="TS"){
					for
					{
						s RowId=$o(^dbo.BTTestSetD(RowId))
						q:RowId=""
						s hisdesc=$listget($g(^dbo.BTTestSetD(RowId)),3)
						continue:(hisdesc'=GenLisDesc) 
						s Code=$listget($g(^dbo.BTTestSetD(RowId)),2)
					}
				}else{
					for
					{
						s RowId=$o(^dbo.BTTestCodeD(RowId))
						q:RowId=""
						s hisdesc=$listget($g(^dbo.BTTestCodeD(RowId)),3)	
						continue:(hisdesc'=GenLisDesc) 
						s Code=$listget($g(^dbo.BTTestCodeD(RowId)),3)
					}
				}
			}
			else{	
				for
				{	
					s RowId=$o(^dbo.BTSpecimenD(RowId))
					q:RowId=""
					s hisdesc=$listget($g(^dbo.BTSpecimenD(RowId)),3)
					continue:(hisdesc'=GenLisDesc) 
					s Code=$listget($g(^dbo.BTSpecimenD(RowId)),2)
				}
			}	
		}
		else {
			if (flag="LAB"){
				if (OTFlag="TS"){
					for
					{
						s RowId=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(GenLisDesc),RowId)) 
						q:RowId=""
						s Version=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(GenLisDesc),RowId,0))
						s Code=$p($g(^ARCIM(RowId,Version,1)),"^",1)
					}
				}
				else
				{
					s hisdesc=$p($g(^TTAB("TC",GenLisCode)),"\",1)
					i hisdesc=GenLisDesc s Code=GenLisCode
				}
			}
			else{		
				s hisdesc=$p($g(^TTAB("SPEC",GenLisCode)),"\",1)
				i hisdesc=GenLisDesc s Code=GenLisCode
			}	
		}
		
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCGenItmContrast).%New()
				s obj.GICTCode = GenLisCode
				s obj.GICTDesc = GenLisDesc
				s obj.GICTHisCode = Code
				s obj.GICTHisDesc = GenLisDesc
				s logJson="{GICTCode:"_$c(34)_GenLisCode_$c(34)_",GICTDesc:"_$c(34)_GenLisDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_GenLisDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,GenLisDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-06-02
/// Description：自动对照-检查测值与HIS对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastCheckValues()
ClassMethod AutoContrastCheckValues() As %String
{
	s count=0
	//获取HIS的检查测值串
	SET $NAMESPACE="DHC-PACS"
	s str=##Class(PACS.RISInterfaceExt).GetMeasureBase()
	SET $NAMESPACE="DHC-APP"
	//s str="1~ss~测值"
	if str="" q "{success:'true',count:'0'}" 
	s length=$length(str,"^")	
	for i=1:1:length
	{
		s istr=$p(str,"^",i)
		s RowId=$p(istr,"~",1)
		s Code=$p(istr,"~",2)
		s Desc = $p(istr,"~",3)
		//根据HIS检查测值的描述找重名的通用名描述
		s PHEGRowId=0
		if ($d(^DHCPHEGENi(0,"Desc",$ZCONVERT(Desc,"U"))))
		{
	    	
	    	s PHEGRowId=$o(^DHCPHEGENi(0,"Desc",$ZCONVERT(Desc,"U"),PHEGRowId)) q:PHEGRowId=""
	    	
	    	s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
			s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
			s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
			s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
			s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
			s PHLICodeU=$ZCONVERT(PHLICode,"U")
			s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
			
			continue:(PHLICodeU'="CHECKVALUES")||(PHEGActiveFlag'="Y")
			//保存对照
		 	if (Code'="")
		 	{
				
				s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			
				If (sshiscode="") 
				{
					
					s obj=##class(User.DHCGenItmContrast).%New()
					s obj.GICTCode = PHEGCode
					s obj.GICTDesc = PHEGDesc
					s obj.GICTHisCode = Code
					s obj.GICTHisDesc = Desc
					s logJson="{GICTCode:"_$c(34)_PHEGCode_$c(34)_",GICTDesc:"_$c(34)_PHEGDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_Desc_$c(34)_"}"
					Ts
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc){	
						Tc		
						s id = obj.%Id()
						s count=count+1
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","检查测值与HIS对照",id,PHEGDesc,"A",logJson)
					}else{
						Trollback
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查测值与HIS对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
						s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
					
				 }
		 	}
		}
	       
	}
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-07-01
/// Description：自动对照-检查项目和his对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastCheckData()
ClassMethod AutoContrastCheckData() As %String
{
	s count=0
	//遍历字典表
	s PHEGRowId=0
	for  
	{	
		s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		continue:PHEGActiveFlag="N" 
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
		continue:(PHLICodeU'="CHECK")&(PHLICodeU'="ULTR")&(PHLICodeU'="RADI")&(PHLICodeU="ENDO")
		
		
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHEGDesc),RowId)) q:RowId=""
			s Version=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHEGDesc),RowId,0))
			s ServerMaterial=$p($g(^ARCIM(RowId,Version,7)),"^",6)
			s ARowId = RowId_"||"_Version	
			s enableflag=##class(web.DHCBL.CT.Arcim).GetARCIMEnable(ARowId)
			continue:(ServerMaterial'="S")||(enableflag'="Y")	
			s Code=$p($g(^ARCIM(RowId,Version,1)),"^",1) 	
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCGenItmContrast).%New()
				s obj.GICTCode = PHEGCode
				s obj.GICTDesc = PHEGDesc
				s obj.GICTHisCode = Code
				s obj.GICTHisDesc = PHEGDesc
				s logJson="{GICTCode:"_$c(34)_PHEGCode_$c(34)_",GICTDesc:"_$c(34)_PHEGDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_PHEGDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,PHEGDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-07-01
/// Description：自动对照-治疗和his对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).AutoContrastTreatData()
ClassMethod AutoContrastTreatData() As %String
{
	s count=0
	//遍历字典表
	s PHEGRowId=0
	for  
	{	
		s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		continue:PHEGActiveFlag="N" 
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
		continue:(PHLICodeU'="TREAT")
		
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHEGDesc),RowId)) q:RowId=""
			s Version=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHEGDesc),RowId,0))
			s ServerMaterial=$p($g(^ARCIM(RowId,Version,7)),"^",6)
			s ARowId = RowId_"||"_Version	
			s enableflag=##class(web.DHCBL.CT.Arcim).GetARCIMEnable(ARowId)
			continue:(enableflag'="Y")
			s ItemCatDr=$p($g(^ARCIM(RowId,Version,1)),"^",10)     ; 医嘱子分类 
			if (ItemCatDr'=""){
				s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) 
				continue:(OrderType'="N")	
			}	
			s Code=$p($g(^ARCIM(RowId,Version,1)),"^",1) 	
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHGENCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCGenItmContrast).%New()
				s obj.GICTCode = PHEGCode
				s obj.GICTDesc = PHEGDesc
				s obj.GICTHisCode = Code
				s obj.GICTHisDesc = PHEGDesc
				s logJson="{GICTCode:"_$c(34)_PHEGCode_$c(34)_",GICTDesc:"_$c(34)_PHEGDesc_$c(34)_",GICTHisCode:"_$c(34)_Code_$c(34)_",GICTHisDesc:"_$c(34)_PHEGDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_GenItmContrast","User.DHCGenItmContrast","通用名对照",id,PHEGDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCBL.KB.DHCGenItmContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
