/// 名称:中药煎法字典
/// 描述:基础维护
/// 编写者:基础平台组 - 胡宜良
/// 编写日期:2021-08-20
Class web.CDSS.CMKB.TCMDecoction Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：胡宜良		
/// CreatDate: 2021-08-20
/// Description：查询数据 
/// Table:CT.WDT.CDSS.TCMDecoction 
/// Input:rowid,code(代码),desc(名字),applyname(适用中药),state(状态),starttime(开始时间),endtime(结束时间),updateuser(操作人)
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDecoction","GetList","","","","","","","")
Query GetList(rowid As %String, desc As %String, alias As %String, applyname As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod) As %Query(ROWSPEC = "ID,DecoctionCode,DecoctionName,DecoctionApplication,State,Operator,OperatTime,Remarks,DecoctionAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, applyname As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, sortmethod) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //中药煎法编码
		s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //中药煎法名称
		s DecoctionApplication= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),4)       //适用中药   
	    s Operator= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),5) 	//操作人员
	    s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)     //操作时间
	    s State= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    s Remarks= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),8)        //备注
	    s DecoctionAlias= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),9)
	    d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s:applyname'="" applyname=$ZCONVERT(applyname,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		
		s ID=0
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMDecoctionD(ID))
				q:ID=""
				s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)		//名称
				s length=$l(DecoctionName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMDecoctionD(ID))
				q:ID=""
				s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)				//编辑时间
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
			for
			{
				s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,ID)) q:ID=""
				s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //中药煎法编码
			    s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //中药煎法名称
			    s DecoctionApplication= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),4)       //适用中药
			    continue:((applyname'="")&&(DecoctionApplication'[applyname))
		   	 	s State= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
		    	s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
		    	continue:((state="")&&(State="已弃用"))
		    	s Operator= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),5) 	   //编辑人员
		    	s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)     //编辑时间
		    	s Remarks= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),8)        //备注
		    	s DecoctionAlias= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),9)        //别名
		    	continue:((alias'="")&&($ZCONVERT(DecoctionAlias,"U")'[alias))
			    if ($ZCONVERT(Operator,"U")[user)&($ZCONVERT(DecoctionName,"U")[desc)&($ZCONVERT(State,"U")[state)
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
						b ;
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
    set Data=$lb(ID,DecoctionCode,DecoctionName,DecoctionApplication,State,Operator,OperatTime,Remarks,DecoctionAlias)
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
/// Description：查询 中药煎法 
/// Table:CT.WDT.CDSS.TCMDecoction
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDecoction","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ID,DecoctionCode,DecoctionName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //中药煎法编码
	s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //中药煎法名称
  	d OutputRowCmb
 }
 else
 {
	
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TCMDecoctionD(ID))
		q:ID=""
		s DecoctionName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)		//名称
		s length=$l(DecoctionName)
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
			
  			s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //中药煎法编码
		    s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //中药煎法名称
  			s State= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),7) 
  			//continue:(State=2)
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DecoctionName)  
  			if (($ZCONVERT(DecoctionName,"U")[desc)||(PINYIN[desc))&(State=2) 
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
    set Data=$lb(ID,DecoctionCode,DecoctionName)
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

/// Creator:胡宜良
/// CreatDate:2021-8-26
/// Description：导入中药煎法字典
/// Table：CT.WDT.CDSS.TCMDecoction中药煎法字典
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).ImportDataTXT("D:\Works\Decoction.txt")
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
		
		s DecoctionCode= $p(data,$c(9),1)       //中药煎法编码
		s DecoctionName= $p(data,$c(9),2)       //中药煎法名称
		s DecoctionApplication= $p(data,$c(9),3)       //适用中药
	    ;s Remarks= $p(data,$c(9),4)        //备注

		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
		s eobj.DecoctionCode = DecoctionCode		
		s eobj.DecoctionName = DecoctionName	             	
		s eobj.DecoctionApplication = DecoctionApplication					
	    s eobj.Operator = "dhcc"
		s eobj.OperatTime = $ZDATETIME($HOROLOG,3)	
		s eobj.State = 2	
		s eobj.Remarks = ""					
		
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
/// Description:导出中药煎法字典数据
/// Table：CT.WDT.CDSS.TCMDecoction中药煎法字典
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMDecoction).ExportData()
ClassMethod ExportData(desc As %String, state As %String, user As %String, applyname As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="中药煎法字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("编号,名称,适用中药,编辑人员,编辑时间,备注,状态")
	//d file.WriteLine()
	

	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:applyname'="" applyname=$ZCONVERT(applyname,"U") //转换成大写
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")

	s ID=0
	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TCMDecoctionD(ID))
		q:ID=""
		s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)				//编辑时间
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",OperatTime,ID)=ID
	}
 	s num=0
	s OperatTime=$o(^TempDataHandle($ZNAME,repid,$JOB,"short",""),-1)
	for
	{
		s OperatTime=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",OperatTime),-1)
		q:OperatTime=""
		s TcmdID=0
		for
		{
			s TcmdID=$o(^CT.WDT.CDSS.TCMDecoctionI("OperatTimeIndex",OperatTime,TcmdID))
			q:TcmdID=""
			s num=num+1
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",num)=TcmdID
	    }
	}
	
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number))
		q:Number=""
		s ID=^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)
		s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //编号
		s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //名称
		continue:(($ZCONVERT(DecoctionName,"U")'[desc)&&(desc'=""))
		s DecoctionApplication= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),4)
		continue:(($ZCONVERT(DecoctionApplication,"U")'[applyname)&&(applyname'=""))
	   	s State= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    continue:((($ZCONVERT(State,"U")'[state)&&(state'=""))||((state="")&&(State="已弃用")))
	    s Operator= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),5) 	   //编辑人员
	    continue:(($ZCONVERT(Operator,"U")'[user)&&(user'=""))
	    s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)     //编辑时间
		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))	
	    s Remarks= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),8)        //备注
		
	 	//替换双引号
		s DecoctionCode=$replace(DecoctionCode,"""","”")
		s DecoctionName=$replace(DecoctionName,"""","”")
		s DecoctionApplication=$replace(DecoctionApplication,"""","”")
		s Operator=$replace(Operator,"""","”")
		s OperatTime=$replace(OperatTime,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s State=$replace(State,"""","”")
		s str=DecoctionCode_","_DecoctionName_","_DecoctionApplication_","_Operator_","_OperatTime_","_Remarks_","_State
		d file.WriteLine(str)
		//s sum = sum+1
	}
	
	
	
	d file.%Save()
	d file.%Close()
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

/// Creator:胡宜良
/// CreatDate:2021-11-8
/// Description:导出中药煎法字典数据
/// Table：CT.WDT.CDSS.TCMDecoction中药煎法字典
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMDecoction).ExportDataTXT()
ClassMethod ExportDataTXT(desc As %String, alias As %String, state As %String, user As %String, applyname As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"中药煎法字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中药煎法字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if 
	
	
	o file:"NWS"
	u file
	w "编号	中药煎法名称	别名	适用中药	编辑人员	编辑时间	备注	状态"
	
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:applyname'="" applyname=$ZCONVERT(applyname,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.TCMDecoctionI("OperatTimeIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.TCMDecoctionI("OperatTimeIndex",UpdateTime,ID))
			q:ID=""
			
			s DecoctionCode= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),2)       //编号
			s DecoctionName= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),3)       //名称
			continue:(($ZCONVERT(DecoctionName,"U")'[desc)&&(desc'=""))
			s DecoctionApplication= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),4)
			continue:(($ZCONVERT(DecoctionApplication,"U")'[applyname)&&(applyname'=""))
	   		s State= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    	s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    	continue:((($ZCONVERT(State,"U")'[state)&&(state'=""))||((state="")&&(State="已弃用")))
	    	s Operator= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),5) 	   //编辑人员
	    	continue:(($ZCONVERT(Operator,"U")'[user)&&(user'=""))
	    	s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),6)     //编辑时间
			continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))	
	    	s Remarks= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),8)        //备注
	    	s DecoctionAlias= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(ID)),9) 
			continue:(($ZCONVERT(DecoctionAlias,"U")'[alias)&&(alias'=""))
	 		//替换双引号
			s DecoctionCode=$replace(DecoctionCode,"""","”")
			s DecoctionName=$replace(DecoctionName,"""","”")
			s DecoctionApplication=$replace(DecoctionApplication,"""","”")
			s Operator=$replace(Operator,"""","”")
			s OperatTime=$replace(OperatTime,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s State=$replace(State,"""","”")
	
			w !,DecoctionCode_"	"_DecoctionName_"	"_DecoctionAlias_"	"_DecoctionApplication_"	"_Operator_"	"_OperatTime_"	"_Remarks_"	"_State
	    }
	}
	c file
	q fileName
}

/// Creator:胡宜良
/// CreatDate:2021-8-26
/// Description：数据重复验证方法，由js调用
/// Table：CT.WDT.CDSS.TCMDecoction煎法字典
/// Input：Id；code；desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMDecoction).FormValidate("","1","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TCMDecoctionI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TCMDecoctionI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TCMDecoctionI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TCMDecoctionI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMDecoction).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMDecoction"," "_Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMDecoctionI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMDecoction"," "_Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMDecoctionI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate:2021-8-24
/// Description：保存中药煎法字典的内容
/// Table：CT.WDT.CDSS.TCMDecoction
/// Input：web.CDSSEntity.CMKB.TCMDecoction 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.TCMDecoction).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TCMDecoction) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		
		s flag=..FormValidate(eobj.ID,eobj.DecoctionCode,eobj.DecoctionName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DecoctionName,eobj.DecoctionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMDecoction).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDecoction).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
			s bobj.ID = eobj.ID
			s bobj.DecoctionCode = obj.DecoctionCode			
			s bobj.DecoctionName = obj.DecoctionName	             	
			s bobj.DecoctionApplication = obj.DecoctionApplication						
			s bobj.Operator = obj.Operator
		    s bobj.OperatTime = obj.OperatTime
			s bobj.State = obj.State		
			s bobj.Remarks=obj.Remarks
			s bobj.DecoctionAlias=obj.DecoctionAlias	
		}
		    s obj.DecoctionCode = eobj.DecoctionCode			
		    s obj.DecoctionName = eobj.DecoctionName	             	
		    s obj.DecoctionApplication = eobj.DecoctionApplication					
		    //s obj.Operator =$g(%session.Data("LOGON.USERNAME"))
		    //s obj.OperatTime = $ZDATETIME($HOROLOG,3)	
		    s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.Operator=eobj.Operator
			s eobj.OperatTime=$ZDATETIME($H,3)						//编辑时间
			s obj.OperatTime=eobj.OperatTime
		    s obj.State = eobj.State			
		    s obj.Remarks=eobj.Remarks
		    s obj.DecoctionAlias=eobj.DecoctionAlias
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典",id,eobj.DecoctionCode_"-"_eobj.DecoctionName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典",id,eobj.DecoctionCode_"-"_eobj.DecoctionName_"-"_eobj.Remarks,"U",eobj,bobj)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.DecoctionAlias'=""))||((eobj.ID'="")&&(eobj.DecoctionAlias'=bobj.DecoctionAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDecoction",id,eobj.DecoctionAlias)
            	}
            
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中药煎法字典","web.CDSS.CMKB.TCMDecoction","SaveEntity",eobj)
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
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药煎法字典","web.CDSS.CMKB.TCMDecoction","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2021-8-26
/// Description：得到新增数据的code
/// Table：CT.WDT.CDSS.TCMDecoction
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.TCMDecoctionD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.TCMDecoctionD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-26
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.TCMDecoction
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
	s eobj.ID = id
	s eobj.DecoctionCode = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),2)
	s eobj.DecoctionName = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),3)
	s eobj.DecoctionApplication = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),4)
	s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),5)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),6)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),8)
	s eobj.DecoctionAlias = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),9)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-8-26
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.TCMDecoction
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.TCMDecoction).UpdateState("1","1")
ClassMethod UpdateState(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMDecoction).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New() 
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
			s lineI=obj.DecoctionName_",识别条件,主要条件-识别词,1,中药煎法名称,"_obj.DecoctionName_",0"
			d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典表",id,obj.DecoctionName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：打开数据
