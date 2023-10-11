FYDetailGridShow = function (hospid, year,itemcode,deptId,isGov) {
	    var $win;
		 $win = $('#FYDetailWin').window({
			title: '经济科目支出控制',
			width: 1015,
			height: 500,
			top: ($(window).height() - 500) * 0.5,
			left: ($(window).width() - 1015) * 0.5,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			shadow: true,
			modal: true
		});
		
		$('#FYDetailWin').window('open');
		
		//年度预算样式
		function EconoValueStyle(value, row, index){
			if ((row != null)&&(value!='')&&(value!=null)) {
				value=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
				}
			if (isGov==1) {
				return '<a href="#" class="grid-td-text" >' + value + '</a>';
			} else {
				return value;
		}
	} 
		///列定义
		var FYDGridColumn = [[ {
				field: 'ecoItemCo',
				title: '经济科目',
				width: 120,
				formatter: function (value, row) {
					return row.Econame;
				},
			}, {
				field: 'detailYearBudg',
				title: '年度预算',
				width: 100,
				halign:'right',
				align:'right',
				formatter: EconoValueStyle
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
		var FYDetailGridObj = $HUI.datagrid('#FYDetailGrid', {
			region: 'center',
			fit: true,
			url: $URL,
			queryParams:{
				ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgCreate',
				MethodName: 'payBudgDetList', 
				hospid: hospid,
				singleSelect: true, 
				year:year,
				itemcode:itemcode,
				deptId:deptId,
				EcoCoNa:""
			},
			columns: FYDGridColumn,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell:onClickCellDetail
		});
	//单元格点击事件
	function onClickCellDetail(index,field){
		if(isGov == 1&&(field=='detailYearBudg')){
			var rows = $('#FYDetailGrid').datagrid('getRows');
			var row = rows[index];
			//alert(row.ecoItemCo);
			payDeAppShow(hospid,year,itemcode,deptId,row.ecoItemCo)}
		
		}
	//查询点击事件
	$("#FindBtn").click(function(){
	    var EcoCoNa = $('#NameM').val()
    
           FYDetailGridObj.load({
               ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgCreate',
				MethodName: 'payBudgDetList', 
				hospid: hospid,
				year:year,
				itemcode:itemcode,
				deptId:deptId,
				EcoCoNa:EcoCoNa
            })});

    //关闭按钮
	$("#BaAddSave").click(function(){
   		$('#FYDetailWin').window('close');
	 })

	
	}