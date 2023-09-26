/// 名称:腧穴字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-8-17
Class web.CDSS.CMKB.TCMAcupoints Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-8-17
/// Description：查询 
/// Table:CT.WDT.CDSS.TCMAcupoints腧穴字典表
/// Input:id,code,desc,alias,genus,channeltropism,efficacy,attending
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMAcupoints","GetList","","中","","","","","","","","","")
Query GetList(rowid As %String, acucode As %String, desc As %String, alias As %String, genus As %String, channeltropism As %String, efficacy As %String, attending As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,AcupointsCode,AcupointsName,AcupointsAlias,AcupointsGenus,AcupointsChannelTropism,AcupointsEfficacy,AcupointsAttending,Operator,OperatTime,State,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, acucode As %String, desc As %String, alias As %String, genus As %String, channeltropism As %String, efficacy As %String, attending As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	

	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴代码
		s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
		s AcupointsAlias= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),4)       //别名
		s AcupointsGenus= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),5)       //类属
		s AcupointsChannelTropism= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),6)       //归经
		s AcupointsEfficacy= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),7)       //功效
		s AcupointsAttending= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),8)       //主治
		s Operator= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),9)       //操作人
		s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)       //操作时间
	    s State= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),11)        //状态（0编辑中，1已弃用，2已审核）
	    s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    s Remarks= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),12)        //备注
		d OutputRow
	}
	else
	{
		s:acucode'="" acucode=$ZCONVERT(acucode,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s:genus'="" genus=$ZCONVERT(genus,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s:channeltropism'="" channeltropism=$ZCONVERT(channeltropism,"U") //转换成大写
		s:efficacy'="" efficacy=$ZCONVERT(efficacy,"U") //转换成大写
		s:attending'="" attending=$ZCONVERT(attending,"U") //转换成大写
		s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s ID=0
	
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMAcupointsD(ID))
				q:ID=""
				s CommonDictName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)		//名称
				s length=$l(CommonDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMAcupointsD(ID))
				q:ID=""
				s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)				//编辑时间
				s:OperatTime="" OperatTime="2021-01-01"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",OperatTime,ID)=ID
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
	       		s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴编码
				continue:((acucode'="")&&(AcupointsCode'[acucode))
				s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
				s AcupointsAlias= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),4)       //别名
				
				continue:((alias'="")&&($ZCONVERT(AcupointsAlias,"U")'[alias))
				s AcupointsGenus= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),5)       //类属
				
				continue:((genus'="")&&($ZCONVERT(AcupointsGenus,"U")'[genus))
				s AcupointsChannelTropism= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),6)       //归经
				continue:((channeltropism'="")&&($ZCONVERT(AcupointsChannelTropism,"U")'[channeltropism))
				s AcupointsEfficacy= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),7)       //功效
				continue:((efficacy'="")&&($ZCONVERT(AcupointsEfficacy,"U")'[efficacy))
				s AcupointsAttending= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),8)       //主治
				continue:((attending'="")&&($ZCONVERT(AcupointsAttending,"U")'[attending))
				s Operator= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),9)       //操作人
				s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)       //操作时间
		   		s State= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),11)        //状态（0编辑中，1已弃用，2已审核）		    
		    	s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
		    	continue:((state="")&&(State="已弃用"))
		    	s Remarks= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),12)        //备注
		    	if ($ZCONVERT(Operator,"U")[user)&($ZCONVERT(AcupointsName,"U")[desc)&($ZCONVERT(State,"U")[state) 
				{
					if ((StartTime'="")&&(EndTime'=""))
					{
						if ($ZDH(OperatTime,3)<=$zdh(EndTime,3))&&($ZDH(OperatTime,3)>=$zdh(StartTime,3))
						{
							d OutputRow
						}
					}
					elseif ((StartTime="")&&(EndTime'=""))
					{
						if $ZDH(OperatTime,3)<=$zdh(EndTime,3)
						{
							d OutputRow
						}
					}
					elseif ((EndTime="")&&(StartTime'=""))
					{
						if $ZDH(OperatTime,3)>=$zdh(StartTime,3)
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
    set Data=$lb(ID,AcupointsCode,AcupointsName,AcupointsAlias,AcupointsGenus,AcupointsChannelTropism,AcupointsEfficacy,AcupointsAttending,Operator,OperatTime,State,Remarks)
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

/// Creator：胡宜良
/// CreatDate: 2021-08-30
/// Description：查询 腧穴
/// Table:CT.WDT.CDSS.TCMAcupoints
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMAcupoints","GetDataForCmb1","","","气穴")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "ID,AcupointsCode,AcupointsName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴编码
	s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
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
		s ID=$o(^CT.WDT.CDSS.TCMAcupointsD(ID))
		q:ID=""
		s AcupointsName=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)		//腧穴名称
		s length=$l(AcupointsName)
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
			
  			s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴编码
		    s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
  			s State= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),11) 
  			//continue:(State=1)
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(AcupointsName)  
  			if (($ZCONVERT(AcupointsName,"U")[desc)||(PINYIN[desc))&($ZCONVERT(AcupointsName,"U")[q)||($ZCONVERT(AcupointsName,"U")[q)&(State=2) 
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
    set Data=$lb(ID,AcupointsCode,AcupointsName)
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

/// Creator：胡宜良	
/// CreatDate: 2021-8-12
/// Description：导入腧穴字典
/// Table:Table：CT.WDT.CDSS.TCMAcupoints 腧穴字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).ImportDataTXT("D:/1.txt")
ClassMethod ImportDataTXT(path) As %String
{
	s savecount=0
	s nosavecount=0
	s linksavecount=0
	s updatecount=0
	s continuecount=0
	s timecontinuecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheType=""
	s TheHosp=""
	s TheMarkFlag=""
	
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
		//ID,AcupointsCode,AcupointsName,AcupointsAlias,AcupointsGenus,AcupointsChannelTropism,AcupointsEfficacy,AcupointsAttending,Operator,OperatTime,State,Remarks
		s AcupointsCode=$p(data,$c(9),1)			//腧穴编码
		s AcupointsName=$p(data,$c(9),2)			//腧穴名称
		s AcupointsAlias=$p(data,$c(9),3)			//别名
		s AcupointsGenus=$p(data,$c(9),4)			//类属
		s AcupointsChannelTropism=$p(data,$c(9),5)	//归经
		s AcupointsEfficacy=$p(data,$c(9),6)		//功效
		s AcupointsAttending=$p(data,$c(9),7)		//主治
		s Remarks=$p(data,$c(9),8)					//备注

		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
		s eobj.AcupointsCode = AcupointsCode		
		s eobj.AcupointsName = AcupointsName	             	
		s eobj.AcupointsAlias = AcupointsAlias					
		s eobj.AcupointsGenus = AcupointsGenus					
		s eobj.AcupointsChannelTropism = AcupointsChannelTropism					
		s eobj.AcupointsEfficacy = AcupointsEfficacy		
		s eobj.AcupointsAttending = AcupointsAttending
		s eobj.Operator = "dhcc"
		s eobj.OperatTime = $ZDATETIME($HOROLOG,3)	
		s eobj.State = 2	
		s eobj.Remarks = Remarks					
		
		s result=..SaveEntity(eobj)
		if ((result'["false"))
		{
			s savecount=savecount+1		
		}
		else
		{
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	q "{success:'true'}"
}

/// Creator:胡宜良
/// CreatDate:2021-8-30
/// Description:导出腧穴字典数据
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMAcupoints).ExportData()
ClassMethod ExportData(desc As %String, state As %String, user As %String, alias As %String, genus As %String, channeltropism As %String, efficacy As %String, attending As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="腧穴字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("编号,腧穴名称,别名,类属,归经,功效,主治,操作人员,操作时间,备注,状态")
	//d file.WriteLine()
	

	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:genus'="" genus=$ZCONVERT(genus,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:channeltropism'="" channeltropism=$ZCONVERT(channeltropism,"U") //转换成大写
	s:efficacy'="" efficacy=$ZCONVERT(efficacy,"U") //转换成大写
	s:attending'="" attending=$ZCONVERT(attending,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s ID=0
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TCMAcupointsD(ID))
		q:ID=""
		s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)				//编辑时间
		s ^TempDataHandle($ZNAME,$JOB,"Short",OperatTime,ID)=ID
	}
 	s num=0
	//s OperatTime=$o(^TempDataHandle("short",""),-1)
	s OperatTime=""
	for
	{
		s OperatTime=$o(^TempDataHandle($ZNAME,$JOB,"Short",OperatTime),-1)
		q:OperatTime=""
		s AcupointsID=0
		for
		{
			s AcupointsID=$o(^CT.WDT.CDSS.TCMAcupointsI("OperatTimeIndex",OperatTime,AcupointsID))
			q:AcupointsID=""
			s num=num+1
			s ^TempDataHandle($ZNAME,$JOB,"Handle",num)=AcupointsID
	    }
	}
	
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle($ZNAME,$JOB,"Handle",Number))
		q:Number=""
		s ID=^TempDataHandle($ZNAME,$JOB,"Handle",Number)

		s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴编码
		s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
		s AcupointsAlias= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),4)       //别名
		continue:((alias'="")&&(AcupointsAlias'[alias))
		s AcupointsGenus= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),5)       //类属
		continue:((genus'="")&&(AcupointsGenus'[genus))
		s AcupointsChannelTropism= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),6)       //归经
		continue:((channeltropism'="")&&(AcupointsChannelTropism'[channeltropism))
		s AcupointsEfficacy= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),7)       //功效
		continue:((efficacy'="")&&(AcupointsEfficacy'[efficacy))
		s AcupointsAttending= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),8)       //主治
		continue:((attending'="")&&(AcupointsAttending'[attending))
		s Operator= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),9)       //操作人
		s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)       //操作时间
		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))
        s State= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),11)        //状态（0编辑中，1已弃用，2已审核）		    
		s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"")
		s Remarks= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),12)        //备注
	 	//替换双引号
		s AcupointsCode=$replace(AcupointsCode,"""","”")
		s AcupointsName=$replace(AcupointsName,"""","”")
		s AcupointsAlias=$replace(AcupointsAlias,"""","”")
		s AcupointsGenus=$replace(AcupointsGenus,"""","”")
		s AcupointsChannelTropism=$replace(AcupointsChannelTropism,"""","”")
		s AcupointsEfficacy=$replace(AcupointsEfficacy,"""","”")
		s AcupointsAttending=$replace(AcupointsAttending,"""","”")
		s Operator=$replace(Operator,"""","”")
		s OperatTime=$replace(OperatTime,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s State=$replace(State,"""","”")
		s str=AcupointsCode_","_AcupointsName_","_AcupointsAlias_","_AcupointsGenus_","_AcupointsChannelTropism_","_AcupointsEfficacy_","_AcupointsAttending_","_Operator_","_OperatTime_","_Remarks_","_State
		d file.WriteLine(str)
		//s sum = sum+1
	}
	
	
	
	d file.%Save()
	d file.%Close()
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

// ,name,alias,genus,channeltropism,efficacy,attending,state,user,StartTime,EndTime

/// Creator:胡宜良
/// CreatDate:2021-11-8
/// Description:导出腧穴字典数据
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMAcupoints).ExportDataTXT()
ClassMethod ExportDataTXT(desc As %String, alias As %String, genus As %String, channeltropism As %String, efficacy As %String, attending As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"腧穴字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"腧穴字典数据.txt"		
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
	w "腧穴编码	腧穴名称	别名	类属	归经	功效	主治	操作人员	操作时间	备注	状态"
	
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:genus'="" genus=$ZCONVERT(genus,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:channeltropism'="" channeltropism=$ZCONVERT(channeltropism,"U") //转换成大写
	s:efficacy'="" efficacy=$ZCONVERT(efficacy,"U") //转换成大写
	s:attending'="" attending=$ZCONVERT(attending,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.TCMAcupointsI("OperatTimeIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.TCMAcupointsI("OperatTimeIndex",UpdateTime,ID))
			q:ID=""
			s AcupointsCode= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),2)       //腧穴编码
			s AcupointsName= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),3)       //腧穴名称
			s AcupointsAlias= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),4)       //别名
			//continue:((alias'="")&&($ZCONVERT(AcupointsAlias,"U")'[alias))
			continue:(($ZCONVERT(AcupointsAlias,"U")'[alias)&&(alias'=""))
			s AcupointsGenus= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),5)       //类属
			continue:((genus'="")&&(AcupointsGenus'[genus))
			s AcupointsChannelTropism= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),6)       //归经
			continue:((channeltropism'="")&&(AcupointsChannelTropism'[channeltropism))
			s AcupointsEfficacy= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),7)       //功效
			continue:((efficacy'="")&&(AcupointsEfficacy'[efficacy))
			s AcupointsAttending= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),8)       //主治
			continue:((attending'="")&&(AcupointsAttending'[attending))
			s Operator= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),9)       //操作人
			s OperatTime= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),10)       //操作时间
			continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))
        	s State= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),11)        //状态（0编辑中，1已弃用，2已审核）		    
			s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"")
			continue:((($ZCONVERT(State,"U")'[state)&&(state'=""))||((state="")&&(State="已弃用")))
			s Remarks= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(ID)),12)        //备注
	 		//替换双引号
			s AcupointsCode=$replace(AcupointsCode,"""","”")
			s AcupointsName=$replace(AcupointsName,"""","”")
			s AcupointsAlias=$replace(AcupointsAlias,"""","”")
			s AcupointsGenus=$replace(AcupointsGenus,"""","”")
			s AcupointsChannelTropism=$replace(AcupointsChannelTropism,"""","”")
			s AcupointsEfficacy=$replace(AcupointsEfficacy,"""","”")
			s AcupointsAttending=$replace(AcupointsAttending,"""","”")
			s Operator=$replace(Operator,"""","”")
			s OperatTime=$replace(OperatTime,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s State=$replace(State,"""","”")
	
			w !,AcupointsCode_"	"_AcupointsName_"	"_AcupointsAlias_"	"_AcupointsGenus_"	"_AcupointsChannelTropism_"	"_AcupointsEfficacy_"	"_AcupointsAttending_"	"_Operator_"	"_OperatTime_"	"_Remarks_"	"_State
	    }
	}
	c file
	q fileName
}

/// Creator:胡宜良
/// CreatDate: 2021-8-17
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.TCMAcupoints 腧穴字典
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMAcupoints).FormValidate("414","12345","12345")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TCMAcupointsI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TCMAcupointsI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TCMAcupointsI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TCMAcupointsI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMAcupoints).ValidateAlias("","")
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
		
		s Alias=$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMAcupoints"," "_Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMAcupointsI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMAcupoints"," "_Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMAcupointsI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:胡宜良
/// CreatDate: 2021-8-15
/// Description：保存 腧穴字典
/// Table:CT.WDT.CDSS.TCMAcupoints 腧穴字典
/// Input: eobj As web.CDSSEntity.CMKB.TCMAcupoints
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.CMKB.TCMAcupoints).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TCMAcupoints) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		
		s flag=..FormValidate(eobj.ID,eobj.AcupointsCode,eobj.AcupointsName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.AcupointsName,eobj.AcupointsAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMAcupoints).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.TCMAcupoints).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
			s bobj.ID = eobj.ID
			s bobj.AcupointsCode = obj.AcupointsCode			
			s bobj.AcupointsName = obj.AcupointsName	             	
			s bobj.AcupointsAlias = obj.AcupointsAlias					
			s bobj.AcupointsGenus = obj.AcupointsGenus					
			s bobj.AcupointsChannelTropism = obj.AcupointsChannelTropism					
			s bobj.AcupointsEfficacy = obj.AcupointsEfficacy		
			s bobj.AcupointsAttending = obj.AcupointsAttending	
			s bobj.Operator = obj.Operator
		    s bobj.OperatTime = obj.OperatTime
			s bobj.State = obj.State		
			s bobj.Remarks=obj.Remarks	
		}
		    s obj.AcupointsCode = eobj.AcupointsCode			
		    s obj.AcupointsName = eobj.AcupointsName	             	
		    s obj.AcupointsAlias = eobj.AcupointsAlias					
		    s obj.AcupointsGenus = eobj.AcupointsGenus					
		    s obj.AcupointsChannelTropism = eobj.AcupointsChannelTropism					
		    s obj.AcupointsEfficacy = eobj.AcupointsEfficacy		
		    s obj.AcupointsAttending = eobj.AcupointsAttending
		    //s obj.Operator =$g(%session.Data("LOGON.USERNAME"))
		    //s obj.OperatTime = $ZDATETIME($HOROLOG,3)
		    s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.Operator=eobj.Operator
			s eobj.OperatTime=$ZDATETIME($H,3)						//编辑时间
			s obj.OperatTime=eobj.OperatTime	
		    s obj.State = eobj.State			
		    s obj.Remarks=eobj.Remarks	
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典",id,eobj.AcupointsCode_"-"_eobj.AcupointsName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典",id,eobj.AcupointsCode_"-"_eobj.AcupointsName_"-"_eobj.Remarks,"U",eobj,bobj)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.AcupointsAlias'=""))||((eobj.ID'="")&&(eobj.AcupointsAlias'=bobj.AcupointsAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMAcupoints",id,eobj.AcupointsAlias)
            	}
            
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("腧穴字典","web.CDSS.CMKB.TCMAcupoints","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    }	
	    }
	    else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	    q result
