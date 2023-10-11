/**
 * func.bsnormal.js
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: ""
}



$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})

function Init(){
	PageLogicObj.m_Grid = InitGrid();
	
	
}

function InitEvent(){
	$("#i-fill").click(fillCqmx);
	$("#i-find").click(findConfig);
}

function PageHandle(){
	//
}

function findConfig () {
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Extend.CQMXBJ",
		QueryName : "QryCqmxList",
		inAdmid: ServerObj.EpisodeID,
		inSDate: $("#i-sdate").datebox("getValue")||"",
		inEDate: $("#i-edate").datebox("getValue")||""
	});
}

function fillCqmx () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return false;
	}
	var PW = $(document).width();
	var PH = $(document).height();
	var ArcimDr = selected.arcim;
	var AimDr = selected.daupid;
	var ApplyDr = selected.aaid;
	var Cqmxid = selected.Cqmxid;
	var src="dhcant.cqmx.bj.detail.csp?EpisodeID="+ServerObj.EpisodeID+"&ArcimDr="+ArcimDr+"&AimDr="+AimDr+"&ApplyDr="+ApplyDr+"&Cqmxid="+Cqmxid;
	if ('undefined'!==typeof websys_getMWToken){
        src += "&MWToken="+websys_getMWToken();
    }
    var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("EditCQMXInfo","̼��ùϩ�༰��ӻ�������", PW, PH,"icon-w-edit","",$code,"");
	
}

function InitGrid(){
	var columns = [[
		{field:'fillFlag',title:'��д��־',width:60,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='fillspan'>����д</span>";
				} else {
					return "<span class='fillspan-no'>δ��д</span>";
				}
			}
		},
		{field:'patName',title:'��������',width:100},
		{field:'arcimDesc',title:'ҩƷ����',width:150},
		{field:'docName',title:'����ҽ��',width:100},
		{field:'fillDT',title:'��ҽ������',width:100},
		{field:'UnifyFillUser',title:'��д��',width:100},
		{field:'UnifyFillDT',title:'��д����',width:100},
		{field:'daupid',title:'daupid',width:100,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Extend.CQMXBJ",
			QueryName : "QryCqmxList",
			inAdmid: ServerObj.EpisodeID,
			inSDate: $("#i-sdate").datebox("getValue")||"",
			inEDate: $("#i-edate").datebox("getValue")||""
		},
		columns :columns,
		toolbar:[{
				text:'��д',
				id:'i-fill',
				iconCls: 'icon-write-order'
			}
		],
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_Grid.getSelected();
			if (selrow){
				var oldIndex=PageLogicObj.m_Grid.getRowIndex(selrow);
				if (oldIndex==index){
					PageLogicObj.m_Grid.unselectRow(index);
					return false;
				}
			}
		}
	});
	
	return DurDataGrid;
}

function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}





 