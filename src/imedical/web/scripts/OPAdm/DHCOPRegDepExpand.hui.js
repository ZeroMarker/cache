var PageLogicObj={
	m_DHCOPRegDepExpandTabDataGrid:""
};
$(function(){
	//ҳ�����ݳ�ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	DHCOPRegDepExpandTabDataGridLoad();
});
function InitEvent(){
	$("#Search").click(DHCOPRegDepExpandTabDataGridLoad);
	$("#Save").click(SaveClickHandle);
}
function SaveClickHandle(){
	var data=PageLogicObj.m_DHCOPRegDepExpandTabDataGrid.datagrid('getData');
	for (var i=0;i<data.rows.length;i++){
		var LocDesc=data.rows[i]["LocCode"];
		var LocId=data.rows[i]["LocId"];
		var CFLocInsuNotRealTime=0,CFRegQtyNotAMP=0,CFLocRegLimit=0;
		var editors = PageLogicObj.m_DHCOPRegDepExpandTabDataGrid.datagrid('getEditors', i); 
		var selected=editors[0].target.is(':checked');
		if(selected) CFLocInsuNotRealTime="1";
		var selected=editors[1].target.is(':checked');
		if(selected) CFLocRegLimit="1";
		
		var SaveStr=CFLocInsuNotRealTime+"^"+CFRegQtyNotAMP+"^"+CFLocRegLimit;
		var rtn=$.cm({
			ClassName:"web.DHCOPRegConfig",
			MethodName:"SaveConfig1",
			Node:"OPRegDepExpand", 
			Node1:LocId, 
			NodeValue:SaveStr
		},false);
		if (rtn!=0) {
			$.messager.alert("��ʾ",LocDesc+",���治�ɹ�!");
		}
	}
	DHCOPRegDepExpandTabDataGridLoad();
	$.messager.alert("��ʾ","����ɹ�!");
}
function Init(){
	PageLogicObj.m_DHCOPRegDepExpandTabDataGrid=InitDHCOPRegDepExpandTabDataGrid();
}
function InitDHCOPRegDepExpandTabDataGrid(){
	var Columns=[[ 
		{field:'LocId',title:'����Rowid',hidden:true,width:10},
		{field:'LocCode',title:'���Ҵ���',width:100},
		{field:'LocDesc',title:'��������',width:220},
		{field:'LocInsuNotRealTime',title:'ҽ���ҺŲ�ʵʱ����',width:150,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           }
        },
		{field:'LocRegLimit',title:'����ÿ��ÿ�����ͬ���ҹҺ��޶����',width:230,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           }
        }
    ]]
	var DHCOPRegDepExpandTabDataGrid=$("#DHCOPRegDepExpandTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocId',
		columns :Columns,
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				PageLogicObj.m_DHCOPRegDepExpandTabDataGrid.datagrid('beginEdit',i);
			}
		}
	}); 
	return DHCOPRegDepExpandTabDataGrid;
}
function DHCOPRegDepExpandTabDataGridLoad(){
	var Loc=$("#desc").val();
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "Loclookup",
	    desc : Loc,
	    HospitalID:ServerObj.HospID,
	    Pagerows:PageLogicObj.m_DHCOPRegDepExpandTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCOPRegDepExpandTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}