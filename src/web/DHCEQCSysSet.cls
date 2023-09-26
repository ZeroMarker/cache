Class web.DHCEQCSysSet Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 设备系统配置表

Parameter SQLCODE = "SS_RowID";

Parameter SQLDESCRIPTION = "SS_RowID";

Parameter SQLROWID = "SS_RowID";

/*
Query SysSet() As %SQLQuery(ROWSPEC = "TRowID:%String,TValue:%String,TDesc:%String,TRemark:%String,TAddValue:%String,TCode:%String,TRow:%String")
{
SELECT SS_RowID TRowID,
	   SS_Value TValue,
	   SS_Desc TDesc,
	   SS_Remark TRemark,
	   SS_AddValue TAddValue,
	   SS_Code TCode,
	   (SELECT count(SS_RowID)+1 FROM sqluser.DHC_EQCSysSet WHERE SS_RowID<t.SS_RowID and SS_Hidden <> 'Y') AS TRow
FROM sqluser.DHC_EQCSysSet t
where t.SS_Hidden <> 'Y'
}
*/
Query SysSet(gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TValue:%String,TDesc:%String,TRemark:%String,TAddValue:%String,TCode:%String,TRow:%String")
{
}

ClassMethod SysSetExecute(ByRef qHandle As %Binary, gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//CZF0138 2021-04-20
	
	s rowid=0
	d BuildDataGetSysSet
	Quit $$$OK
BuildDataGetSysSet
	f  s rowid=$o(^DHCEQCCode("DHCEQCSysSet",rowid))  quit:rowid=""  d
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCSysSet",rowid,sHospID)'="Y"		//czf 2021-04-20
	.d ResetVariablesGetSysSet
	.s LRowID = rowid	//rowid
	.s LCode=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",1)
	.s LValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2) //值
	.i LCode="990018" s LValue="*****************"		//FTP配置信息要求加密显示
	.s LDesc=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",3) //描述
	.s LRemark=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",4) //备注
	.s LAddValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",5)
	.s LHidden=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",6)
	.q:LHidden="Y"
	.d OutputRowGetSysSet
	quit
OutputRowGetSysSet
   s Data=$lb(LRowID,LValue,LDesc,LRemark,LAddValue,LCode,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetSysSet
	s (LRowID,LValue,LDesc,LRemark,LAddValue,LCode)=""
	quit
}

ClassMethod SysSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SysSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SysSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SysSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
/// w ##class(web.DHCEQCSysSet).SaveData("","","{""TRow"":""1"",""TRowID"":""8"",""TDesc"":""批量设备入库默认折旧方法"",""TValue"":""1"",""TRemark"":""1:平均年限法3:不计提折旧"",""TAddValue"":"""",""TCode"":""301002""}$${""TRow"":""2"",""TRowID"":""14"",""TDesc"":""设备必须验收才能入库的金额"",""TValue"":""100000"",""TRemark"":"""",""TAddValue"":"""",""TCode"":""301003""}$${""TRow"":""3"",""TRowID"":""15"",""TDesc"":""设备单价超过设定需要论证表"",""TValue"":""100000"",""TRemark"":""价格为空，无价格限定"",""TAddValue"":"""",""TCode"":""101001""}$${""TRow"":""4"",""TRowID"":""21"",""TDesc"":""采购申请审核后是否自动生成计划"",""TValue"":""1"",""TRemark"":""0:否1:是"",""TAddValue"":"""",""TCode"":""101002""}$${""TRow"":""5"",""TRowID"":""22"",""TDesc"":""生成计划时是否自动提交计划"",""TValue"":""1"",""TRemark"":""0:否1:是"",""TAddValue"":"""",""TCode"":""102001""}$${""TRow"":""6"",""TRowID"":""24"",""TDesc"":""论证是否必须"",""TValue"":""0"",""TRemark"":""0：不限制1：提示,2：限制死"",""TAddValue"":"""",""TCode"":""101003""}$${""TRow"":""7"",""TRowID"":""25"",""TDesc"":""采购申请总价超过该金额只能走年度申请"",""TValue"":""90000000"",""TRemark"":"""",""TAddValue"":"""",""TCode"":""101005""}$${""TRow"":""8"",""TRowID"":""28"",""TDesc"":""验收设备入库是否需要安装验收通过"",""TValue"":""0"",""TRemark"":""0:不需要 1:需要"",""TAddValue"":"""",""TCode"":""301005""}$${""TRow"":""9"",""TRowID"":""32"",""TDesc"":""设备附加图片存储物理路径"",""TValue"":""/DHCEQ/DHCEQPicture/"",""TRemark"":""D:\\trakcare\\web\\images\\DHCEQPicture\\"",""TAddValue"":"""",""TCode"":""990004""}$${""TRow"":""10"",""TRowID"":""33"",""TDesc"":""设备附加文件存储物理路径"",""TValue"":""/DHCEQ/DHCEQAppendFile/"",""TRemark"":""D:\\trakcare\\web\\images\\DHCEQAppendFile\\"",""TAddValue"":"""",""TCode"":""990005""}$${""TRow"":""11"",""TRowID"":""34"",""TDesc"":""开箱验收设备选择方式"",""TValue"":""0,1,3"",""TRemark"":""0:设备项 1:采购合同 3.计划单 4.协议合同 5.投放合同"",""TAddValue"":"""",""TCode"":""201001""}$${""TRow"":""12"",""TRowID"":""35"",""TDesc"":""入库明细合计显示方式"",""TValue"":""2"",""TRemark"":""0：不显示1：显示在首行2：显示在末行3：显示在其它元素上"",""TAddValue"":"""",""TCode"":""301006""}$${""TRow"":""13"",""TRowID"":""40"",""TDesc"":""打印条码的打印机名称"",""TValue"":""pdfFactory Pro"",""TRemark"":""打印条码的打印机名称"",""TAddValue"":"""",""TCode"":""990002""}$${""TRow"":""14"",""TRowID"":""41"",""TDesc"":""打印设备条码的大标题"",""TValue"":""东华标准版数字化医院"",""TRemark"":""打印设备条码的大标题"",""TAddValue"":"""",""TCode"":""990003""}$${""TRow"":""15"",""TRowID"":""43"",""TDesc"":""批量开箱验收设备录入出厂编号串的提交限制"",""TValue"":""1"",""TRemark"":""0:不限制1：提示2：限制"",""TAddValue"":"""",""TCode"":""201002""}","2","2")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
 	k rowid
	Set $ZT="ERROR"
	s TableName="DHC_EQCSysSet"
 	s ClassName="User.DHCEQCSysSet"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	s SQLCODE=0
	s rows=$l(val,"$$")
	TSTART
	for i = 1:1:rows
  	{
	  	q:SQLCODE'=0
	  	s valList= $Piece(val,"$$",i)
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	  	s rowid=JsonData.TRowID
	  	s BussID=rowid
	  	s Value=JsonData.TValue
	  	s Desc=JsonData.TDesc
	  	s Remark=JsonData.TRemark
	  	s AddValue=JsonData.TAddValue
	  	s Code=JsonData.TCode
	  	
	  	;判断数据是否重复 CZF0138
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCSysSet",rowid,Code_"^"_Value,sHospID)
		s Rowid=$p(RtnInfo,"$",1)		//重复Rowid
		
		k Vale
		if (Rowid="")
		{
			if (rowid'="") 
	 	  	{
		  		s Vale(3)=Value
		  		s Vale(6)=AddValue
		  		s Vale(8)=sHospID
		  		s OperateType="U"
				s OldObject=##Class(User.DHCEQCSysSet).%OpenId(BussID)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		  		&SQL(Update SQLUSER.DHC_EQCSysSet Values :Vale() where SS_RowID = :rowid) 
	  	  	}
	  	  	else
	  	  	{
		  	  	i Code="990051" continue	//是否开启平台医院权限只允许一条
		  	  	s Vale(2)=Code
		  	  	s Vale(3)=Value
		  	  	s Vale(4)=Desc
		  	  	s Vale(5)=Remark
		  		s Vale(6)=AddValue
		  		s Vale(7)="N"
		  		s Vale(8)=sHospID
		  		s OperateType="A"
		  		&SQL(Insert Into SQLUSER.DHC_EQCSysSet Values :Vale()) 
		  	}
		  	q:SQLCODE
		  	s ID=$g(%ROWID)
		}
		else
		{
			q:rowid=""
			q:(rowid'=Rowid)
			s Vale(3)=Value
	  		s Vale(6)=AddValue
	  		s Vale(8)=sHospID
	  		s OperateType="U"
			s OldObject=##Class(User.DHCEQCSysSet).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	  		&SQL(Update SQLUSER.DHC_EQCSysSet Values :Vale() where SS_RowID = :rowid)
	  		q:SQLCODE
	  		s ID=rowid
		}
	  	q:SQLCODE
	  	
  	  	;保存医院对照关系 CZF0138 2021-04-20
		s SQLCODE=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCSysSet",ID,sHospID)
		q:SQLCODE<0
		
		s OldObject=""	//先关闭对象 czf 2021-01-21
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCSysSet).%OpenId(ID))
		i BussID'=""	//更新数据获取更新字段Json串
		{
			s key=""
			For
			{
				s value=FinalObj.GetNext(.key)
				q:key=""
    			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			d ##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		}
    }
    
    i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE
ERROR
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// desc:系统参数整理一次性函数,禁止使用
/// add by lmm 2021-09-24
/// modified by  Myl 20210908 双引号问题修改
/// w ##Class(web.DHCEQCSysSet).UpdateSyssetData("","","^115^0^系统是否启用Https协议^0:否 1:是^^;^116^0^设备分类树是否列表展示^0:分类树 1:分类列表^^;^117^0^入库监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^118^0^转移监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^119^0^退货监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^120^0^减少监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^121^0^报废监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^122^0^折旧监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^123^0^台账监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^124^0^调账监审数据生成方式^0:自动月 1:自动单 2:接口 3:手动^^;^125^0^医院资产设备中，旧设备是否仍粘贴并保留使用旧编号^0:否 1:是^^;^126^0^占用设备编号时间点^0,不占用;1,验收提交;2,验收最终审核;^^;^127^0^生成台帐时间点^0,验收审核;1,入库审核;^^;^128^365^采购计划用到的默认有效时长^填写默认有效天数,默认365天^^;^129^0908^年度采购申请开始时间段(MMDD)^格式(MMDD)^^;","16")
ClassMethod UpdateSyssetData()
{
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_remark='价格为空，无价格限定' where ss_code='101001')
	i SQLCODE q SQLCODE_"^1"  //改备注
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='101004')
	i SQLCODE q SQLCODE_"^2"  //改隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_desc,ss_remark,ss_hidden) values ('101006','采购申请设备名称录入方式','0:放大镜选择模式 1:手工录入模式 2:两种均可','Y'))
	i SQLCODE q SQLCODE_"^3"  //加数据改隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_desc,ss_remark,ss_hidden) values ('101007','采购申请设备型号录入方式','0:放大镜选择模式 1:手工录入模式 2:两种均可','Y'))
	i SQLCODE q SQLCODE_"^4"  //加数据改隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_desc,ss_remark,ss_hidden) values ('102002','计划设备选择方式','0:不用申请 1:必须申请 2:二者都可以','Y'))
	i SQLCODE q SQLCODE_"^5"  //加数据改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_remark='0:招标、设备项 1:计划、招标 2:设备项、计划、招标' where ss_code='103001')
	i SQLCODE q SQLCODE_"^6"  //改备注
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='201003')
	i SQLCODE q SQLCODE_"^7"  //改隐藏
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='301001')
	i SQLCODE q SQLCODE_"^8"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='301004')
	i SQLCODE q SQLCODE_"^9"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302001')
	i SQLCODE q SQLCODE_"^10"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302002')
	i SQLCODE q SQLCODE_"^11"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302003')
	i SQLCODE q SQLCODE_"^12"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302004')
	i SQLCODE q SQLCODE_"^13"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302005')
	i SQLCODE q SQLCODE_"^14"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302006')
	i SQLCODE q SQLCODE_"^15"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302007')
	i SQLCODE q SQLCODE_"^16"  //参数不用
	//这几条数据没有
	//&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302008')
	//i SQLCODE q SQLCODE_"^17"  //参数不用
	//&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302009')
	//i SQLCODE q SQLCODE_"^18"  //参数不用
	//&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='302010')
	//i SQLCODE q SQLCODE_"^19"  //参数不用
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='302011')
	i SQLCODE q SQLCODE_"^20"   //改隐藏
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='401006')
	i SQLCODE q SQLCODE_"^21"  //参数不用
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y',ss_value='0' where ss_code='503001')
	i SQLCODE q SQLCODE_"^22"  //改隐藏，默认0
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_value='2' where ss_code='503004')
	i SQLCODE q SQLCODE_"^23"  //默认2
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='601001')
	i SQLCODE q SQLCODE_"^24"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='601002')
	i SQLCODE q SQLCODE_"^25"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='901001')
	i SQLCODE q SQLCODE_"^26"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='901002')
	i SQLCODE q SQLCODE_"^27"  //改隐藏
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='901003')
	i SQLCODE q SQLCODE_"^28"  //参数不用
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_value='/DHCEQPicture/' where ss_code='990004')
	i SQLCODE q SQLCODE_"^29"  //改默认
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='N' where ss_code='990005')
	i SQLCODE q SQLCODE_"^30"  //不隐藏
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='990006')
	i SQLCODE q SQLCODE_"^31"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='990007')
	i SQLCODE q SQLCODE_"^32"  //参数不用
	&SQL(delete from SQLUSER.DHC_EQCSysSet where ss_code='990008')
	i SQLCODE q SQLCODE_"^33"  //参数不用
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990012')
	i SQLCODE q SQLCODE_"^34"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990013')
	i SQLCODE q SQLCODE_"^35"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_value='1' where ss_code='990014')
	i SQLCODE q SQLCODE_"^36"  //默认1
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990015')
	i SQLCODE q SQLCODE_"^37"  //改隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990021','0','预报废设备不计提折旧','0计提折旧 1不计提折旧','Y'))
	i SQLCODE q SQLCODE_"^38"  //加数据，默认0，隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990022','1','盘点是否包含预报废设备','0包含 1不包含','N'))
	i SQLCODE q SQLCODE_"^39"  //加数据，默认1，不隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990025')
	i SQLCODE q SQLCODE_"^40"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990026')
	i SQLCODE q SQLCODE_"^41"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_value='1' where ss_code='990038')
	i SQLCODE q SQLCODE_"^42"  //默认1
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y',ss_value='1,2' where ss_code='990041')
	i SQLCODE q SQLCODE_"^43"  //改隐藏，默认1,2
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990047')
	i SQLCODE q SQLCODE_"^44"  //改隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_hidden) values ('990048','5','微信身份验证失败限制次数','N'))
	i SQLCODE q SQLCODE_"^45"  //加数据，默认5，不隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y' where ss_code='990049')
	i SQLCODE q SQLCODE_"^46"  //改隐藏
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y',ss_value=NULL where ss_code='990053')
	i SQLCODE q SQLCODE_"^47"  //改隐藏，默认空
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y',ss_value='1' where ss_code='990056')
	i SQLCODE q SQLCODE_"^48"  //改隐藏，默认1
	&SQL(update SQLUSER.DHC_EQCSysSet set ss_hidden='Y',ss_value='0' where ss_code='990057')
	i SQLCODE q SQLCODE_"^49"  //改隐藏,默认0
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990058','0','入库时资金来源是否允许修改','0:否 1:是','N'))
	i SQLCODE q SQLCODE_"^50"  //加数据，默认0，不隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990059','1','工作台维修审批进度是否显示下一部审批','0:否 1:是','N'))
	i SQLCODE q SQLCODE_"^51"  //加数据，默认1，不隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_desc,ss_remark,ss_hidden) values ('990060','不计提折旧的设备来源','添加来源的ID串，以","分割','Y'))
	i SQLCODE q SQLCODE_"^52"  //加数据，默认空，隐藏
	&SQL(insert into SQLUSER.DHC_EQCSysSet (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990061','0','折旧计提依据的日期','空或0:转资日期 1:启用日期， 一般默认为0，根据转资日期计提折旧','Y'))
	i SQLCODE q SQLCODE_"^53"  //加数据，默认0，隐藏
}

/// CZF0138 2021-05-24
ClassMethod UpdateFtpServer(ftpserver, ftpuser, ftppassword, ftpport, SSRowID As %String = "")
{
	i SSRowID'="" s FtpInfo=$p($g(^DHCEQCCode("DHCEQCSysSet",SSRowID)),"^",2)
	e  d
	.s SSRowID=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code","990018",0))
	.Set FtpInfo=##class(web.DHCEQCommon).GetSysInfo("990018")
	
	i ftppassword'=$p(FtpInfo,"&",3) s ftppassword=##Class(web.Util.Encryption).SimpleEncrypt(ftppassword,"DHCEQ")
	s ftpInfo=ftpserver_"&"_ftpuser_"&"_ftppassword_"&"_ftpport
	&SQL(Update SQLUSER.DHC_EQCSysSet Set SS_Value=:ftpInfo Where SS_RowID=:SSRowID)
	q SQLCODE
}

}
