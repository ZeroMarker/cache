/// 修改记录表 最终考核分，描述
/// 
Class dhc.pa.udata.uPAScoreLogger Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     chu yali
/// CreateDate:  2016-04-25
/// Description: 修改记录表
///           
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、
/// w ##class(dhc.pa.udata.uPAScoreLogger).Insert(1,"Rscore=7&estDesc =t,"基层科室绩效考核计算-考核指标数据调整")
ClassMethod Insert(updateuser, updatefield, updatedesc) As %String
{
	n (updateuser,updatefield,updatedesc)
	
	s updatedate = $zdt($h,3)		
	&SQL(INSERT INTO dhc_pa_inter.PAScoreLogger (PSL_updateDate, PSL_updateUser, PSL_updateField, PSL_updateDesc)
		VALUES (:updatedate, :updateuser,:updatefield,:updatedesc))
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uPAScoreLoggerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
