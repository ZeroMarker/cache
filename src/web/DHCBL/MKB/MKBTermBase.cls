/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：医用知识库知识库注册类
/// Table：User.MKBTermBase
Class web.DHCBL.MKB.MKBTermBase Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：查询知识库表内容
/// Table：User.MKBTermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBase","GetList","","","")
Query GetList(rowid As %String, desc As %String, type As %String) As %Query(ROWSPEC = "MKBTBRowId,MKBTBCode,MKBTBDesc,MKBTBType,MKBTBVersion,MKBTBSource,MKBTBPYCode,MKBTBNote,MKBTBCatDr,MKBTDesc,MKBTBFlag,MKBTBSequence,MKBTBCodeRules")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, type As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s MKBTBRowId=rowid
  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
  s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),4)
  s MKBTBVersion=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),5)
  s MKBTBSource=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),6)
  s MKBTBPYCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),7)
  s MKBTBNote=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),8)
  s MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),9)
  s:MKBTBCatDr="" MKBTDesc=""
  s:MKBTBCatDr'="" MKBTDesc=..GetCatText(MKBTBCatDr)
  s MKBTBFlag=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),10)
  s MKBTBSequence=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),11)
  s MKBTBCodeRules=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),12)
  d OutputRow
 }
 else
 {
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:desc'="" desc=$tr(desc," ","") //过滤空格

  s MKBTBRowId=""
  for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId),-1) 
	  q:MKBTBRowId=""  
	  //continue:MKBTBRowId=5
	  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
	  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	  s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),4)
	  s MKBTBVersion=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),5)
	  s MKBTBSource=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),6)
	  s MKBTBPYCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),7)
	  s MKBTBNote=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),8)
  	  s MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),9)
  	  s:MKBTBCatDr="" MKBTDesc=""
  	  s:MKBTBCatDr'="" MKBTDesc=..GetCatText(MKBTBCatDr)
  	  s MKBTBFlag=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),10)
  	  s MKBTBSequence=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),11)
  	  s MKBTBCodeRules=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),12)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTBDesc)  
	  if (($ZCONVERT(MKBTBDesc,"U")[desc)||(PINYIN[desc)||(MKBTBPYCode[desc))&((MKBTBType=type)||(type="")) {
	  	d OutputRow
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBTBRowId,MKBTBCode,MKBTBDesc,MKBTBType,MKBTBVersion,MKBTBSource,MKBTBPYCode,MKBTBNote,MKBTBCatDr,MKBTDesc,MKBTBFlag,MKBTBSequence,MKBTBCodeRules)
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
/// CreatDate: 2018-03-27
/// Description：查询 知识库字段映射数据，过滤不由知识库注册自动生成的菜单
/// Table：User.MKBTermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermBase","GetDataForCmb1","","","","功能")
Query GetDataForCmb1(rowid As %String, desc As %String, type As %String, q As %String) As %Query(ROWSPEC = "MKBTBRowId:%String,MKBTBDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, type As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s MKBTBRowId=rowid
  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s MKBTBRowId=""
  for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId),-1) q:MKBTBRowId=""  
	  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	  //continue:(MKBTBDesc="诊断_ICD相关业务")
	  s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),4)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTBDesc)  
	  if (($ZCONVERT(MKBTBDesc,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(MKBTBDesc,"U")[q)||(PINYIN[q)))&((MKBTBType=type)||(type="")) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBTBRowId,MKBTBDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据重复验证方法
/// Table：User.MKBTermBase
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).Validate("42","SY000018","功能_测试")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^User.MKBTermBaseI("CodeIndex"," "_code))
	s:desc'="" flagd=$d(^User.MKBTermBaseI("DescIndex"," "_desc))
	
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^User.MKBTermBaseI("CodeIndex"," "_code,0))
  		s:desc'="" idd=$o(^User.MKBTermBaseI("DescIndex"," "_desc,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
		/*if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}*/
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2019-03-06
/// Description：编码规则校验
/// Table：User.MKBTermBase
/// Input：id, CodeRules
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).ValidateCodeRules("42","SY000018","功能_测试")
ClassMethod ValidateCodeRules(id As %String, CodeRules As %String) As %String
{
	s:CodeRules'="" CodeRules=$ZCONVERT(CodeRules,"U") //转换成大写
	s flag="",flagc=""
	s:CodeRules'="" flagc=$d(^User.MKBTermBaseI("CodeRulesIndex"," "_CodeRules))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:CodeRules'="" idc=$o(^User.MKBTermBaseI("CodeRulesIndex"," "_CodeRules,0))
		if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据重复验证方法
/// Table：User.MKBTermBase
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.MKB.MKBTermBase).ValidateFlag("","Drug")
ClassMethod ValidateFlag(id As %String, code As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^User.MKBTermBaseI("FlagIndex"," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^User.MKBTermBaseI("FlagIndex"," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据保存方法
/// Table：User.MKBTermBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBTermBase).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBTermBase) As %String
{
  s result=""
  if $IsObject(eobj)
  { 
  	s:eobj.MKBTBSequence="" eobj.MKBTBSequence=..GetLastSequence()+1
    s flag=..Validate(eobj.MKBTBRowId,eobj.MKBTBCode,eobj.MKBTBDesc)  
    s flag1=..ValidateCodeRules(eobj.MKBTBRowId,eobj.MKBTBCodeRules)   
    if ((flag=1)||(flag1=1))
    {
      if (flag=1)
      {
      	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
      	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库注册","web.DHCBL.MKB.MKBTermBase","SaveEntity",eobj)
      	s ^ERRORLOGINFO(logid)="该记录已经存在！"
      }
      else
      {
	    s result = "{success:'false',errorinfo:'该编码规则已经存在！'}"
      	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库注册","web.DHCBL.MKB.MKBTermBase","SaveEntity",eobj)
      	s ^ERRORLOGINFO(logid)="该编码规则已经存在！"  
	  }
    }
    else
    {
	   if (eobj.MKBTBRowId="")  //如果RowId未赋值则增加
	   { 
	     s obj=##class(User.MKBTermBase).%New()
	   }
	   else   //如果RowId已赋值则修改
	   {
	     s obj=##class(User.MKBTermBase).%OpenId(eobj.MKBTBRowId)
	     s bobj=##class(web.Entity.MKB.MKBTermBase).%New()
	     s bobj.MKBTBRowId=eobj.MKBTBRowId 
	     s bobj.MKBTBCode = obj.MKBTBCode                      
	     s bobj.MKBTBDesc = obj.MKBTBDesc                      
	     s bobj.MKBTBType = obj.MKBTBType   
	     s bobj.MKBTBVersion = obj.MKBTBVersion                  
	     s bobj.MKBTBSource = obj.MKBTBSource
	     s bobj.MKBTBPYCode= obj.MKBTBPYCode                  
	     s bobj.MKBTBNote=obj.MKBTBNote
	     s bobj.MKBTBCatDr=obj.MKBTBCatDr
	     s bobj.MKBTBFlag=obj.MKBTBFlag
	     s bobj.MKBTBSequence=obj.MKBTBSequence
	     s bobj.MKBTBCodeRules=obj.MKBTBCodeRules
	   }
	   s obj.MKBTBCode = eobj.MKBTBCode                      
	   s obj.MKBTBDesc = eobj.MKBTBDesc                    
	   s obj.MKBTBType = eobj.MKBTBType 
	   s obj.MKBTBVersion = eobj.MKBTBVersion       
	   s obj.MKBTBSource = eobj.MKBTBSource  
	   s obj.MKBTBPYCode= eobj.MKBTBPYCode                 
	   s obj.MKBTBNote=eobj.MKBTBNote 
	   s obj.MKBTBCatDr=eobj.MKBTBCatDr   
	   s obj.MKBTBFlag=eobj.MKBTBFlag  
	   s obj.MKBTBSequence=eobj.MKBTBSequence
	   s obj.MKBTBCodeRules=eobj.MKBTBCodeRules

	   Ts
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc)
	   {
	     Tc
	     s id = obj.%Id()
	     
	     
	     if (eobj.MKBTBRowId=""){
			 
		 	//新增菜单
	   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
	   		s menuobj.Code = "dhc.bdp.mkb.mtm."_eobj.MKBTBCode           
   			s menuobj.Caption = eobj.MKBTBDesc   
   			s menuobj.LinkFuntionDR=""   
   			if (eobj.MKBTBDesc="诊断_ICD相关业务"){
	   			s menuobj.LinkUrl = "dhc.bdp.mkb.mkbicdrelation.csp" 
	   		}else{
		   		s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp" 
		   	}     
   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
   			s menuobj.ParentMenuDr=ParentMenuDr
   			s menuobj.Sequence = eobj.MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
   			s menuobj.ValueExpression="&base="_id
   			s menuobj.actMenuBDP="1"
   			s menuobj.actMenuAutItem="1"
   			s menuobj.actMenuAutData="1"
   			s menuobj.IsMKBMenu="Y"
   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,eobj.MKBTBImage)
   			if (resultMenu'["true"){
	   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
	   		}
	   		
	   		//新增别名属性-名称:别名，标识:常用名别名，格式:列表
	   		s propertyobj=##class(web.Entity.MKB.MKBTermBaseProperty).%New()
	   		s propertyobj.MKBTBPCode = "别名"
			s propertyobj.MKBTBPDesc = "别名"
			s propertyobj.MKBTBPType = "L"
			s propertyobj.MKBTBPBaseDr=id
			s propertyobj.MKBTBPFlag="AL"
			s propertyobj.MKBTBPSequence="1"
			s resultProperty=##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveEntity(propertyobj,"")
	   		if (resultProperty'["true"){
		   		s result = "{success:'false',errorinfo:'属性别名插入失败！'}"
		   	}else{
			   	s propertyid=$e(resultProperty,21,*-2)	
				s resultExtendPro= ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveAll(propertyid,"别名^TX^^^main*备注^TA^^^*检索码^TX^^^","A")  
				if (resultExtendPro'["true"){
					s result = "{success:'false',errorinfo:'扩展属性别名展示名插入失败！'}"
				}	
			}
	   		
		 }else{
			 //当修改注册数据，但是没有菜单时
			 s menuID= $o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(bobj.MKBTBCode,"U"),0))
			 if (menuID="")
			 {
				//新增菜单
		   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
		   		s menuobj.Code = "dhc.bdp.mkb.mtm."_eobj.MKBTBCode           
	   			s menuobj.Caption = eobj.MKBTBDesc   
	   			s menuobj.LinkFuntionDR=""   
	   			if (eobj.MKBTBDesc="诊断_ICD相关业务"){
		   			s menuobj.LinkUrl = "dhc.bdp.mkb.mkbicdrelation.csp" 
		   		}else{
			   		s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp" 
			   	}     
	   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
	   			s menuobj.ParentMenuDr=ParentMenuDr
	   			s menuobj.Sequence = eobj.MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
	   			s menuobj.ValueExpression="&base="_id
	   			s menuobj.actMenuBDP="1"
	   			s menuobj.actMenuAutItem="1"
	   			s menuobj.actMenuAutData="1"
	   			s menuobj.IsMKBMenu="Y"
	   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,eobj.MKBTBImage)
	   			if (resultMenu'["true"){
		   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
		   		}
		   		
		   		//新增别名属性-名称:别名，标识:常用名别名，格式:列表
		   		s propertyobj=##class(web.Entity.MKB.MKBTermBaseProperty).%New()
		   		s propertyobj.MKBTBPCode = "别名"
				s propertyobj.MKBTBPDesc = "别名"
				s propertyobj.MKBTBPType = "L"
				s propertyobj.MKBTBPBaseDr=id
				s propertyobj.MKBTBPFlag="AL"
				s propertyobj.MKBTBPSequence="1"
				s resultProperty=##class(web.DHCBL.MKB.MKBTermBaseProperty).SaveEntity(propertyobj,"")
		   		if (resultProperty'["true"){
			   		s result = "{success:'false',errorinfo:'属性别名插入失败！'}"
			   	}else{
				   	s propertyid=$e(resultProperty,21,*-2)	
					s resultExtendPro= ##class(web.DHCBL.MKB.MKBTermBaseExtendPro).SaveAll(propertyid,"别名^TX^^^main*备注^TA^^^*检索码^TX^^^","A")  
					if (resultExtendPro'["true"){
						s result = "{success:'false',errorinfo:'扩展属性别名展示名插入失败！'}"
					}	
				} 
			}
			else
			{
				 //修改菜单
		   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
		   		s menuobj.ID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(bobj.MKBTBCode,"U"),0))
		   		s menuobj.Code = "dhc.bdp.mkb.mtm."_eobj.MKBTBCode           
	   			s menuobj.Caption = eobj.MKBTBDesc   
	   			if (eobj.MKBTBDesc="诊断_ICD相关业务"){
		   			s menuobj.LinkUrl = "dhc.bdp.mkb.mkbicdrelation.csp" 
		   		}else{
			   		s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp" 
			   	}     
	   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
	   			s menuobj.ParentMenuDr=ParentMenuDr
	   			s menuobj.Sequence = eobj.MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)-1
	   			s menuobj.ValueExpression="&base="_id
	   			s menuobj.actMenuBDP=$p($LISTGET($G(^User.BDPMenuD(menuobj.ID)),16),"^",1)  //"1"
	   			s menuobj.actMenuAutItem="1"
	   			s menuobj.actMenuAutData="1"   
	   			s menuobj.IsMKBMenu="Y"     
	   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,eobj.MKBTBImage)
	   	
	   			if (resultMenu'["true"){
		   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
		   		}
			}
		 }
		 //维护到引用表
	     if (eobj.MKBTBRowId'=""){
			 if (bobj.MKBTBCatDr'=""){
				 s resultReference=""
				 s catlen=$Length(bobj.MKBTBCatDr,"&%")
				 for i=1:1:catlen
				 {
					s catid=$p(bobj.MKBTBCatDr,"&%",i)
					s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("B", id, "T", catid)
					s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "B", id, "T", "")	 
				 	if (resultRef["error"){
					 	s resultReference=resultReference_"^"_0
					}
				 }
				 if (resultReference[0){
					 s result = "{success:'false',errorinfo:'引用表删除失败'}"
				 }
			 }
		 }
		 if (obj.MKBTBCatDr'=""){
			 s resultReference=""
			 s catlen=$Length(obj.MKBTBCatDr,"&%")
			 for i=1:1:catlen
			 {
				s catid=$p(obj.MKBTBCatDr,"&%",i)
				s refRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("B", id, "T", catid)
				s resultRef=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "B", id, "T", catid)	 
			 	if (resultRef["error"){
				 	s resultReference=resultReference_"^"_0
				}
			 }
			 if (resultReference[0){
				 s result = "{success:'false',errorinfo:'引用表保存失败'}"
			 }
		 }
	    
		 //保存日志
		 d:eobj.MKBTBRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBase","User.MKBTermBase","知识库注册",id,eobj.MKBTBDesc,"A",eobj)
		 d:eobj.MKBTBRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBase","User.MKBTermBase","知识库注册",eobj.MKBTBRowId,eobj.MKBTBDesc,"U",eobj,bobj)
		 s result = "{success:'true',id:'"_id_"'}"    
	   }
	   else
	   {
	      Trollback
	      s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库注册","web.DHCBL.MKB.MKBTermBase","SaveEntity",eobj)
	      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
	   }
  	}
  }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库注册","web.DHCBL.MKB.MKBTermBase","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"   
 } 
  q result
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据打开方法
/// Table：User.MKBTermBase
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).OpenData("53")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.MKB.MKBTermBase).%New()
	s pobj = ##class(User.MKBTermBase).%OpenId(RowId)
	s eobj.MKBTBRowId = RowId
	s eobj.MKBTBCode = pobj.MKBTBCode
	s eobj.MKBTBDesc = pobj.MKBTBDesc
	s eobj.MKBTBType = pobj.MKBTBType
	s eobj.MKBTBVersion = pobj.MKBTBVersion
	s eobj.MKBTBSource = pobj.MKBTBSource
	s eobj.MKBTBPYCode = pobj.MKBTBPYCode
	s eobj.MKBTBNote = pobj.MKBTBNote
	s eobj.MKBTBCatDr = pobj.MKBTBCatDr
	s eobj.MKBTDesc = ..GetCatText(pobj.MKBTBCatDr)
	s eobj.MKBTBFlag = pobj.MKBTBFlag
	s eobj.MKBTBSequence = pobj.MKBTBSequence
	s eobj.MKBTBCodeRules = pobj.MKBTBCodeRules

	d pobj.%Close()	
	k pobj	
	
	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:删除限制
