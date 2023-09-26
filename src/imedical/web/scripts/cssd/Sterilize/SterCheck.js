var init = function() {
	var IsSterFinish = IfSterFinish();	//确定是否默认灭菌完成
	//锅号
	$("#MachineNo").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#MachineNo").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetMachineNo',"sterilizer",v);
			if(Ret.split('^')[0]=="Y"){
				$("#MachineNoValue").val(Ret.split('^')[1]);
				$("#MachineNo").val(Ret.split('^')[2]);
				$("#SterPro").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#MachineNo").val("");
				$("#MachineNo").focus();
			}
		}
	});
	//灭菌程序
	$("#SterPro").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#SterPro").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetSterPro',"2001",v);
			if(Ret.split('^')[0]=="Y"){
				$("#SterPro").val(Ret.split('^')[2]);
				$("#SterProValue").val(Ret.split('^')[1]);
				$("#SterUser").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#SterPro").val("");
				$("#SterPro").focus();
			}
		}
	});
	//灭菌人
	$("#SterUser").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#SterUser").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#SterUser").val(Ret.split('^')[2]);
				$("#SterUserValue").val(Ret.split('^')[1]);
				$("#MachineCount").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#SterUser").val("");
				$("#SterUser").focus();
			}
		}
	});
	setDafult();
	var Params = JSON.stringify($UI.loopBlock('MainCondition'));
	var FMachineNoBox = $HUI.combobox('#FMachineNo', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type=sterilizer',
		valueField: 'RowId',
		textField: 'Description'
	}); 
	
	//不合格原因下拉框
	var ReasonBox = $HUI.combobox('#UnqualifiedReason', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	//查询
	$UI.linkbutton('#SearchBT',{ 
		onClick:function(){
			query()
			$UI.clear(MainListGrid);
			$UI.clear(ItemListGrid);
		}
	});
	var query = function query(){ 
		var ParamsObj=$UI.loopBlock('#MainCondition');
		var Params=JSON.stringify(ParamsObj);
		$("#UnqualifiedReason").combobox('setValue',"");
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll'  ,
			parame: Params
		});
	}

	//合格
	$UI.linkbutton('#OKBT',{ 
		onClick:function(){
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert','请选操作数据!');
				return false;
			}
			if (row.IsCHK == "1") {
				$UI.msg('alert','已验收合格，不能进行验收合格操作!');
				return false;
			}else if (row.IsCHK == "2") {
				$UI.msg('alert','已验收不合格，不能进行验收合格操作!');
				return false;
			}else{
				$.cm({
					ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
					MethodName: 'jsOK',
					MainId: row.RowId,
					User:gUserId,
					IsSterFinish:IsSterFinish
				},function(jsonData){
					if(jsonData.success>=0){
						MainListGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		}
	});

	//不合格
	$UI.linkbutton('#FailBT',{ 
		onClick:function(){
			var row=MainListGrid.getSelectedData();
			if (isEmpty(row)) {
				$UI.msg('alert','请选操作数据!');
				return false;
			}
			if (row[0].IsCHK == "1") {
				$UI.msg('alert','已验收合格，不能进行验收不合格操作!');
				return false;
			}else if (row[0].IsCHK == "2") {
				$UI.msg('alert','已验收不合格，不能进行验收不合格操作!');
				return false;
			}else{
				if (isEmpty(row[0].ReasonId)) {
					$UI.msg('alert','请选择原因!');
					return false;
				}
			}
			
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName: 'jsFail',
				MainId: row[0].RowId,
				User:gUserId,
				ResonDr: row[0].ReasonId,
				gLocId:gLocId,
				IsSterFinish:IsSterFinish
			},function(jsonData){
				if(jsonData.success>=0){
					MainListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	
	//单个明细验收不合格
	$UI.linkbutton('#CheckFailBT',{ 
		onClick:function(){
			var MainRow=MainListGrid.getSelected();
			if(!isEmpty(MainRow.IsCHK)){
				$UI.msg('alert',"该锅已验收,无法重复验收");
				return;
			}
			var Detail=ItemListGrid.getChecked();
			if(isEmpty(Detail)){
				$UI.msg('alert',"请选择不合格的灭菌明细");
				return;
			}
			var ReasonDr=$("#UnqualifiedReason").combobox('getValue')
			if(isEmpty(ReasonDr)){
				$UI.msg('alert',"请选择不合格原因");
				return;
			}
			var DetailIds=""
			$.each(Detail, function(index, item){
				if(DetailIds==""){
					DetailIds=item.RowId;
				}else{
					DetailIds=DetailIds+","+item.RowId;
				}
			});
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName: 'jsSingleFail',
				MainId: MainRow.RowId,
				User:gUserId,
				ReasonDr: ReasonDr,
				gLocId:gLocId,
				DetailIds:DetailIds,
				IsSterFinish:IsSterFinish
			},function(jsonData){
				if(jsonData.success>=0){
					$("#UnqualifiedReason").combobox('setValue',"");
					$UI.msg('success',jsonData.msg);
					MainListGrid.reload();
				}else{
					$("#UnqualifiedReason").combobox('setValue',"");
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});


	//上面输入框的回车事件处理 end
	var ReasonComData = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetRetReason',
			ResultSetType: 'array'
		}, false);
	var ReasonCombox = {
		type: 'combobox',
		options: {
			data: ReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.ReasonName = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	}

	var MainCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '验收结果',
			field: 'IsCHK',
			width:100,
			align:'center',
			fitColumns:true ,
			formatter: function(value,row,index){
				if (row.IsCHK=="1"){
					return "合格";
				} else if(row.IsCHK=="2"){
					return "不合格";
				}else if(row.IsCHK==""){
					return "未验收";
				}
			},
			styler: function(value,row,index){
				if (value == '1') {
					return 'background:#15b398;color:white';
				}else if(value == '2'){
					return 'background:#ff584c;color:white';
				}else {
					return 'background:#ffb746;color:white'
				}
			}
		}, {
			title: '锅号',
			field: 'MachineNo',
			width:100,
			fitColumns:true
		}, {
			title: '锅次',
			field: 'No',
			width:120,
			fitColumns:true
		}, {
			title: '灭菌程序',
			field: 'Progress',
			width:100,
			fitColumns:true
		}, {
			title: '灭菌人',
			field: 'SterName',
			width:100,
			fitColumns:true
		}, {
			title: '灭菌日期',
			field: 'SterDate',
			width:100,
			fitColumns:true
		}, {
			title: '灭菌时间',
			field: 'SterTime',
			width:100,
			fitColumns:true
		},{
			title: '验收人',
			field: 'chkame',
			width:100,
			fitColumns:true
		}, {
			title: '验收时间',
			field: 'CHKTime',
			width:100,
			fitColumns:true
		}, {
			title: '不合格原因',
			field: 'ReasonId',
			width:200,
			fitColumns:true,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'ReasonDesc'),
			editor: ReasonCombox
		}
	]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll',
			parame:Params
		},
		columns: MainCm,
		toolbar:'#UomTB',
		lazy:false,
		onLoadSuccess : function(data) {
			if (data.rows.length > 0) {
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
			}
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
			}   
			MainListGrid.commonClickCell(index,filed)
		}
	})
	var ItemCm = [[{
				title : '',
				field : 'ck',
				checkbox : true,
				width : 30
			},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '条码',
			field: 'Label',
			width:150,
			fitColumns:true
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:169,
			fitColumns:true
		},{
			title: '数量',
			field: 'Qty',
			width:100,
			align:'right',
			fitColumns:true
		},{
			title: '不合格原因',
			field: 'ReasonDr',
			width:179,
			formatter: CommonFormatter(ReasonCombox, 'ReasonDr', 'ReasonName'),
			fitColumns:true
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			MethodName: 'SelectByF'
		},
		columns: ItemCm,
		pagination:false,
		singleSelect:false,
		selectOnCheck: false
	}); 
	function FindItemByF(Id) {
		$("#UnqualifiedReason").combobox('setValue',"");
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectByF',
			SterId:Id
		});
	}
	//设置默认值
	function setDafult(){
		$UI.clearBlock('#MainCondition');
		var FComplateFlag="Y"
		if(IsSterFinish=='Y'){
			FComplateFlag="F"
		}
		var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate,
			FComplateFlag:FComplateFlag
		}
	$HUI.radio("#NOCheck").setValue(true);
	$UI.fillBlock('#MainCondition',Dafult)
	}
	setDafult();
}
$(init);
