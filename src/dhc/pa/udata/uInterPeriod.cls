/// Creator: 李明忠
/// CreatDate: 2010-11-11
/// Description: 接口期间设置
Class dhc.pa.udata.uInterPeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-11-11
/// Description: 取出Combobox所需要的有效接口套
/// Table：dhc_nca_inter.InterPeriod
/// Input：start-开始记录位置;limit-记录条数;str-模糊查询字段
/// Output：
/// Return：有效接口套字符串
/// Others：w ##class(dhc.pa.udata.uInterPeriod).GetLocSet(0,10,"")
ClassMethod GetLocSet(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select InterLocSet_rowid,InterLocSet_name from dhc_pa_inter.InterLocSet where %ID>0 and InterLocSet_active='Y'"
	i str'="" s sqlStr = sqlStr_" and InterLocSet_shortcut LIKE '"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("InterLocSet_rowid")
		s name = result.Data("InterLocSet_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator:李明忠
/// CreatDate:2010-11-11
/// Description:查询接口期间记录
/// Table:dhc_nca_inter.InterPeriod
/// Input:locSetDr-接口套rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uInterPeriod).List(1,"","","rowid","ASC",0,25)
ClassMethod List(locSetDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (locSetDr,searchField,searchValue,sortField,sortDir,start,limit)

	s sqlStr="select InterPeriod_rowid,InterPeriod_period,InterPeriod_periodType,InterPeriod_inLocSetDr,InterPeriod_quote,InterPeriod_startDate,InterPeriod_endDate,InterPeriod_remark,InterPeriod_active,InterPeriod_corrType from dhc_pa_inter.InterPeriod where %ID>0 and InterPeriod_inLocSetDr='"_locSetDr_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterPeriod_rowid"
	.i sortField="period" s sortField1="InterPeriod_period"
	.i sortField="periodTypeName" s sortField1="InterPeriod_periodType"
	.i sortField="inLocSetName" s sortField1="InterPeriod_inLocSetDr"
	.i sortField="quote" s sortField1="InterPeriod_quote"
	.i sortField="startDate" s sortField1="InterPeriod_startDate"
	.i sortField="endDate" s sortField1="InterPeriod_endDate"
	.i sortField="remark" s sortField1="InterPeriod_remark"
	.i sortField="active" s sortField1="InterPeriod_active"
	.i sortField="corrTypeName" s sortField1="InterPeriod_corrType"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^periodType^periodTypeName^locSetDr^locSetName^quote^quoteName^startDate^endDate^remark^active^corrType^corrTypeName"
	
	While(result.Next()){
		//集体初始化
		s locSetName="",periodTypeName="",quoteName="",corrTypeName=""
		
		s rowid=result.Data("InterPeriod_rowid")
		s period=result.Data("InterPeriod_period")
		
		//期间类型
		s periodType=result.Data("InterPeriod_periodType")
		i periodType="M" s periodTypeName="月"
		i periodType="Q" s periodTypeName="季"
		i periodType="Y" s periodTypeName="年"
		i periodType="H" s periodTypeName="半年"
		
		//接口套
		s locSetDr=result.Data("InterPeriod_inLocSetDr")
		i locSetDr'="" d
		.i $D(^DHCCJXPAINTERLOCSET(locSetDr)) d
		..i $G(^DHCCJXPAINTERLOCSET(locSetDr))'="" d
		...s locSetName=$P(^DHCCJXPAINTERLOCSET(locSetDr),"^",3)
		
		//期间引用
		s quote=result.Data("InterPeriod_quote")
		i quote'="" d 
		.;说明是rowid对照
		.i locSetDr'="" d
		..s quoteName=..GetQuoteName(locSetDr,quote)
		
		s startDate=result.Data("InterPeriod_startDate")
		i startDate'="" s startDate=##class(websys.Conversions).DateLogicalToHtml(startDate) ;$ZD(startDate,3)
		s endDate=result.Data("InterPeriod_endDate")
		i endDate'="" s endDate=##class(websys.Conversions).DateLogicalToHtml(endDate) ;$ZD(endDate,3)
		
		s remark=result.Data("InterPeriod_remark")
		s active=result.Data("InterPeriod_active")
		
		s corrType=result.Data("InterPeriod_corrType")
		i corrType="R" s corrTypeName="ID对照"
		i corrType="I" s corrTypeName="区间对照"
		
		s tmp=rowid_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_locSetDr_"^"_locSetName_"^"_quote_"^"_quoteName_"^"_startDate_"^"_endDate_"^"_remark_"^"_active_"^"_corrType_"^"_corrTypeName
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "period")&(period'[searchValue)
		.q:(searchField = "periodTypeName")&(periodTypeName'[searchValue)
		.q:(searchField = "startDate")&(startDate'[searchValue)
		.q:(searchField = "endDate")&(endDate'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-11-11
/// Description: 根据传入的参数获取引用期间名称
/// Table：
/// Input：locSetDr-接口套Dr;quote-引用期间的rowid对照
/// Output：
/// Return：引用期间名称
/// Others：w ##class(dhc.pa.udata.uInterPeriod).GetQuoteName(2,"1-2-3")
ClassMethod GetQuoteName(locSetDr, quote) As %String
{
	n (locSetDr,quote)
	
	s QuoteName="",locSetName=""
	
	i $D(^DHCCJXPAINTERLOCSET(locSetDr)) d
	.i $G(^DHCCJXPAINTERLOCSET(locSetDr))'="" d
	..s locSetName=$P($G(^DHCCJXPAINTERLOCSET(locSetDr)),"^",3)
	
	i locSetName="成本核算系统" s QuoteName=..GetCAQuoteName(quote) //成本系统
	
	q QuoteName
}

/// Creator：李明忠
/// CreatDate：2010-11-12
/// Description: 获取成本核算系统引用期间名称
/// Table：dhc_ca_cache_data.AccountMonths
/// Input：quote-期间引用的rowid对照
/// Output：
/// Return：成本核算系统引用期间名称
/// Others：w ##class(dhc.pa.udata.uInterPeriod).GetCAQuoteName("1-2-3")
ClassMethod GetCAQuoteName(quote) As %String
{
	n (quote)
	
	q:quote="" "暂时没有数据"
	
	s CAQuoteName=""
	s Length=$L(quote,"-")
	
	f i=1:1:Length d
	.s CAMonthDr=$P(quote,"-",i)
	.s CAMonthName=""
	.i CAMonthDr'="" d
	..i $D(^DHCCAACCOUNTMONTHS(CAMonthDr)) d
	...i $G(^DHCCAACCOUNTMONTHS(CAMonthDr))'="" d
	....s CAMonthName=$P($G(^DHCCAACCOUNTMONTHS(CAMonthDr)),"^",2)
	..i CAQuoteName="" d
	...s CAQuoteName=CAMonthName
	..e  d
	...s CAQuoteName=CAQuoteName_"-"_CAMonthName
	
	q CAQuoteName
}

/// Creator：李明忠
/// CreatDate：2010-11-12
/// Description: 取出Combobox所需要的引用期间
/// Table：
/// Input：locSetDr-接口套记录rowid;start-开始记录位置;limit-记录条数;
/// Output：
/// Return：有效引用期间字符串
/// Others：w ##class(dhc.pa.udata.uInterPeriod).GetQuote(2,0,10)
ClassMethod GetQuote(locSetDr, start, limit) As %String
{
	n (locSetDr,start,limit)
	
	s resultString="",locSetName=""
	
	i $D(^DHCCJXPAINTERLOCSET(locSetDr)) d
	.i $G(^DHCCJXPAINTERLOCSET(locSetDr))'="" d
	..s locSetName=$P($G(^DHCCJXPAINTERLOCSET(locSetDr)),"^",3)
	
	i locSetName="成本核算系统" s resultString=..GetCAQuote(start,limit) //成本系统
	
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-11-12
/// Description: 取出绩效考核系统对成本核算系统的引用期间
/// Table：dhc_ca_cache_data.AccountMonths
/// Input：start-开始记录位置;limit-记录条数;
/// Output：
/// Return：有效引用期间字符串
/// Others：w ##class(dhc.pa.udata.uInterPeriod).GetCAQuote(0,10)
ClassMethod GetCAQuote(start, limit) As %String
{
	n (start,limit)
	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select AccountMonths_rowid,AccountMonths_name from dhc_ca_cache_data.AccountMonths where %ID>0 and AccountMonths_rowid>54 order by AccountMonths_rowid desc"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid=result.Data("AccountMonths_rowid")
		s name=result.Data("AccountMonths_name")
	
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}

	d result.Close()
	s resultString=""
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-11-12
/// Description: 判断接口期间记录是否存在
/// Table：
/// Input：period-绩效期间;periodType-期间类型;locSetDr-接口套
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.pa.udata.uInterPeriod).IfRepRecord("201001","M",1)
ClassMethod IfRepRecord(period, periodType, locSetDr) As %String
{
	n (period,periodType,locSetDr)
		
	s RowId=0
	s RowId=$o(^DHCCJXPAINTERPERIOD(0,"PTPLocSet",period,periodType,locSetDr,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator:李明忠
/// CreatDate:2010-11-12
/// Description:接口期间记录插入
/// Table:dhc_nca_inter.InterPeriod
/// Input:data-接口期间记录字符串,格式:"基础数据类别ID^代码^名称^拼音码^快捷键^备注^有效标志(如:1^101^学历^xl^101-学历^评职称使用^Y)"
/// Output:
/// Return:SQLCODE
/// Others:w ##class(dhc.pa.udata.uInterPeriod).Insert("1^102^学历^xl^101-学历^评职称使用^Y")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s Length=$L(data,"^")
	
	s locSetDr=$P(data,"^",1)
	i locSetDr'="" s PLIST(4)=locSetDr
	
	s period=$P(data,"^",2)
	i period'="" s PLIST(2)=period
	
	s periodType=$P(data,"^",3)
	i periodType'="" s PLIST(3)=periodType
	
	s RowId=""
	s RowId=..IfRepRecord(period,periodType,locSetDr)
	q:RowId'=0 "RepRecord"
	
	s remark=$P(data,"^",4)
	i remark'="" s PLIST(8)=remark
	
	s active="Y"
	i active'="" s PLIST(9)=active
	
	i Length=6 d
	.s quote=$P(data,"^",5)
	.i quote'="" s PLIST(5)=quote
	.s corrType=$P(data,"^",6)
	.i corrType'="" s PLIST(10)=corrType
	e  d
	.s startDate=$P(data,"^",5)
	.i startDate'="" d
	..s startDate=$ZDH(startDate,3)
	..s PLIST(6)=startDate
	.s endDate=$P(data,"^",6)
	.i endDate'="" d
	..s endDate=$ZDH(endDate,3)
	..s PLIST(7)=endDate
	.s corrType=$P(data,"^",7)
	.i corrType'="" s PLIST(10)=corrType
	
	&SQL(INSERT INTO dhc_pa_inter.InterPeriod VALUES PLIST())
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-11-12
/// Description:更新接口期间记录
/// Table: dhc_nca_inter.InterPeriod
/// Input: rowid-接口期间ID; data-待修改数据(baseDataTypeDr^code^name^py^shortcut^remark^active);
/// Output:
/// Return: 如果传入数据为空返回"EmptyData",否则执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterPeriod).Update(7,"2^201001^M^ID对照^Y^1^R")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	k PLIST
	
	s Length=$L(data,"^")
	
	s locSetDr=$P(data,"^",1)
	s PLIST(4)=locSetDr
	
	s period=$P(data,"^",2)
	s PLIST(2)=period
	
	s periodType=$P(data,"^",3)
	s PLIST(3)=periodType
	
	
	s tmpRowId=""
	s tmpRowId=..IfRepRecord(period,periodType,locSetDr)
	q:(tmpRowId'=0)&(tmpRowId'=rowid) "RepRecord"
	
	i Length=7 d
	.s quote=$P(data,"^",6)
	.s PLIST(5)=quote
	.s corrType=$P(data,"^",7)
	.s PLIST(10)=corrType
	e  d
	.s startDate=$P(data,"^",6)
	.i startDate'="" d
	..s startDate=$ZDH(startDate,3)
	..s PLIST(6)=startDate
	.s endDate=$P(data,"^",7)
	.i endDate'="" d
	..s endDate=$ZDH(endDate,3)
	..s PLIST(7)=endDate
	.s corrType=$P(data,"^",8)
	.s PLIST(10)=corrType
	
	s remark=$P(data,"^",4)
	s PLIST(8)=remark
	
	s active=$P(data,"^",5)
	s PLIST(9)=active

	&SQL(UPDATE dhc_pa_inter.InterPeriod VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator: 李明忠
/// CreatDate: 2010-11-11
/// Description: 删除接口期间记录
/// Table：dhc_pa_inter.InterPeriod
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterPeriod).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_inter.InterPeriod WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 初雅莉
/// CreatDate: 2017-2-14
/// Description: 生成接口期间
/// Table：dhc_pa_inter.InterPeriod
/// Input：data插入表中的数据  type：生成期间的类型
/// Others: w ##class(dhc.pa.udata.uInterPeriod).autoPeriod("1","M")
ClassMethod autoPeriod(data, type) As %String
{
	n (data,type)
  
  /*根据传入的type类型，生成相对应的期间值
  在循环中，需要替换data中的开始日期和结束日期的内容
  并考虑月份中为2月的数据
        接口套 期间  期间类型  备注  开始时间  结束时间 
  data  1^201801^M^222^2017-02-03^2017-02-10^I
  */
  s retSQLCODE=""
 
  s nowYear=$p($zd($p($h,",",1),3),"-",1)  //2017
  s likeStr="%"_nowYear_"%"
    &sql(SELECT count(*) into:count FROM dhc_pa_inter.InterPeriod
		WHERE InterPeriod_period LIKE :likeStr AND InterPeriod_periodType =:type and InterPeriod_inLocSetDr=:data
  )
  
  if (count=0){
	   s $p(data,"^",7)="I"
	  if (type="M") {
		  for num=1:1:12 {
			 i num<10  s num="0"_num
			 s $p(data,"^",2)=nowYear_num  //期间  
			 s $p(data,"^",3)="M"  //期间类型
			 s $p(data,"^",4)=nowYear_"年"_num _"月"  //备注
			 s $p(data,"^",5)=nowYear_"-"_num_"-01" //每月第一天
			 s $p(data,"^",6)=nowYear_"-"_num_"-"_..getMonthEndDay(num)
			 s retSQLCODE=..Insert(data)
		  }
	  }elseif(type="Q"){  //1-3 一季度  4-6 二季度  7-9  10-12
	  	  s startM=1 //开始月份
		  for num=1:1:4 {
			  s num="0"_num
			  s $p(data,"^",2)=nowYear_num  //期间  
			  s $p(data,"^",3)="Q"  //期间类型
			  s $p(data,"^",4)=nowYear_"年"_num _"季度"  //备注
			  i startM>12 s startM=startM#12
			  i startM<10 s startM="0"_startM
		  	  s $p(data,"^",5)=nowYear_"-"_startM_"-01" 
		  	  s startMN=+startM+2
		  	  i startMN>12 s startMN=startMN#12
		  	  i startMN<10 s startMN="0"_startMN
		  	  s $p(data,"^",6)=nowYear_"-"_startMN_"-"_..getMonthEndDay(startMN)
			  s startM=startM+3
			  s retSQLCODE=..Insert(data)
		}
  
	  }elseif(type="H"){
		  for num=1:1:2 {
			  s num="0"_num
			  s $p(data,"^",2)=nowYear_num  //期间  
			  s $p(data,"^",3)="H"  //期间类型
	  
			  if (num="01"){
				s $p(data,"^",4)=nowYear_"上半年"  //备注
				s $p(data,"^",5)=nowYear_"-"_num_"-01" 
			    s $p(data,"^",6)=nowYear_"-06-30"
			  }elseif(num="02"){
				s $p(data,"^",4)=nowYear_"下半年"  //备注
				s $p(data,"^",5)=nowYear_"-07-01" 
			    s $p(data,"^",6)=nowYear_"-12-31"
			  }
			 s retSQLCODE=..Insert(data)
		}
  
	  }elseif(type="Y"){
		  s $p(data,"^",2)=nowYear_"01"  //期间
		  s $p(data,"^",3)="Y"  //期间类型
		  s $p(data,"^",4)=nowYear_"年"  //备注
		  s $p(data,"^",5)=nowYear_"-01-01"
		  s $p(data,"^",6)=nowYear_"-12-31"
	      s retSQLCODE=..Insert(data)
	  }
 	
  }else{
  	 s retSQLCODE="isExist"
  }
	q retSQLCODE
}

/// Creator: 初雅莉
/// CreatDate: 2017-2-17
/// Description: 确定输入月份的天数
/// Table：
/// Input： mon 月份
/// Others: w ##class(dhc.pa.udata.uInterPeriod).getMonthEndDay("13")
ClassMethod getMonthEndDay(mon) As %String
{
	n (mon)
	s isRun=0
	s nowYear=$p($zd($p($h,",",1),3),"-",1)  //2017
	if ((nowYear#4=0)&&(nowYear#100'=0))||(nowYear#400=0)  s isRun=1  //判断是否为闰年
	s mon=+mon

	if (mon=1)||(mon =3)||(mon=5)||(mon=7)||(mon=8)||(mon=10)||(mon=12){
		s returnStr=31
	}elseif(mon=2)&&(isRun=0) {
		s returnStr=28
	}elseif(mon=2)&&(isRun=1) {
		s returnStr=29
	}else{
		s returnStr=30
	}
	
	q returnStr
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInterPeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
