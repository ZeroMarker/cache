/// 名称:中医疾病字典
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-8-24
Class web.CDSS.CMKB.TCMDisease Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-8-24
/// Description：查询 
/// Table:User. DHCDSSTCMDisease中医疾病字典
/// Input:id,code,desc,medname
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDisease","GetList","","","","","霍乱","","","","","","")
Query GetList(rowid As %String, discode As %String, desc As %String, alias As %String, medname As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, quoteflag As %String, version As %String, sortmethod) As %Query(ROWSPEC = "ID,DiseaseCode,DiseaseName,DiseaseMedicineName,State,Operator,OperatTime,Remarks,QuoteFlag,DiseaseAlias,Version,SymptomName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, discode As %String, desc As %String, alias As %String, medname As %String, state As %String, user As %String, StartTime As %String, EndTime As %String, quoteflag As %String, version As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),2)       //中医疾病编码
		s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)       //中医疾病名称
		s TCMDiseDR=rowid
	 	s DiseaseDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseTCMIndex",TCMDiseDR,0))
	 	s:DiseaseDR'="" DiseaseMedicineName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3) //对应西医名称
	 	s:DiseaseDR="" DiseaseMedicineName=""
				
	 	s TCMDiseDR=rowid
	 	s TCMSymDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",TCMDiseDR,0))
	 	s:TCMSymDR'="" SymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3) //证型
	 	s:TCMSymDR="" SymptomName=""
		
	    s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    s Operator= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),5) 	//操作人员
	    s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)     //操作时间
	    
	    s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),8)        //备注
		s QuoteFlag= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),9)        //引用标志
		s DiseaseAlias= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),10)        //别名
		s Version= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),11)        //版本
		d OutputRow
	}
	else
	{
		s:discode'="" discode=$ZCONVERT(discode,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s:medname'="" medname=$ZCONVERT(medname,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s:version'="" version=$ZCONVERT(version,"U") //转换成大写
		s ID=0
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMDiseaseD(ID))
				q:ID=""
				s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)		//名称
				s length=$l(DiseaseName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMDiseaseD(ID))
				q:ID=""
				s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)				//编辑时间
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
			
				s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),2)       //疾病编码
				continue:((discode'="")&&(DiseaseCode'[discode))
			    s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)       //疾病名称
			    
		 		s DiseaseMedicineName=""
		 		
			    
			    if ($d(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",ID)))
			    {
					s DisJTCMDis=0
					for 
					{
						
						s DisJTCMDis=$O(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",ID,DisJTCMDis))
						q:DisJTCMDis=""
						
						s DiseaseDR=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(DisJTCMDis)),9)
						if (DiseaseDR'="")
						{	
							s DiseaseMedicineDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
							s:DiseaseMedicineName'="" DiseaseMedicineName=DiseaseMedicineName_","_DiseaseMedicineDesc
							s:DiseaseMedicineName="" DiseaseMedicineName=DiseaseMedicineDesc
								
						}
					}
					 	
				}
		 		s TCMSymDR=""
		 		s SymptomName=""
		 		for
		 		{
			 		s TCMSymDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",ID,TCMSymDR))
					q:TCMSymDR=""
					s SymptomN=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3) //证型
					if (SymptomName="")
					{
						s SymptomName=SymptomN	
					}
					else
					{
						s SymptomName=SymptomName_","_SymptomN
					}
			 	}
		 		
		 			
		   	 	s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
		    	s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
		    	continue:((state="")&&(State="已弃用"))
		    	s Operator= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),5) 	   //编辑人员
		    	s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)     //编辑时间
		    	s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),8)        //备注
		    	s QuoteFlag=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),9) //引用标志
	 			continue:(QuoteFlag'[quoteflag)
	 			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	 			s DiseaseAlias= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),10)        //别名
		    	continue:((alias'="")&&($ZCONVERT(DiseaseAlias,"U")'[alias))
		    	s Version= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),11)        //版本
		    	continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
			    if ($ZCONVERT(Operator,"U")[user)&($ZCONVERT(DiseaseName,"U")[desc)&($ZCONVERT(State,"U")[state)&($ZCONVERT(DiseaseMedicineName,"U")[medname)
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
    set Data=$lb(ID,DiseaseCode,DiseaseName,DiseaseMedicineName,State,Operator,OperatTime,Remarks,QuoteFlag,DiseaseAlias,Version,SymptomName)
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
/// Description：查询 中医疾病 
/// Table:CT.WDT.CDSS.TCMDisease中医疾病字典
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDisease","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "ID:%String,DiseaseCode:%String,DiseaseName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(RowId)),2)       //中医疾病编码
	s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(RowId)),3)       //中医疾病名称
  	d OutputRowCmb
 }
 else
 {
	
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s DiseaseID=0
	for 
	{
		s DiseaseID=$o(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID))
		q:DiseaseID=""
		s DiseaseDesc=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),3)		//中医疾病名称
		s length=$l(DiseaseDesc)
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,DiseaseID)=DiseaseID
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
  			s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),2)       //中医疾病编码
		    s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)       //中医疾病名称
  			s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),7) 
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)  
  			if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc))&($ZCONVERT(DiseaseName,"U")[q)||($ZCONVERT(DiseaseName,"U")[q)&(State=2) 
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
    set Data=$lb(ID,DiseaseCode,DiseaseName)
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
/// CreatDate:2021-8-24
/// Description：导入中医疾病字典
/// Table：CT.WDT.CDSS.TCMDisease中医疾病字典
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).ImportDataTXT("D:\Works\Disease.txt")
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
		
		s DiseaseCode= $p(data,$c(9),1)       //中医疾病编码
		s DiseaseName= $p(data,$c(9),2)       //中医疾病名称
		s DiseaseAlias= $p(data,$c(9),3)       //对应西医名称
	    s Version= $p(data,$c(9),4)        //备注

		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
		s eobj.DiseaseCode = DiseaseCode		
		s eobj.DiseaseName = DiseaseName	             	
		s eobj.DiseaseMedicineName = ""	
		s eobj.DiseaseAlias=DiseaseAlias				
		s eobj.Version=Version
		s eobj.Operator = "dhcc"
		s eobj.OperatTime = $ZDATETIME($HOROLOG,3)	
		s eobj.State = 2	
		s eobj.Remarks = ""					
		//s eobj.Symptom = ""
		
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
/// Description:导出中医疾病字典数据
/// Table：CT.WDT.CDSS.TCMDisease中医疾病字典
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMDisease).ExportData()
ClassMethod ExportData(desc As %String, state As %String, user As %String, medname As %String, StartTime As %String, EndTime As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="中医疾病字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	
	d file.Open("NWS")
	d file.WriteLine("编号,名称,对应西医名称,编辑人员,编辑时间,备注,状态")
	//d file.WriteLine()
	

	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:medname'="" medname=$ZCONVERT(medname,"U") //转换成大写
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")

	s ID=0
	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TCMDiseaseD(ID))
		q:ID=""
		s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)				//编辑时间
		s ^TempDataHandle($ZNAME,repid,$JOB,"Short",OperatTime,ID)=ID
	}
 	s num=0
	//s OperatTime=$o(^TempDataHandle("short",""),-1)
	s OperatTime=""
	for
	{
		s OperatTime=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",OperatTime),-1)
		q:OperatTime=""
		s TcmdID=0
		for
		{
			s TcmdID=$o(^CT.WDT.CDSS.TCMDiseaseI("OperatTimeIndex",OperatTime,TcmdID))
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
		s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),2)       //编号
		s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)       //名称
		continue:(($ZCONVERT(DiseaseName,"U")'[desc)&&(desc'=""))
		s DiseaseMedicineName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),4)
		continue:(($ZCONVERT(DiseaseMedicineName,"U")'[medname)&&(medname'=""))
	   	s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	    s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    continue:((($ZCONVERT(State,"U")'[state)&&(state'=""))||((state="")&&(State="已弃用")))
	    s Operator= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),5) 	   //编辑人员
	    continue:(($ZCONVERT(Operator,"U")'[user)&&(user'=""))
	    s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)     //编辑时间
		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))	
	    s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),8)        //备注
	    s QuoteFlag= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),9)        //引用标志
	    
		
	 	//替换双引号
		s DiseaseCode=$replace(DiseaseCode,"""","”")
		s DiseaseName=$replace(DiseaseName,"""","”")
		s DiseaseMedicineName=$replace(DiseaseMedicineName,"""","”")
		s Operator=$replace(Operator,"""","”")
		s OperatTime=$replace(OperatTime,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s State=$replace(State,"""","”")
		s QuoteFlag=$replace(QuoteFlag,"""","”")
		s str=DiseaseCode_","_DiseaseName_","_DiseaseMedicineName_","_Operator_","_OperatTime_","_Remarks_","_State_","_QuoteFlag
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
/// Description:导出中医疾病字典数据
/// Table：CT.WDT.CDSS.TCMDisease中医疾病字典
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TCMDisease).ExportDataTXT()
ClassMethod ExportDataTXT(desc As %String, alias As %String, state As %String, user As %String, medname As %String, StartTime As %String, EndTime As %String, version As %String) As %String
{
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"中医疾病字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中医疾病字典数据.txt"		
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
	w "中医疾病编码	中医疾病名称	别名	对应西医名称	编辑人员	编辑时间	备注	状态	引用标志	版本"
	
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:medname'="" medname=$ZCONVERT(medname,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:version'="" version=$ZCONVERT(version,"U") //转换成大写
	s:state'="" state=$ZCONVERT(state,"U") //转换成大写
	s UpdateTime=""
	for {
		s UpdateTime=$o(^CT.WDT.CDSS.TCMDiseaseI("OperatTimeIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.TCMDiseaseI("OperatTimeIndex",UpdateTime,ID))
			q:ID=""
				
			s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),2)       //编号
			s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)       //名称
			continue:(($ZCONVERT(DiseaseName,"U")'[desc)&&(desc'=""))
			s DiseaseMedicineName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),4)
			continue:(($ZCONVERT(DiseaseMedicineName,"U")'[medname)&&(medname'=""))
	   		s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),7)        //状态（0编辑中，1已弃用，2已审核）
	   		s State=$case(State,"0":"编辑中","1":"已弃用","2":"已审核",:"")
	    	continue:((($ZCONVERT(State,"U")'[state)&&(state'=""))||((state="")&&(State="已弃用")))
	    	s Operator= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),5) 	   //编辑人员
	    	continue:(($ZCONVERT(Operator,"U")'[user)&&(user'=""))
	    	s OperatTime= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),6)     //编辑时间
			continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(OperatTime,3)>$zdh(EndTime,3))||($ZDH(OperatTime,3)<$zdh(StartTime,3)))
			continue:((StartTime="")&&(EndTime'=""))&&($ZDH(OperatTime,3)'=$zdh(EndTime,3))
			continue:((EndTime="")&&(StartTime'=""))&&($ZDH(OperatTime,3)'=$zdh(StartTime,3))	
	    	s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),8)        //备注
	    	s QuoteFlag= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),9)        //引用标志
	    	s DiseaseAlias= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),10)        //别名
	    	s Version= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),11)
		
	 		//替换双引号
			s DiseaseCode=$replace(DiseaseCode,"""","”")
			s DiseaseName=$replace(DiseaseName,"""","”")
			s DiseaseMedicineName=$replace(DiseaseMedicineName,"""","”")
			s Operator=$replace(Operator,"""","”")
			s OperatTime=$replace(OperatTime,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s State=$replace(State,"""","”")
			s QuoteFlag=$replace(QuoteFlag,"""","”")
			s DiseaseAlias=$replace(DiseaseAlias,"""","”")
			s Version=$replace(Version,"""","”")
	
			w !,DiseaseCode_"	"_DiseaseName_"	"_DiseaseAlias_"	"_DiseaseMedicineName_"	"_Operator_"	"_OperatTime_"	"_Remarks_"	"_State_"	"_QuoteFlag_"	"_Version
	    }
	}
	c file
	q fileName
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：数据重复验证方法，由js调用
/// Table：CT.WDT.CDSS.TCMDisease
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMDisease).FormValidate("1297","cs","测试")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TCMDiseaseI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TCMDiseaseI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",desc,0))
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMDisease).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias'=""){
			s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.TCMDisease",Alias,0))	//用别名表中别名数据校验别名重复
			s flagN=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(Alias,"U"),0))
			
			if ((flagA'="")||(flagN'="")){	//如果在别名表或字典表名称中存在
				if (id=""){		//新增，重复
					s flag=1
					q
				}else{			//修改，判断保存别名是否修改，若未修改则不重复
					s AliasId=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMDisease",Alias,id,0))
						
					if ((AliasId'=flagA)||(flagN'="")){	
						s flag=1
						q
					}
				}		
			}
		}
	}
	q flag
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：保存中医疾病字典的内容
/// Table：CT.WDT.CDSS.TCMDisease
/// Input：web.CDSSEntity.CMKB.TCMDisease 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.TCMDisease).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TCMDisease) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		q:eobj.DiseaseName=eobj.DiseaseAlias "{success:'false',errorinfo:'名称和别名不能重复！'}"
		s:eobj.DiseaseCode="" eobj.DiseaseCode=..getFactorCode()
		s flag=..FormValidate(eobj.ID,eobj.DiseaseCode,eobj.DiseaseName)  //调用重复验证
		//s flag=0
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DiseaseAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMDisease).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDisease).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
			s bobj.ID = eobj.ID
			s bobj.DiseaseCode = obj.DiseaseCode			
			s bobj.DiseaseName = obj.DiseaseName	             	
			s bobj.DiseaseMedicineName = obj.DiseaseMedicineName						
			s bobj.Operator = obj.Operator
		    s bobj.OperatTime = obj.OperatTime
			s bobj.State = obj.State		
			s bobj.Remarks=obj.Remarks	
			s bobj.DiseaseAlias=obj.DiseaseAlias
			s bobj.Version=obj.Version
		}
		    s obj.DiseaseCode = eobj.DiseaseCode			
		    s obj.DiseaseName = eobj.DiseaseName	             	
		    s obj.DiseaseMedicineName = eobj.DiseaseMedicineName					
		    //s obj.Operator = $g(%session.Data("LOGON.USERNAME"))		//"dhcc" //
		    //s obj.OperatTime = $ZDATETIME($HOROLOG,3)	
		    s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.Operator=eobj.Operator
			s eobj.OperatTime=$ZDATETIME($H,3)						//编辑时间
			s obj.OperatTime=eobj.OperatTime
		    s obj.State = eobj.State			
		    s obj.Remarks=eobj.Remarks
		    s obj.DiseaseAlias=eobj.DiseaseAlias
		    s obj.Version=eobj.Version
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			s id = obj.%Id()
			//d ##class(web.CDSS.CMKB.TCMDiseJSym).SaveSymData(id,eobj.Symptom) //关联证型保存
			Tc
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典",id,eobj.DiseaseCode_"-"_eobj.DiseaseName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典",id,eobj.DiseaseCode_"-"_eobj.DiseaseName_"-"_eobj.Remarks,"U",eobj,bobj)
			
			//同步修改识别词项目数据
			d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中医诊断名称",eobj.DiseaseName,bobj.DiseaseName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.DiseaseAlias'=""))||((eobj.ID'="")&&(eobj.DiseaseAlias'=bobj.DiseaseAlias))
           		{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDisease",id,eobj.DiseaseAlias)
            	}
            	
            	
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病字典","web.CDSS.CMKB.TCMDisease","SaveEntity",eobj)
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
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病字典","web.CDSS.CMKB.TCMDisease","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：得到新增数据的code
/// Table:User. DHCDSSTCMDisease中医疾病字典
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.TCMDiseaseD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.TCMDiseaseD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：修改时打开的数据
/// Table:User. DHCDSSTCMDisease中医疾病字典
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
	s eobj.ID = id
	s eobj.DiseaseCode = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),2)
	s eobj.DiseaseName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s eobj.DiseaseMedicineName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),4)
	s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),5)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),6)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),8)
	s eobj.DiseaseAlias = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),10)
	s eobj.Version = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),11)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：更改状态,审批驳回数据