ERROR
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("腧穴字典","web.CDSS.CMKB.TCMAcupoints","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2021-8-19
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.TCMAcupoints).UpdateState("427","通过")
ClassMethod UpdateState(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMAcupoints).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New() 
	s bobj.State=obj.State
	s bobj.Operator=obj.Operator
	s bobj.OperatTime=obj.OperatTime
		
	s obj.State=eobj.State
 	s obj.Operator=eobj.Operator
 	s obj.OperatTime=eobj.OperatTime
	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.State= "2"){
	        s lineI=obj.AcupointsName_",识别条件,主要条件-识别词,1,腧穴名称,"_obj.AcupointsName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典表",id,obj.AcupointsName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-19
/// Description：得到新增数据的code
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.TCMAcupoints(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.TCMAcupoints(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-19
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
	s eobj.ID = id
	s eobj.AcupointsCode = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),2)
	s eobj.AcupointsName = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),3)
	s eobj.AcupointsAlias = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),4)
	s eobj.AcupointsGenus = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),5)
	s eobj.AcupointsChannelTropism = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),6)
	s eobj.AcupointsEfficacy = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),7)
	s eobj.AcupointsAttending = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),8)
    s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),9)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),10)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),11)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-8-19
/// Description：打开数据
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
	s eobj.ID = id
	s eobj.AcupointsCode = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),2)
	s eobj.AcupointsName = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),3)
	s eobj.AcupointsAlias = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),4)
	s eobj.AcupointsGenus = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),5)
	s eobj.AcupointsChannelTropism = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),6)
	s eobj.AcupointsEfficacy = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),7)
	s eobj.AcupointsAttending = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),8)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),9)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),10)
	s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),11)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2020-08-30
