/// Description：疾病分科字典表
/// Table：CT.WDT.CDSS.DiseaseDeptDict
Class web.CDSS.CMKB.DiseaseDeptDict Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-10-25
/// Description：查询 
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDeptDict","GetList","","","","","","","","")
Query GetList(rowid As %String, deptcode As %String, deptname As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %Query(ROWSPEC = "ID,DeptCode,DeptName,UseFlag,CreateDate,CreateUserID,Remarks,DeptAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, deptcode As %String, deptname As %String, alias As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s DeptCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),2)       //编码
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),3)       //名称
		s UseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核") 
	    s CreateUserID= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),9) 	//操作人员
	    s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),8)     //操作时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),10)        //备注
	    s DeptAlias=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),11)
	    d OutputRow
	}
	else
	{
		s:deptcode'="" deptcode=$ZCONVERT(deptcode,"U") //转换成大写
		s:deptname'="" deptname=$ZCONVERT(deptname,"U") //转换成大写
	    s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	    s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s ID=""
		for 
		{
			
			s ID=$o(^CT.WDT.CDSS.DiseaseDeptDictD(ID),-1) q:ID="" 
			s DeptCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),2)       //编码
			continue:((deptcode'="")&&(DeptCode'[deptcode))
		    s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),3)       //名称
		    continue:((deptname'="")&&(DeptName'[deptname))
	   	 	s UseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),7)        //状态
	    	continue:((state'="")&&(UseFlag'=state))
	    	continue:((state="")&&(UseFlag=1))
	    	s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    	s CreateUserID= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),9) 	   //编辑人员
	    	s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),8)     //编辑时间
	    	s Remarks= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),10)        //备注
	    	s DeptAlias= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),11)        //别名
	    	continue:((alias'="")&&($ZCONVERT(DeptAlias,"U")'[alias))
		    if ($ZCONVERT(CreateUserID,"U")[user)
			{
				if ((StartTime'="")&&(EndTime'=""))
				{
					if ($ZDH(CreateDate,3)<=$zdh(EndTime,3))&&($ZDH(CreateDate,3)>=$zdh(StartTime,3))
					{
						d OutputRow
					}
				}
				elseif ((StartTime="")&&(EndTime'=""))
				{
					if $ZDH(CreateDate,3)<=$zdh(EndTime,3)
					{
						d OutputRow
					}
				}
				elseif ((EndTime="")&&(StartTime'=""))
				{
					if $ZDH(CreateDate,3)>=$zdh(StartTime,3)
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
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,DeptCode,DeptName,UseFlag,CreateDate,CreateUserID,Remarks,DeptAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
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

/// Creator：丁亚男
/// CreatDate: 2021-04-06
/// Description：查询 科室
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDeptDict","GetDataForCmb1","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "DeptDR:%String,DeptName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s DeptDR=rowid
  s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s DeptDR=""
  for{  
	s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR),-1) q:DeptDR=""  
	s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
	s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),7)
	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DeptName)
	//if (($ZCONVERT(DeptName,"U")[desc)||(PINYIN[desc))&(UseFlag=2) 
	if (($ZCONVERT(DeptName,"U")[desc)||(PINYIN[desc))&($ZCONVERT(DeptName,"U")[q)||($ZCONVERT(DeptName,"U")[q)&(UseFlag=2)
	{
		d OutputRowCmb
	}
	continue:(desc'=""||(q'=""))
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DeptDR,DeptName)
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

/// Creator：丁亚男
/// CreatDate: 2020-08-07
/// Description：查询树形的疾病分科
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：父节点 
/// Return：tree格式数据串
/// w ##class(web.CDSS.CMKB.DiseaseDeptDict).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(id As %String = "") As %String
{
	s parentdr=id
	if (parentdr="") s parentdr=-100000000000000

	//输出JSON串
	w "["
	s count=0
	s myRowID=0
	for {
		s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,myRowID)) q:(myRowID="")
		
		s DeptName = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),3)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),7)
		continue:(UseFlag=1)
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_DeptName_""""
		w ",""state"":""open"""
		if $d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",myRowID))
		{
				w ",""state"":""open"""
				w ",""children"":"
				w ..GetJsonDataForCmb(myRowID)	
		}
		else
		{
				w ",""state"":""open"""
		}
		w "}"
	}
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2020-05-19
/// Description：树形科室
/// Input：上级节点
/// Return:成功返回树形科室
/// Other:w ##class(web.CDSS.CMKB.DiseaseDeptDict).GetTreeJson("","","","1","","","","")
ClassMethod GetTreeJson(id As %String, deptcode As %String = "", opername As %String = "", state As %String = "", starttime As %String = "", endtime As %String = "", remarks As %String = "", sortmethod As %String = "") As %String
{
	s IDStr=""
	s parentdr=id
	if (parentdr="") s parentdr=-100000000000000
	s myJsonStr=""
	
	//输出树形JSON串
	s childStr=""
	w "["
	s count=0
	//s myRowID=0
	
	/*k ^TempDataHandle
	if (sortmethod="CreateDate")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),8)				//编辑时间
			//s length=$l(UpdateDate)
			s:CreateDate="" CreateDate="2021-01-01"
			s ^TempDataHandle("Short",CreateDate,ID)=ID
		}
		s num=0
		s le=""
		for
		{
			s le=$o(^TempDataHandle("Short",le),-1)
			q:le=""
			s myRowID=0
			for
			{
				s myRowID=$o(^TempDataHandle("Short",le,myRowID))
				q:myRowID=""
				s num=num+1
				s ^TempDataHandle("Handle",num)=myRowID
			}
		}
	}
	else
	{
		s myRowID=0
		s num=0
		for
		{
	 		s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,myRowID)) q:(myRowID="")
	 		s num=num+1
	 		s ^TempDataHandle("Handle",num)=myRowID
		}	
	}*/
	//s Number=0
	s myRowID=""
	for
	{ 	
        //s Number=$o(^TempDataHandle("Handle",Number))
		//q:Number=""
		//s myRowID=^TempDataHandle("Handle",Number)
		s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,myRowID),-1) q:(myRowID="")
		
		s DeptCode = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),2)	
		continue:((deptcode'="")&&(DeptCode'[deptcode))
		s DeptName = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),3)
		s FatherCodeDR = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),4)
		s FatherName=""
		s:FatherCodeDR'="" FatherName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(FatherCodeDR)),3)
		s DeptGrade = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),5)
		s DeptClass= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),6)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),7)
		s:UseFlag="" UseFlag=0
		if (state=""){
			continue:(UseFlag="1")			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s CreateDate = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),8)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),9)
		continue:(opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername)
		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),10)
		continue:((remarks'="")&&(Remarks'[remarks))
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""DeptCode"":"""_DeptCode_""",""DeptName"":"""_DeptName_""",""FatherCodeDR"":"""_FatherCodeDR_""",""FatherName"":"""_FatherName_""",""DeptGrade"":"""_DeptGrade_""",""DeptClass"":"""_DeptClass_""",""UseFlag"":"""_UseFlag
		_""",""CreateDate"":"""_CreateDate_""",""CreateUserID"":"""_CreateUserID_""",""Remarks"":"""_Remarks_""""
		
		if $d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",myRowID))
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeJson(myRowID)	
		}
		else
		{
			w ",""state"":""open"""
			
		}
		w "}"
	}
	
	w "]"
	q ""
}

