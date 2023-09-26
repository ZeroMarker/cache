/// 名称:定语字典表V2.0维护界面
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 徐文虎
/// 编写日期:2021-01-11
Class web.CDSS.CMKB.AttributeDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：徐文虎 		
/// CreatDate: 2021-01-11
/// Description：查询数据 
/// Table:CT.WDT.CDSS.AttributeDict 
/// Input:rowid,Attributedesc,Applyarea(适用范围),state(状态),starttime(开始时间),endtime(结束时间)，sortmethod(排序方式),updateuser(操作人)
/// Output:ID,AttributeCode,AttributeDesc,Applyarea,UseFlag,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AttributeDict","GetList","","测试","","","","","","")
Query GetList(rowid As %String, attributedesc As %String, alias As %String, applyarea As %String, state As %String, starttime As %String, endtime As %String, sortmethod As %String, updateuser As %String) As %Query(ROWSPEC = "ID:%String,AttributeCode:%String,AttributeDesc:%String,Applyarea:%String,UseFlag:%String,UpdateUser:%String,UpdateDate:%String,Remarks:%String,AttributeAlias:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, attributedesc As %String, alias As %String, applyarea As %String, state As %String, starttime As %String, endtime As %String, sortmethod As %String, updateuser As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s AttributeCode=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),2) //定语代码
        s AttributeDesc=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3) //定语名称
        s Applyarea=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),8) //适用范围
        s UseFlag=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),4) //状态（0编辑中,1已弃用,2已审核）
        s:UseFlag=0 UseFlag="编辑中"
        s:UseFlag=1 UseFlag="已弃用"
        s:UseFlag=2 UseFlag="已审核"
    
        s UpdateUser=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),5) //编辑人员
        s UpdateDate=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),6) //编辑时间
        s Remarks=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),7) //备注
        s AttributeAlias= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),9)        //别名

        d OutputRow
    }
    else
    {
		s:attributedesc'="" attributedesc=$ZCONVERT(attributedesc,"U") //转换成大写
		s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
		s:applyarea'="" applyarea=$ZCONVERT(applyarea,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.AttributeDictD(ID))
				q:ID=""
				s AttributeDictName= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3)		//名称
				s length=$l(AttributeDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.AttributeDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),6)				//编辑时间
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
	       	
	       		s AttributeCode=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),2) //定语代码
        		s AttributeDesc=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3) //定语名称
        		continue:((attributedesc'="")&&($ZCONVERT(AttributeDesc,"U")'[attributedesc))
        		s Applyarea=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),8) //适用范围
        		continue:((applyarea'="")&&($ZCONVERT(Applyarea,"U")'[applyarea))
        		s UseFlag=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),4) //状态（0编辑中,1已弃用,2已审核）
        		if (state="1"){
					continue:(UseFlag'=state)			
				}
				else{
					continue:(UseFlag="1")
					continue:((state'="")&&(UseFlag'=state))
				}
        		s:UseFlag=0 UseFlag="编辑中"
            	s:UseFlag=1 UseFlag="已弃用"
            	s:UseFlag=2 UseFlag="已审核"
    
        		s UpdateUser=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),5) //编辑人员
        		continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
        		s UpdateDate=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),6) //编辑时间
        		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
        		s Remarks=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),7) //备注
        		s AttributeAlias= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),9)        //别名
	    		continue:((alias'="")&&($ZCONVERT(AttributeAlias,"U")'[alias))
        	
				d OutputRow
       		}
	  	}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,AttributeCode,AttributeDesc,Applyarea,UseFlag,UpdateUser,UpdateDate,Remarks,AttributeAlias)
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