/// Table：User.MKBTermBase
/// Input：RowId
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetRefFlag("37")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s MKBTBRowId="",flag=0
  	for{  
		s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
		s MKBTBPRowId=0
		for  
		{	s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId)) q:MKBTBPRowId="" 
			s MKBTBPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),6)
			if (MKBTBPConfig=id){
				s flag=1
				s myInfo=myInfo_"<知识库属性>"
			}
			s MKBTBEPChildsub=0
			for 
			{
				S MKBTBEPChildsub=$o(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
				s MKBTBEPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),4)
				if (MKBTBEPConfig=id){
					s flag=1
					s myInfo=myInfo_"<知识库扩展属性>"
				}
			}
		}
  	}
 	s MKBTPRowId=0,flag1=0
	for  
	{	
		
		s MKBTPRowId=$o(^User.MKBTermPropertyD(MKBTPRowId)) q:MKBTPRowId="" 
		s MKBTPConfig=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		i MKBTPConfig=id
		{
			s flag1=1
			s myInfo=myInfo_"<知识库属性>"
		}
		s MKBTEPRowId=0
		for 
		{
			
			S MKBTEPRowId=$o(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPRowId)) q:MKBTEPRowId=""	
			s MKBTEPConfig=$listGet($g(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPRowId)),4)
			i MKBTEPConfig=id
			{
				s myInfo=myInfo_"<知识库扩展属性>"
			}
		}
	}

	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:删除限制
