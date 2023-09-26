/// 名称:部位字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期:2021-3-5
Class web.CDSS.CMKB.BodyPartsDict Extends %RegisteredObject
{

/// Creator：钟荣枫	
/// CreatDate: 2021-1-14
/// Description：查询 
/// Table:CT.WDT.CDSS.BodyPartsDict  部位字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsDict","GetList","","","","","","","","","Douglas","Short")
Query GetList(rowid As %String, code As %String, desc As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, remarks As %String, alias As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,PartsCode,PartsDesc,UseFlag,UpdateUser,UpdateDate,Remarks,Alias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, remarks As %String, alias As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),2)       //部位代码
		s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)       //部位名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),7)        //备注
	    s Alias= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),8)        //别名
	    d OutputRow
	}
	else
	{
		s ID=0
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.BodyPartsDictD(ID))
				q:ID=""
				s BodyPartsDictName= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)		//名称
				s length=$l(BodyPartsDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.BodyPartsDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),6)				//编辑时间
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
	       	
				s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),2)       //部位代码
				continue:((code'="")&&(PartsCode'[code))
				s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)       //部位名称
			
			
		    	s UseFlag= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
		    	s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
		    	continue:((state'="已弃用")&&(UseFlag="已弃用"))
		    	continue:((state'="")&&(UseFlag'=state))
		    	s UpdateUser= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),5) 	//编辑人员
		    	continue:($ZCONVERT(UpdateUser,"U")'[user)
		    
		    	s UpdateDate= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),6)     //编辑时间
		    	s Remarks= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),7)        //备注
		    	continue:((remarks'="")&(Remarks'[remarks))
		    	s Alias= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),8)        //别名
		    	continue:((alias'="")&&($ZCONVERT(Alias,"U")'[alias))
	    	
	    		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PartsDesc) 
	    		
	    		if (($ZCONVERT(PartsDesc,"U")[desc)||(PINYIN[desc))
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
    set Data=$lb(ID,PartsCode,PartsDesc,UseFlag,UpdateUser,UpdateDate,Remarks,Alias)
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

/// Creator：钟荣枫
/// CreatDate: 2021-3-5
/// Description：查询 部位 下拉框 
/// Table：CT.WDT.CDSS.BodyPartsDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsDict","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ID,PartsDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s ID=rowid
	s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),2)       //部位代码
	s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)       //部位名称
			
  	d OutputRowCmb
 }
 else
 {
	
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	s ID=""
  	for{  
	  	s ID=$o(^CT.WDT.CDSS.BodyPartsDictD(ID),-1) q:ID=""  
	  	s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),2)       //部位代码
		s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)       //部位名称
	    s UseFlag= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),4)
	  	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PartsDesc) 
	  	if (($ZCONVERT(PartsDesc,"U")[desc)||(PINYIN[desc))&(UseFlag=2) 
	  	{
	  	d OutputRowCmb
	  	}
  	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,PartsDesc)
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

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description：数据重复验证方法，由js调用
/// Table:	CT.WDT.CDSS.BodyPartsDict部位字典表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.BodyPartsDict).Validate("","1","")
ClassMethod FormValidate(id As %String, namse As %String) As %String
{
    s flag=""
	s namse = $ZCONVERT(namse,"U")
	s:(namse'="") flag=$d(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_namse))
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
		s:(namse'="") idc=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_namse,0))
		if (namse="")
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
/// w ##class(web.CDSS.CMKB.BodyPartsDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BodyPartsDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.BodyPartsDictI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BodyPartsDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description：保存部位字典表的内容
/// Table:	CT.WDT.CDSS.BodyPartsDict部位字典表
/// Input：web.CDSSEntity.CMKB.BodyPartsDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.BodyPartsDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.BodyPartsDict) As %String
{
    s result=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,eobj.PartsDesc)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.PartsDesc,eobj.Alias)		//调用别名重复验证
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
                s obj=##class(CT.WDT.CDSS.BodyPartsDict).%New()
                s obj.PartsCode = ..getCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
                s bobj.ID=eobj.ID

                s bobj.PartsCode= obj.PartsCode       //部位代码
				s bobj.PartsDesc= obj.PartsDesc       //部位名称
			    s bobj.UseFlag= obj.UseFlag        //状态（0编辑中,1已弃用,2已审核）
			    s bobj.UpdateUser= obj.UpdateUser 	//编辑人员
			    s bobj.UpdateDate= obj.UpdateDate     //编辑时间
			    s bobj.Remarks= obj.Remarks        //备注
			    s bobj.Alias= obj.Alias        //别名
	    
            }
            //s obj.PartsCode= eobj.PartsCode       //部位代码
			s obj.PartsDesc= eobj.PartsDesc       //部位名称
		    s obj.UseFlag= eobj.UseFlag        //状态（0编辑中,1已弃用,2已审核）
		    if (eobj.UpdateUser'="")
		    {
			    s obj.UpdateUser= eobj.UpdateUser 	//编辑人员
		    }
		    else
		    {
			    s obj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
		    }
		    
		    if (eobj.UpdateDate'="")
		    {
			    s obj.UpdateDate= eobj.UpdateDate     //编辑时间
		    }
		    else
		    {
			    s obj.UpdateDate=$ZDATETIME($HOROLOG,3)
		    }
		    s obj.Remarks= eobj.Remarks        //备注
		    s obj.Alias= eobj.Alias        //别名
			    
            
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",id,eobj.PartsDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",eobj.ID,eobj.PartsDesc,"U",eobj,bobj)
            	//同步修改识别词项目数据
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("部位",eobj.PartsDesc,bobj.PartsDesc)
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BodyPartsDict",id,eobj.Alias)
            	}
            	
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位字典表","web.CDSS.CMKB.BodyPartsDict","SaveEntity",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位字典表","web.CDSS.CMKB.BodyPartsDict","SaveEntity",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：钟荣枫
/// Description：得到新增数据的code
/// Table:	CT.WDT.CDSS.BodyPartsDict部位字典表
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).getFactorCode()
ClassMethod getCode() As %String
{
	
    s dataid = $o(^CT.WDT.CDSS.BodyPartsDictD(""),-1)
    s result=""
	if (dataid="")
	{
		s result=1
	}
	else
	{
		s code = $lg($g(^CT.WDT.CDSS.BodyPartsDictD(dataid)),2)
		s code=$tr(code," ","")
		s result = code+1
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-1-14
/// Description：修改时打开的数据
/// Table:User. DHCDSSBodyPartsDict部位字典表
/// Input：id
/// Return:Json格式的字符串
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).NewOpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""	
	s obj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(id)
    s bobj=##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
    s bobj.ID=id

    s bobj.PartsCode= obj.PartsCode       //部位代码
	s bobj.PartsDesc= obj.PartsDesc       //部位名称
    s bobj.UseFlag= obj.UseFlag        //状态（0编辑中,1已弃用,2已审核）
    s bobj.UpdateUser= obj.UpdateUser 	//编辑人员
    s bobj.UpdateDate= obj.UpdateDate     //编辑时间
    s bobj.Remarks= obj.Remarks        //备注
    s bobj.Alias= obj.Alias        //别名
	d obj.%Close()
	
	s str = bobj.JsonS()
	q str
}

/// Creator：钟荣枫 
/// CreatDate: 2021-3-5
/// Description：根据id删除 体格检查
/// Table:CT.WDT.CDSS.BodyPartsDict部位字典表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	//同步删除部位分层字典数据
    s flag= ##class(web.CDSS.CMKB.BodyPartsLevel).SynchDelete(id)
	s info=$p(flag,"'",2)
	if (info="false"){
		s result=flag
	} else{	
	s re=##class(web.CDSS.CMKB.BodyPartsDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)      //说明：改成前台调用
    if (RefFlag'=0){
	    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"    
	}
	else
	{
    s pobj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(id)
    s eobj=##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
    s eobj.ID=id

    s eobj.PartsCode= pobj.PartsCode       //部位代码
	s eobj.PartsDesc= pobj.PartsDesc       //部位名称
    s eobj.UseFlag= pobj.UseFlag        //状态（0编辑中,1已弃用,2已审核）
    s eobj.UpdateUser= pobj.UpdateUser 	//编辑人员
    s eobj.UpdateDate= pobj.UpdateDate     //编辑时间
    s eobj.Remarks= pobj.Remarks        //备注
    s eobj.Alias= pobj.Alias        //别名

   
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(CT.WDT.CDSS.BodyPartsDict).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",id,eobj.PartsDesc,"D",eobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.BodyPartsDict",id)
           	
	}
	else
	{
		Trollback
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("部位字典表","web.CDSS.CMKB.BodyPartsDict","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	}
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2021-03-05
/// Description：导出字典数据
/// Table:
/// Input：
/// Output:文件名 fileName
/// 在对应的路径下生成 .txt文件
/// w ##class(web.CDSS.CMKB.BodyPartsDict).ExportDataTXT("","","","","")  
ClassMethod ExportDataTXT(desc As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"部位字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"部位字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
    o file:"WNS"
    u file
    
    w "部位代码	部位名称	别名	编辑人员	编辑时间	备注	状态"   //注意此处是用tab隔开
    
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s Num=0
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.BodyPartsDictD(ID))
		q:ID=""
		
	 	s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),2)       //部位代码
		s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),3)       //部位名称
		
	    s UseFlag= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),4)        //状态（0编辑中,1已弃用,2已审核）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    continue:((state'="已弃用")&&(UseFlag="已弃用"))
	    continue:((state'="")&&(UseFlag'=state))
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),5) 	//编辑人员
	    continue:($ZCONVERT(UpdateUser,"U")'[user)
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),6)     //编辑时间
	    
	    continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(UpdateDate,3)>=$zdh(EndTime,3))||($ZDH(UpdateDate,3)<=$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(UpdateDate,3)>=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(UpdateDate,3)<=$zdh(StartTime,3))	
	    s Remarks= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),7)        //备注
	    s Alias= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(ID)),8)        //别名
    	continue:(($ZCONVERT(Alias,"U")'[alias)&&(alias'=""))
    	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PartsDesc) 
    	if (($ZCONVERT(PartsDesc,"U")[desc)||(PINYIN[desc))
    	{
	    	s Num=Num+1
	    	w !,PartsCode_"	"_PartsDesc_"	"_Alias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag    //注意此处连接符是tab
    	}	
	}
	c file
	;W !,file_" 生成成功，共"_Num_"条"
	Q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2021-2-23
/// Description：导入字典表数据，,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).ImportDtaTXT()
ClassMethod ImportDtaTXT(path) As %String
{
	s savecount=0
	s nosavecount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s PartsDesc=$p(data,"	",1)	//描述
		continue:PartsDesc=""
		s Alias=$p(data,"	",2)
		
		s eobj=##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
		s eobj.PartsDesc= PartsDesc       //部位名称
	    s eobj.UseFlag= "0"        //状态（0编辑中,1已弃用,2已审核）
	    s eobj.UpdateUser= "dhcc" 	//编辑人员
	    s eobj.UpdateDate= $ZDATETIME($HOROLOG,3)    //编辑时间
	    s eobj.Remarks= ""        //备注
	    s eobj.Alias= Alias        //别名
		s saveresult=..SaveEntity(eobj)
		if (saveresult["false")		//保存失败
		{
			s nosavecount=nosavecount+1
		}
		else	//保存成功
		{
			s savecount=savecount+1
		}	    
		
	}
	w "读取数据总共"_(num-1)_"条",!
	
	w "savecount:"_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.BodyPartsDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.BodyPartsDict).UpdateUseFlag("1","1")
ClassMethod UpdateUseFlag(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	
	s obj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsDict).%New() 
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",id,obj.PartsDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description:查询 部位年月日
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsDict","GetDataForCmbYMD","","")
Query GetDataForCmbYMD(rowid As %String, desc As %String) As %Query(ROWSPEC = "PartsRowId,PartsCode,PartsDesc")
{
}

ClassMethod GetDataForCmbYMDExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PartsRowId=rowid
        s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartsRowId)),2)       //部位代码
		s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartsRowId)),3)       //部位名称
	    
        d OutputRowYMD
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PartsRowId=""
  		for{  
	  		s PartsRowId=$o(^CT.WDT.CDSS.BodyPartsDictD(PartsRowId),-1) q:PartsRowId=""  
	  		s PartsCode= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartsRowId)),2)       //部位代码
			s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartsRowId)),3)       //部位名称
		
            s PartsDesc1=$ZCONVERT(PartsDesc,"U")
            i (PartsDesc1[desc)&((PartsDesc="年")!(PartsDesc="月")!(PartsDesc="日"))
            {
                d OutputRowYMD
            }
        }      
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowYMD
    set Data=$lb(PartsRowId,PartsCode,PartsDesc)
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

