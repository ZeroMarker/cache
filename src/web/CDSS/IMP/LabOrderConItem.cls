/// 名称:基础库-HIS检验医嘱和HIS检验项目关联表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-8-4
Class web.CDSS.IMP.LabOrderConItem Extends %RegisteredObject
{

/// Creator：阚延新	
/// CreatDate: 2021-8-5
/// Description：对接方检查检验字典表 下拉框
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input:id ,code,desc,type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.LabOrderConItem","GetDataForCmb1","","","","","3","15","1")
Query GetDataForCmb1(rowid As %String, q As %String, code As %String, desc As %String, type As %String, hospid As %String, flag As %String) As %Query(ROWSPEC = "ID,DictCode,DictDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, q As %String, code As %String, desc As %String, type As %String, hospid As %String, flag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConExamDictD(ID))
		q:ID=""
		s DictCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//对接方检查检验字典代码
		continue:((code'="")&&(($ZCONVERT(DictCode,"U")'[code)))
		s DictDesc= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//对接方检查检验字典描述
		continue:((desc'="")&&(($ZCONVERT(DictDesc,"U")'[desc)))
		s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),17)		//对接方检查检验字典分类
		continue:ExamType=""
		s:ExamType="检查" DictType=2
		s:ExamType="检验项目" DictType=3
		s:ExamType="检验医嘱" DictType=13 
		continue:((type'="")&&(DictType'=type))
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
		s:DictHosp'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(DictHosp)),3)
		continue:((hospid'="")&&(DictHosp'=hospid))
		if (DictType=3)
		{
			s DictFlag=$d(^CT.WDT.CDSS.LabOrderConItemI("ItemHospIndex",DictCode,DictDesc,hospid)) //是否匹配
		}
		if (DictType=13)
		{
			s DictFlag=$d(^CT.WDT.CDSS.LabOrderConItemI("OrderHospIndex",DictCode,DictDesc,hospid)) //是否匹配
		}
		s Flag=0
		s:DictFlag>0 Flag=1
		continue:((flag'="")&&(Flag'=flag))
		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DictDesc)
	  	if (($ZCONVERT(DictDesc,"U")[q)||(PINYIN[q))	//过滤
	  	{
	  		d OutputRow
	 	}
	}
						
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,DictCode,DictDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:阚延新
/// CreatDate: 2021-8-5
/// Description：保存 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input: str
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.LabOrderConItem).SaveData("31^1826927^1827104")
ClassMethod SaveData(str As %String) As %String
{
	s result=""
	s hospid=$p(str,"^",1)  //医院ID
	s ordid=$p(str,"^",2)	//医嘱ID
	s proid=$p(str,"^",3)   //项目ID
	
	s LabOrderCode=$lg($G(^CT.WDT.CDSS.ConExamDictD(ordid)),2)			//检验医嘱代码
	s LabOrderDesc=$lg($G(^CT.WDT.CDSS.ConExamDictD(ordid)),3)			//检验医嘱描述
	s LabOrderStartDate=$lg($G(^CT.WDT.CDSS.ConExamDictD(ordid)),15)	//医嘱开始日期
	s LabOrderEndDate=$lg($G(^CT.WDT.CDSS.ConExamDictD(ordid)),16)		//医嘱结束日期
	s LabItemCode=$lg($G(^CT.WDT.CDSS.ConExamDictD(proid)),2)			//检验小项代码
	s LabItemDesc=$lg($G(^CT.WDT.CDSS.ConExamDictD(proid)),3)			//检验小项描述
	
	s eobj = ##class(web.CDSSEntity.IMP.LabOrderConItem).%New()
	
	s eobj.LabItemCode = LabItemCode	             	//检验小项代码
	s eobj.LabItemDesc = LabItemDesc					//检验小项描述
	s eobj.LabOrderCode = LabOrderCode					//检验医嘱代码
	s eobj.LabOrderDesc = LabOrderDesc					//检验医嘱描述
	s eobj.LabOrderStartDate = LabOrderStartDate		//医嘱开始日期
	s eobj.LabOrderEndDate = LabOrderEndDate			//医嘱结束日期
	s eobj.ConStartDate=+$H								//对照开始日期
	s eobj.ConEndDate=""								//对照结束日期
	s eobj.DictHosp=hospid								//医院
	s result=..SaveEntity(eobj)
	
	q result
}

