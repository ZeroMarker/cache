/// Creator:高姗姗
/// CreatDate:2021-09-03
/// Description：CDSS知识库注册类
/// Table：CT.WDT.CDSS.TermBase
Class web.CDSS.CMKB.TermBase Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：查询知识库表内容
/// Table：CT.WDT.CDSS.TermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermBase","GetList","","","")
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
  s MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),2)
  s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),3)
  s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),4)
  s MKBTBVersion=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),5)
  s MKBTBSource=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),6)
  s MKBTBPYCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),7)
  s MKBTBNote=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),8)
  s MKBTBCatDr=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),9)
  s:MKBTBCatDr="" MKBTDesc=""
  s:MKBTBCatDr'="" MKBTDesc=..GetCatText(MKBTBCatDr)
  s MKBTBFlag=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),10)
  s MKBTBSequence=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),11)
  s MKBTBCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),12)
  d OutputRow
 }
 else
 {
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:desc'="" desc=$tr(desc," ","") //过滤空格

  s MKBTBRowId=""
  for{  
	  s MKBTBRowId=$o(^CT.WDT.CDSS.TermBaseD(MKBTBRowId),-1) 
	  q:MKBTBRowId=""  
	  //continue:MKBTBRowId=5
	  s MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),2)
	  s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),3)
	  s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),4)
	  s MKBTBVersion=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),5)
	  s MKBTBSource=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),6)
	  s MKBTBPYCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),7)
	  s MKBTBNote=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),8)
  	  s MKBTBCatDr=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),9)
  	  s:MKBTBCatDr="" MKBTDesc=""
  	  s:MKBTBCatDr'="" MKBTDesc=..GetCatText(MKBTBCatDr)
  	  s MKBTBFlag=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),10)
  	  s MKBTBSequence=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),11)
  	  s MKBTBCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),12)
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
/// Description：查询 知识库字段映射数据，过滤不由CDSS知识库注册自动生成的菜单
/// Table：CT.WDT.CDSS.TermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermBase","GetDataForCmb1","","","","功能")
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
  s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s MKBTBRowId=""
  for{  
	  s MKBTBRowId=$o(^CT.WDT.CDSS.TermBaseD(MKBTBRowId),-1) q:MKBTBRowId=""  
	  s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),3)
	  //continue:(MKBTBDesc="诊断_ICD相关业务")
	  s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),4)
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.CDSS.CMKB.TermBase).Validate("42","SY000018","功能_测试")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TermBaseI("CodeIndex"," "_code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_desc))
	
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermBaseI("CodeIndex"," "_code,0))
  		s:desc'="" idd=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_desc,0))
  		
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：id, CodeRules
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.CDSS.CMKB.TermBase).ValidateCodeRules("42","SY000018","功能_测试")
ClassMethod ValidateCodeRules(id As %String, CodeRules As %String) As %String
{
	s:CodeRules'="" CodeRules=$ZCONVERT(CodeRules,"U") //转换成大写
	s flag="",flagc=""
	s:CodeRules'="" flagc=$d(^CT.WDT.CDSS.TermBaseI("CodeRulesIndex"," "_CodeRules))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:CodeRules'="" idc=$o(^CT.WDT.CDSS.TermBaseI("CodeRulesIndex"," "_CodeRules,0))
		if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.TermBase
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.TermBase).ValidateFlag("","Drug")
ClassMethod ValidateFlag(id As %String, code As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.TermBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TermBase).SaveEntity()
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TermBase) As %String
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
      	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库注册","web.CDSS.CMKB.TermBase","SaveEntity",eobj)
      	s ^ERRORLOGINFO(logid)="该记录已经存在！"
      }
      else
      {
	    s result = "{success:'false',errorinfo:'该编码规则已经存在！'}"
      	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库注册","web.CDSS.CMKB.TermBase","SaveEntity",eobj)
      	s ^ERRORLOGINFO(logid)="该编码规则已经存在！"  
	  }
    }
    else
    {
	   if (eobj.MKBTBRowId="")  //如果RowId未赋值则增加
	   { 
	     s obj=##class(CT.WDT.CDSS.TermBase).%New()
	   }
	   else   //如果RowId已赋值则修改
	   {
	     s obj=##class(CT.WDT.CDSS.TermBase).%OpenId(eobj.MKBTBRowId)
	     s bobj=##class(web.CDSSEntity.CMKB.TermBase).%New()
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
	   		s menuobj=##class(web.Entity.MKB.Menu).%New()
	   		s menuobj.Code = "dhc.bdp.cdssV2.cmkb.mtm."_eobj.MKBTBCode           
   			s menuobj.Caption = eobj.MKBTBDesc   
   			s menuobj.LinkFuntionDR=""   
		   	s menuobj.LinkUrl = "dhc.bdp.cdss.cmkb.listterm.csp" 
   			s ParentMenuDr=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.ENCYCLOPEDIAS",0))
   			s menuobj.ParentMenuDr=ParentMenuDr
   			s menuobj.Sequence = eobj.MKBTBSequence 
   			s menuobj.ValueExpression="&base="_id
   			s menuobj.actMenuBDP="1"
   			s menuobj.actMenuAutItem="1"
   			s menuobj.actMenuAutData="1"
   			s menuobj.IsMKBMenu="Y"
   			s resultMenu=##class(web.DHCBL.MKB.Menu).SaveEntity(menuobj,eobj.MKBTBImage)
   			if (resultMenu'["true"){
	   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
	   		}
	   		
	   		//新增别名属性-名称:别名，标识:常用名别名，格式:列表
	   		s propertyobj=##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
	   		s propertyobj.MKBTBPCode = "别名"
			s propertyobj.MKBTBPDesc = "别名"
			s propertyobj.MKBTBPType = "L"
			s propertyobj.MKBTBPBaseDr=id
			s propertyobj.MKBTBPFlag="AL"
			s propertyobj.MKBTBPSequence="1"
			s resultProperty=##class(web.CDSS.CMKB.TermBaseProperty).SaveEntity(propertyobj,"")
	   		if (resultProperty'["true"){
		   		s result = "{success:'false',errorinfo:'属性别名插入失败！'}"
		   	}else{
			   	s propertyid=$e(resultProperty,21,*-2)	
				s resultExtendPro= ##class(web.CDSS.CMKB.TermBaseExtendPro).SaveAll(propertyid,"别名^TX^^^main*备注^TA^^^*检索码^TX^^^","A")  
				if (resultExtendPro'["true"){
					s result = "{success:'false',errorinfo:'扩展属性别名展示名插入失败！'}"
				}	
			}
	   		
		 }else{
			 //当修改注册数据，但是没有菜单时
			 s menuID= $o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_$ZCONVERT(bobj.MKBTBCode,"U"),0))
			 if (menuID="")
			 {
				//新增菜单
		   		s menuobj=##class(web.Entity.MKB.Menu).%New()
		   		s menuobj.Code = "dhc.bdp.cdssV2.cmkb.mtm."_eobj.MKBTBCode           
	   			s menuobj.Caption = eobj.MKBTBDesc   
	   			s menuobj.LinkFuntionDR=""   
			   	s menuobj.LinkUrl = "dhc.bdp.cdss.cmkb.listterm.csp"    
	   			s ParentMenuDr=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.ENCYCLOPEDIAS",0))
	   			s menuobj.ParentMenuDr=ParentMenuDr
	   			s menuobj.Sequence = eobj.MKBTBSequence 
	   			s menuobj.ValueExpression="&base="_id
	   			s menuobj.actMenuBDP="1"
	   			s menuobj.actMenuAutItem="1"
	   			s menuobj.actMenuAutData="1"
	   			s menuobj.IsMKBMenu="Y"
	   			s resultMenu=##class(web.DHCBL.MKB.Menu).SaveEntity(menuobj,eobj.MKBTBImage)
	   			if (resultMenu'["true"){
		   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
		   		}
		   		
		   		//新增别名属性-名称:别名，标识:常用名别名，格式:列表
		   		s propertyobj=##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
		   		s propertyobj.MKBTBPCode = "别名"
				s propertyobj.MKBTBPDesc = "别名"
				s propertyobj.MKBTBPType = "L"
				s propertyobj.MKBTBPBaseDr=id
				s propertyobj.MKBTBPFlag="AL"
				s propertyobj.MKBTBPSequence="1"
				s resultProperty=##class(web.CDSS.CMKB.TermBaseProperty).SaveEntity(propertyobj,"")
		   		if (resultProperty'["true"){
			   		s result = "{success:'false',errorinfo:'属性别名插入失败！'}"
			   	}else{
				   	s propertyid=$e(resultProperty,21,*-2)	
					s resultExtendPro= ##class(web.CDSS.CMKB.TermBaseExtendPro).SaveAll(propertyid,"别名^TX^^^main*备注^TA^^^*检索码^TX^^^","A")  
					if (resultExtendPro'["true"){
						s result = "{success:'false',errorinfo:'扩展属性别名展示名插入失败！'}"
					}	
				} 
			}
			else
			{
				 //修改菜单
		   		s menuobj=##class(web.Entity.MKB.Menu).%New()
		   		s menuobj.ID=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_$ZCONVERT(bobj.MKBTBCode,"U"),0))
		   		s menuobj.Code = "dhc.bdp.cdssV2.cmkb.mtm."_eobj.MKBTBCode           
	   			s menuobj.Caption = eobj.MKBTBDesc   
			   	s menuobj.LinkUrl = "dhc.bdp.cdss.cmkb.listterm.csp"  
	   			s ParentMenuDr=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.ENCYCLOPEDIAS",0))
	   			s menuobj.ParentMenuDr=ParentMenuDr
	   			s menuobj.Sequence = eobj.MKBTBSequence 
	   			s menuobj.ValueExpression="&base="_id
	   			s menuobj.actMenuBDP=$p($LISTGET($G(^CT.WDT.MKB.MenuD(menuobj.ID)),16),"^",1)  //"1"
	   			s menuobj.actMenuAutItem="1"
	   			s menuobj.actMenuAutData="1"   
	   			s menuobj.IsMKBMenu="Y"     
	   			s resultMenu=##class(web.DHCBL.MKB.Menu).SaveEntity(menuobj,eobj.MKBTBImage)
	   	
	   			if (resultMenu'["true"){
		   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
		   		}
			}
		 }
		
		 //保存日志
		 d:eobj.MKBTBRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermBase","CT.WDT.CDSS.TermBase","CDSS知识库注册",id,eobj.MKBTBDesc,"A",eobj)
		 d:eobj.MKBTBRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermBase","CT.WDT.CDSS.TermBase","CDSS知识库注册",eobj.MKBTBRowId,eobj.MKBTBDesc,"U",eobj,bobj)
		 s result = "{success:'true',id:'"_id_"'}"    
	   }
	   else
	   {
	      Trollback
	      s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	      s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库注册","web.CDSS.CMKB.TermBase","SaveEntity",eobj)
	      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
	   }
  	}
  }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库注册","web.CDSS.CMKB.TermBase","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"   
 } 
  q result
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.TermBase).OpenData("53")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TermBase).%New()
	s pobj = ##class(CT.WDT.CDSS.TermBase).%OpenId(RowId)
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetRefFlag("37")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s MKBTBRowId="",flag=0
  	for{  
		s MKBTBRowId=$o(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)) q:MKBTBRowId=""  
		s MKBTBPRowId=0
		for  
		{	s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId)) q:MKBTBPRowId="" 
			s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),6)
			if (MKBTBPConfig=id){
				s flag=1
				s myInfo=myInfo_"<知识库属性>"
			}
			s MKBTBEPChildsub=0
			for 
			{
				S MKBTBEPChildsub=$o(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
				s MKBTBEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),4)
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
		
		s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)) q:MKBTPRowId="" 
		s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
		i MKBTPConfig=id
		{
			s flag1=1
			s myInfo=myInfo_"<知识属性>"
		}
		s MKBTEPRowId=0
		for 
		{
			
			S MKBTEPRowId=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPRowId)) q:MKBTEPRowId=""	
			s MKBTEPConfig=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPRowId)),4)
			i MKBTEPConfig=id
			{
				s myInfo=myInfo_"<知识扩展属性>"
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.CDSS.CMKB.TermBase).DeleteData("37")
ClassMethod DeleteData(id) As %String
{
  	s result=""
	s re=##class(web.CDSS.CMKB.TermBase).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{
	  s eobj=##class(web.CDSSEntity.CMKB.TermBase).%New()

	  s eobj.MKBTBRowId=id
	  s eobj.MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),2)
	  s eobj.MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),3)
	  s eobj.MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),4)
	  s eobj.MKBTBVersion=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),5)
	  s eobj.MKBTBSource=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),6)
	  s eobj.MKBTBPYCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),7)
	  s eobj.MKBTBNote=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),8)
	  s eobj.MKBTBCatDr=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),9)
	  s eobj.MKBTBFlag=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),10)
	  s eobj.MKBTBSequence=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),11)
	  s eobj.MKBTBCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),12)
	  
	  Tstart
	  	//知识库属性删除
		s resultBasePro=""
		s MKBTBPRowId=0
		for  
		{	
			s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",id,MKBTBPRowId)) q:MKBTBPRowId="" 
			s resultPro=##class(web.CDSS.CMKB.TermBaseProperty).DeleteData(MKBTBPRowId)
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
			s menuID=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_$ZCONVERT(eobj.MKBTBCode,"U"),0))
			s resultMenu = ##class(web.DHCBL.MKB.Menu).DeleteData(menuID)
			if (resultMenu'["true"){
				s result = "{success:'false',info:'菜单维护数据删除失败！'}"
			}
		}
		//同时删除知识数据
		s resultTrem = ##class(web.CDSS.CMKB.Term).DeleteAll(id)
		if (resultTrem'["true"){
			s result = "{success:'false',info:'知识数据删除失败！'}"
		}

	  s sc=##class(CT.WDT.CDSS.TermBase).%DeleteId(id)
	  IF $$$ISOK(sc)&'(result["false") {

	   Tc
	   s result="{success:'true',info:'删除成功！'}"

	   //保存日志
	   d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermBase","CT.WDT.CDSS.TermBase","CDSS知识库注册",id,eobj.MKBTBDesc,"D",eobj)
	   d eobj.%Close()
	  }
	  else 
	  {
	     Trollback
	     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	     s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库注册","web.CDSS.CMKB.TermBase","DeleteData",eobj)
	     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
	  }
	}
 	q result
}