/// Creator:赵文伟
/// CreatDate:2021-08-27
/// CT.WDT.CDSS.DiseaseDeptDict
/// Description:测试保存方法
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).TestSaveData()
ClassMethod TestSaveData()
{
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s eobj.RowId=""	
	s eobj.DeptCode="002"
	s eobj.DeptName="测试2"
	s eobj.CreateUserID="Domo"
	s eobj.CreateDate="2021-08-31 16:03:55"
	s eobj.UseFlag=0
	s eobj.Remarks="yyuiop"
	
	
	//s eobj.Medicine="^950,^951"
	
	w ..SaveData(eobj)
	q ""
}

/// Creator:丁亚男
/// CreatDate:2020-08-17
/// Description:保存科室分科字典表表
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input: eobj 科室分科字典表表实体对象
/// Return:
/// others:w ##class(web.CDSS.CMKB.DiseaseDeptDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseaseDeptDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..Validate(eobj.RowId,eobj.DeptCode,eobj.DeptName)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该记录已经存在'}"
		s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
		s:eobj.CreateUserID="" eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New() 
			s bobj.RowId=eobj.RowId
			s bobj.DeptCode = obj.DeptCode  
			s bobj.DeptName = obj.DeptName 
			
			s bobj.UseFlag = obj.UseFlag
			s bobj.CreateDate = obj.CreateDate  
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.Remarks = obj.Remarks
			s bobj.DeptAlias = obj.DeptAlias

		}
		s obj.DeptCode = eobj.DeptCode
		s obj.DeptName = eobj.DeptName
		
		s:eobj.UseFlag="" eobj.UseFlag="0" 
		s obj.UseFlag = eobj.UseFlag
		//s obj.CreateDate = eobj.CreateDate
		//s obj.CreateUserID = eobj.CreateUserID
		s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
		s obj.CreateUserID=eobj.CreateUserID
		s eobj.CreateDate=$ZDATETIME($H,3)						//编辑时间
		s obj.CreateDate=eobj.CreateDate
		
		s obj.Remarks = eobj.Remarks
		s obj.DeptAlias = eobj.DeptAlias

		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分科字典",id,eobj.DeptName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分科字典",eobj.RowId,eobj.DeptName,"U",eobj,bobj)
			//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("科室",bobj.DeptCode_"[A]"_bobj.DeptName,eobj.DeptCode_"[A]"_eobj.DeptName)
			//同步修改识别词项目数据
            d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("会诊科室",eobj.DeptName,bobj.DeptName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.RowId="")&&(eobj.DeptAlias'=""))||((eobj.RowId'="")&&(eobj.DeptAlias'=bobj.DeptAlias))
            {
            	s re=##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDeptDict",id,eobj.DeptAlias)
            }
			//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("科室",bobj.DeptCode_"[A]"_bobj.DeptName,eobj.DeptCode_"[A]"_eobj.DeptName)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分科字典","web.CDSS.CMKB.DiseaseDeptDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分科字典","web.CDSS.CMKB.DiseaseDeptDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.DiseaseDeptDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0,count=0
    
    /*if ($d(^User.DHCDSSDiseJoinDeptI("DeptDRIndex",id)))
    {
	    s DeptID=0
	    for
	    {
	        s DeptID=$o(^User.DHCDSSDiseJoinDeptI("DeptDRIndex",id,DeptID)) q:(DeptID="")||(count=3)
            s DiseaseDR=$lg($g(^User.DHCDSSDiseJoinDeptD(DeptID)),2)
            s DeptName=""
            s:DiseaseDR'="" DeptName=$lg($g(^User.DHCDSSDiseaseDictD(DiseaseDR)),3)
            s count=count+1
            s flag=1
            s myInfo=myInfo_"<诊断知识库:"_DeptName_"-关联科室>"
	        
	    }
    }
    
    
    if ($d(^User.DHCDSSDeptJoinDiseDeptI("DiseDeptDRIndex",id)))
    {
	    s DiseDeptID=0
	    for
	    {
	        s DiseDeptID=$o(^User.DHCDSSDeptJoinDiseDeptI("DiseDeptDRIndex",id,DiseDeptID)) q:(DiseDeptID="")||(count=3)
            s DeptCodeDR=$lg($g(^User.DHCDSSDeptJoinDiseDeptD(DiseDeptID)),2)
            s DeptName=""
            s:DeptCodeDR'="" DeptName=$lg($g(^User.DHCDSSDeptDictD(DeptCodeDR)),3)
            s count=count+1
            s flag=1
            s myInfo=myInfo_"<疾病关联科室表:"_DeptName_">"
	        
	    }
    }
    */
    if ($d(^CT.WDT.CDSS.AssConDeptI("DeptIndex",id)))
    {
	    s DeptID=0
	    for
	    {
	        s DeptID=$o(^CT.WDT.CDSS.AssConDeptI("DeptIndex",id,DeptID)) q:(DeptID="")||(count=3)
            s AssDR=$lg($g(^CT.WDT.CDSS.AssConDeptD(DeptID)),2)
            s AssName=""
            s:AssDR'="" AssName=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3)
            s count=count+1
            s flag=1
            s myInfo=myInfo_"<评估量表关联科室:"_AssName_">"
	        
	    }
    }
    //if (count=3) s myInfo=myInfo_"..."

    //字典对照引用接口
    s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(id)),3)
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("科室",DeptName)
    s myInfo=myInfo_Mappinginfo
    
    //识别词项目引用接口
    s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),3)
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("会诊科室",DeptName)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:丁亚男
/// Editor:丁亚男
/// CreatDate:2020-08-17
/// Description:删除科室分科字典表表
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input:
/// Return:
/// others:w ##class(web.CDSS.CMKB.DiseaseDeptDict).DeleteData(5)
ClassMethod DeleteData(id As %String)
{
	s result=""	
	/*s re=##class(web.CDSS.CMKB.DiseaseDeptDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
		/*if $d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",id))
		{
			
			s myRowID=0
			for 
			{
				s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",id,myRowID)) q:myRowID=""
				d ..DeleteData(myRowID)
			}
		}*/
		
		s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New() 
		s bobj.DeptCode = obj.DeptCode  
		s bobj.DeptName = obj.DeptName 
		//s:obj.FatherCodeDR'="" bobj.FatherCodeDR = obj.FatherCodeDR.%Id() 
		//s bobj.DeptClass = obj.DeptClass
		//s bobj.DeptGrade = obj.DeptGrade
		s bobj.UseFlag = obj.UseFlag
		s bobj.CreateDate = obj.CreateDate  
		s bobj.CreateUserID = obj.CreateUserID
		s bobj.Remarks = obj.Remarks
		s bobj.DeptAlias = obj.DeptAlias
		Ts
		//同步删除对照数据 
		s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("科室",obj.DeptCode_"[A]"_obj.DeptName)
		if (re="true[A]true"){
		s sc=##class(CT.WDT.CDSS.DiseaseDeptDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分科字典",id,bobj.DeptName,"D",bobj)
			//删除别名通用表中数据 2021-11-05 GXP
            d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DiseaseDeptDict",id)
			d bobj.%Close()	
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分科字典","web.CDSS.CMKB.DiseaseDeptDict","DeleteData",bobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    	} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-08-17
/// Description:通过id获取科室分科字典表内容
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input: 
/// Return: 科室分科字典表内容
/// others:w ##class(web.CDSS.CMKB.DiseaseDeptDict).OpenData("34")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s eobj.DeptCode=obj.DeptCode
	s eobj.DeptName=obj.DeptName
	//s:obj.FatherCodeDR'="" eobj.FatherCodeDR = obj.FatherCodeDR.%Id() 
	//s:obj.FatherCodeDR'="" eobj.FatherCodeDRName = $LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(eobj.FatherCodeDR)),3)
	//s eobj.DeptClass = obj.DeptClass
	//s eobj.DeptGrade = obj.DeptGrade
	s eobj.UseFlag = obj.UseFlag
	s eobj.CreateDate = obj.CreateDate
	s eobj.CreateUserID = obj.CreateUserID
	s eobj.Remarks = obj.Remarks
	s eobj.DeptAlias = obj.DeptAlias
	
	d obj.%Close()
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// others:w ##class(web.CDSS.CMKB.DiseaseDeptDict).OpenaData("34")
ClassMethod OpenaData(id As %String)
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s eobj.DeptCode=obj.DeptCode
	s eobj.DeptName=obj.DeptName
	d obj.%Close()
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:丁亚男
/// CreateDate:2020-01-20    
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// w ##class(web.CDSS.CMKB.DiseaseDeptDict).FormValidate("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code,0))	
		if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// 重复校验
/// Other:w ##class(web.CDSS.CMKB.DiseaseDeptDict).Validate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：xuwenhu
/// CreatDate: 2021-02-19
/// Description:状态修改
/// Input:id useflag(0编辑中,1已弃用,2已审核)
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).UpdateUseFlag(9,1)
ClassMethod UpdateUseFlag(id, Operation) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	
	s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)
	s bobj=##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
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
		//同步删除对照数据 
		if (obj.UseFlag= 1)||(obj.UseFlag=0){  
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("科室",obj.DeptCode_"[A]"_obj.DeptName)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室字典表",id,obj.DeptName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	
	q result
}

