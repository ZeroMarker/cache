/// add by zy ZY0133 2015-6-10  
/// 根据吉大三院新卫计委的需求写的接口;
Class web.DHCEQ.Interface.DHCEQForWJW Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter SAASDM = 401704017;

// add by zc0128 2023-01-17 增加组织机构号

/// add by zy 2015-6-10
/// 固定资产信息表
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03
/// output:				
///     	BATCH_NUM			VARCHAR2(64)	不填	批次号
///     	UPLOAD_TIME			VARCHAR2(14)	不填	系统上传时间
///     	RESULTDESC			VARCHAR2(4000)	不填	处理结果描述
///     	RESULTCODE			VARCHAR2(8)	不填	处理结果代码
///     	SERIALNUM_ID		VARCHAR2(40)	不填	流水号
///     	UNIQUEID			VARCHAR2(64)	必填	文档唯一 ID
///     	BUSINESS_RELATION_ID	VARCHAR2(30)	不填	业务关联 ID
///     	BUSINESS_ACTIVE_TYPE	VARCHAR2(30)	不填	业务活动类别
///     	BUSINESS_ACTIVE_DES		VARCHAR2(100)	不填	业务活动类别描述
///     	BUSINESS_ID				VARCHAR2(100)	必填	业务流水号
///     	BASIC_ACTIVE_TYPE		VARCHAR2(50)	不填	基本活动类别
///     	BASIC_ACTIVE_DES		VARCHAR2(100)	不填	基本活动类别描述
///     	BASIC_ACTIVE_ID		VARCHAR2(100)	必填	基本活动流水号
///     	ORGANIZATION_CODE	VARCHAR2(50)	必填	组织机构代码
///     	ORGANIZATION_NAME	VARCHAR2(70)	必填	组织机构名称
///     	DOMAIN_CODE			VARCHAR2(30)	必填	域代码
///     	DOMAIN_NAME			VARCHAR2(100)	必填	域名称
///     	VER					VARCHAR2(50)	不填	版本号
///     	VERDES				VARCHAR2(100)	不填	版本描述
///     	REGION_IDEN			VARCHAR2(30)	必填	地区标识
///     	DATA_SECURITY		VARCHAR2(5)	不填	数据密级
///     	RECORD_IDEN			VARCHAR2(30)	必填	记录标识
///     	CREATE_DATE			VARCHAR2(14)	不填	新建时间
///     	UPDATE_DATE			VARCHAR2(14)	不填	更新时间
///     	DATAGENERATE_DATE	VARCHAR2(15)	必填	业务数据产生时
///     	AP08_50_100_00		VARCHAR2(100)	必填	固定资产卡片号
///     	AP08_50_101_01		VARCHAR2(10)	必填	卡片状态代码
///     	AP08_50_101_02		VARCHAR2(100)	必填	卡片状态
///     	AP08_50_102_01		VARCHAR2(10)	必填	固定资产所在位置类型代码
///     	AP08_50_102_02		VARCHAR2(100)	必填	固定资产所在位置类型
///     	AP08_50_103_00		VARCHAR2(100)	必填	固定资产名称
///     	AP08_50_104_01		VARCHAR2(10)	必填	大型设备管理类别代码
///     	AP08_50_104_02		VARCHAR2(100)	必填	大型设备管理类别
///     	AP08_50_105_00		VARCHAR2(100)		甲乙类设备资产许可证号
///     	AP08_50_106_01		VARCHAR2(20)	必填	固定资产分类代码
///     	AP08_50_106_02		VARCHAR2(100)	必填	固定资产分类
///     	AP08_50_107_00		VARCHAR2(700)	必填	规格
///     	AP08_50_108_00		VARCHAR2(700)	必填	型号
///     	AP08_50_109_00		VARCHAR2(100)	必填	计量单位
///     	AP08_50_110_00		VARCHAR2(700)		品牌
///     	AP08_50_111_00		VARCHAR2(700)		生产厂家
///     	AP08_50_112_00		VARCHAR2(8)		出厂日期
///     	AP02_01_126_01		VARCHAR2(100)		固定资产产地国籍编码
///     	AP02_01_126_02		VARCHAR2(700)		固定资产产地国籍
///     	AP08_50_113_00		VARCHAR2(700)		设备序列号
///     	AP08_50_114_00		VARCHAR2(700)		采购流水号
///     	AP08_50_115_00		VARCHAR2(700)		采购员
///     	AP08_50_116_00		VARCHAR2(700)		供应商名称
///     	AP08_50_117_00		VARCHAR2(100)		采购合同号
///     	AP08_50_118_00		VARCHAR2(50)		固定资产采购单价
///     	AP08_50_119_00		VARCHAR2(8)		是否免税
///     	AP08_50_120_01		VARCHAR2(10)		固定资产采购资金来源代码
///     	AP08_50_120_02		VARCHAR2(100)		固定资产采购资金来源
///     	AP08_50_121_00		VARCHAR2(8)	必填	购买日期
///     	AP08_50_122_00		VARCHAR2(8)		验收日期
///     	AP08_50_123_00		VARCHAR2(100)		验收人
///     	AP08_50_124_00		VARCHAR2(8)	必填	开始使用日期
///     	AP08_50_125_01		VARCHAR2(10)	必填	固定资产性质代码
///     	AP08_50_125_02		VARCHAR2(100)	必填	固定资产性质
///     	AP08_50_126_01		VARCHAR2(10)	必填	固定资产质量等级代码
///     	AP08_50_126_02		VARCHAR2(100)	必填	固定资产质量等级
///     	AP08_50_127_00		VARCHAR2(50)	必填	设备单价
///     	AP08_50_128_00		VARCHAR2(50)	必填	设备原值
///     	AP08_50_129_00		VARCHAR2(50)	必填	设备现值
///     	AP08_50_130_00		VARCHAR2(50)		预计残值
///     	AP08_50_131_00		VARCHAR2(8)		使用年限
///     	AP08_50_132_00		VARCHAR2(8)	必填	是否进口
///     	AP08_50_133_00		VARCHAR2(8)		是否折旧
///     	AP08_50_134_00		VARCHAR2(50)		累计提折旧
///     	AP08_50_135_00		VARCHAR2(8)		是否旧设备
///     	AP08_50_136_00		VARCHAR2(8)	必填	已用年限
///     	AP08_50_137_01		VARCHAR2(10)	必填	固定资产用途分类代码
///     	AP08_50_137_02		VARCHAR2(100)		固定资产用途分类
///     	AP08_50_138_01		VARCHAR2(10)		车辆用途分类代码
///     	AP08_50_138_02		VARCHAR2(100)		车辆用途分类
///     	AP08_50_139_01		VARCHAR2(10)	必填	固定资产使用状态代码
///     	AP08_50_139_02		VARCHAR2(100)	必填	固定资产使用状态
///     	AP08_50_140_00		VARCHAR2(700)		放置地点
///     	AP08_50_141_00		VARCHAR2(8)	必填	是否停用
///     	AP08_50_142_00		VARCHAR2(8)		停用日期
///     	AP08_50_143_00		VARCHAR2(700)		租借合同序号
///     	AP08_50_144_00		VARCHAR2(8)		租借状态
///     	AP08_50_145_00		VARCHAR2(700)		租借单位
///     	AP08_50_146_00		VARCHAR2(8)		租借开始日期
///     	AP08_50_147_00		VARCHAR2(8)		租借结束日期
///     	AP08_50_148_00		VARCHAR2(700)		科室名称
///     	AP08_50_149_01		VARCHAR2(50)	必填	机构代码
///     	AP08_50_149_02		VARCHAR2(700)	必填	机构名称
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","DIRSGFIXEDASSETSINFO","","")
Query DIRSGFIXEDASSETSINFO(sDate As %String, eDate As %String) As %Query(ROWSPEC = "BATCHNUM:%String,UPLOADTIME:%String,RESULTDESC:%String,RESULTCODE:%String,SERIALNUMID:%String,UNIQUEID:%String,BUSINESSRELATIONID:%String,BUSINESSACTIVETYPE:%String,BUSINESSACTIVEDES:%String,BUSINESSID:%String,BASICACTIVETYPE:%String,BASICACTIVEDES:%String,BASICACTIVEID:%String,ORGANIZATIONCODE:%String,ORGANIZATIONNAME:%String,DOMAINCODE:%String,DOMAINNAME:%String,VER:%String,VERDES:%String,REGIONIDEN:%String,DATASECURITY:%String,RECORDIDEN:%String,CREATEDATE:%String,UPDATEDATE:%String,DATAGENERATEDATE:%String,AP085010000:%String,AP085010101:%String,AP085010102:%String,AP085010201:%String,AP085010202:%String,AP085010300:%String,AP085010401:%String,AP085010402:%String,AP085010500:%String,AP085010601:%String,AP085010602:%String,AP085010700:%String,AP085010800:%String,AP085010900:%String,AP085011000:%String,AP085011100:%String,AP085011200:%String,AP020112601:%String,AP020112602:%String,AP085011300:%String,AP085011400:%String,AP085011500:%String,AP085011600:%String,AP085011700:%String,AP085011800:%String,AP085011900:%String,AP085012001:%String,AP085012002:%String,AP085012100:%String,AP085012200:%String,AP085012300:%String,AP085012400:%String,AP085012501:%String,AP085012502:%String,AP085012601:%String,AP085012602:%String,AP085012700:%String,AP085012800:%String,AP085012900:%String,AP085013000:%String,AP085013100:%String,AP085013200:%String,AP085013300:%String,AP085013400:%String,AP085013500:%String,AP085013600:%String,AP085013701:%String,AP085013702:%String,AP085013801:%String,AP085013802:%String,AP085013901:%String,AP085013902:%String,AP085014000:%String,AP085014100:%String,AP085014200:%String,AP085014300:%String,AP085014400:%String,AP085014500:%String,AP085014600:%String,AP085014700:%String,AP085014800:%String,AP085014901:%String,AP085014902:%String") [ SqlProc ]
{
}

ClassMethod DIRSGFIXEDASSETSINFOExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s (BATCHNUM,UPLOADTIME,RESULTDESC,RESULTCODE,SERIALNUMID,UNIQUEID,BUSINESSRELATIONID,BUSINESSACTIVETYPE,BUSINESSACTIVEDES,BUSINESSID,BASICACTIVETYPE,BASICACTIVEDES)=""
	s (BASICACTIVEID,ORGANIZATIONCODE,ORGANIZATIONNAME,DOMAINCODE,DOMAINNAME,VER,VERDES,REGIONIDEN,DATASECURITY,RECORDIDEN,CREATEDATE,UPDATEDATE,DATAGENERATEDATE)=""
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQEquip(rowid))
	.d CheckGetEquipListDIRSGFIXEDASSETSINFO
	.q:passed=0
	.s AP085010000=$p(DataList,"^",71)		//固定资产卡片号
	.s AP085010101="2"						//卡片状态代码
	.s AP085010102="审核"					//卡片状态
	.s AP085010201=""						//固定资产所在位置类型代码
	.s AP085010202=""						//固定资产所在位置类型代码
	.i (Status=0)||(Status=2) d
	..s AP085010201="0"
	..s AP085010202="仓库"
	.e  d  //(Status=1)
	..s AP085010201="1"
	..s AP085010202="科室"
	.s AP085010300=$p(DataList,"^",1)		//固定资产名称
	.s AP085010401="" 						//大型设备管理类别代码1:甲；2：乙；3，其他
	.s AP085010402="" 						//大型设备管理类别    1:甲；2：乙；3，其他
	.s AP085010500="" 						//甲乙类设备资产许可证号
	.s AP085010601=$p(DataList,"^",4)		//固定资产分类代码
	.s AP085010602 = $p($g(^DHCEQCCode("DHCEQCEquipeCat",AP085010601)),"^",1)	////固定资产分类		//固定资产分类
	.s AP085010700=""						//规格
	.s AP085010800=$p(DataList,"^",3)		//型号
	.s AP085010800 = ##Class(web.DHCEQCommon).GetTrakNameByID("model",AP085010800)
	.s AP085010900=$p(DataList,"^",5)		//计量单位
	.s AP085010900 = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",AP085010900)
	.s AP085011000="" 						//品牌
	.s AP085011100=$p(DataList,"^",26)		//生产厂家
	.i AP085011100'="" s AP085011100=$p($g(^DHCEQCCode("DHCEQCManufacturer",AP085011100)),"^",1)
	.s AP085011200=$p(DataList,"^",11)		//出厂日期
	.s AP085011200=##class(web.DHCEQCommon).Replace($ZD(AP085011200,3),"-","")
	.s AP020112601=$p(DataList,"^",16)		//国别
	.s AP020112602=##Class(web.DHCEQCommon).GetTrakNameByID("cou",AP020112601)
	.s AP085011300=""						//设备序列号
	.s AP085011400=""						//采购流水号
	.s AP085011500=""						//采购员
	.s AP085011600=$p(DataList,"^",25)		//供应商名称
	.s AP085011600=##Class(web.DHCEQCommon).GetTrakNameByID("prov",AP085011600)
	.s AP085011700=$p(DataList,"^",76)		//采购合同号
	.s AP085011800=$p(DataList,"^",27)		//固定资产采购单价
	.s AP085011900=""						//是否免税
	.
	.s AP085012001="9"						//固定资产采购资金来源代码 1财政资金,2科研资金,3教学资金,9其他资金
	.s AP085012002="其他资金"						//固定资产采购资金来源
	.s FundsInfo=##Class(web.BMI.DIRSGFIXEDASSETSINFO).GetFundsInfo(rowid)
	.s Len=$L(FundsInfo,",")
	.for i=1:1:Len  d
	..s FundsType=$p(FundsInfo,",",i)
	..s AP085012002=$p(FundsType,"=",1)		//固定资产采购资金来源
	..i AP085012002="财政资金" d
	...s AP085012001="1"
	..e  i AP085012002="科研资金" d
	...s AP085012001="2"
	..e  i AP085012002="教学资金" d
	...s AP085012001="3"
	.
	.s AP085012100=$p(DataList,"^",12)		//购买日期
	.i AP085012100'="" s AP085012100=##class(web.DHCEQCommon).Replace($ZD(AP085012100,3),"-","")
	.s AP085012200=$p(DataList,"^",12)		//验收日期
	.i AP085012200'="" s AP085012200=##class(web.DHCEQCommon).Replace($ZD(AP085012200,3),"-","")
	.s AP085012300=""						//验收人
	.s AP085012400=""						//开始使用日期
	.s AP085012400=$p(DataList,"^",44)		//开始使用日期
	.i AP085012400'="" s AP085012400=##class(web.DHCEQCommon).Replace($ZD(AP085012400,3),"-","")
	.s AP085012501=""						//固定资产性质代码
	.s AP085012502=""						//固定资产性质
	.s AP085012601=""						//固定资产质量等级代码
	.s AP085012602=""						//固定资产质量等级
	.s AP085012700=$p(DataList,"^",27)		//设备单价
	.s AP085012800=$p(DataList,"^",27)		//设备原值
	.s AP085012900=$p(DataList,"^",28)		//设备现值
	.s AP085013000=$p(DataList,"^",29)		//预计残值
	.s AP085013100=$p(DataList,"^",31)		//使用年限
	.s AP085013200="Y" 						//是否进口
	.i (AP020112601="中国")||(AP020112601="") s AP085013200="N"	//是否进口
	.s AP085013300=$p(DataList,"^",33)		////是否折旧
	.i AP085013300'="" s AP085013300=$p($g(^DHCEQCCode("DHCEQCDepreMethod",AP085013300)),"^",2)
	.i AP085013300'="不计提折旧"  d
	..s AP085013300="Y"
	.e  d
	..s AP085013300="N"
	.s AP085013400=$p(DataList,"^",35)		//累计提折旧
	.s AP085013500=""						//是否旧设备
	.s AP085013600=""						//已用年限
	.s AP085013701=$p(DataList,"^",65)		//固定资产用途分类代码 01 一般,02 科研,03 教学, 04 经营
	.s AP085013702=""
	.i AP085013701'="" s AP085013702=$p($g(^DHCEQCCode("DHCEQCPurposeType",AP085013701)),"^",2)	//固定资产用途分类
	.s AP085013801=""						//车辆用途分类代码 1 公务,2医务, 9其他
	.s AP085013802=""						//车辆用途分类
	.i Status=0||Status=2 d 
	..s AP085013901="2"						//固定资产使用状态代码 1：在用，2：在库，3：处置&计提，4：处置完毕，5：闲置，6：在修，7：待处置。
	..s AP085013902="在库"					//固定资产使用状态
	.e  d
	..s AP085013901="1"						
	..s AP085013902="在用"					
	.s AP085014000=$p(DataList,"^",72)		//放置地点
	.i AP085014000'="" s AP085014000=$p($g(^DHCEQCCode("DHCEQCLocation",AP085014000)),"^",2)
	.s AP085014100=""						//是否停用
	.i Status'="1"  d
	..s AP085014100="Y"
	.e  d
	..s AP085014100="N"
	.s AP085014200="" 						//停用日期
	.i AP085014100="Y" s AP085014200=$p(DataList,"^",44) 
	.i AP085014200'="" s AP085014200=##class(web.DHCEQCommon).Replace($ZD(AP085014200,3),"-","")
	.s AP085014300=""						//租借合同序号
	.s AP085014400=""						//租借状态
	.s AP085014500=""						//租借单位
	.s AP085014600=""						//租借开始日期
	.s AP085014700=""						//租借结束日期
	.s AP085014800=$p(DataList,"^",67)		//科室名称
	.s AP085014800=##Class(web.DHCEQCommon).GetTrakNameByID("dept",AP085011600)
	.s AP085014901=""						//机构名称
	.s AP085014902=""						//机构名称
	.d OutputRowDIRSGFIXEDASSETSINFO
	Quit $$$OK
OutputRowDIRSGFIXEDASSETSINFO
	s data=$lb(BATCHNUM,UPLOADTIME,RESULTDESC,RESULTCODE,SERIALNUMID,UNIQUEID,BUSINESSRELATIONID,BUSINESSACTIVETYPE,BUSINESSACTIVEDES,BUSINESSID,BASICACTIVETYPE,BASICACTIVEDES,BASICACTIVEID,ORGANIZATIONCODE,ORGANIZATIONNAME,DOMAINCODE,DOMAINNAME,VER,VERDES,REGIONIDEN,DATASECURITY,RECORDIDEN,CREATEDATE,UPDATEDATE,DATAGENERATEDATE,AP085010000,AP085010101,AP085010102,AP085010201,AP085010202,AP085010300,AP085010401,AP085010402,AP085010500,AP085010601,AP085010602,AP085010700,AP085010800,AP085010900,AP085011000,AP085011100,AP085011200,AP020112601,AP020112602,AP085011300,AP085011400,AP085011500,AP085011600,AP085011700,AP085011800,AP085011900,AP085012001,AP085012002,AP085012100,AP085012200,AP085012300,AP085012400,AP085012501,AP085012502,AP085012601,AP085012602,AP085012700,AP085012800,AP085012900,AP085013000,AP085013100,AP085013200,AP085013300,AP085013400,AP085013500,AP085013600,AP085013701,AP085013702,AP085013801,AP085013802,AP085013901,AP085013902,AP085014000,AP085014100,AP085014200,AP085014300,AP085014400,AP085014500,AP085014600,AP085014700,AP085014800,AP085014901,AP085014902)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
CheckGetEquipListDIRSGFIXEDASSETSINFO
	s passed=1
	s InvalidFlag = $p(DataList,"^",59)
	i InvalidFlag'="N" 	{s passed=0 q}
	s Status = $p(DataList,"^",38)
	i (Status>"2"){s passed=0  q}
	s StockStatus = $p(DataList,"^",60)
	i (StockStatus="0")||((StockStatus="3")) {s passed=0 q}
	s StatCatDR = $p(DataList,"^",75)
	s (AsssetsTypeDR,AsssetsTypeCode)=""
	i StatCatDR'="" s AsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",10)
	i AsssetsTypeDR'="" s AsssetsTypeCode=$p($g(^DHCEQCCode("DHCEQForCWJW",AsssetsTypeDR)),"^",1)
	i (AsssetsTypeCode="09") {s passed=0  q}
	quit
}