/// Table：CT.WDT.CDSS.TCMDisease
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.TCMDisease).UpdateState("2524","通过")
ClassMethod UpdateState(id As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMDisease).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New() 
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
		//同步删除对照数据 
		if (obj.State= "1")||(obj.State= "0"){  
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("中医诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName)
		}
		
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.State= "2"){
            s lineD=obj.DiseaseName_",中医诊断条件,主要条件-识别词,1,中医诊断名称,"_obj.DiseaseName_",0"
            s lineI=obj.DiseaseName_",中医识别条件,主要条件-识别词,1,中医诊断症状名称,"_obj.DiseaseName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineD)
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典表",id,obj.DiseaseName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Other: w ##class(web.CDSS.CMKB.TCMDisease).UpdateUseFlag(1301,0)
ClassMethod UpdateUseFlag(id, State) As %String
{
	s result=""

	s obj=##class(CT.WDT.CDSS.TCMDisease).%OpenId(id)
	s obj.State=State
	s obj.OperatTime=$zdt($h,3)
 	s obj.Operator=$g(%session.Data("LOGON.USERNAME"))
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
		/*/同步删除对照数据 
		if (obj.State= 1)||(obj.State= 0){  
		d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("中医疾病",obj.DiseaseCode_"[A]"_obj.DiseaseName)
		}*/
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-8-24
/// Description：打开数据
/// Table：CT.WDT.CDSS.TCMDisease
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
	s eobj.ID = id
	s eobj.DiseaseCode = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),2)
	s eobj.DiseaseName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s eobj.DiseaseMedicineName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),4)
    s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),5)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),6)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),8)
	s eobj.DiseaseAlias = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),10)
	s eobj.Version = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),11)

	/*s eobj.TCMDiseDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),12)
	s TCMSymDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",TCMDiseDR,TCMSymDR))
	q:TCMSymDR=""
	s eobj.TCMSymDR= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),3)*/


	s str = eobj.JsonS()
	d eobj.%Close()
	
	s str1=""
	s pobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	s SymRowID=0
	for
	{
		s SymRowID=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",id,SymRowID)) 
		q:SymRowID=""	
	}
	
	s pobj.RowId= id
	s pobj.TCMDiseDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseJSymD(id)),2)
	s pobj.TCMSymDR= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),3)
	s str1 = pobj.JsonS()
	d pobj.%Close()
	s str2=$p(str,"}",1)_","_$p(str1,"{",2)
    b ;
	q str2 //_","_str1
}