/*// Creator:徐文虎
/// CreatDate:2021-01—29
/// Description：审核、驳回、删除、恢复
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：id-扩展码字典表的rowid
/// Return：成功返回"true"；失败返回"false"}
/// Other:w ##class(web.CDSS.CMKB.DiseaseDeptDict).ChangeState("55","")
ClassMethod ChangeState(id As %String, state As %String) As %String
{
	q:id="" false
	s result=""
	s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s eobj.DeptCode=obj.DeptCode
	s eobj.DeptName=obj.DeptName
	//s:obj.FatherCodeDR'="" eobj.FatherCodeDR = obj.FatherCodeDR.%Id() 
	//s:obj.FatherCodeDR'="" eobj.FatherCodeDRName = $LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(eobj.FatherCodeDR)),3)
	//s eobj.DeptClass = obj.DeptClass
	//s eobj.DeptGrade = obj.DeptGrade
	s eobj.UseFlag = obj.UseFlag
	s eobj.CreateDate = obj.CreateDate
	s eobj.CreateUserID = obj.CreateUserID
	s eobj.Remarks = obj.Remarks
	s eobj.DeptAlias = obj.DeptAlias
	s result=..SaveData(eobj)
	if (result["true"){
		s result="true"	
		if (obj.UseFlag= 1)||(obj.UseFlag= 0){ 
		//同步删除对照数据  
		d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("科室",obj.DeptCode_"[A]"_obj.DeptName)
		}
	}
	else{
		s result="false"	
	}
	q result
}
*/
/// Creator:xuwenhu
/// CreatDate:2021-04-09
/// Description：导出科室字典表数据
/// Other:w ##class(web.CDSS.CMKB.DiseaseDeptDict).ExportDeptData("","","","","","","")
ClassMethod ExportDeptData(name As %String, opername As %String, alias As %String, state As %String, starttime As %String, endtime As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"科室字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"科室字典数据.txt"		
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
	w "科室编码	科室名称	别名	状态	操作时间	操作人员	备注"
	
	s parentdr=-100000000000000
	s myRowID=0
	for{
		
		s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,myRowID)) q:(myRowID="")
		
		s DeptCode = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),2)
		
		s DeptName = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),3)
		continue:((name'="")&&(DeptName'[name))
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),7)
		if (state=""){
			continue:(UseFlag="1")			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s CreateDate = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),8)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),9)
		continue:(opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername)
		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),10)
		
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
		s DeptAlias=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(myRowID)),11)
		continue:(alias'="")&&($ZCONVERT(DeptAlias,"U")'[alias)
		
		w !,DeptCode_"	"_DeptName_"	"_DeptAlias_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks
		
	}
	
	c file
	q fileName
}

/// Creator:xuwenhu
/// CreatDate:2021-5-27
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.DiseaseDeptDict).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	s DeptID=0
	s Code=$o(^CT.WDT.CDSS.DiseaseDeptDictD(""),-1)
	if (Code="")
	{
		s:Code="" Code="1"
	}
	else
	{
		s Code=Code+1
	}
	q Code
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.DiseaseDeptDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).BatchConfirm()
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
/// Table:CT.WDT.CDSS.DiseaseDeptDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).BatchCancel()
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
/// CreatDate:2022-1-21
/// Description:获得别名列表
/// Table:CT.WDT.CDSS.DiseaseDeptDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDeptDict","GetAliasList","3382")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s DeptAlias=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(id)),11)
		s Len=$Length(DeptAlias,",")
		for i=1:1:Len{
			s Desc=$p(DeptAlias,",",i)
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
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),11)        
		if Alias'=""
		{
			s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDeptDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.DiseaseDeptDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DiseaseDeptDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDeptDict","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DiseaseDeptDict",RowId,LogID),-1) q:LogID=""
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

}
