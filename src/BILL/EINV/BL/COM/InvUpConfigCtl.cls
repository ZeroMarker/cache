Import SQLUser

/// 类名 :      BILL.EINV.BL.COM.InvUpConfigCtl
/// 描述 :      计费发票上传配置
/// 编写者:     杜伟晨
/// 编写日期:   2019-09-16
Class BILL.EINV.BL.COM.InvUpConfigCtl Extends %RegisteredObject
{

/// 功能说明：获取电子发票服务器地址、端口号、密钥等配置信息对象
/// 入参说明：HospitalDr  --> 院区编码
/// w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig(2, "")
ClassMethod GetUploadConfig(HospitalDr As %String, ByRef ConfigObj As BILL.EINV.PO.InvUpConfig) As %String
{
	set IUCRowID=""
	if (+HospitalDr>0) {
		set IUCRowID=$o(^BILL.EINV.PO.InvUpConfigI("IdxHospitalDR",HospitalDr,0))
	}
	//根据医院取不到时取第一个
	if (+IUCRowID=0) {
		set IUCRowID=$o(^BILL.EINV.PO.InvUpConfigD(0))
	}
	quit:(+IUCRowID=0) 0
	
	set ConfigObj=##class(BILL.EINV.PO.InvUpConfig).%OpenId(IUCRowID)
	quit:('$IsObject(ConfigObj)) 0
	
	quit 1
}

ClassMethod CreateTestConfigObj(ByRef ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s ObjUPConfig=##class(BILL.EINV.PO.InvUpConfig).%New()
	s ObjUPConfig.IUCTimeout="10"
	s ObjUPConfig.IUCServer="128.28.19.130"
	s ObjUPConfig.IUCPort="7001"
	s ObjUPConfig.IUCSecretKey="cb1a968f00093c538b562c70c3"
	s ObjUPConfig.IUCSerPath="medical-web/api/medical"
	s ObjUPConfig.IUCAPPID="YBRMYY8870938"
	s ObjUPConfig.IUCVersion="1"
	
	q 1
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:： 查询invUpConfig信息
/// Table：       被访问的表 InvUpConfig
/// Output       ID 
/// 				IUCAPPID       应用帐号
///             IUCActiveFlag  启用标志
/// 			IUCInvoiceType 票据监管类型
/// 				IUCPort		   端口号
/// 				IUCSecretKey   单位校验KEY
/// 				IUCSerPath	   路径
/// 				IUCServer	   票据服务器地址
/// 				IUCStyle	   票据种类
/// 				IUCTimeout     服务延时
/// 				IUCUploadWay   票据开具或上传方式
/// 				IUCVersion	   版本号
/// 				HospitalNo     医院编码
///                 FactoryCode    开发商编码
/// 				FactoryDesc    开发商名称
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvUpConfigCtl","QueryInvUpConfigInfo")
Query QueryInvUpConfigInfo(qHospitalNo As %String = "", qFactoryCode As %String = "") As websys.Query(ROWSPEC = "ID:%String,IUCServer:%String,IUCPort:%String,IUCTimeout:%String,IUCSerPath:%String,IUCVersion:%String,IUCAPPID:%String,IUCSecretKey:%String,IUCInvoiceType:%String,IUCActiveFlag:%String,IUCUploadWay:%String,IUCStyle:%String,HospitalNo:%String,FactoryCode:%String,FactoryDesc:%String,HospDesc:%String")
{
}

ClassMethod QueryInvUpConfigInfoExecute(ByRef qHandle As %Binary, qHospitalNo As %String = "", qFactoryCode As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    set ID=0
    for  set ID=$o(^BILL.EINV.PO.InvUpConfigD(ID)) quit:(ID="")  do
    .set list=$g(^BILL.EINV.PO.InvUpConfigD(ID)) ;获取数据串
    .set IUCServer=$lg(list,2)           ;票据服务器地址
    .set IUCPort=$lg(list,3)	           ;端口号
    .set IUCTimeout=$lg(list,4)		   ;服务延时
    .set IUCSerPath=$lg(list,5)		   ;路径
    .set IUCVersion=$lg(list,6)		   ;版本号
    .set IUCAPPID=$lg(list,7)			   ;应用帐号
    .set IUCSecretKey=$lg(list,8)		   ;单位校验KEY
    .set IUCInvoiceType=$lg(list,9)	   ;票据监管类型
    .set IUCActiveFlag=$lg(list,10)	   ;启用标志
    .set IUCUploadWay=$lg(list,11)	   ;票据开具或上传方式
    .set IUCStyle=$lg(list,12)		   ;票据种类
    .set HospitalNo=$lg(list,13)         ;医院编码
    .set FactoryCode=$lg(list,14) 	   ;开发商编码
    .set FactoryDesc=$lg(list,15)        ;开发商名称
    .set HospId=$lg(list,17)             ;医院
    .set HospDesc=$s((+HospId'=0):$p($g(^CT("HOSP",HospId)),"^",2),1:"")
    .do OutputRow

    quit $$$OK
OutputRow
	set Data=$lb(ID,IUCServer,IUCPort,IUCTimeout,IUCSerPath,IUCVersion,IUCAPPID,IUCSecretKey,IUCInvoiceType,IUCActiveFlag,IUCUploadWay,IUCStyle,HospitalNo,FactoryCode,FactoryDesc,HospDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   向表中添加数据
/// Table：        被访问的表(BILL.EINV.PO.InvUpConfig)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).SaveInvUpConfigInfo("102^8081^10ms^com^1.1^0001^key^E^Y^N^V^00002^002^博思")
ClassMethod SaveInvUpConfigInfo(DataStr As %String) As %String
{
	q:$g(DataStr)="" "添加失败，数据为空！"
	s result=""
	TSTART 										;开启事务
	s FactoryCode=$p(DataStr,"^",13)     
	//判断数据是否存在
	i ($d(^BILL.EINV.PO.InvUpConfigI("IdxFactoryCode",FactoryCode))>0) { 
		//TROLLBACK
		q "接口或任务已存在，无法添加数据！"
	}
	s obj=##class(BILL.EINV.PO.InvUpConfig).%New() ;获取对象
	//给对象赋值
	if (obj) {
		s HospId=$p(DataStr,"^",12)
		s obj.IUCServer=$p(DataStr,"^",1) 
		s obj.IUCPort=$p(DataStr,"^",2)
		s obj.IUCTimeout=$p(DataStr,"^",3)
		s obj.IUCSerPath=$p(DataStr,"^",4)
		s obj.IUCVersion=$p(DataStr,"^",5)
		s obj.IUCAPPID=$p(DataStr,"^",6)
		s obj.IUCSecretKey=$p(DataStr,"^",7)
		s obj.IUCInvoiceType=$p(DataStr,"^",8)
		s obj.IUCActiveFlag=$p(DataStr,"^",9)
		s obj.IUCUploadWay=$p(DataStr,"^",10)
		s obj.IUCStyle=$p(DataStr,"^",11)
		s obj.HospitalNo=$s((+HospId'=0):$p($g(^CT("HOSP",HospId)),"^",1),1:"")
		d obj.HospitalDRSetObjectId(HospId)
		s obj.FactoryCode=$p(DataStr,"^",13)
		s obj.FactoryDesc=$p(DataStr,"^",14)
		s sc = obj.%Save()						;保存对象
		if ($$$ISOK(sc)) {
			TCOMMIT								;提交事务
			s result="数据添加成功"_obj.%Id()
		} else { 
			TROLLBACK						;回滚事务
			s result="数据添加失败:"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Save()						;关闭对象
	} else {
		TROLLBACK							;回滚事务
		s result="添加数据失败，对象创建失败！"
	}
	q result
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   更具ID删除表中数据
/// Table：        被访问的表(BILL.EINV.PO.InvUpConfig)
/// Input：        ID
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).DeleteInvUpConfigInfo("3")
ClassMethod DeleteInvUpConfigInfo(ID As %String) As %String
{
	quit:(ID="") "ID为空"
	set result="数据删除成功！"
	set sc=##class(BILL.EINV.PO.InvUpConfig).%DeleteId(ID)	;创建对象
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		set result=$system.Status.GetErrorText(sc)
	}
	quit result
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   更新表中数据
/// Table：        被访问的表(BILL.EINV.PO.InvUpConfig)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).UpdateInvUpConfigInfo("1^192.168.1.88^2020^10^imdical^1^ddd^fab03b86e8da1e577a05524073^E^Y^N^V^3^BS^博思")
ClassMethod UpdateInvUpConfigInfo(DataStr As %String) As %String
{
	q:$g(DataStr)="" "更新失败，数据为空！"
	s result=""
	TSTART														;开启事务
	s ID=$p(DataStr,"^",1)										;ID
	q:(ID="") "ID为空，无法修改数据！"
	s obj=##class(BILL.EINV.PO.InvUpConfig).%OpenId(ID)	       ;获取对象
	//给对象赋值
	if (obj) {
		s HospId=$p(DataStr,"^",13)
		s obj.IUCServer=$p(DataStr,"^",2)
		s obj.IUCPort=$p(DataStr,"^",3)
		s obj.IUCTimeout=$p(DataStr,"^",4)
		s obj.IUCSerPath=$p(DataStr,"^",5)
		s obj.IUCVersion=$p(DataStr,"^",6)
		s obj.IUCAPPID=$p(DataStr,"^",7)
		s obj.IUCSecretKey=$p(DataStr,"^",8)
		s obj.IUCInvoiceType=$p(DataStr,"^",9)
		s obj.IUCActiveFlag=$p(DataStr,"^",10)
		s obj.IUCUploadWay=$p(DataStr,"^",11)
		s obj.IUCStyle=$p(DataStr,"^",12)
		s obj.HospitalNo=$s((+HospId'=0):$p($g(^CT("HOSP",HospId)),"^",1),1:"")
		d obj.HospitalDRSetObjectId(HospId)
		s obj.FactoryCode=$p(DataStr,"^",14)
		s obj.FactoryDesc=$p(DataStr,"^",15)
		s sc = obj.%Save()										;保存对象
		if ($$$ISOK(sc)) {
			TCOMMIT												;提交事务
			s id=obj.%Id()
			s result="数据更新成功"
		} else {
			TROLLBACK											;回滚事务
			s ErrorInfo=$SYSTEM.OBJ.DisplayError(sc)
			s result="数据更新失败："_ErrorInfo
		}
		d obj.%Save()							;关闭对象
	}else {
		TROLLBACK								;回滚事务
		s result="更新数据失败：对象创建失败"	
	}
	
	q result
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   查询表中数据通过ID
/// Table：        被访问的表(BILL.EINV.PO.InvUpConfig)
/// Input：        ID
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).getInvUpConfigInfo("1")
ClassMethod getInvUpConfigInfo(ID As %String) As %String
{
	q:(ID="") "查询失败，数据为空！"
	
    s list=$g(^BILL.EINV.PO.InvUpConfigD(ID)) ;获取数据串
    s IUCServer=$lg(list,2)            ;票据服务器地址
    s IUCPort=$lg(list,3)	           ;端口号
    s IUCTimeout=$lg(list,4)		   ;服务延时
    s IUCSerPath=$lg(list,5)		   ;路径
    s IUCVersion=$lg(list,6)		   ;版本号
    s IUCAPPID=$lg(list,7)			   ;应用帐号
    s IUCSecretKey=$lg(list,8)		   ;单位校验KEY
    s IUCInvoiceType=$lg(list,9)	   ;票据监管类型
    s IUCActiveFlag=$lg(list,10)	   ;启用标志
    s IUCUploadWay=$lg(list,11)	       ;票据开具或上传方式
    s IUCStyle=$lg(list,12)		       ;票据种类
    s HospitalNo=$lg(list,13)          ;医院编码
    s FactoryCode=$lg(list,14) 	       ;开发商编码
    s FactoryDesc=$lg(list,15)         ;开发商名称
    s HospitalDR=$lg(list,17)          ;医院代码

    s result=IUCServer_"^"_IUCPort_"^"_IUCTimeout_"^"_IUCSerPath_"^"_IUCVersion_"^"_IUCAPPID
    s result=result_"^"_IUCSecretKey_"^"_IUCInvoiceType_"^"_IUCActiveFlag_"^"_IUCUploadWay_"^"_IUCStyle
    s result=result_"^"_HospitalNo_"^"_FactoryCode_"^"_FactoryDesc_"^"_HospitalDR
    
    q result
}

/// 功能说明：导入电子票据系统的字典信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// 修改履历：杜伟晨 2019 09 29  新做成
/// s RowDataInfo=""
/// s ErrMsg=""
/// w ##class(BILL.EINV.BL.COM.InvUpConfigCtl).ImportInvUpConfigByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportInvUpConfigByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s RtnFlg="0"
	
	s FactoryCode=$p(RowDataInfo, "^", 13)   ;开发商编码
	s:(FactoryCode="") ErrMsg="开发商编码不能为空。"
	q:(FactoryCode="") RtnFlg
	
	ts
	set Rowid=$o(^BILL.EINV.PO.InvUpConfigI("IdxFactoryCode",FactoryCode,""))
	if (Rowid="") {
		s objDicData=##class(BILL.EINV.PO.InvUpConfig).%New()
	}else {
		s objDicData=##class(BILL.EINV.PO.InvUpConfig).%OpenId(Rowid)
	}
	
	s objDicData.IUCServer=$p(RowDataInfo,"^",1)       ;票据服务器地址
	s objDicData.IUCPort=$p(RowDataInfo,"^",2)       ;端口号
	s objDicData.IUCTimeout=$p(RowDataInfo,"^",3)       ;服务延时
	s objDicData.IUCSerPath=$p(RowDataInfo,"^",4)      ;路径
	s objDicData.IUCVersion=$p(RowDataInfo,"^",5)      ;版本号
	s objDicData.IUCAPPID=$p(RowDataInfo,"^",6)       ;应用帐号
	
	s objDicData.IUCSecretKey=$p(RowDataInfo,"^",7)       ;单位校验KEY
	s objDicData.IUCInvoiceType=$p(RowDataInfo,"^",8)     ;票据监管类型
	s objDicData.IUCActiveFlag=$p(RowDataInfo,"^",9)      ;启用标志
	s objDicData.IUCUploadWay=$p(RowDataInfo,"^",10)      ;票据开具或上传方式
	s objDicData.IUCStyle=$p(RowDataInfo,"^",11)          ;票据种类
	s HospCode=$p(RowDataInfo,"^",12)
	s objDicData.HospitalNo=HospCode                      ;医院编码
	s HospId=$s((HospCode'=""):$o(^CT("HOSP",0,"Code",HospCode,0)),1:"")
	d objDicData.HospitalDRSetObjectId(HospId)
	s objDicData.FactoryCode=$p(RowDataInfo,"^",13)    ;开发商编码
	s objDicData.FactoryDesc=$p(RowDataInfo,"^",14)    ;开发商名称
    s sc=objDicData.%Save()
    if ($$$ISOK(sc)) {
	    tc
	    s RtnFlg=objDicData.%Id()
	}else {
		tro
	}
    
    q RtnFlg
}

/// Creator: ZhYW
/// CreatDate：2020-07-06
/// Description: 查询医院
/// Input:
/// Output:
/// Debug: do ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvUpConfigCtl","QryHospital")
Query QryHospital() As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1

    set id=0
    while($o(^CT("HOSP",id))) {
	    set id=$o(^CT("HOSP",id))
	    set data=$g(^CT("HOSP",id))
	    continue:(data="")
	    set desc=$p(data,"^",2)
	    set dateFrom=$p(data,"^",9)
	    continue:((dateFrom'="")&&(dateFrom>+$h))
		set dateTo=$p(data,"^",10)
		continue:((dateTo'="")&&(dateTo<+$h))
	    do OutputHospital
	}

    quit $$$OK
OutputHospital
	set Data=$lb(id,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
