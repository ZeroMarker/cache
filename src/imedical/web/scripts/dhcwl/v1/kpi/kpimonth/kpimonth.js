/**
*  Creator   : wk
*  CreatDate : 2018-05-23
*  Desc      : 指标日期ID维护界面
**/﻿

var monthObj = $HUI.datagrid("#kpiMonthGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.SECFunction',
		QueryName:'GetMonthQuery'
	},
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,50,100],
	fitColumns:true,
	toolbar:'#monToobar'
})

/*--日期列表--*/
var yearObj = $HUI.combobox("#yearForMonthID",{
	url:$URL+"?ClassName=web.DHCWL.V1.KPI.SECFunction&QueryName=GetYearList&ResultSetType=array",
	valueField:'code',
	textField:'desc'
});

/*--monthID查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		monthObj.load({ClassName:"web.DHCWL.V1.KPI.SECFunction",QueryName:"GetMonthQuery",filterValue:value});
	}
})

$("#monAddButton").click(function(){
	var date = new Date();
	var year = date.getFullYear();
	$('#yearForMonthID').combobox('setValue',year);
	$("#monAddDialog").show();
	$HUI.dialog("#monAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				var isValid = $("#monAddInforForm").form('validate');   //检查表单信息是否符合要求
				if (!isValid){
					myMsg("请按照提示填写内容");
					return;
				}
				var year = $('#yearForMonthID').combobox('getValue');
				$m({                                             //将信息保存到后台
					ClassName:'web.DHCWL.V1.KPI.SECFunction',
					MethodName:'CreatMonthID',
					year:year
				},function(txtData){
					myMsg(txtData);		  //弹框显示返回信息
					monthObj.reload();      //刷新当前页
					$HUI.dialog("#monAddDialog").close();  //关闭弹窗
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#monAddDialog").close();
			}
		}]
	})
})