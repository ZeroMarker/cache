/// 字典相关的处理类
Class BILL.EINV.BL.COM.DicDataCtl Extends %RegisteredObject
{

/// Creator：      DuWC
/// CreatDate：    2019-09-19
/// Description:： 查询DicData信息
/// Table：       被访问的表 BILL.EINV.PO.DicData
/// Output:      	ID 
/// 				DicType      类型
///             	DicCode  	 编码
/// 				DicDesc 	 描述
/// 				DicBill1	 对照信息1
/// 				DicBill2     对照信息2
/// 				DicDemo	   	 备注
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.DicDataCtl","QueryDicDataInfo","LogicIUDType")
Query QueryDicDataInfo(Type As %String = "") As %Query(ROWSPEC = "ID:%String,DicType:%String,DicCode:%String,DicDesc:%String,DicBill1:%String,DicBill2:%String,DicDemo:%String,XStr1:%String,XStr2:%String,XStr3:%String,XStr4:%String,XStr5:%String") [ SqlProc ]
{
}

ClassMethod QueryDicDataInfoExecute(ByRef qHandle As %Binary, Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    s ID=0
    f  s ID=$o(^BILL.EINV.PO.DicDataD(ID)) q:ID=""  d
    .s list=$g(^BILL.EINV.PO.DicDataD(ID)) ;获取数据串
    .s DicType=$lg(list,2)           ;类型
    .;q:'(DicType[Type)
    .q:(Type'="")&&(DicType'=Type)
    .s DicCode=$lg(list,3)	         ;编码
    .s DicDesc=$lg(list,4)		   	 ;描述
    .s DicBill1=$lg(list,5)		     ;对照信息1
    .s DicBill2=$lg(list,6)		     ;对照信息2
    .s DicDemo=$lg(list,7)			 ;备注
    .s XStr1=$lg(list,8)			 ;备用1
    .s XStr2=$lg(list,9)			 ;备用2
    .s XStr3=$lg(list,10)          ;备用3
    .s XStr4=$lg(list,11)          ;备用4
    .s XStr5=$lg(list,12)          ;备用5
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ID,DicType,DicCode,DicDesc,DicBill1,DicBill2,DicDemo,XStr1,XStr2,XStr3,XStr4,XStr5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryDicDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicDataInfoExecute ]
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

ClassMethod QueryDicDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicDataInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      DuWC
/// CreatDate：    2019-09-20
/// Description:： 查询字典类型下拉列表
/// Table：       被访问的表 BILL.EINV.PO.DicData
/// Output:         DicType      类型
///             	DicCode  	 编码
/// 				DicDesc 	 描述
/// 				
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.DicDataCtl","QueryDetComboxInfo")
Query QueryDetComboxInfo() As %Query(ROWSPEC = "DicType:%String,DicCode:%String,DicDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryDetComboxInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    
    s DicType="SYS"
    s DicCode="SYS"	             ;编码
    s DicDesc="系统"		   	 ;描述
    d OutputRow
   
    s code=""
    f  s code=$o(^BILL.EINV.PO.DicDataI("IDataKey", "SYS", code)) q:code=""  d
    .s rowid=""
    .f  s rowid=$o(^BILL.EINV.PO.DicDataI("IDataKey", "SYS", code, rowid)) q:rowid=""  d
    ..s objDicData=##class(BILL.EINV.PO.DicData).%OpenId(rowid)
    ..s DicType=objDicData.DicType           ;类型
    ..s DicCode=objDicData.DicCode	         ;编码
    ..s DicDesc=objDicData.DicDesc		   	 ;描述
    ..d OutputRow
   
   /*
   s ID=0
    f  s ID=$o(^BILL.EINV.PO.DicDataD(ID)) q:ID=""  d
    .s list=$g(^BILL.EINV.PO.DicDataD(ID)) ;获取数据串
    .q:DicType'="SYS"
    .s DicType=$lg(list,2)           ;类型
    .s DicCode=$lg(list,3)	         ;编码
    .s DicDesc=$lg(list,4)		   	 ;描述
    .d OutputRow
    */
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(DicType,DicCode,DicDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryDetComboxInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetComboxInfoExecute ]
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

ClassMethod QueryDetComboxInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetComboxInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   根据ID删除表中数据
/// Table：        被访问的表(BILL.EINV.PO.DicData)
/// Input：        ID
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.EINV.BL.COM.DicDataCtl).DeleteDicDataInfo("3")
ClassMethod DeleteDicDataInfo(ID As %String) As %String
{
	q:ID="" "ID为空"
	s sc = ""
	s result = ""
	TSTART														;开始事务
	s obj = ##class(BILL.EINV.PO.DicData).%OpenId(ID)	;创建对象
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

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   更新表中数据
/// Table：        被访问的表(BILL.EINV.PO.DicData)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.EINV.BL.COM.DicDataCtl).UpdateDicDataInfo("2^SYS^AA^A类^无^无^66")
ClassMethod UpdateDicDataInfo(DataStr As %String) As %String
{
	q:$g(DataStr)="" "更新失败，数据为空！"
	s result = ""
	TSTART														;开启事务
	s ID=$p(DataStr,"^",1)										;ID
	q:$g(ID)="" "ID为空，无法修改数据！"
	s obj = ##class(BILL.EINV.PO.DicData).%OpenId(ID)	;获取对象
	//给对象赋值
	i (obj)
	{
		s obj.DicType=$p(DataStr,"^",2)			
		s obj.DicCode=$p(DataStr,"^",3)
		s obj.DicDesc=$p(DataStr,"^",4)
		s obj.DicBill1=$p(DataStr,"^",5)
		s obj.DicBill2=$p(DataStr,"^",6)
		s obj.DicDemo=$p(DataStr,"^",7)
		
		;+ZhaoZW 2020 01 06 start  
		s obj.XStr1=$p(DataStr,"^",8)			;备注1
		s obj.XStr2=$p(DataStr,"^",9)			;备注2
		s obj.XStr3=$p(DataStr,"^",10)			;备注3
		s obj.XStr4=$p(DataStr,"^",11)			;备注4
		s obj.XStr5=$p(DataStr,"^",12)			;备注5
		s obj.UpdateDate=$p($h,",",1)			;更新日期
		s obj.UpdateTime=$p($h,",",2)			;更新日期
		;+ZhaoZW 2020 01 06 end  
		
					
		s sc = obj.%Save()										;保存对象
		if ($$$ISOK(sc))
		{
			TCOMMIT												;提交事务
			s id = obj.%Id()
			s result = "数据更新成功"_id	
		}
		else
		{
			TROLLBACK											;回滚事务
			s ErrorInfo = $SYSTEM.OBJ.DisplayError(sc)
			s result = "数据更新失败："_ErrorInfo
		}
		d obj.%Save()							;关闭对象
	}
	else
	{
		TROLLBACK								;回滚事务
		s result = "更新数据失败：对象创建失败"	
	}
	q result
}

/// Creator：      DuWC
/// CreatDate：    2019-09-16
/// Description:   向表中添加数据
/// Table：        被访问的表(BILL.EINV.PO.DicData)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##class(BILL.EINV.BL.COM.DicDataCtl).SaveDicdataInfo("AA^abc^A类^无^无^66")
ClassMethod SaveDicdataInfo(DataStr As %String) As %String
{
	;s ^TMPSaveDicdataInfo=$lb(DataStr)
	
	s result=""
	TSTART 										;开启事务
	s DicCode=$p(DataStr,"^",2)    
	;q:$g(DicCode)="" "添加失败，编码为空！"
	//判断数据是否存在
	i ($d(^BILL.EINV.PO.InvUpConfigI("IDataKey",DicCode))>0)
	{ 
		//TROLLBACK
		q "接口或任务已存在，无法添加数据！"
	}
	s obj=##class(BILL.EINV.PO.DicData).%New() ;获取对象
	//给对象赋值
	if (obj)
	{
		s obj.DicType=$p(DataStr,"^",1)			;类型
		s obj.DicCode=$p(DataStr,"^",2)			;编码
		s obj.DicDesc=$p(DataStr,"^",3)			;描述
		s obj.DicBill1=$p(DataStr,"^",4)		;对照信息1
		s obj.DicBill2=$p(DataStr,"^",5)		;对照信息2
		s obj.DicDemo=$p(DataStr,"^",6)			;备注
		
		;+ZhaoZW 2020 01 06 start  
		s obj.XStr1=$p(DataStr,"^",7)			;备注1
		s obj.XStr2=$p(DataStr,"^",8)			;备注2
		s obj.XStr3=$p(DataStr,"^",9)			;备注3
		s obj.XStr4=$p(DataStr,"^",10)			;备注4
		s obj.XStr5=$p(DataStr,"^",11)			;备注5
		s obj.UpdateDate=$p($h,",",1)			;更新日期
		s obj.UpdateTime=$p($h,",",2)			;更新日期
		;+ZhaoZW 2020 01 06 end  
		
		s sc = obj.%Save()						;保存对象
		if ($$$ISOK(sc))
		{
			TCOMMIT								;提交事务
			s result="数据添加成功"_obj.%Id()
		}
		else
		{ 
			TROLLBACK						;回滚事务
			s result="数据添加失败:"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Save()						;关闭对象
	}
	else
	{
		TROLLBACK							;回滚事务
		s result="添加数据失败，对象创建失败！"
	}
	q result
}

/// 功能说明：导入电子票据系统的字典信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// 修改履历：董科锋 2019 09 29  新做成
/// s RowDataInfo="SYS^EInvFarctoryList^电子票据开发商列表^1^2^3^4^5^6^7^8"
/// s ErrMsg=""
/// w ##class(BILL.EINV.BL.COM.DicDataCtl).ImportDicdataByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportDicdataByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s RtnFlg="0"
	
	s DicType=$p(RowDataInfo, "^", 1)   ;字典类型
	s DicCode=$p(RowDataInfo, "^", 2)   ;字典编码
	s:(DicType="")||(DicCode="") ErrMsg="字典类型和字典编码都不能为空。"
	q:(DicType="")||(DicCode="") RtnFlg
	
	s Rowid=$o(^BILL.EINV.PO.DicDataI("IDataKey", DicType, DicCode, ""))
	i Rowid="" d
	.s objDicData=##class(BILL.EINV.PO.DicData).%New()
	e  d
	.s objDicData=##class(BILL.EINV.PO.DicData).%OpenId(Rowid)
	
	s objDicData.DicType=$p(RowDataInfo, "^", 1)       ;类型
	s objDicData.DicCode=$p(RowDataInfo, "^", 2)       ;编码
	s objDicData.DicDesc=$p(RowDataInfo, "^", 3)       ;描述
	s objDicData.DicBill1=$p(RowDataInfo, "^", 4)      ;对照信息1
	s objDicData.DicBill2=$p(RowDataInfo, "^", 5)      ;对照信息2
	s objDicData.DicDemo=$p(RowDataInfo, "^", 6)       ;备注
	
	s objDicData.XStr1=$p(RowDataInfo, "^", 7)     ;扩展字符串1
	s objDicData.XStr2=$p(RowDataInfo, "^", 8)     ;扩展字符串2
	s objDicData.XStr3=$p(RowDataInfo, "^", 9)     ;扩展字符串3
	s objDicData.XStr4=$p(RowDataInfo, "^", 10)    ;扩展字符串4
	s objDicData.XStr5=$p(RowDataInfo, "^", 11)    ;扩展字符串5
	
	s iNowStr=$h
	s iNowDt=$p(iNowStr, ",", 1)
	s iNowTime=$p(iNowStr, ",", 2)
	s objDicData.UpdateUser=UserDr    ;操作员
	s objDicData.UpdateDate=iNowDt    ;更新日期
	s objDicData.UpdateTime=iNowTime  ;更新时间
	
    ///保存数据
    s sc=objDicData.%Save()
    i $System.Status.IsError(sc) d
    .;$system.Status.GetErrorText(sc)
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objDicData.%Id()
    
    q RtnFlg
}

/// 更新开票标志
/// w ##class(BILL.EINV.BL.COM.DicDataCtl).UpDataKPFlag("","Y")
ClassMethod UpDataKPFlag(LogicType As %String, Flag As %String) As %String
{
	s rtn=""
	if LogicType="" d
	.&sql(update BILL_EINV_PO.DicData set DicBill1=:Flag where DicType="BusinessType")
	.s rtn=SQLCODE
	else  d
	.&sql(update BILL_EINV_PO.DicData set DicBill1=:Flag where DicType="BusinessType" and DicCode=:LogicType)
	.s rtn=SQLCODE
	q rtn
}

}
