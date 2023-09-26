/// 名称:症状字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-7
Class web.CDSS.CMKB.SymptomDict Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-1-14
/// Description：查询 
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SymptomDict","GetList","","","","","","2021-11-01","")
Query GetList(rowid As %String, desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,SymptomCode,SymptomDesc,UseFlag,UpdateUser,UpdateDate,Remarks,SymptomAlias")
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
		s SymptomCode= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),2)       //症状代码
		s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),3)       //症状名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),7)        //备注
	    s SymptomAlias= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),8)        //别名
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
				s ID=$o(^CT.WDT.CDSS.SymptomDictD(ID))
				q:ID=""
				s SymptomDictName= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),3)		//名称
				s length=$l(SymptomDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{																		//默认按时间倒序排列
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.SymptomDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),6)				//编辑时间
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
	       	
				s SymptomCode= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),2)       //症状代码
		    	s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),3)       //症状名称
	   	 		s UseFlag= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    		continue:((state="")&&(UseFlag="已弃用"))
	    		s UpdateUser= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),5) 	   //编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),6)     //编辑时间
	    		s Remarks= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),7)        //备注
	    		s SymptomAlias= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),8)        //别名
	    		continue:((alias'="")&&($ZCONVERT(SymptomAlias,"U")'[alias))
		    	if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(SymptomDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[state) 
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
    set Data=$lb(ID,SymptomCode,SymptomDesc,UseFlag,UpdateUser,UpdateDate,Remarks,SymptomAlias)
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
/// Description：查询 症状 
/// Table：CT.WDT.CDSS.SymptomDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SymptomDict","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "SymptomRowId:%String,SymptomCode:%String,SymptomDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s SymptomRowId=rowid
	s SymptomCode= $lg($g(^CT.WDT.CDSS.SymptomDictD(SymptomRowId)),2)      //症状代码
	s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(SymptomRowId)),3)      //症状名称
  	d OutputRowCmb
 }
 else
 {
	if desc="" s desc=q
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.SymptomDictD(ID))
		q:ID=""
		s SymptomName=$lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),3)		//名称
		s length=$l(SymptomName)
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
	}
	s le=0
	s num=0
	for
	{
		s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
		q:le=""
		s SymptomRowId=0
		for
		{
			s SymptomRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,SymptomRowId))
			q:SymptomRowId=""
			//s SymptomRowId=$o(^CT.WDT.CDSS.SymptomDictD(SymptomRowId),-1) q:SymptomRowId=""  
			s SymptomCode= $lg($g(^CT.WDT.CDSS.SymptomDictD(SymptomRowId)),2)      //症状代码
			s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(SymptomRowId)),3)      //症状名称
			s Usefalg= $lg($g(^CT.WDT.CDSS.SymptomDictD(SymptomRowId)),4)
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SymptomDesc)  
			if (($ZCONVERT(SymptomDesc,"U")[desc)||(PINYIN[desc))&(Usefalg=2) 
			{
				d OutputRowCmb
			}
  		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(SymptomRowId,SymptomCode,SymptomDesc)
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
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.SymptomDict).Validate("","1","")
ClassMethod Validate(id As %String, name As %String) As %String
{
    s flag=""
	s name = $ZCONVERT(name,"U")
	s:(name'="") flag=$d(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_name))
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
		s:(name'="") idc=$o(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_name,0))
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
/// w ##class(web.CDSS.CMKB.SymptomDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.SymptomDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.SymptomDictI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.SymptomDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.SymptomDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// Description：保存症状字典表的内容
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input：web.CDSSEntity.CMKB.SymptomDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.SymptomDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.SymptomDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s eobj.SymptomDesc=##class(web.BDP.util.String).Replace(eobj.SymptomDesc," ","")  
        s flag=..Validate(eobj.ID,eobj.SymptomDesc)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.SymptomDesc,eobj.SymptomAlias)		//调用别名重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
        if (flagAlias=1)
        {
            q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.SymptomDict).%New()
                s obj.SymptomCode = ..getFactorCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.SymptomDict).%New()
                s bobj.ID=eobj.ID
                s bobj.SymptomDesc=obj.SymptomDesc          //修改描述
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks
                s bobj.SymptomAlias=obj.SymptomAlias 
            }
            Ts
            s obj.SymptomDesc = eobj.SymptomDesc          //修改描述
            s obj.UseFlag =eobj.UseFlag
            s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
            s obj.UpdateUser = eobj.UpdateUser
            s eobj.UpdateDate= $zdt($h,3)
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            s obj.SymptomAlias=eobj.SymptomAlias
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典表",id,eobj.SymptomDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典表",eobj.ID,eobj.SymptomDesc,"U",eobj,bobj)
                //同步修改识别词项目数据
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("症状名称",eobj.SymptomDesc,bobj.SymptomDesc)
                //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.SymptomAlias'=""))||((eobj.ID'="")&&(eobj.SymptomAlias'=bobj.SymptomAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.SymptomDict",id,eobj.SymptomAlias)
            	}
            	
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("症状字典表","web.CDSS.CMKB.SymptomDict","SaveEntity",eobj)
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
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("症状字典表","web.CDSS.CMKB.SymptomDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.SymptomDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.SymptomDictD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description：修改时打开的数据
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New()
	s eobj.ID = id
	s eobj.SymptomCode = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),2)
	s eobj.SymptomDesc = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),3)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),4)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),5)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),6)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),7)
	s eobj.SymptomAlias=$LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),8)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:阚延新
