/// Description：标本字典表 
/// Table：CT.WDT.CDSS.LabSpecimenDict
Class web.CDSS.CMKB.LabSpecimenDict Extends %RegisteredObject
{

/// Creator：ZWW
/// CreatDate: 2022-09-16
/// Description：查询检验标本字典
/// Table：CT.WDT.CDSS.LabSpecimenDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabSpecimenDict","GetList","","","","","","2","","","","","","Short")
Query GetList(rowid As %String, desc As %String, code As %String, alias As %String, specimentype As %String, state As %String, opername As %String, starttime As %String, endtime As %String, inspectionsheet As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "SpecimenRowId,SpecimenCode,SpecimenName,SpecimenAlias,SpecimenDesc,SpecimenNorm,UseFlag,CreateDate,CreateUserID,Remarks,SpecimenType,EnglishName,Unit,InspectionSheet")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, code As %String, alias As %String, specimentype As %String, state As %String, opername As %String, starttime As %String, endtime As %String, inspectionsheet As %String, remarks As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
    s ind=1
 
    if (rowid'="") //根据rowid返回该条记录
    {
		s SpecimenRowId=rowid
		s SpecimenCode=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),2)
		s SpecimenName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),3)
		s SpecimenDesc=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),4)
		s SpecimenNorm=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),5)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),6)
		s:UseFlag="" UseFlag=0
		s CreateDate=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),7)
		s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),8)
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),9)
		s SpecimenType=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),10)
		s EnglishName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),11)
		s Unit=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),12)
		s InspectionSheet=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),13)
		s SpecimenAlias=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),14)
		d OutputRow
 	}
    else
    {
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:code'="" code=$ZCONVERT(code,"U")
		s:inspectionsheet'="" inspectionsheet=$ZCONVERT(inspectionsheet,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
		s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
		//默认时间倒序输出
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.LabSpecimenDictD(ID))
				q:ID=""
				s SpecimenName= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(ID)),3)		//名称
				s length=$l(SpecimenName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.LabSpecimenDictD(ID))
				q:ID=""
				s CreateDate= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(ID)),7)				//编辑时间
				s:CreateDate="" CreateDate="2021-01-01"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",CreateDate,ID)=ID
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
			s SpecimenRowId=0
			for
			{
				s SpecimenRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,SpecimenRowId)) q:SpecimenRowId=""
				s SpecimenCode=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),2)
				continue:((code'="")&&($ZCONVERT(SpecimenCode,"U")'[code))
				s SpecimenName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),3)
				s SpecimenDesc=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),4)
				s SpecimenNorm=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),5)
				s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),6)
				s:UseFlag="" UseFlag=0
				if (state=""){
					continue:(UseFlag="1")			
				}
				else{
					continue:((state'="")&&(UseFlag'=state))
				}
				s CreateDate=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),7)
				s:CreateDate="" CreateDate="2021-01-01 00:00:00"
				continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
	    		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
				s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),8)
				continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
				s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),9)
				continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
				s SpecimenType=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),10)
				continue:((specimentype'="")&&(SpecimenType'=specimentype))
				s EnglishName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),11)
				s Unit=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),12)
				s InspectionSheet=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),13)
				continue:((inspectionsheet'="")&&($ZCONVERT(InspectionSheet,"U")'[inspectionsheet))
				s SpecimenAlias=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),14)
				continue:((alias'="")&&($ZCONVERT(SpecimenAlias,"U")'[alias))
				if (($ZCONVERT(SpecimenName,"U")[desc)) 
				{
					d OutputRow
				}
			}
 		}
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SpecimenRowId,SpecimenCode,SpecimenName,SpecimenAlias,SpecimenDesc,SpecimenNorm,UseFlag,CreateDate,CreateUserID,Remarks,SpecimenType,EnglishName,Unit,InspectionSheet)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2018-03-27    
/// w ##class(web.CDSS.CMKB.LabSpecimenDict).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	
	s:code'="" flagc=$d(^CT.WDT.CDSS.LabSpecimenDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex",desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.LabSpecimenDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabSpecimenDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabSpecimenDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2020-06-19
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.LabSpecimenDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.LabSpecimenDict).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.LabSpecimenDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.SpecimenRowId,eobj.SpecimenName,eobj.SpecimenCode)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.SpecimenRowId,eobj.SpecimenName,eobj.SpecimenAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.SpecimenRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(eobj.SpecimenRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New() 
			s bobj.SpecimenCode = obj.SpecimenCode  
			s bobj.SpecimenName = obj.SpecimenName  
			s bobj.SpecimenDesc = obj.SpecimenDesc 
			s bobj.SpecimenNorm = obj.SpecimenNorm
			s bobj.UseFlag = obj.UseFlag 
			s bobj.CreateDate = obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.Remarks = obj.Remarks
			s bobj.SpecimenType=obj.SpecimenType
			s bobj.EnglishName=obj.EnglishName
			s bobj.Unit=obj.Unit
			s bobj.InspectionSheet=obj.InspectionSheet
			s bobj.SpecimenAlias=obj.SpecimenAlias
		}
		
		s obj.SpecimenCode = eobj.SpecimenCode  
		s obj.SpecimenName = eobj.SpecimenName  
		s obj.SpecimenDesc = eobj.SpecimenDesc
		s obj.SpecimenNorm = eobj.SpecimenNorm
		s obj.UseFlag = eobj.UseFlag  
		s obj.CreateDate = eobj.CreateDate
		s obj.CreateUserID = eobj.CreateUserID
		s obj.Remarks = eobj.Remarks 
		s obj.SpecimenType=eobj.SpecimenType
		s obj.EnglishName=eobj.EnglishName
		s obj.Unit=eobj.Unit
		s obj.InspectionSheet=eobj.InspectionSheet
		s obj.SpecimenAlias=eobj.SpecimenAlias
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.SpecimenRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",id,eobj.SpecimenName,"A",eobj)
			d:eobj.SpecimenRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",eobj.SpecimenRowId,eobj.SpecimenName,"U",eobj,bobj)
			//同步修改对照数据
			d:eobj.SpecimenRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验标本",bobj.SpecimenCode_"[A]"_bobj.SpecimenName,eobj.SpecimenCode_"[A]"_eobj.SpecimenName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.SpecimenRowId="")&&(eobj.SpecimenAlias'=""))||((eobj.SpecimenRowId'="")&&(eobj.SpecimenAlias'=bobj.SpecimenAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabSpecimenDict",id,eobj.SpecimenAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验标本字典","web.CDSS.CMKB.LabSpecimenDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验标本字典","web.CDSS.CMKB.LabSpecimenDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.LabSpecimenDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New() 
	s bobj.SpecimenCode = obj.SpecimenCode  
	s bobj.SpecimenName = obj.SpecimenName  
	s bobj.SpecimenDesc = obj.SpecimenDesc 
	s bobj.SpecimenNorm = obj.SpecimenNorm
	s bobj.UseFlag = obj.UseFlag 
	s bobj.CreateDate = obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Remarks = obj.Remarks
	s bobj.SpecimenType=obj.SpecimenType
	s bobj.EnglishName=obj.EnglishName
	s bobj.Unit=obj.Unit
	s bobj.InspectionSheet=obj.InspectionSheet
	s bobj.SpecimenAlias=obj.SpecimenAlias
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.LabSpecimenDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    /*if ($d(^CT.WDT.CDSS.ItemJoinUsageI("SpecimenIndex",id)))
    {
	    s UsageID=0
	    for
	    {
	        s UsageID=$o(^CT.WDT.CDSS.ItemJoinUsageI("SpecimenIndex",id,UsageID)) q:(UsageID="")
            s TreatItemNumDR=$lg($g(^CT.WDT.CDSS.ItemJoinUsageD(UsageID)),2)
            s DetailUsageDesc=$lg($g(^CT.WDT.CDSS.ItemJoinUsageD(UsageID)),6)
            s TreatItemName="",TreatName="",DiseaseName=""
            if (TreatItemNumDR'="")
            {
	            s TreatNumDR=$lg($g(^CT.WDT.CDSS.TreatVSItemD(TreatItemNumDR)),2)
	            s TreatItemName=$lg($g(^CT.WDT.CDSS.TreatVSItemD(TreatItemNumDR)),6)
	            if (TreatNumDR'="")
	            {
		            s DiseaseDR=$lg($g(^CT.WDT.CDSS.DiseJoinTreatD(TreatNumDR)),2)
		            s TreatName=$lg($g(^CT.WDT.CDSS.DiseJoinTreatD(TreatNumDR)),4)
           			s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
	            }
	            
            }
            s flag=1
            s myInfo=myInfo_"<诊断知识库:"_DiseaseName_"-关联治疗方案"_"-"_TreatName_"-"_TreatItemName_">"  
	        
	    }
    }
    if $d(^CT.WDT.CDSS.LabJoinSpecimenI("Specimen",id)) s myInfo=myInfo_"<检验关联标本>"
    */
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.LabSpecimenDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s re=##class(web.CDSS.CMKB.LabSpecimenDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
		Ts
		s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New() 
		s bobj.SpecimenCode = obj.SpecimenCode  
		s bobj.SpecimenName = obj.SpecimenName  
		s bobj.SpecimenDesc = obj.SpecimenDesc 
		s bobj.SpecimenNorm = obj.SpecimenNorm
		s bobj.UseFlag = obj.UseFlag 
		s bobj.CreateDate = obj.CreateDate
		s bobj.CreateUserID = obj.CreateUserID
		s bobj.Remarks = obj.Remarks
		s bobj.SpecimenType=obj.SpecimenType
		s bobj.EnglishName=obj.EnglishName
		s bobj.Unit=obj.Unit
		s bobj.InspectionSheet=obj.InspectionSheet
		s bobj.SpecimenAlias=obj.SpecimenAlias
		
		s sc=##class(CT.WDT.CDSS.LabSpecimenDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",id,bobj.SpecimenName,"D",bobj)
			//同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.LabSpecimenDict",id)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("检验标本字典","web.CDSS.CMKB.LabSpecimenDict","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    }
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 标本
/// Table：CT.WDT.CDSS.LabSpecimenDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabSpecimenDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "LabSpecimenDR:%String,SpecimenName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s LabSpecimenDR=rowid
  s SpecimenName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(LabSpecimenDR)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s LabSpecimenDR=""
  for{  
	  s LabSpecimenDR=$o(^CT.WDT.CDSS.LabSpecimenDictD(LabSpecimenDR),-1) q:LabSpecimenDR=""  
	  s SpecimenName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(LabSpecimenDR)),3)
	  s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(LabSpecimenDR)),6)
	  //continue:UseFlag=1				//过滤停用
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SpecimenName)  
	  if (($ZCONVERT(SpecimenName,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(SpecimenName,"U")[q)||(PINYIN[q))&(UseFlag=2)) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(LabSpecimenDR,SpecimenName)
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

/// Creator：xuwenhu
/// CreatDate: 2021-03-09
/// Description:状态修改
/// Input:id useflag(0编辑中,1已弃用,2已审核)
/// Table：CT.WDT.CDSS.ExamDict
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).UpdateUseFlag(1,1)
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	if (Operation="弃用"){ //弃用操作
		s re=..GetRefFlag(RowId)
		s RefFlag=$p(re,"^",1)
		if (RefFlag'=0){
			q "{success:'false',info:'"_$p(re,"^",2)_"'}"
		}
	}
	s eobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.CreateDate=eobj.CreateDate
 	s obj.CreateUserID=eobj.CreateUserID
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",RowId,obj.SpecimenName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:xuwenhu
/// CreatDate:2021-03-09
/// Description：导出检查字典表数据
/// Other:w ##class(web.CDSS.CMKB.LabSpecimenDict).ExportLabSpeData("","","","","","","","","")
ClassMethod ExportLabSpeData(code As %String, desc As %String, alias As %String, specitype As %String, sheetname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检验标本字典数据.txt"		
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
	w "标本编码	中文名称	标本别名	英文名称	标本类型	单位	检验单名称	状态	操作时间	操作人员	备注"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:sheetname'="" sheetname=$ZCONVERT(sheetname,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s SpecimenRowId=""
	for
	{ 
		s SpecimenRowId=$o(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId),-1) q:SpecimenRowId=""
		s SpecimenCode=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),2)
		continue:((code'="")&&(SpecimenCode'[code))
		s SpecimenName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),3)
		continue:((desc'="")&&($ZCONVERT(SpecimenName,"U")'[desc))
		s SpecimenDesc=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),4)
		s SpecimenNorm=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),5)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),6)
		if (state=""){
			continue:(UseFlag="1")			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中")
        
		s CreateDate=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),7)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),8)
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),9)
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s SpecimenType=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),10)
		continue:((specitype'="")&&(SpecimenType'=specitype))
		s EnglishName=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),11)
		s Unit=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),12)
		s InspectionSheet=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),13)
		continue:((sheetname'="")&&($ZCONVERT(InspectionSheet,"U")'[sheetname))
		s SpecimenAlias=$LISTGET($G(^CT.WDT.CDSS.LabSpecimenDictD(SpecimenRowId)),14)
		continue:((alias'="")&&($ZCONVERT(SpecimenAlias,"U")'[alias))
			
		w !,SpecimenCode_"	"_SpecimenName_"	"_SpecimenAlias_"	"_EnglishName_"	"_SpecimenType_"	"_Unit_"	"_InspectionSheet_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks

	}
	c file
	q fileName
}

