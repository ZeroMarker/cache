//页面Event
function InitEnviHyLocItemsWinEvent(obj){
	//弹窗初始化
	$('#winEvLocItems').dialog({
		title: '科室监测项目计划编辑',
		iconCls:'icon-w-paper',
		headerCls:'panel-header-gray',
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	
	obj.LoadEvent = function(args){
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPcEntity').close();
     	});
		
		//保存子类
		$('#btnSubSave').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
		//关闭子类
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winEvLocItems').close();
     	});
		//删除子类
     	$('#btnSubDelete').on('click', function(){
			if(!obj.RecRowID1)  return;
	     	obj.btnDeleteSub_click();
     	});
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if(!obj.RecRowID1)return;
	     	var rd=obj.gridEvLocItems.getSelected();
			obj.layer2(rd);		
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
			if(!obj.RecRowID1)return;
			var rd=obj.gridEHLocation.getSelected();
			obj.layer1(rd);	
     	});
    }
    
    //前台保存数据
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});
	
	//选择科室
    obj.gridEHLocation_onSelect = function (){
	    var rowData = obj.gridEHLocation.getSelected();	 
	    if (rowData["ID"] == obj.RecRowID1){
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
		    obj.gridEHLocation.clearSelections();  //清除选中行
		}else {
			$("#btnSubAdd").linkbutton("enable");
			obj.RecRowID1 = rowData["ID"];
			obj.EvLocItemsLoad();  //加载子分类
		}
	}
    
    //选择科室监测项目计划
    obj.gridEvLocItems_onSelect = function (){
	    if(!obj.RecRowID1)return;
	    if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
	    var rowData = obj.gridEvLocItems.getSelected();
	    if (rowData["LoID"] == obj.RecRowID2){
		    $("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
		    obj.gridEvLocItems.clearSelections();  //清除选中行
		}else {
			obj.RecRowID2 = rowData["LoID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");
		 }
	}
	
	
	
	//双击编辑事件
	obj.gridEvLocItems_onDbselect = function(rowData){
		if(!obj.RecRowID1){
			$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
			return;
		}
		obj.layer2(rowData);
	}
	
	//保存
	obj.btnSaveSub_click = function(){
		var errinfo = "";
		var LocationID 	= obj.RecRowID1;
		var ItemID     	= $('#cboItem').combobox('getValue');
		var txtItemMax  = $('#txtItemMax').val();
		var txtItemMin  = $('#txtItemMin').val();
		var ItemUnitID 	= $('#cboItemUnit').combobox('getValue');
		var PlanDate 	= $('#PlanDate').datebox('getValue');
		var txtNote  	= $('#txtNote').val();
		var IsActive    = $("#chkActive").checkbox('getValue')? '1':'0';
		if (!ItemID) {
			errinfo = errinfo + "监测项目为空!<br>";
		}
		if (!ItemUnitID) {
			errinfo = errinfo + "限定单位为空!<br>";
		}
		if (!PlanDate) {
			errinfo = errinfo + "计划安排日期为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
			
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + "^" + LocationID;
		inputStr = inputStr + "^" +	ItemID;
		inputStr = inputStr + "^" + txtItemMax;
		inputStr = inputStr + "^" + txtItemMin;
		inputStr = inputStr + "^" + ItemUnitID;
		inputStr = inputStr + "^" + PlanDate;
		inputStr = inputStr + "^" + txtNote;
		inputStr = inputStr + "^" + IsActive;
		var flg = $m({
			ClassName:"DHCHAI.IR.EnviHyLocItems",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if (parseInt(flg) == 0){
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else{
			$HUI.dialog('#winEvLocItems').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridEvLocItems.reload() ;//刷新当前页
		}
	}
	
	//删除
	obj.btnDeleteSub_click = function(){
		var rowData = obj.gridEvLocItems.getSelected();
		var rowDataID = rowData["LoID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
					ClassName:"DHCHAI.IR.EnviHyLocItems",
					MethodName:"DeleteById",
					Id:rowDataID
				},false);
				if(parseInt(flg) < 0){
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = ""
					obj.gridEvLocItems.reload() ;//刷新当前页
				}
			}
		});
	}
	
	//加载子表
	obj.EvLocItemsLoad = function () {
		obj.gridEvLocItems.load({
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			QueryName:"QryEnviHyLocItems",
			locId:obj.RecRowID1
		});	
	}
	
	//配置窗体-初始化
	obj.layer2 = function(rowData){
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定申请科室",'info');
			return;
		}	
		if(rowData){
			obj.RecRowID2=rowData["LoID"];
			var ApplyLocID = rowData["ApplyLocID"];
			var ApplyLocDesc  = rowData["ApplyLocDesc"];
			var EvItemID = rowData["EvItemID"];
			var EHItemMax = rowData["EHItemMax"];
			var EHItemMin = rowData["EHItemMin"];
			var EHItemUnitID = rowData["EHItemUnitID"];
			var EHItemUnitDesc = rowData["EHItemUnitDesc"];
			var EHPlanDate = rowData["EHPlanDate"];
			var EHNote = rowData["EHNote"];
			var IsActiveDesc = rowData["IsActiveDesc"];
			IsActiveDesc = (IsActiveDesc=="是"? true: false)
			//$('#cboLocation').combobox('setValue',ApplyLocID);
			$('#cboLocation').val(ApplyLocDesc);
			//ApplyLocDesc=Common_LookupToLoc('cboLocation','cboLocationID','1|2','O|I','');
			$('#cboItem').combobox('setValue',EvItemID);
			$('#txtItemMax').val(EHItemMax);
			$('#txtItemMin').val(EHItemMin);
			$('#cboItemUnit').combobox('setValue',EHItemUnitID);
			$('#cboItemUnit').combobox('setText',EHItemUnitDesc);
			$('#PlanDate').datebox('setValue',EHPlanDate);
			$('#txtNote').val(EHNote);
			$('#chkActive').checkbox('setValue',IsActiveDesc);
		}
		$HUI.dialog('#winEvLocItems').open();
	}
		
	//配置窗体-初始化
	obj.layer1 = function(rowData){
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定申请科室",'info');
			return;
		}	
		if(rowData){
			obj.RecRowID2 ="";
			var ApplyLocDesc  = rowData["LocDesc2"];
			$('#cboLocation').val(ApplyLocDesc);
			//ApplyLocDesc=Common_LookupToLoc('cboLocation','cboLocationID','1|2','O|I','');
			//$('#cboLocation').combobox('setValue','');
			$('#cboItem').combobox('setValue','');
			$('#txtItemMax').val('');
			$('#txtItemMin').val('');
			$('#cboItemUnit').combobox('setValue','');
			$('#PlanDate').datebox('setValue','');
			$('#txtNote').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winEvLocItems').open();
	}
	
	//查询
	$('#search').searchbox({
		searcher:function(){
			var locDesc = ($('#search').searchbox('getValue'))
			obj.reloadgridEHLocation(locDesc);//重新加载表格数据
		}
	});
		
	obj.reloadgridEHLocation = function(locDesc){
		var ApplyLocDesc = locDesc;
		$('#gridEHLocation').datagrid('load', {
			ClassName:'DHCHAI.IRS.EnviHyLocItemsSrv',
			QueryName:"QryLoc",
			aHospIDs : $.LOGON.HOSPID,
			aLocCate : "",
			aLocType : "",
			aIsActive: 1,
			locDesc:ApplyLocDesc
		});		
	};
}