/// 配液中心异常类
Class web.DHCSTPIVAS.Exception Extends web.DHCSTPIVAS.Common
{

/// Description: sql增删改时的失败的错误信息返回
/// Debug:       w ##class()
ClassMethod Error4Sql(msgInfo = {%msg})
{
    if (msgInfo = ""){
        s msgInfo = $g(%msg)
    }
    #; 调用系统错误日志, sql错误为系统级别, 此处不设回滚, log
    q "-1^" _ $tr(msgInfo, "^", "~")
}

/// Description: 
/// Description: 
ClassMethod TestSql()
{
    &SQL(
        
        UPDATE INC_ALIAS
        SET
        INCA_DESC = '西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]西洛他唑片(培达)[50MG*12]'
        WHERE INCA_ROWID = 1
    )
    q ..Error4Sql()
}

}
