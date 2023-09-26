Class web.DHCEQCColSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveColSet(TableName, SetType, SetID, Data)
{
	//q TableName_"^"_SetType_"^"_SetID_"^"_Data
	if ((TableName="")||(SetType="")||(SetID="")) q 0
	s TableName=$ZCONVERT(TableName,"U")
	s TableID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",TableName,0))
	//q TableID_"^"_SetType_"^"_SetID_"^"_Data
	if TableID="" q -1
	s $ZT="ERROR" 
	TStart
	k PLIST
	s PLIST(2)=SetType
	s PLIST(3)=SetID
	s PLIST(4)=TableID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("DHCEQCColSet",User)
	s len=$l(Data,"&")
	s Columns="^"
	s SQLCODE=0	
	for i=1:1:len
	{
		k PLIST(1),PLIST(9)
		s Str=$p(Data,"&",i)
		s PLIST(5)=$p(Str,"^",1)	;ColumnDR
		s ColumnDR=$p(Str,"^",1)
		i ColumnDR="" q
		s Columns=Columns_ColumnDR_"^"
		s PLIST(7)=i	;Sort
		i $p(Str,"^",3)=1
		{
			s PLIST(9)=$p(Str,"^",2)  ;ColumnsWidth 2011-07-15 DJ
		}
		s FindID=$o(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,SetType,SetID,ColumnDR,0))
		i FindID=""
		{
			&sql(Insert Into sqluser.DHC_EQCColSet  values :PLIST())
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQCColSet Values :PLIST() where CS_RowID=:FindID)
		}
		i SQLCODE q
	}
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	//处理删除记录
	s ColDR=0
	f  s ColDR=$o(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,SetType,SetID,ColDR))  q:(ColDR="")||(SQLCODE'=0)  d
	.q:Columns[("^"_ColDR_"^")
	.s ColRowID=$o(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,SetType,SetID,ColDR,0))
	.&SQL(Delete From SQLUSER.DHC_EQCColSet Where CS_RowID=:ColRowID)
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	TCommit
	q 0
	
ERROR
	TRollback
	q -1
}

ClassMethod GetColumns(TableID, SetType As %String = "")
{
	s ColumnsInfo=""
	s sort=0
	s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //2011-07-15 DJ
	s GroupID=%session.Get("LOGON.GROUPID") //2011-07-15 DJ
	i SetType=""
	{
		i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,2,UserID))  d
		.s SetType=2
		e  d
		.i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,1,GroupID))  d
		..s SetType=1
		.e  d
		..s SetType=0
	}
	i SetType=0 s SetID=0
	i SetType=1 s SetID=GroupID
	i SetType=2 s SetID=UserID	
	s rowid=0
	f  s sort=$o(^DHCEQCCode("DHCEQCColumns",0,"Sort",TableID,sort))  quit:sort=""  d
	.f  s rowid=$o(^DHCEQCCode("DHCEQCColumns",0,"Sort",TableID,sort,rowid))  quit:rowid=""  d
	..q:$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",3)'="N"
	..;过滤设置列 //2011-07-15 DJ begin
	..q:$D(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,SetType,SetID,rowid))
	..if ColumnsInfo'="" s ColumnsInfo=ColumnsInfo_"&"
	..s ColumnsInfo=ColumnsInfo_rowid_"^"_$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",4)	
	q ColumnsInfo
}

