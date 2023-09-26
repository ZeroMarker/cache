Import SQLUser

/// Function:医嘱项外部代码关联
/// Creator: sunfengchao
/// UpdateDate:2014-9-15
Class web.DHCBL.CT.ARCItemExternalCodes Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 查询外部代码关联  
/// Creator: sunfengchao
/// CreateDate: 2014-8-21
/// Table: ARC_ItemExternalCodes
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemExternalCodes","GetList","13381||1")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "EXTRowId,EXTCode,EXTDesc,ctlocdesc,DefaultReceive,DEfaultSend,EXTDateFrom,EXTDateTo,EXTCTLOCDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if ParRef'=""
	{
		s parref=$p(ParRef,"||",1)
		s version=$p(ParRef,"||",2)
		s rowid=0
		f  s rowid=$o(^ARCIM(parref,version,"EXT",rowid)) q:rowid=""  d
		.s EXTRowId=parref_"||"_version_"||"_rowid
		.s EXTCode=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",4)
		.s EXTDesc=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",6)
		.s EXTCTLOCDR=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",8)
		.s ctlocdesc=""
		.s:EXTCTLOCDR'="" ctlocdesc=$p($g(^CTLOC(EXTCTLOCDR)),"^",2) //获取科室描述
		.s DefaultReceive=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",10)
		.s DEfaultSend=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",9)
		.s EXTDateFrom=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",1)
		.s EXTDateTo=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",2)
		.s:EXTDateFrom'="" EXTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EXTDateFrom) //转换日期格式
		.s:EXTDateTo'="" EXTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EXTDateTo) //转换日期格式
		.d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(EXTRowId,EXTCode,EXTDesc,ctlocdesc,DefaultReceive,DEfaultSend,EXTDateFrom,EXTDateTo,EXTCTLOCDR)
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

/// Function: 新增外部代码关联
/// CreateDate:2013-5-22 
/// Creator:  sunfengchao
/// Debug:    d ##class(web.DHCBL.CT.ARCItemExternalCodes).AddOrderExtCode("")
ClassMethod AddOrderExtCode(SaveDataStr As %String) As %String
{
	n (SaveDataStr,%session)
	s eobj = ##class(web.Entity.CT.ARCItemExternalCodes).%New()
	s eobj.EXTRowId=""
	s eobj.EXTParRef=$p(SaveDataStr,"^",1)
	s eobj.EXTCode=$p(SaveDataStr,"^",2)
	s eobj.EXTDesc=$p(SaveDataStr,"^",3)
	s eobj.EXTCTLOCDR=$p(SaveDataStr,"^",4)
	
	s EXTDefaultReceive=$p(SaveDataStr,"^",7)
	if (EXTDefaultReceive="true")||(EXTDefaultReceive="Y") s eobj.EXTDefaultReceive="Y"
	else  s eobj.EXTDefaultReceive="N"
	
	s EXTDEfaultSend=$p(SaveDataStr,"^",8)
	if (EXTDEfaultSend="true")||(EXTDEfaultSend="Y") s eobj.EXTDEfaultSend="Y"
	else  s eobj.EXTDEfaultSend="N"
	
	s eobj.EXTDateFrom=$p(SaveDataStr,"^",5)
	s eobj.EXTDateTo=$p(SaveDataStr,"^",6)
	s Result=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	q Ret
}

/// Function: 修改外部代码关联
/// CreateDate: 2013-5-22 
/// Creator: sunfengchao
/// Debug:   w ##class(web.DHCBL.CT.ARCItemExternalCodes).UpdateOrderExtCode("1||1||5^ecwf^wfwfe^1^02/03/2017^^true^false")
ClassMethod UpdateOrderExtCode(editorderextcode As %String) As %String
{
	n (editorderextcode,%session)
	Set extrowid=$p(editorderextcode,"^",1)

	S EXTRowId=$p(editorderextcode,"^",1)
	s ParRef=$p(EXTRowId,"||",1)_"||"_$p(EXTRowId,"||",2)
	s eobj = ##class(web.Entity.CT.ARCItemExternalCodes).%New()
	s eobj.EXTRowId=$p(editorderextcode,"^",1)
	s eobj.EXTParRef=ParRef
	s eobj.EXTCode=$p(editorderextcode,"^",2)
	s eobj.EXTDesc=$p(editorderextcode,"^",3)
	s eobj.EXTCTLOCDR=$p(editorderextcode,"^",4)
	
	s EXTDefaultReceive=$p(editorderextcode,"^",7)
	if (EXTDefaultReceive="true")||(EXTDefaultReceive="Y") s eobj.EXTDefaultReceive="Y"
	else  s eobj.EXTDefaultReceive="N"
	
	s EXTDEfaultSend=$p(editorderextcode,"^",8)
	if (EXTDEfaultSend="true")||(EXTDEfaultSend="Y") s eobj.EXTDEfaultSend="Y"
	else  s eobj.EXTDEfaultSend="N"
	
	s eobj.EXTDateFrom=$p(editorderextcode,"^",5)
	s eobj.EXTDateTo=$p(editorderextcode,"^",6)
	s Result=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	q Ret
}

/// Function: 删除外部代码关联
/// CreateDate: 2013-5-22
/// Creator:  sunfengchao
/// Debug:    d ##class(web.DHCBL.CT.ARCItemExternalCodes).DeleteData("")
ClassMethod DeleteData(rowid As %String) As %String
{
	n (rowid,%session)
	Quit:rowid="" "{success:'false',info:'未选择医嘱项外部代码,不能删除!'}"

	//用于保存日志
	s obj = ##class(User.ARCItemExternalCodes).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.ARCItemExternalCodes).%New()
	s eobj.EXTRowId=rowid
	s eobj.EXTCode=obj.EXTCode
	s eobj.EXTDesc=obj.EXTDesc
	s:obj.EXTCTLOCDR'="" eobj.EXTCTLOCDR=obj.EXTCTLOCDR.%Id()
	s eobj.EXTDefaultReceive=obj.EXTDefaultReceive
	s eobj.EXTDEfaultSend=obj.EXTDEfaultSend
	s eobj.EXTDateFrom=obj.EXTDateFrom
	s eobj.EXTDateTo=obj.EXTDateTo
	d obj.%Close()

	Tstart
	s sc= ##class(User.ARCItemExternalCodes).%DeleteId(rowid)
	i $$$ISOK(sc)
	{
		Tc
		//删除时，日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemExternalCodes","User.ARCItemExternalCodes","医嘱项外部代码关联",rowid,eobj.EXTDesc,"D",eobj)
		d eobj.%Close()
		Quit "{success:'true',info:'删除成功!'}"
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项外部代码关联","web.DHCBL.CT.ARCItemExternalCodes","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		Quit "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
}

/// Function: 批量添加医嘱项外部代码  
/// Creator:  基础数据平台 孙凤超
/// CreateDate: 2014-12-17
/// rowid (医嘱项rowid)
/// debugs:   w ##class(web.DHCBL.CT.ARCItemExternalCodes).MultiAddExtCode("13902||1","4rr^rr43^3^Y^2017-03-10^2017-03-30^Y*rr^rrr444^2^N^2017-03-01^^N")
ClassMethod MultiAddExtCode(rowid As %String, AddExtCodeStr As %String) As %String
{
	N (rowid,AddExtCodeStr,%session)
    s ExtCodelength=$length(AddExtCodeStr,"*")
    for i=1:1:ExtCodelength 
    {
        Set ExtCodeStr=$P(AddExtCodeStr,"*",i)
        s eobj=##class(web.Entity.CT.ARCItemExternalCodes).%New()
        s eobj.EXTParRef=rowid
        s eobj.EXTCode=$p(ExtCodeStr,"^",1)   
        s eobj.EXTDesc=$p(ExtCodeStr,"^",2)   
        s eobj.EXTCTLOCDR=$p(ExtCodeStr,"^",3)
        s EXTDefaultReceive=$p(ExtCodeStr,"^",4)
		if (EXTDefaultReceive="true")||(EXTDefaultReceive="Y") s eobj.EXTDefaultReceive="Y"
		else  s eobj.EXTDefaultReceive="N"
	
		s EXTDEfaultSend=$p(ExtCodeStr,"^",7)
		if (EXTDEfaultSend="true")||(EXTDEfaultSend="Y") s eobj.EXTDEfaultSend="Y"
		else  s eobj.EXTDEfaultSend="N"
		
        s eobj.EXTDefaultReceive=EXTDefaultReceive
        s eobj.EXTDEfaultSend=EXTDEfaultSend
        s eobj.EXTDateFrom=$p(ExtCodeStr,"^",5)  
        s eobj.EXTDateTo=$p(ExtCodeStr,"^",6)
		s Result=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(eobj)
		if Result["success:'false'" s flag=1
	}
	if flag=1 q "{success:'false',info:'医嘱项外部代码添加失败, 请通过<医嘱项外部代码>页签添加!'}"
	else  q "{success:'true'}"
}

/// Function: 保存医嘱项外部代码  
/// Creator:  基础数据平台 陈莹
/// CreateDate: 2017-2-23
/// Others:   w ##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemExternalCodes) As %String
{
	n (eobj,%session)
	if $IsObject(eobj)
	{	
		s:eobj.EXTDateFrom'="" eobj.EXTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EXTDateFrom)
	    s:eobj.EXTDateTo'="" eobj.EXTDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EXTDateTo)
	    if eobj.EXTDateFrom="" s eobj.EXTDateFrom=+$h
	    
	    s:eobj.EXTDefaultReceive="" eobj.EXTDefaultReceive="N"
	    s:eobj.EXTDEfaultSend="" eobj.EXTDEfaultSend="N"
	   
	    S flag= ##class(web.DHCBL.CT.ARCItemExternalCodes).FormValidate(eobj.EXTRowId,eobj.EXTParRef,eobj.EXTCode,eobj.EXTDesc)
		if (flag=0)
		{
			if (eobj.EXTRowId="")
			{	
		        s obj=##class(User.ARCItemExternalCodes).%New(eobj.EXTParRef)
			}
			else
			{
				s obj=##class(User.ARCItemExternalCodes).%OpenId(eobj.EXTRowId)
			
				s bobj = ##class(web.Entity.CT.ARCItemExternalCodes).%New()
				s bobj.EXTRowId = eobj.EXTRowId
				s bobj.EXTParRef=eobj.EXTParRef
				s bobj.EXTCode = obj.EXTCode
				s bobj.EXTDesc = obj.EXTDesc
			
	        	if $IsObject(obj.EXTCTLOCDR){
						s bobj.EXTCTLOCDR = obj.EXTCTLOCDR.%Id() 
					}
	        	s bobj.EXTDefaultReceive=obj.EXTDefaultReceive
	        	s bobj.EXTDEfaultSend=obj.EXTDEfaultSend
	       	 	s bobj.EXTDateFrom=obj.EXTDateFrom
	        	s bobj.EXTDateTo=obj.EXTDateTo
		
			
			}
		
		
			d obj.EXTParRefSetObjectId(eobj.EXTParRef)
	        s obj.EXTCode=eobj.EXTCode
	        s obj.EXTDesc=eobj.EXTDesc
	        d obj.EXTCTLOCDRSetObjectId(eobj.EXTCTLOCDR)
	        s obj.EXTDefaultReceive=eobj.EXTDefaultReceive
	        s obj.EXTDEfaultSend=eobj.EXTDEfaultSend
	        s obj.EXTDateFrom=eobj.EXTDateFrom
	        s obj.EXTDateTo=eobj.EXTDateTo
		
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.EXTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemExternalCodes","User.ARCItemExternalCodes","医嘱项外部代码",id,eobj.EXTDesc,"A",eobj)
				d:eobj.EXTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemExternalCodes","User.ARCItemExternalCodes","医嘱项外部代码",id,eobj.EXTDesc,"U",eobj,bobj)
				
				///2020-04-30 chenying update 检验医嘱外部代码 检验医嘱的外部代码对照应判断唯一性，只有一条有效的外部代码，否则，存在两个外部代码，判断会导致取标本为最后一个添加的检验项的标本。增加第二个对照时自动将第一条对照截止
				s arcimsubscript=$p(id,"||",1)
				s arcimversion=$p(id,"||",2)
				s extchildsub=$p(id,"||",3)
				s childsub=0
				for 
				{
					s childsub=$o(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)) q:(childsub="")
					continue:extchildsub=childsub
					s EXTDateTo=$p($g(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)),"^",2)
					continue:EXTDateTo'=""
					s EXTRowId=arcimsubscript_"||"_arcimversion_"||"_childsub
					s Oobj=##class(User.ARCItemExternalCodes).%OpenId(EXTRowId)
					s Oobj.EXTDateTo=eobj.EXTDateFrom-1
					d Oobj.%Save()
				}
					
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项外部代码","web.DHCBL.CT.ARCItemExternalCodes","SaveEntity",eobj)
	    		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
		else
		{
			if flag=1 q "{success:'false',errorinfo:'外部代码已存在！'}"
			if flag=2 q "{success:'false',errorinfo:'外部描述已存在！'}"
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2017-2-23
/// Description:数据重复验证方法,js调用
/// Table:User.ARCItemExternalCodes
/// Input:id, parref, code, desc
/// Return:"1"(代码数据重复),"0"(数据都不重复),2 (描述重复)
/// Other:W ##class(web.DHCBL.CT.ARCItemExternalCodes).FormValidate("3||1||2","3||1","fewf","ww")
/// Other:W ##class(web.DHCBL.CT.ARCItemExternalCodes).FormValidate("","2||1","eee","e")
ClassMethod FormValidate(id, parref, code, desc) As %String
{
	new (id,parref,code,desc)
	s arcimsubscript="",arcimversion="",extchildsub="",flag=0
	s arcimsubscript=$p(parref,"||",1)
	s arcimversion=$p(parref,"||",2)
	if id'=""
	{
		s arcimsubscript=$p(id,"||",1)
		s arcimversion=$p(id,"||",2)
		s extchildsub=$p(id,"||",3)
	}
	q:(arcimsubscript="")||(arcimversion="") 0
	if code'=""
	{
		s childsub=0
		for 
		{
			s childsub=$o(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)) q:(childsub="")||(flag>0)
			s EXTCode=$p($g(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)),"^",4)
			s EXTDateTo=$p($g(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)),"^",2)
			continue:EXTDateTo<+$h
			if ((id'="")&&(code=EXTCode)&(childsub'=extchildsub))||((code=EXTCode)&&(id=""))
			{
				s flag=1
				q
			}
			
		}
	} 
	
	
	if desc'=""
	{
		s childsub=0
		for 
		{
			s childsub=$o(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)) q:(childsub="")||(flag>0)
			s EXTDesc=$p($g(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)),"^",6)
			s EXTDateTo=$p($g(^ARCIM(arcimsubscript,arcimversion,"EXT",childsub)),"^",2)
			continue:EXTDateTo<+$h
			if ((id'="")&&(desc=EXTDesc)&(childsub'=extchildsub))||((desc=EXTDesc)&&(id=""))
			{
				s flag=2
				q
			}
			
		}
	}	
	q flag
}

}