/// Creator:阚延新
/// CreatDate: 2021-8-6
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.LabOrderConItem).FormValidate("26274","I21.103","5","37")
ClassMethod FormValidate(id As %String, icode As %String, ocode As %String, hosp As %String) As %String
{
	s flag="",flagc=""
	s:((icode'="")&&(hosp'="")&&(ocode'="")) flagc=$d(^CT.WDT.CDSS.LabOrderConItemI("UniqueHospIndex",icode,ocode,hosp))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		
		s:((icode'="")&&(hosp'="")&&(ocode'="")) idc=$o(^CT.WDT.CDSS.LabOrderConItemI("UniqueHospIndex",icode,ocode,hosp,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) 	//返回重复标志
		{
			s flag=1  
		}
		else  	//返回不重复标志
		{
			s flag=0 
		}
	}
	q flag
}

/// Creator:阚延新
/// CreatDate: 2021-8-5
/// Description：保存 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input: eobj As web.CDSSEntity.IMP.LabOrderConItem
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.LabOrderConItem).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.LabOrderConItem) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s flag=..FormValidate(eobj.ID,eobj.LabItemCode,eobj.LabOrderCode,eobj.DictHosp)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.LabOrderConItem).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.LabOrderConItem).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.LabOrderConItem).%New()
			s bobj.ID = eobj.ID
			s:obj.DictHosp'="" bobj.DictHosp = obj.DictHosp.%Id()	//医院
			s bobj.LabItemCode=eobj.LabItemCode						//检验小项代码
			s bobj.LabItemDesc=eobj.LabItemDesc						//检验小项描述
			s bobj.LabOrderCode=eobj.LabOrderCode					//检验医嘱代码
			s bobj.LabOrderDesc=eobj.LabOrderDesc					//检验医嘱描述
			s bobj.LabOrderStartDate=eobj.LabOrderStartDate			//医嘱开始日期
			s bobj.LabOrderEndDate=eobj.LabOrderEndDate				//医嘱结束日期
			s bobj.ConStartDate=eobj.ConStartDate					//对照开始日期
			s bobj.ConEndDate=eobj.ConEndDate						//对照结束日期
		}
		d:eobj.DictHosp'="" obj.DictHospSetObjectId(eobj.DictHosp)	//医院
		d:eobj.DictHosp="" obj.DictHospSetObjectId("")
		s obj.LabItemCode=eobj.LabItemCode							//检验小项代码
		s obj.LabItemDesc=eobj.LabItemDesc							//检验小项描述
		s obj.LabOrderCode=eobj.LabOrderCode						//检验医嘱代码
		s obj.LabOrderDesc=eobj.LabOrderDesc						//检验医嘱描述
		s obj.LabOrderStartDate=eobj.LabOrderStartDate				//医嘱开始日期
		s obj.LabOrderEndDate=eobj.LabOrderEndDate					//医嘱结束日期
		s obj.ConStartDate=eobj.ConStartDate						//对照开始日期
		s obj.ConEndDate=eobj.ConEndDate							//对照结束日期
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("LabOrderConItem","CT.WDT.CDSS.LabOrderConItem","HIS检验医嘱和HIS检验项目关联表",id,eobj.DictHosp_"-"_eobj.LabItemCode_"-"_eobj.LabOrderCode,"A",eobj)
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("LabOrderConItem","CT.WDT.CDSS.LabOrderConItem","HIS检验医嘱和HIS检验项目关联表",id,eobj.DictHosp_"-"_eobj.LabItemCode_"-"_eobj.LabOrderCode,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("HIS检验医嘱和HIS检验项目关联表","web.CDSS.IMP.LabOrderConItem","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：阚延新	
/// CreatDate: 2021-8-5
/// Description：查询 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.LabOrderConItem","GetList","","","","","","")
Query GetList(rowid As %String, icode As %String, idesc As %String, ocode As %String, odesc As %String, hospid As %String) As %Query(ROWSPEC = "ID,LabItemCode,LabItemDesc,LabOrderCode,LabOrderDesc,LabOrderStartDate,LabOrderEndDate,ConStartDate,ConEndDate,DictHosp")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, icode As %String, idesc As %String, ocode As %String, odesc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		//ID,LabItemCode,LabItemDesc,LabOrderCode,LabOrderDesc,LabOrderStartDate,LabOrderEndDate,ConStartDate,ConEndDate,DictHosp
		//DictMapType,DictCode,DictDesc,IntDictCode,IntDictDesc,MatchFlag,UseFlag,Remarks,DictDR,IntDictDR
		s LabItemCode= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),2)				//检验小项代码
		s LabItemDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),3)			//检验小项描述
		s LabOrderCode=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),4)			//检验医嘱代码
		s LabOrderDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),5)			//检验医嘱描述
		s LabOrderStartDate=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),6)	//医嘱开始日期
		s LabOrderEndDate= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),7)			//医嘱结束日期
		s ConStartDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),8)				//对照开始日期
		s ConEndDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),9)				//对照结束日期
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),10)			//所属医院
		s:DictHosp'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(DictHosp)),3)
		d OutputRow	
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.LabOrderConItemD(ID))
			q:ID=""
			s LabItemCode= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),2)				//检验小项代码
			continue:((icode'="")&&(LabItemCode'=icode))
			s LabItemDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),3)			//检验小项描述
			continue:((idesc'="")&&(LabItemDesc'=idesc))
			s LabOrderCode=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),4)			//检验医嘱代码
			continue:((ocode'="")&&(LabOrderCode'=ocode))
			s LabOrderDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),5)			//检验医嘱描述
			continue:((odesc'="")&&(LabOrderDesc'=odesc))
			s LabOrderStartDate=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),6)	//医嘱开始日期
			s LabOrderEndDate= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),7)			//医嘱结束日期
			s ConStartDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),8)				//对照开始日期
			s ConEndDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),9)				//对照结束日期
			s DictHosp=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),10)			//所属医院
			continue:((hospid'="")&&(DictHosp'=hospid))
			s:DictHosp'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(DictHosp)),3)			
			d OutputRow	
		}						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,LabItemCode,LabItemDesc,LabOrderCode,LabOrderDesc,LabOrderStartDate,LabOrderEndDate,ConStartDate,ConEndDate,DictHosp)
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

