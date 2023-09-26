/// 名称:单位字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-7
Class web.CDSS.CMKB.UnitDict Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-1-14
/// Description：查询 
/// Table:User. DHCDSSUnitDict单位字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitDict","GetList","","","","","","","")
Query GetList(rowid As %String, desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,UnitCode,UnitDesc,UseFlag,UpdateUser,UpdateDate,Remarks,Alias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s UnitCode= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),2)       //单位代码
		s UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),3)       //单位名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),7)        //备注
	    s Alias= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),8)        //别名
		d OutputRow
	}
	else
	{
		s ID=0
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.UnitDictD(ID))
				q:ID=""
				s UnitDictName= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),3)		//名称
				s length=$l(UnitDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.UnitDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),6)				//编辑时间
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
	    	   	
				s UnitCode= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),2)       //单位代码
		 		s UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),3)       //单位名称
	   	 		s UseFlag= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    		continue:((state="")&&(UseFlag="已弃用"))
	    		s UpdateUser= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),5) 	   //编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),6)     //编辑时间
	    		s Remarks= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),7)        //备注
	    		s Alias= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),8)        //别名
		   		continue:((alias'="")&&($ZCONVERT(Alias,"U")'[alias))
		   		if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(UnitDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state) 
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
    set Data=$lb(ID,UnitCode,UnitDesc,UseFlag,UpdateUser,UpdateDate,Remarks,Alias)
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
/// CreatDate: 2021-01-24
/// Description：查询 单位 
/// Table：CT.WDT.CDSS.UnitDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitDict","GetDataForCmb1","","","盒")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "UnitID:%String,UnitCode:%String,UnitDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s UnitRowId=rowid
	s UnitCode= $lg($g(^CT.WDT.CDSS.UnitDictD(UnitRowId)),2)      //单位代码
	s UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(UnitRowId)),3)      //单位名称
  	d OutputRowCmb
 }
 else
 {
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.UnitDictD(ID))
		q:ID=""
		s UnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(ID)),3)		//名称
		s length=$l(UnitName)
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
	}
	s le=0
	s num=0
	for
	{
		s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
		q:le=""
		s UnitID=0
		for
		{
			s UnitID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,UnitID))
			q:UnitID=""
			s UnitCode= $lg($g(^CT.WDT.CDSS.UnitDictD(UnitID)),2)      		//单位代码
  			s UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(UnitID)),3)      		//单位名称
  			s UseFlag= $lg($g(^CT.WDT.CDSS.UnitDictD(UnitID)),4)       			//状态（0编辑中,1已弃用,2已审核）
  			//continue:(UseFlag=2)
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UnitDesc)  
  			if (($ZCONVERT(UnitDesc,"U")[desc)||(PINYIN[desc))&($ZCONVERT(UnitDesc,"U")[q)||($ZCONVERT(UnitDesc,"U")[q)&(UseFlag=2) 
  			{
  				d OutputRowCmb
  			}
			continue:(desc'=""||(q'=""))
			s num=num+1
			q:num=1000
		}
        q:num=1000
	}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(UnitID,UnitCode,UnitDesc)
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
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：数据重复验证方法，由js调用
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.UnitDict).Validate("","1")
ClassMethod Validate(id As %String, name As %String) As %String
{
    s flag=""
	s name = $ZCONVERT(name,"U")
	s:(name'="") flag=$d(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_name))
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
		s:(name'="") idc=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_name,0))
		if (name="")
		{
			if (idc'=id)&(flag>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.UnitDict).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias'=""){
			s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.UnitDict",Alias,0))	//用别名表中别名数据校验别名重复
			s flagN=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(Alias,"U"),0))
			
			if ((flagA'="")||(flagN'="")){	//如果在别名表或字典表名称中存在
				if (id=""){		//新增，重复
					s flag=1
					q
				}else{			//修改，判断保存别名是否修改，若未修改则不重复
					s AliasId=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",Alias,id,0))
						
					if ((AliasId'=flagA)||(flagN'="")){	
						s flag=1
						q
					}
				}		
			}
		}
	}
	q flag
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：保存单位字典表的内容
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：web.CDSSEntity.CMKB.UnitDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.UnitDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.UnitDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s eobj.UnitDesc=##class(web.BDP.util.String).Replace(eobj.UnitDesc," ","")  
        q:eobj.UnitDesc=eobj.Alias "{success:'false',errorinfo:'名称和别名不能重复！'}"
        s flagAlias=..ValidateAlias(eobj.ID,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
        s flag=..Validate(eobj.ID,eobj.UnitDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.UnitDict).%New()
                s obj.UnitCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.UnitDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.UnitDict).%New()
                s bobj.ID=eobj.ID
                s bobj.UnitDesc=obj.UnitDesc          //修改描述
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks
                s bobj.Alias= obj.Alias        //别名 
            }
            Ts
            s obj.UnitDesc = eobj.UnitDesc          //修改描述
            s obj.UseFlag =eobj.UseFlag
            s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            s obj.Alias= eobj.Alias        //别名
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典表",id,eobj.UnitDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典表",eobj.ID,eobj.UnitDesc,"U",eobj,bobj)
                //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.UnitDict",id,eobj.Alias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位字典表","web.CDSS.CMKB.UnitDict","SaveEntity",eobj)
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
    //s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位字典表","web.CDSS.CMKB.UnitDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.UnitDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.UnitDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.UnitDictD(dataid)),2)
		s result = code+1
	}
	q result
}