/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.TermBase
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.TermBase).GetChildOrderedIDStr("","")
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
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
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
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
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
/// Input：ParentID 父节点Id，baseCDSS知识库注册ID 
/// Table：CT.WDT.CDSS.TermBase
/// Return：Json格式
/// Description:获取树形分类数据(带勾选框)
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetCatJsonData("")
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
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,ParentID,mySeq)) q:(mySeq="")
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
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,ParentID,mySeq,myRowID)) q:(myRowID="")
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
		s Desc=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：CatDr
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetCatText("10,12")
ClassMethod GetCatText(CatDr As %String) As %String
{
    s CatText=""
    if (CatDr'=""){
		s len=$Length(CatDr,"&%")
		for i=1:1:len{
			s catid=$p(CatDr,"&%",i)
			s cat=$listGet($g(^CT.WDT.CDSS.TermD(catid)),3)
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：code
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetIconByCode("SY000041")
ClassMethod GetIconByCode(code As %String) As %String
{
    s Image=""
    s id=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_$ZCONVERT(code,"U"),0))
    s:id'="" Image=$LISTGET($G(^CT.WDT.MKB.MenuD(id)),6)
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
/// Table：CT.WDT.CDSS.TermBase
/// Input：code
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetMenuExist("Test")
ClassMethod GetMenuExist(code As %String) As %String
{
	s flagc="",flag=""
	s:code'="" code=$ZCONVERT(code,"U")
	s:code'="" flagc=$d(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_code))
	if (flagc>0){
		s flag=1	
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:表字段为数据来源时，获取配置项的描述
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetDesc("Test")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBase).GetDesc(12)
	s MKBTBDesc=""
	if (RowId'=""){
		s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(RowId)),3)
	}
	q MKBTBDesc
}

