/// 名称:全文检索配置
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2022-03-22
Class web.CDSS.CMKB.ALLDictSearchSet Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2022-03-22
/// Description：查询 
/// Table：CF.WDT.CDSS.ALLDictSearchSet
/// Input:id,code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ALLDictSearchSet","GetList","","","CT.WDT.CDSS.DiseaseDict","","","","")
Query GetList(rowid As %String, tddesc As %String, tablename As %String, tfname As %String, num As %String, tfdesc As %String, menuurl As %String) As %Query(ROWSPEC = "ID,TableDictDesc,TableName,TableFieldName,TableFieldNum,TableFieldDesc,MenuUrl,Remarks,DataStateNum")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tddesc As %String, tablename As %String, tfname As %String, num As %String, tfdesc As %String, menuurl As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s TableDictDesc= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),2)        //中文表名（与菜单名称保持一致）
		s TableName= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),3)       	 //数据表名称
		s TableFieldName= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),4)       //数据表字段名称
	    s TableFieldNum= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),5) 		 //数据表字段顺序号
	    s TableFieldDesc= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),6)       //数据表字段描述
	    s MenuUrl= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),7)        		 //菜单代码
	    s Remarks= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),8) 	  		 //备注
	    s DataStateNum= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),9)         //数据状态顺序号
	    
	}
	else
	{
		s:tddesc'="" tddesc=$ZCONVERT(tddesc,"U") 			//转换成大写
		s:tablename'="" tablename=$ZCONVERT(tablename,"U")  //转换成大写
	    s:tfname'="" tfname=$ZCONVERT(tfname,"U") 			//转换成大写
		s:num'="" num=$ZCONVERT(num,"U") 					//转换成大写
		s:tfdesc'="" tfdesc=$ZCONVERT(tfdesc,"U") 			//转换成大写
		s:menuurl'="" menuurl=$ZCONVERT(menuurl,"U") 		//转换成大写

		s ID=0
		for
		{
			s ID=$o(^CF.WDT.CDSS.ALLDictSearchSetD(ID))
			q:ID=""
			s TableDictDesc= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),2)       //中文表名（与菜单名称保持一致）
			continue:((tddesc'="")&&(TableDictDesc'[tddesc))
		    s TableName= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),3)       	//数据表名称
		    continue:((tablename'="")&&($ZCONVERT(TableName,"U")'[tablename))
		    s TableFieldName= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),4)      //数据表字段名称
		    continue:((tfname'="")&&($ZCONVERT(TableFieldName,"U")'[tfname))
	   	 	s TableFieldNum= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),5)       //数据表字段顺序号
			s TableFieldDesc= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),6) 	    //数据表字段描述
	     	continue:((tfdesc'="")&&(TableFieldDesc'[tfdesc))
	    	s MenuUrl= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),7)     	    //菜单代码
	    	s Remarks= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),8)        		//备注
			s DataStateNum= $lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ID)),9)		//数据状态顺序号														//数据状态顺序号
		    if ($ZCONVERT(TableName,"U")[tablename)&($ZCONVERT(TableDictDesc,"U")[tddesc)&($ZCONVERT(TableFieldName,"U")[tfname)&($ZCONVERT(TableFieldDesc,"U")[tfdesc)&($ZCONVERT(TableFieldNum,"U")[num)&($ZCONVERT(MenuUrl,"U")[menuurl)
		    {
			    d OutputRow
			}
	
		}
						
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
    set Data=$lb(ID,TableDictDesc,TableName,TableFieldName,TableFieldNum,TableFieldDesc,MenuUrl,Remarks,DataStateNum)
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

/// Creator:胡宜良
/// CreatDate:2022-03-23
/// Description：数据重复验证方法，由js调用
/// Table：CF.WDT.CDSS.ALLDictSearchSet
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ALLDictSearchSet).FormValidate("","")
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	
	
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""

	s:desc'="" flagd=$d(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",desc,0))
		
		if (((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:胡宜良
/// CreatDate:2022-03-23
/// Description：保存全文检索配置表的内容
/// Table：CF.WDT.CDSS.ALLDictSearchSet
/// Input：web.CDSSEntity.CMKB.ALLDictSearchSet 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.ALLDictSearchSet).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.ALLDictSearchSet) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.TableDictDesc)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CF.WDT.CDSS.ALLDictSearchSet).%New()
		}
		else	//修改
		{
			s obj=##class(CF.WDT.CDSS.ALLDictSearchSet).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.ALLDictSearchSet).%New()
			s bobj.ID = eobj.ID
			s bobj.TableDictDesc = obj.TableDictDesc			
			s bobj.TableName = obj.TableName	             	
			s bobj.TableFieldName = obj.TableFieldName						
			s bobj.TableFieldNum = obj.TableFieldNum
		    s bobj.TableFieldDesc = obj.TableFieldDesc
			s bobj.MenuUrl = obj.MenuUrl		
			s bobj.Remarks=obj.Remarks
			s bobj.DataStateNum=obj.DataStateNum 	
		}
		
		    s obj.TableDictDesc = eobj.TableDictDesc			
		    s obj.TableName = eobj.TableName	             	
		    s obj.TableFieldName = eobj.TableFieldName					
		    s obj.TableFieldNum =eobj.TableFieldNum
		    s obj.TableFieldDesc = eobj.TableFieldDesc	
		    s obj.MenuUrl = eobj.MenuUrl			
		    s obj.Remarks=eobj.Remarks
		    s obj.DataStateNum=eobj.DataStateNum
		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			Tc
			
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.ALLDictSearchSet","CF.WDT.CDSS.ALLDictSearchSet","全文检索配置表",id,eobj.TableDictDesc_"-"_eobj.TableName_"-"_eobj.Remarks,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.ALLDictSearchSet","CF.WDT.CDSS.ALLDictSearchSet","全文检索配置表",id,eobj.TableDictDesc_"-"_eobj.TableName_"-"_eobj.Remarks,"U",eobj,bobj)

		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("全文检索配置表","CF.WDT.CDSS.ALLDictSearchSet","SaveEntity",eobj)
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
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("全文检索配置表","web.CDSS.CMKB.ALLDictSearchSet","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2022-03-23
/// Description：打开数据
/// Table:CF.WDT.CDSS.ALLDictSearchSet
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.ALLDictSearchSet).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.ALLDictSearchSet).%New()
	s eobj.ID = id
	s eobj.TableDictDesc = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),2)
	s eobj.TableName = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),3)
	s eobj.TableFieldName = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),4)
	s eobj.TableFieldNum = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),5)
	s eobj.TableFieldDesc = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),6)
	s eobj.MenuUrl = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),8)
	s eobj.DataStateNum = $LISTGET($G(^CF.WDT.CDSS.ALLDictSearchSetD(id)),9)
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2022-03-23
/// Description:数据删除方法
/// Table:CF.WDT.CDSS.ALLDictSearchSet
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.ALLDictSearchSet).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"
	 
	s obj=##class(CF.WDT.CDSS.ALLDictSearchSet).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.ALLDictSearchSet).%New()
	s bobj.ID = id
	s bobj.TableDictDesc = obj.TableDictDesc
	s bobj.TableName = obj.TableName
	s bobj.TableFieldName = obj.TableFieldName						
	s bobj.TableFieldNum = obj.TableFieldNum
	s bobj.TableFieldDesc = obj.TableFieldDesc
	s bobj.MenuUrl = obj.MenuUrl		
	s bobj.Remarks=obj.Remarks
	s bobj.DataStateNum = obj.DataStateNum
	Ts
	s sc=##class(CF.WDT.CDSS.ALLDictSearchSet).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.ALLDictSearchSet","CF.WDT.CDSS.ALLDictSearchSet","全文检索配置表",id,bobj.TableDictDesc,"D",bobj)
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("全文检索配置表","web.CDSSEntity.CMKB.ALLDictSearchSet","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-03-23
/// Description：导入全文检索
/// Table:CF.WDT.CDSS.ALLDictSearchSet
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.ALLDictSearchSet).ImportDataTXT("D:\ALLDictSearchSet.txt")
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
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s TableDictDesc= $p(data,$c(9),1)       //中文表名
		s TableName= $p(data,$c(9),2)       	//数据表名称
		s TableFieldName= $p(data,$c(9),3)      //数据表字段名称
		s TableFieldNum= $p(data,$c(9),4)       //数据表字段顺序号
		s TableFieldDesc= $p(data,$c(9),5)      //数据表字段描述
		s MenuUrl= $p(data,$c(9),6)				//菜单代码
		s DataStateNum = $p(data,$c(9),7)		//数据状态顺序号


		
		s eobj = ##class(web.CDSSEntity.CMKB.ALLDictSearchSet).%New()
		s eobj.TableDictDesc = TableDictDesc
		s eobj.TableName = TableName
		s eobj.TableFieldName = TableFieldName						
		s eobj.TableFieldNum = TableFieldNum
		s eobj.TableFieldDesc = TableFieldDesc
		s eobj.MenuUrl = MenuUrl		
		s eobj.Remarks=""
		s eobj.DataStateNum = DataStateNum					
		
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

}
