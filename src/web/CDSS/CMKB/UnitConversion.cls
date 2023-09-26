/// 名称:单位转换字典表维护界面
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - Xuwenhu
/// 编写日期:2021-07-16
Class web.CDSS.CMKB.UnitConversion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：Xuwenhu		
/// CreatDate: 2021-07-16
/// Description：查询数据 
/// Table:CT.WDT.CDSS.UnitConversion 
/// Input:rowid,fromunit(从单位),tounit(到单位),conversionfactor(转换系数),state(状态),starttime(开始时间),endtime(结束时间),sortmethod(排序方式),updateuser(操作人)
/// Output:ID,FromUnitDesc,ToUnitDesc,ConversionFactor,UseFlag,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitConversion","GetList","","","","","0","","","")
Query GetList(rowid As %String, fromunit As %String, tounit As %String, conversionfactor As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %Query(ROWSPEC = "ID,FromUnitDesc,ToUnitDesc,ConversionFactor,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, fromunit As %String, tounit As %String, conversionfactor As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写	
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s FromUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),2) 	//从单位
        s:FromUnitDR'="" FromUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(FromUnitDR)),3)
        s ToUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3) 		//到单位
        s:ToUnitDR'="" ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(ToUnitDR)),3)
        s ConversionFactor=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),4)		//转换系数 
        s UseFlag=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),5) 				//状态（0编辑中，1已弃用，2已审核）
        s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
        s UpdateUser=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),6) 		//编辑人员
        s UpdateDate=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),7) 		//编辑时间
        s Remarks=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),8) 			//备注

        d OutputRow
    }
    else
    {
																	
		//默认按时间倒序排列
		k ^TempDataHandle($ZNAME,repid,$JOB,"UpdateDate")

		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.UnitConversionD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),7)				//编辑时间
			s ^TempDataHandle($ZNAME,repid,$JOB,"UpdateDate",UpdateDate,ID)=ID
		}
		s le=""
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"UpdateDate",le),-1)
			q:le=""
			s ID=0
			for
			{
				s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"UpdateDate",le,ID))
				q:ID=""
				s FromUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),2) 	//从单位
				continue:((fromunit'="")&&(FromUnitDR'=fromunit))
				s:FromUnitDR'="" FromUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(FromUnitDR)),3)
		        s ToUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3) 		//到单位
		        continue:((tounit'="")&&(ToUnitDR'=tounit))
		        s:ToUnitDR'="" ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(ToUnitDR)),3)
		        s ConversionFactor=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),4)		//转换系数 
		        continue:((conversionfactor'="")&&(ConversionFactor'=conversionfactor))
		        s ConversionFactor=$fn(ConversionFactor,"N")
		        s UseFlag=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),5) 				//状态（0编辑中，1已弃用，2已审核）
		        
        	    s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    	    continue:((state="")&&(UseFlag="已弃用"))
		        s UpdateUser=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),6) 		//编辑人员
		        continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
		        s UpdateDate=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),7) 		//编辑时间
		        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		        s Remarks=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),8) 			//备注
		        
				if ($ZCONVERT(UpdateUser,"U")[updateuser)&($ZCONVERT(UseFlag,"U")[state) 
                {
				if ((starttime'="")&&(endtime'=""))
				{
					if ($ZDH(UpdateDate,3)<=$zdh(endtime,3))&&($ZDH(UpdateDate,3)>=$zdh(starttime,3))
					{
						d OutputRow
					}
				}
				elseif ((starttime="")&&(endtime'=""))
				{
					if $ZDH(UpdateDate,3)<=$zdh(endtime,3)
					{
						d OutputRow
					}
				}
				elseif ((endtime="")&&(starttime'=""))
				{
					if $ZDH(UpdateDate,3)>=$zdh(starttime,3)
					{
						d OutputRow
					}
				}
				elseif ((endtime="")&&(starttime=""))
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
    set Data=$lb(ID,FromUnitDesc,ToUnitDesc,ConversionFactor,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    k ^TempDataHandle($ZNAME,repid,$JOB,"UpdateDate")
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

/// Creator：胡宜良
/// CreatDate: 2021-11-9
/// Description：查询  
/// Table:CT.WDT.CDSS.UnitConversion
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitConversion","GetDataForCmb1","","瓶","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "ID,FromUnitDesc,ToUnitDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s ID=rowid
	
	s FromUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),2) 	//从单位
	//continue:((fromunit'="")&&(FromUnitDR'=fromunit))
	s:FromUnitDR'="" FromUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(FromUnitDR)),3)
    s ToUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3) 		//到单位
	//continue:((tounit'="")&&(ToUnitDR'=tounit))
	s:ToUnitDR'="" ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(ToUnitDR)),3)
	
  	d OutputRowCmb
 }
 else
 {
	
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	if desc="" s desc=q
  	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.UnitConversionD(ID))
		q:ID=""
		s ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3)		//名称
		s length=$l(ToUnitDesc)
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
	}
	s le=0
	s num=0
	for
	{
		s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
		q:le=""
		s ID=0
		for
		{
			s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,ID))
			q:ID=""
			
  			s FromUnitDR= $lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),2)
  			s:FromUnitDR'="" FromUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(FromUnitDR)),3)       
		    s ToUnitDR= $lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3)
		    s:ToUnitDR'="" ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(ToUnitDR)),3)       
  			s UseFlag= $lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),5) 
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(FromUnitDesc)  
  			if (($ZCONVERT(FromUnitDesc,"U")[desc)||(PINYIN[desc))&(UseFlag=2) 
  			{
  				d OutputRowCmb
  			}
			continue:(desc'="")
			s num=num+1
			q:num=1000
		}
        q:num=1000
	}
  	
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,FromUnitDesc,ToUnitDesc)
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

