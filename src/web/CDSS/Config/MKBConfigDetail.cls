/// Creator:Xuwenhu
/// Description:平台配置子表
/// CreateDate:2022-04-26
Class web.CDSS.Config.MKBConfigDetail Extends %RegisteredObject
{

/// Creator：Xuwenhu 		
/// CreatDate: 2022-04-26
/// Description：查询子表数据 
/// Table:CF.WDT.CDSS.MKBConfigDetail
/// Input:base 【CDetailParRef】
/// Output:CHRowId,CDetailValue,CDetailActive,HospitalDR,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfigDetail","GetChildList","31")
Query GetChildList(base As %String) As %Query(ROWSPEC = "CHRowId,CDetailValue,CDetailActive,CDetailType,HospitalDesc,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetChildListExecute(ByRef qHandle As %Binary, base As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (base'="")
	{
		s ConfigChildSub = ""
		for
		{
			s ConfigChildSub = $O(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub))
			q:ConfigChildSub=""
			s CHRowId = base_"||"_ConfigChildSub
			s CDetailValue = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),2)		//配置项值
			
			s CDetailActive = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),3)		//是否激活
			//s HospitalDR = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),4)			//医院院区
			//s:HospitalDR'="" obj=##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(HospitalDR) 
			//s:HospitalDR'="" HospAreaDesc=obj.HospAreaDesc
			//s HospitalDesc=$lg($g(^User.DHCDSSCustomerHospD(HospitalDR)),3)
			//s HospitalDR = $LG($G(^User.DHCDSSCustomerHospD(hospid,"ChildExt",ConfigChildSub)),4)			//医院院区
			//s HospAreaDesc = $LG($G(^User.DHCDSSCustomerHospD(hosid,"ChildExt",HosChildSub)),3)		//院区名称
			s CDetailType = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),4)			//类型
			s HospitalDesc = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),5)			//配置对象
			s UpdateUser = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),6)			//编辑人员
			s UpdateDate = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),7)			//编辑时间
			s Remarks =	$LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),8)				//备注
			d OutputRow	
		}	
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CHRowId,CDetailValue,CDetailActive,CDetailType,HospitalDesc,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetChildListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChildListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetChildListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChildListExecute ]
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