/// Table：User.MKBTermBase
/// Input：RowId
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).DeleteData("37")
ClassMethod DeleteData(id) As %String
{
  	s result=""
	/*s re=##class(web.DHCBL.MKB.MKBTermBase).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){*/
	s re=##class(web.DHCBL.MKB.MKBReference).DeleteData("B",id)
	if (re'=""){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{
	  s eobj=##class(web.Entity.MKB.MKBTermBase).%New()

	  s eobj.MKBTBRowId=id
	  s eobj.MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(id)),2)
	  s eobj.MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(id)),3)
	  s eobj.MKBTBType=$LISTGET($G(^User.MKBTermBaseD(id)),4)
	  s eobj.MKBTBVersion=$LISTGET($G(^User.MKBTermBaseD(id)),5)
	  s eobj.MKBTBSource=$LISTGET($G(^User.MKBTermBaseD(id)),6)
	  s eobj.MKBTBPYCode=$LISTGET($G(^User.MKBTermBaseD(id)),7)
	  s eobj.MKBTBNote=$LISTGET($G(^User.MKBTermBaseD(id)),8)
	  s eobj.MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(id)),9)
	  s eobj.MKBTBFlag=$LISTGET($G(^User.MKBTermBaseD(id)),10)
	  s eobj.MKBTBSequence=$LISTGET($G(^User.MKBTermBaseD(id)),11)
	  s eobj.MKBTBCodeRules=$LISTGET($G(^User.MKBTermBaseD(id)),12)
	  
	  Tstart
	  	//知识库属性删除
		s resultBasePro=""
		s MKBTBPRowId=0
		for  
		{	
			s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",id,MKBTBPRowId)) q:MKBTBPRowId="" 
			s resultPro=##class(web.DHCBL.MKB.MKBTermBaseProperty).DeleteData(MKBTBPRowId)
			if (resultPro'["true"){
				s resultBasePro=resultPro_"0"
			}
		}
		if (resultBasePro["0"){
			s result = "{success:'false',info:'知识库属性删除失败！'}"
		}
		  
		s flagMenu=..GetMenuExist(eobj.MKBTBCode)
		if (flagMenu=1){
			//菜单中删除
			s menuID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(eobj.MKBTBCode,"U"),0))
			s resultMenu = ##class(web.DHCBL.BDP.BDPMenu).DeleteData(menuID)
			if (resultMenu'["true"){
				s result = "{success:'false',info:'菜单维护数据删除失败！'}"
			}
		}
		//同时删除知识数据
		s resultTrem = ##class(web.DHCBL.MKB.MKBTerm).DeleteAll(id)
		if (resultTrem'["true"){
			s result = "{success:'false',info:'知识数据删除失败！'}"
		}

	  s sc=##class(User.MKBTermBase).%DeleteId(id)
	  IF $$$ISOK(sc)&'(result["false") {

	   Tc
	   s result="{success:'true',info:'删除成功！'}"
	   //引用表删除
	   d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("B",id)
	   //保存日志
	   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermBase","User.MKBTermBase","知识库注册",id,eobj.MKBTBDesc,"D",eobj)
	   d eobj.%Close()
	  }
	  else 
	  {
	     Trollback
	     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库注册","web.DHCBL.MKB.MKBTermBase","DeleteData",eobj)
	     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
	  }
	}
 	q result
}

