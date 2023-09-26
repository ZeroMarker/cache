/// 名称:会诊医嘱字典表V2.0维护界面 
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 徐文虎
/// 编写日期:2021-01-27
Class web.CDSS.CMKB.ConsultationDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：徐文虎 		
/// CreatDate: 2021-01-07
/// Description：查询数据 
/// Table:CT.WDT.CDSS.ConsultationDict 
/// Input:rowid, consultationdesc(会诊名称),state(状态),starttime(开始时间),endtime(结束时间),sortmethod(排序方式),updateuser(操作人)
/// Output:ID,ConsultCode,ConsultDesc,UseFlag,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ConsultationDict","GetList","","","","1","","Short","")
Query GetList(rowid As %String, consultationdesc As %String, alias As %String, state As %String, timescope As %String, sortmethod As %String, updateuser As %String) As %Query(ROWSPEC = "ID:%String,ConsultCode:%String,ConsultDesc:%String,UseFlag:%String,UpdateUser:%String,UpdateDate:%String,Remarks:%String,ConsultAlias:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, consultationdesc As %String, alias As %String, state As %String, timescope As %String, sortmethod As %String, updateuser As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s ConsultCode=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2) //会诊代码
        s ConsultDesc=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3) //会诊名称
        s UseFlag=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),4) //状态
        s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
    
        s UpdateUser=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),5) //编辑人员
        s UpdateDate=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),6) //编辑时间
        s Remarks=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),7) //备注
		s ConsultAlias=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),8) //别名
        d OutputRow
    }
    else
    {
		s:consultationdesc'="" consultationdesc=$ZCONVERT(consultationdesc,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.ConsultationDictD(ID))
				q:ID=""
				//s ConsultationCode= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2)		//代码
				s ConsultName= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3)		//名称
				s length=$l(ConsultName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
			
		}
		else
		{																		//默认按时间倒序排列
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.ConsultationDictD(ID))
				q:ID=""
				//s ConsultationCode= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2)		//代码
				s UpdateDate= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),6)				//编辑时间
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
		       	s ConsultCode=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2) //会诊代码
	        	s ConsultDesc=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3) //会诊名称
	        	continue:((consultationdesc'="")&&($ZCONVERT(ConsultDesc,"U")'[consultationdesc))
	        	s UseFlag=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),4) //状态（0编辑中，1已弃用,2已审核）
	        	s:UseFlag="" UseFlag=0
				if (state="")
				{
					continue:(UseFlag="1")	
				}else
				{
					continue:(UseFlag'=state)
				}
	        	/*
	        	if (state="2"){
					continue:(UseFlag'=state)			
				}
				else{
					continue:(UseFlag="2")
					continue:((state'="")&&(UseFlag'=state))
				}
	        	s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
	    		*/
	        	s UpdateUser=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),5) //编辑人员
	        	continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
	        	s starttime=$p(timescope,"^",1)
	    		s endtime=$p(timescope,"^",2)
	        	s UpdateDate=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),6) //编辑时间
	        	continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
	        	s Remarks=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),7) //备注
	        	s ConsultAlias=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),8) //别名
	        	continue:((alias'="")&&($ZCONVERT(ConsultAlias,"U")'[alias))
				//s ConsultationDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ConsultationDesc)
				//continue:((Consultationdesc'="")&&($ZCONVERT(ConsultationDescPY,"U")'[Consultationdesc)&&($ZCONVERT(ConsultationDesc,"U")'[Consultationdesc))
				d OutputRow
	        }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,ConsultCode,ConsultDesc,UseFlag,UpdateUser,UpdateDate,Remarks,ConsultAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
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