/// Creator：阚延新	
/// CreatDate: 2021-8-5
/// Description：查询 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.LabOrderConItem).DeleteData(1)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
		
	s pobj = ##class(CT.WDT.CDSS.LabOrderConItem).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.IMP.LabOrderConItem).%New()
	
	s:pobj.DictHosp'="" eobj.DictHosp = pobj.DictHosp.%Id()	//医院
	s eobj.LabItemCode=pobj.LabItemCode						//检验小项代码
	s eobj.LabItemDesc=pobj.LabItemDesc						//检验小项描述
	s eobj.LabOrderCode=pobj.LabOrderCode					//检验医嘱代码
	s eobj.LabOrderDesc=pobj.LabOrderDesc					//检验医嘱描述
	s eobj.LabOrderStartDate=pobj.LabOrderStartDate			//医嘱开始日期
	s eobj.LabOrderEndDate=pobj.LabOrderEndDate				//医嘱结束日期
	s eobj.ConStartDate=pobj.ConStartDate					//对照开始日期
	s eobj.ConEndDate=pobj.ConEndDate						//对照结束日期
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(CT.WDT.CDSS.LabOrderConItem).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCDSSLabOrderConItem","CT.WDT.CDSS.LabOrderConItem","HIS检验医嘱和HIS检验项目关联表",id,eobj.DictHosp_"-"_eobj.LabItemCode_"-"_eobj.LabOrderCode,"D",eobj)
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("HIS检验医嘱和HIS检验项目关联表","web.CDSS.IMP.LabOrderConItem","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}

	q result
}

