Class web.DHCWL.KPI.KpiIOService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w class(web.DHCWL.KPI.KpiIOService).OutputKpis("12,3,4,5")
ClassMethod OutputKpis(kpiIds, ByRef outStream As %Library.FileBinaryStream) As %String
{
	s path="D:\temp"
	s name="outfile"
	s date=$p($h,","),time=$p($h,",",2)
	s name=name_date_"_"_time_".xml"
	;s ^DHCWLTemp("OutFileList",date,time)=name
	s filePath=##class(DHCWL.MKPIIO.OutputToXML).OutputOfStream(kpiIds,.outStream) ;path,name)
	q filePath
}

ClassMethod SaveForFile(node)
{
	n (node)
	s tempFile=$g(^DHCWL.MKPI.TEMPCONT("TempFileName"))
	i tempFile="" s tempFile="temp.xml"
	s file=##class(%File).%New(tempFile)
	i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
	d file.Open("WN")
	s ind="" f  s ind=$o(^DHCWL.MKPI.TEMPCONT(node,ind)) q:ind=""  d
	.s content=..TrimLeft($g(^DHCWL.MKPI.TEMPCONT(node,ind)))
	.d file.Write(content)
	d file.Close()
	k ^DHCWL.MKPI.TEMPCONT
}

/// 用到global ^DHCWL.MKPI.TEMPCONT来临时存放一个请求的内容
/// w ##class(web.DHCWL.KPI.KpiIOService).SaveParaOfContent("content",1,"Hello")
ClassMethod SaveParaOfContentAutoInde(node, content, isTrim As %Integer = 0) As %String
{
	n (node,content,isTrim)
	q:($g(content)="")||($g(node)="") "无数据"
	i isTrim=1 s content=..TrimLeft(content)
	s index=$o(^DHCWL.MKPI.TEMPCONT(node,""),-1)  ;取当前节点的最大序列号
	s index=+$g(index)+1
	s ^DHCWL.MKPI.TEMPCONT(node,index)=content
	q "ok"
}

ClassMethod SaveParaOfContent(node, content, index, isTrim As %Integer = 0) As %String
{
	n (node,content,index,isTrim)
	q:($g(content)="")||($g(node)="") "无数据"
	i isTrim=1 s content=..Trim(content)
	s ^DHCWL.MKPI.TEMPCONT(node,index)=content
	q "ok"
}

/// w ##class(web.DHCWL.KPI.KpiIOService).TrimLeft(" 			  dd")
ClassMethod GetParaOfContent(node, index As %Integer) As %String
{
	n (node,index)
	q $g(^DHCWL.MKPI.TEMPCONT(node,index))
}

ClassMethod NextContent(node, index As %Integer) As %String
{
	n (node,index)
	;s index=$o(^DHCWL.MKPI.TEMPCONT(node,index))
	q $g(^DHCWL.MKPI.TEMPCONT(node,index))
}

ClassMethod NextAndDeleteContent(node, index As %Integer) As %String
{
	n (node,index)
	;s index=$o(^DHCWL.MKPI.TEMPCONT(node,index))
	s cont=$g(^DHCWL.MKPI.TEMPCONT(node,index))
	k ^DHCWL.MKPI.TEMPCONT(node,index)
	q $g(cont)
}

ClassMethod GetNodeSize(node)
{
	n (node)
	q $o(^DHCWL.MKPI.TEMPCONT(node,""),-1)
}

ClassMethod DeleteContent(node)
{
	n (node)
	k ^DHCWL.MKPI.TEMPCONT(node)
}

/// w ##class(web.DHCWL.KPI.KpiIOService).TrimLeft(" 			  dd")
ClassMethod TrimLeft(content) As %String
{
	n (content)
	s len=$l(content),i=1
	f i=1:1:len {
		s char=$ascii($e(content,i))
		i ((char=13)||(char=10)||(char=9)||(char=32)) continue
		e  q
	}
	;b ;001
	q $e(content,i,len)
}

/// w ##class(web.DHCWL.KPI.KpiIOService).Trim("MKPIFLUpdateDate>"_$c(13,10)_"    <MKPIFLUser>卢晓春</MKPIFLUser>"_$c(13,10)_"  </DHCWL.MKPI.MKPIFL-1>"_$c(13,10)_"  <DHCWL.")
ClassMethod Trim(content) As %String
{
	n (content)
	s len=$l(content),i=1,result=""
	f i=1:1:len {
		s char=$ascii($e(content,i))
		i ((char=13)||(char=10)) continue
		e  s result=result_$e(content,i)
	}
	;b ;001
	q result
}

}