/// Creator：徐文虎
/// CreatDate:2021-01-11
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.AttributeDict
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.AttributeDict).FormValidate("","")
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc=""
	s:desc'="" flagc=$d(^CT.WDT.CDSS.AttributeDictI("DescIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:desc'="" idc=$o(^CT.WDT.CDSS.AttributeDictI("DescIndex",desc,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.AttributeDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.AttributeDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.AttributeDictI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.AttributeDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.AttributeDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:徐文虎
/// CreatDate:2021-01-11
/// Description：保存定语字典表的内容
/// Table：CT.WDT.CDSS.AttributeDict
/// Input：web.CDSSEntity.CMKB.AttributeDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.AttributeDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.AttributeDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,$zstrip(eobj.AttributeDesc,"<>W"))  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.AttributeDesc,eobj.AttributeAlias)		//调用别名重复验证
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
                s obj=##class(CT.WDT.CDSS.AttributeDict).%New()                
                s eobj.AttributeCode=$o(^CT.WDT.CDSS.AttributeDictD(""),-1)+1
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.AttributeDict).%OpenId(eobj.ID) 
                s eobj.AttributeCode=obj.AttributeCode				
                
                s bobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
                s bobj.ID=eobj.ID
				s bobj.AttributeCode=obj.AttributeCode			//代码
				s bobj.AttributeDesc =obj.AttributeDesc			//名称
				s bobj.Applyarea=obj.Applyarea                      //适用范围
				s bobj.UseFlag=obj.UseFlag							//状态（0编辑中,1已弃用,2已审核）
				s bobj.UpdateUser=obj.UpdateUser					//编辑人员
				s bobj.UpdateDate=obj.UpdateDate						//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
				s bobj.AttributeAlias=obj.AttributeAlias
            }
            Ts
            s obj.AttributeCode=eobj.AttributeCode			//代码
			s obj.AttributeDesc=eobj.AttributeDesc			//名称
			s obj.Applyarea=eobj.Applyarea                      //适用范围
			s:eobj.UseFlag="0" obj.UseFlag=0
			s:eobj.UseFlag="2" obj.UseFlag=2
			s:eobj.UseFlag="1" obj.UseFlag=1				//状态（0编辑中,1已弃用,2已审核）
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate						//编辑时间
			s obj.Remarks=eobj.Remarks							//备注
			s obj.AttributeAlias=eobj.AttributeAlias
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",id,eobj.AttributeDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",eobj.ID,eobj.AttributeDesc,"U",eobj,bobj)
                //同步修改识别词项目数据
            	d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("定语",eobj.AttributeDesc,bobj.AttributeDesc)
                //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.AttributeAlias'=""))||((eobj.ID'="")&&(eobj.AttributeAlias'=bobj.AttributeAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.AttributeDict",id,eobj.AttributeAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("定语字典表","web.CDSS.CMKB.AttributeDict","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("定语字典表","web.CDSS.CMKB.AttributeDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:徐文虎
/// CreatDate:2021-01—11
/// Description：根据ID删除定语字典表的内容
/// Table：CT.WDT.CDSS.AttributeDict
/// Input：id-定语字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.AttributeDict).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	
    s result="" 
    s re=##class(web.CDSS.CMKB.AttributeDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)      //说明：改成前台调用
    if (RefFlag'=0){
	    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"    
	}
	else
	{
    s obj=##class(CT.WDT.CDSS.AttributeDict).%OpenId(id)   
       
    s bobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
    s bobj.ID=id
	s bobj.AttributeCode=obj.AttributeCode 			 //代码
	s bobj.AttributeDesc=obj.AttributeDesc 			//名称
	s bobj.Applyarea=obj.Applyarea                      //适用范围
	s bobj.UseFlag=obj.UseFlag							//状态（0编辑中,1已弃用,2已审核）
	s bobj.UpdateUser=obj.UpdateUser 					//编辑用户
	s bobj.UpdateDate=obj.UpdateDate 				//编辑时间
	s bobj.Remarks=obj.Remarks							//备注
	s bobj.AttributeAlias=obj.AttributeAlias							//别名
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.AttributeDict).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",id,bobj.ID,"D",bobj)
        //删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.AttributeDict",id)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("定语字典表","web.CDSS.CMKB.AttributeDict","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
	}
     q result
}

