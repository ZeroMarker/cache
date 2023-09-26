/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：医用知识库知识库注册属性类
/// Table：User.MKBTermBaseProperty
Class web.DHCBL.MKB.MKBTermBaseProperty Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Description：查询知识库扩展属性父表内容
/// Table：User.MKBTermBaseProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBaseProperty","GetList","","36","")
Query GetList(rowid, basedr, desc) As %Query(ROWSPEC = "MKBTBPRowId,MKBTBPCode,MKBTBPDesc,MKBTBPType,MKBTBPBaseDr,MKBTBPConfig,MKBTBPName,MKBTBPFlag,MKBTBPSequence,MKBTBPIsShowInLeft,MKBTBPCodeRules,MKBTBPWikiShow")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, basedr, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTBPRowId=rowid
		s MKBTBPCode=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),2)
		s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)
		s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),4)
		s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),5)
		s MKBTBPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),6)
		s MKBTBPName=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),7)
		s MKBTBPFlag=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),8)
		s MKBTBPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),9)
		s MKBTBPIsShowInLeft=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),11)
		s MKBTBPCodeRules=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),12)
		s MKBTBPWikiShow=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),13)
		d OutputRow
	}
	else
	{
		if (basedr'=""){
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s:desc'="" desc=$tr(desc," ","")

			s MKBTBPRowId=0
			for  
			{	s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",basedr,MKBTBPRowId)) q:MKBTBPRowId="" 
				s MKBTBPCode=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),2)
				s MKBTBPCodeU=$ZCONVERT(MKBTBPCode,"U")
				s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)
				s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U")
				s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),4)
				s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),5)
				s MKBTBPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),6)
				s MKBTBPName=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),7)
				s MKBTBPFlag=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),8)
				s MKBTBPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),9)
				s MKBTBPIsShowInLeft=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),11)
				s MKBTBPCodeRules=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),12)
				s MKBTBPWikiShow=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),13)
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTBPDescU)
				i ((MKBTBPDescU[desc)||(PINYIN[desc))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTBPRowId,MKBTBPCode,MKBTBPDesc,MKBTBPType,MKBTBPBaseDr,MKBTBPConfig,MKBTBPName,MKBTBPFlag,MKBTBPSequence,MKBTBPIsShowInLeft,MKBTBPCodeRules,MKBTBPWikiShow)
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
/// CreatDate: 2018-3-27
/// Table：User.MKBTermBaseProperty
/// Description：数据标识重复验证方法
/// Input：id, code:标识,basedr:知识库id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).ValidateFlag("","Drug")
ClassMethod ValidateFlag(id As %String, code As %String, basedr As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^User.MKBTermBasePropertyI("FlagIndex",basedr," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^User.MKBTermBasePropertyI("FlagIndex",basedr," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Table：User.MKBTermBaseProperty
/// Description:用于实现数据校验功能的方法  
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, basedr As %String, CodeRules As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:CodeRules'="" CodeRules=$ZCONVERT(CodeRules,"U") //转换成大写
	s flag="",flagc="",flagd="",flage=""
	s:code'="" flagc=$d(^User.MKBTermBasePropertyI("CodeIndex",basedr," "_code))
	s:desc'="" flagd=$d(^User.MKBTermBasePropertyI("DescIndex",basedr," "_desc))
	s:CodeRules'="" flage=$d(^User.MKBTermBasePropertyI("CodeRulesIndex",basedr," "_CodeRules))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)||(flage>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd="",ide=""
		s:code'="" idc=$o(^User.MKBTermBasePropertyI("CodeIndex",basedr," "_code,0))
		s:desc'="" idd=$o(^User.MKBTermBasePropertyI("DescIndex",basedr," "_desc,0))
		s:CodeRules'="" ide=$o(^User.MKBTermBasePropertyI("CodeRulesIndex",basedr," "_CodeRules,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))||((ide'="")&(ide'=id)&(flage>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Description：保存修改内容
/// Table：User.MKBTermBaseProperty
/// Input：web.Entity.MKB.MKBTermBaseProperty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBTermBaseProperty, logFlag As %String = "") As %String
{
	
	s result = ""
	
	if $IsObject(eobj)
	{
		
		s:eobj.MKBTBPCode="" eobj.MKBTBPCode=eobj.MKBTBPDesc
		s:eobj.MKBTBPSequence="" eobj.MKBTBPSequence=..GetLastSequence(eobj.MKBTBPBaseDr)+1
		;TX,TA,R,CB,C,F,S,P,SD,ETX
		if ((eobj.MKBTBPType="TX")||(eobj.MKBTBPType="TA")||(eobj.MKBTBPType="R")||(eobj.MKBTBPType="CB")||(eobj.MKBTBPType="C")||(eobj.MKBTBPType="F")||(eobj.MKBTBPType="S")||(eobj.MKBTBPType="P")||(eobj.MKBTBPType="SD")||(eobj.MKBTBPType="M")||(eobj.MKBTBPType="SS")||(eobj.MKBTBPType="ETX")){
			s eobj.MKBTBPName=eobj.MKBTBPDesc
		}
		if (eobj.MKBTBPCodeRules=""){
			//生成编码规则
			s eobj.MKBTBPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTBPDesc)
		}
		s flag=..FormValidate(eobj.MKBTBPRowId,eobj.MKBTBPCode,eobj.MKBTBPDesc,eobj.MKBTBPBaseDr,eobj.MKBTBPCodeRules)  //调用重复验证
		
		if (flag=1){
			s result = "{success:'false',errorinfo:'该记录（编码）已经存在'}"
		}
		else
		{
			s blogJson=""
			if (eobj.MKBTBPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MKBTermBaseProperty).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBTermBaseProperty).%OpenId(eobj.MKBTBPRowId)
				
				s bobj = ##class(web.Entity.MKB.MKBTermBaseProperty).%New()
				s bobj.MKBTBPRowId = eobj.MKBTBPRowId
				s bobj.MKBTBPCode = obj.MKBTBPCode
				s bobj.MKBTBPDesc = obj.MKBTBPDesc
				s bobj.MKBTBPType = obj.MKBTBPType
				s:obj.MKBTBPBaseDr'="" bobj.MKBTBPBaseDr = obj.MKBTBPBaseDr.%Id()
				s bobj.MKBTBPConfig=obj.MKBTBPConfig
				s bobj.MKBTBPName=obj.MKBTBPName
				s bobj.MKBTBPFlag=obj.MKBTBPFlag
				s bobj.MKBTBPSequence=obj.MKBTBPSequence
				s:obj.MKBTBPDefinedNode'="" bobj.MKBTBPDefinedNode = obj.MKBTBPDefinedNode.%Id()
				s bobj.MKBTBPIsShowInLeft=obj.MKBTBPIsShowInLeft
				s bobj.MKBTBPCodeRules=obj.MKBTBPCodeRules
				s bobj.MKBTBPWikiShow=obj.MKBTBPWikiShow
				s blogJson="{MKBTBPRowId:"""_bobj.MKBTBPRowId_""",MKBTBPCode:"""_bobj.MKBTBPCode_""",MKBTBPDesc:"""_bobj.MKBTBPDesc_""",MKBTBPType:"""_bobj.MKBTBPType_""",MKBTBPBaseDr:"""_bobj.MKBTBPBaseDr_""",MKBTBPConfig:"""_bobj.MKBTBPConfig_""",MKBTBPName:"""_bobj.MKBTBPName_""",MKBTBPFlag:"""_bobj.MKBTBPFlag_""",MKBTBPSequence:"""_bobj.MKBTBPSequence_""",MKBTBPDefinedNode:"""_bobj.MKBTBPDefinedNode_""",MKBTBPIsShowInLeft:"""_bobj.MKBTBPIsShowInLeft_""",MKBTBPCodeRules:"""_bobj.MKBTBPCodeRules_"""}"
			}
	
			s obj.MKBTBPCode = eobj.MKBTBPCode
			s obj.MKBTBPDesc = eobj.MKBTBPDesc
			s obj.MKBTBPType = eobj.MKBTBPType
			d:eobj.MKBTBPBaseDr'="" obj.MKBTBPBaseDrSetObjectId(eobj.MKBTBPBaseDr)
			d:eobj.MKBTBPBaseDr="" obj.MKBTBPBaseDrSetObjectId("")
			s MKBTBDesc=""
			s:eobj.MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(eobj.MKBTBPBaseDr)),3)  //术语注册描述
			
			s obj.MKBTBPConfig=eobj.MKBTBPConfig
			s obj.MKBTBPName=eobj.MKBTBPName
			s obj.MKBTBPFlag=eobj.MKBTBPFlag
			s obj.MKBTBPSequence=eobj.MKBTBPSequence
			d:eobj.MKBTBPDefinedNode'="" obj.MKBTBPDefinedNodeSetObjectId(eobj.MKBTBPDefinedNode)
			d:eobj.MKBTBPDefinedNode="" obj.MKBTBPDefinedNodeSetObjectId("")
			
			i eobj.MKBTBPIsShowInLeft="Y"
            {
                s obj.MKBTBPIsShowInLeft = "Y"
            }
            else
            {
                s obj.MKBTBPIsShowInLeft = "N"
            }
			s obj.MKBTBPCodeRules=eobj.MKBTBPCodeRules
			s obj.MKBTBPWikiShow=eobj.MKBTBPWikiShow
			s logJson="{MKBTBPRowId:"""_eobj.MKBTBPRowId_""",MKBTBPCode:"""_eobj.MKBTBPCode_""",MKBTBPDesc:"""_eobj.MKBTBPDesc_""",MKBTBPType:"""_eobj.MKBTBPType_""",MKBTBPBaseDr:"""_eobj.MKBTBPBaseDr_""",MKBTBPConfig:"""_eobj.MKBTBPConfig_""",MKBTBPName:"""_eobj.MKBTBPName_""",MKBTBPFlag:"""_eobj.MKBTBPFlag_""",MKBTBPSequence:"""_eobj.MKBTBPSequence_""",MKBTBPDefinedNode:"""_eobj.MKBTBPDefinedNode_""",MKBTBPIsShowInLeft:"""_eobj.MKBTBPIsShowInLeft_""",MKBTBPCodeRules:"""_eobj.MKBTBPCodeRules_""",MKBTBPWikiShow:"""_eobj.MKBTBPWikiShow_"""}"
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				
				s id = obj.%Id()
				//维护到引用表
				if (eobj.MKBTBPType="S"){ //引用术语格式配置项、起始节点维护到引用表
					if (eobj.MKBTBPRowId=""){
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "BP", id, "B", obj.MKBTBPConfig)	
						s resultRefNode=""
						if (eobj.MKBTBPDefinedNode'=""){
							s resultRefNode=##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "BP", id, "T", eobj.MKBTBPDefinedNode)	
						}
					}else{
						s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "B", bobj.MKBTBPConfig)
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "B", obj.MKBTBPConfig)	 
					    s resultRefNode=""
						if (eobj.MKBTBPDefinedNode'=""){
							s refNodeRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "T", bobj.MKBTBPDefinedNode)
							s resultRefNode=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refNodeRowId, "BP", id, "T", eobj.MKBTBPDefinedNode)	 
						}
					}
					if ((resultRef["error")||(resultRefNode["error")){
						s result = "{success:'false',errorinfo:'引用表保存失败'}"
					}
				}else{
					//切换为其他格式后同步删除引用表数据
					if (eobj.MKBTBPRowId'=""){
						if (bobj.MKBTBPType="S"){
							s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "B", bobj.MKBTBPConfig)
							s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "B", "")
							s resultRefNode=""
							if (bobj.MKBTBPDefinedNode'=""){
								s refNodeRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "T", bobj.MKBTBPDefinedNode)
								s resultRefNode=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refNodeRowId, "BP", id, "T", "")	 
							}
							if ((resultRef["error")||(resultRefNode["error")){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							} 
						}
					}
				}
				if ((eobj.MKBTBPType="SD")||(eobj.MKBTBPType="SS")){ //知识表达式、引用单节点格式配置项维护到引用表
					if (eobj.MKBTBPRowId=""){
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "BP", id, "B", obj.MKBTBPConfig)	
					}else{
						s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "B", bobj.MKBTBPConfig)
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "B", obj.MKBTBPConfig)	 
					}
					if (resultRef["error"){
						s result = "{success:'false',errorinfo:'引用表保存失败'}"
					}
				}else{
					//切换为其他格式后同步删除引用表数据
					if (eobj.MKBTBPRowId'=""){
						if ((bobj.MKBTBPType="SD")||(bobj.MKBTBPType="SS")){
							s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "B", bobj.MKBTBPConfig)
							s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "B", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							} 
						}
					}
				}
				if (eobj.MKBTBPType="M"){ //映射格式配置项维护到引用表
					if (eobj.MKBTBPRowId=""){
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "BP", id, "MB", obj.MKBTBPConfig)	
					}else{
						s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "MB", bobj.MKBTBPConfig)
						s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "MB", obj.MKBTBPConfig)	 
					}
					if (resultRef["error"){
						s result = "{success:'false',errorinfo:'引用表保存失败'}"
					}
				}else{
					//切换为其他格式后同步删除引用表数据
					if (eobj.MKBTBPRowId'=""){
						if (bobj.MKBTBPType="M"){
							s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("BP", id, "MB", bobj.MKBTBPConfig)
							s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "BP", id, "MB", "")
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表保存失败'}"
							} 
						}
					}
				}
				s resultTermPro=""
				//保存日志
				if (logFlag=""){
					d:eobj.MKBTBPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermBaseProperty","User.MKBTermBaseProperty"_eobj.MKBTBPBaseDr,"知识库注册属性维护",id,MKBTBDesc_"-"_eobj.MKBTBPDesc,"A",logJson)
					if (logJson'=blogJson){
						d:eobj.MKBTBPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermBaseProperty","User.MKBTermBaseProperty"_eobj.MKBTBPBaseDr,"知识库注册属性维护",eobj.MKBTBPRowId,MKBTBDesc_"-"_eobj.MKBTBPDesc,"U",logJson,blogJson)
					}
					//保存术语属性
					s:eobj.MKBTBPRowId="" resultTermPro=##class(web.DHCBL.MKB.MKBTerm).AddBasePro(eobj.MKBTBPBaseDr,id)
					s:eobj.MKBTBPRowId'="" resultTermPro=##class(web.DHCBL.MKB.MKBTerm).UpdateBasePro(eobj.MKBTBPBaseDr,id,bobj.MKBTBPDesc)
				}
				
				if (resultTermPro["false"){
					tro
					s result = resultTermPro
					//s result = "{success:'false',errorinfo:'知识库属性同步失败'}"
				}
				elseif (resultTermPro["已经有该属性"){
					Tc
					s result = "{success:'repeat',id:'"_id_"',errorinfo:'"_$e(resultTermPro,32,*-2)_"'}"
				}else{
					Tc
					s result = "{success:'true',id:'"_id_"'}" //返回RowId
				}
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
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
/// CreatDate: 2018-3-27
/// Description：获取修改时的记录
/// Table：User.MKBTermBaseProperty
/// Other: d ##class(web.DHCBL.MKB.MKBTermBaseProperty).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.MKB.MKBTermBaseProperty).%New()
	s pobj = ##class(User.MKBTermBaseProperty).%OpenId(id)
	s eobj.MKBTBPRowId = id
	s eobj.MKBTBPCode = pobj.MKBTBPCode
	s eobj.MKBTBPDesc = pobj.MKBTBPDesc
	s eobj.MKBTBPType = pobj.MKBTBPType
	s:pobj.MKBTBPBaseDr'="" eobj.MKBTBPBaseDr = pobj.MKBTBPBaseDr.%Id()
	s eobj.MKBTBPConfig=pobj.MKBTBPConfig
	s eobj.MKBTBPName=pobj.MKBTBPName
	s eobj.MKBTBPFlag=pobj.MKBTBPFlag
	s eobj.MKBTBPSequence=pobj.MKBTBPSequence
	s:pobj.MKBTBPDefinedNode'="" eobj.MKBTBPDefinedNode = pobj.MKBTBPDefinedNode.%Id()
	s eobj.MKBTBPIsShowInLeft=pobj.MKBTBPIsShowInLeft
	s eobj.MKBTBPCodeRules=pobj.MKBTBPCodeRules
	s eobj.MKBTBPWikiShow=pobj.MKBTBPWikiShow
	
	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description:根据id删除
/// Table:User.MKBTermBaseProperty
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBTermBaseProperty).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.MKB.MKBReference).DeleteData("BP",id)
	if (re'=""){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.MKB.MKBTermBaseProperty).%New()
		s pobj = ##class(User.MKBTermBaseProperty).%OpenId(id)
		s eobj.MKBTBPRowId = id
		s eobj.MKBTBPCode = pobj.MKBTBPCode
		s eobj.MKBTBPDesc = pobj.MKBTBPDesc
		s eobj.MKBTBPType = pobj.MKBTBPType
		s:pobj.MKBTBPBaseDr'="" eobj.MKBTBPBaseDr = pobj.MKBTBPBaseDr.%Id()
		s MKBTBDesc=""
		s:pobj.MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(eobj.MKBTBPBaseDr)),3)  //术语注册描述
		
		s eobj.MKBTBPConfig=pobj.MKBTBPConfig
		s eobj.MKBTBPName=pobj.MKBTBPName
		s eobj.MKBTBPFlag=pobj.MKBTBPFlag
		s eobj.MKBTBPSequence=pobj.MKBTBPSequence
		s:pobj.MKBTBPDefinedNode'="" eobj.MKBTBPDefinedNode = pobj.MKBTBPDefinedNode.%Id()
		s eobj.MKBTBPIsShowInLeft=pobj.MKBTBPIsShowInLeft
		s eobj.MKBTBPCodeRules=pobj.MKBTBPCodeRules
		s eobj.MKBTBPWikiShow=pobj.MKBTBPWikiShow
				
		Tstart
		//删除知识点
		s resultTermPro=##class(web.DHCBL.MKB.MKBTerm).DeleteBasePro(eobj.MKBTBPBaseDr,id)
		if (resultTermPro["false"){
			Trollback
			s result="{success:'false',info:'知识库属性同步删除失败！'}"
		}else{
			s sc=##class(User.MKBTermBaseProperty).%DeleteId(id)
			if $$$ISOK(sc)
			{
				Tcommit
				s result="{success:'true',info:'删除成功！'}"
				//引用表删除
				d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("BP",id)
				//保存日志
		   		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBaseProperty","User.MKBTermBaseProperty"_eobj.MKBTBPBaseDr,"知识库注册属性维护",id,MKBTBDesc_"-"_eobj.MKBTBPDesc,"D",eobj)
			}
			else
			{
				Trollback
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description: 根据id获取描述
/// Table:User.MKBTermBaseProperty
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).GetDesc("1")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBTermBaseProperty).GetDesc("41")
	s MKBTBPDesc=""
	if (RowId'=""){
		s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(RowId)),3)
	}
	q MKBTBPDesc
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).GetLastSequence(34)
ClassMethod GetLastSequence(base) As %String
{
  	s LastSequence=0
	s Sequence=0
  	for{
	  s Sequence=$o(^User.MKBTermBasePropertyI("SeqIndex",base,Sequence)) q:Sequence="" 
	  s LastSequence=Sequence
  	}
	q LastSequence
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description：保存知识库属性拖拽的顺序
/// Other: w ##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveDragOrder("9&%12&%11")
ClassMethod SaveDragOrder(order, seq) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"&%")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"&%",i)
		//选中行的顺序
		s obj=##class(User.MKBTermBaseProperty).%OpenId(rowid)
		s obj.MKBTBPSequence=i+seq-1
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			/*s scTermProOrder = ##class(web.DHCBL.MKB.MKBTermProperty).SaveTermProOrder(rowid,i)
			if (scTermProOrder["false"){
				s result = "{success:'false'}" 
			}*/
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"

	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'保存成功'}"
	}
	q result
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Description：获取列表配置项
/// Table：User.MKBTermBaseProperty
/// Input:catid User.MKBTermBaseProperty id
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBaseProperty","GetConfigList","4")
Query GetConfigList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),4)
		s MKBTBPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(rowid)),6)

  		if ((MKBTBPType="R")||(MKBTBPType="CB")||(MKBTBPType="C")){
	  		if (MKBTBPConfig'="")
			{
				s configLen=$Length(MKBTBPConfig,"&%")
			    for i=1:1:configLen   
			    { 
			      s ConfigNum=i  
			      s ConfigName=$p(MKBTBPConfig,"&%",i)
			      d OutputRowConfig
			    }
			}
	  	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowConfig
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
/// CreatDate: 2018-3-27
/// Description:添加配置项 result="true"时添加成功
/// Input：id-大类id，extend-配置项
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveConfig(id)
ClassMethod SaveConfig(id, config) As %String
{
	s result="",flag=""
	q:(config="") "配置项名称不能为空！"
	s obj=##class(User.MKBTermBaseProperty).%OpenId(id)
	s olds=obj.MKBTBPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (old=config){
		      s flag="N"    
		      s result="该配置项已经存在！"
	      }
	    }
	}

	if (flag'="N")
	{
		s:olds'="" obj.MKBTBPConfig=olds_"&%"_config
		s:olds="" obj.MKBTBPConfig=config
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
/// CreatDate: 2018-3-27
/// Description:修改配置项 result="true"时添加成功
/// Input：id-大类id，index-要修改的序号，config-配置项
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).UpdateConfig(id)
ClassMethod UpdateConfig(id, index, config) As %String
{
	s result="",flag="",new=""
	q:(config="") "配置项名称不能为空！"
	q:(index="") "未选中要修改的配置项！"
	s obj=##class(User.MKBTermBaseProperty).%OpenId(id)
	s olds=obj.MKBTBPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (old=config)&(index+1'=i){
		      s flag="N"    
		      s result="该配置项已经存在！"
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
		s obj.MKBTBPConfig=new
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
/// CreatDate: 2018-3-27
/// Description:删除配置项，同时删除知识点配置项的值
/// Input：id-大类id，index-要修改的序号
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).DeleteConfig("63","扩展1")
ClassMethod DeleteConfig(id, index) As %String
{
	s result="",new="",flag=""
	q:(index="") "未选中要删除的配置项！"
	
	s obj=##class(User.MKBTermBaseProperty).%OpenId(id)
	s olds=obj.MKBTBPConfig
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
	if (flag="Y")  //存在该配置项名称
	{
		//删除该配置项
		s obj.MKBTBPConfig=new
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
		s result = "该配置项名称不存在！"
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2018-07-11
/// Description：用于实现数据校验功能的方法 主要校验该属性同名且同格式的各术语属性下是否有属性内容
/// Input：prodr-知识库属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermBaseProperty).FormValidateProDetail("1")
ClassMethod FormValidateProDetail(baseprodr As %String) As %String
{
	s flag=0
	s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(baseprodr)),3) //知识库属性名称
	s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(baseprodr)),4) //知识库属性格式
	s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(baseprodr)),5)
	s MKBTRowId=""
	for
	{
		s MKBTRowId=$o(^User.MKBTermI("BaseIndex",MKBTBPBaseDr,MKBTRowId)) q:MKBTRowId=""  //术语
		s MKBTPRowId=""
		for
		{
			s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,MKBTPRowId)) q:MKBTPRowId=""  //术语属性
			
			s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4) //术语属性格式
			
			if (MKBTBPType=MKBTPType){
				if ($d(^User.MKBTermProDetailI("ProIdx",MKBTPRowId))) //属性下是否有属性内容
				{
					
					s flag=1
					q
				}
			}
		}
	
	}
	
	q flag
}

}
