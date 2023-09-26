Class web.DHCBL.KB.DHCGenLinkPointer Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2014-11-25
/// Description：查询检查部位通用名和部位关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetNewEvrPartList","","CHECK","197","1")
Query GetNewEvrPartList(rowid, lib, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF")
{
}

ClassMethod GetNewEvrPartListExecute(ByRef qHandle As %Binary, rowid, lib, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEPA(GlPPointerF)),"^",2) //指针名称
			
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			s GlPSysFlagF=""
			s GlPActiveFlagF=""
		
			d OutputNewRowEvrPart
		}
	}
	else
	{
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
		
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
			
			s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEPA(GlPPointerF)),"^",2) //指针名称 
			s GlPPointerU=$ZCONVERT(GlPPointer,"U")
			
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			s GlPSysFlagF=""
			s GlPActiveFlagF=""
			
			i (PHLICode1=lib)&((GlPPointerF=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
			{
				d OutputNewRowEvrPart
			}		
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRowEvrPart
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewEvrPartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewEvrPartListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewEvrPartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewEvrPartListExecute ]
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

/// Creator：石萧伟
/// CreatDate: 2014-11-26
/// Description：查询检验部位通用名和标本关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetNewLisList","","","","","")
Query GetNewLisList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF")
{
}

ClassMethod GetNewLisListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEGEN(GlPPointerF)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			s GlPSysFlagF="" 
			s GlPActiveFlagF=""
		
			d OutputNewRowLis
		}
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			s strRowId = "{ID:"_GlPRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
				s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
				s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
				
				s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
				s PHLICode1=$ZCONVERT(PHLICode,"U")
				
				s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
				s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEGEN(GlPPointerF)),"^",2) //指针名称 
				s GlPPointerU=$ZCONVERT(GlPPointer,"U")
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"
				s GlPSysFlagF="" 
				s GlPActiveFlagF=""
		
				i (PHLICode1="LAB")&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputNewRowLis
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRowLis
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewLisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewLisListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewLisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewLisListExecute ]
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

/// Creator：石萧伟
/// CreatDate: 2014-11-25
/// Description：查询药品通用名和剂型关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetNewList","","","")
Query GetNewList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
			s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
			s PHLICode1=$ZCONVERT(PHLICode,"U")
		
			s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEF(GlPPointerF)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			s GlPSysFlagF="" 
			s GlPActiveFlagF=""
			
			d OutputNewRow			
		}	
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			s strRowId = "{ID:"_GlPRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
				s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
				s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
				s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
				
				s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
				s PHLICode1=$ZCONVERT(PHLICode,"U")
		
				s GlPPointerF=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
				s:GlPPointerF'="" GlPPointer=$p($g(^DHCPHEF(GlPPointerF)),"^",2) //指针名称  
				s GlPPointerU=$ZCONVERT(GlPPointer,"U")
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"
				
				s GlPSysFlagF="" 
				s GlPActiveFlagF=""
		
				i (PHLICode1="DRUG")&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputNewRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,GlPActiveFlag,GlPSysFlag,GlPPointerF,GlPSysFlagF,GlPActiveFlagF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewListExecute ]
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

/// w ##class(web.DHCBL.KB.DHCGenLinkPointer).GetJson("12","PHIC")
ClassMethod GetJson(gen, type) As %String
{
	s:type'="" type=$ZCONVERT(type,"U")
	s GlPRowId = 0
	s json=""
	for 
	{
		s GlPRowId = $o(^DHCGENLINPi("0","Gen",$ZCONVERT(gen,"U"),GlPRowId)) q:GlPRowId=""	 
				
		s PHEGLibDr=$p($g(^DHCPHEGEN(gen)),"^",7) 
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
		s PHLICode1=$ZCONVERT(PHLICode,"U")
		i (PHLICode1=type){
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称 
			s json = json_PHEFDesc_"^"
		
		}
	}
	q json
}