/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTermBase
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTermBase).GetChildOrderedIDStr("","")
ClassMethod GetChildOrderedIDStr(LastLevel As %String, base) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)=mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s childStr=..GetChildOrderedIDStr(myRowID,base)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
		
	
	q IDStr
}

/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Input：ParentID 父节点Id，base知识库注册ID 
/// Table：User.MKBTermBase
/// Return：Json格式
/// Description:获取树形分类数据(带勾选框)
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetCatJsonData("")
ClassMethod GetCatJsonData(ParentID As %String, base As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,ParentID,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,ParentID,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s count=count+1
		s Desc=$LISTGET($G(^User.MKBTermD(myRowID)),3)
		s Desc=$tr(Desc,"""","")
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_Desc_""""
		w ",""state"":""open"""
		s childStr=..GetChildOrderedIDStr(myRowID,base)
		if childStr'=""
		{
			w ",""children"":"
			w ..GetCatJsonData(myRowID,base)	
		}
		w "}"
		
	}
	w "]"
	q ""
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据分类的id串获取相应的描述信息
/// Table：User.MKBTermBase
/// Input：CatDr
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetCatText("10,12")
ClassMethod GetCatText(CatDr As %String) As %String
{
    s CatText=""
    if (CatDr'=""){
		s len=$Length(CatDr,"&%")
		for i=1:1:len{
			s catid=$p(CatDr,"&%",i)
			s cat=$listGet($g(^User.MKBTermD(catid)),3)
			if (CatText=""){
				s CatText=cat
			}else{
				s CatText=CatText_","_cat	
			}
		} 
	}
	q CatText
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据知识库code获取菜单Icon
/// Table：User.MKBTermBase
/// Input：code
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetIconByCode("SY000041")
ClassMethod GetIconByCode(code As %String) As %String
{
    s Image=""
    s id=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(code,"U"),0))
    s:id'="" Image=$LISTGET($G(^User.BDPMenuD(id)),6)
    if (Image'=""){
        s Image="../scripts/bdp/Framework/BdpIconsLib/"_Image
    }
    else
    {
        s Image="../scripts/bdp/Framework/BdpIconsLib/null.png"
    }
    q Image
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
	s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_code))
	if (flagc>0){
		s flag=1	
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:表字段为数据来源时，获取配置项的描述
/// Table：User.MKBTermBase
/// Input：RowId
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetDesc("Test")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBTermBase).GetDesc(12)
	s MKBTBDesc=""
	if (RowId'=""){
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(RowId)),3)
	}
	q MKBTBDesc
}

