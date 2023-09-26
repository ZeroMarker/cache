//外来器械登记界面js
function deleteMain(mainRowId,PackageType){
	if (isEmpty(mainRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.PackageInfo.Package',
				MethodName:'DeleteMain',
				mainRowId:mainRowId,
				PackageType:PackageType
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#PackageList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
}

var init = function () {
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('ForeignDeviceTB'));
			MainGrid.load({
				ClassName: "web.CSSDHUI.PackageCallBack.ForeignDeviceRegister",
				QueryName: "GetDeviceRegister",
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
            AddWin(saveMast);
		}
	});
	//保存单据
    $UI.linkbutton('#SaveBT',{ 
        onClick:function(){
            saveMastRows()
        }
    });
    function saveMast(){
		var Params = JSON.stringify($UI.loopBlock('ForeignDeviceTB'));
		MainGrid.load({
			ClassName: "web.CSSDHUI.PackageCallBack.ForeignDeviceRegister",
			QueryName: "GetDeviceRegister",
			Params:Params
		});
    }
	
	function saveMastRows(){
		var Rows=MainGrid.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
        $.cm({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			MethodName: 'jsUpdate',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				MainGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
    }
	
	//默认日期设置
	var Today = new Date();
	var Dafult={
		RecDateValue:Today
	}
	$UI.fillBlock('#ForeignDeviceTB',Dafult)
	
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('ForeignDeviceTB'));
			MainGrid.load({
				ClassName: "web.CSSDHUI.PackageCallBack.ForeignDeviceRegister",
				QueryName: "GetDeviceRegister",
				Params:Params
			});
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('ForeignDeviceTB');
			$UI.clear(MainGrid);
		}
	});
	
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			MainGrid.commonDeleteRow();
			Delete();
		}
	});
	//回收人
	$("#Transfer").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#Transfer").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#Transfer").val(Ret.split('^')[2]);
				$("#TransferDr").val(Ret.split('^')[1]);
				$("#TransferRec").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#Transfer").val("");
				$("#Transfer").focus();
			}
		}
	});
	//移交
	$UI.linkbutton('#TransferBT',{ 
		onClick:function(){
			var Params = $UI.loopBlock('ForeignDeviceTB');
			if(isEmpty(Params.Transfer)){
				$UI.msg('alert','请输入移交人！');
				$("#Transfer").focus();
				return;
			}
			if(isEmpty(Params.TransferRec)){
				$UI.msg('alert','请输入移交接收人！');
				$("#TransferRec").focus();
				return;
			}
			var flag=false;
			var rows = MainGrid.getChecked();
			for (var i=0;i<rows.length;i++)
			{ 
				if(rows[i].IsTransfer=="是"){
					flag=true;
				}
			}
			if(flag==true){
				$UI.msg('alert','所选的器械包中存在已移交的器械，请核对后移交！');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
				MethodName: 'UpdateTransfer',
				Params: JSON.stringify(rows),
				ParamsTB: JSON.stringify(Params)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						MainGrid.reload();
						$("#Transfer").val("");
						$("#TransferDr").val("");
						$("#TransferRec").val("");
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
		}
	});
	function Delete(){
		var Rows=MainGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
					MethodName: 'DeleteForeignDevice',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							MainGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
	var NotUseFlagData=[{
		"RowId":"Y",
		"Description":"是"
	},{
		"RowId":"N",
		"Description":"否"   
	}]
	        
	var NotUseFlagCombox= {
	    type: 'combobox',
	    options: {
	        data:NotUseFlagData,
	        valueField: 'RowId',
	        textField: 'Description',
			required:true,
	        editable:true
	    }
	};
	
	var OperatorTypeData=[{
		"RowId":"1",
		"Description":"急诊手术"
	},{
		"RowId":"2",
		"Description":"择期手术"   
	}]
	        
	var OperatorTypeCombox= {
	    type: 'combobox',
	    options: {
	        data:OperatorTypeData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true
	    }
	};

	var SexData=[{
		"RowId":"1",
		"Description":"男"
	},{
		"RowId":"0",
		"Description":"女"   
	}]
	        
	SexCombox= {
	    type: 'combobox',
	    options: {
	        data:SexData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true
	    }
	};
	///获取使用科室数据
	var UseLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var UseLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + UseLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onLoadSuccess: function (data) {
				//$(this).combobox('setValue',gLocId);
			},
			onSelect: function (record) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				row.ExtLocDesc = record.Description;
			}
		}
	};
	///厂商下拉数据
	var FirmBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onLoadSuccess: function (data) {
				//$(this).combobox('setValue',gLocId);
			},
			onSelect: function (record) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				row.FirmName = record.Description;
			}
		}
	};

	var typeDetial=""
	//消毒包下拉数据
	var PackageBox = $HUI.combobox('#package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial+'&packageClassDr='+packageClassDr+'&Hospital='+gHospId,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var rows = MainGrid.getRows();
			var row = rows[MainGrid.editIndex];
			row.InstruName = record.Description;
		}
	});	

	var MainCm = [[
		{
			title : '',
			field : 'ck',
			checkbox : true,
			width : 50
		}, {
			title: 'id',
			field: 'RowId',
			align: 'left',
			width:100,
			hidden: true
		}, {
			title: '消毒包名称',
			field: 'InstruDr',
			align: 'left',
			width:150,
			sortable: true,
			formatter: CommonFormatter(PackageBox, 'InstruDr', 'InstruName'),
			editor: PackageBox
		}, {
			title: '包标牌编码',
			field: 'InstruCode',
			align: 'left',
			width:100,
			sortable: true,
			editor:{options:{required:true}}
		}, {
			title: '使用科室',
			field: 'ExtLocDr',
			align: 'left',
			width:100,
			sortable: true,
			formatter: CommonFormatter(UseLocCombox, 'ExtLocDr', 'ExtLocDesc'),
			editor: UseLocCombox
		}, {
			title: '接收数量',
			field: 'RecNum',
			align: 'right',
			width:80,
			sortable: true,
			editor:{type:'numberbox',options:{required:true,min:0}}
		},{
			title: '接收日期',
			field: 'RecDate',
			align: 'left',
			width:100,
			sortable: true
		},{
			title: '接收人Dr',
			field: 'RecManDr',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		},{
			title: '接收人',
			field: 'RecManName',
			align: 'left',
			width:100,
			sortable: true
		}, {
			title: '器械数量',
			field: 'InstruNum',
			align: 'right',
			width:80,
			sortable: true,
			editor:{type:'numberbox',options:{min:0}}
		},{
			title: '是否植入物',
			field: 'Implants',
			width:80,
			align: 'center',
			sortable: true,
			formatter: CommonFormatter(NotUseFlagCombox, 'Implants', 'ImplantsDesc'),
			editor: NotUseFlagCombox
		}, {
			title: '收费单号',
			field: 'Receipt',
			align: 'left',
			width:100,
			sortable: true,
			editor:{type:'validatebox'}
		}, {
			title: '病人姓名',
			field: 'SickerName',
			align: 'left',
			width:80,
			sortable: true,
			editor:{type:'validatebox'}
		}, {
			title: '床号',
			field: 'BedNo',
			align: 'right',
			width:50,
			sortable: true,
			editor:{type:'numberbox',options:{min:1}}
		}, {
			title: '登记号',
			field: 'HospitalNo',
			align: 'right',
			width:80,
			sortable: true
		},{
			title: '手术类型',
			field: 'OperatorType',
			width:80,
			align: 'center',
			sortable: true,
			formatter: CommonFormatter(OperatorTypeCombox, 'OperatorType', 'OperatorTypeDesc'),
			editor: OperatorTypeCombox
		}, {
			title: '手术医生',
			field: 'UseDoctor',
			align: 'left',
			width:100,
			sortable: true,
			editor:{type:'validatebox'}
		}, {
			title: '使用日期',
			field: 'UseDate',
			align: 'left',
			width:100,
			sortable: true
		},{
			title: '厂商',
			field: 'FirmDr',
			align: 'left',
			width:100,
			sortable: true,
			formatter: CommonFormatter(FirmBox, 'FirmDr', 'FirmName'),
			editor: FirmBox
		}, {
			title: '电话',
			field: 'Tel',
			align: 'right',
			width:100,
			sortable: true
		},{
			title: '送包人',
			field: 'SerMan',
			align: 'left',
			width:100,
			sortable: true
		}, {
			title: '动力器械',
			field: 'PowerInstru',
			align: 'left',
			width:100,
			sortable: true,
			editor:{type:'validatebox'}
		}, {
			title: '医院Dr',
			field: 'HospitalDr',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		}, {
			title: '医院',
			field: 'HospitalName',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		}, {
			title: '器械功能检查',
			field: 'FunctionalCheck',
			align: 'left',
			width:100,
			sortable: true,
			editor:{type:'validatebox'},
			hidden: true
		}, {
			title: '病人性别',
			field: 'PatientSex',
			align: 'left',
			width:80,
			sortable: true,
			formatter: CommonFormatter(SexCombox, 'PatientSex', 'PatientSexDesc'),
			editor: SexCombox
		}, {
			title: '病人年龄',
			field: 'PatientAge',
			align: 'left',
			width:80,
			sortable: true,
			editor:{type:'numberbox',options:{min:0}}
		}, {
			title: '灭菌参数',
			field: 'SterParameter',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		}, {
			title: '高温选项',
			field: 'SterTemp',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		}, {
			title: '是否反洗',
			field: 'BackWash',
			align: 'left',
			width:100,
			sortable: true,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			align: 'left',
			width:150,
			sortable: true
		}, {
			title: '移交人',
			field: 'Transfer',
			align: 'left',
			width:80,
			sortable: true
		}, {
			title: '移交接收人',
			field: 'TransferRec',
			align: 'left',
			width:90,
			sortable: true
		}, {
			title: '移交日期',
			field: 'TransferDate',
			align: 'left',
			width:150,
			sortable: true
		}, {
			title: '是否移交',
			field: 'IsTransfer',
			align: 'left',
			width:80,
			sortable: true
		}, {
			title: '备注',
			field: 'Remark',
			align: 'left',
			width:100,
			sortable: true,
			editor:{type:'validatebox'}
		}
	]];
	var Params = JSON.stringify($UI.loopBlock('ForeignDeviceTB'));
    var MainGrid = $UI.datagrid('#ExtralList', {
        queryParams: {
			ClassName: "web.CSSDHUI.PackageCallBack.ForeignDeviceRegister",
			QueryName: "GetDeviceRegister",
			Params:Params
        },
		lazy:false,
        columns: MainCm,
		selectOnCheck: false,
		toolbar: '#ForeignDeviceTB',
		onClickCell: function(index, filed ,value){
            MainGrid.commonClickCell(index,filed)
        },
		onBeforeEdit:function(){
			var rowMain = $('#ExtralList').datagrid('getSelected');
			if(rowMain.IsTransfer=="是") return false;
		}
    });

}
$(init);