/// Creator：徐文虎
/// CreatDate:2021-01-07
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.ConsultationDict).FormValidate("","哈哈")
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc=""
	s:desc'="" flagc=$d(^CT.WDT.CDSS.ConsultationDictI("DescIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:desc'="" idc=$o(^CT.WDT.CDSS.ConsultationDictI("DescIndex",desc,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.LabSpecimenDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.ConsultationDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.ConsultationDictI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.ConsultationDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.ConsultationDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate:2021-01-07
/// Description：保存会诊医嘱字典表的内容
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input：web.CDSSEntity.CMKB.ConsultationDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.ConsultationDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.ConsultationDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,$zstrip(eobj.ConsultDesc,"<>W"))  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
            
        }
	    s flagAlias=..ValidateAlias(eobj.ID,eobj.ConsultDesc,eobj.ConsultAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.ConsultationDict).%New() 
                s eobj.ConsultCode=$o(^CT.WDT.CDSS.ConsultationDictD(""),-1)+1              
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.ConsultationDict).%OpenId(eobj.ID) 
                s eobj.ConsultCode=obj.ConsultCode				
                
                s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
                s bobj.ID=eobj.ID
				s bobj.ConsultCode=obj.ConsultCode			//代码
				s bobj.ConsultDesc =obj.ConsultDesc			//名称
				s bobj.UseFlag=obj.UseFlag							//状态（0已审核，1编辑中,2已删除）
				s bobj.UpdateUser=obj.UpdateUser					//编辑人员
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
                s bobj.ConsultAlias=obj.ConsultAlias		//别名	
            }
            Ts
            s obj.ConsultCode=eobj.ConsultCode			//代码
			s obj.ConsultDesc=eobj.ConsultDesc			//名称
			s obj.UseFlag=eobj.UseFlag				//状态（0编辑中，1已弃用,2已审核）
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))				//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)				//编辑时间
			s obj.UpdateDate=eobj.UpdateDate
			s obj.Remarks=eobj.Remarks						//备注
			s obj.ConsultAlias=eobj.ConsultAlias		//别名	
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",id,eobj.ConsultDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",eobj.ID,eobj.ConsultDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.ConsultAlias'=""))||((eobj.ID'="")&&(eobj.ConsultAlias'=bobj.ConsultAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ConsultationDict",id,eobj.ConsultAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("会诊医嘱字典","web.CDSS.CMKB.ConsultationDict","SaveData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
                     
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("会诊医嘱字典","web.CDSS.CMKB.ConsultationDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:徐文虎
/// CreatDate:2021-01—07
/// Description：根据ID删除会诊医嘱字典表的内容
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input：id-会诊医嘱字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.ConsultationDict).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	
    s result="" 
    s obj=##class(CT.WDT.CDSS.ConsultationDict).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
    s bobj.ID=id
	s bobj.ConsultCode=obj.ConsultCode 			 //代码
	s bobj.ConsultDesc=obj.ConsultDesc 			//名称
	s bobj.UseFlag=obj.UseFlag							//状态
	s bobj.UpdateUser=obj.UpdateUser 					//编辑用户
	s bobj.UpdateDate=obj.UpdateDate 				//编辑时间
	s bobj.Remarks=obj.Remarks							//备注
	s bobj.ConsultAlias=obj.ConsultAlias		//别名
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.ConsultationDict).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",id,bobj.ConsultDesc,"D",bobj)
        
        //同步删除别名通用表中数据 
		d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.ConsultationDict",id)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("会诊医嘱字典","web.CDSS.CMKB.ConsultationDict","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator: 徐文虎 
/// CreatDate: 2021-01-11
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConsultationDict
/// Input： Consultationcode(代码), Consultationdesc(名称)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).ExportMapping("","")
ClassMethod ExportMapping(Consultationdesc As %String, alias As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"会诊医嘱字典数据.txt"		
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
	
	w "会诊代码	会诊名称	别名	状态	操作人员	操作时间	备注"
	
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:Consultationdesc'="" Consultationdesc=$ZCONVERT(Consultationdesc,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConsultationDictD(ID))
		q:ID=""
		s ConsultationCode= $lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2)		//代码
		s ConsultationDesc=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3)			//名称
		continue:((Consultationdesc'="")&&($ZCONVERT(ConsultationDesc,"U")'[Consultationdesc))
		s UseFlag=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),4) //状态
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"")
       
        s UpdateUser=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),5) //编辑人员
        continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
        s UpdateDate=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),6) //编辑时间
        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
        s Remarks=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),7) //备注
        s ConsultAlias=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),8) //别名
		continue:((alias'="")&&($ZCONVERT(ConsultAlias,"U")'[alias))
		w !,ConsultationCode_"	"_ConsultationDesc_"	"_ConsultAlias_"	"_UseFlag_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks
	}
	c file
	q fileName
}

