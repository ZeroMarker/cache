Class DHCWL.util.DirectoryFile Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.util.DirectoryFile).SetPathOS("D:\hello\test\a)
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
	i '##class(%File).Exists(path) d
	.d ##class(%File).CreateDirectoryChain(path)
	i ($g(fileName)'="") d
	.if '(##class(%File).Exists(path_deli_fileName)) d
	..s file=##class(%File).%New(path_deli_fileName)
	..d file.Open("WN")
	..d file.Close()
	.s path=path_deli_fileName
	q path_"||"_deli
}

/// w ##class(DHCWL.util.DirectoryFile).GetTempDir()
ClassMethod GetTempDir() As %String
{
	s version=$ZVERSION
	i version ["Windows" {
		s temp="c:\temp\tempdhcwl\mkpi\"
	}else {
		s temp="/tmp/tempdhcwl/mkpi/"
	}
	;q temp
	s path=..SetPathOS(temp)
	q $p(path,"||")
	
	//s $zt="Error"
	s temp=##class(%File).TempFilename()
	s temp=##class(%File).ParentDirectoryName(temp)
	;q temp
	s path=..SetPathOS(temp)
	q $p(path,"||")
Error
	s version=$ZVERSION
	i version ["Windows" {
		s temp="c:\temp\tempdhcwl\mkpi\"
	}else {
		s temp="/temp/tempdhcwl/mkpi/"
	}
	;q temp
	s path=..SetPathOS(temp)
	q $p(path,"||")
}

}