/*/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：根据ID删除单位字典表的内容
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.CMKB.UnitDict).DeleteData("4")
ClassMethod DeleteData(Id As %String) As %String
{
	s result=""
	Quit:Id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	TSTART
	s sc=##class(CT.WDT.CDSS.UnitDict).%DeleteId(Id)
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="{success:'true',info:'删除成功！'}"  
	}
	else
	{
		TROLLBACK
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
		
	}
	Quit result
}*/
/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：修改时打开的数据
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.UnitDict).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New()
	s eobj.ID = id
	s eobj.UnitCode = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),2)
	s eobj.UnitDesc = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),3)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),4)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),5)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),6)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),7)
	s eobj.Alias= $LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),8)        //别名
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-11-8
/// Description:导出单位字典数据
/// Table:User. DHCDSSUnitDict单位字典表
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.UnitDict).ExportDataTXT()
ClassMethod ExportDataTXT(desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"单位字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"单位字典数据.txt"		
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
	w "编号	单位名称	别名	编辑人员	编辑时间	备注	状态"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.UnitDictI("UpdateDateIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.UnitDictI("UpdateDateIndex",UpdateTime,ID))
			q:ID=""
			s UnitCode= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),2)       //编号
			s UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),3)       //单位名称
			continue:(($ZCONVERT(UnitDesc,"U")'[desc)&&(desc'=""))
	   		s UseFlag= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    	s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    	continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已弃用")))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),5) 	   //编辑人员
	    	continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),6)     //编辑时间
			continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>$zdh(EndTime,3))||($ZDH(UpdateDate,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(StartTime,3))	
	    	
	    	s Remarks= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),7)        //备注
			s Alias= $lg($g(^CT.WDT.CDSS.UnitDictD(ID)),8)        //别名
	 		continue:(($ZCONVERT(Alias,"U")'[alias)&&(alias'=""))
	 		
	 		//替换双引号
			s UnitCode=$replace(UnitCode,"""","”")
			s UnitDesc=$replace(UnitDesc,"""","”")
			s UpdateUser=$replace(UpdateUser,"""","”")
			s UpdateDate=$replace(UpdateDate,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s UseFlag=$replace(UseFlag,"""","”")
	
			w !,UnitCode_"	"_UnitDesc_"	"_Alias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
	    }
	}
	c file
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-1-18
/// Description：导入单位字典
/// Table：CT.WDT.CDSS.UnitDict单位字典表
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.UnitDict).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	
	s result ="" 
	
	s file=##class(%File).%New("D:\单位字典.csv")
	b ;1
	d file.Open("RS")
	d file.ReadLine()
	b ;2
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		b ;3
		s eobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New()
		b ;31
		s eobj.UnitDesc=$p(Line,"[next]",1)
		continue:(eobj.UnitDesc="")
		s eobj.UnitCode=$p(Line,"[next]",2)
		continue:(eobj.UnitCode="")
		b ;32
		s del=$p(Line,",",3)
		continue:(del="删除")
		s UnitDesc = $ZCONVERT(eobj.UnitDesc,"U")
		s UnitCode = $ZCONVERT(eobj.UnitCode,"U")
	    if $d(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_UnitDesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_UnitDesc,""))
		   s obj=##class(CT.WDT.CDSS.UnitDict).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.UnitDict).%New()
		    //s UnitCode=UnitCode+1
		    //s obj.UnitCode=UnitCode
		    
		}
        
		s obj.UnitDesc = eobj.UnitDesc
		s obj.UnitCode = eobj.UnitCode
		s obj.UseFlag = 2
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
/// Table：CT.WDT.CDSS.UnitDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.UnitDict).UpdateUseFlag("677","1")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.UnitDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New() 
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典表",id,obj.UnitDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-29
/// Description:查询 单位年月日
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitDict","GetDataForCmbYMD","","")
Query GetDataForCmbYMD(rowid As %String, desc As %String, flag As %String = "") As %Query(ROWSPEC = "UnitRowId:%String,UnitDesc:%String")
{
}

