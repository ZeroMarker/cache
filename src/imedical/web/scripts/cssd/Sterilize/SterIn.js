//删除明细
function deleteItem(sterItemRowId){
	if (isEmpty(sterItemRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
			if(data){   
				$.cm({
					ClassName:'web.CSSDHUI.PackageSterilize.SterilizeItem',
					MethodName:'jsDelete',
					rowId:sterItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
}
//删除主表单据
//第一步:盘点单据是否可以删除
// 第二步删除主表单据
// 第三步删除子表数据 (包括修改打包表数据)目前的策略是:有明细不允许删除
function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
		if(data){   
			$.cm({
				ClassName:'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName:'jsDelete',
				mainRowId:mainRowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
					$('#ItemList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
}
var init = function() {
	var GridListIndex = "";
	var GridListIndexId = ""
	//上面输入框的回车事件处理
	var IsSterFinish = IfSterFinish();
	if(IsSterFinish=="N"){
		$('#SterOver').hide();
	}
	var IsMachineBindCar=IfMachineBindCar();
	//锅号
	$("#MachineNo").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#MachineNo").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetMachineNo',"sterilizer",v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'灭菌锅未启用!');
				$("#MachineNo").val("");
				$("#MachineNo").focus();
				return;
			}
			if(IsMachineBindCar=="N"){
				if(Ret.split('^')[0]=="Y"){
					$("#MachineNoValue").val(Ret.split('^')[1]);
					$("#MachineNo").val(Ret.split('^')[2]);
					$("#MachineNoSterType").val(Ret.split('^')[4]);
					$("#SterCar").focus();
					var machineNoDr=$("#MachineNoValue").val();
					var RetBat = tkMakeServerCall('web.CSSDHUI.PackageSterilize.Sterilize', 'IsPackageBat',machineNoDr);
					$("#BoiValue").val(RetBat);
					if(RetBat==0){
						$UI.msg('alert','该锅为今天第一锅，需要进行生物监测！');
					}
					if(RetBat==2){
						$UI.msg('alert','该灭菌锅未维护灭菌方式！');
						$("#MachineNo").val("");
						$("#MachineNoValue").val("");
						$("#MachineNoSterType").val("");
						$("#MachineNo").focus();
						return;
					}
					//$("#SterPro").focus();
				}else{
					$UI.msg('alert','未找到相关信息!');
					$("#MachineNo").val("");
					$("#MachineNo").focus();
				}
			}else{
				if(Ret.split('^')[0]=="Y"){
					$("#MachineNoValue").val(Ret.split('^')[1]);
					$("#MachineNo").val(Ret.split('^')[2]);
					$("#MachineNoSterType").val(Ret.split('^')[4]);
					$("#SterCarValue").val(Ret.split('^')[6]);
					$("#SterCar").val(Ret.split('^')[7]);
					$("#SterPro").focus();
					var machineNoDr=$("#MachineNoValue").val();
					var RetBat = tkMakeServerCall('web.CSSDHUI.PackageSterilize.Sterilize', 'IsPackageBat',machineNoDr);
					$("#BoiValue").val(RetBat);
					if(RetBat==0){
						$UI.msg('alert','该锅为今天第一锅，需要进行生物监测！');
					}
					if(RetBat==2){
						$UI.msg('alert','该灭菌锅未维护灭菌方式！');
						$("#MachineNo").val("");
						$("#MachineNoValue").val("");
						$("#MachineNoSterType").val("");
						$("#SterCarValue").val("");
						$("#SterCar").val("");
						$("#MachineNo").focus();
						return;
					}
					//$("#SterPro").focus();
					if($("#SterCarValue").val()==""){
						$UI.msg('alert',Ret.split('^')[2]+'灭菌锅未与灭菌车进行绑定，请先绑定！');
						$("#MachineNo").val("");
						$("#MachineNoValue").val("");
						$("#MachineNoSterType").val("");
						$("#SterCarValue").val("");
						$("#SterCar").val("");
						$("#MachineNo").focus();
						return;
					}
				}else{
					$UI.msg('alert','未找到相关信息!');
					$("#MachineNo").val("");
					$("#MachineNo").focus();
				}
			}
			
			
		}
	});
	//灭菌车
	$("#SterCar").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#SterCar").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetSterCar',6, v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'灭菌车未启用！');
				$("#SterCar").val("");
				$("#SterCar").focus();
				return;
			}
			
			var CarSterWay = Ret.split('^')[4];
			if(CarSterWay==""){
				$UI.msg('alert','该灭菌车未维护灭菌方式，请先维护！');
				$("#SterCar").val("");
				$("#SterCarValue").val("");
				$("#SterCar").focus();
				return;
			}
			var MachineNoSterType = $("#MachineNoSterType").val();
			if(CarSterWay!=MachineNoSterType){
				$UI.msg('alert','灭菌车'+Ret.split('^')[1]+'为'+Ret.split('^')[5]+',灭菌车与灭菌锅的灭菌方式不匹配！');
				$("#SterCar").val("");
				$("#SterCarValue").val("");
				$("#SterCar").focus();
			}else{
				if(Ret.split('^')[0]=="Y"){
					$("#SterPro").focus();
					$("#SterCar").val(Ret.split('^')[2]);
					$("#SterCarValue").val(Ret.split('^')[1]);
				}else{
					$UI.msg('alert','未找到相关信息!');
					$("#SterCar").val("");
					$("#SterCar").focus();
				}
			}
		}
	});
	//灭菌程序
	$("#SterPro").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#SterPro").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetSterPro',"2001",v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'灭菌程序未启用！');
				$("#SterPro").val("");
				$("#SterPro").focus();
				return;
			}
			var ProSterWay = Ret.split('^')[4];
			if(ProSterWay==""){
				$UI.msg('alert','该灭菌程序未维护灭菌方式，请先维护！');
				$("#SterPro").val("");
				$("#SterProValue").val("");
				$("#SterPro").focus();
				return;
			}
			var MachineNoSterType = $("#MachineNoSterType").val();
			if(ProSterWay!=MachineNoSterType){
				$UI.msg('alert','灭菌程序'+Ret.split('^')[6]+'为'+Ret.split('^')[5]+',灭菌程序与灭菌锅的灭菌方式不匹配！');
				$("#SterPro").val("");
				$("#SterProValue").val("");
				$("#SterPro").focus();
			}else{
				if(Ret.split('^')[0]=="Y"){
					$("#SterPro").val(Ret.split('^')[2]);
					$("#SterProValue").val(Ret.split('^')[1]);
					$("#SterUser").focus();
				}else{
					$UI.msg('alert','未找到相关程序！');
					$("#SterPro").val("");
					$("#SterPro").focus();
				}
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
				var boiValue = $("#BoiValue").val();
				if(boiValue==0){
					$UI.msg('alert','该锅为今天第一锅，需要进行生物监测！!');
					//保存主表 并且跳转到 子表扫码输入框
				}
				SaveMain();
				
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#SterUser").val("");
				$("#SterUser").focus();
			}
		}
	});
	//保存生成灭菌单据
	function SaveMain(){
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var Params = JSON.stringify(ParamsObj);
		GridListIndex = "";
		GridListIndexId = "";
		if(isEmpty(ParamsObj.SterCarValue)||isEmpty(ParamsObj.MachineNoValue)||isEmpty(ParamsObj.SterProValue)||isEmpty(ParamsObj.SterUserValue)){
			$UI.msg('alert',"请填写完整!");
			$("#MachineNo").focus();
			return  
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSave',
			Params: Params
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				var mainRowid = jsonData.rowid;
				if(!isEmpty(jsonData.rowid)){
					FindNew(jsonData.rowid);
				}
				$("#BarCode").focus();
				$("#MachineNo").val("");
				$("#MachineNoValue").val("");
				$("#MachineNoSterType").val("");
				$("#SterCarValue").val("");
				$("#SterCar").val("");
				$("#SterPro").val("");
				$("#SterUser").val("");
				
			}else{
				$UI.msg('error', jsonData.msg);
			}

		});
	}
	//确认进锅
	$UI.linkbutton('#OKBT',{ 
		onClick:function(){
			Ok();
		}
	});
	//灭菌完成
	$UI.linkbutton('#SterOver',{ 
		onClick:function(){
			SterFinish();
		}
	});
	//BDTest
	$UI.linkbutton('#BDTest',{ 
		onClick:function(){
			BD();
		}
	});
	//生物检测
	$UI.linkbutton('#BioTest',{ 
		onClick:function(){
			Bio();
		}
	});
	//重新进锅
	$UI.linkbutton('#SterRepeat',{ 
		onClick:function(){
			SterRepeatIn();
		}
	});
	function SterRepeatIn(){
		var Params =  JSON.stringify($UI.loopBlock('#MainCondition'));
		var ParamsObj =  $UI.loopBlock('#MainCondition');
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选择需要重新进锅的锅次！');
			return false;
		}
		if(row.IsCHK!="2"){
			$UI.msg('alert','只有灭菌不合格的锅次，才能重新进锅！');
			return false;
		}
		if(row.WorkStatus=="Y"){
			$UI.msg('alert','已重新进锅，不能再次重新进锅！');
			return false;
		}
		var RowIndex = MainListGrid.getRowIndex(row);
		GridListIndex = RowIndex;
		GridListIndexId = row.RowId;
		var firstMachineNoType=row.TempType;
		var machineNo = ParamsObj.MachineNo;
		var machineDr = ParamsObj.MachineNoValue;
		var machineNoType = ParamsObj.MachineNoSterType;
		if(firstMachineNoType!=machineNoType){
			$UI.msg('alert','当前锅与原锅灭菌方式不一致，请重新输入锅号！');
			return false;
		}
		if(machineNo==""){
			machineNo=row.MachineNo;
			machineDr=row.MachineNoDR;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsRepeatSave',
			Params: Params,
			MachineNo:machineNo, 
			MachineNoDr:machineDr, 
			carlbl:row.carLabel, 
			ProgressDr:row.ProgressDR, 
			RowId:row.RowId
		},function(jsonData){
			if(jsonData.success==0){
				MainListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function Ok(){
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选择需要确认进锅的灭菌锅！');
			return false;
		}
		if(row.ComplateFlag=="是"){
			$UI.msg('alert','无法重复确认进锅！');
			return;
		}
		if(row.ComplateFlag=="灭菌完成"){
			$UI.msg('alert','已灭菌完成！');
			return;
		}
		var RowIndex = MainListGrid.getRowIndex(row);
		GridListIndex = RowIndex;
		GridListIndexId = row.RowId;
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetComplete',
			MainId: row.RowId
		},function(jsonData){
			if(jsonData.success==0){
				MainListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function SterFinish(){
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选择灭菌完成的灭菌锅！');
			return false;
		}
		var RowIndex = MainListGrid.getRowIndex(row);
		GridListIndex = RowIndex;
		GridListIndexId = row.RowId;
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetFinish',
			MainId: row.RowId
		},function(jsonData){
			if(jsonData.success==0){
				MainListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function BD(){
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var Params =  JSON.stringify($UI.loopBlock('#MainCondition'));
		 if(isEmpty(ParamsObj.SterCarValue)||isEmpty(ParamsObj.MachineNoValue)||isEmpty(ParamsObj.SterProValue)||isEmpty(ParamsObj.SterUserValue)){
			$UI.msg('alert',"请填写完整!");
			$("#MachineNo").focus();
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsBDTest',
			Params: Params
		},function(jsonData){
			if(jsonData.success==0){
				if(!isEmpty(jsonData.rowid)){
					FindNew(jsonData.rowid);
				}
				$("#SterUser").val("");
				$("#SterUser").focus();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function Bio(){
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选操作数据!');
			return false;
		}
		if(row.ComplateFlag=='是'){
			$UI.msg('alert','已确认进锅无法生物监测');
			return ;
		}
		if(!isEmpty(row.BatLabel)){
			$UI.msg('alert','无法重复生物监测');
			return ;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsBioTest',
			MainId: row.RowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				MainListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	//查询锅号的下拉数据加载
	var FMachineNoBox = $HUI.combobox('#FMachineNo', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type=sterilizer',
		valueField: 'RowId',
		textField: 'Description'
	});
	//查询区域默认值设置
	var Dafult = {
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate,
		FComplateFlag: "",
		FChkFlag: "N"
	}
	//加载界面时，默认值记载
	$UI.fillBlock('#UomTB', Dafult)

	//查询
	$UI.linkbutton('#FSuerBT',{ 
		onClick:function(){
			query();
		}
	});
	function query(){ 
		$UI.clear(ItemListGrid);
		GridListIndex = "";
		GridListIndexId = "";
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll',
			parame: Params
		});
	}

	//上面输入框的回车事件处理 end
	var MainCm = [[
		{
			field:'operate',
			title:'操作',
			align:'center',
			width:80,
			formatter:function(value, row, index){
				var str = "";
				if(row.ComplateFlag=="是"){
					str = '<a href="#" name="operaM" title="删除" class="easyui-linkbutton" disabled  onclick="deleteMain('+row.RowId+')"></a>';
				}else{ 
					str = '<a href="#" name="operaM" title="删除" class="easyui-linkbutton"  onclick="deleteMain('+row.RowId+')"></a>';
				}
				return str;
			}
		},{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '锅号',
			field: 'MachineNo',
			width:60,
			fitColumns:true
		}, {
			title: '锅号Dr',
			field: 'MachineNoDR',
			width:60,
			fitColumns:true,
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
				}
			}
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
			title: '灭菌程序Dr',
			field: 'ProgressDR',
			width:100,
			fitColumns:true,
			hidden: true
		}, {
			title: '灭菌人',
			field: 'SterName',
			width:100,
			fitColumns:true
		}, {
			title: '灭菌状态',
			field: 'ComplateFlag',
			align:'center',
			width:100,
			fitColumns:true,
			styler: flagColorIn
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
		}, {
			title: 'BD检验',
			field: 'BDLabel',
			width:100,
			align:'center',
			fitColumns:true,
			styler: flagColor
		}, {
			title: '生物监测',
			field: 'BatLabel',
			align:'center',
			width:100,
			fitColumns:true,
			styler: flagColor
		}, {
			title: '验收人',
			field: 'chkame',
			width:100,
			hidden:true,
			fitColumns:true
		}, {
			title: '验收时间',
			field: 'CHKTime',
			width:100,
			fitColumns:true
		},{
			title: '温度类型',
			field: 'TempType',
			width:100,
			fitColumns:true,
			hidden: true
		}, {
			title: '灭菌车',
			field: 'carLabel',
			width:100,
			fitColumns:true
		},{
			title: '重新进锅状态',
			field: 'WorkStatus',
			width:100,
			hidden: true
		}
	]];
	var ParamsObj = $UI.loopBlock('#MainCondition');
	var Params = JSON.stringify(ParamsObj);
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll',
			parame:Params,
			FChkFlag:"N"
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		singleSelect:true,
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({plain:true,iconCls:'icon-cancel'});  
			if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0);
				var Row=MainListGrid.getSelected();
				var Id = Row.RowId;
				if(!isEmpty(Id)){
					FindItemByF(Id);
				}
			}
			if(!isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", GridListIndex);
				FindItemByF(GridListIndexId);
			}
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
				if(Row.ComplateFlag=='是'){
					$('#BarCode').attr("disabled", "disabled");
					$('#AddItemBT').linkbutton('disable');
				}
				if(Row.ComplateFlag=='否'){
					$("#BarCode").attr("disabled", false);
					$('#AddItemBT').linkbutton('enable');
				}
			}   
			MainListGrid.commonClickCell(index,filed)
		}
	})
    