/// Creator:xuwenhu
/// CreatDate:2021-05-07
/// Description：导入数据
/// Other:w ##class(web.CDSS.CMKB.LabSpecimenDict).ImportLabSpeData("","","","","","","","")
ClassMethod ImportLabSpeData(path) As %String
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
		
		s RowID=$o(^CT.WDT.CDSS.LabSpecimenDictI("CodeIndex"," "_Code,0))
		if (RowID="")
		{
			s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New()
			s bobj.ID = ""
			s bobj.SpecimenCode=Code					//功能代码
        	s bobj.SpecimenDesc=Desc							//功能名称
        	s bobj.UseFlag="1"								//状态
        	s bobj.CreateUserID="dhcc"					//编辑用户
			
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

/// Creator：xuwenhu
/// CreatDate: 2021-05-12
/// Description: 批量处理数据，将代码更改为纯数字递增
/// Input:
/// Table：CT.WDT.CDSS.LabSpcimenDict
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.LabSpecimenDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(ID)
		s OldCode=obj.SpecimenCode													//旧代码
		
		s obj.SpecimenCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)		//新代码
		s sc=obj.%Save()
		d obj.%Close()
		TS
		If $$$ISOK(sc)
		{
			tc
			s count=count+1
			
			//调用字典对照接口
			d ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验标本", OldCode_"[A]"_obj.SpecimenDesc,obj.SpecimenCode_"[A]"_obj.SpecimenDesc)
		}
		else{
			tro
			s failcount=failcount+1
		}
	}
	q "总处理"_count_"条,失败"_failcount_"条"
}

