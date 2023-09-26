/// Creator:高姗姗
/// CreatDate:2018-03-28
/// Description：医用知识库知识库注册扩展属性方法类
/// Table：User.MKBTermBaseExtendPro
Class web.DHCBL.MKB.MKBTermBaseExtendPro Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description：查询知识库扩展属性子表的内容
/// Table：User.MKBTermBaseExtendPro
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBaseExtendPro","GetList","","92","","")
Query GetList(rowid As %String, parref As %String, name As %String, type As %String) As %Query(ROWSPEC = "MKBTBEPRowId:%String,MKBTBEPConfig:%String,MKBTBEPName:%String,MKBTBEPType:%String,MKBTBEPSequence:%String,flag:%String,Id:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, name As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{

		s MKBTBEPRowId=rowid
		s MKBTBPRowId=$p(MKBTBEPRowId,"||",1)
		s MKBTBEPChildsub=$p(MKBTBEPRowId,"||",2)

		s MKBTBEPName=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),2)
		s MKBTBEPType=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),3)
		s MKBTBEPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),4)
		s MKBTBEPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),5)
		
		s flag=""
		d OutputRow
		
	}
	else
	{
		if (parref'=""){
			s pobj = ##class(User.MKBTermBaseProperty).%OpenId(parref)
			if ((pobj.MKBTBPType="L")||(pobj.MKBTBPType="T")){ //列表型或树形
				;输出主列名称
				if (pobj.MKBTBPName'=""){
					s MKBTBEPName=pobj.MKBTBPName
					s MKBTBEPType="TX"
					s flag="main"
					s Id="1"
					d OutputRow
				}
				;输出备注
				s MKBTBEPName="备注"
				s MKBTBEPType="TA"
				s flag=""
				s Id="2"
				d OutputRow
				;输出检索码
				s MKBTBEPName="检索码"
				s MKBTBEPType="TX"
				s flag=""
				s Id="3"
				d OutputRow
				;树形格式输出上级分类
				if (pobj.MKBTBPType="T"){
					s MKBTBEPName="上级分类"
					s MKBTBEPType="TX"
					s flag=""
					s Id="4"
					d OutputRow
				}
			}
			s Id=""
			/*s MKBTBEPChildsub=0
			for 
			{
				S MKBTBEPChildsub=$o(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
				s MKBTBEPRowId=parref_"||"_MKBTBEPChildsub
				s MKBTBEPName=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),2)
				s MKBTBEPType=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),3)
				s MKBTBEPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),4)
				s MKBTBEPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),5)
				s flag=""
				if (MKBTBEPChildsub>0)&((MKBTBEPType=type)||(type=""))&((MKBTBEPName[name))
				{
					d OutputRow
				}
			}*/
			//按顺序输出
			s Sequence=""
			for {
				s Sequence=$o(^User.MKBTermBaseExtendProI("SeqIndex",parref,Sequence)) q:Sequence=""
				s MKBTBEPChildsub=0
				for 
				{
					S MKBTBEPChildsub=$o(^User.MKBTermBaseExtendProI("SeqIndex",parref,Sequence,MKBTBEPChildsub)) q:MKBTBEPChildsub=""
					s MKBTBEPRowId=parref_"||"_MKBTBEPChildsub
					s MKBTBEPName=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),2)
					s MKBTBEPType=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),3)
					s MKBTBEPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),4)
					s MKBTBEPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(parref,"ChildExt",MKBTBEPChildsub)),5)
					s flag=""
					if (MKBTBEPChildsub>0)&((MKBTBEPType=type)||(type=""))&((MKBTBEPName[name))
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
    set Data=$lb(MKBTBEPRowId,MKBTBEPConfig,MKBTBEPName,MKBTBEPType,MKBTBEPSequence,flag,Id)
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
/// CreatDate: 2018-03-28
/// Description：修改时打开的数据
/// Table：User.MKBTermBaseExtendPro
/// Input：id
/// Other: w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.MKBTermBaseExtendPro).%OpenId(id)
	s eobj = ##class(web.Entity.MKB.MKBTermBaseExtendPro).%New()
	s eobj.MKBTBEPRowId=id
	s eobj.MKBTBEPParRef=$p(id,"||",1)
	s eobj.MKBTBEPName = pobj.MKBTBEPName
	s eobj.MKBTBEPType = pobj.MKBTBEPType
	s eobj.MKBTBEPConfig = pobj.MKBTBEPConfig
	s eobj.MKBTBEPSequence = pobj.MKBTBEPSequence
			
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description：保存知识点扩展属性子表字典的内容
/// Table：User.MKBTermBaseExtendPro
/// Input：web.Entity.MKB.MKBTermBaseExtendPro 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBTermBaseExtendPro) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s BaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),5)
		s:eobj.MKBTBEPType="" eobj.MKBTBEPType="TX"
		if (eobj.MKBTBEPRowId="")  //如果RowId未赋值则增加
		{
			s genLength=$d(^User.MKBTermBaseExtendProI("NameIndex",eobj.MKBTBEPParRef,eobj.MKBTBEPName))
			if (genLength=0)
			{
				s obj=##class(User.MKBTermBaseExtendPro).%New(eobj.MKBTBEPParRef)
				d:eobj.MKBTBEPParRef'="" obj.ParRefSetObjectId(eobj.MKBTBEPParRef)
				s obj.MKBTBEPConfig=eobj.MKBTBEPConfig   
				s obj.MKBTBEPName=eobj.MKBTBEPName
				s obj.MKBTBEPType=eobj.MKBTBEPType
				s obj.MKBTBEPSequence=eobj.MKBTBEPSequence
				/*s MKBTBPDesc=""
				s:eobj.MKBTBEPParRef'="" MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),3) //属性描述
				s MKBTBPBaseDr="",MKBTBDesc=""
				s:eobj.MKBTBEPParRef'="" MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),5)
				s:MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBPBaseDr)),3)*/  //术语注册描述
			
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc)
				{
					Tcommit
					s id = obj.%Id()
					if ((eobj.MKBTBEPType="S")||(eobj.MKBTBEPType="SD")){
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "BE", id, "B", obj.MKBTBEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}
					//保存日志
		 			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",id,MKBTBDesc_"-"_MKBTBPDesc_"-"_eobj.MKBTBEPName,"A",eobj)
					
					s resultTermExtPro=##class(web.DHCBL.MKB.MKBTerm).AddBaseExtPro(BaseDr,id)
					if (resultTermExtPro["false"){
						s result = "{success:'false',errorinfo:'知识库扩展属性同步失败！'}"
					}else{
						s result = "{success:'true',id:'"_id_"',logType:'A',elog:'"_id_":"_eobj.MKBTBEPName_";"_eobj.MKBTBEPType_";"_eobj.MKBTBEPConfig_"',blog:'"_id_":""'}"
					}
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
			s genLength=$d(^User.MKBTermBaseExtendProI("NameIndex",eobj.MKBTBEPParRef,eobj.MKBTBEPName))
			s MKBTBEPChildsub=$p(eobj.MKBTBEPRowId,"||",2)
			s TempChildsub=$o(^User.MKBTermBaseExtendProI("NameIndex",eobj.MKBTBEPParRef,eobj.MKBTBEPName,0))
			if (genLength=0)||((genLength'=0)&(MKBTBEPChildsub=TempChildsub))
			{
				s obj=##class(User.MKBTermBaseExtendPro).%OpenId(eobj.MKBTBEPRowId)
				s bobj = ##class(web.Entity.MKB.MKBTermBaseExtendPro).%New()
				s bobj.MKBTBEPName=obj.MKBTBEPName
				s bobj.MKBTBEPType=obj.MKBTBEPType
				s bobj.MKBTBEPConfig=obj.MKBTBEPConfig
				s bobj.MKBTBEPSequence=obj.MKBTBEPSequence
				
				d:eobj.MKBTBEPParRef'="" obj.ParRefSetObjectId(eobj.MKBTBEPParRef)
				s obj.MKBTBEPName= eobj.MKBTBEPName
				s obj.MKBTBEPType=eobj.MKBTBEPType
				s obj.MKBTBEPConfig=eobj.MKBTBEPConfig  
				s obj.MKBTBEPSequence=eobj.MKBTBEPSequence 
				/*s MKBTBPDesc=""
				s:eobj.MKBTBEPParRef'="" MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),3) //属性描述
				s MKBTBPBaseDr="",MKBTBDesc=""
				s:eobj.MKBTBEPParRef'="" MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),5)
				s:MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBPBaseDr)),3) */ //术语注册描述     	
				Ts					
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					//维护到引用表
					if (eobj.MKBTBEPType="S"){ //引用术语
						s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BE", id, "B", bobj.MKBTBEPConfig)
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BE", id, "B", obj.MKBTBEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}else{
						//切换为其他格式后同步删除引用表数据
						if (bobj.MKBTBEPType="S"){
							s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BE", id, "B", bobj.MKBTBEPConfig)
							s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BE", id, "B", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							}
						}
					}
					if (eobj.MKBTBEPType="SD"){ //知识表达式
						s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BE", id, "B", bobj.MKBTBEPConfig)
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BE", id, "B", obj.MKBTBEPConfig)	 
						if (resultRef["error"){
							s result = "{success:'false',errorinfo:'引用表保存失败'}"
						}
					}else{
						//切换为其他格式后同步删除引用表数据
						if (bobj.MKBTBEPType="SD"){
							s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BE", id, "B", bobj.MKBTBEPConfig)
							s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BE", id, "B", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							}
						}
					}
					//保存日志
					//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",eobj.MKBTBEPRowId,MKBTBDesc_"-"_MKBTBPDesc_"-"_eobj.MKBTBEPName,"U",eobj,bobj)
				
					s resultTermExtPro=##class(web.DHCBL.MKB.MKBTerm).UpdateBaseExtPro(BaseDr,id,bobj.MKBTBEPName)
					
					if (resultTermExtPro["false"){
						s result = "{success:'false',errorinfo:'知识库扩展属性同步失败！'}"
					}else{
						s result = "{success:'true',id:'"_id_"',logType:'U',elog:'"_id_":"_eobj.MKBTBEPName_";"_eobj.MKBTBEPType_";"_eobj.MKBTBEPConfig_"',blog:'"_id_":"_bobj.MKBTBEPName_";"_bobj.MKBTBEPType_";"_bobj.MKBTBEPConfig_"'}"  //返回RowId
					}	
					
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

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description：遍历保存知识点扩展属性子表字典的内容
/// Table：User.MKBTermBaseExtendPro
/// Input：web.Entity.MKB.MKBTermBaseExtendPro 实体类
/// Other: w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveAll(205,"测试属性修改345^TX^^^main*备注^TA^^^*检索码^TX^^^*展示名^TX^^205||123^*别名^TX^^205||124^","U")
ClassMethod SaveAll(rowid As %String, extendstr As %String, proOperateType As %String) As %String
{
	s proType=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),4)
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
			s MKBTBEPParRef = rowid
			s MKBTBEPName = $p(extend,"^",1)
			s MKBTBEPType = $p(extend,"^",2)
			s MKBTBEPConfig = $p(extend,"^",3)
			s MKBTBEPRowId = $p(extend,"^",4)
			s flag = $p(extend,"^",5)
			s MKBTBEPSequence=i
			s:proType="L" MKBTBEPSequence=i-3
			s:proType="T" MKBTBEPSequence=i-4
			continue:MKBTBEPName="备注"
			continue:MKBTBEPName="检索码"
			continue:MKBTBEPName="上级分类"
			if (flag="main"){ //扩展属性列表中的主列名称保存到属性表的主列名称字段
				b ;01
				s eobj = ##class(web.Entity.MKB.MKBTermBaseProperty).%New()
				s pobj = ##class(User.MKBTermBaseProperty).%OpenId(rowid)
				s eobj.MKBTBPRowId = rowid
				s eobj.MKBTBPCode = pobj.MKBTBPCode
				s eobj.MKBTBPDesc = pobj.MKBTBPDesc
				s eobj.MKBTBPType = pobj.MKBTBPType
				s:pobj.MKBTBPBaseDr'="" eobj.MKBTBPBaseDr = pobj.MKBTBPBaseDr.%Id()
				s eobj.MKBTBPConfig=pobj.MKBTBPConfig
				s eobj.MKBTBPName=MKBTBEPName
				s eobj.MKBTBPFlag=pobj.MKBTBPFlag
				s eobj.MKBTBPSequence=pobj.MKBTBPSequence
				s:pobj.MKBTBPDefinedNode'="" eobj.MKBTBPDefinedNode = pobj.MKBTBPDefinedNode.%Id()
				s eobj.MKBTBPIsShowInLeft=pobj.MKBTBPIsShowInLeft
				s eobj.MKBTBPCodeRules=pobj.MKBTBPCodeRules
				s eobj.MKBTBPWikiShow=pobj.MKBTBPWikiShow

				s resultBasePro=##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveEntity(eobj,"false")
				
				If (resultBasePro["true"){
					s result=result_"^"_1	
				}else{
					s result=result_"^"_0	
				}
			}else{
				s eobj = ##class(web.Entity.MKB.MKBTermBaseExtendPro).%New()
				s eobj.MKBTBEPParRef=MKBTBEPParRef
				s eobj.MKBTBEPRowId=MKBTBEPRowId
				s eobj.MKBTBEPName=MKBTBEPName
				s eobj.MKBTBEPType=MKBTBEPType
				s eobj.MKBTBEPConfig=MKBTBEPConfig
				s eobj.MKBTBEPSequence=MKBTBEPSequence
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
		
		s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),3) //属性描述
		s MKBTBDesc=""
		s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),5)
		s:MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBPBaseDr)),3)  //术语注册描述
		s:logJson'="" logJson="{"_logJson_"}"
		s:blogJson'="" blogJson="{"_blogJson_"}"
		if (result["0"){
			s result = "{success:'false',info:'保存失败！'}"
		}else{
			s result = "{success:'true',info:'保存成功！'}"	
			d:proOperateType="A" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",rowid,MKBTBDesc_"-"_MKBTBPDesc,"A",logJson)
			if (logJson'=blogJson){
				d:proOperateType="U" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",rowid,MKBTBDesc_"-"_MKBTBPDesc,"U",logJson,blogJson)
			}
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2018-05-08
/// Description：遍历删除知识点扩展属性子表字典的内容
/// Table：User.MKBTermBaseExtendPro
/// Input：web.Entity.MKB.MKBTermBaseExtendPro 实体类
/// Other: d ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).DeleteAll(2")
ClassMethod DeleteAll(rowid As %String, logFlag As %String = "") As %String
{
	s result=""
	s MKBTBEPChildsub=0
	s logJson=""
	for 
	{
		S MKBTBEPChildsub=$o(^User.MKBTermBasePropertyD(rowid,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
		s MKBTBEPRowId=rowid_"||"_MKBTBEPChildsub
		s resultDel=..DeleteData(MKBTBEPRowId,"false")
		if (resultDel["true"){
			s result=result_"^"_1	
			s log=$e($p(resultDel,"log:",2),2,*-2)
			s:logJson'="" logJson=logJson_","_log
			s:logJson="" logJson=log
		}else{
			s result=result_"^"_0	
		}
	}
	s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),3) //属性描述
	s MKBTBDesc=""
	s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),5)
	s:MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBPBaseDr)),3)
	s:logJson'="" logJson="{"_logJson_"}"
	if (result["0"){
		s result = "{success:'false',info:'保存失败！'}"
	}else{
		s result = "{success:'true',info:'保存成功！'}"	
		if (logFlag=""){
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",rowid,MKBTBDesc_"-"_MKBTBPDesc,"D",logJson)
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description：根据ID删除知识点扩展属性子表的内容
/// Table：User.MKBTermBaseExtendPro
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).DeleteData("70||72")
ClassMethod DeleteData(id As %String, logFlag As %String = "") As %String
{
	s result = ""
	s re=##class(web.DHCBL.MKB.MKBReference).DeleteData("BE",id)
	if (re'=""){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{
		//new Entity对象，用于保存日志	
		s eobj = ##class(web.Entity.MKB.MKBTermBaseExtendPro).%New()
		s pobj=##class(User.MKBTermBaseExtendPro).%OpenId(id)
		s eobj.MKBTBEPRowId = id
		s eobj.MKBTBEPParRef=$p(id,"||",1)
		s eobj.MKBTBEPConfig=pobj.MKBTBEPConfig	
		s eobj.MKBTBEPName=pobj.MKBTBEPName
		s eobj.MKBTBEPType=pobj.MKBTBEPType
		s eobj.MKBTBEPSequence=pobj.MKBTBEPSequence
		s MKBTBPDesc=""
		s:eobj.MKBTBEPParRef'="" MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),3) //属性描述
		s MKBTBPBaseDr="",MKBTBDesc=""
		s:eobj.MKBTBEPParRef'="" MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),5)
		s:MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBPBaseDr)),3)  //术语注册描述
				
		d pobj.%Close()
		k pobj
		Tstart
		
		s BaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(eobj.MKBTBEPParRef)),5)
		s resultTermExtPro=##class(web.DHCBL.MKB.MKBTerm).DeleteBaseExtPro(BaseDr,id)
		if (resultTermExtPro["false"){
			Trollback
			s result = "{success:'false',info:'知识库扩展属性同步删除失败！'}"	
		}else{
			s sc=##class(User.MKBTermBaseExtendPro).%DeleteId(id)

			if $$$ISOK(sc)
			{
				Tcommit
				s result = "{success:'true',info:'删除成功!',log:'"_id_":"_eobj.MKBTBEPName_";"_eobj.MKBTBEPType_";"_eobj.MKBTBEPConfig_"'}"	
				//保存日志
				if (logFlag=""){
		   			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBaseExtendPro","User.MKBTermBaseExtendPro","知识库注册扩展属性维护",id,MKBTBDesc_"-"_MKBTBPDesc_"-"_eobj.MKBTBEPName,"D",eobj)
				}
			}
			else 
			{
				Trollback
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description:获取列表配置项
/// Input:catid User.MKBTermBaseExtendPro id
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBaseExtendPro","GetConfigList","")
Query GetConfigList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTBPRowId=$p(rowid,"||",1)
		s MKBTBEPChildsub=$p(rowid,"||",2)

		s MKBTBEPType=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),3)
		s MKBTBEPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),4)
		
  		if ((MKBTBEPType="R")||(MKBTBEPType="CB")||(MKBTBEPType="C")){
	  		if (MKBTBEPConfig'="")
			{
				s entendLen=$Length(MKBTBEPConfig,"&%")
			    for i=1:1:entendLen   
			    { 
			      s ConfigNum=i  
			      s ConfigName=$p(MKBTBEPConfig,"&%",i)
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

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description：添加配置项扩展 result="true"时添加成功
/// Input：id-大类id，config-扩展配置项
/// w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveConfig(id)
ClassMethod SaveConfig(id, config) As %String
{
	s result="",flag=""
	q:(config="") "扩展配置项名称不能为空！"
	s obj=##class(User.MKBTermBaseExtendPro).%OpenId(id)
	s olds=obj.MKBTBEPConfig
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
		s:olds'="" obj.MKBTBEPConfig=olds_",&%"_config
		s:olds="" obj.MKBTBEPConfig=config
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

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description: 修改配置项扩展 result="true"时添加成功
/// Input：id-大类id，num-要修改的序号，extend-扩展配置项
/// w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveConfig(id)
ClassMethod UpdateConfig(id, index, config) As %String
{
	s result="",flag="",new=""
	q:(config="") "扩展配置项名称不能为空！"
	q:(index="") "未选中要修改的扩展配置项！"
	s obj=##class(User.MKBTermBaseExtendPro).%OpenId(id)
	s olds=obj.MKBTBEPConfig
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
		s obj.MKBTBEPConfig=new
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

/// Creator：高姗姗
/// CreatDate: 2018-03-28
/// Description: 删除扩展配置项，同时删除知识点扩展配置项的值
/// Input：id-大类id，num-要修改的序号
/// w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).DeleteConfig("63","扩展1")
ClassMethod DeleteConfig(id, index) As %String
{
	s result="",new="",flag=""
	q:(index="") "未选中要删除的扩展配置项！"
	
	s obj=##class(User.MKBTermBaseExtendPro).%OpenId(id)
	s olds=obj.MKBTBEPConfig
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
		s obj.MKBTBEPConfig=new
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

/// Creator:高姗姗
/// CreatDate:2018-09-11
/// Description：获取日志对象描述——给日志提供的接口
/// Input：key-Json的key值
/// Return：扩展属性描述
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).GetLogObjectDesc("78||85")
ClassMethod GetLogObjectDesc(key As %String) As %String
{
	s keyDesc=""
	q:key="" ""

	s propertyid=$p(key,"||",1)
	s child=$p(key,"||",2)
	if (propertyid'="")&(child'="")
	{
		s keyDesc=$LISTGET($G(^User.MKBTermBasePropertyD(propertyid,"ChildExt",child)),2)
	}
	q keyDesc
}

}
