/// 名称: 报表数据保存
/// 描述: 各类报表数据保存与读取
/// 编写者：许立新
/// 编写日期:2010-3-25
Class dhc.ca.cache.udata.uReportResult Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：许立新
/// CreatDate：2010-3-25
/// Description: 报表数据写入
/// Table：dhc_ca_cache_data.ReportResult
/// Input：repType-报表类别,intervalDr-核算周期,distSetDr-分摊方法套,dataSetDr-数据分层套,data-数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.udata.uReportResult).Insert("报表类别",1,2,3,"4^科室名称^5^6^科室类别^项目名称^7^8^项目类别^数据类别^9a^10b")
ClassMethod Insert(repType, intervalDr, distSetDr, dataSetDr, data) As %String
{
	n (repType,intervalDr,distSetDr,dataSetDr,data)
	
	//报表类别^核算周期^分摊方法套^数据分层套
	//金额^科室名称^科室层级^科室顺序^科室类别^项目名称^项目层级^项目顺序^项目类别^数据类别^数据类别^科室Dr^项目Dr^来源科室名称^来源科室Dr^来源科室类别名称^来源科室类别Dr^来源科室类别排序
	//s data="报表类别^1^2^3^4^科室名称^5^6^科室类别^项目名称^7^8^项目类别^数据类别^9^10^来源科室名称^11^来源科室类别名称^12^13"
	
	k PLIST
	
	i repType'="" s PLIST(2)=repType               //报表类别
	i intervalDr'="" s PLIST(3)=intervalDr         //核算周期
	i distSetDr'="" s PLIST(4)=distSetDr           //分摊方法套
	i dataSetDr'="" s PLIST(5)=dataSetDr           //数据分层套
	
	s fee=$p(data,"^",1)
	i fee'="" s PLIST(6)=fee                       //金额
	
	s deptName=$p(data,"^",2)
	i deptName'="" s PLIST(7)=deptName             //科室名称
	
	s deptLayer=$p(data,"^",3)
	i deptLayer'="" s PLIST(8)=deptLayer           //科室层级
	
	s deptOrder=$p(data,"^",4)
	i deptOrder'="" s PLIST(9)=deptOrder           //科室顺序
	
	s deptType=$p(data,"^",5)
	i deptType'="" s PLIST(10)=deptType             //科室类别
	
	s itemName=$p(data,"^",6)
	i itemName'="" s PLIST(11)=itemName            //项目名称
	
	s itemLayer=$p(data,"^",7)
	i itemLayer'="" s PLIST(12)=itemLayer          //项目层级
	
	s itemOrder=$p(data,"^",8)
	i itemOrder'="" s PLIST(13)=itemOrder          //项目顺序
	
	s itemType=$p(data,"^",9)
	i itemType'="" s PLIST(14)=itemType            //项目类别
	
	s dataType=$p(data,"^",10)
	i dataType'="" s PLIST(15)=dataType            //项目类别
	
	s deptDr=$p(data,"^",11)
	i deptDr'="" s PLIST(16)=deptDr                //科室Dr
	
	s itemDr=$p(data,"^",12)
	i itemDr'="" s PLIST(17)=itemDr                //项目Dr
	
	s FDName=$p(data,"^",13)
	i FDName'="" s PLIST(18)=FDName                //来源科室名称
	
	s FDDr=$p(data,"^",14)
	i FDDr'="" s PLIST(19)=FDDr                    //来源科室Dr
	
	s FDTName=$p(data,"^",15)
	i FDTName'="" s PLIST(20)=FDTName              //来源科室类别名称
	
	s FDTDr=$p(data,"^",16)
	i FDTDr'="" s PLIST(21)=FDTDr                  //来源科室类别Dr
	
	s FDTOrder=$p(data,"^",17)
	i FDTOrder'="" s PLIST(22)=FDTOrder            //来源科室类别排序
	
	&SQL(INSERT INTO dhc_ca_cache_data.ReportResult VALUES PLIST())
	
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-3-25
/// Description: 报表数据删除
/// Table：dhc_ca_cache_data.ReportResult
/// Input：repType-报表类别,intervalDr-核算周期,distSetDr-分摊方法套,dataSetDr-数据分层套
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.udata.uReportResult).Delete("报表类别",1,2,3)
ClassMethod Delete(repType, intervalDr, distSetDr, dataSetDr) As %String
{
	n (repType, intervalDr, distSetDr, dataSetDr)
	
	&SQL(DELETE FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType=:repType AND ReportResult_intervalDr=:intervalDr AND ReportResult_distSetDr=:distSetDr AND ReportResult_dataSetDr=:dataSetDr)
	
	q SQLCODE
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(dhc.ca.cache.udata.uReportResult).GetCNCODE("东华",4,"^")
/// w ##class(dhc.ca.cache.udata.uReportResult).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uReportResultS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
