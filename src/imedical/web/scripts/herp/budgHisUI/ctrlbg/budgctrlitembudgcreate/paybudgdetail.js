FYDetailGridShow = function (hospid, year,itemcode,deptId,isGov) {
	    var $win;
		 $win = $('#FYDetailWin').window({
			title: '���ÿ�Ŀ֧������',
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
		
		//���Ԥ����ʽ
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
		///�ж���
		var FYDGridColumn = [[ {
				field: 'ecoItemCo',
				title: '���ÿ�Ŀ',
				width: 120,
				formatter: function (value, row) {
					return row.Econame;
				},
			}, {
				field: 'detailYearBudg',
				title: '���Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter: EconoValueStyle
			}, {
				field: 'Jan',
				title: 'һ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Feb',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Mar',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Apr',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'May',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'June',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'July',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Aug',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Sept',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Oct',
				title: 'ʮ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Nov',
				title: 'ʮһ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Dec',
				title: 'ʮ����',
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
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell:onClickCellDetail
		});
	//��Ԫ�����¼�
	function onClickCellDetail(index,field){
		if(isGov == 1&&(field=='detailYearBudg')){
			var rows = $('#FYDetailGrid').datagrid('getRows');
			var row = rows[index];
			//alert(row.ecoItemCo);
			payDeAppShow(hospid,year,itemcode,deptId,row.ecoItemCo)}
		
		}
	//��ѯ����¼�
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

    //�رհ�ť
	$("#BaAddSave").click(function(){
   		$('#FYDetailWin').window('close');
	 })

	
	}