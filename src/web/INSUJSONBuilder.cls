/// ZMC 20140915
Class web.INSUJSONBuilder Extends %RegisteredObject [ LegacyInstanceContext, Not ProcedureBlock ]
{

/// 生成JSON，不使用request，这样方便使用
/// w ##class(web.INSUJSONBuilder).BuildJSONFromQuery("test","web.INSUDicDataCom","GetDicJSONInfo","SYS^^1^","^^^^^^")
/// w ##class(web.INSUJSONBuilder).BuildJSONFromQuery("test","web.INSUTarContrastCom","DhcTarQuery","asplc^1^CZZG^A^^2014-09-17","^^^^^^")
/// w ##class(web.INSUJSONBuilder).BuildJSONFromQuery("test","web.INSUTarContrastListCom","QueryConList","4802^CZZG","^^^^^^")
ClassMethod BuildJSONFromQuery(RootID As %String, classname As %String = "", methodname As %String = "", InArgs As %String = "", Expstr As %String = "") As %String
{

	s rtnstr ="100"
	s $ZT="Error"
	s sysRoot="INSUINFO"	//临时global根节点
	i ((classname="")||(methodname="")){
		q rtnstr
	}
	New rs,columns,%sc,i,execute
	s stflag=0
	s EndIndex="0"
	s spl=$c(36)	//$分割符
	s tmpArgspl="@"	//分割符
	;s clsargspl="^"
	;s:$g(qKey)'="" nqflag=$g(qKey)
	;s ^zmc(33)=Expstr
	s txtflag=+$p(Expstr,"^",1)
	s jsonflag=+$p(Expstr,"^",2)
	s nqflag=+$p(Expstr,"^",3)
	s start=+$p(Expstr,"^",4)
	s limit=+$p(Expstr,"^",5)
	s:start<1 start=1
	s QueryFlag=0
	s EndIndex=limit*start-1
	s StIndex=(start-1)*limit-1	
	s:StIndex<0 StIndex=""
	s:EndIndex<0 EndIndex=0
	s inArgs=$Replace(InArgs,$c(34),"")
	//判断是query还是类方法
	s Iscls=##class(websys.Conversions).IsValidClassName(classname)
	i (Iscls) d
	.s Isquery=##class(websys.Conversions).IsValidQueryName(classname,methodname)
	.q:('Isquery)
	.s QueryFlag=1
	//直接调用class类方法
	//判断是否有必要重新查询
	i ($d(^CacheTemp(sysRoot,RootID)))&(txtflag="1")
	{
		s tmcnt=$o(^CacheTemp(sysRoot,RootID,""),-1)+1
		s:tmcnt<1 nqflag=1
	}else{
		;s nqflag=1
	}
	i nqflag=1 
	{
		i $d(^CacheTemp("INSUINFOTitle",RootID)) k ^CacheTemp("INSUINFOTitle",RootID)
		i $d(^CacheTemp(sysRoot,RootID)) k ^CacheTemp(sysRoot,RootID)
		i QueryFlag
		{
			s Qcnt=0
			s rs=##class(%ResultSet).%New(classname_":"_methodname)
			s paramcnt=rs.GetParamCount()
			s execute="Set %sc=$method(rs,""Execute"""
			f i=1:1:paramcnt Set execute=execute_","_$c(34)_$p(inArgs,tmpArgspl,i)_$c(34)
			s execute=execute_")"
			Xecute execute
			;判断返回是否ResultSet
			s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
			i (myIsVal)
			{
				s columns=rs.GetColumnCount()
				s titstr=""
				f coli=1:1:columns d
				.s:titstr'="" titstr=titstr_"^"_rs.GetColumnName(coli)
				.s:titstr="" titstr=rs.GetColumnName(coli)
				s ^CacheTemp("INSUINFOTitle",RootID)=titstr
				f  q:rs.Next(.%sc)=0  i $$$ISOK(%sc) d
				.s rowdata=""
				.f coli=1:1:columns  d
				..s:rowdata'="" rowdata=rowdata_"^"_rs.GetData(coli)
				..s:rowdata="" rowdata=rs.GetData(coli)
			 	.s ^CacheTemp(sysRoot,RootID,Qcnt)=rowdata
			 	.s Qcnt=Qcnt+1
			}
			s Count=Qcnt
			d rs.%Close()
		}
		else
		{
			s Count=0
			;s Count=##class(web.INSUEXCUTE).ExcuteLong(classname,methodName,inArgs)
			;s Count=$CLASSMETHOD(classname,methodname,RootID,inArgs)	//inArg是用^把多个参数值拼起来,类方法实际就两个入参
			
			s execute="Set Count=$CLASSMETHOD("_$c(34)_classname_$c(34)_","_$c(34)_methodname_$c(34)_","_$c(34)_RootID_$c(34)
			f i=1:1:$l(inArgs,tmpArgspl) Set execute=execute_","_$c(34)_$p(inArgs,tmpArgspl,i)_$c(34)
			s execute=execute_")"
			Xecute execute
			s ^TMPZMC("BUG")=execute_"_"_Count
		}

	}
	else
	{
		s Count=$o(^CacheTemp(sysRoot,RootID,""),-1)+1
	}
	q:Count<1 "100"
	i (txtflag="1")
	{
		//输出原始数据,JS可直接导出xls文件
		i Count>0  d
		.s totcnt=Count
		.s:(EndIndex>totcnt)||(EndIndex=0) EndIndex=totcnt-1
		.s Index=""
		.s titval=^CacheTemp("INSUINFOTitle",RootID)
		.q:titval=""
		.w $replace(titval,"^",$c(9)),!
		.s Index=""
		.f  s Index=$o(^CacheTemp(sysRoot,RootID,Index)) q:Index=""  d
		..s tmplineval=$g(^CacheTemp(sysRoot,RootID,Index))
		..s tmplineval=$replace(tmplineval,$c(10),"")
		..s tmplineval=$replace(tmplineval,$c(13),"")
		..s tmplineval=$replace(tmplineval,$c(9),"")
		..w $replace(tmplineval,"^",$c(9)),!
		.s RtuValue=""

	}
	else
	{	
		//查询并生成json
		if jsonflag=1
		{
			//直接输出JSON
			i Count>0  d
			.s totcnt=Count
			.s:(EndIndex>totcnt)||(EndIndex=0) EndIndex=totcnt-1
			.s Index="",Head="{""total"":"""_totcnt_""",""rows"":[",End="]}"
			.w Head
			.s Index=StIndex	//翻页时看到上一页的最后一行
			.f  s Index=$o(^CacheTemp(sysRoot,RootID,Index)) q:Index=""  d
			..q:Index>EndIndex
			..s LinValue=$g(^CacheTemp(sysRoot,RootID,Index))
			..s:stflag=1 LinValue=","_LinValue
			..w LinValue
			..s stflag=1
			.w End
			.s RtuValue=""
		}
		else
		{
			//默认缓存是^分割，原始数据转换成json输出
			i Count>0  d
			.s totcnt=Count
			.s:(EndIndex>(totcnt-1))||(EndIndex=0) EndIndex=totcnt-1
			.s Index="",Head="{""total"":"""_totcnt_""",""rows"":[",End="]}"
			.q:$d(^CacheTemp("INSUINFOTitle",RootID))=0
			.s titval=^CacheTemp("INSUINFOTitle",RootID)
			.q:titval=""
			.w Head
			.S myArray = ##class(%ArrayOfDataTypes).%New()
			.s Index=StIndex	//翻页时看到上一页的最后一行
			.f  s Index=$o(^CacheTemp(sysRoot,RootID,Index)) q:Index=""  d
			..q:Index>EndIndex
			..s LinValue=$g(^CacheTemp(sysRoot,RootID,Index))
			..s jsonStr=""
			..f k=1:1:$l(titval,"^") d
			...d myArray.SetAt($p(LinValue,"^",k),$p(titval,"^",k))
			..s jsonStr =##class(web.INSUCacheJSON).Encode(myArray)
			..d myArray.Clear()
			..s:stflag=1 jsonStr=","_jsonStr
			..w jsonStr
			..s stflag=1
			.w End
			.s RtuValue=""
		}
	}
	q ""
	
Error
	q rtnstr_"^"_$ZE
}

/// This is a diagnostic function; it runs the specified query and prints the output to the console.
/// w ##class(web.INSUJSONBuilder).RunQuery("test","web.INSUTarContrastCom","DhcTarQuery","amxl","1","CZZG","A","","2014-09-17")
ClassMethod RunQuery(RootID As %String, ClassName As %String, QueryName As %String, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
{
	New rs,columns,%sc,i,execute
	New pcount Set pcount=$zutil(141)-3
	s Qcnt=0
	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s paramcnt=rs.GetParamCount()
	s execute="Set %sc=$method(rs,""Execute"""
	f i=1:1:pcount Set execute=execute_",.p"_i
	s execute=execute_")"
	Xecute execute
	;判断返回是否ResultSet
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i (myIsVal)
	{
		s columns=rs.GetColumnCount()
		s titstr=""
		f coli=1:1:columns d
		.s:titstr'="" titstr=titstr_"^"_rs.GetColumnName(coli)
		.s:titstr="" titstr=rs.GetColumnName(coli)
		s ^CacheTemp("INSUINFOTitle",RootID)=titstr
		f  q:rs.Next(.%sc)=0  i $$$ISOK(%sc) d
		.s rowdata=""
		.f coli=1:1:columns  d
		..s:rowdata'="" rowdata=rowdata_"^"_rs.GetData(coli)
		..s:rowdata="" rowdata=rs.GetData(coli)
	 	.s ^CacheTemp("INSUINFO",RootID,Qcnt)=rowdata
	 	.s Qcnt=Qcnt+1
	}
	d rs.%Close()
	q Qcnt
}

/// w ##class(web.INSUJSONBuilder).ToExcel("C:\INSU202061191258.xls","序号(非空)^RowID(新增时为空)^模版字段代码^模版字段名称^对照代码^对照名称^模版字段类型^医保类型^对照标志^父节点Rowid^父节点序号^^业务类型^预留1^预留2^预留3^预留4^预留5^HospitalDr^^^^","web.INSUINFOTemplate","GetConInfo","ZZB@@@A@INSUEPRUPLOAD@1@2")
ClassMethod ToExcel(ExcelName, title, ClassName, QueryName, InArgs As %String = "") As %String
{
	s $ZTrap = "ToExceleErr"
	New rs,File
	s spl=$c(36)	//分割符
	s tmpArgspl="@"	//分割符
	;New pcount Set pcount=$zutil(141)-3
	s pcount=$l(InArgs,tmpArgspl)
	Set excelDir = "\temp\excel\"
	i $l(ExcelName,".")=1{Set ExcelName = ExcelName_".xls"}
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	Set File = ##class(%File).%New(PhyDir_ExcelName)
	do File.Open("NWRS")
	s QueryFlag=1
	s Iscls=##class(websys.Conversions).IsValidClassName(ClassName)
	i (Iscls) d
	.s Isquery=##class(websys.Conversions).IsValidQueryName(ClassName,QueryName)
	.s:('Isquery) QueryFlag=0
	
	i (QueryFlag){
		s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
		s execute="Set %sc=$method(rs,""Execute"""
		f i=1:1:pcount Set execute=execute_","_$c(34)_$p(InArgs,tmpArgspl,i)_$c(34)
		s execute=execute_")"
		Xecute execute
		If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
		Set columns=rs.GetColumnCount()
		;d File.WriteLine($ZCONVERT($tr(title,tmpArgspl,$c(9)),"O","UTF8"))
		d File.WriteLine($tr($tr(title,tmpArgspl,$c(9)),"^",$c(9)))
		;For i=1:1:columns d File.Write(rs.GetColumnHeader(i)_",")
		;For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:columns  d File.Write(rs.GetData(i)_$c(9)) } else { quit }
		s tmplin=""
		s indexlin=1
		f{
			q:rs.Next(.%sc)=0
			if $$$ISOK(%sc) { 
				s tmplin=indexlin
				f i=2:1:columns  d 
				.;s tmplin=tmplin_$c(9)_$ZCONVERT(rs.GetData(i),"O","UTF8")
				.s tmplin=tmplin_$c(9)_rs.GetData(i)
				d File.WriteLine(tmplin) 
				s indexlin=indexlin+1
			} else { quit }
		}
		if $$$ISERR(%sc) do $system.OBJ.DisplayError(%sc)
		Do File.Flush()
		Do File.%Save()
		Do File.Close()
		Set File=""
		Set rs =""
	}else{
		;s execute="Set Count=$CLASSMETHOD("_ClassName_","_QueryName
		;f i=1:1:pcount Set execute=execute_","_$c(34)_$p(InArgs,tmpArgspl,i)_$c(34)
		;s execute=execute_")"
		;Xecute execute
		s sysRoot="INSUINFO"	//临时global根节点
		s tmpRootID=ClassName_QueryName_InArgs
		i $d(^CacheTemp(sysRoot,tmpRootID)) d
		.k ^CacheTemp(sysRoot,tmpRootID)		
		;s Count=$CLASSMETHOD(ClassName,QueryName,tmpRootID,InArgs)	
		
		s execute="Set Count=$CLASSMETHOD("_$c(34)_ClassName_$c(34)_","_$c(34)_QueryName_$c(34)_","_$c(34)_tmpRootID_$c(34)
		f i=1:1:$l(InArgs,tmpArgspl) Set execute=execute_","_$c(34)_$p(InArgs,tmpArgspl,i)_$c(34)
		s execute=execute_")"
		Xecute execute
			
		q:(+Count)<1 ""
		i Count>0  d
		.s Index=""
		.s titval=^CacheTemp("INSUINFOTitle",tmpRootID)
		.d File.WriteLine($tr($tr(title,tmpArgspl,$c(9)),"^",$c(9)))
		.s Index=""
		.f  s Index=$o(^CacheTemp(sysRoot,tmpRootID,Index)) q:Index=""  d
		..s tmplineval=$g(^CacheTemp(sysRoot,tmpRootID,Index))
		..s tmplineval=$replace(tmplineval,$c(10),"")
		..s tmplineval=$replace(tmplineval,$c(13),"")
		..s tmplineval=$replace(tmplineval,$c(9),"")
		..d File.WriteLine($replace(tmplineval,"^",$c(9))) 
		Do File.Flush()
		Do File.%Save()
		Do File.Close()
		Set File=""
		Set rs =""
	}

    //Quit "dhctt.file.csp?act=download&filename="_ExcelName_"&dirname="_PhyDir
    q "/temp/excel/"_ExcelName
ToExceleErr
	b ;err
	Set File=""
	Set rs =""
	q "/temp/excel/"_ExcelName
}

}