/// Creator：Xuwenhu
/// CreatDate:2021-07-16
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.UnitConversion).FormValidate("","")
ClassMethod FormValidate(id As %String, fromunit As %String, tounit As %String) As %String
{
	s flag="",flagc=""
	s:fromunit'="" flagc=$d(^CT.WDT.CDSS.UnitConversionI("FromToUnitIndex",fromunit,tounit))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:fromunit'="" idc=$o(^CT.WDT.CDSS.UnitConversionI("FromToUnitIndex",fromunit,tounit,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-16
/// Description：保存单位转换字典表的内容
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：web.CDSSEntity.CMKB.UnitConversion 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.UnitConversion).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.UnitConversion) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.ID,eobj.FromUnitDR,eobj.ToUnitDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.UnitConversion).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.UnitConversion).%OpenId(eobj.ID) 			
                
                s bobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
                s bobj.ID=eobj.ID
				s bobj.FromUnitDR=obj.FromUnitDR.%Id()			//从单位
				s bobj.ToUnitDR =obj.ToUnitDR.%Id()				//到单位
				s bobj.ConversionFactor=obj.ConversionFactor	//转换系数
				s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已弃用，2已审核）
				s bobj.UpdateUser=obj.UpdateUser					//编辑人员
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
                
            }
            TS
            d obj.FromUnitDRSetObjectId(eobj.FromUnitDR)			//从单位
			d obj.ToUnitDRSetObjectId(eobj.ToUnitDR)				//到单位
			s obj.ConversionFactor=eobj.ConversionFactor			//转换系数
			s obj.UseFlag=eobj.UseFlag								//状态（0编辑中，1已弃用，2已审核）
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate						//编辑时间
			s obj.Remarks=eobj.Remarks								//备注
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                TC
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",id,eobj.FromUnitDR,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",eobj.ID,eobj.FromUnitDR,"U",eobj,bobj)
            }
            else
            {
                TRO
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位转换字典表","web.CDSS.CMKB.UnitConversion","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位转换字典表","web.CDSS.CMKB.UnitConversion","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-16
/// Description：根据ID删除单位转换字典表的内容
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：id-单位转换字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.UnitConversion).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	
    s result="" 
    s obj=##class(CT.WDT.CDSS.UnitConversion).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
    s bobj.ID=id
	s bobj.FromUnitDR=obj.FromUnitDR.%Id()				//从单位
	s bobj.ToUnitDR =obj.ToUnitDR.%Id()					//到单位
	s bobj.ConversionFactor=obj.ConversionFactor		//转换系数
	s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已弃用，2已审核）
	s bobj.UpdateUser=obj.UpdateUser					//编辑人员
	s bobj.UpdateDate=obj.UpdateDate					//编辑时间
	s bobj.Remarks=obj.Remarks							//备注
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.UnitConversion).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",id,bobj.ID,"D",bobj)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("单位转换字典表","web.CDSS.CMKB.UnitConversion","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-16
/// Description：审核、驳回、删除、恢复
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：id-单位转换字典表的rowid
/// Return：成功返回"true"；失败返回"false"}
/// Other:w ##class(web.CDSS.CMKB.UnitConversion).ChangeState("7")
ClassMethod ChangeState(id As %String, Operation As %String) As %String
{
	q:id="" "false"
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.UnitConversion).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New() 
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",id,obj.FromUnitDR_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-16
/// Description：打开时的数据
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：id-单位转换字典表的rowid
/// Return：json
/// Other:w ##class(web.CDSS.CMKB.UnitConversion)OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
	s eobj.ID = id
    s eobj.FromUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),2) 	//从单位
    s eobj.ToUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),3) 		//到单位
    s eobj.ConversionFactor=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),4)		//转换系数 
    s eobj.ConversionFactor=$fn(eobj.ConversionFactor,"N")
    s eobj.UseFlag=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),5) 				//状态（0编辑中，1已弃用，2已审核）
    s eobj.UpdateUser=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),6) 		//编辑人员
    s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),7) 		//编辑时间
    s eobj.Remarks=$lg($g(^CT.WDT.CDSS.UnitConversionD(id)),8) 			//备注

	s str = eobj.JsonS()
	d eobj.%Close()
	
	q str
}