/// Description:数据删除方法
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMAcupoints).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	s obj=##class(CT.WDT.CDSS.TCMAcupoints).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
	s bobj.ID = id
	s bobj.AcupointsCode = obj.AcupointsCode			
	s bobj.AcupointsName = obj.AcupointsName	             	
	s bobj.AcupointsAlias = obj.AcupointsAlias					
	s bobj.AcupointsGenus = obj.AcupointsGenus					
	s bobj.AcupointsChannelTropism = obj.AcupointsChannelTropism					
	s bobj.AcupointsEfficacy = obj.AcupointsEfficacy		
	s bobj.AcupointsAttending = obj.AcupointsAttending	
	s bobj.Operator = obj.Operator
    s bobj.OperatTime = obj.OperatTime
  	s bobj.State=obj.State		
	s bobj.Remarks=obj.Remarks
	Ts
	s sc=##class(CT.WDT.CDSS.TCMAcupoints).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典",id,bobj.AcupointsName,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMAcupoints",id)
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("腧穴字典","web.CDSS.CMKB.TCMAcupoints","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).BatchConfirm()
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
			s re= ..UpdateState(ConID,"通过")
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
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).BatchCancel()
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
			s re= ..UpdateState(ConID,"驳回")
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
/// CreatDate:2021-10-27
/// Description:获得别名列表
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMAcupoints","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s AcupointsAlias=$LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),4)
		s Len=$Length(AcupointsAlias,",")
		for i=1:1:Len{
			s Desc=$p(AcupointsAlias,",",i)
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
/// Table：CT.WDT.CDSS.TCMAcupoints
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMAcupointsD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMAcupointsD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMAcupoints",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.TCMAcupoints
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMAcupoints).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMAcupointsD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMAcupointsD(RowId)),11)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMAcupoints","GetLogList","524")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,OperatTime,UpdateTime,OperatorName,Operation")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMAcupoints",RowId,LogID),-1) q:LogID=""
	    	s OperatorName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s OperatTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s OperatTime=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OperatTime)
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
	set Data=$lb(LogID,OperatTime,UpdateTime,OperatorName,Operation)
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

