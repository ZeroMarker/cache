Import SQLUser

/// 名称: 		BILL.EINV.BL.COM.InvLogicPathCtl.cls
/// 描述: 		计费发票路径维护
/// 编写者：	ZhaoZW
/// 编写日期: 	2019-09-16
Class BILL.EINV.BL.COM.InvLogicPathCtl Extends %RegisteredObject
{

/// 功能说明：根据票据业务编码及开发商编码获取配置的业务处理类和方法
/// 入参说明：PathCode    --> 票据业务编码
///           FactoryCode --> 开发商代码
///           ObjInvLogicPath  --> 业务类型配置对象(出参)
///           PathType    --> 业务类型 I 接口 T 任务
/// 返 回 值: 0 成功 -1 负数代表失败
/// 修改履历：董科锋 2019 09 29 新做成
/// w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath
ClassMethod GetInvLogicPath(PathCode As %String, FactoryCode As %String, ByRef ObjInvLogicPath As BILL.EINV.PO.InvLogicPath, PathType As %String = "I") As %String
{
	
	Set RtnFlg="-1"
	q:(PathCode="")||(FactoryCode="")||(PathType="") RtnFlg
	
	s rowid=$o(^BILL.EINV.PO.InvLogicPathI("IdxIUPCode",FactoryCode, PathType, PathCode, ""), -1)
	q:rowid="" RtnFlg
	
	s ObjInvLogicPath=##class(BILL.EINV.PO.InvLogicPath).%OpenId(rowid)
	s ActiveFlag=ObjInvLogicPath.IUPActive
	q:ActiveFlag'="Y" RtnFlg

	s RtnFlg="0"
	q RtnFlg
}

ClassMethod CreateTestLogicPath(ByRef ObjInvLogicPath As BILL.EINV.PO.InvLogicPath) As %String
{
	s ObjInvLogicPath=##class(BILL.EINV.PO.InvLogicPath).%New()
	s ObjInvLogicPath.IUDPrintType="E"
	s ObjInvLogicPath.IUPClassName="BILL.EINV.ADP.BSA"
	s ObjInvLogicPath.IUPMethodName="Invoice"
	
	q "0"
}

/// 功能说明：根据PathCode获取相应业务的处理类和方法名称
///           此方法没有考虑 不同开发商,后续作废
/// w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath
ClassMethod GetUploadPath(PathCode As %String, PathType As %String = "I") As %String
{
	
	Set PathInfo="^"
	Quit:PathCode="" PathInfo
	
	Set id=""
	For  Set id=$o(^BILL.EINV.PO.InvLogicPathI("IDataKey",PathType,PathCode,id)) Quit:id=""  Do
	.Set obj=##class(BILL.EINV.PO.InvLogicPath).%OpenId(id)
	.Set ActiveFlag=obj.IUPActive
	.Quit:ActiveFlag'="Y"
	.Set ClassName=obj.IUPClassName
	.Set MethodName=obj.IUPMethodName
	.Set PathInfo=ClassName_"^"_MethodName
	Quit PathInfo
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-16
/// Description:   向表中添加数据
/// Table：        被访问的表(BILL_EINV_PO.InvLogicPath)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).SaveBillIUPInfo("LocalInterface^zzt^查询接口^DHCBILLZZW^QueryStudentInfo^N^本地接口")
ClassMethod SaveBillIUPInfo(IUPStr As %String) As %String
{
	q:$g(IUPStr)="" "添加失败，数据为空！"
	s result=""
	TSTART 											;开启事务
	s IUPType=$p(IUPStr,"^",1)     					;接口/任务
	s IUPCode=$p(IUPStr,"^",2)     					;接口代码
	//判断数据是否存在
	i ($d(^BILL.EINV.PO.InvLogicPathI("IDataKey",IUPType,IUPCode))>0)
	{ 
		TROLLBACK 									;回滚事务
		q "接口或任务已存在，无法添加数据！"
	}
	s obj=##class(BILL.EINV.PO.InvLogicPath).%New() ;获取对象
	//给对象赋值
	if (obj)
	{
		s obj.IUPType=IUPType
		s obj.IUPCode=IUPCode
		s obj.IUPDesc=$p(IUPStr,"^",3)     			;接口描述
		s obj.IUPClassName=$p(IUPStr,"^",4)			;类名
		s obj.IUPMethodName=$p(IUPStr,"^",5)   		;方法名
		s obj.IUPActive=$p(IUPStr,"^",6)       		;是否启用
		s obj.IUPReMark=$p(IUPStr,"^",7)       		;接口说明
		s obj.IUDPrintType=$p(IUPStr,"^",8)			;票据类型
		s obj.XStr1=$p(IUPStr,"^",9)				;备用1
		s obj.XStr2=$p(IUPStr,"^",10)				;备用2
		s obj.XStr3=$p(IUPStr,"^",11)				;备用3
		s obj.XStr4=$p(IUPStr,"^",12)				;备用4
		s obj.XStr5=$p(IUPStr,"^",13)				;备用5
		s obj.FactoryCode=$p(IUPStr,"^",14)			;开发商编码
		s obj.FactoryDesc=$p(IUPStr,"^",15)			;开发商名称
		s sc = obj.%Save()							;保存对象
		if ($$$ISOK(sc))
		{
			TCOMMIT									;提交事务
			s result="数据添加成功！"
		}
		else
		{ 
			TROLLBACK								;回滚事务
			s result="数据添加失败:"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Save()								;关闭对象
	}
	else
	{
		TROLLBACK									;回滚事务
		s result="添加数据失败，对象创建失败！"
	}
	q result
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-16
/// Description:   更具ID删除表中数据
/// Table：        被访问的表(BILL_EINV_PO.InvLogicPath)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).DeleteBillIUPInfo("9")
ClassMethod DeleteBillIUPInfo(ID As %String) As %String
{
	q:ID="" "ID为空"
	s sc = ""
	s result = ""
	TSTART														;开始事务
	s obj = ##class(BILL.EINV.PO.InvLogicPath).%OpenId(ID)		;创建对象
	if (obj)
	{
		s sc = obj.%DeleteId(ID)
		if ($$$ISOK(sc))
		{
			TCOMMIT												;提交事务
			s result = "数据删除成功！"
		}
		else
		{
			//回滚事务
			TROLLBACK
			s ErrorInfo = $SYSTEM.OBJ.DisplayError(sc)
			s result = "数据删除失败，失败原因："_ErrorInfo	
		}
		d obj.%Close()
	}
	else
	{
		TROLLBACK												;回滚事务
		s result = "数据删除失败，失败原因：创建对象失败！"	
	}
	q result
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-16
/// Description:   根据ID查询表中数据
/// Table：        被访问的表(BILL_EINV_PO.InvLogicPath)
/// Input：        输入参数说明，包括每个参数的作用、取值说明及参数间关系。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:		   w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetBillIUPInfo("2")
ClassMethod GetBillIUPInfo(ID As %String) As %String
{
	q:$g(ID)="" ""
	s list=$g(^BILL.EINV.PO.InvLogicPathD(ID))                ;获取数据串
    s IUPType=$lg(list,2)									  ;接口/任务
    s IUPCode=$lg(list,3)									  ;接口代码
    s IUPDesc=$lg(list,4)									  ;接口描述
    s IUPClassName=$lg(list,5)							  	  ;类名
    s IUPMethodName=$lg(list,6)							      ;方法名
    s IUPActive=$lg(list,7)								      ;是否启用
    s IUPReMark=$lg(list,8)								      ;接口说明
    s IUDPrintType=$lg(list,9)								  ;票据类型
    s XStr1=$lg(list,10)									  ;备用1
    s XStr2=$lg(list,11)									  ;备用2
    s XStr3=$lg(list,12)									  ;备用3
    s XStr4=$lg(list,13)									  ;备用4
    s XStr5=$lg(list,14)									  ;备用5
    s FactoryCode=$lg(list,15)								  ;开发商编码
    s FactoryDesc=$lg(list,16)								  ;开发商名称
	s IUPStr=IUPType_"^"_IUPCode_"^"_IUPDesc_"^"_IUPClassName_"^"_IUPMethodName_"^"_IUPActive_"^"_IUPReMark
	s IUPStr=IUPStr_"^"_IUDPrintType_"^"_XStr1_"^"_XStr2_"^"_XStr3_"^"_XStr4_"^"_XStr5_"^"_FactoryCode_"^"_FactoryDesc
	q IUPStr
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-16
/// Description:   查询表中数据
/// Table：        被访问的表(BILL_EINV_PO.InvLogicPath)
/// Input：        输入参数说明，包括每个参数的作用、取值说明及参数间关系。
/// Output：       ID : ID IUPType : 接口/任务 IUPCode : 接口代码 IUPDesc : ;接口描述
///                IUPClassName : 类名 IUPMethodName : 方法名 IUPActive : 是否启用 IUPReMark : 接口说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvLogicPathCtl","QueryBillIUPInfo","","")
Query QueryBillIUPInfo(PIUPType As %String = "", PIUPDesc As %String = "") As %Query(ROWSPEC = "ind,ID:%String,IUPType:%String,IUPCode:%String,IUPDesc:%String,IUPClassName:%String,IUPMethodName:%String,IUPActive:%String,IUPReMark:%String,IUDPrintType:%String,XStr1:%String,XStr2:%String,XStr3:%String,XStr4:%String,XStr5:%String,FactoryCode:%String,FactoryDesc:%String")
{
}

ClassMethod QueryBillIUPInfoExecute(ByRef qHandle As %Binary, PIUPType As %String = "", PIUPCode As %String = "", PIUPDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    s ID=0
    f  s ID=$o(^BILL.EINV.PO.InvLogicPathD(ID)) q:ID=""  d
    .s list=$g(^BILL.EINV.PO.InvLogicPathD(ID))            	  ;获取数据串
    .s IUPType=$lg(list,2)									  ;接口/任务
    .q:(PIUPType'="")&&(PIUPType'=IUPType)			  
    .s IUPCode=$lg(list,3)									  ;接口代码					  				  
    .s IUPDesc=$lg(list,4)									  ;接口描述
    .q:'(IUPDesc[PIUPDesc)					  
    .s IUPClassName=$lg(list,5)							  	  ;类名
    .s IUPMethodName=$lg(list,6)							  ;方法名
    .s IUPActive=$lg(list,7)								  ;是否启用
    .s IUPReMark=$lg(list,8)								  ;接口说明
    .s IUDPrintType=$lg(list,9)								  ;票据类型
    .s XStr1=$lg(list,10)									  ;备用1
    .s XStr2=$lg(list,11)									  ;备用2
    .s XStr3=$lg(list,12)									  ;备用3
    .s XStr4=$lg(list,13)									  ;备用4
    .s XStr5=$lg(list,14)									  ;备用5
    .s FactoryCode=$lg(list,15)								  ;开发商编码
    .s FactoryDesc=$lg(list,16)								  ;开发商名称
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,ID,IUPType,IUPCode,IUPDesc,IUPClassName,IUPMethodName,IUPActive,IUPReMark,IUDPrintType,XStr1,XStr2,XStr3,XStr4,XStr5,FactoryCode,FactoryDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind_1
	q
}

ClassMethod QueryBillIUPInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBillIUPInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBillIUPInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBillIUPInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-16
/// Description:   查询表中数据数据
/// Table：        被访问的表(BILL_EINV_PO.InvLogicPath)
/// Input：        输入参数说明，包括每个参数的作用、取值说明及参数间关系。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod UpdateBillIUPInfo(IUPStr As %String) As %String
{
	q:$g(IUPStr)="" "更新失败，数据为空！"
	s result = ""
	TSTART													;开启事务
	s ID=$p(IUPStr,"^",1)									;ID
	q:$g(ID)="" "ID为空，无法修改数据！"
	s obj = ##class(BILL.EINV.PO.InvLogicPath).%OpenId(ID)	;获取对象
	//给对象赋值
	i (obj)
	{
		s obj.IUPType=$p(IUPStr,"^",2)						;接口/任务
		s obj.IUPCode=$p(IUPStr,"^",3)						;接口代码
		s obj.IUPDesc=$p(IUPStr,"^",4)     					;接口描述
		s obj.IUPClassName=$p(IUPStr,"^",5)					;类名
		s obj.IUPMethodName=$p(IUPStr,"^",6)   				;方法名
		s obj.IUPActive=$p(IUPStr,"^",7)       				;是否启用
		s obj.IUPReMark=$p(IUPStr,"^",8)       				;接口说明
		s obj.IUDPrintType=$p(IUPStr,"^",9)					;票据类型
		s obj.XStr1=$p(IUPStr,"^",10)						;备用1
		s obj.XStr2=$p(IUPStr,"^",11)						;备用2
		s obj.XStr3=$p(IUPStr,"^",12)						;备用3
		s obj.XStr4=$p(IUPStr,"^",13)						;备用4
		s obj.XStr5=$p(IUPStr,"^",14)						;备用5
		s obj.FactoryCode=$p(IUPStr,"^",15)					;开发商编码
		s obj.FactoryDesc=$p(IUPStr,"^",16)					;开发商名称
		s sc = obj.%Save()									;保存对象
		if ($$$ISOK(sc))
		{
			TCOMMIT											;提交事务
			s result = "数据更新成功！"	
		}
		else
		{
			TROLLBACK										;回滚事务
			s ErrorInfo = $SYSTEM.OBJ.DisplayError(sc)
			s result = "数据更新失败："_ErrorInfo
		}
		d obj.%Save()										;关闭对象
	}
	else
	{
		TROLLBACK											;回滚事务
		s result = "更新数据失败：对象创建失败"	
	}
	q result
}

/// 功能说明：导入电子发票业务的字典信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// s RowDataInfo="I^test^desc^classname^methodname^N^测试^C^1^2^3^4^5"
/// s ErrMsg=""
/// w ##class(BILL.EINV.BL.COM.InvLogicPathCtl).ImportInvLogicPathByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportInvLogicPathByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	;s ^CacheTemp("ImportInvLogicPathByExcel")=RowDataInfo
	s RtnFlg="0"
	
	s IUPType=$p(RowDataInfo, "^", 1)   ;接口/任务
	s IUPCode=$p(RowDataInfo, "^", 2)   ;接口代码
	s:(IUPType="")||(IUPCode="") ErrMsg="接口/任务和接口代码都不能为空。"
	q:(IUPType="")||(IUPCode="") RtnFlg
	
	s Rowid=$o(^BILL.EINV.PO.InvLogicPathI("IDataKey", IUPType, IUPCode, ""))
	i Rowid="" d
	.s objInvLogicPath=##class(BILL.EINV.PO.InvLogicPath).%New()
	e  d
	.s objInvLogicPath=##class(BILL.EINV.PO.InvLogicPath).%OpenId(Rowid)
	
	s objInvLogicPath.IUPType=$p(RowDataInfo, "^", 1)       ;接口/任务
	s objInvLogicPath.IUPCode=$p(RowDataInfo, "^", 2)       ;接口代码
	s objInvLogicPath.IUPDesc=$p(RowDataInfo, "^", 3)       ;接口描述
	s objInvLogicPath.IUPClassName=$p(RowDataInfo, "^", 4)  ;类名
	s objInvLogicPath.IUPMethodName=$p(RowDataInfo, "^", 5) ;方法名
	s objInvLogicPath.IUPActive=$p(RowDataInfo, "^", 6)     ;是否启用
	s objInvLogicPath.IUPReMark=$p(RowDataInfo, "^", 7)     ;接口说明
	s objInvLogicPath.IUDPrintType=$p(RowDataInfo, "^", 8)  ;票据类型
	s objInvLogicPath.FactoryCode=$p(RowDataInfo, "^", 9)  	;开发商编码
	s objInvLogicPath.FactoryDesc=$p(RowDataInfo, "^", 10) 	;开发商名称
	s objInvLogicPath.XStr1=$p(RowDataInfo, "^", 11)     	;扩展字符串1
	s objInvLogicPath.XStr2=$p(RowDataInfo, "^", 12)        ;扩展字符串2
	s objInvLogicPath.XStr3=$p(RowDataInfo, "^", 13)        ;扩展字符串3
	s objInvLogicPath.XStr4=$p(RowDataInfo, "^", 14)        ;扩展字符串4
	s objInvLogicPath.XStr5=$p(RowDataInfo, "^", 15)        ;扩展字符串5
	
    ///保存数据
    s sc=objInvLogicPath.%Save()
    i $System.Status.IsError(sc) d
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objInvLogicPath.%Id()
    
    q RtnFlg
}

}