ClassMethod GetDataForCmbYMDExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, flag As %String = "") As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s UnitRowId=rowid
        s UnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitRowId)),3)
        d OutputRowYMD
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s UnitRowId=""
  		for{  
	  		s UnitRowId=$o(^CT.WDT.CDSS.UnitDictD(UnitRowId),-1) q:UnitRowId=""  
            s UnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitRowId)),3)
            s UnitDesc1=$ZCONVERT(UnitDesc,"U")
            if (flag=""){
	            i (UnitDesc1[desc)&((UnitDesc="天")!(UnitDesc="月")!(UnitDesc="岁"))
	            {
	                d OutputRowYMD
	            }
	        }else{
		    	i (UnitDesc1[desc)&((UnitDesc="天")!(UnitDesc="月")!(UnitDesc="岁")!(UnitDesc="分")!(UnitDesc="小时")!(UnitDesc="周")!(UnitDesc="年"))
	            {
	                d OutputRowYMD
	            }
		    }
        }      
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowYMD
    set Data=$lb(UnitRowId,UnitDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbYMDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbYMDExecute ]
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

ClassMethod GetDataForCmbYMDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbYMDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.UnitDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.UnitDict).BatchConfirm()
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
/// Table:CT.WDT.CDSS.UnitDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.UnitDict).BatchCancel()
ClassMethod BatchCancel(idstr As %String)
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

/// Creator:胡宜良
/// CreatDate:2021-10-21
/// Description:数据删除方法
/// Table:CT.WDT.CDSS.UnitDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.UnitDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	
	s obj=##class(CT.WDT.CDSS.UnitDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New() 
	s bobj.ID=id
	s bobj.UnitCode = ""
	s bobj.UnitDesc = obj.UnitDesc
	s bobj.UseFlag = obj.UseFlag
	s bobj.Remarks = obj.Remarks
	s bobj.Alias= obj.Alias        //别名
	s bobj.UpdateDate = ""
	s bobj.UpdateUser = ""
	
	Ts
	s sc=##class(CT.WDT.CDSS.UnitDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典",id,bobj.UnitDesc,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("User.DHCDSSBodyPartsDict",id)
            	
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("单位字典","web.CDSS.CMKB.UnitDict","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-1-5
/// Description:获得别名列表
/// Table:CT.WDT.CDSS.UnitDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitDict","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s Alias=$LISTGET($G(^CT.WDT.CDSS.UnitDictD(id)),8)
		s Len=$Length(Alias,",")
		for i=1:1:Len{
			s Desc=$p(Alias,",",i)
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
/// Table：User.DHCDSSSymptomDict
/// Other: w ##class(web.CDSS.CMKB.UnitDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.UnitDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.UnitDictD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.UnitDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.UnitDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.UnitDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.UnitDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.UnitDictD(RowId)),4)       
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

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitDict","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.UnitDict",RowId,LogID),-1) q:LogID=""
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

/// Creator:赵文伟
/// CreatDate:2023-01-15
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.UnitDict).GetRefFlag("32")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0,count=0
    //识别词规则引用接口
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetUnitRefFlag("单位",id)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2023-01-15
/// Description:根据ID返回描述
/// Return:UnitDesc
/// w ##class(web.CDSS.CMKB.UnitDict).GetUnitDesc("32")
ClassMethod GetUnitDesc(id As %String) As %String
{
	s UnitDesc=""
    s:id'="" UnitDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(id)),3)       //单位名称
    q UnitDesc
}

/// w ##class(web.CDSS.CMKB.UnitDict).GetUnitText("123，456")
ClassMethod GetUnitText(id As %String) As %String
{
			s DictName1=id
			s DictName1=$Replace(DictName1,"，",",")
			s DictName1=$Replace(DictName1,"(","（")
			s DictName1=$Replace(DictName1,")","）")
			s DictName1=$Replace(DictName1,"[","【")
			s DictName1=$Replace(DictName1,"]","】")
			s DictName1=$Replace(DictName1,"#","")
			q DictName1
}

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.UnitDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.UnitDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.UnitDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s eobj.UnitDesc=##class(web.BDP.util.String).Replace(eobj.UnitDesc," ","")
		q:eobj.UnitDesc=eobj.Alias "{success:'false',errorinfo:'名称和别名不能重复！'}"  
        s flag=..Validate(eobj.ID,eobj.UnitDesc)  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		 s flagAlias=..ValidateAlias(eobj.ID,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.UnitDict).%New()
            s obj.UnitCode = ..getFactorCode()
        }
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.UnitDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.UnitDict).%New()
			s bobj.UnitDesc=obj.UnitDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.Alias=obj.Alias
			
		}
		
		s obj.UnitDesc = eobj.UnitDesc          //修改描述
        s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        s obj.Alias=eobj.Alias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//新增时，日志
            d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典表",id,eobj.UnitDesc,"A",eobj)
            //修改时，日志
            d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitDict","CT.WDT.CDSS.UnitDict","单位字典表",eobj.ID,eobj.UnitDesc,"U",eobj,bobj)
            //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.UnitDict",id,eobj.Alias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位字典表","web.CDSS.CMKB.UnitDict","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("过敏史字典表","web.CDSS.CMKB.UnitDict","SaveEntity",eobj)
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位字典表","web.CDSS.CMKB.UnitDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
