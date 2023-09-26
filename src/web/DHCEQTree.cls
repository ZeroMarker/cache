Class web.DHCEQTree Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 150;

ClassMethod GetTest(itmjs As %Library.String = "", itmjsex As %Library.String = "", parid, layer, preline)
{
	s nodes=""
	s id=parid_"001"
	s nodes=nodes_..CreateNode(id,"节点"_id,1,0,layer,parid,preline)
	s id=parid_"002"
	s nodes=nodes_..CreateNode(id,"节点"_id,1,1,layer,parid,preline)
	q nodes
}

ClassMethod CreateRoot(id, text)
{
	
	new html
	s html="<div id='treeviewarea' style='background-color: '>"
	s html=html_"<SPAN id=Tree_"_id_">"
	s html=html_"<DIV noWrap><NOBR>"
	s html=html_"<IMG id=Icon"_id_" style=""CURSOR:hand"" src=""../images/tree/root.gif"" align=absMiddle onclick=""ExpandTree("_id_")"">"
	s html=html_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href=""#"">"_text_"</A>"
	s html=html_"</NOBR></DIV>"
	
	s html=html_"<SPAN id=Set_"_id_" style=""DISPLAY:none"">"
	s html=html_"<input id=""HasChild"_id_""" name=""HasChild"_id_""" type=""hidden"" value=""1"">"
	s html=html_"<input id=""Loaded"_id_""" name=""Loaded"_id_""" type=""hidden"" value=""0"">"
	s html=html_"<input id=""Parent"_id_""" name=""Parent"_id_""" type=""hidden"" value="""">"
	s html=html_"<input id=""Layer"_id_""" name=""Layer"_id_""" type=""hidden"" value=""0"">"
	s html=html_"<input id=""IsLast"_id_""" name=""IsLast"_id_""" type=""hidden"" value="""">"
	s html=html_"<input id=""ID"_id_""" name=""ID"_id_""" type=""hidden"" value="""_id_""">"
	s html=html_"</SPAN>"
	
	s html=html_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

ClassMethod CreateNode(id, text, haschild, islast, layer, parent, preline)
{
	new nodes
	new expandgif
	
	if (islast=1)  
	{s expandgif="2"}
	else
	{s expandgif="1"}
	if (haschild=1)  
	{s expandgif="style=""CURSOR:hand"" src=""../images/tree/P"_expandgif_".gif"""}
	else
	{s expandgif="src=""../images/tree/L"_expandgif_".gif"""}
	
	s nodes="<SPAN id=Tree"_id_">"
	s nodes=nodes_"<DIV noWrap><NOBR>"
	s nodes=nodes_"<SPAN>"
	if (preline'="")	{
		f i=1:1:$l(preline,"^")	{
		s nodes=nodes_"<IMG id=Line_"_i_"_"_id_"1 src=""../images/tree/L"_$p(preline,"^",i)_".gif"" align=absMiddle>"
		}
	}
	s nodes=nodes_"<IMG id=Expand"_id_" "_expandgif_" align=absMiddle onclick=""ExpandTree("_id_")"">"
	s nodes=nodes_"</SPAN>"
	s nodes=nodes_"<IMG id=Icon"_id_" src="""_"../images/tree/folder.gif"_""" align=absMiddle>"
	s nodes=nodes_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href="_"""#"""_">"_text_"</A>"
	s nodes=nodes_"</NOBR></DIV>"
	
	s nodes=nodes_"<SPAN id=Set_"_id_" style=""DISPLAY:none"">"
	s nodes=nodes_"<input id=""HasChild"_id_""" name=""HasChild"_id_""" type=""hidden"_""" value="""_haschild_""">"
	s nodes=nodes_"<input id=""Loaded"_id_""" name=""Loaded"_id_""" type=""hidden"" value=""0"">"
	s nodes=nodes_"<input id=""Parent"_id_""" name=""Parent"_id_""" type=""hidden"" value="""_parent_""">"
	s nodes=nodes_"<input id=""Layer"_id_""" name=""Layer"_id_""" type=""hidden"" value="""_layer_""">"
	s nodes=nodes_"<input id=""IsLast"_id_""" name=""IsLast"_id_""" type=""hidden"" value="""_islast_""">"
	s nodes=nodes_"<input id=""ID"_id_""" name=""ID"_id_""" type=""hidden"" value="""_id_""">"
	s nodes=nodes_"</SPAN>"
	
	s nodes=nodes_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s nodes=nodes_"</SPAN>"
	q nodes
}

}