/// Creator：高姗姗
/// CreatDate: 2015-1-8
/// Description：根据知识库标识查询药品通用名关联字典表内容
/// Input: lib=PHIC/LAB/CHECK
/// Table：User.DHCGenLinkPointer
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetInstrList","PHIC","","")  
Query GetInstrList(lib, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetInstrListExecute(ByRef qHandle As %Binary, lib, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s:lib'="" lib=$ZCONVERT(lib,"U")	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
	
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
				
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
			s PHLICode1=$ZCONVERT(PHLICode,"U")
		
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			if (lib="DRUG"){
				s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称  
			}
			s GlPPointerU=$ZCONVERT(GlPPointer,"U")
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			i (PHLICode1=lib)&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
			{
				d OutputRowInstr
			}		
		}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowInstr
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetInstrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrListExecute ]
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
/// CreatDate: 2014-11-25
/// Description：查询药品通用名和剂型关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetList","268,267,","","")
Query GetList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取通用名授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	//获取剂型授权Json
    s AuStrForm=##class(web.DHCBL.Authorize.DHCPHExtForm).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlagForm=0
    if (AuStrForm="")||(AuStrForm["limited:0") s AuFlagForm=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
			s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
			s PHLICode1=$ZCONVERT(PHLICode,"U")
		
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			d OutputRow			
		}	
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
			s strRowId = "{ID:"_GlPGenDrU_"}"
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
			s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s GlPPointerU=$ZCONVERT(GlPPointer,"U")
			s strRowIdForm = "{ID:"_GlPPointerU_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&((AuStrForm[strRowIdForm)||(AuFlagForm=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				
				s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称  
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"
			
				i (PHLICode1="DRUG")&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag)
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
/// CreatDate: 2014-11-25
/// Description：查询检查部位通用名和部位关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetList","","","","","")
Query GetPartList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEPDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetPartListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取通用名授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	//获取剂型授权Json
    s AuStrForm=##class(web.DHCBL.Authorize.DHCPHExtForm).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlagForm=0
    if (AuStrForm="")||(AuStrForm["limited:0") s AuFlagForm=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称
			s:GlPGenDr'="" PHEGActiveFlag=$p($g(^DHCPHEGEN(GlPGenDr)),"^",6) //通用名是否可用 
			continue:PHEGActiveFlag="N"
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" PHEPDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			d OutputRowPart
		}
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			
			
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
			s strRowId = "{ID:"_GlPGenDrU_"}"
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称
			s:GlPGenDr'="" PHEGActiveFlag=$p($g(^DHCPHEGEN(GlPGenDr)),"^",6) //通用名是否可用 
			continue:PHEGActiveFlag="N"
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
			
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" PHEPDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
			s GlPPointerU=$ZCONVERT(GlPPointer,"U")
			s strRowIdForm = "{ID:"_GlPPointerU_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&((AuStrForm[strRowIdForm)||(AuFlagForm=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"

				i ((PHLICode1="ELECT")||(PHLICode1="ULTR")||(PHLICode1="RADI")||(PHLICode1="ENDO"))&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRowPart
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPart
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEPDesc,GlPActiveFlag,GlPSysFlag)
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
/// CreatDate: 2014-11-25
/// Description：查询检查部位通用名和部位关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetEvrPartList","","","","","")
Query GetEvrPartList(rowid, lib, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEPDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetEvrPartListExecute(ByRef qHandle As %Binary, rowid, lib, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" PHEPDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			d OutputRowEvrPart
		}
	}
	else
	{
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
		
				s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
				s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
				s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
				
				s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
				s PHLICode1=$ZCONVERT(PHLICode,"U")
				
				s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
				s:GlPPointer'="" PHEPDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
				s GlPPointerU=$ZCONVERT(GlPPointer,"U")
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"
			
				i (PHLICode1=lib)&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRowEvrPart
				}		
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowEvrPart
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEPDesc,GlPActiveFlag,GlPSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetEvrPartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEvrPartListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEvrPartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEvrPartListExecute ]
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
/// CreatDate: 2014-11-26
/// Description：查询检验部位通用名和标本关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetList","","","","","")
Query GetLisList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,Desc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetLisListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取通用名授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")-1
		for i=1:1:idLen
		{
			s GlPRowId=$p(rowid,",",i)
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
				
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" Desc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2) //指针名称 
			s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
			s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
			s:GlPActiveFlag'="N" GlPActiveFlag="Y"
			s:GlPSysFlag'="N" GlPSysFlag="Y"
			
			d OutputRowLis
		}
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			
			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
			s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
			s strRowId = "{ID:"_GlPGenDrU_"}"
			
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
			s PHLICode1=$ZCONVERT(PHLICode,"U")
			
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
			s:GlPPointer'="" Desc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2) //指针名称 
			s GlPPointerU=$ZCONVERT(GlPPointer,"U")
			s strRowIdForm = "{ID:"_GlPPointerU_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&((AuStr[strRowIdForm)||(AuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
				s:GlPActiveFlag'="N" GlPActiveFlag="Y"
				s:GlPSysFlag'="N" GlPSysFlag="Y"
			
				i (PHLICode1="LAB")&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRowLis
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLis
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,Desc,GlPActiveFlag,GlPSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisListExecute ]
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-2-8 
/// w ##class(web.DHCBL.KB.DHCGenLinkPointer).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, gen As %String, text As %String) As %String
{
	s flag=""
	s flagd=""
	s:text'="" text=$ZCONVERT(text,"U") //转换成大写
	s flagd=$d(^DHCGENLINPi("0",gen,text))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""	
		s idd=$o(^DHCGENLINPi("0",gen,text,0))
		if ((idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCGenLinkPointer
/// Input：web.Entity.KB.DHCGenLinkPointer 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCGenLinkPointer) As %String
{
	
 s result = ""

	if $IsObject(eobj)
	{
		s args = eobj.GlPPointer
		s argsLen = $Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{	
		s eobj.GlPPointer=$p(args,",",i)
		s flag=..FormValidate(eobj.GlPRowId,eobj.GlPGenDr,eobj.GlPPointer)  //调用重复验证
 		if (flag=1)
  		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  		}
  		else
  		{
			if (eobj.GlPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCGenLinkPointer).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCGenLinkPointer).%OpenId(eobj.GlPRowId)
				s bobj = ##class(web.Entity.KB.DHCGenLinkPointer).%New()
				s bobj.GlPRowId = eobj.GlPRowId
				s:obj.GlPGenDr'="" bobj.GlPGenDr = obj.GlPGenDr.%Id()
				s bobj.GlPPointer = obj.GlPPointer
				s bobj.GlPActiveFlag = obj.GlPActiveFlag
				s bobj.GlPSysFlag = obj.GlPSysFlag
			}
			d:eobj.GlPGenDr'="" obj.GlPGenDrSetObjectId(eobj.GlPGenDr)
			d:eobj.GlPGenDr="" obj.GlPGenDrSetObjectId("")
			s obj.GlPPointer = eobj.GlPPointer
			s PHEPDesc=""
			s:eobj.GlPPointer'="" PHEPDesc=$p($g(^DHCPHEF(eobj.GlPPointer)),"^",2) //指针名称 
			
			i eobj.GlPActiveFlag="Y"
			{
				s obj.GlPActiveFlag = "Y"
			}
			else
			{
				s obj.GlPActiveFlag = "N"
			}

			i eobj.GlPSysFlag="Y"
			{
				s obj.GlPSysFlag = "Y"
			}
			else
			{
				s obj.GlPSysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s ids = id_","_ids
				s result = "{success:'true',id:'"_ids_"'}" //返回RowId
				d:eobj.GlPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_GenLinkPointer","User.DHCGenLinkPointer","通用名和指针关联",id,PHEPDesc,"A",eobj)
				d:eobj.GlPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_GenLinkPointer","User.DHCGenLinkPointer","通用名和指针关联",eobj.GlPRowId,PHEPDesc,"U",eobj,bobj)
			}
			else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名和指针关联","web.DHCBL.KB.DHCGenLinkPointer","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}
			
	}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCGenLinkPointer
/// Other: d ##class(web.DHCBL.KB.DHCGenLinkPointer).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCGenLinkPointer).%New()
	s pobj = ##class(User.DHCGenLinkPointer).%OpenId(id)
	s eobj.GlPRowId = id
	s:pobj.GlPGenDr'="" eobj.GlPGenDr = pobj.GlPGenDr.%Id()
	s eobj.GlPPointer = pobj.GlPPointer
	s:pobj.GlPActiveFlag="Y" eobj.GlPActiveFlag="true"
	s:pobj.GlPSysFlag="Y" eobj.GlPSysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-07-24
/// Description：获取修改时的记录
/// Table：User.DHCGenLinkPointer
/// Other: d ##class(web.DHCBL.KB.DHCGenLinkPointer).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCGenLinkPointer).%New()
	s pobj = ##class(User.DHCGenLinkPointer).%OpenId(id)
	s eobj.GlPRowId = id
	s:pobj.GlPGenDr'="" eobj.GlPGenDr = pobj.GlPGenDr.%Id()
	s eobj.GlPPointer = pobj.GlPPointer
		
	s eobj.GlPActiveFlag=pobj.GlPActiveFlag
	s eobj.GlPSysFlag=pobj.GlPSysFlag
	s:pobj.GlPActiveFlag'="N" eobj.GlPActiveFlag="Y"
	s:pobj.GlPSysFlag'="N" eobj.GlPSysFlag="Y"
	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2016-1-26
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(GenDr As %String, PointerDr As %String) As %String
{
	s return="",myInfo=""
	s flag=0
	if ($d(^DHCPHINSTRUC(0,"GP",GenDr,"Form",PointerDr))>0){
		s flag=1
		s myInfo=myInfo_"<知识库编辑器>"
	}	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCGenLinkPointer
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCGenLinkPointer).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s pobj = ##class(User.DHCGenLinkPointer).%OpenId(id)
	s re=##class(web.DHCBL.KB.DHCGenLinkPointer).GetRefFlag(pobj.GlPGenDr.%Id(),pobj.GlPPointer)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.KB.DHCGenLinkPointer).%New()
		
		s eobj.GlPRowId = id
		s:pobj.GlPGenDr'="" eobj.GlPGenDr = pobj.GlPGenDr.%Id()
		s eobj.GlPPointer = pobj.GlPPointer
		s PHEPDesc=""
		s:eobj.GlPPointer'="" PHEPDesc=$p($g(^DHCPHEF(eobj.GlPPointer)),"^",2) //指针名称 
		s eobj.GlPActiveFlag = pobj.GlPActiveFlag
		s eobj.GlPSysFlag = pobj.GlPSysFlag
	
		s sc=##class(User.DHCGenLinkPointer).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_GenLinkPointer","User.DHCGenLinkPointer","通用名和指针关联",id,PHEPDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名和指针关联","web.DHCBL.KB.DHCGenLinkPointer","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

}