/// Creator：高姗姗
/// CreatDate: 2018-05-03
/// Description:根据id获取类型：列表或树形
/// Table：User.MKBTermBase
/// Input：RowId
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetType("1")
ClassMethod GetType(RowId As %String) As %String
{
	s MKBTBType=""
	if (RowId'=""){
		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(RowId)),4)
	}
	q MKBTBType
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据知识库名获取知识库id
/// Table：User.MKBTermBase
/// Input：RowId
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetDesc("Test")
ClassMethod GetIdByDesc(desc As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("诊断_ICD10国际码")
	s id=""
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:desc'="" id=$o(^User.MKBTermBaseI("DescIndex"," "_desc,0))
	q id
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据标识获取知识库id
/// Table：User.MKBTermBase
/// Input：flag
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
ClassMethod GetIdByFlag(flag As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	s id=""
	s:flag'="" flag=$ZCONVERT(flag,"U") //转换成大写
	s:flag'="" id=$o(^User.MKBTermBaseI("FlagIndex"," "_flag,0))
	q id
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据知识库名获取菜单id
/// Table：User.MKBTermBase
/// Input：desc
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetMenuId("Test")
ClassMethod GetMenuId(desc As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBTermBase).GetMenuId("诊断学_临床实用诊断")
	s menuid=""
	s id=..GetIdByDesc(desc)
	s:id'="" MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(id)),2) //知识库代码
	s:id="" MKBTBCode=""
	s:MKBTBCode'="" menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(MKBTBCode,"U"),0))
	q menuid
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:代码自动生成  SY000000 代码最大值加1
/// Table：User.MKBTermBase
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=8    //代码长度
  	s StartCode="SY"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s MKBTBRowId=0, preCode=""    //寻找符合规则的最大的代码
	for {
		s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		s MKBTBCode=$listget($g(^User.MKBTermBaseD(MKBTBRowId)),2)
		if ($e(MKBTBCode,1,StartCodeLen)=StartCode)
		{
			s preCode=MKBTBCode
		}
		
	}
	if (preCode="")   //如果没有符合规则的代码，则生成第一个
	{
		s zeroLen=CodeLen-StartCodeLen
		s zeroStr=""
		s count=0
		for
		{
			s count=count+1
			q:count>zeroLen
			s zeroStr=zeroStr_"0"
		}
		s preCode=StartCode_zeroStr
	}
	s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
	s CodeNumLen=$Length(CodeNum)     //数字的长度
	s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合

	q code
}

/// Creator:高姗姗
/// CreatDate:2018-3-27
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.DHCBL.MKB.MKBTermBase).GetLastSequence()
ClassMethod GetLastSequence() As %String
{
  	s LastSequence=0
	s Sequence=0
  	for{
	  s Sequence=$o(^User.MKBTermBaseI("SeqIndex",Sequence)) q:Sequence="" 
	  s LastSequence=Sequence
  	}
	q LastSequence
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:判断知识库分类是否存在，存在时知识库分类必填，不存在时知识库分类不必填
/// Table：User.MKBTermBase
/// Return: 1:必填，0:不必填
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetCatExist()
ClassMethod GetCatExist() As %String
{
	s flag=""
	s BaseDR=..GetIdByFlag("Cat") //分类知识库存在菜单
	if (BaseDR=""){
		s flag=0	
	}else{
		if ($d(^User.MKBTermI("BaseIndex",BaseDR))){ //分类知识库存在数据
			s flag=1
		}else{
			s flag=0
		}
	}
	q flag
}

/// 修复数据：同步菜单维护中的顺序到知识库顺序字段
/// w ##class(web.DHCBL.MKB.MKBTermBase).UpdateSequence()
ClassMethod UpdateSequence() As %String
{
	s MKBTBRowId=""
  	for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
	  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
	  s ID=##class(web.DHCBL.BDP.BDPMenuDefine).GetID("dhc.bdp.MKB.MTM."_MKBTBCode) //菜单id
	  s Sequence=$LISTGET($G(^User.BDPMenuD(ID)),8)
	  s $LIST(^User.MKBTermBaseD(MKBTBRowId),14)=Sequence
  	}
  	q 1
}