/// Creator：阚延新	
/// CreatDate: 2021-8-5
/// Description：HIS检验医嘱和HIS检验项目关联表导出
/// Table:
/// Input：
/// d ##class(web.CDSS.IMP.LabOrderConItem).ExportDataTXT()   
ClassMethod ExportDataTXT(hosp As %String)
{
   	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"HIS检验医嘱和HIS检验项目关联数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/IMP/DataExport/"
		s file=Path_"scripts/bdp/CDSS/IMP/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
    o file:"WNS"
    u file
    w "所属医院	检验医嘱代码	检验医嘱描述	检验小项代码	检验小项描述	医嘱开始日期	医嘱结束日期	对照开始日期	对照结束日期"   //注意此处是用tab隔开
   
    s Num=0
    s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.LabOrderConItemD(ID))
		q:ID=""
		s LabItemCode= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),2)				//检验小项代码
		s LabItemDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),3)			//检验小项描述
		s LabOrderCode=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),4)			//检验医嘱代码
		s LabOrderDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),5)			//检验医嘱描述
		s LabOrderStartDate=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),6)	//医嘱开始日期
		s LabOrderEndDate= $lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),7)			//医嘱结束日期
		s ConStartDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),8)				//对照开始日期
		s ConEndDate=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),9)				//对照结束日期
		
		s LabOrderStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LabOrderStartDate)
		s LabOrderEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LabOrderEndDate)
		s ConStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ConStartDate)
		s ConEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ConEndDate)
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.LabOrderConItemD(ID)),10)			//所属医院
		continue:((hosp'="")&&(DictHosp'=hosp))
		s:DictHosp'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(DictHosp)),3)			
		//w !,DictHospDesc_"^"_LabOrderCode_"^"_LabOrderDesc_"^"_LabItemCode_"^"_LabItemDesc_"^"_LabOrderStartDate_"^"_LabOrderEndDate_"^"_ConStartDate_"^"_ConEndDate   //注意此处连接符是tab
		w !,DictHospDesc_"	"_LabOrderCode_"	"_LabOrderDesc_"	"_LabItemCode_"	"_LabItemDesc_"	"_LabOrderStartDate_"	"_LabOrderEndDate_"	"_ConStartDate_"	"_ConEndDate
	
	}
	
	c file
	;W !,file_" 生成成功，共"_Num_"条"
	Q fileName
}