ClassMethod DIRSGFIXEDASSETSINFOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DIRSGFIXEDASSETSINFOExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod DIRSGFIXEDASSETSINFOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DIRSGFIXEDASSETSINFOExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 2014-6-20 HZY0055 获取资金来源描述信息
/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetFundsInfo("1")
/// 返回值：自筹=123,财政=234,科研=345
ClassMethod GetFundsInfo(EquipIDs)
{
	//n length,i,equipRowID,node
	//n FTDR,FRowID,FundsInfo,FundsType,FundsFee
	s Times=$H
	s node="web.DHCEQEquip.GetFundsInfo"
	k ^DHCEQTemp(node,Times,$j)
	i EquipIDs="" q ""
	
	s FundsInfo=""
	s length=$l(EquipIDs,",")
	f i=1:1:length d
	.s equipRowID=$p(EquipIDs,",",i)
	.q:equipRowID=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR))  q:FTDR=""  d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR,FRowID))  q:FRowID=""  d
	...q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	...s FundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
	...i length=1  d
	....d BuildDataFundsInfo
	...e  d
	....s ^DHCEQTemp(node,Times,$j,FTDR)=+$g(^DHCEQTemp(node,Times,$j,FTDR))+FundsFee
	
	i length>1  d
	.s FundsInfo=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQTemp(node,Times,$j,FTDR)) q:FTDR=""  d
	..s FundsFee=^DHCEQTemp(node,Times,$j,FTDR)
	..d BuildDataFundsInfo
	
	k ^DHCEQTemp(node,Times,$j) 
	q FundsInfo
	
BuildDataFundsInfo
	s FundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTDR)),"^",2)
	i FundsInfo="" d
	.s FundsInfo=FundsType_"="_FundsFee
	e  d
	.s FundsInfo=FundsInfo_","_FundsType_"="_FundsFee
}

/// 医疗设备表
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03
/// output:			
/// 		BATCH_NUM		VARCHAR2(64)		不填	批次号
/// 		UPLOAD_TIME		VARCHAR2(14)		不填	系统上传时间
/// 		RESULTDESC		VARCHAR2(4000)		不填	处理结果描述
/// 		RESULTCODE		VARCHAR2(8)			不填	处理结果代码
/// 		SERIALNUM_ID	VARCHAR2(40)		不填	流水号
/// 		UNIQUEID		VARCHAR2(64)		必填	文档唯一 ID
/// 		BUSINESS_RELATION_ID	VARCHAR2(30)		不填	业务关联 ID
/// 		BUSINESS_ACTIVE_TYPE	VARCHAR2(30)		不填	业务活动类别
/// 		BUSINESS_ACTIVE_DES	VARCHAR2(100)		不填	业务活动类别描述
/// 		BUSINESS_ID		VARCHAR2(100)		必填	业务流水号述
/// 		BASIC_ACTIVE_TYPE	VARCHAR2(50)	不填	基本活动类别
/// 		BASIC_ACTIVE_DES	VARCHAR2(100)	不填	基本活动类别描述			
/// 		BASIC_ACTIVE_ID		VARCHAR2(100)	必填	基本活动流水号
/// 		ORGANIZATION_CODE	VARCHAR2(50)	必填	组织机构代码
/// 		ORGANIZATION_NAME	VARCHAR2(70)	必填	组织机构名称
/// 		DOMAIN_CODE		VARCHAR2(30)		必填	域代码
/// 		DOMAIN_NAME		VARCHAR2(100)		必填	域名称
/// 		VER			VARCHAR2(50)			不填	版本号
/// 		VERDES		VARCHAR2(100)			不填	版本描述
/// 		REGION_IDEN		VARCHAR2(30)		必填	地区标识
/// 		DATA_SECURITY	VARCHAR2(5)			不填	数据密级
/// 		RECORD_IDEN		VARCHAR2(30)		必填	记录标识
/// 		CREATE_DATE		VARCHAR2(14)		不填	新建时间
/// 		UPDATE_DATE		VARCHAR2(14)		不填	更新时间
/// 		DATAGENERATE_DATE	VARCHAR2(15)	必填	业务数据产生时间
/// 		AP08_10_052_17	VARCHAR2(50)		必填	机构代码
/// 		AP08_10_013_07	VARCHAR2(700)		必填	机构名称
/// 		AP08_50_081_00	VARCHAR2(2)			必填	填报状态代码
/// 		AP08_50_082_00	VARCHAR2(10)		必填	设备类型代号
/// 		AP08_50_083_00	VARCHAR2(50)		必填	设备类型名称
/// 		AP08_50_084_00	VARCHAR2(100)		必填	设备型号
/// 		AP08_50_085_00	VARCHAR2(5)			必填	同批购进相同型号设备台数
/// 		AP08_50_086_00	VARCHAR2(2)			必填	产地类别代码
/// 		AP08_50_087_00	VARCHAR2(100)		必填	生产厂家
/// 		AP08_50_088_00	VARCHAR2(8)			必填	购买日期
/// 		AP08_50_089_00	VARCHAR2(2)			必填	购进时新旧情况代码
/// 		AP08_50_090_00	VARCHAR2(50)		必填	购进时新旧情况
/// 		AP08_50_091_00	VARCHAR2(10)		必填	购买单价(千元，人民币)
/// 		AP08_50_092_00	VARCHAR2(5)			必填	理论设计寿命(年)
/// 		AP08_50_093_00	VARCHAR2(2)			必填	使用情况代码
/// 		AP08_50_094_00	VARCHAR2(50)		必填	使用情况
/// 		AP08_50_095_00	VARCHAR2(2)					急救车是否配备车载卫星
/// 		DE09_00_053_00	VARCHAR2(15)		必填	填报日期时间
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","DIRSGFACILITYINFO","","")
Query DIRSGFACILITYINFO(sDate As %String, eDate As %String) As %Query(ROWSPEC = "BATCHNUM:%String,UPLOADTIME:%String,RESULTDESC:%String,RESULTCODE:%String,RESULTCODE:%String,SERIALNUMID:%String,UNIQUEID:%String,BUSINESSRELATIONID:%String,BUSINESSACTIVETYPE:%String,BUSINESSACTIVEDES:%String,BUSINESSID:%String,BASICACTIVETYPE:%String,BASICACTIVEDES:%String,BASICACTIVEID:%String,ORGANIZATIONCODE:%String,ORGANIZATIONNAME:%String,DOMAINCODE:%String,DOMAINNAME:%String,VER:%String,VERDES:%String,REGIONIDEN:%String,DATASECURITY:%String,RECORDIDEN:%String,CREATEDATE:%String,UPDATEDATE:%String,DATAGENERATEDATE:%String,AP081005217:%String,AP081001307:%String,AP085008100:%String,AP085008200:%String,AP085008300:%String,AP085008400:%String,AP085008500:%String,AP085008600:%String,AP085008700:%String,AP085008800:%String,AP085008900:%String,AP085009100:%String,AP085009200:%String,AP085009300:%String,AP085009400:%String,AP085009500:%String,DE090005300:%String") [ SqlProc ]
{
}

ClassMethod DIRSGFACILITYINFOExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQEquip(0,"InStockList",0,StoreLocID))  quit:StoreLocID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"InStockList",0,StoreLocID,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQEquip(rowid))
	..d CheckGetEquipListDIRSGFACILITYINFO
	..q:passed=0
	..s Qty=1
	..s vRowID=rowid
	..d SetValueGetEquipList
	..d OutputRowDIRSGFACILITYINFO 
	
	s InStockListID=0
	f  s InStockListID=$o(^DHCEQEquip(0,"InStockList",InStockListID))  quit:InStockListID=""  d
	.s Qty=0
	.s vRowID=""
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQEquip(0,"InStockList",InStockListID,StoreLocID))  quit:StoreLocID=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockListID,StoreLocID,rowid))  quit:rowid=""  d
	...s DataList=$g(^DHCEQEquip(rowid))
	...d CheckGetEquipListDIRSGFACILITYINFO
	...q:passed=0
	...s Qty=Qty+1
	...s vRowID=rowid
	.d SetValueGetEquipList
	.d OutputRowDIRSGFACILITYINFO
	Quit $$$OK
OutputRowDIRSGFACILITYINFO
	s data=$lb(BATCHNUM,UPLOADTIME,RESULTDESC,RESULTCODE,RESULTCODE,SERIALNUMID,UNIQUEID,BUSINESSRELATIONID,BUSINESSACTIVETYPE,BUSINESSACTIVEDES,BUSINESSID,BASICACTIVETYPE,BASICACTIVEDES,BASICACTIVEID,ORGANIZATIONCODE,ORGANIZATIONNAME,DOMAINCODE,DOMAINNAME,VER,VERDES,REGIONIDEN,DATASECURITY,RECORDIDEN,CREATEDATE,UPDATEDATE,DATAGENERATEDATE,AP081005217,AP081001307,AP085008100,AP085008200,AP085008300,AP085008400,AP085008500,AP085008600,AP085008700,AP085008800,AP085008900,AP085009100,AP085009200,AP085009300,AP085009400,AP085009500,DE090005300)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
CheckGetEquipListDIRSGFACILITYINFO
	s passed=1
	s InvalidFlag = $p(DataList,"^",59)
	i InvalidFlag'="N" 	{s passed=0 q}
	s Status = $p(DataList,"^",38)
	i (Status>"2"){s passed=0  q}
	s StockStatus = $p(DataList,"^",60)
	i (StockStatus="0")||((StockStatus="3")) {s passed=0 q}
	s StatCatDR = $p(DataList,"^",75)
	s (AsssetsTypeDR,AsssetsTypeCode)=""
	i StatCatDR'="" s AsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",10)
	i AsssetsTypeDR'="" s AsssetsTypeCode=$p($g(^DHCEQCCode("DHCEQForCWJW",AsssetsTypeDR)),"^",1)
	i (AsssetsTypeCode="09") {s passed=0  q}
	quit
SetValueGetEquipList
	s (BATCHNUM,UPLOADTIME,RESULTDESC,RESULTCODE,RESULTCODE,SERIALNUMID,UNIQUEID,BUSINESSRELATIONID,BUSINESSACTIVETYPE,BUSINESSACTIVEDES,BUSINESSID,BASICACTIVETYPE,BASICACTIVEDES)=""
	s (BASICACTIVEID,ORGANIZATIONCODE,ORGANIZATIONNAME,DOMAINCODE,DOMAINNAME,VER,VERDES,REGIONIDEN,DATASECURITY,RECORDIDEN,CREATEDATE,UPDATEDATE,DATAGENERATEDATE)=""
	s DataList=$g(^DHCEQEquip(vRowID))
	s AP081005217=""	//机构代码
	s AP081001307=""	//机构名称
	s AP085008100=""	//填报状态代码
	s AP085008200=$p(DataList,"^",75)	//设备类型代号
	i AP085008200'="" s AP085008200=$p($g(^DHCEQCCode("DHCEQCStatCat",AP085008200)),"^",10)
	i AP085008200'="" s AP085008200=$p($g(^DHCEQCCode("DHCEQForCWJW",AP085008200)),"^",1)
	i AP085008200'="" s AP085008300=$p($g(^DHCEQCCode("DHCEQForCWJW",AP085008200)),"^",2)  //设备类型名称
	s AP085008400=$p(DataList,"^",3)	//设备型号
	i AP085008400 '="" s AP085008400 = ##Class(web.DHCEQCommon).GetTrakNameByID("model",AP085008400)
	s AP085008500=Qty  //同批购进相同型号设备台数
	s AP085008600=""	//产地类别代码
	s AP085008700=$p(DataList,"^",26)	//生产厂家
	i AP085008700'="" s AP085008700=$p($g(^DHCEQCCode("DHCEQCManufacturer",AP085008700)),"^",1)
	s AP085008800=$p(DataList,"^",12)	//购买日期
	i AP085008800'="" s AP085008800=##class(web.DHCEQCommon).Replace($ZD(AP085008800,3),"-","")
	s AP085008900=""	//购进时新旧情况代码
	s AP085009000=""	//购进时新旧情况
	s AP085009100=$p(DataList,"^",27)	//购买单价(千元，人民币)
	s AP085009200=$p(DataList,"^",31)	//理论设计寿命(年)
	s AP085009300=""	//使用情况代码
	s AP085009400=""	//使用情况
	s AP085009500=""	//急救车是否配备车载卫星
	s DE090005300=$p(DataList,"^",45)	//填报日期时间
	i DE090005300'="" s DE090005300=##class(web.DHCEQCommon).Replace($ZD(DE090005300,3),"-","")
	quit
}

ClassMethod DIRSGFACILITYINFOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DIRSGFACILITYINFOExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod DIRSGFACILITYINFOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DIRSGFACILITYINFOExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2015-6-10
/// 固定资产分类汇总表
/// 成本收益数据表-固定资产分类汇总表 BUSI_EQUI_BALANCE  
/// query名字我们组写好了,请大家帮忙把内容添下.
/// modified by zy 2014-7-23
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03 
/// output:	
/// 		会计年度:		Year
/// 		期间:			Month
/// 		仓库编码:		在科/科室ID	 (如果在科室,科室编码就不为空,仓库编码就写"在科"; ID 是CT_Loc表中的ID)
/// 		科室编码:		在库/科室ID	 (如果在库房,科室编码写"在库",库房编码不为空; ID 是CT_Loc表中的ID)
/// 		资产分类编码:	国标码代码
/// 		资产类型:		0/01/02/03/04      (01:医疗设备;02:房屋建筑;03:土地;04:其他;0:未定义(当没有在设备类型上给设备定义卫计委的资产分类时显示未定义)) 
/// 		资产编码:		设备名称
/// 		资产归属编码:	空
/// 		资产归属名称:	空
/// 		期初数量:		数字
/// 		期初金额:		数字
/// 		本期增加数量:	数字
/// 		本期增加金额:	数字
/// 		本期减少数量:	数字
/// 		本期减少金额:	数字
/// 		期末数量:		数字
/// 		期末金额:		数字
/// 		本期折旧:		数字
/// 		累计折旧:		数字
/// 		资产数量:		空
/// d ##class(%ResultSet).RunQuery("web.BMI.BUSIEQUIBALANCE","BUSIEQUIBALANCE","2014","07")
Query BUSIEQUIBALANCE(Year As %String, Month As %String) As %Query(ROWSPEC = "ACCTYEAR:%String,ACCTMONTH:%String,STORECODE:%String,DEPTCODE:%String,EQUIKINDCODE:%String,EQUIKINDTYPE:%String,EQUICODE:%String,ATTCODE:%String,ATTNAME:%String,BEGINAMOUNT,BEGINMONEY:%Float,INAMOUNT:%Float,INMONEY:%Float,OUTAMOUNT:%Float,OUTMONEY:%Float,ENDAMOUNT:%Float,ENDMONEY:%Float,DEPREMONEY:%Float,ALREADYDEPRE:%Float,EQUIAMOUNT:%Float") [ SqlProc ]
{
}

ClassMethod BUSIEQUIBALANCEExecute(ByRef qHandle As %Binary, Year As %String, Month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Set TJob=$job
	If ($L(Month))=1 Set Month="0"_Month	;20150701  Mozy0155
	//本月没有生成记录的,要去快照中,找到记录,并写入表中.
	if '$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month)) 
	{
		d ##Class(web.BMI.BUSIEQUIBALANCE).FillReportListInfo(Year,Month,TJob)
	}
	//防止写入记录的程序出错,本query报错.
	i '$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month))  Quit $$$OK
	s (ATTCODE,ATTNAME,EQUIAMOUNT)=""
	s ACCTYEAR=Year
	s ACCTMONTH=Month

	s rowid=0
	f  s rowid=$o(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month,rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQForWJWSnapMonthReport(rowid))
	.s STORECODE= $p(DataList,"^",6)
	.s DEPTCODE = $p(DataList,"^",7)
	.;i STORECODE'="在科"  s STORECODE=$p($g(^CTLOC(STORECODE)),"^",2)
	.;i DEPTCODE'="在库"  s DEPTCODE=$p($g(^CTLOC(DEPTCODE)),"^",2)
	.s EQUIKINDCODE=$p(DataList,"^",8)
	.i EQUIKINDCODE'="" s EQUIKINDCODE=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EQUIKINDCODE)),"^",1)
	.s EQUIKINDTYPE=+$p(DataList,"^",9)
	.i EQUIKINDTYPE>0 s EQUIKINDTYPE=$p($g(^DHCEQCCode("DHCEQForCWJW",EQUIKINDTYPE)),"^",1)
	.s EQUICODE=$p(DataList,"^",10)
	.i EQUICODE'="" s EQUICODE=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQUICODE)),"^",1)
	.s BEGINAMOUNT=+$p(DataList,"^",13)
	.s BEGINMONEY=+$p(DataList,"^",14)
	.s INAMOUNT=+$p(DataList,"^",15)
	.s INMONEY=+$p(DataList,"^",16)
	.s OUTAMOUNT=+$p(DataList,"^",17)
	.s OUTMONEY=+$p(DataList,"^",18)
	.s ENDAMOUNT=+$p(DataList,"^",19)
	.s ENDMONEY=+$p(DataList,"^",20)
	.s DEPREMONEY=+$p(DataList,"^",21)
	.s ALREADYDEPRE=+$p(DataList,"^",22)
	.d OutputRowBUSIEQUIBALANCE
	Quit $$$OK
OutputRowBUSIEQUIBALANCE
	s data=$lb(ACCTYEAR,ACCTMONTH,STORECODE,DEPTCODE,EQUIKINDCODE,EQUIKINDTYPE,EQUICODE,ATTCODE,ATTNAME,BEGINAMOUNT,BEGINMONEY,INAMOUNT,INMONEY,OUTAMOUNT,OUTMONEY,ENDAMOUNT,ENDMONEY,DEPREMONEY,ALREADYDEPRE,EQUIAMOUNT)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod BUSIEQUIBALANCEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BUSIEQUIBALANCEExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod BUSIEQUIBALANCEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BUSIEQUIBALANCEExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).FillReportListInfo("2014","07",1464)