//扫码动作
 $("#BarCode").keypress(function(event) {
	if ( event.which == 13 ) {
		var label=$("#BarCode").val();
		var row = $('#MainList').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择需要添加的锅次!');
			return;
		}
		if(isEmpty(row.RowId)||isEmpty(label)){
			$UI.msg('alert','参数错误!');
			return;
		}
		if(row.BDLabel=='是'){
			$UI.msg('alert','BD测试不允许添加明细!');
			return ;
		}
		$.cm({
			ClassName:'web.CSSDHUI.PackageSterilize.SterilizeItem',
			MethodName:'IsLabelBat',
			mainId:row.RowId,
			barCode:label
		},function(jsonData){
			if(jsonData==2){
				$UI.msg('alert','该消毒包内存在植入物，需要进行生物监测！');
				saveDetail(label,row);
			}else if(jsonData==1){
				$UI.msg('alert','该消毒包需要进行生物监测！');
				saveDetail(label,row);
			}else if(jsonData==0){
				saveDetail(label,row);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
		
	}
});
function flagColor(val, row, index) {
		if(val == '否' || val == '不合格'){
			return 'background:#ff584c;color:white';
		}
}
function flagColorIn(val, row, index) {
		if(val == '否'){
			return 'background:#ff584c;color:white';
		}else {
			return 'background:#15b398;color:white';
		}
}
//根据条码保存明细
function saveDetail(barcode,row){
	$.cm({
		ClassName:'web.CSSDHUI.PackageSterilize.SterilizeItem',
		MethodName:'jsSaveSterDetail',
		mainId:row.RowId,
		barCode:barcode
	},function(jsonData){
		if(jsonData.success==0){
			$UI.msg('success',jsonData.msg);
			//$("#BarCodeInfo").val(jsonData.msg)
			ItemListGrid.reload();
		}else{
			$UI.msg('error',jsonData.msg);
		}
		$("#BarCode").val("");
		$("#BarCode").focus();
	});
}

	//选取待灭菌包
	$UI.linkbutton('#AddItemBT', {
		onClick: function(){
			var row = $('#MainList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert','请选择需要灭菌的锅次!');
				return ;
			}
			if(row.ComplateFlag=="是"){
				$UI.msg('alert','该锅次已经进锅不允许添加!');
				return;
			}
			if(isEmpty(row)){
				$UI.msg('alert','请选择需要添加的锅次!');
				return;
			}
			if(isEmpty(row.RowId)){
				$UI.msg('alert','参数错误!');
				return;
			}
			var MachineNoDR=row.MachineNoDR;
			var carLabel=row.carLabel
			SelBarcode(AddItms,carLabel,MachineNoDR,"IN");
		}
	});
	function AddItms(barcodes){
		var Row = MainListGrid.getSelected();
		var MachineNoDR=Row.MachineNoDR;
		if(Row.TempType=="1"){
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName: 'GetLoadNum',
				MachineNoDR : MachineNoDR
			},function(LoadNum){
				var ExistedNum=ItemListGrid.getData().total
				if(LoadNum<barcodes.length+ExistedNum){
					$UI.msg('alert','待灭菌包数量超过该锅的装载上限');
					return;
				}else{
					$.each(barcodes, function(index, item){
						saveDetail(item.Label,Row);
					});
				}
			});
		}else{
			$.each(barcodes, function(index, item){
				saveDetail(item.Label,Row);
			});
		}
	};
	var ItemCm = [[
        {	field:'operate',
			title:'操作',
			align:'center',
			width:80,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				var str ="";
				if(rowMain.ComplateFlag=="是"){
					str = '<a href="#" name="opera"  title="删除" class="hisui-tooltip easyui-linkbutton" disabled  onclick="deleteItem('+row.RowId+')"></a>';
				}else{
					str = '<a href="#" name="opera"  title="删除" class="hisui-tooltip easyui-linkbutton"   onclick="deleteItem('+row.RowId+')"></a>';
				}
				return str;
			}
		},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '条码',
			field: 'Label',
			width:170
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:160
		},{
			title: '数量',
			field: 'Qty',
			width:60,
			align:'right'
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			MethodName: 'SelectByF'
		},
		toolbar: '#IpuntTB',
		columns: ItemCm,
		pagination:false,
		singleSelect:false,
		onLoadSuccess:function(data){  
			$("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
		}
	});

	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectByF',
			SterId:Id
		});
	}
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
		QueryName: 'FindNew',
		ID:Id
		});
	}
	var Default = function() {
		
		$('#MachineNo').focus();
	}
	Default();
}
$(init);