/// 修复数据：修复知识库注册中的知识库分类数据为新的分类知识库的id串值
/// w ##class(web.DHCBL.MKB.MKBTermBase).UpdateCat()
ClassMethod UpdateCat() As %String
{
	s MKBTBRowId=""
	s str=""
	s base=$o(^User.MKBTermBaseI("FlagIndex"," CAT",0))
  	for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
	  s MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),11)
	  s tremcat=""
	  s catLen=$Length(MKBTBCatDr,",")
	  for i=1:1:catLen
		{
			s catDr=$p(MKBTBCatDr,",",i)
			s TKBTBCCode = $listGet($g(^User.MKBTermBaseCatD(catDr)),2)
			s TKBTBCCode=$ZCONVERT(TKBTBCCode,"U") //转换成大写
			s tremid=$o(^TKBTREMi(0,"Code",base,TKBTBCCode,0))
			if (tremcat=""){
				s tremcat=tremid
			}else{
				s tremcat=tremcat_","_tremid
			}
		}
		if (str=""){
			s str=MKBTBRowId_":"_tremcat
		}else{
			s str=str_"*"_MKBTBRowId_":"_tremcat
		}
		
  	}
  	s len=$Length(str,"*")
	for i=1:1:len
	{
		s trem=$p(str,"*",i)
		s id=$p(trem,":",1)
		s cat=$p(trem,":",2)
		s $LIST(^User.MKBTermBaseD(id),11)=cat
	}
  	q 1
}

