/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库诊断列表扩展属性方法类
/// Table：CT.WDT.CDSS.TermExtendPro
Class web.CDSS.CMKB.TermExtendPro Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：查询诊断扩展属性子表的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermExtendPro","GetList","","19","","")
Query GetList(rowid As %String, parref As %String, name As %String, type As %String) As %Query(ROWSPEC = "MKBTEPRowId:%String,MKBTEPConfig:%String,MKBTEPName:%String,MKBTEPType:%String,MKBTEPSequence:%String,flag:%String,Id:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, name As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ^TMPGSS("list")=parref
	if (rowid'="") //根据rowid返回该条记录
	{

		s MKBTEPRowId=rowid
		s MKBTPRowId=$p(MKBTEPRowId,"||",1)
		s MKBTEPChildsub=$p(MKBTEPRowId,"||",2)

		s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),2)
		s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),3)
		s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),4)
		s MKBTEPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),5)
		s flag=""

		d OutputRow
		
	}
	else
	{
		if (parref'=""){
			s pobj = ##class(CT.WDT.CDSS.TermProperty).%OpenId(parref)
			if ((pobj.MKBTPType="L")||(pobj.MKBTPType="T")){ //列表型或树形
				;输出主列名称
				if (pobj.MKBTPName'=""){
					s MKBTEPName=pobj.MKBTPName
					s MKBTEPType="TX"
					s flag="main"
					s Id="1"
					d OutputRow
				}
				;输出备注
				s MKBTEPName="备注"
				s MKBTEPType="TA"
				s flag=""
				s Id="2"
				d OutputRow
				
				;输出检索码
				s MKBTEPName="检索码"
				s MKBTEPType="TA"
				s flag=""
				s Id="3"
				d OutputRow
				
				if ((pobj.MKBTPType="T")){
					;输出上级分类
					s MKBTEPName="上级分类"
					s MKBTEPType="TA"
					s flag=""
					s Id="4"
					d OutputRow
				}
				
			}
			s Id=""
			/*s MKBTEPChildsub=0
			for 
			{
				S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
				s MKBTEPRowId=parref_"||"_MKBTEPChildsub
				s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),2)
				s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),3)
				s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),4)
				s flag=""
				if (MKBTEPChildsub>0)&((MKBTEPType=type)||(type=""))&((MKBTEPName[name))
				{
					d OutputRow
				}
			}
			*/
			//按顺序输出
			s Sequence=""
			for {
				s Sequence=$o(^CT.WDT.CDSS.TermExtendProI("SeqIndex",parref,Sequence)) q:Sequence=""
				s MKBTEPChildsub=0
				for 
				{
					S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermExtendProI("SeqIndex",parref,Sequence,MKBTEPChildsub)) q:MKBTEPChildsub=""
					s MKBTEPRowId=parref_"||"_MKBTEPChildsub
					s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),2)
					s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),3)
					s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),4)
					s MKBTEPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(parref,"ChildExtPro",MKBTEPChildsub)),5)
					s flag=""
					if (MKBTEPChildsub>0)&((MKBTEPType=type)||(type=""))&((MKBTEPName[name))
					{
						d OutputRow
					}
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTEPRowId,MKBTEPConfig,MKBTEPName,MKBTEPType,MKBTEPSequence,flag,Id)
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

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.TermExtendPro).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(CT.WDT.CDSS.TermExtendPro).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.TermExtendPro).%New()
	s eobj.MKBTEPRowId=id
	s eobj.MKBTEPParRef=$p(id,"||",1)
	s eobj.MKBTEPName = pobj.MKBTEPName
	s eobj.MKBTEPType = pobj.MKBTEPType
	s eobj.MKBTEPConfig = pobj.MKBTEPConfig
	s eobj.MKBTEPSequence = pobj.MKBTEPSequence		
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:丁亚男
/// CreatDate:2018-05-15
/// Description：测试保存方法
/// Input：
/// w ##class(web.CDSS.CMKB.TermExtendPro).TestSave()
ClassMethod TestSave() As %String
{
	s rtn=""
	s eobj = ##class(web.CDSSEntity.CMKB.TermExtendPro).%New()
	
	s eobj.MKBTEPParRef = 19
	s eobj.MKBTEPType = "TX"
	s eobj.MKBTEPName="12"
	s rtn= ..SaveEntity(eobj)
	q rtn
}

