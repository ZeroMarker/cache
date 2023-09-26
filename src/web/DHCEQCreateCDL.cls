Class web.DHCEQCreateCDL Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

ClassMethod CombinGblInfo(clsname As %String, RowID As %String, vgbl As %String, vidx As %String, useCodeGbl)
{
	new gbl
	set gbl="    sqlrowidname = "_RowID_";"_$c(13)_$c(10)
	set gbl=gbl_$c(13)_$c(10)
	set gbl=gbl_"    storage SQLStorage"_$c(13)_$c(10)	
	set gbl=gbl_"    {"_$c(13)_$c(10)	
	set gbl=gbl_"        type = %Library.CacheSQLStorage;"_$c(13)_$c(10)	
	set gbl=gbl_"        sql"_$c(13)_$c(10)	
	set gbl=gbl_"        {"_$c(13)_$c(10)
	if (useCodeGbl=1)
		{set gbl=gbl_"            idexpression = $i(^DHCEQCCode("""_##Class(web.DHCEQCommon).Replace(clsname,"_","")_""",0));"_$c(13)_$c(10)	}
	else
		{set gbl=gbl_"            idexpression = $i(^"_##Class(web.DHCEQCommon).Replace(clsname,"_","")_"("_""""_"0"_""""_"));"_$c(13)_$c(10)}
	set gbl=gbl_"            map DataMaster"_$c(13)_$c(10)	
	set gbl=gbl_"            {"_$c(13)_$c(10)
	set gbl=gbl_"                type = data;"_$c(13)_$c(10)
	if (useCodeGbl=1)
		{set gbl=gbl_"                global = ^DHCEQCCode;"_$c(13)_$c(10)}
	else
		{set gbl=gbl_"                global = ^"_##Class(web.DHCEQCommon).Replace(clsname,"_","")_";"_$c(13)_$c(10)}
	set gbl=gbl_"                structure = delimited;"_$c(13)_$c(10)
	if (useCodeGbl=1)
	{
		set gbl=gbl_"                subscript 1 { accesstype = Sub; expression = """_##Class(web.DHCEQCommon).Replace(clsname,"_","")_"""; }"_$c(13)_$c(10)
		set gbl=gbl_"                subscript 2 { accesstype = Sub; expression = {"_RowID_"}; startvalue = 1; }"_$c(13)_$c(10)
	}
	else
		{set gbl=gbl_"                subscript 1 { accesstype = Sub; expression = {"_RowID_"}; startvalue = 1; }"_$c(13)_$c(10)}
	set gbl=gbl_vgbl_$c(13)_$c(10)
	if (useCodeGbl=1)
		{set gbl=gbl_"                rowidspec 1 { field = "_RowID_"; expression = {L2}; }"_$c(13)_$c(10)	}
	else
		{set gbl=gbl_"                rowidspec 1 { field = "_RowID_"; expression = {L1}; }"_$c(13)_$c(10)	}
	set gbl=gbl_"            }"_$c(13)_$c(10)
	set gbl=gbl_vidx
	set gbl=gbl_"        }"_$c(13)_$c(10)
	set gbl=gbl_"    }"_$c(13)_$c(10)
	set gbl=gbl_"}"_$c(13)_$c(10)
	Quit gbl
}

ClassMethod CreateAllcdl()
{
 //生成operationTable的cdl
	new rset,sql,rrow,allcdl,created
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Distinct TableDesc FROM Sqluser.operationTable WHERE SortNO is null"
	set rrow=0
	set create=1
	set allcdl=""
	d rset.Prepare(sql)
	d rset.Execute()
	While (rset.Next(.sc)) // go to the next row of the result set
 {
 If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 {
 set tablename=rset.Data("TableDesc")
 set allcdl= ..CreateBCdl(tablename)                
 //d ##Class(web.DHCEQCommon).WriteFile("d:\cdl\OperationTable.cdl",tablename,create)
 d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\OperationTable\"_tablename_".cdl",allcdl,1)
 set create=0

 //set allcdl=allcdl_..CreateBCdl(tablename)
 }
 }
 //d ##Class(web.DHCEQCommon).WriteFile("d:\cdl\OperationTable.cdl",allcdl)
	//生成codetable的cdl
	//quit
	set allcdl=""
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT CodeName,ShortDesc,ExtendStandard,NeedItem,IndexInfo FROM Sqluser.CodeTable WHERE InsideFlag=1 "
	set rrow=0
	d rset.Prepare(sql)
	d rset.Execute()
	While (rset.Next(.sc)) // go to the next row of the result set
     {	    
        If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
            {
                set tablename=rset.Data("CodeName")
                set ShortDesc=rset.Data("ShortDesc")
                set ExtendStandard=rset.Data("ExtendStandard")
                set NeedItem=rset.Data("NeedItem")
                set allcdl= ..CreateCCdl(tablename,ShortDesc,ExtendStandard,NeedItem,rset.Data("IndexInfo"))
                d ##Class(web.DHCEQCommon).WriteFile("D:\Share\cdl\codetable\"_tablename_".cdl",allcdl,1)
            }
     }
 //d ##Class(web.DHCEQCommon).WriteFile("d:\cdl\CodeTable.cdl",allcdl)
}

ClassMethod CreateBCdl(clsname As %String)
{
	new cdl,rset,sql,fieldname,sort,datatype,displaytype,rowid,indexInfo,i,unqinfo,maxlen
	new att,gbl,idx,unq
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT TableDesc,SortNO,DataItem,ItemName,ItemType,ItemLength,AllowNull,DefaultValue,Reference,InsideFlag,Remark,IndexInfo,UniqueInfo FROM sqluser.operationTable WHERE tabledesc= '"_clsname_"' order by id "	
	
 set cdl="",att="",gbl="",rowid="",idx="",indexInfo="",unq="",unqinfo=""
 set sort=0 	
	
	Do rset.Prepare(sql)
 Do rset.Execute()
 While (rset.Next(.sc)) // go to the next row of the result set
 {	    
 If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 {
 s fieldname=rset.Data("DataItem") // perform busines logic   
 s indexInfo= rset.Data("IndexInfo")
 s unqinfo=rset.Data("UniqueInfo")
 s maxlen=rset.Data("ItemLength")
 if (##Class(web.DHCEQCommon).EndWith(fieldname,"RowID")=1)	
 {
	 set rowid=fieldname
	 set idx=..GetIndexsInfo(clsname,indexInfo,rowid,0)
	 set unq=..GetUnqsInfo(unqinfo)
	 continue
 }
 set sort=sort+1
 //增加一个参数备注
 set att=att_..GetFieldInfo(fieldname,sort+1,rset.Data("Reference"),rset.Data("InsideFlag"),rset.Data("Remark"),maxlen)_$c(13)_$c(10)
 set gbl=gbl_..GetGblInfo(fieldname,sort)_$c(13)_$c(10)
 }
 Else // if there was an error, break out of the While loop
 {
	            w "err"
 Quit
 }
 }
 If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 {
 Quit "err"
 }
 if (att="")
 {
	    set cdl=""
	}
	else
	{
		set cdl=..InitCdl(clsname,rowid)
		set gbl=..CombinGblInfo(clsname,rowid,gbl,idx,0)
		set cdl=cdl_att_unq_gbl
	}
	//d ##Class(web.DHCEQCommon).WriteFile("d:\cdl\OperationTable\"_clsname_".cdl",cdl)
	Quit cdl
}

ClassMethod CreateCCdl(clsname As %String, prefix As %String, ExtendStandard As %String, NeedItem As %String, indexInfo As %String)
{
	new cdl,fieldname,fieldnames,sort,rowid,i,maxlen
	new att,gbl,idx
	new tmpfield
	set cdl="",att="",gbl="",rowid="",fieldnames="",idx=""
	
	set rowid=prefix_"_RowID"
	
	i (+ExtendStandard=1)  d
	.set fieldname=prefix_"_Code"_"^^^"
	.set fieldnames=fieldnames_fieldname
	.set fieldname=prefix_"_Desc"_"^^^"
	.set fieldnames=fieldnames_","_fieldname
	.set fieldname=prefix_"_Remark"_"^^^"
	.set fieldnames=fieldnames_","_fieldname
	.i NeedItem'="" d
	..set fieldnames=fieldnames_","_NeedItem
	.set fieldname=prefix_"_InvalidFlag"_"^^^"
	.set fieldnames=fieldnames_","_fieldname
	i fieldnames="" s fieldnames=NeedItem
	
	set sort=1
	DO {
		set fieldname = $PIECE(fieldnames,",",sort)
		s maxlen=""
		i (##Class(web.DHCEQCommon).EndWith($P(fieldname,"^",1),"Remark")=1) s maxlen=160
		set att=att_..GetFieldInfo($P(fieldname,"^",1),sort+1,$P(fieldname,"^",2),$P(fieldname,"^",3),$P(fieldname,"^",4),maxlen)_$c(13)_$c(10)
    	set gbl=gbl_..GetGblInfo($P(fieldname,"^",1),sort)_$c(13)_$c(10)
    	set sort=sort+1
    } WHILE $PIECE(fieldnames,",",sort)'=""
    set idx=..GetIndexsInfo(clsname,indexInfo,rowid,1)     		
	                
    if (att="")
    {   set cdl=""}
	else
	{
		set cdl=..InitCdl(clsname,rowid)
		set gbl=..CombinGblInfo(clsname,rowid,gbl,idx,1)
		set cdl=cdl_att_gbl
	}	
	Quit cdl
}

ClassMethod GetFieldInfo(fieldName As %String, sort As %String, reference As %String, insideflag As %String, remark As %String, maxlen As %String)
{
	new att
	set att="    attribute "_##Class(web.DHCEQCommon).Replace(fieldName,"_","")
	set att=att_" { sqlfieldname  = "_fieldName_"; "
	set att=att_..GetTypeInfo(fieldName,reference,insideflag,remark,maxlen)
	set att=att_"description = "
	set att=att_""""
	set att=att_fieldName
	set att=att_""""
	set att=att_"; sqlcolumnnumber = "_sort_"; }"
	;i DefaultValue'=""  d
	;.set att=att_"; initialexpression  = "_DefaultValue_"; }"
	;i +required=1  d
	;.set att=att_"; required; }"

	Quit att
}

ClassMethod GetGblInfo(fieldName As %String, sort As %String)
{
	new gbl
	set gbl="                data "_fieldName
	set gbl=gbl_" { piece = "_sort
	set gbl=gbl_"; delimiter = "_""""_"^"_""""_"; }"
	Quit gbl
}

ClassMethod GetIndexsInfo(clsname As %String, indexsInfo As %String, rowid As %String, useCodeGbl)
{
	new idx
	s idx=""
	if (indexsInfo'="")
	{
		set i=1
		DO {
			SET idx=idx_..GetIndexInfo(##Class(web.DHCEQCommon).Replace(clsname,"_",""),$PIECE(indexsInfo,"|",i),rowid,useCodeGbl)_$c(13)_$c(10)
			set i=i+1
			} WHILE $PIECE(indexsInfo,"|",i)'=""
	}
	q idx
}

ClassMethod GetIndexInfo(gblname As %String, indexInfo As %String, rowid As %String, useCodeGbl)
{
	new info,indexs,indexName,i
	set indexName=$PIECE(indexInfo,",")
	set info="            map Index"_indexName_$c(13)_$c(10)
	set info=info_"            {"_$c(13)_$c(10)
	set info=info_"                type = index;"_$c(13)_$c(10)
	if (useCodeGbl=1)
		{set info=info_"                global = ^DHCEQCCode;"_$c(13)_$c(10)}
	else
		{set info=info_"                global = ^"_gblname_";"_$c(13)_$c(10)}
	set info=info_"                structure = delimited;"_$c(13)_$c(10)
	set info=info_"                populationtype = nonnull;"_$c(13)_$c(10)
	set i=1
	if (useCodeGbl=1)
	{
		//set info=info_"                subscript "_i_" { accesstype = Sub; expression = """_gblname_"""; }"_$c(13)_$c(10)
		set info=info_"                subscript "_i_" { expression = """_gblname_"""; }"_$c(13)_$c(10)
		set i=i+1
	}
	//set info=info_"                subscript "_i_" { accesstype = Sub; expression = 0; }"_$c(13)_$c(10)
	set info=info_"                subscript "_i_" { expression = 0; }"_$c(13)_$c(10)
	set i=i+1
	//set info=info_"                subscript "_i_" { accesstype = Sub; expression = "_""""_indexName_""""_"; }"_$c(13)_$c(10)
	set info=info_"                subscript "_i_" { expression = "_""""_indexName_""""_"; }"_$c(13)_$c(10)
	set j=2
	DO {		
 		//SET info=info_"                subscript "_(i+1)_" { accesstype = Sub; expression = {"_$PIECE(indexInfo,",",j)_"}; }"_$c(13)_$c(10)
 		SET info=info_"                subscript "_(i+1)_" { expression = {"_$PIECE(indexInfo,",",j)_"}; }"_$c(13)_$c(10)
 		set i=i+1
 		set j=j+1
 	} WHILE $PIECE(indexInfo,",",j)'=""
	set i=i+1
	//set info=info_"                subscript "_i_" { accesstype = Sub; expression = {"_rowid_"}; }"_$c(13)_$c(10)
	set info=info_"                subscript "_i_" { expression = {"_rowid_"}; }"_$c(13)_$c(10)
	set info=info_"                rowidspec 1 { field = "_rowid_"; expression = {L"_i_"}; }"_$c(13)_$c(10)
	set info=info_"            }"_$c(13)_$c(10)
	Quit info
}

ClassMethod GetUnqsInfo(unqsInfo As %String)
{
	new unq
	s unq=""
	if (unqsInfo'="")
	{
		set i=1
		DO {
			SET unq=unq_..GetUnqInfo($PIECE(unqsInfo,"|",i))_$c(13)_$c(10)
			set i=i+1
			} WHILE $PIECE(unqsInfo,"|",i)'=""
	}
	q unq
}

ClassMethod GetUnqInfo(unqInfo As %String)
{
	q "    index "_$PIECE(unqInfo,",",1)_" { attribute = "_##Class(web.DHCEQCommon).Replace($PIECE(unqInfo,",",2),"_","")_"; unique = 1; }"_$c(13)_$c(10)
}

ClassMethod GetTypeInfo(fieldName As %String, reference As %String, insideflag As %String, remark As %String, maxlen As %String)
{
	new att
	set att=""
	if (##Class(web.DHCEQCommon).EndWith(fieldName,"DR")=1 && insideflag=1)
	{
		set att="type = User."_##Class(web.DHCEQCommon).Replace(reference,"_","")_"; "
	}
	elseif (##Class(web.DHCEQCommon).EndWith(fieldName,"Date")=1)
	{
		set att="type = %Library.Date(FORMAT=1); "
	}
	elseif (##Class(web.DHCEQCommon).EndWith(fieldName,"Time")=1)
	{
		set att="type = %Library.Time; "
	}
	elseif (##Class(web.DHCEQCommon).EndWith(fieldName,"Num")=1 ||##Class(web.DHCEQCommon).EndWith(fieldName,"Fee")=1 )
	{
		set att="type = %Library.Float; "
	}
	elseif (##Class(web.DHCEQCommon).EndWith(fieldName,"Flag")=1 )
	{
		set att="type = %Library.String(SELECTIVITY="
		set att=att_"""33.3333%"""_",VALUELIST="_""",Y,N"""_",DISPLAYLIST="_""",Yes,No"""_",MAXLEN=3); "
	}
	////////添加
	elseif (##Class(web.DHCEQCommon).EndWith(fieldName,"Status")=1 )
	{
		new ValueList,DisPlayList,MaxLen
		set att="type = %Library.String(SELECTIVITY="
		set ValueList="",DisPlayList="",MaxLen=0
		set lnum=$l(remark,"|")
		set lnum=$Justify(100/(lnum+1),1,4)_"%"
		d ..GetValueList(remark,.ValueList,.DisPlayList,.MaxLen)
		set att=att_""""_lnum_""""_",VALUELIST="_""""_ValueList_""""_",DISPLAYLIST="_""""_DisPlayList_""""_",MAXLEN="_MaxLen_"); "
	}
	////////////
	else
	{
		set att="type = %Library.String(MAXLEN="
		if (maxlen'="")
		{set att=att_maxlen}
		else
		{set att=att_"30"}
		set att=att_",COLLATION=""Exact"",TRUNCATE=""0""); "		
	}	
	Quit att
}

ClassMethod GetValueList(remark As %String, valueList As %String, displayList As %String, maxlen As %String)
{
	//set valueList=","
	//set displayList=","
	new i
	set maxlen=0
	new displaylistsingle
	new maxlen2
	for i=1:1:$l(remark,"|")
	{		
		set valueList=valueList_","_$p($p(remark,"|",i),":")
		set displaylistsingle=$p($p(remark,"|",i),":",2)
		set displayList=displayList_","_displaylistsingle
		set maxlen2=$L(displaylistsingle)		
		if maxlen2>maxlen s maxlen=maxlen2
	}
}

ClassMethod InitCdl(clsname As %String, RowID As %String)
{
	new cdl
	set cdl=""
	set cdl= "class User."_##Class(web.DHCEQCommon).Replace(clsname,"_","")_$c(13)_$c(10)
	set cdl=cdl_"{"_$c(13)_$c(10)
	set cdl=cdl_"    sqltablename = "_clsname_";"
	set cdl=cdl_$c(13)_$c(10)
	set cdl=cdl_"    owner = _SYSTEM;"_$c(13)_$c(10)
	set cdl=cdl_"    parameter EXTENTSIZE { default = 250; }"_$c(13)_$c(10)
	set cdl=cdl_"    super = %Library.Persistent;"_$c(13)_$c(10)
	set cdl=cdl_$c(13)_$c(10)
	set cdl=cdl_"    persistent = SQLStorage;"_$c(13)_$c(10)
	set cdl=cdl_$c(13)_$c(10)
	Quit cdl
}

}
