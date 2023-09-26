Class web.DHCST.Common.Display Extends %RegisteredObject
{

/// Descrition: 数据集转为Json输出,Ext表格
ClassMethod RSToJson(RS, Sort, Dir, Start, Limit, IsNum = "")
{
	s endRow = Start+Limit 	// 结束行
	s startRow=Start+1  	// 开始行
	s pid=##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
	k ^||TMP("DHCST",$ClassName(),pid)
	// 标题
	s dirOrder=1,sortNum="",isCHN=""
	i $zcvt(Dir,"U")="DESC" s dirOrder=-1
	s colNameStr=""
	s colNum=RS.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=RS.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	.i $zcvt(colName,"U")=$zcvt(Sort,"U") s sortNum=i
	s countRecords=0
	While(RS.Next())
	{ 
		s sortVal=""
		s ret=""
		f i=1:1:colNum d
		.s colVal=RS.%GetData(i)
		.i ret="" s ret=colVal
		.e   s ret=ret_"^"_colVal
		.i i=sortNum s sortVal=colVal
		i IsNum="Y" s sortVal=+sortVal
		i sortVal="" s sortVal="ZZZZZZ"
		s countRecords=countRecords+1  //可做索引用
		s ^||TMP("DHCST",$ClassName(),pid,sortVal,countRecords)=ret
	}
	i countRecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson() q ""
	s sortIndex="",count=0
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),pid,sortIndex),dirOrder) q:sortIndex=""  d
	.s indexCnt=""
	.f  s indexCnt=$o(^||TMP("DHCST",$ClassName(),pid,sortIndex,indexCnt),dirOrder) q:indexCnt=""  d
	..s tmpData=^||TMP("DHCST",$ClassName(),pid,sortIndex,indexCnt)
	..s count = count+1
	..q:count<startRow
	..q:count>endRow
	..i count=startRow d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countRecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,colNameStr)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,colNameStr)
	...w ","_retstring
	k ^||TMP("DHCST",$ClassName(),pid)
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	q ""
}

}