ClassMethod OpenData1(id As %String) As %String
{
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
	s eobj.ID = id
	s eobj.DiseaseCode = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),2)
	s eobj.DiseaseName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s eobj.DiseaseMedicineName = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),4)
    s eobj.State = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),5)
	s eobj.Operator = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),6)
	s eobj.OperatTime = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),8)
	s eobj.DiseaseAlias = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),10)
	s eobj.Version = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),11)
	//s eobj.TCMSymDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),12)
	//s TCMSymDR=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(ID)),3) //证型
	//s:TCMSymDR'="" SymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3) //证型
	//s:TCMSymDR="" SymptomName=""


	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-08-30
/// Description:数据删除方法
/// Table：CT.WDT.CDSS.TCMDisease
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDisease).DeleteData("2536")
ClassMethod DeleteData(id As %String)
{
	s result=""
	/*Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}" 
	s re=##class(web.CDSS.CMKB.TCMDisease).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)      //说明：改成前台调用
    if (RefFlag'=0){
	    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"    
	}
	else
	{*/ 
	s obj=##class(CT.WDT.CDSS.TCMDisease).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
	s bobj.ID = id
	s bobj.DiseaseCode = obj.DiseaseCode
	s bobj.DiseaseName = obj.DiseaseName
	s bobj.DiseaseMedicineName = obj.DiseaseMedicineName						
	s bobj.Operator = obj.Operator
	s bobj.OperatTime = obj.OperatTime
	s bobj.State = obj.State		
	s bobj.Remarks=obj.Remarks
	s bobj.DiseaseAlias = obj.DiseaseAlias
	s bobj.Version=obj.Version
	Ts
	//同步删除对照数据 
	s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("中医诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName)
	if (re="true[A]true"){
	s sc=##class(CT.WDT.CDSS.TCMDisease).%DeleteId(id)
	if $$$ISOK(sc)
	{
		//关联证型删除
		s JSymId=""
		for
		{
			s JSymId=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",id,JSymId)) q:JSymId=""
			
			s JSymresult=##class(web.CDSS.CMKB.TCMDiseJSym).DeleteData(JSymId)
			if (JSymresult["false")
			{
				tro
				s result = "{success:'false',info:'中医疾病关联证型同步删除失败！'}"
			}

		}
		//关联识别词删除
		s TCMDJWordID=""
		for{
			s TCMDJWordID=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",id,TCMDJWordID)) 
			q:TCMDJWordID=""
			
			s TCMDJWordresult= ##class(web.CDSS.CMKB.TCMDiseJWords).DeleteData(TCMDJWordID)
			if (TCMDJWordresult["false")
			{
				tro
				s result = "{success:'false',info:'中医疾病关联识别词同步删除失败！'}"
			}
		}
		//关联属性删除
		s TCMDJPropertyID=""
		for{
			s TCMDJPropertyID=$o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",id,TCMDJPropertyID)) 
			q:TCMDJPropertyID=""
			
			s TCMDJWordresult= ##class(web.CDSS.CMKB.TCMDiseJProperty).DeleteData(TCMDJPropertyID)
			if (TCMDJWordresult["false")
			{
				tro
				s result = "{success:'false',info:'中医疾病关联属性同步删除失败！'}"
			}
		}
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典",id,bobj.DiseaseName,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMDisease",id)
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病字典","web.CDSS.CMKB.TCMDisease","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
	//}
	
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-9-7
/// Description:获取引用标志对应的中文
/// Input: QuoteFlag 引用str
/// Return:描述
/// Other:w ##class(web.CDSS.CMKB.TCMDisease).GetQuoteFlag("D,K,R")
ClassMethod GetQuoteFlag(QuoteFlag)
{
	/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
  	s value=""
	if QuoteFlag'=""
	{
		s QuoteFlagDesc=""
		if QuoteFlag["D"	//被决策知识库引用
		{
			s QuoteFlagDesc="决策知识库"
		}
		else	//未被决策知识库引用
		{
			s QuoteFlagDesc=""
		}
		if QuoteFlag["K"	//被医为百科引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="医为百科"
			}
			else		//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"医为百科"
		
			}
		}
		if QuoteFlag["R"	//被规则知识库引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="规则知识库"
			}
			else	//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"规则知识库"
		
			}
		}
		if QuoteFlag["M"	//被数据对照引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="数据对照"
			}
			else		//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"数据对照"
		
			}
		}
		s value=QuoteFlagDesc
		
	}
	q value
}

/// Creator:胡宜良
/// CreatDate:2021-9-7
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.TCMDisease).RemoveQuoteFlag("","R")
ClassMethod RemoveQuoteFlag(OldFlag, RemoveFlag)
{
	q:(OldFlag="") ""
	s result=""
	s Len=$Length(OldFlag,",")
	for i=1:1:Len{	
		s flag=$p(OldFlag,",",i)
  	 	continue:flag=RemoveFlag
  	  	if (result=""){
	  	  	s result=flag
	  	}else{
		  	s result=result_","_flag
	  	}	
	}
	q result
}

