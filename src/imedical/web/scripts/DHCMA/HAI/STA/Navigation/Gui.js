$(function () {
	InitOROperCatWin();
});

//ҳ��Gui
var obj = new Object();
function InitOROperCatWin() {
	var SelectedInd = 0;
	obj.RecRowID= "";
	obj.RecKeyID= "";

    //��������
    obj.gridOperCat= $HUI.datagrid("#gridOperCat",{
		fit: true,
		title: "",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.STAS.NavigationSrv",
			QueryName:"QryNavigation"
		},
		columns:[[
			{field:'ID',title:'���',width:40,sortable:true,showTip:true},
			{field:'Code',title:'ָ�����',width:60},
			{field:'Desc',title:'ָ������',width:220}, 
			{field:'StatDesc',title:'ָ�򱨱�',width:200,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnStatDesc_Click(\''+row.StatCode+'\',\''+row.StatDesc+'\')>'+row.StatDesc+'</a>';
				}			
			},
			{field:'Method',title:'���㹫ʽ',width:240,showTip:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOperCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOperCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//�����н��кϲ�����
            //$(this).datagrid("autoMergeCells");
            //ָ���н��кϲ�����
            //$(this).datagrid("autoMergeCells", ['OperCat']);
		}
	});
		
	InitOROperCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}