/// Creator：阚延新	
/// CreatDate: 2021-8-6
/// Description：导入 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.LabOrderConItem).ImportDataTXT("D:/HIS检验医嘱和检验项目关联.txt")
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
		s LabItemCode=$p(data,$c(9),1)			//检验小项代码
		s LabItemDesc=$p(data,$c(9),2)			//检验小项描述
		s LabOrderCode=$p(data,$c(9),3)			//检验医嘱代码
		s LabOrderDesc=$p(data,$c(9),4)			//检验医嘱描述
		s LabOrderStartDate=$p(data,$c(9),5)	//医嘱开始日期
		s LabOrderEndDate=$p(data,$c(9),6)		//医嘱结束日期
		s ConStartDate=$p(data,$c(9),7)			//对照开始日期
		s ConEndDate=$p(data,$c(9),8)			//对照结束日期
		s DictHospDesc="深圳市中医院"				//所属医院
		if (LabOrderStartDate[":")		//带有时间
		{
			s LabOrderStartDate=$p(LabOrderStartDate," ",1)	
		}
		if (LabOrderEndDate[":")		//带有时间
		{
			s LabOrderEndDate=$p(LabOrderEndDate," ",1)	
		}
		if (LabOrderStartDate'="")
		{
			s:LabOrderStartDate["/" LabOrderStartDate=$Replace(LabOrderStartDate,"/","-")
			s LabOrderStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(LabOrderStartDate)
		}
		if (LabOrderEndDate'="")
		{
			s:LabOrderEndDate["/" LabOrderEndDate=$Replace(LabOrderEndDate,"/","-")
			s LabOrderEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(LabOrderEndDate)
		}
		if ((LabOrderEndDate'="")&&(LabOrderEndDate<+$h))	//过期
		{
			b ;1
			s timecontinuecount=timecontinuecount+1
			continue
		}
		if (ConStartDate[":")		//带有时间
		{
			s ConStartDate=$p(ConStartDate," ",1)	
		}
		if (ConEndDate[":")		//带有时间
		{
			s ConEndDate=$p(ConEndDate," ",1)	
		}
		if (ConStartDate'="")
		{
			s:ConStartDate["/" ConStartDate=$Replace(ConStartDate,"/","-")
			s ConStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ConStartDate)
		}
		if (ConEndDate'="")
		{
			s:ConEndDate["/" ConEndDate=$Replace(ConEndDate,"/","-")
			s ConEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ConEndDate)
		}
		if ((ConEndDate'="")&&(ConEndDate<+$h))	//过期
		{
			b ;2
			s timecontinuecount=timecontinuecount+1
			continue
		}
		s DictHosp=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(DictHospDesc,"U"),""))
		if (DictHosp="")	//医院错误
		{
			s continuecount=continuecount+1
			continue
		}
		
		s eobj = ##class(web.CDSSEntity.IMP.LabOrderConItem).%New()		
		s eobj.LabItemCode = LabItemCode	             	//检验小项代码
		s eobj.LabItemDesc = LabItemDesc					//检验小项描述
		s eobj.LabOrderCode = LabOrderCode					//检验医嘱代码
		s eobj.LabOrderDesc = LabOrderDesc					//检验医嘱描述
		s eobj.LabOrderStartDate = LabOrderStartDate		//医嘱开始日期
		s eobj.LabOrderEndDate = LabOrderEndDate			//医嘱结束日期
		s eobj.ConStartDate=ConStartDate					//对照开始日期
		s eobj.ConEndDate=ConEndDate						//对照结束日期
		s eobj.DictHosp=DictHosp							//医院
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
	w "过期数据"_timecontinuecount,!
	w "医院类型错误"_continuecount,!
	//q result
	q "{success:'true'}"
}

/// Creator：阚延新	
/// CreatDate: 2021-8-6
/// Description：导入 HIS检验医嘱和HIS检验项目关联表
/// Table:CT.WDT.CDSS.LabOrderConItem HIS检验医嘱和HIS检验项目关联表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.LabOrderConItem).KLabOrderConItemGlobal()
ClassMethod KLabOrderConItemGlobal() As %String
{
	k ^CT.WDT.CDSS.LabOrderConItemD
	k ^CT.WDT.CDSS.LabOrderConItemI
	q ""
}

/// 根据检验医嘱名获取关联的检验项目名
/// w ##class(web.CDSS.IMP.LabOrderConItem).GetConItem("阴道分泌物检查","31")
ClassMethod GetConItem(OrderName As %String, HospID As %String) As %String
{
	s ID=0
	s ItemDescStr=""
	for
	{
		s ID=$o(^CT.WDT.CDSS.LabOrderConItemI("OrderDescIndex",OrderName,ID))
		q:ID=""
		
		s ItemDesc=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),3)		//检验小项描述
		s DictHosp=$lg($g(^CT.WDT.CDSS.LabOrderConItemD(ID)),10)		//关联医院
		continue:(DictHosp'=HospID)
		if ItemDescStr=""
		{
			s ItemDescStr=ItemDesc	
		}
		else
		{
			s ItemDescStr=ItemDescStr_"^"_ItemDesc	
		}
	}
	
	q ItemDescStr
}

}