ClassMethod FillReportListInfo(Year, Month, Job)
{
	//new PreMonthStr,flag,Preflag,beginFlag,CurSnapID,SnapID,PreSnapID,CurMonth,rowid
	//new CurDataList,PreDataList
	//new CurEquipTypeDR,PreEquipTypeDR,ItemDR,CurOriginalFee,PreOriginalFee,ChangeFee,CurDepreFee
	//new CurDepreTotalFee,PreDepreTotalFee,CurStatus,PreStatus,CurStoreLocDR,PreStoreLocDR
	//new BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee
	//new TJob,EquipTypeID,StoreLocID,TempList
	
	k ^DHCEQTemp("BUSI_EQUI_BALANCE",Job)
	
	i ($L(Month))=1 s Month="0"_Month
	s CurMonthStr=Year_"-"_Month
	
	//找到前后两个快照的ID,通过比较两个快照来出结果
	s (SnapID,PreSnapID)=""
	//指定的会计周期的第一天才能取到ID
	//20150701  Mozy0155
	Set SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(CurMonthStr)
	If SnapID="" Quit
	Set PreSnapID=SnapID-1
	
	s rowid=0
	f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:rowid=""  d
	.s CurDataList=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
	.s PreDataList=$g(^DHCEQSnapShot(PreSnapID,"Equip",rowid))
	.d BulidTempData
	
	//从临时golable中把数据写如表中.
	d ..SaveReportListInfo(Year,Month,Job)
	
	k ^DHCEQTemp("BUSI_EQUI_BALANCE",Job)
	quit
BulidTempData
	s (CurStatCatDR,PreStatCatDR,CurAsssetsTypeDR,PreAsssetsTypeDR,CurStatus,PreStatus,ItemDR)=""
	s (CurStoreLocDR,PreStoreLocDR,CurAsssetsTypeDRCode,PreAsssetsTypeDRCode,CurInvalidFlag,PreInvalidFlag)=""
	s (CurStockStatus,PreStockStatus)=""
	s (CurOriginalFee,PreOriginalFee,ChangeFee,CurDepreFee,CurDepreTotalFee,PreDepreTotalFee)=0
	s CurStatCatDR = $p(CurDataList,"^",75)
	s PreStatCatDR = $p(PreDataList,"^",75)
	i CurStatCatDR'="" s CurAsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",CurStatCatDR)),"^",10)
	i PreStatCatDR'="" s PreAsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",PreStatCatDR)),"^",10)
	i CurAsssetsTypeDR'="" s CurAsssetsTypeDRCode=$p($g(^DHCEQCCode("DHCEQForCWJW",CurAsssetsTypeDR)),"^",1)
	i PreAsssetsTypeDR'="" s PreAsssetsTypeDRCode=$p($g(^DHCEQCCode("DHCEQForCWJW",PreAsssetsTypeDR)),"^",1)
	q:(CurAsssetsTypeDRCode="09")&&(PreAsssetsTypeDRCode="09")	//都09就是非卫计委统计数据
	i CurAsssetsTypeDR="" s CurAsssetsTypeDR=0
	i PreAsssetsTypeDR="" s PreAsssetsTypeDR=0
	s ItemDR = $p(CurDataList,"^",7)
	quit:ItemDR=""		//有空就是数据有问题
	
	s CurStatus = $p(CurDataList,"^",38)
	s PreStatus = $p(PreDataList,"^",38)
	quit:(CurStatus>"2")&(PreStatus>"2")	//不是本月报废数据,不统计
	i (CurStatus="0")||(CurStatus="2") s CurStatus=0	//状态只记两种	0:在库;1:在用
	i (PreStatus="0")||(PreStatus="2") s PreStatus=0	//0:在库;2:封存 都记为在库
	s CurInvalidFlag = $p(CurDataList,"^",59)
	s PreInvalidFlag = $p(PreDataList,"^",59)
	quit:(CurInvalidFlag="Y")&(PreInvalidFlag="Y")	//无效数据
	s CurStockStatus = $p(CurDataList,"^",60)
	s PreStockStatus = $p(PreDataList,"^",60)
	quit:(CurStockStatus="0")&(PreStockStatus="0")	//验收未入库
	quit:(CurStockStatus="3")&(PreStockStatus="3")	//退货和减少
	s CurStoreLocDR  = $p(CurDataList,"^",67)
	s PreStoreLocDR  = $p(PreDataList,"^",67)
	s CurOriginalFee = +$p(CurDataList,"^",27)
	s PreOriginalFee = +$p(PreDataList,"^",27)
	s ChangeFee=+CurOriginalFee-PreOriginalFee
	s CurDepreFee=$o(^DHCEQMonthDepre(0,"EquipMonth",rowid,CurMonthStr,0))
	i CurDepreFee'="" s CurDepreFee=$p($g(^DHCEQMonthDepre(CurDepreFee)),"^",14)
	s CurDepreTotalFee = $p(CurDataList,"^",35)
	s PreDepreTotalFee = $p(PreDataList,"^",35)
	//只要有下面一个条件变化的就要分别记期初的减少,期末的增加
	i (CurStatus'=PreStatus)||(CurStoreLocDR'=PreStoreLocDR)||(CurAsssetsTypeDR'=PreAsssetsTypeDR)||(CurInvalidFlag'=PreInvalidFlag) d
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.quit:((PreStatus="3")&((CurStatus<"3")))	//期初是报废,期末可用的只记期末
	.quit:((PreInvalidFlag="Y")&((CurInvalidFlag'="Y")))	//期初无效,期末有效的只记期末
	.s StoreLocID=PreStoreLocDR
	.s AsssetsTypeID=PreAsssetsTypeDR
	.s Status=PreStatus
	.s BeginQty=1
	.s BeginFee=PreOriginalFee
	.s ReduceQty=1
	.s ReduceFee=PreOriginalFee
	.s DepreFee=CurDepreFee
	.d DoDataList
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.s StoreLocID=CurStoreLocDR
	.s AsssetsTypeID=CurAsssetsTypeDR
	.quit:CurStatus="3"	//本月报废的数据只记减少.
	.quit:CurInvalidFlag="Y"	//本月无效掉的数据只记减少.
	.s Status=CurStatus
	.s AddQty=1
	.s AddFee=CurOriginalFee
	.s EndQty=1
	.s EndFee=CurOriginalFee
	.s DepreTotalFee=CurDepreTotalFee
	.d DoDataList
	e  d
	.s (BeginQty,BeginFee,AddQty,AddFee,ReduceQty,ReduceFee,EndQty,EndFee,DepreFee,DepreTotalFee)=0
	.s StoreLocID=CurStoreLocDR
	.s AsssetsTypeID=CurAsssetsTypeDR
	.s Status=CurStatus
	.s BeginQty=1
	.s BeginFee=PreOriginalFee
	.//处理原值调账的数据
	.i ChangeFee>0 d
	..s AddFee=ChangeFee
	.e  d
	..s ReduceFee=-ChangeFee
	.s EndQty=1
	.s EndFee=CurOriginalFee
	.s DepreFee=CurDepreFee
	.s DepreTotalFee=CurDepreTotalFee
	.d DoDataList
	quit
DoDataList
	i (StoreLocID="")||(ItemDR="")||(AsssetsTypeID="")||(Status="") quit 
	s TempList=$g(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemDR))
	s $p(TempList,"^",1)=+$p(TempList,"^",1)+BeginQty
	s $p(TempList,"^",2)=+$p(TempList,"^",2)+BeginFee
	s $p(TempList,"^",3)=+$p(TempList,"^",3)+AddQty
	s $p(TempList,"^",4)=+$p(TempList,"^",4)+AddFee
	s $p(TempList,"^",5)=+$p(TempList,"^",5)+ReduceQty
	s $p(TempList,"^",6)=+$p(TempList,"^",6)+ReduceFee
	s $p(TempList,"^",7)=+$p(TempList,"^",7)+EndQty
	s $p(TempList,"^",8)=+$p(TempList,"^",8)+EndFee
	s $p(TempList,"^",9)=+$p(TempList,"^",9)+DepreFee
	s $p(TempList,"^",10)=+$p(TempList,"^",10)+DepreTotalFee
	s ^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemDR)=TempList
	
	quit
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).SaveReportListInfo("2013","03",1464)
ClassMethod SaveReportListInfo(Year, Month, Job)
{
	k PLIST
 	s Date=+$H
	s Time=$p($H,",",2)
	s PLIST(5) = Year
	s PLIST(6) = Month
	
	s PLIST(25) = Date
	s PLIST(26) = Time
	
	Set $ZT="SaveReportList"
	TStart
	s SQLCODE=0
	///保存当月结果
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID))  quit:StoreLocID=""  d
	.s AsssetsTypeID=""
	.f  s AsssetsTypeID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID))  quit:AsssetsTypeID=""  d
	..s PLIST(10)=AsssetsTypeID
	..s Status=""
	..f  s Status=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status))  quit:Status=""  d
	...i Status=0 d
	....s PLIST(7)= StoreLocID
	....s PLIST(8)="在库"
	...e  d
	....s PLIST(7)="在科"
	....s PLIST(8)= StoreLocID
	...s ItemID=0
	...f  s ItemID=$o(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemID))  quit:ItemID=""  d
	....s PLIST(11)=ItemID
	....s (EquipCatDR,AsssetsTypeDR)=""
	....s EquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",4)
	....s PLIST(9)=EquipCatDR
	....s DataList=$G(^DHCEQTemp("BUSI_EQUI_BALANCE",Job,StoreLocID,AsssetsTypeID,Status,ItemID))
	....s PLIST(14)=+$p(DataList,"^",1)
	....s PLIST(15)=+$p(DataList,"^",2)
	....s PLIST(16)=+$p(DataList,"^",3)
	....s PLIST(17)=+$p(DataList,"^",4)
	....s PLIST(18)=+$p(DataList,"^",5)
	....s PLIST(19)=+$p(DataList,"^",6)
	....s PLIST(20)=+$p(DataList,"^",7)
	....s PLIST(21)=+$p(DataList,"^",8)
	....s PLIST(22)=+$p(DataList,"^",9)
	....s PLIST(23)=+$p(DataList,"^",10)
	....&SQL(Insert Into SQLUSER.DHC_EQForWJWSnapMonthReport Values :PLIST())
	....q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
SaveReportList
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^"_ErrorMsg     //返回错误消息 ;
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).DeleteData("2014","07")
/// add by zy  2014-7-24
/// 用于要删除某月的数据操作.
ClassMethod DeleteData(Year, Month)
{
	q:'$Data(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month))
	s (rowid,flag,SQLCODE)=0
	f  s rowid=$o(^DHCEQForWJWSnapMonthReport(0,"YearMonth",Year,Month,rowid))  quit:(rowid="")||(flag=1)  d
	.s DataList=$g(^DHCEQForWJWSnapMonthReport(rowid))
	.s EQUIKINDTYPE=$p(DataList,"^",9)
	.i EQUIKINDTYPE=0 s flag=1
	
	i flag=0 w "报表中数据完整,如继续删除g,取消删除q!"
	TSTART
	&sql(delete from sqluser.DHC_EQForWJWSnapMonthReport where SMR_AcctYear=:Year and SMR_AcctMonth=:Month)
 	if SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
	TCOMMIT
	q SQLCODE
}

/// add by zy 2015-6-10
/// 医学装备基本情况信息表
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03
/// output:				
/// 		统计年份	ACCT_YEAR
/// 		统计月份	ACCT_MONTH
/// 		医学装备总数	ARMARIUM_NUM
/// 		医学装备总价值	ARMARIUM_COST
/// 		其中：国产设备数	ARMARIUM_NUM_CHINA
/// 		其中：国产设备价	ARMARIUM_COST_CHINA
/// 		其中：进口设备数量	ARMARIUM_NUM_IMPORT	
/// 		其中：进口设备价值	ARMARIUM_COST_IMPORT
/// 		装备大型医疗设备数量	LARGE_ARMARIUM_NUM
/// 		其中：甲类设备编码	LARGE_ARMARIUM_CODE_A
/// 		其中：甲类设备台数	LARGE_ARMARIUM_NUM_A
/// 		其中：乙类设备编码	LARGE_ARMARIUM_CODE_B
/// 		其中：乙类设备台数	LARGE_ARMARIUM_NUM_B
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","ARMARIUM","2015","02")
Query ARMARIUM(Year As %String, Month As %String) As %Query(ROWSPEC = "ACCTYEAR:%String,ACCTMONTH:%String,ARMARIUMNUM:%String,ARMARIUMCOST:%String,ARMARIUMNUMCHINA:%String,ARMARIUMCOSTCHINA:%String,ARMARIUMNUMIMPORT:%String,ARMARIUMCOSTIMPORT:%String,LARGEARMARIUMNUM:%String,LARGEARMARIUMCODEA:%String,LARGEARMARIUMNUMA:%String,LARGEARMARIUMCODEB:%String,LARGEARMARIUMNUMB:%String") [ SqlProc ]
{
}

ClassMethod ARMARIUMExecute(ByRef qHandle As %Binary, Year As %String, Month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i ($L(Month))=1 s Month="0"_Month
	s CurMonthStr=Year_"-"_Month
	
	s ACCTYEAR=Year
	s ACCTMONTH=Month
	
	//查看设备的信息,应该查看下月的快照数据.20150701  Mozy0155
	Set SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(CurMonthStr)
	if (SnapID="")
	{
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
		.s DataList=$g(^DHCEQEquip(rowid))
		.d CheckGetEquipListARMARIUM
		.q:passed=0
		.d SetValueGetEquipListARMARIUM
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:rowid=""  d
		.s DataList=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
		.d CheckGetEquipListARMARIUM
		.q:passed=0
		.d SetValueGetEquipListARMARIUM
	}
	d OutputRowARMARIUM
	Quit $$$OK
CheckGetEquipListARMARIUM
	s passed=1
	s InvalidFlag = $p(DataList,"^",59)
	i InvalidFlag'="N" 	{s passed=0 q}
	s Status = $p(DataList,"^",38)
	i (Status>"2"){s passed=0  q}
	s StockStatus = $p(DataList,"^",60)
	i (StockStatus="0")||((StockStatus="3")) {s passed=0 q}
	s StatCatDR = $p(DataList,"^",75)
	s (AsssetsTypeDR,AsssetsTypeCode)=""
	i StatCatDR'="" s AsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",10)
	i AsssetsTypeDR'="" s AsssetsTypeCode=$p($g(^DHCEQCCode("DHCEQForCWJW",AsssetsTypeDR)),"^",1)
	i (AsssetsTypeCode'="01") {s passed=0  q}   //非医疗设备不统计
	quit
SetValueGetEquipListARMARIUM
	s (ACCTYEAR,ACCTMONTH,ARMARIUMNUM,ARMARIUMCOST,ARMARIUMNUMCHINA,ARMARIUMCOSTCHINA,ARMARIUMNUMIMPORT,ARMARIUMCOSTIMPORT,LARGEARMARIUMNUM,LARGEARMARIUMCODEA,LARGEARMARIUMNUMA,LARGEARMARIUMCODEB,LARGEARMARIUMNUMB)=""
	s OriginalFee=$p(DataList,"^",27)
	s ARMARIUMNUM=ARMARIUMNUM+1
	s ARMARIUMCOST=ARMARIUMCOST+OriginalFee
	s Country=$p(EquipData,"^",16)
	i Country'="" s Country =##Class(web.DHCEQCommon).GetTrakNameByID("cou",Country)
	i (Country="中国")||(Country="")  d
	.s ARMARIUMNUMCHINA=ARMARIUMNUMCHINA+1
	.s ARMARIUMCOSTCHINA=ARMARIUMCOSTCHINA+OriginalFee
	e  d
	.s ARMARIUMNUMIMPORT=ARMARIUMNUMIMPORT+1
	.s ARMARIUMCOSTIMPORT=ARMARIUMCOSTIMPORT+OriginalFee
	s LARGEARMARIUMNUM=""
	s LARGEARMARIUMCODEA=""
	s LARGEARMARIUMNUMA=""
	s LARGEARMARIUMCODEB=""
	s LARGEARMARIUMNUMB=""
	quit
OutputRowARMARIUM
	s data=$lb(ACCTYEAR,ACCTMONTH,ARMARIUMNUM,ARMARIUMCOST,ARMARIUMNUMCHINA,ARMARIUMCOSTCHINA,ARMARIUMNUMIMPORT,ARMARIUMCOSTIMPORT,LARGEARMARIUMNUM,LARGEARMARIUMCODEA,LARGEARMARIUMNUMA,LARGEARMARIUMCODEB,LARGEARMARIUMNUMB)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod ARMARIUMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ARMARIUMExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod ARMARIUMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ARMARIUMExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2015-6-10
/// 固定资产卡片信息表
/// 成本收益数据表-固定资产卡片信息表 BUSI_EQUI_CARD    
/// query名字我们组写好了,请大家帮忙把内容添下.
/// modified by zy 2014-7-23
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03 
/// output:
/// 		会计年度:		Year
/// 		期间:			Month
/// 		资产卡片编码:	设备编号
/// 		资产名称:		设备名称
/// 		使用状态:		1			 (1:正常;2:待处置;3:处置完毕.  由于不明白三个状态的意思,在系统中输出的都不是报废设备,理解为正常.)
/// 		卡片所在位置:	0/1    		 (0:仓库;1:科室)
/// 		仓库编码:		在科/科室ID	 (如果在科室,科室编码就不为空,仓库编码就写"在科"; ID 是CT_Loc表中的ID)
/// 		科室编码:		在库/科室ID	 (如果在库房,科室编码写"在库",库房编码不为空; ID 是CT_Loc表中的ID)
/// 		资产分类编码:	国标码代码
/// 		资产编码:		设备名称
/// 		规格			空
/// 		型号:			型号
/// 		品牌:			空
/// 		入库日期:		例如:25/03/2013
/// 		资产归属编码:	空
/// 		资产归属名称:	空
/// 		数量:			1
/// 		资产原值:		数字
/// 		资产现值:		数字
/// 		预计残值:		数字
/// 		累计折旧:		数字
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","BUSIEQUICARD","2015","03")
Query BUSIEQUICARD(Year As %String, Month As %String) As %Query(ROWSPEC = "ACCTYEAR:%String,ACCTMONTH:%String,EQUIARCHNO:%String,EQUINAME:%String,USESTATE:%String,EQUIINTYPE:%String,STORECODE:%String,DEPTCODE:%String,EQUIKINDCODE:%String,EQUICODE:%String,EQUIDESC:%String,EQUIMODEL:%String,EQUIBRAND:%String,INDATE:%String,ATTCODE:%String,ATTNAME:%String,AMOUNT:%Float,PRIMMONEY:%Float,CURMONEY:%Float,FOREODDMONEY:%Float,ALREADYDEPRE:%Float") [ SqlProc ]
{
}

ClassMethod BUSIEQUICARDExecute(ByRef qHandle As %Binary, Year As %String, Month As %String) As %Status
{
   
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i ($L(Month))=1 s Month="0"_Month
	s CurMonthStr=Year_"-"_Month
	
	s ACCTYEAR=Year
	s ACCTMONTH=Month
	
	s SnapID=""
	s CurSnapID=0
	for  s CurSnapID=$o(^DHCEQSnapShot(CurSnapID))  quit:(CurSnapID="")||(SnapID'="")  d
	.s CurMonth=$e($ZD(^DHCEQSnapShot(CurSnapID,"Begin"),3),1,7)
	.i CurMonth=CurMonthStr  s SnapID=CurSnapID
	//查看设备的信息,应该查看下月的快照数据.
	//
	s SnapID=SnapID+1
	if '$Data(^DHCEQSnapShot(SnapID,"Equip"))
	{
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
		.s DataList=$g(^DHCEQEquip(rowid))
		.d CheckGetEquipListBUSIEQUICARD
		.q:passed=0
		.d SetValueGetEquipListBUSIEQUICARD
		.d OutputRowBUSIEQUICARD 
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:rowid=""  d
		.s DataList=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
		.d CheckGetEquipListBUSIEQUICARD
		.q:passed=0
		.d SetValueGetEquipListBUSIEQUICARD
		.d OutputRowBUSIEQUICARD
	}
	Quit $$$OK
CheckGetEquipListBUSIEQUICARD
	s passed=1
	s InvalidFlag = $p(DataList,"^",59)
	i InvalidFlag'="N" 	{s passed=0 q}
	s Status = $p(DataList,"^",38)
	i (Status>"2"){s passed=0  q}
	s StockStatus = $p(DataList,"^",60)
	i (StockStatus="0")||((StockStatus="3")) {s passed=0 q}
	s StatCatDR = $p(DataList,"^",75)
	s (AsssetsTypeDR,AsssetsTypeCode)=""
	i StatCatDR'="" s AsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",10)
	i AsssetsTypeDR'="" s AsssetsTypeCode=$p($g(^DHCEQCCode("DHCEQForCWJW",AsssetsTypeDR)),"^",1)
	i (AsssetsTypeCode="09") {s passed=0  q}
	quit
SetValueGetEquipListBUSIEQUICARD
	s (COMPCODE,COPYCODE,EQUIDESC,EQUIBRAND,ATTCODE,ATTNAME)=""
	s EQUIARCHNO=$p(DataList,"^",71) //EquipNo
	s EQUINAME=$p(DataList,"^",1) //EquipName
	s USESTATE=$p(DataList,"^",38) //
	i (USESTATE=1)||(USESTATE=3) d
	.s EQUIINTYPE="1"
	.s STORECODE="在科"
	.s DEPTCODE=$p(DataList,"^",67)
	.;i DEPTCODE'="" s DEPTCODE=$p($g(^CTLOC(DEPTCODE)),"^",2)
	e  d  //(USESTATE=0)||(USESTATE=2)
	.s EQUIINTYPE="0"
	.s STORECODE=$p(DataList,"^",67)
	.;i STORECODE'="" s STORECODE=$p($g(^CTLOC(STORECODE)),"^",2)
	.s DEPTCODE="在库"
	
	s USESTATE=1
	s EQUIKINDCODE = $p(DataList,"^",4)
	i EQUIKINDCODE '="" s EQUIKINDCODE = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EQUIKINDCODE)),"^",2)
	s EQUICODE = $p(DataList,"^",7)
	i EQUICODE'="" s EQUICODE=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQUICODE)),"^",1)
	s EQUIMODEL= $p(DataList,"^",3)
	i EQUIMODEL'="" s EQUIMODEL = $p($g(^DHCEQCCode("DHCEQCModel",EQUIMODEL)),"^",2)
	
	s INDATE = ##Class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",45),"date")
	i INDATE="" d //无转资日期显示入库审核日期
	.s InStockListDR = $p(DataList,"^",70)
	.i InStockListDR '=""  d
	..s InStockList = $p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	..s INDATE=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(InStockList)),"^",13),"date") 
	s AMOUNT=1
	s PRIMMONEY=$p(DataList,"^",27)
	s CURMONEY=$p(DataList,"^",28)
	s FOREODDMONEY=$p(DataList,"^",29)
	s ALREADYDEPRE=$p(DataList,"^",35)
	quit
OutputRowBUSIEQUICARD
	s data=$lb(ACCTYEAR,ACCTMONTH,EQUIARCHNO,EQUINAME,USESTATE,EQUIINTYPE,STORECODE,DEPTCODE,EQUIKINDCODE,EQUICODE,EQUIDESC,EQUIMODEL,EQUIBRAND,INDATE,ATTCODE,ATTNAME,AMOUNT,PRIMMONEY,CURMONEY,FOREODDMONEY,ALREADYDEPRE)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod BUSIEQUICARDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BUSIEQUICARDExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod BUSIEQUICARDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BUSIEQUICARDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2015-6-10
/// 固定资产字典表
/// Input:输入参数  :	Year   : 2013
/// 					Month  : 03
/// output:			
/// 		固定资产编码	EQUI_CODE
/// 		固定资产名称	EQUI_NAME
/// 		固定资产分类编码	EQUI_KIND_CODE
/// 		计量单位	UNIT_CODE
/// 		固定资产规格	EQUI_DESC
/// 		固定资产型号	EQUI_MODEL
/// 		是否折旧	IS_DEPRE
/// 		折旧年限	DEPRE_YEARS
/// 		是否计量	IS_MEASURE
/// 		是否分摊	IS_COST
/// 		是否停用	IS_STOP
/// 		停用日期	END_DATE
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","DICTEQUI","","")
Query DICTEQUI(sDate As %String, eDate As %String) As %Query(ROWSPEC = "EQUICODE:%Float,EQUINAME:%Float,EQUIKINDCODE:%Float,UNITCODE:%Float,EQUIDESC:%Float,EQUIMODEL:%Float,ISDEPRE:%Float,DEPREYEARS:%Float,ISMEASURE:%Float,ISCOST:%Float,ISSTOP:%Float,ENDDATE:%Float") [ SqlProc ]
{
}

ClassMethod DICTEQUIExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQEquip(rowid))
	.d CheckGetEquipListDICTEQUI
	.q:passed=0
	.s EQUICODE= $p(DataList,"^",71)
	.s EQUINAME = $p(DataList,"^",1)
	.s EQUIKINDCODE=$p(DataList,"^",4)
	.i EQUIKINDCODE'="" s EQUIKINDCODE = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EQUIKINDCODE)),"^",1)
	.s UNITCODE=$p(DataList,"^",5)
	.i UNITCODE '="" s UNITCODE = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UNITCODE)
	.s EQUIDESC=""
	.s EQUIMODEL=$p(DataList,"^",3)
	.i EQUIMODEL '="" s EQUIMODEL = ##Class(web.DHCEQCommon).GetTrakNameByID("model",EQUIMODEL)
	.s ISDEPRE=$p(DataList,"^",33)
	.i ISDEPRE'="" s ISDEPRE=$p($g(^DHCEQCCode("DHCEQCDepreMethod",ISDEPRE)),"^",2)
	.i ISDEPRE'="不计提折旧"  d
	..s ISDEPRE="Y"
	.e  d
	..s ISDEPRE="N"
	.s DEPREYEARS=$p(DataList,"^",31)
	.s ISMEASURE=$p(DataList,"^",15)
	.;20150701  Mozy0155
	.If ISMEASURE="" Do
	..Set ISMEASURE="N"
	.Else  Do
	..Set ISMEASURE="Y"
	.s ISCOST=$p(DataList,"^",82)
	.i ISCOST="" s ISCOST="N"
	.s ISSTOP=$p(DataList,"^",38)
	.If ISSTOP="1"  Do
	..Set ISSTOP="N"
	.If ISSTOP="2" Do
	..Set ISSTOP="Y"
	..Set CSID=""
	..For  Set CSID=$Order(^DHCEQChangeStock(0,"Equip",rowid,CSID),-1)  Quit:(CSID="")||(enddate'="")  Do
	...Set TStatus=$Piece($Get(^DHCEQChangeStock(CSID)),"^",5)
	...Quit:TStatus'=1
	...Set ENDDATE=$Piece($Get(^DHCEQChangeStock(CSID)),"^",8)
	.If ENDDATE'="" Set ENDDATE=##class(web.DHCEQCommon).Replace($ZD(ENDDATE,3),"-",":")_" 00:00:00"
	.d OutputRowDICTEQUI 
	Quit $$$OK
OutputRowDICTEQUI
	s data=$lb(EQUICODE,EQUINAME,EQUIKINDCODE,UNITCODE,EQUIDESC,EQUIMODEL,ISDEPRE,DEPREYEARS,ISMEASURE,ISCOST,ISSTOP,ENDDATE)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
CheckGetEquipListDICTEQUI
	s passed=1
	s InvalidFlag = $p(DataList,"^",59)
	i InvalidFlag'="N" 	{s passed=0 q}
	s Status = $p(DataList,"^",38)
	i (Status>"2"){s passed=0  q}
	s StockStatus = $p(DataList,"^",60)
	i (StockStatus="0")||((StockStatus="3")) {s passed=0 q}
	s StatCatDR = $p(DataList,"^",75)
	s (AsssetsTypeDR,AsssetsTypeCode)=""
	i StatCatDR'="" s AsssetsTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",10)
	i AsssetsTypeDR'="" s AsssetsTypeCode=$p($g(^DHCEQCCode("DHCEQForCWJW",AsssetsTypeDR)),"^",1)
	i (AsssetsTypeCode="09") {s passed=0  q}
	quit
}