/// Creator:xuwenhu
/// CreatDate:2021-05-12
/// Description:获得别名列表
/// Table: User.DHCDSSBodyParts
/// Input: id-部位表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s PartsAlias = $lg($g(^CT.WDT.CDSS.BodyPartsDictD(id)),8)
		s Len=$Length(PartsAlias,",")
		for i=1:1:Len{
			s Desc=$p(PartsAlias,",",i)
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

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.BodyPartsDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).BatchConfirm()
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
/// Table:CT.WDT.CDSS.BodyPartsDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).BatchCancel()
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

/// Creator：胡宜良 
/// CreatDate: 2021-11-5
/// Description：数据转移
/// Other: d ##class(web.CDSS.CMKB.BodyPartsDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BodyPartsDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BodyPartsDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.BodyPartsDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.BodyPartsDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BodyPartsDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.BodyPartsDictD(RowId)),4)       
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
/// CreatDate: 2022-03-02
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.BodyPartsDict).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //识别词项目引用接口
    s PartsDesc= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(id)),3) 	 
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("部位",PartsDesc)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr	
    //部位分层引用
    if ($d(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex",id))){
	    s myInfo=myInfo_"<部位分层表>"
	}
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用"
    q return
}

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsDict","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.BodyPartsDict",RowId,LogID),-1) q:LogID=""
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
/// CreatDate: 2022-11-30
/// Description：查询部位
/// Table：CT.WDT.CDSS.BodyPartsDict
/// Input：父节点 
/// Return：json格式数据串
/// w ##class(web.CDSS.CMKB.BodyPartsDict).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(id As %String = "") As %String
{
	
	w "["
	s count=0
	s myRowID=0
	for {
		s myRowID=$o(^CT.WDT.CDSS.BodyPartsDictD(myRowID))
		q:myRowID=""
		s DeptName = $lg($g(^CT.WDT.CDSS.BodyPartsDictD(myRowID)),3)
		s UseFlag = $lg($g(^CT.WDT.CDSS.BodyPartsDictD(myRowID)),7)
		continue:(UseFlag=1)
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_DeptName_""""
		w ",""state"":""open"""
		
		
		w "}"
	}
	w "]"
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.BodyPartsDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.BodyPartsDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.BodyPartsDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,eobj.PartsDesc)  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.PartsDesc,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
			
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.BodyPartsDict).%New() 
			s obj.PartsCode = ..getCode()
        }
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
			s bobj.PartsDesc=obj.PartsDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.Alias=obj.Alias
			
		}
		
		s obj.PartsDesc = eobj.PartsDesc          //修改描述
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
            d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",id,eobj.PartsDesc,"A",eobj)
            //修改时，日志
            d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsDict","CT.WDT.CDSS.BodyPartsDict","部位字典表",eobj.ID,eobj.PartsDesc,"U",eobj,bobj)
            //同步修改识别词项目数据
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("部位",eobj.PartsDesc,bobj.PartsDesc)
            //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BodyPartsDict",id,eobj.Alias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位字典表","web.CDSS.CMKB.BodyPartsDict","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位字典表","web.CDSS.CMKB.BodyPartsDict","SaveEntity",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
