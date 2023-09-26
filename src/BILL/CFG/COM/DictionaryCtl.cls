/// 名称: BILL.CFG.COM.DictionaryCtl.cls
/// 描述: 计费字典相关业务类
/// 编写者: ZhYW
/// 编写日期: 2022-02-28
/// 产品组：计费医保组
Class BILL.CFG.COM.DictionaryCtl Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.DictionaryCtl","QryDicListByType","YesOrNo",2)
Query QryDicListByType(dicType As %String) As websys.Query(ROWSPEC = "id:%String,code:%String:代码,text:%String:描述")
{
}

ClassMethod QryDicListByTypeExecute(ByRef qHandle As %Binary, dicType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	quit:(dicType="") $$$OK
 	
 	set dicId=0
 	while($o(^CF.BILL.COM.DictionaryI("IDicType",dicType,dicId))) {
	 	set dicId=$o(^CF.BILL.COM.DictionaryI("IDicType",dicType,dicId))
	 	set dicData=$g(^CF.BILL.COM.DictionaryD(dicId))
	 	set code=$lg(dicData,3)
	 	set desc=$lg(dicData,4)
	 	do OutputDicList
	}
	
	quit $$$OK
	
OutputDicList
	set Data=$lb(dicId,code,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: zjb
/// CreatDate: 2022-08-18
/// Description: 查询字典维护树数据
/// Input: 
/// Output: 
/// do ##class(%ResultSet).RunQuery("BILL.CFG.COM.DictionaryCtl","QryDicTree","")
Query QryDicTree(hospDr = "") As websys.Query(ROWSPEC = "_parentId,Rowid,TreeStatus,DicType,DicCode,DicDesc,ID,DicTypeD,DicCodeD,DicDescD,DefaultValue,DicMemo,DateFrom,DateTo,Creator,DicMemo,DataSrcFilterMode,DataSrcTableProperty")
{
}

ClassMethod QryDicTreeExecute(ByRef qHandle As %Binary, hospDr = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1
    ;s ^TMP("QueryDetComboxInfoExecute")=$lb(hospDr)
    //if hospDr="" s hospDr=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
    s DicType="SYS"
    s DicCode="SYS"	             ;编码
    s DicDesc="系统"		   	 ;描述
    s TreeStatus="0"
    s Rowid=DicCode
    s parentId=""
    d OutputDicTreeOut
    s TreeStatus="1"
    s (ID,DicTypeD,DicCodeD,DicDescD,DefaultValue,DicMemo,DateFrom,DateTo,Creator,DicMemo,DataSrcFilterMode,DataSrcTableProperty)=""
    d GetDicListByDicType
	
    s Rowid="0"
    s code=""
    f  {
	    s code=$o(^CF.BILL.COM.DictionaryI("IDataKey", "SYS", code)) 
	    q:code=""  
        s rowid=""
        f {
	        s rowid=$o(^CF.BILL.COM.DictionaryI("IDataKey", "SYS", code, rowid)) 
	        q:rowid=""  
            s objDicData=##class(CF.BILL.COM.Dictionary).%OpenId(rowid)
            s hospid=objDicData.HospDR
            ;continue:(hospid'=hospDr)
            s (ID,DicTypeD,DicCodeD,DicDescD,DefaultValue,DicMemo,DateFrom,DateTo,Creator,DicMemo,DataSrcFilterMode,DataSrcTableProperty)=""
            s DicType=objDicData.DicType           ;类型
            s DicCode=objDicData.DicCode	         ;编码
            s DicDesc=objDicData.DicDesc		   	 ;描述
            s TreeStatus="0"
            s Rowid=DicCode
            s parentId=""
    		d OutputDicTreeOut
    		s TreeStatus="1"
            d GetDicListByDicType
          
   
	     } 
	 }
    Quit $$$OK
    
GetDicListByDicType
    s ID=0
	if (DicCode=""){
    	for {
	   		s ID=$o(^CF.BILL.COM.DictionaryD(ID)) 
	   		q:ID=""  
	   		s Rowid=ID
	   		s parentId=DicCode
    		s list=$g(^CF.BILL.COM.DictionaryD(ID)) ;获取数据串
     		d GetDicDetailByDicType
    		d OutputDicTreeOut 
 		}
	}else{
		 for {
	   		s ID=$o(^CF.BILL.COM.DictionaryI("IDicType",DicCode,ID)) 
	   		q:ID=""  
	   		s Rowid=ID
	   		s parentId=DicCode
    		s list=$g(^CF.BILL.COM.DictionaryD(ID)) ;获取数据串
    		d GetDicDetailByDicType
    		d OutputDicTreeOut 
	 	}
	}
	q

GetDicDetailByDicType
	s DicTypeD=$lg(list,2)           		; 类型
    s DicCodeD=$lg(list,3)	         		; 编码
    s DicDescD=$lg(list,4)		   	 		; 描述
    s DefaultValue=$lg(list,5)		     	; 默认值
    s DateFrom=$lg(list,7)		 			; 开始日期
    s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
    s DateTo=$lg(list,8)			 		; 结束日期
    s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
    s Creator=$lg(list,9)			 		; 创建人
    s DicMemo=$lg(list,10)          		; 备注
    s DataSrcFilterMode=$lg(list,11)		; 数据源检索模式
	s DataSrcTableProperty=$lg(list,12)		; 数据源表名及字段名
	quit
    
OutputDicTreeOut
	//s Rowid=$i(Rowid,1)
	set Data=$lb(parentId,Rowid,TreeStatus,DicType,DicCode,DicDesc,ID,DicTypeD,DicCodeD,DicDescD,DefaultValue,DicMemo,DateFrom,DateTo,Creator,DicMemo,DataSrcFilterMode,DataSrcTableProperty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

/// Creator：      Hanll
/// CreatDate：    2022-02-24
/// Description:： 查询DicData信息
/// Table：       被访问的表 CF.BILL.COM.Dictionary
/// Output:      	ID 
/// 				DicType      类型
///             	DicCode  	 编码
/// 				DicDesc 	 描述
/// 				DefaultValue 默认值	
/// 				HospDR      院区
/// 				DateFrom	 开始日期  	 
///  				DateTo      结束日期
/// 				Creator      创建人
/// 				DicMemo		 备注
/// 				DataSrcFilterMode	数据源检索模式
/// 				DataSrcTableProperty	数据源表名及字段名
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.CFG.COM.DictionaryCtl","QueryDicDataInfo","QUERY")
Query QueryDicDataInfo(Type As %String = "", KeyCode = "") As websys.Query(ROWSPEC = "ID:%String,DicType:%String,DicCode:%String,DicDesc:%String,DefaultValue:%String,DicMemo:%String,StartDate:%String,DateTo:%String,Creator:%String,DicMemo:%String,DataSrcFilterMode:%String,DataSrcTableProperty:%String,ActFlag:%String") [ SqlProc ]
{
}

ClassMethod QueryDicDataInfoExecute(ByRef qHandle As %Binary, Type As %String = "", KeyCode = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
    s ID=0
    if (Type=""){
	    for {
	   		s ID=$o(^CF.BILL.COM.DictionaryD(ID)) 
	   		q:ID=""  
    		s list=$g(^CF.BILL.COM.DictionaryD(ID)) ;获取数据串
     		d getDicData
    		d OutputRow 
	 	}
	}else{
		 for {
	   		s ID=$o(^CF.BILL.COM.DictionaryI("IDicType",Type,ID)) 
	   		q:ID=""  
    		s list=$g(^CF.BILL.COM.DictionaryD(ID)) ;获取数据串
    		d getDicData
    		d OutputRow 
	 	}
	}
    quit $$$OK
getDicData
	s DicType=$lg(list,2)           		; 类型
    s DicCode=$lg(list,3)	         		; 编码
    s DicDesc=$lg(list,4)		   	 		; 描述
    s DefaultValue=$lg(list,5)		     	; 默认值
    s DateFrom=$lg(list,7)		 			; 开始日期
    s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
    s DateTo=$lg(list,8)			 		; 结束日期
    s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
    s Creator=$lg(list,9)			 		; 创建人
    s DicMemo=$lg(list,10)          		; 备注
    s DataSrcFilterMode=$lg(list,11)		; 数据源检索模式
	s DataSrcTableProperty=$lg(list,12)		; 数据源表名及字段名
	s ActFlag=$lg(list,13)					; 有效标志
	quit
	
OutputRow
	q:(KeyCode'="")&&(DicDesc'[KeyCode)&&($$ALPHAUP^SSUTIL4(DicCode)'[tCodeAndDesc)
	//需要输出的列
	set Data=$lb(ID,DicType,DicCode,DicDesc,DefaultValue,DicMemo,DateFrom,DateTo,Creator,DicMemo,DataSrcFilterMode,DataSrcTableProperty,ActFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator：      Hanll
/// CreatDate：    2022-02-24
/// Description:： 查询字典类型下拉列表
/// Table：       被访问的表 CF.BILL.COM.Dictionary
/// Output:         DicType      类型
///             	DicCode  	 编码
/// 				DicDesc 	 描述
/// 				
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.CFG.COM.DictionaryCtl","QueryDetComboxInfo")
Query QueryDetComboxInfo(hospDr As %String = "", KeyCode = "") As websys.Query(ROWSPEC = "DicType:%String,DicCode:%String,DicDesc:%String,DicNum") [ SqlProc ]
{
}

ClassMethod QueryDetComboxInfoExecute(ByRef qHandle As %Binary, hospDr As %String = "", KeyCode = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s ^TMP("QueryDetComboxInfoExecute")=$lb(hospDr)
    if hospDr="" s hospDr=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
    s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
    s DicType="SYS"
    s DicCode="SYS"	             ;编码
    s DicDesc="系统"		   	 ;描述
    d GetDicCodeNum
    d OutputRow
   
    s code=""
    f  {
	    s code=$o(^CF.BILL.COM.DictionaryI("IDataKey", "SYS", code)) 
	    q:code=""  
        s rowid=""
        f {
	        s rowid=$o(^CF.BILL.COM.DictionaryI("IDataKey", "SYS", code, rowid)) 
	        q:rowid=""  
            s objDicData=##class(CF.BILL.COM.Dictionary).%OpenId(rowid)
            s hospid=objDicData.HospDR
            ;continue:(hospid'=hospDr)
            s DicType=objDicData.DicType           ;类型
            s DicCode=objDicData.DicCode	         ;编码
            s DicDesc=objDicData.DicDesc		   	 ;描述
            q:(KeyCode'="")&&(DicDesc'[KeyCode)&&($$ALPHAUP^SSUTIL4(DicCode)'[tCodeAndDesc)
			d GetDicCodeNum
            d OutputRow
	     } 
	 }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

GetDicCodeNum
    s Num=0
    s ID=0
	if (DicCode=""){
	for {
   		s ID=$o(^CF.BILL.COM.DictionaryD(ID)) 
   		q:ID=""  
   		s Num=$i(Num,1)
 	}
	}else{
		 for {
	   		s ID=$o(^CF.BILL.COM.DictionaryI("IDicType",DicCode,ID)) 
	   		q:ID=""  
	   		s Num=$i(Num,1)
	 	}
	} 
    q
    
OutputRow
	set Data=$lb(DicType,DicCode,DicDesc,Num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

/// Creator：      Hanll
/// CreatDate：    2022-02-24
/// Description:   向表中添加数据
/// Table：        被访问的表(CF.BILL.COM.Dictionary)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##class(BILL.CFG.COM.DictionaryCtl).SaveDicdataInfo("SYS^DicType02^类别02^0^住院^2022-02-25^2022-02-26^收费01^备注02")
ClassMethod SaveDicdataInfo(DataStr As %String) As %String
{
	s result=""
	s ^TMP("SaveDicdataInfo")=$lb(DataStr)
	TSTART 										;开启事务
	s DicType=$p(DataStr,"^",1)
	s DicCode=$p(DataStr,"^",2)
	//判断数据是否存在
	i ($d(^CF.BILL.COM.DictionaryI("IDataKey",DicType,DicCode))>0)
	{ 
		TROLLBACK
		q "数据已经存在,不需要更新"
	}
	s obj=##class(CF.BILL.COM.Dictionary).%New() ;获取对象
	//给对象赋值
	if (obj)
	{
		s obj.DicType=$p(DataStr,"^",1)			;类型
		s obj.DicCode=$p(DataStr,"^",2)			;编码
		s obj.DicDesc=$p(DataStr,"^",3)			;描述
		s obj.DefaultValue=$p(DataStr,"^",4)		;默认值
		s obj.DateFrom=##class(websys.Conversions).DateHtmlToLogical($p(DataStr,"^",5))		;开始时间
		s obj.DateTo=##class(websys.Conversions).DateHtmlToLogical($p(DataStr,"^",6))		;结束时间
		s obj.Creator=$p(DataStr,"^",7)			;创建人
		s obj.DicMemo=$p(DataStr,"^",8)			;备注
		s obj.DataSrcFilterMode=$p(DataStr,"^",9)			; 数据源检索模式
		s obj.DataSrcTableProperty=$p(DataStr,"^",10)		; 数据源表名及字段名
		s obj.ActFlag=$p(DataStr,"^",11) 		;有效标志  zjbadd 20220926
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

/// Creator：      Hanll
/// CreatDate：    2022-02-24
/// Description:   更新表中数据
/// Table：        被访问的表(CF.BILL.COM.Dictionary)
/// Input：        DataStr
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.CFG.COM.DictionaryCtl).UpdateDicDataInfo("16^SYS^YesOrNo^判断^0^2^23/03/2022^30/03/2022^sf01^")
ClassMethod UpdateDicDataInfo(DataStr As %String) As %String
{
	q:$g(DataStr)="" "更新失败，数据为空！"
	s result = ""
	set ^TMP("UpdateDicDataInfo")=$lb(DataStr)
	TSTART														;开启事务
	s ID=$p(DataStr,"^",1)										;ID
	q:$g(ID)="" "ID为空，无法修改数据！"
	b ;ID
	s obj = ##class(CF.BILL.COM.Dictionary).%OpenId(ID, 0)	;获取对象
	b ;obj
	//给对象赋值
	i (obj)
	{
		s obj.DicType=$p(DataStr,"^",2)			;类型
		s obj.DicCode=$p(DataStr,"^",3)			;编码
		s obj.DicDesc=$p(DataStr,"^",4)			;描述
		s obj.DefaultValue=$p(DataStr,"^",5)		;默认值
		s obj.DateFrom=$p(DataStr,"^",6)			;开始时间
		s obj.DateTo=$p(DataStr,"^",7)			;结束时间
		s obj.DateFrom=##class(websys.Conversions).DateHtmlToLogical(obj.DateFrom)		;开始时间
		s obj.DateTo=##class(websys.Conversions).DateHtmlToLogical(obj.DateTo)		;结束时间
		s obj.Creator=$p(DataStr,"^",8)			;创建人
		s obj.DicMemo=$p(DataStr,"^",9)			;备注
		s obj.DataSrcFilterMode=$p(DataStr,"^",10)			; 数据源检索模式
		s obj.DataSrcTableProperty=$p(DataStr,"^",11)		; 数据源表名及字段名
		s obj.ActFlag=$p(DataStr,"^",12) 		;有效标志  zjbadd 20220926
		s sc = obj.%Save()										;保存对象
		b ;sc
		if ($$$ISOK(sc))
		{
			TCOMMIT												;提交事务
			s id = obj.%Id()
			s result = "数据更新成功"_id	
			b ;result
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

/// Creator：      Hanll
/// CreatDate：    2022-02-24
/// Table：        被访问的表(CF.BILL.COM.Dictionary)
/// Input：        ID
/// Output：       result
/// Return：       函数返回值的说明
/// Others：       其它说明
///   w ##class(BILL.CFG.COM.DictionaryCtl).DeleteDicDataInfo("3")
ClassMethod DeleteDicDataInfo(ID As %String) As %String
{
	q:ID="" "ID为空"
	s sc = ""
	s result = ""
	TSTART														;开始事务
	s obj = ##class(CF.BILL.COM.Dictionary).%OpenId(ID)	;创建对象
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

/// Creator：      Hanll
/// 功能说明：导入字典信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// s RowDataInfo="3^SYS^DicType02修改^类别02修改^0^呼吸内科^66163^66163^sf01^畜注03"
/// s ErrMsg=""
/// w ##class(BILL.CFG.COM.DictionaryCtl).ImportDicdataByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportDicdataByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s RtnFlg="0"
	
	s DicType=$p(RowDataInfo, "^", 1)   ;字典类型
	s DicCode=$p(RowDataInfo, "^", 2)   ;字典编码
	s:(DicType="")||(DicCode="") ErrMsg="字典类型和字典编码都不能为空。"
	q:(DicType="")||(DicCode="") RtnFlg
	
	s Rowid=$o(^CF.BILL.COM.DictionaryI("IDataKey", DicType, DicCode, ""))
	i Rowid="" d
	.s objDicData=##class(CF.BILL.COM.Dictionary).%New()
	e  d
	.s objDicData=##class(CF.BILL.COM.Dictionary).%OpenId(Rowid, 0)
	
	s objDicData.DicType=$p(RowDataInfo,"^",1)			;类型
	s objDicData.DicCode=$p(RowDataInfo,"^",2)			;编码
	s objDicData.DicDesc=$p(RowDataInfo,"^",3)			;描述
	s objDicData.DefaultValue=$p(RowDataInfo,"^",4)		;默认值
	s objDicData.DateFrom=##class(websys.Conversions).DateHtmlToLogical($p(RowDataInfo,"^",6))		;开始时间
	s objDicData.DateTo=##class(websys.Conversions).DateHtmlToLogical($p(RowDataInfo,"^",7))		;结束时间
	s objDicData.Creator=$p(RowDataInfo,"^",8)			;创建人 UserDr
	s objDicData.DicMemo=$p(RowDataInfo,"^",9)			;备注
	s objDicData.DataSrcFilterMode=$p(RowDataInfo,"^",10)			; 数据源检索模式
	s objDicData.DataSrcTableProperty=$p(RowDataInfo,"^",11)			; 数据源表名及字段名
    ///保存数据
    s sc=objDicData.%Save()
    i $System.Status.IsError(sc) d
    .;$system.Status.GetErrorText(sc)
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objDicData.%Id()
    
    q RtnFlg
}

/// Creator：wzh
/// CreatDate: 2022.10.17
/// 功能说明：根据type 和 value 获取id
/// Input:：	Type  	--> 字典类型
///           	Value	--> 默认值
/// Return: 	String,^拼接
/// 			flag		|	1:成功		0: 失败
/// 			msg			|	flag=1,msg = 查询的id，flag=0，msg=报错
/// Debug:	w ##class(BILL.CFG.COM.DictionaryCtl).getIDByTypeValue("CPCtrlLevel", "3")
ClassMethod getIDByTypeValue(Type As %String, Value As %String) As %String
{
	quit:((Type = "")||(Value = "")) "0^"_"入参异常，请排查！"
	
	s id = $o(^CF.BILL.COM.DictionaryI("ITypeValue",Type,Value,""))
	quit "1^"_id
}

/// Creator：      tangzf
/// CreatDate：    2022-08-17
/// Table：        根据字典类型代码取字典
/// Input：        index 数字  ，传入时取固定位置
/// Output：       ^第一位=,第四位=字典描述
/// Return：       
/// Others： 
///   w ##class(BILL.CFG.COM.DictionaryCtl).GetDicInfoByTypeCode("ProductLine", "OP", "2","")
ClassMethod GetDicInfoByTypeCode(DicType, DicCode, HospDr, index = "")
{
	s $zt="GetDicInfoByTypeCodeErr"
	s ID=""
	;s ID=$o(^CF.BILL.COM.DictionaryI("IDataHospKey",HospDr,DicType,DicCode,ID))
	s ID=$o(^CF.BILL.COM.DictionaryI("IDataKey",DicType,DicCode,ID))
	q:ID="" ""
	s list=$g(^CF.BILL.COM.DictionaryD(ID)) ;获取数据串
	s StrInfo=$LISTTOSTRING(list,"^")
	s:index'="" StrInfo=$p(StrInfo,"^",index)
	q StrInfo
GetDicInfoByTypeCodeErr
	s $zt=""
	q ""
}

}
