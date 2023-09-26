/// 名称: DHCWL.MKPIService.VersionPath
/// 描述: 指标系统后台代码的安装,导入以及版本更新的补丁
/// 编写者：ban
/// 编写日期:2012-07-11
/// 
Class DHCWL.MKPIService.VersionPath Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 版本参数
Parameter KPIVersion = 1.20;

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 返回代码版本
/// Table：        
/// Input：        
/// Output：      
/// Return：       代码版本
/// Others：   
ClassMethod GetCodeVersion() As %String
{
	n
	q ..#KPIVersion
}

/// w ##class(DHCWL.MKPIService.VersionPath).GetVersion()
ClassMethod GetVersion() As %String
{
	s verNode=$o(^DHCWL.MKPI.Version(""),-1)
    s version=1.0
    s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
    q version
}

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 返回当前代码版本
/// Table：        
/// Input：        
/// Output：      
/// Return：       代码版本
/// Others：   
ClassMethod GetCurrentVersion() As %String
{
	n
	s nod=""
	s nod=$o(^DHCWL.MKPI.Version(""),-1)
	q:nod="" ""
	q $g(^DHCWL.MKPI.Version(nod))
}

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 返回历史版本
/// Table：        
/// Input：		   dateTime:日期时间,格式(yyyy-mm-dd hh:mm:ss)        
/// Output：      
/// Return：       代码版本
/// Others：   
ClassMethod GetHistoryVersion(dateTime) As %String
{
	
	n (dateTime)
	q:dateTime="" ""
	s dtCache=$zdth(dateTime,3)
	q:$d(^DHCWL.MKPI.Version(dtCache)) $g(^DHCWL.MKPI.Version(dtCache))
	s dtNod=$o(^DHCWL.MKPI.Version(dtCache),-1) 
	q:dtNod="" ""
	q $g(^DHCWL.MKPI.Version(dtNod))
}

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 指标系统后台程序安装,并写入版本号
/// Table：        
/// Input：        fileDir:安装程序的文件夹路径
/// Output：      
/// Return：       成功返回1,否则返回0
/// Others：   
ClassMethod Install(fileDir) As %Status
{
	n (fileDir)
	s $zt="InstallErr"
	//写入版本信息
	s ^DHCWL.MKPI.Version($h)=..GetCodeVersion()
	s dem=$$GetOSDirDem()
	s fileDir=$$GetOSDir(fileDir,dem)
	;b	//1
	//导入文件夹中的xml
	//DHCWLKPICode.xml
	d ImportFile(fileDir_"DHCWLKPICode.xml",.err)
	i +$g(err)>0  goto InstallErr
	//DHCWLKPICustom.xml
	d ImportFile(fileDir_"DHCWLKPICustom.xml",.err)
	i +$g(err)>0  goto InstallErr
	//DHCWLKPTable.xml
	d ImportFile(fileDir_"DHCWLKPTable.xml",.err)
	i +$g(err)>0  goto InstallErr
	//RunQ.xml
	d ImportFile(fileDir_"RunQ.xml",.err)
	i +$g(err)>0  goto InstallErr
	//编译文件
	d $system.OBJ.CompileProject("DHCWLKPITable")
	;d $system.OBJ.CompileProject("DHCWLBuildData")
	d $system.OBJ.CompileProject("DHCWLKPICode")
	d $system.OBJ.CompileProject("DHCWLKPICustom")
	
	
	q 1
ImportFile(fileName,err)
	n (fileName,err)
	d $system.OBJ.Load(fileName,,.err)
	
	q

InstallErr
	w $ze,!
	w $g(err(1)),!
	
	q 0
GetOSDirDem()
	n
	s os=$system.Version.GetOS()
	q:os="Windows" "\"
		
	q "/" 
	
GetOSDir(fileDir,dem)
	n (fileDir,dem)
	s len=$l(fileDir,dem)
	s last=$p(fileDir,dem,len)
	;b	//2
	q:last="" fileDir	
	q fileDir_dem
}

