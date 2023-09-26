Import sqluser

/// Description:装箱操作表结构相关
/// Creator:    hulihua
/// CreateDate: 2018-01-11
/// Table:      DHC_PHBox--物流箱
Class web.DHCINPHA.MTBinBox.SqlDbBinBox Extends (%RegisteredObject, websys.Abstract) [ ClassType = "" ]
{

Parameter AppName [ Final ] = "DHCINPHAPHBOX";

/// Descript: 	新装箱记录
/// Creater：	yaoxin
/// CreateDate：2013-03-24
/// Table：		DHC_PHBox
/// Input：		SqlStr=发药科室ID^病区科室ID^装箱数^创建人ID
/// Return：	>0，记录ID;<0，错误	
/// w ##class(web.DHCINPHA.MTBinBox.SqlDbBinBox).InsertBox()
ClassMethod InsertBox(SqlStr As %String) As %Library.String
{
	s DispLocId=$P(SqlStr,"^",1)
	s WardLocId=$P(SqlStr,"^",2)
	s BoxNum=$P(SqlStr,"^",3)
	s UserId=$P(SqlStr,"^",4)
	q:DispLocId="" -101
	q:WardLocId="" -102
	q:BoxNum="" -103
	q:UserId="" -104
    s ret=##class(web.DHCST.Common.AppCommon).Lock("PHBoxNo")  
    q:ret'=0 -99
    s AppName=..%GetParameter("AppName")
    s No=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",DispLocId)
    i No="" d ##class(web.DHCST.Common.AppCommon).UnLock("PHBoxNo")
    q:No="" -105   ;生成单号失败
	s Status=10
	s DateCreate=$P($h,",",1)
	s TimeCreate=$P($h,",",2)
	s Err=0	
	&SQL(Insert Into DHC_PHBox (PHB_No,PHB_Num,PHB_Status,PHB_FLoc_Dr,
			PHB_TLoc_Dr,PHB_UserCreate_Dr,PHB_DateCreate,PHB_TimeCreate) 
		values(:No,:BoxNum,:Status,:DispLocId,
		:WardLocId,:UserId,:DateCreate,:TimeCreate))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHBox",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-100
    d ##class(web.DHCST.Common.AppCommon).UnLock("PHBoxNo")
	q:SQLCODE'=0 Err
	s RetID=$p($g(%ROWID),$c(1))
	q RetID_"#"_No
}

/// Descript: 	物流人员发放时(装箱核对)
/// Creator：	yaoxin
/// CreateDate：2017-03-27
/// Table：		DHC_PHDox
/// Input：		SqlStr BoxId^UserId^LogisticsLd
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MTBinBox.SqlDbBinBox).UpdateBoxData("7")
ClassMethod UpdateBoxData(SqlStr As %String) As %Library.String
{
	s Err=0
	q:SqlStr="" -201
	s BoxId=$p(SqlStr,"^",1)
	s UserId=$p(SqlStr,"^",2)
	s LogisticsLd=$p(SqlStr,"^",3)
	s PHBDatePhHand=$p($h,",",1)
	s PHBTimePhHand=$p($h,",",2)
	&SQL(Update DHC_PHBox set PHB_Status='60',PHB_UserPhHand_Dr=:UserId,PHB_DatePhHand=:PHBDatePhHand,PHB_TimePhHand=:PHBTimePhHand,PHB_UserLogistics_Dr=:LogisticsLd where PHB_RowID=:BoxId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHBox",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Description:揭药箱发放处理条码信息
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PHDox
/// Input:			
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothCollectDb("15")
ClassMethod SaveBoxBarDataDb(SqlStr As %String) As %String
{
	s PhBoxId=$p(SqlStr,"^",1)
	s PhBoxStatus=$p(SqlStr,"^",2)
	s Err=0
	&SQL(Update DHC_PHBox set PHB_Status=:PhBoxStatus where PHB_RowID=:PhBoxId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("SaveBoxBarDataDb:DHC_PHBox",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-3
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

}