/// Creator:丁亚男
/// Date:2018-4-17
/// Description：保存知识点扩展属性子表字典的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：str——扩展属性的信息用^拼串
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.TermExtendPro).SaveStrData()
ClassMethod SaveStrData(str As %String) As %String
{
	s result=""
	s MKBTEPRowId=$p(str,"^",1)
	s ParRef=$p(str,"^",2) 
	s MKBTEPName=$p(str,"^",3)
	s MKBTEPType=$p(str,"^",4)
	s MKBTEPConfig=$p(str,"^",5)
	q:(ParRef="") "{success:'false',errorinfo:'没有获取到要扩展的属性！'}"
	q:(MKBTEPName="") "{success:'false',errorinfo:'扩展属性名不能为空！'}"
	s catName=$listget($g(^CT.WDT.CDSS.TermPropertyD(ParRef)),7)  //属性的主列名
	s:catName="" catName=$listget($g(^CT.WDT.CDSS.TermPropertyD(ParRef)),2)  //属性的描述
	q:(MKBTEPName=catName) "{success:'false',errorinfo:'扩展属性名不能和主列名重名!'}"
	s:MKBTEPType="" MKBTEPType="TX"

	s upName=$ZCONVERT(MKBTEPName,"U") //转换成大写	
	if (MKBTEPRowId="")  //如果RowId未赋值则增加
	{

		s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",ParRef," "_upName))
		if (genLength=0)
		{
			s obj=##class(CT.WDT.CDSS.TermExtendPro).%New(ParRef)
			d obj.ParRefSetObjectId(ParRef)
			s obj.MKBTEPConfig=MKBTEPConfig   
			s obj.MKBTEPName=MKBTEPName
			s obj.MKBTEPType=MKBTEPType

			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc)
			{
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"

			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息

			}
		}
		else
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
	}
	else                     //如果RowId已赋值则修改
	{
		s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",ParRef," "_upName))
		s MKBTEPChildsub=$p(MKBTEPRowId,"||",2)
		s TempChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",ParRef," "_upName,0))
		if (genLength=0)||((genLength'=0)&(MKBTEPChildsub=TempChildsub))
		{
			s obj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(MKBTEPRowId)

			d obj.ParRefSetObjectId(ParRef)
			s obj.MKBTEPName= MKBTEPName
			s obj.MKBTEPType=MKBTEPType
			s obj.MKBTEPConfig=MKBTEPConfig        	
			Ts					
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		else
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
			
	}			

	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：保存知识点扩展属性子表字典的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：web.CDSSEntity.CMKB.TermExtendPro 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.TermExtendPro).SaveEntity()
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TermExtendPro) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s BaseDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTEPParRef)),6)
		s:eobj.MKBTEPType="" eobj.MKBTEPType="TX"
		if (eobj.MKBTEPRowId="")  //如果RowId未赋值则增加 ^CT.WDT.CDSS.TermBaseExtendProI
		{
			s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",eobj.MKBTEPParRef," "_$ZCONVERT(eobj.MKBTEPName,"U")))
			if (genLength=0)
			{
				s obj=##class(CT.WDT.CDSS.TermExtendPro).%New(eobj.MKBTEPParRef)
				d:eobj.MKBTEPParRef'="" obj.ParRefSetObjectId(eobj.MKBTEPParRef)
				s obj.MKBTEPConfig=eobj.MKBTEPConfig   
				s obj.MKBTEPName=eobj.MKBTEPName
				s obj.MKBTEPType=eobj.MKBTEPType
				s obj.MKBTEPSequence=eobj.MKBTEPSequence
				
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc)
				{
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					/*if ((eobj.MKBTEPType="S")||(eobj.MKBTEPType="SD")){
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById("", "E", id, "B", obj.MKBTEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}*/
					//保存日志
		 			//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermExtendPro","CT.WDT.CDSS.TermExtendPro",MKBTBDesc,id,MKBTDesc_"-"_MKBTPDesc_"-"_eobj.MKBTEPName,"A",eobj)
					
					s result = "{success:'true',id:'"_id_"',logType:'A',elog:'"_id_":"_eobj.MKBTEPName_";"_eobj.MKBTEPType_";"_eobj.MKBTEPConfig_"',blog:'"_id_":""'}"
				}
				else
				{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				}
			}
			else
			{
				s result = "{success:'false',errorinfo:'该记录已经存在！'}"
			}
		}
		else                     //如果RowId已赋值则修改
		{
			s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",eobj.MKBTEPParRef," "_$ZCONVERT(eobj.MKBTEPName,"U")))
			s MKBTEPChildsub=$p(eobj.MKBTEPRowId,"||",2)
			s TempChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",eobj.MKBTEPParRef," "_$ZCONVERT(eobj.MKBTEPName,"U"),0))
			if (genLength=0)||((genLength'=0)&(MKBTEPChildsub=TempChildsub))
			{
				s obj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(eobj.MKBTEPRowId)
				s bobj = ##class(web.CDSSEntity.CMKB.TermExtendPro).%New()
				s bobj.MKBTEPName=obj.MKBTEPName
				s bobj.MKBTEPType=obj.MKBTEPType
				s bobj.MKBTEPConfig=obj.MKBTEPConfig
				s bobj.MKBTEPSequence=obj.MKBTEPSequence
				
				d:eobj.MKBTEPParRef'="" obj.ParRefSetObjectId(eobj.MKBTEPParRef)
				s obj.MKBTEPName= eobj.MKBTEPName
				s obj.MKBTEPType=eobj.MKBTEPType
				s obj.MKBTEPConfig=eobj.MKBTEPConfig 
				s obj.MKBTEPSequence=eobj.MKBTEPSequence 
				       	
				Ts					
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					//s result = "{success:'true',id:'"_id_"'}"  //返回RowId
					/*
					//维护到引用表
					if (eobj.MKBTEPType="S"){
						s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("E", id, "B", bobj.MKBTEPConfig)
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "E", id, "B", obj.MKBTEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}else{
						//切换为其他格式后同步删除引用表数据
						if (bobj.MKBTEPType="S"){
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("E", id, "B", bobj.MKBTEPConfig)
							s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "E", id, "B", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							}
						}
					}
					
					if (eobj.MKBTEPType="SD"){ //知识表达式
						s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("E", id, "B", bobj.MKBTEPConfig)
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "E", id, "B", obj.MKBTEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}else{
						//切换为其他格式后同步删除引用表数据
						if (bobj.MKBTEPType="SD"){
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("E", id, "B", bobj.MKBTEPConfig)
							s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "E", id, "B", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							}
						}
					}*/
					//保存日志
					s result = "{success:'true',id:'"_id_"',logType:'U',elog:'"_id_":"_eobj.MKBTEPName_";"_eobj.MKBTEPType_";"_eobj.MKBTEPConfig_"',blog:'"_id_":"_bobj.MKBTEPName_";"_bobj.MKBTEPType_";"_bobj.MKBTEPConfig_"'}"  //返回RowId
					
				}
				else
				{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				}
			}
			else
			{
				s result = "{success:'false',errorinfo:'该记录已经存在！'}"
			}				
		}			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：遍历保存知识点扩展属性子表字典的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：web.CDSSEntity.CMKB.TermExtendPro 实体类
/// Other: w ##class(web.CDSS.CMKB.TermExtendPro).SaveAll(51479,"别名^TX^^^main*备注^TA^^^*检索码^TA^^^","U")
ClassMethod SaveAll(rowid As %String, extendstr As %String, proOperateType As %String) As %String
{
	s proType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),4)
	if (((proType="L")||(proType="T")||(proType="P"))&(extendstr'["||")){
		
		s resultDelete=..DeleteAll(rowid,"false")
		
	}
	
	s result=""
	if (extendstr'=""){
		s logJson=""
		s blogJson=""
		s extendlen=$Length(extendstr,"*")
		for i=1:1:extendlen
		{	
			s extend=$p(extendstr,"*",i)
			s MKBTEPParRef = rowid
			s MKBTEPName = $p(extend,"^",1)
			s MKBTEPType = $p(extend,"^",2)
			s MKBTEPConfig = $p(extend,"^",3)
			s MKBTEPRowId = $p(extend,"^",4)
			s flag = $p(extend,"^",5)
			s MKBTEPSequence=i
			s:proType="L" MKBTEPSequence=i-3
			s:proType="T" MKBTEPSequence=i-4
			continue:((MKBTEPName="备注")||(MKBTEPName="检索码")||(MKBTEPName="上级分类"))
			if (flag="main"){ //扩展属性列表中的主列名称保存到属性表的主列名称字段
				
				s eobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
				s pobj=##class(CT.WDT.CDSS.TermProperty).%OpenId(rowid)
				s eobj.MKBTPRowId = rowid
				s eobj.MKBTPCode = pobj.MKBTPCode
				s eobj.MKBTPDesc = pobj.MKBTPDesc
				s eobj.MKBTPType = pobj.MKBTPType
				s:pobj.MKBTPTermDr'="" eobj.MKBTPTermDr = pobj.MKBTPTermDr.%Id()
				s eobj.MKBTPConfig=pobj.MKBTPConfig
				s eobj.MKBTPName=MKBTEPName
				s eobj.MKBTPFlag=pobj.MKBTPFlag
				s eobj.MKBTPSequence=pobj.MKBTPSequence
				s:pobj.MKBTPDefinedNode'="" eobj.MKBTPDefinedNode = pobj.MKBTPDefinedNode.%Id()
				s eobj.MKBTPCodeRules=pobj.MKBTPCodeRules
				s resultPro=##class(web.CDSS.CMKB.TermProperty).SaveEntity(eobj,"false")
				
				
				If (resultPro["true"){
					s result=result_"^"_1	
				}else{
					s result=result_"^"_0	
				}
			}else{
				
				s eobj = ##class(web.CDSSEntity.CMKB.TermExtendPro).%New()
				s eobj.MKBTEPParRef=MKBTEPParRef
				s eobj.MKBTEPRowId=MKBTEPRowId
				s eobj.MKBTEPName=MKBTEPName
				s eobj.MKBTEPType=MKBTEPType
				s eobj.MKBTEPConfig=MKBTEPConfig
				s eobj.MKBTEPSequence=MKBTEPSequence
				s resultSave= ..SaveEntity(eobj)
			
				if (resultSave["true"){
					s result=result_"^"_1	
					
					s logType=$e($p(resultSave,"logType:",2),2)
					if (proOperateType="A"){//获取属性添加时的扩展属性日志串
						s log=$e($p($p(resultSave,"elog:",2),",blog:",1),2,*-1)
						s:logJson'="" logJson=logJson_","_log
						s:logJson="" logJson=log
					}
					if (proOperateType="U"){//获取属性修改时的扩展属性日志串
						s elog=$e($p($p(resultSave,"elog:",2),",blog:",1),2,*-1)
						s blog=$e($p(resultSave,"blog:",2),2,*-2)
						s:logJson'="" logJson=logJson_","_elog
						s:logJson="" logJson=elog
						s:blogJson'="" blogJson=blogJson_","_blog
						s:blogJson="" blogJson=blog
					}
					
				}else{
					s result=result_"^"_0	
				}
			}	
		}
		
		s:rowid'="" MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),3)
		s MKBTPTermDr="",MKBTDesc=""
		s:rowid'="" MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),6)
		s:MKBTPTermDr'="" MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //术语描述
		s MKBTBaseDR="",MKBTBDesc=""
		s:MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语注册id
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)  //术语注册描述
		s:logJson'="" logJson="{"_logJson_"}"
		s:blogJson'="" blogJson="{"_blogJson_"}"
		
		if (result["0"){
			s result = "{success:'false',info:'保存失败！'}"
		}else{
			s result = "{success:'true',info:'保存成功！'}"	
			//保存日志
			s ^TMPDYN("DYN")=logJson
			d:proOperateType="A" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermExtendPro","CT.WDT.CDSS.TermExtendPro",MKBTBDesc,rowid,MKBTDesc_"-"_MKBTPDesc_"-扩展属性","A",logJson)
			if (logJson'=blogJson){
				d:proOperateType="U" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermExtendPro","CT.WDT.CDSS.TermExtendPro",MKBTBDesc,rowid,MKBTDesc_"-"_MKBTPDesc_"-扩展属性","U",logJson,blogJson)
			}
			
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-05-11
/// Description：遍历删除知识点扩展属性子表字典的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：web.CDSSEntity.CMKB.TermExtendPro 实体类
/// Other: d ##class(web.CDSS.CMKB.TermExtendPro).DeleteAll(2")
ClassMethod DeleteAll(rowid As %String, logFlag As %String = "") As %String
{
	s result=""
	s MKBTEPChildsub=0
	s logJson=""
	for 
	{
		
		S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(rowid,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
		s MKBTEPRowId=rowid_"||"_MKBTEPChildsub
		s resultDel=..DeleteData(MKBTEPRowId,"false")
		
		if (resultDel["true"){
			s result=result_"^"_1	
			s log=$e($p(resultDel,"log:",2),2,*-2)
			s:logJson'="" logJson=logJson_","_log
			s:logJson="" logJson=log
		}else{
			s result=result_"^"_0	
		}
	}
	
	s:rowid'="" MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),3)
	s MKBTPTermDr="",MKBTDesc=""
	s:rowid'="" MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),6)
	s:MKBTPTermDr'="" MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //术语描述
	s MKBTBaseDR="",MKBTBDesc=""
	s:MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语注册id
	s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)  //术语注册描述
	
	s:logJson'="" logJson="{"_logJson_"}"
	if (result["0"){
		s result = "{success:'false',info:'保存失败！'}"
	}else{
		s result = "{success:'true',info:'保存成功！'}"	
		if (logFlag=""){
			d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermExtendPro","CT.WDT.CDSS.TermExtendPro",MKBTBDesc,rowid,MKBTDesc_"-"_MKBTPDesc,"D",logJson)
			
		}
	}
	
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：根据ID删除知识点扩展属性子表的内容
/// Table：CT.WDT.CDSS.TermExtendPro
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String, logFlag As %String = "") As %String
{
	s result = ""
	/*s re=##class(web.CDSS.CMKB.MKBReference).DeleteData("E",id)
	if (re'=""){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{*/
		//new Entity对象，用于保存日志	
		s eobj = ##class(web.CDSSEntity.CMKB.TermExtendPro).%New()
		s pobj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(id)
		s eobj.MKBTEPRowId = id
		s eobj.MKBTEPParRef=$p(id,"||",1)
		
		s:eobj.MKBTEPParRef'="" MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTEPParRef)),3)
		s MKBTPTermDr="",MKBTDesc=""
		s:eobj.MKBTEPParRef'="" MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTEPParRef)),6)
		s:MKBTPTermDr'="" MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //术语描述
		s MKBTBaseDR="",MKBTBDesc=""
		s:MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语注册id
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)  //术语注册描述
		
				
		s eobj.MKBTEPConfig=pobj.MKBTEPConfig	
		s eobj.MKBTEPName=pobj.MKBTEPName
		s eobj.MKBTEPType=pobj.MKBTEPType
		s eobj.MKBTEPSequence=pobj.MKBTEPSequence
		d pobj.%Close()
		k pobj
		Tstart
		
		/*s BaseDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTEPParRef)),6)
		s resultTermExtPro=##class(web.CDSS.CMKB.Term).DeleteBaseExtPro(BaseDr,id)
		if (resultTermExtPro["false"){
			s result = "{success:'false',info:'术语扩展属性同步删除失败！'}"	
		}*/
		s sc=##class(CT.WDT.CDSS.TermExtendPro).%DeleteId(id)

		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			if (logFlag=""){
		   		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermExtendPro","CT.WDT.CDSS.TermExtendPro",MKBTBDesc,id,MKBTDesc_"-"_MKBTPDesc_"-"_eobj.MKBTEPName,"D",eobj)
			}
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	//}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description:获取列表配置项
/// Input:catid CT.WDT.CDSS.TermExtendPro id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermExtendPro","GetConfigList","19||3")
Query GetConfigList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTPRowId=$p(rowid,"||",1)
		s MKBTEPChildsub=$p(rowid,"||",2)

		s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),3)
		s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),4)
		
  		if ((MKBTEPType="R")||(MKBTEPType="CB")||(MKBTEPType="C")){
	  		if (MKBTEPConfig'="")
			{
				s entendLen=$Length(MKBTEPConfig,"&%")
			    for i=1:1:entendLen   
			    { 
			      s ConfigNum=i  
			      s ConfigName=$p(MKBTEPConfig,"&%",i)
			      d OutputRowExt
			    }
			}
	  	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowExt
    set Data=$lb(ConfigNum,ConfigName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：添加配置项扩展 result="true"时添加成功
/// Input：id-大类id，config-扩展配置项
/// w ##class(web.CDSS.CMKB.TermExtendPro).SaveConfig(id)
ClassMethod SaveConfig(id, config) As %String
{
	s result="",flag=""
	q:(config="") "扩展配置项名称不能为空！"
	s obj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(id)
	s olds=obj.MKBTEPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (old=config){
		      s flag="N"    
		      s result="该扩展配置项已经存在！"
	      }
	    }
	}

	if (flag'="N")
	{
		s:olds'="" obj.MKBTEPConfig=olds_"&%"_config
		s:olds="" obj.MKBTEPConfig=config
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result = "true"
		}else{
			s result = "添加失败！"
		}
	}

	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description: 修改配置项扩展 result="true"时添加成功
/// Input：id-大类id，num-要修改的序号，extend-扩展配置项
/// w ##class(web.CDSS.CMKB.TermExtendPro).SaveConfig(id)
ClassMethod UpdateConfig(id, index, config) As %String
{
	s result="",flag="",new=""
	q:(config="") "扩展配置项名称不能为空！"
	q:(index="") "未选中要修改的扩展配置项！"
	s obj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(id)
	s olds=obj.MKBTEPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (old=config)&(index+1'=i){
		      s flag="N"    
		      s result="该扩展配置项已经存在！"
	      }
	      if (index+1=i) //要修改的序号
	      {
	      	s:new'="" new=new_"&%"_config
	      	s:new="" new=config
	      }
	      else
	      {
		    s:new'="" new=new_"&%"_old
		    s:new="" new=old
	      }
	    }
	}

	if (flag'="N")
	{
		s obj.MKBTEPConfig=new
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result = "true"
		}else{
			s result = "修改失败！"
		}
	}

	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description: 删除扩展配置项，同时删除知识点扩展配置项的值
/// Input：id-大类id，num-要修改的序号
/// w ##class(web.CDSS.CMKB.TermExtendPro).DeleteConfig("63","扩展1")
ClassMethod DeleteConfig(id, index) As %String
{
	s result="",new="",flag=""
	q:(index="") "未选中要删除的扩展配置项！"
	
	s obj=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(id)
	s olds=obj.MKBTEPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (index+1=i){
		      s flag="Y"  
	      }else{
		      s:new'="" new=new_"&%"_old
		      s:new="" new=old
	      }
	    }
	}
	if (flag="Y")  //存在该扩展配置项名称
	{
		//删除该扩展配置项
		s obj.MKBTEPConfig=new
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result = "true"
		}else{
			s result = "删除失败！"
		}
	}
	else
	{
		s result = "该扩展配置项名称不存在！"
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-10-12
/// Description：获取日志对象描述——给日志提供的接口
/// Input：key-Json的key值
/// Return：扩展属性描述
/// Other:w ##class(web.CDSS.CMKB.TermExtendPro).GetLogObjectDesc("37913||81923")
ClassMethod GetLogObjectDesc(key As %String) As %String
{
	s keyDesc=""
	q:key="" ""

	s propertyid=$p(key,"||",1)
	s child=$p(key,"||",2)
	if (propertyid'="")&(child'="")
	{
		s keyDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(propertyid,"ChildExtPro",child)),2)
	}
	q keyDesc
}

}