/// Creator：      lhh
/// CreatDate：    2013-01-09
/// Description:： 指标系统后台程序安装,并写入版本号，从配置文件中获得按照信息，以后升级就不需要维护该方法了。
/// Table：        
/// Input：        fileDir:安装程序的文件夹路径
/// Output：      
/// Return：       成功返回1,否则返回0
/// Others：   
/// w ##class(DHCWL.MKPIService.VersionPath).InstallFromConfig("F:\Work\SVN\指标\发布环境\4.10Beta\InstallPackageCode")
ClassMethod InstallFromConfig(fileDir, config = "config.txt", onlyCompile As %Boolean = 0) As %Status
{
	n (fileDir,config,onlyCompile)
	s $ET="d ##class(DHCWL.MKPIService.VersionPath).InstallError()"
	s wrongFlag=0,%postLineFlag=0,%postStr=""
	//写入版本信息
	;s ^DHCWL.MKPI.Version($h)=..GetCodeVersion()
	s fileInfo=..SetPathOS(fileDir)
	s flag=0
	s path=$p(fileInfo,"||",1),deli=$p(fileInfo,"||",2)
	s filePath=path_deli_config
	s file=##class(%FileCharacterStream).%New()
	s file.Filename=filePath
	;s file=##class(%File).%New(file)
	;s sc=file.Open("R")
	if (file.IsNull()){
		w "打开文件失败："_filePath,!
		q "请检查路径是否正确。目录名称为{安装程序所在位置}\InstallPackageCode。不同的操作系统，路径分隔符不同。"
	}
	s version=$$GetLine()  ;file.ReadLine()
	i version ["Version:"  d
	.s versionNum=$$GetLine()  ;file.ReadLine()
	.s ^DHCWL.MKPI.Version($h)=versionNum
	.s flag=1
	i flag=0 d
	.s line=version
	e  d
	.s line=$$GetLine()  //file.ReadLine()
	q:line="" 1
	s exeCode=""
	f {
		;s line=$$GetLine()
		q:line=""
		;w line,!
		;continue
		i line [ "ImportList:" {
			s exeCode="ImportList:"	
			s line=$$GetLine()		
		}elseif line [ "CompilePackageList:"{
			s exeCode="CompilePackageList:"	
			s line=$$GetLine()		
		}elseif line [ "ComplieOtherList:"{
			s exeCode="ComplieOtherList:"
			s line=$$GetLine()	
		}
		s sc=1
		i exeCode="ImportList:" {
			s:onlyCompile=0 sc=$system.OBJ.Load(path_deli_line,,.err)
		}elseif exeCode="CompilePackageList:" {
			s sc=$system.OBJ.CompilePackage(line)
		}elseif exeCode="ComplieOtherList:" {
			s sc=$system.OBJ.CompileList(line)
		}
		if $$$ISERR(sc){ 
			d $system.OBJ.DisplayError(sc)
			s wrongFlag=1
			q
		}
		s line=$$GetLine()
	}
	if (wrongFlag=0) w "安装成功！"
	else  w "安装失败，请根据错误提示修改正确后再尝试安装"
	q $g(sc)
GetLine()
	s hasReadLine="",defLen=1
	f {
		s hasReadLine=$$ReadLine()
		q:(hasReadLine="")
		continue:($e(hasReadLine,1)="#")
		q:hasReadLine'=""
	}
	q hasReadLine
ReadLine()
	s %pre="",%cur="",%str="",readLen=1
	do {
		s %pre=%cur
		if (%postLineFlag=1) {
			s %cur=%postStr
			s %postLineFlag=0
		}else {
			s %cur=file.Read(.readLen)
		}
		//if ((($ascii(%pre)=13)&&($ascii(%cur)=10))||(($ascii(%pre)=10)&&($ascii(%cur)=13))||(($ascii(%cur)=13))||(($ascii(%cur)=10))){
		if (($ascii(%cur)=13)||($ascii(%cur)=10)){
			s %postStr=file.Read(.readLen)
			if (($ascii(%postStr)=10)||($ascii(%postStr)=13)){
				q
			}else {
				s %postLineFlag=1
				q
			}
		}else{
			s %str=%str_$g(%cur)
		}
	}while('((%cur="")||($ascii(%cur)=-1)))
	q %str
}

ClassMethod InstallError()
{
	w $ze,!
	w $zerror,!
	w $g(err(1)),!	
	q 0
}

/// 根据当前操作系统，将参数中的路径设置成所在系统的路径名。若路径中有文件名则在生成的路径中创建文件。
/// output:返回当前操作系统下的路径和分隔符，用"||"分开。
/// w ##class(DHCWL.MKPIService.VersionPath).SetPathOS("D:/temp/test.xml")
ClassMethod SetPathOS(name... As %List) As %String
{
	n (name)
	s deli="/"
	s version=$ZVERSION
	s path=""
	i version ["Windows" {
		s deli="\"
	}
	s len=$get(name,0)
	f i=1:1:len-1  {
		s:name(i)'[deli path=path_$get(name(i))_deli
	}
	s path=path_$get(name(len))
	i deli="/" d
	.s wrong="\"
	e  d
	.s wrong="/"
	s path2=""
	f i=1:1:$l(path) d
	.i $e(path,i)=wrong  s path2=path2_deli
	.e  s path2=path2_$e(path,i)
	i $p(path2,deli,$l(path2,deli)) ["." d ;若路径中最后一个为文件，则创建该文件。
	.s len=$l(path2,deli)
	.s path=$p(path2,deli,0,len-1),fileName=$p(path2,deli,len)
	e  d
	.s path=path2
	d ##class(%File).CreateDirectoryChain(path)
	i $g(fileName)'=""  d
	.s file=##class(%File).%New(path_deli_fileName)
	.d file.Open("WN")
	.d file.Close()
	.s path=path_deli_fileName
	q path_"||"_deli
}

}