/// Creator：徐文虎 		
/// CreatDate: 2021-01-20
/// Description：查询在用数据下拉框，JS调用 
/// Table:CT.WDT.CDSS.ConsultationDict 
/// Input:rowid,
/// Output:ID,ConsultationCode,ConsultationDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ConsultationDict","GetDataForCmb1","")
Query GetDataForCmb1(rowid As %String) As %Query(ROWSPEC = "ID:%String,ConsultCode:%String,ConsultDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String) As %Status
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
        s ConsultCode=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2) //会诊代码
        s ConsultDesc=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3) //会诊名称
        d OutputRow
    }
    else
    {
        s ID=0
        for {
            s ID=$o(^CT.WDT.CDSS.ConsultationDictD(ID))
            q:ID=""
	       	s ConsultCode=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),2) //会诊代码
        	s ConsultDesc=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),3) //会诊名称
        	s UseFlag=$lg($g(^CT.WDT.CDSS.ConsultationDictD(ID)),4) //状态
    		//continue:(UseFlag'=0)
			if ((UseFlag=2))
			{
				d OutputRow
			}
			//s ConsultationDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ConsultationDesc)
			//continue:((Consultationdesc'="")&&($ZCONVERT(ConsultationDescPY,"U")'[Consultationdesc)&&($ZCONVERT(ConsultationDesc,"U")'[Consultationdesc))
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,ConsultCode,ConsultDesc)
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
/// Table:CT.WDT.CDSS.ConsultationDict
/// Input： path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).ImportData("E:\Works\任务\会诊医嘱字典.csv")
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
		s Desc=$p(str,",",2)			//描述

		//去除两端空白
		//s Code=$zstrip(Code,"<>W")
		s Desc=$zstrip(Desc,"<>W")
		s readcount=readcount+1
		
		s RowID=$o(^CT.WDT.CDSS.ConsultationDictI("CodeIndex"," "_Code,0))
		if (RowID="")
		{
			s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
			s bobj.ID = ""
			s bobj.ConsultCode=Code					//功能代码
        	s bobj.ConsultDesc=Desc							//功能名称
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

/// Creator：赵文伟
/// CreatDate:2021-10-27
/// Input:RowId  Operation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ConsultationDict).ChangeStatus(003,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.ConsultationDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",RowId,obj.ConsultDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-21
/// Description: 批量通过
/// Table: CT.WDT.CDSS.ConsultationDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).ChangeStatusPass("")
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

			s flag=..ChangeStatus(id,"通过")

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
/// CreatDate: 2021-10-21
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.ConsultationDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).ChangeStatusBack("")
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

			s flag=..ChangeStatus(id,"驳回")

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

/// Creator：赵文伟
/// CreatDate: 2020-11-01
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.ConsultationDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New() 
	
	s bobj.ConsultCode=obj.ConsultCode 			 //代码
	s bobj.ConsultDesc=obj.ConsultDesc 			//名称
	s bobj.UseFlag=obj.UseFlag							//状态
	s bobj.UpdateUser=obj.UpdateUser 					//编辑用户
	s bobj.UpdateDate=obj.UpdateDate 				//编辑时间
	s bobj.Remarks=obj.Remarks
	s bobj.ConsultAlias=obj.ConsultAlias		//别名
	
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:赵文伟
/// CreatDate:2021-01-18
/// Description:获得别名列表
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ConsultationDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s ConsultAlias = $lg($g(^CT.WDT.CDSS.ConsultationDictD(id)),8)
		s Len=$Length(ConsultAlias,",")
		for i=1:1:Len{
			s Desc=$p(ConsultAlias,",",i)
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
/// Table: CT.WDT.CDSS.ConsultationDict
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.ConsultationDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.ConsultationDictD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ConsultationDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.ConsultationDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.ConsultationDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.ConsultationDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.ConsultationDictD(RowId)),4)       
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

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ConsultationDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.ConsultationDict",RowId,LogID),-1) q:LogID=""
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
/// Table：CT.WDT.CDSS.ConsultationDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.ConsultationDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.ConsultationDict) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,$zstrip(eobj.ConsultDesc,"<>W"))  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.ConsultDesc,eobj.ConsultAlias)		//调用别名重复验证
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
                s obj=##class(CT.WDT.CDSS.ConsultationDict).%New() 
                s eobj.ConsultCode=$o(^CT.WDT.CDSS.ConsultationDictD(""),-1)+1              
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.ConsultationDict).%OpenId(eobj.ID) 
                s eobj.ConsultCode=obj.ConsultCode				
                
                s bobj = ##class(web.CDSSEntity.CMKB.ConsultationDict).%New()
                s bobj.ID=eobj.ID
				s bobj.ConsultCode=obj.ConsultCode			//代码
				s bobj.ConsultDesc =obj.ConsultDesc			//名称
				s bobj.UpdateUser=obj.UpdateUser					//编辑人员
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
                s bobj.ConsultAlias=obj.ConsultAlias		//别名	
            }
            Ts
            s obj.ConsultCode=eobj.ConsultCode			//代码
			s obj.ConsultDesc=eobj.ConsultDesc			//名称
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))				//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)				//编辑时间
			s obj.UpdateDate=eobj.UpdateDate
			s obj.ConsultAlias=eobj.ConsultAlias		//别名	
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",id,eobj.ConsultDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConsultationDict","CT.WDT.CDSS.ConsultationDict","会诊医嘱字典",eobj.ID,eobj.ConsultDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.ConsultAlias'=""))||((eobj.ID'="")&&(eobj.ConsultAlias'=bobj.ConsultAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ConsultationDict",id,eobj.ConsultAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("会诊医嘱字典","web.CDSS.CMKB.ConsultationDict","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("会诊医嘱字典","web.CDSS.CMKB.ConsultationDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
