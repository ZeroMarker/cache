Import SQLUser

Class web.DHCEQEquipDoc Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLCODE = "ED_RowID";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "ED_RowID";

Parameter SQLDATETO;

Parameter SQLROWID = "ED_RowID";

ClassMethod GetPicture(equipdr)
{
	new html	
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_equipdr_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	if equipdr'=""
	{
		s rowid=0
		f  s rowid=$o(^DHCEQPicture(0,"Equip",equipdr,rowid))  quit:rowid=""  d
		.s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src=""../images/shebeipic/"_$p($g(^DHCEQPicture(rowid)),"^",4)_""" align=absMiddle hideFocus title="""_$p($g(^DHCEQPicture(rowid)),"^",3)_""" onclick=""SelectPic("_rowid_")"" ondblclick=""ShowPic("_rowid_")"">"
		.;s html=html_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href=""#"">"_text_"</A>"
	}
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String, path As %Library.String, remark As %Library.String, equipdr As %Library.String, isDel As %Library.String)
{
 	if (+isDel=1)
 	{
	 	&SQL(Select pt_path into :picpath  From SQLUSER.DHC_EQPicture where PT_RowID = :rowid)
	 	if SQLCODE q SQLCODE
 		&SQL(Delete From SQLUSER.DHC_EQPicture where PT_RowID = :rowid)
 		if SQLCODE q SQLCODE
 		if picpath'=""
 		{
	 		//s picpath="d:\trakcare\web\csp\shebeipic\"_picpath
	 		s picpath="c:\zip\"_picpath
	 		If ##class(%File).Exists(picpath)
	 		{ d ##class(%File).Delete(picpath)}
	 	}
 	}	
 	elseif (rowid="")
 	{ 
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_Path,PT_Remark,PT_EquipDR)
 			values (:path,:remark,:equipdr))
 		s rowid=$g(%ROWID)
 	}
 	else{
	 	&SQL(Update SQLUSER.DHC_EQPicture 
	 	set PT_Path=:path,PT_Remark=:remark
	 	where PT_RowID = :rowid)
 	}
 	if SQLCODE  q SQLCODE
 	q rowid
}

Query GetPictureList(EquipDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TEquipDR:%String,TPath:%String,TRemark:%String")
{
SELECT PT_RowID TRowID,
	   PT_EquipDR TEquipDR,
	   PT_Path TPath, 
	   PT_Remark TRemark
FROM sqluser.DHC_EQPicture
where PT_EquipDR=:EquipDR
}

ClassMethod ShowPicture(path, remark)
{
	new html
	s rowid=1
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_rowid_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src=""../images/shebeipic/"_path_""" align=absMiddle hideFocus title="""_remark_""">"
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_rowid_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

}