/// w ##class(web.CDSS.CMKB.TCMAcupoints).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
 	/*/识别词项目引用接口
    s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMAcupointsD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("腧穴名称",MedicineName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr*/

	//规则(处置明细)引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("腧穴",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.TCMAcupoints
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMAcupoints).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMAcupoints) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,eobj.AcupointsCode,eobj.AcupointsName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.AcupointsName,eobj.AcupointsAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMAcupoints).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMAcupoints).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMAcupoints).%New()
			s bobj.AcupointsName=obj.AcupointsName          //修改描述
            s bobj.Operator=obj.Operator
            s bobj.OperatTime=obj.OperatTime
            s bobj.AcupointsAlias=obj.AcupointsAlias
			
		}
		
		s obj.AcupointsName = eobj.AcupointsName          //修改描述
        s eobj.Operator =$g(%session.Data("LOGON.USERNAME"))
        s obj.Operator =eobj.Operator
        s eobj.OperatTime=$ZDATETIME($HOROLOG,3)
        s obj.OperatTime= eobj.OperatTime
        s obj.AcupointsAlias=eobj.AcupointsAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典",id,eobj.AcupointsCode_"-"_eobj.AcupointsName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMAcupoints","CT.WDT.CDSS.TCMAcupoints","腧穴字典",id,eobj.AcupointsCode_"-"_eobj.AcupointsName_"-"_eobj.Remarks,"U",eobj,bobj)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.AcupointsAlias'=""))||((eobj.ID'="")&&(eobj.AcupointsAlias'=bobj.AcupointsAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMAcupoints",id,eobj.AcupointsAlias)
            }
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("腧穴字典","web.CDSS.CMKB.TCMAcupoints","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("腧穴字典","web.CDSS.CMKB.TCMAcupoints","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
