payDeAppShow = function (hospid,year,itemcode,deptId,EcoCo) {
	    var $win;
		 $win = $('#PayDeAppWin').window({
			title: '�����ɹ�ƷĿ֧������',
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
		
		///�ж���
		var FYDGridColumn = [[ {
				field: 'purCode',
				title: 'ƷĿ����',
				width: 120,
				formatter: function (value, row) {
					return row.Purname;
				},
			}, {
				field: 'deappYearBudg',
				title: '���Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
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
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100]
		});

	//��ѯ����¼�
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

    //�رհ�ť
	$("#Certain").click(function(){
   		$('#PayDeAppWin').window('close');
	 })

	
	}