/// Creator：高姗姗
/// CreatDate: 2018-05-03
/// Description:根据id获取类型：列表或树形
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetType("1")
ClassMethod GetType(RowId As %String) As %String
{
	s MKBTBType=""
	if (RowId'=""){
		s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(RowId)),4)
	}
	q MKBTBType
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据知识库名获取知识库id
/// Table：CT.WDT.CDSS.TermBase
/// Input：RowId
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetDesc("Test")
ClassMethod GetIdByDesc(desc As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBase).GetIdByDesc("诊断_ICD10国际码")
	s id=""
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:desc'="" id=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_desc,0))
	q id
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据标识获取知识库id
/// Table：CT.WDT.CDSS.TermBase
/// Input：flag
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetIdByFlag("Diagnose")
ClassMethod GetIdByFlag(flag As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBase).GetIdByFlag("Diagnose")
	s id=""
	s:flag'="" flag=$ZCONVERT(flag,"U") //转换成大写
	s:flag'="" id=$o(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_flag,0))
	q id
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:根据知识库名获取菜单id
/// Table：CT.WDT.CDSS.TermBase
/// Input：desc
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetMenuId("Test")
ClassMethod GetMenuId(desc As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBase).GetMenuId("诊断学_临床实用诊断")
	s menuid=""
	s id=..GetIdByDesc(desc)
	s:id'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),2) //知识库代码
	s:id="" MKBTBCode=""
	s:MKBTBCode'="" menuid=$o(^CT.WDT.MKB.MenuI("UniqueCodeIndex"," DHC.BDP.CDSSV2.CMKB.MTM."_$ZCONVERT(MKBTBCode,"U"),0))
	q menuid
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:代码自动生成  SY000000 代码最大值加1
/// Table：CT.WDT.CDSS.TermBase
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=8    //代码长度
  	s StartCode="SY"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s MKBTBRowId=0, preCode=""    //寻找符合规则的最大的代码
	for {
		s MKBTBRowId=$o(^CT.WDT.CDSS.TermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		s MKBTBCode=$listget($g(^CT.WDT.CDSS.TermBaseD(MKBTBRowId)),2)
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
/// Other:w ##class(web.CDSS.CMKB.TermBase).GetLastSequence()
ClassMethod GetLastSequence() As %String
{
  	s LastSequence=0
	s Sequence=0
  	for{
	  s Sequence=$o(^CT.WDT.CDSS.TermBaseI("SeqIndex",Sequence)) q:Sequence="" 
	  s LastSequence=Sequence
  	}
	q LastSequence
}

/// Creator：高姗姗
/// CreatDate: 2018-03-27
/// Description:判断知识库分类是否存在，存在时知识库分类必填，不存在时知识库分类不必填
/// Table：CT.WDT.CDSS.TermBase
/// Return: 1:必填，0:不必填
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetCatExist()
ClassMethod GetCatExist() As %String
{
	s flag=""
	s BaseDR=..GetIdByFlag("Cat") //分类知识库存在菜单
	if (BaseDR=""){
		s flag=0	
	}else{
		if ($d(^CT.WDT.CDSS.TermI("BaseIndex",BaseDR))){ //分类知识库存在数据
			s flag=1
		}else{
			s flag=0
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2018-08-13
/// Description:判断菜单是否由CDSS知识库注册生成，自动生成菜单不允许修改代码
/// Input： menuid 菜单id
/// Return: 1:是，0:否
/// Other: w ##class(web.CDSS.CMKB.TermBase).IsMKBBaseCreate("1510")
ClassMethod IsMKBBaseCreate(menuid) As %String
{
	;##class(web.CDSS.CMKB.TermBase).IsMKBBaseCreate(menuid)
	s result=0
	s Code=$LISTGET($G(^CT.WDT.MKB.MenuD(menuid)),2)
	if (Code="dhc.bdp.mkb.encyclopediamanage"){ //术语管理菜单代码不允许修改
		s result=1	
	}
	if (Code["dhc.bdp.cdssV2.cmkb.mtm"){
	    //术语管理子菜单代码不允许修改
		s CodeU=$ZCONVERT($p(Code,"dhc.bdp.cdssV2.cmkb.mtm.",2),"U")
		if ($d(^CT.WDT.CDSS.TermBaseI("CodeIndex"," "_CodeU))){
			s result=1
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2018-08-13
/// Description:术语管理下的菜单修改描述及顺序时，同步知识库及规则
/// Input：菜单code，菜单描述，菜单顺序
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.CMKB.TermBase).SyncMKBBase("dhc.bdp.cdssV2.cmkb.mtm.SY000011","功能_术语分类","32")
ClassMethod SyncMKBBase(menuCode, menuCaption, menuSequence) As %String
{
	 ;##class(web.CDSS.CMKB.TermBase).SyncMKBBase("menuCode","menuCaption","menuSequence")
	 s resultSync=""
	 if (menuCode["dhc.bdp.cdssV2.cmkb.mtm."){ //术语管理子菜单同步
		 s BaseCode=$p(menuCode,"dhc.bdp.cdssV2.cmkb.mtm.",2)
		 s BaseCodeU=$ZCONVERT(BaseCode,"U") //转换成大写
		 if ($d(^CT.WDT.CDSS.TermBaseI("CodeIndex"," "_BaseCodeU))){
		     s BaseId = $o(^CT.WDT.CDSS.TermBaseI("CodeIndex"," "_BaseCodeU,0))
			 s flag=..Validate(BaseId,BaseCode,menuCaption)   
		     if (flag=1)
		     {
		      	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		     }else{
				 
				 s obj=##class(CT.WDT.CDSS.TermBase).%OpenId(BaseId)                  
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
     q resultSync
}

/// d ##class(web.CDSS.CMKB.TermBase).TestSave()
ClassMethod TestSave() As %String
{
	s eobj = ##class(web.CDSSEntity.CMKB.TermBase).%New()
	s eobj.MKBTBRowId = "43"
	s eobj.MKBTBCode = "w00023"
	d ..SaveEntity(eobj)
}

/// Creator：丁亚男
/// CreatDate: 2019-03-06
/// Description:判断编码规则是否可以修改
/// Input： basedr
/// Return: 1存在内容，不可修改,0可以修改
/// Other: w ##class(web.CDSS.CMKB.TermBase).IsMKBBaseCreate("1510")
ClassMethod IsCodeRulesChange(basedr) As %String
{
	s flag=0
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",basedr))) s flag=1
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2019-03-27
/// Description:根据标识获取知识库id
/// Table：CT.WDT.CDSS.TermBase
/// Input：flag
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetFlagById(5)
ClassMethod GetFlagById(id As %String) As %String
{
	s MKBTBFlag=""
	if (id'=""){
		s MKBTBFlag=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),10)
	}
	q MKBTBFlag
}

/// Creator：丁亚男
/// CreatDate: 2019-10-28
/// Description:根据知识库id获取分类描述
/// Table：CT.WDT.CDSS.TermBase
/// Input：分类描述
/// Other: w ##class(web.CDSS.CMKB.TermBase).GetCatDescById(87)
ClassMethod GetCatDescById(id As %String) As %String
{
	s CatDesc=""
	if (id'=""){
		s MKBTBCatDr=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(id)),9)
 		s:MKBTBCatDr'="" CatDesc=..GetCatText(MKBTBCatDr)
	}
	q CatDesc
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:术语注册不同状态的数据统计
/// Table:CT.WDT.CDSS.Term
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.TermBase).CountData()
ClassMethod CountData()
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	
	s MKBTBRowId=""
  	for
  	{  
		s MKBTBRowId=$o(^CT.WDT.CDSS.TermBaseD(MKBTBRowId),-1) q:MKBTBRowId=""  
		s Totalcount=Totalcount+1
		s Reviewedcount=Reviewedcount+1		
		
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

}