ClassMethod DICTEQUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DICTEQUIExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod DICTEQUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DICTEQUIExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2015-6-10
/// 固定资产分类表
/// Input:输入参数  :	
/// output:
/// 		固定资产分类编码	EQUI_KIND_CODE
/// 		固定资产分类名	EQUI_KIND_NA
/// 		上级编码	SUPER_CODE
/// 		资产类型	EQUI_KIND_TYPE
/// 		级次	KIND_LEVE
/// 		是否末级	IS_LAST
/// 		是否停用	IS_STOP
/// 		停用日期	END_DATE
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","DICTEQUIKIND")
Query DICTEQUIKIND() As %Query(ROWSPEC = "EQUIKINDCODE:%String,EQUIKINDNA:%String,SUPERCODE:%String,EQUIKINDTYPE:%String,KINDLEVE:%String,ISLAST:%String,ISLAST:%String,ISSTOP:%String,ENDDATE:%String") [ SqlProc ]
{
}

ClassMethod DICTEQUIKINDExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipeCat",rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQCCode("DHCEQCEquipeCat",rowid))
	.quit:$p(DataList,"^",7)="Y"
	.s EQUIKINDCODE=$p(DataList,"^",1)
	.s EQUIKINDNA=$p(DataList,"^",2)
	.s SUPERCODE=$p(DataList,"^",4)
	.i SUPERCODE>0 s SUPERCODE=$p($g(^DHCEQCCode("DHCEQCEquipeCat",SUPERCODE)),"^",1)
	.s EQUIKINDTYPE=""
	.s KINDLEVE=""
	.s ISLAST=""
	.If ##Class(web.DHCEQCEquipeCat).HasChild(rowid)>0 Set ISLAST="N"	;20150701  Mozy0155
	.s ISSTOP=""
	.s ENDDATE=""
	.d OutputRowDICTEQUIKIND
	Quit $$$OK
OutputRowDICTEQUIKIND
	s data=$lb(EQUIKINDCODE,EQUIKINDNA,SUPERCODE,EQUIKINDTYPE,KINDLEVE,ISLAST,ISLAST,ISSTOP,ENDDATE)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod DICTEQUIKINDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DICTEQUIKINDExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod DICTEQUIKINDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DICTEQUIKINDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 设备医保飞行检查数据
/// d ##class(web.DHCEQ.Interface.DHCEQForWJW).GetEquipInfo()
ClassMethod GetEquipInfo()
{
	
	s rtn=0
	
	s filename="bhsrmyy_sb"		/*$p(StartDate,"-",1)_"_"_$p(StartDate,"-",2)_"~"_$p(EndDate,"-",2)*/
	s fileload="D:\"_filename_".csv"
    s file=##class(%File).%New(fileload)
    d file.Open("RWSN")
    //d file.WriteLine("病案关联字段,结算单据号,医疗机构编码,医疗机构名称,医保结算等级,参保地统筹区域编码,参保地统筹区域名称,结算日期,结算年份,结算月份,住院号,个人编码,患者社保卡号,病案号,险种类型,人员类型,入院科别,转科科别,出院科别,主诊医师编码,主诊医师姓名,患者姓名,身份证号,患者性别,患者出生日期,患者年龄,患者所在单位,患者家庭住址,患者床位号,新生儿入院类型,新生儿出生体重,新生儿入院体重,住院医疗类型,异地标志,入院日期,出院日期,住院天数,离院方式,上一次出院日期,是否有31天内再住院计划,医疗总费用,基本统筹支付,大病保险,医疗救助,公务员医疗补助,大额补充,企业补充,个人现金支付,个人账户支付,个人自付,个人自费,符合基本医疗保险的费用,本次进入大病保险范围内金额,起付线金额,甲类使用,乙类使用,丙类使用,超限价自付金额,先行自付金额,自费金额,个人支付比例,统筹支付比例,个人支付床位费,统筹支付床位费,入院诊断编码,入院诊断名称,出院诊断编码,出院诊断名称,床位费,诊察费,检查费,化验费,治疗费,护理费,卫生材料费,西药费,中药饮片费,中成药费,一般诊疗费,挂号费,其他费,医保支付方式,病组病种编码,病组病种名称")
	d file.WriteLine("资产类别,资产编号,资产名称,生产企业,规格/型号,数量,单价,采购金额,启用日期,核销日期,使用状态,存放地点,使用科室,中标号,合同号,出厂日期,合格证号,是否收到发票,对应发票号")
	//d file.WriteLine("BRIDGE_ID,HISID,HOSPITAL_ID,HOSPITAL_NAME,P_LEVEL,BMI_AREA_ID,BMI_AREA_NAME,BILL_DATE,YEAR,MONTH,ZYH,PATIENT_ID,SOCIAL_CARD_ID,MEDICAL_RECORD_ID,BENEFIT_TYPE,BENEFIT_GROUP_ID,ADMISSION_DEPT_NAME,TRANSFER_DEPT_NAME,DISCHARGE_DEPT_NAME,DOCTOR_ID,DOCTOR_NAME,PATIENT_NAME,AAE135,PATIENT_GENDER,PATIENT_BIRTHDAY,PATIENT_AGE,PATIENT_COMPANY,PATIENT_ADDRESS,BEDID,NB_TYPE,NB_BIRTH_WEIGHT,NB_INPATIENT_WEIGHT,CLAIM_TYPE,IF_LOCAL_FLAG,ADMISSION_DATE,DISCHARGE_DATE,ZYTS,DISCHARGE_STATUS,PRE_ADMISSION_DATE,DAYS31_RE_ADMISSION,TOTAL_AMOUNT,BMI_PAY_AMOUNT,DBBX,YLJZ,GWYBZ,DEBC,QYBC,CASH,SELF_PAY_AMOUNT,SELF_PAY_IN,SELF_PAY_OUT,BMI_CONVERED_AMOUNT,DBBX_CONVERED_AMOUNT,QFXJR,JLSY,YLSY,BLSY,CXJZFJE,XXZFJE,ZFJE,GRZFBL,TCZFBL,GRZFCW,TCZFCW,ADMISSION_DISEASE_ID,ADMISSION_DISEASE_NAME,DISCHARGE_DISEASE_ID_MAIN,DISCHARGE_DISEASE_NAME_MAIN,ACCOMMODATION_FEE,DIAGNOSIS_FEE,INSPECTION_FEE,TEST_FEE,TREATMENT_FEE,NURSING_FEE,MATERIAL_FEE,WESTERN_MEDICINE_FEE,CHINESE_MEDICINE_YINPIAN,CHINESE_MEDICINE_FORM,CONSULTATION_FEE,REGISTRATION_FEE,OTHER_FEE,YB_PAY_TYPE,DRGS_CODE,DRGS_NAME")
	d file.WriteLine("ASSET_CLASS,ASSETS_ID,ASSETS_NAME,RECEIVE_MANUFACTURE,RECEIVE_SPEC,ASSETS_NUM,ASSETS_PRICE,ASSETS_COST,START_DATE,WRITE_OFF_DATE,USAGE_STATUS,STORAGE_LOCATION,USING_DEPARTMENT,MEDIUM_MARK_ID,CONTRACT_ ID,DELIVERY_ DATE,CERTIFICATE_ID,INVOICE_RECV_FLAG,INVOICE_ID")
	
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  quit:EQRowID=""  d
	.s EQInvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.q:EQInvalidFlag="Y"
	.s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.q:EQStockStatus'=1
	.s EquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$p($g(^DHCEQEquip(EQRowID)),"^",4))
	.s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s EQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.s Manufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EQRowID)),"^",26))
	.s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EQRowID)),"^",3))
	.s Quantity=1
	.s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)
	.s PurchaseFee=OriginalFee
	.s StartDate=$p($g(^DHCEQEquip(EQRowID)),"^",44)
	.i StartDate'="" s StartDate=$zd(StartDate,3)
	.s DisuseDate=$p($g(^DHCEQEquip(EQRowID)),"^",89)
	.i DisuseDate'="" s DisuseDate=$zd(DisuseDate,3)
	.s Status="正常"
	.i EQStatus=3 s Status="报废"
	.s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location",$p($g(^DHCEQEquip(EQRowID)),"^",72))
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",19))
	.s IFBNo=""
	.s ContractNo=$p($g(^DHCEQEquip(EQRowID)),"^",76)
	.s LeaveFactoryDate=$p($g(^DHCEQEquip(EQRowID)),"^",11)
	.i LeaveFactoryDate'="" s LeaveFactoryDate=$zd(LeaveFactoryDate,3)
	.s RegisterNo=$p($g(^DHCEQEquip(EQRowID,"EX")),"^",1)	//器械注冊證號
	.s HasInvoice="是"		
	.s InvoiceNo=""
	.s InStockListDR=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,InStockListDR)
	.s InvoiceNo=$p(return,"^",1)
	.;w EquipCat_"^"_EQNo_"^"_EQName_"^"_Manufactory_"^"_Model_"^"_Quantity_"^"_OriginalFee_"^"_PurchaseFee_"^"_StartDate_"^"_DisuseDate_"^"_Status_"^"_Location_"^"_UseLoc_"^"_IFBNo_"^"_ContractNo_"^"_LeaveFactoryDate_"^"_RegisterNo_"^"_HasInvoice_"^"_InvoiceNo ,!
	.s mList=EquipCat_"^"_EQNo_"^"_EQName_"^"_Manufactory_"^"_Model_"^"_Quantity_"^"_OriginalFee_"^"_PurchaseFee_"^"_StartDate_"^"_DisuseDate_"^"_Status_"^"_Location_"^"_UseLoc_"^"_IFBNo_"^"_ContractNo_"^"_LeaveFactoryDate_"^"_RegisterNo_"^"_HasInvoice_"^"_InvoiceNo
		
	.s mList=$tr(mList,",",".")
	.s mList=$tr(mList,"^",",")
	.s mList=$tr(mList,$c(13))
	.s mList=$tr(mList,$c(10))	
	.d file.WriteLine(mList)
	
    
	k ^TMP("XMLBSum",$j)


	d file.Close()
	q 0
}

