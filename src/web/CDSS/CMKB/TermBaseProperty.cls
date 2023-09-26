/// Creator:高姗姗
/// CreatDate:2021-09-03
/// Description：CDSS知识库注册属性类
/// Table：CT.WDT.CDSS.TermBaseProperty
Class web.CDSS.CMKB.TermBaseProperty Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Description：查询CDSS知识库扩展属性父表内容
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermBaseProperty","GetList","","36","")
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
		s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),2)
		s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)
		s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),4)
		s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),5)
		s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),6)
		s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),7)
		s MKBTBPFlag=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),8)
		s MKBTBPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),9)
		s MKBTBPIsShowInLeft=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),11)
		s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),12)
		s MKBTBPWikiShow=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),13)
		d OutputRow
	}
	else
	{
		if (basedr'=""){
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s:desc'="" desc=$tr(desc," ","")

			s MKBTBPRowId=0
			for  
			{	s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",basedr,MKBTBPRowId)) q:MKBTBPRowId="" 
				s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),2)
				s MKBTBPCodeU=$ZCONVERT(MKBTBPCode,"U")
				s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)
				s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U")
				s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),4)
				s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),5)
				s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),6)
				s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),7)
				s MKBTBPFlag=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),8)
				s MKBTBPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),9)
				s MKBTBPIsShowInLeft=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),11)
				s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),12)
				s MKBTBPWikiShow=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),13)
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
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Description：数据标识重复验证方法
/// Input：id, code:标识,basedr:CDSS知识库id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).ValidateFlag("","Drug")
ClassMethod ValidateFlag(id As %String, code As %String, basedr As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^CT.WDT.CDSS.TermBasePropertyI("FlagIndex",basedr," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^CT.WDT.CDSS.TermBasePropertyI("FlagIndex",basedr," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Description:用于实现数据校验功能的方法  
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, basedr As %String, CodeRules As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:CodeRules'="" CodeRules=$ZCONVERT(CodeRules,"U") //转换成大写
	s flag="",flagc="",flagd="",flage=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TermBasePropertyI("CodeIndex",basedr," "_code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",basedr," "_desc))
	s:CodeRules'="" flage=$d(^CT.WDT.CDSS.TermBasePropertyI("CodeRulesIndex",basedr," "_CodeRules))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)||(flage>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd="",ide=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermBasePropertyI("CodeIndex",basedr," "_code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",basedr," "_desc,0))
		s:CodeRules'="" ide=$o(^CT.WDT.CDSS.TermBasePropertyI("CodeRulesIndex",basedr," "_CodeRules,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))||((ide'="")&(ide'=id)&(flage>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-3-27
/// Description：保存修改内容
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Input：web.CDSSEntity.CMKB.TermBaseProperty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TermBaseProperty, logFlag As %String = "") As %String
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
				s obj=##class(CT.WDT.CDSS.TermBaseProperty).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(eobj.MKBTBPRowId)
				
				s bobj = ##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
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
			s:eobj.MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBPBaseDr)),3)  //术语注册描述
			
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
		
				s resultTermPro=""
				//保存日志
				if (logFlag=""){
					d:eobj.MKBTBPRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermBaseProperty","CT.WDT.CDSS.TermBaseProperty"_eobj.MKBTBPBaseDr,"CDSS知识库注册属性维护",id,MKBTBDesc_"-"_eobj.MKBTBPDesc,"A",logJson)
					if (logJson'=blogJson){
						d:eobj.MKBTBPRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermBaseProperty","CT.WDT.CDSS.TermBaseProperty"_eobj.MKBTBPBaseDr,"CDSS知识库注册属性维护",eobj.MKBTBPRowId,MKBTBDesc_"-"_eobj.MKBTBPDesc,"U",logJson,blogJson)
					}
					//保存术语属性
					s:eobj.MKBTBPRowId="" resultTermPro=##class(web.CDSS.CMKB.Term).AddBasePro(eobj.MKBTBPBaseDr,id)
					s:eobj.MKBTBPRowId'="" resultTermPro=##class(web.CDSS.CMKB.Term).UpdateBasePro(eobj.MKBTBPBaseDr,id,bobj.MKBTBPDesc)
				}
				
				if (resultTermPro["false"){
					tro
					s result = resultTermPro
					//s result = "{success:'false',errorinfo:'CDSS知识库属性同步失败'}"
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
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Other: d ##class(web.CDSS.CMKB.TermBaseProperty).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
	s pobj = ##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(id)
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
/// Table:CT.WDT.CDSS.TermBaseProperty
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.TermBaseProperty).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""

	s eobj = ##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
	s pobj = ##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(id)
	s eobj.MKBTBPRowId = id
	s eobj.MKBTBPCode = pobj.MKBTBPCode
	s eobj.MKBTBPDesc = pobj.MKBTBPDesc
	s eobj.MKBTBPType = pobj.MKBTBPType
	s:pobj.MKBTBPBaseDr'="" eobj.MKBTBPBaseDr = pobj.MKBTBPBaseDr.%Id()
	s MKBTBDesc=""
	s:pobj.MKBTBPBaseDr'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBPBaseDr)),3)  //术语注册描述
	
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
	s resultTermPro=##class(web.CDSS.CMKB.Term).DeleteBasePro(eobj.MKBTBPBaseDr,id)
	if (resultTermPro["false"){
		Trollback
		s result="{success:'false',info:'CDSS知识库属性同步删除失败！'}"
	}else{
		s sc=##class(CT.WDT.CDSS.TermBaseProperty).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result="{success:'true',info:'删除成功！'}"

			//保存日志
	   		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermBaseProperty","CT.WDT.CDSS.TermBaseProperty"_eobj.MKBTBPBaseDr,"CDSS知识库注册属性维护",id,MKBTBDesc_"-"_eobj.MKBTBPDesc,"D",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}

	q result
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description: 根据id获取描述
/// Table:CT.WDT.CDSS.TermBaseProperty
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).GetDesc("1")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBaseProperty).GetDesc("41")
	s MKBTBPDesc=""
	if (RowId'=""){
		s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(RowId)),3)
	}
	q MKBTBPDesc
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).GetLastSequence(34)
ClassMethod GetLastSequence(base) As %String
{
  	s LastSequence=0
	s Sequence=0
  	for{
	  s Sequence=$o(^CT.WDT.CDSS.TermBasePropertyI("SeqIndex",base,Sequence)) q:Sequence="" 
	  s LastSequence=Sequence
  	}
	q LastSequence
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description：保存CDSS知识库属性拖拽的顺序
/// Other: w ##class(web.CDSS.CMKB.TermBaseProperty).SaveDragOrder("9&%12&%11")
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
		s obj=##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(rowid)
		s obj.MKBTBPSequence=i+seq-1
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			/*s scTermProOrder = ##class(web.CDSS.CMKB.TermProperty).SaveTermProOrder(rowid,i)
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
/// Table：CT.WDT.CDSS.TermBaseProperty
/// Input:catid CT.WDT.CDSS.TermBaseProperty id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermBaseProperty","GetConfigList","4")
Query GetConfigList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(rowid)),4)
		s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(rowid)),6)

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
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).SaveConfig(id)
ClassMethod SaveConfig(id, config) As %String
{
	s result="",flag=""
	q:(config="") "配置项名称不能为空！"
	s obj=##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(id)
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
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).UpdateConfig(id)
ClassMethod UpdateConfig(id, index, config) As %String
{
	s result="",flag="",new=""
	q:(config="") "配置项名称不能为空！"
	q:(index="") "未选中要修改的配置项！"
	s obj=##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(id)
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
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).DeleteConfig("63","扩展1")
ClassMethod DeleteConfig(id, index) As %String
{
	s result="",new="",flag=""
	q:(index="") "未选中要删除的配置项！"
	
	s obj=##class(CT.WDT.CDSS.TermBaseProperty).%OpenId(id)
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
/// Input：prodr-CDSS知识库属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermBaseProperty).FormValidateProDetail("1")
ClassMethod FormValidateProDetail(baseprodr As %String) As %String
{
	s flag=0
	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(baseprodr)),3) //CDSS知识库属性名称
	s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(baseprodr)),4) //CDSS知识库属性格式
	s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(baseprodr)),5)
	s MKBTRowId=""
	for
	{
		s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBPBaseDr,MKBTRowId)) q:MKBTRowId=""  //术语
		s MKBTPRowId=""
		for
		{
			s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,MKBTPRowId)) q:MKBTPRowId=""  //术语属性
			
			s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4) //术语属性格式
			
			if (MKBTBPType=MKBTPType){
				if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))) //属性下是否有属性内容
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
