/// add by ZY0210
/// 增加科室拼音码信息记录
Class web.DHCEQ.Plat.CTAlias Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by ZY0210
/// w ##Class(web.DHCEQ.Plat.CTAlias).GetAlias(1,1,text,1)
ClassMethod GetAlias(SourceType, SourceID, Type As %String = "text", AliasType As %String = "")
{
	new FindRowID,rowid
	i '$Data(^DHCEQCCode("DHCEQCAlias",0,"SourceID",SourceType,SourceID)) q ""
	s FindRowID=""
 	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAlias",0,"SourceID",SourceType,SourceID,rowid)) q:(rowid="")||(FindRowID'="")  d
	.q:(($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",8))="Y")
	.q:(($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",9))'=AliasType) 
	.s FindRowID=rowid
	q FindRowID
}

/// add by ZY0210
/// Data:json格式的数据
/// SourceType:记录的表明:DHCEQCDepartment;DHCEQCMasterItem
/// SourceID:对应表ID
/// AliasType：PYCode:拼音码,ShortName:简称,WBCode:五笔码
/// w ##Class(web.DHCEQ.Plat.CTAlias).SaveData()
ClassMethod SaveData(Data, SourceType, SourceID, AliasType, DelIs As %String = "")
{
	new PLIST,RowID,JsonData,Result,Text,Desc
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCAlias",JsonData,.PLIST)
	s RowID = JsonData.ARowID
	s Text = JsonData.AText
	s Desc = JsonData.ADesc

	if (DelIs="1")
	{
		&SQL(update sqluser.DHC_EQCAlias set A_InvalidFlag='Y' where A_RowID=:RowID)
		If SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
		}
	}
	ELSE
	{
		Set PLIST(4)=SourceType
		Set PLIST(5)=SourceID
		Set PLIST(9)="N"
		Set PLIST(10)=AliasType
    	if RowID'=""
    	{
			&SQL(Update SQLUSER.DHC_EQCAlias Values :PLIST() where A_RowID = :RowID)
			if SQLCODE
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SLQCODE)
			}
		}
		else
		{
			s FindRowID=""
		 	s rowid=0
			f  s rowid=$o(^DHCEQCCode("DHCEQCAlias",0,"SourceID",SourceType,SourceID,rowid)) q:(rowid="")||(FindRowID'="")  d
			.q:(($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",8))="Y")
			.q:(($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",9))'=AliasType)  
			.i Text=$p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",1) s FindRowID=rowid
			.i Desc=$p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",2) s FindRowID=rowid
	 		i (FindRowID'="")	//modified by csj 2020-03-31 需求号：1249906
	 		{
		 		&SQL(update sqluser.DHC_EQCAlias Values :PLIST() where A_RowID=:FindRowID)	//modified by csj 2020-03-31
	 		}
	 		else{
		 		&SQL(insert into sqluser.DHC_EQCAlias values :PLIST())	
		 	}
			
			if SQLCODE
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
			}
		}
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

}
