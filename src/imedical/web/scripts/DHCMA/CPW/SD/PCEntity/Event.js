//页面Event
function InitWinEvent(obj){
	
	$('#winPcEntity').dialog({
		title: '付费病种维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});

	$('#winPcEntityItem').dialog({
		title: '病种项目维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	//初始化-明细弹出框
	obj.DiaLog_three = $('#DiaLog_three').dialog({
		title: '服务价格明细',
		iconCls:"icon-w-paper",
		width: 460,
		height: 320,
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.saveToSrv();
				$('#DiaLog_three').window("close");
			}
		},{
			text:'关闭',
			handler:function(){
				$('#DiaLog_three').window("close");
			}
		}],
		onBeforeOpen:function(){
			obj.editIndex=undefined;
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
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer1();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPcEntity.getSelected()
			obj.layer1(rd);	
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
		//保存子类
		$('#btnSubSave').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
		//关闭子类
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winPcEntityItem').close();
     	});
		//删除子类
     	$('#btnSubDelete').on('click', function(){
			if(!obj.RecRowID1)  return;
	     	obj.btnDeleteSub_click();
     	});
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if(!obj.RecRowID1)return;
	     	var rd=obj.gridPcEntityItem.getSelected();
			obj.layer2(rd);		
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
			if(!obj.RecRowID1)return;
			obj.layer2();	
     	});
		//删除按钮
		$('#btnDel_three').on('click', function(){
	     	obj.btnDel_three_click();
     	});
		//添加服务价格按钮
		$('#btnAdd_three').on('click', function(){
	     	obj.btnAdd_three_click();
     	});
     }
	//添加服务价格按钮
	obj.btnAdd_three_click = function(){
		if (endEditing()){
			$('#gridPriceMast').datagrid('appendRow',{
				index: 1,   // 索引从0开始
			});
			obj.editIndex = $('#gridPriceMast').datagrid('getRows').length-1;
			$('#gridPriceMast').datagrid('selectRow', obj.editIndex).datagrid('beginEdit', obj.editIndex);
		}
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
	//保存服务价格          
	obj.saveToSrv = function(){
		if (endEditing()){
			$('#gridPriceMast').datagrid('acceptChanges');      //保存之前结束编辑操作
		}
		var rows = $('#gridPriceMast').datagrid('getRows');
		var gridPcEntityItem = $("#gridPcEntityItem").datagrid('getSelected');   //取不到值
		var RowIndex1 = gridPcEntityItem["BTRowID"];
		for(var i = 0; i < rows.length; i ++)
		{
			var RowData = rows[i];
			var PriceCode = "";
			var PriceDesc = "";
			var RowID = RowData.ID;
			var RowIndex2 = "";
			if(RowID!=null){                                //保存旧行
				RowIndex2 = RowID.split("||")[2];
				PriceCode = RowData.BTPriceCode;
				PriceDesc = RowData.BTPriceDesc;
			}else{                                          //保存新行
				var newData = $("#gridPriceMast").datagrid('getSelected');
				PriceCode = newData["BTPriceCode"];
			}
			var inputStr = "";
			inputStr = inputStr + RowIndex1;
			inputStr = inputStr + "^" + RowIndex2;
			inputStr = inputStr + "^" + PriceCode;
			var flg = $m({
				ClassName:"DHCMA.CPW.SD.PCEntityPrice",
				MethodName:"Update",
				aInputStr:inputStr
			},false);
		}
		if (parseInt(flg) <= 0) {
				if (parseInt(flg) == -100) {
					$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
				} else {
					$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				}
				return;
		}else {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				//obj.ClearFormItem1();
				obj.gridPriceMast.reload();//刷新当前页
				obj.gridPcEntityItem.reload();//刷新当前页
				$HUI.dialog('#DiaLog_three').close();
		}
		
	}
	
	
	//双击修改
	obj.editHandler = function(index){
		if (obj.editIndex!=index) {
			if (endEditing()){
				$('#gridPriceMast').datagrid('selectRow', index).datagrid('beginEdit',index);
				obj.editIndex = index;
			} else {
				$('#gridPriceMast').datagrid('selectRow', obj.editIndex);
			}
		}
	}
	//关闭行编辑
	function endEditing(){
		if (obj.editIndex == undefined){
			
			return true;
		}
		if ($('#gridPriceMast').datagrid('validateRow', obj.editIndex)){
			
			var ed = $('#gridPriceMast').datagrid('getEditor', {index:obj.editIndex,field:'BTPriceCode'});
			var BTPriceDesc = $(ed.target).combobox('getText');
			$('#gridPriceMast').datagrid('getRows')[obj.editIndex]['BTPriceDesc'] = BTPriceDesc;
			$('#gridPriceMast').datagrid('endEdit', obj.editIndex);
			obj.editIndex = undefined;
			return true;
		} else {
			
			return false;
		}
	}
	//弹出框中删除按钮
	obj.btnDel_three_click = function(){
		var RowData2 = $("#gridPriceMast").datagrid('getSelected');
		if(!RowData2){
			$.messager.alert("提示","请选择一行进行再删除!");
			return;
		}
		$.messager.confirm('选择框','确定删除此记录?',function(r){
			if (r)
			{
				var flg = $cm({
					ClassName:"DHCMA.CPW.SD.PCEntityPrice",
					MethodName:"DeleteById",
					aId:RowData2.ID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg) == -100) {
						$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
					} else {
						$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
					}
					return;
				}else {
					$.messager.alert("提示","删除成功!");
					obj.gridPriceMast.reload();//刷新当前页
					obj.gridPcEntityItem.reload();//刷新当前页
					$HUI.dialog('#DiaLog_three').close();
				}
				
			}
		});	
	};
	//选择病种
	obj.gridPcEntity_onSelect = function(){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowData = obj.gridPcEntity.getSelected();
	
		if (rowData["BTID"] == obj.RecRowID1) {

			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
			//obj.PathTCMExtLoad();
			obj.gridPcEntity.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.PcEntityItemLoad();  //加载子分类	
		}
	}	
	//双击编辑事件 父表
	obj.gridPcEntity_onDbselect = function(rd){
		obj.layer1(rd);	
	}
	//选择子项
    obj.gridPcEntityItem_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1)return;
		if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowData = obj.gridPcEntityItem.getSelected();
		if (rowData["BTRowID"] == obj.RecRowID2) {
			$("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
			obj.gridPcEntityItem.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["BTRowID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");	
		}
	}
    //双击编辑事件 子表
	obj.gridPcEntityItem_onDbSelect = function(rd){
		if($("#btnEdit").hasClass("l-btn-disabled")){
		$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
		return;
		}
		if(!obj.RecRowID1) return;
		
		obj.layer2(rd);	
	}
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var IndNo = $('#txtIndNo').val();
		var IsActive = $('#chkIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var Diagnos = $('#txtDiagnos').val();
		var ICD10 = $('#txtICD10').val();
		var Operation = $('#txtOperation').val();
		var ICD9CM = $('#txtICD9CM').val();
		var ReferCost = $('#txtReferCost').val();
		var WarningCost = $('#txtWarningCost').val();
		var HospitalDays = $('#txtHospitalDays').val();
		var IntervalDays = $('#txtIntervalDays').val();
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + IndNo;
		inputStr = inputStr + "^" + Diagnos;
		inputStr = inputStr + "^" + ICD10;
		inputStr = inputStr + "^" + Operation;
		inputStr = inputStr + "^" + ICD9CM;
		inputStr = inputStr + "^" + ReferCost;
		inputStr = inputStr + "^" + WarningCost;
		inputStr = inputStr + "^" + HospitalDays;
		inputStr = inputStr + "^" + IntervalDays;
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.PCEntity",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		alert(flg);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1=flg;
			obj.gridPcEntity.reload() ;//刷新当前页
			$HUI.dialog('#winPcEntity').close();
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridPcEntity.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.PCEntity",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1="";
					obj.gridPcEntityItem.reload();//刷新当前
					obj.gridPcEntity.reload() ;//刷新当前页	
				}
			} 
		});
	}
	//保存子类
	obj.btnSaveSub_click =  function(){
		var errinfo = "";	
		var inputStr= ""
		var Desc = $('#txtItemDesc').val();
		var CatCode = $('#txtEntityCat').combobox('getValue');
		var EpisCode = $('#txtEntityEpis').combobox('getValue');
		var IndNo = $('#txtItemIndNo').val();
		var IsActive = $('#chkITemActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if(obj.RecRowID2){
		var str=obj.RecRowID2.split('||');
			inputStr = str[0] +"^" + str[1] 
		}else{
			inputStr = obj.RecRowID1 +"^" + "" 
		}
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + CatCode;
		inputStr = inputStr + "^" + EpisCode;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + IndNo;
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.PCEntityItem",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		//console.log((parseInt(flg)<=0)+flg+inputStr);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!", 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 =flg
			obj.gridPcEntityItem.reload() ;//刷新当前页
			$HUI.dialog('#winPcEntityItem').open();
		}
	}
	//删除子分类
	obj.btnDeleteSub_click = function(){
		var rowData = obj.gridPcEntityItem.getSelected();
		var rowDataID =rowData["BTRowID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				 var flg = $m({
					ClassName:"DHCMA.CPW.SD.PCEntityItem",
					MethodName:"DeleteById",
					aId:rowDataID
				},false);		
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2="";
					obj.gridPcEntityItem.reload() ;//刷新当前页		
				}							
			}
		});

	}
	//加载子表
	obj.PcEntityItemLoad = function () {
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridPcEntityItem.load({
			ClassName:"DHCMA.CPW.SDS.PCEntityItemSrv",
			QueryName:"QryPCEntityItem",
			aParRef:ParRef
		});	
	}
	//配置窗体-初始化
	obj.layer1= function(rd){
		if(rd){
			obj.RecRowID1=rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var IndNo = rd["BTIndNo"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="是"? true: false);
			var Diagnos = rd["BTDiagnos"];
			var Operation = rd["BTOperation"];
			var ICD10 = rd["BTICD10"];
			var ICD9CM = rd["BTICD9CM"];
			var ReferCost = rd["BTReferCost"];
			var WarningCost = rd["BTWarningCost"];
			var HospitalDays = rd["BTHospitalDays"];
			var IntervalDays = rd["BTIntervalDays"];
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtIndNo').val(IndNo);
			$('#chkIsActive').checkbox('setValue',IsActive);

			$('#txtDiagnos').val(Diagnos);
			$('#txtOperation').val(Operation);
			$('#txtICD10').val(ICD10);
			$('#txtICD9CM').val(ICD9CM);
			$('#txtReferCost').val(ReferCost);
			$('#txtWarningCost').val(WarningCost);
			$('#txtHospitalDays').val(HospitalDays);
			$('#txtIntervalDays').val(IntervalDays);
		}else{
			obj.RecRowID1="";
			
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtIndNo').val('');
			$('#chkIsActive').checkbox('setValue',false);
			$('#txtDiagnos').val('');
			$('#txtOperation').val('');
			$('#txtICD10').val('');
			$('#txtICD9CM').val('');
			$('#txtReferCost').val('');
			$('#txtWarningCost').val('');
			$('#txtHospitalDays').val('');
			$('#txtIntervalDays').val('');
		}
		$HUI.dialog('#winPcEntity').open();
	}
    //配置窗体-初始化
	obj.layer2= function(rd){
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定中药方剂",'info');
			return;
		}	
		if(rd){
			obj.RecRowID2 =rd["BTRowID"];
			var Desc = rd["BTDesc"];
			var CatCode = rd["BTCatCode"];
			var EpisCode = rd["BTEpisCode"];
			var ID = rd["BTRowID"];
			var IndNo = rd["BTIndNo"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=='是'? true: false);
			
			$('#txtItemDesc').val(Desc);
			$('#txtEntityCat').combobox('setValue',CatCode);
			$('#txtEntityEpis').combobox('setValue',EpisCode);
			$('#txtItemIndNo').val(IndNo);
			$('#chkITemActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2 ="";
			$('#txtItemDesc').val('');
			$('#txtEntityCat').combobox('setValue','');
			$('#txtEntityEpis').combobox('setValue','');
			$('#txtItemIndNo').val('');
			$('#chkITemActive').checkbox('setValue',false);	
		}
		$HUI.dialog('#winPcEntityItem').open();
	}			
}