/// d ##class(web.DHCBL.MKB.MKBTermBase).CreateMenu()
ClassMethod CreateMenu() As %String
{
	s MKBTBRowId=""
	  for{  
		  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) 
		  q:MKBTBRowId=""  
		  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
		  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	  	  s MKBTBSequence=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),11)
	  	  
	  	    s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
	   		s menuobj.Code = "dhc.bdp.mkb.mtm."_MKBTBCode           
   			s menuobj.Caption = MKBTBDesc   
   			s menuobj.LinkFuntionDR=""   
   			if (MKBTBDesc="诊断_ICD相关业务"){
	   			s menuobj.LinkUrl = "dhc.bdp.mkb.mkbicdrelation.csp" 
	   		}else{
		   		s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp" 
		   	}     
   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
   			s menuobj.ParentMenuDr=ParentMenuDr
   			s menuobj.Sequence = MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
   			s menuobj.ValueExpression="&base="_MKBTBRowId
   			s menuobj.actMenuBDP="1"
   			s menuobj.actMenuAutItem="1"
   			s menuobj.actMenuAutData="1"
   			s menuobj.IsMKBMenu="Y"
   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
	   }
}

/// Creator：高姗姗
/// CreatDate: 2018-08-13
/// Description:判断菜单是否由知识库注册或规则注册生成，自动生成菜单不允许修改代码
/// Input： menuid 菜单id
/// Return: 1:是，0:否
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).IsMKBBaseCreate("1510")
ClassMethod IsMKBBaseCreate(menuid) As %String
{
	;##class(web.DHCBL.MKB.MKBTermBase).IsMKBBaseCreate(menuid)
	s result=0
	s Code=$LISTGET($G(^User.BDPMenuD(menuid)),2)
	if (Code["dhc.bdp.mkb.mtm"){
		if (Code="dhc.bdp.mkb.mtm"){ //术语管理菜单代码不允许修改
			s result=1	
		}else{ //术语管理子菜单代码不允许修改
			s CodeU=$ZCONVERT($p(Code,"dhc.bdp.mkb.mtm.",2),"U")
			if ($d(^User.MKBTermBaseI("CodeIndex"," "_CodeU))){
				s result=1
			}
		}
	}
	if (Code["dhc.bdp.mkb.klm"){
		if (Code="dhc.bdp.mkb.klm"){ //规则管理菜单代码不允许修改
			s result=1	
		}else{ //规则管理子菜单代码不允许修改
			s CodeU=$ZCONVERT($p(Code,"dhc.bdp.mkb.klm.",2),"U")
			if ($d(^User.MKBKLMappingBaseI("CodeIndex"," "_CodeU))){
				s result=1
			}
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2018-08-13
/// Description:术语管理下的菜单修改描述及顺序时，同步知识库及规则
/// Input：菜单code，菜单描述，菜单顺序
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).SyncMKBBase("dhc.bdp.mkb.mtm.SY000011","功能_术语分类","32")
ClassMethod SyncMKBBase(menuCode, menuCaption, menuSequence) As %String
{
	 ;##class(web.DHCBL.MKB.MKBTermBase).SyncMKBBase("menuCode","menuCaption","menuSequence")
	 s resultSync=""
	 if (menuCode["dhc.bdp.mkb.mtm."){ //术语管理子菜单同步
		 s BaseCode=$p(menuCode,"dhc.bdp.mkb.mtm.",2)
		 s BaseCodeU=$ZCONVERT(BaseCode,"U") //转换成大写
		 if ($d(^User.MKBTermBaseI("CodeIndex"," "_BaseCodeU))){
		     s BaseId = $o(^User.MKBTermBaseI("CodeIndex"," "_BaseCodeU,0))
			 s flag=..Validate(BaseId,BaseCode,menuCaption)   
		     if (flag=1)
		     {
		      	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		     }else{
				 
				 s obj=##class(User.MKBTermBase).%OpenId(BaseId)                  
			     s obj.MKBTBDesc = menuCaption                     
			     s obj.MKBTBSequence=menuSequence
			     
			     s sc=obj.%Save()
			     d obj.%Close()
			     If $$$ISOK(sc)
			     {
			     	s id = obj.%Id()
			     	s resultSync = "{success:'true',id:'"_id_"'}" 
			     }
			 	 else{
				 	 s resultSync = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
				 }
		     }
		 }
     }
      if (menuCode["dhc.bdp.mkb.klm."){ //规则管理子菜单同步
		 s BaseCode=$p(menuCode,"dhc.bdp.mkb.klm.",2)
		 s BaseCodeU=$ZCONVERT(BaseCode,"U") //转换成大写
		 if ($d(^User.MKBKLMappingBaseI("CodeIndex"," "_BaseCodeU))){
		     s BaseId = $o(^User.MKBKLMappingBaseI("CodeIndex"," "_BaseCodeU,0))
			 s flag=##class(web.DHCBL.MKB.MKBKLMappingBase).Validate(BaseId,menuCaption)   
		     if (flag=1)
		     {
		      	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		     }else{
				 
				 s obj=##class(User.MKBKLMappingBase).%OpenId(BaseId)                  
			     s obj.MKBKMBDesc = menuCaption                     
			     s obj.MKBKMBSequence=menuSequence
			     
			     s sc=obj.%Save()
			     d obj.%Close()
			     If $$$ISOK(sc)
			     {
			     	s id = obj.%Id()
			     	s resultSync = "{success:'true',id:'"_id_"'}" 
			     }
			 	 else{
				 	 s resultSync = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
				 }
		     }
		 }
     }
     q resultSync
}

/// d ##class(web.DHCBL.MKB.MKBTermBase).TestSave()
ClassMethod TestSave() As %String
{
	s eobj = ##class(web.Entity.MKB.MKBTermBase).%New()
	s eobj.MKBTBRowId = "43"
	s eobj.MKBTBCode = "w00023"
	d ..SaveEntity(eobj)
}

/// Creator：丁亚男
/// CreatDate: 2019-03-06
/// Description:判断编码规则是否可以修改
/// Input： basedr
/// Return: 1存在内容，不可修改,0可以修改
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).IsMKBBaseCreate("1510")
ClassMethod IsCodeRulesChange(basedr) As %String
{
	s flag=0
	if ($d(^User.MKBTermI("BaseIndex",basedr))) s flag=1
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2019-03-27
/// Description:根据标识获取知识库id
/// Table：User.MKBTermBase
/// Input：flag
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetFlagById()
ClassMethod GetFlagById(id As %String) As %String
{
	s MKBTBFlag=""
	if (id'=""){
		s MKBTBFlag=$LISTGET($G(^User.MKBTermBaseD(id)),10)
	}
	q MKBTBFlag
}

/// Creator：丁亚男
/// CreatDate: 2019-10-28
/// Description:根据知识库id获取分类描述
/// Table：User.MKBTermBase
/// Input：分类描述
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetCatDescById(87)
ClassMethod GetCatDescById(id As %String) As %String
{
	s CatDesc=""
	if (id'=""){
		s MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(id)),9)
 		s:MKBTBCatDr'="" CatDesc=..GetCatText(MKBTBCatDr)
	}
	q CatDesc
}

}
