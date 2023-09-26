/// 错误信息记录类
/// Creator:	wangjiabin
/// CreateDate:	2018-04-08
Class web.DHCSTMHUI.RtnObj Extends %RegisteredObject [ Not ProcedureBlock ]
{

Property rowid As %String;

Property msg As %String [ InitialExpression = "操作成功" ];

Property success As %Boolean [ InitialExpression = 0 ];

Property results As %String [ InitialExpression = "[]" ];

/// 记录错误日志的主要信息
Property keyValue As %String(MAXLEN = 300) [ InitialExpression = "{}" ];

/// 是否记录日志(1:记录, 0:不记录)
Property recordFlag As %String [ InitialExpression = 1 ];

Method Json()
{
	s rowid=$this.rowid
	s msg=$this.msg
	s success=$this.success
	s keyValue=$this.keyValue
	s recordFlag=$this.recordFlag
	s:keyValue="" keyValue="{}"
	i (success<0)&&(recordFlag=1) {
		s AppCode="DHCSTPARAMERM"
		s AppId=$o(^DHCSSA(0,"ACODE",AppCode,""))
		s Date=+$h,Time=$p($h,",",2)
		;trollback
		//将keyValue转换成json对象，当作带引号的字符串处理会导致最后ToJson()方法出现\"转义
		i (keyValue="{}")&&(rowid'="") {
			s keyValue=##class(%DynamicObject).%New()
			s keyValue.rowid=rowid
		}
		s StkType="M"
		&sql(Insert into SQLUser.DHC_StkSysErrorRecord
			(DHCSTER_Date,DHCSTER_Time,DHCSTER_App,DHCSTER_ErrInfo,DHCSTER_KeyValue,
			DHCSTER_StkType)
			values
			(:Date,:Time,:AppId,:msg,:keyValue,
			:StkType)
		)
	}
	s ReturnJson=##class(%DynamicObject).%New()
	s ReturnJson.rowid=rowid
	s ReturnJson.msg=msg
	s ReturnJson.success=success
	s ReturnJson.keyValue=keyValue
	s Str=ReturnJson.%ToJSON()
	q Str
}

/// Description:记录错误信息
/// Creator:	wangjiabin
/// CreateDate:	2018-04-10
/// Table:		DHC_StkSysErrorRecord
/// Input:		success:小于0错误 0成功, rowid:业务表rowid, msg:错误详细信息, keyValue:错误数据(使用{}对象格式), recordFlag(1:记录错误日志, 0:不记录)
Method Err(success = "0", rowid = "", msg = "", keyValue = "{}", recordFlag = "1")
{
	s:keyValue="" keyValue="{}"
	s $this.success=success
	s $this.rowid=rowid
	s $this.msg=msg
	s $this.keyValue=keyValue
	s $this.recordFlag=recordFlag
	q $this
}

}
