
//名称	DHCPEGPaymodeDetail.hisui.js
//功能	团体支付方式汇总	
//创建	2019.04.28
//创建人  xy

$(function(){
	InitCombobox();
	 
	InitGPaymodeDetailDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
    
})

//查询
function BFind_click(){

	$("#GPaymodeDetailQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.FeeReport.RcptPayDetail",
		QueryName:"QueryPayModeDetailNew",
		BeginDate:$("#BeginDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		GBID:$("#GDesc").combogrid('getValue'),
		PayModeDR:$("#PayMode").combobox('getValue'),
		LocID:session['LOGON.CTLOCID']

	});
	
}

function InitGPaymodeDetailDataGrid(){
	$.cm({
		ClassName: "web.DHCPE.FeeReport.RcptPayDetail",
		MethodName: "GetGPaymodeDetailColumns",
		LocID:session['LOGON.CTLOCID']
	}, function (txtData) {
		var columnAry = new Array();
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["width"] = item.width;
			columnAry.push(column);
		});
		var GPaymodeDetailObj = $HUI.datagrid('#GPaymodeDetailQueryTab', {
				fit: true,
				border : false,
				striped: true,
				singleSelect: true,
				autoRowHeight: false,
				url: $URL,
				pagination: true,
				rownumbers: true,
				pageSize: 20,
				pageList: [20, 30, 40, 50],
				columns: [columnAry],
				queryParams: {
						ClassName:"web.DHCPE.FeeReport.RcptPayDetail",
						QueryName:"QueryPayModeDetailNew",
						BeginDate:$("#BeginDate").datebox('getValue'),
						EndDate:$("#EndDate").datebox('getValue'),
						GBID:$("#GDesc").combogrid('getValue'),
						PayModeDR:$("#PayMode").combobox('getValue'),
						LocID:session['LOGON.CTLOCID']
				
				}
			});
	});
	

		
}




function InitCombobox()
{
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GDesc",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGBaseInfo&QueryName=DHCPEGBaseInfoList",
		mode:'remote',
		delay:200,
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},

		columns:[[
			{field:'GBI_Desc',title:'团体名称',width:80},
			{field:'GBI_Code',title:'团体编码',width:140},
			{field:'GBI_RowId',title:'ID',width:100},			
			
		]]

		});
		
	// 支付方式	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text'
		
		
		})	
	

}