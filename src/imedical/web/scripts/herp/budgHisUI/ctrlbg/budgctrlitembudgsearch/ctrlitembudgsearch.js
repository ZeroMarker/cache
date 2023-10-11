var hospid = session['LOGON.HOSPID'];

$(function(){//初始化
    Initmain();
}); 

function Initmain(){
	
	//年度下拉框
		var yearBoxobj = $HUI.combobox("#yearBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
				},
			onSelect:function(rec){
				$('#itemSearchGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
					MethodName: 'ctrlBudgList', 
					year:$("#yearBox").combobox("getValue"),
					deptid:"",
					})
				}
		});
    //科室下拉框
    var deptBoxobj = $HUI.combobox("#deptBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
			},
			onSelect:function(rec){
				$('#itemSearchGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
					MethodName: 'ctrlBudgList', 
					year:$("#yearBox").combobox("getValue"),
					deptid:$("#deptBox").combobox("getValue"),
					})
				}
		});
		
	var GridColumn = [[ {
				field: 'year',
				title: '年度',
				width: 120,
			}, {
				field: 'deptname',
				title: '科室',
				width: 120,
			}, {
				field: 'sumyear',
				title: '各控制项年度总预算',
				width: 180,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Jan',
				title: '一月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Feb',
				title: '二月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Mar',
				title: '三月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Apr',
				title: '四月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'May',
				title: '五月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'June',
				title: '六月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'July',
				title: '七月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Aug',
				title: '八月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Sept',
				title: '九月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Oct',
				title: '十月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Nov',
				title: '十一月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Dec',
				title: '十二月',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}			

		]]
		var itemSearchGridObj = $HUI.datagrid('#itemSearchGrid', {
			region: 'center',
			fit: true,
			url: $URL,
			columns: GridColumn,
			queryParams:{
				ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
				MethodName: 'ctrlBudgList', 
				year:"",
				deptid:"",
			},
			singleSelect: true, 
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100]
		});
		
		
	//查询点击事件
	$("#FindBtn").click(function(){
		if($("#deptBox").combobox("getValue")){
			var deptder=$("#deptBox").combobox("getValue")
		}else{
			var deptder=""
			}
           
           itemSearchGridObj.load({
                ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
				MethodName: 'ctrlBudgList', 
				year:$("#yearBox").combobox("getValue"),
				deptid:deptder,
            })});

		
		
		
}