/// CreatDate:2021-1-14
/// Description:导出症状字典数据
/// Table:User. DHCDSSSymptomDict症状字典表
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.SymptomDict).ExportData()
ClassMethod ExportData(desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"症状字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"症状字典数据.txt"		
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
	w "编号	症状名称	别名	编辑人员	编辑时间	备注	状态"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.SymptomDictI("UpdateDateIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.SymptomDictI("UpdateDateIndex",UpdateTime,ID))
			q:ID=""
			s SymptomCode= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),2)       //编号
			s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),3)       //症状名称
			continue:(($ZCONVERT(SymptomDesc,"U")'[desc)&&(desc'=""))
	   		s UseFlag= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    	s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    	continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已弃用")))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),5) 	   //编辑人员
	    	continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),6)     //编辑时间
			continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>$zdh(EndTime,3))||($ZDH(UpdateDate,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)'=$zdh(StartTime,3))	
	    	s Remarks= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),7)        //备注
	    	s SymptomAlias= $lg($g(^CT.WDT.CDSS.SymptomDictD(ID)),8)        //备注
			continue:(($ZCONVERT(SymptomAlias,"U")'[alias)&&(alias'=""))
	 		//替换双引号
			s SymptomCode=$replace(SymptomCode,"""","”")
			s SymptomDesc=$replace(SymptomDesc,"""","”")
			s SymptomAlias=$replace(SymptomAlias,"""","”")
			s UpdateUser=$replace(UpdateUser,"""","”")
			s UpdateDate=$replace(UpdateDate,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s UseFlag=$replace(UseFlag,"""","”")
			w !,SymptomCode_"	"_SymptomDesc_"	"_SymptomAlias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
		}
	}
	c file
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-1-18
/// Description：导入症状字典
/// Table：CT.WDT.CDSS.SymptomDict症状字典表
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.SymptomDict).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	
	s result ="" 
	s SymptomCode=0
	s file=##class(%File).%New("D:\症状字典.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s eobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New()
		s eobj.SymptomDesc=$p(Line,",",1)
		continue:(eobj.SymptomDesc="")
		s del=$p(Line,",",3)
		continue:(del="删除")
		s SymptomDesc = $ZCONVERT(eobj.SymptomDesc,"U")
	    if $d(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_SymptomDesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_SymptomDesc,""))
		   s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.SymptomDict).%New()
		    s SymptomCode=SymptomCode+1
		    s obj.SymptomCode=SymptomCode
		}
        
		s obj.SymptomDesc = eobj.SymptomDesc
		s obj.UseFlag = 2
		s obj.Remarks = ""
		s obj.SymptomAlias = ""	
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
/// Table：CT.WDT.CDSS.SymptomDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.SymptomDict).UpdateUseFlag("1","1")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New() 
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
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
			s lineI=obj.SymptomDesc_",识别条件,主要条件-识别词,1,症状名称,"_obj.SymptomDesc_",0"
			d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}  	
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典表",id,obj.SymptomDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table：CT.WDT.CDSS.SymptomDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).BatchConfirm()
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
/// Table：CT.WDT.CDSS.SymptomDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).BatchCancel()
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

/// Creator:阚延新
/// CreatDate:2021-1-15
/// Description：根据ID删除通用名字典表的内容
/// Table：CT.WDT.CDSS.SymptomDict
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.CMKB.SymptomDict).DeleteData("2210")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	Quit:id="" "{success:'false',info:'删除失败,入参为空！'}" 
	 
	s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New()
	s bobj.ID = id
	s bobj.SymptomCode = obj.SymptomCode			
	s bobj.SymptomDesc = obj.SymptomDesc	             	
	s bobj.UseFlag = obj.UseFlag					
	s bobj.UpdateUser = obj.UpdateUser					
	s bobj.UpdateDate = obj.UpdateDate					
  	s bobj.SymptomAlias=obj.SymptomAlias		
	s bobj.Remarks=obj.Remarks
	
	Ts
	s sc=##class(CT.WDT.CDSS.SymptomDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典",id,bobj.SymptomDesc,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.SymptomDict",id)
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("症状字典","web.CDSS.CMKB.SymptomDict","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-11-10
/// Description:获得别名列表
/// Table：CT.WDT.CDSS.SymptomDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SymptomDict","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s SymptomDictAlias=$LISTGET($G(^CT.WDT.CDSS.SymptomDictD(id)),8)
		s Len=$Length(SymptomDictAlias,",")
		for i=1:1:Len{
			s Desc=$p(SymptomDictAlias,",",i)
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
/// Table：CT.WDT.CDSS.SymptomDict
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.SymptomDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.SymptomDictD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.SymptomDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.SymptomDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.SymptomDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.SymptomDictD(RowId)),4)       
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

/// Creator：胡宜良 
/// CreatDate: 2021-11-26
/// Description：删除限制 
/// Return：1-被引用不可删除，0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.SymptomDict).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //识别词项目引用接口
    s SymptomDesc= $lg($g(^CT.WDT.CDSS.SymptomDictD(id)),3) 	 
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("症状名称",SymptomDesc)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr	
    
    //诊疗规则引用接口 ZWW 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("症状",SymptomDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("症状",SymptomDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能弃用或删除!"
    q return
}

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SymptomDict","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.SymptomDict",RowId,LogID),-1) q:LogID=""
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
/// Table： CT.WDT.CDSS.SymptomDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.SymptomDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.SymptomDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s eobj.SymptomDesc=##class(web.BDP.util.String).Replace(eobj.SymptomDesc," ","")  
        s flag=..Validate(eobj.ID,eobj.SymptomDesc)  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.SymptomDesc,eobj.SymptomAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.SymptomDict).%New()
            s obj.SymptomCode = ..getFactorCode()
        }
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.SymptomDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.SymptomDict).%New()
			s bobj.SymptomDesc=obj.SymptomDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.SymptomAlias=obj.SymptomAlias
			
		}
		
		s obj.SymptomDesc = eobj.SymptomDesc          //修改描述
        s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        s obj.SymptomAlias=eobj.SymptomAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//新增时，日志
            d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典表",id,eobj.SymptomDesc,"A",eobj)
            //修改时，日志
            d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SymptomDict","CT.WDT.CDSS.SymptomDict","症状字典表",eobj.ID,eobj.SymptomDesc,"U",eobj,bobj)
            //同步修改识别词项目数据
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("症状名称",eobj.SymptomDesc,bobj.SymptomDesc)
            //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.SymptomAlias'=""))||((eobj.ID'="")&&(eobj.SymptomAlias'=bobj.SymptomAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.SymptomDict",id,eobj.SymptomAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("症状字典表","web.CDSS.CMKB.SymptomDict","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("症状字典表","web.CDSS.CMKB.SymptomDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
