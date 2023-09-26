var init = function() {
	$(".ystep1").loadStep({
				size : "large",
				color : "green",
				steps : [{
							title : "δ�ύ",
							content : "�õ�����δ�ύ"
						}, {
							title : "�ύ",
							content : "�õ����Ѿ��ύ"
						}, {
							title : "ȷ��",
							content : "�õ����Ѿ�ȷ��"
						}, {
							title : "�ܾ�",
							content : "�õ����ѱ��ܾ�"
						}, {
							title : "����",
							content : "�õ����Ѿ�����"
						}, {
							title : "����",
							content : "�õ����Ѿ�����"
						}, {
							title : "����",
							content : "�õ����ѱ�����"
						}, {
							title : "�黹",
							content : "�õ����Ѿ��黹"
						}]
			})        
	var MainReqFlage="";
	// �������
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"ReqLoc"}));
	var ReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�¼����
			$("#FReqLoc").combobox('setValue',gLocId);
		}
	});
	//��Ӧ����
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			$("#FSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	
	////===============================��ʼ�����end=============================
	//��ѯ
	
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDrugInfo();
			$UI.clear(ItemListGrid);
		}
	});
	$('#ClearBT').on('click', ClearDrugInfo);
	function QueryDrugInfo() {
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	function ClearDrugInfo(){
		$UI.clearBlock('#MainCondition');
		SupLocBox.reload();
		ReqLocBox.reload();
		$UI.fillBlock('#MainCondition',Dafult)
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$(".ystep1").setStep(1);
	}
	
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
			}
	 $UI.fillBlock('#MainCondition',Dafult)
	
	//���������Ļس��¼����� end
	var MainCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '����',
			field: 'No',
			width:100,
			fitColumns:true
		}, {
			title: '�ܾ�ԭ��',
			field: 'RefuseReason',
			width:150,
			fitColumns:true
		}, {
			title: '����״̬',
			field: 'ReqFlag',
			width:100,
			fitColumns:true
		}, {
			title: '�ύʱ��',
			field: 'commitDate',
			width:150,
			fitColumns:true
		}, {
			title: '�ύ��',
			field: 'commitUser',
			width:100,
			fitColumns:true
		}, {
			title: '��������',
			field: 'ReqTypeDesc',
			width:100,
			fitColumns:true
		}, {
			title: '�����̶�',
			field: 'ReqLevelDesc',
			width:100,
			fitColumns:true
		}, {
			title: '�������',
			field: 'ReqLocDesc',
			width:100,
			fitColumns:true
		}
	]];

	$("#FReqLoc").combobox('setValue',gLocId);
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		onLoadSuccess:function(data){  
			        if(data.rows.length>0){
						$('#MainList').datagrid("selectRow", 0);
						var Row=MainListGrid.getRows()[0]
						var Id = Row.RowId;
						var state = Row.ReqFlag;
						if ("δ�ύ" == state) {
							$(".ystep1").setStep(1);
						} else if ("�ύ" == state) {
							$(".ystep1").setStep(2);
						} else if ("ȷ��" == state) {
							$(".ystep1").setStep(3);
						} else if ("����" == state) {
							$(".ystep1").setStep(5);
						} else if ("����" == state) {
							$(".ystep1").setStep(6);
						} else if ("����" == state) {
							$(".ystep1").setStep(7);
						} else if ("�黹" == state) {
							$(".ystep1").setStep(8);
						} else if ("�ܾ�" == state) {
							$(".ystep1").setStep(4);
						}
						FindItemByF(Id);
					}	
			},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var state = Row.ReqFlag;
			if ("δ�ύ" == state) {
				$(".ystep1").setStep(1);
			} else if ("�ύ" == state) {
				$(".ystep1").setStep(2);
			} else if ("ȷ��" == state) {
				$(".ystep1").setStep(3);
			} else if ("����" == state) {
				$(".ystep1").setStep(5);
			} else if ("����" == state) {
				$(".ystep1").setStep(6);
			} else if ("����" == state) {
				$(".ystep1").setStep(7);
			} else if ("�黹" == state) {
				$(".ystep1").setStep(8);
			} else if ("�ܾ�" == state) {
				$(".ystep1").setStep(4);
			}
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);	
			}	
			MainListGrid.commonClickCell(index,filed)
		}
	})
	//�����������б�
	var packData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetPackage'	,
			ResultSetType:"array",
			typeDetial: "2"
	},false);
	var PackageBox = {
		type: 'combobox',
		options: {
			data:packData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[GridList.editIndex];
				row.PackageName = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '����������',
			field: 'PackageDR',
			width:200,
			formatter: CommonFormatter(PackageBox, 'LocDr', 'PackageName')
			
		},{
			title: '��������',
			field: 'Qty',
			align: 'right',
			width:100
		},{
			title: '��ע',
			field: 'Remark',
			width:200
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			singleSelect:false
			
	});	
	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF',
			ApplyId:Id
			
		});
	}
	
}
$(init);
