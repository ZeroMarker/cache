/// 名称:方位字典
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-11-16
Class web.CDSS.CMKB.PositionWord Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-11-16
/// Description：查询 
/// Table：CT_WDT_CDSS.PositionWord
/// Input:id,code,desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PositionWord","GetList","","","","b","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, alias As %String, type As %String, useflag As %String, user As %String, starttime As %String, endtime As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,PositionCode,PositionDesc,PositionType,UseFlag,UpdateUser,UpdateDate,Remarks,PositionAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, alias As %String, type As %String, useflag As %String, user As %String, starttime As %String, endtime As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s ID=rowid
		s PositionCode= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),2)       //方位词代码
		s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)       //方位词描述
		s PositionType= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),4)       //分类
	    //s PositionType=$case(PositionType,d:"单纯方位词",t:"特殊方位词",h:"合成方位词",:"")
	    s UseFlag= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),5)        //状态（0编辑中，1已弃用，2已审核）
	    s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),6) 	//操作人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),7)     //操作时间
	    
	    s Remarks= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),8)        //备注
	    s PositionAlias= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),9)
	    d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s:user'="" user=$ZCONVERT(user,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		s ID=0
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle") 
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.PositionWordD(ID))
				q:ID=""
				s CommonDictName= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)		//名称
				s length=$l(CommonDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.PositionWordD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),7)				//编辑时间
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
	       	
			
				s PositionCode= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),2)       //方位词代码
				continue:((code'="")&&(PositionCode'[code))
		    	s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)       //方位词描述
		    	s PositionType= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),4)       //分类
		    	continue:((type'="")&&(PositionType'=type))
	   	 		s UseFlag= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),5)        //状态（0编辑中，1已弃用，2已审核）
	    		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    		continue:((useflag="")&&(UseFlag="已弃用"))
	    		s UpdateUser= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),6) 	   //编辑人员
	    		s UpdateDate= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),7)     //编辑时间
	    		s Remarks= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),8)        //备注
	    		s PositionAlias= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),9)        //别名
	    		continue:((alias'="")&&($ZCONVERT(PositionAlias,"U")'[alias))

		    	if ($ZCONVERT(UpdateUser,"U")[user)&($ZCONVERT(PositionDesc,"U")[desc)&($ZCONVERT(UseFlag,"U")[useflag)
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
    
    set Data=$lb(ID,PositionCode,PositionDesc,PositionType,UseFlag,UpdateUser,UpdateDate,Remarks,PositionAlias)
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
/// CreatDate: 2021-11-17
/// Description：查询 方位词 
/// Table:CT_WDT_CDSS.PositionWord
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PositionWord","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ID,PositionCode,PositionDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	
	s RowId=rowid
	s PositionCode= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),2)       //方位词代码
	s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)       //方位词描述
  	d OutputRowCmb
 }
 else
 {
	
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.PositionWordD(ID))
		q:ID=""
		s PositionDesc=$lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)		//方位词描述
		s length=$l(PositionDesc)
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
			
  			s PositionCode= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),2)       //方位词代码
		    s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)       //方位词描述
  			s UseFlag= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),5) 
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PositionDesc)  
  			if (($ZCONVERT(PositionDesc,"U")[desc)||(PINYIN[desc))&(UseFlag=2) 
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
    set Data=$lb(ID,PositionCode,PositionDesc)
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
/// CreatDate:2021-11-17
/// Description：导入方位词字典
/// Table:CT_WDT_CDSS.PositionWord
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.PositionWord).ImportDataTXT("D:\Works\PositionWord.txt")
ClassMethod ImportDataTXT(path) As %String
{
	
	s savecount=0
	s nosavecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s num=0
	k myFileAry
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s PositionCode= $p(data,$c(9),1)       //方位词代码
		s PositionDesc= $p(data,$c(9),2)       //方位词描述
		s PositionType= $p(data,$c(9),3)       //分类


		
		s eobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
		s eobj.PositionCode = PositionCode		
		s eobj.PositionDesc = PositionDesc	             	
		s eobj.PositionType = PositionType					
		
		s eobj.UpdateUser = "dhcc"
		s eobj.UpdateDate = $ZDATETIME($HOROLOG,3)	
		s eobj.UseFlag = 0	
		s eobj.Remarks = ""					
		
		s result=..SaveEntity(eobj)
		if ((result'["false"))
		{
			b ;1
			s savecount=savecount+1		
		}
		else
		{
			b ;2
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
/// CreatDate:2021-11-17
/// Description:导出方位词字典数据
/// Table:CT_WDT_CDSS.PositionWord
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.PositionWord).ExportDataTXT()
ClassMethod ExportDataTXT(desc As %String, alias As %String, useflag As %String, user As %String, type As %String, starttime As %String, endtime As %String) As %String
{
	
	//s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"方位词字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"方位词字典数据.txt"		
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
	w "方位词代码	方位词描述	别名	分类	编辑人员	编辑时间	备注	状态"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
	s:useflag'="" useflag=$ZCONVERT(useflag,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s UpdateTime=""
	for{
		s UpdateTime=$o(^CT.WDT.CDSS.PositionWordI("UpdateDateIndex",UpdateTime),-1)
		q:UpdateTime=""	
		s ID=""
		for 
	    {
			s ID=$o(^CT.WDT.CDSS.PositionWordI("UpdateDateIndex",UpdateTime,ID))
			q:ID=""
			s PositionCode= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),2)       //方位词代码
			s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),3)       //方位词描述
			continue:(($ZCONVERT(PositionDesc,"U")'[desc)&&(desc'=""))
			s PositionType= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),4)
			continue:(($ZCONVERT(PositionType,"U")'[type)&&(type'=""))
	   		s UseFlag= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),5)        //状态（0编辑中，1已弃用，2已审核）
	    	s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"") 
	    	continue:((($ZCONVERT(UseFlag,"U")'[useflag)&&(useflag'=""))||((useflag="")&&(UseFlag="已弃用")))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),6) 	   //编辑人员
	    	continue:(($ZCONVERT(UpdateUser,"U")'[user)&&(user'=""))
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),7)     //编辑时间
			continue:((starttime'="")&&(endtime'=""))&&(($ZDH(UpdateDate,3)>$zdh(endtime,3))||($ZDH(UpdateDate,3)<$zdh(starttime,3)))
			continue:((starttime="")&&(endtime'=""))&&($ZDH(UpdateDate,3)'=$zdh(endtime,3))
			continue:((endtime="")&&(starttime'=""))&&($ZDH(UpdateDate,3)'=$zdh(starttime,3))	
	    	s Remarks= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),8)        //备注
        	s PositionAlias= $lg($g(^CT.WDT.CDSS.PositionWordD(ID)),9)
			continue:(($ZCONVERT(PositionAlias,"U")'[alias)&&(alias'=""))
	 		//替换双引号
			s PositionCode=$replace(PositionCode,"""","”")
			s PositionDesc=$replace(PositionDesc,"""","”")
			s PositionType=$replace(PositionType,"""","”")
			s UpdateUser=$replace(UpdateUser,"""","”")
			s UpdateDate=$replace(UpdateDate,"""","”")
			s Remarks=$replace(Remarks,"""","”")
			s UseFlag=$replace(UseFlag,"""","”")
			s PositionAlias=$replace(PositionAlias,"""","”")
			
			w !,PositionCode_"	"_PositionDesc_"	"_PositionAlias_"	"_PositionType_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
	    }
	}
	c file
	q fileName
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：数据重复验证方法，由js调用
/// Table:CT_WDT_CDSS.PositionWord
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.PositionWord).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.PositionWordI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.PositionWordI("DescIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.PositionWordI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.PositionWordI("DescIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.PositionWord).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.PositionWord",Alias))
	    s flagN=$d(^CT.WDT.CDSS.PositionWordI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.PositionWord",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.PositionWordI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate:2021-11-17
/// Description：保存方位词字典的内容
/// Table:CT_WDT_CDSS.PositionWord
/// Input：web.CDSSEntity.CMKB.PositionWord 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.PositionWord).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.PositionWord) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		
		s:eobj.PositionCode="" eobj.PositionCode=..getFactorCode()
		s flag=..FormValidate(eobj.ID,eobj.PositionCode,eobj.PositionDesc)  //调用重复验证
		
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.PositionDesc,eobj.PositionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.PositionWord).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.PositionWord).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
			s bobj.ID = eobj.ID
			s bobj.PositionCode = obj.PositionCode			
			s bobj.PositionDesc = obj.PositionDesc	             	
			s bobj.PositionType = obj.PositionType						
			s bobj.UpdateUser = obj.UpdateUser
		    s bobj.UpdateDate = obj.UpdateDate
			s bobj.UseFlag = obj.UseFlag		
			s bobj.Remarks=obj.Remarks
			s bobj.PositionAlias=obj.PositionAlias 	
		}
		
		    s obj.PositionCode = eobj.PositionCode			
		    s obj.PositionDesc = eobj.PositionDesc	             	
		    s obj.PositionType = eobj.PositionType					
		    s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate	
		    s obj.UseFlag = eobj.UseFlag			
		    s obj.Remarks=eobj.Remarks
		    s obj.PositionAlias=eobj.PositionAlias
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			Tc
			
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典",id,eobj.PositionCode_"-"_eobj.PositionDesc_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典",id,eobj.PositionCode_"-"_eobj.PositionDesc_"-"_eobj.Remarks,"U",eobj,bobj)
			//同步修改识别词项目数据
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("方位",eobj.PositionDesc,bobj.PositionDesc)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            	if ((eobj.ID="")&&(eobj.PositionAlias'=""))||((eobj.ID'="")&&(eobj.PositionAlias'=bobj.PositionAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PositionWord",id,eobj.PositionAlias)
            	}
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("方位词字典","CT.WDT.CDSS.PositionWord","SaveEntity",eobj)
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
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("方位词字典","web.CDSS.CMKB.PositionWord","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：得到新增数据的code
/// Table:CT_WDT_CDSS.PositionWord
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.PositionWord).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.PositionWordD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.PositionWordD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：修改时打开的数据
/// Table:CT_WDT_CDSS.PositionWord
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.PositionWord).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
	s eobj.ID = id
	s eobj.PositionCode = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),2)
	s eobj.PositionDesc = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),3)
	s eobj.PositionType = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),4)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),5)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),6)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),8)
	s eobj.PositionAlias = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),9)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：更改状态,审批驳回数据