// add by zc0128 2023-01-17 河北省卫健委接口 begin

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).InsertContrastType()
ClassMethod InsertContrastType()
{
	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_EquipType', '类组-记账科目', 'DHCEQCEquipType', '011', '2','HBWJW','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_Origin', '设备来源-资产来源', 'DHCEQCOrigin', '011', '2','HBWJW','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_DepreMethod', '折旧方法-折旧方法', 'DHCEQCDepreMethod', '011', '2','HBWJW','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_Expenditures', '经费来源', 'DHCEQCExpenditures', '011', '2','HBWJW','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_BuildingStruct', '建筑结构', 'DHCEQCBuildingStruct', '011', '2','HBWJW','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCContrastType (CT_Code,CT_Desc,CT_DataType, CT_Mask, CT_ContrastType,CT_AppName,CT_InvalidFlag)
	VALUES ('HBWJW_PurposeType', '资产用途', 'DHCEQCPurposeType', '011', '2','HBWJW','N'))
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAsset(1)
ClassMethod GetOneAsset(RowID As %Library.String = "", pSnapID As %Library.String = "")
{
	s $ZT="ERRORGetOneAsset"
	s ObjEquip=##Class(User.DHCEQEquip).%OpenId(RowID)
	s ObjEquipNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjEquip)
	s EquipInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	d EquipInfo.%Set("SAASDM",..#SAASDM)
	d EquipInfo.%Set("YQBH",ObjEquip.EQNo)
	d EquipInfo.%Set("YQMC",ObjEquip.EQName)
	s FLH=$e(ObjEquip.EQEquiCatDR.ECCode,1,7)
	d EquipInfo.%Set("FLH",FLH)
	//Modify by zx 2022-04-21
	;s StoreLocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",ObjEquip.EQStoreLocDR)),"^",20)
	s StoreLocCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",67),"0",6)
	d EquipInfo.%Set("SYDW",StoreLocCode)	//使用科室编码
	//Modify by zx 2022-04-21
	s LocManageUserCode=""
	s LocTypeID=""
	s StoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",67),""))
	i StoreLLocTypeDR'="" d
	.s LocTypeID=$p($g(^DHCEQCCode("DHCEQCLocType",StoreLLocTypeDR)),"^",1)
	.s LocmManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",StoreLLocTypeDR)),"^",6)
	.i LocmManageUserDR'="" s LocManageUserCode=##class(web.DHCEQCCounter).LPAD(LocmManageUserDR,"0",6)
	d EquipInfo.%Set("SYR",LocManageUserCode)		//使用责任人编码
	i LocManageUserCode="" d EquipInfo.%Set("SYR","654321")
	s LocationCode=""
	s LocationDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",67))),"^",2)
	i $p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",72)'="" s LocationCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",72),"0",6)
	s LocationDR=""
	i LocationCode="" d
	.s LocationCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",67),"0",6)
	d EquipInfo.%Set("CFDD",LocationCode)	//存放地点编码
	s DepreMethod=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCDepreMethod",ObjEquipNew.EQDepreMethodDR)
	d EquipInfo.%Set("ZJ",$p(DepreMethod,"^",2))	//折旧方法编码
	d EquipInfo.%Set("LJZJ",+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",35),""))
	d EquipInfo.%Set("ZMJZ",##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",28),""))
	//Modify by zx 2021-04-21
	s LocTypeCode=""
	i LocTypeID'="" s LocTypeCode=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LocTypeID)),"^",2)
	s PurposeTypeCode=$CASE(LocTypeCode,"0205":"201000",:"204000")
	//01 在用 02未使用  03不需用 04 待报废  05毁坏不能用  09其他
	s EQStatus=$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",38)
	s EQAdvanceDisFlag=$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",93)
	s XZ=""
	i EQStatus=0  d
	.s XZ="3" 
	e   i EQStatus=1  d
	.s XZ="1" 
	e   i EQStatus=2  d
	.i EQAdvanceDisFlag=2 d
	..s XZ="4" 
	d EquipInfo.%Set("XZ",XZ)	//使用状况编码
	
	s Origin=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCOrigin",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",20))
	d EquipInfo.%Set("ZCLY",$p(Origin,"^",2))	//资产来源编码
	s EQAccountNo= ""  //ObjEquip.EQAccountNo
	if (EQAccountNo="")
	{
		s InStockListDR=ObjEquipNew.EQInStockListDR
		i InStockListDR'=""
		{
			s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
			i InStockDR'=""
			{
				s EQAccountNo=$p($g(^DHCEQInStock(InStockDR)),"^",14)
			}
		}
	}	
	d EquipInfo.%Set("PZH",EQAccountNo)

	d EquipInfo.%Set("FLH16",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID,"OtherInfo")),"^",17))
	s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",27),"")
	s FinanceFee=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetFundsAmountByFundsType(RowID,pSnapID,2)
	d EquipInfo.%Set("CZBK",FinanceFee)
	d EquipInfo.%Set("FCZBK",##Class(web.DHCEQCommon).FormatNumber((OriginalFee-FinanceFee),""))
	s WXEquipTypeDRs=","_##class(web.DHCEQCommon).GetSysInfo("990023")_","
	s EQEquipTypeDR=","_$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",63)_"," 
	if WXEquipTypeDRs[EQEquipTypeDR 
	{
		d EquipInfo.%Set("DWKJKM","1701")
	}
	else
	{
		d EquipInfo.%Set("DWKJKM","1601")
	}
	d EquipInfo.%Set("PZPZDW",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID,"OtherInfo")),"^",36))
	d EquipInfo.%Set("SFRZ",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID,"OtherInfo")),"^",16))
	s EQManageLocDR=$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",17)
	s EQManageLocCode=""
	i EQManageLocDR'="" s EQManageLocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",EQManageLocDR)),"^",20)
	i EQManageLocDR="" s EQManageLocCode=##class(web.DHCEQCCounter).LPAD(EQManageLocDR,"0",6)
	;d EquipInfo.%Set("GLBM",EQManageLocCode)
	s EQManageUserCode=""
	s EQManageUserDR=$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",39)
	i EQManageUserDR'="" s EQManageUserCode=##class(web.DHCEQCCounter).LPAD(EQManageUserDR,"0",6)
	d EquipInfo.%Set("GLR",EQManageUserCode)
	if ($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",82)="Y")
	{
		d EquipInfo.%Set("GXGY","1")
	}
	else
	{
		d EquipInfo.%Set("GXGY","2")
	}
	d EquipInfo.%Set("SYZRZT",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID,"OtherInfo")),"^",37))
	d EquipInfo.%Set("BEIZHU",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",34))


	d EquipInfo.%Set("RZRQ",##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date"))	//
	//s Expenditures=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCExpenditures",ObjEquip.EQHold10)
	s FundsExpenditures=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfoNew(RowID)
	d EquipInfo.%Set("JFKM",FundsExpenditures)	//经费来源编码
	d EquipInfo.%Set("GZRQ",##class(web.DHCEQCommon).TransValueToPage(ObjEquipNew.EQAddDate,"date"))	//
	d EquipInfo.%Set("JZLX","3")	//价值类型编码
	d EquipInfo.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",27),""))
	s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ObjEquipNew.EQInStockListDR)
	s InvoiceNos=$p(InvoiceInfo,"^",1)
	d EquipInfo.%Set("FPH",InvoiceNos)	//发票号
	i InvoiceNos="" d EquipInfo.%Set("FPH","1")
	s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
	i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
	//d EquipInfo.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	
	s EQPurposeTypeDR=ObjEquipNew.EQPurposeTypeDR
	i EQPurposeTypeDR=""
	{
		s PurposeSetInfo=##Class(web.DHCEQ.EM.CTPurposeSet).GetPurposeSet($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",19),"")
		s EQPurposeTypeDR=$p(PurposeSetInfo,"^",1)
	}
	s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",EQPurposeTypeDR)
	s CurPurposeTypeCode=$p(PurposeType,"^",2)
	i CurPurposeTypeCode="" s CurPurposeTypeCode=PurposeTypeCode
	//d EquipInfo.%Set("LKX",CurPurposeTypeCode)	//资产使用用途编码
	s EQBuyTypeCode=""
	i ObjEquip.EQBuyTypeDR'="" s EQBuyTypeCode=$p($g(^DHCEQCCode("DHCEQCBuyType",ObjEquip.EQBuyTypeDR)),"^",1)
	i EQBuyTypeCode="" s EQBuyTypeCode="2"
	//设置空属性开始
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("SCCJ","")	
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	d specificData.%Set("XSS","")	//坐落位置
	d specificData.%Set("CCH","")	//土地使用权类型编码  1出让 2划拨 3租赁 9其他
	d specificData.%Set("DJH","")	//房屋产权权属证号
	d specificData.%Set("FW_CQXS","")	//产权形式编码 1有产权 2无产权 3产权待界定
	d specificData.%Set("TD_ZMMJ","")	//房屋使用权（证载）面积
	d specificData.%Set("TD_QSXZ","")	//权属性质编码
	d specificData.%Set("TD_FZRQ","")	//房屋产权证发证日期
	d specificData.%Set("GG","")	//土地产权形式编码 1有产权 2无产权 3产权待界定
	d specificData.%Set("SYNX_SONG","")	//权属年限
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("TD",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	d specificData.%Set("XSS","")	//坐落位置
	d specificData.%Set("SYNX_SONG","")	//权属年限
	d specificData.%Set("MJ","")	//数量/建筑面积
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("FSSS",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	d specificData.%Set("XSS","")	//坐落位置
	//01钢结构  02钢混结构  03砖混结构 04砖木结构 05其他  DHC_EQCBuildingStruct
	//s BuildingStruct=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCBuildingStruct",$p(ObjBuilding,"^",2))
	d specificData.%Set("XH","")	//建筑结构编码
	d specificData.%Set("FW_JZMJ","")	//建筑面积
	d specificData.%Set("FW_CQXS","")	//产权形式编码 1有产权 2无产权 3产权待界定
	d specificData.%Set("FW_QSZM","")	//房屋产权权属证明
	d specificData.%Set("DJH","")	//房屋产权权属证号
	d specificData.%Set("CZR","")	//房屋产权持证人编码
	d specificData.%Set("FW_SYQR","")	//房屋产权所有权人
	d specificData.%Set("TD_QSXZ","")	//权属性质编码
	d specificData.%Set("GBM","")	//房屋产权来源
	d specificData.%Set("SYNX_SONG","")	//权属年限
	d specificData.%Set("FW_FZRQ","")	//房屋产权证发证日期
	d specificData.%Set("FW_ZMMJ","")	//房屋使用权（证载）面积
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("FW",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	d specificData.%Set("XSS","")	//坐落位置
	d specificData.%Set("MJ","")	//数量/建筑面积
	d specificData.%Set("SYNX_SONG","")	//权属年限
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("GZW",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("XH","")	//规格型号
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("PQL","")	//汽车排气量编码
	d specificData.%Set("JT_CPXH","")	//厂牌型号
	d specificData.%Set("WX_DJRQ","")	//注册登记日期
	d specificData.%Set("SYNX_SONG","")	//预计使用年限
	d specificData.%Set("JT_BZQK","")	//资产编制情况编码
	d specificData.%Set("TPH","")	//车辆用途编码
	d specificData.%Set("CZR","")	//持证人编码
	d specificData.%Set("CL_XSZ","")	//车辆有无行驶证编码
	d specificData.%Set("JCNF","")	//车牌号
	d specificData.%Set("CCH","")	//发动机号
	d specificData.%Set("GG","")	//车辆识别代码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("CAR",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("XH","")	//规格型号
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码	
	d specificData.%Set("SB_PP","")	//品牌
	//s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",ObjEquipNew.EQPurposeTypeDR)
	d specificData.%Set("LKX",CurPurposeTypeCode)	//资产使用用途编码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("TYSB",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("XH","")	//规格型号
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("SB_PP","")	//品牌
	//s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",ObjEquipNew.EQPurposeTypeDR)
	d specificData.%Set("LKX",CurPurposeTypeCode)	//资产使用用途编码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("ZYSB",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("DJH","")	//文物等级编码
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("WW",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d specificData.%Set("TPH","")	//图书册数
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码	
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("BOOKS",DataObj)	
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码		
	d specificData.%Set("JJ_PP","")	//品牌truct
	d specificData.%Set("GG","")	//质料和规格
	d specificData.%Set("SYNX_SONG","")	//预计使用年限
	d specificData.%Set("JJ_SHL","")	//数量
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("JJ",DataObj)	
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码	
	d specificData.%Set("GG","")	//质料和规格
	d specificData.%Set("SYNX_SONG","")	//预计使用年限
	d specificData.%Set("BF_SHL","")	//数量
	d DataObj.Insert(specificData)
	d EquipInfo.%Set("BF",DataObj)	
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("ANIMALS",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("PLANTS",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
	d specificData.%Set("CZDFDW","")	//发明人
	d specificData.%Set("WX_DJJG","")	//登记机构
	d specificData.%Set("WX_DJRQ","")	//注册登记日期
	d specificData.%Set("WX_PZWH","")	//批准文号
	d specificData.%Set("TD_FZRQ","")	//授权公告日
	d specificData.%Set("CJDFDW","")	//发明名称
	d specificData.%Set("BTZDW","")	//证书号
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("WXZC-ZL",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
	d specificData.%Set("CZDFDW","")	//发明人
	d specificData.%Set("WX_DJJG","")	//登记机构
	d specificData.%Set("WX_DJRQ","")	//注册登记日期
	d specificData.%Set("WX_PZWH","")	//批准文号
	d specificData.%Set("BTZDW","")	//证书号
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("WXZC-SH",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
	d specificData.%Set("CZDFDW","")	//发明人
	d specificData.%Set("TD_FZRQ","")	//出版日期
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("WXZC-ZZQ",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
	d specificData.%Set("CZDFDW","")	//发明人
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("WXZC-FZL",DataObj)
	
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
	d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
	d specificData.%Set("FW_SYQSRQ","")	//投入使用日期
	//11 集中采购机构采购 12部门集中采购 2分散采购
	d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
	d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
	d specificData.%Set("CZDFDW","")	//发明人
	d DataObj.Insert(specificData)	
	d EquipInfo.%Set("WXZC-ZYZZ",DataObj)
	//设置空属性结束
	
	s EquipCatCode=ObjEquip.EQEquiCatDR.ECCode
	s DataObj=##class(%ListOfDataTypes).%New()
	s specificData=##class(web.DHCEQ.Plat.JsonObject).%New()
	if $e(EquipCatCode,1)=1
	{
		s BDRowID=$o(^DHCEQBuilding(0,"EquipDR",RowID,0))
		s ObjBuilding=""
		i BDRowID'="" s ObjBuilding=$Get(^DHCEQBuilding(BDRowID))
		s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",44),"date")
		i FWSYQSRQ="" s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date")
		d specificData.%Set("FW_SYQSRQ",FWSYQSRQ)	//投入使用日期
		
		d specificData.%Set("XSS",$p(ObjBuilding,"^",6))	//坐落位置
		if $e(EquipCatCode,3)=1
		{
			d specificData.%Set("CCH","")	//土地使用权类型编码  1出让 2划拨 3租赁 9其他
			d specificData.%Set("DJH",$p(ObjBuilding,"^",17))	//房屋产权权属证号
			d specificData.%Set("FW_CQXS","1")	//产权形式编码 1有产权 2无产权 3产权待界定
			d specificData.%Set("FW_ZMMJ",$p(ObjBuilding,"^",4))	//房屋使用权（证载）面积
			d specificData.%Set("TD_QSXZ","")	//权属性质编码
			d specificData.%Set("FW_FZRQ",##class(web.DHCEQCommon).TransValueToPage($p(ObjBuilding,"^",18),"date"))	//房屋产权证发证日期
			d specificData.%Set("SYNX_SONG",$p(ObjBuilding,"^",29))	//权属年限
			
			d DataObj.Insert(specificData)	
			d EquipInfo.%Set("TD",DataObj)
		}elseif $e(EquipCatCode,3)=2
		{
			if $e(EquipCatCode,4,5)=90
			{
				d specificData.%Set("SYNX_SONG",$p(ObjBuilding,"^",29))	//权属年限
				d specificData.%Set("MJ",$p(ObjBuilding,"^",3))	//数量/建筑面积
				//11 集中采购机构采购 12部门集中采购 2分散采购
				d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
				//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
				s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
				i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
				d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
				d DataObj.Insert(specificData)	
				d EquipInfo.%Set("FSSS",DataObj)
			}
			else
			{
				//01钢结构  02钢混结构  03砖混结构 04砖木结构 05其他  DHC_EQCBuildingStruct
				s BuildingStruct=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCBuildingStruct",$p(ObjBuilding,"^",2))
				//d specificData.%Set("XH",$p(BuildingStruct,"^",2))	//建筑结构编码
				d specificData.%Set("FW_JZMJ",$p(ObjBuilding,"^",3))	//建筑面积
				d specificData.%Set("FW_CQXS",$p(ObjBuilding,"^",7))	//产权形式编码 1有产权 2无产权 3产权待界定
				d specificData.%Set("FW_QSZM",$p(ObjBuilding,"^",16))	//房屋产权权属证明
				d specificData.%Set("DJH",$p(ObjBuilding,"^",17))	//房屋产权权属证号
				d specificData.%Set("CZR","")	//房屋产权持证人编码
				d specificData.%Set("FW_SYQR",$p(ObjBuilding,"^",30))	//房屋产权所有权人
				d specificData.%Set("TD_QSXZ","")	//权属性质编码
				d specificData.%Set("GBM","")	//房屋产权来源
				//d specificData.%Set("SYNX_SONG",$p(ObjBuilding,"^",29))	//权属年限
				d specificData.%Set("FW_FZRQ",##class(web.DHCEQCommon).TransValueToPage($p(ObjBuilding,"^",18),"date"))	//房屋产权证发证日期
				d specificData.%Set("FW_ZMMJ",$p(ObjBuilding,"^",4))	//房屋使用权（证载）面积
				s BModelDR=$p(ObjBuilding,"^",44)
				i BModelDR'="" s BModelDR="0"_BModelDR
				d specificData.%Set("XH",BModelDR)
				d specificData.%Set("GG",##Class(web.DHCEQCommon).GetTrakNameByID("buildpruposecode", $p(ObjBuilding,"^",43)))	//土地产权形式编码 1有产权 2无产权 3产权待界定
				d specificData.%Set("SYNX_SONG",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",35))	//权属年限
				d DataObj.Insert(specificData)	
				d EquipInfo.%Set("FW",DataObj)
			}
			
		}elseif $e(EquipCatCode,3)=3
		{
				d specificData.%Set("MJ",$p(ObjBuilding,"^",3))	//数量/建筑面积
				d specificData.%Set("SYNX_SONG",$p(ObjBuilding,"^",29))	//权属年限
				//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
				s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
				i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
				d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
				//11 集中采购机构采购 12部门集中采购 2分散采购
				d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
				d DataObj.Insert(specificData)	
				d EquipInfo.%Set("GZW",DataObj)
		}
	}
	elseif (($e(EquipCatCode,1)=2)||($e(EquipCatCode,1)=3))
	{
		d specificData.%Set("XH",ObjEquip.EQModelDR.MDesc)	//规格型号
		i ObjEquip.EQModelDR.MDesc="" d specificData.%Set("XH","/")	
		//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
		s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
		i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
		d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
		s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",44),"date")
		i FWSYQSRQ="" s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date")
		d specificData.%Set("FW_SYQSRQ",FWSYQSRQ)	//投入使用日期
		//11 集中采购机构采购 12部门集中采购 2分散采购
		d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
		if $e(EquipCatCode,1,3)=203
		{
			d specificData.%Set("PQL","")	//汽车排气量编码
			d specificData.%Set("JT_CPXH","")	//厂牌型号
			d specificData.%Set("WX_DJRQ","")	//注册登记日期
			d specificData.%Set("SYNX_SONG",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",31))	//预计使用年限
			d specificData.%Set("JT_BZQK","")	//资产编制情况编码
			d specificData.%Set("TPH","")	//车辆用途编码
			d specificData.%Set("CZR","")	//持证人编码
			d specificData.%Set("CL_XSZ","")	//车辆有无行驶证编码
			d specificData.%Set("JCNF","")	//车牌号
			d specificData.%Set("CCH","")	//发动机号
			d specificData.%Set("GG","")	//车辆识别代码
			d DataObj.Insert(specificData)	
			d EquipInfo.%Set("CAR",DataObj)
		}
		else
		{
			s Brand=""
			if $p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94)'="" s Brand=$p($g(^DHCEQCCode("DHCEQCBrand",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94))),"^",3)
			if Brand="" s Brand="/"
			d specificData.%Set("SB_PP",Brand)	//品牌
			
			s EQPurposeTypeDR=ObjEquipNew.EQPurposeTypeDR
			i EQPurposeTypeDR=""
			{
				s PurposeSetInfo=##Class(web.DHCEQ.EM.CTPurposeSet).GetPurposeSet($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",19),ObjEquipNew.EQEquipTypeDR)
				s EQPurposeTypeDR=$p(PurposeSetInfo,"^",1)
			}
			s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",EQPurposeTypeDR)
			s CurPurposeTypeCode=$p(PurposeType,"^",2)
			i CurPurposeTypeCode="" s CurPurposeTypeCode=PurposeTypeCode
			d specificData.%Set("LKX",CurPurposeTypeCode)	//资产使用用途编码
			d specificData.%Set("SYNX_SONG",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",31))	//预计使用年限
			if ($e(EquipCatCode,1)=2)
			{
				d DataObj.Insert(specificData)	
				d EquipInfo.%Set("TYSB",DataObj)
			}
			else
			{
				d DataObj.Insert(specificData)	
				d EquipInfo.%Set("ZYSB",DataObj)
			}
		}
	}
	elseif $e(EquipCatCode,1)=4
	{
		//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
		s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
		i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
		d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
		d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
		//11 集中采购机构采购 12部门集中采购 2分散采购
		d specificData.%Set("DJH","")	//文物等级编码
		d DataObj.Insert(specificData)	
		d EquipInfo.%Set("WW",DataObj)
	}
	elseif $e(EquipCatCode,1)=5
	{
		d specificData.%Set("TPH","0")	//图书册数
		//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
		s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
		i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
		d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
		s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",44),"date")
		i FWSYQSRQ="" s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date")
		d specificData.%Set("FW_SYQSRQ",FWSYQSRQ)	//投入使用日期
		//11 集中采购机构采购 12部门集中采购 2分散采购
		d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码
		d DataObj.Insert(specificData)		
		d EquipInfo.%Set("BOOKS",DataObj)	
	}
	elseif $e(EquipCatCode,1)=6
	{
		//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
		s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
		i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
		d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
		s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",44),"date")
		i FWSYQSRQ="" s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date")
		d specificData.%Set("FW_SYQSRQ",FWSYQSRQ)	//投入使用日期
		//11 集中采购机构采购 12部门集中采购 2分散采购
		d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码	
		if $e(EquipCatCode,3)=1
		{
			s Brand=""
			if $p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94)'="" s Brand=$p($g(^DHCEQCCode("DHCEQCBrand",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94))),"^",3)
			if Brand="" s Brand="/"
			d specificData.%Set("JJ_PP",Brand)	//品牌truct
			d specificData.%Set("GG",ObjEquip.EQModelDR.MDesc)	//质料和规格
			i ObjEquip.EQModelDR.MDesc="" d specificData.%Set("GG","/")	
			s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",EQPurposeTypeDR)
			s CurPurposeTypeCode=$p(PurposeType,"^",2)
			i CurPurposeTypeCode="" s CurPurposeTypeCode=PurposeTypeCode
			d specificData.%Set("LKX",CurPurposeTypeCode)
			d specificData.%Set("SYNX_SONG",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",31))	//预计使用年限
			d specificData.%Set("JJ_SHL","1")	//数量
			d DataObj.Insert(specificData)		
			d EquipInfo.%Set("JJ",DataObj)	
		}elseif $e(EquipCatCode,3)=2
		{
			s Brand=""
			if $p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94)'="" s Brand=$p($g(^DHCEQCCode("DHCEQCBrand",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",94))),"^",3)
			if Brand="" s Brand="/"
			d specificData.%Set("JJ_PP",Brand)	//品牌
			s PurposeType=##class(web.DHCEQ.Plat.CTContrastInfo).GetContractInfo("HBWJW","DHCEQCPurposeType",EQPurposeTypeDR)
			s CurPurposeTypeCode=$p(PurposeType,"^",2)
			i CurPurposeTypeCode="" s CurPurposeTypeCode=PurposeTypeCode
			d specificData.%Set("LKX",CurPurposeTypeCode)	//资产使用用途编码
			d specificData.%Set("GG",ObjEquip.EQModelDR.MDesc)	//质料和规格
			i ObjEquip.EQModelDR.MDesc="" d specificData.%Set("GG","/")	
			d specificData.%Set("SYNX_SONG",$p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",31))	//预计使用年限
			d specificData.%Set("BF_SHL","")	//数量
			d DataObj.Insert(specificData)		
			d EquipInfo.%Set("BF",DataObj)	
		}
		elseif $e(EquipCatCode,3)=3
		{
			d DataObj.Insert(specificData)		
			d EquipInfo.%Set("ANIMALS",DataObj)
		}
		elseif $e(EquipCatCode,3)=4
		{
			d DataObj.Insert(specificData)	
			d EquipInfo.%Set("PLANTS",DataObj)
		}
	}
	elseif $e(EquipCatCode,1)=7
	{
		//01自用 02经营 03出借  04出租 05部分出租  06对外投资 07担保 08其他
		s EQDirectionsUseCode=ObjEquip.EQDirectionsUseDR.DUCode
		i EQDirectionsUseCode="" s EQDirectionsUseCode="01"
		d specificData.%Set("SYFX",EQDirectionsUseCode)	//使用方向编码
		s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",44),"date")
		i FWSYQSRQ="" s FWSYQSRQ=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSnapShot(pSnapID,"Equip",RowID)),"^",45),"date")
		d specificData.%Set("FW_SYQSRQ",FWSYQSRQ)	//投入使用日期
		//11 集中采购机构采购 12部门集中采购 2分散采购
		d specificData.%Set("CGZZXS",EQBuyTypeCode)	//采购组织形式编码	
			d specificData.%Set("WX_ZLH","")	//专利号  著作权证书号
			d specificData.%Set("CZDFDW","")	//发明人
		if $e(EquipCatCode,3)=1	//专利
		{
			d specificData.%Set("WX_DJJG","")	//登记机构
			d specificData.%Set("WX_DJRQ","")	//注册登记日期
			d specificData.%Set("WX_PZWH","")	//批准文号
			d specificData.%Set("TD_FZRQ","")	//授权公告日
			d specificData.%Set("CJDFDW","")	//发明名称
			d specificData.%Set("BTZDW","")	//证书号
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-ZL",DataObj)
		}elseif ($e(EquipCatCode,3,5)=701||$e(EquipCatCode,3,5)=702)	//商号、标志
		{
			d specificData.%Set("WX_DJJG","")	//登记机构
			d specificData.%Set("WX_DJRQ","")	//注册登记日期
			d specificData.%Set("WX_PZWH","")	//批准文号
			d specificData.%Set("BTZDW","")	//证书号
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-SH",DataObj)
		}elseif $e(EquipCatCode,3)=3	//著作权
		{
			d specificData.%Set("TD_FZRQ","")	//出版日期
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-ZZQ",DataObj)
		}
		elseif $e(EquipCatCode,3)=2	//非专利技术
		{
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-FZL",DataObj)
		}
		elseif $e(EquipCatCode,3)=4	//资源资质
		{
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-ZYZZ",DataObj)
		}elseif ($e(EquipCatCode,3,5)=703||$e(EquipCatCode,3,5)=704)	//商誉、管理经营
		{
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-SY",DataObj)
		}
		elseif $e(EquipCatCode,3)=6 //信息数据
		{
			d DataObj.Insert(specificData)
			d EquipInfo.%Set("WXZC-XXSJ",DataObj)
		}
	}
	q EquipInfo
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERRORGetOneAsset
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by zy 2022-2-22
/// 固定资产新增
/// Input:输入参数:	YYYY-MM
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","AssetAdd","2022-10")
Query AssetAdd(MonthStr) As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod AssetAddExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") 
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.//q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.;q:((EquipType=8)||(EquipType=9)||(EquipType=10))
	.q:((","_FacilityEquipType_",")[(","_EquipType_","))
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.//i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s InStock=0
	..f  s InStock=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,InStock)) q:(InStock="")  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(InStock)),"^",25)   //Add By CZF 2016-12-07 begin
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(InStock)),"^",10)
	...q:ISStatus'=2		//Add By CZF 2016-12-07 end
	...s ISNo=$p($g(^DHCEQInStock(InStock)),"^",14) //2011-07-22 DJ
	...q:ISNo="" //2011-07-22 DJ
	...q:ISNo'="2212296000215"
	...s InStockList=0
	...f  s InStockList=$o(^DHCEQInStockList(0,"InStock",InStock,InStockList)) q:(InStockList="")  d
	....q:$p($g(^DHCEQInStockList(InStockList)),"^",22)'=""	// Mozy0217  2018-11-01	过滤设备配置的入库明细
	....s StoreLocDR=0
	....f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockList,StoreLocDR))  quit:StoreLocDR=""  d
	.....s EquipID=0
	.....f  s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockList,StoreLocDR,EquipID))  quit:EquipID=""  d
	......s EquipData=$g(^DHCEQEquip(EquipID))
	......q:$p(EquipData,"^",38)>2	//报废或其他
	......q:$p(EquipData,"^",59)="Y"	//无效
	......q:$p(EquipData,"^",60)'="1"	//还未入库
	......//s EquipNo=$p(EquipData,"^",71)
	......s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAsset(EquipID,SnapID)
	......s Data=Data.%ToJSON()
	......//s Data=EquipID
	......d OutputRowAssetAdd
	Quit $$$OK
OutputRowAssetAdd
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod AssetAddFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetAddExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod AssetAddClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetAddExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetMove(823)
ClassMethod GetOneAssetMove(BussID, pSnapID As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "")
{
	s $ZT="ERROROneAssetMove"
	s ObjMove=##Class(User.DHCEQStoreMove).%OpenId(BussID)
	s ObjMoveNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMove)
	s MoveInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d MoveInfo.%Set("BDBGBH",ObjMove.SMStoreMoveNo)
	d MoveInfo.%Set("SAASDM",..#SAASDM)
	d MoveInfo.%Set("RZRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.SMInAckDate,"date")) ///入账日期
	d MoveInfo.%Set("PZH",ObjMove.SMStoreMoveNo)	//凭证号
	d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD(ObjMove.SMMakerDR,"0",6))	//变动单申请人编码
	d MoveInfo.%Set("BDRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.SMInAckDate,"date"))		//变动日期
	d MoveInfo.%Set("BDYY","资产变动使用部门")	//变动原因
	d MoveInfo.%Set("DJBZ",1)	//变动类型0单价  1  使用科室，存放地点，使用人
	;s FromLoc=$p($g(^DHCEQCCode("DHCEQCDepartment",ObjEquip.EQStoreLocDR)),"^",20)
	s FromLoc=##class(web.DHCEQCCounter).LPAD(ObjMove.SMFromLocDR,"0",6)
	;s FromLoc=ObjMove.SMFromLocDR
	;s ToLoc=$p($g(^DHCEQCCode("DHCEQCDepartment",ObjEquip.EQStoreLocDR)),"^",20)
	s ToLoc=##class(web.DHCEQCCounter).LPAD(ObjMove.SMToLocDR,"0",6)
	;s ToLoc=ObjMove.SMToLocDR
	
	s Data=##class(%ListOfDataTypes).%New()
	s ListRowID=0
	f  s ListRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,ListRowID)) q:(ListRowID="")  d
	.q:$p($g(^DHCEQStoreMoveList(ListRowID)),"^",15)'="" // Mozy0217  2018-11-01	过滤设备配置的转移明细
	.s BatchFlag=$P(^DHCEQStoreMoveList(ListRowID),"^",3)
	.i BatchFlag="Y" d
	..s RowIDs=$G(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs"))
	..s equipRowIDs=RowIDs
	.e  d
	..s EquipDR=$P(^DHCEQStoreMoveList(ListRowID),"^",2)
	..s equipRowIDs=EquipDR
	.s count=$l(equipRowIDs,",")
	.f k=1:1:count d
	..s EquipDR=$p(equipRowIDs,",",k)
	..q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipInReduce(EquipDR,pSnapID,StartDate,EndDate)'=0
	..i EquipDR'=""  d
	...s EquipData=$g(^DHCEQSnapShot(pSnapID,"Equip",EquipDR)) 
	...s EquipNo=$p(EquipData,"^",71)
	...s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	...d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	...d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	...s OneZCDM =$e($p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1),1,7)
	...d OneData.%Set("ZCDM",OneZCDM)  //资产分类号
	...d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	...i $p(EquipData,"^",66)="" d OneData.%Set("SYR","654321") 
	...d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	...d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	...i $p(EquipData,"^",72)="" d OneData.%Set("CFDD","000001") 
	...d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	...d OneData.%Set("BDXM","使用部门") //变动项目：0单价  1  使用科室，存放地点，使用人
	...d OneData.%Set("BDQNR",FromLoc_":"_##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMove.SMFromLocDR)) //变动前内容
	...d OneData.%Set("BDHNR",ToLoc_":"_##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMove.SMToLocDR)) //变动后内容
	...d Data.Insert(OneData)
	
	d MoveInfo.%Set("DATA",Data)	//变动类型
	q MoveInfo
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetMove
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by zy 2022-2-22
/// 固定资产转移
/// Input:输入参数:	YYYY-MM
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","AssetMove","2022-10")
Query AssetMove(MonthStr) As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod AssetMoveExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") 
	s EquipType=0
	f  s EquipType=$o(^DHCEQStoreMove(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:((EquipType=8)||(EquipType=9)||(EquipType=10))
	.q:((","_FacilityEquipType_",")[(","_EquipType_","))
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s BussID=0
	..f  s BussID=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate,BussID)) q:(BussID="")  d
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(BussID)),"^",27)
	...q:SMInvalidFlag="Y"
	...s SMStatus=$p($g(^DHCEQStoreMove(BussID)),"^",13)
	...q:SMStatus'=2
	...;q:$p($g(^DHCEQStoreMove(BussID)),"^",1)'="2210181000017"
	...q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipReduce(BussID,SnapID,StartDate,EndDate)'=0
	...s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetMove(BussID,SnapID)
	...s Data=Data.%ToJSON()
	...d OutputRowAssetMove
	
	s ETRowID=0
	f  s ETRowID=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID))  q:ETRowID=""  d
	.s AuditDate=StartDate-1
	.f  s AuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID,AuditDate))  q:(AuditDate="")||(AuditDate>EndDate)  d
	..s CARowID=0
	..f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID,AuditDate,CARowID))  q:CARowID=""  d
	...q:$p($g(^DHCEQChangeAccount(CARowID)),"^",11)'=2
	...q:$p($g(^DHCEQChangeAccount(CARowID)),"^",2)=0
	...;q:$p($g(^DHCEQEquip($p($g(^DHCEQChangeAccount(CARowID)),"^",1))),"^",20)=2
	...q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipInReduce($p($g(^DHCEQChangeAccount(CARowID)),"^",1),SnapID,StartDate,EndDate)'=0
	...s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetChange(CARowID,SnapID)
	...s Data=Data.%ToJSON()
	...d OutputRowAssetMove
	
	s ADDate=StartDate-1
	f  s ADDate=$o(^DHCEQAdjustData(0,"TypeDate",1,ADDate))  q:(ADDate="")||(ADDate>EndDate)  d
	.s ADRowID=0
	.f  s ADRowID=$o(^DHCEQAdjustData(0,"TypeDate",1,ADDate,ADRowID))  q:ADRowID=""  d
	..q:$p($g(^DHCEQAdjustData(ADRowID)),"^",11)'=1
	..q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAdjustLoc(ADRowID)=0
	..q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipInReduce($p($g(^DHCEQAdjustData(ADRowID)),"^",1),SnapID,StartDate,EndDate)'=0
	..s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetAdjust(ADRowID,SnapID)
	..s Data=Data.%ToJSON()
	..d OutputRowAssetMove

	s PreMonth=##Class(web.DHCEQReport).GetPreMonth(MonthStr)
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreMonth)
	s SERowID=0
	f  s SERowID=$o(^DHCEQSnapShot(SnapID,"Equip",SERowID))  q:SERowID=""  d
	.q:((","_FacilityEquipType_",")[(","_$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",63)_","))
	.q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipInReduce(SERowID,SnapID,StartDate,EndDate)'=0
	.;q:(##Class(web.DHCEQ.Interface.DHCEQForWJW).GetCIRowIDByEquip(SERowID,MonthStr)="")||(##Class(web.DHCEQ.Interface.DHCEQForWJW).GetCIRowIDByEquip(SERowID,MonthStr)="")
	.q:$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",20)="2"
	.q:$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",59)="Y"
	.q:'(($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",60)="1")&&($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",38)<=2))
	.q:$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",45)>(StartDate-1) 
	.q:(##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipChangedBySnap(SnapID,SERowID,PreSnapID)=1)
	.;q:($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",72)=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",72))||($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",66)=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",66))
	.s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetSnapEquip(SnapID,SERowID,PreSnapID,MonthStr)
	.s Data=Data.%ToJSON()
	.d OutputRowAssetMove
	Quit $$$OK
OutputRowAssetMove
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod AssetMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetMoveExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod AssetMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetSnapEquip(823)
ClassMethod GetOneAssetSnapEquip(SnapID, SERowID, PreSnapID, MonthStr)
{
	s $ZT="ERROROneAssetSnapEquip"
	s StartDateInfo=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s SNEndDate=$p(StartDateInfo,"^",2)

	s MoveInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d MoveInfo.%Set("SAASDM",..#SAASDM)
	s ECIRowID=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetCIRowIDByEquip(SERowID,MonthStr)
	i ECIRowID'="" d
	.d MoveInfo.%Set("BDBGBH","CI"_ECIRowID)
	.d MoveInfo.%Set("RZRQ",##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeInfo(ECIRowID)),"^",4),"date")) ///入账日期
	.d MoveInfo.%Set("PZH","CI"_ECIRowID)	//凭证号
	.d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQChangeInfo(ECIRowID)),"^",16),"0",6))	//变动单申请人编码
	.d MoveInfo.%Set("BDRQ",##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeInfo(ECIRowID)),"^",4),"date"))		//变动日期
	e  d
	.s EOLRowID=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetCIRowIDByEquip(SERowID,MonthStr)
	.i EOLRowID'="" d
	..d MoveInfo.%Set("BDBGBH","CI"_EOLRowID)
	..d MoveInfo.%Set("RZRQ",##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOperateLog(EOLRowID)),"^",5),"date")) ///入账日期
	..d MoveInfo.%Set("PZH","CI"_EOLRowID)	//凭证号
	..d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQOperateLog(EOLRowID)),"^",7),"0",6))	//变动单申请人编码
	..d MoveInfo.%Set("BDRQ",##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOperateLog(EOLRowID)),"^",5),"date"))		//变动日期
	.e  d
	..d MoveInfo.%Set("BDBGBH",MonthStr_"-"_SERowID)
	..d MoveInfo.%Set("RZRQ",##Class(web.DHCEQCommon).TransValueToPage(SNEndDate,"date")) ///入账日期
	..d MoveInfo.%Set("PZH",MonthStr_"-"_SERowID)	//凭证号
	..d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD("000001","0",6))	//变动单申请人编码
	..d MoveInfo.%Set("BDRQ",##Class(web.DHCEQCommon).TransValueToPage(SNEndDate,"date"))		//变动日期
	.
	d MoveInfo.%Set("DJBZ",1)	//变动类型0单价  1  使用科室，存放地点，使用人

	
	s Data=##class(%ListOfDataTypes).%New()
	s EquipData=$g(^DHCEQSnapShot(SnapID,"Equip",SERowID))
	i '$D(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)) d
	.s (LoctionDR,LoctionDesc,LocationCode)=""
	.s LoctionDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",72)
	.i LoctionDR'="" d
	..s LoctionDesc=$piece($g(^DHCEQCCode("DHCEQCLocation",LoctionDR)),"^",2)
	..s LocationCode=##class(web.DHCEQCCounter).LPAD(LoctionDR,"0",6)
	.e  d
	..s LoctionDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67))
	..s LocationCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67),"0",6)
	.s (ManageUserDR,ManageUser)=""
	.s StoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67),""))
	.i StoreLLocTypeDR'="" d
	..s ManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",StoreLLocTypeDR)),"^",6)
	..i ManageUserDR'="" s ManageUser=##class(web.DHCEQCCounter).LPAD(ManageUserDR,"0",6)
	.i ManageUserDR'="" d
	..d MoveInfo.%Set("BDYY","资产变动使用人")	//变动原因
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	..d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	..d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	..d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	..d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	..d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	..d OneData.%Set("BDXM","使用人") //变动项目：0单价  1  使用科室，存放地点，使用人
	..d OneData.%Set("BDQNR",":") //变动前内容
	..d OneData.%Set("BDHNR",ManageUser_":"_##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)) //变动后内容
	..d Data.Insert(OneData)
	.i LoctionDesc'="" d
	..d MoveInfo.%Set("BDYY","存放地点")	//变动原因
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	..d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	..d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	..d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	..d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	..d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	..d OneData.%Set("BDXM","存放地点") //变动项目：0单价  1  使用科室，存放地点，使用人
	..d OneData.%Set("BDQNR",":") //变动前内容
	..d OneData.%Set("BDHNR",LocationCode_":"_LoctionDesc) //变动后内容
	..d Data.Insert(OneData)
	e  d
	.s (SOLoctionDesc,SNLoctionDesc,SLocationCode,SNLocationCode)=""
	.s SOLoctionDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",72)
	.i SOLoctionDR'="" d
	..s SOLoctionDesc=$piece($g(^DHCEQCCode("DHCEQCLocation",SOLoctionDR)),"^",2)
	..s SLocationCode=##class(web.DHCEQCCounter).LPAD(SOLoctionDR,"0",6)
	.e  d
	..s SOLoctionDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",67))
	..s SLocationCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",67),"0",6)
	.s SNLoctionDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",72)
	.i SNLoctionDR'="" d
	..s SNLoctionDesc=$piece($g(^DHCEQCCode("DHCEQCLocation",SNLoctionDR)),"^",2)
	..s SNLocationCode=##class(web.DHCEQCCounter).LPAD(SNLoctionDR,"0",6)
	.e  d
	..s SNLoctionDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67))
	..s SNLocationCode=##class(web.DHCEQCCounter).LPAD($p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67),"0",6)
	.s (SOManageUser,SNManageUser,SNManageUserDR,SOManageUserDR)=""
	.s SOStoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",67),""))
	.i SOStoreLLocTypeDR'="" d
	..s SOManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",SOStoreLLocTypeDR)),"^",6)
	..i SOManageUserDR'="" s SOManageUser=##class(web.DHCEQCCounter).LPAD(SOManageUserDR,"0",6)
	.s SNStoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67),""))
	.i SNStoreLLocTypeDR'="" d
	..s SNManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",SNStoreLLocTypeDR)),"^",6)
	..i SNManageUserDR'="" s SNManageUser=##class(web.DHCEQCCounter).LPAD(SNManageUserDR,"0",6)
	.i SOManageUserDR'=SNManageUserDR d
	..d MoveInfo.%Set("BDYY","资产变动使用人")	//变动原因
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	..d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	..d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	..i $p(EquipData,"^",66)="" d OneData.%Set("SYR","654321") 
	..d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	..d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	..i $p(EquipData,"^",72)="" d OneData.%Set("CFDD","000001") 
	..d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	..d OneData.%Set("BDXM","使用人") //变动项目：0单价  1  使用科室，存放地点，使用人
	..d OneData.%Set("BDQNR",SOManageUserDR_":"_##class(web.DHCEQCommon).GetTrakNameByID("user",SOManageUserDR)) //变动前内容
	..d OneData.%Set("BDHNR",SNManageUser_":"_##class(web.DHCEQCommon).GetTrakNameByID("user",SNManageUser)) //变动后内容
	..d Data.Insert(OneData)
	.i SOLoctionDesc'=SNLoctionDesc d
	..d MoveInfo.%Set("BDYY","资产变动存放地点")	//变动原因
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	..d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	..d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	..i $p(EquipData,"^",66)="" d OneData.%Set("SYR","654321") 
	..d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	..d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	..i $p(EquipData,"^",72)="" d OneData.%Set("CFDD","000001") 
	..d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	..d OneData.%Set("BDXM","存放地点") //变动项目：0单价  1  使用科室，存放地点，使用人
	..d OneData.%Set("BDQNR",SLocationCode_":"_SOLoctionDesc) //变动前内容
	..d OneData.%Set("BDHNR",SNLocationCode_":"_SNLoctionDesc) //变动后内容
	..d Data.Insert(OneData)
	
	
	
	d MoveInfo.%Set("DATA",Data)	//变动类型
	q MoveInfo
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetSnapEquip
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetCIRowIDByEquip()
ClassMethod GetCIRowIDByEquip(SERowID, MonthStr)
{
	i SERowID="" q ""
	s CStartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s CIEndDate=$p(CStartDate,"^",2)
	s CIStartDate=$p(CStartDate,"^",1)
	s MaxCIRowID=0
	s CIRowID=0
	f  s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",SERowID,2,52,SERowID,CIRowID)) q:CIRowID=""  d
	.q:($p($g(^DHCEQChangeInfo(CIRowID)),"^",4)<CIStartDate)||($p($g(^DHCEQChangeInfo(CIRowID)),"^",4)>CIEndDate)
	.i CIRowID>MaxCIRowID d
	..s MaxCIRowID=CIRowID
	i MaxCIRowID=0 q ""
	i MaxCIRowID>0 q MaxCIRowID
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOLRowIDByEquip()
ClassMethod GetOLRowIDByEquip(SERowID, MonthStr)
{
	i SERowID="" q ""
	s OStartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s OLEndDate=$p(OStartDate,"^",2)
	s OLStartDate=$p(OStartDate,"^",1)
	s MaxOLRowID=0
	s OLRowID=0
	f  s OLRowID=$o(^DHCEQOperateLog(OLRowID)) q:OLRowID=""  d
	.q:$p($g(^DHCEQOperateLog(OLRowID)),"^",3)'=""
	.q:$p($g(^DHCEQOperateLog(OLRowID)),"^",1)'=52
	.q:$p($g(^DHCEQOperateLog(OLRowID)),"^",2)'=SERowID
	.q:($p($g(^DHCEQOperateLog(OLRowID)),"^",5)<OLStartDate)||($p($g(^DHCEQOperateLog(OLRowID)),"^",5)>OLEndDate)
	.i OLRowID>MaxOLRowID d
	..s MaxOLRowID=OLRowID
	i MaxOLRowID=0 q ""
	i MaxOLRowID>0 q MaxOLRowID
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetAdjust(823)
ClassMethod GetOneAssetAdjust(ADRowID, ASnapID As %Library.String = "")
{
	s $ZT="ERROROneAssetAdjust"
	s ObjMove=##Class(User.DHCEQAdjustData).%OpenId(ADRowID)
	s ObjMoveNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMove)
	s MoveInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d MoveInfo.%Set("BDBGBH","AD"_ADRowID)
	d MoveInfo.%Set("SAASDM",..#SAASDM)
	d MoveInfo.%Set("RZRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.ADDate,"date")) ///入账日期
	d MoveInfo.%Set("PZH","AD"_ADRowID)	//凭证号
	d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD(ObjMove.ADUser,"0",6))	//变动单申请人编码
	d MoveInfo.%Set("BDRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.ADDate,"date"))		//变动日期
	d MoveInfo.%Set("BDYY","资产变动使用部门")	//变动原因
	d MoveInfo.%Set("DJBZ",1)	//变动类型0单价  1  使用科室，存放地点，使用人

	
	s Data=##class(%ListOfDataTypes).%New()
	s ADLRowID=0
	f  s ADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",ADRowID,ADLRowID)) q:(ADLRowID="")  d
	.q:$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",2)="" 
	.s FromLoc=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",3)
	.s ToLoc=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",8)
	.q:FromLoc=ToLoc
	.s EquipDR=$p($g(^DHCEQAdjustDataList(ADLRowID)),"^",2)
	.s EquipData=$g(^DHCEQEquip(EquipDR))
	.s EquipNo=$g(^DHCEQSnapShot(ASnapID,"Equip",EquipDR))
	.s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	.d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	.d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	.d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	.d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	.i $p(EquipData,"^",66)="" d OneData.%Set("SYR","654321") 
	.d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	.d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	.i $p(EquipData,"^",72)="" d OneData.%Set("CFDD","000001") 
	.d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	.d OneData.%Set("BDXM","使用部门") //变动项目：0单价  1  使用科室，存放地点，使用人
	.s FromLocCode= ##class(web.DHCEQCCounter).LPAD(FromLoc,"0",6)
	.d OneData.%Set("BDQNR",FromLocCode_":"_##class(web.DHCEQCommon).GetTrakNameByID("dept",FromLoc)) //变动前内容
	.s ToLocCode= ##class(web.DHCEQCCounter).LPAD(ToLoc,"0",6)
	.d OneData.%Set("BDHNR",ToLocCode_":"_##class(web.DHCEQCommon).GetTrakNameByID("dept",ToLoc)) //变动后内容
	.d Data.Insert(OneData)
	
	d MoveInfo.%Set("DATA",Data)	//变动类型
	q MoveInfo
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetAdjust
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetChange(823)
ClassMethod GetOneAssetChange(CARowID, cSnapID As %Library.String = "")
{
	s $ZT="ERROROneAssetChange"
	s ObjMove=##Class(User.DHCEQChangeAccount).%OpenId(CARowID)
	s ObjMoveNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMove)
	s MoveInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d MoveInfo.%Set("BDBGBH","CA"_CARowID)
	d MoveInfo.%Set("SAASDM",..#SAASDM)
	d MoveInfo.%Set("RZRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.CAAuditDate,"date")) ///入账日期
	d MoveInfo.%Set("PZH","CA"_CARowID)	//凭证号
	d MoveInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD(ObjMove.CAAddUserDR,"0",6))	//变动单申请人编码
	d MoveInfo.%Set("BDRQ",##class(web.DHCEQCommon).TransValueToPage(ObjMoveNew.CAAuditDate,"date"))		//变动日期
	d MoveInfo.%Set("BDYY","资产变动单价")	//变动原因
	d MoveInfo.%Set("DJBZ",0)	//变动类型0单价  1  使用科室，存放地点，使用人

	
	s Data=##class(%ListOfDataTypes).%New()
	s EquipDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
	s EquipData=$g(^DHCEQSnapShot(cSnapID,"Equip",EquipDR))
	s EquipNo=$p(EquipData,"^",71)
	s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	d OneData.%Set("SYR",$p(EquipData,"^",66))  //使用（责任）人 Keeper
	i $p(EquipData,"^",66)="" d OneData.%Set("SYR","654321")  
	d OneData.%Set("SYDW",$p(EquipData,"^",67))  //使用（责任）部门
	d OneData.%Set("CFDD",$p(EquipData,"^",72)) //存放地点
	i $p(EquipData,"^",72)="" d OneData.%Set("CFDD","000001") 
	d OneData.%Set("DJ",##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")) //价值
	d OneData.%Set("BDXM","单价") //变动项目：0单价  1  使用科室，存放地点，使用人
	d OneData.%Set("BDQNR",ObjMoveNew.CAOriginalFee) //变动前内容
	d OneData.%Set("BDHNR",ObjMoveNew.CAChangedOriginalFee) //变动后内容
	d Data.Insert(OneData)
	
	d MoveInfo.%Set("DATA",Data)	//变动类型
	q MoveInfo
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetChange
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by zy 2022-2-22
/// 获取一个报废业务数据
/// Input:业务ID 和 状态
/// output:
/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetDisuse(2460,1)
ClassMethod GetOneAssetDisuse(BussID, Status)
{
	s $ZT="ERROROneAssetDisuse"
	s ObjDisuse=##Class(User.DHCEQDisuseRequest).%OpenId(BussID)
	s ObjDisuseNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjDisuse)
	s DisuseInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d DisuseInfo.%Set("SAASDM",..#SAASDM)
	;d DisuseInfo.%Set("RYBH",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjDisuse.DRAddUserDR))	//负责人编码

	d DisuseInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD(ObjDisuseNew.DRAddUserDR,"0",6)) //负责人编码
	d DisuseInfo.%Set("CZFS","92")	//处置方式编码  92	报废
	//Modify by zx 2022-04-21
	;s RequestLocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",ObjDisuse.DRRequestLocDR )),"^",20)
	s RequestLocCode=##class(web.DHCEQCCounter).LPAD(ObjDisuseNew.DRRequestLocDR,"0",6)
	d DisuseInfo.%Set("BBBM",RequestLocCode)	//编报部门编码	
	if Status=1
	{
		d DisuseInfo.%Set("DBH",ObjDisuse.DRRequestNo)
		d DisuseInfo.%Set("SBRQ",ObjDisuseNew.DRSubmitDate) ///入账日期
		d DisuseInfo.%Set("SFPG",0)	//是否评估编码 0,否，1,是
		d DisuseInfo.%Set("SFSB",0)	//是否评估上报 0,否，1,是
		d DisuseInfo.%Set("SBWH","")	//申报文号
		d DisuseInfo.%Set("IFZCBA",ObjDisuse.DRHold1)	//是否资产备案编码 0,否，1,是
	}
	elseif Status=2
	{
		d DisuseInfo.%Set("BDBGBH",ObjDisuse.DRRequestNo)
		d DisuseInfo.%Set("SBBH","")	//处置申报单编号
		d DisuseInfo.%Set("BDRQ",ObjDisuseNew.DRAuditDate) ///入账日期
		
		d DisuseInfo.%Set("CZSR","")	//全部处置收入
		d DisuseInfo.%Set("CZCB","")	//应上缴金额
		d DisuseInfo.%Set("PGJE","")	//评估价值
		d DisuseInfo.%Set("PCJE","")	//列入本单位当前收入
		d DisuseInfo.%Set("SJGK","")	//已上缴金额
	}
	
	
    s KindFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",44)
    s EquipIDs=""
    i KindFlag=0  d
    .s EquipIDs=$P(^DHCEQDisuseRequest(BussID),"^",1)
    else  if KindFlag=1  d
    .s EquipIDs=$g(^DHCEQDisuseRequest(BussID,"EX"))
    e  d
    .s MXRowID=0
    .f  s MXRowID=$o(^DHCEQDisuseList(0,"Request",BussID,MXRowID)) q:(MXRowID="")  d
    ..i $p(^DHCEQDisuseList(MXRowID),"^",2)=0  d
    ...s OneEquipIDs=$P(^DHCEQDisuseList(MXRowID),"^",3)
    ..e  d
    ...s OneEquipIDs=$g(^DHCEQDisuseList(MXRowID,"EX"))
    ..i EquipIDs=""  d
    ...s EquipIDs=OneEquipIDs
    ..e  d
    ...s EquipIDs=EquipIDs_","_OneEquipIDs
	
	s (totalOriginalFee,totalNetFee)=0
	s Data=##class(%ListOfDataTypes).%New()
	s count=$l(EquipIDs,",")
	f k=1:1:count d
	.s EquipDR=$p(EquipIDs,",",k)
	.i EquipDR'=""  d
	..s EquipData=$g(^DHCEQEquip(EquipDR))
	..s EquipNo=$p(EquipData,"^",71)
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..i Status=1 d
	...d OneData.%Set("ZCBH",$p(EquipData,"^",71))  //资产编号
	...d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..else  if Status=2 d
	...d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	...d OneData.%Set("YQMC",$p(EquipData,"^",1))  //资产名称
	..i Status=1 d
	...s OneFLH=$e($p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1),1,7)
	...d OneData.%Set("FLH",OneFLH)  //资产分类号
	...d OneData.%Set("U1","0")  //处置收入金额
	...d OneData.%Set("U2","0")  //实际上缴金额
	..e  i Status=2 d
	...s OneZCDM=$e($p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1),1,7)
	...d OneData.%Set("ZCDM",OneZCDM)  //资产分类号
	...d OneData.%Set("DJ",$p(EquipData,"^",27))  //单价
	..d Data.Insert(OneData)
	..s totalOriginalFee=totalOriginalFee+$p(EquipData,"^",27)
	..s totalNetFee=totalNetFee+$p(EquipData,"^",28)
	if Status=1
	{
		d DisuseInfo.%Set("ZCYZ",totalOriginalFee)	//处置固定资产原值
		d DisuseInfo.%Set("ZCJZ",totalNetFee)	//处置固定资产净值
	}
	d DisuseInfo.%Set("DATA",Data)	//变动类型
	q DisuseInfo
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetDisuse
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by zy 2022-2-22
/// 获取一个退货与减少业务数据
/// Input:业务ID 和 状态
/// output:
/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetReduce(3,1,"","","")
ClassMethod GetOneAssetReduce(BussID, Status, SnapID, StartDate, EndDate)
{
	s $ZT="ERROROneAssetReduce"
	s ObjReduce=##Class(User.DHCEQReturn).%OpenId(BussID)
	s ObjReduceNew=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjReduce)
	s ReduceInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
	d ReduceInfo.%Set("SAASDM",..#SAASDM)
	d ReduceInfo.%Set("RYBH",##class(web.DHCEQCCounter).LPAD(ObjReduce.RMakerDR,"0",6))	//负责人编码
	d ReduceInfo.%Set("CZFS",$p($g(^DHCEQCCode("DHCEQCOutType",$p($g(^DHCEQReturn(BussID)),"^",17))),"^",3))	//处置方式编码  92	报废
	//Modify by zx 2022-04-21
	s RRequestLocDR=""
	i ObjReduce.RUseLocDR'="" d
	.s RRequestLocDR=ObjReduce.RUseLocDR
	e  d
	.s RRequestLocDR=ObjReduce.RReturnLocDR
	s RequestLocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",RRequestLocDR )),"^",20)
	i RequestLocCode="" s RequestLocCode=##class(web.DHCEQCCounter).LPAD(RRequestLocDR,"0",6)
	d ReduceInfo.%Set("BBBM",RequestLocCode)	//编报部门编码	
	if Status=1
	{
		d ReduceInfo.%Set("DBH",ObjReduce.RReturnNo)
		d ReduceInfo.%Set("SBRQ",ObjReduceNew.RMakeDate) ///入账日期
		d ReduceInfo.%Set("SFPG",0)	//是否评估编码 0,否，1,是
		d ReduceInfo.%Set("SFSB",0)	//是否评估上报 0,否，1,是
		d ReduceInfo.%Set("SBWH","")	//申报文号
		d ReduceInfo.%Set("IFZCBA",0)	//是否备案 0,否，1,是
	}
	elseif Status=2
	{
		d ReduceInfo.%Set("BDBGBH",ObjReduce.RReturnNo)
		d ReduceInfo.%Set("SBBH","")	//处置申报单编号
		d ReduceInfo.%Set("BDRQ",ObjReduceNew.RAckDate) ///入账日期
		
		d ReduceInfo.%Set("CZSR","")	//全部处置收入
		d ReduceInfo.%Set("CZCB","")	//应上缴金额
		d ReduceInfo.%Set("PGJE","")	//评估价值
		d ReduceInfo.%Set("PCJE","")	//列入本单位当前收入
		d ReduceInfo.%Set("SJGK","")	//已上缴金额
	}
	
	s EquipIDs=""
    s ListRowID=0
	f  s ListRowID=$o(^DHCEQReturnList(0,"Return",BussID,ListRowID)) q:(ListRowID="")  d
    .s OneEquipIDs=$g(^DHCEQReturnList(ListRowID,"EX","RowIDs"))
    .i EquipIDs=""  d
    ..s EquipIDs=OneEquipIDs
    .e  d
    ..s EquipIDs=EquipIDs_","_OneEquipIDs
	
	s (totalOriginalFee,totalNetFee)=0
	s Data=##class(%ListOfDataTypes).%New()
	s count=$l(EquipIDs,",")
	f k=1:1:count d
	.s EquipDR=$p(EquipIDs,",",k)
	.;q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAssetEquipInCurMonth(EquipDR,SnapID, StartDate, EndDate)'=0
	.i EquipDR'=""  d
	..s EquipData=$g(^DHCEQEquip(EquipDR))
	..s EquipNo=$p(EquipData,"^",71)
	..s OneData=##class(web.DHCEQ.Plat.JsonObject).%New()
	..i Status=1 d
	...d OneData.%Set("ZCBH",$p(EquipData,"^",71))  //资产编号
	...d OneData.%Set("ZCMC",$p(EquipData,"^",1))  //资产名称
	..else  if Status=2 d
	...d OneData.%Set("YQBH",$p(EquipData,"^",71))  //资产编号
	...d OneData.%Set("YQMC",$p(EquipData,"^",1))  //资产名称
	..i Status=1 d
	...d OneData.%Set("FLH",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	...d OneData.%Set("U1","0")  //处置收入金额
	...d OneData.%Set("U2","0")  //实际上缴金额
	..e  i Status=2 d
	...d OneData.%Set("ZCDM",$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(EquipData,"^",4))),"^",1))  //资产分类号
	...d OneData.%Set("DJ",$p(EquipData,"^",27))  //单价
	..d Data.Insert(OneData)
	..s totalOriginalFee=totalOriginalFee+$p(EquipData,"^",27)
	..s totalNetFee=totalNetFee+$p(EquipData,"^",28)
	if Status=1
	{
		d ReduceInfo.%Set("ZCYZ",totalOriginalFee)	//处置固定资产原值
		d ReduceInfo.%Set("ZCJZ",totalNetFee)	//处置固定资产净值
	}
	d ReduceInfo.%Set("DATA",Data)	//变动类型
	q ReduceInfo
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERROROneAssetReduce
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by zy 2022-2-22
/// 固定资产报废申报
/// Input:输入参数:	YYYY-MM
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","AssetDisuseRequest","2022-01")
Query AssetDisuseRequest(MonthStr) As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod AssetDisuseRequestExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") 
	s BussID=0
	f  s BussID=$o(^DHCEQDisuseRequest(0,"Status",1,BussID)) q:((BussID=""))  d
	.s EquipType=$p($g(^DHCEQDisuseRequest(BussID)),"^",43)
	.;q:((EquipType=8)||(EquipType=9)||(EquipType=10))
	.q:((","_FacilityEquipType_",")[(","_EquipType_","))
	.s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",53)    //Add By CZF 2016-12-07 begin
	.q:DRInvalidFlag="Y"
	.s DRStatus=$p($g(^DHCEQDisuseRequest(BussID)),"^",10)
	.q:DRStatus'=1			//Add By CZF 2016-12-07 end
	.;Modified By JDL 2011-9-16 JDL0096
	.q:$p($g(^DHCEQDisuseRequest(BussID)),"^",10)'=1
	.s ApproveRoleDR = $p($g(^DHCEQDisuseRequest(BussID)),"^",31)
	.q:approveroleid'=ApproveRoleDR
	.s TLastApproveDate=""
	.s TLastApproveListDR=$o(^DHCEQApproveList(0,"Source","5",BussID,""),-1) 
	.i TLastApproveListDR'="" s TLastApproveDate=$p(^DHCEQApproveList(TLastApproveListDR),"^",7)
	.q:TLastApproveDate=""
	.q:(StartDate>TLastApproveDate)
	.q:(TLastApproveDate>EndDate)
	.s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetDisuse(BussID,1)
	.s Data=Data.%ToJSON()
	.;s Data=BussID
	.d OutputRowAssetDisuseRequest
	
	s DBussID=0
	f  s DBussID=$o(^DHCEQApproveList(0,"Source",5,DBussID))  q:DBussID=""  d
	.q:$p($g(^DHCEQDisuseRequest(DBussID)),"^",10)'=2
	.q:((","_FacilityEquipType_",")[(","_$p($g(^DHCEQDisuseRequest(DBussID)),"^",43)_","))
	.q:$p($g(^DHCEQDisuseRequest(DBussID)),"^",53)="Y"
	.q:($p($g(^DHCEQDisuseRequest(DBussID)),"^",21)>EndDate)||($p($g(^DHCEQDisuseRequest(DBussID)),"^",21)<StartDate)
	.s CALRowID=0
	.f  s CALRowID=$o(^DHCEQApproveList(0,"Source",5,DBussID,CALRowID))  q:CALRowID=""  d
	..q:$p($g(^DHCEQApproveList(CALRowID)),"^",10)="Y"
	..q:$p($g(^DHCEQApproveList(CALRowID)),"^",12)'="0"
	..q:$p($g(^DHCEQApproveList(CALRowID)),"^",5)'=approveroleid
	..q:($p($g(^DHCEQApproveList(CALRowID)),"^",7)>EndDate)||($p($g(^DHCEQApproveList(CALRowID)),"^",7)<StartDate)
	..s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetDisuse(DBussID,1)
	..s Data=Data.%ToJSON()
	..;s Data=BussID
	..d OutputRowAssetDisuseRequest
	
	s RStatus=0
	f  s RStatus=$o(^DHCEQReturn(0,"StatusReturnLoc",RStatus)) q:((RStatus="")||(RStatus<1))  d
	.q:RStatus>2
	.s RLocDR=0
	.f  s RLocDR=$o(^DHCEQReturn(0,"StatusReturnLoc",RStatus,RLocDR)) q:RLocDR=""  d
	..s RRowID=0
 	..f  s RRowID=$o(^DHCEQReturn(0,"StatusReturnLoc",RStatus,RLocDR,RRowID)) q:RRowID=""  d
 	...q:$p($g(^DHCEQReturn(RRowID)),"^",28)="Y"
 	...q:($p($g(^DHCEQReturn(RRowID)),"^",6)>EndDate)||($p($g(^DHCEQReturn(RRowID)),"^",6)<StartDate)
 	...q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAssetEquipCurMonth(RRowID,SnapID, StartDate, EndDate)'=0
 	...s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetReduce(RRowID,1,SnapID, StartDate, EndDate)
	...s Data=Data.%ToJSON()
	...d OutputRowAssetDisuseRequest
	
	Quit $$$OK
OutputRowAssetDisuseRequest
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod AssetDisuseRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetDisuseRequestExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod AssetDisuseRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetDisuseRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2022-2-22
/// 固定资产报废处置
/// Input:输入参数:	YYYY-MM
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","AssetDisuseAudit","2022-01")
Query AssetDisuseAudit(MonthStr) As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod AssetDisuseAuditExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053")
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.//q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.;q:((EquipType=8)||(EquipType=9)||(EquipType=10))
	.q:((","_FacilityEquipType_",")[(","_EquipType_","))
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s BussID=0
	..f  s BussID=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,BussID)) q:((BussID=""))  d
	...s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",53)    //Add By CZF 2016-12-07 begin
	...q:DRInvalidFlag="Y"
	...s DRStatus=$p($g(^DHCEQDisuseRequest(BussID)),"^",10)
	...q:DRStatus'=2
	...s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetDisuse(BussID,2)
	...s Data=Data.%ToJSON()
	...d OutputRowAssetDisuseAudit
	
	s RLocDR=0
	f  s RLocDR=$o(^DHCEQReturn(0,"StatusReturnLoc",2,RLocDR)) q:RLocDR=""  d
	.s RRowID=0
 	.f  s RRowID=$o(^DHCEQReturn(0,"StatusReturnLoc",2,RLocDR,RRowID)) q:RRowID=""  d
 	..q:$p($g(^DHCEQReturn(RRowID)),"^",28)="Y"
 	..q:($p($g(^DHCEQReturn(RRowID)),"^",8)>EndDate)||($p($g(^DHCEQReturn(RRowID)),"^",8)<StartDate)
 	..q:##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAssetEquipCurMonth(RRowID,SnapID, StartDate, EndDate)'=0
 	..s Data=##Class(web.DHCEQ.Interface.DHCEQForWJW).GetOneAssetReduce(RRowID,2,SnapID, StartDate, EndDate)
	..s Data=Data.%ToJSON()
	..d OutputRowAssetDisuseAudit
	
	Quit $$$OK
OutputRowAssetDisuseAudit
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod AssetDisuseAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetDisuseAuditExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod AssetDisuseAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetDisuseAuditExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).AssetDepreTotal("2022-02")
ClassMethod AssetDepreTotal(MonthStr)
{
	s result=##class(%Library.ResultSet).%New("web.DHCEQ.Interface.DHCEQForWJW:AssetDepre")
	s sc=result.Execute(MonthStr)
	s Result="{""CONTANST"":["_DataStr_"]}"
}

/// add by zy 2022-2-22
/// 固定资产折旧明细
/// Input:输入参数:	YYYY-MM
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","AssetDepre","2022-04")
Query AssetDepre(MonthStr) As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod AssetDepreExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	i SnapID="" Quit $$$OK
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") 
	s EquipDR=0
 	f  s EquipDR=$o(^DHCEQSnapShot(SnapID,"Equip",EquipDR))  q:EquipDR=""  d
 	.;q:((EquipDR=8)||(EquipDR=9)||(EquipDR=10))
 	.;q:EquipDR'=449570
	.q:((","_FacilityEquipType_",")[(","_$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipDR)),"^",63)_","))
	.q:$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipDR)),"^",59)="Y"
	.q:'(($p($g(^DHCEQSnapShot(SnapID,"Equip",EquipDR)),"^",60)="1")&&($p($g(^DHCEQSnapShot(SnapID,"Equip",EquipDR)),"^",38)<=2))
	.s EquipData=$g(^DHCEQEquip(EquipDR))
	.s EquipNo=$p(EquipData,"^",71)
	.;.q:$p(EquipData,"^",20)="2"
	.s OneData=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d OneData.%Set("YQBH",EquipNo)  //仪器编号
	.i $d(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,MonthStr)) d
	..s BussID=0
	..f  s BussID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,MonthStr,BussID)) q:BussID=""  d
	...s DataList=$g(^DHCEQMonthDepre(BussID))
	...q:$p(DataList,"^",20)="3"
	...q:$p(DataList,"^",3)'="Y"	//是否主折旧
	...;d OneData.%Set("SAASDM",..#SAASDM)  //组织机构
	...;d OneData.%Set("ZJYF",MonthStr)  //折旧月份
	...d OneData.%Set("ZJE",$p(DataList,"^",14))  //当前月折旧额
	...d OneData.%Set("LJZJ",$p(DataList,"^",12))  //累计折旧额
	...d OneData.%Set("ZCYZ",$p(DataList,"^",5))  //资产原值
	...d OneData.%Set("ZMJZ",$p(DataList,"^",17))  //账面净值
	...d OneData.%Set("YZJYF",$p(DataList,"^",10))  //已折旧月份
	...d OneData.%Set("WZJYF",($p(DataList,"^",9)*12-$p(DataList,"^",10)))  //未折旧月份
	...s Data=OneData.%ToJSON()
	...d OutputRowAssetDepre
	.e  d
	..;d OneData.%Set("ZJYF",MonthStr)  //折旧月份
	..d OneData.%Set("ZJE","0")  //当前月折旧额
	..d OneData.%Set("LJZJ",+$p(EquipData,"^",35))  //累计折旧额
	..d OneData.%Set("ZCYZ",+$p(EquipData,"^",27))  //资产原值
	..d OneData.%Set("ZMJZ",+$p(EquipData,"^",28))  //账面净值
	..d OneData.%Set("YZJYF",(+$p(EquipData,"^",31))*12)  //已折旧月份
	..d OneData.%Set("WZJYF","0")  //未折旧月份
	..s Data=OneData.%ToJSON()
	..d OutputRowAssetDepre
	Quit $$$OK
OutputRowAssetDepre
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod AssetDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetDepreExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod AssetDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetDepreExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2022-2-22
/// 字典:人员、部门、存放地点
/// Input:  MonthStr:	YYYY-MM
/// 		TableName:	人员：DHC_EQCUser  ;部门：DHC_EQCDepartment  ;存放地点：DHC_EQCLocation
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","CodeDataChange","2022-10","DHC_EQCLocation")
Query CodeDataChange(MonthStr, TableName As %String = "") As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod CodeDataChangeExecute(ByRef qHandle As %Binary, MonthStr, TableName As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	i TableName="" Quit $$$OK
	;s TableName="DHC_EQCLocation"
	s BussID=0
	f  s BussID=$o(^DHCEQDataChangeLog(0,"TableName",TableName,BussID)) q:BussID=""  d
	.s LX=""
	.s rowid=0
	.f  s rowid=$o(^DHCEQDataChangeLog(0,"TableName",TableName,BussID,rowid)) q:rowid=""  d
	..s ChangeDataList=$g(^DHCEQDataChangeLog(rowid))
	..s UpdateDate=$p(ChangeDataList,"^",5)
	..q:(StartDate>UpdateDate)
	..q:(UpdateDate>EndDate)
	..s OperateType=$Case($p($g(^DHCEQDataChangeLog(rowid)),"^",7),"A":1,"U":2,"D":3)
	..i LX=""  d
	...s LX=OperateType
	..e  d
	...i (LX=1)&&(OperateType=2)  d	//第一条新增，第二条修改，只记新增
	....
	...e  i (LX=1)&&(OperateType=3)  d   //第一条新增，第二条删除，不需要传
	....s LX=""
	...e  d
	....s LX=OperateType
	.q:LX=""
	.d BuildCodeDataChange
	Quit $$$OK
BuildCodeDataChange
	s OneData=##class(web.DHCEQ.Plat.JsonObject).%New() 
	d OneData.%Set("SAASDM",..#SAASDM)  //组织机构
	d OneData.%Set("LX",LX)  //数据类型 部门新增为1；部门信息修改为2，修改时DWBH为主键，根据DWBH修改信息，不允许修改DWBH；删除为3
	i TableName="DHC_EQCUser"  d
	.s DataList=$g(^DHCEQCCode("DHCEQCUser",BussID))
	.s UserCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.d OneData.%Set("RYBH",UserCode)  //编号
	.d OneData.%Set("XM",$p(DataList,"^",4))  //
	.s DeptCode=""
	.i $p(DataList,"^",14)'=""  
	..;s DeptCode=$p($g(^DHCEQCCode("DHCEQCDepartment",$p(DataList,"^",14))),"^",20)
	..s DeptCode=##class(web.DHCEQCCounter).LPAD($p(DataList,"^",14),"0",6)
	.if DeptCode="" s DeptCode="00001"
	.d OneData.%Set("DWBH",DeptCode)  //所在部门
	e  i TableName="DHC_EQCDepartment"  d
	.s DataList=$g(^DHCEQCCode("DHCEQCDepartment",BussID))
	.//d OneData.%Set("DWBH",BussID)  //编号
	.s DeptCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.d OneData.%Set("DWBH",DeptCode)  //编号
	.d OneData.%Set("MC",$p(DataList,"^",2))  //
	.d OneData.%Set("SFMJ","1")  //是否末级
	.d OneData.%Set("SJDW","000000")  //上级部门编号
	e  i TableName="DHC_EQCLocation"  d
	.s DataList=$g(^DHCEQCCode("DHCEQCLocation",BussID))
	.s LocationCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.d OneData.%Set("DDBH",LocationCode)  //编号
	.d OneData.%Set("MC",$p(DataList,"^",2))  //
	.d OneData.%Set("DWBH","")  //所在部门
	.d OneData.%Set("SJDD","00000")  //上级地点编号
	s Data=OneData.%ToJSON()
	d OutputRowCodeDataChange
	Quit
OutputRowCodeDataChange
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod CodeDataChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodeDataChangeExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod CodeDataChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodeDataChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2022-2-22
/// 人员字典
/// Input:
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","User")
Query User(MonthStr As %String = "") As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod UserExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	;s EndDate=$p(StartDate,"^",2)
	;s StartDate=$p(StartDate,"^",1)
	s BussID=0
	f  s BussID=$o(^DHCEQCCode("DHCEQCUser",BussID)) q:BussID=""  d
	.s DataList=$g(^DHCEQCCode("DHCEQCUser",BussID))
	.s BussCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.s OneData=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d OneData.%Set("SAASDM",..#SAASDM)  //组织机构
	.d OneData.%Set("RYBH",BussCode)  //编号
	.d OneData.%Set("XM",$p(DataList,"^",4))  //
	.d OneData.%Set("DWBH","")  //所在部门
	.d OneData.%Set("LX","1")  //数据类型 部门新增为1；部门信息修改为2，修改时DWBH为主键，根据DWBH修改信息，不允许修改DWBH；删除为3
	.s Data=OneData.%ToJSON()
	.d OutputRowUser
	
	Quit $$$OK
OutputRowUser
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod UserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod UserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2022-2-22
/// 科室
/// Input:输入参数:	YYYY-MM
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","Dept","2022-04")
Query Dept(MonthStr As %String = "") As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod DeptExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s BussID=0
	f  s BussID=$o(^DHCEQCCode("DHCEQCDepartment",BussID)) q:BussID=""  d
	.s DataList=$g(^DHCEQCCode("DHCEQCDepartment",BussID))
	.;s BussCode=$p(DataList,"^",20)
	.s BussCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.q:$p(DataList,"^",19)="Y"
	.s OneData=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d OneData.%Set("SAASDM",..#SAASDM)  //组织机构
	.d OneData.%Set("DWBH",BussCode)  //编号
	.d OneData.%Set("MC",$p(DataList,"^",2))  //
	.d OneData.%Set("SFMJ","1")  //是否末级（填1和0   1是0否）
	.d OneData.%Set("SJDW","000000")  //上级部门编号
	.d OneData.%Set("LX","1")  //数据类型 部门新增为1；部门信息修改为2，修改时DWBH为主键，根据DWBH修改信息，不允许修改DWBH；删除为3
	.s Data=OneData.%ToJSON()
	.d OutputRowDept
	
	Quit $$$OK
OutputRowDept
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod DeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod DeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2022-2-22
/// 存放地点
/// Input:""
/// output:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQForWJW","Location")
Query Location(MonthStr As %String = "") As %Query(ROWSPEC = "Data:%String") [ SqlProc ]
{
}

ClassMethod LocationExecute(ByRef qHandle As %Binary, MonthStr) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s BussID=0
	f  s BussID=$o(^DHCEQCCode("DHCEQCLocation",BussID)) q:BussID=""  d
	.s DataList=$g(^DHCEQCCode("DHCEQCLocation",BussID))
	.q:$p(DataList,"^",11)="Y"
	.s BussCode=##class(web.DHCEQCCounter).LPAD(BussID,"0",6)
	.s OneData=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d OneData.%Set("SAASDM",..#SAASDM)  //组织机构
	.d OneData.%Set("DDBH",BussCode)  //编号
	.d OneData.%Set("MC",$p(DataList,"^",2))  //地点名称
	.d OneData.%Set("DWBH","")  //所在部门编号
	.d OneData.%Set("SJDD","00000")  //上级地点编号
	.d OneData.%Set("LX","1")  //地点新增为1；地点信息修改为2，修改时DDBH为主键，根据DDBH修改信息，不允许修改DDBH；删除为3
	.s Data=OneData.%ToJSON()
	.d OutputRowLocation
	
	Quit $$$OK
OutputRowLocation
	s data=$lb(Data)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod LocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocationExecute ]
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
	;b
	Quit $$$OK
}

ClassMethod LocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocationExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetJsonData()
ClassMethod GetJsonData()
{
	//2016方式
	w "-------2016动态对象方式------",!
	s newobj={}
	d newobj.%Set("BDRQ","2022-02-01")
	d newobj.%Set("BDLX","库房分配")
	s DataObj=[]
	for i=1:1:2
	{
		s listobj={}
		d listobj.%Set("ZCBH","12345"_i)
		d listobj.%Set("ZCMC","呼吸机"_i)
		d DataObj.%Push(listobj)
	}
	d newobj.%Set("Data",DataObj)
	s jsonStr=newobj.%ToJSON()
	w jsonStr,!
	s jsonObj={}.%FromJSON(jsonStr)
	s ListDataObj=jsonObj.Data
	s Iterator = ListDataObj.%GetIterator()
	while Iterator.%GetNext(.key,.val) 
    {
	     s SMLObj=ListDataObj.%Get(key)
	     s ZCBH=SMLObj.ZCBH
	     s ZCMC=SMLObj.ZCMC
	     w "ZCBH="_ZCBH_",ZCMC="_ZCMC,!
    }
	w "----------------------------",!
	
	w "-------组内JSON对象方式------",!
	s newobj=""
	s DataObj=""
	s listobj=""
	s newobj=##class(web.DHCEQ.Plat.JsonObject).%New()
	d newobj.%Set("BDRQ","2022-02-01")
	d newobj.%Set("BDLX","库房分配")
	s DataObj=##class(%ListOfDataTypes).%New()
	for i=1:1:2
	{
		s listobj=##class(web.DHCEQ.Plat.JsonObject).%New()
		d listobj.%Set("ZCBH","12345"_i)
		d listobj.%Set("ZCMC","呼吸机"_i)
		d DataObj.Insert(listobj)
	}
	d newobj.%Set("Data",DataObj)
	s jsonStr=newobj.%ToJSON()
	w jsonStr,!
	s jsonObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(jsonStr)
	s ListDataObj=jsonObj.Data
	s key=""
	For
	{
		s SMLObj=ListDataObj.GetNext(.key)
		q:key=""
		s ZCBH=SMLObj.ZCBH
	    s ZCMC=SMLObj.ZCMC
	    w "ZCBH="_ZCBH_",ZCMC="_ZCMC,!
	}
	w "----------------------------",!
}

ClassMethod CheckBussNumByOrigin(vBussID, OriginDR)
{
	i vBussID="" q 0
	s Num=0
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",vBussID,SMLRowID)) q:(SMLRowID="")  d
	.s SMOriginDR=""
	.s vBatchFlag=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)
	.i vBatchFlag="Y" d
	..s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	..s SMOriginDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListDR)),"^",1))),"^",15)
	.e  d
	..s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	..s SMOriginDR=$p($g(^DHCEQEquip(EquipDR)),"^",20)
	.q:SMOriginDR=OriginDR
	.s Num=Num+1
	q Num
}