ClassMethod GetColSets(TableID, SetType, SetID, TableName As %Library.String = "")
{
	if ((TableName="")&&(TableID="")) q ""
	if (TableID="")
	{
		s TableName=$ZCONVERT(TableName,"U")
		s TableID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",TableName,0))
	}
	if (TableID="") q ""
	
	s ColumnsInfo=""
	s sort=0
	s rowid=0
	/**************************************************************/ //2011-07-15 DJ begin
	s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s GroupID=%session.Get("LOGON.GROUPID")
	i SetType=""
	{
		i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,2,UserID))  d
		.s SetType=2
		e  d
		.i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,1,GroupID))  d
		..s SetType=1
		.e  d
		..s SetType=0
	}
	i SetType=2 s SetID=UserID
	i SetType=1 s SetID=GroupID
	i SetType=0 s SetID=0
	/**************************************************************/ //2011-07-15 DJ end
	f  s sort=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",TableID,SetType,SetID,sort))  quit:sort=""  d
	.f  s rowid=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",TableID,SetType,SetID,sort,rowid))  quit:rowid=""  d
	..if ColumnsInfo'="" s ColumnsInfo=ColumnsInfo_"&"
	..s ColID=$p($g(^DHCEQCCode("DHCEQCColSet",rowid)),"^",4)
	..s Caption=$p($g(^DHCEQCCode("DHCEQCColSet",rowid)),"^",5)
	..i Caption="" s Caption=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",4)
	..
	..s ColName=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",2)
	..s Position=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",5)
	..s Format=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",7)
	..s ColWidth=$p($g(^DHCEQCCode("DHCEQCColSet",rowid)),"^",8)
	..
	..s ColumnsInfo=ColumnsInfo_ColID_"^"_Caption_"^"_ColName_"^"_Position_"^"_Format_"^"_ColWidth

	q ColumnsInfo
}

ClassMethod GetTableData(TableID)
{
	if ((TableName="")&&(TableID="")) q ""
	if (TableID="")
	{
		s TableName=$ZCONVERT(TableName,"U")
		s TableID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",TableName,0))
	}
	if (TableID="") q ""
	
	s ColumnsInfo=""
	s sort=0
	s rowid=0
	f  s sort=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",TableID,SetType,SetID,sort))  quit:sort=""  d
	.f  s rowid=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",TableID,SetType,SetID,sort,rowid))  quit:rowid=""  d
	..if ColumnsInfo'="" s ColumnsInfo=ColumnsInfo_"&"
	..s ColID=$p($g(^DHCEQCCode("DHCEQCColSet",rowid)),"^",4)
	..s Caption=$p($g(^DHCEQCCode("DHCEQCColSet",rowid)),"^",5)
	..i Caption="" s Caption=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",4)
	..
	..s ColName=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",2)
	..s Position=$p($g(^DHCEQCCode("DHCEQCColumns",ColID)),"^",5)
	..
	..s ColumnsInfo=ColumnsInfo_ColID_"^"_Caption_"^"_ColName_"^"_Position

	q ColumnsInfo
}

ClassMethod SaveTypeList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")  //hisui改造：替换hisui下拉列表样式
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;w "<option value=></option>"
	i Type=""
	{
		w "<option value=0>系统</option>"
		w "<option value=1>安全组</option>"
	}
	w "<option value=2>用户</option>"
	w "</select>",!
}

/// add by lmm 2019-12-25 999284
ClassMethod TipSpan() As %String
{
	;;下拉列表
	;modify by lmm 999284 2020-01-16
	;modify by lmm 2020-06-04 UI
	w "<span class='messager-popover info' style='top:7px;width:940px'>"
	w "<span class='messager-popover-icon info'></span>"
	w "<span class='content'>长按Shift可连选,长按Ctrl可点选</span>"
	w "</span>"
	//w "<span id='tipspan'>提示</span>",!
}

ClassMethod GetColSetWidth(TableID, SetType, SetID, ColumnsID)
{
	i ((TableID="")||(SetType="")||(SetID="")||(ColumnsID="")) q ""
	s ColWidth=""
	s ColSetID=$o(^DHCEQCCode("DHCEQCColSet",0,"Columns",TableID,SetType,SetID,ColumnsID,0))
	i ColSetID'="" s ColWidth=$p($g(^DHCEQCCode("DHCEQCColSet",ColSetID)),"^",8)
	q ColWidth
}

ClassMethod GetTableID(TableName As %String = "")
{
	i TableName="" q 0
	s TableName=$ZCONVERT(TableName,"U")
	s TableID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",TableName,0))
	q TableID
}

}
