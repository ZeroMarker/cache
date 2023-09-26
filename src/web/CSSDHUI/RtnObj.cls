/// 错误信息记录
Class web.CSSDHUI.RtnObj Extends %RegisteredObject [ Not ProcedureBlock ]
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
	i ((success<0)&&(recordFlag=1)) {
		s AppCode="CSSDPARAMER"
		s AppId=""
		s Date=+$h,Time=$p($h,",",2)
		;trollback
		i ((keyValue="{}")&&(rowid'="")) s keyValue="{""rowid"":"""_rowid_"""}"

		s StkType="CSSD"
		&sql(Insert into SQLUser.CSSD_SysErrorRecord
			(CSSDSYSER_Date,CSSDSYSER_Time,CSSDSYSER_App,CSSDSYSER_ErrInfo,
			CSSDSYSER_KeyValue,CSSDSYSER_Type)
			values
			(:Date,:Time,:AppId,:msg,:keyValue,:StkType)
		)
	}

	;s msg=$zcvt(msg,"O","JS")
	s msg=$Replace(msg,"\","\\")		;$zcvt转义单引号,与hisui不兼容
	s msg=$Replace(msg,"""","\""")
	s Str="{"
		_$c(34)_"rowid"_$c(34)_":"_$c(34)_rowid_$c(34)
		_","_$c(34)_"msg"_$c(34)_":"_$c(34)_msg_$c(34)
		_","_$c(34)_"success"_$c(34)_":"_$c(34)_success_$c(34)
		_","_$c(34)_"keyValue"_$c(34)_":"_keyValue
		_"}"
	q Str
}

/// Description:记录错误信息
/// Creator:wangjiabin
/// CreateDate:2018-04-10
/// Table:CSSD_SysErrorRecord
/// Input:success:小于0错误 0成功, rowid:业务表rowid, msg:错误详细信息, keyValue:错误数据(使用{}对象格式), recordFlag(1:记录错误日志, 0:不记录)
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