ClassMethod CheckAdjustLoc(vAdjustDataDR)
{
	i vAdjustDataDR="" q 0
	s vLFlag=0
	s vADLRowID=0
	f  s vADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",vAdjustDataDR,vADLRowID)) q:(vADLRowID="")||(vLFlag'=0)  d
	.q:$p($g(^DHCEQAdjustDataList(vADLRowID)),"^",3)=$p($g(^DHCEQAdjustDataList(vADLRowID)),"^",8)
	.s vLFlag=1
	q vLFlag
}

ClassMethod CheckAdjustNumByOrigin(vAdjustDataDR, OriginDR)
{
	i vAdjustDataDR="" q 0
	s Num=0
	s vADLRowID=0
	f  s vADLRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",vAdjustDataDR,vADLRowID)) q:(vADLRowID="")  d
	.s ADLEquipDR=$p($g(^DHCEQAdjustDataList(vADLRowID)),"^",2)
	.q:$p($g(^DHCEQEquip(ADLEquipDR)),"^",20)=OriginDR
	.s Num=Num+1
	q Num
}

ClassMethod CheckEquipChangedBySnap(SnapID, SERowID, PreSnapID)
{
	i SERowID="" q 0
	s Flag=0
	s (OLoctionDesc,NLoctionDesc)=""
	s OLoctionDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",72)
	i OLoctionDR'="" d
	.s OLoctionDesc=$piece($g(^DHCEQCCode("DHCEQCLocation",OLoctionDR)),"^",2)
	e  d
	.s OLoctionDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",67))
	s NLoctionDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",72)
	i NLoctionDR'="" d
	.s NLoctionDesc=$piece($g(^DHCEQCCode("DHCEQCLocation",NLoctionDR)),"^",2)
	e  d
	.s NLoctionDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67))
	
	s (OManageUser,NManageUser)=""
	s OStoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(PreSnapID,"Equip",SERowID)),"^",67),""))
	i OStoreLLocTypeDR'="" d
	.s OManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",OStoreLLocTypeDR)),"^",6)
	.i OManageUserDR'="" s OManageUser=##class(web.DHCEQCCounter).LPAD(OManageUserDR,"0",6)
	s NStoreLLocTypeDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",$p($g(^DHCEQSnapShot(SnapID,"Equip",SERowID)),"^",67),""))
	i NStoreLLocTypeDR'="" d
	.s NManageUserDR=$p($g(^DHCEQCCode("DHCEQCLocType",NStoreLLocTypeDR)),"^",6)
	.i NManageUserDR'="" s NManageUser=##class(web.DHCEQCCounter).LPAD(NManageUserDR,"0",6)
	
	i (OLoctionDesc=NLoctionDesc)&&(OManageUser=NManageUser) s Flag=1 
	
	q Flag
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).ExecuteSend("2022-08",0)
ClassMethod ExecuteSend(pMonthStr, SourceType)
{
	i (pMonthStr="")||(SourceType="") q "条件不能为空"
	i pMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)  q "当前月份数据不能上传"
	s Info=""
	if SourceType=0
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendaddDataInfo(pMonthStr)
	}
	elseif (SourceType=1)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendchangeDataInfo(pMonthStr)
	}
	elseif (SourceType=2)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendgetDisposalDeclareResultInfo(pMonthStr)
	}
	elseif (SourceType=3)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SenddisposalDataInfo(pMonthStr)
	}
	elseif (SourceType=4)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendAssetDepreInfo(pMonthStr)
	}
	elseif (SourceType=5)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendDeptInfo(pMonthStr)
	}
	elseif (SourceType=6)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendUserInfo(pMonthStr)
	}
	elseif (SourceType=7)
	{
		s Info=##class(web.DHCENS.BLL.EPWJW.SendDataInfo).SendLocationInfo(pMonthStr)
	}
	q Info
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipReduce("17","66353","66382")
ClassMethod CheckEquipReduce(vBussID, SnapID, StartDate, EndDate)
{
	i vBussID="" q 0
	s Num=0
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",vBussID,SMLRowID)) q:(SMLRowID="")  d
	.s SMLEquipIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	.s count=$l(SMLEquipIDs,",")
	.f k=1:1:count d
	..s SMLEquipDR=$p(SMLEquipIDs,",",k)
	..q:'$D(^DHCEQLifeInfo(0,"EquipSourceDate",SMLEquipDR,23))
	..s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",SMLEquipDR,23,""),-1)
	..q:(LIDate>EndDate)||(LIDate<StartDate)
	..s TransAssetDate=$p(^DHCEQSnapShot(SnapID,"Equip",SMLEquipDR),"^",45)
	..q:(TransAssetDate>EndDate)||(TransAssetDate<StartDate)
	..s Num=Num+1
	q Num
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckEquipInReduce(1,"17","66353","66382")
ClassMethod CheckEquipInReduce(vEquipID, SnapID, StartDate, EndDate)
{
	i vEquipID="" q 1
	s INum=0
	i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipID,23)) q INum
	s ILIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipID,23,""),-1)
	i (ILIDate>EndDate)||(ILIDate<StartDate) q INum
	s ITransAssetDate=$p(^DHCEQSnapShot(SnapID,"Equip",vEquipID),"^",45)
	i (ITransAssetDate>EndDate)||(ITransAssetDate<StartDate) q INum
	s INum=1
	q INum
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAssetEquipCurMonth("17","66353","66382")
ClassMethod CheckAssetEquipCurMonth(vBussID, SnapID, StartDate, EndDate)
{
	i vBussID="" q 0
	s Num=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",vBussID,RLRowID)) q:(RLRowID="")  d
	.s RLEquipIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.s count=$l(RLEquipIDs,",")
	.f k=1:1:count d
	..s RLEquipDR=$p(RLEquipIDs,",",k)
	..s TransAssetDate=$p(^DHCEQSnapShot(SnapID,"Equip",RLEquipDR),"^",45)
	..q:(TransAssetDate>EndDate)||(TransAssetDate<StartDate)
	..s Num=Num+1
	q Num
}

