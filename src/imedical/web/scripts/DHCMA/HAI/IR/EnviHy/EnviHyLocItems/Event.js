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
	//弹窗初始化
	$('#winEvLocItems2').dialog({
		title: '科室监测项目计划编辑',
		iconCls:'icon-w-paper',
		headerCls:'panel-header-gray',
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	//tab页签切换
	$HUI.tabs("#Maintabs", {
		onSelect: function (title,index){
			var tab=$("#Maintabs").tabs('getSelected');
			var ContentID=tab[0].id;
			obj.TabArgsID = ContentID;
			obj.RecRowID1="";
		}
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
			if((!obj.RecRowID1)&&(!obj.RecRowID3))  return;
	     	obj.btnDeleteSub_click();
     	});
     	
     	//保存子类
		$('#btnSubSave2').on('click', function(){
	     	obj.btnSaveSub2_click();
     	});
		//关闭子类
		$('#btnSubClose2').on('click', function(){
	     	$HUI.dialog('#winEvLocItems2').close();
     	});
     	
     	
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if ((!obj.RecRowID1)&&((!obj.RecRowID3)))return;
	     	var rd=obj.gridEvLocItems.getSelected();
			obj.layer2(rd);		
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
	     	if (obj.TabArgsID == "EHLoc"){
				if(!obj.RecRowID1)return;
				var rd=obj.gridEHLocation.getSelected();
				$("#TRUnit").css('display','none');
				obj.layer1(rd);	
	     	}
	     	if (obj.TabArgsID == "EHItem"){
				if(!obj.RecRowID3)return;
				var rd=obj.gridEHItem.getSelected();
				$("#TRUnit").css('display','none');
				obj.layer3(rd);	
	     	}
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
	
	//选择项目
    obj.gridEHItem_onSelect = function (){
	    var rowData = obj.gridEHItem.getSelected();	
	    if (rowData["ID"] == obj.RecRowID3){
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID3="";
		    obj.gridEHItem.clearSelections();  //清除选中行
		}else {
			$("#btnSubAdd").linkbutton("enable");
			obj.RecRowID3 = rowData["ID"];
			obj.EvLocItemsLoad();  //加载子分类
		}
	}
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
	    if((!obj.RecRowID1)&&(!obj.RecRowID3)) return;
	    if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
	    var rowData = obj.gridEvLocItems.getSelected();
	    if (rowData["IDList"] == obj.RecRowID2){
		    $("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
		    obj.gridEvLocItems.clearSelections();  //清除选中行
		}else {
			obj.RecRowID2 = rowData["IDList"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");
		 }
	}
	
	//双击编辑事件
	obj.gridEvLocItems_onDbselect = function(rowData){
		if ((!obj.RecRowID1)&&(!obj.RecRowID3)){
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
		var DateItemArr = $('#cboDateItem').combobox('getValues');
        var DateItemIDs = DateItemArr.join();
		var txtNote  	= $('#txtNote').val();
		var IsActive    = $("#chkActive").checkbox('getValue')? '1':'0';
		if (!ItemID) {
			errinfo = errinfo + "监测项目为空!<br>";
		}
		if (!txtItemMax) {
			errinfo = errinfo + "计划监测数量为空!<br>";
		}
		if (!DateItemIDs) {
			errinfo = errinfo + "监测计划为空!<br>";
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
		inputStr = inputStr + "^" + DateItemIDs;
		inputStr = inputStr + "^" + txtNote;
		inputStr = inputStr + "^" + IsActive;
		var flg = $m({
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			MethodName:"SaveLocItems",
			inputStr:inputStr,
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
	
	//保存
	obj.btnSaveSub2_click = function(){
		var errinfo = "";
		var ItemID 	= obj.RecRowID3;
		var txtItemMax  = $('#txtItemMax2').val();
		var txtItemMin  = $('#txtItemMin2').val();
		var DateItemArr = $('#cboDateItem2').combobox('getValues');
        var DateItemIDs = DateItemArr.join();
        var SubLocArr   = $('#cboLocation2').combobox('getValues');
        var aSubLocIDs  = SubLocArr.join();
		var txtNote  	= $('#txtNote2').val();
		var IsActive    = $("#chkActive2").checkbox('getValue')? '1':'0';
		if (!aSubLocIDs) {
			errinfo = errinfo + "申请科室为空!<br>";
		}
		if (!DateItemIDs) {
			errinfo = errinfo + "监测计划为空!<br>";
		}
		if (!txtItemMax) {
			errinfo = errinfo + "计划监测数量为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if	(aSubLocIDs.substr(0,1)!=','){
			aSubLocIDs=','+aSubLocIDs;
		}	
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + "^" + aSubLocIDs;
		inputStr = inputStr + "^" +	ItemID;
		inputStr = inputStr + "^" + txtItemMax;
		inputStr = inputStr + "^" + txtItemMin;
		inputStr = inputStr + "^" + DateItemIDs;
		inputStr = inputStr + "^" + txtNote;
		inputStr = inputStr + "^" + IsActive;
		var flg = $m({
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			MethodName:"SaveLocItemsByItem",
			inputStr:inputStr,
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
			$HUI.dialog('#winEvLocItems2').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridEvLocItems.reload() ;//刷新当前页
		}
	}
	
	//删除
	obj.btnDeleteSub_click = function(){
		var rowData = obj.gridEvLocItems.getSelected();
		var rowDataIDs = rowData["IDList"];
		if (((obj.RecRowID1=="")&&(obj.RecRowID3==""))||(rowDataIDs=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
					ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
					MethodName:"DeleteLocItems",
					aLocItemIDs:rowDataIDs
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
		if (obj.TabArgsID == "EHLoc"){
			obj.gridEvLocItems.load({
				ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
				QueryName:"QryEnviHyLocItems",
				locId:obj.RecRowID1
			});	
		}else{
			obj.gridEvLocItems.load({
				ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
				QueryName:"QryEnviHyLocItems",
				locId:"",
				ItemID:obj.RecRowID3
			});	
		}
		
	}
	
	//配置窗体-初始化
	obj.layer2 = function(rowData){
		if ((!obj.RecRowID1)&&(!obj.RecRowID3)){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定左边项目",'info');
			return;
		}
		$('#cboDateItem').combobox('clear');
		$("#TRUnit").css('display','table-row');
		if (obj.TabArgsID == "EHLoc"){
			if(rowData){
				obj.RecRowID2=rowData["IDList"];
				var ApplyLocID = rowData["ApplyLocID"];
				var ApplyLocDesc  = rowData["ApplyLocDesc"];
				var EvItemID = rowData["EvItemID"];
				var EHItemMax = rowData["EHItemMax"];
				var EHItemMin = rowData["EHItemMin"];
				var EHNote = rowData["EHNote"];
				var DescIDList= rowData["DescIDList"];
				var IsActiveDesc = rowData["IsActiveDesc"];
				IsActiveDesc = (IsActiveDesc=="是"? true: false)
				$('#cboLocation').val(ApplyLocDesc);
				$('#cboItem').combobox('setValue',EvItemID);
				$('#cboItem').validatebox("validate");
				$('#txtItemMax').val(EHItemMax).validatebox("validate");;
				$('#txtItemMin').val(EHItemMin);
				$('#txtNote').val(EHNote);
				$('#chkActive').checkbox('setValue',IsActiveDesc);
				$('#cboDateItem').combobox('setValues',DescIDList.split(","));
			}
			$HUI.dialog('#winEvLocItems').open();
		}else{
			if(rowData){
				obj.RecRowID2=rowData["IDList"];
				var ApplyLocID = rowData["ApplyLocID"];
				var ApplyLocDesc  = rowData["ApplyLocDesc"];
				var EvItemDesc = rowData["EvItemDesc"];
				var EHItemMax = rowData["EHItemMax"];
				var EHItemMin = rowData["EHItemMin"];
				var EHNote = rowData["EHNote"];
				var DescIDList= rowData["DescIDList"];
				var IsActiveDesc = rowData["IsActiveDesc"];
				IsActiveDesc = (IsActiveDesc=="是"? true: false);
				
				$('#cboItem2').val(EvItemDesc);
				$('#cboLocation2').combobox('setValues',ApplyLocID.split(","));
				$('#cboLocation2').validatebox("validate");
				$('#txtItemMax2').val(EHItemMax).validatebox("validate");;
				$('#txtItemMin2').val(EHItemMin);
				$('#txtNote2').val(EHNote);
				$('#chkActive2').checkbox('setValue',IsActiveDesc);
				$('#cboDateItem2').combobox('setValues',DescIDList.split(","));
				$('#cboDateItem2').validatebox("validate");
			}
			$HUI.dialog('#winEvLocItems2').open();
		}
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
			$('#cboItem').combobox('setValue','');
			$('#cboItem').validatebox("validate");
			$('#txtItemMax').val('').validatebox("validate");
			$('#txtItemMin').val('');
			$('#cboDateItem').combobox('setValue','');
			$('#cboDateItem').validatebox("validate");
			$('#txtNote').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winEvLocItems').open();
	}
	//配置窗体-初始化
	obj.layer3 = function(rowData){
		if(!obj.RecRowID3){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定监测项目",'info');
			return;
		}
		if(rowData){
			obj.RecRowID2 ="";
			var ItemDesc  = rowData["ItemDesc"];
			$('#cboItem2').val(ItemDesc);
			$('#txtItemMax2').val('').validatebox("validate");
			$('#txtItemMin2').val('');
			$('#cboLocation2').combobox('setValue','');
			$('#cboLocation2').validatebox("validate");
			$('#cboDateItem2').combobox('setValue','');
			$('#cboDateItem2').validatebox("validate");
			$('#txtNote2').val('');
			$('#chkActive2').checkbox('setValue',false);
		}
		$HUI.dialog('#winEvLocItems2').open();
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
			locDesc:ApplyLocDesc,
			page:1,
			rows:9999
		});		
	};
	//查询
	$('#search1').searchbox({
		searcher:function(){
			var ItemDesc = ($('#search1').searchbox('getValue'))
			obj.reloadgridEHItem(ItemDesc);//重新加载表格数据
		}
	});	
	obj.reloadgridEHItem = function(ItemDesc){
		$('#gridEHItem').datagrid('load', {
			ClassName:'DHCHAI.IRS.EnviHyItemSrv',
			QueryName:"QryEvItem",
			aIsActive : 1,
			aAlis : ItemDesc,
			page:1,
			rows:9999
		});		
	};
}