/// Creator:xuwenhu
/// CreatDate:2021-5-12
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.LabSpecimenDict).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s LabSpecimenID=0
	
	s Code=$o(^CT.WDT.CDSS.LabSpecimenDictD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="00001"
	}
	else
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,5)	//补0
		//s Code="PE"_Code
	}
  
	q Code
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-21
/// Description: 批量通过
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).ChangeStatusPass("")
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
/// CreatDate: 2021-10-21
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).ChangeStatusBack("")
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
/// CreatDate:2022-01-13
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabSpecimenDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s SpecimenAlias = $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(id)),14)
		s Len=$Length(SpecimenAlias,",")
		for i=1:1:Len{
			s Desc=$p(SpecimenAlias,",",i)
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
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabSpecimenDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(RowId)),14)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabSpecimenDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.LabSpecimenDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.LabSpecimenDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabSpecimenDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(RowId)),6)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabSpecimenDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.LabSpecimenDict",RowId,LogID),-1) q:LogID=""
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
/// Table：CT.WDT.CDSS.LabSpecimenDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.LabSpecimenDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.LabSpecimenDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.SpecimenRowId,eobj.SpecimenName,eobj.SpecimenCode)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.SpecimenRowId,eobj.SpecimenName,eobj.SpecimenAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.SpecimenRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.LabSpecimenDict).%OpenId(eobj.SpecimenRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.LabSpecimenDict).%New() 
			s bobj.SpecimenCode = obj.SpecimenCode  
			s bobj.SpecimenName = obj.SpecimenName  
		
			s bobj.CreateDate = obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.SpecimenAlias=obj.SpecimenAlias
		}
		
		s obj.SpecimenCode = eobj.SpecimenCode  
		s obj.SpecimenName = eobj.SpecimenName 
		s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
		s obj.CreateDate = eobj.CreateDate
		s eobj.CreateUserID = $g(%session.Data("LOGON.USERNAME")) 
		s obj.CreateUserID = eobj.CreateUserID
		s obj.SpecimenAlias=eobj.SpecimenAlias
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.SpecimenRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",id,eobj.SpecimenName,"A",eobj)
			d:eobj.SpecimenRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabSpecimenDict","CT.WDT.CDSS.LabSpecimenDict","检验标本字典",eobj.SpecimenRowId,eobj.SpecimenName,"U",eobj,bobj)
			//同步修改对照数据
			d:eobj.SpecimenRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验标本",bobj.SpecimenCode_"[A]"_bobj.SpecimenName,eobj.SpecimenCode_"[A]"_eobj.SpecimenName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.SpecimenRowId="")&&(eobj.SpecimenAlias'=""))||((eobj.SpecimenRowId'="")&&(eobj.SpecimenAlias'=bobj.SpecimenAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabSpecimenDict",id,eobj.SpecimenAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验标本字典","web.CDSS.CMKB.LabSpecimenDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验标本字典","web.CDSS.CMKB.LabSpecimenDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
