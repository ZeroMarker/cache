$(function () {
	InitOROperCatWin();
});

//页面Gui
var obj = new Object();
function InitOROperCatWin() {
	var SelectedInd = 0;
	obj.RecRowID= "";
	obj.RecKeyID= "";

    //手术分类
    obj.gridOperCat= $HUI.datagrid("#gridOperCat",{
		fit: true,
		title: "",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.STAS.NavigationSrv",
			QueryName:"QryNavigation"
		},
		columns:[[
			{field:'ID',title:'序号',width:40,sortable:true,showTip:true},
			{field:'Code',title:'指标代码',width:60},
			{field:'Desc',title:'指标名称',width:220}, 
			{field:'StatDesc',title:'指向报表',width:200,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnStatDesc_Click(\''+row.StatCode+'\',\''+row.StatDesc+'\')>'+row.StatDesc+'</a>';
				}			
			},
			{field:'Method',title:'计算公式',width:240,showTip:true}
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
			//所有列进行合并操作
            //$(this).datagrid("autoMergeCells");
            //指定列进行合并操作
            //$(this).datagrid("autoMergeCells", ['OperCat']);
		}
	});
		
	InitOROperCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}