/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).CheckAssetEquipInCurMonth(1,"17","66353","66382")
ClassMethod CheckAssetEquipInCurMonth(vEquipID, SnapID, StartDate, EndDate)
{
	i vEquipID="" q 1
	s INum=0
	s ITransAssetDate=$p(^DHCEQSnapShot(SnapID,"Equip",vEquipID),"^",45)
	i (ITransAssetDate>EndDate)||(ITransAssetDate<StartDate) q INum
	s INum=1
	q INum
}

/// 获取台账或快照资金来源及折旧信息
/// 入参：	EquipIDs：设备ID串，逗号分隔
/// 		SnapRowID：快照ID
/// 返回值：自筹=123:112,财政=234:140,科研=345:235
/// w ##Class(web.DHCEQ.Interface.DHCEQForWJW).GetFundsAmountByFundsType("5","1",2)
ClassMethod GetFundsAmountByFundsType(EquipID, SnapRowID As %String = "", FundsTypeDR)
{
	s FundsFee=0
	i (EquipID="")||(FundsTypeDR="") q FundsFee
	i SnapRowID="" d
	.s FRowID=0
	.f  s FRowID=$o(^DHCEQFunds(0,"Equip",EquipID,FRowID))  q:FRowID=""  d
	..s FundsStr=$g(^DHCEQFunds(FRowID))
	..q:$p(FundsStr,"^",10)="Y"
	..q:$p(FundsStr,"^",2)'=FundsTypeDR
	..s FundsFee=FundsFee+$p(FundsStr,"^",3)
	e  d
	.s FRowID=0
	.f  s FRowID=$o(^DHCEQSnapShot(SnapRowID,"Funds",EquipID,FRowID))  q:FRowID=""  d
	..s FundsStr=$g(^DHCEQSnapShot(SnapRowID,"Funds",EquipID,FRowID))
	..q:$p(FundsStr,"^",10)="Y"
	..q:$p(FundsStr,"^",2)'=FundsTypeDR
	..s FundsFee=FundsFee+$p(FundsStr,"^",3)
	
	
	q ##Class(web.DHCEQCommon).FormatNumber(FundsFee,"")
}

}
