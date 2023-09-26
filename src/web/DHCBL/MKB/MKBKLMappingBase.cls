/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：User.MKBKLMapping
Class web.DHCBL.MKB.MKBKLMappingBase Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询知识点映射注册表内容
/// Table：User.MKBKLMappingBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingBase","GetList","38","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBKMBRowId,MKBKMBCode,MKBKMBDesc,MKBKMBMappingRelation,MKBKMBKnowledge1,MKBKMBKnowledge2,MKBKMBNote,MKBKMBFlag,MKBKMBSequence,MKBKMBIdentify")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBKMBRowId=rowid
		s MKBKMBCode=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),2)
		s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)
		s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4)
		s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)
		s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)
		s MKBKMBNote=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),7)
		s MKBKMBFlag=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),8)
		s MKBKMBSequence=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),9)
		s MKBKMBIdentify=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),10)
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s MKBKMBRowId=""
		for
		{  
			s MKBKMBRowId=$o(^User.MKBKLMappingBaseD(MKBKMBRowId),-1) 
			q:MKBKMBRowId=""  
			s MKBKMBCode=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),2)
			s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)
			s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4)
			s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)
			s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)
			s MKBKMBNote=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),7)
			s MKBKMBFlag=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),8)
			s MKBKMBSequence=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),9)
			s MKBKMBIdentify=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),10)			
			s MKBKMBDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMBDesc)  
			s MKBKMBDescPY = $TR(MKBKMBDescPY,"_","")
			if (($ZCONVERT(MKBKMBDesc,"U")[desc)||(MKBKMBDescPY[desc))
			{
				d OutputRow
			}
		}
	}
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBKMBRowId,MKBKMBCode,MKBKMBDesc,MKBKMBMappingRelation,MKBKMBKnowledge1,MKBKMBKnowledge2,MKBKMBNote,MKBKMBFlag,MKBKMBSequence,MKBKMBIdentify)
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

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：自动生成代码
/// Table：User.MKBKLMappingBase
/// Input：rowid, desc, type
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).GenerateCode()
ClassMethod GenerateCode()
{
	if ($D(^User.MKBKLMappingBaseI("CodeIndex"))=0)
	{
		s code = "B00000001"	
	}
	else
	{
		s pre = $O(^User.MKBKLMappingBaseI("CodeIndex",""),-1)
		s pre = $E(pre,"3",$L(pre))	
		s code = pre+1
		s codelen = $L(code)
		for i=codelen:1:7
		{
			s code = "0"_code	
		}
		s code = "B"_code
	}
	q code
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据验证
/// Table：User.MKBKLMappingBase
/// Input：id, desc
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).Validate()
ClassMethod Validate(id, desc)
{
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^User.MKBKLMappingBaseI("DescIndex"," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^User.MKBKLMappingBaseI("DescIndex"," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:石萧伟
/// CreatDate:2018-08-08
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingBase).GetLastSequence()
ClassMethod GetLastSequence() As %String
{
  	s LastSequence=0
  	s Sequence=$o(^User.MKBKLMappingBaseI("SeqIndex",""),-1)
  	s LastSequence=$g(Sequence)+1
	q LastSequence
}

/// Creator：石萧伟
/// CreatDate: 2019-02-26
/// Description：数据保存方法（生成新的注册菜单）
/// Table：User.MKBKLMappingBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBTermKLMappingBase).SaveNewEntity()
ClassMethod SaveNewEntity(eobj As web.Entity.MKB.MKBKLMappingBase) As %String
{
	s result=""
	
	s codeforMenu=""
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.MKBKMBRowId,eobj.MKBKMBDesc)   
		s bobj = ""
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.MKBKMBRowId="")  //如果RowId未赋值则增加
			{ 
				s obj=##class(User.MKBKLMappingBase).%New()
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBKLMappingBase).%OpenId(eobj.MKBKMBRowId)
				s bobj=##class(web.Entity.MKB.MKBKLMappingBase).%New()
				s bobj.MKBKMBRowId = obj.%Id()
				s bobj.MKBKMBCode = obj.MKBKMBCode
				s codeforMenu=obj.MKBKMBCode
				s bobj.MKBKMBDesc = obj.MKBKMBDesc
				if $IsObject(obj.MKBKMBKnowledge1)
				{
					s bobj.MKBKMBKnowledge1 = obj.MKBKMBKnowledge1.%Id()
				}
				if $IsObject(obj.MKBKMBKnowledge2)
				{
					s bobj.MKBKMBKnowledge2 = obj.MKBKMBKnowledge2.%Id()
				}
				s bobj.MKBKMBMappingRelation = obj.MKBKMBMappingRelation
				s bobj.MKBKMBNote = obj.MKBKMBNote
				s bobj.MKBKMBFlag = obj.MKBKMBFlag
				s bobj.MKBKMBIdentify = obj.MKBKMBIdentify //2019-03-04
				s bobj.MKBKMBSequence = obj.MKBKMBSequence
			}
			if (eobj.MKBKMBCode="")
			{
				s obj.MKBKMBCode = ..GenerateCode()
				s codeforMenu = obj.MKBKMBCode	
			}
			else
			{
				s obj.MKBKMBCode = eobj.MKBKMBCode
				s obj.MKBKMBCode = eobj.MKBKMBCode	
			}
			s obj.MKBKMBDesc = eobj.MKBKMBDesc
			s obj.MKBKMBKnowledge1 = eobj.MKBKMBKnowledge1
			s obj.MKBKMBKnowledge2 = eobj.MKBKMBKnowledge2
			s obj.MKBKMBMappingRelation = eobj.MKBKMBMappingRelation
			s obj.MKBKMBNote = eobj.MKBKMBNote
			//s obj.MKBKMBFlag = eobj.MKBKMBFlag 
			s obj.MKBKMBIdentify = eobj.MKBKMBIdentify //2019-03-04
			if (obj.MKBKMBSequence="")
			{
				s obj.MKBKMBSequence=..GetLastSequence()
			}			
            i eobj.MKBKMBFlag="Y"
            {
                s obj.MKBKMBFlag = "Y"
            }
            else
            {
                s obj.MKBKMBFlag = "N"
            }			Ts
			s sc=obj.%Save()
			d obj.%Close()
			s id=""
			If $$$ISOK(sc)
			{
				 tc
				 
				 s id = obj.%Id()
			     if (eobj.MKBKMBRowId=""){
					 
				 	//新增菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.Code = "dhc.bdp.mkb.con."_codeforMenu           
		   			s menuobj.Caption = eobj.MKBKMBDesc   
		   			s menuobj.LinkFuntionDR=""   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbtermcontrast.csp?mappingBase="_id      
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.CON",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = eobj.MKBKMBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
		   			s menuobj.ValueExpression="&mappingBase="_id
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"
		   			s menuobj.IsMKBMenu="Y"
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
			   		}
				 }else{
					 //修改菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.ID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.CON."_$ZCONVERT(codeforMenu,"U"),0))
			   		s menuobj.Code = "dhc.bdp.mkb.con."_codeforMenu           
		   			s menuobj.Caption = eobj.MKBKMBDesc   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbtermcontrast.csp?mappingBase="_id      
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.CON",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = eobj.MKBKMBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)-1
		   			s menuobj.ValueExpression="&mappingBase="_id
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"   
		   			s menuobj.IsMKBMenu="Y"     
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   	
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
			   		}
				 }				
				//保存日志
				s result = "{success:'true',id:'"_id_"'}"  
				d:eobj.MKBKMBRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBase","User.MKBKLMappingBase","知识点映射注册",id,eobj.MKBKMBDesc,"A",eobj)
				d:eobj.MKBKMBRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBase","User.MKBKLMappingBase","知识点映射注册",eobj.MKBKMBRowId,eobj.MKBKMBDesc,"U",eobj,bobj)  
				
				if (eobj.MKBKMBRowId'="")	//修改
				{	
					if ((bobj.MKBKMBKnowledge1'="D")&&(bobj.MKBKMBKnowledge1'="A"))
					{
						s MKBRRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MB",id,"B",bobj.MKBKMBKnowledge1)
						d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MB", id, "B", obj.MKBKMBKnowledge1)		
					}
					if ((bobj.MKBKMBKnowledge2'="D")&&(bobj.MKBKMBKnowledge2'="A"))
					{
						s MKBRRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MB",id,"B",bobj.MKBKMBKnowledge2)
						d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MB", id, "B", obj.MKBKMBKnowledge2)	
					}
				}
				else
				{
					s ^lee(0) = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "MB", id, "B", obj.MKBKMBKnowledge1)	
					s ^lee(1) = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "MB", id, "B", obj.MKBKMBKnowledge2)	
				}	

				
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
			
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册","web.DHCBL.MKB.MKBKMBMappingBase","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语库维护","web.DHCBL.MKB.MKBTermBase","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBKLMappingBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBTermKLMappingBase).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBKLMappingBase) As %String
{
	s result=""
	
	s codeforMenu=""
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.MKBKMBRowId,eobj.MKBKMBDesc)   
		s bobj = ""
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.MKBKMBRowId="")  //如果RowId未赋值则增加
			{ 
				s obj=##class(User.MKBKLMappingBase).%New()
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBKLMappingBase).%OpenId(eobj.MKBKMBRowId)
				s bobj=##class(web.Entity.MKB.MKBKLMappingBase).%New()
				s bobj.MKBKMBRowId = obj.%Id()
				s bobj.MKBKMBCode = obj.MKBKMBCode
				s codeforMenu=obj.MKBKMBCode
				s bobj.MKBKMBDesc = obj.MKBKMBDesc
				if $IsObject(obj.MKBKMBKnowledge1)
				{
					s bobj.MKBKMBKnowledge1 = obj.MKBKMBKnowledge1.%Id()
				}
				if $IsObject(obj.MKBKMBKnowledge2)
				{
					s bobj.MKBKMBKnowledge2 = obj.MKBKMBKnowledge2.%Id()
				}
				s bobj.MKBKMBMappingRelation = obj.MKBKMBMappingRelation
				s bobj.MKBKMBNote = obj.MKBKMBNote
				s bobj.MKBKMBFlag = obj.MKBKMBFlag
				s bobj.MKBKMBIdentify = obj.MKBKMBIdentify //2019-03-04
				s bobj.MKBKMBSequence = obj.MKBKMBSequence
			}
			if (eobj.MKBKMBCode="")
			{
				s obj.MKBKMBCode = ..GenerateCode()
				s codeforMenu = obj.MKBKMBCode	
			}
			else
			{
				s obj.MKBKMBCode = eobj.MKBKMBCode
				s obj.MKBKMBCode = eobj.MKBKMBCode	
			}
			s obj.MKBKMBDesc = eobj.MKBKMBDesc
			s obj.MKBKMBKnowledge1 = eobj.MKBKMBKnowledge1
			s obj.MKBKMBKnowledge2 = eobj.MKBKMBKnowledge2
			s obj.MKBKMBMappingRelation = eobj.MKBKMBMappingRelation
			s obj.MKBKMBNote = eobj.MKBKMBNote
			s obj.MKBKMBIdentify = eobj.MKBKMBIdentify //2019-03-04
			//s obj.MKBKMBFlag = eobj.MKBKMBFlag 
			//s obj.MKBKMBSequence = eobj.MKBKMBSequence
			if (obj.MKBKMBSequence="")
			{
				s obj.MKBKMBSequence=..GetLastSequence()
			}			
            i eobj.MKBKMBFlag="Y"
            {
                s obj.MKBKMBFlag = "Y"
            }
            else
            {
                s obj.MKBKMBFlag = "N"
            }			Ts
			s sc=obj.%Save()
			d obj.%Close()
			s id=""
			If $$$ISOK(sc)
			{
				 tc
				 
				 s id = obj.%Id()
			     if (eobj.MKBKMBRowId=""){
					 
				 	//新增菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.Code = "dhc.bdp.mkb.klm."_codeforMenu           
		   			s menuobj.Caption = eobj.MKBKMBDesc   
		   			s menuobj.LinkFuntionDR=""   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="_id      
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = eobj.MKBKMBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
		   			s menuobj.ValueExpression="&mappingBase="_id
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"
		   			s menuobj.IsMKBMenu="Y"
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
			   		}
				 }else{
					 //修改菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.ID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM."_$ZCONVERT(codeforMenu,"U"),0))
			   		s menuobj.Code = "dhc.bdp.mkb.klm."_codeforMenu           
		   			s menuobj.Caption = eobj.MKBKMBDesc   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="_id      
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = eobj.MKBKMBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)-1
		   			s menuobj.ValueExpression="&mappingBase="_id
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"   
		   			s menuobj.IsMKBMenu="Y"     
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   	
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
			   		}
				 }				
				//保存日志
				s result = "{success:'true',id:'"_id_"'}"  
				d:eobj.MKBKMBRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBase","User.MKBKLMappingBase","知识点映射注册",id,eobj.MKBKMBDesc,"A",eobj)
				d:eobj.MKBKMBRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBase","User.MKBKLMappingBase","知识点映射注册",eobj.MKBKMBRowId,eobj.MKBKMBDesc,"U",eobj,bobj)  
				
				if (eobj.MKBKMBRowId'="")	//修改
				{	
					if ((bobj.MKBKMBKnowledge1'="D")&&(bobj.MKBKMBKnowledge1'="A"))
					{
						s MKBRRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MB",id,"B",bobj.MKBKMBKnowledge1)
						d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MB", id, "B", obj.MKBKMBKnowledge1)		
					}
					if ((bobj.MKBKMBKnowledge2'="D")&&(bobj.MKBKMBKnowledge2'="A"))
					{
						s MKBRRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MB",id,"B",bobj.MKBKMBKnowledge2)
						d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MB", id, "B", obj.MKBKMBKnowledge2)	
					}
				}
				else
				{
					s ^lee(0) = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "MB", id, "B", obj.MKBKMBKnowledge1)	
					s ^lee(1) = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "MB", id, "B", obj.MKBKMBKnowledge2)	
				}	

				
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
			
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册","web.DHCBL.MKB.MKBKMBMappingBase","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语库维护","web.DHCBL.MKB.MKBTermBase","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：石萧伟
/// CreatDate: 2018-08-13
/// Description:判断菜单是否由规则注册生成，自动生成菜单不允许修改代码
/// Input： menuid 菜单id
/// Return: 1:是，0:否
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).IsTermBaseCreate("1510")
ClassMethod IsTermBaseCreate(menuid) As %String
{
	;##class(web.DHCBL.MKB.MKBTermBase).IsTermBaseCreate(menuid)
	s result=0
	s Code=$LISTGET($G(^User.BDPMenuD(menuid)),2)
	if (Code["dhc.bdp.mkb.klm"){
		if (Code="dhc.bdp.mkb.klm"){ //术语管理菜单代码不允许修改
			s result=1	
		}else{ //术语管理子菜单代码不允许修改
			s CodeU=$ZCONVERT($p(Code,"dhc.bdp.mkb.klm.",2),"U")
			if ($d(^User.MKBKLMappingBaseI("CodeIndex"," "_CodeU))){
				s result=1
			}
		}
	}
	q result
}

/// 石萧伟
/// Description：保存拖拽的顺序
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).SaveDragOrder("")
ClassMethod SaveDragOrder(order) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(User.MKBKLMappingBase).%OpenId(rowid)
		s obj.MKBKMBSequence=i
		s sc=obj.%Save()
		d obj.%Close()
		
		If $$$ISOK(sc)
		{
			
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

/// Creator：李欣
/// CreatDate: 2018-09-10
/// Description：同步到术语库注册添加属性
/// Table：User.MKBKLMappingBase
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).SaveTest()
ClassMethod SaveBasePro(proName, proPId, baseId)
{
	s eobj = ##class(web.Entity.MKB.MKBTermBaseProperty).%New()
	s eobj.MKBTBPBaseDr = baseId
	s eobj.MKBTBPCode = ""
	s eobj.MKBTBPDesc = proName
	s eobj.MKBTBPConfig = proPId
	s eobj.MKBTBPFlag = ""
	s eobj.MKBTBPType = "M"
	s eobj.MKBTBPCodeRules = ""
	s result = ##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveEntity(eobj)
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：User.MKBKLMappingBase
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.Entity.MKB.MKBKLMappingBase).%New()
	s eobj.MKBKMBRowId = "40"
	s eobj.MKBKMBCode = "B00000014"
	//s eobj.MKBKMBCode = ..GenerateCode()
	s eobj.MKBKMBDesc = "诊断与病因"
	s eobj.MKBKMBKnowledge1 = 5
	s eobj.MKBKMBKnowledge2 = 7
	s eobj.MKBKMBMappingRelation = 3
	s eobj.MKBKMBNote = "无聊"
	s eobj.MKBKMBFlag = "N"
	s result = ..SaveEntity(eobj)
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBKLMappingBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBase).DeleteData(1)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	/*s DelResult = ##class(web.DHCBL.MKB.MKBReference).DeleteData("MB",id)
	if (DelResult'="")
	{
		s result = "{success:'false',info:'"_DelResult_",不能直接删除'}"	
		q result
	}*/
	if ($D(^User.MKBKLMappingBaseD(id))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	
	s eobj = ##class(web.Entity.MKB.MKBKLMappingBase).%New()
	s obj = ##class(User.MKBKLMappingBase).%OpenId(id)
	
	s eobj.MKBKMBRowId = id
	s eobj.MKBKMBCode = obj.MKBKMBCode
	s eobj.MKBKMBDesc = obj.MKBKMBDesc
	s eobj.MKBKMBKnowledge1 = obj.MKBKMBKnowledge1
	s eobj.MKBKMBKnowledge2 = obj.MKBKMBKnowledge2
	s eobj.MKBKMBMappingRelation = obj.MKBKMBMappingRelation
	s eobj.MKBKMBNote = obj.MKBKMBNote
	
	d obj.%Close()
	k obj
	
	
	Tstart
	s Child = ""
	s rownum=0
	for
	{
		s rownum = $O(^User.MKBKLMappingDetailI("RowNumIndex",id,rownum))
		q:rownum=""
		s KMDRowId = $O(^User.MKBKLMappingDetailI("RowNumIndex",id,rownum,0))
		s resultc = ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(KMDRowId,id)
		if resultc["false"
		{
			s Child="Y"	
		}
	}
	s sc=##class(User.MKBKLMappingBase).%DeleteId(id)

	s flagMenu=..GetMenuExist(eobj.MKBKMBCode)
	if (flagMenu=1){
		//菜单中删除
		s menuID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM."_$ZCONVERT(eobj.MKBKMBCode,"U"),0))
		s resultMenu = ##class(web.DHCBL.BDP.BDPMenu).DeleteData(menuID)
		if (resultMenu'["true"){
			s result = "{success:'false',info:'菜单维护数据删除失败！'}"
		}
	}	
	if $$$ISOK(sc)&&(Child="")
	{
		d eobj.%Close()
		Tcommit
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBase","User.MKBKLMappingBase","知识点映射注册",id,eobj.MKBKMBDesc,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
    q result
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:知识库删除时，判断知识库生成的菜单是否存在
/// Table：User.MKBTermBase
/// Input：code
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetMenuExist("Test")
ClassMethod GetMenuExist(code As %String) As %String
{
	s flagc="",flag=""
	s:code'="" code=$ZCONVERT(code,"U")
	s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM."_code))
	if (flagc>0){
		s flag=1	
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2018-03-23
/// Description：查询某个或其他术语库的公有属性接口
/// Input:base : 所属术语库ID	desc:用户输入的检索条件
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingBase","GetTermBaseSet","")
Query GetTermBaseSet(q As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetTermBaseSetExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s a("D")="文献管理"
	s a("A")="评估表"
	
	s desc=q
	s ID = ""
	s desc = $ZCONVERT(desc,"U")
	for
	{
		s ID = $o(^User.MKBTermBaseD(ID),-1)
		q:ID=""
		s Desc = $LG($G(^User.MKBTermBaseD(ID)),3)
		s a(ID)=Desc
	}	
	s ID = 0 
	for
	{
		s ID=$O(a(ID))
		q:ID=""
		
		s Desc = a(ID)
		s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s DescPY1=$TR(DescPY,"_","")
		if (Desc[desc)||(DescPY[desc)||(DescPY1[desc)
		{
			d OutputRowTermBaseSet
		}	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTermBaseSet
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermBaseSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermBaseSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTermBaseSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTermBaseSetExecute ]
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

/// Creator：李欣
/// CreatDate: 2018-03-23
/// Description：查询某个或其他术语库的公有属性接口
/// Input:base : 所属术语库ID	desc:用户输入的检索条件
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingBase","GetPublicCat","5","")
Query GetPublicCat(base As %String, desc As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetPublicCatExecute(ByRef qHandle As %Binary, base As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$zconvert(desc,"U")
	if (base'="")
	{
		if (base="A")||(base="D")
		{
			s ID = "Desc"
			s Desc = "中心词"
			
			d OutputRowPublicCat	
			/*for
			{
				s ID = $O(^User.MKBAssessmentBaseD(ID))
				q:ID=""
				
				s Desc = $LG($g(^User.MKBAssessmentBaseD(ID)),3)
				s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
				
				if (Desc[desc)||(DescPY[desc)
				{
					d OutputRowPublicCat	
				}	
			}*/
		}
		/*elseif (base="D")
		{
			s ID = 0
			for
			{
				s ID = $O(^User.MKBDocManageD(ID))
				q:ID=""
				s Desc = $LG($G(^User.MKBDocManageD(ID)))
				s Desc = $LG($g(^User.MKBDocManageD(ID)),3)
				s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
				
				if (Desc[desc)||(DescPY[desc)
				{
					d OutputRowPublicCat	
				}		
			}	
		}*/
		else
		{
			
			s tmp("Desc")="中心词"
			s tmp("Exp")="知识表达式"
			s ID = 0
			for
			{
				s ID = $o(^User.MKBTermBasePropertyI("TermBaseIdx",base,ID))
				q:ID=""
				s Type = $LG($G(^User.MKBTermBasePropertyD(ID)),4)
				if (Type'="TX")&&(Type'="TA")
				{
					continue	
				}
				s Desc = $lg($g(^User.MKBTermBasePropertyD(ID)),3)
				s tmp(ID)=Desc
			}	
			
			S ID=""
			for
			{
				s ID=$O(tmp(ID),-1)
				q:ID=""
				
				s Desc=tmp(ID)
				s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
				s DescPY1 = $TR(DescPY,"_","")
				
				if (Desc[desc)||(DescPY[desc)||(DescPY1[desc)
				{
					d OutputRowPublicCat
				}	
			}	
		}	
	}

	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPublicCat
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPublicCattClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPublicCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPublicCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPublicCatExecute ]
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

/// Creator：李欣
/// CreatDate: 2018-03-23
/// Description：锁死接口
/// Input:base : 所属术语库ID	desc:用户输入的检索条件
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingBase","GetPublicCat","5","")
ClassMethod MappingLock(id) As %String
{
	s ^TMP("Lock","Mapping"_id,"Y")=""
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBKLMappingBase).MappingReadLock(1)
ClassMethod MappingReadLock(id) As %String
{
	S Flag=""
	IF ($D(^TMP("Lock","Mapping"_id))=0)
	{
		//未锁死
		s Flag="N"	
	}
	else
	{
		//锁死
		s Flag="Y"	
	}
	q Flag
}

/// 解锁
/// w ##class(web.DHCBL.MKB.MKBKLMappingBase).unLockMethod(5)
ClassMethod unLockMethod(id) As %String
{
	k ^TMP("Lock","Mapping"_id)
	q ""
}

/// 判断知识点映射管理表有没有维护数据
ClassMethod hasDetail(base)
{
	q:$D(^User.MKBKLMappingDetailI("RowNumIndex",base))=0 "N"
	q "Y"
}

/// 取平台配置的密码
/// w ##class(web.DHCBL.MKB.MKBKLMappingBase).findPassWord()
ClassMethod findPassWord() As %String
{
	//取index
	s pwIndex=""
	s pwIndex=$o(^User.BDPPlatformConfigI("ConfigCodeI"," KLMAPPINGPASSWORD",0))
	s password=$LISTGET($G(^User.BDPPlatformConfigD(pwIndex)),3)
	q password
}

/// 通过描述获取属性id
ClassMethod findProIdByDesc(base, desc) As %String
{
	s proid=""
	s proid = $O(^User.MKBTermBasePropertyI("DescIndex",base," "_desc,0)) q:proid=""
	q proid
}

/// 高珊珊
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBKLMappingBase).GetDesc(3)
	s MKBKMBDesc=""
	if (RowId'=""){
		s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(RowId)),3)
	}
	q MKBKMBDesc
}

/// 丁亚男
/// w ##class(web.DHCBL.MKB.MKBKLMappingBase).GetMBRowId("CD")
ClassMethod GetMBRowId(Flag As %String) As %String
{
	s MBRowId=""
	if (Flag'=""){
		s MBRowId=$o(^User.MKBKLMappingBaseI("IdenIndex"," "_Flag,""))
	}
	q MBRowId
}

}