/// Creator:胡宜良 
/// CreatDate:2021-9-7
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.TCMDisease).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //字典对照引用接口
    s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s info=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("中医疾病",DiseaseName)
    s myInfo=myInfo_info
    
    //识别词项目引用接口    
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("中医诊断名称",DiseaseName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("中医既往诊断名称",DiseaseName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("中医诊断症状名称",DiseaseName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr	
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT.WDT.CDSS.TCMDisease
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).BatchConfirm()
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
/// Table:CT.WDT.CDSS.TCMDisease
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).BatchCancel()
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
/// Table:CT.WDT.CDSS.TCMDisease
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDisease","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s DiseaseAlias=$LISTGET($G(^CT.WDT.CDSS.TCMDiseaseD(id)),10)
		s Len=$Length(DiseaseAlias,",")
		for i=1:1:Len{
			s Desc=$p(DiseaseAlias,",",i)
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
/// Table：CT.WDT.CDSS.TCMDisease
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMDiseaseD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(RowId)),10)        
		if Alias'=""
		{
			s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDisease",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.TCMDisease
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMDisease).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMDiseaseD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMDiseaseD(RowId)),7)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDisease","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMDisease",RowId,LogID),-1) q:LogID=""
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

/// Creator:胡宜良
/// CreatDate:2023-3-20
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.TCMDisease
/// Input：web.CDSSEntity.CMKB.TCMDisease 实体类
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMDisease).SaveAmendData(eobj)
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMDisease) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		q:eobj.DiseaseName=eobj.DiseaseAlias "{success:'false',errorinfo:'名称和别名不能重复！'}"
		s flag=..FormValidate(eobj.ID,eobj.DiseaseCode,eobj.DiseaseName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DiseaseAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMDisease).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDisease).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDisease).%New()
			s bobj.DiseaseCode = obj.DiseaseCode			
			s bobj.DiseaseName = obj.DiseaseName	             	
			s bobj.Operator = obj.Operator
		    s bobj.OperatTime = obj.OperatTime
			s bobj.DiseaseAlias=obj.DiseaseAlias
		}
		    s obj.DiseaseCode = eobj.DiseaseCode			
		    s obj.DiseaseName = eobj.DiseaseName	             	
		    s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.Operator=eobj.Operator
			s eobj.OperatTime=$ZDATETIME($H,3)						//编辑时间
			s obj.DiseaseAlias=eobj.DiseaseAlias
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			s id = obj.%Id()
			Tc
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典",id,eobj.DiseaseCode_"-"_eobj.DiseaseName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDisease","CT.WDT.CDSS.TCMDisease","中医疾病字典",id,eobj.DiseaseCode_"-"_eobj.DiseaseName_"-"_eobj.Remarks,"U",eobj,bobj)
			
			//同步修改识别词项目数据
			d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中医诊断名称",eobj.DiseaseName,bobj.DiseaseName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.DiseaseAlias'=""))||((eobj.ID'="")&&(eobj.DiseaseAlias'=bobj.DiseaseAlias))
           		{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMDisease",id,eobj.DiseaseAlias)
            	}
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病字典","web.CDSS.CMKB.TCMDisease","SaveEntity",eobj)
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
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病字典","web.CDSS.CMKB.TCMDisease","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
