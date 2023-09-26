/// 系统工具
Class web.DHCSTMHUI.Tools.UtilTools Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM)
{

/// Description:导出对应目录中的类(在当前目录中新建Export文件夹)
/// Creator:	wangjiabin
/// CreateDate:	2015-03-31
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).ExportXmlByFile("C:\Users\jiabin\Desktop\AZUsertmp\")
ClassMethod ExportXmlByFile(DirectoryName)
{
	s DirectoryName=$tr(DirectoryName,"\","/")
	s isDir=##class(%File).DirectoryExists(DirectoryName)
	q:'isDir -1
	
	s ExportDirName=DirectoryName_"/Export/"
	
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(DirectoryName,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("ItemName")
		s FileType=$e(FileName,$l(FileName)-3,$l(FileName))
		continue:(FileType'=".xml")&&(FileType'=".XML")
		s FileNameOnly=$e(FileName,1,$l(FileName)-4)
		continue:'$d(^$R("^"_FileNameOnly_".1"))	;不存在的过滤
		s FileClsName=FileNameOnly_".cls"
		s FileExpName=FileNameOnly_".xml"
		d $system.OBJ.Export(FileClsName,ExportDirName_FileExpName)
	}
	
	;2016-04-20 add 直接复制不同的xml文件
	d ..CheckFileInfo(DirectoryName)
}

/// Description:对于ExportXmlByFile方法导出的xml文件,做快速对比
/// Creator:	wangjiabin
/// CreateDate:	2016-04-20
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckFileInfo("E:\wjUser1\GUser\")
ClassMethod CheckFileInfo(NewPath, OldPath = "") As %String
{
	w !,!
	;1.遍历NewFile中文件,截取user-name
	s NewPath=$tr(NewPath,"\","/")
	s isDir=##class(%File).DirectoryExists(NewPath)
	q:'isDir -1
	
	i OldPath="" d
	.s OldPath=NewPath_"/Export/"	;用于对比user类,缺省使用文件夹内部的Export文件夹
	
	;不同文件的存储目录名称
	s DifferencePath="Difference"
	
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(NewPath,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("ItemName")
		continue:'$f(FileName,".xml")&&'$f(FileName,".XML")				;过滤.svn等文件
		
		s FilePath=NewPath_"/"_FileName
		s OldFilePath=OldPath_"/"_FileName
		s IsOldFileExists=##class(%File).Exists(OldFilePath)
		;若OldPath中不存在同名文件,返回信息
		i IsOldFileExists=0 d
		.s ret=##class(%File).CreateNewDir(NewPath,DifferencePath)
		.s ret=##class(%File).CopyFile(FilePath,NewPath_"/"_DifferencePath_"/"_FileName)
		.w FileName,?40,"不存在!",?50,!
		continue:(IsOldFileExists=0)
		
		;若存在, 则进行对比
		s CompareStr=..CompareFile(FilePath,OldFilePath)
		i CompareStr'="" d
		.s ret=##class(%File).CreateNewDir(NewPath,DifferencePath)
		.s ret=##class(%File).CopyFile(FilePath,NewPath_"/"_DifferencePath_"/"_FileName)
		.w FileName,?40,CompareStr,?50,!
	}
}

/// 对比两个xml文件(user类)
ClassMethod CompareFile(FileName, OldFileName) As %String
{
	q:'##class(%File).Exists(FileName) "目录错误!!!"
	q:'##class(%File).Exists(OldFileName) "目录错误!!!"
	s NotEqualLines=""
	
	;1.行数不同的, 直接返回
	s RowsNum=..GetFileLineNum(FileName)
	s OldRowsNum=..GetFileLineNum(OldFileName)
	i (+RowsNum'>0)||(+OldRowsNum'>0)||(RowsNum'=OldRowsNum) q "行数不等!"
	
	;2.对比明细内容, 某些特殊的行不判断
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=FileName
	s oldstream=##class(%FileCharacterStream).%New()
	s oldstream.Filename=OldFileName
	s count=0
	while ('stream.AtEnd) {
		s Line=stream.ReadLine()
		s OldLine=oldstream.ReadLine()
		;小机unix环境下对比时,会有$c(13)等特殊字符
		s Line=$$FormatXmlLine(Line)
		s OldLine=$$FormatXmlLine(OldLine)
		s count=count+1
		continue:Line=OldLine
		
		continue:(Line["<Export generator=")&&(OldLine["<Export generator=")
		continue:(Line["<ConditionalWithHostVars")&&(OldLine["<ConditionalWithHostVars")
		continue:(Line["<TimeChanged>")&&(OldLine["<TimeChanged>")
		continue:((Line="<Type>%Storage.SQL</Type>")&&(OldLine["<Type>%Library.CacheSQLStorage</Type>"))||((OldLine="<Type>%Storage.SQL</Type>")&&(Line["<Type>%Library.CacheSQLStorage</Type>"))
		continue:((Line="<Type>%Storage.Persistent</Type>")&&(OldLine["<Type>%Library.CacheStorage</Type>"))||((OldLine="<Type>%Storage.Persistent</Type>")&&(Line["<Type>%Library.CacheStorage</Type>"))
		
		i NotEqualLines="" d
		.s NotEqualLines=count
		e  d
		.s NotEqualLines=NotEqualLines_","_count
	}
	q NotEqualLines

FormatXmlLine(Str)
	s Str=$tr(Str,$c(13))
	q Str
}

/// 获取行数
/// w ##class(web.DHCSTMHUI.Tools.UtilTools).GetFileLineNum("D:\a\1.txt")
ClassMethod GetFileLineNum(FileName) As %String
{
	q:'##class(%File).Exists(FileName) "参数错误"
	s (line,parid,errs)=""
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=FileName
	s count=0
	while 'stream.AtEnd {
		s LineContent=stream.ReadLine()
		s count=count+1
	}
	q count
}

/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckJS("D:\dthealth")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckJS("/dthealth/")
/// Description:检查js文件调用问题(是否存在,Linux环境可检查大小写是否匹配)
/// 			css没做考虑
/// Creator:	wangjiabin
/// CreateDate:	2021-02-27
/// Input:		DirectoryName:dthealth目录的绝对路径(如/dthealth/)
/// Output:		存在js文件不存在csp,js名称
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckJS("D:\dthealth\")
ClassMethod CheckJS(DirectoryName)
{
	s DirectoryName=##class(%File).NormalizeDirectory(DirectoryName)
	s isDir=##class(%File).DirectoryExists(DirectoryName)
	q:'isDir -1
	
	k ^||tmp("JSExistCheck",$j)
	s WEBDir=DirectoryName_"app/dthis/web"
	s WEBDir=##class(%File).NormalizeDirectory(WEBDir)
	s CSPDir=DirectoryName_"app/dthis/web/csp/"
	s CSPDir=##class(%File).NormalizeDirectory(CSPDir)
	
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(CSPDir,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("ItemName")
		;这里根据需要灵活调整,没必要检索所有的csp
		continue:(FileName'["dhcstmhui.")&&(FileName'["cssdhui.")
		
		s CSPFileName=CSPDir_FileName
		d ..IsJSExist(CSPFileName,WEBDir)
	}
	w !,"共发现:"_$g(^||tmp("JSExistCheck",$j))
}

/// 对比两个JS文件
ClassMethod IsJSExist(CSPFileName, Dir) As %String
{
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=CSPFileName
	s count=0
	while ('stream.AtEnd) {
		s Line=stream.ReadLine()
		s Line=$$FormatXmlLine(Line)
		
		;<script type="text/javascript" src="../scripts/hisui/websys.comm.js"></script>
		continue:Line'["text/javascript"		;不是js调用的,过滤
		;这里的写法, 不追求极致, 使用时根据具体情况略作调整
		s JSName=$p(Line," src=""../",2)
		s JSName=$p(JSName,"""",1)
		
		s JSFileName=Dir_JSName
		s JSFileName=##class(%File).NormalizeFilename(JSFileName)
		s ExistFlag=##class(%File).Exists(JSFileName)
		continue:ExistFlag
		
		s ^||tmp("JSExistCheck",$j)=1+$g(^||tmp("JSExistCheck",$j))
		w CSPFileName,!,JSName,!,!
	}
	q 0

FormatXmlLine(Str)
	s Str=$tr(Str,$c(13))
	q Str
}

/// 检查js文件是否被引用. 执行后查看^tmp("jscheck")
/// Input:	CSPDir-标准版csp目录, JSFile-标准版js目录
/// 		注: 注意斜杠完整(仅用于windows下检测)
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckJS2("D:\MediwaySVN\Materials\trunk\DHCSTM-HISUI\DHCSTMHUICode\CSP\","D:\MediwaySVN\Materials\trunk\DHCSTM-HISUI\DHCSTMHUICode\JS\")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckJS2("D:\MediwaySVN\CSSD\trunk\CSSDHUI\CSSDHUICode\csp\","D:\MediwaySVN\CSSD\trunk\CSSDHUI\CSSDHUICode\js\")
ClassMethod CheckJS2(CSPDir, JSFile)
{
	k ^tmp("jscheck")
	;记录js文件的临时global
	d ..RecordJSFileGlobal(JSFile,JSFile)
	
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(CSPDir,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("ItemName")
		;这里根据需要灵活调整,没必要检索所有的csp
		continue:(FileName'["dhcstmhui.")&&(FileName'["cssdhui.")
		
		s CSPFileName=CSPDir_FileName
		s stream=##class(%FileCharacterStream).%New()
		s stream.Filename=CSPFileName
		s count=0
		while ('stream.AtEnd) {
			s Line=stream.ReadLine()
			s Line=$tr(Line,$c(13))
			
			;<script type="text/javascript" src="../scripts/hisui/websys.comm.js"></script>
			continue:Line'["text/javascript"		;不是js调用的,过滤
			;这里的写法, 不追求极致, 使用时根据具体情况略作调整
			s JSName=$p(Line," src=""../",2)
			s JSName=$p(JSName,"""",1)
			
			i JSName'="" d
			.s JSName=$tr(JSName,"/","\")
			.k ^tmp("jscheck",JSName)
		}
	}
	zw ^tmp("jscheck")
}

/// 根据js目录,记录文件名称的glboal
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).AddFileIntoProject("D:\MediwaySVN\Materials\trunk\DHCSTM-HISUI\DHCSTMHUICode\JS\","D:\MediwaySVN\Materials\trunk\DHCSTM-HISUI\DHCSTMHUICode\JS\")
ClassMethod RecordJSFileGlobal(DirectoryName, DirectoryName2) [ Private ]
{
	s isDir=##class(%File).DirectoryExists(DirectoryName)
	i isDir {
		s resultset=##class(%ResultSet).%New("%File:FileSet")
		s wildcard="",sortby="",includedirs=0
		d resultset.Execute(DirectoryName,wildcard,sortby,includedirs)
		While(resultset.Next())
		{
			s FileName=resultset.Data("Name")
			continue:(FileName["dhcstmhisui\Common")||(FileName["dhcstmhisui\ExtUX")
			continue:(FileName["cssd\Common")||(FileName["cssd\ExtUX")
			s LastName=##class(%File).GetFilename(FileName)
			d ..RecordJSFileGlobal(FileName,DirectoryName2)
		}
	}else{
		s FileName=$p(DirectoryName,DirectoryName2,2)
		i (FileName'="")&&($e(FileName,*-2,*)=".js") d
		.s FileName="scripts\"_FileName
		.s ^tmp("jscheck",FileName)=""
	}
}

/// 检查svn目录中(本地文件夹),web类调用的冗余问题. 注意,这里只是检查的web类中的调用,可能存在部分文件,直接由前端js调用.
/// 	遍历所有文件,获取所有web调用, 去除本目录内存在的
/// Input:		web类文件夹名称(因web文件夹内不分层,不做递归处理-即不考虑多层文件夹)
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckClass("D:\MediwaySVN\Materials\trunk\DHCSTM-HISUI\DHCSTMHUICode\Web\")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckClass("D:\MediwaySVN\CSSD\trunk\CSSDHUI\CSSDHUICode\web\")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckClass("D:\MediwaySVN\Endoscope\trunk\EndosCode\web\")
ClassMethod CheckClass(ClassDir)
{
	k ^TMP("ClassCheck")
	;记录类调用的临时global
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(ClassDir,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("Name")
		s ClsFileName=##class(%File).GetFilename(FileName)
		
		s stream=##class(%FileCharacterStream).%New()
		s stream.Filename=FileName
		s count=0
		while 'stream.AtEnd {
			s LineContent=stream.ReadLine()
			s LineContent=$tr(LineContent,$c(13))
			continue:LineContent'["web."
			s FrontPart=$p(LineContent,"web.",1)
			s BehindPart=$p(LineContent,"web.",2)
			
			s Len=$l(BehindPart)
			s Index=Len
			f i=1:1:Len q:Index<Len  d
			.s Char=$e(BehindPart,i)
			.s CharCode=$a(Char)
			.q:Char="."
			.q:(CharCode>=48)&&(CharCode<=57)	;0--9
			.q:(CharCode>=65)&&(CharCode<=90)	;a--z
			.q:(CharCode>=97)&&(CharCode<=122)	;A--Z
			.
			.s Index=i-1
			
			s ClassName=$e(BehindPart,1,Index)
			continue:ClassName=""
			s ClassName="web."_ClassName
			s ^TMP("ClassCheck",ClassName)=""
			s ^TMP("ClassCheck",ClassName,ClsFileName)=""
		}
	}
	
	s resultset=##class(%ResultSet).%New("%File:FileSet")
	s wildcard="",sortby="",includedirs=0
	d resultset.Execute(ClassDir,wildcard,sortby,includedirs)
	While(resultset.Next())
	{
		s FileName=resultset.Data("ItemName")
		s LastName=##class(%File).GetFilename(FileName)
		s ClassName=$p(LastName,".xml")
		continue:ClassName=""
		k ^TMP("ClassCheck",ClassName)
	}
	zw ^TMP("ClassCheck")
}

/// Description:导入新工程后,检查某Package下,不在此工程中的cls
/// 			输出类名, 并添加到一个名为TMPTMPTMP的工程中去
/// Input:		PackageName-包的名称; ProjectName-工程名称;
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckExtraCls("web.DHCSTMHUI","DHCSTM")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckExtraCls("web.CSSDHUI","CSSD")
ClassMethod CheckExtraCls(PackageName, ProjectName)
{
	s Count=0
	d $system.OBJ.GetPackageList(.ClassList,PackageName)
	
	;创建一个临时工程
	s TMPProjectName="TMPTMPTMP"
	&sql(INSERT INTO %Studio.Project (Name) values (:TMPProjectName))
	&sql(DELETE FROM %Studio.ProjectItem WHERE Project=:TMPProjectName)
	
	s ClassName=""
	f  s ClassName=$o(ClassList(ClassName)) q:ClassName=""  d
	.&sql(SELECT * FROM %Studio.ProjectItem WHERE Project=:ProjectName AND Name=:ClassName)
	.i SQLCODE=100 d
	..s Count=Count+1
	..w ClassName,!
	..
	..;写入临时工程
	..s ItemId=TMPProjectName_"||"_ClassName_"||CLS"
	..s ItemType="CLS"
	..&sql(INSERT INTO %Studio.ProjectItem (Project,ID,Name,Type)
			values (:TMPProjectName,:ItemId,:ClassName,:ItemType))
	
	w "共"_Count_"个, 仅供参考,注意核实!!!"
}

/// 从工程中导出类文件
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).ExportProjectforSVN("STM---USER","C:\Users\Administrator\Desktop\user0601\")
ClassMethod ExportProjectforSVN(prjName As %String, Directory As %String)
{
	set obj = ##class(%Studio.Project).%OpenId(prjName,0)
	set item = ""
	set itemObj = obj.Items.GetNext(.item)
	while $isobject(itemObj){
		set name = itemObj.Name
		set type = itemObj.Type
		if type = "CLS"{
			set path = Directory_name_".xml"
			d $system.OBJ.Export(name_".cls",path)
			;d $system.OBJ.Export(name_".cls",path,"/exportversion=cache2016.2")
		}
		Set itemObj = obj.Items.GetNext(.item)
	}
}

/// Description:检查工程内所有CacheStorage实体类的%String类型字段,以及对应索引的Exact属性
/// Input:		ProjectName-工程名称;
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckExact("CSSD")
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckExact("DHCSTM")
ClassMethod CheckExact(ProjectName)
{
	k ^||TMP
	s ProjectObj=##class(%Studio.Project).%OpenId(ProjectName,0)
	s Item=""
	s ItemObj=ProjectObj.Items.GetNext(.Item)
	while $isobject(ItemObj){
		s ClassName=ItemObj.Name
		s Type=ItemObj.Type
		i Type="CLS" d CheckClassProperty(ClassName)
		
		s ItemObj=ProjectObj.Items.GetNext(.Item)
	}
	
	
CheckClassProperty(ClassName)
	s ClassObj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	
	s Properties=##class(%Dictionary.CompiledProperty).%New()
	s Properties=ClassObj.Properties
	s StorageStrategy=ClassObj.StorageStrategy
	s Super=ClassObj.Super
	;Super = "%Library.Persistent,User.Abstract"
	;q:Super'["%Library.Persistent"
	
	s Storages=ClassObj.Storages
	s StorageCount=Storages.Count()
	;i (StorageCount=0)&&(Super["%Library.Persistent") w "Persistent不符:"_ClassName,!
	;i (StorageCount>0)&&(Super'["%Library.Persistent") w "Persistent不符:"_ClassName,!
	q:StorageCount=0				;没有Storage的,不做检查
	
	;检查CacheStorage的个数
	s CacheCount=0
	f i=1:1:StorageCount d
	.s Storage=##class(%Dictionary.CompiledStorage).%New()
	.s Storage=Storages.GetAt(i)
	.s StorageType=Storage.Type
	.
	.;q:StorageType="%Library.CacheSQLStorage"			;SQLStorage不做判断
	.q:StorageType'="%Library.CacheStorage"
	.s CacheCount=CacheCount+1
	q:CacheCount=0
	
	;w ClassName,!
	;q
	
	s Count=Properties.Count()
	f i=1:1:Count d
	.s PropertyObj=##class(%Library.CompiledProperty).%New()
	.s Parameters=##class(%Collection.ArrayOfDT).%New()
	.s PropertyObj=Properties.GetAt(i)		;%Library.CompiledProperty
	.
	.s Name=PropertyObj.Name
	.s Type=PropertyObj.Type
	.s Parameters=PropertyObj.Parameters
	.;q:Type'="%Library.String"
	.
	.s COLLATION=Parameters.GetAt("COLLATION")
	.
	.i (Type="%Library.String")&&(COLLATION'="Exact") w ClassName_"   "_Name_"   "_COLLATION,! q
	.
	.;Exact类型的字段名称
	.s ^||TMP(Name)=""
	
	;q	;只检查字段
	
	;找索引
	;"Name:%String,Attributes:%String,Type:%String,PrimaryKey:%Integer,Unique:%Integer"
	s ResultSet=##class(%ResultSet).%New("%Library.CompiledClass:IndexInfo")
	d ResultSet.Execute(ClassName)
	While(ResultSet.Next())
	{
		s IndexName=ResultSet.Data("Name")
		s Attributes=ResultSet.Data("Attributes")
		s IndexType=ResultSet.Data("Type")
		continue:IndexType'="index"
		;w IndexType_","_IndexName_","_Attributes,!
		
		s Len=$l(Attributes,",")
		f i=1:1:Len d
		.s Attribute=$p(Attributes,",",i)
		.s PropertyName=Attribute	;索引节点(字段)
		.s ExactFlag="N"			;是否含有Exact
		.i Attribute[":" d
		..s PropertyName=$p(Attribute,":",1)
		..s Exact=$p(Attribute,":",2)
		..i Exact="Exact" s ExactFlag="Y"
		.
		.;索引多Exact不行, 少也不行
		.i $d(^||TMP(PropertyName))&&(ExactFlag="N") d
		..w ClassName_"   "_IndexName_"   "_PropertyName,!
		.i '$d(^||TMP(PropertyName))&&(ExactFlag="Y") d
		..w ClassName_"   "_IndexName_"   "_PropertyName,!
	}
}

/// Description:检查工程内所有CacheStorage索引中Exact与global的匹配情况
/// 			检查出的数据,可单独按索引名称重新生成, 比如:
/// 			d ##class(User.CSSDPackageSterilize).%BuildIndices($lb("IndexCSSDPSParrefLabel"))
/// Input:		ProjectName-工程名称;
/// d ##class(web.DHCSTMHUI.Tools.UtilTools).CheckIndexGlobalExact("CSSD")
ClassMethod CheckIndexGlobalExact(ProjectName)
{
	k ^||TMP
	s ProjectObj=##class(%Studio.Project).%OpenId(ProjectName,0)
	s Item=""
	s ItemObj=ProjectObj.Items.GetNext(.Item)
	while $isobject(ItemObj){
		s ClassName=ItemObj.Name
		s Type=ItemObj.Type
		
		i Type="CLS" d CheckClassExact(ClassName)
		
		s ItemObj=ProjectObj.Items.GetNext(.Item)
	}
	zw ^||TMP
	k ^||TMP
	
CheckClassExact(ClassName)
	s ClassObj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	
	s Properties=##class(%Dictionary.CompiledProperty).%New()
	s Properties=ClassObj.Properties
	s StorageStrategy=ClassObj.StorageStrategy
	s Super=ClassObj.Super
	
	s Storages=ClassObj.Storages
	s StorageCount=Storages.Count()
	q:StorageCount=0				;没有Storage的,不做检查
	
	;检查CacheStorage的个数
	s CacheCount=0
	f i=1:1:StorageCount d
	.s Storage=##class(%Dictionary.CompiledStorage).%New()
	.s Storage=Storages.GetAt(i)
	.s StorageType=Storage.Type
	.
	.q:StorageType'="%Library.CacheStorage"
	.s CacheCount=CacheCount+1
	q:CacheCount=0
	
	;找索引
	;"Name:%String,Attributes:%String,Type:%String,PrimaryKey:%Integer,Unique:%Integer"
	s ResultSet=##class(%ResultSet).%New("%Library.CompiledClass:IndexInfo")
	d ResultSet.Execute(ClassName)
	While(ResultSet.Next())
	{
		s IndexName=ResultSet.Data("Name")
		s Attributes=ResultSet.Data("Attributes")
		s IndexType=ResultSet.Data("Type")
		continue:IndexType'="index"
		
		k ExactFlagArr				;Exact标记的数组
		s Len=$l(Attributes,",")
		f i=1:1:Len d
		.s Attribute=$p(Attributes,",",i)
		.s PropertyName=Attribute	;索引节点(字段)
		.
		.s ExactFlag="N"			;是否含有Exact
		.i Attribute[":" d
		..s PropertyName=$p(Attribute,":",1)
		..s Exact=$p(Attribute,":",2)
		..i Exact="Exact" s ExactFlag="Y"
		.
		.s ExactFlagArr(i)=ExactFlag
		
		s GlboalName="^"_ClassName_"I"
		
		;这里写法low一点, 目前没有超过4层的索引
		s Sub1=""
		f  s Sub1=$o(@GlboalName@(IndexName,Sub1)) q:Sub1=""  d
		.i (ExactFlagArr(1)="Y")&&($e(Sub1,1)=" ") s ^||TMP(ClassName_","_IndexName)=""
		.i (ExactFlagArr(1)="N")&&($e(Sub1,1)'=" ") s ^||TMP(ClassName_","_IndexName)=""
		.
		.q:Len<2
		.s Sub2=""
		.f  s Sub2=$o(@GlboalName@(IndexName,Sub1,Sub2)) q:Sub2=""  d
		..i (ExactFlagArr(2)="Y")&&($e(Sub2,1)=" ") s ^||TMP(ClassName_","_IndexName)=""
		..i (ExactFlagArr(2)="N")&&($e(Sub2,1)'=" ") s ^||TMP(ClassName_","_IndexName)=""
		..
		..q:Len<3
		..s Sub3=""
		..f  s Sub3=$o(@GlboalName@(IndexName,Sub1,Sub2,Sub3)) q:Sub3=""  d
		...i (ExactFlagArr(3)="Y")&&($e(Sub3,1)=" ") s ^||TMP(ClassName_","_IndexName)=""
		...i (ExactFlagArr(3)="N")&&($e(Sub3,1)'=" ") s ^||TMP(ClassName_","_IndexName)=""
		...
		...q:Len<4
		...s Sub4=""
		...f  s Sub4=$o(@GlboalName@(IndexName,Sub1,Sub2,Sub3,Sub4)) q:Sub4=""  d
		....i (ExactFlagArr(4)="Y")&&($e(Sub4,1)=" ") s ^||TMP(ClassName_","_IndexName)=""
		....i (ExactFlagArr(4)="N")&&($e(Sub4,1)'=" ") s ^||TMP(ClassName_","_IndexName)=""
		
	}
}

}
