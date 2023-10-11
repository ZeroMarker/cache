payDeAppShow = function (hospid,year,itemcode,deptId,EcoCo) {
	    var $win;
		 $win = $('#PayDeAppWin').window({
			title: '政府采购品目支出控制',
			width: 900,
			height: 500,
			top: ($(window).height() - 500) * 0.5,
			left: ($(window).width() - 900) * 0.5,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			shadow: true,
			modal: true
		});
		
		$('#NamePur').val("");
		$('#PayDeAppWin').window('open');
		
		///列定义
		var FYDGridColumn = [[ {
				field: 'purCode',
				title: '品目名称',
				width: 120,
				formatter: function (value, row) {
					return row.Purname;
				},
			}, {
				field: 'deappYearBudg',
				title: '年度预算',
				width: 100,
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
		var PayDeAppGridObj = $HUI.datagrid('#PayDeAppGrid', {
			region: 'center',
			fit: true,
			url: $URL,
			queryParams:{
				ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgCreate',
				MethodName: 'payBudgDeApptList', 
				hospid: hospid,
				year:year,
				itemcode:itemcode,
				deptId:deptId,
				EcoCo:EcoCo,
				PurCoNa:""
			},
			columns: FYDGridColumn,
			singleSelect: true, 
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100]
		});

	//查询点击事件
	$("#FindBnpur").click(function(){
	    var PurCoNa = $('#NamePur').val()
    
           PayDeAppGridObj.load({
               ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgCreate',
				MethodName: 'payBudgDeApptList', 
				hospid: hospid,
				year:year,
				itemcode:itemcode,
				deptId:deptId,
				EcoCo: EcoCo,
				PurCoNa :PurCoNa 
            })});

    //关闭按钮
	$("#Certain").click(function(){
   		$('#PayDeAppWin').window('close');
	 })

	
	}