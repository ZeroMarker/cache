Class BILL.CES.COM.Util Extends %RegisteredObject
{

/// Creator: Lid
/// CreatDate: 2017-09-13
/// Description: 获取医嘱类型
/// Input:	oeitm:医嘱rowid或执行记录rowid或医嘱项rowid
/// 	    flag:0:医嘱项Rowid，1：医嘱rowid(默认)，2：执行记录rowid
/// Return: 医嘱类型(R:药品  N:诊疗  L:检验  P:自定价医嘱  X:检查(与医生站的S区别)  M:材料)
/// Debug: w ##class(BILL.CES.COM.Util).GetOrdCateType("57||12")
ClassMethod GetOrdCateType(oeitm As %String, flag As %String = 1) As %String
{
	if ((flag=1)||(flag=2)) {
		set arcimRowID=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	}else {
		set arcimRowID=oeitm
	}
	set arcGrp=$p($g(^ARCIM(+arcimRowID,$p(arcimRowID,"||",2),1)),"^",10)    ;子类      
	set ordCateType=$p($g(^ARC("IC",+arcGrp)),"^",7)                          ;医嘱类型
	quit ordCateType
}

/// Creator: Zhouyg
/// CreatDate: 20100302
/// Description: 根据两个传入单位取得转换率
/// Input: fr, to
/// Return: 转换率
/// Debug: w ##class(BILL.CES.COM.Util).UOMFac(14,26)
ClassMethod UOMFac(fr, to)
{
	quit:(fr=to) 1    ;if from-uom is as same as to-uom then return 1
	set rowid=""
	set rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
	if (rowid'=""){      
		set fac=$p(^CT("CTCF",rowid),"^",3)
		set fac=$p(fac,$c(1))
	}else{
		set fac=1
	}
	quit $g(fac)
}

/// Descript: mysql特殊字符转义
/// Others: w ##class(BILL.CES.COM.Util).EscapeMysqlStr("乙醇75%")
ClassMethod EscapeMysqlStr(sql)
{
	set sql=$replace(sql,"^","")	;防止影响拆分
	set sql=$replace(sql,"{","{{")	;"{"影响StringBuilder格式，使用"{{"转义
	set sql=$replace(sql,"}","}}")
	set sql=$replace(sql,"\","\\")
	;set sql=$replace(sql,"%","\%")
	;set sql=$replace(sql,"_","\_")
	set sql=$replace(sql,"'","\'")
	set sql=$replace(sql,"′","\′")
	set sql=$replace(sql,"","\′")
	set sql=$case(sql="",1:"NULL",:"'"_sql_"'")	;空值转换成Null
	quit sql
}

}