/// Table：CT.WDT.CDSS.TCMDecoction
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
	s eobj.ID = id
	s eobj.DecoctionCode = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),2)
	s eobj.DecoctionName = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),3)
	s eobj.DecoctionApplication = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),4)
    s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),5)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),6)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),8)
	s eobj.DecoctionAlias = $LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),9)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2020-08-30
/// Description:数据删除方法
/// Table:CT.WDT.CDSS.TCMDecoction
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDecoction).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	s obj=##class(CT.WDT.CDSS.TCMDecoction).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
	s bobj.ID = id
	s bobj.DecoctionCode = obj.DecoctionCode			
	s bobj.DecoctionName = obj.DecoctionName	             	
	s bobj.DecoctionApplication = obj.DecoctionApplication						
	s bobj.Operator = obj.Operator
	s bobj.OperatTime = obj.OperatTime
	s bobj.State = obj.State		
	s bobj.Remarks=obj.Remarks
	s bobj.DecoctionAlias=obj.DecoctionAlias
	Ts
	s sc=##class(CT.WDT.CDSS.TCMDecoction).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典",id,bobj.DecoctionName,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMDecoction",id)

		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中药煎法字典","web.CDSS.CMKB.TCMDecoction","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.TCMDecoction
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).BatchConfirm()
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
/// Table:CT.WDT.CDSS.TCMDecoction
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).BatchCancel()
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
/// CreatDate:2022-1-20
/// Description:获得别名列表
/// Table:CT.WDT.CDSS.TCMDecoction
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDecoction","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s DecoctionAlias=$LISTGET($G(^CT.WDT.CDSS.TCMDecoctionD(id)),9)
		s Len=$Length(DecoctionAlias,",")
		for i=1:1:Len{
			s Desc=$p(DecoctionAlias,",",i)
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
/// Table：CT.WDT.CDSS.TCMDecoction
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMDecoctionD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMDecoctionD(RowId)),9)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDecoction",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.TCMDecoction
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMDecoction).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMDecoctionD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMDecoctionD(RowId)),7)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDecoction","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMDecoction",RowId,LogID),-1) q:LogID=""
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
/// Table： CT.WDT.CDSS.TCMDecoction
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMDecoction).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMDecoction) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,eobj.DecoctionCode,eobj.DecoctionName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DecoctionName,eobj.DecoctionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMDecoction).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDecoction).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDecoction).%New()
			s bobj.DecoctionName=obj.DecoctionName          //修改描述
            s bobj.Operator=obj.Operator
            s bobj.OperatTime=obj.OperatTime
            s bobj.DecoctionAlias=obj.DecoctionAlias
			
		}
		
		s obj.DecoctionName = eobj.DecoctionName          //修改描述
        s eobj.Operator =$g(%session.Data("LOGON.USERNAME"))
        s obj.Operator =eobj.Operator
        s eobj.OperatTime=$ZDATETIME($HOROLOG,3)
        s obj.OperatTime= eobj.OperatTime
        s obj.DecoctionAlias=eobj.DecoctionAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典",id,eobj.DecoctionCode_"-"_eobj.DecoctionName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDecoction","CT.WDT.CDSS.TCMDecoction","中药煎法字典",id,eobj.DecoctionCode_"-"_eobj.DecoctionName_"-"_eobj.Remarks,"U",eobj,bobj)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.DecoctionAlias'=""))||((eobj.ID'="")&&(eobj.DecoctionAlias'=bobj.DecoctionAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDecoction",id,eobj.DecoctionAlias)
            }
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中药煎法字典","web.CDSS.CMKB.TCMDecoction","SaveEntity",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药煎法字典","web.CDSS.CMKB.TCMDecoction","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