/// Creator: Xuwenhu 
/// CreatDate: 2021-07-16
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.UnitConversion
/// Input：fromunit(从单位),tounit(到单位),conversionfactor(转换系数),state(状态),starttime(开始时间),endtime(结束时间),sortmethod(排序方式),updateuser(操作人)
/// Return：文件名称
/// Other: w ##class(web.CDSS.CMKB.UnitConversion).ExportData("","")
ClassMethod ExportData(fromunit As %String, tounit As %String, conversionfactor As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %String
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"单位转换字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"单位转换字典数据.txt"		
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
	
	w "从单位	到单位	转换系数	操作人员	操作时间	备注	状态"
	
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.UnitConversionD(ID))
		q:ID=""
		s FromUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),2) 	//从单位
		continue:((fromunit'="")&&(FromUnitDR'=fromunit))
		s:FromUnitDR'="" FromUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(FromUnitDR)),3)
        s ToUnitDR=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),3) 		//到单位
        continue:((tounit'="")&&(ToUnitDR'=tounit))
        s:ToUnitDR'="" ToUnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(ToUnitDR)),3)
        s ConversionFactor=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),4)		//转换系数 
        continue:((conversionfactor'="")&&(ConversionFactor'=conversionfactor))
        s UseFlag=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),5) 				//状态（0编辑中，1已弃用，2已审核）
        continue:((state'="")&&(UseFlag'=state))
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
        s UpdateUser=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),6) 		//编辑人员
        continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
        s UpdateDate=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),7) 		//编辑时间
        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
        s Remarks=$lg($g(^CT.WDT.CDSS.UnitConversionD(ID)),8) 			//备注
		w !,FromUnitDesc_"	"_ToUnitDesc_"	"_ConversionFactor_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag			
	}
	c file
	q fileName
}