/// Table:CT_WDT_CDSS.PositionWord
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.PositionWord).UpdateState("5","2")
ClassMethod UpdateState(id As %String, Operation As %String) As %String
{
	s result=""
	s obj=##class(CT.WDT.CDSS.PositionWord).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.PositionWord).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New() 
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典表",id,obj.PositionDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：打开数据
/// Table:CT_WDT_CDSS.PositionWord
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.PositionWord).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
	s eobj.ID = id
	s eobj.PositionCode = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),2)
	s eobj.PositionDesc = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),3)
	s eobj.PositionType = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),4)
    s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),5)
	s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),6)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),8)
	s eobj.PositionAlias = $LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),9)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description:数据删除方法
/// Table:CT_WDT_CDSS.PositionWord
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.PositionWord).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"
	s re=##class(web.CDSS.CMKB.PositionWord).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)      //说明：改成前台调用
    if (RefFlag'=0){
	    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"    
	}
	else
	{  
	s obj=##class(CT.WDT.CDSS.PositionWord).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
	s bobj.ID = id
	s bobj.PositionCode = obj.PositionCode
	s bobj.PositionDesc = obj.PositionDesc
	s bobj.PositionType = obj.PositionType						
	s bobj.UpdateUser = obj.UpdateUser
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.UseFlag = obj.UseFlag		
	s bobj.Remarks=obj.Remarks
	s bobj.PositionAlias = obj.PositionAlias
	Ts
	s sc=##class(CT.WDT.CDSS.PositionWord).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典",id,bobj.PositionDesc,"D",bobj)
		//删除别名通用表中数据 2021-11-05 GXP
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.PositionWord",id)

		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("方位词字典","web.CDSSEntity.CMKB.PositionWord","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table:CT_WDT_CDSS.PositionWord
/// CreatDate:2021-11-17
/// Other: w ##class(web.CDSS.CMKB.PositionWord).BatchConfirm()
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
/// Table:CT_WDT_CDSS.PositionWord
/// CreatDate:2021-11-17
/// Other: w ##class(web.CDSS.CMKB.PositionWord).BatchCancel()
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
/// Table:CT_WDT_CDSS.PositionWord
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PositionWord","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s PositionAlias=$LISTGET($G(^CT.WDT.CDSS.PositionWordD(id)),9)
		s Len=$Length(PositionAlias,",")
		for i=1:1:Len{
			s Desc=$p(PositionAlias,",",i)
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
/// Table：CT.WDT.CDSS.PositionWord
/// Other: w ##class(web.CDSS.CMKB.PositionWord).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.PositionWordD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.PositionWordD(RowId)),9)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PositionWord",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.PositionWord
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.PositionWord).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.PositionWordD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.PositionWordD(RowId)),5)       
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
/// w ##class(web.CDSS.CMKB.PositionWord).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    //识别词项目引用接口
    s PositionDesc= $lg($g(^CT.WDT.CDSS.PositionWordD(id)),3) 	 
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("方位",PositionDesc)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr	
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PositionWord","GetLogList","524")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.PositionWord",RowId,LogID),-1) q:LogID=""
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
/// Table： CT.WDT.CDSS.PositionWord
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.PositionWord).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.PositionWord) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
	
		s:eobj.PositionCode="" eobj.PositionCode=..getFactorCode()
		s flag=..FormValidate(eobj.ID,eobj.PositionCode,eobj.PositionDesc)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.PositionDesc,eobj.PositionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.PositionWord).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.PositionWord).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.PositionWord).%New()
			s bobj.PositionDesc=obj.PositionDesc          //修改描述
            s bobj.UpdateUser=obj.UpdateUser
            s bobj.UpdateDate=obj.UpdateDate
            s bobj.PositionAlias=obj.PositionAlias
			
		}
		
		s obj.PositionDesc = eobj.PositionDesc          //修改描述
        s eobj.UpdateUser =$g(%session.Data("LOGON.USERNAME"))
        s obj.UpdateUser =eobj.UpdateUser
        s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
        s obj.UpdateDate= eobj.UpdateDate
        s obj.PositionAlias=eobj.PositionAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典",id,eobj.PositionCode_"-"_eobj.PositionDesc_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PositionWord","CT.WDT.CDSS.PositionWord","方位词字典",id,eobj.PositionCode_"-"_eobj.PositionDesc_"-"_eobj.Remarks,"U",eobj,bobj)
			//同步修改识别词项目数据
            d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("方位",eobj.PositionDesc,bobj.PositionDesc)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.ID="")&&(eobj.PositionAlias'=""))||((eobj.ID'="")&&(eobj.PositionAlias'=bobj.PositionAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PositionWord",id,eobj.PositionAlias)
            }
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("方位词字典","CT.WDT.CDSS.PositionWord","SaveEntity",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("方位词字典","web.CDSS.CMKB.PositionWord","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
