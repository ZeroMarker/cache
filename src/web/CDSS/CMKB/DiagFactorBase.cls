/// Description: 诊断因子库(增删改查) 
/// Creator: 阚延新
/// Date: 2020-1-11
Class web.CDSS.CMKB.DiagFactorBase Extends %RegisteredObject
{

/// Creator:阚延新
/// CreatDate:2021-1-11
/// Description:获得诊断因子字典表内容
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input: desc
/// Return:返回符合条件的疾病关联治疗方案表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiagFactorBase","GetList","","","","2","","","CreateDate")
Query GetList(rowid As %String, desc As %String, ClassCode As %String, state As %String, user As %String, timescope As %String, sortmethod As %String) As %Query(ROWSPEC = "ID,DiagFactorCode,DiagFactorDesc,DiagFactorClass,UseFlag,CreateDate,CreateUserID,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, ClassCode As %String, state As %String, user As %String, timescope As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s ID=rowid
	s DiagFactorCode = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),2)
	s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)
	s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),4)
	s UseFlag = $lg($G(^CT.WDT.CDSS.DiagFactorBaseD(ID)),5)
	s CreateDate=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)
 	s CreateUserID=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),7)
 	s Remarks=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),8)

	d OutputRow
 }
 else
 {
	
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
 	
 	s ID=0
	
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")

	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DiagFactorBaseD(ID))
			q:ID=""
			s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)		//名称
			s length=$l(DiagFactorDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
				
		}
	}
	else
	{
		s ID=""
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DiagFactorBaseD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)				//编辑时间
			s:UpdateDate="" UpdateDate="2022-01-01"
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
	 		s DiagFactorCode = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),2)
	 		s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)
	 		s PINYINName=""
			s:desc'="" PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorDesc) 
	 		s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),4)
	 		s UseFlag= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),5)        //使用标志（0编辑中，1已弃用，2已审核）
	 		s:UseFlag="" UseFlag=0
			if (state=""){
					continue:(UseFlag="1")			
				}
				else{
					continue:(UseFlag'=state)
				}
		    //s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
		    //continue:((state="")&&(UseFlag="编辑中"))
		    s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s CreateDate=$LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
	        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))	
	 		s CreateUserID=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),7)
	 		s Remarks=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),8)
 	
			if (($ZCONVERT(DiagFactorClass,"U")[ClassCode))&(($ZCONVERT(DiagFactorDesc,"U")[desc)||(PINYINName[desc))&($ZCONVERT(CreateUserID,"U")[user)&($ZCONVERT(UseFlag,"U")[state) 
			{	
				d OutputRow
				
		  	}
		}
	}
 }
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,DiagFactorCode,DiagFactorDesc,DiagFactorClass,UseFlag,CreateDate,CreateUserID,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:阚延新
/// CreatDate:2021-1-20
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.DiagFactorBase 诊断因子表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.DiagFactorBase).FormValidate("","1")
ClassMethod FormValidate(id As %String, name As %String) As %String
{
	s flag=""
	s name = $ZCONVERT(name,"U")
	s:(name'="") flag=$d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_name))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flag>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:(name'="") idc=$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_name,0)) 
		if (name="")
		{
			if (idc'=id)&(flag>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'="")&(idc'=id)&(flag>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:zww
/// CreatDate:2021-12-30
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.DiagFactorBase 诊断因子表
/// Input:name 
/// Return:"1"(名称不正确),"0"(名称正确)
/// Other:w ##class(web.CDSS.CMKB.DiagFactorBase).NameValidate("绝非如此")
ClassMethod NameValidate(name As %String) As %String
{
	s mflag=""
	//s name = $ZCONVERT(name,"U")
	s:(name'="") mflag=$d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(name,"U")))
		if (mflag>0)
		{
			s mflag=1  //返回不正确标志
		}
		else
		{
			s mflag=0 //返回正确标志
		}

	q mflag
}

/// Creator:阚延新
/// CreatDate:2021-1-11
/// Description:保存诊断因子表
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input: eobj 诊断因子表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiagFactorBase).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiagFactorBase)
{
	s $zt="ERROR"
	s result=""
	s WordsDesc=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ID,eobj.DiagFactorName)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在'}"
		}
		if ('$d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(eobj.DiagFactorName,"U"))))
		{
			q "{success:'false',errorinfo:'该诊断因子名称不存在!'}"
		}
		/*s mflag=..NameValidate(eobj.DiagFactorName)  //调用验证
		if (mflag=1)
		{
			q "{success:'false',errorinfo:'该诊断因子名称不存在!'}"
		}
		*/
		if (eobj.ID="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiagFactorBase).%New()
			s obj.DiagFactorCode=..getFactorCode()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(eobj.ID)
		    s bobj = ##class(web.CDSSEntity.CMKB.DiagFactorBase).%New() 
			s bobj.DiagFactorName = obj.DiagFactorName  
			s bobj.DiagFactorClass = obj.DiagFactorClass  
			s bobj.UseFlag = obj.UseFlag 
			s bobj.Remarks = obj.Remarks
			s bobj.CreateDate = $ZDATETIME($HOROLOG,3)
			s bobj.CreateUserID = $g(%session.Data("LOGON.USERNAME"))
		}
		s obj.DiagFactorName = eobj.DiagFactorName
		s obj.DiagFactorClass = eobj.DiagFactorClass
		s obj.UseFlag = eobj.UseFlag
		s obj.Remarks = eobj.Remarks
		s obj.CreateDate = $ZDATETIME($HOROLOG,3)
		s obj.CreateUserID = $g(%session.Data("LOGON.USERNAME"))
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiagFactorBase","CT.WDT.CDSS.DiagFactorBase","诊断因子字典",id,eobj.DiagFactorName,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiagFactorBase","CT.WDT.CDSS.DiagFactorBase","诊断因子字典",eobj.ID,eobj.DiagFactorName,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断因子字典","web.CDSS.CMKB.DiagFactorBase","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断因子字典","web.CDSS.CMKB.DiagFactorBase","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:阚延新
/// CreatDate:2021-1-11
/// Description:删除诊断因子字典表
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input: id 诊断因子表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiagFactorBase).DeleteData("1554")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s DiseaseName=""
	s idc=""
	s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(id)
	s idc=$o(^CT.WDT.CDSS.DiseJFactorI("FactorIndex",id,0))
	
	if (idc'=""){
		s idr = $o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",idc,0))  //取疾病关联诊断因子表中的DiseaseDR
		s:idr'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(idr)),3) //取疾病表名称
		if (DiseaseName'="") {
			s result = "{success:'false',info:'该诊断因子已经被疑似诊断管理中的诊断["_DiseaseName_"]引用'}"
			 
		}
		 s result = "{success:'false',info:'该诊断因子已经被疑似诊断管理中的多个诊断引用'}"
	}
	else{
		s bobj = ##class(web.CDSSEntity.CMKB.DiagFactorBase).%New() 
		s bobj.DiagFactorName = obj.DiagFactorName  
		s bobj.DiagFactorClass = obj.DiagFactorClass  
		s bobj.UseFlag = obj.UseFlag 
		s bobj.Remarks = obj.Remarks
		s bobj.CreateDate = obj.CreateDate 
		s bobj.CreateUserID = obj.CreateUserID
		Ts
		s sc=##class(CT.WDT.CDSS.DiagFactorBase).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiagFactorDict","CT.WDT.CDSS.DiagFactorDict","诊断因子字典",id,bobj.DiagFactorName,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断因子字典","web.CDSS.CMKB.DiagFactorDict","DeleteData",bobj)
   			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}	
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-11
/// Description:通过id获取诊断因子字典表内容
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input: id 诊断因子字典表id
/// Return: 诊断因子字典表内容
/// others:w ##class(web.CDSS.CMKB.DiagFactorBase).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiagFactorBase).%New()
	s eobj.ID = id
	s eobj.DiagFactorName = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),3)
	s eobj.DiagFactorClass = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),4)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),5)
	s eobj.CreateDate = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),6)
	s eobj.CreateUserID = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),7)
	s eobj.Remarks = $LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),8)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:阚延新
