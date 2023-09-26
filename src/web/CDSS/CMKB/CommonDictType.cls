/// 名称:通用字典类型表 
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-7
Class web.CDSS.CMKB.CommonDictType Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-1-14
/// Description：查询 
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDictType","GetList","","","","","","")
Query GetList(rowid As %String, desc As %String, alias As %String, state As %String, user As %String, timescope As %String, sortmethod) As %Query(ROWSPEC = "ID,TypeCode,TypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks,TypeAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, state As %String, user As %String, timescope As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		
		s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //类型代码
		s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已弃用）
	    s UseFlag=$case(UseFlag,"0":"已审核","1":"编辑中","2":"已弃用",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
		s TypeAlias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),8)        //别名
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s ID=0
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.CommonDictTypeD(ID))
				q:ID=""
				
				s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)		//名称
				s length=$l(TypeDesc)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
			
		}
		else
		{																		//默认按时间倒序排列
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.CommonDictTypeD(ID))
				q:ID=""
				//s ConsultationCode= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2)		//代码
				s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)				//编辑时间
				//s length=$l(UpdateDate)
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
			for
			{
				s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,ID)) q:ID=""
				s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //类型代码
			    s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
		   	 	s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已删除）
		    	s UseFlag=$case(UseFlag,"0":"已审核","1":"编辑中","2":"已弃用",:"") 
		    	continue:((state="")&&(UseFlag="已弃用"))
		    	s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	   //编辑人员
		    	s StartTime=$p(timescope,"^",1)
		    	s EndTime=$p(timescope,"^",2)
		    	s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
		    	continue:((StartTime'="")&&($ZDH(StartTime,3)>$ZDH(UpdateDate,3)))
	        	continue:((EndTime'="")&&($ZDH(EndTime,3)<$ZDH(UpdateDate,3)))
		    	s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
			    s TypeAlias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),8)        //别名
			    if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(TypeDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state)&($ZCONVERT(TypeAlias,"U")[alias) 
				{	
					d OutputRow	
				} 
			}
			
		}						
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TypeCode,TypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks,TypeAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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

/*
/// Creator：阚延新	
/// CreatDate: 2021-1-14
/// Description：查询 
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDictType","GetList","","","","","","")
Query GetList(rowid As %String, desc As %String, alias As %String, state As %String, user As %String, timescope As %String) As %Query(ROWSPEC = "ID,TypeCode,TypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks,TypeAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, state As %String, user As %String, timescope As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		
		s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //类型代码
		s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已弃用）
	    s UseFlag=$case(UseFlag,"0":"已审核","1":"编辑中","2":"已弃用",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
		s TypeAlias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),8)        //别名
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s ID=0
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		for 
		{
			s ID=$o(^CT.WDT.CDSS.CommonDictTypeD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)				//编辑时间
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",UpdateDate,ID)=ID
		}
 		s num=0
		s UpdateTime=$o(^TempDataHandle($ZNAME,repid,$JOB,"short",""),-1)
		for
		{
			s UpdateTime=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",UpdateTime),-1)
			q:UpdateTime=""
			s TypeID=0
			for
			{
				s TypeID=$o(^CT.WDT.CDSS.CommonDictTypeI("UpdateDateIndex",UpdateTime,TypeID))
				q:TypeID=""
				s num=num+1
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",num)=TypeID
	    	}
		}
	
		s Number=0
		for 
		{
			s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number))
			q:Number=""
			s ID=^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)
			s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //类型代码
		    s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
	   	 	s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已删除）
	    	s UseFlag=$case(UseFlag,"0":"已审核","1":"编辑中","2":"已弃用",:"") 
	    	continue:((state="")&&(UseFlag="已弃用"))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	   //编辑人员
	    	s StartTime=$p(timescope,"^",1)
	    	s EndTime=$p(timescope,"^",2)
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
	    	continue:((StartTime'="")&&($ZDH(StartTime,3)>$ZDH(UpdateDate,3)))
        	continue:((EndTime'="")&&($ZDH(EndTime,3)<$ZDH(UpdateDate,3)))
	    	s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
		    s TypeAlias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),8)        //别名
		    if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(TypeDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state)&($ZCONVERT(TypeAlias,"U")[alias) 
			{	
				d OutputRow	
			} 
			
		}						
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TypeCode,TypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks,TypeAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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
*/
/// Creator：阚延新
/// CreatDate: 2021-01-24
/// Description：查询 类型 
/// Table：CT.WDT.CDSS.CommonDictType
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDictType","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "TypeRowId:%String,TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s TypeRowId=rowid
	s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId)),2)      //类型代码
	s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId)),3)      //类型名称
  	d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TypeRowId=""
  for{  
	  s TypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId),-1) q:TypeRowId=""  
	  s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId)),2)      //类型代码
	  s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId)),3)      //类型名称
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TypeDesc) 
	  s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(TypeRowId)),4)
	  if (($ZCONVERT(TypeDesc,"U")[desc)||(PINYIN[desc)&(UseFlag=0)) 
	  {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(TypeRowId,TypeCode,TypeDesc)
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
/// CreatDate:2021-1-14
/// Description：数据重复验证方法，由js调用
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.CommonDictType).Validate("","1","")
ClassMethod Validate(id As %String, name As %String) As %String
{
    s flag=""
	s name = $ZCONVERT(name,"U")
	s:(name'="") flag=$d(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_name))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flag>0)
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
		s idc=""
		s:(name'="") idc=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_name,0))
		if (name="")
		{
			if (idc'=id)&(flag>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'="")&(idc'=id)&(flag>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.CommonDictType).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.CommonDictType",Alias))
	    s flagN=$d(^CT.WDT.CDSS.CommonDictTypeI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.CommonDictType",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate:2021-1-14
/// Description：保存通用字典类型表的内容
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：web.CDSSEntity.CMKB.CommonDictType 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.CommonDictType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.CommonDictType) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {
	    s eobj.TypeDesc=##class(web.BDP.util.String).Replace(eobj.TypeDesc," ","")
	    
        s flag=..Validate(eobj.ID,eobj.TypeDesc)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.TypeDesc,eobj.TypeAlias)		//调用别名重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        elseif(flagAlias=1){
	        s result = "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
	    }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.CommonDictType).%New()
                s obj.TypeCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.CommonDictType).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.CommonDictType).%New()
                s bobj.ID=eobj.ID
                s bobj.TypeDesc=obj.TypeDesc          //修改描述
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks 
                s bobj.TypeAlias=obj.TypeAlias 
            }
            Ts
            s obj.TypeDesc = eobj.TypeDesc          //修改描述
            s obj.UseFlag =eobj.UseFlag
            s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
            s obj.UpdateUser=eobj.UpdateUser
            s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            s obj.TypeAlias = eobj.TypeAlias
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",id,eobj.TypeDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",eobj.ID,eobj.TypeDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.TypeAlias'=""))||((eobj.ID'="")&&(eobj.TypeAlias'=bobj.TypeAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDictType",id,eobj.TypeAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用字典类型","web.CDSS.CMKB.CommonDictType","SaveEntity",eobj)
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
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用字典类型","web.CDSS.CMKB.CommonDictType","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.CommonDictTypeD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.CommonDictTypeD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2021-10—25
/// Description：根据ID删除字典表的内容
/// Table：CT.WDT.CDSS.CommonDictType
/// Input：id-字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.CommonDictType).DeleteData("10")
ClassMethod DeleteData(id As %String) As %String
{
         
    s result="" 
    s obj=##class(CT.WDT.CDSS.CommonDictType).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.CommonDictType).%New()
    s bobj.ID=id
	s bobj.TypeDesc=obj.TypeDesc          //修改描述
    s bobj.UseFlag=obj.UseFlag
    s bobj.UpdateUser=obj.UpdateUser
    s bobj.UpdateDate=obj.UpdateDate
    s bobj.Remarks=obj.Remarks 
    s bobj.TypeAlias=obj.TypeAlias 
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.CommonDictType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",id,bobj.TypeDesc,"D",bobj)
        
        //同步删除别名通用表中数据 
		d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.CommonDictType",id)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("通用字典类型","web.CDSS.CMKB.CommonDictType","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：修改时打开的数据
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.CommonDictType).%New()
	s eobj.ID = id
	s eobj.TypeCode = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),2)
	s eobj.TypeDesc = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),3)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),4)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),5)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),6)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),7)
	s eobj.TypeAlias = $LISTGET($G(^CT.WDT.CDSS.CommonDictTypeD(id)),8)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/*
/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description:导出通用字典类型数据
/// Table:CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.CommonDictType).ExportData("","","","","")
ClassMethod ExportData(desc As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="通用字典类型数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	o file:"NWS"
	u file
	
	w "编号	类型名称	编辑人员	编辑时间	备注	状态"
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写	
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s ID=""	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.CommonDictTypeD(ID),-1) q:ID=""
		s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //编号
		s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
		continue:(($ZCONVERT(TypeDesc,"U")'[desc)&&(desc'=""))
	   	s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已弃用）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已弃用")))
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	   //编辑人员
	    continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>$zdh(EndTime,3))||($ZDH(UpdateDate,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(StartTime,3))	
	    s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
		
	 	//替换双引号
		s TypeCode=$replace(TypeCode,"""","”")
		s TypeDesc=$replace(TypeDesc,"""","”")
		s UpdateUser=$replace(UpdateUser,"""","”")
		s UpdateDate=$replace(UpdateDate,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s UseFlag=$replace(UseFlag,"""","”")
		w !,TypeCode_"	"_TypeDesc_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag

	}
	c file
	q fileName
}
*/
/// Creator:zhaowenwei
/// CreatDate:2021-11-05
/// Description：导出通用字典类型数据txt
/// Other:w ##class(web.CDSS.CMKB.TreatDict).ExportCommonDictTypeTXTData()
ClassMethod ExportCommonDictTypeTXTData(desc, alias, state, user, StartTime, EndTime) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"通用字典类型数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "编号	类型名称	别名	编辑人员	编辑时间	备注	状态"
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s ID=""	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.CommonDictTypeD(ID),-1) q:ID=""
		s TypeCode= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),2)       //类型代码
		s TypeDesc= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),3)       //类型名称
		s UseFlag= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),4)        //使用标志（0已审核，1编辑中，2已删除）
		s UseFlag=$case(UseFlag,"0":"已审核","1":"编辑中","2":"已弃用",:"") 
		continue:((state="")&&(UseFlag="已弃用"))
		s UpdateUser= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),5) 	   //编辑人员
		
		s UpdateDate= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),6)     //编辑时间
		continue:((StartTime'="")&&($ZDH(StartTime,3)>$ZDH(UpdateDate,3)))
	    continue:((EndTime'="")&&($ZDH(EndTime,3)<$ZDH(UpdateDate,3)))
		s Remarks= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),7)        //备注
		s TypeAlias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(ID)),8)        //别名
		if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(TypeDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state)&($ZCONVERT(TypeAlias,"U")[alias) 
		{	
			w !,TypeCode_"	"_TypeDesc_"	"_TypeAlias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
		} 
	}
	c file
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-1-18
/// Description：导入通用字典类型
/// Table：CT.WDT.CDSS.CommonDictType通用字典类型表
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.CommonDictType).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	
	s result ="" 
	s TypeCode=0
	s file=##class(%File).%New("D:\通用字典类型.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s eobj = ##class(web.CDSSEntity.CMKB.CommonDictType).%New()
		s eobj.TypeDesc=$p(Line,",",1)
		continue:(eobj.TypeDesc="")
		s del=$p(Line,",",3)
		continue:(del="删除")
		s TypeDesc = $ZCONVERT(eobj.TypeDesc,"U")
	    if $d(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_TypeDesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_TypeDesc,""))
		   s obj=##class(CT.WDT.CDSS.CommonDictType).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.CommonDictType).%New()
		    s TypeCode=TypeCode+1
		    s obj.TypeCode=TypeCode
		}
        
		s obj.TypeDesc = eobj.TypeDesc
		s obj.UseFlag = 0
		s obj.Remarks = ""	
		s obj.UpdateUser = "dhcc"
		s obj.UpdateDate = $ZDATETIME($HOROLOG,3)
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
/// Table：CT.WDT.CDSS.CommonDictType
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.CommonDictType).UpdateUseFlag("1","1")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.CommonDictType).%New()
	
	s:Operation="通过" eobj.UseFlag="0"	//已审核
	s:Operation="弃用" eobj.UseFlag="2"	//已弃用
	s:Operation="恢复" eobj.UseFlag="1"	//编辑中
	s:Operation="驳回" eobj.UseFlag="1"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.CommonDictType).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.CommonDictType).%New()
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",id,obj.TypeDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-25
/// Description: 批量通过
/// Table: CT.WDT.CDSS.CommonDictType
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..UpdateUseFlag(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-25
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.CommonDictType
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..UpdateUseFlag(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator:zhaowenwei
/// CreatDate:2022-1-18
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.CommonDictType
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDictType","GetAliasList","")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s TypeAlias = $lg($g(^CT.WDT.CDSS.CommonDictTypeD(id)),8)
		s Len=$Length(TypeAlias,",")
		for i=1:1:Len{
			s Desc=$p(TypeAlias,",",i)
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

/// Creator：赵文伟 
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.CommonDictType
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.CommonDictTypeD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.CommonDictTypeD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDictType",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.CommonDictType
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.CommonDictType).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.CommonDictTypeD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.CommonDictTypeD(RowId)),4)       
		if (UseFlag'="")
		{
			if (UseFlag=1){
				s editcount=editcount+1
			} elseif (UseFlag=0){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.CommonDictType","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.CommonDictType",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
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

/// Creator：赵文伟
/// CreatDate: 2023-01-17
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.CommonDictType
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.CommonDictType).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.CommonDictType) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {
	    s eobj.TypeDesc=##class(web.BDP.util.String).Replace(eobj.TypeDesc," ","")
	    
	    s flagAlias=..ValidateAlias(eobj.ID,eobj.TypeDesc,eobj.TypeAlias)		//调用别名重复验证
        s flag=..Validate(eobj.ID,eobj.TypeDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        elseif (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.CommonDictType).%New()
                s obj.TypeCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.CommonDictType).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.CommonDictType).%New()
                s bobj.ID=eobj.ID
                s bobj.TypeDesc=obj.TypeDesc          //修改描述
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.TypeAlias=obj.TypeAlias 
            }
            Ts
            s obj.TypeDesc = eobj.TypeDesc          //修改描述
            s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
            s obj.UpdateUser=eobj.UpdateUser
            s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
            s obj.UpdateDate=eobj.UpdateDate
            s obj.TypeAlias = eobj.TypeAlias
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",id,eobj.TypeDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CommonDictType","CT.WDT.CDSS.CommonDictType","通用字典类型",eobj.ID,eobj.TypeDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.TypeAlias'=""))||((eobj.ID'="")&&(eobj.TypeAlias'=bobj.TypeAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.CommonDictType",id,eobj.TypeAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用字典类型","web.CDSS.CMKB.CommonDictType","SaveEntity",eobj)
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
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("通用字典类型","web.CDSS.CMKB.CommonDictType","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
