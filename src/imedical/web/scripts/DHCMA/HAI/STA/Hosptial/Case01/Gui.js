
function InitCtlResultWin(){
	var obj = new Object();
	obj.btnClick="btnInfCase"
	Common_CreateMonth('SearchMonth');
	
	obj.girdInfList =$HUI.datagrid("#gridInfList",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		columns:[[
			{field:'ind',title:'序号',width:145}, 
			{field:'LocDesc',title:'科室',width:200},
			{field:'InfCount',title:'感染例次',width:200},
			{field:'InLocCount',title:'同期在科人数',width:200},
			{field:'InfRatio',title:'感染例次发生率',width:200,
				formatter:function(value){
					return parseFloat(value).toFixed(2)+"%"
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){	
		}
	});
	
	$("#redkw").keywords({
    	singleSelect:true,
   	 	labelCls:'red',
    	items:[
        	{text:'感染例次统计图',id:'keyInfCase',selected:true},
        	{text:'感染诊断统计图',id:'keyInfDrug'},
        	{text:'感染数据统计表',id:'keyInfData'}
   		 ],
    	onClick:function(v){
	    	if (v.id=="keyInfCase"){
				$('#Case02').css('display','none');
				$('#Case01').css('display','block');
				obj.ShowEChart1();
			}else if (v.id=="keyInfDrug"){
				$('#Case02').css('display','none');
				$('#Case01').css('display','block');
				obj.ShowEChart2();
			}else if (v.id=="keyInfData"){
				$('#Case01').css('display','none');
				$('#Case02').css('display','block');
				obj.ShowTable1();
			}
	    }
	});
	InitCtlResultWinEvent(obj);
	obj.loadEvent(arguments)
	return obj;
}