/// Creator:徐文虎
/// CreatDate:2021-01—29
/// Description：审核、驳回、删除、恢复
/// Table：CT.WDT.CDSS.AttributeDict
/// Input：id-定语字典表的rowid
/// Return：成功返回"true"；失败返回"false"}
/// Other:w ##class(web.CDSS.CMKB.AttributeDict).ChangeState("607",1)
ClassMethod ChangeState(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.AttributeDict).%OpenId(id)
	s bobj=##class(web.CDSSEntity.CMKB.AttributeDict).%New()
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",id,obj.AttributeDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Other: w ##class(web.CDSS.CMKB.AttributeDict).UpdateUseFlag(607,1)
ClassMethod UpdateUseFlag(id, State) As %String
{
	s result=""

	s obj=##class(CT.WDT.CDSS.AttributeDict).%OpenId(id)
	s obj.UseFlag=State
	s obj.UpdateDate=$zdt($h,3)
 	s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/// Creator: 徐文虎 
/// CreatDate: 2021-01-11
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.AttributeDict
/// Input： attributecode(代码), attributedesc(名称)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).ExportMapping("","","","","","")
ClassMethod ExportMapping(attributedesc As %String, alias As %String, applyarea As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %String
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"定语字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"定语字典数据.txt"		
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
	
	w "定语代码	定语名称  别名	适用范围	状态	操作人员	操作时间	备注"
	
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	s:attributedesc'="" attributedesc=$ZCONVERT(attributedesc,"U") //转换成大写
	s:applyarea'="" applyarea=$ZCONVERT(applyarea,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.AttributeDictI("UpdateDateIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.AttributeDictI("UpdateDateIndex",UpdateTime,ID))
			q:ID=""
			s AttributeCode= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),2)		//代码
			s AttributeDesc=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3)			//名称
			continue:((attributedesc'="")&&($ZCONVERT(AttributeDesc,"U")'[attributedesc))
			s Applyarea=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),8)			//适用范围
			s UseFlag=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),4)		//状态（0编辑中,1已弃用,2已审核）
			if (state="1"){
				continue:(UseFlag'=state)			
			}
			else{
				continue:(UseFlag="1")
				continue:((state'="")&&(UseFlag'=state))
			}
        	s:UseFlag=0 UseFlag="编辑中"
        	s:UseFlag=1 UseFlag="已弃用"
        	s:UseFlag=2 UseFlag="已审核"
			s UpdateUser=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),5)			//修改用户
			continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
			s UpdateDate=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),6)		//修改时间
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			s Remarks=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),7)		//备注
			s AttributeAlias= $lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),9)        //别名
			continue:(($ZCONVERT(AttributeAlias,"U")'[alias)&&(alias'=""))
			//替换双引号
			s AttributeCode=$replace(AttributeCode,"""","”")
			s AttributeDesc=$replace(AttributeDesc,"""","”")
			s Applyarea=$replace(Applyarea,"""","”")
			s UpdateUser=$replace(UpdateUser,"""","”")
			s UpdateDate=$replace(UpdateDate,"""","”")
			s UseFlag=$replace(Remarks,"""","”")
			s AttributeAlias=$replace(AttributeAlias,"""","”")
			s Remarks=$replace(Remarks,"""","”")
		
			w !,AttributeCode_"	"_AttributeDesc_"	"_AttributeAlias_"	"_Applyarea_"	"_UseFlag_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks				
		}
	}
	c file
	q fileName
}

/// Creator：徐文虎 		
/// CreatDate: 2021-01-20
/// Description：查询在用数据下拉框，JS调用 
/// Table:CT.WDT.CDSS.AttributeDict 
/// Input:rowid,
/// Output:ID,AttributeCode,AttributeDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AttributeDict","GetDataForCmb1","","","皱褶处")
Query GetDataForCmb1(rowid As %String, desc As %String = "", q As %String = "") As %Query(ROWSPEC = "ID:%String,AttributeCode:%String,AttributeDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s AttributeCode=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),2) //定语代码
        s AttributeDesc=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3) //定语名称
        d OutputRowCmb
    }
    else
    {
        s:desc="" desc=q
  		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  		s ID=0
        for {
            s ID=$o(^CT.WDT.CDSS.AttributeDictD(ID))
            q:ID=""
	       	s AttributeCode=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),2) //定语代码
        	s AttributeDesc=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),3) //定语名称
        	s UseFlag=$lg($g(^CT.WDT.CDSS.AttributeDictD(ID)),4) //状态（0编辑中,1已弃用,2已审核）
    		s AttributeDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(AttributeDesc)
			if (($ZCONVERT(AttributeDesc,"U")[desc)||(AttributeDescPY[desc)&(($ZCONVERT(AttributeDesc,"U")[q)||(AttributeDescPY[q))&(UseFlag=2))
			{
				d OutputRowCmb
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,AttributeCode,AttributeDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator: 徐文虎 
/// CreatDate: 2021-01-27
/// Description：导入数据,注意修改保存方法UpdateUser
/// Table:CT.WDT.CDSS.AttributeDict
/// Input： path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).ImportData("")
ClassMethod ImportData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s num=0
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s num=num+1
		s Code=num						//代码
		s Desc=$p(str,",",1)			//描述

		//去除两端空白
		//s Code=$zstrip(Code,"<>W")
		s Desc=$zstrip(Desc,"<>W")
		s readcount=readcount+1
		
		s RowID=$o(^CT.WDT.CDSS.AttributeDictI("CodeIndex"," "_Code,0))
		if (RowID="")
		{
			s bobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
			s bobj.ID = ""
			s bobj.AttributeCode=Code					//功能代码
        	s bobj.AttributeDesc=Desc							//功能名称
        	s bobj.Applyarea=Area                       //适用范围
        	s bobj.UseFlag="0"								//状态
        	s bobj.UpdateUser="dhcc"					//编辑用户
			
			s re=..SaveData(bobj)
			if (re["true")
			{
				s savecount=savecount+1
				
			}
			else
			{
				s nosavecount=nosavecount+1	
			}
				
		}
		else
		{
			s incount=incount+1
			continue	
		}
		
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.AttributeDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).BatchConfirm()
ClassMethod BatchConfirm(idstr As %String, hosp As %String, type As %String)
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
			s re= ..ChangeState(ConID,"通过")
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
/// Table:CT.WDT.CDSS.AttributeDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).BatchCancel()
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
			s re= ..ChangeState(ConID,"驳回")
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
/// CreatDate:2022-1-19
/// Description:获得别名列表
/// Table:CT.WDT.CDSS.AttributeDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AttributeDict","GetAliasList","607")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s AttributeAlias=$LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),9)
		s Len=$Length(AttributeAlias,",")
		for i=1:1:Len{
			s Desc=$p(AttributeAlias,",",i)
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
/// Table:CT.WDT.CDSS.AttributeDict
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.AttributeDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.AttributeDictD(RowId)),9)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.AttributeDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-25
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.AttributeDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.AttributeDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.AttributeDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.AttributeDictD(RowId)),4)       
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
/// CreatDate: 2022-03-01
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.AttributeDict).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //识别词项目引用接口
    s AttributeDesc= $lg($g(^CT.WDT.CDSS.AttributeDictD(id)),3) 	 
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("定语",AttributeDesc)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr	
    
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AttributeDict","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.AttributeDict",RowId,LogID),-1) q:LogID=""
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

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.AttributeDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.AttributeDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.AttributeDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,$zstrip(eobj.AttributeDesc,"<>W"))  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.AttributeDesc,eobj.AttributeAlias)		//调用别名重复验证
        if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
			
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			 s obj=##class(CT.WDT.CDSS.AttributeDict).%New()                
             s eobj.AttributeCode=$o(^CT.WDT.CDSS.AttributeDictD(""),-1)+1
            }
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.AttributeDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
			s bobj.AttributeDesc=obj.AttributeDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.AttributeAlias=obj.AttributeAlias
			
		}
		
		s obj.AttributeDesc = eobj.AttributeDesc          //修改描述
        s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        s obj.AttributeAlias=eobj.AttributeAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",id,eobj.AttributeDesc,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AttributeDict","CT.WDT.CDSS.AttributeDict","定语字典表",eobj.ID,eobj.AttributeDesc,"U",eobj,bobj)
            //同步修改识别词项目数据
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("定语",eobj.AttributeDesc,bobj.AttributeDesc)
            //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.AttributeAlias'=""))||((eobj.ID'="")&&(eobj.AttributeAlias'=bobj.AttributeAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.AttributeDict",id,eobj.AttributeAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("定语字典表","web.CDSS.CMKB.AttributeDict","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("定语字典表","web.CDSS.CMKB.AttributeDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Other: w ##class(web.CDSS.CMKB.AttributeDict).NewOpenData("607")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.AttributeDict).%New()
	s eobj.ID = id
	s eobj.AttributeCode = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),2)
	s eobj.AttributeDesc = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),3)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),4)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),5)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),6)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),7)
	s eobj.Applyarea=$LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),8)
	s eobj.AttributeAlias=$LISTGET($G(^CT.WDT.CDSS.AttributeDictD(id)),9)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

}