/// CreatDate:2021-1-11
/// Description：导入诊断因子信息
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.DiagFactorBase).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	
	s result ="" 
	s file=##class(%File).%New("D:\东华培训\诊断因子字典.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s eobj = ##class(web.CDSSEntity.CMKB.DiagFactorBase).%New()
		s eobj.DiagFactorClass=$p(Line,",",4)
		s eobj.DiagFactorCode=$p(Line,",",5)
		s eobj.DiagFactorName=$p(Line,",",6)
		s eobj.Remarks=$p(Line,",",7)
		s Validatedesc = $ZCONVERT(eobj.DiagFactorName,"U")
	    if $d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_Validatedesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_Validatedesc,""))
		   s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.DiagFactorBase).%New()
		}
		s obj.DiagFactorName = eobj.DiagFactorName
		if (eobj.DiagFactorClass="0"){
			s obj.DiagFactorClass ="症状"
		}
		if (eobj.DiagFactorClass="1"){
			s obj.DiagFactorClass ="查体"
		}
		if (eobj.DiagFactorClass="2"){
			s obj.DiagFactorClass ="检验结果标准"
		}
		if (eobj.DiagFactorClass="3"){
			s obj.DiagFactorClass ="检查结果描述"
		}
		s obj.UseFlag = 0
		s obj.Remarks = eobj.Remarks
		s obj.DiagFactorCode=eobj.DiagFactorCode	
		s obj.CreateDate = $ZDATETIME($HOROLOG,3)
		s obj.CreateUserID = "dhcc"
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
		
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-12
/// Description:导出诊断因子库数据   【弃用】
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.DiagFactorBase).ExportData("","","","","","")
ClassMethod ExportData(desc As %String, ClassCode As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="诊断因子库数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\CMKB\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("诊断因子,编号,诊断因子分类,状态,创建时间,创建人员,备注")
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
 	
 	s ID=0
	k ^TempDataHandle
	for 
	{
		s ID=$o(^CT.WDT.CDSS.DiagFactorBaseD(ID))
		q:ID=""
		s UpdateDate= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)				//编辑时间
		s ^TempDataHandle("Short",UpdateDate,ID)=ID
	}
 	s num=0
	s UpdateTime=$o(^TempDataHandle("short",""),-1)
	for
	{
		s UpdateTime=$o(^TempDataHandle("Short",UpdateTime),-1)
		q:UpdateTime=""
		s UnitID=0
		for
		{
			s UnitID=$o(^CT.WDT.CDSS.DiagFactorBaseI("UpdateDateIndex",UpdateTime,UnitID))
			q:UnitID=""
			s num=num+1
			s ^TempDataHandle("Handle",num)=UnitID
	    }
	}
				
 	
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle("Handle",Number))
		q:Number=""
		s ID=^TempDataHandle("Handle",Number)
 		s DiagFactorCode = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),2)
 		s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)
 		s PINYINName=""
		s:desc'="" PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorDesc) 
		continue:((($ZCONVERT(DiagFactorDesc,"U")'[desc)&&(desc'=""))||((PINYINName'[desc)&&(desc'="")))
 		s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),4)
 		continue:(($ZCONVERT(DiagFactorClass,"U")'[ClassCode)||(ClassCode'=""))
 		s UseFlag= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),5)        //使用标志（0已审核，1编辑中，2已弃用）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已弃用")))
 		s CreateDate=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)
 		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(CreateDate,3)>$zdh(EndTime,3))||($ZDH(CreateDate,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(CreateDate,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(CreateDate,3)'=$zdh(StartTime,3))
 		s CreateUserID=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),7)
 		continue:(($ZCONVERT(CreateUserID,"U")'[user)&&(user'=""))
 		s Remarks=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),8)
 		
		
		//替换双引号
		s DiagFactorCode=$replace(DiagFactorCode,"""","”")
		s DiagFactorDesc=$replace(DiagFactorDesc,"""","”")
		s DiagFactorClass=$replace(DiagFactorClass,"""","”")
		s DiagFactorClass=$replace(DiagFactorClass,"""","”")
		s UseFlag=$replace(UseFlag,"""","”")
		s CreateUserID=$replace(CreateUserID,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s str=DiagFactorCode_","_DiagFactorDesc_","_DiagFactorClass_","_UseFlag_","_CreateDate_","_CreateUserID_","_Remarks
		d file.WriteLine(str)
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:阚延新
/// CreatDate:2021-07-26
/// Description:导出诊断因子库数据【暂不用】
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.DiagFactorBase).ExportTXTData("","","","","","")
ClassMethod ExportTXTData(desc As %String, ClassCode As %String, state As %String, user As %String, StartTime As %String, EndTime As %String) As %String
{
	s sum=0
	
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="诊断因子库数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	o file:"NWS"
	u file
	w "诊断因子	编号	诊断因子分类	状态	创建时间	创建人员	备注"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	s:user'="" user=$ZCONVERT(user,"U") //转换成大写
 	
 	s ID=0
	k ^TempDataHandle
	for 
	{
		s ID=$o(^CT.WDT.CDSS.DiagFactorBaseD(ID))
		q:ID=""
		s UpdateDate= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)				//编辑时间
		s ^TempDataHandle("Short",UpdateDate,ID)=ID
	}
 	s num=0
	s UpdateTime=$o(^TempDataHandle("short",""),-1)
	for
	{
		s UpdateTime=$o(^TempDataHandle("Short",UpdateTime),-1)
		q:UpdateTime=""
		s UnitID=0
		for
		{
			s UnitID=$o(^CT.WDT.CDSS.DiagFactorBaseI("UpdateDateIndex",UpdateTime,UnitID))
			q:UnitID=""
			s num=num+1
			s ^TempDataHandle("Handle",num)=UnitID
	    }
	}
				
 	
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle("Handle",Number))
		q:Number=""
		s ID=^TempDataHandle("Handle",Number)
 		s DiagFactorCode = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),2)
 		s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)
 		s PINYINName=""
		s:desc'="" PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorDesc) 
		continue:((($ZCONVERT(DiagFactorDesc,"U")'[desc)&&(desc'=""))||((PINYINName'[desc)&&(desc'="")))
 		s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),4)
 		continue:(($ZCONVERT(DiagFactorClass,"U")'[ClassCode)||(ClassCode'=""))
 		s UseFlag= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),5)        //使用标志（0已审核，1编辑中，2已弃用）
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"") 
	    continue:((($ZCONVERT(UseFlag,"U")'[state)&&(state'=""))||((state="")&&(UseFlag="已弃用")))
 		s CreateDate=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)
 		continue:((StartTime'="")&&(EndTime'=""))&&(($ZDH(CreateDate,3)>$zdh(EndTime,3))||($ZDH(CreateDate,3)<$zdh(StartTime,3)))
		continue:((StartTime="")&&(EndTime'=""))&&($ZDH(CreateDate,3)'=$zdh(EndTime,3))
		continue:((EndTime="")&&(StartTime'=""))&&($ZDH(CreateDate,3)'=$zdh(StartTime,3))
 		s CreateUserID=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),7)
 		continue:(($ZCONVERT(CreateUserID,"U")'[user)&&(user'=""))
 		s Remarks=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),8)
		w !,DiagFactorCode_"	"_DiagFactorDesc_"	"_DiagFactorClass_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks
	}
	
	c file
	q fileName
}

/// Creator:赵文伟
/// CreatDate:2021-11-04
/// Description:导出诊断因子库数据【在用】
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.DiagFactorBase).ExportDiagFactorBaseTXTData()
ClassMethod ExportDiagFactorBaseTXTData() As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"诊断因子库数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"诊断因子库数据.txt"		
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
	w "诊断因子	编号	诊断因子分类	状态	创建时间	创建人员	备注"
	
 	s ID=""
	for 
	{
		s ID=$o(^CT.WDT.CDSS.DiagFactorBaseD(ID),-1) q:ID=""
 		s DiagFactorCode = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),2)
 		s DiagFactorDesc=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),3)
 		s PINYINName=""
		s:DiagFactorDesc'="" PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorDesc) 
 		s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),4)
 		s UseFlag= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),5)        //使用标志
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中") 
 		s CreateDate=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),6)
 		s CreateUserID=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),7)
 		s Remarks=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(ID)),8)
		w !,DiagFactorCode_"	"_DiagFactorDesc_"	"_DiagFactorClass_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks
	}
	
	c file
	q fileName
}

/// Creator：丁亚男
/// CreatDate: 2020-12-23
/// Description：查询 诊断因子
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiagFactorBase","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "DiagFactorRowId:%String,DiagFactorName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s DiagFactorRowId=rowid
  s DiagFactorName=$LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(DiagFactorRowId)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" desc=$ZCONVERT(q,"U") //转换成大写
  
  s DiagFactorRowId=""
  for{  
	  s DiagFactorRowId=$o(^CT.WDT.CDSS.DiagFactorBaseD(DiagFactorRowId),-1) q:DiagFactorRowId=""  
	  s DiagFactorName=$LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(DiagFactorRowId)),3)
	  s UseFlag= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(DiagFactorRowId)),5)
	  s PINYIN=""
	  s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorName)   //&(($ZCONVERT(DiagFactorName,"U")[q)||(PINYIN[q))
	  if (($ZCONVERT(DiagFactorName,"U")[desc)||(PINYIN[desc)&(UseFlag="2")) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DiagFactorRowId,DiagFactorName)
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
/// Description：根据Id获取诊断因子类型
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.DiagFactorBase).getFactorClass("448")
ClassMethod getFactorClass(id As %String) As %String
{
    s FactorClass=""
   	s FactorClass=$LISTGET($G(^CT.WDT.CDSS.DiagFactorBaseD(id)),4)
    q FactorClass
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：id
/// Other: w ##class(web.CDSS.CMKB.DiagFactorBase).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.DiagFactorBaseD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s code = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(dataid)),2)
		s result = code+1
	}
	q result
}

/// Creator：赵文伟
/// CreatDate:2021-11-04
/// Input:RowId  Opreation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiagFactorBase).ChangeStatus(003,"1")
ClassMethod ChangeStatus(id, state)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(id)
	s obj.UseFlag=state
	s obj.CreateDate=$zdt($h,3)
 	s obj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-11-02
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TCMSymptom
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DiagFactorBase).ChangeStatusPass("")
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
			s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(id)
			s obj.UseFlag=2
			s obj.CreateDate=$zdt($h,3)
 			s obj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				continue
			}
			else{
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
/// CreatDate: 2021-10-02
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DiagFactorBase).ChangeStatusBack("")
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
			s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(id)
			s obj.UseFlag=0
			s obj.CreateDate=$zdt($h,3)
 			s obj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				continue
			}
			else{
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
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.DiagFactorBase
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DiagFactorBase).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiagFactorBaseD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(RowId)),5)       
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

/// Creator:丁亚男
/// CreatDate:2023-3-20
/// Description：更新诊断因子类型
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.DiagFactorBase).UpdateDiagFactor("D:\诊断因子修正0315.csv")
ClassMethod UpdateDiagFactor(FilePath)
{
	
	s result ="",count=0,fcount=0 
	s file=##class(%File).%New(FilePath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s DiagFactorName=$p(Line,",",1)
		s DiagFactorClass=$p(Line,",",2)
		s Validatedesc = $ZCONVERT(DiagFactorName,"U")
	    if $d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_Validatedesc))
	    {
			s ID =$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_Validatedesc,""))
			Ts
			s obj=##class(CT.WDT.CDSS.DiagFactorBase).%OpenId(ID) 
			s obj.DiagFactorClass=DiagFactorClass
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s count=count+1
			}
			else
			{
				Trollback
				s fcount=fcount+1
			}
	    }
		
	}
	q "成功"_count_"条！失败"_fcount_"条！"
}

}