/// Creator：Xuwenhu
/// CreatDate: 202-04-26
/// Description：数据重复验证 重复返回1
/// Table：CF.WDT.CDSS.MKBConfigDetail
/// Input：id, base.desc
/// Other: w ##class(web.CDSS.Config.MKBConfigDetail).FormValidate()
ClassMethod FormValidate(id, base, desc) As %String
{
	q:base="" 1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CF.WDT.CDSS.MKBConfigDetailI("ValueIndex",base," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=base_"||"_$o(^CF.WDT.CDSS.MKBConfigDetailI("ValueIndex",base," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Other: w ##class(web.CDSS.Config.MKBConfigDetail).TestSaveData()
ClassMethod TestSaveData() As %String
{
	
	s eobj = ##class(web.CDSSEntity.Config.MKBConfigDetail).%New()
	s eobj.RowId="22||11"
	s eobj.CDetailParRef=22
	s eobj.CDetailValue="苏州科技城医院"
	s eobj.HospitalDR="22||4"
	s eobj.CDetailActive="Y"
	s eobj.UpdateDate="2022-05-08 15:02:05"
	s eobj.UpdateUser="ZWW"
	s eobj.Remarks="测试"
	
	w ..SaveData(eobj)
	q ""
}

/// Creator:Xuwenhu
/// CreatDate:2022-04-26
/// Description：保存平台配置子表的内容
/// Table：CF.WDT.CDSS.MKBConfigDetail
/// Input：web.CDSSEntity.Config.MKBConfigDetail 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.Config.MKBConfigDetail).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Config.MKBConfigDetail) As %String
{
   	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.RowId,eobj.CDetailParRef,eobj.CDetailValue)  		//调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.RowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(CF.WDT.CDSS.MKBConfigDetail).%New()  
                           
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CF.WDT.CDSS.MKBConfigDetail).%OpenId(eobj.RowId) 				
                
                s bobj = ##class(web.CDSSEntity.Config.MKBConfigDetail).%New()
                s bobj.RowId=obj.%Id()
                s bobj.CDetailParRef=obj.CDetailParRef.%Id()
				s bobj.CDetailValue=obj.CDetailValue			// 配置项值
        		s bobj.CDetailActive=obj.CDetailActive			// 是否激活
        		//s bobj.HospitalDR=obj.HospitalDR.%Id()			// 医院院区、
        		s bobj.CDetailType=obj.CDetailType				//类型
        		s bobj.HospitalDesc=obj.HospitalDesc			//配置对象
        		s bobj.UpdateUser=obj.UpdateUser				// 编辑人员
        		s bobj.UpdateDate=obj.UpdateDate				// 编辑时间
        		s bobj.Remarks=obj.Remarks						// 备注
        		
            }
            Ts
            d obj.CDetailParRefSetObjectId(eobj.CDetailParRef)
            
            s obj.CDetailValue=eobj.CDetailValue				// 配置项值
			s obj.CDetailActive=eobj.CDetailActive				// 是否激活
			
        	//d obj.HospitalDRSetObjectId(eobj.HospitalDR)			// 医院院区
        	s obj.CDetailType=eobj.CDetailType
        	s obj.HospitalDesc=eobj.HospitalDesc
        	s obj.UpdateUser=eobj.UpdateUser					// 编辑人员
        	s obj.UpdateDate=eobj.UpdateDate					// 编辑时间
        	s obj.Remarks=eobj.Remarks							// 备注
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfigDetail","CF.WDT.CDSS.MKBConfigDetail","平台配置子表",id,eobj.CDetailValue,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfigDetail","CF.WDT.CDSS.MKBConfigDetail","平台配置子表",eobj.RowId,eobj.CDetailValue,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置子表","web.CDSS.Config.MKBConfigDetail","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置子表","web.CDSS.Config.MKBConfigDetail","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2022-04—26
/// Description：根据ID删除平台配置子表的内容
/// Table：CF.WDT.CDSS.MKBConfigDetail
/// Input：id-平台配置子表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Config.MKBConfigDetail).DeleteData("31||9")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    if ($D(^CF.WDT.CDSS.MKBConfigD($P(id,"||",1),"ConfigChildRef",$P(id,"||",2)))=0)
	{
		s result = "{success:'false',info:'入参不存在！'}"
		q result	
	}
	//Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}" 
    s obj=##class(CF.WDT.CDSS.MKBConfigDetail).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Config.MKBConfigDetail).%New()
    s bobj.RowId=id
    s bobj.CDetailParRef=obj.CDetailParRef.%Id()
	s bobj.CDetailValue=obj.CDetailValue			// 配置项值
	s bobj.CDetailActive=obj.CDetailActive			// 是否激活
	//s bobj.HospitalDR=obj.HospitalDR.%Id()			// 医院院区
	s bobj.CDetailType=obj.CDetailType
	s bobj.HospitalDesc=obj.HospitalDesc
	s bobj.UpdateUser=obj.UpdateUser				// 编辑人员
	s bobj.UpdateDate=obj.UpdateDate				// 编辑时间
	s bobj.Remarks=obj.Remarks						// 备注
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CF.WDT.CDSS.MKBConfigDetail).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfigDetail","CF.WDT.CDSS.MKBConfigDetail","平台配置子表",id,bobj.RowId,"D",bobj)
        d bobj.%Close()   
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置子表","web.CDSS.Config.MKBConfigDetail","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-04-26
/// Description：数据打开方法
/// Table：CF.WDT.CDSS.MKBConfigDetail
/// Input：RowId
/// Return: Json
/// Other: w ##class(web.CDSS.Config.MKBConfigDetail).OpenData("31||10")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CF.WDT.CDSS.MKBConfigDetail).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Config.MKBConfigDetail).%New()
    s bobj.RowId=id
	s bobj.CDetailValue=obj.CDetailValue			// 配置项值
	s bobj.CDetailActive=obj.CDetailActive			// 是否激活
	
	//s bobj.HospitalDR=obj.HospitalDR.%Id()			// 医院院区
	
	//s:bobj.HospitalDR'="" bobj.HospAreaDesc=$lg($g(^User.DHCDSSCustomerHospD(bobj.HospitalDR)),3)
	//s HospitalDR = $LG($G(^CF.WDT.CDSS.MKBConfigD(base,"ConfigChildRef",ConfigChildSub)),4)			
	//s:bobj.HospitalDR'="" eobj=##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(bobj.HospitalDR) 
	//s:bobj.HospitalDR'="" bobj.HospAreaDesc=eobj.HospAreaDesc
	s bobj.CDetailType=obj.CDetailType
	s bobj.HospitalDesc=obj.HospitalDesc
	s bobj.UpdateUser=obj.UpdateUser				// 编辑人员
	s bobj.UpdateDate=obj.UpdateDate				// 编辑时间
	s bobj.Remarks=obj.Remarks						// 备注
	d obj.%Close()		
	k obj
	s str = bobj.JsonS()	
	q str
}

/// Creator：赵文伟	
/// CreatDate: 2022-05-07
/// Description：查询医院院区（子表）数据
/// Table: CT.WDT.CDSS.CustomerHospArea
/// Input:hosid-父表id
/// Output:CHRowId,HospAreaCode,HospAreaDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfigDetail","GetHospAreaList","22")
Query GetHospAreaList(hosid As %String) As %Query(ROWSPEC = "CHRowId,HospAreaCode,HospAreaDesc")
{
}

ClassMethod GetHospAreaListExecute(ByRef qHandle As %Binary, hosid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (hosid'="")
	{
		s HosChildSub = ""
		for
		{
			s HosChildSub = $O(^User.DHCDSSCustomerHospD(hosid,"ChildExt",HosChildSub))
			q:HosChildSub=""
			s CHRowId = hosid_"||"_HosChildSub
			s HospAreaCode = $LG($G(^User.DHCDSSCustomerHospD(hosid,"ChildExt",HosChildSub)),2)		//院区代码
			s HospAreaDesc = $LG($G(^User.DHCDSSCustomerHospD(hosid,"ChildExt",HosChildSub)),3)		//院区名称
			
			d OutputRow	
		}	
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CHRowId,HospAreaCode,HospAreaDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospAreaListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHospAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChildListExecute ]
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

}
