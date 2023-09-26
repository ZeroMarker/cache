Class web.DHCEQ.Plat.BUSApproveList Extends %RegisteredObject [ ProcedureBlock ]
{

/// Add By CSJ 2019-12-01
/// 描述：获取一个单据的所有审批信息,采用HISUI泡芙显示,格式 <li>Opinion</li>
/// Modified by CSJ 2019-12-13 默认显示最后一条关键审批信息
/// w ##Class(web.DHCEQ.Plat.BUSApproveList).GetApproveListOpinion(1,8)
ClassMethod GetApproveListOpinion(approvetype, sourceid)
{
	i sourceid="" q ""
	set (str,role,user,date,Opinion)=""
	Set id=""
	s flag=0
	For  Set id=$Order(^DHCEQApproveList(0,"Source",approvetype,sourceid,id),-1)  Quit:(id="")||(flag=1)  Do
	.Set str=$Piece($Get(^DHCEQApproveList(id)),"^",3)
	.Set role=##class(web.DHCEQCommon).GetTrakNameByID("role",$Piece($Get(^DHCEQApproveList(id)),"^",5))
	.Set user=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQApproveList(id)),"^",6))
	.Set date=##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQApproveList(id)),"^",7)_","_$Piece($Get(^DHCEQApproveList(id)),"^",8),"datetime")	//增加审核时间的显示
	.Set Opinion=Opinion_"<li>"_user_"  "_date_"  "_str_"</li>"	
	.s flag=1

	q Opinion
}

}
