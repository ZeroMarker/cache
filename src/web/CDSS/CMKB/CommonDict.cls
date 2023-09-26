/// 名称:通用名字典表V2.0
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-15
Class web.CDSS.CMKB.CommonDict Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-1-15
/// Description：查询 
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDict","GetList","","","","","","","","","")
Query GetList(rowid As %String, desc As %String, alias As %String, lib As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,TypeDR,DictCode,DictDesc,UseFlag,UpdateUser,UpdateDate,Remarks,DefaultUnitDesc,EnName,DictAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, lib As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s TypeDR=""
		s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),2)       //通用字典类型
		s:Type'="" TypeDR=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)
		s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),3)       //编号
		s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)       //通用名名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),5)        //使用标志（0编辑中,1已弃用,2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),6) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),8)        //备注
		s DefaultUnitDesc=""
	   	s DefaultUnitDR=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),9)   //默认单位
		s:DefaultUnitDR'="" DefaultUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(DefaultUnitDR)),3)		
		s EnName=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),10)        //英文名称
		s DictAlias= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),11)        //别名
		d OutputRow
	}
	else
	{
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.CommonDictD(ID))
				q:ID=""
				s CommonDictName= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),3)		//名称
				s length=$l(CommonDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.CommonDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)				//编辑时间
				s:UpdateDate="" UpdateDate="2021-01-01"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",UpdateDate,ID)=ID
			}
		}
 		s le=""
		for
		{
			if (sortmethod="Short"){
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le)) 
			} else{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le),-1) 
			}
			q:le=""
			s ID=0
        	for {
            
	       		s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,ID)) q:ID=""
	       	
	       		s TypeDR=""
				s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),2)           //通用字典类型
				s:Type'="" TypeDR=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)
				continue:(Type'=lib)&&(lib'="")
				s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),3)       //编号
				s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)       //通用名名称
	    		s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),5)    //状态（0编辑中,1已弃用,2已审核）
	    		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    		continue:((state="")&&(UseFlag="已弃用"))
	    		s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),6) 	 //编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)     //编辑时间
	   	 		s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),8)        //备注
	   	 		s DefaultUnitDesc=""
		   		s DefaultUnitDR=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),9)   //默认单位
				s:DefaultUnitDR'="" DefaultUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(DefaultUnitDR)),3)		
				s EnName=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),10)        //英文名称
				s DictAlias= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),11)        //别名
	    		continue:((alias'="")&&($ZCONVERT(DictAlias,"U")'[alias))
		    	if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(DictDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state) 
				{
					if ((StartTime'="")&&(EndTime'=""))
					{
						if ($ZDH(UpdateDate,3)<=$zdh(EndTime,3))&&($ZDH(UpdateDate,3)>=$zdh(StartTime,3))
						{
							d OutputRow
						}
					}
					elseif ((StartTime="")&&(EndTime'=""))
					{
						if $ZDH(UpdateDate,3)<=$zdh(EndTime,3)
						{
							d OutputRow
						}
					}
					elseif ((EndTime="")&&(StartTime'=""))
					{
						if $ZDH(UpdateDate,3)>=$zdh(StartTime,3)
						{
							d OutputRow
						}
					}
					elseif ((EndTime="")&&(StartTime=""))
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
    set Data=$lb(ID,TypeDR,DictCode,DictDesc,UseFlag,UpdateUser,UpdateDate,Remarks,DefaultUnitDesc,EnName,DictAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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

/// Creator：阚延新
/// CreatDate: 2021-01-22
/// Description：查询 通用名 
/// Table：CT.WDT.CDSS.CommonDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDict","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, type As %String, q As %String) As %Query(ROWSPEC = "DictRowId:%String,DictCode:%String,DictDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, type As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s DictRowId=rowid
	s TypeDR=""
	s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),2)                 //通用名字典类型ID
	s:Type'="" TypeDR= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)       //通用名字典类型名称
	s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),3)             //编号
	s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),4)             //通用名名称
	//s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),5)    //状态
  	d OutputRowCmb
 }
 else
 {
	s:desc="" desc=q
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:type'="" type=$ZCONVERT(type,"U") //转换成大写
  	s DictRowId=""
  	for{  
	  	s DictRowId=$o(^CT.WDT.CDSS.CommonDictD(DictRowId),-1) q:DictRowId="" 
	  	s TypeDR="" 
	  	s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),2)                 //通用名字典类型ID
		s:Type'="" TypeDR= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)       //通用名字典类型名称
		s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),3)             //编号
		s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),4)             //通用名名称
		s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(DictRowId)),5)
	  	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DictDesc)  
	  	if (($ZCONVERT(DictDesc,"U")[desc)||(PINYIN[desc))&($ZCONVERT(TypeDR,"U")[type)&(UseFlag=2)
	  	{
	  		d OutputRowCmb
	  	}
  	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DictRowId,DictCode,DictDesc)
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

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description：数据重复验证方法，由js调用
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.CommonDict).Validate("129","测试2","个人史")
ClassMethod Validate(id As %String, name As %String, typedr As %String) As %String
{
    s flag="",flagc="",flagd=""
	s name = $ZCONVERT(name,"U")
	s typedr = $ZCONVERT(typedr,"U")
	
	s:(name'="") flagc=$d(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_name))
	s:(typedr'="") flagd=$d(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_typedr))
	if (id="") //如果为空，增加时的重复判断
	{
	    if ((flagc>0)&&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:name'="" idc=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_name,0))
		s:typedr'="" idd=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_typedr,0))
		if (((idc'="")&(idc'=id)&(flagc>0))&&((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Other:w ##class(web.CDSS.CMKB.CommonDict).FormValidate("132","6","测试2")
ClassMethod FormValidate(id As %String, typedr As %String, desc As %String) As %String
{
	q:(typedr="")||(desc="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.CommonDictI("TypeDescIndex",typedr,desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex",typedr,desc,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.CommonDict).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.CommonDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.CommonDictI("DescIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.CommonDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.CommonDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description：保存通用名字典表的内容
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：web.CDSSEntity.CMKB.CommonDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.CommonDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.CommonDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    { 
        s eobj.DictDesc=##class(web.BDP.util.String).Replace(eobj.DictDesc," ","")  
        s flag=..FormValidate(eobj.ID,eobj.TypeDR,eobj.DictDesc)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.DictDesc,eobj.DictAlias)		//调用别名重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        elseif (flagAlias=1)
		{
			s result = "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
			
		}
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.CommonDict).%New()
                s obj.DictCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.CommonDict).%New()
                s bobj.ID=eobj.ID
                s bobj.DictDesc=obj.DictDesc          //修改描述
                s:obj.TypeDR'="" bobj.TypeDR = obj.TypeDR.%Id()	
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks
                s bobj.DefaultUnitDR=obj.DefaultUnitDR
                s bobj.EnName=obj.EnName 
                s bobj.DictAlias=obj.DictAlias
            }
            Ts
            s obj.DictDesc = eobj.DictDesc          //修改描述
            d:eobj.TypeDR'="" obj.TypeDRSetObjectId(eobj.TypeDR)		
		    d:eobj.TypeDR="" obj.TypeDRSetObjectId("")
            s obj.UseFlag =eobj.UseFlag
            s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            d obj.DefaultUnitDRSetObjectId(eobj.DefaultUnitDR)
            s obj.EnName=eobj.EnName
            s obj.DictAlias=eobj.DictAlias
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",id,eobj.DictDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",eobj.ID,eobj.DictDesc,"U",eobj,bobj)
                //同步修改识别词项目数据
            	s TypeDesc=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(eobj.TypeDR)),3)
            	/*d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("生命体征名称",eobj.DictDesc,bobj.DictDesc)
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("妊娠/产后状态名称",eobj.DictDesc,bobj.DictDesc)
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("月经婚育项目名称",eobj.DictDesc,bobj.DictDesc)
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("存在状态",eobj.DictDesc,bobj.DictDesc)
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("患者关系",eobj.DictDesc,bobj.DictDesc)
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("个人史名称",eobj.DictDesc,bobj.DictDesc)*/
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord(TypeDesc,eobj.DictDesc,bobj.DictDesc)
                //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.DictAlias'=""))||((eobj.ID'="")&&(eobj.DictAlias'=bobj.DictAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDict",id,eobj.DictAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.CommonDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.CommonDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.CommonDictD(dataid)),3)
		s result = code+1
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description：根据ID删除通用名字典表的内容
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.CMKB.CommonDict).DeleteData("4")
ClassMethod DeleteData(Id As %String) As %String
{
	s result=""
	s re=##class(web.CDSS.CMKB.CommonDict).GetRefFlag(Id)
    s RefFlag=$p(re,"^",1)      //说明：改成前台调用
    if (RefFlag'=0){
	    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"    
	}
	else
	{
		s pobj = ##class(CT.WDT.CDSS.CommonDict).%OpenId(Id) 
		s eobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New() 


        s eobj.DictCode=pobj.DictCode
        s eobj.DictDesc=pobj.DictDesc          //修改描述	
        s eobj.UseFlag=pobj.UseFlag
        s eobj.UpdateUser=pobj.UpdateUser
        s eobj.UpdateDate=pobj.UpdateDate
        s eobj.Remarks=pobj.Remarks
        s eobj.DefaultUnitDR=pobj.DefaultUnitDR
        s eobj.EnName=pobj.EnName 
        s eobj.DictAlias=pobj.DictAlias       		
		
		d pobj.%Close()
	Quit:Id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	Ts
	s sc=##class(CT.WDT.CDSS.CommonDict).%DeleteId(Id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典",Id,eobj.DictDesc,"D",eobj)
	    //删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.CommonDict",Id)
	}
	else
	{
		Tro
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	    s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典","web.CDSS.CMKB.CommonDict","DeleteData",eobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
	}
	}
	Quit result
}

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description：修改时打开的数据
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.CommonDict).NewOpenData("113")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New()
	s eobj.ID = id
	s eobj.TypeDR = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),2)
	s eobj.DictCode = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),3)
	s eobj.DictDesc = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),4)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),5)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),6)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),8)
	s eobj.DefaultUnitDR=$LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),9)
	s eobj.EnName=$LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),10)
	s eobj.DictAlias=$LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),11)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description:导出通用名字典数据
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.CommonDict).ExportData("","","","","","")
ClassMethod ExportData(desc As %String, lib As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="通用名字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("编号,通用名名称,通用字典类型,默认单位,英文名称,编辑人员,编辑时间,备注,状态")
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s ID=0
	k ^TempDataHandle($ZNAME,$JOB,"Short")
	k ^TempDataHandle($ZNAME,$JOB,"Handle")
	for 
	{
		s ID=$o(^CT.WDT.CDSS.CommonDictD(ID))
		q:ID=""
		s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)				//编辑时间
		s ^TempDataHandle($ZNAME,$JOB,"Short",UpdateDate,ID)=ID
	}
 	s num=0
	//s UpdateTime=$o(^TempDataHandle("short",""),-1)
	s UpdateTime=""
	for
	{
		s UpdateTime=$o(^TempDataHandle($ZNAME,$JOB,"Short",UpdateTime),-1)
		q:UpdateTime=""
		s TypeID=0
		for
		{
			s TypeID=$o(^CT.WDT.CDSS.CommonDictI("UpdateDateIndex",UpdateTime,TypeID))
			q:TypeID=""
			s num=num+1
			s ^TempDataHandle($ZNAME,$JOB,"Handle",num)=TypeID
	    }
	}
	
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle($ZNAME,$JOB,"Handle",Number))
		q:Number=""
		s ID=^TempDataHandle($ZNAME,$JOB,"Handle",Number)
		s TypeDR=""
		s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),2)           //通用字典类型
		s:Type'="" TypeDR=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)
		continue:(Type'=lib)&&(lib'="")
		s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),3)       //编号
		s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)       //通用名名称
		continue:(($ZCONVERT(DictDesc,"U")'[desc)&&(desc'=""))
	    s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),5)    //使用标志（0编辑中，1已弃用，2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已删除")))
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),6) 	 //编辑人员
	    continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)     //编辑时间
	    continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>$zdh(EndTime,3))||($ZDH(UpdateDate,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(StartTime,3))
	   	s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),8)        //备注
	   	s DefaultUnitDesc=""
	   	s DefaultUnitDR=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),9)   //默认单位
		s:DefaultUnitDR'="" DefaultUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(DefaultUnitDR)),3)	
		s EnName=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),10)        //英文名称
		    
			//替换双引号
	 	s TypeDR=$replace(TypeDR,"""","”")
		s DictCode=$replace(DictCode,"""","”")
		s DictDesc=$replace(DictDesc,"""","”")
		s UpdateUser=$replace(UpdateUser,"""","”")
		s UpdateDate=$replace(UpdateDate,"""","”")
		s Remarks=$replace(Remarks,"""","”")
	
		s str=DictCode_","_DictDesc_","_TypeDR_","_DefaultUnitDesc_","_EnName_","_UpdateUser_","_UpdateDate_","_Remarks_","_UseFlag
		
		d file.WriteLine(str)	
		}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description:导出通用名字典数据
/// Table:CT.WDT.CDSS.CommonDict通用名字典表
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.CommonDict).ExportDataTXT("","身长","","","","","")
ClassMethod ExportDataTXT(desc As %String, alias As %String, lib As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	/*
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"通用名字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"通用名字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	o file:"NWS"
	u file
	w "编号	通用名名称	别名	通用字典类型	默认单位	英文名称	编辑人员	编辑时间	备注	状态"
	//w "编号    通用名名称	通用字典类型 默认单位 英文名称 编辑人员 编辑时间  备注  状态"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.CommonDictI("UpdateDateIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.CommonDictI("UpdateDateIndex",UpdateTime,ID))
			q:ID=""
			s TypeDR=""
			s Type= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),2)           //通用字典类型
			s:Type'="" TypeDR=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(Type)),3)
			continue:(Type'=lib)&&(lib'="")
			s DictCode= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),3)       //编号
			s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),4)       //通用名名称
			continue:(($ZCONVERT(DictDesc,"U")'[desc)&&(desc'=""))
	    	s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),5)    //使用标志（0编辑中，1已弃用，2已审核）
	    	s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    	continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已删除")))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),6) 	 //编辑人员
	    	continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),7)     //编辑时间
	    	continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>$zdh(EndTime,3))||($ZDH(UpdateDate,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(StartTime,3))
	   		s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),8)        //备注
	   		s DefaultUnitDesc=""
	   		s DefaultUnitDR=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),9)   //默认单位
			s:DefaultUnitDR'="" DefaultUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(DefaultUnitDR)),3)	
			s EnName=$lg($g(^CT.WDT.CDSS.CommonDictD(ID)),10)        //英文名称
			s DictAlias= $lg($g(^CT.WDT.CDSS.CommonDictD(ID)),11)        //别名
		    continue:(($ZCONVERT(DictAlias,"U")'[alias)&&(alias'=""))
			//替换双引号
	 		s TypeDR=$replace(TypeDR,"""","”")
			s DictCode=$replace(DictCode,"""","”")
			s DictDesc=$replace(DictDesc,"""","”")
			s UpdateUser=$replace(UpdateUser,"""","”")
			s UpdateDate=$replace(UpdateDate,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s DictAlias=$replace(DictAlias,"""","”")
	
			w !,DictCode_"	"_DictDesc_"	"_DictAlias_"	"_TypeDR_"	"_DefaultUnitDesc_"	"_EnName_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag

		}
	}
	c file
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-1-18
/// Description：导入通用名字典
/// Table：CT.WDT.CDSS.CommonDict通用名字典表
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.CommonDict).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	
	s result ="" 
	s DictCode=0
	s file=##class(%File).%New("E:\通用名字典.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s eobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New()
		s eobj.DictCode=$p(Line,",",1)
		s eobj.DictDesc=$p(Line,",",2)
		s TypeDesc=$p(Line,",",3)
		s:TypeDesc'="" TypeDR=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_TypeDesc,0))
		s eobj.TypeDR=TypeDR
		//s del=$p(Line,",",3)
		//continue:(del="删除")
		s DictDesc = $ZCONVERT(eobj.DictDesc,"U")
	    if $d(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_DictDesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_DictDesc,""))
		   s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.CommonDict).%New()
		    //s DictCode=DictCode+1
		    //s obj.DictCode=DictCode
		}
        s obj.DictCode=eobj.DictCode
		s obj.DictDesc = eobj.DictDesc
		d obj.TypeDRSetObjectId(eobj.TypeDR)
		s obj.UseFlag = 2
		s obj.Remarks = ""	
		s obj.UpdateUser = "dhcc"
		s obj.UpdateDate = $ZDATETIME($HOROLOG,3)
		d obj.DefaultUnitDRSetObjectId(eobj.DefaultUnitDR)
		s obj.EnName=eobj.EnName
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
		
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-20
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.CommonDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.CommonDict).UpdateUseFlag("228","通过")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	
	s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New() 
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
		
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",id,obj.DictDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-16
/// Description：根据生命体征名称，取默认单位id及单位描述的方法
/// Table：CT.WDT.CDSS.CommonDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.CommonDict).GetUnitBySign("平均动脉压")
ClassMethod GetUnitBySign(desc As %String) As %String
{
	q:desc="" ""
	s UnitDR="",UnitDesc=""
	s ComID=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_desc,0))
	if ComID'=""
	{
		s UnitDR=$lg($g(^CT.WDT.CDSS.CommonDictD(ComID)),9)				//单位ID
		s UnitDesc=""
		s:UnitDR'="" UnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitDR)),3)		//单位描述
	}
	q UnitDR
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table：CT.WDT.CDSS.CommonDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.CommonDict).BatchConfirm()
ClassMethod BatchConfirm(idstr As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"通过")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量驳回
/// Table：CT.WDT.CDSS.CommonDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.CommonDict).BatchCancel()
ClassMethod BatchCancel(idstr As %String, hosp As %String, type As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"驳回")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-11-26
/// Description：删除限制 
/// Return：1-被引用不可删除，0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.CommonDict).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //识别词项目引用接口
    s TypeDR=$lg($g(^CT.WDT.CDSS.CommonDictD(id)),2)
    s DictDesc= $lg($g(^CT.WDT.CDSS.CommonDictD(id)),4)
    s TypeDesc=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeDR)),3)
    if ((TypeDesc="体征")||(TypeDesc="妊娠/产后状态")||(TypeDesc="月经婚育史")||(TypeDesc="存在状态")||(TypeDesc="患者关系")||(TypeDesc="个人史"))
    {
	  s TypeDesc=$case(TypeDesc,"体征":"生命体征名称","妊娠/产后状态":"妊娠/产后状态名称","月经婚育史":"月经婚育项目名称","存在状态":"存在状态","患者关系":"患者关系","个人史":"个人史名称")
	  s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag(TypeDesc,DictDesc)
	  if IWordsStr'="" s myInfo=myInfo_IWordsStr
    }	 
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能弃用或删除!"
    q return
}

/// Creator:胡宜良
/// CreatDate:2022-1-18
/// Description:获得别名列表
/// Table：CT.WDT.CDSS.CommonDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDict","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s DictAlias=$LISTGET($G(^CT.WDT.CDSS.CommonDictD(id)),11)
		s Len=$Length(DictAlias,",")
		for i=1:1:Len{
			s Desc=$p(DictAlias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-21
/// Description：别名数据转存到别名通用表中
/// Table：CT.WDT.CDSS.CommonDict
/// Other: w ##class(web.CDSS.CMKB.CommonDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.CommonDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.CommonDictD(RowId)),11)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.CommonDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.CommonDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.CommonDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.CommonDictD(RowId)),5)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:zww
/// CreatDate:2022-03-04
/// Description：保存方法【用于导数据调用写的】
/// Table:User. DHCDSSCommonDict通用名字典表
/// Input：web.CDSSEntity.CMKB.CommonDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.CommonDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.CommonDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    { 
        s eobj.DictDesc=##class(web.BDP.util.String).Replace(eobj.DictDesc," ","")  
        s flag=..Validate(eobj.ID,eobj.DictDesc,eobj.TypeDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.CommonDict).%New()
                s obj.DictCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.CommonDict).%New()
                s bobj.ID=eobj.ID
                s bobj.DictDesc=obj.DictDesc          //修改描述
                s:obj.TypeDR'="" bobj.TypeDR = obj.TypeDR.%Id()	
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks
                s bobj.DefaultUnitDR=obj.DefaultUnitDR
                s bobj.EnName=obj.EnName 
                s bobj.DictAlias=obj.DictAlias
            }
            Ts
            s obj.DictDesc = eobj.DictDesc          //修改描述
            d:eobj.TypeDR'="" obj.TypeDRSetObjectId(eobj.TypeDR)		
		    d:eobj.TypeDR="" obj.TypeDRSetObjectId("")
            s obj.UseFlag =eobj.UseFlag
            s obj.UpdateUser=eobj.UpdateUser
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            d obj.DefaultUnitDRSetObjectId(eobj.DefaultUnitDR)
            s obj.EnName=eobj.EnName
            s obj.DictAlias=eobj.DictAlias
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",id,eobj.DictDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",eobj.ID,eobj.DictDesc,"U",eobj,bobj)
                //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.DictAlias'=""))||((eobj.ID'="")&&(eobj.DictAlias'=bobj.DictAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDict",id,eobj.DictAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：赵文伟 
/// CreatDate: 2022-03-03
/// Description：导入患者关系数据——新
/// Table:CT.WDT.CDSS.CommonDict 
/// Other: w ##class(web.CDSS.CMKB.CommonDict).ImportCommonDictData("D:\字典数据\患者关系.csv")
ClassMethod ImportCommonDictData(path)
{
	
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	Ts
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
  		s DictCode=$p(str,",",1)		//编码
		s DictDesc=$p(str,",",2)		//名称
		s TypeName=$p(str,",",3)			//类型
		//s TypeDR = ""
		//s:TypeName'="" TypeDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(TypeName)),2)	//指针
		//s TypeDR=9	//患者关系RowId
		s TypeDR=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT(TypeName,"U"),0))
		//b ;1typedr
		s UseFlag=$p(str,",",4)	
		s UseFlag=$case(UseFlag,"编辑中":"0","已弃用":"1","已审核":"2",:"0")
		s UpdateUser=$p(str,",",5)		
		
		if (UpdateUser="")
		{
		 s UpdateUser="dhcc"	
		}
		s UpdateDate=$p(str,",",6)		//操作时间
		if (UpdateDate="")
		{
		 	s UpdateDate=$ZDT($H,3)
		}
		s Remarks=$p(str,",",7)			//备注
		s DefaultUnitDR=$p(str,",",8)
		s EnName=$p(str,",",9)
		s DictAlias=$p(str,",",10)			
		
		
		s readcount=readcount+1
		s ID=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(DictDesc,"U"),0))
		
		//b ;1
		if (ID'="")		//已存在修改
		{
			s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(ID)
			
			s obj.DictDesc =DictDesc          //修改描述
			//s obj.TypeDR=TypeDR
            d obj.TypeDRSetObjectId(TypeDR)		
		    //d:TypeDR="" obj.TypeDRSetObjectId("")
            s obj.UseFlag =UseFlag
            s obj.UpdateUser=UpdateUser
            s obj.UpdateDate=UpdateDate
            s obj.Remarks = Remarks
            d obj.DefaultUnitDRSetObjectId(DefaultUnitDR)
            //s eobj.DefaultUnitDR=DefaultUnitDR
            s obj.EnName=EnName
            s obj.DictAlias=DictAlias
			
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else	//不存在新增
		{
			s eobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New()
			s eobj.ID = ID
			s eobj.TypeDR = TypeDR
			//d eobj.TypeDRSetObjectId(TypeDR)
			
			//s BodyLastLevelDR =""
			//s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
			s eobj.DictCode = DictCode
			s eobj.DictDesc = DictDesc
			s eobj.UseFlag = UseFlag
			s eobj.UpdateUser = UpdateUser
			s eobj.UpdateDate = UpdateDate
			s eobj.Remarks = Remarks
			s eobj.DefaultUnitDR=DefaultUnitDR
			//d eobj.DefaultUnitDRSetObjectId(DefaultUnitDR)
			s eobj.EnName=EnName
			s eobj.DictAlias=DictAlias
			//b ;2
			s result=..SaveData(eobj)
			//b ;3
		}	
		if ((result["true"))
		{
			s savecount=savecount+1
			if (ID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			w result,!
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	TC
	q "{success:'true'}"
}

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDict","GetLogList","524")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.CommonDict",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	b ;1
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.CommonDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.CommonDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.CommonDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,eobj.TypeDR,eobj.DictDesc)  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DictDesc,eobj.DictAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
			
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.CommonDict).%New()
            s obj.DictCode = ..getFactorCode()
        }
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.CommonDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.CommonDict).%New()
			s bobj.DictDesc=obj.DictDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.DictAlias=obj.DictAlias
			s:obj.TypeDR'="" bobj.TypeDR = obj.TypeDR.%Id()	
                
		}
		d:eobj.TypeDR'="" obj.TypeDRSetObjectId(eobj.TypeDR)		
		d:eobj.TypeDR="" obj.TypeDRSetObjectId("")
		s obj.DictDesc = eobj.DictDesc          //修改描述
        s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        s obj.DictAlias=eobj.DictAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//新增时，日志
            d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",id,eobj.DictDesc,"A",eobj)
            //修改时，日志
            d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDict","CT.WDT.CDSS.CommonDict","通用名字典表",eobj.ID,eobj.DictDesc,"U",eobj,bobj)
            //同步修改识别词项目数据
            s TypeDesc=$lg($g(^CT.WDT.CDSS.CommonDictTypeD(eobj.TypeDR)),3)
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord(TypeDesc,eobj.DictDesc,bobj.DictDesc)
            //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.DictAlias'=""))||((eobj.ID'="")&&(eobj.DictAlias'=bobj.DictAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDict",id,eobj.DictAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用名字典表","web.CDSS.CMKB.CommonDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