/// Creator: Xuwenhu
/// CreatDate: 2021-07-20
/// Description：导入数据
/// Table:CT.WDT.CDSS.UnitConversion
/// Input： path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.UnitConversion).ImportData("D:\Works\文件\单位及其转换.csv")
ClassMethod ImportData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s fromunit=$p(str,",",2)			//从单位
		s tounit=$p(str,",",4)				//到单位
		s conversionfactor=$p(str,",",3)	//转换系数
		//s UseFlag=$p(str,",",5)				//是否激活，状态
		//s UseFlag=$case(UseFlag,"N":"0","Y":"1")
		//去除两端空白
		s fromunit=$zstrip(fromunit,"<>W")
		s tounit=$zstrip(tounit,"<>W")
		s conversionfactor=$zstrip(conversionfactor,"<>W")
		s readcount=readcount+1
		s FromunitDR=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(fromunit,"U"),0))
		s TounitDR=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(tounit,"U"),0))
		
		continue:((FromunitDR="")||(TounitDR=""))
		
		s RowID=$o(^CT.WDT.CDSS.UnitConversionI("FromToUnitIndex",FromunitDR,TounitDR,0))
		if (RowID="")
		{
			TS
			s bobj = ##class(CT.WDT.CDSS.UnitConversion).%New()
			d bobj.FromUnitDRSetObjectId(FromunitDR)		//从单位
        	d bobj.ToUnitDRSetObjectId(TounitDR)			//到单位
        	s bobj.ConversionFactor=conversionfactor		//转换系数
        	s bobj.UseFlag=UseFlag							//状态（0编辑中，1已弃用，2已审核）
        	s bobj.UpdateUser="dhcc"						//编辑用户
        	s bobj.UpdateDate=$ZDT($H,3)					//编辑时间
        	s bobj.Remarks=""								//备注
			
			s sc=bobj.%Save()
			d bobj.%Close()
			If $$$ISOK(sc)
            { 
            	TC
				s savecount=savecount+1
				
			}
			else
			{
				TRO
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

/// Creator: Xuwenhu
/// CreatDate: 2021-08-10
/// Description：得到转换系数，默认系数1
/// Table:CT.WDT.CDSS.UnitConversion
/// Input： path(路径)
/// Return：
/// others:w ##class(web.CDSS.CMKB.UnitConversion).GetConversion("支","盒(15)")
ClassMethod GetConversion(Unit1 As %String, Unit2 As %String) As %Float
{
	s DefaultConversion=1			//默认系数
	q:Unit1="" DefaultConversion
	s Unit1ID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(Unit1,"U"),0))
	s Unit2ID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(Unit2,"U"),0))
	
	q:((Unit1ID="")!(Unit2ID="")) DefaultConversion			
	
	s UnitID=$o(^CT.WDT.CDSS.UnitConversionI("FromToUnitIndex",Unit1ID,Unit2ID,0))
	if UnitID=""
	{
		s UnitID=$o(^CT.WDT.CDSS.UnitConversionI("FromToUnitIndex",Unit2ID,Unit1ID,0))			//如果没有此条单位转换数据，则反取数据
		if UnitID'=""
		{
			s UnitConversion=1/$lg($g(^CT.WDT.CDSS.UnitConversionD(UnitID)),4)					//转换系数为倒数
		}
		else
		{
			s UnitConversion=DefaultConversion	
		}
	}
	else
	{
		s UnitConversion=$lg($g(^CT.WDT.CDSS.UnitConversionD(UnitID)),4)				//转换系数
	}
	q UnitConversion
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.UnitConversion
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.UnitConversion).UpdateState("1","1")
ClassMethod UpdateState(id As %String, State As %String) As %String
{
	s result="" 
    s obj=##class(CT.WDT.CDSS.UnitConversion).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
    s bobj.ID=id
	s bobj.FromUnitDR=obj.FromUnitDR.%Id()				//从单位
	s bobj.ToUnitDR =obj.ToUnitDR.%Id()					//到单位
	s bobj.ConversionFactor=obj.ConversionFactor		//转换系数
	s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已弃用，2已审核）
	s bobj.UpdateUser=obj.UpdateUser					//编辑人员
	s bobj.UpdateDate=obj.UpdateDate					//编辑时间
	s bobj.Remarks=obj.Remarks							//备注
	s result=..SaveData(bobj)
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.UnitConversion
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.UnitConversion).BatchConfirm()
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
/// Table:CT.WDT.CDSS.UnitConversion
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.UnitConversion).BatchCancel()
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
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.UnitConversion
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.UnitConversion).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.UnitConversionD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.UnitConversionD(RowId)),5)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.UnitConversion","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.UnitConversion",RowId,LogID),-1) q:LogID=""
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
/// Table： CT.WDT.CDSS.UnitConversion
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.UnitConversion).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.UnitConversion) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(eobj.ID,eobj.FromUnitDR,eobj.ToUnitDR)  //调用重复验证
        if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.UnitConversion).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.UnitConversion).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.UnitConversion).%New()
			s bobj.FromUnitDR=obj.FromUnitDR.%Id()			//从单位
			s bobj.ToUnitDR =obj.ToUnitDR.%Id()				//到单位
			s bobj.ConversionFactor=obj.ConversionFactor	//转换系数
			s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
			
		}
		
		d obj.FromUnitDRSetObjectId(eobj.FromUnitDR)			//从单位
		d obj.ToUnitDRSetObjectId(eobj.ToUnitDR)				//到单位
		s obj.ConversionFactor=eobj.ConversionFactor			//转换系数
		s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",id,eobj.FromUnitDR,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.UnitConversion","CT.WDT.CDSS.UnitConversion","单位转换字典表",eobj.ID,eobj.FromUnitDR,"U",eobj,bobj)
        }
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位转换字典表","web.CDSS.CMKB.UnitConversion","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单位转换字典表","web.CDSS.CMKB.UnitConversion","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
